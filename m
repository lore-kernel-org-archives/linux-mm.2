Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64466606D806
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gwOrADE0;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Hqy7mCyS;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=2QGf1cFd;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=2i2QQIsM
Received: by kanga.kvack.org (Postfix)
	id 837AB6B05B0; Thu,  5 Nov 2026 07:19:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8446B05B7; Thu,  5 Nov 2026 07:19:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7956B05C2; Thu,  5 Nov 2026 07:19:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 425956B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:19:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5386AA09F0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:19:19 +0000 (UTC)
X-FDA: 85400970438.13.92BD7A2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 26A25120008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:19:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gwOrADE0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Hqy7mCyS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2QGf1cFd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2i2QQIsM;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793881157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqpWQ/H56gC40ALaqhyZMF3XlYC2+ROVooz7JGVgA9M=;
	b=aDh5EjC/4YKN2bDK2d9FZTwO/rcNyNii70CehXN1IT2mODIkirRgCKTryTj2QXDPZ65XoX
	5dqRHR3UlajJIk5kJ+DOcSEwSQRujueMBwJKDySfa8yUO2q330ajJLRIA+xLaAR4yRQELZ
	o0TuGyjALP7IiIbG3Qpp7R4WwVqSwHE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gwOrADE0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Hqy7mCyS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2QGf1cFd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2i2QQIsM;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793881157;
	b=pLLYvqgIC+Av9p6c/Ncn8l2vaI/ksWUvYgltbq2UCJgKVhPV/uzuNUvh/xkD6gxpSB/I9n
	fXviMHR9pxDp9U3yQFT/L/g/IcL9snFzn7XZqNYrIDO2dcZpSdXrl6W6Iq7wugYoEgZV+I
	vvtQJ/W7FGnB1mE5JfvY+/ZSj3y9L2k=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E01831F458;
	Thu,  5 Nov 2026 12:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793881156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VqpWQ/H56gC40ALaqhyZMF3XlYC2+ROVooz7JGVgA9M=;
	b=gwOrADE0Qod4PVwDfNsd6RKN3cB+sGE4cNvv4wbkyzZCV0V1foN+caBz5Hskcp4NF8tF26
	w1nbcHD5aFeef44QG95h9KpqD4JsxU4qHmCJqtxAwp9DS3oQ3LnpbJhU1tBBz2DqOsd9ZF
	uVZLQax3NHgAnPgrND7VAX4D1zeCtNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793881156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VqpWQ/H56gC40ALaqhyZMF3XlYC2+ROVooz7JGVgA9M=;
	b=Hqy7mCySg0o+D767jvmxe6zGPvs4rTxKWmK+ZRuz1ctNWbsc51XXPoLH1HMo8nDf5H7/20
	Pz0DjigL/jYbgZBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793881155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VqpWQ/H56gC40ALaqhyZMF3XlYC2+ROVooz7JGVgA9M=;
	b=2QGf1cFd8g+b2CTSCS0uxz7GbK5LPqBWmMPKf4TvU5AQH5Dg1HRUE9HTNITO5QmYusd8Gv
	YsOgOMJWElI+5g4u6nec3o3Xm7Mzt5Wj6kZrNRmsVHewMKcUp+ANSWJTPATn3eydPsmqzk
	AMabRSzYjzezo1rQKBR1OSv5TTNBcug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793881155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VqpWQ/H56gC40ALaqhyZMF3XlYC2+ROVooz7JGVgA9M=;
	b=2i2QQIsMAWELvaPa0IejbpFt4bdvx6dVBY2kuOnzugjipXn4e7MRfHQXH1YwSMYg5HDZIq
	/r8/1foBG6ruJUBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19864133F6;
	Thu,  5 Nov 2026 12:19:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3z2mNUJ07GqdHgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 05 Nov 2026 12:19:15 +0000
