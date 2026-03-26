Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFD6B106F2EA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C94D6B0093; Thu, 26 Mar 2026 04:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379D46B0098; Thu, 26 Mar 2026 04:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B75E6B0099; Thu, 26 Mar 2026 04:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1850C6B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:20:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D986D13C0B0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:19:59 +0000 (UTC)
X-FDA: 84587516118.27.D2CEAC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40EF6C0008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:19:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zu2v/VtL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774513198; a=rsa-sha256;
	cv=none;
	b=jQKs38yIkHqERAOJ3ced5KS2xmSx/AMW0fo6s7CMN95uUx4hWnRyed13k9kfoFVTcjXtcE
	G41Vlgg55k3W9Hb/2laAPH+iIbo7Q0osr41wn5AMgdBh3aeF1SKrH6AYJH5Vp6XtG8L8xD
	N/ESzQbWQUgwX+9wD31y1y3mAMU0vkk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zu2v/VtL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774513198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1lBUifHSK2r3fzNiLwsfoxh9W55aUgpzogsoCf02mA=;
	b=v/n38Eoere0SxVuv07rxm6S6t+JR1KeSzBCydKAiIQx89PDF/Sur23U0d2BNs2F2+GR1Il
	+BaDhT9OA/VLm5L6PzlDQ6+ezoZqG0I8AujkMlqjuQwmcwUZEnhi9wm/N9FkHE2wX1gCeJ
	j9sD/iLcnM5SOKDteZO1qn+Ysuhxywc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 813D860103;
	Thu, 26 Mar 2026 08:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5C6C116C6;
	Thu, 26 Mar 2026 08:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774513197;
	bh=kmZd/Y3BrScNBiGSWx6bpuwl/waYMYQG7ahxj4ypNiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zu2v/VtLWyhE1/BeOXveBKbAh5pxhRiuniOG/45V9P/Fj9WKWZYsYyBQKd2BXhp2Q
	 ge4weDjJjHIx6J/Cw9sghCFfJ5IIs3FCdtN1d0WXmbtfwmHxpmAHuloAtbmL/Q7c1/
	 J4FB34ZLZ4MnUsIAY5jxHep0RmqMl0Td4xc8bfJvVolFh7NYHEi3kLcb9AB9leZRW9
	 jj2ug1obEra+AD9HcYU+t2/KFisOkMaPjkRDQ175DA+DKj4mGZcis0+r9p2KkNGhdJ
	 6pzLswbqn29eZDbrYGh5MT+9qK6M7BW69YhQKiCxn2AcyGiXxA1/POMW1Q0/4AEJ6/
	 XEdn0LGT31JUg==
Date: Thu, 26 Mar 2026 17:19:54 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, ziy@nvidia.com,
	yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 1/4] mm: memcontrol: correct the type of stats_updates
 to unsigned long
Message-ID: <acTsKkBS12yOEoI2@hyeyoo>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <158fa0b1296168047342f02050e9d2bda6888d27.1774447069.git.zhengqi.arch@bytedance.com>
 <fcd29ba1-e02a-4c91-80d1-2d1280e2ff99@lucifer.local>
 <c46cc185-5c23-4145-bfad-5c455b84857f@linux.dev>
 <3eb8b252-b6fa-4708-8c84-bf90142fe682@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3eb8b252-b6fa-4708-8c84-bf90142fe682@lucifer.local>
