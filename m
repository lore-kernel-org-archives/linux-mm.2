Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39090F4384C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7935C6B0005; Wed, 15 Apr 2026 11:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6586B0088; Wed, 15 Apr 2026 11:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611A76B0089; Wed, 15 Apr 2026 11:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEC76B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:42:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED5011A04E2
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:42:03 +0000 (UTC)
X-FDA: 84661206126.05.63A5767
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 39B8E4000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:42:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kmxzwh5k;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776267722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/n2RlBCr8TBqiK8VMG4cuJ2ucsZfCjcOUaPCSY07ob8=;
	b=PrGhX80Qkg4xnyxUFcE3zILXB8ueOYL8X4J9nAA0g1bRRi1graFFsXeW6MwuYKz1iq9kiK
	8+MqqmVMVZd9xXHSFP1Al7K/JeBU6cRZhwShsTEGVBZ3jLWayeTeq6YIHwPV4ki+0wgPUf
	GszM3baNX/VS0AWTU2PknP6s7shx+Ag=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kmxzwh5k;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776267722; a=rsa-sha256;
	cv=none;
	b=GP4Xozywvw0gAJozZnjkASDaCAw2vMfqSnRW6t7FLQx4syLXPnQDFpz3Q0e58qrF0IGqsU
	kH+7CSMF6mmr+NsjfS3Cn+Rz6DECNw8wZiCvbGnAZ935Gy/cuCfGSHHmGYGVCuthdl/70Z
	zzg9PKpu5R2JJSjI5a2hnFCHsB5udNk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 030A544358;
	Wed, 15 Apr 2026 15:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E53C2BCB0;
	Wed, 15 Apr 2026 15:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776267720;
	bh=d1HM7PVn1b/sFK5Q8gbW9a2ysyVMOcGPTRDIkGOJLhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kmxzwh5kQhW8yoQvCDKk88rcmiH4uE9fYeC2UDk9u0qQTDlid6ZdbiTuY6C1SJPxR
	 8VKoTahMG+7Wfa02KNDWwNDLH2ab+Fq5j2j95KYHhOzDcwGIzQ8b2aB3d4oKhamDrr
	 I/yxdAotUqD244mkORxNvGkBjyZ6BPEMOcu+MsI4rcGmVLcP7qYolN86FA2ctxTZXB
	 zia1k18/Vfgci1uF7gKkntfQJuDGEZqBOVMVJBTcm48pAyCiVMoSKbB0yLmUm84+RM
	 iG/9Tuoke0ifBXsV0AyJP436IRmypfFZGKf0KU1UQcxqrJp5y7JZFB/ZVj4zXkIfV6
	 9JDfwwOjN6Irg==
Date: Wed, 15 Apr 2026 18:41:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 11/11] liveupdate: fix return value on session
 allocation failure
Message-ID: <ad-xwh2Ecr3Yg270@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-12-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-12-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 39B8E4000A
X-Stat-Signature: 84i7fzxftakfqxxj87wf1xm5e8upyyfs
X-Rspam-User: 
X-HE-Tag: 1776267721-788407
X-HE-Meta: U2FsdGVkX19TNyreJE7REeJuD7YcZvzUXG0QMTkPW8/THUSueX/ioLs7i5QecmdZAhUnlkgDWnuT01v6P6NmNf3JIiGjWRYMiJ1NEU52wtfzTwG1CvpbL+C1PjYHuourOwbF2+GGLZvByXlLZqfITzygmQZhMFjuiZ0i4yBVPk+YYvahM1mwOLkG5A0i6xUk8toNq+sgsO9+PXmsMdBaA2DngzfYakqfemkAyGDrhc3TcaQwwd+s0RXkntQsZVmluhrSYJBFFgrzf2XNhwoguxR1ulqaVfzITDkfKbB68QVN+UaFmc33Ly8GvjJM70AWUa5yjKDjgiARO/Hw9pfeWqyax8XSEutnXGZqY+2xoNsSDr0utXqiA5agoXVOhKRvVxdCHhSzgXD/5tt/Uwdavb9EfjYxZFt4eD8B5kwA6VtmzpqTRPorcHIhvKtodovHUqGCsPY4BwIIXixSXhQZYXDlFzNjhg/srY0nXTRTzgwUZO1lHnuG8KxH5DM+K0V/QtCWczGJXRGAkO4P/W6I8IMQTcHlaNpAKW2AvwyCxXtFGN9TEs0ELBantjWAnBXo58aN1ES+nskwDT+Ur2ZZbVXARz1PdyrF8EPxF2zW9fBtJcI2pZE2Fn9H4bVjJ/+1fHLz2hCACAi0w0zgBJgRbZBkWvBg8osKyWqmWKyjn0eOz4FSGjD0J4LGrHc4f386yYFs0nYsHfqo6C5ZHzxky9MkIJHJ2YWfvseiLWyEBeh0JkRTXc4Ou9/+lzf+IXQCcwK5SFxY+jdAIsiVl0EzmfIYNq//iRa78lBYYHnlex7hypRXm7At/ePXKf4F/RguH44xl4H/83uf7FyHVmBtfMarJz+yTp7+sz7XbDmETjWf9DSPsXlmAUpPH80XTOZPtRPQ9xeJoalZZSy3pxtRrUWKDAxHnA8Y0//1cCfz6muEHprVyQpIo9mlMkrpXCKfUf70jkGebX7dgieYPR8
 7cn9rAwR
 FKi9jR/Sqk8+RW0lr6APyTErAtF6xAPGDbOLzibo6pn3TogmqrVQgA/NR0gZLe/MxNKODwX/fq/qjlWXhF/F+7qhDgqiBrEBX+rAACoSTSajWMEWr2OpJ304mZeFfeJZ5h+nO4jpR+dN6z9GBkV6X75DBb/pT0GT85wr4aoc4og6osx2Y1y0KfU4s4ONYWAruSCmzfRiXwbChf9/vNm2utzKG2uZs3eQYGIFnQZWmBJ9Vq45sKG6YTUcWUxgnnrd9bU26fqhc3PwypjCgJxUWm4DtfemI6pZXcH+UuPcD8H0zInXgHqJcfJ7xEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:27PM +0000, Pasha Tatashin wrote:
> When session allocation fails during deserialization, the global 'err'
> variable was not updated before returning. This caused subsequent calls
> to luo_session_deserialize() to incorrectly report success.
> 
> Ensure 'err' is set to the error code from PTR_ERR(session). This
> ensures that an error is correctly returned to userspace when it
> attempts to open /dev/liveupdate in the new kernel if deserialization
> failed.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_session.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index a3327a28fc1f..92b1af791889 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -547,7 +547,8 @@ int luo_session_deserialize(void)
>  			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
>  				(int)sizeof(sh->ser[i].name),
>  				sh->ser[i].name, session);
> -			return PTR_ERR(session);
> +			err = PTR_ERR(session);

it's really not obvious that err is global and it should be set before
returning.

I'd suggest replacing all return with goto that will return err;
This way it should be clearer that since err is returned it should be set.

> +			return err;
>  		}
>  
>  		err = luo_session_insert(sh, session);
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

