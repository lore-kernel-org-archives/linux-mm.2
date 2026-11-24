Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D02606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIER/tK9
Received: by kanga.kvack.org (Postfix)
	id 195906B07F1; Tue, 24 Nov 2026 12:23:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16D0B6B07F3; Tue, 24 Nov 2026 12:23:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0838A6B07F4; Tue, 24 Nov 2026 12:23:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA9F56B07F1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:23:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 853BD1C3FE8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:23:47 +0000 (UTC)
X-FDA: 85470684894.02.C3F14E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA9D640006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:23:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aIER/tK9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795541026;
	b=Hx7SFpGtSKbZP7Jy1JjncP2sfn5nRyKU7ksG/EW/K2vL1Y22ys3CohfbXHNkM3ZZmm1CIv
	PYPdOqpz2frH5a2SeD/ORfmokx4niLYh/wHwL1kKhbx+zhrlDU+KomV2T215rXMXFt5jFy
	lZsCNa27fX9LG5y4ompcSHj+/ODyNOg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fS8UX0zOG7y5HTbRfTEb+A5QmGIQnuTVBZNrsVPO3QA=;
	b=X75FUrnU5KCNxaz6jzEO7KcEW233psnVFwlTWY9RKhQ6+KgFS75EZa9crgQZWLemQXKGrZ
	qj+c0uQzniFzHEU4QBZmv84Bk6jaPPQlcRh0/+KAaY1KWWW5K7hzycK+hsFPVsLPoAf7KR
	e/d++PZ9tg/7SE1p4FAUzi4TSKkGHBY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aIER/tK9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0425D43A39;
	Tue, 24 Nov 2026 17:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F0E1F000D1;
	Tue, 24 Nov 2026 17:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795541024;
	bh=fS8UX0zOG7y5HTbRfTEb+A5QmGIQnuTVBZNrsVPO3QA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIER/tK9Xj9J7xTkM7cNMYCpdtYq0gOZ2/0BrOQlgPEO6oQ5XstyYWIMiG9xBv81o
	 dW0o2fsXWJ7a0R3kzyAd7SW3xgwAyK/lFagJBx9SUiAJivswcb77/aFDQis9KITn4z
	 2hQCWdu8XGvvjs6cR7zxu41TDaqS1fRg7RPlbK6qgQsdkTQWIKRav9VBIUJDloU4/S
	 T2qG0m0Y5nYwqLVJD7Bxbjy8GBYXbO+AkFaxmZ6p4feLXekf2YjojAswcGcH7TtM8d
	 Zjm526349OF6EKBgApdu6YcK8jHdyS6sID2wuiZijTsgye75nh3feB7scItYNrqYsZ
	 zfI0e9bBZJN1g==
Date: Tue, 24 Nov 2026 17:23:35 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Puranjay Mohan <puranjay12@gmail.com>, 
	Pedro Falcato <pfalcato@suse.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
Message-ID: <awXHR007d8MlhJUC@gremlin>
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
 <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net>
 <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
 <CAJuCfpEd1rz3P7fB7W_mHkyzbpq9TscRE+QNwvHdYME=WJj6cw@mail.gmail.com>
 <awWz3nc_b8x3mIXq@gremlin>
 <CANk7y0gAxY18Ew+6j5YsqrOsf5Dx+v5M78r7_8JLXh5RHZj4qA@mail.gmail.com>
 <CAJuCfpFuDCUPTUi3SuAhmbtw5tubRZ0+YEY3PotjyJ8Or8pdQQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFuDCUPTUi3SuAhmbtw5tubRZ0+YEY3PotjyJ8Or8pdQQ@mail.gmail.com>
