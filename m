Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03123CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B976B0104; Mon, 11 May 2026 05:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6433A6B0106; Mon, 11 May 2026 05:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5597A6B0107; Mon, 11 May 2026 05:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBEF6B0104
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:04:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00BF98CC6C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:19 +0000 (UTC)
X-FDA: 84754552680.07.7273AEA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id C18DA20010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UZRhiSBd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2QKjWRUGZavYM1HdL6nJ1yLQpyzjFP+uSIPdSalIxY=;
	b=uZMDuqW25PRyYsoQlRK+KAy+Mu92NQJ6VSRiZ+kOmwzPce6qgkdGqRGffTbsmauFQc7D7V
	a8fTKeNioCxXPjL9DO1nOId3PIlr9L1q4MbH+fDWmUVbtPlT3H8MHnIXBCHeB3K8H2fH3Y
	drTz5SYTgE56lxaKFvqSppgpnpagNps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490257; a=rsa-sha256;
	cv=none;
	b=1NQwxI3s5DQUNxSGCIXcFtWKSjOvpSC2clN8qY1uY8qrrAAn7LxF7I5y7659zhEeiBPt4Q
	rxtZFYe/OrIhrI3s94S/HEZf56/9a5QIL1SfZBKoIBDZaDfGAN0A3WaWRD4zCnEMZH+1dX
	+Q/UWsotj7Z29oYAMaF0xYLj4CcBCfM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UZRhiSBd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t2QKjWRUGZavYM1HdL6nJ1yLQpyzjFP+uSIPdSalIxY=;
	b=UZRhiSBdxKcdFP7s0k8zsQF8D0haiN/wCE3PSVVxRxkbOVx2DKjx+YZGaIGTXMnmI4zyzC
	oUD1Sh2zQwaYJ2N43AHH+i0TcyVTcZqasZt9iU1RhKre+3h7sROO/tWuRbhuDQTHGK+iDG
	zdbtcXGBF3DPJj2qokV5r7ZoSWTq2qw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-3RpuC3SFP4mTvUMYKKQpFQ-1; Mon, 11 May 2026 05:04:15 -0400
X-MC-Unique: 3RpuC3SFP4mTvUMYKKQpFQ-1
X-Mimecast-MFC-AGG-ID: 3RpuC3SFP4mTvUMYKKQpFQ_1778490255
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488ba2f4094so31584035e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490254; x=1779095054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2QKjWRUGZavYM1HdL6nJ1yLQpyzjFP+uSIPdSalIxY=;
        b=AeBWHV0Zsfqe1dRgiuuU/uXFh/QL2aj9DQRSRvQMRi6k0ff5Ioh50iXkV8mJd54qpP
         EnLMOrioXiCOM3uGrsbA519bDO+RPei5kpRmRSmfFdhuALDpV8EDosggXsOvcO8Tnuz/
         4QtajRRPeIQ+fXJSY115KZ46VjL/nFc6FBljkTWEPggHR5GqeE8E7EZdY5hocLnpyBHr
         4XEiblzMKxY4ea3QgKoEMVo5EAxkn4rh7dj3VRy8g3Fm0r9f4LGbEiwfHgpGpttMCSqS
         qSM6DD4ajzjIubSg1M+0DpwE80NZcntq2yqTg/7X/1pdnmOAwMz50QhuP7WEw88PU9tc
         e15A==
X-Forwarded-Encrypted: i=1; AFNElJ/4AZSKAfGCBO2ErGCZ7+T34HG2nTSohSC/SqP+dCk75MtPzgHTNRtcRzmcRRru9xTCqPbOk3hnmg==@kvack.org
X-Gm-Message-State: AOJu0YyGJP0u+Rm4000oFKbRy/AgJ08mj6md5oyXe/+xmubd1vl1tyx4
	lkWe+WE2bi4YCIm848I7JXKAly/d4GeuI5t3W4SgS1JSNVntbVjTA2hiZPZxws46zSdDo8SCHY5
	IfC90+EUwphS63IHCiq+JfZ2PSVtJbVvfrT02WearA7z8a+ouIqsd
X-Gm-Gg: Acq92OEBN5UoRo/z82a5aYgZQYJcHUw+eycUI0+NLqzYSteLeo/+TZre3dQ8J10Kd47
	iWsSOLQsF8sTI7WhCZAdMDzuHdtxZabNJXW+PFUQa3NNaSxGHT3U7uBGtH/0YUsy7bBw1v2AodZ
	K5zwiO/B3oETznJWSFCy4Y0D8hQxgqHDeqJW+3o/ozlAeHnAFaaNa3h8aPrZLUmIXFR499STeto
	soOs7WYj+YqM33T5c8cLhWI63MiDP/HZmgU6+NlzZIAuZ60wEZNkWndn0cUrpzxGk/Ga+FgxVwq
	ek/I2GJljRQ1oCTXRu36knwtH7p9UMdKjXp9Yi7yqCZhYm5acIQuqqdTrLcq2A5ONslIJmnM1f3
	LD0Ui+QuVaNNuVu4j6yRO2S94hMq8s7YZYkX5l+Le
