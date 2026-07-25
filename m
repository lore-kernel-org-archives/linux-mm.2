Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF29C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400546B008A; Sat, 25 Jul 2026 11:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7256B0092; Sat, 25 Jul 2026 11:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7726B0095; Sat, 25 Jul 2026 11:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05B206B008A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:53:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79F8A160364
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:53:25 +0000 (UTC)
X-FDA: 85027743570.10.4852B20
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.167])
	by imf10.hostedemail.com (Postfix) with ESMTP id 99DC8C000B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:53:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=lAw81lEF;
	spf=pass (imf10.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.167 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784994803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyDxN4rb6c/XRh6ApxXaUggDqwL7NriZKZmwb5ZGNr0=;
	b=YF2EhT2jFAutCjPbgo88f9V1ET/6AnYEUleqFuR7tw2Jn6mAS28Hqe0X3EmgfYvat+xMs1
	O2v5qppwLXFDxc7oFk9hhNwRviTtvvYOV7Kx1YeLxNoqY5y3Q29KZE5Ei2DymIL57lXMp6
	JAxsRSf8hvattxmxlb4mfOxEYXav8IA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784994803;
	b=vnKX4+qB69k/rdSV5RTYNII6mu5lPbXVAUefAGt0t1BzEDsB3GBKLBzN+SEL2UoiERaR6/
	DzWa80OqmgPklxCaV9kRf6z4g+zhdpdKVM3c8gK17XqLWLQtLI+1apjjUKXBOVdtCuBg6k
	geWcPykIA1bfGXSgKlCNR4A5Qpf8MiQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=lAw81lEF;
	spf=pass (imf10.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.167 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
X-KPN-MessageId: f6722ea7-8840-11f1-b2a8-005056abbe64
Received: from smtp.kpnmail.nl (unknown [10.31.155.40])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id f6722ea7-8840-11f1-b2a8-005056abbe64;
	Sat, 25 Jul 2026 17:53:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=QyDxN4rb6c/XRh6ApxXaUggDqwL7NriZKZmwb5ZGNr0=;
	b=lAw81lEFK7S9f/rACqMC/NqmXpYceCpp5cH4vJ17FvnFfPJM908eEIZcgO33m1NYJhLir3B8hfMsB
	 0dkpvjnE0hnL9kyqyJyNFPMyCJJdOXTgIH+3zsUFA4jXjzs8K0WBOWiw9CSqmJ2HkU0Ct4SV+hSldA
	 BxXnVgw/2AiYdKSW+IilNNRFCfuWHxNB5L1BvtwlniHDxXJ1x3GWWxhXVjIIX9o1tZxFwFM65UsZPh
	 MBrAewgAs75Tws1Do3y8QvZgjbSFF0kJmccTmy0BYkvRYLnZxgq5FEpCWTUwxCTbm3p5aMsbq2gsxb
	 qokfxdwaD0FyXEq7mN1UfwP1q4uU92Q==
X-KPN-MID: 33|CbsXFLwPkiZSid3jhTG4eAoG0+HdmFlqVyytflOBzhjRucXogh53OgyTaWYhr2X
 c/37UxYIHX+rJYsSkSZfJ9cq1z1O6hnTsvUIarb8UqeY=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|M10uTIOs814OUqOUH87DCyajQ3CPn/5g9oXhZWYWkEj+J4yUp3ywRikiaVEN3cF
 Wpx7wnvTeXEjwz9lyCBzNcw==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id f63a02e1-8840-11f1-86b1-005056ab7584;
	Sat, 25 Jul 2026 17:53:21 +0200 (CEST)
Date: Sat, 25 Jul 2026 17:53:19 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 15/24] binfmt_misc: return errors directly in
 load_misc_binary()
Message-ID: <amTb6I6mG8HcaG3y@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-15-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-15-a162f7cb58d6@kernel.org>
X-Stat-Signature: 48szo9f5b7e9doswn7bsjaiuddsg8cia
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 99DC8C000B
X-HE-Tag: 1784994803-953603
X-HE-Meta: U2FsdGVkX1/Uutxq5Ra2MTBz7h4+nJ/C0iUepa6kDe1LdvoV768bLmaksKRzPoSB7vXE77OAUjxbDy3x1VyCs/frwKsf2L3dtxSypSyULtDJwLX04h4CHqgYefI2KtaicIqW9UAwK6aov4pOQNSZ2Cdl+eEjiYLPtN/hDh/6omuI2Gj4LCA6HStyxeAZCxY0It+RHaBr821EjbDWCKo5LHd42dJ4vEH8OH7CIJqQ8t7uQyeKThGB+yvtfbTL+tK52r3JcDoJHwh1TidkqDHxYRPhuL1yBkfARfAuyURACtCr7MH98BbFu6FJbVR7CX8nkHiynrb40XFFZslc3ype+wvYBbrc+nWwoM20uwXn8UikXYfE/ko5ZEu8jNc6eU9lSg2j41fQ45Oo9tqo+7wrkmMdqUHCG5HpGTir4CUz+Nr1DmhYu32X2yZ53gul8ybmA7a20fCdvRzSUBlVse51DQAsvPO5/knUfPrLsd3rTHPvRFl6HZn2CPeNeDtnPVzSuZFvwKct1cY4lCwna4EZXdhZi9HkoGV7fE24ELTkzfD9UAuoHMyYfVTRpXI4NrOCg4GwCg/OlwzFwi7KWUfZsntJxqtn5xYK2gch4d6xBR582b9GmrBDx37CsVBI6km8GQ5SzNAv6EiQPfP0thX70X17oqotc6mVHysKo+lcE6fcaqQOMKiMvC0zRKx4W+LPv8adH4l9l5OgcH2EqEBlNK+2pd0D6iqsGAYlIsp+FfPIYEXiWiq5saD2o/4L6zk5wTj6L6xoWwYndZVeP+ZTaykE1UfYlkiESxwZ9yHRRQWISKg4VpdKkbJFpiWGUOUyWy2l7orol7EQB2Tulz2JRj/fELm0YD/4Nklx6sLQ4mGLp3WtpvfmOU356vDNq8tlO8ir7lM101kO/5yTukiRV341GCoA2ZAc4J9/QzjJszSk/MzZD8rcSRPUJGIw1U0vDqwYd09XKPYDqeNFsP+
 fTtsGmRz
 c9y8sGOqM2wxJx1J143D8m1OYG9Lsd111CotiFkJqDuxwfUqRA9cfo2oQ9vc+OCPPmN9W0wHmWiNeq/Tgj4wwGB2q3G/mM3WvlnmRPCkF+cH00i72c+iDxgnxKstZTveWb8+cVec/GRBSrFXC9cy2YI2wy/ywLRu4QTOWsug7hSAi+LXQRFFZ+oF3/F3FaBSJyB0T+fR2CEOdRocnA4KS2+wOL7DJZL4itZQKsBMkgx8ez5+f6A8ilprCao84h1Z8pMqzUDge7PgMKqYFIRLySTov+GInjQNH+yn7keidncAxTVp9Wunh8aX3rD0s5AkoEp/Al/w0t2cgg5h3HQm/tl0vr/EgNnmC7rOOdRnTKYjT5rCmQxhRecWgQHgvtBoQZ8CtMXAssPBkCR3XBNOakxuBCoN/HJjc0acfZTAEnlLSvHAR2cqbP8VcpU3RoF3SITZ6f0ipW/92qiuCeoK9NKeeMYgVoyotK+RUMq9d+qdG3I15sZ8quT9gAozMZ7I5VM3B5xLNWtUdPLbXRHu7pNgMQ9ruL/05e0FLHQrgYthcmVYSc9ZNS1BF/gFlx1CrNSYmOZmnerEf1oo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:16AM +0200, Christian Brauner wrote:
> load_misc_binary() seeds retval with the error for checks that
> happen further down, reassigns it along the way and funnels every
> exit through a ret label whose only job is dropping the entry
> reference, so figuring out what an early return actually returns
> means replaying the assignment history. Give put_binfmt_handler() a
> cleanup class and take the reference with __free() so every failure
> can return its error right where the condition is checked. The
> comment at the label restated what the put_binfmt_handler()
> kernel-doc already explains, it goes with the label. Drop the dead
> NULL initialization of interp_file which is assigned on all paths
> before use.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 41 ++++++++++++++---------------------------
>  1 file changed, 14 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index cd5dbf61771e..06f4849cf1ad 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -183,6 +183,8 @@ static void put_binfmt_handler(struct binfmt_misc_entry *e)
>  	}
>  }
>  
> +DEFINE_FREE(put_binfmt_handler, struct binfmt_misc_entry *, if (_T) put_binfmt_handler(_T))
> +
>  /**
>   * current_binfmt_misc - get the binfmt_misc instance of the caller's user namespace
>   *
> @@ -215,30 +217,29 @@ static struct binfmt_misc *current_binfmt_misc(void)
>   */
>  static int load_misc_binary(struct linux_binprm *bprm)
>  {
> -	struct binfmt_misc_entry *fmt;
> -	struct file *interp_file = NULL;
> -	int retval = -ENOEXEC;
> +	struct binfmt_misc_entry *fmt __free(put_binfmt_handler) = NULL;
> +	struct file *interp_file;
>  	struct binfmt_misc *misc;
> +	int retval;
>  
>  	misc = current_binfmt_misc();
>  	if (!READ_ONCE(misc->enabled))
> -		return retval;
> +		return -ENOEXEC;
>  
>  	fmt = get_binfmt_handler(misc, bprm);
>  	if (!fmt)
> -		return retval;
> +		return -ENOEXEC;
>  
>  	/* Need to be able to load the file after exec */
> -	retval = -ENOENT;
>  	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
> -		goto ret;
> +		return -ENOENT;
>  
>  	if (fmt->flags & MISC_FMT_PRESERVE_ARGV0) {
>  		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
>  	} else {
>  		retval = remove_arg_zero(bprm);
>  		if (retval)
> -			goto ret;
> +			return retval;
>  	}
>  
>  	if (fmt->flags & MISC_FMT_OPEN_BINARY)
> @@ -247,19 +248,19 @@ static int load_misc_binary(struct linux_binprm *bprm)
>  	/* make argv[1] be the path to the binary */
>  	retval = copy_string_kernel(bprm->interp, bprm);
>  	if (retval < 0)
> -		goto ret;
> +		return retval;
>  	bprm->argc++;
>  
>  	/* add the interp as argv[0] */
>  	retval = copy_string_kernel(fmt->interpreter, bprm);
>  	if (retval < 0)
> -		goto ret;
> +		return retval;
>  	bprm->argc++;
>  
>  	/* Update interp in case binfmt_script needs it. */
>  	retval = bprm_change_interp(fmt->interpreter, bprm);
>  	if (retval < 0)
> -		goto ret;
> +		return retval;
>  
>  	if (fmt->flags & MISC_FMT_OPEN_FILE) {
>  		interp_file = file_clone_open(fmt->interp_file);
> @@ -274,27 +275,13 @@ static int load_misc_binary(struct linux_binprm *bprm)
>  	} else {
>  		interp_file = open_exec(fmt->interpreter);
>  	}
> -	retval = PTR_ERR(interp_file);
>  	if (IS_ERR(interp_file))
> -		goto ret;
> +		return PTR_ERR(interp_file);
>  
>  	bprm->interpreter = interp_file;
>  	if (fmt->flags & MISC_FMT_CREDENTIALS)
>  		bprm->execfd_creds = 1;
> -
> -	retval = 0;
> -ret:
> -
> -	/*
> -	 * If we actually put the entry here all concurrent calls to
> -	 * load_misc_binary() will have finished. We also know
> -	 * that for the refcount to be zero someone must have concurently
> -	 * removed the binary type handler from the list and it's our job to
> -	 * free it.
> -	 */
> -	put_binfmt_handler(fmt);
> -
> -	return retval;
> +	return 0;
>  }
>  
>  /* Command parsers */
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

