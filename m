Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE2C606A339
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UZ+5BXur
Received: by kanga.kvack.org (Postfix)
	id F27BE6B05B0; Tue, 17 Nov 2026 16:27:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00386B05B3; Tue, 17 Nov 2026 16:27:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16A06B05B4; Tue, 17 Nov 2026 16:27:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0AB06B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:27:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37856C05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:27:00 +0000 (UTC)
X-FDA: 85445896200.22.AE2C3F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E64140008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:26:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZ+5BXur;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950818;
	b=nj1IImqf42cp/MCX0cwe39Ko1wnbePvuYFNA6vwigCOUCVK7Rxpqg3sBGNvWTQQygz/LsN
	opJjy2HEL+03OYlGmST+A8lgbTGOQoDVjG6Yuk/Sm9EC45Na36EWFTUl6QPb/SjueFVUrf
	ycgpArZAvzKOMH9K79PpvIupEiA+q1k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpCOPggCWDAUfqUiJVhLMHoBzHXEidiolBoE7MTTYIo=;
	b=xsRsxKhP57HqZSZPByNutSChiOjrh3j74HMHbR3L/mfD8u8dg/aql5qVdglvTT0zNyPuoq
	8BGPGFZDMq+6Gr1u0utuxobzUmDx8P40U3XlEKH6Dq2i97tXY21V0kDRN8zSE7SxGHA859
	wTx0YX0w7ahx82GmJYRzHDgibTal/tU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZ+5BXur;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA3E461540;
	Tue, 17 Nov 2026 21:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED241F000C4;
	Tue, 17 Nov 2026 21:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950817;
	bh=EpCOPggCWDAUfqUiJVhLMHoBzHXEidiolBoE7MTTYIo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UZ+5BXurcU5jR0IslP0SCsC3k7KR1KUTfOl6LP3yyr5iFoarRW/VTYdAg0yTU1sJ+
	 iEwEviaV+C6Erp2NrTcrRX5AQP33QzvWfDcc/IUfrltPr+qwlungFvmgiJXja4FasW
	 f832n8DxgPWIyD1cE7R8sRogh1BajMiyMNPVrFHfPr1SKM/PEbUgJma2H4rtjE6YlJ
	 mHcAtEVM4O+WAO88OfDfxFyRUfOfwrge+sVjpGIo9XbLIP3mNRI4XymEJ5CdbzP5KO
	 ATeEscM658gFCvB3PxhaNvduz3rrlIhOHHqxK4DNCEVpJEpo13z+RYB8Xbtb+uwcI0
	 2dS8cTsGjXbPw==
Message-ID: <fb021aeb-42df-43d4-9181-5e6d730ed60b@kernel.org>
Date: Tue, 17 Nov 2026 22:26:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 "Gregory Price (Meta)" <gourry@gourry.net>
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
 <20261117-huge-pfnmap-fault-races-v2-2-276007e73bcb@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-2-276007e73bcb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6E64140008
