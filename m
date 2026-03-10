Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2514AFD88C5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 22:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F356B0088; Tue, 10 Mar 2026 18:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E236B0089; Tue, 10 Mar 2026 18:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A086B008A; Tue, 10 Mar 2026 18:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9996B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:26:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9587A140359
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:26:37 +0000 (UTC)
X-FDA: 84531588834.16.095759D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id F2DDB40007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:26:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tMy2nOqh;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773181596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZ/FFKg+pgBnlo0lmpkDDW7J+SCADTSzwKPk3IuVCEA=;
	b=68AhBdmNEDUiEnQZIoUf18nzrIIlHMLRDlvUbULGCvinP84xisVbAMw4pFWDX6sNDsqtzH
	3DroiBosGXrc5eRcDtwmR+vJ1EplXtAtdIfKVCFuIUlVMxnfw3odVY710g5I7Iy6lD2mUs
	AO9/jMMWEL+v5w4Wwa6/QwG6SlOWMgw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tMy2nOqh;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773181596; a=rsa-sha256;
	cv=none;
	b=tVW6AftKQ6SzpmJWmLIHYHdwckfuVEWSwKk8gsKBTFD0C102u978rw0hLmY6UebJQLsHX0
	RxuxdhxcW8ACaE/66oSiiPD75JqdArIij4QBXgLBaqrv944nWP29USdRy36dCyV+hYdq3u
	WFb1dK1nCMSamyMG/f20ic+mm9p2oUo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 545CF600B0;
	Tue, 10 Mar 2026 22:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8FBC19423;
	Tue, 10 Mar 2026 22:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773181595;
	bh=MiJVL62qsCyYZ8Q9hg91dFKxbXDSYJtJCUMeT8RSe5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tMy2nOqh+lVisv69GNVkSEJt9g1Qr03MTTHGiOse6QUzZ53kMuiZ9S3G/hr+PrjWV
	 WXXccBj9JrPQmy+65UMvGxFAzUZGCzx+HL+lsh9m3ng4XtJEjlbzkcehgnVDGbr2jf
	 H7401RW21twx1DfnOyOgWcLmrhAwXMDz+aPc0CjPkfj0bQd1FAXpGtXdwVCf7MXT2W
	 qK+qK1HU5qRHWQyisgFCoJkoMB443UUFJwY0t765rBOzGtuwhhRck7uNrNws1O+Ezh
	 /MPIXuSi4KPVpBWwO5VDi42YtNab2U1otLRJr4Smmely+UMIFs/EU8EnVUrIQv+lhO
	 Xb0W5tD+XouiA==
Date: Tue, 10 Mar 2026 23:26:32 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
	linux-nfs@vger.kernel.org, bpf@vger.kernel.org,
	kunit-dev@googlegroups.com, linux-doc@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, netfs@lists.linux.dev,
	io-uring@vger.kernel.org, audit@vger.kernel.org,
	rcu@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Christian Loehle <christian.loehle@arm.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kthread: remove kthread_exit()
Message-ID: <abCamDkRssM8QUVa@pavilion.home>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
 <20260310-work-kernel-exit-v2-1-30711759d87b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260310-work-kernel-exit-v2-1-30711759d87b@kernel.org>
X-Stat-Signature: 7zepw58g1kwje54s8gi8gpkp8tutb5mc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: F2DDB40007
X-HE-Tag: 1773181595-159262
X-HE-Meta: U2FsdGVkX1/WNSTYEU4oR5zSFuvfzlgakI7Unv4V8skjZNIYHTZVAhkeChgSLa+RE1ue/V4U0x5fZQ/U2uDQC1b4vZy6fcRrC79y0zjA2M4tLtdi6wzBG06GTd5dbJiH+3zjQTdrOrGA89PZXVeIE2UowYE/zpDpiIvphXievxzrHSUd5QOXz0v21tE+6FPklNvY29ttE+ePDXY+5RhByW907k0Z0EOC9ESMXn0quAub2AxB53R6tpRAZtT2aiUrn36DFJH6Ue2Jp5SEr0kc5uJiPB2HSGJBfv/pKKtJeXkQWj2E51krkjLsZAyDB8LHBPi5EVimX0AJwRVXNvBGFfFvjWDziEr7+K6lSHl/8r34vLXQ3p2hXyfZpxaOcfzh2JHGAYop/LciRrlXxLqEIAVRznDwS2+P+DS/0CvuE8qgJv5V5oO3TOJuJZS4zXEgEPDxN9lhAfAFHeCJF6jkFLig44da5w4w/3pefI7npRm0jSsVL0hOoUgzmdCl4t9Og1ar+kOk8DFwv9dR3LHh+DZyXlKY+EnGFiSsjWW9jWDVyBt3IxdDkkeGQhehnJ+RsHyLJYSiag/+I8THJLzAxjlin49IR101AmlGPZFghyBe3JzofwcngQ0DQnabwU0VEmeu0ovGkSAshVLiiZtVwdrXqdVE2WcwJl2S3Z1HCK1gbXmj4CgpcQGRRxAZOAftbwI7FnbFrf8vVQCQGw1vdnM0YGkUW8vV6jmQ5Mn0ScxvsJ7ZJb0Fnk3LXtNbOQ2olqQuj9o66zVIlhjgre0BNSoPvt5jeFp4cI9La1oS358804GX4erb+5m252l+f7PbFsSeb0j/NhIv9W+KuGlS2/X3GGPSAWB+cf/jiHv5mVTx4x3zFj8V06iMAD3tdAMsTd6IIaeufs76gM7YcbkPPXIdYBq5bw/yX4WBEaipSd9nL8SzO1G/T0wHgCf0yOptgDHDRLPDSf4e7IPcKjK
 gnKwjydG
 Z4kX1FdCaZq2p/UWKl3xpck2GfbivnoYwb0xNuuTkZW+SLkPfCP9fDBi6ngAtRDrjdFPYj7AMYjbOL4OBangdEcHyWdVbNGRogrQseJSfiA+iS01vUWeKy3kLzWbEf51H6WVCqT9X+4A/ezy6uhh5e6/mebUNmJzEPHUeGXevymUIlabKeVR+Az1JkKMGr4+jMBzc6TSiapbTIiDkxm5k+78a11QfgJxduML4vkv94gHSW68ZZi/hcwEWNqwTgHOBRbMLf8EmBwMdWfp4BvKuul9cKtj0qH9mujVBDKi5uT2/9jspZY32UkBwGmRL6m2D6cFHGN7sihdLaUHTSh+wovCygyfAn+lrec52Fv454dAbBZ0+mUvslr74lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Mar 10, 2026 at 03:56:09PM +0100, Christian Brauner a écrit :
> In 28aaa9c39945 ("kthread: consolidate kthread exit paths to prevent use-after-free")
> we folded kthread_exit() into do_exit() when we fixed a nasty UAF bug.
> We left kthread_exit() around as an alias to do_exit(). Remove it
> completely.

Thanks for fixing that UAF! I unfortunately missed it.

> 
> Reported-by: Christian Loehle <christian.loehle@arm.com>
> Link: https://lore.kernel.org/1ff1bce2-8bb4-463c-a631-16e14f4ea7e2@arm.com
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs

