Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B43D5C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 18:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7FDD6B008C; Sat, 19 Sep 2026 14:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FE56B0092; Sat, 19 Sep 2026 14:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1EAB6B0093; Sat, 19 Sep 2026 14:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0066B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:17:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8FBE1202E5
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 18:17:34 +0000 (UTC)
X-FDA: 85231319628.25.E5766AC
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1DC0C20002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 18:17:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Pw96kPb/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789841853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXlL+5LiPO2Gr9S8btdNT0yhev55DeOp6fa7hhJR9YM=;
	b=mCJG8v6N8Jh02N7gGKnh7z64e+D5FAb8TO/U/LC3VO7mswnS4ycgYCT8NldW2d3WlmLRLW
	/lGzvw6SmS5fn7kIZlQaJOsTO3WbspGaEZYtOktmiDH/TII+1dT6fp+ltSAX5zitOzEhfO
	tglDiXUQmeFCdCHGNJn+TC4NQGP5TGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789841853;
	b=EkFP3ltWMr9ogrbSkrZJ8UfT/1T3f+BQe7Sp8L8TYW3KrO0vD1PshzXXirnkx2xFcPgLQO
	IwmhN9rzf4aCIavIdYpHh8Y/pmYTGxosq46EYS/XGtnc1AR1Mle1ebUVu1snBYijGfiudd
	PU4mokge2Rd64LXJAJucqOz/rSFfcqc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Pw96kPb/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so1598701a91.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789841852; x=1790446652; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CXlL+5LiPO2Gr9S8btdNT0yhev55DeOp6fa7hhJR9YM=;
        b=Pw96kPb/+GsSxcL4SducibYv7CREEGwBi3CHEyXhFPV+gbIqCO5s2vSwMbyVGklFkI
         Hi5ZhJECuIL3NAK2R0iyejeaOAckFL/uF0PS6kF2OOrdcucqMtNsB4Fkl0x1ocJt8HRh
         jdPmL4XpIdM8VsFnWUqwD/RA+2aRdp4Fm4iaubUR8AW1yIwXFjp+lJaxohglYpxgIFew
         OFAOHRzRVqi8MB2aEfV/I4GZkaIhjzibz/Vsbww5Kg6UYr+D/fgMA3eGngJrK++sjOIf
         HZLa/cbj8ls61Y6LifmH/c17+hpxzad4TuULZjV2j8HzODVqMcW9yza7OydY2oAYWvTd
         tYDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789841852; x=1790446652;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CXlL+5LiPO2Gr9S8btdNT0yhev55DeOp6fa7hhJR9YM=;
        b=U0TDLKtKKC2oySudX3HSreeEEmJV3Pa2NttHyycRjB5gbcS5FwPSSj5IiXeryI7Yqq
         Ywo9wEeL8HzL80IKpt0YPq4Uu0j7Uz/C9Oja7JvhtMf8Wn3v2fWLZzsNEG/GcrLXzIeb
         +a+/X6ENWd3l9f/x9UGAzOcDCcB61Gm6/cWH+Q4RdJZOArRYtpn33oOfRhuibZMuBSYx
         wFmFPo/g227onDoYHxakS2GLWvzQ4fZm3TIziD1Fx1DYYx0uDweP0lb95IS+AzJCfwr1
         vSvmDFSXL+yP4Ggz/7YLfN9OmHYEz06SvYft/jCd6U4LUOt8Qr8q3rcLdnJxsuUSvNVN
         JPJA==
X-Forwarded-Encrypted: i=1; AKwUvBx2LskqPmivY7NkOJlmdFQzaeQ7V3/4SriLB2eO8paCuN4xL6BAK6PyCSSiREcPZITKrqJUCQ5ldA==@kvack.org
X-Gm-Message-State: AFuF++kVwGuNa2tVLl5yyiB1xGYjH9gKO0eniHU+Ay/wTjvBsyF/OeHu
	HE/wc3A+3FE20UwxXKt0S6cjtHcWpMks9sDIQ6eN6UTJd5A/Jim54X9h
