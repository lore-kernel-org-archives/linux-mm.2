Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51ED6C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFD66B008A; Mon, 28 Sep 2026 05:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070556B0095; Mon, 28 Sep 2026 05:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1806B009D; Mon, 28 Sep 2026 05:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC6386B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:44:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46D83140153
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:44:25 +0000 (UTC)
X-FDA: 85262685690.09.258F2C4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id C564540002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:44:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1rEYD66R;
	spf=none (imf07.hostedemail.com: domain of BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3vCuvsycw4sSgqHUBL1WfDqs61oYOwO3Ein0oVSivE=;
	b=6vHfM13QQwAaNd4W2WnXfYpNk2SzddB4X4pzUmof8p6ce4zKLNfzDMJ8G1h3bh4f7FEC27
	dWKrFZoLw/F+DxOmaKs3f9o6iXzhQ8F/H6LH1mGnlOdYlUep57kON6CDH5yDjYnv23hAaT
	Lz/gQQ62G2qH6LlgtfJ+vfgyTgqLKT0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790588663;
	b=xPXeDjdY3YsdXe3oLgSiBvhuMMozyLxYJt1Mvr/cINX7qLBQo+BYikTvxkXEv+9ZaUvjHr
	uYKaqUpUxd7qNm0YHhheKu3uLE/f920nroV7OJ+Ss0l7gk+As7pdPuGoUqtgB2/ZnmPdPk
	hC0YUwwZ6N860015OQXSBg+e9g88c7w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1rEYD66R;
	spf=none (imf07.hostedemail.com: domain of BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V3vCuvsycw4sSgqHUBL1WfDqs61oYOwO3Ein0oVSivE=; b=1rEYD66RCoxQv8dyttaZqn4T2b
	cGVC3QeEfZMFjzIypKtPj10LdufhjRiwK9cumWHnXjqAq3gzCbGz1S11J+FGrzRNiSMWGgVtZoU4b
	1J1zg9aBJPueRkygKndaJ3a45ogFTQ7xCF4p0NObKYV4ZMooVHXvFvJKwDPsudGFKardWbS2WY27e
	PW/aS3LXbqebHbFo/rMtSMHXC3x5k9qQpeKmgMoB8kMDgl7EcXqrxqo3CtNyHN1u6P5umoT2TY8Wv
	o3R0udwwAvmD/rO2iTENnsQ/RVucAZoxqgBvzz2GD9zNFhT/okLs2AoZjf6xskZgZr1u+JWK7VNwE
	mEUyyR2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB7uD-00000000G5s-14j6;
	Mon, 28 Sep 2026 09:44:17 +0000
Date: Mon, 28 Sep 2026 02:44:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>
Subject: Re: [RFC PATCH 1/4] block: do not issue background swap bios as root
Message-ID: <aro28ZGuYgmNg_n5@infradead.org>
References: <20260928081900.4187482-1-alex@ghiti.fr>
 <20260928081900.4187482-2-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928081900.4187482-2-alex@ghiti.fr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C564540002
X-Stat-Signature: wid31i6z9izymz1ts1nb4swmrjm69yib
X-HE-Tag: 1790588662-556312
X-HE-Meta: U2FsdGVkX19d0IU5mq2d9GUVaDlK3j87jcQ01KmEG5HwwWHj97H+1Oi+BBk1mYcGjeb6Km5Ujgp5G72JvxWC6lMXmeuU37gz3WQJev8YoC/QAVVnlpQ7fBEaEvQYFgndcT4ek4Ap/93c3TjwzjMnXHuXjMP0eTuESs4Z/AU8Y6axetvP/b1WuFyHx63Agpkd/D8+Y5EiUVt8coRKdBkwnlNP/VrRUrT/m5wc9QN37j1go66xCznti4YxLNUDxmlyflYdMKA/hA+oWIHwHtoEmLYRUqyUiNguSc4zjjASR31NMRE3dgHyyDZJPQmh+rITD8gVpNA0dIeRgHMcVJwghL9Vth/8CRL1+xbbjlUAKwus8TU2503+PvJfeQivRHKMGGOtffYKUA0Mz3n0u6L8w40jWULycZtDMxkHhOVbM3Nc6pePCRsNEyqBR5sQi68SoRNDES9YedUnTgIQuMQa3HSUteGveZsUtvqCpj/i8Cg7NYt+6QN+HMvkiT7KJSGWswQr8sbW8dl5omQejKAS08opbyxOLBlp32c0+Z2Pkwhbj2ivE4Ernw6w97tdXT7WJrCJZ1+APyKGud/3XaQtDTSDMZZumozW02OFDXaPuDVQ5vNqrY0Of6i/uO0kNSSvdJILLf3Bw0agA/lLoGdUh0MAVI1Oo/2Z5VQEj++9ZS7jO5vvE8TRxJ8l+BSOXUIq7F2ttFOFZZ14HdfpsLvvg5V0bMcQ0nnh7/qieTmpClcv7MEC4C7wIL8piDC6vslvgYy8H0Xh5IBucAMVohw5CnYqYwyw8CACKY66Z/q9CJiey+HzYd/YqMhivAYWacuRC2eq9AR9Qx9lQE/H2NOFrJg25A4psmmm/dOrzpFy/7aijCXk/PAKKXgr0sg+68zAga4MQEtmwTGiQPfzHpltuVkfvY7eefvNgB0svNyhtdCAXXNBJ27u0+A5qIb3FWlVX8Haeq6PWi8unwoWbcF
 NAiQDNcd
 +KowLbpgFCi2LmreNy+Cu4cQFM1Yn39VNRULwbnsdnY+s49MlTagRx48L83U9zFmxHJfg29MnaLeEfMEebHFdGq6+gHAVuLbmbQzPmvgXEJL5kOqUG5DhVEFXFYcwrhRzpn2mFTwKrOF6oQkHptk9K8krrPnLlMV+JdMFkYymDO/6nEDl6Mb/sfowgW9Sjo1I62TV1BZaaeM52k+uLwUH13jAVu8gl+/7sohM8Ty1hEtVILQznuNSeC/cA4QKaPWzv3qsMP3hAwuWdIaF8oKZVvpcB0mGD/Ipuz7PEX+VK2KKgicMi9Uyctsr52CYOK/7m13tZCcDIcJZJ55vTqthYkaNPDtGSUPQVnChkGDgjU/DcgCdNym3kgRWE5ZnGd2whLG0WiQE3/KhrRILuG6ex1dRf8mNHYiP0EouFQqjRJEG82lS/HXDP/pFHUcMOAC6aGJJXdpMnegZOB7xjdC3GRqu02TRHjRq9X5HFoxZ5cJUcvo3kiBo2cdRAYfgr6UeSz3wOaCqukkNSRIxPf8/NqI5Llbz4Bz2AYqhLGnOiFAz4DUZGBDc6NtkPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 10:18:36AM +0200, Alexandre Ghiti wrote:
> bio_issue_as_root_blkg() issues every REQ_SWAP bio as root, bypassing
> the cgroup IO controllers, because reclaim cannot stall indefinitely on
> swap writes. Some swap writes are not urgent though: zswap writeback is
> best effort.
> 
> Such a bio cannot simply drop REQ_SWAP: dm-crypt and dm-thin rely on it
> for limit_swap_bios, which caps in-flight swap bios to avoid a memory
> deadlock, see commit a666e5c05e7c ("dm: fix deadlock when swapping to
> encrypted device").

Is that true?  REQ_BACKGROUND very much implies the I/O can the throttled
and thus better not be foreground paging, and thus the caller should be
able to tolerate a failure.

