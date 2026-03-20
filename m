Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C3501099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC466B009D; Fri, 20 Mar 2026 14:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C6E6B00A6; Fri, 20 Mar 2026 14:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B576B00BD; Fri, 20 Mar 2026 14:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD1F6B009D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:19:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 322F1584C8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:19:30 +0000 (UTC)
X-FDA: 84567254100.11.08F3FA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 456951A0010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:19:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cet4N38q;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAqmIpfQANEAuEJCQspIG3/xHFA3afWxbUMTE97V27Y=;
	b=JsIuNzIwv0UT9xoU2Nv082UP9QW4rtTRiA6RRYsXbGEvOhJ8zJopC59dxJmLd0KYkv4P1l
	5KH0DTSVUYkx+0e/umeH/pCwNa92raViJKkHCLQahy47C86ACM2TUu/yYj1hrXhMgWb61S
	fe6jAulyVD0x1yh41VqpHI6d2xE0btg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030768; a=rsa-sha256;
	cv=none;
	b=FWz/eyaL8AuFMFDVxqZpfGtRGp7m5u2/BxNbxrUL+DZI138LCh4p2PV9fjR57eQw+Lvxu/
	PUfaJFbp40X9OLLxlhH3pE6a/m6VnIRN1bRp+Hkj2O/FGYGeAXf1a/+X015KDi+yRf0Url
	dRW7IS99BGUXxmVN5qKtFjp4z0EZbHw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cet4N38q;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10A9E4375C;
	Fri, 20 Mar 2026 18:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC792C4CEF7;
	Fri, 20 Mar 2026 18:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030766;
	bh=fhynckOY3YNY5Z7Vmj+3M9LO934fJkg+0qdwtO++Nsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cet4N38qjcfMf1hg2fBVK/3J0TcvK5Mk9XFV6riNA9guHnYQ3YgtOKsHP+rmkWYr6
	 rYXRmsM2aZqSY1A/mFeiQVZ07NhSrrijL6gq9mf3rgmQDl9FZZSzK/4Yr/Y6A8fPm5
	 OEyBvZnOwUeTv9YxnI7x5f9WeYlMWV7UBnIkfT1gVY+PIvDElJUBkTOflo85rfxBVs
	 nAKTPslk4lGymjYpEAxIBj9hHs21k2R8ATq9mp8G1ZbRZTFA4K1rT10A9RaFvBJry8
	 zSNh2xS7oOi3lGYzxWkSLd/Fb9gPDybtiMzuM7yOYte0zRAgXpqEc/8vCk8YLItg5C
	 rxtx+Rh4ZwmpA==
Date: Fri, 20 Mar 2026 11:19:26 -0700
From: Kees Cook <kees@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Andrei Vagin <avagin@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, criu@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Subject: Re: [PATCH 2/4] exec: inherit HWCAPs from the parent process
Message-ID: <202603201118.2F75F8D@keescook>
References: <20260217180108.1420024-1-avagin@google.com>
 <20260217180108.1420024-3-avagin@google.com>
 <CGME20260320091528eucas1p14a64767f916b556d30cfa00bfd320ace@eucas1p1.samsung.com>
 <aec9c36d-d67a-4b61-9950-57b95afedf75@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec9c36d-d67a-4b61-9950-57b95afedf75@samsung.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 456951A0010
