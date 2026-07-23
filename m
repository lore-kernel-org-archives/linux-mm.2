Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F813C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7250B6B007B; Thu, 23 Jul 2026 13:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D54B6B008A; Thu, 23 Jul 2026 13:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59EF56B008C; Thu, 23 Jul 2026 13:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26D226B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:07:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DAEE160576
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:07:12 +0000 (UTC)
X-FDA: 85020671904.04.0CEF775
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 62815120014
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:07:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=e7+Vhubt;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784826430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6nTISuiCBMBC/x5bhGnScXYmL0t1DEe+uFhjm9NEqZI=;
	b=CeOVC198jjkEDg/3UcEvp+LYUvt4lToJ2/GU1uAr7MlH1U2g1vZIcvb5Hy0QPkn3J5uXqC
	+WYAEXRXc+togbegCvRu8qDIAodgHH3pez+2cN4BsXcBe7ry1BQXPXvCHd246YyLIvL1bP
	gmb2gcVf7oKCNZbDMQIvd8aT91tWb6A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=e7+Vhubt;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784826430;
	b=kJjIENh9x8O8LkDNsVFJByJbn+Bh1a4muaxN4I5CAmMraYhnTUQrjMWYB56JAN8UgT85Tx
	n4ROiSQoTb2i1mCpYbFrH2Pe0psvc+IbVSsbaBL9AYSpLzlvYVPEwqXW6nwAap237r3/9B
	ygw7nQwYsJn2MAnDayMWx2k6XEF8yAU=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8f256eaedf8so11481966d6.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784826429; x=1785431229; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6nTISuiCBMBC/x5bhGnScXYmL0t1DEe+uFhjm9NEqZI=;
        b=e7+VhubtFaz1hXoBtJiH7F1cH+RcTvDaL4FXYWPvkO9fakIz/H63LKAqtkMmm9hMvw
         9RuEiUUDuoJ5B0xCM3RrNktndPuIt1pODO56GFShFI3NPAsZepVsCU2pRFESqyaQ7zeV
         5B5+GBii54uCeOzR3/uSCAO9k6QFCS0KfPdCimJy7P0dGEDOHWbiEDrZwWVFpLnNNd7A
         OAR4TjrLuALzdRbGbQX/5jKqzfkQaByva2d99q6DhW8auhF80W4MPAcc2gB5UumT9xxT
         CEtrcNlYhfgxxxURwZjgKFACusinYDme8f8uquu3J2JF+RDSyqvZohi3VN0wS4/zP63V
         7JZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826429; x=1785431229;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6nTISuiCBMBC/x5bhGnScXYmL0t1DEe+uFhjm9NEqZI=;
        b=XaZCMBUU5dL+nLjvfa1hIx2joknHHDwE7WpL9FRtccM+pCltfsof7A+pXoGpEGjb46
         HcBz6i/JpbRhPoCOzusgYZG4FNUcN+skg4Y90XV3CPVaWXGYYq11kRx00CYw57LoVpmn
         v4NTlON8IKMKhJqNC47HejE0Wo4GNzKF9eFRkky9/ZhFDbDubWMSuIfbgSKF+DhdGHMi
         qNgY33hZ8DoXo3L87DzyY4xppiVMT/tb9Zj9qBU44G2BPDzkMGm7JaQY4nrqG9UCwFgj
         M853ASdPcLqAiUAvAgnyLfnOTx8Zx48fjDHFP1yW+bu/7903e0c3LQY6sSMpfOC3XSOS
         2YaA==
X-Forwarded-Encrypted: i=1; AHgh+RoiOM5DRSuHvlCGysIC8wX3Gu7zanFtuyGPpnnok3QDamZDRyZOmbRnjzU+p008pCM9sP7sf220Eg==@kvack.org
X-Gm-Message-State: AOJu0YwMTp0HFAGVXc6ovYXK2kPqBZQ0+K8Xq5g3IKtqfII5lNLZNtUo
	wbEUWhp14BMymQBpqWBrhYpwz12Jo4ECcBiwOc3D4UAWSdB/rf1RzJ+2s9ozB0FMHridlTKDlYK
	bwJj2
X-Gm-Gg: AR+sD129DHps5qS0c+AxVnUt8tQPI9esR5ae0J4nKN3WAU9xFY3g8t68OAEwmvVCryl
	8/eFXkgvFjFrqlf/GR44gXHsh33kRLhciglAiYpyoBexTMYQfWBthl3Cd/6XbeE4PxqjVcYg5iR
	pJQauCsS4aiPTZ0gaWirq4zxwcxeGGoYH0c4iJDUdBkME+2JGL7Krgj//btQTtMbbcSaGxtibuX
	BZnMX2EWZ6A8mZvIE4lbLHDHsXhxFvvzvibghjxNOt6mFuNaDfbRbuyBYLz995qa5BpRfnFgggm
	HwoOMtdcbrRlMkj6oXAlWmSCkToc61NQoxSwK8qGE3yx52xuKLQEclo3jWV3lrZ8iuvMgtiMsS1
	gdznxeabYKHWi7zBMWggaTMUCM1qwkA2GO+wIxrmN+4CMlKgHwFn1ErLTTWaHjJ1lAqGlv2CZb+
	Ve
X-Received: by 2002:a05:6214:5d0a:b0:8f1:579e:a41b with SMTP id 6a1803df08f44-907ca295150mr42984396d6.24.1784826429087;
        Thu, 23 Jul 2026 10:07:09 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8f2a8bsm48949526d6.20.2026.07.23.10.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:07:07 -0700 (PDT)
