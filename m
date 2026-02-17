Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE23E9A047
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D4E6B00A2; Tue, 17 Feb 2026 15:32:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED2B6B00A4; Tue, 17 Feb 2026 15:32:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF426B00A5; Tue, 17 Feb 2026 15:32:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE8DB6B00A2
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:32:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 901D516036C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:32:17 +0000 (UTC)
X-FDA: 84455095914.11.275A3B0
Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com [209.85.167.194])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7946380008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:32:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=cUTGz4jC;
	spf=pass (imf30.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.194 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771360335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTb6I/Y6Yeg69YIr2bHQGlJl+Mkv02foH8/PpQiTI8w=;
	b=ojkBxs2r5K2bwUkHuldFI/8xEXcXfH+Vh/Da0zhLcFzZ5l9dXH0ZayOE+VysjsNUYE97ek
	iT60LPjJAXUIsmnVIxZH96JWL+RiKYItDMP2eYuyLI395TNHbJRVWUsxbGVGOZ8XPn4Smh
	1MMlwqSp3Jk6CwX9oTlj/rxrY8H5NWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771360335; a=rsa-sha256;
	cv=none;
	b=ocihEIb0mmdKMVlLkU43PSmTyDWoF2YZIJaDuuam3xZOeRDSznWOMNOSFukbpeUZTeXOzY
	/mCnc0vfjJHOulaKqRiZIHSCpMhOab/4AF4O5HxVuZdGDBRpkOaO6p3PZz3b6jQv2mr1m8
	/dyJEXTKlTEev52jcqEj4C6qn4Y0vpg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=cUTGz4jC;
	spf=pass (imf30.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.194 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-oi1-f194.google.com with SMTP id 5614622812f47-46394090d2fso1335410b6e.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771360334; x=1771965134; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GTb6I/Y6Yeg69YIr2bHQGlJl+Mkv02foH8/PpQiTI8w=;
        b=cUTGz4jCrS/wiLEKR80HD1GCQoSyukwDnaMtqYlDn2FaHwOtAip+XYGpHAOLxFDwH9
         Gk/Hi2/E4ID7/56BZ+ifr4n+w4nyGQBROkpUIRzGgL7zu57EkQfvNDky/mEyAlaLhSv/
         PIZh1AYIwxb/OohilJBeokk/ksf/Ki8TPWKLCikZPLS4DjGrKIwJ96lISFgg8kQeUe7h
         IdzBNHnN/pI2GyPTNMwYGrXN3yVy23j1anLAhcw8TV3jjzQvR/AzfZN6axB+zR7JHBOC
         YLIl1H1aEqO3WeB8kDRhWPVa+M4FdvboyKGEJpTJktCe+Iv3oP1iscAJHR1YOWkShKWr
         Pw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771360334; x=1771965134;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GTb6I/Y6Yeg69YIr2bHQGlJl+Mkv02foH8/PpQiTI8w=;
        b=HMzM6qfQdvvSpdEF8xWMkP62woEY3CLDbDcuiU3kDu3huwzCBTLwK8Te4IhW5NfGsO
         wh0YpdlP5SEb+WuVEmQKzlGrBbwxO2B7J7mwXL/NRYlnXI2bGIIKwtfqY036O1vk5VMr
         HwMStn610hk46gwtvLlKyjpLowRolCnA/9TFmfDgQfMAgT+HDefA7dTiI1spLe1Rhj6q
         oCjeL3g4Y8VjoYmDHet6ZpRnTMTXDowyMK7YhpNfbmLvgKcwBLK/4KG/0ocfJ8RvREXA
         q8ndW+t3y1++RFw46Ll93dCW4B2UmE72CNXeSzuDx0zHQG03cbNxphSUg1tnM2bthRVI
         kF5A==
X-Forwarded-Encrypted: i=1; AJvYcCXmC+gAXfv9mokAHn3UhMDNOhML/oXkfxUnjGh5nYwYkzhNYXXyQs+6ZafCRn95Zv7TZyBEjRK1Qg==@kvack.org
X-Gm-Message-State: AOJu0Yw0KxhsDY1fVhLHklwp3U0wN24VQuXs3MaFjSrtgXz8N7nJW6KX
	wJkUer3zBEX44iYKv2Zi2HAc8wGtrn3hJHVDQXTaR4ywo22rekxvxvOGIuCuln0Y4gs=
X-Gm-Gg: AZuq6aIGk2tptjpGcqhvCMv0/z/RjfcH7YWQlKYibSUxalxi2pigHbtqKPLdMtrWNGg
	NwUT4VkjZCr9RJ3fMKeq+QACZjuUKelYdHU848D+KGGP0ecgVKLEF/4jURLphzsYmf54SG7Fvcy
	4Sy3ZJkDfn6D3uEXLcBST896H/3dlqk+as7wQx62IQnDymE5CiC7O7GDQcR6DNTBliXlCIkC2kl
	y39LOX4k1dgq1tUN0ru54ZVu3qi5Qk2jT/orA3R3SYD59INPKFZThy+RcotQqz0fz16Ov2t/hGr
	dhwq3Q6c950bdjGGPqCra77tKUv1i43nL5AIfvxlYrP6k/BD9lnFFNk6uu0sgtmwXwt+0NCwcFY
	um16Ste+fWR4A1/p4Ja9lEN0mbjsiP+pLN3iznr6q2I7U3QtHpPa+pTbVI37RuOZcWC6L3WKSE7
	gqugwKB8Be3CVuM54Gofy4TNP6qRdUVOdZWh8XtVCANXTBYYdAgMzZQAKROmaSklhQTa+f2idzm
	Btn1J27
X-Received: by 2002:a05:6808:1793:b0:45c:96bb:1202 with SMTP id 5614622812f47-463b40b7374mr6464117b6e.58.1771360334150;
        Tue, 17 Feb 2026 12:32:14 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4636b065d5csm13412550b6e.13.2026.02.17.12.32.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 12:32:13 -0800 (PST)
Message-ID: <abc66533-063b-4cf3-a683-d7c15ffa1c05@kernel.dk>
Date: Tue, 17 Feb 2026 13:32:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
To: Andreas Hindborg <a.hindborg@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Boqun Feng <boqun@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <kkmXYWYC07oImDD0FJFVCCWl45alQdraRLHoLr7zowZfE0tMz0MmPIpuyEYQRSLjBQqrp_Ch0iR2Rix_g49lNg==@protonmail.internalid>
 <aZRWOIPThLfIZ1Ph@google.com> <87ecmjcw2v.fsf@kernel.org>
 <Ubu-HoF6Epp0EBvoi1HO6Q9YgTbAxfjfziFD3wsuTop8XLAXSvW2ZkzmMfb0gA2zCfn1XjwuxBSpyx-lexty6Q==@protonmail.internalid>
 <20260217160451.GA2995752@noisy.programming.kicks-ass.net>
 <878qcrcisb.fsf@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <878qcrcisb.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7946380008
X-Stat-Signature: 9iwfeobmkohfest7m4hqzcn38zhngzg8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771360335-242636
X-HE-Meta: U2FsdGVkX1+Kd6PgO5+4dJ1eS/UpwhZ4J/eQOGKPliip1dhLAxHdR7W96mwFf0yNWlpDUlnNADDWn/aj3JMxbZDB2D07lF7UE3P6Tkc+F7KxsGvjboAMriBSEgLFHPjBD2xFQ5J9cyXO7pF93Pdu58qSZKdw/J+CtBCxsKVRWfnY3tTolb+6IInHxkRMWq5e49Vz/zppe2ltvxK8azdMp8F9KVZr6PZe72oTdS2COviuezQmNN0+tQPOc2Lo4UfheDyplIhHTqI+GynE8XCcQWduJ8o4hQVt0S280wJKCJDjmDm0rejJpWHk6gSuFiiqdsdk6vUl4RlRgMcQXhQZWAIx+aox5i5yhMIGd2Y5lw8MoCXFUYmSIKSD0SmrcYgytsbD1lz5xiyM8pGHYNeobyFSDQk/1z47ITcq9ZqtgduzbufzHkpqSYAYeCPuCtrCEfyC9FmnjqeWmTJNu4UFueH7VkKFd0LDTQTZVOnkE5FOOBL+NF2mZYCruB/SiUPvgv6LcO55nnO8B0rvInOKyy7PjlO82VmEj+uIpkbrFD0b45bl+FTlod3P4LE+0B2zkjxqQgqBqCN1uPbNCgo1qDjCylMc7FKM/76wcOaipmymANcvyNQQNzB7P5gewECCffsbLsE1faCEy0tWbwjJE8UR3AInFoav3G2csT84BJsgnMeDkaqRIMSOWudS8w1yFbHF2iN7J+BejgEanjsZ5WjUbGmajUiPS16iAu03uktc4dMCCJo6tHfDO49ch4GpEuy0LWnzNaBltlwSeUepSCp4z5BwaKgLQ8R30XD1OizK2PPhpUshNkb1GFbjR1RnycRy4UVIa5AQBRCHqwC+nANIeOZOHIWF7Wr2GtnIPydq+CfL+yXcrnECAwV72unhFpgny64qVjQtZHI2qZAH1Ye3vH858RQSIXjRNtZef3nqMoE9nYgQA2d78sqZFSI4f805GMhklcxu1LyYt2v
 YaYIGAjs
 AGuY+Lh2xFWT2LQ3LnLmE3PBwHfEwzGQidFGoMxTHg86ryCyrldWHZIFJOGkb+w0f6yTWYmMnmgtPdSqpM0UbQZNLBIXMk9EDs/keqgo79GmsR2HsWz6fC5ouk//29GDMy3Q6tDYjhjfTiUgy/c8H33bse8rrsWVzsLCXEYYawouyjZsi036oM3Wlut8FHf0aw6ZJxQ7IYjAr5/u7j+zkBSycSmgqabmbQ/2BVZaXJYJAQdJEWLuQPq3ExEKmRfK0uH7rtlK4uYREhL1Irw0b/9QR7uxEuUDOU25Ez68/Z8BBZ+Zk9Rgf2/5hp8ea7CD+yaciFIMi7vlLKd9FiVu42U26dEtj6I4GBwoRDQKFCwP9izBvNs+BSSmBKh4fna3sF1fxy+q6NY+8pIpCIdbIMyNl96vo8+l+SGrGbojOVwsJMTkeVcxOMURkmR7lKpg09XK5pTxfBcmUjRsa8LZ6iSqOewLDW2D6mPuvI6HmqPSHpPpO3FRj6ORPLimESQIkASZmd7+aZItWUJmTU1mkPbXArrJgB30iWG/e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/17/26 11:43 AM, Andreas Hindborg wrote:
> "Peter Zijlstra" <peterz@infradead.org> writes:
> 
>> On Tue, Feb 17, 2026 at 02:56:40PM +0100, Andreas Hindborg wrote:
>>
>>> I'm processing disk IO in the Rust null block driver. The pages backing
>>> the IO requests may be simultaneously mapped to user space, so there is
>>> no way to guarantee that there is no concurrent memory operation to/from
>>> the memory area. User space programs can do whatever.
>>>
>>> I don't have any control flow depending on the data I copy. I just store
>>> it somewhere and return it if a read IO for the same sector arrive.
>>
>> Right, so IIRC the old DIO code used to have this problem. We'd end up
>> writing whatever random state to disk if you did DIO of an mmap().
>>
>> And if IIRC the current state of things is better in that we ensure the
>> mapping becomes RO and we have writes fault and wait until the writeback
>> is complete, ensuring things are somewhat more consistent.
>>
>> But you'd better ask Jens or someone that has looked at the various IO
>> paths in the past 10 years or so :-)
> 
> Oh, this is a really important detail that I did not find while trying
> to follow the code path from user space.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> 
> @Jens is this so, are pages from user space that are part of a write
> request mapped RO during the IO operation?

No, there's no such thing. It'd make O_DIRECT writes much slower.

Also see the recent stable pages merge that went into upstream this
merge window:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4adc13ed7c281c16152a700e47b65d17de07321a

which only really deals with the checksumming problem, but regardless
it's in the same area of "userspace modifies page(s) while IO is
in-flight". If you don't do checksums, and you rely on bufferA ending up
on stable storage while having it in-flight and also modifying bufferA
simultaneously from your application, you get to keep both broken pieces

-- 
Jens Axboe

