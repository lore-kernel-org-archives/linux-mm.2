Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7FBFD8770
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260816B009D; Tue, 17 Mar 2026 10:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238C26B009F; Tue, 17 Mar 2026 10:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1283B6B00A0; Tue, 17 Mar 2026 10:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F024B6B009D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:11:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF5CFB5EDA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:52 +0000 (UTC)
X-FDA: 84555743664.26.A3AEDDE
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0DE10140003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=cJJOtyfa;
	spf=pass (imf23.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llJJeOmsrKZhS7S+LBUIVkS0VQiaBAql1AwgjiwVdWQ=;
	b=ppsuoRPGeVjdDr8BjueG0rjGt3ciQ8m9ia95HTm1zS1nuGfzpoofA5BmVKyqQncRuynYV6
	AJXgj8svGDzPxw68UJs+8E5XKSCLqcSmvRODWOm3OnSg2FVGqJ1NPDS/u3UJmWaaYnISqw
	xdhAblYNxEdiqVdwzMClOWWFDo0wq34=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=cJJOtyfa;
	spf=pass (imf23.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756710; a=rsa-sha256;
	cv=none;
	b=ZGJTMCa8DY0/AwCYzEL9dvmUSmyoZ6CqVjBfaw3vMYX0/pzWV5ova83OuDFTcCU8PuFHQ9
	k5lRX9K7i2CD941szKCge3d1mij1wBLshGm/ajCU08c4gR7x4B02SCi0Cl5U1+SeMubi2+
	1Age1TtaGRiIcorEh9XsuMkEaER5bP4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1773756710; x=1805292710;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=llJJeOmsrKZhS7S+LBUIVkS0VQiaBAql1AwgjiwVdWQ=;
  b=cJJOtyfa4heIHJ2SUr232jOVjxCrE45kR5PS16llDnhJKYMpf3dWRkeo
   OLToOIcSnIEmCkK55n0x+JwCiKjG8xkxO2FzNON+CTvpl5OAitOlaOffo
   0QrfYFDsexV8nd8ePC1VErUE/QhQXG8EReGfcCL44+hQP7jpST3obWWeP
   +wLZXAThTOOUAyF86vDhnU/DdcvY1vNEZBG44zGCRdB1rktq/3l7Qp5U5
   xYlCu2OTONj/FzwOGu8ig2rJ2P4WxfM2spI0P+2i+qc0kmb/Ri0hxZDM/
   PNbvkzbESO1HAigSaRndbsgPxPqibHs0ecHlYwZvlfoNYmD1T1m33Nume
   w==;
X-CSE-ConnectionGUID: zruidjxqQia4haOuXf9V+Q==
X-CSE-MsgGUID: aYgMHUxmQry190BDjc+w9A==
X-IronPort-AV: E=Sophos;i="6.23,124,1770595200"; 
   d="scan'208";a="10908907"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 14:11:48 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:24073]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.35.101:2525] with esmtp (Farcaster)
 id 8f6cda6b-e113-4ce3-95b0-f77c086de20c; Tue, 17 Mar 2026 14:11:48 +0000 (UTC)
X-Farcaster-Flow-ID: 8f6cda6b-e113-4ce3-95b0-f77c086de20c
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:11:42 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:11:41 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.037; Tue, 17 Mar 2026 14:11:41 +0000
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
	<kalyazin@amazon.co.uk>, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v11 06/16] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v11 06/16] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcthf6aKtpV6+9UE+MjaWrmt1tyg==
