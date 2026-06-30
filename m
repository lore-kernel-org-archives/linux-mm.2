Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37810C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CA96B00CA; Tue, 30 Jun 2026 06:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E566B00CB; Tue, 30 Jun 2026 06:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DF76B00CC; Tue, 30 Jun 2026 06:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD7CB6B00CA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:34:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58B93140446
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:34:02 +0000 (UTC)
X-FDA: 84936218724.23.607D3D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 89542C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:34:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+zXCaY5;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782815640;
	b=WvRjEGzejmlPvtoYgN33Q2E3ODuXgIh46FdX4w4iBo+DoTVhyTADLwkx0GTKg3C2t9qbzm
	2hZLgNPW/UUuLbBllrQJuV9UU7aRiIlq11+qIfKMw7/eoOPvfR/a9THdIGyQS4L+7DhyJ5
	RS9UyCRfMP9ERRrFJgJ8qSFVWtpVzYA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782815640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gsl3tPUdzUJBW9EALbXP0CQ+gdTQn4E8pzPSD9/4upk=;
	b=jPQ4W6mrtN9XuCCPyrM5TUQPH7Pjf++u7cqoY5OqHiEvaYTXSmY6+J/R+83xaZ+fhXI0yM
	EUO1Hyq9hngAt6FGQ1nCFoAmsJy8YtK83X23j21ldz8SLvWClYdKMZY+vvauNWhZZ5PQL5
	m4ibjTmlunDI0PBy9Irq4YCA08VB2xA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+zXCaY5;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9B0743714;
	Tue, 30 Jun 2026 10:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73051F000E9;
	Tue, 30 Jun 2026 10:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782815639;
	bh=Gsl3tPUdzUJBW9EALbXP0CQ+gdTQn4E8pzPSD9/4upk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F+zXCaY5S4Ob1UllqUKHQ5eO6fIGVBOcOHk/A04DaLnNWPdqoUSiVZFTVE9Tuu+58
	 6zefI/15iK7W5WQGDL3b9kYNcVOo6bFhmLAyr5ouDGjwPzJ3zPD0YoT3/nEGAIm5Vx
	 6hbOC9zXmnWXjzrIU7FaU3hNeF220G3NPy8QovDFU9loPN3El6UiUf2pd098bM6DFG
	 nlVN6m65S0okuyJtB0/b86tDd/9k2vTkbhsWnVGYsVckvuev7fnfpPdakop9K+Gi4j
	 cpjsrnNH5lVmf/H/5LLrH5eDgT0AhmVlLlMrnVAoLk+Pv2lkeYSmzwiM7dohq0LBVc
	 FHJt8/HE/HrjQ==
Message-ID: <c07c7a6b-da47-4d05-b501-d338e944d861@kernel.org>
Date: Tue, 30 Jun 2026 12:33:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm: fix ternary operator precedence in
 ksm_tests
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Miaohe Lin <linmiaohe@huawei.com>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1782811071.git.sayalip@linux.ibm.com>
 <bea784beacee411394c332272df9e68148caf7f3.1782811071.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <bea784beacee411394c332272df9e68148caf7f3.1782811071.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89542C0003
X-Stat-Signature: fw1qkkhge18384srcdpumwu5rpdejkjm
X-HE-Tag: 1782815640-924978
X-HE-Meta: U2FsdGVkX1+iIbnxSAl+airTDtPi83ttq5LTX/0c9CXQqUwj2g0/e/Vabwk2hdt+V4hyRe83kRU+xnLn+w6HHDELSz8GQ6JmtffKd4wg+lZAfzLwiPkV3W9RYBporKoq7lF6GHH8d+KbxPGx8jFjc/w/VQUKfqMq6yGPU203+AVA+Q5aIjqlpMHDCCeBdiNCAI6bU/75PIoncQePOHuMpBH8eMUethzwn7t1vIyc1MMNPj756Xx6XvN/KYo9xM1IZ//shljl+SupcKX5BESuNSckToIr3g6GOe6ozHAH1yiIorfcoOmRhGZxXWdJRS4RwFl+FOQqXpP+KXi7vEF7kXC73askMWVqmfTccGU9fgoW5T/A5BAckF19iwBDxvB9HKkhQ5sd11EN+au413tSCliw8ZQLu327JQYpFsB6MzxCEm47VIJb2DPCZjvgUsooKJpvkpbYHHKRLiOUiRwWZlmX0hp4j+1T+IcYVKldYlzuoz00a5AlhLtsJhwyPfTnQhtK+RU7H3WbqFYaH0Z5g5OgBlaRglYjpVR+eLW8MqSmK6uUF8AWlgVdnXpbZ5oS01IOjvSRHtKOb1k81k/v9aNxDmPBFd4RNcNjk7S1Qtjf0/DhqUtw55PJFfz56fGMMU3QvuPer727ISYbZvxD/Jk11+Buga4pbfijZlupIl+w741VeOxnPG1j+h7Bl2mnIKHlEeiNjnST0xoGQdN5CSRLiJc9qxbjD8kdrNrXCQJEnHQl4zRvb795LuRvAizDtkhvwkWQGHqoS86VWaTjPs6mocloB0b3zDkwngGkUGLb4L3hwRDh16NjE5nHRkOkueMK9MbZUVYMDA8IHYMXALsEPos8Zy5W2rqNRRroVaIljTZd2ijhmzRbGNQl39Z3vg7hn3YIU6uf45qbeDm9WDLfkD2Tl09UB2ZeX0t2bWONX/9BwgALaYryznc5ep6ahPPtMuYHnPyQ6LVOgqE
 29ck74xF
 rEINzzbPwJbOXLERxYZuP46agMUwjcL+zwSfyyMG/WC4l2zqDZhSE1FVZWc+gkmS8tfK9WqAd9AS0Sb8hr+D+PYN1rEQCnFQkGN9+Z0FAWDf8tHS4JcHc/H4iONMwXqRKEG4juWiNDeXcQgur0Mc5VI4re7rrBfiKej2Jlqfybqyp3MM2or3xtHYZn/LEiy2OMzp6KfIxzwL/42IYFOi+wFJELeF7skEe3WkgJf8fftYMHFn5HE0PoqN0FU0Ty8fcfCxXPJHN7/m27E/NUbQ8Fd3UVhtqupa+nWmnirfvCO7FBLp6/yLEN7yW37RHyE0oBjlsLDqZcAGigsyo6+MaJBKNoMchzQfD5h6cObN8yiq98ASbopD1shyi3QkdFM6PEhBmx+ttelUtfhCI3Dj+9AiBQWFj2j1FJZlLBSZPrulixLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 11:32, Sayali Patil wrote:
> The KSM selftest uses conditional expressions to skip accesses to
> merge_across_nodes on systems without NUMA support. However, the
> ternary operator is combined with logical OR without parentheses:
> 
> a || numa_available() ? 0 : b || c
> 
> Due to operator precedence rules, this is parsed as:
> 
> (a || numa_available()) ? 0 : (b || c)
> 
> instead of the intended:
> 
> a || (numa_available() ? 0 : b) || c
> 
> Add parentheses around the conditional expressions to ensure the
> correct evaluation order.
> 
> Fixes: 9aa1af954db0 ("selftests: vm: check numa_available() before operating "merge_across_nodes" in ksm_tests")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---

LGTM, although the code is a bit ugly (already before your changes).

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

