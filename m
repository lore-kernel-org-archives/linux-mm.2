Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B43ACD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 19:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0C76B0088; Thu, 21 May 2026 15:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3619D6B008A; Thu, 21 May 2026 15:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277B06B008C; Thu, 21 May 2026 15:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1636F6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:07:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7C8B1A0751
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:07:51 +0000 (UTC)
X-FDA: 84792361542.08.8898F79
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7877F8000E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:07:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="CmF/2y0h";
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779390469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6X8QxT97XWDwxSQTOa9c7B5Uvcoz36bOQLLyn390AOA=;
	b=Cb8btZanrUF0F5uLiqA1fMZUlr7mxEqcrykgdLP10ceulTBpj4i62hFywtzpFYWOcFFv6K
	WIdbwVEL0l2aqi1J2uQdngokEhVS0XXic7nxUFP3o+ybFaFA0C5ukDplBZkwWYwXSLZSIm
	arhndiPA1nOPTRUgQ/Tm/g3HxszVCAA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="CmF/2y0h";
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779390469; a=rsa-sha256;
	cv=none;
	b=maUdYnjRqlHdbYSXWwE0QF4DwCIEqDJ+hlGEbdlIiARWEM0g8GHhiR/0mMopHzt653u/X2
	WR2Ds0sf401j0eWu6czIFpljksLxtOHFflrAYIsvbRLzFT7ve60wpL+0dF3psLYCRViVSo
	X8H9qCBljvqBsIU30lMHQDSPZWX9GQ8=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ca12973e15so87890466d6.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 12:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779390468; x=1779995268; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6X8QxT97XWDwxSQTOa9c7B5Uvcoz36bOQLLyn390AOA=;
        b=CmF/2y0hZxCE0tvpnaZ3cRx+P/qv2hzRSWEnq70QTUruZaqHXKM26x9L3gtR0mfDM2
         vVoRqaUa7eOueGYcs8hUup7Hq1olEzxakfjKjD+l+vLRCJxHqxh5jLmm7TuCowEaLbS6
         VdIjUNhXXfg+rItRt6fNC2NOeze9EyNjOKSZQpmQIHvAzDCyiTHhxR2yNqQjpVVZ8Gfw
         6a59Nzm8ckykjzRTQGDlUtvP+VpWTP2cVJCS0HoIXyjtfV2RGqZlyWxXHEisiC+C/xk6
         /89DwMTihzohg65t7KSJRa+b3mAkfA8fTD989/AV96OdltXI7meVErARMzTBzVZpwIWq
         Cbtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779390468; x=1779995268;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6X8QxT97XWDwxSQTOa9c7B5Uvcoz36bOQLLyn390AOA=;
        b=ElojzbXDUSN8oq59A4jI3zk5sea8nWaUXMLzQ9g6DPj/EtLOH5M4QJg4qylrlaPiqx
         bVjPhKnC4gOTUSRRO7MFIHqLWA7d0Yno7/PmMmNolw9IOzJnxqB3qt/gOUi8VUYhiUS8
         jREgyAiy23PdlUMQlxgliRbjz3inpxDKj0aM5yx3qAqQXUhWHugwgIWgAHEiDPimn6VF
         bqXtCf77DYdHNMA4WjuC4VWzoa2ER/nYWqzCiH9VlXcIUt9NFRBBLX/URxYSCKS2U0Gc
         Mw3FEs6lqDHvf8OIjnR7w20qG8QYRhT1WamWOe0NteHWjOKMojtRIguRv7b2vbzd3uVQ
         gRyQ==
X-Forwarded-Encrypted: i=1; AFNElJ/GCpra782h23u6eoKIP0TgVUPd2jNY8DMN48FJZk8tdXRabLWlGRtPp7pB0UDPiWK4ablKT7jgSA==@kvack.org
X-Gm-Message-State: AOJu0YzWLttPUDF+6N2ZODLRj7m8qpBISk8flI7Xlqu3+eL5suFgWVkg
	zb4+RYXDEj/oAOyFepI2QkqUgYchpHPq2xSzPRsl+oQw8RjtdFRRAnqfrJvyeSuyN3A=
