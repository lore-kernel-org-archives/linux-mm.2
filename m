Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2767DD1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82D0B6B00B3; Thu,  8 Jan 2026 12:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECE66B00B5; Thu,  8 Jan 2026 12:15:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72DA86B00B6; Thu,  8 Jan 2026 12:15:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1C36B00B3
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:15:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C38E1AE85
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:44 +0000 (UTC)
X-FDA: 84309448608.11.C3F6A73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8993418000F
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A9BRioOm;
	spf=pass (imf24.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+L4aGlUTHL//gaeiQHaRhPxMz3nCHcb14bPoyvKv68=;
	b=rSu4VYm4/ta2bWw4TvcSKzAc6+s74m90EgT8urOzlOKuLMY4G+f/2OQWUfIy/OWmw+IFim
	ypLOMVO2p3Q/KcEA4avACrBvGh0MpHJ6kQ9Pov8XW1twUxJ1aS6crK437dPQKTA9Ei4iw2
	jOXozTA/8oqVWjqtAq67cqNwcpclbRo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A9BRioOm;
	spf=pass (imf24.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892542; a=rsa-sha256;
	cv=none;
	b=S0v2pqrxnlUq+Xzns2IEI7qOLdGnZgtQlMOZPlyCNqEK8dk1YpYcn509RmMOxu00Zq5Sln
	rFExn3Slb6CyqFGpURsS2qhz09kFXL4md+L1SFe39OJqoxOnqWZPZ/NnfJZbTlNvPXQ+lA
	wfaUJ1XWS76IUfTv0kJ0E4yrcQJgV+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 09B5C6014C;
	Thu,  8 Jan 2026 17:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89616C2BCB2;
	Thu,  8 Jan 2026 17:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892541;
	bh=odztZpOUjdPpxpnVnhNo5G14j/5HFOW1Zpu+cMYj4mw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A9BRioOmXSEdRevGPU2umsDaGngTrbkSFKt8n+5010kaFbJb3XhoQBBbnRYpes7KH
	 9etMgBsH349DVH7lP6n7Twjkt9tCQv7EICUiBdLE/bXLDpfmENj1ridUABHwLSMdxj
	 uSjmQ2lCPwAwa5E0ZShmgomJu2iNw8rRtOTcbaUs7Gb1X6W5N9yKGpA+NsJxGYOE8S
	 B6OUt47Vg8ILGw9witmobk++jbuZCzOOgrYrpLQpxmRefyCdeLkpX95NCZMJ9nyoJY
	 muqWbQByN8NZldOnr9ExnxgNVfJjDVQz608JR31HmzXT7bM9Vk+aFbZ5H1g1dZxR9S
	 HgGy3xg+SBmfg==
Date: Thu, 8 Jan 2026 09:15:40 -0800
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marco Elver <elver@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 1/5] slab: Introduce kmalloc_obj() and family
Message-ID: <202601080912.F762F30B6@keescook>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-1-kees@kernel.org>
 <960729bb-0746-4709-a40c-2e254f963deb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960729bb-0746-4709-a40c-2e254f963deb@suse.cz>
X-Stat-Signature: kudahajwyfgkm3rehawhffofqteg8b31
X-Rspamd-Queue-Id: 8993418000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767892542-735479
X-HE-Meta: U2FsdGVkX1+iWHEnVb4h7Gg/uE4IohUJJm0+3WXbJQmRelJarKVHratojIPvhp2XlFQEugOmjb//Tw1TswEAI003mv3WbkvJ89hVAkeYWQji4s7ta2JNBwogCeQvFy9x7r7Lm3MufCWDwaG1m0qtef01uqfq4MoNyeMYi0hQlqOgSSETdaNRkbWPKG9MB6Nh0OSopQ5Dz3UqIZkFt1wjpeWHIzS/QlDmQ1TDvXj1kh/dcqWTLLNyu1CpHfz2RRsCI3oT8NbaUWb3WL9o7JXOl9w1Td0BHTkvblvgCZxXNFEvwdQO19NlHSbdyjogMe8BydltMp2tc4TkWYVxyFSeI//Uz8kDvnrNrFSVBqW/bMMXWZGoFIX6es+VxPFUw7gX65xgAstROJ/oyejhEhCH/OVBexyECNvdzz/Dqdub4gh+K0X2ehcIwzJJJye3b2WKQg7WX+uLy2SPLuY6T8XXjwtE/mdEZ4We56QlFMlaIelZFWZGctyTH9DF7oqwnj+5gdPuLfu675A7t52HZ9eXp9kNjNGglz2W2IjUFCUXClNc0PpHqJnbR+DI4rAWj5lfQl+j/JJecti88QU6uRbKfTAvz9llXGREog08fpVbiK6Aku4C/p3SgdlAFGgOeVQw8FHS9yZZHDO6arge1jLmzmOYJMixSJTLpLsoGANUMm7sz6A6XizmsQHsryThEg+idqTEIWN4NIWG1dblSA8/AUByG9qtzRwl8CWp6Ybq9H8q/dCXqHx5MJer9geUVqFOOA7z75uOEyxDM0Dhx51VBXMtZahazGZvWES8Ebo13s5nrmUtZ91jkMNeM+NNfu4ONL4NxJIfrwa/D8P3+zI50u+IvI6a0CMYOpvAxRs2MgRa/5lIB7Rlm3mjIRS2M7TQTOfkvpiDsRXJ6MqCCQINAcccI3SwrZ18JsYbLaoT5C5u1CDnq4+Bo6teczTkdLf4Y5H1GVzHQl+MeNZ1zuV
 g5wleii2
 Tj90ds9ACfCP+E12p2BoyW/Wd5fbfFGmeb4rhAfEki5sQhY/nugyLtyx8BgV8a9mZX4hxSL+9mwQVhPkOgofWjXB2ZAr2QdR9peshtlR96SCKpBPcIqm6/E+31WG4KZKbkdfRFeWijUio4nDQDrdOwlR7mjWi96teyHef08x4G4liMbdZM1KaQFJYOk1kZuk6TEkIv+fplppzbI23FUPXAgWCn4A2/Zmpq3y20O7H939pACtwLTIcpAmSAX4G3Brl/IPAya51okNzZCHrSMVPwpfK4HOD5Yqt83RMcd/qnlrIipfST4Gz2Hwvd3VU/Wc51mNYHpgN3ebQ1q4fY3iD9se2lBGs1XB2PjwnaU/pbCXue2djwoFVzrPvaONLaLLZOU4JR0P+wkJ5Am4RSynwk7yaHOePjgTnqNYPW32FtTeqRJ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 03:01:00PM +0100, Vlastimil Babka wrote:
> On 12/4/25 00:30, Kees Cook wrote:
> > Introduce type-aware kmalloc-family helpers to replace the common
> > idioms for single object and arrays of objects allocation:
> > 
> > 	ptr = kmalloc(sizeof(*ptr), gfp);
> > 	ptr = kmalloc(sizeof(struct some_obj_name), gfp);
> > 	ptr = kzalloc(sizeof(*ptr), gfp);
> > 	ptr = kmalloc_array(count, sizeof(*ptr), gfp);
> > 	ptr = kcalloc(count, sizeof(*ptr), gfp);
> > 
> > These become, respectively:
> > 
> > 	ptr = kmalloc_obj(*ptr, gfp);
> > 	ptr = kmalloc_obj(*ptr, gfp);
> > 	ptr = kzalloc_obj(*ptr, gfp);
> > 	ptr = kmalloc_objs(*ptr, count, gfp);
> > 	ptr = kzalloc_objs(*ptr, count, gfp);
> > 
> > Beyond the other benefits outlined below, the primary ergonomic benefit
> > is the elimination of needing "sizeof" nor the type name, and the
> > enforcement of assignment types (they do not return "void *", but rather
> > a pointer to the type of the first argument). The type name _can_ be
> > used, though, in the case where an assignment is indirect (e.g. via
> > "return"). This additionally allows[1] variables to be declared via
> > __auto_type:
> > 
> > 	__auto_type ptr = kmalloc_obj(struct foo, gfp);
> > 
> > Internal introspection of the allocated type now becomes possible,
> > allowing for future alignment-aware choices to be made by the allocator
> > and future hardening work that can be type sensitive. For example,
> > adding __alignof(*ptr) as an argument to the internal allocators so that
> > appropriate/efficient alignment choices can be made, or being able to
> > correctly choose per-allocation offset randomization within a bucket
> > that does not break alignment requirements.
> > 
> > Link: https://lore.kernel.org/all/CAHk-=wiCOTW5UftUrAnvJkr6769D29tF7Of79gUjdQHS_TkF5A@mail.gmail.com/ [1]
> > Signed-off-by: Kees Cook <kees@kernel.org>
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> 
> How do you plan to handle this series? Given minimal slab changes (just
> wrappers) but there being also changes elsewhere, want to use your hardening
> tree? I wouldn't mind.

Ah! Sure, yeah, I can take it. Thanks for the Ack. I'll get it into
-next and refresh the treewide changes.

-Kees

-- 
Kees Cook

