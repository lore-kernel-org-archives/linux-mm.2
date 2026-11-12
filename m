Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF87606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TZH94E7p
Received: by kanga.kvack.org (Postfix)
	id 098026B05C4; Thu, 12 Nov 2026 07:18:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070CD6B05C5; Thu, 12 Nov 2026 07:18:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1DC6B05C6; Thu, 12 Nov 2026 07:18:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C51056B05C4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:18:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B64FBC057B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:18:34 +0000 (UTC)
X-FDA: 85426370148.09.6F373F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E142CC0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:18:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TZH94E7p;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794485913;
	b=RvfQtp5QWeptvGGhnDL6JsZwIKrRg/gK80Y71Nou9WGnUR5nBOwxpqb137Q8FNp0Lkmgou
	g7oQlTuzwtmuaKJsRlZqVoDcYUDev18wMbtTlPwtSCuuwYlldFZxIYSZe0ERZQ7U5NDzri
	6+Tk4pri1Q+2FI+22eYaulf17v1eUHM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TZH94E7p;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794485913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TK3aRkLRHP/iqzsQKw5rkUdu5ikzTBwM57q8k3Ae9oU=;
	b=BnHLiI47irFr1pZryjoWg814Gnp+DGp04A57kzRtb7L8Jicfmt6flDkts8LtRwmOojQAxL
	7p11FnIrVUMHPPrYeEc/3p4+bp2Q5nL/zb5LnOWjo4AcfE35eXYETQaLthMo5+yK3CpSco
	G7dVPuu7LkjnAHCkiJUzFkCyzyeEq3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BC7A423C9;
	Thu, 12 Nov 2026 12:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E8D1F00A05;
	Thu, 12 Nov 2026 12:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794485912;
	bh=TK3aRkLRHP/iqzsQKw5rkUdu5ikzTBwM57q8k3Ae9oU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TZH94E7pGMxvMIthbP4IOtLV3POYGe9pY6rVMkwD9Xv0CEZmQqoO8TYZSjuIQJLu7
	 h5UdVya5Fuw+xEGSg9KDgiYYKslo7REsw6t5vSCYAmBfsc1EO43pIV5o7YguuaUTR4
	 b1IYE/pcUNQpWqwTNaUEE5LSdKXQsTX0A3C/CNJ2J3TU5LnUrIGjWowtFGzsZrtcQj
	 gbGj+5Q9kyQVOjMtMphKQlBe+7D6qM71YziIB9zjPGXcgSmpxo3B6dp1s36MozGJho
	 F+ypjaDlZBLArB++wBEHgYOsJxEw6KhBigkY93fvxGAgODc2x5bdDvY5Qt0KIOL5IA
	 mStMyb1AEULow==
Date: Thu, 12 Nov 2026 12:18:19 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avWuajpT8RU9_0PL@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
 <aa4c71b6-f81d-4544-96fa-ed54e78b0de1@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa4c71b6-f81d-4544-96fa-ed54e78b0de1@linux.dev>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E142CC0006
