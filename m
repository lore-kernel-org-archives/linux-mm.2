Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA6560A3804
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=sqNHz1K+
Received: by kanga.kvack.org (Postfix)
	id 15C986B0303; Mon, 19 Oct 2026 13:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098836B0304; Mon, 19 Oct 2026 13:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8DF6B0305; Mon, 19 Oct 2026 13:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C43966B0303
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:12:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54470160833
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:16 +0000 (UTC)
X-FDA: 85340019072.11.75A2686
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8527718000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sqNHz1K+;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792429934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bz4HIGdHrbzH5B04ukJiXoFVbLAu333X7PHNoO6ecQs=;
	b=qcK0p8XNEiSnC4GkZGg/DvnftntyVaRlKYomCZMW4axhKYs24jCoNZfHRGWdqbz07u2rkN
	pzrDE0sQhdzSfqaB45xucHhvE4Z7/a8DYel1Wg518MqwQbEfZpAW5IfcHiUMIw4oar4vhH
	WxsYfuEQbYpWq0vWodTnNWVVdB7YvBU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sqNHz1K+;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792429934;
	b=BuKVc6KZnbNXXMzUlyHxcisOJrguDjPLbhu6Uevfa1dr1DKcYHknUI1M2GzKl7+Yuu1zgk
	8kqsMimza0y39TSIM8vmPNfpslLAl13Wll4LeSTA/IMFRI8U/CEn0q1qJsMe0KNA1CJqU8
	B1YAhR5NVu+PjJaMHeq6xj0CXVExrwM=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5366ae57896so11834291cf.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792429934; x=1793034734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bz4HIGdHrbzH5B04ukJiXoFVbLAu333X7PHNoO6ecQs=;
        b=sqNHz1K+pnGAEq/M5xks766SfujXcQjjVpSatrGprlKEMmhPFYsbt1xboIUqLWst9V
         q+Qf8OJuPCXu/SXbC51psTkytPpexoWdlZ9q+A3jkRi8gXxy5If0TG15CiIxoUqBQ8l/
         5BYI5tCyCN8uI+ttva/WNQQnFo/mtul1mzR6d7V13F1tcXVtQD7kL07OjNhcB4hUDO7d
         nV8acrFki6tPPMwr7anPxrQ1FHNFYTwuEYon/Y3A8vfGhaJhNKk/Gf9KPovUXDPAay+H
         xGnUckgrahdx5Fs8H8sQFgwa8yT6KYX7tL9ZsWPyMO0D+8I2iM1uJKftGBHsGlvg7rZJ
         osEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792429934; x=1793034734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bz4HIGdHrbzH5B04ukJiXoFVbLAu333X7PHNoO6ecQs=;
        b=HQSDFQXVknbNMy4L3YCa/DL/VMnX4Xh6/n1hNDtN5V/7yxGWmK/2ksaVoQOhUnpV6d
         VWJO0cSyy+kWWhcnpHkBbo9PkyXw2ifLjL8aY0sFqTP1HGOEI47uYWzum38V+nbMI6Ut
         dEGBsSDwlQ1UTNOemFJmYfwC7+l4kp5jolgFs8mIsmTaor/n+drKr0+6EA7bF1gr9twp
         zr/8E1+FT0E1QXfiYSBe2HAAD4eBBZj5gfqz2dNJCt3XPkg73mTBSO1FmZhfPPjSNawB
         MBFQ3hFuK7Hn6tvH68pbx1EoHWXvgY2rQJYcEUZAkPNU79tz62FAv9MuBmax8hxpWrQ6
         Ff1A==
X-Gm-Message-State: AFq9FYKN6xa0wYCPe/jxlo6/vdmr2yjtIXxvqR8PaJdDCJrvb08sQgvW
	YiOSrer8yArT1F7jKgu95B2SlSGp2/qlf7SN77xWw/dfbnwNAHdvtfFvK1S6coSoHWw=
