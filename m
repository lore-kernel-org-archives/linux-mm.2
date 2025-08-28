Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8352CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B408E000C; Thu, 28 Aug 2025 05:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A268E0001; Thu, 28 Aug 2025 05:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2218E000C; Thu, 28 Aug 2025 05:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76E0D8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D6DB1408DC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:39 +0000 (UTC)
X-FDA: 83825668878.01.4D55BDC
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf03.hostedemail.com (Postfix) with ESMTP id C10352000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=I2NvUl9s;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf03.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373977; a=rsa-sha256;
	cv=none;
	b=UJ5Pk65mSzIkBMbWhfKVZxus+KVdgI+BUPjXgQkYuhVZfidYBlr35Dz52um2Q8Facro2sV
	34eSwFbiBb+rcYiriQHXNPrD/vuBuvXrneSiqGj2JNDJqKKsn9dmOuz7ie347DOxcBPJNs
	BuMGqORSPE2IguTQeSYYJ1OMKKZiDq4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=I2NvUl9s;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf03.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyhzIZH3Q6IiBys3GR5p06vlDvFDBIcBe4gJFy0icy8=;
	b=uzXO+fZDNtaE0OqnOTn9T7xaeHITAgDLSUaCDGvl38MxS/hCEq0D81IMW3ofAha2A3tZ6f
	aKgv4Z+XjT2b/UW/1+f070ZuRAo22z+1s0st27lgv4z9X8jrGfctQXglvyylOFOxc52gBN
	CVsHofC7bRzbgFCJay3tyyy/TlR4f70=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373976; x=1787909976;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SyhzIZH3Q6IiBys3GR5p06vlDvFDBIcBe4gJFy0icy8=;
  b=I2NvUl9syf5Eiigf+fp8xvmmR6vSLB6/9ObXzXnE0K9TrHKveoyyrxRd
   Tagickjct33rexMUUghu+xct2S/IlwJpzlPFseufcxnyF5uoM2rLMz2yE
   p9QiHolOlryijOUIjd7SjL+jlZ9v9QfBwPS+q48K7776Q4L9egZkAJ13a
   IXXHN6tzWH6MbNvvtiwqtcMxznTT+cJ1tC2YyAVxxFiGupbk9gS0rmx/P
   vjUIdgBce2o7n/CcnnSVlIVLbLssljqKx41QkAmXCM+eCRXtzu/kkeGVW
   QrhyHz3PhcUDf3Nfo4q3F+ES6okC4bj1uHlxUvIqjquPSLkyzBZRmS8A9
   g==;
X-CSE-ConnectionGUID: XH6vX520Rw+VjO+/Iz6NOg==
X-CSE-MsgGUID: F0Zsr4f7Qnmj4E5zjIaQkQ==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1301818"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:30 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:2694]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.1:2525] with esmtp (Farcaster)
 id 75f51d0c-0b42-4089-8026-da4960a5d2fe; Thu, 28 Aug 2025 09:39:30 +0000 (UTC)
X-Farcaster-Flow-ID: 75f51d0c-0b42-4089-8026-da4960a5d2fe
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:29 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:29 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:29 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: [PATCH v5 10/12] KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP
 in mem conversion tests
