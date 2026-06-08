Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13041CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78B8A6B00D7; Mon,  8 Jun 2026 04:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7639F6B00D8; Mon,  8 Jun 2026 04:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679976B00D9; Mon,  8 Jun 2026 04:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55B316B00D7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:40:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E3B41C23A0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:52 +0000 (UTC)
X-FDA: 84856099944.15.753CC36
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id E011C180002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S/Noz1hP";
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4h2My/REs5Vp77QAaORxbiGwFbWeluHTenTERVDNw80=;
	b=x2KFreMylnqki3FIFCtW26kQRUrhCeYyyE9N3Fm5i2cK0G8r2Ux4LIEGd4t1IpCDyvWKS5
	a+rzL32sAZ1dOt2oSDo2C6syUMNSOzZSV9S/Fb8duij6VoCSFY0dQxy5P9TOo87Zoeo+tH
	/6Rye0fpmWbAxn0fqDIHn2bSBSDFQ+g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S/Noz1hP";
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908049;
	b=OCHxyE9h4fYri7xJhVWbQKFfoC5FrP0GiziIl6vHsZwwEuAxECnnzQlZNmjFFoDFuvqsH4
	QdgTuvMLcLordAyxYk+Op/yMQ+zI26sxV2LOa8jkddG9VCwZsT/HbYItGJYESpNPIEl5PU
	Uj4+tj5rB3wJLfUkbtX+2LVXafimlbE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780908049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4h2My/REs5Vp77QAaORxbiGwFbWeluHTenTERVDNw80=;
	b=S/Noz1hPm7yN8f5rky8pAG61d76StLIo1SKwf6lmWyPyblhiH9mtfxf5EVVQiB/zbICi32
	TIXwdPjt9PWIOUmycBa1l9PbhFnXOACsvbj0dCiJrOwYfzbxcdDG18Csc4/dysITwKYQj5
	/iFri/ybEbqgTn0lHtPbB9REb0kYUnA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-EBcTq-LTO5i9uWxAB1IvfA-1; Mon, 08 Jun 2026 04:40:47 -0400
X-MC-Unique: EBcTq-LTO5i9uWxAB1IvfA-1
X-Mimecast-MFC-AGG-ID: EBcTq-LTO5i9uWxAB1IvfA_1780908046
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45ef9f0af71so3070917f8f.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780908046; x=1781512846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4h2My/REs5Vp77QAaORxbiGwFbWeluHTenTERVDNw80=;
        b=NZOeP2ypXWx1Pmod8rUm/O8S5HGW+xeHNX8hQZkh/9O/2lHWS82mjEdfKtw3KvLpt+
         ZJ7fRR29r0BShxyo9lHo4fywc2/Ao+dMLHq9EFGLWNDSeYvE2T/W5yEm+HAX0+ZPGw5W
         iaGa/kehXUR0kBamHnA06n6Uj1tM/mRq88OsQHxhZduwwJwZwWmr5+kFz8tU2AUWs50Q
         SPEaqAKP+YzoLFWAJEzXl3t1BPironr5UwrB2mJp4OuygDWj1TbFm5DyuBA7+vZG8D1T
         E7pfKmg7FbxaWVgKZWd7A/i4wyJv0E0AoxlRI5Whb35obXL3/ETp/IqIClFimdD3XdY4
         /DBg==
X-Forwarded-Encrypted: i=1; AFNElJ99s5oPd7sDoeWSltITJcq4eCZ6pgqSeZubWz0AeuMUKiYnKMD3xUy9QShzTotY1qJU9noUHuseVg==@kvack.org
X-Gm-Message-State: AOJu0Yw94bMcPy4SxfMf4eaaRnWGOFngm9IPHRpYQL13x+mhu8aav77e
	OKcKSfuQXszYW/rIDyJlJk033ja9REtY0vI16cK8szZKnaArj+n8Cpz2YAI/eCc2LUdYeSPTJaU
	8ZfJR97hp2f0r0zP9aH6OK5BVsPjSWNYfuw+P8t4JsjR+EiQDo+fG
X-Gm-Gg: Acq92OF1zpSUhJmWRsLDgFuQ0A/89M9l6GT55HNCUH2eQUtU878CERqDKcz/EWbkZ8O
	+cNA0jUdvzm7wUKDHp5Q2fUnjf7R9J+EuT0KrWJ43TLuoLYCuhI6kKBf1bstjehNLqwZqmsWUej
	t5yzWLZUN9nk56KVo3s13+Q+s9YBX8Bw2ZweEJwR2c3fpthoXJDlSdg+Td/kR1kgy/bTho/F1M6
	bno2Cwz77Yr0L/1djIcWT0diQqrC4M02igeT94XXpsdcdBoOddSAocI1iDRcLoGKXwOHH/+oWg0
	z7/juxZ0LUoIUt/tjf/PmeTby77LjaIAC/CHp1tVhR1t8nlxS/ftTQMVn4XAIJt6RW9DNk22cO+
	2Ctyu66VUCb7DQKu8s17kGh4=
X-Received: by 2002:a05:6000:491a:b0:45e:f93a:2069 with SMTP id ffacd0b85a97d-46032db4e83mr21033522f8f.23.1780908045867;
        Mon, 08 Jun 2026 01:40:45 -0700 (PDT)
