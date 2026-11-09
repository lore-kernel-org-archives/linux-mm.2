Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14CE5606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CF1KFL6T
Received: by kanga.kvack.org (Postfix)
	id 2C7366B00EF; Mon,  9 Nov 2026 09:41:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E336B05B2; Mon,  9 Nov 2026 09:41:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18DE16B05B3; Mon,  9 Nov 2026 09:41:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE62F6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:41:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 725E312068D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:41:08 +0000 (UTC)
X-FDA: 85415843016.02.A2D9697
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C74380002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:41:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CF1KFL6T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794235266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bb4YiGnWy4BM1x36qZFjtxE5DebHJsBBn8AssHQWknY=;
	b=pWwE6qqBm52NT/ERsDdWxYkrvh6pA1NwJ8O5XkwhqsT+cy/k7oJ4sOX+83Ew5yP/mZ5GN4
	WnwRa3DgS3S7PQi5fjtSrNGAHSr2d9meMKrB/zzkv0XqfqHGR5rLVpuEdqLfp8mi1WZisE
	Pwz7ledHpW0Z3J4/KaDbGYIsUHjryXg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CF1KFL6T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794235266;
	b=rjAJtElEU0v4hXGVCsOoX9oizSNiPKRU4/Zx6clubbco0p38+/E2RDcTAMe9Pc5AT4WZsu
	JYYiUzSOY8ViLpAhfkql32u64KGXTKUgldODxA677ZATqCLThjjkz+DMjCilXnVOOCa8/6
	gmVjy8dFS1J1HITX5x7Xz1fEt6RMWYI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CBE661EAA;
	Mon,  9 Nov 2026 14:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DE41F008A2;
	Mon,  9 Nov 2026 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794235265;
	bh=Bb4YiGnWy4BM1x36qZFjtxE5DebHJsBBn8AssHQWknY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CF1KFL6T33YetD69+P7GucCHukbQjGhEBH35RiH9duxGWZzk2iZIEN/tZ1ubJiEHB
	 KlOaAPqLPl7LsnaTrgQE4HJiuWzKs/d+P6iNCILhAPO37vUQc6vkKHaz16SF7h2PhP
	 FxPMx+yYubvFcdEsq8AmU0b0DTWvZduozQcBfGtDne5UGE/I4/pL1D6zIwjB8qOSxe
	 jYTWtJ31rORIv46mWJ17zcjz8Nbn8NC+QnuMMtCn4wSKKWS/vlnQp4hfbSOCKZ7Jz1
	 Z0XQ8Lwsu/ljB2iD2Y1UYmfvA21tzwYplmpFJ9zRtWFDeU4KgO/wYZ37hR2fXMUWaG
	 4qTX6KyeI3vig==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id A95A0198003A;
	Mon,  9 Nov 2026 09:40:59 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 09 Nov 2026 09:41:02 -0500
X-ME-Sender: <xms:e9vxav6gnDUOCTGY5iKET68F_S4Ks9C3DO2sWsFkX12FmHJd1xc2-w>
    <xme:e9vxaih7HIiWGbhyhMBLJP4QRneTjO9JikqLyDqwzXErxTyDWKSyf84uOIsmibEU3
    e8kc1iUfA_JFNAfxAGMTPotMpAoa0tfJJoF_nw9F7Hl-5VDftFlTgh2>
X-ME-Received: <xmr:e9vxat3x3pI_x5c9_UMgLW25E3ykkt4tkrICwsizt_HlS5caKcjJhLV3UlY>
X-ME-Proxy-Cause: dmFkZTEKdBoMKgMRay4urn9/97JBWLZB/Nc7W3NNbeiTiEDJ6ec/ToiDpx48TwXgpRebBr
    do5JD+UW8FmSuDSDtHrn84fYcLhwJdWovAjzeWqs58LnXsHqTLLbRFnJH9mGU1txR7bAXk
    eHJ337LGBz7I112G150++fVYtthTJYo09fZ73Jn3ogTs2DErUqzgYChLJPKK2OPzIpAs75
    f2NTaueaOVYWzVVKult+J/8Ijul+ecXdLo1ud8dj3CauGAEv81dm/XyZOtUFy203sAiWcO
    HuTgP3MWJJpG6iTz4fTXy2cJkveYjSj7AFdxL1AjJxWPBTfh2XO3zy5pkeBnwcQmkShrII
    pbJ3tA2SqNcroRO1ayORhcIjBOuep9PCv+VbghE95w0P31wIDKFQVreqltAcwNd4IA2lU7
    2bdUB6NsC6z3VqD+S5NNWgz1FRbTTzQZHdaLIRbMu61xP4g9yCQOxdl30XiaqzE8WN36Qu
    q5iOHyGNOMkRXbBsChEqvy/q6kW5Ux2oId3BiZ+cvOifBrx4ZNYy+drauMxS5VRZlivpln
    AhnT1NJST8UnyxYPmu4GIeho7l6pkHjRtU5M5oV0Vs0TGR5gJqPKFg8JCZ2xzsxeaAhdhf
    1y4tvCbHzZvpdG5R4XNHsw12G5D+ZyB/OwvAjdGkDh/O6Y7h5oLRPoqwmCPA
X-ME-Proxy: <xmx:e9vxaoVVHUbrcPMvMG2vIp2Sy6LVHOO-jQFACerr3ZEVwaVoc4sQOA>
    <xmx:e9vxaq2f1muNPK566-Vf934CqSYxufJNAv3pxFnqN6skvoaLSKrNGQ>
    <xmx:e9vxapjr4trfH-DjcVIc3D9y7NnyFICKEug2D07u8BsrEKnHBiPtRg>
    <xmx:e9vxaqIqRx2seoKneFVUn25vlz1U7hPdco2ez1zPjDwOuSpacQshxA>
    <xmx:e9vxaiXPR-7zyf2HymLAVW-skXa7WhUscV3e0M9YsibaePzomnuU-I0_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 09:40:58 -0500 (EST)
