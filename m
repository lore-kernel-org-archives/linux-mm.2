Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672B8FC9EDA
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 08:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9456B0005; Sat,  7 Mar 2026 03:12:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756B66B0089; Sat,  7 Mar 2026 03:12:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662416B008A; Sat,  7 Mar 2026 03:12:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5FE6B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 03:12:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC2ABBB59C
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 08:12:29 +0000 (UTC)
X-FDA: 84518550018.02.3F22532
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3B719180003
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 08:12:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZtP21oxO;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772871148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sdze1vMs0OuzQgYDA8e+FxqVAK6kCnnSYKiZeIT3DIg=;
	b=qDQop9wyyS/5kuXPGZWNYbs0vwkLN5RjSQZ6bMuaYyl7ejImqNQMe1MIkP/1Ei9Eo438Vy
	YpC7edCOZTOFncFUMEaz+GHvilUQCkj6RNDUTd4QgLcL2wJbP7uSYurDTTqLRP1NZzbI6D
	rPEqBC5a6/oBxJkBg1h3i8wpLe7/Pf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772871148; a=rsa-sha256;
	cv=none;
	b=QgNJZFJZkcWbEXZA0a25jo5uu2dIM6IrmCwfFcZTlXvLVerY411hlUZ1txcSaI3flprP3p
	kthZDnUxmOI4tjTC6qK58IPzO/axuq9vCKbA21z9pRs7vLX8CP34iQDj/Z9JYmwfSxtlde
	AIgFjgKYFeQguXv0EQAt3yr86SVP6Pk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZtP21oxO;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DA9960018;
	Sat,  7 Mar 2026 08:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A79C19422;
	Sat,  7 Mar 2026 08:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772871146;
	bh=pbzFoDuvMn3JPkaovhYfMFaj6gWOQL7cm+VcI8S47tA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZtP21oxOAW5Cgf4Jk3AmX1HmRhDvJOtzr5D1Jphvb7RhIpWZHOSnKV4puwoBPgZyc
	 s1fEMY3IKS/tUt9tj7PgRA2MUL1SBWtHHRFSyxPHhqO8pycuLD3Bggv0IWYSGssEsv
	 YbZAvIo9wkFMk9p3pd66OCtpZtvKBB/9/BaRzWGb3wXHL7AMqIbt15ih163DoZP8fP
	 YuSGahVBsoa68hPOHa8W4bJPRhw0bqZVXZc/YnY4SsbHCDzxus66mz8DkhGgWBmo/t
	 pyuczhiMiWRpOWHbBDRMLmE4+65w0RpHyOmqylV4gicnb8V6x2AQ4xuiCSw1SccV4t
	 iIw66Ud6x92KQ==
Date: Sat, 7 Mar 2026 10:12:18 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Xie Yuanbin <qq570070308@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
	morbo@google.com, justinstitt@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] mm: optimize once judgment with clang
Message-ID: <aavd4hoAO1DFLuJP@kernel.org>
References: <20260307065405.37473-1-qq570070308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307065405.37473-1-qq570070308@gmail.com>
X-Rspam-User: 
X-Stat-Signature: nx4bo4k6u5gi4c4bdqwj89zqx7ez5fdo
X-Rspamd-Queue-Id: 3B719180003
X-Rspamd-Server: rspam03
X-HE-Tag: 1772871148-310669
X-HE-Meta: U2FsdGVkX1/iCAr7cIYrSLHSZgJ5VnY1x1CpQduwS0VgQ2fBhQqdCv6jRgQ0PEs3sYRz3U+AiXpu9H4vMVeD9z4R56X90Opxw3BampkOWheyMemfkefYYrUmFBAiln1Ac8B3QtFgEdkQcJHwfjO1RDYDukQmBVA6XQoQVqI4MMbaPupoAvclrmSA1QT/aFCfCxIq/7lmkpFp2eKiFGr9wXtrzhWHdopOjvDyNUnJD5K/EqjXUEWW6azu/5nK+C21MR49hmpYBbK94QGSblg/hiMOTtWthDW+HCJwmpgPE42zPu9X0xw1axZvkz1iQLAFD7I4jXmuK76xF9NfJWinJzxYN4PnMSf3KjbcmLC77/aMRWsbMIk7Uzxfs9grQM21NxYBM66GVhOLaKjq5oxng6VloU5p4I92+R92NmYdz7X11BGIcC7C8adV3xLpgQlDAlqwpDiYlsUiiRKnjT/OakGl8cHKO5Dc5Y7Op6vd8Pl1hHvMiLI3zWgWS0JCIimTVsPHr9p2uAtrSjYD2S0KHFTSKdjPApgYzPgPKPAoMuvSNsPbywLuxwWYZNw1+SENMlBBDRTwfyHhyGRzg1LVHH2szIdozFwaE9HHsQ90m2OpgseM/swlUWcLcjYh7BCN+ljb6A/I5MiH5zAjVGOzHNVWZt7nOue2LTLoOX2SylcH1v5ra0wpldUiqk6PbTgXXinBX5iNcrZm2eS1b9kkVcg2KdOGVzpxgsiot+vp9qF8U0J43rWebM0h+p3tHBDOnOYXvYYGTefH0yaZKkrnNrFTauEEN12IIIILGlNoAYznw/vqm0+fjST+NSa7AKs7JeK4IzF5tVQWeGr4Aq0txRFdgGhPQJngxO6cSIEhIxQO5In16xQH5mPq/zbuk65c+NrG4RCp/d7Yv60eYn8yQPPjJqfFtYI4/Amorow5eqTja77QWOHLA1o744CMXFoC2FExycUCTmMhK7noY2k
 vsf+XoqQ
 eNpoakyL/Dlm+Lw2q3amF3B7X/r2Zj5Pa5jvqqH6WIUJC7ltxEdkQj31HoSwIkNDNpppw7VIBnFbhdyE/Wn9swWGQWRGqrv/+2+CxzxZeEDcoi/a4Cvqa/NkRmSg85wq1VCZFWZDVzB+618+fh6qj7ot5AFTtKfcVjWKKrhdXNwvAngcfwoXJkGxXL0GcV9oq8l9VSA+I8BxDh8LLtgtZT8o7/M26BtaOZGftLjay3x9BRLXCrtmqHklaM5SGU2zla7tQFnVCwBBj95igZzy+dnOmGeR2Kmv4RTkHC4oZxtGFh8YN1ZMiOAJcRb5wmb4UBN4VSuq+qeE1PdVwBsSwuCSrlRFK7D0T6EKFnx8LkBhRKM0Fr2n4aXZvwsczYfBVx4w2aVPL1PVx0gp60ykOCgXBMYC6Jw1dpYg+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 07, 2026 at 02:54:04PM +0800, Xie Yuanbin wrote:
