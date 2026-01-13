Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A623D29DF4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0A26B0005; Tue, 13 Jan 2026 04:26:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1CA6B0089; Tue, 13 Jan 2026 04:26:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1BD6B008A; Tue, 13 Jan 2026 04:26:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9F56B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:26:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 547C8575BF
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:26:47 +0000 (UTC)
X-FDA: 84326410854.12.967A0F7
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	by imf25.hostedemail.com (Postfix) with ESMTP id 49A90A0008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:26:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=vHmCKgwv;
	spf=pass (imf25.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 188.40.203.114 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk;
	dmarc=pass (policy=reject) header.from=codethink.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768296405;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwhRz1qvbi1/fe/0umje0amzQnKdrgwi6Ba7ekT00jc=;
	b=XwkIMi/AMtAgZj/LAfPVMBRuuL4gOcH9O/wD1NyjFucSVJDWvuDDQeuhN9Fvh0/ENy/PBM
	jU08vrxlVznJKjFx7BpNudhaIGlCkBe/fqiNnUKlMu8HTB6BoqDkRUD82O7s5V5Yc5Umxq
	3Vu5bm5UOE0KVM8/mnw7mDPYG3v5kew=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=vHmCKgwv;
	spf=pass (imf25.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 188.40.203.114 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk;
	dmarc=pass (policy=reject) header.from=codethink.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768296405; a=rsa-sha256;
	cv=none;
	b=PWFPp6mY6C/pUxujJxWsk/F6sddZHUQyf6JhSUlMU+PTgEHPWSeGznBgYBE0Ma6COzK1Nd
	hlni42ag/yPuMxhW12gyGMLCzM/4k1ltZqHFs3HSeI++Ss50YWjBpieYbEWuWocebpNc3w
	T0qw8R98dMNXZ/5XpYWZYcW3SJDzszE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Reply-To; bh=iwhRz1qvbi1/fe/0umje0amzQnKdrgwi6Ba7ekT00jc=; b=vHmCKgwvdh4dx1Iv
	kGr3yHQ4o2bZUoYuCUk3Gj5PGdY0MqoJnxNIH/rnfkhvofRMZl0P44RYu0zToMxEPRuhARc9YsMkY
	NfWWYyAVRs7+cC2q03ckTT82jGkUoOdLdW06CUTFgndQ4lAXRdOS1FLkfIM4ikQV8fuzQLs30H+RP
	4OT0/KbfcrzJNasHZV13j4fOxva71j6lK59chDTj/uLt5O97yDmHHNopz2XsrbcPkKPWf3LsZafLw
	U3RzmVSRuHVkvQHmyulcxFr3T6fTgRFy8mZpf/OCL4rrjBG0ffvtx+s4HYND0Drf2qvPRajDIOyM0
	0TNCK0AaCsUNcmfyVA==;
Received: from [63.135.74.212] (helo=[192.168.1.241])
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1vfafh-00GFza-Au; Tue, 13 Jan 2026 09:26:41 +0000
Message-ID: <2a289c18-b5b7-497c-bd6d-a25602706b23@codethink.co.uk>
Date: Tue, 13 Jan 2026 09:26:37 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: make khugepaged_collapse_control static
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org
References: <20260112161820.604669-1-ben.dooks@codethink.co.uk>
 <49229782-acf5-4e33-b317-63399deb6f6d@lucifer.local>
Content-Language: en-GB
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <49229782-acf5-4e33-b317-63399deb6f6d@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 49A90A0008
X-Stat-Signature: myyfequqq9auqyn3r9nr7x9gss3uf6hs
X-HE-Tag: 1768296405-518834
X-HE-Meta: U2FsdGVkX186QK/X8k0SlyT9MmPMfEpoZFUjJhsS1dKFa94gxvx5rocCSomLY7sJ49UZ/YN5IMXPY2IeGuXjVMsJeuecMu9yG9t2r3GupBKI++lhZkq0NVZo2en1k1IcscrgNJ7YmkLM+8xg5TjZZxpRMJVD6SVj59DvYp/GNs/Wq2xum5Jl3QG/p5sbm9A2P4RNSZsv8dw0lZfwK4ELwsNGHKXPT2zNK4+Jbvf+nq6f4BxM9vlu8SdJKYAh7zFX37FiHGUmQPARW4ekw7CieuZj5oR4Dd2lq0LtQ7Jliw+gAz9bhUgjNraAma9b6Wta8AOc+zBrkpPgeDdMouRzlwv4iDLi7AWrodsDELwxLxVY2fYHtZZpbMVG4j69/0t6xn9Kutxm+jkIGqX7/In6SNTXV8fTmk2dQLVmQVr69c/XzYcNn4HnlUn6DsDfA6riS7tA22eqNI+OeqFOJ7cEhXM43lf2m48Ts23UtRDXltTqZks72lS7J1rHeRi8hhy1M4MQ+MS6CqA9AVQYD2gBTvISTKzoAdizzaNPkKK/Ie+9RpPJSyBr3/Wr3fXzdaybinPe08sUnt/ylsyIe0PrRg8M5RpgtHebjLPUYeBcHUMms0PhOg5uuynSVOBkh0UZTTllqSsLfnU4o7UdKuIPHKhE7Y2yFdLbJmsvZHzGB2QXuXftLy13dFz7lnI+J25DwxhIhRHENIuy63NQR37pejOUsy20TEVF/Df+5JKBAeSTVI9zbvF85v6dJZ1ysAvmz9ry4VLAqaXwgCskUdTs7bdrMNEJjtBwEWhN5l7D8hP1d8HjwZOVVGAFvgh/X68lDtbOgb6PMmoto388G9KVV2YQYgnqqM0y7nkSdC55KVxC9qScXL5jMX1vzdkPDFtEMEE7SrkhoDEbmB0XRi2zrGJCYWP69sQmNZe7jdMChvQNyJ5a5iDz6HHWDAu1iMX9sn16D0yKRfDLLbiwXIt
 iASXLXG1
 +6kjnEqfIDHivww2hhZqIIJ1NlyrhN8k1YB8biHAvhmeJLICSgxHREfMlkYlWEKLkhFhk6WWroEeG7gBT63jlbdMq5m65GaDRL6hiJjyxzpXUGfV2W6fTBlvA0rnhdvJhpSczXficRK9ypn6ozfr+1awUYgtb8UQwQnRZzJYpEPWbcOOAqGXbAiOvvSHJvdvoEKPE9IGmfx0fj+7Hx2Io872U6S+o6TnBOoxpGe6NsX6PJG7BTnxG/P2hhhwzE8SBeWmf32EtsOkI1MHET/+lo8lXOn7jAnS60YdoELS81uS782UuODaPsYv4RXhs3FSEExOEgz5lFIB6mMKrq4Ja+b1X8gC3/4pL5NeeNx9uI7Kio/YBaQ+ugT1Zo2jkuCQ1zcJ0XNOxWu5y3FlcAS3l0te943mHwXzB30Qjfd1ubG6uUcWxmWcWTDoMoj/NLzf3J733RkJwq5/uMriNjEZuc7EhxTGR4B+CRC3AGZWOxOaJgzJEzfIDil4H79biEmeq6G3spw2dezUCGfQo5Eq3A6O90F+GfIGGclPdQrEHw2LtwXc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/01/2026 16:33, Lorenzo Stoakes wrote:
> On Mon, Jan 12, 2026 at 04:18:20PM +0000, Ben Dooks wrote:
>> Make khugepaged_collapse_control as it is not exported.
>> Fixes the following sparse warning:
>>
>> mm/khugepaged.c:829:25: warning: symbol 'khugepaged_collapse_control' was not declared. Should it be static?
> 
> Thanks for the patch, but sorry to say that this has already been addressed in
> [0].
> 
> [0]: https://lore.kernel.org/all/20251224111351.41042-14-shivankg@amd.com/
> 
>>
>> Fixes: 34d6b470ab9cf ("mm/khugepaged: add struct collapse_control")
> 
> (Small note: for something like this that isn't fixing an actual bug we don't
> use a fixes like this).

Is this a subsystem preference because I was told I needed it for other
patches.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

