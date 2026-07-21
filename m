Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D613C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9406B008C; Tue, 21 Jul 2026 09:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB9F6B0092; Tue, 21 Jul 2026 09:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B496B0093; Tue, 21 Jul 2026 09:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDAF86B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:51:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1C60A0175
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:51:18 +0000 (UTC)
X-FDA: 85012920636.11.514F9C9
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6BC1914000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:51:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=G+WERwPL;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of "prvs=5662d1cd31=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=5662d1cd31=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784641876;
	b=z1e6hsEQ2VAuS3eBCzZ5p9CXWk6JZBSvaPU7pD0u1kurecZOVTe3vcGdCnIjLXYNMskugT
	zEecnqFolAFutx96NZhejpW7R9XByyed3eJG+ZA6rwioosvWmsDvZWzy9UDDkNTba3qUUs
	U1Xq4+82IXHnKx0nlnfquz0o557hMCE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=G+WERwPL;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of "prvs=5662d1cd31=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=5662d1cd31=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784641876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgKqNwI9zHLhK4AxI/VtHp9PGEUWLwuB1Rwu5NNgDlg=;
	b=wzNa0pS46fDAhYMtuzybkzAgXuiP44Lb4t4mMQP9kOUyteAF8jOUuXNUwDao66CPrhktf5
	FNvfHZtxkfPRs4Nz7z8MouWl2gre2Dq8PJZnV4dU+54Tr8dgkzlE9q0iOVlVniCLUZfg+X
	bzIttH+qBHdBKJyGEHzen/8UeBH/txc=
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LDmH6j930246
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:51:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=hgKqNwI9zHLhK4AxI/VtHp9PGEUWLwuB1Rwu5NNgDlg=; b=G+WERwPLhiAe
	69s2vKEtmDv2qYfUCZ738zaPksZOw9QVXm7WvP2zwWMbSlLKR55jXkq1kz5tyvNl
	p319Jl/M+GPvDossNQVvKjWv4mTtIKG1dxu7NdVSVUmBZL6QsT8n5xM/n1jA2979
	LMdVmqrcOS20sRkHx19rcPPV0eMb9YZdRolUH1uV2hX5evGcPQRVmQc/JhQWmxcC
	wp5C6MSHqEqXbdbGGOQE5EnhOz96eLg3w9c+zPGG+buoV79d11Nr6XnKASF6ltkb
	NI0wliMXHrYcYV+VgfLUiJUWHVALCoEQoV54iSHlK1C0a7OZWwYKOIXpepKQncYL
	QltCu+Kd1w==
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fgu84wept-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:51:15 -0700 (PDT)
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-69c0f3a15dcso6748284a12.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:51:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784641873; cv=none;
        d=google.com; s=arc-20260327;
        b=L348c44F+cZCkdduz2Kl2nOCQOmS79fwfag2n/y9nvGD7FqtFNL4hzDLhjzmVzRUZK
         N286+sBcFoylAWt8NElEoIz4d9eJFkgI6Mq/UZ9YvwCuGWKdjeFmwezgtImpZdpE3RHD
         sXDvtmSdIol01OOhetPfyIXaqV9WwMfVbICYQZfbiPGCbN4aH/vn9O+uvSF49WriL9g1
         u+LZpazgKyz9qIKn99xPi8eRYb642Z08x5UG4ZMl+V6lyOq7WJzzE0uaGRtDeKvVkWbx
         fd0R9MTOhTHJRuFgk05GV49d5a1S6++xO4thOIwc9Jrqv1Yy6yABC/YVUCY3v0W8J7fD
         PdjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=kgCqHqk6t/4b7ihE9C0Q1R3dMzn+0bCpulqcGqITNJE=;
        fh=7JajkvmeLzJ1j8bNr4wQCauNb6mFrfJmJ4K9Bi7hJpE=;
        b=BzRgSG7NBSQENIIs2Hmv8hulrQlRl1PVO3A1k3lakOV2rp3n4/WJazOk6cyfUemB/K
         zVHpeaXKQKNJxbrVSemJPN0MDXeugqqOqmF9d5H1GRy+nUm7m8vfCRrsoFmYo1Tmrg6p
         /iMdNof3yeGdfqYE9VKMrSkxhA523AU59zl+fqHPoWW17i2ZUr1eOFJZuX6uxgUVTdw/
         RJpOulH23aLtzjzn0sVznB5ebVZCoqWp8k+Qi4rBhPlURYN/92aunxAplcJ4NT18M6aV
         KQwm2bkNG9n11ITnDMgtjfcfqUvsUF6u7VFVcprup+JtK4c7FwaB4nc8ITQjCrj6QvBS
         avDw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784641873; x=1785246673;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kgCqHqk6t/4b7ihE9C0Q1R3dMzn+0bCpulqcGqITNJE=;
        b=dsP9G9h7Qq5tblJAe6Wi0iTAXiD8/BSW4x996dXty3PbHd8SUFIHbK5v4OMhKFXdag
         gAf/tNrW4hnRgKUCZ/yDzzv081EnUPnDfs2Fnr+zl9AJovtknpMJRYw1StH9Sd6QULn3
         Rwa3palJSMwcGL02OH226p1STWNsnOAahNfbp/YkQsTaL86EVEwPuZyFBygxHu9SBxSL
         QzPhW4Q1Ahw//Ppz8HT0HzqI4na+9U98eHVxHfjMllURxQOMqYCg7RzCy/N35T+LnbPg
         eljxk6Dar3UgqzgcmdLPTwZMfsjUP19TpmMRW2WW6xqtmwlFADKuLs4dywcibSp262s5
         qiPw==