> commit 242b872239f6a7deacbc ("include/linux/once_lite.h: fix judgment in
> WARN_ONCE with clang") helps optimize performance and size under the
> clang compiler, but the modification is not complete.

How much does it actually optimize for size?
Note that performance is really not critical here because we are already
dealing with slow path of debug code.
 
> Port the modification to WARN_ON_ONCE_GFP(), VM_WARN_ON_ONCE_PAGE(),
> VM_WARN_ON_ONCE_FOLIO(), VM_WARN_ON_ONCE_MM() and VM_WARN_ON_ONCE_VMA().
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Xie Yuanbin <qq570070308@gmail.com>
> ---
>  include/linux/mmdebug.h | 8 ++++----
>  mm/internal.h           | 3 ++-
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> index ab60ffba08f5..a167c5aa525e 100644
> --- a/include/linux/mmdebug.h
> +++ b/include/linux/mmdebug.h
> @@ -60,7 +60,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>  	static bool __section(".data..once") __warned;			\
>  	int __ret_warn_once = !!(cond);					\
>  									\
> -	if (unlikely(__ret_warn_once && !__warned)) {			\
> +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
>  		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
>  		__warned = true;					\
>  		WARN_ON(1);						\
> @@ -80,7 +80,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>  	static bool __section(".data..once") __warned;			\
>  	int __ret_warn_once = !!(cond);					\
>  									\
> -	if (unlikely(__ret_warn_once && !__warned)) {			\
> +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
>  		dump_page(&folio->page, "VM_WARN_ON_ONCE_FOLIO(" __stringify(cond)")");\
>  		__warned = true;					\
>  		WARN_ON(1);						\
> @@ -91,7 +91,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>  	static bool __section(".data..once") __warned;			\
>  	int __ret_warn_once = !!(cond);					\
>  									\
> -	if (unlikely(__ret_warn_once && !__warned)) {			\
> +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
>  		dump_mm(mm);						\
>  		__warned = true;					\
>  		WARN_ON(1);						\
> @@ -102,7 +102,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>  	static bool __section(".data..once") __warned;			\
>  	int __ret_warn_once = !!(cond);					\
>  									\
> -	if (unlikely(__ret_warn_once && !__warned)) {			\
> +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
>  		dump_vma(vma);						\
>  		__warned = true;					\
>  		WARN_ON(1);						\
> diff --git a/mm/internal.h b/mm/internal.h
> index 6e1162e13289..52367f52d623 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -93,7 +93,8 @@ struct pagetable_move_control {
>  	static bool __section(".data..once") __warned;			\
>  	int __ret_warn_once = !!(cond);					\
>  									\
> -	if (unlikely(!(gfp & __GFP_NOWARN) && __ret_warn_once && !__warned)) { \
> +	if (unlikely(__ret_warn_once) && !(gfp & __GFP_NOWARN) &&	\
> +	    unlikely(!__warned)) {					\
>  		__warned = true;					\
>  		WARN_ON(1);						\
>  	}								\
> -- 
> 2.51.0
> 

-- 
Sincerely yours,
Mike.