X-Received: by 2002:a05:600d:1:b0:48e:7f1c:8760 with SMTP id 5b1f17b1804b1-48e7f1c87bdmr67342645e9.27.1778490254386;
        Mon, 11 May 2026 02:04:14 -0700 (PDT)
X-Received: by 2002:a05:600d:1:b0:48e:7f1c:8760 with SMTP id 5b1f17b1804b1-48e7f1c87bdmr67341395e9.27.1778490253720;
        Mon, 11 May 2026 02:04:13 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6db0b08asm78949215e9.8.2026.05.11.02.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:04:13 -0700 (PDT)
Date: Mon, 11 May 2026 05:04:08 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH resend v6 26/30] virtio_balloon: disable reporting zeroed
 optimization for confidential guests
Message-ID: <77585f29352cb5fa235898db07e7a3fa04d4d04e.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WRYoETBTab4rvhmz4i5MpRQNoaCtnNb4ePeysDnxR-4_1778490255
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: C18DA20010
X-Rspamd-Server: rspam04
X-Stat-Signature: pcuf7duaaiafzbonp1kjs9c95bs79kxb
X-HE-Tag: 1778490257-336834
X-HE-Meta: U2FsdGVkX1+/Hly8pTFugtGescWDqJOG2+M+aVOkiur7KTP68f9tYvh/FHS9ibputaOwIPIQs+qbF2hSL8OlhP4Md2CZ9gmLuiS4p4BinzE1baIfuQ7G7d7RuUnVddf6WR9O+CCrMDY24q9Mn7Bqg6r5GNggJTTvycHkOF+6r12h7GPWiKu38WnJOAj5SuvF8Ljt22VlBq9cAg9auCpnkQz7n55G77Kexho6OnNwD8yxEj5NLzgsGm6JzR+7Wf1DYChyT5pddmoD10lO3prSeOvjqYg81YtS9wIXPJaKT0zcjy2ZzGQAs/HzCHmHDq7H4Win2H1RdeqKUcFZ9Gz/RmSLYaB7cagqdYfyFKbhaPEm0/jxxsx0KgU+RAn0jJGDfrpXCFWMcgbSK24kTNMnDXX7dNoDfJ/IwVipTa1ffbeYf3mBTaJw4i5dwq0CiaEGyN3k5ohMwfH1QvokR4R59aAIhLry1LX1b7Nay/pX1jbmH0MPJUOfPkqhWnK857j6Rz60fRZI7hjXt+IqrnAyGdX2W2IlouXtBjb1qBtNr5WePj9F88RwFPsZ7vw6ZrlTIIcOkgTz+H5zk5UCetS3NMfvPwhqQUQ3ZRCwdxqsLfpU2RgS2jO+uU9HS2UGIcveG6OvdYp8QXWOXliaCzKohmX3N9mfloyzLh+hY+xakrBQdN9fX9nZsKJbLYUPOnnjICCloaYdI26p3i2cv9bGgokPzvFtPg2gNkKALiq2lSUskFy9Vsns8SvFO3FFUQVJHY5mxgYwzhiWQlc4VOV82mjWx5r3J3UvJG901hEfcTQJcu+vmrQJoxCHUZ41/2+KweMzRjFvtATk/uDD1ekfA8OLLiqDcpLvf8cuMA5HdGW6VZ4MYShv5xYzTpKTMC6k/F4J4aLuDkyUYpJpKmXA+Boy+fx4vLzbX3hTkLCOrct1AqfQ8TxxVllK/a7n7ntRYlcnQNTQQTe3gYlgopI
 y5N53pA6
 7thu6FVrSysWt9h93Nw/C+zK//+q/UOhkHDAGYvMO0SWFy7l2HlA/E5t82xwcITcc7U5qEyMuHhSA1DfzBiXe6XlUV6/bnq1L4TnO8mLM048E2Jd6tZOpnJgFBXsS9P3bloPCmkBFQc9e6K/UtZuYmfHpRSMnG6PWfI4es2dguN+Lo56QRgT/bWyDLtEoD9VVDDs/hJ3phKYsPNdsGU2FrK5I/1pVjWoGSx8pgbaaiExyYknlALBguxs2de/6jw/WUHsjZeJNM5yYE+dwRZfzixniXbN/L1K39WUYUg/tscFs2WlZK3iP+hwbLIerYTCidYm46Z+Go8ZhdFTz/k3p966Mogn3o72JyDb+6bCQDrAsXD4H6vLRALewW9g9D4o+BvTYtDWvyogHfC20XxZDOoGWQywGElwVWTUZwwgNQv/tOMG575/0YAiZLBLubdlu4NQr99ZbFxq6Ep3EkTmcxuLc0EimYLRkXUBT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In confidential computing environments (TDX, SEV-SNP), the host
is untrusted and may lie about zeroing reported pages. Clear
DEVICE_INIT_REPORTED in validate() so the guest does not skip
re-zeroing based on hints from an untrusted device.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 drivers/virtio/virtio_balloon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index e5d11782ce41..d1cdb904d60b 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -18,6 +18,7 @@
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
+#include <linux/cc_platform.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -1190,6 +1191,8 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	    !want_init_on_free())
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
 }
-- 
MST


