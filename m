Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46A92E83835
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 21:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F566B0088; Mon, 16 Feb 2026 16:06:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A296B0089; Mon, 16 Feb 2026 16:06:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D026B008A; Mon, 16 Feb 2026 16:06:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2769C6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:06:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1533C41C8
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:06:50 +0000 (UTC)
X-FDA: 84451554180.04.EE987FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 20ED840013
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:06:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kpnhcbom;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771276009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WkSVYigH09cL3jipx4bmEeLH3+RWwip//Y7161Ufmso=;
	b=Gce0RYyCl0vLA/lgcXCDSG0Pu0fCNSDt7+o//Uz89BAYdB385Gm9JHfCcByHmmSJSQIw5l
	q23NmLSzmGPWjNQ209Jcbl1hPbYcmhynQiCts9vcgdXAMep9kAktVexC0dPYkrYvmGQvEV
	y+G48Bdvt14aPHr2DIf0iyAL1bB8Rbg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kpnhcbom;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771276009; a=rsa-sha256;
	cv=none;
	b=naS0MJIPd6MWIvhgjjVG0EnhCHhl1X6gb3GagSx6HMVM3HdlDnlGoMzUDNml+MCv5jIn/E
	7TFCSwIjku/QX2pD6y1TfohVo6TjeAHg98wcA32Ix1TxYlJnp+9G0tRoCidOb1aplFGzZe
	1+e6/75WLa0cnHpoBwCJnPp4B0pGbeo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AFED60133
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B9CC116C6;
	Mon, 16 Feb 2026 21:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771276008;
	bh=NG+dm0s43ukyI2Anb776ST2gZS5qq0/DGcoJ9RFJq84=;
	h=From:To:Cc:Subject:Date:From;
	b=kpnhcbomUE/SnBdEgIq4mosGBFBn1Fi7UNxbdwVlPhJzZXc2hhLfK8x5PN6q0LweZ
	 2JTk1QRGYPxC+FhtQY+T5vW058BM3fngT3rh/1OBkc3CLaii/6RyC/YJfMFYpnRDx1
	 dGyCfrVS0+U6qfg04eZX7vS0ZdodsTBtzmJ9blP56pQbxMrPPqSVqiMDUJvY3j27w+
	 WR7Dcu3rGfS7VP9p60D2v54yPY1I1BWQU7n0MSP5XNJEVRMOMPnslUwD7B3ZD/ZTq/
	 hrAqlnftNmY4URIJWc/m6djJPwONal4ni2PMw2QUf2RvDgoeqTk9l2EjF951gSPCAH
	 uMz564vwy707Q==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Yearly Retrospect (2024)
