Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A45DC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 18:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0526B0089; Mon, 28 Jul 2025 14:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C972A6B008C; Mon, 28 Jul 2025 14:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACD86B0092; Mon, 28 Jul 2025 14:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB5526B0089
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:48:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F03180398
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:48:14 +0000 (UTC)
X-FDA: 83714558508.27.2D4CAEB
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4D0F940012
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:48:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JjGEQEJf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=asml.silence@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753728492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPtqArRqu6RKIpD2evhkTp5wjAyR3mIuxIPwkqRJjJg=;
	b=CvtN7NkxPvS4lh82kkgx3CuG2fefS/0uN/LsvCCmhN+eeF7wMREHDQC/T254m/B0YmOV6B
	Qp5mcWk9F2VB5AQoLX3OZ3cA3Dofl7h4HDEiM1NYJPWFH21Djp5OaNtSYMR9H07aBwW+eP
	PFxYfZb7mtcZwbas8988IfxHX8eVvvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753728492; a=rsa-sha256;
	cv=none;
	b=JUU7eLM+tdwMtk+owvvO9P51q7WBiiViyqwI93zPXje2cnBBj14uhZIjnbA8QjfMBb+fGA
	KaG5tQt6I3yGXNW5Dfo9gIfZYA1/BA9F8cBv1QAE2NDqhhe34I4rPtru4Lem5u1Uniz5sZ
	XgHTzy89ustilBUlfqDZxSXa+/dhA60=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JjGEQEJf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=asml.silence@gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ae0bde4d5c9so933531066b.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753728491; x=1754333291; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KPtqArRqu6RKIpD2evhkTp5wjAyR3mIuxIPwkqRJjJg=;
        b=JjGEQEJf9UMUY2tjVq27ZpjxG/GSF2emBL+0Www6DUTQxZdoRYigNqJ8bNE/N11cvA
         WGPJubz1nsSjsAf4t3ef00MiJLdohcm7OSb9UWznDW2xz2XMSj5XZjTaKB2x+0RL2ZCf
         cuM81CsOccaEusLzwtz35O0WCTsnYDF99skPBWdQlI3FBzwKKlPCzizzNeXUTGNoXavU
         vLsWmcxWFHFlWsCu3gv0YD2ZKw+NyL0DSDGgCDAeJbkkGRkUeL6ue6But0dK/xanTTq3
         WzJv71KW50K33Y0CH67CoqRVr6Eeu5xL0yEs4PXYBcsRJn2XT5ZDaehbQiUa7muH0f2Q
         3Khw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753728491; x=1754333291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KPtqArRqu6RKIpD2evhkTp5wjAyR3mIuxIPwkqRJjJg=;
        b=KWOhd4+apI8eidCyEMmoR53nPdmaiD91/XKJe3RRi1Mr+nkfEeDkRx4YmcWFLK/DrR
         HiRwOSu9XiejMMOdwCdJcK/vMmFMQibKQZf5X2Gi/wTZbxvv0yfqedffaz4BMyTvyCbT
         Pz7I8RtO+zjGulN025iDNO6qyc2w/ndc032rTHOwR2osFGcWZyWS4fdaysP9wbt2nOOR
         skFdpFDtguX+UhdHtsBI3gHylp51CWWMwGUaBU8wwfdDlQvhyEBxEdVaLQXMXPkazSAv
         KOYHZHbZ8lKetBbD6H0mDP+XputGK2dNDqwhbpb/5ayNFuSbXLur+ObHP9Hnf7tJiIt8
         wyOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzZgk8hupSbTR/LP/inlk8fK1qHhWS44+ceErjHHL8xobGQHn/jV+MrRzkhUWrXvNh2+eS9uNOEg==@kvack.org
X-Gm-Message-State: AOJu0Yy+ZoEkIgfTsn6ZoI6rdP1isqd5YDr8xc7ltxAnIBwV+EFcjChx
	hFWrczz2wFvbA4LtztGgOquCVzD9tjPKEKfhNes5+Se2YP5TzmM4PsOj
X-Gm-Gg: ASbGncvPtlm69/WiskUlw6wmgMVr/qhRtSHrVvDtme6hziXRL4Ht1+SD5I2+WyLGdVW
	vbe8Qt60X1M3fXFTHFBrLx5EOEUHgnjtZbkRZ66b4MowHU6W6qPNQXevCxr1RoHK+uIdAJUPD/g
	gkZoS4ol85YElBHsXOo+FJH8eTeCTNvBttROvPbABewXVglTcEYpD9CRZBGM+msWncXduZczaCZ
	s8oHcHRsljaFvj+6X5xir45DcvqHTbtpVmEhfsYziHql/wDVTp/xB4JNyzvgoasUx8s31dPo/a0
	q7MFoBYhj9mKmIurDSg5sD6QgGSd5LdvKwuW1I95I/plOMkQS6nTSU1dn2U8GvzYRgwKdETwhyd
	QnFwOotC9Fi4xjrlTu1/lkmjylpDoH5w=
X-Google-Smtp-Source: AGHT+IGzAV+yc6Tr08lhtVqfYb5YTgQLPzE5kcZfo5vFpSIrj8JxMfbWLpoJFl0I+K+SgA12E6PiOQ==
X-Received: by 2002:a17:907:d2a:b0:ae3:e378:159e with SMTP id a640c23a62f3a-af617d0afbbmr1521651666b.26.1753728490438;
        Mon, 28 Jul 2025 11:48:10 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.164])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af635aa33f9sm460220966b.98.2025.07.28.11.48.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 11:48:09 -0700 (PDT)
