Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7616D58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7C96B0088; Mon, 23 Mar 2026 16:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378716B0089; Mon, 23 Mar 2026 16:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267916B008A; Mon, 23 Mar 2026 16:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 109AA6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:54:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB3051EA1C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:54:26 +0000 (UTC)
X-FDA: 84578530932.01.69482B1
Received: from toronto-edge.smtp.mymangomail.com (toronto-edge.smtp.mymangomail.com [209.38.81.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id D546D140002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:54:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=hEtjmfsc;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space;
	spf=pass (imf09.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774299264; a=rsa-sha256;
	cv=none;
	b=SkoAzh4vDMUqZPy+Cl9f7VGY+edfksc+L6hbx3/jL7t/zr9e4dBXdsVF6BZ6t0k/Dna6yB
	SMab0KRPn7I2JTSIbSZbZbApXPH5FPtFvM+UpqWBQxzfI7GD3p8Ig52xGm1zBJCmXizMro
	DpenzKqT2PBD47U6Y4RkRLjjuQzGlDU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=hEtjmfsc;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space;
	spf=pass (imf09.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774299264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c60hJIyNyv9yh8aBhgVysIO8a8ET5sR/fQVUyc4EJU8=;
	b=aOTU8gIS1kUex+0AvZP3FVgfZfGYvIpv6kPlD4QhmrDzokydAf27plsHidQBgbb0jMH1vW
	bjkxizkjWYLq6ugc134ZSqRNiXqG9JNPpkWVBSvT86vWUlYyhcqOgJjfLc2eErZch9tIk6
	DsVNy+KbOdlSDW6txsEnG4LboKvwkoo=
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTP id D31315D9BD;
	Mon, 23 Mar 2026 16:53:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774299230;
	bh=zXUX//KKN2ShokHoNvZQWtxG3NpHa+Qkb5EmvEAmUdc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hEtjmfsc36898xBxppbvJmaSSXZ9V8cKYQVNd8eWcHb+j1Y+sHmDKKzTM+1c2nC7i
	 AGVknnRIrDPU9zRpN03H7+dA045k/V9jyF/NdBa38udN9MNeIwDgVBTRqeBH6JXRHE
	 lyb6t5ECkf8f1TL3VkXGpjeOufXV5N6288xL+9LA=
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
Received: from authenticated-user (smtp.mymangomail.com [205.185.121.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
 SHA256)
	(No client certificate requested)
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTPSA id E37B15D9B9;
	Mon, 23 Mar 2026 16:52:31 -0400 (EDT)
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 21:52:31 +0100
From: oskar@gerlicz.space
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, Baoquan He <bhe@redhat.com>, Pratyush
 Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 1/5] liveupdate: block outgoing session updates during
 reboot
In-Reply-To: 
 <CA+CK2bC8o2p_poLb0yfp6mAAwR42Vg_99Yh_HLK1iJZrCrsVig@mail.gmail.com>
References: <20260321143642.166313-1-oskar@gerlicz.space>
 <CA+CK2bAfPSKfV=_Sw20oqF56+H3a4k3x+47i6-EUK8mLV-i2+A@mail.gmail.com>
 <CA+CK2bC8o2p_poLb0yfp6mAAwR42Vg_99Yh_HLK1iJZrCrsVig@mail.gmail.com>
Message-ID: <f76e6cbcf6752342ee940ed0dfeca7bd@gerlicz.space>
X-Sender: oskar@gerlicz.space
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gto44rsnhamzww8sswdkmrowd6uso4yp
X-Rspamd-Queue-Id: D546D140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774299263-697096
X-HE-Meta: U2FsdGVkX19OQK496rxexhlxZ0ej2hmdhqTTgufAkba7oefU2244CyOYSqObD6H2NJPNMlHCaEQnMLDmgiw7GTxpv0tCEfM1K0iRlf3aeZ0ZTZmpNTaDfff3NtJhNCbx11lCJ4Kr5NwP2/etk3h/5keXinQk5tIvoLZnAHiI14jZDh1kAziRe1GoLi2P/CMR2PMaATCY+Xx2UPD/5IXXmXkC/7jQe98XfbLq8aMKEpwlP4LrkSfuR3+DvfcTQ5zzwEC8xkwpKE6m33wdZ3gyWWbiVIBvsj1DqTpwDmqv0s6uEaLeIEWRfN3x929Z4jsFBShGq6WHJk7G6P9+9lqdYg163yO747lthDaSF2P+928P2UwA5jSNd1TsA9ugqZRDU8EHe6k8QAMSTQhLtttcLXvNnn3sCneHiyyeCMzJbvxzUhez7o71tf7aMqNNTluVMZVkEJV81S9wTfXQ686qCnfEgV1qeHUVgpYvFB/X5P3hYGE+GE/qGF/HgrkSOOfICQoj5JZYri1R6YvvQ8/B3VbSyz6HVloq7lDRhSbTPcYKnhtuvsN4HP1/ZrtgYMDX52guDfEJkj6CJuPrQg3bzctjlOiVV4Jet7gfbl8b0u1YgZ8tWvUoPsO20aHFIHhiKpZ+/IRvgLhM5Vk38LXX687b4vj5+hNvIyEAx5M0TT/ocEMJ4OLlB2xgSxfhxK1ijY3JHFh41LY8Kw1ne99gp7fNASFWkFatjn3AGhqWzloGCKcGVGDEMo/VLFTzsVCYuIEF+PRe24/saPeNRLUmRQ+azoq3NBNuW50GI/rKYz5LXt3ggJ+zE1TfGoFhCTUJtL1UhC/ph32DUvK5dm3c8qIihDhSehTgr+oP8+EfVgALMirLkYAJofRzk5RCsjki6nFOt1OmgzpEPrZvqWrsNX9xyhG2ZhMF499F2z+6gblhj2bp2yUfXGDwJ2As4VDjMNyPQ1OB7fhwbbBr/Fr
 gyplSeKb
 9VBmZPyh/2k3BhpOhTD35oWcZmw3V7YzAHsXXjcz+Eav4xtRp3RoTvi5q6113UEk9bOxD+kOJ6CQMO4OhJc/lMTSgoVPzlxqrCmXeeXtfrAmbCRhjy9Czli5/0y85oKnU6MdQh82Q92BlZYrOJIfW7U42NxWlHzKpR4lePB/ucUj4+m9YYAYWO1ngHrtAxxcWl8EPF078BwJTiYLTTmP3Lj/rKKZavHWyjXIwAvf9zRbZXDd9J1d2FZOAeQrPFaWLI29KVJKtJcWg2cQN0JtRk3Kzi8qRLhmE6jrs3xUpmVhM2UdynFdg6FbZojD05w9VLoqmBDiaH2wkhhXevcnoOEZg5IxDrYArzKsGmxiIFGwwdtjC8uvY5oJJ7XU/iWtCMOf79P+aeDliFxDeZy8FpqfORSN6Ofxx3NDztF3VOQfomOuvcZzXjRErA+CzBpMsMK0RA2X5M9jO7xsTbzEsglnm70U2Lw1kUfC918+QvI7BUwGjLWYi9uGddCHl6IXLcpsXEKB+cCghc6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-23 20:00, Pasha Tatashin wrote:
> On Sat, Mar 21, 2026 at 6:28 PM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>> 
>> On Sat, Mar 21, 2026 at 10:38 AM Oskar Gerlicz Kowalczuk
>> <oskar@gerlicz.space> wrote:
>> >
>> > kernel_kexec() serializes outgoing sessions before the reboot path
>> > freezes tasks, so close() and session ioctls can still mutate a
>> > session while handover state is being prepared. The original v2 code
>> > also let incoming lookups keep a bare session pointer after dropping
>> > the list lock.
>> >
>> > That leaves two correctness problems in the reboot path: outgoing state
>> > can change after serialization starts, and incoming sessions can be
>> > freed while another thread still holds a pointer to them.
>> >
>> > Add refcounted session lifetime management, track in-flight outgoing
>> > close() paths with an atomic closing counter, and make serialization
>> > wait for closing to drain before setting rebooting. Reject phase-invalid
>> > ioctls, keep incoming release on a common cleanup path, and make the
>> > release wait freezable without spinning.
>> >
>> > Fixes: fc5acd5c89fe ("liveupdate: block outgoing session updates during reboot")
>> > Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
>> > ---
>> >  kernel/liveupdate/luo_internal.h |  12 +-
>> >  kernel/liveupdate/luo_session.c  | 236 +++++++++++++++++++++++++++----
>> >  2 files changed, 221 insertions(+), 27 deletions(-)
>> 
>> Hi Oskar,
>> 
>> Thank you for sending this series and finding these bugs in LUO. I
>> agree with Andrew that a cover letter would help to understand the
>> summary of the overall effort.
>> 
>> I have not reviewed the other patches yet, but for this patch, my
>> understanding is that it solves two specific races during reboot()
>> syscalls: session closure after serialization, and the addition of new
>> sessions or preserving new files after serialization.
>> 
>> Given that KHO is now stateless, and liveupdate_reboot() is
>> specifically placed at the last point where we can still return an
>> error to userspace, we should simply return an error if a userspace is
>> doing something unexpected.
>> 
>> Instead of creating a new state machine, let's just reuse the file
>> references and simply take them for each session at the beginning of
>> serialization. This ensures that no session closes will happen later.
>> For file preservation and session addition, we can block them by
>> simply adding a new boolean.
>> 
>> Please take a look at the two patches below and see if this approach
>> would work. It is a much smaller change compared to the proposed state
>> machine in this patch.
>> 
>> https://git.kernel.org/pub/scm/linux/kernel/git/tatashin/linux.git/log/?h=luo-reboot-sync/rfc/1
> 
> Oskar, I made a few more changes to avoid returning an error if
> get_file_active() fails. This prevents a race condition where the user
> might call close(session_fd) right before calling reboot(). I
> force-updated the above branch. Please let me know if you want to take
> these changes and use them to in the next version.
> 
> Pasha

Hi Pasha,

thank you for taking the time to prototype this approach and for the 
detailed explanation, I really appreciate it.

I agree that reusing file references and introducing a simple blocking 
mechanism makes the solution much smaller and easier to reason about 
compared to a dedicated state machine. Your patches definitely move 
things in a nice direction in terms of simplicity.

While going through it, I was wondering if there might still be a couple 
of corner cases worth discussing. In particular, do you think a boolean 
gate is sufficient to cover in-flight operations that may have already 
passed the check before serialization starts? It seems like those paths 
could still potentially mutate session state during serialization.

I was also thinking about the lifetime of incoming sessions (especially 
lookups holding pointers). Do you think file reference handling alone is 
enough there, or would we still need some explicit lifetime protection?

I’m currently working on v4 and will take a closer look at your branch 
to see if we can combine both approaches in a way that keeps the 
solution simple while still covering these cases.

Thanks,
Oskar Gerlicz Kowalczuk

