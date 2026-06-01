Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD304CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E416B041D; Mon,  1 Jun 2026 11:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1FB16B041F; Mon,  1 Jun 2026 11:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F3D6B0420; Mon,  1 Jun 2026 11:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B24B56B041D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:25:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 596CE1626D9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:25:54 +0000 (UTC)
X-FDA: 84831719028.12.AAAAB07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6EE6412000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:25:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Evw7um1L;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780327552;
	b=jV9D14B5XBJs3jGAwsSEFw9R/0EHhuwRoRp8+StvUL0+sq8bLvlyxUbEHqG9a9DbFDt42W
	WtADeln+Gia/NAg1Cjg8fs6ufEzoKrSLfqZ/eE+OpyaI69NtB3+rx1xToAsU1PeXbRwl00
	Jg2Lbdbx8E23tvgubeQKK7tTdwMQ9tQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Evw7um1L;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780327552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wt1AxhWkdz5vT4IX+aS+7S39jLcDgUB3QRpVfwNb0U=;
	b=fk+0y5NyIjaN7fDHjbSI85jk4bOFFrYBclicVbMq0fhPd2s4FMnBS4K8yIGOCpTuRpVImN
	vNv2/xN7ELNHb344614w4DLCTbd+ewtf5x4UBd/EzAgm4GCUZkbxhgEzzkDefmbPQp3aan
	obp1tyxUKrXhMUOXe/1OpanAm0WgcXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B32942B70;
	Mon,  1 Jun 2026 15:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E841F00893;
	Mon,  1 Jun 2026 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780327551;
	bh=5wt1AxhWkdz5vT4IX+aS+7S39jLcDgUB3QRpVfwNb0U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Evw7um1L70qffU6mAIbK7qY2EAwv6itIIW7jvKm7LzRoN8ezL4Cls8zqSGfGFkaDw
	 NGBS2bv03RJwJw6Hz7zmIpO758fpzurp1JEG/mIBf4AVRyapHhG8QeX7vWsOBNb1yt
	 Sw1LRIzzn6KdAXWwug/OdfFMjcyn3cc0wTGAhDzIWyAaORBpGgZ6KLHVGCa/5kuj2e
	 M1fzD+mw2heTkG6gCKTMj3ZlFxXSID+loWxeGaWXUwZI0RhtFn3ZUY+dSd55tP+tZI
	 TtVnrplbUyLwlMKGqfGQD7g79zVTQpR1PdoHdXvDubNUR9kAB74ViLv5Q/iLG5MoTt
	 bTRFlb7e3JDBQ==
Message-ID: <88aa89e7-aa7e-4abf-babb-a2855bcb3fee@kernel.org>
Date: Mon, 1 Jun 2026 17:25:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/vma: eliminate mmap_action->error_hook,
 introduce error_filter
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1779462249.git.ljs@kernel.org>
 <e770b28427937057fa953ac380a134b24acd8bb4.1779462249.git.ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e770b28427937057fa953ac380a134b24acd8bb4.1779462249.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6EE6412000D
X-Stat-Signature: qtzmdkqn6unxzkzoooee7aikzmtcpqyo
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780327552-543984
X-HE-Meta: U2FsdGVkX18h6bSRoRL4iuPSJMgn3HBImXxq84DbGfRhtu3pPG1UrmADQpCxLGrj1hegg5BfuNxlt1RazGPJNJF5C4dR3Nok6KAEV5uPWLe+AeCUvTSU6TdXDGupZz9h2M+7cvcuk22Nq4j6ZiYNier4RMHsawOg2ZdOOfqP1GD58vyVqjvobfO9RuSbACl7QJibSRiqnHeiGIyazOZSFwRX1aV/RByNemjUfoEWB/iIcuGhrmQXEfXMRlpJF3PlN30H08GhEd3lTx9fKSRvAkfFPb8LqcgNkLVCcQ8+OWsl4Gi99Smaw46MTqcB0aTdmygWBckmCi8h3TeMhoiQ36qhh2b3c24ZX4aRuTAwOAksHPk/ZcyxpRTVevZqJaF+Zz1MdUnIHCUM8Wbz2dcghI4p87GZ3uso1gwK8j51Gwkv/PdV9SZ/ycFA5WjQ+hW3JnE9hwujKqzezQzoNswnRob8Wo1OFuwTPzEI79YlcFidA7ckhYsnwbbEuaODRfrWUeE5RoQc85evBKvPjbY0fsW8fAxWxuTqyn4Dutk8+dBGX6OXrnLsOdzcmkXDBxE66TaAuwifa/7rE+F4yBjgJOr3Od1X1ObnPxPXOWWNqBs7JjvenbJz35xuqTVaF4CFvSlQVoAY/YIxa5oM/J1DAQYB4DXebJ2VRn2Iw5e2IC5URQrWFomVv/qphgZewLrYFJ6PGuYfrItPXRx7F/sFISr6JvBMgjIYY3nZDpooWhlbOjY+56KiFNAXsHj+mGmzBeU9ftaPEBlHljsVuiuzIFxNfkaGtV/zJlHXc1bGfdbYA4+L1fQVCnu7nlV7AW0s73TSLidZQUv/0ApKhxSFIYJHiYe5NsAxlGQ02A7fFSnt9fkD95A+6dRdI5pUyCgLx8XA9GQG2b6VgpynRrE0okJvm5r00frjUK5JXLg4fdAaKCESpsg0c7RhhrdbbhhEeV5zhGhEfHsrOE6gLOA
 WlR3JdTF
 ieFk9VjN2dXTzTe5qRVcfSm5Vej1tDsWUGf5IPg3v8HIcvAyLaYD43fL62Uo5msydd5FEHr7a/x/UKADzvFCYCmbqT7FvC1ZrcHTGSPvAMK5Y0/TuGhpkZ4mLAecsMObTI2iMUpQ3xxR7oL5KWa1qhQlI74e8ZdverPaKJBD+FOPmFs91y1cmnEQ8TIP7ZyPoKYeX+OTy4uznuqQ40WwegZG2jvNBxJtAN65UkLWL9f7QBT4Dpd3foMksZtJDSa5gIZWGaTbgI7VtJFYiSWBK46HK2BZCupsWDIxE76HYfTALz2VOKOecAryUL/ICPdTNcH/DsojcAN9SNTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 18:00, Lorenzo Stoakes wrote:
> Rather than providing a hook, simplify things by providing the ability to
> filter errors. This allows us to more carefully validate the value provided
> and thus ensure only a valid error code is specified, and simplifies the
> interface.
> 
> This way, we eliminate all hooks but mmap_prepare and allow only mmap
> actions to be specified (which core mm controls).
> 
> This significantly improves robustness and eliminates any unnecessary code
> duplication in driver mmap hooks.
> 
> We also update the /dev/mem logic (the only user) to use
> mmap_action->error_filter instead.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  drivers/char/mem.c              |  8 +-------
>  include/linux/mm_types.h        |  9 +++------
>  mm/util.c                       | 29 +++++++++++++++++++++--------
>  tools/testing/vma/include/dup.h |  9 +++------
>  4 files changed, 28 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index a4297eb39887..11639d988e47 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -322,11 +322,6 @@ static const struct vm_operations_struct mmap_mem_ops = {
>  #endif
>  };
>  
> -static int mmap_filter_error(int err)
> -{
> -	return -EAGAIN;
> -}
> -
>  static int mmap_mem_prepare(struct vm_area_desc *desc)
>  {
>  	struct file *file = desc->file;
> @@ -362,8 +357,7 @@ static int mmap_mem_prepare(struct vm_area_desc *desc)
>  
>  	/* Remap-pfn-range will mark the range with the I/O flag. */
>  	mmap_action_remap_full(desc, desc->pgoff);
> -	/* We filter remap errors to -EAGAIN. */
> -	desc->action.error_hook = mmap_filter_error;
> +	desc->action.error_filter = -EAGAIN;
>  
>  	return 0;
>  }
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 945c0a5386d6..8d1fb85e7684 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -844,13 +844,10 @@ struct mmap_action {
>  	enum mmap_action_type type;
>  
>  	/*
> -	 * If specified, this hook is invoked when an error occurred when
> -	 * attempting the selected action.
> -	 *
> -	 * The hook can return an error code in order to filter the error, but
> -	 * it is not valid to clear the error here.
> +	 * If non-zero, filter errors that arise from mmap actions such that we
> +	 * return error_filter instead. Only valid error codes may be specified.

Is that really a filter or rather an "error conversion" / "error override".

"Filter" to my German brain implies that we would ... filter selected error
codes, not convert them to something else?

>  	 */
> -	int (*error_hook)(int err);
> +	int error_filter;
>  
>  	/*
>  	 * This should be set in rare instances where the operation required
> diff --git a/mm/util.c b/mm/util.c
> index 4e172990afcd..9b4e5432d45a 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1414,16 +1414,22 @@ static int mmap_action_finish(struct vm_area_struct *vma,
>  	 */
>  	len = vma_pages(vma) << PAGE_SHIFT;
>  	do_munmap(current->mm, vma->vm_start, len, NULL);
> -	if (action->error_hook) {
> -		/* We may want to filter the error. */
> -		err = action->error_hook(err);
> -		/* The caller should not clear the error. */
> -		VM_WARN_ON_ONCE(!err);
> -	}
> -	return err;
> +
> +	return action->error_filter ?: err;
>  }

Out of interest, why does dev/mem require this monstrosity?

If it's really a dev/mem specialty, you could just make it less generic and call
the property

"bool eagain_on_error;"

because surely, we don't want any more such monstrosity?

-- 
Cheers,

David

