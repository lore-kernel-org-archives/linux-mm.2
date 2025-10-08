Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B945CCA472
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95F968E0024; Wed,  8 Oct 2025 08:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9373E8E0002; Wed,  8 Oct 2025 08:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873D48E0024; Wed,  8 Oct 2025 08:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 765BD8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:49:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C1A1160530
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:49:47 +0000 (UTC)
X-FDA: 83974928814.26.06C723C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 52ED6140003
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:49:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759927785; a=rsa-sha256;
	cv=none;
	b=nTuglW4Yfw1WY+iov3KCl9Kemne9VEWf1NOdCylZX+6NcQKbHMPH2wg5b7BbtOP47Ji+eN
	bc7Vu0/CwXO0aUdBGTN3SCsq7gr2UWjxfdHit2z+gb29eXP0+nx7xmgAccm1eCdYp2t55J
	Gs3DO4sj+FrCMzvqRYWvhU6MzL5TZ0s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759927785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vwo6jSsWh0LZkP/HfAfvawCuyjk8gpqlk/W8PXUtBKI=;
	b=QVBL3GNMR/NMFPykOT7lBWgX9TOfDgG7FIwMaNYpMkvcM96f/1MLIhib6j/bOqUFJjYBaE
	snrYN0PUdN06bP/qpZiIuiN1Jgv7xKeBcYaK0G9FxEKgQljp2xIZVBfzv5A80fdauJuQZn
	jq4Gn5vcUIF7+iqp5Xn+YfLbONHAuyk=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4chXnB34qkz6M4Zx;
	Wed,  8 Oct 2025 20:46:22 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F15E14033F;
	Wed,  8 Oct 2025 20:49:41 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 8 Oct 2025 15:49:40 +0300
Message-ID: <1940d681-94a6-48fb-b889-cd8f0b91b330@huawei-partners.com>
Date: Wed, 8 Oct 2025 15:49:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>, Zi Yan <ziy@nvidia.com>
CC: David Hildenbrand <david@redhat.com>, Alexei Starovoitov
	<alexei.starovoitov@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew
 Morton <akpm@linux-foundation.org>, <baolin.wang@linux.alibaba.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Liam Howlett <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<usamaarif642@gmail.com>, Matthew Wilcox <willy@infradead.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii
 Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, David
 Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<21cnbao@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo
	<tj@kernel.org>, <lance.yang@linux.dev>, Randy Dunlap
	<rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>, linux-mm
	<linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
 <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com>
 <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
 <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com>
 <CALOAHbD_tRSyx1LXKfFrUriH6BcRS6Hw9N1=KddCJpgXH8vZug@mail.gmail.com>
 <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com>
 <CALOAHbCS0WvUSsK_rbtU8LTLuz_eynVEa1ULyYmyRcMW_hfZWg@mail.gmail.com>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <CALOAHbCS0WvUSsK_rbtU8LTLuz_eynVEa1ULyYmyRcMW_hfZWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Stat-Signature: 46nta39jnmxdccoith7gtpcaurh3rtsr
