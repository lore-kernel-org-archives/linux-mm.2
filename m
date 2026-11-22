Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20532606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AcrfRABr
Received: by kanga.kvack.org (Postfix)
	id 0B31B6B00EF; Sun, 22 Nov 2026 12:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03CD06B05B0; Sun, 22 Nov 2026 12:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F8A6B05B3; Sun, 22 Nov 2026 12:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A73EE6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:37:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C0951404A1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:37:22 +0000 (UTC)
X-FDA: 85463461524.01.622CA3A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E32D1C0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:37:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AcrfRABr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795369040;
	b=LSHYmpC3zznbqMXieOSkJnNv6RtpPhLXI4SQj6cSovlqtl8J6Du6qzEyrP27s0hd67p0Am
	NqoOOMiOMNyggU7NZaQFeKqE2iY6cgu7EHgho8UPRKDc8cw/S04oPJxnVWp6VIln1Yu+2E
	0Jt6dN5oRYDs5JRaFveSQgYxqOtK/m0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795369040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3khkEbh3+4+UW9EqZNzFj2fkzRmCDGkNMhSbTs+zklo=;
	b=4sSMbOeQrdIvjAPhrO16QOSJQLe8eyvGnsjRNsxG7hsDIW3Uv80VJg6YOXUu/SNZXxwDmo
	f59nuY185m9FCMQzQESgD/KWKOvDIOD7d3pqilu7NL2uuc8VvwgguAD2TZaM/deh8uWVTe
	5XBRBChJ1dJ/K82ErjcP1DYZm+Jcs9I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AcrfRABr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795369037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3khkEbh3+4+UW9EqZNzFj2fkzRmCDGkNMhSbTs+zklo=;
	b=AcrfRABrNOwnEhsGrXTjNVPo+MjeXfswph8Vhc8vp8h4kLa88vPZSvuRGn34JPDmmMjLt7
	0XwtepxvuU8GS7a5EQ1FhqSTBeS3lKuW+W9aekKmo9+E/CGqVxJHjiwLElbk99x0eNDwKc
	Q/Distgz3AKHs0SKhtYELbjtO+I5qGs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-kHQNsU1kMSOJgBqpmqYPBg-1; Sun, 22 Nov 2026 17:37:15 +0000
X-MC-Unique: kHQNsU1kMSOJgBqpmqYPBg-1
X-Mimecast-MFC-AGG-ID: kHQNsU1kMSOJgBqpmqYPBg_1795369033
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4bb69d84053so16995645e9.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:37:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795369033; x=1795973833;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3khkEbh3+4+UW9EqZNzFj2fkzRmCDGkNMhSbTs+zklo=;
        b=EAe+DTMb+9lasIDeTjDkKYhNgzQx2aOAc+FRjFywF1Eg5voql9A+Md6fNIKz3QdRcv
         Q5w1wrfvSUvu6kkpUkMYIJLr+wNL4hBtaX9oCZ8vmz1l8WfKfj5y0F7FMaYRtrTiEcO/
         gfv8FCSBPT6uq9JEl1Y1KjIjlFZyng5ch0f597RjJdOQbJVJks+kgb3anyNoE4AwsXuO
         Ztt5iFeCx05D7XwUfez0bGNyzOdOtS2i6TUUgepzVPZlYOUGXqh8puT9RiAG0nl1w/kW
         CQsgWYg157yWbABG25mW77UKSGp+s8tFnjDcG1TBMvcmSCjJL9l3/w6MsvCMAQsRp5fg
         e+OQ==
X-Forwarded-Encrypted: i=1; AL+hErH/o2lzLjSZi20Gsamio9NJIIupOOmmvBklrrrZaK2d8IzDsdp8PQccSRPNM/6LV6TUkmDnwN9Ixg==@kvack.org
X-Gm-Message-State: APuU4Z8oavCHZFWm1rsk09F8WK5+b1MG6zZnYJ+6Q15E827XCbNAMzD9
	Kc457B3NyQZbURm2SZkMIoBQmYHDLay7FXwvRrFLjrEmWEl1+EGe3AGtD1EFnUk+6JSb79765A/
	9vT2P421WQipYIXJmf38kYUfRDoFOb8fF+pShRyYhfCqihAN3Yww=
