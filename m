Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B6760A261D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XCKMUP58
Received: by kanga.kvack.org (Postfix)
	id 9D6866B00FC; Mon, 19 Oct 2026 16:51:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987126B00FE; Mon, 19 Oct 2026 16:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D766B0101; Mon, 19 Oct 2026 16:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6086B00FC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:51:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1562AA7B94
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:51:34 +0000 (UTC)
X-FDA: 85340571708.05.C91B31F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BE22020005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:51:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XCKMUP58;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792443092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z09TlHme8s+UYlN6I8GSIiTbNEV9B18/ss/FueYOjmg=;
	b=l5mjBjknkE0imIc6gE5nm/+mUQ2H3IDAQjwvB+h5bRj5qhfotVzsiIJlET0T/6uDATOvZF
	RjyqMZpnPV4DkIQ1IfvgXrQ6jQDcqv7PgJmQrhvRPH6yAM7V4Pic9/NnHHIUdxwkupA6/Y
	DP17Ir+N6mz89JQDL2XYNQYRWOgq2uI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XCKMUP58;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792443092;
	b=YvmU69OIDoy6CoL2tLJAm6xqX4PCjKLirMG6cVGDpX0O5XcvOhsvbgWvUQSw1KGlaShMpF
	VUPhpGkDWxWC2UVrFBPX1kH+RHt9d+Vrjw8Pe10omYIDh2gwBe9817xKxklbhVj/AGmJ4V
	tlK+l/XtCz28zsZvpzTL3xILFjQs6nY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C89C42A60;
	Mon, 19 Oct 2026 20:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97921F000C4;
	Mon, 19 Oct 2026 20:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792443091;
	bh=z09TlHme8s+UYlN6I8GSIiTbNEV9B18/ss/FueYOjmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XCKMUP58RqYYAGi8f/qrT4MupGAV7Y/5KbiQx2GN7ryUsajnzax1rAUyZszN20opG
	 8TSyUYoJevEScTJN+N33VeDVqLmhdo02wuISvoi2tHkIQtEsLoV11SMCFI9f/qrcnL
	 AzZdQo4kpx0DqPNPDwXSI4f6zY9/KVFOHx9CP2WwQs999f0CEQIO7T9ZKGqxM9AUbx
	 C656DjxNOzQAKj8CWqFAOF3T7iKu8kJxeSf/o4p5pnihgRWVkpYRjRY6NpMVAAKcPK
	 3lxxoHPYwmJazhosRodJTsYxYkpaftF35bnvPmz9fWWAvJH6wtb6g/4Y/pqzDN7F1d
	 3+T825S9VgMoA==
Date: Mon, 19 Oct 2026 21:51:29 +0100
From: Harry Yoo <harry@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, ljs@kernel.org, dave@stgolabs.net, 
	roman.gushchin@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <ataClWf9F_zp-KDh@thinkstation>
References: <20261019185002.3428594-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
X-Rspamd-Queue-Id: BE22020005
X-Rspam-User: 
X-Stat-Signature: qf1az4stfbcswk4mkrp1hj7ukrgfm4ei
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792443092-244691
X-HE-Meta: U2FsdGVkX18olkJJ8HA1f/A4fZCz3syq9u/WaJDy9Q+IvRBg9a9mlKari2gRbXTEMC5TQXoJu+TjBmJbmZzMqC+RDOmSo0dwKsvp+/o6rwPJ3CP4djSYxHvQN4aNXQayqi/TxszUmfNp6tHJlbIomaB8tN+8tjg/SOzJjg2pDd+ICGw6mG38X5RLpt0vVPVL22o84JNgb8U83pscHrrGtMzv24doEaO3dwm+pWn+e7qp/Ly3Rsw1Jnrtg9HDACEc4pbKO/82ULphkjrNJD+u1gNC5V4druF9WI69r7mc79JuQkBIZfz+frP9NcKsfTQ/ogDHYG+dMkaKOoNYuZ7gkrv/D5U6pLYNuCaOpqTUfl6gQ4oTDiDE1+VGZu8r+x3+/Vx/+WRFOMJhRHpaxoblrutYR++bvXZ8tyMUz+AWt3C/5EUCDGRKFFc5bKTxWAS26kkaSm+rMtttZYD37lZW4ujuiJqTMNBPAPQddstvukF+ezIo5HvBi1gtYkT+499PxhwW2FFUaZX6pDLeITRqU2cg2ErLsGGjYXY6EDpOICEuInLSCvZ/ckeVTBUylhUCxDDNtuXAC8WISGg+K9gAX4Fov4DExPxQOi8rYqVd0nsbadnlCUxIf5OTRBqyA+Fn1/glilnvkWdlrMSCvjbcgyDl9uqM56qkLsJ0R0vl5WkoRPc0aXl3RIjdPT5TvTJhklBV0307CPai9fIjS9y+2KDY381Cwy708VaFH1WjnrSox4pqRLN0etc5Lxp5KenKvVuR4floQa6N3XVjrID3NyHNBORsv6gA+kXxk/ADvLIii7XpVxEUM17Ax1X2/dzM+Y+auH+AyIM/sC12mGGqlXRJNWObPocHwnluLXaBX2n/6LR9GhlinGAi7m5tdrvUjTqThx5QCvaETyZOrqoF1Zw+WyK/NIY6N2gf+vxWAPSAWpjXnbDK9d7gBz31tBSHHSi+ugEamo96ZMfANgI
 FXb/P9HD
 4QTuKw5P9Xt+RBRfeFO1JXY6m9R/Frs+QNOF98MDOYUdZN1tOoMiIv3Bnayf8EqwKRwfR4r20rntcN71efIt5S6eF3kthtCc1Dcw6E+EHNJ436BaXQPRSvJVUDrPn8f+483b4PWC4Q1RbPIBYcVMEKDZ0NW2eYumTIOOnv2KQhky+aQuIeXOJLNr+i3PGVeUvJbU7wRNs/AFB6S/U8QlCezHve9yEWtAyrVyLuZihRWBmptLq7TctG6xL4YOaMq+Rc/eUKQdcsj/60F74npzdSf9/5pWYp6Lqu0Eg0+3FcM46H79l901afGrZ7CADXx56vQdrNXhnND+R/LO27qOzHy2R8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 02:50:02PM -0400, Gregory Price (Meta) wrote:
> user_proactive_reclaim() limits per-node reclaim to
> gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> reclaims a node's movable memory. A movable-only node, such as dax/kmem
> or hotplugged memory onlined movable, reclaims nothing and fails with
> -EAGAIN.
> 
> To reproduce, fill a movable-only node with clean page cache and write
> 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> cache stays. The same write to a ZONE_NORMAL node frees 200MB.
> 
> Scan every zone, as memory.reclaim does.
> 
> Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

