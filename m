Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64AACC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822726B008C; Wed,  9 Sep 2026 11:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9D46B0092; Wed,  9 Sep 2026 11:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8706B009D; Wed,  9 Sep 2026 11:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9E76B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:25:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DD14140262
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:25:18 +0000 (UTC)
X-FDA: 85194597516.13.E612D6E
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9EDD210000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:25:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gC3bTDAZ;
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788967516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4jJh3TX4gx98qaUfn3Q4oVt1KTvxUkS7IflLLQjx2I=;
	b=dLunt529ho6mv4OAy8iWOHM3maw7gbgIZeV6E+4n3JT6drfx1jQsL2LdVSGoHcbHHCg9Qs
	kzVr0nhyyRrM1gVLf19+/1SstnGe8IB/kQAIlBeW25ewUZa8pKntvj2mKfAvjSx38vaa+/
	ZBTqJmLdk3enAv+8ukeQnsrufxyKEUY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788967516;
	b=WeDGHXsdkt8wHRCxf6V46wm0Y4ll0DlpLXOVfwM3L7BGwyOEshbHQaNVs8HpG15wFzn0vR
	O97zPfiwSm1l5HTvsKrQoRx/6bBxIw1wyg4jBuy9IT0mKUwYEbmkPsK8mOXZaKN241oRxM
	2WV1HO4+feu9cPA+pn1jX35AxxuEc5A=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gC3bTDAZ;
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-871c8a36fe3so68233597b3.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 08:25:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788967516; cv=none;
        d=google.com; s=arc-20260327;
        b=iGFde6NDaOz9n9pPswW30C52ga4F/uyVt4sXRw+zJvPQWhEudPjlYlSrIxoPqlN/kN
         PKb2MbTz9iSMqEd4SK4C0/ASJgLpMnZlAxC+kTXB8UX1YVqD6eYTPQd1ESDQmM7e6kNW
         kLXFb8oNStoT/EhH7fcJYW3dh4qQ66JezRp0BsU7BRcnXe7xehYv6LMLt4MbFzEf/JVj
         YtNcV86F5ORbukS3iW2v5eR5ZM2Wg/V+8X8FuSAk4IU2uB8pPTU9d4qyaxy2ncKP1tdM
         ouW4ZaizLYKs7klkgtjdDc3sWMKIy0iIb2FtIpvofNnBEKQsdvWDlyXMr/hRKIBnCiTj
         PQKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=m4jJh3TX4gx98qaUfn3Q4oVt1KTvxUkS7IflLLQjx2I=;
        fh=iQoGpiye+5bTttuXxDxy97tCmcwZ3k3lx5/yOMaHNs0=;
        b=eUEA8zjOTHDwSD1qYXjiLGk/NJMzrUCqU7IhHlg6Aw+7BlGGrXs6funZEu1Bdq6ITQ
         1BkGRScfQwVqx//F2O8Akp8/1MJ4sfQ8RPQ6ixQ8WzVE4jkV1+QP+46gSYlQXYmazBRS
         v1731QnHyUf+xtAVp9CtPDsRlsPXHsToku5KeNjETdhyAN+pRon2Snkdvlz3EERj3088
         u2bdR7x83zTsYZsP4wBMVx90HzwXLHBvMlu9tb93pLG0WCVCdFwgmKe3dBvWcHxF9Gk1
         OPRMrizGUkaBbYJQ0iBLK/9R1/67ymXGOlhpRUXMS3Pt3qDpgkHcg9h91FsJs68nnFbX
         5KGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788967516; x=1789572316; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m4jJh3TX4gx98qaUfn3Q4oVt1KTvxUkS7IflLLQjx2I=;
        b=gC3bTDAZWzWxGrdOx+8NsPsaVUQ2NzuDN8jKjQbSE5BH59I/Pd88QWNGFxoPAKQgSZ
         h/w4vKf7zcJK7o6ojVvVrGFCV2GYPEHgaKo3aBmSk2rJigTRuRtxwoauKboEkr8TnEvE
         RbR4H1dTuq7hY5NHqPbriuqzsWi8P9udj9ySDWRf5+Yer3XSshx9F6ALZDEPl6CdAbof
         D2ujA/MuII9x98Ya6c6Thl/nYDPTQiO/smejBvkMk8BxvQlvxCG/o8kzbPZW25yRHYVK
         vwmzqFIW9kOCqztDFdlq/0A0GLO93bKYMfXJBwRdBujoGGvz7fgwUA1LfpqolXLFLwVL
         RsRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788967516; x=1789572316;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m4jJh3TX4gx98qaUfn3Q4oVt1KTvxUkS7IflLLQjx2I=;
        b=mA3tZPin/ySVNI92pnTOPg2fQ9EMXowRzrFmAXK7iVNE8hjnLeSCtRrl2Ns15oJ+f+
         gnEcwVcKSYAkasSYFnmTaZ/uZQTuteoFN100wkFyFAgFEnikcGWyoHj6HhI0OHzbnqmN
         0SCzBC/wMwoX/JavDz5DRDt0Z2ucr+jmc5HQxtplDCK/vSZs2GocAijyknX3fSShr6P9
         9Er2el9j6zihIhfhDx/9rtIoYTK1WGjoMJwORCgsHus7+lTQtng4FEzla/2ZkuEAN0sR
         v22Mg0mk1wYWL2ZRJ99VmbhabBE9MqfVeZaVZy6AeAjMQiG/h4LGliDV/GAfg/wa3fVi
         /sOw==
