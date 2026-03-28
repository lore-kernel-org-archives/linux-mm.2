Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD02910F3DE2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 14:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55C26B008C; Sat, 28 Mar 2026 10:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06C66B0095; Sat, 28 Mar 2026 10:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C9C6B0096; Sat, 28 Mar 2026 10:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A108B6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 10:09:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42BDEB704F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:09:11 +0000 (UTC)
X-FDA: 84595653702.21.E42E240
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7FE154000B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:09:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QxtFOkmy;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774706949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUPyR6FGKdaNFtDwXKMgSP6tvkRH5SqZ0KfVbyzx970=;
	b=qY9Y5RIPYxh5hUSZqTkhdpCharBLxcHU/N+h0esO8SRQqWfXGfKN+w+smztaIFOHopdGwG
	sQrLIs1VLr0DN9CdIQQJU/S3ewnKa7ioxeK62+GVpBBueHNDGxwamwVS9/Tezr+T7RgAED
	be3hVU39mW8Le4lJ+g/6wdU5XjnIBqE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QxtFOkmy;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774706949; a=rsa-sha256;
	cv=none;
	b=Jz53dnHcq1haXOsbtQT7MFJwYi3FE7hHCkLRU6rJj5sTJqTtL6KVaHO3GIK8VVSBlSJY9d
	QO6jzN5Oa/ZVedg8tzGFciAKK5dSOawCQh1Au/BVOOWBJoLpmVKdzaGZEkXTCS0aoof70W
	JaDveufLxh5WHDrhGSP+Y6dkie6S+5U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8131643F16;
	Sat, 28 Mar 2026 14:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C2FC4CEF7;
	Sat, 28 Mar 2026 14:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774706948;
	bh=RH/HWSCiN4u2TczIYbCULCcVSw97zuiwD8lfgVnonpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxtFOkmy5xzW92dCoMV1zhUG+Hn5lF3wg9JH90VQ58i5P64hkhu+NGVq6GSJ7Uavm
	 eD5cLmkbCh6ohHPIjHJxpOH20iwRPr5P5Ucv53R9loQ6hZyERumgk76R0+zoalg95P
	 wHZfyonQ3vMJ6xsw6RMs1As//X/oxfz8jzevb8D5lhkH74KAB1KIqd8w4UL02m4rMi
	 2+k+sAc8pdNw4uEdMYiKxb54wcsNKgfke4BoGxMfQwWD46JRjBsVxaLgYtthd9tlJV
	 eylRCwHXV5b4J5aZ2bpT0H5fWek3cdzJ19uNHwHIDWEKSVxcIQrGMmMaTl1tnHFlu3
	 ZoA0KSaq2Bi6A==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] mm/damon: add synchronous commit for commit_inputs