X-Rspamd-Queue-Id: CA9D640006
X-Stat-Signature: nzt7tfw17bdtjepfbyisxkcapwp135hj
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795541025-527999
X-HE-Meta: U2FsdGVkX1/XrXEqP/YSC6T8HNTkhoGW+QybAVpWbN94Lvhddg74PQeSkb8IQXWwYTYEZAeofTtcQFpxQoEagu6i49y64o7PA6ABgi+PETKWR47ie6QyrqdEKGSaTiNnLgkLsRm3OC+EXWyPE5ayHrPJlyBwKAnaFvNysgbaNqUWdcOHTZjl0NzG1OXSDtl0YHQ6w2Yz5VT8gGk93qR92/2B2r4uGSFC1Jewug5INrGt27TA8JWbPTmHQCBqy+EzplzS7SW+neN0o3FUEwLWDKR6ehLYYpe57xn3S3BKPdadgCjkMIqxczUfyF/XoZ1+741w8LABILgCNFYnYyUUE2bQh4teVbsqxdb9ofOBnOzzt/GtOq/gRSE9Xi26sD0LZ5++OSN3T+fIZR4uoW7orviG6QvKJuHWMfJSW6zBpuUU3iC9aCSTTvnvjuxCxA6FnT2sr38DFduyzYgu/5YIb05BljbVMnN8p32izgTZlmXtJD7wWn2Aw2Fd/xU1rSO4z7c2wKGZk2334bIgdXOINcA5QrSjq9oSz+fJy6P6DuSt2wu/Ovpe7YLXBBOI3DgwJzRP9zZZU668E6vg3IaRwBb0PkOdFvwoPLWqbx9MxUHNqF1zijkTHRvxdv3UQbyvWa1LDGzhZaelOHtFTdkwZdVq9hs99iKMMmpoXU1x5DJ+RgoX/zR+gkJa0qFapqceYLGel8iVvXhrIWkOT9lgwJdAc7zFgYdTMqZHrEMBFZjRaC6ftyMpDV22E0l61i+9Cv6uIydTm9J9U5uqqt1nwImWO9ttZiMe2bQgENIl2RkdLZ6yfvlfer7NkAtWMszE6v5FpNBb/YdeNGKbjz/JflVq0pjazTm2LU6MER3XiOEryxnR/Mi5SD8DaD89CSWJVdV2acc+TdFW08ytZr0JQzsVRSCBDtTJA0Q0UUhslgkPfaXo+qsk1UVnoodqrzXxhJYrV6f3ChGhiuJ0kET
 wW6uwyxG
 hiIqWDvLbgGFrNHakjofdKzlzROjaNsmxucjmnF368tT4H+tXZthY9h+2eeIcowsCOCN66kZMl3IYDIOR4GPambjykvTi741Zc9w0BPt9IikA6DZ5ew6gFsD8UL8giT809Zq+CpfWsOvtCZZfF3lnSK5layNxuCe3IcDWERYITZ+VomS89HHphd6UfTNlIm5KQdhK12o/Gx7ZHwwklaIvls8wFPF71yB20DEHe5v9A/Qb4acNufLDUJDhV2GEotzVzMEUxl7aFXDE9gmfBPVyITX+xw0fLFHkiTiqyCYI9THoq2nsFKM0Nvkhs3d0RamZATro9fZxu1RULc1ErJwyl+KSG3DW5SWa39zY9cQEddvI0ZKPeEEIMeLkgkk51HwcI7BxQkzfW9X+JAgq7zJqKlS8do5Gko8KoK0BkIME5aPBQHRPDwjDOywg7p/N5uUeCjHI0pxdOpHruphNUPfuLQMdNkTrfegN2H5ZJ2bhtZTil7FMlmkW5HqcDvzWoat91C3SqiQLRv2GUAw2Y1MmhKOO92vWFMKYs72ZuWj6kQyaUOBZtaGLwUqGfxmkMW6UmUhr5Er0NhnAYg5WjAHGU7MVRHK2sMB2rFfk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 08:34:40AM -0800, Suren Baghdasaryan wrote:
> On Tue, Nov 24, 2026 at 8:06 AM Puranjay Mohan <puranjay12@gmail.com> wrote:
> >
> > On Tue, Nov 24, 2026 at 9:28 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > >
> > > On Tue, Nov 24, 2026 at 07:51:42AM -0800, Suren Baghdasaryan wrote:
> > > > Actually, VMAs are allocated from a SLAB_TYPESAFE_BY_RCU slub. With
> > > > that RCU unlocking move you don't need other_mm copy and the comment
> > > > that comes with it. VMA won't be freed until RCU lock is dropped.
> > >
> > > Yeah but they can be reassigned? They won't be _freed_ until a grace period but
> > > they can go back to the slab and then allocated elsewhere  right?
> > >
> >
> > Yes, they can go back to the slab and become a different VMA.
>
> Yeah, you are right about that. So, we either have to keep the RCU
> unlock in place to keep other_mm comment valid (my personal
> preference) or update the comment next to other_mm to explain the new
> reason it is needed. Either way is fine with me.

I think let's just change the comment?

Andrew could you change:

	 * stable and can be freed in the narrow window after vma->vm_refcnt

->

	 * stable and can be reused in the narrow window after vma->vm_refcnt
	                     ^
			     |
			     just this freed -> reused :)

Thanks!

--
Cheers, Lorenzo

