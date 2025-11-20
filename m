Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A38A8CF8859
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0EA6B0007; Thu, 20 Nov 2025 08:29:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78906B0088; Thu, 20 Nov 2025 08:29:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6796B0089; Thu, 20 Nov 2025 08:29:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0376B0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:29:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0223C1374A7
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:29:32 +0000 (UTC)
X-FDA: 84131067426.22.96BD0BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4F62040003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:29:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dFxAWLwk;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763645371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEEvDbIkq+Y5Mpl0rYfxoGsCGene+u0KC3g+KuciChU=;
	b=W1yP5qQjMMBilqgymIggyDsXn1U29BnfWoBzbwlfsS4Ehjo6NNHRJS55jLN9m8S686GXlz
	/IYEuvBlTWlayOT7KwjHS9anjS29fTvUKi9i9nCZZtM6MwtiMcVfDOR+a7EnASX0s5SnbO
	Y/AcYZPedm90n3rWXcI1vMEDCNKUijs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dFxAWLwk;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763645371; a=rsa-sha256;
	cv=none;
	b=kFTeN/dbqe/UIq6+Wg/qsmfBv7b+IYo9VroPe49x3N4yESdD2mx5sXiB2CawYiO5AJ3cNS
	4SmauyRwSsflEmkZl17vJ3pcyO3vue8UcJ1vtVjeIXWtg5s5eyALK3MqAnSTahJfnM9r2c
	V1EUegD89yg1T0UiX6heUKJNTAUuBiI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EBF960159;
	Thu, 20 Nov 2025 13:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696B2C4CEF1;
	Thu, 20 Nov 2025 13:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763645370;
	bh=WZU8YZVNbH9FupGqUrgw5DmUou46sjiYKi37MvqORC8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dFxAWLwkeJpmG95tU1YvLqrMFtE1xoY8AMaETQkrrGe8tU5jkl/iVac4wQudxnxY1
	 KhPrO9vx2YTdf90paFpoS7c84BMBaBn8bo979ASlHAC+jJi3qTeKDIj/6mCTvyQwRh
	 ZmfJdYunou9FlkmnekDBfMeM0IoCbbrAF48rrujI5XOjtCoqAWXh+uChbl/DzV9mB6
	 75Cmv+9JGkDrlMPffuEGxVacn5h7I0NSCpUgI6VqACNET/MkhqZFmInU+Bfrv2g8pL
	 O6DINDJsLkG+Q1kuMCJjKyN83HUHi74xMqfGW9D29Gzv6x5IWaZfnqVJUlPl2I8dYb
	 Vvy4xYKZuM/LA==
Message-ID: <81e34d93-9031-4840-a0d0-56d488f3bc17@kernel.org>
Date: Thu, 20 Nov 2025 14:29:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] mm/khugepaged: map dirty/writeback pages failures
 to EAGAIN
To: Lance Yang <lance.yang@linux.dev>, "Garg, Shivank" <shivankg@amd.com>,
 Dev Jain <dev.jain@arm.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251120065043.41738-6-shivankg@amd.com>
 <20251120065043.41738-10-shivankg@amd.com>
 <6c1d6b80-d290-4110-9a49-53e7404136bc@arm.com>
 <33476cb4-318b-49db-9cc1-a354eca9e883@amd.com>
 <ef4a0c2c-62d1-46de-9ea2-dd946857a03a@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <ef4a0c2c-62d1-46de-9ea2-dd946857a03a@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4F62040003