X-Rspamd-Queue-Id: 52ED6140003
X-Rspamd-Server: rspam09
X-HE-Tag: 1759927784-357958
X-HE-Meta: U2FsdGVkX19Nxtnh4hxBKQn0vVK32Ug/W+inLTzMRHsGQhTUD/WMFexM1mOZug049Xh2v+iDlMhz6r8KLk37sLTkAdUagLq2vbaqAl1F1xqDNudt8LrbaX82mU2NH7WG5E4OIy5RsadZOPjGYMcZ0emh/xLIpaLYnNInQpxDypeCLZpsIFVhDLXh9LA6lAmqh34IbePZQnDRJxsAWjEoYQ782y21939XynlpWyqHEWo20HppBNYHssZ5dI+DOocV4I+wDSVdwWp0oNcVUSdb1r/p9wGb+fzB01CJRHMr0Vgt6+23L09uJfSXUpPk4PZLLjHuXD1saYk4bKAu7VLTSaEQHL49m3b6k63MKfMBcruWliLtYt1i6V177gBsc8r2tVbzC6dOuD1kKLYyd5IlV61S1TOzy5UxM3e4UMlhCxBDnwo7OekDkoFdmSe04tYP4/BJ0SMEHgAEv920LNxK+eYotEWHEpM6xuidvLlenWfygXgUhc310tJpkPta4seXY3dGLdjwbbfNGt0mk+bormSrrkiYO6JEsTrrZpcrEtSwgOou82KGuQI5TFt8Sw6Lu27s1zF8Mdq0z+PyfVrCLnxM+NJFeIHXL12OlbLSJhXQ3U6t02+MLnxyJLF1z7G1xg5Od6gozQvlBVtcsTpJ7HEQhy2b8lLvfus23B48QToCFRI70NkeFTfEZWVLcB/BlCv45wJ2QUKwxLHZMH5q1Vp7oUXkOSDo31y7EVpjV3lAJ+7Ep9f62cjoAZC071nS+JCmxEsT+8ndKvL123w2ySMuRAgn8iq4ABYil4KzSo7dcsTr3atXZbNfU2h7ZjtW0TLX1EYLbUUrcyFMkLghq10dgZVExsGqCz+Pd8nh5rEHC3dvDnuqeY8Xxr18BTsMEDuzhKWavorkrl3hQC5mrf5bcbfozdVtWRGobUAVXZ5zLRWiMsuaanm9TrXP5wGO7QjTbdDaFppjYd37d4S
 u01jXZLD
 Nl3NJZ6zjQOEVuTENtoQ1thyhbvjTkE0K5wOImua2b3q292SkVjNaYzO0XhZ4dEEKOQWzhjj/RCF/0x1jTlYmAeOpq7wbGhOzJJjErUVDCfH3zGqAZ/9Kn2Tk29zrnVfybakyf4mKdDMGn4zmMc53Rk2G+ZP8EoXk2FLoMZvX+nq0DMn9IasJy4EnqcvMtcoDhbg4ZrpfHFXaYIB4kkB1+BaO2qoKzFttbK63wsa06ekuGZp5DK9ybz129N6XFO7VzJCAENmVOusCdX8rtJQ9aMds50dhb7QC09Pi63W7NpKAnfwK/aSraboMdWeKgkvQbOj1Fne6x8pfL09c9hzNjtbqt5i3shHoZP1zjEHSUz9VDItT79+zmJ86MDubp+PfxWopqIZMZbEtK2jyvxidDYByi+tnc7gwDI3U3HSFZips3Jg7fjLfkxU1Oh6vB5LortnwLU0FUniYBG3q3uGBmqEBjoa0ZbdHvRzs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 10/8/2025 3:06 PM, Yafang Shao wrote:
> On Wed, Oct 8, 2025 at 7:27 PM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 8 Oct 2025, at 5:04, Yafang Shao wrote:
>>
>>> On Wed, Oct 8, 2025 at 4:28 PM David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 08.10.25 10:18, Yafang Shao wrote:
>>>>> On Wed, Oct 8, 2025 at 4:08 PM David Hildenbrand <david@redhat.com> wrote:
>>>>>>
>>>>>> On 03.10.25 04:18, Alexei Starovoitov wrote:
>>>>>>> On Mon, Sep 29, 2025 at 10:59 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>>>>>>>>
>>>>>>>> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
>>>>>>>> +                                     enum tva_type type,
>>>>>>>> +                                     unsigned long orders)
>>>>>>>> +{
>>>>>>>> +       thp_order_fn_t *bpf_hook_thp_get_order;
>>>>>>>> +       int bpf_order;
>>>>>>>> +
>>>>>>>> +       /* No BPF program is attached */
>>>>>>>> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
>>>>>>>> +                     &transparent_hugepage_flags))
>>>>>>>> +               return orders;
>>>>>>>> +
>>>>>>>> +       rcu_read_lock();
>>>>>>>> +       bpf_hook_thp_get_order = rcu_dereference(bpf_thp.thp_get_order);
>>>>>>>> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
>>>>>>>> +               goto out;
>>>>>>>> +
>>>>>>>> +       bpf_order = bpf_hook_thp_get_order(vma, type, orders);
>>>>>>>> +       orders &= BIT(bpf_order);
>>>>>>>> +
>>>>>>>> +out:
>>>>>>>> +       rcu_read_unlock();
>>>>>>>> +       return orders;
>>>>>>>> +}
>>>>>>>
>>>>>>> I thought I explained it earlier.
>>>>>>> Nack to a single global prog approach.
>>>>>>
>>>>>> I agree. We should have the option to either specify a policy globally,
>>>>>> or more refined for cgroups/processes.
>>>>>>
>>>>>> It's an interesting question if a program would ever want to ship its
>>>>>> own policy: I can see use cases for that.
>>>>>>
>>>>>> So I agree that we should make it more flexible right from the start.
>>>>>
>>>>> To achieve per-process granularity, the struct-ops must be embedded
>>>>> within the mm_struct as follows:
>>>>>
>>>>> +#ifdef CONFIG_BPF_MM
>>>>> +struct bpf_mm_ops {
>>>>> +#ifdef CONFIG_BPF_THP
>>>>> +       struct bpf_thp_ops bpf_thp;
>>>>> +#endif
>>>>> +};
>>>>> +#endif
>>>>> +
>>>>>   /*
>>>>>    * Opaque type representing current mm_struct flag state. Must be accessed via
>>>>>    * mm_flags_xxx() helper functions.
>>>>> @@ -1268,6 +1281,10 @@ struct mm_struct {
>>>>>   #ifdef CONFIG_MM_ID
>>>>>                  mm_id_t mm_id;
>>>>>   #endif /* CONFIG_MM_ID */
>>>>> +
>>>>> +#ifdef CONFIG_BPF_MM
>>>>> +               struct bpf_mm_ops bpf_mm;
>>>>> +#endif
>>>>>          } __randomize_layout;
>>>>>
>>>>> We should be aware that this will involve extensive changes in mm/.
>>>>
>>>> That's what we do on linux-mm :)
>>>>
>>>> It would be great to use Alexei's feedback/experience to come up with
>>>> something that is flexible for various use cases.
>>>
>>> I'm still not entirely convinced that allowing individual processes or
>>> cgroups to run independent progs is a valid use case. However, since
>>> we have a consensus that this is the right direction, I will proceed
>>> with this approach.
>>>
>>>>
>>>> So I think this is likely the right direction.
>>>>
>>>> It would be great to evaluate which scenarios we could unlock with this
>>>> (global vs. per-process vs. per-cgroup) approach, and how
>>>> extensive/involved the changes will be.
>>>
>>> 1. Global Approach
>>>    - Pros:
>>>      Simple;
>>>      Can manage different THP policies for different cgroups or processes.
>>>   - Cons:
>>>      Does not allow individual processes to run their own BPF programs.
>>>
>>> 2. Per-Process Approach
>>>     - Pros:
>>>       Enables each process to run its own BPF program.
>>>     - Cons:
>>>       Introduces significant complexity, as it requires handling the
>>> BPF program's lifecycle (creation, destruction, inheritance) within
>>> every mm_struct.
>>>
>>> 3. Per-Cgroup Approach
>>>     - Pros:
>>>        Allows individual cgroups to run their own BPF programs.
>>>        Less complex than the per-process model, as it can leverage the
>>> existing cgroup operations structure.
>>>     - Cons:
>>>        Creates a dependency on the cgroup subsystem.
>>>        might not be easy to control at the per-process level.
>>
>> Another issue is that how and who to deal with hierarchical cgroup, where one
>> cgroup is a parent of another. Should bpf program to do that or mm code
>> to do that?
> 
> The cgroup subsystem handles this propagation automatically. When a
> BPF program is attached to a cgroup via cgroup_bpf_attach(), it's
> automatically inherited by all descendant cgroups.
> 
> Note: struct-ops programs aren't supported by cgroup_bpf_attach(),
> requiring us to build new attachment mechanisms for cgroup-based
> struct-ops.
> 
>> I remember hierarchical cgroup is the main reason THP control
>> at cgroup level is rejected. If we do per-cgroup bpf control, wouldn't we
>> get the same rejection from cgroup folks?
> 
> Right, it was rejected by the cgroup maintainers [0]
> 
> [0]. https://lore.kernel.org/linux-mm/20241030150851.GB706616@cmpxchg.org/
> 

Yes, the patch was rejected because:

1. It breaks the cgroup hierarchy when 2 siblings have different THP policies
2. Cgroup was designed for resource management not for grouping processes and 
   tune those processes
3. We set a precedent for other people adding new flags to cgroup and 
   potentially polluting cgroups. We may end up with cgroups having tens of 
   different flags, making sysadmin's job more complex

In the MM call I proposed a new mechanism based on limits, something like 
hugetlbfs.

The main issue, still, is that the sysadmins need to set those up, making 
their life more complex.

I remember few participants mentioned the idea of the kernel setting huge page 
consumption automatically using some sort of heuristics. To be honest, I 
haven't have the time to sit and think about it. I would be glad to cooperate
and come up with a feasible solution.

-- 
Asier Gutierrez
Huawei


