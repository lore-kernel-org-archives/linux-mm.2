Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B7241125852
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 16:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7117D6B0005; Wed, 11 Mar 2026 12:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E96F6B008A; Wed, 11 Mar 2026 12:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6292C6B008C; Wed, 11 Mar 2026 12:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9F46B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:39:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B34B0583AA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:39:55 +0000 (UTC)
X-FDA: 84534343950.30.462711E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2EB64180019
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:39:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BvffOP3n;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773247194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGpXyALhfc9ipUvUx2Rb3/Cd1rhguI2Q8MDX4D4dbLI=;
	b=gEORUQQrQP5EkHQJd18kWVAXVapo5ZBeh11Qyr4KJ4aVuIOle4Q2Y0nCK1Ej41/UcjHsPb
	uulM2rw/WhWVzyMPbdehKyilcl148QskZz8yzgGiGrei6hDJli18RucIod2Ra3Ta9VpqL6
	kre/2uxjcObMKPoBL3lYxbLpT5sUkEk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BvffOP3n;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773247194; a=rsa-sha256;
	cv=none;
	b=I9n/jTjg/gSK6qtvIoynxN2h141p4AwNtfxdiFM1udmavc4S2aA+72QYGa30Uc8ZH1k37J
	vX4o93DSWmY6J3Zxj68vlfZnOhCSoIDubBnVSMgnxbOJy9RTy6MrK9g9Rekolr5ps+lHzg
	HHbhRxCr9HvK37HxEXoctPyIL6pOS9M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED61440700;
	Wed, 11 Mar 2026 16:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8770C4CEF7;
	Wed, 11 Mar 2026 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773247192;
	bh=sGpXyALhfc9ipUvUx2Rb3/Cd1rhguI2Q8MDX4D4dbLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BvffOP3ncDcKlNtNMsTMQistyIfSztVrCJQPOZ2HzPGHem2ozXIJFuRof8aTDuGl+
	 ffDtSyzeUfE8ED2h1dGDHLkFJpfxNLkAPlD3xmsPrWI/ukYrdArKTpmRWfz4P/XttV
	 vENoSeMlovMxFyXtuKXyN+DLSmcg6/zpz2pbdM7zxJMr8aiknMcaOhhsovNeBVvDWM
	 Z039ULAcS+Vg7jcSg+2U2qhj1oV51vIrB/LAsBce3wW1YsKQLmz92hFwxPn9hVeaCo
	 axLAtRQse4yPVCtXMz/CgJXetVk0h8MSaXKIkJ+nvVe0cqnNIKCOz3472hXF2Ybny+
	 YQbAh/kARzirw==
Date: Wed, 11 Mar 2026 16:39:48 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Jianzhou Zhao <luckd0g@163.com>, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: BUG: KCSAN: data-race in do_mremap / vma_complete
Message-ID: <7464e0be-7e5a-47a1-afd7-1ef20ec57aa5@lucifer.local>
References: <1a7d4c26.6b46.19cdbe7eaf0.Coremail.luckd0g@163.com>
 <abaad620-bc19-4a3b-9bef-6a1ad4335ce3@lucifer.local>
 <u7wzfkse7au4aganufewx2ykz5xg2lgzaf2eu3tfkmowcmsobb@4xubw3ikany2>
 <3c0873a2-6b9c-4842-b2d3-c3ffe908afbe@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c0873a2-6b9c-4842-b2d3-c3ffe908afbe@lucifer.local>
X-Rspamd-Queue-Id: 2EB64180019
X-Stat-Signature: o5iug4wjyfm4w81m4gmfehw8eyjjm8dh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773247194-302178
X-HE-Meta: U2FsdGVkX19bbKRWmo77n37BCTq+ByAx3m/Ucyi4ORlvDB5AkT8GoFnWzZui+mxiG0wO4s+j5TQd7oOIQ9CFiBRE1/qHU1LPjtvbnoZyO3XRW2pvnF92dStb3zis6QXCRoqjbbbj2j0RwQ9QsWpSbS10zVT63W6MDRX9ZM5fSenH5C1b7JzBXg+uZGa66snC1dAWFJZ1EZ3yG0Zq0iSzA5gxzkBiErV57jjRCJVRcAs9PAUR/IYGWgj+L35V6mreqQdmv4KMRuq/keU0/HP2/NJDC+kCBk7ROSEeZqC15ToHNwxMN5IzXxgKEDBWAC754SXV9Semrzt830pYAFn9dqFBdEr6whpA/D5h6s2sEJ6wE63ND15fobv/FM7f27xAeKWT/f2dA62JltPVwD3A2dpgwJ0LYyHcjSbHjS41UewU77plTCydyXBjxG5g0JcAvHbui2fJ2Q78i8/duk6VsFzX7ST+hCfSFtCYo1CEc3fbuftEcyQJgwFlJkNTdKuov1fqW/IJ/x+hY6HDHexv24cBjiPIIJ3EvZyqovIXh3QOacqXUdORZdn0H0igeusqJcwgIA02JPYFhKVmiqFlNoe2+Bt720LgEKfN8PVL8FF/d2VztYwrXdh/MgDcguHcFU0A4e7d3pvdMfVhfu/NHCfoMEz3MZo52mdW5bcS5tSiGHLinoSBSgShU9Ld1v2Qx4owybeyvVMaoqVuyj4ikkLm0OfmjrPkinvgWgNyOvghuYgjDVX7DHri9XPgVAMJSYgrLC76M5AmF+op+gNa+k2kQr546nR2qV1+mi8+l+IA+y+UxhFAaQ3tqBd66cym3X/KJjqOxfRc/S26vtZ5kERg6GohnOteGW2MAxq5B316Dwc90FHgCYNE5MvF4JzoIPrZP50SZXm6p4nSkWzQY1m9R3LRkaluGSVhHspKjrXHZxgq7wOhWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 04:17:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 11, 2026 at 10:27:32AM +0000, Pedro Falcato wrote:
> > Well, the problem is that the data_race() is incorrect. It would only be okay
> > if the check could fail (with no bad side-effects). Otherwise, we need READ_ONCE()
> > and WRITE_ONCE().
>
> Yeah true, also a user can update sysctl_max_map_count without any mmap locks
> held obviously.
>
> So we're probably in a state of sin generally that we've previously tolerated.
>
> Anyway, that check seems to be wrong, so I'm going to send a patch that fixes
> it, and I'll update the logic to READ_ONCE() this variable. (proc_int_conv()
> already does a WRITE_ONCE()).

Also, updating to only check this once mmap write lock held, so avoid the
racey situation altogether.

Cheers, Lorenzo

