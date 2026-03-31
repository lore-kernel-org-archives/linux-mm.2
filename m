Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F9AFF60CF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8489D6B008C; Tue, 31 Mar 2026 03:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81FC16B0095; Tue, 31 Mar 2026 03:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736796B0096; Tue, 31 Mar 2026 03:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 634CD6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:28:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1910BD1CD
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:28:03 +0000 (UTC)
X-FDA: 84605529246.13.7DF55CE
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id DF9A6140003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:28:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jNLmsdy0;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wagPPFB0kk3KhuNLW9TIEMtF81ktdb45BmYJ3ltM5R4=;
	b=OhRGjYo0VXePWi4tDe29IanlGFxpx5jHfYh9LYHxHlsNQHKm2EqeSGy8JEX/DeJ05RsZs2
	eGkAI+pCGQ8a3FgtOuTgVjpbinnqUoDuh87mck+LQOSqQta/VBK2unuNT/of6qkAxObxa0
	IIHq1svuYQHYeVRZzV+ueWHtryROLDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942082; a=rsa-sha256;
	cv=none;
	b=pMsForcLdXqd+E8AELJLzNIS3A75TLwnHMZRe0+pjzyyruNNrj/zM5+OU54N7EwLZzcnVv
	uT25WX3kwsLuc4ByQAHnUnw3dA2/vt2kOUHP5+XuXG+jAAT2c3RGCCPSGdCoqL79H0a8D1
	WWE+KJGlVxWNRSRAk77ty+5gvMGr7LI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jNLmsdy0;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so52356885ad.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1774942081; x=1775546881; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wagPPFB0kk3KhuNLW9TIEMtF81ktdb45BmYJ3ltM5R4=;
        b=jNLmsdy0GF3iabLJVywsFCpzmnh8XfQx7O8fIkwZ3SIuWiH3zmSC5Y5jKKTZRRNWeo
         5ci6IoNWcRIPttbEAxxGBAd+gnSI4VEvKM8ffXHuJf41w6kB6JpOh3vvicF2dsE6phyJ
         RyHdrqp0yzg1Oni8QAodJSLtMk3tNAUvA/N5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942081; x=1775546881;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wagPPFB0kk3KhuNLW9TIEMtF81ktdb45BmYJ3ltM5R4=;
        b=eWUdkLfp4V+4+1BWmgUiLoONXU8Ycb1m8pFpVNWmGmfQkQ3Nq6R9lR2Lz1TQSA0APX
         L3B4DTdUUp3s1M5RU+fADdQgHS3JlwUoEEC9ENsjmpX+anqdRqxdjhaThhqKYuvFK2jP
         6M3BCjcTOAgPUqT5H2suT3x3eRimtlAK1x/gwbZrPdmBioaY315qTgERcqqxZ3PbOwnv
         hwPLVQnu4AfxxQN6q+biUNe7qST5vUGYcOmhTFu2YC/q8xpCPIrnlWEpxwxmazkyf8Fn
         0yo3K6YE9hMComLarg3y6fdeWIT8RKhLBtWDeQxOwJSsY75qm9HpS5iXrXwTdYb57zZA
         7BhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGSfHtVAtZv9NftgwW9yqaxMh/tQ8ljaUXWA+Pyq6fBAn0yG6j9tP6ADdYRJ3UkiPVTJl/ybCGmw==@kvack.org
X-Gm-Message-State: AOJu0YybwdUuAFye+3341P7i9JgM6ia8wESilqjRLk91hD2447PfWNR4
	sSgayifIRTgPZbyjdm+m05ZnoEC3sRFzfTjNE7qvtLDj/XTcNDtCtzvsYp313FaOpw==
X-Gm-Gg: ATEYQzwwDJBYDzK8sl9u8dxbxeFAgPlT3I0p9Seqr3EXv6H3y+/wXgos6A87qtQWY3/
	j9b4lYNnXBOcn/J7OTX3LrhRrlXEwUsfuG7Jk9h8HbvhvPSAoQuS6H9owJ17+SOgoAjydM0xgoe
	3JQ61eSxRc6Uu6hthyqXnN1sP/i1+Rrs0Nhns2Z4cHCciLC9Sjn1Kjqe6sXdOgC9MtaX+xD8tdV
	6UmWdV+4KG12+QC1HShw8by2rfkBA690TN2f9T16xY73YwvHtA/6/+7vDABbllSO7FGAADsHvZ+
	6LOmwsD4KsO+U+KSb2DreLmqdJFLfeNaGZTHEzc1/0dZTpRCesAxbZYpxpxduFsEt5fWlLzXCE+
	+Aj37A94zUcx7FMf9P1eNd1TPZCjx51USMjjrHVFa0PSvuA/QfaJkW+sCwhzGyP/3SZ6cKuER7i
	squcDj1dxl7XVplsOO2M2D2kK1+5Ex53Mo2zekPnZdIkG1VDMyu8hdEhO5C8gTziXzUlNdjqCBw
	w==
