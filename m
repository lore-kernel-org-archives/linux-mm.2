Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95304CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0C0D6B000D; Fri, 12 Sep 2025 05:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3426B000E; Fri, 12 Sep 2025 05:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABF56B0010; Fri, 12 Sep 2025 05:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C98F86B000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:17:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 77D1686F03
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:46 +0000 (UTC)
X-FDA: 83880045732.12.2A2ADBD
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9B911C0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=oS1A9aQA;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf20.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668664; a=rsa-sha256;
	cv=none;
	b=N0uTD/wClJBKhN3AtS78MGT3Ny9v9vGosHjlTvQXOSjvo/mjd6UWmAQHvFct3UQTME3nwk
	imDKmco61iR8GoJIjrJMZnwMs118yb6T3/hZ6oLAVvnbU/UPlQ9t/hzvwyh11mduk4GsgX
	hHaKJs3jrxxARIXAw4va7VtZUivp2L4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=oS1A9aQA;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf20.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6MGuHLofg/UQ6j3od6DFBlP6h40d9oLh3k2QL5DRKE=;
	b=6BW5INfVQWKptN2bDzMt5eLlp+hHR16PX24Mg8/diChajhR+CgY8JHU3UHD4pKj+aoZW+t
	aAwddI1QzRlVAutnG53VzrfE8n7hTY0yDZv6WENcCkSCTYrCKregpqQ3EH/P4lqPMRtgiA
	McNfPKyohME+5AuHnFFGHKXMq2qgA0c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757668664; x=1789204664;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=L6MGuHLofg/UQ6j3od6DFBlP6h40d9oLh3k2QL5DRKE=;
  b=oS1A9aQA0s5qXdEwYS2xf2esNE+/UOK2uL3UPIQ8GhY89soSISfKlEN9
   74pQWK/FXM0IUnTKvQnh/U1GK5+eoxCc59HvQ5CaEX7zAbJORBCidGsTX
   bmCMLe2zyROrGYTBzuPP2Lx12AG0CBCPpRJGiFHeIZMngeE9RjxJ35J3+
   x4M68qb7kPwFo+gLijQ1PQYNjaLnh6bPm45L4W6WvJV0YtgsXC+0aF9w5
   zCjzapJ7Uhjbgn1vpyTNUioOK+3lHJzGzXz8QAWat/zP4yM057Hww8Xmm
   T/UPws2sppOb8tmuAOWGbCzDwtJPusTMFhx3Nlcg+4T0YEIc4WMdz3fp8
   w==;
X-CSE-ConnectionGUID: cI7j6VGMR7Gv8uvIQ36e9A==
X-CSE-MsgGUID: MCGMwWEZT+SLHHcXUqXwxg==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="2009525"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 09:17:33 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:12545]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.20.211:2525] with esmtp (Farcaster)
 id 01a2f483-7280-4d83-8886-4614fd54f9f9; Fri, 12 Sep 2025 09:17:33 +0000 (UTC)
