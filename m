Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F37606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 22:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pztf3cph
Received: by kanga.kvack.org (Postfix)
	id A453E6B0912; Tue, 27 Oct 2026 18:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5FD6B0913; Tue, 27 Oct 2026 18:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5B56B0914; Tue, 27 Oct 2026 18:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45A326B0912
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:55:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AAB4E80B12
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:55:27 +0000 (UTC)
X-FDA: 85369914294.21.BCCFA2E
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id D50071C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:55:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pztf3cph;
	spf=pass (imf21.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793141725;
	b=HBsb1inQJE2tNVAVbhkMpC8cmjA0PBdXE4mu68rEjWcVYSe76sSGb+J8gxkTKaAox6k+d5
	cs5oE/Z/E9qo3O7ue9bPlbWxfdrjcJQKyWDi3MEcMutD0ZxB4xa6a5xq6KmH+uPHU20NVZ
	N4hhvBfs+0YpxPeSmYbo48NWLz0O2Qo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pztf3cph;
	spf=pass (imf21.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793141725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTV8eg2on2B99kAeZJ8uQmhlFR662/OZM2R8QtayN34=;
	b=gNTjxXMVwd02AABxJy3NjxVaRtM5Ctjl6L/vP5UT0+khJWEXoSCJi7xIKzB7hZINjLEFha
	12FtYA5yRsEUq8pf01aQymZTfl1ulsbK10OMmvAMFYopZ9O1Gzqvws6LUIMNZp7a7VBc84
	QbR42nd5yHX8wuiRja0GD4oMQpGLRI8=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so13425ad.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793141725; x=1793746525; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KTV8eg2on2B99kAeZJ8uQmhlFR662/OZM2R8QtayN34=;
        b=pztf3cphSuqkkQoN1qnK3DkVumZEP0El6ngs72LcXqX+J/mQ+ZZWyiFO50CHGDhK7S
         sFDUDHzxqyDRJUVvRsDk0xUy9OJkCQVpOekSUsLDRNIiHOwNFMqJZYrwHc7Ajdw2LPEg
         PlEgwayfR4EScRDxVA5zyIhwaWhj18mrDm/ZKKo5RSqD1csgFCq31oNG/1xyWYdPEKSF
         83Vju8yK3/XJz3ErOhFWo5YCzRAVVEXr+6Cp+x2eadC0VXMMz3NKDCnBMEds/nAUXfa/
         jcMpZmc4f7VUmTEw+Nut5hk44kvCOUQnnkLCilHxcI7cy+64p9HyqIxdKjl5lor+Gk6b
         QaoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793141725; x=1793746525;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KTV8eg2on2B99kAeZJ8uQmhlFR662/OZM2R8QtayN34=;
        b=a7K0XCIEGgtvMMiNN4eFG2FA8E3DPrEcFv/6u383m5A3DisrX9T9seGR1osUAHdBhV
         RIAO9mZYJwlLuJQv1klnQgVSgafTtmDqWF3eyjL7ZhhFFILEnJWrNk9ZUgP/mcFUR5eU
         QzwF4vZyjNtPjusB98U0RL6RMny++pO8N19u8Fv1ceBm/irxaWXwKjSSdpQdkcNJC6Ce
         U7ZWgT4gUgDm+sQu16KqpinstNWbYgnjbrysgil/4T4KwKVLueUghDTlLOcBGs9TOeI+
         Sk83UBN+ofjrcvNRsvRhwZv31QCbiB6KNx88YhJZJQcxOif2ysFLBKCSjvDB8tylRlUR
         oB9Q==
X-Forwarded-Encrypted: i=1; AKwUvBxWaMf9XshZW7C9UlHW+zICFMBPMHLF5uS5lM45IkB2nHUHc/ncYjsYuO+xhuTDZWrNoC+sydCFQA==@kvack.org
X-Gm-Message-State: AFq9FYKHuD8nc6fJMIR05PK+FdaEVdy1BPXwwvyIUJvKTwLF19yKLXzv
	7/wXk31iBWEqDnSAJqnFzxH9+xTv59agOwzPVV0F/SVMGVd8kypyxcWCfQmkZcmSow==
X-Gm-Gg: AYBFou31JwIR0S3Y8r3+Rj/WMssEW1u3pEokiEJ2vBnqUG9t9YEjnpVToetEO9FVK3M
	Xte3t7hJDx1BqlkgYJe9Duk6R8lf9TqBbUPzVuf9d8mBlYxK8ccHDSYXbwfUYLWsabkbfUSELuQ
	itPl47dFK4hGicseD2ZAiG3mFkrpRUdsGR9rhT3XW9bdk/ij0koX4ZXnlCivfuzh4tMZMzd8zjQ
	y3Ea676GLP3JXyp15hWE0PXU/KlAvCGgtHcxCVmcUq21VF+GBsoyKzNKXs5N96xAIDpn5sxa97W
	UdU6LTVyRqmSieHPuKRGbu7CnNyiy5KjEAUA2pOoFm6E72CTxPcwKoeg4H99ruSU5TAx/HiybJ0
	Tl7jTMoYZlGnya3wdzi5W7kOgxMwjTB9iygnNk6rL9N+IR8BKySLYgAjD9PnzTzNESIRUJpEtru
	sz+JZcq4GGyesXYDl3t0m+921W2B80wqPE5oytOFgw9cVcv2ie3PF2/f3Sta6BSEojKjJtyNr6E
	hNyVnK9ZxKhGGSy6HKYuWQpd/t0tJ37LxCj43uw+na0c6gQvReTAaBUP4kU5gP13TG2oBbQjKSu
	ALZoSksD1iE3RXHXKLd8QJK03sZ3Zy7A71EtKQfrvFyl2nt7QGymUcK5PZikQ6tAICGqcZUFHKi
	3bgmWNIrBfdmIFAOljSJLsg==
X-Received: by 2002:a17:903:11c6:b0:2bd:3bfd:74f1 with SMTP id d9443c01a7336-2eb0029f8a1mr1832445ad.2.1793141724187;
        Tue, 27 Oct 2026 15:55:24 -0700 (PDT)
Received: from google.com (163.1.145.34.bc.googleusercontent.com. [34.145.1.163])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a662e1fcsm516911b3a.30.2026.10.27.15.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 15:55:22 -0700 (PDT)
Date: Tue, 27 Oct 2026 22:55:18 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <auEksxfAi9lHFXmT@google.com>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D50071C0005
X-Stat-Signature: sh673wefxnzyfbx9hyuqt8b5b9gbak7h
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793141725-107325
X-HE-Meta: U2FsdGVkX18dU1lxV6mHhfl4SZF3qcHljC3OZHSfn9NGolOvNL3f8O9wsS43hFBera2m/JCfnwVZSd4fRmrNS3OzDU5Vs3xYffQfww94O/RgGx+p9cbYfWKK1u6kVr8T7QYUXGqQpuoa282Sdet+2jPn7xxutSwvGA0gZYAeh3THcV+l6IEp8Peh+3IXNuXmvTD9OvZMN1J6qp1VrQ7E8fEfdpfQj1UWftqGqYYwxureS0sV4BsYxXRMtlpcesSMu9vgZ4MRP0CwKm+qM6IFJF65t1wss2cGh8zAfZb9MdMs21lEMYTr2kHMrcSHnDVFSQF4Jzlw1o526DW0Dg/f1d6AMkv8q5AmglNH8YIA0jW63VE7zRAZoBY15YrusrE9eegpTkECH2i7vTczVUyr80HL8XaeybxriN6glfEcYbELQLft8HtoDPCHvflC2vdWqgfaVzK8Y/UDaVGBr2Hc17Q2MZzCZ9GvDke+NAKfT8D9FmwF0XRBSA7y6dK6tVtd4DlplnrxAsNGwag1bkmr7KiuOIdrNuioWp/qvUA2wS6v5vlGbEIJzFsL62+UQpSKjp+DLKw5fSYw65DIXHUNT4AhQrXn2GxmrlqoLCuBeZjW6vqFWzmhpAdnrYaTDlvb8F/PuNHC22dhSy74LeGfQZUpGJdX0t7W0nZR0ElF7G8EyaHvE2+nBAab27g52HMiWxqt6M45LDiZipusBPi6VEWuz7Oar3sXyzQCEfs4F2zMn/WknxIScOYus697P/6JfJrl3Atq/9vZWCDJqop7qZxCE/HZGiLVYl0tX5qfRtgXuyo+eXmKUbeR2jQJ55tcanwrn+igpeSzEYY1WDl0uwZCwaGj8Qlk3OtthXfIXqSUUhgl5u7IsFRuNJxJoBexHG/xOcUQtMhrM7t+5aJ7zho7PfokBGnvm5Z02nU+g/Qr+fEa/V69wGUYRiGaCKxNzzClS+xi7U9a8x3SIbB
 zNStM0d1
 +O8KTDeAFAtBAG9jHmyOkAJdR9p8O6kObo1FoK8YmNLOs8RaV1klBkx3IoiabOelhad0fdxSWN86ST9A4jLhtPcHdKZgEyifhjEudjstWakb1obpKC/PaoejcZsvHeAaW+b8cIgCtSny0oU+Q5jHyuqQ0e22ptNtqgVhHdwPmKx+A3BfC21OyKZcZxpeBFJcBDLPNus6AX4y2kSeVmUsI5NSISyGwX8qPDHKOWWmfj53RqCAsH49ZcC32FJxJV3MkBoH2kE5VPbgOInmeZlkH8njoZW8rZzEpvXrgTfwUB+cbGGbGVgqYXl6POI3DFO+ZJHjD07o5AOMUVPEnXdc83WNnW+E4WQc5NQGK36iS9Aym1m7YmqZlnRsBpSyBMrf6O/75EuWXB1ffef8sWsPAe5vMZzC4N/Gye3EXX9ZBjt4QK918hEmAuCIJ7YT9LVhDvASNkA8XI0WwPf9DkQSBYaj+IFNqrBrgO3dPbNR43jDoIecguZznpbgwRLDv13nVZzFqJ1F7xlNUT00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 03:46:34PM -0700, Andy Lutomirski wrote:
>On Mon, Oct 26, 2026 at 3:06 PM Samiullah Khawaja <skhawaja@google.com> wrote:
>>
>> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
>> holes from being punched into a shmem or hugetlbfs memfd while leaving
>> the file fully writable.
>>
>> Background
>> ==========
>>
>> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
>> memfd_pin_folios() to pin the folios backing a memfd and hand them to a
>> device for DMA. Pinning keeps those folios allocated, but it does not
>> keep them in the file. If userspace later calls
>> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
>> the folios are dropped from the page cache while the device continues
>> to use them. The pin holder is never notified, and from that point on
>> the device and the file silently diverge.
>>
>> The existing seals only partially address this. F_SEAL_SHRINK prevents
>> pages from being dropped by truncation, which is why udmabuf requires
>> it. Hole punching, however, is only blocked by F_SEAL_WRITE and
>> F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That makes
>> them unusable for memory that must stay writable, such as guest RAM or
>> DMA buffers, and udmabuf explicitly rejects memfds that carry them.
>>
>> Proposal
>> ========
>>
>> F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
>> fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
>> -EPERM, while reads, writes and resizing are unaffected. Combined with
>> F_SEAL_SHRINK, it guarantees that userspace cannot remove pages from
>> the memfd while the memfd remains writable.
>
>How does this solve the problem?  F_SEAL is about a userspace
>contract, and if there are existing users of the APIs in question, it
>makes very little sense to start making those users fail because they
>haven't taken the appropriate seal.

It doesn't change any existing behaviour, nothing starts failing for
users that don't set the seal, and drivers wouldn't require it. It's
opt-in. Userspace that wants the guarantee seals the memfd, and a kernel
user that pins it can check for the seal and rely on the pages staying
in the file. For example, the iommufd live update path could skip
verifying the pinned pages at preserve time when the seal is present,
and do the full check otherwise.

https://lore.kernel.org/all/arVYa_90j0oN1hnu@google.com/
>
>Would it make more sense for the drivers in question to set some flag
>(refcount?) on the file to block hole punching?  Or perhaps to have
>the hole punch code notice that it's trying to punch out a folio that
>is pinned or otherwise referenced and to refuse to do it?

The pins already keep the memory alive while it's used for DMA; the
problem is only that the page silently stops being part of the file.
Refusing to punch pinned folios on every file would change behaviour for
existing users: fallocate() would start failing whenever a page is
pinned, even briefly by O_DIRECT. A flag set on the file by long-term
pinners would avoid the short-term case, but it would still make punches
start failing for existing users of those drivers, which is why I went
for an opt-in seal.

Another option, closer to what you mentioned, but opt-in, is instead of
sealing the whole file against hole punching, a seal that only protects
pinned pages. Punching, shrinking and truncating keep working on a
sealed memfd, except where they would remove a page that is currently
pinned; those would fail with -EBUSY. Files without the seal behave
exactly as today, so existing users are unaffected, and pinned memory is
guaranteed to stay part of the file.
>
>To some extent, the issue you're describing is maybe broader than just
>the APIs you're contemplating.  If I open a file and then do something
>in thread A that GUP's the file and punch a hole in the file in thread
>B, I'm doing something weird, and I can imagine plenty of ways it
>could go wrong.  (Especially if it's GUP for write.  I hope we already
>get that case right.)
>
>-- 
>Andy Lutomirski
>AMA Capital Management, LLC

Thanks,
Sami

