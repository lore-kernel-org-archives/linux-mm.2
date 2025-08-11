Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 776C0CA0EC5
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D1E8E0041; Mon, 11 Aug 2025 07:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6CB6B0165; Mon, 11 Aug 2025 07:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F0F8E0041; Mon, 11 Aug 2025 07:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 712136B0163
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:26:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21CE516012E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:55 +0000 (UTC)
X-FDA: 83764249590.13.7BD9EA8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id EDCD8C0005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dw7hYDSn;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJDg4sW92zbLWKqBjb1tVZssT9gBBixv5gdvUlii8Zs=;
	b=6j96uJOmhmtBE0wjiaow7qDgm1wtWwUqCJKGPS2Btob69j6MyVTkrbRsrlI53FPgOgscZZ
	NXJCH2Du+EWUZ29l+oDjMTlKsEtRLnHXKUn3dg4OdYvf4Vt2hzoxc6g5ZxFu1k9/wqFZgW
	7Tdldmfv2cGMtzw6yFhIAdWmOJQ1PFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911613; a=rsa-sha256;
	cv=none;
	b=g5xavQ7u+F4A7c0lOpLmyquNVXTcOs5DWPSXeSfl0fLIOMe1lPad4M0poQsanRSzrgdPQ6
	85+ahvnPdlspgI9206wuq7LfnbJkVVuoxzu8FXeBKQkvBEDDHvnJvCeYdnqc1yARp6/E3Z
	eRJIZJygK9ixSeI3xV1YgWP3A75+k58=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dw7hYDSn;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UJDg4sW92zbLWKqBjb1tVZssT9gBBixv5gdvUlii8Zs=;
	b=Dw7hYDSn4ECdNdnpa6TzGzoX5SH1fo2SKgFssJItHmYvklx91CAYj5o+2ABXjcY/u4gWDD
	d6CQLcHShyJgVUl9k0eMRfsfMmliaFqWdYBFuyf75U07P62r875NBLQI2a1KovrvpTdNHg
	zexyAy+1g/yo9F4j1QYoIm34b+RnVVE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-1aRNdAWONe2yEyaiYACdJA-1; Mon, 11 Aug 2025 07:26:51 -0400
X-MC-Unique: 1aRNdAWONe2yEyaiYACdJA-1
X-Mimecast-MFC-AGG-ID: 1aRNdAWONe2yEyaiYACdJA_1754911610
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b7891afb31so3196134f8f.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911610; x=1755516410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UJDg4sW92zbLWKqBjb1tVZssT9gBBixv5gdvUlii8Zs=;
        b=HSFfwhUSjAi8jRo4MDktnGQESlZDT4FwiJf0e46l/luRWr/pzHO2RTaDa4xMITcw8L
         OwwAgP138ixnrhq4SA3giOy+unc/NTsPOGZ4sdM9aYVzq/maXJHlQKsjseW71sjJMMXu
         DBd0ZvBUux/GtIC+ePw10F6gGiTF9SwA6ZgSEJt+wYBrDtQsRo1yI2SaCUhzDhzxCM9U
         eu+gE3oNnSNXA/ehgKGmJvZI1A3j0bYVsyj4fmXVO9ww1qY2bPixDZriBAPhXbwRLd61
         OBMc7gDAzxqUMh9mgqp2YDw/HHuGSFpuoC/UOVw1tF5vpnZnUF3Yp3P0Tw+cEv9wQeC7
         SSBg==
X-Gm-Message-State: AOJu0Yxz3N2OdwGtUOQ+1akIgdoqsOUVg+C3ZIq1S18Smwl1IntUjDRW
	eAoIKCPzsHZZAbyuKOp/jJKkqs2K51BMJFgeqW1wFSIDI9W9xlbzBYs0vfvNTyctKNUTtvQgoE0
	5GBIaCa3d8n/jcR1tJflyxQOc8+53kKwGVKUMSlh7nfES06sZYgos1qZxx4Sc
