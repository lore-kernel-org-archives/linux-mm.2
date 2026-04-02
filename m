Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D71BD39418
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 11:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0E06B0088; Thu,  2 Apr 2026 07:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880EC6B0089; Thu,  2 Apr 2026 07:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F626B008A; Thu,  2 Apr 2026 07:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 653EF6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:44:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B88D13B4EF
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:44:59 +0000 (UTC)
X-FDA: 84613434318.12.0F3CC76
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 51FDA18000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:44:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TC3BfVx6;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775130297; a=rsa-sha256;
	cv=none;
	b=HBHYg4/PRbiFJ6updAtjMWRZDQhqE9I75ZyzG31+OKRIG8L1jGhO6Ggu//9YfWl2Ydj8o+
	SmsmPqNuxts+ivTi+FbyTwz8d9e3eAtiojYLNs8vL/9OBKE2Hh3NzypGmgVzr4tInQFwp9
	O5JKx4XDH9WqLKa59zMUZDDadZUTk9E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775130297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2QHCVOKZe5aOuuGBELCvMiQhEHXDG+VGl4rmeomtG+0=;
	b=nUVQtOLY1EuftXMpVVz31YhEpuUCUe+Eirx5SplJgjPJdRcglMdroepMSnICA4yDS/tj4J
	tGqz1V6kPoACIFwtZAcIdklrA01z7gCb4SMJWiTff5jYF1T9A0QnXOQDANbNkTC7wwgEKC
	4AL8bKhr8D9HLvQ3TVKjXabBGh0CXEU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TC3BfVx6;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ab46931cf1so13086275ad.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 04:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775130296; x=1775735096; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2QHCVOKZe5aOuuGBELCvMiQhEHXDG+VGl4rmeomtG+0=;
        b=TC3BfVx6B3mHGfPY42Lcg/0av5pCI9OdS9+atY2WolOx0oBvEtoiV1ooJIQFCwk5lr
         JwIjy8nJtoRVP77mL2GxfA4bqNLlRLMZ52sGIKtIjJxs7z2BXEKigc5qCqwJ0pMjUWQj
         84euJsZMzcQEaAwOwtn1L6s9htmbI3QMadFBksjOI17GgLShkMHhEowyXrxvzM1v8ego
         9AyPH7GLg0o5uShV55/ugqnUItBgZrnZekt5sr2el/u5AkCTZSPDRuYJDLMuoIbzxLci
         Vo2alz0QAMxwhQX8ALnuP5h93IYrmDOkSyaLGidCzvUXlQj+3dY2jO5PpLyYoEUmiHzD
         CcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775130296; x=1775735096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2QHCVOKZe5aOuuGBELCvMiQhEHXDG+VGl4rmeomtG+0=;
        b=LnPDBJD97Yyab/iSBYIK2V44vqRT57JqJdyX5xfC2WtejhIJ75IsZ65r435aFyEO3c
         CSrHqbqK63J/a6dLS0Fw3hSSwHzwZ+0BGOu7uNMH1w7IFifffwLQTUcwLD09MKFMaf65
         t6YwZoaisq14QA+WVzNAbwc1wPrMJzupRcaSPmEpMN5ELuHiGH5x/h3pmfZEgr56Zqpw
         6qdv4vb2v2zkzjWxqln3TEwjzPpmEyVWu+nBLG3+PYLjsxpeoQylt3F/NGTv21yzl5Le
         6Jthg9cu8/ixTLx6U3WxOHZ/wXuDbHpQjEUVsCe9lcBaoKmNyaSatQbr9JxZ97CFQPUG
         1dIA==
X-Forwarded-Encrypted: i=1; AJvYcCVoS74st1GImZMN/xIrkixmYQzZMJFES5M3gUnwf9H+Vl2TFuYGtC4mf/ak8iR9LhDZ+PFgRcVwDQ==@kvack.org
X-Gm-Message-State: AOJu0Yz2mbfS1VHIVDMqJ8j/IrbJhgq8XBkT2XWE9wl5lmmiFRJNlZpX
	x1YzeYLN3neF1K194qjiGfkLh3JN5fFKalQp751wjO13eU54aI3CwlgS
