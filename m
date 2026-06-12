Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71F64CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31226B0098; Fri, 12 Jun 2026 15:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08A06B0099; Fri, 12 Jun 2026 15:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A459A6B009D; Fri, 12 Jun 2026 15:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 978A86B0098
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:50:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 32BACA0223
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:50:21 +0000 (UTC)
X-FDA: 84872302242.20.1A7887A
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58599180003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:50:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CzqqOcEu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3-WIsagkKCMgozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3-WIsagkKCMgozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781293819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJtaeor/RMdRA8pDnzGdMSIMMP892NMMkV6Jr1/bAH8=;
	b=igeDX6zZqTL0lPuMUaDGXIjM+dcea/qVJ2gRz4yTDLGiZv8yuEik5+2G8MuayKnaOD3GmU
	E3K978UQnTxsf1/Na3EZc+i7qGezYJ28ThOrtTuHDTbgnTpPtWWme5YPC9/ebfiaE4fX+H
	s0qZc20crIkMQrSCIPYLtWviIk0oEjw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CzqqOcEu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3-WIsagkKCMgozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3-WIsagkKCMgozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781293819;
	b=Zte6zVUa1Mz0rdfwAYt1mvBltpSkeMQ4bEJfNxOC3DIgcw4VkMTi4s2VSqp0ggfOAYxsV3
	lPmc3meZyii2PpDk6NbRcM6TJ3Lfyg8JFgwuGtBhYb0yNewAtruKkCX01gNFxmIuOI3+oH
	lZR2RBPXaCrZm0A0Jrp042MoBH3csmA=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45ef5e38a18so632696f8f.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781293818; x=1781898618; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yJtaeor/RMdRA8pDnzGdMSIMMP892NMMkV6Jr1/bAH8=;
        b=CzqqOcEuZgsomzZL4dk7Ebys15m8b121s7yUfdFEQGecR+ASd5UHYrhGdZen97x7wu
         eC1mV/chjrngeh5lx9qpREteYs/sbDxvJLnk2kbEeb3cvbkCi6U5IkngaEB70aTdjUMJ
         XA+ksICU+82TcT5/MnaaE0TZB77F6sFYtNMfjjNT75y/qBhMFaAFiOaAAlNPGRmjXsy3
         I2hjN2C8GLVMqEyflYiZby7s7MZSgy1K3V+o42yx9X8m+5a0BBpOp4a446TEa8UXQX5i
         ukrKLU2Q5LWDzQ0A6bWnbVkWosqckfdLOFErhUBX6ZlqDxXStQsLzcteh1I9W2f2ElkM
         aI7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293818; x=1781898618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yJtaeor/RMdRA8pDnzGdMSIMMP892NMMkV6Jr1/bAH8=;
        b=Dd8lkhhKM/L5rHCw3D6/z88DSBbBQsYgYM3lbs0PVQXHp08Rlqp+Ky8h7EKtXV7OIV
         3i65DZVxzCFchQr8zJpGPSPcVqXC1kuCtR1hw3Rhhrc6Adwb2awCuLwrmnId0OUTsCz1
         Tq/xgMdNYk8naNHaTQKczAGUjF48zQFfCf7MuGtru8ZLJb0zUhWEZwYdaeUybwleb3e9
         6UvTl8tXyy+6WQgAosdnl6zFqEvt77C2ed9B8ltqqH9ZLBcNddhiNbm2y1f6CbTQq4Vj
         3fy1nfZNg5NbRDoJMtx90OSYGHZX9rNvuCx8CaDbGIdA4+4LwMPa92tHEf5fxZc3Dg0s
         UC/A==
X-Forwarded-Encrypted: i=1; AFNElJ9QaA2krieCwZ434g2xAPhna6zh9fCKUhyA9DfL8+qoNdEahRmOjk4SfWfSiToyanwS8Fqb6xWz6A==@kvack.org
X-Gm-Message-State: AOJu0Yx5OniA0ha8EoF6+S4cT073B6gJJzT7tfEDf9++I5L0sWCKisf/
	vWy+zBNsd48xDK6TbzM6ZdqUW8mPCRKdngqi1AAJ/wmPXicRAtOrFbkRUCciqFCgGDb04vouHKP
	hV/YfzRnCxC7uM5c82A==
X-Received: from wmsk6-n2.prod.google.com ([2002:a05:600d:8486:20b0:490:3fd8:77de])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1790:b0:48a:8b02:ae91 with SMTP id 5b1f17b1804b1-49220092ec4mr6888375e9.11.1781293817496;
 Fri, 12 Jun 2026 12:50:17 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:50:16 +0000
In-Reply-To: <2da031dd-4442-45b7-9515-72ffc60e8d8c@intel.com>
Mime-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230413.D68967BC@davehans-spike.ostc.intel.com> <aipphZ5iCnbXVNSR@google.com>
 <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com>
 <131c6a49-9177-418b-a653-8f13942fb8d3@kernel.org> <876077cc-db6a-4517-9d81-cdfbb43e599e@intel.com>
 <CAJuCfpFh60wULMkFc7hzxWNg+qmZ2R_HMw_QZe5CNcDRFuoN6A@mail.gmail.com>
 <e9e196ff-7428-43bd-8e06-dc2cf0628c9e@intel.com> <CAJuCfpFo_avdhpOviX7EsPqLgDJ3DfeGpth+yu1-ahfawqaSzw@mail.gmail.com>
 <2da031dd-4442-45b7-9515-72ffc60e8d8c@intel.com>
