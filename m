Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEECBD358E0
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC736B0088; Thu, 29 Jan 2026 03:47:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAABE6B0089; Thu, 29 Jan 2026 03:47:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61D96B008A; Thu, 29 Jan 2026 03:47:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A411A6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:47:07 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5577014090E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:47:07 +0000 (UTC)
X-FDA: 84384371694.09.8BE2712
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id CD6351A0007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:47:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JLhsJCWy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N6TMZz8d;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JLhsJCWy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N6TMZz8d;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769676425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayXGorl1oZA4YurCNlc7iXC86LNC/WuwB8s/B5m+MTs=;
	b=hmLdccwET77w4yfvWk70oJbbsYFiN3NJHtzB0XPMmkTsbuYAlWGNts/5VQaN6Pj7aRUV6Y
	Y5OvZEFK21n4AtuXiMvpklVz27gzvi50QAR51xA9h4DhUB/KVPHfSYUuI3QXBRDm1wFzgV
	kB/Z8Vulmu9s/SnpwJCLDyTylGzxsbc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JLhsJCWy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N6TMZz8d;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JLhsJCWy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N6TMZz8d;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769676425; a=rsa-sha256;
	cv=none;
	b=VoXwtjAuXwG3e0WqVe7otjioT2OK2BQ4tKDk2R9bpGSSFiCWFX25Ys4xIcHFhLu7v4SLwi
	vw26vaGAkTs1pPP5rkEWAvEnuTlLKKBAEEz0ur6c8Og+0OKxymulzHMYi7k3rc1z1xy9D7
	fpu2iat+cSjXzHsnv3cL/WeSFrDTcUo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4CE3F34043;
	Thu, 29 Jan 2026 08:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769676423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ayXGorl1oZA4YurCNlc7iXC86LNC/WuwB8s/B5m+MTs=;
	b=JLhsJCWyZj/bqxI9HrGk6is/Pa14mOfwDr5dzkveSKi5vguYOzYraVu2cJzXxIiRWgryFD
	rbzcVCxQiRhQR480yR9BC1dneluERAsY4nxcfBPtaZNWqKVLsaZaNzhcHlfKpAgVRW0XCY
	G5uq1j3sMRBeJX7QA6ieCcTINM4imKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769676423;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ayXGorl1oZA4YurCNlc7iXC86LNC/WuwB8s/B5m+MTs=;
	b=N6TMZz8dsfMRIB/BP7vTohjCq0I2IoB8cn+VDjvmG4PcC1bXCZQ+NfU60APmDsq7ayeHVM
	afQN6JevmuEQKoBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769676423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ayXGorl1oZA4YurCNlc7iXC86LNC/WuwB8s/B5m+MTs=;
	b=JLhsJCWyZj/bqxI9HrGk6is/Pa14mOfwDr5dzkveSKi5vguYOzYraVu2cJzXxIiRWgryFD
	rbzcVCxQiRhQR480yR9BC1dneluERAsY4nxcfBPtaZNWqKVLsaZaNzhcHlfKpAgVRW0XCY
	G5uq1j3sMRBeJX7QA6ieCcTINM4imKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769676423;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ayXGorl1oZA4YurCNlc7iXC86LNC/WuwB8s/B5m+MTs=;
	b=N6TMZz8dsfMRIB/BP7vTohjCq0I2IoB8cn+VDjvmG4PcC1bXCZQ+NfU60APmDsq7ayeHVM
	afQN6JevmuEQKoBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D28F3EA61;
	Thu, 29 Jan 2026 08:47:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wEqwCocee2ncdAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 29 Jan 2026 08:47:03 +0000
Message-ID: <3317345a-47c9-4cbb-9785-f05d19e09303@suse.cz>
Date: Thu, 29 Jan 2026 09:47:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [vbabka:b4/sheaves-for-all-rebased] [slab] aa8fdb9e25:
 will-it-scale.per_process_ops 46.5% regression
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-mm@kvack.org, Harry Yoo <harry.yoo@oracle.com>,
 Mateusz Guzik <mjguzik@gmail.com>, Petr Tesarik <ptesarik@suse.com>
