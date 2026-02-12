Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1BA6EE3697
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 15:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A07B6B008C; Thu, 12 Feb 2026 10:28:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B216B0092; Thu, 12 Feb 2026 10:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042DF6B0093; Thu, 12 Feb 2026 10:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7E316B008C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:28:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D8051B2857
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:28:28 +0000 (UTC)
X-FDA: 84436186296.06.13C0B13
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3AA14140008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:28:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W27sjswi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jGwcCSjI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W27sjswi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jGwcCSjI;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770910106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6Ok7yayDSj8orWu5mTwXnKKhkzyIWcEaWvhkksfU+I=;
	b=yuFJL28yThKOuRaGajvm2VAQNNbofYvYsLWTQ/bTClbsYuXq9pc+DZ8sD5d+Jaav0uG0Lo
	xC+FHWE7EcaX02Sy3OaVXT/qaI7xB6fwzQwT26/jtGP0DhaOw1F136p6at4A+pF4zOanlY
	NIDCtNYrfCU7A7caGrpL8aod29KLfxc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W27sjswi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jGwcCSjI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W27sjswi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jGwcCSjI;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770910106; a=rsa-sha256;
	cv=none;
	b=gBE79t1G/S6qLGUXlRNcrvG0KPuhmgH8+foc2zXBdm3jHsMHg95hMo3xp6F8tTWu8DnaV5
	HqMUyNe1NeZ9vYHPcJFbFfl43cw5FfXb4QRKNMdx1TKQyvRKY/vdZPFLtS+fiWAGJzkSZ2
	d6nmoukUq+iv/p6EwQ3tK6ecpI2/9U4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4FB745BDB1;
	Thu, 12 Feb 2026 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770910104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H6Ok7yayDSj8orWu5mTwXnKKhkzyIWcEaWvhkksfU+I=;
	b=W27sjswiPFhRjFyxLmKyVhaHTw+oGCRytro4u60AS9rG1tmn/tcETrbEeCsYW76GH1CO9N
	7beSRbDDVF5qLcQN5V9HLo+9/7x6UoM4dPnr+T7Y6SDV34AXz4FXpxTKwoGBY3cMxg4GNn
	laBTaqE73JMHHxPiR6zYkHmL8ALXIUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770910104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H6Ok7yayDSj8orWu5mTwXnKKhkzyIWcEaWvhkksfU+I=;
	b=jGwcCSjI8s00pX6bW9fUMyiN3/8PM0hFJkVOrvxvMRy28RDPVq/dz18/gDLKnzlJGXNCd5
	NrWS+vbROHtGETAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770910104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H6Ok7yayDSj8orWu5mTwXnKKhkzyIWcEaWvhkksfU+I=;
	b=W27sjswiPFhRjFyxLmKyVhaHTw+oGCRytro4u60AS9rG1tmn/tcETrbEeCsYW76GH1CO9N
	7beSRbDDVF5qLcQN5V9HLo+9/7x6UoM4dPnr+T7Y6SDV34AXz4FXpxTKwoGBY3cMxg4GNn
	laBTaqE73JMHHxPiR6zYkHmL8ALXIUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770910104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H6Ok7yayDSj8orWu5mTwXnKKhkzyIWcEaWvhkksfU+I=;
	b=jGwcCSjI8s00pX6bW9fUMyiN3/8PM0hFJkVOrvxvMRy28RDPVq/dz18/gDLKnzlJGXNCd5
	NrWS+vbROHtGETAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D39863EA62;
	Thu, 12 Feb 2026 15:28:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bltXM5fxjWmBcwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 12 Feb 2026 15:28:23 +0000
Message-ID: <a5b8f7ab-b9cd-4ca1-9192-d0347a79a2c0@suse.cz>
Date: Thu, 12 Feb 2026 16:28:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] mm: rename my_zero_pfn() to zero_pfn()
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Will Deacon <will@kernel.org>,
 linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260211103141.3215197-1-rppt@kernel.org>
 <20260211103141.3215197-3-rppt@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260211103141.3215197-3-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w7z4mk6ey5rynjfcx9ha88h8ysd9u7w9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3AA14140008
