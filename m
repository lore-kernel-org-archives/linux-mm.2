Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C1D8CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 20:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011316B008C; Tue, 29 Sep 2026 16:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD866B0092; Tue, 29 Sep 2026 16:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4336B0093; Tue, 29 Sep 2026 16:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC4D96B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:21:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B68D84061B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:21:32 +0000 (UTC)
X-FDA: 85267920024.24.83AE320
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 09515A0008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:21:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="dZBZNw/J";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790713291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNXUzGSmJcg+x1Y67m5TU8BDoA/huH4kHiMBSuw+QHQ=;
	b=uS4LYwb4W7JnuqRPcvAebYJ1yegu9ZOgD2TaNyUR5j69Rks/DadfQbOGuRzY16E8MUn/4S
	VSzR3+/+TGDdxCEzI+lttKZbA+x2qEIZqiIqIwR8SdNOC/16DNRVhJ0MXviBWcHnSzAptZ
	GQVe9zqUhIX2IK087gydZURvc1PYhdo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="dZBZNw/J";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790713291;
	b=HffbV4mt+mL5SECgJewaKYHbmmgCnvVChY1aXboiS9QZdEZCMRLu5zJ6uQCpwz/0knOpSV
	RByy+42Nh5if374VRjivh4kjN7K9DbkAV1tF/qx+iZc9XiME5czIO6w4XOx6Ri2MaPOcJR
	eumHGd1o8ev+WGZZ6u9AljLrBze1X9A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3658043578;
	Tue, 29 Sep 2026 20:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12411F000FF;
	Tue, 29 Sep 2026 20:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790713290;
	bh=WNXUzGSmJcg+x1Y67m5TU8BDoA/huH4kHiMBSuw+QHQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dZBZNw/JUw63SYHQEK7bPJ7nkX8D5Ba5G7q42k8NZrKTda19/l4Y2w/bB9YguySoT
	 yUXN4+La4u35x9e4bp7AHS7peAUNw+M/12nSdhAE+OwhXw429/K47zrVkJxuJEDKfB
	 T2vF6LllaLvHlrW1vThl+HVfd2bJwpanOpUWIQeo=
Date: Tue, 29 Sep 2026 13:21:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kazuki Hanai <hnkz.64@gmail.com>
Subject: Re: [PATCH 1/1] shmem: fix unicode_map leak on remount with
 casefold=
