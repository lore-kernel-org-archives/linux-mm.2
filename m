Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00935C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3A08E00CC; Thu, 24 Jul 2025 19:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9632F8E007C; Thu, 24 Jul 2025 19:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8790C8E00CC; Thu, 24 Jul 2025 19:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 77AC08E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:49:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B4B3BA2E4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:49:46 +0000 (UTC)
X-FDA: 83700803172.01.3FED7E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7D2DB100007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:49:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TW17cz/E";
	spf=pass (imf05.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400984; a=rsa-sha256;
	cv=none;
	b=8gJaOpL06i+a8/mMG+YqxjjpIg5d0EQldu4vbRpkUXEZjFdWADT/uin5/YOslWF+7OSqJA
	9lqTL1Eauf0GvJfldrESgl5URkrQDawTgBCCUsoicljxb04Wiweh4sOYmFWAC7rXaP4mD7
	0zQqAcLIryJRCN96q879SGETLeOw9eg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TW17cz/E";
	spf=pass (imf05.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dAeNlc30cFfp8rYzswkX/S31DM2T5CCdjqAtX8h120g=;
	b=q0a8mHvfObUfy1SgxrWo8tSw9Es85UnPQo9Nc1n8vUeiXkuMbquMYIeAeaDAEl1sBUoM9m
	Po3rZcFvdqjQBi/h3LHILU1V66ibh29OtUN9QZSG9vARxUd5jtWPiy+xTNWb/I0oQu3K3z
	xtnAr9zT+rzDUJByMaTDmfZ3E5ZEdf4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B49D2601DA;
	Thu, 24 Jul 2025 23:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6103CC4CEED;
	Thu, 24 Jul 2025 23:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753400983;
	bh=yMwOVWXuZtxnuZSKywwnjOh8HTftfAM04cVJJa9ebcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TW17cz/EEZaZJmmAANQIcH721CVqiYs4LQJri53qVRx99HG1jZN0YeCm+1tRjrZ//
	 Js/j4lVsCcFwwUP0dpNXXlxianCp7nwBPxuD13aaNZcrqJrHOkNKo88vzUd0slfVr4
	 OBXRpHcT8p4UmBYpoWowl95Q3YE2D0bTrkeJ2BuBy8SM8wPSFkeQxJ1D8JcAFVYk7+
	 WSbj5pSUAsPPICBiMuAfcU/14xU79isfbnly6OiAMYgg7uBvBnidj5xY6FrzxAIgzh
	 z7fpjzt+CBzhIMAvNsmNP1tzvobW45LNqeGvkHyXv9OcMANdijzSMQAi4aw7aq8Uzz
	 dIDSeiovGZNSA==
Date: Thu, 24 Jul 2025 16:49:43 -0700
From: Kees Cook <kees@kernel.org>
To: Bhupesh <bhupesh@igalia.com>
Cc: akpm@linux-foundation.org, kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com,
	laoar.shao@gmail.com, pmladek@suse.com, rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
	david@redhat.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
	brauner@kernel.org, jack@suse.cz, mingo@redhat.com,
	juri.lelli@redhat.com, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, linux-trace-kernel@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [PATCH v6 2/3] treewide: Switch memcpy() users of 'task->comm'
 to a more safer implementation
Message-ID: <202507241640.572BF86C70@keescook>
References: <20250724123612.206110-1-bhupesh@igalia.com>
 <20250724123612.206110-3-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724123612.206110-3-bhupesh@igalia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7D2DB100007
X-Stat-Signature: 5xum3m3iy4pmg3nwsxstogzw1akx5zn7
X-HE-Tag: 1753400984-157063
X-HE-Meta: U2FsdGVkX18qKSzbQKgs9a54esnqyqz5VJTNPbiV7nZI7PtRBYBKQVy8Epp2JFHACJz5WY+5LgeakbR2Bdoutk1uR/MeL63715OKJjm4YOTIawyElBygtD7XvyZ1n8wwxVVdsK0dvDWwzI0Jv1H8WmKsP1Aqpww/b3fEFfVzd5Esi9tLGPC1ifrdLUG+A/y1TES+DymL8HpSTequ9sThRKRSKS6pzSpBrBnjG3nOUJqBMOIfzRqvzndfB5un/64z1KQAaDkFsYjlAQeI73kYHp26Ce2ykLPAgMWc0wgHyew8Ja8LCYzJB6k7nj/0pLwsdBwu+d98VLXARL2gEQXtOeIjylNltCH4W8/3jdDNGuOzQvtIKkbVTtUGq8K575FXoKr7Aem10R0N9A842GwARBGi/qXQmTz11j105NcnzgOqBf0wrW3a8AONw7IPvwYYSHZwd9xF/5DaoOrnTF5k6IsWBgCtUiKIjH+Hb1y4aBEdgiNLOJNSdYCI6SkpNI0tgDG+ltdxGDExTRW1jmHYC9lAWu55cM+oNexHvC+V/NaoluR3j+nZy42TEZzpeC4FsyGCk0jRhSMJ1mDXa/fKTSD8aUarGaxlZIrLbKX0gw7vkPDijrQUrH9JYkTrp35TUCvPv8wbxu7WRJenwGHJW3xfaOK8h3fyoaKothaTOyCOJoVAtea18mbIpxg0S2IwZzqPxlM/8Y9mtxn6RVpsrPGGvLb17rYssrqtedxgwP/aVoaOgQ5aZOSXaHWlPnf4hvQXYsHo+slLOD95278gsrcsppkszaNQxemoTOf0ZX176yNSNyWalciiI9lxVEKUAKA7jsV3KozYpy4Y//iKtEew3pKDzxy+deCNmLqdYqev4ygG2bTIWQbDwXz/KSp1B32E/GbmZ/OcfqH+SapqWBeHElUzjRVPCYmjkgGHrVm/K3VKEuDOHbTcMs1cP0lvRDnXGiiy2vHDJNld5d2
 CgO71v34
 uGtVck0yieymZjoGs+OJZTUCEMVXfmTQ4ZKXFzzsWtXCqfQGWHKXS0PTIKpEtjvb344H6EBvR3waKCibMsk8UAKGFdSlsI1yS8+grPBdiPlRmStO8/X90mAQ8ukG4MEjg0Ug5jIuTDpAU+YktxGf1Qbzfwa/Pud3hkD8OKiH7jAGwBOJRgYO+QHd+Lsw3yAZxGMJzKRgpoBx+ftgIcL/kMfdsItcn94Qw18FGgKftJcg7uQe8mTaPUGd0QgEbSCKk8iwE0Xz8mFgG39sjZabuFooBtsKB2ci1jIEk7AFo+zZVy114rbUdgTVskQ21aPyW5CAPVaorYks+lNf+5kezhgPPbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 06:06:11PM +0530, Bhupesh wrote:
> As Linus mentioned in [1], currently we have several memcpy() use-cases
> which use 'current->comm' to copy the task name over to local copies.
> For an example:
> 
>  ...
>  char comm[TASK_COMM_LEN];
>  memcpy(comm, current->comm, TASK_COMM_LEN);
>  ...
> 
> These should be modified so that we can later implement approaches
> to handle the task->comm's 16-byte length limitation (TASK_COMM_LEN)
> in a more modular way (follow-up patch does the same):
> 
>  ...
>  char comm[TASK_COMM_LEN];
>  memcpy(comm, current->comm, TASK_COMM_LEN);
>  comm[TASK_COMM_LEN - 1] = '\0';
>  ...

Why not switch all of these to get_task_comm()? It will correctly handle
the size check and NUL termination.

In an earlier thread[1], I pointed out that since __set_task_comm() always
keeps a final NUL byte, we're always safe to use strscpy(). (We want to
block over-reads and over-writes but don't care about garbled reads.)

In the new case of copying into a smaller buffer, strscpy() will always
handle writing the final NUL byte.

The only special cases I can think of would be non-fixed-sized
destination buffers, which get_task_comm() doesn't like since it can't
validate how to safely terminate the buffer. The example you give above
isn't that, though.

-Kees

[1] https://lore.kernel.org/all/202411301244.381F2B8D17@keescook/

-- 
Kees Cook

