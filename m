Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC946CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509606B00DA; Mon, 11 May 2026 05:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1606B00DB; Mon, 11 May 2026 05:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1D96B00DC; Mon, 11 May 2026 05:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28A446B00DA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:02:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA3801A0672
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:31 +0000 (UTC)
X-FDA: 84754548102.07.42A1A35
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id B5F15120009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ijurj5ur;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=g6CZb+gPScf1lVN/S7XPKRQ4KmfenIADFU9s99fYsC+ayWDxQP7ndM2fr+yxOYABWJzH8p
	6So9vYb0u3fEREosVWpIB/7+8QJatFqlGjOvsa4puanwI7XzPyWkDEDHRmA3btULSOonQP
	IuzBjltDZRAk1VeM0N9WO/LLxPPASdE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ijurj5ur;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490149; a=rsa-sha256;
	cv=none;
	b=j7fWbd76ZEVn4h8S0pZkiRueevEXY0p1qkBW6cq2nV9XChlr5oW1mt5wfm3dCNC33DG8Uv
	KseSJrxEXlS9GKdTs0V/1hFm+HY19rwqvMlAEIyuixxz0U+GqGJCMe8mb4JyRhU/+nxOF6
	fVzPUgcwCSwNs1HKg83F1F0rUOpPy/Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
	b=ijurj5ursZI6LBsVPyLvZ/NdcoLvuz8kk/10D4qNen8VhJ71YBtcAyNK5OXQI3CHRKqYrx
	ymuzOR4621H6C3uX/dwUjLOoGqYmq4FBAn0cWKaKwnm2CqfvNiBZgEXNiARpKRkZYnCsLp
	23EYC/7TYFzxu6Xvk/WMZEA+oqJcIAU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-eYNihiIJPoCHCUB73HKz9w-1; Mon, 11 May 2026 05:02:27 -0400
X-MC-Unique: eYNihiIJPoCHCUB73HKz9w-1
X-Mimecast-MFC-AGG-ID: eYNihiIJPoCHCUB73HKz9w_1778490147
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43ff19e54beso2869447f8f.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490146; x=1779094946;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpAQ9O1oMgUNlo5ukg9OEno1SM1k+70VK2/jH7/8vVM=;
        b=cvuJjZQ4l/XO0omPrZixx+8r8gk5eAx3NoL0Akze6o14H/n5rVzZ5g9p5HFLIAVk2h
         j+BRCXCLF1ue++4ZlB24JjB4ZDGKf/hAcoNY6s83AMDSY4NBRGaDId9JW3PJDwWl7M/w
         eMJTJ5RC7H8wjow4TtxDxjSvLPZrj2/IzOrKndA5GzxaW+ks0FgieUvEFOsTJeq/7B05
         N94hunmsYHKQ6TND7Lfe99Wo7IQVp3ilbhWkwI+oWztgLoZpnJFsBxoSw3c8nBmdEMWI
         Fa7Z1xdJEgafmv4/WRcxbdLu+HMJc/CZkJuJ16aA26M2GsW9d5Druj06N2OsWU2Eo0sC
         MaoQ==
X-Forwarded-Encrypted: i=1; AFNElJ8gAvvjFG1A2xUMnyAfAgwCn5FkjNj/vG4NgwHpwtQcZ01Xs57Smxo4seazpaDiUdV5kr31Z9zRvQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3o7LmwodX0gZNq7ZRzAQW5aEiFqWlk+lamGpkctlF2InODg2B
	1obwZ3d5r3e8EVZYezdiqb8tt2BtrEwUMhDkhzJST2LZTL4SoKCwspC++XItj4mM8fIFw3IQXzl
	UN8NsRvuGTAPhl7z4EjoQeTebvuW1MauL+EcamPOFGsswKVpVxktF
X-Gm-Gg: Acq92OEpsQ4v2RJD8ITrykboyoxRJjs7ZXupqoQcSx1zztx+Q8ILE7oiDGc6wIjmfdY
	sBDQtjBnKkkYLRscRO95/dYmKecrlCkQgm5LtwiCaHK4gyRv5ijUQk2CruqWTqYDqSAIVsATv7q
	87lSrhmFAb/Z8hL8zRZvKRa67lj5f1wOplUT1IiEumxqQHAbrSlOrJEid1q+K0q99dTYmf/Hh33
	OJQiOn7BHtlj6g/0gz/+6BPGNH68wU7uDsnQkgMI+PsdaX/MGDAUhlJ9hdvADqzPC59u72TUNCm
	MX99aPKtdpF0vY5DRi5oLbJwKP72z4qCcg0Z50iJbmJewa9oyCPcH+Mwmzqmz0pBua9s0GxqBaj
	w6eNHPW/aW42gZZ+T3J5Kv+E2IWSxO94zstiUkLQ4
