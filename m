Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C7CC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37B56B008A; Wed,  2 Sep 2026 02:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10436B008C; Wed,  2 Sep 2026 02:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4EC06B0092; Wed,  2 Sep 2026 02:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C43176B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:29:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57A471A075B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:29:52 +0000 (UTC)
X-FDA: 85167846624.16.5B2865D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 78EE7140006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:29:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhwMWXav;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788330590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRAw/kC0iwtoV3FdnJXkic4hdm4mGBrURlUSImGfXWQ=;
	b=IKemm21xazt1oT+4tBdkrLgjRzenIZNH42ub9GGOW6k3rGEa82u4/H3SqWBmRrFeGQiYLu
	P0si1vemTVftc8S78aTz9nd7UPAT35sxll8du0ka5RcrhUvN1frAHDxBTSbQgjk572+O+t
	yHhkN6q6vwYxx/DQhEIwuRC0Oa+Tzpc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhwMWXav;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788330590;
	b=yI6hO3FFUIz7SoVgRmD+KFoPRx5K1DiGVuE/TzfaE+e0fp/Fr2o3ii2ZsnYvVLj20H3epp
	ZLnO9vYtVWKk/H1Oco0BnQq28pd6dN2NPN6DC1O/qgRXPMCBS561b3gy53moGSgHXUV6Fu
	LLmoSzpPA5BlqPFqUv4qNvvoa9IFUl0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92A34444F9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6B81F000E9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788330589;
	bh=bRAw/kC0iwtoV3FdnJXkic4hdm4mGBrURlUSImGfXWQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dhwMWXavq4ih0BcJvdepVPQYJSPg8sheLLU5hnHC2t6E0iGD08jnwQRUo4WYJ2AGt
	 c9qpeKjUA15MIXSKSrjOC7/wAR8POb1k2jGW0h0tGI0ZjmFqUignDoFEUBt+orrY6A
	 iTgF++Oy/DKOGWCT6UuOF/Lfo/f0cz+xS/N1YohFwR7/zZ4XbpH6IheBBbDcWEWPUL
	 aI9iyfLq8N4tGW6DnQdsxejUQvCiJblirRVKmPgtW3LXGkY+NByvqc5aQ6WCtbpiXf
	 QAKqkZfxkLm7VacIvWUl2UOd25gY/TPH4264gd+kWQtqgWouYZ42nDBYCP6gW+rdKw
	 xGzs3Aall9LKw==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9390f8a1c9eso65913385a.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 23:29:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqEVC5kl33xUSF16NyLwpjsN9hANm3ZabpK5aXTe4flgbrICzgLFVKjAfcNi3oLjuHKqynZT1L8KQ==@kvack.org
X-Gm-Message-State: AFuF++m6KwylqxvRkKUXzC5M+it3kkYBWLYZOWuywlN4EY+MzZLraiDI
	7r9BGvs+D4cITIoh9aidTg1TFYHvd/56eWds49DW0cpoz4oNsTt/fhAReTvYBaIBjKl3x+YjUsu
	/oscRliDRAs4w7/J3oBlCk2UMdrr3vpw=
X-Received: by 2002:a05:620a:a0cd:20b0:934:aa56:45df with SMTP id
 af79cd13be357-93960df450fmr271672085a.11.1788330588481; Tue, 01 Sep 2026
 23:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260901054358.4049095-1-dev.jain@arm.com> <20260901054358.4049095-4-dev.jain@arm.com>
 <CAGsJ_4yGFBRv-C3UV-G1tB0HUmhVvJL6ac5x_Dtu9NSGk9BGzw@mail.gmail.com> <55e7bc2a-dfdd-4cbb-9bf6-ea3bf4b03cce@arm.com>
