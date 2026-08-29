Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EF19C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 00:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D096B0088; Fri, 28 Aug 2026 20:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643AA6B008A; Fri, 28 Aug 2026 20:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5337F6B008C; Fri, 28 Aug 2026 20:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 346D86B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:33:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A78E9805FF
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:33:06 +0000 (UTC)
X-FDA: 85152432372.09.30F7A9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D2D5A1A0006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:33:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nU20J96s;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787963585;
	b=Xnrvqys1DJOO3G6mDvefFfz3U7bTCOmq1Hcyl9gb/LLCJPB+ztOH1qqGC1JKii92BcdYBk
	Z9geh/skoUrSAuTl+pxoM8JcCsvmfIY68bc8uMqvt4NKF2ndLikSjFxZwzcxDSzEjxZ5et
	7C3eZ6FTRcwxKELQi9qeVkPbxCZKsq8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nU20J96s;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787963585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rx5znqdJGkl3U/Uccn0MBlBkR7uBNv5MBWL8vTAd4/g=;
	b=rcKrXzOvQtYJ0bz0UbEE61EkAmUwfDkJ5fBwKXqmxVTGq+w0YHgSNUOvBrheMTdpebOFGO
	8Fhu68aTfy4dcIsG+i8lBeNnh0dSr2aQsapQPhwINv4p+yfD4zf1uygITu69LPk6qPpknd
	RR7fgEr8n6FICr0aaSd1DjNVz/d6sAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7656405B6;
	Sat, 29 Aug 2026 00:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB381F000E9;
	Sat, 29 Aug 2026 00:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787963583;
	bh=Rx5znqdJGkl3U/Uccn0MBlBkR7uBNv5MBWL8vTAd4/g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nU20J96swjtewWfNW6NOEeQ2fgGx2KF8MwoiCZqj+/+UQDopAatdvPYy9TXSMTuqF
	 wRgbp6PJ75bfgfUpmoCMdNnxAdpVOka4FAWn3zJCRtY7dfir6t8303h64kBtwSh+Q+
	 XYCBvqn+3TB4isHKJHpPv7zYQEZd4jrV+95rS/ik=
Date: Fri, 28 Aug 2026 17:33:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 liam@infradead.org, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com,
 hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: Don't install PMDs in
 uffd-minor-registered VMAs
