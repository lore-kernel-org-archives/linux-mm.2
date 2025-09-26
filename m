Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B16CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 19:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200D18E0005; Fri, 26 Sep 2025 15:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18AD68E0001; Fri, 26 Sep 2025 15:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A728E0005; Fri, 26 Sep 2025 15:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8AF38E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:18:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C910BB590
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:18:00 +0000 (UTC)
X-FDA: 83932361520.04.94EDFC7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id A4A8420009
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:17:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=K5uNgAWd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758914278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhLPxwL+DQHqKGTW1ubEYzyPgce3kGbV8vk9hn+L5lY=;
	b=wXOr8dlQo3zZYxOiYfkQEkbym2V5VYDBtysb7mtTcpIxw+wB1HjGAgdlZbzdm9eB7ps0kx
	E7ypkkc0aJ3IKG4vt+NJyVTF7NDsarhAMbwHDt4upg3I6CUrchs+8SCRvXjwOCeeInVABN
	ESnPHkR1RVy4ice3dmPNEBmHdnQnNRI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758914278; a=rsa-sha256;
	cv=none;
	b=oV2slaIOFJDLeYJSG30C4DHqcJpDwn5qnlDzUX4iIwNMZZYnsNuOzISdOi1a4P110bDwll
	1zkuNhWidCrHJaAEKlvj8a3nqcGUCVmuGfvSYQYgi6WCGI4Ea7kvtEATbcXwiJ9shkUhfM
	8H02Jcf+Cpf2VIPg5DbtoFFavhXGPlU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=K5uNgAWd;
	spf=none (imf13.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=yhLPxwL+DQHqKGTW1ubEYzyPgce3kGbV8vk9hn+L5lY=; b=K5uNgAWdwN9hMMfTQv1hxsa30n
	VLs5wbbT9ezEb4qbUhg6z5vLWUbhU7Pdwm48QOEYhV+8p4XQKXQEs+cJSVcsPkO5s+L43+QMUgwgQ
	B3o6Cq4F+78eC97uURqPOdc0y14x4M0G8kBR8/AbflwMdadWJ5QhiL1jubP9yrKTTOOpA5K/UewAg
	RGVTzjzCg9BZMwMYple2oYAu6nfAbTU3Mzx7VTXYJwJEyeLIAlJs9R5i8MvnEceGJcGEoZ2xgVQ89
	ksMAJym7/p2wfU75+a/y3s5k6AXqv6iKgFO2VhpBjbY+5KmgfQ2cWJZr7k9QKdrLe7CnTMoSPFXl9
	5ehk4QeA==;
Received: from [50.53.25.54] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v2Dww-00000003suW-2zZW;
	Fri, 26 Sep 2025 19:17:46 +0000
Message-ID: <a5015724-a799-4151-bcc4-000c2c5c7178@infradead.org>
Date: Fri, 26 Sep 2025 12:17:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 mm-new 04/12] mm: thp: add support for BPF based THP
 order selection
To: Usama Arif <usamaarif642@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
 akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com,
 willy@infradead.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net,
 21cnbao@gmail.com, shakeel.butt@linux.dev, tj@kernel.org,
 lance.yang@linux.dev
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250926093343.1000-1-laoar.shao@gmail.com>
 <20250926093343.1000-5-laoar.shao@gmail.com>
 <073d5246-6da7-4abb-93d6-38d814daedcc@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <073d5246-6da7-4abb-93d6-38d814daedcc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A4A8420009
