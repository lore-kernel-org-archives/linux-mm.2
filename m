Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9798C87FCA
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 22:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5B66B0092; Tue, 29 Jul 2025 18:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796116B0093; Tue, 29 Jul 2025 18:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685236B0095; Tue, 29 Jul 2025 18:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5699B6B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:17:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C32FDC01BA
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:17:57 +0000 (UTC)
X-FDA: 83718715794.06.7FA7544
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id AFD1820009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:17:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W4pT2HpZ;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753827475; a=rsa-sha256;
	cv=none;
	b=B90LQuJ0y98fAIAWav2MIorvvPYB29X5QiXt7RO9hxUhWT+v6VHHmSoK2dUCDpL8L4EOhS
	uQPk8L9+mTmU+zPz2RuAIw9easZvacP/aK+8+Fgy4KAMdZ26fG0HsozAnHBMwJkkfZvq+F
	ivxQ8TvNN/BodD0udf5htAh9Ukp7DW8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W4pT2HpZ;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753827475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9R9i9gZzmllbRYerZjV3O0Hgnx9VaX1f/NEv9kky20=;
	b=iYc18hFefmxdJDWoyNPW1RDGoF0BSxG0Vbqk0cPUg+mGogfjoilx7gUGWTNXWBvtlZxw3a
	EbfZA8WtoQwno7YsOCk8zc97yY1A++RCOxVAjxf0iYnyJBFkjXRWycxmnI/UN7rcmHOw6j
	3tBCbqJixIrtq9YkWGupfcQviHmDLR0=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4561ca74829so62888525e9.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753827474; x=1754432274; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S9R9i9gZzmllbRYerZjV3O0Hgnx9VaX1f/NEv9kky20=;
        b=W4pT2HpZyQq+cp1MCb77px3YwKyb5oyxU/EmP2QJs77NO8GAlnYW1+zDplp9R2VGz9
         Rya6FbUiwL4E6DhTV0nXDT3NPmY2YIoYN14wEJQlIOYr+6e1k98lOgzxNEIrb3v/4qDL
         UAtZtWkJ5V/ORK8u+zhJE9dES9D8cMt14Lwrtya6bt+VX1cER35fa7BV+6Y1NeTdp4Al
         t0lJy0IubX6r7eqffCF5NRG9j2e5xYxDREwVe9n36yksSK/SHxC2BAxG69r7hVnM9222
         nQGxpWQI8Bufl4ZAjmmEH5cBnvKnCaGKPx4nmQOxU64/j5tnTV0imvAa+HMjGFidKhi/
         yW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753827474; x=1754432274;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S9R9i9gZzmllbRYerZjV3O0Hgnx9VaX1f/NEv9kky20=;
        b=KAcHrxtXXRCC0C8pCtizMTMFi6CZ2PxBFX6vtm9EUakaLtcZGP0sB0ZCkMextPnlli
         EoBjQuAw/coB4iwSsGs/RmmgRdbNZYCTpWu2Zkyabm2krQRDqbDUMW4Fyi/lGx8pMrwI
         gYj5NfSmlbbNF7Q+qZEY06X7gj0B8ltnVymHcMk4yjQm8oQCNHOg0AjcsjVnIdLfq3af
         ldAIOEnMlhlOxQSLa0SvUZ8/VRRKDJaOpi8P9tLcDzjdF19lMZExxj4B1Olxvpmly6vO
         eTGEVVlLFMgladU9+hK0d0bS6TIP2POQLF7i0jXOqmNjwy3HRGMtL+UuJHQm68SZY+qW
         HH3g==
X-Forwarded-Encrypted: i=1; AJvYcCUKhdO+YIcHgqvhz7bZ4fShwWOW4uxpysip33QjFAH+7epy0/3ddoKOZA+Kk12fiA2Y0O9M4sRCrw==@kvack.org
X-Gm-Message-State: AOJu0Yx0Hy94XaHa/6RLLC0OQSiW52oX+ibZuyWcr5hD3I29cQadHAxy
	Cq/25ZjOhQbR6cBY4ny++251X0gLFtz1QReTz8lB+iLshKPw4D7PSwU1
