Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6E8C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83A6B6B0093; Sun, 19 Jul 2026 23:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3E36B0095; Sun, 19 Jul 2026 23:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B686B0096; Sun, 19 Jul 2026 23:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA606B0093
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:38:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B55C31C076C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:38:15 +0000 (UTC)
X-FDA: 85007746950.01.C123932
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id ED0A720005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:38:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fPHNRiw7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of realwujing@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784518693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IYPYAaWLt0mLcr+u21OpJLddua6jvE6TZ5CKvfA5kU=;
	b=Loyvt+gdwTL/EkE+8zKYV83AgAZjq9+DDiQqa4PJ6Nqcyruqp+QdyUuDwHzfbsJBOfQe8m
	hehq8rzQPC9CwtMsYdsedXBauLn5catfTfNdnpKh9LKw4aco+XWtfRIMwh1MsbTATnUCQp
	19eXfcRBISZFfgm8+W6ih8vCfjmjyZg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fPHNRiw7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of realwujing@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784518693;
	b=RIGLA8n0P9Wtk3L5ottJ6D9k0ErDisAPT6TRUu9SRug9LFq4LN+PruZWZ/imSPvV5z0GBG
	vqhWP6BriJUciTjSiAHTHAYEMrmF4W/agY4+8Olppb7nMV86cMkZQUkgL7v2Dg3I1vjxYS
	nPyyJHRcHSCz9EC24ZL1i93k83KEkSM=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2caed617615so106734055ad.3
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 20:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784518693; x=1785123493; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2IYPYAaWLt0mLcr+u21OpJLddua6jvE6TZ5CKvfA5kU=;
        b=fPHNRiw729/FDvNV2PHzAC8StgtvIap6E8PeoLTj63NLn/9wq80CAQGcsEOlLxc7G5
         c/BwVL05z1B4J/9gEJl3KsIdyiyXirV7ytVQdRe9MBDdjINtCh0aa6v9CHCfcfEpe0wU
         QN8EPAnQmdBWej+mDC2WgJN4dPMWpQJuf7pyGVWv+d1KMw/aWWgRyUjKPOJ8DUkJL4FF
         RqoYd5y5DxdSCtnx3l1CucxE2C9hx6rNWzq0OlD+njm3PvJ4xSWUmotDnCFaOzwCpMen
         ocyNWpcNOMnA5K1RVH4d3BYq7fJYUB93+2mZuc9vnmXvPZpI6OwNNj4sNQw2OObpJp/j
         ZYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784518693; x=1785123493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2IYPYAaWLt0mLcr+u21OpJLddua6jvE6TZ5CKvfA5kU=;
        b=ib9Bfa3WR8W1Xd8vm6cpnlfOM5icFkwi/3Z09HOMVR74WInnDvO20y3CCfz5oguF9d
         EQb5dXAI9sBjhdEY9SfzQHfvhOyxD64sqX6wZOMJ+i7zDNlWxpeqhgxr6s9+EEGyxCRG
         wOhdzK6fKf0ZCfpXrkNHQwsQ+6GfWAZEfPvjYceBdkgKC9IibnTbERyJ0MShoeHHNpkw
         DKR6s3LD+JQRqs7cOQXw5R7FkfLj/z/JL2KjMdnhRMksSo30euHc/dL5l5hRlqeGro2T
         EmPwUDiHkrMGxmsOPYk4N3uIZmqgICHEVfGTf5TQ4YuR+gvVnG5rsJylKrqnSlrbrQiO
         u36Q==
X-Forwarded-Encrypted: i=1; AHgh+RpvDyJ4JA4XNKRGYpoGwzZAzNSpnnNHVupAV8BjKI+6C2oSQteeL07MqaEvk3S2JzIJ4L3Mx2lkjg==@kvack.org
X-Gm-Message-State: AOJu0YxR/UYbWEYTI2bfaddjqt7EgRZ52/pZsb2bOAv1Q5c4s5EbKkT8
	qiJ5aRCEhFmnH2Np/LJG58eQWWEEFdQhOp2p63xmKUWQTKx8PTFfHSGr