X-Forwarded-Encrypted: i=1; AHgh+Rqb4MARLD0pXLR03wYNnMBsR7mm/QnJy4XK6TxXt5g/+1q/CoCz8vMkvAlmEx6kGhaNY9G4iJgdwA==@kvack.org
X-Gm-Message-State: AOJu0Yw7cEHcYUB9I1qRGJKYvgPFTNl0MIofgjVssIXu9naSb+4LnjKI
	HJlYj2KvBY5MSPtZCsi88rlU6/GoWdE3JnhGBzhenATOjclnVPmp+50KsQtZjpy1DHNre128zI6
	+PoX33GRzQBQliwPwj7Qm8kX7HLeHFPfJyLF61Usg9ZElRdMila8xzZS8C19moVTpqYQ0HoJ6UW
	nS0hpWSzMd1Virg7e24bd4gykTWA==
X-Gm-Gg: AR+sD12EqkWD7YRueQKSOxUMl0BaWkgrKbRajT9H8nrBtcFF1R23fdv/ScESGarZk7r
	sIboQidZRYxL7JuTBXTHyQ5wu2/BMVmz9UFR+L8dzdELoYkZb5Sj9Ion4DUSYIy0y/mv5GSLxvK
	cHyzNmpABZH81NCqaRq5H9/Mdp34gkOSrLEpPNXcUxeUiR5twtXX8z+c1Q7KOGm5YB9lPAIo6y
X-Received: by 2002:a05:6402:40c7:b0:697:eb97:a4ed with SMTP id 4fb4d7f45d1cf-69e64dd54d5mr7267912a12.7.1784641873405;
        Tue, 21 Jul 2026 06:51:13 -0700 (PDT)
X-Received: by 2002:a05:6402:40c7:b0:697:eb97:a4ed with SMTP id
 4fb4d7f45d1cf-69e64dd54d5mr7267883a12.7.1784641872842; Tue, 21 Jul 2026
 06:51:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr> <20260718093723.153324-2-alex@ghiti.fr>
 <CAKEwX=Nn0dMc1K9drXFVMwt7wMZ2P6KToeh7T3rE1+Xq5yrCFw@mail.gmail.com>
In-Reply-To: <CAKEwX=Nn0dMc1K9drXFVMwt7wMZ2P6KToeh7T3rE1+Xq5yrCFw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 21 Jul 2026 15:51:01 +0200
X-Gm-Features: AUfX_mxqg_lic_i-cnpMMasc3XbCKh4ZvMOp6vx1fefhyR4VNBj1s0GHL0sNvB8
Message-ID: <CAEmasaWnp_pHEo2m=5GEo4r3YYWoRC20FNfWN=TtrPT070WUzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios directly
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE0NSBTYWx0ZWRfX/ivhbqd8xILz
 Y+H1GdnEu/RlQNA9UQ6sMZ8GDBbnEucjkYnsj7CYKYJsxFXLpb3oXkGGe0zTsC20vEiyS38OTxZ
 fYagnBZk2Xtgchh6jeC8hTh8fPMnDl4=
