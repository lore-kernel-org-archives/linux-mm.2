Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D1E606A33C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fbgXWj1/
Received: by kanga.kvack.org (Postfix)
	id BD9EC6B06EC; Tue, 27 Oct 2026 08:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89A46B06EE; Tue, 27 Oct 2026 08:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79926B06EF; Tue, 27 Oct 2026 08:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87EA16B06EC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:15:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28A2F160A01
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:15:51 +0000 (UTC)
X-FDA: 85368302502.05.9AAC4E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 45D158000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:15:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fbgXWj1/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJNnO55C6AmR58ZbeinAj1BxG+DZ/g7vQRj9tLP8FcE=;
	b=uxzVLhIr3omh3wg5ImgURETzL6udowV+oo2AAfVQGEF/cY5p5IemYdQdM3ILziFNv14COM
	/tV0MHGQqb8DGloXIVxm6zjyTtvsBZZfGsG/zpcKA0H551DozKmC7TaQvnu4+FHBGY47v/
	5GzYijCWOtiSBF87Nj0lUgxT4bKNDFg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fbgXWj1/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103349;
	b=MA9y7pvLffMqHz455IM3UP3nNMC6E/oTbyzpwNHRVpXxs8dj3I8XQiMCgKPILfy2DVUU5y
	iFRXo+zjDl6P9YSO56ZOYfmmcjlN+kiqBwCFIjb/AMbPw3HgqDbb+yOyj3M1BRat1PhcGN
	kbCyF4VVMZlo2Uvc73FRxSxGZWpbZ6E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7142641984;
	Tue, 27 Oct 2026 12:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C87D1F01825;
	Tue, 27 Oct 2026 12:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793103348;
	bh=lJNnO55C6AmR58ZbeinAj1BxG+DZ/g7vQRj9tLP8FcE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fbgXWj1/g519KQ+q0WyFpS2YospmjaHK7RkACo3duGiVboKd5uKktUCQnqfZvIIwG
	 Bwn7XY1iAhz+VlC7yTOPEnHj1UQWBcbAUkNh+xXoknzNybHRuYZGKI7iOeOSkt+XmM
	 REnH+JGDibRQzXQ5YgW0A5NMGkCWu1AGlPMOAjWFuZON8rsevFq5+B0l6t68Im0N/t
	 bpYuIdDj2ztiVNHybuxqBqJ2cKoffhq3Lz1JDCprwnDqCJaHb2NrFljCC9FEgTYzmy
	 OxoHRydNb6JFL8I8JL3+Tmk2ntpENq6Tr3/QsK5027s/x7n1JqPg0sZxRvTf4T0wSf
	 i7GuITIgITgpw==
Message-ID: <916d4173-36a3-48f2-8362-2ce7d937bee4@kernel.org>
Date: Tue, 27 Oct 2026 13:15:35 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: fix userfaultfd protection during merge and
 unmerge
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: xu.xin@linux.dev, chengming.zhou@linux.dev, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, jglisse@redhat.com, aarcange@redhat.com, peterx@redhat.com,
 kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bobbypowers@gmail.com, bgeffon@google.com, dplotnikov@virtuozzo.com,
 dgilbert@redhat.com, hughd@google.com, hannes@cmpxchg.org,
 kirill@shutemov.name, cracauer@cons.org, mcfadden8@llnl.gov,
 gokhale2@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com,
 rppt@linux.vnet.ibm.com, xemul@openvz.org, riel@redhat.com, shli@fb.com,
 jthoughton@google.com, corbet@lwn.net, pbonzini@redhat.com,
 seanjc@google.com, sj@kernel.org, ziy@nvidia.com, stable@vger.kernel.org,
 samarth.colleges@gmail.com, med08elkadiri@gmail.com
