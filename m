Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F84D2D0EB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D6A6B0005; Tue, 13 Jan 2026 09:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115226B0089; Tue, 13 Jan 2026 09:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B636B008C; Tue, 13 Jan 2026 09:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E46366B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:46:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A56D7B5CA2
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:46:11 +0000 (UTC)
X-FDA: 84327215742.26.5DB1937
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 104DD1C0010
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:46:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DWF2snKT;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768315570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jSy7jBvC9nebYOjTwgO9FutvaOd0nj9PGpV6sjReCbI=;
	b=J6AehDJ1QV7aARcwFyJjCOoAeliLZiXnng+4xbVlsl3CduFzAK36AcWnsO+J+EZinC3Qqx
	pycF9qiEVzMgva9YKcJmsretn7QF9iXnSifQ2qBM7drzdCUtn6VanROflP6443Ty7BdaWT
	Q/nskhQkcaquveedAJLfrvnhWZCy0bA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DWF2snKT;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768315570; a=rsa-sha256;
	cv=none;
	b=Pp8B+ssVpbHv8rfLUJv8cYTyMyXYdLJG2cWURHWFm54Jkjhb3a9VHrjqXHGYBJqL8Rqh7C
	IYkOG1gAZ3GQzC9hUACw9S+auH8jmDVo8yBesckQoohx0oCd6mKtaMi3uYIcziiRLlYaRi
	UUJMaKoxLn2tiZj9yAsvh2WT7GCSBsw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 211EE6001D;
	Tue, 13 Jan 2026 14:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77F2C116C6;
	Tue, 13 Jan 2026 14:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768315568;
	bh=4uCAucSurgWYYIfTPVGMA7hAEuKLq8ADMBBO1vAY/Ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DWF2snKTTWME68p5bqRoDMZp5nz+HXJ3bikIf6obk6LehQbfcBB89unOKo0echBdQ
	 FuaLneguObpC5wzEdpQ4rXKS7R+Ve5bjzkv3OLAU9ULW88251bOBr6hU6ADJ4kju8g
	 Ow6/uz65FMFNWthx0KS95LsdmFZZ89cakQFpXsZjmBoc6LAFAoBEQ9+wOqAOQ4UcHj
	 5J6wu98pb1caihXnGjUDkQ6+uXeDHWR1nEAKf56OwSj6TZZTGkxmse0ttEsihnjDqj
	 6MjG+RmsooY9V3L2ZPU8Fj55ZhiqPZ64NpuhkDFoZhEoO57LJvo6aI93ajbvqAI/OW
	 5jmKNED0nhbOw==
Date: Tue, 13 Jan 2026 16:46:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/2] kho: Adopt radix tree for preserved memory
 tracking
Message-ID: <aWZaqcStRAK6VWLy@kernel.org>
References: <20260109001127.2596222-1-jasonmiu@google.com>
 <20260109001127.2596222-2-jasonmiu@google.com>
 <aWTJ2v9J-Aa6ykBf@kernel.org>
 <20260112143904.GA812923@nvidia.com>
 <aWYt0gBHxDCKqj9Q@kernel.org>
 <20260113130526.GE812923@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113130526.GE812923@nvidia.com>
X-Rspamd-Queue-Id: 104DD1C0010
X-Stat-Signature: 67spueho97ty6y9b3u3ad8caexkqyxpm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768315569-408821
X-HE-Meta: U2FsdGVkX197AHTfq/6lWz/j9A9r/EFt6oqq8HNDAtAicv0aagcfyErW511KdDQGxCx6W7GjUAYnBAgMVXOUNwmrGBciLugDcup1XS+C/xC8ABWfJSgUA0U/YFj8mDDmkoJjORkWx1UFOQLw+KXO6S3271RIgPNxiuD0fdTWxmgHAGo95VL8Jl3R+1RaLgTRGXzgZuSu0UOrdrdtlIQ7PSas3zbBk5rjlZuhEtYlNEVFeVJDe48Rh7EaiJL01YY2h6Zr1Ry6WfPBbYNOjtu6q/o7Ph7A6G4H79HlPFiba1j1lIjjOCPxi4nuFnsrBb/g+FtNSrKC3Fta+qm1cLBNyBSc9TyLxSCVXB15eEMEVc6lzLYbW/+lnuMtrkAvefCNjTROltk8G4mIVTGy3eWEj0Kk0Pv5qBjIdsFDZAfTmSQgI3YdrmHb5EpnOXakC8N6MKK0lkMrJ3BLwmGO0sv2k/9I6bONs1+CPPqik6nJ6bTLxwKxcwb0RkQAwS3p2MdBlFq7Ld8j0AlOjDLDslmDIBHnd6APKcjDyJhEBBr58MZZIRGZYsSDJXPbgjW95GsSglJurZatXxhta8YpH9oc2JvUO5fvwMc5Bh7/8HVrNMqHYMeTlj7kXOnfLZLX10woNYH51kIihbMd7aKLUbg3ZKgkNx1mohJr8gC0Bf+66SFSvi5ob/ynhfIKzVTMCocK4JYpkAYwXrOYfB/De7uuGrFlPABWW5zO+tMQTwmJAyWfXoprENIDph75FeNgzo7wgobmMKRlHGhXGgy4t5ZE8BQtJdr6Chx+X1bq9QHBR7NjM5m1+x8GaZbc9GVeVgoVrO0BseRshtLytXhfXKZ75CZWdfrhBjoC6oT4KuijYtDuFsYOYskne8jS9f6hH6+rM9oDA9cxVcYByUd6rOMOxeKZiIZ0m+GXuqumhVBER1J9+u6lWalkJN5vEhWwCjg8mI6NhWDB3ky/sT8/nCt
 F+69mFiV
 XY9Rxli9LxCbIqLZ8hE8H8HcRCneA2g2BC1+lypMOHgaTZMRvnDrZcgiHAuA6jfCDPZ52N0guiUMpfGy0PnUw5lH/Ez9OVazr2DjlNK0KjvONccZjDCNfk44lFBmIkv3ta3+oXKTIZQNqdzb6qUhRaxP02mFKPGAou/3rlG/8Yuwo4uiuxL6gChDEk60qANVaCtXCiu7X4J8Va9X4HiMemBZiG5mCeMsSMKtT6Y/JGNvmoo0+L3irsqYRNOo8cCsqC0G8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 09:05:26AM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 13, 2026 at 01:34:42PM +0200, Mike Rapoport wrote:
> 
> > For example mshv intends to use kho_radix_tree to track the hypervisor
> > memory and there unpreserving will be a part of the normal flow.
> 
> I do not think this is a good idea.

Sorry I wasn't clear, mshv is not going to use KHO memory tracker but
another instance of kho_radix_tree data structure. 
I don't see a problem with that.
 
> Nothing should be touching KHO until a kexec sequence is started. KHO
> calls should WARN_ON prior to this point. If a kexec sequence aborts
> then the entire radix tree should be discarded and it should go back
> to WARN_ON'ing KHO calls.

The whole point of making KHO stateless was to decouple it from kexec
sequence and let userspace control when preservation happens and to allow
preserving as much as possible ahead of time to save cycles at
kexec-reboot.

> Jason

-- 
Sincerely yours,
Mike.

