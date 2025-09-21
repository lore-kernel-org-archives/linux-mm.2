Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22261CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 15:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA218E0002; Sun, 21 Sep 2025 11:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB2A8E0001; Sun, 21 Sep 2025 11:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02D88E0002; Sun, 21 Sep 2025 11:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5CB18E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:07:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 569AA1403A6
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:07:37 +0000 (UTC)
X-FDA: 83913586554.18.5EA1753
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F6E44000A
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:07:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758467255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=IHBtu94qFv3HdMM7VTfYM32UmEicSbtOW2nqrqSI61g=;
	b=G+yfTdv9AsDTFOxUHuzY3Q5947KFhPayNgpFkgCRx11ZWlh7vRFAwtq6B9OU29E+8Nr8oE
	Hdscf7xMb6wpmrE5kTdIDPizrsAvRtICqejUAhjPicyRXQnuY63+T7tUkhrDp8sn17T+VB
	PYQ0MZGmkBs8sJOzQXaGCJKfpZTsIoQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758467255; a=rsa-sha256;
	cv=none;
	b=IhqGh3te3pZiKSSjVj2YX5KiFAcSRgUli3Sc5uGJs1w80nJ5R5NmV1582v2J3e1da5/I0y
	jwFd2hdHzR8xoTA3bZdksCsgm9iiPvvxiPIaN0U30RVsD8ZNGDILsxTBC6sBAYJIUqtY/S
	3nYgcvoquLV8NJf0dnln+j6u/d1KahU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cV8jr3Cy5z8Xs76;
	Sun, 21 Sep 2025 23:07:28 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 58LF7NMP070585;
	Sun, 21 Sep 2025 23:07:23 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 21 Sep 2025 23:07:26 +0800 (CST)
Date: Sun, 21 Sep 2025 23:07:26 +0800 (CST)
X-Zmail-TransId: 2af968d014ae464-25fd9
X-Mailer: Zmail v1.0
Message-ID: <20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn>
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <shakeel.butt@linux.dev>,
        <hannes@cmpxchg.org>, <mhocko@kernel.org>, <roman.gushchin@linux.dev>
Cc: <david@redhat.com>, <chengming.zhou@linux.dev>, <xu.xin16@zte.com.cn>,
        <muchun.song@linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjMgMC82XSBtZW1jZzogU3VwcG9ydCBwZXItbWVtY2cgS1NNIG1ldHJpY3M=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 58LF7NMP070585
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sun, 21 Sep 2025 23:07:28 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68D014B0.000/4cV8jr3Cy5z8Xs76
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F6E44000A
X-Stat-Signature: 5wpger5fesd7ri45micmfxsr68r8196m
X-Rspam-User: 
X-HE-Tag: 1758467254-995472
X-HE-Meta: U2FsdGVkX1+JkZLa/u7K2ZuM1FRij0CAJahR0cDcCbgs5UByfpdnA1RfZ1oVSaeHf2msuIRNcJA+dkzJAiCnrd+dNzzD2yotTY4aXN02d/fyfEn+NOBs7YZudZkxe/tUkbl1RJ7edRLDbrAVM9cbJPhY0fpWG8JoFsqpmSfsLi7gQnQ6Ndzb/1ZbAweJua92SfCCHXKBw+XfqDuJ9f7WBskPwlKa2fPtWanutT664Xr+K6JIfJ7MDhN7YHIxd+Yj+OLYkXL8ibQhHkmVNvL++wSFrnvwskAg8UfM0wTMAG6yharguGYUO5tD2112lYm4IV1NX5rs9VVaI5s7pibuka3QFslsf+nx75owey5kVC8biXN761VIIeuFvVnMrp+xOWnc0ElJIrMq81Ao2eMTII1/OiZPeXFwinIBTBqosh3jsRdNmKHQRNPc7bjdPXBA8l7SWHhADVCfUS1sqZShQIG8vfBjVgjujaUV5N8U1TSxbxig8lU26WGCb6++E4+P4xGKoqLnpGuSPriz3XHDb4r4Pk69fY+Ue4Wg/7fUpQRD5pRApjVEHa6Riamxy+l4CmdiTeJ4ZT174D3lP4alNWaXyvrMSajQDEQmXT9YxwNDOmIcfWcBGvNOh7/Tvf5Ox8J3RkUTAYd5EORBudWMNDcL0Rdg4N3S6x8b2uINlUSkFyTjDGxRBdCz/nwMf5KiSjuMZrpeQp0MUwi09fd9KQM1yHfcwSFK9J7JYGACoBf+3JimhkEPqxV5+d2YoR1CUyQ4m2w7c34x+musYVCHUMbUH3eli7SuYkDIT2NJbJ6vKjDofFsFM6Gnvb48pQQArizSYdw0B6pp37sIotTyN/ezZvgt/hd55Or2KJQmCvRDR/8jsxfVhCmXsptS3EQ+hFT4eZZSzyQz2wvi3qGW4LoTwbqdUt4TGb12xv94bgDaoSiY4alviwiuWhTapmpWXyzcSaiS1eJLwEt7i+y
 GgEjZq/9
 oVo7zggPhLiZ3BOxUJ8rB/qS22yqowhNbbGkQ2bGCMIQU6+z2myhA/YO8hMu3SBw0pd8ZOfn8xGBXVs/FjvsoGZn7nHGQQ1BzLp2WiG+U6wF60yjbHRyibkp4b39NdfNJger4pzXlRlpyb1NLK6b+qPzNH6j7xfCd1s0bvmTrGM23YilFUE3ySszLA1tSl9v+ISxzEKEkkwK/HO/qmENExZhEO1om1zaSjFH3BXRUW4OrKlGD69SU+Xd3Agqpc15/PxiuU3Cj9GwQI3A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