Date: Mon, 16 Feb 2026 13:06:24 -0800
Message-ID: <20260216210625.68098-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20ED840013
X-Stat-Signature: gj5dxc1yyk6j1wey4n1eg3wj5uoe4e4q
X-Rspam-User: 
X-HE-Tag: 1771276008-79646
X-HE-Meta: U2FsdGVkX19HksFyhjeANRpINQwL/pCVvuUXIpGkG7wNEkoxMtslf1fH2Vv4ejJltmAz+AAOboaY2CrKKUCBXmn8GDpPhJb3FyPnSZxua05IrRzNbq7FpfKCfV+S3jMIJ2n1J9tcNqj6QG60LvQjUz4VFCcII1G2dB2Ft4JvvPQ/NwEmhLw0A64P5plJwEfEY6vCwswnRRu5C7uawmGpi/9aiTLLnfpQdSr1L7yvlwCmDiOyj6uaO3HOjKGBkpNnkZMwkcsUr3X8T/nfErXA6snjbD3o4sahk4ohZNwntEjv5UCfJySacSPd2pNA+7A1rWcrmIrdu5svqjWYzqCholTSZIT8/CCQHI1X45ohrvpZOgtU24oMV0CwFlfeU4t9cGKbRolW+B5L9S2BOq0+szuO3KfxAM2m54g4HqAq5UxYIt/vMEeZwx5u9kfM9zvrKCOepxfDKaJGkWP8zinTGTt9v0KVtqjWmSvVeOOQOEgPh3D1Y4BdK0uUQzPi/8KY4JvsWv0KdP0eMkcvucjpzEESTh5Hm348DGzcXf0zzMy+r0+Dp2vl7ZyYItLWoqvIR/+wz/VCzFTAzxBuNcTLIAYJ8DJGVobx88D9oUPNvXmnOR2aQSAsg+EZtwqKTkx/Ebu067XG3blIxOn9cgQYgbAHCHdkRab377DHuxLErad7ODZ5FeA/h2VaITE1nX4uR4CUKzIBNJO7Ql8nVtCIC6tiUo3vMqjkXuiJs6H8irYtBmamej1XKO177ldagJod3Z+ha7c0e/oxzzUTN+kPAdf5JbkIrhnsXA58KQ/hpL8SBnCJYaMrIV255Ovviac6L1X6OkUA6kTG/t8hW/eTWaFtYuEbbhngVvxa0u5yWH3wExkLLO93a2wVuyXffQo3qFrxSOCSowbbAVqLxoKG4NaNsA7q0vDamLn8ZxPQ5Zvjaka8cbSOA5BmcCSZ0dK8sVVgAUcpVMuCzKJ/RdS
 xKZllOkc
 bi0DIYLWatFKCtE35r3ZL7zmkk6Ia4Q+sWCiR+P/X5tiYjWU/rm5MRd/MnScRl1CTbDDAe/mQrGXXq6yhZcFgNB8pwubITqOYeaZH02nEcencuorDbuYZZ8d+erb2MGHsBF2/uH5SKcy447b4OkIUVrDWBtsi6dg88zNVvIb7997xvcKO/MEMNs6ErZr6tDoDih7oEJo3R+XgT+Zl9XFgR1E/BwWyH8BE9yiF00kZB3XQGM5A+KnVWI7KeIdxtFowoa0mB1Oxod7d4NklZ3KXkyN95su2LwkbDIF+6ESO6VIttbE9ax3MHgV4l8Uwsp9c06QDy5Ct6lO8ftOmH4cHTE5d9f9Wn3yVEgsKo1xyY9YfmtMH9SsFjdzgbOXwyfWuOSIvzY7lv9RIl4FsD76ZmdmE8Zx6nt2qqL5F5t3EU0g0+hVP4mwpfd/Pse20iesPmfnvZdz/r6LSFJGQcOrk5AXSXhFGyPCjC6RSF+mkVCsg7R3Jr3YnKgQbt42QuO/RRK1CjtrdQBE6CNYN8tRvVWKTMSLf4fd0bvlZKZqFs9ex9ITxwodCgqjb2K02tdBzP6G1QO9OCLdM2clt7WVe1fZfEGTvyx50Pq6FG/0noTuEmkaRksGrK4PhhRtIhkDH/YMqtFfYsINnSyrbW6BIV3roblsRDYthr4J4vc40S3khs3x0+QPtArg4p8cq2u/kz/NE7DtnXC33wkmc/HPFqFUNiSg9qNdJvGiN9YLOtZrBGoDXUxvDlUY3l7LMZ8RQiwv3h/XwC5W+Wa4egxURazV/AE7p4Hg+9x41x4GM7jpOGT81rEIM7zWwbmVkstqbO8n1cDMmL5RbflTjeMKwhMCIrEnAjETbEvoUYZKIK1xO1Z3Q3MCMUDD0JGkUBTj9xlIdpemW7MugMitrK/LSUR8kwoBVBUHRwwNKmSQ7BSd1rGBOSAk9qdGokAIYiHwF1hGvyVQEYq+ckqHy7EDjq2oPmiZC
 w/yxFzMM
 1LOVYcNUB1/7trqx1C0HPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After DAMON has upstreamed in 2021, I shared yearly retrospects for 2022 [1]
and 2023 [2].  And somehow I forgot to do that for 2024 and 2025.  Let me share
the retrospect of 2024, before my memory goes away.

Summary
=======

2024 was a year that DAMON has been more publicly and widely adopted.  AWS
published their usage of DAMON as a VLDB paper.  SK hynix developed and
upstreamed DAMON features for memory tiering.  Debian kernel team has enabled
DAMON build config on their kernels.  Citations of DAMON papers have also
increased from 10 in 2023 to 17 in 2024.

DAMON's status and future plans have presented and discussed on multiple
conferences, including OSSummit NA, LSF/MM/BPF, OSSummit EU, and LPC.

Number of development participants and commits have reduced compared to 2023,
though.  Hopefully that reflects how DAMON continues being stabilized.

Events
======

In January, Linux 6.8-rc1 has released, with feedback-driven DAMOS
aggressiveness auto-tuning [3] feature.  The feature allows users simply feed
DAMOS rewards for current aggressiveness, and DAMOS can automatically tune the
aggressiveness to convince the user.

In March, Linux 6.9-rc1 has released, with DAMOS aggressiveness self-tuning [4]
feature.  It makes the aggressiveness auto-tuning can work itself, without
user's feedback.

