Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C9A5C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 03:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1F48E00BD; Mon, 11 Aug 2025 23:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273068E0045; Mon, 11 Aug 2025 23:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1889D8E00BD; Mon, 11 Aug 2025 23:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 084998E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:57:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F6051601AA
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:57:29 +0000 (UTC)
X-FDA: 83766745818.12.C9A0165
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id BDA86180008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:57:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DAKwB5gK;
	spf=pass (imf06.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754971047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=oHPrTUit6799Ukyl327yHbnkbr4IJYMNh4FvhRAhqPE=;
	b=dcdkbHlhAOEu9WX7+gWpgGszHSp7CRYrhHwu41t4Lj5OL468TlXD59aOGBVCjiUcbG4Bo7
	YhQFxZo4QwSB/zF5cG8U6GeiqlkVEIdMJqYq11cbCP6ROyyXvcK5jm2ZmpbjNfR7Qi3URy
	VDFKU2PW0bSmbOY3TJHJYDzk2oUyMQs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754971047; a=rsa-sha256;
	cv=none;
	b=VArwLSMhf26kEfW0waQWSWkfDU7nD1t0RZIt6Xb1EqHeThR8jDd9EH583uT9rH1sNh2qwl
	Kc2orrmyJazhyGF6ZcFmPDtDqQwNmLfkA3vXmiWurqz+N0KjyzZW9keaEQNSYRSrzFlFct
	W5mT0sWTU9a2G0qDPT+Mkb1b+PPafQU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DAKwB5gK;
	spf=pass (imf06.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76b36e6b9ddso4258162b3a.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 20:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754971046; x=1755575846; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oHPrTUit6799Ukyl327yHbnkbr4IJYMNh4FvhRAhqPE=;
        b=DAKwB5gKQX2WdXhDB/kcDhtL1mqy3cks0yq2bFlg1yOYBmY7MRfwgYN/ISiB9ZQHQU
         6sydfiXL/YcsMJ04OFMUQQq/qVF9dw49XHjOoIYa9QbvO6sSqwKxSMVgxfIfnpISe6+l
         jMrxhEzEKYaxdeUBwuTp1R5cRXtjcA4bSJfFD+6XJ+hnUHKr77yJKglB+pXsajz1Yyce
         scT67wtlvgTUEemjaRxg52KmD8n05l+hSvmghFSqdwbyw91Ufx89ANw5FJ3zZseHDZDo
         UczyUWi2cgkknd32TJDHbjSpBTGlqrn5zkEdYKj6E525sIEWCx3F9/IOVLLGQkKpcDyz
         y/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754971046; x=1755575846;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oHPrTUit6799Ukyl327yHbnkbr4IJYMNh4FvhRAhqPE=;
        b=pYsz+081oZ3omAmDcs79yGjGnELG2u5d7fH1At3KgZ28oYjyzLVOG9Tmn4O/A8b4yt
         sK2qYdwqyQ6PCFUIh5NYcd8vjwTPpcFp6VAXqFgUEMyb1E7lJd7HnA0OW8EZyS1qQP5J
         prWzZSk84PHx65HSgi/UTKheNplP+iGkr8bgaqpEZipipfT3Md2l4sAAKKRpIeQoUPvL
         F8JKK2h0e7awpN3WWxLvFVgi4rh2TYsBprBuP2/N/tE1fGY+RDlqEsmZRuKsFcUXBFwH
         qvF8pfKu2WHTZlbxFx0QICVmkHdMXpI1cKbFgovRA4pH/f1mo3Honj2JZmCmLY/8ibL1
         ZGsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK+wy+MUPph1+oAA4VIRt5BwsZ69Pa9xuKrZHpSzGFlap8TF2/lEciWiA1Ezm1/ivUJQQgSQJqfg==@kvack.org
X-Gm-Message-State: AOJu0YwuVRkfl2129jwdY4Wjm0Ouctcb7OfpFFH31OTbgNteyD5mA8HQ
	56lYHl5p6ZFCJ/G1EKKLcr08MXgDpEiHIqUmZbEXmYQ0dQIzpBcxB38R
X-Gm-Gg: ASbGncv2f2qPRB25XLr7UouwqdNf8lRstjjjgnSIfK2C7z+U7fNpC44oR8rbwbJvyan
	a2RASconevtIlbORP9uLP/YY5Bptc5YkMGQAwwND9n2tmfwldw4UPvNsoybDiiKbJZ+0RzVvhhZ
	sHKZS96iQpCmugamat0+iMrIKrRHacH1rrikuTf3HWmw13R7+wZXOrtGcDiSVn75byi6QqWI5eQ
	WEoyE9rAOsuvV7oA4RjcWmJOFA6MAsyXwn7NnTmejC8WztdEmsYU6dfYMVepboXJmFfFDHdTTAs
	eNF/V2AYiFJpJD/Nb+SZa9SgF8eB2D7OQg4t+zXQJgJ6azBeaPMXgRM3BZntsXhljfWz8Fiwe26
	9VrGuuLue/rtfpeU=
X-Google-Smtp-Source: AGHT+IEkniR3HqY/dwK8Kl26I13c00NtfCllhZC4xMwWhoDZe02+yOvV18spWIGeG2IlgEKVjtPGFg==
X-Received: by 2002:a05:6a00:4b14:b0:76b:dee5:9af4 with SMTP id d2e1a72fcca58-76e0def6cd0mr2882742b3a.13.1754971046534;
        Mon, 11 Aug 2025 20:57:26 -0700 (PDT)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfe50c8sm28095622b3a.120.2025.08.11.20.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 20:57:25 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
In-Reply-To: <hp2wzpu3bgwqyw6almor2x6exgx7t76kch4uec5fbh3xw6sy5w@p6bvhcdhpyea>
Date: Tue, 12 Aug 2025 09:22:30 +0530
Message-ID: <87frdx5h8h.fsf@gmail.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com> <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b> <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com> <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com> <hp2wzpu3bgwqyw6almor2x6exgx7t76kch4uec5fbh3xw6sy5w@p6bvhcdhpyea>
X-Rspamd-Queue-Id: BDA86180008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 4pijfyetrhmbjo3ibnfmar6jnskx4thq
X-HE-Tag: 1754971047-220875
X-HE-Meta: U2FsdGVkX1+UN6S7lMh5CAToV7Q5/jPvwwctEyM3MBTVusKVSxoAq5FrDGA6FDhVwtQD5sQgj7g0wRLMHwHx+9uZzHaO8/0TIFIW81htCX7vD4zttAS9Et978twNIxxrCtGqhZxe2b3jTO6t9+xVUawPfzOXHNJeiFx3h3qrMK1dhC0t8WEWCoIvxh7mHz/hu6VkMA3+HaSHlsNrAFh/o5g0f21pb9+dUtZMm7xscWTvRYdlzkBq9sol0kHRrnhGKGCel5UrthGFHYIgHVEOmDArJfwFGPqkS3Up2RKAr5YrRVd7RNMyXZpclbR41N23aNaUr2qvpDJZTlNFqYqbTb04CA9aktowzOQzIQqWNi3jBQ9SjGL32QrFR+zBdlWjVMFRy5hJqNKlowdb4xWnVM/E02sMXSwTlhlECXshudrBj9/Dmh8hOEKKE/1nLVDmA6XR88R2EZ9d3mx8xYn49E4sazXzqriKq2S3KyvdDKPBZEj8+nP927KvXlKw5L2kyaVazyj2J06iUquzX1DnXgcteBIFK3unLWeGPJdUXPGu9OQqHxrAS/kZc7xy0o2o6FuzLT5NV2fh0rMwQbRm2nQH0W8RakZ2OdBS6atGDyJZOXTlL9HmS7EEGf2I7B57cG1W8LRCYTVuR3mwkUgsi2Z7HXYgKyqEKzmtZcr195sEXaPmFM/nLFI1v2v8SR1jdkCBllAzs2zwyE5Ey0fhj4aTY7eHOmpa+s98b2hkJNFORENrt/ppeIAZ9y24Afb0JtV7/p3fQYu0ECHEGiTPsE+O6F2ToxBnMo4U/juWl84bTDBckl7eiecgptKoZGB4KKg9GxoomadjSI7YmXCupFaU+L5lMQANJgEg7KcnjVEqPVUlplGcgTW5IlRpwgVFfOyR112hAd2gt5dmUm71MJEsHxDxkVeTxGNxxf46dgQOyeL06XDw0EQtqPM0s6MgNeWi+7SpKHO+WRoSnDX
 /DYx3WdF
 V1DqWFz8jgAKg/gz3LlTmm08EisaQSxlUMyJ6RqPXF7Xa730aMIjgMcOU6pRMDwgcxMgEuIzE18dfOKc4OBLBuEmeSqvH2GDheow5syHu4xa5T61Mmc8d7cSb+YX1BtV52epoL66wxGxMX4BvM4GrpnBNutI9qda6ekfG2B8Km13pryhL1cN7CiwNBRkwSRylsHl24INmI0YKjVWWRu09RHApw8ZPfOAZqGmkPQUxSe93T0DdiKwmtHhLVZd2FineteZqGKvr3gpzjwpKhk9RUe2q4e00DnQWfR5iVQXa8ta10YePn61Td6QuaXG/36NIIDY83mGknf+RvrIAcAgN3K+bwKcOm/WdK3H93fy1OatmJ9wy67Doo17hPkbDFLRw1T9QgSmg9V+TL0gjNkTW9KgzsQ8hJFcSx56oeSr/yO1W6tDob7gVLyQ0Uwzt3FOtb6fKnECYyDKfwv7BF1Wp/JhN+oiZnhGYTbxM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com> writes:

>> > > > Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will always allocate
>> > > > the huge_zero_folio, and disable the shrinker so that huge_zero_folio is
>> > > > never freed.
>> > > > This makes using the huge_zero_folio without having to pass any mm struct and does
>> > > > not tie the lifetime of the zero folio to anything, making it a drop-in
>> > > > replacement for ZERO_PAGE.
>> > > > 
>> > > > I have converted blkdev_issue_zero_pages() as an example as a part of
>> > > > this series. I also noticed close to 4% performance improvement just by
>> > > > replacing ZERO_PAGE with persistent huge_zero_folio.
>> > > > 
>> > > > I will send patches to individual subsystems using the huge_zero_folio
>> > > > once this gets upstreamed.
>> > > > 
>> > > > Looking forward to some feedback.
>> > > 
>> > > Why does it need to be compile-time? Maybe whoever needs huge zero page
>> > > would just call get_huge_zero_page()/folio() on initialization to get it
>> > > pinned?
>> > 
>> > That's what v2 did, and this way here is cleaner.
>> 
>> Sorry, RFC v2 I think. It got a bit confusing with series names/versions.
>> 
>
> Another reason we made it a compile time config is because not all
> machines would want a PMD sized folio just for zeroing. For example,
> Dave Hansen told in one of the early revisions that a small x86 VM would
> not want this.
>
> So it is a default N, and it will be an opt-in.
>

I looked over the patches and I liked this design. This is much simpler
and cleaner compared to the initial version. 

Thanks!
-ritesh

