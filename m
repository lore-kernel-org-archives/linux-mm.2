Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 989D16087858
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YcFgk06y
Received: by kanga.kvack.org (Postfix)
	id 7FAF66B05C8; Fri,  6 Nov 2026 19:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3396B05C9; Fri,  6 Nov 2026 19:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C546B05CA; Fri,  6 Nov 2026 19:37:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2F86B05C8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEB18C0189
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
X-FDA: 85406458536.14.FFEB142
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B3D01140009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YcFgk06y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011826;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Tz/4R3+nBGJbuRMe2ive2nBKLEVbhjpacp28U7sWIg=;
	b=DS+Sh6HRqJBDYh5rkUXTSTwRtDCvuoCfFKY+hf14P4pbZz6SwooU0FMit1t540u0dbdqC1
	FVzYxcWQERbk4Df3s14hUOD6E8srBucGa1DsMW0Z2V4gADfvQGl/yiSnxR5fdvfAdtH+91
	uPD4/Se6TyER1ceNyfl/t5/ipxa4PK0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YcFgk06y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011826;
	b=iygZv9hdUFIBAxmNkjE4g7ljjEDRVvwX0C2+WX10/gzSTJu1qawDsk8nC0ToaZsKh/QqFE
	abDY53xXIRE0AZb5CIi6sAzy+7TOy5l1rPhlNSvMA2I+GwvfP8CPS/jJBgvJv0R5rilUJE
	4BLspbROZi2RXF/x3i878CGoJDeZ18k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13CAE43F9F;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011826;
	b=us3VkzdYHP08912mKq5PN8ekRTFJmXPZ04BxJYq9g68sMU91aqsJTY5SgZ7AiioWEoPh
	 ZQBZiprsMcjB+z4SZUyo4Ut0EFE74SJk11aF1idkiWzht8ZhPh4N3TO/bSW2ZmKebqFLN
	 X1txzHT+KCxLN6gfhOd8GBRmRrgPVFIoSVLu8V6OL6uZ85VY8M4r+eCSVU2XoCNHixC1S
	 exjDV/1rdkhAPL4/k14HRnTqx4mWlZfwtSRCSHZ/FaV6dCTzgMhxg5UMXbMwJCQG+RWvL
	 LMQkoh0RCLn12i8VV57/RKT4LWfrqk7oeUrWDqwgoL/6zmSY++vMBNULttKt7QHJiQA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011826;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=8Tz/4R3+nBGJbuRMe2ive2nBKLEVbhjpacp28U7sWIg=;
	b=RBNzmu2e/EnV4QYovyyO3EZXgsLuTFRniMk/XGr/g6vX3EPHBWe1xjsnX7ZxVnzqLsHG
	 oEx+OMR/dwI40100Qh0U5q6v6GmvWuRw2OiDL2xsGW6AglDH/g+jLC5vp1tsuTrarOB+A
	 ok3UBgi5xpyUq0pG6qXWG2YLhznO/WclX+E6VUuPptGXO3we2XYgImxSH1poKThHWUPSU
	 BhJ+yMVSgSXWV9w/iErpagk/eJ94FlJ4g698xI/6UkrYjzAG6fSr7x5Pqz/646uA7sif0
	 rqYnPve5mqcyUIqYpMBqJM4YDhRFctSxlITbnlLEfMmH2NR5rUZJibC11I+XPAJa58Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E6F101F008A4;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011825;
	bh=8Tz/4R3+nBGJbuRMe2ive2nBKLEVbhjpacp28U7sWIg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YcFgk06yhJGMx4ocEtTr3gFzuX5jO8NFKmGUP29JT/g/8d43ZnvGlJn39kJwh3ifM
	 sGG8YUQn6msPVOxgGAvKqsJsbl29PDvVcHnOWnqgnWzFiIg6Aj0kyXuLE7l8kAlLW1
	 vwMSI5sZkeOOsLiHJMPWhXENSb9ZPGn1Uq8ag5oKrlFKzCTePF3XHaf2QiH0cCuHSR
	 r3SFVQ4M+MJQbiwJD5gfbiEQ7jV2nLwgR23K6L7k2Je7bhUsMhhofNqGGRcwPvqDow
	 RePU/m4urp+n7NCqph7NJ+hxsB1kO079i5FeOarqAVutz2CmAsZIo2YjCnhRnhwks/
	 wLD2gE9JJXVog==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B52414797B;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:00 -0800
