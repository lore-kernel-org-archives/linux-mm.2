Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C9CCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98CE96B03AF; Mon,  1 Jun 2026 09:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964596B03B1; Mon,  1 Jun 2026 09:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A19D6B03B2; Mon,  1 Jun 2026 09:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE336B03AF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:59:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 276A21C0C4C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:59:13 +0000 (UTC)
X-FDA: 84831500586.09.D4B4EBC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id 34A0020002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:59:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XxXYGu7h;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780322351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlO9fhb4LnpJsMUQrtw5sIyHWQGmZWd74UWypqIxzL8=;
	b=gX7ztf8RtJeN5f+03g6BiS0pMteLszbnvfFqFokTQN/jJEOrxzLHot/NoiINJBC1G5gQvi
	mr6JPOSrPzL0W0w0tUl/o0DgUwHEe+lHA1Ajo1vVbfRXysMaG2WrEhaEme885FQQZNCZTf
	RDShRQEKr9WgC2yXlgM0HV5f3dS3dyc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780322351; a=rsa-sha256;
	cv=none;
	b=Wv55Skg9wq9ZTmtHwuznuW0b7W253jv0dUdo29GpwLZmzmHNvg4LH782tLHO6LM6pLZxIL
	59Xv0SKmY4b9tqmSMqfQlnVITvcUIEowm0+ad5DfuuhTUKMEeGMyOZuNNi4jwW2tNC1AXI
	m9R1+POm4y2pFIn+OYBU3V+Dtt6eL1g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XxXYGu7h;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BlO9fhb4LnpJsMUQrtw5sIyHWQGmZWd74UWypqIxzL8=; b=XxXYGu7hAOfubhOHWn6yu7LcOO
	F+qHetGLL4ojNK5CMLYmsnOTXpunLAM7wGwYqNkKN+qNDr3jKx5ULh21ZYBpWCF+n+jD81YlBgR99
	tdySmQnpN/A9KmP7Q+fih7rz1gjySVEBrZECJk4ju5fY92RhkZi5c7p9KN3ScAS80ZzXFIaDgA1Je
	3LaJ5Ga1v0Kjm7MaPjnNey7YQgZ8pU6E0Znhy0fF95q0om4m4iAgd9OnvlcgQer5MCkokdWU/VDF7
	6mnXDDKzry492oZlQ7BuuTdaty/R46g9bmhFY5PpMixqH9LFbJ5NNmrKvtFwDTkmmiE6Vua91DWyN
	PN8rNqKg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU3AW-00000000CEl-14rO;
	Mon, 01 Jun 2026 13:59:04 +0000
Date: Mon, 1 Jun 2026 14:59:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v2 5/5] mm/shmem: optimize file read with folio batching
Message-ID: <ah2QKCFWdzXIW448@casper.infradead.org>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-6-chizhiling@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601055704.167436-6-chizhiling@163.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 34A0020002
X-Stat-Signature: fo4176h7p3k1ydm74e7r53nysut7fxt3
X-Rspamd-Server: rspam06
X-HE-Tag: 1780322351-99666
X-HE-Meta: U2FsdGVkX1/tJcSYWEfSAIhHTTzhC/yk5ez3vY8GC926nSItAl3dxTXn8OO+CgPik+XugUxA6e6noECd5NK9bxpWksf9R0gFBdxiFzjep9sqyxpYfGei4eNG7YKcmtxOWIi85lrrY0GUh5ylITao3JXcI1kQc99p3rOLCwNPBUCimWdINBbCN2OCdHku6BPzc8YybbZHjbREFX8tR+A964wDyeTGpf6nj8Btz2HuUGnePTdQEe0aPzvuEaM72SpX70gCiX+FDk9r3shI5xInuriEbzL2tr3PLO4Izwl780SB4ZZ6WuDnZYtSe0QrUJfJoqVBTpdmV3YneAu1+XSwo5pA7EEzO4zXCMYrFMJQf5HNVn9/ZdOcvWZtVuOexmtOitq6m0gFsGxV645zFYCOzBWYUsfqq7FxNtAnkb0EJgseSkm6pNbnhnd72nRBIYwGOr+7Sky9Al7FZpvkL1R9svTfDey2VyRlff1Sd3NHmbXfhWSfPcNAx7oUjyrm8E1YUrPiJ9nfCewYSGv18E8e1ni4nXPxBEvlZhYcgEbB6ckbs+LeTM61E/8lxebHMkHl6Fyyz7sQomQWbR1k5jJTXGVWp7LCyrUsb2cpF+PL/QjBCGVWxCNaS7EmJwdfagUSXxDajt26Us4jW95T4Sim3RPVMA48w2OeLoPe3B509RI3385RwLqvsWFa322dpSZ1h8SKsPNNmdWcGTmb5T8EBorP4KK5YXmX5xy3XJPP9Rq4iR7XxF8ZgtwdKjFFoQf/KQOw8Fsdh+p5cxU2kEGCBScTKvDchtT9nZCMFqx6+ujucx4S7qvDLmck2TuH/tnPAd/xEf2beC9Ik9Ip2e0UjOqa3Q7Dz+ErKWNokWhQREWwGxvIl3T5Tl1SieAKC2Ors9C69jGLndGwbPmJd1LJzahxo+0XcmHMfCvO9/8hTcdPS8d6gOvzp68gRkv/Ad9S44cmrDjK2IAZ+wFHjfW
 lSyv7chq
 qql5Vz+tG8DKgb/poQuB+rUCSfgFqVHx4DuO+dE4tCsQCeNeAQlECZSXhmtewVPhKA1Ro6Twa2L8PJuLiFnVmzyKRoyeyxHDoug638To/gaA52kevr2bDv/rHB1ukrQsSFlk9MvweyqE0+iLyCgZhnBenamJNnX5MAQQ/lIRWQQu+HntstKMHvG/5H+GAlV5bYwqdzSK7Da4U/yCVgj6oHy+RNkY/+e8LDI+rQEUdAHunz0lz45SQGCG6sidVFajwS3cMykWHvCWWSIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 01:57:04PM +0800, Chi Zhiling wrote:
> +			if (folio_batch_count(&fbatch)) {
> +				for (int i = 0; i < folio_batch_count(&fbatch); i++)
> +					folio_put(fbatch.folios[i]);
> +				folio_batch_reinit(&fbatch);
> +			}

folios_put().

> +	for (int i = 0; i < folio_batch_count(&fbatch); i++)
> +		folio_put(fbatch.folios[i]);

Also folios_put().

