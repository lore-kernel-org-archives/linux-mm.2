Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37937FCC07D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 21:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64A176B0005; Fri,  6 Mar 2026 16:33:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F77B6B0089; Fri,  6 Mar 2026 16:33:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5034C6B008A; Fri,  6 Mar 2026 16:33:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBF16B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:33:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7CCAC1A98
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 21:33:24 +0000 (UTC)
X-FDA: 84516939528.14.830509B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1BF234000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 21:33:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="YZ/xBNKk";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772832803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EfPVcmwsuRKv1y0TA1TiAxpIHxIBaisplZgWh5x9/2I=;
	b=qOvpwjalgVisbNr59DwMV5hyR4QW4qaiQ+aU4p5zr0j7VGSPcWzmEbJ4D2IU8XvM1Hq10Q
	mr/XEvn8VV27i9z07JaR68FSpkNVMYAiRSyId1NnbiiaJIvkJISHJqIgKzmMqGz3lOGHvu
	XohVcZxHtiawLLgVACdequUyxe6wqy4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="YZ/xBNKk";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772832803; a=rsa-sha256;
	cv=none;
	b=j3wovW6SRicliUChTyceJwcUas0C7zNVgmS63r5tF4tcQnHv9moLMMj9uCi9M2I2jryfSp
	wR0BFZrn2ZnwvJKNB2aN8Fsdtk0YG7S5d0NwFBJcdLImoujQu/5MpHZY/KwVzRYJxqoIve
	EwyqIU00mEGFIum22SMWeZLhprQg4ks=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D56260018;
	Fri,  6 Mar 2026 21:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E34C4CEF7;
	Fri,  6 Mar 2026 21:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772832802;
	bh=8jaSIcRSx+9WU8w9NefmaqaqpI5tNzDSPWXQW3xYA5s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YZ/xBNKksGtAYPckNFaiDTD5J5+3zMZkaM45Kfz+l4PN0ZnBiWvY473N8oaX93Rzy
	 B8uX2yQVWtsrXq5dG4jI6WNVnz3Py73QkdcvRTk7nZdKNWo+jvQ5exAu+zLWR9ebDQ
	 NdagGLA99dbNlkReEVhkdcWkuh5cMYTcbUwMOrJ0=
Date: Fri, 6 Mar 2026 13:33:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Law <hlcj1234567@gmail.com>
Cc: Liam.Howlett@oracle.com, aliceryhl@google.com,
 andrewjballance@gmail.com, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Josh Law
 <objecting@objecting.org>
Subject: Re: [PATCH] lib/maple_tree: fix swapped arguments in
 mas_safe_pivot() call
