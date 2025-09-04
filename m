Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C32BCA1014
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 03:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DBD08E0007; Wed,  3 Sep 2025 23:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3E88E0001; Wed,  3 Sep 2025 23:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0B18E0007; Wed,  3 Sep 2025 23:52:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8548E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:52:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F34F51D6DC0
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:52:05 +0000 (UTC)
X-FDA: 83850194652.07.3265840
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 551A6180003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:52:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VbckYjIH;
	spf=pass (imf24.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756957924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHu+iTdIG5S01S/EIjEUwmsaaoJZJsqgpN4mWUiS2lk=;
	b=koKCRvC00Ug4HBn5h4ihXp+INw6psFVosTzXtXxpEqqB3kG2pKCrSfsRa83Z+GIxrKdN6s
	M6icUVDUyS91PYI5g2qWgw2tzo9F1Gqi+gs2CwiaKfvG4nFCHnH/j3Dp8OlzM3HA7336nl
	pw2bzcWoNIrO0waypqqvWjGc9jFH7lw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756957924; a=rsa-sha256;
	cv=none;
	b=jcSuwVUMS9/3tbDNPz2e58ZsCGwKkparKt/58Mebr1jU3XawulZhAIxL28mrV2Rso6VS+7
	Ag9jmT9Domoxj3uNVkT1P29ZtSsTLHRtdn4fuN/PL27Nu72a0GlIiC6T7viv00LygVh09X
	lcV8+0/C4Jgq9va/PnRytYzD1kRtnc4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VbckYjIH;
	spf=pass (imf24.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDF7543A97;
	Thu,  4 Sep 2025 03:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13EEC4CEF0;
	Thu,  4 Sep 2025 03:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756957922;
	bh=Mq4Kc9uMoIrJADgD3/HVomvbYH3TWWO8E7JKatF4Z2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VbckYjIHgshtdKT9gVoBz9foeJDHDPTsHZpx7aFB7pMnysbfkwoOky6VDUeT2IxIf
	 LcdKdW01cW+oSxbgcGuAnIwXWKyO+q/K3OQ8GPdHjH8sumGc9LYeDOVaHg5ON3NdDF
	 ihonL0iDBEdk5z1IU4hYm3QAfNmUJ/8QGK9BjftJx2aHM0D83ve/WdOhBGaKa0LAep
	 oq4Isj5gSgsWYL1iaPo0mNcBCJkVXWyJrGdaISZZEsnERJ5ZzJRE0M1ZJ7K0BrBYNg
	 gtBhD0M/bxLJsHpvnKE7yMdmufchRPu4X5jMjw++w94uMBHPjiX+d9juBNvrQWsq3a
	 jnkFGEBD3JHqg==
Date: Wed, 3 Sep 2025 20:52:02 -0700
From: Kees Cook <kees@kernel.org>
To: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.f, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [RFC RESEND v3] binfmt_elf: preserve original ELF e_flags for
 core dumps
Message-ID: <202509032051.BF7FC654F@keescook>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
 <20250901135350.619485-1-svetlana.parfenova@syntacore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901135350.619485-1-svetlana.parfenova@syntacore.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 551A6180003
X-Stat-Signature: fycu9dj1br49hsmun6ndoqgmqwu5qx7j
X-Rspam-User: 
X-HE-Tag: 1756957924-968142
X-HE-Meta: U2FsdGVkX19MQ8OuTZ7ei6kAQQS/y1GA4ueBWA4evbDhuWctE8hkPvVSYQHkeTu1LcjkR2AEt75lUkH5dqXr8cGiVeLnDQRojMeKRamBLSUolefMZyRpTPCHTJAlJ/X9Aldv3k7wKHPZprMZOArA/7JeaS6KtTUbbuQk7YQvNxZfNZ/oNSaQi5KjANv5ESxfNCJv0qs5A3I3AnWdAJ9esqdcxBXcEfMeDQTyd7GaccyGOu45OvgExXpcA1GWX8MGUCjYRvHzvvyRw30TEwdZm9ci+94ZfQKo9Kl+HMAw/nS87fypprNo+QH8NkdmUP+r3/BWNL4RcnJxoVLu14n+4QW0xX4yBSf012XadZ6n2f1k27dwq8l0FqyMSNq8Dn2dGPF8OoNnL313S771pSSCZZBj1Uanki/TEvmReWDTWt7SRMSltv98v5roUDNNhVrfgB62/Fypgj4blW/teA4r+mVis/Pg8nLRhNR+ZO18w8r6iZnBVTs5a8Fl5S1wWwcjB88Dyh8FaISAG/c22aYuNAZi7BZR4oUyEJHBcF+zoJTT0EEChmP00tt2SxMoTGgb9htq0pPUsXVuFOozjUuFKjPIh6QbjMJMyIo/vBdHHwoozXJjQwvyBoOzvaLZ2vYLfvnWYiKuPb+kXNgwj4PKBi1BR0xZrYD0GEP81O+2E/JXrY3/3G32+E7cxbOPWisOAsQlGRQwKnHZ9lQNHWvdQ2Hkrfdm/CYIBW12bDfPy59Olq3kw0oxvJpSCAyWLOAem8qUZh4xvgPVJAlV/PQ/k83UxFVkLUAhBZKNbHCJuTO1A40x/4Avk0AN8sZYg/0Gvf4ixtsTKLps0oNKPkHtXXl+KCu6NmOk3tZ567anFac03c3V1M1EpFDeFwk8c2wXd59I2RSxpHf+jEMqlNiXum9GVyjjkyCJOuq/+t+PkKFnXPGk/Evgg9OOodNP5OJ8dxqFxrrg0UDYS8JRRPB
 g9YaeAAj
 V2/uvWGO841cVMvpaXrsBT+21FKBhWP4R2DZ0m8nMrcNpqJTLSdQC4pV+eh+seWShf8x3xYKR2prmci5conaOL3Skakvz+c9lWc6b6yiBXw7BGrFi9oOgTQka0gBWmqqxXjiVdv14M5Hg/fwjel6it9cHT0vlE/nD12Fe98WxKcMouTZgANpk6dl8VGy+lMTmx/K5lt4uwrgFQILfEsSP/OAuaDTw80EgckUWbn10VRNVO7ZOEGdTEfbnE1sVV0IpCDYOZHnRN+t5Syox8okNyLQNsGOVs6HHT2xYkN6wlmWcP/c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 08:53:50PM +0700, Svetlana Parfenova wrote:
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index a4b233a0659e..1bef00208bdd 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -224,6 +224,7 @@ config RISCV
>  	select VDSO_GETRANDOM if HAVE_GENERIC_VDSO
>  	select USER_STACKTRACE_SUPPORT
>  	select ZONE_DMA32 if 64BIT
> +	select ARCH_HAS_ELF_CORE_EFLAGS
>  
>  config RUSTC_SUPPORTS_RISCV

I'll take this patch and alphabetize the above select into the right
place. Everything else looks great. Thank you!

-Kees

-- 
Kees Cook

