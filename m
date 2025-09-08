Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F08ECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E389B8E0024; Mon,  8 Sep 2025 11:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10768E0001; Mon,  8 Sep 2025 11:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D260C8E0024; Mon,  8 Sep 2025 11:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C015A8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:40:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B3D21601E7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:40:37 +0000 (UTC)
X-FDA: 83866495314.16.94CD3E5
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E0CEC0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:40:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FQuirPzF;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757346035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmlBlDpl+4/RqcC9nUmRT5mg0GKEaeGb1rCCM8xHueA=;
	b=2Zw/z3JEwWmM70LW4tovITMlo7BWwzFEima4+bf+ieuWwIjgbzMnv4Ka7gsGRr2PeVawP4
	P9XRJh0uELpeCxKBcQuXfOELD6DsxNMcBfw//3zmPMikZfKocxHno3jnIQZkL70bJWabiX
	d+5rT0bMA3p3ZJNu+z70K5VL8UpxZ14=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FQuirPzF;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757346035; a=rsa-sha256;
	cv=none;
	b=Dfhp0qtcXqt4prrvtFMDEt/f7hYjFTFp8GKT/VijerTJJvhorbtRrK9L4fN8O9ivUge+cZ
	D+vuhr5Knx+YIRNMYhnCUOuklxB6gK+ex0DsFQWnOeIc5WEUhp44Bs/uvBq9BxTEqOSLpi
	CmJiLmv3INKlYsvjzOiDNwzjozJEZ50=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b5d5b1bfa3so43206071cf.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757346034; x=1757950834; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mmlBlDpl+4/RqcC9nUmRT5mg0GKEaeGb1rCCM8xHueA=;
        b=FQuirPzF537LdH862RgXwoVMzhT32/ad1YTTqjpqg2IOUnKg+I7866vQ3DOMKLDI0o
         Z5c3UjFok8d0zU5qtTIAj2ke16PI47HnQynnW+EzIc3Gb+7H+MtxvSa9r7VDDvKFTwZK
         WLau1RTqtjgshloTTGq4M/g3YS3tsD988E+QxMo4GnkqOrAgT51zcIfoYVx/+OSbO5wM
         tv2gXdt7N5aECQFoKFnviVxtqnXeBHKHXYWDGDXvvBJ7bgaJnWcI0yzCyalgmCM7nIRp
         +7sC3l4ZNjLY7pWkIhcGny+AbHtcW618SUv4ycVly1E0tVvxuLlLNgNj9KsBzXN6wbXL
         SNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757346034; x=1757950834;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mmlBlDpl+4/RqcC9nUmRT5mg0GKEaeGb1rCCM8xHueA=;
        b=BAEgFLzoAy4j+LVF8rfpemiLneIBP3Hjzmf8dZTaCWYjeNzNgWSx57tlVlFyaOzdtd
         QMD5pYkTaYRrMm56QMQyrWun56tVch9/SAHhoz4MhcvjdcoGmCyJ6ldu/Wh+0jPYZv4V
         5qu893Ax6595BrBRfPgYjyG2kIusn94fwjB2gaLjeHG0btXgjCDtFqQp6kPfQnQKnyqL
         33tFHqYb/XbAo+9DrEEBuMYRk2tNodnArFeowF+5jCq/jTqfUAYjNfqg0QgCIdyd5kG+
         1Olv1c3HYCRqKIe8Nk3vR9sxC4+HEG8nIO1gsK2ns98m0GTy/H51Vi7dXqjefEQrPndI
         xxsg==
X-Forwarded-Encrypted: i=1; AJvYcCUL2aixsr8ro7Xqr9QoiSskcBx7Rz7MVXRL3nPNXXhJ8hTFLMPibZAE5w8iLoMa2DaYCd+tg06I9w==@kvack.org
X-Gm-Message-State: AOJu0YxOFnhORI2PMpON9BnamZWBZnPaCyIWIfkcERQ2o3xZAn94os2N
	h9Z9wwU5XF68NYQSV0rfDqPQjoLVsmLqmbbTCOSZURVm4kvdxXG16uR4jG0FyYmY
