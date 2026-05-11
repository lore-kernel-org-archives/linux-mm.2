Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9897CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E316B009F; Mon, 11 May 2026 04:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BEDE6B00A0; Mon, 11 May 2026 04:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5346B00A1; Mon, 11 May 2026 04:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4DC6B009F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD9FD1A0625
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:36 +0000 (UTC)
X-FDA: 84754525632.16.A788C07
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id A987980008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UP7zIgjs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489614; a=rsa-sha256;
	cv=none;
	b=34cD7j9CUOW69gFLPbZ7TtdPLN34ENodxHcitilG6iwMySdeHHsJgfTjsx+iE7aVb8GKet
	nMupCvsowgTUhCCjO8wFCg/oe67J5iWQz+COdfv20QKkwJLO5iRxfU9D1zOIBV251lyyb5
	6SDRKGVwhZ6uqTgRA/SRJolyh5hVoLs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UP7zIgjs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PyhJPD76XSlXOLIxrgX26vlRXB2m99TPkgzm+4tnrhY=;
	b=wrbI9veavcg5QRHuhLnNat3hHxN/G0suZBgB9/gHJl7+4jMV3/orlw520knDQw79+KMPdc
	3o+zL3Ce/TpxuVrO5QHmZVPpc0htbQOb3fvHC24HcfEMbURV8hgh9POnqOi/9aDO+o18AT
	A941hsvUxkboC35dEYQGwwUVHVfRQdA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PyhJPD76XSlXOLIxrgX26vlRXB2m99TPkgzm+4tnrhY=;
	b=UP7zIgjsDYuqfZffq+BqUZ8G5KPYSa8esW5yi5WUmtE06mILBCKyxKWpVdPehcimA5GXo7
	m8WQxuZuRkfKQruTPhHokLyooPGBGTmT8sP1RbqUz44kBBKi2+MbSgIyGHpnDfl9Ch6+Vn
	BajS44Agx3s7uhGqH07ZsKs9cqOof5A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-OaCtJagDOXeNipL8O6rrKQ-1; Mon, 11 May 2026 04:53:33 -0400
X-MC-Unique: OaCtJagDOXeNipL8O6rrKQ-1
X-Mimecast-MFC-AGG-ID: OaCtJagDOXeNipL8O6rrKQ_1778489612
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4411a1f9601so3122460f8f.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489610; x=1779094410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PyhJPD76XSlXOLIxrgX26vlRXB2m99TPkgzm+4tnrhY=;
        b=JIShiwSJgtFmpVnG7WlRPV5Ix+m48YdSnXcPidfHL3PxyI76KZ83mpJ+zHtMEVxZfs
         bpRHSOE3xNiCQ0rXcZV57leh8Z89P+v+Y4OYauh4LIQ+ejDq4p5BQQI7OQo+lEBrU3+v
         0BCJf3+xxsTRZTnkCqpFRipLHJoh1ArTU9Oj+l1Ob2t8UFoXPd//jyIVmennacmCDEYO
         8b4EBws1nE0BDxFN9nBE9eGKAFJw8QfmdckzqtPNdhmZw7WxZ05YPWX3onB55GodSGYt
         uM5M8xLhaoLiJ7oQTzHShiGSUnwBAgsrUsPPZOhCMejubci/zbRF2+umXmdZCiw+q1rO
         GnDw==
X-Forwarded-Encrypted: i=1; AFNElJ/yKcBTLBxlVbkzDjyVJzObS8hl+7BJQjjG9U5p00JBzeza9yo8G8PZL8rwzNc1u8otO5u2gzBRqg==@kvack.org
X-Gm-Message-State: AOJu0YyXfEbaIUIAmRgYCbgwBNoRMTNgbf4VbfcnUf6aeZ5peVA8XO2J
	RBRdImUKqPrrZQHqPMsnWvDdNFqw2U4Sg8VBWGEHFt5e69HE8EsDC/N+G+leWc1zkDLMA/qMhjF
	g0vFYcj8yYFlEVgmtj7J4fdYKuXx0S58S2fr9AmabGW1eBI5bmfLR
X-Gm-Gg: Acq92OH/TfNFgO3gr3n4XgI68oZJbvm0bp0Qmy1/ipXnXktihFpPiB/IBYa7oVwnOvi
	qy3tb7+FsyfNpM37Sulnl1AUTQ8APZkm/hescfzeI51m/ABD8Paxu1U/GqWggzkkKYhcz2A5yqb
	iFPGLMvurNuuO13C2CJAjsiH0ebIGVT9j6kdiMsexuk8bpVFJ1fGMkiTqyg5bFiZSx3JVXoSB8m
	SJE94Gx+yxy9HtutElxIpr3lSulC/c1A444emP7i3K6vmIin94PnSmUt2XJrANjvmUEyOsRZF6A
	GstTicMj+xKRETJVZqzUWzd3+W7SGI+390qAe7/7igdRAbezNNF/q8VQRI8qriRDPESUVPalrfG
	YdqPO6epQaISWoKmYiTaJuS82c1faQicRaWW0B6H0jzdv1CBj4RM=
