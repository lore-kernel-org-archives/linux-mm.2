Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A0ACA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550F56B0030; Thu, 28 Aug 2025 05:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E106B0031; Thu, 28 Aug 2025 05:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5E06B0032; Thu, 28 Aug 2025 05:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA0B86B0030
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B02F11987F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:36 +0000 (UTC)
X-FDA: 83825668752.10.C124801
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf03.hostedemail.com (Postfix) with ESMTP id 12C962000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Gw8pxPFf;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf03.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373974; a=rsa-sha256;
	cv=none;
	b=DkGPp1MejtIcmkzf8OHTltKXHdi4olspsrp+wt3Pc03bJJQSEY7HlnkxpyYQfaLyBlYt8l
	WUm4DS+yueeK36ztZ1BZRGyvF8fiFiUgLIlhIlnZeuo/KLhXtpfypTtCKCJNvLcLiSbRtF
	5eOhbnpRNhrAGR7aJGQx8DBd6xcCl3E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Gw8pxPFf;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf03.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0IDH9n28kEwYt0ECrfeYfhTLW/JDV2HhZTsdNRyHePU=;
	b=g1jVQd+gNNYM5Md3zjhKWlBGY/RjpsKIqyjtQ36fQIb6O0sYPTdF3ZWGWaSAUKm4CLzTUc
	3HEBS+QqP1grIRI/E5wYqXT04Kud0S+hBPHbgMHk8pbvABXARbIGOqBMRSg+Ipq/gWY27g
	8AQJuQUSKO7NjxumWVXHBMNbUVUjiWQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373974; x=1787909974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0IDH9n28kEwYt0ECrfeYfhTLW/JDV2HhZTsdNRyHePU=;
  b=Gw8pxPFfZxvfhzQRd+HaclTJXnJickkHN/+N3lIOXCH4sBWg8Xybj0DE
   IjBx8NVEg1TuUH3PNbTRLIMMlQDCGVhJSK8IdD5LMTZtO9AEqW4VB87FJ
   L5L0ajPCT4Q82W9rlFaP6fez9yypNZVZjCBLsCGsCXsCZTwZxkpYAVIfu
   A4Zy2+ytOX6UDVDJFdNZoMweEjnbnC0rAMCI/hLSZIDu2UFyxQvImSaXK
   DwxZplLo4QqleIFwslGyaG/6I1oMoegPm01Uo2QN9pfVLnTxp+erktMwG
   5hd/W9LiFm6WaCX3JllwZDFzlBy9FCSFIeORaWxd1WkLUF4unf3i9igvY
   A==;
X-CSE-ConnectionGUID: StAVDOr1TDqzrpf/UacFbA==
X-CSE-MsgGUID: 62wxrjsZSS6115niAVDpqQ==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1301811"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:24 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:10411]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.194:2525] with esmtp (Farcaster)
 id cf079725-5cad-40a9-99e7-2d92fc48a8df; Thu, 28 Aug 2025 09:39:23 +0000 (UTC)
