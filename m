Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8808B606A330
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gi1agw5A
Received: by kanga.kvack.org (Postfix)
	id EBA8D6B05E6; Thu, 19 Nov 2026 07:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BDF6B05E7; Thu, 19 Nov 2026 07:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82236B0627; Thu, 19 Nov 2026 07:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8E646B05E6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:02:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AB31120A90
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:02:47 +0000 (UTC)
X-FDA: 85451731974.10.7468FBA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id CB69C180012
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:02:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gi1agw5A;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089765;
	b=qtzHVqoLtNHLMvcLTdXuKzpqq/JR7aQyHazZNah6z0Bixq79T+OHc7mxRL0Er6rtSm5RmX
	tC1j1XuO4ZeBQLKyxo6x9xHtD02qMH1DixGRj0orMrHsIaAxVAj3a26GK7MD1h80+YGhTt
	PdL/mDVtz/b786TOoBM2uj6ay2CblVs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4AW+1r5ioYbTqiBhF66CNLfZpJFNCdMJyMeafN4jyY=;
	b=cdaKfBNmw2ZB/dU+m2pgNia/LPhCl+o2/QC5zrZ3zk/d16X5kc9n93dKWmwLsyPpMEqAB9
	1VZwOoRfyBCHA7JmzjEc3z82qzF5LRbv5XQlL19stjWa4nxhnMc5TLVA7jWdD/AdKmhsc8
	bGgW37LY4xSnnkYKdcFfjD2AfvMsalA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gi1agw5A;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795089764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4AW+1r5ioYbTqiBhF66CNLfZpJFNCdMJyMeafN4jyY=;
	b=gi1agw5ApvlhZONZ3u/TuG1vqa8Gk+HC2sbIAoguZZ6G+FXsbzSFYOqXZZqhWEc/7pAofi
	LgngcpfpCAMT46GymxiIYEVeA1MOd9N3oP5N6S6DSVblaptEBlt4qlyBPMcSkYtLkKOxKT
	HLyPwtj2Qy3CNQiPlO5IcnSGngaRin0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-EkOlRSDkPUaT0ki1bBPTUA-1; Thu, 19 Nov 2026 07:02:42 -0500
X-MC-Unique: EkOlRSDkPUaT0ki1bBPTUA-1
X-Mimecast-MFC-AGG-ID: EkOlRSDkPUaT0ki1bBPTUA_1795089762
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c50549f6cf1so145272566b.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:02:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795089761; x=1795694561;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A4AW+1r5ioYbTqiBhF66CNLfZpJFNCdMJyMeafN4jyY=;
        b=quwG0TkvcwUip3gApQyjQb/8tqAoCyVs5l+9ryB4q+JHKG9RMiBGkNK+PWf7pyVacl
         Ugm17iLcwrJ/yofH5HdWJA0kk2xyIgzzPNiIEFbMTb3QtE1PklK2SSAIvvwiekTCPXfB
         miENp5SNmY6xD8PdIuaUfY+NCTvYe1nJXG6A2dExmTb1jJcKOOomSIl01fV/O2M+5PXm
         6JXpPIpqO991vECBDEBSh/TmjE2CSa41TUdqj0uJrg4aX+BsqQHaKN7akPprdiG7qQVi
         TlZjq5aEpS+Q3/X8FsjqA9lnplv11Ku2SBUxW12NcMr85sDlmXxev6yu8bJ2/nVRDqvb
         rMFg==
X-Forwarded-Encrypted: i=1; AL+hErFz/shpj5bvgcyub39Jf7jDaOeD2dy18YZ65t0nUcoIde+QHRcyoWNVIKQKGjhov5fwbcdfPG8n2w==@kvack.org
X-Gm-Message-State: APuU4Z9+81F2Uo38WpgHmIgWPRnEDKsiCCDQW+//wgjAR2eYTvWYC7HX
	mEvTG0T1VizXPlDP7zKcX5rvxSVQ2k87k1u10CNvkna8CpwV/E/+H+oXOzyUzp5GSrcDpEc9FR6
	wshTKbnjUjHvQyIBhyeB4ZyoIPyaELWStw7TAtnigMAnufzBdV8kn
