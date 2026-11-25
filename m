Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4F4606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HZZpKpqL
Received: by kanga.kvack.org (Postfix)
	id 6A2156B0AE7; Wed, 25 Nov 2026 16:46:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6798A6B0AE9; Wed, 25 Nov 2026 16:46:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58FD16B0AEA; Wed, 25 Nov 2026 16:46:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31C096B0AE7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:46:39 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE60D1C4B67
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:46:38 +0000 (UTC)
X-FDA: 85474976076.04.9D404A7
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB746180003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:46:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HZZpKpqL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of shalasheg@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=shalasheg@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795643197;
	b=JNZ8doiQFvQBqRJfLSJm8ijlVPE/aipjF2InOpLgKA9v8dq7RjuRgsJWpdzPdkqiKiwqGq
	kfoLwFBif44OBUpBJKQl0NAjDessWP6hAg9myewa8loGM9e4D+eo4kgtgDOaOtP37SIPne
	F0WEFnw0cDvrHLOI1s/T7YZeH1ujYE4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795643197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ECZfLCqovArdDXRBWaYMU5CLXc1REyLj6z5OT4Fz8Bo=;
	b=VUqKJU6xeo9DNPb1G//GUZ92SpjM3BlaYAE0waPzRVR0PucayHLcPZC4B0rtlQA2xSOwwg
	alTZWMLQ3L6VfJRabaYP6/ayxoZ5M+aCIsj8n4hc/VPHCjaZ6iluS4MeVi+9o+sQbnOwE+
	oUpR9LmIXkJBvfaedUtR4ePHLdPNEBQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HZZpKpqL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of shalasheg@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=shalasheg@gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be3cff0f6cso4153521e87.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795643195; x=1796247995; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ECZfLCqovArdDXRBWaYMU5CLXc1REyLj6z5OT4Fz8Bo=;
        b=HZZpKpqLDd4CJ9WGmyXLL35z+EsphE+rszkXglENeBkFb6aobTNOsJMJL9SmJHN4aM
         X/quiIYNMNHZ/QI+Fhzx9di5pD9pBYeHcmDmu3Ra8ocv6qE7HPAjqNr0Jrb1yApCmB0N
         48U8/q0HGFkD5CPrVA4XgPMkQRsMFvOhGSDhdhahmCLH1dLuOXaTEi4M31Xt3Nl/2QoD
         AeSjRJgRK+uh3NNgQVd6+dCGnHYmz5pNC93iOEOn3b33tHnL09R0mI4bGJXHuB7q9xC6
         b+SU1FX7CjCuJHmzRY8/BgcBPQxr+QipT/lYMfrzGfcB7O/Etiiow92p8aE2MIxeJBhU
         G3Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795643195; x=1796247995;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ECZfLCqovArdDXRBWaYMU5CLXc1REyLj6z5OT4Fz8Bo=;
        b=ajLsWwkfqsa+uHl5ABOYModzqthw5NJH84wNK8qcPlV20HuSpASiNVV4IFwpiYe3g4
         e3Bv8oVvMKjbp19B16IcDuYiWmIlXkJV1JhJcpTU+ZtgEQ3wFNx9jTvwGNyGrkNZhhP+
         eBxzyeszQDf6cKXfe8yHCkjUo03Pk40RJUfTLYbpqaKXxXnBlR7K1lgQcM9lT2JWa0WH
         ruEfNdtc6V4/3Y3TuvRTVeNAVkWNcG1k14UJPycRAg8Po9GjNW1RGbIauScaPnBWNX4T
         UJ6hkT5OQqA2HpO6QiSomkmeWFo4MgzifmQpW5hZOw9nu6MxBG5Rr+Cu1vsVaZcFc1ti
         6omQ==
X-Gm-Message-State: APuU4Z+toZuXFcVuhsJ52jivX0FEYDtze1slbPbWmiIcN7TlFqT/S4Wb
	cdaSpXFo9NUj4o8YQNxai4GU4onEXR8bKVyuc036xG0aJmRzg11CMczV
