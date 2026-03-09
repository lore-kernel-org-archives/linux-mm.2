Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A0EF3C248
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA7C6B0088; Mon,  9 Mar 2026 09:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D880B6B0089; Mon,  9 Mar 2026 09:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB42E6B008A; Mon,  9 Mar 2026 09:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD23F6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:02:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E2241A0104
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:02:02 +0000 (UTC)
X-FDA: 84526537284.21.13D685D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id 37AC540025
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:01:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=NVFEsr7G
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773061320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVZJ8HA1Bq2a4PhlPxh0lErV720ISPGpbYGMuWQZ5Lk=;
	b=lH9pY4c3THifq4viy9bfL8wQ4c9S7KyF6XxVgvL6jANYSeCcZ8uz8GxUYea28DYxCs3LHW
	eLI/R+gRbszgIB3BNweNNZxzlyeM4MQKK8lJTx6jLtK7zb99PDUct08+eID8FKkSKEgYB+
	VGdlhHuo+2ygKzFXJw4tO9GB2E5i+JY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773061320; a=rsa-sha256;
	cv=none;
	b=aTfE/6+Gl3g/BWuIFXKqKRcdjB9Jq4LSpFW9l63uge8btaeSZS6+zVGH9Mr1KEN9l1Zxhy
	jbADjJLQkHNNcnTIhoPu1D7Q0lqkCdtyaF7GxPL24d4wvMF8PVEL45ufSncmNz3xZA4Gt+
	Pxc34920Q78MPC4mBlSO/rfD3muv0uE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=NVFEsr7G;
	spf=none (imf04.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xVZJ8HA1Bq2a4PhlPxh0lErV720ISPGpbYGMuWQZ5Lk=; b=NVFEsr7GEe+1IceOj9Tgde+bOM
	BC5ggZUCHv4FUkC8SvcoAo0kSlw6vUqgNYU0nkgjPTDujyZiRruV3N7EnE6SYJWyPj9GW4WINEhWf
	8T8PeoS2LmMwfA6T+eHQ8RUJnDGNjuK24LvozWiuHSCEskCAwJpMcXL5gDGBnspQUvfeY+9264KwL
	a9FRenXm8GKp8RmaWOerp16NZe6KVgCBikixT/yAN8hbwjNjcrKabTTv5MN5+71FtdE9Kz0BtTDwF
	QrhlPTYFNs1zdtPbv+3n4gCqLylkfoz/64UetKXX2maA2RUtc2fcu0mUbn4pLW0isgBHZh+4mgGuL
	sksMAMIw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzaF2-002EbW-0v; Mon, 09 Mar 2026 13:01:48 +0000
Date: Mon, 9 Mar 2026 06:01:43 -0700
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, SeongJae Park <sj@kernel.org>, kernel-team@meta.com
Subject: Re: [PATCH v7 4/6] kho: fix kho_in_debugfs_init() to handle non-FDT
 blobs
Message-ID: <aa7EoP1zQ9wAG1Ri@gmail.com>
References: <20260306-kho-v7-0-404d14c188bb@debian.org>
 <20260306-kho-v7-4-404d14c188bb@debian.org>
 <aa6DWto0xY5EPyxK@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa6DWto0xY5EPyxK@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 37AC540025
X-Stat-Signature: 7im5kh64kkdjwh4tfpt91o9fnky6a4gy
X-Rspam-User: 
X-HE-Tag: 1773061319-625170
X-HE-Meta: U2FsdGVkX18Na42y5pANEpT2mu44VmPL+v7s21i2WjP4lbFbRCLIkKTiNwjIpDROvwVRcbVbMtlMzCCKv1FojnRXRvH3/CEK+qxhMCovHg9wfcO6qbs9BerV/sSOpOhmqDaDYi5fNqubMtEs1IhGHOyrQq7QEiv1VGk7Gv/GvZJdbNhOnY2UDT+ycSCVH9Py0wZD39DQAv7CtE1CJq4w0LDn4OFP6rD1iqmvkpScgA8zH6JTTi0/Cnj9ni6Q4z7N6HLxxsTCoy6Uwqz0YmP5erhRM/x7HyOubM44Wm4YrPB6wbOyLcT9d9/sfQxu13UhfnmMDG7UmmHOJy0lKJn0wWlK6DB1ChJn91yJfVFRYqEkiClFVR/7X/tqaYxzGAg+jJpRdui+e6GWaVZM9nWx4Rw4jS/P7sHMwODhBsDuLqsBJLeprjUtfOBu8mY7I7gAwkBsiEkGPhdon0z2f47uGJQ8asmu2zmPuYs3viO466v6p5V9niWDE8qUe9a10VGCnKddlMhGBxMp8vlZcpnY8eS48x5oUjc1q4b+yncAsWjTPgXmnJjiTKfCS1T2C3uxhS2mAvDyZb9DNbUuKz43D1WvvOuEh3p4EVZbmO1jSSJJvgAimH2cscD9mHpp47DOFc85z2PCpvAh8W4SUb0suXz88ydPQscxresIfS64JRiNeCW0WsZ2eyMyrhgwl8a+povwDhBQctC3mmAqEINEUymkRf+LcOOXWAZaEiA4OkAnzJyxsQV4Zg2pBRQ1YPz5ptZXuBAevRqsF169T1qb5hrhtB0Rz185atVgM3KV7NFff67wwL1ceiv0igtkqAVnw1x0adSgT6/LT/hRqYFlRdb3g8ZcB12rsiuZHCgzViRtUf0hiceEEBG76w5K0YR4dciDX0RAtn0ASQAjDV7ajFcxlBjwkIrXsK0oznDr98OdOnxoUHkfACp46ZLooWoDnxLKaJIXh3WINhU5C7F
 Ojz2F3Ek
 5WjnbHyDw/0uYNLzrepIzc14NtxlHngDvlM1JLYjuioz+YDTzwfiyGUIqvA/UIsn5KjrszDVqhIIpnRFob42T4M9lC6p31r0e/b3AbPAW01LX7aPh9T2xiZQer4PdOaisIIH7wRg5lugtCzdRDECUn/bQgfT2mBGgRoNIJbXPr+plAlQGlnBrqXb4DHsSiiaY6i1O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 10:22:50AM +0200, Mike Rapoport wrote:
> On Fri, Mar 06, 2026 at 04:39:23AM -0800, Breno Leitao wrote:
> > kho_in_debugfs_init() has two problems when displaying incoming
> > sub-blobs in debugfs:
> > 
> > 1. It uses the hardcoded property name "fdt" instead of
> >    KHO_FDT_SUB_TREE_PROP_NAME ("preserved-data"), so it never finds
> >    subtrees stored by the current kho_add_subtree().
> > 
> > 2. It calls fdt_totalsize() to determine blob sizes, which assumes
> >    all blobs are FDTs. This breaks for non-FDT blobs like struct
> >    kho_kexec_metadata.
> > 
> > Fix both issues by using KHO_FDT_SUB_TREE_PROP_NAME to find subtrees
> > and reading the "blob-size" property from the FDT (persisted by
> > kho_add_subtree()) instead of calling fdt_totalsize().
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  kernel/liveupdate/kexec_handover_debugfs.c | 38 ++++++++++++++++++++----------
> >  1 file changed, 26 insertions(+), 12 deletions(-)
> > 
> > diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
> > index 7a100f2bf3947..fc2baa8b104fd 100644
> > --- a/kernel/liveupdate/kexec_handover_debugfs.c
> > +++ b/kernel/liveupdate/kexec_handover_debugfs.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/io.h>
> >  #include <linux/libfdt.h>
> >  #include <linux/mm.h>
> > +#include <linux/kho/abi/kexec_handover.h>
> >  #include "kexec_handover_internal.h"
> >  
> >  static struct dentry *debugfs_root;
> > @@ -121,23 +122,36 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
> >  	fdt_for_each_subnode(child, fdt, 0) {
> >  		int len = 0;
> >  		const char *name = fdt_get_name(fdt, child, NULL);
> > -		const u64 *fdt_phys;
> > -		void *sub_fdt;
> > -
> > -		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
> > -		if (!fdt_phys)
> > +		const u64 *blob_phys;
> > +		const u64 *blob_size;
> > +		void *blob;
> > +		size_t size;
> 
> Do we really need two size variables? Can't we just have u64 *size and pass
> *size to __kho_debugfs_blob_add()?

We definitely can. let me respin with the other changes as well.

Thanks for the review,
--breno

