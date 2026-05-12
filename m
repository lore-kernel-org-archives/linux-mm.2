Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 809E9CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7E86B0088; Tue, 12 May 2026 01:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F636B008A; Tue, 12 May 2026 01:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5D76B008C; Tue, 12 May 2026 01:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C776E6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:11:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7437B8C886
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:11:02 +0000 (UTC)
X-FDA: 84757593564.06.B43AC8F
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 73A8380002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:11:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VAZhS3hv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778562660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmFCwYFPN9JhQ7rUtUManCwqQCQkhjY68tukGiC0U4I=;
	b=qluKBY/homNhAXnRhO/4oXrdW7WYHvUa/rEBhpB2lA9EzG6R5JolMMHhQRzSXHAbQ+AJb5
	OPDtcv61bOHa70zX4jFs3F8g3z9sAqcTzqazlXkAF5tTrkXLxBUd13+IIh6EcrLYcCuoue
	7N8NmvpSeCaKgOfi9tIoytyqwqVlwQ0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778562660; a=rsa-sha256;
	cv=pass;
	b=OZ6IMz3tYXzSUVHvboBgrdvv5KpaqjlNaEzpmao+8s5vdWGpAPVdK1HMVS3FXXO97MeUGN
	Jys+mS+O/Ovkw4rC3uhehzQKDu/V0zfjV5Q+vHFIp49tASmaSszHEAdnsyJTwUhWgu0GrN
	vv42BypXTp2+zwKAIixapHGPx5qlluI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VAZhS3hv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bd2087858c4so15906266b.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 22:11:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778562659; cv=none;
        d=google.com; s=arc-20240605;
        b=cCz48Tu0Ns+896OX0/+AppjWgojNu0gOf7+QbrZmLFq+yF9OuHoKLKtt1T3R7KBdKi
         ibgbpfF1B5Y7ydg+Oc8ifLaMrcjOf97RqG4ImiBLrErYHQVGzUcA3g7pMUIow189oEmS
         QMaB/qQdQ5FzJ/WfgDqpq4Qr1HClO8H5/M03yhh75btTNg8lHgUna/3GHeWYjqHO3LFh
         qBrlseqI8r7SE+jLgDz/DK8rTR8qc/NbkNlkvya/F1/pICCsYAVzc8AmtOAc01eVp67c
         vn0DbrCxJpqIdY5e1eNaqnUQVHbhb64PHRiP1YuhKj+vkorlruBTRPH52eruhiinu11K
         Uo5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BmFCwYFPN9JhQ7rUtUManCwqQCQkhjY68tukGiC0U4I=;
        fh=1yi4p5cVlLUwp2lusJlRVSVg/aPTM/G2rW0g1Eu79PU=;
        b=kATcBcY9lKvpMpOY2d6/IE+EX6K5xgy5BUXvRU0yIP8r4anE2ogG/9+6TZduYc2h0y
         YOHoYyvJKU2b8tm16TnahTrWhEfa1pd0E424DT8bBZi3wPAM8UeQGa2koJphuTfPQ+Od
         AcpfdTwebiFKZ1u2ZjtSQ/r/ymRu/oh4RiXkxkBxMEV83xO/mTIeoMiinpwQcvYwxOnx
         SRa0C6p591uzqlNzSWUDx8moLNiJbTZ6l+fE6K1wPedDUPqP91SEdzmwyi2dtlS/lSZA
         WQkusEaWZe/KlLMkDR6zz9Wsl9VLczHjyI76AKYwo4uNIp73zNF9SxL8ONwNgrJP4wuY
         Fymg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778562659; x=1779167459; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmFCwYFPN9JhQ7rUtUManCwqQCQkhjY68tukGiC0U4I=;
        b=VAZhS3hvRPemh2Stz/A0I07tImdA3v6VEPXRZxTFVoa2f64J/ANES21B+PNvoL6unw
         a56Xnp5eVc68hCN1M2q+GP9mqalIx2b6oi52VZBSvBRjg7djZ8TQ/39j6iDgKzUnGDBx
         4heb7+LyC3U9GW8NwzXHC+bg3lvdiqDtMO0GG08DKhjk3U407KfoE1xkI2JCr98bN7z4
         tcZL+/PdsTkpjEaaRii8VA2BHSrnkIvpwisLf0vLUNzRgeXAx4rAFb8PSMhGAi8HM54l
         GuTfJm1FBdCXpAeWuB3ulvffwGIcByDLof3pMGfVjDihG0ocX+7YFGp6Mea7kbSk690t
         Cwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778562659; x=1779167459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BmFCwYFPN9JhQ7rUtUManCwqQCQkhjY68tukGiC0U4I=;
        b=g4/7CIsXH2pMiv5t+qgsTuQzS8a3jlCmWmF/HUc/vHM+QzoLlSmRHKU5LjB/tGFfXz
         MvzEHQNvvm/8CtwE73+wO/DFLahRKuZUlzVwFs1viUpe6UwD+HnJV55XrClLUnqtt7Ba
         7RhDvESyJnVJuFlzJGk8KAfSP+LYNqn9+UtiJ2hXsDCRu1jHDhGTgc7U/FSc5LcolChg
         XbTxMnrxdbveLSO1fufQla2OyaWaHTClVmLd6fsEybb19nC5ovCxFYC4IrBx1WSB4E3k
         m4c91WknGEijIiCGOm9mE+For3/NJyKJt9wpifmqTY5vOXNb1v87aGVf7OtSE6198r6Q
         JQXA==
