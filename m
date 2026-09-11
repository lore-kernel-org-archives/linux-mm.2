Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94233C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 21:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4A36B0088; Fri, 11 Sep 2026 17:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695806B008C; Fri, 11 Sep 2026 17:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D536B0092; Fri, 11 Sep 2026 17:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31A876B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:31:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F188A140340
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:31:49 +0000 (UTC)
X-FDA: 85202778738.15.48A7669
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf22.hostedemail.com (Postfix) with ESMTP id 025C3C0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:31:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HBgWDR2O;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789162308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGvIJQkp5IyRlQ+7Y8L/xW8OHuy5Tn+hF4zSv+pVlvM=;
	b=L/3Pctw6DZKT9qQDyzbmXyziUlfSX3SWGLWU8k78x0ZtDvwMkykVT+tBbaAJxWq6SXOWQl
	917HImEJkmrOpw4yV2ZfZAZsixsS3NReFKUiixE3HPwZicN0goHOX4st4VOBY/iU18Sg7E
	jrQ4dr+dvKFUBWVK3f6cTgdphhXymfc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789162308;
	b=79Q/pXEixBAQMy7PnLperE1/E3EaevHlCudE6FjL8NUYsOf8vllKt/Jvu54o/EUyw7gTxY
	+9orvHJDZD7s0AVWA2M0JNh9UnSgkr3WXafrIZGceE3xEf04cvy6EeBjnuhReVT4vOLUR8
	9CJbvaYWqvD1uHAdSU2abbvgeGn4j6k=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HBgWDR2O;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530d5fc2cd8so134001cf.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:31:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789162307; cv=none;
        d=google.com; s=arc-20260327;
        b=dj3aeuDaFV3QvOnd0LQmuLu3V0c8mh6Y/9JnkBg8YfxMYnJXJfPJs4cl1NP4ikAx6f
         kMC93UvdY4b0nHjvQjQbmR3BAYjlttB6WwVc1MpVQK2mkbCVhQj7JwQ19r3I1szKJbOj
         xGCFpXpBuuRBbfxAkIJgimlzAq9ddqhqWczXexLH31Dga5cLHAvpoBLoYiJklYrwIJZK
         BCbp0KCmCNh9slQpEAfgWlcMlPypG5KruMixRKI8JihMfDw2ZCSOBbQDk3mda3mL2Kqr
         LWMpvVF7Imq6M01egvNESIjEpNpUy3e9CyAnaREUv4K+yYu25EtDTJixkMM4RpGlW1PH
         0JZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VGvIJQkp5IyRlQ+7Y8L/xW8OHuy5Tn+hF4zSv+pVlvM=;
        fh=YNiINbTT2pbPt/criMf260kJ0jv5lmIuIMTzNkAuOtM=;
        b=Kg9lwYkyuYFrjGJAqi9OfUR90Ir5pnHm4ENm9NjM616wcnQ5S7lFVSOKFPGLMWwp75
         TYkBGxxu61ZpqpabHt1HMBzTyyY1uVULZ/v+xYyGwALLxPSZ17IoE7RD1kB41xg6Gju+
         7cL7l65PXu8tETAqux5mhXTbM+MhBb9LRcl49X/P0T5n0Xag3JargtgcGl/WRC4mUum6
         ysMawSY1RZQ0t+77jAz0F16R0F38FxevmjG6fTxYqzAv2Gdg+eGG60KopQDbEQO20TdK
         ZF06kzB1AKn/mx7VIqZ3yQWciv3leV7NAj+70sx+0rrvFdQT0+t4JX9+5BhXh83r097U
         AWag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789162307; x=1789767107; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VGvIJQkp5IyRlQ+7Y8L/xW8OHuy5Tn+hF4zSv+pVlvM=;
        b=HBgWDR2OgshVoDjZBXRh1J5374II3EbuDsIQxBmg1sFDuSnnImTbYDiX+M2Cq9oa/k
         GyvkivVuH6B7CJfPjtN8HvHWFj77aEZg4rYBcajsXzPH78Exm3JRoOQVOSZgCTwilkWB
         ZRj45JbzoKzFBwvE1PO01RQ26lQSIhjSUwDD/IP0Pel3DOloDeW18hry6ZiXlyONDl5D
         wirgYl0jM5gA1CMHE2ttMie3xKgZCrDCrKJmvRU/qBiQl3UmQqYDOT8/WDZWHaKMEAkQ
         jz6ECQ3E7FG7hr4ZbgqErKGksTFS3yeLGQ1zWyLjTioOzD6rI9dqwjlTgEBRZYb4FVor
         O1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789162307; x=1789767107;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VGvIJQkp5IyRlQ+7Y8L/xW8OHuy5Tn+hF4zSv+pVlvM=;
        b=BxdOk8+7p4J09MT6RLB0uqr0+lcFffHsZD4jzpn7KFsI38CswGRsWJidNY0jaEtJ1w
         7EfccyeYMcOMlFJ3wT0OlCHfwL7REqXaT9OS5x7p8Fuq4CsCiTmqnCj+z7/RhlICEeXq
         7EWLAJNsDpNojLzg5B3HDurW0Dsp9fAUj/fTvZJSLN3yqzvVklJ6Zq3q71DkNHmIbWei
         /Zme7jL/qnQ/Vw4IuORGV+rq16eVo9y6lsJ9AN26nQjQv/f/qCeyfKv+7pMWk/z/Q/Kh
         HXnqizvLEMc1CyiiukxHApFEb7TlrCkOyeSPEbaaZeon1GZFdCDO2ixMtVKC0Qq9LqWJ
         HNxQ==
