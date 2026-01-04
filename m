Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C52BC2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 12:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B706B0092; Sun,  4 Jan 2026 07:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03186B0093; Sun,  4 Jan 2026 07:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39636B0095; Sun,  4 Jan 2026 07:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A078A6B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:24:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49893CDB7B
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:24:00 +0000 (UTC)
X-FDA: 84294198240.20.2003273
Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1B1A84000A
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:23:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=H1I1TrKQ;
	spf=pass (imf04.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.202 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767529438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/z+V1pSSbU+lSVDgvRDlrCapTmH2Lgc2n5gwlV+Ah1o=;
	b=svd9+pQ8/wNuj2UvZteBo1KgFZDv5KHhLBXatzYF7W76l2tdgM7JjRosvMxmT+CUAnZaPZ
	eK6/YvefeCEoqd/jHoMg97zKqc5vZKgX+8RVIhkXKf6AVoGdkfjX8TNV44mxRGpXpDRKTs
	CYjbmzViFP6JLa/6PYhc2R1qpwHqiAo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=H1I1TrKQ;
	spf=pass (imf04.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.202 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767529438; a=rsa-sha256;
	cv=none;
	b=R5dEbKkID0CszSayjthaO9k6Kj/tXqPB5q+5otNglGLcztyCj35qf+wlmOfiqQpdQd/OqB
	rvgJerMCKrb39AQ7tEpTWLjLsiB27Adq1rId8mVDIaeQI3D+/qhm8h5URVlfagXDyznkcQ
	YpVYgu6h7ehQUOUBBqWsPf31wIsaecc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767529433; bh=/z+V1pSSbU+lSVDgvRDlrCapTmH2Lgc2n5gwlV+Ah1o=;
	h=From:To:Cc:Subject:Date;
	b=H1I1TrKQ2mBD4yGsDnSGhX8hT1R4VQQaEOfXFV5bcPlK5idcBHcwXKNGPFVfo9Hrg
	 6hESCiw7dh/7888qJ9j9mVpWRjPsQUaIY1aAcYmp/v8VFuWP7oyEhhuqSkLNrqFnSn
	 53G+vOvhOifWEDw6mrQfMfRQarm3Lli8N0WeWkXQ=
Received: from localhost.localdomain ([61.144.109.141])
	by newxmesmtplogicsvrszc41-0.qq.com (NewEsmtp) with SMTP
	id 5F28C2C8; Sun, 04 Jan 2026 20:23:50 +0800
X-QQ-mid: xmsmtpt1767529430tyyo02coa
Message-ID: <tencent_C5AD9528AAB1853E24A7DC98A19D700E3808@qq.com>
X-QQ-XMAILINFO: Mzhc4BPq5polBqMa04Yr6MS1KL4SN5AC153qfj/d6YvlAeJCV6gnPKBTJjStfG
	 wyiPL0jQ8wTf4Zt3UFBHI03x7OwJo8imB4X5iJWcVu3qomT9qPjyO1Up0N6cZNavw4kc3UR6wUDs
	 ioPoKuYKl7amIxYLRllGQ20Der7dtv9kmDo5dn/jBncMUlATrZP8WVqheDGudSKW8v2FALxYkoSs
	 5HBAYeQ2sc24TpwThwjTOB5YKnCletN5XmrOq4g62GNE5Iw5gCAgtxqnXTW/IefSD/QBRP57Ubhv
	 +52IoCFtJJcRO1CTGPit//4VB/ADaO3o58BTQgm3figXC2m6ODipaxPHxbPmaUSyjPKStMVhzAf7
	 OXb8hRA6bqdY4MAc7crIpJI4XpRejmvLuMBQOCsC43LnysSWn50KNm/7IO1DP5QsbhkQNdiRNLNx
	 zwGDRaRgKexFUXkHZRsRKPI7qUPN6j57C/4mMAa01ddf5ORgSoghWxduOnzBol90N1vy7pyzq8mO
	 l4Xiz5gExVxwRci7B9XgoiB0j7iTVfr65JGxl6tWt9pm6QQqq9QLJfayi9ww2hh0OFF28w7EOnK8
	 ChOcDoUccp2cufxXU33odsdM9qBzHxaIlqtzkEPdswHyQUwYcbd1NieXPeqA3BpVEKPGfclciJc9
	 HaQ8/msiyLXuDpyod7KLOo9vopHPWD1Fk+5uRZA9go50dGgZ211nVrYHSmSUnFdbPGy30oHVP06s
	 mrxEfnUFah1MNybK0w70b28x+9J5bGMMC081qj4x0wvNg03krtn/AUNEVsqng3/mYfRzIei1gLWi
	 w2oKi8rd6hZZ0B8ItquNErdeptlaQwFaOnuhY/7rWCDRHYlQ/PpITiDp3R0BNBNA7uZo/nTvLQz0
	 HWEEoNJJ6XP2+zLwJOEzsBy0qM4WDHZWkjz5yq6P6LO0BlDR1X5KUvFGaljGN6/JLew8b/XmtcHP
	 7R/VH6BS62ftQfh+Upzr7P6adtFFIYgGPs8cbrO4vC4SLLboGbGyJ8t+YOntnhKF2HnIEQeFmVU3
	 Mz5uUdLnZEzjfbe5v4Yo+HL/CNrFbDvruUz4lMXXFpjzMA/jaLttE2ceSNFzB62BR3lHSpoYNlyt
	 l9yhqypA66aWwGBYGT/mIdOOi2YA==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: wujing <realwujing@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	wujing <realwujing@qq.com>
Subject: [PATCH 0/1] mm/page_alloc: dynamic min_free_kbytes adjustment
Date: Sun,  4 Jan 2026 20:23:22 +0800
X-OQ-MSGID: <20260104122323.1218248-1-realwujing@qq.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hzn6jhnfkzgf7g1ocdjghpg93knxb5s5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1B1A84000A
X-HE-Tag: 1767529435-426923
X-HE-Meta: U2FsdGVkX18xfWUKr4jpO9XTpTwgUxHYYBamzh/NyFWBQHl0+Wo95pbE7cBknaaIrOBjcDQxJeEpvKUXNCbpwqsqPDU01R60SEfoFIEH98nJrRSqSksyXui15O9Wm4Ne4oqbcg5/Ag4y7/18I+vZ3pH/iG3M7VsgBwKPfWyPDlWi+vvjxm7CMJ1VfeUTbw7ee70w3L+m6sh80JRVEZY9YrWliqVXCaSYrmCj1q8PXEXH9fS+Zf7VxgzSU00tnyPIQj//wecUH2vzzSzvYJtvPp1FmD2zmJve70jPilVsFJ4GuWR8630K4a1V15M4H6x9ry/osxtSq/gUn7Lkxui4Jla88pWQCJJJU7Nkz3dVdcYcGI1sk10VlhMPY42ZXM6aU5BCNv5AZVCFM6PH+t93yL8OJClO40gY45Qd363ekS6nnE6iFacN6zLkoH0m1eNHSupvQpDUCVjRWLLWGe3/jsWLxijkHYGln7P4QphuU3Yx7NBSXrxzKhzX1VU2b2yekI3cEQD1XZLur1C3xBINOd2HtCE/GThgX7d2lJ+uz/TJjz1bRW0MIfD8bzOJkdu+mgDQ+USJzamB/CNx75c6qYBOJWFr8xntiNoeAimluoOcLMvltznV6sujeGe+9IC1YxT9ueg3Uk0VvzbmhTvV85axBxp0y9r0MP6tH//aDGHf7VDORY7pQY9CCOG25jW7p72v7ejkSj7OcqL+usB+1SSTYKM0/5DK42hdmtH0toj+rKBzNSxor84+388nLmEEv6kyECPuzJBYZWdzP6/KZU4PaOor2m9MimeHEifeRgcpo30X7+wdpuenB+Vp1imTCGO0wl+L9Zro4ApX4H+tZ63h1NF4WdzVhdCOgi3mBUFmTBFYecwxbbhOhzaWbwq4NT8TXx+T0rSNdo9KsP36x3aW8oVgLJcR1W1Vf5xWolYh8L15EdrIBMmvus0VYoPYXu7iIeG3FG26bnHBK7F
 D6SRfem1
 G0hlfW3St/Qg3GWNcGOTrQPm99FAv04SIcbC6DgFs86qoqEy7K5o6GhPmoyMoWdAJSzLSDsIaH8P2aEOHkuxIQV61CmNOsjRQuXHXE0g+pY+NlDL8jhR88W05G69phcEd/Rznvv1j0hAfsTTyuwp+RQU+l0LI4svK13c70xmf2YyK5rK9HESB5IpKhCRkwqp3Iean2FE4aur4Q1PgA64ZG5bB1jPB5q7nMA04G72JL/A/w8J0ugA9zHq7w9xN6nn0Bf4M79xeLnOkv3DYKJic1MoAQ3fCpF08regu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic allocations (GFP_ATOMIC), particularly in network interrupt contexts,
are prone to failure during bursts of traffic if the pre-configured 
min_free_kbytes (atomic reserve) is insufficient. These failures lead to 
packet drops and performance degradation.

Static tuning of vm.min_free_kbytes is often challenging: setting it too 
low risks drops, while setting it too high wastes valuable memory.

This patch series introduces a reactive mechanism that:
1. Detects critical order-0 GFP_ATOMIC allocation failures.
2. Automatically doubles vm.min_free_kbytes to reserve more memory for 
   future bursts.
3. Enforces a safety cap (1% of total RAM) to prevent OOM or excessive waste.

This allows the system to self-adjust to the workload's specific atomic 
memory requirements without manual intervention.

wujing (1):
  mm/page_alloc: auto-tune min_free_kbytes on atomic allocation failure

 mm/page_alloc.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

-- 
2.39.5