Message-ID: <aixi-DxMuc0MiGeO@google.com>
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
From: Alice Ryhl <aliceryhl@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Carlos Llamas <cmllamas@google.com>, 
	Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 58599180003
X-Stat-Signature: d3sodxa961zg7fknqm5meq7bpcy3xmm9
X-HE-Tag: 1781293819-893392
X-HE-Meta: U2FsdGVkX1+BvH0cFa21RiXEFtO8n+miruxCF3PSylEUe4r5/AIkThYCPij1uDDUtNkjqvKxbfvhtNe+g7Vb9FlInq2M87xWjH+1Vq+aZsOz2qr5OjhJY0TAzfYhan1tpQ7/zQwg2rH4jj8cd211Q7H1i983ka/UlFFNtLWoAY1X32RSGYMTJjdMA9v9u3kK4uaAbejT8EvIK5sTFj5YFv+dw2X853fuzDvuRou46EzBLy0nrTFXcOAyhhqkPJtWIcezGwrZQUxa28vAiF24RXNmn5AKwng9eC3J1T/cAuDDlDvskFe6HN8LOwL4HVDOPHdsz0jeC250l17TRVKFTs2VrN+ABDxeBlS3+VrVnuI1eVsJCR9PDcNy/b4rjnT1MQ1lc231NxbdUqKYwGu4paEkf0UgBsi9RL34IEhi321nMG2cyQhw1FtU3V7aut5hSmQV+gsT26cjWbagQ0vbAvxnX2c3oXKllzF3I20JAKge/6ad8+NI9uLy9dq/t1+lMCl9Z9f/17uKGlRH0yqiBb8npQsEql3HsA2WB/MeWtLoPO230Ua0wcjGAupOuFil2i7P3/jq9AuwScQouSS2Q+hqsf8jvWtbZpTCjouIZaFYUDhjQRho65oSDrddbbfa9r8po7sYU9V889xHUOsyqXmw3qZGTiWE/wv9JqpgwQaFxAcWdw5bNgaGyqSZHDSxNA6YJHXUf1OelGsXSs7kv49ylj6CG3omaEkDUQqKyO5+nESII2lZ2jlqSD3ZCS+wIQ3oF6zXytkDXJhDml+ODTSN1PrZzXO6arf4UgUH0gqhbdGMZJ4HFdppplFCS3JmbY/SyfpzzfeXK5mzyl5ric9hQipC+ta8yqOEkGY8vmfxryeMtQ6j63DPcs77QYViWaAKg5lLzXnW26+KGTCDaECsCt5GUosZyAxKjtwtqaQunJSiQGjo8eJJrak18sSumsMkKSgOzO03q7ROm5C
 UgxCqycA
 9VMHgbNRqOUQP9Y9HlkNA0OBvpMd87eifUISdsQPngRiiASnwXZuvbNJakM5NM7Q7U/lSlc3STon4MGxWyA4WR06EjAnnq74+dQMtpY8F/MCIU/nMnryzjcRYhVgWzN6wrfDTQQQysajvIYC/sRGK18uyAj7XLa26SmcjfF+go7p3kWhncSndRfl9NLqZXNJaRlVc0KlBrzGxowcize9KdoPx+HpLesg8yXJWeYAObYanCSzotXJX9UmHYoA5m+3zbJ2pv/fly9gCfnC6xoG0M0Nv4AZpUMg9im1pspr2zpCe9uXFjNHVgcQfdq7E/FrTFB2ckhOKsE9xpXQPf68xHg68CoJbAI0qMCGiucUTau+KfsVWJimIyD8mM6Ef8r6bV81vgVQbYYMuJFMxK8syYDb0+EDP0CIgpZuXhUl8mm3X5F0S5fCzqD4Oha0Jat3Cq5GCOFzoQLsJoE9JBPaJm2aPVSxSs1rqQZcxSGUDFgJrGgSCTLwtKIF0y8bEau517eSqMRJJNsFaOGcBsZf+Qz5qbbz7MNnRHTwth24yB1wDwV9C47Z9NUcCp4YXJuKoCPnLQrHX6WOsKwPATmEcRCtP+LL4MQh3r2OkNuDTcX93isY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 11:47:59AM -0700, Dave Hansen wrote:
> On 6/12/26 10:44, Suren Baghdasaryan wrote:
> >> It's not impossible, but I do think it is irrelevant. Or at least that
> >> the *VMA* is irrelevant in this case. binder_alloc_is_mapped()==false
> >> means that the binder VMA is gone. It's not in the maple tree, and it's
> >> not coming back. If a VMA is found, it's an impostor.
> > Right, but before your change we were bailing out early. With your
> > change we would be generating the traces and freeing the page. I think
> > that's a functional change. Was that your intention?
> 
> Yeah, it was intentional.
> 
> I think the existing behavior is buggy. It also complicates the goal of
> removing the mmap lock fallback. I've broken that behavior change out
> into a separate patch. (attached here)

I think you can just:

1. do a lock_vma_under_rcu().
2. if it fails, check binder_alloc_is_mapped().
3. if still mapped, return LRU_SKIP, otherwise behave like a failed
   vma_lookup() does today under the mmap read lock.

Or you can even skip steps 2 and 3 and treat failed lock_vma_under_rcu()
as LRU_SKIP because processes that unmap their Binder vma without
immediately closing the fd (freeing all the pages) does not really exist
in practice.

Alice

