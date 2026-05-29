Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FA3ACD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD386B00D8; Fri, 29 May 2026 11:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4186B00DA; Fri, 29 May 2026 11:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3CA6B00DB; Fri, 29 May 2026 11:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7DA16B00D8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:23:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 688531C0272
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:20 +0000 (UTC)
X-FDA: 84820826160.19.9179297
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2AF4D14001B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YTyJCtn4;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=cLfApWgzQaRjkB3JeTgxcTegmRNM2FL6zt1MzFSGaQxiGiv8ZlJGML6JpTDISiy5SH9ypu
	FeH/154UhJQQnI9zNKhBtz8RuSwZqkINZDkGq2H73YFZU2dHepsniVI3yAI1w0WW5XFAOW
	RA2HY2MHEnxr2IvWo5+xLzg3YMqVRuc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068197; a=rsa-sha256;
	cv=none;
	b=fKS4r0xvdcT+4xmgPPC9FFK9r7xMYCCZRe0HUMs4x2xVPxupITinxp+74mMuAbu3cEGS1w
	vMiFeiVaOVtayZhlZzU177JlQUhYMr+NFteUvI0hG1R3DAxnz+W9EDav0Y3JaDW01p+CEQ
	IDtDKMFb09IfrtBp7hkFQQ698+aW2eg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YTyJCtn4;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=YTyJCtn4mPExPTO0zgeD2h79mhz9HnfK/oDGkYhb2NG3n7WFbpnADmS1vxNy2sN2HJIt8r
	hB2nSOdfwHSH7VU22xiqOQw4THcvgm7In2txs+MZoiixB2OABT3hOaz/dNV3E3wgWUTnuU
	P+gyHHvbMYM01VvP4UXt0YbrdwV0J5I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-kLuPBT4fNGqvf4SjrCt_jQ-1; Fri, 29 May 2026 11:23:15 -0400
X-MC-Unique: kLuPBT4fNGqvf4SjrCt_jQ-1
X-Mimecast-MFC-AGG-ID: kLuPBT4fNGqvf4SjrCt_jQ_1780068194
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4909deb82d0so5870855e9.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068194; x=1780672994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
        b=M62EL/kJnk+HKdG1MEURKq3JEDe8Eq6PcvAVp1xTwH0x64L9+ec8EFqpP7CJdvU2Ls
         vcYXuB+AIeUlyvG5v/fmuKJpn/3HLejR+3k1gWbXIOEORi1mGr7XAsKsvDcyVuZvk6UY
         0QTcbf3ikQrTVuVGm1N7NwvSBR/GmphUJ3cqHbg5SYktW494QW9YkE/tzNvp4HF9fny8
         hi6YTNfblxRdY2C8F7+sSHUjGT4N1cMgOsiIDy5kf+JNcgew/or+VRXe9V1zj/Zcw59Y
         YVkx3Mp8LmnCYVCcJBlQZ9WpvvdHrG/M2lBFt1LxnMw0g3fme+1KBxJdej/MS77eDKA1
         IcQw==
X-Forwarded-Encrypted: i=1; AFNElJ+ffdDkB3i5tEMJNRHVtqQDX3IbRWNNjhrHTe8DRLteu5AEgBOwr/FpzDAmI5JbzRe6IwOIsbLcJQ==@kvack.org
X-Gm-Message-State: AOJu0Yw50jRBIPLXWBqGsQpDo2z+Ku85+TA5/VebO9FOHrnN/tzwj6GF
	QWz1DPwTQxDusRe/Mbz2YvQYe/XogVb4mnguN+IOh6OaFzvdhVpuNEvXdTW86jzYdLP2M8IB1Iw
	0cWPyin6pmxvdhAc0HmVrfY2StKptOsNMDTWLL5kM5v9eZoH5c4M6
X-Gm-Gg: Acq92OGSZUuuuwHKDT4q6JuOi3YxPZMaDRL+/+CEXFU9PHoR5HFr4NzroXN5x6oJrFK
	O1rUdnoCOMv7O9/+bx5DvJYtPLx6HGc7uVFSB9A1klg9TdicGkj8N4kM+MaXQGim7BU9VfcPqie
	MOOhlfWIHq1gY81jtTvIZC9Z1e1TbI9hJ2GI1sFDfqD0XR7hxpbF310ksINX17E6kOALENH6OrX
	eNj05L4JBnQ6MTMig1KkSbM65u90CAgNAHv8VhOPL2aWBCs69Xal67ccSm/3/r7ZQW698cQnxu3
	4BwNW97CUN0a/Top7Bkcw95DAJPaR9jTXh9/eJJwQgx9iGv4p1qyNMuXbbGSGEYhbEnFrJe4RPg
	sonkUrjUaeTxBbIrhWGIsGP4hCOiexoYop2aOP6TAhNDCPU+vb6ijKg==
X-Received: by 2002:a05:600c:3587:b0:490:958f:2a5e with SMTP id 5b1f17b1804b1-490a291d967mr2191585e9.13.1780068194001;
        Fri, 29 May 2026 08:23:14 -0700 (PDT)
