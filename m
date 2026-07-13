Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26760C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4D56B0103; Mon, 13 Jul 2026 12:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC716B0105; Mon, 13 Jul 2026 12:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB116B0106; Mon, 13 Jul 2026 12:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0796B0103
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:26:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5F1F1C8220
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:26:36 +0000 (UTC)
X-FDA: 84984281592.24.B0504B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0870140007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:26:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/wWVPKT";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783959995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4oSo8Q8M/HDQKQiotqOthLA9NEMRzPw5zmVE4LKJDjI=;
	b=zcedBZMgr9JDt2CBKPcw63CLrS9Ep8KhJGsBinq6mNs9q2beoCnqbRb0+Z1p2gVz3goPX+
	1c4gUCqEucVFOPOE6Zbz3rYNLk+xGHxkc5uFGB+AdwY9KbBS5kp0m7IzxAmYuWko9xKIwK
	jDOdPTEoSP4aUufV1vB9m5rS9sPpNvw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/wWVPKT";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783959995;
	b=aiLaxzP+M6XeEbZfuezxk4KVydzm3u4LnhVxCjSjGgwXgN6+dt3PqQGD416dmrBLHKbItq
	gbegIbtymMcnBlfMEcaHXFCBBcCJDxe23u5j9OHONPOiakIiUKTIo5Kwg5pAZSsEzxxTuF
	ZVCWkCfBQ+zRhbyhixAvPd8Hrd8lHbc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C2416132C;
	Mon, 13 Jul 2026 16:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA4F1F000E9;
	Mon, 13 Jul 2026 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783959993;
	bh=4oSo8Q8M/HDQKQiotqOthLA9NEMRzPw5zmVE4LKJDjI=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=j/wWVPKTi2yTT9K+qqP7blEbgxvBXpRJlGYEleVOdJY/ZkEhoBIwU1XYjxGWpoIdN
	 mlS6Xlu2LM2QXPsfPsM+IAwCvbLnTk3PUIFLKAeSQKyasltc5nTKDN8FP+v5+XkUZt
	 oMxHh/hBdgPEvK+o9M/a9XHrOuskaRHNBN+GAA2b23faueb2V+5Bzreu3fOlknCV3g
	 X9mDV4OfSOsr58Xw+JFDKUJfvXypw26dMhAOyajWuLXAmB1PrYjlAOf7rtGN25iIL/
	 rCzb4NMtDX3G/agbRDAIFbc/H1Uo5RS/e34Ox8O6QnOgt1x71EyMVCwAMkKzkgYZBB
	 TIXI8gpq6Bz9A==
Message-ID: <f1864767-8cbe-4f1e-ab73-81944d3b8f97@kernel.org>
Date: Mon, 13 Jul 2026 18:26:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com,
 "linux-csky@vger.kernel.org" <linux-csky@vger.kernel.org>,
 linux-m68k@lists.linux-m68k.org,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>
Cc: Russell King <linux@armlinux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankur Arora <ankur.a.arora@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Magnus Lindholm <linmag7@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Klara Modin <klarasmodin@gmail.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, "Kirill A. Shutemov" <kas@kernel.org>,
 zhangtianyang@loongson.cn, wangyuli@aosc.io,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Lorenzo Stoakes <ljs@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Rohan McLure <rmclure@linux.ibm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Anup Patel <anup@brainfault.org>,
 atish.patra@linux.dev, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 qi.zheng@linux.dev, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>, chaitanyas.prakash@arm.com,
 Ard Biesheuvel <ardb@kernel.org>, guoren <guoren@kernel.org>,
 yang.li85200@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
 Dinh Nguyen <dinguyen@kernel.org>,
 "schuster.simon@siemens-energy.com" <schuster.simon@siemens-energy.com>,
 Vivian Wang <wangruikang@iscas.ac.cn>, junhui.liu@pigmoral.tech,
 Muchun Song <muchun.song@linux.dev>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 Nam Cao <namcao@linutronix.de>, Pavel Machek <pavel@kernel.org>,
 djbw@kernel.org, yu-cheng.yu@intel.com, Baolu Lu <baolu.lu@linux.intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, Coiby Xu <coxu@redhat.com>,
 Andreas Larsson <andreas@gaisler.com>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Stafford Horne
 <shorne@gmail.com>, Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-3-yeoreum.yun@arm.com>
 <d57f5b18-583d-4848-9d74-65b15c93dcf8@app.fastmail.com>
 <2858abeb-4134-4768-9a35-a569d5c86e10@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2858abeb-4134-4768-9a35-a569d5c86e10@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0870140007
