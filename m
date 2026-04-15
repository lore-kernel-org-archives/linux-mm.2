Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42B5CF43849
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2AD6B0092; Wed, 15 Apr 2026 11:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91C16B0099; Wed, 15 Apr 2026 11:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6A46B009B; Wed, 15 Apr 2026 11:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BBCD6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:31:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BE91E425C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:31:57 +0000 (UTC)
X-FDA: 84661180674.15.5014BE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 61D322000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:31:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=huV9nTg8;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776267115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAmHeV41MzDBWnGtsTbhSmu/azng2XFWfAksIPSDB7A=;
	b=3N/vky5IBOrHd4z0tYfvMduBN8ihkqMdzs9B8mpaJK1yRz5KeGxuLkiKNRshjn5DHUv91u
	RCmdDJLcmwtDZBQDmgsQiAbCtbqkWD0dn89JmaDoPbAic5yASuQv56MwyXSk6JCMIhSkhS
	iFj9e1qMGA59Y9W7/f4g0XtatTZRcKo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776267115; a=rsa-sha256;
	cv=none;
	b=4IVWp1YrZINqH4aW0TH1vCcs12ybyA1ElcZP4wtJpfoskbQEWcwixxFT13AnREp+yG4Gk+
	a39jQWn5BdsaYNesuWcGiDbSXcR7JG+So2nFrjPeqbETsR8DxXZCtWhC0hwePYlb8IT+XU
	WVKoLU4cSm47JSn2Vaxwi5AmR2nAZt0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=huV9nTg8;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1885342B24;
	Wed, 15 Apr 2026 15:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC74C19424;
	Wed, 15 Apr 2026 15:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776267114;
	bh=1tDsvv1sxI2uTzxIZN8RvOiouBDKtDIgWijD4C3lV5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=huV9nTg8aekK7d5lOkB+9C75grBxCIiAGjuPQki4kGPMcbpWKN6eAOk639zsOyUm/
	 uQ44R85keGmZjXXnmsTRhfyRRcXfdSYn505dt/iqmwrosDohP8TYOINpWMFx0P8Gf2
	 O1COgJ/wLLjg4c2GXsbnSc6NAayAawm9tzHvth3yMN49a7NDhKziqa4FY1T93KMvn8
	 RwRVJb8GNXc8m6w7yMYkd840P98m45dHjWQTTG9aHol0nrtBRt7JFN1ZPd6gnV358W
	 cQoi5CEk6dkYmzWlrsXmPYpLEd2NWq4aNUZDtuuUskmaKnH4qTOAppK5TwKTwX1AZp
	 EwFYn8QrBXvMw==
Date: Wed, 15 Apr 2026 18:31:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 07/11] liveupdate: Auto unregister FLBs on file
 handler unregistration
