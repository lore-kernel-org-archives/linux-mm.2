Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC4EC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2767A6B007B; Thu,  6 Aug 2026 13:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227E56B0088; Thu,  6 Aug 2026 13:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D626B008A; Thu,  6 Aug 2026 13:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9AFF6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:49:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 812F41A01A4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:49:57 +0000 (UTC)
X-FDA: 85071582834.01.DBA5D06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DD0AE8000F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:49:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUlr7AjS;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786038596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOPx2EyXFY1KLS8DPm/AyQOQWbpHUOBhNVa7ZrJKkzQ=;
	b=07s1bYrgFjvHHHwDwXuzvosdfIPq0Ek7McZIZMBpgtdA6gvl/01dYG2AcnKI0INCGeNb2v
	cVfeF5ZvH6tbqKeqPwnlLCUNAvxmKK7fitm4xtNhANfjUvXftboC3e/Z9Dy8U9+JpHue3i
	jPlIcBxSjC0E8RO1ImcM5ymkrzt4BR8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUlr7AjS;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786038596;
	b=XpGXTF3fvFsQFcyXNnwONIwLV+mRb+c/Rq8d7xCBzK/adZ9ag0L+4/8EFpoU4Vr93jHxlv
	ocK3WbUuUC2K1p8LvpO0CsEhG0CKAzcFpV8dL+Z4roQvmf9gxPx3wh0ojlh2KEiBAigu6M
	qKMaQXKl3AdqWMyHj4Zs2W0/cLJU0kQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 019BC42D76;
	Thu,  6 Aug 2026 17:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291331F00AC4;
	Thu,  6 Aug 2026 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786038594;
	bh=WOPx2EyXFY1KLS8DPm/AyQOQWbpHUOBhNVa7ZrJKkzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUlr7AjSkJs8mEMsMOzX9NYI5Tn+OWpi3UjyL0C7eQ0PMdN5K8mYS+ctM1hwCOKM9
	 ck6Eshd+LzCFYrosbPzE9bcvsgB90VaIz0sdLZg0h16nuz/sH63+64Ir7rJA/CdamE
	 LJJ/zISNh/6H2c//99gjZNTMAlGa5gCpGD38BTFqvMOSVLrYtqsC6TNUiEicMacCEb
	 fPtKEQh2PbChvEstKttp2JdBpoQ8G46RMyoExXvc9Xmg/oJv+UdtXlOAs0Y7gAnL1k
	 xMJz57HM6FMNYa7fbvvr4oVhKNPXsbBKsEs/+KevSZfRlD6fyWF0WV5+BUvelYfMVN
	 bNMT84CAZJy7g==
From: Sasha Levin <sashal@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Danielle Costantino <dcostantino@meta.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Hao Ge <hao.ge@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.12.y 0/2] mm/slab: fix unbounded recursion in free path with memalloc profiling
Date: Thu,  6 Aug 2026 13:49:39 -0400
Message-ID: <20260806131001.stable-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806-kmalloc-no-objext-for-6-12-y-v1-0-036dfc3273fc@kernel.org>
References: <20260806-kmalloc-no-objext-for-6-12-y-v1-0-036dfc3273fc@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yb5gjnpxqnppqnmubwykmjij8m8r5hwc
X-Rspamd-Queue-Id: DD0AE8000F
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786038595-998492
X-HE-Meta: U2FsdGVkX185O3gTfXa1K2x9o4JGMHAq7fvTBdDaiD5IDh9rxKanu70k2nbl8/uV7gebtr1nDkd4pJC/iAh2+NYBJWad719pLVQ4h472WNqxtPGmR8EAbCYTn4TtgAvyM/l8kbrtLLEnoo6RtjkO4k58DHhGULp8whFZdlFLaBaZR7fYVkgD7bbwKWa71CMVAZNUTNSpYtUnPVMYbtdb05+x1vmlYcPevergr7fX9OTvt9kVFd6Gc8Ou0x0GD23r+aDVNIQ4U9UaNqKOowV43Mb4bToPIJvKwatgezkILqOcPJzHqO9DXthzrSqI2JbhpEn59zc/4BXCUKuAFbp9VztUAOgkw/ODc6aGx9z7Ynrfw/esDCCGphwJ0lUHjgwbV5VBH4IkI0LOT3JVcMk7qEwn3Cj/ebHdYq546FijN8BCYbblvYVLcWYmlCuopSpWKGOm4mUs2hI2Abxtc2sAqC+e51tD11Of20QUVmLxs8LaamXt1UwXKTJV8TJhETbpZE9q8HGRIbZLSsz9CPYmrUHDEsLvY3rvYd0Qgp2lOi9ewbadN5v8+w1c/j6e+3oC2jAtlRLN2+3a3jSrId6RqDjX2PMxViNSx147ozzHu9i0DPtHSRrDXbXW86GfgBC1Fo5Z3CyPMuGHuM973KnL+InyEfm2+kGUX0Rs2FA1qAFhG1WKtM6wGSSnFv2JiajdpjQRE/Llxv2Qqvo7xqXJrZX3LsOWpNyzkulaMJR1Ur6TbhpSu18UNzGgbxawyQ49OhT54AebZzfesNkDXL1KcdYdc2wh1gWfs3/9U9RAM3ZbKc5hTA5ZCWzFE9uOZ6/L8mXtqULp4ZAjofxb0MZsxXyTY5LV4Npt5fZzv2ZohLI2rZThVRaNV68b/GOyodKdIgOCoW3GtIO7oUr7QgvZkrf/Hb851Vxqz5SL3hmIA05IsDxB8nMGePTbNl6fIGz8lKwEyjULKg7//eVK28F
 3HQz5BJG
 ILPQGXpfY0gH+n8IMC/hDXpW6CP+V23u6K7wZ7srWL6kwiq6hH0RlmIwHumGTStxck0jj249aq2VBiGS8Md6v0yPca3YTe/BV4BK04V2uoeml6qeQQlI2rkIKq+9obltwuPyjqL79RHsyXCZZCn3JhIwjyypy21FGtn5xl2HSUC67kwhjPGD/lDvPNzET6Mz76Op9LcALQ0vQkG2faoq/e+DnLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 05:37:40AM +0000, Harry Yoo (Oracle) wrote:
> This is backport of "mm/slab: fix unbounded recursion in free path with
> memalloc profiling" series [1] for 6.12.y.

Queued the series for 6.12, thanks.

-- 
Thanks,
Sasha

