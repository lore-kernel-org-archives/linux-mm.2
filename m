Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F8F3FD877B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03DC26B009B; Tue, 17 Mar 2026 10:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0153D6B009D; Tue, 17 Mar 2026 10:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46DB6B009E; Tue, 17 Mar 2026 10:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4F376B009B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:11:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADF0E1B6F2E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:36 +0000 (UTC)
X-FDA: 84555742992.15.DA1C542
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf17.hostedemail.com (Postfix) with ESMTP id 125EC40019
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=nDIrBGSc;
	spf=pass (imf17.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yq/Z/mNNjYHh4gnEoHNSJLkORCM9JDhCuatXRLcv2PA=;
	b=luUVD3Bq+nG66NcU45lUiS/MhJh9aLNRbwRO1ImArXs7Pe7shA1TAC4csN+IK5Xy6byANu
	OhnE1BYA1MFSxBTPQKdBqrABjRhj8CDsXuVXCuRduAV8VOBKFwFe5HjsJ8Ag6KWe3A6trl
	ELNvmbuHd4n9EGwLzJb5tEnZHlAxQZU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=nDIrBGSc;
	spf=pass (imf17.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756694; a=rsa-sha256;
	cv=none;
	b=svtHtuJ0g2ZXTB5aYzwomvGhkcU5EepHTwrjnalDYQ8LtXEXLGuzqwc2bosLyStfJm9xCt
	dJErMO2u1qeuKalDKXWkU1ItECu6aaYWdtsuFUZjJJlGEaF66xFU+IDJnUzctfknu7xuxF
	VHSx/g4Uzun05+vWX0RKB68md5PT3zE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1773756694; x=1805292694;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yq/Z/mNNjYHh4gnEoHNSJLkORCM9JDhCuatXRLcv2PA=;
  b=nDIrBGSccuyX9OTJ6U//EafXn+n2zuHhOEgWKfYpPUUK+vamJwTehws3
   K9kaDJbCQqzUH9jrF/C3z2VIxosE9wscYE7nZFSmwNt57mXIePKusAsf+
   SdzpJndI7S/aLhbJVg5sPR+fvIqjfC+u4Mqd3JwpD8y6+7kl1LwUjcc/E
   rX5ZojWoFgm/Ha4J20A+WnBoOVyz4WT3lTWW/k2jQbjSmlsMXabFU/kKP
   zQpj2U3KHoLQ2pgfqd4vi1K19GbmyQglHW4RWj44yrIBi4KT6nOzSfP/F
   LWOLpcwHdqL9LZo075XcxEsTXRm1Vu9e50oH0dDhj7PIK18ZGbEPvue5y
   Q==;
X-CSE-ConnectionGUID: aH9ubdWDST6jSOpzSPbiCQ==
X-CSE-MsgGUID: r7wP3IKWR+GcRQYSRa2qvA==
X-IronPort-AV: E=Sophos;i="6.23,124,1770595200"; 
   d="scan'208";a="10997942"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 14:11:32 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:2083]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.12.17:2525] with esmtp (Farcaster)
 id 8ba284ac-6fe7-47a6-8347-fb5d3507a06d; Tue, 17 Mar 2026 14:11:31 +0000 (UTC)
X-Farcaster-Flow-ID: 8ba284ac-6fe7-47a6-8347-fb5d3507a06d
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:11:31 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:11:30 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.037; Tue, 17 Mar 2026 14:11:30 +0000
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
Subject: [PATCH v11 05/16] mm/gup: drop local variable in
 gup_fast_folio_allowed
Thread-Topic: [PATCH v11 05/16] mm/gup: drop local variable in
 gup_fast_folio_allowed
