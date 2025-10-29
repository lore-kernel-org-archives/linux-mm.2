Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5029ECCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF4F8E00F7; Wed, 29 Oct 2025 16:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F3E8E00B2; Wed, 29 Oct 2025 16:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736F88E00F7; Wed, 29 Oct 2025 16:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62D1E8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:36:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 263144A218
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:36:44 +0000 (UTC)
X-FDA: 84052310328.17.985AA07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8670F10000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:36:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DrC5gWSU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761770202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LEUcmXJTUfdquMyF/tYPWzyIMDRJzVNKX+sXv4F6gUg=;
	b=wn55VneErcCrmg5nA4hSZzqAkz0vVkoNPQcH+T1vvvg1ElQqdhlFlUSuFBmRGGkmMiyKXj
	+B9yw+e/wyOHlr+4mLMeqOu9Rrtv6x74FG88MQgmKwZIgnHeyDBQ9DRpv7GaD2u5e34D2g
	F1Y7aY/MFhoxryTz8S/4y7QApmUe58I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761770202; a=rsa-sha256;
	cv=none;
	b=AWtDvCgsJyLcEs/DAh0GXmAH7rXthsFtIqvKP1VhzJJVfbxAbsSlTEkhh5lr7r1lIzJYsf
	+bK90ojXuqDOkC6K4NFsrnFcHVzaSW1yOCiFdOU7F27VT9eI75AnpC8xAzMNgLewLkI8OB
	qkpIlpxIK0bztWkyx41+4V6tAn/Gs3Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DrC5gWSU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 38DE843D2D;
	Wed, 29 Oct 2025 20:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19A6C4CEF7;
	Wed, 29 Oct 2025 20:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761770201;
	bh=iOgHS+eZEE/s/+7/l6K7Sr/3V+3Pj70ijnv3Cvpoook=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DrC5gWSUJMcUvoYLDXbfHIwK1tb2VBfHwJxQHwh7TzSL5xh8sdvcpQx06xLCpGTzD
	 6QQbbuzI+A/83Qlo+5BQGNuXpAkQyO09qgmnhxbREexwqrM9/pbeWYilD3XQafjfXD
	 HLxEIloCvEhH93/Qn0m2ZleVlXUNdrWWQldZwdOuIPMn2PXL+rj2ACGEwkcb3AhzfC
	 8VL8fzNYLHsdvEe95oaGzi6RelBNNgGhKSWy70B1SDCA6SFjt2zL0ax7ezldRCYICq
	 v5gj8faxK3Pe1LhmNADlsWAcETHsfwvDKTaSu7gFesptWU5Y/ZMOVqtl5nwTqZCsqJ
	 P7/gghhtBrsOw==
Date: Wed, 29 Oct 2025 10:36:39 -1000
From: Tejun Heo <tj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
Message-ID: <aQJ61wC0mvzc7qIU@slm.duckdns.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev>
 <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldkte9pr.fsf@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8670F10000C
X-Rspamd-Server: rspam02
X-Stat-Signature: i7dxozjnf9pzrgwihd6mnrqdegunbnhi
X-HE-Tag: 1761770202-82583
X-HE-Meta: U2FsdGVkX19nR18ear9kDuJcs/EwfeCwQDzuEA+A+9f7obq/hNpCX8iRv8p9J7KQ1bb2aNkbBaMs9Zux54ozY1UfegP9m2Jbxvfiaw65AfM0RGZIl57n0qWUcReKUTwxuHMN31oQ/nxUt2gsI68lrQYX3ip6Fj1s09utXX2rDu6jDJRdn1+7h5oFu8DIbOE9MscFVlh9OhOt66ZPNQ1xnXvDtod7WHsWgv6M0ktJaH7TREw3vy7AVL2TDuEUSOuuASd1E5j0DbwemflUbDuyxDE/3ZuFIF8OGtlb1dfNvrlKqqP16Qi+VOCF/MkDEMVQrxULWVJeb5ZjNxlN9xmarRYkoUYwjTAKGhTA5BQzsRjTiWAmZCRKKldcH9NinDJ4t4VXfpKC8o7Ug0TJ4U4IdfxgZwnOJ+bPOgTxJc8HxN7U8B3yQeIHjeCwK737TXbLl/XuoPR1/tFNEnVKeBv+GJ1XOFhafHB6lmKtCIH2yIrmEW9ntoKutwsxqFRrRjR7J4Eoeo1Rdp0WqMjY3WgZK0zrjJ+jn3pYJeIxW/CYEH06XFvpwjTp2VwaCIh0DmJvfTrZQmi2R8/WfdRqzuoRG5Q3NbWqq6rPYNq60HUh3570QLmlRUF24M7m+9otz1fdiCWSFS0xfCElOiW54HZ9FOfFUr8z29dOD9If7uwctsaLXQrooYZbOvk9j6Ghhz0ZT3oIsQmBHghUDj5wuppXe8QRpChziQx2W67GK4M9ya3g0zzshKsUhmd9K0vxuMhyzeoQLtKk+L9SE1vYrYn7QnrVjIiVB6PUK4+If5AGjmDAZyEXCqHPsLqVqAK3FpkR4gzlx6jL/+h85Q7/64ubBgCY7aoCoQArMPZV591D1AdmIHtJW9Gy1p8MbNRrpB7CH/Ep3XVuB9qKB3DYZID6cssAJKmGJEa7WKNK1tdKsEYaRw+achJ14u8bAmJDjUgqeYFJz42GCk+zwVmhzho
 ueLPO4pP
 DW80YSrxB74jT5peKqsJC1DZDocWcvXh3bnUduVL9GOWxtyCl1L3iD1nKko6yIdJ/MOyGWyto+hafqozTFGuiyhow8FrJlowDgwx1r0VAWqb8kj8jFiYMS9msqiejpnSi6d+dmqcxTWm0euYeCozJAUsVYSfG3T+GL1T8Q1dXt7j8cz4Rkcy+CrhKCFfUCagdX3eN1sEe/LA3W83h/CYABAAgsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 01:25:52PM -0700, Roman Gushchin wrote:
> > BTW, for sched_ext sub-sched support, I'm just adding cgroup_id to
> > struct_ops, which seems to work fine. It'd be nice to align on the same
> > approach. What are the benefits of doing this through fd?
> 
> Then you can attach a single struct ops to multiple cgroups (or Idk
> sockets or processes or some other objects in the future).
> And IMO it's just a more generic solution.

I'm not very convinced that sharing a single struct_ops instance across
multiple cgroups would be all that useful. If you map this to normal
userspace programs, a given struct_ops instance is package of code and all
the global data (maps). ie. it's not like running the same program multiple
times against different targets. It's more akin to running a single program
instance which can handle multiple targets.

Maybe that's useful in some cases, but that program would have to explicitly
distinguish the cgroups that it's attached to. I have a hard time imagining
use cases where a single struct_ops has to service multiple disjoint cgroups
in the hierarchy and it ends up stepping outside of the usual operation
model of cgroups - commonality being expressed through the hierarchical
structure.

Thanks.

-- 
tejun

