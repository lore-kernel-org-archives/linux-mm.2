Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28138606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 23:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OfkTtSt2
Received: by kanga.kvack.org (Postfix)
	id 389F66B0B36; Wed, 25 Nov 2026 18:44:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A596B0B37; Wed, 25 Nov 2026 18:44:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229326B0B38; Wed, 25 Nov 2026 18:44:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1C306B0B36
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:44:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78A621C1D49
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:44:34 +0000 (UTC)
X-FDA: 85475273268.17.30D217F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 90AA340009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:44:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OfkTtSt2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795650272;
	b=u5k/HXj3cjMDhQZU8l1ky1GLnnyPLWQQg0oaE1t9NSz0Rb7WMcGUfk+s/RTopeVe3FnA84
	r5UAD/mSx2Vecw7Gj8UkSbLnahq1PdBNlrS9laJGGkwI0+0PPp9GymEyr4Sh3QH4HBnE0U
	reLVw4R1F/ONEHvZHEBFzyA3s6hYQms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795650272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/ATAjGGuvCnHn352ejN1uMtKhQ6IIrtwCiWm+JOgec=;
	b=U5w125ihvedEfNP0NaLucdePFaS84y19MI2DaabqL+1K1ifv0IJ/PfliBK9ealy8BMzCZu
	cJJpWHWBm1so/PbqExOh4ErRrSf99FDLX2Wgf4Q3+lHDJjPScwaoKZERTSzGJTTpeqcsZH
	+VYUEjWMLZR/8fz0WWjYfh+qqYxQzCE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OfkTtSt2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88CAF46043
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE651F000CF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795650271;
	bh=f/ATAjGGuvCnHn352ejN1uMtKhQ6IIrtwCiWm+JOgec=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OfkTtSt2xtBQR9UeimfOoTw6v3sL+yc1TRUwElnClmYZrlwHdJanGTW6e4tH5HmCu
	 /ssM52sxD1/MhEerP68lHHZ2OqaasROIYX1xjwuQ6HHzNYlUZjf64/GqfLW5GZdNey
	 8NDu78Zrgxpy1RRRhqMjMcGGez/CPEcafU2I5r4u998bsnBDVTJNGADkdyqGonNP0d
	 8rY0clo9rfZHjK/mgu4HsuJwHdYmocLmWHimVsjmnkejjtqbC/khs90dLfWPk3USLN
	 Vg+PjAWb+XDt2QrKNk+9tb9bIH62ElwnS3HqSHnCpzgH0FC2MhIY/+Vz90ywivXVIA
	 3iXjXHfmqz9wQ==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93f269e335eso734900385a.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:44:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGvdiTiyxmvuDHhMLNCoRp19T93gCA+OeYIeZ0wk+mE3xFIfxUCDMdyE+FY2bC0oaevX9Di5cjDxg==@kvack.org
X-Gm-Message-State: APuU4Z/EqAYXDb3SmyQmczNP/1ZS7PN0PrWYH/CCFj0E+Jb73C7EJp5m
	nIB4sIVT/S+OJW9o3ok70mios0lFTK+N0ydEGcpY+SHN03lIPZex33vgrGNci6b8AsjYB3EzgmE
	1tSiI9NXJU6L1LhaMb7Nve8nQGNKJ2PU=
X-Received: by 2002:a05:620a:3188:b0:93e:869c:43e2 with SMTP id
 af79cd13be357-949baa0d797mr3140085885a.50.1795650270349; Wed, 25 Nov 2026
 15:44:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125113518.1207280-1-hui.zhu@linux.dev>
