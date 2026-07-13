Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 135B5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D676B00D5; Mon, 13 Jul 2026 12:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173B26B00D7; Mon, 13 Jul 2026 12:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08AEB6B00D8; Mon, 13 Jul 2026 12:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4A096B00D5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:22:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1B46168F57
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:46:53 +0000 (UTC)
X-FDA: 84984181506.11.50DAA91
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 90B39C0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:46:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=rpUm8oJ5;
	spf=pass (imf22.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.186 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783957612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hUxVYFht1tdb/sUwhOuEe8yDpFk9imzzMyufOuZTBPY=;
	b=OUks6Ad1Ns//skWMGS5g6CtHUHzQvqDlO0F+KTMHhkNOD/sTbdejYomX5lF6Cfwn3prXpX
	EjtGpEY7EwE9aIjru3x6XfXZPswMLPu0+8a4AVfKOA+Hjay2ufOv+yWs3dpv/m+LQR8Ew+
	DjEAf83H/9XfhfrEM8DLSYIg7vMeseo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=rpUm8oJ5;
	spf=pass (imf22.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.186 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783957612;
	b=LbD27izapWh51aWyBQ7cPvU1bTOS+C0VDwLBVgcfAxtAoqpZ9ceft6xkaHNl6W9CepPCaQ
	aIThBkENIbp2dzZZABbyiSUXdDMKAcf6yfu2xFCzxVLMFew7mv69m8/l0jd4qOAd9jk9rl
	NwLhraG0d12sN36uHViIvmD4Q5rnsY8=
X-KPN-MessageId: 0fa2a740-7ed2-11f1-bfba-00505699b430
Received: from mta.kpnmail.nl (unknown [10.31.161.189])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 0fa2a740-7ed2-11f1-bfba-00505699b430;
	Mon, 13 Jul 2026 17:46:49 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 0fa15743-7ed2-11f1-ae77-0050569981f5;
	Mon, 13 Jul 2026 17:46:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=hUxVYFht1tdb/sUwhOuEe8yDpFk9imzzMyufOuZTBPY=;
	b=rpUm8oJ5V8u8CNYpnH7rK4LSR5HlcRAdD1GbbhbmKhmAAhHvjSKvEIe/y9bk+4FJfX0C8LB1hVG/+
	 EgrRQ2ZESYUDkxzMOtMOxGcn9zL0wz1AjaYTQu08blaWURC4y9xA3CzJ6sirdVNxnQrPy3qjHzZZgG
	 ocFDF+2vwhhfP7aYoT1jTeaJnJCiLm0RNyr9fClI4mD86haImeCxJNWbmE5VKGqM8zYs3/kHL74oOp
	 UMNGSuPuhA6vWvVEnQvaWB5RZe/IOYVhfta8FZhhNj2d52j1gFGhEB9r+b9bs/JNtwcAFx7/u6m3eS
	 +gRNVodqP0JvJbttWp8p7B8wHjK+bmg==
X-KPN-MID: 33|tJf6GHfavJYe+yixV6KMl5QCp9MYFWnzf0krHLI4pjDUtje1qABrSYX/sirqiT+
 HSOnyOP8YGhgW5f5eGilcJ1Wao19HjGERTYkpUY7i19M=
X-CMASSUN: 33|IwFtFjTrgl8Oafs6kUPgFfVj910ZH2GzJhZGBERE53rdOPMeERYCAki6Q7IH8h1
 +fFAsDBoebTINIzDmr8QKBA==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh04 (cpxoxapps-mh04.personalcloud.so.kpn.org [10.128.135.210])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 0f9510e4-7ed2-11f1-916a-005056995d6c;
	Mon, 13 Jul 2026 17:46:49 +0200 (CEST)
Date: Mon, 13 Jul 2026 17:46:49 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Message-ID: <1048749513.880112.1783957609482@kpc.webmail.kpnmail.nl>
Subject: Re: [PATCH v3 14/24] binfmt_misc: rename load_binfmt_misc() to
 current_binfmt_misc()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-IP: 178.229.242.209
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90B39C0004
X-Stat-Signature: hxdzmjm7tmxoisspnxfikejepkoyptzf
X-HE-Tag: 1783957611-615204
X-HE-Meta: U2FsdGVkX1/qaIrt+M9Pqg4sMJlnNw/7PetmsoepwwVaaBMRUp7FZe8uOLe6+NhGXBzx+EgcuFirKAbtoT7RsSYnH8XXiRtvb5O3hn/ttLYsHW2X2db/84lnJ/uidXF9kTBUNx1HGOfnctxLwlwiIRWMe2MFj8Bh/4tI3yL/JXSBHNcPJ9UAlUIbvsKD92y1KbztmRKBMsbkunt0XlGHzHrsj2noV6wiX9R1aod6+NQ7+PdTGDiTXGv0IFqwG7NDdkA1N9WwcRGCGZ7KZWjJTEx5aCdLvE2F1BWGwGwBP/PG6GgtAYOv9H7GEDt+imNMR8KB4ft36kzr6/3GLJv9RQuyHdvRvvPtDrj7yiS79m7y1ejT9MoWPBm6O4+duXzuiO5pYbhtiZGUKn7Ch5TrS5apxIiuvo2U6rUm4FQgJ3z7Ww4l+AYJQaxLNMCkCkoprUvOw6wBzsHIps9SLNjF9YJ2AP6sABeuTRbfleDotT++leHKF6QujtfLOfZzxBNhnjldfU1l7oB/nveAMJY9RQ6Ibr7N8tlsJ43Zq98SeltykUQ6D+IHxoTiohtT01McxK4OXHDvMAx6dABZ4vYtLbKAMdPi+kYHUDWjxPKZiCOuIYZd4kjfMPcfVIGuzM/zuSKhc8rZ7FHR18WS61QJs1bBu4jhgGHVuTZMwEZK171iUaxeCKFGBqRvP8ZVYytfajCBX5FqLBNG/re1NxlLTPZSW4F1UFS+jNgzsM/KbUQp157NwQxn1ryfmUoox+MvKkG4Bom/6c0uKXuJhGDu9cVxdgdM3ijJvVQbYB6k6lCIyjPCZY7h48jksPKI/SUyQEuzUDO2/sWZL+rDt7fXMQ6igAZC4q3zyEcP7thpjHsl8VyrLQBU4fj6rnHSw8zMnS9v6mjsytcfCT38uPt0zzIsLRoq5eiNomc1W0UuB3MO2c8juqCjxwW9sDk99FkoyF8n+Nkq08GeqFrTNM5
 PT16JvKH
 ApsUffoYNVVgwuO3vHADz9nr5dxTS43dYJ4ZUxTWleGmBkfIXUtMn7gbE35xuLivb/aWFqRK5q/g0dwosg1fVPn6IqsF2wHH/k1HBNNYV1Pr786DPr+eyGheaNO+IMDCxXyyuN49ysoZ5uMT9hCOA0dwx7RcSpjNIpNliDtFumH2BFdpoUEIl+QWjSrSFwRc2PZU31yrL6MCyICArMZY1PJweEPtuqkZE+jdoEduE4g9guuqMc9erflFJdyZUJFGxCj099Fy6RfIW4CIg6pyPZm9ur7SetjU1fojcsmke654pjM1T27huh9QPlJDQB5oQyFG/q6qLqeqezYuci6Syd3xkhK+46vin3pYLtIXYD7gh72KVGkvylpk4nHcw2patVFvb9LAPxPKRP9fCmJSi5m8uzXwWPhzWZcRigOLSBr1N2TEWFZ9DWCeHQU2E7AS0SXiBiJQ/vu3ooUZhAt0lw1+i7gspQAgs36aRFO5Wg1awExjTaFP4bPdfFAAgWRQuk8Bmt9eXExm2yELONaqZJ42VldFgC6o3rVNbU2jFDzwgDwiglNB07gMU5opc4V1jhybPV7hL910IowQ=
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

Maybe put a WARN() there then?

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