Date: Thu, 23 Jul 2026 13:07:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Gregory Price <gourry@gourry.net>
Cc: Sean Christopherson <seanjc@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>,
	kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
	vishal.l.verma@intel.com
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <amJKOPczNMb96NJv@cmpxchg.org>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
 <amIcXrS7nGX-adpG@google.com>
 <amIrDncrL4K-JRBO@cmpxchg.org>
 <amIxyy4Vg_TTE8Y4@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amIxyy4Vg_TTE8Y4@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62815120014
X-Stat-Signature: 34kxk9jpyhpr11hhuzhwdaonmp5aefkq
X-HE-Tag: 1784826430-884658
X-HE-Meta: U2FsdGVkX1/E7ThJlO9HsWTiemAI/du3l4jF1Oa96FhvMMeMFQgixfOGDCcecJlUpY5RdJNk8bzrOLgRiJDXKOnhdhVQkRDCryUA7Vo9iTBjr2k5nk9oyFdhkiNhZl37EtTmhaqw471x89M1mok+CKrsUy/2GaP9TpqEII5zlMdddmq4dgkK5A3n3dETtbttCGeaDfFp4tkp2YlYoENvj8Cjk8fyezp0ji9xICM6SorS082bhoI4Qt3vFNZuLlxjjDmGNp7ev91x5fY4tHyAYhnV2vMehUTd2+bmQ1HMBTVItWZo8ices+ch6bZWJZ0YHjm1NYmx3JHoN1PQdsRTmdmO1iix1I6Pde6H2eAsFgTToJjPCT8c4w+nTJw7FIUzeWrAeCo1Frw7w/oblucLs1/vCe1dwiNt5av/ItW/LS2fTAGhF/bI2rkde6vXJl78DV1czMZCAf9b9XM9HxwdsqKJx9mFPxh4y3+QhRx8UPK4IbmzGXydDbu6K9x7+L0hQGAg6vt2XgXl0If+5BLAX7xkTNuTX+Enql8IvRIjOqJaWmklbs8+gMWwYZMLtCDswDM6HsWxZLaS34FmSXRQkcFztztWdold/3kVQgp+8Y7dguxgflG5VumW3bxudFTbzpg8ZosLBNMXvKuHfSeziLtZDvvhEzZJoFrPFIYFdCcDu/86P7i81uIWGYkh9acPG0EJf9ZtfpyT4wFdfbSWymDKKHj8sfHCUuz1BjDlyazvNmc1rFTwN4rH8myHux/RMBGlepJ5rZWjFZreewIDu3WdaClylddPOONIrXH0rAUi3VhdyMFXfUl9iJtZy+LT1tSEHo+bBxl1DUKwh4OznN9gIcjwSZtLaKthuCnPZOrw5SmEIwZS910QqvTrPb0jJTexuph/G7HCXO3LhcZqVMFOsKlOPiP0FbkJYYxfEpXX7TwEsyxr6cM2dyOp6lfTSUK21DGDExqjK5yg+4K
 sMV00j9U
 desnn9N3Ljs6mIsC4obRZsZCgp1Wjq6j4lopjaWZN2e0j3N/6iVphnUm4y+yImPq2h4PO5CQ5vumhTnnumfEXKLWQlea85NVRoPxRKzLTSZ0kVj+lsrOSYrlXTvV8hxYDw0mdCr5bkAYPXC77uwSC0myVAPnER8sEW8KO9NLzRY8spYZF8OHCmi3hdm3bccwessEQV+Yw7G586ikGtpVxpkDZW1vUavLv7TzWkQGrY3BwdW27htA8BHxd0O8o47DF95er8u6T8AO4h7UZT0lhntts2HTGj4QJYVixY93O3c9t8dnPDePmyaHOQM2JBG3cQN754o7QQgxJXLaBIyz9umuKRnhpaTVf0S0YW3ZEUrBg19IAhqFyRNIICiZbXnM9ijWgRlAoeG1Aqv1FEP0uvFqpfF2ibDSFoj1Wjsd+6lnq2VZscV521akT/fYKzFvON7gQ81b5sdpSGqg5ZZtsIgKQGbRlgeM1jha2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 11:58:27AM -0400, Gregory Price wrote:
> On Thu, Jul 23, 2026 at 10:54:06AM -0400, Johannes Weiner wrote:
> > > 
> > > My stance is that using NUMA balancing with KVM guests is a terrible idea, and
> > > that anyone that insists on using such a setup gets to suffer the consequences.
> > 
> > I agree. Surely we cannot leave shmem balancing broken due to
> > that. It's also not clear to me how many people even enable numa
> > balancing.
> > 
> 
> I lean towards Johannes' stance here that consistency is better, and if
> KVM has a known-poor interaction with numa balancing, maybe KVM should
> simply set a default policy (when none are present) to avoid this.
> 
> That said, this is painful because MPOL_F_MOF / MPOL_F_MORON are already
> a silently inherited policy on boot (added during init).  This will be
> confusing for users.
> 
> This is not documented anywhere.  Maybe this change should come with a
> docs addition that says the default global policy is ACTUALLY:
> 
>    MPOL_LOCAL + (MPOL_F_MOF | MPOL_F_MORON)
> 
> Instead of just MPOL_LOCAL and letting that silent implementation
> detail bite people.

Hm, where do you see "Instead of just MPOL_LOCAL"?

Documentation/filesystems/tmpfs.rst says it defaults to "default" and
points me to set_mempolicy(2). That in turn in general makes little
mention of numa balancing and doesn't mention MPOL_F_MOF/MPOL_F_MORON.
In fact these are documented as internal flags.

The numa_balancing entry in
Documentation/admin-guide/sysctl/kernel.rst however DOES say plainly
that enabling this feature will sample and migrate mapped process
memory to where it's used, and that this has a performance penalty.

It seems there is a general lack of documented interactions between
user-requested policies and the system-wide numa-balancing behavior.

