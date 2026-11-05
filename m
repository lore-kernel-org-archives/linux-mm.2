Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62AE8606A331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ujiuQq8A
Received: by kanga.kvack.org (Postfix)
	id 494AC6B05B4; Thu,  5 Nov 2026 12:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445576B05B5; Thu,  5 Nov 2026 12:37:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334736B05B6; Thu,  5 Nov 2026 12:37:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2946B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:37:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94D5D120B10
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:37:03 +0000 (UTC)
X-FDA: 85401771126.05.3B325F8
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9F750100008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:37:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ujiuQq8A;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793900221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dk4g+BGecR/++NTUwlCVXRBVFsZCz/QDtiIPUnrLB94=;
	b=D3S0+JKqCcNg8PQ4unYY84GzQyj3TOE4X/CzDhZLlCxFdnkEtg6cT1qNBou2IjMChs3Tuq
	5t+1Z9z8IRQX4OYmjfjSCPF58CVqOMtlx/d3VTKMzbLte8NjD0n3M6NETTr5rQx9XIXC7l
	3KP6y4pxq1f23JRp10Ezk2M6Gx+fOg4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793900221;
	b=aZSPqv/p7N8+4nKvTRpVHan5tYTJSrRoZie8n0sa2bwWBLaQPMWp5eUt4r6pYWBrJrQAsX
	d/bc5R2N9EHsLsCr6FpTCZCP/nOL3A+BUHOwUb4QT9XLu5jiIt46NlTieT9bMg4p72lF2E
	A/7SZDXsIV5OQTFC4pt5FpsNP5i7Irg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ujiuQq8A;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e4831c028so1966707f8f.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 09:37:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793900220; cv=none;
        d=google.com; s=arc-20260327;
        b=q9TXJDah+0SJsGy9fr4oIIvIKC/6lbYu/ThOiTBCuCvPOKwgt8T7OZpClH2HNBtFBW
         JeytGasFAYpSMYQC0rq+2MzJ1PIjRGXzt/K2N++GLM9nQBx8uuxkId6jJ3h9Rb7SFBWI
         8IXZKBJ2rRUSA5ob2FlHo7dy6qgcmzhCY/+9tWZVwWDFcNaqBbbp1vjCVJvBZSfQ5Fy9
         vbQQiXp6M9eGogqZ6iUgdJwKUMLiitm4VKrYN4plpilLqG7a2fwFkQdrfgjbBHxvONsB
         i1i2ueRCMkBObXNa3Wpboeats6dRTTb8g79WhvbiY15eiRBapRMrJmfCor8KdWGV7LTa
         HRAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dk4g+BGecR/++NTUwlCVXRBVFsZCz/QDtiIPUnrLB94=;
        fh=OVZEN6x/sN6eQuj25aPujreIis+mpdqXXZJTDk/OHWE=;
        b=K/mGDamRXp5O6br95xZjLAtRqwRLkiKbJAtz9AL3t5dhAR7ao3U/CVaoANNlfNHHhB
         jQUWlZORM3WbVjWKSKA23HK1F40MEkjQFfg8d+rQO3bUcnnicwq0wkVQHOhVEkKb3jXY
         BP+Y0/UXABrG8rWt0q5AvPAV1iUL+UMArkRQoHOd9vHBcFs0+WeoncDlwvgvTRb0EOMd
         pLOkd8w65NtLhfL5A262Ly8IqGT7UZ1vYjv9gjAs5gKQwngzXD4GxH8INsx9xhkNi2KC
         p3+mznRgSr06agoMerBUOuyAFz8+/aviSj+nqUx6xp1FsgcMGhYrFITrJXPN8nvbqgoM
         cUdA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793900220; x=1794505020; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dk4g+BGecR/++NTUwlCVXRBVFsZCz/QDtiIPUnrLB94=;
        b=ujiuQq8A6bcNqAzIOKlorws6IG1LqCotAthkvPFrenYsjAMPKwuCp+jFJpxPba2sR0
         oTmCBaNxW0KS0bDz0BzmtRAAJp4HmR4CfKNTm9DkJ4q09tJ0RVlackh2rmG4hWiEUwXY
         n1YYzr0XEuAw+yagqoTFAqe+VJIqiVK2CzGLXS5ESXQ1LJ0/MtRWVndW1XrYQm1Ivjxb
         JiS5xnhM4C/zguKacxwBrGTL2gMt0mkDcBXj28ZsMdcdFrxnFW/yracZ5x7mBDoibzmU
         NexzKX2teqk9FeNHUu42xtW4nC7y/ksCnuW66sszXqixeWVx3r+DANWxO33LEC2+elg1
         nFdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793900220; x=1794505020;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dk4g+BGecR/++NTUwlCVXRBVFsZCz/QDtiIPUnrLB94=;
        b=bXpwGE5XI953JaFoSF6mV/32jlo+U7lDKy9HXIojVJ/VDv+3Ytlz+ouv94M/WsIlxA
         1s4BSZYeySZbrN8NR398CcJj2FRSSQ+AWYiUklicRZ/KVwsJSauaJX6brp7AnhFZEuTW
         21zxJeryMclbAe6wH2pbSRuamlyYBmxwyVavAa5gTIN22wn0BsrqP12brTWxFzGHvP9n
         XNVPqTBnQSoFVfjZkEjotIYq7fXc4ugfH9itposM8S4OH/ypj2iqnxyeCB89jJUHKQmA
         ewQmlLecgIoxVSPPr/tgx3qphMaI0uEo7P6fuDvDc4LBKYZHEHctYcruX2hka6wJG6a0
         0J2w==
