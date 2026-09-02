Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE26C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8450F6B0092; Wed,  2 Sep 2026 12:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CAB6B0096; Wed,  2 Sep 2026 12:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A8B6B0095; Wed,  2 Sep 2026 12:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5598E6B00B0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:23:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9DA812028B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:23:31 +0000 (UTC)
X-FDA: 85169342622.20.DD94FC2
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id A4060C000F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:23:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VySD6Hf9;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YqXELgsqbWJd3zd9NAsECFpyBD1HQvK/BLYl3TOCsc=;
	b=7koL2scziQkBo/wUqtUYE7syNoR6S7Lo97bkDyQyJDDtxZIvHwWQv8KCU5C+tu+nB2iOWh
	ssD9U41FpIMUqGp7SLuSKjXh/BkyxQ4AVYj+NYXXuKbBHm/MY/xZwC18GHl+8RuDArIQ1Q
	Z3dkrPxNQiEVJKss5584Il3Ic2BZUHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788366210;
	b=hQWtpj1kXOC6giLSUxdLH9G4gEx2a+ZOJiNaUs5z8wqlVWSpoabZnXDz2wYPn0No/BOnTH
	8qA2IR3GMXUypkzoBrPp57PbfWs9L3sygHy6n4/brPZXscVp8gNOuPUeZP7ffoc532J1FF
	h2cXV09OgJ2/9Jg+5G9b2cJAXhM8COY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VySD6Hf9;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66f96a9d30eso511409d50.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 09:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788366208; x=1788971008; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+YqXELgsqbWJd3zd9NAsECFpyBD1HQvK/BLYl3TOCsc=;
        b=VySD6Hf9GsfLhLQFBa4R39U9n0FtzCRVJ0L+8x1dXI09xb4Zn2IRV5h5zyEFVDeJkR
         KZ/aWBCmcFu+wbP6ie5kbYPpNzI1TgLXbgH5SVz/gVRHx2Ssw+qG3KQI1CLCbnjnOAR8
         p16oC3pVJoy/zriHCzZJmQL8LmUki/heij0/HsrOaq5JfStqQY1+je4hpMDgpL3dWz7/
         LyZaZb6O8utHQihvNYYWe4FSgMUmJ017B9AKTY39GK3brq3lkN+ppkQ5ygPFXIgoMiWQ
         2+31ntbi9tlpnNRvjH0dIOA0m3W2C0xKxKswWkKUXtbPNt5kdMgxcp+YuzE3ayor1rcE
         HSGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788366209; x=1788971009;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+YqXELgsqbWJd3zd9NAsECFpyBD1HQvK/BLYl3TOCsc=;
        b=Pa69m27l5lin85sGqbrhiG86jDkBPgqBzNSkKpG5ukaWLdsXmWFQPznJG1TTWkE+4k
         y3MBZKnbRozB6aMOh7lT1/OmRg9JJ7j47827VC57S/hA2afQr6V5kt0v7d2A1bkSikIr
         dB7k5n4v4Wl4NLizrb/O01j8Cz5roNqU4jfnHYYe0s+FLno5WbBKAPV7Zuz1YwA1niRn
         nhHX4QX6N7buR646Z5zaUeyTQIVlfRA6C3UkVrrBs4cPVqgGyy+theNIA6iAnRlae/nT
         la/Hedy2sXhZlhyZ2JOeWaJI8xhiiSYEVKl+QNFsxUpswFSNw7FAVhBj0uVIgqwgvrMk
         kx7Q==
X-Forwarded-Encrypted: i=1; AKwUvBwrlSgIOlMi8/V1tRum2ZWpSXTWBblzpN061DgfUH9z7d/IfPWkptk+jlNJfdseg8s4f2USKZ0sUQ==@kvack.org
X-Gm-Message-State: AFuF++mlhV3stKd+Vp/HFAGpXAuBM1gOFzNImMn/momRV87YFIMQXQEv
	HqwVmCCP9rinm6ghSoSOTIvQHDQW6JJZZVt1KY/FlGAJMLbnAktxXm3bZaNd67xJ9yk=
X-Gm-Gg: AYBFou1Q8iMIqRcASr0ZgaLeRnY2SCMh6KYLGJsAElLXYqQNtPvKfRi4utTKGAMofPZ
	bJTGg+inFQlc4GTPRbSKtsbsGx+2CfgiYHyu4CUlmSME7P9kuffmCThcvNHXgDrDBqSkUepaKHa
	SL/RszHpKsdjvEEye33JgK81cJ5U5gs6mho7/nHgzBjBWqRxVGFjjFUsRkDek9CDVcNvl+K3dHZ
	4g1Q1u0/A9FFY95T5/BwAuBf5iJFmN/O09rJTtOGHl9IQwcnkYNcRmVyyqKY02w3BuYQIx2b1+U
	hsjOsV3ZzqGYKAMMQvngU47ww/vtWqB79sOxBbnvzkkB2k02VFujC7RgCDp3kjznvJmkfrNwfHR
	+lG7Zn08tZS2ky05Ew3I+4Jxwj3LDW1g6fmZUnlQ1jNf5r7hhjhYZ1C74uBAMPE7m08u+XknPPU
	0CrvXcR9UO9NGr2QH2AMIOPG8b/pSy69NQYjL+/Y3owye7/hqjAuz8tpeIBSHX
X-Received: by 2002:a53:ca4f:0:b0:66e:6231:5735 with SMTP id 956f58d0204a3-66f9bb54ddamr1843674d50.18.1788366208467;
        Wed, 02 Sep 2026 09:23:28 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c17840d87sm20706277b3.27.2026.09.02.09.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 09:23:26 -0700 (PDT)
