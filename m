Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F43103E2E6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F406B0005; Wed, 11 Mar 2026 17:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345826B0089; Wed, 11 Mar 2026 17:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227926B008A; Wed, 11 Mar 2026 17:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1283D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:59:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B354313AE11
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:59:35 +0000 (UTC)
X-FDA: 84535149510.01.F17B067
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD942140006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:59:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcXW+dQM;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773266373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zVb+OxDqSjGUfwQzmjE94zOu/RnPssCymz9zuJYtuc=;
	b=gf0INF7o33iKRIvJjkMstXPIpa4y9S+ar8rLmTaliXEkEhVlctVgwc+HgBq/wrfp1x4R3H
	3/ZGx9GWEKGBxYo/1L+/JGmybEQhYhaigsz0NzzBumjfSO6gxqgpXSa2pR5ft1LT0W0VGX
	ohD631Qr4sGK58fkKLjOjavWEcZDUwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773266373; a=rsa-sha256;
	cv=none;
	b=DjKBRwPjc6KjUvPVzvLYDV4lQQB63aPW0rbZlN7Nq+DFqgIWYl8rRGRBQtDvUk6RxPEqPD
	vgoz/3cobVIDiCSbRD1CflPFEkvM0S/nAo4WDGfaARa9+Zn1P7tNHE6Gmo/XBulIfnTimJ
	npgFdsYHJTTanN9FIzbOVz4kdynvvFc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcXW+dQM;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A46D60142
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A42C2BCAF
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773266372;
	bh=5zVb+OxDqSjGUfwQzmjE94zOu/RnPssCymz9zuJYtuc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KcXW+dQMHzrMWnhn826Wb/waJzLtVGpKCcsOFICPmKf8lmI9n0MjzIS3ZoVP56rwL
	 zUDD6s9qOrMgKcopB7/4MFQD8yUMJtuuyxU12KRRejbKDqk66UwPXF6nfjKRYdpxHo
	 sD1nvMq24ZwDouef/yXa1cEYx1DH9sS6LJvT4q9nO821+VyMyJzMVywQOPQHLYbjc8
	 pwR2vXlCA/2tDGEKwhUQ8pe5sVtlCUzaMuOobHsBT1FUV7tmc5y99oU9E0ghnNDV8J
	 YYmep2Xfp7CJ8xOFkcwd3/dGq8L5ZwvABvG2WNV/NmCoMY/0hJu38wVWdBBjvtyD9S
	 B5EFdGOcHTVuQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b96d784828bso43231566b.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:59:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXuwUbJVqXYVw8aO8prNTxn/muUqheruQHgrgoMLD86FeMiesgL9mR+HSZW6yNPXe0TcrecLzBx/w==@kvack.org
X-Gm-Message-State: AOJu0Yz+pssGvnNveqbuSBAFn8a36lgb+5eIahlsfkZF0EXyUyQtYROr
	pMSk8gQM+WwYulxdIsCShUxpP2lx8EjIMvuzn+17aijTf7vsfrXCdPeruu4wW1IL0ucrt/lzIAk
	GSPg8hDuglTEx79YzWYvO4yfzIqy6Jdk=
X-Received: by 2002:a17:907:26cc:b0:b96:f0a0:c7d4 with SMTP id
 a640c23a62f3a-b972e5dbd4bmr236173166b.46.1773266371618; Wed, 11 Mar 2026
 14:59:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260311154358.150977-1-hannes@cmpxchg.org> <050ce5bd-4725-468e-acaf-7fca72b84d06@linux.dev>
 <abGpgxsDKeSc6cjR@cmpxchg.org> <abHBYss1GDYX4uWe@cmpxchg.org> <abHLtmDvYl5QYCv0@linux.dev>
In-Reply-To: <abHLtmDvYl5QYCv0@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 11 Mar 2026 14:59:19 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM_fY_9nqQ2YHy9xTtdsesuOdQU_LntbZk149gL0gE=Kw@mail.gmail.com>
X-Gm-Features: AaiRm50Pn79_B3iDgllhhqIH4NVAWHZ1hIoA8TzSQAYNbCqtZDrOIafXeFL2hLU
Message-ID: <CAO9r8zM_fY_9nqQ2YHy9xTtdsesuOdQU_LntbZk149gL0gE=Kw@mail.gmail.com>
Subject: Re: [PATCH] mm: switch deferred split shrinker to list_lru
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: k8i8kmbr7ccwi7ctbjdaq8facyu6sn6s
X-Rspam-User: 
X-Rspamd-Queue-Id: DD942140006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773266373-467730
X-HE-Meta: U2FsdGVkX18TOwF12jTFLBNwXed4p/v957yP8keyx4tCwlUuNDF7fgMy0LaEiWQQqXnmb0GvUjL+BTHGryQOJxHyn9Xym1Pl/AX9Tz+2qVOcjJcMSxdipAR6mjdRCyFISVlETdTL+VR90WAM62VTC+qu6uX1j8kttH+E13ftMSoTB6DYKPWwtNSuKTCMRU08g2RX0/oxqIjqgKfUmIj7YPZR0Bdm5IidCRKCENsMPoDRdlE8Px5Fs82ZSRVSKoxlOcxHT2d9H23Xch4FM+Ph14deG2GF9bK+sasEwdogo70hINQ31jcv4nRCxODQcbDNLuwb01aq5TJ9WxH8HhwR6zMY8XCI6aFQHcSEFXqnEBYMz2AYYOaB5hA5SG+DJdWgGayu5BTzaroIpgPRPpAK2HneV2H/Y/GIDc2N6FKjDFLeaj8NsWvqcU8q2ViaDgMqO2hgTDQa2TFi1vjJ1/TdRuEURkR+MT4Yex35dCDTnIQ8mtnlU0iktgI3BJVDaRzxCP7U2NtSJ1ysNUFVSLng+F+VmrOKlUoXkpifDgJ8OrZHgbmSfP1VAODhnlj+QKn+FLL4jAmXubIeXo404I5qKTxS4s9PeI8rNQjGqIuAM7fYU2j5PnZfXjebzTiDmbxnP9U1pqyQrbYYTP8OC8QEWxVRqIPhJBSKEQ32lYj0DuCWr4R2Go/5xA02mSFyLf+HWBgDZO7ii1UHZOACEU/VZM+yu5wDbpkZQSiZ/ZsIxdDHFTVuqD8ZwH5Mh3/JqxrpOOLAlMmAMG72wBY5Gyehyp85t21KG7TgLRJr5tEZz7HXklnqcTscRUgOMcMddZca3GKFDbq3Fjm2XcaPU29FGXru6e6USbYnLz+z63D9Ye1kMRLl9Xwisl2MOsovOXyU9MOO6Egxi4BMBHNKC9z6j0bpmn5sFhadzNyjcVEn0f2zkoHf0zKRorDXh46qydgfKzBy94z2ebCaYkKg2Ij
 mOD4LDRx
 bAZk2y2IN2r+ITBNAbfFZZcr1rrUAeu8dNX+M7yKgksmB7gflHc9t8SDO7eUulXCHPCqOv0DNUAnWqLKGs6yG+Z7I26XUs+/LuOJ3RvOwZExK7VKUU2LzthIvf+SuJ0GncWk/ZPZEth1Xgb7le/1Qqq169vd1yOUb+YBntasAn2qLO+bXEbcDBcqz17mObEPjMEQlMLd4TgK7GgFi2fqt4I6a++8T9fam60cOiPoQjMEDwsZvjuhhEGH/0cgvNzeJTUM7d5s9HlU03YeLtRJ5aiBhiiPv2MZrKm2cE5Xg97dWOE3vfKr6IQvKMNXQ5IZt+I1zmqwUG2LqTR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Okay, lockdep actually does warn. rcu_read_lock_held() is explicit and
> > not appeased by implicit RCU sections.
> >
> > Paul pointed me to rcu_read_lock_any_held(), which we could use in
> > obj_cgroup_memcg() to suppress the splat and permit implicit RCU.
> >
> > Or we can make rcu_read_lock() explicit in the above code.
> >
> > Any preferences for how we want to handle this in MM code?
>
> I would vote for explicit rcu_read_lock() to be consistent with other places.

+1

