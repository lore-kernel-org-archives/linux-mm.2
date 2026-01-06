Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04BCC98331
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A2E6B008A; Tue,  6 Jan 2026 09:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037F46B0093; Tue,  6 Jan 2026 09:34:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BD36B0095; Tue,  6 Jan 2026 09:34:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D8BBE6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:34:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EEE11A6E9
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:34:03 +0000 (UTC)
X-FDA: 84301783566.01.10D9912
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5C8B718000E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:34:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qqpBBoRA;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767710041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wx+ewIqNCvXiEK72ZIzZeNoHzYUIlPPL9R9aVyJh3G4=;
	b=3xAvmJmhpLSsJvYgw9cGLqR/BDc5aljh8WbrEuTJ4n9uBdHyKhVtXVEHJNq+2qe6owzFAL
	I/Gc+zBIzenbzoH2ycV1IudU7il4M4PKBKUGM2kJf7ZtdFt+XuShO+Ues8kjBYgFWLdIjL
	oo1L/ykvTvDoCCX94LqimS4UdRVeJ8Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767710041; a=rsa-sha256;
	cv=none;
	b=zI/1j2YBYp8k6r+pA8IqGy/OnQHVUX05T+JafXWbHxHfwbCz3JTST1P12jKaU+soLw0inK
	YtVQy3Vn4pWU8hVkAHXz1AIi6gXLL5vgRgJAoiXrACRVbMDEcvmJmwvRD8hrg5M2qflBbl
	5eP5NmVRLQShF0KHmFoJMxvZ7RY7A9I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qqpBBoRA;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FEE240A05;
	Tue,  6 Jan 2026 14:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684BDC16AAE;
	Tue,  6 Jan 2026 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767710040;
	bh=OD1TgDZeB7mYEnHxc/Q1fkeQ0gYBFCDnhMkeUpbXDxU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qqpBBoRAPpFtdbygI5te+6DMFR2ULPHp+mdHIgT7EXp5Ap0QmtmsaVE+8wVktWG7+
	 E3EpkARf0310WL7WpvBXnUKYlGaOD50KEK3ESWBcHpHb5blEZu+M32HYLhlg8DcoWL
	 /OJiRimM3kzA87J3x5V6QH1Yx0nWn2el52RYxAOxFegRifD41A/thNtnLEQl+T6xwv
	 uqr4uW0cugJ3igO3b/PuLaScCEl3co3p9oZp/bvOb+vMG03MkXPvwHWdmw8PJeY+t1
	 SHgcb40tthApNsYn4G+c4qT4Wco7grALBDJWgNgb8CbwNIDG99mIBBAYgkLL+Y+MaT
	 ibJnSp0MVoqPQ==
Message-ID: <238ef4ab-7ea3-442a-a344-a683dd64f818@kernel.org>
Date: Tue, 6 Jan 2026 15:33:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.cz>, Joanne Koong <joannelkoong@gmail.com>,
 akpm@linux-foundation.org, linux-mm@kvack.org,
 athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, carnil@debian.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com>
 <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <616c2e51-ff69-4ef9-9637-41f3ff8691dd@kernel.org>
 <CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jz95rk1cky6eb95oertgqfrxpkfgu4d7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C8B718000E
