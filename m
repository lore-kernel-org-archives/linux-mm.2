Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93470CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 14:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A502F6B008C; Fri, 15 May 2026 10:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A007B6B0092; Fri, 15 May 2026 10:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EFF86B0093; Fri, 15 May 2026 10:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 796506B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 10:24:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02BFC160175
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:24:38 +0000 (UTC)
X-FDA: 84769875078.10.425CD03
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf29.hostedemail.com (Postfix) with ESMTP id 35E6612000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:24:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=bJbAwpj0;
	spf=pass (imf29.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778855077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohNchLk5gAAU6hAND7s6bUUwHtS10xJjW5wCO8yXh0Q=;
	b=2qFrMVQcPX/ftS54c7N3RhcBp4x5CUqCjPjc1RZA+ghUp4o3ncS+cLhf2V9L5deicSDatn
	CQxq9luFO+TN/YyT7BTHA5wbXhyL3IO3OcAbXt4J9fDvuCF27TPMHcvvL+DaxzoACJnGeg
	o/yAqb+ghUL3pT0s5O4nXhDPrZeJhik=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=bJbAwpj0;
	spf=pass (imf29.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778855077; a=rsa-sha256;
	cv=none;
	b=6EIFmm65mrXjw8MIYmeJV3Pq4FVz3ZiK21bVoZ3+1S3mWlgWCSrLCSAlnWXIebrhAzt8bf
	BCnmhCwjyz2fHbwS9dDHd8HNCSI9tNOo3TBcnFBmhCupnVyChLBX360u6DQEAcEisLsgi/
	Ha7lbZGFHiK7fK+q1dEcPtcJV0p0b90=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 4A83D410B5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1778855075; bh=ohNchLk5gAAU6hAND7s6bUUwHtS10xJjW5wCO8yXh0Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bJbAwpj0ZYDzZ6JvkHJobOVegOR8y+qm5UhbcAjc71P6KtqspF3o3iI3TsipuGwPU
	 jhqmjbr1oJgaIBkttPXP01sjz/SvMPAOOcvpi7G+35iX3pNRN/fyt95F+CLgRmH1+F
	 3vnvcB16pBbUabzp4MGoSAjqh6NJPIl6H/xyQGp1I2q1jffZOyRQ1NF/TmY+eC+SCA
	 Vqow3sy+wj6jZQxxCboIq7uSf7MAWJvOoNgxemzL143IhUGT4ePXQIrUS45vnJisuv
	 YYxI0/x8OmtshLAoZrScFow/p/fhl99AUbcZ0Hz+08P5agF5BlU4/jMLDfJhx6c7w/
	 HHH+rK/Ggjc+A==
Received: from localhost (unknown [IPv6:2601:280:4600:27b:67c:16ff:fe81:5f9b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 4A83D410B5;
	Fri, 15 May 2026 14:24:35 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Costa Shulyupin <costa.shul@redhat.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Shuah Khan
 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Costa Shulyupin <costa.shul@redhat.com>
Subject: Re: [PATCH v1] docs: locking: Fix stale dquot.c path
In-Reply-To: <20260503160221.1594319-2-costa.shul@redhat.com>
References: <20260503160221.1594319-2-costa.shul@redhat.com>
Date: Fri, 15 May 2026 08:24:34 -0600
Message-ID: <87a4u0rbrx.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: s859tsfgq1doirdkcqwbziwkrfjzk9fn
X-Rspamd-Queue-Id: 35E6612000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778855076-591419
X-HE-Meta: U2FsdGVkX18YzGH+XtbDPm6gutzI0LZixFRmuX0XTaw81AT6LGVTtsJClk1TequNhuZ0UfAaH7fmDUnaVICrLeuPfJasg7NJXQK3SvewpAqZrUxLJ7f3vLzxBv+kpxasKmsjlZ4vcEbj2PosTmluXLc0aIrrqcO7NR5Ku99PMd7MvnHGYmbC1WS2n3zvRi2zfUQyZ0ttSy0/eW+tI11IKH+0OIuFDTATrwUb58S5fcsiKjQsG0btjYomjWfaWlzEmg0pPnIgD9g9zlYubkRWv+xPtK3uSL+HtJeuB3g5Hqbs0d/CEY4ZDMNXdIjgTXRBQBjXeSfesdZfcH7z4JgBolSM+QaeWYxFaig6IcPqGyWPYRVMQxafLjvUiw3mRybDjJjIqq8Tj+0hBihHjsHGSOvLjBRLMVxMFRBDzK47rdVt/lvgGHJdiifgm0PxRKM8N927hlpNDtrzsBU6e+g57YQcfcwzfBSv/GGgHqDRHzFbAJPxAUYwsQ2/CxtCWeyraAtnAALxlrDg7FIC1mCrOdl80Edh2yppRNiuUY6W/+i5nAXUbaOVEq7IkRCWPTtaq3OXMZaY8dklzQj0JM0+qfCLq3Z9G9SWtTT3VnyCV8AijxmwTGeDP/BcBXQ+nkUG22cHKNT1UAnqxJ5UDAuaCZLykWy1T53IARp379+J1Y2gd71HlBeqI9c0Kqy+8qXicHBxcehbgY6RUS5TjgKz62sOuCVV9nDyh9WO+R6zp/PL6sg34w0vXXuzXV38XMPfEWh/ILYFcSZl8BIO4Gh9OEngSmYfo40pTcBSvKmLlpaalvKwR1TjXnnmDBWq55BWEQLj18YrDCBdPZNoEoP2pQbM8gx/sAYp3vjY35hGUf0MhjlcbsRWJuaPRCYkqqezLy/z2Q4f+//rRIMlt6goPoKa+MngLh6JBVmRyMteNpVFPtASuSV7RQza7ZsXbXCrJH8MLDbMIlQAfxBcpjm
 sU+kAKzB
 ovpFcy6pT3RRqpMrXfnl++eqPqRpvoecr/0TVam+UUoImiu/DX2qcQSA5WY+qk+7U3V5CVWJ8kDhJQhrRQQPVH/nkeuNVYGstSd90JpVcWxDeEQxt+OoWdDZoQSd5Pf8K/eX7BI9/hdH5E7Vo3uqHEi6VWH/k7y8nLgYJhOExw/N8QPqvsJX57KcPvBkVh2KZbWhyGoKudsVB0cuTjI/PAIjNRv0YmXDasfyvU6bzd8VqnGwsZ/SOIpDsbNeTuV9bE1a+3vmdCD2eXWZcSmPMFTPEYQc9cQh4NxYoOfd6CrH5SAUOXAlDS8b0Fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Costa Shulyupin <costa.shul@redhat.com> writes:

> The quota code was moved from fs/dquot.c to fs/quota/dquot.c
> in commit 884d179dff3a ("quota: Move quota files into separate
> directory"). Update the reference.
>
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
> ---
>  Documentation/filesystems/locking.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 8421ea21bd35..277e49314d32 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -584,7 +584,7 @@ write_info:	yes		dqonoff_sem
>  FS recursion means calling ->quota_read() and ->quota_write() from superblock
>  operations.
>  
> -More details about quota locking can be found in fs/dquot.c.
> +More details about quota locking can be found in fs/quota/dquot.c.
>  
Applied, thanks.

jon

