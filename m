Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880AAD37E33
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2D06B009E; Wed, 14 Jan 2026 08:46:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624FB6B009F; Wed, 14 Jan 2026 08:46:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4F96B00A0; Wed, 14 Jan 2026 08:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36EF56B009E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:46:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 102B01BC7E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:46:17 +0000 (UTC)
X-FDA: 84330693594.28.2CC89F0
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf27.hostedemail.com (Postfix) with ESMTP id 63F964000F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:46:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=EsjUlizt;
	spf=pass (imf27.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5xPeIwvxwceYnISan7bruFGytAE0WaFAg0fT7oZnis=;
	b=JabkMf+SNCTcmxfwhDZ+mZ4ZxXsd2FvbgT7WcnRMfcq2GvxdBAuk6j+tnBY5y2ai/9hWKL
	3Se9zrX4kYWxouHELLAC9Iykx5t0pNpP3s1FvLBrDxchD1rCjSQiXPNvt7pqKVZmMa5HEP
	s3FD5zbP0Q9/lMngZCwdJ07kfMDuN9o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=EsjUlizt;
	spf=pass (imf27.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398374; a=rsa-sha256;
	cv=none;
	b=PjGTZoXTZLBIaCMTgb72W2meY20QJgK2vtVXuvz5kJwr4CBNllRhn+EzB6terTJ0neCzzQ
	um7Pk8VBraT4dXOzvmWDYbqzQBQo32a1lndNyPIsNvB4xoAJiZHKDLkf6nNgVHCWC4WYUR
	zQTr8lEhjWB+RJnobAUAnzGVgqQZsTA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1768398374; x=1799934374;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P5xPeIwvxwceYnISan7bruFGytAE0WaFAg0fT7oZnis=;
  b=EsjUlizt7LGr1jqH01ab3QfQ6zWeG1Wp/eE8ZlPKjIJASHxmoZyIVpXX
   o1tQKi7VLauNb9u16g5unGAlsrZ9LkzoFOT500wNOJ/MzqNFk7JY6gtrS
   ++TCi1AszPrfxeK1Fy2SD1BcTsXjRxAPBD9Q3eHxFL8H9F1nY5reeBJVh
   pvo9FPATn+kwvU0f062dec3CvJOF49SRNM7nJ4VbT3DDYIw8eJvkr9wVO
   +pP8/DgLAPCbBnlopVo8yDT8mM1N1v61le6UI+NxcG6jf75VHQQKMS5HU
   jPljiCCuqgby+zWvnzj5v4syUMKAGItjhmyFfKXIEpeewm5/hYwF+RhuQ
   A==;
X-CSE-ConnectionGUID: qOxv2R7+TsqUHbTFNtCJkg==
X-CSE-MsgGUID: OKMRs3zISxyT8DtwEeYY8A==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7804549"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:45:50 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:3437]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.45.189:2525] with esmtp (Farcaster)
 id 3a6e19d3-d194-4c9a-9a13-610c87456b84; Wed, 14 Jan 2026 13:45:49 +0000 (UTC)
X-Farcaster-Flow-ID: 3a6e19d3-d194-4c9a-9a13-610c87456b84
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:45:47 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:45:46 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Wed, 14 Jan 2026 13:45:46 +0000
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
Subject: [PATCH v9 03/13] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v9 03/13] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHchVwWngo8rPrNFUOAFLSLpXv6DA==
Date: Wed, 14 Jan 2026 13:45:46 +0000
Message-ID: <20260114134510.1835-4-kalyazin@amazon.com>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 63F964000F
X-Stat-Signature: dubbnx5w15wzp47krqthk9geztac5nub
X-HE-Tag: 1768398374-318038
X-HE-Meta: U2FsdGVkX1/c1/T1yJ/WUs1hU146cnfPW9V5gl21rPZh6Y2VBan/LzEVF8JSz0san6XNKEH/37xE4yX3oUr1YQw+cJ9lF0xD+/vvwbu6XRN12rSMg/MEl0EWYl7c4M6R5nGPhqERtsc+VhQBac5BmGj9Uxv2RH0aMDAHmEvGXblZBpQSATlMNKyroUjG2MPPibcGHsR/RfpweVja16but3qYY2a/xkF4+wnrybDjxJDXOPJtSRg5R8IQ6aHIeWdTVXBLvtHxj0aLXg4RYeiceOVN/GXitoh2koJRMrhGc4+k9wNV7/3Mk3peaDVrS5Vv15/SmfcVVh257UtWqo+pPB8CtxBcfM1/lgh+zw+qwq9R6h8wHLBS0TGj30eRQZWk4kdN04KjHrbymc6NmZvxx4+C6SO+gLqhaL8pgDQt//wjY4urh3tOgASD04zcr9B6VDoz/X9M4i8bYIt17B3T8P06dE+bWBf4GpmveS5O8BYvm7uNtStJkdnkRKgNdC3w64TpnJnE4A3KmvyqxQ+ugw+VOyWn0XlnYmK1M7xqoDUGsY0G6VcnZr/C9PuMllo8E7KGsjSCIlwD1P6Y/htntw6XMVAdjRRv6U0h6uoLxNA7Xfo7x+ftyJgxc7jWCMTTj2/h8Dw2+19XzV0FfbLyNNOi87jiUrBbijNB+yH1VvqMupcGGddq6l8duqhvE48paxJ4Sv07tfso3vewgDWiroPwwOSXctLPaMG/3EqexMwQAkaV/ZaiStKg+5gxcnwZDMkC2SWcHGHAxNShdV5rxcdXHmmDtHsYej71Bj8TN0A/m2aFJeiq7QZegTBgXcWhLDcgPuDxbAQvUCrumegMIe4Fqtb8Id9RWjoTCp3etk0qlRp7p5LiR2LJszzZtjEovVsx+eTDRKc/q+abPqwKVB/u2zUTROq8+yx/VkTwriYH6UwkMhF/2D8xzIlnvVMixFnjwMZ7OInfPF5Y9MA
 9mMuON8L
 JPwyuMZyu38i//NrPYJr4Ph0Na7r4cTo+8wD1Q/mtxUjK3PjK0GwALK/jI3NtXDyuH+OVZJQ4Qh70ix0K2Mf4D1NYrw5uon+l9WalJUSScjqfyl2V7nogOvubDE/4UkB6gVwIx+fj55rEy5Qmfv/QyuUtc8vvvCyxFkYrWaIyFTDHa6Jg+Dbbktojh+8jNXs0hQTc1vbVP9uL2yndqQDXdIoUTpOduakirmVHh/EPPmibIJgYSipU3cEdvAHgd/6vJ3paXKN84xDFYIkekP6Q3C5FdZHz4hw4PtvoYWamI+1Kz/gJUl0UMXgr4WkTtK/apG2WpwmvpSWZuaBCzNSKcy7OuXf9gFvUyTKlpDSVdHmVATZbXTu9H3+N+yfVkri8HoMNh66azWAerP/C/LhdujyaXIiOxNLA818LfCdCSl7hwJFroAa8zF8Z648jHGK9V8gfbG+SlxOVYy94WD5jA4KE8hcfkS8TMnvp6PZ+Ie7otrZSLpUW+RtmTIvm/kaxcRPm7Q2y8c/jrQwXU+3lwHfufWnWfS65bmRjfXsYQVUH99b8wbi+OoP7p8ZVv/VcT1LzPBhrtHwt1DshyYNzMvWqaTgqCNcQ8NPANriTPxk897fPunfvYMvTaiSgxxN9cY9YSABRXO4GddzmNtnrD9VAbz5XdSyIsShOfO+bPlxZq0pQr/UJJ9lxHqTChsAtBfylL4H5LNGysAlcpvNvijxTJbuDuVZQCFwuL+YY1zoX5n7Ny1bRlfVLhgWXrU9OWu0I+FldCTA6mbqvUwSZF8xkwAezZn3qV9Ul
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are=0A=
set to not present. Currently, mappings that match this description are=0A=
secretmem mappings (memfd_secret()). Later, some guest_memfd=0A=
configurations will also fall into this category.=0A=
=0A=
Reject this new type of mappings in all locations that currently reject=0A=
secretmem mappings, on the assumption that if secretmem mappings are=0A=
rejected somewhere, it is precisely because of an inability to deal with=0A=
folios without direct map entries, and then make memfd_secret() use=0A=
AS_NO_DIRECT_MAP on its address_space to drop its special=0A=
vma_is_secretmem()/secretmem_mapping() checks.=0A=
=0A=
Use a new flag instead of overloading AS_INACCESSIBLE (which is already=0A=
set by guest_memfd) because not all guest_memfd mappings will end up=0A=
being direct map removed (e.g. in pKVM setups, parts of guest_memfd that=0A=
can be mapped to userspace should also be GUP-able, and generally not=0A=
have restrictions on who can access it).=0A=
=0A=
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>=0A=
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Acked-by: Vlastimil Babka <vbabka@suse.cz>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 include/linux/pagemap.h   | 16 ++++++++++++++++=0A=
 include/linux/secretmem.h | 18 ------------------=0A=
 lib/buildid.c             |  4 ++--=0A=
 mm/gup.c                  | 10 +++++-----=0A=
 mm/mlock.c                |  2 +-=0A=
 mm/secretmem.c            |  8 ++------=0A=
 6 files changed, 26 insertions(+), 32 deletions(-)=0A=
=0A=
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h=0A=
index 31a848485ad9..6ce7301d474a 100644=0A=
--- a/include/linux/pagemap.h=0A=
+++ b/include/linux/pagemap.h=0A=
@@ -210,6 +210,7 @@ enum mapping_flags {=0A=
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,=0A=
 	AS_KERNEL_FILE =3D 10,	/* mapping for a fake kernel file that shouldn't=
=0A=
 				   account usage to user cgroups */=0A=
+	AS_NO_DIRECT_MAP =3D 11,	/* Folios in the mapping are not in the direct m=
ap */=0A=
 	/* Bits 16-25 are used for FOLIO_ORDER */=0A=
 	AS_FOLIO_ORDER_BITS =3D 5,=0A=
 	AS_FOLIO_ORDER_MIN =3D 16,=0A=
@@ -345,6 +346,21 @@ static inline bool mapping_writeback_may_deadlock_on_r=
eclaim(const struct addres=0A=
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);=
=0A=
 }=0A=
 =0A=
+static inline void mapping_set_no_direct_map(struct address_space *mapping=
)=0A=
+{=0A=
+	set_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
+}=0A=
+=0A=
+static inline bool mapping_no_direct_map(const struct address_space *mappi=
ng)=0A=
+{=0A=
+	return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
+}=0A=
+=0A=
+static inline bool vma_has_no_direct_map(const struct vm_area_struct *vma)=
=0A=
+{=0A=
+	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);=0A=
+}=0A=
+=0A=
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)=
=0A=
 {=0A=
 	return mapping->gfp_mask;=0A=
diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h=0A=
index e918f96881f5..0ae1fb057b3d 100644=0A=
--- a/include/linux/secretmem.h=0A=
+++ b/include/linux/secretmem.h=0A=
@@ -4,28 +4,10 @@=0A=
 =0A=
 #ifdef CONFIG_SECRETMEM=0A=
 =0A=
-extern const struct address_space_operations secretmem_aops;=0A=
-=0A=
-static inline bool secretmem_mapping(struct address_space *mapping)=0A=
-{=0A=
-	return mapping->a_ops =3D=3D &secretmem_aops;=0A=
-}=0A=
-=0A=
-bool vma_is_secretmem(struct vm_area_struct *vma);=0A=
 bool secretmem_active(void);=0A=
 =0A=
 #else=0A=
 =0A=
-static inline bool vma_is_secretmem(struct vm_area_struct *vma)=0A=
-{=0A=
-	return false;=0A=
-}=0A=
-=0A=
-static inline bool secretmem_mapping(struct address_space *mapping)=0A=
-{=0A=
-	return false;=0A=
-}=0A=
-=0A=
 static inline bool secretmem_active(void)=0A=
 {=0A=
 	return false;=0A=
diff --git a/lib/buildid.c b/lib/buildid.c=0A=
index aaf61dfc0919..b78fe5797e9c 100644=0A=
--- a/lib/buildid.c=0A=
+++ b/lib/buildid.c=0A=
@@ -46,8 +46,8 @@ static int freader_get_folio(struct freader *r, loff_t fi=
le_off)=0A=
 =0A=
 	freader_put_folio(r);=0A=
 =0A=
-	/* reject secretmem folios created with memfd_secret() */=0A=
-	if (secretmem_mapping(r->file->f_mapping))=0A=
+	/* reject folios without direct map entries (e.g. from memfd_secret() or =
guest_memfd()) */=0A=
+	if (mapping_no_direct_map(r->file->f_mapping))=0A=
 		return -EFAULT;=0A=
 =0A=
 	r->folio =3D filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT=
);=0A=
diff --git a/mm/gup.c b/mm/gup.c=0A=
index 9cad53acbc99..11461a54b3ae 100644=0A=
--- a/mm/gup.c=0A=
+++ b/mm/gup.c=0A=
@@ -11,7 +11,6 @@=0A=
 #include <linux/rmap.h>=0A=
 #include <linux/swap.h>=0A=
 #include <linux/swapops.h>=0A=
-#include <linux/secretmem.h>=0A=
 =0A=
 #include <linux/sched/signal.h>=0A=
 #include <linux/rwsem.h>=0A=
@@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_struct *vma=
, unsigned long gup_flags)=0A=
 	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))=0A=
 		return -EOPNOTSUPP;=0A=
 =0A=