X-Rspam-User: 
X-HE-Tag: 1767710041-563344
X-HE-Meta: U2FsdGVkX19K/Z+00VLQyZSigvWMlM5r0JtWt6v1xf/JgxawhNylp4GVeeeFF0UgsoQAPVLCpDFvknCgNQDqXE7t/Abh8/rKJ2HpPJNIIPjEetFqSU/A1N1TRtfWGQeXbcM24HS+nIttp5ecnSEqOErnTY6T9as4eOMekvbfJMWseVMjIZn5fzvA9RpMTicGVod77ay1c6X1UyHkpzjdlmK9Aj7f2BIbujxEaZqycQPbcJEXsegMXbRwN3R8OJAAE5a5NgKYqeVQQjN9SifcdHwytuBI5/b7BmPOBW4Jq6Nrq4JiTmxXzP9poerFNT66R1jBTEkqRbdY0k+/5bNBRfH4F5jyR1pAr6V5ebkrrEySXkjQ5nA7h6dhTVThLUPCRgybt2+TkqMxY4bvgfjbCicd3soc+QmN1mNRfwiTy97tS9VmOnyEo6T1LnzLS+ethfvlPFyKxekhb+e7ycQiif4jKuTKf8hPsvRiuuvxMvyEI4qHkroLFLtjc1jy8Qkt37ORz9tQmUxjBO8IsN6E2ujuledXXXalGI5h37C6m6G2YwX/pEicgqeNszYEN1Q2KFfVOFojqrmR8Zhg9PZNKDWFSNVacIbyQeXzo2sLDhF8aiVRPVLrIp3HWPPMJGC6A2UvegTdMhJxU1e4UEOt9CPDXnPI1MScjjbwDi/plLoO/u5D1lGTs62QdAPOLTej3Mi1uKHzhwiO3rGmWkUTyUuAqJug5Q/8gFa94Z/lzvDBqhZe9gMhtGPdSNMplHMeoKiv2URohZQJ6oicTNx7EZ9MRynI3sgMxCzx/Ug2xORGq6OPZnngWqIJRgxtT5/AFhdN50YBMla4p/jU/dEhGvvzDln81QRMswY9+mZBAI1bFRtRRQJuNjyQ4k6EHephsaSKPHpoBdUrPg6dCWRAZ9I+eQq3GmT9TtfCOXu/l8vyCy8yNePTC/nBkRYehSdccbDGoy/cqr36Axjb9Fk
 Tm7ypTwr
 //tlYPnNIeLLqtfESy6t1tOzHnIlATotSSwMEjY1I3fCxs8MFSNRsR+mkWsKHrbEltGgKdqysvdxWQuYJKV9SyAftTRWcw4fTzmpVpNVk3knXwDTRXiDEpFzMMsIiU5Ro5qqBJmM89PFh8gZfBSFNlVy79wbBKDKGSSNLTGQLeW59VikjwBhYTu0auBit26HgVGN0k+KyyAgEMThafPwrFrWhwHa+wFHgGKnstnQ1p4Ak1kV39JNJYfh1+9C/3AFq33yT1D5Nix8LJgmH+8uPIiwn8I3VAg8aliGDSYUWx9/W0KnLnM40WRk82B8kiyG9Y4KJ4i4GYXPb6zk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 14:13, Miklos Szeredi wrote:
> On Tue, 6 Jan 2026 at 11:05, David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
> 
>>> So I understand your patch fixes the regression with suspend blocking but I
>>> don't have a high confidence we are not just starting a whack-a-mole game
> 
> Joanne did a thorough analysis, so I still have hope.  Missing a case
> in such a complex thing is not unexpected.
> 
>> Yes, I think so, and I think it is [1] not even only limited to
>> writeback [2].
> 
> You are referring to DoS against compaction?

In previous discussions it was raised that readahead runs into similar 
problems.

I don't recall all the details, but I think that we might end up holding 
the folio lock forever while the fuse user space daemon is supposed to 
fill the page with data; anybody trying to lock the folio would 
similarly deadlock.

Maybe only compaction/migration is affected by that, hard to tell.

> 
> It is a much more benign issue, since compaction will just skip locked
> pages, AFAIU (wasn't always so:
> https://lore.kernel.org/all/1288817005.4235.11393.camel@nimitz/).
> 
> Not saying it shouldn't be fixed, but it should be a separate discussion.

Right. But as I pointed out in [4], there are other call paths where we 
might end up waiting for writeback unless I am missing something.

So it has whack-a-mole smell to it.

> 
>> To handle the bigger picture (I raised another problematic instance in
>> [4]): I don't know how to handle that without properly fixing fuse. Fuse
>> folks should really invest some time to solve this problem for good.
> 
> Fixing it generically in fuse would necessarily involve bringing back
> some sort of temp buffer.  The performance penalty could be minimized,
> but complexity is what really hurts.

I'm not sure about temp buffers. During early discussions there were 
ideas about canceling writeback and instead marking the folio dirty 
again. I assume there is a non-trivial solution space left unexplored 
for now.

> 
> Maybe doing whack-a-mole results in less mess overall :-/
> 

Maybe :) I'm fine with the patch as is as well.

>> As a big temporary kernel hack, we could add a
>> AS_ANY_WAITING_UTTERLY_BROKEN and simply refuse to wait for writeback
>> directly inside folio_wait_writeback() -- not arbitrarily skipping it in
>> callers -- and possibly other places (readahead, not sure). That would
>> restore the old behavior.
> 
> No it wouldn't, since the old code had surrogate methods for waiting
> on outstanding writes, which were called on fsync, etc.

Yeah, I raised some "except" below, I assume there are more. No that I 
would want to go down that path :)

-- 
Cheers

David

