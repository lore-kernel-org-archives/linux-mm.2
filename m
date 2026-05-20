Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1486CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1753D6B0099; Wed, 20 May 2026 10:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C8A6B009B; Wed, 20 May 2026 10:12:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089D16B009D; Wed, 20 May 2026 10:12:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF3446B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:12:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE655A0102
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:12:12 +0000 (UTC)
X-FDA: 84787987704.07.9FC3B72
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id A6E0240011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:12:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gx0UHGVf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779286330; a=rsa-sha256;
	cv=none;
	b=Fq8nDsRmx5AA7W6ruJd29mUhIEYnDcHXx5VIGcMYll1tDKWhBcdf059x0kDSposl86CUzj
	An8gC3QMXfiSVUy8UJnKVytbShxNNQGkFOwGmtme2DVyBqlEW0lvTyELcKpsYA0LSCNvec
	4cYJL7w7dYKBnXVzWC6U9BgCZwP7b8Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gx0UHGVf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779286330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGS4g7trviZuWuV8kj9ji3KsBnr4BymorUPX2qH0oeg=;
	b=gxlx/tAZkMvN5PxAfT1D/lkswU2MAaqMqdX4tiJb1iu1FZTxN8Rv1gAE4/gyrH40BEeD7e
	c8Cv78kx+2EBxkbmFRBRZ5CO52p4GPrABoC33ftePc6LVbBpMJEGNXo+HwgsJ6xyXqly3j
	Fsj4ZFdBMmN8ak5BWs0ADo+FxwqTAvE=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c736261ee8dso2260884a12.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779286329; x=1779891129; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zGS4g7trviZuWuV8kj9ji3KsBnr4BymorUPX2qH0oeg=;
        b=gx0UHGVfaPGYA5l0kbpedy80q8+7Q0ThowcapVMbdy4pRPdCBmXmoQZXp7GUHh7nxR
         3T6x0WnGjs/CqYPXPyD1CzZZ6x+x7D78w3Mo7sVd526bWTzRjignTgq5wwo9AtBxqVXf
         csUfshmaiHrv57zoUTOwPrYu4Ss8F9DGKkLKu+qQnEPpTbwv9zJCc/MHxGW47I8Hbrdi
         dB6SM3IAT05R1rnzATsv6EnzScKC1qX078ti1NJ4IlVOF8fg0lg5H2BtzSRqX+KpZ9IY
         QHIk3en6Pfa0XPS9ui+qBUHGji5ycErM/zQLgvhuiV9/DALM3oGrMIgA7810DXl+359j
         wntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779286329; x=1779891129;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zGS4g7trviZuWuV8kj9ji3KsBnr4BymorUPX2qH0oeg=;
        b=at+rahb5xP9nZH970Xr3OXUNfHITuXT8mzRXq8qZQyjf4xM/ZlTjXfLs0T7EsR2GXr
         VO/P6a77hNY7M2REGL9myFRaKsnXC7tBo1UIGW4dpGTLZ3v8CSDMcjVoUXpnETUWS5Tw
         k+HLZ4WdkI6CK5G+Ptxssd8R0d7dJRqjXVzsifGix5wejxAawWC9MXYuHcq7oy+H1rRx
         dvUCafIa3/dvpCXDpuwhkc/4degccq4UW3HCks7BNtEZEQIYU0zxaDR55zmOxrKF+SbL
         t7Zo7l9hq49sh3cs5Jm5yZMw7/sh2VpfWwv0ijMaO4ZSexDo8MfU9kPMiIyujdYZY1fT
         6xZQ==
X-Forwarded-Encrypted: i=1; AFNElJ+eD0d5j4DYvWpzztwSh/ycyfXMoKfxfbeWQxC1zmHTV8XxCCjPEltywzQRGfuanmtwqKeZPOKTmA==@kvack.org
X-Gm-Message-State: AOJu0YwQiREwXFGvTtiWPTq8GTUQnjfG0i+3U3dx7jEFI9mnw61sKCDI
	8Z/uKtfPkXZuctkPMtJJ4hdXsoVlWIiZKOJJQFcxn43bWevMm1h8tOip
