Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD712C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77926B002A; Thu, 28 Aug 2025 05:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28276B002B; Thu, 28 Aug 2025 05:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D172A6B002C; Thu, 28 Aug 2025 05:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B86F46B002A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43B33160A85
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:33 +0000 (UTC)
X-FDA: 83825668626.02.58A9C5C
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf14.hostedemail.com (Postfix) with ESMTP id B46C8100005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=mk1wmxTx;
	spf=pass (imf14.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5VklHf5PkKOeHc3XbWZdqiBA2iS3Z+Xopt/Sp9JBKU=;
	b=cbzL0OUOirwBnAfwKFxIyYp7FPkpMlaaef6/zP6qviCX5drnw+Gm1JS4mWhSNpx1ssmLi8
	sU7z1ecs72nbahtRPQeaHtFDefRI4wFAtIIuang69Qr4z64bOHaqMF7t2IvIWMgddsAMJu
	VlMV5WRDQT9ZYl5OKNhYbx7iws2mIv8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=mk1wmxTx;
	spf=pass (imf14.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373971; a=rsa-sha256;
	cv=none;
	b=cuXzWNm6RL8gZFB2S490hCbJeKjOYERtqHvxNDZmpBXxGiIk4xX4ci3kRUivt0mNdFdpMx
	pUxVSzGEwjfA96JSQw68gkOLcDtzNl/RIImqbm16OvSs5bEFMYGpE2PoBBJDWCZ1L2o3SY
	iOp035EGdA5QoXem1bX+q1+KdOqV1E0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373970; x=1787909970;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D5VklHf5PkKOeHc3XbWZdqiBA2iS3Z+Xopt/Sp9JBKU=;
  b=mk1wmxTxOjW79I1gShAp8yA4sNbzWONO4CFUmNdOAN92+ESf9495DoTG
   ukKgsTD4NQoy3uufk7wEP6v4lT2XNnOOJVIM6T5+wCeN68rxlU562f84/
   4f5G6cJHpABv/MvvYHpFX1M0TlrwCSTOwymj3H2+0qtxOernS/uf8X8zr
   JMXLSK299yN4SLlvRo4oewc+T2dLHfU0miT/eqlFSSxt8tfq39OyAZSrm
   Y+D9BvcsJ2xpuw3NzfEoap12i3pGwwDnHaPAfYnolk4JJJYHzBFoKKpt1
   CxPWyDc/1VVQKdHyeskokMGJAeBeoTC8RPwemrACjR9U2NAmIYtesmmwX
   Q==;
X-CSE-ConnectionGUID: cA3IF88hTGCu0u49d8dObw==
X-CSE-MsgGUID: 7fRD7oY2TsW077CwD8M2/g==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1303833"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:21 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:30440]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.7.27:2525] with esmtp (Farcaster)
 id 9f22d498-02a7-409a-8efe-63ea39f9f7b4; Thu, 28 Aug 2025 09:39:20 +0000 (UTC)
X-Farcaster-Flow-ID: 9f22d498-02a7-409a-8efe-63ea39f9f7b4
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:19 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:19 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:19 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcF/+gv6cY7v7RYk6q9eokpxVTew==
Date: Thu, 28 Aug 2025 09:39:19 +0000
Message-ID: <20250828093902.2719-4-roypat@amazon.co.uk>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: B46C8100005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: izt9n3ydjesrdm7e5cqwnnryn91m4xdf
X-HE-Tag: 1756373970-184321
X-HE-Meta: U2FsdGVkX185ojSPfGfeNaG4k1y5TlnQwt78JnWCcewFIJDt5jb45DuIJB9c7IuV9lTxmJIzQaG9wY9OJdokvk+QFPDzeYuWW+825qv+ETAFgtNLe5eSO6ezchZA/jedRDnseNeAnwJSMZPyMYq9o2WrYE3vKT5DKPEptytBt0NyvB5tcVtzxLPjG8Q0gQCMvs2Fl1DEu/WsSPZ1D2dDWd2r/X3aeQwiezaanNSjolpZ2Nr1YtBeI4Hy/UdIy14rfqVKFUI0sGlKn1afB5STmpJoLX4PKXvFqY8QmJOpZtKx4Xx5TcqtaTOKym7AXCc2Ah/jf6G32kYOZ7TEMDOHaKnWr1gnNdEzBZ8A7pDJV5erUxOG+/CG6g3G4dRFcKuVepPTfksUcTgzl89BduZ6acxe0smG4ytYgHLgIVndgHtEz8mlj5Q19JAf3WEWmmKxe+SLG3pVqjsDyf13pTeL9jAK2Xp/SVIxJXp2o3JTTnND3mePiNiz/YuOFTm4hzp8/DIdwtaIYMdteUL19yzRBOfPkoFXf0lPhQnWjfe5CTjsQDQh84t4MG7cykYC75VluT5gXo/B1i7PNapsmEOdptu8/wOqrdxpEZLWa3pvq6l5vBIJ//lgLnlsP9wGFlrrpARu9Jx6BFZuXrj5+FCPUvO7hB8qLH/BIT4QFEOF5o7eCg6ziafeFVygavHBYclAH4G32/iZYD6NL6/56bwegqohA+Gw/QjUk5GM/8O8xhwiSGwR6Wu6XB3cCTVIAoj6eVdBDXnUFXuNDgqd/TB7xsR4svFIVNf7hmUaCc+gWOJ0hZp8nCu0Z00hok7wAOGeVYJmJCqXJ96c2s7xj3JZPW+C+A/5e+9mKPECliFgYTiko7KoQiHHbgVkO/s/oHu6vKGWlmNqgsJBiVxPSKjB/uZNawzIqtrwDakcK9Aq0cPz7DgPvdx9mOMmzgar03/tN0URMkVsi78tyoz+wqO
 yEx0zgj4
 PGn0At30ef0qVlJFFtbZzNqhad/0rqdrcjIRLwnIT1XSP/xjE9CfgkQGWOUhRLj14s7S5hjJuq2Eeh6s8W15hz2d4MTxGa0jOJC34w8kVM0u1Tc/zNnyN63mZAliUGRR74lu2JV/wfRxOgAch7H2vP89zxlko2ZOWFXbQnYMdSVihmlsT+2sjmLf7QNaTOp8gK80FCgG6uCY4Hj7sHAUm7MjbFXirDQ/KjM2ObhrlbNKLm0SHDv70748EUTDQ5N17tKfNbOabE57Uek0DElWVkfVfYFt8Jhno+iZQrbXpN4o9Oow+0bnVxJRLa7LAljGd9qrWyjOU7GFvuKxYi1IHneKQAb0tKyCLcx5eHJG8o9Z+KKW5C/ohO/aAIOpdDHZ3yASCmDbSX6B5lktX/MknM5ALud6NQECmghe166jXjxqaMG54Wz1F3mIFGejCZcMSnpIxYxAfVDKb49gxLzHEIZO7/PNFImVgtqhJ8Gl3utUDv2WpQxeuzkbtc4ZvteC131NRAog5yb0Odun5KZOUjlqjHhKDNygaBUYlFieGpV/RZ6goXWTuq+FFhYK/IHrVoCtU5+KIv2MiyRWsezvMMhMxlALpzRtWQwLmU1D/WhUug7L9eTlxtVfWeAUeOFITwPjrBbFxTP3CqUgRHcdlr0fOowjM7wvj95DwtuO2CA7iNJ+JgU3y/z0d0RCy4jnEnyic1GU53w6eBsmSeUxvvtR8cRywuwYuxYwC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are=0A=
set to not present . Currently, mappings that match this description are=0A=
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
This drops a optimization in gup_fast_folio_allowed() where=0A=
secretmem_mapping() was only called if CONFIG_SECRETMEM=3Dy. secretmem is=
=0A=
enabled by default since commit b758fe6df50d ("mm/secretmem: make it on=0A=
by default"), so the secretmem check did not actually end up elided in=0A=
most cases anymore anyway.=0A=
=0A=
Use a new flag instead of overloading AS_INACCESSIBLE (which is already=0A=
set by guest_memfd) because not all guest_memfd mappings will end up=0A=
being direct map removed (e.g. in pKVM setups, parts of guest_memfd that=0A=
can be mapped to userspace should also be GUP-able, and generally not=0A=
have restrictions on who can access it).=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 include/linux/pagemap.h   | 16 ++++++++++++++++=0A=
 include/linux/secretmem.h | 18 ------------------=0A=
 lib/buildid.c             |  4 ++--=0A=
 mm/gup.c                  | 14 +++-----------=0A=
 mm/mlock.c                |  2 +-=0A=
 mm/secretmem.c            |  6 +-----=0A=
 6 files changed, 23 insertions(+), 37 deletions(-)=0A=
=0A=
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h=0A=
index 12a12dae727d..b52b28ae4636 100644=0A=
--- a/include/linux/pagemap.h=0A=
+++ b/include/linux/pagemap.h=0A=
@@ -211,6 +211,7 @@ enum mapping_flags {=0A=
 				   folio contents */=0A=
 	AS_INACCESSIBLE =3D 8,	/* Do not attempt direct R/W access to the mapping=
 */=0A=
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,=0A=
+	AS_NO_DIRECT_MAP =3D 10,	/* Folios in the mapping are not in the direct m=
ap */=0A=
 	/* Bits 16-25 are used for FOLIO_ORDER */=0A=
 	AS_FOLIO_ORDER_BITS =3D 5,=0A=
 	AS_FOLIO_ORDER_MIN =3D 16,=0A=
@@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_r=
eclaim(struct address_spac=0A=
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
+static inline bool mapping_no_direct_map(struct address_space *mapping)=0A=
+{=0A=
+	return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
+}=0A=
+=0A=
+static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)=
=0A=
+{=0A=
+	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);=0A=
+}=0A=
+=0A=
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)=0A=
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
index c4b0f376fb34..33f173a607ad 100644=0A=
--- a/lib/buildid.c=0A=
+++ b/lib/buildid.c=0A=
@@ -65,8 +65,8 @@ static int freader_get_folio(struct freader *r, loff_t fi=
le_off)=0A=
 =0A=
 	freader_put_folio(r);=0A=
 =0A=
-	/* reject secretmem folios created with memfd_secret() */=0A=
-	if (secretmem_mapping(r->file->f_mapping))=0A=
+	/* reject secretmem folios created with memfd_secret() or guest_memfd() *=
/=0A=
+	if (mapping_no_direct_map(r->file->f_mapping))=0A=
 		return -EFAULT;=0A=
 =0A=
 	r->folio =3D filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT=
);=0A=
diff --git a/mm/gup.c b/mm/gup.c=0A=
index adffe663594d..8c988e076e5d 100644=0A=
--- a/mm/gup.c=0A=
+++ b/mm/gup.c=0A=
@@ -1234,7 +1234,7 @@ static int check_vma_flags(struct vm_area_struct *vma=
, unsigned long gup_flags)=0A=
 	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))=0A=
 		return -EOPNOTSUPP;=0A=
 =0A=
-	if (vma_is_secretmem(vma))=0A=
+	if (vma_is_no_direct_map(vma))=0A=
 		return -EFAULT;=0A=
 =0A=
 	if (write) {=0A=
@@ -2751,7 +2751,6 @@ static bool gup_fast_folio_allowed(struct folio *foli=
o, unsigned int flags)=0A=
 {=0A=
 	bool reject_file_backed =3D false;=0A=
 	struct address_space *mapping;=0A=
-	bool check_secretmem =3D false;=0A=
 	unsigned long mapping_flags;=0A=
 =0A=
 	/*=0A=
@@ -2763,14 +2762,6 @@ static bool gup_fast_folio_allowed(struct folio *fol=
io, unsigned int flags)=0A=
 		reject_file_backed =3D true;=0A=
 =0A=
 	/* We hold a folio reference, so we can safely access folio fields. */=0A=
-=0A=
-	/* secretmem folios are always order-0 folios. */=0A=
-	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))=0A=
-		check_secretmem =3D true;=0A=
-=0A=
-	if (!reject_file_backed && !check_secretmem)=0A=
-		return true;=0A=
-=0A=
 	if (WARN_ON_ONCE(folio_test_slab(folio)))=0A=
 		return false;=0A=
 =0A=
