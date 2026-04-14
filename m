Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79D11ED7B95
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72656B008A; Tue, 14 Apr 2026 05:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB936B0092; Tue, 14 Apr 2026 05:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E2F6B0093; Tue, 14 Apr 2026 05:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5576B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:53:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3755013B062
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:53:17 +0000 (UTC)
X-FDA: 84656698434.19.2101D60
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id E6FA4C000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:53:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="QK/ZOkL6";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XyCOi7I8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ldW0heS5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eDY9yA7I;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776160395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPD5JZWXLOXJK2CA5dw/48scjaOqjpDP5gnVdaxSMmU=;
	b=VSyGMdo0PUwNcDBLgTpHYRKjzht+HAQUPgZYXYaVfb4tRClIUcpoNRANq/iSICEx5822fc
	KF+2pQA30LUJ/sWRGw/URNUGjDmir6wquULGiVxLFcrTuLPuZHwiTTxuBCQwXWy6T9gvGF
	iHpKRYivbEBBC2LZTJQAVFTpRkm7PjI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776160395; a=rsa-sha256;
	cv=none;
	b=gET8RRIf3I468RhrCRm96eEENxWPSlI5EiN8SU8mOfN18oHGVkPPXecb6auJ8rDOEOLhpQ
	LPvgKZORqyUaZiofYux9JtGe9IAr1JqHBEVJ0ot+jy8RAR8Lm6Juh6qTtjWVlMz0EnMoK1
	QeOBAQ0fSyLTzQ7k4mZUxkJKMSmjkzQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="QK/ZOkL6";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XyCOi7I8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ldW0heS5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eDY9yA7I;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E84EE6A7FD;
	Tue, 14 Apr 2026 09:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776160393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pPD5JZWXLOXJK2CA5dw/48scjaOqjpDP5gnVdaxSMmU=;
	b=QK/ZOkL6r4fU6O+gor08Pai79piFrmp2r4Fam2U2BYrzwYs6gOTcpRKXDpTKM34ncUruQz
	t6aSl/vdi+lj42pK36OyyuQpbsxwcE0VUpqEk2z3fo+0CWOirQ7YIoIUWzVIVUWiACWNtX
	VNpw/1oCwWSQFpNDPO2h0noh66hGIsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776160393;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pPD5JZWXLOXJK2CA5dw/48scjaOqjpDP5gnVdaxSMmU=;
	b=XyCOi7I81m/DD+MuTT92PsbyWhkBhhMM6ItWy1qpDZnhj8No6VoiqYPSuXXYeIUz4rYALX
	K377bQZ/WAhA75BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776160392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pPD5JZWXLOXJK2CA5dw/48scjaOqjpDP5gnVdaxSMmU=;
	b=ldW0heS57tSYJqsYHBM+df1+cAWOzkw3dseiwFDNU//v/FNXRZFbl+bhNR3IornHJeaGGo
	9qzlmQ1bpLN/kBfJNp7GwUmpVnLNpSzmpTOx+91+LSd0pCFHUUZzTRuYY5af96c590RBnS
	bA6Lqm8iYWEJjoaHZF7xf9h0yAdncSc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776160392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pPD5JZWXLOXJK2CA5dw/48scjaOqjpDP5gnVdaxSMmU=;
	b=eDY9yA7INydVASNMf8xbIpzO178bIet8WbflFAfM6KSNUwqJfNNyhujCbTxgNK7Nt2oSMS
	pwWoDfgN+Zkm8aCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FC574B3A7;
	Tue, 14 Apr 2026 09:53:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1bCGCYgO3mlLZwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 14 Apr 2026 09:53:12 +0000
Date: Tue, 14 Apr 2026 11:53:07 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
	hughd@google.com, baolin.wang@linux.alibaba.com, peterx@redhat.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] hugetlb: drop vma_hugecache_offset() in favor of
 linear_page_index()
