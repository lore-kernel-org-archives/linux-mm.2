Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D4F606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GBUKEafI
Received: by kanga.kvack.org (Postfix)
	id 90A176B089F; Tue, 27 Oct 2026 14:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1B86B08A1; Tue, 27 Oct 2026 14:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8586B08A2; Tue, 27 Oct 2026 14:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 581EA6B089F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:59:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37186A0B27
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:59:54 +0000 (UTC)
X-FDA: 85369320708.20.561EEEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6017A40009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:59:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GBUKEafI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793127592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGUNZ2N4izt2BrjI89y42KzCgR2U1rTdgd6e4ryL5is=;
	b=A8TaL08LcxBh258bVXiCfFLJwMS4sqXhPBPK5I2dw89Wa2wsKTO9C/zVRzxUDGmyL7+9HC
	R3mAWb4w0PD47G9iXTQJZfN+BAvDR/8BwhwLJXC41Yh8l4hjE1Y3FVFS52wq3dvQL/iJo5
	GFh0F6wNw/b9jahGS3jmcrEhK+tQEoA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GBUKEafI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793127592;
	b=BpXjaK9YprJACQKY+vZ5V8GIH9YS061p6CFFnUEwI3Nf95wYs0PBqCzvXXWtk28BuB02sD
	KzYRlnWfocgy07rgh12HA57S03rw7D0DACf/Vc7gbY2ZTs9xynqioTHt2Ac6FvQBwBgyhT
	mR2JABh/dxJNwjX0zM/yiFwK8hMCj6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E991416C8;
	Tue, 27 Oct 2026 18:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0381F01829;
	Tue, 27 Oct 2026 18:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793127591;
	bh=JGUNZ2N4izt2BrjI89y42KzCgR2U1rTdgd6e4ryL5is=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GBUKEafIXma8eeUkgoEONyZfmNLHZnhPQGFQVsuGfRdY9VxaySeTjrdbFW7ptRbVA
	 hUEQkqET62H91eVZkZHyk53nOcf57mTBeILoQULyVkmZdRFQE8p7MRFMwmd+fPmc9J
	 ghDxtYg6zcgW2VQrPPTm9KAWwlBvZE60LX3I0qdY9gv6WNhMqeEXyjo1hnMJB/82OI
	 sSPJxhjQSWHFk+C5WoYca/OBl84+pWIDaJqrLB5vwBtxFAH6uVOWKdffQL2T3lEUaB
	 i9dIVYjiU8JXt/LM47PVuhVicGWXoiNSosxfwgnxShpV8V3Fk269UOgTPIvsaNyBUs
	 tdAPnvoh++tOg==
Message-ID: <94116d0a-3b79-42c9-bb31-0ebdbd00effa@kernel.org>
Date: Tue, 27 Oct 2026 19:59:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: allow freezing mappings
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org
References: <20261027173031.763213-1-pratyush@kernel.org>
 <fcb7b786-53e5-49bb-8505-63eb8bb4e836@kernel.org>
 <2vxz33troxg3.fsf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2vxz33troxg3.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6017A40009
X-Stat-Signature: asifdn73iffm1xijjqparsutz3ed9cpd
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793127592-319932
X-HE-Meta: U2FsdGVkX1+Y6X5AU7kujEKW+9Pc5i9Xygsc1U2FmTfGGJFpYzgqPQ/wJuW4bGNyQUomOdwuL066lq0q79k0R9rIWz2OezqzfA4Jt5dbtgNgsHG8HLPyaPvFmFr3+1fH2r2qgzueQm2gkXKGH5xB/0w1zdftkiuUfH5nSvjjojLaCuDfX/6vTHDBwL6+BFO++kMMA9/bNu1O5MdAGFbfyd1lMbFOWbYTmhB4BZwNAV5v/nZjkRIvPa/KBx0xenf8q+AJRAwYCk21qW8rcJRCLipdbvYVTm1zkG8ITLr6UEPxatUEEKgzJfJC4e4OjmTbVKTbyap1+2FHMZr58L040Vts25K9wVUt6g3s8EjsU4d3SGJ8ehHYFIQAJ9hGgGOHimEFuB07it5kv7GNwv/92A/GLqbKOVFlkzCASP9oOpVFuiUdD7VfFS5Un21qvx9FwBwFw6AwWSa/FC9rCtP1mozgE2h99xnkxLIG7SAeiH8aLnjziz/1uFgmww9DeygpPybrsfqIRhswN+MoqYNd3+fIYEtJE/ldTpuAx4motO+nbWap4RNBr8ceGiiUNQy7/uq+5sAZp6syBfaD9HseYqEWymcF5H6d8eqkPLDRZUiLzj0vb9LJghYvrq6m8ziKRi2qfnR+LM/ZdI5tuQeFq4aCtFCdPLtSp0+QvPg64uBcaoLn5w+2eOD0aq+lMh7NLKBYrAGjbgy1FiezPU0IVr8ckoCQQp9rBXGQgxayAebHnn/iB55RYlIEwP8Mo2E/uK+wnuHTuDW1ejqVj4TcVOqkfRSD9SrusoRtIiA48Ihxi5Wc2508oaIhQjD75pNC8nDrq99bPVQFfoKG7/HQI8XawOu8gfR63CZkHaXMkNdvmV1Kv1Wa11sZNOU6+biQzrDcvdc9jml8afnKl92pd3h926uYqcYsi535m84PATkRHARw5IWBmgcdb54HOrFcy//DnBUcEM88uDq1Mqh
 E7XlmZg9
 cEtgpCni9y2y4CPrcuxyt1b3zaYiN8gpk/WOXBryIs8x0/XTRGoeI51cFpq5m4ZI3asH4PH846PnNWMfMM3rumqxVL2qWUo81EL1BRX1X13IXo2BUangFCBC8D5ACDbsGrS0m9PVkHJVzWL/UiWIipNCWhiV4HcBdVEzFgNy+QyGUWhwcGf2F/3Z5qfv1LHOp7LwEBrm8YzoGyqFXrtrnx5CMFdmQSNexdk0DO+VbkbxRHSab5Y74d0wWJ9dtcTG58Mq+3GZoljp6zSpNw2+CrcqJjhn6so6nLHQgEE36VTZMbzEe1OUHNaYfiYO1C4U67RS55BzWuh0f87INUP/AOKe4ouly1Fwwc3kAcMY6R89yM/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 18:38, Pratyush Yadav wrote:
> On Tue, Oct 27 2026, David Hildenbrand (Arm) wrote:
> 
>> On 10/27/26 18:30, Pratyush Yadav wrote:
>>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>>
>>> Hi,
>>
>> Hi,
>>
>> we're in the merge windows and focused on fixing things (apparently all of the
>> kernel). This is not the right time to discuss new changes.
> 
> Sorry. I thought the MM tree was open to changes in the merge window.

We usually prefer to get stuff outside the merge window, but right now we have
our hands full with fixes.

So I just wanted to set the expectation that this will likely be ignored and
might need a ping or a resend after the merge window.

(I'm afraid the fix party will not end before the merge window ends)

-- 
Cheers,

David

