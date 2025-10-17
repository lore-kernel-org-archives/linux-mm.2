Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA55CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 17:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3CDC8E0009; Fri, 17 Oct 2025 13:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED458E0006; Fri, 17 Oct 2025 13:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC458E0009; Fri, 17 Oct 2025 13:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B72838E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:30:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64C991A02BE
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:30:35 +0000 (UTC)
X-FDA: 84008295630.30.5BB523F
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 762B91C000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:30:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JJt97HZW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of wyihan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wyihan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760722233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIL1nDuSoId7w0AXQ//S+0eYpVMeQ8tIjQGoxQsFgN0=;
	b=OChwm2+4wprtNiz+0GVMdQUxGUup3iLPZcveOZcsB8f+svvXErxrZ4HvaqJpdNtZhUzXUH
	pOK46UIFwi/6N3dAPNBFlVgjang+JLpY0deXM3zNnXdIxVadjqt6PtO0xooV/uJHK2LM4E
	qKzyLqR8upU+yAXdTRYM9PilOjILx+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760722233; a=rsa-sha256;
	cv=none;
	b=IyFM/XRwD0MBTJRzbIxeRsnGfDjqozVcmOcsdSd/GQdcqZgwmlCFT9VzqEoqvzdoxO6WuH
	5ZvX/S/3WQIAzqXWXIUsJbMDbus0ykZZS44UUzkjEkUGA0BEAgWn8zqiyt4432oLpX14lL
	ip9E8DxuSd1TxZf3gRl2NLbnyI8790c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JJt97HZW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of wyihan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wyihan@google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-290da96b37fso11525ad.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760722232; x=1761327032; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uIL1nDuSoId7w0AXQ//S+0eYpVMeQ8tIjQGoxQsFgN0=;
        b=JJt97HZWEFQdHOt9j3DaGGKmWDcLbu3AXEEt6IlwMieZNpkZBXLgGpfaT9P8RXG7qP
         D2hOmvAY5eiBTq4AoTiRu95ClpC1+dagtElGWWF8RdPpbDvCaB+pGiilzjATsnvPdhDj
         u8A6Elyal46yW76qGGK5GhwdgiWeJ3VvlcOO8MrS51pM/Ukp+DdcPMWIb/nZWt469jYH
         6FKPJ7hlTZrec0Z/ezoba5z7E7UZInJj3Z3FWp19RUhCGAgeA8VB+XBZWz4bHqBEYU9+
         lHGDQI/wsIV9wY/n1Om7oE8/dM3J91XWzNTbOrbf9rVmmFbe77Yuxhpwh9fpOUF/ximo
         W+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760722232; x=1761327032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIL1nDuSoId7w0AXQ//S+0eYpVMeQ8tIjQGoxQsFgN0=;
        b=f/bvk6Jmstw9lGYY6Dmoh3q8J1h6bB9dP+U581XqrjbLrOCOg7kXuLks23LpJwIjBK
         2hl8is9g03BaFOi+ot0qyMUZN/lwFekyKcSawJybIaX9i6ysxNaG0CgZ6Axutm92DZvZ
         GKmGBKWf27ndZl1Kq+y8GZu2iuNH31/r63g9LSOLbFH4WVuF1yGDLKN9txPMbt5AuVem
         5pHADhteBkg90WbRqnpHo22DX52VMbsBQQvAF0BgACvBZBWgIj4xEBlhhDNgxqWou4hT
         jGqJDxqRsRbcl2EmXT32Qz1wOf4G/z/nSUQlKQDlX9uifSu8qKmoane5PM6teKr683AF
         qW6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXe3pPoHnaRdOUrSfxzRyuHiiBWe82+kerTieXp50sDi/+r0NLqkCRB4CEbhVzLdIJAMfnqE9uyBA==@kvack.org
X-Gm-Message-State: AOJu0YwthnU9fsoUozX7ZNbgAFlSrgXLkCeuTerEQAxsFsGrd/39hC5G
	BgiQKh+LZ4KMw8TpQ4T8k3I74A0Q11Y8J/cP6VxJF6LarEQWtcLGb9mFDF3tuirpeA==
