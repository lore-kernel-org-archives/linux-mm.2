Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415E2606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 00:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UAqZTcmw
Received: by kanga.kvack.org (Postfix)
	id E455D6B0629; Thu, 12 Nov 2026 19:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D6E6B062B; Thu, 12 Nov 2026 19:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5AB96B062C; Thu, 12 Nov 2026 19:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3A116B0629
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:22:36 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0F6E1C3C38
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:22:35 +0000 (UTC)
X-FDA: 85428194670.16.E21D74E
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5DA212000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:22:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UAqZTcmw;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794529354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1OPI1lt34LpA9BkY3H/uvJw7+nIzQc2Xct83tHpWEg=;
	b=ufGoqhfNQ3rKfomYp30uYqOfFMNKKGvCVbgGe4LPjfS/tBNtP++o421XTh2/yeZZTcKPVq
	KbtjkHu+WOKTNxjZs6MwRRfzDBv7IF+EqiNZ2zbnIbmJ3/lzC5iyBYb+B66KTRV2ZuYNjY
	p404wdwSsu9X3kZOESUmhBQqkSxuFLc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794529354;
	b=AwMPdwoHoM+IJxdZ/vYaIiMy974A1j0tF7XpIvFEn0LqTu4rNr2D/s+qb38wEvPOQ+KqM8
	EG4q84xC6uvHfKpJoTwW4nlY2oOUtPDmlIDzadg4hIBefjf/wQuTyqxwB3IFHvX6LMMNcz
	YFWPu9ykC2si340PHoNEJTTXkykSyYg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UAqZTcmw;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rmnnRyoTz6AZdPc0e7253Fzuu1lAJK2/CJLVmW/V7xA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794529351; v=1; x=1795134151;
 b=UAqZTcmwWUSa6qiP47CvyCBFbS/M+WBUYo93rYswHJgDFyn75f5FroGkj+JCoO2Ebo8q2JpX
 +bxcb3Fc8AN6qQiUfe4JRuB2rwOfA6EzYq/ziDN1kOiU3ARI5c+zs2ktBfJ9kgDHPo8AgvTom3q
 2XDMB0AC7r4cCB6ULeMjhAdk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 04ff1534b9e29b12;
	Fri, 13 Nov 2026 00:22:30 +0000
X-Mizu-Trace-ID: 04ff1534b9e29b12
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
From: Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <avYJ-CxBEpdO1Wmu@gremlin>
Date: Thu, 12 Nov 2026 16:22:18 -0800
Cc: sashiko-reviews@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
 =?utf-8?Q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
 Borislav Petkov <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
 Dennis Zhou <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-Id: <49B1B6F1-86DF-4472-970A-055E1DFD8808@linux.dev>
References: <avYJ-CxBEpdO1Wmu@gremlin>
To: Lorenzo Stoakes <ljs@kernel.org>
X-Mailer: iPad Mail (24B119)
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: czg3o7qyrn5hg8tiunria5jc46x1qrjz
X-Rspamd-Queue-Id: 5DA212000A
X-Rspam-User: 
X-HE-Tag: 1794529353-337959
X-HE-Meta: U2FsdGVkX1/DyxmmcIx8mdwQU9q6Jz6CFpNvKGw9Qj7L97D5Y0KgbZYWLwXkFvJWxp3LN0rUm6yJaRc6BZBKOQgbom0z39wyOGHNzJoUr9uK1tNjkXkqFoDkjFh2RZiI1BwruXlpw2Y3xKKPL4xQmw0LVFMQblHMJrcSsukDcM4uCxjwG2SvHf289EmWUn5Tl8CGO9ak7soszxxRqvtG71BudrjAI9WInhiI5bK9rpVlqo7PGnZCcX4tVARLP9mpg0GLw4GNXr6INAmqKq5fUZKdD2RgabC/xrDd1DZH2dB7P0W8yCRUgIJldj+hYvVuw9HhH2UYDFWNRKB319JLX2MiUt/fQSzo04lgFLpH0gQXkxfqMeo8QAkXWJ9wZ9ysG/L/l4TWCQr8dVYNugfaGrzk8JTDGXmgTjDfwiuQ+AgRyu4yyKskhIzh77bg3msn5tm7RweiqGbOA8T68oopk/a2QrG7cHADvZQ2PJi3h2ZFobvLAWsuG7P2QTZjRbIes78F+X8SzgnjtZAH6tvJbWAL1A9M4lSAx47sZBMD50d+ihlOXEXSgFx1Wd5C64mMJ13kvSeLkPQzaMU3q+y+vz9rTxJRfEqS2HokA93D1Z3wP48Vm9SmM5uEgD9tsb7AF5I8nNMK58eoZXwRje5WyoDNNtTwj9taJ64NVSFxElggbNhyPCJomRYUpKDGLJUG607ilqiu0vxzj+HG2aSbhWqCVCtEaoOiolFdAPpf5jomCn/JO8Hc8BZGfen4st8ZTIdFC+rgFtjM+a74qsnMXrgCgBNiAqzMrUV4/6lzK0j9HrgLeh+ULhrW69/4DQU6+7+0E0SsbINllkt72xEkvdrlhws7QX3NdBGB3ymFkU9fZj2zE+f09Hf+/PHxjxhb2t+v7THVWYM7u//djI6tD9uSlsJfc6Kcpy/uEx7qREkV0VoyGg/wAa5HAX/o8Co0WkDsxvvAoiWEKOrEAzR
 fb9gDi9d
 meLJRAIgcvUtCSqu35RBuPeTCYJLLDpnhXrg29AWhNQ2B7+qenm+Jb9xVSRQoBlcnfon2gA1CrgItHK4Dtaz+CaaYxo54vtPlWkE/LHPKS6or1BgLBwD1KfjblHKOCCUB/pn13s6NVWpzBlzlAMpMvHfTBLfMXHyQzb8KLWH+DEffjduFq0j83NhpJ1eljBRfRv/naNkN7I6pW4O0VJ1Sa5xHAIVzU1hgKyP6jf0i4j3XP6KTpDrp9Gsd8jj22O2LVAExmy8wAJq2MXNDjrxcNilQplIEDjcGO/ncJxBUv6PM8PI8/dc4KHcOx7vi/Nl8QBxYMfQF7Hiv5+IPhuhIm8i/yH8q+MndITF50CH1jhDM4DdVwzAAJcKLNe/TRGbqHz6I1Dwm7A4Hn+YLWGRGD4rlBq61EpfaCAtZm1rNGEQ9VBnkZIi1F+WiyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> On Nov 12, 2026, at 11:03=E2=80=AFAM, Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>=20
