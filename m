Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B436ACCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635A08E006B; Fri, 17 Oct 2025 16:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF998E0006; Fri, 17 Oct 2025 16:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487868E006B; Fri, 17 Oct 2025 16:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32F9E8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07AD813A753
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:05 +0000 (UTC)
X-FDA: 84008705130.11.54112A5
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 31615C0005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0SoGNxQK;
	spf=pass (imf28.hostedemail.com: domain of 3TaPyaAsKCKwMOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3TaPyaAsKCKwMOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731983; a=rsa-sha256;
	cv=none;
	b=FEcvDK7YA/5x6dsGbMI2ztMjOkBt66gyqTWBmOYjhhOH6UI3eDlNm0oaTf0BaJkjcO29+q
	/ogz/qY0saXspok72V7h64DxBjiTC/5ClpQ446lfCPKI4hYQ5rGeywmtDUNzvFm13pHwuL
	TuLqEM9YBJO+nBPxuqw8PyNnQf+qWwc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0SoGNxQK;
	spf=pass (imf28.hostedemail.com: domain of 3TaPyaAsKCKwMOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3TaPyaAsKCKwMOWQdXQkfZSSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzloQp0TPf2fLdiTJlGZLQkrpHjgZ46Ds9buDtJoDXY=;
	b=mqSu0+pCYV7lIWX4nlgzJwiOR8vDMhMHqYXhszvfYF6uEqwqGqpbysJKWI/JTrQHkanSA/
	miyxRt4OMRKCgh2ZodhRKj7Nj4lNbg3NOeCUWzr+86iEmGkZkUrRWT21Hhl517oBTzPKHe
	03b1hgF1Qn3QxTfmEU3BqZiO6BAtgyE=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33baef12edaso2230544a91.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731982; x=1761336782; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gzloQp0TPf2fLdiTJlGZLQkrpHjgZ46Ds9buDtJoDXY=;
        b=0SoGNxQK5F0CeCQxCiqDYSTPfdlg3J+UNVHF7CLG85a/1192786vWgNN9oNZOjbxq3
         O7/CkFlf8ujwwT5h3JCAfXTlecx3xQf7ZZWioqQHc6fpzTf5PqT86IPHGiz4P94LadbS
         3N+vfWkB5JX6s7yeR+RvgTJ6qauv3FyIheLprOtriGKKXAa58u5Y66yPfaIvbWI+qhqm
         E+gF6WbzMR2VF2fulSNGfbM9qzFFpq9X8c2nitzyGuf0DJgVppJ69wqY+8UZiGiUgSs8
         r97AWD7pkLBgCTLPTCSihaSBpZ7b4Btg7KxNV4CVWznPQ4fe2ZiKlxWkFw2JwCzrMBYf
         Mb7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731982; x=1761336782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gzloQp0TPf2fLdiTJlGZLQkrpHjgZ46Ds9buDtJoDXY=;
        b=NVou66JU3vFZCSrW2VkVUkMgPNLObp33uVabBfJjUceHuaaIeSG/y6mw1hm2dijdzA
         TOsiZA7t5QAuberq/1s52bF74eQXyxWf60tFevmYYNd6oxV0p3k/InlzKd0DdKgrfElK
         wpFEe8cyjrWZpiiFHQcrvGGJD2q3bVqiUmdFJEo9UP36QpuRYyQ/WzjW9vhvY0jQA9rV
         MCmuO7dhSxU6KSeEMBVovjwxsrF56D5dsY/NCb57p217z6UHByS8fIGFFDFjfODfjXkQ
         X7H8fEXBWj3jiwurN/mXLT7oh+HUnVqm0nOAba8m+SbgKr/YILuujmy/39BDxqNiZ4zD
         FuYg==
X-Forwarded-Encrypted: i=1; AJvYcCXXNb+1Db9nmy1GvLFlO5t0+qNeSnwSU21DPIT53R++INgbDmfKrBLux5jyJG8ZN5woPm1C637doQ==@kvack.org
X-Gm-Message-State: AOJu0YxFWJLck66keidQRbD593qeNn4MXnbc0AW9RPtz9+48gcj9miso
	SQSLltQUPw73RKnVhTUxuaKr1zP3m3Hwv1cwvkgDkTa8eDF5A/kWlaLFLhvoXnazC2SfzMPkarj
	zBz16eBnw3KotpasgNfH0QRHOLA==
X-Google-Smtp-Source: AGHT+IEpN0MnN6PvJLRUm946buFQLbmtK0gdHmBaP5LEf3oHWoiaohC28e+OPVfB4xkdPalSl2AiLN8+JWhQOYKhmw==
X-Received: from pjot19.prod.google.com ([2002:a17:90a:9513:b0:323:25d2:22db])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:ec8b:b0:330:3fb8:3885 with SMTP id 98e67ed59e1d1-33bcf8e6354mr5452028a91.18.1760731981888;
 Fri, 17 Oct 2025 13:13:01 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:01 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <c47ed2eddab3146889273373295c576bac296805.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 20/37] KVM: selftests: guest_memfd: Test conversion
 flow when INIT_SHARED
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: tuafahj6rp79o8r4ec3k43c4icujthh3
X-Rspamd-Queue-Id: 31615C0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1760731983-450564
X-HE-Meta: U2FsdGVkX19zsPUm9mngy7ofoDuUbgkkU31EPCbjeeJVap+AnYfePbQvCI3lXk6ICq1hSnTNgRBic4L5x+Hoz7+8bCwnlsqXdfMdHfpgiT4vdO3i+UVy0Whi2fZeyZxU2pCZUEaa+vhc3zcPolOln7c2Zr62UbT2oOChIVOAEnXOMwLvLUr7VXGkdCKd5HCF5SB82dsBDgxVkZYC7SuiJw6CC0hDTzqxrNDoppGF82QDqRvmbXpN9BMbz6+fX8tGpjOM0h5WKDOz7XLIqkZm48QVQASFWrHKDEkgVFPV5asiHCTOuCrd3eQPERkOYQpJfDypUHTHSGNhcZ4X0asasSa0a4x8bAJiAfM+KoGlhVtjq8qIas9pKvUlWGKeTnCbTS9IqZVLIbdhpINY1fMtoJMCNs2cPfoGcR2f0j0//8shvORWwOIKA/b6MH96gPOgGfMmB3OPmL52rPNBPa7fDgGwDyLz7GNwGouJxEDyc+6KDKXNvpX1hlVLcOQ4t4pauSGHwYucUSg02oy5zh2Ef0rgr+KpCFf0X64/OvlhKMIfff62S9GXTCCZYs6rcm2kkteS/+ecXYbvFZQAZfA9h9WsiQLVE0x722H/pe0UpmUss54MtrU3IHhgZuLkOXTR5GKfeXdziQm9WEm1T53ad7CGTLoLDE1mZnpevu1vnKai1x77Wz4SIvFT0OvfvTjvArOVO+peghgexXOTzVj+AoDv9bRZEP79n1mwTSxUPIkAGU69xLmo/8CWjVlsdqOckyL4jJU8RPteRc6nY5I+qlTopdauGcAkshNxH3d1sNTD1yq3mgn9AhXUPgSFU+PcdWalKqvYS3qRr6/gMzuKJcw49BxKR4APRJ9yHEcqmKlN/nDOK8saLqemoDCBU0bG4ex950hILoU0M5Al9cef/ZI9p59i9RmcKybQhLj0yhJU/Ot0GBTWVK2tvlJS02aWlNHzI5a05oboi8oTTwC
 tPbOzOHF
 KI3Lpr6FdRLNLbIVooF8P7F0ixW00/VGvrR9ep1Pt5+wF5OvhKjP91HhcWxnSScfyWuEhJ2PmN+NiOT6LeIHwK93DX5vBOULJgEaljFHGySl/03YPVBe2ylC999HR/FeUdZQdOUJpJc6dBWLQGEU1Tw2954T+VpupJsyboEe+13A8ssZynWFUyzyRSiRXqe/Jok0xTLLLnQ+aDEQ5OI3efeRjpINSi0SfLg8gB1jzcTImuLjmeyeEhQOlSHozZhtpyS8bywm61OszEViNHQ4wR1mlOm2QGtWQbjKi9Xb084QdUh4N14aSTxh5LoUCqebp/UJzI8rRdzFXpFAMZ0f+wQuMYy+GMNMcCfBYqRsqu3zLVIhzd6kGMPxQpvYM1rLigPHWVjkXiuJERk4eoELZu2wK2wAVabuhUIWCHDp+7ufa0kJwLi65/vO59HL98ZgQyx9v46K7sW6Dzoo9HAMZc+gqHckI3RffD3i54FWPpVqMpsf7Xg7zw1SQ4H/928/MYgPYU7xt7vJ0CLFCpm5smV1+wXfVmtSLLnaXjJ8Wvrj1hbqrcU5VlVxM+6gghUfMyxter6OqQ8Te5yKeZS7s0wN9ZJgIXaTRFQ1TGXztViKzqSX084xCr1kxNKXJ7Mlai/7qoDmZRbRP4PwXEN2RS4bCvC3+u3wvIy0flNpifypPQe+w0UFiXRwzFjpVY/jS+xik
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test case to verify that conversions between private and shared
memory work correctly when the memory is initially created as shared.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c     | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index e0370e92e1b24..d57e66ee11310 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -95,6 +95,12 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
 #define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)					\
 	__GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
 
+#define __GMEM_CONVERSION_TEST_INIT_SHARED(test, __nr_pages)			\
+	GMEM_CONVERSION_TEST(test, __nr_pages, GUEST_MEMFD_FLAG_INIT_SHARED)
+
+#define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
+	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -194,6 +200,12 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
 	test_convert_to_private(t, 0, 'C', 'E');
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
+{
+	test_shared(t, 0, 0, 'A', 'B');
+	test_convert_to_private(t, 0, 'B', 'C');
+	test_convert_to_shared(t, 0, 'C', 'D', 'E');
+}
 
 int main(int argc, char *argv[])
 {
-- 
2.51.0.858.gf9c4a03a3a-goog


