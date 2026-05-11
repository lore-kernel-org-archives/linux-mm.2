Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A346CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6386B00E7; Mon, 11 May 2026 05:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A603B6B00E9; Mon, 11 May 2026 05:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9015C6B00EA; Mon, 11 May 2026 05:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 777B56B00E7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BED3C22A4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:03 +0000 (UTC)
X-FDA: 84754549446.09.D32B2E7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0D2F420009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C3pC9KZc;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
	b=Vdc43rxMP6GsW8QvqIMCEvXFBLerHx7EvOLu7MofkSdokBE5TYWxHWeyvgyegMB0trR5cW
	ZnOfKm5iL0NRKxcuvLcvfXkpsjHpMP8c2K/WGw5ecHnWSi7rW/W/hHBodgV0rauM4Uwiv5
	MsHwxKsA0+qJ2ebPTf+f8W0pLxDzGEE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C3pC9KZc;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490181; a=rsa-sha256;
	cv=none;
	b=qLYAI3hyvuAe6vuMR3xsPhtWJye/naNM+AarQKvrBleUT3WP7gOkm/RCW8Y+fFE5I8STJ+
	jnGypjf22jYszhPW1TMM/O+fBaKi8MLt+209vFZrMFuG422TvgMz2M1DhqKQ4/TZ6bdBff
	8USDlTyWLkiCU3IzfT3WNuB0RsqidiA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
	b=C3pC9KZcjiLvACYdbpfEDhgV5zbtSl1aht1uFTTuJRGHVcnGGDNToo1yswuoiiIEoiECy5
	4OCo8ct3pEntwe6PUfFNyl56QpUvBNurxQ8c6sRJOuN021a4gpC2rt3kGD9NsBUz0Lea8a
	N5CTLOEiGh3ibHwqnFq/VLdBxtch0T0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-2Y-WoJWmNyS1LzHsanap3g-1; Mon, 11 May 2026 05:02:59 -0400
X-MC-Unique: 2Y-WoJWmNyS1LzHsanap3g-1
X-Mimecast-MFC-AGG-ID: 2Y-WoJWmNyS1LzHsanap3g_1778490178
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48a55de6fb0so28097555e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:02:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490178; x=1779094978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
        b=P/4U8rAzPu6B+sZhksQhWuv3qqR247gmMiCW+ehnMQ5ovBfAA9b1U/cfa6rpL3Re4m
         PAhHRgRDrLBplKB8g6alaZR8mC3YhXHQunZh1Z1sw4CTyJGSpeospFmyFV30xhM+m3pX
         RtTJ7UQ+kyrz3J7Z4c3u7Nvm7YR7flenlSe0j3jMAVXYMyQWHZMKyFrtaJ4C4kDs/4jP
         hcWnjMMvzEB4J0vifvh5eMpMu81mpphzWAfj+Acl9BPd/zFPGd4xAX/UtwEyZzA1onrZ
         Nzb1vV7LMb2/6NJmDECtOlkv0V0w1/ps8KO8MWQHPghR3AJg8/4TbmgeUfddE52+NJ1Z
         X70w==
X-Forwarded-Encrypted: i=1; AFNElJ9MpGiQvMIgac4F0JXHFk8/6QtxVvMDBZfMQe8Ew/F9LG4D9WWwfeEaXJME5UhOQbN5PZBjCO2TcQ==@kvack.org
X-Gm-Message-State: AOJu0YxFvWJf2EmjQpzB3QwV7ih9O/qRAqicyC4vdEmSN3W/slrf/84j
	kFfzrsh3GjdDf72ZWo5CtYtsjjGQL8/iwaa4mf6yVUe+1ngAQPZdtJ1Q7TdQ7YuHMJZwIMYcONR
	kLAlB7r5obVQ/5YfLy+IIuoxPjxbb9OFMq/DpuLgO+/PYgeFOqq5s
X-Gm-Gg: Acq92OEUbkKiNOxKitQbtxQPhThxAyK8FgreYKTuDQ/7xiVWj7veo0IFaSEUviXch/i
	D7InnagBIzqAC84+9YpxgX2cfI3KjbWtZcrszcQn6MtWLaHCmVYAtp1ytrGDgW2CcKztfBo4rAu
	g6kc2tgr3bRC4ft1YpPega3sEr0tFtXRBlKMK9TLTgwfaPGnJXrIq5FtqXtR2k6DEzFvQjAQrcW
	jYYW6uUf0rqU43kBKONoKAKnAqfuS9MeoEHWadVxk6MfO4nbunOWBONn7QmzxBOrc2NRhQjijVh
	1CZiGLkD3ikrdk7ZUNdnxwMkbfk0yfoTk69sfvLLpUJg8Mx2Z/TPEARHNTS3e13JRNj8/tMnb8O
	kPLI90VgZPKZ5e+HIoVToghGXl1l0QRoBP7o9OeiK
