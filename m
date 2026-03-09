Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9285CEFCD71
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 09:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3A66B0093; Mon,  9 Mar 2026 05:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F4A6B0095; Mon,  9 Mar 2026 05:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42B076B0096; Mon,  9 Mar 2026 05:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 330D26B0093
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:54:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB3608D308
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:54:21 +0000 (UTC)
X-FDA: 84526064322.29.B1DBB01
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1DC70A0007
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:54:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4r+L3HMG;
	spf=pass (imf25.hostedemail.com: domain of 3ypiuaQsKCAslnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3ypiuaQsKCAslnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773050060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/MEyZb/LBxvw6GMpGFDX0oKNKuzzaTQJv09alTwZUHg=;
	b=zU8jbiJcviBdNfKLLa54y1JJaLUd7Vvzfc/ADNaHHrRfOemkVpNqqjtHmQD2z1O+FbEwns
	/FFR/tfJVB1SH5589SEUI0bsT0JL+kSu13Rgfz37lG43WYsxgQGvvYQ+MFDe8J1s2ExOer
	T+76CgzmxI0PK6dEApbTMzsrhhx3kQU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4r+L3HMG;
	spf=pass (imf25.hostedemail.com: domain of 3ypiuaQsKCAslnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3ypiuaQsKCAslnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773050060; a=rsa-sha256;
	cv=none;
	b=uTiEQV/kRBSAeRvbwnrJAzSfFDlNncLu15Z2cGeybGrg6sZcEh3NhA2B5sIRyKzlwh6Ree
	mH3c8o5lA456gEPkmSQzBsN1fqiLKGt/IeSa69O/mz+nqztAV6dky8njvtDlCZiHHDBRny
	bs3U0V8A4i2hMgXEMJdiVFXsrfhqRrc=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3595485abbbso10471542a91.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 02:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773050059; x=1773654859; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/MEyZb/LBxvw6GMpGFDX0oKNKuzzaTQJv09alTwZUHg=;
        b=4r+L3HMGkBNjemazx01YHERzXyxnKSDG9f2w4d22Hyak7M4ZPPVKTC9b2BK1keaakb
         BjH5F7dKpvTH3ViDHbFqif1/ZFxrdaWOxGDSFg9mmtUQZ4is8o3Gvx0VL4hzBy6wZd2m
         qaVMz6htrltRlfhNJjcDU+hK+Q/bGrUO+nkx8kzUimMk9inamUBInaCl1z9781+Mj1eg
         VKaJb+EsjIgmDH6j9TpaK3HTCqszv+7AG1NmGizOKy6j+LINP81H9qvYoltPd8PCTds2
         WIcTXULLWcYRuFCla556TyLjPLowyM6Ytfy0ZR80FupAWxfTNd0jkWP1IA/SkYa/Zu+Z
         xB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773050059; x=1773654859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/MEyZb/LBxvw6GMpGFDX0oKNKuzzaTQJv09alTwZUHg=;
        b=rFzh0DN8QqCyon3DhjFn9obNVhgogLQEQEY/PCUZ9gTiQxpq74MwW4FHGQJMa8OLC5
         XKPNynoN4mltcQu4CqjYXQ4yQO7zcPdDHKF46on4ILGC74Tzcf0tBAd3/td0Sl5trxcA
         6mOOVGXzOckkSzIWNCmmteJNGIc6nhcBLuvwidCri9O9oywLHxFsZAxH1G4u2sCwnaBA
         BDq/jJIJaizXvvhW5VLYqNhs/nWpfy7HSVzaNOLvJIBTLUWoEoRY3vwVwf5fuMmHcyVF
         YyuZwZnRucDbjmm+HyhhLkQf5lrWXKZ1i8J4Ht65kVXskvGw57f+fzbcMIg8IIeIaYJt
         MsGA==
X-Forwarded-Encrypted: i=1; AJvYcCXhWT+7yWYMeN3dfY5Q7E8ButQ13+FB/Cvm7ia71uGsnkruUss45PJqo1pbtHSbd0yzoeq09Kv/SA==@kvack.org
X-Gm-Message-State: AOJu0YwQhpMZJrCrBtU2viF1QlpqvK9E/UiOXB8FbzriOuUZnJCzTJxn
	XU3SHZ0nv4BdWEE8n9LyzCigyQLxuCCUk/r5TtPffmil/k+y9V3+9J6vmESZKJgIaLIVxNyXqzk
	QFvUzvhRSlbKFTtDtyOoCyPhCng==
X-Received: from pjbcq1.prod.google.com ([2002:a17:90a:f981:b0:359:8ddd:8042])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2b4e:b0:359:8e5e:43ee with SMTP id 98e67ed59e1d1-359be2ee7f0mr9058209a91.19.1773050058833;
 Mon, 09 Mar 2026 02:54:18 -0700 (PDT)
Date: Mon, 09 Mar 2026 09:53:55 +0000
In-Reply-To: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
Mime-Version: 1.0
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773050050; l=3384;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=j//w3WNdHhv+K+KJtK+49w6iacgmz4dTxY4RPng9cDM=; b=47SP9RDMCEYTpZusRbsJtAhE6uNyDbx53VwlcxfkhVofBND7pZ84qMDahkOmQWfyUOEuUMi+w
 8KtzTKEfucPCalS3OewldUeVaBmw6TDArODKk48Vg/ruFqX9znVvd2L
X-Mailer: b4 0.14.3
Message-ID: <20260309-gmem-st-blocks-v3-4-815f03d9653e@google.com>
Subject: [PATCH RFC v3 4/4] KVM: selftests: Test that st_blocks is updated on allocation
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: bo8j3ysbbmzpikxqsuomf9xkzr6cfer4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DC70A0007
X-HE-Tag: 1773050059-498388
X-HE-Meta: U2FsdGVkX1/rLgSmQmg1P7atibmvV3vgqdOUVrpVovqMlDpxBsha5nywsebsJG2wpcFxGGKWFaziIRzdgJ1CvRE8z0KUE3eQTScuNdsCbIxXvSPnSUhw0Vwv9rns72+lLc1MupuvZ6rNTD9OcgAHXhYQpv/nnq0JufTm/sJSNKq24BKSUKqNhO99h904Wv8v4MKHz3OxI0gKtz25prJa5TO78BJpX9TUS/BtcgS+GvK3a9x+QLS9L42fT4hhmOGQtZWWLTp8aPvVuI/X1NY+Xd9ySuTvm8TV6DVghYRBzLiiDwSDW05Vz8CkRfqYccGkPXJ1JA3Qyq8OzYo+pnid37h2bHz5kn6zrP8O5MlIFs5qUAbRjZCrq0sT0HqoJc3mU2+wvUu6s6FfTHhcxH103uCnYMmWf5R1woU8Nu92RF3OWG75+LULcDdDXTKQc67QrW6h2NZDGMnJNHlIRdLPMnT2gSiyaKmxQ2Dwty2a8nC32NIW4yYX2GAzSE6MZTo30x9/AJRS+SzWEELd+g5Zdj3InhWsuMUHGr3miTGUym+QfQlwAyn5eh1DCXXMow6AAJg6n7OnjTMbevu6EVCKhU0jKdK7YaQ7BWBgACP4tUdvQ/MregKp/Q/xLeKI2tyRZqRBaF5J2fdQh0Q87Bo1i+PLY78kCRVckxy6X+X7hveArdg86fePPIrEM8zcHZ2RXq7AkwLftIsVXr5Ocp7pgjV7M6KVvbQWmGLjjUU3ELIQXk64EeU2Qx5oUo+xCgeGBAd9r3+lulXLWKxnkRWX7v11ijAj5hrX6Z1YXva8V+0GIOOrNh4zEu5p9c+1xlYse8dfN8TsjbrXJmiei3yjC5vmeI17j4blYQtGVIvKMczMZyjjRgiVJLY9vc2pp0tMDgXgXJ0I0E5L4U+x9XLCz1id+BE4nx6xw6h884Hb0iuyRK5buN22PhzbR1NgG4Ryw0br7P22q9HFLAj3PQh
 LJZ2OiLq
 Acm2LTuZz5QVSfbhKNOTv7CsnXquy0AoaRCdbIY8MOnTrGZ3u1uI4lb0cCxrw+iiM9F07wELeg6QIOkyq6bMYFQisjuuEowlpnMnmo/We9Xz+Z0TDaqEXkPU8Z0pCjKSCg9bgrKtL1FpZzvnJW2tdk2dSNlr2zAUVUXT2vCYMTMgH+6JLZZHgz4nY4LLupegYo78Bciv5it4Dj/IMtHipTY5MAmrMwaSBLGgv56iHiV3Z2Sw4bIWYOJMR1+cL6G7PeMT+kfQjexexQFSoR0VwY7FihmwzBsPEBzUscrTHPO06sHYiu301G+6IO7iNz2XzVGly66D1uB18Anu3tKqqnIKz0H/OtajT2Q1vw8M+WXJroZqnTT5O7sHi3jgmV9EmSrt7bcTTnbgaWEmwj/VvlPQi7LuxTLBsjQXPhnetuOn1EU2vT8RVANWIOkftlH+afG1J46EnnVhUjMxeEHH3cWVZZAhKjkNDgC15vkNG7LFtaUVOU/ifgS0FR1iVD1bLjNyo/1Lp6Sa3dxmdf+E9GoX/CZPkRO4DmpkeW9wamfXdvADPmzsjFyzmad+JTPz+NIk3nMp0Nzx2mUUUFaDw3fWysyAjOSEWLw4qaqs3tfm74Tw1gjmyNTtqjIxgvaG9qN3C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The st_blocks field reported by fstat should reflect the number of
allocated 512-byte blocks for the guest memfd file.

Extend the fallocate test to verify that st_blocks is correctly updated
when memory is allocated or deallocated via
fallocate(FALLOC_FL_PUNCH_HOLE).

Add checks after each fallocate call to ensure that st_blocks increases on
allocation, decreases when a hole is punched, and is restored when the hole
is re-allocated. Also verify that st_blocks remains unchanged for failing
fallocate calls.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 638906298ed73..3381a556f397d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -276,41 +276,58 @@ static void test_file_size(int fd, size_t total_size)
 	TEST_ASSERT_EQ(sb.st_blksize, page_size);
 }
 
+static void assert_st_blocks_matches_size(int fd, size_t expected_size)
+{
+	struct stat sb;
+
+	kvm_fstat(fd, &sb);
+	TEST_ASSERT_EQ(sb.st_blocks, expected_size / 512);
+}
+
 static void test_fallocate(int fd, size_t total_size)
 {
 	int ret;
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, 0, total_size);
 	TEST_ASSERT(!ret, "fallocate with aligned offset and size should succeed");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			page_size - 1, page_size);
 	TEST_ASSERT(ret, "fallocate with unaligned offset should fail");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, total_size, page_size);
 	TEST_ASSERT(ret, "fallocate beginning at total_size should fail");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, total_size + page_size, page_size);
 	TEST_ASSERT(ret, "fallocate beginning after total_size should fail");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			total_size, page_size);
 	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) at total_size should succeed");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			total_size + page_size, page_size);
 	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) after total_size should succeed");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			page_size, page_size - 1);
 	TEST_ASSERT(ret, "fallocate with unaligned size should fail");
+	assert_st_blocks_matches_size(fd, total_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			page_size, page_size);
 	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) with aligned offset and size should succeed");
+	assert_st_blocks_matches_size(fd, total_size - page_size);
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, page_size, page_size);
 	TEST_ASSERT(!ret, "fallocate to restore punched hole should succeed");
+	assert_st_blocks_matches_size(fd, total_size);
 }
 
 static void test_invalid_punch_hole(int fd, size_t total_size)

-- 
2.53.0.473.g4a7958ca14-goog


