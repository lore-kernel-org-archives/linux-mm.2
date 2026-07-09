Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EAD5C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE9C6B00AA; Thu,  9 Jul 2026 10:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395736B00AB; Thu,  9 Jul 2026 10:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AC9E6B00AC; Thu,  9 Jul 2026 10:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08BCB6B00AA
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:57:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 910AC1401CE
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:57:15 +0000 (UTC)
X-FDA: 84969541230.25.1546DDA
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA31020008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:57:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=l25hrEP1;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783609033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUc0YxX2OnLyX2sI3kys65ZvVtk8+5Y5AOwoYWzDFOM=;
	b=4fYxuPOjZCUL00AzniH7GQ494cKPFOvXRZyh8sUEP49UkAlRYcYGSo1hxptZYnxdO7Jbdp
	IGME2n6bqmJ3acZKpzOoEtUQC2oH78KQBOxpmuV+EFMvR7m/ugbQaSRRpQ5syKXK4Nsj98
	SHoN8FkRm+Tr10YyDCjM4JmqKjWPPpc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=l25hrEP1;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783609033;
	b=OvzmGuNVDFa0XwJ7F9gRirvhoYBrzqVv9HlI/KnXqDU+qDIHo7IXBDAzsxyx1Xw7torls5
	OXuODV4tFwQurOP4cGXT3uwpUA/n0yIaY57rsm2FiuG8+NyuAybwf2VkSdCb1vVjd3JnXT
	6+bA9pqXN1eEfVjh9/YNCuruyLWg74M=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e99ef0902so51747085a.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 07:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783609033; x=1784213833; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cUc0YxX2OnLyX2sI3kys65ZvVtk8+5Y5AOwoYWzDFOM=;
        b=l25hrEP1yRgkSHMS4VuLhwCXiKZaGD5vUk29/kBcOT/nnJ36ldYIyTYMEHuCL9YfuT
         JUVwpR/KCjszKIWdG0qw9UpakGgHEQZJcfs3mNybWeYu1RdiOcLNmedw9KTHsW0Dvl/s
         GaU67PacM+RltIFqvkwEgoQMeJfng5RZJB2GtIZ0/vqPQgLQ4h8lnW2FcrTR6PWNmE+1
         ENsiM51QxAAY2q59tkNwgXgfFw7KvqhzwRr4EvAepmmG85V/sB/EhJoMZ7LoJZyUaKEj
         lk5p4QcrN8WtU0Otk1JBl6rdvheZFwBJbZsNCfG7+M5ThV2AJLS1CG2bWzt8pdrYM2rZ
         DYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783609033; x=1784213833;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cUc0YxX2OnLyX2sI3kys65ZvVtk8+5Y5AOwoYWzDFOM=;
        b=Ag6P5z5s4aaETAYBbkfFgj1a5xICIDK3uf/+ak8+bZhyOMv9CXruQKq0d9MK8KRki+
         KiIWKCYho5dworWohGBXV68A4EKlNCzaLYAMEGRCf2O+GJ5FVZEPuG9cN7GEDjI2abv+
         tIBygCB4lLrnTIhfATN5DEuMELXdRBKlj90Bk4eJCI6gSeJevuNf8qQgujR8Lyj3Gwp2
         ant7k4+sWyRpK/TofsluW2AR+kbi30/Sr5e66IizzEajzcDJQ8NsKx5h6c+pqnHQuLC6
         g3UD5GeCz8oN1oSZb5MhjdT6nBVk4dU+SZSfqQOHi6etaRk+mfHGnZXiBtFmLUgJyOUm
         HB5w==
X-Gm-Message-State: AOJu0Yy9LjLNvu7eE33y5MgsqSoE7LPYbQDXDjhMAIRHGUYZA5SRz7Mw
	ANUSzTy+OT8yndiQOthJ/jgk/L3yCF0J0rwgqG9tbkHVHa8Ubs1OC3Iq50d7iwe2DYM=
X-Gm-Gg: AfdE7cnagj1H/4SugcwTPEdOkwIeWT0PmMxrdKtCUUuhJHtj61XgupCYxSPfdaX7sx/
	fwgYN86YRyqZSC54Mjb9NkOgaY6wW4EGSXnbjWicAUxop0EbYt5lc2J/GHqn9tmf6NMIbDbQZfQ
	mocHORxtGmA6ur6XC1v/MXy1/JeDKvrXz/2x9J1WvSBWrLHtAI63Hq+O81i7NPHTeTKseUKhm2d
	ZdY+ZcgDXXIxqbB+T9+lw2TKOnp+g1qu4H3WyexTJPWcz+CBOuB8KOGWNW/tDifPJYeuwlJLVGh
	NBY6mXlrCAzjcGMGRNZ8x/ExldBhHBUVfX7BINBwzGkoSP2hyi7oBxQ6CSoSRLOIoFXrR3bvp3a
	KxJ2PGw8lecyYVExZD6aTtAVa/coYbo3kAGUB/ZxuDt0w3PyfFHr92angvdt22Db5wHdAjv3flH
	pQajNBpev3pgaGwTYXWHYuA6+ncTEkC/eRbE8Rf86+OWpiBkj1eRL6Q5XZijv2cotCC7Rq
