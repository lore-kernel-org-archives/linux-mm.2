Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613A2606A327
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NQywSJLG
Received: by kanga.kvack.org (Postfix)
	id 7D8086B0161; Tue, 20 Oct 2026 09:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788C16B0162; Tue, 20 Oct 2026 09:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677A36B0163; Tue, 20 Oct 2026 09:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0AF6B0161
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:07:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C770080184
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:07:31 +0000 (UTC)
X-FDA: 85343031102.26.2182D8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 06D9FA0007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:07:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQywSJLG;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792501650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FviSrc6B8vBLUnpcsmbMd3IYKvKwW6SGuuJu+3akv8=;
	b=X632q4/U4v3mI5/MUWAwdNnggkOdCYAwSIeFHqfhun2ODkyhFZDuMKK07NEcqYtyNnfECB
	mJZqJDw/OYTHMfu9+N6FrxAfumURhZEzY1yrLqDDpPMyMpdo7rbgItZEOd7GeQTbVPgrSK
	WfaWW1b/NICfCUipuMcHBnStqoAOBQU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQywSJLG;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792501650;
	b=cRH5AUFbfUxQx3EeLte3OclJ1MP5jwmX9EQe4KVUzPhobw1ng6ZDLq9aV6PqRzlA92BECC
	tYAyErac1ZlVFxwAexOafqA+YQrHtgXxHq06LpZZOj6tB9+4Fw4ViBG+E5I0AOSQ9iG+t6
	jsDlrceoeE4zRPjuAj3i3mP4RNYgKpc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A06C60D7E;
	Tue, 20 Oct 2026 13:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3C11F000CA;
	Tue, 20 Oct 2026 13:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792501649;
	bh=1FviSrc6B8vBLUnpcsmbMd3IYKvKwW6SGuuJu+3akv8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NQywSJLG93kGO78eU3Q3Xg4JxVUYRuI5M/N0LJ0toaNH6jIQUP/jy5ijJSDoDtmp9
	 JcVpY79wvK41PQmbzVBd7/zKGFJp1PYfu10ch67DsDDWPO3quOYlm7QlQRih5HtyLC
	 5N5nqQz9Of05WxCvsIEFXnD6ixHhTRpsQwyf/6ntwryLcJ6Tzo7+BsynRMsu8aVqRP
	 42SSPM2FYQxM1obALTH1EYEg0ivd0FanZEqx9APLSa6jUIAji80WfVQl0m79y3l+MH
	 JwLg8KmfotgNA18XAJv6kRf38P6kq5K5xPByjvwpg4iPslmDZPv6MbtC6cANi/4UZX
	 qrG7rA2rjWFGA==
Message-ID: <bc1b3255-99f7-49c8-bb52-bada6df80f72@kernel.org>
Date: Tue, 20 Oct 2026 15:07:24 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned
 pages
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
 <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
 <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
 <20260929034123.2705745-1-xiangzao@linux.alibaba.com>
 <877bjowf9i.fsf@DESKTOP-5N7EMDA>
 <fbd5ae06-b6da-48f6-9c46-188fb6ba9684@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fbd5ae06-b6da-48f6-9c46-188fb6ba9684@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06D9FA0007
