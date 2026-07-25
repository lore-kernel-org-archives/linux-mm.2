Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E5DCC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818B76B009D; Sat, 25 Jul 2026 12:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C94D6B00A3; Sat, 25 Jul 2026 12:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8FE6B00A7; Sat, 25 Jul 2026 12:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9486B009D
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:30:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6B181C04B5
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:30:01 +0000 (UTC)
X-FDA: 85027835802.01.8F8AEA5
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.185])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6089A0006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:29:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=ldVHvzU3;
	spf=pass (imf15.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.185 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784997000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NOBUv49T7ToX/K4H4kKJPsi+EKjIl7Ooc3WRNcdlZM=;
	b=IwxrVQ3YQC7I7T0/wEHSJG7YOZydHJSo6g07Rlq8Iqho8SlisP+c07I0W71dFcUR5pyXEk
	a1/fkWOQH0uc2YZ1ZlZ8iAtvkEqmAbed/43erdMrQYAagDmHEOH+Xq0lZ8o4SW4Fu6Xmbk
	F3Zf1COywpTuYccMh0y//BOOnnZh3+o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=ldVHvzU3;
	spf=pass (imf15.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.185 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784997000;
	b=Yajj6E4l4TVFmVQzwz7cko813HpgW/7UVX9Ydnbg84JUJNAaFBvc7+eBBB+9Yj+SD78BiN
	7ZfMVD2q1/MgxXUP9N/U29PZW3Izi7Vmij/uNSVXMrTnTBBT2ebktFHsphll69BpcpASB0
	WOZ7fFyBeCvx5afP/9wIobvmyVkQ0Vc=
X-KPN-MessageId: 13459b61-8846-11f1-9e8e-005056999439
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 13459b61-8846-11f1-9e8e-005056999439;
	Sat, 25 Jul 2026 18:29:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=9NOBUv49T7ToX/K4H4kKJPsi+EKjIl7Ooc3WRNcdlZM=;
	b=ldVHvzU3DXavEc2TreKqR8kVf5AVNuwEojW2WOFht0LxX1+BthGysSlVCBGMe1RMEjpmqTIoM7Cmy
	 dVSRJPLufhvAdduqe704J/kglRVRWTvQHkK4FSrY1qHa8J+B7sVvGz5OSfDDlbD7GMQURU+nH3eJt/
	 jz/9yLbFNkLMhxuRzoe5eKfPxUHf90EI7u9b89o33b2gbdGZjKgbRX2FxwgIv6lRmpZK9loXFSeuDq
	 9v/kRS6xwrf5XcFfoM+PnPs2bJE2+58DPDBc+1pwONHaECblieXiA6NmR97Qdv9nWhE2306AoqnM4t
	 7H0ji1N30+bx+SgFd3X2fUvqthYMMSw==
X-KPN-MID: 33|CBRkVaaFRB9b3xzdQF5ESsZIRaX8E/Efedu2g3wzDlrEYL54Uo0IaGUfv2DQrpM
 eKzeqkkrdIiNKGO0sLm08m00wfqKoDFJ/trcK1sEdaa4=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|53lsszmG0L4fuDZW6ajWlyv7INCwvFMlLH17wQmkZGInxrTobbciV6WGiwSsUAa
 lbV244g63yzd+/vWi0is3JQ==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 1304f40e-8846-11f1-87f8-00505699b758;
	Sat, 25 Jul 2026 18:29:57 +0200 (CEST)
Date: Sat, 25 Jul 2026 18:29:52 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 19/24] binfmt_misc: use a flexible array member for
 the register string
Message-ID: <amTkcITPlXlFk7VK@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-19-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-19-a162f7cb58d6@kernel.org>
X-Rspamd-Queue-Id: E6089A0006
X-Rspam-User: 
X-Stat-Signature: ii17dqf1fimrseaqd1ogszddumyd3wf7
X-Rspamd-Server: rspam04
X-HE-Tag: 1784996999-678977
X-HE-Meta: U2FsdGVkX1+5KLTyj39xOZXRF4pA4zKHWOc47xZlUkHNBjvyL/TmNK9r/pP2As+pWX+S/gVOECAht6FsrsbIc5vB45lL3dt78hJNK9Kr9TzPXrQNpHTKMbxXN0NHbFFzwlMvBzPBYU3RJ160maf5EPXnmt/kHl1hL/EyLN/qIV4D+G4ZIM8LIgZrZJ9mwsyM4qPRoEqml8A4LWZO6bMRHoEMAXjqvmPIkzzOwwWgbkI5fruFVJcC9Q1IvJEB10lu6fxQLN8CyKJJBzjafAATRWpoa5zbNTjaLlOHbE7CxFiObC/QYdY9MPL9s3Aujr6f+NJJCTjlZadtAjzZ4K5SpoznvPOvdDozSE5CQaqlRXEERxDinLo3CGsjvl4uBAjcskbxyNCQKTU6FffDQ8Ndd6QPkhdToBdUTGCIgNwbOt3vOAlxAF+XIF3QcLFx5uTTjTRz2DDHPNzqFEMJP8Gge4AtiQcSedNgqs0YQAwl3JNbnQqD34Z4p8BTUWJfgtEFFNj6e0BGQaz94b8c4a/KtxsnB/Lc0SIOgDfsZqYvH4YCrL4sU38g+0OQzJ2PrqbIvPHQKK+CTWNQhCA4tRJRY3FIEthOBEhqYCU3RAx9sVpUgayygcfPauXgWYMJlRmwqPcm3L7jtaFJ3KqHuiFJwfEhpTPHWJLupX/1yAoOaVXE5zk9uhoCqtoz3DEdeL/nBcoF4q16pj1ebQ5ZFBiBfEbYgpp6aKwIYzTTbprznxXV4CSaZbG/7jeGqEOxGtOFr7uAWQRAj6oxjKs/02ixy9lxkzUcH98Hwzs3vzwPK+PHh8f69Uj7ek8+I485htEM1BVqYn6lY7eQ3TBvpBW/taUntYnj4xCzLRJpcj9dWexkyqucMDBCbB7XRL4VVhEBRTTjLek2ET2WwoETN0ge1GCaEZGWQnPnac3hDrlsaEd3Uewc4KJOq6U0fOtJDl+428P3vBhzEcpQMaH2MjM
 GjYyKXx6
 BlDW2OzsiOknqjyp2DB+hiC8PQCsAu5obA/OfJCgWHG5mBYTrTmIA+vNmXg9aeMpfQGqnV/Ee+lpu6IGEM/OQTQYSafTejMeWjIy8Nt1FgWQDVC6a5Lp3lNBU/O6dZxxi95TZxEZTlLC4pt7tEZWf4+xJLlYHxObkFfaodHQFNM9XdFXAwk+CaOjRf0m7NTe/30B2zszMnV6ZORyG5cPgKa5KohSaIhOf9ko22gWPhRfUqiJ06HT/ld6Qda7KaPUV2xRWmTmF8c84ewbZNTIe4eutMLn1t14u37ZVIyUJTvx67gx0/6cxJVfC+d7xkn773CLGHnQuVBArSuwphOW3ow8Fx9vr1pJbw24SmVQPL41UoMgUck6k4/BFBiFFA2hWRAReQdCPoIXoF6PERsPMYfKMm8qUMfMb7HnV00pKCSV+1xZCC51fh1IqAFp0aA4dukNjSfmQfX736/hizjoUbYKHo15N+CyNJd3kzm2DeOUJpT5kOw4uD4GNyTrCdeAmxjGqTm8rGjNt3GzzgEgG8C7DXijdb2zc/YIBR8R/7bKQiCWPxpEEPqWRpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:20AM +0200, Christian Brauner wrote:
> create_entry() allocates the entry and the register string it parses
> into in one chunk and finds the string part again through manual
> pointer arithmetic behind a cast. Make the layout explicit with a
> flexible array member and struct_size(), and give the magic pad of
> trailing delimiters a name while at it.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index d9dc9546d199..4cfd3ce5e47e 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -59,6 +59,7 @@ struct binfmt_misc_entry {
>  	struct file *interp_file;
>  	refcount_t users;		/* sync removal with load_misc_binary() */
>  	struct rcu_head rcu;
> +	char buf[];			/* register string, fields point in here */
>  };
>  
>  static struct file_system_type bm_fs_type;
> @@ -78,6 +79,9 @@ static struct file_system_type bm_fs_type;
>   */
>  #define MAX_REGISTER_LENGTH 1920
>  
> +/* Trailing delimiter pad so field parsing always terminates at a delimiter. */
> +#define MISC_DELIM_PAD 8
> +
>  /* Check if @e's magic matches @bprm's buffer, applying the mask if set. */
>  static bool entry_matches_magic(const struct binfmt_misc_entry *e,
>  				const struct linux_binprm *bprm)
> @@ -345,9 +349,9 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
>  					      size_t count)
>  {
>  	struct binfmt_misc_entry *e;
> -	int memsize, err;
>  	char *buf, *p;
>  	char del;
> +	int err;
>  
>  	pr_debug("register: received %zu bytes\n", count);
>  
> @@ -357,12 +361,12 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
>  		goto out;
>  
>  	err = -ENOMEM;
> -	memsize = sizeof(*e) + count + 8;
> -	e = kmalloc(memsize, GFP_KERNEL_ACCOUNT);
> +	e = kmalloc(struct_size(e, buf, count + MISC_DELIM_PAD),
> +		    GFP_KERNEL_ACCOUNT);
>  	if (!e)
>  		goto out;
>  
> -	p = buf = (char *)e + sizeof(*e);
> +	p = buf = e->buf;
>  
>  	memset(e, 0, sizeof(*e));
>  	if (copy_from_user(buf, buffer, count))
> @@ -377,7 +381,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
>  		goto einval;
>  
>  	/* Pad the buffer with the delim to simplify parsing below. */
> -	memset(buf + count, del, 8);
> +	memset(buf + count, del, MISC_DELIM_PAD);
>  
>  	/* Parse the 'name' field. */
>  	e->name = p;
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

