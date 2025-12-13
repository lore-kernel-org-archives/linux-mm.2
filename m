Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1416D59F5C
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 00:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD346B0005; Fri, 12 Dec 2025 19:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C3C6B0007; Fri, 12 Dec 2025 19:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D216B0008; Fri, 12 Dec 2025 19:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F42136B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 19:07:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5779B8B51
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:07:10 +0000 (UTC)
X-FDA: 84212507820.15.5EDCD08
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id C174D180002
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:07:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=V1966Dx3;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf06.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765584428; a=rsa-sha256;
	cv=none;
	b=shLNmn+aQrsYzoklK9H4PzAGwYKTTKeCWOGfpG37vQxA8qfjkp/c4buCVRItyNmaZelq+3
	c1PDzIL4MJDa6tqUReZjV5MDZU9lB6keJHpUcvfHkI8If/4cfmDN3fJQEi58NpRSBWnzJ/
	EtXqpT/gjdTFme4M87WJA66IZBnLh6w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=V1966Dx3;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf06.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765584428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c459pZsavFBd2omsdsKSsvXiCamORAaW3VGkhGRV9lw=;
	b=E3yglYU2aHY5BIkN9xQyr8O6oTSOpc7Rhv2dCrHyuYzXknscapaDRFlHZ/GqCv41zt8cYM
	sW+XWj38dbSRE6WRQ8tYXl+j1Gb+VB85U8VYLZJwfmRMUabkXaOlGZt3CSQiuY0r/RvyS4
	ISeKuBnk0W+J5ECeKHgBUvHGdmif4y8=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-297ec50477aso7518495ad.1
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 16:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1765584427; x=1766189227; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c459pZsavFBd2omsdsKSsvXiCamORAaW3VGkhGRV9lw=;
        b=V1966Dx381PuMg2m2fvyzmDf7igZdTlm5HL0+I7KhHw8KGBeae/nZ9cbM2TzQISBnP
         bf/OxEyi0qpyx1fUm7YH8N2BmIdZeSSwXuxM3uBh49ybSZcFyISae6EUTfxafVUuCTIa
         P/vXwM6rFYBemjTnMFy+UBvWwysz35cfJIOYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765584427; x=1766189227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c459pZsavFBd2omsdsKSsvXiCamORAaW3VGkhGRV9lw=;
        b=ubns4qH34COqvaWTq26EUJGmeVAKSDe3aVBFIjgA59VXzB0Lruj9lxSyY4pObpTy3R
         Ge/nqkzNi8g8JhOP/mYybqxiFzmTfwtv9nNZTtCa9j8YphwnoeZHyHmjvkJnkHQjQrxH
         IyR4YjQfsL4dq1yLMlecewoC6GsiMf6rRSZ02aD034wQN6lekVW3f01NcTRueZ34bbYa
         ra7z8Mq/RF1T9GMYUMpX0Ln+Tza5nk+SPaac5DdkbAwEI2opqDTF3DRi1ecUdiQyLpLy
         rS6ggMEaTPWEmjloXf+Bqd5J2/NTmzMcJTbiQona/UGuHd4yObNLjQ/jKKh63FDWtHwk
         aCUg==
X-Forwarded-Encrypted: i=1; AJvYcCUnvNCDmVF6ggmUhAAkAVxfcFpXr9JDdAonLEOHNTbxTRQeJXQL0DQR6lzksSfxhSOe8WDQZy87Bw==@kvack.org
X-Gm-Message-State: AOJu0YwKtYM+DOE3Bqbi1UZ9to2YL5uU7vPdcPSjSa6HtGQPwBTQAT3k
	WmYzxjKs5wHObiOFR7yLOrjJipmwwrTuSwK+5bpWEVH2ApMNJvij6UKiAwSsc+rx4p0=
X-Gm-Gg: AY/fxX6Ka09u3Zbycnbw1s5rvIgUeqP83cHjDXFN+ZfgxnkdlYKdGyzE4gG4A9oJR0/
	cI/MfjPOfERT8J29l+76G6Y7wrYtNsHclcYSdWhfVgX/DF1F2o7yOHPssPyoSkv/9owh97t9rhW
	VmNTp4x80h9GedHSXRikOWpebJiE/RIrbAXxZBciT4pL8Qn1IvM1Tekykd1Fp4dOwVOpyOxmRIK
	SIK/iKyxJSRSFaUiy0cOUrqubfTExq86wKlHFpWiGix59iKC2sz6HY8IHAcaxk29Jp9+T9qUY4n
	zUMZx3D6BKpvw02BIwkrHjkB8tB5SnEmj6mjvbUJ94doFpNFZjtZjVWBRytSjuzklP9L/mubn7W
	wsu0GjKkvvppWWjQSWfYBDXvON5E682iTNORSK/9qhBKeM5XvwKDLmEyLYri9jklpcPT9KSedxc
	Gq0nJVwq3aIv0SecAYbfdJtbMX89Cr23cMIAzCU8eSOP2ceQHbkkwhq/vnt4zOLyM7
X-Google-Smtp-Source: AGHT+IGD3neeAc46I6IPze60uchqAciCUw5+KPUso/H/AkJuBiPK5VpYZ9xQ7twLPULbQfBALpgYhw==
X-Received: by 2002:a17:902:c94d:b0:295:6117:c597 with SMTP id d9443c01a7336-29eee9f1eb6mr75179915ad.5.1765584427334;
        Fri, 12 Dec 2025 16:07:07 -0800 (PST)
