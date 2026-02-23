Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 407BDEC1122
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74AA66B0005; Mon, 23 Feb 2026 14:02:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8846B0089; Mon, 23 Feb 2026 14:02:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6247A6B008A; Mon, 23 Feb 2026 14:02:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BBA36B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:02:58 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDA041602BA
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:02:57 +0000 (UTC)
X-FDA: 84476643594.11.CD9A738
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 10D2A8001C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:02:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j5INVXIL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771873376; a=rsa-sha256;
	cv=none;
	b=6uCiHI2iPb7ZhIJQG1htTrxxZUjgI4lJ4X04aV6EoBomwawwYXfokP6zw2ulXIZjq7s5Kg
	DD7os8Zdt0YCcVU8HewK4pTqg32h1H5ATV6DJ0CiN/v3rnFn7bFfqwZ1xlK0ktmGg5elIW
	UBvpzXAGTwcxNhlsurAZn44DO8hpFEo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j5INVXIL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771873376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1q9OIY/ja79xQZyMwDY8+lmaLB15J8cqbigUd8WTY1g=;
	b=Syrty3IZwwYwBeJaPmbwDvgTDqM++r9LnStbODcGdNz11k62J2KYkrDU398bwWU23ltyen
	252m7J9isBeJ5IJ+Yeh30vWa9+d3nTP3iirTE+C/XGZdmPqE2kp1tYLyH/I673BCU4xNj5
	LyQ4xduVAnu1KYYByz7zU7L8KfM/Z6k=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-674181e5bb9so817344eaf.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771873375; x=1772478175; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1q9OIY/ja79xQZyMwDY8+lmaLB15J8cqbigUd8WTY1g=;
        b=j5INVXILE6Z4D0u3qmHDGqLsSpmHq/OgXix72dyX3Dmn4u/nnzpOuS3ohVicP2EyOg
         0cGWnwqAr1vLK/jbC8e/frniGesZ+aSh0EMMO7/IsZkb1Z07pvdsZlvK861CZef8KrAq
         BXYlDBRY8q5cLZ6HPkT1GdUCEien6YhPZnuQZO17Nvmy4KYWdHb77Ggb42WG03/6rrZm
         l5DMcEiHSjKaVz0ix7EyHE5Ympp8dvXLwGkB3X62BJSgYzLfYD9gSWEmHUg08qJK5+mb
         RWu0ov9jPzU5UVVly2LzhXRiQ2r0vE4YxqFE9ZIAVXszUbDM98Rp57scGhfj5lSdee8C
         AJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771873375; x=1772478175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1q9OIY/ja79xQZyMwDY8+lmaLB15J8cqbigUd8WTY1g=;
        b=mq3kuD66+5rFUBZ/u9HfqF50QoyqydEz48Pmw5XwgWEyhvQAfDmDIRn1otZG1LdT7F
         7/fyrkOqdsOTntwsHVm8Ezurg54WCBgyoOMEWfHZronbH9dTKONeOcb2j+Cg2qez2mCZ
         RiKo2284a0N2FBmCWFUFHX+r4sTxVWS17MYP6LJf2oo5ds9DLS5NRbAR5aaux3G/SiVt
         A1fbokBn82bk9F3Su22G1xhTbTIJ5QiAz0w+JSkYTwON73xTJ1UdiipU/Jll/RfyV6P0
         8zLH7f5hxsMSC9rpi/t2jNYCgCr8J5kyAC7CyO55nLtvWSvPzLeVR5GCNOC7nzR09wwi
         jLuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQf4zjtwhGXuuco8hSYmtAFLIFB5VI/ryXXZjNnDGh64261XYl8OfJsJELt07CVsi1K/1BIASSXg==@kvack.org
X-Gm-Message-State: AOJu0YxXMHAtt2pz2M0x0Ef4Brfss8TEmfkF4VacML0+D2O4rglyKKrS
	LlmTlso7fboKa/v7/BwZbEQELg94ELdZ7RTUjC0NPCiWdlo37D9Z3v4V
X-Gm-Gg: AZuq6aIAi13Y+EgfLP69pCD9jSSEsgEMqBGa5t44IOvwunNizN82mjTDIPEp+F7gWV1
	JEbK2E9Id/97hhX4aTXNYk0iC3XB+j/RJ1Z4ROEqtj+eoC/qNQCBj1UWHaa93XHoejhtjyFEiPI
	5AkxILwQlAmiAJP8ZhAuxwf/G+PLX2HWckkFfAfxhaljt6QK2Xpih0oumc2N3u89WKtLJCadSXW
	PJe0MvJKc0EMkrADWrLk5kX1tvv9hufSqO9o+do1FXT0mRP+rEk9rFbAGOQ9N0XXFqgVlmYZ0k5
	xlQnkC7IzPjYOAUD0R2DGzuBmtXiP8NT93PZnfjLwWGyRVEHyeK/Uln+WE3CK/onskh7zcxg/7p
	GLztjGq/behk0plRcZrdPpob12jTch8wbm/f9d/kVf+nF7WNeRKuMrPnvPaSvkTnHDafrNNizdP
	dbcB1EhfVZB8PWkdAM7Ug+8nFAOy7p4uhzs/X+kQ==
