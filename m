Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4949BC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66DBB6B00E5; Wed,  2 Sep 2026 07:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646426B00E6; Wed,  2 Sep 2026 07:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B366B00E7; Wed,  2 Sep 2026 07:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C88C6B00E5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:28:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C246AA393A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:28:03 +0000 (UTC)
X-FDA: 85168598046.16.3E0ED65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 39E79A000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:28:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LTnS4nix;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788348482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOkWaTR/rl0qR/SlR48VncMxFLhFzReZRLMpk5f2CtI=;
	b=4VY6kQcuEgxHasmmtqyXTyMkIjQDFEZeld1MLVs7QAYILLIEmwpOZsJvhApA7hGH5VgJNN
	IdeM3+ISSN5SvKQegwfbEdH1pOQsZuufoT75Y3iI6F25Llv00x0QDxtyJ1i5xeNoTOijWD
	jX90WiVSUSDQnmPoJiuXbtFvBI4LtNY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788348482;
	b=nBhGbP/mtvOEph96mGCqLOrM/wbgjjfBAuPhBgfEUPbgtT7uRwZjCkdHpm0oDvj1qrRS96
	Qx3e2bbMte91JZ+MrkNdk/zBZfJvc8sgfsyztj4dnSBrApyMjvInMB53mYl9vkjqbSlqX7
	1tilzR5O96iSrcLZwY7TeN/+U/FcYt4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LTnS4nix;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B43E1600D1;
	Wed,  2 Sep 2026 11:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D801D1F000E9;
	Wed,  2 Sep 2026 11:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788348481;
	bh=jOkWaTR/rl0qR/SlR48VncMxFLhFzReZRLMpk5f2CtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LTnS4nix+lkxGZFdMT9owY8sNAP2Fm00l2wZiWUZaMK0WnBxMYzlEkKLDz8j741ax
	 1jTn66jrsywkmyeDPoAedANWTuhkmMGYyMpfyAvVuQMbICNiD5gkvNPhAlBDM1WPob
	 ggnU7wh3w4MhajY559HTtkxyMOOk+JbV0RduD6OBBvSgl7bocO4W/0MCmbAn6/hweq
	 qK7mBz9qxZEZj4qv4Q97QUiRMqGCn2Dp0S02CLG/SuujwoKVfPe/Bd9+a1ws6OqD7p
	 Nn7Yv6ttUysNOgQ34XY0CZFuFalBS0IxW4d2MNMP3pVE8z0HJpPhAFJq5EtmIe4dUF
	 NnJXShK2uI2fg==
Date: Wed, 2 Sep 2026 12:27:59 +0100
From: Harry Yoo <harry@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: take n->list_lock for the list_add() in
 __refill_objects_node()
Message-ID: <apgH-QpYrRU1qzX9@nixos>
References: <apPa-cGLcyt90l-E@v4bel>
 <apQU8wjMlvbKBQgh@dev>
 <apQ7osHcRj3vdJPn@fedora>
 <ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org>
 <apgE4TWLFGoqoOos@nixos>
 <apgHa1tISzqsnc_C@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apgHa1tISzqsnc_C@v4bel>
