Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 638FE10F6FDC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 16:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1846B0005; Wed,  1 Apr 2026 12:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71CB6B0088; Wed,  1 Apr 2026 12:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9882E6B0089; Wed,  1 Apr 2026 12:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C26A6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:31:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15C73C76BD
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:31:08 +0000 (UTC)
X-FDA: 84610526616.18.C81BDA5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 90E5E1A0018
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:31:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kdKwJuy0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/UTQMI83";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TYxNHsl5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=50xnfiq7;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775061066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrz8RGNPnc70Z3dHVGCi2lu4rxIGK4ux7WnKlXn2C/g=;
	b=4Mk/Ooevrn6f70mOQpFIk+Q6AyZhquBsP/ZElMvUxYkDF6ONgUe/rPl/PfH3JGx9sEGXT5
	5SdEyLRIYdeJgiARS2k0DBu1AYbeYkOfMx+l4k1kxMEm4L1n4QMU4yM3alaWBeMcHWI7FV
	Qpe3G9GQEPWFm8MhY7XlkBw82J+8oOk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kdKwJuy0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/UTQMI83";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TYxNHsl5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=50xnfiq7;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775061066; a=rsa-sha256;
	cv=none;
	b=uZGY0P+8z1ZUTbXOs4RwQslqZaJpzWAnj77GUZT8Rg3iRcOW3m417AySrzS2F45VdljMnx
	KXV1uyMlxJGbPHKeJE4Uofdv/cQHY4SdutNQfAnD+GbjTLUsLEvVpjs5z+VFgybPkCrliK
	ZSoO5SKE8nt2vJKpzM6h0ELWpkHw13o=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DA17B4D305;
	Wed,  1 Apr 2026 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775061064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mrz8RGNPnc70Z3dHVGCi2lu4rxIGK4ux7WnKlXn2C/g=;
	b=kdKwJuy0UBpqF0REXKiYrycjhFEDj88ArmAFMKWx0aigay4qXABcXiYWhV5Vs3fyV++4PX
	1KygErYcy9e0b4eMNoSia9Wegf1KXN8B+W5ka2j6vpJ1pAffr5GjlSHh4Iq1aHYc8Ta7FB
	hc7Wl6yixXay6+DQId2KIctOJ1tqaj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775061064;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mrz8RGNPnc70Z3dHVGCi2lu4rxIGK4ux7WnKlXn2C/g=;
	b=/UTQMI83VujbE9Aqz4uiv9sx8QQehwtEfRAair6N+2q5PwEAFfXHkEj+V30ZZCPds/a/mW
	1niisYnxaDvjqpDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775061063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mrz8RGNPnc70Z3dHVGCi2lu4rxIGK4ux7WnKlXn2C/g=;
	b=TYxNHsl5JoNtIy1qm/6aDNv3T/YMZXjSTktIbhtRO9SF8JDwxqOn7CRQPh9RWMSGjbVhiT
	sHFrFu6FQjTPc1oZBhc3nWCQ4D3H0HE4CTg772rW8NNldwxHeg8MX8g9x4Th+5a1W30M9y
	SelhCHMSwcm3hqTI2hjqxtt3gWPLiQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775061063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mrz8RGNPnc70Z3dHVGCi2lu4rxIGK4ux7WnKlXn2C/g=;
	b=50xnfiq7NYzZZ8FIF0cDtpb6iTdu2KYT8uCqtvwHuuRr86pBNcYsBPsAsi1pOqwAmZZYD6
	waiW9wJwtmFjSHAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D18C04A0B0;
	Wed,  1 Apr 2026 16:31:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CkgiM0dIzWksAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Apr 2026 16:31:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 819C7A0B39; Wed,  1 Apr 2026 18:30:55 +0200 (CEST)
