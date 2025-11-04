Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB23CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 03:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14BA8E00E3; Mon,  3 Nov 2025 22:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6AD8E00DC; Mon,  3 Nov 2025 22:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB0C8E00E3; Mon,  3 Nov 2025 22:44:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8ACAE8E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 22:44:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 375BD13AABD
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:44:11 +0000 (UTC)
X-FDA: 84071531502.10.A89491F
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf09.hostedemail.com (Postfix) with ESMTP id 36F1A14000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:44:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hBFzAFez;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762227849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mI5NZzwX6x6xO/W1T3LkO8z5F3lpSfn/IETM235fG98=;
	b=QWH/5AcCrsRGEZj0N6w+jIGGAjyfMUSPhh4etkloloPDlxBVyogpZC8EOqeZEryhI8FSbq
	4h/2PxUCwBvRxm1iSaQF/51l2TNPz92gulhCLcJNhZSpNyl3Vly1Mf3Kuol+hkSS7qCVes
	pS0XtSrQF2LtQs87rFz+4Cg0pQZ/GVw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hBFzAFez;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762227849; a=rsa-sha256;
	cv=none;
	b=JVDlmhyVShtVm2oL/0Z938IEWogZNIf5RPgsuUqWZFNQ6Fgzb7/EfDcVmOe89gt8saSF5/
	2gL0h1KvcgDBkHOO27zOfHSlsyXT9Rgm5Vxg8GsMMT9Hcs0w2xtQzROtcsv76LCheIZXAt
	hG8yqzIjEG2iycEiP54SFW/o0tA+0yY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mI5NZzwX6x6xO/W1T3LkO8z5F3lpSfn/IETM235fG98=;
	b=hBFzAFezSw5JUCqYW5mq4lqx75pi/JseqBGO1dB9WuIWOkL3yRPZ07q09rs6isMru3p+tiNC7
	GjC2VM3ts7O8bU6uaEZHyqT2D6IHqU5GpI7oS18Jut473ONzsEfaZ6qzrtQmQ0oL3x3FZ64ox2k
	v1YpxsgeVzQICoCb8/hW3uk=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4d0vR829VdzmV6Y;
	Tue,  4 Nov 2025 11:42:28 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E19A51400E8;
	Tue,  4 Nov 2025 11:44:02 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 11:44:02 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 11:44:01 +0800
Subject: Re: [RFC PATCH v1 0/3] Userspace MFR Policy via memfd
To: Jiaqi Yan <jiaqiyan@google.com>, Harry Yoo <harry.yoo@oracle.com>
CC: =?UTF-8?Q?=e2=80=9cWilliam_Roche?= <william.roche@oracle.com>, "Ackerley
 Tng" <ackerleytng@google.com>, <jgg@nvidia.com>, <akpm@linux-foundation.org>,
	<ankita@nvidia.com>, <dave.hansen@linux.intel.com>, <david@redhat.com>,
	<duenwen@google.com>, <jane.chu@oracle.com>, <jthoughton@google.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <muchun.song@linux.dev>, <nao.horiguchi@gmail.com>,
	<osalvador@suse.de>, <peterx@redhat.com>, <rientjes@google.com>,
	<sidhartha.kumar@oracle.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <willy@infradead.org>, <vbabka@suse.cz>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>
References: <20250118231549.1652825-1-jiaqiyan@google.com>
 <20250919155832.1084091-1-william.roche@oracle.com>
 <CACw3F521fi5HWhCKi_KrkNLXkw668HO4h8+DjkP2+vBuK-=org@mail.gmail.com>
 <aPjXdP63T1yYtvkq@hyeyoo>
 <CACw3F50As2jPzy1rRjzpm3uKOALjX_9WmKxMPGnQcok96OfQkA@mail.gmail.com>
 <aQBqGupCN_v8ysMX@hyeyoo> <d3d35586-c63f-c1be-c95e-fbd7aafd43f3@huawei.com>
 <CACw3F51qaug5aWFNcjB54dVEc8yH+_A7zrkGcQyKXKJs6uVvgA@mail.gmail.com>
 <aQhk4WtDSaQmFFFo@harry> <aQhti7Dt_34Yx2jO@harry>
 <CACw3F503FG01yQyA53hHAo7q0yE3qQtMuT9kOjNHpp8Q9qHKPQ@mail.gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <425edf39-fd51-cf99-9608-34ee314486a6@huawei.com>
