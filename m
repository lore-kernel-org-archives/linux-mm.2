Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4B0606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F1loS7Bu
Received: by kanga.kvack.org (Postfix)
	id 83BBA6B0695; Wed, 21 Oct 2026 05:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC3E6B0696; Wed, 21 Oct 2026 05:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703906B0697; Wed, 21 Oct 2026 05:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 510A46B0695
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:47:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D25ECC04F8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:47:41 +0000 (UTC)
X-FDA: 85346156322.03.259AE6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3FFF91A0002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:47:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1loS7Bu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792576060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JpjVsU6FXE7MZxGDqXvB7MMyt/x4Dn0v6kgOUHr85A=;
	b=jYFY2JXBbmgV25KVdDrHC18x6gTF3VhyEZvP6ylqf88UPsz4YujGRA5vsi/b4bnlC+Ti1o
	R1yXC1c8G7wSjkVBOAVayKeQf59B/azpd9H9GCrRPGTnJswGcAKFcxc19yNUdjk4YUe7LA
	n5TCTbL6eBnlvblyLzEM57F9r8NndzQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1loS7Bu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792576060;
	b=J0ZwU3CWrm5gW+4rwCmFsSnffsDseRvRrQaCudeloADrg9ZUoROY+rv8ogzQBlNkLNUDXk
	CxZHJx4FUHSWWT7Nw4orck3ur1r35cM1KYOtUpoYhQ0/92AdEoTHIGlf53LP1G7l2vJ9Yh
	o/iHMXD+Q747rbgyVAzc6SsmT82VGCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B5944369C;
	Wed, 21 Oct 2026 09:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98241F000CB;
	Wed, 21 Oct 2026 09:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792576059;
	bh=8JpjVsU6FXE7MZxGDqXvB7MMyt/x4Dn0v6kgOUHr85A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F1loS7BuDGU8Nq/BOhOEicIwypEeiu9CgOrtdETK4USaT20RidDtt6LsDWv20J5qO
	 qXWVdyTxkXChmsG4Wg60XGjVF31BL84czl48LTtJjPf70YAuduE3WNckkvurPRfb//
	 a1hfJfc2OBNBH/mDKoI9fSLG7u5Y2cld6ytC30F3pszGU91lbU6DqudhbZ0/iRI4qo
	 zf0ia4TZoYkw64U94fZCniy8x+zuaR+BcilSNxQLEkAOEiwbGgW8RwsnkBhZ8gIcsF
	 07mHfG8xT4aH70m3WyCB53m/VOoxFMDY/qa/omEcGk4LFeQTqdeRl9p4qGW9OWCu5Z
	 wkD2VBY737Mrg==
Date: Wed, 21 Oct 2026 10:47:37 +0100
From: Harry Yoo <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/percpu: clean up callers of pcpu_obj_full_size()
Message-ID: <atiKBXHXjXcC2Ykc@thinkstation>
References: <20261021023011.3199331-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021023011.3199331-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FFF91A0002
X-Stat-Signature: h8jo9wx5p36c3uje48tm3qgu3pit3hc3
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792576060-345038
X-HE-Meta: U2FsdGVkX1/wNuDuP9Yv5QZ0zDX8c4pBYF9xa3n1SBPH6K+ZIoEZ9Jv5jbjZzeeXzmu+OrEyx8kj/Ncoo6e36dT7Psc3JPFGmrm0bZ0AXzgT1YV2dQ9DQaYdkmC7XEoVExMVtRhGuiZ7RFWUSsNI6wIB7dhwqYCQe6Fzwe2QZkLVIEXKZ/78u9U2E1ikPRjpMuSRXtI3+uduwoaRrJjGbkTNr8SCxDWEL3l9jh2ccYE9EK/5wi9DjtGILHczn4iRr82ZB89qfngGhPpkSRiNKio1ApnG+0leCYkYHlMIazWofheKjpZt58Fa8PCdWndS7SoN01tsLjlv9onfzPXDh0yRekE15Xv6xtYwBsrqQ9BEjIIC/QiNnvl9KmP+oKax9HhutGc4RH2f3o3lZxJkg++oAj1txR75lIEQcvrugIZ5dQ+qA6v+c/7M9Lo7jZKstUpuThSH2wHPNegbmZQWY9q+V0iVUum0Vsy5htj1P/GKL+bkqHCpJ3bCy2hBHAZZNA0NY/EupGOwOGcy7SQbabpih0ydbVuT/fBHGEqXOFb7Mgf7ecSSuAevyE4tqRM/ezd/A5ZvTxc4ztDNF53Eci2L4436YMvQzYR0YU6Dg05SyMPn2L5yw+i3x2MpL0UEGp6x8FoARLJf95Fwh+co/TLxRbtOW2nV5v+AAtTfEZ7K+BzTHL45KjCyRy4JaKIkYF53yakj5fY8IZGsZrnvdB8smC7SUejVD9EUxXrgVKeW5m07IQja0YCkoTYLXffUpA9icHiYK2SS7OR/IFTvElQ7x5yRkVKbfpnZ2/0yeHTCx2R1KkUKMTJWDfnA0hfMdl5YR3uqe1eliQfa4txQzqcUNvimYf8eUIXo9zGfabjC0iXnB1NmDHj26b0TWtqjfvHTIK8jZJEmXTNik4d1OB0ds7AiLFa4KABQYS9Ts/M5guahdJl6T3vx2WTf0JLF/E76hN0nc6kc5AQFCYy
 qGjIswaf
 zm4yGLDFseWGmpVhcZDkz1n9pPZWS8559BnvgC3DtypVHmt4o6F9bcbxtK3nfkKzaq5i22osIkoAa+TwWNk18zJzhQvnmPO3YghH5S2O5zrBxVq3fA0tA1eK3eCkiOLv70KpaYrXfzljIR3ZAsPmCwFbRlijMTCieqeEOjaiLcnn0A+OrZqFwnZ/5rA5uwEmqPPPfECK2otuh2yuElJ5Le/4TUxP4741LVHw45sFHlGoPJLNz2wKdKX0VJ1KceGxF2o4b/o8HYi6G0GTBTxaSloMWnRGfSLRN9kggi5YBPKFkcMbt8trl646Vmian8lv7hOuiirXi0IJG2Raqjtr+51ecpd4k0lEG1NXHPjWPXXtsGXWJzoXThUJdZrKgWD/K+WK065Mcmy9os53FtI4QGeHzhOiQM3b9Ta/C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 07:30:11PM -0700, Joshua Hahn wrote:
> The size of a pcpu allocation can be interpreted in two ways:
> 1. The size of the allocation attributable to a single CPU.
> 2. The total size of the allocation across all CPUs, including the
>    allocation overhead (for obj_cgroup membership).
> 
> In most accounting paths for percpu memory, we need the second
> definition (full size). Make this more obvious by coalescing the
> callers of pcpu_obj_full_size() and renaming the parameter to full_size
> to distinguish between the two definitions above.
> 
> No functional changes intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

Thanks!

-- 
Cheers,
Harry / Hyeonggon

