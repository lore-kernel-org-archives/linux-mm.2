Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11EF3C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 06:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AFFB6B008C; Sat, 19 Sep 2026 02:50:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639B06B0092; Sat, 19 Sep 2026 02:50:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501AB6B0093; Sat, 19 Sep 2026 02:50:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26C536B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:50:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 635CD1A01CB
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:50:35 +0000 (UTC)
X-FDA: 85229588430.25.618610C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 87FDA160004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:50:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIPvq99o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789800633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fy0hcrpc8gMaop8QcMQpaxARuL214HEekfRBW/zK9rY=;
	b=q1fAdY7ESNhWtNMRBRibtS8IBP1+bq1vMbBBht9xulfsmTZtNFPgas+att1WH1VH72GECD
	x5m5ns/1rxZcUS04RrSC44Sie9KV3P0xS3kmqxN8dySz8nGVe1M5cvGSTUXRMZkIMcu9Ph
	C8eD+8gzJA12APeCjvb7BZMdrsBQR/Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789800633;
	b=j3xHazDIKsGHlwFMwqDa8xbthmRTTDkOzLyzEsUS6Fy0NjMI7R2m4RKQ+YcPeMq2A2nCOQ
	Wo54k3UI/FqSsK586r/lKapNcJTvFoPLckdJ+k/CzLMoX4pR/XSBGLC6SSOX7IT+3SPm9S
	nOWOYuV57eY7nTJjd1YFc7ztyaUQmCs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIPvq99o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 643DD60232
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189F81F0089C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789800631;
	bh=Fy0hcrpc8gMaop8QcMQpaxARuL214HEekfRBW/zK9rY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MIPvq99olCRTHkZm1a4B8dnyivpeG0vonLr8KVJro7Umjvj9r0UHj8ViaTpLGli81
	 7F6VI1ERxQQ9TsQUsQ9qCudOMvh8Fk1oS07eNXTxn4buUuVhd8rszx4HuBGEFEnJhB
	 VjNFJjUT7d9mur+Simr0L5yO/ENwKxrpJTgO7iajCPeSZxc01krhauFJF6BKaOpsTB
	 TYe8xj1URdMs/kzH3QOQrF5L8Wa4FxwiFNyiDSND5OIAJMAYpGqyZN1rnwdRUf8WWL
	 66IyqD4hve/foAj8TIbwOXbjECgNfO8jwsJZ/WnjKdwLrLZ2KrnYROiRXvSq5YJ5m4
	 bMElivfCyeDOA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66f7a9afe43so1254708d50.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:50:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzQQfz2+WNIjW1CLsmz0sj24iqLSqpknv2RbhKBmikFBKMG9iQtPoOPvmJVqqX+6YGr2/9vxSIWjg==@kvack.org
X-Gm-Message-State: AFuF++mCCXn0h89mU5wOSgnW22ukaRSy0qASh818O2AI0HqcMKWzuCyZ
	EAkOK6rc9SR4tpiWaDkjW8K5yq1YzpnAbE6GTxnqa8fU2ylWN2crR34QvIVbf3RwudtQdqd/RB3
	jqDkII0FNa1Gfsi+0emsIQVNGT7kyVakT601ZajebJg==
X-Received: by 2002:a05:690e:80a:20b0:66f:c1bc:c085 with SMTP id
 956f58d0204a3-6717fdf9ab7mr1037245d50.77.1789800630447; Fri, 18 Sep 2026
 23:50:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com> <aqgMCIOFi0dKx_6L@fedora>
