Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10EE606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=jDJ0PvQj
Received: by kanga.kvack.org (Postfix)
	id 0679E6B05C3; Mon, 26 Oct 2026 22:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36DD6B05C4; Mon, 26 Oct 2026 22:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E260E6B05C5; Mon, 26 Oct 2026 22:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB1546B05C3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:57:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1757AA0964
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:03 +0000 (UTC)
X-FDA: 85366894326.09.11DCC44
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6A47220005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jDJ0PvQj;
	spf=pass (imf13.hostedemail.com: domain of 3_BLgag0KCAElfwjompvhimjohpphmf.dpnmjovy-nnlwbdl.psh@flex--kevinloughlin.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3_BLgag0KCAElfwjompvhimjohpphmf.dpnmjovy-nnlwbdl.psh@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMgB+FzrQPZBtoyno0UE3jQCmYhoPeFOpiZUNmu3S6w=;
	b=k6RWYft+0P0HF4WRwEH21drE9zVqdLKdyjaEPygPiVzy4ZHcAxvYFOCHfHfu/lELF5ktaP
	wVXxRSSKPkOqgsFAgPCv6c6/fs+O2qFDMWB8XZFqXrmIZe+XBVTqIo6xiN9abLMgM7T+xi
	8Rgm2AMkrNtvpyeNXC97uCj3arxQp1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069821;
	b=3gNn9/ACfMuxuDGtm36CpUm49rSH8yxfKuPVCMkRPAF8qKdTY3xYOGM8OHLrJSqUGK8FLw
	xDqMOU+lSNuAvi8YrikLCqteOugFSKiwyyz14HcfdUAvROOXl0OIZrtVITniWUvBiccAvq
	EE6p2T6ADNHnD78mJkjqFnT+6L5kenQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jDJ0PvQj;
	spf=pass (imf13.hostedemail.com: domain of 3_BLgag0KCAElfwjompvhimjohpphmf.dpnmjovy-nnlwbdl.psh@flex--kevinloughlin.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3_BLgag0KCAElfwjompvhimjohpphmf.dpnmjovy-nnlwbdl.psh@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4db3db8687fso6207065b6e.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069820; x=1793674620; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CMgB+FzrQPZBtoyno0UE3jQCmYhoPeFOpiZUNmu3S6w=;
        b=jDJ0PvQjbb8B8qX9+zG6keFO7H9zKfWjStvDJCdUpVGGfM2yuxrWHlSF5zIAytn6oS
         1dbTalxbAl4uAGeKFVHGHzMmYiUNsCMROYr0/rzezCBcBWkajRo4e5yOul9Dv84w8KtT
         M6J9+rbWtWzJynTvmb0ZgMN8QkxshqxJ4qN1xuZ9U4UIl9sNm2YKvHiu2cG5W2OABsPt
         KuiDV28sq4+JyvTQiz9FJMeJnMLDoxiT2VFBGGrYx+VT4O0OvaxQ92oUrWj/eqmBzkZP
         RR78saCBFAIPZqf0JZK9GWM5rALkW90wB9Su4E+BgseLKv8wVD1aPQLVu8qNlc++lM33
         +OWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069820; x=1793674620;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CMgB+FzrQPZBtoyno0UE3jQCmYhoPeFOpiZUNmu3S6w=;
        b=oA1LI+bmLlKqnqDbAFBpkOqRyJwd65L64yhUs1/kvCpwvVE+a9CWvTDmDLqsfx5/f2
         Aviv8LaMqLYsau+hRhuMrkAeHJN49n/wa68d0Qc41kdP0/u+iP+DNqlc2/g4BFvPBuub
         wxvY0KW62dDeaPivY/hl0gK81oxN2Z69jD37iw57AI3r59CDwy1ZIpFWdAZfYDorOM6z
         Iz49uVVrF72iZBDHYWP4Zjc+ZoAE7E+Q/EG13fVsBhDpKCxx1ksUjZUascbXPlTJTaAS
         0BDpiECBiRRoQtns+w4u0yoU+dz7X4mNF1vja5xCkjeHTW6csmWgGgiOFh6FOS10WcqO
         Hx1A==
X-Forwarded-Encrypted: i=1; AKwUvBws+/piLfXSD+W+pfTdwUEjF27j6XfolCGMQyhBj7w/3OH9BwWA/cCU5I+ZBVtAqRpaDSWTXGBvWg==@kvack.org
X-Gm-Message-State: AFq9FYJCk9g7yt7/im7qv5xsB0Bn8YFc5QG8FL6JtYXTHw9fHQT/9oim
	uGR7DzURPl2+6J41DHbZJijfX+x/2k9TAbspZ0tbgEcTYinpYs0pGpsHXGyuU+dLOolub2Ho6rJ
	ERvXV/jJ1oxhFeJQURtZv8Y5MrkoYU6XYYA==
X-Received: from iovf14.prod.google.com ([2002:a05:6602:38e:b0:9c8:5014:752e])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:50a3:b0:549:e9e3:9490 with SMTP id 5614622812f47-55c0023237emr5583862b6e.23.1793069820114;
 Mon, 26 Oct 2026 19:57:00 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:15 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-13-kevinloughlin@google.com>
Subject: [PATCH 12/13] virtio_balloon: unaccept inflated balloon pages
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6A47220005
X-Stat-Signature: ozjbx8w9f7m1debqn3y146jsc1t7r5wc
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793069821-798816
X-HE-Meta: U2FsdGVkX1+f1GVvosoBneN14LBs7qNgq0ltNGeUGac75ZcSv/NiOcKq2+RXrCmiAi8lrJEyJVBCLa5R4oKQUgZQWuTVmOcKYX6vkZBOklrDGO4XMUpYpAQzR0tKxPXUw9n2aX4guIAQGHIZ74EpUkEZfcH+ngE5U55/hWJ863o7Gw4/OjH+jjJPHsOIVLLM6MTQrbBVXiU/EaUSIHc8/6urYshfCgh/+D63MdCkxDwNDpxudTNiYIZ87lbjwZdHWx4aK5B8ZCBJKoY3wvD/PJq3V8Fn4QHso60Rd/ibdpUjFT4HV5jJ9UN6TEIwZexm+YPCjr8CX0u+lkpitT4+Bq+5L204tEP0t+YHwhWxJIIAUf37tJKmQvJVNdH0PD6tFWhM0ramhOovqru07hBCjSOeSPtun6wfTgV2m3UBGCx2C4WqgQCtf0zZbJKHvtD/040o4VLw58kI+AMNItU2Th4kceUgyNFDHh04jcO7KmfsXltzodYspK106iES99JLHDww9IIap57/MqNUt+LyIXIasMPmopRW+sMZwBuFTuCkBJspA/kDVma37rrxcQrfoRvlvQeA/mWAaDEKWdazEhWVdliKQwRHcefrf+oi7L7K4/1CQggMPnTb0Loi+aWcy7uP2+UehPHZ74fZuqr9bn35PZO03APuKVif1r3JCilqz9ETVg/Ky2TDL48r05wUEkVh+ODA6C2gDvJ7pIhOQQXyegTEOY8+bnOC00g2qfLDAW9g2P+7p3PRAEn9hUz9bMiK5CoLtJ1NWvHurjMVGKyBnFqq8hDXOVE5ZAOd8KrhlEid05jSLnusqu1U0talyPh2dIcJ8Uwrr9eS5cAJQUY45RWvLS+tVLiYlGgAAAXQf8pdsbGue+c6chEf5s8Z1UTel5CvWEwh2KN6wbM7j8n7439qtlk4QWWuelRMo7O/SlbLaj1DAZZAfsPyFAIo103Mx6Kwl4Gk/lvNY3n
 NnoQsUsG
 vVTQPrrVoBrhkRT1tpChrqdQRkJRmnWpOvb4qJ8V1gzGm+fDP6pgM/+wOgrEJ9OBsAx85vnSBJcfalqiSn3IPtcWcVQ2aD18N8oPTut1XFp2XpwUnmfCe3qnODGBzQ9GHv6Y1dXkMMlQ2ltabCLXP6EoaZGKBKlO9WVSKJex59SPdAvnkmjYzuR/8n99b+54dqd7xRsx9HgecK2o2zGDK7f/ADRQVt6huLQRDYikP3ifrSMfrvVapQc9zV627GHHx3a2dUAP/pCkj9oFKR+CJansoAO5triRpnMGcXcd+/+NpOSZkrJR5iStEL9ITyEYf7RL6+DZaMNpArtmNVFn8zz5YfEc1LhMYItvlNSDyzluKg3C1GTDVVxVZY1H0glHTUMRB8fruSrE6jAJSPsGZvyf5y4ZF+OrHsJQhHQqPXsLqIlMn7txR8Waf77HaR7KE19bgs57ujK2zEUe4Q7wdMfuwVZJOukbkL/dcvsv9rWCHrRl7NSo7H2e8oi9CU3f/NkEBIAfYRAd0cYzHSh133dE02lOOjK4IMX8PiaYjfeF9jmx1EyzmqoiNN3vqIH7ergifFfTZ9F5Sp9q0haDFA/eUrYwxyQj65/TjG60uuVihi1rLrOiekg9Z7EQqK5JLo02Jak5rPBQEeyPSIKVcEOim5uH9TCdTkKSMarvklKPNkl3MOebioYEOSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When pages are allocated for balloon inflation in confidential
computing guests requiring page state transitions, mark the allocated
pages as unaccepted via mark_memory_unaccepted() before notifying the
host VMM. When those pages are later deflated and released via
put_page(), the page allocator routes them to zone->unaccepted_pages
for lazy re-acceptance on demand.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_balloon.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index e10bd792ef7c..217431e75751 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -329,6 +329,15 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 		unsigned int pfns = (1 << page_order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
 
 		list_del(&page->lru);
+		if (virtballoon_cc_needs_state_transition()) {
+			unsigned long page_size = (1UL << page_order) * PAGE_SIZE;
+			phys_addr_t paddr = page_to_phys(page);
+
+			if (mark_memory_unaccepted(paddr, page_size)) {
+				put_page(page);
+				continue;
+			}
+		}
 		balloon_page_enqueue(&vb->vb_dev_info, page);
 
 		vb->num_pages += pfns;
-- 
2.56.0.307.g5fe7bd680c-goog