X-Gm-Gg: Acq92OFxtIAS1KJXuPQWpN4YwaBxe8EaueOfAmK9njrReJy4CgthLoG6H/g2hwZGrJB
	FB6Z84WprfH+GLlDFtmGxCsaqPLW8EscSLXRjo+KYsCr8g+GKrHPagTld6m/I17h8BpkRMZN2PQ
	/O59FIwPzspOB+u3AfGKhAsziU19mQaUE59fQ0D1GGqa6aRVsct18fclWh0XqaLvaIA8w9SO2TE
	Xl/L72YoAmKN0VF24RXztIE2e2akY2qArpLBaw/cypNwrVuHUu16mJ7e4OTgQZ2k9vFlJtyWT0b
	q2YGTO0dDYdpF4fFx5jPASo/6T6lBQpseSi/+L37uq2X06NgUBghEi+9K6YY52CoHXy2z36+3dH
	FX6ak62PDubHglxCb46UfZsnry4a/LMQRcCAM7OYbC1JIsX5uuR4uvwawgZYeBiKqPn78ut6+FT
	0XHuUAYG/E6dQfQR42UqDo21JuZLsKDO7mUx3o8cyHLXgCaA5rkWHVM1NjqZZk4qnSzA==
X-Received: by 2002:a17:903:2907:b0:2b7:a350:463f with SMTP id d9443c01a7336-2bd7e8883d8mr164318035ad.10.1779286329405;
        Wed, 20 May 2026 07:12:09 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d11ce67sm227565595ad.74.2026.05.20.07.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 07:12:08 -0700 (PDT)
Date: Wed, 20 May 2026 07:12:06 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	kys@microsoft.com, Liam.Howlett@oracle.com, david@kernel.org,
	jgg@ziepe.ca, corbet@lwn.net, leon@kernel.org, ljs@kernel.org,
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org,
	skhan@linuxfoundation.org, surenb@google.com, vbabka@kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <ag3BNjx2zJz31NTr@skinsburskii>
