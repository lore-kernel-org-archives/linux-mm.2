Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 318C9C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292A06B0088; Fri,  4 Sep 2026 06:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243A46B008A; Fri,  4 Sep 2026 06:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15ABC6B008C; Fri,  4 Sep 2026 06:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF1946B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:56:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8197E140886
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:56:32 +0000 (UTC)
X-FDA: 85175776224.21.2273C66
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 67B86160003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:56:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S2rNmhuT;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788519390;
	b=RJKFLI4aL+dwfJhmbt81TDHyzKcPtWAO97AQb9SXVlQ+UdrHIbl9u7be0ZJsJyN5HATaIC
	EO+9ey2+5sVP1x1X1GXhgIneXas/gVPTKioCr50Z9B0weaDr3CUdXO/8DMyrCupukqSAYj
	J7Cmge438Ja/qjUgG8YwhYsV8hc+XW0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788519390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IM8NoM49A+ozaM0Om6T6zXkX9aE+Qkum0L985twKnxk=;
	b=LJW4ZJsDS1d1+HdikitCLwvW8g1TWd9ihC5RlxSOJSwuzI1xbIlFOIH44edXpKswf+kTFi
	SSHTrLsOgqvuAk+fNXfdcRb5liavFxsAX9yE+i1Q301sQA06Ew80Lj3qUe6uRsiqLDJl5d
	pObTOHUmbdfguDyVe6m8JJ1rJ0Y+SZg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S2rNmhuT;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87EB5153B;
	Fri,  4 Sep 2026 03:56:25 -0700 (PDT)
Received: from [10.57.81.239] (unknown [10.57.81.239])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F2533F673;
	Fri,  4 Sep 2026 03:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788519389; bh=Jo0Cg8nB4834KwQthZNdLPhYT1OJ9nMS3OZvbrsYpgI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S2rNmhuTTmENs918kTR+Q1XiOPxk9ktuHnukft7JoZ92m+dYWAtk5PqOQ/TfRAMp8
	 bDALhVnplbiEnx2XLIpzsuIvyHVlcN/TSD7l+dGLfUtdERLg8jTfAMUglWLLiKleJo
	 7qGXyqfOJ0GL33LVnVUxEzrw4r7KufRGNKImHiTg=
Message-ID: <78638e8a-4919-4c2b-b6d8-dadc7a981709@arm.com>
Date: Fri, 4 Sep 2026 11:56:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: hugetlb: fix BBM for mprotect() on contiguous PTEs
To: Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260901131823.15799-1-kmehltretter@gmail.com>
 <551663b9-d031-4755-af7f-dc6c22524b35@arm.com>
 <aplP1oUjx96O_I69@willie-the-truck>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <aplP1oUjx96O_I69@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 67B86160003
X-Stat-Signature: f4nb5frjt1nwgus1uq7m4f45xu883omo
X-HE-Tag: 1788519390-428427
X-HE-Meta: U2FsdGVkX1+jK4ukWAIflTTPp0SEX+3NPD8pjqvIt/tjT8mSgR+bxPhIQB9Vq6qWypujwca3dJKv0xYbX5IYT10IDeIk5O5nDNlvAccJ9CRMK+zKysqUyk1gYaKhd0DxNUUmpPTVkcJ1FUqsmTqa0wF72Ugnc9DmbOjlxtZNVxujvmq7s/Ks4zByMKhhLw4HsSN9XgESoykbdqHvi1D1Km1OvWrBP1L83buWUxsJCmo3vWwSQcms0ARkSmn5BHpj7jT6t8y6S7ahGCYjgpp+yWvdGQEVAA8ofJ4MtuXtgcs0cNOpM82CKJJvkB8grbq8lMaujOC/92Pm59/ZcNCswT70y6qV+AAHidgWZBtN6QIqH18zGB65EYzlefwPS65dVPoKzHdQjfEElXTecDWx/40vldKM44VLHmhMW76Y8z9ZCi9HwkB9CM639FEwtx0Yhf7Szb918zQ7D/F+7kNFbQx8gWnJpMAa/cyJ7VdmU0LrMQ7qkJeVarVF6lAX+VoI4PIUTxS94tfNKxPQbTqVYA1pOZciFgOH3YKurMFsHcNrUmQ3jY+rLST+XHsbsC3PHIQHquJxefT3uHfeYnM34lPd2rNeHYGxHe6/60Y1Z70+Qhz2+X7I9DgEAfl8g9R67yQkcdgUaO16G3OpBNf9yJFw/G1e1uPzcgJvLE0hPy6E3eLgyuhB43PMX8hyJUFYmu9IqVQkVhy2d0DwPoc1zv6Jo16ysroDMlUegVaBMOqmsB0SqxG/6hR8MqdaEvoiNkz72zIwQ0RWpFmMllVeGu94TvWOEkdn3994ktdQtbJUGMnOEGl3Ell/gs77ZCokEg/B4rXxKttIDVpQ08Ld0ge70bazZHl6AvhaK41Wh/M8IYydg1M/8WA5PaPKKG8EwoEkRc3XdNp8+tCxVdxXknYhkIBLwk2ernArMpaBT4v84Ql4V2J/e07+PtkGu/EZWukVBGj0whm9n2V1BsW
 wmZV4nm+
 30rOOm2I0B2D1wcOI2AyMcm70+xtoFzDcN+YOqr7EI6t1b2MZBpNS2Mr3cV9L75hPrXxWIfMvCXNTLAYfUMnDvpq64YAZ34JBGO8a3faG55ZjITN3fWl5oH3PNhu7rxpYQFWuduWr3wBUc2P3R2vtAoubG8vwdM1gCqTvvTgpqRunq2oBlXYovKH+ehNCTURjXK768eG1h7iOU9yj2v0me/SkHDJnzC/JM9wDPtHJtL9Fc1JlLlBvEviHxrg2DKW/j8lI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2026 11:45, Will Deacon wrote:
> On Wed, Sep 02, 2026 at 08:16:36PM +0530, Dev Jain wrote:
>>
>>
>> On 01/09/26 6:48 pm, Karl Mehltretter wrote:
>>> huge_ptep_modify_prot_start() clears a hugetlb entry before changing its
>>> permissions. For contiguous PTE mappings, break-before-make (BBM)
>>> requires a TLB invalidation after clearing the set and before making any
>>> entry valid again.
>>>
>>> Commit fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from
>>> get_clear_flush()") removed this invalidation, relying on the deferred
>>> flush from the core code. Commit 410982303772 ("arm64: hugetlb: Restore
>>> TLB invalidation for BBM on contiguous ptes") restored it for
>>> huge_ptep_set_{access_flags,wrprotect}(), since a deferred flush is too
>>> late for the break step. The modify-prot path has the same problem.
>>>
>>> Use huge_ptep_clear_flush() for contiguous entries so that the TLB is
>>> invalidated during the break step. Leave huge_ptep_get_and_clear()
>>> unchanged because it is also used by teardown paths, where the deferred
>>> flush is sufficient.
>>>
>>> Fixes: fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from get_clear_flush()")
>>> Assisted-by: LLM
>>> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
>>> ---
>>
>> The transition happening here is:
>>
>> old_prot+cont -> zero -> new_prot+cont ... (i)
>> and then TLB flush.
>>
>> Arm Arm rule R_JQQTC says:
>> "For a TLB lookup in a contiguous region mapped by translation table entries
>> that have consistent values for the Contiguous bit, but have the OA, attributes,
>> or permissions misprogrammed, that TLB lookup is permitted to produce an OA,
>> access permissions, and memory attributes that are consistent with any one
>> of the programmed translation table values."
>>
>> This implies that a live update like
>> old_prot+cont -> new_prot+cont then TLB flush ... (ii)
>>
>> is safe. Which should also imply that the transition (i) is safe,
>> since the configurations the PE can observe for (ii) is the same
>> for (i), except that in (ii) the PE can fault too, which is fine.
> 
> I'm not sure I agree. As written, the text above says that if the
> permissions are misprogrammed (which they are in this case) then the TLB
> can produce an OA consistent with any of the entries. Hopefully it just
> needs some further clarification.

I'm not sure I understand your concern here. Is your concern that the OA could
be pulled from one of the invalid entries? The intent is that any entry that
does not have the VALID bit set is not considered an "entry" within the
"contiguous range" for the purposes of this. (because it is invalid).

That's implied (if you squint) from:

IPGVGZ: The Contiguous bit is present only in valid Block and Page translation
table descriptors, and therefore neither of the following configurations are
considered as misprogramming of the Contiguous bit:
  - A contiguous range of descriptors that are each either invalid, or valid
    with Contiguous set to 1.
  - A contiguous range of descriptors that are each either invalid, or valid
    with Contiguous set to 0.

In general I am of the opinion that the rules around contiguous mappings are not
as clear as they could be and the VMSA architect has indicated that he hopes to
clean them up over time. Bit I don't quite see your concern in this case.


> 
> There are probably also cases where we're changing the attributes and the
> permissions at the same time, so it's not clear to me that it's safe to
> allow those to be inconsistent (e.g. tagged/guarded vs read/write). If
> I was going from untagged read/write -> tagged read-only then I presumably
> wouldn't expect to see a tag check fault on a write?

Again, I'm not sure I follow, but I'll take a stab. I think you're implying that
a write permission fault should take precedence over a tag check fault? (I have
no idea off the top of my head). And you're further implying that with this
transition the HW might see an intermediate "tagged read/write" entry, and if it
does then it will raise a tag check fault, not a write fault for an attempted
write. But I don't see how R_JQQTC permits that because it says "consistent with
any one of the programmed translation table values" so the HW can't pick
attributes from one entry and permissions from another. It will either see the
old "untagged read/write" or the new "tagged read-only".

Sorry if I've missed the point!!

Thanks,
Ryan


> 
> Will


