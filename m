Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1C2C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5216B0099; Mon, 24 Aug 2026 16:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E256B009B; Mon, 24 Aug 2026 16:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1669F6B009D; Mon, 24 Aug 2026 16:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E79826B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:56:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BA43C0273
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:56:07 +0000 (UTC)
X-FDA: 85137370374.17.5B90663
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED879100005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:56:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9U43Ttv;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787604966;
	b=IvS3obJu9PokkELaFuH459UFoE+YmFCULTqTiuRiCuXJcLaRluPx9v+2x9CN06qO9nyll4
	bEuJX+pelE31N3CmIy9ByYYjoDTs3qfYsABb90HESyPiJs1B7n6iRY9M0sL/HAZ3F8/NKq
	3ZotZ/zBNQp8kWW1+6yJ2bKF6dN0aa8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9U43Ttv;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787604966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ID8tRmJx0mTc50vU9b3epIJ7qr0Pi6TP7Z/LEdh/C/g=;
	b=2eIiUWbwhUAKDp99Y9pLteF+0DIKWP8HAgQnVEA7XhAsC0R1G/GF1H8WQY7VLHuq6luAW5
	QhxemfnswYUSDQqFaK71eLgfqVfcrqPLG4GWqgPEKpZiYDAd0qjOU1+u+X9K0ZuLhPgcXw
	wz4/uZLbo7s6TOUe2QDp54U8zsEBT8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFB196011F;
	Mon, 24 Aug 2026 20:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568BD1F000E9;
	Mon, 24 Aug 2026 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787604964;
	bh=ID8tRmJx0mTc50vU9b3epIJ7qr0Pi6TP7Z/LEdh/C/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h9U43TtvfiwgLEXgrMS99wtxxxr2PLjP7grrikYJffbdrc6MZhVmrVEizPCoW1Llw
	 F+Qowkn86+zGGuU4nICaTK8ev1g6tNC6MogWYMRPdWpVNBO+W0aTeUlsgYc5i5v4fN
	 3T6EXPJBsTJVTkBEH5NAcmZMiiPIUMQgX7g3nNz4xZKd0YiHLFAwStOZ9507eZ5XQC
	 0S+tHj0NPYNij1QAeOrh3MUVhR4uSfVrH9WS7tbHIIA9rgvXEh8mNePtJkI2kkogJT
	 ijfTFfWZLwc0bKeKZTyR/mKiBef9QyFfufdS04XmnDWhYpgt1VKQJyiQHBTmFxu1/Q
	 b9vUJ7KA1lNdg==
Date: Mon, 24 Aug 2026 21:55:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Artem Lytkin <iprintercanon@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Danilo Krummrich <dakr@kernel.org>, Jann Horn <jannh@google.com>, 
	Carlos Llamas <cmllamas@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Deborah Brouwer <deborah.brouwer@collabora.com>, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rust_binder: check ownership before using vma
Message-ID: <aoyvV5-ZqXoRDFaf@gremlin>
References: <20260218-binder-vma-check-v2-1-60f9d695a990@google.com>
 <20260824194808.216021-1-iprintercanon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824194808.216021-1-iprintercanon@gmail.com>
