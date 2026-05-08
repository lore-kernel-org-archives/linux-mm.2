Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D045ACD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410FE6B0246; Fri,  8 May 2026 13:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2246B0249; Fri,  8 May 2026 13:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF6E6B024A; Fri,  8 May 2026 13:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EFF16B0246
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:32:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAFF916023B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:32:51 +0000 (UTC)
X-FDA: 84744947742.16.30ACE45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4DF2F14000A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:32:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c+eZOWn2;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778261570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvlRlJjkS7+f0793A2cw1Q6gSGolEexX0bZuhdH1mD8=;
	b=M+m95dX5KZniE94IBRrCExsDRojV5pqChwkPU1vI6O98zteDJ3Iujta/9RwwzxmgLKMewD
	Og6R507t1T7LuqAw/mop565DwEoG2p7nX5GNwXwtbAiYuhIPt2cHdNm0xDUcCD3m4hNX2m
	t7UyS5kQFz2yOyf0l4dHjRJNUqn/HwI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c+eZOWn2;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778261570; a=rsa-sha256;
	cv=none;
	b=7EwRtg+x+G4+dUAOMfmrro6p4Z+JrKqK5NSRbsMvW67KUflfF5I647mX4kjtk5yJh+Oblo
	bsBoIlvWiHUXRmpt35RbPV5lsYiZ7HqkrlUs/mOL5UfpplvIWIcHlv9VLsszNhGGMpF5/m
	g761qECGo3BK52Jz/2MO/N/+r2cRyOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B712460052;
	Fri,  8 May 2026 17:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425ADC2BCB0;
	Fri,  8 May 2026 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778261569;
	bh=CVZ2Lu2w6060hpJnLG6IemuNJfvzKhd0qIeDWWA2eC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c+eZOWn27yCrRXqrrso0FMm56AyZ5fMd391l5nCDm7XuPy9LJJevh3Ygcp5cf0PyV
	 NRFjJnjpx8tUoC5v4HShthRJDS6n4To0KMQVYN/bX99A7LupxrjRV0aAReO0Qiamiw
	 k0bcNNlzhQFg+o2bjXfjdErp45eaFO9YrZZ8X4fERe56pU9KlJuIFnbE9g0Sxn1au0
	 F7Vk5tV0YsedgoRvaxYFTawECW3gc+gaOdh9tvVO6NroGj1AI0t8OT1zXPTUrMDDjs
	 z9pPq4WKqn1921SQxdegO2XGen7oF2reAeCB3qpiHe8U2EwngCcUhMqEUruzoSV8/a
	 eTh1V3Siz8xxg==
