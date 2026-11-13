Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FF3606A8A7
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X78cUYoU
Received: by kanga.kvack.org (Postfix)
	id A1E816B00EF; Fri, 13 Nov 2026 14:02:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5EC6B05B1; Fri, 13 Nov 2026 14:02:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B1C6B05B9; Fri, 13 Nov 2026 14:02:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA456B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:02:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4F72A79BC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:02:48 +0000 (UTC)
X-FDA: 85431017616.08.A834A46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2C6D2100007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:02:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X78cUYoU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596567;
	b=tQWVJTEeE/DanPRsYCxOb8qXXBdYE7AaemfAXaeAj/uqOeK8Qj2zJiyDMPD5hahdxEv5/B
	IJL3hRD4ZZscfg7e4vJ29FW4HViDax/aX0qBtoJHJQoRkInjgeeO+5co9CprLRQvAE58je
	2gf9FTM6l76T5fP1MmbJz5RxgD5Yvuw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwTOBx+Jltn2XW+4Mg0maGISpF6Y7cfL2ZL24ASbOeA=;
	b=vwfycPrlIUnOju+L+qVR7r/rcBarxt39vs0AG5USB/Scs2HQ1V2H4uYgwAkSOxwnkQJbnE
	3SXVbozQe3iaX+Ky6iUvp4aQYgGooRqkrJS2fVoUwZESc+iVC2d7SNHpR/xkPc+y5pGyLQ
	pnjURrXIJOSTYc7O1DSyRUimP1SxmFc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X78cUYoU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A40AC6242C;
	Fri, 13 Nov 2026 19:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18431F000C4;
	Fri, 13 Nov 2026 19:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596566;
	bh=KwTOBx+Jltn2XW+4Mg0maGISpF6Y7cfL2ZL24ASbOeA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X78cUYoUjXHiG1qzWewIHCXS6qqkU3WoRc6BWbaI0b6GthrnVwI4mhpWL2GGvBZWT
	 r9GgfeBG8++oZO+Bw6dr+LZtOv/NMjN4Ntb9BpTSTN0ofH13FFgd+uCkE3iArb/zXe
	 89P9/ZVy/euGWgXCEWX9Jc4Wm0VLMjbBOv1Q7eI+SSO3fDwUW+HDvAxDZVlG/dwgXS
	 x7agLj5mWRKyknKwmcYIXT4fLNklS5d/bg7ydZB/TGeXgPqnaMHVRuNB7YijhLgxVT
	 EalRbF7PWqw6h+r5GnZsXMGFpYWbnBb4qzqyOi7hZk6yZ0/p64jepacEhvldSBqOdY
	 fWZfF67xhBkIg==
Message-ID: <64e1c24f-08fb-437e-80c1-e5b486d15200@kernel.org>
Date: Fri, 13 Nov 2026 20:02:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Handle implicit read permissions in
 madv_populate