X-Received: by 2002:a05:600c:3587:b0:490:958f:2a5e with SMTP id 5b1f17b1804b1-490a291d967mr2190915e9.13.1780068193465;
        Fri, 29 May 2026 08:23:13 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef35601d7sm5881021f8f.28.2026.05.29.08.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:23:13 -0700 (PDT)
Date: Fri, 29 May 2026 11:23:08 -0400
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
Subject: [PATCH v9 13/37] mm: use __GFP_ZERO in vma_alloc_zeroed_movable_folio
Message-ID: <caa240ff3163c6ad118156a38aef54f48af0f942.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rPA4ujPRZK2S_34N6mQ5yzgw8J38fjN3IgatQbU8y0Q_1780068194
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: 3wdd8m5buk346ae3c4ga91nhfqjaybn9
X-Rspamd-Queue-Id: 2AF4D14001B
X-Rspam-User: 
X-HE-Tag: 1780068196-893477
X-HE-Meta: U2FsdGVkX19X95UwlhMUWMqBJtXa3j3n7P1zV70sCdVsPLP0Ns4QNrl0q8PvTTT0c3XFtWySjoG9iJJMr724uPO4bFBO+lr+FMNjO629KUSNK+oD7ED1XgZWjGZTcENWqb5RcNrmeITu+szG8cCU+4fSmp/rhuXAlFdg2yCuY2CLiG5lxe4pI6VViKpD4mdJml1J5T328y5VxvmzGfncTyCwZQK8m7u9mx3KxW8BNRLNEtfABuIF6znLHHt7R+oBorcrMDb1s8kashwLdKiPHitsPaTEbZHexGpIYf+OsCrPHFtKJ7P+JKPFAamVguTJEaFx9sFD81/eJmF5QuxgDKe1wSlDGlc1pNmXBi1iaby9Ejra+JqSFzCLGNvIUoN9kCH0aDtRy8DtxoxlG4aq0yl+J6I17N7s/kVZHsLgkokyJe9UJRYQELJFZZcbNF0Wum7NwLeAJTQX4RPsab0zRPVB43ZY601yEIpI6V239TEsvHhJ3K/QFvVm8hiRX5QS7Vlf0RtnkFhaOBNqD+fY6IiCcIIZ2mvNwaHYYhH0j209SvXf7jtYTfwwSkqLEeqkL/jwDjyxxx8fD4y4qf4DKIZ87x4QnmGvBX201la1zy2A0RvsXxTuF+xUqNb8US6lThmDSk/jmKKJhKv2SXprSFtveWjLN6B4p9B0cmi8D+T9HNIGY/tB2P+oGPdDl33Ic0iJbE721ZGhF1584AcYJsvgyPtl4YCSyrCGrvtoU/EaBkuVuK+osRw7Hb30eoNsFhbPqarqr29T6FFWToE3siegV/MC17E3PBnHjV4541dJlomwrlzXpVb1XlhYpgDeE8HrAiYOiFpRJ4Mb4fvkhLs0TZm9j9peu+9zBZLeK5ePHuuMAu9n75E0IGNBdAflsHomXyy1O3W4IlqK2ENU3TI2YEEY3nJ0sGJ/qEaoTjdytEnTED05nXg9dN2uEd1xef5fWuLcUwZUbOFrr1J
 VMky/G/8
 rV8Cdin4UWb1JOgTjiqH8nbvBk6dwN42YqLFMlyKdQgTHpIt3PzIpSKcxnz3j5sj7TMa8fGULBpFHh1bIf6EQMxImivqV3rh9tsa7SEQjqHjz1l89RhzWIE3mJ77Fwxl6TUXrSkjoSNZ4Du4dKAb7c0RCW7umFxbaViluu/o61tOA6x9VNb8mod+ogenmqaeL6hk6wLykibSAcpk3jm9KKHQnM4vnFNuDM0QTo2w4DAKLAVtNtEKvPJNLdHoNUhlAFFgtrQMV0+zVVZKgVZI5lbruY/zavjhBpSHEuLqUfgJ/jjWl1FqIHFfUojcUBhVOlfkUF1VDsbszL6nbW6IYq6ykH50pEx+kRWG3O3Kegth+G4RaeMfpjKsWSgoGmyr6Ea9ajkyNM40cU3rQNF5B3J1UDy08RAOVKAhdiHVMIrPihthVwdyAYH7TH0CrOU8IQPk1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that post_alloc_hook() handles cache-friendly user page
zeroing via folio_zero_user(), convert vma_alloc_zeroed_movable_folio()
to pass __GFP_ZERO instead of zeroing at the callsite.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/highmem.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..ffa683f64f1d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -320,13 +320,8 @@ static inline
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 				   unsigned long vaddr)
 {
-	struct folio *folio;
-
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio && user_alloc_needs_zeroing())
-		clear_user_highpage(&folio->page, vaddr);
-
-	return folio;
+	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
+			      0, vma, vaddr);
 }
 #endif
 
-- 
MST


