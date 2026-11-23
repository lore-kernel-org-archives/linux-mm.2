Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF3F606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HRTPwa/C
Received: by kanga.kvack.org (Postfix)
	id 822B96B05B2; Mon, 23 Nov 2026 11:24:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3156B05B3; Mon, 23 Nov 2026 11:24:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7105D6B05BA; Mon, 23 Nov 2026 11:24:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41FB36B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:24:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A276680918
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:24:06 +0000 (UTC)
X-FDA: 85466905692.04.E31EDFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DBAA620010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:24:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HRTPwa/C";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451045;
	b=g2Fye+43TNonKgxKHg4steG5pbYwKDGsUfCtDf+jG8Jk0IfkvPo+P2U0mbsIQMtP9alnFj
	4RSUhTASAaNxXwqw/PEDwILHN9Zifh/aBzWUVCH0O/jtKHIox33LYtKhFxh8CbbneGN80h
	WIjoLfHXbDcTtbq71rIzCt8aw/jnkwc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXavW4JWzr1Q6W/lcF7e/uXGv4HjAfnzdjNwVnsw0mE=;
	b=ndOXc0qM2nmmJhX7uuL5nD1KrvU26BtrTRo//tkwqy7XR8z1emTtQO0xeVTLEivaGvOmvN
	RvUdLnIz9p67nNGtDOvnZyYyoinP80Pz75JoniN/V47lYJF7Epx9I3gwgSlQULiRON3Zii
	ZauYm4TaycqT3Zf+pbQGZSdVcSg4Kbc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HRTPwa/C";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 152C84489D;
	Mon, 23 Nov 2026 16:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026541F000E6;
	Mon, 23 Nov 2026 16:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795451044;
	bh=DXavW4JWzr1Q6W/lcF7e/uXGv4HjAfnzdjNwVnsw0mE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HRTPwa/CG7GeJX/h6unRrUok3iyt++C87ZisW5dSA1pkNjBFXoKnQGd2R3+99lWbf
	 tCetkOzw10KfiAfqEDb1zDLFv4dSTB2BpsmYl3iNpebQ7hv/xp3wS7tvtpJJa02uwR
	 cWfyimQxDjn0P8ABZU7kIiHW3OOa5izFSY2TAj6KjfDZ5K5c4NNBj7+23dHYLhz01P
	 5G5QuAYWkHHF59D7fxqFV4RmpzUN6f7pMDyC7k4H5a+AAMLrnAgF2jgE6mfDpZnnN3
	 xFsw8dAcIFFyrXfH5mCymvWuv218H/b5jt86qgLvxzV/SBpK/t0zlUKbz90HWv9EDM
	 kWUJXsBcJy++A==
Subject: Re: [PATCH net 1/3] net: multicast: keep source filter state when a
 source update fails
