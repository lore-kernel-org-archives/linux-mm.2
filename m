Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE25C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048206B008A; Wed,  5 Aug 2026 02:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41186B0092; Wed,  5 Aug 2026 02:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CE56B0093; Wed,  5 Aug 2026 02:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B42DD6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:11:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B4BD8038D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:11:40 +0000 (UTC)
X-FDA: 85066194360.19.BE0632F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6EE3C180003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:11:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LkwWgCSq;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785910298;
	b=DbQDad2od7VFMAojpP9aX2ej74vXX3ZKnVjRbrCt0joJsN9hrFBI6IEtb7KNGvZ3ujo2SU
	LAp6xnnsyp8dZxjrr5tIxgZUO/NtAXgea7si0uBvGrUM50qSX8FGgq2LeybRBy4Q/O5edP
	cRIJuhFmXHra6Q489PIPBrNmPEzoccM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LkwWgCSq;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785910298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o06/6FPH7j0zA4EIe85PZVZwlMghUXEo1x/4oJlkPUw=;
	b=5Kh61SsrDKSBwqa1jPi4FoW+OyH5RNZ8SNSEVxECFjnjWDlBslqUn9m0lEFi46REqO/aHb
	nqCC0iKxQVt8VzhA4hqdYTGPECANzd4huXEZ6Gut3hYLqV1FUGAuzCvVu0AK9PuXGDtNa8
	ZozBR75HPeczCLto1hM2Cpvu4A7ebUY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCF85600B1;
	Wed,  5 Aug 2026 06:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0455F1F000E9;
	Wed,  5 Aug 2026 06:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785910297;
	bh=o06/6FPH7j0zA4EIe85PZVZwlMghUXEo1x/4oJlkPUw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LkwWgCSqVEHenrGLY5DwHpwv7bCvEcjU1bM/SAkxZR2C7FbjCYG3GZB5To0YtXKhJ
	 BROZukET64rl4TaA+ifSfCscJVUF45Sj1Mbg8SEyLyuM5osT/W4PTtOdU+dpW/5eRG
	 lT1en6InMlUBFn/zGgyPhjerWsf2AfB8VVnhSXw4voTEHz6UfS0qFAT9XSyOwjJ8fM
	 f54q8nYfmXaOeDNfFsURdyQ4grrm1xxLOlAzlipOCf89+cNJXPeLxgPi2gG5ZvQVWv
	 qF4AxGW4BsKoX4/f0sTLmGSj0EsjUXEQ/4Y3hV+0ZhQ0+P1Cw/fzmiNjZE2Z54f5q5
	 k+NL4/dHq1Unw==
Message-ID: <17add1ab-4390-4e8c-95ce-b8f0723d4c79@kernel.org>
Date: Wed, 5 Aug 2026 08:11:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Yang Shi <yang@os.amperecomputing.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 dennis@kernel.org, tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <anIXr4Kbn59Ac31Y@lucifer>
 <69f4cd9c-bd6c-4e5d-b8d1-a7be8408a57a@os.amperecomputing.com>
 <94c7988a-3ecf-4b26-b0a8-011bdc76283b@kernel.org>
 <29edec61-8f11-b9b1-3df9-2a51815ee771@gentwo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <29edec61-8f11-b9b1-3df9-2a51815ee771@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6EE3C180003
X-Stat-Signature: ewjtjdfwu1maejoyhemn5s7zqybd6ji9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785910298-643705
X-HE-Meta: U2FsdGVkX1/uUt/6lJLcVCr7wulWABoJRSjxo8SSLeNjxnK2RSlIps3L7RJRwcGexYon/XgVpOPTXAg6ADMrYWw8xV1ZAlva2nnmOLRjWsA67hmkr4ZRbvAq2MQo7ybo/oSxXv8g/5UPafk1DuiIbbN5Dj9eU1Ig0ICkCmmmNEA35twGuLil0A+xMrCnUoRFVnFlzHtTXZGxEQzG7oYxXCjpyvyEsOXhESDxSgCREynfq/YFtNLflIfVgOfSM5aYQqoXx4WuuF0c6qdzrgiu/hkIwg6ZANFbec3H/wN/GqojMPCZ//vE1q8YdMsCn+Y9u5RQ00B25IaWGrESsgoM+/loV0K+xh6uNXVkXqvl9ffvwQi+X4bpUSUfMRzUadF2XhzcRrs16/YVOuHKroaeaX6Fx/1PxSnOftsA691xqBNs0+nFWKlZDIaJbdRptonFeNS3XCekz1GQvJnGxiafKMSGXR9KSg/mKAvHCgJ9XVxZEUxtCtG2naHaTL4RRHtigZiNPcUJAm624dRGXC+iFWJH2Cd8LkhtrnTIROJDXb48Ru8s8C1bOrS76y9SIHYrKUuJJqTwxyFYIw5k0cQNdAh4nhLGByY/+zXftaTnq7Qpz7A3VOBu/vyouQcvdu9eZqLY1MJy3gUJ6w+Fqx74a+Oc0ajunbSxbieDBruYWNMkV+mSAXB4N7mKhbUnM6yIX3WiERfqrqvxqu/5AhIbWyF/Msfq4WoJuUHsO9qzRxqKg95J1N6S/DBCdSw0t2bkD+hTetTjDLtybuA6LT0bWXjSHpU20cPVa3MM/HJg/yJx6yfZnN6X9yRyIbmz6NB42omHDF4DeGvWcJ5aOGJwktSfqkXXEcDy4/g6wD35aKHyrVJjxygGzkNfp/N6yMt4HUALRzj3e6hQH67EYUjaKDwXWKAfSiTxcmg6b67CXFRKkKOOi09pTfsabtt3AjmY/1C2ZGRlQkOVtrvKYzo
 B5J8pg9c
 Fi3lQgnpL3b1If4XHzATGHLlCJUOlMvIWZ3ZZFJ+x/9pgMhu6X/AcZb49Uh9cu1RV5sJvtrQhMxnBximlgx70Memm0FfQ67fBwpP10wJu8owhMiSA0ADcpJVhZM8Vg0HN4fMKlacJLriOlyMqRK5VOiwp5RQOREjRkhZTHn5Kc/kdTeHVjM1z4uI5zm+wSVTpHvq3gsKLj6KAcDMNFHYmkV2iotYx+VmqRST44YYJtJJbwBjpb0wePzJ0wqv/5pKB6V+y1h5qqiaWpO0jM0k7LAYA9YO0MhPMU4OQhusVCKGjyvfTW7GCqhjsxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 00:35, Christoph Lameter (Ampere) wrote:
> 
>> That's really all we are asking for. If there is a measurable performance
>> difference, great. Share the results or point us at them if we missed them.
> 
> Scanning over the patchset: It seems that you are using a special
> instruction that is unfamiliar to me. Which processors support that?

That's best asked in reply to Mark's patch set I think.

-- 
Cheers,

David

