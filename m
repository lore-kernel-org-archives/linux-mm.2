Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA9F6CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7A86B00AE; Mon, 11 May 2026 04:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF816B00B0; Mon, 11 May 2026 04:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5BE6B00B1; Mon, 11 May 2026 04:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA526B00AE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EE651C057B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:14 +0000 (UTC)
X-FDA: 84754527228.17.5F12D2F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id C502C2000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XFJOCFmX;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
	b=wvfjGat+aaQBUBN2KV9U360ThDXbyWQdmSKSTMiPbshLkCVwcqX/2r8vMviwL7LgJrcG3x
	pkDQzdYXwIicpNZrLu12mg+8o7lRK92AJjUwQwSJ2pWZzuTOBDYPjdar6KaRTavMDBPWJ6
	H53RtkPil8k1Ac6bwFTybJRniERSgvI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XFJOCFmX;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489651; a=rsa-sha256;
	cv=none;
	b=zkROTrTTn6JlrXDeKPAg2gNb/NkFZXosAHKlyPnnPN6xdMJQdx9H+3uRkJrzixx6aHxZ0L
	b+RNsK135/1dT2uV1ZLfuSDsIDY6SVg4Ef5vB1dAZqqqcK4nbALNQeSSSpOsRP7RJ/hHJl
	5F3RQNpMdUO9xc9I37VoRx+jHAx+DIw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
	b=XFJOCFmXUcfQl8khgZmTOmarW4gqaft0yCUwHAgk9igGJTfHhMEvuG50iM0He1pb7Wx6gQ
	+AneG2qhp/rxe/EjrJH6LyBKWKJIvS8SeIQMvfDWKocTuDNHxaQlG6c8HjeLieFbaDq04g
	f34XUpB7SD+P8AJ0qET/Tfn2OEldLf4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-VvdXsgrZP5yTJI6W3KXOMQ-1; Mon, 11 May 2026 04:54:09 -0400
X-MC-Unique: VvdXsgrZP5yTJI6W3KXOMQ-1
X-Mimecast-MFC-AGG-ID: VvdXsgrZP5yTJI6W3KXOMQ_1778489648
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48a55de6fb0so28043255e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489648; x=1779094448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=awVRqRC+b/AmjARdxVJbu/50IYPO1xelbVaktsnFd6g=;
        b=e8+QGFOcDFZ+gTGJVT/X2hpUk5KENUEnPNJ08QuMTW3T0jnZfo2CXKwYc+m74D0awt
         eSwSb4C8o5jg5JyaKxbCz8AlW1eNrDvTNW22qyep6xk682xWYU3VVExMLfE2CKKGEXbp
         kUnHWkyKoywz3ab2Wv42aScW4sMr0c8l9SXO5gkKpgrRpvI+rYxgXsQ9RQqBQFf1Zl/g
         dHVmjLfPBHpQMSOS9qiyVP//CTouFAVLZQP8L4dNS/wpzBizUxoP27gniBK5lSciOJf6
         RfzHAcRBiNoE9V0/PD/f2qmNttdKKB27eXwDRuZInWEUFKPKhhYJtn4rDdiQ9pdpnaON
         3svQ==
X-Forwarded-Encrypted: i=1; AFNElJ8eA3hyONqm6luJmxWgJgkbxebdkqykemFBnOc8yafz9RbC1kfn87JVAP455iIMt+esD+sryg32gQ==@kvack.org
X-Gm-Message-State: AOJu0YxjFngX63JuF9urn0hTDu3UP+PXxHXyWJg/Wm3RxxmWv/0oIoLX
	OC63z9KhXihc+pkH7LmCkylGiDeQ6ATjelME+fU59LSTXSKDMp73U9CJRTaq1sMERtNZmdKQCo8
	lttMn2nVLuLuh+RI20NXUN6MThhuEJVdJAp+UKq/tR08vOaFSmzOc
X-Gm-Gg: Acq92OFBsrIbsOu5dXTH5eOVeVG4zhTCl/ZT118eKQVpRmVOYwkUR/U6ukfBGIsCwGO
	5DJLBZ4oQJMpaF3ivzUG/hPwrUkMWGjicGDnmo+565xUEcRbjJ3RMQ0aOHt93xLwvJScVpUvbLo
	Tm+TF4qXXG2h7xeEDtqadAXSwcL/G8KjnU3rJa0DvZzpiPcrWGNwM20VFEvJgareULpblcZ2Jrp
	qsCR0eDTymaTsdykebTCrEhKJw1FNPKOuj23qvIzavmkE+qH4S793u/dKOZHcfumTEe1SRYQ4Hz
	h04pT1ymn5v7c3nvNp1SLQtRqq5OaoVf+hFfGQ7eIA9NJY2EkjIGt2PQx3okbSPKzLQAKpjFkwz
	XMOW103LwqYYi9TbZlEo0WuSMENWzonc+D5LhlQPs
