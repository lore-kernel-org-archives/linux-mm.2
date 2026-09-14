Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 155BFC88E6E
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 08:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A036B0088; Mon, 14 Sep 2026 04:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BAF6B008C; Mon, 14 Sep 2026 04:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61376B0092; Mon, 14 Sep 2026 04:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 884E36B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:32:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 480F4C1250
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:58 +0000 (UTC)
X-FDA: 85211702436.29.9ED84E5
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf12.hostedemail.com (Postfix) with ESMTP id 683F940006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bPjfrvER;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789374776;
	b=OcvH9YUfiuozMek6Y8NopkUMeGUdQBhEDMFl8BnwAZ3BQA+4kEdJ1SKspEeTblnoDz9brQ
	h5n70N6nj6N1UU/KeWjztrJEN/seLQBwEnpOgww0RViXdTpbCJGlgrEYJ1RjycFMjqgfhE
	BqgBT20HfL8oQ4zTDZUNGuWK5DwdQRk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bPjfrvER;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789374776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5SgxrpCr+3rPiETqStc1WoDgDVOaLwcyekKiy2XRu0=;
	b=eCqjCzcsiGS950B4tENFLxc4lFe5rl8tprgak6eSPIWUSFyfEy0jQ7AIzt1xu7ZxB8pQw1
	9DJgWG4t2jAAdD7M4Cqd0X5mDI1jc9cRej60gvBmnbfVZLCvZxVeq4W1rEnrBN3VpoG53h
	XTXDzBiZOkJjbzfb87D4J9EBeHXihQM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789374770; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=V5SgxrpCr+3rPiETqStc1WoDgDVOaLwcyekKiy2XRu0=;
	b=bPjfrvERnS787nd6X/u8wHOITjBrc0aGeVj97hF/K7CpXeSeZzjfZHAApjXrP4riqZVmYVkJvOpq6SJwrahXqwU0UIQpU27YTGm/PdahfzkeBamwo7QYuwUrwWDNPDKXEZ1UNnYc1xO4jlxCnhH+53g6zX4AXsszdbpa8EWipeU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XAtYEDx_1789374767;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAtYEDx_1789374767 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 16:32:48 +0800
Message-ID: <e4cd7338-9ff2-4fb4-a5f7-b1ccbd71603f@linux.alibaba.com>
Date: Mon, 14 Sep 2026 16:32:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/12] mm/collapse: state what a collapse may do in the
 policy
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-6-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260910120238.2529819-6-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 683F940006
X-Rspam-User: 
X-Stat-Signature: 69daghmhgbk5w35obsyeh9ts97nbnqcm
X-HE-Tag: 1789374775-958810
X-HE-Meta: U2FsdGVkX1/fzoZFyW9VNt8x0uI48m/DCn/+AYkdHWZEyrGEm2nbuZIOhUsYlHLhWNLKO5NY9PesyqLyTQpK0TQ7/dycOhMNBL9UlnNDamuGZGyShg0oBRGLnhH/s3kio+elqkJnQixXSmfvOSn7yCbjeqevACVHR6IRxsXvLr5nIRq0luoJFAnJywLqfSMbOPuHfL6JMBccaqQsHB958Q6Li3iwqksXOZQtR0YWal4T+jwswoQ7ChvpmpJJz8SH2xnbloQHPTkhQ4+bNcA7V8PpzlllscfHuN5xhDPJy+L+W//A7DZ52sH1BLiRKtrxyCTJp2VckMYhTof424gzcncFXe89kUG5iJVoCcdxCGe6lTQruMQimkIYhpRwM4g/G0ej+XqPcaUKJ9p3GaCbNPliTzM6vkVExiwkeOAN+JMQAalZBGM+z0qvW6DrfltVhepWGXqBz6LM9un1BI18M6BedMZXIYmGzJwo6BcmQ2eOpmzG8sbaqzUqHZ1cFP3uLfkkOn5B9xF8z3qZwKt7ZqoT3cO5+AlKT/QkXBjlbEgxUvKD4Uszn77Q4jteFjxg2cwO22zrqfDcsJ5Plovk0AlY//5eSGCGUraLH9t2No+nKD4xMbWeI98BGFZFs1FOPx3fTjMHnwmfMXRLuWm3urcWHKhV4Yq6DSJ4PYA6l5vgCFiGFvvGZmiev7RbnGorBVSNT1hmrNOr4xf/XPlVkYSEAzuS6/svlGaZD0DPDH3hIrrogdQBiaLulLLfY4droC7hLn7nSGtSzShn4stCPHGHubYxpmrEDvHwo2B1mfzwx6TxBWAOVOXZd0e8ba768Tei+0unx1/Ks48IZxdnfQjCPOjniI6N1Nf3HD2i5jzE7FysM0zlNhTZ2acc6KS6uGaS9nCjuGR0ykO3AX4+opWyzro4dcgn/axwd+QaoeziC6//O4ZE4Ph1dPLLfS/iIv705W1g3lw+chdLDFz
 G6MC8CWb
 mabr+cqMqPB5QCZMzzqzTv5/8/UWYaJ/9bSlocsVVqzkZS+0JOFcfA/USHzVkQCkq1NBpcmPEouiLtF5JSEbFOZg0crHuzsjLL4dS7vbc23iSp5zskRtnt4EDeIzn7tG6hjy12LhzjP/tfIec2hwufZvVOtJyaUTYa52OZ4yPGJyhK+0UZfDzcX0mdQpJlc6Tw4len0VUAk2hXYelgnI+7d1ZH9N+gPdeUA/RSjxnSXk8apKkuCJZkZdpUf3GVYKg8sInxxqw98i3jPrrsMZ+/RRqdE5V/M6aqcnskEXRX0e1gOec4RBVE5vH4+rFn8ZfsSeigQ/zrnzVXZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/26 8:02 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Tests scattered through the collapse path decide what a collapse is
> allowed to do by asking whether khugepaged started it.  Between them they
> settle:
> 
>   - which VMAs are eligible, and how hard to try for a folio;
>   - how many empty, swapped-out or shared PTEs a window may contain, and
>     whether a sub-PMD window is held to a stricter rule than a PMD;
>   - whether a range has to look used, and whether a MADV_FREE'd page is
>     left alone;
>   - whether the PMD is mapped as part of the request, and whether dirty
>     pages are worth writing back and retrying.
> 
> None of those is a fact about khugepaged.  Each is something the caller
> decided before asking, and the collapse code should not have to look up
> who called to find out.
> 
> Add struct collapse_policy for the caller to fill: khugepaged from its
> own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
> Every test becomes a read of a field, and cc->is_khugepaged goes, having
> no reader left.
> 
> khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
> call.  That is the one change in behaviour.  The max_ptes_* limits and the
> defrag setting behind the allocation mask are sampled once per pass rather
> than on every table.  A table scanned early in a pass and one scanned late
> are then judged alike.
> 
> collapse_file() also drops a NULL check on the collapse_control.  It has
> one call site, reached only from collapse_single_pmd(), which dereferences
> cc unconditionally, so the check was already dead.
> 
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Thanks. The logic is much clearer now.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