X-Rspamd-Queue-Id: ED879100005
X-Rspam-User: 
X-Stat-Signature: yomriymbpymzhjez9k6947zsio15c4zc
X-Rspamd-Server: rspam06
X-HE-Tag: 1787604965-560198
X-HE-Meta: U2FsdGVkX1+0ik7mDDHZ3CsCAyZithVUBkm3cCcfuSbSKL3BitvoZ/G2mnGCo1/OnNMvtltN3Cg/C/5RF9e2IxdBVb7gRxbA07HxilSURrTTvw4rfAYSYF0c1sIamPHG3mT937Zbo6SEvRDSBQPct0qeENj0K5um9KoC+ZNdZ1OEdC9dvmzhMXJia20HTZKZERamyOh4eNs0uicX5wJAamQGj0YLPLIlPSl6Rrw5Eh2dff9Qb8JwNfrX7dewhd7uGPM5gU6EEhgQYcF6b4hYUevQpxGC0+LZ3GT/JqFGVOANHNp+NW8AsbYgZhI9U1Tec4VwdRph9oqZX4HLudzLOUEhH1pGIr9Vfku3+9/RgfTZtvTrdYNWxjz0uRpHXK7y88j6q/RfkUxQ4GrsN5x26U8lIm8tT34x6HL7oBzD8fPyxkpvm2uOP8qVgqttR/ehj0aWbIbA30qai+wGfQ6m003dUiSuwh0LOUMs+q4Sj+nziXwQVVJIepA4FjX/O4Ebxxv+kDVHq8OjgyyxVahVSLntCM6RZfS7xYIjd5TAbEtYwJEjd1aQB9yIEwaPW8nyxByCikkPoixs/Jxy+KVI1GGORrHBtQX36sRf/q/k0K64X4uOtuXie8uuSfTVd+mVbw096SFKprZo5Q6ffMvp1Urw/L5L9xfvKYbPLpIrdJbeeaqHZiMc9M3gtjTem2OkbLt6UblR5F1ARk6cPgET13KLjFokUXy8rivstkNqPUv8Vi/Gp3AsOI/aukeTMBfuqmHbQrDOCRurfIJn3ktWxQGY4NYw+sqATnAIafDgFLOO6GW/3rviXYbE6Tcv6jVhizTuWWn/7+Mt1U4l7rFFK80ChfL3xLV0pE09VTn1AOOLEH0c54luzAtjaez8ou6XgCWUL5Co+OtKZ2qlV7I/f/EoMTNP3coEk+4cTcpDTLlzUFuXeBCjJDGKT6Hd+ySSnrU35AwKJ8QCiVHu5o5
 kfLM6L8I
 cTj1M4Zr7OGM9898EdiZAp43d7sZ23Wd5NsCX7uFDoIyejwXaQdB5sHt+an5SSdC0sO6mlUVKq8V6pI6H3Bt2UXnbhYqDFhErYChvswRy+nsQSizr1RI/+9zG4lWoD1lfZRpiaiw+LuiEPLcNJLWHjcy6ZcvKINPeTZb302k3ym04YN5c1pj4mrpYMeSFghI+UKYxTGkBqQ5C/mYa2zVPBjCUgXrDgnEmdR21wCOCLhNNGWcZvGRXp6E7cOPhXcb6w440HmDQwW11wdY+LuIr5XgeEYSMS5iPXd1LEPJ9JqGuf/yNDbihFm10b/VNq9+VBbzwP6KXTK6+/3let3NoHZqKnAMXIWmuPRNbZZCq4UNN1epvZVZacEEoABeLah8lg/o+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 10:48:08PM +0300, Artem Lytkin wrote:
> On Wed, Feb 18, 2026, Alice Ryhl wrote:
> > The plan is to introduce more vma
> > abstractions to avoid this unsafe access to vm_ops and vm_private_data,
> > but for now let's start with the simplest possible fix.
> [...]
> > (We probably still want to do both, but
> > the vm_ops->close callback will be added later as part of the follow-up
> > vma API changes.)
>
> Alice, is that follow-up still on your list, or would you rather someone
> else took it?
>
> I'd like to add the missing pieces to kernel::mm::virt: a VmOperations
> trait with open, close and fault, a typed way to install it together
> with the private data on a VmaNew, a VmFault wrapper, and a PFN-map
> typestate next to VmaMixedMap with vmf_insert_pfn_prot() on it. Binder
> would then drop BINDER_VM_OPS and the raw vm_ops pointer compare and get
> a close callback like the C driver has. Tyr needs the fault and PFN-map
> half of that for its user MMIO mmap. The first two patches of
> Collabora's Tyr series are the pgprot_noncached and pgoff helpers; they
> have had no replies since 7 May, so I'd build on those rather than
> duplicate them:
>
>   https://lore.kernel.org/all/20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com/
>
> One design question first, for you and Lorenzo. f_op->mmap is
> deprecated in favour of mmap_prepare, where a driver sets desc->vm_ops
> instead of touching the vma, and the Rust side only has the old mmap
> path today. Should the vm_ops abstraction be built around mmap_prepare
> from the start, with a Rust mmap_prepare hook for miscdevice next to
> it, or is landing it on the existing VmaNew an acceptable first step?

I'd say you should build around it to start, anything that you need to use
that uses the legacy interface can be converted :)

I (should) have more patches coming next cycle to keep the conversions
coming.

One thing that might be difficult if you in some way rely on a driver that
needs conversion is that I am building out the infra as I go -
i.e. implementing stuff like ioremap, mapping kernels pages, etc. as
mmap_prepare() does it in a different way.

But on general principle - mmap_prepare is the future and building
abstractions around it makes sense.

>
> Artem

--
Cheers, Lorenzo

