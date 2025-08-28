Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6824C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF07E6B0028; Thu, 28 Aug 2025 05:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1B06B002A; Thu, 28 Aug 2025 05:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6BDE6B002B; Thu, 28 Aug 2025 05:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 966236B0028
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30C32118D8A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:29 +0000 (UTC)
X-FDA: 83825668458.20.3BD97F5
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf18.hostedemail.com (Postfix) with ESMTP id A2B631C0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=EQX9hwot;
	spf=pass (imf18.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6MGuHLofg/UQ6j3od6DFBlP6h40d9oLh3k2QL5DRKE=;
	b=xG6aT0nYhyqO2L5Zwg5Y40tFjFthRZrg2LAqEBFap7m6Agdho8UIAhLZO/BAPLk55gBdlP
	TjHzTIg2XUDvn+h90AcpRP22b0eqzl+gQ+JwPWcfGw3G/5VZl7PqM5IhBeM+XESpRcTX0Q
	9i0gdfW+CMnDXGR3noZ/1kGc8MAgSv4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=EQX9hwot;
	spf=pass (imf18.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373966; a=rsa-sha256;
	cv=none;
	b=m6v9pVbgUynWKYpNTnMN8UEpqO8kHwPzAQTXz2R5ufczslK9cditrUTCpAijT/ZX9sfFEc
	vlEENGeRqgLseYMxdRim2J4PxOLSBlOKQRgbboaKxV+KmVL2sZ2yDfe/FsH4wOeKwby8PE
	mXQV+ZOcU1ux3+UI3XqfPDpoS/ca/JU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373966; x=1787909966;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L6MGuHLofg/UQ6j3od6DFBlP6h40d9oLh3k2QL5DRKE=;
  b=EQX9hwotzFaTTrByFcOju61Qf0Eiy4yvGA8VDdIhj0TWYTQ6NQOW/unN
   8Q/QwJ0rGd9KlZ9+KPUxSA7wsqYtCj7J6tH0iNYbODKJBd1Mm8ArGVrO5
   WCBjx05DCLMGs2HeKVFtphidWxHtSS0MimKVOTL17KxVHpGdYdK/BdfFM
   x7DUClfku7MLiS1AXLAE7SlsNg3Zou0e4AVepI5Femt1H8MoiA+1o0gyA
   DopLjh60n3Ac+1Wa+ZvaLFKVKc01NzbuTpEEoh51AMFrYJH4J0uiBSo3Q
   j/ZcAFzAJUSL3jj8VrEwD/H+FRHHuNuwBqhhK9sAo91RzXNuuzI8gTknz
   A==;
X-CSE-ConnectionGUID: xHLGpQ9EQomHh63vS1uFkA==
X-CSE-MsgGUID: peFr5JATRJ+PESY0Origbw==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1303198"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:16 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:15240]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.43.161:2525] with esmtp (Farcaster)
 id 88d0e6d1-2f79-4aea-8d55-7d6f4981dd7e; Thu, 28 Aug 2025 09:39:16 +0000 (UTC)
X-Farcaster-Flow-ID: 88d0e6d1-2f79-4aea-8d55-7d6f4981dd7e
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:16 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:15 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:15 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: Elliot Berman <quic_eberman@quicinc.com>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, "Roy,
 Patrick" <roypat@amazon.co.uk>
Subject: [PATCH v5 01/12] filemap: Pass address_space mapping to
 ->free_folio()
Thread-Topic: [PATCH v5 01/12] filemap: Pass address_space mapping to
 ->free_folio()
Thread-Index: AQHcF/+eDtAQnAAgHUCJHWFnAQTX+Q==
Date: Thu, 28 Aug 2025 09:39:15 +0000
Message-ID: <20250828093902.2719-2-roypat@amazon.co.uk>
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
X-Rspamd-Queue-Id: A2B631C0007
X-Rspam-User: 
X-Stat-Signature: qcx5sc16o4pfxca7ur9hj9m71nctehzw
X-Rspamd-Server: rspam09
X-HE-Tag: 1756373966-515043
X-HE-Meta: U2FsdGVkX1+lzZsi+g3Z61GKdDiVQIhBYKpaL5GanDT8i1s7OEzSnHrChjRpyzgXgHXGLHxdfmllXhz2XLZu2XR/wMCMF7elQ7Mkx9ZTL8i8TlT3HwEBKQkDpoLbXmpDhph3vXZu6TzsNMK9Swey2rUAtaVEV9d1Mo0Ay1/rrTc5Aec8rJNY0UdrtUoN/Gar8nHQUSZXPxptnqgq3VGnChFgaMxkNlrYydjJ0nwPG46/YCef+sw3ZWvEqJm/lrd1zxEDydsFTloizNYylBvHwTQ9bFq5rZeRyavjfIKls36R/jMXb94qaiPAUaReNaN8yy0HDJUTtmifLBsAdodT1EHRQlnbtCwZt9NRqQgJYvxX4goy8RL8QuPeUJaQihLYTCstjMOMWytGdrfS0nY1bAUf2tGL6zp0ZwGZryjGYB5OONSDt69msn8nJ5yJSZHSNfltRkZk7KKIM9JLSfarL0So2f7uFYiBY8407LKFx9KkBrjYIfzRuhGpPXe6HGVGdKVI707Lt8taYHUX6hMxkwsEbpq9pSzFwtIgZRkC0I18SudoShwvjkQstTFV9frOkpgWs2tpeogCqSycDJUIVWcVYHPS4YV3/bQKAWXvgxWNm4EWYPny1OaBfob6S2rrNfaAdcuHyFHrWap+gHV+wv17/6VKY+QC1GxRQDfQbDDYDg4A/Fe5uJsEb7+SuwZk6RWhE895xHMVEUQFFHfuamJF5agco6DleGaMQX2/RbznyZiPJ8I6dz5GExo81Q53Vl0xaz2JEvecm4ounOKo7BiTT3+wnpk9mhIDrWJh1li8EZX57MhNm9ORSw2SrW08M/1oT+kvcVX7Bf+LPGrObq5taiEYHZBSAua4OYhFC8LOfp4NiSVeVnBja7QP7zxR0EpI5OaOlUI+9INh9wPVOjLRVt014blMHKM/7XqFCFJ1+Yfp4JDNn+jVRea+8cDI4o2IxsP0KOmAkTR09DO
 Nsddz+Ki
 9gc0FMrSXjHx7sUQwwLGwpRKSLIEeMrdmp6S2zWm7Og00r1KLTcY/nUL9GBOr3NzJwvptECmNfFZeMAet31igKbEh9if9SWh/QJnGRcYkunec/GLv6GiWoT2ma1BT52eUeCoeOI1lVEkT3sXW3Oa4+7cqNLjeUwGOv6EVbDpEI0R/vxReCyAJ8trYQ2OhjR4vLDq8pr7qTxZO0uXRd/drV0Hbuav6ZVAFQ+xJdfk/knPnY4Y7TJmN+6pTbDETU0EmPfdosiJBESdiGv1niTucPsEc0YrocsmPN5tEBOQdRtz4kKa0jGbHh3yCHTvcuLz0MBjo6zfEwouMEUmntpAg5h5ZC4RELvB7BPQl+ZYGQGmkHEXzlFxQqqdVnQei07xNooyI0Q7kENznenDzI9E+euHHIag2CoJU7EKPgaCmmkL056j6KB847/iIp8mPWfu/AxegbsFOukItcQZzV6rVGvhg+JtVQ4oiCW4FHPH+cRISc/IzCFqBcWuJ8299zrD3WRpT4k2o+eZ/8JVp/BBZVtrhf7c4bkoDPA6f5vyeHOFh+teKVNmxSkAS0aGitg0Wx2tUuJA/buqVzhODNIRwifuZYU8sdTonGIcNaIZcc7754/ZID51q9bsSN2WyZvph8XnPCOYPIENw8guIH84IEctRkTNY3V17VZksiYi5v6Qsnpwq00rcYOOxpQW9M5wp/ZKjXtJvAW+I4/BodWp0liAdUeqicSOzbUBetp4Abp+GRBk5mFLG2sFjRh1Oco+harXmfnLI+Cg7co2z+0Ik5y1Wu3f5SeHHJbtnhujbcGZ0chL7tEVFLwM5aNU58sBiasRCb7RXJ5gPQhH7hgGAalnnPA==
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

