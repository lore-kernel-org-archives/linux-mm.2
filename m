Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA28ED19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE006B0089; Mon, 26 Jan 2026 11:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595886B0096; Mon, 26 Jan 2026 11:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439466B0099; Mon, 26 Jan 2026 11:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 310C66B0096
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:48:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3CC6BB7F3
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:48:07 +0000 (UTC)
X-FDA: 84374697414.08.55EC16F
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D12BA0006
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:48:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=PeQazHFk;
	spf=pass (imf15.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgJFZCSqrVJt0+BzRZuoe7zAknQmbtr7VpFf6h3CgPg=;
	b=C0f7F4wtJkiPNc23JKFS80OnLMmxWbJHXa+AGkHbUygIQG4CfuszvMuMlwVlx+0yi/m3Bn
	p/yum0fnRPFS9ZSmL0mq+YDRFuwdgQPeUAyB0IuJE1/6qxZwwxdGJk4ZRD5XyBEjXQVEec
	4f9Ap5Xz4z4GwPEvNis9Wgmf9Qlc2Uw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=PeQazHFk;
	spf=pass (imf15.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446085; a=rsa-sha256;
	cv=none;
	b=m6iUgaG6uLxYH8w04r8qavhdFxhPNz2MKTj09n3yj1JkA5Hl8j8uOA3T039pPn0/0F+G0e
	rwi5bm22eiW+IQHgswh49FlecICeBll6NAFGm9nPO8KjDGXGGZLd0DzVj03WD8zG+WqzyY
	hTEPMjtQtJo3dCA9iIXy/lN/bcJ1kLI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446085; x=1800982085;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jgJFZCSqrVJt0+BzRZuoe7zAknQmbtr7VpFf6h3CgPg=;
  b=PeQazHFkZdU5M+PQQDsTgW+WtIDTNb3xYOrvymcf6HMPcC2pQN2kYS1U
   CmW5kxXhbniK2EaNpw7Q5Rfl+E6ccgNDfhhX/w7Cg06/4xYW7meZtiXiP
   DhMVLqxkpqzsl8xYdI0MzlDeRNY4tRBOHCAAimIFnll9JyEazfW4lgftu
   3Syn0M0sRtsBTnok2TpPzqsW355G4GG/W3lQ2Wdi31UfEH+MXRdw/ycTT
   0TASVCby5hY8oJPYAAgDI2j5ts4clC0Md/hke7AIb9h5Nf67YuZh9n9Mu
   4L4muQkEly2+7UDqt2VIEY/mi5n3RFj9szXInK2g+uR+m0d6g9cHqy/GA
   A==;
X-CSE-ConnectionGUID: 68dPJX1DRr+d/k46RLO5KA==
X-CSE-MsgGUID: jyJ+3/s1TzK/o4WNai3wsQ==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8346867"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:47:46 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:15746]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.35.232:2525] with esmtp (Farcaster)
 id d808891c-3d1e-4406-ab18-83b65628f38f; Mon, 26 Jan 2026 16:47:46 +0000 (UTC)
X-Farcaster-Flow-ID: d808891c-3d1e-4406-ab18-83b65628f38f
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:47:46 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB003.ant.amazon.com (10.252.51.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:47:45 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:47:45 +0000
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
Subject: [PATCH v10 05/15] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v10 05/15] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcjuN+wYgyELySR0aXnXlkSze4dg==
Date: Mon, 26 Jan 2026 16:47:45 +0000
Message-ID: <20260126164445.11867-6-kalyazin@amazon.com>
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
X-Stat-Signature: 9w9kkjyptnk7ecrybg7rhk6r1pqy53xu
X-Rspamd-Queue-Id: 2D12BA0006
X-Rspam-User: 
X-HE-Tag: 1769446084-760560
X-HE-Meta: U2FsdGVkX1+q5viz0ZzQaC5P4/nqXtze+GPegkzT48qiFOBzbUxcLMtzdtk6QWys2Lm9KxXnNbwXceSwbO+ODykvkyN9jaXydGSi6UwtV1J7EYGWFt1BubwQDDNef/p4VNIilBLIg+qxc4LB1N7+0n31eBXs9aKulyqj5J6hnPMSmU38D5XlSjMkfa4MpRqQZ3jlNufZ0F/kodKn7rrMWHprOlNhkoatyBKV4znNt0s4IEU1/SzDSTR/J2uMfzo2TpFsr88SlqYA37DAe7NNJ/3wSFEMrCbcYbngqS8pqflkGKEfcbx3ImVT4JNXKIupPKHktFeCD5rACauiF1KVpaapRv7UwXRJF19MsZ8OYpYOx4M7IS7edB+WTg8sZhVps8ZxUKkRwGPBwpTu4tYtlc8YGzvWzUf0U0grkGd/miJit7eDaYZMcB1GusUXWfx1u39uTGL4TyUf88sVl1cLjHonn0y2uPnOOmtUT0ZEuDRyECWOpx8iZBFWe4oLzFMEJvzKc3+fjlWGP+wKqzxJqVkLsYacAJDSZTwMtkccnsEQCxWt1vZGHaNcMi/wQAS3lXrk3+VxeGryu44a6YuihyFukOGEuEgJ4YYRe3PsDarSvBvvhd8ciwPMrunrZvyOQsvvV/590Rcj9QfcsalmhV22mRtfoufy7euslVt73LY/8K9OvLy6ZEV1j4OHlnUx6IMOLBIxrh2jvKwRdBjCybCXhxfZhZPm8w9WQfQK1B6iFvZ6sY55sbO3jfSK/A2WRdSjdM6mPnulAp9Z0k6LRct+xVaMrfE+S58uzPzw6CMMMlCBL1Mw1ExBfgDvA06JmRrdhTMMgiqx6EbaJZHTVOhWzbMUAqOcBZHZugAWYFAdwIIHukaNnuux2F7FPJFCTXLX00vfzFEHw/knxhaqCvQcs8XPACsjXB71+OppnOtUtYBgGKtXJxa/9hiTspOuTMqzeu2Av9Sv3PCc7zf
 MFBDPlHo
 KSCzIo8GTQ2jpYuacHr/4SUABjufHct5BL7kwLsaOMBM2OkWKgrqpvSMzjA27XZFM8wjRoIJy9qg0N1n+Xa2hJUPdybgd7mlBZKrwrCsLPUMRpNR/MeMjWC6cvfP1YUHFu68FIqGsxooBwJAU5TbwZYIcYmqj+hSYBhBYG9vOWvN6ztMN8nlPhEPjnz7fM9z7s2aJ6/kq1NcJtysQnuPsMPN6cRfOl0TkXCHVLjskuRyE+bt0rThy5S24KhVpKaywbBTpoTorGasDm5p/VN3LW1xRnvqr/oFzjf4oRrXbcgQr3XTSBrvyC0y3oro71gzrBiQ82gYhPZUE7YbfJ1JfPAphKummX5r+2RbCBfwgrh7DyyYhDjZxaG/XABDPfNhUVdrmnRUFR/sTpDfBKFiCsoiZHr/G9GHHbRW/FkiFmKHDFCatuv/c9EQDLlkWPD9m6TqZhevvqrYHoVXLXLqpMVi6rrSP4XzURxNVTr7WL6kSa+2xH0cbEtvf9A53k439UmFTCKtwQBGypcF9exJ3eqB65LoJFGUZycWr0o9vHFza51BJlJpVVAlsHnAI56w7t6DwwYNOogaxWhWhK9ajVXaGwQnBzAOREGes+KyXXhO9btj4XDbGwPf0Zb9qAWpdj0klG/K+xh/LTmjlRIUa0fJCiQIUDK1v8dRKvtdvw/kfpPp77yJ47LrQ3DGIqy/QT9ST6c3uInnRUfkFJUgy0IvCgHSZpTV/BQbK6GYHQyx94rKOXFCEGhApokARQxq1b0tB/JDwX/9qv00Th2uUTRStMbsOcqY/G+Qw0pwkcY0QgREIaRN2y/dqeQ==
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
Reviewed-by: Ackerley Tng <ackerleytng@google.com>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 include/linux/pagemap.h   | 16 ++++++++++++++++=0A=
 include/linux/secretmem.h | 18 ------------------=0A=
 lib/buildid.c             |  4 ++--=0A=
 mm/gup.c                  |  9 ++++-----=0A=
 mm/mlock.c                |  2 +-=0A=
 mm/secretmem.c            |  8 ++------=0A=
 6 files changed, 25 insertions(+), 32 deletions(-)=0A=
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
index e72dacce3e34..3d73c00a36d5 100644=0A=
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
@@ -2744,7 +2743,7 @@ static bool gup_fast_folio_allowed(struct folio *foli=
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
@@ -2782,7 +2781,7 @@ static bool gup_fast_folio_allowed(struct folio *foli=
o, unsigned int flags)=0A=
 	 * At this point, we know the mapping is non-null and points to an=0A=
 	 * address_space object.=0A=
 	 */=0A=
-	if (secretmem_mapping(mapping))=0A=
+	if (mapping_no_direct_map(mapping))=0A=
 		return false;=0A=
 =0A=
 	/*=0A=
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
index 4453ae5dcdd4..bfbca0be55e6 100644=0A=
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

