Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10812C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418B06B007B; Tue, 21 Jul 2026 14:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F08A6B0095; Tue, 21 Jul 2026 14:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32DA86B0098; Tue, 21 Jul 2026 14:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F062F6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:55:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09E401A020D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:55:39 +0000 (UTC)
X-FDA: 85013687598.09.D3D524F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6147DA0003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:55:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=daUUye2A;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784660137;
	b=XoBEzlG+DYRjL13TewUuu8oJBog1lPa6Heq3ayJbX66uI1f2gQoBkbsuNLIEd0EZh1YWfG
	bGwJOLSTw7GPHXXE8d3gonVtUBJCBjVxC0AhzEnvU0mMpfWc8TdlZ8Mg1COQHWgzOduCDc
	Phi6VtSr7TzV268PN9TPORVQM37QdX4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=daUUye2A;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784660137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UAi4eQzDNEd5w/Ba3EDptz0LD+o9oAJZBB5wapwD9A=;
	b=Sz69M85ArnB6WvEDLTC5OwQjgIHlgnApvbqiu6PvMWaxqV6N10PVmFMDsD/XywDRgpOgKT
	lu3lhCLKddyJI/Od9SPYuN+zr+fg4Msiu4qb4e8sMll4cpL5sp5ZRRivxeFb9+8ym8lJGv
	kAZfJakn+WTJzHddcdx/WbkLFLjqqdc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5UAi4eQzDNEd5w/Ba3EDptz0LD+o9oAJZBB5wapwD9A=; b=daUUye2AsziwomkyW1X1DMg4iv
	3XZ3nvps1Dw4FNf2SJ8xKb7MfISTLkTyFigM9uj+KnAWljVhQpltxBnaDI7kbQxcuerUzWnd5qdYv
	wq5IRHWBqkX4GmzpWNTR6Gnv7X3lVuG8C/KqYSYJIbKY+dOS4X17q1z5MLCBsCFZhJfxuVjM6LvpK
	OBSBBtnDSC2NX9+BNB7nN1HhuK/BEI3sGWuWBMr4AIKrFROHnbOmSSaEMlAtq8TGtrChZ9kd/o2rA
	+lXxUgNr3oinU7m0mK5MaF0TO5nzhnLzJkwUQmB8b5QGSKtQosTV8tqGjnP19J2citaEA0G+Jc46U
	6MM9tmDw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wmFco-002QEZ-0E;
	Tue, 21 Jul 2026 18:55:30 +0000
Date: Tue, 21 Jul 2026 11:55:25 -0700
From: Breno Leitao <leitao@debian.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: osalvador@suse.de, avid@kernel.org, linux-mm@kvack.org, 
	riel@surriel.com, Muchun Song <muchun.song@linux.dev>
Subject: Re: [BUG] mm/hugetlb: possible temporary resv underflow
Message-ID: <al_AeZZTk6vxtmMm@gmail.com>
References: <alEJkwn5VlTTH_ZX@bender.morinfr.org>
 <alSyhslcItgtqSHT@gmail.com>
 <alYT8J9aRQDx_8pP@bender.morinfr.org>
 <alYZ7fso3zp3j3jv@gmail.com>
 <aleSDxoADBD0Qkb-@bender.morinfr.org>
 <aleyArKTozc4ml5g@gmail.com>
 <al82D3-mumVFAezH@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al82D3-mumVFAezH@bender.morinfr.org>
X-Debian-User: leitao
X-Stat-Signature: o35otoitqbg38pbpdc8ijkx6kngdgapg
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6147DA0003
X-Rspam-User: 
X-HE-Tag: 1784660137-365684
X-HE-Meta: U2FsdGVkX19PpXVRbGRRjQiMsyENA4pybPEFCeaTxuErLz5TJPyxChgN76QR0abZIevUxX2kAEqM5hxLA7uMWG9oGsczLcSoSzOG8RGrivhhnyQsQSNnv07UdRje7abdhAVtSucQGaBfjSDiTAe9Zb1I5KYcjzoY2NAeLzXCLumy9B1mmfSeKQQjeVzKsPMqe+9sLBfDRRlqEm84XCbxVGvnXpK821vG9Q4if2ggpevh8uI4OGMVja0wMqy7VmgEgu0riCFBE5ot8nMrWUTj1bl5uny0K4oUzc9SVb0yIkHyrQUPAEYEQMCuLPNUyYXB5ThCl4AeHwWLDqk1XOIQQzoksa9DGhhUR8xRaJz11PI6j0oMl9N4cHQsHdwGmvhoeGGmKok4XvnMXfrA83Vr1vhXy1RZxFcto0m3pHMndVrSIadnZb2NPQ+gBxCM+aAoFAUOjaCXZe7gj4NyaElNCGdHI2EcSwYW300Rs6fimEbVIVB9q9aTD+pGGv1Xr20wsP/vUSMIosa6nyf5vM5BRxSjqMBacHjSGK3sZ2m6vZcNMbGHmlyxjnfzlM5WVj//H35QoxidSYoKOu/PxHAwJmgXdEME65Pxkj4H/dehjyRpCThtdoAs2DxqU4xO3giuWPDllRzjQTMKml5XZkeeJdlWBcxKs4WSPOdkXpVY5QTU0jWNYqVujEg4YqwBE60jtNlohTM2JWiOKUhtuzxLRju6lYSDPeGKBmsvowXzsq+qR+RPVCZtdIUtnj4H3OtAlgrFZzhaUZyxzwFhlF0w7WN2Y5Y9PZvCdO+0nhrrxIpIunvnoxiTc8UC9iwfjFvMObcdqBKKvl8UvYIm/A2YI+Qx+zFOlJic884UFMkTvTsARNfBKzsZYdhe2oLaNIstzsadbD+fvq2CznJMWq2YCvOiGg9nDubOzB5f9BIWGs39NRhXBOR2e/y3lhJxQwF0ou5fSVS8peF0Idx158n
 c2O1H8nt
 idwXNRB9O5LI0HxbClVqR0j+1Ix9qDYafZQzWvQRZBJEimOaw8UbV+N+RUnGpTqEuTvKU2Clhh3gDDjNQx32h+N+X99yUH2E403/JHQgMxGTqFUH/mw+56uEcplHF9MDo3C9vGouLjSaSqVbxViRwR7SW2vnEWRtoBGUfxCiN/qQzH4j5sPksOLEU8xFh3RMUUNEU6bIPNzfRMHxoF/SEoT64B1BR8AzRz4lBy5CUAxxBisQAjVMzM3PcimnzG2ktBxSoytLP/X/5wHQGL83hrp7cl2z3+iRHcfzrNRSHE+jkV5ER+CVP9uZYt46ETMyHwbbwZ9WGmcIqkkqo0WbATrGEhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 11:04:15AM +0200, Guillaume Morin wrote:
> On 15 Jul  9:15, Breno Leitao wrote:
> >
> > On Wed, Jul 15, 2026 at 03:58:39PM +0200, Guillaume Morin wrote:
> > > Did you have the chance of looking at the selftest version of the repro?
> > > Should I spin up a patch for this as well?
> > 
> > I've skimmed over it, and it seems fine. please send it in a proper
> > patch and I will review it.
> 
> Will do once the fix is reviewed, no point in adding a selftest which
> fails everytime I think but let me know if you feel otherwise
> 
> I do not know if you had the chance to take a look at the patch:
> https://lore.kernel.org/linux-mm/aleRuVBaWu6eTCJb@bender.morinfr.org/

Yes, I've looked at it today, and it seems correct, just a few nits.

--breno

