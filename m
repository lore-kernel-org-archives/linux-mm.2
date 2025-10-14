Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1FADCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 04:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FA68E00B9; Tue, 14 Oct 2025 00:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79A18E0007; Tue, 14 Oct 2025 00:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59C38E00B9; Tue, 14 Oct 2025 00:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A23858E0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:18:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44EB31606FD
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:18:37 +0000 (UTC)
X-FDA: 83995413474.10.3B0E675
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf28.hostedemail.com (Postfix) with ESMTP id 555A8C000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:18:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760415515; a=rsa-sha256;
	cv=none;
	b=VlAL2z6yI3fCQ3UbdrpdUruT2K39CiMGEHAjAT4+6z2Wt8te4gHLNkgZkNesUaDzy6N98l
	vn7fLu0Vs5ifLX47DYFN11pUMnu4RJ1gtVCAibcSuNRx5I7uFIZHK17wysXHXbT8hKF8WK
	+dumMAQOohS1AAtrfN/tdatLu5LmftE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760415515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=iWtd/nALOpsfHuLAFi4FmlJbXjJ51Y5XNgARs6xua6FpsBCYTeyzkirfST9v/AcCDSnWRz
	iNlCuIsznG63ozlpk+7iexjsDpydvnZ1HsFCkVoBN25rSGkaVlL5Jz6CdfP3okSB/XcjGW
	XEfPwne968kyp/1AsKblgo+I2gwd1qM=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 528D8227A87; Tue, 14 Oct 2025 06:18:30 +0200 (CEST)
Date: Tue, 14 Oct 2025 06:18:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove the BOUNCE config option
Message-ID: <20251014041829.GA30344@lst.de>
References: <20251013095620.1111061-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013095620.1111061-1-chenhuacai@loongson.cn>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: usn45apm7d86a4gnittn8qypinbkoh1j
X-Rspamd-Queue-Id: 555A8C000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760415515-377113
X-HE-Meta: U2FsdGVkX1/GuuSMVmyI5rycESW9+Rl+QeEY9GSEDAflg7GmtP9Bxl4JPQwRqNW0QR2PGEqdYhCPDmakTvPzoK7DSn4kmi5ilAmhh4pryuvkmYQKxT/aVrFZWFAf8WIVUgvsnzhZlpQObLBHVJ4AkjCdMBdloYOQVtjKUOtn4eJEo2T20S13eq/8SBSSCgjFzAESiTtXO1jJySC0qVPP7ebJWinzUL2PFOi7gcyKNEfiuReqvkWalPJ7RtfSuzkhq8a5NN2t8OtQ3ZlhCarVdHD3q3pVuDJT14LnIPBmZ0Z14mw/OGSlL8MyYmY11tW6M9qKTnKaQv1FXa8NDqW+o5SKyhf+TWd9TDNrh/SCtyo0O1xF2GpdVd7rF7hpEHMSkGMxLneNiyYkbGS6jpYqlNNVKT9JepACbJ4GHgPqdM/3CT0yCK7UTyp9LxOiXaPHUOgq4Kl65OGkSAeFxUW2JKNdlN7Z8dsyCA9Og+IHZKtcVAIT0rT0AfHLSI5h1xmDbh4sg2RGAljAxDUX7sKLgObb6CkHRkmVKCVh+XVCmm19+4egKZGHz7m1hzhIeRuExph6btZZD2DuRO2GROblCqh1aHyWO7pgVbyk69oV15zsQBkjF26NvuGWKWqXowxhTAlsDYFL0hO72v2Cky8dU0XXMfMicg890TYObQ3aOUfjd8ndYb+BN02u2Twpo1CJ40nz/yJz8p3Pq36SltaaZOR9UFlQTox37mXLGC204b3uAxsW/JHQMXMCshLDX+ZecR5U3rRacXEnVUVWvizWbE/CAuwmNcMIEWndws0tN1ABMSmYHpVOj/eZMpWvcyUaDRJqaA0ZtyJEpXVQUszUAUflNFJdwqBu7OHH5foXfTwFho0MjUagi1XOOCL2H001xdA/QLrZ66g43cAbgNMC3ZFQbzKEFflXb440q1MG7eWKK9xQQgeh6z68r922e4ie+9AlRebdYrrNe0LqR2x
 xdFW7zIL
 rHj/YOKVk8/WcvsW159V1Qttv/9xjuUNbBbnBqiMUE7qrMToUlmN/Er/F8OBUU8Pz1vWBp+UsFBP3Jsga2/QNUtGn9xVTWe14UYRWozuZSiAja7ldIsa7SevIWSYzJNCJMWtYpl6BmZwIIDwI0hBjWdR3CaECJGWGzKX3IV2r3qGG1z7BY5Intd71NUtzvBNvJh2L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