X-Gm-Gg: ASbGncsI9+J65DPR1FYQu4jYUnOZaZg8aFNgrJmoo/his2lo2wn1UlpK6heDFLtHItL
	h5mWrhEzcrox1nC1dJaEi0SwR+2W0wEPvgYLqL3+mx4FaigUrPwXiRFP1qAbAUK6QXjaNh3/eey
	p02lbBdUuhAxOx5noTBY4xZKiEjno+xhBChLPyQIz2guesoOxya4bL6uk0nBF6OoBUkW52OBIbL
	l96mGRaALBpteA/hP31n5WCu+vadkUbW2/R5rd/DaorsqZT+07kETDqTxr3MDK86NvEmwTWc+aS
	wwbfTuY5HPhqf846/HU/u5ZBUsALMh1yIRY7PuEpEqURGY/KRwmYusEufShix1Zc0kGrcgDsTl7
	SczYrhoEWb2Ps4eIOgdNOrBqekxYHWxbJQut/5VX3q/AYJne8sHPBibWig/SWjWLxMht27CNhTI
	itjdkgrwnLqN8=
X-Google-Smtp-Source: AGHT+IFU1PZ+J2iW9oBqGqqd64Y3TTikMQfv+fShqzgZXQJgjFCltE/gj+GjX+w0jAHOPjKr8vx3MA==
X-Received: by 2002:a05:622a:19a5:b0:4b3:15d4:1c1d with SMTP id d75a77b69052e-4b5f84bdc33mr88981991cf.84.1757346034372;
        Mon, 08 Sep 2025 08:40:34 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1145:4:1456:e851:ddd5:be9f? ([2620:10d:c091:500::3:4e10])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b48f7ac9f8sm106132511cf.52.2025.09.08.08.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:40:33 -0700 (PDT)
Message-ID: <1d7a945c-70db-4446-85ab-19f5af88e204@gmail.com>
Date: Mon, 8 Sep 2025 11:40:30 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling
 THPs completely