X-Stat-Signature: a8xe3mskfgkomeks5owg4mi3uuzkazzi
X-Rspam-User: 
X-HE-Tag: 1794485912-349697
X-HE-Meta: U2FsdGVkX19Nshc9g3oofIB5yEKDSB2dJ3GVLwCwrz2Ng085W3sT+AM2Wmgc5eATrhEUJ6Kz4iJ8HEu4dMQWUZHExIevR8k251qUPRiBMNZraVwzDZAzSlBatcRwRN+OrQKj1eW3QF/X4aBvhpDpSg34vTujKrjercvitg/tXl5VP0orj0ZeHhQwHmSqTuc+jdis08brAw6r2fh80zxVBaT1g+kFVdkkCGImVsYErNWoEAGzVp45v//kiJh1HTbMEeGU+ALycBOG65m3g6DZ+yfCIkymQMfx3ALE7BBlv0Bn8sjpTjqj+MIK/vAu1sjgWGGFqn4XZeVuI3EUgoAVA3YAjlkK34LoMruqZrsv6UcYZLDa+SXvE9Q/pvCEfcqz3DyAVvr0vSmEUGIzDJEPAGzo+CW7vPUS+hK2rDgYyP8ilXqcaap/vyad8pEdgrog4yPwGZ8acNM6filg9FACP3ivTnCHWGLbDBuDahIrEydpdNR8bzzNlkUxRAA4h6gnQvzBI8wQ/jTY9BS24q/0KCR5eTMRmu9Po7h5XG6VbvLVHS4UozyDJ9eWbD4PKzcxsS+Y9uviNPpQIdUR2WJYLKRdeAU4BSQPDB3oUTLeTiArAJwMLRwp2YgcF427o+hXVtvngMZyiBCrIZEN/NynN1Iw05P+an/4yMVGiIOoOjXlhnBzU78pWaSXXfOxhEXOpmn+jAhHR3eBVBptuNGyW9jLMwDeiIrzVcmLfu2J8tQsEwpl99uHFrQ9X0pTXhPhTScc4n5ljr8jMqPpNCJ4o0XRXBU4cmKbUqcvSPpFyn9oCx/3vjfuG3bJNYlmh1vg82IRl59epXDyz9mnHx2AZQXyzDJrN474a2yihM/Y5NjUXCI/2niUhpYVZZKW3+YkXowyWm1Di1S1jQPT36zgwXApxjCwrFVWdgkZQenwq/VCxR9rXhH0tOGAPkjS6B4wcT+Xq9gXDFddPyqAOvf
 5+NID5LV
 h+8vscD4rk/h0Gfkrsq+mnciLeg9EUJy6Eevg51foBHcuo+/7PvnmMbi92ymMJOF/T84toeZkI9sk1DKCc25Hh5ZKywsLpGSDlGuxoUEyv/A1GNrtIvO/u5GMt8/MUee9pBzWQCV+FVFX49aunyZtpUTOiP7jJrLuIl5RxuCBnZJHEGhVFiYagx2Seicsq/xMJefnqHXSJqYY5Oq5q5mSVFYkA+PS97b8e7LHyZJGkkfQhmubAypHebYrP8FqdH22XSSbJV8s1588HSy61dhny6GFbODxBRbHF0CeCZdvbHZr7/MtdwIRbda3Nkuo/tXyEZ1Rh7pFJEBWxsA2NDQV8FDXO6DtQc4EX63jVVwQ0auzsezvVl3tXqGM9ACv8xRYQe+Ejw9k/4HlGbyl9RUpKQLlot/gd2X4J8Z1C/N6ypJsnVwSs/6imbcfQgf1/2M+JIA7bhHW3ElfM+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 10:49:34PM +0000, Usama Arif wrote:
>
>
> On 11/11/2026 18:13, Lorenzo Stoakes (ARM) wrote:
> > The OOM killer can quickly trigger again after having selected a
> > victim. That victim might not have freed its memory yet, but its mm will
> > be marked MMF_OOM_SKIP by this point, so the OOM killer will ignore it.
> >
> > This can cause the OOM killer to kill an innocent process when the first
> > might have freed enough memory to relieve the memory pressure.
> >
> > Fix the issue by freeing the memory before marking the mm MMF_OOM_SKIP.
> >
> > Note that the task which calls mmput() might not be the victim - if it
> > took a reference on the mm (e.g. ptrace), it may hold the last reference
> > and release it when it calls mmput().
> >
> > Therefore we cannot rely on current to tell whether the mm belongs to an
> > OOM victim. Instead, partially revert commit b3541d912a84 ("mm: delete
> > unused MMF_OOM_VICTIM flag") to reinstate MMF_OOM_VICTIM, which
> > mark_oom_victim() sets on the victim's mm, and check that.
> >
> > Reported-by: Chris Mason <mason@kernel.org>
> > Fixes: bf3980c85212 ("mm: drop oom code from exit_mmap")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
>
> Makes sense, it will free an OOM victim’s pages before setting MMF_OOM_SKIP,
> avoiding unnecessary additional kills.

Thanks, yeah I tried to find the smallest way of doing this, it is subtle
though!

>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Thanks! :)

--
Cheers, Lorenzo

