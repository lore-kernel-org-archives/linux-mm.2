Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2613FC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 12:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE4A6B008C; Fri, 21 Aug 2026 08:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48536B0092; Fri, 21 Aug 2026 08:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10C36B009F; Fri, 21 Aug 2026 08:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95F116B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:14:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A75580446
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:14:04 +0000 (UTC)
X-FDA: 85125168408.26.519F85C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2AF6B20002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:14:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F9xZm3D5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787314442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTo43XzM9NUgOXbGuwfipf+ydqi6G4CBeuCh3lZD0Nk=;
	b=ahAhq+HDV8YvGYwDXUQjBNfva8OdcMpsxpueiCbt/qWpRzP3SmOMGemsa3iGUDRaiJfi23
	qdrWldjNYmay69WMNRyV5HIFA6h7dOc6DQHBWx+wP1wEjJTEEcJJuqNpxrnAn/hmc0L0bY
	7SVYn/WNK98KNyuRWeukSdN41giTvJE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F9xZm3D5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787314442;
	b=4En0pJK1fWQ09CQJZvUrzdPDDPHxjNhef1sgR7AEEpXA5X9A8p91nQXiA4cHoMKA9WrNpM
	OPheWggEI88Ca8xl2nQ3W53WVFuM34BdTeSxDvIlTPxtoCA03XY0S2HkkJKsgJXC1UqSgO
	IRfbSavuy7B6UcryffxO3Md+XDz5dYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D02A43208;
	Fri, 21 Aug 2026 12:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC09C1F000E9;
	Fri, 21 Aug 2026 12:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787314441;
	bh=CTo43XzM9NUgOXbGuwfipf+ydqi6G4CBeuCh3lZD0Nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F9xZm3D5H0/Uv5L4hcfihUo3fdiP6Hvgp0pL/WqUhjpGaOHM2CVV/0ptIq4eKlwfK
	 FsPGqXS/E+8QkznG0QEk3zwevPO6GmOxy1mZlVl91/S4q7FhQAQfbYxyyAGfWzpB5n
	 OCUpZ77tYtrAeWk/VAqHntzrrgAsg0nQF+R5T9RyLubhklm2BaIwHcpc13hTm7oG7s
	 2e+nAR1EluuhNQzeHyeg6+CzJp31+v3WbFpm9LZh/hmCajLWCfVkwO/q/fiSz2bs8T
	 aREXF6K+WifJQlwID5ssZx18r4UwGI2/7pBkL+tj3EQuicn5+G47E7sP/7Axyyyw5g
	 wwY/BZMJZsBwQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 70C74198003A;
	Fri, 21 Aug 2026 08:13:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 21 Aug 2026 08:13:59 -0400
X-ME-Sender: <xms:BEGIavtIAoKVV-dIUxyA4hb9b8Po-Uu5F4VgIusSrZ-ftBHmlY5jng>
    <xme:BEGIat7ayKzrTI1y15oHrgt9rZjGhVRwJ88mUjdy-2utV-KQfaBZHfbpZRKTOsW5J
    v8M3wmS-gpiooODj0JS8q1hSF7qAOVENRKFg2zDZ0BE_mquNa5yS7e0>
X-ME-Received: <xmr:BEGIaitgIW0wcqLrWhbKFvZzMMlLP3dDs7o6QqHmbf7_EVtuQx_kzbO0wZ8>
X-ME-Proxy-Cause: dmFkZTE9He33vT2aJi4Pjqa5rACtwZDlVpfI4pvolegsHlra2/oFh2wdyqtRnKCr7ywq+M
    g7eAQmzQdACCzrovzxZQjZLPJDG2xAorZP57RC0xH50KqrbUdypzNxr9qdXRN4bTf2+ipG
    8BG+yoJanZ/ks4GQusJQpsrHrqlZ3pkbjRdRuXzpOg+mRn7rz7S4lVv1eYWakrw99Kah4/
    iht0P1kYzC2LkK1mqvZMgZ/fsSwfWQ0upMFvWwktgZqJ8iC+7BRE55Digr9Ry7WRH9JFi8
    Kb8wR85a0slyGHElPl+sDK29U529kPWpZH9uxTUMneVTVAYtIdFqt6xqapZTpJeobCnjZA
    AqhU/FAlDd2ydVSCS0xp0Kdh2Si9jol+Uncq7lTx+VsGBLBu+IKT539uBKtN3GnehctHc7
    PTE77HXSbIUf1+t/VygZXTi6eWofINEX/PrxK5Q5yrLsnEup2U33Y9sEl0T9yP61BGppub
    7ZyzSoH+MLna6iFwrY8dl1VC41tjkoWcU1GuEVkP3F0nTIl2rcNksi99bVv9leCNaHtMsI
    3dcMTXQ7Hlvai1j4eDWW+W8HeLhNHOFJqNIzkL8bA2xvH1EE5/bDmVwuUqT/BokDhXDCG7
    QzPrrMqNBqe3DbycJbEiKK3Rk3nE1WZz0CV1j0ijiJnEAO5aRQTAHZJnD9Qg
