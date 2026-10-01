Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D69A4CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00BC6B0092; Thu,  1 Oct 2026 07:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A4C6B0093; Thu,  1 Oct 2026 07:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903CC6B0095; Thu,  1 Oct 2026 07:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5520F6B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:23:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8D90C03AD
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:23:19 +0000 (UTC)
X-FDA: 85273821318.27.35513FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E7DF3180006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:23:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hq1jxQGW;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790853798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e65AJN+dizDpNgTUq4a0Cxwv8xeFTHb03ml1zIvkCoQ=;
	b=1zoSiw4squSZ5agLUIBmKPh81KaIjEavDdvb2AaLIavC5TpBhEBFmCnGWLxvgooH10q2xr
	j100VfyX9JGHJGL1ugtubbF/meV9yLdaxL0LFnIEdu0mCRzpMZMSq3blarXcYf7y9OXn5i
	kEhk4RdBAx8O4MFiIfN9wwOCKMXtntM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hq1jxQGW;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790853798;
	b=u1wB5Qlx7w976yEAEqaSFQSXhL6WxmkL7T6OuLz4UNNU6pqt7ORwXVHQPpW6haPOryeUfs
	omSWOCjLB3869kDe3bXFwLrNRLKj0AOU1swMnf6JE+5kugaBq3KyF1ZiqGhZ4c1e8kFbZs
	UErjXsDfd4Y11t1RzSMntnWMtVzHUFk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C276E43CCA;
	Thu,  1 Oct 2026 11:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C481F000FF;
	Thu,  1 Oct 2026 11:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790853796;
	bh=e65AJN+dizDpNgTUq4a0Cxwv8xeFTHb03ml1zIvkCoQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hq1jxQGWzfify63ZgZEC2/fTTtnkxCsb0bizh56Uwcr6HWZKYoDtzLAFE/he9Pr/3
	 OBvyMZtgVbRz0AtkC8gljG+lq9UL50oTsGKJDPGHK8jZJIpT5dYB8hyBjZJXNOxLRz
	 S1g4fJkhFx4OhWbRxwbh5UP/VmxG+SgV7NC4wNLWdSvJKJsZSB2wPLKQlnN6Pd/MOU
	 AyvCel6IqNdq6bPj/vEEPmH4T2cCnmdvEGZQUWWySwrQ1KwV4DDeKV0/oxJqkb4dkM
	 SU0m4lXhUuDVnTU/1yFOTftTVkqDtBxeH3Z1k8kBGVDEVovf+RLA3zW5xQqJ4ct+O6
	 UbDMDSXAUlYtA==
Message-ID: <2dcd9dbc-99ca-4f5e-8e25-f42977763c84@kernel.org>
Date: Thu, 1 Oct 2026 13:19:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] mm: add hw_pte_val for HW PTE storage
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 James Clark <james.clark@linaro.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
 kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-6-5670b8cb9059@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922-pte0-v3-6-5670b8cb9059@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gsj3ee4cqmhpp8h4thubodnq5ac7wfhf
