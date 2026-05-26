Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A61F4CD5BD5
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 23:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF756B0005; Tue, 26 May 2026 19:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FDC6B008A; Tue, 26 May 2026 19:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E626B008C; Tue, 26 May 2026 19:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 429986B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:06:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99974C1CE2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:06:01 +0000 (UTC)
X-FDA: 84811105722.22.FDB5328
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf17.hostedemail.com (Postfix) with ESMTP id A5D1C40008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:05:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779836759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NfeN3CXEbyivrkOn1VZRpP21lvR610fFtzuMPR4WbjY=;
	b=8dCHSx40o1XZ4xreKHbxWQcI+1ofu2qIau2gCHLwOPFK9qLpzvUuACmFy6iFBztyBi21JI
	52wfw5mx57yoE+HxLHPgFSHtZx3Sw0LUoH0SYhuTflXnkJ5L21LmfR6cipo45NzKP04jEa
	YKpN5QyEK8mSeCIWOs8PkB5jZt61gh4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779836759; a=rsa-sha256;
	cv=none;
	b=lknR9M3GjfQL1rVj0QWizv42/Quq89ehmrNyuz1YkUV0L2VQ8CfdoZ5hYDSOujzHVpVjj3
	AmgFrY8SSSh+PyinXXr41ka5RGMVBxncKXWfmdK+6kwt71SOkSRKUQmoD/ccNcnEmVsaWQ
	RH+P24KmSjSeY4M9JFlvHqyeLOtc5PY=
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B8391C17AE;
	Tue, 26 May 2026 23:05:57 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 406AE42;
	Tue, 26 May 2026 23:05:53 +0000 (UTC)
Date: Tue, 26 May 2026 19:06:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Shuah
 Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com, David Laight
 <david.laight.linux@gmail.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, akpm@linux-foundation.org, Yafang Shao
 <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
 Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com, linux-mm@kvack.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 3/6] treewide: Replace memcpy(..., current->comm)
 with strscpy()
Message-ID: <20260526190625.3f4aca0a@gandalf.local.home>
In-Reply-To: <20260524-tonyk-long_name-v2-3-332f6bd041c4@igalia.com>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
	<20260524-tonyk-long_name-v2-3-332f6bd041c4@igalia.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX198cU+0hhRKHgHKCMGLiBRPea5RXN7Pa8Q=
X-HE-Meta: U2FsdGVkX1/HAlOe/gblRw+FZXAPz9aej4jZ5+qyN3IcF8eNqN8XtKUl9dtjJYbiVCa9qB8xOz8RSl8BKxIfrBXXKl/53pbAujRrubHFyvoWaOSh+p8/OxEHMlfhY5WwQXXNzez9ODxnM6sxMlxKWtVhL/tCJWEldrcmI/rkr4XcYdSBP1rAdLVNIJfU582Ivbj7bDwVXcIOHZfPO5PF/GOJK5xl1kt1mKnH7FyxI6TKS812kwImkYcBfg86KS476A18d1wmpRLaXGvV0+APnu4B2VPcH3FoAXiZo4wLr8+GEjEHbihz/oNlHHHqWNzWzilqWNFWKqNgKVxZHfbbJFHYJkVtpbMXcYQsAJxBOYgmrQC0U4pfYk/nW318yKL/
X-Stat-Signature: 9auk6eknhpizuua3h3ezkr7jmo9nfwem
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A5D1C40008
X-HE-Tag-Orig: 1779836753-129925
X-Rspam-User: 
X-HE-Tag: 1779836759-654357
X-HE-Meta: U2FsdGVkX183Bs7rxlnYKAP0PIKm73VL6b3HhiywHZT5tcIPzid6XL8Dez0DmgfyKw77Sw5NaqpLmJbV3VtfPI476ns4gcHM/m0xyO52k1z9HkQIqZY2iOpkV/GMQe2akhWwm4D3NBjf41zs7THKt8M8gSIx26qx8xYPNxcI+KRdsEt34+fw5EUgRwTf1jVIgHMXk9Q4zrDbeU7GilW+HJvl4Tmx0RtrOyHO38RpODt9Cv2HRUId+98PkC9g5vtwg1xPnvj4aBqMoiDENmCwxwOvVGVjJDc/racBbsznkKwFfvgkqUWz+/X/F7ERPGxNaVNlo5CsLyjMfkcSjFqeOhIn+6xnAc+uNUUEGJ4d+EuhJkUTT0QvSw2as3B1J99YxctWRCxmR9pycy+cVvtTmMGJ37D/J/FJ6NCBJq/lY2UnfkZiUfMcwdEHisA/8E987uP8vVp7uc0sCHgPergzLvhrMv60AuOK5uBOA5ZXhl/7PubDdA4TB9X/hCNHJmInQYrGlbtcblAPXj6MqwGFjcec6bJbx5qPKI0MoOYWhRz6wP+fcYEWOgm5TVxW5il4j593SHa3qF+xddRzrHTG/OswgU4MquX8ZLE19eH9a1zDxCSyz86hWd4BtNdRfKb0VN7CfO5Sf6X6sjQeH569gSk4o3nlVCfdv+zwRMd60caG1eZtDm6/glIanvAoB35UT/W2R6DvcDJx74bLd2Z6XQL2Bav/zKrtSJfCSS+SkJTJ/1nIW2V1AUb5XUOdye4kjbTj/2HvmNtTFJ9lpnd2CueV2KGwujVIirRHcOHaRsMlsFIlmgg1LU+4LieM7AKGdgxr5naAHly2OjCsH/fw4LsZ79XfuEbqxd3Az8PvAE+klzhEUAHO6B+O5dBTMOGvDJoCuFk5hFrDUxqwHRHULZuW/QUErxi0Wym/82dQ3eaLFPehQSpFmInkh10C+C/wTUyX2z9K4Q4cg4wXU75
 QmcICuGw
 IcPZ8UEalSX6TkTeV2qCdAqJpuS3UL2TK5eeElLB2bcKVmSMcZbxfVCv6kEXqLvVYquxw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 24 May 2026 19:38:53 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> In order to increase the size of current->comm[] and to avoid breaking any
