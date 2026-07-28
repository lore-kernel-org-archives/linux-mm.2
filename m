Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93091C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 03:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02B456B007B; Mon, 27 Jul 2026 23:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1EB26B0088; Mon, 27 Jul 2026 23:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DC36B008A; Mon, 27 Jul 2026 23:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B482C6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:13:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2494F12028C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:13:17 +0000 (UTC)
X-FDA: 85036714434.29.A0EC263
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id D5A4214000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:13:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QABHcAm7;
	spf=none (imf23.hostedemail.com: domain of BATV+695790e2dd2d1c4e9532+8374+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+695790e2dd2d1c4e9532+8374+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785208394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHN+9hNginFL/FCYHigLOr7fyStAUtGKteBBOUHnsmI=;
	b=1EHytx7572JxHj+B3D8QoGBdQv1fOWqUflizdDpgKLd29aLbznlPK2FPS0y0Laug1Ff3L6
	MHt41X8NMOI8rhAmJMD407s60RqgOsau0dJZ+GxIWURlsGyBZLDrJPReXwrnCu2O/d1fu6
	KgjxNjbHUdm0Rd+VcGQBbix5QMGcQ4c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785208394;
	b=G4SiB9LzLUov4xjGFi+heCuoQPx14VRhdmseLhbC28FBnLS/ivUA4bS8DB3XXPR+thYYoZ
	rS96zVasSS1rR5i2bkEmLzIhzwPTk3nVLgQun+U1AIT2G7EvkLAnbxnsabKIGFGtgzajuL
	Rn6N82krnpmBqGMQn2NWvgMpD6IpTNQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QABHcAm7;
	spf=none (imf23.hostedemail.com: domain of BATV+695790e2dd2d1c4e9532+8374+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+695790e2dd2d1c4e9532+8374+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EHN+9hNginFL/FCYHigLOr7fyStAUtGKteBBOUHnsmI=; b=QABHcAm7QJS9+/Zh2HsSxmpm++
	r3saAVwtV8cMm8MHhUJ5eZdAjL3qV/xs+faG0HNaFKWQ7xaGeARsi4hKkzYAwW9PE403/X9BA6ful
	eokhT4nB6lnh42YphqfVx7a1YiloFlJmSFp68XSd0eQ5MMAAVuBqvR6+QxFepST9y8cVPGZut3XH+
	ncX/ciuUE94g+Z57j1LhQCnrxb/dVB3awZHgFdHg/91F95vSD8URDPKbDVTj8m/0q/I5xCLD9ET/O
	2pZcmzFRfbn4H/MMT6cL6fpWdFCUKD1ORHtbR2qilJLIm6LfDwwFP4wOayPw0gvsD4ZLtXR9szbuS
	/19NGtpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYFi-00000004JFR-2jMp;
	Tue, 28 Jul 2026 03:13:10 +0000
Date: Mon, 27 Jul 2026 20:13:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v2 2/2] mm: Extract non-swap page handling to
 do_non_swap_page()
Message-ID: <amgeRhp4GmIcqIpD@infradead.org>
References: <20260723030752.16979-1-hongfu.li@linux.dev>
 <20260723030752.16979-3-hongfu.li@linux.dev>
 <10c60511-c841-4bd8-aa5f-0d826b676533@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10c60511-c841-4bd8-aa5f-0d826b676533@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D5A4214000D
X-Stat-Signature: s6oeqkiqhnayaabaduceowgx8yaf5hwg
X-Rspam-User: 
X-HE-Tag: 1785208393-399130
X-HE-Meta: U2FsdGVkX1+Q1ny+w8guCJU3zdgxo81NjKeLAB1XNi3gyMgOJBmQCSjQDCPZVS5XUlmVOgSG9avJBdMMQNws5ETbtSsbFLHGpVHtgL73Afy6yPfJ0lTN6pczbR8QFcTz0y5wDU7B9Wwzh/dc3ilvcmf8/JtM0IEhqbxAK84Cd46oYeTj2kx4T8496R7XZUePWGqKSXSHwfYXTvcuApZX7508vEo0wRuO+SLJCdQCLq6jb1lZPo707QABxO4qUH+oxITgK72QL8eQtc2GXvru4VkG4jy8aMNiowno4gKCRqkzuiEeGvq41E4nXBL9WIumUJNEikuxOoK0k/NsfsweTzzFPp909fuo10fqbYqgRkEArYzs/SjsHc4Rajk672j6ObLqaMswtjQQE/xk6494KzlGARVR8ya1l78KEuEXDvsSYZZ2yVy66dX27R8RCC+zqEVutlf/OPLA5hQpbfckWw9L2TgD2RLagxRH8eaP3b3nzjc3WFqpQ6YNRxoymvbzdXIl2QCq4NFx4QeXDoG4s20vL/xWtlDENvJ5lZPk0HR4ZMI+BKD7AJYRBtV9KzofwIlgNxPq/ZKwEqKT/yYcXsr/vKk2ljFqrNFkgXGrttOz8CyuPToL+usM4eud6MPUragpxWnE3hoyAPEaDmg392CTBJCp5AyTT/IQq56LbPHvV468STneO0pEiU/qgzN6AnjHZRmFOPyEPGVDNiO25wZLnYAEIbdzI2u0lgHWxDUU4F9l2NhEFE2CAMbVcwoXfoUrw0G3jgtI/ZCckZuq1Qv3gdEoMCcbOc7Waeq52MUUD57krwIE6oet/qCPakIY1sFPOfPQuNPrAeqA0VxFNhofNcoe9H0he2YlVuedlpMGxBZGHohkjuHmUc0UG+JCT6dGy8NOKW0iGS8kT1hn5roxMNlUd+wG+hKVMaLpvAvDbBnntgmZ5PZlzhS0RVSWzbVzcNVOw7pzEJrGQLx
 K/LlGx5W
 rTurUlhopVWuySsJuj4TmQCst9QGlBaxcC1wt0T9xvmLHiXLwebqWpO4vYMeYJIfu8qpQNMSobIx65pYpKAq0gr0AvW1iGNkx4MJPHDnNuGq0EkaAUxSDk72VgDzF4mtHeiluyBMzCS6ndhUYZelEVc7dWWnOsNNcSOs9f3hdfAgFqNBlrSlErToP1+etUb1XD4b7IT2VNPVvSv+ibY5evYTOuwV78ntHOjXu7dUzLuQGA/2Yycn5yFq024J9Crmv85u0TsDcUpkFiFk2+k4XEl2a/eoC1oGY7ZPfMd/OqcOcl4pBl3T7q5Zc4tvT9+SKxxFIzeKaqyWU1qPJ5p/PxI/5V8Dn3GdaPitMXY2g0lmzsMswvhfdIDPXxdYgYMnaLgks8+vYURWHAFdq+huH2NAqyULpGIDTJbEEWCIUzSXMGsKg3AuUETIL0p6S7XWjqAesmhzLhFcVi4wlBKhwJliUFbmcuNLmY4jfeOdFXvZq5afBs3eP36G0Kbytlzv/poMc8lHGlKnmpp95drs7JNgqYfBgg6f2Gs7FictFL8h29uS11WiK3JmnarKQjI5dKYWdwaOt8YG4RYo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 09:33:12PM +0200, David Hildenbrand (Arm) wrote:
> We're handling softleaf entries that are not swap entries.
> 
> do_nonswap_softleaf() or sth like that would be better than talking about "page"
> if there is not even a page.
> 
> But actually it should be the other way around:
> 
> do_softleaf_entry() [currently do_swap_page]
>    ... non-swap entries
>    do_swap_entry()
> 
> Or sth like that. Then, maybe in the future, we can just move do_swap_entry()
> out of memory.c
> 
> So we're factoring the wrong thing out in this patch.

Yes.  From the code structure it also is really obvious that the
block handling the softleaf_is_device_private() should be a separate
helper instead of a giant code block sitting in the middle of an
if/else chain where every other case has a well-defined helper.


