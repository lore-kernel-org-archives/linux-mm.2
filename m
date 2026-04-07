Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77908EDB7FD
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 11:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83106B0089; Tue,  7 Apr 2026 07:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5ABC6B008A; Tue,  7 Apr 2026 07:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70896B008C; Tue,  7 Apr 2026 07:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B58936B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:01:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E8D6140776
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:01:17 +0000 (UTC)
X-FDA: 84631468194.16.90B9AAA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id A9B4E40010
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:01:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BVgp+a2h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UKfZtvIs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qA8IdJKI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LysQ9c8V;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775559675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oXLKBYtaCCSbMWBda+nxyI4Nn65hTz2TbyxjesyuSE=;
	b=TFNqVYqvBsb8kDccHBQ8RUcvd6MVmFgFMFNM0szYECuQodJDmlAABA2stKp6TTXIXt5swF
	60x1Ap9xBfq0YRgr99UdzCCjH0nJAO1Hn5vQBiVTnWg6B9rttqUsigsPvJhN5EZOb0vddE
	BfedX513Ld+e32wYnoEbfcIqfBvoPzs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BVgp+a2h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UKfZtvIs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qA8IdJKI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LysQ9c8V;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775559675; a=rsa-sha256;
	cv=none;
	b=nqAh37D7ZHBFPvbvnJpdHSw0L2K1aajC4qyaNqSidieTb77tkTuRNcY9/uZnQH7HPHDvXU
	GB0A7XMUlE1ZyEavxHnmE8AKQ5Dt+flG4W69HChc9tVIwsuTJkGXY2zPQB18UtlXML0S0o
	GyTVUT0/eZV2pcg1cIaLMHz5KDzBQb8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 99B485BD36;
	Tue,  7 Apr 2026 11:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775559671; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6oXLKBYtaCCSbMWBda+nxyI4Nn65hTz2TbyxjesyuSE=;
	b=BVgp+a2hMv3tETDV+rR9kch9LY661rG6gG/nGImoQc+GuC4d6flbkjiWXxH7wnRTm0U20M
	5LtMnlL59Hb8Wl9q8CRbWSxrIMQBwrNawXdRfkjhDxV2jYade8lAzh3Eju4D5FK4La91Uv
	NImxRNZBi+0n638H/qDh7MoW0WCYKXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775559671;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6oXLKBYtaCCSbMWBda+nxyI4Nn65hTz2TbyxjesyuSE=;
	b=UKfZtvIsiO3FB8fMLaXkTmekdqfggL0VR9IAJ/K+MzJUVIotdHA9OZ534503T9FcjZvVxE
	h+2TNRuAWa2JUhDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775559666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6oXLKBYtaCCSbMWBda+nxyI4Nn65hTz2TbyxjesyuSE=;
	b=qA8IdJKIP1IEjzpOJmvlCMYX7wCu03qUGsEnRfmc9u/FSNyytXOsKwNsEtWuOatglxRwQm
	GV8DwwIzVJPGVwCZ1xBWQXl1iTbIC37Lgm2dMpr84X//XzVd/U3OHZYICbEYyLGmHS5SW7
	xW6/YM8ymwTVspOG5R2MXu5IQ+2M4hw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775559666;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6oXLKBYtaCCSbMWBda+nxyI4Nn65hTz2TbyxjesyuSE=;
	b=LysQ9c8VZNrysxsUFJYO5ot3gJQ68lu1GmpT4jYOLonIGJQirvH2/VDKWv6O7tu2kf2kvy
	MK4Iz8A2fe5ul8BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A6BE4A0B0;
	Tue,  7 Apr 2026 11:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b1fDIfLj1Gm3OgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 07 Apr 2026 11:01:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4BCD4A0A81; Tue,  7 Apr 2026 13:01:02 +0200 (CEST)
Date: Tue, 7 Apr 2026 13:01:02 +0200
From: Jan Kara <jack@suse.cz>
To: Anand Moon <linux.amoon@gmail.com>
Cc: David Howells <dhowells@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Peter Zijlstra <peterz@infradead.org>, Nathan Chancellor <nathan@kernel.org>, 
	Kees Cook <kees@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, Douglas Anderson <dianders@chromium.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, "open list:CERTIFICATE HANDLING" <keyrings@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Subject: Re: [PATCH v1] treewide: Fix indentation and whitespace in Kconfig
 files
