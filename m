Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0085ECD4F50
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6747A6B0005; Mon, 18 May 2026 14:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E366B0088; Mon, 18 May 2026 14:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561B36B008C; Mon, 18 May 2026 14:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 434316B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:42:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFB0D92627
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:42:24 +0000 (UTC)
X-FDA: 84781411008.30.79FCA42
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 94C2F14000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:42:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C6slzCNK;
	spf=pass (imf23.hostedemail.com: domain of jannh@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779129742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+p1ThALA7tHsxgp3ecD+YLGFewUIoZYVb4FRUnieaW4=;
	b=B5oIWy8pXYllBMUglnTGk3ZMQrP1MYX8XM3R2UlCqnsly7gIu72/X1puVSBwZYwyle4YVm
	vKO7aYwrFoZHNDGhxqMiEYPnLNu8ZCeFi++6Hd/LcrHiexvlaVLJWrmRcpBD9+cUR2cXkg
	AAwCV8OHkKxEkEM9+RU/QnP7FT64psc=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C6slzCNK;
	spf=pass (imf23.hostedemail.com: domain of jannh@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779129742; a=rsa-sha256;
	cv=pass;
	b=2pPM7LU3I6ObhD3xxyEupY4vrkwxHu10I1ViLozU1k46W/MfVU5K5e6RgqF6AdIZfx7wHS
	UkRuZnzFyAWD3DUXwDgn2psnejTepmYI1OqULe5kbzmvnt0aiX3WQQo/gk86ixF5OWJc/g
	ILi1GzbpeQnkJzn5RSXOQhQ0GT5Zd0s=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso104a12.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 11:42:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779129741; cv=none;
        d=google.com; s=arc-20240605;
        b=OMtNmwUU5gPqH54ECj8TNHmg0FgLc6mC7B1AUYl1hojbv/7euMhIJSR4lm8q+bpsuS
         vjKL8Ju9vDuhqgKuPuB1R3nRG4+zMjoxoo4TU1hawDPOOPpS0axJognXNd9X/p6t/c0m
         5lqQ1ljGYIe7eaPkAXzu6pWI5DDs82t409vS4laKkv9bRN2lwBe7c1aqMa+LQRfyEphS
         K4wIlhjQdyIspaKqH1+u97nJorKGc2T7xUWv7/WGdrwgxaXLqIpO6yyzxznoGEbmrFQ5
         FOZIzrxW2RF4oYkuFE9S/7dp1FfQxyYm0xPMrAkJal6ijAi9AD+Pks/MTXhC1jy3uQmD
         fbMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+p1ThALA7tHsxgp3ecD+YLGFewUIoZYVb4FRUnieaW4=;
        fh=PhCQbZemMxc7IcQ/JvQSzAYYgF0dDlgjf4MBOTzmIos=;
        b=AQSD3XvufwCmAwZphdBbTN7J7xGcVbHbedwEijHta76NxR549gd76V6J/JpJwJaK+8
         beHPLvbeiRpSStkwlk2u8ObiaVjhMGNqNbYHAOJ/8oBSfaogqs+AqYFR8Oxnfi5eJgbj
         NexV5iQC2zzNigrBbXVxwRWnJ1KS+cXXHk4VCRmmrxhCM0PpUICyNLAIPfxsKl72h8sw
         BkNtOA8xXuPHeuineBIDxT6hXdKGD8rcECTG0cXUByZU5Yi6eC4Y4v4RxfgWfYNOKQst
         L514Wwu/r0sYHGaMjj5W5r/lrfmaHZWDCLEzV2FXbvr8JjQPXzgoFE7Ml06DctlfADuH
         kAeg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779129741; x=1779734541; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+p1ThALA7tHsxgp3ecD+YLGFewUIoZYVb4FRUnieaW4=;
        b=C6slzCNKEgWIAlq7dx1uG1Sgp0jkw63Gy9cX5bicC8PNryzPI+b9kQNJ/ZKbX9XYXg
         GEZVwAOrJ39WCdytbvbpvwBGdqPBZD0Xf+kpxEKD2lG8pUpcuHTnE1oFkBBFK2t7UYQQ
         JbQOEBEGtGhsmf6xTUrh89MLD7/kWiMlK0oWk+HeGA4l1eoVcyZZ0JgmHON/bJ9QGxTm
         /n+4dKFXCMqKzWEVtDfludXJ9HuOvhbqbweeqW2fe6NYN1IvD913kdLhZ9P2v5fpbo1m
         fNkn4H1qb4zoAzQMJW95AbkJZDcC0RpnsFBL75aFPyCpUBQmhd16J1WjTvQomvCyILj4
         pGDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779129741; x=1779734541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+p1ThALA7tHsxgp3ecD+YLGFewUIoZYVb4FRUnieaW4=;
        b=CnyVRbGwNl+ckoj+Ae+Xtvl8q6VSyqR7eo2wLCIjzvxcgQjuQ4gqUmkYl9b+qJnzFf
         70L+LNWPzL6qvsBrORwILRQuuFRZ0k6wrkZpSyO2/BfZrAFIgf7flDQ6bsYjBwTuQNaK
         BlI9AVgzR64WsVZ6E8WR5vLnz4uWmBI/tvQNJTEMHzP5NLD/oG4VBdi6soHzRSP9Klx0
         7ek7sCib/wllqW2bQkDfgSam7ZypzSwxsqhq5LyveyH5gscG+LEFXtiQEg5Evg1+VBHT
         l7T14D7Vng1pFjhaxLb5bwDUxB79rO3ghvev8K804SJasKQ5yCVeNGDmLgTEx53STf25
         AGnw==
X-Forwarded-Encrypted: i=1; AFNElJ9yG+OWzicbgRxo7tZGikWXSiRXZ05GWa5yoIL6NJ6g6pzX4LtfZR+9smz1vA6c9JEG7CCofQUrZA==@kvack.org
X-Gm-Message-State: AOJu0Yzy3BHgVI8OqFeTOhZL0ThaON9kLRnuOuR/bK/fR0S22Ft7yj6V
	pRezcBrKAqE5ACJrF0i1TGJnKVIsmU/NHidvq6EtNWLsJ1w1yb+MBNzETuDb0i1QPnK4Kjc3uG7
	ymJZ8SzGW4sEugNuq1w3itgFz9/KDWjKxc4fIIGZU
X-Gm-Gg: Acq92OG3VQG8l5nOmD4m7+eFD6tyIqA5xBWvlRb5Lv9lBhAT0aFjAkqADSMPJ9v/9ND
	84JyrKRQWtz5VB1xzUhJRsLa7gpifkVCSYhsS0KAoPS3vio6ktSu7uDl01TNXEVEbKdfrYfVltb
	VK/2xku0vvUfcoDL094ROKbLX8DX2QnIUQKPWSDHWzrdslXZD13/EAraOmVZof4ySIIxUgB0Wze
	dE9tOljSw7vbjywbZwbp+f4xW5jnTW7xItCs84bCh1BLUfCLKZyJaGIKjSOoMA6h2KG9HxZApg6
	Z//2r86pTAZh+0VajxdoVR3nPapg6mQ5zsPTsQSdwdFW9pM=
X-Received: by 2002:a05:6402:17c1:b0:673:9b15:39ff with SMTP id
 4fb4d7f45d1cf-684986e13a1mr103311a12.5.1779129740542; Mon, 18 May 2026
 11:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org>
 <CAHk-=wgvUW=1qtJxYcvbA_WaTom6n73nT7S_=7tZd0bo49BNOA@mail.gmail.com>
 <CAG48ez3jeAAvy5mymVkLq84Lf27VyQqM9JkjFYzXps+-jLKMkg@mail.gmail.com> <CAHk-=wjxBg4Mb98zjJP95gYsC1kYzzBdtp-Yz+J3ZYD+3HrHyw@mail.gmail.com>
In-Reply-To: <CAHk-=wjxBg4Mb98zjJP95gYsC1kYzzBdtp-Yz+J3ZYD+3HrHyw@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 18 May 2026 20:41:43 +0200
X-Gm-Features: AVHnY4LstOPS__-9Aax3fzoyWaoHW_wSKT_XE_DeVocrxJninb7wmPZdDWUwtFQ
Message-ID: <CAG48ez0Gz_GghVeVzaixAQRNYBdWHYEj3K6FXBSzc+8WNsFxtA@mail.gmail.com>
Subject: Re: [PATCH] ptrace: keep task's mm around in separate exit_mm field post-exit
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Christian Brauner <brauner@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xx3zpfgmyd8p8z4jon9dy1z155jnbckz
X-Rspamd-Queue-Id: 94C2F14000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779129742-605762
X-HE-Meta: U2FsdGVkX19mOoKMj78TtJk4ZysJ63wtxZCFoF8wW+hN4PJ8HpJ91RNFPymd0lyhOURh2nVdBhGDnJdYm4YhSKQETHSLhycyeY1iTIULB6K7xLUJ4l2oX4LYIWjtlgcbymWI7cJg4dP2UlcPzXCmOfavaBpW0ZgFCjAMcne5wlaE9MXctUc6g2HXtYQO14Yf9fbuj7eO4O/+nwWSxfmYolGPPnniGXktigDC9jVtoiahDBN8CCI96fCqEfjyU6irlkTwDKKseEC8pbCN+j0/KyEjMnHhu205IbfI4VqsroOV2TJm6sM0G6G8/q27FJVnK/hJwpQDCgECpXbmEIS1J2sSLJjifOvZDeRy4Eo+QJ65LgiaXWcGncvj2Y1waFJKauXR6+kmF45Rfec0BEewg7zTJJnuJBcm88SP6d4m+xr+EOmOBwctD6dF61zaIRTG0x9NG/3xMXMS9pTsZse74YAQDLhSeBJBTu2pLtFPqG14aAMzAwYiNp5xfr8tznCIbD70MHUgClifxyLqEwkjUcdTIUuvDXN4lDVwnUE86XJBTC5WJx3V9iOtGNK01FeE3XUF9T4A7d5CvVZGvqcN7LNxDhd6b1+G2Hdtlu2FefZqCcLDl+B7Bpvq+RFerq5xrZuE2oCgJZEMWtz/bjEDHd4GSM9pheLYXbztbxlUbyRMCscdoVqJyQTvOcZZFw04kVVsfm3VLQaUFtJaJO1t7co/+7cFzqZ6IMqQHh+/qmRec7gwO8jmT+jLoF6TAqkfDoGj0JlASOO8pyRgEyIlFJeMEVSUC6LX2No/KjXkpb+LlgAaM3YAAAbGD4po/KKnBZSsYZv7iKx5G9pjStoNQF9unnVhZ73moSDL3wM4nhhdNGP64xl4M4xVnv/V9JQcpIjQ+0xpPlTlnsDMXk0r90D1QkXqZVhJJ1BQaIBFs8qylRwRAeV66HotGKrTxM6kUptx0cSd403BQ/QU1vZ
 sDEXynjA
 j+s8rRP25G8bWijust+VlM9KSrwBasq2AesVGTGjDqnyJX3gQEBOxMuk3qn/IaPr8JEBMZoliVSfkMqU4iE6vGD+uwagsrx92ph+QUyPGTH0z3IiyJv+VfSaJEiOsgou5fiSgZN1mqCwDRHVXci/Xq+n9MJ0gZ7Ju6KoH58oiCbXdd4hSbfmJYIcERrGGzLQMdbPBZ9pVWjmd/LWEPUQrKL+SoOaa1+e9up7QQbLVCs0ak04nNKRpF3s2bhznLcdyRU4nNPWdb2799LSA4pwqYjVbYvJp9O5VOSKoQ4DQ91PBG0PYk+bmwxhETLhhY6ay67abFoPnLNJBI+xVG+c3fP3XckGdsrPjT5bX/Ql1bFRzRtlhV/oc+7Xq+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 8:11=E2=80=AFPM Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
> On Mon, 18 May 2026 at 10:20, Jann Horn <jannh@google.com> wrote:
> >
> > I mean... /proc/$pid/task/fd/$n probably has the same problem, no?
>
> Possibly. That said, the permissions on that directory changes when
> the process becomes a zombie, so it might almost accidentally be ok.
>
> > pidfd_getfd() is just more severe because it directly creates an FD
> > for the file, instead of going through normal VFS open() permission
> > checks. But /proc/$pid/task/fd/$n is theoretically also dangerous for
> > stuff like anonymous pipes or memfds, where security mainly relies on
> > not being able to reach the inode.
>
> If your security depends on "not reading the inode", your security is
> not security, it's a joke.

I mean... __shmem_file_setup() explicitly creates files with
S_IRWXUGO, and that is what memfd_create() uses. So the security of
memfds in particular always relies on the inode not being reachable,
unless LSM restrictions are involved.

user@vm:/tmp$ cat memfd_test.c
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>

int main(void) {
  system("grep ^Umask /proc/$PPID/status");

  int memfd =3D memfd_create("foo", MFD_CLOEXEC);
  char cmd[1000];
  sprintf(cmd, "stat --dereference /proc/$PPID/fd/%d", memfd);
  system(cmd);
}
user@vm:/tmp$ gcc -o memfd_test memfd_test.c
user@vm:/tmp$ ./memfd_test
Umask:0002
  File: /proc/699/fd/3
  Size: 0         Blocks: 0          IO Block: 4096   regular empty file
Device: 0,1 Inode: 2064        Links: 0
Access: (0777/-rwxrwxrwx)  Uid: ( 1000/    user)   Gid: ( 1000/    user)
Access: 2026-05-18 18:24:31.669411864 +0000
Modify: 2026-05-18 18:24:31.669411864 +0000
Change: 2026-05-18 18:24:31.669411864 +0000
 Birth: 2026-05-18 18:24:31.669411864 +0000
user@vm:/tmp$


(Anonymous pipes are less problematic in this aspect, get_pipe_inode()
uses the current_fsuid() and sets mode 0600.)

> The /proc/pid/ interface has been around forever, and that's ignoring
> regular ptrace too. Files have absolutely *never* been private, and
> anybody who thinks they are some private thing is just wrong.
>
> And being a zombie doesn't even change that - files can stay around
> afterwards, and it's not a problem.
>
> I really think the *only* bug was literally the whole "people didn't
> think about mm->dumpable as a security thing wrt zombies"
>
> (And the entirely unrelated bug of IO-time vs open-time, which we've
> had many many times because it's such an easy mistake to make).
>
> > I think that would be kind of ugly because here, the MM is not
> > actually used for memory management thing; instead, the MM is just
> > used as the one place we have that stores state that is shared between
> > threads
>
> I agree. Except it is *not* "the one place". We have multiple shared plac=
es.
>
> In fact, I wonder if we should simply just move "dumpable" into
> "struct sighand_struct" instead (or "signal_struct"). Those stay
> around until the task is released, and they kind of are more natural
> for core dumping, since it's about signals.

I think signal_struct is not unshared on exec; so in this sequence of event=
s:

 - task T1 is a non-dumpable task
 - task T1 creates another thread T2
 - T2 exits
 - T1 goes through execve and becomes dumpable

I believe T1 and T2 are still associated with the same signal_struct,
which means that even though T2 is part of the pre-execve process, it
shares state with the post-execve process and it would wrongly be
considered dumpable.

I hadn't realized that the sighand_struct is unshared on execve, I
guess putting it in sighand_struct might be an option. (An
implementation detail regarding that is that a task can currently lose
its sighand_struct while there are still references held to the task,
but I guess changing that would be easy.)

