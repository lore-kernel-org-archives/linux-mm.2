Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16B0C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A020D6B0088; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2A76B009F; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7726B0088; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68D0F6B0088
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6F2D16036C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:52 +0000 (UTC)
X-FDA: 85027762344.01.400CED0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id A88A7100011
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=THSuntwS;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHllHAYD+554jhDmr6CAyg40twiId7LXCrXkJDYooJQ=;
	b=Ki/sc/aCpbljxQvdfmeiAQzvqJN6LS/3mXLg5Md2MfgFgUb+5BKr4rcuaItoIxJyqMxrMP
	irBNMVDW0u0JqnlqmIr+N5skHtFptKhEe1bcVh3KaiuG/q14QGgzX/l1bkT1tPh6OS/7Hy
	Up2k4qwQy0HDxDd64cOH8zWB5Y4muXQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=THSuntwS;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995251;
	b=2IHb28v4c2hBh7+fEfaMwwfj/IJdXJu3Y3Xmbnmv6HOFY51lMuxucw+DbeNdXe/1WqCDMk
	6nJh9CNQLTlMCMSox+4Oi9kup43f7So6HyYxiEY3QP05NG657AwaipoVeVR6PlNoEuFlh0
	dJpnI8VboS/5F/7VZUTPF9mTt/Q85b8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=VHllHAYD+554jhDmr6CAyg40twiId7LXCrXkJDYooJQ=; b=THSuntwSFONitnt27C7IJdW548
	O6xJkUXRoFqUPhLIkkeKDDST1c3ZYshJLHQQXhtUlNGg2nCLFVm0fdWMJ9c8CL0qQiTsEThheFnKM
	Q0W4bl2sEOOu/Kd0yiryGLUQAhMcyqMAgLxZjJ4ZyU8RBJ5vUYAkjH78yL0xIZJuIV7nX2htOcDzk
	S9hEwGI9WRHHGr4D7bYNchChPF3CyG3149Wl4gPa+N6z89Ae1tsr1IMM8/GVzznSHrHfs/EnRYpg+
	mo5miHVkGdeUQ8eBiiNUg7QRxaewROajlLxWY51dPhVzLuFCiw+e1EPezfy2Xo/qzpKxpM/I3jza4
	Fh2hTqqw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnens-00000006X7k-2Q6D;
	Sat, 25 Jul 2026 16:00:44 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v5 11/12] filemap: Add support for authoritative mappings