X-Gm-Message-State: AOJu0YwVknnthCIHY+TE9bkK3AJ8ApJaB8FNkehO20GSllgB3zJiyMVA
	BXGgWEr07HGmnkDHwI0doHbUwEodfgGC5oZW6AQDuJ4hGhDfvbqKGSUzpWe0Qtj7IGNcYkqV9Nm
	s+WQYv90eSCmf0i6zvvFeAWawtupnXMU=
X-Gm-Gg: Acq92OFwvbYZq2JRMygfs5hz64NFujYfjlOL4/VQFiJl6pCULYuC9fu5Eu98ObOfclU
	GMuINwQI1zdhZobU76CUvVyFjCLk56KCgAoJVSwAdlvpP7+nYQ7N384WujPNrQaaKvzC60hYIXM
	YaB/loqzqjNcEqh1KLisfauVeahnngt+2OHgulDkW8RX45izMum8dXV8Q4Q+r/5/O5PzxmHwf2M
	FbsYogfjaH1uZpoyFGkFplV1YvWjTQtrrt3rgYuz7J3kO6BbCBe8FJ4BfQ574p0BlpqHtxi0Ndf
	OcwW395ygAhBH+yHYyd/J4bwUp7Nj5kh94E3ys7o
X-Received: by 2002:a17:907:9807:b0:ba7:cc67:488b with SMTP id
 a640c23a62f3a-bcaa9f61221mr914386766b.5.1778562658599; Mon, 11 May 2026
 22:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <CAMgjq7CJ8Are6m7X2UxUoJ=77c_oSpdG8-bzkmdRzwey2Cp1gQ@mail.gmail.com> <20260511141249.eac1426fee41c9fe463e7e23@linux-foundation.org>
