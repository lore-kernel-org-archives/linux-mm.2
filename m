Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC32C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 18:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42D976B0096; Fri,  4 Sep 2026 14:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE3C6B0098; Fri,  4 Sep 2026 14:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3E86B0099; Fri,  4 Sep 2026 14:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 065AC6B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:26:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 924DE160170
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:26:47 +0000 (UTC)
X-FDA: 85176910854.10.21741ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id DDEE81C0008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:26:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IzZk9N13;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788546406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOHPyrxGo1MSBUwKK8LJZJGpSrjxqZrlHYw4onj99co=;
	b=kWTszzxurRIzd4DlDd/YrdFWHZVftzxcjbGdweNNGfBHHAR96m1kYLrfgGjKBtImOpK0t9
	TBJ0dwYa0my+zni8rAiaaeyZiQzUjSeMq7MNCDlmCl12nXgX0I+vgOsFL4CK2/1Ed27wov
	X8K4IYx0Y9jaf4MCT9SVWUkRlYM472A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788546406;
	b=CsSaAqJ7fnu5V+EJ0CjBuxW15iN5cpQw61XB2TITkvbCOi1tNJa0J2yWQqRo+okAW3nV8a
	IDrtr2rceNJXRvLJBSKHHipjZycR9U2LB8robgn4oMrgRVlXJR1i1vZ++j27dntJAxZHFf
	4a1Yhw1Q/J5MVYp6SmwTiUcwRUzd+4Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IzZk9N13;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 44C4260209;
	Fri,  4 Sep 2026 18:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663401F00A3D;
	Fri,  4 Sep 2026 18:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788546405;
	bh=oOHPyrxGo1MSBUwKK8LJZJGpSrjxqZrlHYw4onj99co=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IzZk9N130M1AYqZLUIcnt1+xtyT9UazgRQmgcW1dCFY+Oy4NX97N/6boMXxgOTa5L
	 ykHX+tXGl/E0wn4BBf2ilsyKB/i71c0yWNjFngGN6ydwhULI5bMtfkIpsl3TmZmlFF
	 UI6bM3EgRe6+R9abWKirKpVpFRsJLH7io482Y8TE=
Date: Fri, 4 Sep 2026 11:26:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
 david@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 eddyz87@gmail.com, memxor@gmail.com, kpsingh@kernel.org,
 matt@bobrowski.net, song@kernel.org, utilityemal77@gmail.com,
 sun.jian.kdev@gmail.com
Subject: Re: [PATCH bpf-next v4 0/7] bpf: Add user memory access kfuncs for
 mm_struct
