Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4479AC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFCC6B00A1; Wed, 14 Oct 2026 13:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170776B00A2; Wed, 14 Oct 2026 13:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010F76B00A3; Wed, 14 Oct 2026 13:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4C846B00A1
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:58:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B5401A073D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:19 +0000 (UTC)
X-FDA: 85321991118.09.7280CC6
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5879DC0009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Wj1x7WUt;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCaGfSim3PIx3Nsok29/mbPBbK9Nc93PZX36t0w056I=;
	b=nJhQLkVOOQh4hUtaeHaI8FF/cdTYIIF+1jMBjzQt5A89nMy93uhI1v9o4cWUafiJh//wXo
	n/PVJ6bdPn5/esPuLLuLCYA6PiUpUEv0Nkm2yPupRliGmX+cCuoS4Nyxr4ptTEYrz3lho5
	kS79Bt7QOeUkrqEa+zoKiVh40UitzFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792000697;
	b=mUtEiAGpxLymVvMqQ6w8QyulTpT8EQ4XZMW1QKSQVHxzurGEF7eO2FZW9jJHVp4XDTTSOB
	vAA3otNlA9kWwGHs+gUJhYcSevV5hS08ulF/D/51mnVB/lhqkRqtClcVzROlro3qTbymDi
	iNDI5vpzGL5nAdCACcv72kfJnX1lvi4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Wj1x7WUt;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5339381b46eso44866011cf.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792000696; x=1792605496; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gCaGfSim3PIx3Nsok29/mbPBbK9Nc93PZX36t0w056I=;
        b=Wj1x7WUtalgVXIq45Vixmrj9PzKyzCHLKDGzBLVugw4qgXzJS6C85CsVl+AoCnLZLO
         KKiDYXI518d3oKOjJ5S+ax+E2I9gF9in8vFxoGtVvDOLOuVY3GDEJ30eHZG6mNMrOZOr
         8x+WssEB0S5/Nh/XMqMYimXXHxFDbdvjZswvLYh/CT1ySgkryL3gcohLEcmXITrGmohZ
         gdMXFf+uxzQEI7dvzH4Ww4tn4/pOsHlTlR3YBCFUP9kpRosHyt7J1tYF6VEq8QaBxIe/
         B2dUqx1xCVFuSC6qIA/dCpnUC8E7NOdLkeJ9rAxllYBUVNGJxmZsoZwnDI9t0Zx8V8jS
         ZuvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792000696; x=1792605496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gCaGfSim3PIx3Nsok29/mbPBbK9Nc93PZX36t0w056I=;
        b=VHjktvL71fco1UR3Kj8rdsez/lfGuLrmOtM0GxC50DudgImB1T3C4p/Lxefh2AOqTE
         cHyJ2+6wNE16JY9+qX9FA5NwtS7x7Z7STkoP6vy+3fI7WU2HUt9cYMT9nprvZCclZ6bu
         i8/tr+qR3Pbno5JIbngKyJx0XA2uklRkbl1EHKdM5E84w9q1HbwoG3rLmh7d+p6MQnt2
         XGERq1vqo5vFFokbjR/gdAoNssmWkrYtS/PycT3muMKFGNiJSoKc35zJRxNXK9Wv8H5T
         cGktVDTBmnCypUa4yCI1JQ14hOX6YS9sZgAse///SOOp191qma5biWRlj9onjiUhVLZZ
         XSTw==
X-Forwarded-Encrypted: i=1; AKwUvBwRzott5cLKnJNH2iEYzgT9gUoybFw5nBxLX/sO/B01sG9KNR9YzUouU18+rT9SCNOKIs02zk2m1g==@kvack.org
X-Gm-Message-State: AFq9FYIM86KA8wUWUxRhWAQNcs2veBnB3uz0pC1dPgsbfAPUsgZkANyg
	jN1P2w7Gdt2HABb/LSfvxbCOShW9bKh6rX2OpIRANQkzTEgGP+WJRWqq+ES6H7IbjDY=
