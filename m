Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7E0606A33F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e1IltH/h
Received: by kanga.kvack.org (Postfix)
	id 338396B05B5; Wed,  4 Nov 2026 11:59:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3103C6B05B7; Wed,  4 Nov 2026 11:59:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B7B6B05BB; Wed,  4 Nov 2026 11:59:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E74836B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:59:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71C2CC06D0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:59:26 +0000 (UTC)
X-FDA: 85398047532.08.5A47023
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id DEBD41C0007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:59:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="e1IltH/h";
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ChK0INPk67gm1yU3y9ycjg3DavhKidCa/NOKnRXt3E=;
	b=1f96WHcY74P3YTBap0M4K3huIoyX6la3vhYUMyYGLauJKHrse6hqqcv/fzTUZSnIoImLjC
	5AHyPmCRg6Ytk4mJNp/piZoVkFaL8XDutH2KjqgnRHB6p7X1E9fy+0Qam99VHXTRtt0Ip1
	dOd4w74nszTYIwLo7TSLaQURTt85Wbs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793811564;
	b=ePoyGOom3sp0QkZgfZZWj3m+7vuDNpeE8UMmxzh4sDF5W9Aa6h/vAgq2JUwOJPlLCv2NDL
	7WNyrDwsg67XykG+vF1Rx8cDk2/6ffV3u6t3j1VmiQ/o1XGEzSJHtrZGCecWma69ckuT9C
	62Hr/myU33wgttpOChKtal80P0xKaYs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="e1IltH/h";
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5ED5B60609;
	Wed,  4 Nov 2026 16:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768EB1F000C1;
	Wed,  4 Nov 2026 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811564;
	bh=4ChK0INPk67gm1yU3y9ycjg3DavhKidCa/NOKnRXt3E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=e1IltH/hwj2W3cR9SklfIBuPpiVdyAm/FwepfN/AbRq+r8/IbUR3jqQcUVHkVJ80C
	 06+cz8P8GC+/B3dQEvITq/W+IOwGtPORC1nuZoa/6OKutaQGnsh83PiXBnA9hes95x
	 EPqBgYzbCWN4QjyuZGXgMfRbQEIim8rvmmPr5uktGj+13/5AvaJJHw4UbVjaULZ2tK
	 pCDl6L1xa5eInJrm6UBMG3QojaQTUDyGKuWXwm1yAFbOvEUusx9/f9j6sGLzm20Ogf
	 BAEVoJuBMkBD9xBLFsEL4PZKuRi8DEIrQC6f5DA4taC8fdjRcHOrNyLQw38Yjcy+9r
	 5OL6kcEsw/Fyg==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 10/10] selftests/liveupdate: Add a test for
 preserving tmpfs files
