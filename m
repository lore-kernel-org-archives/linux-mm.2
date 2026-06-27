Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F31C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 04:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9AD6B009E; Sat, 27 Jun 2026 00:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083286B009F; Sat, 27 Jun 2026 00:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4346B00A0; Sat, 27 Jun 2026 00:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3A4A6B009E
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:43:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E1B5A067C
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 04:43:49 +0000 (UTC)
X-FDA: 84924449778.23.72204B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42A26A0002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 04:43:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sS73z00q;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782535427;
	b=BkleVNf9uoAgaSNM7KYeaq/xbdDLgEJyFWN4UaBhEJnh7JkjdjopbSX9N79dnq0uEEe+zb
	zZADK2o8+PMTSN8W+S5QKOEvUlt8HWTThq25/PnpBlYWeV84qhw/ykVlvMFxPM9jfKRdnb
	fitkWlHxwFv+2wviSQ0R1TbZDcXsFwY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782535427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTHBMgLRsJ8I4B5XDuSy1XEC3oI8SAw7TJAZm1NPnKc=;
	b=tTbgzHqqEF2a1BfqeShG+RT/nk6yz5O/qCLR2MlDqxRrTF2kzl1y0QgsOvEdcsRw4pCtEQ
	tlnPRcVwX5GtjEIBJsMPmWHqf44Uxkb8hSkhUreu6143oqXNqK9eJlVWa9T8b0U+SnhXhE
	8boU/mhvObt7MdOdyJYjcZVUigoJ8Cs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sS73z00q;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 237E8414E9;
	Sat, 27 Jun 2026 04:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D7A1F000E9;
	Sat, 27 Jun 2026 04:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782535426;
	bh=VTHBMgLRsJ8I4B5XDuSy1XEC3oI8SAw7TJAZm1NPnKc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sS73z00qlkOua9wcrNHLEJ8lZun2b/oyDm0pzR0uffbXq9iHpQ2NdQu0IkgEAokcN
	 k/1auQmJ1C3A0DRAsPshTeoVfV2Q8tzXHIVwUdOvClcSeCHBPG+sgG/fMaIIzQbABq
	 ZvEDxBRpj8Dzya75bJriUZueekOtJvecjsi4dCZc=
Date: Fri, 26 Jun 2026 21:43:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, Will Drewry <wad@chromium.org>, Christian
 Brauner <brauner@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/6] seccomp: non-cooperative pinned-memfd argument
 redirect
Message-Id: <20260626214345.5590f05f946872a7a9565c41@linux-foundation.org>
In-Reply-To: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
References: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ym7uhpogp615seosczas3s6q3sk3ung3
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42A26A0002
X-HE-Tag: 1782535427-892525
X-HE-Meta: U2FsdGVkX19/Y4AOly/94IPV5PWc/lxR/ajA6IQYnfYK/gP1G6u386TdagnDVSNIs1lPxUK/3OTBJH65q1WS0sD7vY66LW1Xu7WlzqUtu9405RSAjHRGmrluVzgVvTBrxpZWKieN4hnK5lnaUa783B1EpeMu+KHdXdistFnpaU2ll4YTS2uvC9BclU5PO04lYmsZr3994vZpKSUAc+hopjra+I5osLjS7hZgpGNhE+D6tSpsBa/iohfpLm8nCIaPSHdSeHDxpl3J7WPB3XVep+K2NiNjuS3pPluFw+K7hcRIiKXWFvymVG/K4JuHglrhsfD77X25F3a+4jv06HdTSPoLm2tr+M8kARG6EBiE1Bx/rTW86H/QW6n9mNzTP7BAZTBZkTdrH2jP9hHgbFlCgy3jfkdJynXPg/pHREUqPsBw6a48Zcw/cIPTQojiO/AOZUfC1Rqmon5g37X6EM4+/Ir9Rk9HGO6rzkOTPTLPjf3DwTlWWeejJE7FcdmnjffD41cTW0OeeEsEdJ2F5uOIPllnhPObYvU8ZRUzdW3zdP97yDw02LypJ290sKqjo0kzq8nIWsD/DmxLkONzR6D2dmMV1N/OMo4AkNIVNNuW+m4wTmOKcuB11pBycwPbLh4+eBk/LpSXT92x22WQq+dIvvaWUcKVi2whiVd5MtXd8xLrqtzTrn1STlCO/KvN5TWR3VZy11w7zUxnzuJdSYtf7FepPDvWYW6UDYJ5YopX7SHZkLoGIfKua8k19VTTkXGpKyJmc5sfvEl3I+nVE/c3VRYeKOxfqijpTAS5TH+oE/COlPuYkWqv5ATYewFNepxKCU8HP2L0OhO4TeSk7G+fOUgtTBJH0cxWhEcxKH6ycku60jdswflgYv9dYxGytfOLwiDmtHQqdc0LajZnylFt/n20zQ/YpUbJ47qQc73wklT+L4hQAX9HjLNiE9bmIQXHQHOMQjDrFP2iAxQ4+uQ
 AQJ08n8z
 s296aBw0Vx5jQBwBCbm6aGeS314tbzQMl1bGkHpDRaiRMrEW4xKXbkfHJkMcabOsplbb7gJdsq9tkc/ZWepVBGu5xvmYY0zIU+yMzfwEOcZoLPCPd5trSApHLtojnz9ixeS234mp/eZ44ksJ8+mkCkdnd/fUeGvDfWCg3EKmFRKcoPF5zG8aOseE5NXVSvCpfeyPyRWifCHs15t2kVUrk1vE7/Ya0E1EiZqKYCGZKTurQc8ew1v7dFRfPGfpqV89h9fUeJLmVoFJSCvlmuXTjrNbZWVpxiSMKR7ZjU5J6KCIcc6/FoKkP2PevgKyifeILQYxLpNBKUWCtWoT3i6KLiEg5veFrziw43kiBxS8CavyCTV1PU0UdoWT7e1xbWgF45GSgwsHc7SKEwG2H1mxsFbHi8wCjPyhBzQiw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 18:22:13 -0700 Cong Wang <xiyou.wangcong@gmail.com> wrote:

> The seccomp user-notification SECCOMP_USER_NOTIF_FLAG_CONTINUE response
> carries an inherent TOCTOU: once the supervisor decides to let a syscall
> continue, the target (or a CLONE_VM peer) can rewrite the memory behind a
> pointer argument before the kernel reads it. This is documented in the
> UAPI header and is why the notifier "cannot be used to implement a
> security policy" today.
> 
> The cooperative way around this is for the target to map a shared memfd
> and mseal() it during a trusted setup window, so the supervisor can hand
> the kernel an immutable buffer. That window does not exist for the common
> fork()+execve() sandbox model, where the supervisor wants to confine an
> uncooperative (or legacy) binary it did not write.
> 
> This series lets the supervisor close the TOCTOU without any target-side
> cooperation:

AI review went crazy over this.  I hope there's something useful in there:
	https://sashiko.dev/#/patchset/20260627012219.1079851-1-xiyou.wangcong@gmail.com