Thread-Index: AQHcthfziSFmLyCfmUqH6JhuxYgvLA==
Date: Tue, 17 Mar 2026 14:11:30 +0000
Message-ID: <20260317141031.514-6-kalyazin@amazon.com>
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
X-Stat-Signature: 9ofru9wwegdpbmejra5n8eceypuktxnk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 125EC40019
X-HE-Tag: 1773756693-388799
X-HE-Meta: U2FsdGVkX1+ggyxRsbQeXdxH8PRBgTu4WNuCyZWtH6S6uL/YcYiFrHMLdQzuJZV6AlAzNoE715OcvUEUdD+pmr/POjA91ICp6Za/dzKaK9hIsRA0fRQ8C/PsiUHX2ZPVIJR3S9C12sMDH4XdcN4Paa+teybthjbe42kyz2u8mrRyvWUM3a72ca/YHmQ6po2Kdmodeyn3UJnkNWoP4tdoU5KAIDDi4cP/+dvGQwqPwg9SD+Sg/9m1b0Y+g7PLXK3Ei3NY5Q2NEpFRbXdsZQ3TZyiNC4j9QR3EnHO3jXyeKxSnnT/NCnQx+No3TC5C39LmNomfA8MF5nMk15x3jUfMd6vhBan8jCHlhZKzn5xQ217MP8rbLdaYgOXJ19Im7MX2KSBeh4HO8Yc5GVnhGzauenZMtpE9M77ImyeTV81Suav8x1j9eRSHKhuZsTeh93mgzXztwDGSN74/7Oucx2c0/At8ONSdub6dGFDYzZfuofoVrWQAc5AqFNs56R/RTohF9nicl+hC75ixh9G44O2cRlYRDeLedQUDE8bZgrQuRhP9c5u9Zi45aSFb3XaFv+PuX+VNZc2yh5Z/6phIDFaw3jLFWuZhg+Qg6jD+szAM6xOIgp4YaZNQVOoVDMFb7n59xSjOd45Q04srPVj8m57cMzhSejkyv38UvMRT3sIGPBsHAAa/IbWM+PAv5JF06nnev13NvOej2cp8RRSo8RtiONpa6zpBaIUGc1o6m2yvB1bd6se6wo+4jV/HTkJS8iEBF39CTY9Dm1lddFtBcZWNGl3CuluboHVotZSH1974qAccvmbv/nC357BD8rMF1h88uRm9z3edRNOAGxCsCbboazS0Tx8zu5HYbdaXENBvsD6Uuc2XML6/ds7tdLdLBXnTzgDI/v79cLccfyocUXAscFqAEJ+O5rIg1VNDh2FIQBCiRzQyD5CFWSo33CGwMPouB0h+rgGOklr8ZFYsSJt
 MaB8p1Fm
 OLHbMHwJLRXva+n8T1TEHABKPx/GoWXlrAkAyZEnkYBO//8B5mMkjZWZGrC/OVcr53k22FGTFbQRPlBtMzbH+IEhnOVX82JrRd0AQetFb+ffoqKvAAEZCdfluoUc2fFEWeZKc0tc1Z6TEtGQCdY4xqxwGayazwneQKFXcMVxIrCHw54ASWD1REUHA6ZmwfrOecwDhfeWgolXMNc3INn/jGwvc6X7ke3WhMPL8uNB+ITKkwW0pXXJlusKxr+awPIozLuRYOa/Zu8/sCr2kitUICAZHW7wEMafSlRjM0lTtZYGQGPDga51I2KZT9NW7Qpmn2N9X+VnSY6l4Zriq6BtnxNc/U7B9b65oI5UQpxWsB2el32SA9ea4WvJ60FXBk8X/TkOp87UQXNkk+i/PJfDxrXXgtYpbe4fQdSBxUTvUQsx6Y08d7HYFWB5zELn3E0bue42Td3H2vb4H8FaGHD2zGV6rv/UE+51EwE+oHOtxxG7zHE0+H7PpHbtPQCotBceGaO5+4jfrOeLdUe/RQX+/bBCqSgAwYVqG72D/fUhKhgyW6wjNgnJDOyWEK8UclTeU4qM/LS1j/VCnri6wt+BA2SMmALWhYjhVSKxpyaA7STZL1gQ7/nDEYkkRM1KyWKUXonFPyOxy7xTMcXS84BFXXC/SjYPajcdX+zm6UHXYTPh4TBeq5THEm1lrMBp6S2xmK7Kk2Zk1tvpKCkGxKvyKIasR/0gIaVkP4w9qz+CQLm7n4tojh2mWiiwhZsDejksohddZRmzuD5xV8mk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>=0A=
=0A=
Move the check for pinning closer to where the result is used.=0A=
No functional changes.=0A=
=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 mm/gup.c | 23 ++++++++++++-----------=0A=
 1 file changed, 12 insertions(+), 11 deletions(-)=0A=
=0A=
diff --git a/mm/gup.c b/mm/gup.c=0A=
index 5856d35be385..869d79c8daa4 100644=0A=
--- a/mm/gup.c=0A=
+++ b/mm/gup.c=0A=
@@ -2737,18 +2737,9 @@ EXPORT_SYMBOL(get_user_pages_unlocked);=0A=
  */=0A=
 static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags=
)=0A=
 {=0A=
-	bool reject_file_backed =3D false;=0A=
 	struct address_space *mapping;=0A=
 	unsigned long mapping_flags;=0A=
 =0A=
-	/*=0A=
-	 * If we aren't pinning then no problematic write can occur. A long term=
=0A=
-	 * pin is the most egregious case so this is the one we disallow.=0A=
-	 */=0A=
-	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) =3D=3D=0A=
-	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))=0A=
-		reject_file_backed =3D true;=0A=
-=0A=
 	/* We hold a folio reference, so we can safely access folio fields. */=0A=
 	if (WARN_ON_ONCE(folio_test_slab(folio)))=0A=
 		return false;=0A=
@@ -2793,8 +2784,18 @@ static bool gup_fast_folio_allowed(struct folio *fol=
io, unsigned int flags)=0A=
 	 */=0A=
 	if (secretmem_mapping(mapping))=0A=
 		return false;=0A=
-	/* The only remaining allowed file system is shmem. */=0A=
-	return !reject_file_backed || shmem_mapping(mapping);=0A=
+=0A=
+	/*=0A=
+	 * If we aren't pinning then no problematic write can occur. A writable=
=0A=
+	 * long term pin is the most egregious case, so this is the one we=0A=
+	 * allow only for ...=0A=
+	 */=0A=
+	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=3D=0A=
+	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))=0A=
+		return true;=0A=
+=0A=
+	/* ... hugetlb (which we allowed above already) and shared memory. */=0A=
+	return shmem_mapping(mapping);=0A=
 }=0A=
 =0A=
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL=0A=
-- =0A=
2.50.1=0A=
=0A=

