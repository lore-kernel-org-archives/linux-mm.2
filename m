Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E86D19503
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A062E6B0095; Mon, 26 Jan 2026 11:48:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BCE76B0096; Mon, 26 Jan 2026 11:48:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8956D6B0098; Mon, 26 Jan 2026 11:48:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7BB6B0095
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:48:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B3CE14072E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:48:01 +0000 (UTC)
X-FDA: 84374697162.22.490E899
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf17.hostedemail.com (Postfix) with ESMTP id CE7454000F
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:47:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=lmdoGtbo;
	spf=pass (imf17.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLi/u5ebqRUc1ICzy4nCfhfttKcqfygi8VMYBxy2oh0=;
	b=RdKoHpm9hTDxCbpxiDkVSmIxiGe2Df0KU7hjUvAqM0keHF0Pd1beO+QH//lVGHuyNqI0qb
	P/erIRGKNNQEOi2GKoaSiL3qTDQElO/9rNbjernpzajUpYEq5TZwsAPoTUj+WLhifxKF4C
	/Xsm1aLXgU7wPG4uV/ImFbfDGYULgPo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=lmdoGtbo;
	spf=pass (imf17.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446079; a=rsa-sha256;
	cv=none;
	b=WGRt28GUgzF8b5xUAQ2/zNsyeepiUFp9KFUNa7gd0UIAld9SCHDtg1vEE3jNxjAiVIO5+y
	MeHy+TqsBfOhkkimbNqYNpuC5vIfVcHMwS0gZzmMUJbExn970A+KodFmVqtmsdj3qT3BT8
	o9tCP6T+QfUDyRi4N5Lc8tZA4QxT38A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446078; x=1800982078;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YLi/u5ebqRUc1ICzy4nCfhfttKcqfygi8VMYBxy2oh0=;
  b=lmdoGtbokqt8ibvkJnYmX5+w/1KRSyvGjKCKQ91Yi1VRMOc3Dh/UCTGX
   M1294rDdc/9hdBPTUkXeudn+5fJRm9qoO1bY0RmPWEYz9dwfJacnCCgOZ
   d7+snaLtd4LB5yCG8bS1OKD1RVfBxtT0hgJezd8qPG8ZVjKan5ePv5F2B
   H0brKj5pDeHSTwjZIy1NaxP9kIPP5Og77c+RIYT+Ak0hO9gWNQBov8fZ8
   mMuyFCSh0bUdhxMEaItSXAiIOVVIzrZVXYvrKP6agUE/S6wOMZiYNPilk
   je9vAaVtcclictJBQz/RcXPa4KVNT/myWnfFamoP8icCmMK4bnaBo5J+V
   Q==;
X-CSE-ConnectionGUID: Yypu5wYxS1iHAL5CgyZSpg==
X-CSE-MsgGUID: YXLvk2c5Q/ikyAczP4JXTQ==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8451277"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:47:40 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:28334]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.27.197:2525] with esmtp (Farcaster)
 id 2d375b96-55fb-45b3-87e1-96d636e6af0c; Mon, 26 Jan 2026 16:47:40 +0000 (UTC)
X-Farcaster-Flow-ID: 2d375b96-55fb-45b3-87e1-96d636e6af0c
Received: from EX19D005EUB001.ant.amazon.com (10.252.51.12) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:47:34 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB001.ant.amazon.com (10.252.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:47:34 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:47:34 +0000
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
Subject: [PATCH v10 04/15] mm/gup: drop local variable in
 gup_fast_folio_allowed
Thread-Topic: [PATCH v10 04/15] mm/gup: drop local variable in
 gup_fast_folio_allowed
Thread-Index: AQHcjuN4fOzeQZ4jRUG7KbJA7KTWHg==
Date: Mon, 26 Jan 2026 16:47:34 +0000
Message-ID: <20260126164445.11867-5-kalyazin@amazon.com>
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
X-Stat-Signature: eojy68wh58cd6pkr31uwthmkcghkeixx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CE7454000F
X-HE-Tag: 1769446078-863850
X-HE-Meta: U2FsdGVkX1+klx+sCVxXZQ2K4MLgPjvrt2uQliy5cdSmF4iF5qe9rUa9CNrkXsy3Kbg+5xw0T55l787HMdnFH+/ksZLWtN1WQHSQI6cNnT5CW2ss0xSN9crEHpViXB94ieQs0LpPuBbZviW2UiHivU9dXyv1ZDqBbNKadbeqh9cPY94i890pX+eT+d+kqPYlw0YW6g2J38bS+5qfUL7YUnc6rWX6qhFPVSOkDTsjoez3NkyQVSLOWC2wVxhWRaZGDlyWrIqQpEAaUSTZtG1r9O3PLQZgaSQfClnblcwN5A/QxRRQsljVLzDh296KyRfDNCmlsb9KN/b6lqRl42c5mxfVkKa9HgQwwj1UGM/W6vde46uQciqJW9sTwf6RlHkkcMdKmjCXJ3KzpX9PBUJN4jWJs1ORSMUpigFjhJDS123ivK+0CsL+zjr96SSyY4ugl6Njn59IcmDybnCSq2DC2WnJ415dqsanbgDAIke/tlgwdhZOxcWmZueIzYlWa9VCvpsWXD3aoC5U/IXigd62iugTNKLqcDeiNc2/pP0VagNb+grjQ25oUdgvm2zZvO/a/XeMy/ICIJND2ARq4dic+Dn8J5Rd0TMj68E2WoBvrBQ3sO+xfLstlrOHbLmbNwHZnU+P2elHbTfmvdJMra0H0xGjTS7OOtkLWYcs1FPF/o+9XcUFgr/mq6T1r9XFrGgRlM3LC38d2JxeCjGEED5CrHfMQ40jkFW/hWo2KmRZ4sCCUt7lRqC9B7PJTsreEIffY7Ip4l08vbHljRn6qpMNqf/0TmioxEGMStj5j40c5EUKOhSO1XxtC2s1CYj0dou/JVlJb4DMdABGNgo5mMS2DcZpdANC8yLPgZwy6mV6Bs1YgzJvfpofbJuhq4eP19hRu8kYb/t7x/EWMme8IxG/vosdx1B2GoKYtmIp7mvw+VbhE4mTpSdKwayGrS19ffcKLLBIrhj3bVm83WaYOSo
 2rah/k9L
 HN8DMVDa+mYmQQf+RT1YVjkYl8JVlcDtKJ0pZhvJPS98Vq0FyQMNWQGNJta5CZAWxfJ+F5CXMZm2elUB4oF2J/VPA2blkQThgh3a4NPblzNvaMFMbO4hiH7d8FHGfIOp89wg7DS6pJdAKiKg3UYQw0KsTCvbbkIgiWVGErRHcHHK6PtkbilUfULwbBddo7FuhkkYdmYtQMfKB1WyG0R+g1agncHhsHKI+AH4M1hjY+JKH9t1ENOncgajvPQnRgZR5uDwIY9hazbTj4mIg3PZDYf5NrLNPxnzlEF5U0hJtv9TkSN540p92CQ6Bj1NvahR3BqwluyXm7pX8vFc7gs8hiLoGY1SiQ2VU/KTyKXgjlNuOL/p4eGuls406B7BDODCcXV7/FzJ/ua4U07vPm+JX2FhCGbO8e/eK/+yFn+8kBWy+mod3DihmyUmacj7ZxD5vLU30p5PlZd4BoBVyT5EWF/D5dvVlH7C3pPCozyn6t+oZiQOOqPGBc3yY9vf3HunwDDzMxWF2q7lhqHqcZ7ymLOKlk2lolgV8Shyw5sx8DsEmbhjX7+dSxfTNylSzPNztU8rYez4Zpd6Bqt/l8FQQ1vb4MAPpk4CZ1XyS/9L/M/iJDovTtTWrzZUsXYGCnMVC+uyGkVHZ10cuGXGZUl3EzCarZ6fIgqAJl7gDaiL/YU68jEYX48EAX7PxHTBY/h70goXoZ0HoF86I3Le9oLae8nSdCF9Mj2DVoU5q873u3/lSXwwIX9f97GHcocQZ9PoAtF1tan0SYM9iW2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 mm/gup.c | 19 ++++++++-----------=0A=
 1 file changed, 8 insertions(+), 11 deletions(-)=0A=
=0A=
diff --git a/mm/gup.c b/mm/gup.c=0A=
index 9cad53acbc99..e72dacce3e34 100644=0A=
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
@@ -2793,8 +2784,14 @@ static bool gup_fast_folio_allowed(struct folio *fol=
io, unsigned int flags)=0A=
 	 */=0A=
 	if (secretmem_mapping(mapping))=0A=
 		return false;=0A=
-	/* The only remaining allowed file system is shmem. */=0A=
-	return !reject_file_backed || shmem_mapping(mapping);=0A=
+=0A=
+	/*=0A=
+	 * If we aren't pinning then no problematic write can occur. A long term=
=0A=
+	 * pin is the most egregious case so this is the one we disallow.=0A=
+	 * Also check the only remaining allowed file system - shmem.=0A=
+	 */=0A=
+	return (flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=3D=0A=
+	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE) || shmem_mapping(mapping);=0A=
 }=0A=
 =0A=
 static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start=
,=0A=
-- =0A=
2.50.1=0A=
=0A=