X-Gm-Gg: AYBFou3dmKvOuUuDUKYADbq+Sa4vFxNgaw0mhrbhXtW30+SbZJVdlVag4fmEbqQZOIX
	lATozQqZ2RxKIYRnLX5myV/MLuX7eEl6dAMARjx+//VrtyAq/+2J9qLUnmRjwMrJ6kQC7/HqT76
	94aaonZV8mYoFj+d0O9fdpEQArNZ/TnqPvtB0KRdLSTX0uWUHqbRFy/uoAr8WXNM8258tWxNQeX
	yX27idaUE7bDFm+Aj3BD3rj0EeOOS/FZqfRJO5QcCpT1ZUUZ/Darv0L+i7jvcMxqs7LQ6q+gLZO
	poSZj04Q8yTNkvUnP2frhBsov/pL8pkvY3aLinzXAGM+0NQ+LiYs7XeGtPKAu0a7UJl8b38F3/5
	OQ+XiRZ+GWi1wVVHjWIHcbw/rXp3ZDnQ3weiyaHy04B6Q3KJq+PiALw6iOHoYm2ibxjquqmrpuL
	LhxR+uX3IbnW2Evxa/vtyTzMZ1f9C3M4mOJD8ZXtXPir1fTyjaoHmJzM+kNdxo4A5W2LW/L6L8m
	8/jZLxzzhXkX0kfhMcbnHYlX6zFtuq3MOi/FIh9ez4YTgNPmhLbZ96vbQHR
X-Received: by 2002:a05:622a:229c:b0:51c:fc4:a144 with SMTP id d75a77b69052e-53645bf1ad1mr120809701cf.4.1792429933560;
        Mon, 19 Oct 2026 10:12:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040d4cedsm723116d6.34.2026.10.19.10.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:12:13 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 3/7] selftests/mm: check that MADV_COLD and MADV_PAGEOUT reject hugetlb
Date: Mon, 19 Oct 2026 13:12:02 -0400
Message-ID: <20261019171206.3331374-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019171206.3331374-1-gourry@gourry.net>
References: <20261019171206.3331374-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8527718000D
X-Stat-Signature: xptxitmj65qqw5uztnf1grp3fzdg98zh
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792429934-808507
X-HE-Meta: U2FsdGVkX1++ROme7HYtO4WgbtjYtlDWBk8xCX2YimLCTQH1hM5YVJMBDCS5t7HhAWGe//8Ls8gW5je+Grdo4Qzj3RUXUSE1v2Q2etmqkA8amqdMIzPYRd85O7PeruFs+eOu/SGF+QEKC8vp1N1+WhVw1E+izPEOtCfhosecj7Lpp7Lf8vd++oyfATXBiB9Fwz9W8yn5iTvJL4gqCoADlHdXWQg5PRf95SmM2PFd6d+ELsw4Nhmyjn/znWbVZc1Isd0PFvgj5QX8pThkWKA8UZLCvxC91j2ktWuAUb05IHCP2ItuPerbfDCWTeW6vOZFCc4Pfe2ns2HqmIH6z7Jc4E6fZKKUHnCu3qhMgj9CYRWxYyxV9qmNUfld6XghvXvp+MgdKztRer1HWawhBKlYyKd/d0NdwbE9plgYWdKtZR1Luaj32qBLlyiRI3bbm49kRuJNf/kCP5Xd8ezyvajC+7ivlhnaZLg1x9GksO/qmdDe+H6NiFcDF9AqUiCkQ2gDdjhxifRItNaL0ziiY+FMpQi5qYDaUwjWUF80aYKzd0ci3qHsTbSnfJOgxPxxoN0nvJ6+2eanxLrY4bp8fYordqlBPR2F9bjRaaOJUZVWM2xtzN2ClWzhshYexzWRfzIafB/foDQnhx46uLJOL+3MjVx+DmM4KeFmhQySgYFl9XSbQ2NMD6Uz35TmK5N3MIs6jOj5QjzmfITDuJ43gjKsqViJI+cNNpI2mgnmnvzA1tV7GIb+FOf/JxK+/Cau1VBWmD0++lo+KYwOXQvmSXByP59Wi8+oKQc8UH2WSP4+bMg1jQerd3YdnnBpqW5JNdqcL2TO4mOFCcM7OpYXPhMjJhEwo0EcajnI2eeU/jQ4LqgfvhWOWQnj5L9pWD3fVoGQog85C4EHdenUucHpJYUlUUerN0STIaANXAwxIjb5oZd1q+sO06fPjSZb8THtxF1AP5m9hC4P0Ao/2RKTLSw
 lxd0P+Du
 V0qWRg3MU1y2+PoYZ/y7Plsb0F5RAg+iOJXR6Tmecc11Yg0oyKL0VUJaOZ7jOeN7EwaIDt+azRB6vUdI/t0+eqtEMSrluAs5O3ClCBbFE6H1EWI+fF39YTrzqXEpVsuRS/s2Fv1J86EPjv44jufzfA4QQd+OXWF7ilvfXCFeJHq+bGl+UCZokgJZQCvyhugZggKqb4Bgqv/wehjAshgMSn9Wb6uidCu9s+SbKTXHNQ6+axbteCc2KieiTXhacoC6t0gDHXzPjJp5PF1yUZiCFNJeSoIRo5/XpNCYl6rXhj0QXKSonswiD1asmpmqshdL+WqNzgE9YEKsSKqjq3gRYi1exdWi24dSiXopBkfP/k11psFRAM3NbyDmaGXdOUjV66AsScIk9qxvQ3vtvBoKx1xY2LTXH2KULMkYt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Neither hint may be applied to hugetlb memory, so madvise(2) must fail