Message-ID: <dssmmmam4yt222rtsk7nmrnwf46ocv66kujo2k6vihgqxeunyz@zwg2j5pxre7h>
References: <20260407053945.14116-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407053945.14116-1-linux.amoon@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A9B4E40010
X-Stat-Signature: ghhuxdqab1b4ybumn3gpes79pmh3zqw7
X-Rspamd-Server: rspam06
X-HE-Tag: 1775559674-939111
X-HE-Meta: U2FsdGVkX1/HDiJs+zDjZtdHscF2xLjrT4regubG9h/W1XWWD62Rr3AEZrYU9AgJrq/+2ItGY5SwCJHBaTLWTrO5yJqyiU4qIsAnHVleoujlEWL8r+SWATTm5LvsQKQKWhTZdj8iKvBjDjXwbUk8Y/PoU4L1RkgwYmoOO7EV7tghAeowFw36Gbtm/VfA0ld7Ohv17SMH68JRqLyV50ijnXhho4d5LmgZwJr0JC6iaUoykKpIHHb7ONBdn1JJ8ZFnQGY1C8LHI+pYdudAT2cV+lxskvMg2lsrJhcPNRzdLcOt4tQWe/BNqaZWJ5eXGls20Yxyzq716JfUJRBoRYqit8NbpsRIovpsWlRmvn1ntMdaZO/Pa9ZNh3UkSWvuJsnMhk7c48WYpvQBrxQ5zoNxu2j+Tdjx2yNEXfwbLUnOCkVaW6SbyJV48NBmZGlC2IIE1xiN2QdmSPYgKdabbb/XPbePKgZr7iT3ne8ynuUFsIK2HH+REln0Rv4yvnTkStIKRb7BcS9SbgwRrKve0cf/SSGfkSekvy1wSmbaRbfHE/3Li1kAdHvTfDPtBOMZfErLGRCAR6ky/d4BhTTwtRWP/ONnbgyJWYakSPZQLgE7t4hFgiK+PN8KibqRhZHeQhFh1WB/NEgOqPNlMVB7F8RIvrY9wm9uVamBqbYKuEYR5AM+ly77mkmTd4fHazzAmrg304+02OjHx/hGaIHHcSW2hVVLzaVbW4PWJuuayZK8WBplZOFceXzwthemxu/nxTpGsuec5tSpSsCPmz+qqOOahwiZuhr3qyc4Y6XT/z5uHmA33nJh0tG4xEb60brJYnUC4m6f80Bnqhkp0qSKo9Akbnx+Ps4gdjgsIHLMzbFqIeLlKJLQm3wvYRe5C19nYQdx3p2GfUzSDlCcXfT4XiOOsdEDZHf0y5w39yACq6vG5z8tHriWwAWRcMfRXdjodo+t3SPYwlIsNUAGvOrhlzh
 QNvMYShm
 FS0b8fQ60OoeqfywWfVD+T5ygOj8fLV56M0XlnmUaihxzkxSX9qGhiElD4ZOdCkyxehC4IaIREtatb2JChubwpMMqK2fRY5Sqkw1TAAjv4JPjmwMGdrlxWNgXeSl8GXAwIwNDKC7J5k62gF0/dAG15Cq3yghVK2cvpLg4337r854/GwchPTWoZqc3JVXBQSmamZt+KFSs+gvLaT8s0sJwu0zC7VuajhfhlCY/bc6q1ZYsXyar8jLEWURBG97YDO8+3GM7JyJHAX3jxtQCFy9uD3X3XDrI+cYNvRXwORI7yCN0Rt3CpqeSjJYrfUhg79st4rjrBpEbEEHuOPM2MfUXF/UNiryklFJ/1uFPWwjsGjIrxo1+2PqeTRqu4efdWAGjQeD/XIlAgNIqnHPwKZzFZ8qvRJnVAoQTd2gLLaKK1DnPmUPcd/hAw2Iqf450IQKB80aolgo16XOStcw/OCC2pJGXI7BquxAXovJxK4yZuLpNBhk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 07-04-26 11:09:34, Anand Moon wrote:
> Clean up inconsistent indentation (mixing tabs and spaces) and remove
> extraneous whitespace in several Kconfig files across the tree.
> This is a purely cosmetic change to improve readability.
> 
> Adjust indentation from spaces to tab (+optional two spaces) as in
> coding style with command like:
> 
> $ sed -e 's/^        /\t/' -i */Kconfig
> 
> Signed-off-by: Anand Moon <linux.amoon@gmail.com>