X-Forwarded-Encrypted: i=1; AKwUvBwSFKkReoLW8oUpQk6RWINF7Q/zl1n7DAkh/Z9faeCPxSv3a2ujgeVe+JCFVM7yM2ZOfNZLhe1oaw==@kvack.org
X-Gm-Message-State: AFuF++nV4VbgGB4dK3TdrnQkW/Kt0ffXjwSIxLyC7O6ahU36tb5mnv/P
	ayYAPyFKOli6kjhm/2y26dWpqMp1fnH/Xc8uVpkwhrN3jscpLZj4SE/QVlPrfusBM5+ZNzgdJPv
	Rwy8655Iv597BBFECmoKFo1O3Unrqr7cZwj4LlmDX
X-Gm-Gg: AYBFou3IoN7xpOhavW+v+kUzdbnFKPLRWFnVC5sQBJbjevVTrBoyuwoe7xZB3+DsBWy
	W4hPnplkzbETyZLdqcXU4sACj2LBeYAYR13+Wn7SEki69iFKYgmGak5aXg4uibcICQNF4FfT8Ft
	pRHHr7uxRSyQYA7eFL1kVt8Wbf7hdIqMhFxpJuixrslhiaZigbW5jMNMyywpHxqeq8bVdOBz879
	lb5eMuWYgUxhbRkv9UOs7MPXdJIEtsZVS+xaISoCDwDZFQ9uuJAHZjtk6hbLsZ7w1xpLfikjHxX
	Y54pDCGeSnRIp23LBphgP0e8EKtISkYLY7dNF532vkPBHu2qjKPskA==
X-Received: by 2002:a05:622a:11d0:b0:52e:1e8:21f4 with SMTP id
 d75a77b69052e-530e63d3194mr1543051cf.5.1789162306468; Fri, 11 Sep 2026
 14:31:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260911194145.1781926-1-surenb@google.com> <20260911194145.1781926-4-surenb@google.com>
 <8a5abc5a-bfd4-4fc3-aec2-a567ef5c409a@kernel.org>
In-Reply-To: <8a5abc5a-bfd4-4fc3-aec2-a567ef5c409a@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 14:31:33 -0700
X-Gm-Features: AcwNN1UKizZchXvXxtFlTQJTapR2k2sJ1U1PVMre-GTpxn3kamF7rTTUDJ1EgCI
Message-ID: <CAJuCfpEp8eBidJSr0NZ-sBuJh-d51BNuM0SJAOSGN7m7GjY=3g@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] proc/task_mmu: clarify shmem mapping walk
 conditions in smap_gather_stats()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rmf3995mfwo9qdxyaornw1bkh3usn87u
