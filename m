Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C54DD46638
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 22:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF1B6B00AA; Thu, 15 Jan 2026 17:54:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CD56B00AB; Thu, 15 Jan 2026 17:54:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0716B00AC; Thu, 15 Jan 2026 17:54:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7C406B00AA
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:54:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EC82C1B5E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:54:33 +0000 (UTC)
X-FDA: 84335704026.02.4F7F994
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8CB99120005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:54:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AnqOm6RQ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768517671; a=rsa-sha256;
	cv=none;
	b=sjxg/UdTd6oHqAmTD4a04399ihQNqiecbnIhGzTCKQVgTSNnoPfQ7tu5Kk+Gop5Rf6DfJx
	iUuFbGiKnGNjM6Driy6CD6PsfkaSzcaSJ1HvQDGAMTo1V4sTb9cd+PUg3GAauEd5ipHiMm
	Mn66Kkl2003UT/iSX+Eh2gzsjvMAdjE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AnqOm6RQ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768517671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reZxE7asEWiVI0EMu8bQnNYE+4B4+Kkux9l14QRm3R4=;
	b=HtH0IQZeCREUaiUyy8unm+ZjRzKm1LvwLOr6pXaMhZwM3YEf2jLuIceigZEwdy9RYmt6QH
	bhLcS6jOAJndh6NqqUKYphqlLCjot+DP/tpNkIOASXrGPctMSbaoPtMJIDu5L9vdgVgHe2
	y9h1gyCJS82geePIUDGZHGHDza8sxKM=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-81e9d0cd082so1245888b3a.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768517670; x=1769122470; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=reZxE7asEWiVI0EMu8bQnNYE+4B4+Kkux9l14QRm3R4=;
        b=AnqOm6RQUsy5akvm5XePFqxjAhDEMcu8mRp67CzIDapNERth2vhGDoCnBdLUXyBCOn
         ykCJI2pE6V99Tr4t1NxkuvIWDclGFrYLkpHCR8qrMPCbSutiL0L3WZkZ/lEPL9TsSeVu
         ne3d2uiRkviD3YCP2HZtP2EKI4JwOxrYa7KCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768517670; x=1769122470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=reZxE7asEWiVI0EMu8bQnNYE+4B4+Kkux9l14QRm3R4=;
        b=ScVZYt1BJ52iEADUHMDv4mQQcPwGaSuh1J5PqzZLYIL3uAwf73jwDJr8zIEetEP1uH
         K5SigYkePfMOkBVmO8btoLEzv/5snmXpVG4xZEQrCBI9Hq/gmQkBjGnk285OhVtDg6H5
         5Lp17SEiQWp3XYVJfKLb2gWhDu7wyrBJt03G6+mc+hG7gsv283ETlCVtsA4QFZkebQgF
         JKaGclLI+sVYLqyhqZmOGeTILRVvsgvgV3kuMTKja4gjg0PnpmebXAxnec8MSqqFjwg9
         bfgT3oh66H5E8XaG9kAwiLhFOxmyi1fGKyVRnlBAJ9eGlv9qnsh8hOBiuzsHQr9ZYTXg
         nOPg==
X-Forwarded-Encrypted: i=1; AJvYcCXB2hD2SNXu38jjmR1NfjxcMc9hnHskFR2rYvMO2AA1UENvtsRRU0WxeYlRydaz89mvGbzuwgcBXg==@kvack.org
X-Gm-Message-State: AOJu0YzPe52CF3J+ptasPG9pngHlDutjlCdMap0PgJde8atHQqilJAH4
	nCw08/5B8XJHKKfkZCz0sVk+pwk9Plh2gnZCtjWSDje+HIj7X8xoV8FlZa5IpHvzzw==
X-Gm-Gg: AY/fxX4EQ+LvYaaNYh6NFhSwdLTXyb9sbJ0edNr09ZvxaRoZhC3O0Cw+BlgTr0BtGJi
	DFmZDg8uCyBCsMA3R4fpOjEChCPlp/thzqFBnRqCsNvQEl9psX0GM9bhFp63qYXzDo1bNEqwBwm
	B7BseTkApEdO+/YifWAcr2nUT9bEGmKBvAlg3A9ROcU0I1xkmhkBIDrrg9ttm2wp152lU0K9Dxj
	dBme03eBF239/41o1IjFxFLY77jgblUUPrgZXx8l5sauGvfJwGyjyRPVjNOxofncaqXsN8m7Wj+
	ugW1FaJsPEiJW9y39xqjN+XXpXahlbynp55nbq3o4DTyaTsyOvdroLN61kSAzfojPIEKAcKJE4U
	31xKHxBxo0nLbpE4YoO/KGkCUFTVJYQPFX8sOR69R0bQOc6YaWmXaZzvz0fpTz7IOdA7QKx0N3B
	S+Fb41B4BJFNILT5vueDyyhOB0EtPXvKYXER6AMgCm5s/pMLyFiL/D0sCzd6I=
X-Received: by 2002:a05:6a20:3d19:b0:366:14ac:e1df with SMTP id adf61e73a8af0-38e00db7745mr721247637.69.1768517670392;
        Thu, 15 Jan 2026 14:54:30 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ba7a:360:116f:dac])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190ab921sm3017215ad.8.2026.01.15.14.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 14:54:29 -0800 (PST)
