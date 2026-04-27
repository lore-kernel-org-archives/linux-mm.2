Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D08FF885D
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 02:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6FB6B0005; Sun, 26 Apr 2026 22:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78376B0088; Sun, 26 Apr 2026 22:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D6E6B008A; Sun, 26 Apr 2026 22:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B63756B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 22:45:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0448A12068B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 02:45:05 +0000 (UTC)
X-FDA: 84702793812.23.E032AE2
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf19.hostedemail.com (Postfix) with ESMTP id 000891A0007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 02:45:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JaDKlWAX;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777257904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYl/EI6HUrKkXy66gKXetGu+BfOANz47rhqED+fRSzU=;
	b=5Ni902e5AFB3Ar5KTSiBhGE978tbQzrZLJwyMcmf/BbC8lo05BB0+spR18nP1hvVFv+nnZ
	uEzWUZC4W22UXaWZTO4IVHvrexf8mFLLy9G2DhgObN6HI2E4xY8BJwoyFMJApdLeoi+ykv
	ZgAXDJdlLnBuAaxM3S21ySS7ZWyThIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777257904; a=rsa-sha256;
	cv=none;
	b=e/GqThewxm1ecA9uOEpaRltbjnG8G/FFuRXkDXXIXO3+ql4l7Z9sMm2G101OJYz+qf+rtC
	kYFl6CLDEt3u3JKnf+gWAhzP2OU3pmfi7oQ+ulaEAf7HKVLatQGH1P7SsLmTQFNWnZapmd
	mLIu5dMEiBh7FWOjPDx5qHios/EjcH4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JaDKlWAX;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XYl/EI6HUrKkXy66gKXetGu+BfOANz47rhqED+fRSzU=;
	b=JaDKlWAXp2AGsZ7JdIIvish4dDgPf+AXd1JZpzMRqxq/L1qudEp1YvSy+qdvVuWRLUSCuVDyG
	oiCEAOP/DnqWFtEsI4kZCdzKyMLTvJnUmqY/93+ZbK3BGpjQurWOBw/iZ3JHcmp0bWUxjt8aKgt
	Hm/B1QmUY2za+ndqvD6ISxQ=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4g3nn31XhpzRhR4;
	Mon, 27 Apr 2026 10:38:31 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id A905540569;
	Mon, 27 Apr 2026 10:44:56 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Apr 2026 10:44:56 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Apr 2026 10:44:55 +0800
Subject: Re: [PATCH v4 2/3] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-2-2d0277f8f601@debian.org>
 <6b505601-747a-0812-7544-63a8ab3cffce@huawei.com>
 <aejlg62nxcF_5g2v@gmail.com>
 <c1517ad3-91d1-2ea1-efa7-0f29415d513d@huawei.com>
 <aeta8Ifvmqi6-E8w@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <5e05384e-740e-b374-2370-01f96d1dac9f@huawei.com>