X-Rspamd-Queue-Id: E7DF3180006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790853797-345092
X-HE-Meta: U2FsdGVkX18f0RthoVWNSgO7FQRv6DsXfHDr0lVqlFV0Q9lp/R1SFl5aBZK1mbr1N+14CI3hGvfRZ2bTZPEhA4R0ZFBdwd5gZmWdv3LJpfFwUSdqpZ/UbWPKjxwUCYp3FDxZVrQowwthAG0fLxpWGUt/pIWDrgTv/fpbWEnGFxn6qbEVsezukxD/SjaODUWo2B3t7wlKDS1CNLoJj3QPwGE76H9t129DVxhx257vdD1HLR38CCJRy42uOK8iVyfrHKMrQQc8KuB+onlhKibh4AgBjeAiXFOND8pGk/mPadkQrayaCregqz75v7SATiOCsc1fu7JzZg3zcAUkgKpPPa1OGrgokVZWpIEaPo805RBV4Eb8yPsKCJ9ut7ClVWrej9ZWkQKIBzYwvKVmXLz7HAjcZl7MF/GPYD+dJsdjI8QZqExSUnidKegWdizvo+MpZ3r1fMrOGAqo2FavKqYQGBp64y1TcSKOS06O+Z3PxLBrQvtQkP17u5ncynNc6RB6n9msgcyY0WyPhmAyeogAFpPkCZSX3nE9KEFsA/5+0QfTazjLm8VUmSesWMTpxUAgnCfluZFM6kYB+lB7MnwHy8okoL+CayaJ7eMMjC2Mq55+4ELFJLg99Zb7A8OWI1j9WEbZ3p8fiTzhay0SqC0PEEBkUIBtElRnIpCtOXGEcTpjC+rRtYwv3ZG20les5rh4TU+swvBBfY9lOXvnGPuKhdmI5DznjFX6iQ3Fb8E8lWLcNlpf+ywkBuf8NrYK3BJSaPXS6BKsAo7zh8cyHL4rPkEfRi5SJHgTpcVb5n7WwuAGgJ0NgZkqEKUAhrO34jMJCaqngavST1EWMUHAGNA3NdDqa8kYPvwmjz4NpxC5bmktWTB8k2bKheTb0cg3X5L6sqh1EeD7JqzpFqJ00aeMlkbtjbzYrUbQS/HQHi1EA7TMIL3K6Olm13wnSlmYWQFm0ouH4VwkT4B5Fidbstw
 SVPQhAK1
 QA1Nmp2Js2IGpVgTB532zCYpADoAijNSxN6FWKtf4+gTMG4Hywl5vfCID45FoN9TTFFj1r2Ye48IbCslnmbw8WVbVJFDAJy2hjdO4LXJrilqSixisfkeXsPtaMSQjjbjTICWqZTSccFQUvG5A8YK9cl98q6e8FhYEBtdpGSn+/gp9XAYlxPWfFV/LysEujEOX5Gn0fxHszUMNpKnHqKnUE/cmYRt1C4V87QoPbI58qMZWxUYMk2E25Egjsg6y3moD5BzawVdLNWVdl+FrgnYCqFOdfY+5XWyxUvWhHDhBAGWDJf9eb0JIhMlSophHoXpKikxi7LBmSjBz26+0Z7YhHMoF8IKmNhG+D/8M1yjR2+6+VzowD+FLk/q1c2nut4GdUoE/NMYONbXtcFwF5TSB/IPbccOPF3y7RBKSAbUb1f1kbjNnsDOQRp6UGDAtTUlLKNxhXthrgFkoiQ7IR3oYUi/ZZEvMjo6P4pyJEufjdtSSx8BUlVNEtuQNKdBgGJrRBFS6rxTNwwcHXfkp6UKfHxX5/jNuB97neiyZpfvVn6EpfqfCZBUGE1K/9kLWKXABQAMp4W6L8BlzMlV02miGvd0q7PC2ZGWds8mUPjI25tLrVzVMehtrPEMbwcXvk4HD33CyI49iDGn9xlQlm2oPTQ5Pf1ABkT2WzzD7W3SEXvwwmfMdQzZWWQ0/cK3GxfKwz5IJcmpd6hp5u4kMWmUsULafwLH0qN0nreAIPvvzG8ByJKZor8Hqr5p2wc/AOaz9DpYIPl58VjAahZawV+os9swZLuafcvZzGm/it+XBrqzCv9GfNsYbcnoXYPzxCh0YDXCTXIZjoOULsAWFbGLuzzXOJoxWuu74aV9An0S/BLnsbtQEBFWQ0N7BcQ5adGF2psWEYGj9jkwVxedMwFX5JXb4DgPAkFt2YijYXhcDhQwTBDJdaAcf+A5dy4SPnIfJaQwCh+qiTckAYLhGHWDv0jn6Kxy/
 QIFU4QTc
 1C+J+3dC2p8EMSLDVCGG9VEZY/SBEViUNjDsy6CL+hZCbScwrCetZs04C1qT3uMiqSphIlRz1N+ToDf1slFiWspiZxYRH1NZvHQEz5gtCFHihvrd5+K4FKPHunyB4H7Yg8JAvMsifdqstFjNxr7LOWIvLVrx+VnE5EcFN8vXIU6MqeXWaSg7XUr9J9PBrLlptRuJYsHsL0sNA4XnMwyB/MDZo/bIxzgzYHKGUymSoCQ9LGfVM7TRX66c3RldGtgg7d/qrVSZ294nRm4ivS2pZ78soy+ZELifD4VXt/2Nf9/rchDvzltOvzc7tWSxh4bABwtYghqwmhilcjmfGbOHqUvxDnz0bbrKE0cYxAUQzoyfQeO9RyrmYwHBJSNz2chfkpoWl55ihvYYdlIzT433VtJtiZFDs7lCIvn19/gpya4bgLIXMkBZYcdufAHX0igHk0sgHdNCuoXFggFjg/MGlAAPguZJdAGicRCy5VvWrAJZOqRnb7453+UT5jK0308J5FDER7NXJQEHsJ0nTgkHvyV+queLRSGCAyGyNzbHauLw+vQJHxSmfrly3XCpLnYKVtF5oyfutMLVP0FBPC4EIllE+JTVwjnAlNXZVdJCtDFRorHmLW9CZoUjDlbrur6dFjQAzXAL4iVJBNZ6WOzFI+VOALWH5BrpERUDWyjkUB19Y+8A3zRyBzPoCtSlmW8rNqlMY/toOLtBA9gDMRvM3qaMWUzAxY2BfpN86StC07Q3ZfnMbdGhr6bjVxZcrMp0phf02D9gZmeCtMWTW+xNqlC4jGQmBnQ/kk2GvarVgaMNGmBi3r9FbmDAC2XtItoFWeOA5/VHG4fGdsjhccx9jKZozyP8x5zoue/Mas0lSPb0ukChu+3L1VaR2TX7AW71zNxCA61GAMhgp7vTqicp+QTOtSGiuL5qsRJeCB6pZNmz+aLQqzmJq17XlUu+QSaWBQcuRE/zBEm1EPKdjcy9VZHom3OVm
 TLZ9yxkQ
 xlvdfitKah+NdWE3i6hsvfy8VhMn5HNCS0X3+a2//pIEQgW4/zOGtrQalkLzEBCrjT7PogX256mb2nvaGGkZ3q+7y5DPXy7BKyQO+KmOkfu4/FlPDBm80Z/GDvqwvQpSfAV9JiVvrpDZvW4eYM7XiwAsedVeKt1cRtrglq2AuI32AOoHEZLdhp6IhF7pcS/MlQktF4uICelLrZxAQREs8hd1ntxnxNskNFaDyO4WB8fTb0aad24aL5UdSgRmpZmUAD+6ZOJDSQ7ZXnSxXJs8j0y6+4pFASzZxbQ3OUaQzvYpi8PAv4HBXM5yiycqkN0iCU6UKNam6gJED0QNsWqyEkTYpBI3tLyya2ydEODaojfzmN0icsLCUXhcy6/muOGVxSFk/6NGDW8eUOZHPzRuDk54ZvHbM32rDCLp/MOWEDaj8QQvn2a7fafo0nKNtTOWGqwX68kSPBkv3DtvrhEZC+wLqIf3f1sC7yT02u+1N0pl5IwsWEyXJmyw2m9HjOZ+XpidcG05Nnh5LYAohGwdBGSm7fRxO8MRcE/QOn85IbzuakZLc6QqkO1y++Z80K3KvdMKFssNxOJd5GXxg7U+PZs82cTtEKsRnVVKsvXdrSXvOdxvJR1peH84DbgcGALzshOnP34/pAJFqA154jRyvw5VNUlBIn/NcGUHPU8i0Xo6M0rTwkyQ1a/62ntoCGL08Vq2PtLL10Aw6xILphcnInQJpURrJ7dafz39TbhHQNZ/G2iOXdj0Bo56JuT39Bpfmu7m+bIie+aao9oV7o7vCvpr/eGZTm1uMRh7rRaWErHnYx35AyD34YDFpjsSqngmBbRCaj6r8jJk998Q7IT4gc+qtY2CZtmJEve7tkb4EfY+WJKohbsLZzFSeqBvAf4vWITqNTBj6zPpHYFxQ48/+vQdzHrKLSOKeTz+tDkZozK0KptP7xNT1TOgDdN+XoM3w8bv6ic17tvFz9bJ1cm+FoJ/Suf3y
 eEpqbOQ2
 JexY8yQN1N+oRfVdfoHsZvLTnTP1x/0Fg/sq+8+yN0JsWN7Ylfr0MsZ3GU62pAfb2Ye9TTnRsbUySj9SqtO3MHvDYVwoe7XqDuSOCiqKH0+C1P+PSFx8rHOfVlZq0ky/PrFxvVl8AzeHMicDFn71wR9cDLE/af31VLLLaGFfQfg4W6L8nL7fOBbttr7ta/34MeJVgjsN4m64DwpCpyhLOxg4Vl8rmMLV5mTS6rbi9e3tz0atV+VebKyhnDc1YZ1w5ViOoD1SjVwCnWxu5NtWdtyxQj80q9jeQR2G4qLFmW3BEf40JuE7Oku9NEp3RQoqlcIWgvwIKoC0DuNVoEK3aHbi4+0onaGqR18JkMmDLjqEY++Bk3rEchk9GbiLEjDSW8r9MOnN/5NG1O8g+IO69GeI5+bQ5LTgjaUxvSRAx+hw1cT4VHor2/UWSe2HXfzWOgAe5IPNNfSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 19:12, Muhammad Usama Anjum wrote:
