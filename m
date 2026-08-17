Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E985C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D5C6B0878; Mon, 17 Aug 2026 13:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DAD6B087A; Mon, 17 Aug 2026 13:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723216B087C; Mon, 17 Aug 2026 13:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6476B0878
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:34:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D023D1408D5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:34:23 +0000 (UTC)
X-FDA: 85111460406.24.1DE29A4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id B5BE340009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:34:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=o2j6v1+1;
	spf=pass (imf27.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786988062;
	b=2Aijtf30ZHQJvBuMmaX7921cyh3P1utUuHk3U+NYcqacnEs2I5H32XvNaKLXUoLS8pKt+T
	VFszuOkh1W8+4FnWjzdPGFMObSkINQld87MsFcQEnseGFGLEk83mtYdS2Gd54WluS/QaDF
	TvVlN5CumIe6514JX90M4EO1gz/qodw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=o2j6v1+1;
	spf=pass (imf27.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786988062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/80AwWXrivI+neZRMiIV+d6NMNyflzdEuKzM/Rjq8s=;
	b=2Zw+5zoyIc075GSN3c8sJt6iWw6Nrabw8KJ5c7nKLcTOAQkepro7hPEpeI27NRApZuhQtu
	LIpO2W/1b/ZKfiKYLq4U8EUk7lDTZAlgAvpvst1ocz22dU/+JrcFUGuIyh4aAB2S3+6kpE
	poHDTHeRYHp+Qqpd2cR4PtHS2mliV4I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A344514BF;
	Mon, 17 Aug 2026 10:34:16 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A6483F673;
	Mon, 17 Aug 2026 10:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786988060; bh=dQHeVJirWd2OT1TdcvEiO5y7O6Dg5Prwr73YHx3YgGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o2j6v1+1kEj7SSVM9Z8novRqGeoQKzjTsL/kODG2VHN9wav2fIVvYLOOsBj2gcsay
	 CORquf427smN+XQJ22xJ1GiiAFsv6aQMXPknWZ3Y2XT7vP+pbPcXpdgPCbLUA9yDAS
	 bl/pMq5IX9UHlSyIxTvkIItls/szRGWTzY4swwyY=
Date: Mon, 17 Aug 2026 18:34:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Houghton <jthoughton@google.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Linu Cherian <linu.cherian@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>,
	Frank van der Linden <fvdl@google.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
Message-ID: <aoNGGKYZrOlaJ4mH@arm.com>
References: <20260708031129.3503195-1-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
X-Rspamd-Queue-Id: B5BE340009
X-Rspam-User: 
X-Stat-Signature: gmz3rmbzpianz9ycrkeno1m1ftcx8ucw
X-Rspamd-Server: rspam06
X-HE-Tag: 1786988061-719123
X-HE-Meta: U2FsdGVkX19mTUBBZikdwIRzfOlbVMQrfZLAVtcwdxxSxO9XDr3BaHHD8qYuQOJgF+vxNlkKtIHcKzgcV4ExyjavCoHnDgmIwrIqZAluTrJ9XWUgPwLCFAJhwiyauBu3+8BscZ5cNvc0G9hM7L3NZtg1MpzHRj73n6EhLZ8A/PwnA47qt6JqUzQtsDwp4/9TXjBJdfjXix9cqjWgTSGsHRr8H4FrRfMzH3TQIAS84AoUHDBYY2Z/BSgKW9CF77PfWIgm5Njcnr8B+jZZaO51OprBxfs+RAN9PaK0nLttDC/XnR3V3S8h4mRqyp9Vq8eO0bKMq3V7V+odEcrQm0QU9i0peykMBcj8IOopfpn6HN+b/orzwj0JnapIF54BhEbvKW0ju2jH7rwv9hWgfb3zgFK3Jfg8UxZVE9qPRUBxQnu+6vxrcCbsxYlX0ygoxDiFXRivnGu3VnAK4Sfe9otTMSS33voJi6Adxl694nj0aXYb5u+zH6TLxgmrOAYT3o6f9WM2UoB47qKJ/Vjli8EwlW5quJ3+N0TW+R2rzqxjK6XKA3t6EmZaNqkdkTK0jL2L/wDt/iDjxWZ+t/RyF5Pd8Fi4gNkblI1C7g4q/NHKNiJz6aBGbtyHDN7plnEAUV/uXhX+Po8pyK8NlNvbn0yvQEgoBmMY22DgQ7Pdu3N4vxufyLotKbw8BoxEW+TbBo6DWF0eNHgKnDkOtSKiLWCyS+F7lwT1gQs/D0Yxw8gnxAFQAJmVAcr8nXEkh9gV9He//kws+Aqwy0n/UtHl28Oz6O1D5tASQ1nTWaHzAYZnCxkmjOoaDWtu/A4360wQd3vjPRlMq2CYIacrJk2Eo/+pJ9pbsPu51kCXtMx/0TxIGUADFLa6+HbC2iz5k7eWjSmYVGcPBy1zxgbnxg9aOI3cyp+trbYRVTx90eKh4iAeQOBqGfyaYwNa2vmCjiKzVRfkmNFLKm5OIwPka13ykY9
 6yl8oM86
 J6aOo2FifbEZ/MGGUjSkCttauPNTOqIHKdh9eDJLRukkqrwep8GgGw9ks7n4kvK/mRotnKEf3B42S0oEl1N6laLK6rNIEG8muW28VdvVKuQwwEfkIJevMifKMp/FtvynMCSMtPalJuzA+ld+RZO4Z+wyJ2xb4V4Dtll/+Y5c9LF542mHTZLco3z/RZGIdcz7NZGXt5A4QJ3bDpFKl9LbCIthxnHTvwjN/QZ+C4P45S+RcigM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi James,

On Wed, Jul 08, 2026 at 03:11:10AM +0000, James Houghton wrote:
> The following Herd litmus test demonstrates the PTE update routine:
> 
>   AArch64 TTDFaultlessUpdate
>   Variant=vmsa
>   TTHM=HA
>   {
>    uint64_t x=1;
>    uint64_t y=2;
>    [PTE(x)]=(oa:PA(x), af:1);
>    0:X0=PTE(x); 1:X0=PTE(x);
>    0:X1=x; 1:X1=x;
>    pteval_t 0:X2=(oa:PA(x), af:0);
>    pteval_t 0:X3=(oa:PA(y), af:1);
>   }
>    P0                | P1             ;
>    LDR X4,[X0]       | L0:            ;
>    MOV X5,X4         | LDR X2,[X1]    ;
>    CAS X4,X2,[X0]    |                ;
>    DSB ISHST         |                ;
>    LSR X9,X1,#12     |                ;
>    TLBI VAALE1IS,X9  |                ;
>    DSB ISH           |                ;
>    ISB               |                ;
>    CAS X2,X3,[X0]    |                ;
>   exists
>     0:X5=0:X4 /\ (* First CAS must succeed *)
>     (fault(P1:L0) \/ ~(1:X2=2 \/ 1:X2=1))
> 
>   (* This test should not violate BBM requirements. *)

We definitely need a clear statement in the Arm ARM around this. As
already raised in this thread, we can assume that AF=0 entries won't be
cached in TLB but there's more to the BBM rules. For the dirty bit, we
have R_SGJBL, we might need something similar for AF in addition to the
BBM rules update. In theory, I think your approach works but we need the
memory model experts confirmation and the Arm ARM updated.

I'm not entirely clear what the above litmus test guarantees other than
not giving a warning. On P1, X2 can be either 1 or 2, otherwise fault
but that won't happen with HA. I'd rather have something in the 'exists'
rule explicitly (like a TLB conflict abort; not supported AFAIK but
maybe that's what fault(P1) was meant to show?).

In addition to the above test, I wonder whether we could have P1 do two
consecutive reads from [X1] and check the read values. Maybe go through
a third mapping, OA(z) with AF=0 after the TLBI or just start with AF=0
on x. Basically any other tests for coherency like read-after-read etc.,
check that the behaviour is preserved through AF=0 just like going
through valid=0 with BBM (that's something that should eventually be
runnable on actual hardware to validate where we won't have a BBM
warning message).

-- 
Catalin

