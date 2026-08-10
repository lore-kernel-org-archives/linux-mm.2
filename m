Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D93C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C03B6B0095; Mon, 10 Aug 2026 04:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770F86B0098; Mon, 10 Aug 2026 04:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686E56B0099; Mon, 10 Aug 2026 04:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 466126B0095
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:52:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0D7816032A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:52:27 +0000 (UTC)
X-FDA: 85084743534.08.79EFCA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 27B371A0002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:52:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZvEc+zMN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786351946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ja+bbx5/k6Ur1P7gZyvdceXvb5QS4sd8f7Hohxvn9oM=;
	b=Wyk8WnlXOF0aiDbA3F5m9AvXX2eSNgh9aoXI7QDEZX4sCxvqVLvjprlTDovLIfiwRsN21U
	zu45r8XaukLiZO/6TAFZ0Tj9oW3cwDzW7zf5+sEU7+Ah6PBdGsE1Ob8HS5lfWyorZ6I7Ew
	O9MseXK6q3vTyWCYbszduPs4qb484IE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZvEc+zMN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786351946;
	b=M5PI+aqWzMyxxuXfinVXdDXIl0NrGVlM3Nuofw75p9+yrjMTRqacS/lNNU3n3pWKrCO771
	fS33Q7g6PhGUjT0O/uPf2sHf2KlKEm/u4qmRwcWrormY0FtJ6x+cN2Whm4VLe9nnPRM/G2
	zYiIPK0whh45C0JMtmLaiJi+kGUykJc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E9C5760052;
	Mon, 10 Aug 2026 08:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EA11F000E9;
	Mon, 10 Aug 2026 08:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786351944;
	bh=ja+bbx5/k6Ur1P7gZyvdceXvb5QS4sd8f7Hohxvn9oM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZvEc+zMNW/8pT1cKRhb+nZuoMlg8vdkHd5yuLE0Zg2dtbFRoUlPsDVJq/FLUCnzRF
	 La41lPi+VTuopR4OysD0A1dMw2M42MuSZZUFs+qq6QRzoAVJ0mUkjB/RIUGzYzIxsh
	 8HnQlkioNc97hH//K4APckBNNLx4SsIxHr6LHABqM86ZmR4h3L29Y8b2RA2UHQvlOC
	 H2+Lzf7M60DlULqEK8kb6Tp2a/r4+MEgoErg2PEfESuaO9CQH0rdoZUZ3CBqBcWZMi
	 HLwID1l/RyAc/ZSHUbV8BPFjJ1B3yYzPWmWzkQOMDS7ZpAmVDruN/Q8TbJ3gaIqXO6
	 zlnsg5aWbiGiQ==
Date: Mon, 10 Aug 2026 09:52:04 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@kernel.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, 
	arve@android.com, cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/5] mm: Make per-VMA locks available universally
Message-ID: <anmQIeQIGkZdCKVU@lucifer>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-2-surenb@google.com>
 <anaCkrk55EQoE2aS@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anaCkrk55EQoE2aS@casper.infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 27B371A0002