From: netdev-bot+sashiko@kernel.org
To: x-professor@outlook.com
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Nov 2026 16:24:02 +0000
Message-ID: <179545104255.3135.1386420892995095806@kernel.org>
In-Reply-To: <fcc87bc014e01d9571fa33aaabd22180908e55d1.1795102467.git.x-professor@outlook.com>
References: <fcc87bc014e01d9571fa33aaabd22180908e55d1.1795102467.git.x-professor@outlook.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: DBAA620010
X-Stat-Signature: ppacy9yia3pn7zfchr3kammqdfnjw7gm
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795451044-496014
X-HE-Meta: U2FsdGVkX1+LDYC+HIEQ6NkOPzWDoh/+BgSzhaaENOVAxWIVoC9fVqfO56xx4fLV0nQHEH/FYO4M2bxD0qfxES4XushPpeEVyrOdjTU2IZbJkQ9VDgo7VbQ+uX3SAIe1zolXYG5YJGmvbpG9XlzqfEnpxUnvDze29jM2OQbUAb79jkiFGQ1F1YOD8d8C57uSe8OoNY3m+ECzJkk2dzgROSODfE7YJ4r538KuOTBfOPPd+o54DiUMzPJ9DlzXwAp1vRGt8pBfDVUo+g6EVypvD72apw4/ijV3QbPDvnKTZSphDfjcR+kElS1au4TobQEdgBYKJu6pGvu2yg4jHlMWokLP/C5zMZNyPk9u57dotOnc0w/xAqF50N136Z3mrK0PLBeCXAr5dIktI5PYNQoVvy4C9KO/MMRJzN/5QAtifC3JmSN0RJM2pa5s3GDf6+SEGGFVccwfvbmExqWsEbQZ4Epe8Qd2SFaiY6FhuuraYgwC+/n2Ea9rFHTU6xTSnZYDOd+iux166LjYSpVvD/mCw21tMbfi27C0i5aTly4WJaw3pRJ6LcfFw/muQxzhr1Z4Q6uEA/I5P5IyWKLE2PpLrCAd64InTSc87uMr1GLrqtdktflQCDaB+ndnxUS3Y4BCtrLG15Pd+zt17OjtphgtylIyD4VpVxrbwg7yKQdDixLGHL3hHeLNlZ8QDM3FOjrgXzg6/4kWhzmRg7Mkz+QysDBE9yVQQrev++DMEgpFVu3hX1wPi4SVljEvL87xx9pkYVomzcvYzzvkXYNsSQsNb/3Hr8cYZ1sm29myDrc0IPH2KxB2VbHwGUKCCy9Rh/CANZrOab//9WbmGbEnXyXuyChlxrhaVXWF4XSb5N9aYxKSGuysTjw+msAiRzNvqNrMZ3+Q/sQiM00avjXgJrJuKKdQQymhRFWqfCRj1zWTKGE30s4FtZcJOfwHzs3ACV1T2Ryqnp7y6ksGzNsH2Mg
 9MgPTNRm
 fBKPPkh2effp5WaQn2+wLU5eeFTcq4yEbXA2JSXJrrI4Rt/3D+l0gnVA8o7MD8ujVV/e1vr9zh5+/zeSK2rxuaRjFweZdDTL5IFD9FEjAdTgsAwUJXy04nON0paZpbrlZL/L3epmrrhfsIF5WPHVgIJtDBz1PO3RM+Q/U68MZWwhbBrdNULa5uRD0mXUE48nnQnBUBr4HfRYei/F+dKQV1PbLuxOdHQNcm+p3OYaAfTpJ456GDWXaVDXg3a/gXvadbg2GCKGNnipYr6AhFpxiCv88zayGVQEFjuOK/xC0ut9Bo7qpHClLG0hGiT8OhbYQh94Yus6k8ZjPwssCwoPRlcWC7a5jfioDdFCf3T2evMh+W57QW/LD7chavmlZmXommHembSumSQTe8pE158RDSCyLjlzfU+DB4msazX0JCjAxIlf5/UcesVI8w7I8HgBdudhBLkboSjoGFZ9oZus3SoQPXeJmj90/4vzFj6+EdA8gARjooS292mWpZS5hFEWlT8vm7hkgkwaiVgUT5Fkoev0o1xsypzNpPbyqbwl686EtZLGySksiQleKLyp7m9RUtwD8UfOSh13y9kN8JflbaDbtiT/WVX5CsOFHPRxx56YHE0GhBi2koFx6qLBYhNWovL459HX//6cWLGzHGvPEjkLA8WMZBbAnrYpRYtgDchJJYfYSVJ5Tcm24WYcrR+giz+Icxg2dUAhSY5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 3 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] ip_mc_source() (net/ipv4/igmp.c) and ip6_mc_source()
  (net/ipv6/mcast.c) still switch the mode of an empty filter before…
- [Medium] The patch now returns every non-zero result of
  ip_mc_add_src()/ip6_mc_add_src() from the add paths, not only…
- [Medium] The new `done:` rollback in ip6_mc_source()
  (net/ipv6/mcast.c:504-508), and its IPv4 twin in ip_mc_source()…

--

net: multicast: keep source filter state when a source update fails

This patch restores the previous socket filter mode when ip_mc_source() or
ip6_mc_source() fail after switching the mode of an empty filter. It also
returns device-side errors from ip_mc_add_src()/ip6_mc_add_src() before
the socket filter is published. When the source update fails, it drops a
membership that the same MCAST_JOIN_SOURCE_GROUP or
IP_ADD_SOURCE_MEMBERSHIP call created.

> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 52cde8782eebd..bfa448028f8a1 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c

[ ... ]

