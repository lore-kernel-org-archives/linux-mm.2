Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C0FFF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 14:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3515C6B0005; Sun, 26 Apr 2026 10:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328DF6B008A; Sun, 26 Apr 2026 10:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266936B008C; Sun, 26 Apr 2026 10:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 184D96B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:45:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0A08140644
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:45:17 +0000 (UTC)
X-FDA: 84700979874.09.5C12C81
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4571CC0006
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:45:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NwuvaAMh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777214716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OiFyBmC7gClh7pyL8uPE736qSNuG55EW852NdgZNRz4=;
	b=CAEIvLR1+CAzAwre5JS1tF8hAaYu14tfboVn1POkQ0gUmVxK78ofef5vmy4BftHcMi3iha
	U1Jb6PIHiR8RmUMpHKkv/m+eReyWeW+sx3a9XfknDhPLTz53HPnb23ImcOA32d/lwnDTl5
	yUzbTCTPZgvAiWOKmyRf9PYDRhuaDiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777214716; a=rsa-sha256;
	cv=none;
	b=YjH2tQzXy0iCUtUxPsFhMjHnfZ5KArQ6xQks35HrfT3NigoyPQpgeufNq5WhZAeXALgEid
	6010mN2SkaU3/4FnKDOqD5To0znBGbox2rnMTYcuDSVvEDLVDjJa324FqE5Uu1RNWfroM5
	TeFTe+9fIk8KAdFAMpYbz9LeVfbyACo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NwuvaAMh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82f6b592fc7so4196311b3a.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 07:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777214713; x=1777819513; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OiFyBmC7gClh7pyL8uPE736qSNuG55EW852NdgZNRz4=;
        b=NwuvaAMhG5G+B3HPGgAhg6AG30mpUI3nQSnCtHjI+hBAbJYihMNn11OL8rNt11LB5H
         ORr/LLC+I3JS1aiQM0xPBzzgFzby4EW02iQWC0GlCDplQI0kCYxbRP+QoEkL7qW4HXXy
         skJh2RG682cjS0PJtRZGCoI5lk2tdyLiS0uuabcm+cCDWbNOzU5YhvdzqiC30rx7mHJw
         lq4eg1wY114zN0l2+7Db8rbkgBAkw6/x9MZAzR1QcamdHGwe27KHhEeRJEK02uDvpbvH
         8p8fGYRhOsZrklWeLJYGgixBdO1ppH2sOIjmLuPvVjxaHZoLCngPnGrlcL/qC3GXcdxj
         Ol9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777214713; x=1777819513;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OiFyBmC7gClh7pyL8uPE736qSNuG55EW852NdgZNRz4=;
        b=mWwyp217tI0RrPaHkPWIXoPGa5e1y1hJZ0wa0LUyDQw326z3Xzqrmn0jFm+722yrhk
         B6T1BLV3gk8LPZ1FNAJhK4Ixw6lsD7r4Pd6tal+Sx4qqL9nY9zEQCrYjQWLoZjMn5mcK
         AphIx52T9tl/cP1ySdZ9Q5YkVBaUNa6rG32ruOxzoUHsaNdn4TnwLVJqWPRJvSgupnOB
         C8s0lG+Zy2/gId0XB70JSaYrtkXO7oGLwe33KbNue0bDoFGeZ8bDHx3EmQxsY/dpE5Fe
         cgUqbgRve7w6MiZzGOZEIAhxv6bI6Rac7YbKi1bV6ekAQtd46/GBAkl36EGNNq7ytoKP
         z8rQ==
X-Forwarded-Encrypted: i=1; AFNElJ/PKLa+7aQ63IG2e3df3GpxP20wmlJNsHV7sYhZtJoDvdxAkOOjKq/KOoN4jC3Szd5xMFEyvKxBVg==@kvack.org
X-Gm-Message-State: AOJu0YwA3q/WzY1T5CaSyQm5vqzU3sGuRbucQxkwH/q4ipobp2npUTXS
	B0B12H90QkiH8xBvtCqrJsVIrJ7KmaMR/ahdE7TxOShXXhQ2qINAwZrKQFcaESksMrc=
X-Gm-Gg: AeBDievARDYxZfLjvk/7djorSM5mIzbhhXfgKO1bqCRTkPnx0rPYwDTb4qDXIW8tgix
	dhsZlX5oP2TGzfd7HDgqj+KUrBiWlP/dg+bqXySY1vfJnhKlGcCzybw8ELr8fIAbPXBC9padV++
	dRjZPHJMojZV3teF3agZ1bl3zKs7T0DcTZwwVr9YbaB8q83WAQX/ebc1GVQM5DITK6Lmc2NLYlO
	YE0EPAx49NPNXDWDkr5ElYvlFtJAw5uHEdWZQh9HLv2Qyc9r9gIoJzQpvtiSgMbc1JueF2EF7oP
	9zN+QCXVITk2dUO+oxY8pn6DFscVc1P8+diwKRNSt2Fqm6LQwe/sMlEe/HE2LbqI52I0UWad/GP
	uoCzW0QhVYZ3lj7GF0WXKvn510K5yE/BkhRJRgaILDOhPIcRfb8dHI2PWeDfMyiN4DY6mCjP0rD
	BrDKi21xit5UL5ZbqicUMlJKkIW66E
