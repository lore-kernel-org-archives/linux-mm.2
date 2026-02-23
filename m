Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EBCEEC2AE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 23:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8786B0005; Mon, 23 Feb 2026 18:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865FF6B0089; Mon, 23 Feb 2026 18:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71DD26B008A; Mon, 23 Feb 2026 18:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0E86B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:42:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BE58140344
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:42:29 +0000 (UTC)
X-FDA: 84477348018.19.33D89F2
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 944D4C0007
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:42:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IXv8T62I;
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771890147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1G7Co3UGLp29oZTzIMMy89dawTZvG8ZKLFe9M3O6sY=;
	b=yr6Vt4Jn6xZmRS44ZJVo3yHsczxpmY83OawhE/tK0cindMwUI0pNQzIHn0kegVZlaBvyPG
	ERIOFu1Q/GHeIFG78mpvjKPTO4mMK2LxPQNjNl3GgdkLTpesUibO8/2X5xko3wKqN2Fymr
	eezeoD7+Ysg3pTLMIqbbBgpZWPz62uQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771890147; a=rsa-sha256;
	cv=pass;
	b=0O4E3PfElxbHFF4UoGjG33z9ukEey8D08XOFfHpdkmNwzbwh1SmXLEFOV204LmJimPJhAa
	ZmSLrvKinYTiiGw0c0YGGCBub/Raryf/mdU5Rp/O57AUHpo+eGhxUY0vYvWF2afURDaUYC
	ZjJdORKMk+EyhEfN48G31EhIbrb2wq0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IXv8T62I;
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5688c221fd3so2134189e0c.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:42:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771890146; cv=none;
        d=google.com; s=arc-20240605;
        b=VjK6t8ydhDFezF7ZpfuS9Vl2fBxDKtbACiTfnEW+r8V5EghOuJTh3PtZ/vhJue4HMc
         oLewwa2Xg2xlWU4S12zd1MxeHSB7/gwPSlx6rCHGTttRALD37JSkTrA/pqCTN7zw8b2s
         C75x2wb88SIjMzjWcycAAtOVCxxp0EDDjWX9A9JD84kYjK7IzAu0CxHH0Tdlb1bS8S3x
         JYEO2D3XbqO6B9g+2lgjHdElyu+3zyJ+m5lJ6PRxguBDV58H5F3obiPMT9tXTYzKGVCt
         kBx+D0ucKDGgNWSOO9ZgFEJqXhuKqlmIe8J9T9pf+S+6NgVCu4pqRJwZB8+8VWqkBuHI
         pYWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=G1G7Co3UGLp29oZTzIMMy89dawTZvG8ZKLFe9M3O6sY=;
        fh=30S5uRSsyT3y1vBFjd/6a57gK4hcADppYi7nI+yb0Tc=;
        b=eSkiPhrQHGEA/kDMvfQQVEivXDZZEm2oAGsAEWFvHOApcV1WghyCpPWZsHbh1gxlk2
         kiqkzUyPheUUlVcOZRi95gQw175Vg6hFyUwhuz95jG67UqjFjjSKWpJW1EiErXR99Hju
         S2MQLY7zDMs03blvELOWTwTBzaffoJwG1F/cudpUzLbckgFWmIkZzW7gW95Wyg2P1068
         +l07tGSgJlxsz6b1GOweqSVW6JVUrdr/sRAc7VpOW8foQyjBTu2dXv/vhZl5L0AcB+eF
         UAN7r4DZxFXvVCaqhyksu46g7eI5HINrkJhOlyzOwV/EQqDPJ7pUB590uPVXrg+7krlz
         P5Gg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771890146; x=1772494946; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=G1G7Co3UGLp29oZTzIMMy89dawTZvG8ZKLFe9M3O6sY=;
        b=IXv8T62IXDfLNErHyM1Ig5mNTpsg8BvV2JbCIiZ1mGc7JABg1b31XRDEsPpVNOtqRS
         snFZSRuE4w72w4USKpCMCu2TMtLsUEMX7imlcvKkZXDaJcx1L4frfAgsGIXgOT//StRQ
         U+V1018yzLa9ipS5Vpbd60QjoihMNKcNpaNWq3SFNloeZJg7lBWVXM5ezbfU1djIWXG9
         wnM4T59UjYND99Kf3EVk2Zf7zfgtooVYtlT0Mo1/YS5OkgpC4wO0vvDTdXNM8JmSY13v
         EFQxhbGG6SAunz0KuqW1upmcNw6+XcdkV3jl5TUzPKJ19nSkZ1JcyDrhAoE+0v3qjBoh
         4clg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771890146; x=1772494946;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G1G7Co3UGLp29oZTzIMMy89dawTZvG8ZKLFe9M3O6sY=;
        b=P6KtXo57R9gSqGQlnfbjfvS5Xx8yMzm2JIk+/jag+iWLmweQr91a8cTq67l1L1h7Mv
         r5niaLG3C6uUeS1CAQ8iwjKAB6p83qmqyeA0sU5TXlaiOo7FDNvtHT4TJPUbomNehhNt
         fc8fF9GYGfVNel+RvQdMgoRZ6GgsVlu+9QjwgkfYnFHVJG7NgUWqv7GhnE2KZ4wbRt0i
         kphXbHgiMUFou1cCmE1f8FoougpxpEvih6EvhvD9HI3wgTrpg/x9crQIo38wSHjE0xgo
         NDc4lFCx9NysCNhVND7Su9pdh8VAZoMcJTY6ExREkUZLeCNDv/d8z3/PY3G/aZsfldfT
         UWQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXACi1isZAdFH4mfrpeYvQOmbhvSbW3TpkTVFrSC1dGPgE6WQ1imcxCYeSxDzeIuuiOFQG2kMsTA==@kvack.org
