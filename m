Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA2FC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB706B008A; Fri,  7 Aug 2026 16:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD356B008C; Fri,  7 Aug 2026 16:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B796B0092; Fri,  7 Aug 2026 16:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36D2F6B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:11:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC159120145
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:11:46 +0000 (UTC)
X-FDA: 85075569012.29.454C54D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3771640010
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:11:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gsrmj8vr;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786133505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PoT4LgZPx6dpe2ViNgQqI8z1wiZgMRaIvQ2UfGebaK8=;
	b=4FuH0TRWJhxDh2ItDqnF2qUpIeNf83oakIhv0664lI0QDxfz9DpYru0iUIPPiSjCb9hyHB
	DU81A9RYFQk++9odnzPY7qL6BCQZoqaREINTjoW4pRI6PAdOEgwCEGGVtC+i8f0dygZhHG
	Th43/zJ2+m/NfRyT7cMGBfwwD6Sdeo0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786133505;
	b=iNKT6T9HlaTY2KBS0yOxO/2gZPAcPWA5rMXPP87eEk7hGIHKdO/rZu26yUkDMu4WzeJlDV
	yzocfhlnZj2ZSaRUpSqjL6U53LEw07+JDUcXsB9Nl9iOctWwa+tdCvKUZnIxH9P6IDgLWd
	nizgYtzWxPDzV62QY+aZMGz8b8vBPwQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gsrmj8vr;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC241601DE;
	Fri,  7 Aug 2026 20:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C631F000E9;
	Fri,  7 Aug 2026 20:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786133504;
	bh=PoT4LgZPx6dpe2ViNgQqI8z1wiZgMRaIvQ2UfGebaK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gsrmj8vr7c7IjufwJOCf499sr4WiTwxVh/dcgeb+fhpebQQAWLhC7jU/pUcI1RDk+
	 RAFChKOcJHqJsVYtAZoW5Tw9AFhlEPGw0xeBcJ72sLhNZfWfuxCtCFp7IGtImrUUk4
	 06cVSO2uSDAaA/NxiFuJva2/k40AhiXpZo/mzFBlLpWpDQWZkKzoAU6SUCwvEeQDWx
	 MISrOGFzCeRUiFBSyYN0jDVXYKrZPfC/WaT9yFs2NswmSXudgIuxUtgUVyIolUWhNk
	 ms8n7ejef0vp/1VifCy7oCYxc6fy6oKLyIE/KoY3un/57S3E1Wr6i6Sju5u/T0d7Vq
	 9eIRqwOi5oPRg==
Date: Fri, 7 Aug 2026 20:11:41 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org, youngjun.park@lge.com, 
	baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation
 failures
Message-ID: <anY7842WB7C308rX@google.com>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
 <anWAZ3T6Sz8bsKSo@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anWAZ3T6Sz8bsKSo@KASONG-MC4>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3771640010