In-Reply-To: <20261103010216.3447716-11-dmatlack@google.com> (David Matlack's
	message of "Tue, 3 Nov 2026 01:02:16 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-11-dmatlack@google.com>
Date: Wed, 04 Nov 2026 17:59:19 +0100
Message-ID: <2vxz1p90jzx4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DEBD41C0007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 8ueexnfor5wtfjt61kntyapja9mtiwuo
X-Rspam-User: 
X-HE-Tag: 1793811564-925513
X-HE-Meta: U2FsdGVkX1/kd6OFfiDsGJ73C+RKg8HpLIN4v+nS7NjVz09XopleCH13U2EQBpSUnH4hNxGiRLqCJKX+q22f4ka/lgAyMwkmirgIRZC44WNUJSjq9ElD4ek7HSLfZhR4V+dUAZSY5TqOCmMfi1Z0Qac6ttnY7xnzkdqK14SA1OFD0WB2JhIDYmIB9lh1GXea27RnDgwEERrXDqXdimd5wddB2bvQ8g330fv/K0Z+wMzdUvJ0ddYVUwynMf9WhrN4MZmzQrjSTTePaHvLKspnprlTX96arRsXUBbKLAr/cIaJ+pYpLYHh9iPhMmrkf/mKcCQeL3uZZdf5GDElYgsWAHFlwRRC2Fc2qB73cSxlTamGeYnynp5Oht8ACSUbDdUJUH8krpbrb/5DUnmctEm3yEH0Oc3p+vld0j/ZgYB/sO9FHxAXbMiv/uYA+UC3bEHEXmhxb4epaQTwKmaABq1e4K7D5hJcVn31yL0ndlE7xMLI3T8qmKh6XBKCC9GyNBfnMFsAK37QDTLU+JMQR/GK1Da/8D+K+YJF48sZo0G5bu/F/mB2i1aAvwdH7AtkW56pINATgpKuKQjUNPvWYB2It3cn+eaW5t1Rv5wroEvc66AKGQLyXzS/IIw+6zJIBd3vwSGe+0SAw7DxMCQFn58Dd0JxuySh8soIz7l6ShvnHn5ma8X15mvYgt121bPkAx9tjrtDPLI620RMwtvyjcR7yKnQEjInu17AgmNu+VvC7GzcX2YCS/wvFKCoXI8O8pa3eQBJ9zy3ocNO4MkALFuRDDWCjMyLL+pRJj4opxCNkkEAp3ajngxNIBGsdiPAWq2ZrlMTwVehN2mDCJ8lgR4s7IPvTFoPMIpZ/HvbAHvrivJsKo71qq2rObTe1StWduDUem2kISEhOiP/zMGbKOamCPJFYaYVPrCF8E0I8psjY8BUgoCpG3yiS/xYqivcxOu/ejNQh9a5i7lNP4lCz9v
 JOX9C9kE
 2hQjog0SzjCUjnDr/o2QZqwg/x9C1A9XmhFi7ljUIOb1JzYRPkTbIdQj+ca2/4wrRpLEHW35+miRlYrbX5cA6WOjOUgYIjYVQbTQLAStIQ4I4KtraPrGCt2/YbUGcBMcg7ruoVGVt2ET/1TIgDp8DCigS5jm4Q3nSgewzxZG0KpdRXXScnlhENGsYp2T3LjlPYTT6mV1seB4ft61wSq0bJyTrI1Lt/kbMNnQFPOtO+wsy1dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03 2026, David Matlack wrote:

> Add luo_tmpfs, a kexec test for preserving tmpfs files and memfds, and
> for retrieving tmpfs files onto a tmpfs mount with struct
> liveupdate_shmem_retrieve_arg.
>
> Stage 1 preserves the source files of each test case. Stage 2 runs
> each test case in its own directory, with its own tmpfs mounts, so that
> block usage can be checked exactly with statfs() and st_blocks. The test
> cases cover:
>
>  - The restored file: contents, size, position, seals and holes, for
>    linked and unlinked source files.
>
>  - Creating the file: it is created like with open(O_TMPFILE), with the
>    requested mode minus the umask, owned by the caller, and not linked
>    until userspace links it, unless it asked for O_EXCL. Also O_RDONLY
>    and O_WRONLY files, other open() flags such as O_APPEND, O_NONBLOCK
>    and O_CLOEXEC, read-only mounts, and directories that the caller
>    can't write to.
>
>  - Preserving files that can't be written to: a binary while it is
>    executed, through a read-only fd, files on read-only mounts and
>    superblocks, and immutable files, including sparse ones, whose holes
>    are filled. Preserving someone else's file that the caller can't
>    write to fails, and so does preserving a file through a write-only
>    fd or an append-only file.
>
>  - Executing restored binaries: a restored binary can be executed
>    before the session is finished if it was retrieved with O_RDONLY, but
>    not if it was retrieved for writing, since LUO keeps the file open
>    until then. These test cases execute copies of the test binary.
>
>  - Block accounting: the file fits a mount of exactly its size, and a
>    large folio that extends past the end of the file is charged in full.
>    Running out of space, or hitting the memcg limit, fails permanently,
>    and leaves nothing charged to the mount or the memcg. The session can
>    still be finished.
>
>  - memfds: they are only retrieved as memfds, with their seals, and
>    files from tmpfs mounts only onto a tmpfs mount.
>
>  - Interactions with LUO: invalid arguments, which can be retried,
>    retrieving a token twice, and outgoing sessions.
>
> Also check that the size of a preserved file is frozen, and that the
> test doesn't trigger kernel warnings.
>
> Enable CONFIG_TRANSPARENT_HUGEPAGE for the large folio test cases,
> CONFIG_MEMCG for the memcg test case and CONFIG_TMPFS_XATTR for
> FS_IOC_SETFLAGS. Those test cases are skipped without them.
>
> tmpfs quotas are not tested, since the test runs as root, which is not
> subject to quota limits.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/liveupdate/Makefile   |    1 +
>  tools/testing/selftests/liveupdate/config     |    4 +
>  .../testing/selftests/liveupdate/luo_tmpfs.c  | 2055 +++++++++++++++++

Umm, no way I am reading all this...

LLMs are great at generating tests, and I'm not saying there is no value
in this. It is just that this massive code dump is unreviewable by
humans. It is also unfair to the human reviewer because it took many
orders of magnitude less effort to _write_ them with an LLM.

What do you all reckon we should do about this? Trust the LLM to get the
testing right? Do we give up human maintenance of tests entirely? Do we
do fault injection to test the tests themselves?

Or do we make the tests smaller and more human reviewable?

>  .../selftests/liveupdate/run-vmtests.sh       |    1 +
>  4 files changed, 2061 insertions(+)
>  create mode 100644 tools/testing/selftests/liveupdate/luo_tmpfs.c
>
[...]

-- 
Regards,
Pratyush Yadav

