Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D1D10FCAD2
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 20:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424176B0088; Wed,  1 Apr 2026 16:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5136B0089; Wed,  1 Apr 2026 16:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB166B008A; Wed,  1 Apr 2026 16:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 197466B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:44:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A027789AC1
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:44:04 +0000 (UTC)
X-FDA: 84611164008.13.59A231B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EF10640009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:44:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SVC1G+9q;
	spf=pass (imf04.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775076243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMe2h+8nwoxfX40YPi4Rbri4SOzp9FJKTrDnD96vqkw=;
	b=7k/iKpACTHdcQRwOOQQfbTahDeSqPoYKCnLg8aj6UcL7vyjJxS0NtYYVIUYj7RYNuwF9ye
	vUnfPY0jFs3JbF1lJv1Jlp7neHQVQR+DvBka+kdeVWmy57oVryS7i5W6W51aTFB+TVffa4
	VThIxGXLOEp7GL6VENaxHoypSVHy1es=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775076243; a=rsa-sha256;
	cv=none;
	b=Qc+3mHfaAEcOckQHLKCs3vO2LXVc+1FHwyB0TWaZFIkxqZGS8j35WFIvHai46tqW5cktTR
	TX0wCzM97xl8tgkojzKj9snmghrZjTYD2Hg13LAtAA5+OmvpPKJ8GQVepxRZdQR87042k0
	FcaUuf7YzGwVsEWQyoJiRYmNIy5+QU8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SVC1G+9q;
	spf=pass (imf04.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0037844115;
	Wed,  1 Apr 2026 20:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCACC4CEF7;
	Wed,  1 Apr 2026 20:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775076241;
	bh=kTOS3uekJiiJ5a6z93beysMcrDQebo3EZ8N7JGrOBNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SVC1G+9qBK5pCrZkNWxdglydUIgueJO94ACXdf/Xztp3Npu7WHpWWPpRC59QtVDTu
	 jwIRDs1ZwWfKffRZq2/C25rUuH6bXOvsqbOiXkq52vDgNWX+Xl0ozaeaJaVkqMj9Qw
	 qRK1Iyl1gtxyEUD/5R3EOGrpZQ6DsKiqPYLCnjsiqW/FsF7zNnQy1TltcT7+JunXGo
	 dNEDAzO4oj9lOaoimycNQyMyoz9aBXvMdIg14QAYWoK+iT/XYGgeQR9dorQlRoLt0c
	 57LAT8WKdtDLr2DgJfw+aQTxzcZW5dW4HdTzhGPuV1lsSzbLZMem3p2bDkwbZBnF3D
	 VUuBjnWo7FERQ==
Date: Wed, 1 Apr 2026 13:43:59 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] execve: block Emacs binaries
Message-ID: <20260401204359.GD2466@quark>
References: <20260401131226.4011156-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401131226.4011156-1-mjguzik@gmail.com>
X-Rspamd-Queue-Id: EF10640009
X-Stat-Signature: csjiifncr3cq3zsranx1wjjbab7hkif4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775076242-343465
X-HE-Meta: U2FsdGVkX1+ZnR1HPe6OQft2pDSC0FiK3AytjrSu017uPJpcx5dNkd3oHdkvPoOOsmQFQEB5QSBX21AWj1IpBODsrvdsqZpom40M5Pj1GfuhFPoNmJszCT2hKt5biDBHLXonOzwu0nplcG7F3+gekWhnyjcOYAf/8VIyxYYBDQUCLkJgM5Rw6SG/mpBEwPViZ3CPQtVyJRgLikzfA5WYO2j5lUIRJKEhdJhGNREQrMw34Q7RgQXF7S9yh3r12NojqwfgLi3xiysxJszGBRG8CYyQ8Ql6reTRcY6dLjSWzxp3EfM3cjxsK3XR0Ow3gH0vXc8ddWoawE2Wd2HYBu3SYF8SG5GK4zDi1NqlvnGUPFcOg/m2lICc78gBoSx5zcxQC1U6Vedut6wVY56+9t6E4qIwP6yqXPG7bJbilYl6xChFBJ8SDVVCiwjOHlCTa8munDSLjI+zVvIGlKMTqArHlfbHBXJgfpLV+kUalKijw+DYszG9E5mQzYu4kRdmUaSEVeAZDINKmrpEz1NcOmUhI0X0une5KDqaykM89/fF0iubCEpO7HK5sRRxpMVD2rhJxlG+Yvjm5z5rJ6d/5PYqQ1xuWoRmXXmGZu1uq/Fb4NRT2NdBXAC+bK0oMX45mIIinHFzzQH0gE79rIssexWVp6HiTifMtC2GZZ+U/R3KUnONuw9OqkEGj9DjoG/ZanRUMTmN8SYDw7/dzKOZTIbg+XtGF6iCMmTunQVtQE2xlG4QapQsiUY2tBrDdK5O8dDY9gKLTG7rgEfWkM6Byh6aDFqEf81ZZRXSmLb/MddTJvzHlrhKY+IpAc7dGXj8+Sv+lG2rsYV3GokeFh/61a6RgusA3kytcpJByc33y+7qtMp/XIB0A5UMf6BBKKqNo0LLNY8adpwl1Glkxw9LJ1xymL65l15rQ6KXJs8J2r/Dx1CyxqW7RQ80dLU6y/cDc6jroGuRUfPQ+zxwAIi6+Ys
 TctnaXv1
 Gs+5/1FS2lBMCj0BkpbiM5s1MmbFnBjHsnQJkCxTcR//hUVjjfeWWPtNt20nr42f6UbQCs7PU3ILqW1OfGfX6a+zuHe7FKCUJls7fKid0udwDo/DygCC6P95PNgPzaOKzY3AkmC56OCmVRO3jjwoWRMDP+aQq5Z+isLQ2SZJBy197ied9F+Esue1Aj/jxrTnwWgT6Szb2bmhK4ODl8zbWgC3dDKBR/8sHyFLO+p4PyT+JWUOvJVIeh7whelXFjSFIRCG/8qYYmVCijXqC0Mvu54cnw9yhaHQb7dyyVPmEx+aeFBUdqWBb18GeLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 03:12:26PM +0200, Mateusz Guzik wrote:
> No justification needed.
> 
> A new errno is introduced to indicate what happened.
> 
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> ---
>  fs/exec.c                        | 16 ++++++++++++++++
>  include/uapi/asm-generic/errno.h |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 9ea3a775d51e..2e954b31e3a2 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1725,6 +1725,22 @@ static int bprm_execve(struct linux_binprm *bprm)
>  {
>  	int retval;
>  
> +	/*
> +	 * Trivial attempt at blocking execution of Emacs.
> +	 *
> +	 * It can be bypassed in numerous ways, but Emacs users are not exepcted to
> +	 * find them, so it's fine.
> +	 *
> +	 * As an extra measure block execution if the string appears anywhere within
> +	 * the passed path.
> +	 */
> +	if (strstr(bprm->filename, "emacs")) {
> +		/*
> +		 * Disgusting!
> +		 */
> +		return -EMACS;
> +	}

Won't this break some existing text editing workflows?  To ensure a
seamless transition I'd suggest also embedding a copy of a proper text
editor into the kernel image, and making the kernel automatically
replace the emacs binary with it.

- Eric