X-Authority-Analysis: v=2.4 cv=ApXeGu9P c=1 sm=1 tr=0 ts=6a5f7953 cx=c_pps
 a=Tczdrg5if7+wQeIJmxD/XA==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22
 a=pGLkceISAAAA:8 a=GXzu1mSckkvTQhgV4B4A:9 a=QEXdDO2ut3YA:10
 a=1oAhN8tkTtOBK6_UvoHx:22
X-Proofpoint-ORIG-GUID: -YQNMaYE7CN6V0cbmEmr0X80XoWo8D_j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE0NSBTYWx0ZWRfX7mvlZLjvctUt
 hE0X7FJ1L2quhTyk4pL8IyF79k7BwfA1jfAQqv6NbNWe049Nww6DASp0xSyRhWWa5Y4hQKTZ3mf
 voqBo41KPckW+441yW0wBP1u1UFaC8Ep+CSCncj+uXUuuDLeklUSs0vPdi9VcMG02o5TlHgu8pq
 8DUCpA3Z/pwUisQcGK3T9QjT3TsxkPp+xocqCisOiwPTJLq7s/7hn4xaP6P/OVZmx+PQpmQ4e97
 z2TISevNn2xiy6Aj/CnV5/1Y7OJvUj14HIOvE7lt7H4Nwe1818KWDuAe0Jja6QXHqxvxThE7VKO
 xruZ9Ib7cOv2n9BGgB3wsW4V0ku7ohze6rlRCaZjRHpK6NmTul0NSAdx1co5T3SCSxnYjZJnWT+
 rzgq/BXyKCKr4OW93IFLrE2YWcK+QR4pO6HJf/mHAOQwekQl+snj6+wZr+/vK4TnkaGjMkO/PLY
 cDZK2BNM6DgGm7ynytQ==
X-Proofpoint-GUID: -YQNMaYE7CN6V0cbmEmr0X80XoWo8D_j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-20_03,2025-10-01_01
X-Stat-Signature: 1n9gw738g3e534tyqo5zxi6xsr6k9gh6
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6BC1914000C
X-Rspam-User: 
X-HE-Tag: 1784641876-436251
X-HE-Meta: U2FsdGVkX19d7tblhZ3IdxO+N/yXY7XhKVKkz9LdI80+LAsOrHeym9ORIY6FG5s9ktSnDLM0GGFaXqh1uFUhlok57m2VgRin+Y6hu4ag3iLz7RkMg2MB2j8GqnFsDPj/n49c8f1D0Z/hDOzdfOEKmyyqsVjHBcyZOvPuK7T45Ig0TfZerX8njoB/hjfAMXxMidQh8oUfWm+O6bJubt7zAcY/Yhwu7dDI1pB+QG4mgLYNr9cQ1YlsMKNmNwqdh7NnB62bN9gJIzLSbhu0FqbfDfg9Mgw76blu1ab/2gOgVO2gRrsgBi90iYELFjCSOVBYlT3fSjplk4j61PJ8f2WXC6janooJd7nEVGeMRY8kkc5I0usdB7BcCnn3v6BYUbJbS1JsD3ekuLjiE7jRoxCX6jK8Xrk+MAhaAYJi8meuTqqbdJb5ZsyntzZyYLUCF1KxYRVR4SuIcEmGkI5S9TtUuGXOQFqCrdfO5cZBxw1kM9Ew6yGAiDsuhAUf8wdUWVNKQITiyk2dpTd4LlImcqkIFa5OzcIVHpwOnbaWY1Niv5sp8Uqxb0NSsYgP8xLvG1FhJ/RHOkCx146wXEibBmHuGamGsuBF0UHpAQaxqgJJBy0KL3+gUpNyrJoMKmSpzg5gou8k+W6F33X2lxU5mwHBqvYy7LMWkpZ2gCizJ6v0E0sy5OM9VQ5qhDmaQ272ws2a6z7O6jL0qeyN+Xp+ttyQSNo5rhmXKxDHGrbwg1FqU68ifI3hVV82ORGCwhJb/YXDfa+zEOa27fehSfPlx8S8Lb/0scwikkQtLmkShITJG9ylBJKF+QWlzVMp7J1IWzPMxOqaiIbH3b9kH1/t8Z9MvYFn950rOCX4c0azp2qHbHABseQ3YJ0ccl1YGYuExmpuaRidWGBkv9R0tOiFMrWbbcxh8Afpjzl1jzZLCW1ElPea+sC1umAn40ldZLYYWnK663V0Yj60Z3x+bM6d+hF
 WBirOnM5
 mW0HkDTo7b8Zl7ulzr02YYYAKBRdUh3zUmYi9cq/JXKzXMbsa9x6SHenAMIgrvkrAOulxOuyk4vx+3PSfudo6vdzHCDOEnlMnFXeSF7ZaGQorQ813YWMFehnfjXcVnAyTJwS5TserjDoKxsIN2rK9AMY2tcq30CtwXnfKKOWVe+DXjgo6t4XusF1NBvXCvJmkP82lk4bguKhyhaZagBHYv1j788fg/Jf/xgeOwaiWjc7YMB3gudDtIbCcmzULPJNZ4fCqHuVsASVnP1kq//gBznFJxIgznvlW4uaNM+LFLWHVzBo1vhMOltq1eeCfzqBEtPHIT3u75wHbRk7hKcBGGaQU/ofuOxh8H3wRu8AP5y43EzCgUWDD9KmNu0DxOKuuXiQJj8RtjKUi+55BY1/HEhu5Hq4edx2wWLw6H5aI5BlFgF4IzCVjeVuSQyCryg3Nx4wnWO/qCPdjW98SPuofZ4W9fP41eSJdhtfkZUUCuNcKA2wNqjsDAvsWSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

