Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A421C606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=v14WN48b;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OvkNExNy;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=v14WN48b;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OvkNExNy
Received: by kanga.kvack.org (Postfix)
	id 9768C6B05BD; Thu,  5 Nov 2026 04:33:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94D4D6B05BE; Thu,  5 Nov 2026 04:33:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83DA66B05BF; Thu,  5 Nov 2026 04:33:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57BCE6B05BD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:33:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2F45A09AD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:33:02 +0000 (UTC)
X-FDA: 85400551404.23.F2DC02A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 11F4D140007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:32:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v14WN48b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OvkNExNy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v14WN48b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OvkNExNy;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793871180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgu8NzTJnS2R+zD0u6Z5S8xrxcIoknrqJKi9obAmajo=;
	b=6xrTKb+TsEUHqT+PTBa2XMUcWfXPNH5PqtFzjLPikBhfBlkFC8uBy+abfLvvVdr58ftaIx
	NjUbzgd4Sa8Rtz3GLt3PDXlRlJAkqNnVTx0zbY1CoqFp241Ye6zyGZYhRkPhUIuwoAK/Aj
	3R/1Dni1Y08uB2RykYzBbzkUQA3uZuI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v14WN48b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OvkNExNy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v14WN48b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OvkNExNy;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793871180;
	b=8FVgmTpA3wnUBEFEnor6UAdbe2fd87li+Su7+Prx2lkWSiBvb18PfdZXsEjv9idD1V2N/h
	yPUgGPQBBFNdJJrnVBmQ9S376VO1yTHj+UoIrxiUzS+/4oPoGtWINDmhHvw525h13GDERH
	iPiHFwHU54GxDWmtFGxv+77DEFwmfEs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 43A9421F5B;
	Thu,  5 Nov 2026 09:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793871178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgu8NzTJnS2R+zD0u6Z5S8xrxcIoknrqJKi9obAmajo=;
	b=v14WN48bHlIql9h5HLTugaVISujZG1I/c68I+QtgBbLoIBApSEacYXXWBcqgCfJXFq6f+A
	a04b7rV9MZ+1A7GaOjZPNsUBb09L6OB9bhWH1gZyydPZAUwPj8q85pTy4SRbmwmJ76LAqC
	SSzXuvpaBX/SH14eaONLs8VdXTpBuaQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793871178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgu8NzTJnS2R+zD0u6Z5S8xrxcIoknrqJKi9obAmajo=;
	b=OvkNExNyUPYRAlVHRPqHODS9azrcpr+2lIkcR7gaa3TaHUtdVPDuCCR60na21ee4PYtMBN
	8FyqEylcSu5PIbBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793871178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgu8NzTJnS2R+zD0u6Z5S8xrxcIoknrqJKi9obAmajo=;
	b=v14WN48bHlIql9h5HLTugaVISujZG1I/c68I+QtgBbLoIBApSEacYXXWBcqgCfJXFq6f+A
	a04b7rV9MZ+1A7GaOjZPNsUBb09L6OB9bhWH1gZyydPZAUwPj8q85pTy4SRbmwmJ76LAqC
	SSzXuvpaBX/SH14eaONLs8VdXTpBuaQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793871178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgu8NzTJnS2R+zD0u6Z5S8xrxcIoknrqJKi9obAmajo=;
	b=OvkNExNyUPYRAlVHRPqHODS9azrcpr+2lIkcR7gaa3TaHUtdVPDuCCR60na21ee4PYtMBN
	8FyqEylcSu5PIbBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 160DB134F4;
	Thu,  5 Nov 2026 09:32:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jQQAOUlN7GrMbwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 09:32:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 9A6FBB666; Thu, 05 Nov 2026 10:32:57 +0100 (CET)
