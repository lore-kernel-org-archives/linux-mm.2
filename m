Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE4CCF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 02:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8068C6B0092; Tue,  6 Jan 2026 21:06:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B46D6B0093; Tue,  6 Jan 2026 21:06:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0E46B0095; Tue,  6 Jan 2026 21:06:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57ACD6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:06:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4D6E1ADCA5
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:06:17 +0000 (UTC)
X-FDA: 84303527994.22.54498D1
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0FCB7C0002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:06:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ObUVfb1D;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767751576; a=rsa-sha256;
	cv=none;
	b=pVlOUNfQ24y48AkUpD0qJjnMhfbhrCAQbHM4LLTJqra6xcSd9UroyWDP81gBb6p0bUl3lx
	LJgSmXSIhjCR+ZFb2JPbYB1eqkdcXPTAHK8Q5Q3u8igx6gx2Tcks0t80VtGJ+CW+IFiw+k
	gUTh0kzMnXR/SOb43I1OglDyh0TFYxw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ObUVfb1D;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767751576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8u+GfL9+f1hnMBnvYrDQmm8OyJ399gzv33UC/xcQXvs=;
	b=Zm+S9TmHZ+5RyfiKhPdqlbC62o69e7gI9SFflPAFaCIl5SYXoQHkCD8cwkPkK/yfmqs3Ul
	dfwEXqgtGhRRMW4Bd7HQihC2QeMJN0rM/p1fnj3zHKpJXYIYr497nZ3vZ5Xcr+erysld9o
	+dfMtqHiSw34C1FdG3NVW8C/8qujiK8=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34abc7da414so1181754a91.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 18:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767751575; x=1768356375; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8u+GfL9+f1hnMBnvYrDQmm8OyJ399gzv33UC/xcQXvs=;
        b=ObUVfb1DvmDVPyxJnc1pBuzd7LapyvsmKEUkhZvhnSzmBqHr22ZBzbzHiOaK6VchYq
         CZEXCr6ClqsuxljOidhRg8DTt1cmiiyJb93kfu77a1N2Eb0/fmYSEeoJ0eFYfLldkQku
         E33CxzhQ6ceHFA4weiEhKFZ2nr7/S/1Tl0QL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767751575; x=1768356375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8u+GfL9+f1hnMBnvYrDQmm8OyJ399gzv33UC/xcQXvs=;
        b=YIOOOAijOeNamN9CrkmjfiuF4B2jYrzXJGPtk54ofdncJaBWAksa5cYF9WQPJfG8YQ
         q7UxRCYRiiKjHRFQvx9Kv4ZoN1d/CbA0+FlA79T9qjGYLZw8rFCTm+2GLOoGAM/Ywg7J
         xCRYXLClCF4g8bbuIH/lwJVf/IG7oesh6t+gKnJ+6jvkuRfUEaAe6QLqPAjT1TKtHVQw
         yMEn8uJCzolNmBGfisc017//17vim6ZiXhBMcbgXQL3VzsGJ/90/s8jqK5+3Xr7yFQ5U
         1bXYRJh634A/wSr7efua9XCKv/VRq6e5h2+qRNNlY8GBNR0M4AX3PPgeEi/MuZr0WF+/
         hzfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsOOcRxF9lzTDvXsX50kIwBcd8FyoEfaZMTn5NeAtz0ZRmDEvtO+tFSfacDX+3tv2T3DytWnDyLQ==@kvack.org
X-Gm-Message-State: AOJu0Yx7Xu9v5dVRdfffdgG219t1T9pgGBSfn2ISF/sGr3BjMmgpYULK
	dgcn7YaJOo200cWhIbe8bjatOFoZW9p2/98HF+OYOshjkNGf3p6WKQdIJr7Zh/57rA==
X-Gm-Gg: AY/fxX6VpDuEeLbRmL9FAdD/tyDZWLRbtbcignF24UNId5i7uQtzRYzojyT+5AOu4Db
	/zmjM6Q3pYHx7mkIcc9puV2UVbL0HoBFjP8IEqX1kQtENPkgOPdL4g3W3uZ8UJQmUwD5fsqts02
	asGEhVM5EnnR3s1SaP8TNsFVa12q3DbUpk6vfSgaSTHfNsGAcVhfSF7l/u1iQAYh+IzgULfSg4d
	CfEo7jPjYYNRvM4fp9IBGj7Jn9JseJmDqlpjU9H2g2nBqdz9W9jLWVQXzvdQmY7TbX2ot0HO+AM
	0tVmFA6VSxOhhQALe+DJWjdpH4i3w7g5gBvdKYY7E+idsO31nELEoobs6UmXNrrW5V5kW5IAqvq
	hA5OWqes32ydoBaTh2AB6kDUQPvW3lvaEqJUDo8v1xNZ4aTFjZsvB6N4sdOpUzJqoyHNrFD4GnC
	tPUjQl3ve+jGQJ3z6Lj2tBTyj/Ql9TFhZ/M1Uo0GTejYlpWOI2FCc=