X-Stat-Signature: 8yinqey1sebmyobghdn1ao9u6qy94ont
X-Rspam-User: 
X-HE-Tag: 1763645371-447437
X-HE-Meta: U2FsdGVkX1/epBPSnlO8GZl87mWyalWjqs62fhKJAwNebGRWhXzTwWK5pmFRgrxd+V+vZAdibDz8hpD/C/802hKlVl8nMtlvOmHFY6wwZp2f9SMxktTn0pnKXvGof5KxASgkCc916gotTYrKuSW6RrJztCLioQTnSXDSoT9aT3HrgMyrf7dAmgcUgzJyKzZNxSbeG3OEGaTEpcSkw9pi1OhIMS5Mq6yOU5mXeQi1xD5hb+39THldVa1IQPe27W17pfHdz5plknxz2qCZsq9x9SDIl9PeAOD1jvABZzpxRgfvAfeNlX+UglRvU+TvrI59cH3HJuVN5rQgmVlpug6WBtUhef1/1dLaIe6tpaSOv33KhTbMwnBGZPY7ClVWAEZjy7NNvsKkZUspEk3jqzrXK+NKqvN63IUvUlKjc9Kc9ForQWS7zNWEaKpRhCc1V6QwSWSRkGBZAz2SmMAln9wV17cGNCRjFIeUlLVZiyfUF1mYHyQz2N6Tr93DUvOlNNwzLfZXdL/UNSpEJOvy7g9a8kFcJNBaHIJypu1Mn82PSGK1+89fILmqXbXEodKQyEAIISsfnVsDSB51sXvJFwil9LJQWtVGOReDTWrcDylenhOsFK7mSf3Sf5xhgyhegf5L9PTBjyzGx2dkTZv11WERKIDpywrVIJJECdZY/l6tPmm123imOuwJpiyGMvVtNeV7+2li0mEU8GRCiYor02wtfK2TrHm4Hl3l0gS+tftBf0KWsLUzUdYR0taMpSZ4xKTyUPnJRq+Pefr/LzmybzqTfAue+qOQeG+aGBwABQTS+yuEKMQQNfy8HxIpNp1cL9wWtrcItUV+InEU4ICrYZHUhSZiJYtgZiJXSSAJGTDdNtwPDALdw2zbmZO3j9rD4fvAfVuFGU9dLirsVAYxvjARzxw4sYpCJPyQb9zy7sCA46cOd+5fhtEt5ZGYamUzWC7V1UC+zc91rDJxDiy8+WN
 k80NOl5G
 5ze2RygrvGroB4o/sC60+TLyNbSgrrOaWhCRYL7q5SmspsMvmGar9Ixu3qWCM5YQ1V7dUMaVNS8eVPyUvZ0Vw4yPpFd1Gqm29EGIG4S6We7fViG2Sd9Hqs1NNcZUBLyrbGxXa62vo4D9aJd7NN9uYF78i8s3X1hnS6tD8e2/4/kJAYaLkmPFxu3BCDhHKX18KWsVbDsIjoPsmQRzLF93mcbmsbUzKKXETWZgpialb0LrQhl+KhTydBs2ZdEZQ8AFwKpxGizb4/wBzRqGv7x6ZuMhS4q5OXg4v6W1gAj/nrOj9Hnx8OGY7E765lkQxpePI/9oqD3tH+UJwiECkDW9pIxPp+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 13:24, Lance Yang wrote:
> 
> 
> On 2025/11/20 16:17, Garg, Shivank wrote:
>>
>>
>> On 11/20/2025 1:33 PM, Dev Jain wrote:
>>>
>>> On 20/11/25 12:20 pm, Shivank Garg wrote:
>>
>>> SCAN_PAGE_NOT_CLEAN is confusing - NOT_CLEAN literally means dirty, so why not SCAN_PAGE_DIRTY?
>>> Or SCAN_PAGE_DIRTY_OR_UNDER_WRITEBACK? Since folio_test_writeback() is true as a result of
>>> the folio being dirty, maybe just SCAN_PAGE_DIRTY can do.
>>>
>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>>
>> Thanks for the review.
>>
>> I chose not to use SCAN_PAGE_DIRTY because dirty and writeback have different meanings[1]:
>>
>>       Dirty: Memory that is waiting to be written back to disk
>> Writeback: Memory that is actively being written back to disk
>>
>> [1] https://www.kernel.org/doc/Documentation/filesystems/proc.txt
>>
>> IIUC, a page under writeback is no longer dirty, so using SCAN_PAGE_DIRTY would be misleading
>> for pages in the writeback state.
>>
>> I considered SCAN_PAGE_DIRTY_OR_WRITEBACK initially but felt it was too long.
> 
> Nit: If SCAN_PAGE_DIRTY_OR_WRITEBACK 

I would prefer that here.

-- 
Cheers

David

