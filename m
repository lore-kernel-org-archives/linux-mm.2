Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66099C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 23:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318E26B0092; Tue, 21 Jul 2026 19:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE006B0093; Tue, 21 Jul 2026 19:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206AF6B0095; Tue, 21 Jul 2026 19:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED4996B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:18:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79C1E120314
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:18:20 +0000 (UTC)
X-FDA: 85014349560.08.4D40712
Received: from rev.ng (rev.ng [94.130.142.21])
	by imf29.hostedemail.com (Postfix) with ESMTP id B26E0120008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:18:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=rev.ng header.s=dkim header.b=Cm+9ttcF;
	spf=pass (imf29.hostedemail.com: domain of ale@rev.ng designates 94.130.142.21 as permitted sender) smtp.mailfrom=ale@rev.ng;
	dmarc=pass (policy=reject) header.from=rev.ng
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784675899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RrEHHSPxeM7rdWT0hfycPsvOnFeT0A9FFnWzE4N1zg=;
	b=NTSwL7ESgCKsyEBu9zaYVgQBBEEZ8rQwApXyXQbV7nNaLUkNWzgvoPP1cI/GS215qe3Twz
	R/1hPkwCJVs80VgyOfR0BCdgDVBxTTH5eQTtJFwgZ0EffUr3rg68f+GorJgkbhmVlSEoFo
	yvFeT6N/dnYrqKXqky4GrXKOOXaaD6E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=rev.ng header.s=dkim header.b=Cm+9ttcF;
	spf=pass (imf29.hostedemail.com: domain of ale@rev.ng designates 94.130.142.21 as permitted sender) smtp.mailfrom=ale@rev.ng;
	dmarc=pass (policy=reject) header.from=rev.ng
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784675899;
	b=Ai6khvWsYtRAYf4hTD8UX9VbRj5eMyW/+J3vMYFH9CI7xVz+/WbJC/3ZRKrhLwZVRRjsiC
	U7kzKglR3tekV1Ybbydgc0eiBmp+kWRIIukKAgY9ZLduv4INrxwvLvJVH6Mc/7ljgurq96
	1rqvrWgTOzTnb9PRcvLa+x+BVXLLQBI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rev.ng;
	s=dkim; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive:List-Unsubscribe:List-Unsubscribe-Post:
	List-Help; bh=6RrEHHSPxeM7rdWT0hfycPsvOnFeT0A9FFnWzE4N1zg=; b=Cm+9ttcF+8oHHzW
	Qpp2AmmbKSuZTuRKmWPaUVg5lPnF+zfqZ1cwGFXevVOVemoz2ujAcYxcuzffOFUlbeRnvJDpGRV43
	CBD+WgAOqtEYxZ1hLAX4i+xLdo/bMudOuCE8OpUM/veNlD58rYySHxczGn/AoFqfz9sF8GrulWRB7
	VA=;
Date: Wed, 22 Jul 2026 01:18:08 +0200
From: Alessandro Di Federico <ale@rev.ng>
To: Christian Brauner <brauner@kernel.org>, Farid Zakaria
 <farid.m.zakaria@gmail.com>
Cc: david.laight.linux@gmail.com, jack@suse.cz, jannh@google.com,
 kees@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, mail@johnericson.me, shuah@kernel.org,
 viro@zeniv.linux.org.uk, Gemini <assistant@google.com>
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
Message-ID: <20260722011217.45e79a08@spawn>
In-Reply-To: <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
	<20260704211409.1978485-1-farid.m.zakaria@gmail.com>
	<20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
	<CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
	<20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B26E0120008