X-Received: by 2002:a05:6000:491a:b0:45e:f93a:2069 with SMTP id ffacd0b85a97d-46032db4e83mr21033456f8f.23.1780908045356;
        Mon, 08 Jun 2026 01:40:45 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f344558sm48517487f8f.18.2026.06.08.01.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:40:44 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:40:30 -0400
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
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH v10 35/37] virtio_balloon: disable reporting zeroed
 optimization for confidential guests
Message-ID: <101bfae36b0f6445ff0189c2b0936648f3f46118.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: froPvxy0QRqsr7KLAEy9PZqTLd-st_sC-TU526aSxHs_1780908046
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E011C180002
X-Stat-Signature: 3y6h7d664j1kdmghxi745q66x3q96a6f
X-Rspam-User: 
X-HE-Tag: 1780908049-446932
X-HE-Meta: U2FsdGVkX18MB8DVUhatQDtYp8x1rz54A6LomyPW/oZPy6dMmpZ+kjgiqOI+kSuC6Bs9tN5zYdg1VM6qbyBGdg/KYCGk99ysTdu3n+vsQtZy4+fEFmW99R4ifxOsE+9bjdJn/xMW0BcRe99mVeLIp/9d2+il/BkqVNJSF7HPGV48Sx2Cf5ekg0CrXQbb26UJAX9oTmMLtNwnR8bqgJrraokmS5NHcT0bfk74lAP00OExQuJUWfvTO4MTZcug7xCp2d1n8l6CA5n4meearufRrmN//A4pb89QmijvceIjMprWxb5D0vwBfcLDB7o1Q4ZP9qTYOn1n78By74fchzl252qo5qsv76gXVcDtC73apJmLyIvYbblpLOeLZkGL2XkYt3FFkBbFRn6ZAGySyBHAVuTEK6TicDl/NlJeRfbaYzXTFPgfcsv5jNEu1qZlOgtiMM30z/gfs2z4ZtsB4DNNvbo1ICCqIL7+neGqgUYlQoD2HY7iTukZ1/0nC9Vj5bFU/PAVp5/x14DtQPFeedEYL+BBVi9P7Wtxx+UgIjfq91MtjioXqGUU8j1vh7KlfFZNAvfOsXKkqr43oZlhX4CJTTshcHMcDa1arFNVrX2p1A89Kw34NrC9xPPZa82ki5flE/yEUr5pbBOmeVo5VkjyE2kL+acB5TV0KIUmiXy9p/YW9lx5cGYFXqRt4xwX/oU1iS6wCrTiNQlJfqj5hplfs0sQt8yzobluVovWBFfuRWa0j2hz2P78vZ9EweektDSJ1ziAlfe/bMprHd3ydhujfAHZ5LeWw5lcvMDU2tLRAlsUqWDiJjTLnZ1JP/WAqN5XmfzoQC6fpljfcIZ8H+mlgoKKZi1rhDwK3f+HqXn4YoMoGsm2JQMOG8Kmt6m18gy3wGPvP6uqamYeyIMx6o/Dzg2jfRUOX6zh9PWci/xBEFqde+oUOx+YXj/P28vrJoGXWkejK1D6JgZBoOD/6us
 +OLGcm3g
 18N2BHJis5XbRD3+RkMyz9giydHlj5e0Zr5W+dlG29Hla5lDwIUi7lRhhTGk+9Y1BHSz7sD3s9LrdhOKbnFgeOUzi39dsEeIdTt1P+4KLHWhuV+AfrTt1U1YURJbRf049ZrJUgkvll742AbB2k1i+zaoL8oT/nEj8imKzgfZ8Qi1dDrqEVGhdbVE93rU48fmo5AKJ7gUCkKp83zMNGUUQktyeY4EW53RY1nzIggGwlGhj0uYiH6Q16Be87ehiZr4XvpaOj4vB08qPHtGCjh3Vsj3lOrqb89Nrn7NXgcJJkVSSbYVpa4q/7vKDgVqHZ4yNwUG818sqp7xI5dQ+srMcURaffvpX/9s5lwjK5cmKsZ4YRkQXrl3CqFW3EDRkzrWznacJ0tLjg7zR5ncnLuq41D13R/tT3Hrduqu5LW0NvAMJQasAOiHipCicGoZcJQpDHl+ecc94jldaSuK/IiomQ6+UeUFjIPPsxHps
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

Note: currently REPORTING remains enabled and
VIRTIO_F_ACCESS_PLATFORM is cleared in CC environments.
This is known to leak free page physical addresses to the
host.  Whether that, or ballooning in general, is a security
concern in CC is up to the user.  This patch only disables
our new zeroed-page hints where the host is untrusted.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 drivers/virtio/virtio_balloon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index e3afa6f32ba5..bf1172ad5419 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,7 @@
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
+#include <linux/cc_platform.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -1193,6 +1194,8 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	    !want_init_on_free())
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 	/*
 	 * Balloon submits 1-2 sg entries max per buffer, virtqueue
 	 * sizes are 128+.  Disable indirect descriptors to avoid
-- 
MST


