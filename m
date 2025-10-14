Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C928CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90048E00D9; Tue, 14 Oct 2025 05:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40708E000D; Tue, 14 Oct 2025 05:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F0B8E00D9; Tue, 14 Oct 2025 05:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB578E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:41:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44E18C07D3
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:41:28 +0000 (UTC)
X-FDA: 83996227056.26.2C8AC21
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 11FD0140008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:41:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1H3IgPc3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="k2mPwc/Q";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1H3IgPc3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="k2mPwc/Q";
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760434886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoXuj8K6ZDVLY1mRyJSVSwhHzEVlf9jzE9Cln4mTonc=;
	b=6k/6ttuirgcJe7ISYzUCJXzfjgapb3eUuCkRXeZRT7QKjQLbZiSHmBv/LB9j1wcMAG7n9k
	lNGlQpLf8UTjWEMr1N4oeqWr8bpiSBHAB12Q4yDZ1NQAACY3BVLKyRxhVC0ysHw9j9yKxX
	Kekr8ArwpOFNs53IfIPFoQbdIH/FE50=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1H3IgPc3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="k2mPwc/Q";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1H3IgPc3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="k2mPwc/Q";
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760434886; a=rsa-sha256;
	cv=none;
	b=tw/sZSu6IhZnd2fCyQHREYtFLGN4yxIXrW2vJ3OK/UaJOpbL35evCSvgFfPS2KYqKYSDia
	PSUlTnBBKIQaZ5AU9Wt0FgvCbVdiFTRi1aEhgbXgpDtVzCcGE+t2sl5RUZmXxVFchl+8XM
	T6SkjDYYoRG74aAa5z7chB5KldIP2yc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A4491F7B2;
	Tue, 14 Oct 2025 09:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760434884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XoXuj8K6ZDVLY1mRyJSVSwhHzEVlf9jzE9Cln4mTonc=;
	b=1H3IgPc32utC6kfxuXukK2ocfQTMccE12b5ilIOrWLVg+H2sVRQtjGEx+r2k8EBfiwQOjx
	7zvN/D8Bqod/ny17ZO6BKf6mkN/7iTJF8kWk0fB8A5dwH369LzrmB4bMIeiZ/CH6Qe86Cp
	XGpXfD9XHdET4PD0VGsuoXMH7rXcwXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760434884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XoXuj8K6ZDVLY1mRyJSVSwhHzEVlf9jzE9Cln4mTonc=;
	b=k2mPwc/Q2dxXTz64jw8UXNBc2kONSuxaHdZ/SYdliLtsooEI5EVHulp8pLS5AGEGfV2CbU
	PzNdnhXBF0fEvYBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760434884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XoXuj8K6ZDVLY1mRyJSVSwhHzEVlf9jzE9Cln4mTonc=;
	b=1H3IgPc32utC6kfxuXukK2ocfQTMccE12b5ilIOrWLVg+H2sVRQtjGEx+r2k8EBfiwQOjx
	7zvN/D8Bqod/ny17ZO6BKf6mkN/7iTJF8kWk0fB8A5dwH369LzrmB4bMIeiZ/CH6Qe86Cp
	XGpXfD9XHdET4PD0VGsuoXMH7rXcwXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760434884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XoXuj8K6ZDVLY1mRyJSVSwhHzEVlf9jzE9Cln4mTonc=;
	b=k2mPwc/Q2dxXTz64jw8UXNBc2kONSuxaHdZ/SYdliLtsooEI5EVHulp8pLS5AGEGfV2CbU
	PzNdnhXBF0fEvYBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E3469139B0;
	Tue, 14 Oct 2025 09:41:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4KBmNMMa7miRWgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 14 Oct 2025 09:41:23 +0000
Date: Tue, 14 Oct 2025 10:41:18 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: correctly account old mapping after
 MREMAP_DONTUNMAP remap
