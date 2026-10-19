Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E0560A2601
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=gjjwm/hz
Received: by kanga.kvack.org (Postfix)
	id 998506B0302; Mon, 19 Oct 2026 13:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920E96B0303; Mon, 19 Oct 2026 13:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812896B0304; Mon, 19 Oct 2026 13:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4746B0302
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:12:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C25308078E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:14 +0000 (UTC)
X-FDA: 85340018988.11.D3646EC
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 077F440007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="gjjwm/hz";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792429933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSkebjJriJxD8huVKtJ/dZPvDeRsYwUsy6nc9NLY9s4=;
	b=Y7JONZhFk85L6T6pY1ZyUpXSahrMVObr7JtFiT8YMyKXwy4jDh+W80BDqP/1TYdwen4FsH
	HEht0ZANtA4AMSpCA65DM6+zOajylQG/4nlFtUVr/FmZOvxUunzdmuHuNHjhJ//+0qSVN3
	wy6qAxeJtKirC9pRGNCLcaBAZ8OVuIw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="gjjwm/hz";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792429933;
	b=NPE16nUl4rauJ7lDOG/7W2/2phr6gjUq/nhWSo5CikF8EVr2Jnwl3vcmlmpYpF5gSSieS8
	YiGVhoS8Z28EqLN1kFbTrMsjYrNAjZDaBiIL5MtLRRKdN9jVdUpKnIJyOe05HRqcm7/Njh
	+GY5KuxGo0q3qY5aNc2zV3fGN3vRv9E=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91beb36fcc6so15513716d6.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792429932; x=1793034732; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NSkebjJriJxD8huVKtJ/dZPvDeRsYwUsy6nc9NLY9s4=;
        b=gjjwm/hzhArOxjVTz+4i3nxYBmhM5ye/hLdrDiFwJ/oAcjFCqpWkbMmUu5v8Hx2z+k
         l5BFxB2lwwCTfToRW7pHxo+p5cdz/HCEqLsAePV45vE526LgddErM8HmOrKSVowemnht
         Tow+4iW4/q4QvrLh1pQL8v7+OjC+7a5cSbM75YeW7Nw74u3gdyLQ7TCU9sAUl86YFXFC
         Y7K+8Qgxs8h0UwB/EtOeca4mQZamUbov3fWFpU+buO60rPbDB1z2s53WKhm0lYXR6ryJ
         ZpVhUWuHvNh8pIeMa+qnLRn4Rw5oSKcS7JhDW+hRRPQILmzyFlIox7kJRWUhP+gC2RXL
         B1Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792429932; x=1793034732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NSkebjJriJxD8huVKtJ/dZPvDeRsYwUsy6nc9NLY9s4=;
        b=EWfeX2KWkMfibba83YR39Vyza4DAw0GBjWeY0u7sS8NfBlZPLrGqSX0mzjSjjWprnX
         c4Vc8ywTr41owzQyS7cC25p1xhvMsvdJ4+cfJhF1AAVChyCQO7z8eXO/JrSC9Kzygdfm
         /SV7gEUPyYUjvpSgZMKlKlj+83iU+qe1Y5VLasM7mMgflnuO69DFypL5HmGINYCZEr96
         2hqgg+Qrgjyoa4FcYAxV/ti/nBdq8SFfkPWykQ4LmvQTsj6H/EfPbacQFESTREppwaw2
         h1xo/GDMZI6C6397NcftxBgkvUMA4HSLwD/qmOh9K092JNWG5fWG49p/rXwdAe3OFNve
         TQjg==
X-Gm-Message-State: AFq9FYIE5R68EzHIKyHX0On12cr3eFDs80oxRkjYgGzpC0UkWIo7sQ8S
	94+14cOwtFyxVxJb3nTJweaSkQpiIhR/33SxxA52DJpRgfc1DSd+Vxe5H7oOw4af4iQ=