X-Gm-Gg: ASbGnct5d/zIs1BZt1krqK4spaCvj6YCdM4rUiqd65fTJM68RPvxJ9APK5JjegAaqcV
	I/3a1RAEUGryBDgYeT7E/e5Lcu8dmLN/s/pt39PabvQrmizSUuDLYKFpFaYUTaEY+0gbg6hCbzk
	Xw5qm6DvPcWSq+AMogVjZE53L67yrKJcimEO5fFDLrdSfhgubZpSOzsFYzpihSqR3znYiGi4QpH
	i5t2m+hWBd33k96woAe+niKU2iY1NcrfIMs47x0xBri23s3D5p2GgUFzxv/8WOaepdbunHaYyfb
	KqCI32WqSOL1k+FXNsVjeNbv+xecgBMpAkBgE8FunCRxfze5heD/UqtRuUU91TIgmwjDbk9Ygkl
	9Rn/+4cCS6EWzhsTpoQiQwZag
X-Received: by 2002:a05:6000:2010:b0:3b7:9d83:5104 with SMTP id ffacd0b85a97d-3b900b83ce4mr10356614f8f.51.1754911610046;
        Mon, 11 Aug 2025 04:26:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH28XXBuV6P4eMmACbygagN9E2w90dcNlvtCQwFebmNkdYsSnJof6QrfGHsOh8VfCIdvok2gg==
X-Received: by 2002:a05:6000:2010:b0:3b7:9d83:5104 with SMTP id ffacd0b85a97d-3b900b83ce4mr10356583f8f.51.1754911609552;
        Mon, 11 Aug 2025 04:26:49 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3bf93dsm40408983f8f.27.2025.08.11.04.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:48 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 06/11] powerpc/ptdump: rename "struct pgtable_level" to "struct ptdump_pglevel"
Date: Mon, 11 Aug 2025 13:26:26 +0200
Message-ID: <20250811112631.759341-7-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XNbKrXtCMm3DvVuAP6BdrMZ_zq0F1BwY5T6E_yqqNDo_1754911610
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: EDCD8C0005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: yy6d6fdniz974ws9yq7tauh68thr8tqo
X-HE-Tag: 1754911612-17206
X-HE-Meta: U2FsdGVkX1/8Z4Hk+gRiD75+06694TJVHrcfi7cnnHGX2AHdiV7RSaG7nVY4+87DDuz+dLzwwxsCLLkyucIbx1Ck3jnS8bEMRhnLOzufwoaDLtSWDwWrZjze7GtBhmmuWa5/am5uRXf5cRBjLZpWNw2vDfqhDoVkw+TD9Z3fq+T0c+uzRc8fj0roMpb+5sV4YZ9ZplSsuqJGymxVI3ojG/n8ApZ4ji70lWBA8AljQNhuc3NJMT5AWhwtn4a6ZquNdy3lg/mW6xe+4cVri2k5gqkQz424nWuwy8K3hECuIEeYSa674KTS/CKkoaP303KzoyKqhW8OYbnFHhd3A0E+U/DlJ3fBT5H4jcbfEg3yFp+D644xruoTt8MRAAWdnLDJIap0n+JVF9wZ1sHdguc3XuGQl92gLvHIJ2ezAsQKBY9CNQO04YPS8LylHMAF3VINJNX2qLrEIQ72GwUIyR+gZTAdOp8NNhBkYwcGNa3/KVw/Tp6vmn30mlsOK7xkky5XMNpNiqp2x5F1EYr90zd4Ky2+FP9Rm2AJsJQjFSFY3L1DkXifR4MleKJGSXFrLqJpWJ9WC0+bQ7mXysp6V8VotXkZYQ3zrSNo6+WHBxa7+Az+77FiagcMZRXqxiHUUO9Q1nlZPIwmKDUG/XkVG9uNnrcoRUocljMr35f7rs4wooJAJ1M0px6xz+EhFh6n9KXJG58Vh6kPGcVV08lBsQQMpDmrewyQ1z9+tMY8H+XgnXyhUIlU0OsssMXP4tdfDXd3pj+uxd8IsLR6Uq5U1ekogljq3YFqc1f4BtNlcO+FAE/gwCQTLom9/nMie8AUQystlYKOikxlFFd1utYeVa39IxrSXi3tFPgcUEsKdsfRGg5yDpoebGY8dy/wYYrtOo80S3XGQHC83Q0wjWnzT8ve2cRJFJvdbfL0Vx4z8AQ055YmYDjdnzu0PvRkTwgLytS0GbO2B+W7lH678xu+jpj
 c6GpdXCM
 SQNzHfHj2ObNpvoISX1/oTjgtKGIsajXG5rkjhEiq71iYu8OcdBsk2ATNgoHKyUhUzqdDVf2lvIS3MTH5Bj/9z3NK5xYnIEHFV5Cj1ZeMvHKelL1SiRTsFuTHw8mbyD4N2AtzB4RXDuLqvSTcQn791su6KvKIFZaHvBMJHLU9JjZ5mQdtJsK655zvP2ro9Wa4yJcJq8c8n9P7TWkgAWF21AsqNYYzxWGS+79pnXmB4RmC0h6ygdkPTJvO218+ot3F2xcudbYi3BI5LE5CzWynNIci4YBFviDdZLj9eNvL7Re5nS229RXQDxCocOPX0NpoAdTsmus26evquhGgzqsOj8J/IijE5Rk0nmL6cDGcUA18Ly6gZl2Pyuzgq3X4G1+z6IqdfXUeieETBQlc3DuwMNiG/e8xCUE4f/lJZqWvgXASvUPUMGcfwAt+cknrzOb8XN/WXkdowcjWLUHZGJvigIiZhqH/T3hXwCx3juGQehOmCGwtAMjaQDBhX5007MBDNXNqtdVUjKXo8pUIx4wiD2P+ee/Z76ZYd6A5ieu/Y7LctsU0LnmiOXQHyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to make use of "pgtable_level" for an enum in core-mm. Other
