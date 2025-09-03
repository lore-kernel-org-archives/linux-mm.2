Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D299FCA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 05:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04AAA6B0007; Wed,  3 Sep 2025 01:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021EB6B0008; Wed,  3 Sep 2025 01:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79DF6B000C; Wed,  3 Sep 2025 01:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D72976B0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:23:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6102285CC8
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:23:48 +0000 (UTC)
X-FDA: 83846796936.18.C377DA2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id C57131C0009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:23:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CPWbebEH
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756877026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qRjLV1qt7qnMoxu1/nhjb2dUbiJeayY0vDYRf8D713I=;
	b=FvZEF0K7tWA+BtsQ6jyGBorLa6MtEFs2mCenZzZB+4JT4l1y2cRMjQ7FHTUAj2RYVEUgxN
	5LadFJkT26tdsB3ELWjVbu7OuBpM5AsdVk599qLOdXD8M5XN4BN3rRImxk9MehHsK4db1I
	ohdAI4vw6DHZ5v0/+tdwIoFucMCVTsc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756877026; a=rsa-sha256;
	cv=none;
	b=D4XFImXZt1DxvPPSrz1eIOREQGOCHLRAfBXw73rH38U+c5/0uaCG2+i0GUHFmqdpBA9869
	DWK1z1bvThbQTIFZEfJ01y4K50JxApNyf42c3rKQeiC8+T4q3D8cY4e0/Ppsym9PMu3GKh
	JsOdbAFuVYYl2uAM5kZ2slOWKIg71Co=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CPWbebEH;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qRjLV1qt7qnMoxu1/nhjb2dUbiJeayY0vDYRf8D713I=; b=CPWbebEHKF9oA7dtV1pPY8+ssE
	rMa0Oe2pKL5USXsh3LSxYi5dw25BB/epmf6WmJiZ+PQif+QvY+Qvr7rKPgehnnlFEUIC4qttwi1Z2
	vPGWLg7xA04Inx3B/833lFi6Vo1WDWK3hgXd4RbEG9nmfMPVvQVkPWZkw0MIf9+WIF+OQqvf30FTm
	YKFXONn5IgAcEc6xXi1T5MWWkrupDe+VsB8abbc8LnS78tO1AxxlqQW5gyV1oCeH/5Xcu7koXKyu+
	ENqJR8fsSPoTNy1bsGkAHlC8ZUjYwXF7sxyivrPvgi9lJc61Lipl5klwCQUlQyn2Zbq76K6pe7WI8
	AE/4W52g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utfyA-0000000Fhub-0mQW;
	Wed, 03 Sep 2025 05:23:42 +0000
