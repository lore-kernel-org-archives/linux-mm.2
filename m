Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AB8E6B26D
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 02:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116086B0088; Mon, 22 Dec 2025 21:09:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4666B0089; Mon, 22 Dec 2025 21:09:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05156B008A; Mon, 22 Dec 2025 21:09:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC7546B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:09:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F344160437
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:09:43 +0000 (UTC)
X-FDA: 84249104646.05.F39A2F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 00D3C40006
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:09:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="zf+UFP9/";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766455782; a=rsa-sha256;
	cv=none;
	b=Ki5QFgcBmAuYvVdh46gvQk+9K3EYdXjHFxmcF/32F04zm/VxIWLy8oQPk8tuGm75dd4+Gb
	oGJgYJ9X1DXeSYW4bne4TrtOcSlnNtMfPcl5MvFgSXV1YJrh37lCzdUnW+KFae5LQS1Wn0
	D/5XENktVdWts+V6ms22rs85rj19iKQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="zf+UFP9/";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766455782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjOohyygVGSf2xYGgD42/FW4oPN+tx6taP6zHqBbQxw=;
	b=jncdsrC71dM3iBizZ8IFJL4RLYkza5lSeeAP5U1gBSLqaSDvEWmZImqcMeqIeRh8m2QoY9
	yKvZq9ENksiyCqjL1ARJa8p6YJupxvA/7ZP1fClwlKYTFm7FFuaDI/OcTrICNl8BiDLctV
	v4uyWtphVGDuFu5mKH9uxwzGDEg/lq8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F86460136;
	Tue, 23 Dec 2025 02:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E14C4CEF1;
	Tue, 23 Dec 2025 02:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766455781;
	bh=AQLfanbb9dQEk3fOTNLXdF1OqxqK87zVLhLJu0c2XjY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zf+UFP9/Jahlxv6KaIZNZCZejhI0pnpghKxyZOksaJK5Ymp1yj4EZ3LFwIMQIvKkF
	 gq9Fam19sHL2Z6Ro1Z5Gpkn5RR2uSrPCgFHAmVQWDeGAR3RWK/zMDuBmv9a0iZFRrM
	 26jK1Y9vtz9qTTmT4Sb7VOxWuYtzKCgrTiqFR8jc=
Date: Mon, 22 Dec 2025 18:09:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-doc@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 98/101] htmldocs:
 Documentation/admin-guide/laptops/index.rst:7: WARNING: toctree contains
 reference to nonexisting document 'admin-guide/laptops/laptop-mode'
 [toc.not_readable]