Message-ID: <ad4Og_719Yq4yshf@localhost.localdomain>
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-5-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409234158.837786-5-jane.chu@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E6FA4C000A
X-Stat-Signature: rjo6bjk9trbyicpn4dfi94rhjo6wxjo4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776160394-876286
X-HE-Meta: U2FsdGVkX1/rkC5ZPstEV+vgh7Ikf9C8Gda1IZrmONNVaNtWkZ1KXWRat6daNhoWTgfpEOHbJokJ+72758sJXAeeFbRrDoPeSOnt1h9vUN8lwelKquvZcp6w9DSjRfF3D1sMDQE13nHw90smngaTZs3WmC3mFbfgpRP6l91cLMuFb9mCjpbLZesWS0nWvxcH/Y0o7Ykh1NFin/w2ETF72OLv/eAZGo12Q5pibFh7dEVf0zkdlnhm6MqzE8iFg2Eo+GXtmU2uyuKekuFRHh3GQ++ErJrLVxSWKpuLJsS8ufa2oPLxEJHmo8E6Cczxic7vjKWQcXyzN5kwxm9fO+gAyRsCg0bUIheocBCZ8uoKwIcwD+wq/BlmF//NfUTmrDu/ZFNe+9e0W0yljOVAoMWlkPklecaqRg5zMwqN5FMVeiZ9L6qaevb44JoWzbFuhnT79wNH/h4Y3Zxy77auNyW0enSgTrropfgGFQlYTrHjlCxbcFyYLkz8CUJELn9YZXFDFrzTQVW4W63uK2eI5F4AGDpVIK8dvdaD9yN9m+QaPclCrohF9A5SxLKrPU28qKwtTFUPdyOs7jxXlbcFYy4shBBIKw5pGOdLcgxHxVIKDumrN9wDgYcTinxcxOyAtKAWJ2Aw/r17eN3wLQHHTiF3YeQO47FSIR/kLasRf8G1yvjaGQp/HLyycIebga3jOnwmao+FdkL6g9deAkxOMr3rzQvK0BlF2MuHluTYGj/bgknY3z//8GKuQiXJxn5mW2p96iJ9yJTf+MWEf1toikh4epzoaTbX+n6QzjOU2ofggmM8AWQp0/EHQDqlbtRy33ozW9TWsOdvaKSUffcEda41bhi8fRwQZykEl0ORaxYQLsHPrJk1iDM7myM40Dhg7//AOlUgSXiUW0mPXaVnl38PrEFUhcYgU06MACLsZB/n4ixXxCs1io8/uHh8CdX6ylKruFy7en87C1hWhrLtnGN
 o+DSTRlh
 Zm54b7QbnsAJO+XY++Hbf/Q2eruSpKb1DDxTdoDsjtVg9glPYRmIKZL/2w87e2sJFoxXnmINwREuEjMkuGl1xfJWyUtyRwiCKbLvrlE88otFjXxLQFwKC7yb5QZWOp17Rjt1Vw/+javUzRaAPLcvuvbQgC2noYY4RLwxn73CuJYOMh0wUVTAmfemCDdGfgbU6kV1ST95XpDlp6Q8fGUaTfY/3XTg3DcVBo6xyQi0E5rT+6Z8SlLCmGfthE5fCwQHOHileboaha8Eq6z7XrImFOHP2h66UHdKBc+ri38yzO3mDT8KKkRX16LdO211wtWw4KHEpFA9CXsno7L4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 05:41:55PM -0600, Jane Chu wrote:
> vma_hugecache_offset() converts a hugetlb VMA address into a mapping
> offset in hugepage units. While the helper is small, its name is not very
> clear, and the resulting code is harder to follow than using the common MM
> helper directly.
> 
> Use linear_page_index() instead, with an explicit conversion from
> PAGE_SIZE units to hugepage units at each call site, and remove
> vma_hugecache_offset().
> 
> This makes the code a bit more direct and avoids a hugetlb-specific helper
> whose behavior is already expressible with existing MM primitives.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>


Looks good to me, the only thing is the conversion to hugepage units
which may not be very clear to the casual reader, but you already
mentioned that you will add a helper, so all good.

 

-- 
Oscar Salvador
SUSE Labs

