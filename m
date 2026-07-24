Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0BDDC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 14:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3716B007B; Fri, 24 Jul 2026 10:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9639D6B0088; Fri, 24 Jul 2026 10:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C786B008A; Fri, 24 Jul 2026 10:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 531ED6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:56:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEA6DC03D5
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:56:32 +0000 (UTC)
X-FDA: 85023971424.04.0590A71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 03C5E1A0011
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:56:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bR89Uyd/";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784904991;
	b=rK7Mx32EEdwG8IU4mTIdlJtHGl4BT5kzbdvjqOHdg+Mz1w5xhMH+acg06KIEaiZYhGAfxP
	WJLYgo70/NwV3iazwhd2ixnxwtCJhKPMYV+P//l/HPqZnZ8DVUJ1iZcuLWNQdjxTVMFs0n
	EPeL+i+FILyH6yp8YjjhS5iHsGtTMVY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bR89Uyd/";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784904991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiA6gXTuTGgHW28jlCoj+TMMGhFDB5U5k/MPS6FjwGg=;
	b=gdPFCgN4jbPn0iAPVmt/AjKLsS4MillB2KbvR6lLoiEaA5hYzS6kXiuwvhgbgkmgFTGx2s
	Jqzt5WAQUxC8Xk/rWk75UXVRp0AscNJ19ars2k/zhsCIeN+D2N/VyVTUGvWFO/yEZvACQ5
	Q5XNWnuolWoRYiAuRpcJTMPr5nzgSVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24E3143ADA;
	Fri, 24 Jul 2026 14:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F1A1F000E9;
	Fri, 24 Jul 2026 14:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784904990;
	bh=JiA6gXTuTGgHW28jlCoj+TMMGhFDB5U5k/MPS6FjwGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bR89Uyd/XgB4oBVh4s0lK8ELkkaAN+12cpSPi49dnRldX1bdswC+CnbYQfU90xzYV
	 Tbh72IMrIgWPAj0dEi/aR+lfmdDrpNI/TJJVMuMQUTCKVdM2NCvz5xK5gDRr3kQjIn
	 8CUL3N6wVpkg0qZGkoVyDVr+k743IfqtGsRbVSb5rgEmpoLIpOYy0pkvKhYT9eoVWf
	 nowmH4vDHueWAQAESjh/5vi0H3SDonbhTpqJ9357TyZFoYcES0t2ZiOnTJKEyVtfKp
	 z1sCYa4F5jI6ban+BjGttzEZwHsNxGduDi4+MYwnU38rf46caVB3+lIvltJZJVJnLn
	 C/TiXP7pFsvbg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: dayou5941@163.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/damon/ops-common: factor out damon_putback_folio_list()
Date: Fri, 24 Jul 2026 07:56:19 -0700
Message-ID: <20260724145620.94967-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724143917.94375-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 03C5E1A0011
X-Stat-Signature: 4wcura8n8u917mzj6spfwpw6inyamyp4
X-Rspam-User: 
X-HE-Tag: 1784904990-753961
X-HE-Meta: U2FsdGVkX1+0K5daqiXeVUViqWFQGdpc4T7p1SdylvQW3RIY/AqBMbkizp4tlwKtGQBCgFcZOsJJID+KfEPmx2qDuqMdUWC6Ge7C737vlGyPcvD0q+/4eU/LITIEkZdX2pXHicEu2n2pjg/gWIq2LdtvVY77mYapM0hVCPQyU3yRovxM5m9MjZE5pFMwBz0ZgIthTYzIoqgzlTlFJjRDAcmXgVGlssqLyWLNXHOgBwTe3PkoFi3ZjgkWz0Djb2uazGtBZ0FDtRo5+BQ6+h8pC2dXQU6az+0ggKJpB8eWV4YlhJn9EM64ErNSmdUKjlCayBb7DHiQXkoqACZ4Rw8qtlpVhqBFf6Ng6hl+GftZegjYxTiTLX4+HmZELpCxWUQ7yeJRM4vl8IUlANrOob8hzRRqi+FocP2IboR/Oh/GDAmuM1D3IBv+cLZVVhENrhPpFx9bcIBXYUwkxM3uHIKlenqhPyZ/rZrUfPVSIo07zMVk46r+xQ+6gKKPWfqwCNA2/wdy2sG5Jw26RqZ2mNarSVOosP4WAQ5UI5t09R7UhKJ+KsHbULmNZ43Ai3kCYfn7bIls/+YE1h7lSrApVML9o3mVd39Q8FkCC+mx9gz1f184CY3JyB3fZs4U3UUrEU9PFQNwmP9A4KO/kxul3GA6dg17ZFKlMGNLRLcAID1URSSrNCsxfdj6EfC2CYwsJ3Q1lnBhs+GC/Zl9T79XJ55rmWE/BG6rda2mGXbcOPeMiyJoqMDnanhfbuQBSrXt+oCdLho8e1p/gvrMgLW6SQVmWo4hZfJMhh0RPq2PwbUoajHlG11ND1R2/muk3MnHypma0sCikF3l3QUzD3hVDbMBci/oDiqzmoCibntABCQjgkdq4vQ9QM5lm3W6OAY5eAh/7vOG9k2k8FPp8xQJu5KdkotFDmhIf2m6rfnm6+VHBcVkQD7J7qBS2t8Irfh7dKodygVx1EpvjuxvYgDX3lX
 n+edU3LJ
 s2tvRCXimMTrGHOwnieaZgoov8VkJFD8b7/EtwFIFgQf/d/x4zzHEq5xexSXV7OAManZwIZOuPkM22SAJhgle3qF0volHD+ou+RIjsG8Mars4FNXAnYYgizrGIjXWNArDsOH1bn68OPftbvr0M3WljmUT2d1usuddYZt8Zu/bRyhD2vWjnicbfGLyItaY3LQljq7/S5xL5/nmz+ZoPJsUeJPHvlgtjJgjEqqke8e/jk9Rk3eF6O09r4d/CnsB/5PW6ytEff2FpcIxCK+okKil85Li1+ZLqJHE9gTRWoocuz3I/qGdcmdeJFsSO64BgnZDp6y6Q8iuI6wP9qV9EgpTNndr71myUHpceG/Y10vFFZuQMM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Jul 2026 07:39:24 -0700 SJ Park <sj@kernel.org> wrote:

