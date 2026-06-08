Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55713CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665696B0005; Mon,  8 Jun 2026 14:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D026B0088; Mon,  8 Jun 2026 14:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552326B008A; Mon,  8 Jun 2026 14:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 471496B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:01:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F34451A0236
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:01:36 +0000 (UTC)
X-FDA: 84857512992.17.0B2F996
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id A86C61A001D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:01:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RP68i5uN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780941694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UoX/xydv0CvknQ1ef5QoOdvD3AYDMennvM/Sj2Oa9g=;
	b=ZqT6Og5Bab+zDnYmOCV9yyrKYEr/6FSUEcKNjqH8p5wb1+2VmJ3RjNrjhohGxMVelMpPmH
	HIxQsCRQt7D5ANT2f5RDvmrA7gEYLB8rbmD2RjSgjHoTl+U6qmPPBw1ldRrdMHcC0iN/P1
	YCa+kBzJTnayIh+A5C3hIu4CPv5skco=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RP68i5uN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780941694;
	b=iKlMvoM9MXtQLACnyvP3PLH5sD2n+LFtTqOPA8Dq2+P8ySuAcmThFtlDJJC5FfkFbYkBOJ
	490Xw3MH16KuIq1JUDuxMARYDADwQRrDacclrpWN/5WTCKRCsQ4zt3Dr9eZb5//pK9wZTh
	+ZDpv5b/zKB2jpJsNKWDIdvcWai8Dls=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490b9318997so34535975e9.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 11:01:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780941693; cv=none;
        d=google.com; s=arc-20240605;
        b=Y5VYYQNkBICA4Jyxp9QiyTOjIhz2eOc6OpJ79SB+ELKjdRuxBjkWlLUK5UFv8rZuKK
         zDRFSMvcCbxtAXh2EjXM6y4HH8gXdRdETNNy5UyX5ibR8Mx6ZA6DDleq7BeCqyIeYbaL
         iSEaBxYcuKCLIZICy3srLUXgrqdInajjC/3vTM30OTfbFsueyrId1D3eHFObrFSNBR9v
         BCqdJTFwBnc9782/SBJ+BQmrMZaaryB40rNJmpLLIu3iW66cZw6/A/LKjAdKtebHsNm/
         rwOr6KjK2g94945osGXPmbaLkSRxm0HUNd5Z18xP67m8yj6eoEBlUrpysbOo8K5T+gFy
         vxGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6UoX/xydv0CvknQ1ef5QoOdvD3AYDMennvM/Sj2Oa9g=;
        fh=JfzbElF8Y8DFqGPkX5CGt7PEdDD21QMvGA0J0uJwQsw=;
        b=M53YqGHt23evWj4qKV4wXC5grtPzLqGPrR21MO5vQy5/ROsgUFlsNwiN14Vw50aJQh
         bYA85xJdnjd2MhfKPorhVCwp96b42KSU9Kocf32Sw07H4LfkIQFtac1T4sJew+0UOfgI
         SFU6zd2BIYAkeNF/Eh/ZbLN0bsOe8LRvjYft9cpq0YjTJOygQaWOiCAPv65A5prKEx8n
         JghUK2LlVsVEEsh3DWJeSjcY/jC/4mhXuqeah663W++hCYapKZPUI6f/uvRLhgmEQnBr
         gy/CurUqEeYy/iWRdxRfrjYsZFwe0p43v0x2H7RYIkHtXPjvIDL7e0E745HMhlgYMudc
         Wq8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780941693; x=1781546493; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UoX/xydv0CvknQ1ef5QoOdvD3AYDMennvM/Sj2Oa9g=;
        b=RP68i5uNTXx192ZyQVw/AOMC0NA93RW6zXXK27baqIvAwsP2cnnFzTI2j6XXEknjMa
         dkXQ/0Cj8JDO8yb2VGNDaXIbcI82Wu3qXtG4h90cj/kOvBYEV1q5eayvdvaikxs0lLIW
         qw+JJp+/9Dy19CxLfmBR4EFLFLVXqbsMXuKGPUd+8pTBr3pNfE34kcumhwCXGiylNcFl
         PBKu1pmDSHQMC68BFtpIAtX5GL+qSTAYWeN8yiCAItNiAX/nSCIPGejoHzLO18khAuLN
         +IFtF3PCKA0HFd97e8kSYuZtZ7DJeg83jpeNuXTql8Nk9kUlQb9KQGbkaoTzdwzgBcFw
         vXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780941693; x=1781546493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6UoX/xydv0CvknQ1ef5QoOdvD3AYDMennvM/Sj2Oa9g=;
        b=NnjduuulGDNKKDZFY+hSz6X/O2ZjXleSWU0AXk6Gx1aQKkmFp8F8aOjPfHa6ic6cRM
         PF1dV7TJsu3vwpmzfD3nJ9SNP1H+4gHAg6X2z2lLw2l1V8glY3tn90hedYubcOPG2/mg
         +a0VrJa+AWV3s+x5ooyLr3fSrPai7aCY1dmJZnmwlnWo6KvvvKxLzCTpEBGe5sAyIpHP
         zgoiP7zhvz1n5FTlc0kt0ThXHNGIWHVAlAO2e3hUcptqqa0RO0rhIrIFUT/adb3yjJoU
         ZmCcGp9stYFg+IFm7c5lMbMx+uczYPONjMGEEUDqMA+GIY4uapXJEbWnBSslH06rVBiN
         fkAA==
