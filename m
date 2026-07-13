Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40EE6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C956B009D; Mon, 13 Jul 2026 12:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5786B009E; Mon, 13 Jul 2026 12:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E1F6B009F; Mon, 13 Jul 2026 12:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 020EF6B009D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:13:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BEFA5120202
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:04:52 +0000 (UTC)
X-FDA: 84984226824.19.91C8C83
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id B4EEDA0011
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:04:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="bQjhkVF/";
	spf=pass (imf25.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783958690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QyDxN4rb6c/XRh6ApxXaUggDqwL7NriZKZmwb5ZGNr0=;
	b=7zpBcYOilVkMrck//czJhR1yohQCdyibNI9Sv35ECDLk9iB3cb2xCb3ZUMeTe46cS/hhZk
	IR+x7HxvkQG2JB2KUuJp+Pu0tuS2ZwvzaKqi+kx4R9DEaC6l1xBooArNRMGJVpxxgOEjOX
	kNGawiS4XKP0FKaQKfdV+L4b5ZpnsGg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="bQjhkVF/";
	spf=pass (imf25.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783958690;
	b=DtGSOpvEy8+v1bDwi6G9RsIHw/OW6BFOvYHveOoN26hMMHgv/c1VIjDMvWzzpbedrEWkL3
	rsiXPdIeIvXcPXHo+kqxHRfOEBUoZBRIVAsYZYboGbXX+gGul45y+BGsLDhzmnhpooQY69
	231IwhaUQcEPvg7HNiJURtzFtCE4CI4=
X-KPN-MessageId: 92cbc407-7ed4-11f1-a59f-005056994fde
Received: from mta.kpnmail.nl (unknown [10.31.161.190])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 92cbc407-7ed4-11f1-a59f-005056994fde;
	Mon, 13 Jul 2026 18:04:48 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 92caa8f3-7ed4-11f1-b307-0050569977a2;
	Mon, 13 Jul 2026 18:04:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=QyDxN4rb6c/XRh6ApxXaUggDqwL7NriZKZmwb5ZGNr0=;
	b=bQjhkVF/3foAkYKWZM9gG8De2qfD3OH25hbSlUm40YHqaPfmqOKG9Sr2cc7p0aEuOfIIZWMO1KVm/
	 2YJzPvAr/BTgCigqpk+Sy4ohQHjfxYWD49/gDtyjaSFpsGRNXbMh/kHEHMJVH0afaf12/Z015CbhIo
	 gVSdItqHCa65jjLXrorV4c0HPhCCu+lVxPZDCuzJCJBStSyou/oTnNeWh3bGQM3GzTF+b1KLJcZJjp
	 X3q/m1Rq7gpBncM8Rws0/QVuz5UZ9gbOAAOeAPWHNoO4nWEFJ0BHv3Yu/rp+oTLvzx9sfikrYp0nhc
	 AAV+aXr0d4htqk+NZIZn0XUz0mYTjFg==
X-KPN-MID: 33|8ogNYeWAZgjT7SkZzZjdanq6v0VxlLJsJ2kKnB6g2YCeUWVyy60fwDkfpz3wqF6
 lzkztzcHDWCA/N9P7Is8PXcpbMz1zDIJBDEm5qVjtHYQ=
X-CMASSUN: 33|xsZ0uT1g44ma6fztJwKEavrFwzP+rYu77nZbbx2ZlzW4HLqA90ooVL5+wb2a/Za
 hD7KS4+YidSpPsm/jcky0+w==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh08 (cpxoxapps-mh08.personalcloud.so.kpn.org [10.128.135.214])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 92c5c247-7ed4-11f1-916a-005056995d6c;
	Mon, 13 Jul 2026 18:04:48 +0200 (CEST)
Date: Mon, 13 Jul 2026 18:04:48 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Message-ID: <1732140714.875816.1783958688577@kpc.webmail.kpnmail.nl>
Subject: Re: [PATCH v3 15/24] binfmt_misc: return errors directly in
 load_misc_binary()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-IP: 178.229.242.209
X-Stat-Signature: e4isb5xe3hymoct1hgak3ujt4t1ie1ct
X-Rspamd-Queue-Id: B4EEDA0011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783958690-422939
X-HE-Meta: U2FsdGVkX1+m+sQ/vzLpfp5+d4nf+38r1x01MoP/VoJejGE2rupfD4Er3JxtuFH+wT0RV4fQww7jvTElr/svYcUy4HKhHIJyeQLP6rY8AEVnXCZqnD0pupvG5aM0EcT9r5yJeEc4SaVgMpztDONItKG+XdpX04m1SNywOrwerqt3anvx+U8pAC/L6hbchEBAahGEP9pE1EyRqVBA5BLTNZZGlNVQoyBlkNORZNG9pk35ICc15IemxtOutlBSD1kn9ePj2FP+9BSJwwZkrGHPOI/HAzGxgob+qJaObUwPu1sQeNjAbl72SZFPa+qlmRpS0xnbddsYjjBdy+eIsB50U6YSW+X1jwj1yfqGHeD713t14sCWUOWgpO0fLyXcxuL880d5ToSaS2sp3TKWd+cNwVaFKSJCxL5G72/zGzkjmSiPHGZ0WT/UeegyqR21VKSLE1DAyXdGfDd9UHt5lsuxf1s/ZzTtITJ8kHzPwy0vpswJ3l0cf0at5yWCXqz5VG3mB8mECADtncRHEk6sG2DNFJh8H2CBETJfmvPOCmSKaFQel9bfk3CkBRI+y9G3HrEkwChRukutvCnXaCSpSBmKUVMyDOpNMU11lvCLg7r0nld02fI9K4KzRb3Ib6SX46/DZyfHFaWGoUPwkOZW7CJ/k+eLeYNVbM4HxMFLWg3nOLvECvh8x3WivKOspM68vGflQ7ySor1Yp4u5nVVIcs0+sJvhVGSDoH7GclSfMEwisSmmhK0E0olHkrRBeS/5LMqTR0qOCWGQXxlWGJZtf8FhnYJ/WgLXKJjZ0EsttGdCKogNe97x7CtcKjl+2Cw4YTBIv9/UEYM9l0Y3Xtsuk/DtENdQL3hVLIdnMNFNvsfGfEmg17jztD0E9xVtGLgBqM984xn+xZlbmNMC8pOJ2VPKbDfLCg+jF/N/CGju8xGAB4FdJ2kvrdsTiyDTkOnZDdjxOy2DU9Yy+dw0zGjuMLo
 GDbhylM+
 alESaGPwVQ8tlrB08Bu3atBR2kcePmFkvVjEweXWP6LRpiHDnrwIH48GsOHNUW7UYRJs9s2UHxsKFmR/Ksy6ovGCF87q14yVb7cni0RHX3dTF90heDNGmQzxcCTZvMorJlD++5aavLdFr/7kZTncL56OC/QnJkG2a5DuTvuMVJGSfmvERnm6tl8s+rbwaa6vwQJrbevl7Q/IruvAdL5gw6FHO5LOrrM/eaI+/JOF84cL2FR9D9gmfxJ6E4uxo0/A4MUybdTOdUlsT/UkH/+fQv9E1osCM7UDQQeBkMpLCDYDUyiNJ0KAq4tYW78MXsn1oKI03mJgw+y5GxXN2Gdo9MBFt3Fa+V1RPk1F2Fd12cSAOD7gQM3hCwUrnWUIayAfGY6fBpWts1ZXREWkCR/kP2rnWf8TAapPFGKQANzANed9o3GKxJj2/PxBUSRvO3RORA+lLPj/dlis4hoaQKbdxYXahYNsKsnOlWsjo7DQnixPLPNx0nDcTaLD+8ZSyoKHBfBsoa1ugi9OtI3sb+TBTGSz8p5f7Y9xBWLfGpVaqRXM3UOqqYLOxirzhdHsNSNov4GjGeQVigAwaRxi+4URicmcigbs1wC5rjNEe
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