X-Received: by 2002:a17:902:d487:b0:2b0:ac1e:9720 with SMTP id d9443c01a7336-2b0cdc5d700mr165997155ad.23.1774942080640;
        Tue, 31 Mar 2026 00:28:00 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:90ef:61f3:1679:56f5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24277e8d3sm101197635ad.55.2026.03.31.00.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:28:00 -0700 (PDT)
Date: Tue, 31 Mar 2026 16:27:56 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Brian Geffon <bgeffon@google.com>, linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH] zram: do not forget to endio for partial discard requests
Message-ID: <act3bNgya8n4nVcj@google.com>
References: <20260331071537.706139-1-senozhatsky@chromium.org>
 <20260331072633.GA5494@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331072633.GA5494@lst.de>
X-Rspamd-Server: rspam12
X-Stat-Signature: qa83iufpz1edjkehrfbddp31nos9k6dp
X-Rspamd-Queue-Id: DF9A6140003
X-Rspam-User: 
X-HE-Tag: 1774942081-702652
X-HE-Meta: U2FsdGVkX19ZK/yw2FQOQYhNPLJGBZLNbjDHbqTQKSUpylO6hnPbrM2WAGsFD+yEftqdtV6AoQLLInSyYEAaoVhdFI4ajXJKE/EL9Sw09fy149abZYuBVyzr497wrN/FHjfn7ZLlH+en4B/VNVz/1cwMWkMs5QyQNJVSu84CZ/s41657impAVm1Ghe3CWu9nt1uebJgdP8CSjxsjwuRku5/jZobUIfYk3M5DbJtX5cE0wBI9FMgXuPDhohcAuAYtOInBTFZr1WsF+aU3LgTSqr9HLRjhQx20U6RWjKl4IPD5Ya5d5D6jtIUqWcA/A2CxEOngMF+RSsv/7W15GmAd0Uo6M9kqABSwZ8C/LFi3iYD1YKDZqfu0vhpV712M3IEt0V1rtWmCH5NmG2RR7U1da/hvHjB6d3Hv/eTG14BFCEneU1jcqdIaxkHGBbThfbBmwChkSk9KVLOBYqSlo1lWLuP1Zkw7WkKosE8Ctjcf3I9ej9Mgmh51I6EXj9wyItPcdySdLjtzfC5VqHblAG+Gn0SW4tLszTKi++EEpGiANmjzHM2hfFyG+3e4fFRTml7oAOrBbYQeCICw/HS8XsnNd/z7d/AERSX91HqvZvJLuEmQ7wadeXmEW6dAqB9p9yjUUXP6kJk8nTLD7MvPC543MoHO9VXiK3ywLVLrfk75xbiP53Mro9IvEG1OaRHmc5wtLmVQk2zedbGZY0uRh9u9/+ZVQqsJItzl/wxJ45udz40gKN7XAglA1cPOMRLiA30W28aXMevzT9Iueohaykz6rHfX4m1ER3A1T9FX5ZZrDCu5DRLhdg696pH08ME3NsjkB3Jr7Q17fS+FPZReCQEqwQQ2wsy3HHyl3JogwvlYKD03/dDe3XvPK4o3m2P7QHr/aVwn5XZjT1sLJ3Fzq0OsMEX+YYVN5J6eMJVgNulX/67yFyHHjE20ztfTcLwUqn+z+OZq7Yuwlh09sM8Isxr
 Ly/Wp+v6
 Dst6gw52bhMj0itGLSDjUlCClYEbpFeroJxWT3CF1Fy14sXSr34hJZbWRxTPlaX9u4JkRXhPCRb0pxjEshJqmt+PO44dqhoysy0WPGJdu6s1YpqcR3I73qLYveC+Dme9CLMgsZBdiYHdBUzLI0+ThhxisEqKvw955hdjsnSHr7yqlFfyi/Ja8qYJJUPfyEjCmLlf+HcdjTUlIrChvR5+2rj/EmBym837kMCjktKm3nHm0PyNLZFfSxVr3twzntD/XsYY7pQpoIcI5dgdIKcGEOnOt3YOcy01iMzIgMWnVOQv8k67LPV1DYY3SB5j47R7wVAzbCEy7HH4+zbXV21Cm8RvalsmQS2F8Ul2e6e7A0rT9Scg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/31 09:26), Christoph Hellwig wrote:
> On Tue, Mar 31, 2026 at 04:15:06PM +0900, Sergey Senozhatsky wrote:
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -2683,8 +2683,10 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
> >  	 * skipping this logical block is appropriate here.
> >  	 */
> >  	if (offset) {
> > -		if (n <= (PAGE_SIZE - offset))
> > +		if (n <= (PAGE_SIZE - offset)) {
> > +			bio_endio(bio);
> >  			return;
> > +		}
> 
> Use goto end_bio and share the code with the final completion at the
> end of the function?

OK, will do in v2.