Message-Id: <20260904112643.73448e55f788fb1cdcdd12ef@linux-foundation.org>
In-Reply-To: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
References: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DDEE81C0008
X-Stat-Signature: 9kjtywna834886jrurdhum4hcsyc7mfx
X-HE-Tag: 1788546405-20773
X-HE-Meta: U2FsdGVkX18tRNx9Q+Vtfs7NK/k1I4N2eoYD9ZWKNT4DRhdRhTllL9YixS5eQwLe4VISiRQS+j61FMdcL1vg3rjcHr4NU9YPaMbHVvsMEasf1rn3L+0gdkz9edTBMKSRmHU6WTwaWPhAsO1sXnZX2QcEMdv6Kt/MihGxcHZFwgAnKSZN3u1W8xkgF6YXji9cb8gppHbcXRS0uNXUOeyP5N/r1G/FdaA6NUqRuj4L2FIJ6+kFikDlaMzp9rLDSmIh8R/M8xKasww6jy54JeZjmtaxBjBGmjbme318CCddOhIQxSdZZdYxBbehX1wEC1mDtD0jXnW3DJQhmiS5UwJ3f3kuviDWRBNGwtklVeRI5m6p162KMNVHJYEOzU9IkUWCQToe1mZ5RDgT2zFyzIKgpmzIAO9Vxx1vgz7CvRYEx/X/Q0BGCZKe9j0Fl2rr7KVQ/f+Ze/HORYe/qbJ1sdEfjiL1VHRW3rumuU30m6qfIOizqwiV2QiHjnAvuNRuB4lGs6fo0JbXnJ+cbXK0pTIICA1cSYONcSllE4xt1V7ksx3FWSEnfHsR83B1M74iDrFnHr/vTt1TER9s/3JKEj+E5fwE6gHMbRiP6GyR8lKak0C21HU28a1YAXpSyvH+wGqGKXSXr3qOnO2ZyZ01SDZny+qdGqSaUO1wTCZnb7j0j6QqFw6dHKrpx84t7nz28ypkPXojLfqLBOAT7Ro+FywdUyQ9U1MtwfCwcRCWcS6uNqvvMFflMV9GfCpk6YIiwRksKY/qisRSjxyrmvtAlvkkhbH/Yfic0zGxdXVyLtcl8dGaCmhplMvRPVRcPqRo06HhrFe6PSGZKE9Dgky/HgM8gl2HOlwLUQfCDiJ1r+z+MlLD533Q0qLJVvSfpPqoLQWrX/4yBURLBYy847s3CDbZedzBXSdPVOahEjRVEhehMSDcxNsjW53oigkx0K9h7N+tQy4QWv0d5YMFXlCZmmc
 EXf404Y5
 B+zZE9th415IQGdJoZAjt3NAAyed2kGBYVxIMmJE+fe1JLJgo5s0veHGjip7Or0j4FvVMoPWAD5tXJ0+SoKRLJOnwb9QxEk/s/sZnv/oDzXHDxoNbmF/PvJKGoRgO8Plsx03MO+LxsZDGh4PTpiaRTx9TsqvbUIg7qb3ASHUQ95MzOIw0xfu4hZJsMBvOuGY44PeCqq26KjT3BIm0SgzKtN/L3h+BPfsIBNWPzRVTDdhg4xS5B0dm6dLqhZGyhzdcK+OInLIpNzg66SzlW+lujseUsfs38bC5slaugO97SQXZyspphtP1JkY0yxnm6Drfdb5HpR3eYVWLi7FJn7LCSrODICDKBRctUwaqq9IhKc2Lg4Pi0JIYwzBi4malWsvaT44IVOV3g/VKnDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 17:53:33 +0300 Anastasios Papagiannis <tasos.papagiannnis@gmail.com> wrote:

> On MMU systems, during exec, argument and environment strings are copied
> into the new address space held by struct linux_binprm before that address
> space is installed on the task_struct. Existing BPF user memory helpers
> operate on the current address space or one associated with a task_struct.
> Because no task_struct refers to the new address space at this point,
> programs cannot access these strings from the bprm_check_security LSM
> hook.
> 
> This series adds two sleepable BPF kfuncs for copying bytes or
> NUL-terminated strings from a trusted struct mm_struct. It also marks
> linux_binprm->mm as trusted-or-null, allowing BPF LSM programs to pass it
> to the kfuncs after a NULL check and inspect exec arguments before
> allowing the exec to continue.

Why didn't I get the usual bpfbot review emails for this series?  Is
this a sign that all was clear?

> Changing bprm->mm to trusted-or-null would otherwise reject existing BPF
> programs that read through it without a NULL check. Preserve that behavior
> by allowing fault-protected reads through trusted-or-null BTF pointers.
> Pointer arithmetic, writes, atomic RMW operations, BPF_LOAD_ACQ accesses,
> and passing the pointer to a kfunc that requires a non-NULL trusted
> argument continue to require an explicit NULL check.
> 
> On NOMMU systems, exec argument and environment strings remain in
> bprm->page[] until they are transferred to the new process stack. They
> cannot be accessed through bprm->mm at the bprm_check_security hook.
> The new kfuncs remain available on NOMMU for address ranges represented
> by a supplied struct mm_struct.

I'm surprised that bpf even attempts to support NOMMU.  I expect the
user/tester population is zero.  Perhaps just disallow this, if it
saves any effort.



