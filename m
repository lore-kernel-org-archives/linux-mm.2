Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24ADC44536
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1EEC6B00B8; Wed, 22 Jul 2026 20:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7696B00DB; Wed, 22 Jul 2026 20:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B371E6B00DC; Wed, 22 Jul 2026 20:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 871176B00B8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:43:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0839FA0348
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:43:01 +0000 (UTC)
X-FDA: 85018191762.24.A621046
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 669E6180004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:42:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mTqLo440;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784767379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+2kLP9EImJrEMVLvA4gKSuudUGJH4mKmiOkjQNmRDQ=;
	b=CgSdARMVGMiKhikLKQ60AIWRSt4y402HR2Qf8Er1vXy4g0vsqsL+PTWK8j1Q1JC6qOioaw
	CKuqDdA2OMbAup/qrxaWgKO3HjGbevsR0wzsRqEkVmIWl93av88q2ymVOAKc0x7mXCN92W
	bW6/6pKe8RzixXKlhINusvksLAmoWpI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mTqLo440;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784767379;
	b=MQfWqiLsLmb9qrOIx2JpKZ/VJx5Xmn2UM8DrB+9+uVPpQo3SUCySNHOKrFTRRJ6Oth2uc9
	1u4BUykTzqkm8yXzfmujdJxxQYef0z+XUOgws15P9suGoNWK31JUXEm3cURX6wZskmY+sF
	OFFVBUKK7LycChOLTXdpSg3dwB8xycQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B65040750;
	Thu, 23 Jul 2026 00:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214441F000E9;
	Thu, 23 Jul 2026 00:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767378;
	bh=X+2kLP9EImJrEMVLvA4gKSuudUGJH4mKmiOkjQNmRDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTqLo440Dol06r7eUsxr2uCFOzX9K0M4cgRa7uukdEBjKRDQ1wLsKCtZ7f8Qq5wfr
	 HEg+AXOec3M7KXRZxVN9SKxvtbIk0WfaR0noRnTw/eqSsPwHG5II8/naBxyoXSNp5p
	 NGFGcBRNvWCH9UCi8+TE5LCkI6zRdsgUqzKE5nQG2SAKeKf8nWD3KyfQAtysmY0Hoj
	 uHeWSoorIJhn0fv4a11Rkg5mZPJQ3EB+tWLgzAXQnzXblk8qtrNhYswkU1D5Et1Qth
	 sOML6nJjjMcByq0+E0MEjNfXZQMUAoRFBGB/ms+lKBSEAcTt7IgLJePqhrPgswMW+d
	 HB8FaUiy05MyA==
