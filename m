Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3467CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539E66B0005; Thu, 28 May 2026 04:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511F06B0088; Thu, 28 May 2026 04:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400C56B008A; Thu, 28 May 2026 04:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FEEE6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:42:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D27C21A0785
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:42:16 +0000 (UTC)
X-FDA: 84816186672.23.B700651
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id C5E8D140005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:42:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UVqD8SwJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779957734;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqVycrQztzNHkBb79EnfZhgyZd7li/azBuhpH40fhX0=;
	b=e8u+KyR8aYcr/audevswhtb2aC2oluG8tWqQwCkXcf/zPeXBaYWoQZucCNowFmz5Upk52h
	8B8O7tIxSwq+D8kqO8aVJi7JjaFXjc7vKoQIDSncLNzE4ceyP1SqBbZn4/hRQ3nRwLR7kn
	AxKm+3ZviwDctzyPxCLoDqxERVFh3OU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UVqD8SwJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779957734; a=rsa-sha256;
	cv=none;
	b=MkrFKWDRwRmE55U8bmXsZJtuIzoDVaNNw+y6mp0tte836aswzbnW1leY7QgC8SfIGaZrPf
	J6IWQv4+ri8NbmW74qWAgJEFgi1/dkB3PVMPArk3yWfOXmP7B5XFxlYl/qFvj3wtsoKum0
	EOeLW+rbwYmZO0rv13Mz5Mmkhj3MVt0=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-68852b58d87so4632022a12.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 01:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779957733; x=1780562533; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AqVycrQztzNHkBb79EnfZhgyZd7li/azBuhpH40fhX0=;
        b=UVqD8SwJjiPCYSGpZA9Z1a+6oqeUstWrxayJvaAxjQUVECay/zUWFf2taRg1WFlX1/
         aroHwkP1Gfwyf5He4/Ib34bvWezBLgJerHLNA5q/c1Rw3cjI17xL+CkqA3DST7OxUto7
         uSN9c7LkBbUwjWBGMmg14Y3uGONCb6HfegNDHltdh+NYSo0zSb62bf9k8MZIW+xbPEw+
         KW2mnNsNoDgX6vXNWvjedm3pshunTPbpIZhHB9S4UR1ptqhv8be9TUcVaVLuX5NPrbE3
         f6bXfK1ozpTrSmsPpc/CpAtd5riIa6pU1Pdklg7vJ7UtoSHERyZnVQuezGHYL+0PEPgi
         CV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779957733; x=1780562533;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AqVycrQztzNHkBb79EnfZhgyZd7li/azBuhpH40fhX0=;
        b=o2StEs1p2RcO8jjE1GlcJ8r3nDHNM7t8A0is+7IaDUbP1hwtnSMjcDOqe1muDgEkxg
         Yue3f7djGqTpSGiCr0rfkbiqH8WG3njhq+1eh2cmWxztYqRTAtP6I/toZ7yqVlcoMefl
         bdBoXw1ZzM+Kzt4RL4pw4wj03n3GtPzC6/77T9QoYhO5dsEDlzO9U7UiEmaLeUgGUTiU
         mf3iwoCjPQ3vLcUkpxFfCH2l8T3xLk2FREKbbT0fju2mGBsYEHsOfJKbwKO0aT3dzf4b
         lsifJCQb/Nx3WQna/JaZ05iGqkKhxslSzhZTtUnDSw3Apa79DTUcCqZTOagavWHKJHAa
         E2Og==
X-Forwarded-Encrypted: i=1; AFNElJ9jCBAq+VsWUdzstFI0SbZr89OKXA0xlY7l1SYOPViDzK4o/seHdURRrPMYU2S/yJ530/LMtT7l7g==@kvack.org
X-Gm-Message-State: AOJu0YzBHT/3V41nkLRdEteqbA18HWUFCJIfL5ClPKQWy9EdZKtV04vk
	tFVT6pu++lLTQo5NRk88nlr5P8OjyqMM15hkBVw1CrvLqyBbrJjETyaF
