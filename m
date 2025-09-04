Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9131CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36D08E000F; Thu,  4 Sep 2025 11:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E2F8E0002; Thu,  4 Sep 2025 11:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCEF8E000F; Thu,  4 Sep 2025 11:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF1038E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:13:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90E0DC0208
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:13:11 +0000 (UTC)
X-FDA: 83851910982.14.E634DF2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3019240015
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:13:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="JRX/HJLF";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HhbyZPUX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="JRX/HJLF";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HhbyZPUX;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756998789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uc0MFXmurty/MFvGV5vECjCPl62NXr2oSZ/7oQCP8eM=;
	b=SGa0X29xDICPODXLx48NS1g19fouV5eIYVjG0+onm8TeS4RWP1I4acczliR7pEzncPV7Gy
	lLmesE6zm2/iqfsuqy4/zlqLu5YjcYzOylWb3B+LCjxUz6kmegeJitfVKqVfgnnKziG2Fv
	Nb0zEC89tSyCHLXO7sj/cJH01up7oA4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="JRX/HJLF";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HhbyZPUX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="JRX/HJLF";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HhbyZPUX;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756998789; a=rsa-sha256;
	cv=none;
	b=YvZEJaKoy+DmraL5qLzeqjgJgdAQsVzqByjuJT+P+EUAOEbPJPT28im8Cx546HdpvwNaYG
	5Gc13NNJwNYYBjYsk48seuO84auD7AXjoicjyAfgUQS0mb8yv/oBHYogVi4MghPX1FGwue
	QaskJqJLOsdriJ0r59tJdT/a1oXKpJQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 826B5374EC;
	Thu,  4 Sep 2025 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756998787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Uc0MFXmurty/MFvGV5vECjCPl62NXr2oSZ/7oQCP8eM=;
	b=JRX/HJLFtZ2zK7uDWFxn8a/vcX0uyoAzkO63iDeOOwRvP2VGrn0i8DKEl5tl6D4/5vHxFa
	LfXRrhBSOBBa30+RzeYMDva/TgI5eFf1SGVOgIYgoo8+302iZOFT8Mla6dNOOOO2ZtPkjp
	2Wnta+ZxIrxoG4INVnjDGfQ/+eC3Gpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756998787;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Uc0MFXmurty/MFvGV5vECjCPl62NXr2oSZ/7oQCP8eM=;
	b=HhbyZPUXOEhsLdadh4JNP0yAKrp4oFjWCHVhst/FoD2F44M11TMbTsbFGJF1S6WpDoVEUK
	MZixa4GfA1x5XAAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756998787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Uc0MFXmurty/MFvGV5vECjCPl62NXr2oSZ/7oQCP8eM=;
	b=JRX/HJLFtZ2zK7uDWFxn8a/vcX0uyoAzkO63iDeOOwRvP2VGrn0i8DKEl5tl6D4/5vHxFa
	LfXRrhBSOBBa30+RzeYMDva/TgI5eFf1SGVOgIYgoo8+302iZOFT8Mla6dNOOOO2ZtPkjp
	2Wnta+ZxIrxoG4INVnjDGfQ/+eC3Gpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756998787;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Uc0MFXmurty/MFvGV5vECjCPl62NXr2oSZ/7oQCP8eM=;
	b=HhbyZPUXOEhsLdadh4JNP0yAKrp4oFjWCHVhst/FoD2F44M11TMbTsbFGJF1S6WpDoVEUK
	MZixa4GfA1x5XAAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7177D13675;
	Thu,  4 Sep 2025 15:13:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vvBQG4OsuWjBBwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 04 Sep 2025 15:13:07 +0000
Message-ID: <12b43696-d684-4502-aa48-6179702c8b11@suse.cz>
Date: Thu, 4 Sep 2025 17:13:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [vbabka:slub-percpu-sheaves-v6r2] [maple_tree] 99848157f7:
 WARNING:possible_circular_locking_dependency_detected