X-Rspam-User: 
X-Stat-Signature: ajugb7dih9fm1gfzfm6qao9wqrkebc6n
X-Rspamd-Server: rspam04
X-HE-Tag: 1784675898-577943
X-HE-Meta: U2FsdGVkX19DtEnhBma5eK+FAhhWI8zdTpgR19eshUtdJsuGO0MQ9FM0elA6M53KDOn6AalAuzJ1SBrQSTndaE5Vpf8gPLNxk6W9AGRxhkBXfZ53FgJ/IXU30IuCchGCvTkPrAidjOEzfYXFfeUVEG7e4sQKpywegrSx+0kZ09zY160omR1O1Q7V2YDD4rtJX/iFizdN0WyECQ2+eHl/BqKZvMjzg5rD+FUqh64kPoTjf1hiKE/Yw1UjDwDib36qcUHIUjXuYUNhAmIw9+qBWd1DoYgIL+qiE8ohD58ew2XvmMuNqr/e2iLT/ooN/eVPAMfJX4gxrXC5XQZOSgvUMW3/ilkbROJFr1loh5pgYMlKbspOo6+fbtHjtHs3P2mkLOh49WP1qlEcQSoY5xul/pTWp6ftTJe8Ve1nERup896FvYrkL0NlgymdIJzwLqoSQZtC5950qUt5sxMaKfjMnRLz3E8iTe6aEho6fqz89bdgW2cWBzQpuaDEkuvEEEQ6cLivvqHN+ue+mGu1qJ6onnpBX6qB80t+SFBH61pqwgNmdf+SR/7A1GrQuZVly1uw/DnW42DxPL7TZvS5RXS6QaNdklaCWpSBTSX6zC7HlmxeObU7PUhWSRLdLmQpChpGm58AKlRolhvpZ2bG9wNxZ8jk2+Nfu8E+kUk4EfoU45/7aRdhn4LiUDuH8Dj1prZgKBEA8KGQl+3XWTjg1VWpoRqej4bFipvPJBSqjbWDpSKjYoufyw3rrSQ4/Uh9ULee4UhGC7wJ3QNw/CtDviCn9OXCBgG1eF0KvojNgwPt4Fue9The9ckvas0B9nrnZ5MF9e5MAFdl3czqv2aFbxG21G7ua36DJlHFvb1eRJ8oLy78QXyQQ6Tx6WtrNK2JFAjKbJf0V4tZngeMzKcUWsG0ACkIOaKvh3VjJy8n4NHfWlvE405LaVBMq/OXRc48eTtqNUijQkF7dxKPTqhOTs6
 jb/OHlLQ
 OiATU4TvfRRQTOp/wMb2L4jtJjqcnsabqyh1uviQ2bmuGZyUiqU0WOkr9AKzA6t4keJ6481b84z8goK2IWYO8iX4Js81SAz/0Qg2KP4184VLNmBZJZjkxzeKMspiQizW97Z0UVjCSuQRZBx4PIrIJFza22Aede2GhUqj1x4BBGoekZoH2nX3G91lpqxP3f6PW4CVNkNcs2lKT3B3JxpYv+t3soXTG0EPFMnJ7RdMBgA1et8vw+K4rhIqAKVoWa+bUKv1B3IGmA8SzvaNRn7QIarGqMJCHBhxptbbTWaMg19+o0tVVvuqGvpK+x2carFkZribKWvVKEgpBEHUnGbAehkS5WcGTpnjpQTuUgc4pk7jsTTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 07 Jul 2026 13:34:46 +0200
Christian Brauner <brauner@kernel.org> wrote:

> > That makes sense -- but you will need CAP_BPF etc.. to load the new
> > programs though if inside a userns.  
> 
> Right, bpf tokens exist to delegate bpf access to containers. Not
> always ideal but it works for such cases. 

Hi everyone, first post here.

tl;dr I think an $ORIGIN+PT_INTERP-like feature should be available by
default (no root) since portable software is most important when you're
an unprivileged user.

I've recently read about this patch and I'm super excited. An
ORIGIN-like feature for loaders is something I wanted for years. Let me
share our use case + some additional nix use cases.

We have a package/build system that makes heavy use of RPATH+ORIGIN to
make portable installation directories of our software, as in: extract
a plain .tar in ~/mysoftware, `./myexecutable` and it works [1]. No
root, no run-time patching, no namespaces.

Now, this means we need to ship all of our dependencies properly
RPATH'd (using $ORIGIN). The only exception is the libc, which we can't
ship, since we can't put $ORIGIN in PT_INTERP. This means we
need to link against an ancient libc in order to be compatible with
a wide range of host libcs. Needless to say, is a *huge* pain.

This patch could in theory solve our problems, except for the "no root"
part, which I think it's the most important one. After all, if you
assume your user is root (at least at install time), you don't have big
problems, just drop your software in /opt/mysoftware and ship your
loader in there.

But I think being able to use $ORIGIN from non-root users would be
useful also for nix, not when you are on NixOS (where I'd assume they'd
enable PT_INTERP_NIX by default), but when you're on a non-NixOS system.

There are several projects that aim at running nix without root:

    https://github.com/davhau/nix-portable
    https://github.com/nixie-dev/nixie

Currently they either use user namespaces or ptrace. However, the former
is restricted under Ubuntu (`apparmor_restrict_unprivileged_unconfined`)
and the latter is not ideal.
AFAIU it'd be possible to avoid all of this if $ORIGIN was available by
default in PT_INTERP, or at least the biggest roadblocker would go away.

I understand that enabling $ORIGIN in PT_INTERP can be problematic (I
should dig into that actually).
However, in whatever way this gets supported, I think that in order to
be actually useful in the most important use cases where portability is
important (i.e., no root, no user namespaces), having this feature
available *by default* is important.

> In any case, I think it wouldn't be crazy to allow registering
> "default" handlers that appear in all binfmt_misc instances if needed
> so containers with separate binfmt_misc always have the bpf program
> available. [...]

Maybe we can have a "default eBPF program" loaded for
`PT_INTERP_WITH_ORIGIN`?

We toolchain people are happy to tamper with our binaries, but if these
features are not available by default, their use is going to be limited.

In any case, thanks for this work, I've been wanting this for a long
time.

--
Alessandro Di Federico
rev.ng Labs

[1] https://github.com/revng/orchestra

Note that this is soon going to be dismissed in favor of nix itself.

Example artifact:

wget 'https://rev.ng/downloads/revng-distributable/develop.tar.xz'
tar xaf develop.tar.xaf
$ ./revng-public-demo/root/lib64/llvm/llvm/bin/clang --version
clang version 16.0.1

