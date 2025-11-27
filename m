Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFBD7D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5016B0010; Thu, 27 Nov 2025 06:20:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47CA26B002D; Thu, 27 Nov 2025 06:20:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA0D6B002E; Thu, 27 Nov 2025 06:20:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 292106B002D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:20:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D22E3131D12
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:20:04 +0000 (UTC)
X-FDA: 84156142728.23.050DC45
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5EC0D20008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:20:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hkCri3Jb;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf03.hostedemail.com: domain of "prvs=419c917ea=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=419c917ea=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764242402; a=rsa-sha256;
	cv=none;
	b=mZbTo7yUeT8c9V1nskpkGLmrcKdsBlD6HNIgi2mgB3EQcYtNeA79TpWhvb0r0XEmzYNAEw
	o5C/am3svwpoqKy7YPyP5NzePw1XJ7Fd+jWnvIvgkXKcJxP6k7Q0fA4qpiv6/dpECWKnPE
	xbXREZ40Bw434L9BILdG02nzNc/4DM0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hkCri3Jb;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf03.hostedemail.com: domain of "prvs=419c917ea=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=419c917ea=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764242402;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+H64Ah6mYGxHQfE73KQcSigtJh1K4kxYLJX7clH3BEI=;
	b=y5f12Jo2zFHdfZFAWE30Hm7hwnItGX19tmLkvu6i6P8x2tOw3kGxEIagRw5bY1LIFQHzmU
	L025RDC2MRokuQWrihn9sesyBkXjYBsZb7RTGgK9Hf6LZHSLwr8sXOKgFY9nDzW21n4c4N
	X3xQO/gyh53PsMT8jMXpcfYGEUvun4A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764242402; x=1795778402;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=+H64Ah6mYGxHQfE73KQcSigtJh1K4kxYLJX7clH3BEI=;
  b=hkCri3JbBZERMy19EgzrL3VImDKHTLjdX2UgmT1RRPVjpZqPVpYpYf5W
   EnvUV8iN04e8olJeDjx6R4qZqo3UIJEvkGuLSMLpVvd6vP6kEzJSGW037
   s9CHIFyHWbWC2mFzxO8325dyjKFwDKKUFAOh3qWA3D83H6gRdaYOqil+T
   8wZTYW0MmgOPSThrVYij2cKIKFjc4NTfZSw7fjIbwCN7voBcXxHOScgkX
   fe8LLNxLrEcIo96CtfT/D4gyv+2cRLrZS0kVDeK2AhsmMKdOiTy+8Pf2w
   nPaTDqdWO9lHldioPwO2TdtdCiKuuCrEjHDA/0oMoXWv6CPIrx7+VHL/G
   A==;
X-CSE-ConnectionGUID: D+oseAjuS/CfvMD+9yRiZQ==
X-CSE-MsgGUID: 2qf8pyqtR5OsfOhqRXaxyg==
X-IronPort-AV: E=Sophos;i="6.20,231,1758585600"; 
   d="scan'208";a="5780819"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 11:19:44 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:29782]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.46.211:2525] with esmtp (Farcaster)
 id 162dbd5c-9963-4950-b318-3a7250b738d9; Thu, 27 Nov 2025 11:19:44 +0000 (UTC)
X-Farcaster-Flow-ID: 162dbd5c-9963-4950-b318-3a7250b738d9
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Thu, 27 Nov 2025 11:19:37 +0000
Received: from [192.168.18.64] (10.106.82.32) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Thu, 27 Nov 2025
 11:19:36 +0000