Thread-Topic: [PATCH v5 10/12] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in mem conversion tests
Thread-Index: AQHcF/+mcpyXe48FIE+SGIUwj8fMnw==
Date: Thu, 28 Aug 2025 09:39:29 +0000
Message-ID: <20250828093902.2719-11-roypat@amazon.co.uk>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C10352000B
X-Stat-Signature: 3j3dy4yzkwac1gxoqb66ugk6t1pcxgs5
X-HE-Tag: 1756373976-56502
X-HE-Meta: U2FsdGVkX19KWFXdqvsHJQNyhbO1ZxM/0gFyzuma9jZsFBGzRQFF4fBN7j8CW1m9j6dGHrwRUES7vu7H3qfVF6IuP1jm4elAClLEyac15QWekylmVjv2p8vjQ5mmOHG2DLxCHxXF/BNoR7CbiW5XT2eGxtf18aAjScXQJ+MSZFrNLx/XHgaZUB1j/ZhCq0nsr00rjXMQxlRtCYx8yi4xjeSuj54H0Bk6XVtMi2JJnPbZ08lxxZbEU3wZ/o5EL/mhn/BNOwl5cRCo8YrgKIqnZX2mCwOSi7/3d9+c8Bmc4vO0MjGFMsydSd5EjrXsPICR7Tcr1ka8253cEXDb5ihghAhA+qgYZABmzjlWrlM+uVi6PR/FHxFiK8HofVuifC+OnP8h58OD5AhBVtsykuWYLTU0zQihhAVfNyhocncmt+qO2glN/npfAqLGwN7N0bnTfOnEhRHXWe4WOTBujvgtRuDsbZ2r29/WRmKzZB9Pwf5zzbxUXxJ8Ntg1k9qKv9DMS9u/T8ulIvvitGsPBVtsjVvH9ZVnM77RiPV9M0e6xYieR4Y48ulk4QbymMC/5OEgSu059/Hf+cviRbZj+5Mi/aH00TA3DQCRptMq5zzqsOu1eKdQQ7AgxzeAzE7aseaL0TD4qU2gMw6ehog8XK1OgbCnDzt9yP1fH0L7Fdq2Iq+9hgnHVdfS5fqLUyvx+e97PsTsGeJUNRrpMeCsZOLlfNlTLSDd85mXcteSULN+KdF0E2CsWuhUzheBvAogfB/YxzX820ln7IMgF6lwKuWmTbiTHLpFjZ3pnEY4qRxfNjlo9g/im4C6gJfBIONwksK3tOTSanCxf3tatNvtYRW3iuQNK7JGcA+ubeNQJaIf3ltsE5fE+l6M4djpL5lGqAq1PadAUPOVoZF7VvVpw46vdtkgYVflPyFV3r0vaBOVjvwEFveZ4OGHb8UZa/F8BZ1CyanQZ8m8FliW9r5dyOG
 P7Xuu9Ot
 Jqh0NJFMvkmzdcvPf1+kFMa3hTmYW0lsiuMzLCSNaaR13r6igOeNYGWsdXnBHiqt4g9nSW2kAcxHEpfCRSh+oz6qfRVKGsTQXVU/86D+JbfiVYXNBKEiJku3AvpHD010g0M1jiB1os6etGYiriMXPXrLs6kB4jbFmyCDkNMwXFAFkW9aibwzS7GFUZIEHnrykDyFttsv0CTqCNv9Ai/CfDnJLGD2Po99P+iGqliwlGX+KYeCF3hdMI0xTUwn8yvozm06k7d/IwGQMKAOZxI8uU5bqU+9OMI1rMBkuurYYasfA0bIKINQDCMQBzqEqz7xQ9uDc7kowsj2X2iK2oJtor9/HdL4mo02TZyjzGkg6CZ3fYwSR/CpYjs47z+8L6ymCdAqOUqwUsNofl8mLd+XsgmIFpyYHlhZ7maLbGuVcyrrxaIswN2RXZYgiP7JsrXLWx51nVJWkVl1plf0WxxuUQOyBbmbQxlBFdx83kMAekoth9GcNslmJZurmwLYbn4x6pa2W99aRtXBLawsbxhKxp56p66yBRY5lEbLz8PloYSRgZAYFuP6Hpn0CAoLfgDyIvE32BQO3d2OUr5ay1U8zmpyGvy9q8dQtAWO/xhwq2q8i5go5Wn323U9WZUEptvne8Mgz3lwLhxaR995I7qnRdzN15ejBiSmHXMtFSSVQe/YMTSx8rM5vWsRyFeQC7OB7inOSMyouK4UiVEa3SVD3xrhiX9E5ZKXLuDpaKgtBD+17/Aw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cover the scenario that the guest can fault in and write gmem-backed=0A=
guest memory even if its direct map removed.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 .../selftests/kvm/x86/private_mem_conversions_test.c       | 7 ++++---=0A=
 1 file changed, 4 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=
 b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
index 82a8d88b5338..8427d9fbdb23 100644=0A=
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
@@ -367,7 +367,7 @@ static void *__test_mem_conversions(void *__vcpu)=0A=
 }=0A=
 =0A=
 static void test_mem_conversions(enum vm_mem_backing_src_type src_type, ui=
nt32_t nr_vcpus,=0A=
-				 uint32_t nr_memslots)=0A=
+				 uint32_t nr_memslots, uint64_t gmem_flags)=0A=
 {=0A=
 	/*=0A=
 	 * Allocate enough memory so that each vCPU's chunk of memory can be=0A=
@@ -394,7 +394,7 @@ static void test_mem_conversions(enum vm_mem_backing_sr=
c_type src_type, uint32_t=0A=
 =0A=
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));=
=0A=
 =0A=
-	memfd =3D vm_create_guest_memfd(vm, memfd_size, 0);=0A=
+	memfd =3D vm_create_guest_memfd(vm, memfd_size, gmem_flags);=0A=
 =0A=
 	for (i =3D 0; i < nr_memslots; i++)=0A=
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,=0A=
@@ -477,7 +477,8 @@ int main(int argc, char *argv[])=0A=
 		}=0A=
 	}=0A=
 =0A=
-	test_mem_conversions(src_type, nr_vcpus, nr_memslots);=0A=
+	test_mem_conversions(src_type, nr_vcpus, nr_memslots, 0);=0A=
+	test_mem_conversions(src_type, nr_vcpus, nr_memslots, GUEST_MEMFD_FLAG_NO=
_DIRECT_MAP);=0A=
 =0A=
 	return 0;=0A=
 }=0A=
-- =0A=
2.50.1=0A=
=0A=

