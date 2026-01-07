Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09F40CF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F8F6B0093; Wed,  7 Jan 2026 00:43:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716056B0095; Wed,  7 Jan 2026 00:43:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615536B0096; Wed,  7 Jan 2026 00:43:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC7A6B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:43:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EADB91A71A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:43:51 +0000 (UTC)
X-FDA: 84304076262.17.ABA6525
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0A1C440003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:43:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="iwhssG/Q";
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767764630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jm+UnvkV4Nkj86IV5YhkNGl+AQ7yBruyZpFq7iSiOQI=;
	b=Yt2j818C+DNXwJ20RoXaiSm3N5PxL+ZpLkmOeDVoBjWvaXTHDfaFExerFrzFjvhYQU0glC
	5C8cubGxgyZwt7AiwAQgow9V2REwocmFmiKdpjutfO5Mhjou9n+ZvfmGa+RJ7XbVp/OMqz
	i0rw5EwmB3/RC5LaqYntemKOXzHphzw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="iwhssG/Q";
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767764630; a=rsa-sha256;
	cv=none;
	b=1y5fikUyKHzSj6g9MnX4V2ULDQoo87ia4EjQDqlySEkYdoN3UeGR4JTD3HDINpfEcf09O1
	vBBHHsjAkViWK29xk+o5K8+Uu9bF7eUlG03LZp2Y0oX9qk2+X/Kjqq67LE1uhFqUf4CYu4
	cFReSfmPbQZtER3+wQ9/uAQuC72EDXI=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29f1bc40b35so22170435ad.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 21:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767764629; x=1768369429; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jm+UnvkV4Nkj86IV5YhkNGl+AQ7yBruyZpFq7iSiOQI=;
        b=iwhssG/QzOkF/s9QfUqzmIVuiIEZEsYct7HHvqJA5DYBGXQGovAxBQfYsq+/B6Y66B
         Tt6i8rJV6aZcwBfVsB7MJfkRkENhiRlJHY095TDUrhDc82fsGCqJGko63H59JpgV5qoa
         A4GX9Hczg+zNhisp5XOkB/tFC3nXtBAqyiPVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767764629; x=1768369429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jm+UnvkV4Nkj86IV5YhkNGl+AQ7yBruyZpFq7iSiOQI=;
        b=dSQ6W9KeD2Xz7rPxbYDIs5gDSXMjm9jIrB2CbfRJ4Zj0LCqc+5qWSE3gJ4ddtU559/
         unPhhEWADrHAuo7iBxplxqXIB7ekwW+X9uw1LnJjzg8j4GIj1vPKmQ7MwgR/JqW+/jMp
         8iGgJRPCHCnwA7ASW+12kgtf6ajq+ZSR9628x0xmQ04xhMddA1pWouVMiTPC6p1vw8M4
         EqL3oTFPPhttUzG+W0a8HRyJZJFV8U4gsTchw2TS6JQntaieQ5oa4AUsYXWXQ2T/xOKE
         T1Z0DChrMOyezXVibFh4vqaBjv/+HIDBXqKGSLdoAmK5AdI7VfTeDdovz+B7TztPlkiu
         xL8Q==
X-Forwarded-Encrypted: i=1; AJvYcCW68q87wfVfouMrGRt2BUR8O6DNIPxnStOQ+wKG2I9vAYcdzcUxgLejWP0IiSKNEsRjtwiKnRZ9og==@kvack.org
X-Gm-Message-State: AOJu0YzQrUZfMYZkeO+7P20C5UNeshpLGe0yP3BtB8wCAr0aWwFw0g9Z
	y2uC8d1b0uBn8RzDIV8ICDvFdsuXJZ+n7FkW3y3Eh/IbfsQMicymjIElvZNY3f7WmQ==
X-Gm-Gg: AY/fxX7FuOzLqmIeW+R+muFPd3m/rSsTvkk8TRPNXDBZf1+QW0yCdZwpoO/oU3E3Fep
	drRu2YVS7O5i/PyfQdk7X+tr1a/AGvEyyPx5SGsuLpO7mqUvW8PeZ0twhtAqDJbnkLkNdSV3y5U
	MjM1Uxb5ASL1opL38UXw6F7g9r89eTssAgBQQTCcvelvEyaUocXWHhKvTry4gtgVRyXfjLJ8sdh
	hB5IlFOirg54PHAjJJ6n7J+3eSSPrcKm5g8A2FQZOFAOmmJ5uAoy8kKPd2XVMIngPq7scl6hDvc
	N6xJEQufQdYogRezTxZxMhyhF1NVAQaN8XkXgjmtQSa+yLejepOpPitcnBvO4viKtubpzhTO5HK
	LNq8N9lymesCE0/gKr64ROzEwWQ8ixvHirPE8f7Rj2FfB88Ydj+WkbyekJ0sJi8hLkUVWYABNRc
	pjJHwANWcZnonQfZab3S1Jz3IraJdl1ueWLbZgzqO9XhL4qgjZ/GPdKUO/Wie/qg==