X-Gm-Gg: AYBFou2ZaTl/OUMJ7mQaubaOiNUdEYSSnAKgPcyu95bxd8nfVhoHFhJdMCerI9hjzAJ
	TsJ6SBLLwwNzTV8fAreNMObCdhRGF3jC+2QLTFSq7QUE8LJzVP7UWkMZ1sZau60n2wI2biJV1BT
	xLDNnYNYKYx7cj9P3dZeDC3NqBNzqoH5u3OA28Prn3mX8v+ihCpmf7taJnBmHxFoPnrZW4uxFZT
	bnvZ79+F9KJFNSfY0iiCmkLDUpJKYVOPIED0di6/kB2qaSgxFjhKWWdfBBnr6r/hKaCJR4HR0ds
	VZNtAsu5fR6byWcCxhV+0qC/FEkMycmIBN+fF1iBrLmaNl4zDpcnGMMcrD2DQy5fHxyJj5VacTp
	NsAtclJIVK3GGgLkjg3W6V9/tgM2aYC3Kc0D3wT3rYXA=
X-Received: by 2002:a17:907:6d1f:b0:c46:8b87:c1f4 with SMTP id a640c23a62f3a-c510e2d4ee1mr524866366b.20.1795089761411;
        Thu, 19 Nov 2026 04:02:41 -0800 (PST)
X-Received: by 2002:a17:907:6d1f:b0:c46:8b87:c1f4 with SMTP id a640c23a62f3a-c510e2d4ee1mr524859666b.20.1795089760723;
        Thu, 19 Nov 2026 04:02:40 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1520:4400:d78d:7b2d:2f5d:e08f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a655f9f4a7sm10439162f8f.34.2026.11.19.04.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 04:02:39 -0800 (PST)
Date: Thu, 19 Nov 2026 07:02:36 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, virtualization@lists.linux.dev,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: [PATCH v11 2/7] mm: page_reporting: support host-zeroed reported
 pages
