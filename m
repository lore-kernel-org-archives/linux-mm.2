Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A31C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87BE06B00A7; Wed,  5 Aug 2026 05:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B996B00AA; Wed,  5 Aug 2026 05:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769406B00AB; Wed,  5 Aug 2026 05:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54FC06B00A7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:02:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD9EF40406
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:02:07 +0000 (UTC)
X-FDA: 85066623894.28.1DCFDC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3C57840009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:02:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FvDWd5gL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785920526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=66l5hkhMF3qY+C/lhEJTwIWDv2T0Sfe1Ujylj6oShM0=;
	b=qplqELBaeCy1FuHSI87hZFdsce+lUaOLQXqOIh9ZggrOn/nwnV2AZcLMy58SrNHSU/A4QK
	OPIv88JpJmvnqT4cYOfNEjCce7kK35U/ogP3Fiu3AiJzOBvF2twISJetDHVwP/VTib0iLD
	1Y2ejgnqQXn6JqPZmwbgOs6yuN6B62A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FvDWd5gL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785920526;
	b=2Z6Menj0MBUHtASEcfrtgicBsNvPY7jiXvSusBZ+sxXCHOWtUMvgFVc/mJX8/psoiW0lID
	Gx6fs5ar3quUHipGKfUFEYaurwpNVsovpOEHmERL/eJzMtYIkOZ7JxmRDFN5Pb06FnTQJv
	nFz2H6vnPQsRwuMuokzwiXp8MdBctqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6FC2600B1;
	Wed,  5 Aug 2026 09:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB51B1F000E9;
	Wed,  5 Aug 2026 09:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785920525;
	bh=66l5hkhMF3qY+C/lhEJTwIWDv2T0Sfe1Ujylj6oShM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FvDWd5gLedAF3nNnMaCJ9oirgJhxdVx4jBcpZAAzC0qzYO75osbFDc+BfDmdihS7j
	 B1UKpRlg48RQxGFsStggVP+zgbFlW2Ek5FaO2J1gJ4nECj/WeZvwy6nMaCsdvhoR8j
	 HRty18X26LmzDYN+W3OtJe+e2D5kawLQcV2/OLCbOZsGqfyp7bFqbgY0Ai0PLf4jMv
	 37COKCxILOlCdxvUYreRvTwSZnqe6W2r2ctkzSTaU4hRzCGxPIYXGwhDWD+qSrRbdF
	 NntzsRY/ogQRIztXPjMjddwT4tyIGNz8z+DpWOzrwbSvvhCeP8X9T1zlfDPvMxeSRx
	 B49VqHoTzImaQ==
Date: Wed, 5 Aug 2026 10:01:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 04/15] mm: update print_bad_page_map() to show
 anonymous page index
Message-ID: <anL7eZcHnM5mPr_T@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
 <amrvgjPNfKqWPUU0@gourry-fedora-PF4VCD3F>
 <fec1be38-406d-4656-95eb-048729afec40@kernel.org>
 <anBqV9z6hVLIqoIn@lucifer>
 <anL0LEhb_bp_uQ1J@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anL0LEhb_bp_uQ1J@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ekaymufnbf66wk9989iegycqaoj1zamf