X-Gm-Gg: AYBFou1SND75TYzN4GzOpSh4y7C5+dh2tcCCct8FqIO0aWCg5QtLLN/XoPc8yQSxkrT
	DAmRbTFJWAkFdf9yvIrQwGcO5FiM9TWL0GnrfMVVaHLUTz5YlSiF9w5kpsU61z9wOiKVM7KlY3o
	3w+9B2chjhMao3OH2ocitzYyP1IHiahd2/bUsTfHEDMudn5yVEkx7H6I3eLTBYGd9iVzOYD/2RG
	V9KZECtziNM7urlT/r9D9L9RU6DsYUe5ZlPdC8fppLtjapbcu6//MLxWBAbYrKRKmSNmRmtQvqc
	8WjYLemtswcdNsr7+F2y7fQZH8MDSS5uQ+6qImoZNWulJXH7jyJ6uJ4Je3VsUWONVvDKafmLOzn
	Ifiom+NZmpeIAnpdgla1AkHFflB36xVCapqwkDNhVkwgscVxDHwRdT5GteA+6iE8UHwq3SVPqAN
	Ft//f7nCRe7gdlLx/8vbK5Zu1WZ+6vCDCPmAlkLFdrHE7ar14RA9Urs9X1HFziRuI1DeYEXxsav
	6FcMJuRbEKru9B8JLeBK/NMP8woE4aGYta28jx6oqv2hJMjfWmsx8CpMfm5
X-Received: by 2002:a05:622a:1f0b:b0:535:1291:f1c5 with SMTP id d75a77b69052e-535acef8d28mr253194901cf.54.1792000696292;
        Wed, 14 Oct 2026 10:58:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b95847sm58498006d6.32.2026.10.14.10.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:58:15 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH 8/8] selftests/mm: check that unauthorized MADV_PAGEOUT skips large file folios
Date: Wed, 14 Oct 2026 13:57:56 -0400
Message-ID: <20261014175756.2035176-9-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014175756.2035176-1-gourry@gourry.net>
References: <20261014175756.2035176-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5879DC0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bxxjf1fddwzrusnt8dp8j6xjo537oe3y
X-HE-Tag: 1792000697-566147
X-HE-Meta: U2FsdGVkX1+lpQ40INylaS00wIWHmXooY5yR6ejOgO8pqE+Sie45fGGHKtFe92/axtZyhzPFE5N+7q34DucuqAZP0HXnmCwVasi9E457IVm7RSl0HdXCpjyUkXIcrou1rHnZMPckkV7lDqJFT4pbmySaHkYVx9h7KBzIpEq/CdpOBYabr4lwQ8flSjpRGl9s/1rmnik0rxYGoGbMHNavsYBnKbEiPC1U3BmXLVu7vDyBwQvCG29vGfnWVMUDQM1AqL1JywLvXdxSIotKKPhogG9sWPhRL4PSHgonJTQuDjK9XB9f8rBFgaLAnsRvyH+W9ciTwcRAOyjA6xBmt4lk9pNy9Qnsu6NGdqU8ofIBMUyPGQb+FTjnI0OxxQfQBsOltYt6pksWgV9WWuN7W5K+ONR8cPmv27nrpOjfFn/uTrsQ74zMzgagUYsVegokZSg8qU4YFBiYEsOIi9UPqy3RtxntxT0Q1jf1QJMXxeTODztnauE4sZOFrZyqy2mgp8DOEqBbYs0uZcL26LRElt/zdcYa8HXvyBlyEln1eoKaFv1Peo/tyhQ5BvxtyMUqPNfijyW+0kuAWglUN+xOKDOWpALRZkKUu+zGMqtj5e/Ir5f2I2gPalUml4ucsOtCbAkSEjQUidX4wBh9A3aI0cjMacJbkeWnHHbnTUFmVwkYsd5CQ4fQBbZcioWv1HPHsJBBiBj0TMg0Z8P5WX5Ut+FNu45iWVhV5Xdsk4x8b/u3W52gZGamdXUNhFCwHsTDQzItReDZsZ0JuQzIOrhvD3C50jZh+PJMSfH3peFOcWteXNWmTH9Z3eYPfGOHWjfHj51MJfWNuXtQFY0gVV9/zEOOBsG2Y0gySdl8gal9EtGvK5PKjV5OBFzxtr0LDYGGrZ+saY6v8f9MNDVAJVLiQZvGtbu705J3l51au3GZmIruLnyGDCogjvwAl810DyXdqtotHLXUk9QGh8LG8BKp0eg
 nl95+CFN
 EvTAQo0pAWdS56FQcDUyr2hhp7YVGvCkCuxHrQ8NwO42NMfp8QXecju5rbPDyHxDvL1QBqNQQsLllgWeY4etY6ty/WNGy+vKjc/8hP0r5u8mOGrtnrhOlNQobTA47OUIgqSSc2355morCtcM00f264/+tRxuR1qEzbg3erXaonkD/ZT1qqW5iTuGpspYWjFp8dQMtXvKA87y/opvZvSGo97JVdObWk2SUaIPOGB5VlkIaj9bbhA8P3KG8sVVZ9csYfZUNyCKzhxvD/LEYi0Z14YEXEnj/WdL+Y6sFimS/uF0BxIdp3eac5mFabX52rjv3Tc+aIQszZ0v9DEpJ+xFeIIyATU15v7QZ2IEe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A caller that neither owns nor may write a file may page out the COW pages