Message-ID: <da4a9efd-64b3-4dc5-a613-b73e17f160d6@gmail.com>
Date: Mon, 28 Jul 2025 19:49:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page pool
 in page type
To: Mina Almasry <almasrymina@google.com>
Cc: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
 daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com, toke@redhat.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20250728052742.81294-1-byungchul@sk.com>
 <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
 <CAHS8izO6t0euQcNyhxXKPbrV7BZ1MfuMjrQiqKr-Y68t5XCGaA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izO6t0euQcNyhxXKPbrV7BZ1MfuMjrQiqKr-Y68t5XCGaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6ajbnaeqhb6hn1bfc4doby4deqajc55w
X-Rspamd-Queue-Id: 4D0F940012
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753728492-982090
X-HE-Meta: U2FsdGVkX18HYt3sM0X52DvGmRF6l3nMkA5ElCibIKOrsRb7d24xO2WWQDJJPmRoX1P/UdYybnLKm7GNj2SBbgKpcsoxeg1inCaKYdTsAKnWaL1I6rYRegVn/XeIbJvlmk4CcluROLCOwOtKmUYyETGB/A4TNk6yRe94+IEVJg/WgCsku43+Jc+5tMVaA4IcLepvz2KnkRx+QIgrgq2brV3Uwu6QfRcVEKJ4dzkNiPwelhJ2M/3fcZ9MAkf3Cap38b97A32sH6CuVsiNB8owxB/5MbF5M4ZmIP+Ka+R9mgMP2o1pKmXPi859kDVgVeF5G62IF72PddTq1uHMi7HoEZLU6HCf0UdCWt6Wx1SZwGIoVC2cqmmXKY0EIjZxclhdITYHgCbbPF+3TQprL0GkfPQr16WvDMWl5le6q2C5pifNGYR4fwkdFSyL5GFlWXRG/7SjQpsxSgSdEodigsmAu5lbX7013AMCxwxO5LmMpe9PIsMxmA61j267RoNH+yqqUY0Hf2nlfldAigkdGqZoC8a7nDtgoXhbez8WA+IXsuyV/n/58bQ6UMg0pk4ZtoYt0a1FGpIHyaCf/0f+2yW3HEViVWHZbxvQOxYc2QW9bAkbDlC36fg/bW+bkQdZUbp5D0UMXJz/l46mMFwwGdT1MLITExJXbi+Ibg8J41i7ibSU6lt4x9RvjiKzaseqpgQ0bN32FqqMBDiKX5E3HOaQc6onjh2vVHgZelVZ6UuZPr1yepOFfNK4cPpL6PrrDmzk7b2bxC1I6x9KtbxYA2a/eEerf5X7X0E25T/Vq7l+r/M1xSJ3DS0RBVs2y2iEa3qkl+Sg4t0iM8SFz4eHrFdG94zDrDXaGHvs6NxQ2t9SUTrh7VHNGT08eXszU9X+hGG08NdbFVdJ3/LJrfEfABJr4CuY5NSApNzZ2RpadRfOz9XbRrfMTQy/Yw73TipMbnFWZHFefI0iAoWqBy46nLD
 BFjgjup1
 DPmBULcOA7UjXrx8mqWKHyPr4iwnXXLEgCrITsTaEf3lM9djtyWfs5MfCbWGAMr2y1APWk7n4p/eRYNRkCP/7LX2YXW1FWOEvREnRxydVJ7aQiesVcKjY9I0MMNEK5JIEYRFWi5gN0J+EZ7SRis3AnTRST2DhaskGBmEpyjNwFQhTQ+0aPvWW0/2tTZcUuYfAi4PWznojQsM2Y1XQwNjZnhnTyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/25 19:39, Mina Almasry wrote:
> On Mon, Jul 28, 2025 at 11:35 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 7/28/25 06:27, Byungchul Park wrote:
>>> Changes from v1:
>>>        1. Rebase on linux-next.
>>
>> net-next is closed, looks like until August 11.
>>
>>>        2. Initialize net_iov->pp = NULL when allocating net_iov in
>>>           net_devmem_bind_dmabuf() and io_zcrx_create_area().
>>>        3. Use ->pp for net_iov to identify if it's pp rather than
>>>           always consider net_iov as pp.
>>>        4. Add Suggested-by: David Hildenbrand <david@redhat.com>.
>>
>> Oops, looks you killed my suggested-by tag now. Since it's still
>> pretty much my diff spliced with David's suggestions, maybe
>> Co-developed-by sounds more appropriate. Even more so goes for
>> the second patch getting rid of __netmem_clear_lsb().
>>
>> Looks fine, just one comment below.
>>
>> ...> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>>> index 100b75ab1e64..34634552cf74 100644
>>> --- a/io_uring/zcrx.c
>>> +++ b/io_uring/zcrx.c
>>> @@ -444,6 +444,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
>>>                area->freelist[i] = i;
>>>                atomic_set(&area->user_refs[i], 0);
>>>                niov->type = NET_IOV_IOURING;
>>> +             niov->pp = NULL;
>>
>> It's zero initialised, you don't need it.
>>
> 
> This may be my bad since I said we should check if it's 0 initialized.
> 
> It looks like on the devmem side as well we kvmalloc_array the niovs,
> and if I'm checking through the helpers right, kvmalloc_array does
> 0-initialize indeed.

I wouldn't rely on that, it's just for zcrx I do:

kvmalloc_array(...,  GFP_KERNEL | __GFP_ZERO);

-- 
Pavel Begunkov


