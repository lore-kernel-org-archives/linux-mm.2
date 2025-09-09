Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9987FCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032E76B0011; Tue,  9 Sep 2025 11:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25958E0003; Tue,  9 Sep 2025 11:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B246B0029; Tue,  9 Sep 2025 11:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF75B6B0011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:11:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81C66140564
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:11:19 +0000 (UTC)
X-FDA: 83870050278.15.3B01817
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4FF2A20016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:11:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=B+JXdkr5;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757430677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tURBG8J8o/qd06zK5K8bYxIL4Qoo/SPoLEPuSdcyLLo=;
	b=QNQXuyoQgNWmh7nZqTu2K4toNgY3WUuA8rquh6o72wels7vZtHXVo63jXrX1uiBY8335p9
	+AiJ38h8DcioDT3GaHZLevFoeA8WaAVQLkwbNGhGhazLFO6Fuqqi3e7sX7dZBZlyyUAaYs
	BiSRoMJIiAXf0epU1ou1HO3ow9l04gw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757430677; a=rsa-sha256;
	cv=none;
	b=WeCc0Gd7K31g25+XikLfKLBCnE+jaGbLy9YiM7/8EMw/nq3Oy8hgeFijrtkxPOe/K5wx1/
	nhcCpK2B1jWPe8aQzf2Lhh6nu1c/hoKoz4Yu3kwRVB10DMP3VFb9B7bYjhxKs9Elk7koDh
	yeZAY8ReQtbxjrNuAaNg/vyEzSltfC0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=B+JXdkr5;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b490287648so93550901cf.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 08:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757430676; x=1758035476; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tURBG8J8o/qd06zK5K8bYxIL4Qoo/SPoLEPuSdcyLLo=;
        b=B+JXdkr5Nds/2204lf3+HA/aQnYsDsQ4PTXNRsaJVOpVd+994dlpRfD7+bdGJrtAXT
         u8+g6l2/3DFCVvbgWnk18HTQRovhvD7Pz0T6H9Q8K/9VxD71fOeL1A/513glkLOT6IFu
         OPWQLGHwPlczYqGRxLiPsxb06oRzUCZhPryxCJF2xa4C2Tl6ParD07JIxKznmdzXmk4M
         SFFman5HumeQ2gVyetio1jm05Y0XPUci4EA8zq9Bk6XRIQbYBZP+Brtjydkr6s+QnVlb
         tUOK82KVKm5urO/4p9unMaDX8yfZK7LGA51iJd79bf7b9uBZwQeJCJTMRkVQSuWesN2i
         Av+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757430676; x=1758035476;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tURBG8J8o/qd06zK5K8bYxIL4Qoo/SPoLEPuSdcyLLo=;
        b=ij0lA/w1dbbj4tW2ipEnE4fHy5yJko3u+pgkB/gn35dknVhykHWdOBlZF0tdIhR42E
         qHbyXAewMRkhU+xqKvpUQ8fYowPES0uuPDRXSvzzN63xjSmPxM+HEHpTi6on/tQioq8b
         YaWkMDt4sRIXrFTYvweVAzaOvfXt7HG/XNbAGHmrxl0H59A2XpKCmtSKa/KS8zrhoQV2
         SzN0pgDUEGqvOg4jiiiNC0t5Z6Szh0e44o/vCZdOqbjyo5nwpXMfDm57cLmVRhwuhb0/
         XV1ZNKjuX3FMTIs35n6W67IV8bG4CsjrMoV5qUy7OcxZduCYd6A+gB4jtpZiDgVTB65j
         ZSAg==
X-Forwarded-Encrypted: i=1; AJvYcCWqJ14Eyo3LbWK+YbFkDlz3rONT4BVLmO/1GYvCFS2BuFK9p9Tl4TvyHPFzKCQNE9+oCJwOvuXEsQ==@kvack.org
X-Gm-Message-State: AOJu0YwWdJVvPdbuvyoBfgEJAyRAo8yQW0LocrTSWt2SINaA7igGKaas
	8SAw/AbXdvfhMs4rlW1cM95BASwn9D7SCG926SVZ55OOgQnNQpT3HxYDX74PWtW6a70=
X-Gm-Gg: ASbGnctLuHBZlgdCZtv6CXxs449QW1+lTRWS/0R7G+pf47y/b9JxgvDqmYdxwvWFC+C
	tpgTt5W/27FKUu1b6sA8N9J6xqlS0xVS9A63kD1nN4MW0e4C1RPC6dcTYV1RUD1o4d5FZydpCcS
	TfzXp/QcaFHRtlGCdVVuEETuIxC56IA7NKyrQ9BGGi6M3pu/xQu/0kMIIzujnd88Y0fmDDJ9J+U
	wLyWdZ2VfJBZAjok5ZOX+8Oif1wFzdDApJYupjYxsLkL9IQZ8HBr06LvY5p6oFIO+FQFhGCm3+R
	GurbPMEZo568hETQhZhPaL5CLrqpeowViI00sX5nIY6jmB8VtJ81ySxH8e0sH5sbhu8IeIn2vmS
	zkMu+VsNsD73O
X-Google-Smtp-Source: AGHT+IFKTzUCRKvQlrS8Ai0m7e/x5mKMWEsbS7AmLloMhvq2/uude/1VNVPNgbAgTYRvG0gKhgh+LQ==
X-Received: by 2002:a05:622a:1482:b0:4b3:bd5:e1c with SMTP id d75a77b69052e-4b5f84474f2mr123084661cf.53.1757430675099;
        Tue, 09 Sep 2025 08:11:15 -0700 (PDT)