> 'get_maintainer.pl --nogit --nogit-fallback' suggests adding below recipients.
> I added them.  Please consier using get_maintainer.pl from the next time.
> 
> - linux-mm@kvack.org
> - linux-kernel@vger.kernel.org
> 
> On Fri, 24 Jul 2026 14:01:35 +0800 dayou5941@163.com wrote:
> 
> > From: liyouhong <liyouhong@kylinos.cn>
> > 
> > The putback loop is duplicated in damon_migrate_folio_list() and on the
> > invalid-nid path of damon_migrate_pages().  Factor it into a small helper
> > for readability.  No functional change.
> 
> This is not a hotfix.  I'd suggest sending this separately, not together with
> the first patch of this series.  Sending hotfix together with non-hotfix when
> they don't really need to be applied together only makes it complicated.
> 
> > 
> > Signed-off-by: liyouhong <liyouhong@kylinos.cn>
> > ---
> >  mm/damon/ops-common.c | 25 +++++++++++++------------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> > 
> > diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> > index f5ded45fabd1..9a1e8aec5444 100644
> > --- a/mm/damon/ops-common.c
> > +++ b/mm/damon/ops-common.c
> > @@ -331,12 +331,22 @@ static unsigned int __damon_migrate_folio_list(
> >  	return nr_succeeded;
> >  }
> >  
> > +static void damon_putback_folio_list(struct list_head *folio_list)
> > +{
> > +	struct folio *folio;
> > +
> > +	while (!list_empty(folio_list)) {
> > +		folio = lru_to_folio(folio_list);
> > +		list_del(&folio->lru);
> > +		folio_putback_lru(folio);
> > +	}
> > +}
> > +
> >  static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
> >  						struct pglist_data *pgdat,
> >  						int target_nid)
> >  {
> >  	unsigned int nr_migrated = 0;
> > -	struct folio *folio;

I forgot mentioning this breaks build, as Sashiko also pointed [1] out.  This
patch cannot be applied as-is.

[1] https://lore.kernel.org/20260724060707.CE1F81F000E9@smtp.kernel.org


Thanks,
SJ

> >  	LIST_HEAD(ret_folios);
> >  	LIST_HEAD(migrate_folios);
> >  
> > @@ -374,11 +384,7 @@ static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
> >  
> >  	list_splice(&ret_folios, folio_list);
> >  
> > -	while (!list_empty(folio_list)) {
> > -		folio = lru_to_folio(folio_list);
> > -		list_del(&folio->lru);
> > -		folio_putback_lru(folio);
> > -	}
> > +	damon_putback_folio_list(folio_list);
> >  
> >  	return nr_migrated;
> >  }
> > @@ -395,12 +401,7 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
> >  
> >  	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
> >  			!node_state(target_nid, N_MEMORY)) {
> > -		while (!list_empty(folio_list)) {
> > -			struct folio *folio = lru_to_folio(folio_list);
> > -
> > -			list_del(&folio->lru);
> > -			folio_putback_lru(folio);
> > -		}
> > +		damon_putback_folio_list(folio_list);
> >  		return nr_migrated;
> >  	}
> 
> Looks better.  But, how about further simplifying it by moving the folios
> putback from damon_migrate_pages(), and doing that from damon_migrate_pages()?
> damon_migrate_pages() would do the putback always before returning, and the
> taregt_nid path will 'goto' the path.  E.g.,
> 
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -391,15 +391,8 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
>                 return nr_migrated;
> 
>         if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
> -                       !node_state(target_nid, N_MEMORY)) {
> -               while (!list_empty(folio_list)) {
> -                       struct folio *folio = lru_to_folio(folio_list);
> -
> -                       list_del(&folio->lru);
> -                       folio_putback_lru(folio);
> -               }
> -               return nr_migrated;
> -       }
> +                       !node_state(target_nid, N_MEMORY))
> +               goto out;
> 
>         noreclaim_flag = memalloc_noreclaim_save();
> 
> @@ -424,6 +417,14 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
> 
>         memalloc_noreclaim_restore(noreclaim_flag);
> 
> +out:
> +
> +       while (!list_empty(folio_list)) {
> +               struct folio *folio = lru_to_folio(folio_list);
> +
> +               list_del(&folio->lru);
> +               folio_putback_lru(folio);
> +       }
>         return nr_migrated;
>  }
> 
> This could be applied to the first patch.  And this patch can simply remove the
> redundanty putback.
> 
> >  
> > -- 
> > 2.25.1
> 
> [1] https://lore.kernel.org/20260724060707.CE1F81F000E9@smtp.kernel.org
> 
> 
> Thanks,
> SJ
> 