X-Gm-Gg: AZFdTZe6H+Ielvy1cRkcYpaPEPZn1Wl5lLaEE05IGSfCy7baK/7a4YhuJU4HKQoI+7L
	zazx5BmUqtd80qNwaf8sj/HXAHKt7k/18KaEsbtL6drRXR/1HQspgqMBZP/TQPG1ZpyXKzMJp3t
	fx+R/y+IUk68BbsSSvmTm1NcBCt0xzhWjOrQoUqXQTtKKwbK5IqwAAF5UvrURJXrBLH3TQg0W/D
	OOlDgJzhN6mxue3GaWIpOQ1w3ppZ/EuzzBZi63oNbti5kWJxUttbZkQaz592F5/ZXH3jTn3q4ny
	lME2FHZv/emAd+Yz98/s/SAfp8xKA+IwNYFBwUeWNgBBipVlKY4fQPnxUpc85EKOUMXmqXycOMq
	HXtgpxdWj8WvAu0xstbviUqiIigrfEXJXqvTyUcw6hrqJXH+JknkBeHBekoJCYnto6E8u74Lscz
	DCVAxk
X-Received: by 2002:a05:600c:674f:b0:4bb:56bb:1196 with SMTP id 5b1f17b1804b1-4bb8880fb9bmr195004215e9.23.1795369033360;
        Sun, 22 Nov 2026 09:37:13 -0800 (PST)
X-Received: by 2002:a05:600c:674f:b0:4bb:56bb:1196 with SMTP id 5b1f17b1804b1-4bb8880fb9bmr195003715e9.23.1795369032886;
        Sun, 22 Nov 2026 09:37:12 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm114828375e9.2.2026.11.22.09.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 09:37:12 -0800 (PST)
Message-ID: <2f60e148-f9ea-4b48-b8b9-3c524b6a8a2d@redhat.com>
Date: Sun, 22 Nov 2026 19:37:09 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>, airlied@gmail.com,
 apopple@nvidia.com, balbirs@nvidia.com, christian.koenig@amd.com,
 dri-devel@lists.freedesktop.org, Francois Dugast
 <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org, jgg@nvidia.com,
 jgg@ziepe.ca, leon@kernel.org, leonro@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org,
 Patchwork <patchwork@emeril.freedesktop.org>, Shuah Khan <shuah@kernel.org>,
 SeongJae Park <sj@kernel.org>, thomas.hellstrom@linux.intel.com,
 Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com
References: <179342234355.4.16705453209886955762@gmail.com>
 <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
 <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
 <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
 <179535872126.34.4789080961796247940.b4-reply@b4>
 <af91d4a7-11ca-4f84-b8da-33ee1a585916@redhat.com>
 <20261122091419.f82e88761dbd12771fb6c976@linux-foundation.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20261122091419.f82e88761dbd12771fb6c976@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Gh-7-Mf3UuxCqH-1T7TZAa16d7LXEngPvFAU__dUAo8_1795369033
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E32D1C0004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 7ox3h4gohi81mpajge43ytero8tyqbq7
X-HE-Tag: 1795369039-410001
X-HE-Meta: U2FsdGVkX19EKITtNuULlWZ+niT9PO/uu0RjvxjQADEwFmdFCFU4N7kSQ8Us2S42gGSxAAeWAAFdmre5UPPi9w7lomD77+fmtG6mY3j+d9l5mYQCJxxn6bWxZyrJNVSN1ZptYT7j/VDyxNad+lOCn70rDQARY76piVKKEMqA5j0PA85ICYwOue5tGtywTDw5v7ii0umO0SxENzlm8naezKXfY14WWJCfFryYpNzPzYUqnSzP+RqXIa7gEaDxHFFT2ngSGbtQeBcvAlujQ9yX8ohu5OswS1I4IrP5cgeyA3XCA82Gh+8FUs6SnnJ6SEb6PdV/i2M6qICnncPLcWPNHTGLoTbrPz78VtLZMVerh7dSv4TNuUvnL7Qii5Arjg/OCA1lQ83vGl5ckdmSqTMcQRx6+jmu0W9Bso/U4DDix79nRLipmLrObPb2quBJQ8SOTxDTe0At+V9HJzpzzT8lhw+2MPR8jiFhvgLlBjzvL1bTZIu4NaJ3+6ddywh1ez6RNr/euypJqXexnW3qkfKXgH3k5pXAtF8WuUr27K/MI+ti5yCmILWIJTsP8nnRQbE/ZjGg6FIGynCpHSNRy3vw8CVzL8+XVa0p97LHM7kDFG0lqk+yCc2NmUFZfE/Ug5VoFGFc2fByY5dR888gygk8zY9KXbEsM+YblfhyCHIfeMQJZmmmBZ73whIlGqSP/KoQIKnubhb2gb2ZEtCInhBqeeywx5QTXCxEYSOYTSmrgrych65zoEWO4UcTsah/0gFa5mEgEM3orNiAE3ablXdX4vgxTXJyH5da4HVxUqysbCvFvP1j0A5Xfa6ZXx6I1vMLuUag9q/+a2HxT0c/WAyUzuipVpqRiSqrBj35F9FbyY0/GIZ/t5xipqvFxuYe8afKpnxfDxetnpPKDEQn7J6VIH8/Rgae4BV7nvcrbuIwkO74yMQ0UqduUxcchuoLWazDuE6SVz7qoNIdZ3tA0nL
 p+D78oaG
 cMWNKoOIquIS67oqWsnSgRiIyGpN0JocpZuYSD8y6kNoItx8UgovwIlju4z8OLYcruYRlw+6VK/bDAjeenF7sIlQU/tjFcxuZFG+1+ldax46nuwTbXQrAV36HBc8/jiJsUNM44vI3or619qeyHqSWGwtSq+Tmg+LUd+qhpzMi6oHGm+t2++OEzmbfvoplU8U2OsSW7FL0ipNHknmpidjnQOu8Y/WzKhA8P07M1nXMC7d0E5k6vl8oV2tcRPrXqah40FIU/NxdqtOnVhux3xNfOt/nAvuClIi8IWLAZ3u62dZrlNHcM4P2DUoBuzY1Oa86frFl+f5ML9xf+J3bslI2LNIazY4bRC2K6wq+QMrHdKTxWslQ+VP1WuMNUYyUQKRl7joJYu0yN3jVzts1qOfiC+whJocpVCYvSHd2EX3gKvGsq5NE+c9C7l1ggtvqNzkXcyC0S65KoAivHmqC0h90Apu11PH1EXf9uZr9uqPGbo5fY1CCEoohgyu2x2QRYNUh0A1G7oJYmZGf9XUiaPfHD2ozCHOlcwHNe0v0KN0R16KP5D8xl/eLPA0hsHfTDkT3iRK4rxl4B7dSkqoDlUwwbTKRlAUzjfDpAM1GG1cBBblzDlFkwI/m2i1crrt1MrJE1/kHV/MavIORMTu5vyfamCDJoXLfQYQZfCbeDJBBNMUIV1pQqWhPJtHU8A/kNbisYlVkjuTA5AW3JN3giJhz66CRpvwso15gIZ7QzdHdABPVKaYSxvthfPbM5iQC0VckL5+jOPS7F3SpfC8N8N1LSMK+yDHWj6TP4knYSAL3v1Oafa7OZfs1OhrExNebKr5f7l0pvGffyAP6TlpAmZBRFqGrOyoCdVO2hFuMGU/ZwTmipS28KcQFBjvb93CXPDpZKkfcJAdk5Mx/OXhLshCHS4lgtVRvZy/jcFgAKXhtmbvru6SzIRHgXsGWVY3rb0+P4g2x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/22/26 19:14, Andrew Morton wrote:
> On Sun, 22 Nov 2026 18:41:39 +0200 Mika Penttilä <mpenttil@redhat.com> wrote:
>
>> On 11/22/26 16:45, Aveline Noir wrote:
>>
>>> Hi Andrew,
>>>
>>> On Sun, 22 Nov 2026 01:52:46 -0800 Andrew Morton wrote:
>>>
>>>> Store the corresponding RAM backing page instead.
>>> This avoids the oops on the first read through the second descriptor,
>>> but leaves a stale backing page pointer after CPU faultback.
>>>
>>> Since the mirror XArray entries don't take a page reference, they rely
>>> on invalidation.  When the CPU later faults the page back to RAM,
>>> dmirror_interval_invalidate() skips MMU_NOTIFY_MIGRATE for the same
>>> mdevice, and dmirror_devmem_fault_alloc_and_copy() only clears the
>>> migrating descriptor's entry before the backing folio is freed.  The
>>> second descriptor still points to that freed backing page.
>>>
>>> Reading the same page again through the second descriptor in QEMU
>>> triggers a KASAN use-after-free in dmirror_do_read(), and the read
>>> returns the stale data instead of what the CPU wrote.
>> I think this is right, but a fairly artificial scenario: it needs two
>> descriptors open on the same test device in one test, a migration through one,
>> a read through the other, a CPU fault back, and then another read through
>> the second descriptor..
>>
>> The fix lets the device private page content be read without an oops
>> in the context of one fd which is an improvement. 
> May as well fix it.  I'll test this updated version.
>
> Mika, please feel free to take this over, perhaps integrate it (or
> something like it) into whatever you've got going on?  Or not, let me
> know ;)

I can handle it in the context where it made difference for me.