X-Gm-Gg: Acq92OH2floii0MhiCBwHUr0sFlk7FnZ+6WuHxsKKOKTxUSqsyna7Rkj/XFjcp37Xyk
	zij3kazvnzjR7gIJ3vbGlqgsi8lPGdEnfxka8ArAxrsFeIlGBmECyLS8lv/MXDZpGR9+0dlJzSr
	PonGu8Nlk3LqGEAiBKR1phz0eQuc14DpJ+fwi13b55gZqnGFntKoOU23K14c76rY1pmTwwqE5FC
	33N+INlkGsohouJbHXEnQ2vucSw23lYQKxuPJFj6XFX0aOopLdHiGp7n0hO/ZFAIKrz3+A8ihmu
	mwKF+QV6SFFcXgcZueGAq0HX02iCKQK1D/tMrQ/oIGRa6ZHa3dFRUNUUu5WPUg4NYwwZeuHFhE/
	t9wkSb1Fa4R6U5T5l/HUTu9aHejuY2bEXccgAdNmpSEP8xXsiTX3cjAYoKtxzAj0anbVBPTpF+E
	vQ5uG1GGhMvdXijRdk29s1uLswH4YW5R8824Q+9VP4gP+IYKK3JpUEoQfPmoABsA==
X-Received: by 2002:a05:6214:3c89:b0:8cc:611f:197f with SMTP id 6a1803df08f44-8cc7b69fb91mr10772426d6.44.1779390468578;
        Thu, 21 May 2026 12:07:48 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc7680906bsm12968866d6.0.2026.05.21.12.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 12:07:48 -0700 (PDT)
Date: Thu, 21 May 2026 19:07:47 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: always print scratch sizes
Message-ID: <ag9VrVW3E28UOsAt@plex>
References: <20260519155324.2692594-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260519155324.2692594-1-pratyush@kernel.org>
X-Stat-Signature: 9qzrg7dwri3zoxrrek9p135ifqd59cn5
X-Rspamd-Queue-Id: 7877F8000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779390469-565647
X-HE-Meta: U2FsdGVkX19MDDRHWavDmx4Yy0FDKys1yGQdi8xxUqC4PtF4E92xIgAu4rthIyQIz+5mXuWbsiP57wYCIlWbXXIYckE610V2bhjbXI6jWUOUSa5OZ/19khitDh/4gik6skzCGJIIIE7yw/fFU1iFf0hSV7xuoBqbpSUY1C6k58kBi5qNUfOT8+GRzHSVkTusrsARtXbkYH3m853T/XlVf+Oav941L7a9susX+y6oY8tDaKSUuTmcjEGeoKWwIo04jAUeT1OK4407ISf6ZY5blCkahvnF4rFR6C0/hI55bjXdkUQy5ZxRJggINxboe6DbekNUshXMVPI8zvp791mG6nHMtpqJgcDLfawOoAawRK9ot88WmzdQR9GDrkU9vkqc255vozDUGURPog86aRkDAkavp91270z03NPMmqMNEoEuLT/JD4mccONWOJooCheTxNRVkLAG8j/JL64/3CWoMWfcREeKF31dVSA4hP4LMte/HjoS7xSeBIoU9ueZpfz07UZ6udOdZuYM2t9fPbMl00DYmDwVSgT35EEYiDyiJ5flCI1ySLrDsXbZZY9T2gZDzONJuduc6hrQc99c0VtjSK5urcPmKdz/42fZmQloukoD5gf7diR1h4hW7y4NeHXYv7yU7wLmlFRidmAhbM7gR5vHKVR/zuaXb7xFES5nokmDvEbA6IDrAflXpoQpHz6QGGH4i/TeFG+QCQWDzrbSR8PoJau53lHz0/m20lBd5IJRSSLXn1pT+J2YKJW82MQmydrLq2LVpArdYM7Mkrltx8rmqtHAfT0TYhc6X1WuUZPAdRVC7IANY2qOABgdeNTMMmlYyMZDdZhfbwyYT1jad+l8wi6eHnLY+Mm5AHoqQ/6wZBSua2gIWn0PyW+1m1QVQK1wdwHTkTQoizPc2Igl0SZMGTTRkSD+WQCUpAiusxovjKrThAcr9TSWZyuo6o/SObLqe5dkg4+D4/pA/IG
 RiYEl5Yq
 iaQCbeo9TDtc5RxT+u6MzHIdeNG165mzGY1IdQykqqts7XhfVsj540e5RTT0AxKlrT0vYMrCP56NL1ZCmDJmy6tt0ot/7UmlWos9Hid9mv/SnXoHXiSe4dSVRQXd+0nK0gPkZj1l5WwMWj9rd0ES0Ro8OfDzD9m3aY77iBUqUQQkKuktt4CeOhL+4a+fkAwDxeMt5eFaH1irlp9hPwttEPK3Z7AIJKyhW4kqJV2ejWxpIc8hO0AhoeY6BwmQ6OSzyIMfZU+NpT0JK2bMg8nx2Fg/dnAa2BwxogvT/XYX1EglDUEzgMiiuuTLGi2JLfrkYx/Lw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-19 17:53, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Currently, KHO only prints scratch sizes when the size is specified