v2->v3:
------
Some fixes of compilation error due to missed inclusion of header or missed
function definition on some kernel config.
https://lore.kernel.org/all/202509142147.WQI0impC-lkp@intel.com/
https://lore.kernel.org/all/202509142046.QatEaTQV-lkp@intel.com/

v1->v2:
------
According to Shakeel's suggestion, expose these metric item into memory.stat
instead of a new interface.
https://lore.kernel.org/all/ir2s6sqi6hrbz7ghmfngbif6fbgmswhqdljlntesurfl2xvmmv@yp3w2lqyipb5/

Background
==========

With the enablement of container-level KSM (e.g., via prctl [1]), there is
a growing demand for container-level observability of KSM behavior. However,
current cgroup implementations lack support for exposing KSM-related metrics.

So add the counter in the existing memory.stat without adding a new interface.
To diaplay per-memcg KSM statistic counters,  we traverse all processes of a
memcg and summing the processes' ksm_rmap_items counters instead of adding enum
item in memcg_stat_item or node_stat_item and updating the corresponding enum
counter when ksmd manipulate pages.

Now Linux users can look up all per-memcg KSM counters by:

# cat /sys/fs/cgroup/xuxin/memory.stat | grep ksm
ksm_rmap_items 0
ksm_zero_pages 0
ksm_merging_pages 0
ksm_profit 0

Q&A
====
why don't I add enum item in memcg_stat_item or node_stat_item like
other items in memory.stat ?

I tried the way of adding enum item in memcg_stat_item and updating them when
ksmd manipulate pages, but it failed with error statistic ksm counters of
memcg. This is because of the following reasons:

1) The KSM counter of memcgroup can be correctly incremented, but cannot be
properly decremented. E,g,, when ksmd scans pages of a process, it can use
the mm_struct of the struct ksm_rmap_item to reverse-lookup the memcg
and then increase the value via mod_memcg_state(memcg, MEMCG_KSM_COUNT, 1).
However, when the process exits abruptly, since ksmd asynchronously scans
the mmslot list in the background, it is no longer able to correctly locate
the original memcg through mm_struct by get_mem_cgroup_from_mm(), as the
task_struct has already been freed.

2) The first issue could potentially be addressed by adding a memcg
pointer directly into the ksm_rmap_item structure. However, this
increases memory overhead, especially when there are a large
number of ksm_rmap_items in the system (due to a high volume of
pages being scanned by ksmd). Moreover, this approach does not
resolve the same problem for ksm_zero_pages, because updates to
ksm_zero_pages are not performed through ksm_rmap_item, but
rather directly during unmap or page table entry (pte) faults
based on the mm_struct. At that point, if the process has
already exited, the corresponding memcg can no longer be
accurately identified.

xu xin (6):
  memcg: add per-memcg ksm_rmap_items stat
  memcg: show ksm_zero_pages count in memory.stat
  memcg: show ksm_merging_pages in memory.stat
  ksm: make ksm_process_profit available on CONFIG_PROCFS=n
  memcg: add per-memcg ksm_profit
  Documentation: add KSM statistic counters description in cgroup-v2.rst

 Documentation/admin-guide/cgroup-v2.rst | 17 ++++++
 include/linux/ksm.h                     |  1 +
 mm/ksm.c                                | 70 ++++++++++++++++++++++---
 mm/memcontrol.c                         |  5 ++
 4 files changed, 85 insertions(+), 8 deletions(-)

-- 
2.25.1