Date: Fri, 16 Jan 2026 07:54:25 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Mason <clm@meta.com>
Subject: Re: [PATCH 2/2] zram: fixup read_block_state()
Message-ID: <wstf2ujpdkz5evedgqr2awze7wdwcmcluxntkqk2eifp5axjpu@lawhwffyeg72>
References: <20251216022727.578BFC4CEF5@smtp.kernel.org>
 <20260115033031.3818977-1-senozhatsky@chromium.org>
 <20260115140743.f7ada77bc912595a580eaf7c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115140743.f7ada77bc912595a580eaf7c@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: g1hsayacqnarxrfywk5x9s6hn4ozrxfc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8CB99120005
X-HE-Tag: 1768517671-962243
X-HE-Meta: U2FsdGVkX181aUqrDrMZHBayDzqIWIcNrwHEg+YqA59AR96+JtdL9Fo7Jh6qndmW4VLPk1jh3DNO/2IMsJDHfIqv7XZ1B+Cv1dgUZmRGB8FAt1ix6U6u3H6TURwilAoc9+NXJQll1CGg879ZI2AOzeJrdFiUZDwCiIO9Vo6OMxo8DiRcwMqlfWOtnI+3T/kWlhaZiWfFGQCrRiX5HkchrcD2oqC1TYYXd7ccP8pDuMkgyfhfdGdItfDPg59M8g66WJd05YwSHFb6M2NCx1fSBqY9hpWmIlqcsj76PRJY2swcimgNi71GnFv3GP9+Ht9D2Mn5Us2AEB/9uDfkaIhNpA3x7v1X2tChTZokdi2GdxNz4bq4yw78V1SobrSfDIBJh0gQLD8CuZkTeZYY+EfagCircccDfT44gMG2sUKVD7s4tkn9/EO7aioLZrPbpgV0C4/nOXRwNzqckmt4SEcyh4JqXwSIYwCKgix51pwEui+BmNawpLTr1gb3apG+6K0PqCmpbWdN4UZgP1TKDYfI7o2uu2/oszwBVvSDJyqfaY+nChu2ZT2Bp7IEjhWkE/L6rt/tl5XDx5UIGeQ2wSXl7UwDEV3Xf/F8+mGasLQ/mDM5Cwcw5ir//UUNiAYeqMzyI27hhP6GaFbkGzfF1saUcFtg3PnLbMgPHb0DAoj53jWgRx0ahJX7qY/fg1nISUIbl1k4vhz5ovEQHJVN2i/prUj7RKGPdtSFoVCsV+amKOShVUgxRMRRfu9S4gvUGoUArBpN3IbSVz6lMRaR6zosCNVauxbZF0+uqJMVL2/sj/JGheGibj5GvG2tTDtRL16PIBtl5gIF7pQI3F1hjwq638GfXW7hH4iQWg/27SscspDl2TBF93y857g7VRN9Jb/7QmXD47pToFZ9RvJ1rxJK91rCxz2yxFMVHgi7LfPeOAh2JboBu7f1mc79kXy7WqNkLgTdU7u90cphjRLVeHw
 XNNZjC1q
 kzJtADm4e+5a4YUCY49jKz85dd1AIkwKUEwCjzG2iAbIDyUCRjmyrrw7HVCjAQZfC1oo4aH1OnSPNas4LR2vsFHnvN1CfWf2J79KDPwAT3+c+IsE6IkHtrz8pAY7D1/wv5IXZeppQS1ZZAzt3uM/bGyQOwoWTAmNNXzu7ikjVdWxMq4v2eGrSRxtKGig4v+h2MEVhsmYGyPYfOvBKyLJcWhDjeNjIxDEcLB4LBYwx7WFj1AW9p2HJ33wpqwPZzzYbmbkljOrV33T9r0pAuKcc76G6fzmSXHKeYa/TXzGso8dQD520Y5Oo8PHfV7/W7iJ9ow1TENtlH6OnZwTvygEkrKaVHa19hcEoHG7peb09oknvguVFHhciaR3M13kFoEnjzz6UhMi4aR2S9QEFPTjDj8qhj7q0v6y7Ceg5nPjJZC/r/qULKD5lvo8WgIS6fls0d/XJhD1KzoWirdqIEuEvDxzhXZSwx3U7CebHiH6BBIF46KsLZhQuL1SWiZbeWxo0CmsB1DWtGXrlUjlcX1Cs+ugLiBq7a/9jxO5rYTrm9JfjtjsfQfwEijJdRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/15 14:07), Andrew Morton wrote:
> On Thu, 15 Jan 2026 12:30:06 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> 
> > ac_time is now in seconds, do not use ktime_to_timespec64()
> 
> Please help me out here - which patch introduced the issue which Chris
> found?

This one:
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-u32-for-entry-ac_time-tracking.patch

> > Reported-by: Chris Mason <clm@meta.com>
> 
> The Closes: link would be helpful.

I thought that for fixup patches that are still in your tree we
don't need Closes: tags.  If you prefer to have them, it should
be this email:
http://lore.kernel.org/linux-kernel/20260114124522.1326519-1-clm@meta.com

[..]
> > -		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
> >  		copied = snprintf(kbuf + written, count,
> > -			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
> > -			index, (s64)ts.tv_sec,
> > -			ts.tv_nsec / NSEC_PER_USEC,
> > +			"%12zd %12u.%06lu %c%c%c%c%c%c\n",
> > +			index, zram->table[index].attr.ac_time, 0,
> 
> local `ts' is now unused?

Oh, yes.  Somehow my compiler didn't notice that.

