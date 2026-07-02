Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC50C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513F76B00D8; Thu,  2 Jul 2026 20:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC786B00DB; Thu,  2 Jul 2026 20:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428FC6B00DC; Thu,  2 Jul 2026 20:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17EA16B00D8
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:32:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BEAF401D2
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:25:19 +0000 (UTC)
X-FDA: 84944512758.20.72A648E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id EE62C20005
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:25:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=clziuTaL;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783013117;
	b=igWYAauM+cXsSL75Cr7zzs0ic7BlHZZZkuQqNlheolSV3/hjMh8bWsOz0d1MWFl4ASSeH4
	2LCdKvoGCqgUCYnYVf1HnsLT68oAdFJATPQLyoiEd/3lFhKTPEpoXZtxs3PVgvx5Hz0O2A
	j0vkEn3gj2RtCg0FA7iCVJUiWXRtKK0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783013117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rpsz4g3zxC6WA/xxJCnqVHrdcGnie/XC58606CgCcjE=;
	b=acHu+jVEyoVwCMPiqiTnMdU5u2UqKjL1/tuYl1RXuEEsRN3aWDjxptiCQALIZuaLqrsRs1
	YcCeansOSj/sXvvFt5Fx75tA8nW7Ho+M+Do6OB2M0zB5rHP01/pSmKl5x8J6UD+2QROFsw
	Rpk25gCUuJTtKDqYKeMMf1voOWR52sY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=clziuTaL;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783013116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rpsz4g3zxC6WA/xxJCnqVHrdcGnie/XC58606CgCcjE=;
	b=clziuTaLhkqI6Dt4iYcVZBRwuqM4V7W8l2yKl/025AuH5vEkY26iI/vGpDhYS4HAF0WWAz
	QftZkLCpaHIKVekZPLBJm39QcVzil/Jmg4ngOvg2M0XSSoef5qkNk3vJJUkDY5a3TWRoqC
	Rfpofo9/N3ntuAgQRr8EVMg5fwN4VX0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-PFauOJgUMLqtjKwlVRLQbg-1; Thu,
 02 Jul 2026 13:25:12 -0400
X-MC-Unique: PFauOJgUMLqtjKwlVRLQbg-1
X-Mimecast-MFC-AGG-ID: PFauOJgUMLqtjKwlVRLQbg_1783013110
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F19621879595;
	Thu,  2 Jul 2026 17:25:09 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.7])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E25943002D2C;
	Thu,  2 Jul 2026 17:25:00 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ljs@kernel.org,
	willy@infradead.org,
	Nico Pache <npache@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 1/2] mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
Date: Thu,  2 Jul 2026 11:25:46 -0600
Message-ID: <20260702172548.37075-2-npache@redhat.com>
In-Reply-To: <20260702172548.37075-1-npache@redhat.com>
References: <20260702172548.37075-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: n1ukMBIGPckPj2zVeC8Wx6TCH7yXnWAS0_rrEtbzsT8_1783013110
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: EE62C20005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: adixigijyua7mkin7kr61njodsat16th
X-HE-Tag: 1783013116-270492
X-HE-Meta: U2FsdGVkX1/aUwMHj6G/4yLwlBCyxpRzVtI5+GCnXw29SVXc9W2XCbF0eRl6+0ZOBxwrg741GJtjKBSqNEOER+jlRlwGmBhgTCKA+ZGQMqqoRppe4Zlr5crC3NpgHnPdjqWLDyr67D+48pXkjGBLz2mF7y4cVTdr5qZYDvbes8Ej8tmeIFv7nCdJW2v2llI8RRGdvpqVufelOqV6nJNjgmh1Lc82tqrQSerS9ePTd4tIj+CCX93ufVl5i849ke8O85kDhRCcXs69SzGUqhGHgv66nIdDX0Ib5aqieVOc4+YveyXl0M1ZMJayF7JeGzDWWczTgXqJsTEXbeUS3iuZxZfpQViuxqxUfbzy6EuEXOEBNsKfagKkEGYoZHsw7QL8ONU1wRZ9DOSM6TdMqVwuf4xYwFdeBWtwV+nemEKWiYai3en/gcColqG4Jcym04Le4LtuqwUDbDz4SskAcw+3GY+rrkjzTujdT2YiF2bNHN0D4g/1Khw8bWnJwC32fVWEcJ2A41F/K5OQdTrJNFAhZl/gCdFvLAmz/oal9hnEiFYjN4Q5OzUU9FJWvp4TnAgJUcIv1sNgjcoGhlq7xrru6Yi2q3PKOhUZLC/pX/uH+TGF6X1+5Xz6eiuSqdvbF9IWtVw3p/R9bwBAhCoDntLi1M+vd53YfWCCLJyELHaBffjeafx7d0VX4sRcod4nz2LWICgnWus9kHyi1br/tZ6dgqdKK5kUelBJCNxu1zGo9roQb679QbN3DhmHBZsJUkAHbWcz96LJ6N+DsXpQ+jjNleDAIGOJr9KltpEIwslYtDHsetwIuWWQKfe2YLjh4rNyE90aFTGY+3MvhI/4uaRXraiLaP7+wch+beLGIwmQTErbRW9DZpeMHbT9eiz0VNsXwuuNBA0AcYQKFVpFZClXaM6Ydkbyq8CJqZHEDVAIBWYZYCz0NmdxPliJa0kPi5OAjHjugAx7jPM8D9x3+vW
 HPSISZJb
 upAPzMI58ZRXlb4yCFNOMXkwov3kqaKfWLJSTGUX6qJnMIUjG5GBKkLqSjh2YMXLxfJ/N0tbjn8GXgq1U8SxBPfbaLTDJEEM0wGiHvTD5XzIkVdLFOy6T8EP6cwp/2FLGvVvnNv0h0yiI+kUITJ8sceTWVmxhJX6V7FzW/278vnxHumsYMKQKN5Gdwz1C6GiHEV+f+jh7a2dRIPFoke1+Sexs5hQc9BnGxrBK79z7EbSLX9jviLm4rfPfybCCTqaSFm9DglHVFkE9YMN/0Gco4fyARoGuWOkU0NmbnoJLZ2Lg/YPbind0gFI1d5HyNQyTO4aF70inl/Ib9oAv0py2RPwHG0BE2379Ya/+rjXwKWXQ1OBnbcjjXxIZ+6euNdvWXqJLG/mTm4/xWnRUnR4G8Kp2yIu0FvJFmSlWnaaFoVP5gQimyKfRPZB7114IKTkoUMPuAcAyiqvu4CMvE+oBvDAZZuchINb8jZs0BumQSp5kFVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a zone device folio is mapped as anonymous, folio_add_new_anon_rmap()
increments MTHP_STAT_NR_ANON. The corresponding decrement lives in
__free_pages_prepare() in page_alloc.c, but zone device folios are freed
via free_zone_device_folio() which never calls __free_pages_prepare().
This causes nr_anon to remain permanently elevated after zone device
folios are freed.

Add the missing mod_mthp_stat() decrement to free_zone_device_folio()
so that the counter is properly balanced.

Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
Co-developed-by: David Hildenbrand <david@kernel.org>
Signed-off-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/memremap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memremap.c b/mm/memremap.c
index 81766d822400..accba23aef28 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -425,6 +425,7 @@ void free_zone_device_folio(struct folio *folio)
 	mem_cgroup_uncharge(folio);
 
 	if (folio_test_anon(folio)) {
+		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, -1);
 		for (i = 0; i < nr; i++)
 			__ClearPageAnonExclusive(folio_page(folio, i));
 	}
-- 
2.54.0


