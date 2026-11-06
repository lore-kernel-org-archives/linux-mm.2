Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41267606D80D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YbmWk8WU
Received: by kanga.kvack.org (Postfix)
	id 5FA116B05B1; Fri,  6 Nov 2026 03:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584AF6B05B2; Fri,  6 Nov 2026 03:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F716B05B3; Fri,  6 Nov 2026 03:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15AA86B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:31:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D86BA0CE7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:31:14 +0000 (UTC)
X-FDA: 85404024468.29.CE39221
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id AFBFFC0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:31:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YbmWk8WU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793953872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gRVAhGeZWCNMiNHPmygg3aA49aMAiMWPBcpElZA7SC0=;
	b=VH8+OPvGT4jVMjeMEN72G5ATVcoZZcf9MGALKBUZQf28XIegBjEVN0zwRMKnLAvwJmrlUo
	zk0aU8puNBXZGX0cnmUQ4xIEbZW+XzRZ/6HPAoLLrKvj7qYDv+V+hPjTxHnE/+LX4ulEQG
	f+CLocAmxvWkdOCdyJv5SRwHA7ZvTQY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793953872;
	b=xWRTJ5U6tmB2zY+i3VEfkuqsSWTamfBarTRCvu4pigastiYamHjNTWBf3SvstnMuOZVKn8
	8lI1K8Mg7aTOTW4aXgg6Al2tiL7LTuwBmYg77CsGuh07Lr29+3WuoyJjzrqglVBQVxvh4k
	pHE+n4+qBjzw9nUyM2P+xL4ZHID50Ls=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YbmWk8WU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so3046145e9.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 00:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793953871; x=1794558671; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gRVAhGeZWCNMiNHPmygg3aA49aMAiMWPBcpElZA7SC0=;
        b=YbmWk8WUrhIEj3EGj3vkVgzvY0a4Ny5j39EBxCiXSJjfQjBpzj1CcrPpT30F7crH9w
         FtabW30/C9evTqo++oNQW1bhYJgv4BDSy5aSgnc8HYssIO2NKZ2wLU/rddYFoIvieyM9
         aDaF2SnH5LUQjO1e3rnC3jCRudlQglQnj+0EfXtwtcP7s8APhNe2yNeuyf3j178p4ZS2
         A+Y3fQqeye7JKs1UZiMkT6eS6oW/eTENHr2Y7rnLEuj5CoKcwCTrtbSIlkK1OmHNYwuo
         vvJQZKSY4nv4GNpCDx7x8sGrDrPLgYEDQVrx4ZyJq8uhfCJiiW9Y96m65OoTllRnl+Vn
         SQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793953871; x=1794558671;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gRVAhGeZWCNMiNHPmygg3aA49aMAiMWPBcpElZA7SC0=;
        b=Pw/Llc7Jg/v9sGjuRjf/CARUD7qiHns0+Vw5g5KJ0O3HHIOAnU3OMKdHno6+d90Xlh
         vaBFzShWZhyWH+4682YhmqRgDDL+vNE4kU/udx2m7bdZtgLfFi5fzGjhALHNPhqLdKX+
         ssXFh6c47wzp9mZiYNtVEniCQNIiMVmfhzvXuSJLow0wABl9lXiGE38WlwT9Ock7J2oT
         opwgisrQl2fn3qg/DrAvMAJBYoQkDfJbRsc83EL6BOA8DX6B3d5M3KZ48fL8OBHia8aC
         nnnKThR8BO2E+m2YgeE0og3MYvJHrpLWSKSWuEutEWNWgLNLMLYYPzIcj5Fhd+Xz0R7e
         b19g==
X-Forwarded-Encrypted: i=1; AKwUvBwTKSJ3Rp61/W21j7dpzWgpyX3VG5GfJ1UhZth8/js9verPCFW8AXzy1H1rjGjXYQOqnk9LUgPjhQ==@kvack.org
X-Gm-Message-State: APuU4Z8BR4BwrIxzakqG3z/lLrlrNkKVZAu8ZkA99GVOxb7EIYW7G++E
	XPkdOdBSI/lcddrApOUNuEdSTuddkpUD9AAs0WoplbGnmfuGmxD6TRIU
