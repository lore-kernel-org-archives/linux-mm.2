Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1018606A681
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=GQmQyhYT
Received: by kanga.kvack.org (Postfix)
	id C93336B05C1; Sun, 22 Nov 2026 10:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CBF6B05C3; Sun, 22 Nov 2026 10:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E786B05C4; Sun, 22 Nov 2026 10:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5B86B05C1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:53:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FE94C0232
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:53:28 +0000 (UTC)
X-FDA: 85463199696.01.E1DC41D
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 599671A0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:53:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GQmQyhYT;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362806;
	b=AGF0AOzk8GJLk5RNGw9pJ7d7C1caRZ2UQjz52Ct1gSU1bb6ZKBWHDe5uHKt6pQj8VAVZyi
	H9vJf7tcC9aImYOwFaavj4l+Rxm9HzlF+Wt/aCqomgaGpjymOKixqa5v1OJZev0WFTSMt8
	75bIdosBzSOdPVk+ACtjkQDrKQ73uFQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fzk0SoUY1PVvL00u1hntgJWoBs0ufQmEIsqyDHWq1II=;
	b=x459wXJ6rzwPiyXLarSjCDzbcUPvbutYyIZu5fJ433yAXH0ouICE34XKwvnJ0+Pir3C8qg
	JxLji43R7O1gc/onV2OgqBSJ1lF13cErKiBsdV2OHVfR5CdZya9c8ukEWM1ZoCj5bQLTws
	n+rw2hRL491GoyklwJXpg/pHhl0zii4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GQmQyhYT;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-9210f2622ccso33432836d6.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795362805; x=1795967605; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Fzk0SoUY1PVvL00u1hntgJWoBs0ufQmEIsqyDHWq1II=;
        b=GQmQyhYTIUzVhKMy+EzSsSvG5iMq7hPpU9qoh9E8OnxSyPu1duLBkFPR7tgO/nxNH+
         iOBKdggSv9tOWQQxxUIzLA2nl06v1WhGx0Dokkqy9WXWAgl+R1m1N7prVhIhEByQv8xQ
         oR16NkYEdBOhkrvFUsRxZy8GMMF2nJuM48/jLnIsJhrkqcILbGH20Miu/KZkubk+mtoa
         H4B7J/ECHyLFz9qY6x4OF4kGF9BD9OdQQ/aawmZFW6sjEot/IvSGARWAQSUXMbLxz/j7
         v1lpE1dQXZsNQTW2UC8BrffcSSLOmSsUgrh5s+L6W/OiBAwmGIrV+VC0Y2FK9D1VGkYL
         T/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795362805; x=1795967605;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fzk0SoUY1PVvL00u1hntgJWoBs0ufQmEIsqyDHWq1II=;
        b=BxxgTDoZ/beDlj8CIhISBQfCrC0lBFQ+n/hQ+wLQJ/Sj23m7WTd2TeMiKb3t6oL7Ib
         oVqt39EEoTT3gk0dLuTKp0dEi4Wqo+mv+X/M9ZsUYY3xBqxsoloHjEnDMKTaLA7qhz7j
         PV/Zjg/hoVSmiUyB5dVpURTHvFmJ2Nq0ouCyFI0SziPGIjS5Q0kcbeoYaRsJk2Y38oBw
         +0GGr0Y9R52zfXdR8mfaUVoU0xywpUzQjM3afZqzEYK4RZISEb0v73hcFD8KjXREMjP9
         a49gZqqyMs7BXNgOMEe5b+IvV4aaNjZqteh/PeByBekE3y4esUNyLJS4bgcTe71ahCqd
         lOoA==
X-Forwarded-Encrypted: i=1; AL+hErHVJ9bs7L3ydwymSsluJ8cAMZ8SUWiSJ+zadZLGtvJeqqjFSIpqhh6BPXW+2ilYRzx7EAd2E1vjPQ==@kvack.org
X-Gm-Message-State: APuU4Z82ixDrZ4Kz5gtQxh2pGxk/yFKqb+BduSBA/RF4s0VcQCyv5nMU
	UI6mvDqnz37x4h2DOYZI6M7NyKYmHX884a4M39GndKZxZMOMnQl0hIM7UN8ykUKbnH4=
