Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ACFFCA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 16:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96766B008C; Wed,  7 Oct 2026 12:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76426B0093; Wed,  7 Oct 2026 12:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85476B0095; Wed,  7 Oct 2026 12:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3AA6B008C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 12:47:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B352802FE
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:47:51 +0000 (UTC)
X-FDA: 85296411942.13.5A6E871
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 96B321A0004
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:47:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jWcWDR3y;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791391669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUg8bGzuDc1hntbJS6/jkPP2umt4kBrIq8LnvLb+dZA=;
	b=q8MEO737FkLqw2p79EmyQExIhfw05vqx5kU5enDzZspyNk35aEyD9XfHtSzLgQg8k7N1I/
	bwFIV9rd3KiM3EeXoE3os71E6EhaW+O/mQ1CwzNmjGCgbmKNK8tUNq/QNvFEe2gy8mM6GN
	mO+ChqpWDykQ/DBlB2wXqGHnMoqPr0U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791391669;
	b=f9yHBjJ3ln1d006l4ohWYi4nmYwphKMpaln4sPfzohD0QR3pm7AJrh8GIQlEAHivfZ/sPa
	WpBhPSbBImMk8J8X3OyGEXOowi4ai9WwRcLp0h8n/ZQkeiP2NXMqbdaF2tsH4USS6ds6yt
	RXF9c30HfQvLmq0L4YCSn6rrO/p1fwI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jWcWDR3y;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48b02a2359aso1921092f8f.0
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 09:47:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791391668; cv=none;
        d=google.com; s=arc-20260327;
        b=qBVUOZ/3IQnGK2G87/2AynAgAG2x+nPYCKxVG5STxC3Q5gkvGSVNtbzEFH8hdlpHhJ
         ml13zmbkCyqGPDni71GNTDB98MCctUF6QoRGEw55cjYrUDf5u49aQNBFNBRHBu+2jDDS
         mugNOogrBXHKUGqklLnNq1QLBhEE8f+SN+uorI4/jHwx47XJgPRjTavY2ZO4lPq/Q7Oz
         QBf++lqCoq5TV+Bkb0ZVO0kf+AI1853K+YCEWbl/2cCAd8ZaUF1Mlcr3ordlicIcKyjy
         lXZS243WGJWL0zyBdtkA2vxuGyK7IHn9Pg3sdich3vMBEBeYuKec7FvrzHsZc8BRZUjJ
         9ghw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mUg8bGzuDc1hntbJS6/jkPP2umt4kBrIq8LnvLb+dZA=;
        fh=5xtaoSAIvBS5k0Fh6pwhgK6nYKehekflfmaVHCY4PGA=;
        b=Yh30Kf8eINBDoN8d8o45lXRLBABO+tkItlQ7UStHEKPHvgtDJu7ohTpruqnkhoAk6X
         9IS2FotGLI3DSkAY6SOTePBX5IfA6SXlnLdQFZsx9x1RFhgSdnByLagTVHto98tVLa7D
         YQvgcuTEoixrbBGCzvhJjeb+7HavgjPUp2CMi5uaPRLkMkkFEjGrdVQ3qgkgEUhVXzIu
         VXZCvobZ7R/1a/etdbFxr4hD7Mwu3fGLryo2IFJplUKtHAemWvDl/4rsKt14zTJAcMux
         5ZPrKMfZvxxUdEv6Vrfn4iM4+LZ787NIoVIaM0wG7eKtfdOgoY0s6DxmRmxTc9V1512c
         kRYA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791391668; x=1791996468; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mUg8bGzuDc1hntbJS6/jkPP2umt4kBrIq8LnvLb+dZA=;
        b=jWcWDR3yACQaDdZrmtqmx5xH4Cr/zgAV5cJFeApVNdi/UrDmwfWCzu9PRcSjJOCsEU
         cTX/u0RlLWNdL9YUsBfSC/oroE3ZJA5fsGExCOqWVzy97F3u6++6kMDylXltMqNvk8Zv
         N9YIiEISarm/WKvgYYWNHftFPKoJkqQy9PNe6t2nwWZG1Gqe/842p/VcyrVXEq7VGcyf
         UOs8zIfpOz52nKgBwhOw03K9ZZvshucaIEhzGssY+0NVm3xzm1cXwjM/bo6dU3MAIlVO
         AWTqDa2JejibJGnFz6Hb7vO+bwUCZXf6l+NqXUROU85liek2rTfieyEf9RpqCLksBk2m
         WSGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791391668; x=1791996468;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mUg8bGzuDc1hntbJS6/jkPP2umt4kBrIq8LnvLb+dZA=;
        b=ojrE1YehkmlUHeR7UT3m63rBUQg5danJat39uRT33TjGaktHT6h782es3cXlR6pudJ
         72ZW8+za9pBH3aRCAx4pvg9UT6feYpOacE9JZT281oaOS/HTeVDGq9NG02ztznw9jw7a
         FmJNJO9L2YBhW8OmtQZa8HAJ3V7NMJWktsuppI7vBaVfBVw52TsOeiKStl+Z1w0a+gAM
         3qN5yLnpopyC7xzePcbPt54ApQJq4a2a9SElso7UdHWE6TwoDkzv1FGqtd+ij2mpFrbV
         gsmF5Dm9wnY0wNY9MF0oYLhRO4/o6XcGmHQ4fqxfiwCk8NoojONmj9uS5ardjtAwMqzg
         muEQ==
