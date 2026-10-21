Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAAFB606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UywjvSFz
Received: by kanga.kvack.org (Postfix)
	id A69316B07E4; Wed, 21 Oct 2026 19:03:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A413B6B07E6; Wed, 21 Oct 2026 19:03:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AA06B07E7; Wed, 21 Oct 2026 19:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 733656B07E4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:03:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF49E8016C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:03:48 +0000 (UTC)
X-FDA: 85348162536.02.BEE2D8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0957C80002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:03:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UywjvSFz;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792623827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGy266VCPwYvIDUWYVr0t88Ce39cKFxVLG4EB/XzkPU=;
	b=I2vYnVSJWsYEPLrU0z7LtZl5vpn5oPzMRm2N5BuDQ+0pBL6VQ2ffuBNxs44+6Jwb0UF5D9
	BaIetbGBGks3B/5rTyggqX244CCHi23v6eL3k0QnbyA2AysAq8rogrfL5pcRpAw8n+vyOA
	I0MU9S3JRfQ/gCTFJ0Veeyj20LRrn6U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UywjvSFz;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792623827;
	b=BW+6MG5xXxt3IQPOz7Snw3MrTqQf+/TRdzgW4yYh4GFLMK2gU5Y7zfaeyNliV/MZy4Dy4m
	E83B8zFZmrDNtKJ4ZLeRQergqr6mWKwuemv/I8NMUXKe0Q950SZq7GGUdlq6/4m8HTwqbr
	ZFx3lnSh6nfcTfGqdapJsMgPzOJavjQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2741A60008;
	Wed, 21 Oct 2026 23:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7431F000C1;
	Wed, 21 Oct 2026 23:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792623825;
	bh=jGy266VCPwYvIDUWYVr0t88Ce39cKFxVLG4EB/XzkPU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UywjvSFzXCbCANEWfPAmPkcP0TIKKWxwAs9SSqMXsBJbf7hATd0cs1whhmRimISjo
	 k/Dh4wRJHnAildmzIeVAGYMokJ4yQTyxKMI+H8t0HSLALiFZNNzEG35jkRLbhmwZqe
	 eD5P6/UVrDWI5V0AqUJMoZIn7K/lSL19VgVpZvW8=
Date: Wed, 21 Oct 2026 16:03:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, Shuah Khan
 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, David
 Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] docs: core-api: include documentation from
 linux/uaccess.h
Message-Id: <20261021160345.f01d046a25999a2d6edfb65d@linux-foundation.org>
In-Reply-To: <878q3q4qby.fsf@trenco.lwn.net>
References: <878q3q4qby.fsf@trenco.lwn.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0957C80002
X-Stat-Signature: rixmwtjp5w3w8cqjf4bnycp7ta8kry3y
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792623826-276473
X-HE-Meta: U2FsdGVkX1/Hge+lFAhGgm5oOptHmLPCEmS6fGCxe/V2l95XJFE3Zc+y+Y8xYQGDRBrEZjwFjkp+L68A+57DYPB4Fp1sWMseCh0wBKCoNd+ixyX1uddN8Aaj/mfXCl/UP59MMo+gW8YPd6M/3a9ziHLCAfvYIOSJuf+0O34o/3IYayRF/LmusXWuT+byrVvnkziB+9mAURTRPgrwwNW5Qs9Cwbt8d/erjvfuKZ6ied3wK2LjDz02waVOKeQeYMxgcnlnzRdF7r6jvwjvzym+UhfEvJcdFsMz9ylUIi3vmV2WmTemBt0ErsRpTil/yrvoo+gDv8DdBkw2mSro7ifT23TZHyivVpOkA7prZ0z5WaJ7s+dWWQO0Lg8KAmtZVPTQoZaZ7S5Y+n2xslyprLVpWjnCGakshpzvTuIwWZD7eLx/vQzUq6HZQChbrXDOouDOT6XPc1kh7HT/HQCj6xrwMQv9mvmSTdibhgRzR2dFP71QDVqSM6GxZ6ohXeUvcQah94wbFIWtAy6643A1rrlq4UXdEoRXEqb80bNXCDwFsLKOCAFAA8FgFs2ibHA6breO/cQCL+NfuPP1Gcfo5I/cq9C4lgsyuWDsnep6Tumt5hcqFMEanxESF9QvfHflwmdXn3hAm+ISD9vh4fPsFzOj8y9ws1xlj9OJwh/zGzpnNEr2Ah9o+8ZTS+f62LMavd+mcZX2ZCaLH+8Rq9z4Q9An93vS3LcFsnaPs+e+UPDS3hR63SJ/+/UV4OVPoTCN7yQcTZBJ4yy1KiJjP3DS+bbEYvWDWMNXJ/hIYPwNXxGV7GzHmg5C++JsutVd+T1C4r8TQPH9HgaQGaajrpjyp23sz38A/cha0WAYP05mVOorGvbtdC59ha4oSIckNQDSd/E9X9WcvMi80+SpSDMgsS27l9Zqn6lpSoLPN+9zT5ng8bQhmHgBB8Wl2iWnUGgFf9fQ/ZazpcLekheFb1BKCow
 SH7i5sKT
 gcog3X4eq+fswBvx1jr8RMrLmP5Xsc+J7r8MafqU2OaEhxV1eUPIWMYbXlucUjTMP2JvHmq52nkpOPlQHAme+aqV6e6jz50OjdAse55LrGgeonIEX9po4fi1SUn507/KHRRS3XsU+ikO+fPmTASCYlG9jKXrmulZwICIMAsMAKj2OA7F0fdByP/x4uXoYpAdBCw78y+A90/+NGQOcRYVMt6vtO0mLjw6fo37lkS2zC1CuPdR8A7N1ZcXJb9Rh4hqWvtHcYdKrl+qddkDFwVl8MbTaU7brgpDr7OzbTeCO9H4oSmhRab7+ckzGMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 16:54:41 -0600 Jonathan Corbet <corbet@lwn.net> wrote:

> Documentation/core-api/mm-api.rst brings in documentation from the
> x86-specific version of uaccess.h, but many of the functions in common use
> are documentation in include/linux/uaccess.h instead.  Incorporate that
> documentation as well.

Thanks.

>  Documentation/core-api/mm-api.rst | 3 +++

It's confusing when a tree-owner sends a patch.  I never know "is this
for me, or does [s]he intend to apply it".  So please make this known!


