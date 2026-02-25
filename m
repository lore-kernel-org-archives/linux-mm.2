Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 943EDF357DA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33FB6B0099; Wed, 25 Feb 2026 02:20:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12F96B009B; Wed, 25 Feb 2026 02:20:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C576C6B009D; Wed, 25 Feb 2026 02:20:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFEAD6B0099
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 616881402BC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:57 +0000 (UTC)
X-FDA: 84482132154.12.9C91FF5
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id AEDEDA0007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=q9oa7js+;
	spf=pass (imf15.hostedemail.com: domain of 31qKeaQsKCOkLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=31qKeaQsKCOkLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772004055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCRWKaRAQP2gBMw/IwAKqq2A0WtVFQ88sM/7soXGb8M=;
	b=feVBHw+7HNiAUEcMI+JCX9OsbqvkdoZYKXeqaGlq77p+GnuKwyJy0lRUd1ROtguyzTbdGw
	EbHwpcITn5gQ+N7IPOYkGwEtoBdMXDLH4qLC3WjzQMrnwh9kXp6vs6hUW9ZpbmEDoIqU2U
	JQa9tzu/Fha8dor1zm6/hZGau15Xvf0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=q9oa7js+;
	spf=pass (imf15.hostedemail.com: domain of 31qKeaQsKCOkLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=31qKeaQsKCOkLNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772004055; a=rsa-sha256;
	cv=none;
	b=obO2ICiL0oMojAMRq1fEwFx9JsPjRZ7drZoKXYd1srOIHljWP2CKbWWsfcg9ovQ822jZql
	o5rX2ZIZ7WTLlGukbd8KsMyQxN4hf+40SmooaK4aLr1cG3E1Sw1dU9gXqjSLNlYUn5Vrnr
	3dWK0z/FsHeNZi6LITRNlu9AIoEhwm0=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aae0d40a47so501593635ad.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772004054; x=1772608854; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uCRWKaRAQP2gBMw/IwAKqq2A0WtVFQ88sM/7soXGb8M=;
        b=q9oa7js+L0MEay55oZfbrENsueZ7x2PttEQSxg4s+DFZDm2j2JLu5UaOb9pATk2lKQ
         v0QHe8S8QPJJ9v7x6Oz5NAN+V3+cdvJvFnLf98r0NnwWiXHW6iH+vOUpWeGUFewmj3vQ
         YUp2aLnOG0XWnLCet1qLgW03T/lPdepR6jrb5mL9gyYh5WQ804RI+E0+OjJPuko3JsHf
         0hq9ck4j8fjd1wvFsjnrelF8zjJrN7zJUwFXs6+cxuBoRA2JbEDCdLPjZYxn/FcKNrZM
         +XUhbtGqK+GAD81FLShRNCWXvxExdBb0++Vi/Aem7589sVQjegW1CCVhmTD7E76Pf3B0
         FS7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772004054; x=1772608854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uCRWKaRAQP2gBMw/IwAKqq2A0WtVFQ88sM/7soXGb8M=;
        b=YGU9NhXRokpGQbe7AlmZfKrzzm9zkjR5nOGIIeOug6ygWGjC8u1T4mjNpDpd0rNS40
         z7gurocUpG0aVxEsCFmphTkMIOthS2rxuP3htG74ae2SFYK9gdqbtlK+0NINfBHPIdxJ
         9f8gnq8V3h+oMkDEmVeur2OgwQfFXuAauM97y8nwSvgDe60ava0ECC58WRE0FsUDya67
         Ocl0aQ/vrs02Ti4grNSuUDb1khAkrCp4c/JoDiHR0ip4npcvdun5Po1dsBFoe5+eHLf2
         B9Ns4SE4nrrbvwJfymQN8w1x+pf+0VTBHFcOheJ6rt/xPxCfsQ1e7bwqIKryAmna6Wvg
         +8rg==
X-Forwarded-Encrypted: i=1; AJvYcCVQMJo6tRLAsZVgUtoP+4q1UgQejSwackeb4a/pywkCYKbeKiM6wTFpAKvsOD5Y3o769MBj3g4npw==@kvack.org
X-Gm-Message-State: AOJu0YzJikyMkkWf9xagu6Xpt1n4zdLigwc3dWeNyOOHiIT9FT7e9DJU
	b6dHGQHI0xKsu6On3X3tJBjSQCSUB6LoDh6i6pEZS2PkfA69ELP+PxfiNbU1neqGHh07K2GKocP
	WV1PXySlGHd1LqeRvPK9gVyIx6g==
X-Received: from plsk6.prod.google.com ([2002:a17:902:ba86:b0:29f:1738:99f3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d511:b0:2a7:c188:bd1f with SMTP id d9443c01a7336-2add14146b1mr15540455ad.40.1772004054358;
 Tue, 24 Feb 2026 23:20:54 -0800 (PST)
Date: Wed, 25 Feb 2026 07:20:41 +0000
In-Reply-To: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
Mime-Version: 1.0
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772004043; l=3384;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=dOYyBdQXA1usfepnnNuDszu6x3QfaYGIbNqVbOtmh7o=; b=zZrSG7T8hLIyNxblKZAGfB+9IN1V9IOqYlhpVMvYXXGbthbgU9tmocvsvN/c7FJF4snDqAhSr
 TzWnTmDXwh2DG87+Tp1yHs6y/+kQ/SVsCjVtOclQbRZ0IyhxW13o7OV
X-Mailer: b4 0.14.3
Message-ID: <20260225-gmem-st-blocks-v2-6-87d7098119a9@google.com>
Subject: [PATCH RFC v2 6/6] KVM: selftests: Test that st_blocks is updated on allocation
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: j9xbkfk8qys86nw8yrahwjztc3ahtk7c
X-Rspam-User: 
X-Rspamd-Queue-Id: AEDEDA0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1772004055-302786
X-HE-Meta: U2FsdGVkX19ESTnV2DhcWOKiRoWlkYYNaq+CH9N8r6ZgSsZQw9LrbFjOhofLrz6uJGo6Xs6vVSmS1Om5UMkz2WOiPkcXIdlAjkqFAgv/v5d+XQjXU36QAeqWVw7PHwWj89Yx8LcAgKmOp44vJ79tr6ttb9+JuU+AunxpdvCSCQDblyRr7ErlnbjZfqsA3qtr3iZBz5isjYlvTsGCxYlN3bHB5auOv7lPVIAIz2KRlaq1tLobowko89/32nEiXyzjRoTlgubmBkaXdvckQPFduRwPU3q8n1LA+NPjIuHPgdFXBKsprEuCOkdS0R18h3tM8M9I/8IEHnAXSR9umG0WLbkC2CaqjFWp1fyXr0M0GJbvFT3TG7b/SqPeHqsh81VNrHYBhzS6444W7V4sRf7cKMHLP3uysCmZYsOOtSqNDMsM7LF9tIEIbrsSEXMa01mKCWIqUkaqREG5IrXxyslzIrYD23Fvp4zkjOTK/gQuDdB88nGukh4m5TcS5KgT88mNbaBL5WjCihoHnlmzSfymuiyA7oQuszKU4JYB+lBLiCwHyO7fuYVsLs/ANxHBjV85MPE206mOHogmiY2iIf2I/ou4moLnnmCf8lD5aa/XBCDinVqfR+1jFKSTt1oBdIGb074NAx0ULWa0mo+fFdxdb1QbP1OcAyHTPN7JA/YHm4KuQHyPgyGCcmZevkjEXEa+IR8IxBO8wFDN02GAH/nq+1/4NFAIDcC1lfrZmTrur5dIepF42A1iV680wpdyD3zW8TKDLdMNy4VMfZXb04V77hnIoL7PUuZFi+Nbu9dmoVPS/CPkA0ZSq3jXyWVQ36sUkEB+jUTrsdXPubeiYjWt6U1UwmkjC11EID1uUDm+pIQr18j00ZYFkj2KMbQogLh2ENuVrCn15/SQBZ4oo66gYzxyHCc4/lhsXtTb5nJ9AQ3zWtokKomPQjgt++9/Wl8ViP2GvQqUkQ+UXU09171
 jEChMole
 T8CHTL2jVx6AoGrKAYi18pe592s4h6DQFTbGW4KJWKPMoOcdOanjKnG8ODqM2JGNKowYsMAYxxGKirGuTs5POMooanPmq6jxJj+VgxzlB3eZpbMyBDFEC77v8vDW9MAdue+5Sn5TFNZMiJFESSE5wXOO98l+ZNgnMumO1ioyx9sLNHpggLeK2LwyvHOYkV/z7mQPonoava/80FslE8ULjEF9BnoZgp8He6BBTADJccOASBwXisOOBnNfUXVYDJNQVWEPwIML9sNUSeo9uhWMJm6FD2D4DUn0wzuB/m7bMCXcov/2JBnU6jTvj/cq1sRWt7aXD9dPB/kxdT/4DqGB7B4yedopJAwB7o43CqUIp57Mk0t206X3fTAqPAJX46lrEixn/3cVTK4l8fNzgzpcjOU5oDmwF7r3pFZPj0Dgey5GwJ3SO7gHM2gpf/g==
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
index 81387f06e770a..89228d73fa736 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -218,41 +218,58 @@ static void test_file_size(int fd, size_t total_size)
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
2.53.0.414.gf7e9f6c205-goog