X-Stat-Signature: nba4ryaz75iy95pmy3o7umuhzhuiwadg
X-HE-Tag: 1786133505-71803
X-HE-Meta: U2FsdGVkX195lX3yz0EHKsjzlve/sP1RFTMb7om9iFba4bQNAHHjvZ5CZTej2XfzDzDWl2ab3BtZ+aPdUCcUhveUVudZaZZwHsIWkhixisw0ifWxZ5EFS4+kxJtrJqGlAdoXpQT/3u4CxCn05axfuDFZkTf6bLZiU0oOK8X8Wq7FOagEqeMtIxxu4Kh8/cykhW/lFx3YBoyfd2w7tG85eqhGLND94VcosmRPVExDYSdl+a1ShOZ47FecpUlOsydkuqzrEa122hbKMX7ZYolDMcbNNh3KjjDxD09qMFA2QR/9ZQK45adfbuQXtmwFWT3087WysNfuolx6MghOJuWUnxqLH3pRZhk3HDRikE5JjOU7Xv7loTGo2PpxfAFvHXIU8ZsftPqfTFryjMzVBxLR4IedjIgIbg2U0VAG/scCAFtmja1A00wzdVSL2ubIZv2PYg0iiTBPtuDzM3kOapEWpIqNFCtuCtTPqOoChPZHa0AqRaqqUacIrdojeB80jsMCMVZZRFoJcFw9ci9L8GtLl/SRsqXK0RyNpMbpt+A8TrHof6NWWpYSnId+uZKS0csyIHzRRWOvz3wLBbkZMkVgJy9krY8qN/0XKJ2H63/lks6x3B6K+OmXK8BJABQZPA9oucs2X3lUIkTdc166ZCwNZPS7B2Wt6FcR2Bsgor9r9jYw6HXM4fAS8JbZcXM2U0JUO64MPANxHR9JnpsbBt6Z7xHVD/6GgJ9AlX7S6I46oFE+T1g/fQDuthqvgtcvGhE/2iaRzcKcyvh8Mehj3aWDn4zGwgoe0AEDRQY0Zfy5Tf956RtI3dAjof14dITXRVN5fbMskCeOA03V3qCrgXNQfCMk2BcKu4tiheex6hNYGcm8QytaHGdGEEZ/PzfILP1x6GOXvJ6GEietLZH2uM72Fw1Ue29CfGjHyr2uvI0h3uPOUCYbQrh1VNG3HCEL5PHqcVDSUzO7CgGg9+N/NgF
 1dTbam9C
 p4Iey6nFXIHRv7lvvYKP8UjHdI9qP2aeGtPDEBeSqJwTRipTtHZz2QZ9B6UXIEQqND1LIoA/7xBWC9jdrX46qbqQ+IwHqUsRGX9qSeEtEg21pqBWJGKXyerjDlE1Nj6/FCvNb32vsqSHC0YwrUtdTfSMMu5gyC9YadmXxKrDTL65VW9IYqER4XeGfwzNyM26UR1RMKCt4NEF2lIck2Vh8xzWUwZvOwubPcCt4arlR58Gm30iOmsGzLVvU142Dj4htqL5Y2diE+P3ZgS61K8unk5y2fWiBzUjmI1F1HhTc2b+/dKxjxRZ8QbDSrNo7k8ABn3XjhjBzPj3ZdMSqDFYMdfdS68LAEOhCwVizVZEuUgCtA4UJZS3QRbzusGtuiMKuvQyOKzAe+pgKEM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:29:17PM +0800, Kairui Song wrote:
> On Thu, Jul 30, 2026 at 08:23:02PM +0800, Xueyuan Chen wrote:
> > folio_alloc_swap() reports most allocation failures with a generic
> > negative error code. Reclaim cannot tell whether splitting a large folio
> > could make progress or whether there is no backing space at all.
> > 
> > Keep the global free swap count and the remaining hierarchical memcg swap
> > margin as separate inputs. The memcg charge path reports only its own
> > margin; folio_alloc_swap() combines the two layers when classifying an
> > allocation failure.
> > 
> > Return -E2BIG for large folios when a smaller allocation might still fit,
> > -ENOSPC when no global swap space is available, and -ENOMEM when the
> > failure is not helped by splitting.
> > 
> > For early large-folio rejections, check global and memcg swap availability
> > instead of returning -E2BIG unconditionally. On a memcg charge failure,
> > swap slot allocation has already succeeded, so use the remaining memcg
> > margin to decide whether a smaller charge might fit.
> > 
> > This only refines folio_alloc_swap() return codes. The reclaim callers are
> > updated separately.
> > 
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Suggested-by: Youngjun Park <youngjun.park@lge.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  include/linux/swap.h | 16 ++++++++++++----
> >  mm/memcontrol.c      | 32 +++++++++++++++++++++++++++++++-
> >  mm/swapfile.c        | 32 ++++++++++++++++++++++++--------
> >  3 files changed, 67 insertions(+), 13 deletions(-)
> > 
> 
> Hello Xueyuan,
> 
> Thanks for the patch!
> 
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 0544b2ec4c56..7d12058174ae 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
> >  #endif
> >  
> >  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> > -int __mem_cgroup_try_charge_swap(struct folio *folio);
> > -static inline int mem_cgroup_try_charge_swap(struct folio *folio)
> > +int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin);
> > +static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> > +					     long *swap_margin)
> 
> Am I the only one that feel this returning argument is a bit ugly? See below..

No :)