X-Gm-Gg: Acq92OHwZCR14e8Popbhhw+eskDb/tvHJ2SCWsDhi3Phiti4RIaWj0uzyab8OtBaynD
	sUIzk5C6CtFKA8f9M5Ktt/HCzMipOKMkvVvyAZ4WuFSh/UEw9ijTNTWZ+Z0ZLw0ApeHsfhXko9S
	GBUIqv+T12V8EBts4BvQi6hZP2yVAxGXPNex3NBcCVXmpxNbRwvpRhYcYyKgFKP0cTajkG1LZLu
	IANFk+ACkyF9f4QRzJ30zYZgzZvt0E1iL7GJw+9uRM9TI95n6BaVihVFtzYikpSxvIhI5pFILsM
	px0dWxiEYPTy8gjt9HA8R13k5e28iJSAvShoVPlGjC8LIsYxFRC14phc/g2Y8OVGnHANmC/5Ptu
	/xGBLtMOpnvbrczn+W5j7IYlIlt+7aXN3DFyUTF+tG3LRVvFf7wFMS5WE2LSeOiNoe80ORtA/nZ
	iLml9owkPLjnYxFcYC8k86qPe8cDgj9/oh
X-Received: by 2002:a05:6402:4348:b0:67b:89f5:26c7 with SMTP id 4fb4d7f45d1cf-6889cc57bd9mr14041876a12.26.1779957732880;
        Thu, 28 May 2026 01:42:12 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68a6fac081esm1560944a12.8.2026.05.28.01.42.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2026 01:42:11 -0700 (PDT)
Date: Thu, 28 May 2026 08:42:11 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
	jack@suse.cz, jackmanb@google.com, jannh@google.com,
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
	lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org,
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com,
	pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org,
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
	sunnanyong@huawei.com, surenb@google.com,
	thomas.hellstrom@linux.intel.com, tiwai@suse.de,
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <20260528084211.wsdrvbvxvkddokb5@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
 <2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.com>
 <20260525121041.2f2508a4f627c338cddd837a@linux-foundation.org>
 <20260526065708.oyyddmt2zgfwu2q7@master>
 <CAA1CXcDXyDhMyiVAb8XbusqMU10JXA8nOUw6b4_2i9H-kV2vwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcDXyDhMyiVAb8XbusqMU10JXA8nOUw6b4_2i9H-kV2vwQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C5E8D140005
