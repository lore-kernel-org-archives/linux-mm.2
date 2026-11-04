Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D4A606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 03:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oU8AH/tk
Received: by kanga.kvack.org (Postfix)
	id 1A8DC6B00EF; Tue,  3 Nov 2026 22:39:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C256B05B1; Tue,  3 Nov 2026 22:39:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077696B05B2; Tue,  3 Nov 2026 22:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D64096B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:39:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6265A80564
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:39:05 +0000 (UTC)
X-FDA: 85396030650.17.2A83802
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5AABC0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:39:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oU8AH/tk";
	spf=pass (imf10.hostedemail.com: domain of mkp@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mkp@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793763543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MSatX/G/vVIWGJoAI0tPC6fx007E3Z2lu/4uprBFlM=;
	b=lEOg7yEP+kCy2+M8Ggj8nHN9ux1/WXPmdFKkpjP1UxN2QYWn8DXp7YEgB9HYAlpWa3Dq9z
	LFKwMpqVJX5A8DTrUPnUER2tqUaxnmTn0P36CAXL+3HgiuynNC1X/M38utFohKAufeXHHB
	o0KAmZ8E0obgrVOjthR52CE3TdmY3ag=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793763543;
	b=8nC3HNA2ceUV0ta/qcxQkrF9K9gzk21j4et3gn+7QzDpRPWCZSbZ8LHZPdiOfz18vcf2Wl
	NvMamGo7R8Zg5JGolWx8Mb2UyA91g7RK0ZUJVWElMbDYBB/7E5otIqITstYQ95d4Dz1k+S
	zJa3ET3N1LXAxwFj9rIo2BjTxx0zDy4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oU8AH/tk";
	spf=pass (imf10.hostedemail.com: domain of mkp@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mkp@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F6076022E;
	Wed,  4 Nov 2026 03:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FA41F00919;
	Wed,  4 Nov 2026 03:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793763543;
	bh=9MSatX/G/vVIWGJoAI0tPC6fx007E3Z2lu/4uprBFlM=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=oU8AH/tkWpzRwTF1kdq202zjvQncB0rfXyqulT4eyrNzEnIF4j48NgAbG2Caj1a7B
	 bMwPFiLxGpjgTtxKflKmS29xjpsYy+uoF/n935fbiBKeNusPTC1ePuFEOlPnPPcNEk
	 xFtpzO5elTJwY12Cy11QLYphesyVhHicZbo4/L/e91qX3dGksuyh8kvN9FyyrHgXAL
	 A2ZHgW8K1y0maVcVzKrTUm2MaPtPdCroAFRqGZ9P0+cop628w2faHu/6+eEMRMpwPc
	 3lqsGfgHjJTW8+Vc/3zNDrpsahxe/9gmvL+iS2SrdtAafA7cJAAJim7GFFQPdMePbb
	 CybKyOCyWeu4A==
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Viro
 <viro@zeniv.linux.org.uk>,  Thomas Gleixner <tglx@kernel.org>,  Peter
 Zijlstra <peterz@infradead.org>,  Kees Cook <kees@kernel.org>,  Arnd
 Bergmann <arnd@arndb.de>,  David Hildenbrand <david@kernel.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  "Liam R. Howlett" <liam@infradead.org>,
  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Sean Christopherson <seanjc@google.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Jim Mattson <jmattson@google.com>,  Jens Axboe
 <axboe@kernel.dk>,  Pavel Begunkov <asml.silence@gmail.com>,  "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>,  David Sterba <dsterba@suse.com>,  Chris Mason
 <mason@kernel.org>,  Alexei Starovoitov <ast@kernel.org>,  Daniel Borkmann
 <daniel@iogearbox.net>,  John Fastabend <john.fastabend@gmail.com>,  Josh
 Poimboeuf <jpoimboe@kernel.org>,  Steven Rostedt <rostedt@goodmis.org>,
  Masami Hiramatsu <mhiramat@kernel.org>,  Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>,  Ingo Molnar <mingo@redhat.com>,
  Arnaldo Carvalho de Melo <acme@kernel.org>,  Namhyung Kim
 <namhyung@kernel.org>,  linux-mm@kvack.org,
  linux-fsdevel@vger.kernel.org,  kvm@vger.kernel.org,
  io-uring@vger.kernel.org,  linux-scsi@vger.kernel.org,
  linux-btrfs@vger.kernel.org,  bpf@vger.kernel.org,
  linux-trace-kernel@vger.kernel.org,  linux-perf-users@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/10] scsi: bsg: Don't copy sense data to user
 memory when canceled
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261026215226.3713941-2-jthoughton@google.com>
Message-ID: <yq1fqxh1d15.fsf@mail.kernel.org>
References: <20261026215226.3713941-1-jthoughton@google.com>
	<20261026215226.3713941-2-jthoughton@google.com>
Date: Tue, 03 Nov 2026 22:39:01 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: t14fcaq7d8oizporu3wxuwdj8q4xsm9e
X-Rspamd-Queue-Id: D5AABC0002
X-Rspam-User: 
X-HE-Tag: 1793763543-919898
X-HE-Meta: U2FsdGVkX19tfU9rYP9knLSym9OsW2CU4s0PmMaNNHzm2DSdHFZhMW//Ea2+Q93DtTGzqqkuJMpvW7Pm6TNu4S7vlD1Dn4udnsuBW0QI9D0CSHiyhablxg1e1EksCydguIXThhxPVoBkyw7HK0U/tdWWn6rPTwUA4cr4hWr+lIYTiemRqarFsH9UunropMDMYyZTogksS6S7pPhxmtV71mT6mO/bCspR+R/4CVh9l4lZlEj+YAvo7I2gK//kXaTFYvuP0MhsT+SocXo7CZsLGBILY9v1NVyHwAMl2O87PiNcOMgwcN1NNyZHfHrWQmRGy/HZTK+0rwCtklID93mLZFqmTr+le4GSyB6WeVHv6nv2bnwNW/2aslWbcqDLxrcuPY118vxWwoSBmK1aR3lSpcHSwRWpsCiTezqnaXsHcLBsxchl8PI+IzomHNwift7Q7nT0zmCozezRZFJcmfMWhsjwrKhnQKgiqY2bE5Cgo2Jd13YCXqH48qlgJHHv+xcbo1nP3v9UfaZkxb7m43M7ENnf56jYA9hQV722jsUiBQn7eL8e6SKlAo4HH4evi3c7Z1+MXO9VEoD8JBMA5/p13Dek5J/M3pyIj+6+eRL7XRUNgg/fnBgcjcri75Geiq39wbE/TvX49EpRmIswflaRU97hhbIeamyG5gt14LhUlghLYunpxShSWJh6NngBgRUyQNW439Uo/4VGI65LGEdIf26SRBJtxOvWm2Q6QwZDc2mOkwGQF4iCyYy3GcSBtzRqxnd2H6SPlxNC6cQJL+i+ZYiYvnb3WeM1gMESbWDkDkL0dN+qN04H3tYCtz93cbGxv0ejEJPRgTxt2+n1WrWbgTNY8b2k9Cg4YyEFfKZ1yULop5X+HrsjOGMOB/+EaqQ72dcO2vZFDe4WZjE2lS50xZTCWWZo1tY1yOVZzX1FxghRYbwW5dWDpoUk6Aial6br/ouEzGrViu2fMlAa1GC
 43nj1gu8
 nLixak7mBJhJlSOCrAGQ7oGXhjKL0uz18jWkv5CSgh0tq+pMhTn6YZ1xz9HvUyI2nevlJL3NGfqb8Qt+JYUBqwHz+B/872oDyJEvh+DELGwnqKiEUdezq1Crz71idmRq6EwJL86M0+GUvkMthf923o1C5OjwbWcbY47pi2qMkrTNJuFdzd9wJzF2st/jcrGwlCsAQDrb/oXXpxQnxSBnHaGqTa5Gg9Wpj6e0ew+tK5pU66bPg0l2o6Tx3WYJVTSXoRVk4SsjMr/sxn5yjrnto3Vm6fN5dsdrGxZCZ1rAmMDgpkDErdQVnnRhVyyadmOTzvNf4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


James,

> scsi_bsg_uring_task_cb() copies the sense data to the submitter's
> response_addr with copy_to_user(). It runs as io_uring task work, but
> io_uring may also run it with tw.cancel set from other contexts when the
> submitting task can't run it: from a kworker when the submitting task
> has exited (io_tctx_fallback_work()), or from io_cancel_local_task_work()
> when a DEFER_TASKRUN ring is torn down.

Applied to 7.4/scsi-fixes, thanks!

-- 
Martin K. Petersen

