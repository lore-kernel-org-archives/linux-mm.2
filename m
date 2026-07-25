Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA99C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7F06B007B; Sat, 25 Jul 2026 11:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88356B008A; Sat, 25 Jul 2026 11:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53006B0092; Sat, 25 Jul 2026 11:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8156C6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:52:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07E15160366
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:52:47 +0000 (UTC)
X-FDA: 85027741974.04.BC3AFEC
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D2A0A0003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:52:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=HQI6ELAo;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf15.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.170 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784994765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Oe0jnIXRtpZPsHT6Iavl/LHj6/KkV9pYh02KESLWzc=;
	b=CFBI1G1iHZ9NAdkScInssPlYjfFnQpwN5uwFhIv802CR5lhuZ5INCxsvLcYCKcq6Hnq9CW
	nU7sOCx3dlOBja0KZzjf1TYwDoIDa8rhxnOakj4rFCH7L5OwA1veKNrFbkSZoBgIdmw8c2
	cpJxcjdLi6Xu5lUSoLQ6hYXTWwbSsfs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=HQI6ELAo;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf15.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.170 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784994765;
	b=OfRXYLfkZnzoR1cEvWjuakJhqBH3DPz2B50vlZIXEfUyvefzHAtUiXBkRlqVb5TJlUFh8m
	1feK/YY1I03kcdjhiLV6xuf0iFg/9dvhC8w1Bf6sOvt+ykbLyWTj/2ov5QmT8vdM6rKxXo
	9WkO7qLJw1kxNvlEjf8aa46N1gRn69s=
X-KPN-MessageId: df272e7f-8840-11f1-83b3-005056ab378f
Received: from smtp.kpnmail.nl (unknown [10.31.155.40])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id df272e7f-8840-11f1-83b3-005056ab378f;
	Sat, 25 Jul 2026 17:52:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=+Oe0jnIXRtpZPsHT6Iavl/LHj6/KkV9pYh02KESLWzc=;
	b=HQI6ELAo91lZBncETmbv37Uo0ySFUFWrXrWq0sYyyXGyx0prLCNPx/RIWCXLN1L5S5ltgD2fmSVwG
	 n9NoGvy8SWb8GIhi466ZNgGnt0NaNP+A/S/MCjkA7rbKeS2KRQudDrPsfd51gxG72hoIyboqRr7cSv
	 12MKXGcyvi0ouLfjypEnCR3m2ftahzUCJrCZm08rnu7Uzw+DP24ugQlF1sSmwYPdNtO8rsH7f6RSxv
	 OwaZTS7eYa/Yc+CsAyUAWSlwn3T5Cl7C++lGT1KZNGwrSMPpdpG/WyBYF5F2Wrb9sPdALqOUNlTzYo
	 86v3FI94WkyxCsqYqgxcY5eXh0rwJeg==
X-KPN-MID: 33|TD21L4c0WDJVGaA49Ef8ARvm1SU68dN1K0LC4/VDeL08o6YCqtkCI1wF6DExL01
 Acl5Bpjh+HYMdOao0+997KXxp9rNqEkFIGpgULhMmFqg=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|gw/haAHwblGQZopLI6Q7IitHaF5BrKRCbX16+2hc+eQLblxd/5j/CHo3el08DmX
 EB7qMIxT3Zm2SHLV8zumHrQ==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id def9a23c-8840-11f1-86b1-005056ab7584;
	Sat, 25 Jul 2026 17:52:42 +0200 (CEST)
Date: Sat, 25 Jul 2026 17:52:41 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 14/24] binfmt_misc: rename load_binfmt_misc() to
 current_binfmt_misc()
