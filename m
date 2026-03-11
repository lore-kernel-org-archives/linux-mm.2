Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2025FD88D3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 00:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15296B0088; Tue, 10 Mar 2026 20:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2BF6B0089; Tue, 10 Mar 2026 20:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC216B008A; Tue, 10 Mar 2026 20:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A93356B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:02:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55B158B441
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:02:14 +0000 (UTC)
X-FDA: 84531829788.23.70503BE
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf04.hostedemail.com (Postfix) with ESMTP id 879DA40007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:02:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773187332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=edd6vuu24+x3xfdeQnQc3m+ptFgMAuq1lyXlt7zXBpQ=;
	b=MAPgmiS90pUYSO64PVHqWI4I+mGrTPqzCcnw6bZgyij9b2fA/JjoYSb2GItJZg1X+3mSk+
	3f+67oxWiffBNFh7AxkV7kWZv8Q1qURP2FSeZnMQo/Bp1ik6OhYum05MmXKRbmH0qq3yI/
	bsDBa5gmaCzDwrkHCj9eJixNDYkRYTc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773187332; a=rsa-sha256;
	cv=none;
	b=SHdW8ZB9MHwBrUxd81VbZtjod5YsscmxKybo5wV0AO9XP6Nz/JIj6ZQABNWAWP6z/xkpOI
	yRZxiecjKLHvTZHNw/9KlAFxwANTw5B98WRPfCMyAGSM66V/etO4m05HE3E1RkogCo6hZk
	6d+PXVbgYDgn9i5sQ2yyeljo3d6f8DI=
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BCB113A961;
	Wed, 11 Mar 2026 00:02:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 85BFC20027;
	Wed, 11 Mar 2026 00:02:06 +0000 (UTC)
Date: Tue, 10 Mar 2026 20:02:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-nfs@vger.kernel.org, bpf@vger.kernel.org, kunit-dev@googlegroups.com,
 linux-doc@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 netfs@lists.linux.dev, io-uring@vger.kernel.org, audit@vger.kernel.org,
 rcu@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, Christian Loehle
 <christian.loehle@arm.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] tree-wide: rename do_exit() to task_exit()
Message-ID: <20260310200217.451cf37e@gandalf.local.home>
In-Reply-To: <20260310-work-kernel-exit-v2-2-30711759d87b@kernel.org>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
	<20260310-work-kernel-exit-v2-2-30711759d87b@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18LHCHZ+vV3JFPf+Z89JvS/nvAKMsv+FAI=
X-HE-Meta: U2FsdGVkX1/3tMWPLwyG4JCc4wkqvh9SiSPSlhJp6Tv4W/fwSwUFhWXG3UBrBxSzLq3p72eu37Xu4WWh77aTVVkk97xFw9hCg2Tn+gfwvdW114asIqtfy8xHhNrVuERS2G/65ce3/BsvZjC5d8Vnvs35vga+tnTJklfjQ+UttgL5bwbjp5oOgQNdAzx3oibQ4Mzt0N8V0YHeM+nhQRgwSGhlB1291Y2eHefZmXFBYTpQLIIP1XDBd9pac8iHtBZirKQZfE9I0NK+xzIHdGI0aui4vMm56FkppnHJDf/mUfgi8cC8UEAJB61JKAsSDfwj7R599Re8N4CNbTJgYcDwKo1gfVDZt4y9
X-Rspam-User: 
X-HE-Tag-Orig: 1773187326-98008
X-Rspamd-Queue-Id: 879DA40007
X-Rspamd-Server: rspam08
X-Stat-Signature: 5bg3rrg18jbru7uwkfxn1hbh397psca6
X-HE-Tag: 1773187332-577390
X-HE-Meta: U2FsdGVkX1+xfLfbHcqvpwoX4ZuT0RHbPvm8Fkfz61X3hquSzV7kYcDvjB4n/ngprXUMbEUg8Gbr6QaAdfYmGrLE5mB5r83JESDQA/aSxMUAU6mqP153pK0G+0a4T6NJ1nbpnwZ7j7f26wkdE1TIxwJ9rPyYmewyZq6e1b04kDJpQdf1q3RQ/v4iaQuS2slbiRNtl7+tgrqjKiSqTwEQWkng+bl31nj0qKmlKzvDH/7TqwEjeSicElg+cw0kEDvGR6p6mPvZlkzhFuPaUDg/bjMxTYCT6rjlfhss1mXNurXjsf8Yq7oI+wZ0HzeJKnJv4wqiVA8ExYnY5eB9tFRW26WtIfsYzGIe15Bw2lEam8ZEwjhBoZpGQX8WoaM5Mt1ZYKOHNIXCWTae/72MqDY6o1CP8PQaTFDtdEtWv2smrR3ZzPyTV3FUeNZSau2e/mNaB7H+qi8Fzt1BaUlRWn5qNJ2W7ZuoKdJ7ChO0ORewJSmjrrZkpng+BQM3xMF1B00h+Sjgrn1ozU4HXC55HGD3qfg8axcAbCZX3HxOMDv07/4y/sfFTTB2roXqQpfjLTM9O+2N4W3g/H4bUEAX7sYIVULacf+QtbXBIKraQfKNsTOeLM4ld/r9IWpuIemT2wc9aebFgNaOVRaINMGDMyseTVhKqBaMPUGGkxpuPI0fk1KGg1FY01AkC4Ugvz1TSjZvipz7i7ISuopzu652tc1hcUcea3oPOlX3KZmt1fUXooLuGfSg0hc2KjJgMX8/glhN2ILgQWnyUCuSO+ZQQGzcEoCJW73Sdj0wOXQHV6EB+Ckuf2UUJLzNSFJQ3sSJB4kP2PhaHhmvAAB2SNCBgCLBmNjYCf4Z8Y9TgavPslngg92pjLEg+g3Gvfa5b4Z0/Kga2eslVykuS8KShkidqIBU0eNUHxqk3cSdAuTcvZPHrt5ERulnR5eRfTakqEI8/nUjQjrOsgZdWTv1znh7Ej3
 PP7K7B9D
 PAOHB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 15:56:10 +0100
