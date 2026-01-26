Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69DDCD19503
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9C86B00A2; Mon, 26 Jan 2026 11:51:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C949A6B00A3; Mon, 26 Jan 2026 11:51:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4BC66B00A4; Mon, 26 Jan 2026 11:51:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F97E6B00A2
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:51:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BC3E16030A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:51:07 +0000 (UTC)
X-FDA: 84374704974.04.A9352B5
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf25.hostedemail.com (Postfix) with ESMTP id D147FA0006
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:51:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=hboE2wAw;
	spf=pass (imf25.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWGOx1LJU1Lp2rVsMU/Gh8xhbQtWU2hA9WJ9kcqa2lY=;
	b=j32KKS4VaOJjoFdT0r3oFUMwfy6GXfOrnZlUp1S7aR3bQKGtZT4hVftKXJnB05wQ5Zgsh4
	qzPZB+gLThtFtC7+90KCQ/rihwLaJAxpkctlZfv0dtGC1ARzL+aqtTPXBAQhCE+rVc1YbI
	FbwHvEmDxDdaR5IsmdZ/Hgls1Msc0cA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=hboE2wAw;
	spf=pass (imf25.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446265; a=rsa-sha256;
	cv=none;
	b=ZHy0t4ipA5p8Leq46ZIvz/azAitdCwrQNgqSAMzIS/vw/IIN6GAObEvTSJrfc+iBFyDIyb
	ocwsDsGTmliBdwG+3WP04aE8kOJg8W4sOnfkPoOXH4nXJiLikFYJmtNGOFPNLOX4Vcgs/t
	ma3A1o9SbksCWfbRMHDa648r5YmZNfU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446264; x=1800982264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CWGOx1LJU1Lp2rVsMU/Gh8xhbQtWU2hA9WJ9kcqa2lY=;
  b=hboE2wAwJKndIWyaftXPY42IwmWnd/lMyttlZGA6pRQQNGW7B5we2CxK
   f2jP24M1I09/GZDQVyfWA89xNOlra9f2U/GnSooMfgufAGCCxJeBRuFlN
   UET4hAZ+iFvJccc5y4Kp2U3AHgnoH7wi8+rEhZp1wHN/Yb5NolFobbNME
   TA8iyK1uHjDR81E+EaUWkqUSzsAh3S6k3F8ww6uXh0P8Alf5NtItNLAgx
   gEJ35Dss5eBSTzP6GbiFFs5IEnNun5G04Na67jMO91KpXCsSWQCoL/x4o
   nt9Kt6ZNd/4er6uudqbOOqrw3j2uszU/3C/g0zfoss8xSDlABZwW7/PlB
   w==;
X-CSE-ConnectionGUID: OTPDPd+WRq6SnWkJKAJ4vQ==
X-CSE-MsgGUID: WBzqhBMjTtmhVyyuALB2qA==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8355925"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:50:46 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:6441]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.13.191:2525] with esmtp (Farcaster)
 id 11366de5-e0f8-4887-8ca6-1fe533487262; Mon, 26 Jan 2026 16:50:46 +0000 (UTC)
X-Farcaster-Flow-ID: 11366de5-e0f8-4887-8ca6-1fe533487262
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:50:44 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB003.ant.amazon.com (10.252.51.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:50:44 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:50:44 +0000
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
Subject: [PATCH v10 10/15] KVM: selftests: load elf via bounce buffer
Thread-Topic: [PATCH v10 10/15] KVM: selftests: load elf via bounce buffer
Thread-Index: AQHcjuPpjxdWuZs0h0+r9kXLDgvviw==
Date: Mon, 26 Jan 2026 16:50:44 +0000
Message-ID: <20260126164445.11867-11-kalyazin@amazon.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D147FA0006
X-Stat-Signature: rhiczqk8rrs11ruxbozou8a5ktderqdh
X-Rspam-User: 
X-HE-Tag: 1769446264-974659
X-HE-Meta: U2FsdGVkX1+01I2WqnVhbyKSV4pzLfM8aGDvD7AelBEm68zuO7YPo+jYSEr5ncZTljaV2vGoiZerlqSTFyA2UFfG4iEC1/xKAAk91K41X+Uwimp4Ed2uOcc1592ZV12a4ouCb7o/G7PDKL+SZD5G82Ell55Ue0xYWDzBfbcUzFsvcjl/sN1o8DBJU1f9iYe3y/e0ygcJRFReTfCaNAE7KO5EkQqktyUdJc0fEzBtsBCNsRb7mJ1t5244zZbcWvPGLyVIXabu9zCyPkuOGz0PFLF0lvQcQN6u8P3TgeNXW+re+5uZHDes7cbCkqw/p3eMJu8bkQUQiroB1asWP4jCOv+hb3yhGOhTzhxPMOkYk6f8VWbGeXLnZKVaoFoHanh9NZRkDNMSFThb7Ng059P4w4OYTF/OC3bQcpSuXFaTHUGx0gCYTvhO6SaD7pwLI8HzmepzipBm9vMBbQUBLTbyRzCUpQ/ClBBzUL8blz4r/4hRQMoC09lQhL+KpzyqfiYwmItTBk7A3mP2T2Z7Xjxa6MA+olKjbzau0x06o2IkLQw7zEQmWn8iVnT9domIOy6iUSUEYyFKsEttWzOeTG1I8tzbVWQDZnVU94+J3lvCanYeUvkve/gzsPCrVL21UAfVnSllfGMglESsU6lJQHKt7ulv8HMGUCOvxDPh8A+5OwoXqh1O90KRuPyoLwTUvhKKfke5CYxPtyENNkwT2vV1IOIOXnOQiiOj2t20wNUtD3v/V8jU/8z/rpTqVW7QZiWlXlhQgilaCsx2hw2Sy30it0kbNlJ2rIC3iIsZZseYN9GYjVXFulaNHgUalWKqIFiUsVKNgmyuAT10+AbXslNWfMa9hhpbcVNoizou9j1UGmjNM530rQRrcKrSx1+L0D3T7n952GJ+a1irZTjYibn7CJ/h4ljZXLi/qL4yJK3lC29MC8iLnU3FxkZ2zux7vVX1bwuCtpWdzFFIbAYtII+
 OQAcVwVG
 wEKYI0NF/bEKV+kpMHIfgZ5m6+/xqZKbpZuyBtViSS/+U3JfyLjT5ssGGz4OYLHlWwd7usC9Z50rximK8UwJ+6IPDNSZrFeSq4JNoZAzG3C7CP8wyDF8Wp1CS1HJj0lhnScq3vrJZtmdIDHEgS98SYbKWEVHfQbln2JAoeSzUBwHSIAsiQSsa8lLJGt+d9Djq85t0MnvoU+E/VDecc2BCF/9pqY2bz7C6BUAsBsPywd6yKnpX0sRS/6Qi097mPPrWeJrq4lEfeYhcfFG9ewLGdK/JjAsB9HOOAwVbV2bjxBfNb1SVX61BLF/SL1HeyoJWOosBcLfjbgrH1dP4G1SjSogwEzsBM9YIaOOWWoPvOuvNDjhYOI9Z1iO5suZuaCFLAineawEo5UkXqRYHo9mqyH3yenw76XC7Ms8ppaQGwA6D6KyWv46Yii6Iyask8a6Sm8VBXcNqXsg/0ZHkq2dZfHlKCzK6lblQosA51ZUn+g1BXt2Gv+T6PQvhCrzhlgAbnMkpLmrpuidKIYLd3Jhoxo0TWQUbjqhz3KN4EeJ5pDpmS4fe4NbbiTIwlqLUKrP6QFfY/61FGcBMK7fJ/VHPxS4IikOcMZsLGS6ACxyJdtXd/xZlQhot3zUBNBmmZQ1KOMkBJWVXgWPHXBfWc995VtgC8ta0aB6VDlzJevWxqzQ19Vg8OeX93LKbCj4RN6ZNegdOhXY7E8y7v10sVczZJ+Jbcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
If guest memory is backed using a VMA that does not allow GUP (e.g. a=0A=
userspace mapping of guest_memfd when the fd was allocated using=0A=
GUEST_MEMFD_FLAG_NO_DIRECT_MAP), then directly loading the test ELF=0A=
binary into it via read(2) potentially does not work. To nevertheless=0A=
support loading binaries in this cases, do the read(2) syscall using a=0A=
bounce buffer, and then memcpy from the bounce buffer into guest memory.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 .../testing/selftests/kvm/include/test_util.h |  1 +=0A=
 tools/testing/selftests/kvm/lib/elf.c         |  8 +++----=0A=
 tools/testing/selftests/kvm/lib/io.c          | 23 +++++++++++++++++++=0A=
 3 files changed, 28 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testin=
g/selftests/kvm/include/test_util.h=0A=
index b4872ba8ed12..8140e59b59e5 100644=0A=
--- a/tools/testing/selftests/kvm/include/test_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/test_util.h=0A=
@@ -48,6 +48,7 @@ do {								\=0A=
 =0A=
 ssize_t test_write(int fd, const void *buf, size_t count);=0A=
 ssize_t test_read(int fd, void *buf, size_t count);=0A=
+ssize_t test_read_bounce(int fd, void *buf, size_t count);=0A=
 int test_seq_read(const char *path, char **bufp, size_t *sizep);=0A=
 =0A=
 void __printf(5, 6) test_assert(bool exp, const char *exp_str,=0A=
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftest=
s/kvm/lib/elf.c=0A=
index f34d926d9735..e829fbe0a11e 100644=0A=
--- a/tools/testing/selftests/kvm/lib/elf.c=0A=
+++ b/tools/testing/selftests/kvm/lib/elf.c=0A=
@@ -31,7 +31,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *=
hdrp)=0A=
 	 * the real size of the ELF header.=0A=
 	 */=0A=
 	unsigned char ident[EI_NIDENT];=0A=
-	test_read(fd, ident, sizeof(ident));=0A=
+	test_read_bounce(fd, ident, sizeof(ident));=0A=
 	TEST_ASSERT((ident[EI_MAG0] =3D=3D ELFMAG0) && (ident[EI_MAG1] =3D=3D ELF=
MAG1)=0A=
 		&& (ident[EI_MAG2] =3D=3D ELFMAG2) && (ident[EI_MAG3] =3D=3D ELFMAG3),=
=0A=
 		"ELF MAGIC Mismatch,\n"=0A=
@@ -79,7 +79,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *=
hdrp)=0A=
 	offset_rv =3D lseek(fd, 0, SEEK_SET);=0A=
 	TEST_ASSERT(offset_rv =3D=3D 0, "Seek to ELF header failed,\n"=0A=
 		"  rv: %zi expected: %i", offset_rv, 0);=0A=
-	test_read(fd, hdrp, sizeof(*hdrp));=0A=
+	test_read_bounce(fd, hdrp, sizeof(*hdrp));=0A=
 	TEST_ASSERT(hdrp->e_phentsize =3D=3D sizeof(Elf64_Phdr),=0A=
 		"Unexpected physical header size,\n"=0A=
 		"  hdrp->e_phentsize: %x\n"=0A=
@@ -146,7 +146,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *fil=
ename)=0A=
 =0A=
 		/* Read in the program header. */=0A=
 		Elf64_Phdr phdr;=0A=
-		test_read(fd, &phdr, sizeof(phdr));=0A=
+		test_read_bounce(fd, &phdr, sizeof(phdr));=0A=
 =0A=
 		/* Skip if this header doesn't describe a loadable segment. */=0A=
 		if (phdr.p_type !=3D PT_LOAD)=0A=
@@ -187,7 +187,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *fil=
ename)=0A=
 				"  expected: 0x%jx",=0A=
 				n1, errno, (intmax_t) offset_rv,=0A=
 				(intmax_t) phdr.p_offset);=0A=
-			test_read(fd, addr_gva2hva(vm, phdr.p_vaddr),=0A=
+			test_read_bounce(fd, addr_gva2hva(vm, phdr.p_vaddr),=0A=
 				phdr.p_filesz);=0A=
 		}=0A=
 	}=0A=
diff --git a/tools/testing/selftests/kvm/lib/io.c b/tools/testing/selftests=
/kvm/lib/io.c=0A=
index fedb2a741f0b..74419becc8bc 100644=0A=
--- a/tools/testing/selftests/kvm/lib/io.c=0A=
+++ b/tools/testing/selftests/kvm/lib/io.c=0A=
@@ -155,3 +155,26 @@ ssize_t test_read(int fd, void *buf, size_t count)=0A=
 =0A=
 	return num_read;=0A=
 }=0A=
+=0A=
+/* Test read via intermediary buffer=0A=
+ *=0A=
+ * Same as test_read, except read(2)s happen into a bounce buffer that is =
memcpy'd=0A=
+ * to buf. For use with buffers that cannot be GUP'd (e.g. guest_memfd VMA=
s if=0A=
+ * guest_memfd was created with GUEST_MEMFD_FLAG_NO_DIRECT_MAP).=0A=
+ */=0A=
+ssize_t test_read_bounce(int fd, void *buf, size_t count)=0A=
+{=0A=
+	void *bounce_buffer;=0A=
+	ssize_t num_read;=0A=
+=0A=
+	TEST_ASSERT(count >=3D 0, "Unexpected count, count: %li", count);=0A=
+=0A=
+	bounce_buffer =3D malloc(count);=0A=
+	TEST_ASSERT(bounce_buffer !=3D NULL, "Failed to allocate bounce buffer");=
=0A=
+=0A=
+	num_read =3D test_read(fd, bounce_buffer, count);=0A=
+	memcpy(buf, bounce_buffer, num_read);=0A=
+	free(bounce_buffer);=0A=
+=0A=
+	return num_read;=0A=
+}=0A=
-- =0A=
2.50.1=0A=
=0A=

