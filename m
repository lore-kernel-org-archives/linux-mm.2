Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DED46070CBD
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=c9mE+CRT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kal9kkyQ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=c9mE+CRT;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kal9kkyQ
Received: by kanga.kvack.org (Postfix)
	id 91EEE6B05D3; Tue, 10 Nov 2026 07:59:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEFB6B05D4; Tue, 10 Nov 2026 07:59:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF3E6B05D5; Tue, 10 Nov 2026 07:59:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFA96B05D3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:59:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03164407C7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:59:04 +0000 (UTC)
X-FDA: 85419214650.18.07A6144
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id DD40A20003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:59:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c9mE+CRT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kal9kkyQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c9mE+CRT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kal9kkyQ;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXIEEsQfVTIPoYksjJrq5Bxki7KhKYAms5GVjwoGo8Y=;
	b=OR/lT0OQEdyn0N8B7Js0f5L59Uf7Kt4Pkv0acPkYIQFbnKmV4QfREI9p7slCH0ld02OiqQ
	w1gONegBQpzMjdWqKj0JU+95ocB7117zqXUXmKeH8YFpcDAGDpq1NlUP3b8VIR4kf65NGf
	XOmvA03/nBOmen4tsJUUyjcKIp96hWc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c9mE+CRT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kal9kkyQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c9mE+CRT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kal9kkyQ;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315543;
	b=QbNSMLvpVym1E9w2qW2o2zSo+5F0wbdOoPOkqqb9bCcZt0AjUXLjNdVCSDxuLWG5SNcSHD
	5Teqg66IPffA2B+TE+zIaJGAiSad6+Eo76cSFI0I0RtHu+mkUfCIEn474DELI6433WwpP8
	JOZY7NR3mmcNJMiibDsLtRb2K5oSro4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 96EA721C3C;
	Tue, 10 Nov 2026 12:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uXIEEsQfVTIPoYksjJrq5Bxki7KhKYAms5GVjwoGo8Y=;
	b=c9mE+CRTtVzWwHCARJ1vd96Xho3nI/pS4LksT/7Mtmz/enT3ot6Jv+ishWlr43gZSQip4n
	SM34HuYF7Cvf9TdHqnHerexkyr7m27gwbghlt5kBxleXZTpWWWludIkY/uX/1xq2ZGF1Cl
	84ZWSnV4g+NJIksQj9LF3uDbQvrtb1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uXIEEsQfVTIPoYksjJrq5Bxki7KhKYAms5GVjwoGo8Y=;
	b=kal9kkyQ8SEr1Uo3AFh1O8jXLtIAjDTFZiXwnabICsxjbUs+efcLTV1NmhR9cGdyfqXeRJ
	S89Jh74CnobXgdBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uXIEEsQfVTIPoYksjJrq5Bxki7KhKYAms5GVjwoGo8Y=;
	b=c9mE+CRTtVzWwHCARJ1vd96Xho3nI/pS4LksT/7Mtmz/enT3ot6Jv+ishWlr43gZSQip4n
	SM34HuYF7Cvf9TdHqnHerexkyr7m27gwbghlt5kBxleXZTpWWWludIkY/uX/1xq2ZGF1Cl
	84ZWSnV4g+NJIksQj9LF3uDbQvrtb1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uXIEEsQfVTIPoYksjJrq5Bxki7KhKYAms5GVjwoGo8Y=;
	b=kal9kkyQ8SEr1Uo3AFh1O8jXLtIAjDTFZiXwnabICsxjbUs+efcLTV1NmhR9cGdyfqXeRJ
	S89Jh74CnobXgdBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DE921339F;
	Tue, 10 Nov 2026 12:59:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B0aKEhUV82qHRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:59:01 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 0FDA5224EF; Tue, 10 Nov 2026 13:59:01 +0100 (CET)
