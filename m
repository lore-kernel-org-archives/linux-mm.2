Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18125CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099E46B0088; Tue, 29 Sep 2026 17:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04ABB6B008A; Tue, 29 Sep 2026 17:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA38D6B008C; Tue, 29 Sep 2026 17:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B01026B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:09:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34A201205C2
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:09:44 +0000 (UTC)
X-FDA: 85268041488.09.5C9CF36
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf02.hostedemail.com (Postfix) with ESMTP id ECD4780008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:09:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=krisman.be header.s=MBO0001 header.b=VOcC2k3+;
	dmarc=pass (policy=none) header.from=krisman.be;
	spf=pass (imf02.hostedemail.com: domain of gabriel@krisman.be designates 80.241.56.152 as permitted sender) smtp.mailfrom=gabriel@krisman.be
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790716182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiLYfNLi9fHUv/AIARCPOZejdDUsvSdtLFBSFLvIThk=;
	b=rqKqSOYKZu5XVNSLl7A3axzvqujdDrpmv5R6cYhxIVCPrJFgKbqXTr0KwBKUSy4r2BySD8
	D0xQ6d8oamf76cRIoAHwuzAGwGcfHAal4VYTdQZOImkGmWtxM8UQYSHMnOhVD1BJG9bjnx
	LrfLgrtsCG+rtPgYfqmT2T+qK20dVUg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=krisman.be header.s=MBO0001 header.b=VOcC2k3+;
	dmarc=pass (policy=none) header.from=krisman.be;
	spf=pass (imf02.hostedemail.com: domain of gabriel@krisman.be designates 80.241.56.152 as permitted sender) smtp.mailfrom=gabriel@krisman.be
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790716182;
	b=xBqGE/L65l8EvdwJi5MiCCF/vGJU+iGN+5lkR/6vfmDnIcFTcdig683o0wQDcyNsY1OV3i
	BNZ2XhOGRzJuS1jnc9ObEIWtdp2FPiWuHvDZr1sMN/wHy60u7tfEUuLWr+0ebE6TZUPfsX
	iqNXQwTLaAqR4dKTveqPGmGJ0nmCsb0=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4hvW5Z603DzKp6M;
	Tue, 29 Sep 2026 23:09:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=krisman.be; s=MBO0001;
	t=1790716178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oiLYfNLi9fHUv/AIARCPOZejdDUsvSdtLFBSFLvIThk=;
	b=VOcC2k3+l9mwIjlQmluaLAMj3QcSsEaHRsJCDEDf/X6QqEOr/Cup/qfRLOpiG6HEFPsfD4
	mOfdToOqRiPUn6IpXLxZAMZRMgBmmxGqdRKKUAakHzrGjAZS5yiULaMBvtMyLE+Ycd/XG9
	OplZoxE+fXU+4+z6M29312v0ZyO4pxqH2eY/hOnP4bqC4Kyhqhjd/ellBnlI+WTAhOx8CO
	iHhpkSQlDGlVHlvdJCwPORM4W2VUoItohk+YX+wgHixx4oUgYo85m3XhdBb/E2PIkkApgI
	VamztEsMrppgs+aR6E7mdQDLiZ9Jz5ziSvtX69zdcClghz/lWFdkb578D0puSg==
From: Gabriel Krisman Bertazi <gabriel@krisman.be>
To: Kazuki Hanai <hnkz.64@gmail.com>, hughd@google.com
Cc: baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Kazuki Hanai <hnkz.64@gmail.com>
Subject: Re: [PATCH v2] tmpfs: fix unicode_map leaks in casefold option
 handling
In-Reply-To: <20260827152516.805622-1-hnkz.64@gmail.com>
References: <20260827151426.796843-1-hnkz.64@gmail.com>
 <20260827152516.805622-1-hnkz.64@gmail.com>