X-Rspamd-Queue-Id: 40EF6C0008
X-Stat-Signature: xqhs3jdac8gynb8cgkom7cw8ad3az8cf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774513198-943082
X-HE-Meta: U2FsdGVkX1+pdv6zoTNUZVM6RVSVZg0FM8MDc6RQ5z+2tqqv4pJaX95bjQFsM7ngFH8jVeOmp7jcEKNYveL1mGxe8orPCXFJfsxTuemvQhonV5nE+l01amHtd2AS89DXkXlDNasuZSEsMG1gPjxfhEu/tAGbSjaGCIU7cVwUg1JfQAG1h5KVB7uHg1t23cinioysIzLH2SFLFLExM7R51ZTO/U1yhWuRkU3Di4WTDftodlWimn9rplgqQjD/w4paWbCn1ohDZ9zbh9Jq8ff2MHIZslcGotz7yo8C1Tca8ewf2xjRkBqvECaJmQP9jC5lVBMLLxbennjyn3cQTg9fmeW2eF9kSrCSj8kWXvdI8Zjx3HXbfbqu0kAIWA1zOJJfvI/Bg916gUyhT7cjsThuJwEpXFoC+aRMFvGIf+L1r6XT8Ix6PFQ+jqIBb7eCdwma17o/MMb1xE4kC59BbXAs/ydyb7y7eh89HwhBo0sRPNpCo1F5ULtAQrO0RLfNLUEFopA8IUXqY9CNDvajNPKyCtIDPrkk95LtlfmwRgUnv+bIbOcM62UWqY/+62fjr49aTFXCmC8Ys0xT0ASilO5CAq+E63S56LKIPr8ZxzFObDP16ex72jVSrOTttQgiLL0IakwAvi0wyzjoQEUg4FwPDw51pP/ChUX3O2WXr64/DyVjTCTRxVj8bBaCtHcriOybYFcqTzlFGgVPE7eHvZ7RB7Y8fYGN/ZJCPohM+/5ExNoKw4lkkJ43D9fZx0sL/my1qckAT6Y4RuZC0O5RJMgPJxUCS4HZwFizazTOH1RlDBah/DlGi10Rn1JPMlumziICDEW0B2nu/IuAInEqjwheIIbmajHx+zeT4OW0oMbcvdPnAt96w+hI72Q/9b7w1xirAJPv+lWJCS9PWaGI1p5zW5P4LEUIq5ACnn/9WtGd/UyMeGgQcSueVDhOq+9WGDgDnaF5vTyoQq0vg8hF5Zn
 +q+PPyEF
 WWZsDeJH7YqVZ8TjBt1tux1c+PGiZmHEOY3Kjj0QfbfxwWA6S9lFnMxBNCHfzP63XZUoMt9ozyUyHcWq+iLfNS9wzA2k5BjMMcqsWchzeDquu14XNUC8uQcGGzCgvjN5W48Kwv7z0Oca+/TEyhwBTySZYzhKYjuxVuCu7kzq32dP18s/fUIxDoAxZytzddlho3EboxU9dyrzSGrdJ6RtVpPbwUSfBu0ySp75tOmmHD1ob+3n7Mq0MJvQGqhxe+GwOAFNuF6arHQxd9Uy6fiT120lFs1P+xTiaeYjsXDNc+D3mxIyHdV+eq0KK3mJBA1OttDaU83NwaU4wF0M8FRmqO1DzyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 08:05:57AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 26, 2026 at 10:32:43AM +0800, Qi Zheng wrote:
> >
> >
> > On 3/25/26 11:28 PM, Lorenzo Stoakes (Oracle) wrote:
> > > On Wed, Mar 25, 2026 at 10:13:22PM +0800, Qi Zheng wrote:
> > > > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > > >
> > > > The memcg_rstat_updated() tracks updates for vmstats_percpu->state
> > > > and lruvec_stats_percpu->state. Since these state values are of type long,
> > > > change the val parameter passed to memcg_rstat_updated() to long as well.
> > > >
> > > > Correspondingly, change the type of stats_updates in struct
> > > > memcg_vmstats_percpu and struct memcg_vmstats from unsigned int and
> > > > atomic_t to unsigned long and atomic_long_t respectively to prevent
> > > > potential overflow when handling large state updates during the
> > > > reparenting of LRU folios.
> > >
> > > Do we need a Fixes, possibly cc: stable for that? Apologies if already
> > > asked + answered.
> >
> > Before LRU folio reparenting was introduced, we wouldn’t pass in such a
> > large value, so this wasn’t a problem. Since LRU folio reparenting is
> > still in mm-unstable, so I didn't add a Fixes tag in [4/4].
> 
> Ah, well these patches should be _before_ the LRU folio reparenting then?

Yes. I think that'll be the best option.

If that's too much of a headache at this point (I'm not sure),
it should be at least part of 7.1-rcX, given that it's quite unlikely
that people will notice it during bisection anyway...

-- 
Cheers,
Harry / Hyeonggon

