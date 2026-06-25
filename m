Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A3CCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B6D6B0005; Thu, 25 Jun 2026 05:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDBF56B0099; Thu, 25 Jun 2026 05:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF19C6B009B; Thu, 25 Jun 2026 05:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8826B0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:40:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A6118FF37
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:40:27 +0000 (UTC)
X-FDA: 84917939694.27.DB2D93C
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf21.hostedemail.com (Postfix) with ESMTP id 516B31C0003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:40:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vXReBvDY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782380425;
	b=hCBC7b5YmJmXcwE590pHmuA6PVO2Wv3vfzm2ay4aWgSYKTLrNvc09tVrmdl9FpV/ULbuCT
	UbtfQ9vUwxuu/HVKjNl84Y+QY8y2nUn9SOZi3H3nahehmaLb5B3IdfadLC9we+8PlU/Ee6
	Oh9ftNbn7zPtH5Eg6ZyTqezxCar6TG8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782380425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FY1PyiORB/zCxts/fRveZ6vdxg1hQ/t5DTuDGlkXWW8=;
	b=iZYfGjIrzYn1fQRVfYD4adLtAg2TfEOkzB562WZdvQdxQgdX6OtvaGoPx6LjQ03T1fjphx
	/mapHA8MWZYZu/avVLDEs7cNcfnYsxjemNhFAAjyuhZUpKlJMc2CDM5/TLFXnJGUctFTBP
	5JhNHW+0wVG5noSLc5c7IvY4zokY998=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vXReBvDY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782380418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FY1PyiORB/zCxts/fRveZ6vdxg1hQ/t5DTuDGlkXWW8=;
	b=vXReBvDYDhFntJr5ITL+FUB98gaGuUalk/XfSWhDmbPb1FGX0/ndA7EjtCGefA2lO66tCb
	bz0VTaIZBMWYcZzWgNMGcmKXiwxMhoqiIGjEYkU5X4UhhJMhp2JKabICirFtek+SRqmBra
	PAx3UFYK65LKv1LQrtCEPFIA5Ql0pQk=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Jun 2026 09:40:14 +0000
Message-Id: <DJI14IET2O9O.XJHLXBK60WES@linux.dev>
To: "Suren Baghdasaryan" <surenb@google.com>, "Hao Ge" <hao.ge@linux.dev>
Cc: "Brendan Jackman" <jackmanb@google.com>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory
 Price" <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>, "Michal
 Hocko" <mhocko@suse.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Alistair Popple" <apopple@nvidia.com>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH v2 13/13] mm: remove __GFP_NO_CODETAG
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-13-31f31367d420@google.com>
 <6e312b15-d2b5-4137-aa3f-720ec214c7ab@linux.dev>
 <CAJuCfpF9-CS-gt1S=tRNaK10yNnnod9DLEe-Y5L3ad5u60Gagg@mail.gmail.com>
