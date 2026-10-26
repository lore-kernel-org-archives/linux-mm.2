Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29711606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=CJjg7Ks8
Received: by kanga.kvack.org (Postfix)
	id 03DA06B05B3; Mon, 26 Oct 2026 18:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014766B05B4; Mon, 26 Oct 2026 18:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E455D6B05B6; Mon, 26 Oct 2026 18:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5AEC6B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:46:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F2CC16056F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:46:50 +0000 (UTC)
X-FDA: 85366263780.18.12F7DBA
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42E6E140002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:46:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=CJjg7Ks8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.41 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793054808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKnr+HaOzY7Irrp2H9F7r4w2uph5h2kmhEeFaXwyEMA=;
	b=8RVAKueR3dAHi0Prjhb8b9ZCpNIU9AwKDP+8H4ZCCBHRQ2xxl4lkVkCYTaB467smaezSXX
	2QRnd+QP+JfgAagV4xlbVizKhfxOImOYSd8Cc8RQ1l6kj4Jr84PJigeroLEIBMklv1XZ9X
	GijZGJp1Fp5qG8PDKKshewy1ED/wq30=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=CJjg7Ks8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.41 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793054808;
	b=EW/5Hr3FAoy4UqWzLE3tjzu3lg6id5IfChWCrr5SjsXDQvgEYqrhJBqQKmJh5/Tw/eoP9E
	1ZnHCXZhDyI6N2INwb/IH/z0eu5f8V9gNGQaT0q2q6Lrq0agaEFhewI0y9644XuGpOYNLv
	2uU0HJmRxfchY3gW9fK0gBKcgU2S91g=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5be47aa555cso4060585e87.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:46:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793054806; cv=none;
        d=google.com; s=arc-20260327;
        b=aX9riIlSPlq8VMbJb10BDU1mc1zH9yiznWqfF5O2XjZLyLoIIPPEA/qq8MUIt92Bc8
         OFhsqQjJAlSbHQqznM8cOAo6/Yar+JcM4XB8gpAAo0Uc1ju61rR6dp+nU+KPrcfBqH3s
         0YBT0iVrCFW935sQ8M/YYuPjDzxRuZGEsGQq/Y30Iuw60ZCJWi587bmf2jlZVSo54n4m
         OiFLB4wem0qMrzt3dUw2CsXGTUCBb74kQyki8FdkASV2ZvHtElV90hBjGXL5lDqFirCJ
         aTIsuR7pmHe/itE5QOM39FNMJkE9N6Al7QlTzfhCdYu7tLANOLTMgIndpCggZ7E+8p+o
         WQyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sKnr+HaOzY7Irrp2H9F7r4w2uph5h2kmhEeFaXwyEMA=;
        fh=AzYjr0Obxs9+v9ztrgzBJQ8DPB+mbC/p3W4I9KCl94w=;
        b=fREzAt8EEYl8qRodg+JxTaCNAjddoUIvAtBiMeZaRUxEmga6mvlXYgBvUL67V6u1hg
         rl6O85jHuXjo1WvRIIqqZYTiO9zmzYowmME23FnCSO+VDBsz90k0ECPWc8msVI2U2Hvc
         L5Xoxu79dXwLhJQ1VZ+4fnRMw9zClyD+jtJCMB8S4ssNdA9CdhNw31GoiOmLydADe3J6
         yZzlOiYwchghjz5UdP+zmjvDtI3w44MfOU7bJ6T7A/Lp7X6wGSzw+1gpnNDozNFNIZnX
         Cpy0Ej7NzJvZwlJVP8fyLm47FNuPmPS4SNj14rkEeSuopE/SEttLIZWPZRrXoUCTftUe
         rhqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1793054806; x=1793659606; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sKnr+HaOzY7Irrp2H9F7r4w2uph5h2kmhEeFaXwyEMA=;
        b=CJjg7Ks8abw8gr1axbaSe3sxUZyAszdvFVvp4GQQ528W3tLtpiv77lrQiy23Tbu81F
         MmDfVBkqIxD/ImINBH7rv+7pmB4ioJ0ver6xHEwPqr/B1BrcGnpAsSEqQ0LSBB/4C1kJ
         y8xtnh0v+kRfNtBVmDVmfVVNXeCXUnOKB3bwHoxYx7GBk+bBRC0RYMyJrMvqXHrQstdO
         9dvj/i0of2W/MijoW4TvSwaG/FZhLgkNOR2/4YAf6H9MwzEIPIIuazzyIy7VxLfHmtxf
         Mj7s7BHMq2KX5vYAJgFAwrdlUly/zVJDuJyO90IQ+pvCx2ofEDb6DBtzd1qhUvsUchtu
         IGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793054806; x=1793659606;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKnr+HaOzY7Irrp2H9F7r4w2uph5h2kmhEeFaXwyEMA=;
        b=oNdcEhFmIMCF/c7AB0AC5/yWwE22rA416BgQ5TJH51yi3yNq/FSejdtjfJpeqXa6lR
         JM7EZXwQt9yQFpAv9445y7Ox4mLHZGqhdDUu10gOTT/ilXTytw8AFPX1Ml5t/4YKVWDS
         WrcqQfeLhs7pjpqDWt1eCvpdXlqU72elZptATAhiF/VbiDAaFfj9PL1l995mhBPg/FzV
         ETxGSduA80IN/d0eCrcREAzm/lrvbcZxFiEcfbCvjkdoK0XSk+gVLmXntfUS+QhVMEgZ
         raxQLMXAnjc+nrVnqCrEoDaGy0blPNJB2HViruIMDJUDY1cxjZm7dSTuZaRQpWtPtHZI
         Wgkg==
