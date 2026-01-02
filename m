Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6594FA374B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 14:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6D06B0088; Fri,  2 Jan 2026 09:05:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E646B0089; Fri,  2 Jan 2026 09:05:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F176B6B008A; Fri,  2 Jan 2026 09:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE4936B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 09:05:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA9171AE34
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:05:32 +0000 (UTC)
X-FDA: 84287196504.13.744AB08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BB1AA18000E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:05:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bEXwHj4c;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767362731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHhKBLUj/xPGvd98uQUXe/daqMsBh++bApJj90w3Yok=;
	b=omMO4LDTWqOq7ZF3EDKplD3rs6a/HRwFLvrc88UWAzeHW4MZDIu6o7YGqPyjkNwlE77MkY
	pp66vcuNaFIde1uJouDTBj/7WfiKlc/+U4eta0/oqXz7BF0Zsg+trmV4vtY7EpmWupKKYp
	kfmBXMnQOaW/sUcxERRTWIVBz/ubpKg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bEXwHj4c;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767362731; a=rsa-sha256;
	cv=none;
	b=hHK6KgcN0BBYuJADbU8nvOn5QDAmNwOdn/R2VQ/c01GI07qnCmtDdWy3E5C+kDbsdFHV/E
	4EW9JK87DpdTP4VgPihLr85Q8jFk6cHjLmY+VDwXEDb6fxpXhuUWzh15c5b7y+7fxvunBj
	4izKSHQuDcZnbhhrqukLldqIDthkDD0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 999AC40624;
	Fri,  2 Jan 2026 14:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A71C116B1;
	Fri,  2 Jan 2026 14:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767362729;
	bh=dHhKBLUj/xPGvd98uQUXe/daqMsBh++bApJj90w3Yok=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bEXwHj4cDOGyrvCsRQsGDv6yK+YiVcL6Hso7BUrsbYoRlIE0/vU3oyAYugWyBB03N
	 oLvB4x/cV2WbXpQ4eQ2+75+qFzaPNHOYpSE7Al6RyZFb/pH6fcgBWhZLuoTixEY+hG
	 4vRM1b0DI0my9AcFkYxCHeB3j9IQg2/kzWUkIOUEpkbj19gqZ8W1oeqr2cbKmVdZIj
	 0avpZ7L87kiJWhEaM0grbGMtsGS6G4xhroO237+78uDg+r3zrCjBegDBITsR6qYRHy
	 Lzyti33d7vz4No+P31u2mk14wPviBN2gkACyXRwsf1yZ0eCAF1j1oIuIH7H1V45Pu5
	 v0o+rvB5BhZeg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Evangelos Petrongonas <epetron@amazon.de>,  Alexander Graf
 <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Jason Miu
 <jasonmiu@google.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
In-Reply-To: <CA+CK2bDDEZ5a+LJNDVMtKFtQ1D9rP6rJqU064eoru=a9eHpaAQ@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 30 Dec 2025 11:05:05 -0500")
References: <20251216084913.86342-1-epetron@amazon.de>
	<aUFJH9xzJXYOt_X8@kernel.org>
	<CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
	<aUF4fsWwD9BswkFh@kernel.org>
	<CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
	<aUUYprAotKYMiEs0@kernel.org>
	<CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
	<861pkpkffh.fsf@kernel.org>
	<CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
	<86jyyecyzh.fsf@kernel.org>
	<CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
	<863452cwns.fsf@kernel.org>
	<CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
	<864ip99f1a.fsf@kernel.org>
	<CA+CK2bDDEZ5a+LJNDVMtKFtQ1D9rP6rJqU064eoru=a9eHpaAQ@mail.gmail.com>
