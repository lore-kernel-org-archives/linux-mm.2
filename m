Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E06B4109B46F
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 13:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581EB6B0096; Tue, 31 Mar 2026 09:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559EE6B0098; Tue, 31 Mar 2026 09:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4700E6B0099; Tue, 31 Mar 2026 09:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 379EE6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:54:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4D8814021B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:54:13 +0000 (UTC)
X-FDA: 84606502386.29.B368127
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7FE0A180004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:54:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=noo9CrCn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ie2Uqd8Q;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=noo9CrCn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ie2Uqd8Q;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774965251; a=rsa-sha256;
	cv=none;
	b=bt89mRj8EZjmVXmgiPDSgeUaZwo3T4QNIVpd6nxo9Nn0aCjVVRAH9rFyOI2PTwbwXckZOG
	k/5RwTsnz96S2hwVu4WOJHa0E9WIfwnJhgLQeltvfcEWLjoKhfZAMizWSK6CNn1a+kklCd
	jh6qXP+LZWy0pA1rig5pvtSZPk/7d38=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774965251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnyeDesH8XvQgUYEq2ZvWJlz/7Jiqomx9yyWl1kQg8U=;
	b=xN6Q5w7eQuRQe6qWpj3/ufUkoJcO+agR/8tWOAGu5S2KfRWLM5LAoQNRwF0928Ki3EeDeq
	+X2qmy5LoY166lMrErCBmqlvEmuxWByjnq7KKotPfNCMvm98znkvKZbZV/QWpobo+eWwwC
	rIOJubaYjtnyVJMymcSoJYOzL6+et8U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=noo9CrCn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ie2Uqd8Q;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=noo9CrCn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ie2Uqd8Q;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D85C54D202;
	Tue, 31 Mar 2026 13:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774965249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WnyeDesH8XvQgUYEq2ZvWJlz/7Jiqomx9yyWl1kQg8U=;
	b=noo9CrCnwjNHm8W6GXgFAbboHKwnkF7ikohX3BMdtE2IDAdDjvmoq4s4o0hRGWtQEnBziS
	4qlB7kS4d3vnA8qwRDScsnpqp3cBco8EbaXIwQlmeBnjYji6UgcD6e1MA908uHUD9fQQDx
	Z7371nDS7mfNv6tL/sd7a2i8Z5/E+60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774965249;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WnyeDesH8XvQgUYEq2ZvWJlz/7Jiqomx9yyWl1kQg8U=;
	b=Ie2Uqd8QVUHXSaiU6zaiR67RcmB/loT1WCQq/OKItmWwlQtqM2wKVgcifHSp4YNvox+fX0
	DZ2JYdKzTLG77TAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774965249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WnyeDesH8XvQgUYEq2ZvWJlz/7Jiqomx9yyWl1kQg8U=;
	b=noo9CrCnwjNHm8W6GXgFAbboHKwnkF7ikohX3BMdtE2IDAdDjvmoq4s4o0hRGWtQEnBziS
	4qlB7kS4d3vnA8qwRDScsnpqp3cBco8EbaXIwQlmeBnjYji6UgcD6e1MA908uHUD9fQQDx
	Z7371nDS7mfNv6tL/sd7a2i8Z5/E+60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774965249;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WnyeDesH8XvQgUYEq2ZvWJlz/7Jiqomx9yyWl1kQg8U=;
	b=Ie2Uqd8QVUHXSaiU6zaiR67RcmB/loT1WCQq/OKItmWwlQtqM2wKVgcifHSp4YNvox+fX0
	DZ2JYdKzTLG77TAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F9864A0A2;
	Tue, 31 Mar 2026 13:54:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dv9YBAHSy2nucwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 31 Mar 2026 13:54:09 +0000
Date: Tue, 31 Mar 2026 14:54:07 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/selftests: add merge test for partial
 msealed range