Date: Tue, 10 Nov 2026 13:59:01 +0100
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
Subject: Re: [PATCH RFC 14/41] debugfs: use fc_init_pseudo()
Message-ID: <tqopv6vbmzwwjyp24wch4hw526xibknezzimun4tniww2dq7wu@ajdlmym5ihdu>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
X-Spam-Score: -16.80
X-Spam-Level: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DD40A20003
X-Stat-Signature: kfkydwsukfpyipa77jpjpgnch4w14umj
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794315542-580380
X-HE-Meta: U2FsdGVkX1/+uriWcLxBp0s2csWPNgyswSGBDZRWLx8IPe2s+vlLRqk6mnF5ftRj+OKC1NEKCSsXrI/6cWaN7+jlTS1DTa5xaeIPMH+voOIo3WmNrdEakATyKd53fFO4gBXYLshEunMqxChWeN0vaILhKsUvXTKd6C+6zfm6jloQrojToAn8ba8pHsmSEVK56gARSERF7QF6qZa9aM2xNaEBGfizQoIGRvu0tc7qu5vu2cMoEwh1gFqbrO7Wuu4oZIfqufQyXyNv/a7vVp5SJ8mktk2eFtRVjgEqfCmNKkakCum0xbLkm5GuxZwS9RDbjfOsKMpvdlbgXruyz7X27fOO/N8qPMxHTYYmFYc1C6Gm6IzfY2qFgBGczH5KLSxoniryW1q11cBpGj+Q+d+Nag6FDSsquFDBqmcVaXEsNkI2DDFFnRWO7UoY8DzgXPe6q0a3GdlGn4iEz8ucHcSULr3P5FlVjOVIKtdIG0MpMev61U3Peuj0ibRaPVqvHfvdnSBShzCbasCRqppDYn+fl+rgZWTJfF8wM19X5OyY0E0KA7wgFnu596BnT9nUWJCM3a/buU04D1Qsehh0jr7ghg+4IdGMk+3/Fxtom/B4MGDHsLvl/v1V4/7Rxzcm3ohBgF6vUnEhSEGPfkhMXLmqdjsPdfzRW6SeZmIyV6bxSqrt66rfW6UljUAsKl47wmyhaDGyUvA3I3/EHLA6gq4vxViK+VNhFErpR/mmA35uxZrB7fcW5mvSj7MzkDq63BzxDRVtFOhoSg0KZAiFmxuBXslBhViZLL26PEmzdjlrI2iTG80YIuN8JFImMhTbOh5sMdN6x2Yn/XbnFzgVsvu9bVspeHed/Aag/MRjctF5/wIseFedgTYLhZCbwUD5n/8B5WHeGUyjuqZrWIsdP5YoSUslql1AmQW8kHuBtwI1Z4GlwJ1iAeIxaFzsx3un4yds/Q9YQDvb07hEk06fMO1
 NKAVgF0G
 s0gg4F6hQdreg/AS90nDcCi+v7q4sM0grxrtoK+85GZlbbjx+E2vJ6QkGdke5h583l8V9iOE/L3Svf/Lo+sJhK+CUwEJwgH9eBrvwSqtmeZ4fTBDDeQVCLJnsO2IOiwjxFcb8qMM5J9SvVGt8B3ktrnkprMfVvkuuklpVBEK/VcZuVpA3/8OMefQx57TA122SLNiZOathHnYRm4nfuJGsR/SNdi1kFJ0szmV7GfO25i1A89M3bDUd0a61up3rIeBN8y4C3+Y3IrrO/pNnc1Sb+fpcz05XJOk8bdSCw8FRlvP3EgJ0F/UBwOOiVNfQD1MfLCRuyBMmVWUHjr+4EX8GQU/BBirQJouSXdjB/F48MlJdJTgzQv9/U4MrM+SYgFMtbXeKDJbji6P5T2UJZpc84mQqw+CeH+IBCPbz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:30, Christian Brauner wrote:
> Initialize debugfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. debugfs never holds executables or
> device nodes.
> 
> SB_I_NOEXEC also refuses PROT_EXEC mappings. The debugfs files that
> can be mapped, kcov, relay channels and powernv's memtrace, map data.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

OK, makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/debugfs/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index b4915551ad31..f163f0bc5703 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/fs.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/fs_parser.h>
>  #include <linux/pagemap.h>
>  #include <linux/init.h>
> @@ -317,6 +318,7 @@ static int debugfs_init_fs_context(struct fs_context *fc)
>  	fsi->mode = DEBUGFS_DEFAULT_MODE;
>  
>  	fc->s_fs_info = fsi;
> +	fc_init_pseudo(fc);
>  	fc->ops = &debugfs_context_ops;
>  	return 0;
>  }
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

