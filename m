Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9692BFD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB61D6B013E; Thu, 26 Feb 2026 16:43:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DAC6B0141; Thu, 26 Feb 2026 16:43:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA296B0145; Thu, 26 Feb 2026 16:43:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 971346B013E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:43:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DED61B6FEA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:43:43 +0000 (UTC)
X-FDA: 84487935126.11.6790854
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7AEB7140007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:43:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XOzpSo6t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772142221; a=rsa-sha256;
	cv=none;
	b=V1WdvkRZX6FKsV8an+uYh6AXtn5dbsu1xbw15i6z8zXXI9tHLS2+E/gV68S1t+qfZ3YU/k
	VszlemJfi5J6o/C1mjvmd79Np5thwXWdVGsSlgT4DpllPQbbljlrjF/u8yrnwDpLYrdMNN
	IzdoZM069WXH+q7WXtnEcgqWCHWZWo0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XOzpSo6t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772142221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YemIJbaT8kVRnq52OlqB85TuhHJUc8NZS4+MR2RkKxw=;
	b=6W3AHEyfkUMLBs9d+ErCxu8vMO5BEIVBRr6iVJY2DG2rfer5IOaZInGyfQyq+GOWa9NmHn
	uR2Qms85bX7pGqqQSZ0ulMb9IXpnjsbAp5MYJx0DkAVo80duKn2Iw4D8y/pA+feqR2O0DP
	FOLrNVstxif1RgoTP6qpzNX48O0EmQ0=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d18f80b5c2so1363062a34.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772142220; x=1772747020; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YemIJbaT8kVRnq52OlqB85TuhHJUc8NZS4+MR2RkKxw=;
        b=XOzpSo6t2ktqmz5ovV/GPUolc8hKQWJhNT9E0XCcJpcYVLuvThkLV+gjvojO4UNI+V
         gkukxmgdGyZpHfFrY8trn4yHx6Rtw67UkAWwNVVHJb2xgzSLdCl9zeYPCsCgdZ1AMVf+
         6OLuBNbqrfEhIRQdIoRyry+T0MbpkCMZqHQh4o7cNesVSxRa4P2hXEefGglqgQN1/iRk
         u83xvOkp51efi/jkJS4WLV5rbuwlnoMgCrt1pw++Gq9qDFDm1x2xjCj2BYygBJkqSI1+
         IdZi9tmzhwfh4uDLtFwJjEgil/VpgKhJMQ2hWzH+5R9XCoYeOSB+AMjq/f2+/wpGVqGP
         CLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772142220; x=1772747020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YemIJbaT8kVRnq52OlqB85TuhHJUc8NZS4+MR2RkKxw=;
        b=DuJjZJuB3PEcFq3DyTQ2//AYDAebjNl13QHRgWY2X1I2Y2wgK0fjMNGK1EuIfnaihT
         NsAYh7FK69JaaO2pSK2tXfpbFIbYk46qlxWYhTA4UPVe21IVnd1e7vgEyzB/nQvBMPRk
         o5XeY5H5Uyjeb05Q14NpFBMTJ6HwZLsVm+92zA2qMFccF4cnzonStrCe9pMoXSflUgSg
         2TTr7FssOj34hRSCND+2bZh1xcp+w+CVJCFrcZI2lEB3+34lsgzX6mX6Df41W3yuhL+J
         NxFmm+2JDq/7uohc4NkJb4tUmx1alZZEXwY6pGWpQNYFUUdr+aEdcc62ISlOrRldV9jM
         k49g==
X-Forwarded-Encrypted: i=1; AJvYcCWY657IyhOSV1MhkCcW4qMcO2TcFhoyf+FYa0gSeAaUSBv8C25b4TPU4j5VqbmcGn23xC9mIrIL2Q==@kvack.org
X-Gm-Message-State: AOJu0YwdZlqrkcYIEO4ppleqXCFQ/Tc8S+U1ei6qQouQ+N2s4GhMB/NK
	GMN5NbW638Zx5wUDeFTBPvz6jZy3iZeNI4J/W0scoZWBR3XAR3EKvhJs
X-Gm-Gg: ATEYQzyp0QpmpFHXnL4BgpIfaFc+U/xseKBXiS9SAqu2spJarqlDdhxTUK8kd55prGM
	6oeyzFDSN+0BwCbaHvFdPNHh5QwDfc2Hp37X5iWBMUdRFwEyBp7qQ8mjxvVXHrA/sfvlAyVxOk+
	Ms2eMdF+7CxkjE4arsaxfGWmyDTPvSHCvWvPOEBHCECsmSiwxdqFczFfdUTh79A4u5MA8KWeiu9
	Pt+ZZIEdJQoXNLosQQkfWqqeh0KUPv86tod1gdBfD0Os/V6iDo7oflqfmE5IJ9pB6Y1XhjvrvYg
	JIgGR1xLgRASsyDbVtZgSHCLR7z7uLVPEWdo3j/RAMxBaY8R/iBSHUVbTVgvtDXkPghuEv0cY5B
	dLMocPtZrGlNnJ6TjNElh8GOi/2zGbFCEo8Gj0u0MCqIHWOj+fLVenUyU/v2L2Kci94prmeW3Af
	9E9FV/jt2wLXaUThaqSF6CUw==
X-Received: by 2002:a05:6871:8908:b0:415:e487:7f29 with SMTP id 586e51a60fabf-41626ef1464mr483310fac.20.1772142220184;
        Thu, 26 Feb 2026 13:43:40 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:74::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160d211b82sm2755448fac.13.2026.02.26.13.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 13:43:39 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jens Axboe <axboe@kernel.dk>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 3/8] mm/zsmalloc: Introduce objcgs pointer in struct zpdesc
