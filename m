Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CD8CD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 02:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F436B04B4; Mon,  1 Jun 2026 22:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446716B04BC; Mon,  1 Jun 2026 22:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35C356B04BD; Mon,  1 Jun 2026 22:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 242EA6B04B4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 22:47:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC8F31C0DD8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:47:06 +0000 (UTC)
X-FDA: 84833435652.24.DD5DEB6
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf07.hostedemail.com (Postfix) with ESMTP id E5F7740008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:47:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LkPFv9Yx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780368425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DzEYFBO0HPhxlPtDd2N2r80uc2UpuMcmthR9XLKa9lY=;
	b=0hnvntFo27USBIYv3JkRImhatAvvFjlI8X7rOvivfMTaq/tEe6MkE73C+ZVuCIyuF+uF6Q
	kekiKljk4qOSCCt0WJGYjJRXXxrqL19f9ZR7XZykTqiUSscPQ25CVqIDjDim2BJVEOpAWh
	cEaMy2G0QfTzlp2XOQV54/Yh57xioBE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LkPFv9Yx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780368425;
	b=w0uhHqYbNSXHka8PZQxvK9XJh8ki+bVrhns4WIGlNbKAmqr1rhZUZRpmm29iXamqzqgRZm
	pVAJzjPXl5Z1zH/N1hgWvmVX9/qFoEk+AljNuB1cMAoT6kc1RZoTzjsIaoYOn/GyiIsNzq
	0SliutZbKcEvAaKDNPheAh0RS4eku9o=
Message-ID: <2e9175ab-f9be-44c6-bf1a-a82aeed18f98@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780368422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DzEYFBO0HPhxlPtDd2N2r80uc2UpuMcmthR9XLKa9lY=;
	b=LkPFv9YxAbgRgjzFP5BMJD5UzFP+Pyiqo/D36+oL993VEh6AhN+ezGxDUcCS9s1mF8idFo
	bKX0IsY3IN9aHJ9n2qaT7GDgfkgtCEo4nxE73t6M0xRyIHtFkbgoKVcmNlAMsIba1f1TGR
	1etFxbBwPJy0kyfvqYoI+XbTR08elbs=
Date: Tue, 2 Jun 2026 10:46:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Content-Language: en-US
To: Barry Song <baohua@kernel.org>, wangtao <tao.wangtao@honor.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@kernel.org" <david@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>, "sj@kernel.org"
 <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>,
 "luizcap@redhat.com" <luizcap@redhat.com>,
 "zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
 "kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "liam@infradead.org" <liam@infradead.org>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>,
 "riel@surriel.com" <riel@surriel.com>, "harry@kernel.org"
 <harry@kernel.org>, "jannh@google.com" <jannh@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>,
 "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
 "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com"
 <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "damon@lists.linux.dev" <damon@lists.linux.dev>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>,
 "jparsana@google.com" <jparsana@google.com>,
 "dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>,
 wangzicheng <wangzicheng@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer> <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com> <ahlzj--3Gm5pD9ge@lucifer>
 <a90bcb0fa3a044588350e92a78258a09@honor.com>
 <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E5F7740008