X-Rspam-User:
X-Stat-Signature: dqp91onh8o8jfkgpc56k6y5kqddnku47
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794950818-547204
X-HE-Meta: U2FsdGVkX19Tk25KQUghtryvZ6LOwOWynYv/S6J/osLcWLlbyA71hoWQdp5GX5ZNFqBJ30cPkMOzuJx8jRZFMsh93XYQUBLJR7mJugNIsNTO8DJCYZF+ob3UrjecXuWJUOEznACO2oL1LCpR4Vua/DEb21PPeZIib9ScyQGAMmI0ZCDNxau77WQZ1X7rL9dDLBcz0xntxx1+BYBJppng3T0ozRnT4qGpoMpFpFH/Lr68LHAzx93+pZ57fhpgte2d1z+qXBolpW3rwPTmXvFXQhQ83xrEmOVUs1x154YWqK/1loPuhYLf/qD0bjnw1GlmlrhA8DxPOur5NzQCyVSTV5oD8VzgyvpYEUN7qQGq9HnRL52oarA936JQ9lSbAxg1fomEWYYeGn9Nz+oYlGfChjOkCEUBDbEm8FeA76IMzR7ts5lSuQWXQ6bJ0Lp4WMs/2HNRfoMuGEHO6XzVKzLGRfd7tnBlnlkvCoo3XG9HZxAYliwZmzX+3v8ZrbERhps6H3549URsE57d+XfYmairZCVRUYhnh5tMUtIlb+q0SQIMvhCuohsMoBm1JThHXeGY++YO/X5CO6eMKIe/Hxp57MOgBH3WWcruzD6N7HaIyr8NyaFaJ0Q1rfZ2amXGT5S+1cAn9X1mB4L7lvllRCwstOjr3+5tzcsLVwqhdApMZSVhl12+MnAIWLJfaFiP/Dl5E2BoJbMULEyC8Ked4SPvFMPdNyDKLYGH/0rpALXA/VqIJ0J2WM672jEezjySu2VEjVQAdLfQBrQ33vai+/cHMKinz5E1PHnQNxzTrCHaeEz+zVA3GYb/8XWDyRCzl7oSdi8ywwhHBZwxP3ms5tfvdPTeo3O1lvHqAiqbmxzHWrj0WPip0654MyUeuHbZ9GoHlSewVFRXxoUgc6Zgw0PG3kyd1jjMceypSdKFUa3HlgBNs1UoPmHVKAn7PWvgN4Cvo6N7xW9zSjR/1i/jYX/
 rlwyzHQb
 5KX+IijZt2asqGYobvG2HUVRhN4Wh3qFHH/t6J4C0fzo53wJZBLa7wTjDMefQAyWYxDZHDqcthP5txWDGvh/Z3FP0VhoOiQ1/poQ1GuBKxsBVPikX+yyQ9roXMUbmCVcFwC+N5Fle/CP3wLmpb3nF66eJAMTLvIDzOD1OBTbigT4gRmpgU9ls7Zb5zdMjwQH06YMal1mOupZrch+okcZnsi64j1eKrzjM4y0tLQXyfVrkLbFvfocu/qexn3USI9t41czNBuFcRYY9Joc/qeCZ9kJPmhdBK1HNFhQPLx54lFIek0SWL5te0Rk5whviVnKWUNcbFC8f/Sq+7N/5D5dbnzAVrT6X22P+T/6HqYq/bWKGghvJMBHxgvLyLsEcLKNu6ElDmh9Lgf3BBHFW7fWnD57gDITrwYvkUfmt3RZomUFFnMvfVSHY2DgXG46hYykjBwrk46/Zf2jdjBrsc7y2tXq+znevN6TeS9rJdlVXfozdFvY5QWvfPq4w3yUBcTO5dSbXg472F4xGAV65O2PLARJoCTjen+w4hwZNip4bbVtYsTogndVPccnH+4uiPhlJ/SqA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 19:31, Lorenzo Stoakes (ARM) wrote:
> From: Eliav Farber <farbere@amazon.com>
> 
> walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
> so without holding the PMD lock, so the assertion is only valid if nothing
> can concurrently install a huge PMD entry in the range.
> 
> This is not the case for a VMA whose driver implements both ->fault and
> ->huge_fault and which invokes vmf_insert_pfn() from the former.
> 
> The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
> takes the mmap write lock and faults taken under the VMA lock are
> unaffected by this.
> 
> This can result in two concurrent threads faulting the same thing
> disagreeing as to whether to attempt a huge fault and thus ->fault and
> ->huge_fault running at the same time and triggering this assertion.
> 
> So just remove the assert.
> 
> Target the commit which introduced the first driver able to do this for the
> fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
> them using its own mapping entry lock.
> 
> Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> [ ljs: rewrote commit message ]
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