X-Forwarded-Encrypted: i=1; AKwUvBxSLH2u6zMVLTDRebFWmFoqpceomjA5svfAK1al7x7u/CiUJHevzrKUJIdFbYiSi3i/aoNkzLzsxg==@kvack.org
X-Gm-Message-State: APuU4Z/jc7RSqaf//KKLoTFD7+n1gbw8zcfi6cgDGCNolzJBdYaWa4Zj
	YWN6O4VvFzXIA8TirOXyVBz8RAK/rS5y/M8XeEfJCA/jUC9WUXHShBzOe20dua6guC/wYEBU59R
	xpUIKZhdGuj+vDbuWtud7mweS8RvggCs=
X-Gm-Gg: AYBFou19ulyyxCIy1wh+R5dWxFki3Nf3R6Jdr8hHOhQlKAlEzRM5FRn6W+BPmXqmeRw
	N+za3vdV3ANK+FHLNXQ8xKR/t4lUZauLECdUa8EJqX5QnpiN4kg7Nq++L2JBg/LAM9E6GK2rOck
	n0JLXLchoqip9LW2rpNFp6JhSSuplp7lSi7ubvgIibfNA2v7q2924a1ooTUqpqTYApQ8tGHC6Nj
	Ggue97xjVifyCVyYPd9zo/b62EB8LVJvqBJd5nVj2FaZrmQ/gYTpcFakOT5oyjbLcKh2RCo/RaW
	9Hx6/rlZgsXjgcy3e2OiPigtEj0DDVE4CFwZU945DUMFitYU2hBSJQ3EVJR4rTGz2XtPrJwh89W
	t+OuQFvvqdzmySoAoAcR/7MBXzTlS8lJe/Nrr+/Xwr2rVZ5JOrKAat7oTu2QWJdHBIHd2H1AYfd
	mN3zRQ/sHpoNUGNiXcgQspiSNwoKZhCtzbRsBw+YimowjXPTXYFU7T
X-Received: by 2002:a05:6000:2901:b0:48b:59f:db9c with SMTP id
 ffacd0b85a97d-492775f03ddmr690889f8f.53.1793900219836; Thu, 05 Nov 2026
 09:36:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105044752.1997895-1-senozhatsky@chromium.org> <auy9UfB30AlYabV8@google.com>
