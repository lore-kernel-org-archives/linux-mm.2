Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B423606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QsxeWVGs
Received: by kanga.kvack.org (Postfix)
	id AF34F6B05B1; Tue,  3 Nov 2026 01:26:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACBB36B05B4; Tue,  3 Nov 2026 01:26:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E14B6B05C7; Tue,  3 Nov 2026 01:26:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB1A6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:26:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00803A03EE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:26:42 +0000 (UTC)
X-FDA: 85392824286.01.B97DB36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3864820002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:26:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsxeWVGs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793687201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YqOpFkmr9cAx+aebIVE0MX85yK0hEwpHWmKUBVI4T8=;
	b=UzczbwDRnhX5sQeJKJn2GxUEqb9rnYK3UrV/tAm7Vplq1WLtYY0zDwefIN0FNgCtd/n/yN
	MvzlNfyU/DigeceTALVJ59W/CI0yL1Nt0od0l7HEOP68nIpL69BWCZz/kQaGFVtgATd9LN
	r9l31EkY0JvGhbWf6E9mdmf2gvCa6hI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsxeWVGs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793687201;
	b=WU1Te7/pVrmihdNc+/Wnr+Bb4AEF/W+R5xXxCtvG5HQsIPYhSu97D5CKuCBIYjc4NNu/0a
	LLofmYvmfuiJGGpSafCdKQC9zD7ZEC9aZHoXbOgvV1IOQ6cVhEODc5waNfXK9wWn1/ry8U
	FGiyPPbJsFA5z6/JhIbVx6lQ4dDBWUc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 114B843DEC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAD51F00A23
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793687200;
	bh=8YqOpFkmr9cAx+aebIVE0MX85yK0hEwpHWmKUBVI4T8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QsxeWVGs+KYTOUEkspb59iQwhUOSBK2FJX4t7WZhE3xlXkV2tPSSGG81hQg9f7bkV
	 SwSjUOfneP/7rcLzcidgl/1JltBikccpwF1OOtQFYWtq3YnlTTYd0oVNZxqBIn2Kvd
	 LxgPlDMXTqob7xiuqgZcDszFA+gs/M7q4omjZsQW7kSInuBePN+8R6NyqgpIho0fct
	 M43xAqjg2+bvEs2UiN1dJqvzAPRITyY0Z1F5LqWj8YsPhupHQpbyjY6hE145zpqcbC
	 NB8bwYvKoLGZviwk1QW64CgTjhHFPMFn/ZHZUmi4s+4g0zsDntpmAcl3hs+VXcupW5
	 wFOGJL2Ej1krQ==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f2b8cf037so326289385a.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:26:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBySYb6S6f3n7oaBbYS0901Cmg2HliLt+cM76UBj1T4NEOBD1fHSpSNbJtGGNujfUjlhCdsEosGW2A==@kvack.org
X-Gm-Message-State: APuU4Z+2P837Ha8YyhEdbD4FLCYTimqmJS/PRKrIQFoEdHOw/lWFzYrP
	PWINXHkezM9x4dRa1VXb4JfUETUFZzrDIztoNJY3BZxVVgEcthtOaoZfzYYUmigR/GqEmjXCFrL
	/WQjs0foqKIyLJwrF4IXUK5JrjEpUrF4=
X-Received: by 2002:a05:620a:880c:b0:93f:1936:b229 with SMTP id
 af79cd13be357-944217ee7a9mr1684444285a.77.1793687199176; Mon, 02 Nov 2026
 22:26:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103025610.3738894-1-ridong.chen@linux.dev> <20261103025610.3738894-7-ridong.chen@linux.dev>
