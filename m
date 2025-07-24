Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E68DC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5FFB8E00CA; Thu, 24 Jul 2025 19:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9CB8E007C; Thu, 24 Jul 2025 19:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8CB8E00CA; Thu, 24 Jul 2025 19:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BAD08E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:38:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0734C057B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:38:05 +0000 (UTC)
X-FDA: 83700773730.04.24F8118
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf27.hostedemail.com (Postfix) with ESMTP id 584A240005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:38:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRIW9KGH;
	spf=pass (imf27.hostedemail.com: domain of kees@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20zNdnhVMEE4ppbNQP0Y2okYSRQIntQ886en1roRbdA=;
	b=AaWogXboWiZ12H68y69VynqOXFp+HDd/eBNbtkqyqxKI30OYpzJlX9gDBIpjpDM3+lXwUe
	5W1D48KmnNPXd7AEu4603X++wc5/5C7cxZjSGb51wgmSwkrXxPeVLK/HLN2eKFrWFrj/T/
	+GX3HEKPwJ83v+g5NSeB1UQnxVeGUqk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400284; a=rsa-sha256;
	cv=none;
	b=I7m43kU87JWwQPQ+yI5EHmtPiJ9TgZpmu3wcGuSCDOuHuybFQSZHp9RiwFMIV0cldy7LU4
	W7gGEkYAjB88cthiiOrXtknA6DoHZ1HbxOlGRCg6ApMULVy6MRztQxO5KAZbsxN+SPvG7c
	V3sq9FYquRDPbcazhnW5eYlk4rxVlF4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRIW9KGH;
	spf=pass (imf27.hostedemail.com: domain of kees@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 37B955C67B9;
	Thu, 24 Jul 2025 23:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB12C4CEED;
	Thu, 24 Jul 2025 23:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753400282;
	bh=b5hCToxNeuwTg9pHwy7ASyHLcQ4WXMdqVI9hwgI69ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lRIW9KGHcqL0Fmk+5ttu/lxjwJbU/eFI84L7Hj2MdW1ul6fOEUBmOnNycwc827Q4i
	 LJEsZJ4GrO/oavqNwFPm9QRw9JUObG/+JjzR4v93D3Z/GX86s3koBwvt/aib1W/GAM
	 3RexJjMDXqALCzOv+OU2x4dAPCS7pO0Y31VMtBcJ6qNYaNPH6sRFA3Mnsp8YtAIEBs
	 z3FgN22qFgnMhUL3M9Kn9FiIpuoW6nQxO/phd+Q1+C0IteuDAAlQ0Y242fixPEdh1m
	 DqLjhm17PE65XTYxL6aNBrQ0qbhAUzoCYsp2B2mMVvwDSjijsYmA9fI8vyAmTLKO38
	 kzpv0dDDyGK6w==
Date: Thu, 24 Jul 2025 16:38:02 -0700
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
Subject: Re: [PATCH v6 3/3] include: Set tsk->comm length to 64 bytes
Message-ID: <202507241634.C0346AC@keescook>
References: <20250724123612.206110-1-bhupesh@igalia.com>
 <20250724123612.206110-4-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724123612.206110-4-bhupesh@igalia.com>
X-Rspamd-Queue-Id: 584A240005
X-Stat-Signature: ia4gsf3po35rtfw5c4n9yksnji6rpedp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753400284-8869
X-HE-Meta: U2FsdGVkX19CBy7jBs17YX+PNksOsZcD7uzJ38iNnU+nGkI+Pnb1z5YNEIcZ6WDelwbojyZG5HvrNocB71hzNpZj1eHx5PN3blKR3i2NR/qwB8bupvv9C+8slEsTFaSK3RKdRKJHlnCG0/sre9RFAt1ukHWVWJSYH9AEizwt9EE35XUsf4j8NNNuqratJbKhA8I97Gw1wfGpH1964WV/2yqvrX3vZrzsKldIPTFBoNClUBzu8x0xj9E/9IPFjt4uLQcHJN2sePqa6rcE6Y38eEXDDSvH6UT7JeBCOYxl2uJyrUHffS/Z7vsB8eEhJSJxUQBmkqBMZGUTz/g+ZDNTnsNhhHmD6bswa7JACFWOFhyyHVN6TcD6MxX0N4OUw5cwFmCT+7Hx06qAXDnMW0ExM5MoDoa17Y3rRhYBcmzU9NQup4EY2H9dWSUkmLGqPuQY7tzaViZmqzOJQffD84h5plWVQCSDkCfc8YXFzGgH5p+F6HM6hn778Uj4FpZDAAPkP9njnNd7vaZdGr1Kx1BuyHTjmbGz3uHgIQUApsnxLm+yFxBHk1hu+QzMiM4De4383TeTQ566GhVfYIas31EodEbak7My3GdZr17uBmbgvLG85Sz4g9A50Vw/KtsXMeQB1HFRwfDJgT7WlSpcQ/mAplGavTTXInKBXJK/3hLkTg0kgMA/j2smvF9gClRUGJiQmiCXOEhC1GMcvPCwMiGLHVx0ez+hpFz26/pZzLmah1mEsbRVVhbvUzHvjgPB60DcaqQkfS5QyqoctJJ8vfnmN8MzMdMamKZjgMIlsCd6ZAJMua4HWxTaoZsB1D4UiDpQcUcYcbkf8AzpLqLdNBrwrbE2FdYEA1GGsIKwb97MeImFNJJoWgfR5s8vh2msqjj4mj+c5mJ+KjbDdwbc/yrP+PX2ZW15igZDbKo4ZdBItZ30E4zlOqJ2f28zqHOSzFV0G76To72M5mf/bFBM/LJ
 eUSH+cBY
 jHkAUjceJ6dgsrF0SJzFOnHWnEqjcnuM1PfxVxkNU0DyN+294PrL/hIP9fr9wr370tmxvNAKworKzfCd4zcojVgxG1rwxv5ouyU+Q1B3Z/pnBHyprfSZp8Ez8PWM1liz5JSdfYGiTC07IYR+KltYKAekuNWMTp4VN8qtpeKgb+33QjnjbPdTOF3J+hZw3icRWYPLlUGv1Ouzo1qZwPkAyJ0M+/eOwqnGWCGmM28mJeUMpT+vZgA6tNH+cy1ZZ1F9Y+GZwl2hk6Uvm5Dtf+EymhOiPaH9Ml0GG/F0HHtN+m8Rnkv3+wWipIlRRRJZ1AX+Ffqt7JBOdotKu0GY5UtkQckg+gWXuzj9mqaSdc7/VrvmH+mRTqbjyMmm1FOBhLqgHesxSaBYv57iz6LEt51A7I0jcREII0bw1y4ga
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 06:06:12PM +0530, Bhupesh wrote:
> Historically due to the 16-byte length of TASK_COMM_LEN, the
> users of 'tsk->comm' are restricted to use a fixed-size target
> buffer also of TASK_COMM_LEN for 'memcpy()' like use-cases.
> 
> To fix the same, we now use a 64-byte TASK_COMM_EXT_LEN and
> set the comm element inside 'task_struct' to the same length:
>        struct task_struct {
> 	       .....
>                char    comm[TASK_COMM_EXT_LEN];
> 	       .....
>        };
> 
>        where TASK_COMM_EXT_LEN is 64-bytes.
> 
> Now, in order to maintain existing ABI, we ensure that:
> 
> - Existing users of 'get_task_comm'/ 'set_task_comm' will get 'tsk->comm'
>   truncated to a maximum of 'TASK_COMM_LEN' (16-bytes) to maintain ABI,
> - New / Modified users of 'get_task_comm'/ 'set_task_comm' will get
>  'tsk->comm' supported up to the maximum of 'TASK_COMM_EXT_LEN' (64-bytes).
> 
> Note, that the existing users have not been modified to migrate to
> 'TASK_COMM_EXT_LEN', in case they have hard-coded expectations of
> dealing with only a 'TASK_COMM_LEN' long 'tsk->comm'.
> 
> Signed-off-by: Bhupesh <bhupesh@igalia.com>
> ---
>  include/linux/sched.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8bbd03f1b978..b6abb759292c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -317,6 +317,7 @@ struct user_event_mm;
>   */
>  enum {
>  	TASK_COMM_LEN = 16,
> +	TASK_COMM_EXT_LEN = 64,
>  };
>  
>  extern void sched_tick(void);
> @@ -1159,7 +1160,7 @@ struct task_struct {
>  	 *   - logic inside set_task_comm() will ensure it is always NUL-terminated and
>  	 *     zero-padded
>  	 */
> -	char				comm[TASK_COMM_LEN];
> +	char				comm[TASK_COMM_EXT_LEN];
>  
>  	struct nameidata		*nameidata;
>  
> @@ -1954,7 +1955,7 @@ extern void kick_process(struct task_struct *tsk);
>  
>  extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
>  #define set_task_comm(tsk, from) ({			\
> -	BUILD_BUG_ON(sizeof(from) != TASK_COMM_LEN);	\
> +	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\
>  	__set_task_comm(tsk, from, false);		\
>  })
>  
> @@ -1974,6 +1975,10 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
>  #define get_task_comm(buf, tsk) ({			\
>  	BUILD_BUG_ON(sizeof(buf) < TASK_COMM_LEN);	\
>  	strscpy_pad(buf, (tsk)->comm);			\
> +	if ((sizeof(buf)) == TASK_COMM_LEN)		\
> +		buf[TASK_COMM_LEN - 1] = '\0';		\
> +	else						\
> +		buf[TASK_COMM_EXT_LEN - 1] = '\0';	\

strscpy_pad() will already make sure buf is NUL-terminated, so I don't
see why there is a need for explicit final byte termination? (And even
if we do need it, then it should just be buf[sizeof(buf) - 1] otherwise
using a buf that is < TASK_COMM_EXT_LEN but > TASK_COMM_LEN will have
a spurious NUL byte write beyond its buffer.)

-- 
Kees Cook

