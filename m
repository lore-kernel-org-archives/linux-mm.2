Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F0FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CECE6B00A3; Tue,  7 Jul 2026 07:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6AF6B00A4; Tue,  7 Jul 2026 07:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC786B00A5; Tue,  7 Jul 2026 07:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5191B6B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:34:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7ACD1C38E1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:34:53 +0000 (UTC)
X-FDA: 84961773666.26.94C6ADA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 293E6140009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:34:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxElatQY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783424092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xD7a/PykFMk76eX8/Vohs5LQ/Ovej1+QHxfa9aUv6iI=;
	b=3RP0a+F3rKyEpyPGKKRCTZ0fK7TtfaCiP8ErSj0mIjUG6h0eck8vHWS88MC6dZAPWe18hS
	VVgxACXD1V4pweDHGy1/nd+WCuhkWXrASodGBa7VrkgnYqmzbRcrwS8JXTsTgRd0Pi2p6s
	mDThTh7OC1LvoFlseemOiVWvBLhR75k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxElatQY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783424092;
	b=If8XSDyZCfXmjweEsdgCgtifHKtV+JQbP+VD8Jx11nGSFLLc0/lAiwTdczc+UnQQoQPRJi
	vkVpwCccgN1HqSU31TV0apP74Nvvuc0fWocLbJotAOhr/qwawX+nLfNfR61zu7C/MQQFUT
	ZRqqb5dGZLdIemLqGOIMkNgipluc/SU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1033C405C7;
	Tue,  7 Jul 2026 11:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386571F000E9;
	Tue,  7 Jul 2026 11:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783424090;
	bh=xD7a/PykFMk76eX8/Vohs5LQ/Ovej1+QHxfa9aUv6iI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=KxElatQYxv1NDV7ZRp28MI4mwxdFDntYF6Wepqb+KQ0fCpXULtGhYLd1ZwhCpwE5t
	 smUsPY7tDXC1bPg67nofX7s8Zo74QTynRz1eShZn35qt2duFR5eYxL6JmgjGjMtXhv
	 zsMPeiuJAJi1POB0mFeQRQynkJe56KdkvaxghcaRLcFsNZOHNBnnXqmO+380NF0w0z
	 MlrXBWM5TER/rH5e6S4PzGWlxXoSKiQnmgXK3blzKFGetTn5VZlGGnH0Pn7GRKNSOk
	 Dxpmkz2e1ZSjzv43OudYSdCbrS5nXC1YDfyJVuKikpnW7HN1XZIx/uCusz4ZEFkQzD
	 boLajUpNZhiiw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
From: Christian Brauner <brauner@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, david.laight.linux@gmail.com, 
 jack@suse.cz, jannh@google.com, kees@kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mail@johnericson.me, 
 shuah@kernel.org, viro@zeniv.linux.org.uk, Gemini <assistant@google.com>
In-Reply-To: <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
Date: Tue, 07 Jul 2026 13:34:46 +0200
Message-Id: <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1976; i=brauner@kernel.org;
 h=from:subject:message-id; bh=zBPUW+WQ/GjuRupYdwz/7FHmp89KGxrLyUS9t0y2NyU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5PAm/Ib/tm2Wn+4vyDv75We5Ws38unHZes8Mkw9zG6
 JnkzP62jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm8/cnIcGRNwrINtdMr/8eX
 hyzkbDET+dxxbnX9Zz5vrp1LRfL2rWT4Z7Dz3jdV9ijN8xOEfghc5k3QOpNw8bz073THWa7T38i
 asgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 293E6140009
