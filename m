Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49686E91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 14:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAF406B0089; Thu,  5 Feb 2026 09:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D0F6B008A; Thu,  5 Feb 2026 09:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969036B0092; Thu,  5 Feb 2026 09:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83B9E6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:30:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3766213B34A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 14:30:25 +0000 (UTC)
X-FDA: 84410638410.22.5ADBB87
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6258D4001A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 14:30:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770301823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kbGuWUKKZxIJ4VyHIs2tT7Am3jzrWJWN1tlp8PnhERU=;
	b=KCIU0cnsO3FEwdDH86kd25cIWSkPpqPCssWUk2YwLJRyIHuAYxNSeZh7Nj8QC8EMUigc2L
	ijSehBcdhXC2tw5k0ESWGfzC37waGXd2b504prgY36Lemu1grUv63IABE46JI8quXNElYC
	JYakReSY9g6r7JTV0LqYjOx3VLo0MKI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770301823; a=rsa-sha256;
	cv=none;
	b=doNHqmMCMO4y92xvPPXZbJ3jljeZqSVMa7VLT53WnD4nz8gJw5PT9oVg4YD63+7RolnSZ/
	wBKDhlWNFHOFXghIGquLSCz/VuHw/oKs9WBU9N5jfkGvuWISF+ZETxTJrzo/VlOHzs+Ogt
	9kTvmRCpD3nly5Nef/OVU9TbbkeT0/g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB4F3339;
	Thu,  5 Feb 2026 06:30:15 -0800 (PST)
Received: from [10.163.132.75] (unknown [10.163.132.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D94F13F73F;
	Thu,  5 Feb 2026 06:30:18 -0800 (PST)
Message-ID: <acb25f5d-b099-42a8-be26-c60b79502e3a@arm.com>
Date: Thu, 5 Feb 2026 20:00:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
From: Dev Jain <dev.jain@arm.com>
To: "David Hildenbrand (arm)" <david@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
 <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
Content-Language: en-US
In-Reply-To: <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6258D4001A
X-Stat-Signature: om9c683b9cpytc3irux5r17yt1zjbpfw
X-Rspam-User: 
X-HE-Tag: 1770301823-260669
X-HE-Meta: U2FsdGVkX1+KaXRl/qhxoCdia40gvdNkxoi7eUl04OzD5iVs8m1sj4UkVU7QbcMuwp9boAk3ODxamt40cYCItpVt4k/dQB+23JfCUEZKmDIJ460z804X1uXDpnhmCK9UNJlTo3qDzGesPjRWfKdihwYpACXr9OSD38bnkWxrGMDmp+C80ebBO1vu0xcfaVH4lLHCZkxmKGJQHgEULILIsMdy20trIl8dm4eJitXdsRIu9neQSYtEbU5RKxaBpqu/krVq6KFigQtz8g7unX5PhJPoFq/LoTqmtSkmoLwasbjUSaggFatZpP5xdVHDd5vZGkvLk4+w8SoIg2FHv0f9NJLfC4mNqvEH780/8K69TXSYUqId+ZHv64L+KcGK7Q0jlZ0+4gMexZSiMBy9YYZHBiZ+oAN5TiQO+vOktLh8tIDZnY11OThkAzt08hKzKwvwiEZMAiucL90aDKN4y4WOk41O035QzwATazqp6dvvavP6cOvJuORfBFMydcE4526CQ26rZtxxSRDaP7aZoc0ws428XLVtPT8p/jzfslJL7CWYVmWNY0X223qi7WI2QaOuLyxw6sPJJ29ypTrGNTFNmj8EiukxJarrm6XwJvudSjO2RE/vxm3GYOpDNpNdDvPgxtilUYuU8R06HuCE4m+1vfzCurrFjvm9clcGtI8pRq7fa+QjxTuYe3E4Dw6jbm6Qd7AW6qjmvZ9rw3SRJV+O86Xdn02KkKzCaJCIQDNR5sF3w5MhnaC/Yk6rS+XdrgQQi4xKw+6UKREp72Htcju/gOA5lDTHA+cDeX5AnpSN3SrNiw0Xnb5JNKMfGj5omGh3hrfJU5AWAY/N8XBkxR14JRrPFjdlvVzmS1VzVqPyYGMcVrMTXrfJckjoUIhIs06+c32mCaYNmW0FBZSD57+EVNsBDUzOaNRPTzwDIeOoAWpVsUwSFTANrlzqe7jngBrPxEddbVmiVoVsv0LAmqY
 DPvCrnzh
 6D2g/4EMjMrXCj/GHwYQnMaovsOf/M5/bsoKMTeoMQhGhr4JM0xXH0USTgK6qkYJv90DASiq8W54K/0LYptG7aZ2+LTFlumgMYJUObyPv2PpCMyJEJ81xa69adA5yG26wLhHZy46hfw4MM9NiQ8AewAPeswcIH4HNCIeGVqG/3SWylmST9GTMzXZ4MTjdVbRafufo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 05/02/26 7:55 pm, Dev Jain wrote:
> On 05/02/26 5:41 pm, David Hildenbrand (arm) wrote:
>> On 2/5/26 07:08, Vernon Yang wrote:
>>> On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm)
>>> <david@kernel.org> wrote:
>>>> [...]
>>>>
>>>>> +     if (cur_progress) {
>>>>> +             if (_pte >= pte + HPAGE_PMD_NR)
>>>>> +                     *cur_progress = HPAGE_PMD_NR;
>>>>> +             else
>>>>> +                     *cur_progress = _pte - pte + 1;
>>>> *cur_progress = max(_pte - pte + 1, HPAGE_PMD_NR);
>>> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().
>> Yes!
>>
>>>> ?
>>>>
>>>> It's still a bit nasty, though.
>>>>
>>>> Can't we just add one at the beginning of the loop and let the compiler
>>>> optimize that? ;)
>>> I'm also worried that the compiler can't optimize this since the body of
>>> the loop is complex, as with Dev's opinion [1].
>> Why do we even have to optimize this? :)
>>
>> Premature ... ? :)
>
> I mean .... we don't, but the alternate is a one liner using max().
>
> The objective is to compute the number of iterations of the for-loop.
>
> It just seems weird to me to track that in the loop, when we have the
>
> loop iterator, which *literally* does that only.

I realize I shouldn't have bolded out the "literally" - below I wrote that
I won't shout, but the bold seems like shouting :)

>
>
>
> Anyhow, I won't shout in any case : ) If you deem incrementing in the
>
> loop prettier, that's fine.
>
>

