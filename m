Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7C4608363D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 13:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGos98CD
Received: by kanga.kvack.org (Postfix)
	id C83766B05B7; Tue,  3 Nov 2026 08:33:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59A66B05B8; Tue,  3 Nov 2026 08:33:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B715D6B05B9; Tue,  3 Nov 2026 08:33:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD136B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:33:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30394A7F85
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:33:08 +0000 (UTC)
X-FDA: 85393898856.13.174BF4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 89C381A000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:33:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGos98CD;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793712786;
	b=2+spBW45Ia30Y/n3YMTjnPn5oQTOqGG5wiXbwgNuyVHMMRyELf6YQ5GdS8tKlsAKsuQGpS
	OEYhhvcnU893HYt+gKqT9jTZMpLBKGoZ4v0LFb7Ux2AEH2sGWIbfacvsrSdH/vVJgPaCkf
	HDBSDOPLn+kpIZKClapf8TKx/sOjtCk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793712786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22QbouE8cQ/+KqBR8JqAf++7e526LrzApHVyHj4Hi0o=;
	b=G/MtPgzzReqAQUz10rcPCsjqjVA6NnWbOlZy1BslkyiNT4twXGAL4eP2q5qefNyucpI7+H
	gh07+D6mMHuQXD0wZnjidEcU2oBmjtCEDDCobkdvF3+2uhTw8fEe55io1JWbzRdAFcoxaZ
	snYg5JM4NaOhqy9eZ7RSydOzFjQrdN8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGos98CD;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D612609EB;
	Tue,  3 Nov 2026 13:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE9F1F00A1E;
	Tue,  3 Nov 2026 13:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712785;
	bh=22QbouE8cQ/+KqBR8JqAf++7e526LrzApHVyHj4Hi0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iGos98CDWJFnllXPkCf8GCsRc1D6heFPT8Ll+q6MHeLy0v8iW8HvOnABe+bnd/dY8
	 Fj6xY0lnNvx0cLeybulsFMPH5PNYyIRtZaE/9+HQvcALFKBJF5CpZ9DqbKjMsCuEW4
	 2TW1HpV2WXbtF9Oa7L4FtRe3U5R48bCtsBvt63QFKRjgrmkiXUi0ajC0sYkULz9nZp
	 t/WF/tfglE4p/ZEak3bpvtrg+FjOIOPDTrQoV8xLABTyokXa+vv9dbyQZOKsn1GvnC
	 6jTiDLxOEDzEByv212uS/1McM8X2HI0QUNmfWdbz7KAQriKAMzyv2n6EF1JN9nSZQ0
	 GREHWwMO3yiyw==
