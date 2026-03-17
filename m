Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4225FD877B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA1E6B0092; Tue, 17 Mar 2026 10:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481F56B0093; Tue, 17 Mar 2026 10:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FF66B0095; Tue, 17 Mar 2026 10:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25F9F6B0092
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:11:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E96B91B6E5C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:00 +0000 (UTC)
X-FDA: 84555741480.20.C4F3896
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4DBC2180003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:10:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="RALj/rNb";
	spf=pass (imf24.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYvr0CwhFQIS2ZaS+F5r9gx/5JKbQ+VxsBq0F/u29+4=;
	b=iSswlggMXwP8cw/PJsVqGOB0UmZITcWejvuAsMQ7ZiYguMfSlyOP0kAlz4mEMWmvm7vjwi
	djF82ma9Ez6kyVp8OMgo+yNmb6RbLIC2C5jmyVKRuHy8uD1DngvJW/0Td3yJ3UXnr/K7tX
	tvpM8SrormsGv/fJwg7oXvlA0c436Is=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="RALj/rNb";
	spf=pass (imf24.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756658; a=rsa-sha256;
	cv=none;
	b=2VfYUKWfEpt2gbI7JZgeFD2B91zQrn2qoB7KoaMeMQ8YEQZscu5UyYpnYbZBAsF7XkcGzP
	2I8Lu1n1p4LwTdIjIyBSXSczF1urZXVXCCw1vz/aVTSE/ZOzgn/PF6tkOPLWHHEUHLkQlo
	1yM+HyqFGqKB6fmXMWWesj2r9MltVNk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1773756658; x=1805292658;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VYvr0CwhFQIS2ZaS+F5r9gx/5JKbQ+VxsBq0F/u29+4=;
  b=RALj/rNbqmmp+Uq2TomIEbBRObp+oAjqmtRme0swdySwBRXtCFB8QKpR
   gTok2cFTgqVF+djrfpiqP49J9VPocVlaitvuZuLCFmc7OylCy5CQN92hT
   zuD0bjGNPV5yCRb4B4Fk88aJ3oc2fyx3nZxx/WjjxTwQyx6TAB0TDeM9w
   Imuf5NrUwblbGcPcUYYv5w22MlyNDJH/eYURKTRiIw6i00blCEIuDN3qL
   QuU/qXFDfJNibWzYwjXwXKg7RyRoxkm/DHPzMEzCqutG8ocB8f4KxzpcN
   wwvo0861LC+o98s+wWdcahHuiJSp163QRFS17cF+lSc3qeUUNna6GgbuM
   A==;
X-CSE-ConnectionGUID: qXHvxhvLTNeyghAyahceNg==
X-CSE-MsgGUID: puQ8nFyqTDmGaW3b5uM8dg==
X-IronPort-AV: E=Sophos;i="6.23,124,1770595200"; 
   d="scan'208";a="10894914"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 14:10:57 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:28985]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.12.108:2525] with esmtp (Farcaster)
 id d8fc662a-bddf-4bdd-a07a-65c8795e29a8; Tue, 17 Mar 2026 14:10:56 +0000 (UTC)
X-Farcaster-Flow-ID: d8fc662a-bddf-4bdd-a07a-65c8795e29a8
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:10:56 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:10:55 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.037; Tue, 17 Mar 2026 14:10:55 +0000
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
	<loongarch@lists.linux.dev>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>
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
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com"
	<eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com"
	<riel@surriel.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com"
	<coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
	<yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com"
	<tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
	"wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, "mlevitsk@redhat.com"
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
	"Manwaring, Derek" <derekmn@amazon.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>
Subject: [PATCH v11 02/16] set_memory: add folio_{zap,restore}_direct_map
 helpers
Thread-Topic: [PATCH v11 02/16] set_memory: add folio_{zap,restore}_direct_map
 helpers