X-Received: by 2002:a05:6000:24c9:b0:43f:dc54:9493 with SMTP id ffacd0b85a97d-4515c575364mr37802039f8f.21.1778489609626;
        Mon, 11 May 2026 01:53:29 -0700 (PDT)
X-Received: by 2002:a05:6000:24c9:b0:43f:dc54:9493 with SMTP id ffacd0b85a97d-4515c575364mr37801957f8f.21.1778489608944;
        Mon, 11 May 2026 01:53:28 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491da03a7sm24453888f8f.33.2026.05.11.01.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:53:28 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:23 -0400
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
Subject: [PATCH v6 08/30] mm: alloc_anon_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <a48bd110f808ef8df6cef819b11580bc10ff38d3.1778487000.git.mst@redhat.com>
References: <cover.1778487000.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778487000.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bgKw8v9ru6RLJJKvmI7Cgd5qlF-JCLFj1FpeRA4mw8g_1778489612
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: thc1knwr5sn8jcwdj1ysgnc6sdmkrith
X-Rspam-User: 
X-Rspamd-Queue-Id: A987980008
X-Rspamd-Server: rspam07
X-HE-Tag: 1778489614-892052
X-HE-Meta: U2FsdGVkX191LzZ87jNgbjEgu0IyRvDQj0zzyPi7xSGs4T8+yN8OTufoKphTD6lCghWP93z4O/n2G17ff1SasbXARNMtgL9M7nasyLjyl1Rziw8C4+ckIwpO8n0ZxIj5QzALWiPPYAGktB47dgLioyWOh5gzPTu7XaKGIc+j+D+60SQqf9tmLvXGTFZRQkvOn4vacKuz3VUXRRSTzOFmS0v3bAFGJvg38CXo5UV57JU6sEXunvuNXyLKFnpXbH98fAGn+WUW/5Fitp30bxKnbchR1wRT5iAcUd1dFp/broQbamxqMSs9vjxE5f44kMSMCDYYkQpFSMd7YfSeZx4irFMT3XIy11x6XsS/BzLvq5RwDQ8QtghUFTlvbpEOHL5RkPyglI8R762VqsaIHL2N4R2pBTPyKtG1BWoL6em+AH6RG5JWv2V8jKD+Gl8w67ziHBP1u9wtsqLb+LKqOj2TGQP59up82K4b/KKSFEYf+QL7pEiKXfKibk4zQWS6mX1WN+iYat+c3h4b4VKzSP2H03I8ZqLRmApEt/8f8PiGysIEOfkZTpQs7ygtfI2+JKlbKJZOsWdGrKgLjqbZJ6rLJqa0bwvc5CJhjqnB98Ib7ak6aQK3o0/uxpGuaoeDG/tjg8UynPcoSEax/8KI4HETHJSyywdPyNXx6WQ15ppSLAt0JuzVu+E+4tv95pFn6rpj5aQf6PrTx/gMviUOg20HkXni5k1x3rbQIVsGoYDD1avEvkEhWG0gUayJEtMVEXKlSemMRpE5ddBNvtGYj0IKQjIC/2kygP3niINxVp0Zi1j3ILkUrio/SryqHgj+5qF4CvZBQFdu3JgR1d5arYYUCsKIM1G9QGxBKF1nMuTVj5O/2gAzb54BTjOibjCOvgMSrWTEBXLkckR9s949lHCk63rgp/NGCsPDpP3lXKT/jb5WA4Jlxbd2mEhmsUFqpBDAJpvcZzNmF5laC8R2QK9
 nM+OANb8
 awaXoZQYTkEdyx9R1U6f5CsMT0YxZNkq7V7f9IyEFvomACLwJXMw9xT48ZUKHQd5mt40gWZEfYMM1Ms+hsqvAclTe/y94e/tUheHcagAj0e2gOdyO/PYBxdr1agYHpWYL86Ht7LUja6hvadw7SpfL9hiajqNydbmkQ6lzD6WTu03qilGFWhK6XM2Xcy/jes8iIPrURXaMhIsbPqLPAFURDvqAUtDRc6VJpJNjlEpTXYGZkG0HcbJ1h0IsZza/6qo9JAXeV8Ud+oxS7LmsjhP01jT2z8MFbvUMgxARXTdGdLZZS/kKq8rfL5vmLz8XDckr6KJZUy3tbeu5d6UxeSMWBCKz1WnMsDna+RIquvxxzfECf8lI/EpWlsBMOCbEnsfcA+SlGXz0KHodVroXtm+YmkUSLpJZjW4pNTEbTN+20fg/sNl1YHlt78CaFTQGZJsP/wUq9Rcm8KtXPOTiaA2rQIeG8bZg+4u+WvuP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
vma_alloc_folio_noprof now aligns internally for NUMA interleave,
and post_alloc_hook will use the raw address for cache-friendly
zeroing via folio_zero_user().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..0824441a6ba1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5252,8 +5252,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-- 
MST


