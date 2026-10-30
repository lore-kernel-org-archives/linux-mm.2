Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DDC2606A320
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b66erMyA
Received: by kanga.kvack.org (Postfix)
	id F3CD26B05B9; Fri, 30 Oct 2026 17:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F134D6B05BA; Fri, 30 Oct 2026 17:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29666B05BB; Fri, 30 Oct 2026 17:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFE156B05B9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:36:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 415DAA851F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:36:18 +0000 (UTC)
X-FDA: 85380601236.25.B4CA6AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B09740007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:36:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b66erMyA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uffWnCX+dZCMC5zfqHz8EFOq57RMKg2oGaNPtOTb0ak=;
	b=mgsMqyn8uShu+XPqz9fm2s4QbKTZKrVWPkAh+WHWlwDyTs1AInPdoytNiTleJg6tjJRD3J
	TKtdnWhdfqXcVVE2irzldJgtD6C7/TmJWoRxKR1WFkxgPWyIkaaGwiFbubtQm+z+m5tf50
	ndY4KRmZaG8rAmN6KvkR+SaZN9OA8oM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b66erMyA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396176;
	b=lI3P2iqruVsT/c0I7CXoR+VjjqAp/l5vtiwhnJTWpfpsfsFxLMgsXnSwZ+cxsnefVrwBma
	VrG0YvgYKP7dfE/mTrP3YJlRtg8+yQUXZRgIfUxxr9uT+eBBXAHocemy2MzrX3L/zsvJTJ
	C+tIvV4JIbL0LPHbC3akYaB7qKVUKTM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB1EF60233;
	Fri, 30 Oct 2026 21:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE89D1F00A02;
	Fri, 30 Oct 2026 21:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793396175;
	bh=uffWnCX+dZCMC5zfqHz8EFOq57RMKg2oGaNPtOTb0ak=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b66erMyA/4rcHH7GTtaplkrXxXXnjafDpQRaA1GC4RN+7mG+xzJmMHXZM1yhFlOgq
	 xzhqlzmNfp88yGqMF5+YP1g9iQiGaQKD4PdQInnhKmv9e0PwiXI5IyD1W0rzoj9wdE
	 rNRctA5HgnG4x0svvzuPckqP+1Y87OACM+zxWZdxgiquzhNw8+3pXnJ+74s0phHaM+
	 Yxfx0qeEbctJJ5fBezlaDHzTTaZln5WtUaYEx2NBbQCETpZhBZvySP1xDboZxG5+qK
	 LogiGw6Y+fmgYHDIjiq6Hlgp52tmugZOxqa2lfxIeeupLTPxX+IXCyE4zNWWv1DR9I
	 l6m7uqhjQ3bFw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 30 Oct 2026 22:34:30 +0100
Subject: [PATCH 6/7] MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-maintainers-v1-6-97278f8a5f54@kernel.org>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
To: Alistair Popple <apopple@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Byungchul Park <byungchul@sk.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>, 
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1918; i=david@kernel.org;
 h=from:subject:message-id; bh=S2+gMbb/eCTDH7Pu2Zb0zjeGPfd0pSGk5ktePYriPXo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKe8uZNbl0X/LffO/el9IcrXDc+nNy8LSjw4MxU8QkG1
 ts3nLdR7ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiTDqMDL8W9cZefrsxqkXR
 +e0DF9P3klcM3x3yfGy4iY/ToPScxDWG/94HdfQunNpva3Ezk5FxbZhPy75jK020lft+/XH8p+m
 ZzQoA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 8B09740007
