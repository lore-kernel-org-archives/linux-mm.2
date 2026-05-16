Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578E3CD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 23:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8456E6B0005; Sat, 16 May 2026 19:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C7F6B0088; Sat, 16 May 2026 19:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759946B008C; Sat, 16 May 2026 19:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 64BE16B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 19:14:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 117B01A0457
	for <linux-mm@kvack.org>; Sat, 16 May 2026 23:14:45 +0000 (UTC)
X-FDA: 84774839730.09.67459ED
Received: from outbound.mr.icloud.com (mr-2005g-snip4-11.eps.apple.com [57.103.71.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id EADD9100005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 23:14:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=yMeRoyrm;
	spf=pass (imf05.hostedemail.com: domain of cheesecake2960@icloud.com designates 57.103.71.73 as permitted sender) smtp.mailfrom=cheesecake2960@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778973283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zVePlSPbB8tZaMeUqvI5r7tySGsEW1UJvhXgOHkLv8=;
	b=4kDiXm/m4RBN2jSVgfHB1o2ig8SQwrLh1N8vZe7JxprIworMOKRVaeIqvmMvNaKRfArnqB
	ka/J5+EZbUjbLwAaLYgdVjAmf+EUkYFokzLH9edmSNBYcH3E1wMOxq+qdM5wElj6KppZ6X
	JVQsl11yG/7RVfflzGUAzzWhN54AYzI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=yMeRoyrm;
	spf=pass (imf05.hostedemail.com: domain of cheesecake2960@icloud.com designates 57.103.71.73 as permitted sender) smtp.mailfrom=cheesecake2960@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778973283; a=rsa-sha256;
	cv=none;
	b=Of1xYJrWWIFTucUsSn4+ffnlTL/9YG3znVo9mG+ciRxlVTwP7gq0bYFtg59YuP9yW/ua0n
	c39uspADYMCnsrxApJrIGJBMkP5nsTBaLP12/HnpV6F0PmdlFKweJOAg7S8NkbJYvCHccw
	K7wnOp9q6QRchOrizN60xTE57Pcun+I=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-0 (Postfix) with ESMTPS id E96FD180014F;
	Sat, 16 May 2026 23:14:40 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhKBUMDRQBBCFYBWANLVxQEG1sIUhhXE1gTVl8OXQIwUBtfAkIPHBNWFRMLU1ZRGFwdQAhUClkVC0EFXXcCURxWDVdDVARfUEsbDlwCS1oVVRcOAkIfUB9MFldDWhkcGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKAlEcVg1XQ1QEX1BUEVdQC1JXEQpJAl0BRgtDXEweWVQJUF1bTQULGg9XR1obVgsFXwQVXzhaDlsERxQXG1wACUtGCUkdDgRUB10FXQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1778973281; x=1781565281; bh=/zVePlSPbB8tZaMeUqvI5r7tySGsEW1UJvhXgOHkLv8=; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:x-icloud-hme; b=yMeRoyrmKaBhjYKor1AW72OHUCOd+ptW0mkDPf04aBLfg/B1SSbV77JJB7mK0CEZhgokRf/xylM2NW6cGi4ktDRx9f59Kq4oE5XOIW5jLY+Z4xKuQlY+SToBkrBtSAxpd3iG8EYmqS7oL7ldnQoIc4u1jzLtwtWxyv59KLcI+8oTGS4RC+MA2e7GmDZ+jVX0I4v9wk8xgbr6NPZneK2ESRA0mmyXZbLbagJXt+H4no+MLUESCGzT+DX1ppi6YocxtX/IEBiEj54DhnU0JYoO/3j3sPETdsGrEFvKTPtk4St873tCP3L+/6rt+3qMYGpmwGEZpucur7AWbOwNuhAOig==
Received: from [192.168.1.33] (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-0 (Postfix) with ESMTPSA id 788201800146;
	Sat, 16 May 2026 23:14:37 +0000 (UTC)
Message-ID: <9ea31106-93e4-4cbb-b56f-de7ccef246ef@icloud.com>
Date: Sun, 17 May 2026 08:14:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: fix typos in design.rst
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260516170847.146524-1-sj@kernel.org>
Content-Language: en-US
From: Cheesecake <cheesecake2960@icloud.com>
In-Reply-To: <20260516170847.146524-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: pixu_aVUBLdvevj9Cz3LevPRO61nP8sx
X-Authority-Info-Out: v=2.4 cv=bcFmkePB c=1 sm=1 tr=0 ts=6a08fa61
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=sIGCgqHK338A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=v3ZZPjhaAAAA:8 a=JORHhQuN_TVeFzD3vIAA:9 a=QEXdDO2ut3YA:10
 a=zY0JdQc1-4EAyPf5TuXT:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE2MDIzNyBTYWx0ZWRfXzpv8BHIlWj63
 3jfaMPHcz/h7PH3Pu0ibIXpZvtyeE/o0A5D3rC+YmTWAkqiP0Lwrr1jxy8xTs3sHZzxzdKvFG3a
 CbovpU3V2hljm3X7DQHlePJeDkmfFARTS5sK9NYNEm0sT6UlUTtJsodikIO1SxVVdHbvX1H5in3
 kXlO1cB+RO1MKA/HiE1tff6ScgNqzVhDPmR2h2MluZ90NDjb21/W0gt3rMtatB/kkLfABTqcual
 1n+MBnFD+AwBi76GHZ4W3Tvn5Bf2AtSjzv0ZgqfnN7vdhCjFNf801vgFZCPWHiappA4wX0xQYKv
 2lvzZVJQBeM30lG8NiqaNIIrjAhRLeIb60yz81KvGv5pNR8Mr4HvrvB2CUXwcQ=
X-Proofpoint-GUID: pixu_aVUBLdvevj9Cz3LevPRO61nP8sx
X-Rspam-User: 
X-Rspamd-Queue-Id: EADD9100005
X-Rspamd-Server: rspam06
X-Stat-Signature: fwissrktot9qnt5xefx44hnsy86rxz11
X-HE-Tag: 1778973282-414869
X-HE-Meta: U2FsdGVkX1/FCl3Lg3titzSumgpvBdQJnJB8H2mtjhQBm5Xb6mH7LfnWZ0N66ltqH+t2sb3KmClSvWKzemg+BlxANANo1IWBLmsbuT3khf7cYV9EYKXwnNovCtjJR2bB8Pv5L8GwXNVw3a4yhMKW+i+vAgpg1z9fYcTMkzGlhybklDfWTjz8W1cR2XJ2q9pTrw5daCk3LlXw4IVnlFF0ppceNa8m1MSAjbDM8lKCHHU2271nCaOn7+jYIWBzTpzsMwxC4zsTl9goKzJElLTEUuGETQP734cY3KTWyb9c1zbttONAoasL5m70RwoM8dEmpx7jyaP2ElEhZ1ooDaVCY9Zpkl4juIdn/sXKrFutgK4TfXGCBW/eycD2KTs7CKpxBFyKm1nDjtFqL1D+Rr1fzWGX/IZ/Bw2aWyevTzA5iFC5uAkeM1n1GWci14U2in9qknGdnaenpwR6xUyCI4o42WDnungZpD8DGQICN9FpdU/8mHml6wVdKtTjy5o80e7hzjR6oWbN4SU1JK3upp8tyWT7QFIC6yyh7R2uSGBXHobUcpY8hfoXZOW94FZAy7QZ8SZ5/JGzOve8zZJxfnuIqBXmddmEMMeVa1Bo4Hd0jKUjF4tVkDAJoFeNJBEeQ7VwPZRt1EjcxGF87+Nvv5aukhZvstMu5g82phyzHAl763zdwo1A9pLV1gqWbV6stDWQZTqfKMMsO2Eucxwn2LRfVYmNUGPMmQdGAjC71G/Qmmo5mHxAJfwpB84ck/izzJzdo/l07Lyo2epY/aDt7vFj3ksu850uKsFllw8EmUTfZEt/4New3AcGBnm/2vJpP/kKqOOBA2sS7PCK+cXmWEcLUQ1TFvjsbtdeT56miAKVGwM9nhaX3ZIYkaaXArHZTqAUvuw8ECbtt9mIc8gkNGAkOeZNvTRV9vFrmJBJsYCEBRq6wG2rakMIuRmhzI4Mi3+j7p8Uealc/1oNfEtntoR
 JNeUGl2m
 9lH8CC9ZeHi7BKbCQKZNMKLIa3INxfsELR8K4m3qKvnzLMR7tNwZNNlTUU1VQuOn/xBxyYmx5wjmyVYXpqQXNYLuDO2683axUhwKiTjkDx+Va5K5vQKoo6DswphgxzrptLDl7lPy/blwDNFytCJZdxZP6gP/fhxkk2snkpm7I/P3kGcmZ/LFlyYgzCNpXEkDEsP80D4Rr1ReZPtyzbJiCWkR43BawY8XefxO46KHwHs1sMFzvsocQuptJdrLgwXu/APYxIJbXilcFG5WTR7JONNORbTJeSQElXUMK1zueFmeIgMqOHYb7x8QDpJxB0dg9DzNRFHyO7rFbQy8E60CXmzyuP3hqHPbulxsHRea+G+HlXfCQDM3qlKhoBezUV+uvqeozsW3hpIKE5VuO6vtyMzUzHTSHZivAZVqUIXRtEugwtayNrXGvqpPQAf8dPT5Cx7B9GNeIS8tDCn2bYzJVXuo+mI6hBQxrb4z216EAXjdMRFuw4bsGXMx87RGcfHTzagIV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/05/17 2:08, SeongJae Park wrote:
> Hello Cheesecake,
>
> Thank you for this patch!
>
> For the consistency, let's use 'Docs/mm/damon/design:' as the prefix of the
> subject.  E.g., Docs/mm/damon/design: fix three typos
>
> On Sat, 16 May 2026 18:35:37 +0900 Cheesecake <cheesecake2960@icloud.com> wrote:
>
>> L140: "unsinged" -> "unsigned"
>> L371: "sampleing" -> "sampling"
>> L387: "multipled" -> "multiplied"
> Thank you for finding and fixing these!
>
>> Signed-off-by: Cheesecake <cheesecake2960@icloud.com>
> Is Cheesecake your real name or known identity?  We don't allow anonymous
> contributions [1], and mm community prefer to use real names.
>
> [...]
>
> The file changes look good.
>
> Could you please send v2 of this patch with changed subject and the name (if
> Cheesecake is not your real name or known identity)?
>
> [1] https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1
>
>
> Thanks,
> SJ

Thanks for pointing that out.

I accidentally sent this patch using an anonymous address/name.
I'll resend it properly later.

Thank you for your time.


