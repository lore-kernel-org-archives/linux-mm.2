Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38038606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 06:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=2+1C75S9
Received: by kanga.kvack.org (Postfix)
	id 2D17F6B05B0; Wed, 28 Oct 2026 02:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A6F6B05B1; Wed, 28 Oct 2026 02:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1227B6B05B2; Wed, 28 Oct 2026 02:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD66C6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:09:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4595C408B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:09:55 +0000 (UTC)
X-FDA: 85371009150.06.841F6F6
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1141540005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:09:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2+1C75S9;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793167793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7W8QgouVJygAFTU/QOPQhBR1kM7Toq82huy2c/7CAk=;
	b=io9ZTkHef08A26w3rhMvKliB5HY+ViyJX9N8Um72g0nmjEhnPf1TJ9MgiCv5OMeYEb/fqA
	+2BQO+k5aria+iKwIuSCmj35dj4DK5PrGFcC5EV+AOdfWMvPHdFu1ctNvxTiT/Pf/0yYgL
	+iFMgphyYNk9Eiqa8QEe2VeJWuW2raI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2+1C75S9;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793167793;
	b=y1nyCKg752UElEMoIJQ93D1yuqhzlttTej70BLRclfhuGeGZfQUxsmC/IyfRGAt3Xsi7J5
	r2Bb1Z3dJoHiaLH7m7iy8ZclVPU8q4JF6cHWzz2YpDb77RktLKK8mU5zmdy6f0qXXM15Zn
	n74cm5QZ+UY8FvsKGdWmt0JvRte/T1Y=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=W7W8QgouVJygAFTU/QOPQhBR1kM7Toq82huy2c/7CAk=;
	b=2+1C75S9OvsLz5K40sfJSzRlBYdU/BzYWI58tMpRIf+0f0ZK2cOZMkg2juReOBynHPHQxG8TR
	tTmeA6XyS7FmG29CW8JylZa5BKgFqpekjwBkELhjh5GoiGNjizS2oYUG38F/FqoFbE36Y/xgmF/
	PUeGEdiWDebD7k2wBkYX44Q=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jDxld6q7gz1cynb;
	Wed, 28 Oct 2026 14:09:33 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 9C6AE40586;
	Wed, 28 Oct 2026 14:09:40 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 28 Oct
 2026 14:09:40 +0800
Message-ID: <b0fb80cc-4a0d-4612-beef-bf2fc398f06e@huawei.com>
Date: Wed, 28 Oct 2026 14:09:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Docs/admin-guide/mm/damon/reclaim: document how to
 disable watermarks