Content-Language: en-US
To: kernel test robot <oliver.sang@intel.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <202509041248.b7ece14a-lkp@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <202509041248.b7ece14a-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3019240015
X-Stat-Signature: 8txa9rrfndowtjugcgxhsutt5q3ufgc9
X-Rspam-User: 
X-HE-Tag: 1756998788-73331
X-HE-Meta: U2FsdGVkX1+DPmyr9+t32MBwse5Epy466X1zsIzpHgJu5O8e/t+1kBogQcHAexTvgUsjTQUNTYy35EsQK7Vj+Vvjp5GioDujAJHVn9ysNNVxB9+AIRiMpc1KNZg8z+Gw9dF2Sw6lNOnPzqj0gHvDLEneNifMv8Ytq1QGE10MAxgVjajcaLzPoiuy3EuMHhfVB5vU4dtgBlCSGdpwdlBoJtkFqlAd+R3/pXLd0w5EdmkGQ6LjDcb57GiAYF2F7EzmP0tdk5bU0fZGVlWmLyAr38oVuhdLMn94pPh/NqYH2yGgEcfDxQS546RNIJ/3DOzmnncP76gqj30ABUyVG+PJXjeDv1pYaZkNy99Hr2ptsJNjnrIJNhi3nXYj9G1mnIy+URNe+8R96tjRl2fMEYcusceFrR1PrX27OEGgxEoRRMsLbMEEFH/KwwFiGLs8hPBQwa3072vfN2loQTI+3djZ6C//Fs4aUgYZ+B3FlNRMRn+HpTftvu8JrlESDx3ZSlnbu1DI5sWaXJP3yx7wPZ7Ai0MeDg+zHCIfI/sT7d8cw5cqwSRUEHl0YSW3Ucb36rQrLI8NFEdB367uFHWjNH43h4rcJgdCmHdQf768bSfEX9u3ZaezLx4CXwgnfNZzAEVt1j1/0ehG16xEed7PZ7plqyElBtVEgrtOpg2ePwLnMFos5RpE2goUeB3I8Nhbu0JhxZ3QKN5jBN1rD2QTQm4SBMY4Y923OWsjrRNTDyQGOqgNtlKBOjERd6KKwgh3AIcdQ1NboUa/4Sxk6BPYmFIXXfAqg+TEb7Nd+Srv/fw5Ll1D5UZMiDhG3VOdu62AkaeM7J8SMfM+vnQnjYyKBsmXqvkQ749STqajllK7iHDEFXgc0ZN8UTDcmIy+9pDoO127HCzQa9GSsK8R+vru4Z8PPyM8m8hQmlUrDVRnIr4ZAvA+qOtyiGa5IVfBFKRmGtHynRFNP3tJjQQL9DdoDQT
 JZAb4S/M
 rybf833PWXTb2/X+ADHJP6FO4dslo6CJbEjRyEVWDcLaIrLRpOFsaQKDEx8x+OKAukkKwEH8OoyDRatqDAiu2f1AKoJEI+B7fEG5ZlyvO5INrdyKj4eSuktqEN8mDRnWmsBLsrh6+HEYKIKCOQZErtoeaEhCRQcupp7mYkFHnL43Mt/837GSvJPj6NV+WTfHDaMreFndu2sh+ufbb2Po2ZhRyIkPEG0cIp0zjy/ugswLEu46u4hQ1oKMfieWmDdalcymHXA33K7F0+l1AEurCjPRWFVKDV68AeJcjdTmJjxLnqzOkirmkhYLVwwNqx+0qOShUBjWOH45y1BXPq2a1yrVzUA5FllgZ0U0mP+a4yH4QLEqzNT9ZM36UVhIhveyOH0u4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/25 07:20, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "WARNING:possible_circular_locking_dependency_detected" on:
> 
> commit: 99848157f71c03ca5e975b0e686def1d66e8b19f ("maple_tree: Sheaf conversion")
> https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git slub-percpu-sheaves-v6r2
> 
> in testcase: rcuscale
> version: 
> with following parameters:
> 
> 	runtime: 300s
> 	scale_type: rcu
> 
> 
> 
> config: x86_64-randconfig-075-20250831
> compiler: gcc-12
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202509041248.b7ece14a-lkp@intel.com

Thanks, will be fixed in the next -next snapshot.