Subject: [PATCH RFC v3 26/88] KVM: selftests: Test marking page ranges
 present and absent
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-26-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=3215;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=7QFJFoFyo46UmZUpk/RDNGh2vejWq8fPg2Gg5WaYGKY=;
 b=ohlAxuF/ZwnJnySiSieqvLG3K3rQ2HRF2CfC9ljofHA8P0oU4N4eE4ebYlYM9FPPevFAFBfew
 2jjSIdh2dl6D92vo4evhVx/SgIK++1Q/1C6fef7z+b8ldarmKvndCR9
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3D01140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: x71osig1skgzpsraywbmj71hn1umau5h
X-HE-Tag: 1794011826-297313
X-HE-Meta: U2FsdGVkX1+1V6JIXTbi4tRcgbM87mx1Ebqy+mxy4C/L2LvzWod5iHRfNi7uLtmHmA0M/EzwxqSrzgLDbHz2Ro28Kz+m7/rCLT8N01AbnYJc0bFoPDdf/sfgAwfdYOIy7P3e3L9hdEcZ5dMem7CkuOnDaC23WkUaJ6d8DrS1UPp7uP8WatpYl9WbadcYlOpaefYrYX93CaEfj/vcaycCYfbow9Zawxhq+PrjV6Uw2boygcb0cpH3FQNpUwzWwi2Dp0mkiuz820VvIJoGSP90x3axGn+92vJTYi3V5mYCbp6hoiTwNB1xXCilt9g40huqQeNu3GNYVjlHx6wrtudbd+Ws9KKjncV+SoVyGLIatktBf0dt5UkFUXfZCl3Ap+oOc0HZEBXDLyMMR7D4y7t7fCLy55oowly+jefvRrLguOppCWkDewE8QKtId9j8pNL1dNsdhG05zS4qu8yYDSXjvvfefN/1tFmuUej+mhnQU5cznJtA1m4bZknsRaloTaB0uHIjX58zhr0qjv9qZBniM0AKCPJyxfC1xSjuEcNK71iMeSU4JVUfYgp4YAkRFUBXF2qPTcGpL8SwluOoSf4x780E1jkqr9fL1MrSAJoYfLpGvY2xZAvZcrqy6lOHkKO5QESGpRTHSeBo7nd+qgPTirMsh97z61Bmg4FG02DdC5R4Xm7BfBtPqdK7ZOVFL4mHg2/holrIXPxs92SIEJgHBVB9Mcc/nwejQccku4GQQ3M6e+zlR0FmtRkjgk5M0jnY/azBj8e6br2BBnYIYcn/VWIV72qfzUyWrO462Enick8OpNrgg7YczJRbnXYbE5OnzOqpWVW0QjJIMJV9lzaAGLqnWLaVXIF0VuEcaiYwHwHDIWzTlzVg2lnuJL1spCB/LlFC4c5iSXLQMG4KQz2XSreBKSjpZfXpVh8QYfd0yPbyEZaUa5BPiN+ioS+JTdtw4yVvkFyCPybE1Yl6mno
 3XjTsjEe
 90FkbTIy+VbHyFG9pBII1b7AkAz7ib73ryB1ccJemFO8LA1WlkZ5anJitj36hB4dcQ6r2QD+TFOU20XfUkdyi5JSKa1/KvqxkwFJRCVGi2ZWfVz/DcHsZJXyonGfTZ2g0THSp5fbGk/0eewHxvgt94E4QJK5XXug12i/tHV3OobLYcRly6aml1gPwwIC+tvAn+Vpt9gmbLMocqL011KSrLcqLNUK5TLciAS/v2NcPVYrfNEeWo21Kc/ia7kfd8SZddt9j5XPymQSsG94XLZo+xrHhPQm0ipXTOyaCEpSEic+an2rl6ZfyIUoNABaBjtPUjAAdCEHu10AWh7JS7cyucLj1b7pLHgNnOE9Qqhsp6DxdGpgtduUbhuuyT7fx26no7Cv6d+j0ccTaYVDcsR7VMFp/9uKpbKDeZna4QTMcvOgySuFdGIl2uBjirQV+ZSecQtcV37OQHO1rQF27Qu7acKIuXBVr94ieQEVaT5XzKmWOit9dXWK+gHBPR8jyZatlzdU4pECAHzidvqOSBxGzHWubR6vdxXljlhurNxge+nyjB0tRvxrPxdkYbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Test dynamically changing page presence in provider files via the