To: SJ Park <sj@kernel.org>
CC: <corbet@lwn.net>, <skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20261028053525.155909-1-sj@kernel.org>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20261028053525.155909-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1141540005
X-Stat-Signature: nezs6grrf8c94odj8a8e645bsxycnudi
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793167789-732396
X-HE-Meta: U2FsdGVkX1/W1sBy19EKPdAJUJuZIRKPFmCU6BLeRsyxGPVIdutoBv+SfDQRnwmow+fNnP8uRoHLEz2c/59KTdh18QhSjGpaJVdInFyC+aOWaoa+4EEME/C7AyefXpjkwelyCbwlcGKAdfwPkQ/pXPcsz+W5A+UqafHiDp/nYF6sE7Wmg3psK12yrOX+FK98aiIq9meZofbAosHZcZ0Zfl8bKnVb0jaVKqSlCaTumX5NsxTE3yCcHKjW2myzefSD8ctr6RB4lOVvNC02tOhDtl7oo1bzfHqw2zDkdzWkTzUL4S36JPtfghw+Wp/7Z2NIJuOtV6GoUMJcRWeg5pKqJZr8HZnqGBwIis7xMwneT+sx9uTs22HwDLXiUJwB0YoGabO00RFQzkwMyNLFWlYwEDqXA2EY4gzhl+qCBxbs47GgxVtdCGDOAXoWkTfAXywWhmt/7vyf5waWtbjGA8eiND0s8feuzKVdbMmBRVnyXKBvZrZ92IQKFuKJcNlTqbfEsEviX+oEfRwo/wxRwY0wKCG1Yk9XIji7vcSRTawHk3D51XqD4aM56xJNkP64oWWOe6mQDeqrt6Q2QhtYrWaZt1JYh6nvThuI85X6amCtVcERkOA3JS87dvCUOeQ0XhdJmVea1G+BSs10DJ0GNO8tdMcnsBRaS0Vgy0ed/2r3mhJWeNXB7jZIjNXvaHC0bkRyzDjzfFJQvCYtauisE0E+5FoA+/OKL2rWhIObIBcbNVlk1mSB/35c1nv9BOjdMI6kkdwMpSmWIt24rXitlw1OzeQOEkFa6kIfVaghIRRoSpRQQA7cKVfzGuvZryUvV9DVDNW37ZsUIZ23ksn7Bpq8fOlc0ezb36cLRdLXdUN2R24UPJd+i51pT/Ks5p4epUBPMDJBEJcBPXVqjRq9htizW51hXs6CHV8l6E4dism+e+fKN1+xptg0ec1lMrPskANma2HZxEhkIC4RbN49TZu
 TQtfBZR0
 xK3bDmRYb1rmjh/5K9oxnNZX83ogniW1IxCsRnoXCvROua9hs4sbPFD0MgYOWQt6YanyjYIdf7rtSnN2tGM/ehikB8ZCvlrJbqdCsHy/MDFQVn+oKLKXHZgCKFe/4qz64RLsrvFNQ93bHt4m/ytNQCjEgZvqTJ1jbXXpxUz7jVcb5CwazQf28j3zcRNUd8Ea4KwhBzGzOaIAG8rBlnkJn+MhmgAL2YZKatKQWXyMtGAra+HuzLKhxtSB1P+Y0Yq4loQbNaYGPktiBMOmeR5kcv1aLU/7+k3hmqjDicsrgdsF3F5fBpSinGerWcF1mhdpL9uCnyGzQeGKSUdk+OpMX2O/9fvuHWe+WSPwt29J5XJR8Os5zXwXwQuEDdEjERL8bIUH8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/28 13:35, SJ Park 写道:
> On Tue, 27 Oct 2026 22:24:24 -0700 SJ Park <sj@kernel.org> wrote:
> 
>> Hello Jinjie,
>>
>> On Wed, 28 Oct 2026 10:36:28 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:
>>
>>> DAMON_RECLAIM runs its scheme only while the free memory rate is
>>> between `wmarks_low` and `wmarks_mid`.
>>>
>>> But some users want to reclaim cold pages even while the system has
>>> plenty of free memory, and it is not obvious that the existing
>>> watermarks parameters can already do that. So Document the setup.
>>
>> Thank you for this patch!
>>
>>>
>>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>>> ---
>>>  Documentation/admin-guide/mm/damon/reclaim.rst | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
>>> index ec7e3e32b4ac..23fede7d1cdb 100644
>>> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
>>> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
>>> @@ -193,6 +193,13 @@ DAMON_RECLAIM becomes inactive, so it does nothing but periodically checks the
>>>  watermarks.  In the case, the system falls back to the LRU-list based page
>>>  granularity reclamation logic.
>>>  
>>> +To keep DAMON_RECLAIM always active regardless of the free memory rate, set
>>> +``wmarks_high``, ``wmarks_mid`` and ``wmarks_low`` to ``1000``, ``1000`` and
>>> +``0``, respectively.  Then the reclamation is limited only by ``min_age`` and
>>> +the quotas.  This is useful for reclaiming cold pages even while the system
>>> +has plenty of free memory, e.g., right after an idle virtual machine is
>>> +paused.
>>> +
>>
>> I feel like above might be too detailed.  Particularly, the second sentence
>> looks too detailed.  In a sense, it is not technically correct because of
>> 'skip_anon' parameter.  We might later need to add more such controls, and I
>> concern if this kind of detailed documentation will limit such extensions.
>>
>> What about keeping only the first sentence and dropping later two sentences?
> 
> If you don't mind, I could add this patch to damon/next after dropping the last
> two sentences on my own.

Hi SJ,

It is fine with me, thanks. Please go ahead.

> 
> 
> Thanks,
> SJ
> 
> [...]

-- 
Best regards,
Jinjie


