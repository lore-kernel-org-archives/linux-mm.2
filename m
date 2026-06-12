Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3637CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82006B0005; Fri, 12 Jun 2026 14:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32A66B0088; Fri, 12 Jun 2026 14:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21186B008C; Fri, 12 Jun 2026 14:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BFC036B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:00:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B417120211
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:00:33 +0000 (UTC)
X-FDA: 84872025546.12.0E269EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 74D8F20005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:00:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7U8bB7R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781287231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0noTcRNyUy73IbfdopzjHumsVBr2v5V38UCY07mEA6M=;
	b=RaUI1Zzz8QqdtBEdgU7yrXDMtLhajN1vf6nIM5e9Jigw0zgxtgjAVSyCb7u+86/zk+Z+S8
	vrHOeNBTH056LFQ03rZ485rJh/Xsu9ZDI+a5FrQ500racjZyy2yKmPXKM/joBAiQPcPBXd
	5TCEoIQjwppQ+adseXksRXxX7am8DoE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7U8bB7R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781287231;
	b=6AApuoI6AcxI5T//boqAcWFv2y3Fd8JNC245fPDBQUVlqoTdk94tN0j+RxtKnKuDxCzz06
	gnyl2dORddFp57enh8H6SiGPPjGSigVkoJa4Vr3MsnjI33PwhoWVZgsyW7tAzA4alm4yD6
	E1Z1Z0d1TWnd2bCD1BHf3Z2pBCv7QBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 718DB4403B;
	Fri, 12 Jun 2026 18:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8D71F00A3A;
	Fri, 12 Jun 2026 18:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781287230;
	bh=0noTcRNyUy73IbfdopzjHumsVBr2v5V38UCY07mEA6M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i7U8bB7REAw8r3svcGM5BIjC9+ZJ0BEJiSBO8FPOH/RJCKtQZPQGy8IeHZKcsXZSe
	 pYye9f4LkCVCombP2E/jL9LSyZNbSUM4OO3BZ9dDka3KXfn3uJ9GVEFvHesX6AP9bT
	 +iGFN+FxBOBCZUrHfb7jZh5esiFywJRo/WVimkm7021//8D3aQ3rdlK41ZHEOP4iK9
	 GT479ioDW9bjYtEHIstlQ++uV0zVmSRaCTAK3mx2n1o7MKhEzM2jJq4pQMAsvnt+zZ
	 UlBSk+9vfx5lfLJSdFBh5fhkMRSJbTk2HTwL5F19M4RQXRmYTyAo9Q7LbZGIgMmuOK
	 7OO+drbPJcJwA==
Message-ID: <5b27d22d-a3fd-4267-b63b-5de9e6586d5e@kernel.org>
Date: Fri, 12 Jun 2026 20:00:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm: Add RCU-based VMA lookup helper that waits for
 writers
