Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F8EAD711D3
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 435986B0088; Thu, 18 Dec 2025 21:15:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402CA6B0089; Thu, 18 Dec 2025 21:15:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A076B008A; Thu, 18 Dec 2025 21:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21BF06B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:15:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC8C11A0410
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:15:14 +0000 (UTC)
X-FDA: 84234603348.01.590329F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2586B14000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:15:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ohOY26Jz;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766110513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJE1Djyq4PaKQBKJcJnUzyxofgvgCdCS26m9yVTAGAA=;
	b=mFNXOiy3VYgpE2TxL5n68wNbMJUFb1GSK2nSRGNhv948IvaWtejkkfrsWjt652G1FWx5OH
	59pLbLYM4gh2GkLbnAMmi7a33WAe7bN2ZTNBalKwTfK6W9Kjf9Je1NR3Hw7l7tyACu/9oy
	7YUYdunFIAW2HxHwloKgGpIxlZ2S5NM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ohOY26Jz;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766110513; a=rsa-sha256;
	cv=none;
	b=xo85QY/rcbSzjFep4CA62gFKuaB1pJ7WD0Zvu6AcjnKWPJIH5lONwgltPleO6/p7sxBaLm
	bwmlu0lZRcWwHBapoe7LD4jgxQ0LmtuT1Cp8hpLzbIky+Qq0aPGtAXyIhQhtV3R8q3H4wb
	ZPK7++OlGLGPEfbh0rqnP9t0d8Jutnk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CC784374D;
	Fri, 19 Dec 2025 02:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C1DC4CEFB;
	Fri, 19 Dec 2025 02:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766110512;
	bh=jbSSl/iAC0Y6PJMSUrlMAn/BWY9Mt013nMXshs1xgDs=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=ohOY26JzrJ84xK6XyL8AqFmyDkTo9LE/qIAUO8G0H5ib8aLYkqsqgg4iN4HhwC9A8
	 dSCzzo+xsEtHkc7jQ89GIDOau3gUAOxUVGwQECL+G4gWuQ39gpN4wNlvTaJw6S4eCK
	 6cauPx1p8PM4trko8Ybe0AOqRbLrch7ro1uFZaESGAkC4yrEtka4JS/mJQb+cz9OBs
	 VyLO4ZxrNZu41kCGli0yUgqOe5BHni16a6XnX7cGom+wTldN+siH/m/WQ7cBSSnvFu
	 p+6l9II2GAjI69e6mCttfNJniZ2cFHw8I1y5eFA3aZdR5kW4p5ErP9PalcG5xHtwHP
	 +JMxQvcfiW7bg==