X-Stat-Signature: ok5h5robgd7bqjgaf4ki87nc7ccxxria
X-Rspam-User: 
X-HE-Tag: 1779957734-98090
X-HE-Meta: U2FsdGVkX1/Q8dN88/EPMfFcwzLSyiwdyb/VAmlt9e3hmf/tc+8lj+PbwWfN38iJi27W01J95GWI1L3vdqPRt+lwyjHBSeuEHT4/7KttVo7N3QXm4p6wJe/aykkK1qbg1X2MqdrOQkuCc8hBIGAC6TUOX/jBinCJTZBpoCroSg1K5Z0iSZYBC4kWQG1kSDjzOxp8njV9Jc9sBEcoaNAN421i2u03JZPfUu0KRnSjZdvf4tTeVImLzYKE5y7RvqQj3xAE4yAoTwQjFhwMbvDYBFZ80PVuc5rtWL8Oh5cba0LBm1lm7T6qtEGTfomYDeXQ34dUUkC+vJ+sIzXJK5OugEHu4Glhm+vPnRkMUxp6nIZjiL02MGMUA2BTGyvv4Gqezs/bmXS7hVPfLdYHqfGvAERcTnU/BtFw7fMtdKwEohSfoR/MlF65axqF2OXltqXJRycGIiGwDZshr6whz4FF343ZTuz+FSCGdb3d8w+d9D/+AQVVZNdvwhal09rcKpXlqtrC8Y0rguBy7yefkKqo4fqkeu6QZjDt0IGRBYtsB0lBNqjKYThmqCqxr+B/CZRXjyqpkho4dnkmVLSfKe1cszGrXty0VMGMCcKLjAKuSJo5fQamHPrlmXP4RTzRjStshFianfFMsOs+0gBlCrzSwOfBpM7Q3270Np6G5E7UTCq9NfXkJxVM1HijFA9ExR/GMdmHE8Bk3O4+j81EMGh6MNneP9C8RxDJzd6++48EuxIAUZHxKMjtN+U3m4FOIZ+FgLbn5X2ykIDIxcsIX6x7PcKuXlXcTPQ87Rkivhz/eqLRjN+Jqz7DlY7zKU+bULwD91tx4kBIWtqxWt5WAaL0v4g3v09GcWTZemFTJFhsVP7kQlJzmw0fut5nwviJgoWF2LsVFMnyb83KHj/hYg5qGWK3JPjKahMfuqva3/Kxg7DhZZamPDug0X7NatDT9q7k75L9Of6FH5hARv77pz1
 NMc0Pvv1
 MPNIDQT6+3EyZp5guu31cjfqFks0EMRC4cUnIT+EENVIlQkIyyj6O60XVsQ+Rvajmvg4gtp6Gmi94VcSK3Kbw/xuNPWqxmSzugY8WXVBwYPnRZeskRTmSIPE3RB18cwQU7LWyghuCBgx176sAp0nnbV3QWCUxz/JdNKNi6osxP+lKjvQfyuB9hZc9zbIDmi/jb7ve0Cp0X+6YJXdKaxfDpMFBMyDjw2pJITTcg89gLk7vdhDNSqopoxDWyZUG7X9AkfXDtgZtu1OLEQE73RIAnu4z8CGLFvSw+YhPDdBcXUX/dZaDL3TlY9yswVG0HVMTJJ0wSesB9UxprHq+oNXABByT5liz4qHcGP96RCH2tlIi86Bv2mEgOOT6v7/G6e6mXJptaXMI43fQWCYwmzxlp21q7VJH5frppbVgzn9a4vgx/1PxXrQXLxX4pQcEo0kuB95kdjlUsdmYUWmgIjz5lhzW6vyhXbfDslW1LoQnl0jfa9yP23Mcd5IDGYI3EXP89pWanChEy+twrWGESXuyU71kDmatEJ4fRNOuQm7/3nEtUO+L7ztQ7FiorBdeXUv9LL6NN1NVr7djHiHjGTfWLoXH1vLruUFox+Y254kUsalc2qJOtINt4CybE0YYBlNd15v0ET6E2EnxFIZ3mJcoaR8VWtoY00OhOBCsTI1xiPAaHZN6N35oD+igtr8mtTxKi2Qspg92YB3UzcZHLU46XhJxCG9JCPc54JHGspf0bqqmE6/IrUMFgy7kdInTjsd1GaYtFVy2CdqQCjtoUjKMl1vAxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 06:07:38AM -0600, Nico Pache wrote:
>On Tue, May 26, 2026 at 12:57 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> On Mon, May 25, 2026 at 12:10:41PM -0700, Andrew Morton wrote:
>> >On Mon, 25 May 2026 08:15:53 -0600 Nico Pache <npache@redhat.com> wrote:
>> >
>> >> Can you please append the following fixup that reverts one of the
>> >> changes requested in V17. The issue with the change is described
>> >> below.
>> >
>> >OK.  fyi, what I received was badly mangled: wordwrapping, tabs messed
>> >up, etc.
>> >
>> >Here's my reconstruction:
>> >
>>
>> Hi, Nico
>>
>> I tried to reply your mail, but found it has some encoding problem, so reply
>> here.
>
>Yeah sorry I didnt properly configure my email client after getting a
>new laptop.
>
>>
>> >
>> >Author: Nico Pache <npache@redhat.com>
>> >Subject: fix potential use-after-free of vma in mthp_collapse()
>> >Date: Mon May 25 07:38:59 2026 -0600
>> >
>> >Between V17 and v18, one reviewer (Wei) brought up that we are not doing
>> >the uffd-armed check until deep in the collapse operation.  While not
>> >functionally incorrect, it can lead to unnecessary work.
>>
>> So we decide to tolerate the behavioral change?
>
>Yes, I believe it is ok for now. Either way we needed to remove the
>potential UAF. It only affects the behavior if mTHP is enabled, so the
>legacy behavior is kept. And the uffd case is limited.
>
>My future work involves further optimizing and cleaning up khugepaged.
>I'll make this part of the goal too. My first thought is to do the
>revalidation at every order (between the locks dropping); but that
>essentially pays the same penalty... I can't think of a clean solution
>at the moment.

One way come into my mind is add a @was_uffd_armed field in collapse_control
and updates it in hugepage_vma_revalidate() when latest vma is retrieved.

Still not elegant enough.

>
>Does that sound ok?
>

Not sure. I can't imagine the impact it would have.

>Cheers,
>-- Nico


-- 
Wei Yang
Help you, Help me