Message-ID: <ad-vZZE88FbfJWTS@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-8-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-8-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: 61D322000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 39ndjqwo3ud3wgsiqps8gwgmaxyrg7oh
X-Rspam-User: 
X-HE-Tag: 1776267115-317256
X-HE-Meta: U2FsdGVkX1/X1eIZZcpDfKDDcUhIS7gkt2YT2nO9UFdYVW1ZpUjB+UVGX9UTFrz3PcjAQ4Czp4gszxpvwI+JbgFU9TJqoO6qjuzdYJm8ZZEBzGhyFbh9ZmWVFUO8/MMSXiXZTns9BodLV06TAkcmjGdD4EACP9Q6l2YBUjdwrFGr0al0kvpzcbDmciev0yYAP4lmVT/pow9CWDyTidaAbBFvaJNombwg5ezKFj9f2PrNr2juhWD6f86LokqefUeQA6L7Nfn7jFapby4MdB5EJ+zYpCDfEee+T5fFBCPEqtayEwMxNu+DqEPQaTHD7vOc4cengxfhUwuppmF5a4pXr0NugwKu3xptl5xT+NwnzI+DY+dgd1Vuj2AM2QUigSC3zhK8QfRbW9fFzpqeOS4BgVJJ+svmzlLH1kzAQVMPoa1UXHhJ8LeuXJhDApZCyB5M7xLvhKVHVnR9jrkU5Sjy5JmVKLVKBJyTVxxiiyS49Z2CzDiD/iuMYiIk2ztZYL29J5xLMuFCVvUavBgc17prDQLtVtK4XTG1slD6H1S1kLJAUh6pa4Y7lz2ibj6iaj0d2I2Lv0vS0AO4nVv0Boa8qWbFmNxfuKPFlZQvXcuzldcTDycA7ObovHEjG8BWSXOz6gxId7o6TTfqjF5sLCS15lDQimZsF/kjAFjs/1WQC96w3n80jDCB+g53h431L6yB0VUFJV43vVbyh7HthXYN9mM9PxYtVVD/B2uQ9Gb/jx6QLiod0DtaWY2xmflzTH7DXUw3kvoEO++0pwC/Gk9jatvEtZCsLGl/ZsBowCDgE7gl2xgsgAYsZdOydYSKG1i2MPLUvV8xZxrSrBWY7DJlF+nnC8xUJ/5Ul6hrZXie3df8Apzdi4m/ufm4eZT8s1r57IWNKBtYg4XtdWy9YtCGp7Zzvk7jmT8fSjlWp0hNb+0mxYibjcJhSG2gLqYSGZ5ljk6FTqofyWaBTGcScpn
 0H2FmN76
 c3psCzA+TpKNnfxVDcW1d9HXHYdgbIi9mjSYtlYM5koomEfJFr7thpyJlCvGRw33Ce3oNDd47CQ+r7wcsuG5PiSZha64nSXp5V+eTE2FZxzxdcys0osW6o/TR+h8HdnzNamX4wVfviM5UVOaBrZBo4KmoXcsGFGcqyn/yEZKBJmVvdsP1JP4gZsdKFj1NmNN0fFBC0sz5N7KAidff2exqiGAOzY4uCQ4Oai0WjHAZDYVITcb8gpK0iXxfojfJpevuW9364oLrrp4ENYyuRSdL5PUbhUhGvCjfkskMMXMhYwzXCiUrVo2olxwVDvXSF2cvWXdGxiYDOstE5QftztQ7DJVrsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:23PM +0000, Pasha Tatashin wrote:
> To ensure that unregistration is always successful and doesn't leave
> dangling resources, introduce auto-unregistration of FLBs: when a file
> handler is unregistered, all FLBs associated with it are automatically
> unregistered.
> 
> Introduce a new helper luo_flb_unregister_all() which unregisters all
> FLBs linked to the given file handler.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_file.c     | 14 +-----
>  kernel/liveupdate/luo_flb.c      | 85 ++++++++++++++++++++++----------
>  kernel/liveupdate/luo_internal.h |  1 +
>  3 files changed, 61 insertions(+), 39 deletions(-)
> 
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 63ddcf6dcddb..b37bd79974ce 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -926,26 +926,16 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
>   */
>  int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
>  {
> -	int err = -EBUSY;
> -
>  	if (!liveupdate_enabled())
>  		return -EOPNOTSUPP;
>  
>  	liveupdate_test_unregister(fh);
>  
> -	down_write(&luo_register_rwlock);
> -	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
> -		goto err_unlock;
> -
> +	guard(rwsem_write)(&luo_register_rwlock);
> +	luo_flb_unregister_all(fh);
>  	list_del(&ACCESS_PRIVATE(fh, list));
> -	up_write(&luo_register_rwlock);
>  
>  	module_put(fh->ops->owner);
>  
>  	return 0;
> -
> -err_unlock:
> -	up_write(&luo_register_rwlock);
> -	liveupdate_test_register(fh);
> -	return err;
>  }
> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> index 13f96d11ecc9..b9f5d452a998 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
> @@ -318,6 +318,63 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
>  		luo_flb_file_finish_one(iter->flb);
>  }
>  
> +static void luo_flb_unregister_one(struct liveupdate_file_handler *fh,
> +				   struct liveupdate_flb *flb)
> +{
> +	struct luo_flb_private *private = luo_flb_get_private(flb);
> +	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
> +	struct luo_flb_link *iter;
> +	bool found = false;
> +
> +	/* Find and remove the link from the file handler's list */
> +	lockdep_assert_held_write(&luo_register_rwlock);
> +	list_for_each_entry(iter, flb_list, list) {
> +		if (iter->flb == flb) {
> +			list_del(&iter->list);
> +			kfree(iter);
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	if (!found) {
> +		pr_warn("Failed to unregister FLB '%s': not found in file handler '%s'\n",
> +			flb->compatible, fh->compatible);
> +		return;
> +	}
> +
> +	private->users--;
> +
> +	/*
> +	 * If this is the last file-handler with which we are registred, remove
> +	 * from the global list.
> +	 */
> +	if (!private->users) {
> +		list_del_init(&private->list);
> +		luo_flb_global.count--;
> +	}
> +}
> +
> +/**
> + * luo_flb_unregister_all - Unregister all FLBs associated with a file handler.
> + * @fh: The file handler whose FLBs should be unregistered.
> + *
> + * This function iterates through the list of FLBs associated with the given
> + * file handler and unregisters them all one by one.
> + */
> +void luo_flb_unregister_all(struct liveupdate_file_handler *fh)
> +{
> +	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
> +	struct luo_flb_link *iter, *tmp;
> +
> +	if (!liveupdate_enabled())
> +		return;
> +
> +	lockdep_assert_held_write(&luo_register_rwlock);
> +	list_for_each_entry_safe(iter, tmp, flb_list, list)
> +		luo_flb_unregister_one(fh, iter->flb);
> +}
> +
>  /**
>   * liveupdate_register_flb - Associate an FLB with a file handler and register it globally.
>   * @fh:   The file handler that will now depend on the FLB.
> @@ -426,38 +483,12 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
>  int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
>  			      struct liveupdate_flb *flb)
>  {
> -	struct luo_flb_private *private = luo_flb_get_private(flb);
> -	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
> -	struct luo_flb_link *iter;
> -	int err = -ENOENT;
> -
>  	if (!liveupdate_enabled())
>  		return -EOPNOTSUPP;
>  
>  	guard(rwsem_write)(&luo_register_rwlock);
>  
> -	/* Find and remove the link from the file handler's list */
> -	list_for_each_entry(iter, flb_list, list) {
> -		if (iter->flb == flb) {
> -			list_del(&iter->list);
> -			kfree(iter);
> -			err = 0;
> -			break;
> -		}
> -	}
> -
> -	if (err)
> -		return err;
> -
> -	private->users--;
> -	/*
> -	 * If this is the last file-handler with which we are registred, remove
> -	 * from the global list.
> -	 */
> -	if (!private->users) {
> -		list_del_init(&private->list);
> -		luo_flb_global.count--;
> -	}
> +	luo_flb_unregister_one(fh, flb);
>  
>  	return 0;
>  }
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index 40a011bdfa55..22f6901f89ed 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -103,6 +103,7 @@ void luo_file_set_destroy(struct luo_file_set *file_set);
>  int luo_flb_file_preserve(struct liveupdate_file_handler *fh);
>  void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
>  void luo_flb_file_finish(struct liveupdate_file_handler *fh);
> +void luo_flb_unregister_all(struct liveupdate_file_handler *fh);
>  int __init luo_flb_setup_outgoing(void *fdt);
>  int __init luo_flb_setup_incoming(void *fdt);
>  void luo_flb_serialize(void);
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