Date: Wed, 3 Sep 2025 06:23:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH 07/22] slab: Remove folio references from __ksize()
Message-ID: <aLfQ3UdoiZc9HKyS@casper.infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-8-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829154728.3397606-8-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C57131C0009
X-Stat-Signature: gtnxcshaqiibfiwmrym8imbo55qky5xy
X-HE-Tag: 1756877026-128833
X-HE-Meta: U2FsdGVkX19/NqLyf4SxfW2e5mkhjwVqFz9vA1DTapJE5sAqmS3Coj9sqQpiz0qpWQxzLuTkqZDcY5jfRI/r6eumre2sD/M9goey6/h1LVqpEuR97TFIA2DDOmOoLNXCDrvz9Xezeh+aTSfjXrM3F+3+zscrSL6bXKmaVA8/08rVR27hdoOIGE+dkJ46ZiSJRvtFKuLyZ9JgWC2KXZ8thB8MhGcsF5WXlZtKprwqsTZhMRdIdQha2W7+sgihWGtloaQGPCz/KyeX6pnC07hHFi4BE/71HnHf1Gx2Dger5fJAoqhpPyED794RKsfVatDGrvEYIG/Pa5EtGObTO/J5UaRd9FM06rtxBqno5DAbAdx8p7e6XmRyf4hbPuTxLHgmxBPEgnivA7fAIQ/qt6BEyoN8Lt7Ra4LSBXxGJ7DDg6m8v/JHaM+G8GVyjlomzedqSEKKAJxhEGn2hjuJ+d8KPjfCIOCkV2+M4ZUDY7CY3t5BvIySObWt4edqahF1NM7lahNAu5In4YzYZK4yuWf3fQXIuJtu7RV1SJoTeZviBe12cluDw6HNENpL+9n7yWQ2COKJV5fyprQMihHlybw5AoC9MKoBdBqx45Z358buRMygyv/w8/sOF4WTgcTFvTjODmbvYcJC1/QJR1jeDXuUsjzuO5xFXuUk/YOuq2SlkkgVyomZyBR5Dm9AsJEESsKdiKVZmW+XqvwqIO1/pCaxNVKTiECvHrRIJBBrPl8gJDOgdeDCPH9k8uVewOVbyoCOp2MQ1r8Py3VWMftYw3gkvAKecRj2kHbgUHhOBV7kCQ6SI7Vbzqqms8xr4kSeyrt/0dusyufcYP/y+61G8hv3ubYPPKRnbxGlCOgTnMgJo5E1HlT/RzK2P0iCQo8ieKFjhghAiizpqhI/BW8SuEWRz1UblV5lIKsBPROUA5u+VHthre+q3BTepyBzgvcO1nZYgHbLkXUKAxdJww/lfB7
 sTCvyj3M
 7JV42UXkD1XB0gwlm1UNXHiGWF4+OjB6+eN3tcPd375u8CDZAhr7m2JV31o00zlsRcfCsrKIre0a7SqLoNZWo2ddUoYcT4AoHG5Z1OPqhZNSOlYiImjMvd10hHvundNalVC47edes/arQWEKXljfFiFG91tZ7ALNRBUa5ovI2PHDfXRErj7RfrEL+Hduq/OmAKqNwYMxnRPu1VONhS5h6vws+IRtU7mZ9lxDA9S+0onRpCtdgR7/kRlpVj6r2ZCGrk2JfDBWW4/UyEKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 04:47:11PM +0100, Matthew Wilcox (Oracle) wrote:
> This deprecates calling ksize() on memory allocated by alloc_pages().
> Today it becomes a warning and support will be removed entirely in
> the future.

We can't do this.  At least not without fixing x509:

https://lore.kernel.org/all/202509022248.dbe9cc08-lkp@intel.com/

The important bit:

[ 33.279697][ T1] WARNING: mm/slab_common.c:1016 at __ksize+0xf2/0x120, CPU#0: swapper/0/1
[ 33.341827][ T1] kfree_sensitive (mm/slab_common.c:1234)
[ 33.343783][ T1] mpi_free (lib/crypto/mpi/mpiutil.c:?)
[ 33.345494][ T1] rsa_enc (crypto/rsa.c:62)
[ 33.347230][ T1] rsassa_pkcs1_verify (include/linux/crypto.h:383 crypto/rsassa-pkcs1.c:256)
[ 33.349482][ T1] public_key_verify_signature (crypto/asymmetric_keys/public_key.c:432)
[ 33.352192][ T1] ? __kmalloc_noprof (include/linux/kernel.h:?)
[ 33.354454][ T1] ? asymmetric_key_generate_id (crypto/asymmetric_keys/asymmetric_type.c:147)
[ 33.357247][ T1] x509_check_for_self_signed (crypto/asymmetric_keys/x509_public_key.c:126)
[ 33.359744][ T1] x509_cert_parse (crypto/asymmetric_keys/x509_cert_parser.c:130)
[ 33.361690][ T1] x509_key_preparse (crypto/asymmetric_keys/x509_public_key.c:157)
[ 33.368645][ T1] asymmetric_key_preparse (crypto/asymmetric_keys/asymmetric_type.c:409)
[ 33.371160][ T1] __key_create_or_update (security/keys/key.c:858)
[ 33.373639][ T1] key_create_or_update (security/keys/key.c:1021)
[ 33.376003][ T1] x509_load_certificate_list (crypto/asymmetric_keys/x509_loader.c:31)
[ 33.378485][ T1] ? load_module_cert (certs/system_keyring.c:280)
[ 33.380708][ T1] do_one_initcall (init/main.c:1281)

so mpi_free() calls kfree_sensitive() on memory that didn't come from
kmalloc().  I don't have the stomach to go crawling through the
crypto code to figure out where it did come from, so I'm just going to
assume it was get_free_pages(), take out the warning; make ksize()
work for raw pages and document that this is supported behaviour.


