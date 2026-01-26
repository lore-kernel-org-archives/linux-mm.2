Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFB1CD19503
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5186A6B008A; Mon, 26 Jan 2026 11:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC8E6B008C; Mon, 26 Jan 2026 11:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4336B009D; Mon, 26 Jan 2026 11:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5C36B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:53:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D793CD3AB1
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:53:28 +0000 (UTC)
X-FDA: 84374710896.10.471B224
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4FB8A80005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:53:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=SJCPJUkf;
	spf=pass (imf02.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+Z5wrixfI4H8rTwsRxl2yKp4vaZueJxgsH7jlHoBL4=;
	b=sjkpXnRYASYZxbh1mZ7uUgmUcxhizKnQ5T8R+WQdeGKXJkaMZMuRwjVm0trtGjJxuN8H19
	ihhd4ITcvNnpDrLPvHxWtlcZNREv3xyWiJqJ/L8r9veK2IBWsCnhuXZ0xLJoOhVvsBxliq
	xA9SkXDdBZh8LIddg2VVYmUl0TGB6y4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=SJCPJUkf;
	spf=pass (imf02.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446406; a=rsa-sha256;
	cv=none;
	b=eQthkorIAYSj9QmuPCvS97m5CYq1KZUes8vTddRKpF/z40itby/5/2dQQKPAYGOl6ls8TA
	cfPCTfP+C8k9rvc/wasSDFJNtYEDpZS8WdYjAbhfyEY1hEq1ql4bqgB+f3jjO9ZEdc6lkJ
	odwkvyJoWYIlwzj4E3wEcrrVvwd9AeA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446406; x=1800982406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j+Z5wrixfI4H8rTwsRxl2yKp4vaZueJxgsH7jlHoBL4=;
  b=SJCPJUkfe+L9xst/mNduDA5uvULfxXrJCELrIUhQPtim2jz3uelDfB/1
   BLW3EzQxy0njpmMRfXYTKoN1cAX+8/0kklqNFCKGMmfkQKEk6AhXj7Egq
   tWWMmSdq1CymqVkQiQaVEHhMeeSF47pe6zcbk5Ogfj5dsIqaMnIIazk6o
   Z1zausIHxUCIV5pxhjG05cKBBhZWq5wjg2Qn88gSvDh3lzRgZ8so8bTS3
   EjPSdWrbtvctB0EW6GU+qLYtT53l/O1BhZ2DqXmcGzCHVyAlJ0Wtfs7Qa
   wbvoW6WJKQY3uAJKe0kmlJK8gK8yK9uk24jD1j+TmZ5F3fp+UeC/llNlV
   w==;
X-CSE-ConnectionGUID: Yh5g7urpQqWpn4CqoGKYfA==
X-CSE-MsgGUID: 17QVleK0SeyL2TgczznQFA==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8451565"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:53:19 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:31653]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.20.120:2525] with esmtp (Farcaster)
 id 73c5d942-d46d-4131-8f3e-538958800243; Mon, 26 Jan 2026 16:53:19 +0000 (UTC)
X-Farcaster-Flow-ID: 73c5d942-d46d-4131-8f3e-538958800243
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:53:19 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:53:18 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:53:18 +0000
From: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org"
	<willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org"
	<ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev"
	<martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "john.fastabend@gmail.com"
	<john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "shuah@kernel.org" <shuah@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>,
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"prsampat@amd.com" <prsampat@amd.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com"
	<agordeev@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com"
	<gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
	<urezki@gmail.com>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "gerald.schaefer@linux.ibm.com"
	<gerald.schaefer@linux.ibm.com>, "jiayuan.chen@shopee.com"
	<jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org"
	<pavel@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v10 13/15] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing selftests
Thread-Topic: [PATCH v10 13/15] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing selftests
Thread-Index: AQHcjuRFfdDw6PnQdUi9fE6WE495GA==
Date: Mon, 26 Jan 2026 16:53:18 +0000
Message-ID: <20260126164445.11867-14-kalyazin@amazon.com>
References: <20260126164445.11867-1-kalyazin@amazon.com>
In-Reply-To: <20260126164445.11867-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Stat-Signature: ws3k5hpz3bt3rrf4arxhwswyy9qxu6aw
X-Rspamd-Queue-Id: 4FB8A80005
X-Rspam-User: 
X-HE-Tag: 1769446406-637185
X-HE-Meta: U2FsdGVkX19fmEw9S3mqD+ubIrgzGoywwIAg2/NYB7xgLyJNs3A/CmW/HyhFUne5AoyiSfXA8zdMeeJF6FZVF7NUY3koklXJD9kmioax3vNeg4r9gWbG+VLsWivJwN8Be7eae9n4WfxRdt6FsTKTqOfBnkmcVJOcoGSwRkwf0TfvkIGIF37/11eFGWgGdXVBOpYsJHMVdAF59ekLW5JXkVWE3fa+szS2ddxOPz3lhH+G8mz6xiSeG0UoenodV1tZriO6GiLVKfOP2rzDH6xaSagFv8HwPRVzHTZKtaHdwWbx85Q1I1VeSZT55C+XvN95WQhzvj7b+CVQcmNF6dF5kecEgRNfcQKF6/kN0kijxgrofPB49Jzxcexy3MPhLAtUOy0pYGfQUVhvhdlBE+cYNQMors/EBkRWULx8XBYQ77vI43PYkS88Z2YiutH6++nogYLGsWfTG7MOCRPfaEE4E888zo1t6Q0TvcHbOjstD82xpw0Mg+22Iuybf65Oi/92oK3SZL3nDL/1s49BKp0WWX9lrhf5MPPrrksgMEv90RZGlOoj/01yYgAA58t1EPZjNSk3NrpGTrCLlIiwnrTzAC49iZMuxDnZmOjLCtf+SCT580Mc14MxE3N3CATn3FrpvS9YL/iNiYXO95YIr7/0yerJ4icpax4ia5AVIBQWghkmukTaSlHbc6wrEh4wQwFht7XxmY0hXhyAaojRM0j3jJFMoDgdCuv0hZrSDnpWkQpg2mzPXSEpURVEXeeLrWU9sP4vsFdA+jJiGO52cgtfUSe6nasBg0Tviu7N9o7TSMnI67YGGBGhEpoh5ZIl5vJuZVhPwGYKO7lD/xk6GF425R0oEsFR8DEuq6iS9WcTETRShr7iJMNwyuCVqtmSHqLxYs7i7yDxSZ21vH+TA2PzK1UMlrp/nX3MtLriSMFRwTBhjsAdqRmZm2VPvnCiOjcRBMNonGTv2f2aDEtpE/t
 munDAbsf
 eTjssH7wpudt16sTl772ssVqsY/Fv0m0VsSz/BJBr7zylHC6IwZD0r2HLD2rAfOcG9YrOeZhHf6nVn8Zgbj1qKUWfrMs8KGgFf3r1LJt4uzcsA12oiUdRA4zdwMrngNdkVYFZAUyuXtQBCR9qyJhDTZcuMdJeQlB4Hv4Kq3vWFzB3Ish11CweWg/N7K9XRA70frujybrsDdam17ac1EBmmELWEDXNxSUJcUHoaYnUlyu/cjiqQuVqA0eLrdc8kKSdAJe2+zRHdDe6WKodmFW+sSCOAQfPfTjrDAFJdZ3dbhT2AdVU8eWuC4c/6UX7ctXwwWCgEncf2bY7qv23i3U7IXEh8ugHBy7ZnsMb0CS0ErkIlHzW7GSjaa5mBGjZ54QvwSCNUf082JUxMvYQGSVACZMomffD40DY6RQ6sT5S1kDH1H+QDeGzUO6n8/vGBAuK5WlfYgs9oXzJV5C+mN2WzGSsIdg2DaXaWQ/SVPmlHoiE+TcCtd2fwCmXqJ+6yAQyPUD9zH00goh5UqN1StlEGjkD0rXfkSx9cTOkQy9OtWCpXUlJwJLHxwQqYtNA9JlTyFTQma5IL3ylu3FbN8BI1g9JBKgmBY2bvEHelqhwhEjpW/lxutTPRpPPmZDIjAa5psK0munm4NplFXL7gA/GQt1a2n25jYaAZIZtxESCYAD7iixGgq/U2KsehumFiT4xX0hNdfgwxjgVfQp+kBMtNR6DSBMImx0oW6GcIOGKkcS0IKa/Eo+2cGRBkvpLaen+OoQcZAjCYeVl6C0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Extend mem conversion selftests to cover the scenario that the guest can=0A=
fault in and write gmem-backed guest memory even if its direct map=0A=
removed. Also cover the new flag in guest_memfd_test.c tests.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 tools/testing/selftests/kvm/guest_memfd_test.c  | 17 ++++++++++++++++-=0A=
 .../kvm/x86/private_mem_conversions_test.c      |  7 ++++---=0A=
 2 files changed, 20 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing=
/selftests/kvm/guest_memfd_test.c=0A=
index 618c937f3c90..9615018a1a67 100644=0A=
--- a/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
@@ -403,6 +403,17 @@ static void test_guest_memfd(unsigned long vm_type)=0A=
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |=0A=
 				       GUEST_MEMFD_FLAG_INIT_SHARED);=0A=
 =0A=
