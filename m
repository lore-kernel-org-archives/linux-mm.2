Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC197CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 23:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141E69001ED; Thu, 14 Aug 2025 19:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119C79001D5; Thu, 14 Aug 2025 19:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055DB9001ED; Thu, 14 Aug 2025 19:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E80899001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:09:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75FE2C0800
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:09:18 +0000 (UTC)
X-FDA: 83776905996.14.15D6286
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf19.hostedemail.com (Postfix) with ESMTP id B0D721A0008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:09:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="0R/JyhNG";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755212956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Huj8WA7KPvfe2s+QXSClpIOA7nEUEx7xmyjCXZuu5/c=;
	b=NqgwvOVJLAilUXPClLRgDCGqFUJEfsfpwrAFluKb7+5ipv9yChTfSz8uAjhJ3xvD12NWmV
	SWtCdH2jTUyPhwEZEQh7oO7aBSzP6fdyeImlm+fnJMMe5CxPX7LiENh3gwY6X++O5KU3Lt
	WStAlxiunzkN651XeJ224pJpjPi7wGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755212956; a=rsa-sha256;
	cv=none;
	b=PWc+yil3dsjbP2bxXa0j9C0la+kdMgfjnCJUudufK0885U+ZLa84f27XQzUTzvIW7qk2FX
	DmOmBJnceTN9KSnGq4Hj87hlOb0nyHerwjp1tACA455D5k9KzRS+UmGJF3QDd4mkVN00pl
	4ociv2FhaF7HQo/vI5O4zTdb+GFRjjU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="0R/JyhNG";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 9A49A5C65E4;
	Thu, 14 Aug 2025 23:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EA2C4CEED;
	Thu, 14 Aug 2025 23:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755212955;
	bh=8+3X2KbhAIZ4Bx08PApMHwoBqmWQTqqkpPsM0eZcjoY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0R/JyhNGgq/eZXZdrifW43th1gOVFSjuevoez3EcC7Ev3iF0mZiqmMuJEn/orhgdv
	 dgMvFVRZJzIVKW0m/EuWolNPBJfDx3GGkVphPCRP6l2x6VMTiCYpUAZaHh5UXdkhfu
	 vbUpWP605ZV30nzT0a1/ThIggXXfjwIrRk4X46/M=
Date: Thu, 14 Aug 2025 16:09:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <zhongjinji@honor.com>
Cc: <linux-mm@kvack.org>, <mhocko@suse.com>, <rientjes@google.com>,
 <shakeel.butt@linux.dev>, <npache@redhat.com>,
 <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
 <peterz@infradead.org>, <dvhart@infradead.org>, <dave@stgolabs.net>,
 <andrealmeid@igalia.com>, <liam.howlett@oracle.com>, <liulu.liu@honor.com>,
 <feng.han@honor.com>
Subject: Re: [PATCH v4 3/3] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite orders
Message-Id: <20250814160914.7a4622ae1370092dde11c5f2@linux-foundation.org>
In-Reply-To: <20250814135555.17493-4-zhongjinji@honor.com>
References: <20250814135555.17493-1-zhongjinji@honor.com>
	<20250814135555.17493-4-zhongjinji@honor.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B0D721A0008
X-Stat-Signature: 7qdyxdfrrcp9459z3pryubi5gbu31gbf
X-HE-Tag: 1755212956-961584
X-HE-Meta: U2FsdGVkX1+OErpkdpPClTbY+x7DnrubDkQXO7j7bi3hC0DXoLGSmNtX/+2W4UJNI7JTDxCJn69frRWDreKKOiBsl3lZtAvCY7z0qdfiPbtzo6S0h7K51ZBV+7d5gpGRafvVuHtWKooP23iWXvMnTmqq9QAvXCxT8ZYh+H0qDnSsMsRAMegomMPuKrRtJP2nzRKIhuSsemi+bN9ARSiJPJjfm7XTVkgwdt4btdF7C0sqwsF0Snn3z3gzIBoI8wVMeM7e0OwszM8u3n95B9WKg8vZvZpo99W5mZEsZAypNvVXOqRaovWQSsKpb1qTfXVZ1XjQcO41cVRhjHyzlhfa21WGUhN/JnqRQL2ApT804ygnbLVIbikYwAyjGCdcQwE785sEh2+1PWBjO88eiQHuIwkq+017keJbrEoRkv5UrRZUdh1I8SNppxoDdBlRWctE9t/efsq708nlsWlPazC8UqLNtmcy4KmT39pkDNyPqvCu26uxVSmgoMr4zgB2HXUQrmB8mdRTkN5lmNoMftGv+3f3v5R+LNxzstwPugEeqdMerkECoUw47T8gPOa+Keb2O/X4jgXDhfHvONB0MsevZdFy0hToPTDirDGBqrmxAUCJj2eiEqM7+PV4mnMr9RfpJyBz25sf3olVGUThpQei3x0qTSOVeZ/9/GRcwG9VQPJl6COjh27o/JgjHScH+BtVEwAC3nBtEy34rBVcSRHZz75iCUVIpy/yTp4AwQzP1HxNVVR1C3JDLRWGmiKRMoiYmJqDs2hhneAbPcpfjhijVf4hz99z0paj0xsi9gW/G0d5n+Yak8ppqkxrI5Hff94Sw01W6BqtUrsWdKEgn7miG+mYSgCplEtYmvhVPXYnybkN6ut7S/TFncBKsW6n7P+4ySbk9YhfhiU7XR9KSMh5vXlr9sA/k4z8N+5nmZGnWy5yD8ew1WFCsuPvJLSR4Bu3W8bd5nW/7gW/MNtsdib
 D1YRFW20
 UX+c1B+0Vr1u0eYMb+ZMIEpxfQvDbTVGzsQ6r6SLL1wRHh62LQrO/fI0wuk6bk1aPzd6zXyq11E4xCH+mhP2g53CCAw/2Q0j4b7Px8oN/jx2SHePnTgWGiWczT/ZisXNnac7i4yYdC5NW9IjdidLA/5LuF8BBwaG4DKCuag7w7xF2OLxHEfpUJ6Lt0hrCVZe7hVzPsOZchfoH4hYB1NvsUI/YiuOPymbtTNgRLWbtQ9J0F9rXp4wZmzH98kB4mIhAXV9zxacmnx3CgCErDYBLTPNomGAqqU7koyOJ1UWy6orGocjlcnjweglz4mv3mvnmOvrOGlhZ9ZDYvImZ5D0SlEzbZAUEaOdUze6j6WAnikuEtTw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 21:55:55 +0800 <zhongjinji@honor.com> wrote:

> When a process is OOM killed, if the OOM reaper and the thread running
> exit_mmap() execute at the same time, both will traverse the vma's maple
> tree along the same path. They may easily unmap the same vma, causing them
> to compete for the pte spinlock. This increases unnecessary load, causing
> the execution time of the OOM reaper and the thread running exit_mmap() to
> increase.

Please tell me what I'm missing here.

OOM kills are a rare event.  And this race sounds like it will rarely
occur even if an oom-killing is happening.  And the delay will be
relatively short.

If I'm correct then we're addressing rare*rare*small, so why bother?

> When a process exits, exit_mmap() traverses the vma's maple tree from low to high
> address. To reduce the chance of unmapping the same vma simultaneously,
> the OOM reaper should traverse vma's tree from high to low address. This reduces
> lock contention when unmapping the same vma.

Sharing some before-and-after runtime measurements would be useful.  Or
at least, detailed anecdotes.


