Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C98C0CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53618E0084; Fri, 17 Oct 2025 16:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAEEC8E0078; Fri, 17 Oct 2025 16:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA4E8E0084; Fri, 17 Oct 2025 16:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A94608E0078
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 713AAB7FC7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:11 +0000 (UTC)
X-FDA: 84008705382.02.51D3F01
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id ABB2440004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vIAzPO+s;
	spf=pass (imf11.hostedemail.com: domain of 3VKPyaAsKCLMTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3VKPyaAsKCLMTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpPPOYob1QZnV0MVjnp55PhCGroJIJiVg+QyoFgvrb4=;
	b=Noe2Xxo0klnenW0J4kb3NOs0MiZR1L59RWV8qPzneDCOiZT7T1atqOPkW6pTAVIgsPUTjm
	/8FYgZda9Dwit4cKedBFfHcGWQY6XBLdrPdBhmGczWhV6NEiHS+Gt1qU3PdNZ8LfkCVGZv
	ykVgthF3VU7J0LDH/IyXQHZUAo3n0AU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vIAzPO+s;
	spf=pass (imf11.hostedemail.com: domain of 3VKPyaAsKCLMTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3VKPyaAsKCLMTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731989; a=rsa-sha256;
	cv=none;
	b=7KKIjaIyenNC64/BNeYFNT/rM20SLpx/Ttb0h2JcXhyhD1FMsudqPrCxGks3WnDR6cCde4
	BOEeXYiHnBbQ6/Yw36XggFi41k9olerccLPV1m1rLP3sZXtKAEM6DhrCYDRCBw2d5tCsnh
	yn04piFF1FavYZlDW8soHRnXiBIQbbE=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33be01bcda8so1168856a91.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731988; x=1761336788; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VpPPOYob1QZnV0MVjnp55PhCGroJIJiVg+QyoFgvrb4=;
        b=vIAzPO+sVE3cN1FFnp09L5RaJENVpu5+ttqpATZ7S1gKRs0Cdq9WKmV8Rzl0JfXu4M
         TH2cDndNu2rkD7WmPucglum8m5/k9PdY8klt5Hshjj4Woj8vDpayqcfoBDkaO/pDVdfP
         nj4W/GpZmZjjPIedW7j3s7+Q6I/DAFRx7mdNa+tdo4I4tyDGQlNvhzhkdDX8+nzHjRj9
         gkuYwGcmpB+m3J72BTlb/n2IjY8Njnp1A5bixXKml2cMLJqIfZX7tw0WNAndJtBGcTK9
         DK/U6tWMK+diGX6NBrkoTdhZkBEy3EiTIZ8FS3aP0+uhK0jmabXouuLKm6GMzgFScjWH
         g47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731988; x=1761336788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VpPPOYob1QZnV0MVjnp55PhCGroJIJiVg+QyoFgvrb4=;
        b=PLoolS4sN/dsVCcoH4DIt0JH8/atsMu+1Tv3qath59EQD6l86QUi/vFPNGji/7H9Fa
         6FZTaxOVvuMbgpMHmeKSCGBFsyb9L0CRoiLbIjN+MmRsRPADCW5A+0wf49eQd4wKrp6u
         ANOZw0QfY60AQ+tCCvLHXtLd9iE6iJhRQymD6wOWkHEWFE4gq4AaRD/srn/0wSL+9MtB
         NGkmaVN+/QSDC5HfeeDbnJ1NkVyGyC4Rn9yc3IWEW/eqMQa8Y34AKnhw7iMtOIIFa4uv
         5dbh44nK9uv8dZL6Ae8i8quVfOjAJpY4OYPmgQKSEtaTbvEn/GHw+wOF/YOAP08SvXsl
         qlig==
X-Forwarded-Encrypted: i=1; AJvYcCUvuWyLE1EU0RYeN/FB4PlTbcEo5yhEfJCf2VIcN5jRlQ4dO2qm510hAKS7wPKNmOPaNZEp+rY+vA==@kvack.org
X-Gm-Message-State: AOJu0Yz1XKpyloIWxSIRBlR/Nypr0X9FpSS7s/Ws+PAuq46lqAJD8K9x
	jvsDPSBHeNJ7AJhb//mPtDViE6Ei/nu4gAdkMqOnVY3kpwo1iliatIBnCVhFW4cb5oUrqzltwXk
	8Ag4wY7xtYX36AXZBcwwV2md7fw==
X-Google-Smtp-Source: AGHT+IFaVh5FLKaAG/q3ccs7S5CZUmyME95ySy5g2wu/pIuJKr9rpIYkO/d4uo4694WlqOqMAyATNgjBKMjQAO8boA==
X-Received: from pjbnl2.prod.google.com ([2002:a17:90b:3842:b0:33b:51fe:1a73])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:ec8b:b0:32e:d011:ea0f with SMTP id 98e67ed59e1d1-33bcf8f7280mr5551444a91.25.1760731988400;
 Fri, 17 Oct 2025 13:13:08 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:05 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <1869a0b8eaf867052c11a04fe1efb1442ba1897d.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 24/37] KVM: selftests: guest_memfd: Test precision of conversion
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ABB2440004
X-Stat-Signature: 7ethq3r7ut6zw3hbw58wpbcxakfwzga3
X-Rspam-User: 
X-HE-Tag: 1760731989-985100
X-HE-Meta: U2FsdGVkX18akgRyr4czn8DrS4ra7X6eUcL1HSZ+7aJBqBW/YoOt4C9wkohVC/yFx+ipVb1XFicTJcrtkYaY8N/436iLpkUbknzsFLRB/QtHrY1nqUlqpr3ps104Qx1I2Pgth8EDxmsPLEoIOXvxpVBNxj8e0VlhfjBvxQKwBeTlhhiHpY80F/rbs0C4N2vt1tUYJIjVVh1AIa4LyGXLqQXplrsa+utU5Y/NF11Z9FxfYwjHLQPHiz7iqPKEQZgrWMzmSNVfHKoLDE6ZoprOaDBiTC/al9AwGdV0Deoga4WgC+sX9WF/44+XR3AqvN5VEAN0gktXeZolOg0YULLHIBpw1zlshYoZQta7Sx1tLcj12CcQjzFH8iHnkx6TBGRpy6s4hmBRHpwVVeGPw8z3D/PSnKqab8RQRA04gKgk3XAHIeqfsU6Vsy07+39bpF5l7Cf0LwWx4H6+u4Z0nNwIardnQ8ZMSj6Y6mhW38GTrrLPuzxo05AtEGNKm8WIPLOPtYfpZma/n8AcLbO9NRYPXbXIc3aimMDHf57KKFWc6r2/p9aLn2rRNoTw/CmkybG9/6x7RHecCWCWBkMN4XBIf/KYIomojgiCYyMERJ8RdF6TIb8oCta/4opjGm0YSv4B5wAfy12EmxVcyp1qbDK778Slzmq75/t6+p/fzbdcIrvInGV9lUCvILaqBe7uuA+uVj80AuCZZ3PYft6NGB2p/eyaRycEvmVVsI8hisTqmAcEQ/EZtzp0d9vulFiNgwBrxFJ0KRiaMD2NuIush2oK2/fdCeFIAR24JYrAaajJoSasEckpVvUi1AzEwlNRzYrXXsiFUqN2sz+TIBZ80wLvbkCHtES2P0xZJxouEVUY2bGlERx3qBInXdRlrTfeknbAve9oSOq3mhUna/90hMwayq7bB2lMxuIfSSpWUkmetJt6wUhOIJb32Gtsn28XW+bn0tYjOfHukCbYjO7R+po
 KDZnS46n
 WA6lrDzo8IE++6C6WdB7B5sRbicp/yEEyhwl87D7CVKCZgGx6OkjIyZoJiMzilEZ36zqwD0mXjWr1UJjzSq+0PCTCXxIssYzdIcLNzXxDf3SEdCXGTIknmSpUhb14KhxOXx13Su+S85pVvakmfvT0cPIjyr/Kq/3z6P3XjpqeQR481LLAMwKweOI1GwtxxRFuUts7ZG3Hw2JEoT2wnCI8uzjGjNo3Dz/3y7zSiOowczJ8GkiNnbwd1g3I6mgldKXKgL927yDe8eryXVaIdQoigC7eehB9z4Y1rVbVOfB5md7hPLXk66xSBNnsu88eqoBZLOWD2ImCjE20gopNMoHWIFrUCGXFcaXTA8gkNJk1/h7WO6lyLIkjrlKK3aR+c5/IxJH0Ipx3WuBKNIv8S1oxtVLVXa+TYOL8fvKmoFoILPnJG0Am6qcvTJgZUuLWvqcDPdz9Tj9hot5P4b3Qg7Si1QU6Ia+ZVPlhzf3f0044R+U9UDBi1B0jomIvBaW0tSljNr6B4YOEIln3D7lcRBliy0wcWE+OASSaDUm9gmZ4JOyXuJDaOISJE0qCk9WJDG/0TC7cLV53ygdVMjyl3szyupJiT/4iCfaUCyPs+tVKBogUL0ka1/pZx3WYU0nBumcQp+FyLf8EktdNjAXel92ZfGxATx39X9QIvhj7BReyw/BVKj5bUL6Dc+lOfGAZ2RgmNo8PZP0RZlxUBXw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enhance the guest_memfd indexing selftest to also verify the precision of
memory conversions between private and shared.

The existing test converted a single page within a multi-page mapping but
did not explicitly check the state of the surrounding pages after the
conversion loop.

Add checks to confirm that converting a single page from shared to private
only affects the target page. Iterate through all other pages in the
guest_memfd region to ensure they remain in their original shared state,
thus verifying that the conversion operation is precise and does not have
unintended side effects.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c    | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index b42b1b27cb727..43efe4af1403c 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -235,7 +235,8 @@ GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
 
 /*
  * Test indexing of pages within guest_memfd, using test data that is a multiple
- * of page index.
+ * of page index.  Also test the precision of conversion, that it does not
+ * affect surrounding pages.
  */
 GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
 {
@@ -255,12 +256,20 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
 			test_shared(t, i, i * 2, i * 3, i * 4);
 	}
 
+	/* Confirm that only one page was converted */
 	for (i = 0; i < nr_pages; ++i) {
 		if (i == test_page)
-			test_convert_to_shared(t, i, i * 4, i * 5, i * 6);
+			test_private(t, i, i * 4, i * 6);
 		else
 			test_shared(t, i, i * 4, i * 5, i * 6);
 	}
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == test_page)
+			test_convert_to_shared(t, i, i * 6, i * 7, i * 8);
+		else
+			test_shared(t, i, i * 6, i * 7, i * 8);
+	}
 }
 
 /*
-- 
2.51.0.858.gf9c4a03a3a-goog