X-Stat-Signature: mthq5mn4m73wiq9zcenh5dfp768e6k3d
X-Rspamd-Queue-Id: 39E79A000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788348482-657407
X-HE-Meta: U2FsdGVkX1+dV5kSYoGv/JPl1QRmnZFbYXyjPqpAyLMXf2lzlgxeeRNJpQpvwXMQRLD8XQCrkUrwEMYXfGhRU3+aIKGeuPteHKN/vqFH11o0DR2BM0yujIiq7oqDQuh5R37bhHytNrrOTECCwhNI1Q7PML9lpnmu4qDSJe+x/ArSiENNJV+6xhJOLB//hoWKyGpw8c/KuoVv9F9Gvi6im9nKEr8tFHtpGYAjIPm5IC41nGP/oNBi7LuKaTsAHG+rro723Pj0tdXw3lV08MUju0PRcWZX0nZ9Ohff7F7+Ukg1sp9pNJcC5caIAuHyjaTKZvLNNfN0/zgBzsdBRZ6RR8TlcqrMNj1ZgAMzhdk6IeqEQeRboaRqMj+jglpxS/zqMlTyfgL9Gh9p6ChLl4Kgp+CZVUNge/QXs1axee56leCn6Dx3urXPBXvbnuWBImx7u++IwtIKg+3X0c1Cgut+XZlJVFoQMo79Vdq6bf0EFYz08fPxNh7FsXIqLcE/DSdzUWn6GOoNNDg+aZstvdj15gXVynm6PFeHnymqZHh/FHUiJmlinGbNjdw/IybGWZmAeFuliOcOveJxB6sccmh7z9M0bZnwbTgCv/OHUuhqUaE+bD+rGYcxw9nZL0CK5c72RrUY8pXuOk7Awl+q3i8VX64ZjMhdosj1YeWL0mfuhu9LneTanDFkPYwL5QelwJR/Rup9z1CWmg7TYskVzm035eS6lH0L+9tz2QIrZvpoymBG3fMTDadsGCNRdNdnEsCtNbkf7vHn0Q8GrLiwqvD0YqUlASZ/1t1yrIT+k8bYnKaaD2eV5Ob/2cyB7LSGjBFvNjz2WGTdYmFZfLFfn6lN4uS+tV7zN4FxhxolsmLJobp4cVBDKmvL9wlQObyti4RoLeWirZE+cKuv/8wUMKkUC68HIbuI8oYoH+Fs866c8+A7yexgyqrfOGbv+W+BnGM4BaL9dkE71eDEHmm4tA9
 Qcw9qad2
 SZ53kZaH6LPSOTQB2lpM08wyq0woZ26rq2zPRxU5errEm89/MGXLL8BciU8jGvZoYq6zKiU52etQ6sTgOgGb/PX5v3zYvy9Cp2EUZu9CdZ38BVHpuKHVmDyYPyNAMuLSIBAtF1KDW+gzvAsAT+q4l8CN2cY1mp+1/1r2crgcde6foWvWXRRdgwO85fY5qdf/LcdavY5ldT6C668HlZaprwzS5R4lI9kSi1jGQ3/amENItXy9PeStA04NJ4rb1oy1g5gPcK5N5ljaajXzIsT6KdMXtSRN4AbUFc1SbjGSInPnHlznaIZjv4ED1B200g/uvMJYI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 08:24:27PM +0900, Hyunwoo Kim wrote:
> On Wed, Sep 02, 2026 at 12:20:34PM +0100, Harry Yoo wrote:
> > On Mon, Aug 31, 2026 at 02:55:06PM +0200, Vlastimil Babka (SUSE) wrote:
> > > On 8/30/26 16:35, Hao Li wrote:
> > > > On Sun, Aug 30, 2026 at 12:45:17PM +0000, Harry Yoo wrote:
> > > >> On Sun, Aug 30, 2026 at 04:25:45PM +0900, Hyunwoo Kim wrote:
> > > > Since introducing a new variable seems unavoidable, what if we temporarily
> > > > stash this slab in a pointer like below, and then add it to pc.slabs once we
> > > > acquire the lock.
> > > > 
> > > > struct slab *leftover_slab = NULL;
> > > > 
> > > > ...
> > > > ...
> > > > 	if (__slab_try_return_freelist(s, slab, head, count)) {
> > > > 		leftover_slab = slab;
> > > > 		break;
> > > > 	}
> > > > 
> > > > ...
> > > > ...
> > > > if (!list_empty(&pc.slabs)) {
> > > > 	spin_lock_irqsave(&n->list_lock, flags);
> > > > 
> > > > 	if (leftover_slab)
> > > > 		list_add(&leftover_slab->slab_list, &pc.slabs);
> > > > 	...
> > > > 	...
> > > > }
> > > > 
> > > > PS: If I recall correctly, Vlastimil's initial patch was actually fine. It was
> > > > my suggestion to save an extra lock/unlock pair that accidentally led to this
> > > > trap...
> > > 
> > > Ah, thanks for the reminder. This [1] was the original attempt.
> > > 
> > > [1]
> > > https://lore.kernel.org/all/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org/
> > > 
> > > I wonder if the fix should be to return to that approach and just have
> > > __slab_try_return_freelist() handle the list_lock. The code would be simpler
> > > with not "bool locked".
> > > 
> > > It should be really very rare that we would end up returning a partial list
> > > and also have additional slabs to return on pc.slabs? So I think there would
> > > be no noticeable performance downside to the simpler code potentially ending
> > > up taking the list_lock twice instead of once.
> > 
> > Agreed that it should be rare and not worth the complexity unless
> > we have data to support that.
> > 
> > Hyunwoo, would you please adjust the feedback and post v2?
> 
> If you don't mind, could the maintainers handle this patch on your side? 
> I'd then move to Reported-by:.

I'll post v2 with your Reported-by: then.
Thanks!
 
> Best regards,
> Hyunwoo Kim

-- 
Cheers,
Harry / Hyeonggon

