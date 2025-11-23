Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1470FCFD314
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 01:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B00B6B0023; Sat, 22 Nov 2025 20:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687866B00A0; Sat, 22 Nov 2025 20:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D626B00B0; Sat, 22 Nov 2025 20:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 481096B0023
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 20:50:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5F351A09F3
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:50:30 +0000 (UTC)
X-FDA: 84140192220.27.089C95A
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC483C0002
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:50:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N3aD5DyR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763862629; a=rsa-sha256;
	cv=none;
	b=kgEh0eT2pt8HWioraNcD3y56GmrQ2B6IRmrggurScBkF8M8JF7jc/R9ZiBMmF1kBKYa4Y3
	yHPKy23ICdfpO8irwXMID8DwUbI9HCOD/UnCe7ywohaRcGZJN3rvjmBSjYqF5IqKiGeDaf
	7z1XAqd5PsSizo5T5guzhVYE7WV9l6M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N3aD5DyR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763862629;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZRMmt4pu0dDVkazc6ojxwyXbSgwN1XagjCsYx65qUw=;
	b=nKWTdgSQl04FYVdozJha05kaaxHouvWNOswDSjzNJxeq1kZaOKixoqo7qq8VySBlcMp7bq
	SSyLBa5H6UQO427GEgqiLktpQgYcNiOW5UYGkdt23zINhtVx+yG0yMhlncTW3Odm4+g57J
	UeylUc35jVgflBOtGuuvOzuG4KqiIdQ=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so5147737a12.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763862627; x=1764467427; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZRMmt4pu0dDVkazc6ojxwyXbSgwN1XagjCsYx65qUw=;
        b=N3aD5DyRk38F1LMWrA5vscud23guqLxOpbbFrruHdP0rys8zP/PwDHqnUOse45ya8N
         CgCHzU8OSrIM+RHPOrZzpH3wERnETL9F7PbB/ejE1W78kl2A3FRIPeqNiQsTBYFT7XSQ
         QExcaIsk+tHlpIJ30ChIbLBcBnLzNxQDVMvJTH3GNJNwda89SXc1DoJwCsLlRnjQR+/C
         2HOSxs4si58HHClOJsvE10qduEZ2LUkvlfitd+T2dM1OvTsm4rgDSlmn0jih4F9UGkQK
         gSjRdO00yImp+b+pFMWmuph6O4k2RRnOZ6vP+ZOhcPe2rRHObDzzcSG/33yepIGtScLK
         b0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763862627; x=1764467427;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZRMmt4pu0dDVkazc6ojxwyXbSgwN1XagjCsYx65qUw=;
        b=DijWuSlM2IkPOcXciI32AHef104Rqm+UMg72m7vJjvu45MTyNvKGGjZzHIka0ZVvKS
         sZ2AKyye1hhGjx4lMkWcbAXOLADQbxp3nDe03OHoYOljxofhCMTcUfZNr/L2Ry/2hSoa
         k2TRN+6Sjovz9A0uf180n1Js85YBrQkoE8wdUJ0r7vSzb5kdiYraeVARDgcym4RYJ6C7
         HlNRDnpjhVMeWIklwCHMqaJwQkWrannVaQWN6CEpbWwY7SW9B9Jygu/dlerMa/B7eNL/
         R063dNR8+/ZoXppcCqJiDHIl4UBVqMbjCo6Ad3LWgayBWCWD4ywsCqW8+m4bNfNS0hP5
         8/Pw==
X-Forwarded-Encrypted: i=1; AJvYcCXjvQdfTJSyb3FjKEdnle5/Ud6kT4DyiZZ+zPACaT3uGTjm1dve+83oNF6DVCRyN4MKj8YJAhcqiA==@kvack.org
X-Gm-Message-State: AOJu0YyrJpnMUjT7mBIDXBm32aDHvk0jrTc5NEt2WE65CS3MyR2mIAX7
	ehYpRFC4dIlg8EDKt/qp2RPxy1fEWpM7+zpIUGMYvb0vRwYSaHn6WTUb
X-Gm-Gg: ASbGnct4nn/PpX02cih6WMPcnvvY/63pmTBKSZOkryVg6eNFRPDHMUg+Ck/CtfCpxNX
	uwwXUaZf9VGkJhFxrMtvEe1TIM8cy0gRBFfXFtRqPZQM00LKLV46IKgvHjCKIKPBtOiWObZXffX
	1Gh/Ykc3Uv9PTUM91Zfok/W8OYvb7M2W7qeETimExzRtjNFqWttctMigFqKIaeewEWRQUucEA1R
	+t/JNKllcQSu5dODWuSOc/N3KlQep+0kRE0HHCFtH+19VPocCnXXpIGoosRJg/AYZQKoZEoTYLY
	ahSFmI1RK7rnzbqKDz05+FDCNODzXmEw4mmRHRSifHDq5I9ToOIamfKg4VukaTnuZMe2RUUA57I
	4nyAvI7nu0U9ze4Ce6CYH5iwJef11KasKsx1QIJ+u8uaK1hp48BeUsNzGaXtYlgbY1siAM8Zr4C
	GJK3HmAmIZ1DxJCGf0ZWVXMsND
X-Google-Smtp-Source: AGHT+IHZ4O8wdhJM+yoOYvYZf6LNE4a2WojGsAeFRR0CdKN+TtxymyN3cBZQC1n8qSaPgcVxqeqO3A==
X-Received: by 2002:a17:907:7f08:b0:b41:4e72:309f with SMTP id a640c23a62f3a-b76719d84femr659491766b.50.1763862626935;
        Sat, 22 Nov 2025 17:50:26 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b765c1379ddsm790854666b.0.2025.11.22.17.50.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 22 Nov 2025 17:50:26 -0800 (PST)