X-Google-Smtp-Source: AGHT+IEI7B6KDKiDTTfWYR09nfDyFXIiEhtBo7OO/gO2v/9Mii5a4/apkstTeguv8kwYLgLik0Jpsw==
X-Received: by 2002:a17:90b:1d01:b0:34c:a35d:de1b with SMTP id 98e67ed59e1d1-34f68c48346mr994451a91.37.1767751574914;
        Tue, 06 Jan 2026 18:06:14 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b13137csm39069a91.13.2026.01.06.18.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 18:06:14 -0800 (PST)
Date: Wed, 7 Jan 2026 11:06:09 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
 <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
X-Rspamd-Queue-Id: 0FCB7C0002
X-Stat-Signature: by1yg4ntkha6dyr1ha96x4u67ffyaetr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767751575-843147
X-HE-Meta: U2FsdGVkX1/g9sr3ZZ4s9B0dRm4DCCqp3qSIuikvHzieRP5Q05M0JFpY6ryRI2z78O9ZdhXDPs8OlIQotqUUn+qEKrTGauxLyJEYwczoj1ttjLbP9NSSzODbRKQWahvQLlDjYg+ex3cFvnO03RQC4zy+2AwyLbHjRGkWjt2TQo3UIOVm1MLuOmyVVAIz3L6iUsnY0Bgd+5L3ObjAYxthFc6kqmtoDYlzqAZdeGvL0KxVTmqjV1qMT2bvEIlY8HY9+x4pets4r15UJ1GgMUwxHtLhkIUA1V55V10Kxs8qYH1jtgrPTaNAZYMAv+Z+GMEpGBXa/GmNoDlhFvAULObl6Ird3PAcN3KKlpelF/H1FysFy3NxPTXjj7sx9x3JcNvcHXkeKcYlHiSGhK53h+crTkuriAMnJ5RcuUEBkyfkvFQd/9zTYhEztlzA6OHQksZQR6b8KbySIFodUXIFUy9Slq8PVjfNBSZNUPlhabt36OFLVwZ12aIrID04yzBljrYEguNHFcUoWZ51FNTC+zfvET4ky6IZa83Yxx3KGLLXqQ4hlMGpy5haZ88dJx8CA0S/lmacZrhWJHegeGpLufus4WpmtY6DIs608euzD4IBtCBkONtllT3ozTTsboB4t3HQ/U6TIxI5/v29BJo0ZKV/wQEk+2cMMcZ2o2f+rsLgKybzGedB/p4flOBQ6+5fXartvTPYvUbc+KJJGTVU/Tm2Eam+TQNN/iNZIr+xNpiQwR0TR+DIK2vv27xmAXMir6B17DKXC1+8H3Y2Xy+uDcbZhv/fEparwCe7FQJkwShaYzRsX+3uXykYnQRcXRaTWuDrONTA7vIMcDAWRRIuaP+2ej/XtmdofDEl0lDXb7HVF9QOcdaewzjjZYk5CJAt+Y1nkjj+/9f5FH4tbtHuA18UwUzQtB0n6WyvsuG7Wa4BSTk0ADdZMSa1L1aIGj4cSBrT6X10WtFGaT8YSWJnLyx
 y8MQOavt
 fXVeAmR3+OUIucyu21mKzNWDck68ST/UVzdE1Trsb3ALl4ADi4T/pHInpMzOR6HZvHq5wY179/HV3kBSIIfz5yNIYypphbBmGe9HfWFwntCOnrB7IDdnwCu+iyX0TUqPOLBHI9UzdVumVky8BEjatuj6ITgcWh27AH8FN86io1Juuoo3iyQDIrUpzpIOXUHFd72L4h8/WYvwZkBwvX3H5PnmHEON/u0UWA+Pn1SRCicxImHysWHp01yM8nSFoTcjlYhZ+qi3vW5kgJstrjidjWa6g4a2f/1fGpsgeSML9I9JbWAu3KOny1Zkcur5pXgoBiqN/xtzzhI+dJZ9G8o2wiVIpBNj0davi62/NjaaZI2N0WjM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 01:56), Yosry Ahmed wrote:
> > I recall us having exactly this idea when we first introduced
> > zs_obj_{read,write}_end() functions, and I do recall that it
> > did not work.  Somehow this panics in __memcpy+0xc/0x44.  Let
> > me dig into it again.
> 
> Maybe because at this point we are trying to memcpy() class->size, which
> already includes ZS_HANDLE_SIZE. So reading after increasing the offset
> reads ZS_HANDLE_SIZE after class->size.

Yeah, I guess that falsely hits the spanning path because of extra
sizeof(unsigned long).