In April, DAMON was presented [4] at OSSummit North America.  The presentation
was focusing on the feedback-driven DAMOS auto/self-tuning.

In May, DAMON updates and future plans were discussed [5] at LSF/MM/BPF.  The
plan was including DAMON-based memory tiering and holistic access-aware memory
autoscaling for cloud providers.

In July, Linux 6.11-rc1 has released, with DAMON changes [6] for CXL memory
tiering.  The change is developed by SK hynix for their heterogeneous memory
software development kit.

In July, AWS published a paper [7] introducing their DAMON usage as a part of
it, at VLDB.  The paper introduces AWS Aurora Serverless V2, which uses DAMON
as its core part of memory auto-scaling.  Specifically, they use DAMON for
proactively reclaiming cold pages inside guests.

In August, DAMON project repositories on GitHub has moved [8] from awslabs
organization to damonitor organization.

In September, DAMON use cases were presented [9] at OSSummit EU.  The talk was
mainly covering DAMON usages from AWS and SK hynix.  Honggyu Kim, an SK hynix
engineer who developed DAMON-based memory tiering, has shared their use case on
the talk.

In September, DAMON long term development plan was presented [10] at LPC Kernel
Memory Management Micro-conference.  The plan was about how DAMON will be
flexible but also just works.

In September, Debian enabled [11] DAMON build configuration on their kernels.

In December, DAMON monitoring intervals tuning guide has published [12].  The
guide includes the monitoring and tuning results on real world server
workloads.

Features
========

In 2024, a few new DAMON features have landed on the mainline.  Among those,
below two features are noticeable to  me.

DAMOS aggressiveness auto-tuning feature have landed in two parts.  The first
part [3] on v6.8, and the second part [4] on v6.9.  This feature makes access
aware system operations nearly self-driving.

DAMON changes for CXL memory tiering has developed by SK hynix and landed [6]
on v6.11.  The feature allows users to setup DAMOS for migrating hot and cold
pages for appropriate tiers.

Statistics
==========

In 2024, 20 people made 157 commits for DAMON on the mainline.  I got the
numbers with name of the contributors using my script [13] as below.

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --since 2024-01-01 --until 2024-12-31 --linux_subsystems DAMON
    1. SeongJae Park <sj@kernel.org>: 133 commits
    2. Zheng Yejian <zhengyejian@huaweicloud.com>: 2 commits
    3. Anna-Maria Behnsen <anna-maria@linutronix.de>: 2 commits
    4. Honggyu Kim <honggyu.kim@sk.com>: 2 commits
    5. Hyeongtak Ji <hyeongtak.ji@sk.com>: 2 commits
    6. Barry Song <v-songbaohua@oppo.com>: 2 commits
    7. Akinobu Mita <akinobu.mita@gmail.com>: 1 commits
    8. Maximilian Heyne <mheyne@amazon.de>: 1 commits
    9. Andrew Paniakin <apanyaki@amazon.com>: 1 commits
    10. James Houghton <jthoughton@google.com>: 1 commits
    11. Ba Jing <bajing@cmss.chinamobile.com>: 1 commits
    12. Leo Stone <leocstone@gmail.com>: 1 commits
    13. Jinjie Ruan <ruanjinjie@huawei.com>: 1 commits
    14. Diederik de Haas <didi.debian@cknow.org>: 1 commits
    15. Liam R. Howlett <Liam.Howlett@oracle.com>: 1 commits
    16. Peng Hao <flyingpeng@tencent.com>: 1 commits
    17. Christophe Leroy <christophe.leroy@csgroup.eu>: 1 commits
    18. Alex Rusuf <yorha.op@gmail.com>: 1 commits
    19. Javier Carrasco <javier.carrasco.cruz@gmail.com>: 1 commits
    20. Vincenzo Mezzela <vincenzo.mezzela@gmail.com>: 1 commits
    # 20 authors, 157 commits in total

Huge appreciation to all the developers.  It was a grateful year to work with
you.

The last line of the output for 2023 was like below:

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --since 2023-01-01 --until 2023-12-31 --linux_subsystems DAMON
    [...]
    # 25 authors, 180 commits in total

So, both the number of developers (25 -> 20) and commits (180 -> 157) have
reduced.  Hopefully this means that DAMON is becoming more stabilized and
reliable.

DAMON User-space Tool
---------------------

