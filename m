Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86324CA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 02:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4A96B009B; Fri,  9 Oct 2026 22:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC376B009D; Fri,  9 Oct 2026 22:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376E76B009E; Fri,  9 Oct 2026 22:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 079726B009B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:11:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7178F806D5
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:11:09 +0000 (UTC)
X-FDA: 85305089058.18.9C929A1
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3274220002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:11:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791598267;
	h=from:from:sender:reply-to:subject:subject:date:date:message-id:to:to:
	 cc:cc:mime-version:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=En1ryKdt7KydxQo58i3vejglp8ezmRsPuj457Z5z6uo=;
	b=AvaOA5Nu+JfdzZHB3uAjqzm93is14zQkOg4EqiUXUAD9JCNAAbY0hYlhCVATRgAag/zXtQ
	OHgMUvhdTfi25FJZeXr1Y3mSE9qoEk2+yQQXE4JAztzXqfutma6b9as0/H9VlbM7kBKImW
	QJ+jezHlQPLQkpCqw8aePbOXJTZLrgI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791598267;
	b=bMxaCwnF9JV+VzXZdcq+YPWjJGKDuD+wkpJr+7uH9VEILvV6gRVOP9J7d4j/a52C0gbeTQ
	3wr+crOXJRWOVphK+7fpmRqaKPCLy8gzKdpbBGHODOAI8oSGfcHFZhiV1YWAiKAhOdigOp
	Swhjq/VG5DawxwYbF+yI+5EU1ajdFIU=
X-UUID: d3f94612c44f11f19a56ed5b684f684d-20261010
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_MISS, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI, GTI_FG_IT
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c4742f08-679e-42b4-9639-0b99e2b3fa2f,IP:20,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.3.19,REQID:c4742f08-679e-42b4-9639-0b99e2b3fa2f,IP:20,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:e05d1955835369e02df995000c9e29a7,BulkI
	D:261009193225U7GYPBLZ,BulkQuantity:8,SF:10|66|78|102|127|136|841|850|865|
	898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:1,File:nil,RT:nil,Bulk
	:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d3f94612c44f11f19a56ed5b684f684d-20261010
X-User: duanchenghao@kylinos.cn
Received: from localhost [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 205743036; Sat, 10 Oct 2026 10:10:56 +0800
Date: Sat, 10 Oct 2026 10:10:53 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: luca.boccassi@gmail.com
Cc: jianghaoran@kylinos.cn,
    avagin@openvz.org,
    linux-mm@kvack.org,
    kexec@lists.infradead.org,
    linux-kernel@vger.kernel.org,
    systemd-devel@lists.freedesktop.org,
    duanchenghao@kylinos.cn
Subject: Question about obtaining LUO session FD for non-systemd-managed service
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3274220002
X-Rspam-User: 
X-Stat-Signature: s66pukyyye96uaxnenqsmczq7i64w55s
X-HE-Tag: 1791598265-739394
X-HE-Meta: U2FsdGVkX1880XjlDtGsdrWOnCt5CKTXP8+iUDA0SjLHnE5ENBtUQeVjpINnGzDw4Smy9nARObrcbLe5cUu9dWgUG9jgYyrly6sRnnrpZSXkAg1EbmudtiDrl+UhNnOjYWL1T+QouRHB+fC97Ecj0PwJPfcI07DhAUdQBhGNniiuFHZFb3zBP1b/wWfghqdiYQvOM3xGof+SIeqZvBnlD+1w5o+5Zu8EuL0Jjwkoa9l6FcFL5n48RAmmcU9boU1sKpUH2pTHSbdbwM1sA1/XUZS9a2M9OGjK4GfkEcSqc4qUHmLJOqA/B54gkymosRjA46mcrhLyhWP0hHkBYToqL+LtTwNCuVrVkUwpprhoQo08KBSObQZVVwQhp6xCxwXosLJlDyCWzT+E9LAScIl8aNPdGksh79Q04Pq3ZW69Lr4Cw/mKCOW49kW9RRD8IgtySRGGia3Fm8ZzjCjYBCvuBwEtrkiMqpfA0BYmfOBuSAtyZmSOh8HXcmZIL5IWWIAqNcaCNGDpFiYSYuKNRzZCSJrZ220W+gmaBbPH6WARSLROvPjHdd6OKZuWauK3arlWy3QaBTXNUY6vKnaBW/1RkXkwIaBYaYduxpGEQqsdufsunvs+g/CAASkTwGoX7j2eJ8nt+7uJwi++SvTiaeWpTd2B74MGAAQecpcejadpRC/WrFIuUbVoVHiSRZ8V7H7jVbfqh7+pC+O3TL+yNv3Bo2ex8VQKY5n9YE6POaOwyYJ+6F/GglqOTjzZvbKQz96rWEKwj7qHLr2PxqX+6/isNqoAcymTD7RtHGYmeBU+k+3cteKw24gz1ZZQALToVD0e8klX4iz13wV8KgbgthAMQg4QkkbeItT4RqjDzJKiUN7pUIMejELx5OZ9yA1zLABaCRzSU4OXN8gMaL0W8a22k4Z9CbCu5u4YCofz2pxgkZBhZqwWwYQCYGs7I/wIay7FFcVD0ONUY0P62TEqJU0
 Ci/0R/zd
 FoK7e4GcZmQULRWPFGZA7g0B6HHJAPAnZOntLDNGvwPmzKEq64GdZgmqGhiWbwmcw9OC0NpkfP8GrVIYQ0IsUkbfJO3iyCGYl/nMSMY4YuEYCDsYAzCz3YjLEWaAy6/MLPSO/x53mInH64tTFxOo5dZDx6OuVh51udK6EATj8Qq2NpRM+TAyStDlwt9s9PxwKG7zvQ6XS3cwM4LhNF7qdCCfBKCPQui7RZ5YO6kgyiFa/vUv/LFMMbY6j4KugyCMO2WuI4Tef2PXaRO5POyI0RUzgxGPAmnrZRPc8+mS482Dmi0dW3efVFdpNYw==
Message-Id: <20261010021110.079726B009B@kanga.kvack.org>
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luca,

I watched your excellent presentation from the LPC conference in Prague.

I have a question I’d like to consult with you.

I am currently working on the `memfd_luo` feature in CRIU. My goal is to
leverage the LUO capability to store checkpoint images inside memfds.
After a kexec reboot, the image data will be retrieved directly from
memory instead of from disk.

Here is my pull request on the CRIU GitHub repository:
https://github.com/checkpoint-restore/criu/pull/3152

In the PR discussion, avagin suggested using systemd as the CRIU daemon
to centrally manage LUO sessions and access to `/dev/liveupdate`. I have
watched your talk and read parts of the systemd source code.

From my understanding, systemd currently provides a unit‑based solution
where child processes can inherit LUO session file descriptors. However,
this approach requires the target service to run as a child of a systemd
unit. As far as I know, CRIU does not run as a systemd‑managed service.

So my question is: for services such as CRIU that are **not systemd‑managed
child services**, how can they obtain LUO‑session‑related file descriptors
managed by systemd?

Thank you very much for reading this email. My knowledge of systemd is still
limited, so please feel free to correct me if I have misunderstood anything.

Thanks & best regards,
Chenghao Duan <duanchenghao@kylinos.cn>