Date: Tue, 4 Nov 2025 11:44:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACw3F503FG01yQyA53hHAo7q0yE3qQtMuT9kOjNHpp8Q9qHKPQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36F1A14000F
X-Stat-Signature: oemopzjmgt7nmnd6ibyiac7n366ddtqh
X-Rspam-User: 
X-HE-Tag: 1762227847-621660
X-HE-Meta: U2FsdGVkX19GqMRf8kXZy9AzjDkquS8fYbjOiw3qPrJZeb8x6mEKPd5r8aZKlCLlmfGWsrpEXaZggh7Hwfa1dv+IE3zVgUwJcGYLj9Omdphkg/Vs2YGlgpWjQZDqe5yhqIDA4YjD8xI2/F5Fne/R7jFiojuEUs7gcQHguM/af5f2bTKwNJVdZ/1gBV3drVpv7r2P3JxFli3c1VF7pllvbkI+ICEwCmf8pjLGIuz8hdlIgT8p1A8ZUkw0GacDWkJCaf2f1AWffBI+4ydNTQpKBO2fCbqoSHR95qK/NT24JdfRBYBMyoWMVMD93TLX+qbtKhgRRPt+/29tbcazbAhnAl5dmOU84Njb3/YBIdnhBbUig9pIL3Euf52XC/INS3X8+1arGHuiLig3rsannlN1H1awrAiUhLDjmcesD2QG+PhWeuOx9GhX9ueqnZ62ILkpsST6h4KaGSiPWFt7o/TWZXNbpr5GBzwxKCJRgrzOsTzj2yLMsiTfeH9Cclbn1rSaR6Z99YjtkG9SphYwtieacv1/t0iroeRnya7eJ7c0ahd1vmRu1t7kSas734zVZz7NkkJDYHP3R8hYhS08inVmldZvn456bRQEO3v/ow3YOW+IgZ8UdluK+/KuVJKx8IVVsfBxY+5fZMTwPF0JDR56LvjV4ynd63o1n6E5lEaenFLI+uswtfmnk9mdpUwxv8Luy7rjb8ljSeuWHvXjsqrJgcS35MDsHnyo5M6/ak0RCl770kKCbOCWFq5RQE2OQsPmsltMnvmC8Wu7sReiimBDm5CwYsIOUDjFkodw7B1PIs9yw1NUkxvbwHR0eRuRqe5fjvNPpmHsU5YDPgAUtRS2ggLoakIabIt3UBdoYhL18rxf1I2OXovkkSsDf8n7Z1/IPcPgbwytx/4G5V6Yp2ZIOCKf2p1bU46A7Ki+HtuYPGDMymuExrK+P/1yxyLyDhyyvVzPdHCxxzjl3qNX0xD
 GHEURBuX
 QddHSc9LNlVAsd0E3h9+1+Nkr64AcR3bGM0DQRfTaHEyjbNclAJvaaY+FRdtTd1Xo7Wogor2BRCNDbCVlY5xuqYVDezve8l/tCdlJ3gskg0V3DtfDz50iJ3V0SiFSheQzYPYN4ytOKS8S20ErzmpqD4be1T2fAKPq3IYhOen9CoPkxjmxGDQAbEXaA6nim0Mqb4sNs6qYx6ZH5H3JiXJPYaT0f5hDlqBqQ21l+XvBTOBuPmc485LtTErWHmDFFuzsmsJRVBJy13JnLqcHGLFV1ABq/raWRseaa58NsIxxF1AUgGCensXYdfaHHCth9Jp/tFhR0zVdw9dPIy310zQQ3VxqHagNEijYptSYMK+Kqg9AJpWq/FwRZLFHTjqNJYQA1qe4FH9n+eB2xabdi3/Oi9raxTDuigkrEZFAtfW3E6VSRrdVsKRuS3eWb6vzXVicBDmSw5qWA7qFf1z+DAZwwLbSR+vhXzvKRAHcifYjh3gssssgOFBzqLlFmC06C7ICo6db
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/11/4 0:57, Jiaqi Yan wrote:
> On Mon, Nov 3, 2025 at 12:53 AM Harry Yoo <harry.yoo@oracle.com> wrote:
>>
>> On Mon, Nov 03, 2025 at 05:16:33PM +0900, Harry Yoo wrote:
>>> On Thu, Oct 30, 2025 at 10:28:48AM -0700, Jiaqi Yan wrote:
>>>> On Thu, Oct 30, 2025 at 4:51 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>>> On 2025/10/28 15:00, Harry Yoo wrote:
>>>>>> On Mon, Oct 27, 2025 at 09:17:31PM -0700, Jiaqi Yan wrote:
>>>>>>> On Wed, Oct 22, 2025 at 6:09 AM Harry Yoo <harry.yoo@oracle.com> wrote:
>>>>>>>> On Mon, Oct 13, 2025 at 03:14:32PM -0700, Jiaqi Yan wrote:
>>>>>>>>> On Fri, Sep 19, 2025 at 8:58 AM “William Roche <william.roche@oracle.com> wrote:
>>>>>>>> But even after fixing that we need to fix the race condition.
>>>>>>>
>>>>>>> What exactly is the race condition you are referring to?
>>>>>>
>>>>>> When you free a high-order page, the buddy allocator doesn't not check
>>>>>> PageHWPoison() on the page and its subpages. It checks PageHWPoison()
>>>>>> only when you free a base (order-0) page, see free_pages_prepare().
>>>>>
>>>>> I think we might could check PageHWPoison() for subpages as what free_page_is_bad()
>>>>> does. If any subpage has HWPoisoned flag set, simply drop the folio. Even we could
>>>>
>>>> Agree, I think as a starter I could try to, for example, let
>>>> free_pages_prepare scan HWPoison-ed subpages if the base page is high
>>>> order. In the optimal case, HugeTLB does move PageHWPoison flag from
>>>> head page to the raw error pages.
>>>
>>> [+Cc page allocator folks]
>>>
>>> AFAICT enabling page sanity check in page alloc/free path would be against
>>> past efforts to reduce sanity check overhead.
>>>
>>> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net/
>>> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net/
>>> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>>>
>>> I'd recommend to check hwpoison flag before freeing it to the buddy
>>> when we know a memory error has occurred (I guess that's also what Miaohe
>>> suggested).
>>>
>>>>> do it better -- Split the folio and let healthy subpages join the buddy while reject
>>>>> the hwpoisoned one.
>>>>>
>>>>>>
>>>>>> AFAICT there is nothing that prevents the poisoned page to be
>>>>>> allocated back to users because the buddy doesn't check PageHWPoison()
>>>>>> on allocation as well (by default).
>>>>>>
>>>>>> So rather than freeing the high-order page as-is in
>>>>>> dissolve_free_hugetlb_folio(), I think we have to split it to base pages
>>>>>> and then free them one by one.
>>>>>
>>>>> It might not be worth to do that as this would significantly increase the overhead
>>>>> of the function while memory failure event is really rare.
>>>>
>>>> IIUC, Harry's idea is to do the split in dissolve_free_hugetlb_folio
>>>> only if folio is HWPoison-ed, similar to what Miaohe suggested
>>>> earlier.
>>>
>>> Yes, and if we do the check before moving HWPoison flag to raw pages,
>>> it'll be just a single folio_test_hwpoison() call.
>>>
>>>> BTW, I believe this race condition already exists today when
>>>> memory_failure handles HWPoison-ed free hugetlb page; it is not
>>>> something introduced via this patchset. I will fix or improve this in
>>>> a separate patchset.
>>>
>>> That makes sense.
>>
>> Wait, without this patchset, do we even free the hugetlb folio when
>> its subpage is hwpoisoned? I don't think we do, but I'm not expert at MFR...
> 
> Based on my reading of try_memory_failure_hugetlb, me_huge_page, and
> __page_handle_poison, I think mainline kernel frees dissolved hugetlb
> folio to buddy allocator in two cases:
> 1. it was a free hugetlb page at the moment of try_memory_failure_hugetlb
> 2. it was an anonomous hugetlb page

I think there are some corner cases that can lead to hugetlb folio being freed while
some of its subpages are hwpoisoned. E.g. get_huge_page_for_hwpoison can return
-EHWPOISON when hugetlb folio is happen to be isolated. Later hugetlb folio might
become free and __update_and_free_hugetlb_folio will be used to free it into buddy.

If page sanity check is enabled, hwpoisoned subpages will slip into buddy but they
won't be re-allocated later because check_new_page will drop them. But if page sanity
check is disabled, I think there is still missing a way to stop hwpoisoned subpages
from being reused.

Let me know if I miss something.

Thanks both.
.