>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: lib/test_hmm: invalidate all mirrors on device-private migration
> Date: Sun, 22 Nov 2026 08:53:12 -0800
>
> When one open of the fake HMM device migrates a folio to device-private
> memory, a second open can fault the same address into its mirror page
> table. The second mirror then stores the inaccessible device page, which
> can oops the kernel when dmirror_do_read() copies from it. Store the
> corresponding RAM backing subpage instead.
>
> That conversion also makes the backing page's lifetime significant to
> the second mirror. migrate_vma_setup() notifies all mirrors before CPU
> faultback, but dmirror_interval_invalidate() skips the notification for
> every open on the same device. The faulting open clears only its own
> XArray entry. The other open can read or write the backing page after
> migrate_vma_finalize() frees it. Aveline reported a KASAN use-after-free
> and stale data through the second open.
>
> Handle migration invalidation for every mirror under its mutex. This
> clears pointers before faultback can free the backing pages and waits
> for an active mirror read or write. During system-to-device migration,
> the migrating open installs new entries after migration; other opens
> refault on their next access. Remove the now redundant XArray erase
> from the faultback copy loop.
>
> Extend the PMD migration selftest to read its last device-private
> subpage through a second open, then fault it back to RAM, change it,
> and read the new value through that open. The trigger is available to
> a process permitted to open /dev/hmm_dmirror* when CONFIG_TEST_HMM is
> enabled; it does not depend on physical GPU hardware.
>
> Link: https://lore.kernel.org/r/20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org
> Link: https://lore.kernel.org/r/179535872126.34.4789080961796247940.b4-reply@b4
> Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: Aveline Noir <jm5905938@gmail.com>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: <stable@vger.kernel.org>
>
>  lib/test_hmm.c                         |   20 +++++++-----------
>  tools/testing/selftests/mm/hmm-tests.c |   25 +++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 12 deletions(-)
>
> --- a/lib/test_hmm.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration
> +++ a/lib/test_hmm.c
> @@ -292,6 +292,12 @@ static int dmirror_do_fault(struct dmirr
>  		page = hmm_pfn_to_page(*pfns);
>  		WARN_ON(!page);
>  
> +		if (is_device_private_page(page)) {
> +			struct folio *folio = page_folio(page);
> +
> +			page = BACKING_PAGE(&folio->page) +
> +				folio_page_idx(folio, page);
> +		}
>  		entry = page;
>  		if (*pfns & HMM_PFN_WRITE)
>  			entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
> @@ -327,14 +333,6 @@ static bool dmirror_interval_invalidate(
>  {
>  	struct dmirror *dmirror = container_of(mni, struct dmirror, notifier);
>  
> -	/*
> -	 * Ignore invalidation callbacks for device private pages since
> -	 * the invalidation is handled as part of the migration process.
> -	 */
> -	if (range->event == MMU_NOTIFY_MIGRATE &&
> -	    range->owner == dmirror->mdevice)
> -		return true;
> -
>  	if (mmu_notifier_range_blockable(range))
>  		mutex_lock(&dmirror->mutex);
>  	else if (!mutex_trylock(&dmirror->mutex))
> @@ -1198,7 +1196,6 @@ static vm_fault_t dmirror_devmem_fault_a
>  
>  			src_page = pfn_to_page(page_to_pfn(spage) + i);
>  
> -			xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
>  			addr += PAGE_SIZE;
>  			copy_highpage(dst_page, src_page);
>  		}
> @@ -1822,9 +1819,8 @@ static vm_fault_t dmirror_devmem_fault(s
>  	}
>  	migrate_vma_pages(&args);
>  	/*
> -	 * No device finalize step is needed since
> -	 * dmirror_devmem_fault_alloc_and_copy() will have already
> -	 * invalidated the device page table.
> +	 * The migration notifier has invalidated all mirror page tables
> +	 * before the backing pages can be freed.
>  	 */
>  	migrate_vma_finalize(&args);
>  err:
> --- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration
> +++ a/tools/testing/selftests/mm/hmm-tests.c
> @@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	void *old_ptr;
>  	void *map;
>  	int pagemap_fd;
> +	int fd2 = -1;
>  	int *ptr;
>  	int ret;
>  
> @@ -2143,12 +2144,36 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  		}
>  
>  		close(pagemap_fd);
> +
> +		/* Read a device-private subpage through another open. */
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
> +	if (fd2 >= 0) {
> +		/* This open must not retain the freed device backing page. */
> +		ptr[(npages - 1) * self->page_size / sizeof(*ptr)] = -1;
> +		buffer->ptr = (char *)map + (npages - 1) * self->page_size;
> +		ret = hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
> +		buffer->ptr = map;
> +		ASSERT_EQ(ret, 0);
> +		ASSERT_EQ(buffer->cpages, 1);
> +		ASSERT_EQ(buffer->faults, 1);
> +		ASSERT_EQ(*(int *)buffer->mirror, -1);
> +		ASSERT_EQ(close(fd2), 0);
> +	}
> +
>  	buffer->ptr = old_ptr;
>  	hmm_buffer_free(buffer);
>  }
> _

--Mika