Content-Language: en-US
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?=
 =?UTF-8?Q?g?= <arve@android.com>, Carlos Llamas <cmllamas@google.com>,
 Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Todd Kjos <tkjos@android.com>
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230415.C0521C88@davehans-spike.ostc.intel.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260610230415.C0521C88@davehans-spike.ostc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 74D8F20005
X-Stat-Signature: juyapgwc9r58ozmdhsts3ynjirt6dgfj
X-HE-Tag: 1781287231-255955
X-HE-Meta: U2FsdGVkX18G/4iu+ELaAXnKn17QuD3tvNkysXtA7nPXJ4P8JgNKjKYMpJugXmSlwgfCkBS19D/sIyYog/YkTBVIgQBczdYLR4Yj4YskE9zxWLlRP+QxUv2O/5UIKOb/H1ocB/JWlkj2cf45nRtu5pJH5L6xv2u4zEDUmKd3Jxj6G34E3vt3wbRDW285/7N1bJRy2dRvGJ8sJLSleUkMvDHibidLN2STgZZn/aigTAPQYwbN6gajEKdIuosDCMvgngz+cFKuMIOgBU+4FFlo6vWd9yVvavRstD5YeJcwJQ0Yft+uXq+YorBEpFe4NQd47CAg+nFe8TsXDzj8ZhIgLOfOgirzDasacUskcd6c3icmOQgkzLQVwP1yCSTfaFHLmEOuqOlSRXK8KTL0Qg+bhwwhjoTPosmpkOKjBRO+vKarYC8xKTfcKfCJZKZnlffinUg6DTvDc4TFb53FqC9V5wBplZAMpGpKOCapHksADQd3O9wYK9sN7QXkmk3Va9FCDSpQW8//305vjKq+0jsl0SMKYwX1PPkWP40aQ5Hbfeqq4ZiDSUpf1Z9vXeGlzKzHNap6r4kHcwofGmC9KkF/xX3h+FHS83lbtXAuckBpvaL5PQF7AtfBrY7ddHF8nHrWnLVPEFLmEDVaJYwQ4otbywn/64svKbPqk9A/gKCrhcqjcef5Hj+vCAsYyQgVqudj0EKqsA79d+oNIuuldb/wx0BGPPdSwVM2WkixXNIaoRSgntNYQDnnkOiJ6o3VpSkwxvIC1rVf3g8JhOFixHJUXmjwBrufgvHzm9KfBOwCjCw78uB4SRZUHj6GCcxv74Rr8peSqmmg31j45fXpnFPCMp+WwZoT5CeNRlb0VIiGzrUx/c9+eHLwWfXbqVoF753oqT23WkuiD3Xm2xtw4jXoWdcPLtrM/o4siYr+KmaKsl5X2FKE41KrJD3BkXPb8d/VNhgimOmux5o+FCFJW3c
 oyXlziKo
 9/6M7GTTRTNfdlA2eGogGvXgs74rrQaDE69fEnmzOpVbIkF4tUtodWgrng2Rtdt/E2kt0PGTRBD7GyHU9HV7BgbK9fncykEJjMToMo5vGoeleq0Zd5MJIvOFWt0kHegPwux+A6/uWexEiTPL809RW84Ovb0fFw8SR6/pDcseoGMx5z4k15J2fmsiKpf4MY0k7ehcVMQXsjBZzM8b8/Eu5wEtW+DpE226kM4S/PrKHUn3HWp+n0/gXzO3fSQEFfPTO3czc6iH25EVipj74HdwbFsJU+/CzE5Is8NXDz0/xSs5WIYh4+YNGDQ1HJXsN4a4FJn1kBFz3y/g/mRPu06GIjRTXWqiBvweFVIx/EFG5BkurBuyGJJ0b7ZKEMLpjyl7wA18sElEc80Wrn4qJJX0SHEsqvEGH4yHS8Eb7UrTFRAjKiLu++etY3XcI0D+JaQ9bxhjkIkB8DC5giGDR2dYFxrTkfU3ohnF4zQWzRMYG0KximKqbg0KrxhMiqsntJRO4Zhfj/D2yLgaqvP+U4c9gEFfrjA1ui+h2pxpu8IIvnc2dPT2BBbdeSmjKXMxx6N9q1acf5XZ5NlCNd7p1WjCEYItzC9ses7ryyovF53I7WR6wGukJfv1xWPWNPjRe3yO1yuuR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 01:04, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> == Background ==
> 
> There are basically two parallel ways to look up a VMA: the
> traditional way, which is protected by mmap_lock, and the RCU-based
> per-VMA lock way which is based on RCU and refcounts.
> 
> == Problem ==
> 
> The mmap_lock one is more straightforward to use but it has a big
> disadvantage in that it can not be mixed with page faults since those
> can take mmap_lock for read, which can deadlock when mixed with page
> faults. For example:

... mixed with nested page faults and parallel writers, perhaps?

> 
> 	mmap_read_lock(mm);
> 	// Another thread does mmap_write_lock().
> 	// New mmap_lock readers are blocked.
> 	vma = vma_lookup(mm, address);
> 	// This deadlocks on mmap_read_lock() if it faults:
> 	copy_from_user(address);
> 	mmap_read_unlock(mm);
> 
> The RCU one can be mixed with faults, but it is not available in all

I'd stick to the per-VMA lock term than "RCU one"

> configs, so all RCU users need to be able to fall back to the
> traditional way.

This is now an obsolete statement as patch 1 makes them available? But the
problem is that they can fail and using mmap read lock as a fallback in a
simple way has the above issue?

> == Solution ==
> 
> Add a variant of the RCU-based lookup that waits for writers. This is
> basically the same as the existing RCU-based lookup, but it also takes
> mmap_lock for read and waits for writers to finish before returning
> the VMA. This has some advantages:

