Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D63A3CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 07:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ACC36B0088; Mon, 12 Oct 2026 03:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95DD66B008A; Mon, 12 Oct 2026 03:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824E26B008C; Mon, 12 Oct 2026 03:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59C496B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:57:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0A1E1C435D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:57:05 +0000 (UTC)
X-FDA: 85313218410.11.C80943F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E45CEC0003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:57:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCp5AN6k;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791791824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gowwe8axss2+O2HwBq41jmehPF78rOiKV0GKeG6qTnI=;
	b=iW7VNvjBmzovdgYdYmn2+hNaG0ok3oQEpTOUe2YlM9j/7l6kZyRRZ/V/zC3iMo1wWAzgxd
	l2r/eFq2AbSGTgYBqCdtTdxjID4Weo9rpsGKIGYFNrIER1dC3Z9kdaEBAJSvpz+UcvYy8Z
	y/C1m3vonYbzktPqloQXbAotHsLJlIc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791791824;
	b=eNSjjiAxxHAhQ9A+pcuAIkCWPV8nhXcv/0C6BJrrUDlq3tOZyqWH2M5IRqWtMsiaED2QBw
	gvx6XvdmZW5hInCGtZkLL780tW/MbmwrbcFrpU397PJAuQi0G+Uly5HVch6IjXjtHvvzTF
	1nIH5Ddqe++2nqm7S/wNj3bT4rh3tGg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCp5AN6k;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AEF1C444FB
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9707C1F008A7
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791791822;
	bh=gowwe8axss2+O2HwBq41jmehPF78rOiKV0GKeG6qTnI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YCp5AN6kOS191mseGl+KnE26nqDGIc9TCMHWBCPFSyVGzakxThxu4+h00m6+H2ojT
	 MgK2QQ0lp+fmB1vcsEHNGXS+9GbTjxYbCFK/7GZMU6BFuX75T4a2LSbkG7TSI+ytPE
	 QL+kb7P1BMJcWiR507Tnh/jg69j16hzJql3GOuBodlFPk7Mk+4JNyhTQHQhgiDje/A
	 hsWAzV4aEWPFZ81cMF2g4H4WQZf/GoCUX2Za6al45NJr3lOictWLvr2KNIHKc5k5Mw
	 vnejxbBp8aPdy040DJqX3YgaNH1VIleZJnEWONXv+hq7RPgHdeKUsH5PB1dMaXEKgf
	 EttyiwdA9w0KA==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-917b78dfe30so30679466d6.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 00:57:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz4jJlHEhuQupBFVuXGQ2p57NOeGOK2Y0Mmfn10zKYwQvXuZY2oNy5kh14sh3WcYhJHsul9hRHncg==@kvack.org
X-Gm-Message-State: AFq9FYI39dvp1iwxROcfRxGvs+8ZxYQSeRCjL5AvYPlYeCp8zJRv3ZS0
	PxmCqD6bU2Vusqdlxjb8TIrv66xWvmCjP9BNRf4ZNyvoiPmq+/re705yKvndKFnAB5C1COXb09d
	j04qYYtICKJ+GqD8lgWU8QRWEgnsB1Lg=
X-Received: by 2002:a05:620a:2b8b:b0:93e:c12c:fbb6 with SMTP id
 af79cd13be357-93ec12d082emr1367857085a.67.1791791821896; Mon, 12 Oct 2026
 00:57:01 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <CAO9r8zMHKmAQT8WBAd+kkQEjETVvyHhfbESzKHpXXPQJUB9nVw@mail.gmail.com>
In-Reply-To: <CAO9r8zMHKmAQT8WBAd+kkQEjETVvyHhfbESzKHpXXPQJUB9nVw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 12 Oct 2026 15:56:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x3JL9JW2cBXPo0j_8-2d6XQQGSpBAkSf-8Hw9N=0o=6Q@mail.gmail.com>
X-Gm-Features: AclHuK8gJTkY2DRBIX9AcRDZ89iXtxeakHxULzQhlgHDZmLjl5T6JH2Ua3dDbhA
Message-ID: <CAGsJ_4x3JL9JW2cBXPo0j_8-2d6XQQGSpBAkSf-8Hw9N=0o=6Q@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Yosry Ahmed <yosry@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Kairui Song <kasong@tencent.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ryncsn@gmail.com, 
	chrisl@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E45CEC0003
