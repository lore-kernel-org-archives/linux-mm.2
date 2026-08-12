Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56813C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8816B00C0; Wed, 12 Aug 2026 06:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C07E6B00C1; Wed, 12 Aug 2026 06:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D70C6B00C4; Wed, 12 Aug 2026 06:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF6E86B00C0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:06:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7020A40251
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:06:37 +0000 (UTC)
X-FDA: 85092188034.07.08A1194
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A93F6140005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:06:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YkNUzmJT;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786529195;
	b=TvueAWVi6dRlJZNtWKSAHnmNSGg1aIIwpyGHMQuALmZ+XsxA//gQC4EXyG3C6J03gC3U+e
	q8Mbyyw3miZfKOBj/nbaG3CrrmNUty7HpwWepz1kD9uSQXakIq5hTIAa5bxqp7E2WaGRAG
	LX8pJM54wAHsUoQ0UCchnbs/2n5a+TE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YkNUzmJT;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786529195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqhqgSIAfaVheO7PemO0VNiiqMrnyeL17XE58Cpc+yo=;
	b=ngbT221MXmPCgQ1Qtrs+n5oDDAgGf/SG49zaBT+bmJmDH9289t4JYxHpqTn1Pg+Ego4lFK
	hnU3x9iPY0IOFfyAxPyJBXmU5aBMKoZCqwVHY14kXZG/+uRDN/9umbFo+ipXbA489K86or
	FUxG+sCGUErnhtCRQcfIDIS5k3d6ksU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34B7460A88;
	Wed, 12 Aug 2026 10:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C241F000E9;
	Wed, 12 Aug 2026 10:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786529194;
	bh=HqhqgSIAfaVheO7PemO0VNiiqMrnyeL17XE58Cpc+yo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=YkNUzmJT5tn8OUjA3c0uvAOsWpChPtr6/8oF3EC6rJnrMN3y14gf7LSsdameR3xu7
	 SIwZijLaXEy2Rb4jvX3OAlJo3XODk6Td6kxETo7Rjm90yEIKM9wbQ4TQHDxG+4U2E2
	 DF0OavbdcUZJmPAIn7qn3SqwaTfUVjEZBmgkDdxIQ+8nxBk+pubnBgB5uRSMVhNyzP
	 BhQXHkZm/BcQ7al0BhVup1NSZQz54NXIlbMJLg+mKVv5ZmTW76obcNHcqAqbTsLl2t
	 Zez4yGV3jfHwpgU4da4/x+Y64cy1w/aN9MZkeJ/Kw27HA7yc2gCmjeruq5Kj12/rHD
	 k0XD+y2np0o7A==
Message-ID: <e92915bc-f9b1-4654-8223-bf7807b649de@kernel.org>
Date: Wed, 12 Aug 2026 12:06:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks into
 a helper
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
 <f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
 <753cb38f-66b4-4bd0-8b53-7480efe30ec3@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <753cb38f-66b4-4bd0-8b53-7480efe30ec3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A93F6140005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dnwr6eu96f8a3m3z93wuwxru7q4i4dn5
X-HE-Tag: 1786529195-701978
X-HE-Meta: U2FsdGVkX1/+qLIXGs8O4HDgfMQ4EVM/K7eSY1kjVPNaWIV5ir4Qe3fIbF/4lPGWvpaC9fwjmgktPo3Gd/C/htfTQ2Vfvk1EdWCQ7dHPXzFZiS+NKOnBovjGessMDUW0nuk3XE5PO6gdGPzV+O8gdNV1vpyRXUpWW+PcYiz3LUhjaBG0OUAF812WBdz2ynxwdQdQUaycixynjtUvoQHM5GH5XXvfyg3zg8Yu7CXN8OqgSpeudJzcxc4SaNYrfR0UhzW3k3TqSjtZ5uAJbmVLOuLSMIgAjCgP1iBlrrpjctqAFl/zvIG2Avj0sFSLTFkN5B8lpsZX7oHo87GJjqxXq3mthwItrG5JH3bDmHCwZCLABEcWRL3S2RRqf+S98rA0EPOrnAx+Gas896K5rH5XVojFEG62coy61Q91Nrre6rheY+jKOYYtDJhTuMgnMoJ3NoGq7Dfp9jAiUkf0R6USLoSo0ASTxa+dNcfC7tSiLHk15oGUMGEfL1RaSkJimAxjId7aZKa08YuQSarfKTeRNrrno3z7WduObRZeoV0quQbxmUTEQlHsE5dCb2/VUCfPWZrffDZ7rwjdtecfLVhuKysWj3cDpUf6pDoVfsPbdyM7jpjpeezrp+cM3EElgrvd3XkRnmoULi/zMLRNhNoh3qyPKpgniXJWJ8PCcKYXFtaTN0FyA3n9xZUuAwvUZq2UR0AF4xhDA9+LzSDk6W7Hm/mH858uTj+FwH5fqchR4ntC5VVoHK358PlamQAyvEM18N91mYhMvBwhG3ITgK7BSIl/gJ4rdVjVRe1dNw34EU+eFqw5Wr0Qx6ilFUeniGTC51uVOewa7A/5KyB3ahs3Z05w4LN0mKdbg5LbUrxc8MuL5C/270SKsSKuze+eVNLTTEVqkVMnXrKGtvbnz0nLy8cW9e5qo6L23xj1kmjO8xpdhJRWPMMuTdp6qLnVwLZc0TrZ/Ea3wW5aFZP/SXi
 W1CPmeAI
 KqFhrqo6AMU+y/BvX70gFV12xeU4chOXpnKvEvnyw8rUI08YVIENZkR/MAKyNb+PN0fGgTpgI6mMfmSjGPjjiAkDMaT57/jxUwcHZruBM//patTCxf0RLZ+sX+r/EqJsN60ADNoh5xpWV0RdOCSdyhENWK5NezLWsYT1lCFjQ85+Oyj2ktUhtupPzIWfV464Td0Vm+995yxqyyc5Z/TgLgrjjqmjpD/UrJxtbfzjNKUlmkPXTDOFPCsWhzUCX5IpcZHbm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 11:51, David Hildenbrand (Arm) wrote:
>> Huh, that looks odd.
>>
>> That should just be a VM_WARN_ON_FOLIO(true, ..) or sth like that.
>>
>> But in collapse_scan_pmd() that warning never existed? So this raises eyebrows.
>>
>> [...]
>>
>> I'll play with it to see if we can do better and will reply here later.
> 
> 
> Okay, I think below is what we should do.
> 
> There is one behavioral change: we now longer trace the last folio, which is the right
> thing to do IMHO.
> 
> And I think there is one fix we should pull out and evaluate first: A zeropage with a
> uffd-wp marker is not checked properly, IIUC.

I took a closer look. It actually works as expected already, as max_ptes_none is
0 with uffd, and that will include the zeropage.

So we can move the uffd-wp checks into their old place.

(I think I raised before that the max_ptes_none handling with uffd-wp is
actually a bit off. In general, the uffd handling is weird, because even in
missing mode we can collapse shared zeropages just fine)

-- 
Cheers,

David

