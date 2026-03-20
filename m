Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 770BF108B8ED
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BDE6B0089; Fri, 20 Mar 2026 06:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC8B6B008A; Fri, 20 Mar 2026 06:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB446B008C; Fri, 20 Mar 2026 06:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BAD96B0089
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:36:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49110C0426
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:36:23 +0000 (UTC)
X-FDA: 84566087046.18.4760797
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1BDCB4000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:36:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Fl7ZguFR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fw+9C1Bc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Fl7ZguFR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fw+9C1Bc;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774002981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64b4vlU7vi4a35N1X7Lhu4o4AVa9bXtkwn04bAdK+hM=;
	b=7ZRm/edRjWIJ4BcutROdlscLz+YOmTfQ0ZpXABHIK5sOl8mVQwspPs+iee3dcMQlVuXfGF
	Jjf8nB3E48qXyWaRqe9cxs8S/ocWEBOnrvqMDy8c5YwBK9gcQPCxhtqGAaLzOVJuGAOSHQ
	hwoPujiF3tn6qEwPBnk1Bqh/W4Yv2Ok=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Fl7ZguFR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fw+9C1Bc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Fl7ZguFR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fw+9C1Bc;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774002981; a=rsa-sha256;
	cv=none;
	b=LRQLe4kPZIrus7TNYc1aeHc0EKrDth02jsiV0SB3AVE+qEBom+Ry/u9m0lszKOD1z/17Vr
	0LVO9o8Z9aVoP0OIMUyw/wBnP7TdajHyVOCO7/cbjNmgYCAOFY/5ziyvJ8Wv1j5xVGJtht
	iWJrpJHPBizZo1pntFwpdzITQomS6uc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A89CD4D220;
	Fri, 20 Mar 2026 10:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774002979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=64b4vlU7vi4a35N1X7Lhu4o4AVa9bXtkwn04bAdK+hM=;
	b=Fl7ZguFRpZxa0AJkuO7E2Ps59fgmsORX0MZtduH8drUge1ghN2dRgNtwR8oABQYdAzmUKh
	NPT5rTc3XJsovrhQUZKd7O56kGMf3eBd+/YLMOaDlQQ3HcEL3v1y50xxHJ+SgkSlrSJF9W
	aFjuNNP8ve3bG3n+K0rQsh3pM6l6oPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774002979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=64b4vlU7vi4a35N1X7Lhu4o4AVa9bXtkwn04bAdK+hM=;
	b=fw+9C1BcRVyI2lzL0VDDdxUcJdW+MAzoC/46pgemxXsucPHdtvZ1blqCqrskiq/zBcBG3+
	CMnQ3v6hHoIPr8Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774002979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=64b4vlU7vi4a35N1X7Lhu4o4AVa9bXtkwn04bAdK+hM=;
	b=Fl7ZguFRpZxa0AJkuO7E2Ps59fgmsORX0MZtduH8drUge1ghN2dRgNtwR8oABQYdAzmUKh
	NPT5rTc3XJsovrhQUZKd7O56kGMf3eBd+/YLMOaDlQQ3HcEL3v1y50xxHJ+SgkSlrSJF9W
	aFjuNNP8ve3bG3n+K0rQsh3pM6l6oPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774002979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=64b4vlU7vi4a35N1X7Lhu4o4AVa9bXtkwn04bAdK+hM=;
	b=fw+9C1BcRVyI2lzL0VDDdxUcJdW+MAzoC/46pgemxXsucPHdtvZ1blqCqrskiq/zBcBG3+
	CMnQ3v6hHoIPr8Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC9F94273B;
	Fri, 20 Mar 2026 10:36:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gr9vMiIjvWmeRgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 20 Mar 2026 10:36:18 +0000
Date: Fri, 20 Mar 2026 10:36:17 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/mprotect: special-case small folios when applying
 write permissions
Message-ID: <zg67zwx2rplbebv6qsnuvtsv25utscwoxzud7c7vvjjxcdkn2c@23n3rqfpiifn>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-5-pfalcato@suse.de>
 <1cfe61ec-a910-4cb7-9714-410e37f692c9@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cfe61ec-a910-4cb7-9714-410e37f692c9@lucifer.local>