Date: Sun, 23 Nov 2025 01:50:25 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/huge_memory: change folio_split_supported() to
 folio_check_splittable()
Message-ID: <20251123015025.cbwijhb6rhvtuxzu@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122025529.1562592-2-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: DC483C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: 8p7sje1j9i9u57fnt3ky5rhgi1fmchhs
X-Rspam-User: 
X-HE-Tag: 1763862628-217251
X-HE-Meta: U2FsdGVkX195h0tamUQkPAn1++CKZqL4K13hYZdc3HwLUPTX0nM3AicPC6HLgMejFlJP7jlZOCeDGGK8N7mLtyKZBFtIHCoNaT1W084erkAGiKmUa21Eqf4GWK2WP7kCoy3BvJxPxVTVkNKMmBl3Mrgmf9mcx4i70RooVrbbmXy4xRnmJK/g56j1QN+9u7Wtgz8etWqDQq4HOahc9a/4Z4fBl6GWvbbsdL+XHYYFX1gX4v2z2BY6auPddQbd3ooN8fpv8s3QQGTeygqj6eq201T1dVh3WSPtAy73Br1qJOLOZ2eI9YuxjhOBLARUz6GYBqfFAFIBbFDxDAblfmt0QSfw/5YItEr4Q4Qgs2DZ6vic3Lo4FMacMJVCWWEOkPsenT4d0svY1sSD8sySzndKcK845OzyMtAKZzYxa78nGwLTnxueLP3DWEmOgd1nEPdpVGK8ppFU7tFtK8Qm1YXN65SRrWI1HxJLvI8ZAWCkzO2jhf3eQFCvmmXiTAK/usa9IORRmEnkxSDS191gI+z6B9A0DcLDvqyYlHbdRGiUCXjwNNUFgi0baoC5bifPVfmMYocwO10AW4Nz6W/7Yq45gBX8oChXP/0XFcvl06APFJOvEcdOiscIm/mlqo8cQofx8sh+SMALWPRCm8JaMq2w7re4ekVQdMCmWVr1a7n8a0NdLrMatk0G+Z32pOC2rteW1JehgKRg3ktDFZQi9qYlch5UexiZ/LAsj9/Reo5nKrsdd4QjFFvLiRtk75dFIAC+HmqryuC7swCM0MEkLNt57V2PjUQPfp1XqC2xxyKrefo2/stUHrk8KuWRzn00s0p2lUoBfmW3RbhNExAc07KqNe5qwdO9GtpsS7b8RoERN6Tebx608QX6tm1PavP3xqMy1O5fysDPK8NiCxIoNI3yrf/btRY2E0ZSnfs1KYd9UrBJ3LAFwyQazlTSFzBloSDd8MoNOhRykt+lxk028N4
 +Sf9PhMO
 2N+nKaI45l6ml7VgOKxsaBdVVLY9qZF2dqhMmcXzhHQlr6NUZMyz4wbcfZHZr/dWH4XvN+BlvkYq0jpeipAu3QebaJKXdaU1WXfmIGzZpMsZgWMTroErMtJXwimeWy+MU1hxsgsJ786BcVI2CbKJTShAQP4x10C0bPvyR5d1nyO0BSdDoxGEva1Zb+rOo1MJUqReytaEUGJRerWadqNMNlt+1Ob2BvrjXgZ8LTeEZkIdhmTnH74O/NZGeyotYtAENIY1woF3LrSOAw/wqyHBtNFjVzgobPEc5v5voiLGXqd/eJJLLL/Ay/IbL9owfhtLEEQWUOYuR2pF16WE/dWsCoxcwm35hySWQAQ/9g7+eQE8ieqmcgVkCrmCjVJpKlvpAZ13mVv/Cd+fscbI4ktL9s4rJ4oqnxmepBf/XU1WmapY+jgnilABrzCzEK6JwCj2+uBSXXagkZVkGqdlyrOPsavSZaF+7FCNP90G89Zd/9vSu33tBUle7weSvlTPHR5hM90HjyiOCuGAzw1pW/6ROP7l1dVbvYKLr7EMujHjjn5c3jijHGFwwRp+DbSDZMleSvjjUuTnW98Ea0+znkF97lnqfsWg1VyiufKZFu/itq/F+2w5Yi3DCYiIZOmX5jisIOZuriP7TvQ9TrP4IAV7TnBB8wyl9svxImhyRTtD/zQ1ZNJ9xYnm9uBg5TOP50TnqUk//35x7awO+b7PAcy9nyd3tJyvEZxoWm7n5k6d4hfsEf8AQc1YqIFV8xgrWpHDb1ql95dI5u45qwzWUGYBIrI0O+spiFt6hoHv7pwd2nW/uhrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 09:55:26PM -0500, Zi Yan wrote:
>folio_split_supported() used in try_folio_split_to_order() requires
>folio->mapping to be non NULL, but current try_folio_split_to_order() does
>not check it. There is no issue in the current code, since
>try_folio_split_to_order() is only used in truncate_inode_partial_folio(),
>where folio->mapping is not NULL.
>
>To prevent future misuse, move folio->mapping NULL check (i.e., folio is
>truncated) into folio_split_supported(). Since folio->mapping NULL check
>returns -EBUSY and folio_split_supported() == false means -EINVAL, change
>folio_split_supported() return type from bool to int and return error
>numbers accordingly. Rename folio_split_supported() to
>folio_check_splittable() to match the return type change.
>
>While at it, move is_huge_zero_folio() check and folio_test_writeback()
>check into folio_check_splittable() and add kernel-doc.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>

LGTM, Thanks

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>


-- 
Wei Yang
Help you, Help me

