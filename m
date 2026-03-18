Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF5E107760E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39FA26B02F8; Wed, 18 Mar 2026 15:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377666B02FA; Wed, 18 Mar 2026 15:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D746B02FB; Wed, 18 Mar 2026 15:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 155DC6B02F8
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A72F616014F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:51:52 +0000 (UTC)
X-FDA: 84560229264.02.0AA838C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DBB5618000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:51:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ietM5KZ9;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773863511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZLZxWDNVMTt/OeO92Y/u++b4kHPizkuB9BmS7Kux3E=;
	b=I7OjU82xY4Eb38DN/p3wHHd/pD7wmHkMVgyMNkk5RF4zq5ElaaOqjF8MLTebEsiNMfejxB
	jPpC2r4PIlVKeTFB3HMREJzpWE9FWQ/epszg9pBtmzSxq2ayMVVHY9xVnhE4If7Gak4Vwn
	8o9VSADSqv0D1UfHVuAUeX9Ucp3C2t8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ietM5KZ9;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773863511; a=rsa-sha256;
	cv=none;
	b=3UkRhtyH0iYYMXBWv3G2IzeCo2UOKaVrotPicyr/RAFomAKTz0ABlcE8cjD2R800h49Wqc
	qk7aeIJqUQtSo95BG54qIQAxNRrmyOkuxqInP5zm/JI78qtZWhcPbE+Mg3oZBGN61zFFqQ
	N/p1+yxPxaoGARm+e0eE3pDq9sFM9+Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1469A60054;
	Wed, 18 Mar 2026 19:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1CBC19421;
	Wed, 18 Mar 2026 19:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773863509;
	bh=ATKXW7OYZJzy7zqUfVprOrox3H7IfEFDgiGL1lnrzXM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ietM5KZ9EEyDu64shWSabErQkw8l25bLGuX1+35aLUN/KzDUl/GwZkYGCDy787GdD
	 hdCnAo7nhOfN1IPk6aTWa3jLlxODrJwGj5dJHUhJOtNpv5Vw6PXMgdBT1muFUz7UPu
	 x1w8fu7+/e5AovPtfduiSJfbfGEn/ifu2HG7n9zQ=
Date: Wed, 18 Mar 2026 12:51:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 00/14] mm: memory hot(un)plug and SPARSEMEM cleanups
Message-Id: <20260318125148.b137df94f3c3398cf453e6c1@linux-foundation.org>
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b1yzhwto5rjftjfnootmppzxyu37u79y
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: DBB5618000B
X-HE-Tag: 1773863510-139118
X-HE-Meta: U2FsdGVkX1/C/ktuBqzENKrDkrQ9yXqdrQAoB+feaLrp6EsbPgYxXeZgfs26IVuuDX7PNXSh83KGq2HxqFDL0s5LBGhl3sCN+wp94vrZxR0UwdgnL/XuwZzmlQzeS8OQUFIRfINI8b4muWtNH+p6pX6SPmHqVAh6fGZiaSdvYDNrxc47JOfKGxSVGVNyM9LE6T2vTz+Qgkoa8LbiCOhMOjPTdkmUR1RCx5cRtvPy+qj5ilHPoanI7fodgnKWoM5bIleK/DNvVLLAyazi110epZEKI1CGoE4zQdcabxOP5icxuD7fb9zmLYPcpWM44rwh0THS7VQ1gPG+hjahbmDMhNj6jvOgSBO+c2r66g41pfyNcV9tcHLuvuCbRsG3fmQHC4rv2ceemakfHLp4lJWzExMcIFxI2Hajl8ueC3J3iimqVylB7SeBFPyL/bxd2MB/8bMU43tOWc4ilNHwDWGK0/vGkP8oyWmhsBYch1cGA+FMuOktrKn/Daj/tnlnewBHvFjxcZDzpww186GsP2K9ZWWZXvcrWkdRu1SJr9nPg2W+i6BIqBQvrhMEjrq+PhQYHIW6yFdaU+14irSm7/U4+jDMM8kHOk+uwSp45GpPKlg32tZDnGQP8hZUwPdGuwbb1EV82Qz1tgnkeSG1qFAiaRknwzSdnOzy8le37TV0qeqhPrLs9FqrDYm3ElZreBJ3ORlfIqtVmitoJ7qxSeZDSJ8ZPdK1lb35OAWpUfM/1g1AAgsq6Pfla+hGd1XZjNEkbSM6i8nupnbEyg9MoGsb0RDPvahd5LCJJHtkCxuGn6rm2Vqlc6pAzGGbOSAhjzLnx82xitzmpypGLND1wHFN9QEK9a9tP19M8o1JiSLBVFd9a+X6EVhf6PVcsQ1YVE7FoqWUS6kEzhIAJ/nQveG+MR3fl5AbQEJibWElVWMOl48xGoSwRgqeJ0UA7uHS+4ixrjF87Ijsy80dpyGStQe
 Vunru8Bu
 hZa8/+L6tfSD9PTpARFcU1dkh6DEu/6CXCi1NK0DVx/G33cQW2KlLFkmflB1cJ/aN0m2UxsoT493s8Y47YTPPDA9son2e+AvDXoI2GIPL7kGC61fDUHnI7kbF+z+gAdVv+mVuCuYVAEgcZQVwnZYXNorwPhYc5jbxmApVWwZDm9GKx0GRL9ZgeARRq6jADiG4E8W3P00eDp780pWIOdRlvhMO93btvYdE13+M4AlGglMUUUmmA+jz615zCu/7+LkpFTaCYX/84X4jIprPtPD6z7Ji22j5LTZYO8W9UPVpIvfrUHT90ewqoQQFzjFuPjaHkNQuZZFgpp7LZ9g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 17:56:38 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Some cleanups around memory hot(un)plug and SPARSEMEM. In essence,
> we can limit CONFIG_MEMORY_HOTPLUG to CONFIG_SPARSEMEM_VMEMMAP,
> remove some dead code, and move all the hotplug bits over to
> mm/sparse-vmemmap.c.
> 
> Some further/related cleanups around other unnecessary code
> (memory hole handling and complicated usemap allocation).
> 
> I have some further sparse.c cleanups lying around, and I'm planning
> on getting rid of bootmem_info.c entirely.

Added to mm-new, thanks.

Sashiko said a few things, as I expect you've seen:
https://sashiko.dev/#/patchset/20260317165652.99114-1-david%40kernel.org

