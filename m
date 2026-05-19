Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E823FCD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360E56B0005; Tue, 19 May 2026 14:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311E26B0088; Tue, 19 May 2026 14:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2275E6B008A; Tue, 19 May 2026 14:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1018B6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:56:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB28C1405CF
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:56:30 +0000 (UTC)
X-FDA: 84785075340.22.B84A9C1
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 791404000E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:56:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=NQnk8s45;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779216988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63bmeqgSk7+7aQYOs6wQUlriM8jsLdf5CB2BlAnv074=;
	b=Y21G+n5gITVCwN3nYwjtTaZf586ukyFGtD6Qf7IeotKvG3LpZZYuYPod+gtZFXMGqz6yTz
	K8Zn48zniCteEV3eEERtVFvYwrYgC2mRcEkjrkX2oAaTN0ZOZQwsVmdBqly+IvDU1egZvQ
	yM+qiTp5Gxy3Ung/4GHLDfSYwpKQw0M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779216988; a=rsa-sha256;
	cv=none;
	b=33b9zKv7pM6QatHukk+D+jSldZ/HYUkkRVG1SpRutLvLrdxfxOFingpVFsOyCB6wFkJW/R
	k5iidj/rqYxo8vw2YMRQi3ekrCtic2dV9Hl9xbkKtBoq+3m9DY3/gqjzCWNfxqGEWDYNHV
	FjOmRFlzSYVu4SvrlQpSuV11kOKekCU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=NQnk8s45;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-67f7caa33easo8514103a12.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1779216987; x=1779821787; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=63bmeqgSk7+7aQYOs6wQUlriM8jsLdf5CB2BlAnv074=;
        b=NQnk8s45/fRy+IWco1RG58/eL7dAQ1pXdbGwmq6kQkTjTBcd2SUTNHNAO79MsBZN5d
         1N3e1x1f5/BMtOwupFMTHDarzkoISWSnL44xuhTyb5pLkgwNbVz2rfLHUltsxzi4Hg8X
         eySFmTSdeSICxzKaBPTKIXjFLuQZG5w9E6Vac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779216987; x=1779821787;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=63bmeqgSk7+7aQYOs6wQUlriM8jsLdf5CB2BlAnv074=;
        b=OLLFNoZCN3ihlnVJWX1Knp3ckS3TGcdZOrp5ERhp/5uYiw8UXbtslmsYFTFUJlDyax
         kFH/r1+NK9BMgnKc193TY6jJIFPgDZQ+iUbZV0/XhhvETzMdOUaB20QPkA1oZ/2es5cq
         rQDMgz3E+YKGSfqEX8IGSsE1TtMJHf5xnqLIP26EU9OmnZZFRb9qFFMWOgozLTF4SMVs
         RqjymsePrqx7VtYFc931imrWGcuuxtQmVSNlcxwuVzJr4XC5LjPd6rcIkULl9xTuNaEm
         QIbzfeV6hDua8ipWngWeK/PYw/v2g/77prWFirONONkw9Yf8r2nyboXV7gZ19c+8epMl
         rCug==
X-Forwarded-Encrypted: i=1; AFNElJ8CjZhXtRRYBGDZnWscMUQed1UP/zMbcwl4z7ul0PpOqgJM2l7QX9bfZpS2AGoz2lemqZ/dwd/OJA==@kvack.org
X-Gm-Message-State: AOJu0YxzjjlWyVkpSLaH77NGxrOsA16DLRSM2EAnmlQuLHJrB94j6L+Y
	ERQejrgQo+q61sKlyLelv2BSG6pq4BdX/7M7EM77STVAqyrAL6J05lB2lNHq/mFwLyNLdSHv1z7
	DQRACG134zw==
