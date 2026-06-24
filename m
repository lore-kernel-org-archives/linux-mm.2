Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9E1CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 09:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AED36B008C; Wed, 24 Jun 2026 05:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060AD6B0092; Wed, 24 Jun 2026 05:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90716B0093; Wed, 24 Jun 2026 05:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C42B06B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:00:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 440021A028C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:00:22 +0000 (UTC)
X-FDA: 84914209884.06.994BDEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9591FA001C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:00:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TxiostkA;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782291620;
	b=VK8lwu0yeyUHVuC2atYH1OVS+K4KU6hbl9Ptk4t9i8LVRBexPZPv291q1eqH7DDlWt+xpq
	1GD7/Y21fS27eba1e655BNqeBw8U69C/DhJzBtLhmH+Ks6jThGOJLz2AzEp1Pnfea0lMwc
	pHeG2OOHZYnWCELplcG1r7IfyJqTO2E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782291620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ude7fxjRQOGddru++6y+sDXghtwPibadLNbHTLXVa74=;
	b=lWxUIXezdhb4aClhevlg/QTE3WBEJezxMYN+6M2i6GteBgqwzcub9hr/PUcu9OSpbS84WN
	htkDua3ECXxe1v/lJunkufbYs8o5BhAVuMSk7X6AxPPaK9DlnFZPut12o0w0eMzs74hJoS
	3wVy98ocIu5umhm1l8Zc9EjRv72HtWY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TxiostkA;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0708160138;
	Wed, 24 Jun 2026 09:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011781F000E9;
	Wed, 24 Jun 2026 09:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782291619;
	bh=Ude7fxjRQOGddru++6y+sDXghtwPibadLNbHTLXVa74=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TxiostkAILnXpHLtckz/50qP4hggIdYeAhWBv19SYeKJ2UsA9mpyAdTl2uFBwp9WX
	 6rQlhX/86wZJ8Rg/hukqjeLq/PJ1gh5/K5qliq21GuuiBZJOknZm3gm2kjeuggfW/l
	 7tOpYh3yBcXu3rG+ykqiuUCy+IpRbYB3CMPiOsOwmRQ84pZ08UfCoKnydrlLqqs33D
	 sf4VR8FFbsINdyoz2C3WbEtK5Q+bOGPW7hoQKGqc/Y/G4Yw9OdF0ey2rmMxSWsdUGy
	 2suMZpIhzvWsEFTVb3O2MWCoD3i88l/2K7UO6ib4PBq/JWQFVreG/YXusE1z9ZXUOg
	 As5XjdYOpAngg==
From: Pratyush Yadav <pratyush@kernel.org>
To: tarunsahu@google.com
Cc: Pratyush Yadav <pratyush@kernel.org>,  Ackerley Tng
 <ackerleytng@google.com>,  Jonathan Corbet <corbet@lwn.net>,
  vannapurve@google.com,  fvdl@google.com,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Shuah Khan <skhan@linuxfoundation.org>,
  sagis@google.com,  aneesh.kumar@kernel.org,  skhawaja@google.com,
  vipinsh@google.com,  david@redhat.com,  dmatlack@google.com,
  mark.rutland@arm.com,  Paolo Bonzini <pbonzini@redhat.com>,  Mike
 Rapoport <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  seanjc@google.com,  axelrasmussen@google.com,
  linux-kselftest@vger.kernel.org,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  kvm@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 06/10] kvm: guest_memfd: Add support for freezing
 and unfreezing mappings
In-Reply-To: <9huzv7b910oe.fsf@tarunix.c.googlers.com> (tarunsahu@google.com's
	message of "Tue, 23 Jun 2026 20:06:41 +0000")
References: <cover.1780676742.git.tarunsahu@google.com>
	<48777f4749fa43d5648085dbb2037aa99c144a88.1780676742.git.tarunsahu@google.com>
	<CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com>
	<9huztsqtmihs.fsf@tarunix.c.googlers.com> <2vxz8q85mdyh.fsf@kernel.org>
	<9huzv7b910oe.fsf@tarunix.c.googlers.com>
