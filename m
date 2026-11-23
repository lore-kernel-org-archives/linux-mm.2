Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5C8606A685
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=3VkflIru;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=kAAiYpzk
Received: by kanga.kvack.org (Postfix)
	id D2D686B05B1; Mon, 23 Nov 2026 05:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05BC6B05B3; Mon, 23 Nov 2026 05:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A996B05B4; Mon, 23 Nov 2026 05:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A32046B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:03:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EDAD40867
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:03:27 +0000 (UTC)
X-FDA: 85465946454.11.2F2C529
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id 822AEC0009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:03:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3VkflIru;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kAAiYpzk;
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795428205;
	b=SAdmpUif6mXtTTxu23rsh1jfoqyx9ICm7Beld5CYq7b1AKSpau+ksw14tGWau51nTfsoVe
	kt3P52TEJJxJ3689t/Zz5Jdq8pgB4fEXQ4an1FwMgQEdpmpK1weL1dH07O6Z/bJ/JzJr5h
	zVdknHmC4Dej9OSe3qKVbk1vtH7tsYI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795428205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CD4ic9Gltp6sjM8mfIwiECFvv0TUSDYXBdZI3py6+Hs=;
	b=YDT8f8mbjUo0yXoHwqeyLnbzyC1H0VyV/Y+rdMKeqtjS0fjwqkYSNEQRcQRz6A50xKDm7C
	gHQAcGqCP0uETEPXMrCorJU+XF3JOwzINKS917Gh9k+AyKXBgMTwfxm764lydPlYtbVX3V
	1iWQRYoGuIr2VVUrYW7IWMQLIy5KgAs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3VkflIru;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kAAiYpzk;
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Mon, 23 Nov 2026 11:03:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795428203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CD4ic9Gltp6sjM8mfIwiECFvv0TUSDYXBdZI3py6+Hs=;
	b=3VkflIruKARozyrkLHlX2mQ95+oFUmmPQ9g7O4L3WFJ+V/4YkuEfXhftFZgsdG9N+ReUrC
	3ECXYSLczZ5sfXJmW/dp9rUJNM/FMjQfywHZgZtQzuHb0kSoe7hHEhJUgFIKC0qG05v5/W
	deQUhf+pARzVbGBEEIbo6yBX9OA7AK30MKgGM9nFf9PO5zjwkdkfGkZM9cxjaj34VKvOsw
	myOUpmdrBt4nOPgZIRTrtBBjy4he4UJ8IukvSGDbAO08UnI4M4oCeuCrk04sAimvWyNpHh
	OeIZxe3E8yO3AcaESf76ss7nR72GuxDw2HX74Yv5N4Yb5IVJ8j/g7DgcR1hCiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795428203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CD4ic9Gltp6sjM8mfIwiECFvv0TUSDYXBdZI3py6+Hs=;
	b=kAAiYpzkfztPq6MYwun6e1Y8Vy2mVk9Secfye9usXniusBTfN7Fozg38iBhnOT33Y8lwOo
	+hHvYlvL/ixDdMDQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
	Paul Walmsley <pjw@kernel.org>, Andy Chiu <andybnac@gmail.com>, 
	Magnus Lindholm <linmag7@gmail.com>
