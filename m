Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C2E5606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=PBPr4zWR
Received: by kanga.kvack.org (Postfix)
	id 36ED36B00EF; Sat, 31 Oct 2026 10:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31FD96B05B1; Sat, 31 Oct 2026 10:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DBC6B05B2; Sat, 31 Oct 2026 10:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02E2C6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:30:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BE1880964
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 14:30:19 +0000 (UTC)
X-FDA: 85383156558.20.E40FC4A
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4206840013
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 14:30:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793457017;
	b=qtTZKiONflVUiWLS7Um4oO4h+u1fvq7czzQMuDtgnGZjmpEWWmY/ERhKPCR9g+S18PW4hT
	ok4a8bWVbvVp3GRlGbdtcB3890p1FPvrJqv907AbNFlOFPftYCvkGruKBI9p8ooqAOVb+B
	kjqmFdsGHP+W2qkKm8kHMRt9gPLzWck=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793457017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1IHNH1tOqh0ElrkxzuEZgOPCPQw1/dqe7tff8NfeaM=;
	b=x+g9XJmwOaPQ0Uzjy91i1oGifSmCBZ/Nw9n1dBmBkecyiekHDvQwl+O1fO4w+saTZmcAPb
	oVJ9aev3mTemxiRWvqDPZiPNN6Z2fRF9oWNWWt/MeIPPMknRAd0+poUp8OAsaFGPPrJysI
	CxgQxdbQxWUFK62glgOwevtox0QK+XQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	none
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4935E14099B;
	Sat, 31 Oct 2026 14:30:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 0384720028;
	Sat, 31 Oct 2026 14:30:09 +0000 (UTC)
Date: Sat, 31 Oct 2026 10:30:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Christian Brauner <brauner@kernel.org>, Kees
 Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com, Linus Torvalds
 <torvalds@linux-foundation.org>, akpm@linux-foundation.org, Yafang Shao
 <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
 Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com, linux-mm@kvack.org, linux-api@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/6] treewide: Replace memcpy(..., current->comm)
 with copy_task_comm()
Message-ID: <20261031103008.6849760c@gandalf.local.home>
In-Reply-To: <20261030223435.0e802eb7@pumpkin>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
	<20261030-tonyk-long_name-v8-2-c9b030332254@igalia.com>
	<20261030223435.0e802eb7@pumpkin>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19PtJe/63eTC/xkaNfGiJ5uBmq6C/NDxGc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=L1IHNH1tOqh0ElrkxzuEZgOPCPQw1/dqe7tff8NfeaM=; b=PBPr4zWR7xVHQn7lESfrz+Z1k17LvdUKBJmd2JiZzRU1ujzKeO/PrCrGKGtiwiDF5DLaYsAiiQQNfvl8+m7MVwHesisvOoYWP38K5QcNZctHRcGRLZWBeIKzL3bXzxWQhtIeVG9ptEHsI1JSApLrFLUAEMfvHs1zMpQ/KilPFY4=
