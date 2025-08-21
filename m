Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBC8CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 19:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FD168E0025; Thu, 21 Aug 2025 15:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE218E0023; Thu, 21 Aug 2025 15:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D4F8E0025; Thu, 21 Aug 2025 15:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E5F1E8E0023
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:53:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9DC1D1DD932
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:53:11 +0000 (UTC)
X-FDA: 83801813382.04.EE92556
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id DA26E1A0008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:53:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o1yC6A/4";
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755805990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpvhqNtwaoyMgWmFR5mwGylcVpnj0fZDmJSFlxK6MrA=;
	b=JcDXK4u2txdthrrNIK4+ENxBLaIeDpkIDDYEVHmQnrfnRvTLmGUMYM9V3qg75P6N4osSQb
	vHoXABWe0hn3Azb+m0sjnpQea5wTYLM0wN46/YT5aua0br938Zth1ryOl97GFBaCkCPqqc
	gB3X2GlQesvNcmiwbLWSWs0bRabU3io=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o1yC6A/4";
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755805990; a=rsa-sha256;
	cv=none;
	b=NFkdujoqQmDEeuRIAylg0tb0FEuGnORLdX7XvLxnIAbE3tGetIHX5QG4BEHMqFKU9p0Ygp
	SISUT3mGanlW04nXIo+wCvXfnuJ4ExczjYXWk15/c0be3e9aWghlT1b8JK1f+iH8ASA3hl
	2/5mcMNjX7Q7lxv4nAvlBwO8zdP6JvI=
Date: Thu, 21 Aug 2025 12:53:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755805987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UpvhqNtwaoyMgWmFR5mwGylcVpnj0fZDmJSFlxK6MrA=;
	b=o1yC6A/4MYpDYec+ATsSlQvU4cv7FEoHdPAkutVaf6y41WvCnonOpwaNPIZ97ErDDm5LNT
	MbP9JeKXJj3IbIorKChzLj6Svci8zwwRjZERbaM8OhmfRR6dc6z3DQEGh8D7Fy3v1XLk4v
	Lg0l76RFV4mxF0xN285lCCqY6CO/o2U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DA26E1A0008
X-Rspam-User: 
X-Stat-Signature: jg8656szx385ycpeoxsh9bz47qqj77qt
X-Rspamd-Server: rspam09
X-HE-Tag: 1755805989-239065
X-HE-Meta: U2FsdGVkX1/cwYPcXVudAAbAkvdJ7lJjy8jwIRvuYBhWTw2/URlMVUC2jjmq0RTGRPMAOnc5fXpk2TH1pkBW2roSGfDO2YqNDVoDstW/4thS7MUHFNCDuvPOgcexOWrhOBgeVGRVTqw42eB+hFw8Ql6lzg2dDjGBdd7ez91pS/LynEljuOMojLbM6FyEKJtKpgg3hZ1eOKiVvY4yVZC4n433xgbqSLZbPp9HLfiiNwpf7nWCSxEsInDHJYUJpq7QoETfBDcZJwGjNgLq/A8zltccLDOJRw0zkTA8R4Apfu0hXKtA5LNXOvx43KusCrHcQRbfa2OZO+x91OuGcyoXGOxeToLX64yr5pAYcU7vJv+MkKBx/zaC+Y/r8UquXEySOmvWaB85cZFPg/X2NqQ++k7RVxqzh+ZIH4doWabt2VXjVGlB+lKJYsc0rSUdYYOYUZSaKs7av3HJTEleSaC6riXXRIm8pyyz3kkl1KjzwHnt/0vO/0XNt7NUS+IJOyITgifCLOevUNeN83D6ZP59lj8BKVk9wwPDC0FZFL4Dncet2SH0Ks3Egp8p8FHGttZ6CkTMSa+6TGvK861OMJI9k/fx/IrQCwyCe+Vq3MdVXDkK3pkd6ZnTN1U83WkvDGRE281kLAp/niwxoxpvrBh1h3SiO/XluLdIpBDYvjk3jtqqVHxEqWqwMQT5BVrsrc7AwclhelfHeMbGQ/6uF4mo2ic0yeakowabAgysjAJqIhx+rcjDv+0d+LwccMC19+xuz6GmmTI05sibJHT2kU8YNi1m7WLX8vUdBNEd7rDI2wBJ3tFJILY9fd1pL+vGs5svbJIEM8Sx8BuqcCcTRLroy6CSM/6OtIlBtBqZXKS8IVkFk9sNOh5v8VGJW7jlXy0WvsDLXZbgJs7UicY70dqJSLMcMhfIX6yQGvCFAhvPP1KA0RbBY65fXf9p2vGHxB7tDJbgOxIbkf/DK9x6uRW
 ZXj5BZKH
 Jf3Uqkc3V+ojnn/KCMFHWjKbM+jIAtUTN9Xqlr4IndY83Bb7kfA07Z+69m1OUHmiYmLE8xl/Z6Qqa+xqhlKtLWL79tNHrQGPFd46kyvARjD4/BXxZQAPDB+bcQ5SyO1/vSXDpZ8oQ18Yqtk0bDFs3EpFjDsep0V35Mha2yEDv77c4zkmOvVFGE418saDMWU3bBUD7QUzFFhMeOrcYbTXr8K7d/Kxq+gOTeK8yI61LZOJYeLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > Right now in the oom_kill_process if the oom is because of the cgroup 
> > > limit, we won't get memory allocation infomation. In some cases, we 
> > > can have a large cgroup workload running which dominates the machine. 
> > > The reason using cgroup is to leave some resource for system. When this 
> > > cgroup is killed, we would also like to have some memory allocation 
> > > information for the whole server as well. This is reason behind this 
> > > mini change. Is it an acceptable thing to do? Will it be too much 
> > > information for people? I am happy with any suggestions!
> > 
> > For a single patch, it is better to have all the context in the patch
> > and there is no need for cover letter.
> 
> Thanks for your suggestion Shakeel! I will change this in the next version.
> 
> > 
> > What exact information you want on the memcg oom that will be helpful
> > for the users in general? You mentioned memory allocation information,
> > can you please elaborate a bit more.
> > 
> 
> As in my reply to Suren, I was thinking the system-wide memory usage info 
> provided by show_free_pages and memory allocation profiling info can help 
> us debug cgoom by comparing them with historical data. What is your take on 
> this?
> 

I am not really sure about show_free_areas(). More specifically how the
historical data diff will be useful for a memcg oom. If you have a
concrete example, please give one. For memory allocation profiling, is
it possible to filter for the given memcg? Do we save memcg information
in the memory allocation profiling?

