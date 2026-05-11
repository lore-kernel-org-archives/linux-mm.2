Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45CA6CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0F06B00A8; Mon, 11 May 2026 04:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A636B00AA; Mon, 11 May 2026 04:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990AB6B00AB; Mon, 11 May 2026 04:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA546B00A8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57EA9A0643
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:58 +0000 (UTC)
X-FDA: 84754526556.12.45281C3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2239B4000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KCJ4bNZu;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
	b=Bt/V7N9WsK5bq2F7YwO9qpQucU1M7a6/LFOvHfzgEULBmsJLOFDB0uPJQcAlC7IXJMpwB1
	zErHxNGk4Ync1YqllH03xSEf6ku1Bkat8BmkT0Vs2oeZzlPK0JEyoh5uaRVGl1edKqq6gG
	+uESTOjJmc+mJRdlrz25SOjkjlt+L3A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KCJ4bNZu;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489636; a=rsa-sha256;
	cv=none;
	b=X9g+R1uGokMRRlgPYeTwFf+phB/xIUURGWlYwDQb4dUz8rUCim3wF0crhg0rteQl8wn/bX
	+FJYmnCgOpNvRdzUXzpnEX6MfvuJ5OYZ+WjwXE12WWXu/3iBagDWKmRvCSmKQvKGj8Wd72
	Q+fRfs3PSpi1/NnMA66Qk3L6dsH+gs4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
	b=KCJ4bNZu6QHXlw1ht4MRSkOV36aMMeDc7UwbqVfeGldFscjCo54v1W5dpUbb9N4dLadBAf
	w1m5QAr6VpGG/xVX+rR2W0JKYz3jmOe3eN92RpYVLkzFU+05SbZsWKRCG3GQ3Y7J+kd+Vq
	IWUJSvCFED0Kph70VRIUMtP87yo2Y2s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-qpUM1MjrMO6JwCXvUKJqiw-1; Mon, 11 May 2026 04:53:53 -0400
X-MC-Unique: qpUM1MjrMO6JwCXvUKJqiw-1
X-Mimecast-MFC-AGG-ID: qpUM1MjrMO6JwCXvUKJqiw_1778489632
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48a589c7879so38683795e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489632; x=1779094432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
        b=Vn/Sa1fFmJS3atsmx41pLCVSaAqpc9wsuBRPbqTUAr20HUJtmeVkZfJQfaqUxQDd2n
         Mt4orr98xRq1RjFEp7uIzQLwcoN6CnCOO1q4cyVZndGYR7yzmC938RPpBQkougkUYbZl
         vC+rRuCsNII1RN05aTqmMn3NdgwJ0Np21d+wBKOMj0V3ZoCRbo2MeaEtQCA3wjUdu9wz
         s8kmWt+ClX1TsZEUMZrbxHl/C81WixVfe7QaCVcL2WnQfvbEPYxPJfPY7WuqMeqCwjp4
         mnudpNxTVt1xgUqWbVbDOI3i/d1CIsEjlWcA1FaLOOFMzfdL1n6ELj+DxNVNw4uhWEIt
         BScA==
X-Forwarded-Encrypted: i=1; AFNElJ+jhoRSFBfQZIB+nv+XBox4VEeRPO0xaimaVkmRPRTNyCqUb8apKEsQOwj5MKVx8lZqHhmXZVEQaA==@kvack.org
X-Gm-Message-State: AOJu0YwePFNEd5wg+ZYjVbpNYCDOJmpveoT0We02erQm3sTAZjF2ka/9
	pABbnFCCJBkyzBWuNzaNo7F8D2mbEw0GRizp5Q2gzJK3r4zezUOKqtUBVKtOJePgVFTKqJV9Br0
	TFFiODzJ2Yl9X/BAsYwBPtZmGXyKmPyd2UyfLyK9Ik7yYNEpi+A+X
X-Gm-Gg: Acq92OG7p/mz+sHkLBibOiXK/UfpaK2bnkdJJ3w90Qi2hsSvHnpaApmg7BV163MS2NA
	HHAjGrRoJF2J+1cYn60NcRUSRB7Oe/BXomed6OvsK98sIfxzVkkMI2N+Nqc00tHVXkh+3eJ7QnS
	DD9owmf/T5qpfmWAJ4e0Z89WhQTQ7uLLLX3sR+gkMBukV3Uso9RwJ+7uJZiZpEuzllgtdg2upd/
	+dzf8/lh3AiVQGxkqOQNN8RsWwStt+PCxL7Xl0H08u9n0F7K6QKGyitKvwNpFr7ya3Ndk36jTmd
	SX4iNLomtGWDtr/dPlOKsG9xU4Qwy3Gy0ehMFTfYX/K2pUkZxu438xwS70gDqEAJV6MyyR404So
	m59LPKK9X7VomUSxcROy3MzNYDMFPmjEwpnf5Hcjm