Christian Brauner <brauner@kernel.org> wrote:

> diff --git a/tools/testing/selftests/bpf/progs/tracing_failure.c b/tools/testing/selftests/bpf/progs/tracing_failure.c
> index 65e485c4468c..5144f4cc5787 100644
> --- a/tools/testing/selftests/bpf/progs/tracing_failure.c
> +++ b/tools/testing/selftests/bpf/progs/tracing_failure.c
> @@ -25,7 +25,7 @@ int BPF_PROG(tracing_deny)
>  	return 0;
>  }
>  
> -SEC("?fexit/do_exit")
> +SEC("?fexit/task_exit")
>  int BPF_PROG(fexit_noreturns)
>  {
>  	return 0;
> diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
> index fee479295e2f..7e00d8ecd110 100644
> --- a/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
> +++ b/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
> @@ -82,7 +82,7 @@ check_error 'f vfs_read arg1=^'			# NO_ARG_BODY
>  # multiprobe errors
>  if grep -q "Create/append/" README && grep -q "imm-value" README; then
>  echo "f:fprobes/testevent $FUNCTION_FORK" > dynamic_events
> -check_error '^f:fprobes/testevent do_exit%return'	# DIFF_PROBE_TYPE
> +check_error '^f:fprobes/testevent task_exit%return'	# DIFF_PROBE_TYPE
>  
>  # Explicitly use printf "%s" to not interpret \1
>  printf "%s" "f:fprobes/testevent $FUNCTION_FORK abcd=\\1" > dynamic_events
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc
> index f0d5b7777ed7..a95e3824690a 100644
> --- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc
> @@ -5,7 +5,7 @@
>  
>  # Choose 2 symbols for target
>  SYM1=$FUNCTION_FORK
> -SYM2=do_exit
> +SYM2=task_exit
>  EVENT_NAME=kprobes/testevent
>  
>  DEF1="p:$EVENT_NAME $SYM1"
> diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
> index 8f1c58f0c239..b55ea3c05cfa 100644
> --- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
> +++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
> @@ -87,7 +87,7 @@ esac
>  # multiprobe errors
>  if grep -q "Create/append/" README && grep -q "imm-value" README; then
>  echo "p:kprobes/testevent $FUNCTION_FORK" > kprobe_events
> -check_error '^r:kprobes/testevent do_exit'	# DIFF_PROBE_TYPE
> +check_error '^r:kprobes/testevent task_exit'	# DIFF_PROBE_TYPE
>  
>  # Explicitly use printf "%s" to not interpret \1
>  printf "%s" "p:kprobes/testevent $FUNCTION_FORK abcd=\\1" > kprobe_events

These tests need to pass on old kernels too. So we can't just do a
"s/do_exit/task_exit/" conversion. It needs to test for task_exit first,
and if not found, fallback to do_exit.

See how we handled the _do_fork() > kernel_clone() rename:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/ftrace/test.d/functions#n182

-- Steve