X-Rspamd-Queue-Id: 1BDCB4000A
X-Rspamd-Server: rspam07
X-Stat-Signature: h5mg8qpgz6fxps87qd76gbk8j5k76h3a
X-Rspam-User: 
X-HE-Tag: 1774002980-793639
X-HE-Meta: U2FsdGVkX1/Z5eDC3UxLTboug4L5ISwU7eGD5OIAFeKeb7DhrHdVypZgkbLA+qzGmlcuYJizptMOZPI2O0bhJbtsoF0LJk6ceOq0w2uwc55GuFltx3aTaP1kfrsY8a1a1npW5UfazEN5+pDl1c+/AUjVAYJg7E+dxvQ4rorex41HBCMZ9/I2/QwN64z7KVJq1pbh+5Ndy+ScW53CWfeq7+nIv3PKrDu5ze4LyCOOsYSowoPXY2o6gWXXZyP62hSguxUxl+HPDfeyvnAWX2FL4LnHXF3zgXGC1+O7GGQ022RYAWWwrWjggyu3SWWxBNhKxd4mH77p5tWzqSP6ExVQEyh3uTutejmMjjzyf/8xb+lWT7Qq2TNdnkA+NCHKcKofJWkNvzZbJTtrSNlWNnHcdOvcFKmIYDXHbWA7bdVbf9nn5eyJArSy2JcnUfJdsKuuz7NixCk2Mv5YqfKnkhBexkdTICma4xHBZIA/jkgwoaY7Monw6m0jmu5EdMVxdR3gQdK/G6haz4lDOV94C0MjWh9/J8W++uU0SrDoz0uN10rEQexPQPECdvz9lbiDNhekjID/sq9XJdUgvcWv00atGpZJfQX+mCPZBUpwzOqMD1MKlf4LBDSrH5yyURyGwt1vbLG64N8boi2tZLBUhTV9+UyCV0Cq8gh2QzkCigtGm7Joei8kTyLM7699dwrJ8rGrJeTb7akm9nXPjzXCUAoX1LDReHN1Oonj5X+/g4/djwn7fTViHZGGwFW1lE9pLSeB+c/86Yf3GH+son/7FzYaBfWDpA5I6ONMyXjgPpxhewwVbHym840O0VIH4WvJxAMOKACNShJsUZzZpGCotLnxXS/VGG1cK95GrjVoZZ9LSXj5BnFVoGtoLJU4pDCcr4OKpEh5DWIL0QUniJZzIv5yjdwQIkc8zs7zfU8UO5y6Fb/ZUmcxZdJVvd1qcWZubEZo3KIuuni+BIReCJSP2pP
 jmdKzr/D
 w9l5uN3yQ1KVdsZ6T5RptGjtPIZFq6KRpNbL2Sp536sNHhMB4wplr44wU8JfLp9NfvmBsGzrJhMVjICbudZzSQf8MsEYuFJo8E6DYzjNftKW+hgCZ/ASs7wIZn26+bJ5DLoEtUGLGLD992DQor+fpKMWvdXSpWnByC2J3T9efmO0H83QvakGRzR3FffqFADrkxBGHXYU8fZZ8w1AD9raTxqvd7g3UTovw/ad5tQmASK31NYttcBNlQzz4W6Z3X4NkwBjmQGB5D0QcaL7KhBB6PHwna/iR3CcDiSH9Vy2zvHJBAObPqftL8QL4tS25P1Qwhk03
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 07:17:31PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 06:31:08PM +0000, Pedro Falcato wrote:
> > The common order-0 case is important enough to want its own branch, and
> > avoids the hairy, large loop logic that the CPU does not seem to handle
> > particularly well.
> >
> 
> I think it'd be good to get a sense per-commit what the perf impact is.

I added some numbers on the cover letter - this patch + the __always_inline
one do the heavy lifting.

> 
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> I am iffy on the likely() in the same way I am always iffy on non-profile backed
> likely()/unlikely() but this change seems sensible enough so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks for the review!

-- 
Pedro