-	if (vma_is_secretmem(vma))=0A=
+	if (vma_has_no_direct_map(vma))=0A=
 		return -EFAULT;=0A=
 =0A=
 	if (write) {=0A=
@@ -2724,7 +2723,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);=0A=
  * This call assumes the caller has pinned the folio, that the lowest page=
 table=0A=
  * level still points to this folio, and that interrupts have been disable=
d.=0A=
  *=0A=
- * GUP-fast must reject all secretmem folios.=0A=
+ * GUP-fast must reject all folios without direct map entries (such as sec=
retmem).=0A=
  *=0A=
  * Writing to pinned file-backed dirty tracked folios is inherently proble=
matic=0A=
  * (see comment describing the writable_file_mapping_allowed() function). =
We=0A=
@@ -2753,7 +2752,7 @@ static bool gup_fast_folio_allowed(struct folio *foli=
o, unsigned int flags)=0A=
 	if (WARN_ON_ONCE(folio_test_slab(folio)))=0A=
 		return false;=0A=
 =0A=
-	/* hugetlb neither requires dirty-tracking nor can be secretmem. */=0A=
+	/* hugetlb neither requires dirty-tracking nor can be without direct map.=
 */=0A=
 	if (folio_test_hugetlb(folio))=0A=
 		return true;=0A=
 =0A=