Message-Id: <20260929132129.f22de2069651aa2eaf56bf7c@linux-foundation.org>
In-Reply-To: <ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com>
References: <ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 09515A0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: jxfg6ddnn46ks3e9y1ygbfmdfqufpkip
X-HE-Tag: 1790713290-805825
X-HE-Meta: U2FsdGVkX1/PDtmTxDP6OQ9TIjt4g4q3jm62EWWogpiZVO/w4tM/S/uW6/yriANRHS604zD2hfbYx3SneuC7iW+v3ZU42HY04w/3xFBYmYlJRdpqOZczaFMiquaQyl9KqaL/p35blVFh3CgY3a8wZAZ4z/FdoGabNGh4bD0ZmlpMx7097ITgJdpGhUUVYdW5E0l+Eji2XzMrU3/JkB7CFlFZFs4DV36WUfVQx/63SgBJ98m1bOWsIKwDw+pOrEsm5ZeoOuXcKqutoWeee3QmhDIdIi3Revkt0IRCK/45t7I2mx0RtrapME6/PRRG1YB0U4d4BnRtjNvwyJlF2ahCMx5TZOrVcnnMFuXfWtBrUAc5s8i1+EB6t4EosUGaptyvi5TqCSqIjOFD6E7V9RXQO7gIDhxGy83KoiOvv1lfZtb42DXNkiPP4rh+IQ76EKGj3k85UXv0IP4EccceSFbQMf+6TLt+qehBp07x145OKGyKDNZGCn8UvPigDEJKiws3cm7Ycu96YTOex4dXt7a5riqpEnZg1M2WMEZslg9aQOE5a2hfDmP3vQMQx5G2WX7W3DGtOaRceamGINTbxXJr77jqvXBcBG0vT8So4vsFqGd3kZzGbwimv/sb5ORsxDDjaIMwcl0J1eo55FAfx76mHVJBfEnWR3k0Q6f9MGkLKeSQwRohnk0KkYTWtcARHdCoacl65IqMA/tmrNGqDoRsDMw0SzQ1zvcZilE4gUecihNv9GS/OTmOR58GCTgFur++bWe5ez8mBowN0wUPGvm9sHo//8bsmaobLRjFIB7K5Thhf5yYTcP4+wvFjFUW9iNVg5fqrmnM4rDE2MCbeX3T9KKOrWC2Qdw01Tf9tM6nrEQmJ4qJ8cKAxp90rwM6cbZLt29WJBOJNg+uqiejlErMNobf1XFf8Zi/To+MLNja/pA85tDoCCiyI4o+5WWFH6hwVEHNctCfPWM7bLWtc+b
 Ma+Q5IrR
 s8ZCvW6ETrsHqwx4etvS0WzHSCiti6BZ25pX50e+rD2ahjeCF+uON8PhFXAXkYWbzOoy1qeyHhqR03Yt2CSziJK4DnWfMcEdLvz7mZ3jFlae0Az6XyXDtPG/MGsdKNGggvZhhb1LyEpSUP1+V6zgAum7G1Ql95YiMam+S2+pPNocsmJ9axCoITtZ1JPtu3oRKulVrpvNP/j52TZPUepFAq0ZsJ7J1jUL6mWwcrftte5s4WavVYa7A2BBJquBsotmbY8YwKxqcthxJGOoGl288A6dVBrq/Q1djkcjQf2R35wY4fsw0QHfsckTEw5yUw9FtfMEvtPHBOTdBulGY6PLthB/MQB3P6UjBFQrEOGInoSCBXuNX8dbcCAUR8KewB/ct1RP0yw7rBHE32u9GSJJd3L2YGHg6+OFTFiGS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 15:13:24 +0200 Mohammed EL Kadiri <med08elkadiri@gmail.com> wrote:

> shmem_parse_opt_casefold() calls utf8_load(), which allocates a fresh
> struct unicode_map, and stores it in ctx->encoding.
> 
> On mount, shmem_fill_super() takes ownership of it via sb->s_encoding,
> and shmem_put_super() frees it with utf8_unload().  On remount nothing
> takes ownership: shmem_reconfigure() never looks at ctx->encoding, and
> shmem_free_fc() only frees ctx itself.  The map is leaked.
> 
> 50000 x "mount -o remount,casefold=utf8-12.1.0 /t" on a casefolded tmpfs
> grows kmalloc-32 from 660 to 50574 active objects, and nothing is
> reclaimed on umount.  A tmpfs mounted without casefold stays flat.  With
> this patch kmalloc-32 stays flat too.
> 
> Clearing ctx->encoding after the transfer is what makes the unload in
> shmem_free_fc() safe: otherwise a failure later in mount would free the
> same map twice, once via put_super and once via fc->free.  This mirrors
> what shmem_reconfigure() already does with ctx->mpol.
> 
> This is easy to hit once casefold= is reported in /proc/mounts, since
> mount(8) then passes it back on every remount of a casefolded tmpfs.

Thanks.

I recently merged
https://lore.kernel.org/20260827152516.805622-1-hnkz.64@gmail.com

Which is preferable?

> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5202,6 +5202,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
>  
>  	if (ctx->encoding) {
>  		sb->s_encoding = ctx->encoding;
> +		ctx->encoding = NULL;	/* transfers ownership */
>  		set_default_d_op(sb, &shmem_ci_dentry_ops);
>  		if (ctx->strict_encoding)
>  			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
> @@ -5302,6 +5303,10 @@ static void shmem_free_fc(struct fs_context *fc)
>  	struct shmem_options *ctx = fc->fs_private;
>  
>  	if (ctx) {
> +#if IS_ENABLED(CONFIG_UNICODE)
> +		if (ctx->encoding)
> +			utf8_unload(ctx->encoding);
> +#endif
>  		mpol_put(ctx->mpol);
>  		kfree(ctx);
>  	}
> -- 
> 2.53.0