DAMON user-space tool is also an important part of DAMON project.  In 2024,
eight people made 1,031 commits for DAMON user-space tool.  The list of the
developers are as below:

    $ ./lazybox/version_control/authors.py ./damo --skip_merge_commits \
            --since 2024-01-01 --until 2024-12-31
    1. SeongJae Park <sj@kernel.org>: 753 commits
    2. SeongJae Park <sj38.park@gmail.com>: 264 commits
    3. Mithun Veluri <velurimithun38@gmail.com>: 4 commits
    4. Honggyu Kim <honggyu.kim@sk.com>: 3 commits
    5. m8 <umusasadik@gmail.com>: 2 commits
    6. Yunjeong Mun <yunjeong.mun@sk.com>: 2 commits
    7. Akinobu Mita <akinobu.mita@gmail.com>: 1 commits
    8. Alex Rusuf <yorha.op@gmail.com>: 1 commits
    9. Piyush Thange <pthange19@gmail.com>: 1 commits
    # 9 authors, 1031 commits in total

Note that I was counted twice due to different email address usages.

The tool's output for 2023 was like below:

    $ ./lazybox/version_control/authors.py ./damo --skip_merge_commits \
            --since 2023-01-01 --until 2023-12-31
    1. SeongJae Park <sj38.park@gmail.com>: 1793 commits
    2. SeongJae Park <sj@kernel.org>: 58 commits
    3. Honggyu Kim <honggyu.kp@gmail.com>: 8 commits
    4. sjpark <sjpark@amazon.com>: 5 commits
    5. Michel Alexandre Salim <salimma@fedoraproject.org>: 4 commits
    6. SeongJae Park <sjpark@amazon.com>: 3 commits
    7. Honggyu Kim <honggyu.kim@sk.com>: 2 commits
    8. Andrew Paniakin <apanyaki@amazon.com>: 1 commits
    9. fdu <1050329+fdu@users.noreply.github.com>: 1 commits
    10. Puranjay Mohan <pjy@amazon.com>: 1 commits
    11. Puranjay Mohan <pjy@amazon.de>: 1 commits
    # 11 authors, 1877 commits in total

Note that I was counted four times, and Puranjay was counted twice.  So, seven
people made 1,877 commits for DAMON user-space tool in 2023.  The number of
contributors have increased, while the number of total commits have quite
reduced.  The reduction of the commits was mainly from my side.  I was making
~1,800 commits in 2023, but only ~1,000 commits in 2024.  I actually feel DAMON
user-space tool is being more stabilized.  I also spent quite amount of my time
that I used to use for DAMON user-space tool for another tool, hkml [16].

Paper Citations
---------------

Yet another interesting statistics about the number of DAMON paper citations.
I published two academic papers introducing DAMON in 2019 [14] and 2022 [15].

The number of citations for the two papers have quite increased, as below.

2019-published paper: 6 (2023) -> 10 (2024)
2022-published paper: 4 (2023) -> 7  (2024)

Conclusion
==========

So, 2024 was a year DAMON has more publicly and widely adopted, and extended
itself for more use cases.

References
==========

[1] 2022 retrospect: https://lore.kernel.org/20221229171209.162356-1-sj@kernel.org/
[2] 2023 retrospect: https://lore.kernel.org/20231231222250.140364-1-sj@kernel.org/
[3] DAMOS auto-tune: https://git.kernel.org/torvalds/c/9294a037c01564786
[4] DAMOS self-tune: https://git.kernel.org/torvalds/c/78f2f60377ee43b7f
[5] OSSummit NA talk: https://ossna2024.sched.com/event/1aBOg
[6] DAMOS memory-tiering: https://git.kernel.org/torvalds/c/a00ce85af2a1be49
[7] VLDB AWS paper: https://www.amazon.science/publications/resource-management-in-aurora-serverless
[8] awslabs to damonitor GitHub repos move: https://lore.kernel.org/all/20240813232158.83903-1-sj@kernel.org/
[9] OSSummit EU talk: https://osseu2024.sched.com/event/1ej2S
[10] LPC talk: https://lpc.events/event/18/contributions/1768/
[11] Debian DAMON enablement: https://salsa.debian.org/kernel-team/linux/-/merge_requests/1172
[12] DAMON tuning guide: https://lore.kernel.org/all/20241202175459.2005526-1-sj@kernel.org/
[13] https://github.com/sjp38/lazybox/blob/master/version_control/authors.py
[14] 2019 DAMON paper: https://dl.acm.org/doi/abs/10.1145/3366626.3368125
[15] 2022 DAMON paper: https://dl.acm.org/doi/abs/10.1145/3502181.3531466
[16] hkml: https://github.com/sjp38/hackermail

