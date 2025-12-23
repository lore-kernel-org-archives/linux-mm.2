Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CECE6F090
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 14:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2F66B0005; Tue, 23 Dec 2025 09:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB0C6B0089; Tue, 23 Dec 2025 09:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301236B008A; Tue, 23 Dec 2025 09:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1EC486B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:11:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F25F21A02DE
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:11:26 +0000 (UTC)
X-FDA: 84250923372.26.265A463
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4C52640002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:11:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ud+384l+;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766499085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SCw2xOoCGMv9XI4vkf/eEiR8q/3R3I2p+RcR2Oh0c+M=;
	b=L0Na7ZWLVho5Z5mBZ8tTnu7B0sGUPbQr7z0YXtL3ql+9pup3VrJ6ddBvwqObgqi3Kolth4
	Nn18dR8nRPA+CRRiCymm5jWNBQHLInXMP2NnFefS/9+bqZ04bhPQJfWqVvPbxj/HZUg6NB
	umANONVa72KBsVep31OZg0DgpmiYElI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ud+384l+;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766499085; a=rsa-sha256;
	cv=none;
	b=LzTlep1fFXKkugekTlAL0t8JofmxbMWtHPIAywJE1TP++z9tbYpGUPnEmERlWg/4fxqRg6
	t2h5Tibe3lfDGng2Uqf9+/2XcA6GXvL7TGAWtUxDe4BnOCeakQ04MAg+bJQsvbl7TeZV9A
	dcPrSwcGazdPFEQXl9G65n7qSZR9EIQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BA1542DB2;
	Tue, 23 Dec 2025 14:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA65C113D0;
	Tue, 23 Dec 2025 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766499084;
	bh=dZ53vjUX1HpldK0KbUzIHXXkt9MCtOBq99PLYBLG+Vo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ud+384l+yB+aELzmFdX7l8ibIN7y+5+njLdeHK50/JSiAcJyiiGlkjjdtAKjHeBD4
	 hoQuD1jM3uSCM4t9yQgEceDsegFq6IHknfeOcqrWnRbDrmwKbx/RA2TtkB+W9AIaWW
	 voxc3Piq7yG30t/8HGvKwdBisNooq4awkV/1xR9nwZDAn86BqbV+te3BncQtbUoll3
	 MjnbP3UmazmSq+nS4COmTb0OMtg5b2lQ0qM6+wFgaUOohKM9E/7DLArNeo0fBID4QC
	 GXqFpHbnzeiMJN9E79HfRc+ILd9QLcZVOFEqn6kc68RQBGIYIJXCqWSpdHOreAc7RR
	 jNwu3Li3A/NVA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  rppt@kernel.org,  graf@amazon.com,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  pratyush@kernel.org,
  ricardo.neri-calderon@linux.intel.com
Subject: Re: [PATCH v4] kho: validate preserved memory map during population
In-Reply-To: <20251223140140.2090337-1-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 23 Dec 2025 09:01:40 -0500")
References: <20251223140140.2090337-1-pasha.tatashin@soleen.com>
Date: Tue, 23 Dec 2025 15:11:18 +0100
Message-ID: <86y0mtb855.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ucqopy9yhpfszmw1u8msrxr7xa1otfuc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C52640002
X-HE-Tag: 1766499085-465269
X-HE-Meta: U2FsdGVkX18gBDd382Em7vdo2gqv7Hclti0srRJyeQz1bmqrbYeT3IQc1QJajCBjGE4KfdQ5hHyrJpZ+4zy58Ysoo9Y9cjsZiXdIYdpJef6Z/KBCg6Nx+cBIBIRqMEQqIGFAYQHgj5fRt4nCOr3uX8phMGJ3zRGqL6ROLxQ1rjAh0Sv1SzMqVReVCnSAWYtHCd/JrpGCjw18tm6jJ3/yioOoDjNm77XdjzunhOKKQJWLnQKCzTFFI4lhRihulFehXqp0Ru05jv4HDzWmN4MVYjV3jYZoZQW7TqosjjTp6C7kYCOWFzegMMqtbsu48+zIeyXITGYT8bWcYKuXWjC4EGMvAkx4jsal8+zYFf6r0nHrDVVmxHMF9D0Mahpyx2gZP37ieYf0yuBEDU7dlB5Tq9Xcqrru1UK+k4eQlE4Gn60BKjN5j/PAZPudHbxO4XeiVeC8jSxuvRowBpEHMM2D8oUWMIjcxsZg6Qs2KwTuHRIpMgjcHCTTDxhl9oQBr49ovC4LShj2TSzpWTab7eg6/yFVAz2lJviCHkImJ9Bbmlwvg3E1v+oS2eAOjRynMd3dxSOIccaMZK8tQK56LoZq7ZwanqSkEeRKCRlxCV81/Xg+H34QuK+ckqRb6TJ/ad87qdheSdhgAHINNEXqS307xT1chGYJXyxyFx3ejwzq8Fm8sbee4sP26kY+49MzodjOQuox8wFapwmQSjXzXQKM8dyPgtGl+79MBkWdeIHYAmRWVsRehkIX0YVlETAtSpyGkyHb8DKxL7L57eCGSuJR221pDJMWEm9gzlVWNT4EGtGXZnwvOoD17anWLRlr9AjVL/dfcuobMfv3XXvd/lBFdIpk3uNESCnwCI7RRTj2jVYDQmaguHccyhOo+rIbZMoVe8lWv1UOypmNvzDL4mBvceJQHJrYmRgSuygRB8SdJjhCFanBgWebEQMrJCeNWrNnNV/2+7Mjl6WPSvPjaJp
 6mn2il4V
 sdEKZFRAwRyuOhc/O5ocnyzWPy3NyiVysONHwrDmqJ1g664faWO0Wo1gVOwF8Aqnsqex9ymCcZwjJIx11kYX+nxx3ofwKCRKHouOqQp3l1HJBn2urKBgXZjOp00Op94CpQDYqwNJbq5iysC8/bV+JWTfK2dlPcdtyxvRywpwUQOZvfeY/LEaE1Cg78T5q7cczVplov6wQl6rz3K+mVrsNGogyZ8mC9vXAh2v8CuLQouJmslIatv2+94VMaHdliJuYdBmdIaKxsCSRrOqzz9RpNKkLWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000008, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23 2025, Pasha Tatashin wrote:

> If the previous kernel enabled KHO but did not call kho_finalize()
> (e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
> the 'preserved-memory-map' property in the FDT remains empty/zero.
>
> Previously, kho_populate() would succeed regardless of the memory map's
> state, reserving the incoming scratch regions in memblock. However,
> kho_memory_init() would later fail to deserialize the empty map. By that
> time, the scratch regions were already registered, leading to partial
> initialization and subsequent list corruption (freeing scratch area
> twice) during kho_init().
>
> Move the validation of the preserved memory map earlier into
> kho_populate(). If the memory map is empty/NULL:
> 1. Abort kho_populate() immediately with -ENOENT.
> 2. Do not register or reserve the incoming scratch memory, allowing the new
>    kernel to reclaim those pages as standard free memory.
> 3. Leave the global 'kho_in' state uninitialized.
>
> Consequently, kho_memory_init() sees no active KHO context
> (kho_in.mem_chunks_phys is 0) and falls back to kho_reserve_scratch(),
> allocating fresh scratch memory as if it were a standard cold boot.
>
> Fixes: de51999e687c ("kho: allow memory preservation state updates after finalization")
> Reported-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
> Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr.sc.intel.com
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