Content-Language: en-GB
To: Mark Brown <broonie@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 david@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 corbet@lwn.net, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 hannes@cmpxchg.org, baohua@kernel.org, shakeel.butt@linux.dev,
 riel@surriel.com, laoar.shao@gmail.com, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com, Aishwarya.TCV@arm.com
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-7-usamaarif642@gmail.com>
 <c8249725-e91d-4c51-b9bb-40305e61e20d@sirena.org.uk>
 <5F7011AF-8CC2-45E0-A226-273261856FF0@nvidia.com>
 <620a27cc-7a5f-473f-8937-5221d257c066@sirena.org.uk>
 <abe39fc3-37a3-416d-b868-345f4e577427@gmail.com>
 <771871a1-9ee7-472d-b8fd-449565c5ae80@sirena.org.uk>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <771871a1-9ee7-472d-b8fd-449565c5ae80@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: faxcft7p54s1urwzao7zqcpaox5pxk6y
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E0CEC0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1757346035-667035
X-HE-Meta: U2FsdGVkX1/ahq1u5P0RuEWiyY5g9WhJ9dZ5AEjNEw5dELeRZTS0HC0P/ZBc77KrfMMhaGHVXVuYEJ71n3Ju8/OIuB6rtTnJ0zl3qfyggGASm4s0llJC6OBtpoW4c+Ct+R3LCa9FnEbXI4MUATyw5IfMqtfvCLkkfGOB9uocNjd10oxZHk1LYxpq+HbluXtn8TMuZg79fFfQbTR0kMMCcq9shRWnw5/rIeV3/6vRlGnPf8pNkVnAd/dHwlQQb8a0p7Pa53dgwyzB7mb1hvRMHlmlYv8C7pugqsiFlDh86axlRKy/TF2zUfOSHzxv1AfHojVYA3ruZoBjyDbYgohB+uLIPS+aMz7fAEpnF9oSNrU6NhLNjecjrOsWvJ6lMQSJIZByM0xkfe7EpZteobFjVIcGsQm4xVD0f9713Z/uEhHjbLehXhoaKM7aDvv8T2vAIWKc29Ihrpzkjg7tR/5/eUnviXfJUQXDeg4bx0UAXiVaCIrPAaknGsLTsl+NnTd1IrIz9+MVDGobTjtrP6dGrw2flSi79+6QIRFJk+xxzpC8+gP+osUhJIlweNirjiz3JunbjJ9WpwE4pje+4QzFEhQeRFABbN1Wwn+sF+jyoUA+4XhXK5Gk2pG423FJzgwId+1/yg4KkUkW+iEPPz6td3ujmpWPv3oXQ2CEGUGHuYzxnH2CaFYxFrcktlTnUHF7xY3NBPdo9JGDZ8B4Y+xvQwb8XQeMSXCy71NWosxuZrIFQQSz1oB6dEsh1nT1Py52WY+rlANUOwz4ZKcy+q+2Ts58gV8a+df4CrEcd25UnAEqDokcCk5B3TjWKYHZ6MMIBzPeglU+wRmCsL9iowQ9tKxsKkdxLWwjuJUlcp6qKLS2F4t2PeVcVF5au8p4PLloELffFscHbfBMB+2AZiv/jjC5g6V15IJA2XQR72QkkqETcUdFits/7GQHHDICnehLEO57mGVU7mO5ZCpPBm6
 ILml0osS
 ofuHjYtkTnzLEZ0GXpoDJ3WficJ1ly1H59dCQDvgEqNOdLJdIen5SDCcKZyLoJlr8ZvvEyddKkZHcxxujOm5UJBBDODyqx0Q57iQlVQ7qkW/kuI4BfzA89/Nqnb5cBoRJjzpBboZE2AnnVZG15c84GeOwUmSrj+HOWhAl4Y6CdXocSB1omh0m+mPKZwh1+3CVkYIZBtxSul6udi6c6fkm2vEMCzlkPfk7929Ea9A99eIyrRzjsl1mdX3rRQIamxer/LxuPD3zC5IDUzLTW7UgRPtCKb0VSKCUtYknsdy1+6cNAr4MnlpqPMlJJflUjEG/FlgPIwMKmFK5myykGBuokqGXvUQCin9A1bM1uRP+S5n6F7S3dWwZTJnQmUUqpjZkUyOzgwuD+SbyRneFWqb+n/K3fo4d7G+KM5muCgDE6HOHGRvuf9zEI2pnKDslSNwNTUbN7+Lz44S1JkK1Tl1050p91G/rrLRAH18uHsfLBZrd+fw4NirwG5nncfeyD7xKx/OZcn+vMJOIUUD08OCsMQ4gn4pxfnQ5M44cAtseYQN7ZNKKRICGa5HItmUrwfU7TnnoTi6irhvdtj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/09/2025 16:38, Mark Brown wrote:
> On Fri, Sep 05, 2025 at 08:40:25PM +0100, Usama Arif wrote:
> 
>> diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
>> index 89ed0d7db1c16..0afcdbad94f3d 100644
>> --- a/tools/testing/selftests/mm/prctl_thp_disable.c
>> +++ b/tools/testing/selftests/mm/prctl_thp_disable.c
>> @@ -9,6 +9,7 @@
>>  #include <string.h>
>>  #include <unistd.h>
>>  #include <sys/mman.h>
>> +#include <linux/mman.h>
>>  #include <sys/prctl.h>
>>  #include <sys/wait.h>
> 
>> should fix this issue?
> 
> That seems to do the right thing for me, I'm slightly nervous about
> collisions with glibc in future (it's been an issue in the past when
> they're not using our headers) but I guess we can deal with that if it
> actually comes up.

I have seen this included in another selftest as well with MADV_COLLAPSE.

I think best to have it. I will send a patch with it.

Thanks for confirming!