Thread-Index: AQHcthfeEMFcBldU0EKH3aXM8Uk9Xg==
Date: Tue, 17 Mar 2026 14:10:55 +0000
Message-ID: <20260317141031.514-3-kalyazin@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com>
In-Reply-To: <20260317141031.514-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 4DBC2180003
X-Stat-Signature: kgszwccz3z3ygxswc39rbxrgwf6kzdoy
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773756658-318808
X-HE-Meta: U2FsdGVkX19dv2JN9wW7+J5Dk2131BcSyCCxrBgT/B3PNKJk6OYJto2QgvUYm6/BHKNlAeuT4zXp+XYu6DFefFDNSYJ3+PCi6/qyVHuvwA7upPlC3Le4siGPJSlHv1k5qBoKfTIU3W8Jpvv5C+D85+I/+YeRu1x6sbKWo/1gbsRyAxUr4iiXTIm9hBDsEo7vL0tQFyrrHl4AE2gWEgSBfbPcI7AQ5kbE3r8j+5RE6JJGiozEwi9UIcXEszLg3+AAsjJdrB0hGNH9eQMRWdxW7308Dgc+KbiPhK0pUReU4G3lEFxjI8oxowhgU9V8SosXxtFi25q+IiFGs/phRKv1c5pnyEws6lHEodq16AvDBtr6W6PZVPPxufcjfggeqCg/L3N9bhbDYbBd6BD1yzRiYVXDthCvF7fvR2vETxjl4LFsEqubT7t3Fgcqi8kzSe3kHPX2hC/Z7+uT3Sp7rBI494CFYf8zC8X+n4TG0vHyJSl9F7pHR7aY8Dov1Ie3VaOAH+TQ+J5R8hyhbOpwenPTrfLrMtPh6yMo6vPr+O0Cb9lq5Ub6JvpL6aAzAFwfAmC9+TJw6Mw7GreYII3h5Kpo7V7GuQI7jhT0QL3gaAq4dkIr1Ol10vhM9Um6dtMSgo7M/1KXQXIQdQMGX+NVKvVYZvLnhyECT8D2zszNlbPFrhmjiK7xNH/4uPQ5sJoMXC4rqhTeXzpcGYTEuaV24MtUrUM0fq+1Tfn/lFdkA1R5nps5xuPU8npY1cMmgliFhxUuDPeVZwfLpDGkVZnCJHE4L/S4oDYYQW0vOg94Sj5/yPidXMXJsPe0NT2MpucMu7aOykR9l84SANcKPoLnsb6pz5il1zQLsjlHNasVQ81vk7yW3uXxQho9mYYYOOjPnSMdd5aYxW6137rlbrffZnzMrCYAUUp4jT3/LIDf+Uxu17kCneI4HLEm3rvR5N9wKUd5npjw14Po/NxdY8QFd/Y
 bt4OsT6T
 BLZjxslTGQEEPNy0DYPceNVds5qAw0W+I0brM6+WjGFPgSq4fClyAM9tEIIjhhVqjBuA7viyvPst7qlq3gGUb7eaP4hY/scwvgIXcUO+PZUC3KDY3iZCA1olKSXn6Tln5IQ4TTKG6eb4PdYV/guRbl8/uop2Gv2hERKgamT4igBhxPt2qd4GJ3xnEfTWSCAmN8fLc9DYSMIdTAW+xgHwoHhCVLe047B+LSbZXiYAJPS4dSrRqKnTQprCu2x72SIFYdPDAgLZYHgN3h8TyxGL+fHuqHhZ0jzAI/4fIvGGZa9BoTcv7oRU7uDDS9kzAFpFKnIaz88djiUmgWjZW8QEnaMJBC66sgvBDsZcbGltaVizicistucwsU257C/kbsPf+WPZmD3WKX3A4faYJmNLQohgUlbakB9HWq6+EI2D3MybayxG5XW5zgYnZulCmWkU25D6nxLdtGzzsd6aBxLWqnW9cQV+xd0bPuVhL9KkCVDCTnjMPEY4Fmvh0g9nLDXGKQEuU26xaHHzAgsxQb7lQujVwoj+WQBUBF5Tf+dh0P1giXSop2cQwUN23Z9MedciNFAmFfzfHSaiN058dFDdzGC9WF6ByCrY2SSj7wvA89ETld1Smp80yiiJtg37KO1bi2+XuuEdIU7KifOiyTh2WEgIugQkawLqBGYCCXwHlTPPmd/7dCeIzD3i+IgQRzUeFAt6GrcLWx/zs4kreoET7YSQ+havUsMS5ohhaQIDAdCj+hv27Y41zzAMoxImSdcdFdY7t7K60gGqdZU9cM5Aoqfrb+M66+k1H9KAaMyL/s37iUWz9KIavT7WiHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>=0A=
