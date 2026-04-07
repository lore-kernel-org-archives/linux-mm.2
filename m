Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32FBAFEEF50
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAB36B0089; Tue,  7 Apr 2026 10:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792056B008A; Tue,  7 Apr 2026 10:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CEE16B008C; Tue,  7 Apr 2026 10:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 598A66B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:33:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECD855B581
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:33:08 +0000 (UTC)
X-FDA: 84632002056.30.24B9B80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5855F180008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:33:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GOE5Rr4q;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775572387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7kdpurXW2gj1sLnJLXi1GJ+jwcDo07ajjVIHmessYg=;
	b=E23xpLKsOekpiXDn9N0LCHvQikOt4Sjub/gpyqdOl3HnnJSNg72dC7pFp8CS5dxTYVT4iw
	RQjTYwGOGHcaO0AvyDf3uXAu0ZWJuNk+9H80SzKk5xWW7nvi3O6TJg0WDstJ3Q70GQd4XK
	FDHqNmXQF1PIhaR7HRL77WSFCHAdbtI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GOE5Rr4q;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775572387; a=rsa-sha256;
	cv=none;
	b=sOu2dm+Y6QKX5J0hD8Jeamg0zX58x23Ee1kpRGdjeORiGEho31+o3QxmiA5Z6VEvgKyzc0
	H9cVyjt+aILAnZYpmaH2AD46YhjHAxqb2vGON9//FvrzPwnjnBV7exZid9iCHBKfGTP34P
	kjdQV70XnRedPdy5l5la789jcanh4bs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4842600AC;
	Tue,  7 Apr 2026 14:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4675DC116C6;
	Tue,  7 Apr 2026 14:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775572386;
	bh=WJCSs57FyEtx1BbwUP76PgD4nrF7tpFgSLQ+QREMq7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GOE5Rr4qgmLYU2OH4Qi47OtekLjs+ja1Duqn/llCdgWOet+tpqceQ/ScTNFQT81uq
	 p+tCsjAb/YkYh4ONw8FYpMf5VZE9ff3ECyxpUHXUwzfvEvKqvUGk8X+O/+gH5DuMlP
	 6z0lZfunwTkL0qJ3/YYMeCxMlltNiapBGZG0ZSCz9yFLFuJmKQfr7HhFJagDekaW5S
	 MRKXMmOp5lGba67NTRMOX4/oV6NHBgYZl4rKau4kKBq94ePVbTQJ8peCjE9dJ82k6h
	 wClQA1L/NANAfFyuMgMTiyxy785U6AuedrPKMIfR6tVaf+NFmq9KxpNrLKyO0GI5uM
	 KHe56FJUFh4Pg==