I would stress the part that the mmap lock is taken *only temporarily* to
wait for the writers and ensure we obtain a per-vma read lock, and then
dropped again? As that's the main trick IIUC.

>  1. Callers do not need to have a fallback path for when they
>     collide with writers.
>  2. It can be used in contexts where page faults can happen because
>     it can take the mmap_lock for read but never *holds* it.
>  3. Its fast path does not require taking mmap_lock for read.
> 
> Basically, when applied correctly, this approach results in faster
> *and* simpler code.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> 
> --
> 
> Changes from v1:
>  * Add a comment explaining that this can not be mixed with other
>    per-VMA lock or mmap_lock users. It is prone to deadlocks if so.
>  * Add a FIXME about making the mmap_read_lock() killable

I don't see it anywhere?

>  * Add more chaneglog bits about the possibility for an infinite goto
>    loop.
>  * Adopt vma_start_read_unlocked() implementation from Lorenzo
> ---
> 
>  b/include/linux/mmap_lock.h |    3 +++
>  b/mm/mmap_lock.c            |   27 +++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff -puN include/linux/mmap_lock.h~lock-vma-under-rcu-wait include/linux/mmap_lock.h
> --- a/include/linux/mmap_lock.h~lock-vma-under-rcu-wait	2026-06-10 15:57:55.828431712 -0700
> +++ b/include/linux/mmap_lock.h	2026-06-10 15:57:55.834431925 -0700
> @@ -257,6 +257,9 @@ static inline bool vma_start_read_locked
>  	return vma_start_read_locked_nested(vma, 0);
>  }
>  
> +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> +					       unsigned long address);
> +
>  static inline void vma_end_read(struct vm_area_struct *vma)
>  {
>  	vma_refcount_put(vma);
> diff -puN mm/mmap_lock.c~lock-vma-under-rcu-wait mm/mmap_lock.c
> --- a/mm/mmap_lock.c~lock-vma-under-rcu-wait	2026-06-10 15:57:55.831431819 -0700
> +++ b/mm/mmap_lock.c	2026-06-10 16:02:50.723860779 -0700
> @@ -338,6 +338,33 @@ inval:
>  	return NULL;
>  }
>  
> +/*
> + * Find the VMA covering 'address' and lock it for reading. Waits for writers to
> + * finish if the VMA is being modified. Returns NULL if there is no VMA covering
> + * 'address'.
> + *
> + * Use only in code paths where no mmap_lock and no VMA lock is held.

I think we have various asserts that could be used and are stronger than a
comment ;)

> + *
> + * The fast path does not take mmap_lock.
> + */
> +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> +					       unsigned long address)
> +{
> +	struct vm_area_struct *vma;
> +
> +	/* Fast path: return stable VMA covering 'address': */
> +	vma = lock_vma_under_rcu(mm, address);
> +	if (vma)
> +		return vma;
> +
> +	/* Slow path: preclude VMA writers by getting mmap read lock. */

Again I would say "temporarily".

> +	guard(rwsem_read)(&mm->mmap_lock);

Aside from the missing vma_lookup() I'm not sure we should also trust the
result of the lookup blindly? Should we also verify we found a vma? Some
callers might not fail the lookup because they will only lookup something
that's sure to be present, but some might fail?

> +	if (!vma_start_read_locked(vma))
> +		return NULL;

You can count me on the side that would rather see explicit operations than
the guard. Exactly because it's a subtle usage of the mmap sem, and yeah
also the tracing that Suren pointed out.

Seems to me uffd_lock_vma() mostly does all this right (but also does more
stuff that we don't want to do). I'm just not sure right know when
vma_start_read_locked() failures can happen in practice here (can it be only
recfount overflow or also refcount being zero? hopefully not zero if we
found the vma under mmap lock for read? comment in
lock_next_vma_under_mmap_lock() seems to hint at that) and what to do about
them. We seem to have some unhelpfully stale comments around.

- uffd_lock_vma() doesn't document that it can return -EAGAIN. (and should
the caller then retry or what?)

- vma_start_read_locked() has a comment saying how it cannot fail, but it in
fact can.

> +
> +	return vma;
> +}
> +
>  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm,
>  							    struct vma_iterator *vmi,
>  							    unsigned long from_addr)
> _


