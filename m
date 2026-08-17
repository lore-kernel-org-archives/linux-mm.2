Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E942C5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1926B00A1; Mon, 17 Aug 2026 05:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7996B6B00AC; Mon, 17 Aug 2026 05:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0046B00AD; Mon, 17 Aug 2026 05:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4716B00A1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:35:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E17BA0730
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:35:56 +0000 (UTC)
X-FDA: 85110254712.04.256F800
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 46F6C18000B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:35:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fB7VdzDf;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786959354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bz/3Lps0oDNCceiyOyN1iEoGSjh9V2X4gBWJL4YBiBY=;
	b=cIVF5sKrGgw7/xM+x2C6NNa0mFY70jSePwNEjZ4My95qDcAWLkcOYsHpM3Hqv3Ff/3NZe9
	vf5bd/K+2CXsMgBZnw2nq6dVvDyZs2yXeVNKgokqICmVTtrAgf2CqHlvvDAfIVyxsCpjde
	LBHyt1Xq4lAcQBjPpVyFS/9njHmT0sk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fB7VdzDf;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786959354;
	b=2svieoI+y08xRT+xb8wlaNYXNqHizwFN57zb9dTeQ8wJYirS2pmNQOoKRqjGwOrdAkI/zc
	Xb1WTKTbyDsmY8InLDxvlZpNsMz5/loC5prXU3fLhSoIoPkp/QpUSGB4/ppFkOVkQ00GOm
	SIH5iafztU6V+y1UkVHcdHHxAKMspYc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AB1342E56;
	Mon, 17 Aug 2026 09:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136931F00A3A;
	Mon, 17 Aug 2026 09:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786959353;
	bh=Bz/3Lps0oDNCceiyOyN1iEoGSjh9V2X4gBWJL4YBiBY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fB7VdzDfxUFWNJOJBtj0zSB+fzkrs4gDhweAih4gNcXBDzfc7LRpEhSD/71WcOwpu
	 lAVZvpEC18aHG2GkrzHQFWIg3AwiBYQXX0daMk3rJm9ZsB3Z2exyxY7EIPKAWS7Ey+
	 vPJOGzRrrwSQf+j79XHJzn+JqHcObtDns+9h4X5GTQU//plvjBAoKo5nv57WZNh7kM
	 XZqr9EMsUzqaqkcz+oeXuXtOqb+LTWeFUISaaiIJtzUKE9dv3SbSCk4rzCUlssPVsE
	 8zsN+JxXi/yshc+vKj8MgVhjfOwqtm9K0J/QAX9EwEx+dE224+h8BbrMbbq60xp6YQ
	 G6/bqfoIF5jqw==
Message-ID: <5abb555c-db95-4340-b27d-eeca2d8e68eb@kernel.org>
Date: Mon, 17 Aug 2026 11:35:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: khugepaged: consolidate error exits via
 kselftest helpers
To: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
References: <20260817061955.45454-1-hongfu.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260817061955.45454-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46F6C18000B
X-Stat-Signature: oby6iy65pqzunwa8odutjexibizqfxm8
X-Rspam-User: 
X-HE-Tag: 1786959354-45492
X-HE-Meta: U2FsdGVkX19p37tdpeZ2jS9n/hjZJftpv8c236WG1YxxHJwddjCLYup1SnKLhqFzCbcJ7WJHdPkRvtdYTwyWa5+uW2DisLaBZljRpi/l9BArKy9hcF+Zx+yBoCEhYvNrg/0G9MSPoZt3OgN7t8bM9slZoLvSSwcJ9pzCDhXZrKfkoLzsl6fu6/mFHSpTaPLwH6vFdyqGXC6onKCDAHPzqR+AmHdpMLOD3zug/zgZQn41Vo9/9AiSmSRDHK/6Ev3T+gDGnXsF8xruR4+2rj2dhhve+SvZh7xd/QQnxxZ4Y+MGfXZ43/AkvcuD3vrmK7T6w3k7kujONc/K+9K7/m560P2owfvqSGKb1QLGQeMmu3VjF83D5qcOa6HZInGqnpAKRJ6sNp85+KEhII+k/yCIA/B6nFmsAo3AXq7XY2flq28pZ6wlxkIUuLDkAJ7g0B/iq2JqWnljFuGOEBOYepdX6BSIsmXR0RkHGkPyp1QNyyfNBCPTNOI/f9HDFmwEDlKKFOTV8woA/KWYLNbqSasw5QEOQfeCRfIbdgbpr6SEeWxMhUFNuELjzKJR43ld7rYt8J0i+1BLitDD2Pt1i7nt1RTeldrFDdlAGA38Ok+30leYpTHEKScWPLOZBITwwqKK7n5sVoh8gGxYtuL5D50+hazEwBW0vXDaWA1x4s1/1+iIBs9SUef/Q7ZTfzMC76YCZ7BLtXQdJTVfDTbS06/e/5SMshgQstDSzgVjB1gRZwD1qXlm1Z5MNj50T4oQSWHy0b/kGArRitnXoLBfxyFTxQbsCvIPksYk4OwTDU2hhQSl4wDKSAnUpDP8z/uWQyeLtl4S8IEkGFXte3dsUU8zcj/IWthlHrwP26r4gAXMoko9625D/lVOW9sqSd40/ZHDbmfR7UcgrA9lFLXkjBIpCGmya/iNuwWH1jqf9vgoJyXDJlFXx3NUqMSkJXfpVKgb4tNv3aVmVzCG3WWYph2
 G8GNTQGp
 kQT898Y/nyYi5Jb9LlibmppFCWEaUEF7+wXLSkYu2sMT+T7uzSSlPyAlneGShZ8iF7d171g/yRiZtjO0M8j37AvaNPxPyLaEl0aExAAGmRr6sfYQpsJLS+Zz/E9B5mQHjJ7qHYcaB0UTDbemH9WTNo2liiwlcEwk53VZsrPWCrLCTM36kJJFpfhdhcsTtiLsCZ+dcs+w58oM0qEzOP1FSawwlzXy9rM2SSUr+AV1x8NCcpcLN7LzfPxsuqIYzjjamPEbHJfWk8v02j5Czx7tLk7ewdaHNf60gWfN2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 08:19, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Replace the perror()+exit(EXIT_FAILURE) pattern with
> ksft_exit_fail_perror() so failures are reported through the
> kselftest framework, consistent with the rest of the file.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