Message-ID: <amTbo4nGAcE4F6Ey@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-14-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-14-a162f7cb58d6@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D2A0A0003
X-Rspam-User: 
X-Stat-Signature: zey74nsg4d1q5p5pcyiqzyoy6mkqjh9p
X-HE-Tag: 1784994764-869374
X-HE-Meta: U2FsdGVkX19FWqI+D7nNkfxjymSpLDGOdG7xyGV2961cpbe+OqIv1vvMvpvNfJzsW9kJaBsYEukDvuMsmQ8f7i8ABf+G3r1Sts0khnraLAgrsRv1JpaizGGzARaPp9E8GvQOOSvcFtq8E7j/OoC0/GujAP0eUJc1fMYCUU3b3hgzDK4qvUVgPlovVjCsmt3oFObEGCodd4ZktjNBN2q6zFsd+B7DhMFJK60lS0ENvLWGloWUHOcysy6E9vNs0kyATWaLFTloQqTle553Vv5j9/chhmVBsMNcTIcKO0afuNHuKu5uxK2lfHk6TbBcB8YoCsIqB9KCfKoC1e5MoTWmUWWXDbseM8QBYEISYWktE2YUpHw9kccOGIognI2gBlMNgVQvzv4pgGxqa6pUCDhl72f7TIQ5p9SZg5a3VND8VR1bbPPuak7SCjL3eNXXhKs0GtpideWLCfJ5CkDrwFHJjdLl1t8p9SXvJoaA+ZdXj77+7SjXQW4zjmxoNHQJPUGQJlylqATpXzDoJ3v8SgF0M2/gBsfJk4ScQhpgBXdyK7+KqeI9/o+3P58enaB9wS23S87WCbpLQPxq+kge2V9Cj3aKpTTfBE88UDs7xQeF5Qsqu/RC6SKiFSWqXS25t38f2kdd7gv4SYhf1JwQWzkKXHKRVi42bEgIieal+9MCpM+5U+czbUBgF2BbP244FEgF05dYIC3nl8mfmX3hwRIj6G3rfxjOwrsg+KwdGfexXtN/iA7YhIvMWdwv6AZssxMUkhoSytujf273iBjXTLTU5rO3oI0tbCnqa2kRD07FPb9EnmYY0olarvunA2OA+PZN+mX9drGq0pxl49djlnLAUlyi9GCH+9mKasY3GYwFahIpX2rn3zu1NPZLiU1F7Gy/YE2Yrnr+lsiWC6tHnP/bsZguLo82n9rp+d0/WslBuRp5Fu+xd3j6kMXNh4S1WGuur4KTfpcyJeWZbtO6M1f
 x/WIC/YE
 Vd449KjQWJiQ6G+4jPYqMHX1ObrhyxNUHxEFezcAb0GZUyJViBMTnAu52MK3Ij6TepWF6/hM17YgNPW4PFfxJvKPtP73SIKYx8usTCHXSpmQpmgRZes9nyeuutd3qQpql4yaAUYUmfRbn4RthttPeBYyLAPkKrxCsMV6X0IPEczkw6gCr9oAkWO2MN8kbdjCGJx3K50KMB5HcNNbQc00TLypAEev9OatRSjwKcpSv8A59BCj4UUeRz/2bP+0QyEhPLmjLuKHqbkt7GGZehMjplFfunClGF9wnNfdh6vo6yHru2dulzMCjWLV2uRuG/vRsSi9K8K+ihmvoVGA6od3NS1R/yhR0J1Boa3Xb2kuSq3vJ/9FCsqwZZw/Np77rE5fgHA2wRPaJovPvlmKHzUJqdLDWNq6eWNeWzHmnAxWM94XZMAV1PDjOtt8w0TgB1pUfmEB0MrbjDNc+XAOWUuA0UG5FMNYVtqD8zTsdKOpMvs16+uux6IUMQBnGetd4AA/YANzuyT0fkU7RF0+DSqv4zDgEfehNX6ORNQO3p52r6pqTh5T7hlJCbFDGBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:15AM +0200, Christian Brauner wrote:
> load_binfmt_misc() is one word swap away from load_misc_binary(),
> the binfmt loader it serves. It doesn't load anything, it looks up
> the binfmt_misc instance of the caller's user namespace, so name it
> after what it returns in the style of current_user_ns() and friends.
> Tighten the parent walk into a for loop and fix the stale wording
> and typos in the kernel-doc while at it.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 6a56f40f23ae..cd5dbf61771e 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -184,29 +184,27 @@ static void put_binfmt_handler(struct binfmt_misc_entry *e)
>  }
>  
>  /**
> - * load_binfmt_misc - load the binfmt_misc of the caller's user namespace
> + * current_binfmt_misc - get the binfmt_misc instance of the caller's user namespace
>   *
> - * To be called in load_misc_binary() to load the relevant struct binfmt_misc.
> - * If a user namespace doesn't have its own binfmt_misc mount it can make use
> - * of its ancestor's binfmt_misc handlers. This mimicks the behavior of
> - * pre-namespaced binfmt_misc where all registered binfmt_misc handlers where
> - * available to all user and user namespaces on the system.
> + * If a user namespace doesn't have its own binfmt_misc mount it uses the
> + * handlers of its closest ancestor with one. This mimics the behavior of
> + * pre-namespaced binfmt_misc where all registered handlers were available
> + * to all users and user namespaces on the system. The init user namespace
> + * instance is statically set up so the fallback is never reached in
> + * practice.
>   *
>   * Return: the binfmt_misc instance of the caller's user namespace
>   */
> -static struct binfmt_misc *load_binfmt_misc(void)
> +static struct binfmt_misc *current_binfmt_misc(void)
>  {
>  	const struct user_namespace *user_ns;
>  	struct binfmt_misc *misc;
>  
> -	user_ns = current_user_ns();
> -	while (user_ns) {
> +	for (user_ns = current_user_ns(); user_ns; user_ns = user_ns->parent) {
>  		/* Pairs with smp_store_release() in bm_fill_super(). */
>  		misc = smp_load_acquire(&user_ns->binfmt_misc);
>  		if (misc)
>  			return misc;
> -
> -		user_ns = user_ns->parent;
>  	}
>  

Maybe a WARN() here?

>  	return &init_binfmt_misc;
> @@ -222,7 +220,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
>  	int retval = -ENOEXEC;
>  	struct binfmt_misc *misc;
>  
> -	misc = load_binfmt_misc();
> +	misc = current_binfmt_misc();
>  	if (!READ_ONCE(misc->enabled))
>  		return retval;
>  
> @@ -983,7 +981,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
>  		INIT_HLIST_HEAD(&misc->entries);
>  		spin_lock_init(&misc->entries_lock);
>  
> -		/* Pairs with smp_load_acquire() in load_binfmt_misc(). */
> +		/* Pairs with smp_load_acquire() in current_binfmt_misc(). */
>  		smp_store_release(&user_ns->binfmt_misc, misc);
>  	}
>  
> 
> -- 
> 2.53.0
> 

At any rate:

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

