Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3BD4C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C556B0092; Fri, 18 Sep 2026 08:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D041F6B0093; Fri, 18 Sep 2026 08:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2B46B0095; Fri, 18 Sep 2026 08:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF2C6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:40:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C888406A1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:40:17 +0000 (UTC)
X-FDA: 85226840874.12.63BE897
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id F055A1C0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:40:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ePAluRwd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=timBM+bS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CFEc+DX7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sWb1hUom;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789735215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBIVTqQhbW9GkWkLw6tXoBpdra51UNuriIkEvcJiyds=;
	b=R24ii+yanbUmVMEEftjYfsDwEuEkt0HzSMWwQ+Tw0D6C4yW8ypPtil6mNtohBl7DL53/dY
	34h8j3qJaUFzQXSWAMbyPAQrVwcaitNR3XzvyUJWnI9jJeear2S6vzsQD6Zk57uKMbCKCi
	AlYQ2FHf/SlUn9agaGOP89BqbRyQ/oI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ePAluRwd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=timBM+bS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CFEc+DX7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sWb1hUom;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789735215;
	b=wcSOQt3it4pe4KfrvkV8Rr4j5DPX9CBZDJIJ/m0BOIBYveiY1DzgThB5Z/varZ7yEm/0vU
	FrtV7Y3Y924Vsd62Er27SeiN+5i5DNEssVHUFZ4X+FllS4SE4+VMkyfV3gPm+hMtqwuvs0
	JRdzJb7BU7u8vIt6dxsCgDOREocZzqo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6CF841FFFA;
	Fri, 18 Sep 2026 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789735209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VBIVTqQhbW9GkWkLw6tXoBpdra51UNuriIkEvcJiyds=;
	b=ePAluRwdZrzW7izXIwcVz760jFmSfuOXshE5mGcOcWAozWskiRHHnAg7xbCn1ZIbPyTFNu
	iPygsevUI9tDBSHwpzK0B+swkqm2fQ9ZMWTKXCUi6txs3CavTKssi1gohSgoqDxCQL90Ji
	1x/wNXNTNtBEHf5DtYRJ/fq8/AYbU1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789735209;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VBIVTqQhbW9GkWkLw6tXoBpdra51UNuriIkEvcJiyds=;
	b=timBM+bSWKHBlO27cNXopOH7pQIYDuBMrGBnUDDwf1Z/gcAfAkg12Sgs7+59bchHChTvY7
	5xAEOl8Cz9XjD/BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789735205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VBIVTqQhbW9GkWkLw6tXoBpdra51UNuriIkEvcJiyds=;
	b=CFEc+DX7S/mbXLxGzGeVtEU2/zMIZHVhL5nPH+lT6uOGTpEsaii8lH3AzVZQKn3ggnKItq
	SPzu0/qn4woahHV/kGm628PDL58kT8Jq1uGB4Bwrw2XWYcF/Sl2ZUnyCTv0MMh3VLZg5By
	6dYGLZmmF6mcC6+QAcCK/32pkysVVrM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789735205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VBIVTqQhbW9GkWkLw6tXoBpdra51UNuriIkEvcJiyds=;
	b=sWb1hUom0CreOKzGoyRm0fiarkdRfcVVkA6epuqNz0U2S60lWbCfVGBdkSZwkYOHu8B+ln
	JyC9za0AuuN2TcAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE51013927;
	Fri, 18 Sep 2026 12:40:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mGsaJyQxrWpbCgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 18 Sep 2026 12:40:04 +0000
