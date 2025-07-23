Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D79C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FBF66B0098; Wed, 23 Jul 2025 05:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385456B0099; Wed, 23 Jul 2025 05:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29B726B009A; Wed, 23 Jul 2025 05:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1666B0098
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:09:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8ABD514065D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:09:01 +0000 (UTC)
X-FDA: 83694954882.06.D2B9596
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 58FAA40004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:08:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="YeiT/rU7";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jBmcLNrk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="YeiT/rU7";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jBmcLNrk;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753261739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZ86HXKj+U1sD3fGSIbwoOwgbbHNQx55VC+m5L7A/uA=;
	b=HSbVwYriIb0uHvPJx7DdTQOYMfFGBgraUiEh/5fd17f5TzjLp/UzYCQi+gMeeTFM5/j+E0
	pmwn3eVAmF/MzuTaQHARheT4EDdUnTYulFT7jXNPbgdmsXgAYFfBMa8gThUQJz0jOcdCvJ
	xp0HZAC5EbceR4FF8vRxoZZ+wW1kBko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753261739; a=rsa-sha256;
	cv=none;
	b=sxzZuXn2OzXB72DOPjEM7Q6QIanucQVKiogrFxQgLSifbS1OT8t9K4bzLLAyI/BjxYRMDG
	XAluufrqcamuRnvlL6QxKcSICWeViiUc2CX1gbvDtyvGi2FjlAB5kdAz8A6CWWIqa+dKZG
	5LnGYrPQwDObD5os2WjnN9gAb0bmlic=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="YeiT/rU7";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jBmcLNrk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="YeiT/rU7";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jBmcLNrk;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B036A1F449;
	Wed, 23 Jul 2025 09:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753261737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ86HXKj+U1sD3fGSIbwoOwgbbHNQx55VC+m5L7A/uA=;
	b=YeiT/rU7Mq2AECRYUXA2dMhab4893cj2Kh1z58Ucc7IgyBhPjriu8GZ34TNjx6D1Pu0Rj7
	+JABaDlFKYPd+Zyo4Xzp5FcDl3ov58Z323A62OaAHPJutyvU5XdtAjZwq+eJx+zp4Lps5z
	3mK3/V/9N3i1Y43XJ3pkxX9Wvkja4Xw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753261737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ86HXKj+U1sD3fGSIbwoOwgbbHNQx55VC+m5L7A/uA=;
	b=jBmcLNrkTaZlYfeIVXKMPUCkuXXeoj0V4c/iz0TytTHhd+4IbLZmEfRvisCQGvD3kGHJUX
	ohfhuTmDUJKMDMBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753261737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ86HXKj+U1sD3fGSIbwoOwgbbHNQx55VC+m5L7A/uA=;
	b=YeiT/rU7Mq2AECRYUXA2dMhab4893cj2Kh1z58Ucc7IgyBhPjriu8GZ34TNjx6D1Pu0Rj7
	+JABaDlFKYPd+Zyo4Xzp5FcDl3ov58Z323A62OaAHPJutyvU5XdtAjZwq+eJx+zp4Lps5z
	3mK3/V/9N3i1Y43XJ3pkxX9Wvkja4Xw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753261737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ86HXKj+U1sD3fGSIbwoOwgbbHNQx55VC+m5L7A/uA=;
	b=jBmcLNrkTaZlYfeIVXKMPUCkuXXeoj0V4c/iz0TytTHhd+4IbLZmEfRvisCQGvD3kGHJUX
	ohfhuTmDUJKMDMBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3241A13302;
	Wed, 23 Jul 2025 09:08:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HHsUCammgGh/UQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 23 Jul 2025 09:08:57 +0000
Date: Wed, 23 Jul 2025 10:08:55 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH] MAINTAINERS: add missing interval_tree.c to memory
 mapping section
Message-ID: <567llsbwcwl4v4awyiykqw57f4msuclwrjgp4bivbkyrygogpv@evlqgd3bza7s>
References: <20250722171528.141083-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722171528.141083-1-lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 58FAA40004
X-Stat-Signature: yiza6xudtdcwenn7atuk8zho77bwg9hp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753261739-298705
X-HE-Meta: U2FsdGVkX1/BC3G9qaadrdEUcmXrxuwS0F4ALF/LXmDfE7ZRPJXOAmxbiURyexvf1+95nAZEa4QyXeymqGQxVGWDEZ2zVM/F1XFptXsujNk9uwbh/x6HJQm+AVmRICP+cAjF2HK7scsuCk9FOC65x3eenRDyrmPsJcfCjkUjYgYFndDzVqTRVX9ODATZa3/3bUcFOLhCGZ6goolrUBJNUsjJhyl5M2QcdqSRefmh37BB61+ovTo1cyFaHqsSNG6Ye1Frt2BHv+yl6G+gld3iPN4CcPuZfrCEq7fGNol8yJIDCadoxwZU7CsNR6xqBG8ZOnd5SjwDKUKlmaxdlj54aGC9a9WiMR+o46fLFgLkV6oqOE9RzfYF/JQZ7ExzY+1FZ6ws8zO2VlNGdEcrujMc4+ehD1yP6bs4svn9TIL4CwB5vb/qbJQaqAoQGXWnVgu9ukPrXjilg5ioFkVK4iXOrQebBOcnM4HKqphlm++FEXxX8D6uAZr+0ed9UgrIqR13W+hwaSxINUdOkuZTFN9EqfJFUNgFpjcQJ+HtpO5HQVV0XYz7IWGEqJ5uwypcnum5l9rilN+9kmnTZWtJ24COltQgOQImu8MIhN/4bqF2p+J16i64E/KOwewYLQlvQEWstprq6MarBr1LJhyDFIsAeDoyEUAUtavAuZFHtd9BP04Xfur778x4wleQeC39obzxNLNBtQqC5+oj25t3v6JZ6umc5pimOd3me+nPZxtFm4Bl9L//DOBWlJzRwt4DAr2WVFDZPfbUCdq53xNTfrtgdpdKRKzXTooG+6TWKyEAqafxZza/b3OVfUQbXq97pOcCSPW1MRPMkYvVFnXhCZaxB+HtOJKwhdBne0EYhiAxPz+7D8tj0+Gd70zZ9dHdSdx2O0Ymd9uHxgBK9uAUjgIdjj9gwhF/axnn78hp7t80mqyN+QT3WVvA1/38jOtQQ9YxPKg7u0ud6HH7209VjQq
 KEOP9oKp
 YXM70O+T6Zhdci6yRqdTsGaDpU+xDOmpSjcviB7jB6VfDbd9VdfR4HwszFV0nsMnpk9mzsEBmnkLGOvVqLGue3pyeT0Ot4Gj6x+2QM4SE9DxOnuGkSczHVtRyWGWnCxJCHdflm1xjoGP9YlYnX9L4xyD8QZVfxFNGpZy97/Oul9BYNp2H1eYihvZrg03Lye63i97unYpRzaWqSQySqt2FGDjPD3ZDORdwsfnvxr8Tm2RpQUv2xjcoAdWoFNjW9ZUW98hIMMJR9NBx/Bl8zXxVgMpWmFVuZ+eXEakivLcjsrFPcPxZY+OwNrgCLns/d1U+Ob5YrDJ8+Q4wRQCf8WOTfs4/f+MnlofvYP6MqPcVRvMye2AxHO2xpho6oE5TVvoDL/fL7giBMf8w3Te0Fv4eaAoTVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 06:15:28PM +0100, Lorenzo Stoakes wrote:
> This seems to be the best place for this file.

Honestly, calling this "MISC" and going on with life is also ok.
But:

> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

