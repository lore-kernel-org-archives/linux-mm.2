Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13EF7606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kIXyiyO/
Received: by kanga.kvack.org (Postfix)
	id D734C6B05B6; Tue,  3 Nov 2026 16:36:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4B1B6B05B7; Tue,  3 Nov 2026 16:36:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60F66B05B8; Tue,  3 Nov 2026 16:36:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD786B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:36:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A273414053A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:25 +0000 (UTC)
X-FDA: 85395116730.14.0138EFF
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0ACCC20003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="kIXyiyO/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793741783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wiq41JYzn0rdt5xwEVgdCUgOHpCm+f2EZTVSBBYr7nc=;
	b=j4h9inOXlq0VUyZhTO+OCMs08FxSriTM39BsQoT0WzHIRESL95CR4yIm+bZynobzT58WJK
	uhgnqrI/yywVtLrfh2ePBbtVWYi6LjvXgYSCP4xS2c3200dIzHl/TSKHJeHlm3DSMW4qV1
	hXbAIOrmTYPxOxF3xfWs4ZqmNTPdzy8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793741783;
	b=U1RjzGCg7AOnRE+vL1bnoOX6jMhGVG3kzYRtGs163OyV6ykz/zdzrZaI43rGi4aqs/7KX2
	5Vwh+7bNiYrqioBRlHtTbK+ta8WpVZH0+UyzpOUwie2wI26guwMoEaJwyfWduAM/22KPd1
	TIWodOYE8cx1V06JW3/KpG8pSqYadkk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="kIXyiyO/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48fbe12cfdcso29381f8f.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793741782; x=1794346582; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wiq41JYzn0rdt5xwEVgdCUgOHpCm+f2EZTVSBBYr7nc=;
        b=kIXyiyO/7KinOo7nZXZmDHz2wpAEiFYBewJi9Wr9oFSou7MxGa5UTn35S6losrWtzp
         F7z99YS25R9y/p7HGyGBPHKc2zmVwR7RSppLomvOUzb82zOVqmj7rQE/fyoPaNFGPiTL
         aBIp3nX+Pj+MKz2IGBL8NqTELiWwc3XzhejFp0rOeszNLAynPpqwYhi6MGdtpPJqAAb1
         c9fBYfZW5Vmq9gGjjA/UaXf4E44eAEYmhE0C6HQueF9WCmbrCoAgsVvGM0Op7c3rlW/h
         /GH8flPtNct2TCO3IaABfWrz0OSjW5BQNRvRsjPrTd/NIzjTh/iWpHllHV1hUrWS7G9p
         yi+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793741782; x=1794346582;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wiq41JYzn0rdt5xwEVgdCUgOHpCm+f2EZTVSBBYr7nc=;
        b=nI0iBOfZ+OT5+/MV4VLordwFtBdMwN32YIUXJbp3a7UfPOvwq40hAjXefkf8ME93fl
         ycOnyg3BxskE4LYDf8yHIzWyxN2dly59107JxEY/uS/HNsq0NE+7I4Jc9JiHycnhQu9z
         YCgOYXCwgb9yjxItoez8DioGz8lcgNa6DYjMlFFFJ+PzifLJNT8LL7+VvMWt14JIFuFG
         zfgiIPTTTqFRdk6bmAzgdVNYijD73NcJab2/ktzyWsFBWjcm0d0FS02xBt5CDhIMdlja
         DsrWlq2+5ixuxT3/lamL9Vwp5U+PFem/mLiX7BSfFfhbJ2f4MooPqoskhvW3o6eYV5Fz
         ljJg==
X-Forwarded-Encrypted: i=1; AKwUvBwecudl5H3AtZjHHwj+itBkhiBvRK3i9mlOqVhxGAgtkLWwqerwzhNyoWjFLxRo/+BldYc89h07WA==@kvack.org
X-Gm-Message-State: APuU4Z8jhA4eokCMnX+4j1+f+66x16nyynqdUnbu/tJCXAuNLqIJske/
	IUJhL4Yz6nrVMMexRTyXwzA0seq9a02Sq0PbISLXvuvajk9rw995pFC7
X-Gm-Gg: AYBFou0ib2y4qQvjTzcO/eeqG2OxoXE//hdIabutib+fta8xtvJLC/k7IiDLOyjYsiS
	vhQ9ztqOW3CKEj2jXyy7Ld2bNBrAbtmXtLyMvl8BIn/oTzv7RWj+i7Rtufym4adFebpEMrrOEaX
	+h6GOerifD5w2j5avext+169+fc3T0GJnjlPzlY55rVQvmKgTfLNUgfThOxdSqVrD0WKAnTqyoe
	eVL8g07ZazkuJDNmkIwK2DgRzUoy6cuyR2Oqzozbr1qMuG/+j6Gn/khb0WOtRZ1uSFgGxtD1PO7
	dlFRcnHYGi1tb+8LchLTWz1n4qx3dzxZwXwaPcgJrt5ZoqM3OMrtGNo+m3+6EBUqDoXiCTxBniQ
	im21kYWdhAwhNo2ht8cbDg0wBcTn9UYbZEEKb/fefIyEQqESS51unGCJkDjCdPcPLaYFWlWGu0Q
	VpOvVersLbeFuK9/ZhA1odfi6UsHQ1EU5Gp76wsuXd6cOnmQs4DWDi+vN07Pr5A6/YK0PypjnGt
	BJubhf5MNxVo/rfdGDM0+wdhgAfxspgreLlMKTxB/muHdRIdekfmzZEEL6cW17l1rbnUtokxTnv
	ddvg6Kf5UFGmER4=