X-Stat-Signature: 77ewfme67t6okg3n4suq5pmsmy7uprtd
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792501649-644425
X-HE-Meta: U2FsdGVkX1+ApNJTznSywk/rQOtPWyrJE3wrYeWcFWCO6Rh+1QmWiKNlQSRGldr8DScCs3IeHEbsgeuuIUJer/pqbLNwxiUmTRZlzzMXRy6Ekk9FrOfPH3UKCBVsFPjyNR6lxP+9gw9GRwOFi6JrxOsH1AdQQ0bJtWHYebktqFR+VQvXCojs8c8AA9cJP7DWaQt5VMbir0+eM7tIB4FGeP95obxPkTKVtokl9sjYgC4kb8F44nzxOPliOPnkoIjmOYtHm8So7Am/6Lnn8DiOMJbCvx6kKaM/Z3iM8iSfUVHT9dPRRHy2z303Ls4aWR3cnp+QRF52tXfFxKwM3bZBlu3zvrjBD9SrqD3OSUEt+FrW5e2CwQ3GrJMNI2tsN4IczERcIwGqJmEsfxlT1UKzrYuCsTUSUd2YwIvUJ0pQwqEu3YhNReSuXGWj8TFwcTESvAwYAvPlGF3yqbp+eP+0Vl+SAR2V8rxC4vkUWvtIgH8k/I+kI5GnG5M78mymWJHRgSwbJzdbAp7NVM9EgsJFgmW38nzRdFTZ4OL6csqLzIv/X/izsxrYgIGFJMWPJscP17bk5PiJeitrjZQ05Bz+k43pmRhrNAEzX2GVffChSJ6NLKn0OAZY8cSw2BDk6kvubiisa+Cvo+G4D/1tejXvli8xJ7lJgK9Zz7DEhdUTqUJUog1MllYjpc4id9VWgyxASv72St1iaEdLlYaMh/1wM9ahwqF/6fJOrdRX6JpigJPL856ko0s/JMxscSEgVS6mhb17mytbCfstso68lo4pCtazIRq50lU3neWb+PXEAONyBeVkj/pge5nNW/UcDSB6l72eZTt1wBIsyL3c/tvNP14pRI6QmxeIV4amOWap8L1z40lYY2J9oYuE8OOBKm6KDJhOuBK6Q8N+oTKqIfBDn/Aas16TptSPHFl3Um+NKb9vNFdDcBPZUJP01o1JHWho9LZ6HmVlvgRPmdyd4ti
 QkJjikI6
 Olls1Mq1j7cxIn/68SXLKZaC20u29CUXEpOc/S5DDc188Cfy4kdTFL2MQZUnsMQa80sk66QrDWcpM/29lCc6AL6I2q4hnEQ5hGjjF2Q4LrE1CC6GLM8YjktnGeaHe7TNlVkpaC/3kpeIqcaekNShwIIJcORI0HlDlAXk7FHDl1Es5AmvYdAHOqLE3ol7czmivBjOTvdfDd8CVqKGuTgmMOIcKvu/N843FIB2asK5L7r1meqA67msU97UQlH/UbWtR/lok/AcObVc+2Wq8rW9/VlsB76HiL2agCkFZ+VZqmCUa0vZKGa5RTR2KkGVv2Li7KQucPgVQ4QThVWNsl8HefH/H0nTkdEhO1AqqOiPI1Z8bbQr0cCyri83kMuPK702xByek
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 13:27, Kaitao Cheng wrote:
> 
> 
> 在 2026/10/11 21:14, Huang, Ying 写道:
>> Yuanhe Shu <xiangzao@linux.alibaba.com> writes:
>>
>>>
>>> Agreed, and nothing here replaces copy_mc.  Two things the check adds
>>> while that work is pending: on archs without copy_mc the plain copy
>>> does not fail, it consumes the poison - the same poison consumption
>>> commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting
>>> THP") refused to risk on the split path, at your suggestion; and the
>>> refusal happens before the copy is attempted at all, while copy_mc
>>> recovers only during the read.  The check and copy_mc compose.
>>>
>>
>> Is it good to implement the trick in copy_mc_user_highpage() and
>> copy_mc_highpage() if the macro copy_mc_to_kernel is undefined?
> 
> On architectures with hardware error correction and exception recovery
> support, accessing faulty memory automatically triggers an exception,
> which itself guarantees atomicity.
> 
> On architectures without such support, even if we implement this logic
> in copy_mc_user_highpage() and copy_mc_highpage(), checking the hwpoison
> flag and copying the data remain two separate operations. They cannot
> be performed atomically, so there is still a race window between them,
> however small.

Yes. And you need proper architecture support to fix it?

> 
> Moving the hwpoison check after the copy might address this issue.
> Is there anything wrong with my understanding?

Will architectures that are not prepared for copy_mc_user_highpage() not simply
crash if they trigger an MCE during an access?

-- 
Cheers,

David

