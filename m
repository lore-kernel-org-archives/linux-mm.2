Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5627E606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n+vLYLtK
Received: by kanga.kvack.org (Postfix)
	id 7FEB46B05B1; Mon, 26 Oct 2026 19:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B00C6B05D7; Mon, 26 Oct 2026 19:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5C26B05D8; Mon, 26 Oct 2026 19:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1E36B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:24:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6CD4A091C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:24:57 +0000 (UTC)
X-FDA: 85366359834.02.1B27457
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1B39280006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:24:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+vLYLtK;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057096;
	b=gZ3pme3iv0PJvVh2u8dZIEm7XDop413K21mfqoJ4vH2kwN3Rh+0M3mpGV6eaHLJ48fNkL5
	xgYmm6j1PIfKnRfdIXC2g5mZSNJdkPO7iQL6vqiKmrFVdtHg5fDXNeCToAsWRzXf5jxRaD
	XdFVb60SFY/H/Ri4rjmqrxVpnbm03Vg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+vLYLtK;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kd3Dml8l3wq2mpKC3ZlVeUqbWcVHK5sKBx/wLEoqeB0=;
	b=6UERDWCp1V2n7Pb6ZqmUqkqmhvg2iIgiGWUCg8OVSgpJpPxlKLqUHVyMlMlDNFaK/2ksAp
	zN5aOG9TH+w4oowFV2gm6XmcdV5KdeMBP8V9iLuWlxMKC0HXqUzLoXLw/grMRDhP17PWKb
	/xJU+LrRTWCh6JTbuE4tnHgEii4bGCc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 569F643A59;
	Mon, 26 Oct 2026 23:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBCE1F01829;
	Mon, 26 Oct 2026 23:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057095;
	bh=kd3Dml8l3wq2mpKC3ZlVeUqbWcVHK5sKBx/wLEoqeB0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n+vLYLtKcNv22bWBkMUGXCCk9gajovYZy6u8dQ6jFeLyq4kpoCxdJi0VGVXm/RKKr
	 TnmJczfopJdIqOKC/bvueb8a1IUKSpHq0MkO3GERMNwu7TWiZRyatNv9gw/jgFmi6l
	 Q8BLjog93OMzQB4vESNPiBsCz8e3mhea/ge8JeHM6/8pAJbY4IcRf+ZDno2W3EI7mS
	 NssvA4u/wjqlObgc4uiZDqRGTMQHigLSUgLw+3wYkpC/VA/Qry13ipXJOJ6YlRA1tL
	 am+DNTfRuyttb6yiNo69/enwFUs3hEtDaPhRTtD01NkLO7sg3EUPIsRen7n35FtD9F
	 +R6TlPI70Fwew==
