Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6F77CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 19:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60746B0005; Mon, 22 Jun 2026 15:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12626B008A; Mon, 22 Jun 2026 15:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D297C6B008C; Mon, 22 Jun 2026 15:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60A3E6B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:34:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16FC51C18A4
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:34:25 +0000 (UTC)
X-FDA: 84908550090.03.4C85649
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 56AB840009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:34:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hkm+Lm7h;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782156863;
	b=2b+b6OUM5j3/tA/k13qp5UP+ffyf3paAf+Xp41EvFlyP/nvw11H0Xuy2vS+u7JRSc990k5
	3mMFfRINsHGgs7aU4pu2KFJzhxYkwtqh0+dNExWYAD2g8YSuaEJgkw+xboxDU0/HxGpCfO
	lrjsqvLsG1XgcblvCNENBfTd1BhzmNs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782156863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xn4BQmH5jE2QFSOGntobZsvGCFIf+b2KZja3Sp0t2bE=;
	b=Xaruqc1yjiUefNGXb2x+cMQAIb9A2c/ivZD1M8V5pMgBzVC6eAvoo+1zLLgeJ7Ko/XVvKw
	/So/zp4JaJ4hLkKf9hN/bpTmMwIbZFEUksbU+xOxE42CM1SWuAjmZMUMsbv1j3jUIhnann
	bhKiqVC5zf3utzk5WePerHJE6tUjIoI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hkm+Lm7h;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xn4BQmH5jE2QFSOGntobZsvGCFIf+b2KZja3Sp0t2bE=; b=hkm+Lm7hxbFeaqyd0eOwZthJf0
	N/TPgn5Hwa3OwYWRIzQDtqsJMiUJNlXchFuZJkWpd9O8TDNZUWy8IMroy6ROfjTBHzgaOTLoFIX1q
	x3N+mavONrBzYlQLZLNyVrrnYlREUMHyjTIRve5Quoh/uZalulCkWoNvMdXf8IopmFtFul6pQVd0Y
	bJVDhgb3LS1aUvmbULopATP4bkV0nWLVl2rKOzJzkM6KvyPudV0RL/XAUPBAaisdhVIRUhbS1grG2
	VOUJmAOdK5z1rMnU6cfCQl+/li0An+eWaBj7blvN3RebnTokGbD01YBGm4mgv/y/1Scq7TEGDFRXk
	QTFBC1/w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbkPU-00000004pMW-0XdB;
	Mon, 22 Jun 2026 19:34:20 +0000
Date: Mon, 22 Jun 2026 20:34:19 +0100
From: Matthew Wilcox <willy@infradead.org>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [RFC PATCH] filemap: Remove file pinning during fault handling
Message-ID: <ajmOO0v2ndBFLaSU@casper.infradead.org>
References: <20260622192114.1147198-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622192114.1147198-1-willy@infradead.org>
X-Stat-Signature: ir9wimreec6u9xtobssu7yqu91qrcaq7
X-Rspamd-Queue-Id: 56AB840009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782156862-650909
X-HE-Meta: U2FsdGVkX18ZXSC88XGtnrPQWHdO5bS2mG2UUHql9Va308DRY+maJcwYDQ8p3Qw5LkMgED2GWBMXN2ei5rkXBxuSbj6heLlOQBlQcr0e2Y6oGIgKZzJSfgsSb9cNHwN8tLtTZE/Yz0D671vI2uxsJhNtlYmMVVTvMBDIdPLu9plN7+F/md2c4MVZhEVQC/jiKVs6xKYkKNAIEhH7FW06hRvxH0SMsJtruTNnnDuv01PqRRrJuFEPVwJLDXSURR2q5WngBUXM0SDHPNsMzDUnvZ8xAXzkXwza7x84Mt8oqC6oZoeN3+qNgx+vk5yXINiNYKtDANsFayYSDF+X8JURuWGMOPLuErAWfdsYFQq8f3Id/a1CYYrDaeCHy8VdVtSVTDwr5PzTvT4qm57+1M7XBs3iIF/mI5nDookGzf1zlNAPBkaDQdK/uRhexeOt9bIJ/0a6nVLvCwR1VOtGNPCgh27dGUXJ6ImVAqRFtOuqtB/5EDNg/45h8uCkebig5uUtUL28uidIi+RB/UfnQkktjMHWv8bNzPEd8ZDF5bwbQVumVHl2wqiZvRA81Ft+KHrPBRAt0Y8YB2iKB90N2Hx+lyrbJO1obLoyNs7cWyDaDmYvLOviGiIfhD59vG7yY31y5byC15evjLAxbHOX4GSUleGhprz71/gBmPXHg0nkEY9pPoAyafj8eei2fiOjVfYLr/cZvjqO/LRCrYTzIt1eQ1kl/5XJ4ByM47nvGgGH+XF1IIqzPTgL0Ga2CSyWx4Jg7qphVsknqt8k/1dR1D9thW+vdkMmaNtxPZelj7hyEvOENSfy7HsXMegcUmZwQaGRyaZbMTUrCou2RD2x4l70XEg3T2h3zgeLVbTl8NK1YO9Rrk8U9/HndNzhJzBJanvYrEXhfKGlC8NXVOU74v+YmNW+a4HceRiURY8iwhFi5dvViv2uhJhdyE0P6dKU/uO3pHxmOzeeRQseMb2t6XO
 fjhP3q/R
 Md+unxZm0dR6WW9edC8a4JsKh0S8uZC9vcONRWx8pfCrSoyGciUM6XAqoDMsTleh2rTPc9a8qz/Q/WnShKroEGZU6L8l3jKe9rNA8GB/4IGX+rvyYSoYw1e7TSL0qMesvo+hmmEbuEWdYMzC0f20uhYYD6o77EW2pt9g0P6+gyAryhLTuSR2+/Xha7A2mVQuhv3Oiz68horTyF6qIFSmi2waT+4nkPnWnN4HbxR7eK0bfxCVBVdn3UiCU6E69/D/E3bHctaJXDesN7/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 08:21:12PM +0100, Matthew Wilcox (Oracle) wrote:
>  		if (!(vmf->flags & FAULT_FLAG_TRIED))
> -			fpin = do_async_mmap_readahead(vmf, folio);
> +			do_async_mmap_readahead(vmf, folio);
>  		if (unlikely(!folio_test_uptodate(folio))) {
>  			filemap_invalidate_lock_shared(mapping);
>  			mapping_locked = true;
>  		}
> +
> +		if (!folio_trylock(folio)) {
> +			if (vmf->flags & FAULT_FLAG_KILLABLE) {
> +				if (__folio_lock_killable(folio) < 0)
> +					return VM_FAULT_SIGBUS;

... clearly didn't hit this case during my testing.  It returns with
the invalidate lock held.  I'll fix this for a v2.


