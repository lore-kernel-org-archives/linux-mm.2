Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B163606A333
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FGdo3SDi
Received: by kanga.kvack.org (Postfix)
	id 803926B05B2; Sat,  7 Nov 2026 14:11:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79CD56B05B3; Sat,  7 Nov 2026 14:11:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B9F6B05B4; Sat,  7 Nov 2026 14:11:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 430EB6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:11:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C70AB1203D2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:11:34 +0000 (UTC)
X-FDA: 85409266908.09.EB5D0A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 069B440002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:11:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGdo3SDi;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794078693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bH4sG8PxPI3XSzLdlTVmZF250KgsDqk6SB0vAlniKYA=;
	b=RmfLFaWbmC7LEnyFKYEwNTqktWrJZcWUI8JRtuknQrIRxoqK8SRQK0EGCus0iUkLkCHqYr
	UYt0xOrz8VIvVLx4m2IX2cNYlZzjozE9LTCS98yZHkPRfuQuYjbsBzXIHVDia3TFpj4W/y
	JMkaB2t/52sQjcmWNtI8NAF9gjyoKXA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794078693;
	b=a4F2Iam71nE2G3Iyg0lPltuf/PHFM6+7yqhUjOJtoDrqlxHkC0uteq8ntVS41UGADUGO+S
	uZUI1+YrkyTmdeCrT6gzvxCbtiYNVRdH/AxHmbENLDlsDtr6NFXdYyrA9RbylXwC//KTYC
	oGzo+pHUCqTm4A9PuwH1Qar6hbMJJ1M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGdo3SDi;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DD9543C51;
	Sat,  7 Nov 2026 19:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8494D1F0089F;
	Sat,  7 Nov 2026 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794078691;
	bh=bH4sG8PxPI3XSzLdlTVmZF250KgsDqk6SB0vAlniKYA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FGdo3SDiFOSVJa7QtUjtACayp7b8sVPqRbO3gF7fYZjX1hK6a06frhyCqWXIocQmC
	 ds6G3zS67yyL7FQFLkmzTYK4ZKIp+G06fQLc9+OUIarNaiiHJmP6HZvy9jnnNUsZt8
	 JY4E9RciuGTOvMYJSNI17z1awb5d+A4ywGBTekNU5dMtJSJkXqWG4MrDSUPWIq29qp
	 71Sv4e35V4075qjeGekKguMC3mnd+ji4ap3LrRzuzPb9ACN1f6jtotMrxh+WgiteWC
	 FqsFYn/XbrVP1dS+kN4DQWgAQGL3S1OtnmNZTljmNcp9pRKbqLgx7MR4/qn96dlIDI
	 jdCpUvUvq4EjQ==
Message-ID: <bc095bd8-ee9f-4bab-8333-8f2333b2590a@kernel.org>
Date: Sat, 7 Nov 2026 20:11:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix softlockup in do_pages_move() with huge
 page arrays
To: Zi Yan <ziy@nvidia.com>, shao.mingyin@zte.com.cn,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261107213856462Jx8pIdgdtLvPLfOFTwV4X@zte.com.cn>
 <DMP795RB75PQ.1XIZ1QUJ51Y0H@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DMP795RB75PQ.1XIZ1QUJ51Y0H@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: djsx47f77obkxxuu7gdryak7czi3cs13