X-Gm-Message-State: AOJu0Yzwj8HNMAwS+ul4ON0QZp2Jovt47oOF6KN6CCu847qbNFyFaDor
	co/RrhlY8XGEZmtPqjSCX1zLLCKAlhFW540Cg0gQhA4DwIHMpECBAXPl82XOt8JvxYOxrJoEKZE
	Mcyh1tBZSY7sSH+01TpDz/pttqpYRBqI/oUcDnMI3
X-Gm-Gg: ATEYQzySqBEvrHrKqAAkCheW2j7aYzzUA3ZOLvwkuc8vXDXzXcY1m/1hJu8Wb0ZG+cf
	viUWqNKjA6U/6eQC0O0AHBvid6lniiEPtNrBJhnfZt5siJolo2qlxZJbBTC+bVrNQfa6Ow8Oq4E
	6VIRTOH97Z75VEDb5sk9NDx4OLn0dA2DKfBpH6bs0DHLP4WhJHL/fKezLoilMgpjykd5WSzFzX2
	+PaW4a/sqLVSJsC4N63b/WDZHgkaM7vcUx8fV1RFqbnqmVFE8NAE1II+aDvMVMxdhG9uqHc5f28
	MYMkTlx76YassZARWldgx09e/4yuats3vcB0nBQqlQ==
X-Received: by 2002:a05:6102:3053:b0:5f5:32e2:5ea2 with SMTP id
 ada2fe7eead31-5feb30fc3a8mr3035084137.37.1771890145956; Mon, 23 Feb 2026
 15:42:25 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Feb 2026 15:42:25 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Feb 2026 15:42:25 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
References: <cover.1771826352.git.ackerleytng@google.com> <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
MIME-Version: 1.0
Date: Mon, 23 Feb 2026 15:42:25 -0800
X-Gm-Features: AaiRm52aDnZI9CEbv5M2DeAz_Eaea7Sv4JJPWItwl1wMCqksqqJ4XC4LTodyGY8
Message-ID: <CAEvNRgFF0+g9pmp1yitX48ebK=fDpYKSOQDmRfOjzSHxM5UpeQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/10] guest_memfd: Track amount of memory
 allocated on inode
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	seanjc@google.com, shivankg@amd.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, rientjes@google.com, fvdl@google.com, 
	jthoughton@google.com, vannapurve@google.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: cibpqfdjd54miqyspnjpnscyawkhcgs3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 944D4C0007