X-Google-Smtp-Source: AGHT+IFnhox+Pcm3BMZQmXBaYY5NIAJTxQ6sCrTZWaJcpq3tK6BSanAvCjFTf+57c7fZWXuiyRA7lQ==
X-Received: by 2002:a17:903:4b4f:b0:295:3d5d:fe37 with SMTP id d9443c01a7336-2a3ee49a383mr13924225ad.41.1767764628955;
        Tue, 06 Jan 2026 21:43:48 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cb2e01sm37203925ad.46.2026.01.06.21.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 21:43:48 -0800 (PST)
Date: Wed, 7 Jan 2026 14:43:42 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
References: <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
X-Stat-Signature: wbcupsc49dya6m15cquqqhobk9396p5a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0A1C440003
X-HE-Tag: 1767764629-838484
X-HE-Meta: U2FsdGVkX1+hN8oo3BtW5nsPkZn5U7k4bSPWYlBYdse9b12CnR/Ozz0aHmE4MHkCT79UgdS3LMrUf0qregq9W2tkEbYYyyYB3ESmeVRI65dGuR3IRCkN9Q4/zNzytjyrqChGBvP+CMdyr3WHzkY+IJQyZ14VzEVDGasH0mj9TV0dtDLibFsSZZqf6HUius2Dteuq5uw7Ehqtn4vfhnBETbMU73q80BlhTBuq3iTine9+Pzmxp8qBeII6RTi0iCPCYIJJW0CmElJ40mUTTILXUA9Gk9ya9b3yoREdZj0PXTMYqQG149cgXqK/Tcq9pxk16O097JuREB+DlH1s6HfTKjiSzTbMB2J1yDttfB3fSkyprnOoyilk+jIzmeu81PrG5e5AZdqUu9zqEn/G1D6rAVchWYH3BJcD4TfSWw0AaXO5obUREz4MRhh3vMzT45vN93WOhOPcbj4GeIrFtJNmIQVn7C90lsDCDDpag9O1usahMe17Ra6AO/8ucAhFsgQ9UbPnQIrk47PUvArS0oJvwniNrGVyHD7+UF2W2ntgFAse/uCwhKJGBkKA/eF5tlp4zTCyYuQ/zgVK1Z1kWi3GMpnIaKpE6HtruiOyrH0IuXXCYEoYLphWtegWPzwyq+HEgxGzCGxspnUjDEFI2F8YtIyZv2iZQtF9tIVb4Zkv9NCb9BNNRX6pYcLEKiYEgzI1dSwIBIYCPno2gEBh5ga5FCU7LRdZScjo4xiJuPUJy6TpnJQG28ZcjyTe74+MvxDThGkrhvtWhOuHaz7vI9nOEPhE51yZKUOMaDphrU1ik0DimCyNLSatUcd0otqueT3HWtAfpieZ8oB5aQDGDrlm32WKPguIZsKKwoCixHkDapqeC45FRw8xS6SvTWyWL05Vg7pYUlzQkTuQMjmGTkroKkLX08edzQoQruVzcRhpw05dIQGO60CNkEm9NhNwUBZ51E5OuWED9E6Tx53YK6O
 CDHAcD8e
 33SrmfrhFucqW4lei/fNyzhhb61YDdbWN3RYi6OWbk5jko2anXZ1q9qSinhvnGwv0Ia7Dj/1BV8ELrCoUCUIx+P6nUgqpB+nWh+9ujQrLvtDHgq5wzuQ4f0aE9lNLHc+2XWFr8/29obYzHMl2Bl/6NXe2b30F/e4yEI4fxJLvIoMgcxQpfVTnlC2/0uvL1AMcNg0q4vmxDS3p3z1mfqqubTl0xIq/0M1KhxTW7lqDkBVFlxrgVxRTXsFShktGLxDmEpikPwEyDUzLGRQFbjJ/7ZNKeniyBb3tfYlztJo/CB4t+9HeE5yD7+zUsHrL0kx2r4xQKDFF1kNLixb1EiDyoa6nBTZHPBrV0CJG8WQy+vFoWOQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 05:39), Yosry Ahmed wrote:
> > On Tue, Jan 06, 2026 at 04:24:45PM +0000, Yosry Ahmed wrote:
[..]
> > Adding native SG support to LZO simply means removing the memcpy that
> > scomp would otherwise have to do.
> 
> Yeah the effort to add native support to compressors can be done
> separately. For zswap, I think the most common compressors are
> actually zstd and LZ4.

I think it's the same for chromeos: lz4 (primary) and zstd
(secondary/recompression).  zstd looks very complicated,
not sure if we really want to diverge its codebase from
the upstream (meta github repo).