X-Forwarded-Encrypted: i=1; AKwUvByX1bH5MSvMGwbui0r4sBKygYxlSuPBPOsGSrZHvZ2Dq8AV4uhK+jahvTojm9WbUIAtZtmyeQoD4g==@kvack.org
X-Gm-Message-State: AFq9FYJCbByMHcO3sfmWxJxRsVHlj1+jtGc+6cQp+CQu19NDTk6s/CiI
	fhRBAOLQDzfII9Jg8D9trzi983BM4eQrnK9zWLxNt5DqprplcEPX4ewv97QEgpTetDa3QGunZF3
	MgHzXCXXG4OJcqNpYGYZl3kWqYGOmM5g=
X-Gm-Gg: AYBFou37cw89cABX7lNhY0sECdY9WVHuZtW6adv6sEwIXguzBg627KSf+mH6AQp0I4n
	FouRpctg7J0H0KKMDaYNmzY4qs0dyi2X2uAP5U+6Z/ZPg3j9gNDlzqvB2qMDprv08JtJNNLzGV8
	CF1w75ClvFR241JPyGboHdAvCUcscreM332IrXSGBx+YTK5WxPyTawGU66le35XCFJlyJ8t27WY
	c1yq6duyOfvvTz3l1O640yi31IEfA321Vc6gWkEVOs6Pi1pZZ6lwdaFY8b0XKZmR1mHmx8FGF1n
	zq64I+4hQqhzwNZaSKZ/a9JoC185XaBDNnJkKmiRsy50nzfTmBlinHZfdgMRrIgu9XpqWTJdC6Z
	a/6pyasl3tvpS
X-Received: by 2002:adf:f088:0:b0:488:5468:c23a with SMTP id
 ffacd0b85a97d-48c7277b307mr5249685f8f.17.1791391667725; Wed, 07 Oct 2026
 09:47:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com> <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
