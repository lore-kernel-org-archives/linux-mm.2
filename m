Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A8A5106F2F0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D80A6B0089; Thu, 26 Mar 2026 04:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588816B008C; Thu, 26 Mar 2026 04:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E776B0092; Thu, 26 Mar 2026 04:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39D856B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:06:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 025F5140440
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:06:07 +0000 (UTC)
X-FDA: 84587481216.27.890A17D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 584624000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:06:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Us+jO5Lm;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774512366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qocLzhKoNwuEpBKBumgzNhJetl4M5jN1U/FB4uOTE5E=;
	b=nrmGqEajssvp3IDL7gngKACJdivX6tbOfVPI8QB8hu6cORxui+bmIrl/MpIDGn/PX1x89A
	att+13EnOhRuK5F78WxZOMHoZ3GjPqcKssmRpKzdZNUUDP9gRNrUDwrJ40M52RDV6tFbD5
	nWlIggDNcZganXb4OD9L2QfHe3QF75o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Us+jO5Lm;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774512366; a=rsa-sha256;
	cv=none;
	b=FWLX54bCLRwp01wI27mSocFSoUBU3Z8UEkV717MXrAwS546PQZGFvvLvkYq6qeJWXYC1TD
	YrBIQsYI5EiC5CRT9hPaQuzRd6d4+BQ/xipLge6nbtjVWP0FmOuaKUT33ab/gXHzKqEAPX
	Zh4LHz7HZJCNsJy3RQ7Pcu6RPqpzp7o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5426843AF0;
	Thu, 26 Mar 2026 08:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DC6C116C6;
	Thu, 26 Mar 2026 08:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774512365;
	bh=qocLzhKoNwuEpBKBumgzNhJetl4M5jN1U/FB4uOTE5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Us+jO5LmAS8vTN0skQ/Gyvi5wp7dJizYUkwWyiMv0jbc9m1/rr92yozXMieqJZ+Ob
	 MeaZZagHCuVdgI7IiLvw04CUH5gfJc00cMV6BNFSDS5jghA0YBaVl4bL7IdpquuvD5
	 b9o/jex3ZFRk0KPW4jhjlUqegB5rKA2v6zG+vJSMrf58ROoxTNPR5Mkcuu65EJHoZB
	 imYc5bUK4AO+kuwhUmjYbyBfh5YtEHEjlXHoteU/pTaUquHGpe04ox3rnD8XHucKBu
	 eO7z/gz03O4i01TjrYroOlMBZyU/ggZvu7hpgX5fcluNMV0uyafoNwrmCYQThTIsre
	 GoArltuDDBTrw==
Date: Thu, 26 Mar 2026 08:05:57 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 1/4] mm: memcontrol: correct the type of stats_updates
 to unsigned long
Message-ID: <3eb8b252-b6fa-4708-8c84-bf90142fe682@lucifer.local>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <158fa0b1296168047342f02050e9d2bda6888d27.1774447069.git.zhengqi.arch@bytedance.com>
 <fcd29ba1-e02a-4c91-80d1-2d1280e2ff99@lucifer.local>
 <c46cc185-5c23-4145-bfad-5c455b84857f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c46cc185-5c23-4145-bfad-5c455b84857f@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 584624000A