> existing code, replace memcpy() with strscpy(). The later function makes
> sure that the copy is NUL terminated. This is crucial given that the
> source buffer might be larger than the destination buffer and could
> truncate the NUL character out of it.
>=20
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> ---
> Changes from v2:
>  - New patch, dropped strtostr() from last version
> ---
>  include/linux/coredump.h        |  2 +-
>  include/linux/tracepoint.h      |  4 ++--
>  include/trace/events/block.h    | 10 +++++-----
>  include/trace/events/coredump.h |  2 +-
>  include/trace/events/f2fs.h     |  4 ++--
>  include/trace/events/oom.h      |  2 +-
>  include/trace/events/osnoise.h  |  2 +-
>  include/trace/events/sched.h    | 10 +++++-----
>  include/trace/events/signal.h   |  2 +-
>  include/trace/events/task.h     |  4 ++--
>  kernel/printk/nbcon.c           |  2 +-
>  kernel/printk/printk.c          |  2 +-
>  12 files changed, 23 insertions(+), 23 deletions(-)
>=20

So I was curious to what impact this would have on tracing. I decided to
run the following:

    perf stat -r 100 ./hackbench 50

To see how it affects things. Hackbench is a bit of a microbenchmark but it
stresses the scheduler and thus, scheduler trace events.

I first ran the above and put the output into "stat.baseline", then I enabl=
ed
all scheduler trace events:

   trace-cmd start -e sched

and ran it again and put the output into "stat.before".

I applied the patch and ran it again before enabling tracing (just to see
the variance) and put that into "stat.baseline2". I then enabled tracing
and ran it again and put the output into "stat.after".

Here's the results:

stat.baseline:

 Performance counter stats for '/work/c/hackbench 50' (100 runs):

            53,165      context-switches                 #  11002.2 cs/sec =
 cs_per_second       ( +-  1.33% )
             8,010      cpu-migrations                   #   1657.6 migrati=
ons/sec  migrations_per_second  ( +-  0.90% )
            53,936      page-faults                      #  11161.7 faults/=
sec  page_faults_per_second  ( +-  0.50% )
          4,832.24 msec task-clock                       #      6.0 CPUs  C=
PUs_utilized         ( +-  0.12% )
        18,787,710      branch-misses                    #      1.2 %  bran=
ch_miss_rate         ( +-  0.17% )  (38.88%)
     1,452,653,496      branches                         #    300.6 M/sec  =
branch_frequency     ( +-  0.14% )  (61.55%)
    15,607,564,080      cpu-cycles                       #      3.2 GHz  cy=
cles_frequency       ( +-  0.15% )  (56.21%)
     7,648,608,518      instructions                     #      0.5 instruc=
tions  insn_per_cycle  ( +-  0.11% )  (55.82%)
    12,025,223,911      stalled-cycles-frontend          #     0.77 fronten=
d_cycles_idle        ( +-  0.14% )  (56.26%)

       0.808204663 +- 0.001059873 seconds time elapsed  ( +-  0.13% )

