Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD1CD2A532
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 21:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537D96B00B0; Thu,  4 Dec 2025 16:27:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50FED6B00DB; Thu,  4 Dec 2025 16:27:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44CCB6B00DD; Thu,  4 Dec 2025 16:27:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35D7B6B00B0
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:27:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2CCAB89E4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:27:14 +0000 (UTC)
X-FDA: 84183074388.22.40E13AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 439671A000F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:27:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwZMdJYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764883633; a=rsa-sha256;
	cv=none;
	b=ge3oQigz+BPFF6oP5fpifr9ehKmMRHbZ5FepHDF6t63m25T3D2pcXU3fWXZSUr15x9F+cl
	EmT1/DNZLrTt3NB72N5u4AvaTwcsfCpHKqd1QSCHEhJg1Lk9T6HaQKRrQWvLS/YVv4ddex
	pGNTXv6rKtuVLMo/Q+tIyKWexjPLtBQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwZMdJYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764883633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09mxmHg2Z/Wa1Y7NAyngo1yrqctVpyeDUcumoglVSpc=;
	b=ALluftiw9mqmG9ModXmPNsYHm6IxeJcwHYr6ffP80UTbPXR6dJZluUq3UeCxpFVL0rpZpn
	Mmi5AJZLLdyMTQ7fRM62aASoZX0JTtaSiDT+cFru8xKjz1KHeVxfMSJNlGK0JmeJBXn9PF
	tXHuAs1o1V832V1kpNZj8Cy0cCKMwD0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9D6660204;
	Thu,  4 Dec 2025 21:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18577C4CEFB;
	Thu,  4 Dec 2025 21:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764883632;
	bh=+/9nEHZ6AaSyxVANsChIx0fzl5kuKPosTq+Q94nXS5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SwZMdJYi3acOG/EsgN2/8AAaszdXWocRoZuqwRdsYLDUgBWGzYM3cP1VoOaV4gkIt
	 22FZ9t/PaZiAkr3gGJTCaJE/8eBSb4hL5Xh663kXBWjQQgMfLvYKDy2f6BuwzUq9nf
	 Vf/aS0zVEeRkFKaM1y46tT37+45wn3wdKXw843pHDvXybr5OC/ESU+20gGjhHelW5p
	 HiuegQ60VJXdWExXgBK+/Z0f3RmHMe2jTMnxJ2SlsUmS/6XxNCM4DppLuLt4RTratl
	 2Fv3iRhSqCR2aPs4RXQQA5/o9xrHZvlRWDmIkq0XEKj8PvGVUvA6t7y2TH7UZMMgUW
	 o03GHxRje/JPA==
Date: Thu, 4 Dec 2025 23:27:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: akpm@linux-foundation.org, david@kernel.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, masahiroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
Message-ID: <aTH8qCZinkL-4SDa@kernel.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204023358.54107-1-skhan@linuxfoundation.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 439671A000F
X-Stat-Signature: p5ainwuc98afjiono1sn8h5ko9jrajy9
X-Rspam-User: 
X-HE-Tag: 1764883633-426862
X-HE-Meta: U2FsdGVkX1+y8zOnd+SQu4jo9Hr4mre/5pv4jKhdvzGfiF4ZK/m4OdYJs7KfAWwVAsFCQfIpImAHpw+qVUXSHV8BF1ylAQCifYou86QAej3r9pyD6lrsx/nHYrA8AjT86Sk+V6NoIcWh2iyGUOT2993XHAKO0eXGmONRuOrKMmKs7G/zlHd+gDnb30hIb5F0h6ACVswP7354Ayi1qqai7gTjtq3wJZ7GQfpmz1V7NTBXCY74YBPPf9eF8Stq9814VisLlEt+8crZ1Q9J7iuQcAMwFKfhuTZl4wot3a0coj3RBTMk1pbqkFih5vZxSJM+0Y7wPjeCHePwUvSuLKG8uC884Z75+IAHRPtP1qn7tUBGp9oSr1G51aFQCdT6uDScqeU0p1Gj+qcH3jGkat5YejXZxkbKTik7KtwP23gc7oiVd49RA9PoiYu4xeUgX4kNb1XPXEpPBY28ayKlf3nZgAIhlFaRiz5xoq89jI94XVV3btpUCH/HCusGIcnAxJdHETedYl81xeNXWbizjL1knhNl3guRfPC0ARAqaG34nJL8R0U3XW3svjTXAupp3nDIAkRL68cjanJJU6ijb05xrZQRniP9ccEespRo2W4BbdlRfXqbo5W1PHCLXasSEEo4N0N1yH7A2BJbqCG2lkRZ4zG3nlKYM8+xVWnz7vh3Y0Bfkr8Ay06srBnWn0f0JsaiBTTr7MRWGeAWLnetLrBxe+q4ToqezGAAFrI8Qlk4fqUl1Rxv6APy8SbXrT7a3nTedI8HFROg1ApRNiGwrwZSyqmsqAkd6wop2dn+w3n5YVPDBZHIqmEmJBfmZmfPBTjsnJPjV60uB1ptOXAIscf1HIJJyx9xTuz0GpbncEqS8rh7YRkLkwcu1SBFwxbrGLDne//kcy2GbXvJB6dKiOmc3duVA2N6GkFu3mA1BUcinegxv754QgLXXUxC3S2+GZqhBq2Dds9tFju9u4XfC8t
 hxhfHxeQ
 hoWIiDWrFHH9j5lLy5/w9feHBt5B6e9VZLUMEzJu4vBsfYdDxT3AlSG/NG3l5iZgbU2cSbri0bgPk0OIC8GAcjknNOWdJkYec7dbbAbmjfH0URl0g9rJeWZkEp4Gyba+bf6zEHBSlc42FpqMk+ilPHpSz1Ne+n3BeXdKhS3E3zkk6TOJx6/XTwKoLXUummq/kW/pYdFmsX3Cmw4iLqW61Cd0OpLgA6uz8PWfhUZbUmaPfzFhYAMw8WOko74kuiGT78GSDIj0eSsRr3U946u16sW00lkZleMAhlrHZgf9NpQ68jKAKoKJsqihBmSJ8cVSfOiDSFta07CylsfE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shuah,

On Wed, Dec 03, 2025 at 07:33:56PM -0700, Shuah Khan wrote:
> This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.
> 
> Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
> systems. git fetch-pack fails when cloning large repos and make hangs
> or errors out of Makefile.build with Error: 139. These failures are
> random with git clone failing after fetching 1% of the objects, and
> make hangs while compiling random files.
> 
> The blow is is one of the git clone failures:
> 
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux_6.19
> Cloning into 'linux_6.19'...
> remote: Enumerating objects: 11173575, done.
> remote: Counting objects: 100% (785/785), done.
> remote: Compressing objects: 100% (373/373), done.
> remote: Total 11173575 (delta 534), reused 505 (delta 411), pack-reused 11172790 (from 1)
> Receiving objects: 100% (11173575/11173575), 3.00 GiB | 7.08 MiB/s, done.
> Resolving deltas: 100% (9195212/9195212), done.
> fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
> fatal: fetch-pack: invalid index-pack output

Do you have the kernel log for the failing system? 

-- 
Sincerely yours,
Mike.