architectures seem to call "struct pgtable_level" either:
* "struct pg_level" when not exposed in a header (riscv, arm)
* "struct ptdump_pg_level" when expose in a header (arm64)

So let's follow what arm64 does.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/mm/ptdump/8xx.c      | 2 +-
 arch/powerpc/mm/ptdump/book3s64.c | 2 +-
 arch/powerpc/mm/ptdump/ptdump.h   | 4 ++--
 arch/powerpc/mm/ptdump/shared.c   | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/mm/ptdump/8xx.c b/arch/powerpc/mm/ptdump/8xx.c
index b5c79b11ea3c2..4ca9cf7a90c9e 100644
--- a/arch/powerpc/mm/ptdump/8xx.c
+++ b/arch/powerpc/mm/ptdump/8xx.c
@@ -69,7 +69,7 @@ static const struct flag_info flag_array[] = {
 	}
 };
 
-struct pgtable_level pg_level[5] = {
+struct ptdump_pg_level pg_level[5] = {
 	{ /* pgd */
 		.flag	= flag_array,
 		.num	= ARRAY_SIZE(flag_array),
diff --git a/arch/powerpc/mm/ptdump/book3s64.c b/arch/powerpc/mm/ptdump/book3s64.c
index 5ad92d9dc5d10..6b2da9241d4c4 100644
--- a/arch/powerpc/mm/ptdump/book3s64.c
+++ b/arch/powerpc/mm/ptdump/book3s64.c
@@ -102,7 +102,7 @@ static const struct flag_info flag_array[] = {
 	}
 };
 
-struct pgtable_level pg_level[5] = {
+struct ptdump_pg_level pg_level[5] = {
 	{ /* pgd */
 		.flag	= flag_array,
 		.num	= ARRAY_SIZE(flag_array),
diff --git a/arch/powerpc/mm/ptdump/ptdump.h b/arch/powerpc/mm/ptdump/ptdump.h
index 154efae96ae09..4232aa4b57eae 100644
--- a/arch/powerpc/mm/ptdump/ptdump.h
+++ b/arch/powerpc/mm/ptdump/ptdump.h
@@ -11,12 +11,12 @@ struct flag_info {
 	int		shift;
 };
 
-struct pgtable_level {
+struct ptdump_pg_level {
 	const struct flag_info *flag;
 	size_t num;
 	u64 mask;
 };
 
-extern struct pgtable_level pg_level[5];
+extern struct ptdump_pg_level pg_level[5];
 
 void pt_dump_size(struct seq_file *m, unsigned long delta);
diff --git a/arch/powerpc/mm/ptdump/shared.c b/arch/powerpc/mm/ptdump/shared.c
index 39c30c62b7ea7..58998960eb9a4 100644
--- a/arch/powerpc/mm/ptdump/shared.c
+++ b/arch/powerpc/mm/ptdump/shared.c
@@ -67,7 +67,7 @@ static const struct flag_info flag_array[] = {
 	}
 };
 
-struct pgtable_level pg_level[5] = {
+struct ptdump_pg_level pg_level[5] = {
 	{ /* pgd */
 		.flag	= flag_array,
 		.num	= ARRAY_SIZE(flag_array),
-- 
2.50.1


