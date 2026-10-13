Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6051DCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2616B0088; Tue, 13 Oct 2026 05:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6625D6B008A; Tue, 13 Oct 2026 05:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5780F6B008C; Tue, 13 Oct 2026 05:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34F9F6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:02:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B272DA8884
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:02:26 +0000 (UTC)
X-FDA: 85317011892.19.4243AB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 23F5020008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:02:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WSkbhZjm;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791882145;
	b=r+/cbAHHArIU6kjChT6CV6Ym46xRSMs/i3k6bbodWF4JLFaODCGLK+E5dvsUCN2agYCr1G
	MpL6jtaA3Ck+4AScXlrxDDWFzEEB/wJ5InLsQpQY+mcf8T88Rfc0N+erTAhnjq9btyVXSN
	sd7NwANgMSumiyDiRYKWoWc60Dm1JYI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WSkbhZjm;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791882145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isgOp/oWK7UgvcDokY0BIJcX1YHTkMKo0hu92B4JBqE=;
	b=Qxz3jRsDDuJ+SltyilRvdDfOYLwm5/oghxqRfw34Asg8FKEGStNRo4RXLW4WfyCJ3NCSr7
	HJPBAEt9jniqB1F86sl3WSPT/je227VCfFIsRwTor13rtXDwLFoWNY3Hp/CXMLcBQlqxp4
	VwxYUGc52+xyezHGerkr5zVdW9S8Fjc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0C2B600D1;
	Tue, 13 Oct 2026 09:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755671F000FF;
	Tue, 13 Oct 2026 09:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791882144;
	bh=isgOp/oWK7UgvcDokY0BIJcX1YHTkMKo0hu92B4JBqE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=WSkbhZjmBqxa/sE2Mnj8bDjz5+8dGlp3i9aHxaj6Eh1hfQ0DAxLPoWWdiZURnF/ca
	 Tvbld43AOhDlNw9YBllVvmszi7dHcPek92UyqKZQ5o2H52xrnkHnPUyUzTDXKYyNgH
	 i0a4LNwP7m8WVeUKgeA0cOzJpeOhrIKm2Gkd3T0vDx+8dSeoAuMDXszD3w7bYhbjTE
	 /ROYm1XgqH1+HjIvKUJTs5jBAfVkmhOy6TB5DUFKovrpNtbOX220LROmoSRL7p03mY
	 oE+0lCVh7XqFtCADccnxOtMpR8kiH3fyURn5RbjKYISlVtrcEjCoo9x8X28TZqbfM1
	 ZlVGRj6iDynXQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Sourabh Jain
 <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,  Alexander Graf
 <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  George Guo
 <guodongtai@kylinos.cn>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH] kho: fix global scratch size calculation