of a private mapping of it, but not its file pages. When the advised range
only partly covers a large file folio, the folio must be filtered out
before it is split or reclaimed, on separate paths for PMD- and PTE-mapped
folios.

Check that partial MADV_PAGEOUT by such a caller leaves every page of a
PMD-sized shmem folio resident, both when a PMD maps it and when a mapping
of half of it maps it with PTEs.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/selftests/mm/madvise.c | 121 +++++++++++++++++++++++++--
 1 file changed, 115 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/madvise.c b/tools/testing/selftests/mm/madvise.c
index 74202fed2d04..d59c03ec8191 100644
--- a/tools/testing/selftests/mm/madvise.c
+++ b/tools/testing/selftests/mm/madvise.c
@@ -88,10 +88,11 @@ static char *map_aligned_pages(struct __test_metadata *_metadata, size_t size)
 }
 
 /*
- * Collapse a PMD-aligned range into PMD-mapped anonymous THPs. MADV_COLLAPSE
- * may fail transiently with EAGAIN.
+ * Collapse a PMD-aligned range into PMD-mapped THPs, and confirm the result
+ * with check_huge(). MADV_COLLAPSE may fail transiently with EAGAIN.
  */
-static bool collapse(char *mapping, size_t size)
+static bool collapse(char *mapping, size_t size,
+		     bool (*check_huge)(void *, size_t, int, uint64_t))
 {
 	int nr_hpages = size / pmd_size;
 	int retry;
@@ -100,8 +101,7 @@ static bool collapse(char *mapping, size_t size)
 		if (madvise(mapping, size, MADV_COLLAPSE)) {
 			if (errno != EAGAIN)
 				return false;
-		} else if (check_huge_anon(mapping, size, nr_hpages,
-					   pmd_size)) {
+		} else if (check_huge(mapping, size, nr_hpages, pmd_size)) {
 			return true;
 		}
 		usleep(10000);
@@ -118,7 +118,7 @@ static char *map_thp(struct __test_metadata *_metadata)
 	if (!pmd_size)
 		return NULL;
 	mapping = map_aligned_pages(_metadata, pmd_size);
-	if (collapse(mapping, pmd_size))
+	if (collapse(mapping, pmd_size, check_huge_anon))
 		return mapping;
 	ASSERT_EQ(munmap(mapping, pmd_size), 0);
 	return NULL;
@@ -147,6 +147,33 @@ static void pte_map_thp(struct __test_metadata *_metadata, char *mapping,
 	ASSERT_TRUE(flags & KPF_COMPOUND_HEAD);
 }
 
+static char *map_aligned_file(struct __test_metadata *_metadata, int fd,
+			      size_t size, int flags)
+{
+	char *mapping = reserve_aligned(_metadata, size);
+
+	ASSERT_EQ(mmap(mapping, size, PROT_READ | PROT_WRITE, flags | MAP_FIXED,
+		       fd, 0), mapping);
+
+	return mapping;
+}
+
+/* Create a PMD-sized shmem file filled with 1s. */
+static int create_shmem_file(struct __test_metadata *_metadata)
+{
+	char *shared;
+	int fd;
+
+	fd = memfd_create("madvise-pageout", 0);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(ftruncate(fd, pmd_size), 0);
+	shared = map_aligned_file(_metadata, fd, pmd_size, MAP_SHARED);
+	memset(shared, 1, pmd_size);
+	ASSERT_EQ(munmap(shared, pmd_size), 0);
+
+	return fd;
+}
+
 static void assert_filled(struct __test_metadata *_metadata,
 			  const char *mapping, size_t size)
 {
@@ -734,4 +761,86 @@ TEST_F(madvise, pageout_private_file_reclaims_only_cow)
 	ASSERT_EQ(munmap(mapping, 2 * page_size), 0);
 }
 
+/*
+ * An unauthorized caller must not page out a large file folio of a private
+ * mapping, even when the advised range only partly covers it. See
+ * pageout_stays_within_range about other unmapping.
+ */
+TEST_F(madvise, pageout_private_file_skips_large_file_folio)
+{
+	char *mapping;
+	size_t offset;
+	int fd;
+
+	if (!pmd_size)
+		SKIP(return, "PMD-sized THPs are not supported");
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	fd = create_shmem_file(_metadata);
+	mapping = map_aligned_file(_metadata, fd, pmd_size, MAP_PRIVATE);
+	if (!collapse(mapping, pmd_size, check_huge_file))
+		SKIP(return, "could not allocate a PMD-sized shmem THP");
+	ASSERT_EQ(fchmod(fd, 0400), 0);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(madvise(mapping, pmd_size / 2, MADV_PAGEOUT), 0);
+	for (offset = 0; offset < pmd_size; offset += page_size)
+		ASSERT_TRUE(page_is_present(self->pagemap_fd,
+					    mapping + offset));
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+	close(fd);
+}
+
+/*
+ * An unauthorized caller must not page out a large file folio that a private
+ * mapping maps with PTEs, even when the advised range covers only part of it.
+ * See pageout_stays_within_range about other unmapping.
+ */
+TEST_F(madvise, pageout_private_file_skips_pte_mapped_file_folio)
+{
+	const size_t size = pmd_size / 2;
+	char *mapping, *shared;
+	unsigned long pfn;
+	uint64_t flags;
+	size_t offset;
+	int fd;
+
+	if (!pmd_size)
+		SKIP(return, "PMD-sized THPs are not supported");
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	if (self->kpageflags_fd < 0)
+		SKIP(return, "requires root to read page flags");
+	fd = create_shmem_file(_metadata);
+	shared = map_aligned_file(_metadata, fd, pmd_size, MAP_SHARED);
+	if (!collapse(shared, pmd_size, check_huge_file))
+		SKIP(return, "could not allocate a PMD-sized shmem THP");
+	ASSERT_EQ(munmap(shared, pmd_size), 0);
+
+	/* Mapping half of the folio leaves it mapped by PTEs. */
+	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	assert_filled(_metadata, mapping, size);
+	pfn = pagemap_get_pfn(self->pagemap_fd, mapping);
+	ASSERT_NE(pfn, -1UL);
+	ASSERT_EQ(pageflags_get(pfn, self->kpageflags_fd, &flags), 0);
+	if (!(flags & KPF_COMPOUND_HEAD))
+		SKIP(return, "the shmem THP was split");
+	ASSERT_EQ(fchmod(fd, 0400), 0);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(madvise(mapping, size / 2, MADV_PAGEOUT), 0);
+	for (offset = 0; offset < size; offset += page_size)
+		ASSERT_TRUE(page_is_present(self->pagemap_fd,
+					    mapping + offset));
+	assert_filled(_metadata, mapping, size);
+
+	ASSERT_EQ(munmap(mapping, size), 0);
+	close(fd);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.0


