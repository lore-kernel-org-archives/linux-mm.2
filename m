Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D78606B2F1
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=RB4Gi6He;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QMFLKGZG;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=RB4Gi6He;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QMFLKGZG
Received: by kanga.kvack.org (Postfix)
	id CB6016B05C6; Tue, 10 Nov 2026 08:01:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76216B05D1; Tue, 10 Nov 2026 08:01:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C776B05DB; Tue, 10 Nov 2026 08:01:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AE616B05C6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:01:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8E501606DA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:01:29 +0000 (UTC)
X-FDA: 85419220698.10.8B8E8F5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8E43940006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:01:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RB4Gi6He;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QMFLKGZG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RB4Gi6He;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QMFLKGZG;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2v39D546EgtBEUxd0H/nXHWdpp+WjM1EXJHBDXXhZg=;
	b=45955ndtAuvezHs0IJAIiRWC2l7IHOOLwQLfeQq/C9ZMlEcAF/DeBqUjJDT8O5NTIGKH/R
	DsCl4jrWBw0wIPQWZ53UV6vgzO9JGluXaQmUq52iF1X5ccLpj5wtOWAFPHDSGRudOAEjrs
	NKbJ2+6Ew9QwIpIrVSHOanGOVqG447E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RB4Gi6He;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QMFLKGZG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RB4Gi6He;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QMFLKGZG;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315687;
	b=3dxjg/5P5Sg2pnqBEnxiCLK9Zz8OWvtu9f76rxCiD2xFnZeHLBjcTYChSgKfwRwMfR2RyY
	1SuinCNy8ndj90qAchnN42RcfFvxV2qy9v4DZMVqdmJ9nDQkdxYp+aQmpHmj74MPZZzjLh
	pkBXVupOPb+chz/elXC2YzN+cIUHGog=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5BDE721EA6;
	Tue, 10 Nov 2026 13:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D2v39D546EgtBEUxd0H/nXHWdpp+WjM1EXJHBDXXhZg=;
	b=RB4Gi6He2tOUNMy6bJ00Z+v0V8KBcoceupgbTjR0W9JRUotJXCO22uGnREICS5iWEx7X0U
	0IVV7m7jzO3SjxV/YRQ64cvorbwE4hatCdNNKs+HWfoWzBZSpCG4wvirvsVGvpDlswb0vl
	KcHcL0cPLfF1+mgGlKlCLvj6g90mp8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315686;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D2v39D546EgtBEUxd0H/nXHWdpp+WjM1EXJHBDXXhZg=;
	b=QMFLKGZG2/0yvUwt73PA3Kt1faHu2V/ZbQg11OX2y8poQHVD2y2CgIBv6al9zzMKJr2g2c
	lv9nmQzfSnMd0CCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D2v39D546EgtBEUxd0H/nXHWdpp+WjM1EXJHBDXXhZg=;
	b=RB4Gi6He2tOUNMy6bJ00Z+v0V8KBcoceupgbTjR0W9JRUotJXCO22uGnREICS5iWEx7X0U
	0IVV7m7jzO3SjxV/YRQ64cvorbwE4hatCdNNKs+HWfoWzBZSpCG4wvirvsVGvpDlswb0vl
	KcHcL0cPLfF1+mgGlKlCLvj6g90mp8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315686;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D2v39D546EgtBEUxd0H/nXHWdpp+WjM1EXJHBDXXhZg=;
	b=QMFLKGZG2/0yvUwt73PA3Kt1faHu2V/ZbQg11OX2y8poQHVD2y2CgIBv6al9zzMKJr2g2c
	lv9nmQzfSnMd0CCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3299E1339F;
	Tue, 10 Nov 2026 13:01:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pQ1HBqYV82oESQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:01:26 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C0977224F3; Tue, 10 Nov 2026 14:01:25 +0100 (CET)
