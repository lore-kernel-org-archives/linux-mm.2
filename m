Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23886D1A627
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887446B0089; Fri,  9 Jan 2026 08:41:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835046B008A; Fri,  9 Jan 2026 08:41:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7377F6B008C; Fri,  9 Jan 2026 08:41:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 60CE46B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:41:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11E521AC8CA
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:41:59 +0000 (UTC)
X-FDA: 84312538758.25.C325838
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 323CA140002
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:41:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mCmf/qFA";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767966117; a=rsa-sha256;
	cv=none;
	b=FKAKSw5UKkp1XUs7Q/wI9G+Py2/KIYAa00HnVw8PZwEc2wzjawAz6poDG7v0vBaRryhUmp
	0CO39KhupA1o5vR7agwOoN1GSlhqI6upn4ckWRcRzw23CtPGlZ99zn/uHJxyerPSopkWlc
	UXJTl927SMN33Xlk/VUZXG0c6zbfuys=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mCmf/qFA";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767966117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXHIwmnL5409tJBaiYRklVMiFgqGfnFpWNAtJQKYBig=;
	b=pziBXRKj++ThVKntjfyegPTDTDgpHgywie6Z4S/DffSmNN6IlczbsXup4OvRryA+C2OWAn
	YYTOvJf6T2pIdpQrit3eL5n5vV8+sKdcceqbsyu2QB2MvYAHisAMqXBaMpycwpOxgO3rUq
	5+86y0NaF4V54tfrlfkcrgVlH2IEwVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EEA6439DD;
	Fri,  9 Jan 2026 13:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127F9C4CEF1;
	Fri,  9 Jan 2026 13:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767966116;
	bh=85W2k/vZ6p+6iy0+yFWg6C8malR33X2ekz9QgywhdHg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mCmf/qFAVz66FGjo+1VfRjKDgm9C2YWUh/58ThjZTg1c3qbTdFenCDdpXC5sul1xA
	 NEinrrPqz1ENk859Qij7ccldBetl/K8nhPAZsHEI/WGyU17lEsKkQE3zj2J+gLMfwF
	 Sjx1xESmbA9GzXyMj1Lfi/BjDSbn+P8bHM/5S4ETldvoBCPT9Wj23mwBe5hoj2wwY+
	 oK2l8L3c9w78ggaUMnaxi18GaJAgToAzNL1Uc0Vin/Kif3762G/gwAh3MhdZAhLX1T
	 jv83fvYBoYK9v3r0KqOR+CdrHj2mmE34RZvYEfa3JqDPL7lRXm1uasdfX7/glbDzuf
	 r+Z1asmNqwGrQ==
Message-ID: <3cd08409-8c6b-42ab-97d5-e4440efe4f6a@kernel.org>
Date: Fri, 9 Jan 2026 14:41:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: run_vmtests.sh: fix relative path handling
To: sun jian <sun.jian.kdev@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260108031604.12379-1-sun.jian.kdev@gmail.com>
 <20260108132851.bb6b7813277a5b40ba3aec8f@linux-foundation.org>
 <CABFUUZGinC04zPEtwq3+maN-iNVNdc1p_BFnTdPNTsLXcQ1hnA@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <CABFUUZGinC04zPEtwq3+maN-iNVNdc1p_BFnTdPNTsLXcQ1hnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 323CA140002
X-Stat-Signature: xut4k75kb6gtcquhk59c3ifpxo4hqj86
X-Rspam-User: 
X-HE-Tag: 1767966116-524798
X-HE-Meta: U2FsdGVkX1+ls1WioWu7N6lbnN7BIuPcG0xPaFm9BE/iGdRTRJKjS9SVFeZq3MmlciYHhe2Ig5PFNB07QjqcGy5HPSsk50HeWk2SQudWnq5Q5WmDx8dmw0FJEPklXEnAonqI+41gavhd5bayNpXzANVQ8TpZEKl7qa1xB3rfHfeRwyUOzUdx+4+5zIwRQE1dc+vru2biNAIrfAOBSv5qkY9SiSOkjj30Qu9hr2IF0TcE1ct+ev2OvWgcGYI+eerN5Dk6nhGwLYwxcxxH36sJmjNR720gG/FAO03q+wKB4DC4/S86TVgCQyDC9XCPHb6azI68w1R7LlOBTmlq3W5mkw6rIUkW350ndYisAVkX6j6mCIneM8XfbMLAk/hX9j252p3oWahAe4bJhtzpKW8g4Khvpk0hxsQqSLL4Tkx62PM5FkD4m1TmFiHrzhdN+/TXfaKx/UGiyN4cF7G6JBNTntVfPKKbEZrSJ5EensxQx7DuiNWLPlSNr+aqldTvdPHPHDQn7UN7vaeZe3/U7/Coz9D1leVvt68VqUxo0YodBtwowgXmDAOp3uY6Q04/RS0LazjitsMY7Z/nFaTDCDQep87u+/eR7+PfSeY/oBhSr+oFTKmjF7hIWWgXIWmD/51KJOfAPk/ktRsHVt+HYb5d4lMl4+GYVF2VmwqQM4bKN0ot1jTE11yyMxG95E3gFSmrzPL8mW0bplxnYbygcvz20XRhu2LnpC30TjCa8o2RPckuGhmY3NGdL+mG74kuPsaKZuiTiP3n9mrNvy8C4ePWAM+NlAPb8TUICQDsxvmRixFmqMnmnrV3snssP7WAmJd2nF+Xq7QdTPjTqxCLSgCmwIZ+e2799kmtACUFEKgnabWIVhkfTo41D7ymW2IXhmKlGzpRqN/YWheaVmrk+RiFqjwOBQrbkxifFiuhs6ym/pUq2d1IrODlqUCo1O9DcF24nVbUj2Gwek1uLIo2SDW
 dzbZvIqN
 S0hIdEJC10S3kHjRo8pLMIjpprknGP1m9F54ybfyrYOtsQKhvgs+CJN1C0OY3LSV3BttUdKRgMH8aeJL7OJpaj+wif+yVx8lbR+5u2pIlfw8CJMs8KwcHijIA2rYsdzCvypNkoxhNHiwgmrSNiES/qjy/tOsPyrUMumJzJibRBU6Ja5XS/dnG+WAi7gHoPsTvNP0i9y7qH2BbuCTc0I/Acmy0L/EswwiNr79DRYkK2B/GVPzYiNgUWobKw6BtYkCn4eDrnb6kB6/M2vjOc4TwCl+4pNyxjFTdZmRUqEm5O2oMwZCB/42tdCA3K+aaTDswT9ziRNQxib3A66mRbdYdQBffoAZ6M4gggi3PZJeEKJdT7p5Hpqyscg12/qFdTHoPXU4OtIKDplL6izA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 03:08, sun jian wrote:
>> hm, why?  Is that a thing people actually do?
>>
>> Is anyone going to actually test this feature?
> 
> Yes — invoking selftests directly from the kernel root can easily happen in
> practice, for example::
> 
>    sudo tools/testing/selftests/mm/run_vmtests.sh
> 
> This currently results in false failures because relative paths being resolved
> against the caller's cwd instead of the script directory.
>>
>> Alternatively we could check that we're in the correct directory and
>> error out if not.
> 
> That would also be reasonable, but I slightly prefer auto-cd because it
> avoids an easy invocation pitfall and makes the runner more robust for
> wrappers/CI
> where the cwd is  not stable. That said, I'm happy to switch to a fail-fast cwd
> check if you prefer the behavior.

I'd prefer to just fail for the case that we never supported instead of 
adding support for it.

-- 
Cheers

David