Message-ID: <rtdubi5ewzrptvl25zcdg6ta46kcd6ixowaguftwo3rtmx5cz7@f4sj33igjuic>
References: <20251013165836.273113-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013165836.273113-1-lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 11FD0140008
X-Stat-Signature: zmgx7xjtho3an3mxpnxfgb4yhpmnnudw
X-Rspam-User: 
X-HE-Tag: 1760434885-762855
X-HE-Meta: U2FsdGVkX1+KJat1xuSPuFRCLIuyBGgf+FcIbM3B3fKpHEXtOZVCx3vDNy4AjvWzPnf3NYQyiyjbwlxWlmOj8PGzr9BECcoi8L+MH/qOOdLDKSoeqP2ciiVStlTQ0hNmoMsBlbFb0tbcNUv7j2O/ySCN4YKJo3lPIuvHzLuLtjTXPSLBMUHJwRK9juQgKwnjpzPb95kzoCqCZG0F3uJAlW10IzNfWLEhV6Qy28CKGnhA3K75HwyqXxaN0QyKRxCELkC35JUhowCHHy2kDkuuHwmkN4wTPB2lqE+dzZk8/7C6SAY7mwX7avBQrTviMRU8+jRdxL5RlCY9Wkg60pLJYYpfhyJhswC10EQG/+TWhvjjxkNNZA9c3zcCRJkMRmA75zcSp2T8IBFRXxAFslnsTDrrg7Tm+WKJK+GaxOnoCONarE2P+lo5zSEGup1mJ/1Gtzgzl0+ltko4q5q7H+WNk89tnRJK8dc79LFjd2RaDz1XwIbpB2t6xspXkEBoeNS9WwiVAF9Iu5gYeWF0LSwSik3tj8REGUCPaJ8a/UM1Xw91pAUNfL/Eg4F52Q2mFDDpK3l+4B7l8qccG8gvJcgMBse0CzMtbKLmEkeeuUKoCe54mmrE29HiPEUqjlSOouZseMYCxp5+YLMttd1EhKCgI/g+0FCMnVjrbtPOP7gqSeB0f1/D21t+ibC6ok3kGNvCMwwTwlqiM16O3hxOtoysRIoUxECC/wkEjEEPXlO86U4SNZd3+FI/BFGdVw7UF2dTpzBTNW6orqxrAUFBjx5a1yTUO2P1bDiHa1NuZwHPK0NOpZ9LgOxVDKmzM1D20V6WtLhJppgCkLpuFP/c6TyAjEaxPuDuFGTjcPjGsNqLmUhUT4yup79fyP/1MNFul7xqr8ge/8k2v5j9BKvNprpEgPEwncYZKEIwCmJYpilhm8W7kBTdhD4+MkHXvHDmOVgy/LKW5X+g8NIOlOMoTsq
 7MBN9WxA
 USUVmQlhfaPm6OUWnPqESRF0OvvsxFtopkn42XrJG/tC72/A9iTpj821NYTpyBLt8rWgmJKkNVKDDGbmhS3RAdXQ+N2pAiFL3rGUYeUfntquKCDchT37nN2bjXCIkV/o4xGPDRz/pbFwjwd89IO+GOI6QL9HD3M1/Cp9P8jmPP9WrJ2Y8lQpJ++LEPaNV8TZwBDr96prNxLL8IY/opAuzj+gjFE73XqGNNpRX8YYBVgEk5sBkLaAPjvVDPmblNswYBVcC7BaUVvvuDWcyaqx6lJoL8PCDiAG7SMecNcIBRCuMLVrxD9GJPBAwnPAXawts/Ej3VEQ6MDZPmiWsu2AOomiFCetBSHAehjOxr6T3VVYHOfWP+FoOX1qDIbkrjw93LwEFWHQF7njK6D4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 05:58:36PM +0100, Lorenzo Stoakes wrote:
> Commit b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
> mistakenly introduced a new behaviour - clearing the VM_ACCOUNT flag of the
> old mapping when a mapping is mremap()'d with the MREMAP_DONTUNMAP flag
> set.
> 
> While we always clear the VM_LOCKED and VM_LOCKONFAULT flags for the old
> mapping (the page tables have been moved, so there is no data that could
> possibly be locked in memor), there is no reason to touch any other VMA
                        memory
> flags.
> 
> This is because after the move the old mapping is in a state as if it were
> freshly mapped. This implies that the attributes of the mapping ought to
> remain the same, including whether or not the mapping is accounted.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Looks good, thanks! Should we add a test for it?

-- 
Pedro