X-Gm-Gg: AZFdTZfik0KNZ7/gqLriE8HGYVztKx3uowzqQcxj3FCtR2/PJYJeUrJT4CDZ+oEBrtL
	uHLBQ4f4zKCNRsDcQl+FtEBX+o4T/GTVbKqtAx+b7A/5ctnQJkmd/K9fvA0slEHIDqd2K0bXSbG
	Rg+KesBmpYTovCGfERKcLdDSQuH4AGvStIGntef152/lstFzQvtWTWQG7QDQWVR6pyeImT947r/
	l3JJQ3Y9VdPb8M3aQj+IhncaV/+GI3V9iERtkvP4/3zkUl/yd10xDzsWqG9M2k/YnQvYbI33sVT
	QHpmZK/pba0yzoyJGkhUFKqIFZiA3OQOOVhGe/UACJdb0T9Ag794q86k59s9WBqpTVUUXuGXFbm
	1UhuYfGeSaZTJmH18+0IFMeEza6Q6dr4ht16iW6qVhmGDmHweDCEpr4Y5yRYWwrkgaZvdSDzrNm
	3tsd1mnQTXafQ21UDjynyTBvuf++NzssXZqyoKBQiD4/lsX3btBNsd2Skaild7calBAk37ALZrz
	UC/phUaUzWGJrdwq1w3L+jMFILvARE+fgnm7aXQySDCcsYy8HK49jTSQolDkCRgVA2h9UJdc0A4
	+23JfgMKib6e3zIRM3QUqbQhBqVL/0etIFRhVzC3IqE4uSHW8K6OXLHsSkXE42UZ5iGmYSz4zON
	kaQe9R+f0