In-Reply-To: <aqgMCIOFi0dKx_6L@fedora>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 01:50:18 -0500
X-Gmail-Original-Message-ID: <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
X-Gm-Features: AcwNN1UsCayhu6qSBcp0NCeBygOCBz7cKHDcf9ihkAi9fMFOHSellJ6quiD_7YE
Message-ID: <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 87FDA160004
X-Stat-Signature: ma96ge3irwgpyfhpx47tenhhqqhkngaq
X-HE-Tag: 1789800633-9398
X-HE-Meta: U2FsdGVkX1+4kVmEK7qqLu3/pa4aYA/4sLXrQnWoA3plbn6wmmJTWYj7wgcG+hR06FAbvLywEmHMHdK0nbEdVLllblb94XymdXV7FYaAK7hKtRUqlBxibaR5Y3Nq1slnRTYYXFPnPkIkE9GLOd8OkhIW5r5W5hINX787oxvoHDmUw9iugW19ID6MtsH8wBDu4WfioU5/++Un3Fl/n/FKUSRPtfttMFH3PSkZ9fhYm4/SOnfu1vQz9h3hhhwdR3B66y7RxZocosCnk3N1ChpTbkWvCFSovDXJR9C7q2beecl/BY5zkjMZo8op5QfbtPPKTETUFPttIp3qxeT9D5BKG8EaGPP8L/HgCQ0FerKx9cJT+9uUJ10axjV7B8l875033eA90fBsa4TkMpidWYTVnkTQ09mpqLepGcil42SJPjQGgfaWM7ZVpzLJx3f8pg1evH8GY2tzonzv+p0GT2DbEWigzFZliZ/nPNjOfiZhHzVnlpR2LmZCG1+MEau3uL1fJCJUlpfW/rvYZ96nqxnQ1sTlNIS0MrudmB8rf9VUbkx1nr0CEHtJl8FXMxBpZSzJN5XwhX28cbkANmH8tddJk18zzAp/kX6REd2Dgz5EqSq4/KOalZ/6xZkOORyPSddlLBapMQEFjBoxRzz2OSJdcpbakKcZGujUkOaF8ujRnAAYCWEB6eDfBQ5dBVw/7YEhv5lSsBsuMml7YnPU/+PyNpCYXSuYixGyr67s/rk+AUnIiNDeYTRpOwtGJffsyor7bjisNo00US10yR8eYxjA/dpV7LjAxRT7OH/DoeYWFLHZKYrtfkj3T70PK7Hq7ekj74spqpyv70yjGHFHpPJgD+fCxWQXRgl/wmqvEed87j6OWLZJ+eiDPcBNfRrdTlC6ki2NaSAlgHuhjrlhCBueyCf2O9Ycy8qyAbnvPEBgf8LtK7Bh5GBE59wyBOsasEO1XQjSTkvvipeI3iABcF2
 zmkVqAjP
 FGWCliUsn0nwVU1pNynCMgdfKPIVgRYtFgtqZyx6wLXNwaPU7WY+msYGtS332+PkE7EoByvp9H0yiP4Nj8aURZEZgSbUl1b6UGVEYJExRcs2MyJ6LzBYbcAszcYCGFBdFG1ZHotVO9qpbp5an5//GRgc9HOhZn6il1K2EIWXmkFqDvAJBcrG9bzkcwoSetsPRrQueKf1yp6IdjYVeeJAzI9zhfBn402GWLhVrYA7HAEcLP2h27TtCmJ7TCxlf1dZYVjz3fqb2YrpzzeF5EyKBQ6exCm/a4JyIU616p51T2e3RNZAJechXoYDq/Irh6s9VCPUvyun/jLBRksN3v9KqZe7xPTzkC+zD/eyRDxMDRU5HThv6kMm3/zGSxHxwuxA8PNc8gGyB1MAD9ECxPHyGz7MIng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 10:00=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> >
> > Is 9AM PDT fixed, or can it be adjusted? 9AM PDT is midnight for the
> > UTC+8 folks.
> >
> > The time is still fine for me, though, I tend to stay up quite late
> > anyway ;) so that time works fine on my end if the slot is fixed.
> >
> > Is there a calendar invite or something, please send me one, I'm happy
> > to do a swap sync discussion there.
>
> Thanks for opening this up for discussion. While the time slot is a
> little late for me, I am not very sure if I can attend, will see.

No that time slot is too late for Asia developers. I don't think we
should use that time slot for swap alignment.

We should find a time slot more friendly to Asia.

Chris

