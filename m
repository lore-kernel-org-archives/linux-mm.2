Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24FAE608D92C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hx+Lrfin
Received: by kanga.kvack.org (Postfix)
	id B55A66B05D2; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EBE6B05D3; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A448D6B05D4; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 857056B05D2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3312B12027F
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:11 +0000 (UTC)
X-FDA: 85406458662.12.8147367
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 175F4140006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hx+Lrfin;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011829;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbgD4ImI2n1rI6Htjo1pftOxgnHtLV+P5ZlvPe7/FPM=;
	b=CE6e0fyCqr2wc4PqIUaBjsJEmlUgLzDsISdqxPVOXtBIVTDQcMunUHscIR9HoVsjZk301r
	C1gPrhOrdaqNe+qBiRjOtGLQ+BDlBlgCyLnrtgifKMn8SkZMUfJHsNo0lQlkAtOFNogTEO
	zVLQAb64WwYDR0nV0wYqktD/plIm5ow=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hx+Lrfin;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011829;
	b=vadLq+EEfue4sydDmez1TNyH2Trsl7qsM2YhWd5LSlkdXXTjEuBxxrFRu73GZwzRMulr3v
	7aAvabnzyqegFWqFnF739gdLeSKZuficS6ffQo8szXyd3Gf4uNxpnHiWBZYK+indbJJskx
	9/7jWnE6Iv5/Ro+UtuaoY+cHv1gPzWo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CB0F44491;
	Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011828;
	b=DhCW07Nn03Q+sJ7vioJGBqHKxhj94Gspz/XxJ+f966pMWIYuMynLGUhWqEsvnZ+D6NNr
	 JxwvHA/mYnrUARMRO0gkHr97CJAdp1dBC6buSy3h4hf1fZImOh9Kyxg8BPghYW4E5uQrz
	 j11uX6RvMmC0dJvrMa6KYGintB1WfxlXvtWlMcXFaBLLl9FtfQSHCVi74TUoIZ8Pz3zdZ
	 hSMCohuugs7u8RdU/X9vadKIxgFIV86L99nuV7BIKL2hzuyQGkPcPESdlxba1ZGQBASWX
	 hSS+mRYsX6NjwQDwgwWRD/uX0PRSO90K3BTPVkdID1ZFSOny6X1qE0SelZpcCu6zDyA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011828;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=XbgD4ImI2n1rI6Htjo1pftOxgnHtLV+P5ZlvPe7/FPM=;
	b=iBtBJ3JTtUyU6GAUDnZXdEx+XF+KPjBz9VlpnWGhxjFhBBQCfJ+qQ19NmqdgX4tIpNCL
	 pamOqcyTGQH4Yb/XOvVqcucwTZIhObsvusBeI77Itb7gNORPI4DAzhgORj2HJec44ygAf
	 W1gn5KGw2DVFMM2+f3cwoXQlfW/HlSXzrOAFCSflB7VaZTcBUrZeewTyRSpo+3DfjGond
	 f6/qjw3n4KecsS+9zsJOVUXfr4cCTaQI9yr1EEHTEMCam8G0rkGtq+BW0Z0hOQ7cgdXTz
	 dF8iJqtmikC7AnDthCzSgtqkz/J8ekC8PqzkpKu+QArFy1Upe4VWMhWebV2pAkFQvTQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E22B41F008A2;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011828;
	bh=XbgD4ImI2n1rI6Htjo1pftOxgnHtLV+P5ZlvPe7/FPM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Hx+LrfinJ+cKXfOoDEnRa6iap2I/5fgh1ug2S6gqUAVQgh4Ru/LwyE73BnFN6NQrh
	 gjbWihRk5WcBvYsVG/AnPSbAEUV6liOXdlVKFi4/ulUPLEMytc7GZ8nsqzwLHzx4SK
	 Pw5D8lXtNGYpGC3/QIYSOtEgqqzQTyakl6FT5lAohHexuw9GzVg1AKiMzpQV2Forrf
	 w+Av/aNks8R9+hayu8/OToEhj/0ictjzU3NChnqXOA7LuF4cYW/zdR/9Rpup205S+V
	 xodva+pE5WpqpLnVNVxT+XD0yu1HBM6LgdMF+3mfWRO1ofeLMFLzS10+DiZUGbXDFR
	 CU3cV8yAVBq6A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A416247977;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:59 -0800
