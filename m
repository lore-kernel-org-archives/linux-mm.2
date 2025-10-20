Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DDFBCCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 19:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8D88E0009; Mon, 20 Oct 2025 15:00:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8908C8E0002; Mon, 20 Oct 2025 15:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6C28E0009; Mon, 20 Oct 2025 15:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE1A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:00:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2ECF3C029F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:00:58 +0000 (UTC)
X-FDA: 84019409796.26.90AC872
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A673100022
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:00:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bwlToA3Y;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760986855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wAdwIsaV2mxz61hLX4vusJU8KfwA6OJx8U1ryQWw3U=;
	b=b3HJ5z0zQzvwNPqOxM2wXBSQBcr/1akbExKsEocKhmDNjxx0NXx9ubY6nksS6gR4GP6UXE
	zWCuyR4o3dqu8l9KYY0MIUB4s+LlfRb+b72BxdFbGXisN27tQUKl4gm6k186oOVsg+d/gW
	jqPmpcbf4F1nOP2D+a5B9+5E6XRsM/c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bwlToA3Y;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760986855; a=rsa-sha256;
	cv=none;
	b=myoYsDA24IU2fY9T+N2p4g2vOzyrzAt0mloqzu9Zs5fD7smGGCs4FK0d6LuFfPCMrrpHOY
	8R4vgf3kutu8tsna3BhVHSAh4YwRhRt4KhnmoDFSIIjXB+4odLsiVcDP/XzCiOEWyJaBQ6
	4l5Oiy1zI88V/+e+Grt4lupXgkM7CCc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760986855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5wAdwIsaV2mxz61hLX4vusJU8KfwA6OJx8U1ryQWw3U=;
	b=bwlToA3Yk7Y979RP19AeqesavZsO3x6kb6QCVM3I3xI1PZ6eKvzB0X/lthOBNlfXpGPFuD
	NU/j7RbLTELfO2JF7BgVB8F9mhHMj6NPK4Mk3Ze/aGMTj+zYEuQrh2t8F6Xre6M0dLnj1t
	N4SeOnodIeWj7Eeq4zYhMmrBm6uFeFw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-T8Kt7G8JPoi1OKltZXrYDw-1; Mon, 20 Oct 2025 15:00:53 -0400
X-MC-Unique: T8Kt7G8JPoi1OKltZXrYDw-1
X-Mimecast-MFC-AGG-ID: T8Kt7G8JPoi1OKltZXrYDw_1760986852
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47105bfcf15so25791395e9.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760986852; x=1761591652;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5wAdwIsaV2mxz61hLX4vusJU8KfwA6OJx8U1ryQWw3U=;
        b=FPjQvYhAB1lSHb9gneojQQ5xUvLXortRM845zZJQNDfyjxmlSDhSLURAlgrKgp817/
         ONYEw7+fu9yv7hlcNPpV5z5QTfuB0OEtF86NRKBfXyq9VsC4xY2akYCZKxmP0P0yCjLK
         K47x4zCsg4T7zUiy6UtVIzaBXjEc40563RvRer0UYbBP2AL46i1G3mpWarz3cW9bWTIl
         xTRGY8sFWv8qhXv0p+3D/x5a1jYWC1WFF58BUOXwDs+jK9qLMvfrWEBTzjIBZIVIOJyR
         xGRb/a2qDZ3C9OwuGQkDfIZN2zIDLpznaaHb/dr9W4tbrIm7Kw+gSClltl/FOnWx7Fv0
         GFbw==
X-Forwarded-Encrypted: i=1; AJvYcCVP+c+NKFwWOmrN0aSByIqb4Ozw7i+JgOEMPQu644r/cindf7DC5/6k1VGi9vY12TfYC4Fpv5OnWA==@kvack.org
X-Gm-Message-State: AOJu0YzqjqTiZQhDcWysyiefSh04/XRsBL820HomRIhM33ZVLi0UXrly
	fXkphMpyB6L0JoxLDBW+f220pTLdXy5j8YvUX8VW+059JIvBgr7m2VxRmvEaeVN9/rAQf0FjYd8
	oEURe9BSFUv5nr12jAAnW3hbGri004bHk+i+nDAqtjVe0dlR7i62G