with EINVAL for a hugetlb VMA. Locked VMAs are already checked here and
PFNMAP VMAs by the pfnmap test.

Check the hugetlb case for both hints. run_vmtests.sh does not reserve
hugetlb pages, so when run as root main() reserves the one page the test
needs, and restores the pool on exit. Otherwise the test skips if no
page is free.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
v3: Kept Sarthak's Reviewed-by, but only a couple minor changes,
    e.g. the hugetlb reservations / skips.
---
 .../testing/selftests/mm/madv_cold_pageout.c  | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/mm/madv_cold_pageout.c b/tools/testing/selftests/mm/madv_cold_pageout.c
index 8cbbfd4c24c4..0874726ec141 100644
--- a/tools/testing/selftests/mm/madv_cold_pageout.c
+++ b/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -141,6 +141,29 @@ TEST_F(madv_cold_pageout, locked_vma_is_rejected)
 	ASSERT_EQ(munmap(mapping, page_size), 0);
 }
 
+/* Neither hint may be applied to hugetlb memory. */
+TEST_F(madv_cold_pageout, hugetlb_vma_is_rejected)
+{
+	size_t size = default_huge_page_size();
+	char *mapping;
+
+	if (!size)
+		SKIP(return, "hugetlb is not supported");
+	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+	if (mapping == MAP_FAILED)
+		SKIP(return, "no hugetlb pages are available");
+	mapping[0] = 1;
+
+	ASSERT_EQ(madvise(mapping, size, MADV_COLD), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(madvise(mapping, size, MADV_PAGEOUT), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, size), 0);
+}
+
 /* A zero-length range is accepted. */
 TEST_F(madv_cold_pageout, zero_length_is_accepted)
 {
@@ -276,6 +299,9 @@ int main(int argc, char **argv)
 	page_size = getpagesize();
 	/* The harness forks each test, which inherits this. */
 	pin_to_current_cpu();
+	/* Only root can reserve the page that hugetlb_vma_is_rejected maps. */
+	if (!geteuid())
+		hugetlb_setup_default(1);
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
-- 
2.56.0


