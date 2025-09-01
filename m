Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DAF5CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D111D8E004F; Mon,  1 Sep 2025 09:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC14C8E000C; Mon,  1 Sep 2025 09:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62248E004F; Mon,  1 Sep 2025 09:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0968E000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:25:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 409B55B9C4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:25:09 +0000 (UTC)
X-FDA: 83840752338.10.7635B3E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id C4C381C0012
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:25:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NHQOl1Zw;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756733106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tnXepClSCa4TtmpEoW4LNnvfPXJBpj0jhMGD19t2OsQ=;
	b=bTcmE6GuXR8TSOvgvpRQuYWM+jPtCLtCeeg5kFPPY6NFBBi5HM5Uq+ET3OJ6i4D7hBYyQ+
	rgkSgI+Cqf4/kxj/mCPFfqW4K/uYCl8sdyoNolv9oOtSjC40gjfQslHMg4TrosA8/MCuy+
	f/c3kQAGk52xcKD+tnwRElhBTpNFH4o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NHQOl1Zw;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756733106; a=rsa-sha256;
	cv=none;
	b=bgXJPzNHaHe15pV0e2XH++fAg9sCLW3MC5P/fOWQGTlYu9nGTrxBKTH3xb3l7yx+d3n1RY
	nm45pl9PkEWNDCQt4A2W4XSdhI3yzZLX8yqRrKVtv2gWhstbC9zZZ7z9AyVOqHliOAYdSp
	ngxuaSPJM7fFnauduq3h8RIJB+AR158=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756733106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tnXepClSCa4TtmpEoW4LNnvfPXJBpj0jhMGD19t2OsQ=;
	b=NHQOl1ZwFxLB8evLMxbJ90x+Zw1HjQgiZv7mxBxUj+IOOOrDHZowUmhyUeYniBUZZnt7wc
	ROmESOmX/zsY6dACNpvegw2Q00A4W73eoRBMi6zRcfEdxHaQvw54r0TcKidJlCFTxYiMTq
	7Xhh2t+JjgSJoHDg4OMfmT9ZZt36/IE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-roD49ZwdN5OY6J66jlS5OQ-1; Mon, 01 Sep 2025 09:25:02 -0400
X-MC-Unique: roD49ZwdN5OY6J66jlS5OQ-1
X-Mimecast-MFC-AGG-ID: roD49ZwdN5OY6J66jlS5OQ_1756733102
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b87bc6869so12350065e9.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756733102; x=1757337902;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tnXepClSCa4TtmpEoW4LNnvfPXJBpj0jhMGD19t2OsQ=;
        b=U2QVNQ0kNi5PYIX3ZaRzyOVDNlUOxOko2QzcSBpKOWtkpupptDeuV+S5aRLDTPfLyN
         4Jk3LXMu6JETz97IlH8Ja0xHnPEpvFYQ16z0mX+ejXU3bblxi2wtqybG3i7P/niNw9b+
         V/V+RLLg5MQJiNomYh0gupWTKFNYVwbMK3A81hRWqgXQSjPsNi8j/adXVZTfIIsGYsZM
         0f/zouyzSOMP8BtU69yaVv/vHBI7d43ikTxAi4ch9d3IqsofKsndljZV7/zz0G0Gv0OD
         nQRsmoXoTRz365QqO3m+xCVW8J/QyvOpgKz3XYmiq8j2iMnfvLR2OKjHrKJlgjkjQ4wK
         LXBg==
X-Gm-Message-State: AOJu0Ywexy3hgo+cS6QsnDGdy4BbYQLaoGvuZtxjGmAuGNyxmOXuXF21
	LGBm8g4N87mHHacRQwfTe/USaQWvSdh5ZLnETQaav628p5NICCRD0Vay6N8vZeVHM7B7QNDva/J
	B2A1EMUoShlV86HvqlPAqa2oNaBtGHDkvBjk4+zrYLylK+28JbtNW
X-Gm-Gg: ASbGncsFKGlR55KZ0k7gT3LB0WvYZA7379yuawZ8GCPtVFrAjA6VsyWzRN/p5coZy+X
	oHffbQ0JGuCAeJOV4P312NzJt+rEOjGA1mQD5vLoKS4d3ItS/iIG+7ddQaklUNvr2ydmBzTCuS1
	nvWwHDIXUT3bKWpb8ALEYOe/eyc8u4r+ZiY8haJyRiPwXCDZOcWqYw++DoFYiW13ZK7/nPHQwWt
	h5GxaxXpdIgmyp0mSbmFYD63Oeag+TqRxCykLUqSlDJ+fnrpAyxhqE1gZ1r5OlOiMPK5x2XTv/t
	VqHiZCFWM5B1oS+Mh8H+Bb1T4xdf5tDWJjL/VyGlAKRQWhuRePnGhjIUulhvmH1eJTa6n34DxAQ
	V1GW+pNRGdl4XF03d5rTGy3fgOHgZLQEgFomnOxphXtjtbtIZOhwcALYk5NhuDBlbGeM=
X-Received: by 2002:a05:600c:1c98:b0:45b:8cee:580a with SMTP id 5b1f17b1804b1-45b8cee5b84mr29479365e9.35.1756733101685;
        Mon, 01 Sep 2025 06:25:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFn4DAGKD4/hR6ptaEjNoxJNELsNDQWoqjaZ80cydfGU/2h/6IoyZcnqEvOz4BgFx0o138wIQ==
X-Received: by 2002:a05:600c:1c98:b0:45b:8cee:580a with SMTP id 5b1f17b1804b1-45b8cee5b84mr29478885e9.35.1756733101175;
        Mon, 01 Sep 2025 06:25:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6dc1sm239218725e9.1.2025.09.01.06.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:25:00 -0700 (PDT)
Message-ID: <94ec640b-76cd-478e-9ee7-ff8597d1fafc@redhat.com>
Date: Mon, 1 Sep 2025 15:24:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] copy_sighand: Handle architectures where
 sizeof(unsigned long) < sizeof(u64)