References: <20261026130054.91461-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261026130054.91461-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 45D158000A
X-Rspam-User: 
X-Stat-Signature: 8n5iihrq4i437b6jajurobxwacjp9akt
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793103349-373294
X-HE-Meta: U2FsdGVkX19r8x0Vl6myR56Z3e2zRMN807Rv7H/yA311G/7B6e06/lV2dlLlRYmdzqA0IrSySZjopKbfOy8JW+vbrWkDyCcU1W+a/d0MEskPgYTkS5FEralkMz3oLgYoNLpjXZZQca0TcqxZfXwhTg22YsSgc2VPijzBv3Y9XIChTU/RijC4KMHFElxHYPwUKMjCJj9avm7shDhydvIFRCQOo6ZroYsomto5jbMx4jPqQr5ONXWWkbwcDoq2PNvuoEah7nced1vLxqA04NEkawC/2L5wORo/LTZn3npa5Y8OcYgVlmXV3bZzMSAe20egTWAbQonPbriREvgADaUC/MreMYYXlEIG4qohLhARaaXxmfXnz5xxVuUTIN8GuixMClofuyMbHxxFGyvzqTEpofBkLFYSp38O8WLa+iEtsTlV0MBWAr8jPWvGl6ihtbBsSlS1/ZVeSFsPzaVlAPfz31mWtYDOCsfKWJjDiFv9oAzQfVdZyLEtgRSPkRhDPoaBYjQUYno56vPWI9mmHL6LdIh+76Ss6SX7U9j+6bUTbTpDdG8GVdiBKqdNa/rKShG01NYe3eo0n5Q5XeSa1oscD08UAHh1rkK2jK43FR0A7lLQivpeEIX3vRoIM7wT+0Dnmokfw0LAIjfsqUY3Ci+vMlvlkNX6xsRgRFpxxigME8GLcpbP0PPFpSGeRJsPYpophtWN02sfiWhB4y+MwlQEHvqApK4CQz/sAwLGb5anFeNyQNGNLm4LeYhrhH/Esabsd9wsMnO7i3pCjUMlCGoUbrgNLDV7NTaSS/vjTHeR+XitoVYim9vSq0+0RNshyVviI4rPTamwrGEQ1+5Ru9CBNhxuwhBOevuamgSQ2x//d0khT6jYFm2VAdOMXkhGiSUuxBHQj3p5ZNfikxJlDOEObPiheeeviMazRsBKyqPD9jorPQdX5VNE3C/ETr9mpKe0/dNa653Uugcf/+DrG7L
 4frjYAZP
 7yUalMkz9+FLq9JtOvM4cy1QmPFTwFXv94rlAvLnNudVFmP5D0udJJfWAHZLoj8051YS9FGziG7pR/VW606xdAx8ynGyL2rp5PQv4EVDag/Gm0MuRCMNaDwRYwBzBeFXezfHgVD5TDVZqAdsJdbe5Bid/O899g82xhMR8a+Pz7mMVWjZcmOCIy3rJTPZaBvBxgPGKtThJHZVerQh3Qm+WkL5EgccvfjeIwRfuDCjzTRzBBKD7sCTljzCV6XvpvH8iLikF7/F++BpFW2I/t2U2wYtXkU74AjC05EpqBiT3WxyZ6KRBby7N1OEgebIr3OD6D2W4fyNnZGxT9k1MoVy3mZntty2BJypMuH9B0EeT0kOtKEgAm4/OMBtGxZqnFhDZePhm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 14:00, Lance Yang wrote:
> KSM loses userfaultfd protection when replace_page() builds a new PTE
> from vma->vm_page_prot. Dropping its uffd bit lets a subsequent write go
> through ordinary COW instead of userfaultfd write protection handling. For
> RWP, a merged page also becomes readable without faulting.
> 
> Keeping the uffd bit and restoring PAGE_NONE fixes merging, but we also
> have to handle unmerging. An existing KSM page can be protected with RWP
> before MADV_UNMERGEABLE, so unmerging already needs fixing independently
> of preserving RWP during merging.
> 
> Unsharing replaces a shared page with a private one and should leave
> userfaultfd protection in place, as do_wp_page() already does for write
> protection. Currently, an unshare fault reaches do_uffd_rwp() before it
> can proceed to do_wp_page().
> 
> - With synchronous RWP, handle_userfault() returns VM_FAULT_SIGBUS.
>   break_ksm() then reports success with a KSM page still merged.
> 
> - With asynchronous RWP, protection is cleared before unsharing.
> 
> Preserve the uffd bit when merging, and restore PAGE_NONE for RWP. Let
> FAULT_FLAG_UNSHARE skip RWP fault handling and keep PAGE_NONE on each
> private copy as well. Unsharing can then complete with RWP still armed
> for a subsequent access.
> 
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
> Link: https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/
> Link: https://lore.kernel.org/all/20261020055518.36087-1-lance.yang@linux.dev/
> Cc: stable@vger.kernel.org
> Co-developed-by: Samarth Narang <samarth.colleges@gmail.com>
> Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