X-Gm-Gg: ASbGncuJmDhDmnStSn9sEk9ungvqohxK/7IlPR33V26zhH+uFMkav0IKZjdI1qMXW7Y
	uh+mgN3hfLB+DDCsyffociPS43rfNMGclGEFtjXSx5WYK+pBIzWolmojZwFyi12xTN6lza0AY7X
	eRt25ZedsbqP/g7aGL6ZPz7jq/2JL8xw3f0bYtw1733mtqX4sHvmqFAFmJDXCMXZWiOXt5FKbn/
	GpOSlkirGgjiDdW9V+05eltiChozUf22UuE57Cr3P3z7DjQEknzXxV5g5eXnxvySTU0NgHIvGEP
	b5x+65uwI7hmJyDZYyRZykb+mwhWqq54O3PzjE3x5cvmePcdADPbDpOuGOReWueYowoWh61WyB6
	XcP5Pth3U2BWuL5hM2XeQj2DbptL8qL4DBoy9sqnnBeHQG+LNbZMlCjz3RKIhs1Q5GJ/hj4eekm
	+OJa3aOWq0GnQXwq6EmTfbnm4RbkQ=
X-Received: by 2002:a05:600c:524f:b0:46e:4c67:ff17 with SMTP id 5b1f17b1804b1-471178a6fa9mr95682385e9.14.1760986852329;
        Mon, 20 Oct 2025 12:00:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeBVtTe54kGHudQUvmPQThqNcAHiithbRT8ALDQPVgYD+ACEn42WaNaOAZe32RO2rz4EUwSQ==
X-Received: by 2002:a05:600c:524f:b0:46e:4c67:ff17 with SMTP id 5b1f17b1804b1-471178a6fa9mr95682195e9.14.1760986851909;
        Mon, 20 Oct 2025 12:00:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144d17cdsm241227075e9.18.2025.10.20.12.00.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 12:00:51 -0700 (PDT)