X-Gm-Gg: AeBDiesrhiXmVLiWSuTJ7ShyW0/VVAnZJCq6gksHVWc6XaIe6WOU94DgqzOa3ZgInZ/
	mZJEwKQ5UjOVhUF6JIy9FBd/WZJG+k3DkcO7enr98NdsqltyHYPDFZ0C7hAPvmc8vV+RxksE6fV
	2wYKzc+GFCHrU2MOCthJMJjweWjl73uBvJaPCwb1hPRRMhHchmsuiZ3Q6/T4K9M1UfKysxaRM8A
	6up8sO/CYQWzJORxiWnsM9Dmjv/d0i0Q4a4s3eivzRwekrvs/K4U6DUf3eN2Nqr/Hodm3V1CS7b
	GucdiDn9y9IcnHRi0qq8qhAAkY1jZk5TJu5yc+oF/wfHmJ1ZhgYWzizPNmjEQMLCx5mt9O/J5Ih
	/eRSTEWjqXI0sB5dFN+//9bjv5PGQmrzVQBG7rcN7aYUVpTsDyIQkXvGR5DKD0scuqiZIC6Q/kL
	drNrxxnugBKN7foeJ+tNmgyHdpQiVOSM5REDG0qgD5A7Zn8f9GpcTzTEozreoZh5VRpLxbipPNd
	Fiwc+8=
X-Received: by 2002:a17:902:da8a:b0:2b2:54db:3e93 with SMTP id d9443c01a7336-2b277e52a17mr19766245ad.23.1775130296027;
        Thu, 02 Apr 2026 04:44:56 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27478b658sm28523085ad.31.2026.04.02.04.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 04:44:55 -0700 (PDT)
Date: Thu, 2 Apr 2026 19:44:47 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback
 handling
Message-ID: <ac44BVOvOm8lhVvj@KASONG-MC4>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
 <ac2rO_ovnIQIeYZr@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac2rO_ovnIQIeYZr@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51FDA18000D
X-Stat-Signature: gx8btsuedhztgn49zb13umw4qo1nwd6z
X-HE-Tag: 1775130297-413707
X-HE-Meta: U2FsdGVkX18YbniHKovNSLZM5jp3o3w9iDTpuawzl7RMcsFGSwiNvnDp39CRy8l2TJW4yaNm6Fobjs+vHWJEgMhbQNq8xQ6Z566p9oAoYCSrvM1VCqm8kEE7lQ80+cRwXRVNkCSmJGy4MziWKs2JWwUwQ9aHm2lkqcExWmC9zE/zfTZ4sAAAC/X6BpDOBbaVa9j7QKh2JXKrojGsD5yncpZOYmcQ2fxaLhONz/DR/20YANczrMnJByMtLOH+RE3+Sb5yodsuH2l51yNU/xDzGZPGhU22lxEPI5T9qHsDQhv9kI6SOGphpaVQUMVrz+IFTRrsM0ZiPsraUYi1bUAx+I7zSQrkqVRezieEg22KYJnOcrm6Hk8cJ5wPC4x8KXB/NhxryfMc/LIv8TGdXMjV+WmGDA1DhjmhF/j+2a33ytJYAlyv5nZ+C6ekeODOSkATy+n0HgNKtyhRyL30/ywQU4pP3Cy2csJfEmgGOknDPwuwD25N5pQxqxd+CMJjGo2OhGpvLkIeZxbbc0KmmcHiqAO31586Klt+8UZZRH2NW8vrE2KKfVKc/pPFxPDWUxgCkNBaIcpmZ1tFd9a7gfHQrA249/2EDSWYo++WOt41QqUbkgvQ8EKjFGdAJJJLMDoBawEOta343Klw68p7+/eeEdoXtgCKb8KxNsJB5+VMQK+Ja3pnvnki+eyyQ59oL+5cFCxax/9rGqdMJwERELcmNAiz0v0NcVj2B3YJ/j8yYiYbhwfejeJl3wCNkrh+mdUnuAaSugGJ/syvrn918y30nIzPZgm9CWxdG3NWbZouBz6ctFlNfOj7wcKE0dMRMbbLPQHNDgLHaX/XfXBl1H4vyMUIaqB1jaOZyk7R+gQxqzIpOr+SMQbX0XNK/h1xP5xbA2Vblh4oKbXCyp6PDvUxL7/IPh+EJctNEyGjqQiB60+ru9FhwsF20NMLYgk0hDY0Fmg0DkC/s8VULiEZ/cs
 NW5BSNA7
 bLjQ3x7qNrDgU0ir8LUBKjGRGfUn8+YQrD6//dPvhFPfL41dX8QeHjZfJzc4FVSYmFkyCUeJTdnK3YdogNog3lbl9InSWNn1w1RytZIdHyPmMWIOhHr+x8ZJtdd53LYJ/KnlIK1D4VJbl+Gi88+VYs59OLF7Q60mYYt+Bz2Dt9aF++eqtIxBgYqD96zm+Cz1RQVQGuYARx/v/8YesSfCxQfnJqphgcuCea+qO4tDyB/QI7HGeKpt647wMkqnYcsRVlpM29y5bFmCN3TQX0DmZL8UNDHncyR/KKcb1GkXJXIHJvMM1CAXSPjxmsMWth9dUBsAq7W35Qlph8ZMxpZz6D+fQwCE0RxNcvuzflLSH1s2/CR5MgsBePphvUNlvntEEnJX7pXWAoUGXGZG3dBl1o/tpsQAk3grGhziRZWY2tM92Sci78S0dYDXT0bTITxFRYP+tGOlA3unNdYa/zENSgY46EMcZrxV1L1e5QqKIj/9w63qyXRoOkS5i96fkcWGwUFK++IhEDR6pZ7/zbprVIbVzTmObJclYjsI6Oyxs4+zBpVzZE3xoZT2fLDKhHRCAhuJF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 04:37:14PM +0800, Shakeel Butt wrote:
> On Sun, Mar 29, 2026 at 03:52:34AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > The current handling of dirty writeback folios is not working well for
> > file page heavy workloads: Dirty folios are protected and move to next
> > gen upon isolation of getting throttled or reactivation upon pageout
> > (shrink_folio_list).
> > 
> > This might help to reduce the LRU lock contention slightly, but as a
> > result, the ping-pong effect of folios between head and tail of last two
> > gens is serious as the shrinker will run into protected dirty writeback
> > folios more frequently compared to activation. The dirty flush wakeup
> > condition is also much more passive compared to active/inactive LRU.
> > Active / inactve LRU wakes the flusher if one batch of folios passed to
> > shrink_folio_list is unevictable due to under writeback, but MGLRU
> > instead has to check this after the whole reclaim loop is done, and then
> > count the isolation protection number compared to the total reclaim
> > number.
> 
> I was just ranting about this on Baolin's patch and thanks for unifying them.
> 
> > 
> > And we previously saw OOM problems with it, too, which were fixed but
> > still not perfect [1].
> > 
> > So instead, just drop the special handling for dirty writeback, just
> > re-activate it like active / inactive LRU. And also move the dirty flush
> > wake up check right after shrink_folio_list. This should improve both
> > throttling and performance.
> 
> Please divide this patch into two separate ones. One for moving the flusher
> waker (& v1 throttling) within evict_folios() and second the above heuristic of
> dirty writeback.

OK, but throttling is not handled by this commit, it handled by the last
commit. And using the common routine in shrink_folio_list and activate the
folio is suppose to be done before moving the flusher wakeup and throttle,
as I observed some inefficient reclaim or over aggressive / passive if we
don't do that first. We will run into these folios again and again very
frequently and shrink_folio_list also have better dirty / writeback
detection.

I tested these two changes separately again in case I remembered it
wrongly, using the MongoDB YCSB case:

Before this series or commit, it's similar:
Throughput(ops/sec), 63414.891930455

Apply only the remove folio_inc_gen and use shrink_folio_list
to active folio part in this commit:
Throughput(ops/sec), 68580.83394294075

Skip the folio_inc_gen part but apply other part:
Throughput(ops/sec), 61614.29451632779

After the two fixes together (apply this commit fully):
Throughput(ops/sec), 80857.08510208207

And the whole series:
Throughput(ops/sec), 79760.71784646061

The test is a bit noisy, but after the whole series the throttling
seems is already slightly slowing down the workload, still accetable
IMO, this is also why activate the folios here is a good idea or we
will run into problematic throttling.

I think this can be further improved later, as I observed previously with
the LFU alike rework I mentioned, it will help promote folios more
proactively to younger gen and it will have a even better performance:
https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com/

For now I can split this into two in V3, first a commit to use the
common routine for activating the folio, then move then fluster wakeup.

