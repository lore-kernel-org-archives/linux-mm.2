Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE72CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 16:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7168A6B008A; Fri,  1 May 2026 12:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0186B008C; Fri,  1 May 2026 12:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567976B0092; Fri,  1 May 2026 12:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 420946B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 12:11:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF343C05B1
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:11:12 +0000 (UTC)
X-FDA: 84719340384.16.DB264EA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3C271120016
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:11:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=S+PrOaTu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777651871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CybRlbN4CxbIfeNSZrydRrLn1TjflMMzYAXjMcpWY4=;
	b=5p2r/shylpUHGQAlE3T8bZMoDCnqllP2jx0DM0S9kWezDy76X4RvaUsEBJ/FCiAYVunxlD
	oHYAbY82Apg1HzHMjqxvAc2eiEJ8ocxzplMjJQPwcO6eb6h9U7npzpdFbkplTvh5zHt5HW
	/jLDkBQBWnFAo9IevqUeBeHqypeX0yk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777651871; a=rsa-sha256;
	cv=none;
	b=V0Ux65Xd6k4++G/mQqzyP5G7afloHM8/+UOgWHWaTLckunWYM3H9dLCR6M/qiYV1HR2Tho
	AKNCYE3n3V1NoaHrAU4piW5GKecQ4bbz0mgC/iWOIbxZs1kReabmiWFndg6HqdTqY0MPNU
	9nx1p54aCTieX6eNxLsbK+chHzv3tHY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=S+PrOaTu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+CybRlbN4CxbIfeNSZrydRrLn1TjflMMzYAXjMcpWY4=; b=S+PrOaTuYpMS9yVFL/SRQq4G+T
	EDyv1/76Ou/0SIA3LL0ouPq9EWPMO5l4Z+1N0ptLnqAYO0BqCC4Xm3PO+wTeHKuBAB3IahTX8uA6n
	a7trLSaMY2QWSwvrG+FRQkKWQ18oVU4G7Xnue+id4br5moG5PbXCSji7QEubPHOv5XAVHxDx6zgXt
	wJ7FY6JrVfHfYKvW2+QN3fwPrQPGIgx3RMlpFCjGDCQcXCHPoN+y5K0Lw5lnU6sBd7VbJb/qhMWfh
	UTsBtEsZO5IdNigyrAUUvt2/YmNpV3JbBPOkDvUuz1JBSyohrXzO8wluq9Nh5ga/qGIKeRzyOIxxx
	5YZRXdig==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIqSF-000000091b3-3rae;
	Fri, 01 May 2026 16:11:03 +0000
Date: Fri, 1 May 2026 17:11:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz,
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn,
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 4/5] mm: Don't retry page fault if folio is uptodate
 during swap-in
Message-ID: <afTQl12XcXVnku9J@casper.infradead.org>
References: <20260430040427.4672-1-baohua@kernel.org>
 <20260430040427.4672-5-baohua@kernel.org>
 <afNMkqwxC00OT134@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afNMkqwxC00OT134@casper.infradead.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3C271120016
X-Stat-Signature: t9eng5gmqxqb8yimf38axqm8m71anarj
X-Rspam-User: 
X-HE-Tag: 1777651871-468613
X-HE-Meta: U2FsdGVkX18PSsD5rz4GQiVPUJDNAf5TrunFuQzjxYTOiV68RStX2MG4JDqwtFIOffXS/d2ZZZprqKMm8dLNVN5nT+o720Nzd9EZq/hfq5XTPGDJBcyYDKYJRrDCijPBX2R9XJAIg8iy1rZy9sOVwJyXQV7xn8+SKcVACqW1wac6H5Zdo3U7Im0FZ2q+Ses2k6UKOc+jF5MK56X8Ka26mxpFbEFPUODvksn1ZqgbhmLutUog4KKnMMa0NfcBqJSuuP/nPOMs2fBQMQscu2gCBIg3dqcwYwKL+9i0a/AE3cHd+uQ3ewtVXOsicTSx90jWju/03rXKTkSuJx9VHCfRV1eM069hFGFuqg4AwaIrmnYkkl8P7qzhW5lur5sNIoZQJGwQTztsZO6K1FEn13Nfe2/8bNcEG+toEyK58NCrj6ZYPs+IrRRSc5LEikkUOrR9aRo8INAlCReeg1J/KTGJzuirBQrl0++z720UjO1M4mVSaCdZ0qcvcq7H9Qtf5hd/hdvwCNGFPIK8JO2bIeIZ/pPMgNNERTQQH6NjZpFrpK6Xx50ihi2SkBXySn+T5pXjP3oDiI73mK2xT79zwjzAi2jEdRNX78IXdIK3BDm546WyOpPx41156g57Tj6zPnoafnsuhmHQz1K6C6Ab5lZLTg2/rSqoc3LJDD05ABOdO+UXBCBcrrNgkoqBvFH5A41Dsuna/FqUA/r5cHsjpxlTNa/CfHx18CrlizaPn+YyR+4aDLycAPBaNBWRHEww/tDXVjAKi4KMD0ufP0077aS/huzDXG84fo0lyCFJB2mpeYaOxpTAE5N9tEC0uFM13UGbQ5iXQmNvRYdnwu6DY01vdwgUDnGruL1tUhUfw5gMKodU1TfhgnkVed/Tn4FjJeoFRdEMBo5psUxZUqCUoAZ/DC3Cyv7aW5bpR2nKNJ+vYILln0rThHGDJb3wALP6jYxox6q2G5h5Au/N02lcYYN
 0KBh8W5e
 Q8eBp9a/pNHg3FVf8eglfk02Dfij6E0qi1OjbPvndNzuC737H0SJHfH1SrAefKdGdoxk3g3u2knNy9/lmjjhFNy5yNsjZCJetJ79buPAYIw4aTDTEpiqvP4igy+vtx+o24dtkk75mGnd5R8zwi86QNI+KBLflCET4rDLc/2+8effV80p6eJ48eyKC4VsxANrkqWoKwj3Zj/710wU0oJrek5vkkk2AQS7WXL6D0XkYtTNiTUFO+aKdrkEgEarvCEz9gSOAzvc5Gj9bHHKz23zj64MQ2RaW31sqsys3CUafJz0B9s27We8zSFMT9zNQYAsa0GUq6ejdlkaABkiUyuMO+j2bpZzTwX1Egikn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 01:35:30PM +0100, Matthew Wilcox wrote:
> On Thu, Apr 30, 2026 at 12:04:26PM +0800, Barry Song (Xiaomi) wrote:
> > If we are waiting for long I/O to complete, it makes sense to
> > avoid holding locks for too long. However, if the folio is
> > uptodate, we are likely only waiting for a concurrent PTE
> > update to finish. Retrying the entire page fault seems
> > excessive.
> 
> I think the idea is good, but the implementation is misplaced.
> The check for folio_uptodate() should be inside folio_lock_or_retry()
> rather than tampering with FAULT_FLAG_ALLOW_RETRY in its caller.

Actually it needs to be a little more complex than this.  We
sometimes wait for writeback while holding the folio lock, and
that's a similar latency to reads (or with cheap NAND, maybe longer!)

So I think the test needs to be:

	if (folio_test_uptodate(folio) && !folio_test_writeback(folio))


