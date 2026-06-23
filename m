Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4CFCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 16:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7062A6B008C; Tue, 23 Jun 2026 12:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E38C6B0092; Tue, 23 Jun 2026 12:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D4B6B0093; Tue, 23 Jun 2026 12:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3884D6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:14:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7DD916718A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:14:29 +0000 (UTC)
X-FDA: 84911675058.24.E41630E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4BAB140011
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:14:20 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782231260;
	b=v53Ml4yFL1v2s0NDH1stGH+4p4u5w9N/o7Lvz+TyCaDJiFivMMbPkyx8s/Qawn81ZV/h5x
	NJrHSCGlS+j/8lgkd33SpS5B3NjKWMLZE4BSyE0cx82/dcv+0UePx9Lk7FOfR0MQNRWp8c
	AmwZ4LitbYnwwhb2sFLm3+SgiVOSeUQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782231260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcajKOa6/fzwx6pWaVxtdohrAAfHL26/qCXeO5E8rLc=;
	b=rWRAhJy4xf4FI9YrPAm/NmZO4MTqNvlwgWsXAAkHlVHloqstxS4iPPbEKdoWx4KXxmlbI7
	Va585XtIyMCkOwwJDq7KVZ3D9wL0Qen8sAbW+j8GnwuuEkJEgs/QtbE0ni0W1BJKwM0+vc
	lRwWw3zwufOJttejrdNLNNKxCf4yico=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VUvN9dWT;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7346E43D0D;
	Tue, 23 Jun 2026 16:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEC91F000E9;
	Tue, 23 Jun 2026 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782231259;
	bh=PcajKOa6/fzwx6pWaVxtdohrAAfHL26/qCXeO5E8rLc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VUvN9dWTAFZGuCKtcfMvwtECLwgU5Wn05mBuXFWgGS2j0291eyLug/KqLvXNurhj/
	 8XotdQA07OI7UyAE1bzQQth+XawZek8UmEXl5zi6EpiYijhaMUlUJJvhJFaRD104BV
	 WSewTcfsySn74qg/SifAN6imZ0ebWGBZX9eMMD5P3Up66ERqjHY6jHDFS9zow2Whvo
	 EH9CmPWwa04RWZUyBQ6oqDohYdic1xUJ9pxNV4PSDsEqsyvdBuzfIV+aHFobf9FdME
	 gCMk4kdb3Ug2lmPiMTQaaDPOtCOcdeMdsSuEkgncoxS9U/PjwQFvHs1W+y7sglXYOl
	 cOVui2PvK+BAg==
From: Pratyush Yadav <pratyush@kernel.org>
To: tarunsahu@google.com
Cc: Ackerley Tng <ackerleytng@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  vannapurve@google.com,  fvdl@google.com,  Pasha
 Tatashin <pasha.tatashin@soleen.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  sagis@google.com,  aneesh.kumar@kernel.org,
  skhawaja@google.com,  vipinsh@google.com,  Pratyush Yadav
 <pratyush@kernel.org>,  david@redhat.com,  dmatlack@google.com,
  mark.rutland@arm.com,  Paolo Bonzini <pbonzini@redhat.com>,  Mike
 Rapoport <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  seanjc@google.com,  axelrasmussen@google.com,
  linux-kselftest@vger.kernel.org,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  kvm@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 06/10] kvm: guest_memfd: Add support for freezing
 and unfreezing mappings
In-Reply-To: <9huztsqtmihs.fsf@tarunix.c.googlers.com> (tarunsahu@google.com's
	message of "Tue, 23 Jun 2026 14:36:15 +0000")
References: <cover.1780676742.git.tarunsahu@google.com>
	<48777f4749fa43d5648085dbb2037aa99c144a88.1780676742.git.tarunsahu@google.com>
	<CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com>
	<9huztsqtmihs.fsf@tarunix.c.googlers.com>
Date: Tue, 23 Jun 2026 18:14:14 +0200
Message-ID: <2vxz8q85mdyh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-HE-Tag: 1782231260-94450
X-HE-Meta: U2FsdGVkX18ANt8vRmsGIOFge/59JH4LQC7BeU1nmfz2WVxUzJuVH5qqrgQUkwqxj/5dr5Ih54qxIHSZDemsl5mjrDrG4JJhUyJB6Ad2Evbcs9Mt+QYpf7ThuLLiuci+kVIJ0wdznTaE9tJKGiLQQNhcxaNtRGNvyFHJn3gP5FdtpL6rU6kZ4B39Kg9CVmuSVQqv2r6ot7fIFcghO0ymx17J/Jh/60WG7oFOEafGDz240VCHfw/y93fMuBfax6/+n85aXir/mDzE/3PfHoBVFJMLOXRWNyjX93IEYF6yvYbvIeMP6LdAoaFLe55sgUvr+oRYSMjT2fGBAzU/JVCHiwcxijCkg8q7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23 2026, tarunsahu@google.com wrote:

> Ackerley Tng <ackerleytng@google.com> writes:
>
>> Tarun Sahu <tarunsahu@google.com> writes:
>>
>>>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>>>  			       loff_t len)
>>>  {
>>> +	struct inode *inode = file_inode(file);
>>>  	int ret;
>>> +	int idx;
>>>
>>> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
>>> -		return -EOPNOTSUPP;
>>> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
>>> +	if (kvm_gmem_is_frozen(inode)) {
>>> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>>> +		return -EPERM;
>>> +	}
>>
>> fallocate may eventually go to kvm_gmem_get_folio(), so that would check
>> kvm_gmem_is_frozen() twice. Is this meant to catch the punch hole case?

Yeah, I reckon you can get away with doing this check only in
kvm_gmem_get_folio(). Normally you'd like to fail early, but as of now I
don't see much of a problem. If you drop the check here and fail in
kvm_gmem_get_folio() you'd end up taking and releasing the mapping
invalidate_lock, but this isn't a fast path anyway so I don't think it
should matter much.

I think either way can work just as fine...

>>
>>>
>>> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>>> -		return -EOPNOTSUPP;
>>> +	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
>>> +		ret = -EOPNOTSUPP;
>>> +		goto out;
>>> +	}
>>>
>>> -	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
>>> -		return -EINVAL;
>>> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) {
>>> +		ret = -EOPNOTSUPP;
>>> +		goto out;
>>> +	}
>>> +
>>> +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len)) {
>>> +		ret = -EINVAL;
>>> +		goto out;
>>> +	}
>>
>> There's some reordering here. Why not let the validation happen like
>> before, then check kvm_gmem_is_frozen()?

There is no reordering, if I am reading the diff correctly. The diff is
somewhat misleading. The kvm_gmem_is_frozen() call is added at the top
of the function, and then all the later checks are in the same place but
get a goto out (and hence a full body to the if block). So the diff
reads like reordering, but there is none.

It would be very neat if scru had a cleanup.h style scope-based locking
function, but on a quick glance I can't see one.

>
> To align with design. "stop the fallocate call if inode is frozen, No
> need to go further". I dont have strict opinion on this. I am fine with
> taking it across punch hole as well to make it more fine grained. But it
> will no longer claims stop the fallocate call (allocation one is stopped
> in separate path: fault path) , though functionally it does the same
> thing.
>
> WDYT?
>
> ~Tarun

-- 
Regards,
Pratyush Yadav