@@ -2791,8 +2790,9 @@ static bool gup_fast_folio_allowed(struct folio *foli=
o, unsigned int flags)=0A=
 	 * At this point, we know the mapping is non-null and points to an=0A=
 	 * address_space object.=0A=
 	 */=0A=
-	if (secretmem_mapping(mapping))=0A=
+	if (mapping_no_direct_map(mapping))=0A=
 		return false;=0A=
+=0A=
 	/* The only remaining allowed file system is shmem. */=0A=
 	return !reject_file_backed || shmem_mapping(mapping);=0A=
 }=0A=
diff --git a/mm/mlock.c b/mm/mlock.c=0A=
index 2f699c3497a5..a6f4b3df4f3f 100644=0A=
--- a/mm/mlock.c=0A=
+++ b/mm/mlock.c=0A=
@@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,=0A=
 =0A=
 	if (newflags =3D=3D oldflags || (oldflags & VM_SPECIAL) ||=0A=
 	    is_vm_hugetlb_page(vma) || vma =3D=3D get_gate_vma(current->mm) ||=0A=
-	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE)=
)=0A=
+	    vma_is_dax(vma) || vma_has_no_direct_map(vma) || (oldflags & VM_DROPP=
ABLE))=0A=
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */=0A=
 		goto out;=0A=
 =0A=
