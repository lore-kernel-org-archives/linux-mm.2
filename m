Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8765BC5DF97
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 23:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447D16B0095; Sun, 23 Aug 2026 19:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9106B009B; Sun, 23 Aug 2026 19:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E77E6B009D; Sun, 23 Aug 2026 19:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 066AF6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:01:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 700BA1603B5
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 23:01:43 +0000 (UTC)
X-FDA: 85134058086.01.4A249DD
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 92ADE4000A
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 23:01:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=u8UoykBT;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787526101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBBDznrj/QvBtLL3STRylJUtnIkvdfK3qqt1IzYGCsg=;
	b=QhGOauZKRVWvpv+YB92pPUCUZ9u4weCWw9mqJEmd3KebV8+rhNvLjE3YVATWFkJVFudUSl
	pFnlCi3p0K+oozyMutxVz/BveYZf0pU8oWLxHByqWW8tO2dh4x9YVXw67U+gvc11rwXxA/
	Kk/XZ9OYohHCSL9mtfYcz8RaSleAEuI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=u8UoykBT;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787526101;
	b=SRQ9DxDp0229evJxhNbtPSbNiHpyRHahyEGWxF4/rrlWaDIA5pMEIt2qx7aCuf98B55gdK
	AGCM0xDoqAF7mM6pUtD6b+5ioJ4wTw6PBWh72H3mg3j6XhF03x/IscBRVtppUNoRFWcW/G
	7D/XFL/iwB14wcGYFoEEliDc8A9Hun8=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5276d598b96so13975481cf.3
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 16:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787526101; x=1788130901; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OBBDznrj/QvBtLL3STRylJUtnIkvdfK3qqt1IzYGCsg=;
        b=u8UoykBTGmv/xEoS/uDwP3QAbEL6pD5K9vQ97Cv3j58We3koB5Naasi5/8i1oGRPzb
         qu4rJHejrOVn056oE1slhSYhkQH+ONXFofQaVfnriUGHy2VyuoR+DM0+lDpZs2FP8HBF
         r4raAH6rFtamE27jETYYy8o6JiSjHA44Y88vIP+3n+iwMjwvkj6BvTTnAAYB4t7M8pTr
         K2LfmKq7umH5af8Ek815PegHB/HEAfobzV7tsncpPh5oLQgpf5OoMfS1yPNfqmg79rdx
         Fo71uR128kkTi/eeB0a6warZZr4/+I2Ew2hg/IpthpNd3KiSQNw896jlkTEyRDm7L1oO
         xeLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787526101; x=1788130901;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OBBDznrj/QvBtLL3STRylJUtnIkvdfK3qqt1IzYGCsg=;
        b=sKjFDRDHnjZf8SX2ngtKc5A9nbcQmucbZMPz14PMBTs+Ov/e+lalJLtV6L0vNr2n0z
         Rci8EAFiyIeB6GLVllwrpZOzTwIBpbWCMhhqy8kJurUo+fQA5W5XGIRWOC2zZ/xleWAC
         K3w3aBMv8F6rPnn3NwJrsXqbkrQNeuvCF3Q5MfsNniFiIra5jJXS2a+ZTg/hHVycOAfn
         ENRdIUNPZ2r8qMy6f7MGVYvrSFuL/UUBgWoaHydTP1bkvltEnXwYFgwtdIAP+cmaZrLs
         ddDkieAsbWTZWZsMrAQetHNRT5cNAMhW5vAi/ofjCwyjetgBY3DgDmWgXZjkQ4ORN2wU
         WYPQ==
X-Forwarded-Encrypted: i=1; AHgh+RorqDTYRPVi6dtWO0PhW1kjtfhAJpNejwr4CvCsk4mA5uHqByGJJBKb/7Zl2H2MDubgbjTg6b3c9w==@kvack.org
X-Gm-Message-State: AFuF++mVPLgR+wb/PZfSDBhrD7gqELAyRTXFy6MfUBmXAYfCFPSSxfPn
	3i5b7VJ29539lrtD6iuppaSR6wO4gvrQPfLx8OHt6b+G8wQCGqqOlNK/O9CID1tUq0s=
X-Gm-Gg: AR+sD11iCOzzfxoigFp1YnKe1bwdpXG8TCfl4fdRpt827MLjjprH3/LF7eJ11vk0P/v
	khC0EmdffOgZBGWcEq9pKtIVuvcsBBowzmRoXsjP1gZVL1/Cw2wOTcAA+LP042b0L51AaFhvGas
	HY5UnaIQ74zSl9C9xFBZqCXCb9+qCAextS3SslL2yKiUrjU+tts3DtIii4gfUOQE3JPgD6lLHPy
	jIrDJcfoLcg1b0iQFA78GWY3BGNUOak2zroyVzeFxwU96DQhGU54+ACTyqZ4+reZTwp4D15ajRL
	NxbUv27y18kxv1xDqpp2VYDG3JKXpdECyejhChnvPUGh1Ozjp9WxFVqqmb2kh8so0tDHWFwuYF4
	ciHjIqQ5mbd+OoJCeZobqJfnlQatoDHOoSmYiwZfzqe6QYC9arqr3YAwlqhBszmd1fVUq5Xi2s+
	4twXP2w8nvjW0Qra43Lu3Uih+N/jCom+HEeLIbJo9O1C/YU1jgrWf5jjXrAwdsh1PyAM/bjaTag
	Xm3u7seFGzPe0RGFueC4a47kQV2tXuSG567S9sQkLlYPAD4giBuoh0=