X-Rspam-User: 
X-Stat-Signature: faeja7wbafmhcrb5p35c5aruwuqmqad6
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793396176-822828
X-HE-Meta: U2FsdGVkX18G9MF1T+q4hxBJ/hW4EWbqmgYbE/lCV8RKCgCbiZH44wvIWDTCSC7RZMZ4xgKVhK+AtbuSUYoJUDth61r8UJYF56Q5QgouI4Q3eWSfO5UWERs7UKcEQFBei0QNT9joey+weCd4TKXtP618FCCc4RPLhswNUtn/3Uby36ygj6MQSFJIWLKNzNL0q2g03bCfNkq+epRfps5UZ1Sg7513BZi+QlASsMtOjuAU+MxvDzdXtb3lV+89CHjHo33TK4atLtwSoG44YE8y+Q2bb1ADTLalffp01hvmcDMc4wfyV3WZDzKQlWHFs85HCKRRCl/baQb5FmbyPtPABWo5dg7nNEOyEOMebgOwMGRvEQ4QU+NJoXOekCrtfhjLqCkmIu5JO9Kv+qngm4ov4ybwWUi0OVOyExcP4RCNuDz5l1XsYk7LOEOB4MGg98NaQVkClK3NuczEA700ag0EykSsGiBZ1Ma5c07MVOMI0mCiA440YBGTw2Ks3Dit5b2SmhmC3MtniBkanX2M5Ncb8qukmOGxUxu/u47mXxH+qdruPPNu4lWX4gAVu0EK3UsT+prv3Jhg+yeEUoqtviphRsUpk2DIHmD6pavGlcGut1zMlIUCWkRRjEFMExMCIxK1Y1tB5OUIo7AarBUr+slxdDYosKqNuw3AfLhI8sXnFkmbRWGE7OolWXDsKBmEzyVtxr1hMvVpycGXIm3iJOaxehbVWU2W0xI7XFCvSLGpcReL15bYKLDWzLyopLhH/q4o8XkuOy6dGuCujieSurTi0zQry3LQdOJiCRlPqqvre9ferTRr7w05dZEcg2IkH3i+gEWDlSx3EiC8Q7+qQXOhGZ4nALvvfN8ax4xaJb0AIhfkepvAfQ/RveYowbqaNibuzAlehtWLT3DJJKgfy/KZHw4DliTnHo+V58H4OPL6WAgUwbzKPCRpK6lsk9PTcGdjcr5nmYisyJBmH1VR9tT
 udZ2yKPt
 vXBZ08Hu/arvP8gkOqXgwRpRi7nvG4au02cORqH0b5CY+Hs+pVxKJX7GIwpb6XjnwHNgD9iw3y+QbeI57aNjDrtLvIuIBoaEosAT0gpXKGAzrC59n/u3Vdmf8ef9PIjj1IbQadX965C5PGnFFAmSVGk8Tez6gNZw0cqzHX+kN0e1wP4DI/F63DJG0eBvrvXD7QJsOvmlI5ANZXsyzU67LGjJ5UGDsouPUIJX4vkCJp6vwLNso6Pp0u0jZiGcjF/RvzzpkedZ3P6cozGfDN8j4pVP1BFud6DDH4p/7M81Ae0GX3CcNrF2lejZpsM4vDP08x80q3HTMO7fLcUOGLqKIY1GlNzsO8xdN2YKNc/JzwUcduVpQRP39ybt89l7mRyah061MYXMnT8Fu5AG9o1F3GbJHgDA3/kq9ppYiXWVwXh5awJpDPVZO5Zs9Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Prefix "MEMORY HOT(UN)PLUG" with "MEMORY MANAGEMENT" and put it into the
right spot in the MM component section list.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 98948d159173b..0adc674304987 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17423,22 +17423,6 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/linux.git
 F:	drivers/devfreq/tegra30-devfreq.c
 
-MEMORY HOT(UN)PLUG
-M:	David Hildenbrand <david@kernel.org>
-M:	Oscar Salvador <osalvador@suse.de>
-L:	linux-mm@kvack.org
-L:	linux-cxl@vger.kernel.org
-S:	Maintained
-F:	Documentation/ABI/testing/sysfs-devices-memory
-F:	Documentation/admin-guide/mm/memory-hotplug.rst
-F:	Documentation/core-api/memory-hotplug.rst
-F:	drivers/base/memory.c
-F:	include/linux/memory_hotplug.h
-F:	include/linux/memremap.h
-F:	mm/memory_hotplug.c
-F:	mm/memremap.c
-F:	tools/testing/selftests/memory-hotplug/
-
 MEMORY MANAGEMENT
 M:	Andrew Morton <akpm@linux-foundation.org>
 L:	linux-mm@kvack.org
@@ -17576,6 +17560,22 @@ F:	include/trace/events/ksm.h
 F:	mm/ksm.c
 F:	mm/mm_slot.h
 
+MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
+M:	David Hildenbrand <david@kernel.org>
+M:	Oscar Salvador <osalvador@suse.de>
+L:	linux-mm@kvack.org
+L:	linux-cxl@vger.kernel.org
+S:	Maintained
+F:	Documentation/ABI/testing/sysfs-devices-memory
+F:	Documentation/admin-guide/mm/memory-hotplug.rst
+F:	Documentation/core-api/memory-hotplug.rst
+F:	drivers/base/memory.c
+F:	include/linux/memory_hotplug.h
+F:	include/linux/memremap.h
+F:	mm/memory_hotplug.c
+F:	mm/memremap.c
+F:	tools/testing/selftests/memory-hotplug/
+
 MEMORY MANAGEMENT - MEMORY MAP
 M:	Muchun Song <muchun.song@linux.dev>
 M:	Mike Rapoport <rppt@kernel.org>

-- 
2.43.0