Received: from localhost ([2620:10d:c091:600::c6db])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4b61ba8719csm10336371cf.13.2025.09.09.08.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:11:14 -0700 (PDT)
Date: Tue, 9 Sep 2025 16:11:13 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: zpdesc: minor naming and comment corrections
Message-ID: <20250909151113.GD1474@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-4-hannes@cmpxchg.org>
 <mgt4ejjyz64ehnyskv24nzjllxxie4jvxb6i2dzlq43yev5dtu@sfltngevykts>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mgt4ejjyz64ehnyskv24nzjllxxie4jvxb6i2dzlq43yev5dtu@sfltngevykts>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4FF2A20016
X-Stat-Signature: n4rgjb8my1eprqqgicdftcahfuja1q6c
X-Rspam-User: 
X-HE-Tag: 1757430677-332513
X-HE-Meta: U2FsdGVkX18GxPjsgdoXaX7MfoSNshbt3jiOplwZHn2AUykA0UICofUgyv45v/Vdjcnwa/a9HtMzUIhM5aBSaKK8M/6OhF3lucj7UgiMLy4lzTM7tis1kR0vLbAKMPliqGVLxU2DtSKCS9WByOPAFs6fpmIqm+aXkGzjv+nyOUAuOgi+G3KLK/q+SxVx++kj28xPEhU5jyvwy+F+IMaofLHCUj4yVtrcajqgsZl8WineChRp7UsmuY4dsYZRb/qZitMBZgIFqmBSI5YrUYM93WLHFHCRWXr+/2xTzBJ1jOiILc1r8Epy/uVqinPoMKBbEUcFAl1YSj0TqFLmykYmNYlf+IsKhe/M1RvyW2dXxt5/n1+brmonovYOKaGyEGGU/9TH8MehvV6GrdyBTNQJDoDqI11XqvW+xteE5sqdiZOIS0+UPmtzdgRh9cRQf1KKVo+RaVwyZb9J/5siNMtgdXWcO5B7JzKLGcb0ilSzxgjwZeIwOvrj7wNsM1RkAFhDScFnbeLIC2isaFrkNK0Gt9x1ziCvMbCkznFFHGShRoTv5KRgudfS6psSbuH5AxRgHjcqHUr8kgv/YSu6obDmbC3FkEPioWO9PqIaTzBa4ZM8iEQivV2Qft+lM2F3JhvnboN9zaeBVORHOdekDWAR+e8PJubNQaeYgbUXN+AvVgm2Depc1p+9mNGYc1zGeAbynp4wmgH8nEc6x7LehWqKOv0HydAgi2zyGJGDMFVY6troK2Z9mglrONsZS29XVaRJY5xt5jSN6AzBNpygQ9N90HV+J7hpuv00pwtHOh6eAcn6EDOo9jR244G08BBF9RCh+NFcmNuBOmPBogFk69ioPysR2aZiODLsV8o1bfLooXvruO43OcxDpggrfy2ofqTJJMZsxem0PDVjhj5NXo+UoFJJFdbpLFHfB5qz/hhELlKLbF0ozm6MEsHEu+EI624cT71aZsHEQd0ipiZ64jM
 WE4DKOBW
 1HSoXrD0aRdqQ7KMlPMC3a+kq96XDNZB3GojIalqvTOMiH0jfz0H5VAOY/dYTDZJgfKglDBxtoRu4uFnkCS7uex2SAdmZ6DJQVgH/+cJkJiGOv8jmfNi+2eOY+oYMrdAsvAzfrGz8fIjgt6sDNskaqsyZFuZhb/lAfcdTDmxFCQdd9zO8hnyby4CSvKhHLuLy9nDz1sXKEEipHIDLOl5yA9Js3XYhD9CnvJcJeHh4JgiF3rH7s5qrNR264bPgWxzivMDCSdCaXu1O2vNLmkpbGOZNV3qr24eYPhlKsJJqjgfJxIbF93qthHtMfayynWpfDE205IJlGn415NTmprgvyiLbPalWbBRmyeeydRGPmsSmRsLweTySYa+Fsucj4oY5pQqLklyaABF46ZAyVqkhon+q6r2f+ka60VtkWASTbYECBg6JkxemxU+xTk1dwDtqpx/jcQBc8GH2VDab2fXK6zbexan3zLJgH7sBoVbVnPbnR9Wyu2vHH3ECm3sALOrdoOhe5dTNbytHmF0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 07:05:22PM +0000, Yosry Ahmed wrote:
> On Fri, Aug 29, 2025 at 05:15:28PM +0100, Johannes Weiner wrote:
> > zpdesc is the page descriptor used by the zsmalloc backend allocator,
> > which in turn is used by zswap and zram. The zpool layer is gone.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> 
> Why not rename zpdesc to zsdesc or zdesc while we're at it? It's a lot
> of noise but it's just this file and zsmalloc.c IIUC. Up to you.

I'm kind of fine with zpdesc and not sure the other names are this
much better to warrant the churn. So if you don't mind, I'd just leave
it alone for now.

> If it's just the comment changes I would squash it into the second
> patch, but not a big deal. Either way:
> 
> Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Thanks for your review!

