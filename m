Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE88FF887E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 01:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9674A6B0088; Wed, 29 Apr 2026 21:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916BD6B008A; Wed, 29 Apr 2026 21:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8554E6B008C; Wed, 29 Apr 2026 21:10:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 741A16B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:10:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00373140BCA
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:03:42 +0000 (UTC)
X-FDA: 84713424684.13.5728903
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3033980008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:03:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B1h6EGEa;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777511021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nie39FwUGzpvQQUteZWwz/0F11Lw2PD4zi/e1UDVHdc=;
	b=jDkL1mZ7RlCvYk0mnP8GyS2Y+a4TgF7LoS1wZTs5pJ/zGjYG8Uq/b9jf8RqFiGmj/RE2Tx
	E4YHRhoZ3cUpcBal7gMTI7b91bwlbDW/San98THyzsp6xzDci5DzH6RtitF+fW7GVY18m6
	+pOrY6cVDtiv+duJOt0MIPmFoEKTfk4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B1h6EGEa;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777511021; a=rsa-sha256;
	cv=none;
	b=yy8Q3GGv6b3OMrmL1ygi0aML80a91mKd8sRyefjVjAs0X/v+foa2uBcBKMYk2I2XRfS/LJ
	MfQkNIKaBzNP/Ti8xPVTfVvxxMH615LXLzWqtoETXnyIEypweRlLkhyPxUHIrXfsHOrKIR
	yS5BR+v/tt/e6arxNFlRdj34drLVokM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38DF26024D;
	Thu, 30 Apr 2026 01:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD1AC19425;
	Thu, 30 Apr 2026 01:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777511019;
	bh=6tv8sKnaOedjleOJpNkqRGOfecG2JG8qeIXOpU9VwVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1h6EGEaVDT7ULvhJRLe1vkELBRXpUhhBEnR6orlJ4zVndEeRaZvhYyQS2Y0WNM9a
	 8dsnAFsSXGo5bdA6tHWpsgNaCEn8eROVpTtz7z6O3Hs2OuryAeo32JJpOGTkz6VlOH
	 noEurSGE7vRjLKbbFKWCeVDb9aV3KQqZqM5OWYamlocO2ByLIxQ8AFApUDUY8cWBXl
	 yEvQUxR66573S6eooZTz7/wXY7A/nu96m8GMsBw6oLYWNT7nrBqYEAg7TvXMVXBKjl
	 Q/0dnMCin0uc9pp1L38f9kYPlJQrokXeRiyUCM3jHk95L1HxBm+dUbdEzbA1CrDx52
	 wogvKy9OQQ5oA==
From: SeongJae Park <sj@kernel.org>
To: Manuel Ebner <manuelebner@mailbox.org>
Cc: SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org,
	linux-mm@kvack.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 3/3] Documentation: deprecated.rst: kmalloc-family: mark argument as optional
