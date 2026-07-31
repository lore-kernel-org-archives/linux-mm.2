Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B0EC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 13:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39EF6B008C; Fri, 31 Jul 2026 09:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11B66B0092; Fri, 31 Jul 2026 09:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28106B0093; Fri, 31 Jul 2026 09:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E02A6B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:19:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F294403B5
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:19:34 +0000 (UTC)
X-FDA: 85049128668.04.60429B8
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8DB59A0008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:19:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=aQDSykJ9;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785503972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozj+azE2WMAic6md6kpz5inr7tjqcL2PUGO5bai+aX0=;
	b=lFtnodeVdNvZeMmYiEzAUTER+TYlKBFFVWceShtmXo0+3k4Gk5EYtPBhf3UFG/NIr1TJqB
	Ac1V1JoeZ7qCdMapfqKM6fTJ2duuyRxSHP4+pEcWlMRu0dNm/4HPtiVoOxJ7bOgOUG6SMz
	Xk3o2B/S6cX0T9hGbtwj77kt6CU5qxk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=aQDSykJ9;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785503972;
	b=2jywzUccBYPCHrlAb/v/2PvPKzPwarQTSlY8krNOvQSJR4zON0sNOeV2/h4+1kGKZd8ETd
	5+75DsJtwrhBlgzTix/WPr4lmqGgDYTqSvvH3a8tJDba6qbWFy2djV7qK/K8QBoc4pZxnz
	nt3wg/FVWPct8LI1xQYw13xx/Rg9DaY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ozj+azE2WMAic6md6kpz5inr7tjqcL2PUGO5bai+aX0=; b=aQDSykJ9iT8w8kZVB0r7hPlEYY
	+QYMtbW/SO3mjA7PLH1BAUTc/Madc6281vzWxlV83jB1fYi431eKbSK4gIc/u6KFRIy9V6vYb6rtm
	tcAkdQfeTvkG33j0UuYOUJK+3Mzs8LgAnqxvG+44MxN2TVs1uxuNwmpmhYv9icMy9qYMzMpdTDkhd
	VbC3OQLf9CVtr8KYez6WnSvD3XsmtBtu9dc3CVyms/jpr1pmIi9pG2ud538T/lnZX0UD3vUGruw9l
	Pr4Je6WjpoZl0FkbQRn37HV9/JQMKNrghDRJXHsaZRS2bitl1E4YC59SvbEOCMXnp4mYxVunq+YBi
	X52rfNMA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpn94-00A2YM-0r;
	Fri, 31 Jul 2026 13:19:26 +0000
Date: Fri, 31 Jul 2026 06:19:20 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
Message-ID: <amygM1INCTEoYY2Y@gmail.com>
References: <de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
 <amh1nZVVaaZSGD3M@gmail.com>
 <20260728122016.30752d36c3b3c3af231efa9d@linux-foundation.org>
 <44f81bea-d64a-4f73-8665-46652a928c83@kernel.org>
 <amkn21ftNme48Vbl@gmail.com>
 <f83d5b26-b369-489b-a305-1eb5ec6fccfb@kernel.org>
 <amm72Bu9qmWLI-9b@gmail.com>
 <d0d62d7d-8701-4692-89b9-84dff71a7cf0@kernel.org>
 <amnTfwagJQpEY_21@gmail.com>
 <2e1ca7be-ce73-4146-95fe-d8cff4da9494@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e1ca7be-ce73-4146-95fe-d8cff4da9494@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8DB59A0008
