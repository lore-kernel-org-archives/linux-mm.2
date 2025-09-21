Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF369CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 11:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57518E0002; Sun, 21 Sep 2025 07:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08378E0001; Sun, 21 Sep 2025 07:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DCE8E0002; Sun, 21 Sep 2025 07:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB2F48E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 07:36:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44CFB119466
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:36:46 +0000 (UTC)
X-FDA: 83913055212.25.01D31AC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 75D7E40006
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:36:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758454604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pG+3Bn5Bmy6Le8Y0IArYxJC5aZl8d85HoBB8fZW6Nws=;
	b=Xb7exexWDU5TLRUbqzznbQ+uvSI+rJFM9WAjpcvLqn736nLoSRetCwpep+XV3277TBHKlb
	isF4xH7gwhnX1rtuhURhmsWKfA1VdtSq15wppC+vg0CgbQhLMTgtZ3cZv+pWQ4kssWfjbo
	EzNKXW90vTf/WCV05f02qSlGFRMZh3k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758454604; a=rsa-sha256;
	cv=none;
	b=v9L3XesR0s8Tsr3XucO2MfeY+RlE+rLgAzXFh9Z1DVO2DkDt+2cgCNXJrS+VE1ZKpkDahY
	Qt4xat9wXgS7NJG5CZlWYypcu4Kr0XWJwFjPY5SnBwDYcruueKbzZkHXY7UGmssmQDblR0
	ke0LsNgmvJ9RqOK92l4nMFH46qSJavw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E54B1516;
	Sun, 21 Sep 2025 04:36:35 -0700 (PDT)
Received: from [10.163.39.139] (unknown [10.163.39.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8DCA3F673;
	Sun, 21 Sep 2025 04:36:34 -0700 (PDT)
Message-ID: <4d2e8686-8810-4901-8483-9b5eb040d489@arm.com>
Date: Sun, 21 Sep 2025 17:06:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: "Luck, Tony" <tony.luck@intel.com>, Jiaqi Yan <jiaqiyan@google.com>
Cc: David Hildenbrand <david@redhat.com>, Kyle Meyer <kyle.meyer@hpe.com>,
 akpm@linux-foundation.org, corbet@lwn.net, linmiaohe@huawei.com,
 shuah@kernel.org, jane.chu@oracle.com, Liam.Howlett@oracle.com,
 bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de,
 rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
 shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
 linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
 <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com> <aMsDJ3EU1zVJ00cX@hpe.com>
 <cd71fac2-bb9d-4e84-a074-2b695654e655@redhat.com>
 <CACw3F52p45t3iSZPjx_Lq9kBn1ZGTDZsxk+iQ-xFA1zdvdqqrw@mail.gmail.com>
 <aMsR4Tr9ov1pfucC@agluck-desk3>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aMsR4Tr9ov1pfucC@agluck-desk3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 75D7E40006
X-Stat-Signature: ax8yjuhr4ngaitzkpryxhga1djzffzuf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758454604-687475
X-HE-Meta: U2FsdGVkX1+xgzjO+CEh5r7aBJbrzNXcHJm+ckU1kLdLO5sT6UYAuQnPgOb3lKv4q/jmvMNxgfaWgkRjSa09Eaj1rkDXwLz9lDjblg9k4o6J0EGGya1S4Pf9Tia/h/pTnyMdwIgaNwb5mUqzmnX+ikCJ3Ey9y4MTGf+EccFTJqY7uf36DNshNJoiGAN4aUfmwZYFqvEs2+qTaS2AaSK1uAgrev2/VOxwqUfe+Jzp32DQKYC6kk+tV40U4npEtSxEK6kzAHzquUSc34EuAsGOOl4+Aj6MYkEPzpXIs36WDHqccS/c1MfoGMEkPY71K/nkY49qTPptFOq2YMtCtgPFSyUI5km1dg89hpDZbejgnb4vy0fDk5OY+d5/BIufT5WC3ZVi7Roicu4p/jy5DkirlCuCtSUeVVDz8MFO7nLYkVx36KnFmH7vK3+DbdKHkRCHwZkLTmiCb8J6MM841QJnkNYZ5y8SshONXEBzg2dwz1phTHj5nkeKVW7SdRqRQHatrm8E19evQY+Ze/xZuqFB4UdZ1J2kMC4DlcgXTp9obK/3rKrRXsUnYRhniNkneIJ9G+VukqusM5aHhnpCdu8gApGtcjfAtA8Zp95GyMnYJ3lnkubHgnz4FaCgtauR59oXMOGxLzc89N8/EAr5nBGMeIAX15KQi7ji8MUJHDC/DwV57usb+DF0GkGU/68boqD3YToFKkLp0pKm6NNJ5FetY0ZY/kCbm0niCtK+Ke5Dtj7XZSG2PXLvA3F9J3c9d5kMR8eiX2XuVgvHcUFmt6UMfjOlV1fg4AdXZ0Njd/XtbO6/REU3b/BWxO9N3LhTqFDR0QwOwk7rJCnwUbX3PTOlDDGVvkNcVT30w57ZvygWws/062fwkuKMkXWWF+omoe/faAq/d9N1ZT54P4wyIXSoYtM4oG3pVbbk/AJ4Sjo4/tzMGKqPXf5sOD3F/i4tNNGiqbRzjjUGElPzCNLXG1l
 EgPYhqY7
 rjfIx2kF8tVhzT1GyUJ2FUyp1AcCWMc595RDA4L7VCLVnfR4BnPZ02x7R9A3nR2wC9ARrAF8Ij7qpUrz24R5KRMSpNY38y6CmHJFpw/0dewJIHe9SJQAUpYtdU88/5JdCCf8URXHfeSencWtjYx6xh+bygwE5+HWDS5y+pVlpyxJxm25ZAeiXEt4a9z9dbtnSLnE4cjWLWnT63SeRxx8d2iu3Iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/25 1:24 AM, Luck, Tony wrote:
> On Wed, Sep 17, 2025 at 12:32:47PM -0700, Jiaqi Yan wrote:
>> +1. Given /proc/sys/vm/enable_soft_offline is extensible, I would
>> prefer a compact userspace API.
>>
>>> would create a new file, and the file has weird semantics such that it
>>> has no meaning when enable_soft_offline=0.
> 
> So the expand the bitmask idea from earlier in this thread?
> 
> Bit0	0 = soft offline disabled. 1 = Enabled (but see other bits)
> Bit1	0 = allow offline of 4K pages, 1 = suppress 4K offline
> Bit2	0 = allow offline of hugetlb, 1 = suppress hugetlb offline
> Bit3	0 = allow breakup of transparent huge pages to just offline 4K, 1 = suppress transparent breakup
> Bit4+	Reserved for suppressing other page types we invent in the future
> 
> Values 0 and 1 keep their original meaning.
> 
> Value 5 means: offline 4K, keep hugetlb, breakup transparent huge pages.

This disable bitmask (but when generally enabled via bit[0] = 1) method
seems much better. But I am not sure about page size being a valid page
type classification though. Just to start with, defining first two bits
in this bitmask should be good enough, which will atleast help document
and validate this new interface properly.

Bit1	0 = allow offline of hugetlb, 1 = suppress hugetlb offline
Bit2	0 = allow breakup of transparent huge pages to just offline base pages, 1 = suppress transparent breakup
Bit3+	Reserved for suppressing other page types we invent in the future

