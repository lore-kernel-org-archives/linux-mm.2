Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545EFCA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B99D8E0010; Thu, 28 Aug 2025 05:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B098E0001; Thu, 28 Aug 2025 05:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10AAC8E0010; Thu, 28 Aug 2025 05:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECD5D8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE3781A0A54
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:42 +0000 (UTC)
X-FDA: 83825669004.25.916168B
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8A7F8140005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=aqr7VwiL;
	spf=pass (imf23.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhEedpfYEt1PcCJtARYDpqAPZgRl3DEDExfgwDPiBsk=;
	b=zGAfFLpmCaYVxsyu5tZyp2+rmW1MSQn9m85vNw+QqTQm5Ke8G9EFYQS9wloJKNJg0zlunt
	52Hhu4xleIuEVnhzkfW8xc8uIsHKRzea3UpK65mE8dPFzHIMPKxAxei27OB7OSAfJ53kwH
	aBTfuy9VWJf9+QM/pAYeqThfRS6IMdc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=aqr7VwiL;
	spf=pass (imf23.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373980; a=rsa-sha256;
	cv=none;
	b=ZGDRHZiqnONolM8RsaJaQkylyxEWmhvarhtZgzX+yzEAL0/xqKV3PzWnvaH0x8EpZh8tL2
	ekXEF43T3LmINzTjoMvPe2RKmPOrka0Q+SXBHkItLjvjrfD/6XNytWbn9VbRidjJJE9pYP
	OS7vYA+Zj3xDUnS49yBOvwRT0cTlhas=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373980; x=1787909980;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dhEedpfYEt1PcCJtARYDpqAPZgRl3DEDExfgwDPiBsk=;
  b=aqr7VwiLFuoK7JYE07GOy3SyLCd8NwnsrRcefcNT0mkGAr0uWT7KRYCg
   xWTb0oTQummOQPNac7pclcytDw5TmoLalH4byEq3gNerEwTTxzLFlLyWA
   lSe1sa3DpWcXQw2edcMG4Hjeos9f3zgOnKw4zuTZWqzygYUWZWznFSxui
   l00l+TWulhULGltv47/QmSu3zP4n1IUMS8QEZOvzpyL0BmZOTbF8IL0Sy
   cYuUcsx2lludkUJ/zpuq1/XanI/vNdmhdY9CudbmWgdc4QyTCjUPCZyIe
   TX/401IYriaJXzqFxKjozYgrlaXYVXlqyYvy8opEjftjCJED1s6WQ9GLM
   Q==;
X-CSE-ConnectionGUID: 94cnJsPZSVCixxOlDSzfKw==
X-CSE-MsgGUID: 1aQWO5cOQ+KHlvOc/xQGIg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1302930"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:30 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:20645]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.1:2525] with esmtp (Farcaster)
 id 2dd33327-f6b5-4325-83df-38702bedd8bd; Thu, 28 Aug 2025 09:39:29 +0000 (UTC)
X-Farcaster-Flow-ID: 2dd33327-f6b5-4325-83df-38702bedd8bd
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:25 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:25 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:25 +0000
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
Subject: [PATCH v5 07/12] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Topic: [PATCH v5 07/12] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Index: AQHcF/+kFWmAB7yvMUW8ahTYWv+Nrg==
Date: Thu, 28 Aug 2025 09:39:25 +0000
Message-ID: <20250828093902.2719-8-roypat@amazon.co.uk>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A7F8140005
X-Stat-Signature: trp6ctju5r44g9aux1t7biybnz6rjf7c
X-Rspam-User: 
X-HE-Tag: 1756373980-19592
X-HE-Meta: U2FsdGVkX19rkQF23Zbrwkp/ps8BlfMe9YGhBjU/R41iKAJlIgwkV6T22moWxAa1NE2zmxmqbCZPKGikdCsIiZOB1z9wEZkXlgetjCL7TA0ZeLta0nMrMj4vFHfkOaEw7f3l0lHyp6rYLt3u8dwFgbqe6Rx2VfmRG0Uj1vUY4m4JA2EOuQBbxMp9CFh4Ri1TnZRPsRN4NUUJaySvZ2DT3/2xsD30noxduxLwUI/AENeh3KT4wPFh6a2IZcZIRx944xPAVsI9jUJ9B3291zaVZllAedHGQwJB6G1j7JI9bmYH4kkVYlkmKfjncPs5RqngMJ/3sloFryBVm54VLr7k/fqUvVkxro0h93oZOcDq1rXHhZHR9rDjJtxKooVyfd0ayIWXIS4LlXoghYQUiDSV3nOxKkcRNvxQ8ZSd4NEgWD4jJExQsOpFgUDWSC5TB213lS6/+BheydxPAzGVyG7sdMzyn2m4Mo+2kKgl0GaGLKsheJfw52/tSTCtz79eWas3QDqlWt3qnp3dLCGfBjTSJJcXX1yw2c6fAQI8FLm+Zesr2PyfIkaj5TX4lIFb5bQpHbcNABh8L+mUuppVjYhuJE7vnP2aJQhgR2MrXxxRYUwvvc5o1ZiSvMGErBXTvv5Cr9bglqz1D39cq+BwWvjYOUNT1gDJ8uee5XajaBtSM89fSMy7uAxnFwCrsEuz4dux5eNVTJTYFIBlBhX5a619k6MLKt/mKSk/TyjBmkHOtYBVzgnkvzoQZxHY1fOAdVCmbtJtP4GFrWGYwfQZIydtIjXdF1UrNsLWbziow7Wv2Ps4mlglELNIHiTAPh2jweIbSe0upMJa2FyNxvkDl5j5O0GVzIBUVTQy2bmdUXZp4toOnKfbmPdKgdpSrRNt1OZ7bbj+86yqvc6wL8F6JZQo6vJKDUtR4oq4q/UUUGoRRAoau0dBbyIopoyxB9GMomI6NnFuHXa5s2CGoRZwvJb
 mFoTj5R1
 6ByaIM0zLUugz6mnepOGrVKzDLTQwDbe/YN6ypbI/dZTYLL+byQhyeB92u2qlcvZ32QBkwrujvd27lszFMK2R9ZmY4Oqrzk/LYiEuyNuQ5MjOKShRuocJA2zbp8dCFNdBxc4yGc4KMFMmgIAeQx9kmRjJl/LHUWUgbKNUwhj+rdSf+79aKc6LUy2r6WBK/ZVicdGvXxl46M+HunEJZvkpQpNmvCYhWDasQZPPxvRoP3MGK0eRc9Q3igv1SyMuwIjysYT+aPc2u4KWRxG0txgRMdATb1oRm2TEI+d2ORRZ+qb3TnjL5OLwq28TWIUNqIHPeVt9F3L3UelNYng2xwk+nvkYD2KKNJJfTgMzWwVTygRjkiHnV56dkBBmYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Have vm_mem_add() always set KVM_MEM_GUEST_MEMFD in the memslot flags if=0A=
a guest_memfd is passed in as an argument. This eliminates the=0A=
possibility where a guest_memfd instance is passed to vm_mem_add(), but=0A=
it ends up being ignored because the flags argument does not specify=0A=
KVM_MEM_GUEST_MEMFD at the same time.=0A=
=0A=
This makes it easy to support more scenarios in which no vm_mem_add() is=0A=
not passed a guest_memfd instance, but is expected to allocate one.=0A=
Currently, this only happens if guest_memfd =3D=3D -1 but flags &=0A=
KVM_MEM_GUEST_MEMFD !=3D 0, but later vm_mem_add() will gain support for=0A=
loading the test code itself into guest_memfd (via=0A=
GUEST_MEMFD_FLAG_MMAP) if requested via a special=0A=
vm_mem_backing_src_type, at which point having to make sure the src_type=0A=
and flags are in-sync becomes cumbersome.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c | 26 +++++++++++++---------=0A=
 1 file changed, 15 insertions(+), 11 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c=0A=
index c3f5142b0a54..cc67dfecbf65 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -1107,22 +1107,26 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_back=
ing_src_type src_type,=0A=
 =0A=
 	region->backing_src_type =3D src_type;=0A=
 =0A=
-	if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
-		if (guest_memfd < 0) {=0A=
+	if (guest_memfd < 0) {=0A=
+		if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
 			uint32_t guest_memfd_flags =3D 0;=0A=
 			TEST_ASSERT(!guest_memfd_offset,=0A=
 				    "Offset must be zero when creating new guest_memfd");=0A=
 			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
-		} else {=0A=
-			/*=0A=
-			 * Install a unique fd for each memslot so that the fd=0A=
-			 * can be closed when the region is deleted without=0A=
-			 * needing to track if the fd is owned by the framework=0A=
-			 * or by the caller.=0A=
-			 */=0A=
-			guest_memfd =3D dup(guest_memfd);=0A=
-			TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memf=
d));=0A=
 		}=0A=
+	} else {=0A=
+		/*=0A=
+		 * Install a unique fd for each memslot so that the fd=0A=
+		 * can be closed when the region is deleted without=0A=
+		 * needing to track if the fd is owned by the framework=0A=
+		 * or by the caller.=0A=
+		 */=0A=
+		guest_memfd =3D dup(guest_memfd);=0A=
+		TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memfd=
));=0A=
+	}=0A=
+=0A=
+	if (guest_memfd > 0) {=0A=
+		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
 =0A=
 		region->region.guest_memfd =3D guest_memfd;=0A=
 		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
-- =0A=
2.50.1=0A=
=0A=