In-Reply-To: <20261103025610.3738894-7-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 3 Nov 2026 14:26:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zLDFkp9vfK+PxyF21LV5rEnUqmUumgmMGuwRx8MzAfnA@mail.gmail.com>
X-Gm-Features: AclHuK8HVKdqMIREpv0PqEm0E3nZYzV_dWHIZArjnQaiOz33ddVcOx-caGz6_NQ
Message-ID: <CAGsJ_4zLDFkp9vfK+PxyF21LV5rEnUqmUumgmMGuwRx8MzAfnA@mail.gmail.com>
Subject: Re: [PATCH v6 6/7] mm/mglru: add lruvec_gen_size() helper
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3864820002
X-Stat-Signature: peuuxu5dneahon8h5bfo9y55xnrzagh7
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793687202-598008
X-HE-Meta: U2FsdGVkX191Ck598eQP8Pvw4Yc+ZaCOhUgcf85G/FALwG9Oawh3BwY0PUe1+WETQPNk+Ez52n819g5yTuSfceTlDUDjKO1fZtCaczH39Cd+TkZEaVUuFxOcPKPVKQhAG/mxOLXl7RwP0CfVxbn4smUEEf2OVqrWEOjOrLDvmNWXpSLUmp1dY/p8FAESa/cvrG+WBLv948RvVPN+5pxYdTnHPXoUhI/77DcvN9ETVgdAwc29En21kS4Yf5JB9QHA+4XJB53W/x/BH1aDD/XBiJQDNjuk0KqC1lg4uPr/IKCTc6EjcCjhPTiUbN16c/TBWDYcYTzuQ5LCeD7BlEhzogs8C95445x8zKzpRYnf83NnDwM/GA8iTqge7QY7nuE5AVxvVBktFt+B4I4RgLqWEM9TSXNwHK359NOtEnVa+LTIGM1NiglCLLYDj0uFMbW+JeHkng+/qbTv+OpBI01MkZuzJpekUt11hqHEVEoFWl5PmFhWmEjpibDwLQQpSZW/v3H/GGavQ59GtT8TgWZESRoh+v3Wanw52adt0gnHhWRcFWZPrSM1jlDybQLgpkx640sbAXcHZwcSOKQx/Qq/Z3WEQ/jeg+Xlq6QQDKoLtpdMM/lE9l5L1iU6ElV3KxIv5Jc2Uw96YC6wb+upesRYuJGA7R68+H1aYipKqA1No6cl5NBmwOBLASBDm/cWSADF1C7/Tgp3j6SQ6PhRMzqnyp/T8mhdcrrXOAlBAxDgC3z+ikCQOZEqxY3xaninQRX0Xsb7eBDq4oleg1GXZPDQqxoST7GM8YCIYXk/RSLPXmMNyIPgjD5zGuffmUd91Km+UdWPvNdcox5NsMJ7s/zz9MhJLrDLNO+KfBSQr6FuQ576mw+LxKC/0DQ/agX9rx8Ai63M73PmVm04kC3Fe4ZMq8jZY8AMT2gUgyUEJ93BTJZkQjx4nvwba1oFd4Gnnl3uSHw8v2nTokX+Jt3NeWX
 e7RVIfO2
 hlzVV+VUTl9COn9jOxSJ2tFz660syPtec9QLL4aS+0PEo+5OIjHRnjdPz5suQyWm9NlgzBuI4ES7JMdBmFhukdzTDyUIJslR1bxcGUFsl9NvryDVZvDdY46bBaCMbbDen9iejforgl3IwdmlVksRt1Cz5K5Y51Mhixcgrj47hunPYHtfjosvSQawu/kjQHP3f5rNoZRYW3BqInyiWsA5acjf7dboljJAOPvd+1eVFo3Gxlx9Lb8sZSbKxxDrj0M0oSZ8SUU8HI2Vm+IlS9OjO51I3XwHKfNb9Cr/vsVE03zlshuG6a/GjQlhE/leinuIOLJxKo6PYUYdAQCY+iCdSHoWJqyXGUl4jJftGXbG5ACrK9LZD43M8UFw2ruiez/w2Em6v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 10:57=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The number of pages of a given type in a generation is computed by
> summing lrugen->nr_pages[gen][type][] over all zones and clamping each
> per-zone counter to >=3D 0, since the counters are updated locklessly and
> can transiently go negative. This loop is open-coded in
> lruvec_evictable_size() and in the debugfs lru_gen output.
>
> Add lruvec_gen_size() to compute it from a seq, and convert both users.
> Put it in mm/vmscan.h so that the vmscan tracepoints, which include that
> header, can use it as well.
> An upcoming tracepoint and the MGLRU swappiness rework will also use it.
>
> No functional change.
>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

