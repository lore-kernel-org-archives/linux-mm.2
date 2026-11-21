Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48479606A335
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcaRsRrH
Received: by kanga.kvack.org (Postfix)
	id 5A1896B00EF; Sat, 21 Nov 2026 11:50:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552D66B05B0; Sat, 21 Nov 2026 11:50:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4679F6B05B1; Sat, 21 Nov 2026 11:50:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 244AA6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:50:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E2B040551
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:50:05 +0000 (UTC)
X-FDA: 85459713570.13.B0A4645
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E76CC140005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:50:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcaRsRrH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795279804;
	b=2MjDB3d+ptBSvd9FzEgd/Jz91c7UFZ5ckMLU/kkNEVHI04XuxmshjCiCXny/435AofWpjt
	W/U9852/4O/dMjlUz6kfexGFnh8YqvjOrJD7kB3lg2GBaKW+PXmW1CZ9Z9nlMChSun7BCp
	W3gGTb2q+1PUqRDEwLGxTRbLajTeTPA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795279804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmKlARszXrRzW/9tlEK7o5BZOIq/QjdgeWG7kY2Dx/k=;
	b=Z2VCknVOAjRKP/F/hLDgXr5Jm8G+MdFMov9pj0oLaqlCkkLFuidIvcWl1P2uiPgUGaGYN7
	AJpKiGKmoNAxwlf/fgbHIE3NSLEG7APqqLT0dwbyrSPXUMRLUVBYKigBumR6XqzcLS0wnJ
	gzOmGQB2tPwQEXlBGSGgUzdX3glOizo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcaRsRrH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 817E56147D;
	Sat, 21 Nov 2026 16:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AE3181F000D0;
	Sat, 21 Nov 2026 16:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795279803;
	bh=qmKlARszXrRzW/9tlEK7o5BZOIq/QjdgeWG7kY2Dx/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hcaRsRrHvGL/Sc0mJK7h1Q60HXVGMSiV07H7e9Wm/eCYP/ovxlZrA3Nws0kSzUEKo
	 7e2wiP4VwNV8c4JoR0QkYD6vXBuGWl0YKGXZKktvtFD1EWMAEV6WwWczGeiIojgRkQ
	 c07DjrcsL7cdhRjvksQw8PqngHKEbho0S1Jxvp1wSikxOKzHJnruyYFpBBzoE4cp3H
	 ED4fr5dv/tOVedrJeaonJMOVrz+FvQOQFrw+zJZl6s/vEw+Xq+Jb4hQmgLd9Oh5qkR
	 qmM+edFAf/pZEZny4gRYJXUJM7NAAy7z/yqpjPMoTWOQ6AiKYnpTmHFksebB0DqtoY
	 /e/wX9IzjItpg==
Date: Sat, 21 Nov 2026 18:49:59 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 02/25] userns: Add userns_set_idmap() system call
Message-ID: <awHLt1IpLcqxUnDW@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-3-jarkko@kernel.org>
 <awHCTNAo9uMakhAH@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awHCTNAo9uMakhAH@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E76CC140005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: z4dg7xkb9zeq1tzr1wb1xmabd5xkzsoo
