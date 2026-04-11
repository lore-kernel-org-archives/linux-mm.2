Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A27F45A1E
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 04:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F49C6B0089; Sat, 11 Apr 2026 00:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5D66B008A; Sat, 11 Apr 2026 00:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC136B0092; Sat, 11 Apr 2026 00:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7C36B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:33:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0D89E35CD
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:33:37 +0000 (UTC)
X-FDA: 84645006474.17.3E631C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DFA6B12000B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:33:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJMHSOvk;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJMHSOvk;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775882016; a=rsa-sha256;
	cv=none;
	b=FwG/B6efrPrEZBbF0bwzGyEiWbN+G2D2xpJ20WNAyJKEL34w/Q9P4bbE5f+xaAmuIogWjA
	ycnsj5wPwBX4sQAT2sq/+YGx+nB2BMlsV5NBxZS7Ns2HeTvpKTMiqjvNbMycyFDQSrPiwg
	EEH5oykYyhSyWQAVuVtB8wYUKjZxONI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775882016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSuh+FAi4eaWp65FSPxHy5F7EQ6BKPFGwR8BxtlGUMc=;
	b=MYLF83Fm5+uPTVlrcZQuWQRiKR2TTJG5wlYakabd/HoE+FAZu1dLV8wzYINOVlEU40LeUG
	voOtXM9UtZnx3ut7kPVCKEfrBnlIC2Tm83o7g0b+s+eb5+1CEKKe8/oV1njCQJyVskNp3q
	fuW1sHoYdg5ujCgv9LwsPwTPGyNmCJg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF2FA444A0
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45E3C2BCB7
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775882014;
	bh=BSuh+FAi4eaWp65FSPxHy5F7EQ6BKPFGwR8BxtlGUMc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tJMHSOvk/0stbb7Q6cx1dqgF5c8qg2bq5nxlnHUqxsImRP2ubiNe29jSq5ua0Zzp5
	 /wWOT16LYjpBatA0Na/fLPGtEhHAG8QZNPKvTkVjFGKys2zaw81zPDEaFy7uIg8F9H
	 VWyiu/djih2GsQcrFWV1wow/R6gTHYaeSX7VH9yPjeFu599ryC3ZCVF7sKeqyvIY5a
	 RRA5npEC5htvOrJjIhLsnbfNjIVg62+WHdoGBlrLTWjbn/c6bLSQJWG6gpbrkvvGvf
	 fPkXzNmWTwp0QAfJkMbHbilKslfb2AbtXjfLNGlCc4cf9fKs+hIxmjnlFUUr2addQO
	 D7T9uypjiFJyw==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a00566c11bso34785226d6.2
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:33:34 -0700 (PDT)
X-Gm-Message-State: AOJu0YwSmgZ3KdATwSMEaG78MaZvbPXDtXVO9+uOB9G+c4nz1UUzGKPj
	vSbu7AhGkXABnv0xcBMDwU1CbRIB9NeJaoPBKhMpohBfjBbzCoumNp/Z7I2u/3Grv2HgVGByWeL
	aUW9g3lTj+L0uJgqlEJaNXLHL3uKhWQo=
X-Received: by 2002:a05:622a:281:b0:509:965f:888f with SMTP id
 d75a77b69052e-50dd57ef9bdmr91781331cf.0.1775882013953; Fri, 10 Apr 2026
 21:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com> <20260407-mglru-reclaim-v4-13-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-13-98cf3dc69519@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 12:33:22 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xF-gMYVugbwhFp3_jS-JHsMi+wwjou52JYwb5GXaMhcA@mail.gmail.com>
