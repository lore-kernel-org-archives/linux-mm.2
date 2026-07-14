Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CE71C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339A76B008A; Mon, 13 Jul 2026 21:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA1D6B008C; Mon, 13 Jul 2026 21:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1B86B0092; Mon, 13 Jul 2026 21:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF5A46B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:25:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A9A31A022B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:25:08 +0000 (UTC)
X-FDA: 84985638696.28.E3F9962
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2568A100008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:25:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783992306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=CCzQ4MaTuAF9muB7Q3mU57/scR9UaHk+mjBBlrFCA1Y=;
	b=LrbW/WK4edp8O6mK46ct27MjG8WIJhksyLtEaWVqo26r7CmV6mCbAhI5u7adXhcAgSrGC3
	C4o3pLjT1e8i/3hSMGwo6iXZMWuuC5e5IL1Kkl7z/0EAMSjb1mIUuAFVDveBENb0Z5ZJPw
	sn1t9mK+McNZ98hgxsuRxoW4BsSb6Pw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783992306;
	b=HOy4mEf8X99fBeJfYHgBqGpq8g+QnFmvdZ+Jq7SqxCvAaWXLO7+5Ft1TA0ou99BjsiPYqa
	Yps0Tnui0Ior9ukwoZUfHrVCRb65bSQfl+zh2xLxLbTCnt3kzmueH+YrhtNjEkcmD0BdXZ
	QDkAGgCaGwXo2A9F9smOgcQ4l+eI/NM=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gzhSH4Pcqz7V8t1;
	Tue, 14 Jul 2026 09:25:03 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 66E1Osf6062155;
	Tue, 14 Jul 2026 09:24:54 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 14 Jul 2026 09:24:54 +0800 (CST)
X-Zmail-TransId: 2afc6a558fe603d-93b08
X-Mailer: Zmail v1.0
Message-ID: <202607140924549782dUh3YBPmy8g1NDMK2zIW@zte.com.cn>
Date: Tue, 14 Jul 2026 09:24:54 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <baohua@kernel.org>,
        <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYzIDAvMl0gVHdvIHNtYWxsIHBhdGNoZXMgdG8gY2xlYW4gdXAgbW0vbW1fc2xvdC5o?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66E1Osf6062155
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 14 Jul 2026 09:25:03 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A558FEF.000/4gzhSH4Pcqz7V8t1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2568A100008
X-Stat-Signature: ph8huyt1oej8z71bjmpfkj9z91jyzbgw
X-HE-Tag: 1783992306-271047
X-HE-Meta: U2FsdGVkX19qv7L4pYY8jVI5I1jAIMSZtX9m0c/J5AbCNooZrHcXbYoahsr2D7SxOfYUXEyIDx6gNlQ9gZmFAG5ZitCqrkUcHKi9OB6Xhrqs5DKWnHMQRipjxACyNiXNSgFXSKyeuUjKbhbMGnZo9bNHPUa3GxAQ9MxGI2j1d2yCX7r2va1Xl2jTx8BcywJe7D/pB2br75nelGq7NW9UNhESwG2bn4rlsOB96nf38xyJ+utXPpWxAEPUJht86YuAAismXbiWNyflLcLi4ho88RdmVAsazDM5/jmi5YALgPcsOD+xit68ogVsHp3ElLJ9nCzm/qEoNUdk4YJIgW6ionylX5P2rAUQSdpBJYrjjCMPyVhiHmN6ABEGrW8zRs4MTrfe01d7gsgDmV71UC8pmglQlOvPjolL/S4sF2+HkadR6ZPyOiqXKWoo2m54ppm4D88zAoQT5+WeN6xvwB3TqpiS2MCSpFuFwVG89MNOdO7fBu8UWUEkIkVE9oCPQL8kEHqR+nbM7IW3hEBmvGlbu6+Wl3nVcQw4p6ckAjmHSHhIC94wLWq2o2aPiNjSCJC7iQVMAjweRCENXwvj5LABRpmqGhGKDIyd0zmyXxr+e7gaepnRIiZpTijopMcxeX7Ljm3Gj6xbcm7MejInKVuK56ZSctUFohio9DRSFU7YjPNFPBn8tCQ5dxHBBh3CVld/3KlGBZFttjxWBHXEsv+23/sPOCnFDrUkROH0qmMdee3Fo2az8tStGMRfVygzYTwWLaIZHlT9CC7SS/8I2JuX+xvOeLJEXFPRxJ3cocttpMbshPd+wCymq39jN4OE6X1Q8VHWQoCr9WZgGuZ8KBdt1N1seMVpdNDYOW5IzhqpTUhNe0PkxtprNfWQa30qRk47eRPtuqX7Fmcz3rEoA9aNPf36KSELVVFkkUH3j8De6rK1aj1ZnIc4zFIEsy2KVRVZoQnyUlMbYVw/tpvmjb3
 PR5LE+hd
 2i4swxGzFvHb3oycdsiR1BZunsv7WVtBDLwSQEqePSO0c88riO5uTVO7drrOKBxfkgCylX+EybocJP5KduXL7ct63llS7itSYkGCtWzJVvOIsimZ4EVcFIUJZRHul28M0FYv4Y8RtUqnwqQa0K0MNeYETk7BLSFkFmbCXIsvn+LZgdOGKnPImXYkL7WkFW6GsMoqccHWXc+VxRXU7wT2H2DYQsyuzk8wLeaYJXhzgObjUMPYxCT5/okE0OhLpvdI+p3uDEOz2f0Vdo2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

mm_slot.h is mainly used by THP and KSM.

Patch 1 introduces mm_slot_remove() to abstract the common
hash_del() + list_del() sequence used in both khugepaged and KSM.

Patch 2 adds a comment explaining why mm_slot_lookup/insert cannot
be converted to static inline functions.

xu xin (2):
  mm/mm_slot.h: add a helper function mm_slot_remove
  mm/mm_slot.h: add comments for mm_slot_lookup/insert

 mm/khugepaged.c |  6 ++----
 mm/ksm.c        |  9 +++------
 mm/mm_slot.h    | 11 +++++++++++
 3 files changed, 16 insertions(+), 10 deletions(-)

-- 
2.25.1