In-Reply-To: <auy9UfB30AlYabV8@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 5 Nov 2026 10:36:48 -0700
X-Gm-Features: AclHuK_riEVsVvEc_LND-HcPqE5QdPWZJpeStDe2FO2VdPoa8v6ez4SntyVogl8
Message-ID: <CAKEwX=Nao4jWtY04FXEjxiHUNUhJU2A6nCZLqhRRm-dPBZTmcw@mail.gmail.com>
Subject: Re: [PATCH 0/7] zsmalloc: redesign object alloc API
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9F750100008
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 616w81mgqbu45dwa7967fh8mppq9xh6o
X-Rspam-User: 
X-HE-Tag: 1793900221-148349
X-HE-Meta: U2FsdGVkX1+elItPVkFu9bOrb9kU7nfpTRWSCEM8adyapJLhUCJpzrg24ChhF/Uu1P09Dws0x41UaNvQIiw26dt3lgL51dn66vaNXxZiLJDqkErtlBhHr6mGGEsEcBVCTTG330Razh7HlVgXLshOd8zFaObCSDdKHQq14WlmOiA0IS+M9BtXeLa8vIj1dirnenu1ETxniLHkhNUL0MD/K8nNgI9PoxeIe0uuHdXuSE9CdT6jDh3qQ50Ec/USR7BI1CQaFrcVefJvrGGmnW3igq5UR2wCvdKKAw4zAHBo4H/jYsweWhmgpPknprvN8sOw7ph+SKoQdMVY10PzKcsjFEMLLqA1Rc/9L3QIpfY89mAjzcGfA8FfHPCzQhyFOobuQ6DeyxKhbdvyPvzlrgt9hK8QLWs7cCGNzuVy0LHz1dWBNHlm3/v5uloLiseFtd3Iv0a1urV8xNlzcr8OGQ6Qkm+C9qgL/1m39EU/daGZCj3UkrQe4OCUkP3D6m3cYScEVW1dR7198PM9IeGJ07FpNcx0xIIvEjs6bSLSeyiDZ3vU99n1wqB+Lsw5YIwBBF62WFv9AygNkquCpTcojfm7EdR5oLpc7ZeK57LZBXlzd9dakKfb0zRoPiRSw1fCHwfqpZq0gbnUNFZlxnoHBGM6nvZwdQZ0C0H3KGIBpLcq5ictUmSO+m80+bisGsEQ/3RzY3B1+GZSBOQ75HzKW8J5oyHajr6Q7ns7h94zOcrH97CSuefmOaQNEAauh1sYJRZuFGwS1LRZBkeued/2soIdAZitQDE7R6J62WZfEFVWl3G5zv19JUlR5qiRVbULM7L1Yc3IKbChBdRMqm6Ij+nhmAuvW3tQPXMk4M5m9qaDqthlAdg2N6znPh/6jNWxYS09N/g1MlN+EJzIVSx/AztpRagrP9KkOC1/a3dT8fOAMCMgYYNTOw/aYTDiAG0F6gYUYr5OjUrEhKKMLM6ShOv
 oodTJidK
 vG6he5oKD21IkALlgDVcc9yu/MCpl18AHS+NBuV5YlZAyWAXKiZ1Q+F1CyLMh3YPUsIt2bt9DxUI8a+oZw2+WGoa8lGBPK6eNLvQVe4tO0rYPe8lqikxVe+6dIYbpS+fBO0f3kcZ675KQtOpSCO8soDyqbj4kczGtzWH1JTlwXA8lLz3gFE0mPXMLXmVjdGiIt8jM3Drw30UKUop4pjxjmuYf58UrozCfka9ZOM9faOG1bjgmsrtKTdGLIRSxMklbCcSFG0nUpf4a6N1uZD0RYbXWu/YTu7sxLVtbfb+byCJOhthYFT2JYZ1+GrTje7yQrNqcM65cVaQFbk892cnIt5duOYF6pLJ0nPmA9KlSJbZfwqPZXqtKVOmAUhA6C5hNm9+ZsvylBbLgu2Xml/1mlro31VxB7X5g70s0YOZ/GXZyB2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 10:31=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Nov 05, 2026 at 01:47:30PM +0900, Sergey Senozhatsky wrote:
> > Both zram and zswap already have per-entry structures that store zsmall=
oc
> > handles, so allocating a separate handle_cachep object per stored page =
is
> > redundant.  This series embeds struct zs_handle directly into zram and
> > zswap entries and drops handle_cachep, saving 8 bytes and a slab
> > alloc/free per stored object (2MB per 1GB of swapped out 4K pages).
>
> I always hated that extra layer of indirection, thanks for doing this!

+1.

The mental load saving excites me more than the memory saving :)