Message-ID: <4ouz3wqd7bsguto66h5g3cmgbl5fjiochex6qb7of4dsrwucm7@f3vrqjbl2tkj>
References: <20260331073627.50010-1-ljs@kernel.org>
 <ne3bppkwlk2srskam72k56jq5q63dhnvk67vzztciw2uxxcyr6@gki5bfznhqxa>
 <1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7FE0A180004
X-Stat-Signature: qxcgn6et7cajoo34b8md148d6bo3eons
X-HE-Tag: 1774965251-808580
X-HE-Meta: U2FsdGVkX1/i/kCGeDSslgJoKlspMjpZc5/nvQxPK58/JP6BdtW9BssMIQ2gnq9VVyXPndSUdD78AdCeqz9We1zIB5V8s15VCQ1aljLiMOSLHo+ca/4ZSx2noIWrqfOiAQK1pKdLdXY4klU0LQADD2OD7aH7AEZrQIAHaWiQiyqbHv43PSaPWNxbbU3AY3E2YbP9n41QkaQPcNnDtxc5YKdiw33+yZhR0blqvemny3pcCe4ONR0qg50wVwibOX8nCUUHY4HiuQEvS+uguKjEzcprDisg5YTKPmejWnRXxvni3Dapa5EOE8JrpOBAPg7faGpAHsBuspkIfDtz+RlTNIOffDM4sFUW/2xELOTnojqgcWhgDFuRiw5wkqliDFKUgNleQPMjT0e8C9K3KYcyaoApIODWcAX8MPr3GP6Zi5xnPep0pER7ssk0DoHpVoOPOpdZI2X1G1k9aQvBEbRsgdAb/TQowMNAZX+7aNp6k9lsq6F8yZ5dLWVavVouxXAZQ1OxY0o9kE52p6NxHmx68UPCw+/kSKTmVs7KfyIij8CcCSK25T7XFNwtIiNAeocipLffu8sAcs/ZtKr7E0Rkfp73gfaj1Dh+YaY6jm2w6twmEgkWtwePPn4uPLKTEW5Y7sJd40Bq7qMiLusAOhZ1u/C+ulTRdiumRE3muIuw7IUoFGSsJJqe6n23zzrYaLLI6rqt0G1Ohq9tjoPBXROJ3izLmnNYoxq9uld268M+2+mU1brFLrGFJtdqtRm9yvLsQA7hT/772s5z9m9C7YX19CM00sB8Gk1OTEF9ZY2vvCgrXRd+w97F7AJqlMnb/pcudlLP7wemc1waKlEpWH89f9x7i+kCXVdM+Qwh9rgQGP0gZ628wv4d/XD9nkPC8og/P7R2uPOpEMD6y2ZbTyL5NCITGJUHvAlJCjkU7/XA1xgdYPA0q6F6y++eZWYGBUFseBn7MjGi5/iIBH10UFz
 ItBnVjuF
 6G+Z8I+IpkEeJ8pO82izx4jOE9nN9bVb6aOtFVDDxBI/VRAI59gBAL+GV0o2VM3nIwhPrEhEHjLd5dMEugpALP2afFsB36EMNX92cN+RWxGky5/BjXcRYqb5WxnmEeLBMejE52Sd0EjSW2wwqRSf5GwHYpQM3+LO2NuA2HJM3NZou0wnbZAq6M1AVhqDtwJ8taMxyU4AN0BqPFKypUE9nQu6o2djzlt4Os9w1/OOv64IWsNRSXnWT7M6n+N4uUKJt9Hk9WvgJkDtPPx82FCSPUZQZVNKYpops1Hj6OH0XM7I87FI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 11:08:03AM +0100, Lorenzo Stoakes (Oracle) wrote:
> Then again, and contradicting myself elsewhere on fix-patches blah blah blah,
> since this is just test code, I checked the below and it works the same and
> triggers the regression.

Thanks for taking a look :)

> 
> So maybe we can just apply that?

If you also like it, SGTM. I was going to say you didn't need to (because
it's test code, etc) but you were faster than me anyway :D

-- 
Pedro

