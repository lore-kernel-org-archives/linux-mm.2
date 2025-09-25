Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66BF3CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 00:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84118E000D; Wed, 24 Sep 2025 20:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35008E0001; Wed, 24 Sep 2025 20:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A768E000D; Wed, 24 Sep 2025 20:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 82C628E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:24:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 296EA57993
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:24:31 +0000 (UTC)
X-FDA: 83925876342.15.93B5F5B
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 54D1A100008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:24:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=edWAVzhN;
	spf=pass (imf05.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=chenglongtang@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758759869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=N5GY9mlpgXi96MzyZHcqlVP47rvSfsk+ybtqzRDwO94=;
	b=AVUoygdHuzcX8A3W2FKPtn7eifTLPcMfnaRpab3m4RfdTPaKNPvsWVa9NWfBiFhZRW/7v/
	+velcDp8baSk62w+lEp+TbuZOQIHaoPxG2jt4o/RWesFBA+7Q8ZMtCR5S8LNSiSjlvLAi6
	FxtNISqOArPC3qJog3UF+UpTWzr4+IQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=edWAVzhN;
	spf=pass (imf05.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=chenglongtang@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758759869; a=rsa-sha256;
	cv=none;
	b=skxwxIQfIomIank/9BhRkAxf43jYUewHTT7+GuHk+UETd/7H0K73YIvwPWAJfaHUBEfKRi
	jIlPruXlyy0s8e1E6VcBaB7Mb4yy/lPGiPTalXpUw97ysYYh1R4+YV/NeUT2R5GcyYPRX0
	hnrcg/MK/4tX8OEkvbDsRBDrbToPYvg=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-57abcb8a41eso12091e87.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758759867; x=1759364667; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N5GY9mlpgXi96MzyZHcqlVP47rvSfsk+ybtqzRDwO94=;
        b=edWAVzhNOg2i3j5T3nZW+ZwHBCJ2gN8c49N3Lm5EEmdcUaMe3iWmmYqQfjhORAOSmc
         r9jtH142QfBbjJw91mrTuXbxsUqyks2OGSmKLw1d2A7qOv7fK9qSMaiphHfxg8kQHUZ+
         +0Sf0QY1kVIoWq+CEXaFHxJFfR3+WdRAi6EAfmsDCzg+4r/Za4AvIP0regOsxnXrrhi8
         Ri3qO0w+A07UrlI4+G6pxpKrEsLQPStmlwfivEx/UbGopQNT9PcSJxuWrggExgUy8GKW
         Sm5fdiiLvM76XhNFDW5YyMdFLfIZiCruIzgXkoew/lO8Zaa2iL9Vo/5aoyLUD9y9RrBC
         VVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758759867; x=1759364667;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N5GY9mlpgXi96MzyZHcqlVP47rvSfsk+ybtqzRDwO94=;
        b=ucfLvgobELQHu61cBLXWm33U9UtgokTOWX2D1gUczXzAzq1GEiH/pgymTmHjkiPzvp
         GLKNkwKfdkvVxldNBoTaVui+rMyiOpZtXSAbc7GCMPYEtnLz1IE7pb8fvVCoMiMY0NsU
         gvL+/dLsFZilrdrC5S8Pa52j9+MPSGDCKFV8Vu4XYDXlAU007GLTVZNw+3AYToMSUf6w
         JxGc+SqBsG7GaIWGbntY3/bbw98LCtuV4xZ5L2CAWz6N3jhsEGibpGyMdhaYqMpGwgFT
         s/Blm275CQQMCWNYiR15dP8m+YyTzgwGiJp3mcR6e5f+9bfnCZBrB+1URS5I3lWuZRmX
         walA==
X-Forwarded-Encrypted: i=1; AJvYcCW1nd5flqFUqueomWfLtCRb6L5PYP4mKRBDwcHb7X86fu0FONk7f/lybxAi2VCnc4HTNfP/8nc/Wg==@kvack.org
X-Gm-Message-State: AOJu0YyhIV9Oon9WF6ZdVP1L0U7/6OCkGYRhTc2VOkKOsfqXTbtXnOzH
	B4OW9JF5ImHTxWxRgl18a2b1F/fYF6IeSlAwWOzCTNNWvpzp2VNtXICTPmxuM6Tf2jZ95Q5jzfL
	W3t7tqwnZrvfqspXb8cj86YFPOPQtPErF4r4zVpMB
X-Gm-Gg: ASbGncvcxZHl56SW1ylafEKHNhVsx3bHeTbL5NnhOcfrr4IFwbVPYignrgg8BhMPOQn
	AxE07OIxJOlNm8cp/u/6nvgmYUTUHhcecQ6wGEdZGJrKfihmqbkyHuwJgTMAMVRZj6IHaHhylXt
	5IYz/1p/74KHiDNR7MWYD+3RM0VKUBBcEKo9NamGxQzIpdku8TI97fqDvaV0wnCpvIjyoqEXGK9
	wLyqZdSlRe9Kg==
X-Google-Smtp-Source: AGHT+IFMTp6PzXqAOklHKTSSqlZKQxPAgUWcFxwGJSpvnw3zitIle/E4vjsfTllBU3LWXVblWpybGuk/0Nh+BFP/2wc=
X-Received: by 2002:a05:6512:640c:b0:579:49:344f with SMTP id
 2adb3069b0e04-582ac22e335mr234859e87.0.1758759867086; Wed, 24 Sep 2025
 17:24:27 -0700 (PDT)
MIME-Version: 1.0
From: Chenglong Tang <chenglongtang@google.com>
Date: Wed, 24 Sep 2025 17:24:15 -0700
X-Gm-Features: AS18NWDKNp8A0L7cp_w6YgT49_RdHVek4F17PMs4D8suGX40a2jOmaIa1xotkO0
Message-ID: <CAOdxtTZJqgDNMtqsq51hQ0azanFPLXHMAJ-mRhRS6yjzYhMf_A@mail.gmail.com>
Subject: [REGRESSION] workqueue/writeback: Severe CPU hang due to kworker
 proliferation during I/O flush and cgroup cleanup
To: stable@vger.kernel.org
Cc: regressions@lists.linux.dev, tj@kernel.org, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, lakitu-dev@google.com
Content-Type: multipart/alternative; boundary="0000000000001fc47b063f95318c"
X-Rspamd-Queue-Id: 54D1A100008
X-Stat-Signature: sr83eksmc5s7rnqk5xwandec8d3racnz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758759869-365029
X-HE-Meta: U2FsdGVkX1/S/tDocg7HDiLPtJBKw37dVvAMmz0XH44ELRxY7vL9jctFL666bwxx7Xkin08+EUrFnrWeysYZQqDtGPPMHq1JGTP3Gaztz9ZY7lCsbKkCuf0i5sDSkQVFj0XlPTGQNjYwFxsXiPVcfbaUiLCZnSQgW8USy7L1zxIWjp4P3m+Hlofl3YVZTw00um2b5KE97CSEN6DITBv8VxswXvVMSSQHuXI6/8/5/aT+VmgYvElZJtaSrgkJf0WJ85B+s7hobknb19HvS6/yQ1tAUGkv0uEPSRnga2iEFkd3XrPg+6VwLa3Mv3ugMIzXyyPTpQfrmvWJ1ZXvM75+i5qW5w4gbPxCmSYtxrgUXJQibkngbXFDLz6Bjb3rfqKVf30IPdYlPMCzji3PZV/Zqm0U5mS/dDxO4V3EhXF1pIcSdNRUabgOH2atJgFP+zoSUxCiV1wLvsLZxux5ofi+HBHR//fxnk9pmYc38jYztnCP4d7QfFCTX7HPW9d/uQUcHQLrF1/BedkQqNk9fMeLQoNr9Q60Pg+RY9SHN2Q2fQpph//F5v/v2Z+n3Pu9Yl7SLoP+sMzekyp/94QDPGC/1Bcxwyhp6VeqKCOBow5ZBGrvu8Q2irqv9TiJEPW6g2r7DI5oTy5Z1gnDPWgT27DFBVo9seZeBT8VG9+GvzF7db3PHKiEswShNfRz8e914KyPvzldtCvBThkN/H6RsXuDRiJV/kRoAigULamuus3nfKNG2Sg3i117n6go9p7LvOtVLY+41S8SNtT1N7vPUtBIWm/jOYiDz1yVPTAnWrw9eSckAbYBRCqTpxgGv+jwmvfQ7pNilusp9oiHnzheeA0f3HjOgIHIQi0DSwk7my6JYgH8KQ9cv1mv7nhJlIth3bof3xiSTNtN0xKy8eRV1nBxbry/vbw+IoAfYQncZO3Jn0MyctvGDBePZV3FolAT1k747iSivJBqx5wvtkH8FJz
 JvG6LVUI
 VwCinE2RbmU96y66Ij5IvGxI+NkzaV0KVXDHKYIBJ8sqMn287IcD5XGZL2J0Gvb+Oay9BmciFV7JpCIoxc/f6b9StdkSW92Nr/zjkn55okoi78JpL0zxEhouWlnc/4QPBz3bUCygwe0bnfrsXl3+oVmMvbKlhgIhvrOwZiwalVvKKFhVaIsu6s3ochfAFNCVotOsRmoc32HxhPHzpkefcpbv0CYYK9fWL7G/Vk0uDTyHx/TkDkv5W9E4JdD/D018gzRD537uXPpWQLSxCOAYR3AUP2IDzX5vlO1PEs8XQBlleB6caZ1BRUePCT1qiM/AtJLEyIS9ehJUHVYtdNU7XpmxeTV/dVrMxg1HnqdRXQ3jsdlRgSz3nVQnQXEEUtJWPfjgpR+g0avpdrnrXIen0T6FiYnBc/xCD/GKpZswGHRMO5Ik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000047, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000001fc47b063f95318c
Content-Type: text/plain; charset="UTF-8"

Hello,

This is Chenglong from Google Container Optimized OS. I'm reporting a
severe CPU hang regression that occurs after a high volume of file creation
and subsequent cgroup cleanup.

Through bisection, the issue appears to be caused by a chain reaction
between three commits related to writeback, unbound workqueues, and
CPU-hogging detection. The issue is greatly alleviated on the latest
mainline kernel but is not fully resolved, still occurring intermittently
(~1 in 10 runs).

How to reproduce

The kernel v6.1 is good. The hang is reliably triggered(over 80% chance) on
kernels v6.6 and 6.12 and intermittently on mainline(6.17-rc7) with the
following steps:
-

*Environment:* A machine with a fast SSD and a high core count (e.g.,
Google Cloud's N2-standard-128).
-

*Workload:* Concurrently generate a large number of files (e.g., 2 million)
using multiple services managed by systemd-run. This creates significant
I/O and cgroup churn.
-

*Trigger:* After the file generation completes, terminate the systemd-run
services.
-

*Result:* Shortly after the services are killed, the system's CPU load
spikes, leading to a massive number of kworker/+inode_switch_wbs threads
and a system-wide hang/livelock where the machine becomes unresponsive (20s
- 300s).
- Analysis and Problematic Commits
-

*1. The initial commit* The process begins with a worker that can get stuck
busy-waiting on a spinlock.

   -

   *Commit:* ("writeback, cgroup: release dying cgwbs by switching attached
   inodes <https://lkml.org/lkml/2021/6/3/1424>")
   -

   *Effect:* This introduced the inode_switch_wbs_work_fn worker to clean
   up cgroup writeback structures. Under our test load, this worker appears to
   hit a highly contended wb->list_lock spinlock, causing it to burn 100%
   CPU without sleeping.

-

*2. The Kworker Explosion* A subsequent change misinterprets the spinning
worker from Stage 1, leading to a runaway feedback loop of worker creation.

   -

   *Commit:* 616db8779b1e ("workqueue: Automatically mark CPU-hogging work
   items CPU_INTENSIVE"
   <https://git.zx2c4.com/linux-rng/commit/?id=616db8779b1e3f93075df691432cccc5ef3c3ba0>
   )
   -

   *Effect:* This logic sees the spinning worker, marks it as CPU_INTENSIVE,
   and excludes it from concurrency management. To handle the work backlog, it
   spawns a *new* kworker, which then also gets stuck on the same lock,
   repeating the cycle. This directly causes the kworker count to explode from
   <50 to 100-2000+.

*3. The System-Wide Lockdown* The final piece allows this localized worker
explosion to saturate the entire system.

   -

   *Commit:* 8639ecebc9b1 ("workqueue: Implement non-strict affinity scope
   for unbound workqueues"
   <https://git.zx2c4.com/linux-rng/commit/tools/workqueue?id=8639ecebc9b1796d7074751a350462f5e1c61cd4>
   )
   -

   *Effect:* This change introduced non-strict affinity as the default. It
   allows the hundreds of kworkers created in Stage 2 to be spread by the
   scheduler across all available CPU cores, turning the problem into a
   system-wide hang.

- Current Status and Mitigation


   -

   *Mainline Status:* On the latest mainline kernel, the hang is far less
   frequent and the kworker counts are reduced back to normal (<50),
   suggesting other changes have partially mitigated the issue. However, the
   hang still occurs, and when it does, the kworker count still explodes
   (e.g., 300+), indicating the underlying feedback loop remains.
   -

   *Workaround:* A reliable mitigation is to revert to the old workqueue
   behavior by setting affinity_strict to 1. This contains the kworker
   proliferation to a single CPU pod, preventing the system-wide hang.

- Questions

Given that the issue is not fully resolved, could you please provide some
guidance?

   1.

   Is this a known issue, and are there patches in development that might
   fully address the underlying spinlock contention or the kworker feedback
   loop?
   2.

   Is there a better long-term mitigation we can apply other than forcing
   strict affinity?

Thank you for your time and help.

Best regards,
-

Chenglong

--0000000000001fc47b063f95318c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<br><br>This is Chenglong from Google Container Opti=
mized OS. I&#39;m reporting a severe CPU hang regression that occurs after =
a high volume of file creation and subsequent cgroup cleanup.<br><br>Throug=
h bisection, the issue appears to be caused by a chain reaction between thr=
ee commits related to writeback, unbound workqueues, and CPU-hogging detect=
ion. The issue is greatly alleviated on the latest mainline kernel but is n=
ot fully resolved, still occurring intermittently (~1 in 10 runs).<br><br><=
span style=3D"font-size:15.21px;font-weight:700">How to reproduce</span><br=
><br>The kernel v6.1 is good. The hang is reliably triggered(over 80% chanc=
e) on kernels v6.6 and 6.12 and intermittently on mainline(6.17-rc7) with t=
he following steps:<br><li><p><b>Environment:</b> A machine with a fast SSD=
 and a high core count (e.g., Google Cloud&#39;s N2-standard-128).</p></li>=
<li><p><b>Workload:</b> Concurrently generate a large number of files (e.g.=
, 2 million) using multiple services managed by <code>systemd-run</code>. T=
his creates significant I/O and cgroup churn.</p></li><div><li><p><b>Trigge=
r:</b> After the file generation completes, terminate the <code>systemd-run=
</code> services.</p></li><li><p><b>Result:</b> Shortly after the services =
are killed, the system&#39;s CPU load spikes, leading to a massive number o=
f <code>kworker/+inode_switch_wbs</code>=C2=A0threads and a system-wide han=
g/livelock where the machine becomes unresponsive (20s - 300s).</p></li><li=
><h3>Analysis and Problematic Commits</h3></li><li><p><b>1. The initial com=
mit</b>
The process begins with a worker that can get stuck busy-waiting on a spinl=
ock.</p><ul><li><p><b>Commit:</b>=C2=A0(&quot;<a href=3D"https://lkml.org/l=
kml/2021/6/3/1424">writeback, cgroup: release dying cgwbs by switching atta=
ched inodes</a>&quot;)</p></li><li><p><b>Effect:</b> This introduced the <c=
ode>inode_switch_wbs_work_fn</code> worker to clean up cgroup writeback str=
uctures. Under our test load, this worker appears to hit a highly contended=
 <code>wb-&gt;list_lock</code> spinlock, causing it to burn 100% CPU withou=
t sleeping.</p></li></ul></li><li><p><b>2. The Kworker Explosion</b>=C2=A0A=
 subsequent change misinterprets the spinning worker from Stage 1, leading =
to a runaway feedback loop of worker creation.</p><ul><li><p><b>Commit:</b>=
 <code>616db8779b1e</code> (<a href=3D"https://git.zx2c4.com/linux-rng/comm=
it/?id=3D616db8779b1e3f93075df691432cccc5ef3c3ba0">&quot;workqueue: Automat=
ically mark CPU-hogging work items CPU_INTENSIVE&quot;</a>)</p></li><li><p>=
<b>Effect:</b> This logic sees the spinning worker, marks it as <code>CPU_I=
NTENSIVE</code>, and excludes it from concurrency management. To handle the=
 work backlog, it spawns a <i>new</i> kworker, which then also gets stuck o=
n the same lock, repeating the cycle. This directly causes the kworker coun=
t to explode from &lt;50 to 100-2000+.</p></li></ul><p><b>3. The System-Wid=
e Lockdown</b>=C2=A0The final piece allows this localized worker explosion =
to saturate the entire system.</p></li><ul><li><p><b>Commit:</b> <code>8639=
ecebc9b1</code> (<a href=3D"https://git.zx2c4.com/linux-rng/commit/tools/wo=
rkqueue?id=3D8639ecebc9b1796d7074751a350462f5e1c61cd4">&quot;workqueue: Imp=
lement non-strict affinity scope for unbound workqueues&quot;</a>)</p></li>=
<li><p><b>Effect:</b> This change introduced non-strict affinity as the def=
ault. It allows the hundreds of kworkers created in Stage 2 to be spread by=
 the scheduler across all available CPU cores, turning the problem into a s=
ystem-wide hang.</p></li></ul><li><h3>Current Status and Mitigation</h3><p>=
</p></li><ul><li><p><b>Mainline Status:</b> On the latest mainline kernel, =
the hang is far less frequent and the kworker counts are reduced back to no=
rmal (&lt;50), suggesting other changes have partially mitigated the issue.=
 However, the hang still occurs, and when it does, the kworker count still =
explodes (e.g., 300+), indicating the underlying feedback loop remains.</p>=
</li><li><p><b>Workaround:</b> A reliable mitigation is to revert to the ol=
d workqueue behavior by setting <code>affinity_strict</code> to <code>1</co=
de>. This contains the kworker proliferation to a single CPU pod, preventin=
g the system-wide hang.</p></li></ul><li><h3>Questions</h3><p></p><p>Given =
that the issue is not fully resolved, could you please provide some guidanc=
e?</p><ol start=3D"1"><li><p>Is this a known issue, and are there patches i=
n development that might fully address the underlying spinlock contention o=
r the kworker feedback loop?</p></li><li><p>Is there a better long-term mit=
igation we can apply other than forcing strict affinity?</p></li></ol><p>Th=
ank you for your time and help.</p><p>Best regards,</p></li><li><p>Chenglon=
g</p></li></div></div>

--0000000000001fc47b063f95318c--

