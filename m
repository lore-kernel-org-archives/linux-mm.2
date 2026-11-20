Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB50606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KewQqbwu
Received: by kanga.kvack.org (Postfix)
	id 35B216B00EF; Fri, 20 Nov 2026 10:34:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30BB36B05B0; Fri, 20 Nov 2026 10:34:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248B26B05B1; Fri, 20 Nov 2026 10:34:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F376E6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:34:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2C1B120BBF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:34:51 +0000 (UTC)
X-FDA: 85455895182.03.B1ABAD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 338061C000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:34:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KewQqbwu;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795188890;
	b=Ejwrp4jkPmti2baxn6RPiaZxIFPrAq5sskivNtyX5v4+xvrjbg6uMoMeT4jAJcTwYQbfxY
	nEMycawQlObfXsZ8ImuEe2hcrUNH/ii1w77sjps3EcUuTw6ggXRkP2ytjBUpCuBbfWiYnL
	nqvSlh+JhWI0isXBrvaT+Kq66f3aUDY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795188890;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4lkm1tpa3dv7yUTdwo2D150hj2Tgsxdh/lGY6vYTSA=;
	b=UeRTx5+rkhPGytBGIPTsYArPEwbxNm+NmIq2X3LpIC0R/GfvBMRQKA1FZYUp8OY/tTcS9m
	TksGJL5XNOix/5aVzhDuBtd/DbsJV5mX3jBxVpSKEIBjyrViIUwfjyEetSpB3VkRa9+GlW
	rJAUfaJV6fSMInRMO7uptwmo2D84ffg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KewQqbwu;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 679E1611A5;
	Fri, 20 Nov 2026 15:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8D21F000CA;
	Fri, 20 Nov 2026 15:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795188888;
	bh=t4lkm1tpa3dv7yUTdwo2D150hj2Tgsxdh/lGY6vYTSA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KewQqbwuxe9G+RnXTmiEY97cm4VC8uBshoE4l2oYFdrX9DUjIXL2wvOQh2rQcoJtV
	 HCmBKUUUeOEAu2iH0uGxsDHvOhdt+XdadWawVMbe8hwjixgCYe7365eVn3r1WfYBhw
	 wteoSHHiUmaXkxLsEYVt0OrabzJLDYVwIzW8uXrajle9TG09iQ+NWazglyzqdYAqoy
	 GtzeGXZL5f8GzMSlD6ubMaz0TnjqcAGTX4+G3lEFJik59ffGf9eJ/dZdlgTW1u2NAD
	 1H/E/fu+uVHwM60CwGgGd9HPmDYrm4eQNYjsBagwVVdoFsWaaDS3H7o1v5A8znhMN9
	 YkbBYitX/IF+w==
Message-ID: <sashiko-outbox-225467@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/3] net: multicast: keep source filter state when a
 source update fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yingjie Wang" <x-professor@outlook.com>
Cc: "David Ahern" <dsahern@kernel.org>, "Ido Schimmel" <idosch@nvidia.com>, "David
 S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Simon
 Horman" <horms@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vladimir Davydov" <vdavydov.dev@gmail.com>,
 =?utf-8?b?bGludXgtbW1Aa3ZhY2sub3Jn?= <linux-mm@kvack.org>, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <fcc87bc014e01d9571fa33aaabd22180908e55d1.1795102467.git.x-professor@outlook.com>