X-Gm-Gg: Acq92OFSh84RuWVx4c4fFSzvAtZVoX+uFnfPTmTrBU54HePoJBdfOoNQAVE4PzzW1tx
	eAR21TFc5/7ORtxcx31MhEbMf/9FGO4q6jGIzrRIwyBXsdn80/emRzJ9Ck2sD2AhDlWCm5o39kW
	UlK+L6MnbUXTEuEMQrwZ7QiRCXoDzc5XBaLiFBhFwRBFXKUaxvDHJFdHySOeW5xaWzav/FyLgGJ
	hmw0Fjyaw8FIO3kdbp+tviy65G/eYBIEPzFbDlHK0aG5fTlnBYw3JthxaRrNE9nFYjEaQ9lETt1
	1rl6r3qRhEcQPBnh1NNqhsd/qfrHxoxrBBSRtjj6M182WqOQfPjrVuttd/iD/PCHR6NtZaHNifH
	qAVczJnLNZmUjOjoU0W4fY6CULcBjuzYJvl6maR1lb591CvfwMt5EcRtShj5HpaIdKQbLYM4nSA
	D9uOhkjZ89Si6lx9PK0U0sLYFsVhMbyLBHyFswq3vGIlppuyMg+yhEQEoAUkQJRsolq4sbhH0=
X-Received: by 2002:a05:6402:3548:b0:66d:d31b:e553 with SMTP id 4fb4d7f45d1cf-683bd18f121mr10151179a12.20.1779216986850;
        Tue, 19 May 2026 11:56:26 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68310b52675sm6917843a12.8.2026.05.19.11.56.26
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 11:56:26 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bd01481e592so583259366b.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:56:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9SOBLWywpevkPhJCqsKmHmCFb394rZA6J3iBP9mW9QQ/HYzgFYghKzZC00/2EAXsV0Vdu0tacwmw==@kvack.org
X-Received: by 2002:a17:907:86a2:b0:bd4:d6a4:ed58 with SMTP id
 a640c23a62f3a-bd51792974fmr1245909566b.28.1779216986416; Tue, 19 May 2026
 11:56:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org>
 <CAHk-=wgvUW=1qtJxYcvbA_WaTom6n73nT7S_=7tZd0bo49BNOA@mail.gmail.com>
 <CAG48ez3jeAAvy5mymVkLq84Lf27VyQqM9JkjFYzXps+-jLKMkg@mail.gmail.com>
 <CAHk-=wjxBg4Mb98zjJP95gYsC1kYzzBdtp-Yz+J3ZYD+3HrHyw@mail.gmail.com>
 <CAG48ez0Gz_GghVeVzaixAQRNYBdWHYEj3K6FXBSzc+8WNsFxtA@mail.gmail.com>
 <20260519-gehversuche-lokomotive-cd720c53bab1@brauner> <20260519-lehrling-backt-261d022de809@brauner>
 <CAHk-=wj+NgoDH3GSicJ140SV8OoDd71pLmL3fgFEsTcgoMC6Og@mail.gmail.com> <20260519-anfahren-absuchen-715be2b88075@brauner>
