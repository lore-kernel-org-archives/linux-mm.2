Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8C9C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A758B6B008A; Wed,  6 Aug 2025 06:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CAF6B00A0; Wed,  6 Aug 2025 06:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962D96B00A4; Wed,  6 Aug 2025 06:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 852936B008A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:21:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34775B89FD
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:21:25 +0000 (UTC)
X-FDA: 83745940530.01.03810FF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1F8D4100003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:21:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=N2US6QeO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GirxieAD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=N2US6QeO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GirxieAD;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754475683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOV0rA2Iv5+dUBBYGYW0OY3eKblC/GDoc2anJGe8tLw=;
	b=0xg+zxv4M+ZrnOBRQTcqIC/2cFAvFXzR6N9/h0PbKjZUpBDCN8Cnu/X/JdUSNpJyrmO+2E
	XXqtqqBCX2nE3zVvv78V4LLh2/UAjVz0r6B/Zy9GT/nK0K5ifvMo6xgzVLrw61DWzJyXzC
	cLbCzLSbHzHL1T/LOUHoE3vl7+Jguow=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=N2US6QeO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GirxieAD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=N2US6QeO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GirxieAD;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754475683; a=rsa-sha256;
	cv=none;
	b=T9XudVJRUi0ksxTbf8Wi1/T3N7QNgHljjTla2pvO2e+fxSdGJauAR6Pr0zZsKVMGIM8Mcw
	3uMGw3bNmG4M7A9cNU+TZrxFrD2nF8hKTeGPpyRnj95lhbWmgbR4nxpo20a89wiX1z9JIX
	aPmVLAxUk4oqmhl6AC447VywETsNIyU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 874121F394;
	Wed,  6 Aug 2025 10:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754475681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oOV0rA2Iv5+dUBBYGYW0OY3eKblC/GDoc2anJGe8tLw=;
	b=N2US6QeO11mUYBHcKpaZYAP2kOL7r0KRWEbJLOtBYmzEj4g+Q2usUS/hEhYHSgpgkRN7cb
	hPwoMlMozU+n45BLgHhJ/qrCkprJy6AwZP8WGCACCf5WeL4SvyppNQzWtw0EtuU2jZP9EL
	WgZeZiAsbzO/1RLMw97x5OqK5MKBkW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754475681;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oOV0rA2Iv5+dUBBYGYW0OY3eKblC/GDoc2anJGe8tLw=;
	b=GirxieAD9VuQYJH3xRJB7ZvzYKw7RGb8T2Y8hS1FIv5s5heOKB2U5INtRhuDDFny+QWIAl
	2ZLi7k1fxCO6IIBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754475681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oOV0rA2Iv5+dUBBYGYW0OY3eKblC/GDoc2anJGe8tLw=;
	b=N2US6QeO11mUYBHcKpaZYAP2kOL7r0KRWEbJLOtBYmzEj4g+Q2usUS/hEhYHSgpgkRN7cb
	hPwoMlMozU+n45BLgHhJ/qrCkprJy6AwZP8WGCACCf5WeL4SvyppNQzWtw0EtuU2jZP9EL
	WgZeZiAsbzO/1RLMw97x5OqK5MKBkW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754475681;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oOV0rA2Iv5+dUBBYGYW0OY3eKblC/GDoc2anJGe8tLw=;
	b=GirxieAD9VuQYJH3xRJB7ZvzYKw7RGb8T2Y8hS1FIv5s5heOKB2U5INtRhuDDFny+QWIAl
	2ZLi7k1fxCO6IIBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 10F2213AFB;
	Wed,  6 Aug 2025 10:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U3y/AKEsk2jIMAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 06 Aug 2025 10:21:21 +0000
Date: Wed, 6 Aug 2025 11:21:19 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] testing/radix-tree/maple: Hack around kfree_rcu not
 existing
Message-ID: <diytmqqhv2wd5guvbzuauenr4ucpttlqrcmffecqkdchjyi5bl@x57r6ypqysuw>
References: <20250718172138.103116-1-pfalcato@suse.de>
 <20250718172138.103116-2-pfalcato@suse.de>
 <32irwh2uqdg56jrx7mkbcfltu5t4im6l4j44mtq7ylnebtfpt4@te3sbbfuws5q>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32irwh2uqdg56jrx7mkbcfltu5t4im6l4j44mtq7ylnebtfpt4@te3sbbfuws5q>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F8D4100003
