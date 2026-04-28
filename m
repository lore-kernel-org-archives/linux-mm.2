Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2AD4FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066E26B008C; Tue, 28 Apr 2026 09:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017096B0092; Tue, 28 Apr 2026 09:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96D56B0093; Tue, 28 Apr 2026 09:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D939C6B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:10:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CDA740183
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:10:23 +0000 (UTC)
X-FDA: 84707998326.25.4DA74D1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5356940011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:10:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777381821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SSKjumtC5UCqVi/WUq09F5Mn6HqLmTgkLof3IXXUakM=;
	b=Ckd+laZt2tp76UJAYH45MO2LLxKuwY0lEiaiPZ8Baw/cWN1yz1Rdrb4lRcT+WyQTy01u/b
	q+Ni8goGWYnRCT7f7lVJUdmUaf2u7hGNxy7DDxQSNijhEeFeSCIBr7Sb0d//tBYFFzzoXJ
	vD0Yc+ggGpdus8PdXowueZFfx8Ccexk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777381821; a=rsa-sha256;
	cv=none;
	b=dhkg0T0CSepd1v5jb/9xOaGO/NtGC50QC3r1iKn8LKqjI/PDtBJlcllkaR1sSUSG3JYlyG
	/RPfuWEVpbfZaGgxNuy92S4trtmhXjQm/6K++Unp+KRJr9Qt5K2WKXLfJLgALq5w+MNVZE
	+8MLwGAgzHoQ3ELokaamxu6dUMnzeRs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g4glW0psdzJ46bk;
	Tue, 28 Apr 2026 21:10:15 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F5AC40574;
	Tue, 28 Apr 2026 21:10:19 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 16:10:18 +0300
Message-ID: <69c46d43-c283-4064-9347-817841e532e6@huawei-partners.com>
Date: Tue, 28 Apr 2026 16:10:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] mm/damon/sysfs: implement filter dir files
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260428004454.113463-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260428004454.113463-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5356940011
X-Stat-Signature: zyp7z784bfqe745huyojb9see8yqj547
X-Rspam-User: 
X-HE-Tag: 1777381820-697019
X-HE-Meta: U2FsdGVkX18BZOcI/3P9crembRi/hWcc2l2lOtk/920O9p0bhDaOqG/MamwaPMfj1v+NvqOWB/eihGglOdSkFNYUaJgnAb+rLZmdvfWao9vLZA5bqTs5z5hHr63Na6vFDsNdkhwbLoBhsvNqlRqEaX+pcA5qjE0vc+v/CybPFNjSzmrrdZwHcepBr1E0ZjLIF0Jc0etdAsQUcqxW3QX/jRRAkUuJ+aoBwz9S3S96BcayxVmwbPZXI2kh/bRhJZ2xA7bAmcWQYfeOOV9PBBjTwyA222qc+uoxHtQFfR2+GL0rINo3/ZA/bwH9RO5H2o1Y6l311Nk3Ex0Bc6yVGwtXkq9jCgplE1MRlydmUa/LnuG6YkuO6+atTm1c2dtHAALtt0cg+lhHTwEy6mS9ic9Fq3yQOvuF3rr0Pl984BW4Ku/5qRbrPcGw+4sKlnJuih+vlRCChETLk94BlHK7zZgv5nLHOJwWl9sitrdm4KvHEWphZKH0LDiHJ5HMaG792+79a3uMMjDZMijYGli9yqLtA/ADgbU9TQVYKXKwETTwmKqAm7N5xVBQs9z2oI6BmqxrojIEhyzSQ3iV0s1Vv0+nBvl5lN9lshTwWAwsFxPLw6P8GWjVh+JqH006cb3SWn9EBAdUbnEqPD2xpOLh3yA65Bhx2pMEODoenOEY8eX/dHFO93oEZ7QEqkLO7rG+h17jHUxeeDDjBLEd++gl+nbvG5xxw4DsbIrTxG/uI2QLuVxytw72dSf/FwkFPxER2L8q6Mk9pcQzG4ruahTlrBF42qTwdFGcMoOtAnfpHHDeOYrk1QqxcmZ1zyzWjej09tfAr3LkewuKKZTmJbTrd0nTqwvLL/Gu09YhRAjXJI32to0XpkS2vDbZwmJwMZ5M3NIUBpr1i3s1jbyA28tGGK3z23+YPBQqfHy/9RDhrtXKTwCZM70QI8uAwteigdRgAR/alYUnIaYtFBG5sieYLUE
 44AGgTA5
 unlOgTvBZtfomD+G4v2tG94Lzvol4n039wuWs+uq+FpR7kWQQ/xv10VIgLMD97BvYoGM0mVKf3fVuPioILRyu9D9jkgScl5yXgojfc+alq3jKHzkPcBM4Rjpo8QMzcTEwiRa6L7FMAf43GPHKqoTxHFoOfCUC7pAbrMyJ4wgqWVqbMrWA4gCEAPmeud6XodZ/ZbEq6OZiq4LYU4RbgoIwrK3xwZsW6GkfPvch/bpuIR+iDgtpbdl4IiNwRMUXMN4b6j/L48//vMKYgR8F8SiDZ9MrFbcqH5Y2y0vzqA7qObOksFYt4B1+LHLwJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/28/2026 3:44 AM, SeongJae Park wrote:
> On Mon, 27 Apr 2026 16:24:10 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>>
>>
>> On 4/26/2026 11:52 PM, SeongJae Park wrote:
>>> Implement sysfs files under the data probe filter directory for letting
>>> users to configure each filter.
>>>
>>> Signed-off-by: SeongJae Park <sj@kernel.org>
>>> ---
> [...]
>>> +static ssize_t type_show(struct kobject *kobj,
>>> +		struct kobj_attribute *attr, char *buf)
>>> +{
>>> +	struct damon_sysfs_filter *filter = container_of(kobj,
>>> +			struct damon_sysfs_filter, kobj);
>>> +	int i;
>>> +
>>> +	for (i = 0; i < ARRAY_SIZE(damon_sysfs_filter_type_names); i++) {
>>> +		const struct damon_sysfs_filter_type_name *type_name;
>> Can we move this declaration to the top of the function?
> 
> Unfortunately other parts of sysfs.c and sysfs-schemes.c including
> operations_show/store(), type_show/sotre(), metric_show/store()  are also using
> this pattern.  I'd like to keep the style consistency, if I'm not missing
> something and you don't mind.

Yes, it makes sense to keep the code consistent.

> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