X-Rspamd-Queue-Id: 069B440002
X-Rspam-User: 
X-HE-Tag: 1794078692-812501
X-HE-Meta: U2FsdGVkX18RqvCqkyZgZjpeO2Pz7L8Ce/GtwHfatwm/nGFbPWsUp0y3crLyuUBqLB6OOKmWCM2t+9mJ5E4YXKzs4UE1Cn99ax+AIKtNFfK4Z5xkQj3fRj+SiD0A6qC/IaWYLCS7Yf+WUuTU8VX+9Xmt41NU5ZTVz13tsJWXDK4MFlc/imJDegJ8x+v6+6D4bJLY6vHUjEat6xa+hAayhPBhQhoGEjDJIaTNN7fz4f/CuBjtdoaPsHJFIYJB+FLbvt/lpFCYbUqp+qjJ0/LuoeoBKMYYnoV5y0CgGgQc61Ua9s7SOMaVhn45i9eP1ZwLkwTr7I+Or/tToWX3CORhjTU4A+PG4ffBS/bEPbVRrESAZWwNmIdKxc0iDH7qgDp6nPOj/J7DpnbGWs2bRvQ0UDzqTTHqXT6AjudPsdl1sSEWnFTxLSYOUyOUkff6dZkCpH2ICo5VuocdqDoP9yzIUm2eDojwEztC1euBjOs++M6QWUr101hqzMMn4aWxZiK4hauLC2TQAO98IpVECYWsax6Bl7HgGh8oa18yEtMtWJfnc+zjOKCpOOEy9AcGb7d5WGxAbxQSoPJASXjC8S5SC1hsBw40Z3OZBcTnyZ7MjWquPs+DmCmGc9JE2uL+n06ilUyBzuwktS2xCmZ34Um1w+BzdLFHNDIcg3J3C2GJo7G/8Ko91uDB97JiiT6LJjQftlCuEfJpZL1b5WXNvhULKE/PbPyg7nsa51Xdnm3tBDCzi9dGU7kJjGdK6UoGiKvFpeSNuHRtRBfP0dFFdiiQDkPaLOblCVPbH+qco7+p8gFgjR952VStjoGEgnNggh6AaY62QA7m9wguavZ992+QyQhoD8btbls9TkJL5BJ7qvrZWgTiPbhmyD9V9Rr+0Oh5EKYGkXyOVK6mJxp3AJgABzJU/m3yDMGd6mTAfo15GNifVJ1bAk+TWXxcxJwOnGHc2cLRXNqDORoTZVAhROS
 szJQz2SO
 89d6vNNUIrTItqEUaYNRx4uh1kPumHsLpgH4p65vChm+SCOFA0dEFlrQ/ElZjkBSyMa8Hrxpn03tP0W/sdx65ae/jU1JPT5lbKafKHFK+xkOQpYEU8ukcCZuF04K/tRK+x1gapb41YZpOfeMzgnSTxNvoZyiaNLbK1HpeYKJ5+diWMcjlPaC20IAoYhonbMRwzHVS6+mEbI9bEz7z6lVQmyDcg369ZZ1h/QFBaMhJW/nSr8UMTZYDBM4rGkNhbMIqEJb3fxjMReC2oWDpvbgpbgC4USQklLyWU9EagqEZG8PhYe+6LA+OYfpEkZ/j//A62P94QrNJtCMw2viPGEQJzM1DWn5nDFcEkFW99Rjmu2JNW6RHmXmvTydXST00hcvGNSbN0TgVTmMN7hEDiM296iLV1PnnhE5RC3z/1TPzhA2Z/eIn2Q9dcYDu5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 19:45, Zi Yan wrote:
> On Sat Nov 7, 2026 at 8:38 AM EST,  wrote:
>> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>>
>> mm/migrate: fix softlockup in do_pages_move() with huge page arrays
>>
>> do_pages_move() walks the user page array one page at a time.  For each
>> entry it performs two get_user() calls, an mmap_read_lock()/unlock()
>> around a folio walk, and an optional store_status(); none of them has to
>> sleep when the arrays stay resident and the rwsem is uncontended.
>> move_pages_and_store_status() returns early while the page list is
>> empty, so an array whose entries all resolve to the same node can run
>> the whole loop without any scheduling point.  nr_pages comes straight
>> from move_pages(), so a huge array can hold a CPU past the watchdog
>> threshold on a non-preemptible kernel; with KASAN and function tracing
>> enabled, ten million entries can exceed it.
>>
>> Add cond_resched() so that long calls yield periodically.
>> do_pages_stat() has the same problem and is being fixed separately.  In
>> current mainline only alpha, hexagon and classic m68k can still select
>> PREEMPT_NONE, and they cannot enable CONFIG_NUMA, so this mainly
>> targets pre-v7.0 stable kernels.
> 
> This is probably in the same spirit as the do_pages_stat() patch[1][2].

Right, and I'd like to see an actual reproducer, because we sure have a bunch of
cond_resched() already in migration code.

-- 
Cheers,

David

