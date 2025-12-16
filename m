Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C09CD5C0D1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E9AE6B0005; Tue, 16 Dec 2025 03:15:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895A16B0098; Tue, 16 Dec 2025 03:15:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769A36B00AA; Tue, 16 Dec 2025 03:15:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6153A6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:15:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D8B1135EAD
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:15:42 +0000 (UTC)
X-FDA: 84224625324.13.A0639B8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id AD8031A0003
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:15:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HrHFjfx8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RKRw3307;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1iKonsRc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XuuYJdpK;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQwyudFiYLw9a9VovEqJ9I783SOffROchg5HSdsCFE0=;
	b=4W83ec0/IHC51e3hSy7xa90D9o/M/NQ2SGcb6AM7PAgt29UhxMKzG9ISQ9gvsbxmWVyQoz
	gAxT0Obt8gT3Q53m3x2uvtySUB80RnCDMWKVGniI1bEjvUhCHjb6hKy2iKg22GF5/sYjcj
	NYwGmvMPlkX585OmiECPsaPqCq9f6Xo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HrHFjfx8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RKRw3307;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1iKonsRc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XuuYJdpK;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872940; a=rsa-sha256;
	cv=none;
	b=wR3HgXvsKOzddICQn4BQKNI/WA4Nj16k+p0oFMC5hi0Z2+FacOFHBojVlXdyr5C/ElLgKt
	KB6kNOcQC2LaORt+SpR1pBn858vljlH76oOIsPz12fEADHaZqEW9cWhD5bUJgxTPOejeqB
	v/O2/HuL0qjVCOyQGOLQBeo6mUklEB8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5800A33691;
	Tue, 16 Dec 2025 08:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765872937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OQwyudFiYLw9a9VovEqJ9I783SOffROchg5HSdsCFE0=;
	b=HrHFjfx8R1cIB/gvYTU71BiMzUSEivJxQphHzywX9PvYjtoUT/fYTd6xp4o8FVTuPX1fAM
	r24fcXDqEPGqAxcSYzncotwxUJ0W9WxWm0QNGhosw+Y669zqrLKW035WRniW1OezGeqmpq
	7snkfO8WjvVwXnNr0Aac8+NFG9uL8q0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765872937;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OQwyudFiYLw9a9VovEqJ9I783SOffROchg5HSdsCFE0=;
	b=RKRw3307JYGZ/apkRWJ1/6aTsLexDKWXeKGWtqOy72hpBGNxygy4g++7nViT+BGnFUG4UZ
	UaC6Nm5ScNswIwBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765872936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OQwyudFiYLw9a9VovEqJ9I783SOffROchg5HSdsCFE0=;
	b=1iKonsRczx3XtDGyhOr9vyl8IgQmMqkt0To8Kwj6C9eNZFybb/Beqz/ohTGZZ7x8c5HnNi
	A1DQfbAVXASkQXXygy9QxNuyS+XlkZ0bt1r4AZ40VFuQT04toZ71XpYODfnJRaBAAnTYIK
	jDnsk/maBWoyQD/Jz4Y3LNOQ50ja+3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765872936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OQwyudFiYLw9a9VovEqJ9I783SOffROchg5HSdsCFE0=;
	b=XuuYJdpKR7p7r3c1LDxO0ui4AzXL6Hze4yx4Ijzja9G/Tnhma1yy34PwbWR6hJdk4Td/ww
	Gg6aaHVwBrfn5vAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4BB093EA63;
	Tue, 16 Dec 2025 08:15:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BaqCEigVQWl3dgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Dec 2025 08:15:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E54E2A09E1; Tue, 16 Dec 2025 09:15:35 +0100 (CET)