X-Stat-Signature: cb3fhwjz67rh1ztuwtk3g4m9gmotiy14
X-HE-Tag: 1785503972-625757
X-HE-Meta: U2FsdGVkX1+BsJ+0XS1E22Fmb0NB4reSDLy5oUg6hpB5y+EvhH4YIqhZcXBHiyYvR2phmNMbyyKiAGTjWpUfeZ02ZwIBhKyOFsMoVNA1OyeXwiM1ZLpRkUc8a+W7z36zy2WBuvbjiR0yrqnGuCpk0xNsy6U7AR4P7O/GmKlyHsr/BuFrGxkXbsqD7TPyX3dEEhfIxJGBMtbFTTxom9WGV0tzWjEw6FnH0xmCnSgeEU3O4XjkAVajwiQz8wGMYdv/q6YcrsYqpcqiqys3NaVFGfQ/ZuXPCGYaod9fYqPI/0wIvM4GVkEjFVdJUL5C1AIkE4GBpi/oM3/Rixnq4FnpxK2TFSNQ/vlEtechQ83IFBb9vkA81cEbpOwAyUzxM09sw+wNm6Q13BkuGiAb5JkPFm8PTYm19+0Pdelo7rmNO5twFMvWl2pLZ/KvmZS49acNxgcZOf89OPUTq3wxFaf4iba9CfTGz3zrgJzyYI2xoXX4UcOvL+TxahF3gptXaHbPejdnhIvmVNi3ojB/dKrTHdxc4FeQhaf+kZZ0tPpJvcW6sKKpIzZfG8pkQigFeadfNKY75nKFSaIC9kaTFDzIYCidtEVxzMrkR/Drh46rhZjmON6i3YyGs/HA/w2S4Y1M/wNrlIMmI5iYZlHSaK0RHSPVDvW7GDV6IUrnD3OLIkJ1hg7CuuSZDN3ggzAAUrj/qztcy2QYl4epcS+ncvjekim/U1IlpuytdQq5tRs1FT6hRsa3gWl9V3FGmbqT2YnFrJBQbBHG3uajDiBLNS+W9AqlkaUySWpRqBcUEmkz0tLFNRnC18ZQ8VEUFu8oRPUaLMkCogWYBHRIBROXmxjMcWYDxYoCrCoc72JeeWpv02FuYctlxSY6FiANnNjYqaW3UCE7SDm46B+UqUpQ2vJFuVtxbK2ayuuwYH7A5b1IDzztyCxsD2uU0zXQGaSFW5X1W3QGlui86kQ/Zm+UMrr
 U6Zm1s5d
 1mOCEvhGIhnJmqSm5pYeIrx3FZxr4dcRwNa24iO2NlHL5wEL+SVZeyw/G+uDmzrK2g7facuBgf9rnFdiL4ZE/pA8rjQb+Cf+lOe3IFcLnrUT0BcafBH48KYrcZLzt8IDgokUTuz1juuSfGHiHgUCTEcBorzTCsWhGW7CJck1rmSHfewpwFgkVmujcg2nEeqvsKbyxQCdz91P3u4YaTINmjw/0WxswpBhwF7+ma1UlCeNw22wIhNWJU4ALl8nmhZUMv/EaA/IWH5Iwo92hYRarVfthxWRDclQIuXS01x9xZ3AHloP2et2co+/ujglosxYIdP4GRNDCr3nRkfnM77KnVDONnXdzn1NmuIvFvT8HK3U1ItQVQLdzkv1pfNMKH7djbW+rxxjtIRss1Z2tO+bX4r+AVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 01:11:36PM +0200, David Hildenbrand (Arm) wrote:
> On 7/29/26 12:21, Breno Leitao wrote:
> > On Wed, Jul 29, 2026 at 11:09:11AM +0200, David Hildenbrand (Arm) wrote:
> >> Avoid bash scripts, please :)
> > 
> > Sorry, I will try to control my fingers next time.
> > 
> > Jokes aside, all the selftests I maintain
> > (tools/testing/selftests/drivers/net/netconsole) were done in bash, so,
> > I got totally biased.
> 
> Ah, I see. The MM folks are not known to be bash experts, which is why we limit
> our bash scripts to a bare minimum (and focus on C tests).

Thanks for the guidance. I've rewritten the test in C and posted it:

https://lore.kernel.org/all/20260731-memory_failure_rewrite_test-v1-1-6aa8c6435693@debian.org/

