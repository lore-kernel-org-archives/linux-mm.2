Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A0CC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109056B008A; Fri,  4 Sep 2026 04:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093156B008C; Fri,  4 Sep 2026 04:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEACA6B0092; Fri,  4 Sep 2026 04:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8DC86B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:30:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54D41A0C0C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:30:32 +0000 (UTC)
X-FDA: 85175408304.20.02917AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9BE5A0011
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:30:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CZqJMm1o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788510630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCwmAHeu39K6xzdfz5VnsF0WOjtNpzC44nH7/8gOAy4=;
	b=icTf5TD0SYtfJleJlShbZkHdfOApDsaBx2kQB5C92kNBVo154o0Sv7ik3V/nthHXdRnflY
	f8I80fJWyM9HGRoKyIASmfyVeyzoZVFmFYZ9RyGoNnVoOA0tRBT7WWuotJgQUm/7vpgM32
	ED3YZ04EshvijpUXNaLbhse0rWRQaSw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CZqJMm1o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788510630;
	b=bissLtYINYlRA64Ujl3CuKVIFVZymX3sFv0Y3kre8MDBLBbUWu8+NrOkNQA0bhWM5xDrKV
	qJBBv9VRnc4znWhE0KIElsz3WtGjxXKRwFJH+mmJsnJM7qUfi/PQ7ETo5jTY07H2juOZcG
	TyBMn3mDqpdtuo2dExAAgfBUphn+Ur8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43CD760A79;
	Fri,  4 Sep 2026 08:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514681F00A3E;
	Fri,  4 Sep 2026 08:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788510630;
	bh=HCwmAHeu39K6xzdfz5VnsF0WOjtNpzC44nH7/8gOAy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CZqJMm1ouNXl208Ft0fEiKxNfeGKvX/vYevqxvAjgt3mUsAZ4zWWoBKEtacdgNVu3
	 NdrOHI/Y0wj0v2Ky/CJtsjXKpIKZ97tpmngMWC7cMxUFniALxG1jJfft4N1rcKqni/
	 b7NxkjZVjN8OJsqWfTA5uPJ2K0frokB++G7PlG/GWxhj234dutpiPfJCbwwosOuKAD
	 3NDxzGcdT3YTgKPRwQGZ8cRLyFpJj6F9RPSgWzfvG51164YFMTEm6gBxQVibYZVFBe
	 jXY10+3ew/ThXJmthFtMLRRFJAHFPZURi3pBQuKzEr8ZMnpr0lVLV/iLUmEH39iMPO
	 1d2GzSKMmHT8w==
Date: Fri, 4 Sep 2026 11:30:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Hu <husong@kylinos.cn>, linux-mm@kvack.org, muchun.song@linux.dev,
	osalvador@suse.de, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH 2/2] selftests/mm: restore hidden hugetlb reservation
 scenarios
Message-ID: <apqBn7tWDHQeMrzB@kernel.org>
References: <20260714021630.1063823-1-husong@kylinos.cn>
 <20260901173748.fb7a442941102894a0c42baa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901173748.fb7a442941102894a0c42baa@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: raeuzhz8dnstozadhurnusw5hbhpxedd
X-Rspamd-Queue-Id: B9BE5A0011
X-HE-Tag: 1788510630-92956
X-HE-Meta: U2FsdGVkX1+XoI67GDLmqaFgQP158leyOSEluXBTXcZRuDiK59aGRsKG4AxOnzK396pZ/pz2BZ4vCI7gsxc6fMDsvbI6bLQTl/S71aqkVdp+86uAGfJXJE/ErAvzk804jo99nZF9uoZf3LWeA3sZAfGEi8aI3ckYg1VKvdZlnVC6Rd4zclkkyJ6TKq7X4rKP4zm1OApoJnChrH2quSCgsw1MoXEivz5l0g5wMGQEHjT8jmRLo2yXlc9xrBqFGE7PgfWvzRgaXphuUwI46FBRIv1rqYtD5TC+QSlXO98iWlhSjm0aiGmwVJyLx3lzxu90vAnsNQ5LtshYcfxs1fjJWjarV3dVA++ebYIs5oD/od3lrlmGurXZ7aFypCXEo3OHIRImkF9g/gyEHwQdOLxtD+Mcy/0daJtvmPCepm2jiD8uibXdoo5w6bBYJDRm3hCNTUl40aREDXAIrLihrchs6VvNtnW0vDnF3hBjhCNqtFBjDzlkdU0iuFZ/kHM8kjnQ+kArtmhiTule0nAYwJBP6+uSoL4W5hEry7T6XHGo6/4nrVZcfh1TPXttraFrLnZCBiR6hoM22DGTthDAZ0oxXY1P2C6eqP4GxIBcoW48vlb7r9c0hYiSNhpeyr3swTinx+3ZvJeMwvFpsOP08gHRyUFmPhZq0VFyIm20YHZK3BhrLakg5mm7/LcspFiu/ZFWDs2WWs9AmqViBziZm+a95kwE0y0ECGwnilUJlW/Wu3oB7IL96IGNnOFBMV/cTjug/AW7KtPbaMtw5pqLUXpUWuUemaU/9Mc05yk8R/93jM8bn7mvpZziuginHyZl4Qwv4DAV/6hPUtcqLIiFxj4pKjFbWItzmrtvm7SGPLoR7XSC0X71o2MswKTZOqHXfdizNupo1PuZec380iy7H11+6NblsDQmF8LYD0mN1Eeu2jxL7oa0IbsndSAApd+1j0o1iw4pgCUwwn/wTCOdrr+
 0t/5f9v0
 pBG0xMG4skbsHglZhWHc4OmnNV3w3/HQF8P+oOS3mNBZFEjCuh0FMvOPJ8PA0I8BFit+NwwTrIkIVYMR+0YadFs+0cBPSK4dArydbkuCycKgfgmQLtFYh8HXpNEDhD6MdIZNrZf8vu+6zKXIx4s500fGpcxk+8hJO0/5Eu1vLYzNPTXZ6vkt+tc7VG5h9qgITltXX2eAbnilB1wq2CXEBLVmymejGNjta3wYgwxEShH4akkwhwQ4xqcoSxZvWEgP67126L/AwRQnI7eSZbvDv+eVw5rjzmBMdJQYZ+2YU698O57oa2Qnobcjrvt3d9acAiCaWlaQOgD3RQz/32JTg/Cy//Icxhk1/GUTph6Fs2WpJZpzAQBth/xneMzb35q0WZb5BMEk+tKfzGZu1vnq/QORuzH1kLZqqMQiaCO78rPK6xCFpBBp5alRZuPXr2q31bM42zHdfi104eiaO1psm8Fe9ds/OtrurwGspGUj/OInv9oXZJoDVV9l+9fS7dNAkkLTy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 05:37:48PM -0700, Andrew Morton wrote:
> On Tue, 14 Jul 2026 10:16:30 +0800 Song Hu <husong@kylinos.cn> wrote:
> 
> > A stray 'continue' in the main loop of charge_reserved_hugetlb.sh made
> > the "more than reservation", "more than cgroup limit", and "multiple
> > cgroups" scenarios unreachable, so they never ran.
> > 
> > Remove it so the first two run again.
> 
> OK.
> 
> > The third,
> > run_multiple_cgroup_test(), is separately broken -- a backslash
> > line-continuation breaks its local declarations and its hugetlb
> > reservation accounting does not charge as expected -- and has never run
> > in CI; skip it explicitly with a comment until fixed.
> 
> That's reasonable.  This code was added by Mina six years ago.  But
> he's still around so let's bug him with a cc ;)

And this code breaks our CI e.g:

https://github.com/linux-mm/linux-mm/actions/runs/33040981840/job/98414290236

> > Also correct two
> > `[[ "$method" == 2"" ]]` typos (harmless empty-string concatenation)
> > to plain `2`.
> 
> OK.
> 
> 
> 
> From: Song Hu <husong@kylinos.cn>
> Subject: selftests/mm: restore hidden hugetlb reservation scenarios
> Date: Tue, 14 Jul 2026 10:16:30 +0800
> 
> A stray 'continue' in the main loop of charge_reserved_hugetlb.sh made the
> "more than reservation", "more than cgroup limit", and "multiple cgroups"
> scenarios unreachable, so they never ran.
> 
> Remove it so the first two run again.  The third,
> run_multiple_cgroup_test(), is separately broken -- a backslash
> line-continuation breaks its local declarations and its hugetlb
> reservation accounting does not charge as expected -- and has never run in
> CI; skip it explicitly with a comment until fixed.  Also correct two `[[
> "$method" == 2"" ]]` typos (harmless empty-string concatenation) to plain
> `2`.
> 
> Link: https://lore.kernel.org/20260714021630.1063823-1-husong@kylinos.cn
> Signed-off-by: Song Hu <husong@kylinos.cn>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mina Almasry <almasrymina@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  tools/testing/selftests/mm/charge_reserved_hugetlb.sh |   14 +++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-restore-hidden-hugetlb-reservation-scenarios
> +++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> @@ -439,11 +439,11 @@ for populate in "" "-o"; do
>          fi
>  
>          # Skip populated shmem tests. Doesn't seem to be supported.
> -        if [[ "$method" == 2"" ]] && [[ "$populate" == "-o" ]]; then
> +        if [[ "$method" == 2 ]] && [[ "$populate" == "-o" ]]; then
>            continue
>          fi
>  
> -        if [[ "$method" == 2"" ]] && [[ "$reserve" == "-n" ]]; then
> +        if [[ "$method" == 2 ]] && [[ "$reserve" == "-n" ]]; then
>            continue
>          fi
>  
> @@ -496,7 +496,6 @@ for populate in "" "-o"; do
>          echo 'PASS'
>  
>          cleanup
> -        continue
>          echo
>          echo
>          echo
> @@ -530,6 +529,15 @@ for populate in "" "-o"; do
>  
>          cleanup
>  
> +        # The "multiple cgroups" scenario (run_multiple_cgroup_test) is
> +        # multiply broken and has never run in CI: a backslash
> +        # line-continuation breaks its local declarations, it passes
> +        # reservation sizes in bytes rather than pages (unlike
> +        # run_test), and its assertions compare page counts to byte
> +        # values. Skip it until properly rewritten; the two scenarios
> +        # above are restored by this change.
> +        continue
> +
>          echo
>          echo
>          echo
> _
> 
> 

-- 
Sincerely yours,
Mike.

