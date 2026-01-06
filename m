Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE841C47BC6
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 08:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E416B0005; Tue,  6 Jan 2026 03:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B936B008A; Tue,  6 Jan 2026 03:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FDAA6B0095; Tue,  6 Jan 2026 03:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFFB96B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:00:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7E24C1CF7
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:00:26 +0000 (UTC)
X-FDA: 84300791652.20.059BCA4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 18D17180004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:00:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v4LTjERF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FID3a0K+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v4LTjERF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FID3a0K+;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767686424; a=rsa-sha256;
	cv=none;
	b=BzWaPpoW7dGNTJ46MqcbQJa1maKv+me2ETo60ZrwKc/8fsUx1axd4N7cPh28sfvWgM1Ltp
	P0aGhB4A47gu6/Igmgk4jzn6Kfa4j8gLkgEj/xX37fgw4EZEE4xsCr79ILXFIv/NO+uLw3
	+gWYLR6LJVPstfZAHV7Fb0t/yGB4EWw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v4LTjERF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FID3a0K+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v4LTjERF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FID3a0K+;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767686424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGxwsiRX2plEgoq7t220FzgRSWwaG4m8Yt7YlEvufl0=;
	b=AKbO0AiVCqURyljmZzUmJ7Qq6lP4DZ+Lfj5zl1zjrM7iVFi7+0nd3xAwaaKIOOJ0M6VzPo
	ZRxdM5WuTHpk++G3DCYsB6BwRLupr1/eqwxCFv/qYdpqb2Y2V9vXLMsI77Wi6jrwXKEz8S
	BgAECURz7bFx9i+5EzkM7+QTi6QTYUA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1EB175BCC4;
	Tue,  6 Jan 2026 08:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767686422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xGxwsiRX2plEgoq7t220FzgRSWwaG4m8Yt7YlEvufl0=;
	b=v4LTjERFhtNv7w63efgY1S/1RrFM9OxOeWIuOi4t9LRzzoAvyuzbVx/TLwZK302ta0WhA5
	Rh1BR3PXpvrKnN4dox63NNXlzzI3Nd5PjSkUYQaI6n95Qeen79IV/FPPOOfjmbicjMlGDw
	YHdqN5Deh8Enh+P72jujOKCyW2GPi1c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767686422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xGxwsiRX2plEgoq7t220FzgRSWwaG4m8Yt7YlEvufl0=;
	b=FID3a0K+DHL41UG36n8dQR1XzuSaMILak3XTrlYuaRc1ERGd5PHZQo6lnq0R948UMPQ1FG
	E474O9wvIRTPvHCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767686422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xGxwsiRX2plEgoq7t220FzgRSWwaG4m8Yt7YlEvufl0=;
	b=v4LTjERFhtNv7w63efgY1S/1RrFM9OxOeWIuOi4t9LRzzoAvyuzbVx/TLwZK302ta0WhA5
	Rh1BR3PXpvrKnN4dox63NNXlzzI3Nd5PjSkUYQaI6n95Qeen79IV/FPPOOfjmbicjMlGDw
	YHdqN5Deh8Enh+P72jujOKCyW2GPi1c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767686422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xGxwsiRX2plEgoq7t220FzgRSWwaG4m8Yt7YlEvufl0=;
	b=FID3a0K+DHL41UG36n8dQR1XzuSaMILak3XTrlYuaRc1ERGd5PHZQo6lnq0R948UMPQ1FG
	E474O9wvIRTPvHCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 133D03EA63;
	Tue,  6 Jan 2026 08:00:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TKJgBBbBXGm6GwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 06 Jan 2026 08:00:22 +0000
Message-ID: <e1f271a2-6215-4d16-b17b-45ff8548f8b3@suse.cz>
Date: Tue, 6 Jan 2026 09:00:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempool.c: set @elems slots to NULL once freed
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: klourencodev@gmail.com, linux-mm@kvack.org, akpm@linux-foundation.org
References: <20251223231054.16061-1-klourencodev@gmail.com>
 <07c4f991-ae41-456d-8e7f-287bf8676c9e@suse.cz>
 <aVyqPfnVtdAM4HYY@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aVyqPfnVtdAM4HYY@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 18D17180004