X-HE-Tag: 1770910105-242619
X-HE-Meta: U2FsdGVkX18ysXWPN+pNa7PHvWM+D/XnammL4AUjPWgwuHVQJgSFT1O9LAcZ9jaoaTK6GcWwD6dHkbKyHTp/a8sRP4Svl3J8Dzd4/6ycq9DIPBaXxN2nfb3tm11x9WQVr1Zgt0og2NtxDE6OOMZlf9IQ8fgJvk6JlQhFhLoUrTPCEcP2+Y8kHEzAJrHpJpp46HbkUORG9IcVzgj45Sl3E3yQ/yRRjErcJbJmkiOb6Ym9hxF7lyWuG1uS6i6olxIoG++THnih22YHdNBz0ylqxe9B6Ck74bz7AmvMBQO41dfIohbSu5A5HFnBwrmo3e3pMgt7341hlsyPEFbPbFRDaeL+UAhgqABEdylgIvKEL4OaKnD2QtU5WeFhYPusWc2cXyxcD2FnQYpzCchZEae1d5ufyrFVIJ7A2v0qDD3jtDPHA3w8xMRK6JxWnA9GQ8llVOsAR88javTWr+a5o5+Yn85tTGOUe81yvE+BXUp7YYTnkLkK4kfeDpo/gRWUz2ONcAU59PmOCkhgFYV4u6xD3zZfwNKdjzyiSvDVm//jpPuhESZsziLHYw0+RUyXHYfa8ANqvUyJqPQ9DzgQXcJSm8bZSwdwjpIgwbrLBcKxR+41c64t9x9LnLQxtbpFYt41QIL5W6qErMQqKYEoeyKnAVbd3HMI0GBc6PkNBCR6hTpE6o1r4rZXfaOt52WMvC7cw+TyImx210gPA9b6xzm2idxeGwwUUZj2q+YeRox+ZaA9vVrROikjBJRri8MCWiwSMKxB6mX/Et0zGmVVawOMIDVXWK+/J0l7Px+UtRa1wXu2Y3xb2KpNegIKO9u0LMIsoXz8XUqIKtkF8a0mW/OcywRIO0NLn/xazGm07VUL8CVaNBGd+rerj8fz1rIhvXbzCZNgZRWmWX2bOIiJ3ik9KJT7WXg+I0bwW0dA0eZmNGR4kqR5/TviZN0qQJKjsAcAwJ6irgOJJ5R9LEQrKjk
 vXQR4g97
 ON2dqxXWOgxBwfppDazCP9YdwJGf0PsHUQsqaM7//N3CNPPThj82n2wEsYo37ieubqo6ZmN3QNQmwYacd9VPqOxeqHEEus2T/N1BTmGHzFf07f6vTS8bUxgtVTnXC4NN4r+FlMDpnmlHztAkDCz5zpn2tL4s38lNOMtIGLBiubeWglJpcFRhZuFZpnUX09ldijz+LO0U4BAFN16ySuglTdC0iWTOVAzqdVyvnh+aIqXZI6mNvVOQVDR5nGulbTha0Tr4t5j7EZHOg6a6qMDoqFa15iqboCb4Zp1eTcKjEX2WBpOK+3S/i9+eneYbD5owUA4nnEFMT/JGFDnmw8dqImlAFWPwLzk9H5b05
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 11:31, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> my_zero_pfn() is a silly name.
> 
> Rename zero_pfn variable to zero_page_pfn and my_zero_pfn() function to
> zero_pfn().
> 
> While on it, move extern declarations of zero_page_pfn outside the
> functions that use it and add a comment about what ZERO_PAGE is.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>