X-Gm-Gg: ASbGnct/8Ml2/EFpEGxQzE3Br+OInyW/oz2acXjOe5QO1+Ndptma306YOVsXpBYsErS
	lJvhYngI2i4s4AZdRXhb3kSEgsKb+Qrof47WI37wftQhmxTp3KC67VfztweMMyszIdAdydU20Rd
	RHpplBO7fCjyFg/DPE9F6rz3QCU/WQftID5/GONltFqoe9/J+osY1fs5VWtAPzO2Ive5TIDLyJ5
	M02O+/Wi1YjagXiSDHveqKXBLyleTdfq0x2jCV9fYgiCO4b0GTusxFj66HvGx/tLzbVjH+voULE
	oryjwbmkEBwvJwhuER6StzvpK/rB2BN/7ULZRGw/pun9FFTM9jYkrhfweAbIjZctPd2O2icDyjz
	lXJaSmvnASk1D3QOaAeBtZikdPSryLjpRh057d6X6MnJETQcY78eMOoMZQ9oDztcot3gcnzylnZ
	sPZJRs1UMokA==
X-Google-Smtp-Source: AGHT+IFAxzVacxawo5KpZIZ8F2nXYc0D7iKisaZ5kTwE/SHS9IidB0NJRFvZd5YAa1l7F+++rO+7qg==
X-Received: by 2002:a05:600c:3582:b0:456:1204:e7e6 with SMTP id 5b1f17b1804b1-45892b9d130mr11458165e9.11.1753827473924;
        Tue, 29 Jul 2025 15:17:53 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4? ([2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589536a6e7sm2875515e9.2.2025.07.29.15.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 15:17:53 -0700 (PDT)
Message-ID: <59099cb0-638b-4ca7-b20e-f407a2d27217@gmail.com>
Date: Tue, 29 Jul 2025 23:17:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] selftests: prctl: introduce tests for disabling THPs
 except for madvise
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250728165549.62546-1-sj@kernel.org>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250728165549.62546-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFD1820009
X-Stat-Signature: 8tu86swekztadg5dg3g5s9xgkdicud4o
X-HE-Tag: 1753827475-715919
X-HE-Meta: U2FsdGVkX1/HHNDfn8RCV43raCU8C5VDHeBHpe98enT9sesj3mrQZDvcQoq3Uty9AEGjRVFOoX/bs5ReRTX1GkMreDh53LyF1wGnTuTYaBlcggtDYzNYy1AXVylgpDf17oVjv8c1tP/dJjb0De1i+dsEFomZnOSH1qoPnaE8YO18t8Kx3cOze3IZnTkOGS7zxMpa+CeHxn6snCmoQYPi4EAgrTs1XPYHkJrHJ0awWI4XS88BW18Xs42k3VFW+4UOis6kgbJI9UU5ttLGM3HIDD+BOZ/RMMMx/JanWIB5J8Fs2yIR4rJ71l66SG6fTtPiG8B7PMX8ciIH1taj1idSzsvgxs6UmzId+/X1n3gSD6NIS62nEKI4CwdTrYJzdyN6qVIkuHhlN6uj0e+McQudlTt2fZ8yeXDRWppSQaLlR7IeqactDNKv1FsM+pwBBW2L8aZ5ayTnSk+VMHgMgmoAh6ZN/q1o9UeHYnogLh5EoMi5C8i4jhmEDpdHiLg/4e38abcu7T8UUaeaPZlcdWqKUXG3NvEe0+ZNSahMZ1snDtDIK1pzOJQObNBMgUzLJnQt0nebEO1ORTcM3BqspdvGic1t56CBeKrXRfn1ltLy1Ya61u+OZp/Bg4sTpuwTNX8CrszsaREhaD2eVD6KEAlGQZI/rIbblmpMSLsUzRPApGyHYbj7lcQCrZYCatEAo3/bJPRlc0W6ZBShJ8uT2n6ywENXOGCexxi45XqzNCHfc2hpJC2RZenVMiBgsRmm6MfabVW3U/UYRhzKFgnUn0Eto6RwXAVW/PcpKVYLW+wKzB8at4rsgrwgPIrL9z6jImEx57S+7CRH22ibmvLjKOJol3HgimVnBatfSDdIMZ6RIQ72BmAwpPJTyToo02SP/twS0BtI52C7EU8p/Kh+tILWqUKlukI5XinP/DSmu6bJ5cOS47/SjSgByk0Hx0wYPfQ79+we68SavbUyrs+7RfJ
 6yltvJLI
 kGg7GHC8ZkqNncdw9WUsE2NUDMP8kFvG55OqEruE7bVcVCt59C6msgcWni/m+dX4gr8JczHZnerSFHqWAAsan9y3vT8a0M7n9s5ZxdmzQk1/lBL/x5khbPWQgk2MSafwTTKFxMs+xE3Hhv7ar+KLxMTimEHI4pIkObwPBge6n5u2cSkH065bchA+EIQ12ShLbA0HzjoxEJAIaIcGgNTzn00Xt4cDewXJdIN/xTQXzMyOVotIap5oS1t7UD1j25pZgKByZLP6aNwEffP9LX4OcH/ZQW3W8j3AnkRuVBkhmetPEirVF1UFzX80HJY6k1p0yrvsY9bCKYCDm3JTNii4NFy8VAWXFi87Yzi9prKj6BF2QiyIWENxRyPXf9T9wZA7UGJKSCoFp6IRwYqAE6VHvuiEOAgPwEcncvDE+jR52erz66nRviuuP2Ggw1i4bec9JP5czvTHCDKoA6JXgSeHhAt8S2pnBQt+ZL8JTCTqmU1CkDpg2jJQhd7vU9tj7+a+cADgm/2wY3jSloF/y6ksJt4ZRSI4yhU23hGXj3DY0ljSgOAJkeEjFOG9uyM1/gf7aXKc7tIzzBDcR4u4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> +	res = test_mmap_thp(COLLAPSE, pmdsize);
>> +	ASSERT_EQ(res, 1);
> 
> Seems res is not being used other than saving the return value for assertions.
> Why don't you do the assertion at once, e.g., ASSERT_EQ(test_mmap_thp(...), 1)?
> No strong opinion, but I think that could make code shorter and easier to read.
> 

Yeah this is on purpose, I found it easier to evaluate what the output should be
if I wrote code like this. As compiler will likely just optimize it out (although
we dont really care about performance :) ), although others might find without res
better.
I think you had mentioned it in the earlier thread as well. I will remove it.>> +}
>> +
>> +TEST_F(prctl_thp_disable_except_madvise, nofork)
>> +{
>> +	int res = 0;
>> +
>> +	res = prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL);
>> +	ASSERT_EQ(res, 0);
> 
> Again, I think 'res' can be removed.
> 
>> +	prctl_thp_disable_except_madvise(_metadata, self->pmdsize);
>> +}
>> +
>> +TEST_F(prctl_thp_disable_except_madvise, fork)
>> +{
>> +	int res = 0, ret = 0;
>> +	pid_t pid;
>> +
>> +	res = prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL);
>> +	ASSERT_EQ(res, 0);
> 
> Ditto.
> 
>> +
>> +	/* Make sure prctl changes are carried across fork */
>> +	pid = fork();
>> +	ASSERT_GE(pid, 0);
>> +
>> +	if (!pid)
>> +		prctl_thp_disable_except_madvise(_metadata, self->pmdsize);
>> +
>> +	wait(&ret);
>> +	if (WIFEXITED(ret))
>> +		ret = WEXITSTATUS(ret);
>> +	else
>> +		ret = -EINVAL;
>> +	ASSERT_EQ(ret, 0);
>> +}
>> +
>>  FIXTURE(prctl_thp_disable_completely)
>>  {
>>  	struct thp_settings settings;
>> -- 
>> 2.47.3
> 
> 
> Thanks,
> SJ