Date: Thu, 5 Nov 2026 10:32:57 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 31/34] ext4: use the generic emergency read-only state
Message-ID: <m2tpyczkdirf7z4pnidxf3375ykgs6mrybxz6aejffpfgptw26@vfepghgrvgdr>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-31-2f44f64f0b66@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-31-2f44f64f0b66@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.30
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 11F4D140007
X-Stat-Signature: onum8wcjrp9qcuntjcrfwt88p7it1dk1
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793871179-147555
X-HE-Meta: U2FsdGVkX18hlwfecXiQnM7Ntfks8IhjDKmxLE1Ta6Jdyg2bRfhDL9Admgo6QEs+kWjcbDbDsYJ6PIje5nT8+5JpQEoetuYAUIgbk0K2Q06qP4WfkJ5ZQHtIw3mwlwtdzb71K2hGzIeS/Hgcc0n0V3ScQ/9EIz0V3mT49iZjxDfEd7wh60v26h3oRDa88W1f8s/2dh5htaECK00I8+J8A+bnEgWTp+P6QB5kmuJwgjcVtlVHbNsBdDpHD9Y/uwtC8yLlaobfDq+y6YRG5+T7fiHrrbBBuXcRDZMvvPx9kXqFxEr+vGrM15bsZGbrFnIpBj9F+ZN6o7uet4a0o3b3ZJKGPE9ijlHrKnZV4yQw40s4zx27oyvJ2YAVUgVuATO43tuRCkzrEt3V4WbkQbZzAXcDEuMtBpIwUka4NRBDtLuMIvpPweL8wLsDRfcPF10a/DjFH1W2QpaIbGTcNnlN8WzLjXc5NLj2xbjXqWKkzcmBeZPAYs1fgPVqt4czubW3jYfoaAifZsCBnELcza2ramkS4sNuMe176/z1ignqtqoc2dRQxpqq9X9hTSfsSD1BASwFZSMVYzTiTo6yEV3+GGJwDQeDc9DW1TkgQSyEX+hScdRAOnpBB1mQ+IAjx8IMsg68a0NgMSnB52JpEAEkVKHqQWzTPhakbVkMJ795DbuiUc87w5zmZuNQv7vuzpKZ+y3OUR8wPlrjlyIdWY2wmauoY6cK1F3e5JRpY6hj6QKGcAvDV/d626jYZqdPgc2HJTsSUtOg9n18nygIArJbi+zjd01jNO9U28MVx0je/wamYZ7xHJ7jkeJpoWxSwXhTZzjHGDO82XomhsDbcoQNFFK5O41DBc/C/XZY2JELsZ5glxgYFg3hS/0pab805fKPpPkBPZ0TXa2MlxSgWJHsZzG/cph6o9vSOlScwkGPHr0KopCNuyGZDAQJxKrLhO7PQKzq3YkmBQyY2WSCc0H
 IV7FN6LK
 Z9o8KXi8K9aTYMgFtunQzJmZWTykT92ZRYzaaAutxwcY/e8hnV9RmWdS1rDnnsFW1s2drjroXnYpNiA7qpdA3hCuhk2j8Eq3AAjVQ1u2P6/FUtgEXKbxfIc+Gvef2YJVKpbKcLe/C77+ioZPOEua/iTU59WA8cT4ZnPyI+oEMeTtLuRTGztxCAGjYNBMkKjb4T6Nfvjdmx3AJDcGY7geS4lIcqsj2lGBjRJHul9UOD9IZ42321fo8M5lUvzo5VzfkVyfq5eCFbxhnKtHkurhSJROsJTH0ACgBfcyRmcvDaqgi76i1LiDTL/r+NKZh41gtNEiLbz2dJ+UTf33iwnB4pWjXFhASM7D52diWfA+MOleC6T5tyamfvIYHzE/b8TECSceDDkhjLujXo8vAtN2oryhxIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 29-10-26 17:07:22, Christian Brauner wrote:
> Set SB_STATE_EMERGENCY_RO next to EXT4_FLAGS_EMERGENCY_RO when an error
> makes the filesystem read-only. The VFS then refuses modifications
> before they reach ext4 and reports the superblock as read-only like it
> did when ext4 still set SB_RDONLY. The shutdown state stays ext4's own
> and so do all of ext4's checks because they cover both states. ext4
> keeps showing "emergency_ro" in its mount options.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/ext4/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ae5ba6823c01..afbdbb607b14 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -757,6 +757,7 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
>  	 * and other problems.
>  	 */
>  	set_bit(EXT4_FLAGS_EMERGENCY_RO, &EXT4_SB(sb)->s_ext4_flags);
> +	sb_set_emergency_ro(sb);
>  }
>  
>  static void update_super_work(struct work_struct *work)
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