Message-ID: <c267c29a-5678-4c0f-a15d-e5c12ae8c427@kernel.org>
Date: Mon, 26 Oct 2026 23:33:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
To: Catalin Marinas <catalin.marinas@arm.com>,
 Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: will@kernel.org, Ryan Roberts <Ryan.Roberts@arm.com>, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, lance.yang@linux.dev, mark.rutland@arm.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
 <daab2f45-56c2-48ad-a24f-aa4f889e4da2@kernel.org>
 <e0f60526-bb95-4d39-9a7a-72cdf32ca5b6@bytedance.com>
 <cc2e3af6-bb56-41b1-9cde-151797c3068d@kernel.org>
 <3b57c214-6a43-4fc7-a531-fb5eac196465@bytedance.com>
 <at9H9Vkx57pIcPos@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <at9H9Vkx57pIcPos@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yxeru896ozjgn5ragcn9qtqxx8rs7aw5
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1B39280006
X-Rspam-User: 
X-HE-Tag: 1793057095-791148
X-HE-Meta: U2FsdGVkX19n6eJ8ILmPcnHx+npUkSMfFhD1heQHVPib/WUnJqpUCaruKNVIULROhCGPkOQBaRRCjf9Wqnw1/DuoD0KxKbEZhwerNtjSJrb4NSxZecvTTyZSh0ZiK9XiDX8AJvTmS0KM0sWspdG5mF5f7fgNUKuupCdmeck/seWs2+I2fpMHeEI5Fpf4mMrZEB+5rutJllS8BmRhrWkB/F4lE4cPPa4A54VpJztubHjf1ldHrAs0L7z+en/ZJfVCv6z/L+bfhBTeMqNsuTGfYoM89CQ5+N6E5JQsxoKo5gZpgVmcXwne8WNJetbdwfA0ReU6+9t7kldBBtGHPXWdnRdoC9hkX7zNvCM36TNh3xneZ4+htWaxbvycmdhjH+uFCv1GaS5doJm5UkNDWOKNXeGq3VFCpL4E+9uxDfcl9NoyeX+1GpmwDNro5iAEJeX06QCvppM918r8KYIMCU2bqlucJeP1DOtPRJTO/HX/GNhGBQaNNT3J3wwXgfusNEBimaIPFM7KRyPyiZWEL6oJGo2a41E0XrQ+aPs0BxXqGZ7CxouAl/KdYgEzVPhadhuCz2akxW4IDrBcHjLTjjkVw/QRLre4wqYOniNM+Dd9FW3omO1jYx+aMM5/q/riGsRJqysFT2InuP0ErzK00aXlvXpVR3A06YMlPYxBkWh3BOhwlP+fE4f9DKPvX5Zn7jefyZAhwDSXnnfIhnQdo1E4As9o/JvaFC0TQbanTSiDoDu84tfbHFeFvzvFIv2o4CvES9OHDCA2lw/kc4XagAgi2sezWyVp1aEcloP3pVr0EbsUukaMUeWEaoY9WHa28GB/nRpAukiak5EhzN7mVwm248ceYQyAXCQm35l0wWfzfZ2o6insn3oSLIoNxJtUCwYaJPkF1sfKhljK9exMT6y0qCQQvnb0N1xuI2Zrk/XvZHvgJ0wZgntZNMvBTGhuVqWjIvPwaLd588AEOEcmBVk
 FiX+XBu3
 +QTS+vrqVu17QRszffFB0QOEEH2dbEyKvdnhCcCLNY3NHn2KsI5BXVhQNLeHnrtdJR7sYyFpE12BEvrh7wvlU0PqZnqff+i29LQ8bl7w3TGpBDNX96Q1cFJWrZ9mWe1jgmfiWnIMTB7bqkHwDjklEhmkW9a0v8ptcuZII3sU25VvldLCCSW6LKlsta3b7z269fcNVxAktEF6mBfQoMnHQSzodPbnbXObfFDyPHmAUi7f+YiXRmmW4dAUPPib7XKA3v0Gooejvolfa6rZzGXR58r9+VzYgqT2b8nl1+OBdCqO9jWRCkbWq+EREqSB7TnggZmQZAOuO2xa+jIN85jKuwG9BGD5ZQbTH3waBH7dC7a2QycbVGU1YjtNsNKlSCSiVwq8c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 13:30, Catalin Marinas wrote:
> On Sun, Oct 25, 2026 at 12:00:33AM +0800, Zhao Gongyi wrote:
>> On 10/24/26 4:55 AM, David Hildenbrand (Arm) wrote:
>>> If we have the spare PTE bit, why shouldn't we just use it?
>>>
>>> It will make batching over PTEs faster. And we care about that for present PTEs.
>>>
>>> So I don't quite see why the stable fix couldn't just do it right away? Do you
>>> have a prototype that shows that it would require significant code changes?
>>
>> I tried a small prototype that keeps PTE_CONT on present-invalid PTEs.
>> It leaves contpte_set_ptes() unchanged and makes contpte_try_unfold()
>> recognize pte_present(pte) && pte_cont(pte), instead of checking only
>> pte_valid_cont(pte).
> 
> I think it's worth doing but currently not sure it buys us much unless
> we also change pte_batch_hint() to cover such entries. However, if we do
> this, we need to audit the other pte_valid_cont() callers (e.g.
> ptep_get() needs updating as well).
> 
> So, if we aren't going to change pte_batch_hint() as a backport fix (I
> don't think we should, it's an optimisation), I'd rather take v2 now and
> continue with a proper pte_present_cont() etc. patchset on top.

Your call, the version actually looks quite clean:

https://lore.kernel.org/r/52e7e1f6-3535-474d-9b46-6bb62f96eefc@bytedance.com

But yeah, audit needed (e.g., no need to flush when shattering such entries that
are not valid)

-- 
Cheers,

David

