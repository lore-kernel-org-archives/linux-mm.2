Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D228ECD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBABF6B008C; Thu, 11 Jun 2026 08:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B3E6B0092; Thu, 11 Jun 2026 08:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D814B6B0093; Thu, 11 Jun 2026 08:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C33D36B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:40:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60B688FC02
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:40:13 +0000 (UTC)
X-FDA: 84867589506.29.32EC1BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AA4D4140004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:40:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EeN5KasI;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781181611;
	b=QZQeRKlVLAVAsoIwZDl5+OeJv48odkmg+EM50y75i26J5fNK6/Ils/hstYz6MeqwrO9T+o
	F4ULIX7ijt7rip28BrBoLzsd8d3/AOOeUvyN9yxArGS9KvuIdLA4/qkC6dcRJJ5TmBc+OS
	tgwz6AfLAtqj4hZXu222tvRQ1xmkmbc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EeN5KasI;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781181611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aM4CFsjAfrgDrQU/fs6TDRb0SV1bxnyirTxwHZhtIEM=;
	b=73kDFBzKR/AQF2sZL3QUVkBua1trvYmjCmKJYAa7Rv6xIgje3uquOjVwjkkwH6na7LtDla
	it9xGRdebWhMfUn+QmCSPQQrdezGxKGGe2wlnAtKf/+fe4oL9S3qmKR0HffjAs4EKTnBYA
	LmPdjY7smgXuujGBmJufAMxHITydAck=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A57D44064D;
	Thu, 11 Jun 2026 12:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54021F00893;
	Thu, 11 Jun 2026 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781181610;
	bh=aM4CFsjAfrgDrQU/fs6TDRb0SV1bxnyirTxwHZhtIEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EeN5KasIedx+VFynls428joJP2xO7wsQhXM+JE+dwrimD+izqGH64EN3R24ND7Bd8
	 WOsmQK2462wD4Nl6UUnx+TeQLe6jZmeJzCxGbJE9kCTym7Y7F2+lYe9uwBjylfGNin
	 fBshJXlf3l7DuGg/RQu28awc0CrVkW8mx2eOtPM1j+sJIYkq+hMiZHCS3DMgBFSKIh
	 UZ9jIkl1vc56xvDb60tgS/o8bQqCic4lJ6dXyW8gDjEs0YfzC+zxSu3nXvBUji9mvc
	 HY3ddRBs0PSon87+zIP8x9gb9rd2JQWVK/rCIWQIaAcpRpmkv4nvWaHSnfMrNYUoSb
	 khYH9VNVAPXKQ==
Date: Thu, 11 Jun 2026 15:40:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memfd_luo: validate serialized_data before conversion
Message-ID: <aiqso7rkpX6oMer7@kernel.org>
References: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
X-Rspamd-Queue-Id: AA4D4140004
X-Stat-Signature: cjdabyhni6ido74ezb51ydym7xkn5x8r
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781181611-473060
X-HE-Meta: U2FsdGVkX1+QWQfK+dd4D10xFfE/PuwGeJSSk3bGJGUbZUDZ514UgAODMUQmbdBf8k8CQsMenoG2zgOKD+k28mb08khknnOkOXTZ8jGwGKgiymWj1f9QbYBBH6a/6UHRkN8Bn2kcUitW0SPHTl/WoQKWX9BHFBPLykYf4h4JgOv9zMyJfXw4M4X9DT7sFwQ8t2FjeHhoalWIohNzU2NAgfpgYgGqKaRMTVG69QZaOrWi2APOcBPZnA59t86YswU6R7f2i0vG71Nkihr78ocDT76wOpf4lB0tsvGSPVRml+01EKTuQhLKRBl6QxM7g0QUnO0F/QeqQf1cOEXQvYO0TloBqPHxCzui8E9oJhfID+hmKgswwz+8OYfnGRyCv7hf3atqIlgWXHTrBJlPFNnPb+AwxTxyOEC2LgFjY48jgfW/Ey8tojX/MiDKL9msVo6yuLV4465oPJbaiC5OaPNIC79vjNyVSuxBJupP0AXXuXkgTa6s3RyYC00CSvr0QrTkoR/JJfMH4aP0a23WMuZrcgVwnlN1vuYD5U0d3ecRxne0UX24q3OibOSC5yu4JGkrXYXEKvGWqIUJKapfN/OxqmGMl9aIXY81Lc35XWf/q/e5xbakOtsSGP72XJZhXX0YkDQxKd34r+LZx+1JaboSlpBK/b4w2Pg7A2FLcd8u/4hhI4YRtgYk58MxLrqvu07yXpZniSdjZRoFnHKC8zAGA2NtsAjoTEYBDXrAW/cvKnGY07QiJBTN0gl7hkmq51Yl3EujxuIJ0lRavSDXwUdShHAASEfJrrIf48Qe4NurusoEjczT3J8keFhrnwCdJtIXfLTGt7y1W4JdBuDKGWnaV7tsEz9i/xzX/RhbdlD+I22XQg3hjL5gPm+vxdejStIYKORHPkmLbO74BuQZIyfpnGmnQPWj1Q5wmMq6yITeeMekDbFkqy3U57MJCBbJq9Kho3ZZ98O755/lr0bafRs
 wwYaVnPZ
 usDahYnCsg9rz1A/qQd5LuHB/ujS3xsS66b4TjtYbvU4SniCFQT2wfGYkVMs59nKzMrLb+ej7xIKwigsoXBgARhm6w7QrXmPdn1OEZhoOP9JHz9iujY03sc1lYacU0xVXM7HDTe0c7KymYVMwwi7I1z1nzoIOFqVTBy305xASD6FhQ9kaWKbBNN0f/YFVSqe5OFWxtaw3GdaIGc+H7ANHdN8Xhb2bvGjhttFbf3Q6T4dr9NBcBAfvYFJGJc+6UkJPM5RjeJZu+B++NbPThue2ynciaxg1yxETr4OdFbCAhk3m91xasE4Jv1OwKHJIwqeXGiOh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:30:03AM +0000, Tarun Sahu wrote:
> In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
> on args->serialized_data before checking if the physical address is valid.
> Since physical address 0 does not map to virtual NULL (due to direct
> mapping offsets), the subsequent check 'if (!ser)' was ineffective at
> catching a missing serialized_data, leading to unsafe dereferences later.
> 
> Validate that args->serialized_data is non-zero before calling
> phys_to_virt().
> 
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  mm/memfd_luo.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 59de210bee5f..10f3983b0060 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -397,10 +397,11 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>  	if (args->retrieve_status)
>  		return;
>  
> -	ser = phys_to_virt(args->serialized_data);
> -	if (!ser)
> +	if (!args->serialized_data)

We really should make args->serialized_data a KHOSER_PTR

>  		return;
>  
> +	ser = phys_to_virt(args->serialized_data);
> +
>  	if (ser->nr_folios) {
>  		folios_ser = kho_restore_vmalloc(&ser->folios);
>  		if (!folios_ser)
> @@ -522,10 +523,11 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>  	struct file *file;
>  	int err;
>  
> -	ser = phys_to_virt(args->serialized_data);
> -	if (!ser)
> +	if (!args->serialized_data)
>  		return -EINVAL;
>  
> +	ser = phys_to_virt(args->serialized_data);
> +
>  	/* Make sure the file only has seals supported by this version. */
>  	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
>  		err = -EOPNOTSUPP;
> 
> base-commit: 9716c086c8e8b141d35aa61f2e96a2e83de212a7
> -- 
> 2.54.0.1099.g489fc7bff1-goog
> 

-- 
Sincerely yours,
Mike.