> @@ -2530,9 +2531,10 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
>  		}
>  	} else if (pmc->sfmode != omode) {
>  		/* allow mode switches for empty-set filters */
> +		oldmode = pmc->sfmode;
>  		ip_mc_add_src(in_dev, &mreqs->imr_multiaddr, omode, 0, NULL, 0);
> -		ip_mc_del_src(in_dev, &mreqs->imr_multiaddr, pmc->sfmode, 0,
> -			NULL, 0);
> +		ip_mc_del_src(in_dev, &mreqs->imr_multiaddr, oldmode, 0,
> +			      NULL, 0);
>  		pmc->sfmode = omode;
>  	}
>  

[Severity: Medium]

The mode switch still happens before the request is validated. It is only
undone at done: if the request fails. While the switch is in effect, can
other code see the temporary INCLUDE{} state?

At the socket level, ip_mc_sf_allow() runs under rcu_read_lock() only and
does this:

    psl = rcu_dereference(pmc->sflist);
    ret = (pmc->sfmode == MCAST_EXCLUDE);
    if (!psl)
        goto unlock;

inet6_mc_check() follows the same pattern:

    psl = rcu_dereference(mc->sflist);
    if (!psl) {
        rv = mc->sfmode == MCAST_EXCLUDE;

So group datagrams that arrive inside the window would be dropped for this
socket.

At the device level on IPv4, suppose this socket holds the only EXCLUDE
reference. The forward ip_mc_del_src() then drops sfcount[MCAST_EXCLUDE]
to 0 and switches im->sfmode to MCAST_INCLUDE. ip_check_mc_rcu() reads
this without a lock. Would traffic for the group be rejected for every
socket on the host until the rollback runs?

ip_mc_del_src() also calls igmp_ifc_event(), which arms mr_ifc_timer.
igmpv3_send_cr() only takes pmc->lock, not RTNL. If the timer fires inside
the window, it looks like it could send a CHANGE_TO_INCLUDE{} record,
which is a leave on the wire.

Even if the timer does not fire, the rollback is a second device-level
mode change. A call that changed nothing would still produce qrv
CHANGE_TO_EXCLUDE records, or MLD change reports on IPv6.

When !add and sflist == NULL, the call always ends here:

    if (!psl)
        goto done;	/* err = -EADDRNOTAVAIL */

So that path never needs the switch, and it is always rolled back.

On the add path, the window includes a GFP_KERNEL sock_kmalloc(), which
can sleep in reclaim. Allocation failure under memory pressure is the
failure case this commit is fixing.

The commit message says "the EADDRNOTAVAIL case keeps the EXCLUDE filter
and the group is still received". That does not hold during the window.

Could the code fail early when !add && !sflist? On the add path, could
the allocation and validation run before the mode switch, so the window
goes away rather than just getting shorter? The same applies to
ip6_mc_source().

[ ... ]

> @@ -2585,10 +2596,30 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct

[ ... ]

> +	/* update the interface list */
> +	err = ip_mc_add_src(in_dev, &mreqs->imr_multiaddr, omode, 1,
> +			    &mreqs->imr_sourceaddr, 1);
> +	if (err) {
> +		if (newpsl)
> +			sock_kfree_s(sk, newpsl,
> +				     struct_size(newpsl, sl_addr,
> +						 newpsl->sl_max));
> +		goto done;
> +	}

[Severity: Medium]

This now returns any non-zero result from ip_mc_add_src(). The matching
change in ip6_mc_source() does the same for ip6_mc_add_src(). Both
helpers also return -ESRCH when the device has no entry for the group:

    if (!pmc) {
        /* MCA not found?? bug */
        rcu_read_unlock();
        return -ESRCH;
    }

Can setsockopt() now fail with ESRCH in cases that used to return 0? That
would affect IP_BLOCK_SOURCE, IP_ADD_SOURCE_MEMBERSHIP, MCAST_BLOCK_SOURCE
and MCAST_JOIN_SOURCE_GROUP.

This looks reachable in a few ways.

On IPv6, without privilege: a socket joins G on interface A with an
explicit ifindex. It then calls MCAST_BLOCK_SOURCE with gsr_interface ==
0. The idev comes from ip6_mc_find_dev()->rt6_lookup() and can be
interface B. The pmc loop in ip6_mc_source() still matches the A
membership, because the ifindex check is skipped. ip6_mc_add_src(B, ...)
then returns -ESRCH.

Before this patch, the socket-level filter in that case was committed and
still enforced by inet6_mc_check(), which matches by address only. The
call returned 0. Now the call fails and the filter is not applied.

On IPv4: lowering the MTU below the minimum and raising it again goes
through inetdev_event()->inetdev_destroy() and a later inetdev_init().
The socket memberships survive, but the new in_device has no group entry.
Source operations would then return ESRCH.

Also on IPv4: __ip_mc_join_group() ignores the result of
____ip_mc_inc_group(). If that allocation fails, the membership has no
device entry. A new IP_ADD_SOURCE_MEMBERSHIP or MCAST_JOIN_SOURCE_GROUP
would then drop the membership and return ESRCH, not ENOBUFS.

The commit message says:

    Return device-side allocation errors before publishing the socket filter.

Should only allocation errors (-ENOBUFS) be returned here, with the
-ESRCH cases handled separately?

[ ... ]

> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
> index ecef55f261890..0d982f7d29cda 100644
> --- a/net/ipv6/mcast.c
> +++ b/net/ipv6/mcast.c

[ ... ]

> @@ -403,8 +404,9 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
>  		}
>  	} else if (pmc->sfmode != omode) {
>  		/* allow mode switches for empty-set filters */
> +		oldmode = pmc->sfmode;
>  		ip6_mc_add_src(idev, group, omode, 0, NULL, 0);
> -		ip6_mc_del_src(idev, group, pmc->sfmode, 0, NULL, 0);
> +		ip6_mc_del_src(idev, group, oldmode, 0, NULL, 0);
>  		pmc->sfmode = omode;
>  	}
>  