X-Stat-Signature: 1iz58oednbtnsu31qjqw3c6wfm7hm48p
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783959994-647500
X-HE-Meta: U2FsdGVkX1+eJZnMXXo5YOmljp2LZcWY6Jl9BRrrG5jommLcMImkFWxOGIpa0a9P2th0VbtMA3DmKaDFmoQ9gkEbQHzrlDqa0qDceIjqr2s7Blc/9QUiJsEGRjrdnfvI07Akf9XvZbkWPFgBnQHtjHio5RjvMleWio7uQSxd0C1h/Nr5epDkedlEHFQlz5/+iVlHBPnUPpVk6d0F/yx3YKEzxkWbUluCAfibe0i96BYyjUvEKHJxAv8Wn3EqV3/RTL+Hkd3wpFjyj6PZgdl5ghdTDb79CJUS22VnQrrob1IE5ARsHUBAiLMn6m2seA4M6tvJuVX64o8FGoJRR8jRDloy2RA5pbTi1bTgoYbC0awLAyMISiJfIHUfHr1/KvCXmA5quMjFgpVwZJjYku+tFCBnvZ2IgsbCVRqk9RMFh8PoKWYqm7A2Zv/u1bXE/PHADBzPQLRJkfkrB94IFCZB80d3g6TkWrD0HgEkr6Prby8tInuimoRXC/ZTaix4hZjEWz3zzgKTeVyhM703MGrSZmmxlRxNS1u51t7iyAWyKS9+65jDKW/UbJDgZS6FMH6AMOg3fznPITnrvEKiS6jSv2dLSi9S2Lky3V5bQSfhELopWeCFCTVZACD17S1cHkD8fudbpuWX04Ho/ywwR2GOXpppKMemm4CJllLREBADgWtoz+PjCUCFeKl34dpSKq3SubxjrQtjOP4jdwpZ9gZjgfXEeBG0QNnNnFRFS4SzI8AaOgU8pgrR7f/V+jOfftKBtT6/1Z/2G6YD8DfGrfNM6YUbqcY5XchQf5kLJMZHewxnRTTLevBktBu7dIKwJAr+yQ68e8iEhqttji0I/l0K86IA1R/1k7ZfZmOt/K9tR5aa/44lH6BTSQFGyZByCA9Ef8g3XqU357v804IqWYisJsUSMtQVt9BGMJao5b8OyJW+8c5anJ0E/X7s9CQGDNyh7tpSOnMDXkJHwX5JW/C
 aefgblHP
 jl55Ul0x//6BM9gjpG5r/6628SftI9qRz+03czIlpUY3W9X3krGugLw700Vr5AnohvroCUlDCrx0KIKAal0UwzvYezz+ZOVHl98YcNHSO4974TOGneOBGIvuBxUMa6Wm0+Ohcziwv/cX+rK31KT3EqMy1PrW7R8bpkCuHm6LkK7koB0KWlXpcrpQhwsH5nzeXFqKYJviMcaTwd6APcp5UT7etAAjYRjcnRgpUwDBH19KZQZDqD+EiV909elnFKe86fzvqo9K7ER8s3kplXYqHTqZnJQ4pS/Ej48jBGH1Wt9yUtisVYtklrCZCwFqVNq4gBN7GpgCqZQLZ3j/I3I/ErXKkwgfvJ7WkTgZ+cUQ1TKcpzEk5KBMJ2fA8aXhP+ryACD5jQnMOcpuQPyn/aOh1ONHhSg0Dvo0vw9FhgWvqX/5fHPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  * |        |
>  * +--------+
>  * |        |       +------------+ +0
>  * +- - - - +       | Linux pt 0 |
>  * |        |       +------------+ +1024
>  * +--------+ +0    | Linux pt 1 |
>  * |        |-----> +------------+ +2048
>  * +- - - - + +4    |  h/w pt 0  |
>  * |        |-----> +------------+ +3072
>  * +--------+ +8    |  h/w pt 1  |
>  * |        |       +------------+ +4096
>  *
> 
> So we interpret two 32bit entries as a pair (64bit value). Together they span
> 2x256 values.
> 
> Then we make PTRS_PER_PTE = 512, to iterate all of them (both pairs).
> 
> Let me do some more digging to come up with something I can confidentially

"with confidence", not confidentially :)

-- 
Cheers,

David

