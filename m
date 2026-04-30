Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 443BDFF8864
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD0076B00B9; Wed, 29 Apr 2026 23:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8196B00BB; Wed, 29 Apr 2026 23:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5036B00BC; Wed, 29 Apr 2026 23:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89BA16B00B9
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 493FD140323
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:52 +0000 (UTC)
X-FDA: 84713785464.26.A3C066C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AF8CEC000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qDZoBJBy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25dJlTARsIRfkesN5Wf8bLjbZJM6J//LD8/Re6TixVo=;
	b=bWF038/OLGmPNT8zZnF/VvNWLcEeorx2uagX7BqNyvaj1HYgbDgwU7K62AkSybMS2IQGsY
	h16FnInxe1NRpg6K77EiI5inO0tt3DbNvgLaAt75Rwshyi333blZsig5LUt5APtttwAyp3
	Ft8caOSDr+SL2au1L/A8+XwjdiYDNMU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519610; a=rsa-sha256;
	cv=none;
	b=gL79JlluWBC3BCtIQnWuaW6Xqv+Pz8DilGoicEutZlvD15sCB1bJWPQM76mGbK9Mq7uI3B
	jvQ55wscyr0o/B0IGN4wllqmh2tzJ8D3KCqKmPzWFcmNNNE2MpUk3oGa8nldTOQr+o3JCS
	/aukkD2XwscWODZrq7UPTMrrbXxaPD4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qDZoBJBy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3975A61420;
	Thu, 30 Apr 2026 03:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F82C2BCB8;
	Thu, 30 Apr 2026 03:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519609;
	bh=iFqroCI9QhrRjRPr6nqnuqqWoIPtsKBpJSs5D3LwRHU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qDZoBJByuNsp58dPyZrm1NWzEP6bDZxrt4juzc1Ayrev7wPMACk+uUM41eKdHbD5s
	 i6WA8mJHerklMdFyLbo0sLVn0Wn6JtNrrlu6qNz2XPV+xTwfEr2Ao33Ahz05lpp4G3
	 NHYs0GmngPzMGLvWDKQZbDWIYnpWyiSQgC7r0FnDEL/o/BYqTsd2fj/qa5a5riwjV/
	 qHReu8/iWe0Kzrh+UPBK8/K9grFHLk4eTC8pCN6N48Fw1G4diyvsMP/zpg6m8WwzEd
	 Wuvzr7EgyEvnskXgDxRM78pQgyr7y7kHNbprI6MzT+kmtUllYIlaB8//LC96wQV7Xf
	 WIQc8djoGzeYQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FC563809A07;
	Thu, 30 Apr 2026 03:26:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 14/18] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751956479.2274119.8317675820783174184.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:26:04 +0000
References: <20260227193030.272078-14-kas@kernel.org>
In-Reply-To: <20260227193030.272078-14-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, david@kernel.org
X-Rspam-User: 
X-Rspamd-Queue-Id: AF8CEC000B
X-Rspamd-Server: rspam04
X-Stat-Signature: ijbfszdx8mngkmqcwxcdgenwiajeaqwn
X-HE-Tag: 1777519610-455621
X-HE-Meta: U2FsdGVkX1/ue/qhuBfOIjPu1xkQYNIg1gN9VTgW4BJatfO4ABaq2ma/OaZW4n81mYgZhBqF8J8V3ZzP1oh/THRnKZRzxabZ5uyVtFs63a2Gg3znzQWdUR36fMgrjulbnl5LR0ncdUwmYIHi1szHGY++xDujtk9kh8uqXL6gllBy8aP+OfF50kmZdRJ9kEJ8vSayvH/wkqNO6sxjDQHlQ/2V+yiKEAw31uHuVfI/FbkGwgjVWPyEtbx/NT3GZkG5DZc06ESeZkiGwMHoHJ12NC+/S55TCmD73yEOZdr1Wg3BXjUvb7jcNbK4i0PrjMO+RdTIjkiEUkidZ2Yl7BKCQgAgdgHgXELQ55HR5+DdvdR93iRZzzx8wt/c/nLUEFP9aHkyDu85vXqSK4ebydXxza+v4e+KQGqZfdy/CSPnuVzg3mDbpN4raNV3xTi7oI20ELBYW+EOo5VxrbfKK3vAked/BzVJlrkMUgYbRgS1Oswhl1PGco3kIqSJOXWTeAe6grHgFNMViEKMQerpLpw/w4tMqjexkcdNgYs6IZIjvUsVwMi5UFuZrbNSrqExyg3EVtuBwSR29arelLMwRJsHCWE2Dl6o8EEr88agK6PI1Kmg3wyWChaXCgaxqMpe64eTD5MoGEXNSDtFe8H2RqAfg3Km0pVlJrBYq1VvCT7tZolEheyUXwyrEOv+NUres5mkMn/WDB7a1Kd6bRmwW/Gk/JfoSmNakLx6RBKvpiXirCY8DVPe/EmpIX2kyacF6AKunzhAaPzzPLgSShPM3SajfInZXYmJEYjSWINBxswgG/cQ0OsPsatrBh9gIfMfiI8iAeyeD7YnI+ZB1viPeFnoux5PIxztv8IfdKEBYC7ds0/77QlDT8leyMFHzeSoOcvTelHbphXDxV4/Jh0o4rO9YFTu9YPNLYZxWlBCVx7RXKghmV5/C7dk2Waq1ndM8XHBFc1Kqcy7NWXvXdLIe9g
 8xTC2/ct
 +Zt0peJmYBrU87651nyO7wl83nTEWZsnHwNHzQS6aNTPnebA9n8HLDxSExQLAPuLo4S6GlBm/RXhpzTEsKSCSmePCk/B8NrVMDdqRz+aYM5ABkD+mki84NWqH9YBwy1lMRMqvWVnpNJMmnEJFRDsie1GUp00TCWd1lZWDhNUiuxOTut4TWzT6S2U3NnLQDkWA+Ke+vUwZiljhUXh+I3/t5h5+nXSCjX1KxDrxAArnUuwCKhLgs+dQbcsNeZgebGSOdkSAUvnzEGlMPpyU7GWTk4ugLVXMsTCnLHmpnRz9d+2GovSFfsYdz2110tZYb7gN7kGZZBmuVCKe2ZdQPPFEfyWDPEyiInn4OitHrG6DVpJrkfm9JtkkvSCLs0hg03b3qwMwxKUtS6cP16zBGtrsrr3iH9si90W0Ysvf5YgHKoRTrr2qfQpKwl87tebxGK32KSc0v5LP+Jt5/qrhJ/H0ZhKlugMtAaSXcqN5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:15 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The VMEMMAP_SYNCHRONIZE_RCU flag triggered synchronize_rcu() calls to
> prevent a race between HVO remapping and page_ref_add_unless(). The
> race could occur when a speculative PFN walker tried to modify the
> refcount on a struct page that was in the process of being remapped
> to a fake head.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,14/18] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
    https://git.kernel.org/riscv/c/01b1d0ffb6f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



