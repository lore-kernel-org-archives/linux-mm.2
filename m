Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4C6CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 07:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30E76B0008; Wed, 10 Sep 2025 03:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE19F6B0012; Wed, 10 Sep 2025 03:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0386B0022; Wed, 10 Sep 2025 03:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA9616B0008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 03:31:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F17C13BB55
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:31:12 +0000 (UTC)
X-FDA: 83872519584.28.6B52252
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9A460A0012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:31:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T2OQ0sxc;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757489470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFHJxuICj98Guwl4fVnasAXJJOBn+5zR++ozDmXM+Ds=;
	b=xJa/hE+fZ7IEsUAwTBkRYuPLA+OsFe1cGHGizS8nyW8V+edi4vYIwtj2jh+FFr7KRKWIqL
	MdibOTFUiI3Bf71m8MVz7440LAQiifny//yDEyfZ/AQ0i1YRmMzzpEGguq0uf6z/VH+qCn
	VHBqpGIe2klmAPlCVf5unI9GzjC3yQQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T2OQ0sxc;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757489470; a=rsa-sha256;
	cv=none;
	b=JEuPPRFd+U7u+Yn8L4xiuUw0YpCa7ztLpAfQbRQGmA/+mfqqk4kpKeMHU6CAZnU1Un9BQU
	uhBeppYeTiqQsxNVos03WJvuciWShF3OQd9KQVpNo4PTrOuJ59L2tit389q+hqaDz2nR90
	0jVfZIc8YJRfxqcymoZ4JwYJPGgKgpo=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55f6bb0a364so6860906e87.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757489469; x=1758094269; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xFHJxuICj98Guwl4fVnasAXJJOBn+5zR++ozDmXM+Ds=;
        b=T2OQ0sxcNT9NfiHN/pEofue2pt5ZMIDX8YyIlVqF5mA98luGEs4CfQCHz6c9DxEp+Q
         9v+gnkQaG8ilvY6zV6IS+qhooJccEET9qjbIF8UEihiq90u4Q55SCE9VB+o6csFKWp1f
         JGH6uCLpVYr+WwiALxFFUz6LrhhO6wp7ymrcY571c64+Q5JHuAEmBz2DN05ktx6aFiCL
         t9vN65hj1CZicfmwQ6otp3Y9mBbhthCgfpEcudJnu3U8QI3dQSAHOIl/gvFWIFT6gMMl
         QTi9E4+iUeDUFuRSUDus39+1eJsGM073UcyPcOplSkmB8PlUeaLJZl0XwX5raiTwyQwD
         g7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757489469; x=1758094269;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFHJxuICj98Guwl4fVnasAXJJOBn+5zR++ozDmXM+Ds=;
        b=sgm6ruqs/IHX3Pu7JqvIGo8W6UmNbMCDGpCT94PPExRCzm5z6Hdzi7AHNqsG0cFXy0
         epM4VRJBxZqxy4DIVMcbQziZ0O8p8ctdTF5zWstFCp2e0UxLqT6eM5QswXTGNj6yeVy0
         5LicWno+BPMYVKt28qD2q8Ktd8sHCWcy7Ri8HRej816PALGQMzD9zb5mhv4w2yUjPamw
         eSLNTEXhKehbr/GbZgwN71TdoGMgLqUwvh1tk5hY9ln4verdlRyjKzs7NeIrfYzcBFLR
         B0JqfSxHIAYqgWwxqTTgCEpP5rz/YI+TxfvpSgX7IfPkF+LtjjIfgcfBMRBShHMNT8e3
         Aqlw==
X-Forwarded-Encrypted: i=1; AJvYcCVL1kApkUGN4g23L9gCEyM3vxfW4FGAmGqm1e63jvausA4fIdZPXaHf5z2aChvd6bxlKLDPQrbUrQ==@kvack.org
X-Gm-Message-State: AOJu0YywDfhTaRAVbs0yuPCyJOq8yzhhOrsj0/Y1E2hENpYkcIPgGZ+F
	0pFDm8C7tOFB7y6HvVyHTYM3wtdVP1qwtaKhd2lluWdvvJKGw87k2Nia
X-Gm-Gg: ASbGnctKC0cb8OoX9q9L3GDAmxLoiQakfsknb23KPeDqwo9MVz842IgCxoyk+17FICq
	o4it4pTooEvLGv5X/MiTKP+z8izON62/5HXzvky8WpYHYIbApzZVNcS/bs9TUO7IZ2EVaTeE7e2
	QpPAY5spACJ29lWbZkS8BakuItyaRntZumHDoiewWj30GDnwMBPl2vQvUvtbm8T3FjQPfL/EDr0
	w8xm7QfFYdB5FLuneqlruIxffQXTI7NJDBMyKv1ufYVmkuAfCDNEBKmKzEwxRjxh0H41zHuEdi1
	jKyvVXaMaEtL9WKLEUMadEjge/dD7zNUleTInseGq4BLvDAuM+seOnWb8xeqfRErFKUVQ1Sc0IB
	cZgVvPRfVxQw+fSbvhB3e9TNSBxt9f3/QLOR6xqHHEmhr0vtpEwCB6mBbfIR9IMr3iWMDTu8=
X-Google-Smtp-Source: AGHT+IEcsyTBCBDDV1Tw1uNbYG7FH9MeVABG6eLTqtCcX6osCxdSBBJoixssy7qrpruP7IVgjHC0lw==
X-Received: by 2002:a05:6512:6404:b0:55f:65a3:cfe7 with SMTP id 2adb3069b0e04-56262e1c134mr4873760e87.49.1757489468302;
        Wed, 10 Sep 2025 00:31:08 -0700 (PDT)
