Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242ECCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 18:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8509C8E00E9; Fri, 24 Oct 2025 14:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801388E00C9; Fri, 24 Oct 2025 14:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF858E00E9; Fri, 24 Oct 2025 14:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1338E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:13:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DA5A894FD
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:13:27 +0000 (UTC)
X-FDA: 84033805254.03.D82A6BB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id ABF4AC000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:13:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hbIFI5LZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HoPgPMuv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CIKXMe5+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lyh8gb1x;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761329605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6cajldIgDLiiisXFh5trizW5GaC58+xqdbWgMHBrLM=;
	b=Wk2gza0Q3I/QF/1RA3aKmf/HqvXbQzSaTiATulHdoLkOgkbhLeSN5XF0JjnUYICqQUbuS7
	mH2X6V+ChDT39gDYwr3fRx5Jeb1bWCj9Zan7oNQz8K5R5WMuhHQzMzRUCqgIeXBYt831BY
	nfYaJmu7QK49uY9KLCp97qjXi29LTkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761329605; a=rsa-sha256;
	cv=none;
	b=IXkvyTxtA05ygqXtTHncuRBQpv6mgcEb837zVfYky9KBDO0ptt4XZM5sEhJq2dHAEFLAbk
	aE1N5ZzLqrn4fl0vMqtp9cyGf8KkEkdG81+9Hkel3zRK2jPjKyx59bx9FO0xjNw4Dl1z2q
	xSzPqeiJUJoIbmwk9rkEJC0V9CmpbMg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hbIFI5LZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HoPgPMuv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CIKXMe5+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lyh8gb1x;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B49A1F388;
	Fri, 24 Oct 2025 18:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761329603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6cajldIgDLiiisXFh5trizW5GaC58+xqdbWgMHBrLM=;
	b=hbIFI5LZv1lGAMOm2ffsiYQbay9zZ40Y0coZ6IMcIsBNxRYBuIUWR/vWZ6qB0o3ah2bICX
	2v3Pq6b7MKYgGLmRJ+ltogSuEDH9B2PY1YtakeCXmYUmFVgKlLRgb4lwyBP08yYzLOpDMm
	bpsFavBzbfT6C5xxPwu2bfPGiHcEamc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761329603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6cajldIgDLiiisXFh5trizW5GaC58+xqdbWgMHBrLM=;
	b=HoPgPMuvFzy9l/lUOCIG3kHTtaYBCZCOdqhMuRitZ0dDm7F3ofE9Xl9fayLiBPzOHKDwly
	kUKRXSXaZfUMPZDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761329602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6cajldIgDLiiisXFh5trizW5GaC58+xqdbWgMHBrLM=;
	b=CIKXMe5+kzdth/2nItCfUAL5GBHYsuNe6FaXkNwZ/4cCe1s9ag6d//pG1HlUZYbfeqmroD
	CGF9nI1ow/6ojPAXkADHzV5fjaheXfLRrx4Rwz7+pZer7aEKzPyBACWxKlt9oT0xIQ01ut
	4rjrnIwj/6R4gvLfZ3q7tbJMKuS09sM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761329602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6cajldIgDLiiisXFh5trizW5GaC58+xqdbWgMHBrLM=;
	b=lyh8gb1xjLkkWko5itk0aQ5tG0sEkJ1dMouyKMYJNd6q+OpdiJut5pieJaKPhb7O2cwhE1
	fGwyQpnPLDVhW+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97D2013693;
	Fri, 24 Oct 2025 18:13:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xV1XIsHB+2hoGgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 24 Oct 2025 18:13:21 +0000
Date: Fri, 24 Oct 2025 20:13:15 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: muchun.song@linux.dev, david@redhat.com, akpm@linux-foundation.org,
	broonie@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v8] hugetlbfs: move lock assertions after early returns
 in huge_pmd_unshare()