References: <cover.1795102467.git.x-professor@outlook.com>
 <fcc87bc014e01d9571fa33aaabd22180908e55d1.1795102467.git.x-professor@outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 15:34:47 +0000
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 338061C000C
X-Rspam-User:
X-Stat-Signature: 56xz6k99bhd1dmkwuzma18n41a4r77o1
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795188890-919280
X-HE-Meta: U2FsdGVkX1+UqMlwd//lynulKqjLT6KJlm/3ByA+Zrm+1//ytcZnOPYizWmHXk5LkzspAJWswd5Fqk/BYHMod9UtPly5/66Ik9oINb8fOMP5M26qltEjZ+9wmy9KKb4VZDf1sP1r3FkphuEhmaXB/sBwuiyQlssKjjw6gz4YKLJRNsEET5Fa7kBBKXJQ/5OihNPufMT/NO6mxYDnT0j/NFEDMJEyZbXgJSTdR9267yTF7Fdrx1WCko5AxIxC/ag1QGt77Bo4mvfMVgeCivmjuxmyJ+WVS27cHI4vLef0ZNbwPsr/Yu2S+pvbLHFouEBWEmEPngngBNup0WGW7ItF3cwUbZXTkns9CIx+/pamRh+s+sw6t1raQUWCOs9BQOZ8/AkswIpO2DijCYnjd5PMEa8+Dj061j+3OdZwRUJ0QBBF8zZ8ur/y0VW/vYZjJ6pdp2tppSp+fp0/IBKqkyRLL0i4srE4uIR5vRdVdS7drUWfJlapWnJb8d/V6x/FayM/kihhwKUSddyF4XdKWdI5W1nshSxVs355Wbs5US3wEvfdIaXL7i6q9zEUshyzX2W5tzXZhNrnDYfBiHw2SXvdVkscrJIlqp+1a0Flw9lDSGS77MW8gOFIgb+OVAvkuuZgvGaUaEL0xoCb55YRv80uZUumbmJ1C883CynppGsyxcfUCxe1TXi0XuUiStLw1QGIE3UouXVkOnerRd9Q9qKvPC5VsFswbIv0U5zo37rFxhc9HQPS+G9SboK9D9vuA/HQcq4VGfYywUBlK2EFbObiXFZDnuXdSw95J/m+djE2AA1ZYDURvXYySRjYRCq7PhRzobaMC5SgiFaZ+3RCJ2tCxkmOiqIIxxKMzfw/3nQHciS53k6W0Ci/e1XFOe8MIzer6OcTZ0Hac8YDrEAp8Sn3bTrZJtbeew/APQjPkjlxZewPsOFgy9xz+wXCgcm+A7yA5rUPYSufI59XSm6bwsO
 2GQIiwoj
 PSUqsUd+LMU3NlqipZc/ATUb6pOCsCdE3MicjTyqfdmkFRVuXpfmuo66+W1+C6XVGgVFZ3nbUG3rjMSer74EBKnVfyaEF51hoNkBBAbBS5GjspmKrsIomyxkRR/uFtkKOk5xzARX4hdBVnE5tgH9fHWjCMMbgD5CW5bGYShtpVM5f2JVr9CWBtZAArB33Hb6IDDuQqvA+z53AoZLkoWXniA2hzu6gJQ7uy7RU2627ckMcxllf/Cnq+tVayIl/px6Mve2bHXOJm2K5+jsVfdNTUGNFWQIITc7K608mnockdWnKQ1lDGIMJmmbY5yOCWgMFXx89LbzlXC7w7N+PnUiPLFJmzz9XdK3hRdb2VpDGhVo7omm4+8akbhKpnKU4CKSXJx2RHUYPSPjVy7N0GK5jREAUOASBPi9JOshjI26bX4BJDJFsYH62a+yIiX8sYFKQKCuOBAQBcfDzqFzykBN0KHZ4R7+Yfi8s5Vpn7nb6fSEa2G0XD7yIMLHbNLcPtLW7zJqNGCBz3fOB7wp+XE3meZaaVGiQ/pD+NH9pF3qZF1CcEdV1zv4j002Sv3xiU2SBgAp2E+IZEcNM9iUf5xneuum2OeDtX0UDN8gFfTmVaI2SBXRkMlKzBcPHNiYxZWEeHhIMcUDGDt7f46DvOS5I/oHps2Q61CFp+OKXL/rGbEFzdfZnEyNv3p6ViVZRZNK6h8mX0M9g8V9FBMNH40uVPYEos12EPqrBfocmkHHqnoS9qKCP8apOA0NS9l005si5P4eTjjj5940oADsNNnZdj2gWS0jA1iseh5QbjtZ7/keQVVc+LT9jLOzImT01Zz3AD+P7a1vB3cdlgBkM+QeiGTXHsW/WV/IPCDoog11nRbQ7ADFYQLPnQ82FXzPaOnl+cy27cXCicCyTpHcQCPYkUUP7sKFl2unZLhRkI7aHJuGvzr2Oc3jWuRIin0e9L4Cls9PWXlKDGmJnq9/VaVaFaBS4fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net: multicast: premature mode switch and stateful rollback
  in ip_mc_source()
--

commit 831050a0d77c35ca56da9b5211137601a0a6a62e
Author: Yingjie Wang <x-professor@outlook.com>

net: multicast: keep source filter state when a source update fails

This commit restores the previous socket filter mode, propagates
interface-level source addition errors before publishing the socket filter,
and drops newly created group memberships when a multicast source filter
update fails.

> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 52cde8782eebd..bfa448028f8a1 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -2491,9 +2491,10 @@ int ip_mc_source(int add, int omode, struct sock *=
sk, struct
>  	struct ip_mc_socklist *pmc;
>  	struct in_device *in_dev =3D NULL;
>  	struct inet_sock *inet =3D inet_sk(sk);
> -	struct ip_sf_socklist *psl;
> +	struct ip_sf_socklist *newpsl =3D NULL, *psl;
>  	struct net *net =3D sock_net(sk);
>  	int leavegroup =3D 0;
> +	int oldmode =3D -1;
>  	int i, j, rv;
> =20
>  	if (!ipv4_is_multicast(addr))
> @@ -2530,9 +2531,10 @@ int ip_mc_source(int add, int omode, struct sock *=
sk, struct
>  		}
>  	} else if (pmc->sfmode !=3D omode) {
>  		/* allow mode switches for empty-set filters */
> +		oldmode =3D pmc->sfmode;
>  		ip_mc_add_src(in_dev, &mreqs->imr_multiaddr, omode, 0, NULL, 0);
> -		ip_mc_del_src(in_dev, &mreqs->imr_multiaddr, pmc->sfmode, 0,
> -			NULL, 0);
> +		ip_mc_del_src(in_dev, &mreqs->imr_multiaddr, oldmode, 0,
> +			      NULL, 0);
>  		pmc->sfmode =3D omode;
>  	}

[ ... ]

> @@ -2596,26 +2627,19 @@ int ip_mc_source(int add, int omode, struct sock =
*sk, struct
>  		rcu_assign_pointer(pmc->sflist, newpsl);
>  		if (psl)
>  			kfree_rcu(psl, rcu);
> -		psl =3D newpsl;
> -	}
> -	rv =3D 1;	/* > 0 for insert logic below if sl_count is 0 */
> -	for (i =3D 0; i < psl->sl_count; i++) {
> -		rv =3D memcmp(&psl->sl_addr[i], &mreqs->imr_sourceaddr,
> -			sizeof(__be32));
> -		if (rv =3D=3D 0)
> -			break;
> +	} else {
> +		for (j =3D psl->sl_count - 1; j >=3D i; j--)
> +			psl->sl_addr[j + 1] =3D psl->sl_addr[j];
> +		psl->sl_addr[i] =3D mreqs->imr_sourceaddr;
> +		psl->sl_count++;
>  	}
> -	if (rv =3D=3D 0)		/* address already there is an error */
> -		goto done;
> -	for (j =3D psl->sl_count-1; j >=3D i; j--)
> -		psl->sl_addr[j+1] =3D psl->sl_addr[j];
> -	psl->sl_addr[i] =3D mreqs->imr_sourceaddr;
> -	psl->sl_count++;
> -	err =3D 0;
> -	/* update the interface list */
> -	ip_mc_add_src(in_dev, &mreqs->imr_multiaddr, omode, 1,
> -		&mreqs->imr_sourceaddr, 1);
>  done:
> +	if (err && oldmode >=3D 0) {
> +		ip_mc_add_src(in_dev, &mreqs->imr_multiaddr, oldmode, 0,
> +			      NULL, 0);
> +		ip_mc_del_src(in_dev, &mreqs->imr_multiaddr, omode, 0, NULL, 0);
> +		pmc->sfmode =3D oldmode;
> +	}

[Severity: Medium]
Does switching the empty filter mode up front and rolling it back at done:
still mutate device-level IGMPv3/MLDv2 report state and transiently drop
packets?

When IP_DROP_SOURCE_MEMBERSHIP or MCAST_LEAVE_SOURCE_GROUP (!add) is called
on an empty MCAST_EXCLUDE membership, ip_mc_source() switches the mode to
MCAST_INCLUDE and immediately fails at "if (!psl) goto done;" with
-EADDRNOTAVAIL.  If this socket is the only MCAST_EXCLUDE member on the
interface, the upfront ip_mc_del_src() drops sfcount[MCAST_EXCLUDE] to 0
and flips the device-level filter to MCAST_INCLUDE, and the rollback
ip_mc_add_src() at done: flips it back to MCAST_EXCLUDE, zeroing
psf->sf_crcount on all sources for the group, resetting pmc->crcount and
in_dev->mr_ifc_count, and scheduling igmp_ifc_event() to send unsolicited
state-change reports for a failed syscall.

In addition, while pmc->sfmode is set to MCAST_INCLUDE with pmc->sflist =3D=
=3D
NULL (including across the sleeping GFP_KERNEL allocation in sock_kmalloc()
on the add path), lockless RCU readers in ip_mc_sf_allow() see an empty
MCAST_INCLUDE filter and drop incoming multicast packets for the socket.
The same issue exists in ip6_mc_source() in net/ipv6/mcast.c.

Could the empty-filter mode switch be deferred until after validation and
newpsl allocation (where !add with !psl has already been rejected), or
rolled back if the subsequent source addition fails without modifying the
mode before the !add and allocation checks?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795102467.gi=
t.x-professor@outlook.com?part=3D1

