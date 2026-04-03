Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3BCDE7E365
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 10:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1136B0005; Fri,  3 Apr 2026 06:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178E66B0089; Fri,  3 Apr 2026 06:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6436B008A; Fri,  3 Apr 2026 06:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFA1B6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:17:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B8CBE158B
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:17:21 +0000 (UTC)
X-FDA: 84616842282.30.2440823
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3BF18C000D
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:17:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okwIfj4P;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775211439; a=rsa-sha256;
	cv=none;
	b=xBaE9mboJYjOeRUVs1c/wL0iUBD2miYhxecF8Lv80Dst4CxvBwNhWiynrv8iOQUXSIRhpU
	TkwlrAwzQCXRq16VSClOeIJDT3uVsGk2+6W0Ro91rWbrGbkErI4SSJD61b5eS8k/F7YoGZ
	sKXtvbpj2ZdoWppE+be35yg8O3C9KDo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775211439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlFQh0P6GbnwvheqUCO4RCSbN2lvOgTe9ptYXuR19B4=;
	b=VQe45bXeFwjg6cdqz43YdeLMsHygnIikMJoPAzsKXnHPCu5ug/cry6xDFTE/BBqjlrbL2W
	1SbBy85A/Wx36G89YjDysvpNF6neB4k0SbJ5o2c2VqPXrHPZy2IgQ4cXKd77TYAcR5IAB0
	JdYxdYxEgz0HdU7DWO6V4Kp1TP133+4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okwIfj4P;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 47E2560008;
	Fri,  3 Apr 2026 10:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478FBC4CEF7;
	Fri,  3 Apr 2026 10:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775211438;
	bh=XHL8TaSjsnHgKt+DxB5y+u9IjO2D1o2h4k+YjvwDOp0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=okwIfj4PXWp0FtNFyJm/O1vTiBK5ex1H0qxKdjJfCdQ0DzVeAOTgDrFUNmjJue46M
	 6js9z4Gi942KjxxZSuJ9Q4f21WZiH9CxUp0BIgVOQXvbfQuuzVX2M/HMTwts5lYRs6
	 EUwQl1dKuj+xxeHpafmXiwprFo2N3mgP0SlRFbNJtmKnWY4BEyvE1SW3xI4QNt+yhn
	 SfzRu3aXhvv8EMuhN12AWhHidZn5I9Q+8rC3SSaA88HYWBdjbumKPwG7YrF/y2aVBY
	 NuF3jWEpTTHkdiLgdo+TyS3TSN561vygzK9LTRYP6Lo71JmWTaj5sSgkmUBHeo6/XG
	 c+70RXX/zDSwQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 07/10] liveupdate: Auto unregister FLBs on file
 handler unregistration
In-Reply-To: <20260327033335.696621-8-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 27 Mar 2026 03:33:31 +0000")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-8-pasha.tatashin@soleen.com>
Date: Fri, 03 Apr 2026 10:17:14 +0000
Message-ID: <2vxzika8e4b9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3BF18C000D
X-Stat-Signature: xk7k6wpj56g1rimkkiytrpmgk7w7bm43
X-HE-Tag: 1775211439-836746
X-HE-Meta: U2FsdGVkX18l3j9K0fBY6K7AtQWRXDvqgeM2cnixUL6sJtoT9tjviM86FrDtNU5QwcBSflaNVFXjN+cgK4spVbaQs+IHdcpD8N274s4mpmXz3cKjr+/P7BlTxM0CsbInGLaMVPPakfnzlzb1OQyewoRLHr+Gt6/r9y8WeZ1PDE2NdSA26oQxmQVuBD/Ipb8cck+SdtimuvJr+L8fp0Yy+zwtHaiG4sjWdg1k3IH1n/YJsSWdXQM0snTRQJ+fHHNLoYYK8Fh0fpPyuKBtbcQtKbjVY7YPR8HoL72WNA9Mu4vDM+65PDMs/HQ7YEILagp7V9Ub30jILZI9sowLFnIRWDMmAbwJeDTnYiXVIxPd5Hx0NMBVOJnk9XHiJ0h0/vbjTiS/Qz2p8sS/uHyAtsQRVzazu4uhn+YIO3E2MK9Uik9h+Q+PDURbq40pGhKSr1n+WIYRKxcaEhYvvOh0zG0y3RAPzwG5mM009pyF0WFoq4TWCvj2tIknyHU00krbvJm2o32eRYzBDcUfu0eQoSiem06/PPrgISp908XMEyyukZ3KgBqgLxBCD+zuA1G7bYt7VZsHga/TB13UUgEdyPQasXK9Vmdx9yZarH2gQGXsIvKFMs5j7dL913/TgS/pdR7K2AuqqJCnvsQJ1I4MhI/U5jKmGMt/14TqpAe72gAP+QTPr6QmknMJQsCPEOwWzqQVfC5FyAwWUSdKP2/1hG9kRxMy7/Igcfe1Qz6VulLtHIARNleNO748CS6fOoJTwkfZBY5DfkCwSM1U5jSGORBF4gat3BYl1HCNe8ILqKiQcpfSAwsPxotp4v69zn/mn3Peoou6sjO5F6INHfYUz8TAjaKhtdzx1GVxClroQtg4786h7B9hV0GYIhl4aNCJqYr9JpAKOhKJEpwxMOVShcU0nfaNdYrIZqb6+kwnZxT+RTst83+8qtX2wKIzqDcH4M1SrQgp2dFXqbRP+5zzlF6
 NGoqMfGW
 E015Q9RNlEusiKYir2LmJojgxHyK7fIDO9HB31I08g5yxD4iB5QNlFl7nXkYzFZz5+BsVvDhPKx5roFM0/xS+yddkmljBH7CdKwJBkdZVl7hspFxaI6BKLT7KgU8aAjKCeV2KMQ+n001MjiSumN4p+H9WB/Mtv7eo1iZZlMkVqQjVn/+wtY1nTLei1DiCS/vIRTKiYV23sHQ28HkjyDmtPZa8n5lbRLrWqmG19+/TqqaGEp2VUdFqAR1USg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> To ensure that unregistration is always successful and doesn't leave
> dangling resources, introduce auto-unregistration of FLBs: when a file
> handler is unregistered, all FLBs associated with it are automatically
> unregistered.
>
> Introduce a new helper luo_flb_unregister_all() which unregisters all
> FLBs linked to the given file handler.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_file.c     | 14 +-----
>  kernel/liveupdate/luo_flb.c      | 84 ++++++++++++++++++++++----------
>  kernel/liveupdate/luo_internal.h |  1 +
>  3 files changed, 60 insertions(+), 39 deletions(-)
>
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 439177c10723..80f4e3b796a6 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -895,26 +895,16 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
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
> index ac6fa5b34b43..f8348138de70 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
> @@ -335,6 +335,62 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
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

Nit: it would be nice to have a lockdep_assert_held_write() here to
clearly show that the luo_register_rwlock must be held when modifying
the list. I know that luo_flb_unregister_all() already has one, but in
case we refactor later or add another caller.

Other than this,

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

> +	list_for_each_entry(iter, flb_list, list) {
> +		if (iter->flb == flb) {
> +			list_del(&iter->list);
> +			kfree(iter);
> +			found = true;
> +			break;
> +		}
> +	}
> +
[...]

-- 
Regards,
Pratyush Yadav

