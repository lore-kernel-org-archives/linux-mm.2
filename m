Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D55606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RAp7n2bW
Received: by kanga.kvack.org (Postfix)
	id 40BA36B082D; Tue, 24 Nov 2026 13:35:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC2A6B082F; Tue, 24 Nov 2026 13:35:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2358E6B0830; Tue, 24 Nov 2026 13:35:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D90596B082D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:35:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7910C0C9B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:35:49 +0000 (UTC)
X-FDA: 85470866418.30.99076E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1E4FF10000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:35:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RAp7n2bW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795545348;
	b=Ta1OKs6YQt4eUPm7x18jNcwvBTbBW+PT48fVNEibOb40kxrBxLqtrBMekahEfdSDawQj8E
	3Yz10/D7tfWG4nqGdh5OiB9kxbFYVomZNNo4B5PVwYyXfz1OYqNkXvlGqSYRsomo9k0D3o
	DClnrhxxASNhAY8HDmclJ4zxodSFY+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795545348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKrIa0DcMNjfh21UT4XypKvXywHSQ8okdo6wgugy/pw=;
	b=xrF0FCwkh/G6dmGp0NrXtRYMY00mwzKc19Q9ffYi5E6fbIE4yARNKViKd0YxpGpsOsdQgb
	2kbf63lU9Rdcif4pTolhDaKq4K43Ha2my3bM9/VryZ4cdYz7Ny2LbHfakvRs+DBNPUDbrj
	2/M7cf7IEWK7pIdNHyt5cr45+UsIIik=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RAp7n2bW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3737D45CCF;
	Tue, 24 Nov 2026 18:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5BC1F000C4;
	Tue, 24 Nov 2026 18:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795545347;
	bh=AKrIa0DcMNjfh21UT4XypKvXywHSQ8okdo6wgugy/pw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RAp7n2bW0wpzGNW7Ui2V2k+V9GEl4idrfP1qC2x1iSrh+5xHXbdyy0CJ1wfaoC+Te
	 txOnY9OxeabOYdbKiIA/7LqfM+X1YqOhn78nH6CeCW5v5IT/3p0k4XKT/A5iatNZPs
	 W5+i3LLZ6T7eUzNi7mRtEjDb4PP/wZ3B1WKIS202LxyIZwDnwBx25hJIDsDL/UutmS
	 W/cqup74eq7M+6UP1UVZudi13ylv+WROjXpKegblCYYHoVEBqo7Iv3GjPdvBgVdwuN
	 67ns6lvHHraDemZFXGte0ZKTYNPsz+O2Ak0t9QB6KDs5NQ95iTFoYVc6WI3yKaZNDo
	 9IVFAC/iSNvxA==
Message-ID: <498284d2-70e4-4b6e-978b-98a2b9e1e74d@kernel.org>
Date: Tue, 24 Nov 2026 19:35:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Puranjay Mohan <puranjay12@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
 <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net>
 <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
 <CAJuCfpEd1rz3P7fB7W_mHkyzbpq9TscRE+QNwvHdYME=WJj6cw@mail.gmail.com>
 <awWz3nc_b8x3mIXq@gremlin>
 <CANk7y0gAxY18Ew+6j5YsqrOsf5Dx+v5M78r7_8JLXh5RHZj4qA@mail.gmail.com>
 <CAJuCfpFuDCUPTUi3SuAhmbtw5tubRZ0+YEY3PotjyJ8Or8pdQQ@mail.gmail.com>
 <awXHR007d8MlhJUC@gremlin>
 <20261124093328.3ba2e066e5d5081c69e0e667@linux-foundation.org>
 <CAJuCfpEmFEX5iqLw_c94a97rVrC+xBWpKnO4rVpeDgkUfAPq7Q@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpEmFEX5iqLw_c94a97rVrC+xBWpKnO4rVpeDgkUfAPq7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1E4FF10000A
