Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BBE6D116F3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 12:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921F26B000E; Fri, 28 Nov 2025 07:16:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9816B002A; Fri, 28 Nov 2025 07:16:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E82E6B002C; Fri, 28 Nov 2025 07:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD2B6B000E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:16:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 061BAB6FFB
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:16:15 +0000 (UTC)
X-FDA: 84159913110.02.6E0E44C
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7565C120006
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:16:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="IF1P/8VI";
	spf=pass (imf29.hostedemail.com: domain of "prvs=420eeb500=kalyazin@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=420eeb500=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764332171;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQmqQgiUg9lKMYuf3x986+KMHkr7rlI8OkUZkYHCLlo=;
	b=Z20Edpq2Icfjq05duCOkpq597x8026un7BFWQqX/Sal10yyAa/iQ6iVBrJ/sdyx1Gg56/m
	7DDUopk8THjidPUfVX/ebpLrIYcn+Mm1539DId+Nm1AamxhRBjpgaUm3dzf6lx/7Ud5YDe
	6W7OemeSbdMjlsx0GttEmHhdABb+LvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764332171; a=rsa-sha256;
	cv=none;
	b=yBuxooG8lGi5zBxPC0AHp5E2D8xqD55Go+8Q6HSS20U70K4Ny1JClggaWpdYtL+efrtptP
	teqR9PD+NQemm9A64tu6UQQZQ7fy3jRX6lyn+H1gUpRE8yl+Oqf342Dwg9i6S0QbyM5CO7
	mgz+oQsvIn7OdC8CDVSoT6d6LttuWjY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="IF1P/8VI";
	spf=pass (imf29.hostedemail.com: domain of "prvs=420eeb500=kalyazin@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=420eeb500=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764332171; x=1795868171;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=wQmqQgiUg9lKMYuf3x986+KMHkr7rlI8OkUZkYHCLlo=;
  b=IF1P/8VIllDcD0jnuIC/RbOx0hiFE8HD9ExqT1/KNYfVknuC7tFpc5rm
   Ek+B4P6TrvQxSGndJmaeTaLO7pZQagp5l3VOoSXDQ+o5V56/GmB4mgcFM
   3fYH7qwJs1ZDOrSRDMRA5ywE0FzLLh5gkL67g7UmMQ02BZf7vFT616kjC
   k4J6ySzzfx1sUINa6hrZw1LEHGSFuXzr7Ew+T+Z9lA4gnM8AW5nQYQeO3
   rjo9VKmJNmgJOwpInapx1j6RgTgTYGi8Z6zW+NGG/QZNnlZeHuMM6iTJX
   q2Lvi+1PM6A7QLyfPoJvn+pcNc03N6r4CHHqK0QfTIdnhDhFrGx4mYBaz
   Q==;
X-CSE-ConnectionGUID: a46IeSqzQEW+DEIlmgXGXA==
X-CSE-MsgGUID: bKPh8JWXRo6VH8Yjn5Tl+g==
X-IronPort-AV: E=Sophos;i="6.20,232,1758585600"; 
   d="scan'208";a="5943764"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 12:15:54 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:6730]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.46.211:2525] with esmtp (Farcaster)
 id 0de054ca-fa8f-4660-b374-417544b79f00; Fri, 28 Nov 2025 12:15:54 +0000 (UTC)
X-Farcaster-Flow-ID: 0de054ca-fa8f-4660-b374-417544b79f00
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 28 Nov 2025 12:15:54 +0000
Received: from [192.168.12.95] (10.106.83.26) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Fri, 28 Nov 2025
 12:15:52 +0000
Message-ID: <4405c306-9d7c-4fd6-9ea6-2ed1b73f5c2e@amazon.com>
Date: Fri, 28 Nov 2025 12:15:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v2 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: Mike Rapoport <rppt@kernel.org>
CC: <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, "James
 Houghton" <jthoughton@google.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-5-rppt@kernel.org>
 <bafb0c9e-9ce6-4294-b1d6-e32c41635add@amazon.com>
 <aSgpo1_ZSmxf84-p@kernel.org>
 <13d3a7a4-5cf8-4fbe-8dba-d565525a71c6@amazon.com>
 <aSigyHj01snbfii7@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <aSigyHj01snbfii7@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.26]
