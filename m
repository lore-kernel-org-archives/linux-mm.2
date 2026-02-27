Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D4F0FEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509D76B0005; Fri, 27 Feb 2026 11:37:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4176B008A; Fri, 27 Feb 2026 11:37:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD176B008C; Fri, 27 Feb 2026 11:37:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3896B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:37:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D84C08C374
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:37:27 +0000 (UTC)
X-FDA: 84490792134.20.3FBEDC6
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id EA5AA1C0008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:37:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EI6xyQEo;
	spf=pass (imf21.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772210246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtUg+xjznFV6FYa3fYU09QAY4geu0kHcNistSYyENIs=;
	b=STg5OmOy6pK/eSoe5v0IkAObQ5CoCGrl0Z7Me0pL/rESLTznYJj1TfrCS8CHTSfFoSpksN
	LrZKJ+TRMmkuOx32zk6Z9iDG321y27CjNeBYg5S2TcEq8xKHJf22tXH1VOfyl0Sr/XRGS3
	n0opDFoIKAUzOoOIStGP5ohDU1k0yFg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EI6xyQEo;
	spf=pass (imf21.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772210246; a=rsa-sha256;
	cv=pass;
	b=jwWRAp2y+mcHyaehipSmuhPofvLhQ7ZheUraMOeT7IzRY14GfY5QcPTZj3iPZSHmdFTxfu
	A15/KDVbFwABPB5sCDs933FOVoKDJH7d9SHeBykD7NO6wGPtg9HUaRN8bNFa4GeLaixX7T
	EStIzLUac2DwTGeQSNXx3oSUDQGXWJU=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d4be94eeacso1846127a34.2
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:37:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772210245; cv=none;
        d=google.com; s=arc-20240605;
        b=kauzWdCS2Hz0sOfQu6wNocTLhPCGrmX6y/qXFFBWHceZJ8TQoWp5YXpxw3t+hnlmet
         Rcwxvt6i3/tBsEiKDUpjTW2cqMlPzPVOQatloRqVAMOQqNYAUcHiA//jJ7YzUpiBgoh7
         RWhhWkzMTQyq5T9OLKqOi9sOyyXUE35VmaTt0TCnjfpvrGqSkAn/vDfZLcfvFMgIRaH7
         fG9HpW5bc9hgUobthvhQmNOplWzBVj22GIemKml9ile5W3FNgcehMagLifKvaTiVcMEW
         YLL8Hs0MaAHOxklSSzGyyAYSfreEGu1atw7wCSw1eupQSPH1Mfua1KabVnsstarfn1ez
         rWBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AtUg+xjznFV6FYa3fYU09QAY4geu0kHcNistSYyENIs=;
        fh=BTOCzxeh1gPa7tBz1u8CMpwF/FYKGkrbuLVh9/XXeXU=;
        b=T/AJGPkqRZZ1E3x90euEI701eqn8//djFE6cbDq7KzD9NU5lAIVEqhQl0ESnyEFzUP
         WA23HWDExRb8BMkBGjBsv51Nl70/mMJZpcO/Q1oDqfmJEgKB8LRoi79cQDG7a0J3oJou
         OnK1NRz18bGM+NOT7Pri+7QYfWTWyA7pz7Yvlvqvb8w5BRfD0WSsw6c20D4ZJv7laF5g
         rRN9LbyUnqZOjREqFu27GQUwtwrUrQL63T/pNf5XNTipZA8QpfXfJdOKRP7aykaZQakY
         WC5G5JwNzOT2rnr6jbmvEXj8erkysTsnjLm83t/Ex28OPrs4VncUJbssMwRgF7YvAHMN
         +CFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772210245; x=1772815045; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AtUg+xjznFV6FYa3fYU09QAY4geu0kHcNistSYyENIs=;
        b=EI6xyQEoPPP9avAxpPrUnGaabMQULCkmqhISWAfW/zywRukBx924/gbqA+7D9vURsJ
         egXuCf79BjtbBynQ/AoZCsMT00d52RR4nddjFYfRq2DIFSbk2vQqDf7xvQv9sK7iRQne
         bCAQrrblvmhE/MDFGj3DTXQTc0q+pQGmJqsTsG59ODE+TGmsNII6L89IIniQp5PbOikR
         QcIEXtC3lttP3FlGa/1dYkG3WwMDJd/p1BM08IXFRbLueh3T9fNHhffsM/BcUFBtEE1g
         IFAXK0Lj5Qa90NygsoRy6DFih4szA6WPcNvdm/spV0KsaQLXSCKyp52D1x0eE5mkKH+3
         RQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772210245; x=1772815045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AtUg+xjznFV6FYa3fYU09QAY4geu0kHcNistSYyENIs=;
        b=pNxbsJTWfqsYCoeMrkIBSMLZKB3lXQHXjSGO7GBTJwsIgyKnQrcAUM7ACi6yI4gpF8
         0YQJSTuWqS+6SkoMyhHfHjAteOgjv5T7+77Xr3JS10XUznV5PoTQgBGcrAJPOMAPQXgV
         69SdH09jQ2SQfn2Cmiwp5rBTxzrJIOm3kzwDf80K6gJpwKW0jEEkLbFKSsm57A/BECSC
         yPvgy21Ramc1mckno0/yQQHnHubuUGXFu7k6n+0Z9vznwFFotZZFoa+5d6v593mtOwVs
         Y2IyP9sRE+x4jZA+Gt/Ny3lgnL6r93Y7uaPLIIjr+o1egi7IuGvBv9Pa/uYrb3UoBbOp
         GNdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKKwtQq8A73whwfBdz/Xr1W7ViSFi/zNuTHLxb9onEcSKD0woTRbMNtUB2CcfU6JPt8V/yxyFcFA==@kvack.org
X-Gm-Message-State: AOJu0YwR8mJoUI18YypeRS73FTnuU3kUcWOFL6Df7t9sSmfykzpz1v7n
	ql3DTjMqdS7u9rSJv8NJcF/7xEw7YDCWVKqRXzaqD+t5R0f5ROg2K93R1YrjIc607xw5krarNHO
	fd3ANkZrg9QF3nfyLKcgq90J1YkvA3L4=
X-Gm-Gg: ATEYQzyO/GfnGBHweyjY/7vPhCKFDoX65RnUnvQvDHq6AtW9WCVpoZzo9lrbYFdB8y0
	mhmIa09u0f/47pUfZUU8MFFDIDppyJv5wax/11YJk+DtUC4o6KUsnr4fWFtJSrGQjR3Prcn8yic
	9JhcfBdSHIFl7V3XNEulnZprTw9Ke8HFQcJ8K35pIgxcU6tY06ruAjgXt1R7drxGdtcB/gpDpoZ
	BiE9Q/+pBMnnJB+Bsze5XmComKR0CNGdbNOUDQldmw1/ldDsyuvtTO0/7o9UZPceqxIXwu9vwbb
	R68pTTk=
X-Received: by 2002:a05:6820:4b91:b0:676:83f9:c8ef with SMTP id
 006d021491bc7-679faf6de7bmr2129142eaf.65.1772210244934; Fri, 27 Feb 2026
 08:37:24 -0800 (PST)
MIME-Version: 1.0
References: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
 <aaGHu3ixbw9Y7kFj@redhat.com> <aaGIHa7vGdwhEc_D@redhat.com>
In-Reply-To: <aaGIHa7vGdwhEc_D@redhat.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Fri, 27 Feb 2026 08:37:13 -0800
X-Gm-Features: AaiRm513NgjvEk0OvGli0FMTNAplncs3-HvUI0iqn8dQlxQQVOMBiqw8bIuTMxs
Message-ID: <CANaxB-zh6MLRniZ1WNkZ6iBgbFMLKEVtnpOoLzKGS15X6d0m=A@mail.gmail.com>
Subject: Re: [PATCH 1/2] pid: make sub-init creation retryable
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Jan Kara <jack@suse.cz>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, Adrian Reber <areber@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EA5AA1C0008
X-Stat-Signature: 5fs7i6zpf9g4q789fc3g6p44i5aakrrx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772210245-966694
X-HE-Meta: U2FsdGVkX18c4DiRIBf+4sBmIsokL/g7cjsXOF/1Zsnx4HS+sleZjdGf8tTx7Gk+viIRxSC7hczhsMVV5xJjJ9JGxu9nUmd52fXvUY5BBn3iD1IpEsrekUsLGVJp7jFz0OIa5pl9hHJc5uR7M5JrWyaCU8iHnhicqDOfs/DNRLEomhpw51XW0gkcRpZ/hu34e6nmb7EZPM8pXQAn4NVzcOrUC4rSjU3DH57ZsV/R2ujUz3IC1GzUnZiYK9BCK7B6j5hmRhJrpbiwZP3WRoe4ryuC9D47amdLKMjPA3semarXCZTAvQdZKpho74tMaCYxfqbA7jRqV9aSSYbrurXUbw1M20PCyamb94AJSwwUjzhsjAWMqb6+7urIbstdRljROWSBS5yQtLW9zHecnb44ezBauy2WCd1ii3ZNgGeIf6ZHe6GtlU+AU6UXBJbVC1aCYdQFMd6M356IIAnu/5leu9KfylU1xwnZAyQWUlWJFJofHm/j7WmWEEkRi1IvEMZadf66c5w1YFRRstEx79cGki1xFHZDL/puOJaYuIfvTWIvkqCm5wdGgQBCiEyLxIzWVwP/E+rwJwk1cKYxhNyxT/Fm9nFmAyflruA6PyVCZgHLRPkGXGSec8acWcHbs9QubAX6ztZvRTpObMGnCIMmmiJsHyhnk9kanbgOzWc6rvdKrcI8wljnEwKto1BJYEdZv3QtYJ6ZYR3ENOgEnCXaMAjuhZ8/6/CMNJh0O0T7bOzSczpxbfrnIHeqS8czyicE9fEvJMDhuAATRX2s7Uee4c3lGjvXIJT9tobvcIrDCiTwl7WlBor3zIxvUCQrCZBWUbWhYWcntnQSgTe3zqEkgtbkXaoQfPGbbjVoZbEefu0SedgZHGgfLUP+toW//l7p5flhlO5k082MDOXrqEC6OTvp2Ci3TddqaDwrww8RPG2RmPORak57m2NEnky5LFbA6Aba7utfND0RxdxW8hq
 4BYMQl8J
 G7s9Ch70oaaua9MlpPUYPDvpOC5cDUO6YDJN0v8z3D5zBIRXYm3KcsOiXGUl3kXJNBeMqh7r8h4FslaAq+eTAa0V/lZyZ40YEBYjpc6VLiBsgP6lL6sWP3w9jewNK9JDFmSRZ75n3t2lrOXxF7BKcWVvFxLZ0xI623WOAwjxdr2pjXEgP6pk3S+5FQ3ZVPzILlW0TMvseFC6iHrAAfe9duFsChmf3isIWf7QPfcCffeUrxWUJPR5D0BOwK9IF4I+wpC2m539I3Pq3HwKMZfZ1CBDcZ6JfqGrV1OqhWg5YCa476/BvxCW3dz45ko++YTeIggdfiAhaTlKfi8g6iN3m6qwqGC8J4puSlwEGGCi5pA4tofg2WF5gWzUeSeDKzXTFu8xoKtGGNrclDAhQeC1vvUg//8G+CYoEgkDtWYHoyXuLmtB+URVh1WmLVxRD7lGpwusH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 4:04=E2=80=AFAM Oleg Nesterov <oleg@redhat.com> wro=
te:
>
> Currently we allow only one attempt to create init in a new namespace.
> If the first fork() fails after alloc_pid() succeeds, free_pid() clears
> PIDNS_ADDING and thus disables further PID allocations.
>
> Nowadays this looks like an unnecessary limitation. The original reason
> to handle "case PIDNS_ADDING" in free_pid() is gone, most probably after
> commit 69879c01a0c3 ("proc: Remove the now unnecessary internal mount of
> proc").
>
> Change free_pid() to keep ns->pid_allocated =3D=3D PIDNS_ADDING, and chan=
ge
> alloc_pid() to reset the cursor early, right after taking pidmap_lock.
>
> Test-case:
>
>         #define _GNU_SOURCE
>         #include <linux/sched.h>
>         #include <sys/syscall.h>
>         #include <sys/wait.h>
>         #include <assert.h>
>         #include <sched.h>
>         #include <errno.h>
>
>         int main(void)
>         {
>                 struct clone_args args =3D {
>                         .exit_signal =3D SIGCHLD,
>                         .flags  =3D CLONE_PIDFD,
>                         .pidfd  =3D 0,
>                 };
>                 unsigned long pidfd;
>                 int pid;
>
>                 assert(unshare(CLONE_NEWPID) =3D=3D 0);
>
>                 pid =3D syscall(__NR_clone3, &args, sizeof(args));
>                 assert(pid =3D=3D -1 && errno =3D=3D EFAULT);
>
>                 args.pidfd =3D (unsigned long)&pidfd;
>                 pid =3D syscall(__NR_clone3, &args, sizeof(args));
>                 if (pid)
>                         assert(pid > 0 && wait(NULL) =3D=3D pid);
>                 else
>                         assert(getpid() =3D=3D 1);
>
>                 return 0;
>         }
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Andrei Vagin <avagin@gmail.com>

Thanks,
Andrei

