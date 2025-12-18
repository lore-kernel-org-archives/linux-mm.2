Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 963EDD6ACEE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E066B0088; Thu, 18 Dec 2025 07:11:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13D66B0089; Thu, 18 Dec 2025 07:11:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E203E6B008A; Thu, 18 Dec 2025 07:11:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB22E6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:11:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D8AB13C386
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:11:50 +0000 (UTC)
X-FDA: 84232477980.07.52B1C0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D05C016000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:11:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tifMOqAT;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766059908; a=rsa-sha256;
	cv=none;
	b=qkwpukHvmXJQK26luBJf1X5o2ENOMRO5Age7Nq7BEgc5Bu68f8PNB3ydGg48ZdOQ1yaRCj
	TXOhb4DgU4CZRhsaYuucevLETlASl4b/+lHt7YKpwMKXyxK6zMTmbzH7qPM+wknRbmL0/V
	Ui0ZfpXdtJfitdP9r5PBlHZ51hU1koc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tifMOqAT;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766059908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGIy/p7imDzRWdBxrLQLMVz+M7J3Un9N0ejJqyETGXI=;
	b=gnoBnJhVQTXLA1rmZmrrXuSZXaYcVAPp7bkmEHpTGDq8SDbQniF88aRwDz8UrgJuOXrmI9
	9Y1ZP58lrZvZFaZL53qsYD6Sm+abvAwkPBTCJtBZ5fhSVPTFGWIU3NWGywV2AVOaslrohp
	TtDKshBCPUe6pE59W8724Ufl0zabt+s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CBF460123;
	Thu, 18 Dec 2025 12:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515F6C4CEFB;
	Thu, 18 Dec 2025 12:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766059908;
	bh=ipI3gqtuXeH8Ewu4AyGr2xi/tSRvuGR+xxhOF1hRRs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tifMOqAT2f2HQ4jFq5UqKvTU0mF0DIM0ZYg4EcGmCcHD3ApJwCUlaEkx6WrErE83W
	 zfVw+lvsLSuw3BAAGLDj/rfEui+S/6bV25HghWqJhKBGp4e+fYUCabjUaNgq25cdrD
	 fZiEnD2vP+zR4cz6ocWYmBpyirf1rop1A/XYuEpMGleN/Q5WWurzifZBJmaMOrXpih
	 Y5WOnDjFSyI488CRoaOk3uHWiKTuCN0UxLHysQSEoypsYPCJPwmYgE4blkiDEBHUgH
	 5Sd1mLAEAEZXZVQrVYb8pkkWpGDP9UkfhtdfShTLC1WXDD/0oDNb1BM3X/fU2Pl5rT
	 P+LSgV6IuayVQ==
Date: Thu, 18 Dec 2025 14:11:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tao pilgrim <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, kevin.brodsky@arm.com, dave.hansen@linux.intel.com,
	ziy@nvidia.com, chengkaitao@kylinos.cn, willy@infradead.org,
	zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
Message-ID: <aUPvecgVj8XXBcw5@kernel.org>
References: <20251217120858.18713-1-pilgrimtao@gmail.com>
 <aUPiFbuaglcjqiB1@kernel.org>
 <CAAWJmAaxtKY50BEm3N8V1QTwpyCgQLfLFarrVfPVVpXg9ftmcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAWJmAaxtKY50BEm3N8V1QTwpyCgQLfLFarrVfPVVpXg9ftmcw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D05C016000E