In-Reply-To: <20260511141249.eac1426fee41c9fe463e7e23@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 12 May 2026 13:10:21 +0800
X-Gm-Features: AVHnY4Jyp38llNFierobB5C1VqdlwwSStVA5fOkuUPx0Tui9Rb1Ly3EEa2iHocM
Message-ID: <CAMgjq7DY5G_ZGYbDqnaqo3Uhr=FKi7OktzhmpzrWN+29=Q44+A@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm, swap: swap table phase IV: unify allocation
 and reduce static metadata
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 73A8380002
X-Stat-Signature: w6ykgk1a4cftaoft19cz15uydcpm8ctq
X-Rspam-User: 
X-HE-Tag: 1778562660-991912
X-HE-Meta: U2FsdGVkX19vFiI7HMvXnGseiDf1iWKcehxPTpsO25rlutj3zDjJn5BRNqmGFr6pDkj89BAgHjWR2bTdyuiGt6Q/9Sf4TZdbY4gMQo35tmnQzetmPxMH5AO2vcSSWUj+wFRYTTNbprMV8tnK1PRzm2lrvPB/HV3qg/wKdjDPXRpZfX2lzNmQvnKkjy6TUzSK3VbG5KDXaSzr2VLMoup41NeVmaE9wKN9HiJMSIi9bKy+H35WX+wDoWiX2hNBU6CwwrGzi/j00rqJBx7aKdBh8+HiDCpFZeAg/qyAvGZAfjS7M2wyM1zsps1zQAgpMzJhT+NmWu5QCpmK4H4xzllkGmblTcF9kekwnlg2VOR/L7Ibggip4KhnPwiXrEpjF0qp1ACUkpNCuy/xzf1PVtyGbZlrsokUULQh8WzZMqjywJxJxTmdgGIQy+npjBqAs4wAj4U+s4LrRo81iq4Rycky0NaMl+RmrCwZDxYVILv04+gKeuTOuq/lVQAd644bfLrt8squaimuQkuRNU+P+JACjb7FdFQOReEo780TdCNygiWavq8j7WhyjNZi0H4JGvQXToA3T35Eg7B2ShJuj5tzp9j9nFIVVjwSF+VkpHhFsAqPG/AkUewnsvHsXLVVbq2+Ah9p2dAs4iqQq0XiUHDCGFeAavPqZajT/3qR0ANlKx0nt22EWqmnsIK1z+veHnlUKAUhhQ+OLCr1nKj9hTPCMFU5yHeFEcT+GQwA9GiIJHp5Z71yIzDVb+T/b9L8pyXlvfHY9Rdef0k15OKKf+ub9dowVXH7eUFHtwXfmPNqm/nSd7InSJPkynMgOf4nXVjmjxxkCT7ibhbix6awaxshElB+25rWy8OV80uZjDdbA7wycotfeC91fTbwUAp19VbbPNuhleAjEG/RIv/jpuYDZcQ+y94f9m8CZRIQDhRn7BfjWA92CsCWC48OzhU2YXYhROJxijYoOaXYQEGMFB6
 z7D3yqEE
 3bj5afYwgxcZ+tRl+j62B5ufq6MeSE/DsFGutHXw6H54MDN8i/jVPAWInikjlwszhJnLb76aJwdnPx0wR4SZIeoEm4TilJ6DFMwYhEsZ+eM4yhAAf0Igyor3DJTjGIVknKtozFUdF4NiQE3kZQoW1CncEfjSA6KZfgQ1pNszhxJHqMrcwzCa8LBv9zrvNeiIA8uJ693qOBUUYRBFqTOjqGrOESm+0+Ljdy/x0dQMuhKBJCgEOI+r76dG7fJ+MDxfoOvHvdHiYSYw9WG5bZVdWsLZfslDhXV3Dkxx3k2myNX4ZsdwmC+AJDMKHQaDmlTnCIztwPla2yDHJZ8kEzMb1jvCmpV2KW9ZcKq2Fnq4i9b76TV6zGEswwrX0vr8NILywW9+cBiVfUeARjP3M79aP6+V3wisZJ17cKr0QuLU2I5NvqbK8K+YdGtni8i5eIDmXqmojJ3vTf8iG9u2OlDUKLQVj63KGPERVrZcOE9+Lh5wFf3S8kmu6RKcilNP9mSjJNBQEbg9aikrN+x+/OuONFQpRAnUMbzS974o9ean07Q2Ftk/6JS5e02tpvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 5:12=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 25 Apr 2026 02:11:47 +0800 Kairui Song <ryncsn@gmail.com> wrote:
> > I checked sashiko's review, it seems sashiko itself is bugged or
> > something wrong, Most patched end up with:
> > Tool error: Review tool timed out (active time exceeded)
> >
> > The rest of the results are all false positives, maybe I can add a few
> > more comments in the code or commit so it can understand the code
> > better.
> >
> > And checking V2's review:
> > https://sashiko.dev/#/patchset/20260417-swap-table-p4-v2-0-17f5d1015428=
%40tencent.com
> >
> > Which are mostly false positives and I've fixed the two real but
> > trivial issues already. Things should be fine.
>
> Sashiko review of v3:
>
>         https://sashiko.dev/#/patchset/20260421-swap-table-p4-v3-0-2f2375=
9a76bc@tencent.com
>
> appears to be complete, so perhaps it went back and figured it out.
>
> It claims to have several "critical" and "high" things, so please
> recheck?

Right, thanks for the head up! Just checked again, still, all reports
are false positives.

Some part may worth adding a WARN_ON or some comment (one was also
suggested by Chris), so both humans and AI will be less confused.

For example sashiko is very concerned about round_down of swp_entry_t,
or alignment of folio's swap entry, which is already a common pattern
now and completely fine. We did plan to use a wrapper for that later
to make it less confusing, not really a problem.

Maybe better also add a bit more info to the commit message.

> From your replies in this thread, I believe that we'll be seeing a v4
> series?

Sure, I'll send a v4, most changes are for cleanup and minor improvements.