X-Rspam-User: 
X-Stat-Signature: uuq6gh3jtkay7j6c8a98ua1ecbbu889r
X-Rspamd-Server: rspam09
X-HE-Tag: 1780368424-36462
X-HE-Meta: U2FsdGVkX1+Zs9gami5YbgdDSfBCTmBuKT9P/KVB0I23qrOX1ta0yShGbrjUReurOvr0Qwj17cAIBLnYBIp2L6CvwKqJLIKL3ldKeYOpiXUXihC1LWnomH2aED3rs+g/WKffUkBOZcjhNK38H/JItUxul1i5jIVWu7pcUSshMnsVEtJUlG8WZUprhzg0L0HYdiBFckFaWcG1k+gzgdMG4GFFZ+hig5haXNgkxpkQ9xpyXFeJayTO3u+88JJ8XfOWSK6RUoGgTDcF1yGdkkLGwQLBXFZ75BrMuqVqM+6FPDN08piaPKEwsoUXqpviEzw6srI4NJvriOpxqsnsnBdJPz7j/06TeJsncwL4Ro2NUABvLexHUvaupjF4dv+sP+LVI9vuiqplkVv3tnh4gytAepM00soE0FKk2Y+nc/CGHiiIUPCRbQu2MxQkYdebO+3fx6XeqA2fPX461fmI+hsH/qGBFmwOkLtmGteyd2J5wl5YOPC43UKqOLoApdeYHIMmuVR9KM0G+Rg5WcWNw03/FVapEmuP/Y33Eif8rkj5R6gndzXYDFCOQzjcICxpZkVon3bCkmI5urcaeXhc/o7453Fl0ow5w62LOyphgDUQumWolVMWiEZ4FFp1n48uFTSdmcISzHyZlMz6HzVNwo44SLLTb8rOGeZmtwSwlX5qwl609GwRDEh14BW9l5CapuaFZL3Kqgzsik7coePdYZPcZ7KTt2m6WTnThKgB0ifQuHCQe7Yc1VCYdARO9kj7jSO41a5L2t7pTcishjUrIAe2Hkhgy1K1vwW7ELggqMxozJR892xK15ZmkJY99CGtyGW7lUvpMG1zFJw3dfOb6vZKfZINWvdIrYP//s0WXV8P83Z91H8OkzQCSy3A+l8N+mMEb2k7POifHLOC86EvE/CVwTQgfANYdg0sg1Pw3JAPo/JFRoxUqftAGBomTBH1bZHdWeLXjhaS9tfk4r3oSKB
 thsqsamW
 VmsvCt3xaPpFtZp26I5xsywNxe/fixfWhhFB6GdvXzey3+TmcqLW5KD0FtqVU8SNoHKy9NRxK+UDqCz/AN8+vn4WLGOBoFUX8+gJPMMK+5toZaH7ZoLpzEnU6VWryTBetO7dowIt8TubGMIz2Ta+qwYh1qSoXRO+gxxv1bYWrKLLLBS3B6HArqZxiIgpoUriHkfQ1I6nsEhpTRsITAGzOm3dEzkezVx5DbpAqN3y2s0GPkQRnh3wDwjzA1XCMaZfNsEde9ab9SCV1Fqg2MrccufEW9OyVuryjLdj2jmZwbwgGzWVgzih4VtXOMHodWstrbd1olPRUhfsk8Tnp5IM5OX9C5SoZxTuKcGoL5ozAwrJi7abVrJWQxmXGbocPfj86IOBq8FVpOZnDDzvGf75tYuBqVGGm/y72SUOqCxat1gnm6DmjJQ4N4tYYJMpHW84XOci9YyPayIwRnNjiShEhXgZntarnJHzsdbyNytEWsn5elyWmqIsaAQ2q8fXEcPZwR9k+R5CSOK45F5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/2 10:15, Barry Song wrote:
> On Mon, Jun 1, 2026 at 9:46 AM wangtao <tao.wangtao@honor.com> wrote:
> [...]
>>
>> You said discussion was welcome, yet when someone offered even a
>> small comment, you refused to continue the discussion.
>>
>> If I had known you would be this inconsistent, I would not have
>> replied to you in the first place.
>>
>> This will be my last reply to you. I will not respond again.
>>
> 
> Hi Tao,
> 
> Please don't walk away from the linux-mm community. I read your
> patchset and found it quite valuable. It not only reduces memory
> overhead, but also eliminates rmap costs for exclusive folios.
> 
> Since I'm not very confident discussing technical topics in English,
> I wrote a blog post in Chinese about your patchset:
> 
> https://mp.weixin.qq.com/s/k00tzhTl8HbL3k4G6ev4SA
> 
> I have to admit that I found the implementation quite complex and
> in need of significant improvement. However, I think the underlying
> idea is very interesting and worth exploring further.
> 
> I'm looking forward to seeing a v2 RFC with a cleaner and simpler
> implementation while preserving the core concept.
> 
> Regardless of whether it ultimately gets merged, I hope the discussion
> can continue.

Same here :)

Tao, please don't let this thread get you down. No first RFC is
perfect, and the idea still looks worth discussing :)

Thanks for working on this!

Cheers, Lance