X-Stat-Signature: skdsgk4tyotdesgoboj1qz9nzhjdcngp
X-Rspam-User: 
X-HE-Tag: 1786351946-101174
X-HE-Meta: U2FsdGVkX19LIxYK8dXRnoi2733Z4cdcH4ubtQkW/JJzYwvutbmaDq1npgqG/5tzdctVhn37wh9dOhPCBATDFYFo1YEYsNuUC1nIx4RaT1XoPbWvhqLUjRxf0BJWsirkhNSyy9pw+2kUYYDyE8hN6y2Vux7BAxJqTWYNQZpRAlOgBUEuTY7ZpglvXZRFtXDKpel5MY1CLsKL9AEC5IjsVCPlPtofWl+mi7PJ+60DDRm4lI8AsN/BjS9vkj1MmyFLiJZGoCFw/9IiZlEh2sYzRXEs9/C/XdTDQrk9EKLb3/AiNLxWC1tyhVjHErfu/2Qmd1F8HXFZcwpRrED9gLnSX1pQIXQ+mF7LZXQNtE+f9VhkcCe43NADwl04SnImh4Ka94qHZe6zzgUx8F1N5EI8EN/ygP3ZvmTtVhrAZZgxALbnIIt9PhW6H0anZ8J6UjOjt8K2ygOh/T53P6JpDRIVtLOKqxEy7Yn96iZykW/9qY3StJ1/mhdqIPFJ+INJmVxyOkF5GZQ3INQHmuYT0iQwxUW8Evyyd6IrY8p4xgh5EEfB14Tohi/ymtXJii7EAeAYSpBH6oTg+l+HfyAq/x0xgVhLXjZG4bUWYsinaOjqzWd/62tzK8YQnPuoNI0R+K3TgqMSHK6mh1dXG9lDjLGSRnKjBW2pQd9xdr1jN1VzrSTVUBbgcbhfUMj0dFycmws3J57+h7iWfWdvudmugO2a4xqOapEOINmzBUZu9kJD3V4QVFVyV69/QKoLfJwKRt3eHVYp6n4Se0fa5k6nCqimhy5qPr70xwp7DxguMDtP/1z5r/Hu/dFpXcOVb5VrtEwJpIj9sbsrQqR4kgAJdS4ZtGUPV3Nb2O4V4hpaiLLC1mJ0GsIsbJ9UxEoybfSMXsyHfKGjMdPn269PwvmbDklP+B3IBCXzHzpiJRfel38Bj/h5tPfv8p7R2Tje6hjjfTa0ZZgIT5m3T2mzCiyBybV
 blRkiVNz
 Lz0Q+izQSA4URiU66VJXM8XmCc0gvrVuTH2Ti6n77cLhHVQO2WdYfyhi2G2PwreBEI8XQNEYcRZkciK0hbKKCgqxCfmjDt9Ng+LERhZVseU6AeTE4sdMu7lB4aD8FNb0FrQk3matpnE+AhPA+y7jLMn29StgFZzRg9zeqrjovdPBI6VIFgS5E58Hc+5mKR/95zOTBLzhM0KPOFHj/rGB9xGteF3zRlKpGQfKQ8wkmbl85OwPmJ+8RqqlXLSL8xkdRiZRM6gk3AFIHvhBkexx4dBv8XNvVWnryCjeI4F74Hto9obEZQ/m3UuXduIvLlQU6BCeQgKzwrJ7qQFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 02:12:50AM +0100, Matthew Wilcox wrote:
> On Thu, Aug 06, 2026 at 01:05:44PM -0700, Suren Baghdasaryan wrote:
> > +++ b/kernel/bpf/stackmap.c
> > @@ -272,13 +272,8 @@ struct stack_map_vma_lock {
> >  /*
> >   * Acquire a stable read-side reference on the VMA covering @ip.
> >   *
> > - * With CONFIG_PER_VMA_LOCK=y this returns a VMA with its per-VMA read
> > - * lock held and mmap_lock dropped, so the caller may sleep.
> > - *
> > - * With CONFIG_PER_VMA_LOCK=n it returns a VMA with mmap_lock still
> > - * held; the caller must snapshot any fields it needs and pin vm_file
> > - * with get_file() before stack_map_unlock_vma() drops mmap_lock, as
> > - * the VMA may be split, merged, or freed after that.
> > + * This returns a VMA with its per-VMA read lock held and mmap_lock
> > + * dropped, so the caller may sleep.
>
> I don't know if BPF is compatible with !MMU or not, but the comment
> is inconsistent with the code.  How about:

<requisite nommu rant>

I do think there are components that simply don't think to depend on CONFIG_MMU
even though they do.

In fact more than think - have run into exactly that before.

It's another thing that speaks to nommu being a legacy barnacle that bashes us
on the head fairly regularly for little to no gain (and nobody is testing it for
tip kernel AFAICT).

</requisite nommu rant>

>
>  * On NOMMU configurations, returns with the mmap_lock held.  If the MMU
>  * is enabled, the per-VMA lock will be held instead.  The lock
>  * should be released with stack_map_unlock_vma() which will release the
>  * appropriate lock.  Once the lock is released, the VMA may be freed.

I mean I suppose it's accurate but I don't love the idea of essentially implying
nommu+bpf is a thing and also treating it as so important that it must be called
out here.

I'd rather it be inaccurate for nommu as are most comments in mm and mm-adjacent
components, it's kinda implied in general. Those who care can look at the code.

>
> >   * Returns NULL on failure, in which case no lock is held.
> >   */
> > @@ -288,7 +283,6 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, unsigned long ip)
> >  	struct mm_struct *mm = lock->mm;
> >  	struct vm_area_struct *vma;
> >
> > -	/* noop under !CONFIG_PER_VMA_LOCK */
> >  	vma = lock_vma_under_rcu(mm, ip);
> >  	if (vma) {
> >  		lock->vma = vma;
> > @@ -308,21 +302,20 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, unsigned long ip)
> >  		return NULL;
> >  	}
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > +#ifdef CONFIG_MMU
> >  	if (!vma_start_read_locked(vma)) {
> >  		mmap_read_unlock(mm);
> >  		return NULL;
> >  	}
> >  	mmap_read_unlock(mm);
> >  #endif
> > -
> >  	lock->vma = vma;
> >  	return vma;
> >  }

--
Cheers, Lorenzo

