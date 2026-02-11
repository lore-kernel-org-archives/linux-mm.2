Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86921ECD6C1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982646B0005; Wed, 11 Feb 2026 11:35:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925AC6B0089; Wed, 11 Feb 2026 11:35:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80ADC6B008A; Wed, 11 Feb 2026 11:35:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70DC66B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:35:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21AE1C1D7E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:35:52 +0000 (UTC)
X-FDA: 84432727344.23.9B3207E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 673EC1C0011
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:35:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Szkyrmet;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770827750; a=rsa-sha256;
	cv=none;
	b=YlbCeeNQw/g2ctWVMIUQUvWga2oqed2vboBsgNDl8XE+Us50MtB52pIwS78YGRFARoRj74
	2ShFXi3Wru4GKOCpwG9w/Z2Z1XZepoQOA/5mKK9ey1QhUVuk5DixLiP/xzFTMNndHa7VoZ
	KrqN1pJqLdSrEZ+s48UAwzfD99m0Zac=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Szkyrmet;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770827750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Eu/fT3GPypW+s1vY90qYco1sYAFwWe8lWlOL5ZQ/uA=;
	b=h1Vs6UyQifQrxy9bThHweYjdReEvNrbmGZsplXovP6xMNlAJUY5cMcyYab0CRZ5O3ITvtd
	yT05NbSzqmUeS5haSHpTGcHxGzteDLa2xwwvob+KYR9Rj4EbR6aKyvqvd66aKOEFNZbhHe
	aIVFA/b/kcStRKrCeiGZFPzQFz4y1Zc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 978D060018;
	Wed, 11 Feb 2026 16:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0CEC4CEF7;
	Wed, 11 Feb 2026 16:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770827749;
	bh=0kUjF1LFpJENQZHt7Fo59M51dgtOhJPv1ymb5k5n9ns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SzkyrmethJfMNPOML4ad9CVXaNQugmMiRG8PaJsHrIcOkqX1YtAk3fKac+786QRf4
	 vzpBWFyheBjkmS1rup9jVW4lV8AgVCH0cPYcd4hJrDDSRWA6KPVKWI3uUUnrs/cwAE
	 fz0GjhdZMOrWKNmJdZGhX4Gp9jprqAiumUgM+Yo9c/PPAXP9up/+fFZqI6bYfbc9xL
	 rvLmKpk4vqLo967ptfMgD0y+AsXhoqb0umQ6S4h+7YmLGbMERGK0aw0Mvu8jZak5Hk
	 Hd0kRSZqtdiMJTmZC7RLxAy/CXEVwGjJGd++2F3CphCly9mLmk4Mmt6xYsQQF7ecCI
	 6NmRlnTr6l4Ww==
Message-ID: <3932d6b3-5de9-4c84-b60a-f2a8cc2457e2@kernel.org>
Date: Wed, 11 Feb 2026 17:35:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
To: Ackerley Tng <ackerleytng@google.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
 <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org>
 <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <CAEvNRgGvZbRLcb4JbXjsLUX_V59EApHYTQc49X3Jq70GxovD2w@mail.gmail.com>
 <5759bfba-f235-4b2d-bb30-919dcdfe7b2c@kernel.org>
 <CAEvNRgH1rzZopht8HoKh_Z+HsESMnpbgb8n3o5ezf9it_CrLsA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgH1rzZopht8HoKh_Z+HsESMnpbgb8n3o5ezf9it_CrLsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 673EC1C0011