For the fs bits, feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  certs/Kconfig | 16 ++++++++--------
>  fs/Kconfig    |  6 +++---
>  init/Kconfig  | 24 ++++++++++++------------
>  lib/Kconfig   |  2 +-
>  mm/Kconfig    |  4 ++--
>  5 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/certs/Kconfig b/certs/Kconfig
> index 8e39a80c7abe5..9d2bf7fb5b9e4 100644
> --- a/certs/Kconfig
> +++ b/certs/Kconfig
> @@ -6,14 +6,14 @@ config MODULE_SIG_KEY
>  	default "certs/signing_key.pem"
>  	depends on MODULE_SIG || (IMA_APPRAISE_MODSIG && MODULES)
>  	help
> -         Provide the file name of a private key/certificate in PEM format,
> -         or a PKCS#11 URI according to RFC7512. The file should contain, or
> -         the URI should identify, both the certificate and its corresponding
> -         private key.
> -
> -         If this option is unchanged from its default "certs/signing_key.pem",
> -         then the kernel will automatically generate the private key and
> -         certificate as described in Documentation/admin-guide/module-signing.rst
> +	 Provide the file name of a private key/certificate in PEM format,
> +	 or a PKCS#11 URI according to RFC7512. The file should contain, or
> +	 the URI should identify, both the certificate and its corresponding
> +	 private key.
> +
> +	 If this option is unchanged from its default "certs/signing_key.pem",
> +	 then the kernel will automatically generate the private key and
> +	 certificate as described in Documentation/admin-guide/module-signing.rst
>  
>  choice
>  	prompt "Type of module signing key to be generated"
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 0bfdaecaa8775..74110311968aa 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -78,7 +78,7 @@ config FS_DAX
>  	  --map=mem:
>  	  https://docs.pmem.io/ndctl-user-guide/ndctl-man-pages/ndctl-create-namespace
>  
> -          For ndctl to work CONFIG_DEV_DAX needs to be enabled as well. For most
> +	  For ndctl to work CONFIG_DEV_DAX needs to be enabled as well. For most
>  	  file systems DAX support needs to be manually enabled globally or
>  	  per-inode using a mount option as well.  See the file documentation in
>  	  Documentation/filesystems/dax.rst for details.
> @@ -116,8 +116,8 @@ config FILE_LOCKING
>  	default y
>  	help
>  	  This option enables standard file locking support, required
> -          for filesystems like NFS and for the flock() system
> -          call. Disabling this option saves about 11k.
> +	  for filesystems like NFS and for the flock() system
> +	  call. Disabling this option saves about 11k.
>  
>  source "fs/crypto/Kconfig"
>  
> diff --git a/init/Kconfig b/init/Kconfig
> index 7484cd703bc1a..6fea1453c2941 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1036,14 +1036,14 @@ config PAGE_COUNTER
>  	bool
>  
>  config CGROUP_FAVOR_DYNMODS
> -        bool "Favor dynamic modification latency reduction by default"
> -        help
> -          This option enables the "favordynmods" mount option by default
> -          which reduces the latencies of dynamic cgroup modifications such
> -          as task migrations and controller on/offs at the cost of making
> -          hot path operations such as forks and exits more expensive.
> +	bool "Favor dynamic modification latency reduction by default"
> +	help
> +	  This option enables the "favordynmods" mount option by default
> +	  which reduces the latencies of dynamic cgroup modifications such
> +	  as task migrations and controller on/offs at the cost of making
> +	  hot path operations such as forks and exits more expensive.
>  
> -          Say N if unsure.
> +	  Say N if unsure.
>  
>  config MEMCG
>  	bool "Memory controller"
> @@ -1125,7 +1125,7 @@ config GROUP_SCHED_WEIGHT
>  	def_bool n
>  
>  config GROUP_SCHED_BANDWIDTH
> -        def_bool n
> +	def_bool n
>  
>  config FAIR_GROUP_SCHED
>  	bool "Group scheduling for SCHED_OTHER"
> @@ -1625,10 +1625,10 @@ config LD_ORPHAN_WARN
>  	depends on $(ld-option,--orphan-handling=error)
>  
>  config LD_ORPHAN_WARN_LEVEL
> -        string
> -        depends on LD_ORPHAN_WARN
> -        default "error" if WERROR
> -        default "warn"
> +	string
> +	depends on LD_ORPHAN_WARN
> +	default "error" if WERROR
> +	default "warn"
>  
>  config SYSCTL
>  	bool
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 0f2fb96106476..4b0026954a370 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -589,7 +589,7 @@ config OBJAGG
>  config LWQ_TEST
>  	bool "Boot-time test for lwq queuing"
>  	help
> -          Run boot-time test of light-weight queuing.
> +	  Run boot-time test of light-weight queuing.
>  
>  endmenu
>  
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ebd8ea353687e..10a4ce4247fa1 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1304,7 +1304,7 @@ config ARCH_HAS_PTE_SPECIAL
>  	bool
>  
>  config MAPPING_DIRTY_HELPERS
> -        bool
> +	bool
>  
>  config KMAP_LOCAL
>  	bool
> @@ -1435,7 +1435,7 @@ config ARCH_HAS_USER_SHADOW_STACK
>  	bool
>  	help
>  	  The architecture has hardware support for userspace shadow call
> -          stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
> +	  stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>  
>  config HAVE_ARCH_TLB_REMOVE_TABLE
>  	def_bool n
> 
> base-commit: bfe62a454542cfad3379f6ef5680b125f41e20f4
> -- 
> 2.50.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