Received: from ?IPV6:2001:f70:700:2400:3248:8d01:1cd9:d123? ([2001:f70:700:2400:3248:8d01:1cd9:d123])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29f2ebc340csm25064615ad.28.2025.12.12.16.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 16:07:06 -0800 (PST)
Message-ID: <cbc99cb2-4415-4757-8808-67bf7926fed4@linuxfoundation.org>
Date: Fri, 12 Dec 2025 17:06:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
To: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com
Cc: andreyknvl@gmail.com, andy@kernel.org, andy.shevchenko@gmail.com,
 brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net,
 davidgow@google.com, dhowells@redhat.com, dvyukov@google.com,
 elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com,
 jack@suse.cz, jannh@google.com, johannes@sipsolutions.net,
 kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org,
 sj@kernel.org, tarasmadan@google.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C174D180002
X-Rspamd-Server: rspam10
X-Stat-Signature: izhz1w37zoxhwy8r558emrfsmp31g6df
X-HE-Tag: 1765584428-570004
X-HE-Meta: U2FsdGVkX19YULanoykozAuB5o+WZZv2RYh8+eTUeWp7o5MzzO1ZoF7YsL8VuIqxGJNczFr8JJkd6GILV0HmkwipzK4Ja4VkWjv0GiXhG1ZmSBQllayIGYENixFNnJHfujs3vHbhmhcMbfTEMLsbueeLnklfGSKulWoa/0JCYq1NltY3eoAMObgK3CK3wF12a63mAsesUkVhx1gXlC+tEWSvCcPRmF4nqSXPNRQM0QNjByHPkC5ndnLjaNOJhIiCAavG0Axgv3KMsrenlWqGIXJk/xaUjLXmPmKP9pYtgXUK6q2jNOw6EXC0pmjUwtnvIMcU2Hi0Q73OCNUTKl0TEA1WIKQDv52PlpmOMVncyACsTN8p3ht343fYJ6+rxfpck2fX1tpt8MqaRk0sP3whDBC7aBxtrvBfectllzv7OfWTuLl4BQWlIizBbgS66bLq6fya2lWUwgsFRsJDMdihXCHm/X7uBPHB0cNkew4jLhb1uyZkFtT7rVK0EX0O9LrQ+I5EJaLvPBSyubVUVcBIyHM+b0Iaah2tBxhkNreNbdcNaW8s8NBNkZcdLFphx1ythrUsHCtr6DuV4+2BFQPJ5+QGj7IP+ceQY9Rz90JEasG0OjDw76eWDveUQfjf/prkDXOCq5t1TUo10SmRQkkmCq8WWQp4KtuCW7gx3qpmbxq67mvvyWFM0acA7/Gbn3u/cchT7p/u9JtHEdjoxvcmk0HMPfAFcbYOzk+GuxPONOOARZs2qoxzkVSlfkmezQYQd5dU+HSWbWfZuvP54/ssCEWmcewSLE4j1MAkOcFJs1G4fwPyLMi+jbkPWPp2TllnrpQKbFWnwcF2VJbtEgm5mUifMC/AXiqRIVZyVBPSOomB8G4XXVcprtSNJTfrt9nc2hSkCdQ6PNmkLrA8BKwVrcgeDGDxeu313B4jOv6uNh2wajO52dP2hw1662VBTl1TVNIxJlMgBNp5DF7Gb+9
 XRb3r2Hf
 feXyqlac1nBA4LU4ovHhib59nGt5dcwBQktzlhAEnO1mDtd5YqGAVutZrAonJjJRWjOUuRIV5EEPvslGBEr8mPHat5sdRTfJsEnFWYN5UNhVx9Zvd5zJzLtlCTt9f8PN+UYPm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 07:12, Ethan Graham wrote:
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
> 
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out. Using a simple macro-based API, developers
> can add a new fuzz target with minimal boilerplate code.
> 
> The core design consists of three main parts:
> 1. The `FUZZ_TEST(name, struct_type)` and `FUZZ_TEST_SIMPLE(name)`
>     macros that allow developers to easily define a fuzz test.
> 2. A binary input format that allows a userspace fuzzer to serialize
>     complex, pointer-rich C structures into a single buffer.
> 3. Metadata for test targets, constraints, and annotations, which is
>     emitted into dedicated ELF sections to allow for discovery and
>     inspection by userspace tools. These are found in
>     ".kfuzztest_{targets, constraints, annotations}".
> 
> As of September 2025, syzkaller supports KFuzzTest targets out of the
> box, and without requiring any hand-written descriptions - the fuzz
> target and its constraints + annotations are the sole source of truth.
> 
> To validate the framework's end-to-end effectiveness, we performed an
> experiment by manually introducing an off-by-one buffer over-read into
> pkcs7_parse_message, like so:
> 
> - ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> + ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
> 
> A syzkaller instance fuzzing the new test_pkcs7_parse_message target
> introduced in patch 7 successfully triggered the bug inside of
> asn1_ber_decoder in under 30 seconds from a cold start. Similar
> experiments on the other new fuzz targets (patches 8-9) also
> successfully identified injected bugs, proving that KFuzzTest is
> effective when paired with a coverage-guided fuzzing engine.
> 

As discussed at LPC, the tight tie between one single external user-space
tool isn't something I am in favor of. The reason being, if the userspace
app disappears all this kernel code stays with no way to trigger.

Ethan and I discussed at LPC and I asked Ethan to come up with a generic way
to trigger the fuzz code that doesn't solely depend on a single users-space
application.

Until such time, we can hold off on merging this code as is.
  
thanks,
-- Shuah