In-Reply-To: <CAJuCfpF9-CS-gt1S=tRNaK10yNnnod9DLEe-Y5L3ad5u60Gagg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 516B31C0003
X-Rspam-User: 
X-Stat-Signature: ndhu985p16srj66nrof1oj968cype31y
X-HE-Tag: 1782380422-23842
X-HE-Meta: U2FsdGVkX1+tkTifs5nYsgWqNKq6/Z16TaG8drLLpJOv6eXb9mE6G3tqP626HXWVcxK7L9NRsdiTtZErAIaf/bA3aPJR5z9e1z2LWlcv+3Dfe/mNczp57nlRngQuqFQ4rZcw1q4ZR9VrxR2GM5S/3XFuq9ekfr+1sZgEVN+1wRk0eRHAgEIhnYBnXWDpkQgu9EtbxfPFPRKopfjiV4ZA0uPBTevIigzoX39iapMVqTJ5/Xin24VTKBiXze8mqfAWR3OAO7S7KGYm4uNOKu2EqduDIPiYGnBZVYO6BbFzsBGnykU3Rt60zHlzcnkMtpoabEdRJKEwCedAghVSWyO4VU3zTr1mWsXYU8L4/SxTvwOr36pt/XdFcb2RqQO3KiW003125fYu4YUkJflwTWUQEcqluse2FWMqQuWeuUMT848fKkCYpjhNHi7eI03f2q4D9arfXBr5KIHrnUya8uFHuz5K8yhoZSTbK7Y1j7jYImYTir0FW6v6PVawWcCaX7kpJcbNVi4uDY3IYL8mqT60WRB2+aAip22cIEZMfLd3YnEVL4JI/qEs+bUMUFVAMkL1DSDxEHE9jyzcpDtq2adXcdD6bm+CHApSM0ng1qoGHIel9vL9ug7jQGf2qd7BvHySNnH48aT++cFBY+dl2EwEZ4/e04usoHm57Zk1q+gSdzKJP1QGMLyUXgkIk+qPZm08HaAmiOvzkuVmdSxDs6t3oe+ytas3wT2REJJvqln5vKHSVJ8MEykF39fk1KxAbXMfNy93YFsmbvDO3lb3qG3dFeV7iBnWDf8VaBW5pRFLU9KgXTOfn58ZlULP6UwHvjs2V5mnsFzHHNAjW5uBWvOKyVfch5+HAZ1iESNV1h8lJOJq/vCma0r+UvX9mVKHdvNiYrQrux3VW+XixpYEvVFWr4yBCMELkvk4ASKmp7QLZGC7iNcMrTAzkZ44DTLx8vJt0LV8krnrx72C7PHJtLC
 A1CR/QNc
 ElWtNrPTQGfJ1k9e6TCoKQhQpS2BBzxZQgUoMJaBxeAqLvYHBxNXaw0KosdhmIuwqn8OzK31zNewM336kzVEjIzPEARuxcrFE+CSAwcUpbEgHECJOQ5CbyybFIiqDK+0M0rxg83oWKuQ9NYM18WmerjjStELrxRgidsg7P37XQBGKiAxbuGjeJyrcfurQymOBR0ZKzJRj4AOPgPw4ecSNCmyYwxVpbToMFmSLlHY4d6efotLgBBJ7YwO3lrxgm9kZTsKqR6wfExXI2dgNXOrx3qtnCDGJCe0qajPwVQ+GNBdeTNr4NAmCU7HpbJd0uuadlpPwCrTQZRinJtQBFjD3854O5NbYxV97YsiITI0M+gb2OuU+IpjVGVHAgGNnfI2HVvMSV/RdkXA9c5So19zQkUdebw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 24, 2026 at 4:47 PM UTC, Suren Baghdasaryan wrote:
> On Tue, Jun 23, 2026 at 12:57=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> Hi Brendan
>>
>>
>> On 2026/6/22 18:01, Brendan Jackman wrote:
>> > Now that alloc_pages has an entrypoint that allows passing alloc_flags=
,
>> > we can take advantage of this to start removing GFP flags that are onl=
y
>> > used for mm-internal stuff.
>> >
>> > This requires also plumbing the alloc_flags into some more of the
>> > allocator code, in particular __alloc_pages[_noprof]() gets an
>> > alloc_flags arg to go along with its callees, and we now need to pass
>> > those flags deeper into the allocator so they can reach the alloc_tag
>> > code.
>> >
>> > To try and keep the new ALLOC_NO_CODETAG's scope nice and narrow, don'=
t
>> > define it in mm/internal.h, instead just define a "reserved bit" and
>> > then use that in places that don't care about what it means.
>
> I don't understand why you want to narrow down visibility of one of
> the alloc_flag bits. We don't do that for any other flags, and this
> seems like an unnecessary complexity.

OK can drop this and just expose it directly.

This was just coz __GFP_NO_CODETAG was local to the .c file and it felt
like a "regression" to "leak" it into the header. But yeah on the other
hand this "reserved bit" thing is unncessary indirection.

>> > Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>
>>
>> Nit: The title says "remove __GFP_NO_CODETAG" but the flag isn't really
>> removed =E2=80=94 it's migrated from gfp_t to alloc_flags as
>>
>> ALLOC_NO_CODETAG. Something like "mm: replace __GFP_NO_CODETAG with an
>> alloc_flag" would be more accurate.
>>
>>
>> Additionally, as Lorenzo pointed out in another thread, you will likely
>> need to rebase this series later.
>>
>> I noticed Vlastimil has already landed the slab changes removing
>> __GFP_NO_OBJ_EXT into mainline:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/=
?id=3D335c347686e76df9d2c7d7f61b5ea627a4c5cb4c
>>
>> For v3, it might make sense to fold in Vlastimil's patch so the full
>> removal of __GFP_NO_OBJ_EXT can be completed end-to-end
>>
>> https://lore.kernel.org/all/20260609-slab_alloc_flags-v1-15-2bf4a4b9b526=
@kernel.org/
>
> I think Vlastimil's patch will be merged before this one, so this
> patch could remove __GFP_NO_OBJ_EXT complely, saying that its last
> user (__GFP_NO_CODETAG) is gone.

Yup, Vlastimil's other patches went directly to Linus so the final
__GFP_NO_OBJ_EXT removal is already  in my local branch for the v3 :)