Date: Tue, 10 Nov 2026 14:01:25 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 28/41] ocfs2: use fc_init_pseudo() for dlmfs
Message-ID: <ubsk5hvk6rl3woji3mwix2l4hwfcp3s2q3m2g7llo4yozmi4qf@vnfosiawowxo>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-28-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-28-4c998976c6c7@kernel.org>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E43940006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: 3qsyoies3ane3ofeu1pwtkxkz18xbsty
X-HE-Tag: 1794315687-373449
X-HE-Meta: U2FsdGVkX18hoxiqY4BIDGsDLHElin7F7HUW3K3hHj4OdOvob96F/A3G+bPIk3nediFa57VRFJVz7difKkoyRg0poKj010ULWvaDlN6mc7PusYv7HedLhviMXx9WXOppF6ZN0q0n0uhvk/4cC2hH7Hf9YuM+fgmXwIplOXjWkFgsC2NpJyjyqC8F1+/OBH1mHvoMrt7/jZARxRXNDyXYlhCMOBDgDu6xoj/+S88WqtiIbIxXmXwYNPrxWLt07Z2vpjOraQocL2JvBXURay04HK8byi8yA9SPraFBnwQF+2jlQ8FWPYfVvM3u0rVHORtBmwO12w/4uwgzepMpPHFfDltlTUUd7bTg9pWICXY1gPdXbKev7xALnnpcYIUQL5QKkvuM0gIZuDYFHMHZVD2viqeQf2szEyp53p/xjzd60CZOIr1E8kT0ANVNWczoyNtD2FoVElLoXTz4xtwSsvdjLmlodDROrOI/nOppkuayxJk+k248azW/0LLYnKq/Axf4Q3v/x5NP/Udl0JyYc37kA8pP2tI+mgWTdB8GTFsy8daX+AztETuJ1FSFtQ3Ds4YTm6NFLeo64tRcv78s7Wreak2rk2Sz+zX9Q7dembtsANR5rNq4/SUeDtGUPabsi/vOIEMkkXNSPNm7usCFsgmG0VzVhWxvfBNu6FQBBtKW0WCdtYMfPJ8CHfdCOPhkBQsjtqrnCAa0kVGf3h/6Uq7t9aHB+3PXJu/AdGTdqP43EpPus3HdV4j0z8BDiFXNA9GXWID/AQg30juiErq5Mt/4K7yrCA1jo7SuxGzTysc8qJdyXQYKXANeVJXyMjUHfjyrvG+7zJOb13LuA52kmo8QnGdEUrpBg3lI0SseiFG+qceF5eQvl2Co4XTG2UviVsXrN/An4sGr62kLDPwjp8yWcfALClKkIcTd234ZpvkkOmEqcSKxL09+PrAI+t21eHSl40ZbbD1TbPjSeJtHaKx
 KIFB7F2W
 x7tdqZhJ5lPx9t6XCZ8KJh0ul1yeOx6W+NjubJgvc4BxMb8ZTANSxGfVIZ3TN43ORyiDVHdmidaoJE+fbbC1NFLkS2VS6cGSFlg+FbCRm5g1EGWU4wIdxMuhdVWbvZw+gzcFhkVyD/d9P0ViIvIqi4NxdiR4W2cNKWZucpOQ7MeuJZfJCLotqMKg2qAmQtSb/NugPW5Xe9ex7JqaV59Jhz/11Wua8F6aw1qRhaKeRkYfysw+sLGtQS+58N8ft+TEDQKWaLcTzOJ9E5ZA0J84BHEFopSgJRlfq4EdwwF9zpvQZQmT5rqlFidDLZZ+StuKI3qkmMpE3SLYnvf0+Tk7C/dqwJiek21BC6BO7ptieaHIS7f7y5+UBtPQ074sOMJJZov860qDaEbIQgwc1RtnuhLzb2joSSv4/2c8k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:44, Christian Brauner wrote:
> Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
> device nodes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/dlmfs/dlmfs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index d3bfcada3e3b..1789ec96dc13 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -21,6 +21,7 @@
>  #include <linux/module.h>
>  #include <linux/fs.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
>  #include <linux/types.h>
>  #include <linux/slab.h>
> @@ -563,6 +564,7 @@ static const struct fs_context_operations dlmfs_context_ops = {
>  
>  static int dlmfs_init_fs_context(struct fs_context *fc)
>  {
> +	fc_init_pseudo(fc);
>  	fc->ops = &dlmfs_context_ops;
>  
>  	return 0;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

