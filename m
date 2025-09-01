Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 617AECA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 21:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E438E000A; Mon,  1 Sep 2025 17:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6278E0008; Mon,  1 Sep 2025 17:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4F98E000A; Mon,  1 Sep 2025 17:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DCA68E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:34:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A6FD1DEA8D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 21:34:43 +0000 (UTC)
X-FDA: 83841986046.10.6C49CAC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id B524840006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 21:34:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w5HOZZK5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=26ZgJpUX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w5HOZZK5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=26ZgJpUX;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756762481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPxUiaRg6soTQDF07lejlfC95q4iGKbnFlkTeOnIAvc=;
	b=xyEttMlJaKB4rlIU3KJqCqT0FH+i2aCEJLCSrKElzF0gpNqK/pOpPDx+A/FFnOEVBQx9qK
	5Mbc0WP5/VVJ7vIgGsrhM8nU3HruLbWIZl8xc7QwEUejgQPX0sVtu+mJ1AqBzJRTDpVdZT
	WOhsx4y7uGOyXyZjv0hw+ltmtrvQWOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756762481; a=rsa-sha256;
	cv=none;
	b=ZdO9ed7tueKHOEEiYKWODHaDQzZUItQdzo7Y0noThjKLiowJRBxA1vCTI8i4q8h51Br5au
	AM6jelBIwEIhM+mSz80hy8CvIy7AJs0QMu8WPD2khEPiJ/5pYdQ+GIFELx/gxokHyJoCoG
	6g8R7H+DkwlALCZF5LmsoUZuVc8WTrY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w5HOZZK5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=26ZgJpUX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w5HOZZK5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=26ZgJpUX;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B8CE71F395;
	Mon,  1 Sep 2025 21:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756762478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xPxUiaRg6soTQDF07lejlfC95q4iGKbnFlkTeOnIAvc=;
	b=w5HOZZK5qWU8an95Ym39uEkiPR2a9SnVPTgU8rmr1wVjbVLe6+Vl8np8QZthgnIqJpFGt+
	RmdtcR3BqPc26hEkdat/ftO3B2APspXuyNcxaRSZWN/fbD1Z3RViGlxA0orSFIcG9iQNh0
	gkyG7Ip/exp8e1UwfVwhbOo6DqnKMOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756762478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xPxUiaRg6soTQDF07lejlfC95q4iGKbnFlkTeOnIAvc=;
	b=26ZgJpUX4bmCWjNPYMxLKg91TXhkiT7zJJvsWREhtieeMhAqt8th7qvTLioAvmm/9CL/kh
	7Rlmd+90XJ2pqYDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756762478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xPxUiaRg6soTQDF07lejlfC95q4iGKbnFlkTeOnIAvc=;
	b=w5HOZZK5qWU8an95Ym39uEkiPR2a9SnVPTgU8rmr1wVjbVLe6+Vl8np8QZthgnIqJpFGt+
	RmdtcR3BqPc26hEkdat/ftO3B2APspXuyNcxaRSZWN/fbD1Z3RViGlxA0orSFIcG9iQNh0
	gkyG7Ip/exp8e1UwfVwhbOo6DqnKMOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756762478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xPxUiaRg6soTQDF07lejlfC95q4iGKbnFlkTeOnIAvc=;
	b=26ZgJpUX4bmCWjNPYMxLKg91TXhkiT7zJJvsWREhtieeMhAqt8th7qvTLioAvmm/9CL/kh
	7Rlmd+90XJ2pqYDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6DA71378C;
	Mon,  1 Sep 2025 21:34:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ReOlJ20RtmjvSAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 21:34:37 +0000
Message-ID: <024e3400-6529-43a6-9c11-3b80af79b5b1@suse.cz>
Date: Mon, 1 Sep 2025 23:34:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/12] mm: establish const-correctness for pointer
 parameters
Content-Language: en-US
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 david@redhat.com, axelrasmussen@google.com, yuanchu@google.com,
 willy@infradead.org, hughd@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, vishal.moola@gmail.com, linux@armlinux.org.uk,
 James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B524840006
