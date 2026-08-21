Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9341DC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 13:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A458C6B008C; Fri, 21 Aug 2026 09:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1DAA6B009D; Fri, 21 Aug 2026 09:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939B26B008C; Fri, 21 Aug 2026 09:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBD96B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:43:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08E26C013A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:43:36 +0000 (UTC)
X-FDA: 85125394032.28.5F87A54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5DB8E140006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:43:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Nl/WZpMa";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787319814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aquc0vxWZALAjqgmKU3O8fgPD+LqPPKkZjDpVR5CRnU=;
	b=IG+vcrTAr/SJUGaNucR+J97WxbTe4plOKggaMJnJIgd8zQYr/G+fyYgvfiISeXO41hWTtg
	1Alucq2MoHUQPEKg8SNYmPYqZ2S2mulcHP5IqmTk6ru8D77vpZ+CkLIappFuhcNBFr702c
	Sp1cFdnTnhL0rJOUfAscUGSFlxbiRbc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787319814;
	b=xtZ6obydptazGXWLyDFIJH4CT2OuDrGHvQsN/t8zEV2PDToMNcOBDgVOE7NK72vE9iu2N1
	I8lo0ptRS4YTiu+O9Fgogo75NelTJ5j9At/mSdyCZStHKgXWUgRu10DjW6B0mvt8o3y1MU
	cfNGOQxFjAFy6+KK9v1fFv2Bqd3BCbA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Nl/WZpMa";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E07BC60008;
	Fri, 21 Aug 2026 13:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28EB1F000E9;
	Fri, 21 Aug 2026 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787319813;
	bh=Aquc0vxWZALAjqgmKU3O8fgPD+LqPPKkZjDpVR5CRnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nl/WZpMa0B7PsT1RI21yHaF56mr0V6/CEKrQ6/hWFNAG089oya1jhdHQGgciMfAnp
	 RkzC+fzQxwP/mNwdypDjgO5xT7LMSw+WxgzYFlZutpkdjwtybpl3cVCYLluLnFLlsD
	 T1hbeqtPc9HnYpIBuTo9SI3MjOxr+O7VJggB+B5aNBg4DYLhPE4e8eA8no0PZD+ZmF
	 Igi2o3mcJ1gzXnTjh1KACebRmk/xfS+cLozBfhep2xMDA5CmaPbMjhNMDwaqW+E7P2
	 InDKic7K3rLUMtEJO4JcE1tMGVNk0iaC7hXmnBvfXItGNgqx8up+pk67i6Z+0PmUOF
	 mR9NTzhwUqyXw==
Date: Fri, 21 Aug 2026 14:43:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aohVxL9ww9wVk5uL@gremlin>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
 <aogQ6iDA7RkuTtDG@gremlin>
 <aogYm0fKNsYVyBM8@tiehlicka>
 <aogxgLSLNixXvuUR@gremlin>
 <aog2AeQ2X4KSCkOk@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aog2AeQ2X4KSCkOk@tiehlicka>
X-Rspam-User: 
X-Stat-Signature: uususnmsp7ph3gzfctr54odkhu9yryrh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5DB8E140006
X-HE-Tag: 1787319814-26946
X-HE-Meta: U2FsdGVkX19kCPaZbqqh71BIiNHLQ/Wkvwip9/UUEhFmXsqz65tb02Du9Yuhug8p5bUGTqQK3mB8fb14pPzdBZJUaax8xwkMKy/ZAZ4aJEqtFsL/SlmRfhruYX0PpMDO1rbEBrzQVY1s46R2OvUzSMutQ7BbUX3Pbm97P4R2oBePa+Q0BjIkKZ6ebGjNRObXEGZaX9WuK94OSa4IcoXLfto0SYdzrLCz6vS5wG4y1um09j+BDMmt43++VZoBs2SFkFBYvY4GMlAPFXX3/QDCB+kZCfgCqYCzfDZdja9aFPlbBmYejpaLN/N+37X803SohhVn/YtZlvXzyYZyjueXHRWjnos/JBZ1ag/P9DmWvFwzQSyv6LuFBg9Sgq2pbpkuv43ODLlWLwpRTBnYN1QWQStgm/OYYWe+ZpJLD3uzQGAJWXomRHBbJf3l9ucTNSArAreijEFfqBcNeC78tT2RCBsV/+WnMgj9nyndv18EH++hu1nqpBAwejJqPWQZvS/ZKbsfn3Ik+5aSgJ6JECwRnflkWf4ukZaQ+4m2aq8rUbfvCSqaVDSlaRwmYbuRWNUcguKN+IvVD2sf5EnMU2GPh0i3qDRSmo8CtsKQZVgfT4Qlzoy86X2903oeuwAVs08aQHUD2G4wLsfPqM+8cEWcH2ImvrwIVLlb6cnBVbGwDKEs/jzAqXQxJEB1hVrZ34OC3Ur147lyC3jYGzP1sY4x8P9JG7f6Xx2+WXV4xbB9VoZvcHFmJ+cyABTvl9ftSQ562Nr3zkEXxoaXCAZbg4KDOsSICuCkNVdBwFudpfnBDqnV+uox+O8ypHQKg24qmbEDHb1MssiJhyLJfcl+ST9T6nj34xPyXi8RQdZgSrZ4UuWM+szrrGeVrzoHwvrvHyAoGrwmzefEPuuPplNhGipkLJqtmoyphMPz01OkmJaApkWk9ltQ5Rvf8YVPykRiuQrFJdLYwVlPFBN4SW5ZizP
 6KSEwD54
 uEDYmiVlsnbWXYGpfKTlzQT9IvVEfOCUxa2VAEXNKmKQKJ7KFLjPPLhLJbYpAc5gO/DEpROkv+h49FH0n0/htRlGC7NlJPsKXtKh2wLx5nMQYd7ESyr9tLs5ZFspeWWOy6iH8GrS6Vn+SnCffXa6fDk2IExPUZkQ+jaxfkFn5eyr9BG7veIQG+kosd01EVFc3grHd/tAJfMvdiIHAorSpnugtas5jSiuetujiOEqqQudEW+iUePyiB6qouHYJ9Ptp9PFT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 01:26:57PM +0200, Michal Hocko wrote:
> Hey, do not get me wrong. I very much care about reviewers as well. I
> merely wanted to say that we've had peaks of tool driven patches no
> matter what. Things have eventually normalized but people need to be
> educated about expectations of maintainers. Sashiko suggesting "but this
> might need attention as well..." certainly contribute to more noise but
> keep in mind that AI driven people are going to find a tool of their
> choice to arm them with ideas to implement and post so focusing on
> Sashiko is not going to help all that much. My main message is to
> establish and enforce a notion that patches are going to be ignored if
> they are not justified properly (even if they might seem technically
> correct or fixing a theoretical problem).

I couldn't agree more.

We are, of course, furiously agreeing here :>)

> --
> Michal Hocko
> SUSE Labs

--
Cheers, Lorenzo

