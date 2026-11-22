Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8444A606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QtATdAra
Received: by kanga.kvack.org (Postfix)
	id BA79D6B05B1; Sun, 22 Nov 2026 07:04:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B585F6B05B2; Sun, 22 Nov 2026 07:04:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20136B05B3; Sun, 22 Nov 2026 07:04:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FCCD6B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:04:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3ADB01A069D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:04:44 +0000 (UTC)
X-FDA: 85462623288.17.1BDF120
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 777A3140007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:04:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QtATdAra;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795349082;
	b=cGA43B//CrJwS0VBxJdWKkUIkeievN1ZXW0pRWR784UfhPIDtp87zNo0/55I+TRr91DT8O
	e6h2fs20ffw65Xoz4Y8iEsUvR6uh6fax9fs3VTXSeO0jWRdM6VBiyrjU9QxbSNbDtraqDm
	dvAcwx0rXB7vfeXMQQ6skoLsy6WTo3E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795349082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+yb/y9hVY4gQHBtq0ety+i4x7YbvicEI/eHAt9Cm/M=;
	b=IqOEEPne52k8+/mYqL16FZRpBzLopdVhqQhsRssKHF8QwAcdQimJFUUNoeVRBAV+ptIcW8
	XeA8PssQvs32AY1fCaAANH0UdaonOwoWEaBbfwasfhyGyYM0/JwQxVOBt8WoW6fVw26d0x
	tukuyIYZf8F7sXS0eovgtU8/HMTvvGI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QtATdAra;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795349080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V+yb/y9hVY4gQHBtq0ety+i4x7YbvicEI/eHAt9Cm/M=;
	b=QtATdAra9RhIwPgRhS7ygnxiUsv7aGRaEtVv/V9javQUjljEfvnitQt838MpxOLMnZQZRy
	5UgPfmIB9WMmlg1dSMEBQzTlRSh3lMBl8ka372+01J7jf3jP1w1YCTtvdvtXVR7x77X2AU
	MzJ4RIfh4ETtbo47V2tFa10PXO+Gosk=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-maj0bwZwMzOxWiWHXhqHJQ-1; Sun, 22 Nov 2026 12:04:38 +0000
X-MC-Unique: maj0bwZwMzOxWiWHXhqHJQ-1
X-Mimecast-MFC-AGG-ID: maj0bwZwMzOxWiWHXhqHJQ_1795349077
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5c1ac335922so1071396e87.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:04:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795349077; x=1795953877;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V+yb/y9hVY4gQHBtq0ety+i4x7YbvicEI/eHAt9Cm/M=;
        b=GT3HezegN80er2mWixOF89YLHXZWJEf9Ncte1+XmxM9wIiYfNo28nozqif7z/iFGpM
         9iOaPWbavWt7rTQ5mrEDWfdLD5zIvW8S0tWsVqHiMLlXWRW8l+CZsIUThdS9DTH6cr3z
         IkhYhO4GwD/FudxT4l/cTqo0Ah40Vm2RdpcR2my+8aAFcTkIEqtaiOb2Kn51bloAV81a
         FvQcEmbpwCUsbZ+365bnDZovpnXfFc7co3O2sBQRBCg7GkjjcTRBnEbCA7LHdIL3y82a
         z5Aybnt3gxzxUF289JLstM88qUSporuKrenPVNyqLLUAStcLKgF0idsdZ2OkbrA/m1/k
         Mn2Q==
X-Forwarded-Encrypted: i=1; AL+hErFCV8S2HCLvYasgNyB7VlklaJT/BviN1PX559a+hAUorkVNsp5t36X3qpxqezaINpQDcJ8p1afaEg==@kvack.org
X-Gm-Message-State: APuU4Z/sv2bnFUY0tomsQIAoQL9hQx1eohFNvRKKPZw7EqNlV6x/uE/m
	j97vv84Bl4zk9vYh5iJoNKf3Op2SVhksAf0ErPhV7r1SLRvkDGnMsLyZJ6vO9iZi29DkuYEO9MS
	Mt5Q8ziZgfQcLdIiu1DwLaF1ldqH8Rx1g/QmoL5kuGAVC3gHmVhI=