X-Stat-Signature: ga47fc5broo8dyyqaiosrbg5a9nfoa6s
X-Rspam-User: 
X-HE-Tag: 1758914277-719722
X-HE-Meta: U2FsdGVkX19ecuwurnmPVDfVstLYI9NGfxotiCK+JL0wAdah2hnuY+qAlQhJpBuXKlJGA0Ubt+YY03CzpuPf3QvmAHwuECNrdXgGcd662fEws6GOm+JyH94tLO21u4nbxydlrRg9oEvB3yiPDj4SOdyHGbyShRbXVGF9dGfa26KweeyZn97SUEKiaCUhyADS7lkMl9QpqV/+F+hnhqVbJklA+0oisDKWY0kZO6sjGWOhknDS4K1yAyEQUCrQijxAepjwlvQPsc2TcLHJ2pgQlCFiFhuB0UxIenMhoD99HzJGE3cnLBNXe83e7c+aUhS6csyLNRsiHcnBcRkhfcIFVOaDx+Uvo8hkz8UvJP3ewnv0w3jlcXYARlKkhARJK866wtc+NsQ3pLNGJG/JvGMmCfCtf21ZyhPwJvXMR0kJ/AsPyl8lo+FixLNXx4exD04l9N74nltkTuLJWd3CSH5kKgS64fCiL38GW7Ll4vx9z+DdwsQGP0jZ99IMg036YF/BkEgVZoy0p67Ln+1PjjKYUeeGhtmZg0juH+eMRn5t37CeOoqBrO2hqkO38+K+qOzGiTK0tXX49JSKpRu7JSi7uaR5RKLVryRV01gp019eXAQIV+8dfA8D0kI2sLocEMTAd97Osc6gyColB9pQbltARH75GWNsZwo5pPq8ldhDyylCBL76ucq4g+y7T8UaRPjG9+AzWAmEtVi8sOzQxPLL0adMK5ia8EW3cDoQs0QKPdwGWWVxY3pjCIAaMr2wTwkSS5kk+LXRWFaT0znTbDsSRHm0Fxb0JOJrc91rVfN6j9TjcxJMr8iAtErIWsAP4b/X9BojLD0tqDifjxIj7B9sUq0CESRraOmlFzprQfC0wUXSD5TjZ/jXmOb7BwxBvisLtMwPsqev1/ZFPMhT0iPsBlA0qzAvKwf53Q9Latn8GkgwkeUdhbCiaOrcJCmOMW62we1tJPsqom03BoVzEoW
 h5hZ+Od/
 v+hSzF9RcNKDGoE5FGVNyx8S5PFB36j4IGn0P+bE+x23NpVoikbZFmee0TuZdGFvHj+4/qTRFo6g7Y5HD2Z/MrgeWOFslsJz1/rSC4spsHPhUZ944T3TlfqoWczXzySZZ2vb5lu/zcYmamwxm59PYzCEb/nsPC5A/WfQ9g4mliTeDupCXU9GKwYAtNB5bIiQhqywk+/GYGPd2kQCzNA9Kaq8KcEqGYL/TFRpVYB8bnZJINfgQLVAP7qVp6n61eC3bWIizhzGA6UlwbQBs2RCRih+hydCf/PIOOpck
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/26/25 8:13 AM, Usama Arif wrote:
>> +config BPF_THP_GET_ORDER_EXPERIMENTAL
>> +	bool "BPF-based THP order selection (EXPERIMENTAL)"
>> +	depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
>> +
>> +	help
>> +	  Enable dynamic THP order selection using BPF programs. This
>> +	  experimental feature allows custom BPF logic to determine optimal
>> +	  transparent hugepage allocation sizes at runtime.
>> +
>> +	  WARNING: This feature is unstable and may change in future kernel
>> +	  versions.
>> +
> I am assuming this series opens up the possibility of additional hooks being added in
> the future. Instead of naming this BPF_THP_GET_ORDER_EXPERIMENTAL, should we
> name it BPF_THP? Otherwise we will end up with 1 Kconfig option per hook, which
> is quite bad.
> 
> Also It would be really nice if we dont put "EXPERIMENTAL" in the name of the defconfig.
> If its decided that its not experimental anymore without any change to the code needed,
> renaming the defconfig will break it for everyone.

s/defconfig/Kconfig symbol/

Otherwise agreed.
Thanks.
-- 
~Randy


