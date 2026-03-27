Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C671910BA422
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B1696B00A8; Thu, 26 Mar 2026 23:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 388986B00AA; Thu, 26 Mar 2026 23:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5A86B00AB; Thu, 26 Mar 2026 23:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8B56B00A8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:13:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFDBA5D3B5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:13:53 +0000 (UTC)
X-FDA: 84590373546.20.4D18536
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id EBC5612000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:13:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="hve84N/X";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774581232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAAeXEJRRnV/Ol9N+nMmfYnWVNnFls6CCMpespeleZQ=;
	b=Vq2SvOHEU9bRQcQAq9vPU13caI0RlTV13JquV7Zfpa4G9x02KWbqYCwD4rp7Ede6//SXgB
	Gb4kL7hrI+3Y8bPjKNPzI9GDHx0dMvdYkMfzZ6ni56/Ky211Uf2mvdI5zbOpS+qfrrh3yi
	NKE1qoK15nolprjm5Cf2ePY7F4bt4Ow=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="hve84N/X";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774581232; a=rsa-sha256;
	cv=none;
	b=JDWTeyIHPAJjjV8VBf/EvN//1b8Y/EqpKZ6CgDGzKvXOgBilYX68j6tySJ2yNucVizFwCc
	CHrVcozC/YlmUAVEK9Ged66LENMvNYdGUzI7b7uJzlcvklAr/ys7SDSYYnBppGOL4SOjMi
	65EdG0xzmlCxOeSRjxyvRKjTxygrnGk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFBF0443AF;
	Fri, 27 Mar 2026 03:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B09C116C6;
	Fri, 27 Mar 2026 03:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774581230;
	bh=/nbxgnztPKPE/Y/AAz6k5DR9LwMDKIKYxOf7gLsZnmM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hve84N/XvEGzKL7J7swNcjpi8EC4JPnVRpzI5XIFmdJ0LXiUZT7tfsR97V1HYVXZl
	 Z8pV+ytUh+9GbWpENY9HxbE/0KxCYlCBqIgSd+h6FILFn9UE4fiaHV3Gaq9aRG3L4D
	 JBb6HtrUBpkJcJXYH4j1ebNZgBdKoBH81ERSWKSE=
Date: Thu, 26 Mar 2026 20:13:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Harry Yoo (Oracle)"
 <harry@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 4/4] mm: memcontrol: fix unexpected massive positive
 number in memcg_state_val_in_pages()
Message-Id: <20260326201349.f63af08fb120b2ecb1623211@linux-foundation.org>
In-Reply-To: <0cf08b3f-6fed-41c4-8728-c925e8a55f29@linux.dev>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
	<e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com>
	<54c2b09c-84f8-4118-96a6-acc13ca2f245@lucifer.local>
	<b6462703-9744-409e-a770-b9a7ca5fa198@linux.dev>
	<9ee51ac2-c87c-44f6-b983-44ac9007cb35@lucifer.local>
	<20260326170622.8fa7ca34d1425c241525bd41@linux-foundation.org>
	<0cf08b3f-6fed-41c4-8728-c925e8a55f29@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EBC5612000A
X-Stat-Signature: pk5bpftri1g69ymm387taimgc4tf9ggn
X-Rspam-User: 
X-HE-Tag: 1774581231-119626
X-HE-Meta: U2FsdGVkX18cPcfiIxM0BwMvD2PliPLvFQNv0jKiF9L3nvnVS09NTyR74BgPvf7QYFnsW2YE0ug6e5Af5NgtabLUMhtP4hatfDCop+2aP8hF/ee4WnzTok7EyyxveM6GsC04wqM/Qr1MXDDJxoK2kN31jiofCr9WKzneB7CNVmyRnbnLehXLeg+19GS+T7C945PJxPRY8P+1xKeqiYGcZK5AW98MAnGnF8x5LlAH746Vy9IAUUfE1DXwLThZo0Qj/MHIvjIxTRUXZVgZbFQREMFOBm0O+NoEwAXVDc/1k7YfdfFJ7xx6xddMiDLu+Q8HQ3HftCY8GUc0QwZYMHn2CxmcwOKDUxgQ6R3NVbQoCV585NPzXM12sZpRsQLtOAMEsRYLo+sbxuX+7dQ2QO8RdHWYlCniHQUUhqtf4LQ9OBId2lrcZvhZcxekeOrw8BX+4mwrZVZecE0DJo9bCyKCOMS+K2J2gshV4s6qWK5NwsDOtCbb3h6+jARWA+u1rm7qqCJ2OxRRtDYjj00VV1WJTGGRydOaCrUa9YBfMhZbhxOP7CinQMjpLTUXmfrHujTTE9evtlZftFQi8nvoBbLGbN0XjSbHa2jv/RGz2B6GtoOZeXbjRruV3MdlahAefm6HMYrMop9YVVzpIrJpfCwCINaUg80IxXF1IZwi2th37uvnzNIVJHaja14raVcir6FExyCzr0PsJFeYJrnVFr9QVSvzEjySXiiLNy8T1G8zS0AHWwhqrrU3FGAImZgPI+fbvmu93aiH5/GSpWDAxZX0c0uTAac8SO6DZW+ESLImySjxwmazsJ4vqzzBMfQAV2hcZTo8QAeo8OR7PXQuOvzxRvmJBUXRIRJ29GAPPyeu/jghUXRH4Oz3Bne0eDYKA3tNaIEquZdiRg4zqOpi9vRfXXED3b08pjIhbHc6aubBZUIDIU/1lOc7/TK3n86zfBLpqk/P6f44RKCytARE4wh
 oX3Xa3kf
 8oGtle+1HpdumEy4byudcPd2IVBGuuM/7GeY+66NlVn1zM8S28EnjC9nr4fq13he1TKm+C3OjdaDBP9U0vm1etIYYXJsTWKLwo9/2lZcjqWroAtxTtBW7CUpJrRLgusHU3UqkNkIVPiqUev6JbhFJLcEkI2W5R7Yol0J6zRumLIJdKNyuVtlcvRKXXp4NZ2MCsrFKioK4bMkDInI4tjr0bF0C9IF8D3/3myyCmv3dU4rOIWDT+37kurSFXvglt3hPGDH8qK8uLYI/Aa0vPSOCYAWrsNVCfsGcypAuCcwqqugr158=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 10:42:52 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> > a) Redo this "fix unexpected ..." series on top of "Eliminate ..."
> >     and tolerate the bisection hole (easiest).
> 
>  From my personal perspective, I prefer this approach. The issues fixed
> by this patchset aren't too critical; it's just that the counter might
> overflow (and only with CONFIG_MEMCG_V1). If it can be included in
> v7.1-rcX along with "Eliminate ...", I think it's acceptable.

Cool, thanks.

I've dropped "fix unexpected type conversions and potential overflows
v2" from mm.git to give you a clean mm-unstable to work against.  I
expect to be pushing this a couple of hours from now.


