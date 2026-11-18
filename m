Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4512D606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KCLEdvBA
Received: by kanga.kvack.org (Postfix)
	id 55E116B05BF; Wed, 18 Nov 2026 09:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536446B05C0; Wed, 18 Nov 2026 09:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BCC6B05C1; Wed, 18 Nov 2026 09:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2155C6B05BF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:36:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A148B80150
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:12 +0000 (UTC)
X-FDA: 85448489784.09.F619FE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 089D880006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCLEdvBA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTJ6/5WzE5JCaK+BecloYss1do/yUv+G+4PNfkm1tUE=;
	b=eStPtkWZhbP8qIzh24gO7NRtdBeoj9W4Dbtb/OUuxdEf32XOA+DYfpD/ShhZ5CFzMA/Fiv
	uvlhtCUnnhQH+HpJHjygAvGzQRfS71bdC+SVQb8Ti0hcRKu+vtYkSV/rvAjWAGJQEEiwDh
	KMNF2ReTfL2R4SKS94RDHONYNckNBII=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCLEdvBA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012571;
	b=m75nqRpZCIwrlx4esVqe8jB7OwDKd6oYgyJapvu/RXpZEO+qFwvMa12Llm1Mpb/xI21D8A
	ONSmRMySaFjttk2K4z+7zSkj+MLhOEDktIqhY9Wxh/bnO3mZGDfUSsMwcCVgZOLvT2CmxY
	yd5OCPpYf/iqrh9sN9viXinfWDHbd0Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28CAC40792;
	Wed, 18 Nov 2026 14:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A381F000C4;
	Wed, 18 Nov 2026 14:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012570;
	bh=CTJ6/5WzE5JCaK+BecloYss1do/yUv+G+4PNfkm1tUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCLEdvBA6rxiK2fBZFHlt+emAzYHcLNBNuWT6W1cVvtj/QkHKCbayq8rXMNQqHmiE
	 QG08YNjQB6j8h/O869KvqwnvmKPmcVIXcbvlWAnZ7uimQEHirzPAOFazn8bM62DNru
	 KJJA/Sl7sobjrLTiNT7FadHW9qtxt27IghPR6NWmtNyV+K2Fj9HKN1ArgshlLztngY
	 lhu74b50bLSxx3/jlx4TzmOwF3saTqzenvUlyuOC5VKaEKDgj1bDw4UATfoqSEgeVB
	 jEMz/JSZcpxX9WDruvIkyK5QE2HDrwgJHy8yP+P4bWFJJcUnB6Dpa50CCNsGqcQFs5
	 y5tnzU9V8fn8Q==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v2] mm/damon/paddr: skip non-LRU folios as a whole in pageout
Date: Wed, 18 Nov 2026 06:36:02 -0800
Message-ID: <20261118143602.93103-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118-fix-damon-hugetlb-pageout-20261117-v2-1-547a65a3206e@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 089D880006
X-Stat-Signature: 3eo3ung6ai37cx6opzi9azz4ykjo7xx9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795012570-603408
X-HE-Meta: U2FsdGVkX1/eWxamvfgroNt3URfFXlvVLKtotXmvJEL3zMo0UsJ5cGknmJdtUNFlySiT9cnDgHvPwDSMymURkK/K7BuwRDBaqe4h0tGLXulPPO0gso6E1P2DLbVK923UI7deKaups6VteEcev7IBQpv6V7b05vuZ/cGP0Rx8poo5+gWQtYm+5Ep6TuvXQg3zRrOW2g5MyP+nb+Y69OnzeECUpLHAFWbjF80/ia83vPkamMttkXs811a+WmRqOPYbedYobFF4KjhC/+OEk2/9EEbxPHP+dojgJYF9OprZFyB6nZ0pjtfQeMwoIiqH3d4mDghy//5YOCsvLzDusVmd13zE8iPG4SApIHR1BRHyY5oYvXQ1v0V8NUrb3lWP7kvI3+AiQ3dDXPzDJp/aeqHAI/s6MCsc8SMocG5sLl1+akKFwvA7M/fZcEw2Vfbgp49AkKEPK0LZXkGi65AjabPyNVv5I0Uj1YKsCIDjpNoRsdDywmc2FFYHymZd5/gNq7ew+lj1lHA1dOMWrD2mietYzx/GCUvy+bwFf0r6f4cu//M+mN7VMMmtvRv8YrStjB9h6aJyAClzSpXj2BLa1kaKuCuKMIPHt2JgoJZK/r4rF6D+rgAw1PZZj5J+nNFjb9IlOnGxjsqEjnvC/D37qrKTxGH/BGxXTdt/aXEfAgN5RNjDLVL/Vm055Hwxd2K0b1wXJvT3KLIcVuT58q9EXQrS2lTW6bgB1ivU/LZpx+Iwemzg6xQx+RumaDGGDicSU0i6NeonA47ziJqv8smJZhYDIYFEscuifvBygMh1UUgn/nj1B8mWSuy6f5Jj8EP4P//xOMaliu6/0DPte3i4T7mgxE2JshvM+qcBELI8/zWHYupoxvj1r9Cx1oiIMOR6eFNHUpa2EmBnWMmGe/zqKFnCsB/oEPy/5S1Z1/VOWOuOYuC7wMErzgRThcnWrumbxclYNNtKGQb4JUODmr6tVSH
 ZeLlxyOs
 cjdby994fBRUUTEtWmiRNk9u9BAWPfc5WGMXurC6PLsmtAg8qQ38gKETyzFL+JSUn4oL+U0o26BXbn/z+ROxoDah5Rzt+zTMr4WzNIZAnIQUJkZBjih7THa8i+fW+tEEYP3uQlfWXAjBqh0PLRY4M3fCH5CYg0HAgQA9GxwKDJCVTtWK08wYeDJYi7JZ8tPg4bQAwjhlXHSBnhQYwimc8NRtoQ65oTHJFn3vY6j8t1CqSybHgwDN7oHXXzhWBoBu/Zk+9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 03:24:28 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> damon_pa_pageout() uses damon_get_folio(), which rejects folios that are
> not on the LRU.  For a large non-LRU folio such as a hugetlb folio, the
> loop then looks up the same folio once per base page even though
> pageout cannot reclaim it.
> 
> Use damon_get_monitor_folio() and skip any returned non-LRU folio as a
> whole by advancing to its end.  Do this before the filters, the
> accounting and the last_applied check, so that adjacent regions within
> the same non-LRU folio are not walked by base page either.
> 
> In an x86-64 KVM pageout microbenchmark, traversal time dropped by
> about 99.7% for regions covering whole 2 MiB hugetlb folios. For
> 4 KiB regions within hugetlb folios, traversal took about 1 ns more
> per region.
> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> ---
> Tested in x86-64 KVM guests.  DAMON KUnit tests all passed.  Ordinary-page
> and THP controls passed the 3% non-inferiority bound in the microbenchmark.
> 
> Changes in v2:
> - Drop the redundant hugetlb check and update the subject and description
>   as suggested by SJ.

Nit.  Please add a link to the previious version from the next time.

For other readers, the previous version is available at
https://lore.kernel.org/20261117-fix-damon-hugetlb-pageout-20261117-v1-1-054ef8760a92@gmail.com


Thanks,
SJ

[...]

