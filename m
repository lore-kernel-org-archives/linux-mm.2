Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE635606A7B6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747FA6B05B6; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E646B05BA; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4604A6B05BB; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 143C46B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:25:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9468640D06
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:53 +0000 (UTC)
X-FDA: 85390100586.19.66428E5
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id B115F180005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=nhXQ2Ame5+daf54wfwzPP3l2P6rp0yUdRpVe3pvTfes=;
	b=KHd6zQjub/Q5P7ZctWi50dxeHSHwN3wSLWZGPP3NYRqfQPSWco5QXca333UtL4CHp6Sw3N
	igRa9+ZjZ0yFxmqN4VnSY1D6O4cR3ZDrMNnsocXnWfp54S9UFvG/sXdNbWDgeYk+ixWZc8
	qNAlkLYdSDXNMXtioQj8EH+qNzEVs9Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622351;
	b=Igqf68Z8GpxJWrlxGk36TtvtcWY4aSF7n4/lsEm+dh4iIXx2vaDCNpv14/t+rI7U+w4IHU
	2qMX/+qzuOuBSKtM1t/pkDmlUUuP+olqUY01axg/lXi0bU4WDJUZAj903F3OSzi2j7f9GK
	AML+/sfkmph5Y4oOgihTe54gEn6I9+w=
X-UUID: 836a81b8d6b811f19a56ed5b684f684d-20261102
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:ea2e17f3-a9d6-4002-8a3c-1a5447129d31,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:ea2e17f3-a9d6-4002-8a3c-1a5447129d31,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:639da65dbf4e7f0356cae5a58ab4b3f1,BulkI
	D:261102202544SBVQ7N2X,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 836a81b8d6b811f19a56ed5b684f684d-20261102
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 721082814; Mon, 02 Nov 2026 20:25:39 +0800
From: Song Hu <husong@kylinos.cn>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: tj@kernel.org,
	tjmercier@google.com,
	ddrokosov@salutedevices.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 0/4] samples/cgroup: fix issues in the event listener samples
Date: Mon,  2 Nov 2026 20:25:24 +0800
Message-ID: <20261102122528.1498193-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B115F180005
X-Stat-Signature: m9jxpa68xpsobbgipstz3p14epmtpk9n
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793622350-193838
X-HE-Meta: U2FsdGVkX1/Yh5vN3tcmj4foBsVB2GOC8jAB8TpqNpnCKr1Xl2HfVdeXj8rfP0qu/Wk1b5Swy3paBxVpytQyeN63h73r01rw9OM3ek5DT482cxfX72FmXO9qyTRkGopcTCaFHb3C99/wSyKAZrJKHdFMUqDHNoYhK+37tkK31NSqxug1UpqZMHXJqVEVvFKOtOFvzsT0Ut1w9c0pPzlOIxLfqi79sI/BOgNva90hzXW8VpVVxELixIULTr1ONPnW6dBGMYsMZ0cvuf5eQay3HzUVzwQApokX6W5+TxK8pOYg7PKcVmRBVEUEQsCj34ky1HNy5q1Di13v2imUaZVCSwwh92u0KO8SkcwX9GXexIcBmkulr0WV9z2+gcqjwtY7K8v/6qt8b6zIZ0Ll7ESIH0Ixa7KRx1VZ09FK6pRiX5ULK/QFjOfZ60YY0tAncyGc7dx7jvY9zuP0bmDjqEjPbZr6hGMjwQq7bx5EPL25gOpablmVc5D6bpi9X/48O45yhzCnZHUcS5xV4b4ngRXepXaHUhDQT/fFp/f1MDLq4MnNRrWOm496Xib2Ufd8sHAtFe4tIYxigPIfjCHHI6eADFPWS6bQr0y8mz7OXW3NKGY0b9E8zUee20iG9GXwW7GhPdvONCeRkKnnXmwWBpSVvw0Y3avRrWNJcN16RxeYMF5XdgQeGV+LVyQS7XEg9K89q6whsZBwQ58MEhsIJSFkGl6s1cPJ1Zyc1ts5fsKq9hzczoncPf+7N7GbQEKQ/r45bQ7A8A5Ep1z1z0XeEtnf+vkuZa9muF/IJ3bgUWpfHjTkkqsYjrHPcS9JKhYppvBfBCdq/cA9cFwaKHd7zL3NikF4qdeDIqKSe4VDlsr+6fizbe+x3SEM1k6ZeBV/0OOdfdVejXH0EbkO5qCaLHiP/fJ+KDRnjqsYZNj7X/mqNRe+FFRotMugFrPzeK354IlDxcX64eMJjFcJErk+sJa
 521CrRZg
 wEDyC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The two event-listener samples in samples/cgroup mishandle the
lifetime of the monitored file and poll() errors in several ways.

Patch 1 fixes the poll error guard in memcg_event_listener, which
tests "errno != EAGAIN", an error poll() never reports, so an
interrupted poll (EINTR) from a signal exits the listener instead of
resuming.

Patch 2 makes memcg_event_listener exit cleanly when the monitored
cgroup is removed.  Since eea5d2bb34ba ("kernfs: Send IN_DELETE_SELF
and IN_IGNORED") kernfs delivers both events on rmdir; the sample
warns and keeps polling, so a supervisor still counts it as alive
while the monitored cgroup is gone.  Verified against a real
container lifecycle: the unpatched listener stays alive across
docker rm -f, the patched one exits.

Patch 3 arms the inotify watch before reading the counter baseline in
memcg_event_listener, closing the window in which events were lost.

Patch 4 stops cgroup_event_listener from letting dirname(3) modify
argv[1] in place, which truncated the path reported in every event
line and made the two-listener setup taught by
Documentation/admin-guide/cgroup-v1/memory.rst produce
indistinguishable output.

Patches 1 and 2 were verified against a real container lifecycle
(docker rm -f) in a QEMU/KVM virtual machine; patch 3 runs on every
listener start; patch 4 is compile-tested only.

Song Hu (4):
  samples/cgroup: fix poll error handling in memcg_event_listener
  samples/cgroup: exit cleanly when the monitored memcg is removed
  samples/cgroup: arm the inotify watch before reading the baseline
  samples/cgroup: don't let dirname() clobber the monitored path

 samples/cgroup/cgroup_event_listener.c | 18 +++++++---
 samples/cgroup/memcg_event_listener.c  | 50 +++++++++++++++++++-------
 2 files changed, 51 insertions(+), 17 deletions(-)

-- 
2.53.0


