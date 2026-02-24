Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6589FF3C9A9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B218F6B0089; Tue, 24 Feb 2026 11:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8B26B008A; Tue, 24 Feb 2026 11:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5216B008C; Tue, 24 Feb 2026 11:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 893266B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:01:59 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B5631A01C9
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:01:59 +0000 (UTC)
X-FDA: 84479816358.08.B7C3FE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 708494000F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:01:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEthl8c2;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771948917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BDXcNI2YqN6lmgXjZpcpLkddp4E6BdR60/NMl/MAxM=;
	b=0446eLTozANOQKhLVsBahs//vpioAq95cbffPcV49hK41YPE0zo1EW5yHVhj4XIgtlG7rJ
	yPNHO6+PzDLi4xP7s+M+i/JJd6QxWacByhH6//YKHdnZ1zgQHY8luB8aRh6VDH8RyHsFP4
	wPPhmZTTKJg21wZjdxFMMtlkgRej4OY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEthl8c2;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771948917; a=rsa-sha256;
	cv=none;
	b=rGXgnq2pOGPTD945dq/tXhWJcnZ7868O9H0qhGIEczVPuUFRdgctSc/CjUGmxipgymmel2
	HcC3RAkqT8CLNAkyD3M4oPm1xBwYri50ckUzZv6lDpP5sPAEP7RdZ3qKVnkY/PibclArtO
	AWFC/mvPhfzWhGaR+QdbpBySQzyxNOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA6EF61119;
	Tue, 24 Feb 2026 16:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8E6C19425;
	Tue, 24 Feb 2026 16:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771948916;
	bh=Ea+hXzIJv+wTg0d/87xAtGJA13iNQHZa5+cJCODsZ9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lEthl8c2QIs465ffaq3ukR6zfnik6aB+b7lN47dWKMVeEByhpaVuGYA8JZwkX43rQ
	 BPiEEc7jpRiQzGTGzcBTI5YQw/QdF5LtoVqHc12OVRShocGJ2sHK6zQ3txrV0HYyF5
	 AbDIG3Hej3oTSMzjf9XLrpfEIerYhbEka1ryxw0/a8LhlRKRc7QFmtHEXYD8wIHWqG
	 ctDPx0p6nfXqpbT+5GDzLtsMVxHU8i2X4UKFRXCwGkVXGpcqZGdAclTMRKJ9N0UCox
	 Eas26IPj4tIOS2wKgdPEad7FBj0/Gn//CBGZY9PmS7kFC6ees2g+QJ4kNiNEVg6p3G
	 ed9rt1zmQ5v4g==
Message-ID: <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
Date: Tue, 24 Feb 2026 17:01:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@kernel.org, harry.yoo@oracle.com, jannh@google.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable <stable@kernel.org>
References: <20260224110934.881360-1-dev.jain@arm.com>
 <763ffcc5-8640-4b48-8ace-051ff0ccbdaf@lucifer.local>
 <61161337-0d0b-4597-aad6-b5a1aa1ad41f@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <61161337-0d0b-4597-aad6-b5a1aa1ad41f@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9pttyodj1xexqn6d9ci5ky37gj7pp59b
X-Rspam-User: 
X-Rspamd-Queue-Id: 708494000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1771948917-645939
X-HE-Meta: U2FsdGVkX1/0L/uW1jARIfXkHTYOg1f/oO7B6XCnrf9Gcg5FDEws8QV+pjH4YEIew8jMsLCgtG9YlIDx3X6bRPZYRXjbqAM8QaLp1zZCnXt0Bi3wuAWpyut84RycIjTf0uZAm0y/PtOMK1RLlQszH4Q3kutwgZdXNUMjDmHQe0bY/42lDtx+GpmFzHC0EEo7hikCog6dTJZi78KjMqQ/gGJq1AVAxUSG9N7L2uQ9r9XoQSUUz63gWGWsAR5x9E5ozxe4UwU9DsB3w+okA1Y5lO5rgrE7ZLK9ql+/kWdYoE4feXUv5fxN4giQQNQW9upcg15Ph/hsAqL/jmQh6uWnxb2lVlolmM1mD2ztvXUKAxKaKZ+rIMVQ/o5Fc/nHgQNTfJ4MbCcTiAYu6vik8zLqCCK5IfpXRy3eSisjS82PcyYUMcGDsWVVxd9mXqQiNrHqu+vm22wzP2VFBYJBd8PrrFDcXjjuY1mpZLmhEVjlwXUFy8f3TjYT0rqaO+q0qHnp3XC6DaYEOSm9b5+a2uj7u3w+k+f31YVL/rKogI4EAuvLamKm4gWlv6rEyknXchKXvmL0hJWY0KZ0Pexhv+N0M/URbzFNthchTXGc8jtyssYls3oXo3uASs7ogvtHAotJ0TuAhCGBW3He/tYz2nHxpixqWbc10QDDjbRGYP6uAga9Vq/R+j96Uq+b5MXkLo0NycGUqym4B8jzEHGZVpddQjrBbTTRvAKPD9G2lbvSozCS/Fx5GPnPqWMpyT0GuocOhQFrddQrS3lOGLamvExm95qXGhltaWph0p4NANs+fbOh6pvX49kN3YoQ7x0FJKMVo0SigIMhBb2sQzv06wdXsgom7S1t1mUYB8UgcQWrt/3gu1yIyia38iycmTdYg2NPdicR+vdFyCjfg+Wu6cdx40Itkx8/jCxFXp6oKm2Y5t/vQ0rDKGbGUHZAy/4byzvRJlYUiUwrJttrJjDX647
 Y60OvfdF
 DQQqPubueRTLS946veXZ6Ogp7tHrv3EI8bHGkpiagRBeRvg+nOslUWv/KLlXYMoyHlHBxf0vCS5GjwmbnySXOwDWI1JsugC3zFt23HvUzKAw7m2zPT4pzsgGNi8L7RfSQF3fo9PTrPGKyObtH5+9e9BIzFlNZJAf4xw8PlAkZm39KRH6P0JuwKxL13wR/vN8zMDZ+CPae5z8Xajb4j0jnicUZ56CWiDErinYzCpVjfRDK01p+Anm25Cdo0nD7A1GM27Ky3rO49NZpdJirbrXgO4IsVC6ls4IJPTh8MSgsFp+HP/djJYWJiJDmRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 12:43, Lorenzo Stoakes wrote:
> On Tue, Feb 24, 2026 at 11:31:24AM +0000, Lorenzo Stoakes wrote:
>> Thanks Dev.
>>
>> Andrew - why was commit 354dffd29575 ("mm: support batched unmap for lazyfree
>> large folios during reclamation") merged?
>>
>> It had enormous amounts of review commentary at
>> https://lore.kernel.org/all/146b4cb1-aa1e-4519-9e03-f98cfb1135d2@redhat.com/ and
>> no tags, this should be a signal to wait for a respin _at least_, and really if
>> late in cycle suggests it should wait a cycle.
>>
>> I've said going forward I'm going to check THP series for tags and if not
>> present NAK if they hit mm-stable, I guess I'll extend that to rmap also.
> 
> Sorry I misread the original mail rushing through this is old... so this is less
> pressing than I thought (for some reason I thought it was merged last cycle...!)
> but it's a good example of how stuff can go unnoticed for a while.
> 
> In that case maybe a revert is a bit much and we just want the simplest possible
> fix for backporting.

Dev volunteered to un-messify some of the stuff here. In particular, to
extend batching to all cases, not just some hand-selected ones.

Support for file folios is on the way.

> 
> But is the proposed 'just assume wrprotect' sensible? David?

In general, I think so. If PTEs were writable, they certainly have
PAE set. The write-fault handler can fully recover from that (as PAE is
set). If it's ever a performance problem (doubt), we can revisit.

I'm wondering whether we should just perform the wrprotect earlier:

diff --git a/mm/rmap.c b/mm/rmap.c
index 0f00570d1b9e..19b875ee3fad 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2150,6 +2150,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
                        /* Nuke the page table entry. */
                        pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
+
+                       /*
+                        * Our batch might include writable and read-only
+                        * PTEs. When we have to restore the mapping, just
+                        * assume read-only to not accidentally upgrade
+                        * write permissions for PTEs that must not be
+                        * writable.
+                        */
+                       pteval = pte_wrprotect(pteval);
+
                        /*
                         * We clear the PTE but do not flush so potentially
                         * a remote CPU could still be writing to the folio


Given that nobody asks for writability (pte_write()) later.

Or does someone care?

Staring at set_tlb_ubc_flush_pending()->pte_accessible() I am
not 100% sure. Could pte_wrprotect() turn a PTE inaccessible on some
architecture (write-only)? I don't think so.


We have the following options:

1) pte_wrprotect(): fake that all was read-only.

Either we do it like Dev suggests, or we do it as above early.

The downside is that any code that might later want to know "was
this possibly writable" would get that information. Well, it wouldn't
get that information reliably *today* already (and that sounds a bit shaky).

2) Tell batching logic to honor pte_write()

Sounds suboptimal for some cases that really don't care in the future.

3) Tell batching logic to tell us if any pte was writable: FPB_MERGE_WRITE

... then we know for sure whether any PTE was writable and we could

(a) Pass it as we did before around to all checks, like pte_accessible().

(b) Have an explicit restore PTE where we play save.


I raised to Dev in private that softdirty handling is also shaky, as we
batch over that. Meaning that we could lose or gain softdirty PTE bits in
a batch.

For lazyfree and file folios it doesn't really matter I guess. But it will
matter once we unlock it for all anon folios.


1) sounds simplest, 3) sounds cleanest long-term.

-- 
Cheers,

David

