Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2BED37E37
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7836B00B2; Wed, 14 Jan 2026 08:47:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C57B6B00B4; Wed, 14 Jan 2026 08:47:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B18F6B00B5; Wed, 14 Jan 2026 08:47:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7946B00B2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:47:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1136EB99B1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:47:51 +0000 (UTC)
X-FDA: 84330697542.09.5232BB7
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf21.hostedemail.com (Postfix) with ESMTP id 715531C0006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:47:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="Q/0D3m3N";
	spf=pass (imf21.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZkODn83RzbQJlBtvngM/cf4CG/FWZhQcx+73Doqz/A=;
	b=5+zHpjfmnIFfOq5bSrojqNDuP3hQ6ZJLP6iKLynGJVlnwq/3hWWC2ZBbtND7yfXyt0sl0L
	3JtXhBAVxteL0EIgJI5ltFoRinpounTcxKwYi12qIgigRV8j0VwS8jWF57Nkj5DMkKARM8
	xThcg8spjj/CkldIcyYZMggKq6fZtUY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="Q/0D3m3N";
	spf=pass (imf21.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398468; a=rsa-sha256;
	cv=none;
	b=3XoRRMnhOf4mU8HSL9tnsBWifvhUvISmUgFz9H1Q6ELeMbr78cnrf1M+VLyUGvPT76RcVo
	wUiwmJFALLklY/u8hTOOivguVHL7H2BzNDhtmXvCkoe40XIyPpTDHJctR3ldFUwPJCxDmM
	TCX4opdDDINqhy8fokbKCnoBno+jVNE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1768398468; x=1799934468;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IZkODn83RzbQJlBtvngM/cf4CG/FWZhQcx+73Doqz/A=;
  b=Q/0D3m3NytLHbOA1NZ269kqnmLKcvizNRFYVtjWOIYoCw32EeJxC+tkh
   HF4qBJ+n2lYyOYVJmeqTkMPGCOqGOYgp/b0g1zkNYfQhRO2DYhi8+yTYP
   cWOFQcjwHo4pgsXyF5VYIyQ8z6f+3urJd3DoOChA9X+5kO41JaF+Y7+Yb
   m7UUR5QMepjx9XHhYoBmi2vUqZO+sIvAuFUklpmL+RSr+0xigIsJoTXeh
   T20Nb6y8nxGIcqtj3uQpesw5Jr+cuei0ja2fph4Vv2H6bht3We6Xql3Xz
   1TJ/fudoAx0VIMMafHTZNxQzK3bR9jagPBD8YtP7YPq+W1Jf2sUNDTj9g
   Q==;
X-CSE-ConnectionGUID: 9KpH60D2Si6qGIHBYMit1w==
X-CSE-MsgGUID: IOYRS41zTEev1F6z9fXK1w==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7911948"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:47:30 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.236:26468]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.80:2525] with esmtp (Farcaster)
 id 3d5272de-56d4-40db-b0b7-a6e47fa35f1a; Wed, 14 Jan 2026 13:47:30 +0000 (UTC)
X-Farcaster-Flow-ID: 3d5272de-56d4-40db-b0b7-a6e47fa35f1a
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:47:29 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:47:28 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Wed, 14 Jan 2026 13:47:28 +0000
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
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org"
	<luto@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
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
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v9 12/13] KVM: selftests: stuff vm_mem_backing_src_type into
 vm_shape
Thread-Topic: [PATCH v9 12/13] KVM: selftests: stuff vm_mem_backing_src_type
 into vm_shape
Thread-Index: AQHchVxSq2wgeUau5UaeM0CUzdmDKw==
Date: Wed, 14 Jan 2026 13:47:28 +0000
Message-ID: <20260114134510.1835-13-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
In-Reply-To: <20260114134510.1835-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: 8rqx76q9bgtxz9nkbhrge7pfse41xxrt
X-Rspamd-Queue-Id: 715531C0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768398468-113968
X-HE-Meta: U2FsdGVkX1/DqR0cCLfCR1Vlld0xGra5jU4nQpwztatuptB20R7Ire5cERJC4+j+hPN4E89PhK2oY0J96NIN4XYwn6zHW6WipegWrosKO+SxROpK5U+3IOo+LZ/iYx3MZzvOO2mMmQEL0JZU2gsUfyB+jjOiMwoBxfZZVyuRnav4oCCGALncp5nnHwrW8jj6ek3sSC/q+LNW5DJjy7HEzjLzqROLkBLkMDfuwMpmCpMoK0Is/7Xe34Ev1xLzH1OJGMiPdX6dpXnlTrSfTa7L68ew33ZJt0CfjJstkIfvbd31UsiTffPpxcXjln9WTezSUEx5579u7cEuurqNxdjPjfBA/8ZjVcwviiOtR4wxvBPyLD3g5lv2nQo55G8LMCxw0XSswT4b2GVrtf/kFAXlZ2sxEtAHMTn7VrwhrybhxHm1xSZA1lQcFHiW0ovtFHGu9BJ03qr8xsVTQtI0DPEACGM7STzXVbVKnVyESg3MDi4B6Vv3uujk0UtR+fPOZH/FgPbDaX/zQi50M+ETG01iq4V9uQEl4Uq3LNR46Kk0x3mh47FFyjdc+BvFn1nM9zCQl77Lbr3pxLyeuJ7KWkffk5+91mBREWsYLk9YCysn0Y4CEE3afQumNa3oEaUpzGGkuK+0gH6IR05CnGnWJZ05MLabDIsJE2BvOdMZ/bwWQJ/PMy2pkjfWcjfQT/OUfBDAvbpCHlNZuE7IyHrryT+GRoFCiCZKs586G5pzsmQle06hHa9nl3GMAanSYdvMA84S/fNwNfJR69y1C5UoA1R789BoSVJgu87g5OhHrHWok28cQt6Rsvc1LSx4FriLkOwxhxUSxkpMdLh14gwpdMBhnC69LKNYzq8ZJIbVxU7GIV3mwNj2Xj0HAN3gSCcOG3wouCw7Wi1QASy8wIvt8m2l9de9przgWQUPv36dfyAiENm9fJzgKqCS8GgL/baOiv2Fln63YBNb3ZotCerzlAG
 zosjG4OF
 4C5XrpWfjvKOEGHAI0m9ao487ns8Yle+qsoZ86GaFk8srOSPH/gRL5XSCAxwfhYrxLj/kM5Vb+r2ATA+uPxHCN/mhHLivUti7lM0GYH5hcpC1AGFLImUXGTnRCBNCeXBnhMGtraM0D7qvvwBKsSQ9tfHaScmHqg70jSDSSkIxP5p4XtyRnnSk4iX/SjE8pYZaHR/ZwiSPOOaLn3eq7nNMFQSO3zxvcqgMWyxY+MFy1o80E42gr1Eq3U8IgYlVs8vBTbur5DopEgBuHR1cBWgoNT+Rtx0ks7a7mPzR/3ZKA1G8+6y5nH/ItnVOAF+ExXqKYMcthFZXPtVj3bnad8/DBRxO2hR3h6qhwTkWRhcsZjH2Vd+c01IEte36o+eCTy/MZVQ31fWlBYgrPjgvDf4a3dloLmjDmeV2XP9m7NQnZhG4Rb8nw9WplvcbYFM+FeuRCUux1YVJQjtPN6DVsCObhvqIIR4bhY0rFpy0uakAgf3iXd0cBjWdsHqAXBKXFzPfcS59FW6bo12wNzdquSliWNn3fRIc6Xo0BoQcMGBg8idKj+81JsyKjkQDXQdVAaolwIYcz5GqV2aZSw0abAL/UD8Ydw4WgbjeloKriq0DSgmrXOtUWv8pthoYeD/WZ4GT+jNwNma11wtxSJ9OilvXKuy24WM3YIS+UAaP8N6ho/288gDd7QKIU256Sdl7cQtT1myVPpWrgjdKArnoN9GRVGoX2/gwKWMkV1wLlL2W/aAkgW6+BwEwkpfu3RwVoUogeoQNh+8G1k95J3WXx2GsiGDmLjL4Whg7Zm7/3E3+2FaAyC9xRUEZBgrU1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Use one of the padding fields in struct vm_shape to carry an enum=0A=
vm_mem_backing_src_type value, to give the option to overwrite the=0A=
default of VM_MEM_SRC_ANONYMOUS in __vm_create().=0A=
=0A=
Overwriting this default will allow tests to create VMs where the test=0A=
code is backed by mmap'd guest_memfd instead of anonymous memory.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 19 ++++++++++---------=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +-=0A=
 tools/testing/selftests/kvm/lib/x86/sev.c     |  1 +=0A=
 .../selftests/kvm/pre_fault_memory_test.c     |  1 +=0A=
 4 files changed, 13 insertions(+), 10 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h=0A=
index 6689b43810c1..4bc4af9a40cf 100644=0A=
--- a/tools/testing/selftests/kvm/include/kvm_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/kvm_util.h=0A=
@@ -192,7 +192,7 @@ enum vm_guest_mode {=0A=
 struct vm_shape {=0A=
 	uint32_t type;=0A=
 	uint8_t  mode;=0A=
-	uint8_t  pad0;=0A=
+	uint8_t  src_type;=0A=
 	uint16_t pad1;=0A=
 };=0A=
 =0A=
@@ -200,14 +200,15 @@ kvm_static_assert(sizeof(struct vm_shape) =3D=3D size=
of(uint64_t));=0A=
 =0A=
 #define VM_TYPE_DEFAULT			0=0A=
 =0A=
-#define VM_SHAPE(__mode)			\=0A=
-({						\=0A=
-	struct vm_shape shape =3D {		\=0A=
-		.mode =3D (__mode),		\=0A=
-		.type =3D VM_TYPE_DEFAULT		\=0A=
-	};					\=0A=
-						\=0A=
-	shape;					\=0A=
+#define VM_SHAPE(__mode)				\=0A=
+({							\=0A=
+	struct vm_shape shape =3D {			\=0A=
+		.mode	  =3D (__mode),			\=0A=
+		.type	  =3D VM_TYPE_DEFAULT,		\=0A=
+		.src_type =3D VM_MEM_SRC_ANONYMOUS	\=0A=
+	};						\=0A=
+							\=0A=
+	shape;						\=0A=
 })=0A=
 =0A=
 #if defined(__aarch64__)=0A=
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c=0A=
index 28ee51253909..268a4520633b 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -467,7 +467,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint3=
2_t nr_runnable_vcpus,=0A=
 	if (is_guest_memfd_required(shape))=0A=
 		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
 =0A=
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, fla=
gs);=0A=
+	vm_userspace_mem_region_add(vm, shape.src_type, 0, 0, nr_pages, flags);=
=0A=
 	for (i =3D 0; i < NR_MEM_REGIONS; i++)=0A=
 		vm->memslots[i] =3D 0;=0A=
 =0A=
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/self=
tests/kvm/lib/x86/sev.c=0A=
index c3a9838f4806..d920880e4fc0 100644=0A=
--- a/tools/testing/selftests/kvm/lib/x86/sev.c=0A=
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c=0A=
@@ -164,6 +164,7 @@ struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t typ=
e, void *guest_code,=0A=
 	struct vm_shape shape =3D {=0A=
 		.mode =3D VM_MODE_DEFAULT,=0A=
 		.type =3D type,=0A=
+		.src_type =3D VM_MEM_SRC_ANONYMOUS,=0A=
 	};=0A=
 	struct kvm_vm *vm;=0A=
 	struct kvm_vcpu *cpus[1];=0A=
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/te=
sting/selftests/kvm/pre_fault_memory_test.c=0A=
index 93e603d91311..8a4d5af53fab 100644=0A=
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c=0A=
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c=0A=
@@ -165,6 +165,7 @@ static void __test_pre_fault_memory(unsigned long vm_ty=
pe, bool private)=0A=
 	const struct vm_shape shape =3D {=0A=
 		.mode =3D VM_MODE_DEFAULT,=0A=
 		.type =3D vm_type,=0A=
+		.src_type =3D VM_MEM_SRC_ANONYMOUS,=0A=
 	};=0A=
 	struct kvm_vcpu *vcpu;=0A=
 	struct kvm_run *run;=0A=
-- =0A=
2.50.1=0A=
=0A=

