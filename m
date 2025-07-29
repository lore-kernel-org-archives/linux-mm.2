Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C645EC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 12:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ACDC6B007B; Tue, 29 Jul 2025 08:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E036B0089; Tue, 29 Jul 2025 08:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374066B008A; Tue, 29 Jul 2025 08:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 279326B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:51:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D91F51405BE
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:51:00 +0000 (UTC)
X-FDA: 83717287080.04.AEE4897
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC1CD20004
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:50:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=f2tfzwpP
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753793459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJjEbiV5g+NYVFXOD1NeopHaTyP4OV+DoFwiBySnRy0=;
	b=PwYrucl5Nm9qjHCjNGcxHqO2yiM5hnAn1mbiTkCf6FK+o4EOCUwfSwYMDEWyIIKXj0Mwk5
	Ri58NgYwkE21IcYanJhX1bLKaR+qqrrCOzupYLwUBxQOfaXS/75pI9P2Qw7lYZDyLGqAiJ
	yLv1j2K2mE5ZU6+d49txawbIzYrO9VU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753793459; a=rsa-sha256;
	cv=none;
	b=48EjXW+XVPy41mFp00gOFBz/KOnj8/JVU7NkCsWOn6fVJe7XCa7g0pYXZJP7dh6boNDo6I
	WTJ5kjw5AAFzlPrBnspOm0xJRG4IrlelEDHvpjjctswkDxfqdUtL779MTzHVSj0RoxDt6Q
	mn/nwED7XKoQ/nG6NpaYSZnps/2YpjE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=f2tfzwpP;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pJjEbiV5g+NYVFXOD1NeopHaTyP4OV+DoFwiBySnRy0=; b=f2tfzwpPeWAKHfEdE1Bxz0OpBo
	VHp1WpTQls9sIIxpPnNlRtqNh78tB54Mv8Fs5MbF94ruMzgkyGMxsNSZOLfO4w/9GaFlngs6QT8aL
	1CrUE4YaHzq3PzXFhLEo1lA7NMC6kcnj/7QZ0lsLMtQBH91taKBm6B2s4c4ktsa9CKycxPNN+Plcs
	3Hv8XBZheIvN5GaPXLJqUyzThZLsNFqQ+UxBgd2HWbK/JI9QrbtIjeHC15/CgEC9/D6K626A7wbyQ
	IZpfXYiQtTJ4bdTIpo1iTEL6u0cMJ1sgsJXIl33unEHxkFEB3zd0k9A8VXycb2KgbjFKEoy9lE2D4
	T41JJTDA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ugjn7-0000000CRmM-2hyh;
	Tue, 29 Jul 2025 12:50:49 +0000
Date: Tue, 29 Jul 2025 13:50:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "akash.tyagi" <akash.tyagi@mediatek.com>
Cc: ziy@nvidia.com, david@redhat.com, surenb@google.com,
	akpm@linux-foundation.org, vbabka@suse.cz, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
	chinwen.chang@mediatek.com
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
Message-ID: <aIjDqeQR7t3ZlD_C@casper.infradead.org>
References: <E70C1648-DDAB-4027-AB07-1C19B10C6AEF@nvidia.com>
 <20250729123028.1224786-1-akash.tyagi@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729123028.1224786-1-akash.tyagi@mediatek.com>
X-Rspamd-Queue-Id: DC1CD20004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ouzys9ht9sosgwidpykrehmm5yz5kch6
X-HE-Tag: 1753793458-305734
X-HE-Meta: U2FsdGVkX19CwnWwjwvt2eHfEMbFXPSC18SPcCLA2X4c/MQtp7L0lByeNH9BR1QJebctMckw0N9ZJwzkX48mMEwM/BG2Q5SycxFsemUc5QJmpVQZ0ltz5w6yEUI0F5f5GK6UYFZ8eHWqgNxhi6nUUfuLW4hZazLDedFWh3Cs4kEuJEnhhlgpdh60dCSHSAXkVhIMWawU1O593QXdBYVIzH3SHf+V+Ahb1YqDCCKwS8/W1Z89d241xsWwa4WQCpnltbo6d/dXjmYZjCE5EkdRL/QgOk75bgrlDyYwSdD0WqV0DGrwEZxsScmgBecKpIRQ4BHpC4T+QV72+BaluKPhzFPYN+2MjrnbRAH17IAOyBa2oScgh30BswbDUI6a8sFGvuEHO6ihNyD/hCx2rrub1ZLjglJDdG3LI98GiIadXOkzj0CVCdkA9j/JH/Bb106vTJTNuaxV/eLtyBZz0/RJbLrAd7zLLiC+5wVfoAUWGnaYrkyG4KmHPnH6c+Kx0lBMEAaXD+S93LI4RFRHLGY3EgxKYrVVlOXehQPBv0/XaiAoA+awVjK7HAE5OZ1Eco/WBN7ZjW2uKEw+HarLVgJMe84BiOWjdFtK6TKDh/dTVKS9lUIq9ydYgxeZaFyKOQbLtnboQoMpLN5DbkYYY5T7eXm4D4b3O5sHfaGr9PmYTt22yb1k70/Gr2AXr/RhhBkjF2Bvxdr03xA4OE4TvALn5PVL4U3DkaiEj0DLUa/bBXROyoT+zwZpH+OtH7LuCGbtnNDraFFISHqjgbp32V3BA01SRKAX4zMUrapgL7U/lezG0C3fbJxK1oHMZxdf/9Evs9YUIneSnmfzhnyR85qHH0+ur3Ct8/DpENhS2XrjyIT96ZL0l2pXInn8S4nH1gWP2C7Sf7jHny8hYfDTojdpzBZghlWpPOt05PXR9FGXh1tAMN1lfV1uA0BSz4ln4GIJlphSPwN8nO06Gw1xomB
 3e+eOKNm
 4SzehsYaCC2WAoDQaGJNmjVgm4UXuzK7cz39VeTz7wDV4thROoL5bN1kBKdvcZ5r56dqwW34Io89GWNrzPo0V+OodO/lIsml9UznijcH3PTgDO7hvXqYrUV3IKpK0yIKIRooOPyrFdBAURvdrlUQpelGTjSaLEmFVSwTT5va0bwJ7ZJToR/D+9Tk+a5acQNtTAoSGZcH4HQpPe9/8ghEJfE1js3E3ddBV3cptPihcfGWDobiddyfCtpcJ2eJX0YKZCvF7hmu/vw4Q24SoHM83JvQgPOO7ekOpyqJARF7P49iRX0FJrlH3OvwY62dEPKnDHaB/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 06:00:28PM +0530, akash.tyagi wrote:
> Additionally, android kernels create cma pcp list for pages less than PAGE_ALLOC_COSTLY_ORDER, but not for THP pages.

Why bother?  If it's a CMA allocaation, just free it back to CMA
straight away.