Content-Type: multipart/mixed; boundary="===============1148049922040317406=="
MIME-Version: 1.0
Message-Id: <e80e8faecbfd7099950485f4de08a1226ae10282ec44fe9e6b3610fcb00c8400@mail.kernel.org>
In-Reply-To: <20251219015750.23732-5-roman.gushchin@linux.dev>
References: <20251219015750.23732-5-roman.gushchin@linux.dev>
Subject: Re: [PATCH bpf-next v1 4/6] mm: introduce BPF kfuncs to access memcg statistics and events
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kernel@vger.kernel.org
Cc: inwardvessel@gmail.com,ast@kernel.org,daniel@iogearbox.net,shakeel.butt@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,mhocko@suse.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 19 Dec 2025 02:15:11 +0000 (UTC)
X-Rspamd-Server: rspam02
X-Stat-Signature: bwx67pjr7csa4tkd4zai9kk19p3t367n
X-Rspam-User: 
X-Rspamd-Queue-Id: 2586B14000A
X-HE-Tag: 1766110512-803010
X-HE-Meta: U2FsdGVkX19WLEbt6AE3Jt/u8Tqwi7IGO3fuHlwwZ0wR8gKGJ8bNG/kVn3f5mOoKV+2MOeEpZeOBRy1n2k0WcBhLZYYwmBRSKcoQZYeZp7twTFQ2t07Apq4+wgif6+OqNeLHnHcteLl433s4QzVC3InrHEk8pWZkRfb+jPy1q7hlGCXcBXaBC/5oK8LTekGkgZF4rYmwa8ofEhRvdrPaAjPhK/AjfYR0fDHtBsaqi9oz05Z1Yp/NDf6RvLt6lLaIqUFzO+G/2NiEVqw9E/UWsrynKDWBtN2FSb3M0Wxa6rEJ6S+HSYzWboEwTA9gZldK9soKiwJ9Zr4N4CM/F1mmtd2l5BOB6luRIcntBAIVRsDnPJzGF6yeg0adRr+vo4q6Q5Uy6Q7jTw6+cZnRcjOpCiQnDkkL4GAmcxJM2kwVp7CuWRAifIVfI9QIsXT3QAvU92KbB5r8Qky01EZMUWAj8Y/xZixnWNszTAKoCAAWUlG0akZm40hH3Pj17qS/dP/QghSCPqdA+WCZFCNoOMHvz2E2zb7g59TT+zfsW+7CPPUJv83+EBKza8yhfKYEkaJZsKuskNWFnazJ3h6sZfBtANpvuF25k9+x9Uru9oPGdsva9RKo4jn0jodXdpAmnDD1LWkaS+8z/s3pAtSgIQY5sUmu+C15sU8NuMoMuHTDRAYphrcTJY0bi48Xkum8ZHOwS5QYTrAweemawPPn2joroKmcDv/5zuC+6CZjaNRWU9UvHIpaXT6NJbAfEbNo3HHStJinJUTHC6vkf8r0coNTO/EeWf+yUPwHkLVPGMaeJ1nidXT1H2nS+jeFIlAK+2VYBFIA1ekW3jAmgTbNobrxiSlncqifW5hsndHCTP+y8j9QeuRXtL47bwUH88hzQ+Nidq++8m0VR6kClmCBiJisv/T5ExkIK7RZvdigSeJF2NePxhWQ1iK+ePWb9rq6BpI/LC+M0okRSe+uM2J1TIw
 zRiHSUiV
 RObwzhlYnD6KKPwnmYG3x0qOaN00sT0hsVVjjvWVJhmVoz0JrsWUo4fHoAxej/8bIo4bzUNekgj6UKT3f7d9Z8VJEtIDRFxgq8oFihD0zLhOKGtmML1a7SiqFZs8v+MmcS3EWC8aS0vFzKjL9OyeUSgmB0jiRhgTsnbc4Lc8QNikFswQaEvSPtAnXQfY4ag7DgDhrvQUFxXtWD85TEvCZ7GeEOJlODtJN32PHbBGitqlgSMp3bFqzQXsylehXU+L7DdV+94TA6b5erkWDtJZK91WVePLpR8dTNKBf46BRSnDzUF3hldHLl460UAhaug6FMHJXoMC9GpXY904rb9emaKF6jDVVUKGciZHZSPacnxddf4G+BUPMK8OXxNSEHsFV9C5fG9GSLAWYs1DbZLYXsLS+tCcQwS/NLLSGiI6/Mz7o2tM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1148049922040317406==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 6d0d73bf0dd1..4d9d7d909f6c 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> +/**
> + * bpf_mem_cgroup_vm_events - Read memory cgroup's vm event counter
> + * @memcg: memory cgroup
> + * @event: event id
> + *
> + * Allows to read memory cgroup event counters.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
> +						enum vm_event_item event)
> +{
> +	return memcg_events(memcg, event);
> +}

Should bpf_mem_cgroup_vm_events() validate the event parameter before
passing it to memcg_events()? The call chain is:

  bpf_mem_cgroup_vm_events() -> memcg_events() -> memcg_events_index()

And memcg_events_index() does:

  return mem_cgroup_events_index[idx];

where mem_cgroup_events_index is an array of size NR_VM_EVENT_ITEMS. If a
BPF program passes event >= NR_VM_EVENT_ITEMS, this would be an
out-of-bounds array read.

The sister function bpf_mem_cgroup_page_state() below validates its idx
parameter before calling its callee:

> +/**
> + * bpf_mem_cgroup_page_state - Read memory cgroup's page state counter
> + * @memcg: memory cgroup
> + * @idx: counter idx
> + *
> + * Allows to read memory cgroup statistics. The output is in bytes.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
> +{
> +	if (idx < 0 || idx >= MEMCG_NR_STAT)
> +		return (unsigned long)-1;
> +
> +	return memcg_page_state_output(memcg, idx);
> +}

Should bpf_mem_cgroup_vm_events() have a similar bounds check, perhaps:

  if (event >= NR_VM_EVENT_ITEMS)
      return (unsigned long)-1;

before calling memcg_events()?

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/20357445962

--===============1148049922040317406==--