Date: Mon, 27 Apr 2026 10:44:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aeta8Ifvmqi6-E8w@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 000891A0007
X-Stat-Signature: g8fre95p7m84ker9t1nyqamhnzjuz73d
X-Rspam-User: 
X-HE-Tag: 1777257901-184969
X-HE-Meta: U2FsdGVkX1/YRgA7o732aVMZ7FasrJgKGeKqxE92NGQbTg/0cejrWhFPTf4Bde5xxIiSYQoBhB3vyrwRIO3GmD1f5NGujfM2fEwd58LhnG81N9f29ynTYgfwixhmTKsxw1uKugcs9NMXJr6eKv35DFNirCa7LvweUIkpDGXgO5oVwpIOo+1FJnF1Uk7wyOBN+pEyjG3Rt5K2kAuM7pwus+A+q472X+n0ExKrqWFBk6RBt2m117XIHoSPfqHVxWpc3SJxW2Z0uNph072602CdknSTt9DdeyU6zKWMtddWaNSfe7W0rsFlnQpZOfvP4RDVdjT5XS9HMjPtjeYQFo5j+lvsPjJL4utJENU6mInPEFHgD5xsZRavpx8vOtkSipv4oG/enQRN45D3IoZ3x8uW256XAwQS1pMFhSATa827zmHowz6VIK0cMoHMWydKvH7xpISrf173rCs38nUoYYslGKRaikK9l791fF2lvFrD18VG/NP9YJ8r9FnSW7SfoZqr/RKXHW95KhPGC+lBv2LDEJFDx83D/5b3awTMkqVbhxh9oeywq3ySDufy8rJ9KPgkCz29w1yeY7HzlEXeO/03z/Q9iTb9eVk/s7nXB95BNpEt433/KVlQxCNqndCdcrK837vBtJ6SnQ83AXR4oIJq2Ohij4hoLg2Jm5FhwrkY10wBFQlNoQviwz3bggNtntJC3jko0Q6fniw4BKGIojMNOg20g2zYkiHvSG8jcTDK6CC+g/ZxfY81X2sJD3mXJwTxvDbfyg9Rf0hH+iuxkqrZ1r4qjBZnyZAVG+jhICpZet78n9+ooDjJCUt5Hu78Uc6b9Qt+AfH6UfGBwZXU3K2Au/fMO0ssxca0Ges21+iSLwTI7hxaW6x7D9nX1TXijxcrC+gUE25pQEy0tCfby4RbR6atvOgojANxoWuvzmfX4OFe3WY3Zh5wmQWw7VtyuH/a8lJBbWZnRVvMcx2INZF
 vsVBMAk9
 9eCXMPm4PtVGoehhaLuPDKPpEK+Q+/noGG7l/G0o0gndJewjwBgP+EuIEAnf7pSvjyEFZ+t6pAgCGLXaIIQY8X4WzwpZ75AE5JP796P17jXvKwgr0CkdIz0OmLGsSjLjyqKmDqsTzT8j5XDRheG3EcYgNHF1HD1NHdtSWGFrLi6z6smFLT1vkmir87a/episqLugfrLU5P15d0LhaDoDCDC/PiS1J6qM91Eb76HqVgODEaS5v9yOBbuGkeTBaLiUiNF/jh19rRNTDwHukhqLjdJiNCxeuzYjWx4kcG1+U+ogvWZUoIDcWFO9HBmsxoW2UmniFBO5DhYKntvHYg8nuhUbqFf+8y0Zho1WckaknXZnB0wucy0cKnyXb8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/24 20:01, Breno Leitao wrote:
> On Thu, Apr 23, 2026 at 10:38:19AM +0800, Miaohe Lin wrote:
>>> are you suggesting I drop MF_MSG_KERNEL_HIGH_ORDER from here, or, document this
>>> will not hit userspace pages?
>>
>> No, maybe we should rule out or document above rare case if I'm not miss something.
> 
> Good catch. A buddy page being concurrently allocated to userspace can
> briefly satisfy get_hwpoison_page() == 0 && !is_free_buddy_page(), and
> that page is recoverable via the standard SIGBUS path — panicking on
> it would be wrong.
> 
> The page allocator can't filter it out either.
> 
> check_new_pages() is gated by is_check_pages_enabled() and is a no-op
> when CONFIG_DEBUG_VM=n.
> 
> For v6 I'll try to rule out the race inside panic_on_unrecoverable_mf() so
> action_result() stays unchanged:
> 
> 	case MF_MSG_KERNEL_HIGH_ORDER:
> 	p = pfn_to_online_page(pfn);
> 	if (!p)
> 		return true;
> 	cpu_relax();
> 	return page_count(p) == 0 &&
> 		!PageLRU(p) &&
> 		!page_mapped(p) &&
> 		!page_folio(p)->mapping &&
> 		!is_free_buddy_page(p);
> 
> 
> A buddy page being allocated must transit rmqueue() → prep_new_page() →
> post_alloc_hook() before the caller can use it. Each step either bumps
> _refcount or sets state we can observe (PageLRU, ->mapping). cpu_relax()
> lets that remote-CPU progress become visible before we resample.
> 
> A genuine non-buddy high-order kernel tail page stays unowned across the
> recheck, so the panic still fires on the case this series targets.
> 
> The window is much narrowed now, not eliminated — I'll say so in the changelog.
> 
> I also added a selftest that enables the sysctl, injects MADV_HWPOISON
> on a userspace anon page in a forked child, and asserts SIGBUS (not a
> panic). I've been running this in a loop for hours, and I haven't seen any
> false positive.

The userspace anon pages are already allocated. Those pages are in a stable state.
So your selftest cannot test above window. Or am I miss something?

Thanks.
.