X-Stat-Signature: kashdgsfidydp1haad9fkhx8exge3unf
X-HE-Tag: 1783424091-398627
X-HE-Meta: U2FsdGVkX18OOrrSqQDKVERYZnaqpSjRxNDqDAVzxXXczOTNHNM5Vhxcc2xwWDItU7VV+RE6QU+Yo1OcyzwOUincWQkQMay2EcpnjOr5VcfFP6EB/BEsParWzoJeg2p/6ei2q93NmOqk/GPQEk1M0NW2HfJFLJUCkTvk+/2iou5RwUQFHTbIPm/s9zPOFPwi4C/ggX3KvAZhskPbr3MuZAOh3o3dLmiyK1XHIZ3K5/dbEnf587Gj1CBSHA4wQsMQgAseCW8eSCbDaVDZk+QddQ+lUOEYPTgEpZ9LiX4glklddxQ8riaK/5SPdsO7bgpA2S6gPEqzUBQjCYX+tXJJMZ0WuSjneWwEL7Cnp+NU78dDtL7s+9GVCD1nCgVOOxJVqbRV7YKwDHWhI3HsyuP+mHUmKdof5gCikXDnFiJ0xporNWZTiu3A0+uflTpQYRwyU6nJK2FVn6JH1g90qw9AdVMHrKQz5vxoC1nowldcImrRINfAxEjLfOLwtH7Nlv6rmtg8LZ5MVdV14oowu5m2B2Gj7NGWbWVaRGW1wWu12YLe8BpPslSG61vfsdbLCfIUL72dG1VGt8m/nyDgNMGqL19T5H3XNcyvARWKtSVWDDdMn2xIWvEeCSHf/M06CEcDwabxEFQKHdjqanwwHBz+5QkKS2+AKXcfR2vVY61GVGhd9rSATZ7dkZCZCH05loBElsszUkFFpM49Du7RI3xZnhZ/tBVJF/fYh44BqjEOfUFVtipWqnelCFw/5Wb9nVN5E757KHWFL/I6Ozi9yHcOJTXz2ij9BAg5h/4p6AChEdjouD0lU6wHtxl3Fi1yxoJzIqsDGs+KdwPZD25yq5YFdddULxYC6fpVsTgZS0F8jD51+TLz4H9wR7G43f/W0YnBiwTm9VtacdZNOzglfZ3AZr1QjPk++THNXd2cNWUJg+c9uAlLf057yBnoy3x3ZjQRR41zg44yj2fd4HwDhr8
 mX0zEzhu
 AeqIw5TVJeObiSRBQ80QoP4k9xyqV7he5DSvmYg1upAD0+clleQpDQZWh6LPBNVvaoqVt49sQAfQk76bitfzIcT5mRliCFJr1uLX0vz5PGcDH73gLd47PBZsgYRV/qz27Uwm5aBs8yzbFZLcVfP6vlQm10xt6+nP1eASYLTc3LtV7GuVQY5rfovEVKaAdKrUsnyph0cFrhKLmLFvaBKPS1CnwCYSzpPRyE8k96QowEDz47JeoCQHndEVUJfaU13G2/qJPSTdi5rXEY2xJD32z1bf4f7ZhabBOmEZJmWHuirBnvZESp/uilmMjW1FE58RgfTjcnBuhYG4HGps/rXoFRNUj/0jEuB9wWT8VJiIaYi8kmNGSHbZX20ynw8QETXMHFA8WBuymVUxTghBg/bawWKUSdIOoEO2ACwFffcavomMuu1A0USdjewea6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-06 09:47:53-07:00, Farid Zakaria wrote:
> On Mon, Jul 6, 2026 at 9:01 AM Christian Brauner <brauner@kernel.org> wrote:
> 
> > Ignoring the blatant bpf abuse here I think this is quite workable. So
> > this can be turned into an actual design and patch imho...
> 
> Glad to see you think this proposal is in the right direction.
> Just for my edification, when you say "balatant bpf abuse", you mean
> how it abuses the socket bpf type?
> If so, do you have any guidance on a new type or should I just take a
> stab at it.
> 
> For the proper RFC patch unbastardized with tests, should I start a
> new thread or is
> the convention to keep attaching it to this same thread?

Always start a new thread and bump the version number. So we're at v3
now, if I'm counting correctly.

Fwiw, if you have access to an LLM you can try and setup b4 to manage
patch series. It's quite easy once you get the hang of it.

> > Note that binfmt_misc is namespaced and can be mounted inside of user
> > namespace + mount namespaces fwiw. So a container mounting binfmt_misc
> > (a fresh instance - few do) would escape that bpf program. On the other
> > hand it would allow to register a custom bpf program per container if
> > needed...
> 
> That makes sense -- but you will need CAP_BPF etc.. to load the new
> programs though
> if inside a userns.

Right, bpf tokens exist to delegate bpf access to containers. Not always
ideal but it works for such cases. My main point was to communicate that
containers are able to disconnect themselves from being able to execute
binaries by mounting an empty binfmt_misc instance, iirc. I should
remember that as I did that work but I kinda don't exactly. :)

In any case, I think it wouldn't be crazy to allow registering "default"
handlers that appear in all binfmt_misc instances if needed so
containers with separate binfmt_misc always have the bpf program
available. Just thinking out loud...



