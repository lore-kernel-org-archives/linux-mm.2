Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2614C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8B8900005; Tue, 12 Aug 2025 04:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67907900003; Tue, 12 Aug 2025 04:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56848900005; Tue, 12 Aug 2025 04:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 41816900003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:06:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2F6516020E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:06:58 +0000 (UTC)
X-FDA: 83767374516.14.A9786E2
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 65AE41C000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:06:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fHn8xZcb
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754986017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVuBea6VpC1PMtmAq9faKJNX7R/TAo4v/B6y33Q4vAU=;
	b=kb21vv+Dvh90f/NRhWw93L4lT1M6mOs9GLH0v3zNCkFvn7XC55ySMFMphhv8sKrATEZqxG
	hbGqnGPx+WjKTfHrljltyjv3ErxZWiTVY9bDOj4qjpLwo/CsjUfsCl4y44obuCk6cWbTiB
	TmCphoQy8/e6v7Q02wO5yL7YoNtwuy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754986017; a=rsa-sha256;
	cv=none;
	b=ldfEMw9EHKohXhv60u3APIvmSW4U0PLQb+gGUpSEBY+Qs7W+V6heqev7rFuLzmZ2sQhfO0
	rBpiBa6YoJCCCEDESUBNH6HydErDFLlaInNWXFdjQ+yH1Kc063N1T8rX3K0+xa1510Jj3h
	kpfojWsevfhu4YLCjxFoV5EZQd8I/C0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fHn8xZcb;
	spf=none (imf21.hostedemail.com: domain of BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MVuBea6VpC1PMtmAq9faKJNX7R/TAo4v/B6y33Q4vAU=; b=fHn8xZcbSHg1Xl1P1bPlqfUGPi
	T0pvdLqx44yA2a7vGi0h5Em2B7BUIkKu2hjLQ6I8OM/0PqL9MfTryXHeSfOKfLz3GgdxHfa9ccZSO
	zG9Rcg1mbqWSLo4u+FSb6IdQ/M+ylTJtFcyqRrJvi387wZ/mUo3C7wQRynA2JKKzrVrAI7f7SP2GT
	H0YV32SIOPttO08YKAElC9m4EpgPxK/8M/izBJFPvk+WFfYGeD9SEb9owdB9PzEbGwi7wrUmzNdQt
	CZLdPEbVcIC0Dr11iLvweIa/x5fgY/IIfiqMOq9TfuzozcXLmJccUPByet9E/vW33lTk5L0rldj3a
	nCyki3eg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulk24-0000000ACPJ-2P45;
	Tue, 12 Aug 2025 08:06:56 +0000
Date: Tue, 12 Aug 2025 01:06:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org,
	jack@suse.cz, hch@infradead.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH v1 07/10] mm: add no_stats_accounting bitfield to wbc
Message-ID: <aJr2IMd7uqhLJ9qb@infradead.org>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-8-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801002131.255068-8-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 65AE41C000B
X-Stat-Signature: 1p9ptbht3cqenyfjkw8h1mcsmefjd86h
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754986017-461672
X-HE-Meta: U2FsdGVkX19T5TpAKOPQ2+XbeVSxtYob+KoqpI66XpW+zfU8vFvfZ2hcs7s4PSn8hQTJDMNEmhgXq/atnjzjXneLHa1rU9z6t4LS3jkN8ZNy01chol1nRDAacNBM6gZCfFead4dBWIhqWFuZNTMke5NFZ16Vg3IxypgAGy6SJhCYL57m45TQbrGIlIjMahdP843eGbuiA5ygHC5pEqRXy9HwqYxpiTNGyP81Noc3Y96I9p5XsniU1DqTK4SlMM6DaoV2x6exr8WtdboNS2d2TL1GQvWveFWIPkZteNNJh2E4RJZc5Gv8ZuRiprlkqjyew9sfz8rMKXW64wiJNUhIjglIuRFNwQMCL0WfF+Typ9Hk29t3fxvWcpnqAfu72NQtbWZFUmWOiDQWCl1/M6Uybc7iWu7LtdamLFFst/RR8SOze4IiHn9Ykk+pfG+bcQJmzhW83TtGskTBMFKlt+MGxbbFcVKHHLsPO6v7lmW2X7AXRruiN4ROLX1D47bBT1p4oXNt0QHPFO2ghyZrKvAcA5npyWsnt9CLNLoIULkK8qtSTJnbnZbJCX1qUoNKIfSM3D6DUvOgnBTwOLFCGY4U75pwdCQYKyp7ir+CWZ4eFpTDe2r004JSeNwCgKpgn75Z1MRUYoXK9vV/9AyKpLGMgjBZwDPDsEGpUOB4OdLQmdGeNH/aneIVHyqbhSRbnWW5LQHlM8IQcbZGS7eKkDF3uP7nZ4NgZfgxDfQWuHH8rdJ23Vodw0OAKawe7v0CkRMhAqq5I2mIgFx9onXziGUZDZViCOXOcye2382zwtj+X2iZnJDq3mDbWyTdAy6qnkqndwk2CfZ4zoIzWT2D6q8E0eXZzQCm8tKBEoWwfGTBh8rki0ji0rn2QUtvAWq/tkFhjDwea0aQA02vNUMEPlYkxjR0Wx/fB2FD4wY9358Rqc+NYTEGIQGik2dgC3gBOeeKxod9zBhGFqPDsodpq+L
 DGKFJhJv
 8x/NOjIDOl0AjV0MhT59A/4lZmdrEqEnISW55dpgQWIrpkspk2CpCpkOnniac0aZjQMqw47RoeXfd/kMMyFiQBnd+0s+9LEL/4mV+O5ReX7pIFt2+MoWcf1cXtrEsYfi9Xd5bNGYfiu1Pf5WpWZLLT2fDT6Px95c373R9jlRB01TEh/QXMb+fOuTgp56vdaC9re5GZXRSlCg0nwrSgsE01IQ6DM2VIYhboNv8Ig+TTeyhU+h3qHfSavjNSZG/VQBvfwdW9a1/llp79uVhP6O9pDshx2TvLp+rDpPHuAc4LqLJx+ODZb9Y7JkeWwsVWtq4/IgNsFkwhFvKpir39B9Kp3buzdEImkrlNCvXBpMYGl+RIvIQqoiMHHn4EIQT/qUkQmy//xmvaGcOPOMzZ+xLrYvM14xSB8AFczHElh2dNlKV70lN3ezJlWJC1qDdepWOiw8Um4GbvwjvrXb8q9YS8enDWb+PE6idslxc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 05:21:28PM -0700, Joanne Koong wrote:
> Add a no_stats_accounting bitfield to wbc that callers can set. Hook
> this up to __folio_clear_dirty_for_io() when preparing writeback.

Please explain the use case for this a bit more in the commit log,
and maybe also the comments.