Date: Mon, 9 Nov 2026 14:40:57 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 1/2] mm/memory: recheck PG_uptodate after
 ->page_mkwrite()
Message-ID: <avHaScJrO9AIgDdQ@thinkstation>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-2-kas@kernel.org>
 <avHULH5Irb3byJkG@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avHULH5Irb3byJkG@pedro-suse.tail5790ac.ts.net>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C74380002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cjucwm9ixfhrdnubcbfo9cdmf3bghe83
X-HE-Tag: 1794235266-575315
X-HE-Meta: U2FsdGVkX1/KkkDC70dY8K/AI9LqAE6DZoTQpJM6HEuepucJh3pMnjgg7f0Tbma9SXpwlZ3RSKnJpPz0Idba+ZGBcKQBI8MxZxZiFLBZH1oTrz+ySS7fY83rM6MBHWwTDgjnTBCMKR+QxPQX1Jsnc0QKKxqNvl4NlJQSzM9cqHocj5IP+4HcDRH1dXqH1sRqSMbHLrcbaoXVjLFNtadxafiiQlKn32i3UXR5bZKGAGsv+MmnRpeWNxOzcZZRdB8TB2pmFwJJx9fX0eFIQxymJiB4LFCPPmKOmXDJfPMq63Q0R6XBrTvpVX78X/g5FzS1o1c/eOoE6YvCbtIEaxhdUB/CfSShUGkg5hOFaDviZfGgmNhuIZXcTjvs7j4W8BjgBRKVxXvQOdHCfoyqqGD9wtJeaJHgzzHtHwzUi36E4DlZ2Mj9xNIOPtESgCgjRxgavhRCpCJpq6fUn2mrJkMcucxaiSX6H4g9vJzTbJTPTF7Qh7D+Na7ZesONh30NUdlsmwtRy6198p0ai0xLzTvbJs14btJtbPnd7ixKfeodCqi+yc8mP/xkAHzPgDZZJJuPBSiKVdgfOa1XVJLfVMTKDCIx0O6qGwVg2Qi2kA1UJGeXEBpRkzD/5F58o8DMdZWPPcNLWZa2+u2bTsI40UCdEp8F2a6q88wGpFyL/G1uyIgg3Ddo0JxlrhzNupZ4wNfMq0evDMjY8Efuh/3n2gPETcxLFob6gpEKdUC78Wtbo++up7XtuLyxo26lK9uKki2paKRlDc4SSVdXgKkchGxQ7TuboVEtQzL4MN6vaJrVEnvpq917J1aZENfiIhA9rmQkBr5PDR8m0CdMhswIIgyszoQ8P442t2WzcWhtG0UaSCEIiKMbRqLUUESzvDQCGec/LVtLXKQhvkStjENtCiQ3+nqq9MmISIx/x0MjWwIa1+yjzr1bO8Hax8izEzFdSV2KotbZOxZhFIC8irmXsN+
 IjvU4Dn7
 2Dk41sIpU8bNonTfhFerNCOHZY2g33PHEnoPUQ5OOmwP4oT5nfOnRv5hIjVbcIw7UhyN11bNVKC0fa9LnD4h/TZE7iTGhAb9YBWDbnJhuG7T/+iNlXAg9O8PR0auA3DTGTQpeqUdnkOD9wn4/19q+g+k8k25Mq/tVsV8BYqzLNmhlyUkT8PUW/WdkGB7RWkD8WhAShwjEPH20rYqL6GCiTZJfqRFfvxysnMvJC1g7Lu+skM5Dp8TgDxib0ZbGKj/x7dZMNZDE7FwPE1A+ayHERtdAotwBrqW+CQXQscAuOa+jytbyjh69Vfxc8rCmUGYSq1CcDbDce6CAzuc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 02:11:23PM +0000, Pedro Falcato wrote:
> > diff --git a/mm/memory.c b/mm/memory.c
> > index fe72e66c9c2e..cc1d0b7d15c7 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5613,6 +5613,18 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
> >  	return VM_FAULT_OOM;
> >  }
> >  
> > +/*
> > + * A page cache folio that is not uptodate holds data that was never read in
> > + * or cleared, and mapping it leaks stale memory to userspace.
> > + */
> > +static bool file_folio_not_uptodate(struct folio *folio)
> > +{
> > +	if (likely(folio_test_uptodate(folio)))
> > +		return false;
> > +	/* Driver pages from ->fault() never get PG_uptodate */
> > +	return !folio_test_anon(folio) && folio->mapping;
> 
> FYI you can wrap this line in an unlikely() and it has the same effect as
> wrapping every call:
> 	return unlikely(!folio_test_anon(folio) && folio->mapping);

I prefer it at the call site. That is where the reader needs to see
that the retry is the rare path.

> > +}
> > +
> >  /*
> >   * Either the VMA lock or the mmap_lock must have been held on entry
> >   * (see FAULT_FLAG_VMA_LOCK) and may have been released depending on
> > @@ -6163,6 +6175,16 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
> >  			folio_put(folio);
> >  			return tmp;
> >  		}
> > +
> > +		/*
> > +		 * The folio was unlocked for ->page_mkwrite(). If it lost
> > +		 * PG_uptodate meanwhile, retry the fault to read it in again.
> > +		 */
> 
> The "read it in again" sounds a bit too prescriptive but, apart from that:

Okay, will drop it if respin needed.

David, could you adjust it on apply otherwise?

> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