X-Forwarded-Encrypted: i=1; AKwUvBxKcnQ+P5OcV1h/kFvn/Ujm9dYKzcPepo1FwIzc0pibyB6joixJV1QhQUPuiAbzW7IO8G+wb1Bn3Q==@kvack.org
X-Gm-Message-State: AFq9FYKYOt9tsu0RgYyO/FqCfTP8PGD20Lm7vboDN4EAzt+EpoPHVgzH
	udA6OUX3vv3kmb14SgWaKOxSwrNEbFytVP7fnzds/k/smt6zO/8lfydAV+i3drxtfDNMaHidMxP
	641DFql2kbWVsbJ++Lblm9MIvXe3UjUBW3go6bWHM
X-Gm-Gg: AYBFou1YrcE5HhVUB/cspYFMzmVOGMMsow/zontRZxhQKo/VwvlMg0btjG1EGwa6mrH
	yci8WLThHh5Ivbb3RUJFOKJd8VCEDunKGbFBH8b9D3+cv+D83ePqUQo49bbcRjiHt7e3vHYqMUK
	CPlnoGaoX8p2fW6Cnqg33wPIUc5ROCjFnXq/fGAxPJX1lRIaGwJFVntgcdWSwNPPSOgwluuJIVE
	9KZ/nUYysU9x4Tt24YQwi/4S1EuRCZOhncY4Y3YYH4ySsEdgqdaI8abep7/CltAwbi+QJ+3reI1
	84BVxPrn5rwxiBKY1+I7KIwOokBQNYDoHRpaVescF8H8tFi6KRcu6akWmrSmeBLf7i0okCR2hW6
	jn7mr9SahnfbFNAVsgacdbGVmEWzwEV59Qw==
X-Received: by 2002:a05:6512:3e0d:b0:5bc:e28c:1349 with SMTP id
 2adb3069b0e04-5bfb71fd555mr2854881e87.56.1793054806319; Mon, 26 Oct 2026
 15:46:46 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com>