X-Gm-Gg: AfdE7cnvkZLAUnv6Nwo5DudHwgIdfrNQOuY/Nzn9Jwv5XRLVdMRAWw5ba5dCVl8iFRI
	bhmh7PeGvhp8L/01ezNXXzFJCzfgMXM0UCJtTm5+qDkojHazyw0qyA1lBdw0pice6ewkRxCcXCC
	gfVHzz3Re5njQ8He/jWthB+wQibED98PFhjXYL2A63vCTMlBwkxjXkX/V0mPc7xmzBKJXMbl8d2
	CknYoIS/bml7Xi1bbCjd4uB7KRtZnSWLP549d5VQYtBW/GujixqbXY8bFkogf3Q/mGm7SxDPfpK
	P2tlsBOS82wZCdE0yc4DJxPqYHc9vUSzm41yLSm5tcABH3nCfapMc7/ZpMG3ComWLSvreHMUxKS
	flt9ldbWwiYviSHvq5CSovKH/f0j0U9L9SyvQEJZapBb8ov9QEhSDMjyPLq+dgMWqL9qk7RA=
X-Received: by 2002:a05:6a20:2583:b0:3c0:ac0f:6558 with SMTP id adf61e73a8af0-3c3ad677d0amr13026984637.2.1784518692673;
        Sun, 19 Jul 2026 20:38:12 -0700 (PDT)
Received: from ubuntu.. ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2ddfb35sm26535048c88.14.2026.07.19.20.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 20:38:12 -0700 (PDT)
From: Jing Wu <realwujing@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Qiliang Yuan <realwujing@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v10] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Mon, 20 Jul 2026 11:38:03 +0800
Message-ID: <20260720033804.3862547-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <e011c6a8-cda5-42ce-9d42-b23d1c81b26b@suse.cz>
References: <20260214-wujing-mm-page_alloc-v8-v10-1-bdfea431fd97@gmail.com> <e011c6a8-cda5-42ce-9d42-b23d1c81b26b@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jyq1rmwo7b7e5uschxunycyseor9ypr3
X-Rspamd-Queue-Id: ED0A720005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784518693-483630
X-HE-Meta: U2FsdGVkX18iUqDm3YhuWEZSJqalsq2HyYJKp+zGiy9TxrSW0AtHYjlc9YylBG7bn4OqgPS/MRsSl15AtJ8CQCr2fu6ewQzoxsURxqNM24tH9sw+bKehISH4wU4hFSSCIUT4ZIcVP5KX+AjAyKeirZvPo9fEtKPuoaE/ZTCGjzxWbGy0FKXKGnXe/bHvFI2aE3/+5cI97t6wvxprJqCCpSJdoj7lZm89wgTmUWPdQYDPP0p6VxIFtilbYyl38IJ+buXYySIrJgjAmkbVP3Nc6OC+YOo5xfyCcznkaTZ0Cewe7HfhaaFS8YgnTcxO3m2i4PRwxauckucv1mBBXHnH3AZrd5CVlrWpRFj4zzYNR9ajr4JLXerJ8XZkzvGMOYzhYcBibTxM6owKIcL3WTYKyZMnEFXq7suAokKA6yZnbdU/ZxwKExKXC7GHfyl7SqIYFy1H+FV2+/UAGKVNxXGGurFWn6n7RfhE+JXGMhbLiAGmGMKLojp4p9FdYU2yGVvKUq4muRi9R3+P5HNk4eOplIeCVGS7N3dZk5Yma1ow3pgZts4iFQ96YTWkadzXNdeLPiV8/1k/Eyjak1QIUIIioCL4A9VvmstoX+gaHP4ZLnoOHP79t9D2E1EK1ifkLVW0A0zkTeJOl7pDi3z7uxJASe5zhqnDqory74tCp1SkdM21BRH7Xy0lZxppBTfcjX2Vpt3aq1aFguhuLnJT2wKk4T4iJ8eSpPNOyhh9x7y3d9CfuaTGjxAcmOBu21iikTiXqk6RVCC9OVhP47/52v3GqLGfzpad8uZT8Bio5k5ZKCF7di7fEGV1I5UaN0bfYA3vRS9tbc1j17Kk3qssczP/PWnPn+7RoXJojLH68EVBTn3GccPqKPyPydaJP6TDunYVzuHA0rRayjRdnXLDAFBS1mpmdwd0M4DBz6P6yppCcsr7//A5sVUvik0paJahMUY9dt4p6Nr/FvmPE0eZrP0
 gAaFAstw
 +wJ4EMGMdO6Qpn/C1c338tOqS3+V0jAoHGbFSsLbjkWslHGe+OjjEcHMMBCPcrnZQqn7qzqVn1Upv92xZ5M2dfmZI/fG3eKxYjzUWIqYDnScKmXDu87VuL8neuxysnqGLQ6yLS4UKQAWc+oKEttqVBzwxIOuCrye3wHKtUL/XFRRZOAd9ijMU0e3kFlbJ1MWwtfQs4hnhINp4/Xy5CYaMlWL3rpIgTl+rLgGMN5Mc0cL/OeNtcmAx+xEeZ4ZkkHd57DRI7SSoCyDOrpncit4YlDcnq212LmJ6tblGyOoAgdtQsRKTR0dmeJxLA6piZxKUBuG0M8UFP1+v79QmQ/x3K9AediKWqquJ7BoSbs2gG4Yt0RmLW9yaK3TIfvbejTODaZdwVXleCLTTYWsWjjetCfqIGUmTUYFjCNt4QVDnQ12cGhSe6bqU4e3bvapftN8fdKLizQrwSky41FFD3fsR9u2sXrFqnGNMjeWQ7ffCP4PdPrh3a7J1/ZcdTsbEkkVyZOq8EQtpBlmb7MqCWlnWZHx1Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiliang Yuan <realwujing@gmail.com>

