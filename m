Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1380F10ED656
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547D36B0092; Fri, 27 Mar 2026 06:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8216B0095; Fri, 27 Mar 2026 06:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6BC6B0096; Fri, 27 Mar 2026 06:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2ECF66B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:16:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4E2CE1694
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:16:57 +0000 (UTC)
X-FDA: 84591439674.10.4534C99
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 17AF420004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:16:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PR1RYbV7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774606616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WthTZaMy2BJ2+J1txdM2eJcQIE72Zdbwhyjf9kXV4DI=;
	b=2X92ryzIt9iOpNKW1Vyn44gr5h+7Swtb4rCKco0gscDEwoc34kDsPaB5iXsKB5DIKm4G+C
	ZEcHypLN+cApRsWNiPaXXtsqce54waLKIreCVnFoLL9Jvixl0md/pMj2VoK9cE+wZK9sLz
	zYFmUgHNCQ7bvcuke1rmOHonGV8geQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774606616; a=rsa-sha256;
	cv=none;
	b=xtwJcGEY6iwTZeM9kSW+4ggU1tixT/zp9YO1TVpWPGtI9Egyk+VQQl9jpfFrxf/oScKdHU
	AdtLni2TyB+2fbv7YFRizMBvOSryVK5TE9mtmtzDYiQXETkBYvAynRjaRhDzogEx5EjKUf
	TQkxMrk66KdSlX+Ph4cPCaeGMlS4Ehs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PR1RYbV7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774606613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WthTZaMy2BJ2+J1txdM2eJcQIE72Zdbwhyjf9kXV4DI=;
	b=PR1RYbV7qRtmkzE39wUIuSYmVE1LqNgDV+7oN71W3GwSs7Q5323+o9f45tDk8yeFhje7wR
	zJAfuyKeEaTnTfLCiXN9y1noHFclpYdNIjMn9XuX9jqn4CFeepDjCqUN1HCmbrQlGvlosO
	kWkarM/SIEMOM9VycfEOd9bL89WqhHI=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
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
Subject: [PATCH v3 0/3] fix unexpected type conversions and potential overflows
Date: Fri, 27 Mar 2026 18:16:27 +0800
Message-ID: <cover.1774604356.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 17AF420004
X-Stat-Signature: i1nksta1pxbunusriad374x4cw9osng4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774606615-154392
X-HE-Meta: U2FsdGVkX18AjAeg9qnmlCOg6aC2/G8rbhakFWRVa1Vlc2JxK4jopQwIvfQjaKJkyD6hxU4TUW4mojFIA+qk3HQINJ7ugMlDoP1jRjyyHLfkFlmBa6yU6h+IG4vbi/iSzOQzz1fCLfK4FCrOD4s7nvOOqd0rq/uE4oMixQW8TZ0bvyD9RcVOoi4QJYgAA4HW+FIPcxhB9kF5iumHyos2lUoZJ6Pzh+j8KnVKJVwa4SUoxO4YXJqw9awJQeRuTEZMWk4X2TI21IuAx1iOZhJ+MZ6b2GW+HAKSWX+n59tfCFFSnD+dI1dd6yJSucAaIKuBFvgDDyssngyXmVrULAT28uu/DeerO/GB64Z0m8+XyOksFULjGNkVuIKgkol2OiaBlRiZT9pOamV2lkUTD41FCj1ngk4UxEAGmmVnyP8sC6gxy0Lwr3NdM0e3cxaHz3CBrXznPI5cyf7loKe4eLkhDeDA5orYKVOG+KEvCpxt4X9iUPCjqQsUbMRy+pIama3y7l/wlBceguQ16Da0+QecreXkPyooMohWKks952ia33ryLgKhxX6XskbMZWJFEMfgbnqm0iEB4wRsiO7mjY0GOCTntb1W3g85jEFbENb7dgGgXWneV58INCcChUPwlATQTn6LClkL3JBAJ8Tx5q01cticUeVetl3ZcOeLwzEslnH7Ii2UQo/Z/8Z4tyjDDF+06SAtc8YOej5ursJmHv6LTLjkbI3wSqoWWfeJYYWn95GY3SWIyNilVJQafwpch19iTjXfJy0QlnkF83yCYPdxDmxyXec8g5gIRT19TYLDZaFv5Uiw/iHup6kovHu/qeeDf1cdZzsnyDVdo8XNamui1nImBas/F1AqdWufFei46RZ4qqE82mJalcUdhJpdmAqi2uHjLE5mWRNIcRyjyuMuRGbfgumGWuCf9K6S2AWxOM5x4gcfEkESA/d24HFKIxdf+AAl98qrYRVQH+Et+MI
 eFJLS3DB
 XFsdkuAER8vhzqRZG2npLKbkzWqJ8jde/IheiFtSFwSxAzT7M1cHf+hSNeWOL1OuZuZV1Wviw3gx/vnVsYKPZFim3iErLFv4txyRwn89xWV70WcWTn3C1pQmCczGVfii/dVRbU1P0AmlJSMp3daRXKcyD89gnLLr1cxYWOmkRHyDe/AZuNDzwWM7hUz0H9y7aJH05Ze3IcaJlcLY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Changes in v3:
 - squash [PATCH v2 4/4] into [PATCH v2 2/4] (suggested-by Lorenzo Stoakes)
 - split complex calculation into multiple steps (suggested-by Lorenzo Stoakes)
 - collect Reviewed-bys
 - rebase onto the next-20260326

Changes in v2:
 - modified all commit messages. (suggested-by Lorenzo Stoakes)
 - added a fix patch to resolve the unexpected massive positive number
   (pointed-by Harry Yoo and sashiko)
 - fix the print type mismatch in [PATCH 3/3]
 - collect Reviewed-by

Hi all,

As Harry Yoo pointed out [1], in scenarios where massive state updates occur
(e.g., during the reparenting of LRU folios), the values passed to memcg stat
update functions can accumulate and exceed the upper limit of a 32-bit integer.

If the parameter types are not large enough (like 'int') or are handled
incorrectly, it can lead to severe truncation, potential overflow issues,
and unexpected type conversion bugs.

This series aims to address these issues by correcting the parameter types
in the relevant functions, and fixing an implicit conversion bug in
memcg_state_val_in_pages().

This series is based on the next-20260326.

Comments and suggestions are welcome!

Thanks,
Qi

[1]. https://lore.kernel.org/all/acDxaEgnqPI-Z4be@hyeyoo/

Qi Zheng (3):
  mm: memcontrol: correct the type of stats_updates to unsigned long
  mm: memcontrol: change val type to long in
    __mod_memcg_{lruvec_}state()
  mm: memcontrol: correct the nr_pages parameter type of
    mem_cgroup_update_lru_size()

 include/linux/memcontrol.h   |  2 +-
 include/trace/events/memcg.h | 10 ++++-----
 mm/memcontrol.c              | 40 +++++++++++++++++++++---------------
 3 files changed, 29 insertions(+), 23 deletions(-)

-- 
2.20.1


