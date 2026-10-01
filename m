Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE17CCA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD286B0088; Thu,  1 Oct 2026 06:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4A56B008A; Thu,  1 Oct 2026 06:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA026B008C; Thu,  1 Oct 2026 06:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 329F36B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:30:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A81104037D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:30:23 +0000 (UTC)
X-FDA: 85273687926.14.BBF08CA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7668F1C0004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:30:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i0snoJfx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hgEpxfmA;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TxfXvwt9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hEU3N97n;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790850621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwZ290wnSkIXwUpp85i6pDwiw21bE+flaTKN+OYvr4o=;
	b=zTp/d8yqLvD4QU+4lnu/WOFNeS2PrpFCCeU3P3VfzCNLHS/eGfg+jLZJcgMbUayE8bo0dS
	MoY3ensoTttg9Jimzr9wK3+fvu/Qfx5kSJO3TYKnlGfmSat+0m7ZjhO5wOzI556mgXjv8g
	c8waSoCvlw6NG5mvbx3dhxj5M6I1v2w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i0snoJfx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hgEpxfmA;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TxfXvwt9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hEU3N97n;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790850621;
	b=qjEl1qcHrrIgTgdpHws8PBXW2YaB6dHQ3EHIKEQn99VvldZyXuikvWyHMFPjSdYfhsZsk8
	zk0EsITt8GI6oKB4zC8i1TeQWiMbanm1Y9wHTicGTCyNGK6CXYVm6wPEKBas4Jljp9NJMm
	Igo9GhWYkNBjNU1O4nUagoZ+yFEyWac=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE21E21EC6;
	Thu,  1 Oct 2026 10:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790850615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwZ290wnSkIXwUpp85i6pDwiw21bE+flaTKN+OYvr4o=;
	b=i0snoJfxSxpQ6DQu8h/GdZ/PgAtw/ecP5/inHGdWSDMLt8WeS9ATPC+mQGaCJKoh3k0e0+
	Ukt/XTodtHbVv8m0JQ4pkKZ0OzDpBoCOuWsySnpXXPMNmjI/2227U/dDv6gP420ZjkvK/q
	JOMwB3bk8R6pNFCs6zXy25XWM227kIQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790850615;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwZ290wnSkIXwUpp85i6pDwiw21bE+flaTKN+OYvr4o=;
	b=hgEpxfmAQmTTFbpLxw3fJiNuZSn2AJEJM0imp7u4aseHY+opU6npznHEWDbBz2eBfTOHMi
	lI8DJNrVfaIzCGBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790850611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwZ290wnSkIXwUpp85i6pDwiw21bE+flaTKN+OYvr4o=;
	b=TxfXvwt9Ni0K8hSE1wlRUnC/XnI2V913Ti5KTYPEi54mFrG2BZjD2SEmLQ4aHwX27vI1FF
	ha2XuJJS2yC+hVGSoW145TwF7ndlqu71WKMMrlv2A36sM1JNT0LXasYEMmfkC9/I6os3/n
	oJHemLa0DL7jlEZ+bhB/uLw7sfQ6LTQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790850611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwZ290wnSkIXwUpp85i6pDwiw21bE+flaTKN+OYvr4o=;
	b=hEU3N97nPglpmGyM3ugMExixlrbwcLfo9Imqjda2eZMMFrt71vgSfvsW+lA4dszwC4zL9O
	7xsSfQ97U0IiwNCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC8FA134B3;
	Thu,  1 Oct 2026 10:30:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9RwjLjI2vmpKawAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 01 Oct 2026 10:30:10 +0000
Date: Thu, 1 Oct 2026 11:30:09 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Josh Law <objecting@objecting.org>, 
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Linux Memory Management List <linux-mm@kvack.org>, linux-mips@vger.kernel.org, 
	Bradley Morgan <brads@mainlining.org>
