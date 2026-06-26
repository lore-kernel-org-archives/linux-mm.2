Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69EC2C43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492306B0095; Fri, 26 Jun 2026 11:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442CC6B0098; Fri, 26 Jun 2026 11:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A1C6B0099; Fri, 26 Jun 2026 11:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA0B36B0095
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:05:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5ABE1C2399
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:05:03 +0000 (UTC)
X-FDA: 84922386486.08.145AD84
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7DEEFC0015
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:05:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ka0GYafl;
	spf=pass (imf28.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782486301;
	b=KTqfRVKYMKJpjV4SeyrmmCOcCynkOiGOSY0ahe0RSldWBwstvOxENt+i9uAnv905PZyhSy
	iD8ylcNekIO6XLVBoE4n+DK9PaGl9wDvffz0lb+xeGpAWRJAFBeM6sjycJZWD/uioYG7kX
	ZArjH0Wr4a8//bCWVjSwGr7bQP65g+Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782486301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/3t6es/Sh5NFgNAr92B/NG50RTxtozIvYYF+FgF2iA=;
	b=lCc7tyCPuEDsWU3zOHEeFgfvFstCZLIeJ5+rtlEttmx48Eh/utXr+EkoP1NyF2iEEh6k6s
	cBYXH7wFKeJ8ojBF5Bb16VApARJ2w1YyK65SM8/4b8bqUJuELu9QHuAelB6MnfNYFNXd/N
	FPzjJ1oiQJjQUKqpXrR0CeQOGs/U038=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ka0GYafl;
	spf=pass (imf28.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782486297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/3t6es/Sh5NFgNAr92B/NG50RTxtozIvYYF+FgF2iA=;
	b=ka0GYaflSKkPFQ7rFhIGoeEDcZfUQi/jBpWMJl+inaTs6Ay8kTJp9zdbYmSenvlQJh+XR+
	XB172PGZ4cpCqyqeulNT+N+xr0AurrQi4xrcP61whLGk9uJ8pOP+saDL+I6rAvgBdS3Po7
	QQIlkgcah948ts7waig31URzqiuDpu0=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 15:04:48 +0000
Message-Id: <DJJ2NKKPRANG.188CUADJO2CKK@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Brendan Jackman" <brendan.jackman@linux.dev>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
 <linux-riscv@lists.infradead.org>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org"
 <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
 <yuzenghui@huawei.com>, "will@kernel.org" <will@kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>, "willy@infradead.org"
 <willy@infradead.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org"
 <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
 <kpsingh@kernel.org>, "haoluo@google.com" <haoluo@google.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "jhubbard@nvidia.com"
 <jhubbard@nvidia.com>, "jannh@google.com" <jannh@google.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>, "skhan@linuxfoundation.org"
 <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com"
 <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
 <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com"
 <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jthoughton@google.com"
 <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
 "alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu"
 <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
 <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org"
 <chenhuacai@kernel.org>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
 "gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com"
 <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
 <shijie@os.amperecomputing.com>, "svens@linux.ibm.com"
 <svens@linux.ibm.com>, "thuth@redhat.com" <thuth@redhat.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
 <urezki@gmail.com>, "zhengqi.arch@bytedance.com"
 <zhengqi.arch@bytedance.com>, "pavel@kernel.org" <pavel@kernel.org>,
 "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
 "vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
 <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [PATCH v12 01/16] set_memory: set_direct_map_* to take address
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-2-kalyazin@amazon.com> <aeeDvpDnGnY5n69n@lucifer>
 <DJJ23EXF55VK.1EGQZS511HFB6@linux.dev>
In-Reply-To: <DJJ23EXF55VK.1EGQZS511HFB6@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7DEEFC0015
X-Rspam-User: 
X-Stat-Signature: wurz4qq45er7suwspry8rftya9fn6gcq
X-HE-Tag: 1782486301-793881
X-HE-Meta: U2FsdGVkX19nnOvgfQivyLcLoczBb99RBEWZzNCyUC/prwgQgE7Mm58mSgshI9oOnfCwupoYJuFlZeXYjhX3xvSWYCUZppKYBDylwlm0i3uDQN4nupz27S8YjPNyEEtdzs01FT3+FJjXZhFr8omDceWFfS9135rYiDuRPEwaRIyWhmqXkU3mvt2aY/QnV43dhWMN6MqlcHTQ56Z0eyunC8nV48wG1VCsZVyKX1pvARuRrPoi9hc1GdJCO3XMWZkZVEnEAG7gDQN9M5hj9S3ml0ps3LKVtLhngN8iAoZl6Q716b/w1xslkk3sWD4uESuQtzIFpfXagQQBqd0DRswFTyQ8LL7QYdEGXxGt4Cbtlw92KWxVW1ZOtAZx6OhRI5RG7B24u834k5LeCNeLueX7+UKpXmCKR8fS1YGT/DmuHiCqJuZn6udIk/pbjIcy7P8Rwu5im1XCG/BKv5OSaaHDZKM/7iAW+yKoZJPcTt328avEqGhOwWKX//gh3Ie8vrI5cj3rciEoiAZV5rnt3mmgbWb6Lfz7qoIJsKoxdm3OeJErgGG7yszc0TtU9MQDZ581hBVE75n7zSKI+aalfYMvgWVN6Fe/P5yGKeJXvR0nP46xKFg8XI+gnRAKPmS6G8iKLxr9X2zb3ACCVSZu98rHuFyQXnQqyUL4lEZPdg8/623NArAweAk30pfZn/T15OHgJxFVeWY9AdQ5EdMrsqkSyvxeP98+KE7D/PzjJo7/xesZhOz7wuyyfW7P8sqv+DpPht7cYIpCNi0OLsYKAj85Ur97WRDUFX5hPASEDU/vxh42HWmoPS357hV3tDE5uEB2RBfOfMCvJhTGwmYyDVB+aRa+OLtBxvasbSbYjKMQicPHEoay2OZxyIbp7IVXxdzSkHFJRf0FlYTE/3hWmMfwLe9eiV/DlMTVhyeoJLWjIOAxlB/9z2EFkISfukCR2jJSSrvKZbn64A1vylLg0hJ
 U7YxvhNW
 wUe8hib8r2pJNJmFooxkqODVSlVW+xGERg58GsJKU8QN++ivD6bUnyL0yamakOP8wFF+HzawRLkXo8T/rSAwSHQ2WQ2EbqEdBY9DD1vYpk4eqauQ6eBB7LfbZnROE45p2RKt1Io3gufITaWnpyCe1vpy7LnSvntc/+6DezBceW7xGim3swJc3Rz6ozcJY7e6TBpulFVInd6zfnGhtPzgA7LiqhGCaInu1q5LuO9x/xiKPkqS0k+Oh6E/FoT45nmZsQ2P6K3NS4Yk1gPDznXyiuTtv/kicyeZcY0DSypuM0D2ANu9K4A9ZzM1F5DKJAdRLkeYARv8y0uP0BHUP7sZ8WZNUNFGex51Z/pFAdaVkQ5CdPtWGTWbGsVywZMg9LArdGKd6tVztlmhbyPGoXXisPURIb+QrszbK/A/C8OGYb2Y6381ZPpgy5bW/w9cA/vZCD5grw/T5yFp/KH+iJaz9T9Hcs3UVGdwzgQ1/8v1DC4DOcrQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 26, 2026 at 2:38 PM UTC, Brendan Jackman wrote:
> On Tue Apr 21, 2026 at 2:43 PM UTC, Lorenzo Stoakes wrote:
>> On Fri, Apr 10, 2026 at 03:17:58PM +0000, Kalyazin, Nikita wrote:
>>> From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
>>>
>>> Let's convert set_direct_map_*() to take an address instead of a page t=
o
>>> prepare for adding helpers that operate on folios; it will be more
>>> efficient to convert from a folio directly to an address without going
>>> through a page first.
>
> Why is this more efficient? Isn't it a purely compile-time conversion?
>
> Indeed in the current implementation folio_address() is
> page_address(&folio->page) so it still goes through a page anyway, no?
>
> I might be missing context here about how this will look in the
> memdesc future.

Sorry I failed to do the history search here, this was suggested by
Willy during the review here:

https://lore.kernel.org/kvm/aWkN4yzwPtotaTeq@casper.infradead.org/

Matthew Wilcox <willy@infradead.org> wrote:
> The implementation isn't the greatest.  None of the implementations
> of set_direct_map_valid_noflush() actually do anything with the struct
> page; they all call page_address() or page_to_virt() (fundamentally the
> same thing). =20

But IMO the struct page isn't there to carry runtime information, it's a
type hint that this API operates on physical pages. Yes this is already
implied by the name but it also gives us a certain amount of safety
since it avoids unaligned or non-physmap addresses at compile time.

> So converting folio->page->address is a bit inefficient.

... but yeah now I see this comes from Willy I definitely suspect I'm
missing memdesc insight here.=20

> It feels like we should change set_direct_map_valid_noflush() to take a
> const void * and pass either page_address() or folio_address(), depending
> whether the caller has a page or a folio.  What do you think?