X-Forwarded-Encrypted: i=1; AFNElJ/FU6/siqV6UYRyBc1qHJQGsxMekwe1KLMuCUglNRyUnCE4j4772eRhDKyK8dAVE77a83heYbGQsg==@kvack.org
X-Gm-Message-State: AOJu0YxsZSwL6uuTpgKBN1sCKY6pxLF614Cbp7KsVUqkJGPodOAKfLya
	zamJkcR57/7sSqNyLyyId86zq39f6t4bUNsrKga7NQS8+FrZle1XRlmiqTgqgo09Q872UtgcQC8
	HfJi+UUFBqKnNWaTp376Kk8vSGKjjwEQSmfLl
X-Gm-Gg: Acq92OELgs+JD1ppVDSiiRyBAJg+xA1yfU1UIEY161oL4FZV1/Y/h//1nMvVCTySQ8h
	FUfZ/mfzxdK1pG0l/qfxXVSxr4QotWq0OiYoTNuFEoto0YFy3XkVstw+jHQRQ4IEZiWxN4Jobd0
	nDnw+ar1I+1HGPvnH4sEcsRf6UoJxleg/FsYeSnlD3GHKGxlZdryFWeevjOXoaU+UbQ2jKvFhBW
	qUmC6IW1ZftWpGf9OCp68cN0H1hbMgsaP3TM+JyeK+bdHCI6q/6GgeEC/IMzFbLQgcDcBOCRy8z
	LkAsOOYeLx/CjlR1M+hfoxr/sJMQEBWquoGcfTvDhk5D6zWo5A==
X-Received: by 2002:a05:600c:190b:b0:490:9804:afdc with SMTP id
 5b1f17b1804b1-490c25ff35dmr290599385e9.23.1780941692853; Mon, 08 Jun 2026
 11:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com> <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com> <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com> <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com> <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com> <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
 <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com> <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
 <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
