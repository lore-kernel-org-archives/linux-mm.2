Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E15E81A40
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154D46B0088; Mon, 16 Feb 2026 11:19:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7C36B0089; Mon, 16 Feb 2026 11:19:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B0A6B008A; Mon, 16 Feb 2026 11:19:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF2276B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:19:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81F51140E33
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:19:56 +0000 (UTC)
X-FDA: 84450831192.05.788DBCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DEBAE10000A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:19:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QkXWZvsx;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771258794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDRbRnpopKcVD9C87gJ4+RdQ1pORC0FOojVFYCrjz0U=;
	b=dzwx1VPUMY3WZ3TTSmHzlRqFjzLH7z8CFc0K5VboJJkD/tsMxYrqIlPqkqOmfL/sMCl8IE
	tnPltrPDEnipPnb5ix7boscw4fs5/nwbk/7/jX/6v9NZQMY86HSNtuOvSL8jNLxvtY7FTI
	jEdTcJXMoHujK8sD+nwb4hDp8ZVQnKU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QkXWZvsx;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771258794; a=rsa-sha256;
	cv=none;
	b=LCxzGbPh2q55j8mpy1KASVhcJexNS+2mRhL104i8rOpmnPtS6QDgKsO/NnzHk8SesAl1eH
	dnuHUQwmM6asyQVAKzwLmT++aWGQqhFPDBMYBDboWL4PcGf4gnCoICSjsZrnFtM7KNnp65
	CzeVSXxMQLt261EStBqmovD4RzjQgCQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C3836013E;
	Mon, 16 Feb 2026 16:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160DAC116C6;
	Mon, 16 Feb 2026 16:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771258793;
	bh=Xdcj83X+S0jAZzhzAiEPWWH/OhbcSoEDUGOUeQEAPKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QkXWZvsxTA+V/n96k5wSHxcNjkLNZ8bSahD58XOBxcmWjA2/CrJ1B+W8vA0GxT00C
	 qHMIeAWh/+zHov1BNeNySXAIBkhc6ZF5L8NtiG/fx1/S+bIwq3y+m/0WUOkfZaluFA
	 nhTCqvNaYP8GyCwIa0R+vaoiKnvAamr54SynTI/f1tD5RFa4nG9DhbR6LlLw7dAXjF
	 WfhG1nElyEFP6HN6pyxBUgjQB5V30knOgAYQRHLFsDrRT/uz4siKz/dCQ2lEQeJ+Ex
	 bI20NA1FqzSq2AN3Ei5IN0AGDDhevDbUe1nbmrxqfGt6jGzxULYYm7HNxmFqZCr9Cz
	 zR+nu1kAvcmCw==
Date: Mon, 16 Feb 2026 18:19:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
Message-ID: <aZNDogxae67mAXDg@kernel.org>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
 <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
 <aY9Mf8oZODGiDoXp@thinkstation>
 <6d6dd421-774c-4f29-84d5-3e449240eb93@intel.com>
 <aY9c80nXefdXjGXh@thinkstation>
 <aZCaE04vDpf2hDEc@kernel.org>
 <6a43f009-335f-44de-a48f-f48ee1e912d0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a43f009-335f-44de-a48f-f48ee1e912d0@intel.com>