To: Xionggui Chen <evers_chen@163.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 chenxionggui@lanxincomputing.com
References: <20261112031811.56500-1-evers_chen@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112031811.56500-1-evers_chen@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2C6D2100007
X-Rspamd-Server: rspam12
X-Stat-Signature: ic9w9yieya6oiuzs7haq9qx3kuks7rpx
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794596567-262916
X-HE-Meta: U2FsdGVkX19hpT9hVdY+j8Q++4oQNL7FfytNGtgg8xtxVg2CQLxorqPOhgj6qQVky9xe7U9m2IPcDQ5xz+3q7keqCNTu6aGs5CBLkz0llcWPjBMtAjkrfcTwwi6pGgT2/umAhPN+By/S9UlhZ5dXreLuJHbpbYhyBivPoZY6VVj0p/eiiy3LwWh7V5YO1oJWZEXbvEfJgP91E1Y376ZiqZOp0KeEoKjdsRit94YA+00mvRhX0VtPnV3feMeSAGFE8uPvVOJWCXCUHJVbtu0EMdRlDU0vByldpNjedirhWhjx3W6+b43iTkXcn7UVb8woCbB5pNq9FsMxfqlrz20mApCQlXSAV++qC7HIRRi/iqtso/gIKC3fRfc0YcbC5dAArEV+vvT5EEi91QDNSOG31tS870tL3z7QtiOKCMMYDi7q9K/Ujto4WnY88C/f8pfFd3HG44uFGnLsQlDy2xcmTH0I/gMcVM2stotzxs2cezsbXO9JhNjjYxcRzN8YMgUYj9l1JwOm9mZckqG0y5FIeb+2FYLYuH1osqOYuSvEMpNExjP8R3qRm2Zkos1h8YxEBBv8EinNfwFD+ckJ4XmhV60UYfTjc2bYGshwpxf80G2t+ckIVejhT4gvGrQtiT60JE8Hoi+13DYUXD7w3+U3sqAeS/WeN7a2qKAIi/D/1MDuNKfLnDkxdBeZU6sBEt4swY8aHChkGriVOkzGiLwr5mewvWzY/eJLrrFECLjiwQgrE30eGPJtk6MlBqPe/VIVQLbSbJWVX54QB3tsNbGKtK7NRpksa0pflty2TN2oRooy2NFQ18gWhBEZitNTW3Cp/keWnxpikBHHmJ6Ad7l4ho2deqTD5i7q4kFaSWLCq3VFvbzkkvY9pPnw9gJO1ubZFxX4h9odTyaw6vdsaVklPrfKpddRTEXCQEyqa2MqYUedzx0i3r96gBDCXQu90GnRPPm4Dqx7eTbkIrLQarD
 tDXCkz/O
 PnbzecWPLgrN3ZWJ8/UKxgsZxNY0Aq7FmAn3TxowsNgOwNSL2x3KiwMqz0lPciM+efaFM+HKi6uNv5hvKVPAhZ3qEw5wdja0ZwdqFtifUMf+pXDYpFxl+shIeDTbOb1YfeK2064udkTfO4wjp9cHPqcYOU62DXyfeHYVmp5qvl7XkfHlLq3yIr8nvQ3Wouh4xlwAXd9kfb2w2UVcOmeM91A7DeEKGB17Obg3URIBc0DYePeSbTRRu4UENxzxPpLU6gCVWMFFKt/9GsaA3PrvhCRhzV3B+XGmN29A7s5k2gwhJzSAoyNhDDRvE3ntZiUA7R3Hgfq4kVtUdZ6cXMiTWo36DkIU7KizdQiBcuSzQhpkB1xjfnp9BmR5Utg5VoJvDg98mYlE99wBMsJospmyRl4gFpE7AUI70dqjvuO5ZaaY44r3iqjDSCG0VdCjbdh2PG4wgch59nOX9cRyYla0f+ETSQJG1xj2ib9mASDq/kQCgOvylS39J8DiUdFGmX/TACNAxgU6g74b8Qa6tAomYgO2c+eBrQ46VIVFv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 04:18, Xionggui Chen wrote:
> From: Xionggui Chen <chenxionggui@lanxincomputing.com>
> 
> The madv_populate selftest assumes that a mapping created with
> PROT_WRITE cannot be read, and expects MADV_POPULATE_READ to fail
> with EINVAL.
> 
> However, some architectures, including RISC-V, may implicitly grant
> read permission to PROT_WRITE mappings. On such architectures,
> MADV_POPULATE_READ succeeds, causing the test to fail incorrectly.
> 
> Check the actual VMA permissions through /proc/self/maps and adjust
> the expected result accordingly.
> 
> Add a PROT_NONE test to verify that MADV_POPULATE_READ still fails
> with EINVAL for mappings without read permission.
> 
> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16
> tests, while the updated test passes all 17 tests.

I would have said, if RISCV is the odd one, special case it and call it a day?

That would keep the changes to test_prot_write() to a minimum.


-- 
Cheers,

David