X-Rspamd-Server: rspam06
X-Stat-Signature: sijkxfg9x1uje74hsxja5n3j5jtudfyp
X-HE-Tag: 1754475682-982323
X-HE-Meta: U2FsdGVkX19uhT6A71lgZVT2I6uqZaeb5bCHZlfbnKTXWzFsXC7B71aZUNgOfkooP4K7M/tW69FXIVkBIps8Gpn6KngR4j9n6xqBweqO7z6ZVmAgPFO54eIjkJNOLatbZSt/Q4S8jrTYg1vmkLsVqbi7Wa1Y+n8JHDdU6QajZKjcXzChTEFqZlnVIyJgh9vBEfLqOAYFAd9PO/kMgQI7IMJZZ9/ZSOAv6EGUBn0eEaflShIn328EW/gcOLob27otkjKe6ILRLCSnTdBOJvnp6LIb/j33jV+G4T9D1/t3Fa8WwBWGxAvNq/On6xSGbyuO89jNA3xNthUlHWJ8VZLY85yRFrLTbM01Zmvt9+xzfVC8ZbOc0jFZcYUZjWq7Vcbf8fo7Coqa8BLqlCsjA4PXnvXq/k/4PKV9u12/VWcOwW0/gxDYBRKWijKD6BAwq65nuTXrTuysuTy5f2zF9mibhvSY9iOWsXn6bK+Ds+aCaRkSk8aPjPld+B/ns/C+D+SbGfVbXQwEHtAii0ncsyEYIAfUbQ3d+d8WFKdN71MO738JW+/aUm1HfHJ/B9YcA0dmV6Havie3Dip9lCYDQCmslTz6DH7MDSZgZMhEGLyrsTfzEnq4lRdFVj/gd/rVzCGobgkEuEWM+7UWonVKAHGj63UIUtybQqI9rc589juLtMQoGmym56tzL6ub5MiCOZjfYTwJ4a/YZX8Z1XhQzAt1S8hwUma2kvLjFCeiiS63mxLXUZ4xJVD+gBrfYvIHSFYFfc+jF5FA4jtluOK9clJRir54wMuX0O33BlGzyVCz2tt5WDc65+yCDbziZDD7WzcL3Zve9U718IEBWH4woptfAruWEncX4SMrJ3HGuX1ObMVHW3tfEKLL+NgxQSyV9c+esLKS+W6QfSesym/p1RFogNVAWmP3FWiwh8DslHFPiyfc9QUH+cYaK30VYojN2Pg7ZLIc/BkIJiR/dm1P5tA
 QhvV/d8h
 v8zaPSjKk48vRLQTaM3/yxceEHYs+gt/gGO01LyUHxz+uh3xigaXidBailKSD/wUyyw/NsFQhuC2DQrnalaxkzuQaLlFrF27pMplGOB9hshluMIPtEbD/ky4xe+pEHC5cZnqZNL+jrxhkaX2G5x2w4lJG3w2AtNolUae0sjDWrgbqpyN5rLrOfDfdcBrdbjXqJWTb5sztSbYGjmL+B42h/bvQo3ZlKq6OkcrO3xXkGDQt/Tlt/yUXBCLMJ89opCxvwzytFM32E1UDMxwtEFM1utxO/UuINXByJPHBwJBm2ht1ZSQimBf3Y1Cvanq4ljLakUg9pVtJD+iTHiWbpTc+Hi9ihn9sE0Px1bDZMiif5gYLqLZ4zqB1wFc7ooAhArQFJEGWyXTrarTvx1k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 09:26:47PM -0400, Liam R. Howlett wrote:
> * Pedro Falcato <pfalcato@suse.de> [250718 13:21]:
> > liburcu doesn't have kfree_rcu (or anything similar). Despite that, we
> > can hack around it in a trivial fashion, by adding a wrapper.
> > 
> > This wrapper only works for maple_nodes, and not anything else (due to
> > us not being able to know rcu_head offsets in any way), and thus we take
> > advantage of the type checking to avoid future silent breakage.
> > 
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> Thanks, but shouldn't this be patch 1 so that the testing continues to
> work?

Yeah, that makes sense, I'll re-order these two on a possible v2.

-- 
Pedro

