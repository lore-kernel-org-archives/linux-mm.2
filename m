Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 645A4CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9036B0088; Wed, 20 May 2026 10:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759006B008A; Wed, 20 May 2026 10:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647986B008C; Wed, 20 May 2026 10:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 515E96B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:03:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E57B1C007D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:03:11 +0000 (UTC)
X-FDA: 84787964982.09.637DCD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E3D7314001B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:03:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P5bZhmAO;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779285789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVq1PRtyLwFgQeButF/EYwj+4oJs8ArhxGEpOkEP3iw=;
	b=qvOoC42bcYGj9p4RtoF1IZhap8KeJLTi/8Y73ioT1rSc3Y6NU/3xlbEVXkpmNuHKnKZXgp
	okdX/wK9OpHw9w2wHaZWdIANsLnZlz/Vwb4WJM5zAaJ8bQOZV3yUCEdpFCX7IMfV/ICgv/
	kIiBio7ia0Ok36eOw423yvWLzS/xvco=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P5bZhmAO;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779285789; a=rsa-sha256;
	cv=none;
	b=lzj+XIWFgbuDQ8Q0XWPOCGDn77bd5iWSAQG9WeQr94FAUVdFmMcO9ffaAycg0pXTbtFibz
	RAQpfH8XmST+JfD9b/fWWoadElu+slow4z6Wtegr5Tvcbxs/VpJHT1VmBSlkCwFokv7dif
	JoNZeMH0xHZx7qUiS+fD1Z/DE/oINIU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C33360008;
	Wed, 20 May 2026 14:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0041F000E9;
	Wed, 20 May 2026 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779285788;
	bh=mVq1PRtyLwFgQeButF/EYwj+4oJs8ArhxGEpOkEP3iw=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=P5bZhmAOLXd7woxOuBePjzjhMOCmnSWn6QQ31DwBzJmdE3YXPzHQNq4MqkVRRnf0f
	 NSeOM8OnEK0o5sW17nIE3tgwqEK7Vx9i6i5cgoQe07Gwgr2v9/3i8BTnj+MY2tj84N
	 wEd+Z7TexiYx8Fe3OjaUBxBoQRRJDP1MAyUMN92KV4webK6odgiBUuS0GkIb398dvY
	 7aElPvZUXTY1hOGYlBcyV7CVxAGFTgzwiwiLyUGxUo7MsQ8q01IL3ZI6SrnwH266Df
	 SR9yRlDqRgODQJ0fcPtSE5UK8BTsyhoKUBeYiYOewF6zsPF0W4JgkMTCsSQYiod7Fh
	 gTOnl8gXxqgfw==
Message-ID: <881cec2a-9425-49f5-b96e-4595813a4384@kernel.org>
Date: Wed, 20 May 2026 16:03:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across UFFDIO_COPY
 retry
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Carlier <devnexen@gmail.com>, Heechan Kang <gganji11@naver.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu
 <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260519052516.3315196-1-rppt@kernel.org>
 <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
 <ag2uzVgx2Xl7zi58@kernel.org>
 <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E3D7314001B
