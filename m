Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D93BC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D606B007B; Mon,  3 Aug 2026 12:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6FA6B0088; Mon,  3 Aug 2026 12:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A795C6B008A; Mon,  3 Aug 2026 12:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6F76B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:24:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCF1AA206D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:24:44 +0000 (UTC)
X-FDA: 85060481688.10.20BC0D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 270CB40007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMIaew9z;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785774283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaWM6XXtJGdQmUu+RcuODJPgGZbx++WzLFBvcXy6xMo=;
	b=mecfq7kyJ4c3CrDnzszvfFcDw7hFSFD45WIIiTx/ef48b7rihwTtQzkgXTrqfNFwA5xlzN
	ewDKPwds0IEXx+rGrjYblDapxNVevHuc5Fce9sekIM7CEb7j9tD8tATWv43dz9NNO7z/fT
	Fd8h/Tx/VE3fkReClZ0Czq/zylZ8nrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785774283;
	b=WnnLccIushqOaiUXmlQFH0uFzGM4gmXy1dUC7wmq8LoY9QR1FP7K4EbjAlKoLGmaWwxcgt
	dXOaWZWeAPq3akGaYX1IRDkUag+tNCc1qt31sIRhWxnOXX120ea15VbweSzjdRl5kZ40K5
	ULz8ghIiSBSMNW/vsa7m/93nFNGaUCI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMIaew9z;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D270C60A79;
	Mon,  3 Aug 2026 16:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C15A1F00A3A;
	Mon,  3 Aug 2026 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785774280;
	bh=UaWM6XXtJGdQmUu+RcuODJPgGZbx++WzLFBvcXy6xMo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RMIaew9zOxzKi0Y3dMz/0IBcJIzmZwS7Xhcx9AB7kpMqm85gpkVKkdP/kwf6IpTgd
	 oOJDyJ3iqF94C/6XN9A0xmh9d4EnC2VcZ2OHujhkh89rLu7I8bpbHRxwDxaM2qW98S
	 YcVHVyqORyu5xwQxU4GYvxbb5pg7dj0khCyUvPOuy3cG5oWud5h0blNdVZxC7vn+9k
	 RTns84a8LU7KHif/ELVMPszx/NXl3z8WVoMQ2F7Kg0nM839g0WGD3GJUuc/lUl77tc
	 uBU2+HK8Zms/38xhMS78WJr4rPnoUnvSdPB9LFZalIvY1Se5rWh5scUqxCQAI2uuRt
	 f/RK+3dMm9zOA==
Message-ID: <9c301dd5-76cc-40dc-bbab-a79559d6db1a@kernel.org>
Date: Mon, 3 Aug 2026 18:24:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] mm: Add RCU-based VMA lookup helper that waits for
 writers
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
 dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@redhat.com,
 willy@infradead.org, shakeel.butt@linux.dev, jannh@google.com,
 aliceryhl@google.com, arve@android.com, cmllamas@google.com,
 christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
 davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-4-surenb@google.com>
 <152ee467-b5e4-470c-ad95-c638aa9986bc@kernel.org> <anCst8u7ybHf39n8@lucifer>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <anCst8u7ybHf39n8@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ikenby7h3ps4o1y6w8g4o48djebyr9u9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 270CB40007