Subject: Re: [PATCH v3 00/15] exec: Remove AT_VECTOR_SIZE_ARCH from UAPI
Message-ID: <20261123110111-6431e85f-39a4-427e-b545-2e7a590a6c19@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
 <ec5359c1-c16e-4177-8dfa-2ae5ab8a874f@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ec5359c1-c16e-4177-8dfa-2ae5ab8a874f@app.fastmail.com>
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 822AEC0009
X-Stat-Signature: 5nwk9x8xwhx18qfosiw414mjahwoz5qh
X-Rspam-User:
X-HE-Tag: 1795428205-970633
X-HE-Meta: U2FsdGVkX19qpcTKO70TR5E3p7kdffeS0RIcMJLqZ5hAEJkWe7Yd1cRXmiLJu+pSFIV8nXA5dsyo7nSb+33QLm62eAJeZh0tyoQ5Bd2AcJX525e/z8EEtq4L3+15/3I8YfVitPda/iGCsQRt+ma9PiUYKfo0hQlNg5GEgA4DO4Vjrf02Wvduk+yI84XtyQBP58DXYTLR6Cm30+7NXH7csM9Q4zWK9gGQhLijffcgsiCMuWbKp8S6i0lGI7G4igijnfIvCn19IEQLtDrdmIZ2H401F0t3ErGvfD5jT4g1HVEe2eoXr+72tvv646n4tbeG4a+lsCkz1dRKiR8ep1iA6QazQwEI4DZ5nlkdGBeGCJShQ+9pbczvdmLPyzyjs1gXwVNLelD1c/6U368a66Wn5SmhMyFlNIl6Tp5+mDoYA5oXBfoF63pp9Sb0wpn6bQKzQXIwZyloPoi769fRbGiKw+yd7SCWf7ZCIRznRV8CkJczVrjCouMVayCtKOXafTki+9dkhBIHBH6Qa1Dw8NLrmcKhwgSJ+GGmyrafsz+SfTci+icnXWjwH9PvZw5e32oDSEdY4iMvPsfegoTy1l+rgly5B8517sy/g0ez83oSK0LPqxKX61AgDFpt/WNi2Zs1QBjechJMSlpzwHNHM3zrrtQwRfydf6Hru8Mlnnfqo7oyS7jb5pbUQRUB/pRBaTB9+CABCiP/tdQi70v3UDFvNCNUvh4myz9vwCR8eYvXfJt67pgvSOeCKSDKJE2AUGJO7efLpaelak5mUky4o/dSZHoFh1lY7PKdGzEFNM6OM5qAERxC/EAXxbjd/JdwCERa30pkHgTD/HdX2Q2E2BUikj7tSu0YI3nVsrlOZwWh/1pLmK1pKVGjjyPGsF8SZNFJbUp18OzmzRn9vUMRfiC6Je540If73CAqilGk1hdnzWgdy2/RHyJAtdm/OTC0+uGMseXVI0f+V1h+Rgyg1LS
 qx++4hO0
 IoHgaCJZoNWWYwE4GLBvt1ov0YaT6scCG0QmWr+0Tj+0Hl0Zyftx5W1wqD4pUseLf3xE2VW90SHpICiUofAzngimzVJE3L64DJaNz/Txwr07NhE8pfBlU3UQr1p1GdDuBqwF7htafeTDifi3yPtCwJqUYEd7E2MBf5fnRjA7M+radZWnbRlaMJncV7uJnDhH2OzdQuJnyqyxXKkLThFH+8p1JJPb8ap4ztC0k6j5FE+BRULVbpF9qFWXfL6Yzvt6KI1oQHRou9OZ8rV1o9tVUzhJc8LkKNQM7Sm39uXLSxlHxGLzvy3JaqDDZNwc2lAQnf0FibazXdA3ikiApCjGmvy4cPaUeBlIV4m1aGhgnoILMjUxAbgDPnI78FI4HDtf2eC7bBKEQtaGYI7gk2XptZ+FDS7IGgfPv6Cv6jwuSn0VS1doBblfBirrtsLybtWZsOHPA2IcveLwEVv3fEd0Je8HQRn/skJTwWq9lJvFSXCnbfZ88R6M4AHLCkpCNsm35tOvgsYvjwqCoEsupyzkBa21TyWoyK37ve/B+tfyGPkN0lA0NWfMudkAnBEaoV60iF6O7CiRsrYEdLBQhnwO+lWIiUjfxLWZYyiY3N7TM7HTAq24MGSd2mrQUZwcm9ahqatA3wleebJlZmFMsWJJUSQ4+l/v6c/FJixnT8Vb8AA5c6Nx+2O9ftdaoQWxiMNyc67B++NtvGSfbaxbqw2fQELgJjoG6G+1Q+aYQcXkaIRizQkBeVr2phrArLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 10:44:40AM +0100, Arnd Bergmann wrote:
> On Mon, Nov 23, 2026, at 10:37, Thomas Weiﬂschuh wrote:
> > There is nothing userspace can do with this value. In the kernel is
> > always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
> > userspace and also changes from time to time.
> >
> > Move the symbol to kernel-internal headers.
> >
> > Meant to be applied through the asm-generic or execve tree.
> > The default recipient list was huge. I trimmed it to only the
> > architecture lists.
> >
> > Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> 
> Hi Thomas,
> 
> I'm happy to take this through the asm-generic tree. I've already
> made sure it all applies and the patches look good to me. I'd
> wait a few more days for additional Ack or any other replies,
> let me know once you think I should apply this version.

This v3 is functionally identical to v1 and v2 which have been on the
list of a long time. I am not sure how much more feedback will come.
IMO it can already be applied to gain more exposure in -next.


Thomas

