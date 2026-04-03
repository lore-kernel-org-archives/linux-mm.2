Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D01E7E36E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 10:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535C26B0005; Fri,  3 Apr 2026 06:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E73A6B0089; Fri,  3 Apr 2026 06:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC206B008A; Fri,  3 Apr 2026 06:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 313076B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:55:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA9D51B85B8
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:55:37 +0000 (UTC)
X-FDA: 84616938714.14.97FA0A0
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 15C241C0007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:55:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Phjp9PMY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775213736; a=rsa-sha256;
	cv=none;
	b=v53GJ9GUO6ShIvshEEuiqFdQcvGM7aq9NNZjcLtvwu59MgtyvEwGjaoKfSUL0ZBPBHFFdT
	dTlJiVJW85LvpaKuqxXx3mimcgOTPB+39O/V0fs8Oh4QNRJ+lnnMcwvwOIVOZT6jP9z1fO
	i7Fb/WficTC9LEEhtiXIjY+/FPGLE/0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Phjp9PMY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775213736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCOWVyQQtQGKUxOgS4eWpTFTaC5e80uwLtnknZ47Le4=;
	b=TpnLXdz5mpPY7xf+2MPGaHqpfVQafzedbOKkxlYgLMNHmZrArLOGq5szdAPBRHd9zLI4tT
	AKE+0pjFQW2AhHFSL3VGECLtKvQZH/nQpBDMDEMLOIoPZoxbYApBdUTsdczRpoUoK8kEN3
	kW5whJivrnUpjasAeai5LJ92QXedLmY=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a133b686f7so2053850e87.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 03:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775213734; x=1775818534; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gCOWVyQQtQGKUxOgS4eWpTFTaC5e80uwLtnknZ47Le4=;
        b=Phjp9PMYmXBvU9o1iCRTauQoMLWi+NzEnJqYX7tThYBqMKGj4xAExOyCBaYwBypmtl
         1+3n3oBoibFhEk/BNuzwTpMadSxTeCUTaufxfWdMVUzElrAAspAtohv2fLmAkjqtyXub
         ChwlAybp5+f6Nt9jKaV12Jw49ep3IsGAHQh35F9CNdyb41yx0KN2FSWm+DR7U0UgnOJ3
         xKe+0hzKA5UfoKT9JokLh47slyWjDMM6regmltA2wiKsAPceHdVEeCNowAa6LSLKLi/m
         NrpDl0Qr8RX/9hFAqeaYUhG6lVfKGMBBYdqX0S4viyBoVhQJaBZTHXXaOibWeOGrYOZr
         T+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775213734; x=1775818534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gCOWVyQQtQGKUxOgS4eWpTFTaC5e80uwLtnknZ47Le4=;
        b=XrZygzKoxCHTolCILvAki6v0TXtdhMKpuDR6QJNuH+hfKFLhIwVAsbFoA5tfjPursk
         eY1hKKzrBmvjk/cS9QnSrfx+K3Uts6p+pGQk6oXgAL1zXKrqnmMo6Fmrk4/IT148tSor
         qR1izVKlHVN7nNiQ+Yxl5i0lBx5EnDLOAQtniguRtfAVgjW7I8QjXAFdp/nicVvV8P+T
         3fmTg7XG7KCoIAv1qjIDqIH6jv27CnmKG7e9BZaOvwEI6WMhSiUZ4pQOpUHeyRSh3FyJ
         rdahosrpuPNQmdGa3d14wIjCuhVqXB4OysGcVfKSEHNkygoTlYUTeqKhP46MshN5Inn7
         mf/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUsBxg56quKYSCrSI3XDUVMx7pP0j6hxX8BOLijpVuQpTnMFmSCHNzSPSCQrZxhn85hs3622e/ApQ==@kvack.org
X-Gm-Message-State: AOJu0YwzSm0ud+nFAMIKjUnBbzCOnzAzSM3Mj3DDfqw++241p1ajNbHI
	qi7DX19K3I8pX0eUELiSbawaAxK/8mtPQQYSY1Acg0cqRGaeSaisD59R
X-Gm-Gg: AeBDievH26PjaEo+dGeJu1+97ewt0qQQIpBYF3XeneJIzIJ0sqEQ3A7/If9cwKCdWe9
	NzxaSgX9oxf0fHNfz7k541Swq/p7X7XAe7lhDseihGpA26hnU1x8/DY3BhrUFPBmZvcGv+BA3jN
	F/CvREqG83Z/rguzs2Bt1pv8ypj8RQALCWUqfKn43t6fO980AzUu0kBMiBxwV20Rt0Z514Qg+KI
	XOG0GchkU5+1z6i8tQhhmWjlmiioPSgwmj8j0RJaMI53J5r5qhepYObcJ4xGwNRPcqRVch/kG2o
	6TBi6pQ3fiaX9fNPXsr56mItxcdze5EuSgPWEUDleC5jGDBxOaPN8km86OusGvDLfGPXVlB7V1R
	2ccYfGMuUuDPl4hxi5/+TDaUT2RHWiktZkC8zrdGz6QsddzvFXgSUoZGZi0vYA4o=
X-Received: by 2002:a05:6512:3d92:b0:5a2:bb45:7f21 with SMTP id 2adb3069b0e04-5a33757c21fmr977130e87.28.1775213733774;
        Fri, 03 Apr 2026 03:55:33 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2c6cc6010sm1397846e87.44.2026.04.03.03.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 03:55:33 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 3 Apr 2026 12:55:31 +0200
To: chenyichong <chenyichong@uniontech.com>
Cc: wangqing7171@gmail.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com,
	urezki@gmail.com
