Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB74C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 03:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0596B007B; Sun, 26 Jul 2026 23:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781006B0088; Sun, 26 Jul 2026 23:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697536B008A; Sun, 26 Jul 2026 23:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3097D6B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 23:54:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3A6C140402
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:54:54 +0000 (UTC)
X-FDA: 85033190508.17.94030DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AD11A40005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:54:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKN9vZLq;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785124492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDt6XRhHBziQBa/u0iomOboiTDHrthJqxaelhr7ao5s=;
	b=VthLafbL2fFB7C0inzLZdAN9ndM6X4WcjOPN++luCDIalKbpyrUHiSaKn+uEtlDVB2imQh
	mo/iY88ulFzdAYlU5EG7MRTnITUlWMfYGm70+ZjkvgMSc496wvIMSuKcsRF38uO9C3a7Wo
	JFAjS3838EFZwDOQObOZz0c4pOMSC5I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKN9vZLq;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785124492;
	b=LGGA97hSrFpFrDeuwXP4GKu6gemdE76Hx1qLfakLgC11VTYDzHLW70uwuFhPXbIWzaczDm
	jjISI0Uek6yiCXOWUDS/yl8ObdmIM+kvHskrsRp8ncqfq0cxzSW9Cel2BJiFa26/IXSvXc
	LezcZnNiV7SEfgWWDj270OdC6WKAnmA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 713A743D78
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D6A1F00AC4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785124491;
	bh=TDt6XRhHBziQBa/u0iomOboiTDHrthJqxaelhr7ao5s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YKN9vZLqnJJ7q87b9lUHfv/i4EC5YT4QIWKDJZTDDJz8evKyrlumbgRx7KDCP+u8q
	 BkCsNa6ssFLofdZ0GWRxItd2Z1HiRo1NY9p6+yND2psKpnQHKtmf9dwZBbKlztxHst
	 GA6m+/I3budEwzeov88L4yob4bpcyqnT1/Yo/qCAQqZE2zXC6qksOtpppeZ43JShRw
	 /uBu0XI/OadQ9QhBPsT4L3YRehwzspndzDgNOq3G0cy1zcof6IDM4v6hhoIEto7J8s
	 5oeznMGda5AtsCwvY1QMVEh0gSszSCN4ht7qlZC5xJ14/N9A0d+9tyscDCckVq5VIi
	 uBlgTKobUdheQ==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-930f72317a6so144092785a.3
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 20:54:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr2xwSOqwngIATGdjcj2EJirIs8z+/nGcR4ZO5HdzZi50DFnC1AF/JDQEQJK5WSBhFy34DFR3dOKw==@kvack.org
X-Gm-Message-State: AOJu0YxFUrmSrSO3/2vAfQl2anwkZXMEzpRdZOdt1QWf5MS4dKN9HkCY
	oMHjL/zPtl4ltxWVyiK7CizHXk8K4HEJGR84fxKmSo6Xyy3YxdLuG7025PLz3O9XEhV41S321RL
	HYzzQdZSFaNOS5cSDdXM26P1KHDOyqis=
X-Received: by 2002:a05:620a:2546:b0:931:403:2442 with SMTP id
 af79cd13be357-932df6576a9mr732957685a.18.1785124490445; Sun, 26 Jul 2026
 20:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260714121529.2237261-1-wangzicheng@honor.com>
In-Reply-To: <20260714121529.2237261-1-wangzicheng@honor.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 27 Jul 2026 11:54:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xt6FhvRgmPyoSKdfHd12V+miOZe6SSkg7GGW6TzJFbdg@mail.gmail.com>
X-Gm-Features: AUfX_mxeJtLVdMRlseYd3JXsOkBoHM_0YgC_24_IrWAn_07tj9FPGYqXiGkmRio
Message-ID: <CAGsJ_4xt6FhvRgmPyoSKdfHd12V+miOZe6SSkg7GGW6TzJFbdg@mail.gmail.com>
Subject: Re: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
To: Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, yuanchu@google.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	weixugc@google.com, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	willy@infradead.org, denghaojie@honor.com, baoquan.he@linux.dev, 
	kaleshsingh@google.com, tjmercier@google.com, tao.wangtao@honor.com, 
	zhangji1@honor.com, wangzhen5@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AD11A40005