X-Stat-Signature: y9jbjkepjn8afsg7mqefm7of6qdmkapc
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795545347-58865
X-HE-Meta: U2FsdGVkX19nnohe4JtlcEAMgk0qnKoUYOo1XLlq7p5yPlBM6f0hykMtQJXeAfs/xlAHrmpiOgxVa6n2UMztIX7j+2QqwQO7GV1qMSfCttiHgWRQlqfl45YpioOzE4vGaDLerVqRGtohudmtLWMRklzItAUz/1Pjg4VrHEF/+g3dYudi1WyuaYcooqgOvPIRATrsC90lpEVJpuLLvsFJ9Xc6AH5YzTfs/PNBaWbDjcRqYAN6HygdBP/uN6cOIHIM+Yhtv86j+G6EaubUy8Zp0ZfsRUi0L4JRQxtoF8BE5KdxENFXwNE6FxDO40iUHJ+Q0pebtpnACPWCzZrB8le5vhd2Tla708poOb/Mx9xmf34DUGGwcAU1VnxlWS9zt00Pqv3rpGvYPTtNyhK6/stABMB8YhBlTq0jvs+trnFMnLUYTYtNZCby42ssF+9CFxjDvIEF0uVRXClRVcimg4Ue0p+JhaoD2i1gEw4aP7DbKcL2jWtjxM5p51Hw0ILeBuBgSl1et3Bu91VE0nKRRS18gc9bZ9Fc/umsffSY/Asw0WZGbPqCXFaCbBmwr52kA43TbyhUtJ0N6rakZlHmV9DwK3SOO7Uy4l62nDnQZ5+a9sUW9Nfa567nZeIIz5of0Glm5kPVhDJPaP9Mi7TqOQ2gekEDiEZ7Opw8ep/NubYuhOA4FzY28tTneSlA6GBSJT6hWZTQ1A+sOvqc8lZrC3KJQOPLaWLw6WH1OSzSU2fakbQ2kizaTMw2TtqNUrEd6Wfxmbq0r0Orbc17tfBpoKhShRCBSo8s/DvB2UVd/BiPEDZ0wKJ4sV5agDC3CcBFZ6tWgtAOqfbi5Kf9r4k6YMH549r2KhHqR5r5QBGUuH1m8U+Sv8oF/LcjTqEE7QHlkjdwguU6oM1cT3h22c8dEgZyJYlJh5mt2xOYVQujF9jEINLDirIIAHT/Ng8jSi4Gh5p7hPA0bDPBf3CSvvnKFwF
 NbnMixbM
 TBXnBumwiNwUCI6sAEDH4mYQN7Csqit5wo0S4khZM6YthifSqXYdQC7HQYi1FJbSS2JGvNfouwIfX21ZHKgzHZu8atXCTGp3Bs2R5UhrYaeXZTWr2kuccju4RFxLqV3jZW7yp29pLcPZpLQNHcqAKaBU8N2x/hoXnuB7xxo0YbXY+BtNL8uDrDBiLmfvoB2HfVBQjjdpEwbNHf8hQVQck08+s3+pUBXeBGZQO9EctlsOGf9i5xaaN1VA8SVMQJfcQXLyF7zMc2ZixbRYBWfJnjO08ka/8uMmi5NqvXBrqS/oo4RLdAlTV2RW1iHCzKGkGm8Dh5MyPx5w0twP0w2etGK2y/mKig87ZlfplTQhIS91CjgYmzno083L6Z6zIm/ColWYV6eZySJ+qCPquZih9LEpEBhNdgpz9ISWsC2MJLk2/mbjFhdQAXFXUNILb2CwiStQp94pr/bQjUk7pwijvhl4Z13mo/H+2FM+9tMQR5nB/K8nKapG6jJ185dMuDRO+2Ww5n7hjswW9zs2qsro8AfBHKKox1iu3T20tn22be04Yz6WKOMhT75l1B2qlQ2MCKRuVq4WxFVvUNDwmwX4azMICGDSKgHg5NiTD7rIs3xLsvXg6e426t4nCzzCpkDYbRyR6cs/eZ1HjunseWTdMW3Xwq7i5f+xqBhI/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 18:49, Suren Baghdasaryan wrote:
> On Tue, Nov 24, 2026 at 9:33 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Tue, 24 Nov 2026 17:23:35 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>>
>> > On Tue, Nov 24, 2026 at 08:34:40AM -0800, Suren Baghdasaryan wrote:
>> > > On Tue, Nov 24, 2026 at 8:06 AM Puranjay Mohan <puranjay12@gmail.com> wrote:
>> > > >
>> > > > On Tue, Nov 24, 2026 at 9:28 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>> > > > >
>> > > > > On Tue, Nov 24, 2026 at 07:51:42AM -0800, Suren Baghdasaryan wrote:
>> > > > > > Actually, VMAs are allocated from a SLAB_TYPESAFE_BY_RCU slub. With
>> > > > > > that RCU unlocking move you don't need other_mm copy and the comment
>> > > > > > that comes with it. VMA won't be freed until RCU lock is dropped.
>> > > > >
>> > > > > Yeah but they can be reassigned? They won't be _freed_ until a grace period but
>> > > > > they can go back to the slab and then allocated elsewhere  right?
>> > > > >
>> > > >
>> > > > Yes, they can go back to the slab and become a different VMA.
>> > >
>> > > Yeah, you are right about that. So, we either have to keep the RCU
>> > > unlock in place to keep other_mm comment valid (my personal
>> > > preference) or update the comment next to other_mm to explain the new
>> > > reason it is needed. Either way is fine with me.
>> >
>> > I think let's just change the comment?
>> >
>> > Andrew could you change:
>> >
>> >        * stable and can be freed in the narrow window after vma->vm_refcnt
>> >
>> > ->
>> >
>> >        * stable and can be reused in the narrow window after vma->vm_refcnt
>> >                            ^
>> >                            |
>> >                            just this freed -> reused :)
>> >
>>
>> np.
>>
>> --- a/mm/mmap_lock.c~mm-vma-drop-mm-asynchronously-in-vma_start_read-fix
>> +++ a/mm/mmap_lock.c
>> @@ -300,7 +300,7 @@ err:
>>  err_unstable:
>>         /*
>>          * If vma got attached to another mm from under us, that mm is not
>> -        * stable and can be freed in the narrow window after vma->vm_refcnt
>> +        * stable and can be reused in the narrow window after vma->vm_refcnt

But this is talking about the mm, not the vma, so the motivation to change
that was wrong? (it's not a typesafe cache). Moreover...

>>          * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
>>          * releasing vma->vm_refcnt.
>>          */
> 
> Sorry for being pedantic :)
> There is also this comment later on:
> 
>         other_mm = vma->vm_mm; /* use a copy as vma can be freed after
> we drop vm_refcnt */
> 
> That should be replaced too with:
> 
>         other_mm = vma->vm_mm; /* use a copy as vma can be reused
> after we drop vm_refcnt */
> 
> Again, just replacing "freed" to "reused".

Nah let's not overthink this. It's freed back to the allocator first. Which
naturally allows it to be reused, yes. It doesn't matter if the underlying
page can be freed or not. UAF is a UAF.

> Thanks!
> 
>> _
>>