@@ -2812,8 +2803,9 @@ static bool gup_fast_folio_allowed(struct folio *foli=
o, unsigned int flags)=0A=
 	 * At this point, we know the mapping is non-null and points to an=0A=
 	 * address_space object.=0A=
 	 */=0A=
-	if (check_secretmem && secretmem_mapping(mapping))=0A=
+	if (mapping_no_direct_map(mapping))=0A=
 		return false;=0A=
+=0A=
 	/* The only remaining allowed file system is shmem. */=0A=
 	return !reject_file_backed || shmem_mapping(mapping);=0A=
 }=0A=
diff --git a/mm/mlock.c b/mm/mlock.c=0A=
index a1d93ad33c6d..0def453fe881 100644=0A=
--- a/mm/mlock.c=0A=
+++ b/mm/mlock.c=0A=
@@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,=0A=
 =0A=
 	if (newflags =3D=3D oldflags || (oldflags & VM_SPECIAL) ||=0A=
 	    is_vm_hugetlb_page(vma) || vma =3D=3D get_gate_vma(current->mm) ||=0A=
-	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE)=
)=0A=
+	    vma_is_dax(vma) || vma_is_no_direct_map(vma) || (oldflags & VM_DROPPA=
BLE))=0A=
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */=0A=
 		goto out;=0A=
 =0A=
diff --git a/mm/secretmem.c b/mm/secretmem.c=0A=
index 422dcaa32506..a2daee0e63a5 100644=0A=
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
@@ -206,6 +201,7 @@ static struct file *secretmem_file_create(unsigned long=
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