In-Reply-To: <20261026220546.3114241-1-skhawaja@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 Oct 2026 15:46:34 -0700
X-Gm-Features: AclHuK_ddIvC0f7JBYWchwOFfRRqT-a0AZ_RsWY_MxD_DGe6_YpRsBjkP2gzVDw
Message-ID: <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 42E6E140002
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: oxswcwjm73r7czgi8jkbifh591mix69d
X-HE-Tag: 1793054808-2535
X-HE-Meta: U2FsdGVkX19myefGRV380ZAR7yLyT7dN7woiCgMh4k/uTSIY+SZu9XexH6qaJ4snEdDXs6SQtXPDmzoSqMIQ8svkswZAmQOdPxu6qoPb48zr9ZkwayL6xBQbi3Pfk9DrPFskxjq/D4HgaWaDL8rIHNPN/hpOJLXMIJXJ7wOG5ahAJtb5yXngBEPUEdxL/4zL61mCslPrC/fGqZu11iR/pE5ErYB/cOCBcvKPxq2m3n5YAbannvvVNfVPNUTityFn16GAhb6xtTQxMg+RrpBs5vjVQrWPU5fku2uGOAmQRxmPZ7ws998BH0gocOiedWEAETPaRbWMzwnsanDvrPX1ckbeePbapr5AKFuL3J4JYh7A9PXtYdGXIW02jMAfYbUPF4lkhqpBvWRtZ5itfh7/9O/8zXjnNqQEZ+6i831stZS5FnsTCGn6lygjRo59jLZ1oA/IkFMxkXZS5NT9DE9sjdKVDEeH6UBjLss80MefGdTVRP0l0ItXOvpW2tQ5BFfBqtnFZTpOoNvsKgia/usrEobC/JPhzRUYs0nInRBwpH3HlKHQ0ogmt8O+2Cl+z2eXWy3LyJXkO8f8fD8Cy7jqQjXFJWzNOWCRHKXtS2YKREmn9JMUr8Mm58ik66sjnYbYvhrJn2xCT1IkmZOKNVVxRGLJmDk5nAVGPyi+eiwYKrlsLSsyqfbpfprZrX2xrmC1d36z0NC/KdjRcL21+MzSZLflYlkjGFjO0kHgKXocucR/oPpP4pRPz3fqtdJSxJSydp6QHkU1bIMPiV81OQJ6lEbAstXnpsZFLrvgiqT7WwTYlCk5GLf+cPh/K0fkPcjk0XR6tbMSYOgaitOCS7a/wYQ+rtd2AexA+3cNYKE6zGR8q6wWZS6pYzWuhmnSlfiRLpJEUN/X/hOVzhL1xZ8nPSuFAf2Dd+9Rq/1n1xEuVvplga5wR4c/4cfOhHopexXGYP3JOi7pA0ZeHvWQp7r
 D1XcRLfR
 L9jpHcZtfgKLAlfZglwr7zuTMohXW/jqGWxeFcTlOn4aWQc5DpjF4LRp6wlTAeqOt+0N2StzH6CE5NcogymM6lWydUvl3BFmQSWZMDAAJvN+17JoMZ8GUmrA4LAOtwRWuGLHB4VJYacgV/n2In87gSx46UR2d2Lk42jj0CIX6LAg67WbCVN0ZkAaenTEdex7GoZpvob9Y+2qALgUcCWjucCZ3jA/tDUhbEd3Ig+XEH1JO71M9NMUXhJWt2bDiXMQdJ8wq/XilVAlZxhOcOhIsEcQFjnBH0znKi1Wzx9NDqyWrHqKBhpJqqlT3v0mO5ixI49edQT/YYho5i47kw1Ga5DMLDbrjL+j/mTIEnMe1gFtuVQvWXoU3LvqrkclxgXRygjdOVMaXB5+HkgzrhlGbGdu1nOeyDHGmIppxTLuCSN/jLHZeiYxDkYz9GDNECki85PD0jUlnEJ5fvG0hbKotb4lMxhGqcKrRsNdt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 3:06=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
> holes from being punched into a shmem or hugetlbfs memfd while leaving
> the file fully writable.
>
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
> memfd_pin_folios() to pin the folios backing a memfd and hand them to a
> device for DMA. Pinning keeps those folios allocated, but it does not
> keep them in the file. If userspace later calls
> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
> the folios are dropped from the page cache while the device continues
> to use them. The pin holder is never notified, and from that point on
> the device and the file silently diverge.
>
> The existing seals only partially address this. F_SEAL_SHRINK prevents
> pages from being dropped by truncation, which is why udmabuf requires
> it. Hole punching, however, is only blocked by F_SEAL_WRITE and
> F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That makes
> them unusable for memory that must stay writable, such as guest RAM or
> DMA buffers, and udmabuf explicitly rejects memfds that carry them.
>
> Proposal
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
> fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
> -EPERM, while reads, writes and resizing are unaffected. Combined with
> F_SEAL_SHRINK, it guarantees that userspace cannot remove pages from
> the memfd while the memfd remains writable.

How does this solve the problem?  F_SEAL is about a userspace
contract, and if there are existing users of the APIs in question, it
makes very little sense to start making those users fail because they
haven't taken the appropriate seal.

Would it make more sense for the drivers in question to set some flag
(refcount?) on the file to block hole punching?  Or perhaps to have
the hole punch code notice that it's trying to punch out a folio that
is pinned or otherwise referenced and to refuse to do it?

To some extent, the issue you're describing is maybe broader than just
the APIs you're contemplating.  If I open a file and then do something
in thread A that GUP's the file and punch a hole in the file in thread
B, I'm doing something weird, and I can imagine plenty of ways it
could go wrong.  (Especially if it's GUP for write.  I hope we already
get that case right.)

--=20
Andy Lutomirski
AMA Capital Management, LLC