X-HE-Tag: 1785774283-300958
X-HE-Meta: U2FsdGVkX1/49WqMRBj0VKj5VX4ga8TpD2T3dC+LM6xib+s0BNmG/TkNVs0ismAaYa+1jyhu9uYCFOFiB2Ndw3fIJsOytz3vRl98Z2swELZDlojgJvZDV8jx/LXaFjT8cpR+XPi8cAIFJhxN0b7gAvCTvN6c8yv5WIWDzfwhqneWMzSv2o2YG5nRPIYrX3KL0HW+hCIWpexRL7wzDzDAWXJXoLgcRfQDMtqea4aycAJDPiX7PLlwY5QnTQMtcMIGk3oQSlNfgalPppJI25l34zI+4pQMPbQC/p9OKJMhAM7lKDh4/qdb2mYZq2mFyr6ycfGFGGZGQdciH1x1V0QiTi2d35DMhZgdJV+Hujm2u2wM+UZvutta4l9knquPsxt6kBPe9e+s5l/3DOYDFTiIFhW0qD9ThQLjNkMXcdy2ZVt/hHmzoUw9PSMEFGnm+E4bRw0enk96bFEnpSTLpM5HVmn+eQ78zG5PiMAzlf2pEkjXkEIvdPJJdT2y2b5vro4WoRWCKohsf4b7Kq/FEEF5t7fVEmzf0AywZGouyGZeEgiuZC2Ej3FF4BdsMPaCF/C7kqnEJySI6FaaMWfxnVe+71YzURZkk5z/5FaJ8k7PtAPznMDTHeTQLhFlXURlacx2qKDyEXQd+YU2GRHVrAuJs0tJviOmz6DmENg3s/iZOH9AiANaIbJUDnpVWIcU41Pf0bO5plGadHmokql90gCVSO9bT06XpE7RrH2nPR94egm+C3+8xQm8oarxbMOc09f+wbpKeK0ZzOePvsNL1nQJvcdxnRotnf2rXlLA/3qjmOlulJKPjxj1mS0uAmR+p2tC9Wbck2keQOcgabh/+1WdsqjgrB13VIT7+o1x96qA9AoAx3Vyf6ilsFfvL3qRYlbe3W3Uvs7L7f3NtWfhLa48zBSbA40v31UwUk25AIb+MzuMBc2AP1ZY9DwkpTBy5Q3X3mylNq+UTFFcQhURdba
 Opw4pjYK
 6lR3oMV67QATVCh3GE1fBEXXsdroyzA+aLLUxeVm0lSshSDibM/7TzAe/1+dCN7SD4uLmhnZX42vf8BTMPUWcnbyi+X/0Cp+532aoGzj3xuaS8FqDztfDpdcZe/+ah7m+jWj7R23qfLec5twrPd7rmo9JElova5kYAEi95JMj0HetYfXHqhKVDkXyr993Z5uEmuDnLQ9BmQvVXb4NGAos/7mogorWoKCinvjPXkjtQQB/dsA5c9ZVVPauIyFjYqIoiEXh1YV93UILxrMQy4eRHg6BwcWp5NF5zA0WOuy7247azNjlAHeNGydGnamDDlfc5/Npr1lnWnTjisHjldSC8k/MDL/TEtSnXgRTIj8UtkMge7BYGswPuf3l+Z7qqJ2TY2KbVnGfS8b1Av0nWXbnj+K9YEEO6yejYXjrmZLovdXN5ihL2YOyGtacVkB/u9a0+HSyJ5t4hBnBsZ2ODRQBq7hL2N2T0LJk55fsNAvufxhxS8/9NmM1GeUFPdej/VN1W/7mu963VwUk3qQzka6Z/QSR189bG5f0hr+muvcdcIL0zRNLxZ3VoJnyTL2DoswBJWhzyE88dUJoTq4Rq0pU3SAzHSST1mOHUZ35YEfddjI35yHYZoKfTh6bbDj4GAPsT2+xk9RkPrjZ/iDSQYd7n6SxDFgwbse38GtqqWzKNT/Mmy8OYlKBADSSPRsUTS44z+aYK6WxhrbT/c4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 17:00, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 04:55:19PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 8/2/26 23:54, Suren Baghdasaryan wrote:
>> > From: Dave Hansen <dave.hansen@linux.intel.com>
>> >
>> > == Background ==
>> >
>> > There are basically two parallel ways to look up a VMA: the
>> > traditional way, which is protected by mmap_read_lock, and the RCU-based
>> > per-VMA lock way which is based on RCU and refcounts.
>> >
>> > == Problem ==
>> >
>> > The mmap_lock one is more straightforward to use but it has a big
>> > disadvantage in that it can not be mixed with page faults since those
>> > can take mmap_lock for read, which can deadlock when mixed with nested
>> > page faults and parallel writers.
>> > For example:
>> >
>> > 	mmap_read_lock(mm);
>> > 	// Another thread does mmap_write_lock().
>> > 	// New mmap_lock readers are blocked.
>> > 	vma = vma_lookup(mm, address);
>> > 	// This deadlocks on mmap_read_lock() if it faults:
>> > 	copy_from_user(address);
>> > 	mmap_read_unlock(mm);
>> >
>> > The per-VMA lock can be mixed with faults, but they can fail and need to
>> > be able to fall back to the traditional way.
>> >
>> > == Solution ==
>> >
>> > Add a variant of the RCU-based lookup that waits for writers. This is
>> > basically the same as the existing RCU-based lookup, but on a failure to
>> > lock it temporarily takes mmap_lock for read and waits for writers
>> > to finish before locking the VMA, dropping the mmap_lock and returning
>> > the locked VMA. This has some advantages:
>>
>> Maybe mention that the helper is called vma_start_read_unlocked()?
>>
>> >
>> >  1. Callers do not need to have a fallback path for when they
>> >     collide with writers.
>> >  2. It can be used in contexts where page faults can happen because
>> >     it can take the mmap_lock for read but never *holds* it.
>> >  3. Its fast path does not require taking mmap_lock for read.
>> >
>> > Basically, when applied correctly, this approach results in faster
>> > *and* simpler code.
>> >
>> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
>> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>> > Cc: Suren Baghdasaryan <surenb@google.com>
>> > Cc: Andrew Morton <akpm@linux-foundation.org>
>> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> > Cc: Lorenzo Stoakes <ljs@kernel.org>
>> > Cc: Vlastimil Babka <vbabka@kernel.org>
>> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
>> > Cc: linux-mm@kvack.org
>> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > Cc: Arve Hjønnevåg <arve@android.com>
>> > Cc: Todd Kjos <tkjos@android.com>
>> > Cc: Christian Brauner <christian@brauner.io>
>> > Cc: Carlos Llamas <cmllamas@google.com>
>> > Cc: Alice Ryhl <aliceryhl@google.com>
>> > Cc: "David S. Miller" <davem@davemloft.net>
>> > Cc: David Ahern <dsahern@kernel.org>
>> > Cc: netdev@vger.kernel.org
>> > ---
>> >  include/linux/mmap_lock.h | 15 +++++++++++----
>> >  mm/mmap_lock.c            | 29 +++++++++++++++++++++++++++++
>> >  mm/userfaultfd.c          |  6 ++++--
>> >  3 files changed, 44 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
>> > index eb32b482434e..fdd8f5cf5722 100644
>> > --- a/include/linux/mmap_lock.h
>> > +++ b/include/linux/mmap_lock.h
>> > @@ -228,10 +228,12 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
>> >  }
>> >
>> >  /*
>> > - * Use only while holding mmap read lock which guarantees that locking will not
>> > - * fail (nobody can concurrently write-lock the vma). vma_start_read() should
>> > + * Use only while holding mmap read lock which guarantees that vma lock is not
>> > + * contended (nobody can concurrently write-lock the vma). vma_start_read() should
>> >   * not be used in such cases because it might fail due to mm_lock_seq overflow.
>> >   * This functionality is used to obtain vma read lock and drop the mmap read lock.
>> > + * VMA can't be detached while we are holding mmap lock, therefore in practice this
>> > + * function can fail only when there are so many readers that vm_refcnt overflows.
>> >   */
>> >  static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
>> >  {
>> > @@ -247,16 +249,21 @@ static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int
>> >  }
>> >
>> >  /*
>> > - * Use only while holding mmap read lock which guarantees that locking will not
>> > - * fail (nobody can concurrently write-lock the vma). vma_start_read() should
>> > + * Use only while holding mmap read lock which guarantees that vma lock is not
>> > + * contended (nobody can concurrently write-lock the vma). vma_start_read() should
>> >   * not be used in such cases because it might fail due to mm_lock_seq overflow.
>> >   * This functionality is used to obtain vma read lock and drop the mmap read lock.
>> > + * VMA can't be detached while we are holding mmap lock, therefore in practice this
>> > + * function can fail only when there are so many readers that vm_refcnt overflows.
>> >   */
>> >  static inline bool vma_start_read_locked(struct vm_area_struct *vma)
>> >  {
>> >  	return vma_start_read_locked_nested(vma, 0);
>> >  }
>> >
>> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
>> > +					       unsigned long address);
>> > +
>> >  static inline void vma_end_read(struct vm_area_struct *vma)
>> >  {
>> >  	vma_refcount_put(vma);
>> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
>> > index e20d01e8d38f..6ff05e68e61b 100644
>> > --- a/mm/mmap_lock.c
>> > +++ b/mm/mmap_lock.c
>> > @@ -338,6 +338,35 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>> >  	return NULL;
>> >  }
>> >
>> > +/*
>> > + * Find the VMA covering 'address' and lock it for reading. Waits for writers to
>> > + * finish if the VMA is being modified. Returns NULL if there is no VMA covering
>> > + * 'address'.
>>
>> Hm but it can also return NULL when vm_refcnt overflows, in theory.
>> Should we also return -EAGAIN (like uffd_lock_vma() below), or just retry in
>> here and hope for the best? The latter would be simpler for the users.
>> (AFAICS due to VM_REFCNT_LIMIT we never end up triggering the refcount
>> saturation)
> 
> The problem is everything's unlocked so 'didn't find a VMA' doesn't really mean
> much more than 'something went wrong' because hey maybe if you check again now
> you'll find something :)

Well there might be use cases where you know that either there's a vma with
your address and then you need to do something with it, or there's not and
then you don't. And it can't suddenly appear after you check.

So in that case treating that spurious NULL as "there's no vma so I don't
need to do anything" would be wrong.

The usages in 4/5 and 5/5 seem like they are not this case though. So it's
fine. But perhaps worth just mentioning it in the comment then.

> So I think this might be a feature more than a bug, especially given overflow is
> not exactly likely.
> 
>>
>> > + *
>> > + * Use only in code paths where no mmap_lock and no VMA lock is held.
>> > + *
>> > + * The fast path does not take mmap_lock.
>> > + */
>> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
>> > +					       unsigned long address)
>> > +{
>> > +	struct vm_area_struct *vma;
>> > +
>> > +	/* Fast path: return stable VMA covering 'address': */
>> > +	vma = lock_vma_under_rcu(mm, address);
>> > +	if (vma)
>> > +		return vma;
>> > +
>> > +	/* Slow path: preclude VMA writers by temporarily getting mmap read lock. */
>> > +	mmap_read_lock(mm);
>> > +	vma = vma_lookup(mm, address);
>> > +	if (vma && !vma_start_read_locked(vma))
>> > +		vma = NULL;
>> > +	mmap_read_unlock(mm);
>> > +
>> > +	return vma;
>> > +}
>> > +
>> >  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm,
>> >  							    struct vma_iterator *vmi,
>> >  							    unsigned long from_addr)
>> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>> > index edd90892f8cc..c3a0c38a3dc3 100644
>> > --- a/mm/userfaultfd.c
>> > +++ b/mm/userfaultfd.c
>> > @@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prepare_anon(struct mm_struct *mm,
>> >   *
>> >   * Should be called without holding mmap_lock.
>> >   *
>> > - * Return: A locked vma containing @address, -ENOENT if no vma is found, or
>> > - * -ENOMEM if anon_vma couldn't be allocated.
>> > + * Return: A locked vma containing @address, -ENOENT if no vma is found,
>> > + * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma refcount
>> > + * overflow happened due to high number of readers and the caller should
>> > + * retry later.
>> >   */
>> >  static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
>> >  				       unsigned long address)
>>
> 
> --
> Cheers, Lorenzo