References: <202601132136.77efd6d7-lkp@intel.com>
 <3dfb6857-3705-4042-9a30-da488434d9e3@suse.cz>
 <rsfdl2u4zjec5s4f46ubsr3phjkdhq4jajgwimbml7mq6yy2lg@krjc6oobmkwz>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <rsfdl2u4zjec5s4f46ubsr3phjkdhq4jajgwimbml7mq6yy2lg@krjc6oobmkwz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD6351A0007
X-Stat-Signature: cbnedx6uu4ztzrkyzo4b5w4h6std5d8y
X-Rspam-User: 
X-HE-Tag: 1769676424-459124
X-HE-Meta: U2FsdGVkX1+2gZAt+92aHGDChkAADSlqZs6eX43sghR504XB1TXMm2pNkQFNZHzdtgLYzIW8lbNs0OnMszqZRRvfpWespjRbg8C7jcXFlcyqeTeBwlKPUOwf5N/C+7eDszJWo7vsqDRoqCYXpvQ/GejKKn6P6e0eAs83zB8ChDsTAW99Xf2/NypLtC10ftU1RVWM/tXLF0rTGrvq/e2zQIYnal8/vNi4Av2jb9jaiwVomR6m1UTDPGSiR0KiKxrjDB7QHaYag5bcu9mFDVlp7HjrSZkUr5aeV32qQLj6uwS6+XQ6FRY3HBy5m8FNKElrmrDzxYrF/hXKQUtycFjDbWai/jnkqN7cHB3I4f/+sGKMitPbyqQTQ8s+g14Y8uzmWNdjDjzf0MPqRxhdbnjiyFUiN8EI68uTJCz6Y6yl0iIzQf3zP+5vQ7gXvNqjTtibC1z/fNRt8C4xZdZMbGLWV09t/XciHJay62Klt/9cQbHusBetaqKQCfafFcuzFA2/+cU/ygYeT7+Ou8U7C0F6LQmFvemkNUypA1ELQIeXExn6wnMrq+1jPPrOf/fog7yC20EQwa13T8RP991jHQj7A4Gapw1XF+drGuSHtC1pP0xWQTujFucKR8vlrzJ4rM4v/rjuK4ll2IELY+TqJ1P9sb0DS0auCQ30rfditONlDexs4k/KVljc7YHIso6mP9+NzoEXnJyqrlUg9wZ8Bg6JUeAgSVtKOJIia10xadVg5VcagDHzky3E+uq3BLpN2bMj6TX4PA3S2QJA5KT76qSuAy+Y2Ey74Ff8qifFnn8sT5MYg6jzxpbzTNFrOUVP3/W/B+SCZRqZIGmIYDi++9Cv1UjMqSvUUgyVmDJJeiG5SCpLN5QCLZokkqQSxC3EEl8RTd9O2CnbeZF4u8aeFfZZnlX/PzUTF72ZSf7tBgd8cDR/ATQFA3azUXzU2K+Iw/yTSZuXc6uXDEBmmeIlkpN
 JLweChbT
 JCbSNInyK1pUjJvAMhrSjfZZ3m/am7NAmPsuy1Xha62mMzcIgLKCmJgle1H/KmAhOQ+8jDEPN3VR6gva0TtVsWQRNfCdqsiTPkeduXJwcFY8N7lLjPgsBqTgn3MULS9aTobEgOdj5t1cgPKJG4NXpCQPsI5gSH176r9XBVVNNFY2xfKaxBRQ2/Xfuxe8RQ5j8MKhLaVCPtckW4r2ZlfAqfpG2hyDq8i/Yp9uGgLGf/P5LLCF2pueePf+5zeCLSHTG7sSrDH8mRRfWWg49B+9K4guCMInc5RxKDsfjQd87QLjKj75Mb5Tw4GUR6UF/oaIGNxAJ+ZUxff1lAnE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/26 08:05, Hao Li wrote:
> On Wed, Jan 28, 2026 at 11:31:59AM +0100, Vlastimil Babka wrote:
> Hi Vlastimil,
> 
> I conducted a few performance tests on my machine, and I'd like to share my
> findings. While I'm not an expert in LKP-style performance testing, I hope these
> results can still serve as a useful reference.
> 
> Machine Configuration:
> - CPU: AMD, 2 sockets, 2 nodes per socket, total 192 CPUs
> - SMT: Disabled
> 
> Kernel Version:
> All tests were based on modifications to the 6.19-rc5 kernel.
> 
> Test Scenarios:
> 0. 6.19-rc5 + Completely disabled the sheaf mechanism
>     - This was done by set s->cpu_sheaves to NULL
> 1. Unmodified 6.19-rc5
> 2. 6.19-rc5 + sheaves-for-all patchset
> 3. 6.19-rc5 + sheaves-for-all patchset + list_lock contention patch
> 4. 6.19-rc5 + sheaves-for-all patchset + list_lock contention patch + increased
>    the maple node sheaf capacity to 128.
> 
> Results:
> 
> - Performance change of 1 relative to 0:
> 
> ```
> will-it-scale.64.processes  -25.3%
> will-it-scale.128.processes -22.7%
> will-it-scale.192.processes -24.4%
> will-it-scale.per_process_ops -24.2%
> ```
> 
> - Performance change of 2 relative to 1:
> 
> ```
> will-it-scale.64.processes  -34.2%
> will-it-scale.128.processes -32.9%
> will-it-scale.192.processes -36.1%
> will-it-scale.per_process_ops -34.4%
> ```
> 
> - Performance change of 3 relative to 1:
> 
> ```
> will-it-scale.64.processes  -24.8%
> will-it-scale.128.processes -26.5%
> will-it-scale.192.processes -29.24%
> will-it-scale.per_process_ops -26.7%
> ```

Oh cool, that shows the patch helps, so I'll proceed with it.
IIUC with that the sheaves-for-all doesn't regress this benchmark anymore,
the regression is from 6.18 initial sheaves introduction and related to
maple tree sheaf size.

> - Performance change of 4 relative to 1:
> 
> ```
> will-it-scale.64.processes  +18.0%
> will-it-scale.128.processes +22.4%
> will-it-scale.192.processes +26.9%
> will-it-scale.per_process_ops +22.2%
> ```
> 
> - Performance change of 4 relative to 0:
> 
> ```
> will-it-scale.64.processes  -11.9%
> will-it-scale.128.processes -5.3%
> will-it-scale.192.processes -4.1%
> will-it-scale.per_process_ops -7.3%
> ```
> 
> From these results, enabling sheaves and increasing the sheaf capacity to 128
> seems to bring the behavior closer to the old percpu partial list mechanism.

Yeah but it's a tradeoff so not something to do based on one microbenchmark.

> However, I previously noticed differences[1] between my results on the AMD
> platform and Zhao Liu's results on the Intel platform. This leads me to consider
> the possibility of other influencing factors, such as CPU architecture
> differences or platform-specific behaviors, that might be impacting the
> performance results.

Yeah, these will-it-scale benchmarks are quite sensitive to that.

> I hope these results are helpful. I'd be happy to hear any feedback or

Very helpful, thanks!

> suggestions for further testing.

I've had Petr Tesarik running various mmtests, but those results are now
invalidated due to the memory leak, and resuming them is pending some infra
move to finish. But it might be rather non-obvious how to configure them or
even what subset to take. I was interested in netperf and then a bit of
everything just to see there are no unpleasant surprises.