Date: Wed, 24 Jun 2026 11:00:14 +0200
Message-ID: <2vxzzf0kl3dt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9591FA001C
X-Stat-Signature: hhy5pkj3k3h13qh74g5i7bahx9womp1k
X-HE-Tag: 1782291620-654039
X-HE-Meta: U2FsdGVkX1+SoReL0fZcAkljgXMq0H7URrYT6cbXCRNlj2j8yEg1LODs3jXBQgpMm4V3GFYEgVLIJ3038yfUJRsn4NWbei1YSiFQ/XcvD+0htcpymk/JtcP/Or1D1h8MBfNz6wobo0KwCLyU3I/dtXGU0jXrVWDLmmnMJuUA2gXbn44VNIUlxcxcw+d/o8q+eCx4Nte49p/3Ez6D5NZqprjO5Xlp4rKkEdUBLp6mPTyp/jpMomi3oQrtynRr0J0mDltea8T4Rl31lunepH9wo2A6Tzq7jdaePWIWfXIgSGgyvkklBl43ExW8pLd1c+lWLKMwzWZKwPh+xyHMdGl3sM43/H+xFax5Xc++NLJzXT/cnNw909n9gOlS9Ww9zOOff/VO9tUHOVAZsyOyfOMyNE6yvRTM7ResH01lyBJkFSx3Y3/HlmL1X5lvrXr3myph41+9jf6SzizvYnFx7/45fepA3KwZlcVfD/QsrqzJSO1u5xOtXbyJrOWRFv01bnyj8j5olZc95VSHLNH2cZJOVtA3IsjsRHh/U8ty8PNCIUucaTlkcv8IgpZi8CmrF7nxAlDSc1dFIxwgpOnvAr7UBQ3BXLXX1gj6oOAeTlCND4K21JqP5NA9JBf25gwqDZ/k2Nw8n+TnX2bCnId3jDbufmd2E4tWgEe0+qyGQAZtNUx/eQ1dO5Abo3zlxJh5PqC1wyQvSld95x/8Z8D+k6D1OeArkHJBDLgg8Z4WkJV5cX2GK4xpZUlL1UeO+7YnJFih5ydUkac8WDLiwZUUaso+LsK5M6FGG5l85W0WG5Dvfl1kr665K8R4f8BNp0ZFi/RuD14WlpGQagZQ5QpDqx3QqWc5I5qUId+GA12m9po9ChCoVwBCoh31+IGPc6w6Xp1o2yN8m0i+3cWmdXdpFVsc7EO0VrWnJOxTuDyUQgIHYK6geyIETAJ4R9Wwq7sVlsiw1WLQ/UgkBcUGVvmFybI
 QrrElrgp
 ZTx9GhYdJrnOONQgZcsXZmLrTDlrofUWinm7Kc4y1dw4jE/h2Pe06un/xg8vZ9CxBUaNRUBUudZgVLxPtOqbu3ijFX1T6hu+P7FKA4Cs8IyBZ3w3l467bwXHph6zYWMbtb+hlfRWU02iKDuHdrUI9OZjhL3WiCotrxHM1Wr58lz+pR3+mnLDEQzA4lcBSyx2MOUlL8C7NW4NS8Y55kyGdEZK5XGRTO4fyyYamZgIkmWiTMTag9/2N2RoLXWVISGLGot9PF+AOBG5gqGCQ522P6ocj5k5r8W9El7BVla5yRSJ4e6YAlu0AhPe98g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23 2026, tarunsahu@google.com wrote:

> Pratyush Yadav <pratyush@kernel.org> writes:
>
>> On Tue, Jun 23 2026, tarunsahu@google.com wrote:
>>
>>> Ackerley Tng <ackerleytng@google.com> writes:
>>>
>>>> Tarun Sahu <tarunsahu@google.com> writes:
>>>>
>>>>>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>>>>>  			       loff_t len)
>>>>>  {
>>>>> +	struct inode *inode = file_inode(file);
>>>>>  	int ret;
>>>>> +	int idx;
>>>>>
>>>>> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
>>>>> -		return -EOPNOTSUPP;
>>>>> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
>>>>> +	if (kvm_gmem_is_frozen(inode)) {
>>>>> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>>>>> +		return -EPERM;
>>>>> +	}
>>>>
>>>> fallocate may eventually go to kvm_gmem_get_folio(), so that would check
>>>> kvm_gmem_is_frozen() twice. Is this meant to catch the punch hole case?
>>
>> Yeah, I reckon you can get away with doing this check only in
>> kvm_gmem_get_folio(). Normally you'd like to fail early, but as of now I
>> don't see much of a problem. If you drop the check here and fail in
>> kvm_gmem_get_folio() you'd end up taking and releasing the mapping
>> invalidate_lock, but this isn't a fast path anyway so I don't think it
>> should matter much.
>
> No, Don't agree.
> kvm_gmem_get_folios already have the is_frozen check. which blocks the
> kvm_gmem_allocate. But not kvm_gmem_punch_hole. Your argument is correct
> for kvm_gmem_allocate only. So is_frozen check in fallocate is to
> block the punch hole as well. What ackerley said is correct.

Oh, right. Then we do need the check in both places.

[...]

-- 
Regards,
Pratyush Yadav

