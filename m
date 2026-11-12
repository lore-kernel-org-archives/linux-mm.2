Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1927B606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iiJEKnNz
Received: by kanga.kvack.org (Postfix)
	id 063FE6B05B6; Thu, 12 Nov 2026 13:52:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F300E6B05B7; Thu, 12 Nov 2026 13:52:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7CA6B05B8; Thu, 12 Nov 2026 13:52:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B421F6B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:52:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52967A85E3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:52:58 +0000 (UTC)
X-FDA: 85427364036.28.5A94DB4
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6CF5920002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:52:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iiJEKnNz;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794509576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcSnrIWaKcLWPzgkvDFN69lIrdlqfIyxKv5P92W20vU=;
	b=jdvqMEKt8d8iCUDk2HeJIsJTqcZkwjhgcsAQoF9wEKo+9Vyqxu+geYO5P9DrGNfc6AK1i2
	3OqlDhgELNiXBfPv1LOZ6zBADn4EzbUA4D4K4hBdwvhX68/YhRb73zC1c6nM9OC8spMXpr
	bZXSCxipYyYeTHc3aNBiJdpj5w1ePpc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iiJEKnNz;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794509576;
	b=NPoWBuQ/buV/1AXi5Gbyh7Zayzb6oOwwnmC+Ia+/XtiDxEhd8dFeVS5HRuG41pCaZVFBTg
	Gyu50ftHIYMQkgZoKdhIYQWvt3Ei8NmxfN/XK0bsyCoD1iTy5l3lRUjKyULehcxL7YFQtM
	XAPR/dIrogTwpVAKunaao3j9GnN3Vjw=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b30477a320so2024837b3.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794509575; x=1795114375; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hcSnrIWaKcLWPzgkvDFN69lIrdlqfIyxKv5P92W20vU=;
        b=iiJEKnNz2a2uF6kojN5c0cIYZuZD0IXN1/FZYY4VPdL6qKvlthnEYTnbqFtUx2kIBq
         X7YHgReTRUD8pTHwfoaEBo+SnrW5TAsiFWOBQnmSuMNILi9S44cURuaURMuhCOi+Yg56
         PDu07SGpA4vsKph54LYL6lDIlMU8CrN1hRBddUz1ZsxWVMOs33gPc53F0/DpM0W4dH+l
         7KaWBXJOyW6wGBko5mZ03urVW+WN6itPbs4OZ/Qde/0ijNLeuwC9qKFg1FP2wQyqQMQ7
         t/0WSdJFd7QTe6hqT9hbKNSPKiBvPxbJL9ijyyev2kY9Ic5gt566mQzbbOrsBNmnp56F
         MEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794509575; x=1795114375;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hcSnrIWaKcLWPzgkvDFN69lIrdlqfIyxKv5P92W20vU=;
        b=Id7dVKUTHu/2sdGCZJ3127xIy/hgncLpxSWlzjb0Yjt/siE460KOeCuVE/xP8YTOFz
         YjKqxmvDMdPRtS8/vx0RfVN5iR2kFhBFto3JSldPfG4yDS4WUuP+ey3VUXJMyWGQB4sR
         kLIc3KagXHQ7BAaQAZ8y99eSNO377ZFgGaASPCl88p8LqJ4Z/dw4cDLEjxVHZA1GpQ8M
         BLAXcesMwp86Z0kuNz7YbyBDTSy+vg7q+znF3dXSngjSrwq9bYRQeakiaNV25H+GSHZM
         KaiFhDmM8ncPCOcJceEeiwuo6d7d7yElGxCJKmbGsH9e4u/K4FnNEAm3kZ/JwK8dF4M5
         Xo7A==
X-Forwarded-Encrypted: i=1; AL+hErFq+gb32K7EMjAjA+DUtHbiFuou61RHBJiftp9c5yT3WKsu6LF3ddx5D/jo7RqSpJZ6cFvEvNZGOg==@kvack.org
X-Gm-Message-State: APuU4Z/zxOmcCM/q8UEGdpK6JWizKPmLV7Is4pCD6vdAhsE8DkhnBGgl
	imjSqBb5PPEzgHr49Ybmg8sw5IM6t5LeJafh84kEQOCIssZFkZaKMzxf
X-Gm-Gg: AYBFou1Ompz2dU1Z8dSbtqwEwQEIzKBuYXBfMXpVIIlg2f6DkwuH8xgGVDDqFiINEDh
	qGiRpf/HqIWDgdQEQU1HPsn95Dl2R9KVDSpxqMmZ69BoPE1xZjqM6NEOWINPicjCv+BEvVl/zY3
	1TIEKi1ahr04l7nJpJAOy5vEj+zbW+13ciiTfkw9jB15yGbCKOgHOx0QjHuOlN5hY/gl2utgDK0
	8CkFMU/dfzOq6l31vDwamE77Kt9iM8S/Xian72TVZV6sc0MfbtiL2RfiyH7UtbL20zJ8xCiP7xm
	PG53k3aamRezh7GmP3eh/DZhUfgjneVMUTf8pFO3/mINjjV3fJJIonZBIoTNMyXnz5An1ajWVOp
	cYPPCpilu/4TgtrJZiWNPh+/yuf5m2iKe3jCrnXMQF/aZgERlxwIJGaPaw50eUEwMWS2uVTgrQ8
	VcZzoLtvokmIuA9olYFS9DcPV3e5ZXr50339ofnlypcmen9cE4sc3mqbbsVY8eAs5n5BTNp03mh
	XAciCySWcM8hH/iQ/e+bdNwv1BWUh2AXp6WBdbuiL/lo60GyJDg7z+LDaKEZtnvzFiCRhltiAoS
	xPVG3X/ryPad7OoGsjluhVghdF4nBF7oXVqOofIxrVs9OzaOekLBoTj696xBt9GgV9AMa4CTCO6
	B7mfJfA==
X-Received: by 2002:a05:690c:f03:b0:8b3:7f47:8ad4 with SMTP id 00721157ae682-8b4aa323f76mr2781817b3.41.1794509575553;
        Thu, 12 Nov 2026 10:52:55 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5f::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa933d5esm2680387b3.19.2026.11.12.10.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 10:52:55 -0800 (PST)
Date: Thu, 12 Nov 2026 10:52:54 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
Message-ID: <avYKuUJJNFylInRP@devbig011.atn3.facebook.com>
Mail-Followup-To: "Gregory Price (Meta)" <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
 <179446431092.482102.12227242887844422381.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179446431092.482102.12227242887844422381.b4-reply@b4>
X-Stat-Signature: xyfijk7k9itbz7ukrd8trki1s8xcpbbf
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6CF5920002
X-HE-Tag: 1794509576-119039
X-HE-Meta: U2FsdGVkX1/ROv0/2nGvECA01N3cKs0vF7mTdiIugAK7O0VdDIiY5ViP+JE9e3+dln9Ipa2lzr4pTr8BrB2dFzYKpAvmyGHJczrlfqBZ0DQKQ1Y5tU+U9cCJKfHKb6FDEIFZWWSOvXzSz0xVXZcoxO82UIDwgg8YH4gSBikFi8+bWOb+rr8ihrWQqFV1KDvJjWULSgn/kGBJ+695SOwTJfE/ezrCUB+EN4+s45pvSBx7rZjiKTV5bHexIsdwQviiDOqcREqMKHWN2s+MOTAaMLQ1ms6WSLVfWuJpMWOtGLyC0OoOyotm67tvxT5KvIi4eIFvND4v+sD0FfDD4RRpNEsMU815/e1dVTZEkJT/7xsv2jsvjVWTfU70cVnpnH4UZ/SKWhuF810pYQ7NzJzbtW8KFPsIfqP+Udm2ZtQk+NrMZnTVagV0hf5jgh0atsulIb88VM7OoIWk9IDhkcigDyuNmYfsW2cuZtds18K8gF8TdSpPdPg+Iw2hUT1r9lgnc1qb6v94yE65tG0PtpI554U8kgv+SOemJ5NkQxJPytVnGImuX9XS7hqo9gz7Tr389izW612fmZ6ySkXA3Vl0bnaueXWoxie4AfVKy1lUd7ew13pQZrAr/rq49bWK2qLnLtEnvNQEU1J5lgicEOjRN/s3y/dCCHuUnbQjPPiqnZIlf/Il2eMfTyfhogXPf0nygMqqIkfoUqFgMVpEp16lNXbovqBlu+9japvtjEWV2qb2e8rQ4lu4CdzcaViZynO+bVdSAZmgMAWOsjnnBjMZFzJ1maz5+SYM9JdleuJ7bqJ1p+CFXC7PiFfLM90RYLQHzHt2T95AXiKFe0j9S5HqfWrBzBEqzLz8ko4N91SaltOE+5jR4xjXOFLSCrI5D7jTIzuVx/4c126uwRiqHTHcz6MrBpBQxr+hSYE6ThaYOutYxB7RlqKweLqziNc7frgorsmtEnN0LqEQqTZeEvx
 T9WZuxbD
 TBAPgYppha+2sYbJZoPw/S0wxsU/w/Z/EULcClNaitq4hr971y+8xDNG1qWUh8rebMZ5dx0K/i10/NDUBB8QDZo/JDgV06q5DrrnSen9yAB9Pt6uCXS6T289RlbAq5MA4KUhD1oVGMFrYg08BPf9ky4fcojdatTTLiy2WmQQ+xdq5NxU2LEJ4iAKp9GrjWRxaggnMGQr8MGA0y+AZjlZGpjdqk6VOEH/i4g75xIo5FDwbMmHF59CVx8hCH2MfD5RMjZyATrIWFFxHPB93KYnct0ric3NPrt/NcJlIYEc3az1Suq0nvNW0GHF3YSixb62rwdkEiebuprqbBiAWEvUnmo3IN8kRvnvL3oVmXS8J1EhCOimSjvIOezUcF7ARiALogdAN+XWHHvuFlUSWrw8OM8Z0163RuRGduXsfCAdRHX9mUZQnzn36Q5DT8E7gpqGMzzAe5ghByIZkRSgS2OltP6dqHp1eB+zYT2xrTuWhdu+Htb+rjtusreWmYKvf8nrqR3x+Ldp9GoHcVrnYpqA+bq67v9pcS8ZYzz+6fifImr8x1pMWZuSINEvU6x3XR1jx93Q4vkEH8Q9kdYPR9ljQHgxYrgh9CmycBIve7D+p+UMSRbNdhdhg2QR7P1d/Ds8gI2NlrgzDnnSOQMPoAynQ4kchfh3ZF2CCdW8d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 01:18:30AM -0500, Gregory Price (Meta) wrote:
> On 2026-11-10 14:44 -0800, Joshua Hahn wrote:
> > Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> > NUMA restrictions") makes get_page_from_freelist() skip any node with an
> > active kswapd on the first pass through the zonelist, so unrestricted
> > allocations don't immediately consume the memory kswapd is freeing.
> > 
> > But kswapd is also woken for high-order requests. With THP defrag set to
> > defer, each THP fault that fails on a fragmented node wakes kswapd at
> > PMD order. kswapd reclaims a batch, wakes kcompactd, and sleeps until
> > the next failed fault, so it stays awake much of the time even on a node
> > with plenty of free order-0 memory. This means those order-0 allocations
> > get directed elsewhere.
> > 
> > This was observed on some Meta production workloads running on 2-NUMA
> > systems, where processes with a preference for node0 allocations
> > continuously allocated order-0 pages on node1, despite node0 having
> > hundreds of GB of free memory.
> > 
> > Only skip a zone with an active kswapd if it is also below kswapd's
> > target watermark.
> >
> 
> I feel this commit message could have been simplified further.
> Brevity is the soul of wit.
> 
>   patch (details) skips any node with kswapd running - assuming that
>   this means memory is low, but kswapd is woken for other reasons (e.g.
>   order-N allocation failures).
> 
>   This results in fallback allocations under X conditions, which leads
>   to xyz performance isues.
> 
>   Only skip nodes with kswap running if the node is under the relevant
>   low-memory watermark.
> 
>   (test details)

Thanks Gregory,

I was going to ask to have the commit message updated as a fixlet but
I think given the amount of change going in I will just send a new
version with a more concise commit message to make it less confusing.

Thanks again, have a great day!
Joshua

> Otherwise this looks good to me.  Looking forward to the watermark
> cleanup afterwards - i agree the change here is a bit ugly, but
> probably preferable for the backport.
> 
> Acked-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> -- 
> ~Gregory
> 

