Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9D7CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B326B0088; Thu, 25 Jun 2026 04:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC386B008A; Thu, 25 Jun 2026 04:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC586B0092; Thu, 25 Jun 2026 04:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 866736B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:28:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1D2CA05AC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:28:22 +0000 (UTC)
X-FDA: 84917758044.22.C7136CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1210C40007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:28:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vv/BFSEI";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376101;
	b=TK7QUOCgpkB33hTCQN3l0gh3UBkOF+hQOrHjdfRDR+Cx5rU/8JcLct1ZumyN/PeoC6h7v+
	uZRrKt8rla/OST4qo+kWRYXFn92peP+A9gEVrZ0PQLVEAyzyIjxoA85YwpwHGhy3ja6j3B
	fKUG4e4LmAj/k9ObHIfgXWt/FpwhOQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egKHugauFVcD2XmzNTTw3d2qyTB8B7rTgdVmFNmqNrg=;
	b=ZFjpSFN5A2IItzXbXpU9YHtkostnCPLohNUoIN+2I91e+VoGj6Q8TRVV3mBonSGbTtZbhJ
	+h6ZZTN6B9CDvFUFwmNmBvkMrgNQ6D41X2sZq6UVjVbBqVhiJDUmcWi/mhTdNv9P15aRuD
	a4tyz7Dr0SiDHycadT8n02PGVjFzkGg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vv/BFSEI";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 503CE4071D;
	Thu, 25 Jun 2026 08:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1395E1F000E9;
	Thu, 25 Jun 2026 08:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782376100;
	bh=egKHugauFVcD2XmzNTTw3d2qyTB8B7rTgdVmFNmqNrg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vv/BFSEIrXCF8hk5q6CGRIvgWvOV5dQsjW4VlCOMp/qdSdxk12UM4sQxtefRbTzOp
	 QdXuqVGkYsFyLEwaNMZag5GRtXKhEo8ddH4seU+ZQbFr4eI/RZwrVn0nrHd8cMr8Al
	 hQGiJp1NVjM/TA4fwEyDEMewqt8B9VGV1NsEvo9G/Zbb6vVJV5UN2EZlr7XWRJpOco
	 +VQoEcH1OlXNI1jpeU76sFyrYPyzIAS+aGyItEhL1vfE6sdJ36CvFo/azd+A8TfX4x
	 Bru//XwEltp7BC/88i5rhtt3Op8hWVaFunUX/pAWuHTU+hoxF9iYMfsoqOtj42gs8M
	 P+Prj8fBTAaLw==
Message-ID: <237cdb97-5abc-4c89-a0cf-1a961425f947@kernel.org>
Date: Thu, 25 Jun 2026 10:28:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260625042853.2752898-1-dev.jain@arm.com>
 <ca31c254-504f-4857-bec7-10b8c2de94ed@kernel.org>
 <614e89a8-5108-4ac1-bdf8-fecca48bd91b@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <614e89a8-5108-4ac1-bdf8-fecca48bd91b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1210C40007
