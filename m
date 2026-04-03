Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06655D730B7
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 07:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D7A6B0005; Fri,  3 Apr 2026 03:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3352D6B0089; Fri,  3 Apr 2026 03:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B036B008A; Fri,  3 Apr 2026 03:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8C56B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:50:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EE951404FB
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:50:52 +0000 (UTC)
X-FDA: 84616473144.18.77A2802
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3BDE0180009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:50:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hQFXIiQS;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775202650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGNk4bDYC1wCO/6RaBZaw2UNtyNik6pnk0IPcENeIyw=;
	b=qhkKcJnxt/bsxjUYwXPsf16wYyDcdIpcpWp9m+lM8ZKFGwH/8Yp7nr9WTSEUKQhYXWL7DL
	68jDGDYT4xHpRgm8LKqJYTGxUjvFGPvvYoEmF5ISdtVPyVKoL8HjW3d/7HvBEvqgjnzMOh
	GvQB9mvFIL9FESojix0tBUvaqsa5eEA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775202650; a=rsa-sha256;
	cv=none;
	b=xGGh6YNfM4+KfxPCPL1ly27QManARwTkvRYFXgDbMfeM3znUPepdNKtHl5h44Wg3rXmm/n
	uiHo1RejJ3pb+Gts2iyd4/MCZPkk79PeDUzShHtL86siTwhQBS+I1759m/7M/m+YqyO3l7
	JYBKR6nUHM5yBUN9jCyr1CpsO0m8D1U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hQFXIiQS;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0D284437E
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCABBC2BCB1
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775202648;
	bh=j3xpS4Ssh2WK/+YGbvbewpflo5zi8qwo/O40OEA5xrg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hQFXIiQSrjNQgvzMsUI7V/iDLppGeaos/RzidiRnLm3HkGxUQuXzYism9vboh+MOU
	 QrUqktN6sDhoq5VIgBjPMM+BLjdZes7Iy7mb8MqTTBjZGptq8dYct9nisIu4x8EzNU
	 N54mTgyUszdYaURsCGIyA9ryhUP8YjkU8IIyQdQVA8YC+K+eY9S4tPmO4m7Y02gFMh
	 uwsH6ykUZUHSOIrOV8J8l4KAaSM9MgHmJQk8l0mr406Bmm1bEXr0kGJFvt3+JZ1zw/
	 q25vjQZNv9SCaC9RlY4BM7KecTbzA9yVKBWE6vR21p+/BAXxAEds1lM/a6H4+BVlTP
	 s4gFcP7EpbXAw==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a068db9989so26992426d6.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 00:50:48 -0700 (PDT)
X-Gm-Message-State: AOJu0YxjwugBkhxj9Z5hAXIroR8w2QLmyGyN4RCmpGUKZrslwouNCSi5
	jrNRngdkfv5iCdV76KC5OzCPSLNYsAMaiqWl6HgyXEHnERCRrz/eh49JEEpIeHCrwPe3UGenzKl
	EdVgNG+6Czdc+M+Z5g5ofUFhUEnTKUV0=
X-Received: by 2002:ad4:4ea1:0:b0:89c:6692:1d83 with SMTP id
 6a1803df08f44-8a7033657a0mr30043926d6.3.1775202647917; Fri, 03 Apr 2026
 00:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com> <20260403-mglru-reclaim-v3-6-a285efd6ff91@tencent.com>