X-Received: by 2002:a05:6000:310a:b0:446:96b1:f51 with SMTP id ffacd0b85a97d-45462c34296mr20229235f8f.22.1778490146342;
        Mon, 11 May 2026 02:02:26 -0700 (PDT)
X-Received: by 2002:a05:6000:310a:b0:446:96b1:f51 with SMTP id ffacd0b85a97d-45462c34296mr20229157f8f.22.1778490145663;
        Mon, 11 May 2026 02:02:25 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4549120ec0asm23630828f8f.17.2026.05.11.02.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:02:25 -0700 (PDT)
Date: Mon, 11 May 2026 05:02:19 -0400
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
Subject: [PATCH resend v6 07/30] mm: use __GFP_ZERO in
 vma_alloc_zeroed_movable_folio
Message-ID: <c9448249c53681297f44d18c3396a3329b50d7eb.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2TjJ_bfNbvxxy-IbUiO5agYtQKEfnoKaTJU6qArGk6Y_1778490147
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: B5F15120009
X-Rspamd-Server: rspam06
X-Stat-Signature: euxku1wrw9iahx3siy5w1je7orsoshfm
X-HE-Tag: 1778490149-439053
X-HE-Meta: U2FsdGVkX18g2M3BDrj2yaaJeusoSPYzhNGoPxhmTc/FO9u9YDKl2C/3gsmBGdWk11uW95SMlim0WnGBUBuB6CaTr3vNPo9S4rWvv/nIjb+BaZKsZdu+ycmqcWJwAkWWM1ulQTkKo6EO61ZtDMo44JFH3CTZvLBuJRK4UHyL5l4OQoAKbR9eLefkOpN9Gj238RyEOmqusB7qRA9g3I3O/Pe9Ruaa8Dlaa75NcHhTM66hhCGyRFX3ozC0pOU3Ey/85xfyIURj3mEly2Vex/X86fdoscZo1tPj/6qPDxPULtBjvwyaIJvHzvrw0Zn/4bIPSMtNWDTtSTeS6iPdixtvTQ3tNrIT/5lXDxfOT7zLsmHLSEpDArASQkFaSx2AAPkCz2ejmVFTJFHL4zBLKUNSJ8RjcozoxP1yysh4sJ8xaYUxcj3fN5608K0CGGhiZxSsbt+KK3ccszS2hqkHD4TQ485wOb0Ak8iyslVw00dihuDbcJ6rRxIVSj6ko+HFDmBm6x1iPl/Pi1SbigDjDj0b4LQwjs0JX7/jb/ZJVedm2RwaGQydMSquhySRMqvugxnQ0P+aVTGTd9VtMgKXxmUP3TvPkZ+awQlh1kuPVK3Nqubpa1zpmKFFZuL4NU11SLOy2Fp+Ld4XOAVE5GUlt1zimH5ECskA6CkmvsreAXq3IyD8vWNKvKNkAJAeIjY0x2xkbmhmJU6jE4/wrIVD6RxQFndUlJGqOWHdch6EZx5j76xQ0dGPxNUeO/jtHIWXhC3j9BUFbwK/IAFKvJ5tNK8wiqSIrMx7gMBzpyZxezvAsAtz+dVMBkseixGxVC+Jh5kPGU8vXCy65/2WqqA7MdERn7d6O5nz54yuovToU+zIvMl4nU0rTiUzjxoXH8xb2ru8DFDlqR43J7iz26gjIqpqfATwfG01bPNfl3D1Vfbb2Ts+5ShDHx4RMDALI+YnRF+2XGZnvmORK/cWiOzFsFR
 77wrX9Bd
 lNLfzs1a1B5HHz9kc7wYlXSNYJm3jUqXavLEoadv6BzzWJSfy9WxPQJCP1Jt3UqNudJ+P2DtrGnq8MR9CuUlz2I5ZuX7cm6NKOezYF+COujyv282faZYMEI4c3boDkF006Bt0jQA28cHKfniEIjyf/zWZbrXfy0QnPfiwU2gJN12tY79HJ+D5qL2G4GeHDYWyDsidI1Py1x2lrDS0TM1z7q5Zkg4YkTBOjWJRZU9+ru7iCK/4kwjpoKRdlqAaDzohrr8bs9EdNjKkF1xLA+7+dMw0AD57RTYl8ThMwK7m50WmbRYn99/t3EQ2eu/apQeRBLBx2/TZXpdEI6zfR6ORLdvsVhmf5DZ6pMNi3hOT/nWsSQM9yfm2VznpXFmFbmhDgfBICQHNwSICPG7Y+KVEC9SUBxPwcOnKlNHp0Tj6c9jX7ORxAYhJWaoVWo3pAKbUP/6m
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