In-Reply-To: <55e7bc2a-dfdd-4cbb-9bf6-ea3bf4b03cce@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 2 Sep 2026 14:29:37 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zi=1hq_v3J2+eoGGnv=3VzsJbTejX1HbDDSAmF2Pamdw@mail.gmail.com>
X-Gm-Features: AcwNN1Xu0lESa3FupCaqM-ki0KipDurhFoLH087Q1dWylSkqMuwZBSC7YkpVUj8
Message-ID: <CAGsJ_4zi=1hq_v3J2+eoGGnv=3VzsJbTejX1HbDDSAmF2Pamdw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] mm: move anon-exclusive batch helper to mm.h
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8djwuk6cer7p4wc6p96ntqg6jzn5a6qy
X-Rspamd-Queue-Id: 78EE7140006
X-HE-Tag: 1788330590-320032
X-HE-Meta: U2FsdGVkX19FxCBUsiPDqm6LoqKY4oJo9stlGGP4lTjD+1FEgXTGchZzAKIGWisg1JpEMR09lqfH9e44cqWWXvN8Bv+i405vJd1iCOZh8dB4mu5L8WPc78qZJ0y10mmM0vok88VXGOQmtD40y9QraynB//ByMEn2rsUID4Iaym5goThazFqCGgXf6HsW64xko7YaM2QkEIe4vLEDkIys9mKev6rBU3ziFBS2tIo8I+hEItUD9/P39l6Kn9kCXRGAoDd5SiFkLSeTIH296m6vQbO1fBWrOqiBvRAG/f1S4EQRZ/O0mNYEAVOFWvro4gtwT49NhQ2tOjypoJTCT1dtljrUfYrvKfynW/Gw0K+GrUZPSVq8VE7E9hqMvzXzP1fEL6kqlFR/gDCrtPRr9HoKNsEmdrgbzmfXnnxJOv7k35wKVf0/4MZlbqFP85FSe+AqU0xb2BDANul83i8TmcaWfL6AW71uC+fnS7myxP1B0PTMkFjNkrDmkEub2b/NF50m1tdxT9uRP3koZABXI5ySsxsoxh5WMYC+/1od2WUYhxD/msgj586WFKR2+Vc/AqGGuYBoLkhOFpPdGOZEsP6l3bGINl+FV9S+GlEZnJK7rdtb2Y3eyeaE+s9dKAzgSaCUSn78qRsDs7P19bzUDTkA0lJy5brh4jo9QTbCfyl8B+m31Tb81kCDx5H9yZ0RqC9I1am9dgVY3c/xe8R0i9scko5+XJ88bX9zqSn/puXZ4Io6gD3pUzsd3WfKV5KkdsVRvIMa/5Ocg0E7y61L4p5kE9uVKMt9SBiDOQPG36SZ9B+fp8wcrxIYKFp/TrkDocrNftcS9vJhDqo/po7rpUKPjA28W4LuxcDcUdU/bdvwtCagnxiKMOpyKPyP/iBCiwNsaOQrb/oquJc8ae6W7XIqU/632iJ30MX/MQa+gZuIC2sstEX49Z6FIrVeLDYskhUUtMq689Pm5nkmcMSZw1x
 DvfrJ4rw
 clocdNmJjSLej2a+sz4+6uzs+42gB6y1+3ttE6k7usDKC4nsLT7t7yOhMf53Nl0gnWleW0UpKNvkn76dnMgPXE4Nz7bCgR0szGnsXq2luZoUvrrSaLrcYvhZvVeKiKcKEYt+ibn3RUQEd6VpSDbIfBTITCd321vtVDmLCeEkQ9V3jDD0WNULfeqtkqhC1GgmMo73Ut5StMhSuNlDitaiWhtdENNLb0LywEKjniO0mQX3SD7bNYMG8jODEO9YZkuLr658H7oxiqi8ojxct0gA2ybRpApBTVbc4QXs0idi+tCSt0yQK/ScfCnjpPlkr2uC4jgbbcJ090LSH/SsFfa4v3SnS9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 2:24=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
[...]

> >
> > Hi Dev,
> >
> > I really don't want everything to become a top-level header
> > file. If these are only mm-internal things, could we move them
> > to mm/internal.h or another more appropriate header?
>
> What do you suggest? I had it in mm/internal.h initially, but
> because I had to use the helper this time in patch 4, I couldn't
> do that. The helper will now be used by mprotect.c, rmap.c and
> rmap.h.
>
> I can keep it in rmap.h and make mprotect.c include rmap.h too.

I=E2=80=99d vote for this approach until we find a better one :-)

`include/linux/mm.h` is already way, way too long.

Best Regards
Barry