X-Gm-Gg: AZFdTZf93IpENnPvS85WcplTnFbx2WvcQauQC58tuPaswtTNgHszzS6OO6U87Ajxzyo
	TyAXGQsrfyb/BJ64I5Vxb04Kna5Vxp7uWkhilKjrAp6lME/HwsDSHZUy1mY9Q0eJoqsk0mCJBDB
	MpDJgYWvmH4KVMQr2VP8QS8wZefK2xNScnRQXfi6a9p6md/Yt1pBAVORl4qIO0PfEsbkma9TTO6
	JQFY5KZ0KABkL7ALREFZUsu9sALlA6S/jUvGlG7zEcCvgrH/oHWMu9rcl91I5tVfIRKBfrYTzjk
	GJ3YFtHP2rU2auCji3e76J8VP4fGuTxiag9FDdQ13MxVN3BVDNuoWkd+yS1eEgfs1PFHZQhsDRp
	QOCpCH0/X/mKBvZTLRLKnjoFBUBcIpm7qWjTOWw7TTgMFcfb5lxyxJtd5aJhtTvAFMVPIbTZD7c
	wxBuAZ
X-Received: by 2002:a05:6512:251f:b0:5bf:e540:85e6 with SMTP id 2adb3069b0e04-5c1bc80fc24mr2490879e87.24.1795349076857;
        Sun, 22 Nov 2026 04:04:36 -0800 (PST)
X-Received: by 2002:a05:6512:251f:b0:5bf:e540:85e6 with SMTP id 2adb3069b0e04-5c1bc80fc24mr2490845e87.24.1795349076163;
        Sun, 22 Nov 2026 04:04:36 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd017803sm2088742e87.38.2026.11.22.04.04.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 04:04:35 -0800 (PST)
Message-ID: <ab91c700-311c-4bd5-8d8e-d90d573f57c0@redhat.com>
Date: Sun, 22 Nov 2026 14:04:34 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>, jgg@nvidia.com, leonro@nvidia.com,
 airlied@gmail.com, apopple@nvidia.com, balbirs@nvidia.com,
 christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org,
 Patchwork <patchwork@emeril.freedesktop.org>, SeongJae Park <sj@kernel.org>,
 thomas.hellstrom@linux.intel.com, Vlastimil Babka <vbabka@suse.cz>,
 ziy@nvidia.com