X-Received: by 2002:a5d:6f08:0:b0:48d:f877:3349 with SMTP id ffacd0b85a97d-48e6e4f8cf7mr30803501f8f.42.1793741782271;
        Tue, 03 Nov 2026 13:36:22 -0800 (PST)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed0844e2sm120549f8f.28.2026.11.03.13.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 13:36:21 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Tue, 3 Nov 2026 22:36:20 +0100
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: Re: [PATCHv2 bpf-next 0/8] bpf: Add user memory kfuncs
Message-ID: <aupT1C3SvA3Gxrkz@krava>
References: <20261103075916.100050-1-jolsa@kernel.org>
 <DMLRZ4QCSGYY.3D2G6VQA28CBQ@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMLRZ4QCSGYY.3D2G6VQA28CBQ@gmail.com>
X-Stat-Signature: c3ysic9eknuc67ysg7x7fyqedqoznw5y
X-Rspam-User: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0ACCC20003
X-HE-Tag: 1793741784-139792
X-HE-Meta: U2FsdGVkX18nDlxwm3CBZ2kGDu3qw6XsHy7cJbFjT29Fle2B3++LDP7VwhJpPciJQ3tFei+j4jhykVVJHnMfxARwL4BwlMRVGZlN/4vUgEHreFIhgUSRl8RwaxvBB6x+41d97p/xn/6XlFUfu5LE7yChnhi0keZt6qSF9PlfF729O0unEzV948KtllrVqgwxoP+BTwDjI8nx9nGONti4MWAxEj+JF2wNDyr7GvP3DlWo8cvEdQL2W8zgZLQDMcax0ygVUPaAickgwIOT5YNV54NDMgvhe2mV2puDPw4ePSzNH2gLuU9PttS69KGotgoYdFoXupjRyPKfly/vJPSVgUeFGB/M/l8Pnr+ddtY64rheNXvU72+etnAYx/BQkE+NoJTPWwCoLOVVFgOdPx35rNalQrBrCfVT4AO8jHmGZfzOE0YCLF54oZPwwSr/+7gn1VNGb5fSn7S5a29DJwKMZ8JHx2pkxVimG34OJUsUWyoyss+hQHxQ3OUfweP4t2Ot6HAWpC9Ddo64com5DGNp7a3cLr57fwMB3uZjKRfxM8D4l4L2aSlmUIJvrtT4/7UjXiDhvXT56ohxYxk5wRnIIn8G9Reb1CbZOau74jQ5hSIf8xwdrZ6Al+7atShu9DWbEhcPWp8mi9xNgP/9LjhGQQQihxCs5wuaqk6CzeY7JtqM/arScMtWccp/9fmzsOfTUk0mAlFuQm5UyfRC6BnouLTacfVyQ1bRfC4EPR5d4KoddIXwb8SvuUI35zrc/feBJ5j0H+/t8ZKZQwzMrbNMm2WA1tAQbhdGb+agutwDVN72A91SPpa/t8zS8q9Aci7d7LP358wYNoZ8TSRBg64i1n6PoBhyeWjScmnrzOkx/1LXu6aiMyc4RuDRUuvLapPu0orDXTPBdum/ntKkaRUQ0c99uB0bkBUyrUC3Q6PE6pxpl/xCMq2RWuLorLRWmw2esKqNty/Vh5tQ+apcztD
 I79KsjvW
 yDRLYDlcgIhtTf9C3bGroH/qseP2PuV7UUT9heVD8twYPjhcD6j2np+vgI0hs9pYrOofJtJ6Sx3eWzqj3KPBauX6NNgj9thAzKlFBiUNOBGA8GOGwSj5NY/vW6/LbLy9w60kYwZAZtZS2MWWBlM25FAURGLeDj0+99kylR0ylqYTVIZ81Xp0/CKnlLNw/faekaD67rK8w5jQcmf+fQoQdDz2GfW2uFVmdxCP7uaYb8iNAEudHC8SP6ekRUB6N/bToqv3Vgk9fbh+NpoC7q9OWtP5wO6dilRteI6+wNVcJ4NMndAfnE6r7fyCj0+BDv3EayfVgLuO5FLU4D931C1ztQrR3Z6cFkXNe99P6dcgwy67Bd3Ij3+UxE3FTuZ1i7BD/jY97ZpyGyyYcQs9NEtBgpFzWhRJUXgkGv7ecVjSiVe2nLXn4bwKK4allBpo1ffYr4mfD5eGJIf59yIkHiFFioKOKQp3Xup8JsH9iWLfEDuKIYRcq5yOvfuQVRcQEA1FWuSaHMB2fYocxp11uHhxYXputQ8LGPn3eDuyki7FBL4jrFyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 06:08:37PM +0000, Alexei Starovoitov wrote:
> On Mon, Nov 02, 2026 at 11:59 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > hi,
> > we have few use cases where having the ability to allocate normal or
> > executable user space memory would help (like to replace function in
> > live process or change environment variables).
> 
> Too abstract.
> See
> https://lore.kernel.org/bpf/20261016224310.3135990-1-alexei.starovoitov@gmail.com/
> 
> I don't see answers to these 5 questions.

nice, I missed that.. will add in next version

jirka