From: SJ Park <sj@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	jiale yao <19888972804@163.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_idle: call folio_test_lru() after folio_get()
Date: Wed, 22 Jul 2026 17:42:49 -0700
Message-ID: <20260723004250.96509-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <amC7kzf4f0lRd_Gu@lucifer>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 669E6180004
X-Stat-Signature: 4gnwrbkkb1b7pgr79fi6itt4zb369pgn
X-HE-Tag: 1784767379-414425
X-HE-Meta: U2FsdGVkX180f/ysDtXFq8r3xFG24lhVqmVE35oNgWfZhTzvRnVQNGHV+tGgp5Kw7DUN1/Gg3K4Y05Jiqz+Q23a++K2EKmLvzJsdeYbl50MbMg6MvZmuMm5FLuHCbqx/kVdx4YDD27YKMRi8ke9tuo4QPi35eEXctTNGp5RICTOyMEyCoNGYD2L/HufKrnoD6tfwiDW9gknlenw/W4FVnj+S3zPhE6cMCdW+PNNtYMaSgt0PdfUCGR6dOjoG2LuLh3Luekbb3L6pjr1MtcbMeAi6L5twiyqCVfW55b/ixQKFxqmCmzagPenukhwL9aKtjlGrRNf0b//J2izBhMHrW0u1eJ6PlwLUkFOeDy7NhI6VgaBKB2XrLZMtNqXSawno7xmlfrFLfgoBfHd96/LiDZi75nDppq34ztxW9Ji1i62sRsIUmNOFULVoLha1qNxLBdWu194+R8aLO0UdkR4SY48nSDxW6Ve6at+6fFMEpmMAux9EuexJ9i6IO+lgPE7P+j647/Dbb4doCUgUcDDoO6Tr6j+jOdFbaZ+lA849Sqc5Uy0fKyfCa8bmD828bCUzNR2KwenEmvsESM/YMUvdz7dGullD4ILJNikzuLhUY8Zx4wy3QihAkGBcJH8XtLstYiJrOGa+jHWIxiOL4SzNJ4sKQdRZiNEaDnEEJDgrWcEMAOsUKbcZFlv0bX9v7IN/KlTOOyXOrPxOVBT+q2j1KCPC9lgpExFBy0hw7KroGp3FNQDdKMOpAD+mpLHM7wmSAM9jC1ztzoZkDS3jW6ZTEQhYtwkfKTfP4mrljfHRlvgAFg4AR8k8CvJWjnlrku8bB8UbSUsudHNuKi8jrSoOT28dYPlU/ANEVgzuuviRTGwPal4y0SXcVoZctw0YkKitxeIfvVd+eutG+ffVNtBvobiwZjUwEtoKTMRUesw1BISYEY54QLxoDR8z1vWY/VLRPW1wlP0MRNBILfeXaTB
 eLIB6aNb
 8nzuC025mX52IYzuSWSNm9AAaiDZDqiaPEppOubSe5KFp03Q9Ce5y10NMndWsCxebr9nXMPz9QkbhY/NMsyoMiSFTAf1IUK/SPcJECaOhBNIBrx8VtMELPte8HiJXbIEwqZTQr5Nb3f0TgbaBmX3YcFaCD9ckXhysGfRCJygf8BwYrhT3zQDrY6K9UUOb3Y/czIKHF/Z2kFdn/IqwRWMORd0fAQY5e8xo7n5deHyzOy/gy4PsPuE4uw5K2VuAO2oZ3612PEFo031tTReAf25s0sctMirHKbL/peciRGIYvdebbhDKyPC1tCSHyla24zIo635yKtLr0g2zChk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 13:50:05 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Nooooo :) this is not how you send patches.
> 
> Also you should _reply_ to review comments, not just send another patch with no
> reply. Comms is king.
> 
> Also - don't respin so quick. Wait a day.
> 
> Then send a v2, NOT in reply to anything.
> 
> Really best way is to use b4, docs at
> https://b4.docs.kernel.org/en/latest/contributor/prep.html and etc.
> 
> But you can also do something like:
> 
> git format-patch -v2 HEAD~1
> scripts/checkpatch.pl <patch filename>
> scripts/get_maintainer.pl <patch filename>
> git send-email --to="(andrew)" --cc="<list from get maintainers>" <patch filename>
> 
> 
> On Wed, Jul 22, 2026 at 07:20:20PM +0800, jiale yao wrote:
> > page_idle_get_folio() speculatively calls folio_test_lru() before
> > folio_try_get(). The folio can get freed and reallocated to a tail page
> > in the meantime. In that case, VM_BUG_ON_PGFLAGS() in
> > const_folio_flags() can be triggered. Remove the speculative call.
> >
> > This is a sibling-path bug: damon_get_folio() was copied from this
> > function with the same flawed pattern. Commit d6b8b02a27b3
> > ("mm/damon/ops-common: call folio_test_lru() after folio_get()") fixed
> > damon_get_folio(), but page_idle_get_folio() was left unfixed.

I was actually thinking I should also do this, but I was again failed at
managing my memory.  Thank you for doing this, Jiale!

> > KCSAN
> > (strict mode) confirms the data race on the folio flags:
> >
> >   BUG: KCSAN: data-race in ... / percpu_counter_add_batch
> >     page_idle_get_folio+0x7a/0x2d0
> >     page_idle_bitmap_read+0xc9/0x220
> >
> > Signed-off-by: Jiale Yao <yaojiale02@163.com>
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> 
> this should really be backported, so good to find the right commit to use as a Fixes: here.
> 
> Also then add Cc: <stable@vger.kernel.org> so it gets send for backporting.
> 
> But _please_ wait a day before sending the v2 :)
> 
> > ---
> 
> Also in the v2 put a list of changes here (will not be included in commit msg)
> with links to previous versions on lore.

Assuming all the above nice suggestions from Lorenzo are accepted,

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

