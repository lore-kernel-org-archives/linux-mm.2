Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C106F483F8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 21:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909D16B0088; Mon, 23 Mar 2026 17:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0DF6B0089; Mon, 23 Mar 2026 17:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7586B008A; Mon, 23 Mar 2026 17:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6FCB46B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:06:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42C791EB5E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:06:01 +0000 (UTC)
X-FDA: 84578560122.27.7E7D058
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 47BA0C0003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:05:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uNnOlIf9;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774299959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pW1plpbN5b2kLbMPGpI+zFLp1dVwpXyBUxCgrFpEcb0=;
	b=7Mv2IY2Dy3mSbgJv43tk2WCw45OHbmV9vOsemeV3Gpk7eGvNREQGuTOQjXtUSRV9ZEqZgo
	j8ARznbIBx74EZj1wt0uC5d2DCMZ84PYKnRX/VpcNLKUoA891aJ5S1eW1eajFdMl91bbop
	sPXOoFcssC5e9zMxTrdMy5baIIgo5Yc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774299959; a=rsa-sha256;
	cv=none;
	b=zKJg9EOdfqGSaU4LCkyNxAHwgN377QbWP6aM409WDkU95nr3hddo00jnACSbcIbGosNXBE
	Qjwe41TEzQ4bRmoQWKUlnkvWyDuin9zOsTM46ZyBhyCMGlJBg0qMK7EQOW/NytWaLSbgOf
	xBAJmthX/CdoSLmCPAkIq2+L5yShpZQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uNnOlIf9;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A8254176B;
	Mon, 23 Mar 2026 21:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54D2C4CEF7;
	Mon, 23 Mar 2026 21:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774299957;
	bh=t5cfjJIioDyKblv+DLTJ5G7Df7yaK/d2ZJVfrVqUj34=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uNnOlIf9NHgTcFSC2Fx+8W1oaHAtXeKVKSFhStuJICX+d9miACGoW1+lZicnFzA7k
	 ZOdq94lWQ5rMDyDx1r9GKu1cOriauJaOjMR/KJG8LerHCcI4LWbL86S7Z8vkxYlu6h
	 ODNrh4KA2x1M1aVVMYgSr3fJqceWZROtT5EKrDJ6Sx84QVdJkqhv+Cww8ecv54C+Fr
	 KtMcEse3f416P3p8LufZ2HAArrp1D49S5+5od3Wu2EXl8XwYF+RVrQx/Tw2zexyjXR
	 x3wnm9JrolLOMMnzvbNT2m8qPMooSnodI/6aGbAITEI/dSsIRkZ9eR5+ocmmfA/3aH
	 HuakEz9FEinfw==
Message-ID: <9648838a-ada7-4983-99e3-d694e803e06b@kernel.org>
Date: Mon, 23 Mar 2026 22:05:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
To: Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
 <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
 <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
 <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>
 <acGqbeSjktT4biku@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acGqbeSjktT4biku@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 43y9eftc4nua7dkjbtcd4iyymjqikdds
X-Rspamd-Queue-Id: 47BA0C0003
X-Rspam-User: 
X-HE-Tag: 1774299959-546440
X-HE-Meta: U2FsdGVkX1/Kovv5dLt/uxVm8ph8tfXC7JlsQUKdbR5YcaUqT1IVSrcJn7QSfDUJln+Ct6rUcdlqeh8KFNAnljxKTPeCn/RlCdjrrL25CtDZfoy3VnQUHlHwKy08a1ixgJYl9hXOQ8ep/xweL/CPnjFG+Dt+QnX3hUNfsFTXGOiZAS6v4oqaQm6CRtRXf2sAML7flHd/F7OloInOpAzpB7XgVtK6+R31mJRK1DKPHxP3Og1uenwiS1G7IqgsOsE/txablvjfbmDWEchEYy57l0qBkbo4KBVkZ15/rQpaLhcRVLloVjfqtEyUrkn9SUuUUhBVCGfkrtsGWlZgBN+/+6h0PqaxMNNGIAWwxpLdIPtQEgVV+OtCFG9CEotExVXuCXlgi0Psd/XHuN8otYgZHyZKuiyD9EHJvICodn/ZIrdjsi2FgDPLe72mzi/0tOxEnISk0gSYLuyrA6sSfKpxF2MH/340ZXe+U1HzwS4qO/Leahy3rENjcbVQxsrIQs3QWYHRH84QryjuzfG10DCC6DAcR1Qcy805Ge43LlQxx4NS23hZrFGm1MQBu8y0HFSO2I0R4LPNTPivRmyt8qHh/Gt3+GL8OJnENV+CIVq2MQZcfV95PpumN0AU5u3eBZOL43loQp0oK0uqupoBC32IV4I1PhpqlwAkWNJXQ/dRDG+Chv3gKcDEIutdD25UmILRRvnYw9Zd/tmd1MoPBTSb3VSG68/7kNsJEgpHPhYPEK3VLYwZtoX0DF9zdt0FKxio+UzTey29LqRHekk9vtat5wmfTyKHk369B2fyeHmvqMs4EdFbuHI2XYuMRhgOoagDFJrH5fzdJ9xRPW8eYuvsi/zuedJoqukPV/D/oJLUgJLyezhvQsnJSYUT2XYup9JAfRk3LkRY2pkzmfg7vHKsuSiHchSUqyh/DbKrisW/9DnZJgv63a4S4ZreuBOxrEJ6Qxt+xL/C5SDeCQJbz/Z
 zMGFVwSt
 bTCjG8N2wqlp1jvoiDp7qypV10LT93egYalKExCs2M1CSNNvcaoQC+ahyUpyVYwWKxf+CtKAGvDCf+L0GMCfSj0inF4WJoO1RKFK9tTfe3WyDxKMc00zDoY8DGQ4wOcfq1utA/39TH/uIdPVCQM64+SCwe++U1s5vKrsj4gv5GcpXeFyw8c/Kn9T9cvpF9zlGbCv6utmD59Re/g8oPDWDVcFaH9Pe1pEJuBvcvyGw1tQuy4M5aYt5Bxlqb/QUMHd0W4XA9kvebYP8lh3H79g+89SQvMbLu/bP4/J1WYfBvNQ5psIDzSNGbKBsaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 22:02, Matthew Wilcox wrote:
> On Mon, Mar 23, 2026 at 04:24:26PM -0400, Zi Yan wrote:
>> On 23 Mar 2026, at 16:13, David Hildenbrand (Arm) wrote:
>>> I assume so, because for executables you would have to be lucky to get a
>>> PMD THP? So I don't see the non-khugepaged large folio support on par
>>> with khugepaged support.
> 
> Not necessarily that lucky; if you set VM_HUGEPAGE,
> do_sync_mmap_readahead() will allocate PMD-sized folios automatically.
> On busy database servers (and is there any other kind?), khugepaged
> takes too long to run and find opportunities to collapse text pages.
> Like, days.

Yes, in particular given that the default khugepaged settings are awful.

> 
>> It is more like turning on READ_ONLY_THP_FOR_FS by default for
>> FS with large folio support instead of removing it.
>>
>> OK, I will give it another try.
> 
> I think the test needs to be:
> 
> 	if (mapping_max_folio_order(mapping) >= PMD_ORDER)
> 
> as there can be cases of filesystems which support up to, say, 64KiB,
> but not all the way up to 2MiB.  I disapprove of this situation, but
> this is where we are right now.

Right, that's what I had in mind.

-- 
Cheers,

David