Received: from pc636 (host-95-203-28-174.mobileonline.telia.com. [95.203.28.174])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5695ac78c7asm874530e87.99.2025.09.10.00.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 00:31:07 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 10 Sep 2025 09:31:05 +0200
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH v7 04/21] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aMEpOTLh8EX6DXYq@pc636>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
 <20250903-slub-percpu-caches-v7-4-71c114cdefef@suse.cz>
 <aL7FFpIMmXtzzSL1@pc638.lan>
 <6f8274da-a010-4bb3-b3d6-690481b5ace0@suse.cz>
 <aL_uhPtztx7Ef0T2@pc636>
 <772oyaa3j27tlklhpo6oqxsdtlvsg5goh2opzuig6xvgztgum4@scsoxrgtqm2f>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <772oyaa3j27tlklhpo6oqxsdtlvsg5goh2opzuig6xvgztgum4@scsoxrgtqm2f>
X-Rspamd-Queue-Id: 9A460A0012
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: c1szb19nq5886qohoi69ocy7cfdn6i7k
X-HE-Tag: 1757489470-715101
X-HE-Meta: U2FsdGVkX19Qkq05OlFdnwECNulRVFtOqmD3Qd14tiAErOA5z4PV6NsWtMWJotkGPn5EJCagiwoOBKOM7YuwU73a0iUN43zwto3ffE6gQ2dp/sSwb0HJCG8TghDxsSpTyTse+UJZjBW6WV5hTEwE0N0r4oj65uxZpRDdtkqO8oWCm6wsNkfLmp8wN6R1FIoHpT23U8X9AjJti51YKNUmImPoS7vugRBq+qPmJ+QpMrb0Kuv9a0mVk5G0t+RvO3lJm9faKmagFNKbQ4MRpGn46ZBpq1aTbkAwKXPqZd+1/4ltVARlXXbLM8V8HGUjkyJ4InvesKvj3sjZ14DVHOnbGtUP3bTbsSe9YVGdJzqtU95GziadxjrqoGY09jCEYRfDd6syPE51kETdKDZ6mmEarls+2peGwwPMMEI5y0rd11sLEH7YRK2wjiGLx6leCwOyS+/DwYomsQP8zGoKOqJJFb/iic+ZL6Jc2ZJuSINpI2zCHhQOhrsp8PO1mbrUDbZ7HepPrH4o6pICqfar44hai9HmCqx0F5b3+iK3ks2XdKJ0RQjBhZecIEvc0U3/japw379v9VRSLMxvJ60Gki4WIr0zTQQ0HWNQsNrqLlFosIvx2yL4+9LYMCqaYTfkNLxhksBRjjKctse/Q7avqM3LbmFnIbceQ5G0YXx3vXblm2aZyrDK9vQEK+i0qJbn6OgJ3yhCiO0xPWntNAt/XhHKQFl5uaMBDRHlDgckgaNLRdPKKgCf6J3z24R5WFJ4RJZOcFMgCKzfg5WKnLLMuPuuP2EVwbw6MF3A0ALgFmknX+7E9vQV2PV4qOzIpexcLEHTvlbwS53MBNu60rMDIyYOwsu9NqPD7+fvLTypheWNuFhkJdKvIzDonztht5rQK6kNVVFGmPBhrIa2ReBL+PsYBSKZKRVOhLKNA6aZOWOgYBeMf5ctYrx2B5IrhDiFBmcYiI+ReWNIRPAiy+lV3qg
 6lcv6s7S
 oeHtxQ1KATSHsZbia2P+pD91AwryTzRZI1PWn4eFsAAVuQcgjZwUdI6yMdLZYinBu7wGhhidLS5S8Ueh5rDMdVFJ658S6cft6fAX5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 10:35:15AM -0400, Liam R. Howlett wrote:
> * Uladzislau Rezki <urezki@gmail.com> [250909 05:08]:
> 
> ...
> 
> > 
> > > > - call_rcu() can be slow, therefore we do not use it in the kvfree_rcu().
> > > 
> > > If call_rcu() is called once per 32 kfree_rcu() filling up the rcu sheaf, is
> > > it still too slow?
> > >
> > You do not know where in a queue this callback lands, in the beginning,
> > in the end, etc. It is part of generic list which is processed one by
> > one. It can contain thousands of callbacks.
> 
> How does this differ from kvfree_rcu()?
> 
> Surely if you have enough calls to kvfree_rcu(), you will end up with a
> large list of frees before the end of a grace period?  Our placement in
> the freeing order would still be dependent on what else is using the
> infrastructure in the same grace period, right?
> 
In kfree_rcu() we use page blocks to carry pointers. Lists can be used
if there is a low memory condition so a page can not be allocated or
cache is empty. But this is not part of carr_rcu() track in any way.

Right regular call_rcu() puts callback into its own internal lists and
they are processed one by one during list iteration. In such lists you
can have hundred of thousand callback.

>
> How is kvfree_rcu() affected by rcu callback offloading to a specific
> cpu and rcu expedite?  Often these two features come into play for
> certain workloads which are of concern to us.
> 
We maintain a separate path. Offload is done after a grace period is
over. It is classic way. Historically all deferred freeing was one
call_rcu() per ptr.

> > 
> > If performance is not needed then it is not an issue. But in
> > kvfree_rcu() we do not use it, because of we want to offload
> > fast.
> 
> Today, I free things using call_rcu() and a custom callback so I would
> think stacking 32 together would make the list shorter, but latency
> would increase by waiting until there are 32.
> 
> If we wanted to flush the kvfree_rcu() list, is it done in the same way
> as the call_rcu() list, or is there a better way?
> 
For this case we have kvfree_rcu_barrier(). It is not same as call_rcu()
flushing.

--
Uladzislau Rezki