X-Farcaster-Flow-ID: cf079725-5cad-40a9-99e7-2d92fc48a8df
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:23 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:23 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:23 +0000
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
Subject: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 05/12] KVM: Documentation: describe
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP
Thread-Index: AQHcF/+iTh4+SyN+qUqFXrn8N9N71g==
Date: Thu, 28 Aug 2025 09:39:22 +0000
Message-ID: <20250828093902.2719-6-roypat@amazon.co.uk>
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
X-Rspamd-Queue-Id: 12C962000B
X-Stat-Signature: 3y3bsdnpqxdzrpqenwpnd6fgaiku9x1p
X-HE-Tag: 1756373973-727249
X-HE-Meta: U2FsdGVkX18m5+6SqPXJnELXM0m+T1ptafW5Esog7FiTozoHYDNn/jF9Livj4vwJoTFoRmdGsCc2IuSlbrmKOagovfKX7pPQGUsHxSY43ZQ7Ydvfsdq9AKgoluTeaIeBwf1r4sxvFB8fRWkxLw3fkmV3fGgdmxQuq37y4EMq7UlThZrQDB3ZhpIxQkX8tKfvthZ3uT9L30HHG0LXQagbULluyZuNwjwRFq3IOPVoh6xujkVXkGe0K3AnixdraEDnLvl8LMmOKmxRwhIRLXAAwdiGmT6p5Vs5FLgNCNVv8SjO+lJr0JWy6AWNCyW0HgAy1/QKjlZwh3C8wamBlil6LEZ3sNRtTPxs4vkEvbVSAVKpoWMU50wogrsTdaFYckAtHO0nFK8UkTj3YDHo9e04Vw9kHWAxI0xLNU30znCKen1gFwy9NZ503Tt4vCRm2WBkm5aHl2H+wf/hZzO7a5cE8MMmq0xXbJf9SYadYNuDIX2Qz7L5QUd3QfoMic6BAiK8PiJDP12l7mASpnOJnhP108lhzvpwi5RP+8YjDzG2Nhs3JrMkVYT3wBOOFcg63zO1lfhbtllLz0P8heK9MEhZFXFRr6xricHCsYw5S5wwtX3RoOFy4r3ZO0QokQxZ62tYzHjz00tYx51Y8J7QjBG3Re6/lOCMXicgwmBBR9xUVkD3866g+SuMes+wvrwolmWT7ZO9HBsA++gbUjEWuKHSK/cfurvewouW3pq//8wjahfr4WKUvGRfvo8PSyn7i+1NYfQaiwvw33p/6VV3Xq7C/cbXuUiCYkta9mdLNojT5Y1pwQSLlAajc8e6obfuGxAyA8F0pugYeey24jkfX6Utuz5/UXSsMrAKt9xKbK9OTMlXtn1fXaxc63g4YV+XeOGwYyMYkYvtDFFoYSyf7QR1qBZZUiCdpZKWR7oqYJqNUfH9m6t/VxLN4zI0WAmnU7uKkTwu5Wtb6qLxPZDgSig
 zcqbZXeq
 qt4r2dFOUCzWbSd3zGIxaDPSapzbKsp9z0+V1+87DXmDtEOMudUiI7xGpOwgU3pozwEhgjtC7zcr0P/VqIQNyvxpMoIFZ4/1nsNe9yvG4aFtGv7Oa1QlX1gllRmo2cfZANFel6juHI9nCZOEjOOtsnhc5xZtOzvjboRNLDZfAgIpwmLz51WfZkn3gb2KmFfXXbkrS3OoYEpI9xZdTd3X0VAY74ZG8Tw4R3Jw8uMxneajLaJWQLrsvPyJsPiNPmETDIIn0LfADUDOMGWY/KrJa9JX8ph2ZZpHbk5NIGAtZFzKAhaM/Q5z2XbJ51GoC1MmQhysdEHXpY+RwHWj+JEOCg/2RSHP+tLYqJYLljH+T2wiONKgAx1iGvwo69Ww0Rpy0LTICxNQTbcJ4N9HySFErizS3TU1b7jvjcRvsbOIjERExlHFwVVFqMTGDowoo+KJ3eNYzU81PA39iSn0A+7UDuBED1MRiRQV0jH+8ckrM29s49JSxdSBqbEOGtBnQGpr/Q2+sUXRObPsYlJxUEvluou0yeEJE0H11RvCyiPMGNNcle71VA5zYZMpSdVwar12Emp7/buOFtzsxAmKQe/jw1+PoSl/sgsgp5ILN4Bf856+zd7TD/TfpRo0H53SySvyQ2KcENcgmuoyLt6kXqwi0xR6XCQ2SMgtNwcOogS11B4PdePw9sHzBkUgJYtBVLUKqbySZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 Documentation/virt/kvm/api.rst | 5 +++++=0A=
 1 file changed, 5 insertions(+)=0A=
=0A=
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t=0A=
index c17a87a0a5ac..b52c14d58798 100644=0A=
--- a/Documentation/virt/kvm/api.rst=0A=
+++ b/Documentation/virt/kvm/api.rst=0A=
@@ -6418,6 +6418,11 @@ When the capability KVM_CAP_GUEST_MEMFD_MMAP is supp=
orted, the 'flags' field=0A=
 supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation=
=0A=
 enables mmap() and faulting of guest_memfd memory to host userspace.=0A=
 =0A=
+When the capability KVM_CAP_GMEM_NO_DIRECT_MAP is supported, the 'flags' f=
ield=0A=
+supports GUEST_MEMFG_FLAG_NO_DIRECT_MAP. Setting this flag makes the guest=
_memfd=0A=
+instance behave similarly to memfd_secret, and unmaps the memory backing i=
t from=0A=
+the kernel's address space after allocation.=0A=
+=0A=
 When the KVM MMU performs a PFN lookup to service a guest fault and the ba=
cking=0A=
 guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always =
be=0A=
 consumed from guest_memfd, regardless of whether it is a shared or a priva=
te=0A=
-- =0A=
2.50.1=0A=
=0A=