Date: Wed, 29 Apr 2026 18:03:32 -0700
Message-ID: <20260430010332.114100-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429072704.311603-2-manuelebner@mailbox.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3033980008
X-Stat-Signature: f6fzm8jsx3jhsbjoipt59pnhjbxgyn5m
X-HE-Tag: 1777511020-42959
X-HE-Meta: U2FsdGVkX18iZnVUutt5UKU4rnXBy7Pn0emPtD9iuXEDrCLGJJ5kts3c7gw/tHS/iEgHbp5Tt2pIFPuEsfclLszddo21MEz56D7ICsNMff2JkrRsAkE6sL9UNCC4T+090aHY1Q5hVnA7KXZHn2jY/9vs1SpYfLUsTsRLQ9aUJHk/6ZQbfSpcoR7D5YDioaRXqQMnfEqsviaoy65VVEcn/UBy74oK+A3ox79/o8X+bdrJJvpzWQcbJVPt8TyWsoq54N9nb9GFMIZOrz/gYkrDzIbVE83NUueWYkU+PEQTfrWx1V5IOa7WzU6do/GJbIfskTiRz0dE8jtAvXyGqrUVakwt+sCDc+E5zZnjFPyYpZc3N/OJaO89hdqkIo0QFttK884qVFEXbGtlERGcMG7zgS9i280QPA6/FTKyIKbysHOsR4rWwtPN1Bx2DG8pzIrT5LbBQeqBReQ2945xkMrWy1+sFO1Bagpu6t2P/8dRp5UUsrGa6TXqtcgLdww0URSnYjP0Ig5Od0IppYvVmetZEFcOjwcxIlQCKa+Nk9vb4p2Bo6o8x5zFk4yaMe6QagAJbMg/D7gCn30gWeFiYaZjVviRk0et1VjHpvDA912hJgXduaQ44y+uybC3C/Q0pOsyuRlNWvjr3DdCa/ox4WY0fxClRCWXfGJAwPDIX3bhpX7ZWYvVDTfk0QTcOqH0T9WPMQRei5GHVCeCcDmh6DxPFhjgJtKgKXg9eNwu8pztbf+1WDzenxziYheRnTbIV0JSVSRNTzzi+lFPuBa2qdjhWvWK1g2eSFW3jmDDpTSxQreGm1zn8bAsv8Kgov+eNitUus6hSA4dKFrIad1Scx1HI3chYJNwXBQTVkvu1zVn/V20MNL5zY+NMhMlc2esI1o+Cu5+RZns7XiBZFmhamaEhMflcYTHV0f+qb7g+yt4gaRFw19rYIVpViECkPM5LJOS/XGqRuhTv1T4mnBk9t1
 S/b+zD7F
 fv7Wj9YedfztAg2R0Ywniw2I38oILcsYhEuI4n2jW8z/HFd9pHizm1Kz0RvL7ZuazcPYpfTZwOEdmbvMBKa+VtEP3w7IAct7J8C60jfUqHDvPbALHXmHretCBexM8nQ9dYq/gw6gSxnwkVAQOcFeJp+3axdQ5sXYMqaJRuNAHp1YbZV+TrmKaAyGF1FzPUxwlMZvkYy88VdmcU0jzE1g21WzxvaF7PL8apI/kndYKFBTYO86dXOhqlxCTCeuL7sOkIxHCHAHhLTGdaBE+pMqT7Wzj7OOI+sUGGAPg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 09:27:04 +0200 Manuel Ebner <manuelebner@mailbox.org> wrote:

> put the optional argument (gfp) in square brackets
> add default value = GFP_KERNEL
> 
> eg. ptr = kmalloc_obj(*ptr, gfp);
>  -> ptr = kmalloc_obj(*ptr [, gfp] );
> 
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>

I have a trivial question below, but because it is trivial,

Acked-by: SeongJae Park <sj@kernel.org>

> ---
>  Documentation/process/deprecated.rst | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
> index fed56864d036..ac75b7ecac47 100644
> --- a/Documentation/process/deprecated.rst
> +++ b/Documentation/process/deprecated.rst
> @@ -392,13 +392,14 @@ allocations. For example, these open coded assignments::
>  
>  become, respectively::
>  
> -	ptr = kmalloc_obj(*ptr, gfp);
> -	ptr = kzalloc_obj(*ptr, gfp);
> -	ptr = kmalloc_objs(*ptr, count, gfp);
> -	ptr = kzalloc_objs(*ptr, count, gfp);
> -	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> -	__auto_type ptr = kmalloc_obj(struct foo, gfp);
> -
> +	ptr = kmalloc_obj(*ptr [, gfp] );
> +	ptr = kzalloc_obj(*ptr [, gfp] );
> +	ptr = kmalloc_objs(*ptr, count [, gfp] );
> +	ptr = kzalloc_objs(*ptr, count [, gfp] );
> +	ptr = kmalloc_flex(*ptr, flex_member, count [, gfp] );
> +	__auto_type ptr = kmalloc_obj(struct foo [, gfp] );
> +
> +The argument gfp is optional, the default value is GFP_KERNEL.
>  If `ptr->flex_member` is annotated with __counted_by(), the allocation
>  will automatically fail if `count` is larger than the maximum
>  representable value that can be stored in the counter member associated

Like 'ptr->flex_member' and 'count', why don't you enclose 'gfp' and
'GFP_KERNEL' with backticks ('`')?


Thanks,
SJ

[...]