In-Reply-To: <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 8 Jun 2026 11:01:21 -0700
X-Gm-Features: AVVi8CfPM9EinXbnTowRrF8hGIP3rew15f95GiBStV7nPCFnW8PfDTRssPsRAOY
Message-ID: <CAKEwX=MCFbsh9ndBtR0-bGRr_=v-6bBwTo=muzd9ZSD-LAK1nQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: emg8ynwj13njzcsfpmfixmq5jzakuq6i
X-Rspamd-Queue-Id: A86C61A001D
X-HE-Tag: 1780941694-323238
X-HE-Meta: U2FsdGVkX1+tOVQ7AvXLRNx/S8fgq0VtCc9b+ugR3NWs3+Wjsvn/c8a8IY4AnLPJ5FJM5zDS1tE+/wwnXMAvFPTNTnDTNv/S8E24IAAWmteIlSGv5RmaaEv97Xl9E7ZrbA77zhhz5KAWyYWy6Si74KRjDXmgZUCiFA7oEHGWBAEfzliVcWJZTRIoMNEM9jhjJFE2wF0oStsae08X8p75TxZc1EgjX3OOtuEpZXSTU1mot9EC+fXynde7MGkD4uP1AhuCOs+FCvyKuuNKSujeA4jU+Ov709I1U92ac28/iWEZrh6BGXmlHnrEskWFxGu21iUsg47TOq7n8HQWaDnP5hoU9EmUO8SxGiFIPvmQMA9mHtjNxD+w8qvAmPQLbmdOGDsfp8WGaBpJwSHqjlQaI6Y2ZbOESh1EKGQ+TPBesoxaiQA7vLw5gBlflQtFvKdJv0rEZYTxyoqLwqyH8JI+UPX6YJh3Igutz3KA82GocpGZGvvilaqZQt/ea4fkhycQVGMtZBWAcn6rx7g3kmHOb4rLP4no9QP3X+uleaosGxZGQeBDE1JG2M4eLGXL5gYhrQM8gNn+zsw73WCyyy9bMjyZ5fCCIm431xxbjCAL7Fo0BSrqcJFEiPbRJ6u7gQ31+UAZe+kJHj6B75Lsc57Y+YrbMjr1XkdsR52wLKI85yepXd8YTkcl7T353JSgQm1MA/VwJaPW0zo9pXk+Yho5qe778C9lq2iH7NiGLBcD063IMMsZM5aoqWaRw4yW+nLPMPcZTukHJ53ghjzdV9+yLRiQ7gG22dItq8IFiYE781PE4Gw44wGTCjMiatp6vFq97HHFz4TUmIHjoui9mL3lJxj+qRpHztDT3IOF0C9rQkRGtWjzGTTdcHOPo38E1OmviN6npOXZsHV4Vd7+A6RVp8XoOchumMWwaX27lEec0cak/E/aysZf4iPFCxmSszJ2pYweDRQNPeZO6PkxzD1
 tB49kirf
 Z1V57nELtYVU4K8hnSr3CdDYkCLIYp41FPFx8tik9QWWduppmO//ERI5CDJIFiBDO89+cVZ3m6ZdKcKtwdsOIVtC/5xdpvB43nihxt8fhp497HMcGM+DP4fwoB15oKd0s9MFNO3JgUvibc4T2gs9QeOhyyC3z4aQMxLl/8fH9DOVl+iOJfLhfBNAeUKtAuWfIE6uvQkeo0sPpmgcJ2ifzWVLHcMGfe5BXl+Uuy8WxteylX+TJW9VRe3SeZzZcshcH9fprKdb5dsynSnKov3PTMvNAx2SRa/Taqt6Js3SpoRocdpT4laKAEEL8hkHvJ0ri+9PuAHsr/rq0dQKCJ6ddhvsilL0JcQ9fl2fmDiyW9ArTypDB8Cu5Lio3nCQrtyCCIwjYEk7tsXKLmXgt1Dpvu8t+z5kVDE/9jVgyj1xc+I2sZObMEGEtFFoDSrQLukurjxkVCPEMkXUJUnz1jTR8u6Bz2bQeU8/nzKU6cpbL2PZTKvtkmcLDT6LSJzConw7JhdQjJrY5fCOr3haZc7NtxYg7x1D2ZRS9Qwi7iel4YVsvZzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 9:48=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > But OTOH, this does seem like a recipe for inefficient reclaim. We
> > might exhaust hotter memory of a cgroup while sparing colder memory of
> > another cgroup... But maybe if they're all cold anyway, then who
> > cares, and eventually you'll get to the cold stuff of other child?
>
> Forgot to respond to this part, the unfairness is limited to the batch
> size per-invocation, so it should be fine as long as you don't divide
> the amount over 100 iterations for some reason. Also yes, all memory
> in zswap is cold, the relative coldness is not that important (e.g.
> compared to relative coldness during reclaim).

Ok then yeah, I think we should shelve per-memcg cursor for the next
version. Down the line, if we have more data that unfairness is an
issue, we can always fix it. One step at a time :)