+	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {=0A=
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_NO_DIRECT_MAP);=0A=
+		if (flags & GUEST_MEMFD_FLAG_MMAP)=0A=
+			__test_guest_memfd(vm, GUEST_MEMFD_FLAG_NO_DIRECT_MAP |=0A=
+					       GUEST_MEMFD_FLAG_MMAP);=0A=
+		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)=0A=
+			__test_guest_memfd(vm, GUEST_MEMFD_FLAG_NO_DIRECT_MAP |=0A=
+					       GUEST_MEMFD_FLAG_MMAP |=0A=
+					       GUEST_MEMFD_FLAG_INIT_SHARED);=0A=
+	}=0A=
+=0A=
 	kvm_vm_free(vm);=0A=
 }=0A=
 =0A=
@@ -445,10 +456,14 @@ static void test_guest_memfd_guest(void)=0A=
 	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLA=
G_INIT_SHARED,=0A=
 		    "Default VM type should support INIT_SHARED, supported flags =3D 0x%=
x",=0A=
 		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));=0A=
+	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLA=
G_NO_DIRECT_MAP,=0A=
+		    "Default VM type should support INIT_SHARED, supported flags =3D 0x%=
x",=0A=
+		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));=0A=
 =0A=
 	size =3D vm->page_size;=0A=
 	fd =3D vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |=0A=
-					     GUEST_MEMFD_FLAG_INIT_SHARED);=0A=
+					     GUEST_MEMFD_FLAG_INIT_SHARED |=0A=
+					     GUEST_MEMFD_FLAG_NO_DIRECT_MAP);=0A=
 	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL=
, fd, 0);=0A=
 =0A=
 	mem =3D kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);=0A=
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=
 b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
index 1969f4ab9b28..8767cb4a037e 100644=0A=
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
@@ -474,7 +474,8 @@ int main(int argc, char *argv[])=0A=
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