X-Received: by 2002:a05:6820:450c:b0:663:56f:1ac with SMTP id 006d021491bc7-679c424dd9emr4009371eaf.6.1771873374840;
        Mon, 23 Feb 2026 11:02:54 -0800 (PST)
Received: from fedora ([2603:8080:10f0:ab80::1382])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679c5630a56sm7024190eaf.1.2026.02.23.11.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 11:02:53 -0800 (PST)
Date: Mon, 23 Feb 2026 11:02:51 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZykWyxLy34o7PKr@fedora>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 10D2A8001C
X-Stat-Signature: s4f9bekwkk1eufhhcoqxpmzf4gb7kupo
X-HE-Tag: 1771873375-893802
X-HE-Meta: U2FsdGVkX18ZWNxOZjsSz1GTuEM+Vw+jkZmJCS7mEqpef3WB9qJ9QCFJw8nviHcBCo2EJ4RWHxCiG5pt7xhmmAshSPimTAGovUIdz0Da3WKesmycp2S7tmOslPvHZs9tFhBhlU1kaioM5LYQguJShk3mrd1NzSHdFWBIfOu98LqrJOQPew2oNA7vz1FK4vrjFmFiFlU+nt1mAKBfg4ZJ55YHXJvS6vHqOwyuz8e2ebKTS9gcgfujv9a5ImYrklVr5pCjJp10vEs39ZzRcwyOmmpr8gogiDao1YutSK+wTo61csAHlWc+iK1yHFvDlEv8JkT/5iISBa5prWGWVpETBmWNiKEyVX+eFAUZ3FdcCVoVknikzNPRj2Oz8GiBdA+2OHXIBA2pX+GpmBoyczJedzxuCMD1rHzXY2tD0QhGH2sOxamp087HRKMLp87D/OH9oyTgCX9CgxqN0KxHSwSBOp8KvI76OR37ntAquHfduYcEfLz4E9Hsm2Y+noJzrmwAmSqvbK8mUn8eGKw2it85bG0NyDBEGiVx1ifV0YOkq51H0FkU4jOdNspZyl0Mwjea+ZHq5yugsRTrflB8EqahVFiAQiGsOzmamwM1TLLe2SViHDxJCrWEZPKqAFzKjQaz+j188DvpVSzxdKOKTMwJ9n8sYIie6k9F29EI1FYBFlwAvWPPCWh43UrHZckw1W4XLVoqNNFzV/RXhsRVKRykV5m81GtIH/BqRm4Lk9o0L7gUWmGPbfBElS54y3ANPEN1NDAT1Yfl+r4GMfI+xenVYoewq4J1NXF8B7owx5pZODyo3KGM0Mm7neYbscZYajKp+fePlfQmROMmKZqix39WPQi50qfAwzxF04JJIZGYpNJnbNiRKD0u2PoCEh9A0xVcaUGuQvKUKZ/adauIJchTCvSaCRe+o1pr5ZTUpdCbhqndGduqwvJ+j+XcKSykgNUo1GEBNGYmSNMHouNrc+0
 9d1DtKt9
 W0x9NmdBtXXMDgvJAVcexT0tGZGZjI4Ep0hmZ8bjaNgr/8XTo6FB+wolJS30H1o6Cc8E6VGoUyeujJlXJOPSGXPw6RF1lo6xlTXfXKmf/Jg35jOFoxcRvtX+yvagPbObOLBYj4dviJKOhDWPrUBhBxAitOqEIzryENa7vht6dyNVHziJ6v74pqINeNDqKAcz9vuWT3XBe9grLddJDSDm+fDD11TLRI5ZEMl2UCbYKjFdJ6LoKX+uv46C4MA1cVIncjlz5o6UmKFe8Pch0qqc8QaQW39eJsiEE9jDgfPdTX02NnnfJdDPHoGLvWMLRZS7d9/T1N82hRKzmKjFZIEtMT9gtCs6pSwLf0X6aOaex4u/1nX2htBeoopAF1xyRN26rIT1tA5ZEUaaGqxmXQ2/lKz3eYYcRDJ6ks3zz/5yvldTDybf7CwXsIr8+m2ncBhsdZNV09aWQ51hbFNz3Xz0e4Zd/lLNyMsrMuqd4F2wtHCkHP5UVNxm4pkiLM0RkuXVpUzmsVYdGxtpgtIBcN1y0a9GHxhoKD0AYVK1f17X3h0AQuH0R9Eb4M5j4++YNRG1EdIKUXpqekYyupHBQWCc0Tims98F/QmC3v7qdZg/ilC+IP00JbY163CwvbcjUqCE9y/E9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> flags.
> 
> There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> let's add this flag to GFP_VMALLOC_SUPPORTED.

My only skepticism about this comes from the line in the
vmalloc_node_range() doc: 
"and %__GFP_RETRY_MAYFAIL are not supported."

I myself don't know why that may be. Could you elaborate on if/why the
doc is wrong please?

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> Cc: stable@vger.kernel.org	# v6.19
> 
> ---
>  mm/vmalloc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/mm/vmalloc.c
> ===================================================================
> --- linux-2.6.orig/mm/vmalloc.c
> +++ linux-2.6/mm/vmalloc.c
> @@ -3928,6 +3928,7 @@ fail:
>   */
>  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
>  				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> +				__GFP_RETRY_MAYFAIL |\
>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>  				GFP_USER | __GFP_NOLOCKDEP)
>  
> 