On Mon, Jul 20, 2026 at 5:56=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> >
> On Sat, Jul 18, 2026 at 2:38=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > When zswap writes an entry back, it allocates a swap cache folio,
> > decompresses the entry into it and writes it out. That folio is cold by
> > construction, but it is currently left on the LRU for page reclaim to f=
ind
> > and free later. This wastes a reclaim scan and keeps cold memory reside=
nt
> > longer than necessary.
> >
> > For synchronous-IO swap devices writeback completes in the calling cont=
ext,
> > so the folio can be freed right after the write rather than left behind=
; do
> > that. Because it is freed directly rather than through reclaim, it is
> > allocated off the LRU: dropping the last reference on a folio still on =
the
> > LRU would trip the free-time page-flag checks. A folio that a concurrent
> > swapin has meanwhile claimed is left in place and reclaimed as usual.
> >
> > Asynchronous and filesystem-backed swap complete writeback in interrupt
> > context, where the folio cannot be freed; they are handled in a later
> > change.
> >
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> >  mm/swap.h       |  3 ++-
> >  mm/swap_state.c | 17 +++++++++++------
> >  mm/zswap.c      | 36 ++++++++++++++++++++++++++++++++++--
> >  3 files changed, 47 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 77d2d14eda42..c617e5a0257f 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -306,7 +306,8 @@ void *swap_cache_get_shadow(swp_entry_t entry);
> >  void swap_cache_del_folio(struct folio *folio);
> >  struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t g=
fp_mask,
> >                                      unsigned long orders, struct vm_fa=
ult *vmf,
> > -                                    struct mempolicy *mpol, pgoff_t il=
x);
> > +                                    struct mempolicy *mpol, pgoff_t il=
x,
> > +                                    bool skip_lru);
> >  /* Below helpers require the caller to lock and pass in the swap clust=
er. */
> >  void __swap_cache_add_folio(struct swap_cluster_info *ci,
> >                             struct folio *folio, swp_entry_t entry);
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 9c3a5cf99778..048efc7ca612 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -403,7 +403,8 @@ void __swap_cache_replace_folio(struct swap_cluster=
_info *ci,
> >  static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
> >                                         swp_entry_t targ_entry, gfp_t g=
fp,
> >                                         unsigned int order, struct vm_f=
ault *vmf,
> > -                                       struct mempolicy *mpol, pgoff_t=
 ilx)
> > +                                       struct mempolicy *mpol, pgoff_t=
 ilx,