In-Reply-To: <as0UrrAvqjvUPyQx@kernel.org> (Mike Rapoport's message of "Mon,
	12 Oct 2026 20:11:10 +0300")
References: <20260922131217.698809-1-sourabhjain@linux.ibm.com>
	<asC3-4WNiTF3n7l1@kernel.org> <2vxzo6czjaa9.fsf@kernel.org>
	<as0UrrAvqjvUPyQx@kernel.org>
Date: Tue, 13 Oct 2026 11:02:20 +0200
Message-ID: <2vxz33uaj7mr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 23F5020008
X-Stat-Signature: yzmdc781t7knpm74qqezueof1z7n7pcy
X-HE-Tag: 1791882144-597403
X-HE-Meta: U2FsdGVkX1/9P1gQACDqNoW8kjYEQ+IMMXLzBAzojqOgcl61Ed+m/VmdTxMzKEgHQnu7/709Qh4FPLNFng45WnQ8wc3SMOfcfZR5Oon+/5Kg+zu3d+yNagEdUkLIg+tMrv4EhJFFzI5GzLk7HvpwZ9ugMyYKAq3KY0cfCWyMJvwLGfZBbpe6R3kqrPnKX9n7kwLnGnZSqWmiwyy7uyw+FwMU4LJxxjyxLOH3DIZteFiTAXrl/9OpRaVSJq7hQ4FhYRuBJET5dNvZmt19uchYLT+0qKzO54XekpxnFwmvYKdo0cCWWqOVt6OIBr7K7qSLHb7hU7GJ3cGg0hR+81q598BVmWype9wj9cx5TMIYIl55GZJXNCG65b3bix3GUEv4P5GeKvyPKF5sW5cUeT26I9KyaDurb07EVt80eB1kMR1Q3owxjSWRMabPqwL9VmhbVdJjhD9RwPYT3SLT9Ljmswhkqn6sAjhN9Ku9SR03fe2e7bUeit388odWQB9jcg/81NRAgNzBArFVVhXMiJUHZ41vfkXEM9jcJx/eTszNmoTzAKNFXUHvp4kFqUAkEWq/UNflGKoSmbda954MwSs5Y80/7HGhqMx/x382I6j4yUA4Lip9+F7N7MdlwHogoZkQVu2DhqUF7KX6z2cwwQCiv7MRfMhVajKtS+N/B+64crBwB9F3JQGaI3WeeYRTmSs6ZvCfzEs9UiIZScH5iH6h7mudQ+QLKpOYO1kt9qadVCdr2IkasNHt6cKhz2koiMwxjgAlOymopqPB9dsuN7RkPYJe97TOYtwxayL0gGPiVElZLPGTBZ5nqozvPd0TwxJTOjdKT+5gvPgdpgGM16Kf+WaqnasZ8HnjmOM39aUjk0e9cDmxOxnsW/w4ZAeilUcQo9mY36DpqaCugh6SkIIkT4w0t9f5r4KR+VvnxKB48LTwOxPJRp9oAfVOvaGLf+CU3YS3JlesTOct6ObUrgf
 J1l04Elf
 X1LwqXsZSv6XW1NiO2x0a6VdbNFeMBZnPE362MwbVyNotqU4koH8iTIeDGQ+04nXuxI0S1KbXJxuUG7FUJ77cU6o2FAAy3cu0HOdD9CmkRJN/Az7b8SjKV+n3SbXOnzD0YVvxgxDemY/vkBKNJDPmZTwW27RYbpKyhRDbZq3Pf9chqD133Swz8aFosh+6dHE1wVpTooLtxL/EgsQiqfR6b012q3YNXt+tSzOSFZPN7zc/Q3Qc0qdHuRduw3IUHTprLhB1rdrvt5SsFDfMcnFH2TkE2bPppA4m4BTf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12 2026, Mike Rapoport wrote:

> On Mon, Oct 12, 2026 at 03:52:46PM +0200, Pratyush Yadav wrote:
>> On Sat, Oct 03 2026, Mike Rapoport wrote:
>> 
>> > On Tue, Sep 22, 2026 at 06:42:16PM +0530, Sourabh Jain wrote:
>> >> KHO calculates the global scratch size based on memblock-reserved kernel
>> >> memory. It passes NUMA_NO_NODE to memblock_reserved_kern_size() for
>> >> this calculation.
>> >> 
>> >> When memblock_reserved_kern_size() is called with NUMA_NO_NODE, it
>> >> counts both:
>> >> 
>> >> - memory reserved for a specific NUMA node
>> >> - memory reserved with NUMA_NO_NODE
>> >> 
>> >> KHO needs to distinguish between these two types of reservations.
>> >> When calculating the size of global scratch memory, KHO only needs to
>> >> account for reservations made with NUMA_NO_NODE. Reservations made for
>> >> a specific NUMA node must not be included in the global scratch size.
>> >> 
>> >> Add memblock_reserved_size_nid() to calculate reserved memory for a
>> >> given reservation type and NUMA node. When NUMA_NO_NODE is passed, it
>> >> counts only memory reserved with NUMA_NO_NODE.
>> >> 
>> >> Use the new API for lowmem, global, and per-node KHO scratch size
>> >> calculations. For lowmem and global scratch, count only memory
>> >> reservations that were made with NUMA_NO_NODE. For per-node scratch,
>> >> count only memory reservations that were made with the corresponding
>> >> NUMA node ID.
>> >> 
>> >> Remove memblock_reserved_hugetlb_size() since it has the same
>> >> implementation as the new API and differs only in the memblock
>> >> reservation flag being checked. The new API handles both kernel and
>> >> HugeTLB reservations through its reservation type argument.
>> >> 
>> >> Define the new helper as a static function in the KHO implementation,
>> >> since it is only used by KHO and has no users outside
>> >> kernel/liveupdate/kexec_handover.c.
>> >
>> > I looked again and this feels like a band-aid to me.
>> >
>> > I think we need to step back and rethink the order of the
>> > scratch/kho-bootmem sizing and consider how NUMA and lowmem are involved
>> > there.
>> 
>> Could you elaborate? How else would you calculate the sizes?
>> 
>> To me, the idea sounds fine (although I also share your comments on the
>> code style). This is what the global scratch size should have been doing
>> from the get-go. Today it over-allocates by counting both global
>> allocations and _all_ per-node allocations.
>  
>> There is a separate problem with CONFIG_NUMA=n, but for that I think we
>> should just have a different allocation path where we only do lowmem and
>> global scratch.
>
> I mean more fundamental code refactoring that takes into the account all
> cases (and I could miss some)
>
> - NUMA vs no-NUMA
> - systems that have global scratch containing lowmem scratch vs those that
>   don't
> - and of course fix global scratch over-allocation

Fair enough, that makes sense.

[...]

-- 
Regards,
Pratyush Yadav