Message-Id: <20251222180940.ba15b0280510ff101e8c67fc@linux-foundation.org>
In-Reply-To: <202512212211.GvfwAGPP-lkp@intel.com>
References: <202512212211.GvfwAGPP-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 00D3C40006
X-Stat-Signature: p6ps7d74tsatrhq6qzktw1aouqwxxmaf
X-Rspam-User: 
X-HE-Tag: 1766455781-584680
X-HE-Meta: U2FsdGVkX19oCRguN6X3UGUfw0QIXSzudhucLgxb3MAyWcpiN2XqwoqYHJHNXg2GLL6Oy1lATqxjGdRYTBf7E6d9DsyETHp2kx7pwe9VsQRZCYEDDRIY0UD61faK9YIe6dEtGEeH1ygVKbUxkHJR8Mku+vCnwyKSpHgH3ydL0YLNcctKSM8gDTY8mHWXWPGHbi04qVgOwQrWZP1FpOI2yba515QUeWCd6hk8o/sYdHVp7NiLe/q0cv2FifEwq3cJ+hsfqnUlNUKvKyoqPo85UOfbxDSjhSFNlq5s+vcnIZZuvchqAQL/14Znu6lVuY4Dx0SiAiVn4dDXyklY2JuOQR+flwPf68YKaxZEV56ucJF4ixT0LbQhIfNNonoIzMwpzr0TZHe29zT3SMiaQGAx9Aq+tY7+WAbRM7UCIHet8pDdcdqY6ZRJvG2W8AlxKgVm8xjIIrQSWSnvoHwNLSs1beTQZovrtBeBEAU3hTGtIWSGHiKA7uF9fPGOcObLxwUmqFCrSOBwj0Rd6NtYjpgOp4aS9XDC1w3Q6tQpLFr7EPv1dbMdnsEcxcmt1QWgpjLExOTVVcegdMLUogOrsVCWKsv96TYfozOHhnGSuCk80wyI9pEJwhaqVvXrRTgox9spzdMqp5CW0lJvGVKzQVEX6dzRmwFnseZTo5YwoMc3mVbK/EUt9rU0Gkni+6Fq9Kzj6hrU4qmbC3r+g2zdsoiq4y6PTghQg6V/J4XDaOuXp7KgG9OSh/ixy5fnWwkMOAy9V1jeWFPAe9uSFhsuspGKizLt05qtp7Uou5psRJy1vZS+xK9BNBZc/94603Lq5oSHzEBGSBiiS76Ak66EMa57wfffFvU20D0bj6MkhwU2Gi+7pFe8/CElpodcwOw8HBEtHF3E6Aed2A8wo8g7b4CKpHs7RwgqNncWEMraTHDILZxnp8n6YA1A8xnXNn6ZQyajhc25Yh6mmHrJsC9+NHE
 oq9uVVOY
 bJZYlJKSGq1p8wQKpmH4B6WUCei9vHpHjPcrUVXM5gNFYADvqEKnQfLAYMIGpWk2KRorO0kOpmEoxg2KbI7xiy4DNrGNg+NhUoAtCGSxrNQZbOKXTn8Eloww4DELgkWbBnbbo0rSXSUDfOkLcJb1fHMNUqAAY4XQ7xGWjf7p4kDJdp5EvICI8W6DMkh58RKE/516tcA7IzkD1e229cQ4tU5JNtnvZzxWZmE3zdrdX3z0cDKNzHmDYn2jACiEpToWNdkPUwicGGzLvUa71CuL+We0cW27EEOcze6tYpF0+bAouTAVYYB7C9tLkPMeO13X9mK6KST0ElFsxjRFk5NOw34cXWU4JOM5W46u/DNMy7pHGOIM9ngU9wsYh0PvBnaYvwHMCDLsClIN3SseZIpbQbv/Frg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025 22:49:44 +0100 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   287373d0b6ee3872d95edfd1921fb2f18535d6cd
> commit: 7cc91bf52584387445d654cde466ba5cb1235757 [98/101] mm/block/fs: remove laptop_mode
> reproduce: (https://download.01.org/0day-ci/archive/20251221/202512212211.GvfwAGPP-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512212211.GvfwAGPP-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    WARNING: No kernel-doc for file ./include/linux/pci.h
>    ERROR: Cannot find file ./include/linux/mod_devicetable.h
>    WARNING: No kernel-doc for file ./include/linux/mod_devicetable.h
>    ERROR: Cannot find file ./include/linux/bootconfig.h
>    WARNING: No kernel-doc for file ./include/linux/bootconfig.h
> >> Documentation/admin-guide/laptops/index.rst:7: WARNING: toctree contains reference to nonexisting document 'admin-guide/laptops/laptop-mode' [toc.not_readable]
>    ERROR: Cannot find file ./include/linux/pstore_zone.h
>    ERROR: Cannot find file ./include/linux/pstore_zone.h
>    WARNING: No kernel-doc for file ./include/linux/pstore_zone.h
>    ERROR: Cannot find file ./include/linux/pstore_blk.h
>    ERROR: Cannot find file ./include/linux/pstore_blk.h

Seems solvable.

--- a/Documentation/admin-guide/laptops/index.rst~mm-block-fs-remove-laptop_mode-fix
+++ a/Documentation/admin-guide/laptops/index.rst
@@ -10,7 +10,6 @@ Laptop Drivers
    alienware-wmi
    asus-laptop
    disk-shock-protection
-   laptop-mode
    lg-laptop
    samsung-galaxybook
    sony-laptop
_


