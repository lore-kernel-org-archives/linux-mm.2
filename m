Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519E3606A31B
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 22:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DcwlgpnI
Received: by kanga.kvack.org (Postfix)
	id 530916B05B0; Sat, 24 Oct 2026 18:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506A86B05B1; Sat, 24 Oct 2026 18:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C926B05B5; Sat, 24 Oct 2026 18:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BBCC6B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:24:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD8CF4046F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:24:20 +0000 (UTC)
X-FDA: 85358949480.03.F5F6F43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C08881C0007
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:24:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DcwlgpnI;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792880658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZO95lvl9Nqr2fnKfjhNvY3odHppkPAvE0sy9YV0MAyE=;
	b=PBLkaxneBJEJC8Kw9qNIY1y5ta5gt6MoadCial8oU0d5HuKmXcVe0HJvE5O02agKYVT5S3
	iYxmU4JXAPFJabM791Ni7cEBI5UXZRwEzOzcRS3iho/PRaJnUTK3p2PkhswF39L1uyBwDN
	tyDZzAHS81Icw8LvUUkfODODMY8qSso=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DcwlgpnI;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792880658;
	b=W9WWirTETSv2jrOJnrXAYA5G55+sX2Z/TCrveqOIdEqpKfxgf92iepmK3/+JZ4jmwFk5Yb
	NLe7Y+DPyeSCQErrUKgysnntuwNAX7Rs2lgN59x7HjyB6XtZcVOrfI4zVCAwP6wLugEncM
	1RUBwr6vZc2Jmf4tzqE2DWItCxHCMBY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBE3A4429B
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33B71F031E6
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792880657;
	bh=ZO95lvl9Nqr2fnKfjhNvY3odHppkPAvE0sy9YV0MAyE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DcwlgpnI8DL+2mapwB28c0Uuo/uZkOQbIkpHc/v1SllyC8AnQiHsey8hJ4aUWdbT4
	 prMadH1kOhGswoIzNgX1P+u7U3KoTwqUBcWHh2XYWZ5bxDbPXCFaxmk+P2urzWr1Rm
	 tN/5ED+hsmoVE+0QG0XA0UDNI4BCf1ZefiXFb5Qd5/jU4/xxPiEDB4jLllmx0hbm3K
	 EN3bqey/NcRl3d0IV+S3TGGgleI5BqCIn+v74y01Z2wbeUWXGv7IvSemJyMiXrTytO
	 jmFrvEKOiSx/o2gKOwmTm2S066vyIZyZSIob0mQDj8qkp6Et+Vy3xhiiFLqwSXFeD6
	 V70By5SJLar2w==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f2049ea7aso122656885a.2
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:24:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxa4ONtLzRNYvsq+6WiO4u1Hrc6KYsohh+hwnbNT5S5Kn+NgOWWw0xV4DHh4uay+FTnU0c6d+UBwg==@kvack.org
X-Gm-Message-State: AFq9FYJC2SYsTVTHu7ZIxLo5KNGg7d1AVJP4TFXQDjE4SvS+A3bmkVrK
	TnA8B6ZtYWdUBOYNgCCqJwdIR3JStH+1ZRP7qy+psq15ERY1NqnAYQ/zIxakKi06okSP2KhTPJl
	B/VMBQjGd57GAl/3TW4eofT0lvEjG6n0=
X-Received: by 2002:a05:620a:2616:b0:93e:c06a:7313 with SMTP id
 af79cd13be357-940ef914186mr385330485a.13.1792880657009; Sat, 24 Oct 2026
 15:24:17 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019034426.2354049-1-ridong.chen@linux.dev> <20261019042308.2372396-2-ridong.chen@linux.dev>