X-Stat-Signature: 3fx7zcbjm874znspz6uj3tqr6qh56y85
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DEBAE10000A
X-HE-Tag: 1771258794-829925
X-HE-Meta: U2FsdGVkX19eIjvISnxfkRVsltzolctZXOl7lPkD18ZUboemytXc4NA+jqt7+vbo2AaLZuyRZtb3L7sV/A5T/NcjCYHI9J3AB+j/arZjjk5nxBv9Hwb0/n8A0MpZwS0Y8N6xpTLi2qo5w0KIAIT4cr6XYlxKk0c79pK9sQaazBAgFTqAw4TUUEZ9FNW+/sAXi/rQsn9lYHSvpJeQc1KTALdIgdY6piGgIocE3VaSfSHCTE8Ak1+epw51iYdWd7DMW5T2EAT1tvgs5ZoXcW8lp7PM6z/QwM/wQIbpT5iaXhdz9u/6YoMBwfl35lGWukyO5NZevEmO0e/TpKKDiULa3s/qnf0FwksfDV3071Z7x62ZEMIlWNJ02sIyaPIsGsDfHUZL37/QZ8rZoAeglh87K8cyHiR+mA7dPsZ+UwayDceIg49mK9wWcxF2Ymc9c8np2NL8n2M1bxgwQFhenb8tC24YQ5/MBgge1OAgzHjGiX7mi4Ec4ob1Rqp/gYEJZCoHkoMZlJ8pLf9oyGktRwHxqqtp2Xsf5lSFHcdm4b602FuvGVsQrhsRrGvuVbzbsIP2wl53wIySk3Y4U0NM/7Q4Sb73EykaUMkOJtpW7nhzE6Htic2z7g93VAN6TYH4NqB0oAhfCft5hELRy8bDzIqBMtTVggHpHJketlEWmXD8MLxFsB3/R2u/5AgeI+e4bH1y0wsqgIeUryMnlEo8mUh9JsOTIl1Q2iwVbhaWuKw8kOuy4uAQsf25vZApXWZe7+Yo55n0q6RQpiQO2G+dQz6/ql7aRxKJVN+5KB6YhsZ/gI5EZMVK609htVs/5KtvtQR/vXfDBLa0XFKTiEb9P8HNI020MzTpiqHlI4aTQ0pjTF45Z6oXtUusTS8iYnqAO2TuxmO7CbqB4Y1GwEYNCvdHN/j/2Yr2betkBxw/8UodSu2tuVRJjGvFaaTGuAVZfe41rDoFXJ7I1VEG2IqnN7D
 nUM7kXw5
 PESxVOuMaWVLAlp+QIC3tvVwbw5t/yhtUJlRIbO+QpMotGA/aZRMjrm7wGg0vfMbUJ45JZLw6bOV0mMWXn0awIrzogLxEpQw5H0/sRJY15ckXhhPzh70eTw8MaQ4ZnjTWbf9zwkDCi/jJ8XjISPhnR1PBWqCccSlZQn3YlJspWjSr0+f1loRYhcrJSxcQ1d1SbNY4yQSd9AqXxjBBNKSg+xAG1TpXJKA5zAU1/+2FfjQyQORIHejDErkJ6XyQ6gVFT575IGYLq8/LGXzYekqd0ApOtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 07:53:24AM -0800, Dave Hansen wrote:
> On 2/14/26 07:51, Mike Rapoport wrote:
> > Heh, it's x86's choice of memblock iterator that's rounding the ranges 😉
> 
> Ahh, good point. I was just assuming that the memblock iteration _had_
> to be over PFNs. Silly me.
> 
> > Maybe I miss some context, but my understanding is that for crash kernels
> > the unaccepted table is E820_TYPE_RESERVED and those are never added to
> > memblock.memory by e820 code, hence the call to memblock_add() in
> > reserve_unaccepted().
> > 
> > When x86 creates page tables, init_range_memory_mapping() walks
> > memblock.memory with for_each_mem_pfn_range() that rounds ranges that are
> > not page-aligned, which is normally fine, because it would mean that we
> > miss some partial pages that are divided between E820_RAM and
> > E820_SOMETHING_ELSE.
> > 
> > And Kiryl's intention to round up unaccepted to page boundary seems correct
> > to me.
> 
> It fixes the bug for sure.
> 
> I'm more worried about the next feature, or the existing features that
> also only working because memory is page-aligned somewhere (even though
> it isn't guaranteed to remain that way).
> 
> There are two choices for fixing this: One, we do Kiryl's fix plus
> checks to ensure that all the memblocks that generate direct mappings
> (is it _just_ the "memory" type?) are padded out to page-aligned boundaries.
> 
> The other alternative is to do for_each_mem_range() and do the padding
> universally when creating the mappings. Maybe _also_ with warnings or
> maybe a pr_debug().
> 
> I do still think it's a little wonky for memblock_add()'s management of
> the "memory" type to allow unaligned arguments when that type is also
> used to create page-aligned mapping structures. Memblocks themselves
> obviously need to be byte-level, but I'm not sure it's the right thing
> for the "memory" type API.

Well, we could make memblock_add() implicitly cut down the edges when it's
adding to memblock.memory and make everything there page aligned, but I
truly have no idea what will break and I'm sure something will :)

Another thing that's more on x86 side, is that translation from e820 to
memblock only adds E820_TYPE_RAM to memblock. And since in e820 these are
mutually exclusive with other e820 types, this could create non-aligned
chunks when firmware reservations are not page aligned. It also creates
unnecessary holes in memblock.memory that slow down memblock interation a
bit and more interestingly, everything that's not in E820_TYPE_RAM is
treated as IO and requires ioremap/memremap for access, even it is in DRAM.

If these reserved regions were added to memblock.memory along with being
memblock_reserve()ed we wouldn't hit the bug with unaccepted I believe some
others as well.

-- 
Sincerely yours,
Mike.