X-Gm-Gg: AYBFou15dQd/CCP/BCTpip+QzNTUjHt9NziXjCgW3OeyBUNg/gAG7Kt2t1gOIHEOjcG
	3SN6V3MgpaXZxucIAec7uaBHB5CQwrM5FVEq++NShmlgo3LLV8w1UdviA5XycNO2yPCvHFphCog
	nLKsKaR7MNDeznf5fYT0YI855ybzhKxjgYk4cpGEN3TJdfuZyxkGFMmAn+/ZGOFuMP6J+rJ816i
	rn0Jzm86M2o1RoW9oRIw7VQgUmUkvU10Pfv7iqSPenjd7s+fcx7TsKprWj1nU8rQrWBg1/7Mvt+
	C2Ka8VIZsFWGIvRVlodurD9l88dYat+OH/duKGQ9Y2W6dHyppYEZ6YNS1goC6c8hH5vO/8DhdsB
	TU6bbFuLYZzBWS69k1+dGAXNsBcVKjkjHYFLTtluGzukRbDuHskJvoV/GLSISVWznzdgGNbCeIw
	5KrplvMf9ayAWVbIRSFHsjdYYE6YWdHvmEgmfh1f23nf/zAwebj0qcYrQaaE/EKmlAQxXaQ2Vdt
	lJJ9l2Y73WEos4Qvx55cfmZueWgzKsyh/1TZO6jKtirFGpXdTFpbJJqr5cAuNgGWBHIYqGn7U4m
	QTmaOqQ6HsNVnQhnXwgRGft+uuGFsIfOJx093ykBZA==
X-Received: by 2002:a05:6214:dcd:b0:91b:9061:b7f7 with SMTP id 6a1803df08f44-91bdf059500mr152667696d6.20.1792429932077;
        Mon, 19 Oct 2026 10:12:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040d4cedsm723116d6.34.2026.10.19.10.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:12:11 -0700 (PDT)
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
	shuah@kernel.org
Subject: [PATCH v3 2/7] selftests/mm: check MADV_COLD and MADV_PAGEOUT range handling
Date: Mon, 19 Oct 2026 13:12:01 -0400
Message-ID: <20261019171206.3331374-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019171206.3331374-1-gourry@gourry.net>
References: <20261019171206.3331374-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 077F440007
X-Rspam-User: 
X-Stat-Signature: bgwfnz6kkz37tayu8s48rhxyeyz3qgjt
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792429932-658589
X-HE-Meta: U2FsdGVkX19BczUZKr6xaa3Vn3YGjUmJ+VFoIQW0tLl78htqONDkaIrBQPhatk5LUIeUALbcjgZnmfv3cYsO37qQvqDU10NwL+NCP4NGkWE4YTubOoQAZW+AU717SfvoDGkEtp30/4oDOOr+y74XvwryEY+qy+ZalqM1e/NbhdJDalyrgmUBoVGl8Yykhoxj8NE3UmcKQtoF4pnvRXrCWJ0VdaUimnUwr06QjFQ6/S6J0ubuLOlV98LQ+HXT67Qb4tIWTF4eorxMVOo/hzwNFqPyP25+Q5FzE8yGIunf4Cldaa/6M7inVMKA0LTSURhhNF6lPtEbzgJcCXJ0Phw2u+he3W7NC07MFFza0isrCuy8RAahUwouL7XjfUkCBa/BKDk5YwJEfW9UR0+yj7+9m5V/+NdjYQX+LeWfiFmPKuqCWdCwHUK2ZHmL9U7Hs76cu56rCrJ/oTnYe8nOuRj5Ww4XHrBYCkWK8QAlHppSF0OrwR69rLxVQvo7Ss6F01t4gV3xvRFbDrzGhgKPmRf+k7iQbjnCDS2ZMN3oXX9TR45o1FoRenmzPTBNlt9j5JlIabhr40Jxzyw1GJr83QfM4bVSHx3cSRCaU1sBI8776GUivjDMDiueQC/WyT/80daA0MsGpfbRYJ/Owa+0it4Bfd3vq82telAqhDBFcawEjhOrtpdjJVHEkT++tT1HG35VgiJTnzL54zStL+GUK6UraI6LghqH6s2aFy/TGOB7t+hwAbikB7tF1Sj0SRHg9YarCwJ0yb0i8F9wvt7pJSaFM1yr+Sd/7LpI/cjA+VQKdP/mOfYxfmZ6aE3VR/RSQ1Ix/Wi/UhSRy34ZSQvz1aN0Ivl4vhvOb+qOH3NK04q3DJx7k0RRGhu05WOVIaTUnA44g5OOjfVq4tTQHttqD1MBm7IvypeQMJ6hka3Ii0AgzYo7JFKsmvqdgNINBKu7DANE/KtfRh4xMP5M9QPcPFB
 83NF7a8N
 9BvcO62nHQe+f6+/X8UkGIopuwXC7o9AKdinbXNcQoNYNwjlcq+GAaR8Bw/tf+hwc3K523OHIReqc1hmHVIIH6MXE8ueHdaMG19ajJ955qA/yEzESDehMNn/8ARr6R2IqJkeOLLNq/5Hv//Xwyvu3AffPdkND/jD45VDT7H9TGqQ95EH9zHnjlBWSv9zik8zd9EuXgTpy3xkqJf0YDc+7O6JKGIZoQbOy0NTDbdOMGBBKszuCtjrYSbVoJHCRe/MwJf11yl1Wr8P8CgO2r+nTSnyS+7od7EdHPRPoqCZyMXIC9h6ZnHCSXKbIOkuqOxw1CwAmgUxl0+Gd+L6TIeft50WDpRzjKBWTMZ2g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

madvise(2) accepts a zero-length range, rejects an unaligned start, and
reports an unmapped gap in the range with ENOMEM while still applying the
advice to the mapped pages on either side.

Check each of these for both hints. Around the gap, only MADV_PAGEOUT has
an effect the test can observe, so only MADV_PAGEOUT is checked for
paging out both neighbors, and only if MADV_PAGEOUT can swap at all.
Both hints' ENOMEM is checked first, so it is covered without swap.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 .../testing/selftests/mm/madv_cold_pageout.c  | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/tools/testing/selftests/mm/madv_cold_pageout.c b/tools/testing/selftests/mm/madv_cold_pageout.c
index 5d451d409937..8cbbfd4c24c4 100644
--- a/tools/testing/selftests/mm/madv_cold_pageout.c
+++ b/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -141,6 +141,86 @@ TEST_F(madv_cold_pageout, locked_vma_is_rejected)
 	ASSERT_EQ(munmap(mapping, page_size), 0);
 }
 
+/* A zero-length range is accepted. */
+TEST_F(madv_cold_pageout, zero_length_is_accepted)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+
+	ASSERT_EQ(madvise(mapping, 0, MADV_COLD), 0);
+	ASSERT_EQ(madvise(mapping, 0, MADV_PAGEOUT), 0);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/* The start of the range must be page-aligned. */
+TEST_F(madv_cold_pageout, unaligned_start_is_rejected)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+
+	ASSERT_EQ(madvise(mapping + 1, page_size, MADV_COLD), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(madvise(mapping + 1, page_size, MADV_PAGEOUT), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, 2 * page_size), 0);
+}
+
+/*
+ * An unmapped gap in the range makes either hint fail with ENOMEM, after
+ * advising the mapped pages on both sides of the gap. Only MADV_PAGEOUT has
+ * an effect on those pages that the test can observe.
+ */
+TEST_F(madv_cold_pageout, unmapped_gap_fails_after_advising)
+{
+	bool swapped = false;
+	char *mapping;
+	int retry;
+
+	mapping = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+	mapping[2 * page_size] = 1;
+	ASSERT_EQ(munmap(mapping + page_size, page_size), 0);
+
+	ASSERT_EQ(madvise(mapping, 3 * page_size, MADV_COLD), -1);
+	ASSERT_EQ(errno, ENOMEM);
+	ASSERT_EQ(madvise(mapping, 3 * page_size, MADV_PAGEOUT), -1);
+	ASSERT_EQ(errno, ENOMEM);
+	ASSERT_EQ(mapping[0], 1);
+	ASSERT_EQ(mapping[2 * page_size], 1);
+
+	if (!can_swap)
+		SKIP(return, "MADV_PAGEOUT cannot swap");
+
+	for (retry = 0; retry < PAGEOUT_RETRIES && !swapped; retry++) {
+		ASSERT_EQ(madvise(mapping, 3 * page_size, MADV_PAGEOUT), -1);
+		ASSERT_EQ(errno, ENOMEM);
+		swapped = pagemap_is_swapped(self->pagemap_fd, mapping) &&
+			  pagemap_is_swapped(self->pagemap_fd,
+					     mapping + 2 * page_size);
+		if (!swapped)
+			usleep(10000);
+	}
+	ASSERT_TRUE(swapped)
+		TH_LOG("MADV_PAGEOUT did not page out both sides of the gap");
+	ASSERT_EQ(mapping[0], 1);
+	ASSERT_EQ(mapping[2 * page_size], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+	ASSERT_EQ(munmap(mapping + 2 * page_size, page_size), 0);
+}
+
 /* Neither hint may fault a swapped page back in. */
 static void check_skips_swapped_pte(struct __test_metadata *_metadata,
 				    int pagemap_fd, int advice)
-- 
2.56.0


