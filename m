Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D9A3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173456B0088; Wed,  8 Jul 2026 03:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B6C6B008A; Wed,  8 Jul 2026 03:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF786B008C; Wed,  8 Jul 2026 03:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9CE16B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:24:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 553D9C3EC8
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:24:31 +0000 (UTC)
X-FDA: 84964771542.05.8DFBB29
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B1DFC000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:24:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jEoC5LU4;
	spf=pass (imf10.hostedemail.com: domain of richardycc@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783495469;
	b=XKCs093Ezgoos0+FtdqRJKq1tNRpT0sXCSa7Zoyb2DPD6fEKVTXszfNRdxctGMoZ5771Q4
	lW2XBZf/lE7rRzyERfkutdCrBVT5dFgnWybgbAcfG00jdiaLgngclr/O2WBt6skG3bC5Ai
	c59ikzPQMzPop+FBhgdUjuV7oivsEUA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jEoC5LU4;
	spf=pass (imf10.hostedemail.com: domain of richardycc@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783495469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVZVfce8FNmbFhTXKl/TGSoVctJTue/+MEYw4Jos9Tk=;
	b=BvNaurYvn7liPQ6DAb26I7CqCFUqTH29glqnajGgjDW+WmhGy6o3+S4SGBzXxMgh4zUk1v
	ux/McGxcJCwfTPrViJXUHAMBVpULt29hEcGIOjrnpi1CN4cNbN7L9vftZSvmQ4UKXBC3x3
	SCDpt7LeyjhUjn3KMXc6NPrVyoAJx5o=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso1133e87.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 00:24:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783495468; cv=none;
        d=google.com; s=arc-20260327;
        b=necODvZaV1PgLrNgPCSOGV+k28J8sCMt/0uhoJ/TrUSQRN9fVoHePJ+mJtTb/Pbs/Y
         qTdUj5cUVVaPKsrcgzHAE8HoPXcok5rEe+DTGy2HHrHCfz35pjLU3iOKuWOKDI4ze9NG
         jpttvD0GsHcoYYI4ckZM4c3Q74ZT5/0PiHT27Ya72/s7Sj8GvoHmvOSk6C/7s+m61syK
         dEofB1WzMsf6OxGOum2+ZAoTOMrSXqleynGRwiKaO7bWZmnSTvM4ZZe0xGcmCfNv8dLt
         DZjXd1TXQRQJoTD9Gdi14uHfGZzmLmFTVM+k/z5poR0awTaCCTwFDAQ4vhZAs22Lp5+/
         T1Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SVZVfce8FNmbFhTXKl/TGSoVctJTue/+MEYw4Jos9Tk=;
        fh=bBqTTgoFSxnvI15cvfVDUQrmkl9Yord0KF8ONQCt6F0=;
        b=VeVl5Wgd/4Fvsb1r5s4+MkchNWBFo2Evg9mP7Tg3SV+hWt+l3QqGVws4QeyB72TgRH
         9Xg/eYAVMe1OrMfIpKsz59WHfxBpzrNP+SyPTdRpZmfj8O6EwS/0qj/79qciX8zj6+RA
         zpho4a4jwRON/bJ8pgO3BDADvd1PXptITNmTgQoKREndXsUCydMxPjDVzHVmrf0ZiU/d
         LrzO46/ZWLm/nUse5tppIggaoual2gYdC0KGmOAB0a6Ibcjf0WIWIkFPW7gmNCGOpmnA
         ztaMlZ6wCcuc6GlW5DLsiBxfmR/fEsDeTRHDWaSiepCQ8qMEjuaLvZpG2QGmKngH2V43
         O6Zg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783495468; x=1784100268; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SVZVfce8FNmbFhTXKl/TGSoVctJTue/+MEYw4Jos9Tk=;
        b=jEoC5LU4evRa0VHGFIEYDHhgtUnWTHPhQLUfPpdIdNjEm9Q4H1uHmVsGjG1jtk1klk
         tisCz5dm4DJ4QcH/5Amf0xbIsuqp+q5x7Q9iIvqFntRlkvZ6FPhLNybU0lyC7GJ+oM8n
         03Sw4bxq9pJiemFAugx89Cin5FsvnHgXWezTJa760O+nD7fdZ6Z1h5fX60F/fQjRXvT4
         EeR5bgckYfqlH0y6THKf7XrJzROb5jCAZGF2DTdABtfxhEA5vrw0naDAcmD3fWqXX12c
         q6Jt38cAt3kKx93ReYJ/GWRqIVe2zEO3pmpG0BugpzNv+y4hPBz9yYS6UBfSiO7CSqd7
         2GuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783495468; x=1784100268;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SVZVfce8FNmbFhTXKl/TGSoVctJTue/+MEYw4Jos9Tk=;
        b=i4WnghmHMzT3hKc3jo9FtO+GuWxucR5C6AoCCDG/kefVThmRnetTTP/YQxH1J6a0mm
         sWOymkmQ4HAyh7yvVisp2tnaWyaEdZ7sPaCAxhKRknobMkyz0J+QdmWewTX+TwUA3Ssd
         G1dXK8Aihko1fMB9X+4BPN4S4peSxi6aHEESMhctSs+ENxE+VUK0AWwGkTMjkVXC2Lk4
         G5ubemosSv5Psp/0URn4xV/y4ERQ2vSezxzBKco/8zGFzob0MzU4z0AFsfy7aSlWoPdd
         L51lA4dmFNkx54zX1vHTyk0zrUVFB0obSYvNSVJmZEBZ2V1werSEhdo/9C5STdQ11vHv
         Q4ng==
X-Forwarded-Encrypted: i=1; AHgh+RrsITLKI3CaGh92D2q9eurf6N67Ce2L814cMMEr22CGN8THRv6lIkyPPlS4N+HuF8HrfX3VilKfTA==@kvack.org
X-Gm-Message-State: AOJu0YywOsYSOU3vUSWuWT8LHeVmzhPac477DkxGOhVdZbLJ1uYQHjFT
	InVGvOytoMjeFRZbrT1Pcl73Lad+tN1hLA+FBdK1Uhl4vx/gEeJaW4M8PuLpYLhWq0rvs9MF4QV
	qO3js3eUoFKOHV3PLGxmWx9ZUnZNqjwKBIrRQ0e8=
X-Gm-Gg: AfdE7ckvzSe5kVdVOkdvI//bpISuT7bnsejNbxKUe4nUcrxADSllKn0TpKaza3P5QX7
	E6onAFIlJpw38+bc6UquE86Xi+wSyAeDXgxBbArR+eh7z0yXGwwWdw4t4oiUcjzaj3y0Sy3TLYC
	fP9hpptO1Jr2mOj9J/78/Kr4sG4xef1yTfJfT479vT3L5kC/wVw8Vk3YyNnzL68ISLd8JddSoHe
	QRIPn8GzYbXPH3ZvvmJ7gW5urQgVkrYH+mnp6SSAwztBs0d86a3FVWLCSX5w7s0O47hLT9dtRBY
	xzJZVA==
X-Received: by 2002:a05:6512:3f12:b0:5ae:b726:5f1f with SMTP id
 2adb3069b0e04-5b00d26aaf1mr155042e87.8.1783495467232; Wed, 08 Jul 2026
 00:24:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260706081218.3438762-1-richardycc@google.com>
 <ak1XzPxbwBF72d1m@linux.dev> <CALC_0q9=KNnkQBE_7gC60jZ2Akj9jgL+VaDMFd7yGvqyfTJbYw@mail.gmail.com>
 <ak3Xtrtm5iVayEx7@linux.dev>
In-Reply-To: <ak3Xtrtm5iVayEx7@linux.dev>
From: Richard Chang <richardycc@google.com>
Date: Wed, 8 Jul 2026 15:24:15 +0800
X-Gm-Features: AVVi8CeLgXtPAPjV2LSKKBfklguWzZ9VdOH_PS57VBiZCzhmCOWwzbYvnYViDBE
Message-ID: <CALC_0q-juSkv=iqG7mAGCuGqbdCtjEHEy6oD1pcxQkFdBMJHWg@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B1DFC000A
X-Stat-Signature: 89e4hu8zeqh3se41gyknnr561ru5fzjo
X-HE-Tag: 1783495469-878198
X-HE-Meta: U2FsdGVkX184lvQGyHx2mz0kX5qcLxdryCBTF8gSHttGN7kwgJjoKrvrlb6UE+KuD6xBvaXm14o+T4fCCdvfRmZv4AAETyFtHpwdRGXH7dDud4xQ5MgAN0U05iO14OIVqNxXlL1eFeeSNWP9Ul3ECqQeEEFXckZpz0s3kEqUajB6BMyxAtFVnArGqTwUT4MD4a44h9itPv+Sm3V9bkkRPdaHqv73zX1Ky/eAP+57U2V9OBRFO9EKj1weW0LhFp7yYOCG7Rp+maAp1OvYnMSOKCmU59Cmg+h4c8gA8DvviygVopyF7LFDX88FYxu2qngUVaBvluXNf2darUEdYm/0rrdtngVk7sNyMxj9GAQbzgNi1AXT50CnRuPOcSf4O6PU3od23gBK7AFOJ1PoMH/qusKvHarXz4JrUDdiiwsqTLOnt6fQSxh4OGEhUpNf8sDvZHSwERBF+H3JLI30r///y5r4cvJAls1ZoGSgxKHFRuNJfLVExHQOwSgYMYeqFDv5Nb0FtpyViJmZucd092u18+B3I3KfXjSjOf30G8eKhe4jbeDOhvMNab3gIT/OijLq8sjVfLQ4KjGWKj6EddEFsr6Yxs/066xE4xaBwTwDJqLiPcDgizbRhpQ9ZTt+d16p6CaAovbNtmZAcSZPSXVUU4N/L4QBf5EVspqPfv5Fn9JrW0gA+GltWwBCVlaU4ZSKup37p0+j/vy3c/p090WOL9gTIxt9DXZVJSLXkucNkHLOLf6ExO24pLUrQS6wnl9HmV+hoxsi6ux2gGukziOiu3xIHA+jbD9EF86Awssswa4VVQ4f4qoAjLr8FYCpoY2KybH7iRIkUtxwVsjXBpe0k+h6xxh+UvXooC+GVycFVAhkYO4cFa6rJeHH/8qTQBdO/b/7UwIwhHIs0Pu0rMgrXNv4tpWqxkBZmRX0Wo6h+M7PBpEMOnCHvG1GIXzB1wnwqtYU1LOPLf4h55dT1DW
 lWfSA+tz
 ahUMD8r98nT5hoTlF+40U3fF4LH0WZyOfKiWxMWmE3C2iTyd8Ai5nagH6ZoOa+w3D49h4IXkSh79lhhagC3KMYmi64H9b+w+gHLXINbD6cks8OHgaiHBd3yf7Ht/R2rwMk6spc24vUxo3S3Qt2uFijr26OYMXT3lE7WbZZcNvEICx0aBzoI36EiMuYcJw/XWFzDAVctbav1TdLIPweNIwqcRbjcrFa+EOcn/qf6n80ILefFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 12:54=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> What's so special about proactive reclaim? Why the same situation can not=
 happen
> for global or memcg reclaim?
>

The target batch size of the global/memcg reclaim is typically very
small -- usually SWAP_CLUSTER_MAX (32 pages), allowing the task to
yield or check signals between attempts.
Furthermore, kswapd is a kernel thread designed to be freezable, it
explicitly checks kthread_freezable_should_stop() in the main loop.
In contrast, the target batch size in proactive reclaim is
user-defined and can be extremely large. Without signal checks in the
inner loops, the task may continue scanning and evicting pages for
seconds at a time.