X-Received: by 2002:a05:6214:85cb:20b0:91f:300e:a8d9 with SMTP id 6a1803df08f44-92134adf81emr116279406d6.21.1795362805570;
        Sun, 22 Nov 2026 07:53:25 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921347a0b79sm81259446d6.5.2026.11.22.07.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 07:53:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/7] mm/vma: lock VMAs before taking mm_all_locks_mutex
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261121-some-more-ai-fixes-v1-2-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-2-236e925d9b64@kernel.org>
Date: Sun, 22 Nov 2026 10:53:24 -0500
Message-Id: <179536280440.412063.5336368383648661511.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 599671A0005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ek8ypwxd47qebdh7inaf59jhk8gsq8th
X-HE-Tag: 1795362806-493664
X-HE-Meta: U2FsdGVkX18g9KCeJjnQrk1KFR2H8z/cXXuO/SEkjVBnOUGm9Z6A/r10fkFkrWYG0b9AGB9/N5m29z9UKtwDcjVTfes2YtUG5BltwNov7AR3qaTjI9MOPp8YLHqdVRs2CMQdnWLArybyUmd/gMWgdJCuw8xPD+A/2Jzz7VO/61mlJOvfPZp0jP1dylcz5+iac0FgjFA5GTOY1y2iBtlVxz8LjVxHfsutaBq1wSTq7zaR+L+g2d5O1vDOfZGzaAMQpxPeM98gbXzEwz93ZxN01Ikb0yjAC4ROYHTLxpOlq8asUCxg9VbTs6X05xUlG4RZhsk8ca1CHLGwWpIagyMmwCELYX+rpr2E/y5RMiC/Z18cPdzBYn0DHvFEffB4ClQy2aHkrJuW4CG01jBHe0/NOlR4bKABY4iQU23cGB0smFjoXBNMq1iVomhPmb6D5I/0rcxfBmDimHbR/QET1+NEmozHFYkOnfKMpMzqcIwItCEqFeY1co+pcLDFM+1D0maWftsLljxc3CaPxcmJffGQDOdtuL0EVp3tYHZ7ENhiQnSrktBxfmf9UDem0SzeX+1jutT4LvJwyoEZJkrpl7akrTDU8zb009repTcC1iWhyc6Hi4uewTFxZu8n9Ban835LbPjFyZm++Q9l5Um3rLibiKIt9807Yrkgzh75Va2N93eTdkQs/5S92w4/UZmdGG6mR0c2uPMk766gNPX0s96SoC9ANscpEfowo4h7K2pIxIDvwpBsBr2A7Ni9ye70UlJOQj+OD+qS/aUz1Gf8etoGlYvaB7Ys8wPSAS4p+Y+YWtE+bR4pmggvZ4Cp70SOUdtvi087b1xLGOAY9R6ZlllmHh3bGgMba9GMw/gR/siXaP5cG2qSwX00jGCi0S0IT9lVCnlJ8dZ8j4wPS2bhlFDSvfDJJ+h740PNQ+rmFMKILpjy8AixwoBd57XRx1cCgLRIyEI3SLja44vfxkg3lgi
 Dpy5W2Iv
 R/OEi5FZ7morV6PMa0U0GIVZ8TFzr+EZg6vjaxbCSIKudCHk8l7ADksHoFkeW2yMkSLetjKZ4KJUqqCSr6YNd18srCDsiIIMTihq3JyVeQq6jtwy4ufuYGfss5a5GRTg4bhl47ekti0b9DPAjNavCPg6p1m6QL9CfHyDWB4aDn/cgJ/SHDa7lmReXOybNFQBx6YI7VfRDuEWcNb/IXtM0zPfIHopcQsr647ZsM2TMmHI6cDmPkvwNRuqVkDPsQWBSnqJHsfH1ky+HM69nIRVhWq5Vu9my1uYGdxIRZAC8Y482CZXo5UhvYKVGM7Lu9dwHcIZjNGnO9njEbQaRCu0x1pgtW67QF/kKS8LUv/+foDfQZKN03jvF6KnoU7Jb5Y7Mo1Ho10v2uunJojitRA674aEbqXaVrQVqWCIpt3bBOG6PkmgCOPo5l2DCgmVQ/zai1danQ5ffO5BQgKunYiBpEtp3/Q8XUv5Oz1MKr8tB24gGpFf2syfY2hCUSBwV7/o1dsPSahJ002k4R02M0gPfwPvBMBY7Rpe1Ix3v4rN3UMn9vUn05s+8bkg/0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-21 16:02 +0000, Lorenzo Stoakes (ARM) wrote:
> If an mmu notifier is registered for an mm while one of its page faults
> sleeps indefinitely under the VMA lock, the registration of mmu
> notifiers for every other mm can hang un-killably.
> 
> mm_all_locks_mutex is shared by all mms, so its holder must not wait for
> something that has no bound.
> 
> However, mm_take_all_locks() calls vma_start_write() on each VMA with the
> mutex held, and thus waits for the readers of the VMA.
> 
> Since commit 4ed4379881aa ("mm: handle shared faults under the VMA lock"),
> such a reader can sleep in ->page_mkwrite().
> 
> Consider fuse_page_mkwrite(), which sleeps until the FUSE server replies to
> a write request:
> 
>     mm A, thread 1          mm A, thread 2         mm B
>     ==============          ==============         ====
>     lock_vma_under_rcu()
>     fuse_page_mkwrite()
>       folio_wait_writeback()
>                             mm_take_all_locks()
>                               mutex_lock()
>                               vma_start_write()
>                                                    mm_take_all_locks()
>                                                      mutex_lock()
> 
> Fix the issue by locking the VMAs before the mutex is taken.
> 
> Additionally, make the VMA write lock killable so a fatal signal returns as
> quickly as possible.
> 
> Finally, update the comments to reflect the change, dropping the lock
> ordering list which begs for bitrot.
> 
> Note that the lock order at the top of mm/rmap.c doesn't appear to be right
> - the hugetlb locks are taken after the VMA write locks. However, this was
> already the case, and can be addressed in a follow-up in any case.
> 
> Target commit 4ed4379881aa ("mm: handle shared faults under the VMA lock")
> as this is where it became possible for VMA lock readers to sleep in
> ->page_mkwrite().
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 4ed4379881aa ("mm: handle shared faults under the VMA lock")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