To: schuster.simon@siemens-energy.com, Dinh Nguyen <dinguyen@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com,
 selinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, stable@vger.kernel.org
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
 <20250901-nios2-implement-clone3-v2-1-53fcf5577d57@siemens-energy.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901-nios2-implement-clone3-v2-1-53fcf5577d57@siemens-energy.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LgHHeisHcQMyVGhfG20WoLLgwSNtPQdhRO3TQA8Zgbs_1756733102
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4C381C0012
X-Stat-Signature: 1ut1xcqrjcskns81uf6kyre9bhipxdwa
X-Rspam-User: 
X-HE-Tag: 1756733106-356931
X-HE-Meta: U2FsdGVkX18GpKll4GRK71xjU5P/aI3aoGWQMilVt1gxx6X3f4WVRXSE4GZCb2INkUlmjgIe+SqzNN2Ts7y/IMXcWjITO4k2pkrqhoGlLHfBOIE9JyW2ukgs+GlpPn4a/qVJEyTYclREaDOvWm2v3TNr6WGHlBJJionwgJyiD/iIKvfoABrV7pajUrY93qPt5szxSErOTIbSso69NJ1PNbOv/804SDJqMsOl6xlvEE1lZCDVKd9PItCh9intR80EAbzn4rbsD0gy+za9Jlf7JJBAOZ3TqP4dlQBarWuzOWb/zPFOatm8q1JauyrteCnZg2d9fhoY+ba9NRhiqTaOWSAIBqgw3C5bHDSzAL87IiNBOwr2aoaxNV+rhRhgf5NZcSgrKBy17CCE1RKCVl/xOsSovldpbypa2pOI7RaR8nNX1G7a9FixDugjyggzA1PtRb6902qT/5fW6jVz6umKUkaWCHIKdz3VNE4tCbUUUvkHbtLDwoeGMbJsfvt94ls8FycLqtlvTqGffMtO3WRftDik+1r2CbfEsoVHj2ee/LnXYRAdd0UxQQk2X3kp3I+N4urXjglO8e/THxIGwjg+E/wkBlV303xYApDBl4RazqcwPfxRqScKkJfe29g9c/ZbqXEhIn1u4aQXkzQz4GUhF+4wHJkFfqoOOTCQ1L9jKCVgs6uGQTUG4T0dFnlHOXbLdyk3/+Wq2C4LkIY9J/jIsTRXSbMZH+totGoxhJEwbwnvpiVwHfsLmzZCICPlHO5lK4ZfVHGtIHaMLrppprU7uW1bxMMjgzf5aCTcj8V8O9mRIcctazAtRSE9qGGksU0uCDp/xgB1+7EtDbTycv5ac6Fgtcc9QfgZDq+DJgEaFQDR/dYl9ogwg9rPz2tBOfgYhcDSXv/Ol/GR+zZOkrLlzY9FPmpWz5jfpx5GLeOcbkxRGulKDhn5AkaY/muRTUiRJntWtqExmQyCmzW8nw2
 KraQm1Ra
 iCvRsl5gCZwkaQ+I8ssVC7LcGaPwu6ZLzXgrkzy/A8MU7WrtFjR5fM1Jodn7rpH8TZvAVzZ7f6gsU6FAdNzhygwWDfZnpcj+97qoja2pTYyc+R5Of0RPnj+V3v4qIphOoV3JDGtiqbKuLVsuvkDAaDPHXdiNEk2V7pjpNELWnJoMSqdgMPtj9fiMFHBu3wXGlH8dmQ8HwMiVublvP9rY3G6Yi9ov6ieXPEaqbI+OSt6cU6sCCoArVN+DDE2Drs9kEN+ytLasQYZeWSPrFz1YvTwWq/FCxyorngQRFSm1mInnuqkVL9TLvgdY7gXEZSSO6Mea76MSt3pzFv42rbqizF0Hlde6bPd1yr1ylB6Cl37aFT0u/cxzaLEBpSfSC4xFdkseI772+7DgQ1dfhd26Wu3Jqlm3v2HUY819wA5qYaqgpKfpdXy7GLAoPYOCbhItbtyjN5hxlOZxkwnZW+D/attLEiBKGMt9dum4778UJ+88jsD7Um12OhHD30o0NrmoxFclvE5iWmh9i7oAQ2f/+9zapzJcTZooOTHsvKeDDkW01J8h/ohm0G58SBN68QIzw6GDTCOVzvdmuLVo2lBsPr2XOvbFmVgKP21aSKMzfdQwTmeOThX4yZV69DOcPtBIZwsr8L2d9EC/OBa2J9cc9Gyw6fYydyHrNiwNVbjIqmESD19O9deOUrAsdwjaQ2xp9VXgG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 15:09, Simon Schuster via B4 Relay wrote:
> From: Simon Schuster <schuster.simon@siemens-energy.com>
> 
> With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
> clone3") the effective bit width of clone_flags on all architectures was
> increased from 32-bit to 64-bit. However, the signature of the copy_*
> helper functions (e.g., copy_sighand) used by copy_process was not
> adapted.
> 
> As such, they truncate the flags on any 32-bit architectures that
> supports clone3 (arc, arm, csky, m68k, microblaze, mips32, openrisc,
> parisc32, powerpc32, riscv32, x86-32 and xtensa).
> 
> For copy_sighand with CLONE_CLEAR_SIGHAND being an actual u64
> constant, this triggers an observable bug in kernel selftest
> clone3_clear_sighand:
> 
>          if (clone_flags & CLONE_CLEAR_SIGHAND)
> 
> in function copy_sighand within fork.c will always fail given:
> 
>          unsigned long /* == uint32_t */ clone_flags
>          #define CLONE_CLEAR_SIGHAND 0x100000000ULL
> 
> This commit fixes the bug by always passing clone_flags to copy_sighand
> via their declared u64 type, invariant of architecture-dependent integer
> sizes.
> 
> Fixes: b612e5df4587 ("clone3: add CLONE_CLEAR_SIGHAND")
> Cc: stable@vger.kernel.org # linux-5.5+
> Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

(stripping To list)

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


