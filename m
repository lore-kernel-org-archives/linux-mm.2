Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E00BCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41A89001F8; Thu, 14 Aug 2025 21:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2039001D5; Thu, 14 Aug 2025 21:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B303A9001F8; Thu, 14 Aug 2025 21:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A272D9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:11:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 676CDBBA00
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:11:05 +0000 (UTC)
X-FDA: 83777212890.27.A22D7E3
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id B43DC140003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:11:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="fL2nFq9/";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755220263; a=rsa-sha256;
	cv=none;
	b=AVMKNIs2022wsAFOx/iIKgEbfpbkg3XaGH2/fB0yBL47utdfghSIHk5F6WUxFTaMxDi7yp
	DlfzcZoLLkq+j2IXsOhUGsMB17LcegWty8RdcHJEoeT0pd/iL+tZadSJrbHFLuWDI1ZJoa
	B9dcN5rMlovdZTbN9tpg6yID+zl8ArY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="fL2nFq9/";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755220263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Vp8GbMnqaWewiAEbS11ErejRWv4JkuFpfnK8maBMok=;
	b=M/RhA+oTXGeFa1/jSaP/VUpsCLOw74hF1dj9eYRZWfpnPJDTzNlUIkBNSUX6y7ReR+Mb6n
	R0zJzi6Bh/klq1lwTlLgeolMdjglePvsADGj4x/kKaVUdQirrTJPvmy0ogOet25QVoXgHZ
	BefGedU0THsknLWQIeOMJ28aweOOjw4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id AF83E5C5C3A;
	Fri, 15 Aug 2025 01:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968F4C4CEED;
	Fri, 15 Aug 2025 01:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755220262;
	bh=z73WFDouE2luwIWEwjVYjCE/sTdxrrTGRHZK09LdMMs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fL2nFq9/PNhIEwgZ2UQpPTz8+BNrFJncGrTSd+kKDGTwjmqVBezRlwLIoECD1R/qm
	 1h4wRYhhdy1BwSgucdu6Ws+cimUwZTmWXpbFwq5qVrcqwEYk3R2BirDLs6bknNQNUN
	 DOfp5foSBJH7D2JMfVko+PD2qPbVc++rqmCmIe4c=
Date: Thu, 14 Aug 2025 18:11:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
 ziy@nvidia.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com, Arnd Bergmann
 <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 2/7] mm/huge_memory: convert "tva_flags" to
 "enum tva_type"
Message-Id: <20250814181101.9e15c8c0202face2230ad1fb@linux-foundation.org>
In-Reply-To: <c8a47a7d-3810-426f-a2cf-7c020ce25c7d@gmail.com>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
	<20250813135642.1986480-3-usamaarif642@gmail.com>
	<CALOAHbAe9Rbb2iC3Vnw29jxHEQiWA83jw72fb_CQKGDFHv6+FQ@mail.gmail.com>
	<c8a47a7d-3810-426f-a2cf-7c020ce25c7d@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B43DC140003
X-Stat-Signature: 56q3g9h6ob3yafcz3j3giywrw49f1s99
X-HE-Tag: 1755220263-782913
X-HE-Meta: U2FsdGVkX19TSINRXxJtyXM8fZVVTebh1CooyJHCPEgK4iVQnP2kc0o8LfzbiU/yO5L+3ahhDm8q/LOzdS4n7LOC8RJnO7UT0TOD2hBXvPD+UP+SS5QKNTL54Tk+QwC14+irjCEeXCYXK72cwhvIzo3a80Ul6ZAjYxcW/Kfuh1b0wew4IZd2xk/OuTmQqx7wKEXV5CRp44FXuIv8HPQNSWm0okJJkjtseJjLd6w8FBS9r6BOnd206V1yw2OQfoAimgS3i5sNDiFOZ3ImhOle24w6WDOspMw/9jSPNgj1KjyrE0LaTEMoeJL0TvN3BKVEp5IP77YTNEY1Pvh8CrhFn6d5ndHjPiDWeGDNk9q+9InOm1QFHo1vGvT8MMrgdzzhgtcjUo0kLDkMN4buHoosNx1ldOcJZwNrMy73vtRWxr2DT52HxupnKpkHJ+EzWXQJwfNcf2pp0VzwhoOiLCyTEL2RN7XGw5eLNpbhMm+aiX0fz+lEin75h7aYtpJGXeoCUZZkmlQaKZFWkWplYhI6Mi0W5wppYN0NMixcfGeBxVEVeZqeX33GW1o9X0uWqOcu6vHvLIEGsfgpv17YEDqcE1biQItVRPNJL6gyQ2Ez8qHKdC+/YuPF6//2a0wQ+Aa/KE+1DsNswOeom8bHaTgPAcTku6eNJhkAo7Fl8i8KFKICH4pcS6t35t3ALmSR09ueamTxiAygngFI9AtN6YCT7nOcW2f+oryO2Jtyvnw7Pr/tlGiPqPGc5QlkHQlUMGB3MLmm3I8L+AsvFPEfVWS/NoUefDVWD4yshndzuT9euH4/ohJFc0RNvH4Z4LTXb8sUmhS1D25jIbzmozsrtr6Ila+K7mKSYdpC8VmP1dbgeawLbHX9Zz7AQQgw4QTufdyqI6NoZc6dNLf1/j+eAWI9kV3M9bKL8ORLEedl2sEgH50VezFx0vpamfjZdW5oa6d4wsENsYdZTt31VETFf0+
 sPwg+Zwy
 DzRHBP5cfmACtyPAkvDuzGki/bWFGszrbgkUd6JmUeCSgY0E5KgQ6m/9YC3TN+30C/FDCap/PkVK4gXQ2fLGW+/VDfktTMcO0crQojLIgZ0JQTiIR+FqcLWCnNgsBkxCyA3j+QC0xmmlILJDn6ua6ImQurTFb6Y7WyDILp3zobd4TitxepnBHFHmeo/sgBfkcvO4Ts1bPOkmPIPcM33L+mWWFQ7dUZpcMtYjuL0QltjsGr4Pq1BCURcM42gM33b5tKgs+2k7rpV/+61qViu4cBhrtSKxUdF85QTnS66/rzgelHF3RD5TnQJZlnO37k+OMSEwBmWG0kZVJVvQOgi/jNgb0fHeEwQt/QI8epWvFewBV4dpQM5OkpqWDj6vpDu8gMb+jSy48TezX/44djN4GZuEQkM97uoGGQ2RRuqjMS52DwoMrMZj3r20uJk1b6SngI24Nt1Im031Md6tgk73z3VJHaZnVAeCf5cHY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 11:43:16 +0100 Usama Arif <usamaarif642@gmail.com> wrote:

> 
> 
> > Hello Usama,
> > 
> > This change is also required by my BPF-based THP order selection
> > series [0]. Since this patch appears to be independent of the series,
> > could we merge it first into mm-new or mm-everything if the series
> > itself won't be merged shortly?
> > 
> > Link: https://lwn.net/Articles/1031829/ [0]
> > 
> 
> Thanks for reviewing!
> 
> All of the patches in the series have several acks/reviews. Only a small change
> might be required in selftest, so hopefully the next revision is the last one.
> 
> Andrew - would it be ok to start including this entire series in the mm-new now?
> 

https://lkml.kernel.org/r/0879b2c9-3088-4f92-8d73-666493ec783a@gmail.com
led me to expect a v5 series?

