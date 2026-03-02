Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55841E9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE256B0005; Mon,  2 Mar 2026 06:28:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9962D6B0089; Mon,  2 Mar 2026 06:28:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC7E6B008A; Mon,  2 Mar 2026 06:28:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0166B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:28:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B3818CE0A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:28:47 +0000 (UTC)
X-FDA: 84500900694.07.342F5F1
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4820A40012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:28:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nZpdcC+X;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772450925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQMBHJJoZF5XtHclIrWd6XC6kn/ibNoGfuTRAoEIRCc=;
	b=kVuj+8/CrP0fAV95UXjk+sAHU73Dl1H6P98iFSKyST9/dbdoJdhiozmPEKCcbH2peHC1pl
	K7IcLiTgxO/XFHa8cTc2eLUKshqL3siMkJAQALztQPnAa0pLzJ7e5KYmRj1XDd1PlGXOmJ
	uV8EG3ELb46sYcx5+M+HGj2lL7cYOmE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772450925; a=rsa-sha256;
	cv=pass;
	b=4H0MN8kWUUK47VNCkjDHZJkptONxqPbZ4BiZeesF0rxu6rEC1B+0xTqvejXFTYEsvm9LKJ
	UkACq6y0WKLyqpDZVHBYndTVgEa9p2HcoyyLZKxJaDIX6hGqnxRYFVU3bBd2AiuVoWJ5kl
	AShLzh4y2GmEs11D5imjEuJV/9RliVY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nZpdcC+X;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8954c9daaeaso53432776d6.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:28:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772450924; cv=none;
        d=google.com; s=arc-20240605;
        b=PE0lpVgIn/TUowPuawLVnuo4dUR6aMp3+/yAZtshP1iWidBWfQfOSLtDXXAy+qg+ys
         7Cu+5g+QeSXOtUEb6YpsjakAc905enPI5ATZdFCG+Auq0MQIj6mcM9swpbu+SciyMa/b
         haAD34HOUazfvEd7oxwq6OVjmsfIy7P+YHsWM8s4YGquAqYrrUz3U0Z2MGO8IDKqE9tp
         E0v7CWyIOXJD1BKdgEUCKEJJDecIYpJZRw3iuzefTWtEZFV31qXCaVbRatmgqc4sqHRN
         aTu7yblGgcAvg03QDZky56uNvz4sizbHxMRm93XLJu86fI2Ngy0GBaQKEK+ykx8iepeB
         THCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vQMBHJJoZF5XtHclIrWd6XC6kn/ibNoGfuTRAoEIRCc=;
        fh=02cpICd3uJ5SYLGchF8XE0rIJ+s5rfjG8IVpQUFEOFM=;
        b=V1DP4SLGv4h7Xi8IMdcf8S8drDjhEFtEkeODlXFEXIHGPQtIVwY0jw3dnSdHCQMNRQ
         6YvvjlhVvV50GgOPFWshU5gZJxEjtZ66kMiGLguDQjjNMCs9h6LYR0scbIsWEYtTQoMI
         bbgl3ahjamxa3P/V3a8NwmV3viR54Z+91xcIvWbXyC9BRLkYnd+xWl84tFt401aFKhLr
         GGgfDeLLB5D2Mdtb/AQkWNB98OaxSI+h9Ehu13PQI4U1aD97cEzF+cmD2AGs4aMcdg2N
         XX4Xroo6/03gnvFbcn54s7umF/N0umO3+jbdcUb0MbGeMiNpYdv9zpJn6N7SoaiwhkXS
         ycUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772450924; x=1773055724; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQMBHJJoZF5XtHclIrWd6XC6kn/ibNoGfuTRAoEIRCc=;
        b=nZpdcC+XUK3DmQtIUF0wTfbACfbW1JctOF6urWPBduEPSGkHlPNH9gEV/xWSRXkSRJ
         RMYP6wT3WsNEljOjluDOHXTFsMkrkkNJzsdUZ2Q2DR6ZYLt4eVghVmWgKpFvU9KcfBNi
         QK6MT4ocD3vmcIL5b3c8TzlREiZcD+mAcBl7ZiFaNRlkySiuNFrdDzOHGivGfYl3A7ti
         fOlHPyPFkJPpoLmmumEnMjEpNIEMmsp56AxAuRtDqLhVviTu3UBSkXZBRCG+mn3Y4fGy
         OL/C2Y2KLY+p4Wyxz8EAR1nG/nYW+cn4nD8ngGdUm4ud9a77DG30tYDaZyldp90SNTPh
         xX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450924; x=1773055724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vQMBHJJoZF5XtHclIrWd6XC6kn/ibNoGfuTRAoEIRCc=;
        b=gIL/oFlTckqjaf4IDDHpl5HV0vI1JcW2Fan9A85D1Ra0udze1CcFi8JKGaFwmEvFxZ
         77RcxYiQT7gPw5/BUO539fbM5ezCwMAneqAbruBD8AiiSNFbkke1VBen6xhjcUYWM3Yc
         AUvve2ekc6848LXBQ1Bh8lgwyINZgSOswiABXllMKB8am7Oerto4p3cehf6M3B+tziYS
         mABcmGxXpOzYInpC77NrHqwTVrLt3XJFJ39ZjzR08ZpMuq5avumtZB68bUrBBS49Rj74
         lLFs1OOdAEcg80Y7dRIGalBFor5wLAYxDuvyvTJ7KWdw6P0LNXEXZo1zf7sXaYF0Y77T
         T/Kg==
X-Gm-Message-State: AOJu0Yyf07TmOFsz78YeWC6FfYvoDl1zvM+GbbU3YXtl1sluMpFVjkci
	o4/M+1IGXP7Pi2ppnKEdOcnXWVm3vymgndbPZvJzDQx4ZzYQVsbISHK4h6321o29SH0RF/0nUHW
	68GxCfL1U5nV52dBJ76gKYMkEO3NLnOA=