Date: Thu, 5 Nov 2026 12:19:13 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Krystian Kaniewski <krystianmkaniewski@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
Message-ID: <auxvLCiljPhy0n_q@pedro-suse.tail5790ac.ts.net>
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
 <aunPI5eOUOAEUa8d@pedro-suse.tail5790ac.ts.net>
 <20261104-jf-filemap-v2-pedro-reply-r2-74c87c6fbcf@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-jf-filemap-v2-pedro-reply-r2-74c87c6fbcf@linux.dev>
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Level: 
X-Stat-Signature: 3chhdd6z7h5ebmfo9b8tq9zucisch3fe
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 26A25120008
X-HE-Tag: 1793881157-642978
X-HE-Meta: U2FsdGVkX19bjOn1ikkwNYA4JZzjU1MLx6P1bSl9itSbRhSZsoPm6Dk2Hy4e11BR8qFPUfUU/m9SFRMPad8teSLIJ8cJyzQiemyl8fY55sRFO5S/nkFI8oVGLln9XFSZzOS/HGmnOvFAsRdKdYVKALo5ndcQC7ZmtWIUCh3XTXnkTS7EgSEga/80RHoce/YlZbFCTLkPr9iFgtu1hf/jMuua3RD/4cb6zpxO6mr0lJAwtnesGQ3eTlhba+DXaeF9vs7TVqA+8fs4pWQYdD6KTlnFTAQE1Ep6md2xXH1T+THRID6df/mALSQi2wH4/0H8RsWvzo+6P9KO+xQ3QFYEEgHSi6bofubWrI/1LKlOHLG2iRTkYo3QHx0DbGlgUmGs7Q9t2lhZbZSUDGssVKjrnr4FqRssLcqfUeyCBDSuBEg81s/5zvwxHKNRRqHJPx9YylINGjPunfLq/vYCIrVOZerMIqRdTKnBzXm6NzuXfOFm0JCsXpuIDzrabHxadOpHT/RYiz9hQb7VP/EKpA//uq+P7gZAJTFuHEjx2RejneCVWftTk/WUfRZyIsGqEZH1XTiaAo7ITx5DciohK1oK3MHFzvhklkgJgLNxsCewbNwe44UGbAfuwbEoreMKnsRp9LjdenRj756pkssE7fjyFpSc/F/Nva4POlAf99XodvR2ABWX0Iv0hnbHyq824H+3UwlGspAwzxM5WtwPRR9ZRe0ERsKKEWOKUHFtWbQUs748IzY42owHF/UiyxcyAmkWDj+XbVtRFxcfalRav9M2cHlDYRFfYQhS2zk10QChi1vuQ5hJtJcF9wGrLOm7WMMLoyJTFgsInHRglF2RHJwAq+bR5U1rHI7r+vEiLXncrKSkleGFqjnocEgZtjHGYmMGAFrggPLXWX1EQLvMK+J1BWnkgIX/xqSbMR7RNGNJNfifuXA71txwBNQi54ytM9fA0qXkujLc8Bk91Ab1wLQ
 skKVf588
 MsfL+kg/hCh3ocPX24HcOhm32jp0HoMPnsQOScPJCFYPxW1AcTpCcIG36wIdHEwfomiHGKvMOCubtEKEQMUi6qoHmetVLffsh5UFCHhaBqPrR164o8J1R9SAyR95F8gpFtvCose7mlDZjHmLPGehEQCHJR/nnuVtIASYqz/l+ZBdxsQEH/XlXAXwz7Nuw4pyKPrg81oIUjOcf2MsuRpM2tSjNR37aLYOFuZ6ulYSVyZ0TxLgdBi8wiR2koZaaMTf3G6D8GKHyMds/HWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 11:12:41PM +0000, Jose Fernandez (Anthropic) wrote:
> On Tue, Nov 03, 2026 at 12:12:58PM +0000, Pedro Falcato wrote:
> > I'm not sure I understand. xas_find() was fixed. Is there any other case where
> > this loop can step backwards?
> >
> > If not, I don't think this should be Cc: stable, and should probably be a WARN_ON().
> > As it's a hardening patch and not an actual bugfix.
> 
> Yes, there is at least one more case. It triggers when a read fault
> starts a lookup inside a large folio while a hole punch removes that
> folio and a write puts part of it back. A stress test I wrote for the

Thank you. So, if I'm not mistaken, this is the race:
First, you map/see this:
	[folio pgoff 4, length 4]
Then, at some point in time, someone punches the hole:
	[no folios here]
Then, at some point in time, someone faults another folio in the range:
	[folio pgoff 0, length 8]
so you step backwards. Is this correct? Or am I misunderstanding this?

If so, how can this happen while we hold the PTE lock? That itself should
block truncation.

Can you share the reproducer?

-- 
Pedro

