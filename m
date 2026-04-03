Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A2CE7E371
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9C16B008C; Fri,  3 Apr 2026 07:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A5F6B0092; Fri,  3 Apr 2026 07:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB70C6B0093; Fri,  3 Apr 2026 07:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4446B008C
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:24:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40C648B5E9
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:24:49 +0000 (UTC)
X-FDA: 84617012298.06.C8B5FF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BEC7D20009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:24:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MPnN5Dlu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775215487; a=rsa-sha256;
	cv=none;
	b=xAV4yEXiDJdLDz3yA4hZweyrQs9SC5bFISqm0FBn2a885SvuW3XEVK1p3xCUVCrwB1AhDg
	Ws5RI/0ic13WRlO6iezql2ROLluLwkS+0FMcutSNpvaKvBY+Zn6omasOifoNcJfrkISzOA
	li+E6crjkE4UU0hWHVbMZl6Rmrq4538=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MPnN5Dlu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775215487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKfl9TdVDizzlO2LSkdlwxuYXtAA09Pi4B9rN5R3bSs=;
	b=KoaVK/Q0Tahk5PExz4JQzliyL65oNuyxtD3nbngR1ZRqWCt+/pfuKChkhCs33oQtxzm0tO
	GsI2a0TYo1429Q2OGDCXEmCHKaTYCihA2afxgMFYD1ZTEq4Ushf0WSEQq4jO8CuPogZiwO
	RbZRFCb+4AwGt2P8EZEBx9o6CZ+H91c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CD1D60121;
	Fri,  3 Apr 2026 11:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5912C4CEF7;
	Fri,  3 Apr 2026 11:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775215486;
	bh=n2kIfPcxv9fpCDmESjetmPVIXXSHk10QB/niw+4zBdk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MPnN5DluGKOUu49y7lrQ31VECTcn+7zuVK939IQ5sR/OYJUUpHW5cHhN86TpjW4ZO
	 GWAnpWC9hE3EaJmqVEmgKjv3EI7JPlNNtKzt9viRA+HTBDfMkDoih68tiF8CTXXb/d
	 y+M3nDSw/J1tEGuM6JqsqQgdoSNuw1ddWxE6tUE6FZyqtuonPwaE0L8RIUHlnjkB0a
	 g3UBF2uo+2owZ0fVzaZAnY5b2wDOxiwaRcF+79st1pSStTkWc+3CIDSh17AFfji0+/
	 IKrp5d0S0voXE2VTuh4ICx0KqwvSLDAqAshzULkTs16KdZEm15RW4ltzMWiPQBaEBl
	 Q47Y4/9dxpbTw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usama.arif@linux.dev,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v9 3/6] kho: persist blob size in KHO FDT
In-Reply-To: <20260316-kho-v9-3-ed6dcd951988@debian.org> (Breno Leitao's
	message of "Mon, 16 Mar 2026 04:54:33 -0700")
References: <20260316-kho-v9-0-ed6dcd951988@debian.org>
	<20260316-kho-v9-3-ed6dcd951988@debian.org>
Date: Fri, 03 Apr 2026 11:24:42 +0000
Message-ID: <2vxztstscmmd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: o1nj3rentkqhxntj5rryxw5skzfdf6ju
X-Rspamd-Queue-Id: BEC7D20009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775215487-483079
X-HE-Meta: U2FsdGVkX1+5hg4d5+Re1vE8kTa5rZRlGagTnB+280N3O5jvFbUlaRy0Uz479j/pOaxZ+nM95IU9ys2q7NpZE/658k7ULWTZbD1ENuTa1i32XbcijKojxe9AJ3Yqw7e6cCU1WuteQCzacmq+xJNoGOfZZO025g1xlfJS4uETMjWudXDiv9DVRLeyzBDAb/O46b6ySiwp99z/XQ54DMQEXvZaqfgdmtCgtsZPjAUzHspt64s90PNW431v/jQ7ivusv88zBelckYJ1S6GOoUwIGcWSAA5A3XdjSBUQKuxA9jcx6u3/EpfsdXTnrJtlDa3LCJ9t07lXcLfSpBx9qf/ukCt7A4+qpOrap2NGhnhVtSEdB463oL//vT+FDkwUJLkjyRKVSlVR4dDWHY6dQ9uxwdk/D/eoJdDrvE1jh1F9wjKy72sCcX1xwatb+MPZVM4lEYHRa/v+eh38P4q4rOSaWmqcaGd7R8GFwl6DMIabViulQFQw0w1p0jIdumyNuFVn2nLiYQ3muqLfUwQfwlKiOy2pZl4xc2++5AcqbjDigsbviyXNYFyTPpXo5cG52HvfE4DpuWMhjsKzhQto29AkLFXtl7tePvC9sfzzzGH2MkMrG7GD8wmVyPJGLdClPGUgTszQzEgZSYJ5Ph0VKNhs2uq/GM+sNSFMexQTFEXdb6V7JmNdyNh+TW5GfpPRZBcpl0wlyMGNXf/llofWgkclYRo7FLGkNoeD8ufeide5mDo5uCqK8xaRRvwTTic+lT58H2mbTZcLvOBHyWVskizBbX84fCy7ncNGw4yqnVFClBUXQbJHkgyHIh+3tIAUcdgQeZjhDVIRm8P8Uasja6WepGVFfbDb9eieFYSJfYa/xD0MTnChEFHgADZU0UYj+DLFCUyMC5NQDvA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16 2026, Breno Leitao wrote:

> kho_add_subtree() accepts a size parameter but only forwards it to
> debugfs. The size is not persisted in the KHO FDT, so it is lost across
> kexec. This makes it impossible for the incoming kernel to determine the
> blob size without understanding the blob format.
>
> Store the blob size as a "blob-size" property in the KHO FDT alongside
> the "preserved-data" physical address. This allows the receiving kernel
> to recover the size for any blob regardless of format.
>
> Also extend kho_retrieve_subtree() with an optional size output
> parameter so callers can learn the blob size without needing to
> understand the blob format. Update all callers to pass NULL for the
> new parameter.
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