X-Gm-Gg: AZFdTZeJeJNRc6ZdTdIzn5FXtl6tf3tBxlXkqJVxqh1o6Pft3SSrQTKJS2/oEHuQu3f
	5XMLzsB9l8M9oxvRNxyMNo60rtqDWSJOFsU0EidudGXbZtwmQJo7fjBmYEIWjkyG6HOCFQsaIyq
	zIjnd/hVf4Jkn2f/XZm7ntlqqSDEtbrU0o3piwfQQs0Vft65M7vyMAsb9ffN/j3NwYb+45/FW+e
	AGuh3vPLy4AIpflr87QH5UZtyjO2YcIMNHDc9iyuHiInjnXYrOytnhO2fZ0nVJvj5agwjCqP9xR
	obVaB0abQjUo52UxXQpS72tcVFg4fjtEId3w6hI4zllco/oRWsa2YVA67twnL3GyJ7C1HufMVMQ
	HytQlxpub9nOSrdh8n/VcjpB3bkLxINH69QkHPgGgFlJRQHOAOxbsCQPSdBfX0ATVG/rEd9Rz4A
	IyS5h3HST/xeEI/9mxLRz1EgKl589uQVoBrVr+XyHRAcArEvn6SdYRak1Am84i9WggUmXW0Wq1E
	5GSlX+eWl5ty1V7OUc/IMJNT1oU3KJTsm2/rOkZC4ITCw2mEOAnmqm6CFnWVHJ0Fkp1w4wlAxcK
	RHICrqyJR/OLvmDS8SkiZkKyK/3JMCSxtes0WvC89m/CohBrIvveTF2feA+kfA==
X-Received: by 2002:a05:6512:3b08:b0:5c1:b29a:1ba3 with SMTP id 2adb3069b0e04-5c1bc7d5ce5mr7798199e87.29.1795643194950;
        Wed, 25 Nov 2026 13:46:34 -0800 (PST)
Received: from [192.168.0.103] ([46.8.6.187])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd04327bsm4896168e87.51.2026.11.25.13.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 13:46:34 -0800 (PST)
Message-ID: <edfb1d04-0d55-47ed-b1cb-dcd8c5df75ce@gmail.com>
Date: Thu, 26 Nov 2026 00:46:33 +0300
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] percpu_ref: make percpu_ref_switch_lock per percpu_ref
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
 zhengqi.arch@bytedance.com, linux-kernel@vger.kernel.org
References: <01612865-faa0-4fe5-8184-a177f104843f@gmail.com>
 <6c943754-05b5-4017-9145-0d145766909a@gmail.com>
 <20261125113537.bdb168bfe8962ef1aefc097b@linux-foundation.org>