> > +                                       bool skip_lru)
> >  {
> >         int err;
> >         swp_entry_t entry;
> > @@ -484,7 +485,8 @@ static struct folio *__swap_cache_alloc(struct swap=
_cluster_info *ci,
> >         lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> >
> >         /* Caller will initiate read into locked new_folio */
> > -       folio_add_lru(folio);
> > +       if (!skip_lru)
> > +               folio_add_lru(folio);
> >         return folio;
> >  }
> >
> > @@ -507,7 +509,8 @@ static struct folio *__swap_cache_alloc(struct swap=
_cluster_info *ci,
> >   */
> >  struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
> >                                      unsigned long orders, struct vm_fa=
ult *vmf,
> > -                                    struct mempolicy *mpol, pgoff_t il=
x)
> > +                                    struct mempolicy *mpol, pgoff_t il=
x,
> > +                                    bool skip_lru)
> >  {
> >         int order, err;
> >         struct folio *ret;
> > @@ -522,7 +525,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t ta=
rg_entry, gfp_t gfp,
> >
> >         do {
> >                 ret =3D __swap_cache_alloc(ci, targ_entry, gfp, order,
> > -                                        vmf, mpol, ilx);
> > +                                        vmf, mpol, ilx, skip_lru);
> >                 if (!IS_ERR(ret))
> >                         break;
> >                 err =3D PTR_ERR(ret);
> > @@ -643,7 +646,8 @@ static struct folio *swap_cache_read_folio(swp_entr=
y_t entry, gfp_t gfp,
> >                 folio =3D swap_cache_get_folio(entry);
> >                 if (folio)
> >                         return folio;
> > -               folio =3D swap_cache_alloc_folio(entry, gfp, BIT(0), NU=
LL, mpol, ilx);
> > +               folio =3D swap_cache_alloc_folio(entry, gfp, BIT(0), NU=
LL, mpol, ilx,
> > +                                              false);
> >         } while (PTR_ERR(folio) =3D=3D -EEXIST);
> >
> >         if (IS_ERR_OR_NULL(folio))
> > @@ -683,7 +687,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t =
gfp, unsigned long orders,
> >                 folio =3D swap_cache_get_folio(entry);
> >                 if (folio)
> >                         return folio;
> > -               folio =3D swap_cache_alloc_folio(entry, gfp, orders, vm=
f, mpol, ilx);
> > +               folio =3D swap_cache_alloc_folio(entry, gfp, orders, vm=
f, mpol, ilx,
> > +                                              false);
> >         } while (PTR_ERR(folio) =3D=3D -EEXIST);
> >
> >         if (IS_ERR(folio))
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 761cd699e0a3..3c494c5a671c 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -972,6 +972,30 @@ static bool zswap_decompress(struct zswap_entry *e=
ntry, struct folio *folio)
> >  /*********************************
> >  * writeback code
> >  **********************************/
> > +static void zswap_writeback_free_folio(struct folio *folio)
> > +{
> > +       folio_lock(folio);
> > +
> > +       /* The folio was allocated off the LRU and nothing re-adds it h=
ere. */
> > +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> > +
> > +       /*
> > +        * Gate remove_mapping() on folio_test_swapcache(): a racing sw=
apin may
> > +        * have freed the swap slot (folio_free_swap()) and dropped the=
 folio from
> > +        * the cache, and remove_mapping() must not run on a non-swapca=
che folio
> > +        * (it would trip __remove_mapping()'s mapping =3D=3D folio_map=
ping() check).
> > +        */
> > +       if (folio_test_swapcache(folio) &&
> > +           remove_mapping(swap_address_space(folio->swap), folio))
>
> Hmm I think you also have to test for writeback and dirty here right?
>
> After a racing swapin freed the swap slot, the folio might be dirtied
> and swapped out again. We probably shouldn't try to remove_mapping()
> such a folio?
>
> We also do similar check for zswap/sync-io devices in pageout handling
> (mm/vmscan.c, shrink_folio_list()), and the other dropbehind handler
> (filemap_end_dropbehind()).

Actually it took me some time to eliminate the writeback check, I
think it is not necessary.

First, we only call remove_mapping() at the end of writeback (easy scenario=
).

Then comes your scenario, the hard one. But it cannot happen because
dropbehind folios are allocated off lru. Which means that a racing
swapin can re-dirty the folio (that will get caught by remove_mapping
itself) but it cannot be swapped out (ie under writeback) because it
is off lru and then cannot be reclaimed.

But writing that, I realize I may have missed other "swap triggers"
(MADV_PAGEOUT for example). Perhaps adding the check is safer (and
cheap anyway), what do you think?

>
> When I was playing with this, I also tested the folio with
> folio_test_active() and folio_mapped(), but I must admit - I do not
> remember why I did it. Could just be me making sure we dont get rid of
> frequently used folio rather than for strict correctness. :)
>

folio_mapped() is not necessary because remove_mapping() checks the
refcount. folio_test_active() is always false in my case since
allocated off-lru.

So unless someone confirms what I said above for writeback, I'll check
for it, it's cheap anyway.

Thanks,

Alex