X-Gm-Gg: AYBFou0H63ZidyZgVx8E4jHipSAN5FMImMSCxR/alX4399X5yN+sqE+JEPBSh5bgbJV
	+X3nFwhVZjGkTWj67VGdrB5MsdGTH0NjIH8JuiGVYOlaiDlH+8AVE9Mbyds+LhpQ6gWxwxu42dQ
	glqOzQq2YnS81dQjMn00u4zjr0n6qr8QEu+brY/oF8Pqze80vevWRkJGJ6LjMLAQ5wQ7oHCu2lO
	Z6bKg9KdMETnRfzYYLMOrfXxmJCk5iyDTTHnh1Cm87+6tLs/aTGvV4fv5jtdqOllA4jUNvwTF0+
	LVmQewlaX/ZmyNsLi+iNcK6+QDeUOTrKQCwtdoI99Wq1YyAqsOLquc7MzK/fJIECF3duXMeI20B
	xY3/h5JyNXWHvNM0Zd3h5Ep4SV4dT7T27/ItNP01f1d+TpBg6jKBrLiXfmyx14ls3qaVDhI+Fcn
	5ev9z4W22+j4SyZDDenksfeMDVGOTdAEgvc84v76mkluj0Me1+Td6I4NrWGDthxIaxmd+ocKHlf
	yY3trd4UaIP7sGNdgbrvyPly71O33PmNf2N9UOyEJtunlZ23aiQ8tStPhDV8x07Vip6btoFTBbM
	9g4=
X-Received: by 2002:a17:90a:d005:b0:39d:f731:e5f3 with SMTP id 98e67ed59e1d1-39e54f0e839mr11355351a91.24.1789841851709;
        Sat, 19 Sep 2026 11:17:31 -0700 (PDT)
