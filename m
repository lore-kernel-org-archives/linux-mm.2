Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAEB9C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 10:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E042B6B0095; Sat, 29 Aug 2026 06:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5FE6B0096; Sat, 29 Aug 2026 06:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB5C6B0098; Sat, 29 Aug 2026 06:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEB046B0095
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:05:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45712140685
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:05:03 +0000 (UTC)
X-FDA: 85153873686.20.C2A98B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7109020002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:05:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+PqkQXG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787997901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bm1bDKma1fCaZlo6UL6h2FrDywYhUARIBqg2ikagqJI=;
	b=XcJ/8vd6bUPNhVP2eyxIH98xHTXyUdCzqFzgWW3836+4F4HSSmd+PaY8oQPIAE5dk32aeJ
	yBU29qZOFNc4qao0SYSYJnkVgsU6G+ywM02cHGtBW4oTbUUWdSIUxQs3cqaVGresCfAPvL
	4j6sPHMSEcLyMf7HrnivHVC/viELTHk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+PqkQXG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787997901;
	b=U2JFClHDcQsYuFgQSxFilpguu7VzmEU4/zrHQ8Oba7YT3wpPHubcqGYi9RBtTuq08se+jm
	imcN2igGblGUwIE9mcqdVQtSEVcyGLCZXeC9IG0vipChbRVXerIAkZk21VoRxYpsV8Lxgf
	23bV9m6POXRtum/EMqJUc+e+yFnrz10=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54F51601FE
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0103C1F00A3F
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787997900;
	bh=Bm1bDKma1fCaZlo6UL6h2FrDywYhUARIBqg2ikagqJI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Z+PqkQXGYbY9/A0mRMQa8SBREguvmiQFpgCS7ncHAY/AUCJM9o2SfDjA6hsgDq8Ez
	 +3Mm0EWs9yOftNpFTALFo1/T+66ksL0gVV4A1tpo6YlluRt4TItKIvveb2VOCnHa5N
	 qyZ9/zp+VynmUSel3VpOHTfB2nLDy+USLgjJ+/6uKQH/b1fYBUM9k5lrwfgdejEja3
	 Joxpavp74DPSqhjh8YnFLypvUiZai7OoyEhtJgwIzBUHExOlvyYAEdSq6CiIpPS8OC
	 lD6aF28g15EroYcIZFcC1mU3OeeQYx5PmP4jCJ/hKDR0BsKQml+m4q+iBuPkCku4FP
	 2yb0Jf4mwuH3w==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-90cc0ebbf4bso10328446d6.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:04:59 -0700 (PDT)
X-Gm-Message-State: AFuF++mY6tkYXaDE9qZGJhe1prb7g7Dh24zV4Te2qKXG6rdyDYyUnchJ
	QNFFLs1HEEzMMg6B5V14iXbn0uZpJGdq2AdNg3mhBXAaT310RKPsjjeSk9d9BoyoWofNQ4vxP0J
	qDAeLPP7P3hbwmY3/c5fzjKSrHeb9nH0=
X-Received: by 2002:a05:6214:4497:b0:90a:7fbd:ea89 with SMTP id
 6a1803df08f44-90ce0e572dfmr180465806d6.1.1787997899307; Sat, 29 Aug 2026
 03:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-4-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-4-d9f1c75549c8@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Aug 2026 18:04:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wU7B_Lnz_fbKOUsb+2fs1D3GrMcPq7FBLN4n4M7LLwBg@mail.gmail.com>
X-Gm-Features: AcwNN1X-K486iK9cL85ffaV_ppz2Dedfrrpz1iVvNLwjwGEYt4Lbvyldsp-xaSY
Message-ID: <CAGsJ_4wU7B_Lnz_fbKOUsb+2fs1D3GrMcPq7FBLN4n4M7LLwBg@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] mm/mglru: move max_seq read into walk_update_folio
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: akxawq31t8gxqa1i3wbou1hyyu5qo8qz
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7109020002
X-Rspam-User: 
X-HE-Tag: 1787997901-757912
X-HE-Meta: U2FsdGVkX1/Qro7Uc5qpnwRkIqjekfGDClkpHCVID1RGug/zGdtzEivapc3gfRSV54ocjJ387q3R2Zx0oKA1/Gvno/5Pih675qH5PbtunFg29tbY5pe0ZV/GMbFKuqIwCpJjdyZLfaZhX+OS7Dd7kDM71daerm7n+RoegW5iDqu1FBO2OdhwyZOVSwf9/VUFYxkIxfjblCbiccLXzhylGhHyzcztgvG+fEbcbKRV6qnOqtD9GXcOLlDgRI4c26yvR4CgJSxL5noJLQyL1NAR6Vj0bBGpUmPp+MrrX2TV9se7ylrDUA/N4zBXnUagmKw5hjherVfNlX7lKYdPJ7V7TDEK3hAeKU6vrbyPbFQZ7XXNn9+d3TliKshX0TNpv2kKCfd6ocWuPSvIOCXqvEuym2mwrLbhwSIsA4WCzRfrCfBwcl0sQRzR36TtbF3LPPAHegCZ692QjEVtrJesU0E4NYBLjlfSdt2H9OESkZqoFm+cdAO+5c+30+8ausH8dqJ6AjwB5fPC2ryFZEPhDRC5cSlyshd1TnEHJUi2jHYplhcIVomXBlkHOFngrl4/TgW/h9Gffjhb5GdBktDksNSjKUl1nxRSif2s3fjA7TbaTBWrM3mLXwR3WJfsqko2rWIliozg04YBAGi9IIrYQ7l9TnhhUK15VHZbcZOqjlO4qhrpj+aMHW4TTvUBF4ha8Z1LfqDYHNo1aFpzCm9Ov7mFSlWTWlF9AWl+jx8hFFV54n7H03OlJuwrVUO3rciEVCCI5Ro0uTPLEiduc/B74hJ18L9aNYlKr9s2gKbizHy6MLj6WR+FH97Ptx929n4IaHXdVi/myd/I/6s9QP9bivWfHT+lJZSwtuwyRgb4o61qpPh7rr2PVYOl62F1JKqzF2ep0i1sPRnE1ylOllzCjmkaFbFCYUuwr1TpHEXb1Ia0j7jx5rkMJl6HfqVjR7H5qPflHax5PMOD+M2hvxjKlLt
 KA72KrO8
 QpjkllEGut4qoVEUZgiokaR2F/uBshziWXUXn2UlNYQ1fbgkfDZ6Ds9N0Kr4ez60sE3yPSma3RWLT1NCER+CXvJ2UQsWulVLAhTT46CREEtO7I7c22sX35uQr5TmdHBSdSs6r9wdsgzPKVrreMRTmQDwU6hgrFj2/xNJHLjORbaTADnTpn9iktZ8m/Wjt+jqRDt8Y62OrcNVGLjWQeebZD67AtFFlWL/BbnalT2zecTsyEfjS6nY/pPk4o9aEQekY1GB/akiKGPYWpz3dXXvvfqwOhZ9S5Y1QtRenpelkcpFwEXLaL7C+b90xXOsGHsG0ZbBmGxJfERvFGcoeEkcFU6uoBG5GgF1zSpiJH/cSS0pV4miVzMZgCDBCty8Aq53envDl2vIWB3DjYUtuQyJL0slo2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 1:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
> each read lrugen->max_seq to compute the target generation used by
> walk_update_folio(), then pass it as a parameter. Move the read into
> walk_update_folio() itself so the callers no longer need to compute
> or pass the value.
>
> The max_seq read now happens once per folio update rather than once
> per walk range, so folios always get promoted to the current youngest
> generation.
>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

