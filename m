Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF21CE88D6A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 21:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3F76B0005; Fri,  3 Apr 2026 17:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54EC6B0088; Fri,  3 Apr 2026 17:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A8A6B008A; Fri,  3 Apr 2026 17:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C47196B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:39:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 732A5B6AD7
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:39:48 +0000 (UTC)
X-FDA: 84618562056.09.6E4B87B
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8DA04140012
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:39:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pqeiB+oX;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775252386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaxPn9D0nufvu6pcRhM4O7HHngFJ1hdy48gOkdHVhzs=;
	b=wSohA70jqzBq1IxOjehbFC/qHxk2OujmM/O9YcNaprIWtPjG5T8Zh8UqS+W3AJz7UL/R00
	Hj6Pghiddd//QkP7MFfVcxdHFllJVE4p60yMgVM/jNGLWVY7/z+HkzCP+GrWEqEdPnb6ba
	w5RayqHChj0RhrL7DVeZJaUDpEBNMhQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775252386; a=rsa-sha256;
	cv=none;
	b=qnHB3aL1Z/QljFSTdQm/Zcc70IlPYIQK1Q5jdsRfnjJrM7b93FseUsG0yJkjAt1xg79KHz
	j00BKYYw2nPT8viK0FZzCIA27RgjLIkoKIwJZxI0xE24KceQoOIMFWXWuFWMt+/N8AchNL
	LUHuOGwtDpiSeqILFttyO3ph0/VFu58=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pqeiB+oX;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 3 Apr 2026 14:39:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775252384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vaxPn9D0nufvu6pcRhM4O7HHngFJ1hdy48gOkdHVhzs=;
	b=pqeiB+oXjYhHGbE55N1vYYuQ00Lrja4y9Vwmba6ltaiEplJdL/jYRk08LkbiQ3uqyTPGAS
	8zgHcZB1/3aHdJxPoLgRSV7Z11PNctNltyP+EGIti9osDDeslK8Lp44BZFyEAB4mdE2ENH
	AH8URr42/ehRwbrcLw0HU0He4lfL7VE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v6 29/33] mm: memcontrol: refactor mod_memcg_state() and
 mod_memcg_lruvec_state()
Message-ID: <adAzfpWnPOF1Af9p@linux.dev>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: az95mr4rgbj4rxiq6ceb9jadoh7mwi5q
X-Rspamd-Queue-Id: 8DA04140012
X-Rspam-User: 
X-HE-Tag: 1775252386-78518
X-HE-Meta: U2FsdGVkX19SZZ5iEwryak4FBnGPX8BfWWPZFDgupBN5foMqpnVL37wKn6l+pCRqHKOxI/DkpGa/MQv3fV17xE91nLFoRpJxtZyOday5lC2s36aXG77YnRHim80c+OEzam/7QHQRRgPAz4EQBunNi3h2QyrDN6Xly9UJZDIb/8yBTjZ9W2Y9nQrL+km3uh5prvEQ81h/5GUtwVthJegXKNtWqwJrA8X7bn34LmAzK9QCIA8lxz4ntYW0GOr1AjHPoZE5bA0QNryEN1Dwuhq7dwt82lpT8baDJBiWrl2qo+18uS+eMGivrAOfQYPPXPtVv1uhV8dnSxPpECPUy75kogdjMmmt8pnmZVTLkp38qTsAyhlb1/FswNq7MSSASrgQurXrl100wQKq3fSIwosf1gjUh5JEi1R0bTT+9PiiCZs33F8xeiRPNPB26aiUcoJQaveYUIMdj0TNnZb/BfOmBWiwvQNdLnziAYlrduG1hCyI0H58DA/L77plMAwTDpDHcA5ef+lNTTHJwukEsbk87j7ba3Y6zZzb3ER5LTU7xNOURcJFH232r5kJTFQYNu663XGZtBsuLOSdyzjpchChdKoR6L3B2lJ4TItArsZTEAqeAX5yOuTmNO6vpWRnFP/aMF50WafZYvsmmFyys9hknoRsA6eZmCJz7inKQoMOGQiTJoYuJNuloAeChOjCZtY3KiE2DdDS4ghJseldiOmPGYLv19shnwxYwA42Lu2f94vPbPC67HlYompHhHWp5feY6i6rx+KWZSjBziGjWNo/+QT92V5QmGH69O12/nZfCDCQAkfTcUQJA4NNkIkhL6Go3o/3HL6uFV7zWVazOmgTXk4EJFA3n/1mkXU/J2OMkmVgrfqMuYsXybqmrSX5f7mQWGcoCDBaEVsTPbC/SWC8pVSF8Iqjr5raLD0S+d8UrGaTi9GnuKgKt7GPcWQIWAoWkobo4azI3QVzp8rSVCE
 1qWoxt8W
 OeKoqWi1re7VgqbaR8iJ94IRjUe1Ai6C/j19z2He02CL/w03j7l2ZFq/e4gGFptg8AUiNmmADxY6wgXofc3NwV6/zVFq6Ew/AypzL3V6NmrZl1YJvsY4SFSNgs2vn9bJRCqixHjzJZjqbVPVODZSLYxVsCCCh1RJIrO7tA0Sfd4zznaIMg5u14ukZf2x8xO6So5VatFGsRncuqBcNSAvD7gSWfu7J7U48fdoydGx9ZvdADmgLgpTeuNoTTZCcrgQyz4lSTNBlO1OhHo2o88bnhlTD2XRzZpUUhd3lxoGwgsfbMoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 07:52:47PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
> non-hierarchical stats.
> 
> Co-developed-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

