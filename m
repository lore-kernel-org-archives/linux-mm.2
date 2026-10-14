Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D4EDCC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 00:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66FD86B0088; Tue, 13 Oct 2026 20:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6086B6B0092; Tue, 13 Oct 2026 20:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520306B0095; Tue, 13 Oct 2026 20:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286486B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:11:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D38414038C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:11:49 +0000 (UTC)
X-FDA: 85319303538.29.F6861B2
Received: from sender6-op-o11.zoho.com (sender6-op-o11.zoho.com [165.173.180.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90F1FC0002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:11:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=AFjnC2fx;
	spf=pass (imf10.hostedemail.com: domain of deborah.brouwer@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791936707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31RYT1NeKYC/yx5MWS0uypGHxzMJAgXasfC8mMXP0jU=;
	b=0O2857KKauz5MZK5u/f2SicEBxuRLEGc6BekNToIfvbKKi5BK9apU9MiUM5ZBh1td0ReII
	abOPirJVeLHVeylBwFapkRO7c1g/mKNoUxbXbkAAR66QJ8zsutQk+f4Mued1TTXhE7H0CU
	IQvqxkhu8lGDA9z7fD260eZZbsDDPQg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791936707;
	b=YHo2525M5SD4VoNkDxRT1xWW1JLjeCabZM5MrApavyATLKFZxtbsLEU+0xgtwadYHL9uBz
	EKK2Iwf38tMQmNnB9ZqV/K5lfnjjPWC3qDEg/xxX46THbj6BbpiqFu2s0tG1kMgynv6MbD
	Up4Nov3P4WzB314qxFQdza0tcOb0pmA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=AFjnC2fx;
	spf=pass (imf10.hostedemail.com: domain of deborah.brouwer@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1791936687; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=A5vSWpTRbU3aybI2eZ4bWu31FH9JMEUvPl1dx5fSyhofvK3W8OpljKkSYaK78zCWDgFL3r2OM6ft+wKXk3R67v8IJ3JVQWlI3Wz+9z6nlPCEIk2GYghIM+QUW1WOtdAq5L/619w5bEGHMOe5BSjWYqHm0isecrG1rzra007nc/s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791936687; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=31RYT1NeKYC/yx5MWS0uypGHxzMJAgXasfC8mMXP0jU=; 
	b=l8OGgWMFz0yalA9cBHXEzxupyUm0purbkguZeQxHCIsDEOtgbzkvfX71GC1TT9ybz/q56ibzhyUSsWbxYkXY1lNLY6ucP++ULrA8NhG2Pa3n7sgeggv2eDDrypQ6e432gBEQKFFocb0hvOewW8lPGI0pN9jnh2ijmKxQSe2H88Y=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791936686;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=31RYT1NeKYC/yx5MWS0uypGHxzMJAgXasfC8mMXP0jU=;
	b=AFjnC2fxNenyy/0OM0XTvcgpC5e4cGZr/A/vDN4Vy2BPywkWgmEkU3EsvwGVlDVx
	Ep0ttlN1eh8/22xHZ7sH2oFMYWlA4cvJ6Bsef5O+W1ueGNxTSJXrNdubaN2HPRMLhb1
	x/HF+IPuSAYQQNvbbRe5ZxbqmEMXSmK8gLuJrW2w=
Received: by smtp.zohomail.com with SMTPS id 179193668404267.12973937554386;
	Tue, 13 Oct 2026 17:11:24 -0700 (PDT)
Date: Tue, 13 Oct 2026 17:11:22 -0700
From: Deborah Brouwer <deborah.brouwer@collabora.com>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Ke Sun <sunke@kylinos.cn>, Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, driver-core@lists.linux.dev,
	Alvin Sun <alvin.sun@linux.dev>
Subject: Re: [PATCH v3 04/11] drm/tyr: add per-file VM pool
Message-ID: <as7IqjINtIURG4yi@um790>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
 <20260929-tyr-ioctls-v3-4-26955fb111d5@kylinos.cn>
 <aspyoBHaSaJpMxJv@um790>
 <B20D93F5-4950-4E9C-8E3B-E2DC476DA539@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B20D93F5-4950-4E9C-8E3B-E2DC476DA539@collabora.com>
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-0.2.13.1.5.4/291.928.13
X-Rspamd-Queue-Id: 90F1FC0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 94wefte8qucqfb83wd3s9gsppyo7iqik
X-HE-Tag: 1791936707-621979
X-HE-Meta: U2FsdGVkX1+iYS/ZSnxVAofmBXHZt9G6ha8pna9YNk4W0S8mpPcCZfFnHsYMbPXZEl+giow+EtN2von+JgQXDQ+HUAzcInd08fZhJ8C1Jw1VfIS3q0x5aXMHfhKIQznW5gnaPrLNaVzLbmamDUnVWRfzvqg87bIx7WVR0PZA4yj7qMrfghVADFn0unBt3Z63fdxG8eBufPJkMvxQCgAEmiMhPk1fwvX3p/3y9PJw5At493CP6aQSL3w6R+TZ2HVzQEh1Y1eDZjA+RDlitOO3pXqtpZGFzg8ukoYQMtIL7wgi7OxHox/pGcosG9T93SUR2z/ffuQXjZWkcC7CNDRXr1N6/cjr4qndm2dbjvqTCgR6sF1l/YSgGeuoMIelBVTy9wOOvJsb1Yi3LscLAIjC+R3XXwEDEP4m7rO+iKU687ADhURFoCCoeS/AsT8FF3H6CG6+cVVsUhLGXiyWySxxjMCFdbsnPB1JzdMIVoVVGiut5tkaC359H53RzEyXC4JlYy45AfJMiMn4G6a6aJ4GdNLw4VyJWnnATW+fPvd2sCSgjQ0hM3dRNlZCNCt3FeTOteZMwaM7deBNstvu0CT22ybYJ1fNptF6/EnD5/ZgcEJ4TOd6EfwPbuhhi6FfS9dGZDNs2SCYzbxdW9CPHp7i0ID6i70lASfMshy+NBtKsQVLphwkTAXYv46eE2rKkgWHFp/chmH6lU/9LusqMYEdsGnQoWL/z5GUuVQvaTZVCXzEe3E9yqO3CW2ypJyapWtadh2NFcHvnyEo/cnfapSImkAZFtLDs8uwLPYm2HB4b2DcqrPrPP8xvW2mhrkK91fpes+8oJ2NZ6MD5NRBw3cabG7KchD0vZv6gjxJkfP5gCynRTFTPJ0iKXe0usl3SI/CMvTeVDh1U2YflJqyy4Sft7XsHFX1X2IME6Jus494xhxDsJiTfny1zk9ps8fMmYu/dPesyjbDZe2vHS9PFF4
 LF8aKVRM
 FeqNqgig3yZitSS4WO1TJBC2AWC+8xw3AsaY93mUDGrRtw+2uda5W7vyuRccnz/uL3EPtQECsXLMiMKltt+s0swHoI/Xc4zs6dy8cPY1gWG2BEB/4ntsIdBAjls9O6SeRATZoZll13g/qtL+jwfkrw1/+ZEvj3loz6Vfd1/ToqbPsCfDt8nUxDsjtVhZUcWeAALtTpV6BTEyxILeyRss1WRHQKksn5IaLkgB+Vxbr734D5NBOWWX07ckMAP2ivKNajxooYkrOR9AMMG9EhaVR+mQP81Vv5ebai6Pw/0hSxAAO5dCR7MOJiTJQAgFNHt9N5dduTsrqZ25liWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 04:33:32PM -0300, Daniel Almeida wrote:
> Hi Deb,
> 
> I find it unidiomatic to have containers destroy an item if addition fails. A
> more common pattern is to return the item in an error. Something like:
> 
> pub(crate) struct AddError<'drm> {
>     pub(crate) error: Error,
>     pub(crate) vm: Arc<Vm<'drm>>,
> }
> 
> This would not convert automatically to Error, so callers could not simply "?"
> it, they have to handle it:
> 
> pool.add(vm).map_err(|e| {
>     e.vm.kill();
>     e.error
> })?;

Interesting, I see what you mean because it would give the caller control
over the vm and managing its tear down. And it would be nice to separate
the creation of the vm from inserting it into the pool. I implemented this
myself and that's fine if you want to go with adding a custom VmAddError
or something like that.

But, would you also consider going the other way and actually creating
the vm inside VmPool::add()?

One advantage of this approach is that we don't have to create the vm at
all if there are no ids available so we can just return ENOSPC.

And, since we have to kill a prev_vm if store unexpectedly returns a vm,
then this would centralize vm creation, registration, and failure cleanup
all in a single place. It would also be consistent with planned revisions
to VmPool::remove() which is going to take responsibility for tearing
down the vm.

> 
> Don't worry, I plan to remove the need to manually call kill() soon, so this
> subject will become outdated in the near future.
> 
> Paths where the Vm is already in the pool can call kill() though, this includes
> remove().
> 
> -- Daniel