diff --git a/mm/secretmem.c b/mm/secretmem.c=0A=
index edf111e0a1bb..560cdbe1fe5d 100644=0A=
--- a/mm/secretmem.c=0A=
+++ b/mm/secretmem.c=0A=
@@ -134,11 +134,6 @@ static int secretmem_mmap_prepare(struct vm_area_desc =
*desc)=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-bool vma_is_secretmem(struct vm_area_struct *vma)=0A=
-{=0A=
-	return vma->vm_ops =3D=3D &secretmem_vm_ops;=0A=
-}=0A=
-=0A=
 static const struct file_operations secretmem_fops =3D {=0A=
 	.release	=3D secretmem_release,=0A=
 	.mmap_prepare	=3D secretmem_mmap_prepare,=0A=
@@ -156,7 +151,7 @@ static void secretmem_free_folio(struct folio *folio)=
=0A=
 	folio_zero_segment(folio, 0, folio_size(folio));=0A=
 }=0A=
 =0A=
-const struct address_space_operations secretmem_aops =3D {=0A=
+static const struct address_space_operations secretmem_aops =3D {=0A=
 	.dirty_folio	=3D noop_dirty_folio,=0A=
 	.free_folio	=3D secretmem_free_folio,=0A=
 	.migrate_folio	=3D secretmem_migrate_folio,=0A=
@@ -205,6 +200,7 @@ static struct file *secretmem_file_create(unsigned long=
 flags)=0A=
 =0A=
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);=0A=
 	mapping_set_unevictable(inode->i_mapping);=0A=
+	mapping_set_no_direct_map(inode->i_mapping);=0A=
 =0A=
 	inode->i_op =3D &secretmem_iops;=0A=
 	inode->i_mapping->a_ops =3D &secretmem_aops;=0A=
-- =0A=
2.50.1=0A=
=0A=

