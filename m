Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFFFBFAD3E3
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 06:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C2B6B0005; Thu, 23 Apr 2026 02:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DCFE6B008A; Thu, 23 Apr 2026 02:16:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB346B008C; Thu, 23 Apr 2026 02:16:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EFB7A6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:16:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 684931B80FA
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:16:04 +0000 (UTC)
X-FDA: 84688810248.09.30CD4F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 689C8C000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:16:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fI7yyOMQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776924962; a=rsa-sha256;
	cv=none;
	b=G4f8bVlU4HZUWDZ1W73AjRpHarqB7Gqn9GK0yuBFLm6I7jcXNNLlSxHj52c8SUL8vERpgH
	WcJHTMutXVTNKDphkk3OPESJ8SETYw8mmqj5J3RA+UaAHLHrBgoYhEUNQDv5Y6Rra2JY2w
	SGiCP4v944EToOEsd4YJoxXYEoec9Ac=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fI7yyOMQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776924962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69djUPJJx8coswmZcJMp9SXgE0OzFiu0JhLeiEKj7JM=;
	b=SHA/EVEeKk9z/HCP8TQXa3ZqaDKPwpMoAVf3NpyUstSUNgG1cjrA00IPjCT+mYYjHo40Bs
	LEY2/Z39pzXO0suChxL2mlitwR7Hm12JQN6UKmVkEhrCwlN+faRmJsnSapUgHMAJuzFTHf
	nb9c+ZE8AoZl3iiBWhc10aYEY1h6CmY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D774441859;
	Thu, 23 Apr 2026 06:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8258AC2BCAF;
	Thu, 23 Apr 2026 06:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776924960;
	bh=nwBBq664DxNVCPLrdjYgRhX0pOKg5QQniyywFa0cLM8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fI7yyOMQle6EEJtPUOZvb62FPT9bq8IAnCvH+bfxjnLxwfmrkBm635eBptkeZcYjf
	 LoyCNlwo8IgG4xWTWw41Q5BJiNqeo5MsterhDhwMdmfJ3dNcpeHxn5dJhvnGcFO7cb
	 o+7afynJ6WGXSxaLK5VO1gLp/1jIXb0zIT63ODK47wxM+R3kg14vJaKmUPeES5krgD
	 N+RVfdlOXYSYIq6eHT/lZN8s/hy+SBokvHsnesIPwIHvKRBPwCXfD29f/t9kSeExMM
	 aI30cAcFYxPaUkIkZ9luSfUQveIT2KHtxsnvQqMHorz+ehGz3gaKoEMLxg0wilnsx6
	 dM4hpsz8OBbOQ==
Message-ID: <499d2411-72b5-4bc3-8db7-5a29f9fb3f20@kernel.org>
Date: Thu, 23 Apr 2026 08:15:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] MM transition
To: Josh Law <joshlaw48@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org
References: <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com>
 <92c3d650-be80-4a64-a962-3586ba753316@kernel.org>
 <B2261993-3CF8-47EF-9F76-FABA6BB4A50C@gmail.com>
 <dd27fb14-38f4-439a-b5f8-59149e6fc6e4@kernel.org>
 <4B3D556A-AEA8-4143-85EA-CEB76801B879@gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <4B3D556A-AEA8-4143-85EA-CEB76801B879@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: nzp8ks4ty7h6g5edy9hy3cxd6w4kmpb3
X-Rspam-User: 
X-Rspamd-Queue-Id: 689C8C000A
X-HE-Tag: 1776924962-88741
X-HE-Meta: U2FsdGVkX18uGK2cNzPRbLcWPYk64nGD4CHMZZK0SXr+iNa29Sy8dqiGHuC8W2ksp3fHrcB+NKmFUT6mNChZcUpGZuMN+3N13ME5LhpxHXUpO/GcjuKu0HnYJhdeio/cM6DXu0F8mw5V5HjWZ5K5iEK17dyYiJU6y7kHpyNYcOAByXtzghLJm+wG0JEeA8T2J6fFrOPUGFZNDQubDmyZj/aCigIWnVSgg/DA9Q7NhYxvg8H6uBnn5fiWlsIBgXJHzsmvZse0kugYTaJeCQcSv1QhDnRVtwtdlZQg2FNfPVEKDD0ehCSwxGJHuCu2cMMdhqoBuYQLRU2wlxHD9d0QdBEBn8F3AIx5omb0sDiyvtJGpKt0Zcy0Cfvkk6El5s9FRQAXpMByqyvK6xSjsmlOwMtLA4lMzHaPLO7YKZrHFbS5BlLXDBpvumrDnmf1YKLg5y8YmJLdxsp0G8+S4fmBcz5JO3NOHW1q7rPrz8oQ8soNBsIY7MNK9vsEQEoNvAfEUqZo4ItJoKuLNWRjEO+3tbublFgW1MIh0+TopxZmNOZjDlWfvJjZiJXqwt617EcToNqBWTNpt4/Ita0nIivzmWLM0z1PGxQosKasW02ymxh/DLkXAtsy+Eum2zb+f8ZavQJ7c6TurU+gHnC6uy7yUUz9nnpP1D1VGfjLVrwqntbacdQ2HsaQxjteuLftav+6gKOxUAFVL4hZbzNxBSwufAXb+TctfU6Gh1u7A4BoU6LrN4A6SgnLgZ5FOxecfwEHf+QkdEWWOcv44+5cHsjL9oLFQjpw3fHts297w+xoLiOKs1TM+FxzooRdh4GGLLPQSm0LpB5mr2IvzV44eTQgqnlMgmjvjB4pZxxcnDsDl4y8LE/5JChUkT/4h3qXafRrFXWIOdnLHqQmc8aWw62zdLLeyJMujJhT+s4OEB8fy/zasDy9K52sRo0ifCA3vXI+D26+mlH3tJ5JWDaVTJ6
 GbRV17za
 n/EGFEujke7pUAliZt/LrZLloelafPSSdlyQ8CgGUs5S78UQhy3cYqMBQmov1weg2OCWAtb+YtcWXd/ZUB5C64BoPpzn/3El1y9apK9E0EmOCnlMEV3lf0nH25Me2lemQcrZiUe/l0miq3JavUFmcWMjswVszVLrSnyKD9DCdHPshzICDvkdZrs48LyS3zPrwbFIhEYq4f1JeYJNhOco3xwvd4ssfIujo4l37fmJZiAtcLJJsOFZWL8j1ewpo9izbcMmr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/04/2026 20:48, Josh Law wrote:
> [Snip! :)]
> 
>>
>> Yes, but he also writes (nonmm) "it's pretty quiet" ;)
>>
>> So, MM is the real struggle.
>>
>>> so the (basically) orphaned files like glob, or smth like that,
>>> could go to someone who understands the code better and more likely than
>>> not, has time to review.
>>>
>>> We may have to have a think about this.
>>
>> I'm sure
>>
>> (a) Andrew will enjoy being around and we will enjoy having Andrew around.
>> (b) If Andrews workload is still too high, even after MM is handled
>> differently,
>>    or when he wants to completely retire, I'm sure he will speak up.
>>
>> One step at a time.
>>
>>
> 
> Agreed. If he needs help reviewing patches in lib, he can feel free to
> CC: me, best I can do showing he helped me when I first started :)

NAK, you violated our trust and you should not be close to anything
related to MM or lib.

Best regards,
Krzysztof

