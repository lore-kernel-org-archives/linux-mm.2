Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D85606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N4PDt2E2
Received: by kanga.kvack.org (Postfix)
	id DD3CA6B05B2; Fri,  6 Nov 2026 02:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84836B05B3; Fri,  6 Nov 2026 02:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71FF6B05B4; Fri,  6 Nov 2026 02:58:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9CE6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:58:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5475C0CBC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:58:24 +0000 (UTC)
X-FDA: 85403941728.29.8F0A72C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2035B1A0007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:58:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N4PDt2E2;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793951903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7sxNEVsyIuTPV8a6FVFVg4qeZbioTDu21HyPpnSnRI=;
	b=XF4ytjWyfU7PT9yyW6t6WXrKE0+kWmUD1uLJ0Fox09jyGjUw3WEP78fR0mlCDURrFcD/vj
	wWX7vUoH2Ec6uaaAJS4w3O5Nw4NEg8sX2M5WDuJlqo89vM0Rc//DLkMCAjfLZchuWv045A
	jsj+MyneuOxrTIW3hqRTTdY5NFIL6Zs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793951903;
	b=xe+ZJJAR+9WbNqnDeWF4utZwoSw7OV0Y5xFSe5SxAqAojIoFaqruvxllPzOv88C2JNO/ya
	F+kdwlldP3KWEME2Uqksq1JdMRbG0iDP+cxyXYcreK2+8IvVYxBV4Y7s+JVs/pwvUq166K
	jUt06kQ4E8hLjaT+gpDYMLL4bb7nHu4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N4PDt2E2;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15FB64080D;
	Fri,  6 Nov 2026 07:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF8F1F0089F;
	Fri,  6 Nov 2026 07:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793951902;
	bh=G7sxNEVsyIuTPV8a6FVFVg4qeZbioTDu21HyPpnSnRI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N4PDt2E2G4E+VIbvP7UlpoJPj86dhujZdzHPEsZxc3xuXtlYhZskE4BayNPfpZ/oR
	 P8gUzu9WnPVRdzSBSb2ePhoiGEmmDBep9EAQ6jSY1hXdRbpyyiRm2pc87Xx68vFi1/
	 5Ny7OoMEhaXP2x8+4d0uWbuGxGEqY+IRHHOyMf+cVuzuMy6TwlFyLXbzMQTvbrYapr
	 uoDtgKkKt1JJARcN0hgr0Vxtxsl4QYrrcrRlQuaxpX1KSflyhJkbvVjWnDfhI5DWt3
	 zIbZxsASJ5jb6CgyhoBm9ppPnATR24JLITsmmbhiWMwPrw3rV/J55g4HWmJ1m8ct1Y
	 Oot/kWOGNLORQ==
Message-ID: <5d13a6f7-6b00-4557-9a1f-acc934a2c168@kernel.org>
Date: Fri, 6 Nov 2026 08:58:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: MAP_FIXED leaving holes on failure is very difficult to recover
 from and can even be a security hole
Content-Language: en-US
To: Demi Marie Obenour <demiobenour@gmail.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, Bert Karwatzki <spasswolf@web.de>,
 Jiri Olsa <olsajiri@gmail.com>, Kees Cook <kees@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, Paul Moore <paul@paul-moore.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