Message-ID: <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
Date: Mon, 20 Oct 2025 21:00:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Fp9MhuH1NG0EvLN_Rw9GIfk_X7e3ycyLuqgHNhmSa9s_1760986852
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9A673100022
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: re8mggu815b5p3ymkdty4k18wnm54rnh
X-HE-Tag: 1760986855-981106
X-HE-Meta: U2FsdGVkX1/gY/PicfWX0ld50HC1Yfqoq9A4PTin09M9T2zP0hsCBitQKDWiUNVs0LnkbbF70e7W0j4lRsBdvCwHquGHgW8HwJaI9Y9yDacp/Lc08NfAXtwLa1eeyHnEKX1EnnIASZY+nIY0U14DFFauvYabO/Acl9evN3TGs9BX9ZZ8o7E6Xqkpissfu3+8ZNXASR04B69QfTopQ4XnhxvAM9oZNjonf+D+eVz+3KY7PmrgnmSiUt4JhnKgp5tOddXMrxcHq1497xo0EU8RV3wtTfJITCxKb8G2IiXFg+ZrlT6A+vAxcHWRszEif6eoVpxV4VpFw+yQj1t9FYa1uLlFc24Um+nolkmje8csunWbs9TvXPDTaXq/mjHEKrA0dR/IfClrtESdkPx+ulBeco8BUj60FziBmmTOUH0uU1uD/qWPb2BK/kDWRop72Upi7uI+ZE6yhQLa1GJzAVsxtYcfad1uPC+TaY8L6/A3PFYwiv0rNAAavVF8wBojWk4noHQzx6bNH+uwUNwo664vxJuokl7kxjFXuRLlcgUHdmsN8QGiUJwffE0vIAN/gGk5G+mLjdZ43y6g2Xz+Vw+Q2OrQ8udaIRt1oZm8zKiy0qKnVlqZaHvRmw3U1zw14YmeLUHDFIwsRpWVhIeJmc9acN2bxG63VQ94BAFMBclb5X154+N90gj9ZyFAipS9nESahjR8RhJjQur1jMCpawWeFLzxyGyMHKHZ6ZnrWsdvRqPyJeHVWQgL/kpFqRRSZrP0shRq7hPEM1zh6+rdvW5ZC/dMEIqr936cDpwMDxEkY6KWUe117Su0CNdTFnWHeQX2lSyXJ3BSkahRCu+cSXqlXT7OoTWbVnHnDJSiQCULNnTUI37j21BfPsxiVsFsSz0FX1jwR2bMEw75dB1nLweq8iRzfl+7x8dfLiCJa07g6b/ycoKKQBp7HUGJeMxm7mgI9kvIk077DReyT+F+wLG
 QcoJBaUi
 rHg8nWhgBeBhJGi7trXIA4OSLtfNeQ9AXlk48Wi95a9RfyHYudUpCaRA6RaXktijLfopQSxweX4+4ff7NsJkKwlNz5oqdXEB4o1LevdRSS7NwtA1UaIuoAmN8kMXvaBz+uQtHkusYcmzv+9kkI6Ox33LwuWZciOpXrCTjeu8jMzubZoNiuLTH74X8JWUYyCod9Pb6RsNfM/FLj7b41Q0ApAAThx0cpVB5TZ/JTJiGp8jPrQg7z1g5frZKuD9IhMDuPd/ThxsiNOTIRdfvmKQ1Zllhxoyau7q/Pb66yK2xWsV/KC6+doVEw/6BfyGCEetxrBY1Nn+VcblxY9Ycxj6Ywg3BWv8zW9yumQGX2SA53r4KwK4w4Qmyqg3uE3ryrmyeE8piYPwLvkx4nkcufC4B+gfJncKnhU/pK09/JTuyGrQfeG8cNtzv2KptEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 17:58, Jan Kara wrote:
> On Mon 20-10-25 15:59:07, Matthew Wilcox wrote:
>> On Mon, Oct 20, 2025 at 03:59:33PM +0200, Jan Kara wrote:
>>> The idea was to bounce buffer the page we are writing back in case we spot
>>> a long-term pin we cannot just wait for - hence bouncing should be rare.
>>> But in this more general setting it is challenging to not bounce buffer for
>>> every IO (in which case you'd be basically at performance of RWF_DONTCACHE
>>> IO or perhaps worse so why bother?). Essentially if you hand out the real
>>> page underlying the buffer for the IO, all other attemps to do IO to that
>>> page have to block - bouncing is no longer an option because even with
>>> bouncing the second IO we could still corrupt data of the first IO once we
>>> copy to the final buffer. And if we'd block waiting for the first IO to
>>> complete, userspace could construct deadlock cycles - like racing IO to
>>> pages A, B with IO to pages B, A. So far I'm not sure about a sane way out
>>> of this...
>>
>> There isn't one.  We might have DMA-mapped this page earlier, and so a
>> device could write to it at any time.  Even if we remove PTE write
>> permissions ...
> 
> True but writes through DMA to the page are guarded by holding a page pin
> these days so we could in theory block getting another page pin or mapping
> the page writeably until the pin is released... if we can figure out a
> convincing story for dealing with long-term pins from RDMA and dealing with
> possible deadlocks created by this.

Just FYI, because it might be interesting in this context.

For anonymous memory we have this working by only writing the folio out 
if it is completely unmapped and there are no unexpected folio 
references/pins (see pageout()), and only allowing to write to such a 
folio ("reuse") if SWP_STABLE_WRITES is not set (see do_swap_page()).

So once we start writeback the folio has no writable page table mappings 
(unmapped) and no GUP pins. Consequently, when trying to write to it we 
can just fallback to creating a page copy without causing trouble with 
GUP pins.

-- 
Cheers

David / dhildenb


