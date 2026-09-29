Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FFECA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 18:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536966B0088; Tue, 29 Sep 2026 14:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E70E6B008A; Tue, 29 Sep 2026 14:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FBBA6B008C; Tue, 29 Sep 2026 14:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2D26B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:49:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AF22A6E69
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:49:34 +0000 (UTC)
X-FDA: 85267688268.19.932F92E
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 857DE140002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:49:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=krisman.be header.s=MBO0001 header.b=Lf7mNpHr;
	dmarc=pass (policy=none) header.from=krisman.be;
	spf=pass (imf23.hostedemail.com: domain of gabriel@krisman.be designates 80.241.56.172 as permitted sender) smtp.mailfrom=gabriel@krisman.be
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790707773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxGsR26vdUt0dLRkmfJ6DMuoIFvZS7PYUYqwNoaoH98=;
	b=t6kS7xNYYcjUwAP29qt/N8AqcJqo1kfPb4JRPq0RP6zbYR1w/D71OFqaC6ibpUtKqwYcu2
	xAUiQ8e8Kj855tDAoKEu6MrsVm1B/CYb8EXooLLWaT7Q6a7Enj8CRsQmznaq9rEkX+0fnO
	bh5PCL2rFisuA8r7Adzuwab6x0/bBwg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=krisman.be header.s=MBO0001 header.b=Lf7mNpHr;
	dmarc=pass (policy=none) header.from=krisman.be;
	spf=pass (imf23.hostedemail.com: domain of gabriel@krisman.be designates 80.241.56.172 as permitted sender) smtp.mailfrom=gabriel@krisman.be
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790707773;
	b=uhpCsLXnIAcrCzl11U7kG/FtvKS8XwnEZR8yLwDM0uGyRH+b2Zb48tiuGohgFXfrrPu0Al
	r5CkNQOqXdfvtZpZE/ZaOveVgdCIHfCZSt+XFJdLnfUVgTl+En+YqLE3nbW73SMX1yT9Br
	x6ZzQ94rF4GI3CFCqKWT9QNh7264uUY=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4hvRzq2BXGzMlqp;
	Tue, 29 Sep 2026 20:49:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=krisman.be; s=MBO0001;
	t=1790707767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YxGsR26vdUt0dLRkmfJ6DMuoIFvZS7PYUYqwNoaoH98=;
	b=Lf7mNpHrmJCDzUQ1Pu05FeBsEVuBRTKcVPbPcpRAPXhM68QIJX1zUjasn6/lynR1as4TSc
	7NrBSum9bRai3btPiutAh6Ln9az/p+pmN+2o5OyNXBBF/MCYhlLnSsMqUM6OiQXvif3hzD
	zE7WljtLdQ5Rx2v2XCnrSnM2UJnYC6/+CrTW+TOL1Dvu9/KP4UMCHDOrIMJdS6XCVBaXpj
	kHxiBmTMOcso5Z4s3scPGsTF8FqAYqU8BHs0dm5m8Yki4sgmvOMbfqvUx2ChfbPYprMN8z
	wEcuz+OZgudiNmPoWy65BhaCicnFz2lhATrCJCaFvUYny/YBKq4vuXegXPbRdA==
