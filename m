Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3D8F606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 05:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dpfgAeT6
Received: by kanga.kvack.org (Postfix)
	id A20C86B00EF; Mon,  2 Nov 2026 00:16:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1BE6B05B1; Mon,  2 Nov 2026 00:16:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7D56B05B2; Mon,  2 Nov 2026 00:16:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66FA16B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 00:16:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD14D1A0AD0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:16:47 +0000 (UTC)
X-FDA: 85389019254.18.F351679
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 05CB3140002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:16:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dpfgAeT6;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793596606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AydlHuw6fO2zY4cI253Suc41cz8zgm/O+LvMgOdMh6A=;
	b=rKfa1Fz3JmgvLInOMrt5Nn0cZ7kIScvHW5pV1CuVb89+o5g39Da16HlQw/stPzgsXE4ptR
	2JsTBy2QYh339Ev6QXFijuZT0lVqZCOf5jww2OJzdRKU7tbBPTGNDw6arAhCFLAo2NJqD5
	3hm2wi1+Nzw7ApINiIOMUWZY8uOaGD4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dpfgAeT6;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793596606;
	b=eyiXLYgxwGpeDxzggkOr7pfgbUuvRntunKC7980GcJPXg1GR3IHqThMYySmAX49veS97H4
	nwlOs7br1ruCYtCpnfahTzr0NeiUSNBtt+POl+Seo1prmUuxh4EA2a2fKJQQXOQVnRQx6D
	cbsnQop9TnqFKdYC1mMyCwub/QOGo5k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D6D1F40B13;
	Mon,  2 Nov 2026 05:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B2E1F00919;
	Mon,  2 Nov 2026 05:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793596604;
	bh=AydlHuw6fO2zY4cI253Suc41cz8zgm/O+LvMgOdMh6A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dpfgAeT6XwqEya62aQgDtukLCRoDokJX4+yTA6W3r5srSYYW8lNaavZshZYU9jVQq
	 9LT7W1GdOdDeW7O1/cw332G0uaw3C04X6wClEB0mF6r6Ur1Jkp1WnFAKiTyaj+Gx1M
	 /JlI0wlKndGMZQlDOONwI1O62P1BQofWB/wpHQFU=
Date: Sun, 1 Nov 2026 21:16:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Weilin Tong <tongweilin@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand
 <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tools/mm/thpmaps: fix missing mapping names
Message-Id: <20261101211644.c63a2028bbede0f763f41f80@linux-foundation.org>
In-Reply-To: <20261027074904.3328878-4-tongweilin@linux.alibaba.com>
References: <20261027074904.3328878-1-tongweilin@linux.alibaba.com>
	<20261027074904.3328878-4-tongweilin@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 05CB3140002
X-Stat-Signature: xkxzxymeh9qmq747c14583doxkqxqwmb
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793596605-918167
X-HE-Meta: U2FsdGVkX18ltk1gI2qswsnLS5BvSaeUwMOQY94MJJwE8ETFUTBPjohjlTKsgi7SmLezPK3SNNjqlE6Bs6x5t3fIIBI9uKMec6cLLr5PhOA+JIOzc/qkYfYJMYiA9I0nhHxzMif/Z4w4Fc1GqEQ5c9/STJW0A4BFOPAkjw+BFGFVhHpNLPstnX23E7jIOO2Vc7rZDVPk2Iq+euJhuVKjR4z4TXECVMcmOHKh1Fzu9UafEctaOoANckWe7tlrGrOWupPkXEZDj8cGosdCu5LmVYGIE06lYgQIsqVMnBWaEjwTtZWXr/mJNLmlzZpoxn4zNCOtcFGbd2MgzODG6GHP+NHqbQ3p6g3ZZuIsPPE7LG37mU6n9IhaHgL16VDpsbzbQhuN86NAh72gTmtTd0Yi557DPnfpP1W4zVPZ99FqNWiYEJCYt7hQJwa91oipvnawSVOk83FFLJeS+ZOrDuFK3Qm025FgJxBRe7QBomvQR3v4qBFmJHHub1bqKPUbGb6+8uh2q/w2UNywERgxfZuqkQKgLv/eL5KcKRPrioZ4dIerugx7Y9cm2y6lUeymskkF5NGjFRtaeMhSoMow5EvXoAUP2KqAbAJzM6Xns+cBEX8pO+v0IPGF2Q8gM7Nj25sWX0qrEAsBb8JyCKDOeHvew06PTSy0lZlf0crfTeWe130ZGSXEkMA6JrxNRvZocpXAISG0LiiZRfaGEzlshrQD99G9Fx8zec+Rc5Cx5EgcRDCzs+lgh29c76XjSLpkujfn1nMwmhpGemM3y0iWQcMGmG1h+/6pvhUlwgFKOCJTY71qiN7PAfzSqc6Ywwd6U7ws+G1icKwujDY01K47zl4nFKr0O4K6Xqrrs8CPAP6QvaaaynkZ4rj/PIaTpPfFw1vSPiJfnS4z+G1e57RTOuCu41RaezbH2VB5kFomTonInXsPCunNhPDvnkUZzFhAodmIuLBORn1xQpwPV/+QUld
 EY2IxVK7
 PW4nvWk8p37pGeLpa5w1ZzqML2uEBgLkIV97sdZC+9cnv4M8yFDADtvNMDzb3ydGsa1i0aYdnp+rOPiPqueP2oF50j0flnm93rHHiJQ1bgJQVkTYqLKXG0UqiZSBiWZG/q2Rk3eFtiNVheL0eExo8x/+9QHvlxrdlXYyDM2Ha1sWSlQbRLMl3p6ZpQiq2NMJjDYxDbRk4N+fWIQX7TpeOc/uQJXaeVkTEASZ0GkWP4cUxmVXKn1JiKEqv5vfxJnctuaAz+KmTOBvp17o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 15:49:04 +0800 Weilin Tong <tongweilin@linux.alibaba.com> wrote:

> VMAList splits smaps lines on whitespace and only keeps the mapping
> name when there are exactly six fields. Names containing whitespace,
> including paths with a (deleted) suffix, are therefore lost.
> 
> Limit splitting to the five fixed fields and preserve the remaining
> name.
> 
> ...
>
> --- a/tools/mm/thpmaps
> +++ b/tools/mm/thpmaps
> @@ -198,7 +198,7 @@ class VMAList:
>          self.vmas = []
>          with open(f'/proc/{pid}/smaps', 'r') as file:
>              for line in file:
> -                elements = line.split()
> +                elements = line.rstrip('\n').split(maxsplit=5)
>                  if '-' in elements[0]:
>                      start, end = map(lambda x: int(x, 16), elements[0].split('-'))
>                      major, minor = map(lambda x: int(x, 16), elements[3].split(':'))

Thanks.  My pedantic reviewbot points out

: Could we also handle carriage returns and non-UTF-8 bytes in filenames?
: Both are valid filename contents.  Python's universal newline handling
: splits the former into separate records, while strict decoding raises
: UnicodeDecodeError for the latter.
: 
: I reproduced both failures with real file mappings, before and after
: this series. Opening smaps this way fixes the tested cases:
: 
:     with open(f'/proc/{pid}/smaps', 'r', newline='\n',
:               errors='surrogateescape') as file:
: 
: These are pre-existing problems, not regressions introduced here.
: They could be included in [3/3] or handled in a follow-up.

and yup, these patterns could indeed be encountered.

But let me grab the series as-is, on the grounds it's much better than
before - spaces in filenames are common whereas \r's and non-UTF8 are
not.


