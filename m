Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F8CEEDF143
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 16:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F336B0005; Fri, 13 Feb 2026 11:24:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2746B0088; Fri, 13 Feb 2026 11:24:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4326B008A; Fri, 13 Feb 2026 11:24:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1386B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:24:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02946C075F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:24:39 +0000 (UTC)
X-FDA: 84439956720.17.282E6FE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id D14EE20003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:24:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zvmj6BHb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="kjQlr6Z/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zvmj6BHb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="kjQlr6Z/";
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770999878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ga3U0s0vERXULnme5wK2m/PPS3ABOz+dgFtObtH2Bco=;
	b=L5gT4RpL+XT+nLKy5YYsN15jwyZIGY6kbLRPbqI3k8nu2Xc74B57KZ1yANp8EJf5lLLt+b
	8X68pCRwuhuyz1OwiF6zezQgPVuAvddw6PKweTuX0HPOyf6D2LU64i8b0HHj5m7q6ZNCWc
	6prXAS9ZS1+gx5cyKdz3gAlpHuTa2KQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770999878; a=rsa-sha256;
	cv=none;
	b=xUDrBIPNvxlpnYGizmLCf8/xShExUPRjXmVYYCdpwD6rGK4mlDo2drGh0rYl5D1kQ62LZf
	Ov90wkgSNJZ/jXmFaxhpRQrfnmHoKWaqDD1VtwGgAUoqpd4ZLXNlFtjk/h4B6F7K65LolX
	E6V3Ykzm3afiyPfZYnTe3w4ZVZQWS3I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zvmj6BHb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="kjQlr6Z/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zvmj6BHb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="kjQlr6Z/";
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B7843E763;
	Fri, 13 Feb 2026 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770999876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ga3U0s0vERXULnme5wK2m/PPS3ABOz+dgFtObtH2Bco=;
	b=zvmj6BHbhK76BUhJOY5ofZpmUWd3kBT+ErqeoNyD09gbNlbrV4E814FSMmOP8h2w1UiJxg
	31YCML0pCwkNJBULBU93PEuQs270xJHZd5UFet0n/8GsjKclUD5eg7aXkZJbj6JoSKEYzK
	dBi3BoDW6QeJJVY83qoguyvdJXxB28o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770999876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ga3U0s0vERXULnme5wK2m/PPS3ABOz+dgFtObtH2Bco=;
	b=kjQlr6Z/Rf1pMHZ/b2LQRITaxCv4hNm8U0mXTqye/4kmMpPlz7ry5Kc0th2muz4sSiw0SH
	xuHe828kNoo+b4Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770999876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ga3U0s0vERXULnme5wK2m/PPS3ABOz+dgFtObtH2Bco=;
	b=zvmj6BHbhK76BUhJOY5ofZpmUWd3kBT+ErqeoNyD09gbNlbrV4E814FSMmOP8h2w1UiJxg
	31YCML0pCwkNJBULBU93PEuQs270xJHZd5UFet0n/8GsjKclUD5eg7aXkZJbj6JoSKEYzK
	dBi3BoDW6QeJJVY83qoguyvdJXxB28o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770999876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ga3U0s0vERXULnme5wK2m/PPS3ABOz+dgFtObtH2Bco=;
	b=kjQlr6Z/Rf1pMHZ/b2LQRITaxCv4hNm8U0mXTqye/4kmMpPlz7ry5Kc0th2muz4sSiw0SH
	xuHe828kNoo+b4Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7EE33EA62;
	Fri, 13 Feb 2026 16:24:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SKlzMUJQj2m1FwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 13 Feb 2026 16:24:34 +0000
Date: Fri, 13 Feb 2026 16:24:32 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Luke Yang <luyang@redhat.com>, dev.jain@arm.com, jhladky@redhat.com, 
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, willy@infradead.org, surenb@google.com, 
	vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions
 since PTE batching (cac1db8c3aad)
Message-ID: <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D14EE20003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: b75jogu8fb1b9u4s5y14jrqbkg6e4j8n
X-HE-Tag: 1770999877-829289
X-HE-Meta: U2FsdGVkX18Jhq26cdAMK5l3J4rRgzBtmoPlAWRmpE21B8hrH6XCyFBZ106/P+UZ3MzRB5532z8obcvnfFEyynps1bZoSu3b3wUMGyto9Qx5Z6tt3DQMFOgj0YBXSI7WXnOEv4uSKXwJDKJZaKoJnTYGkVSc/E1KylKhkGI576MX1m03f1C1BGZej7ibXvNrmJTt3nP+xYXSPDu+1LZo5Jgv4j3DcjJWed8v1nkvzv63E+D6/wSVrdEsJ5uHdLLoqvma2x1Jha536Q0fnH32dUgXC/cM+ZQsN5uClwH027ZgyTXlKTSrhqqdNSsMXDDzDWynuuBNWtw7zTxC7quyQY5Q3o5KF6equ1yRbNYL0muwqQDNPgoduRxaTaGYEREaS+IH97yq5oOU4S/sZGV1CpX6wgyHtGmGkGgTO4fkyxEfcBTwpTbXL22h/UMjFEvcm1HZUuGz2PirRlD5/clk5YMj/2oiko4wFLTNeuOV5ZRVgWFsRn/0Kaio7GjUL0WHPwZIK2XPHMtRB2bsCv+SKh0kSOPZgFon2E378zDdEC1Ffw0pFU/QUwqwwO+dTtsfNumLShwm3z696+uSJFR6VAaPyfV0OZW++rww7xzFPDrM0Rh7i26gqSeNYPhPeHxUcM4bywid5ULtpYbnG1GTO4ErH5z0dUBeEI8r2jwB8AW1xDwTC19QxpEmM+mCEH/FN5OK5/2A08YglEi+X9sIJ9+YDcoMVKmtjRf8B0/khbGNwINL2qg34eazIyPPAPS91kS408NCqQgQuPNKYonWCsJcwfD0qRzq/ooadH4MHuZAamJB9JH2diB48/yKJ34sIgfmrDLNuy5pAwcyD9fxUy2gBwf5kR4znsKtqLVht4j90PI+n9BSgDuBps8qug0ZNcOLhNZhEDsojBLtVVtCHQg0f7DOC6f+WD8KvN3IYWkfdUm1tSczob9wroBezRNVMB1D2/AkOIQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
> On 2/13/26 16:08, Luke Yang wrote:
> > Hello,
> 
> Hi!
> 
> > 
> > we have bisected a significant mprotect() performance regression in
> > 6.17-rc1 to:
> > 
> > cac1db8c3aad ("mm: optimize mprotect() by PTE batching")
> > 
> > The regression becomes clearly visible starting around 400 KiB region
> > sizes and above. It is also still present in the latest 6.19 kernel.
> > 
> 
> Micro-benchmark results are nice. But what is the real word impact? IOW, why
> should we care?

Well, mprotect is widely used in thread spawning, code JITting,
and even process startup. And we don't want to pay for a feature we can't
even use (on x86).

In any case, I think I see the problem. Namely, that we now need to call
vm_normal_folio() for every single PTE (this seems similar to the mremap
problem caught in 0b5be138ce00f421bd7cc5a226061bd62c4ab850). I'll try to
draft up a patch over the weekend if I can.

-- 
Pedro