X-Gm-Gg: ATEYQzw9BC30kZlTIuX+H2XYiM+Ng0PaAh5U5Ra63fIoLJ951CytlQ6+WplQ/UF0rh+
	oHb+3aCUXHnV37KOeKpekPasLTauO6ey7n4oC8wA1SBYyR2DBt4jsY5oHCmAtgyzbllMdL5qgA8
	SKqCFnw+VS36iEnYpCf+X9zv69c87HgA03Uej9aOSIQtLd52kL/AeDuCZ0msZpi4zCk5Nlfan7F
	KDoL8y15nG94Utm1Yal4y5ULb9CHDKPuxx52W63nGglRO9sQmPDGfWzybxeYAcVZZ6y7kd3t0ZQ
	KvSydw==
X-Received: by 2002:a05:6214:c22:b0:896:fbdd:ef1d with SMTP id
 6a1803df08f44-899d1d862f0mr176207056d6.3.1772450924193; Mon, 02 Mar 2026
 03:28:44 -0800 (PST)
MIME-Version: 1.0
References: <20260302104016.163542-1-bhe@redhat.com> <20260302104016.163542-4-bhe@redhat.com>
In-Reply-To: <20260302104016.163542-4-bhe@redhat.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 2 Mar 2026 19:28:33 +0800
X-Gm-Features: AaiRm51F0ref6niXp3JagpZ07FBLRw0vGo8-y98eUdHmgoUi5ptCC-MgmXUOKpk
Message-ID: <CAGsJ_4yRuK0fjWc_OO1f3ydt7TaxGEnDvxiJ+Xe370iy9QOMnw@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: kxkdidjbic4o6h1338q96cesfbykcrjd
X-Rspamd-Queue-Id: 4820A40012
X-Rspamd-Server: rspam03
X-HE-Tag: 1772450925-673658
X-HE-Meta: U2FsdGVkX18QG9wHG7aIRdGW1obkhekoZXulUcKJtZmKwi96q4fZspTHAaTWthmn2O4zCUA30wgLmsGn3xQqoHvQS2xrKO70fv2gWOYz2GtHcgXAscnng7AJ6gqo8XV+UB2tGaFkUCzaeChEGbsvHK85P5VOPYjRHxbqn6v/wx3QpDb1XYsGDAFgxUNCMIWCwRpSQwYfRaIaQECtH0WMGr14Fblja1Vc8ZfNeXU9Ji+wUZusR/DjHG1fvswdLckSkJB8WTEbvzPtLJdFTgo90Th7KOmtM1T4YN6I0a41nLH4XxMKiRzbPXc0XYrBYMtp1gsQcrJfMBC5FPhDBL4xat7lbMuc9g+AP8WLfhLC2QgCMmUCdWhPtMc52BJ5of2qJIZncmuA8G8qviDmgxT6QIS7IXuQZMNFHX2/FONiSRR19c1evU0mVxzkakefSCjTAyN8A/87N8dleApKCBArNZCdly+8bg5E7OOne4ydlR1Bi/JkdGyHkYuATryIXYoxTXAq8kYV7l7zDvXrV4szE34YmOjDrFDEJtuEYaq+aI6VVbw/q3zfUPdJbC5qjae7icVcFxhtxSwqLfogO/x6UE15NZjJ69gw8F1g6KieqQLzOmqgaPLKbGRAoLIMBJAmXse+MeCENTcCcZoxQg+k+VYydipWcRHbHZ5JTDz/g3urRD4kvKlk9jhEfh0qA9EIbMuhnbSjq4x5/62F9+1xGNIEmT2/lh7nOVWmyz38CIpDd5NOXmV7LQa5++qy7/Ch5ItsoZue7QraYXHXmky4VFygDBem+r1LyerbkmSPXn5ymAEToOTO2pTpi/+XrlbQZH426BFKg8lzOY6ULn4PE13aeteDQz3Uq5aCVQmrbAB7zd9BwKSWdxSIFcT4AnIUmsCndqiU8r419pqvcyt6pHS897dl1KVA+OTFJO6eePDC1VbFtw/CMkZadrIDblmMN64mu4E2o/Fm90tAEaU
 ikPakV4o
 mVMa8yvN9Kq+5Y1zk3XPywFZIP74f9yyKj7nAq2pRP40IlhoEmUmwvbk+pBZ3kvb/Py8rYafuUN/5O1lRMeRgB3zfl0dIewTr3aJnm/kOFnzeu9m49U997upzWBmDy07FD3/qLrR+t8U59obNg8Jy0vn9herMCY3zEN4VG1W+DMADf+n4i2lKQMBgZHuzKl42pZWjLC3B/uCFgSE43PJGeoemc16VKKH6ogpfM6zF4U2o7bp1B8U/tVILpaWAWQHrU2gusdhs0CoYg2GpbgGQv+sAVaIET11M8YtJin2lHyLzJ/XJYDRJ0Ky6GbjqmX6lu18LxeZUcAj0R+heAXOEGHc6AUAoL7bJB97iJBEgT38RTb+jm1+LB1vHGm77EXaWWJWrWjpDz+N/kHw9dYHFf+iXRMEmluyXoPaBnhU0A7z9dGf6biecQyUTWXEmIY41335gUV6OsYxTKCmOMlFjbt/D8j1Oh/Y++4AQwZYKCP4viRG2nS7SXxg5BA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 6:40=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> All these swap_writepage_* functions are hanlding passed in folio, but
> not page. And this renaming make them consistent with the their
> counterpart swap_read_folio_* functions.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/swap_io.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

