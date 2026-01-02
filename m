Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 179FFFA3726
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 02:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBFB36B0005; Thu,  1 Jan 2026 21:43:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DB06B0089; Thu,  1 Jan 2026 21:43:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3626B008A; Thu,  1 Jan 2026 21:43:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8F526B0005
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 21:43:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53D4E94EB6
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:43:59 +0000 (UTC)
X-FDA: 84285478998.05.676F36E
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 27F17C0009
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:43:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jxe1dIe0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767321837; a=rsa-sha256;
	cv=none;
	b=SxgTOxVhdadX0daSoxJybPoLdwVCZUrEwSvkFtEQrytz+yEN8a64IwpOZW/Z2mpq8jGYCn
	+joOQ8b4N2vxWe7P+elo066yIYFi2hN+kILT8IdYa2+aa7JJC9r33f+/iFmzBLBKYh8alr
	j85MHrqYNB322rD/+TSD3uOKPmyBU8Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jxe1dIe0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767321837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzQAwOW7aTrcNdODCnXEJKZ0/KQteyr6ln71spISn60=;
	b=CPoM4Z/rYlSeUFfd/rHaaAcQT4PaGgVpPolqPaDt9tGeXqPkWjXii9j7Zp9O1aAWreN0ik
	sJB8bSd+opwt53AjiIvNdfeaEyutBNC+fRagKVnHds1RpcvkME3+uhg8UwXnfxPNMu/j29
	FPiowDnNXytBUl6enkQTDLD/1sQ278s=
Date: Thu, 1 Jan 2026 18:43:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767321835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzQAwOW7aTrcNdODCnXEJKZ0/KQteyr6ln71spISn60=;
	b=jxe1dIe0hajunEiEZB8Q+xfocZNgqIHEYAVfJTklWj21hnbF0P8TCgoemBWH6Ae4SXEBK9
	Gi8gnxOHhGjB10ikx55qooen8aHcSi9oDyDjVfihHtaYV6jj3kigAkuhF/bQGPdnBWcsSk
	bZezj3/XTsJ9e+wGWCNDQOnagLV3n2k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg-v1: remove folio_memcg_lock() doc reference
Message-ID: <kfuzaosmmq3ei43k3ng26w3457nwmmm7i34onszzzdnvjz7ova@vnkgrqxw23br>
References: <20260101225552.3423108-1-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101225552.3423108-1-gthelen@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 27F17C0009
X-Rspamd-Server: rspam10
X-Stat-Signature: 4nuug67879uuifmrc5rnfjaoa4w75hmg
X-HE-Tag: 1767321836-533754
X-HE-Meta: U2FsdGVkX1+IylUrHfF4xjv354tY3tNA5VyPJmxVhWhRvqfziIum2CKJc8KlLEAQ9/U/zIXvhZkkRHNDlAJAorVtTTi92Z1fhKuYJgs3AhkKlKuGAUnwrule+vT6DOgenzxg9kEfl6NQjBqwogKWU7iyDPzkt/mz4k3gbvtgu/jDiIvS/pQFptYU7RN4QYK3xP2StwaSX8Anlx9LgGoXdMnK86TsOiQ1yN96UI20DA4uvrGNQALLDmLWuPditrZidf43h6HSNvAdPZvvXsM6YxA4lur5jM+lHwhvvxk952Ae11LymZPHKNUyP4neT/8hCO+AWJ+N0fChXYi1+SFXoNcJXZoQ9ufZEuTVid28EszDErYiI03BN2Z9/a4K1LkdBjaDlEwgYk5U6m7LMuEF3yfAdCamyr6Az+bpx78eLAWXranuHfw4FkgfUbm6y1vSZ6Z6tfuCfCg9zcMnL7EbET3BFNQdbDe61x6hEbNYQPO8yh1t9uaafa8lkT4sweoB1VOVCbh7SJHKa1TwFLsWGdNWK7TOFR9WovnOm/cT5ODJYhANSWupMLDOtQacvsqacgOVqNv76JuDQIsVUeNBJ4QqbioljxyItd4qfx/Ov9eCGub80d3wIJIFDB99zteosu5zYC1AgKJALkgnYY+4zQ30klFOqR1yJnA8iDD3fup6tDXaE1CWPAQGqeCbbNINdlsIGHwIy8IcozFv0NKQc5a0sgGXhC7IgC5wYlVTEYs6FkcANj6mqzKlgQVM9Nn6QVbpkQT3SbhlAZtyZ109gSCVGnrsil8RRDloRRVumXK506d8wd1qsw5Nlz5eZ83MteejlHPQl3PuKix6u2UxfuqMrO1IMEMFBhVbY6SntSvJFgHhFNyHwuU/ObddYILgcjbLDpzgMFQNies1vlGIih3rCrrMvbauFl6Z+YC/XSnni/CyYNKdfAC9BZ0rgubf0Kll8n7PcAkfTY43svC
 vm3UC/Za
 1HmJY00b3t84bHXvpfYpdfo6pRm9BDd6mmwjqWLL5s6LCKkvjKsiODA2u6dAKK6rwlVTJINWAuJi2Scz7LNNIzXUGdtye3kmUgCkwx2IUbeE1OBD1LlFefBBnCfPtXS9efJYt5tZ3GIk4Oi8UI5Wp/pKu51ZtJHrotzFenTIe28DTi/U5V/DxSitCnvxkXl9ANuSlXAJ6XSfSyxDMbN7nGHJQ/X86hzUoLkxyKrs/Yyj7Opo/51HHmXtw2ODGyBqtSMRDACXvpgPXLb/aoQm2aF2abQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 02:55:51PM -0800, Greg Thelen wrote:
> Commit a29c0e4b2e86 ("memcg-v1: remove memcg move locking code") removed
> folio_memcg_lock(). Delete the final lingering documentation reference.
> 
> Fixes: a29c0e4b2e86 ("memcg-v1: remove memcg move locking code")
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