Received: from localhost ([153.61.198.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e55b83602sm4333791a91.1.2026.09.19.11.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 11:17:31 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Sat, 19 Sep 2026 18:17:30 +0000
Message-Id: <DLJHZEZMLW0F.27OPPS218CX9Q@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Hao Li"
 <hao.li@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Amery
 Hung" <ameryhung@gmail.com>, "Swaraj Gaikwad"
 <swarajgaikwad1925@gmail.com>, "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, <linux-mm@kvack.org>,
 <bpf@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mm: restrict can_spin_trylock() to preemptible
 context on PREEMPT_RT
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Karl Mehltretter" <kmehltretter@gmail.com>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Sebastian Andrzej
 Siewior" <bigeasy@linutronix.de>
In-Reply-To: <20260919171443.90512-1-kmehltretter@gmail.com>
References: <20260919171443.90512-1-kmehltretter@gmail.com>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1DC0C20002
X-Stat-Signature: 1f8dg1drf8seuw3kr7fse8g34b4n1fom
X-HE-Tag: 1789841852-650665
X-HE-Meta: U2FsdGVkX19z7oNTiHV2CtCudzVQi5c92Z+5OUoQ3dUQhM2N07ZTu4wezZrbsFPTnbwGMslyCpIN3Wf2SzNdbIQ03Da4f/l9dZrPt7TRpFOytB+ISf+uJLS86zKu1epD+LBkWOus4tHlfpG/f2oFZkdsIF7wxUvbrEvKRWxt82o7ESPI/MTtKTT4b3gYvVCXSu0iEAEl0Gty2l5i6Dw9+OdEZ4jB8qRU3AJbYDikTIUbXbmxYLrx+zfITSlqb4EBo7SSwEY8v7+gUnE6gs3aSVBPGLt65Qo92YeQBKLp8LeGAE0HNE0EQx5AeRRCl916e0LDZbLSE7PMhFAjrVXsrlHZVw63h5nb7MFl2EQejwkQ13LrHR9fGWuY949Zu1h0NUa/UsjUto1SIqPGyxAtc/y+TOjTHs6oQuF7NYCJM5Byb/34+9VeAhRh2wQV9pJAavrOS8+bhe5RREnY3hFNUvonqdNDlKqImb0P+QbRlEbrBAAWOaoWOHRHOfPIgAStA5cobU42EsSUME8OsJFd1n9DBKzE5TdhT24wWTjFM4nuCtAinsg6yUxbqkEJnGC2pbwaFpayzmdB3SZfKpDfn5emYIkiYtvmqpX2oUiIMezbzviknJiAEXWgOGWjq9e6UFzT8ZiH9+9N5VGG5CxQ0ad/li0U3OLKFsGVVIseIpZ7J8pEi7cp6/3B22hJdOOKPoZEHRJWeHIAzdmEW3W+YYsCzyz9iZrZKH7aX2rmt6KRoTExQNZ6LGjUN6axQZ67SmULAalhl5Ef0A8btmkdTX+OA6ef+B0ZXZ059NAAcfdJqdO6qdf8V+pXdSAiraqltR/zSJoGsgMzAITBP00cj28wp3ozjg1FOwRsALeXIiNpLJNHy5k6YzloEFG4bickFbU29af5GnYaMBKaAcpYQAbrJsOAvoXyPBQuUZvq9UEoJhw6hptL1PRjketCyh8Ii5hnWavzO9h9QuXogOI
 kYbP9yoe
 09ub+vaEMuymxG0s5UE6clp7kgR/EDLPftJ1o/U7bQcwDyyiNOLSFPRn3mxqAOtbcEH7wkQSgojKf7ctbrRvo5pFqNcApnVv9/hotXgk7XgpZ9d9YkMD+IGwMfq9ld4IPUK20eTQEIMFhKdIHu4AQOE8RPhpj4OR+Y4rHNmVvvoYzO4esLCkyLHZHoeFHpEhz33tQZtnMqxF8hcELolk3cpkM4fXpyJm6kbcjzMiqTeh/V2UUbpZMpORttzgd38PZgd7qMOZPzyTJ9hCYMutwUvF9KgXaVaDDVI4KdBCaygKG0/ByEcVK75CXob2jsGFIRX0J43RdRa7+6rJRwcy1xbuk8MUDIErTLNSlBPI6FGrfTfHEvJ9dBdTSfBiGyzBDGblbG4GdYm6LgaYF3cjWk9fBcFtECN05x1AgBGMBNzT29xYYTi1l7BwzK3z9SnM/YuVdBIbum8ymxdU6uzKi4Wi3wINZyfXB1KGaMzzFoM5pp83DYtnPjVuN2srzSkZsNU1eSf8PHOts2CO3moqZrtmSReVVF9TsWqYMHlUfwVHGqKB/wF8SSPpm7gkoh1+mv2YGj/GzbD/8MS1cgIHc89p7tLhgIyQjEZ3v0DHQVIQbK/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 07:14 PM Karl Mehltretter <kmehltretter@gmail.com> wrote:
> Allow preemptible context only, as v6.19 did. A held raw spinlock
> implies !preemptible(), so the locks of the caller do not have to be
> known. With this change both machines pass 10 of 10 boots.
>
> The nolock allocations then fail on PREEMPT_RT from every context with
> preemption or interrupts disabled, also where no scheduler lock is
> held. Creation of BPF local storage from such a context fails, as it
> did in v6.19.

6.19 had this check in kmalloc_nolock() only. alloc_pages_nolock() and
free_pages_nolock() allowed irqs disabled since they were introduced,
and arena was sleepable only under a mutex back then.

[...]

> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c94..29646c4afb419 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1641,10 +1641,14 @@ static inline bool can_spin_trylock(void)

[...]

> -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi()
 || in_hardirq()))
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
>  		return false;

No. This kills bpf arena on RT.
Since 7.0 arena_alloc_pages() and arena_vm_fault() take
raw_res_spin_lock_irqsave(&arena->spinlock) and call
alloc_pages_nolock() and kmalloc_nolock() (from range_tree) under it.
With !preemptible() here bpf_arena_alloc_pages() returns NULL for every
prog, sleepable included, and a user space fault in arena gets SIGSEGV.

As Sebastian said in
https://lore.kernel.org/r/20260831143500.x-saxdAs@linutronix.de
raw_spinlock_t is fine in general. pi_lock is special. rq lock too,
I think, since rt_spin_unlock() can end up in try_to_wake_up().
The check has to be about those and not about every irq/preempt
disabled section.

pw-bot: cr

