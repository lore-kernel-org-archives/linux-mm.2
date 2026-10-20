Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F84E606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=M2ANc/UE
Received: by kanga.kvack.org (Postfix)
	id B9C046B053F; Tue, 20 Oct 2026 13:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B7D6B0540; Tue, 20 Oct 2026 13:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60636B0541; Tue, 20 Oct 2026 13:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8419B6B053F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:31:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2069440231
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:31:07 +0000 (UTC)
X-FDA: 85343695374.02.31F3A1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 28B9C18000D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:31:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="M2ANc/UE";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792517465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+gbm0Z15tp8VKniuyUyyrqMzdRSHHdEh41Xgir5bIc=;
	b=4DS9svBdcIuaEHNlZ8gRCZ1rCDUOREBt5+Dz70wXnsLaCqCiM6+OFGDWr8AxmPiyR2Fqgk
	QsbtjmhxLOibbiDGiN8X9IgVEwxdTeys00Y21+u5Bfw6X/m5tdwFFdj33iSHWyteUpYkQe
	1LtqymOGoITEEk6Om5ynjJZarWgk3rk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792517465;
	b=DbrTB/C/TEPYfpqalxdnhI2SXLuDZolDJTKg3dCF47L3St8SwTMFzoxX+akkR+EhRpJDn9
	Vedm20k2V4SEIXQelsDoISWTlWIdnlrwLxsksEJcYHfwYd2FZ1qLOOoUQSmdo5IYccO+IH
	v27ShQ5/UM49C81uFplQT6Kic9taYmo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="M2ANc/UE";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57C3E402B4;
	Tue, 20 Oct 2026 17:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC97E1F000C9;
	Tue, 20 Oct 2026 17:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792517464;
	bh=j+gbm0Z15tp8VKniuyUyyrqMzdRSHHdEh41Xgir5bIc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=M2ANc/UEwP+2XoIwwV7civxb/e+s55KN4SazeS3hJt7uXujlnErwVMFFF7GG0xfkU
	 pNOkQVehGnI9FjPiObPRMlruDigQp2Mlh7g3ZLbaDjE3SMSDzzvMGSRCInsf3nDc7v
	 3RIFNVjJVJwqb3nKKb6Xb7IH2DPm9Uz7GJ2vtYmg=
Date: Tue, 20 Oct 2026 10:30:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 tj@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb_cgroup: prevent use-after-free during cgroup
 offlining
Message-Id: <20261020103057.8066217f6f6fc5b3ed84c90b@linux-foundation.org>
In-Reply-To: <20261020100345.1677643-1-4ncienth@gmail.com>
References: <20261020100345.1677643-1-4ncienth@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 28B9C18000D
X-Stat-Signature: xseq4c5duhi4xkf8chpc56y774katktw
X-Rspam-User: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792517465-647865
X-HE-Meta: U2FsdGVkX196EWk5lqsfZj87t0tbKCYdZq4oVz7UY7jyoxxZ7xwhDCqJ6EHXw4obVmiE49ULVbTNyADm875nignaaIobFEhLGIAurNXxQnLjUxiWdNWw7QU2STaaKPizkrkDO68txzbzL2XWQDRe3Am+QoYivctoifRSdPjXEK1I88HCorJCCH4xzDlvhlUKCwHovFZ1/Oeac0xFw+Mh0v3jFCgkP0phuxHD/r/zcFlUK4YaQ23OtjnpO+PKb8UUG7L9kJheL/ofYYKVYN4EieEi4zrKtHsbYGEmL8Bx4DP9KLDit1iFjSFR2fL9/6urCltKb6yh0uU6jWWTW6UfIZ23QgN/cfF5E3xvrR8efVd25JyaWQ8N/2OcGOOubdJkEwbM9fYZw9zZbcNC1appBjxpoXwQ3ZtIBn9L1G1MUdrtwcPYBgXKFZg0vP1IfFJsB6qHTTOAuYACKTIXELp2VGPMXmt3subOqwQTdZy6qlfBXBJXKTfDchET/hkVvn7U+0Z/MjMhjYGurbopdwwFS4sihw1+xxsDLAGpPKhS95EkcMMG9Ca8seJiIHMcpH6PJXhNSZzGnXHVOwzEXQNNpDHLQQ8XUI6soqnYrDNKD/I5qvD7pl/iN4iDDCC/2JX56zg9Q2azjQCBJXCL7PfsxQOwAp5HBNS5NmyqKPxvPRm00zEiXTjaCiwMV3BuotGu6Xs/Twj1WUbWycW2H6OATtfssSHHPx613bdswuPfzBBPFCx9v15emu5EGtEKVbZs61omjzC6SQZ5eW9wSxBaNUK7Q2HYpV1WKztXacIts6eE2b0+5Nwj/TfGxhThcS0/SrdigRTdTMja0T0Xtluxl0nPG42IN4kg6IWkn8pj7G0RlNta9/WoGApYXYoR8Ws57eYRmMLJ4TFojjhdl1LilESqRrztXge7zQGaBOLVp6yMwZYWBjvxHIy36tNfDNZyvOUZSo4oLY8/3RSw6Dm
 tA+61rjp
 hqEG65JfHPz0Y0lhnay6ZvI9upHlwYrKc+kefSGeuH00V27PNiqKsB6mJitXMzqvtPSQ5Mc5GMzwkJWrIsYMnANmJGLfCG5jSgYYpvW4Oi5+O40XN0ZKkfv2w91IowPQt6RVjwx+k+sok49NNR3wg5Gf7kCKOBDu2bIcuNDC18Svx7c24V7MOwwhlXbWgxk0ktDnTZSWa4bsRZZAaw0OIe7apjw2cMZbTy5xyAjc4cqXCiXZ1fho1tezac2/l5ivJ8HJwXrDU8DgnaN4oSw1BPZ0UjIalIyeenvAgGvu/6IrY8V3oK5zL08GQRly/+OOY/emh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 19:03:45 +0900 Daehyeon Ko <4ncienth@gmail.com> wrote:

> A normal hugetlb charge obtains the current task's hugetlb cgroup with
> css_tryget(), charges its page counter, and drops the CSS reference before
> the folio is committed under hugetlb_lock.
> 
> The task can be migrated while the allocation is in progress.  If the old
> CSS is then offlined, its final active-folio scan can finish before the
> charge becomes visible.  The allocation can subsequently charge that dying
> CSS and commit its pointer to the folio.  Once the CSS is freed, uncharging
> the folio accesses the freed hugetlb_cgroup, including its page counter and
> per-node usage.
> 
> Keep the reference acquired by the charge until commit or cancellation.  At
> commit time, while holding hugetlb_lock, move an uncommitted charge out of
> each dying CSS to the first live ancestor.  The hierarchical charge already
> includes every ancestor, so moving it only requires canceling each dying
> CSS's local count.
> 
> This orders commit against the offline active-folio scan: either the scan
> runs after commit and reparents the folio, or commit observes the dying CSS
> after the scan and selects a live ancestor.  The retained reference also
> keeps the originally selected hugetlb_cgroup alive through this decision.
> Reservation charges retain their existing CSS lifetime and are not
> reparented.
> 
> On an unmodified v7.3 kernel with a 128-page 2 MiB pool, a
> capability-free uid 1000 allocator racing administrator rmdir reproduced
> KASAN writes to a freed hugetlb_cgroup in three of three boots.  Controller
> disable reproduced the same fault.  With this change, 5,000 rmdir rounds
> with 1,075,055 successful faults and 2,000 controller-disable rounds with
> 1,707,348 successful faults completed without KASAN, LOCKDEP, page-counter,
> or refcount reports.
> 
> AI-assisted source review was used to identify the race and to help draft
> the reproducer and fix.  The interleaving and the resulting allocation,
> free, and use-after-free stacks were verified with tracefs and KASAN.

Thanks.  I ran this through my evolving reviewbot.  It liked the change
and agreed with it.

One claim:

>
> ...
>
> @@ -419,15 +438,17 @@ static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>  					     struct hugetlb_cgroup *h_cg,
>  					     bool rsvd)
>  {
> -	if (hugetlb_cgroup_disabled() || !h_cg)
> +	if (!h_cg)
>  		return;
>  
> -	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
> -								   rsvd),
> -			      nr_pages);
> +	if (!hugetlb_cgroup_disabled()) {

This test is unnecessary.  Once h_cg is non-NULL, a successful charge
necessarily came from an enabled controller, and cgroup_disable= is a
boot-time static-key setting.  Please just unconditionally call
page_counter_uncharge() after the existing !h_cg check, followed by
css_put().

> +		struct page_counter *counter;
>  
> -	if (rsvd)
> -		css_put(&h_cg->css);
> +		counter = __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd);
> +		page_counter_uncharge(counter, nr_pages);
> +	}
> +
> +	css_put(&h_cg->css);
>  }
>  
>  void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,