[ ... ]

> @@ -494,6 +501,11 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
>  	kfree_rcu(psl, rcu);
>  	err = 0;
>  done:
> +	if (err && oldmode >= 0) {
> +		ip6_mc_add_src(idev, group, oldmode, 0, NULL, 0);
> +		ip6_mc_del_src(idev, group, omode, 0, NULL, 0);
> +		pmc->sfmode = oldmode;
> +	}

[Severity: Medium]

This rollback undoes the forward mode-switch calls without checking
whether they succeeded. The forward call

    ip6_mc_del_src(idev, group, oldmode, 0, NULL, 0);

returns -EINVAL and changes nothing when mca_sfcount[oldmode] is 0:

    if (!delta) {
        if (!pmc->mca_sfcount[sfmode])
            return -EINVAL;

        pmc->mca_sfcount[sfmode]--;
    }

The rollback's ip6_mc_add_src(idev, group, oldmode, 0, NULL, 0) still
increments mca_sfcount[oldmode] every time. Can this leave a phantom
reference on another socket's device entry?

This looks reachable without privilege, through an existing mismatch in
ip6_mc_source(). With gsr_interface == 0, the pmc loop matches any
membership for the group, while idev comes from a route lookup. Nothing
checks that idev->dev->ifindex == pmc->ifindex. For example:

1. Socket S2 joins G on device B with MCAST_JOIN_SOURCE_GROUP. B now has
   mca_sfcount[MCAST_INCLUDE] = 1, mca_sfcount[MCAST_EXCLUDE] = 0, and
   mode INCLUDE.

2. Socket S1 joins G on device A with IPV6_JOIN_GROUP (EXCLUDE{}). The
   route for G points to B.

3. S1 calls MCAST_LEAVE_SOURCE_GROUP with gsr_interface = 0 for a source
   it never added.

4. The forward ops run on B. The INCLUDE add raises the INCLUDE count to
   2. The EXCLUDE del fails with -EINVAL. The call then fails with
   -EADDRNOTAVAIL.

5. The rollback runs on B. The EXCLUDE add sets the EXCLUDE count to 1 and
   switches B to EXCLUDE. The INCLUDE del lowers the INCLUDE count to 1.

B would be left in EXCLUDE mode with a phantom EXCLUDE count. MLD would
report EXCLUDE{} for G on B, and device-level filtering on B would accept
all sources.

S1's later leave works on device A, because __ipv6_sock_mc_drop() uses
mc_lst->ifindex. So the phantom count would remain as long as B's group
entry exists.

Before this patch, the same sequence only left a phantom INCLUDE count
on B.

The IPv4 rollback in ip_mc_source() has the same unchecked pattern. It can
be hit when a socket membership has no device entry of its own, for
example after an MTU drop and restore or a failed ____ip_mc_inc_group().
Another socket then has to create the entry later.

This also seems to conflict with the commit message's claim that
failures "preserve the previous filter and membership state".

Could the rollback undo only the forward operations that actually
succeeded?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795102467.git.x-professor%40outlook.com

