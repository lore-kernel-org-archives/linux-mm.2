Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7B1FB3D17
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BEDE6B00A9; Mon, 30 Mar 2026 06:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196326B00AC; Mon, 30 Mar 2026 06:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC156B00AF; Mon, 30 Mar 2026 06:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1A3B6B00A9
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:43:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D63316070C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:43:34 +0000 (UTC)
X-FDA: 84602393148.13.1E32B3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BCBCD40002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:43:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=knaHqe2v;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774867412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zz8ARJYVyoAX6gpbsnsuQhzgAXglyeoPSwsCVO1xAow=;
	b=mll1f0fw44OVW5tetNbJpp5kc4l0wIjhO+/YkJcWhIMLi5g9UIxviB5IBo1LoE4bgIEGS1
	233lgLsyoKXoFaFVGFI0I5Sfm56Ggao41mAUTJWlASIPh4UcenFSYajel53+Empb25hpW0
	75PZfLxOtcYzo4azJ0tcYX/6LtSbw9A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=knaHqe2v;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774867412; a=rsa-sha256;
	cv=none;
	b=Qqm4Tms28ImbK9kEJAj4ZAzpY/rD+yh0D7fHtLOD8wbUfL2mhWfr8+ujnE8vvj+bVpsP1j
	VtCmSuumCb1QYaB+qsGbaNDr0JKutwLlDm387o9IGGtAux0M0UjtbKnnY7uTcP152SohXd
	heH2+FTBJW7wjRX44Nq1gCCjHmdZ5Lw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E43143359;
	Mon, 30 Mar 2026 10:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC57C4CEF7;
	Mon, 30 Mar 2026 10:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774867411;
	bh=OoCOlj8/QWtY4FP0+BpV4Z00hRhh0v51w6ArBxXXuJU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=knaHqe2vFBFBi4ruLZm0/3U5BnDMHk8cfOau66gS4mNWkgw643Xx/mGdespF7/8fF
	 y9XSdWcQPDpFFhsMSbTcPS9qHYAaDO7DJC8zI5JUWQVHI4yMJSiBk4kimUGXggS1p0
	 pXX0KX53j1wHbU1S+PPHBNiCWV69BIilFc+bp6wayxMilOX3FyHShnEGASQHwsC0v2
	 myYp8PEnavb9Zgu9rfCBpx7qVmOX0cqHaHtWdIHKts3fZAn6Ec4oJem7yGKrl4FS7C
	 7ZJKTcC1Sog7dG54+mV+homX1mzqaKaLTMOTct2RLl5UbkLyP/Rh4Z14ZPIPiNuOP7
	 CeB6lBWb8j0vw==
Message-ID: <a1054c28-b574-4fcc-afe9-5e902209a22c@kernel.org>
Date: Mon, 30 Mar 2026 12:43:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, rppt@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260330053915.75442-1-liwang@redhat.com>
 <a5b7add7-0507-40c0-a324-81f243ffa261@kernel.org>
 <acok3JY66OcV0Qab@redhat.com> <acpMD8tRCJhgXHeg@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acpMD8tRCJhgXHeg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BCBCD40002
X-Stat-Signature: bz78hj57q74g658d1646oyai8k1zptdd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774867412-810138
X-HE-Meta: U2FsdGVkX1/Qx9rAeHKhuvEg7Rr47fABly14edEOoql5UXpU9/pqhUNul678p6vRGNbVOzJ7P+ZdRjCDoWHg04hGkJ0y5k6cVH1q1XLL8kGttVnB9tznhaDW5P2AZs7trwVfvXMpQ01wZO832BmlkKGzxj3B12NprfBI3Sv6mcZ3TDGJLHrfVgdPKUl/YcbyHkTMq11+56M253rcCy3wkbWqG5djfXjSs59WiE652IutEQmz57hpcuczSQhISSaKlwKSzC+Qn4TKNkD78/NNkRFuNhk1PIXq/Ma5GJ0CMdFA1axwbCB1l5jtPjXr1vyPH9MNITemnlscwoqTyaWO+cVTpZ1H9H+HQlNr+ST13YrfHBYIGglBGrXp7L98Y5xlP7dZdgSFikJ0gFYVd6R5biRKMWrr3fB+UURgebfVSHyo8acZAMiZp0TI+XLusQFnXzEzxPs29ujUHPOOaxU9irTy/GFlezDov+gSWu/1YiQ8hbJ+FdMQYo13ruE6XorGpu3dGNGzJJfXOexUsJXNywgLH2dYAFFszoElmlZjQzhDTPia34U4XwDkoVExCpCfLhWysvIZLQWJDUZDmw//2wZPUX/w34x3ceTzUrghsv4L8cfSWnf3XPiWXHLbOzoUhpYaweDZvmyg0xwBvu/aL0WeSlERxBYp+UcRw8Cw9GJwK0dB3WeikxOcjmRZhiadydHKrokfxMz2a8NWnHaxEa2a36mFkd63Rud13UqqYOEORJJK+OcCpq3EV1FIQsFwSNT8TCgGuTsHffnGvIYcK0GF+tpy2G6+MWp2Lc1ii64dbRpHtkWRkOvImVVM4Buwci4ltpe1cyOfPRHEtrq6YsvYil/jtJfxLRjo7dSfI5ChWBH0FUYbe8gw19/UWftCylQuZ8vTWujXFjuaBW+3XvtAkjgLnSB97hto8/xPmEt6ojS2okaSQ4iCfCUNvDk2GZcFSM4oT2KQshc76XW
 9xD5dDQT
 g++7cYOyrQhXj01PrOXLXhEVcauK+O3aKxLOhS2Q9Q69SLRkyDXsZS7LxCeRb7yyhyl9q3xrs3KeAray59VLirrD3AZKiYfzkInT9MTZVFiPdzRXVY3NS638L53p6BZh2N3NbiCv/krFop1kDVswEJ6cRCCe+j4VipuDYKZFxZRyE/5kdrE3NjwNrUphMXCQ4xu/uKtjg8KAIGNgzzbBUlbhsUmO8DuX5CJKLppsAIxGSVooIzqHffZb+ZBxd5gqqNHwqDCMJagowH7XI11NjtdfUqSYCITjBIMtKKvKBDWmaza+4arsSCHNPjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 12:10, Li Wang wrote:
>>> Why can't we simply open the file once and pass the fd to run_dio_using_hugetlb()?
>>>
>>> fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
>>> if (fd < 0)
>>> 	ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
>>> dio_align = get_dio_alignment(fd);
>>> if (dio_align <= 0)
>>> 	ksft_exit_skip("Unable to obtain DIO alignment: %s\n", strerror(errno));
>>
>> Yes, apparently this is a good suggestion. Thanks!
> 
> And, to make the test elegant, I'm going to add check_dio_alignment() dedicated
> to alignment checking. Then we don't need to pass too many args.
> 
> Tell me your thoughts if you don't like this:
> 
>   static int get_dio_alignment(int fd)
>   {...}
>   
>   static bool check_dio_alignment(unsigned int start_off, unsigned int end_off)
>   {...}
>   
>   static void run_test(int fd, unsigned int start_off, unsigned int end_off)
>   {
>       if (!check_dio_alignment(start_off, end_off))
>           return;
>   
>       run_dio_using_hugetlb(fd, start_off, end_off);
>   }
>   
>   int main(void)
>   {
>       ... 
>       fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
>       if (fd < 0)
>           ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
>   
>       if (get_dio_alignment(fd) < 0)

I would suggest that you query the alignment only once, and forward it
to the test.

-- 
Cheers,

David

