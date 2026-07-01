Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C58C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5976B00AC; Wed,  1 Jul 2026 09:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE0B6B00AD; Wed,  1 Jul 2026 09:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04F46B00AE; Wed,  1 Jul 2026 09:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C72CD6B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:52:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 459F41C720C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:52:55 +0000 (UTC)
X-FDA: 84940348710.14.CE41CC0
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6078B14000F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:52:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=aq6qsf9M;
	spf=pass (imf23.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.219.48 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782913973;
	b=HfEfScXRU5M0EvgA84hZXjn3/ErBk9Sa/JYYCVobgs3tybzzwdVTU8+RR34JmwN17Zd7pI
	v7AkHHVzHUtL16FlxtvXrtupb9W5g3Ft2NHf4Z7Gb372llVQ5+eJgVkflvZatVpCHakO1v
	gafinBEhCMypJKvf5w74KE1hoV8mOiI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782913973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9jTQNUhONnvzwaACiiAR+1wKZIRO/byslWAp9/FPB8=;
	b=u0Mo8HWvR7PmSJqLbHMtt7CllwPeExDTwRxlEpa0SnmvpKrXEWhTjYJ2AXXvchBVjOFTs1
	uOUpi+pKgP/8JtWTbvVcPZzBaS5SdotZnlW5rTg8oy/6p52ccxQ1IN3F23u/LgEt8EGrbG
	fcXIn/favXylSWKydThPBB7lgptnfLc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=aq6qsf9M;
	spf=pass (imf23.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.219.48 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8f3cbaef818so3665106d6.3
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 06:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1782913972; x=1783518772; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b9jTQNUhONnvzwaACiiAR+1wKZIRO/byslWAp9/FPB8=;
        b=aq6qsf9ML26KKR0UEUBiaqjFAPDUh/ZFX39+aFryUllixJqJIqdo7yzq5Sf2+7hX0C
         jZRLTtfqyKbaXJa916y2J0IpOZzBfdh8XsK9DIchSJoCGu7Kufw3WgZP5nXYYnfO/s3R
         GoGIHIug6C9bYWkocXxh0JoqskODeQ1BlSb8u2RC1WCl4tgdjKvLKDPgPvGJaRFzDf/e
         pebZVY/P/TZmM/9RWoRZ79J1qdh1WM8QnBROMaWgvv4uO7gr126hwNmedfcj0iK0Om1A
         gngXbzSERiJg3MTR9WtqdIlfz6pjlMGktK8i6cQT1fYxNxVme5RXI5AzRmVtMw2IQe4l
         TmEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782913972; x=1783518772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b9jTQNUhONnvzwaACiiAR+1wKZIRO/byslWAp9/FPB8=;
        b=Cqh2RTTm5sjrerMN0aFxCVDYrvM5sJrfyocmxJX8zKFoQ/k78TVEEoe2g89RJzVYCX
         8qnBzap+2dqQ1GEvWKgyOcFSr/T/r0VtLK1DaAwVYhKrgCyEQLxzvJvD6DBnl5ZFSJ8T
         jYtHWNhAfjU4FraDY2xz6l8UHG3k8ieZwfbZcbhUlf61dM4Ie6UBbemGmhrOFBV9+j60
         YgMCmUXVXuRXZV+wG2pDnKe6mn6YfQ5rcDyHklR+KhJp0Q6pHOL3rtfIMvHPVxGSVlm1
         iW3k50vjp4+0G59H18WwiGB0g3M0cBntBuaZrrMW4c7FQ4aYcQoKMcwlo8TXjfb9uX97
         oFFQ==
X-Forwarded-Encrypted: i=1; AHgh+RprAX6NANQRl5SM2Tj/vXayqE/mZorcT3vr0EOKgsHcKl0/wCb4uWNLfyHPrqNd09MgI1pBZMWmTg==@kvack.org
X-Gm-Message-State: AOJu0YwwxkoeAoPpOvNMlc2ThHvfO5v8JptzS9MFScU2tHhiP8Epfwse
	Z5S61Eo/Os6tC2OM4hkAgF7uR+WeHeRRXz3wkGD/AkxLKDg+E67uDcjwAIqCwhiI1w==
X-Gm-Gg: AfdE7cn2sZ4iVR2RCABJolLy1O65wpiRBY2gzY4v1CNsTxQ1kswzhzCOhFjXFo9jLfg
	uJnKV7DwVo9tB+ssYeQFbRICwJxLu/W1QSXlGp+1djm3LD37wKafcVokfqOeNauTNMxGw6yEGub
	IB77BqkT3PG3yTFtow9EUqlibBOUp7Iw7BFQ8YXkZ9REbZf80sZi9DjNYYK/CeCQrI1tPbMw9h8
	cJMLBrBmxdrQ1egfkqQjA1HmGI100u6qe7JqWD7iyOfTbywWJZw2aJTx2wz+gHUxqiBhhK99CRc
	dP+VjDbUzvy8J4IXWh7+yodDEu0wm0qKxER+ZpmRAnFl87Xxfkm1a0iKoIrgbqzxD07p9NQ6rRv
	7Tt5293Zw52kyRwPg8nCakSOncBkVvtOJKFsqIXQ/ESWjAz8ij6SIMA4fvrlfZF5+R400Pq92AY
	2Fqfqxg8p1Lj3+/zzlgcfGRVMSEkYHirQ=
X-Received: by 2002:a05:6214:18f:b0:8f1:8737:d794 with SMTP id 6a1803df08f44-8f3c6dc8a06mr15433756d6.16.1782913965137;
        Wed, 01 Jul 2026 06:52:45 -0700 (PDT)
Received: from rowland.harvard.edu ([140.247.181.15])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f35e88a4bfsm22400436d6.8.2026.07.01.06.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 06:52:44 -0700 (PDT)
Date: Wed, 1 Jul 2026 09:52:42 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] usb: host: ohci-dbg: use kmalloc() for print
 buffer
Message-ID: <4aa114fd-ec0e-4e7c-ab9c-6e9a327b3cfa@rowland.harvard.edu>
References: <20260701-b4-usb-v2-0-272807df4b64@kernel.org>
 <20260701-b4-usb-v2-1-272807df4b64@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701-b4-usb-v2-1-272807df4b64@kernel.org>
X-Rspam-User: 
X-Stat-Signature: x7jezj17af3srrgrygeg5pbjcjwdryjy
X-Rspamd-Queue-Id: 6078B14000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1782913973-94954
X-HE-Meta: U2FsdGVkX1+DOUl5YWVoPnJAyOAh/kcr8cRLGK+v5gH4bDEIU8qULtMgQM/PLY5ia8yCH9VPr4x4SVvffuDMzLXqTme+QDoo8dcZ7KVZAH/RihXGnP/LrWKZ6z8ePQXPqHDqLt8kcDY36e3qL7U+4faKrMfbwgyS4XKwzxteJAI9uDQ16jJgtq3wj8fiFGWq6Vm779sKjatG2JqfGwnl1SvhQjGkSOQr8/7Z6/sGKz+OTgr3LSLzGXQae3tzy1xxWk/jF8S9wqGWhUikgMO57jt8HXS5X2/yiRP3lXQXPfL7+QIR+6B1j8lIomKQs4j3uQj7LsBUZ4TNEDKELO0Bwcj1CpuzLeY7JWjjCzl0rn5Nv3FkB7kJjOfVHRN7IAPbu3yW9+HIo9orLDP9UBhLAYoHwhdFRbgou5d4vGLoqbqpBiQaLZFmfraLSq/iVaSJoTbsMvQhcBJy9sd2QqMLbL+k48Z0KFH7cMHxYnuWSmMZdbey9qB7T0m39X/GRpkh2n2AQbcTZmMBQ+WpbTG7ypif9tpZE2mPKevh5mvnBJH+zZH+wTjMyEuUk5XHsyj3hVm82gzk6By//oj3RTuPckC65K2dtAxyvNtW3hJ79WxkQSF+zYt5KhPZb2c6wTOUXjQhtd6ieldzZR3gwkdbNihyWL3Nax4iFK4Fdsn6375PPtjvF6c7D2aEqh+P1qQ3xWPPDmkPPJsQkr4yiGmNQITvdOcToXTzCCjDp8v84o3vPZeb89FwNtP9U4J/6+INvmzNlNoGmyD+DDdb1vymJ9y8TvfP0jvCYNIjAvXkTQh3QDPMzeZGjvKuh8x9ymKF6MpiiwPfZsiFI6GFSc1v093zsvJAvswTKP03gCdpxJmbp3J1Te/JfID7ch6i3bw2tJgwwYmpyz9rnh4pLh9QHHoxqnDD+EyOHhvzcyaciqFH2RMYlm8pEAhfSkgwI0MPzVf1ueKYkHff4HS5bYq
 U8enKUTx
 UiwWkwZjsflk+FSJjji+z4MWhxTn2pM2YTmHGvdv/yy7b0O41HFw/pYvrv5Amp/E76k4sHjLvJmjj63ioZqwfERb+zW1FZo/HMdcPcuMLX46XHjluXu4GoziexGsDKmIQZ9ligiNwgrU8XIJIefOHCzn8o9xSfQsaR/Gl7VYXp1ICUT7qOKKzdjoykxXlDI9Rz2LhR2/3LGdxJTWJur0TECpB8D/WJv0XftXQy2Ud6sMVlT/sZInFbaQ1e+bG0d33ao1RUBQP5GcUqRBfYmYNIT7lGJuz61E4A8Gih9la27qxwNDbqTtbEzItVjJvcaNLISxFXLiYfNTygn9teVJv4SBZmi1g+Xd1pR+ISnLoz0CfZOaXQMmX+qKL/5oFuu7lPHEADIaBewLeYTTxcAGv5Pp2oDQkVn2L5YUSslTSe+4IjtnXA09h3ph07Z/ZKxl1w8dAfEQariqbw4UcvJ1ft8yjngVD1U5IxVQteDaShe8K9Sk1t1xq5ctg+XZ4TU49JRHZ0UWnRkpG+qm2wWulktygUKGm18KpISMC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 12:41:50PM +0300, Mike Rapoport (Microsoft) wrote:
> ochi-dbg allocates buffers for formatting of various dump outputs.
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
> 
> While on it, drop the NULL checks in debug_close(). buf is never NULL
> here because all the open handlers return -ENOMEM when alloc_buffer()
> fails, and kfree() can handle a NULL buf->page.
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>

Incidentally, I filtered it out of my reply this time, but on this and 
previous submissions you have a CC: entry that says <rpppt@kernel.org>, 
which is an invalid address (three 'p's instead of two).  Is there a 
typo in one of your scripts or settings?  It's a little surprising that 
you aren't constantly getting email error messages every time you send 
something out.

Alan Stern

>  drivers/usb/host/ohci-dbg.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
> index 9e0e06bbc570..23dc9eddc06c 100644
> --- a/drivers/usb/host/ohci-dbg.c
> +++ b/drivers/usb/host/ohci-dbg.c
> @@ -683,7 +683,7 @@ static int fill_buffer(struct debug_buffer *buf)
>  	int ret;
>  
>  	if (!buf->page)
> -		buf->page = (char *)get_zeroed_page(GFP_KERNEL);
> +		buf->page = kzalloc(PAGE_SIZE, GFP_KERNEL);
>  
>  	if (!buf->page) {
>  		ret = -ENOMEM;
> @@ -729,11 +729,8 @@ static int debug_close(struct inode *inode, struct file *file)
>  {
>  	struct debug_buffer *buf = file->private_data;
>  
> -	if (buf) {
> -		if (buf->page)
> -			free_page((unsigned long)buf->page);
> -		kfree(buf);
> -	}
> +	kfree(buf->page);
> +	kfree(buf);
>  
>  	return 0;
>  }
> 
> -- 
> 2.53.0
> 