Date: Tue, 3 Nov 2026 14:25:42 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
Message-ID: <20261103122542.GH264423@unreal>
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
 <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
 <DMEVZ5MU1YA9.2X3HCCHNQOIA7@nvidia.com>
 <829c448d-e6e2-4874-a166-7624e87489ef@kernel.org>
 <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: ra4utzmkwjqicjfrseiccmuuxr3zf9xw
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 89C381A000D
X-HE-Tag: 1793712786-510418
X-HE-Meta: U2FsdGVkX1+F53mWEFB3fFCKGpjPf+PwCUdhtVoIbcrN66e1UArlfrtNmX5b266YmsXtD9UV4TPoYI6e7kj0fIzRvesmEkQNR9dxwJsMR5mE3QMeEVjg0gmtgxANtBOM86xT/m9WM4RLY1aNoaFyPv6NeGPGXCfEPQrrEx3UXjxHADVRUKqhfiPfUpJNlSsX1YLryeyoL5SEAtkr+S2I7BoJWvh3dQuElynqKL0FtA4zIU73R9G4ueYghO4NfGTxS5mZJu5A0vJYXJCYPLDjqzf0VQo1MMMDiS2NmGJ8UctiQx+EtHBasgmyTncKo51+6csileC+2F7+5hSrRX6kAaAwH5phe/1bGW8VIjB9FkOCXZXDVJ/9L0FYyt6gBdZw65Jw+bAlEkXGOZXMuFoa8/pI6ToVbKr9bPHntOgi4FDoP4PzwO3P7l9ZicIwtV4zUs8dyWDHLX+WIKvCSmkeJ6hfK3zJAWfsmBY+qaOrlreXO46xmcdHz1bzokS10hVZSOG4vUN4NS4x5cg7eAIZ9rEQPYSp8/00iNpXFgiTSHdtfbQD57mexSlgY8OPc+ULj5Fjb2g6RRFaQOmbgXBywnwIVC6DtZCZsoD/b1UkSbg3cAyuGBF9pfBH1IASftSlj1MdsKbT7RaFOJbkdhUZxaz8Q2HE0qdhRv0OHKkFvy2E56zvH3zwmuLDTZ8NF50rrH6ha95WLdEa+/lvEUY3gdS/ciRthMJ8/FI5ksc5HrzQBf44zMfnLVK22b5ZISc516NWmklprulX7uCsUegX3FyUI/oqe267zJWJoO4NzxG0AiHh/vqwO7h3FCA/4utfWd/9l+s5hEWe1EvJH+BiSTb3F8l2hCeG2vqRqEdmD2NQERJQqxBuO1339pGWwEtdMLrQEIxzht3AADDYyAtrq01eAy0mgFIfterCgxbpJ/Xl4Fw76hUFvqokA45PyVVeizMfBe88HGdSa1wC2W2
 VB16j+bN
 wXBmlvPs2F11iyX/H133ocnl74IXP/3DMg3r9T52dJhikkV8/Uc0eAhePJaVy8cu4wjIOFcRE8DzyfHCuSN6zk2OozyMcDdmyfNyGWSMJtycvJ4qzFtHszh9CV51UYmgQDTXcSeQSuK8qIcQ9drU+IBJe0hJBF7EVsXuxeFmMTUxtqW3mCeL6URQAD5MQe3uwts3nRRgRz0VDBeZ4PoYMAtBsjOIyFCmFnIkGBLTdQ4BFYEEIYQnDcCh3hP5CxLN8vfyjTb3pE0vdM2wW3ycbkhtSX+NHltiEAxlgt/dYFBB6OlWijdcZtc6GLLk5or+pqIL1ZP5VcNkaRFk0ieh93WDVuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 01:49:23PM -0400, Zi Yan wrote:
> On 28 Oct 2026, at 4:43, David Hildenbrand (Arm) wrote:
> 
> >>>> +	/*
> >>>> +	 * VMAs that cannot become writable map the page as a raw pfn, like
> >>>> +	 * the device memory it replaces. The page lives as long as the file.
> >>>> +	 */
> >>>> +	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
> >>>> +		ret = vmf_insert_pfn(vmf->vma, vmf->address, page_to_pfn(page));
> >>>> +		goto out;
> >>>> +	}
> >>>> +
> >>>> +	/*
> >>>> +	 * This VMA is forced to always be shared so this doesn't have
> >>>> +	 * to worry about COW.
> >>>> +	 */
> >>>> +	vmf->page = page;
> >>>> +	get_page(page);
> >>>
> >>>
> >>> This split handling is pretty horrible TBH.
> >>>
> >>> In once case we take a reference in the other not?
> >>>
> >>> Why not perform a PFN mapping in any case?
> >>
> >> For writable path, a new vmf_insert_pfn_mkwrite() is needed, so it was
> >> not fixed. I can fix that part as well.
> >
> > We should do that; returning kernel allocations from this function in ->fault is
> > bad.
> >
> > How urgent is this fix here? (can it actually be triggered?Specific hardware?)
> >
> 
> Not urgent. Like Jason said in another email, RDMA only runs on arch
> with special PTE, so refcount, mapcount, rss are balanced. With DEBUG_VM,
> zero_page checks in rmap will fire on the returned zero_page.
> 
> >>
> >> The read-only zero page part might need more attention, since
> >> we just prevented vmf_insert_pfn_prot() from using zero_page. Do we want
> >> to add the support for rdma_umap_fault()?
> >
> > We just have to make sure that we cannot install it writable etc. But that's not
> > a concern.
> >
> > Just have to be careful :)
> 
> There is one wrinkle, it does not work on
> s390 + mm_forbids_zeropage() == true, where zero page is not present,
> and a private zero page is needed.
> 
> Jason, is RDMA supported on s390? 

Yes