Date: Sat, 28 Mar 2026 07:09:06 -0700
Message-ID: <20260328140907.10389-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328104450.14719-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7FE154000B
X-Stat-Signature: 3krsebbhb6zf9bjxi4g5qmwm37fp16i4
X-Rspam-User: 
X-HE-Tag: 1774706949-721343
X-HE-Meta: U2FsdGVkX1/hZxRhUhDpsPeN89OU4bJ2EapNWJ1GnXNsgGsGx7j9JAhFPAbVfDheSa+fVMqbJ2EKD0jDrcpGjNlj6kzyNBcXkiWm/EwsP0AICEWoxCWe/bmWECoVfy04u/g/zQoyKjkDP/CzzI4H+EBRR7vsvIz1vdNslzuTWijI88V1moHbO45E7M6Htb5sMFG5ZQhx08ABFED0m4Kg48UhDYjF1joyXSWXQGMnwOZQr3k1IyCOIwzW4ug/9wsybNYqIcpCJxLFn37tur2KxRaOtUsthQgpE0GtclifeSXjXIxryYNx2tiqc9HdCD+U/iIIciinQWs29hxXpkXG7KVEKCuJ/4MIYpHjP4epuE3IghMUT8bsfRQ4Xj4bCsj8C9WbfXwYWHVDod/Kvj8+jdz5bxvrj/WD98M4xpyddAdX11COByZ45DOimYGSMD7XhVj6EMim2sl6yzuvnAye4OtseAH45/KSO3PvzdgaYb9QUaAAZhynZWlpsYRha+mLOxFGzezzXc2xpoNNnkSwvg5rWkSCEjRYaMyPo2nBK+/1JU/aziYOCYCFhLBxsVp7aiGL9AH/9SUT1JSiIi6S4zVFSyGN2r3NE4XVcQIKgsbyWn4Oc0QL4j/WEtKnNsfko8uHS7XGhc4p7HpGY+ewUqGnpIj3MLbwhfNE+IKnYqp8Z4TIIQyJ+QaleWSNY6VUtFOIFdSv9wAkcoyaLhlBWm/7DQKQ8zTjMoOcQKjCutBArVTIS8aB0IZ3WBlZhN+KNFydFGGdkckA0Qh/wwPtC2sfzODuCtvJlfH6VFtqT3tbmIHQgi2/gTp4wfL2QbxKv0B+d5rFP6i8wTLwjhXDoy2ZlVKiKxuML68szZBM6f4n+NVjk0IlwgIZDTJ+AkoNv3JlVpGIkLaEMMyUn6ryx0dXkWOjDRT2Kk0Cmpz5BFeyyGm744TuWlc6wWAoqQpsFyOtNt6uKzfP1LrlykF
 Fv342mPb
 yoEGH8qz85oOhtq1bn8RZO02ESKWWgeFMZ4M7cJkFZpTdnSQBNfFzWRQpA8pdZBEwuRKvQLaltgNUNAFzWDRYMn8NjM3iDv9nZIE9YzLBMMTPg6hAJtNbQPyZ3vb37IjPy6/c5gVaTDDLjRh9+M4ApnYNlfuVVdTk304zmdjhvLE59RKe4eqK6NU2JCWHb7TrmTTIlD9lTFZkiV8w4cperO+BQTHA4VcReIxegVK0dWG03GgeZXNfQz1S6pN8jrv7DydFOJ38RrtuHnyeyyzoaH6MD9/PEXJ8sg2MZTUYrry//Is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Mar 2026 18:44:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
[...]
> > > +static const struct kernel_param_ops commit_inputs_param_ops = {
> > 
> > The previous module_param(..., bool) macro used param_ops_bool, which
> > includes the KERNEL_PARAM_OPS_FL_NOARG flag. This allows parameters to be
> > provided as a standalone flag without an explicit value.
> > 
> > By omitting this flag here, does providing the parameter without an explicit
> > value now produce a parsing error?
> 
> To be honest, I was not aware of the implications of omitting the NOARG
> flag. It was not a deliberate choice on my part.
> 
> SeongJae, what are your thoughts on this? SHould we stick with the
> explicit 'commit_inputs=Y' requirement for the new synchronous behavior,
> or should we restore the NOARG compatibility?

Should be a no big deal.  But it would better to keep the compatibility unless
it makes things too difficult.  And it seems simple to do.  Could you please do
that?

> 
> > > +	.set = damon_lru_sort_commit_inputs_store,
> > > +	.get = param_get_bool,
> > > +};
> > 
> > The commit_inputs_store function parses the input into a local variable
> > commit_inputs_request but never writes to the global commit_inputs variable.
> > 
> > Because param_get_bool reads the unmodified global commit_inputs variable,
> > will sysfs reads of commit_inputs unconditionally return 'N'?
> 
> This is actually a design choice we discussed [2]. Since 'commit_inputs'
> is now a synchronous trigger (or a "button") rather than a persistent
> state, it doesn't necessarily need to store the 'Y' value.

I agree to all Liew's opinions.

> 
> > [ ... ]
> > 
> > (Note: The same regressions appear to exist in mm/damon/reclaim.c)
> 
> Thank you for your review. :>

Thank you for reviewing the review.

> 
> [1] https://lore.kernel.org/20260327233319.3528-1-sj@kernel.org (Lastest
> but may not the last fix)
> [2] https://lore.kernel.org/20260323150544.81042-1-sj@kernel.org


Thanks,
SJ

[...]

