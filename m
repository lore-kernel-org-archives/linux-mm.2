Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D741FED3FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CB96B00B1; Fri, 24 Apr 2026 15:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69D46B00B3; Fri, 24 Apr 2026 15:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0E46B00B5; Fri, 24 Apr 2026 15:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B95D16B00B1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:26:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 879691C02A7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:26:22 +0000 (UTC)
X-FDA: 84694430604.27.D3E1D5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D149CA000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:26:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m19PBkcH;
	spf=pass (imf15.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXZF9PzXT/4lUU3AX7c+p/wqhaY1bwBk0EVi/urcaR0=;
	b=6NkFm8vhGNOSpRO5nYcWp35AGhycNPKOGEatai+F2NU1YY1aBedsVZ/WYlxJOZeZxWFEj0
	X+aNmFH0x77E35/TChR23tvBA86syXQwkE35Uj1dVp/wCC3zEEeS5OKZ1Ylw20X2FRymCe
	hKdjKExzgIPgg0muUg0j6xrDqPtc/KU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m19PBkcH;
	spf=pass (imf15.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058781; a=rsa-sha256;
	cv=none;
	b=TLmkyJ9BgncRClrnqhv2IE6thbcueM8jazmlOR6hZhMGbGFFpd4G+fVX/xmRrBxly3dGXb
	OV3YNdhNf4YUVMeAZ4uD93yzDRoNLsQYFLfALPoOC+3WssFWAx1OboYu8SSUesuAWi6D3y
	ZSL8ZbaUyHgbpTvLRxwMgOENHuFr0h0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0C0344165;
	Fri, 24 Apr 2026 19:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536A8C19425;
	Fri, 24 Apr 2026 19:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777058779;
	bh=DWkMRzIlP/FCulKUdiF1Fu9vzPWL2Yx2UPbG01OJWhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m19PBkcH3MjvyyP06bmauP0lmxSN/COgljVdoI+ldpXHQU0DtDimhU8PVacYX+Bo2
	 21pLVZGKSDmK0ObihtLemaCagvhphfyGcvLG/6WJEAkk9fBOQ9e/cAprEuiVcWRui4
	 hUD1BAa6CHaS2D9LcIcsRFxBUABxBro0F76eguF13ien5tNX2z1dhmTqPF4ZIzBCE5
	 2896KCE91Za+W4T5UgBiEvueRIAxp3U2Khr7RTsylHURbrTlDTFpVWUqkpzJQqvzSK
	 x9FUsCN2m2mX21Yu6ULCN8e75VXFWFkBTqRI9G53rhkmG9/xN1kJBN4PXoUZcv2lix
	 XPsYMFaNYOFiQ==
Date: Fri, 24 Apr 2026 12:26:17 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <aevD2USyVq0tKuwy@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aesg-sj6_VmXyqxb@tiehlicka>
X-Stat-Signature: bne6p5b1y6sf36qrod6co41nkgjgjnfx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D149CA000C
X-Rspam-User: 
X-HE-Tag: 1777058780-652979
X-HE-Meta: U2FsdGVkX1/kC0gQ3MKQDRHJj/3m/VMVVR55HbknJgvXRg4xD5n3q6lpvglzGRVGbBhnv6YvFnYX9Di5fnQHGQ5lURA5P6oneQkvwvXupWx3e1QkiX9b5pyuHUPdhOWhr1+WLf6T1w17g55hsRCFJlk8TkJB7lSgJ136V1udvAJIqPeNBAOu3I7OdDnsPeVtlkBu9YWYNwXcr1inhv3Y+qVdrHYmCnjoJTUrxhEIkIMT2a4+lBmC7XDkstYwC/LDpgXlG0RbhJ/dU2ExD6adxdInb1K+6Be51SINkJ6OQedq48J6d9K4nmxx4a0YvOz2i5PFDD5b8ZP8wjVPoUKTUVYY8y92blD92cQ0zheAHV0rTsw5Wx1Cz27zqqSv29JzndGy/6l+Z8Cvrvgldas4dqFbUrURiK+db2W4hB7hBYk2jGn/HNabisipAWzw36CjZYBWFeYKRPGQCtMFrAUalgm5mM51rIudYp2oDhMPeUHEiCJACmBYq57UjS2ljllWBT53bMXgoEui0QaQm1OZDgC1/uj2U/shxFlma3/aa1p1Bc61Bk+/4kmcf9ZMyDRfJs1mZhNFz3hIF84llsULUWUcJEnjsFXvSEtSNsuoF5NkoqWltb+OEn03Qv8mTQG5Xi1e6KvqS3NJuDvPfi+3ZvQMjqJ/x+eeWmyUKnU9FrtFfU5SpFOwJokHsdXKCUQMB/s5YR99nyN9KCi/HmxOcsHMzuNEaG3d4ufOxEAVlU7gV6ghNd+31PSDL2RN38faXWJ6DYNALS1wjDe7fVW6Z1WaYvXdgV1bSfSyRj3QqFSLDJlgYSRqFJnSQztOeo9/U2HIBxpvtUzLlikeeEdG8g2uVgWgOykuQCywmyqHuiDt5OPpgMjBJ6GHC7KV/rhGtC4d5WKhyjrZ5ETsLOy9cDhqmUxMySxtPmA0nDd2eAGD6v7NHyLSR25H0hIaoR9dCYFZK2lzcIWD9CFXljZ
 iuW0yZb/
 Qk5N7VOubq1mWwkFurUSHRgeUOUR2batk00Ih3FS1i/FWL/iNVAp8XaRRD+WfJoAo4KaSiEy9BGx4LUhbLxmVF/Rqbh7UvlOYhqLgol9/g60SjC2m5y+jfg8rQ6Bm/edI3I5pm1kq2e2JAoKggc1qA6yFNCvAcz29OHXUjs6xeeEYB6+rWxWmFNhs9SjuxzYLvIZP/QwzAEPWUlENdewPLbdBX2XBc6yYO04FRImWEObTIGZYyDLnZ3lLYqtTM1AJgTQ4qTy080DKyL7obDZi7nCUWNPiaCULTlmhvUCPPSP5dH+7bd2XSu5Iqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 09:51:22AM +0200, Michal Hocko wrote:
> On Tue 21-04-26 16:02:38, Minchan Kim wrote:
> > For the process_mrelease reclaim, skip LRU handling for exclusive
> > file-backed folios since they will be freed soon so pointless
> > to move around in the LRU.
> > 
> > This avoids costly LRU movement which accounts for a significant portion
> > of the time during unmap_page_range.
> > 
> > -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
> >      exit_mm
> >      __mmput
> >      exit_mmap
> >      unmap_vmas
> >    - unmap_page_range
> >       - 55.75% folio_mark_accessed
> >          + 48.79% __folio_batch_add_and_move
> >            4.23% workingset_activation
> >       + 12.94% folio_remove_rmap_ptes
> >       + 9.86% page_table_check_clear
> >       + 3.34% tlb_flush_mmu
> >         1.06% __page_table_check_pte_clear
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> As pointed out in the previous version of the patch. I really dislike
> this to be mrelease or OOM specific. Behavior. You do not explain why
> this needs to be this way, except for the performance reasons. My main
> question is still unanswered (and NAK before this is sorted out). Why
> this cannot be applied in general for _any_ exiting task. As you argue
> the memory will just likely go away so why to bother?

I revised the description to explain why I wanted to go with only
specific, not in general.

https://lore.kernel.org/linux-mm/aevBRh08X4UTMUj9@google.com/