X-HE-Meta: U2FsdGVkX1+c070Bb41la7t5jN1BzuwNBvpfmTjGU4SkaREpJRXrGLs7S8FI42GHbjriLE/xEuJ5Auuyk4NWkxHcvVv1VEM3mLXOs5T70MxInifBc+GQ96BONclagQH1D+0PZuikD+2lnCVmIYMoxylnYzJSoASeydma1oSFAyF00NPjCIo+BnZjFzGTYnScxuLxJXwH5blA0wGD9LBWOl8fLRUkt/B5BlpfHgiFxsoIN0HSPEZ7vY1Z1BvuTrKEgD+gOECzIPifjoMyxeGTN1xLr7WXtvxc/17+8WTz0VMW2Z+EqFGGjL9uMHfno3NQpDvZMFP23xaBmE3P7h8wAEJ7XvVIyI3s
X-Rspamd-Queue-Id: 4206840013
X-Stat-Signature: i41crhwziuyr3iypubash458fx7ndnz1
X-Rspam-User:
X-HE-Tag-Orig: 1793457009-500293
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793457017-749118
X-HE-Meta: U2FsdGVkX1+21HmBN25Ji40n5w6kQhVke53ycjuWy1DeBSR4t1eRRyNNDfX6Qew1Qr8sOe6W273M/5ZLQSFriPLDy5ySkG137MUBCtHy+BnGpiR4LDxg6+e2uSON3r+8UdsWPKd3zh1GyTamUG29v+3WrI7mSCSeYUiB4dcLviXv/ZZHsE4MHDrkD6LeUZ4deu1AhdnNQvK7FYFj6fdqAsNG53pak8oOO4ynkC5bVP6DWkc56vrV3NMHBzJAu2DBzkG3Q8VBwFpUSzRjj+QunU2iISCEVXqOx2KMXoUKYena+DKo7PslSccmM3gvpx6JdrRrRfeDB/EMgkR7uS8/j6o4RJTJodqTkelDMHkokGNK7uZ4g2spVGkVxdRC3PyAPFADH+/A4/dIAbqJXjBBh8xYfMhugvcK9AwcV/r9BV9vLBb30hx5Zi1k1qZeZDmUO+NL6K1/cAfG+w03mdkvyKaPIvIiN93cQigtw0oj6Mrf9PzguhsT7PUk29q4hTscMiWoHqNwQAOk5D3t+w+cti8lkdFOJqFY0KkEGXG5+vp5b8hpgoTqoI0d+M7+HPVGAXK1NC5T2W0pVdkWWANBuDUCrDGZC7LFe/Yw1JBjpzWU7+qKuz1Vv7G5MIJTTgJt22rtZCdHXGCBMm0NPHJ9lDKRjL/WEYuLNMuaik+wM/9tw1WhXBBTgUznkoqyNYqZSfnQyMjkd5jhLryK4jOfL+KlbSeWCf/lxpuzNWXeqROBwgcdDaw/ZZmE1Fa0WLZunAariDTeh+3PTzoPhZPy2sv/dRX6SQ/x+fuzLWglTIXSTDI2oRhWjxe7hY44IeGe0jfbkhAGh2ML+m9+R1GZb2HcALDUuqEL/iJi6m7Xell2LGTYwhutSyomL1ybErtROAcrpp5Xl2lWyEHOXQhiykkaFvTi2bhXSUdz5VK6jRQ8AScl+cYheX0/IDraWOxEZukS6LF/ha0I+UAkwks
 pPMu/4/u
 1tJ6AkugPz2iZFszqWWeCeOaREZmHc8Lm9m6MOFkpFMQrkZcQkYDhA7QuVtTRYtsfFirsOuP1GA4FvW/pfBBJA7cpzk7jAtXN/2VCQj+YoofrcPURlZwYAF251qGlDkXyzCl9njFhsqDoTPl5wYZ+7JUV8eSWiskQ0lLS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 22:34:35 +0000
David Laight <david.laight.linux@gmail.com> wrote:

> I suspect the trace code would be faster it is just copied the (first)
> 16 characters and worried about whether it was terminated later on.
> It does far more 'saves' than trace reads and their performance is
> much more important.

I'm assuming that the compiler would optimize:

+/*
+ * Copy task name to a buffer. Final result is always a NUL-terminated string.
+ */
+static __always_inline void copy_task_comm(char *dst, struct task_struct *tsk, size_t len)
+{
+	const char *_src = tsk->comm;
+	size_t _len = min(len, TASK_COMM_LEN);
+
+	if (!_len)
+		return;
+
+	memcpy(dst, _src, _len);
+	dst[_len - 1] = '\0';
+}
+

to basically:

	memcpy(dst, src, _len);
	dst[_len - 1] = '\0';

Where it already figured out _len at build time. Adding a single write of
the nul byte without any branches would likely be a couple of cycles at
max. It's all hot cache (from the memcpy) and writing a immediate.

I'm not worried that one line will cause any measurable overhead to the
tracing.

-- Steve