References: <8b45a161-101f-4f28-9b7a-c7c8b8a29f90@gmail.com>
 <auyXeApQlV_CMQDm@gremlin> <310aec2d-3a83-4544-870a-ccd5abd78f48@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <310aec2d-3a83-4544-870a-ccd5abd78f48@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: eyf6sg86h3cq7zgha98djar94jhj8h73
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2035B1A0007
X-Rspam-User: 
X-HE-Tag: 1793951902-396585
X-HE-Meta: U2FsdGVkX1+zPo8xVENWHQk2l/pXzZXoLoFgb7AEqCv/o+BVn6PuR9shjvhxoevSBszHWi94tnR1J4CEnNiYt+ZcbmBZ0kQi8EDhFHBKFb+vIKdDupaNFIg6uM+tym2ZXlxq8rSHFtqC3PWpeMY8kptJ9fzgAb9ZJ4O67X44DgvF9BQTzh5KWHLHS+xYtlOBXB7ghAWoupEcWD92BF9ooJ+bnStfDwOHgVmsX/7AUT9i6QzAJoWEojKLh5fcXGwtRQbmSZ0ieUhBTe3iKB/7T9Xdvc/WeUR2KWrzlpXN753QCNPjKonu2XllKab5lWvDV6aWLTtSTNZhwMKKukj/QXpefTDIiFLGCXmByELPHnu0qDJLaOh+jpt8MANoWbNlFvzzFtfUcVuxSnWUKQqod1G7i2RO57gBjF6MHtgfFcK9uSX9ZVigrKsagPaEM0sSqq9wGTpqujlt5laWLJqt8LqL17A0JQNWxnIcqikXOOCJEcUjEP6uKPPf32KhsbIlFMZxDx4uXyA2XFBiFX8uWW3Nxw8QWk1ojGHqWH+awl/JQUf2cFcxLzgJlAmXq1/xvMVqQkfzRHr+3BYzunFTejn/F4Sa001zqo5kL9Yobl4fv0AlHaVqU5MUR/AsMuwZeg1yOmZfeS0EHwmZPvC0+IQi1Lgj+90Hd81glVJQPaVcM+3+zp40BH9/Q4hVEWaL2dDCUh72n/tfIvM8M/4BVaAy00bUJBPANfwqdJ4sr22OIYAWjtUI2KpPKbR36yMu8iYh+Vg3EmUKIJJeGhkjx5IZsDGRJAdg0/QTyiKW1yVKP4TvJtxM/xY6pCyv6nmLXLu5PRKz/BkpIPWhDl5iqmCcFnNMtVdM/Lkf4NhhbkIT/+XL6o1SuLmdxfkdTk4njZGeTF4wCgWv9DAMmWgFDA1/gk2niXdxIPdMlldH1sxA+dEULzvq516SEN3h3B0Kqzn/ocCq6CgtR0Bkzz5
 5DvoAwLn
 DVYop9a3e5RWpm+lpa5/iCgAHyE8JSIH8AXxVhGctUmhnSoCW4UEUFXPb8pwzQwYy08hFr2coXH4zf/LX7sdpFNMBR8Wj4G79eTmOBhq/oEsWLkxxfzwf2VnJ6wem7OcXdiykNG6KevP6rnV1ObajMM3+GRVoYiJpcYaYyCBFkjDiWeRdbMdVRPbW5hqxKlIeSYsYwu1eWh2bs4wVXI8mNNhf3gB41+mMmFjt9n0AqHWKfXPR/UVovH5piskomu9TrVOrzYvSsOBIpT4ShJJ6W5BUfDNH7sVnJ59oW01WFxUBkQUan9c+KDADEYK04QY/6m1t11SN5vsGEZRZHHYSpNNVDacHBvZvSDbpObDBdQZVzzDHSMhEv9HFLdInyDy0a8ciyofMu6cE/hhkgdnBKpKTPEwtvj5GBDkLstuBePi5+1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 00:59, Demi Marie Obenour wrote:
> On 11/5/26 10:11, Lorenzo Stoakes (ARM) wrote:
>> [ please check kernel mails in MAINTAINERS - my and Liam's at least were
>>   incorrect, which makes it easy to miss. Fixed those up. ]
> 
> I thought I did that, but obviously I didn't do it properly.
> 
>> Thanks for the report.
>> 
>> In general linux system calls do not guarantee compound operation
>> atomicity, and any assumption based on that is incorrect. If you see an
>> error - the operation failed, perhaps partially.

I'd think we only cared about not exposing the temporary state between unmap
old and map new, right?

>> Further, a failed MAP_FIXED leaving gaps was the case for most of the> history of linux. Avoiding that is infeasible.
>> 
>> I advise you to review the NOTES section
>> https://man7.org/linux/man-pages/man2/mmap.2.html on MAP_FIXED - your
>> suggested use of it is not recommended.
> 
> Does that mean that MAP_FIXED should be deprecated?  It seems that the
> safe use-cases can all use MAP_FIXED_NOREPLACE, and that the use-cases
> that cannot be served by MAP_FIXED_NOREPLACE cannot be served by current
> Linux.
> 
> Specifically, if a MAP_FIXED mmap() fails,  the mapping might either
> still be there (in which case one _must_ call munmap() to cleanup)
> or it might not be there (in which case one _must not_ call munmap()).
> There's no race-free way to tell which is the case.  This means that
> MAP_FIXED is unusable in multithreaded programs, unless one is okay
> with leaking address space.

You said "This was fixed in the past, but the fix was undone in
4f87153e82c4". Any idea when exactly it was "fixed", whether the change was
done consciously (or some refactoring side-effect) and if somebody started
depending on it?
4f87153e82c4 is from 6.12 (2 years old by now) and nobody complained so far...

> Are there cases, such as anonymous mappings, that cannot leave holes?

(I don't have an immediate answer. I'd guess that if e.g. some kernel
allocation can fail, this can happen)

> I believe there are some programs that depend on this to handle
> SIGBUS faults from truncated mapped files.  If even that can leave
> a hole, the only thread-safe alternative would be longjmp() out of
> the SIGBUS handler.

A concrete example would help I guess.

> An alternative behavior would be to unmap the pages, but keep the
> address space reserved, as if the mapping was a PROT_NONE anonymous one.
> That would avoid the "it may or may not have been freed" situation,
> as it would be safe to retry the mapping or call munmap().

It would probably have to be a new flag as that's a different semantic from
what we have now. And the use case for adding it would have to be strong IMHO.