X-Received: by 2002:a05:600c:3e10:b0:485:3cef:d6ea with SMTP id 5b1f17b1804b1-48e5e0089e0mr278415825e9.13.1778489632218;
        Mon, 11 May 2026 01:53:52 -0700 (PDT)
X-Received: by 2002:a05:600c:3e10:b0:485:3cef:d6ea with SMTP id 5b1f17b1804b1-48e5e0089e0mr278415135e9.13.1778489631562;
        Mon, 11 May 2026 01:53:51 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e0bf2sm299190565e9.4.2026.05.11.01.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:53:51 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:46 -0400
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
Subject: [PATCH v6 10/30] mm: alloc_swap_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <369a08b86f51572b2715a9ec577de27ea98000d3.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OjQRZlwPkqP343CFKohVKNaHFxmgadBsv_n3twvHnXE_1778489632
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 2239B4000B
X-Rspamd-Server: rspam06
X-Stat-Signature: mwy5uymcb3ha6k3gojzk8d3fotcgu6nh
X-HE-Tag: 1778489635-22468
X-HE-Meta: U2FsdGVkX1/c2Zm4Iy8BWGpr9CRCMX6oZmfeEgipExAamQJHJvGc1xXzlvFaMeCknN39/vGTuxuKDKz9stjUDOWKamaMmiJLs3p/JqyPUcTGyzfy/J5G6FxzD6aVFscRGVtGRmgiAsn1RBPXyI+VX2fiHsKrXUOATvMgudb4Z5PbmYQ65EZBV+8UnHngRueZzzLLx8bk9vdzpjgSPizpLE8jyyiIUk4DH8REarKc2HdYlWdyXyrPT53INIEFVpPm1XqrKmi9eUzfrilF0jz6hFA4UmBJ5Wa6Ruo6GLQrfpaMCxEj0144gzQzBGipSJ4GzrNoG4htO4b+UxYuUvrt5PNebeb1V5YNdY7sqdrYsFFIwuW6ipbrW6qrnPufRj69YL7zQfLvoXwxqfMyT6U91AkL8ja17+gVQ5rXvvjOBjBUHVZb5ty/UmWvSkM/C7rMr4s1LBTpqt6XFvU7YNU0K9l63LXLEkBGMb1gYzMiP6urtOQMbenO6uNlqanYO8E8CCH0LmC8iV+ihkf3KwZsY9aSGZztMzT+cHe6+m+MUpU+dJ0DCpc4tpxe9lzGvcgRtbpLFrw4bve54cFXXeLMW+A5jBO8e1bnrDuFyi1UKuHy568DuyfTyaj4OxpeQ6dVsiwqcTF3Tspbz2o/04wsJ3xr3SaiwhyQR+wJaepc3uZVNIqiv2PvSOuhBismOIqUWDGBOB0soweHt9oI9caSwlFmYhxw7nl/eo+0Jsgpu0RaqBt71utfhYflzCvGzxiE86Wz4mJezztvLJBJxj0qxS2Rc4Volzm1DUV6j33A5Yh8JbcVdaAzIZm6p3XwyuX5ZMnPrdcHqLdkb4tpW6ouQNexcwHrePsIy5fMEVzYLqV0knfdPnhShYO3r+yBZCP8+rBmh+k7aZnLJxBUEs7p/FFFaKCa+oDZgZl546SpNT3YLSZ1O8KI+iQoyc9FMLtrcGhng9LMT91KE6ss7Lx
 KhIovjMT
 sWrOdD5t2rM76/MBWWRwn1hRSw7mlnZRLlRDhPM0cVAtwVvFr3e+kf+6KByTqRh6wTjIAA4EzPWBxM8i+aOXgZjaSHXp3kkRuy0xaDPVU1pRJqj30drO9j3PCcEzly9Mk02Ow0EkkijYZE4qC7MYPBq1r/SE14FrycbfsLNcsbZzz+Or1io+tirga1GPEFupqbg4lFdG3AUWXjC+CcM6WhCECXoszrqEKd5DuQQtKRvbB+6ql9exsF4Fp4c3aAhnFNd6451ci3gE+nUqNqm5/TG0XLRIvLNtcdEX5qTg352061Wd8/yvOneaM0Un5h2twHa6EYCvazUsHzoeb19URMRBTqbFJu0Cb8BZPnd+dJWlNnlx1tias2668xBvqWqQTEI4fgqFZc4wpRqqW0+xjdtyOubnnGIYzBNVAQse70rU+v0eJKDn/2qt5h1uZqdrC/Cdz7x7ldgT+tZD9lRcN3c7HSHaGU2LBXZrJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Same change as the previous patch but for alloc_swap_folio:
pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0824441a6ba1..74523bc00d8a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4734,8 +4734,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
 							    gfp, entry))
-- 
MST