X-Received: by 2002:a05:620a:460f:b0:92d:e54e:72db with SMTP id af79cd13be357-92ecf54a01bmr728326285a.22.1783609032712;
        Thu, 09 Jul 2026 07:57:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90cedfe0sm1725553985a.43.2026.07.09.07.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 07:57:12 -0700 (PDT)
Date: Thu, 9 Jul 2026 10:57:07 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <ak-2w-aHp5huBa2N@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <ak9TSx-I-53dX6fx@MWDK4CY14F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9TSx-I-53dX6fx@MWDK4CY14F>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA31020008
X-Stat-Signature: hhzzactr17ftwzpmxedyu8wskfihrimt
X-HE-Tag: 1783609033-464736
X-HE-Meta: U2FsdGVkX19Xa1ZnPYae/+yIGw36laPeV4NwGofds+wEQkmxGpP5jBWBcc0KoX2LoU8uXDmNPT7WfyY2885hXnd0TcOFl9lRrHpXFfMWCRNtJzYD/gWOsS0VDcMM5xZO7TQXJ/MKFjPwx8nZxFOdLzN3RO5l42yJYugUULdskehJYUWSVlHKuhQTS9O/gM3Rgb+6MkOJhIk9OiJJEgxDii1Z+HkrR1mO9Pfsn/k/eAIQGRrNA48RX3j8FzbP9pVPfV5SLL/4q6NujpXKBjw4CwjeJOmDc9M9YeOe43kMNk5NihkPYCl/7pZTy+nQp4jUNVFsYMp3YEPpK+zbWsqm7DsL/1xMjByHphPQiOSEHT615jx7+Bo394FhUmGkUw6rQfHgJLkCgiIBcQKbvvi9QsnXwsher8etWX+G++lTGVymyWZl45q0OPpBbzIZiKXFZRM4Pj+t9JsqqPRLILdsNL+2DOkq2zrdPiNpWC4foUvikr1qy4tH7iNxs+PAmlgYGsoQgpKVLehUDBji9g/xk3FBmErBwavOytfnEVYSfgsQ5bMkb9eJpV4ryuaZfD+cVo1U2e7hY47Xj1Wa0NDntS/k3PBES3/JL4/HmTt9Ycv+LikM0TkwD+DdpkR3HnAP+qNYvVSfhf0NIz5FmM6b2gb9FlItFSt4LOmHHZxxkdTYsMNn2rP4eNcv+VR18u9a9M6lDDHCqTrO1nAaJpHbks16CbWe7sv9fa22HoZdxqEKy1ZKk8xdxZxL1TxAXwBGNobX9MtKj7YiqMdU+MiES3BuWg8QEmKqoS1+SQVhDB9xscTh4S1+OHsy1SOsvet8+N5F8MutopJvA3JdplhygqsMZ7GcpiJnzU/wYmGo/3ReSahcjzO0YoxG2WzTaryEtzpS2gAFTGJCInPyPmgnvRhd5DWycsJUZbVSRdQRnjISmmIyfuvJ7ylQeuLgKsiRrloEq4lY2KHZbtomFJP
 gw/yun5C
 x4KkplZHhhXOS+6/IOyt/giVeNKGrQX1eY7upCM0FFB8F8ksBZfoYX64YIM1rQaz6nsbuZBZSwR1Ir8ceFfUjlqTHESfs5ifdrRivZWXCjpDdFfBNdEoJ+S4e1Z3nLau7biDqc1jWnjwEW9W2ZYrvE+pxFmOARYjiR4HcDr+/ZQ+uOzXc8RG0QVn3nKOxUx4nsZhyQECW4ByTiFACXZafnmuHD4Ah48gsXZJ3qsyc4AFEkln/Hw9AoJ9vrn30MK849iHiwbdVwgrbeN5k3mJWcCgaSZxC8qRe7wUAX5IsKVAPwupGAeZy1khKSVtyGAK+m20VhR+aAcXq9u9QuJOWNO9XayLH0QCBSf+aBTTVdQm0rvqM4Yb49WKgRAAKXmFx04BUTu5sx/cOLBwmMmLLoen7fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 04:07:31PM +0800, Richard Cheng wrote:
> > +	if (dax_kmem_state_is_online(data->state)) {
> > +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> > +		any_hotremove_failed = true;
> > +		return;
> 
> Hi Gregory,
> 
> I suppose data->state is only updated when writing to the new daxX.Y/state file?
> If the blocks are offlined through the old per-block interface, data->state
> still says online and we will hit this early return.
> Everything is leaked and a later rebind fails -EBUSY.
> 
> Current behavior is using remove_memory(), and it succeeds on offlined blocks
> and fails safely with -EBUSY on online ones, no offlining from unbind context
> either way.
> 
> Your changelog state "on unbind fallback to legacy if still online", but the
> fallback only runs for data->state == MMOP_OFFLINE.
> Maybe drop this early return and just try dax_kmem_remove_ranges() here too?
> 

Hm, I think you are right.  When doing some testing I bounced between
tests which race with dax/state and block/state, and I missed the
obvious case of the whole device being offline but dax/state being stale.

I think this entire chunk actually just drops to:

dax_kmem_remove_ranges(dev_dax, data);

And the internal error catches the condition to the log.

Thanks! I will spin a new version next week.

~Gregory