Date: Tue, 17 Mar 2026 14:11:41 +0000
Message-ID: <20260317141031.514-7-kalyazin@amazon.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DE10140003
X-Rspamd-Server: rspam08
X-Stat-Signature: 1qwawojf8ggztd4fjgfsm7k6erwcwttc
X-HE-Tag: 1773756709-934341
X-HE-Meta: U2FsdGVkX18uvsfBqp+J2+NDXYxNcilVn+24TolMEJeH9wkeTebetxWxV9+QXqPd11fbUHAyfHmh+tlBSQzLbStdax0DmzKZTsk7DPnzbRJL6Arj2WWPCQ3olbTLMEZwus5Yx1dlWJ78+EfPAp+1hWKUyccqU+AYJrprZAR2xq1fRqd8KouA4vL02bRi4dPNr1i+lnMw1pk6DbemcDdop4hifBwDB/MtgT46hzz/85EVNUs8P2TmWy65aSIZdQ0S9z+tIE+ugv2pSUniUFko6SYaxv/9CE9IaptDYMdSseP2kE7k5/enL/izqt0yFItl8k4GovmoSe2QbPwY7Po2pVEQDxvaJZ9v6Mh5Cnp3ijp7ADIKNFxy66jSPuv/fpA+fcAP3khpzWO5er3kxrigvBk0PvcbF0RruFWLpP5TYXluesmgO9H9yWLlbCwZy5/Plx+AmowOBzSEQAQxBxzOvQH2js4NKLRR5/Zu8zi++Ni2KBknlaxnmQeQXMx/XzNxAPITI3bmA5KVhytYrf1hnOLC83xgX0VMtdVbCJIeLbEpNQd4Q5/Py1gQV6b0cJRDXl9asMFWHYqKcbNNofcW1i1cTwo8Egp84XpZwDONlcwySMBdthnOBABX9h759nQudvo4LcZPvbjxbc5I5dW9iNT2P3LWCRZTqVjqBwNHi+Ilrk4CXthCvbw3qmWtYB1s5xSZvsjvajxdbJ8pVGWAB+7zaj57JGunt/10SzmldIE3nYL0omvHRv+tDUVw4TiulqxvCrkevDfJrE/i6951Ys43hxd9gL6Q6858DQcOJ76fAsiPlWf4vDWPeURUz2D1TY0PiCUiigChzwPFPv2MbkuoLz+bYPq89oZL029ATQ0ejszMEOa7cLsn8NHbiHEODDBi1Jj3Pat/m17hlX3OzlNOeMIEhxEv7a+ewV6GQXPq3rFRVv9xnWl31XuxuZPlcOmL3+4x2LLyMGkD/Wh
 iHhVSxJh
 Um6TVPWtornvXJb9M4PgB/2CY7Z/+hpffG2eTjhsK0+J4iNfJ5oKVodbvrAntr3YCcX9T6DGNqUL9pj7IuGA10xDbrTaaJwoSUfE280ydIIKU3Eo4Mho3KUVGuYbX5da+OIWtDljSRx4U9FJVc8942ZpX8zQDmPYVGJa3tjrOax1KnQzjXBY2qV+h6eWs5jsP0/Py2PVSIq5OzmW2SEtq97yAvu/PEpKxDFctXyEy2XA7+qSwuj4VKtdnBwKW48SL+GTmi/aQ7zvTusTlew4dqRXTCee5ZhBeUmladNI7iWMcUEEQgG0CgNCKT2Q/F7+jmiodj5GnfdHWj15DQNc/n4AwRRzkbf9mgFNstY9IJFdXSyPs+1c2bsGsL5wvoLC1pl1R4v8lnrzwan2EH0LkcsRK4Ii/euu7aWjXQWimkLICpM5Jd5daFA9z8iaXmwUTdl2VG+en3dY8g48hySDvWy9V5oStIxWRvooOAonUBHTK3jo8xeaXx3Ws20jgQGXeW9WWrMmK3f+/+NjM+zsEP55vlLIvOUGp1DunApL3zGOESjgVo/YBSZUvseUdGoma+eSXcvfzqqutUu/zrHeU8wFcK7+Lz6PWP4tw5Mc4y072DWNZM6mKs+TI5N9X+diapGoJ/vP0feXmQHhQ9TC1be1KzU5+mJ6J8pSBD/wNB3sVvbsJff+pNXJY6XcPKLqSWV8QQQFxPcXX4+NAYN4HDA6exszKZZNxjkOZH80+eCMjXapQTXj2frycGu62digigCH7F0n94sPL6DSJc0zlj+AFiDagk77ed9rsgiEKfySjZatpbRQ8RscUBQ==
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
 lib/buildid.c             |  8 ++++++--=0A=
 mm/gup.c                  |  9 ++++-----=0A=
 mm/mlock.c                |  2 +-=0A=
 mm/secretmem.c            |  8 ++------=0A=
 6 files changed, 29 insertions(+), 32 deletions(-)=0A=
