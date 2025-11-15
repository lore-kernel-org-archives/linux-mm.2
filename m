Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A0DCE8D6B
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 01:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6648E0029; Fri, 14 Nov 2025 20:48:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80BA8E0005; Fri, 14 Nov 2025 20:48:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96C08E0029; Fri, 14 Nov 2025 20:48:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 953008E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:48:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3CD931A0488
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 01:48:16 +0000 (UTC)
X-FDA: 84111156192.22.572C81A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A63061A0004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 01:48:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Caae3gRh;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763171294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XDYk0bpjajaz09dvSuVLt+FnSuBEajqHFSttt4FDiw=;
	b=N2Q3yd8sYNybgMHwNFtjiOwUofMUCMMk0v+Xx0TRKjdiAH/5i3InsRJf3xuWIkUNbIzdZq
	E/PNEuEvcedNh7+sN7xvGM4xO/FuRDoNC66IRoOhn+a/l+PYG4sAndVT0ec5hCLc/hgmLs
	vTOJbYKe5KLKHlu0vXlBprdWOutpvxg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763171294; a=rsa-sha256;
	cv=none;
	b=nbP8khvwGfOP8za18xUCyQ2HE3eDR/NL7mWsbaW3jsraeDHzsprrUR7QiJulHA7s5bCyu7
	vg12SLd+ukspkjtjZDNVKQiAIZf5S/cWbZHhcjM2zjJu0dtg/Gna5cC2wM2g24waIiSO0L
	Rz8+ALZrO9BRDO6ZPcIHkXYYdzrqfwQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Caae3gRh;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5C5C60007;
	Sat, 15 Nov 2025 01:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E92DC4AF09;
	Sat, 15 Nov 2025 01:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763171293;
	bh=D87jPQOiYZ6fr91ahpNe0YOpMiqCfNUGgZFzJGVVjDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Caae3gRhnVvHTL+Al6KhQ0YaUQxbtKv41e8aHV1lPY4zHcjF2zNR3r5B3fq65iM9L
	 gbSnYtqlO9CUkUIi6eRwv94K4Gfu49JNPLCV6BNdWtvP8CQ8XB2mTU+7NkIpSdmagH
	 DFNOW2TjiQATP8qb1Y03cf1p7KYHrKBqdTOHYhqHrhygVJPtwZ8tNF89asq22AN/HQ
	 TGum8cCL3TijmdQEkn6HfnbQqZONd42Gth6Bsk9z66EGohqm8FPdvzty6YnE0q+NHt
	 oHe9ubqftBbrMAUMExR1GCZlu1RnEkzrsJjtPS9bVxSUjg02FbtJtpl/pqIEU28U8t
	 1aV5QcLg5xxMQ==
From: SeongJae Park <sj@kernel.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	LKML <linux-kernel@vger.kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [RFC PATCH] mm/cma: Inline cma_sysfs counter hooks
Date: Fri, 14 Nov 2025 17:48:09 -0800
Message-ID: <20251115014810.79376-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114110301.39316246@endymion>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A63061A0004
X-Stat-Signature: zu8sgz1fmzy81exyue6m6kxbaqzzxw17
X-Rspam-User: 
X-HE-Tag: 1763171294-985303
X-HE-Meta: U2FsdGVkX1+GuwCHBC+XihPUPigk2SYYHwISgaY1l6lLSQ9inLEQQGYqcAmTrpbcYihTYIokvufo1acgYLfNC8kc2iT1oURDAlykG6/x7soRQfDG6kVkO/Macf6buByNDDype9EyqzeS3iQOhzrnsqurwHQytOLV6/FwCyzwcfYeMd9ubn4LHeNJDCUa2bsOg5U+PJ+kppwLxacgQiz+Lwt9ekQxLBQpnvVEBzwFH34d3Nq8KTBe+AXQz+cMH1YQr3JVnzrBysAsJ9/lJ9BDdJIzCLpixB/SANCZX2CGVGnVivSjbhYf3t2ePm8wwgF9Ux5wGmknIYCk8jOs4njhP72BpuEmdGMase2PkqMI+n1dh1OKLr84OWguXJlDx7HfK3jV9zLFMiJ3CkG23G7J5EqVXDFVSA3tWUArRKUyQ6VDr4enFgkTe1eGxQ31EhZjnYf+pP55fmaflRojzuPbfVM+vfQHTs76KCxpu2gGV3QOh6SuUhvI0OZMdp+D/R5LAb3pwdWT7Nnet3bHXT4nr0ftdhyLBilOcOOXi9RJtGHivDDSf2tdU3W1Hvg2o5HG9gLh/1SpAnP3tQi35qW5YcIcHsqp3mSMsKAGr3bJco4SULmS1kaJIGTY3yi+qI1fLNqM2ykGN/8J6IK3R2HfS/Oup8jV93oOeSXPxvUyTWUtqY/2KwA+Mxi50/4imcbu6WCQc82WdHwUME35YadYSKM8nLGOv5jmWvjIpVQkziCUmh2b2Szmmfxt3xAPTz0cSm38KFo91Oxi26ADwCU1VTML7P30l0hV2gKX/E7wt+eWAT4kFdxwGE5/Sx4+FOWuRcuE9aPmgWGd05XiChYEJAwmHCX7y4FTYlJ2eJk5gAT8Jx9UkW/suZJNRh/q8IS33wdTdj5Vt8eBi6rsUA428ftXQvzm/jvXeYA29TQjkvl5uyXn8sb8thkvFrbuzZCpZT2IE/l9PEmOwiCl1LO
 UAsWfvk4
 GrklrkfJUf3yByOl1Q7x9rrxKXv/gE4DXgFPei/8xHOiue4Z09wyjx442Qw/vS2PetTam4V9Q54TIj56XdJbxRZgdOFfgod/x/jJNcFHDkM2hwd67OM7mVQi/CbHw1IIJVxcsrgh44pxKCfJDV2rLvsxAiGa7egdD5Nq10S0quBJ7kv85m+mn7prsxdtuZ8xoijDGOYH87jpV+kHZ0rPIO8CQxdNTdE7M0EsNQ7y41MUClRUx/w6ACRJZM651JzVDh0LNnfMCBwt5/Os1+OGkMWhJJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 11:03:01 +0100 Jean Delvare <jdelvare@suse.de> wrote:

> Move cma_sysfs counter hooks from cma_sysfs.c to inline functions in
> cma.h. These one-liner functions are only used once each, but the
> compiler currently can't inline them because they are defined in one
> object and used in another. Letting the compiler inline these
> functions lowers the footprint and runtime cost of the sysfs interface
> to CMA stats even more.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>

Acked-by: SeongJae Park <sj@kernel.org>

> ---
> Applies on top of my previous patch due to a context change, but
> otherwise independent thereof.
> 
> On second thought, we might as well move these functions to cma.c as
> this is the only place where they are called, so it's hard to justify
> why they should be in a header file. Opinions?

I think that should also be nice.  In the case, I think it can drop 'inline'
keyword to let the compiler makes good decisions with its nice knowledge.  Also
the similar event accounting code such as count_vm_event() and trace_*() calls
can be moved into the new function together.  If do so, the function name may
also better to be updated to represent it is not only for cma sysfs but general
events accounting.  Just my two cents.


Thanks,
SJ

[...]

