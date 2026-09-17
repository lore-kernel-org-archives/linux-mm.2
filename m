Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18960C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0384B6B0096; Thu, 17 Sep 2026 06:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A2C6B009F; Thu, 17 Sep 2026 06:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6CAB6B00A0; Thu, 17 Sep 2026 06:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0CF16B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:22:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10DEAA02DF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:41 +0000 (UTC)
X-FDA: 85222865322.30.0D7E063
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 74EB620007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRqJNJ2W;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789640559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68wZjuhYIE51G7kJsw5PsVmX/t8A298hnpqXGafpPfA=;
	b=ofoniEsn9PceprMGpMBOv6duKaJmJycURl7mWoy4nP9ojRYqyyEfUbVByjd5ee5QvsWRyO
	SKUu1IiLxh8aoRba6bfSpfKW52unrjoBcJPkyBcuLTGeHuKacQrsbOSIonLBHOPMi7DSvO
	m0G63Vr4ebYm3W4IqNj1KveyBFBLzOE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRqJNJ2W;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789640559;
	b=GPQr+oPFsDg2cKpcvWifu22Y7THVHLAGMG0Toqrl0mW5624x5WUVSxYZcRt2dZhpVKQ3WT
	ysgH446iNuYMBSqEc+WTJOimRHUPx2RmWChwzOB3lsl+2abUSB04nXUQecr9ftPnCuPhPV
	uXBScHSgodRpZdVElywQr0O/CcJz1+M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00E9D60204;
	Thu, 17 Sep 2026 10:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD7B1F000FF;
	Thu, 17 Sep 2026 10:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789640558;
	bh=68wZjuhYIE51G7kJsw5PsVmX/t8A298hnpqXGafpPfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GRqJNJ2WMAydJs43gQH1POxHbtPc/jGljzYWOEKSuOZA/pjYY1qmBbjsDnqPzhSmd
	 n2omHUgY7nfys5RgLfAv2WjJ3jN4wGcAPMOFQDGNcUMu8/FezAjJECnSdWrIsZeuJm
	 fVit30tYcErtAY6nnDmxfZPDxutgdixsxulcETstIW9lshticNz0SOyrK1cWGgJG8v
	 SIzXro5EqNhcpZD9bhsQ1HYXJ+9qu+m2H2IJHkHUUrEwx6KCD52xqHZDu67iukArgf
	 NlEmFHN1pUxfm/p6f2fVE/a7RKXneKxOzA9tz32eDkHjfgD9HFbxLyd6Gos0QJJlrp
	 ZaNYhABE6bmbA==
Date: Thu, 17 Sep 2026 11:22:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ren Wei <weir@nebusec.ai>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, notasas@gmail.com, vega@nebusec.ai, rakukuip@gmail.com
Subject: Re: [PATCH v3 0/1] mm/memory: constrain generic_access_phys() to
 page boundary
Message-ID: <aqu_L0UlVjKm6dRv@gremlin>
References: <cover.1788842306.git.rakukuip@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1788842306.git.rakukuip@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 74EB620007
X-Stat-Signature: r7j31zzkwquqe97ut1icaxbpgyqq5bwy
X-Rspam-User: 
X-HE-Tag: 1789640559-773264
X-HE-Meta: U2FsdGVkX1+LUwmGWrMmszRlCAQZid3bbEKmyBTrMVOB+QsR8s9kaJPtM/kkl3NsS02BglDRFgUC3lDIWT8kDSzFdpKljc4CF3JvfxjBo/QJiSyPFX1SnwSOobG5vlrfIdX0xBaPFzeZyqR/zOSxxXnELAwGBvhRz3dJOa1mxJ1OjChrsZ1vui7Fn/f9cuEtlH9dsqOfc21+7xhiFlVWXSIPkMrjx8FS4tqQlLYNv+vSJZskUs1CnOSqTJZNtBZ820DOKTLJ3D5CD2TzxhwTz+ulwqfPdoAscT49Y1bR1KTJwORRLqd7fkesGGSPi6kok4+FxJsbf1rIDoHtGf2CbxIgwQSZVPd7AwuWF+DWKpJvtabxE1VBcgc0AALvruPxy24j3t6f5L8Bjw4lYk6jKhRHR4bZjw2NQ5EhB2iJDwn6PL0z29mLBR1D0Cm6Nfb13h618eUWdIn6OUi3iTT+LQPsSNvl+U8gYceBQLi/DinywcPE05czpYLXIX62Q4xtVsbl6yY4M3eLnLYr3g3D41MpZv9y4HW64+29aGmRWMNn2Cu8AX5kxlKUy86bjGp1BSnFXT0aQsWClUQrnY7IIWP7j7W8wQv2//jA+JIgmocz181DGkHPfJ06NjtUWzM9M6vIothyt7E32Cx9dJF9i4ZdH/+jXcU/jbHZZRYcNncZ3ME+woy5jHwpO9FqAaeLxwR40ZOBycYeuUyKUQIxK638PPFDrVsKKl2ogb/OcN6wECuhOscSlYuME5mHsDnEOlc1uuZNNCYzj47P66HiLJWNe+GPnL5+UY6hIGMX+p6yIVNpmy+2tpIY3l5DPEHUjiFDpIE9diUesc6ZBOejJqh3eB1TWhVsX7h9CiOHrbdBWnkyFM2l7KdtPdhATAgv+y5hvDkcSONZY/A591Xs/Uk7NEeuzoMF9ojgXQrx6IeZncAY80K0HoOMivs0v+YiYqNfjpc5R9rDLo6p0Ev
 suIvsno3
 MYeJXKGHTg5VYT6+///6j2IaSQ3+se35WUbZ8HcHoe1yDOowYRdePj02CJjX4lpH9NzYa71soLQQZQgw2hAXv2pax2B3I4deDxWuqnVUrY4FKyBgQhlci3cGR6eOdPxuee1upwidpi72gWZJ9cnV10Al/CSGyqNRgfD1ir9EbxgurO6ZP2FnpCQ/vDon6J1p5Op9YaMUMVqX+kOVoIOuw8T/9+qD8AFOfAsKojXaPIrw8aND+s3K96EhsTJSPp4dHrLJXYoSqd3W2JKPy2djwrQ32nDgHgekZO46nXwwUxpfGNzCPQJe7irmQwMKvFiqYf/DAP6i1b3BULojx2n7RF0DpEFPbQCWANowX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is the friendly patch-bot of Lorenzo Stoakes.

You have sent him a patch that has triggered this response.

He used to manually respond to these common problems, but in order to save
his sanity (he kept writing the same thing over and over, yet to different
people), I was created.

Hopefully you will not take offence and will fix the problem in your patch
and resubmit it so that it can be accepted into the Linux kernel tree.

When sending emails to mm:

1. Patch series with 1 patch sent with cover letter

Please send single patches without a cover letter.

The easiest way of accomplishing this (+ our preference) is to use
b4 [0], otherwise format patches like this:

$ git format-patch HEAD~1

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

2. Missing cc's

You are missing cc's. Fixing this is easy with b4 [0] (the recommended way
of sending patches to mm):

$ b4 prep --auto-to-cc

Alternatively, you can use scripts/get_maintainer.pl:

$ scripts/get_maintainer.pl --nogit-fallback <files-or-patches>

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

Specifically, the following appear to be missing:

  linux-kernel@vger.kernel.org

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Lorenzo will reply once he has dug out from the pending patches received
from other developers.

thanks,

Lorenzo's patch email bot

[ Idea shamelessly stolen from greg-kh ]

-- 
Cheers, Lorenzo

