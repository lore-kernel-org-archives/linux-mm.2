Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37419CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9421B8E0009; Fri,  7 Nov 2025 07:10:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB9B8E0002; Fri,  7 Nov 2025 07:10:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9AF8E0009; Fri,  7 Nov 2025 07:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65A558E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:10:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22F8813B0C9
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:10:35 +0000 (UTC)
X-FDA: 84083694030.25.5B1D2E4
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6850A1C000E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:10:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762517433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lRAFr9fkz0WKVmH6iX/BvG5G7xu+UB2ZaNj8waYa99s=;
	b=v6uyn8LPQ5aV4OeJHvszugjHWgQnsMtPiHqkBSR0YurD1oWlVdHfDZkNatQg5ZhpKVeywK
	qgd3T44kaY2kSnO9e8QdY7eKCXgu7n/s9JmQX1xCq+uTd1oA5THlNmQNemjj5mGwOvEYbh
	tcVeCBCb0QK1kTA8gS3z5yGdjzhxKfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762517433; a=rsa-sha256;
	cv=none;
	b=5AGVbBVL5J+MDQihnscrE8qe5j9e2k34uiLrh9uFI3JyEcHX1MPy6Uy8OFFdLyshOqSCcJ
	wa1JLKHrPfRYzFmYiHbcbFeHlrSncAn6RBAn4XY6RuI++grGc7pZoyymZi2jRHoKBUJ+FG
	PTiiiy/iTkbu1y49VwsfWgLuCZOlrpc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A1F41227AAE; Fri,  7 Nov 2025 13:10:27 +0100 (CET)
Date: Fri, 7 Nov 2025 13:10:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 7/9] blk-crypto: handle the fallback above the block
 layer
Message-ID: <20251107121027.GE30551@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-8-hch@lst.de> <20251107044213.GE47797@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107044213.GE47797@sol>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: yby47g49dx171y4kokr711u8hggd8xp6
X-Rspam-User: 
X-Rspamd-Queue-Id: 6850A1C000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1762517433-404858
X-HE-Meta: U2FsdGVkX199Ouz6q3+4xFsHg4AKqzkKykhJ6v++qY505k0LD+sZT2nIy7PIvRz6oii5lQ07uZg1SagrU00QXpQ3L+zo8Oxg7aMzx02Z1ePaK6WPt5cTHvMbU9v3g2Mm/U968H1TwVGANTflBTJYA2XG5m9wehiHQPzQwO2f+CWY73Mz7O3wFTdmdGMRBgLI5yVRIiRGWgmiughy2KBJ3tPqovEyHtqNfHNwMs+8rbuaqleRC/fXpNqpZvSsWcbeIrHXr5gk7oT9N89JHFHhN+0A+0vfwoVa/1iDXligLQxwtMKlvNp6BGvFxMkViae3nB3y1EzG8fbHMpToBsYIu2uvDO0bbIPH7jfK5KvAENziv4rANDQ04ll4Luokg/gsXJ5rnhbHQrkurch+wzg0av7khKjQe2INtUFDkSdTG0LXL8c/PHoo1eoh0Zk4HpNI7Qqmf+TpfamrIcR2Uoz5nF+xPH+1JYBH7YRvYy8JoN/T6Dx0J6JIdgQmfW5/VFD5E/Q4gN1k1e35V/KQ/2gKASpdKQrITwfTDQPTagwxORGwAvGlmRR9U4kITRm0D9xCEJ1dgMW9js3CKXFbeHMNROdYnnvJ8Po38/QzcKoSnd9fIHl69ZJNOXWUivHXftkRp3EZbHvZ6Jl27/q+7ZUNZQZW19zLj2ETk3zDP7CNP4mfZlx7CJuP3BLdEt8sapTRrnV251k8L5d9LKT23+ZeeVLriGzvj5ezlmWn5M/p9sx9dN9J06F7j1PgDZmQ69nPa9vM2VyCOR0Y5JVsfHBLZ/1AN+2XeygCU2/o9Fk/hYBk3blkxUms7gkCbqG6yVu/0muhRMYMApC33utJPwaHBB04BAjAkXXQxV+fdtRmfGwEEM+JvoJqXIbBGOpOVLLhNt+MGelkKAxYQ16yni3eS4Sdo7+cY61K5OIz8YvF9Kx6cvWbOrE3H2Ow5zG3KzVuIRftSFTUwmoKEFbvOzE
 LpAX/XiV
 +fGM3fXBKvM5GaL1EZcxqC/fbi50J5rYhiwFY+4v5MQH8YgTmamexSuBLx41OTQaDOAbxv4t04mfRPTQetbV0fXybDaTwSU4wjFzy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 08:42:13PM -0800, Eric Biggers wrote:
> So, the new model is that if you have a bio that might have a
> bio_crypt_ctx, you always have to use blk_crypto_submit_bio() instead of
> submit_bio()?

In general yes.

> 
> It looks like usually yes, but not always, because submit_bio() still
> works with hardware inline encryption.

It has to, as that is the interface into the block layer that is used
by blk_crypto_submit_bio.  But the intent is that all submissions go
through blk_crypto_submit_bio first.

> However, it also skips the
> bio_crypt_check_alignment() check that was done before; now it happens
> only in __blk_crypto_submit_bio().  So that creates an ambiguity about
> whether that usage is allowed (if, hypothetically, a caller doesn't need
> blk-crypto-fallback support).
> 
> Maybe the alignment check should be done both in submit_bio_noacct()
> after verifying blk_crypto_config_supported_natively(), and in
> __blk_crypto_submit_bio() after deciding to use the fallback?  Those
> cases are exclusive, so the check would still happen just once per bio.

We could do that.  Or I lift the checking into the core bio splitting
code at least for the hardware case to reduce the overhead.  I'll see
what works out better.

> Either way, the kerneldoc needs to be improved to accurately document
> what blk_crypto_submit_bio() does, when it should be called, and how it
> differs from submit_bio().  This also deserves a mention in the "API
> presented to users of the block layer" section of
> Documentation/block/inline-encryption.rst.

Ok.