X-Stat-Signature: 1w4tc456t3mib5osp81et4dqoeer3gg4
X-HE-Tag: 1785124492-480204
X-HE-Meta: U2FsdGVkX18ftLNizY40hFt3MFcPvLwI33TOme6XXhU8l5lfAJdHM5BSfw1ie229SdYj7HOHTRogJ7dMvf8rujt1M0zaR8YdmRHU8zj9WNYOxiigI6nRvHYZLU4/Wr8lP0rwEJv5Gin/YATOzF8PHQGEXObLGjjICIwEkLbncBAkhpvvC+C8u/SC4EqScddxyuYz0oC43UMakOOQvgCyD+heCsOOaa2a/38gljgPFlt/zmu0DDYJJzOPb7Qedc81yXJqhLm6+x3HcPfE17lbE7JweZTCQ0TQ3FNAzcTvIAU2VXnAvnGjjTJ4sDd4gfKBlWQltfOxDX4wnNiQgRsONgqLVx0JxbSHtWycBuATEvZzpbyKECULBH2eZw+rVIpVgE4AAt9VX7Dfft5GSl4jaZrvzuwqodDtBdSHz8cUDwEpu56F+5AgNV8JWemxbXYxF4Q9k7kBYCuCK7Ia+ucqwdUzijcD1LAHW6ckEv16mXLJgyGbIagYDFt7DrRkl9upgAWZ2yjBhWw+WO2Z7Fb5IBymYI1/IUmQWq+7+TQXmhcrr0yQRGbM6t8CTolnr8dqkUnVzh57kNQoib3g1qnIOymkOfhsXQ4uYtfPLKcagrpg7NSY6VYoiDuDlGAaqJhEwRzWxzOy0iqUJT4+uTM08DMda1WZ1XQvPFdyq0I4gR2ddU9h4xIlmYF1V5Xj5/EQL09T/o7Qm4Rr0pCGYGPLQHXKft22rgz3+GEG0v2tfi2f50X6LA0J1WDeYCnIf5F50F9zOKjOx2Uj7v3mxs4lvW2eOZSwO2ALd9yYlj44pyyU3ucj524/eHk4Y8fhfKSDGpUWkPBCmagaBBh3JNPLG2jcS1pI0CwRg/Omkt5BI3OQxZEflEK27OJEO4b7TGMKm/UHszSXxJb6LWu9jBFfCyDdT03GtvNtf0Oo4CXaUjEE2YYdu921icU5iYy0Tl3qLV4++SJFlLmohPvoHVR
 FQv7dTPI
 i88oqoEFENdqmFIx5soB0m7eoMmZCgLIDvwJcybjgrSk8+HeNbYsafUDaMTBwAfzcDX/PTYRAHRx/D4qbpy7QWop3rTX/3BWFhsml4uFXPd2g6QxtI62TVPkW7FtchJrWghHlTE2cmeD7XFOdI4tGZ/oT2d6BbiGPpkV1l61Yq9HVIeiMyipHqmKHP3vTNmUc/Zf1WfKItbtPdvEQPmxtaouGQivMuXdpxpfXjER3D+uuLCJPkbaTKHTHSZA/vAn6Ryjvd/ndEvsAgX1CJrNDv+JE9UWhZ6qs14BMOv62Bf7Wrz0AhKRqSsgCeyQ5J9BOKA7XlLJCQZnzLe4zGMITWzJee03eEhR+AXDMYkAydtKlDAnoNOnSS76f0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 8:15=E2=80=AFPM Zicheng Wang <wangzicheng@honor.com=
> wrote:
>
> MGLRU inverts the reclaim order when anonymous memory is faulted in
> bulk: anonymous pages sit in the young generations while file pages
> sit in the oldest two, so reclaim evicts hot file pages before cold
> anonymous pages.  swappiness cannot correct it.  This series adds a
> per-cgroup proactive-aging operation, memory.aging, with the
> observability to drive it as a closed loop, so userspace can rebalance
> a cgroup's generations before reclaim runs.
>
> The problem
> -----------
>
> MGLRU places pages by access path, not hotness.  On the current tree
> the entry rules in lru_gen_folio_seq() give:
>
>   - faulted-in pages (anonymous pages; the fault path sets the active
>     mark) land at the 2nd youngest generation (max_seq - 1);
>   - file pages from read()/fadvise() land in the oldest two
>     generations: non-workingset at min_seq, workingset at min_seq + 1.
>
> Pictorially, for a full four-generation window::
>
>        youngest                          oldest
>        max_seq   max_seq-1   min_seq+1   min_seq
>        -------------------------------------------
>  anon    .          X           .           .     (faulted in)
>  file    .          .           X           X     (read/fadvise)
>                                             ^
>                               reclaim scans from here -> evicts file firs=
t
>
> Reclaim scans from min_seq, so file pages are evicted before the
> anonymous pages two generations younger, a hot/cold inversion.
>
> swappiness does not fix it: it only selects which type to scan, not
> the ordering within a type, so reclaim can still evict hot pages.
> swappiness=3D201 (SWAPPINESS_ANON_ONLY) just flips the inversion to the
> other side: no value recovers a correct hot/cold order, because the
> order comes from the access path, not access recency [1].  This is not
> Android-specific; the same file over-reclaim is shown on servers and
> worked around there by forcing an age iteration before reclaim.
>
> Why userspace-driven
> --------------------
>
> The benefit is workload-dependent: file-cache-bound servers gain from
> aging, anon-bound servers do not, so no kernel default is correct for
> all.  The kernel also cannot know when to age: on Android the right
> moment is the foreground-to-background transition, when the app's pages
> are cold but their PTE accessed bits are still accurate from foreground
> execution, a framework concept.  The kernel therefore provides the
> mechanism; userspace runs the loop.
>

Hi Zicheng,

The problem is that when an app transitions from the foreground to
the background, it becomes inactive. As a result, you clear the PTE
young bits accumulated while it was in the foreground.

We basically need at least two rounds of scanning to determine
whether a folio is hot or cold. With only one round, many folios
that are actually cold will still appear hot because their PTE
young bits remain set. Nobody clears them while the app is
running in the foreground.

So I'm really curious whether aging should be performed while the
app is running in the foreground, rather than after it has switched
to the background. If this significantly improves the distinction
between hot and cold folios, allowing reclamation after the app
moves to the background to reclaim genuinely cold folios, then it
would provide a much stronger argument for an aging interface that
only sorts folios in the LRU without reclaiming them.
I have a feeling we may really need an aging interface that sorts
folios without reclaiming them. We can then use the sorted LRU to
reclaim cold folios whenever reclamation is needed.
But your use cases don't convince me :-)

If the goal is to work around MGLRU's swappiness behavior, we should
fix the swappiness implementation itself rather than introduce an
aging interface as a workaround. If the concern is swappiness=3D201,
I believe swappiness=3D200 will be a good choice once my swappiness
fixes are ready:

https://lore.kernel.org/linux-mm/20260726122123.7614-1-baohua@kernel.org/

Best Regards
Barry

