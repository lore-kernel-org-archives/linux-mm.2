Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AAB606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=nwJhAOGk
Received: by kanga.kvack.org (Postfix)
	id 505266B05B4; Mon, 16 Nov 2026 02:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5E16B05B5; Mon, 16 Nov 2026 02:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CBD96B05B6; Mon, 16 Nov 2026 02:01:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18FDA6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:01:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97CF6A85C3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:01:31 +0000 (UTC)
X-FDA: 85440086382.24.E315A71
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id D0FDE80009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:01:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nwJhAOGk;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf30.hostedemail.com: domain of evers_chen@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=evers_chen@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794812489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oCH6XC+liX1SVUHDFPJw0slOUl6aJW30d6QU4zbVWw=;
	b=j9snn8acYpuj6v1gAApLtH5tE/WcHLV9ou6K3VZzKo/M0fjMfE/5EN5507N0rKYKuBLuMC
	VXIZBb2G3HPtHF/dwVynHFgrzOHjK3WxpB1AGAAJSkWXITU3kPjtEv/BNCCmt9J3g6A/3t
	P7mHm9d3J46BXqI7ai23T7ic+JRMjNI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nwJhAOGk;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf30.hostedemail.com: domain of evers_chen@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=evers_chen@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794812489;
	b=2CIMIQa+5rk/QgJYzzJBmMW4MTBvBhxkaCVyEolzBFskO/1oPv29cNhJAVSG9yaWZpyycU
	R4bUIoEEjnq6giL8WQ6Opj4uGDF8anWOAxwv4bI5S2NmR6C0FlHNL8OtrxKDdW3cWlhAIE
	iWbxMXWQdj72HKpsLEGiF1fBJB5FOd0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=8oCH6XC+liX1SVUHDFPJw0slOUl6aJW30d6QU4zbVWw=;
	b=nwJhAOGkQsbbp7/qNOE8irIS9xvAcgD0oeiR0r0qtW+Jz6o/Eidr1QHeX8xT7v
	PylJqImPFnywn4PhjlDdsEQ9hjA9p6E7M3bQpmyZP9dsH2ufAXSyscPqGm36bVgc
	BOipbzNJZDuu+gmj4NspwUSGWU4qV7mPMEPMSjHjo7E0Q=
Message-ID: <206b5151-c527-4b7b-8694-dd9c6cfd916f@163.com>
Date: Mon, 16 Nov 2026 15:00:56 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Handle implicit read permissions in
 madv_populate
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 chenxionggui@lanxincomputing.com
References: <20261112031811.56500-1-evers_chen@163.com>
 <64e1c24f-08fb-437e-80c1-e5b486d15200@kernel.org>
Content-Language: en-US
From: cxg <evers_chen@163.com>
In-Reply-To: <64e1c24f-08fb-437e-80c1-e5b486d15200@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wDnD70oqvpqdH8PHg--.13365S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw4rZr18CF15Kw4xtF15CFg_yoW8XF4rpF
	W8C3WYgF4Dtw17Aws2yr10qrs5Jry8Gayjqw1rXFyqywnIk3WftrW7KayYka4fJr4kWw42
	9a95WFyDAryqvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UknY7UUUUU=