X-Farcaster-Flow-ID: 01a2f483-7280-4d83-8886-4614fd54f9f9
Received: from EX19D022EUA004.ant.amazon.com (10.252.50.82) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:31 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D022EUA004.ant.amazon.com (10.252.50.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:31 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 12 Sep 2025 09:17:31 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
CC: "Thomson, Jack" <jackabt@amazon.co.uk>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, Elliot Berman
	<quic_eberman@quicinc.com>, "willy@infradead.org" <willy@infradead.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "kernel@xen0n.name"
	<kernel@xen0n.name>, "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "aou@eecs.berkeley.edu"
	<aou@eecs.berkeley.edu>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "gor@linux.ibm.com"
	<gor@linux.ibm.com>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "trondmy@kernel.org" <trondmy@kernel.org>, "anna@kernel.org"
	<anna@kernel.org>, "hubcap@omnibond.com" <hubcap@omnibond.com>,
	"martin@omnibond.com" <martin@omnibond.com>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>,
	"jack@suse.cz" <jack@suse.cz>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>,
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
	"pfalcato@suse.de" <pfalcato@suse.de>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"weixugc@google.com" <weixugc@google.com>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>, "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Roy,
 Patrick" <roypat@amazon.co.uk>
Subject: [PATCH v6 01/11] filemap: Pass address_space mapping to
 ->free_folio()
Thread-Topic: [PATCH v6 01/11] filemap: Pass address_space mapping to
 ->free_folio()
Thread-Index: AQHcI8YRV4VfKNensEyd8J0XmS1q6g==
Date: Fri, 12 Sep 2025 09:17:31 +0000
Message-ID: <20250912091708.17502-2-roypat@amazon.co.uk>
References: <20250912091708.17502-1-roypat@amazon.co.uk>
In-Reply-To: <20250912091708.17502-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9B911C0005
X-Stat-Signature: qiq139nar5zonx5rbpx3a6ndhxk5wmpe
X-Rspam-User: 
X-HE-Tag: 1757668663-210491
X-HE-Meta: U2FsdGVkX18GDeCSk/gzhjHDQ9B0yIOIBYLIMG71fSSjn6FP4SISjdwrNnrFnmcFD4vAiH9eYPa9RWfp5n9qA/J3/SLYtb56LKFPgT8kt7fvBIPMI3Ij8u/Y+NFhK1ecVopbeVhDsuitFruInhJk02HEL7rJRW2Y3J1HKt5qQolrhFS4Rqgn37hITHGIjY6MVS1hHVWeSsz+JMx3rNEBKV60MKjMkbbEySRp4HU1UlueASkKmG8HroRaTwqo9CrrlX/yrTqkaP917ZsmPTWVFAVnlE0VJrTCxfjn+cKZwqFOCS9wH7hrCcyGq8ThWpkVS/wfjw2134GJBrl4Qzi5/ZRxgltppt7xDXpJxjiFOnH/o8ne8u3KdlRKi0fTjuVrR8fd29mPJnwhPbzFtDi6Tb0m7DjEPFnAnYcS9NqH7jLG42DxagPRiSoz0BpB2gHfr2bV7IzaTbFll/vM+09UtUgmKNYu+JMhtCWtbUaPeMmF8JQOj1KnuDR5G/N2hkF9694fuZoJjcMHxXxFo+pxz+5qUwFoYaRszO5hOlufl24zoXS6SDA0HlC+59fJO62zV9Ul67PrYdCvwVjSHK0H3/0m9VS6/8X8shFHbLRg2Ip0qfQKH6hd0l9YpmyXELp3ZUXNCQPsZHehnAGYZOWhuGpX6WO7e/39iM3E1OHqLDR6H/FKuqhcd2lh2XozU8AgCCPaqrzLDDDlaEPnhByf6Mv8eB5XsOwM7oo5kkPTAYu4fBX1TsEaLLLVcHr3p8RwC7KmWCTsoMYUtsEXngLrdufwPwjFOVZLe84AMWfI8WNMtp3fMwZrCOef9OSjsQdPwFEj+Q/nlb4lDze6OTGIu7ehRPhWOoKkPI649ef29OxyideSj+UJv/odgrsJGQrUnjxCsammjY8/OtplgM2Rxju0kmo0oifmy1SMJTInsHssypNQ317rmR02y3P80PVe2M9hIHRR8hee8r0dSlQ
 Ymat+pKV
 +miOF6QKEUmyGeJvoUCYKOZufavuhvxcHncoLevA9fQ+763xewSPj8M49kAlOe9tBNzGuUGE+UN0UOl/SaP3zPzvvsfSgT2Z/fCgR0MmIdQl98eSkhNv2VBSxSkUA5mGqTei9DcZPGWvYtH4yEzWRVMTNLjqqU/gbuExCCNxjdVGaGqQJi7gwUfoQ2HybZANdCyeGnCGMqu9kAr7XreCVvGrIUD1KlWFF43G8ohZ63fFrhEMPjsZyIOQMovUyFMoxMKXF+qYA4IFCKeSRu0CgJ9/wEhVBYhdYLvbvocG+2xZE5MoUNvXdJha3VOszU1Wu5ciN7uHd0pRZ5vR4mNQy0ARxjhfy563QXj5owpG+D62cF19GCPrg7ZXdzQSRN1oOWJh9s/sX6pO2kCNlk7lBsDE3ZFY8g6na90unSvtEENJCNSpClkBmLclrbUOP66eZnrkhT4FWrSHkrIgZGmwqIZANutw+bNGeq3ZHceyJvF42/Vvot6Ue1vpLXtbPe1Qtu8K9bItfkNRxC6iKuaysxGWpYQ8Ozh/5wJvAujl+7aLsxeisnk5UbAyHMssZSiwI1U+OwhXiPTX9eHrSpomAvBLosNJAAFqpLCwu5QHuBf9cyrZeaF1MZMbcCsSq9lWHz0zAQ0JwabgRkRuhQu9E1cOnDuVT1VK3k5LLN8/T2Dgfd4zRhOFhoxcjn9yrNlvxoMscDdVPZCzo6BLzLAvwH5wkLxh0VeQiHD6V5MZ+Tw3/KrqbpEMS9R1eTlH8H2Jy8TwtPHp4Fs7QsCp4JOpQ61Fv+aia0L5KWj1W8A50JJs5qLNbYXIIASRnvF4XeJ44HmlkCpiICsq/6jETPk2103pSEIf9MHQsMoyetnTathFetXehmcBPXTo1eCjdRwiLmjhEDFIAU2P5ULPFFAM8eYmWNSUxXEcX8V4RNeChXUWUQJTYQE3wv+ui17DUYBSPbVnsGK0mzcJBp4E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Elliot Berman <quic_eberman@quicinc.com>=0A=
=0A=
When guest_memfd removes memory from the host kernel's direct map,=0A=
direct map entries must be restored before the memory is freed again. To=0A=
do so, ->free_folio() needs to know whether a gmem folio was direct map=0A=
removed in the first place though. While possible to keep track of this=0A=
information on each individual folio (e.g. via page flags), direct map=0A=
removal is an all-or-nothing property of the entire guest_memfd, so it=0A=
is less error prone to just check the flag stored in the gmem inode's=0A=
private data.  However, by the time ->free_folio() is called,=0A=
folio->mapping might be cleared. To still allow access to the address=0A=
space from which the folio was just removed, pass it in as an additional=0A=
argument to ->free_folio, as the mapping is well-known to all callers.=0A=
=0A=
Link: https://lore.kernel.org/all/15f665b4-2d33-41ca-ac50-fafe24ade32f@redh=
at.com/=0A=
Suggested-by: David Hildenbrand <david@redhat.com>=0A=
Acked-by: David Hildenbrand <david@redhat.com>=0A=
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>=0A=
[patrick: rewrite shortlog for new usecase]=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 Documentation/filesystems/locking.rst |  2 +-=0A=
 fs/nfs/dir.c                          | 11 ++++++-----=0A=
 fs/orangefs/inode.c                   |  3 ++-=0A=
 include/linux/fs.h                    |  2 +-=0A=
 mm/filemap.c                          |  9 +++++----=0A=
 mm/secretmem.c                        |  3 ++-=0A=
 mm/vmscan.c                           |  4 ++--=0A=
 virt/kvm/guest_memfd.c                |  3 ++-=0A=
 8 files changed, 21 insertions(+), 16 deletions(-)=0A=
=0A=
diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesyst=
ems/locking.rst=0A=
index aa287ccdac2f..74c97287ec40 100644=0A=
--- a/Documentation/filesystems/locking.rst=0A=
+++ b/Documentation/filesystems/locking.rst=0A=
@@ -262,7 +262,7 @@ prototypes::=0A=
 	sector_t (*bmap)(struct address_space *, sector_t);=0A=
 	void (*invalidate_folio) (struct folio *, size_t start, size_t len);=0A=
 	bool (*release_folio)(struct folio *, gfp_t);=0A=
-	void (*free_folio)(struct folio *);=0A=
+	void (*free_folio)(struct address_space *, struct folio *);=0A=
 	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);=0A=
 	int (*migrate_folio)(struct address_space *, struct folio *dst,=0A=
 			struct folio *src, enum migrate_mode);=0A=
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c=0A=
index d81217923936..644bd54e052c 100644=0A=
--- a/fs/nfs/dir.c=0A=
+++ b/fs/nfs/dir.c=0A=
@@ -55,7 +55,7 @@ static int nfs_closedir(struct inode *, struct file *);=
=0A=
 static int nfs_readdir(struct file *, struct dir_context *);=0A=
 static int nfs_fsync_dir(struct file *, loff_t, loff_t, int);=0A=
 static loff_t nfs_llseek_dir(struct file *, loff_t, int);=0A=