Hi Vlastimil,

Thanks for the review, and understood on taking the Ack back - the
v10 changes were substantial, and I won't send v11 just to drop the
tag. I'm folding it into an actual update instead. Let me answer your
three points directly.

1) The Ack

Yours is dropped. I've kept SeongJae's for now since he hasn't said
anything to the contrary, but I'll understand if he'd rather it not
carry over either, given v11 also fixes a debounce race in the atomic
path that nobody, including me, had caught in nine prior rounds:
last_boost_jiffies was checked and updated outside zone->lock, so
concurrent CPUs (e.g. a multi-queue NIC spreading GFP_ATOMIC
allocations across several softirqs) could all pass the
once-per-second check for the same zone before either updated the
timestamp.

2) Real-world benefit and side effects

I don't have a clean before/after deployment number for this exact
patch yet, and I want to be upfront about that. What I do have: a
production host running a downstream 4.19 kernel logged 144 order-0
GFP_ATOMIC failures over a 4h15m window, every single one through the
same NIC driver RX softirq path (bnxt_rx_pages -> net_rx_action ->
__alloc_pages_slowpath), across several unrelated network-facing
services on the box. That's evidence the failure mode is real and
ongoing - it is not evidence that this patch fixes it, and I don't
want to conflate the two.

On side effects: the mechanism is bounded by construction, not just by
intent. Each zone accepts at most one boost per second (the debounce
timer), and watermark_boost is clamped to _watermark[WMARK_HIGH] / 10
per zone, independent of how many zones get boosted in a single
slowpath call. Worst case this adds one extra kswapd wakeup per zone
per second, and the ceiling on any single zone is 10% of its own high
watermark - it can't run away or starve unrelated allocations past
that. I've put this bound into the commit message itself so it isn't
only visible in this thread.

I know a bound isn't a measurement. If it would actually help, I can
try to build a synthetic reproducer (fault-injected GFP_ATOMIC
pressure under load) and come back with before/after numbers instead
of leaving this as theory - let me know if that's the kind of
evidence that would move this forward for you.

3) netdev

Cc'd this time, along with Matthew Wilcox, who asked for the same
thing on v1 and was never followed up on. Sorry that took ten
versions.

Thanks for staying on this thread.

Qiliang

