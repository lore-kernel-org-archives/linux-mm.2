Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41A8CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B58D6B00A4; Mon,  8 Jun 2026 07:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48BAB6B00A5; Mon,  8 Jun 2026 07:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1F16B00A6; Mon,  8 Jun 2026 07:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6A76B00A4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:27:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E66C5164561
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:27:49 +0000 (UTC)
X-FDA: 84856520658.19.6DADDDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 42CDC40014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:27:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqlpETE2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780918068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWwG3u0Aflc/Lda1tLzKYbhfKzk+y64NfNIO0xuz6x8=;
	b=EwE/3exSZjJlS/Kr1A6kdbIMKwC/+PVeAhlYgRPg5jp4FDpKJPWPW3fYFC2XEUjQU3/q8Q
	206tvAm93GIpEOP1De4EjpJXlxd/66vImLlLuSUmu4VdUo7uJllQaGV6xDU/AUvRMaC+ii
	cwUFvp4xXogsLvwmdsb+9Hq4y+ktjA8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780918068;
	b=U2gC0zX+ogvmomKUgA1WR5t/AaAevJM/uqLxSpCmi+VUM3ZQI9z0H7NV8gqmiNFSEKVVba
	0yGhwKOYb/OijD/jfTpOBWx5RaCCS5Phma6ZYAPhW82d9drRpUD/PMUMDwo1WS1rTpYCaV
	doPYKyLIyXLXOSXcFyobPuaJJE1lpKM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqlpETE2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B009C600AE;
	Mon,  8 Jun 2026 11:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438841F00899;
	Mon,  8 Jun 2026 11:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780918067;
	bh=aWwG3u0Aflc/Lda1tLzKYbhfKzk+y64NfNIO0xuz6x8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DqlpETE2sC+9/CTV46REFHah6qfKdE+9VXVClVpyTA7UyFkQaLR3rqjYbxKfg3BRH
	 S457z5AIQ2wen3PR38oQIytG0cvxYEdo2YBwyBliRZycsCic9YetdcOBFnU9cIGCCO
	 HMrYYlDdtOkjVLt56CBdMDFWdfTvbAMX19QtwWsiBEbVCDLQipbP2o48r3LDF1wlk4
	 2gAsNO4YwXt/eBJmex5keeJZr8/Ohh+HhwOHdTP4kxx4IApo3G6qFZ59BZlwkJOmvC
	 DTFaWRacxIL5Ioq516CFVwa5irMFJwWxb7u5dDN5u8EOo4lEVyKCMYeDxp7QqhFFRX
	 T8nfKxWt8ZCvQ==
Message-ID: <74d6034b-ca63-419b-9241-81f8eb1f31d7@kernel.org>
Date: Mon, 8 Jun 2026 13:27:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix ksft_process_madv.sh test category
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Mark Brown <broonie@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260608103224.344101-1-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260608103224.344101-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 42CDC40014
X-Rspam-User: 
X-Stat-Signature: 6tf5tke9opzq8zezw1ifi7bradsoxbyr
X-Rspamd-Server: rspam08
X-HE-Tag: 1780918068-274399
X-HE-Meta: U2FsdGVkX1843fjFZRnwRNQ1CH053qtOHeaCLXnVvhRnTwaxqF35GQHOJwqjePWABojXj6Z91y+E/kliFynQkz5lI7baAWzlUS3VymB/SCEA3N9mHRh9jmQaXq3TXRyy3/DaGNnpuDuU9KvJ03embAZaUsrszC622mr+LNjEriLp0zSPlCdfO/MTHWo98WZ3uraJCzOYPEwbnxFMHxMcU8rQdk5xOhABJOkxJiJSA8+NkgiNcUCSN/0eLLJgiF9ZecpPQUbjITJoUm5SnmjZ1McG3mpQfj78JThNZ6WOqf0+TwlpmATnZP4FIlpHP7amUqNB5hoPP+sAAT84UGNTnAMfZyTrscNEhHrQuNkRPcSomC6KjwzInQvG3A82J8utZONFEDwSZhwnMRY4Ytzl5+WPuqEUeOcVZ/694u6SdP9x5OxqjGUpB/Vn572o4bJBP0fBa/6fZM78lItKqDSqHiCZFz540oRNH2WIg0gb8SZWYa9u+z0rd/twJMkeav0gMVISiKFuEuEGLnRbQYu90+Oh/C6Z8RsxBKi0HPhfbtgAOmSTKQpZno/dySaGvw5W4pxl7D4TmpjnGffOgqcyJpErZClGlkEMAoKNqfO9AIkNptX3lxC2ATgweokjp80yHf9R8SB64E9cMEzihWin/MkAm5/J9XcMuiSpNt9yLGjn7TCpbVVFgP8qYkyzJr6kkO+Vgh3Nj9TTsh52LdOgHu1z/GSzVdfnLx6s9xEk6QuAs8unxqcYkNnIYBpCsH+C/+POIGDI61Rjjs8MtkFUOXSG3HFgNJH3rDKIC2iC+24kNohEHe5qQEiyiXrqxD3WG66pZkqmUEYn2cOfeQ95dMkYGtRPBlNMV7y3MwyRTCkavIfQfxp0e4wvBs+xK7SNNgZE8TVoHW3gcMsxSEGTU6H3DG8QLPFp6AG7ddS5H5ZiByyXT3MMzpQAp6YzW16qpDW+ek7QoMs7YvjPdrr
 K9VZjx+/
 gPzg4vZYJawyur1VkOlPsKUarTyxxZSZFuc1j4z1ahOjHBPxvhG+anjZGA76RNSpxqC/Qr4XtYnohLY4qIdgefCxtIggyfBi06r774qdqwqBkfx6l7ljXqTBAUb+ZNTKjiTvC0I7HBhwdr+1g7bheTQwdoG/jS9ml2LQVdMvZdoWs6fP2PGaIiTU+tsZqHqxDURNVQ/X2+ZOoY2OZ6vuISOUwQfR9H9CCfaj+b+4nbRt8StC0KXIpqp139l3WYga4MlVMDnSqOL4Z6pgjkIl8kL8skqJozI2FrpJh2p4y2+vuqEAmoprLcSVSGp1ew+qSM4UOTwjFNDBuk/twqXfPpsG3JepHbIViw9wpjZODQAkLYj91MSVY5LXrW8sggnyIXPFLqJKW9eli9ME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 12:32, Sarthak Sharma wrote:
> ksft_process_madv.sh currently runs run_vmtests.sh with the
> mmap category. Update it to run the process_madv category,
> since ksft_mmap.sh already runs the mmap category tests.
> 
> This avoids running mmap tests twice and ensures that process_madv
> tests are run through the kselftest harness.
> 
> Fixes: 6ce964c02f1c ("selftests/mm: have the harness run each test category separately")
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  tools/testing/selftests/mm/ksft_process_madv.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/ksft_process_madv.sh b/tools/testing/selftests/mm/ksft_process_madv.sh
> index 2c3137ae8bc8..edad2d2d888f 100755
> --- a/tools/testing/selftests/mm/ksft_process_madv.sh
> +++ b/tools/testing/selftests/mm/ksft_process_madv.sh
> @@ -1,4 +1,4 @@
>  #!/bin/sh -e
>  # SPDX-License-Identifier: GPL-2.0
>  
> -./run_vmtests.sh -t mmap
> +./run_vmtests.sh -t process_madv

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