References: <179342234355.4.16705453209886955762@gmail.com>
 <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
 <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
 <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DoIDBO82a7aThruw3WEVp45BmRWXcN-buNlB7rKDZuA_1795349077
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 777A3140007
X-Stat-Signature: rhpe1p5jqqusz6zcfccrxmri1qad8e6y
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795349081-125731
X-HE-Meta: U2FsdGVkX1+4PM4CF6KQPdvJu9xxJ4ICwg9OWAFwAb/ASHtXzoY0CLsrplEnqRwTqi7CR51OHRlTysmlsMOG3ZfEJ0ZHsa5ipMNvfCH5OdPhvbaolRqJu0gHKyJh+PpJQtMM2/NEb0/8lkxzNqclt116WH+H3hU+wQ5U0ZjOmPtbXj7nVI9H8wR42/Bz3du/0QKg7dW3anE3w4z6nex8UT7NVAAR5cjeMVAR+4Il3GD5yRgp2wOGSWgfKi/SA8wlgNnHBdr32SRor8R5O5/a7qtNh5DUsOyNn3oTbTDAtN/t7X/KP5EvxNR9hbqGwn2ifuvxHN7KpXbhlCMLX2XqmFqUmBfoRsaNRZ90l78O8Xj2YB3AMCNpdYpxOyVgZOpz7boHt7EoN6bvKtXKmwIKqTLJg+ksB4TBZxjRx7xVKbyq2lqfJr3MvYlvbdA2GYC+PMXsanqWiQzcEB9RzhD5gBqgURWfHpTcMsE3XQYQXSzLaTzqwW2LVvZiW0Y0PQ+MQXRJz1ilhXnrNzYMTQWg3KvEnf2OHCyPLOwkuUfQvM2MxEguedwPr/zVMct1hxEHTtH9J0EqEfwv4JPI1m2U+4Yhh3ou2h1t6EDqiEb1Q/MsBEVXGZeSkQ4MXl7PUYHLMrzldxjhwNwpd/LZaK6yL2KGSeuGn/B3Mf7b3RwZ0HxZDz6bUmoaqb30434iyIkucMxspnmLizVyGuxZsQjv2RwDsCRBit/F80dnUnRTQO1DUAYw882utKz4U0HR8VljURUR+LWYMrO0l94l/g0j9FPDgtmzzfLcYmalNKSgDuw8K9NiWu3TCXzLrtudNeZMu9FKZsArJ2Fe3GrSKt9wqCYHcTXEWB2TlcHZNmy3bVA9EVBz4nL5ByPiUgAxLq38cZgZAz9W59RxZBedWdG6mJRM3ZjQvUAaQpvyNvvngZmKRSuW+PAPicZ30FGOLoTR4GjHJvUwKrhdg9rKsTP
 jZv7bSWG
 inn6YsOmSG7GGSG1OLtiMn4MffYIEDBU+CGzy9hu1FoNxk87iOF0GcAUTLoXcsftEFbUHhiwKoVxdk2Fwe6yETdcgz9NdgJ2xKPl48C6B470GF7QxZGIUSTPB/FycfnyUhmGMUJDAoViq85Sv4cGluKEfZpEyK13WLEqovVjmV0yvFOj59Xa+SKik3gojPTrEWJOx/1E9Wq+4jj+qzHAnfx+5sVrt/1PEIP/uLZ9icFXOMlvh53bDFspurrmi99NEaD4Iscvp6EQjX7aRzI8hKcMAR1OeicZ38v0wloaqNTBWQksoF3cD9wW8E+q+0xdGt6pF5cFAXva9VT2mGcWkEgenTDpiaAtAfmrVKckjaZyYNRQcI/1O2Ujgdn1+J5vVL7CJ2thJfmV4lMT+ydy0e/sekKnp18w5QckKotIXaEQl+/9flFovh+OUo80Py5YN/wxmY3o40Iol8x/HTppG4ygAu3+rykHwPwyONV8gwk3iAYS1VBWgfSfz5V6UKhH608fzY4h7zzAOAUr8KupnzCJwD9gGS4QLz8BpvkNZblEjNFtvFRcv1VmYTK2YScDM4lJyxvnO1pmieTZW58Np9dWWVdvBaml3l42rRtc5HywXq2hRfO+dXL+KjAYuTkpBkpaMAYFL/+8I1UHXaMf3DyDtyV5GT6pzDmJazD0vHRHsKC8H62n3tk22P+YLeMMtMS/HtHQapKQLSYxrU3JZJtpRZWjEQJnt8wE5Ot4j2nNPjRBOFMGEwZLCRdywFgtmPnZityrAHnRHxU5qoEpDYAGbMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 11:52, Andrew Morton wrote:

> On Sun, 22 Nov 2026 07:55:37 +0200 Mika Penttilä <mpenttil@redhat.com> wrote:
>
>>> So it accidentally found a bug in lib/test_hmm.c on the way.  "The QEMU
>>> run exposed a real test_hmm bug: a second open of /dev/hmm_dmirror0 can
>>> put a device-private page into its page table, then dmirror_do_read()
>>> tries to copy from that non-CPU-accessible page and oopses".  I'll prep
>>> a fix for that separately.
>> I noticed that also and will make changes around it in my series.
> I came up with the below.  It all tested out OK.  wdyt?  I guess it
> should have cc:stable>
>
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: lib/test_hmm: use backing pages for device-private mirror faults
> Date: Sat, 21 Nov 2026 17:06:45 -0800
>
> When one hmm_dmirror descriptor migrates memory to device-private and a
> second descriptor reads it, dmirror_do_fault() stores the device page in
> the second descriptor's page table.  dmirror_do_read() then passes that
> page to memcpy_from_page(), which can oops the kernel.  This was
> reproduced with an unprivileged process using the fake device in a QEMU
> guest.
>
> Store the corresponding RAM backing page instead.  For a large device
> folio, retain the subpage offset when selecting the backing page; using
> the backing folio's head for every entry would return the wrong data. 
> Extend the existing PMD migration selftest to read the last subpage
> through a second open before faulting the memory back to RAM.
>
> Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> ---
> tl;dr: The unpatched kernel oopsed when an unprivileged process opened the
> fake HMM device twice, migrated an anonymous 2 MB PMD to device-private
> memory through one descriptor, then accessed its last page through the
> other.  The patched kernel returned the expected bytes on all three ioctl
> paths.
>
> A was reproduced and saved before B was built.  As uid 65534, a static
> userspace program verified that all 512 pages were device-private PMD
> entries.  A READ of the last page through the second descriptor produced a
> KASAN-enabled kernel Oops in dmirror_do_read().  Independent A boots also
> oopsed on WRITE and READ_UNLOCKED at the same last-page access.
>
> With only this patch added, READ and READ_UNLOCKED returned the expected
> 0x0a byte, and WRITE returned the expected 0xa5 byte after migration back
> to RAM.  The modified in-tree hmm_device_private.migrate_anon_huge_fault
> selftest also passed (1/1).
>
> This reproduces a userspace-triggered kernel Oops in the fake HMM device
> used by test_hmm; it does not establish reachability through physical GPU
> hardware.  QEMU guests used matching kernel configurations with
> CONFIG_TEST_HMM=y and KASAN.  The guest device permissions were set for
> uid 65534.
>
>  lib/test_hmm.c                         |    7 +++++++
>  tools/testing/selftests/mm/hmm-tests.c |   14 ++++++++++++++
>  2 files changed, 21 insertions(+)
>
> --- a/lib/test_hmm.c~lib-test_hmm-use-backing-pages-for-device-private-mirror-faults
> +++ a/lib/test_hmm.c
> @@ -292,6 +292,13 @@ static int dmirror_do_fault(struct dmirr
>  		page = hmm_pfn_to_page(*pfns);
>  		WARN_ON(!page);
>  
> +		if (is_device_private_page(page)) {
> +			struct folio *folio = page_folio(page);
> +			struct page *backing = BACKING_PAGE(&folio->page);
> +
> +			page = folio_page(page_folio(backing),
> +					  folio_page_idx(folio, page));
> +		}
>  		entry = page;
>  		if (*pfns & HMM_PFN_WRITE)

I have this same chunk. I think it's needed, all dmirror readers expect to
copy_to_user() from pt.


>  			entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
> --- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-use-backing-pages-for-device-private-mirror-faults
> +++ a/tools/testing/selftests/mm/hmm-tests.c
> @@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	void *old_ptr;
>  	void *map;
>  	int pagemap_fd;
> +	int fd2 = -1;
>  	int *ptr;
>  	int ret;
>  
> @@ -2143,12 +2144,25 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  		}
>  
>  		close(pagemap_fd);
> +
> +		/* A second open must read the last device-private subpage. */
> +		fd2 = hmm_open(variant->device_number);
> +		ASSERT_GE(fd2, 0);
> +		buffer->ptr = (char *)map + (npages - 1) * self->page_size;
> +		ret = hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
> +		buffer->ptr = map;
> +		ASSERT_EQ(ret, 0);
> +		ASSERT_EQ(buffer->cpages, 1);
> +		ASSERT_EQ(*(int *)buffer->mirror,
> +			  (npages - 1) * self->page_size / sizeof(int));
>  	}
>  
>  	/* Fault pages back to system memory and check them. */
>  	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
>  		ASSERT_EQ(ptr[i], i);
>  
> +	if (fd2 >= 0)
> +		ASSERT_EQ(close(fd2), 0);
>  	buffer->ptr = old_ptr;
>  	hmm_buffer_free(buffer);
>  }
> _

Looks good to me also!

--Mika


