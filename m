Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B88B2C531F9
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937FF6B007B; Thu, 23 Jul 2026 11:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FB56B0088; Thu, 23 Jul 2026 11:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E4E6B008A; Thu, 23 Jul 2026 11:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3866B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:58:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF1F41C0854
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:58:36 +0000 (UTC)
X-FDA: 85020499032.16.B851936
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 135134000A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:58:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tKqjWqxB;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784822315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g76/VCTunnMtb1dTlZWxSdXy3jUc5pTpstI44HSyfHw=;
	b=DAUr3dx1fuyklOxDKm7CemmIa1g6dOHxumXw4z+jJw4g3GtGDcTiZaRli8EnE6bSaCvr60
	THU1vNL9c6PVljjOfF6W3fjPoOQQqTak3z5tgEDH+vBJLd4Vi5jfoRrWCyYLP5uuXFF6eo
	Hdi4tGYn3uoDZvO2Ua4u42nR+wy05Bk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tKqjWqxB;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784822315;
	b=vF/2f7lLNTttmQYWPuHwohDgpb/j9HD1E/Pp6Esud/IKqel2Xc5XtdAKmIzPU1DrkeRt05
	NPJ7rR+Aefc6iuP6WIc3x3BB6oXYtK5zOrW6OQrOEZJbufxMZmY4Pk0DcifP5qnRBMuy2S
	55OL908/IXUh0cSvJ8KLDd/Knv5V/WM=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9305a2121a1so83567085a.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784822314; x=1785427114; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g76/VCTunnMtb1dTlZWxSdXy3jUc5pTpstI44HSyfHw=;
        b=tKqjWqxBb4bi1iGix7QIhUlq7GmAih2ZdLrRkGZO2Sf3cWR4bs4wtn1TJf1pCBT1pD
         ljWlZ5I73T6RljneeM16bifGgXI+0iP9qH9rbiPvnzLySBxS9XcWAGWsViKJMFv2lcpR
         4xZpKg1oMbU5/5sPAho3KeniTQl0jgn29baLxNlLjQV93SO0X7gwEG7PZbjRWuC3mmoD
         WyE/Kqgxic6HeJjNCWNoq0PdiRB3zVUWVnUjb4jjPZ5fhI/LGS1zLmobz6hAAECWqn4u
         EGzY9p8Qk74zJysWuwadvgkq1b90wOVjigJHFh2DOY0LgBKNeSP0SWpYaAq/a+NiaJZo
         AA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784822314; x=1785427114;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g76/VCTunnMtb1dTlZWxSdXy3jUc5pTpstI44HSyfHw=;
        b=eLuC+pb/5R2OrVBLj7A68pZaiFJsf1XAxmkqPJBI3nLLr5x3sedSCLf7HcLVpdZQqR
         nuL/QEAjt33MuN0OdtiSC2Y120ivZAz4NSxe5Xm6s2L8c7kmYwh226TptRIIDtKkMzBi
         QQmPEQkukG3SXo4mRzwzAPN8Wd+6t9H7iQqbkS8K+IHWT+VWAG5JDo6t+t9Z9kjGvRDQ
         stQWz2RJO8DO9G3Ui6wWMQDBgVEBbSQl6gdr7ToIIUIapVhda9a7kyos3tEoexw7oTFQ
         ufy+9B1zvOZelJGy66XTN6RiQX4svM00PH2rfg+S8bscksW5WJ1C+Rc86yOTiMmhxpUR
         RpoQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp3nig2m1bqjzvFe7zb4LLvmN4r7Yh54N+pIk2vwW9wDk8sZOdI5voVEw7N7yt3mkqdITNZIhzv8A==@kvack.org
X-Gm-Message-State: AOJu0YxizVqNpGsNL8ndjM70iYyTja2AjREW8i3WzZHmJnheg461eKPp
	rhRDjRXNfgLl868dTR0EIt7ZEVVmVKckurDW7Jm7NJUY8fULVCDoaUZ5aGLKnpnaiBc=
X-Gm-Gg: AR+sD11iuwREsjl2luuwntNbIbKSUqvH27aGqVI1auZNapEJTMqwkP3Nm0e5LUD8p0Z
	+vPl9G83TGLZRR9ENSxfyVNXIARWdsibsf21d7qDZ3K0xqYly2xbHe5UqHyt7q49lGHiJs1wP9Y
	bDdXx35rFAP6lTbLElkZ260EgIjA5YFu1vF9HnqO0AIz1jibPajjngSjqTDAA3vJBbvu0e6KF8y
	xF6C7hduAENYVNvLfRO/Z3rgPiOsoCLGa2wq1QE6pVGtlL7h6kDzcuO+vZ9CGibqf+UdiXQ0+GF
	0X8M8ubESriQx3cziFfygvCPgSLywJigj806yO5Sup2xl+dWXfQx6n0kDJsEozDDGOQ7FpzHCsI
	f0t8ZX9Mjt7m94mUZBv1aLWlbVzaAiP1YvS4PioSuYZcXHuM2au736+bmckjPdUFrCQsqFg8DOp
	2+tJmTh5JaMyfXAiNcndYogCyHybsOjujrSbfe0xFchoonmpOk7aL4z68qGw==