X-Stat-Signature: fhrfcwuit9ce8qignyf7z66jc55p1axz
X-Rspam-User: 
X-HE-Tag: 1767686423-1801
X-HE-Meta: U2FsdGVkX1/OS7AaBlmvLw8ntpDKkyNJBItrtXMiQVW3Wi7NHe3/VwPloTfoYlpY1GGjW3lLJdX9ukHzwLG7NtOW3U9gnajikY2/9z8qFkj81fGHNvOqQjkaU4GgY5qse34NlZyqupP0odjftbE1IrR+KT/7CayVDT4BrSYbfttg2ecYRkbOo0/BC4CTk3HwjvF9jzAAgY50yBeUJ6uXK7/3/ZfpV4uMbTfoFQY24wKH0vc9ASNVUL4gWlgNeoEfC63RYlr3F3AYGEKAHtGtu5IaJd/0Y+pIlvTEKwhwnvZsk7LJPDr7r2rddRZ6kiACZ9nT6bcI692FrEIOwbxE1GMz6oY9wHPKx9kD2zsvko+Ws2+DtMoGJeLFBJrkOBWf6cMbVwFrqvZOkODRyS7Al2kN0LZhczOpN+d298YyAbj0C/VJnLRbJi4I1aE5rsih+8Zxwsk2xFnOJGsNWzrhabeB5HQ3dtOZQRkONlX8H6TBH1nkDI+WY6yOn/nuOS8NqRtlOLHnccsIZbGNxAheBJV8tK0wd8blgg+teMNGjTpISOBQZQeUCG1/WAMjk/uw1Ge28k1W5+ixCKtKqS9gxShjm6vUtgd+JEUoa7Wg1wwQEBo3E/bFQPvEd8A16+cjPluT6tGMJj6ZC7DvLD6cPewXfYCSWjXErWGfLBx4kxgok6GxN28mFaQbZZggMbKEx9lyYrJHE26xQCzLjol9z8/DWgFJ0Rj664DSaZRiF5gkJwfZRaiA4G0NHsBx7AcdvXPRaWVmiciXwnOjmH51uEqVUa9iHSpRCLCjc0W+vlXDStd7iGVIHUC64RCMj2nqK1ktGwYpuQIdysoGVCXyF3zr3panib8iu311yEvUucxGDQ/WuJbdS1ag+FVZIpL9Jmu6koWdPaadItStBMrD0VM1vkeHXYRjwOd8rFTEchbpa1ey6C+J2I6fhklSPbMf+NMNBOrKFQX0fsiIKQ0
 5mH9A4ow
 Kp+WMwkhxsyps47PvnvtjygmpEMpF8cJ3dic14gB3pslIgdEd2coZJn15JIdadpYTva43QYYsRTOAH8bpKZN76mFSJXlvIzFpoScxct6Qb8Sz041QfPIUsAZ+uSEMac3EZ+SXOw9T9y/vVZ4XiP3XPlNRwP28aSrDpRtlJkixBAbxN9i2dnHC7B/jpun9A6aNd42zsYDecgy8zjZQCG07MWCad+YCu8Gyl79lbMZg0CGDZSIfjrViGvqOlqVaMpUgW/1QZeQ7Jn5ES5fQKwvUYHFgP5hnYJR0SPlp4L/K+nN5wfXjjnvoFmkahw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 07:22, Christoph Hellwig wrote:
> On Mon, Jan 05, 2026 at 05:46:47PM +0100, Vlastimil Babka wrote:
>> On 12/24/25 00:10, klourencodev@gmail.com wrote:
>> > From: Kevin Lourenco <klourencodev@gmail.com>
>> > 
>> > This is documented in the function comment as "...and sets their
>> > slots in @elems to NULL.", but it was not followed.
>> > 
>> > We need to follow the NULL assignment, because elements newly returned
>> > to the pool must not be touched under any circumstances by the user.
>> 
>> Well alternatively we could update the comment if no user needs to rely on
>> this. Since it was modeled after __alloc_pages_bulk()/release_pages() and
>> release_pages() doesn't do this, we could also avoid it for perf reasons.
>> Christoph, what do you think?
> 
> Not sure. I hate the magic null skipping behavior in
> __alloc_pages_bulk()/release_pages(), but given that we try to stay
> compatible it might be best to do this.

Well but release_pages() is null skipping but not NULL creating?