X-Gm-Gg: AYBFou3ep2BG6TNLU+lLsiynck1YWTrQ9F5ofjFTUhN9BBf1i4g7qLvxQYxcb4L0Ps2
	/zSjvoYKKrsp5G1ZACE5gW+SlR/HTkNI0q3b3vsQRTBF8fMzagzkciVvgKp62EOCsxZR91LRP++
	qhMTHGzDH756dwfNB0C5v3h7okvKyJiZ2Q553AYZtNjaGnmLowknBILKsOkb6XRBDMM4OcmN0eD
	jNJzdduJ2yxTGK4C0oYhRJ9A0bd1Ez5UNFRZOAlh/kUAgsuIsnDWNQq/Vuu6vkKh4vj300Ljqg4
	XbPpx+UJFWdX+lTfZZ/ha9zgMAK8tl/ycc/ZMR0fZ+BvMkPe+V7+T/jRbkEh0IItK2nZDImt4Xf
	fWe83GJNG7udmOHy0bKKlbpE8ElLPmQpBUVli9mHSIVZ7hc0K/yXCzD0qJMe1dgvbFhEq5BS69d
	XiMblD2sKUJyjN26RjUNdYAQhlIZS8ZyTRyunUfvHLnwJj7UspyovL8KwqWBl2eEczYblpHLF5A
	nAacS9kTRVg1Pamy/T6x6wbeIe9AMAEngVNDvCxbSVeO77sr/XH5F6zayq+mENST6E2gF9ayQ0L
	ZmERveoFd+EPppYPcBG+9pa4
X-Received: by 2002:a05:600c:4f42:b0:4b2:4b5e:8141 with SMTP id 5b1f17b1804b1-4b6df4f2304mr29162125e9.9.1793953870825;
        Fri, 06 Nov 2026 00:31:10 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b6dc6e0cfbsm44553765e9.0.2026.11.06.00.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 00:31:10 -0800 (PST)
Message-ID: <40bdc057-7e5a-4904-9f1a-1a36e639e0e7@gmail.com>
Date: Fri, 6 Nov 2026 09:31:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memblock: don't allocate new reserve_mem regions on a
 KHO boot
To: Mukesh Pilaniya <mpilaniy@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Changyuan Lyu <changyuanl@google.com>, Alexander Graf <graf@amazon.com>
Cc: Tony Luck <tony.luck@intel.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, linux-mm@kvack.org,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 Pratyush Yadav <pratyush@kernel.org>
References: <20261105213153.9572-1-azpijr@gmail.com>
 <d928099c-4e43-4af8-a929-b510819967ce@redhat.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <d928099c-4e43-4af8-a929-b510819967ce@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dpsz37h6z6ybxnr6hzt5fxcc6g9er54f
X-Rspam-User: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFBFFC0005
X-HE-Tag: 1793953872-231231
X-HE-Meta: U2FsdGVkX1+kYzQpx9BfPs5hadEXo7qtSxPxZik+RuKpb7Qew16HAKIOCziqZ36GPlxJJ4iIzIQwKOtXL4MFI9h0rRcH0IVgGNCqR3NR9pP+TRQzdNblkqxMHlhudJydDmUWqgir+FlcXAMsD96qG0Rd4LEUeHrUD6IFvceYNz73aDtmzqEbwTZQIKLs+e1sp9Hmp7mA5cJZDF8Ap67m/mBIyXAzofmsSYB02DRPNfNAB+t5bN9NAl8nMuV3iHEHPEZkYaqLIghx2YSM92wVUwMrUZwESqkFp4NHGKD7AbRoAAr+XqIVRvJWhcEdrtDERVhdi7TmD2WONOzOV400GhYFeqtkArAsT3EkM/18d3MHrPyufgi+cZfIRt8ApD2iMY1TZuqfGLTzQiltp4KyKI5eoHbyqm/g23bLT3dDiN8VhjuiHFofJdarZq3yyyHPSLXOXAFibUrgwTxZl3RUAMRBG/xOM1mxCphDIRC41bh34MQZydV7Auf7pC7htrYtHh27lGNL0w9vmBg5dgI9+/iwMSJwqcf/uQ6LUA7V3w8D87iX2Ok2SZI8l38d1m4ufnSbrKxiVHRDiuP5F7wDjzIgPjo3lQCO7xpvmzVG8qdYuKGCzhaNDG7QEfuuPN+38nTmOUelLZ8R19T2kYwwlqtcdd7tzpKY2Jy1/nARTwIMWZ7dyNBQMwxZ2qtH229B0zV3rliPu3krCFD53oCnTKmI777cN1kwjYs+WXgM71Ap5jUDf8G+Ql1j4nnlf38Ctf2nhaDIcCKy19ptZRJJco8WYNu7tvp7ZaNsoTUZM061hvHlnXLaC4zhuizjVPp08DQadEevwE3oUz95eHYdRt4cbMjOosUK8zaico6JwmZuLpSGyXnlhVkMZLipbVU/rsjx7JOqRnw8nehbaKBGa9XUskvOmpe3ogBbvbvwYFquHHym+ZtcWFG+lktMHX9lxkU5MF6XvS/wiPdAhhW
 sAaZpQBa
 wvYAenARzhogjfsnyOmRUhjbkY3QMcKpOZB7aOXqEnd2c/cYzhkrriyCpynUzTsXf17zgCf75EqwNScC6fvvdCjQaidfIcTPZ0rXMLAcgoE2xt3rpLlYMXmQ4nkqC0Hdakpr8bTqiagRfCQ6HJAwGq24/XHQu2kxeaCdQptRCYwK1QrZpYn1YvYKo1tceHwmdYZkoXHmx4mTJN1+XCwRFwKid6YZzl1Zrd/LVuyGfphY1BhfwQAYQiWi1jNzjBhjG1O6alKubsM7TLJw5VJk0on1OfepMIUNch11hIqVxySfZdjFfnjYxLTqEQMV25/2rJITyeXzlogMbvdkGBffiYvwy/Ah47WMCPv4dsjOTPAM005vAXX6AKosRZjhfwRIb/nbnkvXS7NxCxa59bZJ0SfDzB4K1DTgjoO6FcBarqPX3HGo5h8HQf67KcsrSmh7VmJtB2vDa6lnG6luN3sNpqjFdisx2/RRgrRV86klU28Q/O4SLwafxoasuPBmMNNvnJyC811Hg5o+x9r2HVb96IA5C5sGWXBSFPwVyMCdEiZtptySLtOTaYflKZJarncUOdcfDQ668Js/9NeA5DL1COF2YGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 4:57 AM, Mukesh Pilaniya wrote:
> Hi Jose, Thanks for the patch!
> 
> On 06/11/26 3:01 am, Jose A. Perez de Azpillaga wrote:
>> On a KHO boot, a reserve_mem region that can't be revived is allocated
>> from KHO_NOPRSRV memory, which includes the bootmem the next kernel
>> boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG, preserving the region
>> then fails:
>>
>>   WARNING: kernel/liveupdate/kexec_handover.c:1245 at kho_preserve_pages+0x168/0x180
>>   failed to prepare memblock FDT for KHO: -22
>>
>> Without it, the next kernel puts its memmap on top of the region and
>> the ramoops records in it are lost.
>>
>> There is no use case for adding regions across a live update, so fail
>> instead of allocating, and drop the TODO.
>>
>> Add an is_kho_boot() stub so the memblock tests still build.
>>
>> Fixes: f99230780211 ("memblock: add KHO support for reserve_mem")
>> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> ---
>> Changes in v3:
>> - add an is_kho_boot() stub to the memblock tests (Mike).
>> - add Pasha's Reviewed-by.
>>
>> Changes in v2:
>> - fail on a KHO boot instead of allocating outside bootmem, as agreed
>>   with Pratyush [1]. this drops v1's patch 1.
>> - not an RFC anymore.
>> - based on v7.4-rc1.
>>
>> v2: https://lore.kernel.org/all/20261104204235.9066-1-azpijr@gmail.com/
>> v1: https://lore.kernel.org/all/20261021211058.83483-3-azpijr@gmail.com/
>>
>> [1] https://lore.kernel.org/all/2vxzfqxglrg6.fsf@kernel.org/
>>
>>  mm/memblock.c                     | 11 ++++++++++-
>>  tools/testing/memblock/internal.h |  5 +++++
>>  2 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index a450092a80fb..e325e0542c9a 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -2827,7 +2827,16 @@ static int __init reserve_mem(char *p)
>>  	if (reserve_mem_kho_revive(name, size, align))
>>  		return 1;
>>  
>> -	/* TODO: Allocation must be outside of KHO_NOPRSRV region */
>> +	/*
>> +	 * On a KHO boot memblock only allocates from KHO_NOPRSRV memory here,
>> +	 * which includes the bootmem the next kernel boots out of. Only regions
>> +	 * handed over by the previous kernel are supported.
>> +	 */
>> +	if (is_kho_boot()) {
>> +		pr_err("reserve_mem: can't allocate \"%s\" on a KHO boot\n", name);
>> +		return -EOPNOTSUPP;
>> +	}
> I think this over-restricts when KHO is explicitly disabled. kho= is an
> early_param parsed before reserve_mem=, but kho_populate records the
> incoming FDT without checking kho_enable. So a KHO payload booted with
> kho=off ends up with is_kho_boot() == true and kho_is_enabled() ==false.
> 
> In that config nothing can be handed over again; reserve_mem_init
> returns early on !kho_is_enabled(), and kho_fill_kimage bails on
> !kho_enable. Allocating the region from KHO_NOPRSRV is therefore
> harmless, and the documented best-effort reserve_mem= behaviour is
> preserved.
> That said, a new reserve_mem= line is rejected and its ramoops/ftrace
> boot-instance consumers lose their region.
> 
> So, Would
> 
> 	if (kho_is_enabled() && is_kho_boot())
> 
> be better here? If so, the memblock tests will also need a
> kho_is_enabled() stub, since
> tools/testing/memblock/linux/kexec_handover.h is empty and reserve_mem()
> sits outside the CONFIG_KEXEC_HANDOVER ifdef.

good catch, will do it in v4 :)

-- 
cheers,
jose a. p-a