Date: Wed, 2 Sep 2026 12:23:23 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <20260902162323.GO3004@cmpxchg.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901190123.3511535-1-noren@nvidia.com>
X-Stat-Signature: 1pkg3qaa7bje1d7yi81sxxxycjj7eo1c
X-Rspamd-Queue-Id: A4060C000F
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788366209-938196
X-HE-Meta: U2FsdGVkX1/8bLUwaBX/UEcqOBfgS2XhGQlHc+bZUTDLheN964CsRD+LGL7duLB2LRk3cz6dpbkW4X/R+DplEnwWrmqaNhLNz8jk2NwVZ0oohF16ig5PboGgTcBe1/66gz3XQfUTAHYeHGKIP1REp3vyxTau+26mxT6TyOBv7q2vxo+HnwBguJoPY6CvlgJOyZ9XG2kjwFlJgtLsX9CDvilRq7Nc/8bxbLozhXXOJiM0ryB0KZs3Arm6mWoqXjjwTkxXWG40I5K3ygelWc9JziFK7jx9QrOBLKOddYxDl32UjI6l4TXm3IdRpjkCfA59UANs/dqDu7NlyZdzSD+ejgeIlFo6+BVFTfNO4hdAujAHIKuJbHB+DpOoPsdv4Wjga9Xhprf+GQK37tT5u9sLVELttKA4qYur5ETqAAJZ/3QOmpZLRsyOgNqpAdk3ckzSoWvmhb4kiBX7TRzCPEWANhPmHYZ3cn+GWCMHQpiP45CJQKS0hz8hknX9MMtWOF4fJtdd41pkC509tKamKaSs4rs7gZTpebFTuRaqdHERSG9pxNvCA+X+WGYe5qNVnd2K70jCVP/e6xH7Ab/nMArV4mN36tThXDi/C0WZ6dmx2BcBxvo4ZZ76wTiH79GDZRAihImycxhfNKzLEBN+GQH7OI2N6ssFsbl6FokFCpyRu/77oNJJNvmffj3KCCwVY/B4QTQBnWilS5d43oUXoQsIEfaql9IW/ZvVJdyfkQPlXTa7axLrNPrynYunRwM9ph4aYk3dBnI9c1701DlXjrFlwrswbOg3YWDUL6pahGbrXbxoQVM4Ct8WXUrG2UkpDS4IRFlyAqi5k27dLX7I/OsgUDjmlQf4DC9YQLWrkpfn/uKfpsVM4kEDGnIbIDzp6KdydHjGV4eJDnJVLiiv2wnqIgZW2vduuwKOXbmRrYwKZcaimgT7xrLS+LjjWPiuFL2+Kaq+C34pi5Qjl0c4bX4
 TmXearzV
 k4Ap+vbZrmAPpqkKsrm5yD3fQfSCyAXPxbNR6A/ImszRhf/oOjRmOXXEB13k/5XT7YJOwEqza0NHXOu8Q41Nl03IawFAcpNvDMjcjfig9C+VeY3J1XzhRJyArRWYwsGf+ADZX9+vGK0dHiCRgpixDheROvGbSL8Nspd+hcdIuffUhJkefp38E8dVIWP3VDA7Bzl5qRqqItLFd+azjdjVGpOirHdLMBqJbi2OC2v3erVn7nX9ILSRxoaS8UO6GIfJH0/mMUXpLDY+4sse2ISO9NbPtSci83doullawJxhW9kNmCpQ/QEaGfbmsuW0oNM6j4o3HXvjsN4s1g/xVNbE27TseOYdPU0gPX04L2I87DDVcUuYUWWFZ9hNEM8ZozHEFBQmnQtYlHxIqg03VYSlc/aT6lk13u3vRc3gKHVwaJYaWmCWXPs+Bvu49JDSIdYDeNv7nv6DkHjddPJpk1AgT61WOxTYdOqyqV5bSE3JEtZq3uqutpmKE1/wSlOlPrMRzUc0R6iyLlC+bt4oXQ8JRdLXVi9iAq8GOWfC18zxLcHtWHopHeYcLjnL88ZTZavNpYnxW0BO6N0O1kwc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 10:01:23PM +0300, Nimrod Oren wrote:
> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
> heuristic to help keep pageblocks free and reduce fragmentation for THP
> allocations.
> 
> The recommendation scales poorly with larger base page sizes. With the
> default arm64 pageblock sizes, the contribution per eligible zone
> before applying the existing cap of 5% of low memory is:
> 
>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> 
> Even with that cap, min_free_kbytes can reach excessive levels.
> 
> The automatic min_free_kbytes increase predates proactive compaction
> and many subsequent changes to compaction. Given those changes,
> increasing min_free_kbytes for THP by default is no longer clearly
> justified.
> 
> Remove set_recommended_min_free_kbytes() and all associated
> recalculation paths. With this policy gone, min_free_kbytes is
> controlled only by the page allocator's default calculation and the
> vm.min_free_kbytes sysctl. Users who want additional headroom may set a
> higher value via that sysctl.
> 
> Link: https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Nimrod Oren <noren@nvidia.com>

Just to summarize my take from the subthread with Zi: the premise of
this patch is to roll the regression dice on every THP setup out there
because certain ARM configurations result in a questionable pageblock size.

I'm not against carefully evaluating and testing out today's need for
set_recommended_min_free_kbytes() in real world examples. But this is
not that.

Nacked-by: Johannes Weiner <hannes@cmpxchg.org>