X-Gm-Gg: ASbGnctNFtOALN76G1dfyDDGhxwwR1/Cl1690W0hq5dYHaBhhxMGIO+bmorYNFS8UpP
	V4DNk+VB7wxArzaht0U9N4cMi+EOVjyF874d2bUk/2fp4DFBJ0K9oRLSx5AgooWgmH6B5EvGuFA
	MMtNfaVQPbdeDwEUkBjEeeYK2MbOilx8A5XoTtJ4bSPk9kat9vVXC+5wHhOPJcirrxvs1Vqs23E
	kx3M1bAsiZNo/81/kMfmxAYYe87+EINnLMcYWYWzxcH9U346ZNyuJ91OektFH6aGJF75XFrLlii
	mVvsOukcltN+7bfFtaQJOeHFnGpnlhsNJUF2WejCwRrwB3UF739GtFvOYKMJkfxOKRGr8pFI/E0
	dSsyiWAIMxESpbN4+KLCkLUfCvu8TIHhEnUxySrT8fZlK1D00oTEAzryil2BljE00C6PCI32wMc
	5wISxZNJmvU0rtzr39LWyV8hrg/C8PntFDIjaMbYBWQz7DkPp/Vps=
X-Google-Smtp-Source: AGHT+IGSSk8fOYVNSVQWtRUBikGimjzWO1KLbKPMeaLMcileoYpa6q2TxT4nfsTijlIdFMktb4xiiQ==
X-Received: by 2002:a17:902:d50e:b0:290:8ecf:e9f9 with SMTP id d9443c01a7336-2908ecfeb9amr13500235ad.7.1760722231581;
        Fri, 17 Oct 2025 10:30:31 -0700 (PDT)
Received: from google.com (115.112.199.104.bc.googleusercontent.com. [104.199.112.115])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246fd7e61sm891605ad.35.2025.10.17.10.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 10:30:31 -0700 (PDT)
Date: Fri, 17 Oct 2025 17:30:27 +0000
From: Lisa Wang <wyihan@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
	tabba@google.com, dave.hansen@linux.intel.com
Subject: Re: [RFC PATCH RESEND 1/3] mm: memory_failure: Fix MF_DELAYED
 handling on truncation during failure
Message-ID: <aPJ9M25uaKsVC1U9@google.com>
References: <cover.1760551864.git.wyihan@google.com>
 <57ed0bcbcfcec6fda89d60727467d7bd621c95ab.1760551864.git.wyihan@google.com>
 <91dbea57-d5b0-49b7-8920-3a2d252c46b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91dbea57-d5b0-49b7-8920-3a2d252c46b0@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 762B91C000D
