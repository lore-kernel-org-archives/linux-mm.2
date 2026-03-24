Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B12E7E9A76B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016736B0089; Tue, 24 Mar 2026 07:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1BD6B008A; Tue, 24 Mar 2026 07:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1706B008C; Tue, 24 Mar 2026 07:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBC626B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:32:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6DA1D141AC2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:10 +0000 (UTC)
X-FDA: 84580742820.23.815495A
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id A857818000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pseQP1QL;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774351929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OOD+Ib2r6PaW2m7qokKSBfl8HDaIHbYEUH90O4nwHjg=;
	b=0c9F/vJ5iOTRUhg8ra8SVEE/1eAfv/ki43FQDXlY6HwODUIVkR4A9JzFnxQS5965POt4vN
	n1ecDrNLwQmqdS34M1oyYfvqCrm5zK7jdoJmnhFKEoFiCLroDvjOzKgTP4Uj4/eVX+IlRC
	D7lCYwEiUXGtaQi9ec9Z+ZTQ54Mzqvk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pseQP1QL;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774351929; a=rsa-sha256;
	cv=none;
	b=XUnWJZiEPQoWOKdiceZAbqmlbS8XPKFOc/By67KRQjKblY6wn4Gob56zPAxMVS66kxC+r+
	igfYEspg6BlyK3R2PSic8gc58cifepoYk7bHk0CcTVsRVqplA2aeXlGB0ZvpkkuvBdtIn1
	qXYlmXYlMR/Bdvvg6/9Paz+GeIueNaQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774351926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OOD+Ib2r6PaW2m7qokKSBfl8HDaIHbYEUH90O4nwHjg=;
	b=pseQP1QLliNOxG7ecMtLJjShO3ZbGrk44jUXtPZGNfcBhIG05LAlJ9EzPuCClMmVuVfC1n
	3zp+U7RnoMs/WbxtHj7+J8BSQfdX4Z+zzuN3r6NQ+mZB6C9Ep+ZMIQ4WKq8Kd1pPfeYlSg
	EthEye3hxkLry+uCilampI60k8PeVZA=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 0/3] correct the parameter type of some mm functions
Date: Tue, 24 Mar 2026 19:31:25 +0800
Message-ID: <cover.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A857818000C
X-Stat-Signature: kj7oapez9o8hpdo4nxp1jb1knopuihmk
X-Rspamd-Server: rspam06
X-HE-Tag: 1774351928-548481
X-HE-Meta: U2FsdGVkX1/HqeCBPVjLasEpUtjPS/A1hi/iN7PJch1O3L0DktZ/4xxNUrr5NneacYor0zgTdpelIoCBdJP5cJuAaNGrNVyRBkF1340iak215m26uEbx2uaFRpZAfS8G/heNkR5D5WUPG93jRCCuNnrfw0bWS2ZlnvqJrSDpYaMO6TIN/06dKh6QI/bMhokgcVkL1NZVikBQ9tSwa41JfC6xmRiE7HXCmwte64UkQKDLM4NWv3X8dDPsu3xwS6RqurrULYb5nfoAVvhNYywHr8U+wuNCB6iICQJEP9eCT2+Uv1vSag6csC8zKtZXfXDcoYzeHslXgJGo5vsHZq4W9CJEag+ttSZSnJC/GmL5wRB1xmzyo31LzZzs1bCtW4Cbid8ophlqaCTRPFxhi5EXzvX497p4m+9QL2wsXSlxspH5DOry1Kt3S+xxeHR/uzd5s49u3mBHV3AB7QoNl+6e3/fbGq81Qtq4u5XEFTDiBkNKmDxieBqKItKaXliW7UPMxI6ywTNL/AfcY1j78oI/eVC+kklg37h040ie8ROVhwXy5lhHr75CD71r7Vujowm6vr4ajNu/gTT6nf6Tbo7c5PUC5FFKbJBuiqNX6qeV3fg29uInoKDrpaW4cuB5rfTU5W/hwMdWZ7oC2YChc9ttGoQKy3ZGJNML4132wsYRfCrra3iz+TIW67SK9jXG3f7x/5tT1whUxkB/BIIODx/NFBfvPi14Fs3ceCB58hWN+85+scCcB2VPBh0yalD6JONVLAsh4O7CMzzQVNQqKMMZ6tUWs44NUlg7Od34D+sSxsa1slwqqI36Lw7Jw4deCpNRO1RKy6APK5MQgQxA4Ihn9HsO/3mwl4ERpjIRQxuEO+un9N5FfGvjgewF7ltnWHl6Mxtueiw93tB1+yHiN124BNTq2bdqPz5lrbxhF8OHvgcppUwnf2rOWrC9ZU8cyYp7j+habzknRTxHsWMDYBF
 tZ+pgYjL
 E5jOZGHsHT5Ys07OAW5hpChtL5U7P3GDl3zELfnDZR8wgtLvOqM8EfPivRnWNLJJruWXW2tiet1vB8bOFicRm43m9kaStuCx3ErHqmZg7BaY3X74YZjAUDFeNgzDYNFH2GGBrV7aIcUVGLJHGNNWSsN0gf5X1Z3bhVK3d4FmEye2kQOYO5rXFzazwg1Ks8b2/DsMRqjUpgFjdR10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

As Harry Yoo pointed out [1], in the case of reparenting LRU folios, the value
passed to functions such as __mod_memcg{_lruvec}_state() may exceed the upper
limit of int, so this series aims to correct the parameter type of these
functions.

This series is based on the next-20260323.

Comments and suggestions are welcome!

Thanks,
Qi

[1]. https://lore.kernel.org/all/acDxaEgnqPI-Z4be@hyeyoo/

Qi Zheng (3):
  mm: memcontrol: correct the type of stats_updates to unsigned long
  mm: memcontrol: correct the parameter type of
    __mod_memcg{_lruvec}_state()
  mm: memcontrol: correct the nr_pages parameter type of
    mem_cgroup_update_lru_size()

 include/linux/memcontrol.h   |  2 +-
 include/trace/events/memcg.h | 10 +++++-----
 mm/memcontrol.c              | 28 ++++++++++++++--------------
 3 files changed, 20 insertions(+), 20 deletions(-)

-- 
2.20.1