stat.before:

 Performance counter stats for '/work/c/hackbench 50' (100 runs):

            54,722      context-switches                 #  11041.0 cs/sec =
 cs_per_second       ( +-  1.35% )
             8,170      cpu-migrations                   #   1648.4 migrati=
ons/sec  migrations_per_second  ( +-  1.08% )
            54,295      page-faults                      #  10954.8 faults/=
sec  page_faults_per_second  ( +-  0.53% )
          4,956.27 msec task-clock                       #      6.0 CPUs  C=
PUs_utilized         ( +-  0.14% )
        19,304,657      branch-misses                    #      1.2 %  bran=
ch_miss_rate         ( +-  0.20% )  (37.27%)
     1,497,794,368      branches                         #    302.2 M/sec  =
branch_frequency     ( +-  0.17% )  (60.74%)
    16,037,658,236      cpu-cycles                       #      3.2 GHz  cy=
cles_frequency       ( +-  0.16% )  (57.72%)
     7,875,024,533      instructions                     #      0.5 instruc=
tions  insn_per_cycle  ( +-  0.13% )  (57.83%)
    12,344,722,147      stalled-cycles-frontend          #     0.77 fronten=
d_cycles_idle        ( +-  0.17% )  (55.77%)

       0.827636161 +- 0.001027531 seconds time elapsed  ( +-  0.12% )


stat.baseline2:

 Performance counter stats for '/work/c/hackbench 50' (100 runs):

            52,590      context-switches                 #  10837.7 cs/sec =
 cs_per_second       ( +-  1.18% )
             7,958      cpu-migrations                   #   1640.0 migrati=
ons/sec  migrations_per_second  ( +-  0.99% )
            53,819      page-faults                      #  11090.9 faults/=
sec  page_faults_per_second  ( +-  0.48% )
          4,852.52 msec task-clock                       #      6.0 CPUs  C=
PUs_utilized         ( +-  0.11% )
        18,933,395      branch-misses                    #      1.2 %  bran=
ch_miss_rate         ( +-  0.18% )  (37.13%)
     1,451,361,950      branches                         #    299.1 M/sec  =
branch_frequency     ( +-  0.13% )  (60.09%)
    15,683,586,735      cpu-cycles                       #      3.2 GHz  cy=
cles_frequency       ( +-  0.13% )  (56.05%)
     7,628,894,710      instructions                     #      0.5 instruc=
tions  insn_per_cycle  ( +-  0.10% )  (57.22%)
    12,063,750,082      stalled-cycles-frontend          #     0.77 fronten=
d_cycles_idle        ( +-  0.14% )  (57.11%)

       0.811536383 +- 0.001337259 seconds time elapsed  ( +-  0.16% )

stat.after:

 Performance counter stats for '/work/c/hackbench 50' (100 runs):

            53,799      context-switches                 #  10743.3 cs/sec =
 cs_per_second       ( +-  1.35% )
             8,095      cpu-migrations                   #   1616.5 migrati=
ons/sec  migrations_per_second  ( +-  0.86% )
            54,330      page-faults                      #  10849.4 faults/=
sec  page_faults_per_second  ( +-  0.55% )
          5,007.67 msec task-clock                       #      6.0 CPUs  C=
PUs_utilized         ( +-  0.13% )
        19,444,339      branch-misses                    #      1.2 %  bran=
ch_miss_rate         ( +-  0.21% )  (38.04%)
     1,504,382,421      branches                         #    300.4 M/sec  =
branch_frequency     ( +-  0.17% )  (60.42%)
    16,225,153,060      cpu-cycles                       #      3.2 GHz  cy=
cles_frequency       ( +-  0.16% )  (56.19%)
     7,889,645,005      instructions                     #      0.5 instruc=
tions  insn_per_cycle  ( +-  0.16% )  (56.30%)
    12,488,115,947      stalled-cycles-frontend          #     0.77 fronten=
d_cycles_idle        ( +-  0.16% )  (55.55%)

       0.835123855 +- 0.001015781 seconds time elapsed  ( +-  0.12% )


Looking at the difference between cpu-cycles of baseline and baseline2, we =
have:

  15,607,564,080 vs 15,683,586,735 where it went up by 0.4% (in the noise).

But when enabling tracing, we have between before and after:

  16,037,658,236 vs 16,225,153,060 which is 1.1%. May be low but not insign=
ificant.

Where tracing enabled slowed the code down by 2.7% (16,037,658,236 vs 15,60=
7,564,080)
having another 1% is quite an impact!

As tracing now slows it down by 3.9% which is a significant increase from 2=
.7%

I really rather keep memcpy() here.

-- Steve