X-Rspamd-Server: rspam02
X-Stat-Signature: m37xiqot5x5w79fn1jhcq6jxdk95jr6h
X-HE-Tag: 1760722233-373002
X-HE-Meta: U2FsdGVkX18M72dmcoH7F6SunuHHGP9nyyYxi4l9/ZUmvQHs5m6YjHZKEZKvF0vEafWbZvQaVo/yEEWXvPmtclZ/pTUt1/8cMKe++2A+jLu6DhmkDTo5cGwnVpg47LQrK8fRAeejBntrKBHB7pEvflSC3P+UWiKy1SfM50URee/QFGOIVL+RCeA06453w4t7rIQKkgZn7G8lTPA/i4ELM5ElmouUEwvaPS43e9570EhDoOyzjKYJ/TRSf4Jt9c852zkq4XebW97BqEVlA3TkSWengalztt2pSvZl8qa/XRfcgpNAeT3IqFc+wP6k007I/m5l5KFgFsW8I35tueqb2mAbjQSKU+bXxDXT4BxeH/0XXJPkcLK4YzZmrX16V6pBkHSFnH2onXBBomKm7vTkRsaOqtFpxGwsYDHEqaOnhcQew3lA4qWjfJDT6hFkEsGhrJvTYTnb4LorIILNgtHLhU9DNCDQjgKSYJ/+JxpJK9xlZYkhD9lhAGnAQ59QBHxEnhTs0ewN9iphX4vJN3T0tsz+mtYGJ+JSPvjfJS/Gh/l4xbamkUDbU8SdWedlkSFvysjXoZetUtFeoq8ghYtQnj3TtJpU2JwKHbZ3r+8BnDGCkP2yDPUQi0C7NyNc4sLXm1AvTXjYT5fVCObGXpFi9panFRVmuddHp/Q6ehqEzXwDlVYOEFvObQzbNLYFAXT3up5y8npxlzTpYB9Mpf0ceUMs9QMUWssfjS9/5jEryt32UG6/aYljN/8Z01vMUwSOL1Ce5NRlJCwY/0weV2s+1l9LZcoMZbnKFXF21pM69X0gqa66Bhs5n/q/pjFcywnowhc3rJSfljWF5sooaAcMrorSDny9J0qkkdlHTEKcL7yBB/iE+VVY3AH0Bny6ywQsG/LkJhS4wlI0OW8V3UezPndqIyO20IGJTCgHfhjoujMTTQztmy5JPdWPHwB/iOt8qwRrwelTYvGlSevpE0j
 4ex1g4Ez
 RpjReBj1uolxKYqrw5rTwo5QmaPLbtC78MrgmHBpWT1p44nRU0BRg2Izna6Kj3RifThjZv4cfVUKdFBbFYJGlVUy71I013eh66XK0PVnyZxQRdW/og81mpQkjZJlZR7kIYd8JZcPUIOlpkp1jjkAyNH2iNzqAHtAqf4xi77txINlb5WH3PPabVqg90Pm2cS1qpIQ4DOECbOVt3q0jV5cV/Y7e0KEg3HLtcJtQdpFhYUNDlSWt57hq7hll4AjNzWqmfN0GtXuCxqPQij7ewu9KiLH+T/wlEjEkYfCmxk0IXK+eeWGSsw5v1bahbBwNrp2rB71Pk8F3EdLBsSbbd3dOsBMV5On7S4l2b/grEm9HneC/pKzEqckf67Irc/e1XzB+dp5102QY73BqI22b2/FoKMemlJ9+ECD2B289N4BDD7reEH7bX1rKfS2yppQyMw4/onYeX4Y5CbAlqVl3uhB+Z/A+2cAp2qQ9/PJ1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 10:18:17PM +0200, David Hildenbrand wrote:
> On 15.10.25 20:58, Lisa Wang wrote:
> > The .error_remove_folio a_ops is used by different filesystems to handle
> > folio truncation upon discovery of a memory failure in the memory
> > associated with the given folio.
> > [...snip...]
> > +
> > +	/*
> > +	 * The shmem page, or any page with MF_DELAYED error handling, is kept in
> > +	 * page cache instead of truncating, so is expected to have an extra
> > +	 * refcount after error-handling.
> > +	 */
> > +	extra_pins = shmem_mapping(mapping) || ret == MF_DELAYED;

Hello David,

Thank you for reviewing these patches!

> Well, to do it cleanly shouldn't we let shmem_error_remove_folio() also
> return MF_DELAYED and remove this shmem special case?

I agree shmem_error_remove_folio() should probably also return MF_DELAYED.
MF_DELAYED sounds right because shmem does not truncate, and hence it
should not call filemap_release_folio() to release fs-specific metadata on
a folio.

There's no bug now in memory failure handling for shmem calling
filemap_release_folio(), because

shmem does not have folio->private
=> filemap_release_folio() is a no-op anyway
=> filemap_release_folio() returns true
=> truncate_error_folio() returns MF_RECOVERED
=> truncate_error_folio()'s caller cleans MF_RECOVERED up to eventually
return 0.

> Or is there a good reason shmem_mapping() wants to return 0 -- and maybe
> guest_memfd would also wan to do that?

The tradeoff is if I change shmem_error_remove_folio()'s return, mf_stats
will be changed. I'd be happy to update shmem_error_remove_folio() to
return MF_DELAYED as well, but is it okay that the userspace-visible
behavior in the form of statistics will change?

> Just reading the code here the inconsistency is unclear.

Another option is to add kvm_gmem_mapping() like shmem_mapping(). I did not
do it because KVM is a module, so we'd need extra steps to check of KVM is
loaded in memory, and that's a little more complicated. Also,
kvm_gmem_error_folio() already returns MF_DELAYED, which seems to be the
right thing to return.

> 
> -- 
> Cheers
> 
> David / dhildenb

Lisa