Date: Sat, 25 Jul 2026 17:00:39 +0100
Message-ID: <20260725160042.1557264-12-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A88A7100011
X-Stat-Signature: 38apqqyeq9z4roppz8yfsuh9o4qniozs
X-HE-Tag: 1784995250-637003
X-HE-Meta: U2FsdGVkX19NkBToox1IWSW7l3WyHKMwe9gUTYn3qGAndVwtuN+z7jkTFxGwWt7eZXZKQF1A3KvV5AfnGmluWtmZfPl0e6caxbqF/+Fvthw2lnXLmfPF3VlwKgiJBsmfzDeYsDc08yBkuqvaahHNldTw9R9wJ/76iA1iex/n+a28X7BHJuvB49w/v9eekMhbNUNtNBmyPtsUVu12LxdyiBLXt133Ygr2FTkQNdc2xlQ5VKY3ri072ntmvRDGW8NDgyz676YnBn+xi8L1/EtD/dnzV+dy0tlM1eUBgTVQ6GasQYSBrdSpDM2VYTOMrQEHdx2xU10MEvmLucXxYxtju6S3LPUJlsyXethIy760cyR51NTWrvAynlmyP4wcuJs5YzP8c0M719ptfjVpU0ss6yrCTJp6xfrhNYOugpUnaLJht1fku64AeML5k+bTC6RWgwrHF/sLJfJU7NkKsyiWDsdb608EoPGFkgcy2o8cAxzMY86yn8f1doyZ3kHOr5gOQr1MyPhhEZan0RUYaeFpXoqv4VWKGFZB4uD3lAnPoSugebjWQW/WSccvktGDmBCWZAUusoZ6oa2Kabylz30n0KVFbk7DSvA4UwE8EwLPWOw4sZ04dn8d48ANJMxKXc73OeO6idtHsnkvOAZwRj6QjpxTb9zOpsaHxTNwuGPxDkKOD4dJQzRSD/1baJWMIaJTuq+AHkjaY1lkZy15hTyxzVzHXfsnAcb07iGTlafgRkK71JoNXLHk+RKxk2A5r3cZHUw/3otZniGUxUwW2QbEWraaB4bhk1Xjb6cybFcFYH/uQdbhWBzYBYZuj2hmrE+MehDveTY41/Ik9hbMWln9bfRTfZQ7mpQf0uLW3gC7zdyvBSfaOZStg4hif43j/NJ0Z43jh5rBlFGIS0DG6ZbukteZ50WiCZaYnCJH55Qx7GmczbvR7sAkhTXG/7vwnsoBcAUrpl21x7k5i5ZnYna
 hrZDTGxi
 5K85ZmtvGzSNr01XL1TsAgcR/FWQu7j8FmCaG7IxwYAseLeTL6YoYeSx9DHONxFE7F8aLS+jQRJl4V0yRdCeiOyXgcTvnByyBMAzWkIlDhNtxU0CYociWAVLPWV+5fhlvGv9oN+0IzUQt/p4ejewOq2AjHQYaasS6uxI6U5l4FyWY82B1RhNKCf/Us4byyXA/NkBS/OUva06pLmRaDu5UdkUEmxpTXA6aBDMa/6tOCfI7YCeIAMX7FjU0cJRvEC/30fi9nDrcGaOYKrxldsgACfjs1bYaJjxJI0L3CFtf4Oxs4IsD3u5LCpxJJTXzgoy88c48rpBgC3NHMA10jJnLigVzVHzp9rcNTcdQYw7VYWyMpbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An authoritative mapping knows about all the folios in the mapping.
If read() finds a missing folio, there's no reason to allocate one and
try to read it because we know it's a zero region of the file.  We can
just call iov_iter_zero() instead.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 11 +++++++++++
 mm/filemap.c            | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 968b791cfd14..22d48935ffda 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_AUTHORITATIVE = 11,	/* If we miss in the page cache, it's a hole */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline void mapping_set_authoritative(struct address_space *mapping)
+{
+	set_bit(AS_AUTHORITATIVE, &mapping->flags);
+}
+
+static inline bool mapping_is_authoritative(const struct address_space *mapping)
+{
+	return test_bit(AS_AUTHORITATIVE, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
diff --git a/mm/filemap.c b/mm/filemap.c
index 26a5f18121f9..5a8cc20e624e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2697,6 +2697,8 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
 	if (!folio_batch_count(fbatch)) {
 		DEFINE_READAHEAD(ractl, filp, &filp->f_ra, mapping, index);
 
+		if (mapping_is_authoritative(mapping))
+			return 0;
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		if (iocb->ki_flags & IOCB_NOWAIT)
@@ -2853,6 +2855,22 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			goto put_folios;
 		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
 
+		if (!folio_batch_count(&fbatch)) {
+			size_t fsize = mapping_min_folio_nrbytes(mapping);
+			size_t offset = iocb->ki_pos & (fsize - 1);
+			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
+					     fsize - offset);
+			size_t copied = iov_iter_zero(bytes, iter);
+
+			already_read += copied;
+			iocb->ki_pos += copied;
+			last_pos = iocb->ki_pos;
+
+			if (copied < bytes)
+				error = -EFAULT;
+			continue;
+		}
+
 		/*
 		 * Once we start copying data, we don't want to be touching any
 		 * cachelines that might be contended:
-- 
2.47.3