In-Reply-To: <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 7 Oct 2026 18:47:34 +0200
X-Gm-Features: AclHuK-gd21Gfnuh5UQqK7_tIu770TUyW0AwEOlzN_uNtFL1qi4hjnyF8DTH4ZQ
Message-ID: <CAKEwX=N28g4T8mqniB-e+e57ie9D3Koaeq-EmV-TEk-u41FBPA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <ryncsn@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96B321A0004
X-Rspam-User: 
X-Stat-Signature: q3615qrnrdoe8ds35y4kbro7qo8utte6
X-HE-Tag: 1791391669-77385
X-HE-Meta: U2FsdGVkX1+FP4nIivemCbtOptH/wSMq7v3+WcfJmBZZrC5yRebzR+JTFjeuqAnQjnRRvV7UNKY9VCu5W6vtqWL/uwUmZiKqFQZVTDyuDSvWJuHPf2lkA+N60jC4pWRnOPdT9cCY5PHcwPF05HoLNVKcriA2RgGN/6wvw97M1dcp2vlJzYYE8Gmbdwq/AMV/df6St9sye61EUhESWN2/DyCLiCBEGnZDR9qWuQgJ2edwK9lWLtCiVO4WlBw2xgWwz4FmCb+JtQs7UIQMFE2dD80jHQuH8MsrHFwrzgL7TQilDbwDtMfpJIUKg/KVbp7xwVcKV0I7FOKR+2J9lDET1jKcolusdETJhnzcN+So0HpU/p/ZTJnDiEVv8I7zswa0ex99mSvOybjL5PbZ3vK21CcrjigJFuO4AWrhB+kfKuAv69I3VArDUtmJim7SqT0Gl3qC31jDofvT//RQsPJJyF+bQkOB/mv7+eSwJaOncyok0lwHKza4dcBatd57sppxY1MakvQHbEHddZ4zkOi8tMSNHo972OyHf1Pi2hAUNMmr1jNuzpQ7kYakOtk+QEf2q49HlSuFpLWiMugxO62suWSkW4rUcwDdlO9OA5BnHw7H2EH7bxER4dbcFvm4yZqwUbcAWjM7HF5FUhGmYJN52vKMWz+TTaMTNg0uJBNsswJLCLX+2dxb7lA6fl0+7XCuHbbu6MKi6/f5dpsNXH/WuWCC7UjiA1FHq+0pfd+zr+mxoDDj9XiP/ql8dtIMkHo7UGoT0XYhyZORHD6VW6hoRp+xTC9TlCd71sP/PuTcvbdc3h36ucmVcSWHCBcGM61tjwW2ipcT35HwAqzSvNVT3s1vg5G4/itiArTkPG08H7CfTfplNDrC2vaEFbCYmTcFoTLnL1VNO5iU6Zh9ClfW6N0DFeCJufwW3ctb8MmsVMZSc8SSWsJ3v7XDJLgvavFXX62UBClRSxJ2QGTuzIt
 dQza4beM
 Sm+e73IHnN7DRj77MopuYRrGZ5cZq3EPG9k7l5bAfzmOQj1mzJ7MNvlbPTEmjHc2jgQCrAgTATLKfvGsGgytZj+/QzhjL2bXUNFhcDlAUyaEZKzPRzM4g15AuyhM5i/tItehqbdaJUZwS8Q8RTpOo+hOa74o51Gcp5uzNDD6lK1M6GIkWUzy2BVn1vrxhT59RDZCsCMFOK7Oe9VNykJiOY25NGs5DlEDToj9i2ld0IWebxWNuJ8cp8kKQ3ebJDRdpPU+fz+62Om4zfWdBcnWCxI1NH33Yhm0Dt8gD9F/fV0MhARkTx1P1b4hlkxRwtm2pdE8Em0aLpW68kdFl3PgUknDuXHG5cWGGowfPeEzqwggWfDErcEBX7XY14OalUbYHPl8SMLzkzQOK3A436wPeK2SSt8+qkVqTfDiDDfxYI8l0PIH4Toy1J1GgZuGacCVExC0u1qqCFqEeoYdJ7PP+zQaA1s3hkXwnkVMZkPSpRFpFFh7PhshbhUWYhZE7bRgr8dgYabgAeZS2eKHKF1tCs3C6jTy+Lxv5nqa9ylMt8e6JyutvVdSshBK6YYSlYrbtscRM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 5, 2026 at 2:19=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 9/22/26 15:38, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> >>
> >> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org> =
wrote:
> >>> No that time slot is too late for Asia developers. I don't think we
> >>> should use that time slot for swap alignment.
> >>>
> >>> We should find a time slot more friendly to Asia.
> >>
> >> Any time slot would have that kind of problem. We're spread out across
> >> the globe.
> >>
> >> Let's just use a standardized time slot we have for MM alignment sessi=
ons.
> >
> > There are more swap maintainers in Asia than in the US + Europe, at
> > least based on the maintainer file. Please be more inclusive. If the
> > alignment is done without key stakeholders, it miss the point.
> >
> > Sigh, we can't even align on a time slot.
> >
> > In that case, let's keep discussing on the mailing list. At least it
> > is accessible to every one.
>
> Looking at the mailing list, that approach doesn't seem to work.
>
> Finding a time slot that makes US, Europe and Asia happy is ... tricky.
>
> 1 AM is certainly unpleasant.
>
> US vs. Asia is also tricky, but doable.
>
> China 8AM vs. US West Coast 5PM?
>
> China 9AM vs. US West Coast 6PM?
>
> (Europe is 2AM vs. 3AM, who besides me from Europe would join?)

Thanks for suggesting the time slots, and for offering to stay up for it :)

Either one is good for me. But there are folks in east coast who might
wanna join (Johannes).

Johannes, do you have a preference? How about the first one?

And would next week work for everyone? Say on Wednesday?

