Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C66BCAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 22:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0568E0003; Sat,  4 Oct 2025 18:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8688E0002; Sat,  4 Oct 2025 18:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5238E0003; Sat,  4 Oct 2025 18:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE6FB8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 18:54:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29C7AB75AF
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 22:54:23 +0000 (UTC)
X-FDA: 83961937206.23.97FC120
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7F7FF1A0007
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 22:54:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d5IqzDYe
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759618461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujT45zKa5is3+8neivqZuFX3zu1g7WFWJ9dwConA+qY=;
	b=7UaaHIxc+hjsEh59dWWcdyXO2LPbGUH+EV6j1zysUgcofPJlrRL3vnXAGRJ9Vo/w+AzA4n
	gkubUc2sY4BA8O60J26zA/iniisUcTY4UpKT3Rs0fgfQNi92RgAjPyYStzn7UdP65ygZph
	YEjsEK2EoBKBzifNZBmv8scclh0NHPo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d5IqzDYe;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759618461; a=rsa-sha256;
	cv=none;
	b=8eKS56WD4DdoseJ4pdHzH//Yn6tEqgkdpyA2i/MxT2fw6pGhFUVqLgsV1XipDDDaFQQquM
	rNtHw3z4fJASVPsF52BNdAMUOcHnpaonB6mf8tMJzMQmna8VntvBQ5H2uumSCgHyOdhtS8
	C2GAikLV3mw0EFKG7wiGIWJMMSA3I7c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ujT45zKa5is3+8neivqZuFX3zu1g7WFWJ9dwConA+qY=; b=d5IqzDYe+HXRidEcWznZzwC/4f
	5kRWZwuFXUEVgtUB8JiBrYzNeMp0dHGKbOGpTGN2UYlBYMEFYuYbP2j3lwT4xYVNMYZpwnlzLCI2K
	Woh1QqOBjv5v3PXKJVbqGv72E053WYacalKFdg19OJ9in5Jt2Lq01UzCaFdLCX0UivvgrTrgUPUwM
	kNnPQZRKuKAScSTFv6BFsiqiTTe1XJZaqE2AVQZZPejK38XCxmZRvmHzradrxsVW2WwRIvxLohU0u
	I2eRM1xnKZiT8IimYKpEJLuQ0hGhXSMjje+kYwKXCoWIDtUohnBzGXH/SLeXtW/q3OS6sNCpHUkUo
	kkaA3ByQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v5B8W-0000000DL0J-0gTh;
	Sat, 04 Oct 2025 22:53:56 +0000
Date: Sat, 4 Oct 2025 23:53:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: =?iso-8859-1?Q?Lo=EFc?= Molinari <loic.molinari@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
	=?iso-8859-1?Q?Ma=EDra?= Canal <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?utf-8?Q?Miko=C5=82aj?= Wasiak <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Christopher Healy <healych@amazon.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
	kernel@collabora.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 01/10] drm/shmem-helper: Add huge page fault handler
Message-ID: <aOGlgz3E3kzK1_BH@casper.infradead.org>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
 <20251004093054.21388-2-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251004093054.21388-2-loic.molinari@collabora.com>
X-Rspamd-Queue-Id: 7F7FF1A0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ichgepmrfmhzgyxix5sopn6yooqsx845
X-HE-Tag: 1759618460-345465
X-HE-Meta: U2FsdGVkX187ZjqxSuFwXnwy/XWURd+0LzHrb81/IRkbfAP4ct9IXxQl/nyBK7xyESaH7c6eAcF8GV0AkMnDVKEcy8oeYa32E5PAaBaLV4xBRk4nQkPVlRl7IW6fzJYQ0BLI/Mdxyson4gLMlAgcZ+DloxnFlE0z+p2rKM4jOfHPzplDC4zcNAI+RgmH+FP5SYndkhxwAor6eckN0HPA7AqncpfoTNquiXubyuPEWFETDP6CFzisJgYs1pObZihSKUUanxU6NMshcv+FlYGMta70ABEJsKRaFzC3fL/j3gktrBm0G1wV9dS6BD1SbbgJXDi+ugkIvnJapN+U0Hg1w9qGzf3ioJxvNiKsaaDqadg4iDu8OyXb7BraXuF+pUl9P/INJD2iA/kCbxIK79IqVq8vwZXv6PQ2MXU/J4LP1qu8FXGrFPYh5b/xfft493YC4XiGDn8VbUEpSpCt/NfIjc5Assn5qmpoEYxVtePHAB2JSm0c+/W4I1FNU7HTlAh0+sGLSQAhzrCIB6M+ekaKizUcAi5xaYXDARBX8vbrKgVVURldcoTXFLd5JKw7elg1On1Y4aY3rH4NvQpG9z416nikW5mLDYHYBCl+GYv29a616si2DbBXpySg58sF0VDqywNKUmVc9LI29HQQ4GnbHnUr9A1ZChF8nyiyjErafMbJ1vvWPhCbotKEtHbAvwXYDQH3Wtwfl5uyIo4hD1p+9jTVwWDrbW2Ab943BEeIbY+E5i9oPunJgXbBrO8PzEIti8eNUAHlxAfCjBncFFhxySWVjF2hPdQq/FbU9fXAPpmju+cSmpgym8ciQ4z+QncFs+bYEifpMhPYkZe7C3BCfR55ghdmNxebE7zGyt9XaAF8hpVokv3TtxEyHDSr11dCoD3Macgt/sX0Uf7mQNoTmCEz/G2cingPIfgTiay2D43oHIn6hJAs2v+vr6DuT7rKzdCnfgAJf2mD7pUtj3Q
 zKXR402/
 wr4IWYFEDULn52tN3850kYv/nW+NmG6VE8e4YVxLJmby9ytoW6Y/Fd5J4dpl9mF++lljFpJACDvIKxIfqBgBaKvpndIlZ8AvQimOTk98b/suXuqdT/x5UFlZFpZPGilL9aBU/Hew8bZ8Uj8KM2hezBX0ps98Bj0QlhMucCuQRQcgYjlAaFjy0/0IsUW1ZlbOjyy8574L7P0JQ4HnLYlfBMNgixzqq4S2tC0bZSU23WMmSAWQSX+k5fGsvlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 04, 2025 at 11:30:44AM +0200, Loïc Molinari wrote:
> -static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
> +static vm_fault_t drm_gem_shmem_huge_fault(struct vm_fault *vmf,
> +					   unsigned int order)

From the mm side, we'd much rather you implemented ->map_pages than
->huge_fault.  It's far more flexible; for example it'll support ARM's
contpte which ->huge_fault() doesn't.