X-ClientProxiedBy: EX19D014EUA003.ant.amazon.com (10.252.50.119) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: 7565C120006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 5ymg4ekuy8frjku34mjjy5gb9mtery39
X-HE-Tag: 1764332171-67882
X-HE-Meta: U2FsdGVkX18yEBw+LlNhhoAV3Bn45Cz8PJ8KGTBl8YgswvA7YpAcWFMeu5/6COU/+fE1XCYJuEM6alflDwj3ZFyiL1jucYiVVKzRiTZCzJEoaGhAI2FfNpd3gpSAuhkIe/ljNbgWPOL3wkOOJc+oY90Pcn9j/i2vlKVsUixj9KXb+iUf5E+ivknL/GFJYC6yU4yeJwJZ2tHS19mAi+341BfwrRdVqmOFUc2ceunFZJs/3F3aw1QLP8f4yMFoh3Xr8m+F60eG0bz8bbdtA8rNiC31sMj+I7doYhK7WtCYemdkw7orhRFYVbavvVFn5MAstKUj62nSuW0M7c7XEr3ph+A+PmaKJSA5u3/UaCK7rUQvsDmzYVVW0Sbtx8CmTfTuBMwpaP8RtM0p9H4xkXtkkPzLCf7RgRWmcxhPQSjm7WrdhRKzbDplci4K3iFuIq/0VBTM8c6HqM3+UXNOzVhWWUGstREd6jA/3uGvgn2t/e59Sr2JIpW+0ttwzstdDisG8rioBClu0ehXZHVm8is7y+gmIkEoTGhXVOckm075hWM10sEf0HA2PDTHLJcYHY1LgMOXB2xMbtsXfHQc02UNWtr2pgTX1Ee6LNEaDkqjro8wa4SBcfSCW/+B6SRZGobiBJdiTmtgjgAdfaBzpsliNa+bLC2yeB/+4gmgVgDiL1Oz6Rwb/dLg0tri22hOVVBj2DdIK8UyGnAflssxoXSHvdipmd8+M/qXEL2fgYsFQji/mr+gQ/xaQ0BNcAQxlTl6ZfmazuMJGPLLZVgwu1/6M3c6n84uwlWE/dIIHiJX9tZnhriy0po3KCINkJUdaqwSC7JPXoIea/9Hti5uOqa0cuN64q0dsCF/b0xJ6x5Zi1fh2iTT2xvFR+1Jhi5Mrh1UDhH5XsCLpWJpBo73FO7Kz9kRGUZhAVo6Zu2+9VS/iFpCeFST5h5V4iB5IEi2QqTGMz53ExvWNh9LhQUzIWZ
 7ykZHT/k
 0DKP6MBmKUNFemlL5jTBsgKmtDGKfCQU0NcK+LAUeCJ7tI8+ZNMmgaG56DCwFfVhMY/7J5IQ0Q3LsQ9SnDRv0Kz2k6xXo8gNTfBVC/xLAMsuCDf0/Fc43dEzjK2r1U2mhxgC8euduIwrhHhGaLmwT0ZkicZVlJzZaCONod41x5LPVJOFj15JlfyrGM0bOQF+UKSQQKPozN1A0bYKiSUyIQxkYiGO1Oj1WCREmZO+985JTKiVolVBB1CCDrUD53R4Ylq/zLQi/uu8lcGrJt6hQx2yPYB18Bix4xTQoifol67ZFLScwexjwov1MU2paiLVERWoDuK+1R6aqxSXYLoFThpbKTevpVSu0cy1UTKezTpl1xWPp4C9q7Yd6FPmzUTIqZ9xbeIAOobb4sWsaOTfNHhFPzH/iFJcpQxh23L9b3W5DhNS3jfK33bowLeQ0CTVTsCRDmPucterHiGBcTIOnti6XvItNlkWhbfFY1DwiuZ0/KQ2sLrRugcQEnG6CC4RPBMbX3sJObuZYjIgF3IpA++Xof7643R32HYWF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/11/2025 19:04, Mike Rapoport wrote:
> On Thu, Nov 27, 2025 at 11:19:35AM +0000, Nikita Kalyazin wrote:
>>
>>
>> On 27/11/2025 10:36, Mike Rapoport wrote:
>>> On Wed, Nov 26, 2025 at 04:49:31PM +0000, Nikita Kalyazin wrote:
>>>> On 25/11/2025 18:38, Mike Rapoport wrote:
>>>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>>>
>>>>> +#ifdef CONFIG_USERFAULTFD
>>>>> +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t pgoff)
>>>>
>>>> We have to name it differently, otherwise it clashes with the existing one
>>>> in this file.
>>>
>>> It's all David's fault! ;-P
>>> How about kvm_gmem_get_prepared_folio() ?
>>
>> I'm afraid it may not be ideal due to preparedness tracking being removed
>> from guest_memfd at some point [1].  Would it be too bad to add an
>> indication to userfaultfd in the name somehow given that it's already
>> guarded by the config?
> 
> Hmm, shmem also has this clash. There I picked shmem_get_folio_noalloc()
> because that describes well what it does: lookup folio in the page cache,
> grab it if it's there or return -ENOENT if it's missing.
> That's also what hugetlb does for uffd minor fault.
> 
> The guest_memfd implementation I copied from one of the older postings
> allocates the folio if it's not in the page cache and it seems to me that
> it also should only look up existing folios to keep uffd minor semantics
> uniform.

I can't see a reason for guest_memfd to deviate from shmem and hugetlb 
here so makes sense to me.

> 
> Then it makes sense also to name the vm_ops method get_folio_noalloc().
> 
> --
> Sincerely yours,
> Mike.