X-Rspamd-Queue-Id: 3C57840009
X-HE-Tag: 1785920526-407168
X-HE-Meta: U2FsdGVkX1/X5jdpEQXT3e1MSnwGW4SZVZjCiT0k64G+eXXf942P18bApPxqDGv4SvR4ul/I2xBdKPtaONkBwHVclUpL6KphRyfliEsYRzqP3nXgozmAqq0xxtNdrlU+OeXbozvNg2XEX+Srqw65zuglSMUzTTqFjeoBKjTAXkA87Oe3nMFGIjyPZiaYKTMfLHker46alOifDY1ngyHrJl8/vGfM6hgPsMUdPZPbxAG3hm4H3AcfzGdyo8qhxNvvOp3r+mzVSTatBNbPddw3n3+5LXJxwzGFwH5ymr/+yvggwHizWprZl4R1EloPq75Cv7I+FK+2oA6D7He1H8mTyMgk6WBJqHp9bxsHcXqPck52iaSGBNyLjHFMyAKVHeLcxae4lfkQxj4E2i/C5w7S2zbJdEJ+l9JgWmaZfI7RCA26XHLjTOVx7rbWIuuJ5XtL2uu+Yi9dE/BcAv8AzhGr0lOMdV3Ib5gEBS4qXPV8aazbEqLPGIv09oyfP3jIjDZAuEPAY4KyF64bzkP3ibojutdn5y8/N7jRyiIr1dD1G/lIvBjygbLSOA5MES2cZ7M7LXYiTp1SoNEZHfmXph1AmoNujiK2ZnddK9KJBEvy4XrWLN39avsqq1zgZJeeaNpzmygewSsHIsb6mNNxkFOpa2bAHC8B4fwWAKg1r+J55bhFcMwQIxaeumHv7ObKxM8SUsT8xXUtAi4xxqE2osAySQoFHaXrS2Qb6KKf9O3iDkmmYmzM+owWKm7tAuFUMQPTtiUk7DIR/9HavnwyeCeLHwqMvT38RbfxQkqSgvIDXMxFP4+I3LeSnYiclBImzPdhcBSA0mNOpgnX805eyumlRREPyL9G+OWVpM2aoQFPtsVzEpkUWFxx6Gig4/l+tLwERfh4ikazsiASQDwwKVS6wAtcsx6ME+XCgeLqmkzx/cE4DUuCZEF0Hb8ljSwjFRu2IHFXxguBytAEo57JVeX
 CyPwPvKc
 xih3qJOSdzTgZzWUrg0e/lT5F+mELa1snhHA1qmuyJrXYCGYwQmv1fdNW8PclFkCWT6h5q+6a2uDlxmQrUWVHPwfqKOGpNeIJouHzNBn0wQMraTC2FjlBFWfKpdPyKCQQGb5V2dClodxHK3CklNh60m0At/FSstWaCsWY7hrJaGm10bOUXtJg681GeKlYjwsPtf8FivPWT5bUMJ8cHmPbElYDczQTRWAzoSbcbX8Hnb6rhPm5leoLbvmH+iqa065PHYy7mjJwJ+g70rRb+98oPUuMLacwHFpGigW0U6Jc7rAwARv1k9jiLn+RkQhwMTGUQ0EHGJxN+aeJMFlDe5sUyT5StniMLPjfDlsc2WYhCt978Z2+tbxwgEq7QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 04:30:18AM -0400, Gregory Price wrote:
> On Mon, Aug 03, 2026 at 11:19:17AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 11:39:11AM +0200, David Hildenbrand (Arm) wrote:
> > > On 7/30/26 08:32, Gregory Price wrote:
> > > > On Wed, Jul 29, 2026 at 05:48:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > >> This is potentially useful debugging information and matches the existing
> > > >> page offset provided.
> > > >>
> > > >> Use the raw __linear_anon_page_index() function so as to always output this
> > > >> value regardless of whether the mapping is file-backed or not.
> > > >>
> > > >
> > > > Begs the question whether we should mark the value based on whether
> > > > it is file backed or not, but i suppose you can gleen that from the
> > > > other printed values (anon_mem, mapping, vm_ops, etc).
> > >
> > > You mean something anon_pgoff_t or what did you have in mind?
> >
> > I suspect he means e.g. adding a (A) suffix or something? Like page offset xxx
> > (F) or yyy (A) I guess?
> >
>
> Yeah just an F/A in the print I suppose.  Sorry if that was unclear.
>
> If it saves someone the head-scratch of whether some bug is because it's
> "file" or "true anon", given the ambiguity here, seems like maybe useful
> debug information.

Yeah will do on respin I think actually!

I do think not providing that could result in some confusion like 'hm I
thought this was file-backed'.

(We've made our lives hard with varying definitions of 'anon'
also... [shmem being 'anon in page cache' is especially lol] so it's
already confusing but there we go :)

I will add a comment explaining things so if anybody still wonders what's
going on they can see what's up in the code.

>
> ~Gregory

--
Cheers, Lorenzo