Message-ID: <2ec112cbdde76a60ab235a0df7734a23387f1c86.1795089715.git.mst@redhat.com>
References: <cover.1795089715.git.mst@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1795089715.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aSZJsowjt80Tbxp0f3VoG8MH_KFgLrNhkBVH_6fYe1k_1795089762
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB69C180012
X-Rspam-User:
X-Stat-Signature: hf18b38dha1s5k6qagpoxqwqkqp69wmi
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795089764-799453
X-HE-Meta: U2FsdGVkX1++5rf/n9zf6uSFGgVIsheaocYyFW8g4Dpec8FxQpFBrbnVJ2909UQrV4OsJlrYessHOktwVAYjCFFjBdsyZFJvrB/I9wLFfGDpCEszgbl+90FObIwiFK/gN5oztKsk2gg3a42m/PuW6ZTaP84ufxVYG2BPeTBtNEIJQE9zepPgQXgz/ET0PnJ9/+kfhI+OzEjSdHRc7We1Qhfw9U5UDA38oRF9EGToZKAR83mxNv/58RuWSwGBz2Ru5xhv4qhoEottKOXeF9IbTVdm66EJUpaK225MCWeQ6z7+YTTLuNalwTNVmnYDYQrZx71pYhlxZIikXIJmxO9YXb5QPhdkSsX70G919fuGFSL+MN16WATtIXwbkoPlwfo6fLEdN7ftN+8wf21ENckyNG4pYBK+5haJGGulYI8PiTNtIBPM9ESzqSjFQ5LBYCjesaQC3/4q3iTKtf8J5ZU1rLvSzzo/SnAoO7Ars7aqmtO7NMn2Kq+RO6wlB9dZPUfoqrtR4kNMFUl7n9LpYilCYpzKmxQdwKyYR2nYUNIQ6NRetxNva4H6toi8WNFgE168BxkMf7KuvuGqTy680bXo9AO2kMrgyF4arO1WsgR9g8Ylqxms+dzxQsnrDwGPwjZahl2VpdZHUXV8EofSKnWo535bg2S8JGRQ3aFD+YA/Kw59m76XSCDyjtjCTv2sO8okngUKBDvygHVyyk6zHP2rADpjGlc+1acqLIF+/bF5PvK/N9SMRu095jgId43Z+ASmVj5xnP+bv2KIDq+VXs71mTGss2XC7nI3H9w/1MAyIux9B22Kq0ZawPeNCpdzyuLrm5YpjUGuNxCigOswGk2/AACaibPIYz6zsLZWcaFBNvGjFHXaitDYQZTEmTgpg9GB95/xtfzjFAu5XNKRETKhyCRn0agJFZY8eKbvBv7wPqOzUJtTtSYrTzCERV4aAH4jl4HWIhPdNFL+5G6H/0n
 prfbKfUL
 CUmBmCFbHOM3JJYlNP2f+PgwZvED5Ph/XdAZ78fDlQmqf77BKLBMDPdk7s5rJIFjvGIayYtZBuO4NXiI9qQ07RUaLmscmIXnSn1Qy1batNLsCcNLQYNVr6teJ6PUW7a6ZciH8i3ZSBuRbEuDX4vfk2YoecmfKeu8JR73bg4ciJSSunMcVyn3iWy3K5FZS8oq2zyMB+kAmGuipFryRSIo5oLsFKM7x/sDvtkTiCFcN+/Q4otlR9QnPIMjjZ2djZsjBLVfpSsYB7eGXSmy4a9aHLiQw6uY7Laj4vvzoWxNfGwJFo+nB6rpF/I9gxwuruA7BbuHT+6iiYyJxyuGhsHxJbbbeGiGPY39tA8IDdrn31rc7c0aEkgzD1lrVxlmtQcM1wLBkVixX27Ji/II+byQU0kc4QOVXqTcDSxxisJZ7jsXT3Aa42lleA02+F5BJ5K3pYL58i5HyFe7/977Ej2Oa3nd+Ky6UQk1hV94gXUTS4DrDUux+cHFBAngN0CDG219iTXLi8eqHNGM7IKvcV2n4ttcRvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
page reporting devices to declare that their host zeros reported pages
on reclaim.

On successful reporting by such a device that guarantees zero contents, set
PG_zeroed.

Note, that hosts zero the pages for guests, safely, even on
architectures with aliasing data caches, and even without knowing the
guest user virtual addresses.

Specifically, ARM64 data caches behave as PIPT; KVM handles cache maintenance
around stage-2 mappings and invalidates the whole I-cache when it aliases.
On aliasing MIPS, host unmapping flushes the whole D-cache, and slow GUP
flushes the host aliases of replacement backing pages before KVM maps
them.

Any host that can't handle this, will simply not set the flag in its
page reporting device.

No driver sets host_zeroes_pages yet.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
---
 include/linux/page_reporting.h | 8 ++++++++
 mm/page_reporting.c            | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index 272b1274efdc1..49adfc5d45804 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -13,6 +13,14 @@ struct page_reporting_dev_info {
 	int (*report)(struct page_reporting_dev_info *prdev,
 		      struct scatterlist *sg, unsigned int nents);
 
+	/*
+	 * If true, the host zeros reported pages on reclaim.
+	 * This includes any architecture-required cache flushing or
+	 * invalidation, especially on architectures with aliasing data
+	 * caches, so guest accesses observe the zeroed contents.
+	 */
+	bool host_zeroes_pages;
+
 	/* work struct for processing reports */
 	struct delayed_work work;
 
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index de587be178010..841dcd64777d1 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -127,6 +127,9 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		int mt = get_pageblock_migratetype(page);
 		unsigned int order = get_order(sg->length);
 
+		if (reported && prdev->host_zeroes_pages)
+			__SetPageZeroed(page);
+
 		__putback_isolated_page(page, order, mt);
 
 		/* If the pages were not reported due to error skip flagging */
-- 
MST