X-Rspam-User: 
X-Stat-Signature: t9xqj197a6nk9pfhpuwh5ph4r41fc5dn
X-HE-Tag: 1791791823-356452
X-HE-Meta: U2FsdGVkX1+4QedBh0CAfnybg5s66+i8oZRXh6QrLi80IEwg1ZzIx1UjSzInoH4m3u+mVwh6mLu+20uIMzMGcFeGtq42JZ5nbXocMyTw7f+GjVw8c/6Eq4y816GuFOODNtKds3yy934/pwJRz99ajTcg7WErxqnm08lx83+wMWgneB3QsEqfcQze0ae6lU9Vgew3p7j+WodsL0c1Q5NS9PzJ9istQ/zDrzLTiBXDccatoGcJuxSA2QlISTVEs+pBdkb7gw5H1//r7oFSk35crrtEIbOZiSP1+/fIVP3jG3DRXFf4k8aQVqScGf4vrulRTtalsBOQS1aII58kAndIjiQfRYnDd4vd+V6ycxsfnt0KoauXBYuax9pZmTzInZv0mcnDeoj8/5yEzWrW+x+bdEOl0YGxhxN7IbT0H04j/GB6YmLvirGqNfzCWdEpLYPorBeaCjOiTDydIoAvdnfVJ3PB2pvCicleboJ1o21J2AAu0T22S/uLZ37cjhaXMGpo4HvFLV4AZZoKdyuZgkf5R/fifrybUq9TT5sMvyVzBktuApMdXMjzBgCFCa7EXySOsoPB1OYm9s2IYLaw8iAOQff6QoolHGgrlyaTU+jsZuUfkfnfiz4C9uQqDM54r50JW/aZL1kt5T8wS0pxfGzk4ZZVVsAPKGgf9SR72zWrXedW0/o3G6ZmbEud78aFlqgUFIs0WVm1cjFPdsd8/Jf+vuajteP8++JwTDx55WNd+KvI0M0KNg8qHkdejH8sgIq8QAWbmv+Exq6FDps1PzPXb5qXF9TWGRz2+crLVZnT35tP9mvea2Idu6AWsjgFdqdAQKmXOk4Sh38bM8NzxLk6uIYfOWZCbuFHBOdH9XNm4NAUeUS3xwv/7Tqx8E2WC08oHkrX02AIqWJ8oj5YhuIMEdfGSgFwBZnFJ8d+G9KAKBTkYpVStFtyumJL3rFXstwx/VSN6rQm5N7i9o52TM1
 edwKgsDW
 hDqZSXKuLfQTsoGIEommxtEIDdkZerzKnx4M9vkBg8M/7/IEm/p/SYlMECMk18KNVFmIEbMDlvbXyxE/l56lOdJeuj2SeILlwWVstxXPq4TExizx+w5lqlvgSskrKY3iMVSoFqJH0pHv5lSY1VdZ1OqCzb29J0Thu3LO8D2bck9oXOOKCFRjqQf2zpJnJO50KTpZ1hovo6XIe/Lz/0WMeIR8QDEJcwz6S+duZcrFgaFl1LOsy3oQgASV5JDyT4EPJJHS6jS09y/2wyUxghL3dvDElSS3CY3WPFsluTXOijn6X+x58CMcKbewLxS6lvTmaEplDXPRluwHwcFmTPf2bi7C0E5RFiHrQHqqlzvE3vWVJcJRN4Vt4yzKVmF0YVIPBR+rqmK7p2WMmo5YHMaiuzVUVQorktaU9Xhdt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 8, 2026 at 5:37=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Wed, Oct 7, 2026 at 8:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wr=
ote:
> >
> > Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronou=
s
> > device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahea=
d.
> >
> > zswap is the same kind of in-memory, synchronous backend as zram, not a
> > swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> > swapin_readahead().
> >
> > Here are the results from bypassing readahead for zswap too: it was
> > measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shri=
nker
> > off, on Sapphire Rapids and 3 iterations.
> >
> >   768M memcg (sustained swap thrash):
> >     metric                 mm-new    + bypass    delta
> >     build time (s)          405.0       341.7    -15.6%
> >     zswap-in (GB)            79.5        53.0     -33%
> >     zswap-out (GB)          144.8       115.6     -20%
> >     swap readahead (pages)  6.79M       0.45M     -93%
> >     swap_ra hit (%)          72.1        89.9     +18pp
> >
> >   1G memcg (light pressure, build not memory-bound):
> >     metric                 mm-new    + bypass    delta
> >     build time (s)          177.7       176.0    ~same (no regression)
> >     zswap-in (GB)            10.2         7.5     -26%
> >     zswap-out (GB)           27.7        25.1      -9%
> >     swap readahead (pages)  1.07M       0.08M     -93%
> >     swap_ra hit (%)          68.6        87.2     +19pp
> >
> > Similar gains were observed on an AMD EPYC 7D13 host.
> >
> > The gain is from no longer prefetching pages that are pointless for an
> > in-memory backend: readahead inflates anon residency and thrashes the
> > page cache (file pages get evicted and re-read), lengthens each fault b=
y
> > synchronously (de)compressing a cluster of neighbours, and adds
> > compression traffic when those extra pages are reclaimed.
> >
> > Bypassing swap readahead for zswap therefore makes sense.
>
> No objection here, I am just thinking about Kairui's LPC presentation
> about how compressed swap can (in theory at least) still benefit from
> readahead: https://lpc.events/event/20/contributions/2421/attachments/211=
6/4689/Better%20Anon%20(Swap)%20Readahead%20(2).pdf.
>
> Seems like a big portion of the fault cost is still outside of
> decompression and can benefit from readahead, but that isn't the case
> today. I assume any future improvements to readahead and re-enabling
> for zram would also cover zswap?
>

In that case, if we can develop an accurate readahead algorithm with a
high hit rate for readahead folios, we will probably also need to map
them at the same time, as proposed in [1]. For example, if we readahead
4 folios, we should map them all together in `do_swap_page()`.
Otherwise, the cost of future minor faults can still be comparable to
the decompression cost. Readahead alone would therefore increase the
total work, which can be quite significant for synchronous I/O.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4xM=3DWnFO-OuwVude-DQ_UkaCi_zF_b=
XBP9Li5+ZPNy0VQ@mail.gmail.com/

Best Regards
Barry