X-HE-Tag: 1771890147-83040
X-HE-Meta: U2FsdGVkX18D7cTb8CrTTqmPczOOKqFeXb8pimtYOMQAThzc6qohG7NDVF2YDPw62b0Epuub0YmYo33NyXR7a2Xe1UbH6HsPunmWk4VWbq6M1LVZKgS1e89a6B/tTvbBsLy2t+3TWubO9TwvGfBTJWxLAcQfhCzuWGyUxdlF+LMKYgyhVDjA8L8HL8MdtldIvDssmGLToKoHTk/oFwAiCthAElTLTJkEBm4SzX1upjkPGeXBEljK3VBX9frBkn1JznRTKL2THYSbAX4pBzf3EkIpjxGk8t+tGxT15PZ5HCuhJ4D7oOP1xy7gviF4HyABIP+Z4kk4ZIQsjv+N8MKCYc44IJO0pXNBrWUAZ5Bsiz9wG97i93Ve9mpVM2Hhc4+K8xX2XCXS7C8moyjfTXV2x21bOAP4WrSLvDSi9j7rzmKYfvv5qpCIwaNCaXjkmYwnP33kbkanPpG5whovCqOvEei5hI3+LCzpu/cuKDf0xtzpJNMykZufaEMjPefeptO194jnL00rC6VcDp8wVShXLtsKRvFYlETaYrMJKWuGpUCjWYYpJN6f2ND6vmzMXveQGTRt1REtzFlus1q9mQsCyaJv8hHvmx8RSJGqKn7jliOXgTeT9VzxjGyAqIynGQr5dwUai0BZeGbKihAKwZzF9rRcbXp7nMWDXt3HzEYsB2aeAsm/S85OiEiyyqwVC97URyum8XTdkvlc/voBqxSEa8SViFtMpYgqLEyPgVwYZqZjXfI5QfRqitjKFw5N9azswPiQdF62fCP5N8hmve9tmDHR5T2WWdUs67OmTF+7X9WH4g6rGkUZGn9CClUGDHUqj+YFzIqhMh4Cz7NvkqZ/Bq2y3NQi2t3M1wwqtLDoN5dwWijTTK/y/ohvBa2oWyLO3KDDCqynkxX0XyvwgSEf84tkBXhHrLDAItabiHxL9LqW6zB9oGQE/VVQFerAmEbWNth1JE3wLUaJ/TmgWCv
 ZbprtqaA
 UrQFBJ4ZfrwGURbCnFWzVJYq8FrZlIk8pBuUxbtCul7Jl97RrxNRrjSVlk2E3dWmDlpx9PyICqi0X0GfKD01n04dcN86bfhAIPBanklormiMa6cPgywdfQccUUC1Ll7IyfxVS2CdSraeeuOa2F8wMjzIKI1dtFzyPeLhHYOxo1zw10ddjhtEsbhiK60Sd8KvFiTC2cmawpEb6yvIAqoMX0zfb97G9FAJxku7oQoyXf0oPn1MELVfy+H1g4pXRM6JJ89evsV848EPGGD+wdQbLWT49mHJiixaWzx5qC3+193WIhxhVi9u+bu4hgEV878n+8Mn3FyQ88G9abOEO6sjXll8ecFHD3HVmws4Z4Z/2l+KxhY2odOPjCUeLRGIRZYVZp7zGnFXvSDoluT4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 2/23/26 08:04, Ackerley Tng wrote:
>> Hi,
>>
>> Currently, guest_memfd doesn't update inode's i_blocks or i_bytes at
>> all. Hence, st_blocks in the struct populated by a userspace fstat()
>> call on a guest_memfd will always be 0. This patch series makes
>> guest_memfd track the amount of memory allocated on an inode, which
>> allows fstat() to accurately report that on requests from userspace.
>>
>> The inode's i_blocks and i_bytes fields are updated when the folio is
>> associated or disassociated from the guest_memfd inode, which are at
>> allocation and truncation times respectively.
>>
>> To update inode fields at truncation time, this series implements a
>> custom truncation function for guest_memfd. An alternative would be to
>> update truncate_inode_pages_range() to return the number of bytes
>> truncated or add/use some hook.
>>
>> Implementing a custom truncation function was chosen to provide
>> flexibility for handling truncations in future when guest_memfd
>> supports sources of pages other than the buddy allocator. This
>> approach of a custom truncation function also aligns with shmem, which
>> has a custom shmem_truncate_range().
>
> Just wondered how shmem does it: it's through
> dquot_alloc_block_nodirty() / dquot_free_block_nodirty().
>
> It's a shame we can't just use folio_free().

Yup, Hugh pointed out that struct address_space *mapping (and inode) may already
have been freed by the time .free_folio() is called [1].

[1] https://lore.kernel.org/all/7c2677e1-daf7-3b49-0a04-1efdf451379a@google.com/

> Could we maybe have a
> different callback (when the mapping is still guaranteed to be around)
> from where we could update i_blocks on the freeing path?

Do you mean that we should add a new callback to struct
address_space_operations?

.invalidate_folio semantically seems suitable. This is called from
truncate_cleanup_folio() and is conditioned on
folio_needs_release(). guest_memfd could make itself need release, but
IIUC that would cause a NULL pointer dereference in
filemap_release_folio() since try_to_free_buffers() -> drop_buffers()
will dereference folio->private.

From the name, .release_folio sounds eligible, but this is meant for
releasing data attached to a folio, not quite the same as updating inode
fields. This is also not called in the truncation path.

>
> --
> Cheers,
>
> David