Message-Id: <20260306133321.4fa6c5a73067bd179a5e888e@linux-foundation.org>
In-Reply-To: <20260306200820.2819999-1-objecting@objecting.org>
References: <20260306200820.2819999-1-objecting@objecting.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BF234000B
X-Stat-Signature: gj3z8pe8msi6pydrkbdhz74ddsnzz4bx
X-Rspam-User: 
X-HE-Tag: 1772832802-774568
X-HE-Meta: U2FsdGVkX1/MAcLy0g1Al1F5OqV/Ji06onR3GXwPfW+7Wbe5oD1A7OHeXR72gbM7Z7nBUtDhzHzDHg6UWuzkFrka5QfAL5RPTEjewbKSa7aDvUKisH6GfvIN1aENCahTpZ+/Sc+th7QBd+0VNW6jYUpEAxM7XuyoOw2kYf2sUtTWX2Ju7l0jE/a9jF+MXFcSGZwHh+7qq4gkakP005yjkjTmi5a4Asiqrn1VPgUI/k/4Yc+KrQZbleouJOZfbT96AU2SdfwPSv/zEOcrfFT2dPJMVu8MZdQzcpqg1KmthE5io4U8TvhnD5jfgclL4vtTigNfbFyWNwzW8S2pRm9x00JiJPy7WdcERcynZtGfKikOlGB/f4c42GpgsxtDRyn5t06LtMYDeMli2DKW3XuALvybB33iwZpC9+epVtlhSqAPUwYQzchAT0EOCkstSaNGzEG/DsOLXIaoh5hS+E5aNxx0ksdWfIb0ZY3cD44Oeu0AondSQvH8Ih/JK2bwhh0CU3wdBsLoGnfOvYcqeE9zO4yUKVQb63IkztI6eLQ29Ozt1BeR8DzrdBgbBCE5QtQbdVWq13zuZ2IlmI3w+tXlJwckhs49e85kJD+udMII+JgY8PEtHjvGcBumIfFsdf7puDdfc5UUnpZ0eqXTJE1G06ayZyKwotiGERdtbmsE6FQZ341aY2aVJmGSFCyP9ozCpu5X3LoTk735f7YdJF9B8GySGHuWdDzhuSkyd0SN+mBHg6wePTkvXZn86Y10aQGaVEoY0M6c9WiiLFX/bqgWjsWoJW/WkLMw//0q0pKEg9y+iTabEKqmTUZQo9cfiTBmGqAuTMblu5eEJ54cyL9BX1kT+CFUyQ2M54cEXu/nzu9/JtpGkRYT0wLzqa43JJ/pYOurqGRYE4Kp/pMVE26rJXGpvxY52u4056J8+5VZCJtympfxahg10kvfYAKIfLaPSN8SXJGoNd2tiZIKCDc
 y0YoxDax
 dHw3959oEHFzE7SLb1ji68NJPFE9X3yd6FBbdyNeT8fpU30iBQ53u8mqbRoow8Rp+M1Z1osYG/06YWPEVl/rQB8i65x6s3tDDCQ31I+2HOpIS7O58X3iDZs8gz8Y6owj+0yW2svrO7seURYCfMolWLp4TqDfuLC6po5LoO0ZNzuFFSlOj2ewNc8ay1WLfYYBOKfiBSWsKBz1Xu53nGoIbc0u2OMG3wCTiI+8zM36BTnp4JLGaJCljUo8aGmJEnaokuyCsFCQn7+3KpzbtG5XTHoSKnDyzhXGjgN8yPBYDhayJgBkoafpWBwKc93FNKKp7Lmce9qzPf+6nr1kYPzJUETPXMxJuqW83tc1QCrfDXph1Ky5Je5dNmGb5WCSKEYzFLYna
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  6 Mar 2026 20:08:20 +0000 Josh Law <hlcj1234567@gmail.com> wrote:

> From: Josh Law <objecting@objecting.org>
> 
> The call to mas_safe_pivot() in mas_wr_extend_null() has the pivot index
> and maple type arguments swapped. The function signature expects
> (mas, pivots, piv, type) but the call passes (mas, pivots, type, piv).
> 
> This causes the pivot index to be interpreted as a maple node type and
> vice versa, leading to incorrect pivot lookups. In practice, this means
> a null-extending store into a maple tree node can read the wrong pivot
> value, potentially corrupting the range tracked by the maple state. For
> a VMA maple tree, this could cause an incorrect vm_area_struct range to
> be returned during operations like mmap or munmap, leading to silent
> memory mapping corruption.
> 
> Every other mas_safe_pivot() call site in the file passes the arguments
> in the correct (piv, type) order; this is the only one with them
> reversed.
>
> ...
>
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -3279,7 +3279,7 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
>  	    (r_mas->last < r_mas->max) &&
>  	    !mas_slot_locked(r_mas, r_wr_mas->slots, r_mas->offset + 1)) {
>  		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
> -					     r_wr_mas->type, r_mas->offset + 1);
> +					     r_mas->offset + 1, r_wr_mas->type);
>  		r_mas->offset++;
>  	}

Whoops.  How come nobody has noticed after 4+ years?

I'll add

	Fixes: 54a611b60590 ("Maple Tree: add new data structure")

and maybe cc:stable if we have a reason to do so.

