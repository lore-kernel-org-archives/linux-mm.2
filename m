Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A31CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 22:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C96D6B009A; Tue, 19 Aug 2025 18:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A636B009B; Tue, 19 Aug 2025 18:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FDD6B009C; Tue, 19 Aug 2025 18:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76B056B009A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:52:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18AE7137EB8
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:52:29 +0000 (UTC)
X-FDA: 83795007618.06.3206E1B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf30.hostedemail.com (Postfix) with ESMTP id 69CC380005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:52:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VRxHnEG0;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755643947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PG0VeoggKm2w4264coKnqrqWlWs1St8bPFaqho/N+iU=;
	b=8dPS4v5a/wcSnl9iyOroF6buW+nvs1tZWW+hRWOxRf6JDmxTKBXVNP6CCm+el3rGTASP9P
	czMMj1N4hQmz3OEvPNtZHacsdNbTQ3RzOSYKIdywuX1jcD9HWIE4tGbWU6pwwRsuiGZUeO
	Mef5jCHOOGy559gZb+wXbGCbg/uBRYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755643947; a=rsa-sha256;
	cv=none;
	b=nQ4NLxXPlKq2HMvZ/6PjLTjRiJBEOX9PgwPCS9jFUo0ZEqUsLL7p7/Mc0j7x4+kN3WhSQD
	HukXfuyTsnIPkstgdTvKf3KMSC4P0v/P2RGt1rdn+/DcRCQ4x31mmQFLscN8QqxkJzi36O
	gz8KqFgSswQ0T9GZyqCR/7/vaD4uZuQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VRxHnEG0;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 2ACA35C54FB;
	Tue, 19 Aug 2025 22:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F330CC4CEF1;
	Tue, 19 Aug 2025 22:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755643945;
	bh=VHQSLjKvrE7HNYDGcF9hXuERvtRcIH2r8IoBLnp3tGI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VRxHnEG0v+ow/6aDnDx9elsJSvUiowJJ8lN6T/rQnlpoiVhnpwkQciMdIi1zv7RGi
	 JjRDJ+b5lNRiClIOfVFV9zJEGb4tyLGmOugHSddO5s/H/Xv/WdbI/U9GjhEUmqdAYU
	 IYxp75U+ahWCvfr+9L94JLCV8JuGzpMCyjjDGXrA=
Date: Tue, 19 Aug 2025 15:52:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, Shuah Khan
 <shuah@kernel.org>, kernel@collabora.com
Subject: Re: [PATCH v2 4/8] selftests/mm: Add -Wunused family of flags
Message-Id: <20250819155224.23fe3d79896e269bd9e27d04@linux-foundation.org>
In-Reply-To: <57c816d6-a9ba-47c9-8f40-3978580b7f67@arm.com>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
	<20250731160132.1795351-5-usama.anjum@collabora.com>
	<57c816d6-a9ba-47c9-8f40-3978580b7f67@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 69CC380005
X-Stat-Signature: y5s3yf7dgajim8i6yeueag6jkc8njoms
X-HE-Tag: 1755643947-24531
X-HE-Meta: U2FsdGVkX1+nMQeWhDkZeNDxtQyh3iWXqLyE+Kl3ARYZzpdmlEfvMS0QLxeHfdlVS7ZlbHV4jnplfmyt+4ErcgmU0F6DPW6lwC2QCdTxNPc4LRZJ9EesXpZh6CI0m125IpyjagSBF8DPGVmztv6zCDYy1fJfqLcMfwYdCvLLepuYIrQoX4787ktjGkLtT59TH7OqPlNDyj5fuezTadden4E6a8BaZdWR7HLpTUqS/gzTC+kcJo9At/yXvWHR2vnWgphaDqWkenfoOEb/yNwAPgM55IjS/nK7JABfYSpUF25PH3GsGB0oiF+HHkpDc9XlTj5VIpDMkCE6H9mRHrB/j0RQd3gl3cHeU5VLDTyl7a+dMe9rwTtwSUVPpqFbLlmBWiJ2E0FzxD+ah5/Tn87adwc6rVmhCxB1crviZZXKx0/mu/iAiv74mr5g8Me5UAVhAd/Om7fvNxNjU+EpaEJ7w6WKSIli8WI8yFsDWUozJe33lvR/p9YJsXLxKwIIYlvV4nGo0WQEKRy01yPnmuXGcbYxjiX7h6hfbNcuSz5a76P0SOvkSVix3eieS5YjzUk7aU3SyZTRiQ/SsoA/Pn79H7XaAc9g1xcCEj3NVrmOUw7NTkP3kKqyGs+7bgwEnULvvPHxYXjM4KymB8uS96o3P7N4Qm7CkOmg9XUynHdjc8sXxyYNJG3YxrRCNDaz4vGQ6K8Rw3rh6L71zCAn3xH917ZWxck3QyC2VHtRKZZ0qDER1LCVygL1VQXQZtgjZY/CXrguZISg6xnRYx2Y2gP8GO1oOkd6+QYSNOIQJ75B8G4XfNOKeFGT06AYcFvH7XwV3onI7Lb0bKgzfpEm8ZLtVdjYX4SlYLRKB2CsnVFzN/y+Hxe4srtMVZp3JPZY/vZiRKqQ/qmK+iFKtzuNtZ3ke+a91Tddi6CaeM/oZ9oOujHW5vAsV5HEubn9Mi9M6V2UScakqxgwphmp9Hu3e0R
 R56A528w
 hXSCjs8iJzQ2z1UpR63j8Z43XjvefCbmPp9U2TrBgJu9CGfjykl5i1AxTJloAf5kipRikQOKRRxDnQtnoO2/TzgzSJ1iyOkJk+4xmQBKcZ2HkVqRP8R0lg2ePwJTJb6mc8s2soycT+XsrUoWVYBdiS1KYIcx+lv1uFEIeATlgVrRh4YPpJFls6VrMOr7SWJiGFBJ+aW9jP0G8BG6AmK31opfQGKxdQu6dHQMRSaMuHz48qrle3U+FvEJVl2Mrcy6q6ZnuwqG8P+amRUozLQMaVXjfVQr7j5sz0Je1y+G9kxLtczhtIG/WHHx8ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 10:16:35 +0200 Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> >  # Avoid accidental wrong builds, due to built-in rules working just a little
> >  # bit too well--but not quite as well as required for our situation here.
> >  #
> > @@ -35,6 +34,7 @@ MAKEFLAGS += --no-builtin-rules
> >  
> >  CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
> >  CFLAGS += -Wunreachable-code
> > +CFLAGS += -Wunused  -Wunused-parameter -Wunused-function -Wunused-label -Wunused-variable -Wunused-value
> 
> -Wall implies all of these except -Wunused-parameter (at least according
> to gcc(1)).
> 
> As to -Wunused-parameter I am frankly not convinced it's worth the
> hassle. We're getting 90 lines changed in patch 6-8 just to mark
> parameters as unused, in other words noise to keep the compiler happy.
> It is not enabled by default in the kernel proper precisely because it
> is so noisy when callbacks are involved.

Yeah, we rely upon unused parameters in a million places:

#else
static inline void some_stub_function(type1 arg2, type2 arg2)
{
}
#endif