Date: Tue, 16 Dec 2025 09:15:35 +0100
From: Jan Kara <jack@suse.cz>
To: Joel Granados <joel.granados@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	John Ogness <john.ogness@linutronix.de>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sysctl: Remove unused ctl_table forward declarations
Message-ID: <gkuyseuq2v4y2dl5niufwx2egwrk5a6nhrn7k5vspaorfz5jny@q5mz763kegl5>
References: <20251215-jag-sysctl_fw_decl-v1-1-2a9af78448f8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215-jag-sysctl_fw_decl-v1-1-2a9af78448f8@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: ubppzreqyf15bd3k53i6chq7g89mjfbo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD8031A0003
X-HE-Tag: 1765872939-529077
X-HE-Meta: U2FsdGVkX188W2psoXydPd2U94FV568uRMCUOtz2hyr2nCJHodbnVVvEqrIg3sDkdg0u6cBKKr2qws911hRZoKHyhIWA0bIoBRTMPhJjCj2h5jNj44u4WONTV/89Yyu90KFpBOUNkiXtgiM2/Lsa8UT2tZfjEHbpqE65YVeFFxsijtUfCqCzXsZPEjwdej6TlJ6DCIeyx011cRNSC6NqufwiBkUcw7td2gd3jeor9gBAWtJT68C6kWpH2CK09IhFGFHJsS1NwKc1TATmzlx3/BK4OioA/6QwyjZyIwoG/7YwIo8HXBy2c+w6mttouIZkNyVpLN7evuAKhq3Rhp2VKo4cEjy7mQD1q8BK6no5g94in+Oh7HpHDmV/Q9J1pqaHU4qxkoyRQaDsaNbC7/i4zCelW4RrXCcNS6rsEepqetOdwncVpH9PE+riZyydgmrcu8OAtYf8AzavhPB8cy5UjhHRbR+obQ3Q5/Zc4pKFk/bDjOIWG7NvhwyFw3Pru1lVO66zOKdDaaHImvSB70dA0dgHPLMLQnxt7ld8tlnAGSJ/uE1AZ58OD254AneEM+Zuuo4WhVh5i9kPMa4IXlLuxdnqtox4nK8De94KO7QMgNvPKqcKJBIBpD+zQt6z9qx6k9ngBa7jRV9U1snzoY8ER4f3zMw922j5Kl7uW4WfNo8c9j0PMXqmuBIhYlIsMMqR/GPAYmPGrxLyT7qDWykk/4t/wOrRjvLtjd7WRzs+C0mokUMAtSffn/D27pacfOACvaHtmCKU08jhcQLA8HBh43wK0ATUv9T7TGLiMcSYKIMZNz2+x/b6NNrKrDdw6OBHmJBWn9MLlRVU6tHXVlsy+XEZFgMckCdNGusFIfp8liJ6WIUP2UmLakZQk4Isq7QQmTfJV9/pjiuwahbxFhdRdorFHXVmIwZVxvWI8Ekegu8o13nYnvVssHqPM1HT4Am5g1DsiMpRKUboy+B/gHt
 iIzaQJSQ
 USHwe9SRFmQOHP2h1N68fyG5o58ODEw98HINhrSzvg2Sx7worzM0qf0DKqDLmaecqJG+A3n3I5xvzz8iK2PbZ8SDfw9ElIPdf5Zq71Tq+KQBH1DQAcO8nxZG+oicvrI6Ndc+FWBNLohvwppjojE885zojdFPkrYidh621Oe5RNsw211H6vFhbFxsipFM5doxp6YtvK48I1b3oepqzP78q3D6cjX4HpkbE9ZiMwVb4IrmNJzooeUW9NfkbB7Efe36Bf4VRa4BVMyrgwUE+zMJ8FkrjGmSJuwIict+T+cmoPlSFsmZLv0+PwQv5L2xfW5vwPnbgyafdvGASih1EAC+O5PLu2niwl4maI/sVTxVMWlHU9rm+jr4tb1qjzLaa28tCgWMsPoyLoiUyRbaxvOrM/gejFB8QT9wM9NvvOMKO9+iennxSMRGZDyGLwk9rPQ7k80G6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 15-12-25 16:25:19, Joel Granados wrote:
> Remove superfluous forward declarations of ctl_table from header files
> where they are no longer needed. These declarations were left behind
> after sysctl code refactoring and cleanup.
> 
> Signed-off-by: Joel Granados <joel.granados@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Apologies for such a big To: list. My idea is for this to go into
> mainline through sysctl; get back to me if you prefer otherwise. On the
> off chance that this has a V2, let me know if you want to be removed
> from the To and I'll make that happen
> ---
>  include/linux/fs.h      | 1 -
>  include/linux/hugetlb.h | 2 --
>  include/linux/printk.h  | 1 -
>  include/net/ax25.h      | 2 --
>  4 files changed, 6 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 04ceeca12a0d5caadb68643bf68b7a78e17c08d4..77f6302fdced1ef7e61ec1b35bed77c77b294124 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3487,7 +3487,6 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
>  ssize_t simple_attr_write_signed(struct file *file, const char __user *buf,
>  				 size_t len, loff_t *ppos);
>  
> -struct ctl_table;
>  int __init list_bdev_fs_names(char *buf, size_t size);
>  
>  #define __FMODE_EXEC		((__force int) FMODE_EXEC)
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 019a1c5281e4e6e04a9207dff7f7aa58c9669a80..18d1c4ecc4f948b179679b8fcc7870f3d466a4d9 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -16,8 +16,6 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/nodemask.h>
>  
> -struct ctl_table;
> -struct user_struct;
>  struct mmu_gather;
>  struct node;
>  
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index 45c663124c9bd3b294031d839f1253f410313faa..63d516c873b4c412eead6ee4eb9f90a5c28f630c 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -78,7 +78,6 @@ extern void console_verbose(void);
>  /* strlen("ratelimit") + 1 */
>  #define DEVKMSG_STR_MAX_SIZE 10
>  extern char devkmsg_log_str[DEVKMSG_STR_MAX_SIZE];
> -struct ctl_table;
>  
>  extern int suppress_printk;
>  
> diff --git a/include/net/ax25.h b/include/net/ax25.h
> index a7bba42dde153a2aeaf010a7ef8b48d39d15a835..beec9712e9c71d4be90acb6fc7113022527bc1ab 100644
> --- a/include/net/ax25.h
> +++ b/include/net/ax25.h
> @@ -215,8 +215,6 @@ typedef struct {
>  	unsigned short		slave_timeout;		/* when? */
>  } ax25_dama_info;
>  
> -struct ctl_table;
> -
>  typedef struct ax25_dev {
>  	struct list_head	list;
>  
> 
> ---
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> change-id: 20251215-jag-sysctl_fw_decl-58c718715c8c
> 
> Best regards,
> -- 
> Joel Granados <joel.granados@kernel.org>
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