X-Stat-Signature: jj4re3j633krtiaz69h597b56rfyi5nr
X-HE-Tag: 1770827750-919859
X-HE-Meta: U2FsdGVkX19saBky8LHkLNQxnGGrcGVE3xKwcAeeQOm5Q3v8IUc6bz81ptPezr+Z8AdmCY9nrel8wLbGSD3GUHfM0LOa1tSle3rLwuBBOWuTrawuudLEXTQatD4TxT8IRSDiZ0m/R55md57yQjxJ/wA9TQhH/hdRPBng1VUXLtBECAgnymJoHN2RAjJ8a2Antn3WQYnxtlpIKli7pLcofnZC7jSx/ZFTGLM5NPZwtSVJM+lM1i46tkG2B3OVDHo/a7jUEmbyi07hMxZ1/gNkZZpq3tdOcfbRlI/Y+mYkhMHwqTZxDj/x0jnCK+hfzh2uTyZr1B1NmkjhKxNUElM5k1Hkf59eVQVWL9sBI2YcLrc05Uqvg/UFckzkClTXI06HsEtCCaJgsDPfB1BTqBwWLOYfqgijzZF0cfWoTJ4hrFzP7cwqmp/u2NnaiO3LklZgGIDEM9MG40tBD0C2w8KxC9WQNJR/NPtObGpvruYXeZa2O2ptnhC4HupdCrQRqF2RmS4w4cDB7ib42QXJFkRsmA2RbJ+zYJy2k9Xe2dqTlk2aTEYZcw9Dl1NxDbwvzdmh/wFF3ce33IjJEqz2AfQ0LwcPEUJmSRX6inP1bB9DufLZJhKaLBjzDVZHTlIb8yNnqhdJc7PF9oL+Y3Bcr7VF3thWSCneIawzHlgfjpOQtOsBzwDEApqgY+kEJo7Z0NzLmR9qscY0fWkLCnjd+okrrO+ODNyWX3ZQQTaPGhiT6VbHkdvWMaLXLnTtZ17tUYFz3bJPLlmK7i7/rVmWN/Nq1AEGJsr8BBWGB4TACjrF/YvUId+M5bA+9M8JWhgUh0d42GO+/qn2dCrIB8eyDTHgkRLABJDkyYNF/4cAFcReIfXXA/K89XRUzuOU6LXhObReLPBSrcNuLC1SFXq+6WbC3pM8wQdYpiYi9ZShntVSkehGceDY6RqKzc9Y9VF9NZe+RNs9FhDczkqIUYBRg3v
 MZG5eca4
 En/PTDAEdmDjGtkana3YLFXE/3lVrO3Wmj78dMtbfwFwQtp5kk02IaCCudNFLby49XCQ1NWbd00QexhJBchtTsqgTQP+6Pm6yL9siDXkXRrsNvvlrHOIe8p3NLaXaL2CG+nFfw2AREbecj5CyDCzF0zi4KviB3WnHcbTXxNkpovMuzQhoAkMsX7nSkx1NIPGnWfOCjd4+vwEJ05F/b8/k9WnVyOJxCNoOxDC7nxfw6jOg7ttxGasabMqVlt8gl4m0GZZPg6m48IJLXwWkQTD3URgjV0Ohsq87NfApbdPsZpWeMCCLsA0MR31p/HBNRGryu7AhKTGC/KIoaGMuqkYl3rWup3hxfxbcHj5SZ3bEsC1fF+mDwF6KtubdMonrNKl/lk9Xsl8euJZ0PU9QYc0PQ9s13G6tQC6ehysSy0F6YVlpE9Ow9XtLTKAeEz9qdBEeU0za
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 17:16, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> On 2/11/26 01:58, Ackerley Tng wrote:
>>> Ackerley Tng <ackerleytng@google.com> writes:
>>>
>>>
>>> On 6.1.162, secretmem VMAs are skipped since secretmem VMAs are not
>>> anonymous [2].
>>>
>>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/huge_memory.c?h=v6.1.162#n135
>>>
>>> Same for 6.6.123 [3].
>>>
>>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/huge_memory.c?h=v6.6.123#n125
>>>
>>> It breaks in 6.12.69 [4].
>>
>>
>> Do you have a reproducer? If so, which behavior does it trigger?
>>
>> I would assume that we would suddenly have secretmem pages (THP) that
>> have a directmap. Or some page copy would crash the kernel.
>>
> 
> Is there a good way to verify from userspace that the directmap hasn't
> been restored? Should I use CONFIG_PTDUMP_DEBUGFS?

Anything that uses GUP must fail on that secretmem memory. Like doing an 
O_DIRECT read/write or using vmsplice.

-- 
Cheers,

David

