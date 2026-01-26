Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BB9D1950F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 17:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137D46B0005; Mon, 26 Jan 2026 12:47:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2C46B0089; Mon, 26 Jan 2026 12:47:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFCE16B008A; Mon, 26 Jan 2026 12:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE8A76B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:47:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 946FE1A080D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:47:11 +0000 (UTC)
X-FDA: 84374846262.09.CE537D4
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf06.hostedemail.com (Postfix) with ESMTP id 79405180007
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:47:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bBtTcyXY;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769449629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mb/leG6Ch5DsFFPtx2vrqbxxpTr3aeU3kEJMHwQ4pjU=;
	b=IEvv5nR7/Bamo+ogHoa4wcc7n7OS0qcTcDFTYtAm/46Wr+jGHs1pPGOdf5SFitdgHNskiA
	1HaMJsl1yMSU8SuWp7FCbXnYyn/H9GGuw3tsTozVhJI2oO6dO63HIQICM04jv2o6cfjxBO
	I5hHQeF4XfxE6HYfvfoL+fhDPVsD7MA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769449629; a=rsa-sha256;
	cv=none;
	b=YaaLoDLXKSzsY/4Xl3iHzUU2xD32cGo0n+QyQuMVLX3LEQCpMsfFXBiuFdJvaVSrTq3rkO
	Hwdp/J4YFdq5DhA/7TJ/58begU42XCfvs3c645BolCIjanfWN0XHk6E+L0aeADC822Dihj
	O+PiAZcUqJhOBkEzA0L3kRZEGidfaRE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bBtTcyXY;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-47edffe5540so54717485e9.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769449628; x=1770054428; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mb/leG6Ch5DsFFPtx2vrqbxxpTr3aeU3kEJMHwQ4pjU=;
        b=bBtTcyXYXjMu3aKXqdockNs58HBl2C95Gyv/m8/Ov9WQ7v9IOVO2MeJtaGSVxTqD70
         N+GSzeD9aQ/EUutA9fWfgRPtpbUfpAmGxERsNMO6O/JmY2aCz1SI3QyKusjY9H5sgUX9
         dxaz/3BtodXahUihieOvUEF9k4iLBh+HxBx1EwdOfZ3ZeGeljnNpfXaCRLouaRVZshvz
         lEQzA7ctRUxGx6AgkI9HmiSvZoFUWApbjFkzQflTlObnWBspqJ9ar1uZrnTaULe+KRUC
         MDYAD5JtGu8uBrVVmNI1ryIfZr+I82sfP86U5kn6K93Wlls8heShvfZiVuPNh5cKzLF6
         WHYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769449628; x=1770054428;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mb/leG6Ch5DsFFPtx2vrqbxxpTr3aeU3kEJMHwQ4pjU=;
        b=if5vBIOhIXdj30tN5QLjThnqtYKopvAUr5P3A9wvnWIsUekTBmsgHug7we6OpD+Qqb
         n552IT1vd/p4wTKbE8N+68wDW5dsYJF1tKAjV/TD+Yh86vm1Uy8SpcYW/07fBpa/CyB0
         vkfyGGi8BV0vgzIadBDxkPv7f+VsfLDzDTsjU3csubqLYNsWyPPAM3VbyBuclD6DxYB0
         zhx6r3JyqZcmvN6OSO7QaJrn7yvSekzd6WPg/IdCc27cRE4eaF604ITt/1I2euQTns3Y
         9UFJd0pxNBda1cU+xjzCXq+5fJ493ka0fs6Wed4KtmjObqZFdfy8/x2SyogliBIaARHM
         XFuw==
X-Forwarded-Encrypted: i=1; AJvYcCUH5OLi1jOc+ZjXy8Rw+YhZuaEe4o0qqfuZD5+7JyZySxqflPyylEWfklLXB8dn9Q/a7ZueJNa4UQ==@kvack.org
X-Gm-Message-State: AOJu0YwlaePrCgyG8HtllLhY8ugvnYiJJUvMQh4ZGV6Kom9Xo7uSiSbM
	h9Lz2zLw3Ssf5a1Bqu7+lVTduvnA9G3yDlDRd9Irg83an98NA+EmP7g3LR2LDu5QE2o=