X-Received: by 2002:a05:600c:8115:b0:48a:9540:1a3a with SMTP id 5b1f17b1804b1-48e51e196f9mr374461015e9.8.1778490177780;
        Mon, 11 May 2026 02:02:57 -0700 (PDT)
X-Received: by 2002:a05:600c:8115:b0:48a:9540:1a3a with SMTP id 5b1f17b1804b1-48e51e196f9mr374460235e9.8.1778490177155;
        Mon, 11 May 2026 02:02:57 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6db10684sm60460435e9.26.2026.05.11.02.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:02:56 -0700 (PDT)
Date: Mon, 11 May 2026 05:02:51 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH resend v6 12/30] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <20ce2bd8227c0149fb205d293b47348c3ef49974.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cUaQBWoUjHYT-JFv6QhI-JXuhDd90hcz-vEP1G4sgzI_1778490178
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D2F420009
X-Rspamd-Server: rspam06
X-Stat-Signature: mypououfd5rk9fzep9fww5opiu1qshrf
X-HE-Tag: 1778490180-700177
X-HE-Meta: U2FsdGVkX1/Axvine2PIAHIdmaUgM1wySggrfIU5e9I/2+kSAPaQcQYmGSK5+q5ZkO+FrQrRRJDzESWj5/D77GeLkJoi5BRC1KFSxCLyaKIZeBYABTPY5YOHDHHFP5KSg/SWk2iYIi+LTjX+ICHfoECw5BIWpv76vS/Jl2rfI5Sabn4x2+HSS50YaB0+u3t2mlwbKNxeCWGp3IOyVF+6V12ZdfVymZXiti8+dwTag0zSXrPce/j11pz+AjNjVIN62PskrmDHgOT4oDDqHkdaEbvAPI9C80F66O4rf+a+hQ5kP34Gs7Nzm7rpdQ7oGRF1QnSGPqe+yP/g97aHmxRyL5sSSDxh8LHhJxaxeP7hXQajKGZqymam1P/HRX3JL9muoOMgsaPx2i3YO9UhAIP9/YbiesVOXtfhcVVdLs50i50UXecCTFWPnj0C1D5IyVqajdgrV+OzI5bj1hO+GuVKS6pyYWtGJe6vQFT34SA7/lJU54kySZFCp8ipRdefwVnzhYGubAp3gLPnxnMr4Gbw3a2Ys6oGbYMHJdQWSZOxej7Smj6x5ZLal1zaRai515isrjFJ40q4IGEaWRS1QAog2RjQsK4c+MKbJL8qX89Sf6u4DWz5DGpBq7bEGw37AxU8RP0UkCZuB2TPZTzcckOK0Pg5zpapiPuVLWeCwxaqId/WtQ74XAO9fMMi5Iwo+IdXx7PPLq9NT2VYPZW3hWPjzOGuIzwmg8wplWXbrCzSp+WaLlQrdDfF72qHMiIoYjqaOADRM5OqZtVgUj0cmEE+1AzXqOBHm19GYgiD+7juUUM/fTy0FR8BiDPdIqg48KZf+E10/nAVGRsBQr8W4kgWPBuIOgd3l/uKfLG7NVq28Rqx/Xb0CNohEuG68gtXcFyDW6pIgscnNfaX/Q4xuaBCEZ43wyZYsMqpIX1OKiXzD2WuDAyeH8/QbtS8n71l9v39DyaWhy/InmJhDHOeGM1
 s5W+ZoGv
 HgczDR4rjfv5VgvVlS50eTDzsFkGFexpcBn0TnGfLS1dpGXHGFNI2vc/gU+s15k6XDoxbPjBh8pW3LdWhg3d4JbCJGWKLZ4oRArK3xIwVxHTKBDf0azam0ZHsS2bjZAIIV7xv27JhwQlOo6kfKCfGZmlRND7rdBzxcT91s397iH7pxZa8dz+Dm/QzF2HR/mUqhrT/j83RaXB6/2x8l6B7SNes3Yoy9q4mr4C23y308tEGMNMdgD6xVYjboV7xJbeZRKtDoMfi8Jkx27dFO0hMaEzm2NCuSsvCOV3PLirsmOnkOwCtkH4jp1j02QYncfg6B7m0E+JGMW7WeMSqYyKJ6YTC8/N/jiar8u5cfRscC2owM+cKIEwLv9Jqueq8swlS8P94goxuqMOSUJa06+9vpZwKj/mlGD272EXh6JHpDrqInyW+n0PDzCQYvD4RbR8M2S2k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that vma_alloc_folio aligns the address internally, drop the
redundant HPAGE_PMD_MASK alignment at the callsite.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..d689e6491ddb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1337,7 +1337,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
-	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
+	folio = vma_alloc_folio(gfp, order, vma, addr);
 
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
-- 
MST