Subject: [PATCH RFC v3 25/88] KVM: selftests: Add basic test for sample
 memory provider
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-25-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=3413;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=egSCIn/Z8yZyelQp7cvP3qLOE5NIjYa4+lOtgqtkCcA=;
 b=eS+nI7PxlE1maO7QU8JcyjZXzc2ref6sfu7l8coYHFOVhGHBKNsZtFBYoz3WLd43hTPKAb1qs
 PP5daxaQ65oBQ7t7obsP+mJagOwOWNCEhUA/gMKhIeq0BPfUyn6q5uy
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 175F4140006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9kioeb1kcmjbyusbgekcaaoz3zeuzdy1
X-HE-Tag: 1794011828-812887
X-HE-Meta: U2FsdGVkX19OwuU9vLmMLyqgZ5DQcBaeC4CACzVznNnNePF370dYWonXYwPdq/n7HKI42ucu9bzoFjJpyZ2O5WEF9L4ypK7V/OBMkSDnmElQ6wXiql/Ic3PhdLdFToGe/9JhMXCUmKKeioCdTz2YEXBzcTFDaVFam7sIGucMH7NfI91Aw/AtH86G0y9ixhYEzVIHqSOms6b8qrt3bU/IIE1AOPNuDwKQlFPEIsn1hzX+xeyoeGocztD6oF5jELd0WMPydOA4ZYv2K4M4/ieERQCVxJBHUq/RnNCxccLxZUIC7H5hqVCsUZQAkiUXgpGTapWhDNJHh6psAjup29JLMWpfDIQF4UyaZe+OlnSnoTOM2cK5DsmULvnsWYdWAX1+eQYRdbyv1chPWWQ4lePlxRxI2QBxgidc9b0NRU4C7ISF9oN7oM0kVMDDhip48OXwOhgjWTAbQfaDbfv5G1D4c/vROI6KQkS5tXtvtqR3LK4U+HP3tAUk0BcYZIVKFJ5MLUtQG0JXFa0quY3L6TsP4BzcN+xd15iS3NUERSgJ8/Yv+JIFLAo7ZKL7dx4z9ZPkwhjCfsucVO6u1k7V+0Lm3KIBjfAtdZXb9hv2BY9OJaSLcfbO3AmFY1IF37dVmN20+0RNrkaRF/oLq0ozDh/lYLu70k34LcJgVhZNXIRgOqxLbWi/eknKxUih0ox/XAT3wjgNY7uFZCfW5GglMWLO9llUn8d+DSPuccerLvWqw/55loX/R6grm7zvwqpIbhgJj755SlbqRfxNelJ2yjrY1Gf+dIgknKQXQyceWtZC1B6IrFmkF5JD1AjQEIWJhLot4JsGsbTnCO8zjppXOwR3vcJyT9uXFomGBKoXpyoBhbQAdL3IjY5TuJKk6TbhGgXqaCqZJKUhCz0R1MsDzoUl5RvkzCFPDUzSY63ziIYu43tC5Oway6zqlTYLCHmxjTBpWNtjvAorX34PAWuao3j
 Q8RNuRGQ
 lWv9j/YiEmRtD58H3dE+fQ3PwdfoHK1tyRD2kzH8QQQbyxP9n0q90qcE4dOAcqCQ/kFy/9ZagPqrAfAtU3YXbBUSiHoQyzp5vi3EERnIeB1/jTkyzsQwrarfxrOcsuLQCHBUrm248/ZJ05i87kHchxvUrqsC+xZ2JjE0l6N3ZF2qOBObA5K02EGu/Lixi0bLxLpobmhwo9j1pVLCi4k7UtkmVgDfe7GWp/6NRFi+1Va/AMMJYdEJXXvjJQzZWShcrl4OexKNCG+v33bvZNiFDnf/u3owVyD6vLtpZX+zJZrzJuKxh+uzifsnr45JnogYmfrWjMlFkOgUJRHwH+VESLXiCgT0dnjNFZjv26QpEp1uaf2+eQUP+TaeUYKA1ZAnIGRTxhKkYXynkYKGwB3ZEPtRHrsoFbDXFLzrh0rIG5jmqbJpRYYaBCJ6pa23uhobbLLyHRzGgYqveO0G+X88RTvPRrkjcv7DJ8QA8FaeOWp9sfclpQZ8dUM8gSztQ6D1HJ0PwHHVJ5U0P/t+itJi5bcVeF/560r+4hvjX3+WBIkeW6teVfiXgBeV9dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a selftest for the sample memory provider to verify lifecycle