X-Received: by 2002:a05:6a20:1b17:b0:39c:241:65a3 with SMTP id adf61e73a8af0-3a08d68777fmr31746742637.1.1777214712721;
        Sun, 26 Apr 2026 07:45:12 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::349])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797703059fsm22340550a12.24.2026.04.26.07.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 07:45:12 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: muchun.song@linux.dev,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm/memory_hotplug: fix memory block reference leak on remove
Date: Sun, 26 Apr 2026 22:44:46 +0800
Message-Id: <20260426144447.817722-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4571CC0006
X-Stat-Signature: awxdny619ycjjh646y4oeebzk5tgrggs
X-Rspam-User: 
X-HE-Tag: 1777214714-978878
X-HE-Meta: U2FsdGVkX1+o8GorIN00hJ99xiNP0kVgqnF+kb+DGsnG1p0h2iuQBzwN3HVoBw1BMFvoWQKaewI1QwkakmN753iiOnYdUJEnyiQ80IGZCYAYukC0Wlk1UlZmkxUuMvnPCHvYqBAawXtcmTfbM7s0yLSR5RjvyRVUE6YEfVjt+FeHwH8SP617tByzNN1JInoIofRs22LZdIUe+r7ZF0rAJ2QIl7GqP/UPy9h/n4EKnReA3nobW23KJUbfHmqSu7zJJiW/E+7TZp+fxv0bqf2ZEzVF0r1Itw0UwgGqCgjqAWPaTBbHKOPq2o3DCsP+Ssesbm/dYzIBpJPosA2iUr/YrReGsB4WM+Aw0+TPuoNCFhBoVLy7xS0birZLG7kaxwTP3/F53AGo9KD7sqqWjVMpHiUI5RPkjSaHK60jYp/GCs1diqtaFGsEZn/SFGxvZAExAsRkMMJql1cDMaKlPx6fTHPtLA72yJvhgpCJXK2hptVV6Z0J7jBGpmFVJylYxS7D9VJnJO5Naxx5io6NcN8cuvhOLXvOKNbzSvzo40EQFLS1xcEXn8VwwX4fhdTMwxzjc0uqlpu9npW6DNriBRT9H9QY7zfLJTpVvWU80sFEnVYDKaqdybiKRvUEAVuT1kLThsBRFqwXvGbWJQO5JwyYsWx0Q5cOAc01+rGW3eYvuLN0w7usf0pVvyXFBXjfw8YUn6XylfgGl2zZFoeFGPu7xKdB8L2RYEXG+4itgN3VlD7C+NFpfpqy2MidzX/0Ukv/MIdpyo0texQ8+XYCpzCqI8cyw2Wqj6LwGeflq6WiJG0T5MNO3HN1BJpNiz6lizY/fjxm+aDCcQZOie4Z7GiqjYd6ODpxifawEB2UeqcWlWEwi9S6VXIWuHi6/xymk8WDL2KDXtmnXpUvDnJVMzHeAk03QS9NfrlyNCZmOeCTJPpJMD6Sg9wsNi5j4phP4OLVmyUDJrq58mlKoWsaM66
 9ifkN4ZI
 bQ3f5DhJDz+pKhWwW/iuZfennj79OPglyklb0Kr2HMeb2FfW2sxNQP818eGaNYKf2wJ4fvIN5x31seyvlUTFh/BY+dz5rR01XmAbfsKx9eBsbKh1Mi1tSUwXRxCF1ulXPmB3ii/7S64Li8XDvdOX6NRW3UQIWo9na4XHPf+kF1maktwYd10IGZe95IOl9I8leN41IpDUDg2OM4/x6JtglYYYjI/XkWAbD3bte8Hqj1PFr9ibDNsPWPpF18opd17H4qAWfgBa7XLZTrLWC1/bttk2Sfi/0fwgOMJyq3pV7X22NaYXpltAUHflNnqiMZnyzu+mDBnGfLyH+yH3Zs1vcOBFlw9lwzKvRiQhBWc6XHciM35ynRKvrt5Ut9cf108YAlFVJgjIx1D7+RqubkKD06nGduwU0peXXtozluukquQcQSshcAtu6YX/1IGDPVrDJuV78fvub3BDMscFWgqQnka4ryvaQ/pZs14SXDpHIcuzldnJzq28LAKFKYtu/TLQjGSnSYfEaE60zCvxXNTL+cJImd2PUKGGKvtDCLy9N0K7shP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

remove_memory_blocks_and_altmaps() looks up each memory block with
find_memory_block(), which acquires a reference to the memory block
device.

That reference is never dropped on this path, resulting in a leaked
device reference when removing memory blocks and their altmaps. Drop
the reference after retrieving mem->altmap and clearing mem->altmap,
before removing the memory block device.

Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memory_hotplug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a943ec57c85..4426abb05655 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1422,6 +1422,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 
 		altmap = mem->altmap;
 		mem->altmap = NULL;
+		put_device(&mem->dev);
 
 		remove_memory_block_devices(cur_start, memblock_size);
 

base-commit: 7080e32d3f09d8688c4a87d81bdcc71f7f606b16
-- 
2.20.1