X-Received: by 2002:a05:600d:849c:20b0:488:a2ac:a34c with SMTP id 5b1f17b1804b1-48e51f220e7mr276899625e9.12.1778489648195;
        Mon, 11 May 2026 01:54:08 -0700 (PDT)
X-Received: by 2002:a05:600d:849c:20b0:488:a2ac:a34c with SMTP id 5b1f17b1804b1-48e51f220e7mr276898665e9.12.1778489647611;
        Mon, 11 May 2026 01:54:07 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d8f1a57sm60732895e9.14.2026.05.11.01.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:07 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:02 -0400
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
Subject: [PATCH v6 11/30] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <65eec790aa9aa96d8090f3be7030bc47fa4ef84d.1778487000.git.mst@redhat.com>
References: <cover.1778487000.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778487000.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yM3uxm644gz6UBi_l0TNV2YrFmxyHWH33HNxc_WsKn4_1778489648
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: nbf7apw5tiwa48er38d6ykrfptxatypn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C502C2000A
X-Rspam-User: 
X-HE-Tag: 1778489651-339355
X-HE-Meta: U2FsdGVkX18cJkylexW+bcZkHo7LHw1u9TBN/ElZr2NQwD/SGBL8UsaPWiYhxZTqb3c1K4+SLVSog/+bQxFwZYJtudHl2TolWyW5bSUV0i9ubE+KytjfR+2bVxVsex9tR8gi8XMttXEurAMZSbrK81nYKN2i4i+N8mfhxU1Pw8p9ds15tkM0Qn7JzhLHEvUJs/PNtOYM/I7J+KzlUhhGvil8cdzrIZndwNxI6pXypTIBbCeihp7eohPMTvvubZLt9LozXYW3Kk7RY3trmPozxk+3iTPW/EMWEplza8nCP2gtsS3esV22j1XCR4z6/Tx0hv2ZEWJdMCJLty1Slpf3yFhrY6Ealhk7KDViMN05vmgLzZdtYwXXWkWwB2MIZL4LrFhW7linolyk9SKmV1I1mkXIHYpThKq7tDevaPLGtT5cA5a2BdG67IUJfyIqMF8QVCxLUKXWbWyxH+/hJOscZqvRPCwYu51CesP+2QNBcuF33h8zuvFzRFAFv1Sp3qFuiiL5CKI963g/d8eBr4enqZd3hnIb+w1jdVGVgIX4z/CV+Pq77yjPI08dYnT6GZsmNqTkQpXfnJU7546xL/mVZ1P6U7bMKirVjG2j6RSAiozbVfgb2iJHqGdxxmFLDenk9zvX69jrBjnM672/jLdlyiCR0ITqLxM8MvHZU2vv9ABwQBkmnbCQj8U6Ligffhl5XfUUeGYpky9ZGajvV/IWaL4Yi5kRWMDp7Gt9uox0LHlXJS3y5llqqPtIjlMwfAdYBEEjzTkcNVRwdNwE98WPwebIa4hwjfvHeo3SSHTj3+vyYBx4tgE+gFr4P/x0wWqVQSWcm9pqkk0i4zqp/X/Z7nFGjOr4nZ9Yap9w/eCA35BFL5vpXWIjNO5Hp+SVmcl8Kt2h2XgtzM/RnPkEExaBxGrPuRBhHA+6Y2OaAa3kYAUXldBJ2D+wylUTv8HbpTmxMw3HLIS349KYhp6XtCR
 vIkEZ2i2
 cSSl/HW/4/0i55e6qFQq9zMzbdrsii2Nv2zr49ZkFrukz5BXCP57zKIgUDp3YyyKPArKjxl8Ljd3OyGzC7+WVu7h0ayysmVxN1dYaoctR+6HviWwZDFrlMM3oLh4Rj79HoWjdKu+ZNCMiBMSMSANUEmzBw8M2IRllDz5MxC6ewWExE07SRhGReQav8C+pC+Kak3YwylkjBXfXKVBrM5+eUmPZOdoz5LYm0haJsvp38ABc4SdvpieCsW/3VQDx78dVSDpSBA04dW+nz/tP0VT3mEm2o1ipvYv8rGXWL2x/tPwaDxyp6Jqzaqd/GSisgEnS8qg433Ncy7YK2Auf2FpvwCzNJbTJiE3P7p33T5uPeKWvysQIC0pyNE8nj0NrlrMXnqRu3xJZaXoZFN2qokIqWdBVNEERXntkCtEmLXGYyuc5rEKVpsnsMdFDVIpNqzs7U5ef
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