Message-ID: <aPvBu5FIF7QpVhSB@localhost.localdomain>
References: <20251014113344.21194-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014113344.21194-1-kartikey406@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: ABF4AC000A
X-Rspamd-Server: rspam02
X-Stat-Signature: w3kx7iriztoswxh4y9mzhmx9spycd9i4
X-HE-Tag: 1761329604-460071
X-HE-Meta: U2FsdGVkX18fcRB1j9bWZpp+LvGkIH67GXeq0sPvgTgXsKTuVaQVU+FNui/6PtAVczP00wlbyiM1xdvhyfUFiP7J/DERJRDt2Np1/9fMSlFSJlqrwMnK8A176DBwdxYoTnpVZIpaU+QcLxxkLfsw5dYZp16qNhBOU1OL43iaB902cX440jC9LEUUv6SMrtI0M7/iuyUJzkrjEwxlob7j35KB/1KSZNab/iaue09fP7fvaOtyGY9W+dJjBhICF6Kiwkuw02xgOIvprsXmFfUnUVy5LLIsPEbdTSHIUTcc2nqs9nS+NzFu5GHzMCAMl6ugbb37kyu7WFEnllWaa91M2QSH6klbC1cH+ZtNyIJEyhb1oyg79wsTTr4WpEC0AIlFTcq+mjoRS8S7LFZXZJxxmWWk8dwtZ0HC+ul7jNTW9FA++QSqVosltKGATnnW5sItyxaV9r4MkMP5H1Tt40XZuB8jth7QEeHEQ1bEVCfbOGpLzblZ8uuJpntfCDO69byFYbGU3lJXtvVtaHH0e+EPzc+JKaHlPAEuIi/QnPzHyaVOsWuM03ec2Sqb5g2SqXYufq1FDBb2xe6PkA/l29l0RzzZ/JGdEmZG7JdPeWXopeEJspxxpdWjQVrADHq7lDJwrAdtHdDVtxjfuBSFL6vAQeyaCxM+8FBBcLH1Kz5b0kOZ/arRNE2GDngnlX0wroze6jd082NF5yWjygYe0ApsoT3TdcKWikCmf9jg8+kR6JZEQmcVHAc+beX9u9cfFpBdjQJiCeiLLk3aQvEBhhoXu7xUXhlrSsClRHJakn0e5MxTlaVtTtL13cgHycPGz9JrdwguAiwWh2sK5KNw6+jISH64GFp0qS6oXcxpQc/fp/l72GIQ4DrNcIW2MCH4Cyk63ZTqO/97tNWSFPAkArQ01i3/TVgwxO2n7qfVqc7HZY9MTxEWGA8UPPBJYAWKmnwW5rmEjWp83NAEDyEj+4i
 1GXeDEYu
 Y5g5J9fctTgRHO06/F9tbRjdvSE6/Sd6sG+n/mkZXK25erISc9l291Y+GEtoYf/m0lL9kjTNBEVCGC7l3gaFPU4oFPdaYSan/yWoHDRFClseX5rv31pIO7o7BE5QFr3jx56KXxK9YVkIX2WbqOxTzQ87nKSwHOX5fdfJCO8g1ohM2Q7ZVtquPaxjoBGuOJLrivuvD6X+AfGsNtSuMUoMgps6PMBpZ/JZZBk9yE6EwVp/X1SVy088PtvZiVlrmpobPaUGWz2/dcB3b7XGZ0hI7o33KO1aUaEVBKtYDwEBWc+bimc2iunwAFFoRf2B2OGBiSN3QQifeNUxSDXwjNuJD0lixRUgdNDRl6gmJ3l3CjrktJhZ5/lmagtruDpIkLuo2oZJ2tVKhpdVBUoF5J/F47J8NI1rKljqj6VT8jXnF7EyWC2pSvO/gw1PDsOLmj2/Zs+QkzKQwEOMyElrv1ulF/MUUEz22I8MbkVT5a3Fdv4tMTzA+yTnYLn1rnqzVF0sk9GfWQj907usSucqCqf++ta0vsSAkJ7sdza6NkYKRLKUoho61SVKuCrOoM4XORrk4ZvMtBawG4GiFoJ//fcJN86dkhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 05:03:44PM +0530, Deepanshu Kartikey wrote:
> When hugetlb_vmdelete_list() processes VMAs during truncate operations,
> it may encounter VMAs where huge_pmd_unshare() is called without the
> required shareable lock. This triggers an assertion failure in
> hugetlb_vma_assert_locked().
> 
> The previous fix in commit dd83609b8898 ("hugetlbfs: skip VMAs without
> shareable locks in hugetlb_vmdelete_list") skipped entire VMAs without
> shareable locks to avoid the assertion. However, this prevented pages
> from being unmapped and freed, causing a regression in fallocate(PUNCH_HOLE)
> operations where pages were not freed immediately, as reported by Mark Brown.
> 
> Instead of checking locks in the caller or skipping VMAs, move the lock
> assertions in huge_pmd_unshare() to after the early return checks. The
> assertions are only needed when actual PMD unsharing work will be performed.
> If the function returns early because sz != PMD_SIZE or the PMD is not
> shared, no locks are required and assertions should not fire.
> 
> This approach reverts the VMA skipping logic from commit dd83609b8898
> ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
> while moving the assertions to avoid the assertion failure, keeping all the
> logic within huge_pmd_unshare() itself and allowing page unmapping and
> freeing to proceed for all VMAs.
> 
> Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Reported-by: Mark Brown <broonie@kernel.org>
> Closes: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
> Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/mm-commits/20250925203504.7BE02C4CEF7@smtp.kernel.org/ [v1]
> Link: https://lore.kernel.org/mm-commits/20250928185232.BEDB6C4CEF0@smtp.kernel.org/ [v2]
> Link: https://lore.kernel.org/linux-mm/20251003174553.3078839-1-kartikey406@gmail.com/ [v3]
> Link: https://lore.kernel.org/linux-mm/20251008052759.469714-1-kartikey406@gmail.com/ [v4]
> Link: https://lore.kernel.org/linux-mm/CADhLXY72yEVDjXWfxBUXfXhNfb8MWqwJmcb1daEHmDeFW+DRGw@mail.gmail.com/ [v5]
> Link: https://lore.kernel.org/linux-mm/e6bb05f7-8f05-409f-9d87-2d25f66942a9@redhat.com/ [v6]
> Link: https://lore.kernel.org/linux-mm/CADhLXY4WPxzvzuiZPJmhS-9xMqRZ_qf7ZcFf5MXPgXbgB3_Xzg@mail.gmail.com/ [v7]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

I got lost in the flow of multiple patches:

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