sample memory provider interface.

Verify marking pages absent and restoring them back to present, ensuring
that absent page counts in statistics reflect each change accurately.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/mem_provider_sample_test.c       | 65 ++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/kvm/mem_provider_sample_test.c b/tools/testing/selftests/kvm/mem_provider_sample_test.c
index b39161f4933d3..8fe634b0b4f2e 100644
--- a/tools/testing/selftests/kvm/mem_provider_sample_test.c
+++ b/tools/testing/selftests/kvm/mem_provider_sample_test.c
@@ -72,6 +72,70 @@ static void test_lifecycle_and_creation(int dev_fd)
 	}
 }
 
+static void test_set_present(int dev_fd)
+{
+	size_t page_size = getpagesize();
+	uint64_t nr_pages = 4;
+	uint64_t file_size = nr_pages * page_size;
+	struct mp_set_present sp;
+	struct mp_stats st;
+	int ret, fd;
+
+	fd = create_provider_file(dev_fd, file_size);
+
+	/* Initially all pages are present */
+	TEST_ASSERT(!ioctl(fd, MP_GET_STATS, &st),
+		    "MP_GET_STATS failed: %d (%s)", errno, strerror(errno));
+	TEST_ASSERT(st.absent_pages == 0,
+		    "Initial absent_pages mismatch: expected 0, got %llu",
+		    st.absent_pages);
+
+	/* Mark page 1 absent */
+	memset(&sp, 0, sizeof(sp));
+	sp.value = 0;
+	sp.offset = page_size;
+	sp.len = page_size;
+	ret = ioctl(fd, MP_SET_PRESENT, &sp);
+	TEST_ASSERT(!ret, "MP_SET_PRESENT (absent) failed: %d (%s)",
+		    errno, strerror(errno));
+
+	TEST_ASSERT(!ioctl(fd, MP_GET_STATS, &st),
+		    "MP_GET_STATS failed: %d (%s)", errno, strerror(errno));
+	TEST_ASSERT(st.size == file_size,
+		    "size changed unexpectedly: 0x%llx", st.size);
+	TEST_ASSERT(st.absent_pages == 1,
+		    "absent_pages mismatch after absent: expected 1, got %llu",
+		    st.absent_pages);
+
+	/* Mark page 1 back to present */
+	sp.value = 1;
+	ret = ioctl(fd, MP_SET_PRESENT, &sp);
+	TEST_ASSERT(!ret, "MP_SET_PRESENT (present) failed: %d (%s)",
+		    errno, strerror(errno));
+
+	TEST_ASSERT(!ioctl(fd, MP_GET_STATS, &st),
+		    "MP_GET_STATS failed: %d (%s)", errno, strerror(errno));
+	TEST_ASSERT(st.absent_pages == 0,
+		    "absent_pages mismatch after restore: expected 0, got %llu",
+		    st.absent_pages);
+
+	/* Mark all pages absent */
+	sp.value = 0;
+	sp.offset = 0;
+	sp.len = file_size;
+	ret = ioctl(fd, MP_SET_PRESENT, &sp);
+	TEST_ASSERT(!ret, "MP_SET_PRESENT (all absent) failed: %d (%s)",
+		    errno, strerror(errno));
+
+	TEST_ASSERT(!ioctl(fd, MP_GET_STATS, &st),
+		    "MP_GET_STATS failed: %d (%s)", errno, strerror(errno));
+	TEST_ASSERT(st.absent_pages == nr_pages,
+		    "absent_pages mismatch after all absent: expected %lu, got %llu",
+		    nr_pages, st.absent_pages);
+
+	close(fd);
+}
+
 int main(int argc, char *argv[])
 {
 	int dev_fd;
@@ -79,6 +143,7 @@ int main(int argc, char *argv[])
 	dev_fd = open_provider_dev();
 
 	test_lifecycle_and_creation(dev_fd);
+	test_set_present(dev_fd);
 
 	close(dev_fd);
 	return 0;

-- 
2.56.0.455.g6c5a503b38-goog