-static void nfs_readdir_clear_array(struct folio *);=0A=
+static void nfs_readdir_clear_array(struct address_space *, struct folio *=
);=0A=
 static int nfs_do_create(struct inode *dir, struct dentry *dentry,=0A=
 			 umode_t mode, int open_flags);=0A=
 =0A=
@@ -218,7 +218,8 @@ static void nfs_readdir_folio_init_array(struct folio *=
folio, u64 last_cookie,=0A=
 /*=0A=
  * we are freeing strings created by nfs_add_to_readdir_array()=0A=
  */=0A=
-static void nfs_readdir_clear_array(struct folio *folio)=0A=
+static void nfs_readdir_clear_array(struct address_space *mapping,=0A=
+				    struct folio *folio)=0A=
 {=0A=
 	struct nfs_cache_array *array;=0A=
 	unsigned int i;=0A=
@@ -233,7 +234,7 @@ static void nfs_readdir_clear_array(struct folio *folio=
)=0A=
 static void nfs_readdir_folio_reinit_array(struct folio *folio, u64 last_c=
ookie,=0A=
 					   u64 change_attr)=0A=
 {=0A=
-	nfs_readdir_clear_array(folio);=0A=
+	nfs_readdir_clear_array(folio->mapping, folio);=0A=
 	nfs_readdir_folio_init_array(folio, last_cookie, change_attr);=0A=
 }=0A=
 =0A=
@@ -249,7 +250,7 @@ nfs_readdir_folio_array_alloc(u64 last_cookie, gfp_t gf=
p_flags)=0A=
 static void nfs_readdir_folio_array_free(struct folio *folio)=0A=
 {=0A=
 	if (folio) {=0A=
-		nfs_readdir_clear_array(folio);=0A=
+		nfs_readdir_clear_array(folio->mapping, folio);=0A=
 		folio_put(folio);=0A=
 	}=0A=
 }=0A=
@@ -391,7 +392,7 @@ static void nfs_readdir_folio_init_and_validate(struct =
folio *folio, u64 cookie,=0A=
 	if (folio_test_uptodate(folio)) {=0A=
 		if (nfs_readdir_folio_validate(folio, cookie, change_attr))=0A=
 			return;=0A=
-		nfs_readdir_clear_array(folio);=0A=
+		nfs_readdir_clear_array(folio->mapping, folio);=0A=
 	}=0A=
 	nfs_readdir_folio_init_array(folio, cookie, change_attr);=0A=
 	folio_mark_uptodate(folio);=0A=
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c=0A=
index a01400cd41fd..37227ba71593 100644=0A=
--- a/fs/orangefs/inode.c=0A=
+++ b/fs/orangefs/inode.c=0A=
@@ -452,7 +452,8 @@ static bool orangefs_release_folio(struct folio *folio,=
 gfp_t foo)=0A=
 	return !folio_test_private(folio);=0A=
 }=0A=
 =0A=
-static void orangefs_free_folio(struct folio *folio)=0A=
+static void orangefs_free_folio(struct address_space *mapping,=0A=
+				struct folio *folio)=0A=
 {=0A=
 	kfree(folio_detach_private(folio));=0A=
 }=0A=
diff --git a/include/linux/fs.h b/include/linux/fs.h=0A=
index d7ab4f96d705..afb0748ffda6 100644=0A=
--- a/include/linux/fs.h=0A=
+++ b/include/linux/fs.h=0A=
@@ -457,7 +457,7 @@ struct address_space_operations {=0A=
 	sector_t (*bmap)(struct address_space *, sector_t);=0A=
 	void (*invalidate_folio) (struct folio *, size_t offset, size_t len);=0A=
 	bool (*release_folio)(struct folio *, gfp_t);=0A=
-	void (*free_folio)(struct folio *folio);=0A=
+	void (*free_folio)(struct address_space *, struct folio *folio);=0A=
 	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);=0A=
 	/*=0A=
 	 * migrate the contents of a folio to the specified target. If=0A=
diff --git a/mm/filemap.c b/mm/filemap.c=0A=
index 751838ef05e5..3dd8ad922d80 100644=0A=
--- a/mm/filemap.c=0A=
+++ b/mm/filemap.c=0A=
@@ -226,11 +226,11 @@ void __filemap_remove_folio(struct folio *folio, void=
 *shadow)=0A=
 =0A=
 void filemap_free_folio(struct address_space *mapping, struct folio *folio=
)=0A=
 {=0A=
-	void (*free_folio)(struct folio *);=0A=
+	void (*free_folio)(struct address_space *, struct folio *);=0A=
 =0A=
 	free_folio =3D mapping->a_ops->free_folio;=0A=
 	if (free_folio)=0A=
-		free_folio(folio);=0A=
+		free_folio(mapping, folio);=0A=
 =0A=
 	folio_put_refs(folio, folio_nr_pages(folio));=0A=
 }=0A=
@@ -820,7 +820,8 @@ EXPORT_SYMBOL(file_write_and_wait_range);=0A=
 void replace_page_cache_folio(struct folio *old, struct folio *new)=0A=
 {=0A=
 	struct address_space *mapping =3D old->mapping;=0A=
-	void (*free_folio)(struct folio *) =3D mapping->a_ops->free_folio;=0A=
+	void (*free_folio)(struct address_space *, struct folio *) =3D=0A=
+		mapping->a_ops->free_folio;=0A=
 	pgoff_t offset =3D old->index;=0A=
 	XA_STATE(xas, &mapping->i_pages, offset);=0A=
 =0A=
@@ -849,7 +850,7 @@ void replace_page_cache_folio(struct folio *old, struct=
 folio *new)=0A=
 		__lruvec_stat_add_folio(new, NR_SHMEM);=0A=
 	xas_unlock_irq(&xas);=0A=
 	if (free_folio)=0A=
-		free_folio(old);=0A=
+		free_folio(mapping, old);=0A=
 	folio_put(old);=0A=
 }=0A=
 EXPORT_SYMBOL_GPL(replace_page_cache_folio);=0A=
diff --git a/mm/secretmem.c b/mm/secretmem.c=0A=
index 60137305bc20..422dcaa32506 100644=0A=
--- a/mm/secretmem.c=0A=
+++ b/mm/secretmem.c=0A=
@@ -150,7 +150,8 @@ static int secretmem_migrate_folio(struct address_space=
 *mapping,=0A=
 	return -EBUSY;=0A=
 }=0A=
 =0A=
-static void secretmem_free_folio(struct folio *folio)=0A=
+static void secretmem_free_folio(struct address_space *mapping,=0A=
+				 struct folio *folio)=0A=
 {=0A=
 	set_direct_map_default_noflush(folio_page(folio, 0));=0A=
 	folio_zero_segment(folio, 0, folio_size(folio));=0A=
diff --git a/mm/vmscan.c b/mm/vmscan.c=0A=
index a48aec8bfd92..559bd6ac965c 100644=0A=
--- a/mm/vmscan.c=0A=
+++ b/mm/vmscan.c=0A=
@@ -788,7 +788,7 @@ static int __remove_mapping(struct address_space *mappi=
ng, struct folio *folio,=0A=
 		xa_unlock_irq(&mapping->i_pages);=0A=
 		put_swap_folio(folio, swap);=0A=
 	} else {=0A=
-		void (*free_folio)(struct folio *);=0A=
+		void (*free_folio)(struct address_space *, struct folio *);=0A=
 =0A=
 		free_folio =3D mapping->a_ops->free_folio;=0A=
 		/*=0A=
@@ -817,7 +817,7 @@ static int __remove_mapping(struct address_space *mappi=
ng, struct folio *folio,=0A=
 		spin_unlock(&mapping->host->i_lock);=0A=
 =0A=
 		if (free_folio)=0A=
-			free_folio(folio);=0A=
+			free_folio(mapping, folio);=0A=
 	}=0A=
 =0A=
 	return 1;=0A=
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
index 08a6bc7d25b6..9ec4c45e3cf2 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -430,7 +430,8 @@ static int kvm_gmem_error_folio(struct address_space *m=
apping, struct folio *fol=0A=
 }=0A=
 =0A=
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
-static void kvm_gmem_free_folio(struct folio *folio)=0A=
+static void kvm_gmem_free_folio(struct address_space *mapping,=0A=
+				struct folio *folio)=0A=
 {=0A=
 	struct page *page =3D folio_page(folio, 0);=0A=
 	kvm_pfn_t pfn =3D page_to_pfn(page);=0A=
-- =0A=
2.50.1=0A=
=0A=

