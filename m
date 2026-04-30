Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3685FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 14:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE816B008C; Thu, 30 Apr 2026 10:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E2F6B0092; Thu, 30 Apr 2026 10:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394A66B0093; Thu, 30 Apr 2026 10:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 290776B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:34:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 929D042184
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:23:15 +0000 (UTC)
X-FDA: 84715439550.03.7B321B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 857FE14000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:23:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bo+Zse6V;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777558993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRIhIhfWQarJq+vbQ09x+VRvmGeI5gMJjdjE4BbnXtg=;
	b=m0ca0hZUtH3RDs6G4N4C/fHwuxDId3hjzYkJ16eQtWxnlJEZ1vai1wf7RV+MYDnXP7BQOK
	D8sYl5syAHD5BmwMWo57we29sAW274klH8chn1yhK8QCNHthwvYR3t7bmtPRmZFuNp9IVV
	iY6PmF5I/TuUKGDZ/nC1FsEL0jw6qEw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bo+Zse6V;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777558993; a=rsa-sha256;
	cv=none;
	b=kG573I33H6PEyPBlB0TKrfzx88sCv+ZIxH+9vpqF+7waxUvEVr2zm4jWG7g7kES4AP1ey+
	m/m+uEqDPSw+X2UeuanG9N838ChQ2x/YenDwrtb08OTnrioMJDf7ce3YiwmNRqyq0Iyg+1
	D26XAFT1BkGI4YsLuwu/ouZYcKI1ybw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C6FCE60142;
	Thu, 30 Apr 2026 14:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8198CC2BCB3;
	Thu, 30 Apr 2026 14:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777558992;
	bh=3jHMUOff/nZ9R/Xcj/HJoNcMYlwa7TPQ5h+WNWo/oSo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=bo+Zse6V0iUQDGUzkiOtGddBJvm4cAL+eKMnBN9xHemXkz1HEnw60eVR4Df6NkvdV
	 tbt4dEht5oFB+iC+wdx8CEmNctH/8FCRkAH9YOF0UM03uwWl8sB3vLCqv7Vy5tmNOM
	 G+Gkc3ferf/tfPsR84Z502aEP2zzkBgG1p/tIqy+5aBAJj71Y/NqJbmxFYievRij6X
	 Lp+UH0mVMEp/hp925oPmEupSoFSBabsIejvE1Hi+Bsn9pFnIh7JKwr7SPpCmD3M15Y
	 XveMidZHaICFHe6JzgKSmE9iAGFrxlTvDeYRzU9kEwCvledEeqEHtuWF8eyzewDgrd
	 MzrnG2on1CEvg==
Message-ID: <b31e1b5e-511b-4213-a8f8-d9721959d709@kernel.org>
Date: Thu, 30 Apr 2026 16:23:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] userfaultfd: merge fs/userfaultfd.c into
 mm/userfaultfd.c
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260430113512.115938-1-rppt@kernel.org>
 <d5f17a01-4504-4a7b-b58d-c183cedc37f1@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d5f17a01-4504-4a7b-b58d-c183cedc37f1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 857FE14000A
X-Stat-Signature: yw3xphwmrsuxdrdjh5a9a6bd6mpgz6kp
X-HE-Tag: 1777558993-261986
X-HE-Meta: U2FsdGVkX19MUgWADTZCAHkaZVl4NGBaXeRe+ykBRTa5L1DUQkAySIX1CCSpTA6CIf6txD0+RtIQ+jZhUw664/ITBv9ZPK6WSq0OS49CNgQBM++gwiM27BNHWbSF1zxJuedkzAp59/5oHaSh/Gx0OoMzXw3ibDIZ+wQvYs1bA2hZSuoxfGVUJ+XRPKaUK4H/5XoBbUPdyGVnBdBdX/2HLg7AloSh9NbC4i4yBby5a/kcEnGKrmYklLSvonLcAi2W0REFELEX4nEK0oyOhoauEY9xVllr5qWA1jrr4nvfzktyOv2piOMaMaV1NXc42v9y/ZwqP3veAPlWNnhp+uCJJ+5gOQrlB7lUOD15MB9r0lKG2TC37fTNGzAuQTWNPj4zSvJcWfbIXHOOcpqOG2mBBZc0YE9s+tBvWByuE9gs7fgD/OD2IpkuaDubJqKyWNQJtTJJMcqclfkwRJcghY6WezgfC5U2DeKrzOYAQxXeBKJ5WR53SpFcLKzvU8rwH/HxyahJt+2tqNKwYjTYFYaC1kIx0ZFV5j42Lo1KK1dXlagRLy2UBTSpgUP6cCZad5kPsfMoLb6TLGi/QTYhue0arzhBDdAhBcXW7M797ulcoXbJ6mOPFYttEf6y2KNdH0eXsOOwdOSTOsYvDiSZQWkJeUGyfMjrGObZHSAJY/p7dyKRygLMDbNPETSzuO4nlmvnDMFYTQj3HtPBYHZZEHAhzQa9K5XtFc9xd4dor9m/gNOBC/njsko+iOtdNKDsVCo81zsQnvBVD+d4yhXbZBjqGfK+8GjUPBe12LZITtA7cOd88XcrpR5IVEiKqZ3rmXsJ84vLBA9dMaC2SyokU9s9zWM0kVhi8wAiMUqr5lT/ENQEoj8sYR0D59gSMBUM+ILYDqHXmLXDfp3yNIG3FsvsrRlu5tyFCQyBpJusI/0RXkp9OdPAyYQlGeh84CcMHwseXqlTj5dd60hbMNbSqsz
 mmFrz7U6
 ZR8bs7vYxaGb1/SRxWjxr6ifYGt0LZjZojMPZHf6/6VGjj3tyRHvERNvRc74tfkZSnrmmgszxafpLlAvBccEOeCCxqEVe5nK6CiGXLNQu1tmJ23/CCrKni84hj+Vr3+H8RW0in1JVzF+LiZrWi1lKO5NH94qX6IH7pad8hr/O6p4Tjp1UlaT+Btd+qtYJF2AGK4skMdsLB4MhgXHzcl5QVcGdTTGTG4RJaJxu2DCrso/HqevM7wmtuF73SizfHIO8TOzv1E+E4B6jC6ubBLOci0PcnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 13:38, David Hildenbrand (Arm) wrote:
> On 4/30/26 13:35, Mike Rapoport wrote:
>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>
>> Hi,
>>
>> These patches merge fs/userfaultfd.c into mm/userfaultfd.c and make
>> functions used only inside mm/userfaultfd.c static.
> 
> Yeah, makes sense to me!
> 

Thinking about this, is it reasonable that the kconfig stuff stays in fs/ ?

-- 
Cheers,

David