Date: Fri, 02 Jan 2026 15:05:23 +0100
Message-ID: <861pk885zw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB1AA18000E
X-Stat-Signature: 6hmcxugzqzko58ppf3tb86ain7ppkrqd
X-Rspam-User: 
X-HE-Tag: 1767362730-515947
X-HE-Meta: U2FsdGVkX1/BGwfCDiFxmsqUHf31B1nDZvngyz+MMfZlJtL84D3MYvWmE9PNLYShQXgcIZ9uQnKZofbwebi0f5k3u3vndWatxLMrAeY0t80ewtOUVyyKF7Ko3+nqpXrwCNXNTPm5UaK5Ick/i49BK/NCAR+zjo4MF3iITlLmPXsbaVetNxWFdVVbfEp4i7XjekrCRWoXMua9geqqRkLdAvWm25ufr+wrnzeo5Ne9aWjoWP6aZLNRIHUFp4kAWEN6LaLeg7WqxOdRiXeQca9Q4TZmQoiXE1hNvMnDYmkEObcICdusHBPjZNQD1XMXMDgqhbfmToTOQfm3IA4nQxf5uNThnZI2VJWQBgPteo12ZkQL0ylamaReGL+w0qNHfStbReT/1H4R1oWWUKN5v8yTeHKTfYAF2ho6fIHjHwgjfI7sCnXCxjsMuhM8IWDu8pdENvQ3+C67eqR2Op36WOxYbmL45jOc5aJHfk0V+r+6OMXpF2Uu8e0npvyXR5534lEbnid70618g6YvwD3JYfcPAvlBDS0WDp34aJCBL4V45fYJfaVKwYl650SPtjzGjH3OOH9hhzVPpu8wllUUVLhOpMgbxBY2qttlE2XjPmgZfN1owcKGoH3OuQA8+1ntjdnKkVkJKYRE0+Ze/3UYw6qRfMNbdVAvCRcO8G5uNFUat1O7uVRvkU9ghGqdK43FfB5YLET73xBhGS3mCq4rsJXp3SWbmOr1ctCIkyN9XrN+/79RbwXseQxs2JUtqJRcUPpdVllldzcZ37l8gKt+eIWVWkCz2O9PnMHGVbvwbnbewqfbkdgW9h3/tHrpkJvnolzSjXAZKR+7ewTNcgfVaD2b816ncc3rYnkmpbIIilnujlIWQjnG/aTZ/YMTAWDlNHYuUmFVIi+Xm5z5NoB4kVuvmL2a53FdWF39bSmDL1yIG0g8Js0Q5cobaqrbkfCF3phCzAbU8GfRRwpLTUem+xf
 qUZWKzPG
 bHVkKXoIjDDpP49h4wtNoEzdqL894HTeonKXwttcQRGAnpMUk48auRN4sq4JCj6bOZQTe4PjqnFkjUL8iq0BGp6ahFYobA4N0uFbJcVQqxxeZyWKE9hg00IyydFUK6HEx+67+OX4YreipSBFORVWEK+wUHDZrUY1RwmMOEE+YOvBxADp6STpynTnbP4p4/rBcS6drxvtl6hIndwDDoHrU05lUphUgRHEbxRu0nqeNBUYVmsTxvwA7gbcx1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30 2025, Pasha Tatashin wrote:

> On Mon, Dec 29, 2025 at 4:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
>>
>> On Tue, Dec 23 2025, Pasha Tatashin wrote:
[...]
>> >
>> > I kind of do not like relying on magic to decide whether to initialize
>> > the struct page. I would prefer to avoid this magic marker altogether:
>> > i.e. struct page is either initialized or not, not halfway
>> > initialized, etc.
>>
>> The magic is purely sanity checking. It is not used to decide anything
>> other than to make sure this is actually a KHO page. I don't intend to
>> change that. My point is, if we make sure the KHO pages are properly
>> initialized during MM init, then restoring can actually be a very cheap
>> operation, where you only do the sanity checking. You can even put the
>> magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, but I think
>> it is useful enough to keep in production systems too.
>
> It is part of a critical hotpath during blackout, should really be
> behind CONFIG_KEXEC_HANDOVER_DEBUG
>
>> > Magic is not reliable. During machine reset in many firmware
>> > implementations, and in every kexec reboot, memory is not zeroed. The
>> > kernel usually allocates vmemmap using exactly the same pages, so
>> > there is just too high a chance of getting magic values accidentally
>> > inherited from the previous boot.
>>
>> I don't think that can happen. All the pages are zeroed when
>> initialized, which will clear the magic. We should only be setting the
>> magic on an initialized struct page.
>
> This can happen due to bugs when we use a partially initialized
> "struct page", something that Mike have been looking to do. So, pass
> some information in a struct page before it is fully initialized.

The magic is checked at restore time though, and by then all non-KHO
pages should be properly initialized and have their magic cleared.

Also, the magic is cleared by kho_restore_folio(), so this can only ever
happen for pages that were preserved but not restored in the previous
boot. I don't think that is a common use case in the first place.

[...]

--=20
Regards,
Pratyush Yadav

