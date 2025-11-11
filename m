Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09438CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1888E0019; Tue, 11 Nov 2025 04:12:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382988E0002; Tue, 11 Nov 2025 04:12:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271AD8E0019; Tue, 11 Nov 2025 04:12:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2138E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:12:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CD13591A1
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:05:14 +0000 (UTC)
X-FDA: 84097742148.25.37EAC66
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id CE9201C0011
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:05:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QlbGq8t0;
	spf=pass (imf21.hostedemail.com: domain of glider@google.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762851912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RciqffmsGUnB8tK3sBcxSnH1zQElvWzvEdnZAAXNZdg=;
	b=Vma+T29xW4MM7rJsLqpVJSqs0jTspoyTDIp4A5jSEudtUpLRuqpyjPvw1B66JQORIvnaKx
	eRYKu7dR/B9FRDc4kW9ZYTd72XBt+QVHaCAo+ktRIu92AJNzNZnefmWB5g1eUL3wYJkozt
	rawEGCT7Bh6w/u48CHCeeAO4hNZmMis=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QlbGq8t0;
	spf=pass (imf21.hostedemail.com: domain of glider@google.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762851912; a=rsa-sha256;
	cv=none;
	b=HTRTjo9B2UXbYnsEZ6xt42+vEn5dtcR+4QPaHGGyl4RtkR8ZbcaH2ryejYr3YYZIlph0Fb
	kD789TgtWEcUe91yI/A75e1SLVye8p0N42zpjdJNB6qNFVTYkkHf+FrvVh3nYsYlBD6ylh
	DnoVTzjN/yWJ01d32VD4hqG6PamWIJY=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88043139c35so40260236d6.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762851912; x=1763456712; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RciqffmsGUnB8tK3sBcxSnH1zQElvWzvEdnZAAXNZdg=;
        b=QlbGq8t0vA4y3lkPTmzMUoRPrUEVrC3odWZGvuJHDRLJxoii7UYrRqV0DWkMaDcs0I
         9gtnQzTNBltABDollZNnm0CNZttRQdCyrOshS/svVfhioQfijl7ILatzwHLGF8zCmAOb
         NiAjL4cNWTKYsspEVBU3rf6XpCkkVTVG3c3zBRwlXCSqAwRHo2XOwlxTe8SBnO7cB4lH
         aCCDHWnL+7+WaaF5ETNqXz9ItHOFLYJPKB0vcz28/jkFhzT/D98ZtKxEfyHBmqOPJo1T
         duzjt6JVgoe/eIxpUuDB3RhF8wEQABFMvY1n1ZathQbZQmFOizAyr11gs8y7IhoUoVbW
         fCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762851912; x=1763456712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RciqffmsGUnB8tK3sBcxSnH1zQElvWzvEdnZAAXNZdg=;
        b=OW+isJpbqLSKxJrLO8wA7zPPjsT0HXg7ICa7/p+Er3gxAh7F2ziglj8Z5deuXt4z/H
         xc86U5i4LwwmgS5msTTpHAzaAFh+ilkIXwn10moV4Q08b1L09X1CbNiv+yoMSMrRiLYT
         24/uMdg2hHGNKwvZbcF+MlMH1XZK6W6HB6+Oi9Ydp/ZKZIWSQyaE5o7GcnS7Fsy6ZLVx
         OVCr17mKjActzvC/CElENMl3y87rfGhxSFAjf9a60cWKdB7Dc8K0miYtG+/rfsDsd1j6
         UESbwLfNqYFEaFAu9exuO5yi4J3TAWe/2IaYNPhB7FDxoYAF2j0cvwiKS3GhleUyh24p
         /S1Q==
X-Forwarded-Encrypted: i=1; AJvYcCV6zAfbt2D9f68INgkm8mlQ/17KvVIy99xgcNJWDecGGBzbjY4+Ux2dtL3Ou28GYbm7V3bngFHxzA==@kvack.org
X-Gm-Message-State: AOJu0YwYVXfvZIvQ2f4oT8uPtbtbfQteSUbK/3DfQ0Iu09nd3Dr4nyPS
	3AavBykM8p3TvKZ8ZAOV0N01yVzeAfZ3Whk3PzlfhlJFKyblcpdkDJVshg1Cl0JBFESFvYAXvNm
	L1pbuVOlY6OY7UVgylCLNbKQ1jsZqeggbJHLckVKf
X-Gm-Gg: ASbGncv5VFmAzwoVdm5nZ2FV3Qar7pkD70mxZ9KBZV1kv8+gPWi/bSJoLncKpl0ScCH
	1rcc27CwEIrjeX3b3LikaKXBB0bB1meSV//obKuRWTYefq+bTjijPDWW8rHCN1f2Wm32BqqFbWc
	Lj5dUt14SddpxtLyGDSJtRk7PpAhgJBTV+3A63m+5j/rPB0JHXVgsmmEBL+68bqV6+oGbHCkgSe
	Mb0ZcJis1Tnnw/M/KReOlS8A8zM6w6R6lA2QurN9LrlJkoJTl1bjNIz5dkU/jDQ5kAr57vhrv7B
	3it8svubOuhu4ebo943YiAXZ5Q==
X-Google-Smtp-Source: AGHT+IG5h9zoN8ZgQbNHnylwE6ej/e45pEoTj6YsGsJFK5D5YZvplepfzX5RbzM9p15i6Nqb6Snmeh5EikEQA067P+g=
X-Received: by 2002:a05:6214:d4c:b0:880:56f6:92ae with SMTP id
 6a1803df08f44-882386d7384mr151892296d6.57.1762851911409; Tue, 11 Nov 2025
 01:05:11 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <96559d5a8e897f97879259bad3117db617e21377.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <96559d5a8e897f97879259bad3117db617e21377.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:04:34 +0100
X-Gm-Features: AWmQ_bnTIARw6amUs-gvSQivLCgG0XY32k4ioUAxykbqmf67HMroMwsIF2IdVwY
Message-ID: <CAG_fn=X5Dr_Dc1pcnAW19zgo7tW8mUSkpDj-v5eaG-awy4S53Q@mail.gmail.com>
Subject: Re: [PATCH v6 13/18] x86/mm: LAM initialization
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CE9201C0011
X-Stat-Signature: q546ue4nzocff5dcgutpeqyz6r9tus8w
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762851912-610745
X-HE-Meta: U2FsdGVkX1+EAemoyLVH7UhOE91tkhpdHSgpjjkSUp/hj4aOQHe1P/lwSmb3ia4S0ZA6baHXW83zdgcMhY4Fo/xTNZ4wj7gr/Lz6VuLvRhT18i3/OrosqR2QF/QNMyMkrLiMqdnYQ9vEaDpJWOIEIV7gaaKqWUzUX9hPkYceADD5KW067FGGA7V4CBtBiLJaK/I0h09fZ2guRmOrxZ1GeDzVFOWULeevkzN0JThYoyfT+NqxiQl1soFJ6czB8pEKzysWspbezithQUjNlruK7p2SL1xuuAXvxR/bgK8jHK+YGMPyOVgA9upr+YIpCEtqG8p5WaJ6alU/zEIF9M2vLm2G+Uach8t20Wc0fpaxsmtMONCDsxT9np15fdMW91mP8mawXnzipR2sxFvT/P55YzJ+dOk8ZwE0T6rkgqkY5va9ToGw5bmbHBshE6yDn3qMmpmmeS8PSqefgcWqrtjAOL+ktbR1V0DlOMsjjcyye265BEwCvZKFMQAGAZ6uohoxHJJJeHl4iY6WPqlwHcFlHZQvCg+TiVN/Ygnm1YlGqGNSs79V/D7i+PvUxRi4bBBL+46pbKSefXHuJhk+RitUhZ3Hs2B0fEbnlKqRmePlQRcFh/jNTGS81xi+OcR+7Kg6OuKwYxoVanvK+FUWAlXesl7Aa4uSjBoyza2n6V6JUELOji0t0B8TG4CBrYdSow/4IkWdlxxwQ0a04M+xTjhmO7imwflVUjrGCzfmzdwrWaQ3gqW086nlCs2o3g894qMYNLngk8tLuJJi1pUgbvqlSl0cuVGbG2mYmBz9XlQDtwWnscl/j1jhtiilGN4lonc7CyLcMk1tTmoz17cvejX0YK99vu4T+4o2gNCv3CJzrQ3kYJUek4tfhEX4RPViajBd84911cwt9Bmz8WI4YdNDy1AJK2BPNrJZwtUi2yz0+CBFJjdbJDcs7mDSW8fPMoWZTKtg9uoN9KWqNGfElut
 qyJE1IqV
 0/KVITxg295ZfJiU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 9:08=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> To make use of KASAN's tag based mode on x86, Linear Address Masking
> (LAM) needs to be enabled. To do that the 28th bit in CR4 has to be set.
>
> Set the bit in early memory initialization.
>
> When launching secondary CPUs the LAM bit gets lost. To avoid this add
> it in a mask in head_64.S. The bitmask permits some bits of CR4 to pass
> from the primary CPU to the secondary CPUs without being cleared.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Acked-by: Alexander Potapenko <glider@google.com>