X-ME-Proxy: <xmx:BEGIav0shc_srJcckxhEcn5oDMYwQ_YVNN8Y9Pwq-DETg5Yif7W_tg>
    <xmx:BEGIav_NHwxVYGOq7rLRpIKJRpCtPiEYVsIEHb8iVFOJ21eGKAgsiw>
    <xmx:BEGIalABELee1iEoH2WNi7ANrrvQWoPgk9ckhUDbzIpxiLmT6cXcsA>
    <xmx:BEGIalDYjzJR1SxX6hy-1IWiby1sZppN-4yzHtO09zhnV0C29Rqblw>
    <xmx:BUGIalJZZtHDigw0yvLmfJd05hNqkKQNt9tE914dP_xZoOBxAW9zpEUg>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 08:13:56 -0400 (EDT)
Date: Fri, 21 Aug 2026 13:13:55 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aog_uH5fTsJzXjjx@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
X-Rspam-User: 
X-Stat-Signature: y53xcd685fifqbdwut34j8ms19g1zssx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2AF6B20002
X-HE-Tag: 1787314442-923249
X-HE-Meta: U2FsdGVkX1+wct484jteKrJn5DY2eMEsfrIgXQdmReTJXZNW/9Mmhyksrf7AVg6NxvVPzfxnefgQumjeGtv2pV59WeeitplpGBCvJmZI0nAW791maS/hmgNj5qTRLX94s/ZpUUBc3Q/PYwPqaqqN/cruV0jBKXsUn+oBWpA6O/SbS1bGKhnYwKatU4OsCRhZ12DezaPIlhTVtaNs/WnbHj7DdOxukVxxBYN0bNfy9ik59gtncvQfWuMgW+NzXf3SMugahH69Use5dnwxMJx8SBXexFsNA9jP/3YzQYqLFYIKfXeQHGYb7+pGWVpqZYGYG2bF1UhmqBhGEb6kPnMuhrVtBrrnB1YrNftWhoaeB1LHsuJyx24pSJiIIfRPJld3nEzdnSeDXgWByqK9wjDYpPidslK62lLY7rfRYCQ5C9ee4U8vQM8U8XhgQV0m5dfxNVgD9wT00JnqgOcHpIveRFilzSyRfgIgOWMzE96UxqJDtvREhgQVPLkKvf/fTB+4g25Tt9qwHJz5AF6bcT+BT26ASETAFSw/vT2Xtbx9gjh1AWrCoRHpJucYYYEoQiL9uS5v/gCZFXI6rCNKx17nLsZuWFCiaorRmuMPWVBWfls1hY0uLUxJ2WN8ljIRcTAoBC6v+mAHfmQ8TYhFJe2+RH7awJpqMYpxfiaQhVc4EBvRjydot7mY5W0Eypm9LCc6jpGSiEIXQgv22RtN9XmBEAH0Oj0i5448RvSl3GbfyNBJgcvPS8bqDaLEm48oqzOUyQ4awMKPNxDgA00kaUZB6WuLNc9ljBo5DxVkDq5pQDCwufb4AxkrNzPZEHI1mFim0ZSy/s0nTMLWLd8GLJVdTY/XT1BCDbrvGMV6/Rx0FuyXAP7zzcSQQbPvJf/pJFTdqC+7XsO8K4GpVBrkNShnIcppb0hQASuIqZUC+Hy2oeSfzoWZfDUzWDJ7fIT94kHPgNFI+F6Icem7tcyUm4x
 JFVGnazC
 Yjk01K+2cwd0uuzClSjl4Mh8nyyVPOalrKm2XWLo4nDzVrTUGoPMZ9IdtoXmz3DUktvlw41uA1gqraEiFazdofglnJxRXrQLGIRRYrmcREp7LDgC9CaTb6pCD/esNJetetZvRMeLxuztovKUZ0PgIUSdyVSGlQ1S3uAXUqmQqHmoFYPPEYvFMVvZw9KLVDmOwaLu2vd9wOwU9ybwiT3RdnQeoYrCQlB5lPbmk/yuWmUgk5XUoe0MoprfN9H02q91Y//w80VAN6JOWdDHhOWAtzLbuSu6xngE69oe0hOvp/il90Jq5vHCar4leZKQEm4QQEifyPRfmXAJr7rpS9Dj78qD/mwh48d2WrgY1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 03:06:06AM -0700, Breno Leitao wrote:
> +	/* Reserve the table itself so it survives a further kexec. */
> +	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
> +			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
> +			 PAGE_ALIGN_DOWN(ppm));

Hm. I don't think it is enough.

On x86, kernel doesn't keep memblock around after boot (see
CONFIG_ARCH_KEEP_MEMBLOCK). Reserving in memblock exclude the memory
from page allocator. But kexec can place the image there.

For !CONFIG_ARCH_KEEP_MEMBLOCK, kexec uses walk_system_ram_res() that
looks into iomem_resource. And memblock does nothing to exclude the
memory from iomem_resource.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