Message-Id: <20260828173302.29778f1bf802a1db932778ad@linux-foundation.org>
In-Reply-To: <20260828222640.1638457-1-jthoughton@google.com>
References: <20260828222640.1638457-1-jthoughton@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: cjre45fookufhacea31ww5p6u1rzkefz
X-Rspamd-Queue-Id: D2D5A1A0006
X-Rspamd-Server: rspam06
X-HE-Tag: 1787963584-811649
X-HE-Meta: U2FsdGVkX19ThfFWAuAsgUm5GV1CGDgE0xBDe4uLYBxvY6BBra2mqCJpVngFWaV1xgUTR6aHQfayz5SikhFKFvEyjpTuX3HaVpMdN9SOaYn67aV1yCqZqG9ZikscIMJ/bzrmwsBmZcOCfXmrLlTkjoJwlLyLl6J7/ENkbSuWTqMjIj934Lu+6LtQExMWTElDQyeTfrpFaHcYQugoyXAT/GAqCuTAjlah0ZqzImp/Lutu2gEUSkRz1WUeujpNBDI/r6C/IJdcCgHmALeg16hP4GuTCdt67uWcycAzk+norE8nJzL2Jk0SX2ibLvQnFUSHGuZrFXrVGdPpA6LkDUbNNvq9ggrbWpkEDYYoEwOpcuAYWVhMwaPrrUknbRSF9MuFjSy5wEaF66pwo3CB2w3P0YOw7GEMftK8GSBH/h0hxo+ZbF6IVKJpJ4AY8UCQuwM3UffCcXi/ynlZzzpyPb9DZX2LSfiTtOKqc0Q6iWvWutRlfiN/WVl8Wu3QEf2ifes0tdhSvt0UIWX91jIMIqGFwYjRg+bVayTkAA/G5DnYKQbKqUsfjQJURE7uhm4Iy7OG3oy2Tv+QHQb3igA6EDERKXMWInDhpf0H0Lgp58XGLEzHBJa4r18+zUKCYo6FwJ9+mgLd0WY/W/XxRib/KlwbEBMEZym17ilem56rkQIyn+hsWPVC7MtQB/jDLqybaMlZn8CMld/klaPy8kbWE48E8iZDVboc4PEw0neop7jLMMJROJHT2fbMufJul0fiN5qbUw+ociUwwfTIa+lRWGWIjyw/cnfqfXWHleZ8NZGpHEcsmjFjLzMUbbZeFStAm0cUyZtHtvEuB+R4xvKQRHeCVeIIUCW42eb++B5iYLuE5DGRTx0BdMStsX90WCGKzL3TJO0l0JzgGP0jqPWs0beTKv+hs3ooHXo5jO1Biqt9kXPdlX7OeKJC+254QYKgxaeNCHw5LTPDw8AJ4igiVh9
 K57KDiUk
 /WmUyX3EjD421BS1MTMHCfujxFE82xs80kvuMh2AWUag/qb1PJyxMmmvytyGa+MR33MlCji4c7gyWdFShUs7U9ZxftezvjwiBg8eDA3rlBHf1pG7+m+0sUDOuCbIC+jco7Vm4FUERK3v9W/cDwcavRE6aIo55inzJsqCf7ws3xkpX1q0EMnBtz0/kJNt5thK3q5lNOaVvL0UI9i38n4k/zX5WpZ6eLY4GWcXJiR34so0n0bC+91q3PPdHABNGj3rDHmYSrkBxDPDRkCFRV3PK9SbF3qvuJlC53ztjktF+HdXr3ImrR1nuaHdN1Scpl6KV1tyeCFm9r29pOj9TwstyPhb3fYXmCUiBhh4ZWnRuay7gMlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 22:26:40 +0000 James Houghton <jthoughton@google.com> wrote:

> Userfaultfd minor faults provides userspace with the ability to manually
> install PTEs with UFFDIO_CONTINUE. Right now, khugepaged collapse can
> map holes in the VMA when a naturally-aligned THP is present without
> explicit action from userspace.
> 
> This is a problem, as it bypasses userfaultfd minor faults that
> userspace is expecting to handle.
> 
> If userspace implements post-copy live migration using userfaultfd minor
> faults, this situation is currently possible:
> 1. The VMA for guest memory is userfaultfd-minor-registered and nothing
>    is mapped in the page tables.
> 2. A stale copy of a page is present in a naturally-aligned THP (from
>    pre-copy live migration).
> 3. khugepaged collapses the mapping of the THP, installs a PMD.
> 4. The VM now has access to the stale contents => VM is broken.
> 5. After installing the correct contents, userspace attempts to map the
>    page with UFFDIO_CONTINUE; it gets EEXIST, indicating that something
>    unexpectedly mapped the page.

Did I read somewhere that this it biting you in a real-life scenario? 
That would use useful info to spell out.

Or is this a theoretical thing?

> The naturally-aligned THP case is the only case where this is a problem.
> khugepaged otherwise requires all PTEs to be present for
> userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
> correct. This check is essentially bypassed for naturally-aligned THPs.
> 
> No changes are needed for file_backed_vma_is_retractable(), as zapping
> PTEs is safe. Userspace must already handle cases where PTEs are zapped
> without explicit action (e.g. due to reclaim).
> 
> Fixes: 58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
> Cc: <stable@vger.kernel.org> # 6.1

From the changelog it isn't clear why a -stable backport is proposed? 
I assume the userspace-visible runtime effect is a rare and bogus
-EEXIST from UFFDIO_CONTINUE?

> Suggested-by: Lance Yang <lance.yang@linux.dev>
> Tested-by: Lance Yang <lance.yang@linux.dev>

Wondering what Lance tested.  Was he able to reproduce the bug?

Sashiko might have found another race in there:

	https://sashiko.dev/#/patchset/20260828222640.1638457-1-jthoughton@google.com