X-Gm-Gg: AZuq6aJKDXM7r0f1RuMYQW+rEE63NMT/ycNWRfZh7kGqKghN8If1aCattQCoUbCNDRC
	sEPWF8qyMfBkrxScXAW5Rs3Gp41gx86sDBJZQrUpDqPFzNWxyJd15+qCifdNi1iqPZwG4DFWQFH
	p/sQQrcsF3n3oRsHHR8zF6vakmhrO7IPXjx9pehdWLBaRPp89hfTlBsNZFzG4jySwDXLn7innvd
	Cl8ds3lACmtcGp6myLcV+V9M7JOjqKji9ExC+StY02knOmKqQDLlfH0srp6Dk/2Qas9WVi+Tl/Z
	F7CoxxtbVu6YPQZ5ukcv2DOsZByhO7OOFSk48g8Hpw2WfVaaaM56NUkYNYvp35CKJ5TRxdzyfVT
	3ycOLKhxsy0XOqRA+OR4uc6lqxhE6N3Ni5lO887t0xsTbKoVJBimtu0yeLMDBBRhiDjW+4xIUoM
	BPDoHWGN/N+2Z55JJCKMwtZlkE
X-Received: by 2002:a05:600c:8b11:b0:47e:e2ec:9960 with SMTP id 5b1f17b1804b1-4805d06cdadmr105139335e9.35.1769449627682;
        Mon, 26 Jan 2026 09:47:07 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48066bee000sm3831515e9.4.2026.01.26.09.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 09:47:07 -0800 (PST)
Date: Mon, 26 Jan 2026 18:47:06 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v16 3/3] mm: Reduce latency of OOM killer task selection
 with 2-pass algorithm
Message-ID: <aXeommbTq_KNpUZa@tiehlicka>
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
 <20260114145915.49926-4-mathieu.desnoyers@efficios.com>
 <aWfNMKCoEp2LuA2v@tiehlicka>
 <a46b298b-baa3-4998-8715-0568b5b186e6@efficios.com>
 <aWpfbSJe5vREzzyd@tiehlicka>
 <0079bc61-5655-4677-a421-1a61f4c52d59@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0079bc61-5655-4677-a421-1a61f4c52d59@efficios.com>
X-Rspamd-Queue-Id: 79405180007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 14myt8au6jokf6a9qpimre4ddpbapj6t
X-HE-Tag: 1769449629-678100
X-HE-Meta: U2FsdGVkX18Nn5DzdE4q2SxlLxkEP1dz1l5jdIhD6oU2Y/lLXu4t8yVsICgZSd+ApKXBcdKPpOn+Cgc6b9ebOuRxh8PPXlxLD7lhjaJ21FvNxqNgmHdMUUXn9dF6+QL8Zlm0D3zku9FEL7ijClnqYVQIOrmJLl2Az1DNV4ttTvaDijHDpfoO3uPhmtDC9lpBKOEfLJCvQWyVc4QrC2bKtMh/G+fo4v95CyGYB15VMFLPZKBWs24ZQSl9TF+zodcVLMgsg4lipoxTqLZfugXSz2dvUwQXnaQAlDgfxY9ROnLM1XGutzi9ZjH6eUEgQwsG5nioe0AzNqyOFVr+L+godq4XBhM5N43UtEeB8dlGtDTwEde8nG4UJzFsO9CxLBT45EOD9HQO6tSfxAXemjIZRdGPNEM0GuuKuA5Wn/30yuj8ephjok3nzGSFOwY0RF6vET6b5qy8RalD+sT2uOGU4z3k3uEBM3MZGG7detizJ9pWx5Zx1Z9dXOBlw2wTM1u0grlnOpuIP6BOoL0CmsvO2gtD9xMCXhV9xXb3WUgc3C4E40ll1MmSMCU0a5w+NZ1Koy4gR7Ijtk9HyVgjZdGZUrPJgHKIfKnpa29lpiJIoTdWHG3sQ7ECx4k8zwR2gOI9ESz7VoDLyZVHGAkoA6gBE+LhTrQTeZQAqZOCK6x3Sw5g8bRFmxNeu/4F/cbLUNPKwprpsURVdBymoPwWYKAODr6BTLMgoBUQpMBHEiVZ5IiV6N4VWtIVL6yGcUHbDIKxm0nKy3wJrJWVFQwp++BxpgQK5khYNWZOt3rO3YEQVPRBH1ARvznM80SS2JG+fe4pJK3DLxeXmSj9UvEHB12XMqIPtybXkjuU6+DK/Fs5GnlEbsBS9lwUoCnsKbVqFK7vJVB6jmVNeetSDeoKToOVcoym2hsprwqgUHHC8k0Wmz4WlDwdc8nraOMQYiE9AMSD3Baed460c6C/fOCt4QS
 JOVtxLFv
 jX4ynPgrv54D7tt5Mo4JkVwFr+MU2SnnNkYv6rCR/PtH/hwD8+7UHtlvNcDj532z/R+h2wZTGdqKKqPjyeKUv8QAocasqZ8HluQTn+KwUEM3zUsYVI6eFqN6gMEdetFnurEq0jBBgOHkflT112Yot6u7EdrN5U2i1pdaTGbuitvW9ACLEC8Fo0xWwm/z6cs0vO8N/84ToL6DKC1T0akVNL1sPTBnvJUqewnXJuSGjJdDjT2JztrsD63wkVDj+IzEYPfqeHht0Kf5GiijxPZKays6WxQIOZ6jfTonu5PLHtGvB+kmz7WL6VrW1TwtbtHZG67sNVbbub2LQWX5lFwFtcmDHkhkajUjDamky3Nq+eg9fDvZkrECnzsfK0QKwR4ReXeI8+fSOgiZZ4erkHajVw30s5oe16vVBQRK4G7Mjocy9iC3cIkHis1FSJaZYjGIC1eGgLotjRT6XblZlfZHPvYy5R575SKdGcmunw6aogmbOH93d3ysWDzAtTXAE2NHauBy/9unjvwD9fHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 26-01-26 11:39:33, Mathieu Desnoyers wrote:
> On 2026-01-16 16:55, Michal Hocko wrote:
> > On Wed 14-01-26 14:36:44, Mathieu Desnoyers wrote:
> > > On 2026-01-14 12:06, Michal Hocko wrote:
> > > > On Wed 14-01-26 09:59:15, Mathieu Desnoyers wrote:
> > [...]
> > Thanks to those clarifications
> > > > My overall impression is that the implementation is really involved and
> > > > at this moment I do not really see a big benefit of all the complexity.
> > > 
> > > Note that we can get the proc ABI RSS accuracy improvements with the
> > > previous 2 patches without this 2-pass algo. Do you see more value in
> > > the RSS accuracy improvements than in the oom killer latency reduction ?
> > 
> > Yes, TBH I do not see oom latency as a big problem. As already mention
> > this is a slow path and we are not talking about a huge latency anyway.
> > proc numbers are much more sensitive to latency as they are regularly
> > read by user space tools and accuracy for those matters as well (being
> > off by 100s MB or GBs is simply making those numbers completely bogus).
> 
> It makes sense.
> 
> > > > It would help to explicitly mention what is the the overall imprecision
> > > > of the oom victim selection with the new data structure (maybe this is
> > > > good enough[*]). What if we go with exact precision with the new data
> > > > structure comparing to the original pcp counters.
> > > 
> > > Do you mean comparing using approximate sums with the new data
> > > structure (which has a bounded accuracy of O(nr_cpus*log(nr_cpus)))
> > > compared to the old data structure which had an inaccuracy of
> > > O(nr_cpus^2) ? So if the inaccuracy provided by the new data structure
> > > is good enough for OOM task selection, we could go from precise sum
> > > back to an approximation and just use that with the new data
> > > structure.
> > 
> > Exactly!
> OK, so based on your feedback, I plan to remove this 2-pass algo
> from the series, and simply keep using the precise sum for the OOM
> killer. If people complain about its latency, then we can eventually
> use the approximation provided by the hierarchical counters. But let's
> wait until someone asks for it rather than add this complexity when
> there is no need.
> 
> The hierarchical counters are still useful as they increase the
> accuracy of approximations exported through /proc.
> 
> How does that sound ?

Works for me.

Thanks!
-- 
Michal Hocko
SUSE Labs

