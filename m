Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20340606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=A/A8mtK1
Received: by kanga.kvack.org (Postfix)
	id 3D9536B05B3; Sun, 22 Nov 2026 10:49:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0D66B05B4; Sun, 22 Nov 2026 10:49:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7466B05C7; Sun, 22 Nov 2026 10:49:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 005086B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:49:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C27B1A06DF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:49:26 +0000 (UTC)
X-FDA: 85463189532.25.22725AE
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 94DCE140002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:49:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="A/A8mtK1";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362564;
	b=d/xnDDWgHV+5nKV81CpFVVylY+oV7LuV0kfENDrZhVGyiA7EbxN+yWUsklq6qnMCwoOnQA
	RK8aFdbOIcm0j6LAnSwwClaP6lMRaowKVvok/FgglbXKCeBO3HOGifs6Wtpl19PPIsCSr1
	+HvCu013morq+gkKbMuFdiGq7xUc2sU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kx1Rbm/vL1Usb9vl4zidzFY59VtOehRKYBkUaVoHOV8=;
	b=wJ9j8nN8QwOtOWiQUxF6MbEXjX69oNft1q8Yq6geijG8er2IX51fKJWZhXJgdVt2+8VNaD
	9TqPOauX1yPCT0RegqnuurShqDxEHnx26882KD7xZFp91Suz0ZJ8F2xCCGLcs8RhaN2jBj
	sSNUKxo846xTRjDxgbVcmi1cPNF+MKw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="A/A8mtK1";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5569551d19dso38340531cf.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795362564; x=1795967364; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Kx1Rbm/vL1Usb9vl4zidzFY59VtOehRKYBkUaVoHOV8=;
        b=A/A8mtK1w6m8mMZy0FkSKNyzKqfOmrPi0PwC+5F81QmdXhX4DjdaV0G1duQamPkZn5
         DGvcT8X1fplMWJlP8bi9gpjKmRIo2MYcmEoees8W5+/t6058vyd20fjN8yyWsoAeQrVT
         /PS7IFgxf0gQ7GwPFiVyT5SBP528BOd1ekEiOdbA4u70eMDS9uACMV8loG/UOCSkYe5W
         F0BaRUm/Qn/m7E6UcaYJFZwplYGWKsaehy1EN8Nzjfi12foxFQtzZD5/PZktkcGJr+g2
         OPlRO6ew/BjAfYMLsQirSefceyAwX0SXFZz1oU4VD4aXUU4QzdXhMlkv6H5PNL+o0s4z
         14mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795362564; x=1795967364;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kx1Rbm/vL1Usb9vl4zidzFY59VtOehRKYBkUaVoHOV8=;
        b=vM7elJqYT3kCvuKdnG9cF2jM3HLPJCO0PHahdMHgsC7Csrflkx4M1eTT69VB/HVbuY
         V+ApuvHQ7ey1kN8fLMNpGnEw6fGRik3z32IjASl1kgXUXPNogG1cRUV1gF/8ue8K5dYn
         bp/nfPBePOe6EUHaLLxRTVnIiUbLGNHKYbXVOPwAPPOpB+nMtkSVgVadO6WR8mtfAvP0
         K/QBEmfbEI/qxGCau6OO9CYh+HGJL1mX9mM1JaBpDrsSRSTLLJgDpn+LX3XrqFqFPMkM
         +25guR+Crc6AL80Jy1wWAPubUSBX/CGz4tPA3PkHpCfOO0oYAVJtsj9zB1quMPX453vp
         8fNw==
X-Forwarded-Encrypted: i=1; AL+hErHWn/C75A/78Y4ckcSC3lQBAhFA3Fuu0OcEmQCbNAhL1fLFmSnlrVzicYAYhJF+S+aGOJxMPB14zw==@kvack.org
X-Gm-Message-State: APuU4Z+QlPvZW8KiZv/OqbSWfmMcFEX4sWcqgo9syRWyNty+P8p7Y29G
	DJU0mEIdHN4PMSmsiDg2VfJ6caZe79GDvXXRuyuPAmGLLmAqAfT/mb+IzbEYdQb4P48=
X-Gm-Gg: AZFdTZfxJdcPUvLgh3pzZrCssLB3Vt1FPjG0jq0wLBr+qb266uJWFS3kZ8OWMmun6pU
	s8rpy4UtlEbfuy4kQ72v1mSGvZtnMKkE2F52l0m10hbKJ0uNhcEpd7BHKIRhn4t95egxpdI51Yk
	vEu6vqroRAuubxEJMRg+VcwV83CtNCMY7IDae4YyjeZvlE0WCIsXDvThou1QBI5sMAOJI4By5Wa
	riSJKpSndriT+qId/G8L7WW+fr05OA+TN0jiM3KyibHIJL8YTH4M0GGfYZJ1c3jBKFRDNZrmkuV
	Gs9y8TSBuZto3j1Di4/RPWnwTI/yssa7ivkX2/9XB3CGh5poL0IiTjuVBuwYZbAPBhcqtqG8HVC
	pUcy1GXvsGjUPj3iSsO5EzvlVbzVpws/5E7Km2VpBDEKfQgNBSryHp3plfW7d1CeF5fS9xOkp0V
	xZQEh6lVQ/EpWP7TtQf3KcM6zRfBYpyvUz3DgFoTfPJJ8brvPxm0Ode0ituQndaef/FOEwvOhdg
	ysK2J84XHNrAWykG5YLdkWhnN9oO1eflKedohiRYTfMGK135GWSFYVAPWoycQryH20pKs0LtOxo
	JszysZSxH4Adciv9CF1d52NqRPXgKxehb1UlbREw7khXH0BwwiTpktsp0cRZ7ww+mhQM+fT4Amv
	bgDvsH7pI
