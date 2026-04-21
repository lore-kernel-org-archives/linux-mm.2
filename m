Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE841EA7184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 04:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7826B0088; Tue, 21 Apr 2026 00:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97EB6B0089; Tue, 21 Apr 2026 00:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86CB6B008A; Tue, 21 Apr 2026 00:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 965946B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:15:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 094295C712
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:15:22 +0000 (UTC)
X-FDA: 84681248484.11.4A822D1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id CE44440008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:15:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uS9iGCHG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=p7mef9cN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cpuTQ+E+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kOVwBphL;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776744920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYdfvAwxiyPMyDiaQbfwV8KtgdCe2VZI2NMXSwdaNgE=;
	b=SfEUDIas5IaOHDq9JguXZSp8a7TwFsZyMsJGK+ghdr5twGxYPz5PzJkIsiVTOUcXFKnztf
	VPsdCKtj2PKT2I4yf2WLqXKG0WeiP0cvxdahsH6/kK5Uw8k5S5JdNaZa3yfy+gYHdE3mJp
	gRvxTGv2nTrnu/r7kas9QO2dG8XhmEI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uS9iGCHG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=p7mef9cN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cpuTQ+E+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kOVwBphL;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776744920; a=rsa-sha256;
	cv=none;
	b=SWSscId14sIR/LXalrw1HB+2xzSVKCyER7corc82W3vnPoEG+2Dy6G8TksrPd1fWbwvpu8
	I4/ezBLDWf2U/tP+aaujq5UCmS/7Bl5LFPKHA7o+pLJq0k0M6daWHJ9L5pFemPzDtPKzRg
	L0SaOiMYZHeoYgB6K/h/aXXE426x8Nc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 081445BCDE;
	Tue, 21 Apr 2026 04:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776744918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uYdfvAwxiyPMyDiaQbfwV8KtgdCe2VZI2NMXSwdaNgE=;
	b=uS9iGCHGvQBvNjSEu7edu6oNLt8+F8xuB14yELkLOpQXxsadBzPWYhYrLFMWJ5xeP4RXPy
	7fK1+lMia3dCqF6jVB1s2fI5UMUZ4ohsPgZkvCopOhhOIWKfQx1tcb/zHmuP0a+DFD3yyP
	qXGIELXY2L6XxYIpuhKHMEqYU5b2gkg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776744918;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uYdfvAwxiyPMyDiaQbfwV8KtgdCe2VZI2NMXSwdaNgE=;
	b=p7mef9cNPGGWOlV5QoGVD8FI4gSIyoIfKK84yBtIOL5JQayGTZOAicEdBbzu9La5ub8ohx
	jo5vIKxwS5L9X5Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776744917; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uYdfvAwxiyPMyDiaQbfwV8KtgdCe2VZI2NMXSwdaNgE=;
	b=cpuTQ+E+r7kTV8su6DV45tSpkDqiqAmOUrQLPENj4/AZz9HS4NLvUWR3OHW35ULaAeCxPE
	oKRpodFPNyB6j0ipMhOXQ0/Bh61IgyRSZRnHDMqfwsuXp+Gv5FHQve2aC+hX2NAwU7nI9c
	StPlzoQgu0KV8rWMEml9gGVzcJwxZw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776744917;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uYdfvAwxiyPMyDiaQbfwV8KtgdCe2VZI2NMXSwdaNgE=;
	b=kOVwBphL1mwqz+a1WqHY8SR63zj4AFkCC6JimPdReMUw2CHVWxLTudR1U48kpj8Zu/Dv7g
	209xASf4ob/zMYAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3596C593AF;
	Tue, 21 Apr 2026 04:15:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XgNfCtT55mlKcQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 21 Apr 2026 04:15:16 +0000
Date: Tue, 21 Apr 2026 06:15:14 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] mm/mm_init: Fix pageblock migratetype for
 ZONE_DEVICE compound pages
Message-ID: <aeb50jwoCBvgEnec@localhost.localdomain>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
 <20260421022044.1217503-5-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421022044.1217503-5-songmuchun@bytedance.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CE44440008