X-Rspamd-Server: rspam06
X-Stat-Signature: czg1cfky9mpyc8z7j74csbjuqum9qk3x
X-HE-Tag: 1779285788-742938
X-HE-Meta: U2FsdGVkX1/vcWEZ+nl9euZkm51gz8eP2Of8pXAw1FRY/F0cB5lEekcSyxfflmHwGK0ZBLgAo+Phr5eqE4H0XluLR2oSfQUlwJv99C4geu/+9m209ZGrsSrJqpVc/wX+RxR2Tl51S01+4hCgR4cpcVOnaMB/mGj62Y92UQ71fgzvTf3ffi1rKUtXbzD4KYoGMyrCwAWqKEyokGqoKbYY78QAGFKYsns14D5oJOtlZisQiNV59+OPYXVcVVFmbVEAWLvYWA9D1dRGL51wgaJrC09vsupXu3j3X7u7b01up7UwKwvWq3YJmWRyNKXit1hXCCctAC+b5H1SMpCy5oYUwxRdYuhvjBWLT3zpunVfFjv1xf2hcR9CSJmyWpIgKDp3aRrfETY7Tz+O7m+uxqARqcrN7mxbBWObsYlEXbC/xJO7XKSe0xcw8IgMWnWLjrhwla73smOHQWlGoO8y9YZgHwH01Tpzz+9re/jUIj+7zlIdoHaFsimb+A9ELrBC4lw/W+w2nMKlMZsthM1MMnztRTI2w7E8F98xTqxp/oa1PTELViLT2aQzUqZ8soObsROmb1dR8e7re3BGCrck5ymEVqvxexy2nvsBx3T+2f5qLr7fjyLdvlKj08iSw9NaxzcjpQWgJ4u/CGz9ldJd3yvWGF/C24M4cE3yxH1cLwcb3wJuTeInVeDZghj5EZqmWaFwXgpp2sdkQqSvdsbHOwATdkbbOzVKeczVQOYBeH04u4qI/va73QL7cOCVy2z6GOvSPp+cF5TtP0k0Hn6Vr1Gtqy70Tckz+Y3FSSlozG5rET7dXXljJkALEIMOUy1fEymuOJCGg01bEWDv7CAD428uOQycAmsYem84S387GRWOjxc8+OZRJdIm+gAW583DssMpzeHCh3l4C5SjnK89tGvBZC2N58kpZAb9N4GLVQI9t3PHH4FTYoHEPn9smJXEfH1ymN1TuE609jUk3NAXr9C
 6iw0hYT1
 5gb0gpYXblAQ+rb7Ml3tVuAFMpKzt/Ce51Ck7Bxr8971XuU6/ij2iU77XUy2VrmNLo37dZe+YRD84UZ9/Rn9p4aiStZqjYiOy1eOV9s8U/jdzmXrXnmZX8NCLUK6VLJzJePtTrZWmpt/H1Dxs91fjaoy4RSKJ3s5AS8zZbdBv5W3JbCyZTNmvlEB21CwmRTNLBkAt7qSS3/vHqLcx1qygW9gD9MLrOv1yfTFKHCr1c3rTT5qJxKzyY+z9q/xxjS+skiU1Mu15pBYADBwAx0F6mlyl0Bq1akb5ccbx3YvOZBmtjrotA9MSIJg9RvfBGUEVVJmEFLKlB6nooqv+GrLOWEE4y69aTAyyjTglWZRgMra4CBQyBFRjz8nQCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 15:48, David Hildenbrand (Arm) wrote:
> On 5/20/26 14:53, Mike Rapoport wrote:
>> On Wed, May 20, 2026 at 01:09:04PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> As this is all uffd specific, I wonder whether that should be "struct
>>> uffd_vma_snapshot"/"vma_uffd_snapshot" etc.
>>
>> It's local to this file, I wouldn't worry about namespacing until there's
>> an actual need if it will ever arise.
> 
> Indeed, fair enough.
> 
>>  
>>> From a high level, this LGTM.
>>>
>>> I wish we could identify relevant VMA changes more easily. Like, using a per-MM
>>> sequence counter that we simply increment on any VMA changes.
>>
>> Do you mean per-VMA?
>> Per-MM counter would capture unrelated changes, e.g. an masvise() for
>> unrelated range.
> 
> I was thinking about a per-MM thing for simplicity. If there were any changes,
> we'd retry (-EAGAIN).
> 
> IOW, something like &mm->mm_lock_seq, which we have for per-vma locks already.
> 
> Not sure if unrelated changes would really be a problem in practice (another
> thread gabbing the mmap_lock in write mode until we serviced the fault).

Assume something like the following:


diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 180bad42fc79..608bb3c3a613 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -448,9 +448,12 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
 {
        const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
        unsigned long src_addr = state->src_addr;
+       unsigned int seq;
        void *kaddr;
        int err;

+       seq = raw_read_seqcount(&mm->mm_lock_seq);
+
        /* retry copying with mm_lock dropped */
        mfill_put_vma(state);

@@ -472,7 +475,7 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
         * (e.g. replaced with a hugetlb mapping), making the caller's
         * ops pointer stale.
         */
-       if (vma_uffd_ops(state->vma) != orig_ops)
+       if (read_seqcount_retry(&mm->mm_lock_seq, seq))
                return -EAGAIN;

        err = mfill_establish_pmd(state);


In case there is concurrent mmap_write lock, we'd retry. But we triggered and
resolved the fault. So the retry would just succeed in copying from the page,
not triggering another fault here.

So I'd not expect this to matter in practice?


We'd have to implement &mm->mm_lock_seq also without per-VMA locks. Which
wouldn't be too bad given that Dave proposed a patch set to just enable per-VMA
locks unconditionally.

As a hotfix, what you have is probably better, but a simplification like this
might later make sense.

-- 
Cheers,

David

