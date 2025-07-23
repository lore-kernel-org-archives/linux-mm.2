Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E413C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F73B6B0098; Wed, 23 Jul 2025 05:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7E36B009A; Wed, 23 Jul 2025 05:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD0C6B009C; Wed, 23 Jul 2025 05:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0A66B0098
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:57:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F1D0133776
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:57:11 +0000 (UTC)
X-FDA: 83695076262.28.5BA4851
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16D7518000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:57:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LqFGwRRs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753264629; a=rsa-sha256;
	cv=none;
	b=bdb/1kPOkrZ/jqMrExHpHDK0+uixHLKeFkspEeT49fQCZfufCpaVME7XCeGslNKh5kV2VI
	akTAsryTmnRs1EyiRkLoYtc74m57P6koMs3NB2urT38Z2sX0yZsFtmAzhHUggxyRICQ1np
	xKLM0h9UBfyilfBDThx6t/UZebUDilg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LqFGwRRs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753264629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSuQe5TZfFo2TDAjQDLuVsg6M8GZKLj4opJx5Te6VLQ=;
	b=1yKe5MbxGVtCAkKpwpN3iJyDPxQx9o+DZBwzjn5LoA6OBHORbSjAFAi5/8B0m7W3p3QoQN
	KtUo/jGjET8JELFHlaPm+6So5g6vDlmY7e0xUE6zSmLzrOzUd2z2we9fTxhv8by6OusKRp
	laoU8YbZgCA4aJ00RrdNIiTtntnvKro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753264628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mSuQe5TZfFo2TDAjQDLuVsg6M8GZKLj4opJx5Te6VLQ=;
	b=LqFGwRRswXc6uPvnUMS/gkpjFKsdEOcocTR+AbqEP+Z13QkVnGLgeH+80WYfjuXVBupd6K
	NUpI0L/7iFK3S1WfxRp831n8E86EZ53BinYZni/tZIbNuEe4fequx6ck7JoyoaFr8Sx84Y
	XdzjngDLdf/ptA/USS5f9Mbu3EcySvo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-NPQOQFqkO5yoHPnkKFu8Yg-1; Wed, 23 Jul 2025 05:57:06 -0400
X-MC-Unique: NPQOQFqkO5yoHPnkKFu8Yg-1
X-Mimecast-MFC-AGG-ID: NPQOQFqkO5yoHPnkKFu8Yg_1753264626
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso42207115e9.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753264626; x=1753869426;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mSuQe5TZfFo2TDAjQDLuVsg6M8GZKLj4opJx5Te6VLQ=;
        b=r/aF4ha84LqMHxTrJeQkEu8QpYHq8cffxJgSP03yubhgqNCBMxrD3YrakeV6X3/tNf
         A+MIYelw+/Fuh7WIoTzn2q4E2U5P5p993nHNzfNJMVcEPR36EWVe4oXWBJGhZVbhVP57
         k4sGCHmBclOGrBIVQkOdnkAjiOpC01ER8pWkplfetmHKg6cLcST63nEetZEdurVYGz2t
         CozqozTR2MWye3ZQhIxymJpw3bBQOeKE0nbzkr2icDf7lupUI0/DsRKcDc57scIf7PXy
         bGivt0lfLeCvskqSkdq3ODyCyGcNK4Z8OCCIo4ItRAVz/6jbVM0qnPe8gcoW9R0a23HB
         FJWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtou9J1+x0MHjHwdTgmTOr9m1y1xVaqixhnDzi4qD0ppeJFHkVTFU6UlIYy0H2wLtv7hVxweL8vw==@kvack.org
X-Gm-Message-State: AOJu0YzOGeXIl1Pe7YdNJO49TrtkQKtdHGaFcpubSMEm+UGmGtzF7ApT
	eyXylnX3B1xyh3PInZaMRrmngf53fqReCE/tB3x6gF3H2aYQig4JOURJWwy7Dh22yxd7hOZPAMU
	zDedV5HoMbmu4CZK7hcbW94k2QTEJbPw92KhZo5rbbXJGKTLAl2Zx
X-Gm-Gg: ASbGncsoU3fR77Ohqw2LF1V50q5mwVDAR0tfpg3459KfIEIKTEe1/Ngb1Xx1yqZqIYM
	kpJ2oxrmCI+Qt7sxKtFSTSFTY742Qb1A3DimgrVXLiRTijaQbf7fag8gzLrrjlkBTazyuAZc8YW
	Q6eb6JcLx6AtzBYjqfJ3mQQMJF4M1rSUpUQmYG6z9OFIjBYgLDxt4dTb9+wG6Y3w2/8wTMKvHcs
	NgKrsjiEnVuuuvDI/un3aATRWg5dlsXgBabExRbs65AwdCYsIPC/iHX7h77roStIuQ4K1t76Cll
	GZiyc9kXXqk1HPJd20ZZUWnIC/RbBDOP7ezm528nqsARYClE8hR9gDQaWcr4nKUatwWEo871uJw
	RfL3kkjjuZEFFj2za6um8yO2LxPcQfQ+gV7PapR9unZkriPrkkuHbR9FIlaZ1RonFcVM=
