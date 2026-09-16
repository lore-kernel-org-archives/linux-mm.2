Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29422C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D206B0092; Wed, 16 Sep 2026 02:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE276B0093; Wed, 16 Sep 2026 02:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEEA46B0095; Wed, 16 Sep 2026 02:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8EFD6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:37:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E6644060F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:37:17 +0000 (UTC)
X-FDA: 85218668514.25.6C3E567
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6DE13180002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:37:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RRt88J9D;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789540635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2mhIr1a5o49IQFktJzDC8TUUucKqhAIPilE+SQ4C7wE=;
	b=L4lXeYaY1+xyGoFjqvspXwn2gX04iyNLub2KKEm8ugpTDh4B/0PjlJDgf3q+YqucFDm6Hn
	0df/M6gSw1b7MnKygA9bz53dzXSU41dGVzyELWP51MmQQvCtj63vg7nuWorqoYycM7FrXu
	5SlQKXw5HIM1r3lvAD1Xbf7k+JwBUfg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789540635;
	b=aLJNOK1haL3iYfiyoFHFbciJB6ci6Xq/2HeNTfbbf6kt7nglFEh+ZOTrxXHwF2hzNzHxxx
	7adVS98sBvkxDJhrCURSkFntMFWMA+3+R0iWOV96Z/840LAsSc2bpBHpWe68Nx37ZEVJ0T
	O8xdwT/MQJyf2esIlFAyXgW8u70NnQc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RRt88J9D;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CBF960008;
	Wed, 16 Sep 2026 06:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AD51F000FF;
	Wed, 16 Sep 2026 06:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789540633;
	bh=2mhIr1a5o49IQFktJzDC8TUUucKqhAIPilE+SQ4C7wE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RRt88J9DmanaTCYmIeioy7qKoeGnTjl9AMkGELq2T4pH+GfA72gsbE9WEq+qvtSQb
	 6kwBnjIxWXd5bUZ27qfGgvXpPJRc5y5L9jHfdxlCTI4Fensk3Da11x5gkQrtvkUmks
	 7+KtesJFqfnJVKXyKcJWEFycLgrTec23LCvhfh2q1P7RvfgD3ipkEPuDVguWl8TSBM
	 pv+m4exVrr5/nFZ3W8U8Y/OPJdVxcxLvhXAwaJaIpqTv5tqOtqy2fH1bZNYlc51bJ1
	 mb8u84DGZuTtlpuph8ptRSv/OQvXj2jssWC9XIzxZxmW/XfTiyZUIJIr+Y3tX1Y3qg
	 kY7cEWviwvmyw==
Message-ID: <d490e314-b92f-4120-93fc-ae36f487b135@kernel.org>
Date: Wed, 16 Sep 2026 08:37:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] mm/ksm: merge-path cleanups and folio conversion
To: Longlong Xia <xialonglong2025@163.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-kernel@vger.kernel.org
References: <20260915222545.5683-1-xialonglong2025@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260915222545.5683-1-xialonglong2025@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hxp96rhd4f8obk59hstuuuhs78k46syt
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DE13180002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789540635-596555
X-HE-Meta: U2FsdGVkX1+ODI1R0gfQeTRAYkW/A5Zr3oUUNx1zpY9Yz2D7C3cJjty8974f/HhdlwBZUK0Q6cfDwlIZ/LVh6il2n7IxBZ3kxwhUqSMxo1KOvdilazB8r8DJw43N/RguMTMycSuSZqETXBGMlqwNYTF0FgOq9h+0rqjEq8airKcxXh9SFwDGRCGOn6PjjzBu8EaPB1Mlk7WFXqa3KqI1gSa2pvmLfXlGZBR3JHDNA0fp02IY5mRrtSznFci88XYKX3+kPiW251r6/qb2xtjwd/TENzb4PTLunisuxxNAF7pKU0zUPqQrUpvr8br90vfuNh01AuvHofEhm2xOw61s7olxXu+i/pfNnA7VaOCbZin+1oQgQ+/3ePak6UJdecFTLLUQivHpcpFXkf1fdD58BqIWCG7B0FrskGSH1EvfoEtXNV0VXcYTQ6LoXWabFHrUJ8kcGqqE/QsxkPBkJ9yK3CgVHLYrRoL7dQ3sH4nZUZQ7BbxbeapAj6+7Z2ZgQW/u2o8X4xAICJZewWMuJRxoKUfUujd/YrNZeyFIQhKwCJyTxysZa1XPWeciS/rAWNn4EpYGKX/N5FV2j52Kp4BxtTIkd0YeQk/Akw3EvNg3Qj8GIJpSut+NgbMOfyko41mdUUAA37kRkd1Gr/zgNS+8U7eSpd7gY2rJIAy9iilQDf/4nYGRlR+AwIHKLNDwLsYghuSNAD1zfP6peH+u6W7GEhwljNCzJWkrlbvGP7VSbdDAWgfN+vYOGWPDmPSoM/wchWawzbtHzTlzZuAk3f3IZzWNUaYXqT3Iw5dQHFiL15+IEFSHqaMG7R+wDIIThjlp7ub7xzHmQ+3HyxWQ3mcKKGossqXAez45gNJc/v3/hBIDyoRxAgGeUhxrsjHGGuO0Y/IK+sbMpJRCZDFpxrn1HTvmR4jYdj+4sLbbxoXQvmEkE83D6vlkKhOOvsgg4roJawJx+ZCUZ2mndPTDWkh
 RCmJH6zb
 YIp71fWpZ6mieKV1/OMcaLBC98Z8WIlgmhOKrqZc6GBq82scNL3ABE+d0sRPCh/c7rT4aqlFANEafKxyfmhZKOzhvp1Xv5YzDDMk+K4tRwn4bp7d5A1k1rqBaFt6PqoFJ9pg+3R4m69o3YOStR20bGqjF/qXMI3B/TVBo9Q93uLrXfMHcivHaANoFVyr37cVAyEspmPv0DinrwbLyFM5CCJiv5luv+ZU2Okif5NRB8JGl/1/LZpSMnOT0IZ6XMkdew2Df
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 00:25, Longlong Xia wrote:
> Thanks for the review. You are right that I did not justify the
> page/folio boundary clearly enough.
> 
> Patches 11-13 only avoid converting the target page back to a folio and
> provide no functional or performance benefit by themselves.
> 
> I will separate the independent cleanups and drop or rework 11-13 after
> getting guidance from the KSM maintainers. I also found a NULL/bisectability
> issue in v1 patch 12, which I will fix before any follow-up.

In general: once we have a ksm folio (folio_test_ksm()), it can only be a small
folio and we can operate on the folio only.

Until that point, we really need the page, because we might be dealing with a
page in a large folio. Sure, we can carry a folio+page pair to reduce repeated
folio lookups, but be aware that we have to re-lookup the folio and take care of
references whenever we call into something that could end up splitting the
folio. So we have to be a bit careful around that.

-- 
Cheers,

David