> by the command line. It prints nothing when the size is calculated
> at runtime by counting RSRV_KERN.
> 
> These prints are completely useless. When the user specified the size on
> the command line, they already know how large the scratch areas are. And
> that information is readily available by looking at the command line. It
> is a lot more useful to know the sizes that are calculated at runtime
> since they can vary by kernel version. Plus, if KHO fails to allocate
> the scratch areas, the calculated scratch sizes are not available via
> debugfs.
> 
> Print the scratch sizes in kho_reserve_scratch(). Do it before making
> the allocations. The size can provide hints for the failure reason.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 33fcf848ef95..b030f53f2235 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -621,11 +621,6 @@ static int __init kho_parse_scratch_size(char *p)
>  	scratch_size_pernode = sizes[2];
>  	scratch_scale = 0;
>  
> -	pr_notice("scratch areas: lowmem: %lluMiB global: %lluMiB pernode: %lldMiB\n",
> -		  (u64)(scratch_size_lowmem >> 20),
> -		  (u64)(scratch_size_global >> 20),
> -		  (u64)(scratch_size_pernode >> 20));
> -
>  	return 0;
>  }
>  early_param("kho_scratch", kho_parse_scratch_size);
> @@ -691,6 +686,10 @@ static void __init kho_reserve_scratch(void)
>  		goto err_disable_kho;
>  	}
>  
> +	pr_notice("scratch areas: lowmem: %lluMiB global: %lluMiB\n",
> +		  (u64)(scratch_size_lowmem >> 20),
> +		  (u64)(scratch_size_global >> 20));
> +
>  	/*
>  	 * reserve scratch area in low memory for lowmem allocations in the
>  	 * next kernel
> @@ -725,6 +724,9 @@ static void __init kho_reserve_scratch(void)
>  	 */
>  	for_each_node_state(nid, N_MEMORY) {
>  		size = scratch_size_node(nid);
> +
> +		pr_notice("scratch_areas: nid %d: %lluMiB\n", nid, size >> 20);

Please use a space instead of an underscore to match the other string: 
"scratch areas". Keeping the prefix identical makes log parsing and 
filtering much cleaner.

Unrelated to this patch—this is something I brought up to Pratyush off-list, 
but I really dislike the 'KHO scratch' terminology.

First, it isn't actually 'scratch' space, as the kernel relies on it to 
allocate crucial early boot memory, which it then uses permanently. 
Second, we cannot preserve anything within this specific region. 

Down the line, I'd like to rename this to something more descriptive that clearly 
conveys both its importance to early boot and its non-preservable nature. For 
now, the print adjustments themselves look good.

I do not know it should be, but something like kho_bootstrap area sounds 
better than kho_sratch area.

> +
>  		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
>  						0, MEMBLOCK_ALLOC_ACCESSIBLE,
>  						nid, true);
> 
> base-commit: 34e8f02817e31826e76bb2ded48bf28fe921f20b
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 