X-Received: by 2002:a05:620a:1726:b0:92e:7d7a:108b with SMTP id af79cd13be357-93103aee60bmr357433185a.50.1784822314110;
        Thu, 23 Jul 2026 08:58:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a03834sm441323085a.30.2026.07.23.08.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 08:58:33 -0700 (PDT)
Date: Thu, 23 Jul 2026 11:58:27 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sean Christopherson <seanjc@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <amIxyy4Vg_TTE8Y4@gourry-fedora-PF4VCD3F>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
 <amIcXrS7nGX-adpG@google.com>
 <amIrDncrL4K-JRBO@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amIrDncrL4K-JRBO@cmpxchg.org>
X-Rspamd-Queue-Id: 135134000A
X-Rspam-User: 
X-Stat-Signature: 9abb1pa3arb3739stnsf5td8dgjsqnqw
X-Rspamd-Server: rspam04
X-HE-Tag: 1784822314-459550
X-HE-Meta: U2FsdGVkX19ZKwQAIFGnsvRfW2eQ/JdnmvOaOQgbpcfguVPl91egZBabf4dBg5PG0gz3woqGmQMNGZUVkj9fiNqM7mInp/Yqyzob2g3bOMM4cToi16Im3gOWIVLtmSDWodUN7YuBOtrUOIZbMcKdIhfzfAj814uhnreFTgOSrfYZRI5mxVxdJADhoL48U36JZkwVrCsGXsKR9EVaY548srIffDfRSdFS92aanNEnSC7+t5TRVlVisg8o7Y4sx1ZAClFcj+zgn0LvYBmO7cTMltKMsiHNslp+yOCRD943R+U365nqrXOTBdHHtAQPDLamZ+ELaaV7v3IJXQLW6hXZpC+O6x9+o4LmSrInJ0Q0AN+JgsOyWBNG2hW/nQIpevwMJZCSBiuFOu2y6Th3U/vMyqlHhCADFy15OtCUWFmQX3P8PmgTFjVRX/pOBTB/vvHgR5l4b7uhMd1C5K/PetUFc6YP3iAOrGg3j+3NfomdJb4UKPgWIKZ26+1JxEK1g+ZFYPFnYj3JJyqvmz2INAD0YoFxlnqwXxlA4KnkpfgwX5N6/ZeCTr2j/UfL76To11ucFUc0CkV+XvPoPHLeIcrU2R/+8+48gRwvLjtSCYcIDvEor27cTaTzCg7XEdKiAhRhBFeuIXzySiZrgba/7bAUUNLyYbW5qRkVwZVET6wRwqYipNsACrppYNuSOkiyd83yeZ/oHCGEt+mSa0Snkuy8Hfb0rJb0qcciUDQmyPIEixVmpEMiM/7R98wplrzxXz6jyRQZJRnLfZK5iihWxJuqm+yzSn6aO/xZ1wA0/L2vhsCnopSFYbjT1ewnk0NIoTfTl2ns6z7WN8dO0BJo1pRAhaSWaLbK9xSJQLXU4sFYDU5Y4XVdVjyBhm8asREjyoTWEd6cnxrWtPkgBQFlcoit0yd9rjH8W7/Z/bELv5clwmxYG9hMneNGhQYQrXSMjsIvP9dta8UWmE0miEzqw5Q
 ANJJxLiX
 1wQztjRwrl6RFYueLJPaMkD8Gf98HXJUnkmDhE1GP654mdn2Cy2SRZ4wCHTp4g/a1ugh1lqLfTnleMHFDxuAMooVKogy01zfy7ILJSmDeZho4htFftnBewnMT+rkiS/vbG7e/PCBn5+DxgAHmOpMStKq4cXAEzl6sCAjbJfZfX+3voBcC2aqbtdlGrDgYEqdrCyKMa2kRKX906TAu969/9QE9tbA+rJF+1x7jUkZlaEBaJIr7ZS48zu+kgBOc+5XgJsIFNpvfnxCKNm5OlORwunaW4VBI3Oe5YgijI6OXh/LYe3d24OmMEuB3zfV9uGkobOmSk8kg8u9NKAUv8Q3cbwC3GQBwd1Xu8HL59tLs6ceaYavYZ1sJlcJsZfw7MVADUULCQqcxj0yGPtRZbm1HonJ3JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 10:54:06AM -0400, Johannes Weiner wrote:
> > 
> > My stance is that using NUMA balancing with KVM guests is a terrible idea, and
> > that anyone that insists on using such a setup gets to suffer the consequences.
> 
> I agree. Surely we cannot leave shmem balancing broken due to
> that. It's also not clear to me how many people even enable numa
> balancing.
> 

I lean towards Johannes' stance here that consistency is better, and if
KVM has a known-poor interaction with numa balancing, maybe KVM should
simply set a default policy (when none are present) to avoid this.

That said, this is painful because MPOL_F_MOF / MPOL_F_MORON are already
a silently inherited policy on boot (added during init).  This will be
confusing for users.

This is not documented anywhere.  Maybe this change should come with a
docs addition that says the default global policy is ACTUALLY:

   MPOL_LOCAL + (MPOL_F_MOF | MPOL_F_MORON)

Instead of just MPOL_LOCAL and letting that silent implementation
detail bite people.

~Gregory