In-Reply-To: <20260519-anfahren-absuchen-715be2b88075@brauner>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Tue, 19 May 2026 11:56:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg=CX5buR3W7w+ZLkAR8KM8K5M9YqKUxB49Lifnx37CdQ@mail.gmail.com>
X-Gm-Features: AVHnY4JYuOjobcYrDL_0WtQpELsSRYfj6YFbBJjIgfy30Qq-1ZCMCZaAJSuiTFQ
Message-ID: <CAHk-=wg=CX5buR3W7w+ZLkAR8KM8K5M9YqKUxB49Lifnx37CdQ@mail.gmail.com>
Subject: Re: [PATCH] ptrace: keep task's mm around in separate exit_mm field post-exit
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 791404000E
X-Rspam-User: 
X-Stat-Signature: 974tc8i8p5piqj6md3b6fi86wmhxijho
X-HE-Tag: 1779216988-583955
X-HE-Meta: U2FsdGVkX18jTP/ULIgNZ5LHiS7gGk2fKFq0cYlT4rl1WFAjHWelj5sCkjhBj9LhY5eB3Z4JI01dHDYsMpADhmZ9/VsvmovtUIjUPDzwiZ+ecdv2Ew6RpbYXXZaOpK8xBAim85nwKLJPyWcfpUeBc8Umj383dBqmuF0owsp7EiwD9+r0P2DTWwqurF50KaI0heX6Yga8ui7AQBMeMILK/RYge6pZiqJ7FFMWpujPEfVQxR43utW/F29a2sIyiy6g44lR5dLkrs7cIXFoEJbq38IqvTKGmjAcfnEfX1MLSrPzkcBM7z13hPu8ozY4MT6wWs+DgghlMWswMvfO7HbCocvnb1/rGeDF2zJT0azwC1NikFu3s1DGK6wSIex1aigFH7t7Jm9qtwY24iVNmBoSSjwbLCDEQlvnUGC5ZPYnQ7w+e6AJ+ZGI5Eb+Cebf4Ty5CNts1nLUSC7/90W5sJOb5OcD+Qhdl+6J/gwUdiMZFaLCTQKErM6E+A+I4oUk7Zl0jMbnYhRYThteZUjBi+AJTDdDEENy5MkdxE2DlX1zkg3nArb5zzenUf6PvcOTHc96I12OInLXeNwFqaMaUF+w0Rne1Ss1WyorjirVbPNeJ6dv34ClJz3yMdsW8M/rrHQ2R9YrEXdj/LA2SlVzYq+ev3YaDfE1vJxekLLXgP1azyT5YTRqCZY9viO2bt7f1qwAdgpUbO7gDFUsqlsNnelVYEzPD43QGXxrBYnYe7BQC0S4SJO6bAx4c2Hvn+019IcWMmu7oK8PI4PYCb9IH84FQKHYE9zsZytMvI5oND2ZCvUfZwOyx0iwL3S/QN9BSiHzETmIBDqBNnmhOTCzz6ZiRxYPq/Is+s+w15VYcJVQR0RpDM8fWD10pBPN1BTiFKztqlDzViXBnPwLvItg7ikHf7lSBogkNBBXhlkKf5+HBNE6m6Kk1cwW0WXjK2ryAFXyOiK3TL1Zzhkrx/wwdJ8
 wpd6d+9+
 shk1zNNxuJHpdiukc8bCEuyS/eAeEgZ19Xqy34ia1hdNynyhwQmySg0WsIdKs7cPZ9eq1V7dnuPEQpNtbetGCeecwtDJCLVLKWS/jbVutkHGUQQ5K4UkeR2Jm95y86zn4ahg3HW548DzKOflpfjPXfBITYV8MUe9KRmpPGo514blhWnEZGBoSCCasxTc8Yl9oXIVwSuIB7d9X/Pb9IHpgK+HQzsrtu5l7/Fk6GFupoZXvcEhLjH2NbEdwFgv77mZ9lq7guZW7WmHUltqM6uM5dUKu5xuo30DxIPMulV2YoCwHrMMWXPHiPms2yglYBV6Q0TMUPTDoOczgc3hXzSDH+mXirDDothLRcjPlXUGcg24ZsZZdlTYqpNpi+fJ7lZ/DhQy+f8nqtro5JAzgp57hUixt78aSGMSIn3Go
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 at 10:57, Christian Brauner <brauner@kernel.org> wrote:
>
> I failed to actually append the thing I intended to append...
> So for completeness sake I'm resending it here.

Ok, this looks good, but as mentioned, I think we should *not* do that
"copy_exec_state()" at all.

Because I think it's actively wrong for the reasons outlined: it just
keeps the existing race with anybody doing

  fork -> drop priv -> exec

open. Or, for that matter any suid  binary that relies on the
traditional "fork helpers" model rathe than using threads.

So I'd suggest at least trying to only do the refcount update at
clone() time, regardless of any CLONE_VM.

*If* that causes compatibility problems we might then be forced to do
the bad old copy, but I really suspect it won't. The only semantic
difference will be for fork() that isn't followed by an execve() (and
wasn't dumpable), and that is

 (a) very rare (both the "not dumpable" _and_ the "fork rather than
threads", and the combination is rarer still)

 (b) I really think such a situation has potentially secret data in
the address space and the new semantics are much better and more
logical

Now, I might well not think of some situation where a suid program
forks and drops privileges and we actually *want* the end result to be
dumpable, but as mentioned, at that point we *could* do your
"copy_exec_state()". But I think it would be better to try without it
first.

Other than that issue, this approach really does feel like the
RightThing(tm) to me.

              Linus