X-Stat-Signature: 5z6xizoia8empbb1o1tt8j17katwbekq
X-Rspam-User: 
X-HE-Tag: 1776744919-289563
X-HE-Meta: U2FsdGVkX19FzivgJYHgHhEHtbG+QAckR3vlsbL/Zf2FVf4PHBZ+VuLMbvKPB4W8sp4zl1DE42q/TzBPJIUxA9M2sB7tHbzS1aYUZsk8hBDxicG+g2hJ5GU4nt7qwf4qjyHA6lIxIKpgGTLXgc7TLwjCjl2UwFrDj0+nJu0F0V9mnXcHyDLtyHbGmmmFFIBKFzdIsM09usnTfas5igE+UdiGKQbch2cCYyAuvXpkvxzRiVWd61T5Q/b8VD8fYkyQZ41HpVBjWilkh+hVW0QIfPYM145p+TC3I7L9kN0lgeGpOrWBKMMOeJbrbHIB6Hx979rSZ193G2h1fhTHulZTeAQGLN6rdCS15Sfj+yBTDFBPEnLfHdwyBAGRQfcbaQOVRp4aC0MicOeU5/1L5pHU4j/CG+V8QD2WjqvQxeUNtmX4DKWmMYhK1YIWs4j9qZHd9vGbnoNI7eD8rEHPxCkdNZ2SPIqyuqMzthKt7WhVgEk2bW8oFhK5oHD5WMay9xvJD5YS1JVn6TdBNwYmwV/3mGqz+EdA3OZsxPkig+aqBLYz6Vv/u3zEx10JGbC2bi4D97WYJuQ2Czv7anov9Qf0LOIoycImpQRJRjGIUox8XhChK7pdWTuh49Uj6wSwTtsnI02sMuweJ5jva3BsJW5ucOFTbnp/SUYSY1dOCaPa96ceqts0qseFEOjlxDxMfxKckSLPYYbHfskT3Msy6dyByj/OOMwntobKOU8KxzxHeYY4sN0i/7b2wAbvaYWZFn5mGpD/uNYc48XeRpNvzu1+ouj9idas40v9k5QVKhEXf1IKDfV29zy+Wt9nxHJ/SpaRBqE31Zfbi3NmVjxA0RLtg1Siw0SrHealOU14SUYsfAmwhNKJKOAHE9keofgJypG86sBhIIy8AQXablAZKBmae773XXHlUtxDod8fJi7lf11FDyl27iNgoJ2knuvVHzHPGbUkyg5aMtEHBH/vYbb
 VQBkOjcM
 CBCRcHuQXdppLoXLD+coVsh1L5U0ZInxldaNi3VtFaKp8dvnujW2hYUdQAlK1ZEdRMZuLuLhHEmY7H+ejthOZIA5RxIHGnBm9kdkQ8B2jDeNETByoM2VfPwzaeSE2ns93DbrGkvC69kvIpWl//7cQaLZkeH5GGnkKYfDnJo68xP8dPW2im2mTuvFEPpIVHTwIE+ygA9Flup9nWw26j5J/SNHJr5bDmk7PjehkQrScYjlnl6rLXVPr8oV/3WlLZLiBoJNjvJiHgveBj1Z5GO2yCVXKyNHg6+n4OGKb9IP4mqmXMcs0zYn+Os2pHPXX2VFCeFsXbI2w0uw0LhUz2GL7lampK7KasEFEKAfIptQLIsuSJyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 10:20:44AM +0800, Muchun Song wrote:
> The memmap_init_zone_device() function only initializes the migratetype
> of the first pageblock of a compound page. If the compound page size
> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
> subsequent pageblocks in the compound page remain uninitialized.
> 
> Move the migratetype initialization out of __init_zone_device_page()
> and into a separate pageblock_migratetype_init_range() function. This
> iterates over the entire PFN range of the memory, ensuring that all
> pageblocks are correctly initialized.
> 
> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Would not the call to __init_zone_device_page() from
memmap_init_compound() take care of the subsequent pageblocks?

 

-- 
Oscar Salvador
SUSE Labs