X-Stat-Signature: nj9q43tx434k9japik95xsxete4xh8x7
X-Rspam-User: 
X-HE-Tag: 1756762480-549684
X-HE-Meta: U2FsdGVkX19bQ850Rj8AIWOGgB2ZWM4rV1l5VSv83aLgEqpTv9VmFxLj0x5J/9P/2dWOFb0kjYB4NYaKZgC31GMYR8qgpeYIoMmb7dUXYmVhMB8TuBP3gfdopZcIVYTPCU4sk3KL+PrxdPod7llUguWWMELMpLrWT/7CgVCY3we0iin/eGeyO7zXbfiiyadmiYqnD5+nZ5XK1P6Zx66ZSNwNOT5xIGGA9NSBkpQdeyvyIvZGliMdCb7MvPuNHN7igbiq7w+glkVofT1TxPIWQaP/q5KN+xArNpHRs11mPx4ENYPVPDw87q0pD10sacfcCEAS3wBikaWumHgAqQceDQUojuJ7pBCdVkOMs6EG3UmCSx4eiP0CZPKDQs3xYcNHEHX7H0nux4U28qc3GmKh9nFfMnM2ptvrua9tAQKxB1TD/WRK9J4BrZo+Vza2+2grwkL6siqPCjTajJgEPZokpCY6hp6HMNbVVsNDa3jzx4r4K8QCbjNvmY5J5dAmdzX0XI8REq2mhxoh/wMaPhZNPRQ9x46h/QktkjX5GD1pFClryl+ytmF9Ut2A/IxH2+Y7CmuO0HXbifj9VydlBCz+qyMREqDGeQkHxopA6wi7YpBYE15UZoHON/QZBs33JG2TsBdwyvmzICiTb8qaMFGlv7Fb8XTyGsf4LeOIZP3Fh3rnBo4sgIAvBHpuhWX8wRTta/3oCns2XfD1ELTDe94olW9tvHnRjw3XL2n17Qk4nDPvvgZIMvuqHPFE6pGuHZTKWJHq0PeM4sToq6k8+pa+hJU08sysTF6IOrv6sLGxiKA5Txs3EdUeBryMUt2PjjND4nP7Zlp8ME3C6EMbJ7Lfyk5EGgZBanL1loMUOxGGr5SP8CKFnA4hH+FvD3wkKp/jwd1dOdPHy6O3laYlecsYr3s3cBxiiu64R6n+GJ88Z+yNRqjldhGLugAjSBvZnIxYOiWz5AqjF/N9qgmLWxH
 EkyI9TPU
 5sqkVDho+ozGo83aFceCHZZUYKpkg7/ciqe97VcoztMam2zOkO04BhflR1LryWCyg/H4g/quNqoU3Esr7KyhPzZWHyUWCBnGL7IpHyg25zAaiWPhsWsSIHaR7BxwMq5bFgR++XboqGLKROkKj9k8D3UqfoRr7I/GWbmrL1RUxRsjrPVtWdDuCOpHyi1VVyKSF3aHPLNnWT8IJShHYMUJ+esOvrGTgDLs8o1KyQikKLa77sRDttXuYnABHHW4yOTSJtojefzTcIn2mw7igdbuF0NQzjSpKgEXd/kANED2wdHGuu/SfYFadU0NqUUK3SnZB7usAxE2KdmwFKrFRCpY+BOWOXDrB+IjUm3QmKBtCBxuC/otIivZxPaY27njhw10DF/ChX9+VgfJAQYCF26tb777LVjZiuhPdib3RKiLHArFiZMnu7pxAYrTWM2pVDmhP9vVAD97dHjiihHddB2rF+vVAoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/25 22:50, Max Kellermann wrote:
> For improved const-correctness in the low-level memory-management
> subsystem, which provides a basis for further const-ification further
> up the call stack (e.g. filesystems).
> 
> This patch series splitted into smaller patches was initially posted
> as a single large patch:
> 
>  https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/
> 
> I started this work when I tried to constify the Ceph filesystem code,
> but found that to be impossible because many "mm" functions accept
> non-const pointer, even though they modify nothing.

I think (and tried to verify with a lore search) it's the first time you
mention this motivation and it's very useful to state that, thanks!
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>