> =EF=BB=BF+cc Roman
>=20
> Roman - see below - I was under the impression mm was not supposed to rece=
ive
> 'unrelated to this patch but' reports? Did something change?
>=20
> Thanks!
>=20
>> On Thu, Nov 12, 2026 at 06:16:31PM +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found no new issues
>> in this patch, but noticed 1 related pre-existing issue it does not
>> introduce:
>> - [Critical] mm: out-of-bounds write in migrate_vma_setup() [1]
>> --
>>=20
>> commit a0bf8430c5e68cd904038ab8081c7bc9a9b0f7de
>> Author: Chris Mason <mason@kernel.org>
>>=20
>> mm/migrate_device: refuse to migrate shadow stacks
>>=20
>> This commit rejects VMA device migration in migrate_vma_setup() when the V=
MA
>> has VMA_SHADOW_STACK set.
>>=20
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 0f2a2832e0bd1..c27f513ee46e3 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -759,6 +759,8 @@ int migrate_vma_setup(struct migrate_vma *args)
>>>    /* The migrate_vma page walk has no hugetlb support. */
>>>    if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma) || vma_is_dax(vma))=

>>>        return -EINVAL;
>>> +    if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
>>> +        return -EINVAL;
>>>    if (nr_pages <=3D 0)
>>>        return -EINVAL;
>>>    if (args->start < vma->vm_start || args->start >=3D vma->vm_end)
>>=20
>> [Severity: Critical]
>> This problem wasn't introduced by this patch, but can migrate_vma_setup()=

>> write out of bounds on args->src and args->dst when given unaligned
>> addresses [1]?
>=20
> I don't like big buts and I can deny! As above, I thought we disabled this=
?
>>=20
>> mm/migrate_device.c:migrate_vma_setup() {
>>    const struct vm_area_struct *vma =3D args->vma;
>>    long nr_pages =3D (args->end - args->start) >> PAGE_SHIFT;
>>=20
>>    args->start &=3D PAGE_MASK;
>>    args->end &=3D PAGE_MASK;
>>    ...
>> }
>>=20
>> nr_pages is computed before args->start and args->end are masked with
>> PAGE_MASK.  For example, if args->start is 0x1fff and args->end is 0x3001=
,
>> nr_pages is 1, but masking rounds the range to [0x1000, 0x3000), which sp=
ans
>> 2 pages.  When migrate_vma_collect() walks the aligned range, it writes p=
ast
>> the end of the caller's args->src and args->dst arrays.
>=20
> This is silly. It's not critical. Nothing in-tree does this.
>=20
> If internal kernel stuff does incredibly stupid things then incredibly stu=
pid
> things happen. We can't nanny everything endlessly.
>=20
> A monolithic kernel means that the function and its callers are considered=

> together.

Agreed. Let me try to fix this to stop reporting problems like this.