In-Reply-To: <20260403-mglru-reclaim-v3-6-a285efd6ff91@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 3 Apr 2026 15:50:37 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z2=Wrm0NAfpE_98rKqEgncBceVscqFRGDPeuR0eCxQCA@mail.gmail.com>
X-Gm-Features: AQROBzAc891xIGlkBXUm0CKD8CgJdoALXMRKHxHiBPNM7YZLQ35BGrFB1mU9lXk
Message-ID: <CAGsJ_4z2=Wrm0NAfpE_98rKqEgncBceVscqFRGDPeuR0eCxQCA@mail.gmail.com>
Subject: Re: [PATCH v3 06/14] mm/mglru: use a smaller batch for reclaim
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 7ifkhu1ds953k1936ftmmozies1upnzs
X-Rspamd-Queue-Id: 3BDE0180009
X-Rspam-User: 
X-HE-Tag: 1775202650-902314
X-HE-Meta: U2FsdGVkX18VnoMN9jJhZkWH5nK8R14U3aZ+BtirscdFdcQ8NoqPl9RKYM9O9Pi8OGoYFsrdw/VASd4t2BWeD6e2Cq6Sj00LUql7Kre00Kws/ImhCWp6sGbA/gYHrkeqYfgrr4UhYIiG1yYvJgNub/VhR6OfxwDs68zMEHoTNixrB0s0JS0vv1JS2BVltW2/Y2E1oTdA++kcgJu73Y/qPL29K/sGX1TTU6w8v13dQep8agz1MDxpu0440kEZ33ixYtBoInqnTOC51vC5jZUrTxrj9WGnr6tbLON6yEAMYYdirTz8kZpNBDB1GSlVjxUzwTyXkxMin01lqTLuZelj7PLKc/QrzRYt615ZQmBuzzmIykgMIsD78pjfSqizkbAMe0XU31whmriZjXL8An4is6RP7fQ2OOp9fBvxyuTwDiIXU2nNGRsSPYQEfNplvXQZy+6jc955NiRQcFZN66i0gLfUzZByIUtIOXvJ6VeYlQyfOly9iWBUZA7LZnwPeLSUhcdlEOBBjtzUgTERMaQvjxCCOLCa+1YMxaU+j+IAidam7eXCm0L13gSUTnQR57kn398i0ABLF58I39C+qxnJeosvUqyOCxvQg2dJGbcc9+OuJEKKmFmBqGGW+i+uUs4X90W7B43+jDLGjilBf40e/kqfFKLBlCsYPkI26hu1Zlmsnh/gawks1cBdAt6h94I5DYRlVWA4W2KEivISwiaXTFM5zUXeMIsBmUwinGdKMvKQcqzHN+D5HGjQcv+iXvm/Gct6a/llrRnYMhEpt8H9T/PEsNUiXKlcLyyPHPSJOku+i07i87d2QI5b405p5hkP+Ri4XqqpNqCyZk4aHrmUQQdI/yzQv1/ytTMif0hlbHlmwwSAndwdEkPaRnSMQOaX4mS1QtMVLQy8vHB3NxeBUmKrDwMkMAzTd803t03fWzhzxp+d4uXniSK6oWvb44OwSECyxkOVSEija4hPE/6
 MrHP+GEj
 VEz7Mz0aR1TrT0aw7qFubCZInrxsBsgVsRljFhTrpalzm9vDEu0SQHm45rVLtMHCLOK4y0q48c8fqGbljTcKxD3/mKbdPbA3S+cQW3qNRNE0mWXoNrtFcvHNExrQ6Kp8akYmKvh8yrqPFF2QWqAr+vmpkK3jZWNDqMtf3CcLk7rVFGTpzWrDeP4SMmrJ1SGuLutRAUUbi5as5TbYPt6237FCVNG7ywc9cpM8sCQ4mabcrsopxDLrOCdsANd12WbW1nduOjXaxIQ8Ct0VIPXcluduk6mmG7CWtT8jPOCkublUSAt4TqRz1rFFJycRM3E0OGCNgbxa6Qs99ktiv2Kx9dIz92H28SFWMD3UlckB8OXPLg1hO9C2KuzC6ALUQqGSAsWh8737CGE7ia028MyBADYox6dcDZ2X02KuxwFwJLi4bqKnKAHH+WgkRgeQQB2+QJmN2gnUHi/ODS5pGMH8b3dEJ3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 3, 2026 at 2:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> With a fixed number to reclaim calculated at the beginning, making each
> following step smaller should reduce the lock contention and avoid
> over-aggressive reclaim of folios, as it will abort earlier when the
> number of folios to be reclaimed is reached.
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 643f9fc10214..9c28afb0219c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5008,7 +5008,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lru=
vec, struct scan_control *sc)
>                         break;
>                 }
>
> -               nr_batch =3D min(nr_to_scan, MAX_LRU_BATCH);
> +               nr_batch =3D min(nr_to_scan, MIN_LRU_BATCH);

I=E2=80=99m fine with the smaller batch size, but I wonder if
MIN_LRU_BATCH is too small.

Just curious if we are calling get_nr_to_scan() more frequently
before we can abort the while (true) loop if reclamation
is not making good progress.

Assume get_nr_to_scan() also has a cost. Not sure if a
value between MIN_LRU_BATCH and MAX_LRU_BATCH
would be better.

Thanks
Barry