Subject: Re: arch/mips/boot/compressed/decompress.c:undefined reference to
 `__ashldi3'
Message-ID: <ar4050mdKL_W8yI9@pedro-suse.tail5790ac.ts.net>
References: <202609301826.MFaFMsmd-lkp@intel.com>
 <20260930120159.7e4f29a82d461bd8b040454e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930120159.7e4f29a82d461bd8b040454e@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7668F1C0004
X-Stat-Signature: zg3reqasfjthu77y5xnkkfruirzjd5eo
X-HE-Tag: 1790850621-624711
X-HE-Meta: U2FsdGVkX18GGuwbwO6t59wrQn9mJbv6Zh3dcMDATcJmJKa4GmjKjxKkt0FckFHpwml1EGhF77PHBW3b1Syql203PtSqCHCvQUuRBSxFNZYLjXuPI+FxngzaGD2W9oug0YclgZsay01B0S6FEF9ivX0oOepntHTPWt+qRmPjjUkotVS9PH8UY2Hbadn5/AMSE/nF4+fSnss+TvLrojPH5MB6fRrwck1DfHpB1T+fmQNPKeznBcr8AKopMn9ZCK7WidekzoN5iFYjhqg6MlTU0R9ai0pDKO/99qvOOgV6qfujSe95GtaBId5B4XHRxylp/fk2rmo63zTpB5yG0lLTSXWUCFPTZvEe9bm00ntzqMtmAKK4odjoeABpLaOSSoHoIDgllSUmI0597CYLmVVWRf3dvAWqWrmWAlok8bvJrEf9nxoTeAoDvurFcEw50JtvknNoab7BnQF/ehK8LgkcIA0y+cK03YWus40mVfg2zR7jZPnoNNXABHFEZ4MxNhQUQ/BGd8N/WdE05r8uNwsb+sCssjqFtqUxkZ1H4v/e5WvmUh5kjFmKZaLNxHPzCsXX7uLJA7zBVh+LTJ4f1dZB0O/2pJ0M4abOfOoVAp0rUiPavz6CUAWwWqxskqAp4FZj+m4QiICIUGcdyvSHOl5+22/+9oSgWWdmPVSE65ayGSl+ZATwccVKxnZwR9drJjOPiH3hjFd9t1PM9o7CpqQ65r1Dgemq2xN2nUZOb/gQgnwEhPPv3EfLHUw9a4fX/Moi2p7tUmHepnIKI6CFwVeAfB1cGpnXvVPOVt/UMkYpvq9WQlW9QRmo5cxaIRNDeAC/ucs/Nj3Jg0T1/tk0VQsNCCVEC679/RL2a0CvNzRs4Zm3R0xakDcJJY5tRpt2LYMQ3iFql0tUclWKrYPLfPElOlMoPj4YVbqpvTTn7VShQAjeeVjOyXDSMFj/PAsNb0dp6OVua603ILl+sRZ1qV0
 jSOFrf5c
 2lxMB7pe2R8TgVIfD/fNTzDNdB9mQ+PKFcT04pelHzt/sDHQUmqS7+lYFJygAEosYMLSycYxsvI7fn4dYY0Ju9MWGOcvcOm2yddAsg/qDZA8qIKeJBMN5rJB2LjmFVzwY9CNZf87Y7AtORRxFzp4eDfCcrW6EBe3j2YDrimNmKlINt4HgrUiB8rXarp7smxW8X0sB7/QaDi0E0L7juGZfgHCjDZcTx6ygpMMxZPz48QkReDMO5acAPp22eQu8fKUS7KjJi3xS8z6EuE2QTz0AeT3rWze6upqTpBXj5ZBNjARsiY5ztLMaWN9xZvtglqAf/CjDyLKY9HsuHZiScHR2lwEUIe8fBbKogP1sWO/BQWJ7FfKUpiZUaJrM+5aLPZ6pJ55+8GoV+oS2iw5OEDh/4cwarodiLWJtj4kt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 12:01:59PM -0700, Andrew Morton wrote:
> On Wed, 30 Sep 2026 18:36:50 +0200 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   551c722f40809618230001baccf219193e22fc5a
> > commit: d4dba3b9c03a326cfa73833d6b166aeb442f82b5 lib: decompress_bunzip2: fix 32-bit shift undefined behavior
> > date:   6 months ago
> > config: mips-randconfig-r2300-20260930 (https://download.01.org/0day-ci/archive/20260930/202609301826.MFaFMsmd-lkp@intel.com/config)
> > compiler: mips-linux-gcc (GCC) 15.2.0
> > sparse: v0.6.5-rc1
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260930/202609301826.MFaFMsmd-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Fixes: d4dba3b9c03a ("lib: decompress_bunzip2: fix 32-bit shift undefined behavior")
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202609301826.MFaFMsmd-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    mips-linux-ld: arch/mips/boot/compressed/decompress.o: in function `get_bits':
> > >> arch/mips/boot/compressed/decompress.c:(.text+0xf4): undefined reference to `__ashldi3'
> > >> mips-linux-ld: arch/mips/boot/compressed/decompress.c:(.text+0x168): undefined reference to `__ashldi3'
> 
> I dunno, I'd be suspecting a toolchain issue here?
> 
> --- a/lib/decompress_bunzip2.c
> +++ b/lib/decompress_bunzip2.c
> @@ -135,7 +135,7 @@ static unsigned int INIT get_bits(struct bunzip_data *bd, char bits_wanted)
>  		}
>  		/* Avoid 32-bit overflow (dump bit buffer to top of output) */
>  		if (bd->inbufBitCount >= 24) {
> -			bits = bd->inbufBits&((1 << bd->inbufBitCount)-1);
> +			bits = bd->inbufBits & ((1ULL << bd->inbufBitCount) - 1);
>  			bits_wanted -= bd->inbufBitCount;
>  			bits <<= bits_wanted;
>  			bd->inbufBitCount = 0;
> @@ -146,7 +146,7 @@ static unsigned int INIT get_bits(struct bunzip_data *bd, char bits_wanted)
>  	}
>  	/* Calculate result */
>  	bd->inbufBitCount -= bits_wanted;
> -	bits |= (bd->inbufBits >> bd->inbufBitCount)&((1 << bits_wanted)-1);
> +	bits |= (bd->inbufBits >> bd->inbufBitCount) & ((1ULL << bits_wanted) - 1);
>  
>  	return bits;
>  }
> 
> 32-bit MIPS should be able to do this?

FWIW the patch seems entirely bogus. I don't think you can have inbufBitCount >=
32. If you could, then the patch would still not fix anything, because
bd->inbufBits is an (32-bit) unsigned int.

As per MIPS itself, MIPS does not link ashldi3.o into the decompressor for BZ2.
It only does so for XZ and ZSTD.

Changing arch/mips/boot/compressed/Makefile would work, but since the change is
entirely wrong I would suggest perhaps reverting?


-- 
Pedro

