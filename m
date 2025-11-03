Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E69F8CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C30C8E0038; Mon,  3 Nov 2025 03:06:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372A08E002A; Mon,  3 Nov 2025 03:06:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262328E0038; Mon,  3 Nov 2025 03:06:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 102968E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:06:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0380E12BE64
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:06:41 +0000 (UTC)
X-FDA: 84068564244.28.4377CFC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id BD63C4000F
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:06:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zi8CXFTc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TKVA5B8h;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=018BWjI4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OUQNZkcn;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762157200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCkJf14wqV0F4XHGtpv6IsvGx/JTM7DNUNTENvxVbxU=;
	b=6av4mdNstd8dEA1hZ5sdKOVG1mKHicS1DkYBgVS5IcIKNF4p6VI6ofgFLPiaAgpIsSHSdU
	OPV3ubOFFMRLQoWZV0VvsAjqyaC9IL2lhCxGy8sdy0UpZCqJkxBV+KhXPLaUdo1MHNSL+l
	1ZHz7Xuilru2vBSOLgKUKtEKa4H4OMA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zi8CXFTc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TKVA5B8h;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=018BWjI4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OUQNZkcn;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762157200; a=rsa-sha256;
	cv=none;
	b=PSmJw/UhXRcC99jyHcFTd0GvYbd4eNMedPxUv6rmFzyIiQLfmDFYhOGEdoUdHu0WOjFhKV
	ke4jdpxn1P4nDNyG3/b8BOoXbyr9duLJeDcSzEUAT54Ui6OKUBc2cfOdqVKRbzzqDbubLR
	g/bLBiv4pU96sQd4h0tVHvWtoMpC01w=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E9E9E218E8;
	Mon,  3 Nov 2025 08:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762157198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zCkJf14wqV0F4XHGtpv6IsvGx/JTM7DNUNTENvxVbxU=;
	b=zi8CXFTcQaBKBEpxv7jW3Umveo7VgqtbjbyACZo1GbTjQwPDcorm1dOoX2Fkzlq0Le8W7Z
	btudHizqz5EvwlqXOQ/UDkPeQrzjIWq1c/nwBIaBQ3RAWu7RZYky7dzQmT0mOXdF3LVAKS
	fboMrOzYBm+sRlW2IjQOuDoi3rtNtNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762157198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zCkJf14wqV0F4XHGtpv6IsvGx/JTM7DNUNTENvxVbxU=;
	b=TKVA5B8hPFYXxiy/uI/8Rk5SdCozQnbaYE7+LwVfmJ06p/Xb+Lcc3AAxwO6+v525r62EHA
	3xHAl02CyVW1tXAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762157197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zCkJf14wqV0F4XHGtpv6IsvGx/JTM7DNUNTENvxVbxU=;
	b=018BWjI4UciYupwdOCuccVBXRZ2XDz4ea6ZHTB/DxoByTkfFiQn9aVNlepUhZZZVL3TB3C
	hWx8qqKRjPqp/S72VAwSZxlLZF0Xp2V7sgAz3DYOkuw8nW7JorvnSi5rwKVh4mFeMylsPN
	X1E37pTBeIXIrj963W1YYXZBYaLdK5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762157197;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zCkJf14wqV0F4XHGtpv6IsvGx/JTM7DNUNTENvxVbxU=;
	b=OUQNZkcnZxVs3XQevIvUo8kEsC/6j+XzxjZ9NihmdZtp/sOAR2FXLvP18hvLA5VBsBmA4j
	gutiWwhxOU80b7DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA6F91364F;
	Mon,  3 Nov 2025 08:06:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3gNSNY1iCGnNWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Nov 2025 08:06:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 58F69A2A61; Mon,  3 Nov 2025 09:06:33 +0100 (CET)
Date: Mon, 3 Nov 2025 09:06:33 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 05/25] ext4: enable DIOREAD_NOLOCK by default for BS > PS
 as well