Message-ID: <13d3a7a4-5cf8-4fbe-8dba-d565525a71c6@amazon.com>
Date: Thu, 27 Nov 2025 11:19:35 +0000
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
In-Reply-To: <aSgpo1_ZSmxf84-p@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.32]
X-ClientProxiedBy: EX19D010EUC004.ant.amazon.com (10.252.51.178) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5EC0D20008
X-Stat-Signature: xe3qsti4fdi6g4e5t9gqmytdoyqxfhbs
X-Rspam-User: 
X-HE-Tag: 1764242402-353972
X-HE-Meta: U2FsdGVkX1+5tGn2DVHY/u7UDcFfbYn4MyNk7BArQdJb0SMGxDUCAnAgjY3XvwcNtYr3/2ePSljbraVseTiF5310aOut4pSyc2uw25rS4VCWAxTDa6kOeq+3keJm6Yb1zKNZBpl0D1ujYHnBmVwH7/Br108aia3lRgNOAsrulebMjDssKwSP2/Y2ToU0FP4UeYXVeGfUomayE9njZaxVW8odHUqoDYfSVDEPg2Jx5QqSQ9nrb/7d3w3tPUVm1Ef1jepdEuW4s5LySNYedtzSa8XHqf+oA8XNlB1V0rw9zUe9moiVo2kvGerj+mnYqbKhEleTZ7XnT/rnv+iw85/5QEDgAtljDPuEIIJ0EO5tem26Lmp+zlKrYkMRCfQbk9fGk3vuyo0As4cPn/CW/wYeTmCdP2XbEWRPoemL3QTIdEjbOQa2Y9CRTHwDDG04OafbDPd+Q+9MSAn8HJHuHGdVYr5kx7ZjxrmsB3N7nx50cxKs+i4yNDcZICtxyDfQcwUU0s9eY/SdKSAiSIroYHsUs0BwnF2ZR7uboNEnTQKJ0sYGBik9kmJCwv7mbUhfhmmtQDajk/GegsJEKW2kLbKxIt3fIgD0KwnD0owqetZUEu7x6mbwB3Wd20uIyrBeNhtEFWbhpPdxxNsqbhRaWkeEIdzoGT7uv8uJ5zE3lqQkrtfhi0JQMWBYyCfBPavq4ZsEFgcO/VUhThOh4+f1b23R5Cdc9NG3vTpwoYmKh1EaHQ8sUs/vvbjptBLyr+bW1tasXE4m/5Wqzx1cHEgI+Ep7fi8ukJrbidcC44AT1Br/cJ9N2fQY7lIg2eiVNSMvcZDIb2QNQ1335UeZG/DfcEfBqRggtYY6VBphFVrNgPb8roEQ+VxtfP17gzLWBqkC4SGwYOOUCJJQdDpX0dFvhTzz4i9KriH/2sZ3oeUmACwRG+990YuMSR0rGG1Aovuu9ohLV/rysGDpu4GI6I5SicN
 2hiOQDdy
 jfpo24cYv3svZ4dnO4AqhRh9Xr2El0WjZeeEWkWtE7x5BhBWs47OqGAmez0VE08lo2TUf6n08CL5L6j3D/WeoBicCQDD93i4/cAQrfLNaVUSEc/wHrYTuuDnfy+vWtNCY1rRmQbfTyDvYqux8oI/Wc1ihOBrQ1Pk9TPCsc7izulA5npdOay4kc3uGc3mnHCvc2yKarVyOF7X22aUC0Y/BM75LKI8wnfQxj9Rm0aidjAx70Dg7qlmTEQfwN5+0oIU7no3RoOyWPMs8Vd33bZjOgXoJRjN0V280ucyASM00qmsX3uce4jwB2WRz0iNYa+MirNGavWEI/avujHEFE/27B1hYASvO5eWBETY1fGtdck/st9S3SrYhHdJd2PAaG5Wd15qY14nfS+HYKUcKaZrSO5+2QiQtrQnT5PdxGYPpzsdHxcPluTLMEmnej+D67SAVjulHCwV3pqfrdLy6gUFHOjr5mqXc6tP4bmTyMO7JchEIP4MezadnZ1rPjiOPCu4dL1WakZibtSMnXus4QZ1QD265R0QXuVXkDdEo4NMRZc133+ioviNw2GC6OvYv1/ST7EEreppfMUwLhs3Gf1TRPLRKhOlACGZzPRn2QZp3RWsidiN+UvX5cWdO9ZZ8uuRIoudT5jrDIzpzUnp8qwIh7aaJcYc0eNd3Xd4zvALAG9L5rSpM9/EXcBBS5lGlUKUjHk5wVK4bNpsA6VhT0RY4jtFBVonj0oHtCSDjp3/BBhS+EHwRedDIUzp6fkoA0P6W3WRvlgpuyFDapecjhRjlOc93wpUazEO2xrailooUr9fdinm+ZVlxQY394Bz18262DCOZawY7Zf7D81n6RDp0ZqjJFN4Dr+gYJdHH7CnAO6Zt98ftAfzF1VyvmbFtGKbbbroletnTfki0M+q9iwf+90J0hpV5WSIWPGPyb3EIdKoloPsSEbHJf48MbTsBlBMT2Svl3AYH20xSk4o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/11/2025 10:36, Mike Rapoport wrote:
> On Wed, Nov 26, 2025 at 04:49:31PM +0000, Nikita Kalyazin wrote:
>> On 25/11/2025 18:38, Mike Rapoport wrote:
>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>
>>> +#ifdef CONFIG_USERFAULTFD
>>> +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t pgoff)
>>
>> We have to name it differently, otherwise it clashes with the existing one
>> in this file.
> 
> It's all David's fault! ;-P
> How about kvm_gmem_get_prepared_folio() ?

I'm afraid it may not be ideal due to preparedness tracking being 
removed from guest_memfd at some point [1].  Would it be too bad to add 
an indication to userfaultfd in the name somehow given that it's already 
guarded by the config?

[1] 
https://lore.kernel.org/linux-coco/20251113230759.1562024-1-michael.roth@amd.com

> 
> --
> Sincerely yours,
> Mike.


