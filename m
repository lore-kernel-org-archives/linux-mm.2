Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90DA5CCD18A
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1EE38E001B; Mon, 13 Oct 2025 04:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7108E0002; Mon, 13 Oct 2025 04:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CA48E001B; Mon, 13 Oct 2025 04:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA23F8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:09:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A682FB7FFC
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:09:52 +0000 (UTC)
X-FDA: 83992367424.13.3AC3313
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6A95A16000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:09:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="TuqFy/NK";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DB+tZuxo;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="TuqFy/NK";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DB+tZuxo;
	spf=pass (imf08.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpX24lvqV7WFDDylZiXQr7peNkkr00zZ4SHlTRyubQ0=;
	b=cL3oraRJDiqe1ZcRzF1S4pWH6jsAdU+SwcWgaPSxVBqQlggNIVlK/QJ5uBkyDK2ocR3k0/
	M4o6XhN1Co+qHrhTR1I7lc3wb1D+iYBj2KK9yLEa/BMbFUedCZh0tIArxJLiwql7DZ3lph
	wz4sljGKJzysjvuh16h6nw1vA0ANj0o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="TuqFy/NK";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DB+tZuxo;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="TuqFy/NK";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DB+tZuxo;
	spf=pass (imf08.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342990; a=rsa-sha256;
	cv=none;
	b=TbwX/dqJpbzXad4Ewe5WOfiOMdMnTjY09KhOnvGkNzBbkEb6aDf4g32KFHPtlKUtXW4AcA
	k5RrXva7ok6iKt65ZFSSJ58zxLcryBqnDWROnPlvvYeO6oCpwAiev2wdvo9P5+vkjMN14v
	C4Vjg52r2yq0FRu/QEyeWBuszVCGpn8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B0F452122B;
	Mon, 13 Oct 2025 08:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mpX24lvqV7WFDDylZiXQr7peNkkr00zZ4SHlTRyubQ0=;
	b=TuqFy/NKSMlBhY54yA3qrMBpRcSFlcNTt8izqAemZxrstv5oAZdOPFaCUqyjhwXi7XTHnZ
	FL88B2rCk2NvT4gimbBukZi7x250pcP2xIuQ8fZuas+c8zIq0vFQKx7UzG4yb4v82sQOzp
	h0eqw3Wc23wfHq3MMvr9F3F47xe5p0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mpX24lvqV7WFDDylZiXQr7peNkkr00zZ4SHlTRyubQ0=;
	b=DB+tZuxoLCLj0jsrViySAGyPTmfJvtpxj0BMiDluFJXjHp0Df8DjuVUPNJ83vF18Rfzc/L
	IT/bGsqjU20EBICQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mpX24lvqV7WFDDylZiXQr7peNkkr00zZ4SHlTRyubQ0=;
	b=TuqFy/NKSMlBhY54yA3qrMBpRcSFlcNTt8izqAemZxrstv5oAZdOPFaCUqyjhwXi7XTHnZ
	FL88B2rCk2NvT4gimbBukZi7x250pcP2xIuQ8fZuas+c8zIq0vFQKx7UzG4yb4v82sQOzp
	h0eqw3Wc23wfHq3MMvr9F3F47xe5p0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mpX24lvqV7WFDDylZiXQr7peNkkr00zZ4SHlTRyubQ0=;
	b=DB+tZuxoLCLj0jsrViySAGyPTmfJvtpxj0BMiDluFJXjHp0Df8DjuVUPNJ83vF18Rfzc/L
	IT/bGsqjU20EBICQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D4BB13874;
	Mon, 13 Oct 2025 08:09:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +lpJDMyz7GiMHAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Oct 2025 08:09:48 +0000
Date: Mon, 13 Oct 2025 10:09:46 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: muchun.song@linux.dev, david@redhat.com, akpm@linux-foundation.org,
	broonie@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] hugetlbfs: check for shareable lock before calling
  huge_pmd_unshare()
Message-ID: <aOyzyt7irOiINLWq@localhost.localdomain>
References: <20251003174553.3078839-1-kartikey406@gmail.com>
 <20251008052759.469714-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008052759.469714-1-kartikey406@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6A95A16000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ufhnr6yaqpum4dhq8kmsz9hhoamsk65w
X-HE-Tag: 1760342990-420628
X-HE-Meta: U2FsdGVkX18nmpN8390183B3A5J5DiRTAjBlB/AtjaYRSXLLjp33hk4YKrtKrdLzbje8l2fxT5Xboqnf/q1/hX59eYCkXgMxpfBQNSTKrV/k07h9qR4MEX2iqHOCV6Go6+jFdkFwAdhaEOQ5GYEXJBgZReX1a/ibYAVmYPMR39dUCWFgStMtxIgayORr6+idyOVkjfRGhc3gHakJjJy7kWaeBs6hKj4Evq60dW5Nq1Px7mb8E90gINACP5J4P6qn6q9E2b2mq+NEcjrsrSy+uYW/u+FzbiaHkrgL405lyxehOmD86fSkX3ia9O9zuilpYDHK8/miLR532wncUhbMYvMOAOm18N4z3018VOKz2KJa6hEI81w2Kq/qphtdoowK+GKmSpfQ5/pf1G9UUVDKPglmMHS1XWgeqdpvigqaE5/gY7SO+D8eNKsVmF0C+vtQaYggp6Bf662w1WIqT9UiG9cMC5ZbJUmuLy4rWabw9ofpqgVIZra2Gd/gfNaVXfMrTHnWrOllvnegbshfmUkUKPsoLHxB0hv4XgkfHJmaXvMUVvrFc2cANkhTgmITCUSufJMVXq4FBntFBQ8Rdkd2BujxriJFEXOxoVtSA5CvDdpHgHZsPiYPPAcf4/m472yirng3/zwZz4O1e6FYDprcBJhNrK6D5KFrwe8YABAV+rLmxE1qWgDi30R9u6400pGJi/kbSDKDjFFWphyTEDZZHpv7FY2Fi9iGf57YN2kNKUfTBaXEcrHnHBDEE1jvzTdMhKugQsR/fWpS/1FONec/6giF25K4wF9pxx88f4GedDj700da51MTocpeIp/OUCcXUp5vwDwmtJU3OBK558rVjssXnOw07jHsa6eiMH2+PcgWJdNA8+IeqrU5YzKYmywjbWzhQZNrkT19ywxuEi53SFf0j3ETdoMvPDgu/piBcXtqKymOsM+Buq0YDkzWdRGUybqTudRskuH+FXL2Jvc
 sWW8ERLh
 Mw6lmwlgVSWfu01oaI2GsDMLtTrz1OiC7PHquqi3IwbRpUnH6dMAvHbm+V6YSyMwQ01aO9UgV3lzxV0aVmjOHccMTI/eMZ20WjN/eqNY1EYO4DLrXAkEUdbHm2DsPTPvGSLN/8uAj3m7RMv9caXj+VRp1f0KHaLRY2Dj/mra2wTAjsiVH4/We6j5ow5hmD2INPB8LLSc+6vYlF5EeeucuKRuaPaJbxVXSG6Dga9zThGoyYVwcPsUk7HILaI9g+5NPH2Az1Pj1xdUkhRG5cZqeTjTqrknFqxmCwEBJmz7GjzJWBE9hB5WfHQbW4BjNh+pm8FBViRCW46qm2l+lR3sIfNo8d58ld8sfE+ronqeor0ASy7sNJZGjeuURHFkeSDR5sG79MutVOtwxmZXcgMxO80inLs16Nzs9/VP0OQaGVXETpmpL3HPoER2nWTRUWlvGsN+WDNmrPdqe3cN9zmWvyTNgVnrdqtClyfI/hjtEugwYiY7pj70LZHya3s7eROl6lCToYnzsCx6tenKCB8rptETJQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 10:57:59AM +0530, Deepanshu Kartikey wrote:
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
> Instead of skipping VMAs or adding new flags, check __vma_shareable_lock()
> directly in __unmap_hugepage_range() right before calling huge_pmd_unshare().
> This ensures PMD unsharing only happens when the VMA has a shareable lock
> structure, while still allowing page unmapping and freeing to proceed for
> all VMAs.
> 
> Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Reported-by: Mark Brown <broonie@kernel.org>
> Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Link: https://lore.kernel.org/mm-commits/20250925203504.7BE02C4CEF7@smtp.kernel.org/ [v1]
> Link: https://lore.kernel.org/mm-commits/20250928185232.BEDB6C4CEF0@smtp.kernel.org/ [v2]
> Link: https://lore.kernel.org/linux-mm/20251003174553.3078839-1-kartikey406@gmail.com/ [v3]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

