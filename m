Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16822CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075EE6B008A; Fri, 19 Jun 2026 08:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026406B008C; Fri, 19 Jun 2026 08:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FD36B0092; Fri, 19 Jun 2026 08:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BACB56B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:24:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4BB241A0405
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:24:12 +0000 (UTC)
X-FDA: 84896579544.04.6E95B24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A667018000F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:24:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OKRRV1pW;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781871850;
	b=7/iNLUKknlPZyTtx7iR8d5fQbSYQduhewNDXiYvJ1SRq+s+vOMkIwLWYOdjLbyAInpWT7l
	rwalFuk6fAL2gOS9x4cKWImZ4XWecqEwtc3V9OVBdUqRD8bOUBwaBbKuWghcPIMWJayjHf
	X2faXo29tlQchDOANAV1S5ESiOxiPe0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OKRRV1pW;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781871850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aEsNMA0XS4Iug0cWyAkQCLWSguLxaxVidh3weN6Rr0=;
	b=fjrOsx7UJa3Kd/53sVA2GU2ZnehtQDiaD9P7UvnqCCYHBzlCKg4j7TuFTlwa86+gYaYWFY
	tAbvtK4lKVruNBWBPIe359lS1EWGKaP6KzghUfezOSD9vE/VPrG3VZXCRu6sU0q3cYqmXJ
	he6o31uuNeT8GKY3oCabqCrHq8dUhzc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BBF0601E1;
	Fri, 19 Jun 2026 12:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D671F000E9;
	Fri, 19 Jun 2026 12:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781871849;
	bh=8aEsNMA0XS4Iug0cWyAkQCLWSguLxaxVidh3weN6Rr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OKRRV1pWj23erJJAYIeRZ4gm0HzkdqPkHAwADB1LpHg7vOFNlCEQG4kgDDTRuy/zt
	 AK/e4+btNNmGrDPyqr3LaBhN9hlrRDBLg8P2CGW9sVcrE3FWErt6VtpkxoE4AZqRye
	 RAgU0vmCY4vfNAai0fYipRRPygXHhkud5wLdG01ZxC5u7LIP0TqEQhozDt2Y2WmovX
	 i1AZMg7IVzwJ4HUmfahAwNmiliSrHpa2mbaOLSw8K1MVVH7k+E+WGF6hVdB5bdptNg
	 JudzPy6znfjwPXTOgil+cxIJqrFDEWoHcLQAovJgycH1YDybvzqDgIkdV7ewt5zNKy
	 A3vViFHzn0ZUw==
Date: Fri, 19 Jun 2026 13:24:03 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@kvack.org, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 3/3] mm: read remote memory without the mmap lock where
 possible
Message-ID: <ajU0MD6PC7wC_ssl@lucifer>
References: <20260616190300.1509639-1-riel@surriel.com>
 <20260616190300.1509639-4-riel@surriel.com>
 <CAJuCfpHHkQyj7MMoH++RGraZgQ1Hr+4=T4PfbBn-minUCZyuOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHHkQyj7MMoH++RGraZgQ1Hr+4=T4PfbBn-minUCZyuOQ@mail.gmail.com>
