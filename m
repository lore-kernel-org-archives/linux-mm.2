Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A91310ED678
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B526B008C; Fri, 27 Mar 2026 09:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2E76B0099; Fri, 27 Mar 2026 09:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B2B6B009B; Fri, 27 Mar 2026 09:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD29D6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:25:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2C7D1B962A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:25:08 +0000 (UTC)
X-FDA: 84591913896.13.04B421B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E35C020008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:25:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HsriDbNK;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774617907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKsbFAgisqfm7mG017HSEQ1zaSB8o5ghmrnyILqx8Jo=;
	b=0HfjMTyB5ljz3s0FFrYPoMgKasZP41Gx1bWPrBWz064MhUJqqXnk3hEimf4Hm1NzcH4Tv0
	Dt7lsZN6BvfX03C2l207U+a7Ux9gX+asqR/0mHQqelUNpbz86gva0Y7xNQxS4UnqpqiMGX
	CTEmGmi4MH/wTPleOAwNIbkl9e9cvsc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HsriDbNK;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774617907; a=rsa-sha256;
	cv=none;
	b=IOA0yz+WltWlvY1mFDYDpMnqgLHhyvEszxJ9Dwt4tzbgdagzmIb+dWIqxpWpl4otOmZ//a
	GW7o/fopOEuEO82xXtjwlYwpaKb0kVly+UirkrxJ7r5ufTGoziqFVQ0Ou8MvJeBUOHQy2g
	YMs94iW07/A0bQXkJRhD8EDUPsUxnVQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB4434171A;
	Fri, 27 Mar 2026 13:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4DEC2BC87;
	Fri, 27 Mar 2026 13:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774617905;
	bh=brXvhwyCKp5XwYJwondkNZofipJVw6dyyhnaVceck5I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HsriDbNKQQIc9uLqKb3o3lGxNyauWEo1fFT0hzLpKbTb5nTniA1YcveZi7m5zizlf
	 cqaSPiPne+kjrO0ePUeOhaYrmIVOTVVaMmqtDlpQFaaaLCYnD2Y0HtFqRGhqORFh3M
	 +PafWd9fkkR7YtOnWOlqa1wmvmVRW9A8ysAi+in6csCEs/tw+tiKMYb930rZy4krrz
	 JMpvZ2cGCS2cFZ+nR+KFq52hJjdPq4vhAnxfsDbnf80AxKbPC9RH0duuydCsxD4vcf
	 W4oW1ac0IdcMzsiPfcM1+tjLTd9QS4yj5fzkTDdoRAcyZqV8+GgzPhGTYxzaNQdqZY
	 6qqWH9RCEnU+g==
Message-ID: <b28ebf0c-c10e-4e1a-9e8e-30e6925d0da8@kernel.org>
Date: Fri, 27 Mar 2026 14:24:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] selftests/mm: skip several tests when thp is not
 available
To: Andrew Morton <akpm@linux-foundation.org>, Chunyu Hu <chuhu@redhat.com>
Cc: shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
References: <20260324013316.2590422-1-chuhu@redhat.com>
 <20260324090927.eeacb7987d22ed8ba13fada2@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260324090927.eeacb7987d22ed8ba13fada2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E35C020008
X-Stat-Signature: 8f9enxi6gf1xcn7wkxupk9zuyo6wihe4
X-Rspam-User: 
X-HE-Tag: 1774617906-132478
X-HE-Meta: U2FsdGVkX18pxdgsEJ6NBbBCreAotvymzTyvQDX/xQb8RAnulYZvs6JdEm3SOZhg1Q3G+9BBkbctRasy0wtHXWdXI+yNXQsc4irM/3vy6aaJM4SN8OzKbGpbcw1NjDQ1DD33w+VkgpeHASBwQokM9DbFJDRE4tTomy9ZR2RL3yZwMYo+Mc5A6qfsLSryv0qOZLgHpLIDIf4KDadZO6gIHLoUwer68/6pvJepaFqOkObJ/QzgEnQ8siJqHbxjY+h580G3PslnWl0y2ce384VPqmOqhIcDhTWR+OVt0XaKp2ymM/tjjlJn/XOYWZ3hAHt5FUAHtDutgnrL9QjPy6/kpq0j92wfq9YmHQUQV1QzRl8xoQ3xFbeoxbVYIuk3OWDokWvez6IxDoVxJdPrSnUWValDe0gs/KkNYP4nDHmhub9o81P7GHloteWlNfusDOj2wEx9/cPiB9UhvvQaw0oDDGM4Tpsi6A+NkJ1ILgqLDvPT1cLMISZgh9aJM2H9raTOKcNONoEuyD7olKtJFcZm3aJmPaNsuBmUGXoRdQ8EPOMdjllO+MgCV5f8+cINYtWLIu4yRt52QIElgk3aE0LqCGYKL75AUvEdc8hT9BzqUCgKpyEYJt0n6s221wOiEXaIh8aXWBSvW6JqSNcn6379ph3Rh8TuRjafHsFoRhzMUc5LHwQ17kveN6fCKw8uVTK0c3VOT5Gce82ZOLj4OH9CKkfCcFq3WWbjUWMXhRBeqIP/5xIeYah0vP0twzvdIpNWSY8Msl+tGbDSAh3K8AUwNmSSHKUkSI868Vp1DZub91vds7hjjfXMycsDdJs4DKmT+hKLmlhb6u0/Kw2jPJhdbDiLX4DOFx+j6l3/98MgNWSQfI7NkV+Ahrk8RrLJNuzayD6orxGTP1F2jLgwog6iwmtnJSSG6ImIQCEpftmtpLAVcxDCUsaPNMfHvn6zegYcyxqJtvThTZK690S0IIw
 cbRrg6Av
 dtqSbhHq4BUhVpSlA+n0gPMP7XpM1BJl72q7LyRvZbNUMaF/SBwwVWzhVqwO0fFAMCL2pX9G7A6n6GSMYdH8mg9LTpiUmKdhBW4WA8Y/Y51rG84EFZe38gSOKzTfadslBbprgFChoMZ69RsSucqT2o66mUOnv1fL9YINh+6l90VRjQfIVQqK9Krn/USj/CwYyvnYZQ7/2L1f1b1M51iggtuWx4lWNKEWGbJ6d90XrGGklc2N93h92jmXqhleI1iphrxbL08iliMYgPOpid288aoj2y5QwtUT1x+4S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 17:09, Andrew Morton wrote:
> On Tue, 24 Mar 2026 09:33:10 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> 
>> There are several tests requires transprarent hugepages, when run on thp
>> disabled kernel such as realtime kernel, there will be false negative.
>> Mark those tests as skip when thp is not available.
> 
> Thanks, I updated mm.git's mm-unstable branch to this version.
> 
>> Chagnes in v6:
>>   - patch 3 add reviewed-by from Lorenzo
>>   - patch 4 handle the errno before and after close(), suggested by AI
> 
> Here's how v6 altered mm.git:
> 
> 
>  tools/testing/selftests/mm/vm_util.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> --- a/tools/testing/selftests/mm/vm_util.c~b
> +++ a/tools/testing/selftests/mm/vm_util.c
> @@ -785,15 +785,23 @@ int unpoison_memory(unsigned long pfn)
>  
>  void write_file(const char *path, const char *buf, size_t buflen)
>  {
> -	int fd;
> +	int fd, saved_errno;
>  	ssize_t numwritten;

Empty line? :)

> +	if (buflen < 1)
> +		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);

-- 
Cheers,

David