From: Gabriel Krisman Bertazi <gabriel@krisman.be>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] shmem: fix unicode_map leak on remount with casefold=
In-Reply-To: <ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com>
References: <ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com>
Date: Tue, 29 Sep 2026 14:49:21 -0400
Message-ID: <87h5j7yjta.fsf@mailhost.krisman.be>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 9atqpskushf8jnfyt64aawmm1d1i45ic
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 857DE140002
X-HE-Tag: 1790707772-538774
X-HE-Meta: U2FsdGVkX193mIXsVRmtGEve0XP/OINpBYLqR5iVTaOkxJqcMhHbyIomQEbnaT4QyR8qfHoSOrjddfC76t6cHjJz8KqBpxTtReTs6QiPXtrn9c4w0aCZtWfLk5u4Q08EVAZLx7atfwZFplwnWMdDmLfMraf+fdO6yp7q67XllBKxSYer/ZtX31dmC1tENjyiPrLKhLBqv/XMufyFxk4rFUTpbhYTGQkcKQlJzMvEm6zq+BFn356+Y9CLMt/LrlDfo8NUJ2qWiPsv5pX7RNq6k3rPC5RMVodApvMfBwUWzFIZB2hqNJz3VPAb2D4BOR1utyG64VR/FdF3L86duiB/Meb41IFMwDin+7S0yUVNtyRnNkPqzXVML7J2LIlK1lAkM7fjQFE6tDjp5afD2CfC2sirdlFnH2yntJW+RtsqVdheNpw8wrbt8EeH5Mzpv6S2g3fkZy1i/TW/dUdKt3T5+MTN9MHNfJq8vhZvJ/KaakIqHKE9irr/36lodBdqwDUysqhzJ0BfcmhIfNy+4aLC1TQncadi8JNYZ0DjtEY9BB10DqIuMa5SDAae4+c6XoF1z2RWy4lBC6/FPVdRtqYBUigj1geTnVCRTFJjLt2u9jX6xt6AVG/E4fssY2UCHdVZ1Bacv0XYD2JecHaL2wDYhiGY4EKEom4FKjhhj9uzvRqhtzPsjuRnFQgh5S/KM8KEUX1p8Dz5TmPdkT92PuaEu6zKDUhFnIxL7TKAudh2Q1gPBVmVjLj5AYwRPR3X4AMYxJgSID+V78WyqNrGFEI8UQY7Xy/1WbTkFeo6+t858Dlr/GX3Gs5PY3ZoCb8xScyX+sw+ABXvtvnNAuhdUIjhbPwfvQGGbeJ4UQHwpVUUWoHtr6XsPMW7zs3VGTIhbrlTrfTz38lv1ZVLBOet0ZrU/Sqyt3CisaTDntwjL9l1cp3LkHVzNrHPgmIexUImDnDHxrqFJ0d7aum08eQqBsv
 nhCaHfWd
 MuzkLPZovEbbaVzi37lZP+xTb0oVpAtw/d3jy7Ibs46ClJ5I18e7EFBXYX4bFrTVB3yur/r0I6DsaBOqe9JfzFZCLulYYIAG+dYcpTyx6ZjRQGYWuy9E2l5xFVa2iG/mWGrizHq+i7RQA3l0xKlh2JPWIa0zaxV3Mi6ObFLjdWMGSBN3YuOz6rEL1IYspWwIWNJdpsQeAtbEBb91g4L5qQJ/Ae1fLiTxELBtWlGzmnIXHp/F4mtMdmdgtEn9ZT7XzfmP4aXFKbVEyip9swDrbdmeK+RR9E4TIAJA/CY7Qsc9VPqp58Tm0Fl5SHu7HEfvQCzG8mzqXX0ogjjkNh6myoR+BKxtimRtGs0/ful05jryxr4y2Eg0VyNp3PvmXcU0TS/WSdY2+IBf7E7aKv+mYkPtfi00+nRHC8jDYdNfTMwtdJHC4b014SmMPT5q2apAkdyj5N3+KhseIDu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mohammed EL Kadiri <med08elkadiri@gmail.com> writes:

> shmem_parse_opt_casefold() calls utf8_load(), which allocates a fresh
> struct unicode_map, and stores it in ctx->encoding.
>
> On mount, shmem_fill_super() takes ownership of it via sb->s_encoding,
> and shmem_put_super() frees it with utf8_unload().  On remount nothing
> takes ownership: shmem_reconfigure() never looks at ctx->encoding, and
> shmem_free_fc() only frees ctx itself.  The map is leaked.
>
> 50000 x "mount -o remount,casefold=utf8-12.1.0 /t" on a casefolded tmpfs
> grows kmalloc-32 from 660 to 50574 active objects, and nothing is
> reclaimed on umount.  A tmpfs mounted without casefold stays flat.  With
> this patch kmalloc-32 stays flat too.
>
> Clearing ctx->encoding after the transfer is what makes the unload in
> shmem_free_fc() safe: otherwise a failure later in mount would free the
> same map twice, once via put_super and once via fc->free.  This mirrors
> what shmem_reconfigure() already does with ctx->mpol.
>
> This is easy to hit once casefold= is reported in /proc/mounts, since
> mount(8) then passes it back on every remount of a casefolded tmpfs.
>
> Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>

Thanks,

I gave this a spin as well and it looks good.  Feel free to add:


Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Thanks,

-- 
Gabriel Krisman Bertazi