X-Stat-Signature: s7t3etasfwzho3hexu85rtjakboas3ff
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A667018000F
X-Rspam-User: 
X-HE-Tag: 1781871850-82495
X-HE-Meta: U2FsdGVkX19vybwv0no8gV75qO/RsDMQrlTW9XsfWCbp2JayLRbsA+IOzjMdDBXS5ZuSa/ZV+xOymueCuvSfhchWRK4kfWwAXxC5iBvRrsPiVsYs8biHlDPGZ+XUbmEarraK4WMkxbn6qMK2WOjgBJPbQHRqMucDOjxqoWr5JjDwiyKBesZ4q9QdzypCc4Vour7D1mbSYkKnPTCpK3VpDrGKh90hiECAJ1UzXGa/lQEBKJOQPU08olBBY3tPgSVhASHScCiVXEDmOud6SIPRkpKZ0p4gH1Vb6wjQrFIkF/D9bp7BKmUvSfx8slth88c1jm5jo8rFuZHWwlsVmQjWUgFLYJ/wkqyzI/7KuRVr0HCQrtcaYbj48cl1mzhtJKbj2BWwzGnWx4mIy8WQh054vBgSPNC0jfNlODQsyVAkqLTHomituaEXfeUPqQqFflJFMt4C8YEqVc+kWHdJSVURbwbIvuwvd0EkdGDXL1dUYR1t5bMcCoPSb0J1vvoJnavbiniWRcwmqmOgLycVu5eJS929oXajFW+3oMGr8m61c6K8OASHHCtdZRMYhjLbBMmS93rcCfvrpv0JQeQls5cWpESNU/+bemRaYMXUlgu89CY2Hen5T6haLV8SkPVq5w5Ev9IfyPwovodNZRlWdR0k1aGsNkurq0OCioq10uhh9/Vlcbt5nD/USnwSOth4Vw5Ti/xtoo+HuRzXJMwYKfp6WPocl+RXprG1Ip/a0AqXdO9VW21qn3ZF+dqLbMhji4ljeEhpU5HCavUtB/vZ35jFIKKreTMnvx5+WbcgN2BnmN0Myzw11QjX9j3ynczq9caInVPB1wDtboTGgw96VV/HhkESBfpCe0MABzrz3otCO6BuTE5MAzdRa+DjfkOCGbl7sWAAhZkMEPao/vwYjBZDSLLwLsu2HIWrlm11E/AeNLD9EAvCnXLJA2imt3uTd+gBKVjTc88wl18nzB6ZGsZ
 TWvqF0vL
 yp/+QfOeM6oDj4WR3fLjZEnILp3UGbNHbh8q2oSYR5RrpQKE/kjpoox4Vk0ufDicOADWRPurcc97pYMsNCZO+2x0RM1g7TB6sznm8W4vys1Ksbme1OtNoWMEhGTG0Sq5bk9h225SLIqQ8OhN3SJs8K7BmHCt5bNLdLLTiPYP+c8XNkJOfZrl9rninPtCTfKtkswHPYNC9H9oesrfZ6ZV5K8y1Y7jU7sVuMxbbY5SKybSjMADi67XAWP2F9qzOPcZXS1zdlwtwrTy7W/dvyBVbPMggDhq4nmLh1hBPlOFxTQqquItUnsE+kAOi6/p0OVB47s+P1TPL1AQAQ6KeqKxgVsp8K5j0p/Znyo8/U9Y6KE2GN4zNlB14RYbXvStkszLG+weD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 11:19:12PM -0700, Suren Baghdasaryan wrote:
> On Tue, Jun 16, 2026 at 12:04 PM Rik van Riel <riel@surriel.com> wrote:
> >
> > __access_remote_vm() takes mmap_read_lock() for the entire transfer and
> > uses get_user_pages_remote(), which faults pages in.  For the common
> > case of reading memory that is already resident -- /proc/PID/cmdline,
> > /proc/PID/environ, ptrace PEEK of resident pages -- the mmap lock is
> > unnecessary and is badly contended on large machines.
> >
> > Add an opportunistic, read-only fast path that transfers what it can
> > without the mmap lock.  For each address it takes the per-VMA lock with
> > lock_vma_under_rcu(), re-checks the read-side VMA permissions, and uses
> > folio_walk_start(..., FW_VMA_LOCKED) to grab a short-lived reference to
> > a present page before copying it out.  Anything non-trivial -- a not-
> > present page (needs faulting), a hugetlb or VM_IO/VM_PFNMAP mapping, or
> > a race with a VMA writer -- falls back to the existing mmap_lock path
> > for the remainder.
>
> I don't think we should be using per-VMA locks if the read spans
> multiple VMAs. Doing that would risk a possibility of reading
> inconsistent data since we are locking one VMA at a time. While we

Yeah, very true.

Suren has expounded on the possible cases that can occur elsewhere but you can
observe strange states like that.

You can see tools/testing/selftests/proc/proc-maps-race.c for a sense of it and
https://lore.kernel.org/all/20260426062718.1238437-1-surenb@google.com/

Note that for e.g. madvise() this is exactly what we do.

> load and read VMA, its neighboring VMA can be unmapped and another one
> can be mapped in its place. So, our read spanning both VMAs will
> return inconsistent data. access_remote_vm_fast() can check if the
> entire read is contained within one VMA and if not, fall back to
> mmap_lock.

This would also vastly simplify the code. I expect most real-world cases are
like this anyway?

Cheers, Lorenzo