=0A=
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h=0A=
index ec442af3f886..68c075502d91 100644=0A=
--- a/include/linux/pagemap.h=0A=
+++ b/include/linux/pagemap.h=0A=
@@ -211,6 +211,7 @@ enum mapping_flags {=0A=
 	AS_KERNEL_FILE =3D 10,	/* mapping for a fake kernel file that shouldn't=
=0A=
 				   account usage to user cgroups */=0A=
 	AS_NO_DATA_INTEGRITY =3D 11, /* no data integrity guarantees */=0A=
+	AS_NO_DIRECT_MAP =3D 12,	/* Folios in the mapping are not in the direct m=
ap */=0A=
 	/* Bits 16-25 are used for FOLIO_ORDER */=0A=
 	AS_FOLIO_ORDER_BITS =3D 5,=0A=
 	AS_FOLIO_ORDER_MIN =3D 16,=0A=
@@ -356,6 +357,21 @@ static inline bool mapping_no_data_integrity(const str=
uct address_space *mapping=0A=
 	return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);=0A=
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
index c4b737640621..ba79bf28f7e6 100644=0A=
--- a/lib/buildid.c=0A=
+++ b/lib/buildid.c=0A=
@@ -47,6 +47,10 @@ static int freader_get_folio(struct freader *r, loff_t f=
ile_off)=0A=
 =0A=
 	freader_put_folio(r);=0A=
 =0A=
+	/* reject folios without direct map entries (e.g. from memfd_secret() or =
guest_memfd()) */=0A=
+	if (mapping_no_direct_map(r->file->f_mapping))=0A=
+		return -EFAULT;=0A=
+=0A=
 	/* only use page cache lookup - fail if not already cached */=0A=
 	r->folio =3D filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT=
);=0A=
 =0A=
@@ -87,8 +91,8 @@ const void *freader_fetch(struct freader *r, loff_t file_=
off, size_t sz)=0A=
 		return r->data + file_off;=0A=
 	}=0A=
 =0A=
-	/* reject secretmem folios created with memfd_secret() */=0A=
-	if (secretmem_mapping(r->file->f_mapping)) {=0A=
+	/* reject folios without direct map entries (e.g. from memfd_secret() or =
guest_memfd()) */=0A=
+	if (mapping_no_direct_map(r->file->f_mapping)) {=0A=
 		r->err =3D -EFAULT;=0A=
 		return NULL;=0A=
 	}=0A=
diff --git a/mm/gup.c b/mm/gup.c=0A=
index 869d79c8daa4..a5a753da66aa 100644=0A=
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
index 27b176af8fc4..d32e1be1eb35 100644=0A=
--- a/mm/secretmem.c=0A=
+++ b/mm/secretmem.c=0A=
@@ -129,11 +129,6 @@ static int secretmem_mmap_prepare(struct vm_area_desc =
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
@@ -151,7 +146,7 @@ static void secretmem_free_folio(struct folio *folio)=
=0A=
 	folio_zero_segment(folio, 0, folio_size(folio));=0A=
 }=0A=
 =0A=
-const struct address_space_operations secretmem_aops =3D {=0A=
+static const struct address_space_operations secretmem_aops =3D {=0A=
 	.dirty_folio	=3D noop_dirty_folio,=0A=
 	.free_folio	=3D secretmem_free_folio,=0A=
 	.migrate_folio	=3D secretmem_migrate_folio,=0A=
@@ -200,6 +195,7 @@ static struct file *secretmem_file_create(unsigned long=
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