X-Received: by 2002:a05:6000:2506:b0:3b4:9dfa:b7 with SMTP id ffacd0b85a97d-3b768ec1e6fmr2044934f8f.25.1753264625588;
        Wed, 23 Jul 2025 02:57:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGl73Vv5SZsEFpgMGgi837EdpzryiyNAai0v+xTUvEkF0zaqjrdbQ6xETFDhH2xtsYCmD/VEA==
X-Received: by 2002:a05:6000:2506:b0:3b4:9dfa:b7 with SMTP id ffacd0b85a97d-3b768ec1e6fmr2044895f8f.25.1753264625096;
        Wed, 23 Jul 2025 02:57:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458691aafadsm18545845e9.24.2025.07.23.02.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 02:57:04 -0700 (PDT)
Message-ID: <1524727f-aa6d-4286-8ef4-bcd224c50c62@redhat.com>
Date: Wed, 23 Jul 2025 11:57:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] tools/testing/selftests: Fix spelling mistake
 "unnmap" -> "unmap"
To: Colin Ian King <colin.i.king@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250723095027.3999094-1-colin.i.king@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250723095027.3999094-1-colin.i.king@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SL-bZF574hPBn40pfxjF8CnG08TsW_5igjRX6RG_Vrs_1753264626
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 36z9uzeeqd4zz6wci5q7coqjucgwg849
X-Rspam-User: 
X-Rspamd-Queue-Id: 16D7518000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1753264628-485296
X-HE-Meta: U2FsdGVkX1+YLjC4vqqyzeGmD2VrN3GUhq2FAKu4/hB/BXi6uuA458awLD/nEbJNiDXMGFI12t4r2o+UO8NOwszkTIVY0fi0Ah2FYnHQ5jjnzNWJiV+ce8unFtKj8hqUD3jv1Vg1l5X3MmyDpPSga6VMH8jwaTo4OdavwgA+QE8lOrN/4AdtfmM+kXktAx2cHgK9+wS8B0bhmtg4dNl//NshNalqomDAsva1GkZZCiTVjCGXOilOVDqY7snYXukzTajh32NE1j5vr81ouwa7zRLWtjwGSIlpxyO2qDHgq0O0Jd+gPYruG+OC3WdCCgpCVRIu28MeZxQyYkiqJh20rLOurww/0sglNu5Hl/Y+KV3udZomHEg7ZjHE+is3i6PEE9x8TJAM6YrET3L2i1EB816kKrQLxdf8y2iR1WmP6doVS25HuWCsyI4XqjQYX69rxgQujYWern9QbarAICquNkLDHbntPjmNKmjKr6rZettMGcYDH1WdCZ9onx51dL/03eM+OnwakgpXqzDjOn3QHCcPFYy2kvvQM3g9jabbzJLC86j5zEN36hbzKcGVLmyWZr0wgi4x9OraetdZ4+ZwqkmCZIFSoQ5vvK9dOn06Utk+ZcFw3FLTN7ckqy/v1q8Cmd4wCl/btOySbaf+WKxQztOvECNMNBuGtyUb1LsTAOCyymmU+ou+Xm7DvzITsJrarvnZlDflK0E3q2em+i9S7N4yWqkajfPlQPw+CLBsHwhWbIHLHud84YlYHuhdl7IEQVeE2uARbzwhs6T81wfUTkJhZUJOrJ0345Yvgpl7XnA4LCJKVf4p1Dwua1MVNWYqMIoy1iPdIa687DVSpSNwc5KgsdD2At8uoM6YwW4Dp7LN/rTsvRHieFjMitvBvCCa9ESDTsIw/dZ+S5M574lUtfzGz8CSJxi6p1YS4/pcntiwxYpee9gUSTv3PWg09TzAUC+Gy+oIWf4dL1kEA2T
 pTPdXfs/
 NlsexyP3yHR4ou2fckr6N613eZDyYaQ9/2Zrw+A7hCZ50Xq27Hd2h9ltRTO12dkOf75h56+KnUH6pnS4sPWAJj4FdQUGbeP29ZLNsmpx2CaxhWNMQC69WUh0zjFRTb+5953SPoNqT3y8ov9em0LNWZmK6T/uN8ZEz2PFWKn3dqNPsbOAY/nS4lFzxuSuDQ5dG38WdsKyRtiAuN9HON/LcYENYC7YZ4vJASgJrJrRFKML34HBhsyfKGdqdQmvQASo7SjpHEw5amAeisCmhOcOVXjPFDSqCK9brUZLty5lB5BqCbnkCcLU9Lw+WoH3lLHO2AUbldNSycMQ4XwnCo2z8pc05eKMQUUe6awViasOye9sVg9WcHws2WZnMIFqC7K/irgMb/FtERvuLwu9XXADhhMwWF+FXqonm2rx4e9E9cRK/d00gzsiwYRHApugL0OfGHG3j2F8t5ViekqaTIDmBzG0AnS6AZIJXY2PhueUDfGsN7/6WOG7GBpy++Lf+kSbNX9wVAEKbvvdWvCBJm8ZVj7F6WLfWH9K+lKgkg4kwF4z9omm5B5ZrMtyl/WAk4fMnwQz5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 11:50, Colin Ian King wrote:
> There is a spelling mistake in ksft_test_result_fail messages. Fix them.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