Date: Tue, 29 Sep 2026 17:09:34 -0400
Message-ID: <874if7ydbl.fsf@mailhost.krisman.be>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: ugicih3ustmatygutqz943syiyzr4kwg
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECD4780008
X-HE-Tag: 1790716181-952672
X-HE-Meta: U2FsdGVkX19zIyR62oH39YZOOYzKgxww5zalXtjztrUa/pqGIjFyBHNlwfL4hCNoPkng4yG1AMuO2Pvg72DeTBHzwv5PKamKVVmE3UsaK7tqZMUro8IHZ16AUfLdoAGjrM1i3FfDeAFgWOBLGTPEeXTsAvphJgDanVDhd/PTVfgPibh7gJS2sEyIoW8MqVam/outNOcpsuGm/vYODDQDdnmZPJxDeqdJAEFGj0HQuAXYP43zPHY6j1kNb9eBzw4ZGw8Ho72c5tBo3L3MakqWDzqwYH1x4ufmLL+uuTD7CLDTDnYSvSI7Mojk5BY3FmTvazvRYa2ec6aTb5u8ZI/+HJsjJ0BTH58eNriK6krlfMZOZBVxJP0fJbNX2fkFQzhr+qP+0bh+ucIBx4r8cEZUzlTEzNF0u/aQGM9QrJ35tWL8Wucm+ap4XY/3fDnDl+NEzU4AuT7aOsfKFuPvwo/TCC59sJDbmTyxa2ppj6/8OicDWWAdzZIyrFAjjI4BKgThmixRxp4Q7xl04wrhizowKYN7fEnPCsyCas3x0AwbOO5TIqSi79lp2JwAEk/G9akUnPdhSBhXjNGTPad6KCwtfJJIgd3TkT0GuyQA5FEHeccHtor1cBfBfcDjYf/wuP7HDW8j1NHVYkQ+SR/0HHBuZk+4BMgOGhcYD3ga4j6KLJwgKY+T7Dkq4zgvKHluYEjPybHkZTeKY3ky5Yql0ERdB9HaLKO67ryZasgNgA5xlf96ji+49Y6d87Y0bJQ45j7ACqwMcQ8Gw4pdWOBZtrPZVrGWNZ5Myc5c+OlMzRlNguPgxAlWjCatIMEvOXSPYhw5R/JA+5yB9jckZbxfk20Kst9bSzXmvhNK2TBkLJYV/pKF9kjG052CYc4M5WRJmj5CQ+Lg6OWi756SIWbCNt8VmNL5SBpVg3jiEiLC/ASEY9+JDzjOsGN/3cHl5k7EQ9AhNP5V8Ut0w3nIBzcZ6/I
 /Xl1I/fj
 Yn8UIF4SDn9j2Avnzhwy64zYYK2lReHcDrK0DoIj/31KgsJU6P8++cmcxPd9wW5KW/ygm7sfiO2s79KSKVmW1fS6UVqqKfRZMUgpkPc22sXv5Jb6LnGBeRxifEYKrIn7hxJZt/rykfAnwvhw//wyXWXNEgx/wp7eZjrWpHv/TyXLDD45Kzr4Gp9J7zk0oi4b/AnpZ3WXe4K24HlTg3YTBDNpeI4kb5NlutZdN5WTiMKxH0bJKIT3I2LeN8RIKZYnT8JX1Znk/xXfQiiM1wj9afFFfAWCk3C4dw962JG7gF823BvgrPNISyx+iUzRnzwoVOhHmiC23Owh1P0QAN3wLgC2+99JbcdqTHsDshBd/WtWoDfQL1Vrxa27n7hcDWbZ35qvkHt7XkCMHrZloH/KMNJinslld2Ka+E5kZciVNjxf7xTtjJMZ4SaYceoE2Tz+wYnFbVyT+qf69he2COJo2WE5LDbZb4WRqaZKJZQHhJVaxBHhaaJ+Qmo30H41ejdz+ftmDZruMeLgWTyFkGvKeFxOrQzhIcLhTTRovOgAGgNPBDmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kazuki Hanai <hnkz.64@gmail.com> writes:

> shmem_parse_opt_casefold() stores the unicode_map returned by
> utf8_load() in ctx->encoding. The casefold parameter can be supplied
> more than once for the same filesystem context, but replacing the
> stored map does not release the previous reference.
>
> The final reference is also leaked when an unmounted filesystem
> context is freed.
>
> Release the previous map before replacing it, clear ctx->encoding
> after transferring ownership to the superblock, and release any
> remaining reference from shmem_free_fc().
>
> An unprivileged user can repeatedly set the casefold parameter on a
> tmpfs filesystem context from a user namespace. This causes
> unbounded kernel memory consumption and can result in a local denial
> of service.
>
> Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
> ---
> Changes in v2:
> - Keep Fixes, Cc, and Signed-off-by in a single trailer block.
>
>  mm/shmem.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 89a1495e55f7..62440caf2df5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4508,6 +4508,7 @@ static int shmem_parse_opt_casefold(struct fs_context *fc, struct fs_parameter *
>  	pr_info("tmpfs: Using encoding : utf8-%u.%u.%u\n",
>  		unicode_major(version), unicode_minor(version), unicode_rev(version));
>  
> +	utf8_unload(ctx->encoding);
>  	ctx->encoding = encoding;

This patch fixes two bugs at once, as shown by the other patchset that
does it separately. One is the leak during 'mount -o remount', fixed by
the second hunk, which is fine.  The other is when multiple casefold=
parameters are passed at once.  I think that fix is wrong.

I can't think of a real case where it makes sense to pass multiple
casefold parameters, besides user error.  even if you are trying to
outsmart the kernel and handle cases where a new encoding might not be
available, giving it a fallback version, a failure in the first
utf8_load will back off the mount.  IMO, we should just reject the mount
right away instead of silently swallowing the first table here.

This hunk should have been something like this instead:

diff --git a/mm/shmem.c b/mm/shmem.c
index e46bd4fc7e41..06503858dae4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4506,6 +4506,9 @@ static int shmem_parse_opt_casefold(struct fs_context *fc, struct fs_parameter *
 	struct unicode_map *encoding;
 	char *version_str = param->string + 5;
 
+	if (ctx->encoding)
+		return invalfc(fc, "casefold parameter cannot be specified twice\n");
+
 	if (!latest_version) {
 		if (strncmp(param->string, "utf8-", 5))
 			return invalfc(fc, "Only UTF-8 encodings are supported "

> @@ -4976,6 +4977,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
>  
>  	if (ctx->encoding) {
>  		sb->s_encoding = ctx->encoding;
> +		ctx->encoding = NULL;
>  		set_default_d_op(sb, &shmem_ci_dentry_ops);
>  		if (ctx->strict_encoding)
>  			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
> @@ -5073,6 +5075,9 @@ static void shmem_free_fc(struct fs_context *fc)
>  	struct shmem_options *ctx = fc->fs_private;
>  
>  	if (ctx) {
> +#if IS_ENABLED(CONFIG_UNICODE)
> +		utf8_unload(ctx->encoding);
> +#endif
>  		mpol_put(ctx->mpol);
>  		kfree(ctx);
>  	}
> -- 
> 2.53.0

This part looks fine.


-- 
Gabriel Krisman Bertazi