Subject: Re: [PATCH] mm/vmalloc: fix KMSAN uninit in decay_va_pool_node list
 handling
Message-ID: <ac-coy4uxcDQGkBT@pc636>
References: <20260402081413.1896640-1-wangqing7171@gmail.com>
 <B7281353F876D424+20260403075204.894243-1-chenyichong@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B7281353F876D424+20260403075204.894243-1-chenyichong@uniontech.com>
X-Stat-Signature: hjnmbqz78ragoyuya8juieqcjje7ht4i
X-Rspamd-Queue-Id: 15C241C0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775213735-358987
X-HE-Meta: U2FsdGVkX1+ZU3a96PGp8jcEQvu4fpb4LzG7YNUaqg+SPoR4R/1PeigLQ/byZ6qiswmDbM9CeJRrq4PImrPGGtDR5JIX3eyyZo7YrwGKBBxT2Oe28GwDsqg77z0zsjKiu6/IZJVsg7kgQJmSSKqI+KpDKT9LcPVVPWwB/OuOhzZccJInwmfnC3uKbVlY61Kt/FFRmWcehNh9AF2U/y14HgdxaEIhykrcbp6ZqRs3outfnj5xOv3vga/elUvLo1jVRrY5RtdR8w61s8WrALp6+d6XUK20r5v0SkQprbJ01gdDixxmqYaAFYt3YP+NOjdtuaqBY3RrN/Djf4/eK3U2h1n/aYh2ocwiPZjRebA7SkRGubl79B2eirOL4KTdFHCd27BMcp42VkUnAQ6EjXTmnBjXPI1qUoGzCBSRTzX3mqKcP6tnA4YU5cTWtQaRT5+fbcq4+/GFVlf+MSZ4c0+4DqsJtfsoNOt2H7BzdFisk4QTCod+XD9yWUDsg1uWJguLifbvmK72p7HC1x2bRfHLcd5aQaQX86Csi3dl6IpCS1yo7+WhHRLy/gKgsGN544bcuvdtfaF5jf9IjRTJdgpVQ0fIqfxGBcK8NtAlVF97yJnBZLmBdKZqiTZJiNPas9qE3H6FBPzPssn7vLCN3lsW/g+zghYbwZRXYvDU5eS23moa6F2SjIDILnQyNlGSzrzbJQPC9VgY0w0SsBgdbL4IQzOq2L111JOEFd3vqFiGR2d5PEclSSB/hdCFVFr7Ea90+YIymPpsekqRQBG6IaAKz87fScTUaI44diuiqX3IZny1iO1UNgQQZSLDyUlR8lDat/PEC+J11Rn4/aVl1RS2xs6hnLkwRYXJcE9mZplvXbwwwzJ6ztq1wpcxY1IHOMUDmOnhuTOHA06eHXlGP4pqFz4q9HL6gaTw7goVRRnxqoWiT2+Cd2OuEI7heRPmN0L+XD9sTo++98CVXfN3yiX
 Ys5tYHlX
 SZz3YEenaQYoJas2lmDc+rVHONSIzsA7QbabvRkQFeHoiIPSb4oUm9RQEdvmM+mK2GlyAKt7Qcg1HrS4GEjLhnUo/+8iy34ihChiVwdNrM6diZTtk4eettLclRLZnkcCA0CozfRsDiwjh3CbEPUQ1NXxBQGQnJS3v1/KVa6ueIiaKtjbr8+QYuGfWaLpQOsT40N6mxgXwgMBsnyaKS5NUg51lL2M7kIuEmixpeJmjnLTopJU7Vc1QZIHps3gLXryjO5hrRxbwQvQe2gZr63VJnZNpAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 03:52:03PM +0800, chenyichong wrote:
> Prevent decay_va_pool_node from overwriting concurrent repopulation of
> vmap_node pool[i].head while purging. Read/reset pool[i].len under
> pool_lock and splice leftover vmap_area nodes back into the pool
> instead of replacing the list.
> 
> Reported-by: syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=37b7f6cd519f7fb8d32a
> Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
> Signed-off-by: chenyichong <chenyichong@uniontech.com>
> ---
>  mm/vmalloc.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ecbac900c35f..72fb60553a71 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2233,10 +2233,9 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
>  		/* Detach the pool, so no-one can access it. */
>  		spin_lock(&vn->pool_lock);
>  		list_replace_init(&vn->pool[i].head, &tmp_list);
> -		spin_unlock(&vn->pool_lock);
> -
>  		pool_len = n_decay = vn->pool[i].len;
>  		WRITE_ONCE(vn->pool[i].len, 0);
> +		spin_unlock(&vn->pool_lock);
>  
>  		/* Decay a pool by ~25% out of left objects. */
>  		if (!full_decay)
> @@ -2259,8 +2258,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
>  		 */
>  		if (!list_empty(&tmp_list)) {
>  			spin_lock(&vn->pool_lock);
> -			list_replace_init(&tmp_list, &vn->pool[i].head);
> -			WRITE_ONCE(vn->pool[i].len, pool_len);
> +			/*
> +			 * Merge leftover areas back into the pool rather than
> +			 * replacing the whole list. A concurrent allocator can
> +			 * repopulate vn->pool[i].head while we are decaying
> +			 * tmp_list, and replacing would drop those nodes.
> +			 */
> +			list_splice_tail_init(&tmp_list, &vn->pool[i].head);
> +			WRITE_ONCE(vn->pool[i].len, vn->pool[i].len + pool_len);
>
"A concurrent allocator can repopulate..." - Where is it done? Probably
you meant something different.

--
Uladzislau Rezki

