Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4A6606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hqTmKQ/q
Received: by kanga.kvack.org (Postfix)
	id 798B16B05B2; Thu,  5 Nov 2026 05:30:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748D76B05C0; Thu,  5 Nov 2026 05:30:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 687C96B05C1; Thu,  5 Nov 2026 05:30:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4708F6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:30:11 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCE9A120911
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:30:10 +0000 (UTC)
X-FDA: 85400695380.21.5BF9109
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3CD0440007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:30:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hqTmKQ/q";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9zGelRzeR9jm80W8T8wv8FzP08CSeK9Ddixf5lP1vw=;
	b=b3k4FrFvjVnTlbOKyIGUMwYmNxFWc5dmWQFa5WwKBf7klXthLV4R7SVC60AWiZVnpHCkM9
	NPT+9r8UTJGzhjSK0HIgMlaoDQyYvFwrkwpd67hLX2laRR1VbjfQtFC/dypmn38kaVUz1H
	lSck63MLFsNSthwj3sbUto4zcyg1RRg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874609;
	b=uzk+WacV3VL6/POY1urHhgR8CIywwPbXuvAH3MlVP8cWCUGYl+Y5rtjjnvhwLUS0rCvxGX
	3eFJKqU61spm9Tg+xqIuoFzBTftRaxCH9yclAPwmXtpjQlJvYNfvZ+qAIPbN26Y47CBvVQ
	8HJxHds5MdIPAOcw/VTYq58IBQRD1+k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hqTmKQ/q";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C002F601DE;
	Thu,  5 Nov 2026 10:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DCE1F000C1;
	Thu,  5 Nov 2026 10:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874608;
	bh=n9zGelRzeR9jm80W8T8wv8FzP08CSeK9Ddixf5lP1vw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hqTmKQ/qNd9AeJgNq91fZYaBkT1aP98v69T7CblGk1hbHSSV41l03zI/1/gLM3P39
	 gr2TpxhJt9bX3ruuedNEVPDI3PC/uwQke8cG8mPbP4N1aS6QHl/CzhSema57b19cM0
	 FcavNSTFKDWdhBUABl23/UCdpe7kfj64O5K3lAHwlxA85029NxyrZ8hKOPWx6HmMO3
	 74/lcRV0iMzpQuYy95W6qJ2QC4F+kCiMDOwcAIa/BvYHSZYnL0kbfunbtWKVHZRZpp
	 +nRyPjoeSUj1qwEc8FYLCLEGra3P9X0mm1jCPybRdUbf+Cq4XXo/GbUcnmsAao7Akl
	 m89HXXZCO1PEg==
