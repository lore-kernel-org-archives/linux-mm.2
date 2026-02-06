Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A98D3EB28D0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1806D6B0089; Fri,  6 Feb 2026 02:00:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1246A6B0092; Fri,  6 Feb 2026 02:00:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057796B0093; Fri,  6 Feb 2026 02:00:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E651C6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:00:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 924C9C2848
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:00:43 +0000 (UTC)
X-FDA: 84413133966.05.800389E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf22.hostedemail.com (Postfix) with ESMTP id C94F5C000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:00:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xqFEx38G+SryJcWFVHu2y5RWbjgEAeSkegKncOIohRM=;
	b=mUmP6TFd/GZohG1f9K2GlYkKF4642oRLyZg5493VQc7/Bc92WpQrWwb+D1C5aPkqn6oJll
	wtUZpJsAe1UnD3D+XYNPfCGexG2/oZvVPNmkolO+pSTZHql//YkYU3Mgjpg+b2I4PNV8yv
	2ZsB/zIkrI5dQsEPNcUkSp0LNxX8Aw8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361242; a=rsa-sha256;
	cv=none;
	b=EiJDqjJFw3Gtd/zdiE1zjfokkBJhFi2nvG+EHNbqVfXhl4alcppA1TuDA7Ni9kPVz4kcP3
	89gjOhMJfxlz/w2Y/fGG3laL2vCDlpUqC8ABFcinNkiwJ5WMtD09z54FrvQvEtaOdcrDf/
	/S/MhiJmNIgCYWaj5bwZGt2pkLc1GkY=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DCD468D3E; Fri,  6 Feb 2026 08:00:34 +0100 (CET)
Date: Fri, 6 Feb 2026 08:00:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and
 dirty-AG bitmap
Message-ID: <20260206070030.GA26818@lst.de>
References: <20260116100818.7576-1-kundan.kumar@samsung.com> <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com> <20260116100818.7576-4-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116100818.7576-4-kundan.kumar@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C94F5C000E
X-Stat-Signature: pu4ndqbkqj865qubkrwrxch4tb39gp4t
X-Rspam-User: 
X-HE-Tag: 1770361241-39345
X-HE-Meta: U2FsdGVkX1+dRSs2zkX7NUr4CUWnxrYoPzvC9xuTe2x59A0tASm3McblP+NdCOOQCDsCDt+m3xxEes2P1IFoFTdZQm6buqCVCrxg5dmtRkWr8jvKZVLtwjqWlyQZUSD/DkL0UBqU/VyWVhJLUkllgRe7gy/qg4tTwzY8uEGdip6X5Iyzj2agv0ZbjyLZsYP03ISZUo8UESyo+q92IhpyCXrdIS4i3GaBCHQaDgnnsBVYEWe7ikmUYX4sYdamuLZr99kzNKzT9eS5nvwWvev5xcrp6ATpnavj6WDQH3sLvgqP2Idc9u1XBQsC8wQd79SR0tlqoNuX3ETq+LbJ+85+MQgMu9xSvWW9nEhd/5/V0JI7j63sm5/KzxJQsj4D7OuqRqK1XPfFYdlZUmdR3vPQzuF7jCPU1bt7ZEVDZ9uo23zLPo9VDxVGoEO8l1OtcUYyBdWY1BPnNFsiPw3+NiHSBz+2ehyoYFLU2u8Jy4VH87/uGwdbeVPG8VS7Ao0Lyk4Y0U4NGIFaA/+s186l97u0OCoyTqHmVxzT44VEceg0RvdeSe+ay2MgE42Hj9Vz0SPySO6F8mWO1ZaptDqF6FXl52ka3wbhfdJF9mfCnQ0t+zcFAM3Q2+uNBsLZ1pex96E7qYI7jFlcPIU1icKVgm/QltxUCrl0pbGFu0eIGoXnMoaSAk/XwkvBJzdjyWdcw7S4W12Er5EyzacWIZiOx2OgXk5cVHJPnVYj7xtzlFhNy3WC92o0PIKKpV8uqzSvBPUUw/tvPR9MFPO7510+jnWREZ7h8r0JwGu0GrpW9yS2qvjYaCm6w9jcA3cDZLoFXEJfRdtix5iaPLYD3wZX3KfYeCTRG5GGG6Q5hnyDnJSZMy/TlTQN6tiOSE9FbiaWLMOKon2r+SCpQE69QhQa5kv2EnOPL+DMuSuGmhrTr6qD5AwUjNnbSYsZbess8Im2gchPv3WKuPEyEMGoTpRxQ9f
 2NHWak23
 53LEIQyHYl/MqEpLO4dZXJilWU+/euI5BjKsoc/cPC/rPW74wKu6VOwjBCAIkW4bMsixUr+bRMqfi534z3G8DJWanuJP217IqPxio0mnPmIaZGcLx8FaEMIb7nVUrdDEX2hX6TVdmY+6MaNAkYA7J+aOF4ujnoO6f/J5XpbL9/TAyLLI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:38:15PM +0530, Kundan Kumar wrote:
> @@ -99,6 +99,11 @@ typedef struct xfs_inode {
>  	spinlock_t		i_ioend_lock;
>  	struct work_struct	i_ioend_work;
>  	struct list_head	i_ioend_list;
> +
> +	/* AG prediction map: pgoff_t -> packed u32 */
> +	struct xarray           i_ag_pmap;
> +	unsigned long           *i_ag_dirty_bitmap;
> +	unsigned int            i_ag_dirty_bits;

I don't think bloating the inode like this is acceptable.

As said in my reply to patch 5, I think we're better off with more coarse
grained sharding anyway.  i.e. just track an ag per inode.  We did this
for zoned xfs by pointing to the open zone using the existing and
otherwise unused inode->i_private field with great success.   You won't
get as good placement for some use cases where files are fragmented over
multiple AGs and you can please near close blocks right now, but you'll
save a lot of overhead searching the alloc btrees, and probably generate
a write pattern more suitable for SSDs.