References: <177863991557.82528.15288076059759579141.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <20260518104808.ba773348f8564303c4330a33@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260518104808.ba773348f8564303c4330a33@linux-foundation.org>
X-Stat-Signature: i3kk9ary86b9tkefxxmsi17gmmc8x3da
X-Rspam-User: 
X-Rspamd-Queue-Id: A6E0240011
X-Rspamd-Server: rspam07
X-HE-Tag: 1779286330-65619
X-HE-Meta: U2FsdGVkX1/0lyt1kYahBS7f0NJd5P2FHm3wAjXMIfnFE2XdHc09rR51JVo5ie7qfz/68mxj7/0pkrBuvIpHDTe+PYria9CuPqpB3wciYZYOOxXdUbaMGBhVriFlLUg+2yxbv8GHEfYHXAU/L8iUudDXBTDC0aKXmhx8/usKOVV1/c3cPsbB4Oqaq99JPohLTDr5QLZsrEQx77h/hsSdMky/0WNGNJbCCdI2IMSv9ZgwUmd2zMHvdXBTGu0v6bTy2Uxhux4C+lMwg0sy3+yqbimsXhoC2KhCZv61c6FVmWqTh4nyeVzpF078joYzMEfwjuqfuC6QejwwX5G7gP/kR37hYF20OL65vWIDvYZ+KPnh7XHKQcrTsoNccPcvFWd/eRaWMYMTlDH6Bjkd5zJoMPopfcBP0XTh2wLxq6Av3xWlF6YATzVtUFmTTMRWzUU35qKrfqcHGxv2Vp/ix0a6mS9WPiFECjpQ0wvXOaDCL6YAQCBci3s84uoXimRaqHAKs51LND6JWv7docZFLJS6tQNB5XG2/bCRcPp0sa+DehsRlUA5XN7EbAzOiZf8hTY1ja4csY9hn9xoQsA0jNmS9CXSlP4Kt37Uf+WFtZ3YuiXXuQqR88RYCE28IjSxBzFKb9UM9sQOj30krSIbVY/TR03ZnbfJL7ipZDSDPBevQWTox2d25khm6/lTAK/VE2Rg3NaiXDNu8E6BCUqyvKjne3w0RNg2OcIZHQSgQflOidi+k1sTu6z4QtCu8dcGeDx9Wn/KPtsxnNIpTEebbBMsbZt4eK/4eiAY9IDPnc3I9kVWeB8vX9KjX4eSX+VxZ2UOPEVWMAaRgGW/Gw2PmZjBHXB/HEDct44f02vEWuEhEMcox0v1G4SPDnyFSGNQ4kkdE52piLBXHbQkUD8UX99UV85HHVwMfGtJO03TqlrUj8yiJ11jYPBmevKG/V/O7y7637OL1gVRN1k4GYl6iq5
 OgWwjcGq
 zcOcDJGkWWcF7jlRT/TXOZcAnupLGBDSqizURRRIIvrYS3MR3zJ3kmdL9fCsYwlrc5U3K2lGxLeHtP9aI4t4EPLttpBAru47Z4sminqmdKmWvccDcvHzS//OpFR8klG1Qq4Fma6mz9UcHF+0xiwj+/fO3O6A0iMIlVlqxYyT0zgmm/u7Shek0ypWBKxj+kBetglAfb+PF+d3m5/HYuXn/MqQDvf8YTChG6c/cpjN1BnxsfER21cW4EnSD9RKyW1uTWCBuU99sVRPSnmc6H47kBRB0K+hxCCCsglgpXJ1ALZ381xmVyBpJwiXJJqU0NiHh8NE2Of6jIb4oT7o4BHL255gU4Tg23OGX+54wT43Sz+x7zDNRYmQDDO+3h0RNWxZP8IF2M1gOr1zyqHLxpeD6UPTgPjUa3AFfvIk3C3ARR5YZWWQ7S5cCKGsnmzjvHHVM5yNhDRDfdqx5sa48yYZy70iyehgl6AztGmzChlXq81uC5tu7dNahROStHX+hIAlBlRfv0dpPP74ISX866v3s7fNYK13L46+TSAke5wkZE7AUTyyYuGB5/DQCtJB7YXNR4igXM0yjztyl5Rfg6taaGvdDaZ4P3cYEKpUf++RoFHlW2hE3th2xPtzrj72GZgILeUIId9u+/aA2FpUVq/9rcgKhNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 10:48:08AM -0700, Andrew Morton wrote:
> On Wed, 13 May 2026 02:40:11 +0000 Stanislav Kinsburskii <skinsburskii@linux.microsoft.com> wrote:
> 
> > This series extends the HMM framework to support userfaultfd-backed memory
> > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > 
> > Some page fault handlers — most notably userfaultfd — require the mmap lock
> > to be released so that userspace can resolve the fault. The current HMM
> > interface never sets FAULT_FLAG_ALLOW_RETRY, making it impossible to fault
> > in pages from userfaultfd-registered regions.
> > 
> > This series follows the established int *locked pattern from
> > get_user_pages_remote() in mm/gup.c. A new entry point,
> > hmm_range_fault_unlockable(), accepts an int *locked parameter. When the
> > mmap lock is dropped during fault resolution (VM_FAULT_RETRY or
> > VM_FAULT_COMPLETED), the function returns 0 with *locked = 0, signalling
> > the caller to restart its walk. The existing hmm_range_fault() is
> > refactored into a thin wrapper that passes NULL, preserving current
> > behavior for all existing callers.
> > 
> > Faulting hugetlb pages on the unlockable path is not supported because
> > walk_hugetlb_range() unconditionally holds and releases
> > hugetlb_vma_lock_read across the callback; if the mmap lock is dropped
> > inside the callback, the VMA may be freed before the walk framework's
> > unlock. Hugetlb pages already present in page tables are handled normally.
> > Possible approaches to lift this limitation are documented in
> > Documentation/mm/hmm.rst.
> 
> Thanks.  AI review asked some questions:
> 	https://sashiko.dev/#/patchset/177863991557.82528.15288076059759579141.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net
> 
> I'd ignore the fist one: don't write buggy fault handlers!
> 
> 

Thank you for the review.
I addressed the issues found in the new self test in v3 of this series.
Please, take a look.

Thanks,
Stanislav