X-CM-SenderInfo: xhyh22pbfkv0i6rwjhhfrp/xtbC7AkOGGr6qilLogAA3J
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D0FDE80009
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: sdixg6zwrw8y78usqca9aeprao6mg99d
X-HE-Tag: 1794812485-969065
X-HE-Meta: U2FsdGVkX1/SmVBR6Wu8bqS2zcksN/nF+6Q1vuqFafVKy46YuESqri2o87IIe8Gybq+MwJM15d0zrEqrN3x9Qfi41QR+Te7bJikYoO9zire+6qvi2pjP/gnGdFJmdJLhgyrmPfhb0TEoITzQX9l4+5br4jvKl8AoH7w8er0LfABpOHmKxbBnQJw6AZBaGvs0H72ZcKxTZYdS6CV0KTZ6WD5oD90WQC/tAYJlfcR58lF2KX5Ez3ChHUwZlCf9rHwUgASlxi5rSvhHtYbbiKkj9IdbkGJ0dqkzfBlgyQfDYNk7hfh2onLvc7D8qEshwIKru1yc7t9d1MbY22HECyQuI2P67Rrhr4mKIpTxm4CZrAJ0+hnsnZ4W5CVK8vbFclrXSWgdahRdxFWGujTrW2JUYhNNTs+6546kovB/MXZSeaEpGiT7PWH2DUZXRHUC7sFGJyuUIP5zM5tYedGSu8ObIjwuP6WGDmEgMZIonrq6VO+u7qP/2Ep8ac9lSXBucZTgcZFy9Ow6mxLvFBDakGRnkjOfm0jFndXb5aCHGMUfhl5uGLWvteFnbIc16VTQjrPCriFUgt8O7+9pDNpz9bwdpDhyGMdu3PeHqEY6Je4clD1rl+gWo5cgVAf3kzXfS0IQEJpQ+Ka7kDFJVysYD4A29r5w/vwLtpmJ/Id2VwvyZutKgqUFyvYJPPXI6GVkwJ3Ye/ehhNHSupASj9vSoXWfijy7V9QFLb2JwgArXL5trm8FtMQOK0Q4A+e8cLX1nVG+hxV4BJXPYD38zhALRvQNz70Cp8M7NgZrTofxIkxQM5biVdH19Zf3SXN8GTjMswwlhDiJDfJUK3TQBeNkAzcyOOenuYQeXJ+KsjWB2UZzGWahJ8/gU1DH5EZ0wBM2rk1/dHkYIb0nHu9b1pfUGQe2QxveuBCiqsxj330ny0gxrLyNmEAdQopMi3phYDuioJZNU9nY8lA2xIP8SCTNvpC
 6+BaxN+b
 qTG7yfiMZ+G+r85STdjnkjWrLPCW/cW8xieZSOpdP5eQl1Tyj40RYtHgkwceKzNTvhNBmZQS9GpXNk+WZHdGfG7OpOmRTI3n38/N5GQCjsGENGJGmGa8hbxurmHog4geS99OeFca7kAHlp3oMsqscMUi6yj9UAI47lz1a/3llQFaskxUWnow2Fyl9LmPHtV1SAcUgFVdn2fQOc7jjGn31RnDvZlGXs0sypKgBI1YYTevQ1ceSHDSkDTv6qqusRp9QAOCsN+iuxfI1oMCjBF+wZ62KsyOWJRqAeN1TJTtszXMnA4V3PSqCIFDKUz93+STpiGJk0+BjNRpPW4Bt7Ewl9LZY7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thanks for the suggestion.

Agreed. Since this behavior is specific to RISC-V, a simple 
architecture-specific check is sufficient.

I've simplified the patch to use |#ifdef __riscv|in |test_prot_write()|, 
removing the |/proc/self/maps|parsing and the additional PROT_NONE test.

The updated test passes all 16 tests on RISC-V with Linux 7.2.0.

Since the original patch is already in Andrew's mm tree, would you 
prefer a v2 or an incremental fix?

Thanks,
Xionggui


On 11/14/26 03:02, David Hildenbrand (Arm) wrote:
> On 11/12/26 04:18, Xionggui Chen wrote:
>> From: Xionggui Chen <chenxionggui@lanxincomputing.com>
>>
>> The madv_populate selftest assumes that a mapping created with
>> PROT_WRITE cannot be read, and expects MADV_POPULATE_READ to fail
>> with EINVAL.
>>
>> However, some architectures, including RISC-V, may implicitly grant
>> read permission to PROT_WRITE mappings. On such architectures,
>> MADV_POPULATE_READ succeeds, causing the test to fail incorrectly.
>>
>> Check the actual VMA permissions through /proc/self/maps and adjust
>> the expected result accordingly.
>>
>> Add a PROT_NONE test to verify that MADV_POPULATE_READ still fails
>> with EINVAL for mappings without read permission.
>>
>> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16
>> tests, while the updated test passes all 17 tests.
> I would have said, if RISCV is the odd one, special case it and call it a day?
>
> That would keep the changes to test_prot_write() to a minimum.
>
>


