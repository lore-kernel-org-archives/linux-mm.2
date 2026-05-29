Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F4FCD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 23:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493696B0005; Fri, 29 May 2026 19:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444F86B0088; Fri, 29 May 2026 19:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359B96B008A; Fri, 29 May 2026 19:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23B846B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:36:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE98CC1786
	for <linux-mm@kvack.org>; Fri, 29 May 2026 23:36:23 +0000 (UTC)
X-FDA: 84822068646.29.3FE97AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 128FD80003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 23:36:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ulUk/p9P";
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780097782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3wCANRDmAKnXOY0pPU0bwPiXfptLlw7s4pYpBbRNU4=;
	b=p3qa2eCdFAnZO4yr3AXifumeC99RTVytaSdfbkuooiRCJqoB1ZT/p5qxn3F0CPhf/yjErB
	P+Uc8sLIeC33CGK8SJUuG2g1Ek/hdlxBfarUwHzf6F5oKVVE92e/iHp2okzx9Qzf4d70I/
	ITYf0t5lXrrKlxWwaQ2cE+B+GrKsiig=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ulUk/p9P";
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780097782; a=rsa-sha256;
	cv=none;
	b=0fd2XBLop9IvC2+zcjLb2ao1NbyMXbX7WqVQAM47nh7/aTtqqklpnCM2agnnCX8PgyrYW6
	xaISsqJbEEZEWgorVwm63AxUoe2xcEmgzroslDqQeGFS2agl16XHa1bdD5KBYFoL28ntyS
	I+SlZPtQUHTKkSeH+ja4MLsVz8i67+A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45E7660103;
	Fri, 29 May 2026 23:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F5B1F00893;
	Fri, 29 May 2026 23:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780097781;
	bh=k3wCANRDmAKnXOY0pPU0bwPiXfptLlw7s4pYpBbRNU4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ulUk/p9P7YXsrGGptPVWPz2KPipAsJg/6MY76t9tFV+gqOTYJs0eAMBbniM2mJwc0
	 g6iBt611x45wbrhaEJrVgM0xixkRg5S/3BuNLpsOokCV8yxW2udIy/lswLlVRW76Bw
	 CXycO56vcCfWETEgvzF0gK0ZONBTV2d6/CK1IFTE=
Date: Fri, 29 May 2026 16:36:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, liam@infradead.org, jgg@ziepe.ca,
 leon@kernel.org, david@kernel.org, shuah@kernel.org, vbabka@kernel.org,
 jannh@google.com, pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, balbirs@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: do not warn on seeing non-migration
 pmd entry
Message-Id: <20260529163619.fecd655a4db1f4a6543d5342@linux-foundation.org>
In-Reply-To: <ahmdJFCw2arBdsd9@lucifer>
References: <20260529111704.1078346-1-dev.jain@arm.com>
	<ahmdJFCw2arBdsd9@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iznh4dr41mxron9tdgnmcmmpp6nqadi3
X-Rspamd-Queue-Id: 128FD80003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780097781-806454
X-HE-Meta: U2FsdGVkX1/K3rpK/NCNhNBKzX24tAxKzkyEEfK3Tx4WO+UOsk18aVRBYPNNYS0DC7gbN4C92zjfC1qIs1sP5pQKk1kRx53/EOlFndNqBDuHw07e/9CC6XBX1hKUN5K8ltXcnLuT+dG6caXe4dE/D0bm569EtEG9paCZ57sqZMJA4lqdQ0qHH4vQl0M+mOC8qfIID6ylGYpF4YsT5G66usDE5G8Xoj/3tqdFFWlVOzTHEeJztLEI1KbAW/UmyaOw7gWMrqoqR2f1Ch4RIXecJleuUjrUxqkxK1rs7BxbZd7NJkoNT4GMbihJ0ibnLTdkmC6EyMKG+Gr0rloNvoZQySN16gvgMwMQX2PXmpBr53O5JfSKjC9eUi2SoMDcNRj0lNixNzTUhAjYEhgkcaymcO80s9vBFHcxa8rZSE3TgxlWAuzuCicp0y0bVWtHKPg3phSuampheLgHzGs4cuI1Kvrqw6XQWqVCrcx2gmvuJ3cRRkbxOL3KSRV2wv9YBlCkJeBNpA3Tkw9zh+3xwHta+rmTqZPykn5010spdMTL8tEjuq5+PSRkhucOuTA9lmRmg70aFJSnh9bcCLc5LFvuz5R5McvQBJQIKX67Jx3RUqhyTrIvacgAVmSy0xwdU6F2DKGlZsq8/xVr76tzvMopZSJ7C/0YkelgDGzrOCRfLSbAXmpcsWRpf3jfPm+9knvD0u/Lusm3UZMpcfLv5X7cQ0UbO3o+qiGI220cehl7fFLqcGjF6qKm0tWe0KyPiEm8jONU8Cvh1oL1u+CDczMUyppZDVfDwWgTi5+iwhrL0DYkZu5fDGJdiviBB7LYJqoeZ0oUQxsrFXNniIrW99HXPldmVfc14xsroZJ2QUVw+x703Exmx0LPDshZg+y+5l9B5T6nx1VyiCpaRF5qvwxmV4Qq8JW5gr2u+ciApP6On91ctAti9GXBovFP17bROSiA76N2ZqIXi1dMJMQIgy0
 Db+U3ZND
 uDWFHVxawTkaNQc+Ua5zZQknIdd6kBNbwOP5pQV4zi+tVYA3d2TRsSng78yTQ/WJZ0mR8J/oEiHqdEj3kYE4Vg++nNc0BtnRPRiOwdDFWVMfyE1eP42ALAYJP8Psg7b6ZauJEs/4a2CboSmRBe7wCKMo4fTpSDzrZ8gxb2PQm1+jXSC+Tgpfyy8W7G5ZxuXAKXXpzqmFPOCq9IXv6ttxG/eR7f3VTQq+NF50CRHflREwCWDpZ204eL43aFO69MUyuSo7E1Qubc0/ZOVL77RtPimzoI+SD4ZNT8pZ7Twa0SkaKc5Wn1fTWiyq6GMcs4zzvi3Pp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 17:45:24 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> > +	/* Exercise pagemap on a PMD device-private entry. */
> > +	ret = hmm_read_self_pagemap(buffer->ptr, npages, self->page_size);
> > +	ASSERT_EQ(ret, 0);
> > +
> >  	/* Check what the device read. */
> >  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
> >  		ASSERT_EQ(ptr[i], i);
> 
> Thanks for this!
> 
> though, hmm it really feels like you maybe want to add this as a test and
> make this a series :)

yes please!

