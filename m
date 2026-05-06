Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C400CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 16:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E206B0005; Wed,  6 May 2026 12:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF186B0088; Wed,  6 May 2026 12:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4586B008C; Wed,  6 May 2026 12:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB066B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:15:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46AA24024C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:15:09 +0000 (UTC)
X-FDA: 84737494338.06.2162102
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 679AB180011
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:15:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XLSYvey9;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778084107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4+1/o+xgo43F+2pBLdcVc3ZSu95uTHefiaNtMBxq4s=;
	b=ZcsrSYjW38QOFVkI7NShejmlDo9CRYTjh3AMomWXvpk3ea5U/JxjaH5P4OJ+etLyiQ4uGa
	s0GzIII9ZbQuFu/qDgt0ONHvM11d4I8AyUOEpf9Wy1SrR/VUOHWFzQV+5yoDh3+ky7R7lC
	He5Xt+lew1sEbAynqGCAR2DLX5Ygemg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XLSYvey9;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778084107; a=rsa-sha256;
	cv=none;
	b=AXiawal+mN1gg2CqWXvuu20olG78SLJBYCDIOE8bSS4w5YV7m9BWaCUiGL/FtwzfVeO+0X
	xRmy0F6opw7CSSkDZMPD0qi4zUQAHUmb6DxeuN7wvJY/GEV0yA4EXwmEsmWDDxz5Rrmico
	JVyyQS/Yk2jLg6gF5c2zmXG4SxqOnhs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C34C66013B;
	Wed,  6 May 2026 16:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD015C2BCB0;
	Wed,  6 May 2026 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778084106;
	bh=B3REzEcQHj5vktVYOp4io+MCxNEzgbT4NgOlD9ZnWao=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XLSYvey9WPz2hBbTkwmzbkAclbXbGSfpdwIDc+Qakic8vcMii2sl4fpp8de9POwem
	 YDOu5cwi+KZiAVLsrm3mGdBMpyoD0+pjJiiUDIBRGK2Z75SgVUfKbZKQ3EbuHgGXLI
	 umXWjbt31/C/Y8k0UnXp6lWiuPUktxeicjqW/50yMWOCcOrnTpC/Nxflc50vgRWCqi
	 UcxINZSro7yvGoiAgEI3exnmpg8W94PXXNH2EipqC9haLLDaXDQFAJur/55u8sYC7O
	 PLORoNONKCwOlt/9tTopJlV/852N1qWWPEPw+iG14eRg2okK+Qswc5t0dTI/K5z37E
	 awlvD2RGakkjA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Cris Jacob Maamor
 <crisjacobmaamor@gmail.com>,  Mike Rapoport <rppt@kernel.org>,  Alexander
 Graf <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] liveupdate: validate restored LUO metadata
In-Reply-To: <aftVd5RnpnAi2jdc@google.com> (Pasha Tatashin's message of "Wed,
	6 May 2026 11:05:32 -0400")
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
	<20260501173053.73116-1-crisjacobmaamor@gmail.com> <afT_xHDuFwAUSR0X@plex>
	<2vxzse84zzag.fsf@kernel.org> <aftVd5RnpnAi2jdc@google.com>
Date: Wed, 06 May 2026 18:15:03 +0200
Message-ID: <2vxzfr44zf94.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 679AB180011
X-Rspamd-Server: rspam06
X-Stat-Signature: s4x1codt38hwqq64c94xeshmft7xypm6
X-HE-Tag: 1778084107-943370
X-HE-Meta: U2FsdGVkX1/JDT7VRY+lEgerzdfu9YozpqU86xCHQ/nnqGoHkb/+mZHw3G9+KVwmVWzN2ekOXLT0xArwFE2B1R2gy05ghJAS1bJKFmGuVFjQgu8Wna0mBkvctDK+nkfPXf+02ZbctL/h/SN4r27AKh2mxbHfEW069bYqYdZKrlZfSPK7nYUaNLrkTNRsFSpMZiXcf1aAjx6C4DihAZ98HbcNf2iMQV19jXi2lwzIZPBlUX63hHxCrwH2NgTjtAHg77T6FO+ywGdH3okPwe+MeelButXyv9XhDeRrpY6bo4/IJCWYOrgEs8ToK23k043D3QYUih/KkWMgm/1ONdyMCgYWAlL3UP++2BE5VM1p0Ci8DdqiBrAXQ9nJdPFE/sc8anKvn5qMz1/SI3mPikaRYOjvH37r9jmaT7TBNggS7Rqv5qsQqaOynF7U0GubZj6RgSnIwQ5TaY09v7SdLrQwL9imUKPmAF0kF/Mubz7MzJbnh9N65tusNPbJFi0WsNKl65q9A9bjRlXTZ0yjib73WN0TASsnN5nH1tT5VydhNbHKjk2nh2O+t4zdwaSEpTowoj2NzCRpf0x82pFxvPYMwHs4rS8kjWYvUjQT5zJutksyQALrvlAg7IVKVDr0ybpx9A7Cj6VhihEA5GGsrwGVrKnosnkym/vw8U36ymZrOsvN6YHcfVHyFlkHyRAqqCsMcfADEAGGvOsj2HRC7WSkvgZNANSBm52pLFtJKhqSNvVlDgtR8YEK/vSt1yCDJF8qyW3MBEF2KP6oRmjJ7xMU0M59ed3Qtvyt/dQoRdhlGjYcSIy3G3vGspEvtluUP/vyMV40LX6VYeV8yVMVIoUR7a3fV5M8XD0i0qFwEbuRyT9+Rxoq7aYEU/bhrkrahlYWfhOOCsEHxcBzFm50dxhMS6BZBufr2rCwx4nN0gDQD6tDM3xnuzdidq0PRSJqcGDmaafabLhgkFVpCsWvMrU
 +dyY5GFL
 VPDZJ2qlAyWJRd0c7zfo2ANueQTIg3RGCEIWObHOYMcUrewIY75BTPHDPw8U7HpGOQSJtO3XUx9SpZmzstQXsYLRW38w2eVY7ZqO9A/T5FNIryOEQ9/qymNWLGa7X/AzW+FNE/mYDP0ucgNfkV3VEUlJVhms/vWECcaid3/PrhniIfBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06 2026, Pasha Tatashin wrote:

> On 05-06 11:02, Pratyush Yadav wrote:
>> Hi Pasha,
>> 
>> On Fri, May 01 2026, Pasha Tatashin wrote:
>> 
>> > On 05-02 01:30, Cris Jacob Maamor wrote:
>> >> LUO restores metadata from KHO/FDT during liveupdate. The restored
>> >> metadata contains physical addresses and count fields used to access and
>> >> walk preserved session, file set, and FLB arrays.
>> >> 
>> >> This series adds a non-consuming KHO preserved-range check and uses it
>> >> before phys_to_virt() on restored metadata addresses. It also rejects
>> >> restored counts above LUO_SESSION_MAX, LUO_FILE_MAX, and LUO_FLB_MAX
>> >> before traversal.
>> >> 
>> >> As far as I can tell, this is root/admin-only; I do not have evidence
>> >> that a normal unprivileged user can trigger it directly.
>> >> 
>> >> Changes since v1:
>> >> - Dropped RFC marking.
>> >> - Added changelog text to each patch.
>> >> - No code changes.
>> >> 
>> >> Cris Jacob Maamor (5):
>> >>   kexec: handover: add helper to check preserved page ranges
>> >>   liveupdate: validate LUO FDT physical address before mapping
>> >>   liveupdate: validate restored LUO session metadata
>> >>   liveupdate: validate restored LUO file set metadata
>> >>   liveupdate: validate restored LUO FLB metadata
>> >
>> > I have replied separately in the security report to clarify that this is 
>> > not a bug. The behavior follows the ABI specification exactly: we use 
>> > the PA addresses and ranges provided by the KHO FDT tree.
>> >
>> > NAK
>> 
>> I really do think we should do a restore-only variant for the
>> kho_alloc_preserve() family of allocators and use it everywhere. It
>
> That is unrelated to the provided patch series. The author of this 
> series reported this as a security issue to the Linux security ML, and 
> submitted this series at their request.

Oh yes, sure. I am not arguing for taking this series. I just figured
this would be a good point to have this discussion.

>
> This is not a security issue, and in fact, it is not an issue at all. A 
> restore-only variant can be added, but I do not see a reason for LUO to 
> use it.
>
>> would prevent problems in the future. Not because the previous kernel is
>> malicious, but because we might have bugs and the KHO page magic sanity
>> check acts as a defense in depth.
>> 
>> For example, I am currently looking at a LUO bug where LUO does not
>> track if a session is outgoing or incoming. So you can do a retrieve()
>> or finish() on an outgoing session. A lot of nastiness is saved because
>> of the page magic check. Things like kho_restore_vmalloc() or
>> kho_restore_folio() fail early and loudly.
>
> I am not sure what bug you are looking at (please share the details!), 

I was looking at LUO code and realized that we do not separate outgoing
and incoming sessions when dealing with preserve/retrieve/finish ioctls.
So you can create a session, preserve a FD, and then immediately call
finish or retrieve without doing a kexec. Of course, LUO file handlers
aren't able to cope with it.

So for example, you can preserve a memfd and then immediately call
finish. This will call memfd_luo_finish(), where it will try to
kho_restore_vmalloc(). That fails with a bit WARN splat. And then later
it calls kho_restore_free() which also fails in a similar fashion.

You can do the same thing with retrieve(), but that also fails early and
loudly and does not cause any problems.

I am working on a fix for it. Should have something out shortly.

> but the fix absolutely should be to use outgoing/incoming sessions 
> properly, and if we mixed them up somewhere, THAT should be fixed. Using 
> KHO restore is not going to help much; however, I agree it can add 
> some extra scrutiny (i.e., similar to an ASSERT), but it is not really 
> something that would help improve correctness in any meaningful way. The 
> correctness should lie in the LUO logic using incoming as incoming, and 
> outgoing as outgoing.

I am not arguing that we shouldn't fix the logic bugs. Of course we
should.

My point is that this sanity check acts as another layer of defence.
Bugs happen, but the earlier we catch them the better and this sanity
check helps us do exactly that.

For example, if we did not have these sanity checks, the loud errors I
described above would be replaced by silent use-after-free, double-free,
struct page corruption, or other problems.

So I would like to understand why you _don't_ want to have this line of
defence. What's the problem? If you are worried about performance, we
can go and measure it. If the overhead is too high this can be behind a
debug config.

>
>> 
>> If we want to squeeze out more performance later down the line we can
>> move it behind a debug config, but having this usage pattern of always
>> restoring before using is going to be a lot more sane than just using
>> physical addresses willy nilly.
>> 
>> The approach this series takes with kho_is_preserved() is the wrong
>> design. But a kho_restore() or something similar (maybe we can find a
>> better name?) is really where we should be going.
>> 
>> -- 
>> Regards,
>> Pratyush Yadav

-- 
Regards,
Pratyush Yadav