=0A=
Let's provide folio_{zap,restore}_direct_map helpers as preparation for=0A=
supporting removal of the direct map for guest_memfd folios.=0A=
In folio_zap_direct_map(), flush TLB to make sure the data is not=0A=
accessible.=0A=
=0A=
The new helpers need to be accessible to KVM on architectures that=0A=
support guest_memfd (x86 and arm64).=0A=
=0A=
Direct map removal gives guest_memfd the same protection that=0A=
memfd_secret does, such as hardening against Spectre-like attacks=0A=
through in-kernel gadgets.=0A=
=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 include/linux/set_memory.h | 13 ++++++++++++=0A=
 mm/memory.c                | 42 ++++++++++++++++++++++++++++++++++++++=0A=
 2 files changed, 55 insertions(+)=0A=
=0A=
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h=0A=
index 1a2563f525fc..24caea2931f9 100644=0A=
--- a/include/linux/set_memory.h=0A=
+++ b/include/linux/set_memory.h=0A=
@@ -41,6 +41,15 @@ static inline int set_direct_map_valid_noflush(const voi=
d *addr,=0A=
 	return 0;=0A=
 }=0A=
 =0A=
+static inline int folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static inline void folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+}=0A=
+=0A=
 static inline bool kernel_page_present(struct page *page)=0A=
 {=0A=
 	return true;=0A=
@@ -57,6 +66,10 @@ static inline bool can_set_direct_map(void)=0A=
 }=0A=
 #define can_set_direct_map can_set_direct_map=0A=
 #endif=0A=
+=0A=
+int folio_zap_direct_map(struct folio *folio);=0A=
+void folio_restore_direct_map(struct folio *folio);=0A=
+=0A=
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */=0A=
 =0A=
 #ifdef CONFIG_X86_64=0A=
diff --git a/mm/memory.c b/mm/memory.c=0A=
index 07778814b4a8..cab6bb237fc0 100644=0A=
--- a/mm/memory.c=0A=
+++ b/mm/memory.c=0A=
@@ -78,6 +78,7 @@=0A=
 #include <linux/sched/sysctl.h>=0A=
 #include <linux/pgalloc.h>=0A=
 #include <linux/uaccess.h>=0A=
+#include <linux/set_memory.h>=0A=
 =0A=
 #include <trace/events/kmem.h>=0A=
 =0A=
@@ -7478,3 +7479,44 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma=
)=0A=
 	if (is_vm_hugetlb_page(vma))=0A=
 		hugetlb_vma_unlock_read(vma);=0A=
 }=0A=
+=0A=
+#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP=0A=
+/**=0A=
+ * folio_zap_direct_map - remove a folio from the kernel direct map=0A=
+ * @folio: folio to remove from the direct map=0A=
+ *=0A=
+ * Removes the folio from the kernel direct map and flushes the TLB.  This=
 may=0A=
+ * require splitting huge pages in the direct map, which can fail due to m=
emory=0A=
+ * allocation.=0A=
+ *=0A=
+ * Return: 0 on success, or a negative error code on failure.=0A=
+ */=0A=
+int folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	const void *addr =3D folio_address(folio);=0A=
+	int ret;=0A=
+=0A=
+	ret =3D set_direct_map_valid_noflush(addr, folio_nr_pages(folio), false);=
=0A=
+	flush_tlb_kernel_range((unsigned long)addr,=0A=
+			       (unsigned long)addr + folio_size(folio));=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+EXPORT_SYMBOL_FOR_MODULES(folio_zap_direct_map, "kvm");=0A=
+=0A=
+/**=0A=
+ * folio_restore_direct_map - restore the kernel direct map entry for a fo=
lio=0A=
+ * @folio: folio whose direct map entry is to be restored=0A=
+ *=0A=
+ * This may only be called after a prior successful folio_zap_direct_map()=
 on=0A=
+ * the same folio.  Because the zap will have already split any huge pages=
 in=0A=
+ * the direct map, restoration here only updates protection bits and canno=
t=0A=
+ * fail.=0A=
+ */=0A=
+void folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+	WARN_ON_ONCE(set_direct_map_valid_noflush(folio_address(folio),=0A=
+						  folio_nr_pages(folio), true));=0A=
+}=0A=
+EXPORT_SYMBOL_FOR_MODULES(folio_restore_direct_map, "kvm");=0A=
+#endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */=0A=
-- =0A=
2.50.1=0A=
=0A=