X-Stat-Signature: my77s95fztfao6837w4c679rn7gnbeqj
X-Rspamd-Server: rspam06
X-HE-Tag: 1774512366-480157
X-HE-Meta: U2FsdGVkX1/nbdnFLlvDzF5ajuHGlagMf7Nd72mIuJnlEUTR9AlbGqQZ3cb+70/Rig5vdA0KkXHtoQSpi0yoqlsx03qTwHpg/chyCkVYfqRqI3lBTrEg9vo+i9eo/IpW6Fyexbl61JSzw39QcWzKmcwEdbYWBKE93L98kl5X5JWbEqfwpKj1mU36kyFpo7OOzMxvGoEEoaDTf04v9BP6bCrEizs/xxaTlhXmwLpeq4pqIFNvusGRnMM5gNAe/Dn43YEzbvX4DD+FfCDJ9iRBjKQUMnL9MRji4WGuo7vvas9tLIHNGSpcFdxuuPvGSdW9OO9F6Jq53pv4mCBfncACuoi5pxFxcKWn6k5iy/YYAmpBuwHUV0fILv1NG8IzxQIdJKT3ZzOEjoLZW7/rdt03WdoFEoyQvbtmRMXiHYMfcSIGmeN/IvkhvdfF/PvRjmnfW2dYTM3RFA6m6wf+arTuyUncy/3JiO+2fXbKsargaaAMUucOq9ACrXyCCvq9A95spfSqxI/K9HE1vPbeHMtvJkiLVUMv3+OT9Y53TDJ5JNiCuafy6wna8Yd+CVNuqQMGWUdmaVWauUa1tgXyQJ7ZI+m0s1kni9/4i/22xp6EgE/v7wP5ZRadrswZEP1IW7fIonexUXlyLR3KtE9HXJvz2cik5oA8GaTkseaZ4cB3Hden5h7fJ37I5Ny8uv5aHpvEbml8f7h4HgJyQxt16EAb8NtOemoWpAKyBFeQl8/n0IP0/c5x0Or+L47IhjIqUgyUQ108xmnPtvWblphsoLpu3pWFkMe6kjOPl8Fwp3VLu7R+1NdHHC0q4X+G56go4z60/C1d7A7A5sry9OKN/27JjKYliyQN9aeiNoXOgt5S04xtIV3tp1iItm8GhxLqMrtqr3+lHWiTvizFIan/Z9J3YAa2ilVANKl7/st7hiBkyhfXXHnWkvO9Y5W8gGdeKL85FSbnD4M447ZzGb1SyVX
 Urv9PnZF
 aDXLg/+6Tb+qBe9ebPMwo7tLCmB7N1p8RNiqMM2PjbxILpwuRQxHG2lEbV4dqInSe6fsdcR3qDpzbMhH/pZEveiTlOGdQW1B9ChXZ38uL8p0qJD/anoZ7xjGI7j6DB27i9Pk66mluwhhvPDrzgeDUULxM5eXiN8Q4PfdotxYY5hVP5qLRCQYlb0tsPjfmnGn/7ZlCVIuBKS9X1hP9eiUH5u5bYMwNMlv79DDEXyvpsisnhJM3eZ8AWHKDOLXrjwNOG0RqV4oQ7x6SxX+bXaadp7UUfj1qsylN/wLc8CHEXd3x1JPCj1nnr13CZO0pzz/je5ug4GH82XLOcH5TggBWGKmzTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 10:32:43AM +0800, Qi Zheng wrote:
>
>
> On 3/25/26 11:28 PM, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 25, 2026 at 10:13:22PM +0800, Qi Zheng wrote:
> > > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > >
> > > The memcg_rstat_updated() tracks updates for vmstats_percpu->state
> > > and lruvec_stats_percpu->state. Since these state values are of type long,
> > > change the val parameter passed to memcg_rstat_updated() to long as well.
> > >
> > > Correspondingly, change the type of stats_updates in struct
> > > memcg_vmstats_percpu and struct memcg_vmstats from unsigned int and
> > > atomic_t to unsigned long and atomic_long_t respectively to prevent
> > > potential overflow when handling large state updates during the
> > > reparenting of LRU folios.
> >
> > Do we need a Fixes, possibly cc: stable for that? Apologies if already
> > asked + answered.
>
> Before LRU folio reparenting was introduced, we wouldn’t pass in such a
> large value, so this wasn’t a problem. Since LRU folio reparenting is
> still in mm-unstable, so I didn't add a Fixes tag in [4/4].

Ah, well these patches should be _before_ the LRU folio reparenting then?

Andrew - can we ensure correct ordering here?

>
> >
> > >
> > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> >
> > Anyway logic seems fine to me, so:
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Thanks!
>
>

Thanks, Lorenzo