X-Rspam-User: 
X-Rspamd-Queue-Id: 025C3C0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789162307-957246
X-HE-Meta: U2FsdGVkX1/WgMEQAk1QHObz7hNt+Jwlct7eflmYNLPYlTKVNM7qmLgJOlLQGrRu6vsmP30j6SeU3Mkg0/FDJJTmMcIPvELA4llEpOcr77Ja+lp346YlQyapTGHO/ahLKcmSVVAOIN3NF+VxbKwQw4kwcsZ0v8V9KFtUrxSYCqZBFTURGk0Cc/MaPT4sXJbBlHSfhZ0tq8UeWevxSAfzQftHL9/pcXBqFCruNFB3GY/UxL/CU8Sd6ymJ4Ft1M3OWGMGNtQi6B3zSd7xoDu4MgDttpEaFW2Dq7HV5YDaH+D+sNUbhi3pM04VuGUQtFF/XrVKP2Q2dKs39KXkh9LzhM2Ci31o/i3J4T4QKa0SmEVy/JvUVIhzVaBwGlXlPN0AinlNCDSllp2fqpU62xKAB/toKmur2yB++DfaxCq7ODofS6F/4RI6QKkBihHCGjsFL67HbZ2PGpogoi9YJc/jvyeOdaSQ/BgWSzGaXfGoSyQPQtT9JObjYJbm/Q3xKma9mdpeAzrbl0DVLa+KfUIDbj2a2lh5nNigGAA7F95qyZA5h8Seq/d4w2JWr9FVIozD/N8SDH1ELBvte/3Baj1oNIMw+szg0KboPDhKOKkRAWELF0DFzCxfQcqXnyKBSsdUXS4ezLNj5COMX16mS3Zxquu+YapplMyA6PKeJacGCJapQQb6x3SVF7Duiw+sT3wazWc8CPIOf8U87rED944wW65TspWdjtYmX3UP/YbI1SteFtRBPOylUwixu86QQVzjr/sNKjiCC6g+96KC5AEcKj7UOM8z1/i9a6OU9+gn7ZwwCSnIFB2ga6vHJMRn60BQnVBKFKt5ffCu7lXiG1Ag7lvEgfvwrCaTxvhVyNK/o9iT0ZTvkg/DZ+AiNwezzcsJXj3fWoZt0B9ZP1iqDXvv5dXaIBlw+wy2DXiZhQS7ssNB0QwsFk8pSuxLCqX5TzaeR6/jjQyYYcedysE912f5
 GuxBRuE8
 rDZBd9THHAJzW0Z/LhRxf7oRGUD05FW1axz4s3sTxgXp9vi3J+1QP0SbNPzZkyt7ITVtPS2mrTZjCxoPYUli+UZEF+EU8Pfw7UtDAcmwr94Z5i4CZg6/cb98lt14b2rDYFq2/K/J3Hu/UPPYRpn4l7WAAEWfq+sd9DXbbPUR2yH8lfxfJf1+M4+7RDgDPfsR4UQlE8yZPGApv/M00C3OGyeZYDvXZQ4/dEcnB/kV6Aeba8lD/lZy0jJOB8Q6D9XLCPA2p15oiYlkZi9/Uk7yjYQLthqvrWZMuUBidL+Uuj8JopspV2APQ5dAitMlnxc9i2WWJn4xjL7BxVp4FrfWmQC4a+OtN/JPaRXfIlipIOf7DWHXeI1fs6vS98RwjrIGbq5OHrgRdKvegJPQNOjGzJED34Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 2:00=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/11/26 21:41, Suren Baghdasaryan wrote:
> > smap_gather_stats() optimizes stats gathering by skipping the walk for
> > shmem mappings in certain conditions. Update the comment to clarify
> > these conditions and use vma_is_cow_mapping() for CoW identification
> > instead of open-coding it.
> >
> > No functional change intended.
> >
> > Suggested by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

