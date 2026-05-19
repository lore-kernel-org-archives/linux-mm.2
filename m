Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47038CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 17:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A55A6B008A; Tue, 19 May 2026 13:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D1E6B008C; Tue, 19 May 2026 13:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66BF56B0092; Tue, 19 May 2026 13:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 585B86B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:11:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CB6E14034A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:11:38 +0000 (UTC)
X-FDA: 84784811076.28.71D2A5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E7354000C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:11:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRUJWOs7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779210696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZXiomvDJKM07Dk9Ji2mrTmXN5fYHCggl6JxDynWw50=;
	b=bvOnHy/qQfTSddoZJOiEpyjd9GBFNhu4H7HhKta3EfFFgFmCxWlHL0/1zWbexAW0NVgoKd
	Xw+n6Ud9BirpZvsQ2psWw7AA3HOgddSZqx2dyPPO+StzHL4cJbu/t7ehM/mszRYt70R6p+
	NBtnf5NpvJjRT2CRX8iGqAkoE1qWyUw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779210696; a=rsa-sha256;
	cv=none;
	b=ZWDGNvoCjalX77pQq9NIElWw8HB+84yKXE5/IzxTIYJ80aHW+ccjRZQEZg2V9yVhJvX+K3
	WU53EDaMZkyGlbPQSa06uSkNe1PWvUNz/Kj1cuNMAZneyFIdtsAkdDRdGmIcVe9LdvvPs5
	ujC8+jCLrzj7OU2GbAM76hB0TQH71+Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRUJWOs7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E101160229;
	Tue, 19 May 2026 17:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6DFC2BCC6;
	Tue, 19 May 2026 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779210695;
	bh=62vx8mX+NUzIAl4O0uDmSYpMMtEoa4nb7RMkDjQFU9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tRUJWOs7kfmxRw1IyuEx9VNmI+HtBY+RUHfIO4Wrcr7Z60Py1vJdh8cqsfX/MI9sX
	 85wED6Nhx+Wv8GGEbyqmzcIWf2zSmFf29XHERwlPl2D9pT49EizsxHThcfKl4WkAb/
	 NEkW74HrJMDH7B/47xhcIIDNSgYxQemoqodDbhMlMd9EoW7InETveW2nAc3hRkWplH
	 9Jj86eOqcU0sCrYlJNdX/JUkiyfP8GHwb3i40GL5hWX8Fawr8nkqGdKfOyVPFq5e+5
	 88qkzSaYK7+TLbI968s35OlA318ZNtHjcN8Bvq6zXPiOtOSWC7E+W+RbtMTW07doeJ
	 vJqxr1j+6uXqA==
Date: Tue, 19 May 2026 07:11:34 -1000
From: Tejun Heo <tj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	bpf@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot
 installs
Message-ID: <agyZxmHoueGwBAQg@slm.duckdns.org>
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-2-tj@kernel.org>
 <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org>
 <agtuPrgIDNKSu2Oo@slm.duckdns.org>
 <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org>
 <297658c4ae2d6e7103f5968efc936224@kernel.org>
 <04b03066-86d3-4c0b-b077-307fd0f3bc9c@kernel.org>
 <5590fd3d-dae1-4070-b52f-bc40982ac678@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5590fd3d-dae1-4070-b52f-bc40982ac678@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E7354000C
X-Stat-Signature: pzenzt18xwd6es1kue3tizx8xjepcx3z
X-Rspam-User: 
X-HE-Tag: 1779210696-231814
X-HE-Meta: U2FsdGVkX18TVMUVImfph5dyLdmueW20CZL8thjdWVE+/OUkcH8CC/bKoqpztaJlzQQRK9UnvEe2BsIwwL5tTDTpqCmoIohPJXG+NOBKB/sP+JGu4RpHSKXk0NpDfCSbgvJTkm0bpa//FLHKC73VJVJG2ASAw3L1gxGKg1TL8V2qyUKuJ9J33k0t0QRum2vY3Cor8T096u89VOUoghbS9G6YXrxbVcyrmBMq9msPlzAqJiCvU+O7XLLNLa7yhXoIjj0TtmrTQzZDbqedYRqLpxzg3RwiN7OVLJoJLCHTirVIGXiHLgXgCZY4oqOs71bbaW5On30DPv53DHHcvZ4ZvSPe8g3lGBdoRi5BKVpEHe3i5I0eTEot4sAb9H6fOFTW6XjDkJZNAhUCkS15m2ciUChcxSaTldFrIHVaIifnowW4o3x+Qr5zyANj6viv3qvZOHQIzCE3k2O+GL0BTGMpQIrfm2R6IS9B50iBiJ3y78DnpBKz8+8dk9X/wQ+dOpRliNj8N54K+Ls7ZteHNtHsmwOGmNiCY0kzqqegoaA/KsyA1X+vs5AEVeSwzUk4hS2Nbq8uIWSxcq36FTu5udGpPKsnZWr9Ki+Iyvg8lpgRtTttcTG/vafeFKuVgyI+xCWle6Bhc8YakDfBbVZGYWHOULiQyh4nypsjziwfu3TeXz5+PtO4eb7l4l8UEPHKbHc5xRb4xpezgUfea2tT7mP+ALpMb4awy50cbOrJOV8LQ3YonvU3xuSY8FNLkU0qsWd0GFVIyJDaYpRx9ER/rIbXkKm0XaK6jmK0bAM+yLoZq6yFV/1bBwKfhn09dHw5SXMe/rnUZCa3DRCcDPkA3OCoECMj3Ez7CdtxpmVtlifSlUNS1bvQ65os8L2+dF3zLNDqxxD+NJOxk+wKXwI8QkeCDkaUHOg/L0wFxbmqNTXOBs9iX54LNsXBaMULcZuH/DGjztU15acFuHMhPGyF6PL
 GmcDluh1
 N/3PnWRYtGZh4VQ6h/1hewtGEC/PUfX6K05FlJYpd5BBwcLzGflDVnij4Om0sz7rXHNnjOqIgvZiHIbEZU0ACOY2soLmyTDkIdwdYObCDfkhmLKJ0BzhomIwAGYPxitS9Ml3sTwiqMuRjDh56j3hM4K9w5XQZJX2+eKh+ai8p6TIdg1EC+hBsCwoxOjByvk1CKEMTppoLjbCIrUQoAISNveavKwoLCfLfzd/WzozEo0y0sCOy6AHABxZxof9GeJBXWnurNvmRXjrEok4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 11:40:48AM +0200, David Hildenbrand (Arm) wrote:
> On 5/19/26 11:05, David Hildenbrand (Arm) wrote:
...
> >> The only requirements are that the kernel doesn't oops and the
> >> violation gets caught. Beyond that, behavior at the address is
> >> unspecified, and which installer wins the race doesn't matter as
> >> long as kernel integrity holds.
> > 
> > You'll have inconsistent TLB state.

Wouldn't it still be either or with both cases being okay?

> > I really don't like that approach.
> > 
> > We should really try to just take the lock, and remove any code under the lock
> > that could trigger such unpleasant deadlocks.
> > 
> > Is that feasible?
> 
> ... or can we run into similar problems with kprobes? (I am obviously no bpf
> expert ...)

Yeah, I mean, that was just the first TP I found scanning the code. Any
kprobes or other TPs in the path would behave the same.

When this fault triggers, the BPF program has already malfunctioned, so it's
not going to be a high frequency path and performance isn't a primary
consideration. So, anything that can ensure that the kernel doesn't crash or
lock up would be fine. Any better ideas?

Thanks.

-- 
tejun

