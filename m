Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3861CCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9562E8E00FF; Fri, 24 Oct 2025 16:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E00E8E00C9; Fri, 24 Oct 2025 16:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5BA8E00FF; Fri, 24 Oct 2025 16:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6CAB28E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:27:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C51C1A0F7B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:27:46 +0000 (UTC)
X-FDA: 84034143732.26.9DCF522
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id E2C88100013
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:27:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AIkWIZE5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/nrS+TbN";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AIkWIZE5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/nrS+TbN";
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761337664; a=rsa-sha256;
	cv=none;
	b=rrEEAR+KSpSibg+wWmt2uGksgpF4h99jlfC/cbbFaYvXLsWMsQPJ+/BQ8hwwIep0gPno7m
	MmExrjKlFLb3+iee6W3QgfKqSRKfmMY4QqvI+sBaTfbw5Cm4YqiDwebUczM+FMIy1VxInp
	EEAz1B0SC93n39f+VSjp+/e3rFJJ06I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AIkWIZE5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/nrS+TbN";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AIkWIZE5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/nrS+TbN";
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761337664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELyIlQzQ6F11bcetd/x8qz7X8Qn+ndTekMrwM+UQPLU=;
	b=c44Ns7fsQSKnRcxyhOq6VOqgQrsdkNcGTjZG9L3EW5sjdtvw1p2CnYPnmmEgOkqag4u8Kc
	dhZKMTYYg/gnKJWKivwJV/K2Vlg0rysO2q20Xsz4x0Vkp85mRFbzPaXdF93gb+rbU9jpeo
	xBZvWDAKp4/B7stGvzr+flmwplPxmjI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 54D6A211EC;
	Fri, 24 Oct 2025 20:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761337662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ELyIlQzQ6F11bcetd/x8qz7X8Qn+ndTekMrwM+UQPLU=;
	b=AIkWIZE5Lh5VyQp9olqjiRRSajvSl0wY7y7PonFyKPc/eiWzNIM4CHBM+sSYeG8UL5pQ6G
	MHwPnramYA4EDg+iim9q1JaO2uTsYe2khe4wGCoOU/g0QgswD8UBE2oRsaEHniTYvfTSjy
	7MebrAya+pU3oefIlmZ6S87bfTcMoy8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761337662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ELyIlQzQ6F11bcetd/x8qz7X8Qn+ndTekMrwM+UQPLU=;
	b=/nrS+TbNbB5XXKGd4NY7Gu5/NQ0KnEteayJKib+4ik2/5vLAIcvfpKtvFOeTim3fFSZjOH
	oUX9ifHN0MkyWFBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761337662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ELyIlQzQ6F11bcetd/x8qz7X8Qn+ndTekMrwM+UQPLU=;
	b=AIkWIZE5Lh5VyQp9olqjiRRSajvSl0wY7y7PonFyKPc/eiWzNIM4CHBM+sSYeG8UL5pQ6G
	MHwPnramYA4EDg+iim9q1JaO2uTsYe2khe4wGCoOU/g0QgswD8UBE2oRsaEHniTYvfTSjy
	7MebrAya+pU3oefIlmZ6S87bfTcMoy8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761337662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ELyIlQzQ6F11bcetd/x8qz7X8Qn+ndTekMrwM+UQPLU=;
	b=/nrS+TbNbB5XXKGd4NY7Gu5/NQ0KnEteayJKib+4ik2/5vLAIcvfpKtvFOeTim3fFSZjOH
	oUX9ifHN0MkyWFBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48CB213693;
	Fri, 24 Oct 2025 20:27:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hwbIDT3h+2hOGAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Oct 2025 20:27:41 +0000
Date: Fri, 24 Oct 2025 21:27:39 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <5dt6roxyx3h4zojls7cvr4nyjtahi33ti2sir2ijr3w4wjliyz@fl32rra6phll>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
X-Rspam-User: 
X-Stat-Signature: 34yqfarxnhbaamjnake3fzzeyr4dkjtx
X-Rspamd-Queue-Id: E2C88100013
X-Rspamd-Server: rspam09
X-HE-Tag: 1761337663-70274
X-HE-Meta: U2FsdGVkX18oYNwlAIfhfgfwdPGwcUFgALh21Bsr4MN1uDi50V++IUCrHha0KSdNREZYqO1o9VVhkPZy/yQ32XTN2ZNuyzwmdldZME7YZAzPskM6ixrLcUT5rgaBpGG8to4HVyjxkhRyyLvm7NUE/uUs5NOEbsbahzjxwVOaNWyefm7o4Fvpc1CpFcJ1ZvskJEflITy54GnJukAdR5kpI9Och4hvwV4ZLogB/4DPzDrKBtFHOlV1vEdcoZRH0aTXNwlWyJRkLKR+dwvqaqQujuBO0fZxFCxT7mO1ZSYxHxtvCrcwjlZbDmUNNSXUNNVVqSbNXTAsWO5M88OyOpW0BNXCUdpwgQTSR7A8FR/oNyWekgMQW859c5rx2WsJrknXPzLuiVryAsLoRnKudDUB1alQLOwSBYaY48y6VS/8NdxIYUG40OStghm2Dal/aDMn+DLuLUsue4s9Kq33jmtUwhnwQ6mVDLBGfRs1tesH4eP17d6zu3NokxtUSvCYjYQF/Q3PjdgDTyYMNZ5GNm7vw5H2hgFC0DRlEocwISnIXkiprwkPrQODNpBS/38tZZn34xSgjB5djqkkdZSn/qUUmV4RHlbV+yLP6qYXEkZNQcHm7/0LrgsemTkMA/rZOOAo+2uyGfz0YKEDcTncxTAKdbeOX54D2YSlE9P0T8eK/84B+hX4CYm++W2ukKSQdD6NV8JDvIIFJj4IjWxdZV+kcfL4m1HWRj5furco7IM00iuCPedi0kNr8Qc4gw2mUT2eyVW7k8S6Ag7ixja8traMK3UAEypXj7XNoWZV7KEBK5khrGEhYJrtvlSqQNvXxi75yZ0X1ibY104+TjF7Cp9IejdwbgCvftjd6rZH+8cKf2YXQms9zddnZpzjYKjLDlyw+nNqHhPzjTk/i/EcgG1bOWiuUOkEt+fLVOa/U+IK3V8V9mms4rEhxx4EcqkmuUDbqgs13eswmCqgF91N+hM
 9rC/9FCw
 YFGvuMOS/p/3qX0eagssX5+8u3Y0vgKI2I1ZpND573Pbn3elgQ8lzxEZHifCFyjVO4tZsPDPsHRGBX964psyRWfYNTI9JRI1ZgGejZBBpJfPcHAfO+La7foCiFXeL4cIwj+UU29ch8cJ+HrmxSVmu6pfTHtFtfubLXoIa/k4HNbZmoE7xdZhtce9tr/pKmCuF5gVbMFu417jHYYZmDmgI46Qu/gQaCL2Q4+8iSsZyecXXoW5iUgx5nG25tbelZ5OcA/VwisZnHbue5yaGkybAjN9sL8F/kIv0P2aDy6O179FmmcQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 06:12:02PM +0000, Dmitry Ilvokhin wrote:
> Allow to override defaults for shemem and tmpfs at config time. This is
> consistent with how transparent hugepages can be configured.
> 
> Same results can be achieved with the existing
> 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
> in the kernel command line, but it is more convenient to define basic
> settings at config time instead of changing kernel command line later.

Why do you need these options instead of using CONFIG_CMDLINE?
They should pull off exactly what you want, but without changing the kernel?

-- 
Pedro