> Atomic PTE updates need an lvalue for the bits stored in an HW PTE.
> pte_val() only accepts a SW PTE value, so it cannot operate directly on
> a distinct hw_pte_t.
> 
> Add hw_pte_val() to expose the underlying pte_val() lvalue. Access the
> wrapper's __pte member when hw_pte_t is distinct, and use pte_val()
> directly when it remains an alias of pte_t.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes in v3:
> - Moved from the arm64 series to generic series as it makes more sense
>   to add this in generic with all other changes. Usually we only add
>   code where its get used. But this whole series wouldn't get used
>   until an arch started using HW PTEs.
> ---
>  include/linux/pgtable_types.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> index d6c5a7548550b..ee4eace5c3e1c 100644
> --- a/include/linux/pgtable_types.h
> +++ b/include/linux/pgtable_types.h
> @@ -9,9 +9,13 @@
>  #ifdef CONFIG_ARCH_HAS_HW_PTE_T
>  typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>  #define __pte_from_hw(pte)	((pte).__pte)
> +
> +#define hw_pte_val(x)  pte_val((x).__pte)
>  #else
>  #define hw_pte_t pte_t
>  #define __pte_from_hw(pte)	(pte)
> +
> +#define hw_pte_val(x)  pte_val(x)
>  #endif

I was just about to say: this series doesn't add any users. You should add that
detail to the patch description: "prepare for usage in arch code" or sth like that.

With that

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