X-Rspamd-Server: rspam04
X-Stat-Signature: wa9gwm5ycyeku599ka8e8i5dz9a9rym9
X-HE-Tag: 1766059908-840496
X-HE-Meta: U2FsdGVkX19Xw7YkDrhN6t9Ao3+L+S6QHl4Hbrq2oh9A9l3u0qsTGOiGnqSNjKC9NXqba2+qNQrK2mjU9I/g+Zx69gRjC4O3SaQ3aBIdftt36r5rvtRjcLelTxX1zUoth3xVS9jeeWp0Epz2SjGlGX/8MZsuuYIN1SRARlbBhwYXE1xPnGmn9mgXDiRRL7cVIEVYHnSF2+ocT8XpbaQFs1EvYDj/cojWQSUv+PP7EKAWeHBiX2WQvInUyaF9rqHTstbXbu/+5D+1Gfy7kKOx+KD6EIxPnQQ6LEBzf3vnZ5rWL050JQHHc+DFaRpp5TvCsqhE6mF6cK9OjE8p8LXtxuA/H0nrhzcRUTCkL5R11K5O7hddIrg5Zx7pC0Ipr9lU9a9U3NOc2ff/wmSa9xaVy/chd4rgmXPad7MJ0sXveRx+uP9l0H1RQbNkjevGCINfLy4nNypfVEZmn3+cm1H1sFl5bPMufH911NpeEb1jq44NTBlUoeYZxOxZf3lGnlaOZ8i3loMr6BDQ0MBg/PULfvAjLMKpMMMjwJqHbDD7TUgM4fcraLBbNUFL06LOAgKhS1GtTU4EgWz3o9agEQaIQ1In9Wqc7I6/IS5Y7w9DsQ9xLniyUEmFw52ioY2+LpWrELPjk7K7p1gE6zDPpkz4W/VpT1kFXtljnzHquIS4PMvI/kUqZRupafnbFzB9TlfgBni7ivzq9eF3KC2OgWbrd05CO+l8PetR95yf7aBDpv/r0N2uvr4XX8psn/3c6kOpgrdJfioOwpiUkZLVRJmpFR8OQyKsyX3fFHnbcq//0OzXdXEvoRrxSL/iOGiHcFcZHmoy8/yilD2Yl6cXySyfpxjXeFAS1SwMfDithsIYgmyCoEmiUxlDYmg2Pao3jJvi7IS2OIEPUYXOvsyWYXq/yCyXpQWcmhUQD7Fs1SIariP88DbxXKpElKXAPWMhGNrbAFvs4PGZKqBiOVjTXQx
 vv1rHGvj
 +b4U5Ji3n61VMfi4nFeaQygCT2c2lm476sVkjkaMMl9RbYwfinr8lE8uicU4qtuJ3wMxexu+bpt2xih7rH45qcHngi3P/GXo5ArIvQ82kU7GiWeTqO4kZSFH7+DTDk0aHsBq5w4Z/QmnSM3fpMmunlyYN7YWZYYGyK3C2s3Sz5j+95FVb1NEgOdgyMl1D2r/B9nJ1j6b9h3PceNYtyqrkIwJT9/qMs7ohpQPrp0b6msFsJJn5Fe2P72ia0Mf/jv9iXOFFu168CmD+l3UhDg2oyDcng9kfwXQ45JsP0VbNa0Bdqop/CakSNEO4vx88HyWYKtt58lQI3A96V4N5OW7oNDXSbsiGkdWUn58U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 07:45:52PM +0800, Tao pilgrim wrote:
> On Thu, Dec 18, 2025 at 7:14 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Wed, Dec 17, 2025 at 08:08:58PM +0800, chengkaitao wrote:
> > > From: Chengkaitao <chengkaitao@kylinos.cn>
> > >
> > > 1. Added the vmemmap_false_pmd function to accommodate architectures
> > > that do not support basepages.
> > > 2. In the SPARC architecture, reimplemented vmemmap_populate using
> > > vmemmap_populate_hugepages.
> >
> > What problem this patch is trying to solve?
> 
> Following the pattern established by other architectures, vmemmap_populate
> is reimplemented using vmemmap_populate_hugepages in the SPARC architecture,
> which fulfills the intended purpose of vmemmap_populate_hugepages.

But what's wrong with the current sparc::vmemmap_populate()?
 
> The functional logic remains unchanged.
> 
> > > Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> > > ---
> 
> -- 
> Yours,
> Kaitao Cheng

-- 
Sincerely yours,
Mike.