Date: Thu, 26 Feb 2026 13:43:37 -0800
Message-ID: <20260226214338.1062367-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aaC80TsqmKpwFzQf@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7AEB7140007
X-Stat-Signature: 4pgh6z771xrm7a4n869h7ep9pt81x9a4
X-Rspam-User: 
X-HE-Tag: 1772142221-740084
X-HE-Meta: U2FsdGVkX18LDzVZw5PTRvXQRRCjDbCadH+rDyxmiL3EdBloz8mxLwNf+0u0velbzOcPHj8rrYnQsuXQjlP+suiN5JZfMQ5z9ZCfBK5hvZpwlXWBF2bWIhwcUsp0GoR9wBLLVyDwM8d8ED1vonDAWdT16t2zxwwQp0kXxPGggJZ7rug4OmEpOY65O9ZoA/exrUmYK9SGbAt7qodlp+ZvWdiY4QNRTdtomUOspQbs+Dgh8C64Sje2yQtuC0u5SPN88DGDAv4xSR/zzA6kQdUjcqsYBCEPTXOR6g1M36/es3lwX7HI2sSE5yswXLY2XbWHJeD/6DgL9sUSaSaN0LCd9Q1RwcDZwlK6YUPgUdzRxJP39fJJPfWRdK5KYbWyj+PqCnHvAVYT0nVO3b9j+x/h9GmAl91AaPuwzRNVKnAAgLxeBu82S1NzJIT7jsy2d9REbohpJHy4Ph82K7RYjQmV3EDIFED/gmjCiIwsM+tMtl5ADBSLbbXbPSN+ohuIIdIXvYOOLKe9iUxJUnG/msCHgxYbh7gcH2y+nA+Q/sPzXDiRFQBnd7w0JhkwpH9q31HDJmfd/q1xByCfp7ri7n7eOY6F9o+7JNcIhW5g9D3LsXLO/kLnASHnGn9qL3IcE2cOEOqFVezcBOAbqG9bxfmLdEgR8IpuNBsgRoEtYENFjdYXNs/Lwuer6ZiAjfAOVcGsXTwWAtbHUBEbcY6tM0Bee7DNvXRRcD9T8+B7imDZ/zat/GIpg5hIF0s9Aw7X/iItRICKp+YLcd5xSrbkyPbe502KsGudRTZpV6tnCqDBlaJAbVhdNYNpPCxalCh22WJf7a6PDjpkWjBv9LqL3V4o9HRIssbBMrUAbZwpXcfwAj89mY6kTiIZb7VA5iDjh0mxYGbTaR77jkB/W/WyXyZ19QjQNszZ9QUebXGAqNahJzOVqqtVridkrC3p2/yv+NfqS+4Z3As1NtT5rwPTgk3
 UlRhNzEL
 EiK225joy68ziskRdZJJS729UeJy1C69SHIJ6eOewr7jmSNctAjXIpA75oilR0hWXJg10W6Tq4D1qs/S7gfSUn1L0EX5j7S19H4AVgLEuQgoWWPM79cBX3C/0LrLkznWN3xZ7GS57jndCyi4rZTPbyKsgmMBk5ngsb9FjybBNex8VKSjiabAn7XIcMVphANW51T9lLl05BfsPH3oI1ejW84yPMvQyhaWWNm2bkWOAnF9b+BnWz51JKDFesEe6EfSzqpmD/3TvvMbdCYC2Xx3faTyrQF1TJxEyfVQmCZUkBYQXKEBH6VRk1UtYeDWLNOf13iXPZQJj8Fncr4RMqYjO2aUgOtRfQekAh+0q1Fnb+NQVxcV7Tyoo3OZ1tnveM65Hq+yEI8R3/x1SBMaASqYxcq5GyZNmXl9T194Aq9ub6SG9Qp1hUCI2kWI1JH9kkJzBd2W/YyCzEcdqlk0uFfl6DtCD0vbNzmYBJilNy7vVkSsYBe3EhJXiS3NSpfhUzRSUj0k2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 13:37:42 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Thu, Feb 26, 2026 at 11:29:26AM -0800, Joshua Hahn wrote:
> > --- a/mm/zpdesc.h
> > +++ b/mm/zpdesc.h
> > @@ -20,10 +20,12 @@
> >   * @zspage:		Points to the zspage this zpdesc is a part of.
> >   * @first_obj_offset:	First object offset in zsmalloc pool.
> >   * @_refcount:		The number of references to this zpdesc.
> > + * @objcgs:		Array of objcgs pointers that the stored objs
> > + *			belong to. Overlayed on top of page->memcg_data, and
> > + *			will always have first bit set if it is a valid pointer.
> >   *
> >   * This struct overlays struct page for now. Do not modify without a good
> > - * understanding of the issues. In particular, do not expand into the overlap
> > - * with memcg_data.
> > + * understanding of the issues.
> >   *
> >   * Page flags used:
> >   * * PG_private identifies the first component page.
> > @@ -47,6 +49,9 @@ struct zpdesc {
> >  	 */
> >  	unsigned int first_obj_offset;
> >  	atomic_t _refcount;
> > +#ifdef CONFIG_MEMCG
> > +	unsigned long objcgs;

Hello Shakeel, I hope you're doing well!

> Why not just strore struct obj_cgroup ** instead of unsigned long? You will not
> need to do conversions when storing or accessing.

Yeah, that makes sense to me : -)
I guess if we're going to be accessing it with the zpdesc_objcgs and
zpdesc_set_objcgs helpers anyways, we can abstract away the casting to
unsigned long and re-casting to obj_cgroup pointer away from the user.

I was just trying to skip one cast, but I think it won't matter too much
anyways since it's always hidden away. I'll change it to obj_cgroup **
in the next version!!

I hope you have a great day : -)
Joshua