Content-Language: en-US
From: Egor Shalashnov <shalasheg@gmail.com>
In-Reply-To: <20261125113537.bdb168bfe8962ef1aefc097b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DB746180003
X-Rspam-User:
X-Stat-Signature: 17fb4knzoratwbshgyijdocigshzeawj
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795643196-207793
X-HE-Meta: U2FsdGVkX1+w40owEvlILM9lra/1VvEMcXlDNGsrgfqUrGnen4Kuhxn9k8UzVQj+/tWivmrIB8F8T8+itKCgbWUoNe0++38mdiEvturrz1ZQtEsz5j18ilokd985ZhMwQGIqcU08CXhlAtt1/ENZayBcaX8iU3HkHwjzQeTxvYipEk1e+/oX0Z/9+UY6J1kJI/Jql6la7eXfv2R3EbIuWWQz4NHcnLvRm7eQaMcpBV0YdY4ijahxTuE2e+/BQbMyLUepjglzwe+wKu0VctHUbA6jmLCqXMOc3D98+18dbOSWOK6zjmcPGfJcfwpL5ruUcJaaPTlASu0BfFncEEoSbtx/F4jAPdVjzzaBpyTn1ydV/aIVkw4zlai/EAn2Eiwr9g42D73jmO0iB5AF4yIEq3h+3ZMrpwp6FPFBNLdm1tgoXXzU/IfHmZffgdq9KWNDUAyO7vyT8jJIAtwh4jL5Tuv4zG8OghfpOfSHPFK+Oq0xT5sj2fBcCiqNOp0o33Rp1ZgUsuZQTSUjPXKgaa623ElkdJSswO/qJUlUnvJZ0Qza9AOcNdaj1WhPLYVJA67OKoICajetL0+7LUPQ3tXMXp6M3T4fLg9gBe32//4SSBBXhkTzOmTT+bUY/wSTVmQrjQz4e3qSGK8UBCwDEJYiBZQ4rzPY662xk1n/aNMcM5j/eIVIkK6uSd8u+f7Mwgl6+EVdgeLBFtZYlDPjzt4IVJ9pUg4fbFYnAcy7mQXrDv5FKHshzQxnodnpDFwa3bH7R/UT8XygJW78oHKhytig0K1yH1JpOWjjCtu4f6WtWF2stQrcWMngMZJ9sY2zPletZbtpxKPV1PFsHUeLcQRN/UrQszQaHLRWbpHOvT3Jo745E8nzyZl374dxc8/96yNTi5D74hXGHE5Uaqtd6aC6HU98ZReQviL37h6PsoqhlP2JLefBc+rr7+/QKTB5qwcyOquQPaVckteu5XxkVMt
 VOHoQuHF
 BPYt9ffzs3tKRS3TNf7ix6M1vxW2YF/sGqVFTVrh7y0k5rIVdKtwoErYAOc3looRcpCnXpcrl/3oZldN9BYRMfoH+KyGCfxl1wQXyU846a1T/njVmt8iRXghLs4SWOhg5q6ss1qvVAhWLFLxgPxje2vJEgfn3T+/vA2DLdq2+HeVDaEy4+pHf6r1pKCd8R2GIn0MSJ8vqGIYGum/y9NCWP+XTPvSRnNGS5cFX7x95do95NCM4I9wmQG7F70azi54Cz7E18XRwEUfPzWvJ57PJ78afFBeJm0jdpj3/ogo8OCpWwZicZ5FmV8lXF60f4+HjhRaHdckSeZUNdWz1l45wtJyLyDQH4xhv/c+CPq5mDUfAsz4s+TQcnl5cxfo01Vzz9DH28lMUKxpyDTDv4EVHmZpC732hKANpaT1qT3LwkE1pY0Snlevjmxmp40Vg9YWung80MSJP03Fr42WTf46AAsxLcu9qLdytZNJLuYBYsqjgyCEL1Vpdtxzs7MVsVke/Ulzb0IRsKnGqGJazo+eJ22NrG6QNZzo4rFOBFTOf19sRgp13WXiD1taTnf7H/MFttubth+BbRPxdjedab3bvTLyQw0AfsRDGqmkwewDTfJIWnhxgXVmgsXjefVz93Dp/GbqHJHpVh/HuY49biBrhH9vlPRKs2aJBLHAlzaDs7Hv2yPs/uHm3TrZfM6HbX7TSL/PRKqKDw9yqXSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 25/11/2026 22:35, Andrew Morton wrote:
> Well, an unpublished module isn't very useful for us.
> 
> And an intense microbenchmark isn't as interesting as a real-world
> workload.  So can you please provide more details about what "our
> workload" is doing and some measurements on how much this patch
> improves that workload?

The workload is a full-volume discard on an out-of-tree storage
block device backed by NVMe drives. The test machine has 128 logical CPUs.

The device maintains a percpu_ref for each independently managed
logical region of a thin volume. Normal I/O holds a reference while accessing 
that region. To process a discard, we kill the affected references and
wait for outstanding I/O to drain before removing the mappings.
After the metadata updates complete, we reinitialize the references
so the regions can accept I/O again.

A large discard repeats this lifecycle for many regions, with
different regions processed concurrently on multiple CPUs. Although
the regions are independent, their kill and reinit operations
contend on the global percpu_ref_switch_lock.

We measured the elapsed time of blkdiscard over the entire volume,
refilling the volume before each run.

Volume    Global lock    Per-reference lock    Speedup
 1 TB       3.424 s            1.218 s            2.81x
 8 TB      27.943 s            6.133 s            4.56x
16 TB      56.021 s            8.591 s            6.52x

> Alternatively, this looks like somewhere where a hashed spinlock will
> work well.  A static array of 32(?) cacheline_aligned spinlocks, hash
> the percpu_ref* onto one of those.  That'll get 90% of the benefit
> without growing percpu_ref.

This might be a better approach. I'll compare it with the global-lock
and per-reference-lock variants and report the results.

