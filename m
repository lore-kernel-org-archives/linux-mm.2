Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09034CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B8C6B0093; Tue,  9 Jun 2026 07:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7230F6B0095; Tue,  9 Jun 2026 07:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660236B0096; Tue,  9 Jun 2026 07:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A16E6B0093
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:45:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03D9C4056A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:45:57 +0000 (UTC)
X-FDA: 84860195196.03.808B913
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0AA921C0007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:45:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KHfCunVK;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781005556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ysr2Lr9gLOb2elxHpNEW7Abno5MCuUNT7Ueh/hUfyEc=;
	b=ry5bs20n+ueE4x7vpGGI20B6kNOrwLOl0NieEU/KPJfxVCKT+0WA54pM2ZZbuUeLtElEF5
	P+8xGCy0n4AKC/U9gkwXb3T0ojLERUTHuGfQIaGnJnx41tr1tBwD3AAVLdoVcAaQa2i9Sx
	RU4a8Qjm6MnCrtiiqtZxKU8TrUFFvzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781005556;
	b=lY5H79Y/8zdi9unDcRmz7qhU9hTYi6FKIHf4DdUGSXbc394Gz5eq51As16NRVI97buw3d+
	/gEnOdZ0rdGuawid3k9H7MB5rd5vYzoqIxuSSFDsmcig8iUfGx8oFx+eN9Xm00iYM+J6/j
	07C+iA7FicmlUDj/HaCiCMbIS8wg0Is=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KHfCunVK;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781005555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ysr2Lr9gLOb2elxHpNEW7Abno5MCuUNT7Ueh/hUfyEc=;
	b=KHfCunVKBkAIi/gBbZwWkq8wIX051iLGqQBvf1bhHBoYeN6ecXoy6k6aip3stFKN1SWP8n
	5Yf29mVDh/RIHGGoYKY6FBuDmz528ANoTI9daN5+nOdj4zVs/xYAoi/7n4UKBvGQqYHiNM
	KMrHPCkICRYZi32F1HYAb0ZPBpBVjFg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-569-zd-4kSrpPcW3WWUP4yqqOQ-1; Tue,
 09 Jun 2026 07:45:51 -0400
X-MC-Unique: zd-4kSrpPcW3WWUP4yqqOQ-1
X-Mimecast-MFC-AGG-ID: zd-4kSrpPcW3WWUP4yqqOQ_1781005548
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D330A195DE13;
	Tue,  9 Jun 2026 11:45:46 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.33])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 35CB11955DC9;
	Tue,  9 Jun 2026 11:45:36 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Usama Arif <usamaarif642@gmail.com>,
	Yu Zhao <yuzhao@google.com>
Cc: aarcange@redhat.com,
	Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH mm-unstable v1 0/3] MM: Tighten control over zero-page remapping