X-Stat-Signature: cyiop7o11t5jyshcxofeyramfrhbxycs
X-Rspam-User: 
X-HE-Tag: 1774030768-592660
X-HE-Meta: U2FsdGVkX1+GxQyZJErIpQwx6bMwyMmJPYGTftknI88tWc+5wZLYKK+iLTqSd9IZOJFapWRH86eFCoX7FLfJAgw8uMv4orGKDLr0lCgLVhuN+1AsIihTVALvaMYSI4qne8Zy4q8H7UHCubERjFt9lSa/TE3XEmisXj3LPYHbDkbF5MvO2Lm5zaX2vGbSLYtR9c7WFf8iyt1geYS6Kn9KcTNXOteoCqhPuRiiwIMm6W6OrmynbtAphLoYUFyUFsFq0vHiZr4xWN2vcyaNe5Br2X4Y3mJAfxb3ka41mUOKMCz603+24PfFeOIo+dv5nNRp9YlhRAKh0xwZxNfI4IBXHRq/ESTjT0Hfy6u7oKhG9UuFWFo8VRpXBiBMRYtvb7Fl4PhegeYSJNqW40+CCd23J9WdYsbQg7JDS4wxCTkENSEG2vQBdQLUskWoO/oKurvhFVwJoJoUzXG7CLF2ozJjXLOv12X1xzewaUv6T6uF+w5pLEx088uKS+X8strUHu1HzqG4SjxRdgPPPTXyIGyNEZvZzRNz27PUiwIfHbwKbSQK4iIlU3sKI/odxPypuadkYNQ7XQlvmRKG2MzIeSCzTV1MXruAn9WP+A6tn6A8Uia26SuFmxEQS/3iTlhgOmCjO8Teax6wlV8wUUG0QuCmO2kevKhmz2hlLgu9oto+mZuylltgxwwNBNUE0je6kXvUc8gHVg68gt5689NRyX3lPUODse62q49LgJlFViFqnUsyNIkV8Ih2HZFB8/XCTUz3UkHO6v1By6RqK/lDiTd7R11i/tZeyUa5cqhTWqeMPqtaRLMFGoxz/hU1ur3vG96FM1Jt7D6IzHn2lUvVKQeGb1aMj/TWo/DnxNvA2NZPa72Max8JoC0o9vdwHMHHROSWedIAWjyj9ZXLYrbvGSQDPjQ/Fd78GD/7z27UWEFHNCTqJe8SyL/gyDhfqBrVk01lxeGJF8wLKILEDzryif+
 lkaHsSdZ
 fteg1NR5l4cLxdk+HXgN8f5m7CHJz7sJqcFphMVuwqUCYid/GWPNZuAtDrHHns4YxBKGQ0IZS5IDTb5jdnR70+haG7u643yJqFza85bGpztJEosqnM6XiE2qKvwb2LHbeMzwxu9e/to3Ma2Z9APXud59kJHh544GRbGgxmf2v79bAIMYXR7sKAEUSo3dDaDU0j/MAg9PtXTj5+xtqV9KBaoBGXkrkVizJnuBItHfEMSo8zHwEFm1ym0ZPPR3KT6vRLRo1VyCr89Eb+rfnXekz09sKcmEFAIwdpacY1e7Rk94SJVoxxFcZWJK0FeX58Qt1K9q7fYsDxrLgia8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 10:15:26AM +0100, Marek Szyprowski wrote:
> Hi,
> 
> On 17.02.2026 19:01, Andrei Vagin wrote:
> > Introduces a mechanism to inherit hardware capabilities (AT_HWCAP,
> > AT_HWCAP2, etc.) from a parent process when they have been modified via
> > prctl.
> >
> > To support C/R operations (snapshots, live migration) in heterogeneous
> > clusters, we must ensure that processes utilize CPU features available
> > on all potential target nodes. To solve this, we need to advertise a
> > common feature set across the cluster.
> >
> > This patch adds a new mm flag MMF_USER_HWCAP, which is set when the
> > auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV).  When
> > execve() is called, if the current process has MMF_USER_HWCAP set, the
> > HWCAP values are extracted from the current auxiliary vector and stored
> > in the linux_binprm structure. These values are then used to populate
> > the auxiliary vector of the new process, effectively inheriting the
> > hardware capabilities.
> >
> > The inherited HWCAPs are masked with the hardware capabilities supported
> > by the current kernel to ensure that we don't report more features than
> > actually supported. This is important to avoid unexpected behavior,
> > especially for processes with additional privileges.
> >
> > Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
> > Signed-off-by: Andrei Vagin <avagin@google.com>
> 
> This patch landed in yesterday's linux-next as commit ac8c259ce0d5 
> ("exec: inherit HWCAPs from the parent process"). In my tests I found 
> that it causes regression on my Khadas VIM3L board, which is based 
> on Amlogic Meson SM1 (S905D3) SoC 
> (arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts). Running init 
> process fails after this patch:
> 
> Freeing unused kernel memory: 13696K
> Run /sbin/init as init process
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000004
> CPU: 1 UID: 0 PID: 1 Comm: init Not tainted 7.0.0-rc4-next-20260319 
> #12369 PREEMPT
> Hardware name: Khadas VIM3L (DT)
> 
> What is probably important here, this board (for some internal, 
> historical reasons) uses armv7l rootfs, but other boards used in my 
> tests, based on different SoCs, also use such rootfs and boot fine with 
> yesterday's linux-next. Reverting ac8c259ce0d5 commit (together with 
> 0ea77bbf3b98 due to dependencies) on top of next-20260319 fixes this issue.

Thanks for the report! I've dropped these patches from -next for now.
Andrei can you investigate what is needed to fix this?

Thanks!

-Kees

-- 
Kees Cook