Message-ID: <q7podhkdz5bnjif6tm2ldwkdvzafwqc37u67eepajoreu4x2zx@3zypdbhvmouk>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-6-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-6-libaokun@huaweicloud.com>
X-Rspamd-Action: no action
X-Spamd-Bar: /
X-Stat-Signature: 5sqpqfj5mmfyprpy59wcasd76fu9eus9
X-Rspamd-Queue-Id: BD63C4000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1762157199-176532
X-HE-Meta: U2FsdGVkX19cOpVCrizo+L3+vSNq4x93B0vX/kKv7qUNTwM9Unrqrt0VKN00ZycLUTN1/SH+UmR5cNieq0svlURgmGAX0kTfVojBA++ucDZlxKTBbcrDOq7fKNZjAJwcmFy1dpqjzCjZuXazSNxPA2QoVgH49HF7IAdqzva1o06Q3r0sdlKnhbYVlJwrtHamlWZ5WoMQp5XNuh4f1/IfZBZwugXaP6PvVuxrm5gei4Vpv3Cwx+XcNHocooValHU0D1ZpGMqcSgSBd8JruBrX/3LO3paryTpMgzwi8mfRbceQxy2meMDtJsSqI7QHyIsjt5bp5Ot4FXKdXIHMSUpOySmiFG99fqdWpscK/ZaI7f1byIGVSjge2Zha5bTE3sgZ3pJwmMoj049qtDXpTvrlBx7sRKAzSjOJPdnhqHXvutczpwSZEnyjftZEv4JLqBtOI9F6v78c1jILHx2BvN+loe2mwrPjtMk40qm82Z8kYriXCdmi8EvsPM+wR+odCYMwJkDN3OQGfGxGye03St8M+8/8qpIFYtZY6CIZXsfMSlCxZ+5Eg3Dgiy4EE+7u781CcPezlCpT9wFJPEuRKMIALG9z+xYNjOLNvRhOFC+7GVm1dBjdcDaL/eDrexa1plRd6HPh7kaotle7mgbVX+vq5Cxv8uoI4sHgzL2Tl4ygdkMfhuQt+SlLiy9bXJDltZik65mQIAm/MZy/ejoOAkE+5Go3LGyK6ezBNdf6cyIO+uj+xaZ7QFPcHjePjET0GJUJWgonyBvyf+VJadTt2YTrjYmyd/OkfkwQK03DW86b6KWTJHMQhFZfBoNyXxCeFZ+K9jP0nEihoaeEReqGdIbhiE+LHuZ4hDHhsazHQBUwNTRpJlvln8LlHvZ7ivCamejgZhQwbDqn4NZcO+RcZo/LGKVM+1c1r88sh/PjZCxwNUrcl8NhJjKMAcY908HCvrCM2M377QVwa9viku/nt0Q
 D2/IOZSp
 hh7BK6pT046LT4p7Rso+Zjzy6sOadSkg8P2G4if2Hi/aXHfQFkyGcZp4912bW4znqMiiA8diR3iXXbCkJFY7npkwFBHuE9PTSAtR7HvybfV8JuqrArHgkxRsjC5OBF+v0Jh1z34P9qGRHUwfszx9h7dheVwjZhLs1ZO0taG/EH/Vao4NYftqfRRl+ywCEyDUPSZ9fkRcGeKZyjJxDisNrdd+3lPLvgwrRW3e9Q1jfUno1nIr5wGJEa1XcWD7B7+0/Na5fAL9p0iS22EnLVPtdnWms4PEvRs9VwQUHqv6dklIFjwJc41Zn45qlCWmVwzbTHnHkGm0EFfHCBuvD+LMRQZtVFQ7tNyENi1knzYtGHKdRqjeloBd7iOu+O29TPl4EnS4UiAs3t8PYMKwEOrEwHnt1Z6jDF5fZAF7mafvsoy+DW40G2FEqCZ/NUvsOwp07Gsvvj6C1eSUb40bjx10qgeSGZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:01, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> The dioread_nolock related processes already support large folio, so
> dioread_nolock is enabled by default regardless of whether the blocksize
> is less than, equal to, or greater than PAGE_SIZE.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 894529f9b0cc..aa5aee4d1b63 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4383,8 +4383,7 @@ static void ext4_set_def_opts(struct super_block *sb,
>  	    ((def_mount_opts & EXT4_DEFM_NODELALLOC) == 0))
>  		set_opt(sb, DELALLOC);
>  
> -	if (sb->s_blocksize <= PAGE_SIZE)
> -		set_opt(sb, DIOREAD_NOLOCK);
> +	set_opt(sb, DIOREAD_NOLOCK);
>  }
>  
>  static int ext4_handle_clustersize(struct super_block *sb)
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