Date: Thu, 5 Nov 2026 10:29:59 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yonghong Song <yonghong.song@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 3/5] locking/rwsem: add down_read[_killable]_nosteal()
Message-ID: <auxaRUi4h4a4tfUk@gremlin>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-3-a07ab16ac860@kernel.org>
 <20261103115159.GK1813469@noisy.programming.kicks-ass.net>
 <aunLcWto870swo38@gremlin>
 <9c367177-1822-4b6d-8bee-d283eef7b895@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c367177-1822-4b6d-8bee-d283eef7b895@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: n7i67dahek6ejzmn36764o7zae5yw59o
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3CD0440007
X-Rspam-User: 
X-HE-Tag: 1793874609-143377
X-HE-Meta: U2FsdGVkX1/kyNqeyzE6f3EAK5Kem/7/B/jLl+Pl6Obv0ac2okFPp/ae0qk181K00ym0PJiNcnWydeU8yfpC9G9Hw/h26CMWzdxO0JCZRkhBmc2DZyAB8RDxTXqbRdPEqWC0fc/77BJK4a5kr/30IZy+nHMxV47HvrJdKGA88oK6e3BGYFNfiIW4ESfBad2kEp577+4ipO5MJbzsejPf+F30Q3EfhR/OBcwNrLfOKxd6OrYYNhJBvvB1p36S+0dbDsUo3GNFgm0VXxn0pULsVD2gKbwtX1sxs2lJekg419jxeHBY5Iso22SiRTDzqdaszrzDkx6JdYLjwETmyB34yeIrPUgQxnoPsoJ8zELb0TBMK0lfS5eDVp+bZAHPlxH/zcc7PjkS6IodgwNRhG8z0wDVFGJd7C0LhTJT3ouflmpepO/OHw/NosVwbTOZTFLC0IPWVKR8IE/cMKYJCu/fyVDHpscfzcRP/gCoMlYi3gUwg6BSC9zbV1AuAx693/msxzG2G9uFfXJ53UnHlOqk+Z/o4BL9cXgY0syme6DtRDPz0QM7NE0hZM+Qj5A0mzYCPHdUH8KA6klnXSmD/U0nw6xV+jnIPnICfEasrVzhST3MdXMoLNa+ye56N8AkNxwE3TIxuXUhG8QKB+wjirA5nnLuxqmik267OBywzD7+yCKLlxHdXMsd6UHhuAl9Tjlhw0kams+AN1qlS0fe7xK38w7LB+ShlUeKKmuvNH2TIGxcmMe5rBrcKBmAcuQiwBukv8m0JtsuF6qZlj+XlYNbV7dc6St3/e+3Dqzyvpgf6oe5SOPJIefubvuFIazAPx+8a+kd/NaO0OAhVGiOvTFD35FRDbpUKtIBX+3ne8sQ/q2iuhQ0CwbdsJ4jhrSR02m3S1pNhFNKzw9/ATyyZ46wPJLzmoDX37pbj68CaUayFaLQXo8LmmiPAwcsUZOW5Tu53xmVm84ImE3N0tEWl3R
 CBg1/x5h
 d/AK4NU/Np6J+kVEC3isZZvie0JufCZnuyiAPZFKGjsJbElmVJzPsErR86LgFHx+FB4q61XJyXm8XeD+bg+vPHOwcY+x8QxDvPsfn+TnH/sMDvsd0/NmHuqw/KY4D4d9iWcD531FXxYpRp/0CUKh5iuMh4cd92yA3Oisxmj+WAUo1m974rrZOnZpI6W1dxD0JxaChwKbqcPct7eNREupznXb83XkAu4LVbPgNhmv2LKE+0cV7kbBHDuXNfl+pLTzJoE/4rSrSocZWeFnQMOjxK/8zthgIZ3ww18R8QN2m4yI07y4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 11:25:25AM +0100, David Hildenbrand (Arm) wrote:
> On 11/3/26 13:24, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Nov 03, 2026 at 12:51:59PM +0100, Peter Zijlstra wrote:
> >> On Tue, Nov 03, 2026 at 08:27:44AM +0000, Lorenzo Stoakes (ARM) wrote:
> >>> Since commit 1a728dff855a ("locking/rwsem: Enable reader optimistic lock
> >>> stealing") a sleeping, queued writer whose handoff timeout hasn't expired
> >>> can have its lock stolen by a read lock issued before a woken queued writer
> >>> was able to acquire a lock.
> >>>
> >>> To avoid write lock starvation, this is only permitted if no other read
> >>> locks are held.
> >>>
> >>> However, this behaviour defeats the purpose of a reader periodically
> >>> dropping the lock to allow writers in, as doing so only works if the write
> >>> lock is acquired first, another read lock is held, or a queued writer's
> >>> handoff timeout has expired.
> >>>
> >>> Provide a means of indicating this intent via down_read_nosteal() and
> >>> down_read_killable_nosteal().
> >>>
> >>> Implement it by exposing a steal parameter to rwsem_down_read_slowpath(),
> >>> update the starvation logic to modify this parameter and modify the steal
> >>> branch to check it first.
> >>>
> >>> Also drop the duplicated RWSEM_WRITER_LOCKED check and remove the
> >>> goto as the steal condition makes this redundant.
> >>>
> >>> Exposing this function is safe as it only makes the lock more pessimistic,
> >>> so does not impact lock contention.
> >>
> >> Not generally a fan of this -- can't we tweak the steal thing to never
> >> steal if there are pending writers?
> >
> > Oh, well, I had assumed I couldn't fiddle with that behaviour across
> > rwsem's in general, so if I can yeah that's preferable!
> >
> > I could send that change separately then and drop it out of this series.
>
> Just so I understand correctly, this patch here would be gone entirely?
>
> But #4 depends on it, so now I'm confused :)

#4 would go too :P see, making your life easier ;)

I'll try sending the rwsem separately, then respin this one.


--
Cheers, Lorenzo