management and file creation.

Verify creating provider files across multiple sizes and ensure that
initial statistics accurately reflect file capacity, zero absent pages,
and zero read-only pages.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm           |  1 +
 .../selftests/kvm/mem_provider_sample_test.c       | 85 ++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 17a4256e90819..5f7118bddfc36 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -72,6 +72,7 @@ TEST_GEN_PROGS_COMMON += set_memory_region_test
 TEST_GEN_PROGS_COMMON += memslot_modification_stress_test
 TEST_GEN_PROGS_COMMON += memslot_perf_test
 TEST_GEN_PROGS_COMMON += vm_types_test
+TEST_GEN_PROGS_COMMON += mem_provider_sample_test
 
 # Compiled test targets
 TEST_GEN_PROGS_x86 = $(TEST_GEN_PROGS_COMMON)
diff --git a/tools/testing/selftests/kvm/mem_provider_sample_test.c b/tools/testing/selftests/kvm/mem_provider_sample_test.c
new file mode 100644
index 0000000000000..b39161f4933d3
--- /dev/null
+++ b/tools/testing/selftests/kvm/mem_provider_sample_test.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tests for the sample memory provider (/dev/memory_provider).
+ */
+#include <fcntl.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "test_util.h"
+#include "../../../../samples/kvm/memory_provider.h"
+
+#define DEV_PATH "/dev/memory_provider"
+
+static int open_provider_dev(void)
+{
+	int fd = open(DEV_PATH, O_RDWR);
+
+	if (fd < 0) {
+		TEST_REQUIRE(errno != ENOENT && errno != ENODEV);
+		TEST_FAIL("Failed to open %s: %d (%s)", DEV_PATH, errno,
+			  strerror(errno));
+	}
+	return fd;
+}
+
+static int create_provider_file(int dev_fd, uint64_t size)
+{
+	struct mp_new_file nf = {
+		.size = size,
+	};
+	int fd;
+
+	fd = ioctl(dev_fd, MP_NEW_FILE, &nf);
+	TEST_ASSERT(fd >= 0, "MP_NEW_FILE failed for size 0x%lx: %d (%s)",
+		    size, errno, strerror(errno));
+	return fd;
+}
+
+static void test_lifecycle_and_creation(int dev_fd)
+{
+	size_t page_size = getpagesize();
+	uint64_t sizes[] = {
+		page_size,
+		2 * page_size,
+		2 * 1024 * 1024,
+	};
+	struct mp_stats st;
+	int i, fd;
+
+	for (i = 0; i < ARRAY_SIZE(sizes); i++) {
+		fd = create_provider_file(dev_fd, sizes[i]);
+
+		memset(&st, 0, sizeof(st));
+		TEST_ASSERT(!ioctl(fd, MP_GET_STATS, &st),
+			    "MP_GET_STATS failed: %d (%s)",
+			    errno, strerror(errno));
+		TEST_ASSERT(st.size == sizes[i],
+			    "size mismatch: expected 0x%lx, got 0x%llx",
+			    sizes[i], st.size);
+		TEST_ASSERT(st.absent_pages == 0,
+			    "absent_pages mismatch: expected 0, got %llu",
+			    st.absent_pages);
+		TEST_ASSERT(st.readonly_pages == 0,
+			    "readonly_pages mismatch: expected 0, got %llu",
+			    st.readonly_pages);
+
+		close(fd);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	int dev_fd;
+
+	dev_fd = open_provider_dev();
+
+	test_lifecycle_and_creation(dev_fd);
+
+	close(dev_fd);
+	return 0;
+}

-- 
2.56.0.455.g6c5a503b38-goog