Date: Tue,  9 Jun 2026 05:46:12 -0600
Message-ID: <20260609114619.144416-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: hFwMRFHhdzeLxrdsukYKGQsG8yNv85b0U-dCiCKolA8_1781005548
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 0AA921C0007
X-Rspam-User: 
X-Stat-Signature: xepnge58xhxz7pya6kc14zxwi4ktfn76
X-Rspamd-Server: rspam08
X-HE-Tag: 1781005555-86969
X-HE-Meta: U2FsdGVkX19QdeoqkqLpcfORpIghyOOG11gvg9l/tPeEvk71a7iiwV1hAbR6nkQsYuf2aLRqUvGjU77EJuCBz8KIwAla1YX+bGd41idw69P8vFhFz0qczhFzlELjvg72lPSeQOnVTzcozUeaJzuFFW3izpK/Ne+mZUEiAzyY+tV6/DbfLXLkeRSJ0utvWnn+xQuXt6ohtxOFVcCid5rQr8XB3Pz+DQjIQwN9DjGlMPN87zMLqa8OBl/9ZWb384o3IFrvmigvfUFbEyE3+CniX7/UPqTQNbT5LqfZI8tkDyAe1dscqp9cRGMg1PXn0othd9OhktnbCDlKmKS1IQgH+YLgnOLGMQnClKKW/GySjhoojj671dQ6qYvejlALvxvgvdR9h4n5S9M07vMTTKoN+6UkoQP7WYnsanjK4TgLZCofoT6ZKrBF8uI/pdv6Aul1QNWm6SQ7Yxi6PLZQYxKyUMXGYlQUT2IEYiFvn1wfsR+xD+CIlU+mfxUJZMiPUACgtjEgDkAy1jOXgxDc2zVKUYSC1fPtFjfHu1g2vSrT3XrkFMAdie75FIgwbswGzi2gBFSBRtgnqn1UaVs4I8TVy0/H/fja2kOtvT/fxvk56NVnsudpc1QV8SBUg5s2wWqzih0GukM87shQHmBaVp8DQs5iWry2RlfRPVbnh+gkilPyziIOSviJbn46ViK5K5L9AbCpzByGP0nVDDznVJc1uWzS9x/MVwHhDs4AtmlJcU3mqOGSqe07K89m+6TywzwlM+4NjG/gTkdjxdbFal+50dqFVN/NOAzWN9wUZPhtOSLdVGSNDHZ+CcpQ5A0ZFba91caM2PfXQwuHtdsZJ0QELEbb6tMKau2jeboTkLkGXVRX3HFNLNawEPp8977gagbRjsFv1znpEiYcaOqIaXW7B6fNvUNwnoLZXS73KqdpIuAI5anWLpHLBBC/5/nJFiXMsN2GPoeuQFpNayXwhO5
 loRKE9Vr
 RFcOYnDuvZJ5+J0zSUxrs46s8EX7/qQnC05op1Vq9fa5X8yXeREKii7wh5WLQ3YZ8f2kqz2UQ+ozzkzvYJcteTqwMKkEVc1XOEiIHevP8SlC3GrmpFdXmsjtuKDxQPIdBHqFR9NbO48SC5FgiM4xzRxJ47leCjfvkjukiMWu2q1oKlrcqemOh7D4x/BwQzcVDbLMivFklmR8ZGeUCxg2n3irwZHvH+LDZAIgyKvvZsnURj0goKeoyboNrEh0XE1rV7VerofL1CjgNC8gm4aKlIIDEIe7/Uga5EfZLkZN/htfYjz2g8zBIYGDT8macIBwuKTLbORKDC3pk1L/phVD1sC9TyLn3Weaf6lFTUo7ZdE/8KEqTeaTXg/g50RLgIupnlgghDDekNdM3tvS1cJLYLdcao8MlmWYzGfH0Cj/KFkVvxHxNdKKFM4VpoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series fixes a bug in KSM where the pages_to_scan limit is
bypassed and the policy (use_zero_pages) is ignored. It also gives users
further control of the zero-page remapping that occurs when a folio is
split.

Commit b1f202060afe ("mm: remap unused subpages to shared zeropage when
splitting isolated thp") added unconditional zero-page remapping when a
folio is split. This was sold as part of the underutilized shrinker, but
has a larger effect. Since this commit, all splits do this zero-page
scanning and remapping, even if the user has the underutilized shrinker
disabled.

This unconditional zero-page remapping was also problematic for KSM, as
when KSM would try to merge a page, it would split the folio and the
zero-page remapping would remap all zero-filled pages to the shared
zero-page bypassing the use_zero_pages policy. When the user had this
feature disabled, KSM would then waste cycles scanning these already
freed pages, causing little progress to be made, and KSMs performance to
degrade.

In this series we also gate the zero-page remapping behind
split_underused_thp (the sysfs for the underutilized shrinker). This
provides users with more control over this behavior, while also preventing
the KSM bug when it is enabled.

RFC: https://lore.kernel.org/all/20260508170509.640851-1-npache@redhat.com/

Nico Pache (3):
  mm/ksm: export ksm_is_running() to check KSM merge state
  mm/migrate.c: Prevent folio splitting from interacting with KSM
  mm/huge_memory.c: Skip zero-page remapping when underused THP shrinker
    is disabled

 include/linux/ksm.h | 6 ++++++
 mm/huge_memory.c    | 2 +-
 mm/ksm.c            | 6 ++++++
 mm/migrate.c        | 9 +++++++++
 4 files changed, 22 insertions(+), 1 deletion(-)


base-commit: be18cf77e1e749c6469ff44df00eb026f7c0a365
-- 
2.54.0