Date: Fri, 8 May 2026 18:32:43 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 5/6] tcp: Remove mmap_lock fallback path
Message-ID: <af4dkMq5D1wZk1pP@lucifer>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429182002.BB61C7BC@davehans-spike.ostc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429182002.BB61C7BC@davehans-spike.ostc.intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DF2F14000A
X-Stat-Signature: 37xxotmn1y8pf34jt1okmhry4t4qiuno
X-HE-Tag: 1778261570-854848
X-HE-Meta: U2FsdGVkX1/jnKeN5kL4DjWqh808ALEkG1Fj6oP/9PtlQPY2UcCBe56YSiAFRfEDekrv4gvSiVzVCdvhI3TjL/wnDI2pDnJdsK+xyEoMl0f9JkgLrL3yo5pwnKZxGaMjyrUjgU1GuCvQmgVfeZUB4qudAOsPxRWSqaF6MklD9GhmovQNtL7Xc+VjYfgNVZIkqnw9/wnxi8kQfZp9VXfPsf8PyvS29mXAs/WdatYS0tV4D6p2MtXRDW/5wm7FwbeE5xvgmKFWRVzQWXhTEIaaG/Peo0Bm+bWR9/OsDnp/R8PGq2HjmErRP+GsgKz9t9fwZPk2EN81Ji9JwyutxFuhtb9pCZMKd2cXThuVEtOWQ8usIAOJCT1stAJJDkLzK/+icycYLpOScZRmVNfcQM74bPQlE+lQzTiyx/K/8k2f3V3hDfG9w3dVOFuV+hFIyb/AO2hviZAm/sLjn6UC7OwJz9kFc4arLcLZPU+kpeaQQ36VMqUDguIrzfbTqH3ZxW5tvqTwPPntvBNX9nMA543VuEnHsrpa6fAtbdwKTx7BlQ1Qe2dN1XWtdYqGIj2wr5DFRa5qd82JJ038mX2Js3jz3+HC/TjiHReimmVD2+GqVO3o4/QE/hLhJOCsNr5TiOev9EZBW6K9MM7GvgGr7lJsbvWEJVrSx9LK21E9c0Kof+bExtPH/OwFw5yKM89Ny4wdF8c4+7K6mkbV1+DCCFzfHWxekNeq18mQu46RKdeESQv7fY+I2iXt+8+7V43hQf/Dr8pQDSN9JGPN65pCYYGmTL6eCA3LXTGTv2p3L9ZO2MOEcIOOSG35xZYildSjPzdLIaBFZ4F0RqQpoXj53fyJltPqsp135nSi/4Fv0EILOsOtL6oonmRI4VwXue/fU3Um9oY4ec7E+qBS94bgs4A9zm1i3eGXdEVQGozWhq7sY0PhnnzMHow2RoOcNf288pTwA/v/q3QaZ3nQPIORRzu
 G8hRmewP
 VgwGH1O7e8nNXaCit+zWtrJotVSAJ7h+6/wmqRG0dSP1MuWiorPJ6wpBTydEJ5PAkFZ71bzWcX7rxvtiwd6RksqaWcBx8JZaMmLGaDnhKZVRDQN/nAef5+JLTUkKxMN5HJxVALldwnOgU+i+OArNwg0cq6skh/3RTe8pWnrMWzHggxvbJULE76nEIi2wkz7gAqHccB5vAtwD0WccB64fEaz/uEO6EzxVUXHjCfhOePwzS9LbaB/POU1/HrNgX6BMwF/X+6wZ+54cnJYtlsIhxeMr4QtHi0WaXglt+6JBhHUhGTBBeMV3VFIP8ERkyjrissgA0Tjo51HUel5xVAuioVZOCGaqZ3rpGSZi4juufbZTHUZ8ZaSnlkpNuFyRq8ei7MNIe12vWPATyCiOWNKmtCiNWC5zM1w4CkDtbQIHD4ETDTBaMmt6njh5VVvX97rQmf5CB8hedMk+fdO5ovu2b2fUjQIjAkj3zFXHaNv8E6detvT3I9x2rizNTN2NROxZowD9K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:20:02AM -0700, Dave Hansen wrote:
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> Previously, the per-VMA locking could fail in the face of writers
> which necessitates a fallback to mmap_lock. The new
> lock_vma_under_rcu_wait() will wait for writers instead of failing.
>
> Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
>
> This really is a nice cleanup. It removes the need to pass the lock
> state back and forth to find_tcp_vma().
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Yeah, LGTM again, though am not a networking guy so:

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> ---
>
>  b/net/ipv4/tcp.c |   31 +++++++++----------------------
>  1 file changed, 9 insertions(+), 22 deletions(-)
>
> diff -puN net/ipv4/tcp.c~ipv4-tcp-vma-waiter net/ipv4/tcp.c
> --- a/net/ipv4/tcp.c~ipv4-tcp-vma-waiter	2026-04-29 11:18:51.870676498 -0700
> +++ b/net/ipv4/tcp.c	2026-04-29 11:18:51.874676652 -0700
> @@ -2171,27 +2171,18 @@ static void tcp_zc_finalize_rx_tstamp(st
>  }
>
>  static struct vm_area_struct *find_tcp_vma(struct mm_struct *mm,
> -					   unsigned long address,
> -					   bool *mmap_locked)
> +					   unsigned long address)
>  {
> -	struct vm_area_struct *vma = lock_vma_under_rcu(mm, address);
> +	struct vm_area_struct *vma = lock_vma_under_rcu_wait(mm, address);
>
> -	if (vma) {
> -		if (vma->vm_ops != &tcp_vm_ops) {
> -			vma_end_read(vma);
> -			return NULL;
> -		}
> -		*mmap_locked = false;
> -		return vma;
> -	}
> +	if (!vma)
> +		return NULL;
>
> -	mmap_read_lock(mm);
> -	vma = vma_lookup(mm, address);
> -	if (!vma || vma->vm_ops != &tcp_vm_ops) {
> -		mmap_read_unlock(mm);
> +	if (vma->vm_ops != &tcp_vm_ops) {
> +		vma_end_read(vma);
>  		return NULL;
>  	}
> -	*mmap_locked = true;
> +
>  	return vma;
>  }
>
> @@ -2212,7 +2203,6 @@ static int tcp_zerocopy_receive(struct s
>  	u32 seq = tp->copied_seq;
>  	u32 total_bytes_to_map;
>  	int inq = tcp_inq(sk);
> -	bool mmap_locked;
>  	int ret;
>
>  	zc->copybuf_len = 0;
> @@ -2237,7 +2227,7 @@ static int tcp_zerocopy_receive(struct s
>  		return 0;
>  	}
>
> -	vma = find_tcp_vma(current->mm, address, &mmap_locked);
> +	vma = find_tcp_vma(current->mm, address);
>  	if (!vma)
>  		return -EINVAL;
>
> @@ -2319,10 +2309,7 @@ static int tcp_zerocopy_receive(struct s
>  						   zc, total_bytes_to_map);
>  	}
>  out:
> -	if (mmap_locked)
> -		mmap_read_unlock(current->mm);
> -	else
> -		vma_end_read(vma);
> +	vma_end_read(vma);
>  	/* Try to copy straggler data. */
>  	if (!ret)
>  		copylen = tcp_zc_handle_leftover(zc, sk, skb, &seq, copybuf_len, tss);
> _