Date: Wed, 1 Apr 2026 18:30:55 +0200
From: Jan Kara <jack@suse.cz>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] exec: use strnlen() in __set_task_comm
Message-ID: <wesnxxbjdbzstv2weyuyhcmorz3nuib6hz6msfxmrdlbuyow7x@e7rodhd7s7zm>
References: <20260401152039.724811-3-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401152039.724811-3-thorsten.blum@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90E5E1A0018
X-Stat-Signature: k13miiwyra3zuqod7d1fmjf3pkpky9wz
X-Rspam-User: 
X-HE-Tag: 1775061065-490743
X-HE-Meta: U2FsdGVkX18pAedJvNl1hIn1MXXMiU947BKic+NsYX9ZxgBWRaebUdh/MOtqE7aDaF7QJsr6qXr6wGgEGSzuBQvDJSX8TceIRvWmSjAQsDlIgbqwLabIDB6ItZ5BLDtkBvnU9pt4/FEQgbAqPumx0xTiyOruJNcxAU3r1J+/1x02qI+lvecX358d22ht0xL5y7B1pdHgs430BQ+kq8HghVI4JedOpI4fpT/Ir0OL+mL2eoJR0HWWl/YfDy9k6GP4TOOpTvSulCMe4l5k372kZwWahGacAWY67iywKNc46+x6CQJGeHIHd6W7mBpWaVOs5+YU2KWHo5jMwzN3sguXClhlW7j4oYtlMT3rvrY+d+CfNBUqvJONOFi4sd6nFoWAZJ5YKyuJtXNgiMCNimqgHpneK04d/3q7mVMEFxNvSbUTE348zR25lTdZ3IXk4KqLht+rdYfR0xlYY8xjU7M1VC0D/z9gMk5zV7v3liLVI/P8NzZ/70BMRk8JgQGIfvjbZJ9NGJEQ02Cxgz4UDWLkcVvoJbg+DF6rnLizF+ltjSdh5dA+lOy5wgd+XMJkEYN7BVQ/sr+MVXpQjeox3fSXE4BRb0lPg+2X7VV7GedOG28f2UJvq5vNpEStiicqnzuPU5TwV0AheJnWEUWtwFM9LxLrl+Ft58P5IAMHNmo2j+rY+UF7dtOSltvf9mSYEYXTDXtlP0BR2STfez+gvy59fA26YPUI/yyvkNhd5BORRCQjI6fOvWuQMD8Z1cMyDE5zzKQpS/kP0NoQJE9XgB6290h8aNiP7bb4J58wJDdyNRRhvWb10mZJYkCeCery4E7wWAL09P1u/PK/ESPRoqGZSdLTdxUtbfazJiw41nigp3yCBQxspZaTNyu8y+x2GNttRQESngZl9ImlhhI4VWcmgg/edvKa6+u3MJiApBCdSQJRfkKHNs3v6X5Ix12lD1PK0lxVe5NNVhY+ph7yy/2
 QOjgRn6E
 H5X/b9Wpkzzc69GWnjllhKxgtRTrdhdQYJ8kjzDVet5nTIqyniR4poPBDO1JakMxqmSc9Yqe6cvzkKZ/lDIJsSlCRg1w+waSUrU4ax8ujoNaIYHeX/tEJ0dz/DNoZ3aD7WOmpsxwKxigamimZLOuDjn9vOKKb86YPMxIuTE3WwaY1wenDbeueF9nM/D9iIBZcacl9Pja8gn2ANiuRwJOa9byo8mnZGhR/K7VOmaaVmwSr7GFsu6Lyeovo9vsMkIIldcn+3ZEFjCkGfJw4e4SfBuk3auCArCuDtwov22Pk1Nzx2+Gnx4xDvim6m4WsmDAlCHK8LTTgll6+Nc5KbyYUH3m58RxXgm+arMzA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 01-04-26 17:20:40, Thorsten Blum wrote:
> Use strnlen() to limit source string scanning to 'TASK_COMM_LEN - 1'
> bytes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/exec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 9ea3a775d51e..ba12b4c466f6 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1074,7 +1074,7 @@ static int unshare_sighand(struct task_struct *me)
>   */
>  void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
>  {
> -	size_t len = min(strlen(buf), sizeof(tsk->comm) - 1);
> +	size_t len = strnlen(buf, sizeof(tsk->comm) - 1);
>  
>  	trace_task_rename(tsk, buf);
>  	memcpy(tsk->comm, buf, len);
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

