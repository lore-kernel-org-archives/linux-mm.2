Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE3CCCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 11:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AED18003B; Mon, 27 Oct 2025 07:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F278000A; Mon, 27 Oct 2025 07:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375078003B; Mon, 27 Oct 2025 07:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 247D88000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:46:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD156C03D0
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:46:06 +0000 (UTC)
X-FDA: 84043715532.20.653624B
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf14.hostedemail.com (Postfix) with ESMTP id B343F100005
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:46:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=b3xKaH3H;
	spf=pass (imf14.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761565565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XK+kHZoraRihmvN8J6g5npImNw5mp9ljWxnUwpTRbXY=;
	b=Ip/q/lf8cwybVo71e0ohTFu78ZBm7Q1VJ58e89/TSakVcF9hHJYlknywxXTpFIafJalLIf
	juqK0A2rAHLvGxk9twALowx90ubQYHT02vyYQYOZxGs+u/0Eo2a2OXXRDHG9QblcLSDxkk
	B7be3l+tEKdo9M36TCBNmmJztlLT7/s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=b3xKaH3H;
	spf=pass (imf14.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761565565; a=rsa-sha256;
	cv=none;
	b=6G+cczsmnyoZx4TCe2nkFXS12A3AyeG8bjwN6wJGNuSdGb4IzmnhddvIo0y+h7X2ufR8Py
	2PPtH+7o3C2ASHJjPa+ge7RZKqWZNk+JQqpmLem4rRf7qqadU4SI3uzbif17X12/OrDI8w
	8wGBMFJcNUri/W/rg3XcJ/XlTBcmfnI=
Received: from 8bytes.org (p549214ac.dip0.t-ipconnect.de [84.146.20.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 6712359947;
	Mon, 27 Oct 2025 12:46:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1761565563;
	bh=0kFQ3vvotzBg63RutfyUDjSc729Pvux23b7TJTDNuI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b3xKaH3HIudsEnOPgSqaPsxNHCv9VETGXSvTt3can61L0gC0FNaMQ/HyGWLblVxA3
	 txbYg9DFCxLEFFAtT4pKKju3Fmc4dGtOkPpX/GYPwTk3102HYnqfE757wa20vkD2Oz
	 dL6ZKWVy0WvmtbbhxTchW+b9gMz1surolQgcgEvMSSGplxLiS5t6rHpAwWx1g+A2ZH
	 YP1KzLYZt+BOVBBC8j1a9h2lBoHR6nZMYhMYA77Or6QMl4fgwgBBH0Lj907vGrZDBl
	 JxPqVPXf+SwI6dqcq84JT7+zKj0w82jVFYelzVOUFGxX1U2rViC3o8+3m3McFb/Int
	 gHnhbE4h5uFQw==
Date: Mon, 27 Oct 2025 12:46:02 +0100
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org
Subject: Re: [RFC PATCH 3/4] drivers/iommu-debug: Track IOMMU pages
Message-ID: <3ajy2xcjo3t6xdrbeo5xinlwtxzujvx4plzk3vqj3za7ren2rv@wdmwpjlaq6ql>
References: <20251003173229.1533640-1-smostafa@google.com>
 <20251003173229.1533640-4-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003173229.1533640-4-smostafa@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B343F100005
X-Stat-Signature: f4ntr9wjrpikgujb76t19pigz6d56so8
X-Rspam-User: 
X-HE-Tag: 1761565564-877728
X-HE-Meta: U2FsdGVkX19LcT12LJfe9RT+tOmg9HXRzv9iYPBlR/xzEa/xNLbTMKJ/nNQp2Lmgc8fmpJob7MF2tuvfiSH7zJTS+KxWaYwvNzkD1jMSxj9P3BGEupBuEGT6kQh2taL8IENjf8mwj15vrTIurNeB8tmC9WlvpV8Ppm+Z/BR8mW7htuEMqwES9hXIoyq6woZHa1IEuBu7QZ4PGFkffuXRxoiC/rDDPLQBbeUpM9luzdVIOSWEqYUqS9RQlNdfcKZ/6+onTifNO9T9lPYtf7lqd463tyWIdufhZsAhN6GuYPeMt9y31SvX6GXqJggiRCkWFDFVVxCIeKYf56cBu4mFvecYtKf8CM1UqdIuLnfCzvvm6Yxojz3ymqs7rfBdcyCD4M59E7BC9fzV2sRA3tkPvPIU6Qjsy1UrkEqabaQRJqQyP3OpFl7Gc0wkJgjL2fOa98OHcJPXr8z3alPiJt2ENyZYGqdkTwMscwrceEhVU19MaTZgPKgfIBSy+yhPMmuk8Awfcfh52SVXBiPFjFU9f9Xl3Pvs2nEZ7SnuBIqaAXkicRV6+l8eXA/8XvUGJTg+hfLusSjjoFlAtcwCKwpYQulLwGcFCQUppnzlyICokMilMERPEhrJoLmbQcrLpUU+5y8kvkowTp+gI7q+6OB//ZcVM+zvu4gMdKXY1vAJTwtfgqVAZ5kHrXIkXYsNJ/sIQbu5lfANiBTwioHKNanMBEF49GRo+TKg9ve/MHTm6axvtftq0eBYaAj6JAJf95koxBz9mrLU0fde2MW4+7EYA34WIr/BKW7Azma0R/ZKuHzZLa6lk+gUrAaTm32RfUOgFAwhiVSXW9rAiRUA5dwTEBp2pxuAWmnvxoc9A08NA0SBAGtsc3SV2/mAhg1RSa4wNiC3fOrabpyuYL1tXjj8++6rOP4E+FmLkM/uQkCQQ4iy4rP3tHUCJvImL6XeRpuLb6DMTrKN+oeDFjGGABr
 SqHNE4HY
 EvXoV1mgW5+E8eKGK/KDHfh5lg67qu4aFFEiua6Fzq7k6Brh98LWXopRkbqw6hJmdISGramAGxgNnVb8Fm5evUfwgEwjDYO65iwyKJ9vIKcCFptBPhmm/9ev13Wt/+dTMS1IG/W4/RVXJKCAm1Up8jnaTfZAKkL4UlpeanV/DOLeDPVh/ESzmKBF/WKvoB5Iynj9I+PfzJ972CVErlsaponsvdgj6FPmdiGlDlzD1omMTxMp3CD8om1EVFQ9HHD3Uiur6U1W5+VuGauPZVr0XE+tz3pBtNYQ31tgKSKkiLn+VnWc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 05:32:28PM +0000, Mostafa Saleh wrote:
>  void iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
>  {
> +	size_t off;
> +	size_t page_size = iommu_debug_page_size(domain);
> +
> +	if (!static_branch_likely(&iommu_debug_initialized))
> +		return;

This still adds function call overhead even in cases where iommu-debugging is
disabled. Move the static_branches to the header files as well.