Date: Fri, 18 Sep 2026 13:40:03 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Constify arguments in default pxdp_get()
Message-ID: <aq0wyECZk4D96O40@pedro-suse.lan>
References: <20260918064928.793742-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918064928.793742-1-anshuman.khandual@arm.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F055A1C0005
X-Stat-Signature: dk5jth16jhd6p14wza8u8k7owxtzauqo
X-Rspam-User: 
X-HE-Tag: 1789735214-627579
X-HE-Meta: U2FsdGVkX1+sKXDkYTM9Oe357AP29cCP9J9iTEJMORcFWrsW961aC4R+1EMN1b78lJM8BPzGqGXPHHGVgMAJjlE+a8m8To+G6B8kWijR+M/f3S+YivW2nHPOf4GnDaooCSchYR60Yzr05d7BrYmkOS/61RmE2tCTx9kg5d/rWV2uXosmkGoHoassZ5BVJ6xt/DD7Q80aSsoqJJk6IoXYB/uhGu0DHcqWbiXykTuPZzzjy8y3FUB1CKQpo6xDs7rRZQPJrILeLSjVrRSBDN4rwXsq7ue2HwSFX5PjsLvQkpibvsx5/FlPfGt4B6E8snaCyoxDIkBwHNeOdNPp1mP7obLzb5+1OjdJR04jwEHamkrbtJEKF2K0yZpd7dFjHrZ0iFOrH/fOeCF6N2LVDPPjWNKmsEiUhdf1pqWROTnX53zpgzD6UAuZ/MO0JHomae5IG3e8Ieiws1A2m24flVFbOEmxYvcuDZlDF3TuyQEl4Cry93L6ufJJiWqzA4smVWaKl66huO36JPhHTeb2qt/1ntVESmveQ5wcMtt7PjibAgCkvSw/9cNg59Mo7YIGMBI5ZOy3bapSdpsGn8fZoRvVwSUBB40v/PKQN5IO6gUjbVCi71cBu5Mn7JvRCirXPt2GfyQtWoq6lrlHKy+UC63K6UqKCbnPFW64kfq2/Bfv0icPNReCRLZc8A8oieOCM3p4SCmDMuNDeM5po35KTAB0sax+El2hWOYvFHbFNKu9cAeLiCzF2SxBrquGy784Zcvf5nOnrNkx2lpHGDZQai4QLEqvCKUDY0bkGngf/zOMZGLlBBzF01HpigZ6KFEknNACRQ0Z6LbwYSyNFvmYDCbvcA/rN3Hw0EzxLQvC9DVJ8Yc2NSgLtbDA0CCdr3geQwm87bsj+TF7c2CGX+gcIQOfnfwABs/cXC9MpBAORILSmUKDCnF3BYrhFJdLsYY97RrnR1YIhRq9heOt1b0aXf2
 WXzhSMVb
 O27xhUw6YiUPWOaOGiH9vh2ZPVQxg6q/gJLrpyHiuh/d9lk7QhDwm0XhhmPDQBdvorcVyJmtUDSE1y9ty7Nip31oUl1TvtwYRJtgXl8algkdBdujJIiEk1RDukBWFkI8Lshn0kZNGgfvaWrtMBOu60zEFvI6gR3jW/8olc/Cs4Jz+6gAnkNUZRBruDE8iSV0vLxQ0AQp0902KW3dwbL9it/s0lykq7l2ET35io9J2ZCpc8ElQMhZIekIVed5UtQkb4hrS3r2yw6cDD55l18NWank9vBIX40WzU28bELxU/wUKiuaWCoysU7cjjtcsFnYGJb7PT1a++rqAzxi2efCJhMSH51mhoViUllEdvGt0drAVhLICvpsJ0xZmTZ9yArW8OkdThRCdaKuE9Rr6vlXDDUdk6G6det9i548zkLQ9+s2jqug8fcbL7lca4tRhQm8juqC+BGctDuVCH3FfuGe3YDwnCamosYyQsWhtSgpLl/4pj9qiEO3qMGinJQD+EIzN+uoH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 12:19:28PM +0530, Anshuman Khandual wrote:
> Generic MM default pxdp_get() helpers fetch the values contained in pgtable
> entries via READ_ONCE() without modifying them. Just make their arguments
> explicitly 'const' for some additional protection.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

https://lore.kernel.org/linux-mm/20260803164400.531199-1-pfalcato@suse.de/

I'll respin my series, since it addresses every architecture.

(apologies for not doing it yet this merge window, but it has been hectic
downstream)

-- 
Pedro