X-Rspam-User:
X-HE-Tag: 1795279803-877407
X-HE-Meta: U2FsdGVkX1+QQawkqbkP9wM6FaLkDEHfR3wDynXGchV7nEiH8lYtyf61kHW4N96SS4zGiSJdpCjBoM0iHLBNV24RJEcPIpFREAml7nl36otxcKvAmwvSDe+7YINj7d2aqztfmHdR15EokHBbJLkJWHDv6tNRscOMlvCyRG7wGev4Cb9mwSQ22k/2WS2FsdOcNWisEov/d/BdwC0aUNNBpE8XJ3p9CMnkpoX2XYEsA+/V1MXMxlrTtTUjPhxdr7Rjo5FucIiIMUvRS8+prvmvOqn3L8weXmDKbku86r9XbSzKY93/uIu+CPxo4JVH6D9zrmu2XYqVM+kfVKRq8WqEtFZY4yk4DM42farqUJ5gpOqfWzKeFj6Lde3FUrG5CkguD2iCPya7NWE9owD2v2/LXRhi2LTZva0nPFW/R4gMuD9Aw6sD9yIuRS/UD3evwjQAO7l6yEcTEGpWDsubQzqIW2UfDBH+6UryLcIkbEbmuXEi3TmlDizRUm7TjLruzFGOLhlP0bi3HRi9eOeaWEhvwG/eyoJfxBZ2fpa8DNhF8ug7XEJAq8DxuAc5obDzmir7pFBFUGJb/5gMqtxL0SZpC3ACqz7BEBUFZwLdwNEu+apbCNPVKmzYujn2FMsSFa2ZBcEfsHesITfZ+tKP3kMGMUvJFYsG+MHIsKInTr9YLlgPJv0GYc4vEMMx98JX7mLbIyCHJyYXBNUskZFxAhASEsuFC2Z404r1oJHnwe5GwXtkhpUZQRY/YrjwnCVSzx60kN82peqndWAt962RuaourLnwPWrj/d9A4fG4cm5hgZ3/Y5V4oaUFg/cjQlJ4Ad6tFUy/8gbiY2rXJ6ZAjsrQlmyOJC3DuAaPT0G8GkIW25ROqLYcfdemND5xkGrC2Kx9pHtWMW5lawogBVHdu9KDw1ygTu6YT5+OR4WptqwZhwOO/qOc5fkzKR+8r4qY3CwBM5WhlYv1o5zTsLuMz6P
 ePHhE4iB
 G6so+MSmW0NJEEgttjCQMXUKPW1/JOv+AvkVMp7/e1tC1tei628kLusbVfw4gYNh/37ibLZ+WZRyK0HbzS3NDTW3B806sscG4UfybOt1aznqtoh0kmmT7b5cmKHf40WXJ0dBDXZQ4cOfPtKXO3E2R8VMXiVYDeqy2SDLpSZrYA/mOZLt7ezPG/pEt8NC0fgWDfxsV8GvC5bFN7rgkZxJKJ/2ciVTJUKvoAW7rSox1jUS/kcwAZQ6yjoulmMemRPb3ZNBUexaIGmdrBkzLh3H7ZE5Q87pmIV+ljKZrznIUyXPX4ZTLXNqbSWNDABjACAacTDz8ttK4YhLpf/5k7q3CxsZNlc2RwaroP7bZClgCsaNnNg033wZNr9zD6TLmoKQU3fWcl+u85R1usj2Y4YJkizJWXfcjUYWQzzSock0bAoCR/zR6j5HNCk1od353KFQmVGxbeeh7K7eTQgCBPJW5ycGi92VSfMCB/of7jDlbtDinWEjOl/PGYqjhJZEQ/boAsjc8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 06:09:53PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:21AM +0200, Jarkko Sakkinen wrote:
> > Configuring UID, GID, and project ID mappings currently requires writing
> > formatted text to /proc/<pid>/{uid_map,gid_map,projid_map,setgroups},
> > which depends on a live task in /proc and enforces write(2) file-opener
> > CAP_SETUID/CAP_SETGID checks that prevent passing an unprivileged userns
> > file descriptor over SCM_RIGHTS to a dedicated CAP_SETUID/CAP_SETGID
> > mapping helper.
> > 
> > Add userns_set_idmap() to atomically configure setgroups policy and UID,
> > GID, and project ID extents directly on a CLONE_NEWUSER nsfs file
> > descriptor. Require CAP_SYS_ADMIN over the target user namespace in
> > either the caller's or the file opener's credentials, and check parent
> > ID-range capabilities strictly against the caller's credentials.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> I'll remove the flags. I forgot to remove them from final version.

userns_set_idmap() still has flags-parameter but it is gated:

	if (flags & ~USERNS_SETGROUPS_ALLOWED)
		return -EINVAL;

And used as a bitmask:

	ns->flags = ns->flags & flags;

Br, Jarkko