X-Forwarded-Encrypted: i=1; AKwUvByxF9fKOVD+jimfmCTRPpdAJbZBC3Pg6FahLknSmDCT7Uvgs9/rBZq03UwyBNBa6keOl7yfIePGsg==@kvack.org
X-Gm-Message-State: AFuF++mo7e9yldH6UgyWSnz55KnxgZ/X4LtxAGxryVPr9nqUTw9/EBoQ
	fFHSWufi2zr7WwJ/3aiILw71Jy9urle+hSLPR6+x4x+JrPDYkxAdygLOvAcwwyQRtan2ts0kL8x
	AZMc7wZCLKMFd9xNLT63o6FuBR2DFP72MxJISmrwC
X-Gm-Gg: AYBFou1M1e/XKkTBHo4p04I656v+JaWUK5PLtBT4V3x0TUB5jIWUkrn8eMH0A4eBrz0
	jkGGkHsrOQWTO2/b/+pY7Cfo01zA4aplUPF61OYHrY2rd1ByazYzxW4+1UanIZbIeE1EIF+H1b0
	/nnE2TLsRfHLFf2PgK9SGRzjp48dvgDnGFTNaZ1z//WqVo8XhYlAdmq8yRAHH0sMVNVx217qzx+
	VL06l2/il3Gp03tC2yt3UHFjVEHcGzrbLRE9LoFHQudzZ/Jx6ItVq4n31zA7z4EOOA2xplO9e/r
	hCKCQrj26wwbUxUzg73Dbl2WMHDBGUD2T43u2Edh8T4ii+t6QhDtv486oSejkd/asKnIa2eRQnm
	aUFiqWszqeXhV
X-Received: by 2002:a05:690e:d0c:b0:66c:c7e4:2ff1 with SMTP id
 956f58d0204a3-66fb59519a7mr10665340d50.15.1788967513698; Wed, 09 Sep 2026
 08:25:13 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 08:25:12 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 08:25:12 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <bd6c9c74-e374-a9d3-ba1f-8b6f430894fc@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-18-85e5fd25252a@google.com> <bd6c9c74-e374-a9d3-ba1f-8b6f430894fc@google.com>
