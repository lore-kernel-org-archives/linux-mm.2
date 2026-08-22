Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84392C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 21:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598026B009F; Sat, 22 Aug 2026 17:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F966B00A0; Sat, 22 Aug 2026 17:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF5A6B00A1; Sat, 22 Aug 2026 17:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24A466B009F
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 17:47:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 926DC1A022F
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:47:43 +0000 (UTC)
X-FDA: 85130242806.04.583A122
Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F28880002
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:47:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=bpXu1Tiv;
	dmarc=pass (policy=reject) header.from=grrlz.net;
	spf=pass (imf30.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787435262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rsfi6VTa1cx4QP58MMZwnaeJqvXHCHt8CIYSlcjy8iw=;
	b=uVIyeF5aZsOlx5f0gfjd08+AYw4DW9BoAwtFeGLJArAp/88zeOlZvbD+jLtlvqTfK6BoDC
	krO1yFPFfrhjS5kkfHNEKqlayhd15Jz62M3CNRFDuvxJK0d2sWxE9bDnlxri2WXZiJpfx3
	HooYMMZ9i+Q/9H+MGN9MEZcPMox7vjw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=bpXu1Tiv;
	dmarc=pass (policy=reject) header.from=grrlz.net;
	spf=pass (imf30.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787435262;
	b=bbzWM+pd2mh0+cDLKsRlYcdZwbf7GweN541O3+HyplEolYd2T3YLRjJzn5hRz4yTh/8PZ2
	5HdQuqRt/EUIvHUivZ9sar4csittpeYmssZ0mkb+lwtArXNZUKU7V05qlD5bnzi98rnpED
	5Dmwe7/0aanSf4+vEbvMInlqzBu7FCU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1787435258;
	bh=Rsfi6VTa1cx4QP58MMZwnaeJqvXHCHt8CIYSlcjy8iw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=bpXu1TivueVgiuWxWyhE2TO/X4SN0GrzlrFLdJgepUqBXxwdA6bOyaMGU36gn4Ozh
	 vn1tyN99d2OQ957rhrm8hDPq/ja3DmGnCcW9nDHVl70yvbwwuXn6HfxfFTY6un1gqJ
	 IKeLeXfnPaoKJsm2GDZy3ovGu+tHS1cxNKODvvHk=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4hS9ky3nRkz6vKn;
	Sat, 22 Aug 2026 21:47:38 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4hS9kx67P9z4y6W;
	Sat, 22 Aug 2026 21:47:37 +0000 (UTC)
Date: Sat, 22 Aug 2026 22:47:36 +0100
From: Bradley Morgan <include@grrlz.net>
To: Steven Rostedt <rostedt@goodmis.org>,
 =?ISO-8859-1?Q?J=E9r=E9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
CC: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mgorman@suse.de, bsegall@google.com,
 dietmar.eggemann@arm.com, kees@kernel.org, kprateek.nayak@amd.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, vschneid@redhat.com,
 linux-trace-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3=5D_fork=3A_initialize_functi?=
 =?US-ASCII?Q?on_graph_state_before_copy=5Fexec=5Fstate=28=29?=
In-Reply-To: <20260822174053.26aa2f56@fedora>
References: <20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr> <4E2240F5-1211-47CE-AF04-24E1F0BC4707@grrlz.net> <20260822170928.1acba2cc@fedora> <603183e5d6abcae2229c61b8e266e60c@oss.cyber.gouv.fr> <20260822174053.26aa2f56@fedora>
Message-ID: <B701B25D-C39D-46FB-982B-5681B3D45CC6@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F28880002
X-Stat-Signature: u6qowbqampdt9kk5nzj945szcudyz7rb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787435261-455745
X-HE-Meta: U2FsdGVkX18uzsLoYAZPA4mtrMHcRibbK2Qs9wmeyj+ewsEtc7F2AJJgY9Bm0J7KSguXFB7SgBJKbvNGFZmsVlM96F1wWS++Lf84GzbT5WtBt2Arxbp5HNdY04SnsLp29EwQBLOMjpx8/wZ3R01bwF6if+/7+Nfba/59CzPhPe3ntEgDmSUszyICFkuUJKTvA6ClxbYNftlmtYJmeHDO1v6BJhFb4II67+YhHDp/boxYKbvbFXUqFJcO5JIhXi/JHNaGvG+V2thG8uER9vYYnPjcv3cyk2QdP3COHHWVnN/FihRGiaxD4P/EwuL8minnFItwX6uH6Io4YPq24e2d/uYlQm1YD7/BxN4PtuF+DFLSRyy1IeBs0mzHRmK1RNueQT0VPyWLv9IvGrcG5hIxNcAy60l7n2rrJR3I+XI6iuWhBrbMqOn1/QupMwNCRY1twJKwpAFr4g5nasOdQ63mRQRx7xWjctgKjZEPLmrCufb9LL2GJG5R5ckPGiOlW1KzGEPbzt3UMdChHiK1JkqbLk22rlRQBis2qiIqeLpRP3A6KCq4XAJoA58/RL8IbR7J46kEgOv5A/VSgF7PHgyyhVFxadbOGPMDygvFXHVaZRomR5UBtIG5qO+es074OKRdMto33hRdKSAtfbReNniMisj3PG/hsJtipsWVgFs8rgQ5SJMw/Dl3WgSD6H7zJefStP9Wl0VDbA4Lt9+rYRRHCWYbZwWot4kmVJCvN30xFa6bmIcrok23hiBXEr2w2L59JIC0PloyHjrZdD8x7tFncheNSk3CWeeTqivpzLUlLBp7d+oWaVydQJP70/zaRZd7tUiAgD9gfGz43ejLJdqRbWglQH4AZJXBb+Ni2yBAYDOqyZ348eF6tF3HnQNBaWlV+zDnppoMviD4/XgRoBPpB/5qN8qF6NXsqladOxLoqMS0h1yWbbmTlXrnGMBgeZEjnq9gU3lTHLy1NS6fIdi
 W5o0cz7n
 GpxiX/jmdcm0k/WTeS8M6c3TneAhQhDdahGKb5uizsbLOchFlPQTKU2zsn4V8pPuITBDRH//yvdYW+X2d6UNWxybGGAsQOMwBWGT8dm4TNFHOxFTlYNoJNv7vXw/cyiC/8bBoZr+bTTxILo6Xihif+3LSQwHrpFbkg+JAlbqzrV33wH6EyloYZYI2nYjxHsteYh8GqyPnRcaPViq2eb6LXqbXv9crUIf9m7nqEFHpnqE3LPFsNv/kosWo0QtOkR/ouc2h3E94Sat1tVzhIUzd7jVHCWqokaqNpkFkLmQlu+oCt0ig5ERzTDrIHbao7HW75Au40Jnx3oPVerG8tsjBqbFkAG5zPQOBJ73R+S0IJVRDTftgHxb4DmGFYn4djvfTycXk18xQsH471hU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 August 2026 22:40:53 BST, Steven Rostedt <rostedt@goodmis.org> wrote:
>On Sat, 22 Aug 2026 23:12:35 +0200
>Jérémy Jean <jeremy.jean@oss.cyber.gouv.fr> wrote:
>
>> Oops, I did not know that, sorry.
>> Do you want me to resend once more, or that's okay?
>
>No need. It's in patchwork and I'll manually add Bradley's R-B tag and
>start testing it.
>

Will you merge it to one of your very cool tree(s)? I've merged it to my
friends distro tree, not maintainer tree or anything, but I do tests, I
guess that's like future learning! ;d

>-- Steve
>

Thanks!