In-Reply-To: <20261019042308.2372396-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 25 Oct 2026 06:24:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z7u_PtSkjm+kH7JX_ZZDLSnGr1teHq6By0ovgB23O8_w@mail.gmail.com>
X-Gm-Features: AclHuK9i0KBXAHQuNAppLi1kJlXPAo77Un_nGJoXjbM4tmAAAAcT3v5pEG65SEY
Message-ID: <CAGsJ_4z7u_PtSkjm+kH7JX_ZZDLSnGr1teHq6By0ovgB23O8_w@mail.gmail.com>
Subject: Re: [PATCH v4 7/9] mm/vmscan: pass scan_control to mm_vmscan_balance_pgdat_end
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
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C08881C0007
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wtqjr3m71w7nj8gqhqigxaoddasbauw8
X-HE-Tag: 1792880658-967029
X-HE-Meta: U2FsdGVkX185NuK0BM+blGDCYb7tykTkIFA/b/S3fAe7zOTH5a/wSxgVW7K/33vrrKn14rwhvK484rsk16+ts6QLAo/u06/4KiQ4QWT2oUeVNMyPojL7McUbDtu7MeAUrBwPEtflNPYL6GURhYikwm39Tw6dijvVwA9UleTxbL3hWwY37PRqDztywmNtsVoN4QCZrscui21UbGAFKTzbxRUVPTaysZl2Ekzx3EW/lLiq2fdGg9RhTlRSdAE79TZ1BmOgyoK+bKS4ae8d+LsRajuht65DDKrREO6iHO26vCFTj48t2kr+g1y34FsqycmnHCSLtYF6cxGoqbzOtexYVfysaeL9x0p5Y+qmjOZArV9VvelMCEMkknL1dWQe1BvvNC94hrc6om1aSXVCNkMFnz6bfX2bECSFwdOubUNYp+TpsvLQf9KmN9rjShtPhLgkj3lHnfUZPxp0eDd/K9LHx4NOUSEclvHJ/+Z5gyQqc7cfxGpkkAl8D23mgkp97vJUGaX6gGuQAkAIr7w/wQAOdcqXAIqd2EcIYTimxf7ZEbjqAAgnPH+v26HSplhp+dzrf4AXyWKs2znd2NTOrFmPW47pIfgySkKjEwA5LN8KiUvecUaHZWZ7uS3k0a1jcYqFyoGuT/ilIGInlVeK3xwgqZ1v1GN84kml74MOjIF29IejApfvSXvrrDxmcO0jfFAJMsCu2zW2AdF5+bq8f2uI2dxXPcs78TTD0Cj9GVomVI/4DeVkH5ZenJeuCnPcmuR5/7CLqx6aRKXWzlh/WvIfxe1PE05mSl/t0rKnZHVYXKWlPYUw3gIKMen7Yi42GHZM7feM99f2B/YZfE3M0KQFXikfGlcTVc92557S2QviJ+71m7oin0Mm++AJo9A8vVZcxoSz/iDvrMhSmTWDLFaAXzbnN/pp3jOpcFBqD9pdcpUyTAWfG3zFonVTUZhixEvm5Qi9vIgmuMKEpm/U9t3
 M70oQJep
 URAtBsR/4IBQuptLtdYW+aYstFgo16oNxMnMuE8fCFh7HIwKKR+Oy2lYwaamLhTNJsIdHd1LKmBoG8cYzK2dJmnqtuZW692jcmMx3+/25aIta85riJ1uXog3b7qiBa/iZYIJI3N0ZxWrxONa5Mixuq8kVJ6iorU1SKeGJnq2NSJSHgQIWxKQH/LXDIY70probsJwr1Zn5Ph+6hy4qfmIk3/+0bsLI/XHic6+Sz7GMry/0s2IILs+4MxhIlm+rB9yqWWavbDkL5rYiM5Umw+0IJqb4A1V/L2HlPPysdjoNAIghHATu6pCsCObMaXEub7xHppdXFDyFevpAuRvir2XE6LDsLwx11DSFO6to
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 12:24=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> balance_pgdat() passes sc.order and sc.nr_reclaimed to
> mm_vmscan_balance_pgdat_end as bare arguments. Pass the enclosing
> struct scan_control instead and read the fields out in TP_fast_assign,
> consistent with the other reclaim tracepoints. highest_zoneidx stays a
> separate argument: it is a balance_pgdat() parameter, and
> sc.reclaim_idx may differ from it by the time the end event fires.
>
> No functional change. The tracefs event format (TP_STRUCT__entry and
> TP_printk) is unchanged, so tracefs-based consumers are unaffected.
> BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
> to be adjusted; tracepoints are not a stable ABI (see
> Documentation/bpf/bpf_design_QA.rst).
>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Could we combine patches 4=E2=80=937 into a single patch? The changes
seem a bit too scattered across separate patches.

Best Regards
Barry

