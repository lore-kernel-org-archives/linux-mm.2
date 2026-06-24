Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9ABCD4F26
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 02:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445B56B0088; Tue, 23 Jun 2026 22:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F67D6B008A; Tue, 23 Jun 2026 22:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E51B6B008C; Tue, 23 Jun 2026 22:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0413D6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 22:09:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 594CF8C5A3
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 02:09:32 +0000 (UTC)
X-FDA: 84913174584.25.0E226BC
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 54F5510000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 02:09:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QlrfLDWP;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782266970;
	b=I42xoa0rdEEc7fqze6y1TiB3WWEs1KRuVHXOiBQHLEgnULw8X+y8MUF/lim8DiLBHfZaQh
	YIRX81uI4mcvm+fHPzbm495Zovt+FKxjUEZaB1fC4zNaCNJVX2ykseIyN9V7742XP+klo2
	k51OObbyJkZEdD9pgslrJKOd33XzxUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782266970;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+Dbr5cCySdCqBqi2ttFxVY6H+Q6f9EeFLzVyFXEO3Y=;
	b=ylnuKmdDpNAt8Qe5GGL1IWc3wd5GHFocVl88jW/adkb1vo+CWu7A0lr8GfoYXbkNQA6oL5
	N+MrA/APJ2JU5hP94mt/GX+O9jg0lazYoCUvnKEr5J3KXVQBwsDWW1n/9vIh1RSuawn7bW
	JFysRCnoU+0MqUIjxPSneWMQkH862Uc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QlrfLDWP;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-befee9e5ef7so58267766b.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782266969; x=1782871769; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+Dbr5cCySdCqBqi2ttFxVY6H+Q6f9EeFLzVyFXEO3Y=;
        b=QlrfLDWPc9nZ1nEpbUWid4Ixab1/17/J2IlBM+5dy+12PZrXbsgRlMYPjgyBR+hQjX
         feIZ9u9LUnA7HPlAs1Lp7kunrL16friqijIWaG0aNH9v4pL1iOKaddncOC9oj85kUmXv
         7DuhpsXpPAsVv0KlvM0nYUrJqtkcFT5tNacouA6THbxMwmJHROZAGzJdyVyrwu3LXmci
         fKZDTocOnB/in075OIrMfpYcfwHNl5jkPPfG3OZ7UeecA41L6E4XfCN4D04p3i5TLEJl
         OIsqIc6dd29OzCZ+HzzXYSJsiIvlF6Tbv4p4SDEtK4u+ramij2LwL8/IXTg7rBHN0FQS
         2eBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782266969; x=1782871769;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T+Dbr5cCySdCqBqi2ttFxVY6H+Q6f9EeFLzVyFXEO3Y=;
        b=kilzvTLlvXc2nT5pL8ZwnubQnkVCky4qcj3XsiDQu40t71b42kknMI1XEaSOFz+T7R
         tWtjkQUKwOEuuwccD2/Rf8nxCugGPoh/8PHuSpZbdDh3VwFxPC1yFz5MsWH1HpdriNd0
         KncdOtMdGfLkwr06nWgbedR6Q6gGGkEBkT1yRRLBTP+MMfCfBPE8EvC8QFsAsLp+M/28
         lGQ+rYSAezq3L+44ixGL9pQSNbUnTbHyenmw813dzmuKbmvtjNFzA6ljfOoXCsMvdcAB
         QjfXbks659wORmOrzV4LPiHUqgOMHqjtlH1ZG8ocrZJR02G6ggqzMUjB20njYfh5CzVI
         H9mw==
X-Forwarded-Encrypted: i=1; AFNElJ+jcA6PD31lMGCyJLDjGlTdSVD1azkS473h5Nqe/3YklraQsVIBmHzMW8pU1J0WihbFPRlIYwOIPQ==@kvack.org
X-Gm-Message-State: AOJu0Yx60pZfKYEnTG710t/8n9+hIOFgfgvQGWgt1hnAm20wAiIVheVY
	swgPOHdIWrwcPYxAr5DI1AQvpGxRTt8bpl0niOy83AvZnAaG1jTIncT9
X-Gm-Gg: AfdE7ckpcinh5jellxcR456bq5d/7j1dR5Tlg/TTFkmPISclU0qq0AT/Lk3rLvdI3I1
	/mlEQueXasGI9xUOO1zl2nvJKI0TNGFoqRp0+N5UJqZHJrs20+KKkTc0Ls5Px0SAv15Z6a1wabY
	VwoVazvCvIXCJQT9HCP0PISB9WzosyhS0Z3ti/kX04MS/lHInGTtGYh05Mytgl3U2xMNW1CUmW8
	A0M/NaHSlbpdMJqN/FWA1Na+92DjiNw+yXIVrfXt5DhEQ8dUBCvDX2njdRnND1HaBOZP3kkrSZV
	883G812TmbZYV0xMcblAkW6zW6GGAQdLypcighdX4+GCKSD02kxfYSJs/fjIeZQKZvYRhGscv7r
	tdqVP6P/b6mCuWuP9m8443yYz39ptCCSKSg5iH8gyX+ItE5HCc6z68C7HTPonJNMheFbcC4IWe9
	YvCgwWqEnHKTsJWUIOj/z/jQ==
X-Received: by 2002:a17:907:6ea3:b0:c0d:46ca:3ae9 with SMTP id a640c23a62f3a-c119de5e9b5mr42425466b.3.1782266968386;
        Tue, 23 Jun 2026 19:09:28 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5e998d90sm598331066b.17.2026.06.23.19.09.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2026 19:09:27 -0700 (PDT)
Date: Wed, 24 Jun 2026 02:09:25 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	sj@kernel.org, ziy@nvidia.com, balbirs@nvidia.com,
	linux-mm@kvack.org, stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260624020925.3lbraicwe4uzhn3h@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260622130651.23359-1-richard.weiyang@gmail.com>
 <ajk0N3Aekapljaoh@lucifer>
 <20260622142102.pcmr5pftshj5lvju@master>
 <ajld6RKK02Vi-LxM@lucifer>
 <20260622234518.nnx3r7ckphlxn5vm@master>
 <ajq4_VndR8gwponS@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajq4_VndR8gwponS@lucifer>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: htg5c73187srq45ocogtueo83zgj51i5
X-Rspam-User: 
X-Rspamd-Queue-Id: 54F5510000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782266970-20850
X-HE-Meta: U2FsdGVkX1+LheilTfVUC87VX+Ilw2kQxP27vIJKfONjk8OrVdlubp8FnTFUc9SU9yB5oZ3h/rR1lk8MeM+Z2WpRVF6ch6lzyiwLNLGvo3eIPiZ+mfSDhsbbk/3NXeQO8+8UWCAyMW3hHgH98ZG7Qh4qBb3bIa7sglRk2rw7OgGmW4gut3Y10PQwtcSUaVbsJsYtMbk5SRkEmkL2kwXqXS+6VLs4ALELMSh3bFaT4lKSk+vr3/tkmCCARavHhNwviwxOPgnkPh1Yqhfg23H+ICxdcLG0daR7PZ7bOfkwEH7ORtmXkjXlYxvLzgZQKbK0tM1fhOPwX+qsr2bFJIrN3HiE1lcO4CKfo79f+exqp+3wTpljK2sxEmETKt3Ce57VeH+KANsJEStsp3biYR4ZnqlMu34hkc0qcCGnXQSq3KexZL+tWyJclvOAGmyvy/X36LSW+eVgRaUyaM7LC43iLnbJZj8eJ7e7AzPf/XhZA2531iBe4aDP7urtD4M4/8aq+iV+nh6XyMhNddAy23QHGjHiKODWEUcuaV+8ZTJjJ9xvrfkGzAGm5Cvs2D8cZXRKqhmw6bxguz+SgsIEV5NtNnD6k31o7N0Q/h+n0pwqYCQX3eaqga9IrwOO66Cohgns7tK0BYcCcw1WacryM7gx/odYrF8LLy/KgjEZRRgfDsFyEUY7WEv2KMlQ1JL9FzlNGzeZjMMeKEdI9uqNYRrv6GsMWu0V9yyqJcwWZ7186ygx5wh/h7M1oPiyQ2NjD4wyfZmJEy0DvODAk/+6wr53EvHvep/dlogl3CP9WIa40+eb4+yYqqGKL27t2sRVkZyWSpjzmK1jPNewLmFDGZV+DH3dz546eYotb7rgqmY3GbNqD4HqIZRxeMncsW2PlLsBdoFQT5WYGGrkIdWApLyNRfnKd4PzlM1MMkcopwr63gs02L+o4+Cgocxg0P7G/c35zLns2JxF9A1Xtda8JqI
 4VAxzUHy
 iCuC414LScFLaHK8mCxC4sJmRyKc7B5ZyGVvzwZjdwlPRSjYCj4LhRZ6MO35BD20JkiwCp29fibf1NlWKD/pgOhsXkG5Km0EhDoCPv31tnV+ADF6IQZKmCdulkxaLniwyMgBzVynq7ZowHEZwVV7zXn+LVxlHdFjRA8tUSAeaAXtBOPifI3LZ+hl5FBFr7wnBCwTkSf8xxTAckelODuHrS9melHphcaRmxGZk/xZRwU2jOa/rHCaHFA9/IbZ9rJed2gZ0usasXaUS5aIelHBwcVSdRQiehZpbdgyFYKEvB6p4WejaGS06i1jmnU0ALczptUEMKr5m1w5CRbSqN5a7teJtJLNvZF41VuNzknW9qnVEza4oiQGlTupW+PFj9+ZnkyLoMc2qWRawYMFTxQdaSKixefrcFTmX3J5eGVfFxzKsOjOef7Oo0BlpksY8EF9ldz8YjA9YdjyZYLJmrQCIp4Fb6pr9+xW+sRVXx6EFR+iKUnPyvMvd1KsMiK7yOI+SbpVVqahKhnLDuTxrhFl5fzJe90SvueKJbqcECZf68fmZla4EWEXAMMoFEVotC5to7ZgtnbacJuIF/vzb0D6lYJFGOV/PB9ftF9eC0Y5gLakU+DYRr3UEKgUnVA0q/lAiD2KUQUrQ6ccbzR138fal+2k3PowMRgRGmcbNJfu5186bEjUClmcSFsibApkBdjc2DpaacJWxe1koTMzL/ox/Ftq5g+MbNS03ukbq3X0ZIydQIHd/mqPYV347aqglRuIqs5p+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 06:02:56PM +0100, Lorenzo Stoakes wrote:
>On Mon, Jun 22, 2026 at 11:45:18PM +0000, Wei Yang wrote:
>> On Mon, Jun 22, 2026 at 05:11:02PM +0100, Lorenzo Stoakes wrote:
>> >On Mon, Jun 22, 2026 at 02:21:02PM +0000, Wei Yang wrote:
>> >> On Mon, Jun 22, 2026 at 02:46:40PM +0100, Lorenzo Stoakes wrote:
>> >> >+cc Lance, linux-kernel
>> >> >
>> >> >Your subject line is 83 characters long and is way too detailed how about 'fix
>> >> >device-private PMD handling'?
>> >> >
>> >>
>> >> Got it.
>> >>
>> >> >You forgot to include linux-kernel@vger.kernel.org on the mail, lore seems to be
>> >> >a bit broken atm but in general it's helpful to include that.
>> >>
>> >> Got it.
>> >>
>> >> So usually we send a patch to both linux-mm and linux-kernel? If so, I
>> >> remember is later actions.
>> >
>> >Yeah it's better for dealing with kvack going wrong etc. :)
>> >
>> >>
>> >> >
>> >> >Also is useful to make this [PATCH mm-hotfixes] to make it really clear it's
>> >> >intended as a hotfix.
>> >> >
>> >>
>> >> Got it.
>> >>
>> >> >Some commit msg language nits:
>> >> >
>> >> >On Mon, Jun 22, 2026 at 01:06:51PM +0000, Wei Yang wrote:
>> >> >> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
>> >> >> before return the pmd entry:
>> >> >
>> >> >Sounds better as:
>> >> >
>> >> >	For PMD entries that satisfy pmd_trans_huge() or pmd_is_migration_entry(), we
>> >> >	perform the following actions:
>> >> >
>> >>
>> >> Sure.
>> >>
>> >> >>
>> >> >>   * re-validate pmd entry after PTL
>> >> >>   * check PVMW_MIGRATION
>> >> >>   * check_pmd()
>> >> >>   * handle on pte level if split under us
>> >> >>
>> >> >> But for device-private pmd, we just return after pmd_lock().
>> >> >
>> >> >->
>> >> >
>> >> >	However, for device-private PMD entries, we simply acquire the PMD lock
>> >> >	and return.
>> >> >
>> >>
>> >> Sure.
>> >>
>> >> >Also can you please give some justification here as to why all this also applies
>> >> >to device-private PMD? Right now it sounds hand wavey.
>> >> >
>> >>
>> >> I thought below paragraph explain it. Not sure what justification is preferred.
>> >
>> >Something about device private PMDs splitting the same way THP ones do, in the
>> >pmd_is_device_private_entry() branch of __split_huge_pmd_locked().
>> >
>>
>> Hi, Lorenzo
>>
>> Thanks for your detailed suggestions.
>>
>> I tried to add the justification here, and the following is the commit log
>> after consolidate your suggestions.
>>
>>     For PMD entries that satisfy pmd_trans_huge() or
>>     pmd_is_migration_entry(), we perform the following actions:
>>
>>       * re-validate pmd entry after PTL
>>       * check PVMW_MIGRATION
>>       * check_pmd()
>>       * handle on pte level if split under us
>>
>>     However, for device-private PMD entries, we simply acquire the PMD lock
>>     and return. This is not enough, as __split_huge_pmd_locked() would split
>>     a pmd device-private PMD under us just as it does for THP PMD.
>>
>>     This is particularly problematic when PVMW_MIGRATION is set (meaning a
>>     migration entry is sought), as it causes a device-private PMD entry to
>>     be returned with a different data layout, causing memory corruption.
>>
>> Just feel this is not that smooth. Would you mind taking another look to see
>> if I get your point correctly?
>
>Honestly I'd just drop the whole pmd_trans_huge()/pmd_is_migration_entry() bit
>and say:
>
>	Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>	device-private entries") introduced the concept of device-private
>	PMD entries, but did not correctly update the rmap walk code to
>	account for them.
>
>	As a result, when page_vma_mapped_walk() encounters device-private
>	PMD entries, it takes no action other than to acquire the PMD lock
>	and exit.
>
>	However this is highly problematic for two reasons - firstly,
>	device private entries possess a PFN so check_pmd() needs to be
>	called to ensure an overlapping PFN range.
>
>	Secondly, and more importantly, if PVMW_MIGRATION is set the
>	caller assumes the returned entry is a migration entry, resulting
>	in memory corruption when the caller tries to interpret the device
>	private entry as such.
>
>	In addition, commit 146287290023 ("mm/huge_memory: implement
>	device-private THP splitting") allowed device private PMDs to be
>	split like THP mappings, but again did not update this code path.
>
>	As a result, we might race a PMD split prior to acquiring the PMD
>	lock.
>
>	This patch addresses all of these issues by invoking check_pmd(),
>	ensuring PMVW_MIGRATION is not set and checks whether a split raced
>	us we do for PMD THP and migration entries.
>

Have to say this is much much better, thanks!

>
>Cheers, Lorenzo

-- 
Wei Yang
Help you, Help me

