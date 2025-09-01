Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F7B0CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 19:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB906B0007; Mon,  1 Sep 2025 15:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582E76B000C; Mon,  1 Sep 2025 15:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0C26B000E; Mon,  1 Sep 2025 15:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36DD56B0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:23:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C62CA1409F4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:23:20 +0000 (UTC)
X-FDA: 83841654960.09.FA03ED0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0CC2320005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:23:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=waO5M7TU;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756754599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIqgkGlhxszd5dv+EEyL+ssQRqACdJfeCT3IkVeMdqo=;
	b=axwr/IcvcjcVr+yf8NZG43S6rpID78VE527sEtoEq/qSuY+0GbE4L0uKmBxGEVAHf/V1TO
	X02XoOO7iLWFuIPWjL4W4PCT01/2C41dyDHNZjYzLE6PzHzptx+d6fR3R/5PcG+0pKmNui
	J/1rP9JDT9lYN4doTpZGS84eaDDPMI0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=waO5M7TU;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756754599; a=rsa-sha256;
	cv=none;
	b=X+JjMYsXqi9TyQofY3oxmQKZfg6OBuWzsSbS+iMfns1pFpgfM0uklvdBN8/ls4yfHiYOdW
	jZSmPa9gKE4XdzLyacwHWsMT1NOmg8xhnUo10w4MBmA/uTF+FCuiqIzrYwRk7QUI/C3lB6
	VmZeubWT+4GRsyFiBrjSspj3q+SHnKk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE35140B99;
	Mon,  1 Sep 2025 19:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BD1C4CEF0;
	Mon,  1 Sep 2025 19:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756754597;
	bh=/4asbQkP1eDqEbveKkGpr0ywUBl4RSN7gR/XJ53xGVw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=waO5M7TU9BYoRGjtorAnNJETXm72HFsA3Y0tFfhW85iW307Pc3Fq86bh7keOgjgLE
	 ktpXe34fCWJ/hIBD3X4zZpOX2irMQA3Ga0Vr8rilIjKxKv0uR7kEYqCu1sIk7u49Cu
	 IOOyVz6paX9t7Kdqkgl01NvAx2e8rkGiaTJ3GKyI=
Date: Mon, 1 Sep 2025 12:23:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
 catalin.marinas@arm.com, will@kernel.org, scott@os.amperecomputing.com,
 jhubbard@nvidia.com, pankaj.gupta@amd.com, leitao@debian.org,
 kaleshsingh@google.com, maz@kernel.org, broonie@kernel.org,
 oliver.upton@linux.dev, james.morse@arm.com, ardb@kernel.org,
 hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
 yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v6 1/2] kasan/hw-tags: introduce kasan.write_only option
Message-Id: <20250901122316.6b7d8d7fdcf03bdb2aa4960a@linux-foundation.org>
In-Reply-To: <20250901104623.402172-2-yeoreum.yun@arm.com>
References: <20250901104623.402172-1-yeoreum.yun@arm.com>
	<20250901104623.402172-2-yeoreum.yun@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0CC2320005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 88ktq849ru9gtkcq88iczku7fkipxctp
X-HE-Tag: 1756754598-185054
X-HE-Meta: U2FsdGVkX1/l5Oai5uljMnc4zURadJyuyKBgT/gahNFvLOhN8yi1ZEnqqIAYSf1dYG/beoUU2pVwjNtewhDHJWuQRbO9s2FIzEpV78alrbgMQj3UHCjZk9vZq6X8gj2kaIc2Q6CfXmzY0zpamIf/TEGP5mPomEtsdeoMJv1tH2GaUR9HlbGJVuEVbT/GzDj0kyF94Lm0kIUZ19Vi7k7pmVt5NAnra2cVAih95oxH0teoAYrINnFD0RSoP5EXZ1hEC7x3VzYLpi6xDjDCxwrBVbD8Y0b2MNdskA7Bl8Lg+iKBX2kyzSAZyW4q8BSc+A5SnoOfwOWqrZ6PvrNBzarxIEvdL8/L2nU+VIbdFozbl9n5oXWPxc+M4xIpU1uszYne5vUECJ3BGxl4QiBaEvrLKZbkHJC7eUA1S4IFWns2DPo80airatOLRFMl3fg4cgfAUPNafHGeQalbwNEhWJU40Az5evlAtI22FGEZOmqXwA9p5QFDPJ51CoFMzIejLzgafK+7RggeTS8Qhmv0hgNM8EE8PV39aMdElcsWW49PL7i5XgL+/zfBpI2+UtSnCMg5VjJ6CivLHzljq2gk4n+FC+zJQT2YeRMXAvCRKxBW3ZMxk9FCOKrn6YhA/Yvjycsd4KuA5FcGAF/Da94ygsAXoBKj49kzBx1F7EjearLtDLpJtwSZLmSJKA6OtFuXGC4DGG55bzonHFecAP8r5y7NjgrcbBymx4TJqY3NngzFJSc6rhc4NBVNxNZKcqDMlfuxn0smLRZpenmYkLGc+1TKY95k3pGSJc83/DnqYna3Gq+PIztfsxxCZ8D2qiCI68W613OjeEKO69JRe2jHsvxrcu8ifbtMz8QOWuKAYW1TuqaYid2ObSjHQg6J4Dsb8eyMmw/mDfg3ICM7a0AEH7xdl4UXm3jmR8ZTDyZKXA83kibdcvopjwOPIdclLJ/HtNpbAF3JqzUDoc6pg4KT+l7
 H89oc69y
 61mpyPr7wEjzvHuTPdROiqR0ouA917E21dFuKGNNEMwjsuucxYsaHj/EzU21/iyBJ9AL1pVvYklwfr04tA5ua8paZBNvO3NCWwzDAMB3toKu5yyo5rZOAqiErVicNpuc7WZgAwDcmvxOS9nevsawqJZEDPWFaO+uckj+fWwhnqot8SZp1hqYkZhMCaH7BHkf4Kp4Yw+wX92dyoRkojweaDvHteK/8T+O+QsQJ1CBXkiqs+pBK4GoYvqWOLGResQNpviB9Pjo9GD+73WcwmS8xYBQEULlhV0ZoAzdeo8R3fowQQltz1wdfNXgyNMSvoRqXEedsZ1JcTQKAKHNPvuXoorWqnrPbPorNwuUuewnIFOGr0XRuvC1ommP71m2gydVp66nB1MLHYekZjs4zUBrM21Du2SUy1BqA5K8uLx4pQlu/b6M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Sep 2025 11:46:22 +0100 Yeoreum Yun <yeoreum.yun@arm.com> wrote:

> Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> raise of tag check fault on store operation only.
> Introcude KASAN write only mode based on this feature.
> 
> KASAN write only mode restricts KASAN checks operation for write only and
> omits the checks for fetch/read operations when accessing memory.
> So it might be used not only debugging enviroment but also normal
> enviroment to check memory safty.
> 
> This features can be controlled with "kasan.write_only" arguments.
> When "kasan.write_only=on", KASAN checks write operation only otherwise
> KASAN checks all operations.
> 
> This changes the MTE_STORE_ONLY feature as BOOT_CPU_FEATURE like
> ARM64_MTE_ASYMM so that makes it initialise in kasan_init_hw_tags()
> with other function together.
> 
> ...
>
>  
> -	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
> +	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s, write_only=%s\n",
>  		kasan_mode_info(),

This lost the closing ")" in the printk control string.  I fixed that
up while resolving rejects.


