Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10526C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 06:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AFBD6B009B; Mon, 24 Aug 2026 02:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184D96B0095; Mon, 24 Aug 2026 02:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18216B009B; Mon, 24 Aug 2026 02:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5A896B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:37:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4436416045F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:37:25 +0000 (UTC)
X-FDA: 85135206450.14.62D9912
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf28.hostedemail.com (Postfix) with ESMTP id E298AC0009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:37:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SqTN8SiL;
	spf=pass (imf28.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787553443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BE7h3+yxeVXfvWQuV0lNQ+7mLvBP685dQAMjbh176/w=;
	b=DsehLsqQQgQGScbZIi7cb/2xZHw6ZBFhzu50AiHQcvMCMVk7vHPAqjMtx6brapq4I3jv2g
	69uWtXcRn9B03EQYa70GW/XWsvrJuAj1Y9paxpxMopgputGG7ivYDmmG+6mp1vWVFbUtPE
	2jA3mK5NEUbbhgsceUhuk7kzwLYxG3w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SqTN8SiL;
	spf=pass (imf28.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787553443;
	b=23YTrHRWzmkpUHqMFAOhflvck7ajeu3QQn354v9rpFOkkYuz14Ajod91MS21ThQy8irE+S
	RppZ+QKVWZ9B4KKcEv7pVKZF8X8XynZwb0Q/byGL0LrPgGSR+g7+V3uyEjG3Vzdh+0W8i1
	P5keLa5PljkTokEenlMDCAdBAWbyRRY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=BE7h3+yxeVXfvWQuV0lNQ+7mLvBP685dQAMjbh176/w=;
	b=SqTN8SiLzFVGLB6RGHRM5cx5V35adm9PCquSVSY9SzdFLoq+ENurQWO3xKDbtynI6zvtQYhVY
	9TZoVOZoGiF/v36om0LaZkgIlWO3IGTEeuqLT3+jNrCTjUZpBw9ba/KTEFJSPX6mQjUs50qSqLz
	eGFEo6OTgjG3/kQJWileEXc=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hT1CF6338zRhR0;
	Mon, 24 Aug 2026 14:26:33 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 3D1E8203C8;
	Mon, 24 Aug 2026 14:37:16 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 24 Aug
 2026 14:37:15 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<shr@devkernel.io>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v3 0/2] docs/ksm: fix advisor documentation and comment
Date: Mon, 24 Aug 2026 14:10:08 +0800
Message-ID: <20260824061010.3343959-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: jm94p9abieneziy5ac8jpbxodjpuj6gb
X-Rspamd-Queue-Id: E298AC0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787553442-458197
X-HE-Meta: U2FsdGVkX19PPJfVRlUFIg/PWDl9QL8GkO3MESlbBzWR8hS0wcMIEDJFSapJcZgRfx9/8eRz8pvhMhuTTw1yEgKtu4G4JvUrE9DNTvi/qg3UbeyXOaiOCxwkrUBxwwWocZIELSLMUQ/SwqmiGU61BUMUptikC0XFau2mXXNXqzUBmWZh2ZqSXjFoTUssk5JoYaiam4eQFBPH4OqaIqgtGDTMa1lSv9hkmB7l+KalB8D4tHr/gVKiE9miq71Pz9RyLJPEqbpxoNDM/HA3SrOVXRxV6xtrUkGzIVBkF+V2qEKcFNaVoDIOfJsLdMSUDQt9sIA2B5++/eZhF+dtsdJwvIiE45rMrD4gBr8rYcaHP8XhYtxelJFQC8USG7KVsFNpjWfrIQcFZ32Y33kJJNRnoE6q4FBHw1GtQtPHBTowMwk4k0tx2sJ47i2UYYFIrgkfA5Wbz6wcV0UB/zfxsmU6C0Qrfx/cp0VfO4zBKY1/drO++QHBBhB7/gapp+AZ9DEXpZGNbK5KOwxW+IjmrBBea0dBMzeLCTW4tcgSQcY9Dsc8j612zAtFerXfZfW8c8+nhBFAP0N/4L3OwU7rlTHFRhigEQzBv6ypJxmwdNNccDa/qT7jDXOkYJPAhn+0gghKAIn/bGhehxbu3bgspjBSLy7+KCAhJOVqR9pjd+RlrGd/3QkpQXVrdWi6J+p22n7uoN8ECigiD2dfHVamZKf6M5DZBPEOmNgUVAmybFAJ4v9ct0H/8lFv6qU1G6ag6CkjUroAvEMqSwuOlNZiUTv4Sekd53Wd2y5/aR0w0+tWp4hT8MyHhHkunvgneSfP8Bn4KbTVqm9P91NOfHbc8cLpDmY6Z5gQehI1omNhAtjY/zc57Q3xBicUKsbYs2xdWQga0NIKR3ABL1o8Ev/r1IVsIUJC64S2vcLO1NeTlqXGvEKJuRMpLIKWtNL/hsQma3i8UJMiPc2FJFxqW4tjI1r
 lW8US9hZ
 JJCdZjL4KjJ3QtU3RnU6Ty3//RSVK/3H6HeoijhTvFaTzXzJt5ljIk9HQ+uJ39GXUE1kfVKurUG/Ef1y02YMIc51d8ek7VOCbsMjo8LcUwlFMyaO2VK0m7Y+tzodkpg8ZXv6Ixr046DHZIb3V3yiguSTZ4qLMMB7LXT6rS3T+f2VgxztsE7qLzfmqP2337S+daSnIt8lYKvO2r9h+rV1f18/5lCPvixxgu8TKRo80h3usg8VhxV69iQi/3COR6WxQ84Ke6++TPby0bNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes two problems left in the KSM advisor documentation
and code comment:
 - Patch 1 fixes two typos in sysfs knob names ("adivsor_max_cpu" and
   "adivsor_max_pages_to_scan") in ksm.rst that don't match the actual
  knob names.
 - Patch 2 fixes the description of advisor_min_pages_to_scan: it is
   described as the lower limit of pages_to_scan, but is actually only
   used as it's initial value, and the runtime pages_to_scan can drop
   below advisor_min_pages_to_scan.

Changes since v2:
 * update cover letter
 * update commit message for patch2

Changes since v1:
 * remove fix tags for both patches
 * update commit message and comment for patch2
 * collect Acked-by for patch1

Jinjiang Tu (2):
  docs: ksm: fix typos in sysfs knob names
  mm/ksm: fix advisor_min_pages_to_scan description

 Documentation/admin-guide/mm/ksm.rst | 8 ++++----
 mm/ksm.c                             | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.43.0