X-Gm-Features: AQROBzDQ9p205mDi9V0YNTh55D_RjZlpkb5Rnx60hsllhoVRII2IMLU8_jW6caM
Message-ID: <CAGsJ_4xF-gMYVugbwhFp3_jS-JHsMi+wwjou52JYwb5GXaMhcA@mail.gmail.com>
Subject: Re: [PATCH v4 13/14] mm/vmscan: remove sc->unqueued_dirty
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DFA6B12000B
X-Stat-Signature: g311msnzbmqzppgqkx4a8ih9gqnsoxwg
X-Rspam-User: 
X-HE-Tag: 1775882015-569857
X-HE-Meta: U2FsdGVkX1/VVV+9YGyEKKH5JybThh8yB+DWETpZAr+liuQ+knocTr0UhTQtpizs2CjRgQ36fkYXT5fsrg3gEQ4TeHYirFkZVc6K492+vB7Jxtr27L7/9MqpIY3la6JWj9EppaVw0wPnvZ8NqDEAMRkdiv5mFIvxvNj4ZRyOk5Jw6N2ss2raYLTBqQuIOwuNxTwJf4l4NSCkfMpWZHIp60qWMxF962e64G87MDnqy4DDwGN++O/YgkpqMymGNWVJZNeo46rYWhZMqfESdvfyoR/go2ICALHmZsGFeGP10lvGyNnmmrQ/JZrwEgmOJxkQXfAbAHX2qwZCTicrhdqLdnRWVOYoH15WWlLIcyJQMAIv0eOlJtU2VCXez/HN316oRaf3idUF2hy4D5vBhSgTVyz2ZXM2xEpXxxSMmbIk77TKBqEG3kMoPbblP065iRX4bGWRiQlVZ+2pAztECK7JMNSYRHlESAiMO3MDie+8VpwYQRzyw9Mc5KAz7lRk3RfdFFR7GVrZLmFXIgHmGoHXoI5IB6fpoPKCDZCa9O7GqaiJ3s+MykzqPzmiI+HNkJIVF3P1/8XO3PezisqVWpW5yJ1j+Y7/1ql8GbC2IV6Aj/n+jlADHPDzQ0ebysa/3ws4dggIOMdxNUHlVZPlytuuzCFGy5DCC1+QEbK8LNTPAntNq14wy5F/KMSaGVmf4iBK7zfhfLSHaqnDdaUEJI94n7FmV92suOZAapX2fCmqdDlJTv50EiwihdYvcN7MN7LWg9BRhUJZr4rUlAIgxBKTkbX7btHtCuGGbs+VTZi3uk7qLBWaLXUVGUV8hDBAzvamgF+8f46wgmMHTbMoB4eVZ8uKbUIM4ftu9oIDfSQJzxUFaU8Ent19iiEMqfT7Hh0shc8WwRffvX+DVAukN5si656zomMefSxCszDisV536DX1pXp5K2ga/A0YO1QWtqYV946XIqi2pbJQf86bRvY
 w5KC5+Eu
 xOYbcfVRFnQ+oHZrg2iShPHk/jsx8Wi+nj4/O1F2VMaCugeekIeH+BN66TpmsrbFcU5kXV8Lj5cI2nH+5CdHzO/4dCWvFUfQS2ya2YVrcvOBW84BAmSt7m5BUefNcftdRMqz59Xs4rh1FC0lT8jmZkEfaWvpZ56SJDDLN8a7GJgb/KRbr6q9LafUW+Q7kpYguvIfpuHLvqm3B2GM0rDJkfd/jbjoU1GcLeu8aJ6G5rx/dOCaygYziJaZC1WFHLlavwpJDBTe7qWC81Fg7UpuayMn0AL3atPU5ruNxo4Xu/jwgquOyO/tqCppxYfMKswB4jHWYC0VLpxCAFuBldxDRrJ4vjP32VOQN0But+/wvOi1pvQmi60nEkUXYfcLGM+ywQCRbjpwoxGUY+N79vvNN0z37ShkDPl1DNrVORdl1ZLpejU9BAKoOSVJbQ7cFb/itFMktFHy1OwTka0H/KJ9vJF8Geji9/qoxfgeh2JgwlFpjzKoLpSQosUUG6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 8:04=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> No one is using it now, just remove it.
>
> Suggested-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

Best Regards
Barry