In-Reply-To: <20261125113518.1207280-1-hui.zhu@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 26 Nov 2026 07:44:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yTx+vQUQ44iLg8MNA718dY9Z1gAdnz9vvJnZWzVZx-4A@mail.gmail.com>
X-Gm-Features: Aa3M54qXmwUVwHqi93lcxb96GVJpfnkGS49EGx9GJPqC8qElTspz68Xy-8zCgLQ
Message-ID: <CAGsJ_4yTx+vQUQ44iLg8MNA718dY9Z1gAdnz9vvJnZWzVZx-4A@mail.gmail.com>
Subject: Re: [PATCH v3] mm: mglru: reset the mm iteration cursor in try_to_inc_max_seq_nowalk()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Harry Yoo <harry@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90AA340009
X-Rspam-User:
X-Stat-Signature: 9jjamaxjro96s5rrdcypxtpki5b8r3hh
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795650272-774101
X-HE-Meta: U2FsdGVkX1/kqeBPnmUlZ/P93TtFtz6joJXV0eYL6UtEp7nZS5eee2P+vfGlXqkP8w+OwiTape+dqbTXmVPBt3gKvvSQLUKx+2207Tuy5/hSFfDncFRVivETRGv7bam5Zq/T9/1c/GRHgNZCjsmuveyxWW1jO/iGNqRyGKVsdHTbO/j2s8U05FAMCmaWRQKRkEivPw1I7z1g4VqSNosVk4l6yI9dJKPM/ZnuwMSmdf95q9G9LlfnKX1/2wHYo92rH8kUz/Yt2BehXAHM1qgarqp7qLhmTt/wN0qQsXsarSKAfOs/amLq/vaQTcoUaz0zK5FG4/JkupvDGereVbrMbHQEC9So5c++JoFWUPkOfE40MDMGUuQoTnwoII5ZmL/knBZIi+7HTBH4exC5Hz+6RunaPfpmJ8/zFi/hATCqENquNv/hZdhu0qcQZdEPbG78dB3YpEnSvGKfl7BzZEkG7VxaZHkKJPoZPKolyyt6DtWmrVC3Gqm5SjS8fjuHKgdx9DRXAvRjjR5L2T19xJeCet0JNMqOi63t18w3kY3PwaYu+9gBjS1Bt6Skt66uIwLtXsjFhTJraENWLwmJ0YlE6NaZ+tF9fLMeBfIlbZzZ+/LDR//nYZpMtvdpx+IlSeOS81HvHew6QRImzlkAw3uUHgO/EweKi6lOWS+XMsmDgZiYGE0H4yPFZgBVCreVWo5KQI9X1J9jt130crbtznbfhmYhwlRGnE37zwxVHCW3bBsDyUN1HE0svbWld8lNpi8H7AOCRcdjk9b2J2O01LNR6ljSCVn0QHatuG41yycGuvNa1W/qbt/1lwnxaQKMdax9pou6T5IGcXDyXM0ezbM7bPTYh0d/DBknu5D1RTYVRe0Ypsy2VazFZr7jsyMx9jRxJP8AVFNWzWZGKknmamrZRmbWTEWOMtgJ/MNAfe/ysd2Y0p2dBd44Sf+0TlueKHsLPJK2g6d793pfXLWFabO
 2aqSgsiL
 CBh6IFYAYMPHXxUWHjhLZs2KRZKuPRUpa9oGd8N/0QKdJU8OiykHxe6mOpNDdPT2G5+6dl75WZplX5fpjcNU5SvEWTHHRzn2wZYuuRju+qetNsZkPo+UxufA5vNykEcrUvWhf4KBMuhTo6slsMgoOFxWKGBhm8RBLWCGP6c7GoUq7zy9lUZPH7yT6MvEKFqeEsVfQvj0axLqilgq313Rp87rcZ80BZZHAueolHs/hyL0CzltH8OqkfZE1G+qQ/NPZFJDi9OUGhWYdqDkyc/Tm6MevB+tYBhddi0A8z2W9jH1RswEdXETSu6R/70fRzK8Mt7Ffff+rSthBp9H+Y/vWaFBW5afz5zaFvfGrZZpTajcgSmmX4qGiRRCsogd9EIN6oTqZ/4bg0d4OO3vyHh84VUwMd+h49bbJaN5ntu4OgH9ndzzNePt3ZQNAfQzHQQGTSPV7U7GrOZB7Rmzz1GKuvaT/acCJFCSMuzNm1hNyMTI9tjK5FR0n+2BJKswL4+U48gcXSw++xufvuRKmp3UH/HsXHsIp/Ff8ZHQJwDIuCL/tdrdbOAG6WFi0ZeAwkRNncwVbPBajYZU8bMGIbhX036rFabsQpoAC0fT7ikyK8oXLsE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 7:35=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> try_to_inc_max_seq_nowalk() advances mm_state->seq without walking the
> mm_list, but unlike iterate_mm_list_nowalk() it leaves head and tail
> alone. If it races with an ongoing page table walk, the cursor is left in
> the middle of the fifo.
>
> The next walker reads that as "this generation already started": it skips
> reset_bloom_filter() and resumes after the cursor. The mm it visits are
> the ones the aborted walk never reached, so they have no bits in the
> filter being read and walk_pmd_range() descends into none of their PMDs.
> Those mm miss a generation of accessed-bit harvesting, so their aging is
> less accurate and hot folios can be under-promoted. Eviction can still
> detect their references via rmap and lru_gen_look_around(), so this
> weakens aging rather than guaranteeing reclaim and refault.
>
> Reset head and tail with the seq increment, as iterate_mm_list_nowalk()
> does. It is safe: get_next_mm() holds an mmgrab() reference and a
> concurrent walker bails out at "walk->seq <=3D mm_state->seq" before
> touching head again.
>
> Only reachable from memcg_reparent_objcgs() -> max_lru_gen_memcg(); not a
> memory safety issue, since lru_gen_del_mm() repoints head and tail under
> mm_list->lock.
>
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