X-Received: by 2002:ac8:6f14:0:b0:51c:b98a:2448 with SMTP id d75a77b69052e-52df56f9741mr225201801cf.9.1787526100658;
        Sun, 23 Aug 2026 16:01:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e09aca49dsm36057701cf.23.2026.08.23.16.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 16:01:39 -0700 (PDT)
Date: Sun, 23 Aug 2026 19:01:37 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <edumazet@google.com>, 
	linux-kernel <linux-kernel@vger.kernel.org>, syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: Fix sleeping allocation in
 alloc_pages_bulk_weighted_interleave()
Message-ID: <aot5vanOo6bZIkXp@gourry-fedora-PF4VCD3F>
References: <20260821170407.3721004-1-edumazet@google.com>
 <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92ADE4000A
X-Stat-Signature: n83gg16ogf1x4xfmny6spdne9qy1aonf
X-Rspam-User: 
X-HE-Tag: 1787526101-702814
X-HE-Meta: U2FsdGVkX1+sT9H/Df/Br0nvNLovAO4BJEiuyq4Us1rmvCRE3KxD++1r0OCKMD/jCaonGFzD7yPxZLfBL4CMFsNpckX3spYJPKhajb5/9zhghuB/5SyANpOi3XpamxiLTMWOAWbRspW2lkXnRJBG5c5RRfMzsBKXKpzFNoo4HZy6xRSWrjw1TyzzT/n2fTKbd0DXNFP2XVD0zZNmy64tXRLxMkHzW2hMbEiDwbdpLW3xDLojXUeJSR8qxA0eq//KcunzaiRBeACVXd/n8gNIclJ86kWC1slPhB03gbTmP9r3W8OYYSBYOHWTcdAuEAPPGHDkRm3CKDFkoNXuaJcWMAlD/Tegkji5fFAGiSnxk4km59FshjkRO1pJEgvfcTQPZuELzPVz5y1JxIqUPHBd5HePoYBE2kJgLH98ObYjs592+kpM6FYC4ncROTTlrbMr6Bl0bX1umA3i9VaybxgF4V6jXF8C78wUJXFP9UfVkNIZNfSyeDiKVEkXVRJzOr8XhPn273qbcoxbzMdfs+8wcFZ7XEyG9KGDClEIhID0T5rwZ7xyxM631WyncXif2wAQRwGw/gcBNUGIcXigc+UXYsGtMJzY0TBBzl6F8sl2CrnuC6EKRih4XQd0ltePVrx31wQUcn3dqKPj8rzWpdUa9sS6bL4w5hQpgv+A8EAvUG3wwjMrWcVnA/CNjNGslcBqE/tMB6QRpgU74f4WPTuWqiNKm2jg9kg3gTVaaSrFxCyYqn3YxXW17uuh+PcXboNbNdYe0RuJDaRmZz2ZZMTsSysW7HT9rIIufGRWcNOJoBdwljytUsLi8jmiWeHFlNPZVqgrcdLP0TtZe/0KXD4AMHBp8qeAr3la1eDPW0rqf6LE/ljFyw5XJqfCOJi6PFFdul9wo9Sz5KIUVmfKeqJ7o8rybclC1YXqsYX+ggZrjA8RRyDojT7NVn5+jo2ZoSnAusD+1a/kJRwWMym6lf9
 liG/Amcx
 Bw9izx78+6YB2Ijb2AxgiI3W1bcwIOTaIGfSUDLXrRR+f+HizaCn+V6BxW2BznJvjvW+3Lpxd3R8m1zCJpWsJNECZfW2RlIpuirtQ6JJFbxKXMUlVZ3Bp6+WZj1ZkM3gmsrXw+L+RW/Q0ckqWqe33BrvdGZ7iaz2AB4S41F667bpsnHvaQmVQAM3K/fAZQFPipqrEslgcoC2H9AX9PVR8VtG8zY9wnCUFOD67OQn2FdblyKYSAJ/jVLSf5EwGpqUkeG0xDQ9qrgYf+hPYWMiK31TK2gfCZpsCiXe5GhVqmGMYTMQlIHHBTRRiDmRsYELB2wtBMnIM03eBHJzk3LaKNceZLHDiOEi18ikMYVpwrMJFtwjOrJhmj03+PJl3mVxNaw8IP/v4q/F+yMwHmFKfDM/Bdq+3ePHOZBIpzJ/WACjtBhWe+V8K7HZtOt4/bQAJX4oaVSCTMfnCH3ep+MXCQwLH6lGz0he0uy13I2DeZGamq5TUCtgghCtYpZx2r5dOFPks
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 10:40:43AM -0700, Andrew Morton wrote:
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -2688,7 +2688,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
> >  	prev_node = node;
> >  
> >  	/* create a local copy of node weights to operate on outside rcu */
> > -	weights = kzalloc(nr_node_ids, GFP_KERNEL);
> > +	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);
> 
> I wonder if we *really* need the local copy of state->iw_table. 
> Perhaps with appropriate care we can directly use state->iw_table in
> here.
> 
> How much would it hurt to expand the rcu_read_lock() coverage?
> 

Ah, the current space we'd expand rcu read lock into is the actual
allocation - which we can't do. Same with the spinlock.

We can clean this up with a refcount + rcu_free and kill the allocation
in the hot path.  Will get something out this week.

~Gregory

