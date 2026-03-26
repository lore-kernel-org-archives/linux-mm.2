Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7209410AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DAC36B00C5; Thu, 26 Mar 2026 18:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B27F6B00C7; Thu, 26 Mar 2026 18:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7D36B00C8; Thu, 26 Mar 2026 18:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17A6B6B00C5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E116AE1438
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:20 +0000 (UTC)
X-FDA: 84589646400.21.9B9E929
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0661716000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bicqiJt0;
	spf=pass (imf08.hostedemail.com: domain of 3TbLFaQsKCB446E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3TbLFaQsKCB446E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxbETzKCXSc1z/DONft2GKvio3jGrUYSbzzgOX+Xf7Y=;
	b=mBwZNP2UWioivm6xpYPUfrBfApyIdx50nWN/7zywOAW5ibSoJwLJmMSvwk6HPRVdXaYMpK
	jZ9GPAOYOohbrazR72WO4tzehxQaeHl2cHYM3j2SwR3lF6OT8KKMt5TnrLo0Oo+d4nPvyZ
	/5LuDjBoKprD0lsP4SHKOaCNIdvR+dU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563919; a=rsa-sha256;
	cv=none;
	b=2I+xJ48BfiGEPo4WmJ028jfWRK1xzWbKAfYujQHAxxcmw4bM6Ks4/ez8FC5hyLm8ykDk4S
	SCtVUZ2Ld5yqginoZdRjIetO88/Wir2EUIAnZYCBmOG8mE59/yX5OwY8TV0drVzs1OinYx
	/gnP/nMVMf9t7MK3U8wV6pMMMIZKEBk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bicqiJt0;
	spf=pass (imf08.hostedemail.com: domain of 3TbLFaQsKCB446E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3TbLFaQsKCB446E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82a855dc82aso1148292b3a.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563918; x=1775168718; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CxbETzKCXSc1z/DONft2GKvio3jGrUYSbzzgOX+Xf7Y=;
        b=bicqiJt0h8skPW+5X5ZNe1ELfWeo0lzPCm3sbUMAEGiCGCtOq+/jtr9cVGhIbZ3rpj
         HOPHx1qZixHatbtyzVyeYleTdnKP43FzmhU2wi0zHNepzbZdjSnfn41ms3ULcqEKfILl
         UgSMDhhYv2FDieE7uOARTV6nR3YsnjtUVCOs2ZRSeROGC6hq4LUrYMRcn7uYchlVbrre
         8oykvZ8q7kvWClIWha3l6XijS00IK9wqEUGNwt3Y7wEjlES3RkQnHc95IptG8DJzko+C
         5dvwyu5ubhgb5nagBCnRZR3tuFS+okFvb/F1iVUN0/PfSrCXrmQrBmUYimtKBbiixT13
         w+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563918; x=1775168718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CxbETzKCXSc1z/DONft2GKvio3jGrUYSbzzgOX+Xf7Y=;
        b=MpDDFYmeoCs0+lxrQDvjvCDOTho4RMqmb3fcAE7gRXiU/xEb0g90xsZyz0AVIV3P3e
         Wm/iwtcqW/udYpfrVGTwD7NogD2hajqFRzQqcNCkW4RCiVfxjzA0R7CEmjweiVkC0Nnb
         0G823e/6KzaTgeOYQ1+z4nKruUAat7PcH0jXZSATaxV19QuVkU6VsBmfGX3XFl1zGDFn
         wZjkea9tbBVOYBfPZ1i9mYij0ggLZVdzE14/VZc1Xvycak6Y7eImcIDc+vNxNHWpj8A1
         Aa7/MM94zU6zMA9VG0GsFVdIyCjM0gb+3H2yEMSY9HFbFiRrqVKViKQU0wO/jkjR+Lpo
         HSvg==
X-Forwarded-Encrypted: i=1; AJvYcCXbniBDYgfgZdJ6H2rX9QUiLRdAk+J2LAhvtqZIi90eb4ZHt/99PjFt9jE64Mw5tdRWX90dgK0TGQ==@kvack.org
X-Gm-Message-State: AOJu0YxpAO0sqrGGeWQXw3N6WIUcFxguyjOMo7QSnEd8esWtjsG1s6Rw
	vlmrE5Sxvj1KXE9rjlNpvGmXKPxYVsQQoDGdgsCe+u5dprkRB/BcTKZfChUzMnsuKJnOwEr/WCK
	foDcqdWgmmVdaIGFz0a+A56f45g==
X-Received: from pfjt19.prod.google.com ([2002:a05:6a00:21d3:b0:829:7eec:794])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d9c:b0:829:9ea2:3e17 with SMTP id d2e1a72fcca58-82c95d45917mr156048b3a.9.1774563917419;
 Thu, 26 Mar 2026 15:25:17 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:35 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=1634;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ArwNEKwwbHDIAB+t8VvlCTKnXSiAkRboJv5hBzhssb8=; b=HuNUrwsYNrR2xPk/81EPYUE2OyqfcxrfmGxVWyTqFZ8vv4BhYbVtUf37zL0SDyT8xifQZ2GBO
 GDQbPyxFFKxB4OFuan+Lw5MWnRIWkraFqN+uu8w7p8oOz9swRrVK2Bi
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-26-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 26/44] KVM: selftests: Test conversion flow when INIT_SHARED
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 0661716000A
X-Stat-Signature: qdcjyu5idh6sdyc9o47am5cqh8i7e6zm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774563918-207119
X-HE-Meta: U2FsdGVkX1+kIApb72TjLKM5JSAtu9DClSldl2bakIdCK0rF5eH6NkYAn9DT2rkBKYN9XnDFBuV5z1VUsD2d1ibb2gF19MBLOy02TBnN/w02CTA/7kO603SD8b1CNgM3eGMKgMYV5fVl9j2KTwJEawaLv7822kHSeT3bjQ/+Y7uSFw2ACHv8reuGbjnxZGrlCJISDL59tPCW9JTQVa0EVlaI/pdzxBl13a0tErNiMO6NCdjrGSCalbbvskROl/sAEivR//hTFeIuAI2hOik8aAmGIcabEaHiMgP1cdnA1QVbW7tE1QgX0sKbBi7bHzY6FfRxT/0vTj2HUcB5v6Lq3g0hti4j+YzHU/FLwK1bwRLSGYy+tJ5bIg4yLg1MOeM51POiA5uHy3Lpdjw7Lz0/reSh0A5sxU573zhgxL/14vSyb1MU9UKQ8D9xhpywrWX+vic7FbAJ6o7vA9J8TqhYLetRFPFqhyE7Wd7L3JqZKFXkmimSARG2XgzWYO8tE5tkttQpe4QW0deWCzK1Tk77DiLjGV5ukI6RCkDECDBeDjCWZAOAIJakjQ/hTD/ZreYGmLOq4ydwvlHPK/n+1Ge7v+OuGDr5tNk1FBTuVAnbUy78FTOeRgCDBVGmjn3ceLqO2GlubnjvqA4VP0km9CWSEMYIf3HwGfKJq2EdCk2xnt7jtF9XctN0Y7179bErF8AaocGFK3SR/oGNCj2e9GWdPhlIKAO+7M9hg0y5xJaZZlp4fw5p/OgNjtkXnsX2pyeK/alcOJAr6eELDHNuFUVpP47CLY3fFu951iknL7GaHYTJJFjZEb+UDWxQDi0xpknAb4GkmwX+/Mbj8/Wqq4fKArExfTqdGG8Ea+ZeRXoKE2cHq9FP7Y5Oa17PoeqOjgw8Op/IkZ4FRlwQZ8KevfVOqWRBcphMYgrx2wtxKEGdcs9wZaOIlq5rcILHvOshN8klHi9MD4Gxx84oa2hQYtD
 pW0w5kPk
 eBvbe66Tzl4AHXJfafn8xK5HTlUDkxarIPaanPo7EUwHvy6/gs54wugmkljVl36BL+XdgMNJGdM26od6PSbnc/h7uTmEc3WM1HfZWQWTcTnuPKAXgbMqbKkQj1LukKvKOXHpW07BC7MLSEnB4vsGo+HwuS9LHUOjUXVEHs/MXznTNvkj38T2FxZ8J3eGn2ZEohRIxSduAZyn1P05ZXkkCMVVWG7nLI8FBdK/93q/fNWIMscMI3Kbem9oXohVihHj+/ciJSx5vvBnbVrn6HOUQXTPov8vFL/mWoMdYwmOso53uSIfNrmlgDXgoHHkf6IkB4Cj4GnM0nHl93bly9FgM5HLpc8yiw0JxCRojQxvzU464mFsV5CJByK8+svQ2VET6CFCsME5IzLIe5AV1Oj/stTRIRkT3N9sXlXAV06HVs5TB/MYAQHuDsyqOsqsB5H9cwmdlH7FrC0T/CdPLUC+39H43CnPSrCDe4ve0GMdutzJ/Wg6Vc0riQFpq7I++5rKWydczE3lS5IeF9isuUlCdbxTr1eCjsa235DQTpkeI5wrKY2DTv221l7P/CIzS6lFgrDKu/8pvEnhVSl0RI6tCw/SW1zw5HpMvqvvbam8vrj9X4vnBnNS+pziN9Dctp/i6h0u3RaOa9EuGGLtMj2ItoI0eXEumYo5JQQEmq+f3VuUPuoBNSbpR1FsEa/e1EMDZm6NhCT+B3GxibpQmh/L2b3KNIg==
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
 tools/testing/selftests/kvm/guest_memfd_conversions_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 841b2824ae996..81cbdb5def565 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -99,6 +99,12 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
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
@@ -192,6 +198,12 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
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
2.53.0.1018.g2bb0e51243-goog


