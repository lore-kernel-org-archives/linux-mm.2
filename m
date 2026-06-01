Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59EF1CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B702C6B0393; Mon,  1 Jun 2026 08:51:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA2E6B0395; Mon,  1 Jun 2026 08:51:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9326B0396; Mon,  1 Jun 2026 08:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0676B0393
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:51:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 515D4140663
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:51:27 +0000 (UTC)
X-FDA: 84831329814.11.8176102
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA1FD140017
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:51:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="T/rnueMQ";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780318285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEhv83iWRMPpEwpywpQrzBRVTeVJZLFdszoXaX6/TKo=;
	b=Xv34LXjyREzAkcxKlX5l6cvE+g8ulvXEcM9LZsrq9mkipFlolFC2z87ONBclnrjGCAjj3y
	exJ8MNJxpdAVN3bUPwI0j+vmM4yXBaD3nIUdzzV8YmpBM0opmt2Rdgo0XXLDJ1l03M9WVQ
	zztqQi96/DJZG4mabUWzMbLITIYpp0s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="T/rnueMQ";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780318285; a=rsa-sha256;
	cv=none;
	b=4/NnHosq2OV68B95aD0xpk4zaIG4jZLspRvRh79KMyr4HuhgX7cOXcJ5DeslKX7gQp/rdi
	ZRBh6cou1qTexDzVNmVAUQaArqO5qPUVDG5CcKwBfa40T1blmbzywHkMaOiBbAjbEiFX0w
	XdFNJaKMnrXKXRdj9urbQrbo1O10V4w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TEhv83iWRMPpEwpywpQrzBRVTeVJZLFdszoXaX6/TKo=; b=T/rnueMQa5GcXTkGnfK2SYkp6F
	eRWDyHxOMTbt5VXCpubYEBzzMT2cPaFNj1Ps9BJyOgJMlrGqGDDKTBHQwM+pxwEiOXkMzs/wclx4/
	zuWtcBvOIlKAbggC5VgYjL2wRAtQm9+ACNVagcsedWpyYsOiCtlv4y1QGeEhK4xtHwJkOAXGD2b0H
	ePR95Tv+sIvfzzphjL66dyAcHuSPpCg13U2L/LT9yX9xcho+9ee91Tp5QqzrIGSwmcV6ryBpb+fsW
	HHssm50k7Xcdsfns4/qBLIkKcZKaS4GhUV6f9NMF1ionY+EYV9rb06CIG5DlS2nD9vMMzc3kSPSAp
	5BEUUHXg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU26v-000000006aT-0kzb;
	Mon, 01 Jun 2026 12:51:17 +0000
Date: Mon, 1 Jun 2026 13:51:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v2 1/5] mm/filemap: reduce unnecessary xarray lookups
 when read cached pages
Message-ID: <ah2ARWo_EiVOaWDI@casper.infradead.org>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-2-chizhiling@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601055704.167436-2-chizhiling@163.com>
X-Stat-Signature: 6q5qe9ciocmqa1c7yja84ktamuonxz8t
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA1FD140017
X-Rspam-User: 
X-HE-Tag: 1780318284-459467
X-HE-Meta: U2FsdGVkX18wX6YjAoUY5XnBgZ++J1Mqr4/e3ueBHsfsAr3+qFRsViV1Qx4+usiN2EoIkLtgCiA2LrLzE4Kf5v2Umon06xRsDWNN3kjLQ7rbV4sJ9yTentgdIYif+vGqLFHLQzcSm4HgC8kLN7cXU8nz656gkak0PT+80lWYNkKDbfi9w91gljWsQVD+btdkrdQmSj7q7J6WkZWNTFPC/S/GN1BPwt3yIqB20O24W13PspJfgxPswWN1ZyKSc/M/MPWfaQeeScOKRNnNtlPAhSTY7vuF0Jpo8xVPLeBLMC7mJCa9mI4Iuj9Ha3h8VWiBV3ndXW465nPF4o6OG/qcC5WaVhnJMPR8CLmTN13RYCUiWp/m8zz8buquFFD72EeT2I+7L1b+y0a0AWTWruguPeDz4JRHYJzv2YinrgHqbMjWRE0oEjLL8ufhD5jAPMhylnC87ElAA5YWQLwQYSZ+RmFHFF+AH6+LnTML9maRbnYDfKOfju++oGqVa4wU7WzriY1+fZ6VkfgNNMOvuxB8jf6e7E1hCZ3t6MpboYofudJTntC29IvU9/WRkEdzfmUrMD9oL7emrONWG3ty5NMOL0FfomdZZRf4wAfiOrKIBz2c+NrJXrqt54EceAPOoUpiBkou4DvNCPr88feqwTEm+xv4e0aZkd07R+7zhkpefTWmuEMsZomI4cgTZGIgrOjlLUWW2k180zNTLROUB3iFEa8YjhQVgS33rTguO5yFPXbsLLDudjjhUpl6Z0g280GHAC9bzukDyicg7G/IoDXop/M5vWs/LL+s94UAD+IVUILt2RtM6FFVKr7TxOawxvP4IMdphGPCoMXuTZjo89j787jutoV/59yuTf7Zqt2C16MeFpMVa7bGZEoM3VQTPVS5Rc+aBuIMM8nYBakFkyGYJ/+hP3FWAr6a61NNJ5NCYfmPlrWoduYuuU1o0GEwxCP+34QWceFUVSTiyzjFSyv
 UXEuuRuH
 U1zhz11Ul9v5gSZjKoWsxCQfEnrM6GPj6kwllKI3oowAqhfGr6DiYXgR1uQThjAk4rxAlNncMT7R8PpU3QE/BkQTXtqG8S/MF0Q8vzxtM4TEUkD9cai9OPohrCMTH1XV/L7t89RT4E1IxXSyeMP1kzswmAfxsABrSckS4L8wd0mz/8IRt/quj/JLcCDJJ1/IqmLThjQaSFRCHckr3IcxQpPnepKXczyLQUNBR+G7hSmx2r/LHUx60KJjdAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 01:57:00PM +0800, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> When reading small amounts of data from the page cache, only a single
> folio is typically returned from filemap_read_get_batch(). In this case,
> calling xas_advance() or xas_next() after adding the folio to the batch
> is unnecessary and only introduces extra branches.

I don't think xas_advance() is all that expensive.  The expensive part
is going to be calling xas_next() and realising that the folio now lies
beyond the required range.  I think you'll get just as much benefit from
doing this:

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..578b03bd5514 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2459,11 +2459,14 @@ static void filemap_get_read_batch(struct address_space *mapping,
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct folio *folio;
 
+	if (index > max)
+		return;
+
 	rcu_read_lock();
 	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
 		if (xas_retry(&xas, folio))
 			continue;
-		if (xas.xa_index > max || xa_is_value(folio))
+		if (xa_is_value(folio))
 			break;
 		if (xa_is_sibling(folio))
 			break;
@@ -2480,6 +2483,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
 		if (folio_test_readahead(folio))
 			break;
 		xas_advance(&xas, folio_next_index(folio) - 1);
+		if (xas.index >= max)
+			break;
 		continue;
 put_folio:
 		folio_put(folio);
> 