Date: Tue, 7 Apr 2026 15:33:00 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yury Khrustalev <yury.khrustalev@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
Message-ID: <adUVjtFC5HZgnqWU@lucifer>
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407125133.564182-1-kevin.brodsky@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5855F180008
X-Stat-Signature: 9joy7mc1sk7szx9gza3zbw44ryhk1qbr
X-Rspamd-Server: rspam06
X-HE-Tag: 1775572387-735677
X-HE-Meta: U2FsdGVkX1+MpBBhRw2yrcivXAIIbzHqkapafuhKUlrLKwryelt87LsgTPHoJVq0IMzcpxEWEJso0GHo0CRmDkiMOHLypFCsr2wta27NhpYUXNb1Xf59Ry/IeKo3PUhec+MxjNv43iskmq+4ir+ybK8vT5qUKmwBlL7nx+X7CagfwngXdPXcOej4A3F7oqHD9T1BY1iPyPt/657cYPF7/OBJrIi7IQ+QMiCph3PwSn25X7pkPOEDE65HcPn485eK26NsafySJW2KyHHW7aJGbepxBFz9d6co52gfXliPyM9zviFcDr1XjpiSkHYCZHzVwyDTPPCzmnr26TZ5fnfL19/7lF9UMCEqKQcoZss26D7IK0vvgqT7+jQ4qDShoECbNztfWZBrPRFK4VRwPkifJTPFf2vM2q46oIt9W3RM/1VtdqQ5TYQFZHEg4Yl/1lQ+L2MY1vD3TAzQKACg1roWvdnAEWoy0H9+QoZ95c8h5gohiKaalSGYuqhR/Kf2MfXlDbdYlWgmF8dMJpXmr1g+VPti6GayXEyDgekvtgpHV+K4d9M2DBu5rG4GoinmFSfqlfgia8KlW9mC06KmRTTlGZkqiE8b68sAFJdcWnBNnaAWY/IgroBjoG4tQOyGbpn4i4jfpEqFyxxTNE9YBxSYvi6IyWi5MogkbbyYiJFrID8zkMqabqkS0MnJhuR0/YAcky9wBwOIVcinRQmPuDasilNIm2LWXY4+LJSPqOUKg4YNlxnPuWl4oJneq0hGbxoGwgzg8d81HtwYmXyF6VcYjDhi5nhPrJG6wkydD92icvXTtEF7fzDmUjsyaVuh8TEtf0HMyFIEuI1B1zLR4jYDAqx2nb52UzI/PvkHzFYfNfa4/BfSJmNz097R9vPRuqFQ1AnYPZiU7E71dkQwrvvtPI8/fkbC1Njego2hWqL/2ZcxOgSxp/xKfEWQ2WGtou9hCBf+vTAaaV95o9UAyXL
 71iEqYLK
 vqgudLs/EYygRIaHrEbbed4L6Mh+6B6J+I6gDS6u6tKf4MAJ+3TiF7Wsp+ThDeo3/2NYtB09Tifr5jlRHpy+szxFxotjQDEr+LFoq7t1Tm3CYUv02Xr/1eHc24Sme8KdJhgexksXNx8YUqbsqF1GAHFQULjUphJG4io008wRS9qKDEJjVwkR1Y3WwSR5kdhM8OKyC1tQWynywohZVehpehunwT8JFXX5gF0WJtPoJpBHWjMB8FpG4dWgtB+g5NmTMxwrPYT7HDwLHEtO50VRcUYIlp0480ge0Z3B4N9rQCTgAdJyFgTKF+7qyY+9Z2ul9BcFVACJMJax/7ex/IaXOC0iTOHmMKVoVUjgBe6hahwqUeYsgt5rcw+RntDRw3r+c2rq552KnJJ7pD88LOa/mDZySyN3vH4oVSJ8wws9UkbMrGtBccUVfTcNR90SwnInOp3V7Ji6VwxKRL0G3nCFx4yP/rnu/59Hng4QR2UGI1e2gxmlHGKzx6RXKu3hESkhzjGsw9MUxpFT99WnQkhdNc7k9jFVbgGh+ubIsX7mkLPQ5uxjjz900sEvTbKY9DZzsv06SrpdC4TcUR2QqL/wNeH4OJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 01:51:33PM +0100, Kevin Brodsky wrote:
> The ProtectionKey entry was added in v4.9; back then it was
> x86-specific, but it now lives in generic code and applies to all
> architectures supporting pkeys (currently x86, power, arm64).
>
> Time to document it: add a paragraph to proc.rst about the
> ProtectionKey entry.
>
> Reported-by: Yury Khrustalev <yury.khrustalev@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

LGTM, So:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  Documentation/filesystems/proc.rst | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index b0c0d1b45b99..d673cad7dbe4 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -549,6 +549,10 @@ does not take into account swapped out page of underlying shmem objects.
>  naturally aligned THP pages of any currently enabled size. 1 if true, 0
>  otherwise.
>
> +If both the kernel and the system support protection keys (pkeys),
> +"ProtectionKey" indicates the memory protection key associated with the
> +virtual memory area.
> +
>  "VmFlags" field deserves a separate description. This member represents the
>  kernel flags associated with the particular virtual memory area in two letter
>  encoded manner. The codes are the following:
> --
> 2.51.2
>

