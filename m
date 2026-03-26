Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A14B2106F2EB
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D836B0005; Thu, 26 Mar 2026 04:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F086B0088; Thu, 26 Mar 2026 04:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24546B0089; Thu, 26 Mar 2026 04:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF2766B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:02:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7458FE112E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:02:23 +0000 (UTC)
X-FDA: 84587471766.10.007C2C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id EA4F7160006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:02:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AT5Q7FdA;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774512141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kb8dhfpjttQqeUBou/rHdhjeiNSx/oLXCj1by7qGXKc=;
	b=YIQhuqU81n3bNzkJOhjximKTdcJVY1FJwtXMsvIFubSK/8KEU9J97sqL1X1g7i8exd/iSe
	NlLY3qqIXutr6DTw8WqN2ssy3xO+7+PJYNK8hXrfXfi25g2v1fQMBAZgwarObccjjNC2In
	KXNQUsAhKP6RzkT7Y3fmqPZFvkKL7KA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AT5Q7FdA;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774512141; a=rsa-sha256;
	cv=none;
	b=Qz4bQxAIroXwqCSgy3463oyfPA0esumDRgUiAfhGNTIr/Y3WedqSzbDGHeD7WSM3gT3ZIU
	RhDkXZ2Me2Nd7hq+niTt1njh1Vn+1rozP2Y+Ygak93BMqRZXIiFbk92ivZuY4Uj1ewpbFP
	Bbfd9vYg1up2CSGg+nt+5N/qt+sxKiM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4388C60053;
	Thu, 26 Mar 2026 08:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF66C116C6;
	Thu, 26 Mar 2026 08:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774512141;
	bh=A48kUkO1TtrycoKeHx6/YYvUwwXAqNBRegZ4mzWsWV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AT5Q7FdAlt3PjmHZzDskG9ydXKEAAtzJIYmfbCnqz4kza5CM8AFrdE85fKpjjpwaL
	 Fz9NS3JMR46gZG5WOmxUP+m5ol0ITjKrkBLpYaITOCWuvUtvlKoQEt2i1TmNgJ/5kT
	 /vi2HHCpuLyAfLcrIv1VF8ZsQRsxuZfS9Hh5aAW7+I6XJHo62HxOFe2X3k7t2y+kbd
	 anSt8hYP/MrBl7AOcj1nDnufgSjSZIu6bGXfQ9Q/f0ItuTNirDMGrO63KUZUNRjO2Z
	 2LP7Gpg2SrePNK7jtESKiWS6TcJFkG1iMO13I1S/ZMPZJ4ikkWCDcS1pdefCZXu+R3
	 SviBOW7FWSV/w==
Date: Thu, 26 Mar 2026 08:02:12 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acTaRgusrxfCoKqe@tiehlicka>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA4F7160006
X-Stat-Signature: m1qdcbgqnqfwzfpc8e6jc5y9uwrawrfz
X-Rspam-User: 
X-HE-Tag: 1774512141-428197
X-HE-Meta: U2FsdGVkX1+JQuZzVmHN5nPINWGCtT1HgaPW5ApEF6iGvOlozCgEKfuXWDTJRCq8RqF9MIjIYoshFqbq5zA07wCz/Wr38d4vEeELQhjcTDozD9mJaKf0l3CEZEl44S9zo8tt4w7FrenkNRqOM9xOHSxNilFHf53/hd4xauBhwcuui38FlzV28Kvs7Comn1Q7kZKg3RFeVGuWYc6pRvqm2yRFFgl5od2ZqYcPcVzlWGT1oQS4rV8sx2+Y99yGyXWIkIA+GrECFDLYrVfQbL4Om3TklFuXggmMlVv0009hilwIRrLWefcPQtunLpl0ci0wDKxp+PzkehTo+L18oCuFtgGNVuAHQzUsb4EIm+PgXy4LbgmS1+QUsc0mEn4nl6BLBKZPSabOb8vdnthzZb5rm7eXlU8ld6LiByXQorMUVbJmzji6dYpmrCwMpS4sARTOrOlRLPhai0gCSPan0snherrAByY2eqvVdPhTSjSnj9pGtE3H9shKkOasge5pyQJZkiB/rbclGZvRq3pVwIOoUmfVg4MtO+a/QD3zQkxOhpTU/9fm3LWpZn0EPrHElCPoxSUvgflhIwPe34e8t2e1tHp5MSQqzPSkTycM/jALWMbtpm4PI7kk9wWopmXLJ/gzZZqP1gyQxwz9jzn1P5kneLzseooDpwnaJakKrMx5v5MRSOOmLaoWzhbSvhwojXrWiv3ck6Gdf4pc6I55K6CO4AJiFZKYxpJ7oTM8u0nY8EUzWNhBW0DRdH7yrqSJg2Jm/gpn6kwATX7Rju3rru3R3WdMOr2evxF8L4C5wlA3YI7Mvv2TdGiZPx2P9qEwkVCMW3blFNRvOytP3HiyCJTIELwktwA1s8j1Vzn357ZarTwPKBSmPKYtyV9Ao2JFJTs9VcyN2K0eGBgsY8/doiwksfuXlOJtaScGm61D+ZhOj+h2mG+ClFWv7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 08:03:34AM +0100, Michal Hocko wrote:
> On Wed 25-03-26 19:05:47, Andrew Morton wrote:
> > On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > > We should unify both algorithms into a single code path.
> >
> > I'm here to ask the questions which others fear will sound dumb.
>
> Not dumb at all and recently discussed here https://lore.kernel.org/all/CAMgjq7AkYOtUL2HuZjBu5dJw=RTL7W2L1+zVv=SCOyHKYwc3AA@mail.gmail.com/T/#u
>
> > Is it indeed the plan to maintain both implementations?  I thought the
> > long-term ambition was to knock MGLRU into shape and to drop the legacy LRU?
>
> Yes, but MGLRU is not there yet and with development pace last year or
> so we are not much closer than at the time MGLRU has been merged
> unfortunatelly.

I'm quite concerned about maintainership, as it seems the MGLRU maintainers have
not been all that active, and the MGLRU to me at least is currently a black box.

I'm not the only one who's raised this (see [0]).

That'd very much have to be resolved and the community reassured that MGLRU is
_actively_ maintained before we could even contemplate it replacing the
'classic' reclaim approach IMO.

I hope that Kairu, Barry, Zicheng and others who are interested int it resolve
this, however!

Thanks, Lorenzo

[0]:https://lore.kernel.org/linux-mm/aaBsrrmV25FTIkVX@casper.infradead.org/

> --
> Michal Hocko
> SUSE Labs