X-Rspam-User: 
X-Stat-Signature: 5yo9ocmmctm69dykys63e91j93km4rx5
X-HE-Tag: 1782376100-213822
X-HE-Meta: U2FsdGVkX1+lwyDW10EHt2OnusldY2LS9T68PJ8fkdf2WgbxEeiNSSZR/9Gty/k1FxZByO94g4MOMRF1ey7IsMhiWODcRbZo4d3xfu1ShE8Kfh6KKVNbdCOKE/GFsSi1DNXxuS1mIMVe4If/UpmUgcqGESFAGzMs6cMwyhemJF+8g5Xg5gLA5k8wowCJVQU5G4tEgD5jwvrYyvbFloMI3D/V+/DMNV7n0JzOrWoLkQDUVRdG2Y82sD09sBuZugXgR7x4LiMUXk5tip/9fqBS7i4Cgx4SIOZZvZRXMy/332aRYSHzXedEbw+cViC4dNDKiZ96kkKM/KFjoAuYVQyCc+s1dpNx7uNTcPiNEbJEsi5nCoJePQt4hO8X3PNtzs+PLrbGZtF8+esnS/V5D+5qtHvmSGO/9Yyq1MukFDd6B3iL91lQYX1Riurn1EJzkXic7Gb6+lIZdW64/1O4rKFe6jRUaQ6E/3fV2Ctz8jzoIlwKSqpc6mBfcfuTfkLTqAaRTkYcC7R+RmpmycwJoi2akEFoQ9P6wSUOWYL8vSOudI6PKI+XBvWBIk8pfspj808Pf4ZpONeWqJ37A0Ckz4SWaI9m/s0BVIIPSk5TXVWlWi8FVFHEuPoAevhhnsG4AR0YgYpMumo++NjPi5jYAtybJMLVyM1WFhmzkK80MbvW7tznmkdzkblqCB+tNosaJ+iVk1rTIxn23Dc4CndEwiyVVzV1vylmFiVD5ACvi/JYl+pQMhtR5mfDsmIVt+gDH+lwhHCvHdoetkZTcpd2kjSGsfv7H8sgx099SVIfQeLwrnYMrNpPBN5ojcqxAl5n7ljSveYDAVf/DKb6OyPo4PWfa+s0uXCypZ47qu+oyM2yOeWZzoiM+vRl/XHjHkJmRsZ0aYqUWvWHGjNtSrbFj3UiUupoFQ8gk3h/Bh/pvApdlzga/5gAe5mLgJ5E28ZKCRqU2nwu8oYEdvRdPVXq0Pt
 46H1nB5l
 QL1yeTlWG5CkPkJC1MScUTP8ObaHX6AmZ2Omuf9zXYPGMZ6vU614UCR1g0MSys7YnuhUhOhNFLVR/qZPdegrTMkE67j4dRiEG414vaX0E0qeesP0Q+HC/5stcHyhk2zpJKQmLgFzhYzUhCzorwS0QY4fxog9TO1Q0ynP4fz7mHC/dP3LQmjYFKRs6M91KuRevsmijxuOUzRro9tYn/6a9yiiBsaVEj4rwXA0EZ0IzMrG9exbj5x9M2kUECQ7K6eL5SSqXf/5i8yy5gMWtChA/nplzz7+rCsE/0yuwdTHefaE4CfkRYtGu3c2kjIVzBa3Ma4sc8079wTtRAk9X53pfbbK1JHxabRvP2SSVmzPg9n52XAcLrkJPn4pu2jL2A3RsfNe2ZYTXuSwM2Yg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 10:03, Dev Jain wrote:
> 
> 
> On 25/06/26 1:26 pm, David Hildenbrand (Arm) wrote:
>> On 6/25/26 06:28, Dev Jain wrote:
>>> try_to_unmap_one() handles hugetlb folios when memory failure needs
>>> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
>>> case page_vma_mapped_walk() returns the hugetlb entry in pvmw.pte, but
>>> the code reads it with ptep_get() before decoding the PFN.
>>>
>>> That is wrong on architectures where hugetlb entries are not encoded as
>>> regular PTEs. On s390, for example, a raw huge RSTE must be converted
>>> by huge_ptep_get() before helpers such as pte_pfn() can inspect it. A
>>> raw decode can select the wrong subpage, so try_to_unmap_one() can
>>> install a hwpoison entry for the wrong PFN.
>>>
>>> The userspace-visible result is that a later access to the poisoned
>>> hugetlb subpage can miss the expected SIGBUS. With DEBUG_VM, the wrong
>>> subpage can also trip the PageHWPoison check.
>>>
>>> Use huge_ptep_get() for hugetlb mappings before decoding the PFN.
>>>
>>> Before c7ab0d2fdc84, the bug existed in the form of a plain dereference:
>>> we would check the head page pfn of the hugetlb with pte_pfn(*pte), and
>>> bail out on mismatch. This would mean that the hwpoisoned entry will not
>>> get installed.
>>>
>>> I am not sure what is the procedure on such kinds of very old bugs - how
>>> back should I really go?
>>>
>>> Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>> Applies on mm-unstable (d17fe8a046a2).
>>> There are similar old bugs present, in try_to_migrate_one(), check_pte(),
>>> remove_migration_pte(), prot_none_hugetlb_entry().
>>
>> Yeah, we should handle all these cases properly. Can you send fixes?
>>
>> Using ptep_get() on something that's not a PTE entry is shaky on some architectures.
> 
> I can send the fixes blaming the commit till which backport is relatively simple. The bug will
> still remain before that, where we don't even do ptep_get(), just a plain dereference, if
> that is fine. Probably no one is running pre-2017 kernels.

The issue is that we would have to analyze in which cases exactly it would cause
problems, like when migrating prot-none hugetlb folios on s390x, where
pte_present() would not work as expected.

I don't think any of us has time (or motivation) for that detailed analysis to
make some odd hugetlb cases happy.

So I'd say, let's just fix it in a simple way and be done with it. Use
best-effort Fixes: but rather state in the patch description that this was found
by code inspection and that the actual effects are unclear (e.g., pte_present()
misbehaving on s390x), and using huge_ptep_get() is just the right thing to do.
-- 
Cheers,

David

