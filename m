Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CE0FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5986A6B0005; Fri, 24 Apr 2026 14:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5702B6B008A; Fri, 24 Apr 2026 14:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ACBE6B008C; Fri, 24 Apr 2026 14:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8436B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:29:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 810BE1C028F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:29:50 +0000 (UTC)
X-FDA: 84694288140.21.E49B046
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C03771C0002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:29:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TkEikQa7;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnFKVKgl+PPhoj6jfp1IthN6FbfFXx15mLnWLyqyCUU=;
	b=0+NbBD+gbRwJAOGamhVu7MGmsBC94X86wb8EQPAlWHqvzCewZ+4lP5B0MTRZqVelYSpr/2
	AWaK01/dQktpTicoxEa0cUiu7oRvTivQz8mMxYoMjed60EmCoLFnm1nO8kfS0RkkDJymfB
	K0Rkyz3neB19w/E9G4whZLX24vITK6A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055388; a=rsa-sha256;
	cv=none;
	b=DpfpJ8hjCH4HF4nkSeEmciqKACnT1bKvttn9CdEQPkLOLxvnU+J4iHdY6ZwGHP2ytj4r+4
	ZBSL/e1DESmTjyVw9JrlAda9NtCdo+2cyfnqOAwrcRFtpxzOyt2og9xFrpjfNEcFfQsen5
	WqDJ4UkkP6UnM2E+AT3iB5nfAHczXEY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TkEikQa7;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B634E4370A;
	Fri, 24 Apr 2026 18:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEBDC19425;
	Fri, 24 Apr 2026 18:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777055387;
	bh=3kkooBEHJF5hLBMrc88e/f1Fx4klTLxcQLIvIY/U0pw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TkEikQa7+cB0BwOlrtQLBC2F8wSXhYtRVNQR11G6dPJNZqLw+ED3uvByC+3EPR7fR
	 u/5hKjCBfJo635Lqq+gMhUEX+p42mdk4Yn3cTlrG9iGOI0OClH03vexG51H8GpqQVc
	 8US1nADY16Mb6wLjtIA8VnRBe8p9RitxsQ3c8+Uw=
Date: Fri, 24 Apr 2026 11:29:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
Message-Id: <20260424112946.4b4ba29987e166dfade76c2c@linux-foundation.org>
In-Reply-To: <20260424172208.11674-1-nueralspacetech@gmail.com>
References: <20260424065922.5f15ca8c88eaf8a02847af17@linux-foundation.org>
	<20260424172208.11674-1-nueralspacetech@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C03771C0002
X-Stat-Signature: 1gfnmierabze9a1d643r9wzwpoury8z4
X-Rspam-User: 
X-HE-Tag: 1777055388-224735
X-HE-Meta: U2FsdGVkX18WS8ZTipFI+c9FNq+Cf7bqONXpsavFxxHomPXIbqtvvymSc/pynAuIR17d7mulfmmOBRIfiXesnfWTprZ619MoA0QV5cqaySE/Ww5n9k/eVaHasDtaR8Oofrra8YPeqUnxfUwNgg/8Ih6FpgFOUb3RGkZzug2qoLQQ4rcz+AK8FtQ63hiT9i57sPd8icK/SrTguFeRY0lmBdMYZyT5NuG6gWsICEXankTJ/q8rOaqGZVsmF8oebq05Xw87XdHiTeA/980hQZLTLl/L0iQGnbsbPREXmSteM+3M0VSs1QLiDcRe3uQ3XYQ5900JuXb8qAEpIbs587ZDzCrG0K65MvIShmEIaC3eIvip53218yL7+q6i5WXNmvkdC4Y45OfjqG4cxcmMFm54W/E6qKv9hnGoN1JQSRzOKIHHqLuylgmACkmYEOg8DzQWRifysgPWfYIMvgA3d7vuEp1k/NCgZsSwROKrFoiRot7UA0+A6eo2QFXK7U9ejiIBkGEjTgKzWVgSH0SrzGbdkdLUdN1OBK097q/J5U7IlVsxmHbGcnV1OF5ZAQJW0tzGYtSeC/yHXS7CZ51DeOY+1Z91Pz6cqUcZYptYvcm+5Dkq0afdlFWLN0LyfGsE87fvJu5C4dkiXxWbK93zOEnmKe8W8y7kwHhV9bqcTAeEto8fjSSaqKYYbSqojA0/8bPwvDKWIWrMKlGwu+v6/CfBHMD4JqMPyBcWd6yWmWXEMdV6PKTc4eBxki9PkZGA8rk6NjB0HUvaNP0YbEThboV0DsAqnfJTj+SXvXLOWjh7s/oOOhbeZwUc8+fAH/abbE4XS7PqO3jNYHTiWZtC89lG1q/mkXid9Br1oAh7p7T9eDXqeZdS5Z155VwVh64PYY1HWqEUHM6xFoq07/4EGk2ymzKnHjUnXD5w/deYEzquafY06lQyUpSMJpkJvqRF4TqvBgKzf7VCyvfpmuoqwpw
 2kj6htbx
 8h4zrebmS27UzyJjzw0Lr6OE7C47ASgGLg1sn9uCGJde/NLgog5Syae+EJ5gA7SvPQmVfAN59UcDKDuXeqgKOQk8bcY7lRNTV1PSQ7kxYf5uEUU8BX1lVcbXfGvXbkNHMsctrEuvgfAVyqH+/zDoT9HR4rNv1Zhk2slD1HgAAW803Dd9iDhIQhzFcJn8XDnYjbpIswJufeqa+VLfJSRy4YQs3CPt5S2MgxMNQwFIw/5k0vxw363RRPsc8bTNXNmanw75kDazoiidbynrmIySCjLShUrRTiLKJbzcxY71LOtlQECmwHHC+C544NmOMLuD5mbror9KLcGyEdNcbiDSaPFnwlIj31e5QLW0Kidt46l5emHhQRtkQWr3RDu4rFJ0jvyhdSToAHlhfT/SvUdAVNDglVq6QE/wiK2td0+TYyQ8anidk+wFZFsfO3Vf21/P4HEN53AcSHglUd+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 22:52:08 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:

> On Sun, 19 Apr 2026 23:17:43 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:
> 
> > Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
> > with a simpler VM_WARN_ON_ONCE(!folio) check.
> >
> > Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
> > !is_huge_zero_pmd(*pmdp)).
> >
> > Refactor the PMD checks, making the control flow
> > clearer and avoiding duplicate condition checks.
> 
> AI review might have found a bug in the surrounding code:
>         https://sashiko.dev/#/patchset/20260419174747.10701-1-nueralspacetech@gmail.com
> 
> After looking into the AI comment found two potential leak.
> 
> 1. The goto should be unlock_abort instead of abort to ensure 
> the spinlock is released.
> 
> 2. The pgtable allocation at the top of the function
> is indeed not freed on the unlock_abort path. Will add a
> pte_free(vma->vm_mm, pgtable). 
> 
> Since this patch is more of Cleanup on PMD checks and
> Warnings Is it ok if I send different patch to address
> this potential leak issues or need it in this revision
> itself?

A separate patch, please.

It's best to prepare the bugfix patch against current Linus mainline,
then any cleanups come on top of the bugfix.

Thanks.