X-Received: by 2002:a05:622a:428d:b0:51c:b98c:f772 with SMTP id d75a77b69052e-55d769ffccemr140869901cf.15.1795362563800;
        Sun, 22 Nov 2026 07:49:23 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7888fb27sm74884811cf.25.2026.11.22.07.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 07:49:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 6/7] mm/mremap: respect guard gaps on in-place
 expansion
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
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <20261121-some-more-ai-fixes-v1-6-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-6-236e925d9b64@kernel.org>
Date: Sun, 22 Nov 2026 10:49:22 -0500
Message-Id: <179536256259.412063.8859349312024671580.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 94DCE140002
X-Stat-Signature: 1tcoe5zpx75abfx3c8kkfanyy16kjfjb
X-HE-Tag: 1795362564-905651
X-HE-Meta: U2FsdGVkX187hVQFxpM8+aHFOTsiXb2X4+1rObrB+q7ll4TYc+gV5vPcsqyu6cQYZFs5dh65BLVOnJ2J4LB/gAOy+ue8dKU0zNiQpTSim0FB66myxvaYPis8BT+XK/jgPyjqmd68LiGg6YIaIrj8hd/b6rF+lQRLtjD/iGF2NS31cSeRF2CmCm9F6GGt3khoJUqIW0SudTvOFPV3vzefCwmcbqn932va6ObvulXFdfqwuFn3WkjFmR3WUQ3oj/9Hx0M0iWfbtxI1VyCnQ9l0GW7piOsMCEl0Rq74L3VE1oq8qk0tLPHlC5KVAtUZ6wZ8jAkcNiTQ5LN8BPp5KLLgX+Ug9dRRHfdlGhXnSk5q5f+ihKPaKBQxCCrqdKHwSyXZQiLPa0IPsMJKcmk2g+oP3jrcplZoAWeiqjf6dysRj4+ZD5WVyidqUxCUAhEBya9zQYJP1MRhB5JR6hoSyhERz/jYMEAzaLDMWs5F0s7rL+IWNctPId+Rl1xQXTHIET4U4PaIbUMJ9GyNGbQeys1M13kkHGWPZiHY/IeiCAuWtX7uXFDdz3k80JhwnXKEXgxLnlnVX4pMWNjdmgyNobVCWGLmXs6lYvtceKztJRjltbkAzaBzzzgVUuFI9/pP3R6SfpXqSVXQAy6en0I4EugQUlUjhj6/zaAFwuBgAR+iqa/XHps2/GapOotCyicAdTGdR8hvB7UzAy60uM0b1IQworqgLDCHqukRK8l0W/cMBODu8vACIaDy4NpB0kRRqx9Hwc6RpaQNYGXOvxEpm2qaNLcGClF8De6tKbQ3x98VjR7ITL2uuCfVPmlOCV3EV7fJoEKOiQqNIM1h8XCBz6hW8YjJym+fPC7zh+AR7JfXbYmpvERMGgmj39DVXeQEORcAsxImZduPNHvl+MwNywyZ3EVt8E4x0sxoZmm/duFkQ0LcnYsdOpDvNfHt78wGR5grc0Uy3ePx7vOfeP+N8au
 xMchLh0Q
 bBTWGfw0xLm6LGjQntDYwopf0OfqgKv9UpQUbv+d5uKrrSoQRPwzijd7TU9JBE4+jEekIyp4xeOGceupOTRBZX2qwo7tzhBJzfg0D6bRBt8Ba8SPdFBJnZ5m4SpXbSFHTcxBoIgJnhu8u4TTnuM/Y8XPVE0rkrmPbHa3ir7gND1r5dw0u78dpOn/DhBtnnQLb+j/qyaw+qEX9jnxqpqMqiKB6ADjnlfpU6SJpDL25qD0JL4egIUbVOpZxPvrds0NcYOGss8LX6yf1UFyVjM8VXDe7Rx4E8fTSZXxKlM/43eeVafaiLcbHF7jSrq65tU/+SZyrg9SFu+LZfpFzv0kPRo4YjATRBzTn1xo57SdNtXgHec1ZKCT9DMlgT4Opvq0LxJseA3eQAdpXxO1S1xXPY7mXb+yTVeLtOrA7pcYxhSZXfdP/uSPUEjoKeRMuFERKFOUbSLmopgl/71DxCF+EAVtod6XxRY2wyi0twI0fKqXPLY/Q6buE7hzG5SCoravTMKX454yAEATZGoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-21 16:02 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Growing a mapping in place can let it use up the guard gap below a
> stack, so that the stack can't grow any further, or overflows into the
> mapping instead of faulting.
> 
> A mapping has to stay out of the gap of the next VMA unless the caller
> fixed its address. But vma_expandable() only checks that the new range
> doesn't intersect the next VMA, and it passes MAP_FIXED to
> get_unmapped_area(), which skips the gap check there.
> 
> Fix the issue by stopping in-place growth at the start of the gap.
> 
> Growing a mapping into or within the gap of a stack or shadow stack now
> fails with ENOMEM without MREMAP_MAYMOVE, or if the mapping can't be
> moved.
> 
> Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
> Signed-off-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