MIME-Version: 1.0
Date: Wed, 9 Sep 2026 08:25:12 -0700
X-Gm-Features: AcwNN1XO0ky4otDKucsugFRBan2HEERm69mRZ8ScY2_txSdjnOuds0rILhuqOBo
Message-ID: <CAEvNRgEkkvk11_atVj9=+OBym-7SbSMB7MpHcoN6-Q5KS3Lb_A@mail.gmail.com>
Subject: Re: [PATCH v12 18/45] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 5g8hdisf3e5hbkuxkug198s4npr4nh5e
X-Rspamd-Queue-Id: 9EDD210000D
X-HE-Tag: 1788967516-197830
X-HE-Meta: U2FsdGVkX19MqLwm/Rnmupe9wuskYWQESDcnKdqFtX46R75PpylRW49NrNNzvnZUzNhJ9J54rOE+NqREOvQZG06AmFfjNGF1IzaHncTUuPGkmjvD09A5UirsnGvRNslPJbVgmbsVJbGoeS7VP8HVLAAtaCr/rSSLPfNRlE92TT8/BZwdYT50Q5O5oCbKZOoiBfwIJK44rN/NbHlJ9tu7rjSSo+v61zQ4KrvUzVrjptMZlsTFLs9rT5WRfLX+jjHDc/Ou1u6Gw4oI8e7tKggvCPKBaAYYWfo6PTHMyBMBUtric+jV+S+tBT8qnjyPlDpTtJbXT71M9F3XgR8Db3veVP8BexmHIF1r7I7rOhu9iWP1jWTb+QkbSLKLieYe8oTWIUmIWeWvhePSnkPrjIag1IEYXklo+c4+2Ifkfqf8A03T6HzzryM6FRsORT/EbxealWmpPwD4n6KUVEmGsSlouSgTq7OXY6rG1Kyljlz+AetOU8YQYSy2O6svSSbcuZLfUYV5/R+LJclVdsph6mMzPQqNBipL2SxFkAeo4Lax14TD7J2OhVDZnsghy833ut1FRUf6pe1Fmm5NI99e3UA/uPQgq21zgy23RH38JqZ4Gbo+Q5QEAFPnapRFcxEEx+bsJcjfhvT2wKH86nDma1Wn4RdtEt4PFcrUV5QtgZ/+l70L3WnIR72Dp+Qa0Wdz6fb7IjwbsHCdJhGKov4w8HNq1IC4vDf9SnvEeLbaUFVcAlaUCWu137UnEPD/eMJyiudKzcLJso6iSoY7lzUgnFM91I4oEGRd+LEiHt4E3Z3GzNbEA5xP5CklwQZ74h7U4/g8MkoWKhSCMRFE19142su72wg1OPuKfiRlPmwK9vusu5N+2ZMk0ZQLKBakyYOEmmiwD/D3J0UbW/zK6jA9OIW/7Lx9qLKQWZqFdKCAZfZIPpmjP71j/vRgEg8uCO9OxamMg15NBpO8NhrbOfcvB35
 n9gBEdti
 1y2yzqqe8L0kNNVyKxBgUHXNZ12RFY/zfrKBoOVQXkZXfV08eZ+3xq81ohcnXyfXKZVnf/71ib0aJJ6WG1y/B9PSPOVQMlv2KKArohts/PxYZ63zet57DUHveCK6rkC83T7E9dW1kj0xtjJ9AWvV+YkXai0hOWtRuvASoYCHMbjQXF71jLa35KYf+lakaEZtOZ+B4ejkOGg3tSO6u/ieBlSyvhIJ9d6YKnwadNBkE5ubjGwHzpY/3tdawAOymyoz2CdkrUriEQnO4iSVGVXiFF7Gtc6+yYJL7QN/H/PcuTJw6UZJ5lYKC3o/51ToWgJILziTll2hM0dm5aOlGMiZmePE1Xne3Xvj3EPlXz0RjeLXIqxDG63ogNx90fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hugh Dickins <hughd@google.com> writes:

>
> [...snip...]
>
>> @@ -926,6 +927,7 @@ void lru_cache_drain_for_folio(const struct folio *folio,
>>  			*drained = LRU_CACHE_DRAINED_ALL;
>>  	}
>>  }
>> +EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio);
>>
>>  atomic_t lru_disable_count = ATOMIC_INIT(0);
>>
>
> I don't mind about the virt/kvm/guest_memfd.c part of it, but I'm finding
> a KVM patchset modifying mm/folio.c there hard to deal with: and notice
> Sean also suggesting to separate this part out.
>
> As you know, I've worked up a patchset "mm/fbatch: drain lru_add_drain()
> and _all()" which finally removes the problem lru_cache_drain_for_folio()
> works around. In the initial version posted a week ago, there was no
> lru_cache_drain_for_folio() in the tree. Now 7.3-rc1 has it, so I
> intended a replacement 13/25 in my series, giving you just an empty
> inline lru_cache_drain_for_folio() stub (and enum lru_cache_drained)
> in linux/swap.h.
>
> But that won't work for you, if you're adding an EXPORT_SYMBOL_FOR_KVM()
> in mm/folio.c, and of course conflicts with my removals (in context both
> above and below your EXPORT line). It's easy for me to remove what's in
> mm/gup.c and mm/folio.c, but I cannot remove what is not yet there.
>
> I've wasted hours on this, hoping not to trouble either of you; but
> seeing now that I shall have to rebase anyway (an unrelated mlock fix),
> I'm electing to take the only clean way out: I'm going to submit this
> mm/folio.c part of your patch to Andrew tonight (with a shorter Cc list!),
> in the hope that it can be accelerated into 7.3-rc2 (or at least get an
> mm-stable stable base-commit id) which we can both work off independently.
>

Thank you! Will use this in the next revision of this series.

> Whether that's acceptable to Ackerley and to Andrew, I don't know
> (just as we don't know when either of our patchsets will go further),
> but let me try.
>
> Thanks,
> Hugh

