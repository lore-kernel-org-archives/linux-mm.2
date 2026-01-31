Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAED2E7C6F9
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 23:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911926B0005; Sat, 31 Jan 2026 18:59:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE916B0088; Sat, 31 Jan 2026 18:59:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0596B008A; Sat, 31 Jan 2026 18:59:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 675416B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 18:59:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F5AA1B1DC9
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 23:59:08 +0000 (UTC)
X-FDA: 84393927576.23.9F1AF73
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	by imf04.hostedemail.com (Postfix) with ESMTP id 537824000E
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 23:59:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nWz5WBRE;
	spf=pass (imf04.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769903946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtBPPhj1ayBDt09op5lwhUL/PZ+SFYgWzXzV09l+lfI=;
	b=6OSGSW6lZInlCpC8u6rQKGTNYRVkKeBxd+hAoyJJmPYLrV5xQUI7iQy/DfRW6NcNVicyiv
	CQuIoC6jkRDrAE40ogfDr/S1Yjd7Emk31Umk3v07xZ9BowB+qf7fv80PjCvHGIGcURX46L
	GHz48MG1RKial2dAamPusQSiN4Yt/5Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nWz5WBRE;
	spf=pass (imf04.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769903946; a=rsa-sha256;
	cv=none;
	b=D0/8XpmQV+1SJFvUntL9/vrKiu0HcymvWtBhclac5GKhZ5zqIRUsov3BV0Y2ZywgbHaB2D
	K8B2rahyajDYope5+1eqVbVXKLput7GpRwcjOjl+uOMmOR6IOHtpnTcwqvKwTTB2XX2e3s
	Ih/q5AA/czgqAI6Rm9IezUCa5itLbOg=
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2a1462573caso61415ad.0
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769903945; x=1770508745; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YtBPPhj1ayBDt09op5lwhUL/PZ+SFYgWzXzV09l+lfI=;
        b=nWz5WBRE9YcGsQ3gPXfJ8A2RgZFKKZ0aXaI1u3NMFy4Lq25ZQJAYVPU/i24E1tu2Wk
         Ecng1fCyvUvKfOmHPHeFuvxXwILgQucrfSdaWtJ2hDL8Z3LjpgPedGDT+Ta6uynvxam3
         D7KYDul7E0hhpoinvQ6aFTa/4OFfYCOCA3ZeM7PVIF70rrG8mNQeV5bj3MBkJM0Ck0JM
         MzmnAD9DSeZLf0Otp40PXr+g/jqfPkTkSpHqYFF71vU6VQMvkfUTcfzewMP9AalKMLmW
         KE8VmsfKtNnhrnDcvmlcoKzao/SaGIXRz0qGb1goCygzj7IPVf70xsJ6bjXp9ZnkIYMr
         r8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769903945; x=1770508745;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YtBPPhj1ayBDt09op5lwhUL/PZ+SFYgWzXzV09l+lfI=;
        b=J11IA1frQpbAi4lUvGTA94HynVHum3IWd5ub1MeyS2Nxm9xXKVoP4bkYUtgGd+PnYD
         ETB2Wqj18l7y3Nfz85fcr/8dBixeBLz5zqM9rvV7JsUoUnK6bHypnk5/u+cAW7mLMQaG
         Q4XRUPkXhsIqP4v/5L5kqOLBpF+bFPda7mpWIW8ewzh+ie7JKtJlM+d7gtJ0buKJ1/qP
         +5hk3WsydIxZ/OA47RuSiA31CrGFC9/0kvYpgpgTebrdLkg6nKt+WFnCpQqf1rWwYv8r
         jr7lT/fPhHyNZuLMkyNDqRhXZzk5DxIS1+IH2khDdzIh/eRXNPH4SHXee32JHKxbh1DS
         hASg==
X-Forwarded-Encrypted: i=1; AJvYcCU1eN6fkzdDb5http0mzo2Eggir7EW7COSdy7JymWfB/GLaKE2x6GYMSiygKWHsWT5vODFLcla49Q==@kvack.org
X-Gm-Message-State: AOJu0YzdnisAuKQ3Op5ZAndIfNWr6fFX2LH3d3M2JeaWDOBw0k3Lqd26
	tmcA7roK0Xtp3TwJs7TerdNbdKQkaJQfeW12WsgdZrghN/M1W+IsKc911GsIk/b+HA==
X-Gm-Gg: AZuq6aJRhWANeid0v99c3W1eI+VMe3oMeOGQQBrSswwY99ARPG1yLSrfQVbIur/omPL
	ISc+d1FJVLKwFzEKIV29yCh2isbi/D9MMAThti1s13BYNVniTVtUGFkfnMNctU94ZsXqzMtXjJR
	Acm9e2Jmru+0FeIiIQizs0mbuRysZ5AlMTOy25EKW7PdjWCShARJ+ko8EtDDu0vHbcxpsS+hWCA
	wSllTyQpiJlwUloMpMchf6q7BuHD1Tj8wA5/NykGPjpZfRrqA5vSkd1qfOvB11Yh6J4sV9hbtvs
	KhModBbgbelBFno6kPv+7FN6nBvnJ+fXTeQg5QhKgsCfZYf7YbC0KWIWIf3CtaOCjAP/XAw0rs4
	A70TY8mbAAvtV3Pk8W6R28D4vT0CRIg1Cx2im1T4OmEULx78dLr+gygQb4DC2sx9yUVWjAxGXPt
	lxmcx7ZrM5PGjEDffX1bt7lvPynWFdJrc5KOI3AYwwjQCkLGHh/A==
X-Received: by 2002:a17:903:110e:b0:2a0:867c:60e2 with SMTP id d9443c01a7336-2a8f50d2ee6mr1807895ad.19.1769903944481;
        Sat, 31 Jan 2026 15:59:04 -0800 (PST)
Received: from google.com (130.15.125.34.bc.googleusercontent.com. [34.125.15.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6427da8441sm10057645a12.9.2026.01.31.15.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 15:59:03 -0800 (PST)
Date: Sat, 31 Jan 2026 23:58:58 +0000
From: Bing Jiao <bingjiao@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, muchun.song@linux.dev,
	roman.gushchin@linux.dev, tj@kernel.org, longman@redhat.com,
	chenridong@huaweicloud.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v9 0/2] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aX6XQmBncndLdu1X@google.com>
References: <20260114070053.2446770-1-bingjiao@google.com>
 <20260114205305.2869796-1-bingjiao@google.com>
 <aXlY04m0FuX-9LRE@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXlY04m0FuX-9LRE@linux.dev>
X-Stat-Signature: t8j7o9oes1zinaffzsykis6dqbetp11e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 537824000E
X-HE-Tag: 1769903946-146836
X-HE-Meta: U2FsdGVkX19JgdfROeAEE8RB6p/Y55yl12js+6mmtBugmgfzwxrk7KbVkkbk7eqEf7Hl2j2aE8vGZCpQ5F8jSkn+UEYdszx2xr34glbVV3DqprwuDej35KbM7h9JsUA9P2ocHugSArg83OFajGhU2VCE++rhQof+CYec5gtvzeUklBuNajhGEr5TgrzxKBFLKIHrDY3cAJ0cHeiv//ZmZuKWjHn4A2OngADUvLfFCHE7Moxx722cPBZHuE0JjYZK2VXvWITUJB5GRge0M1M4n0198KOpv/MS1bh4H2sIeCTmWcdmhUs1sVQKC8q786gskv1C1LsK6QiTTBUjKdA9C1TtDOauiE8r7GFCYg2+uotOb/15z6Nem9iDOi4rKhyt1eH932ckSKb+Rli2Ez5TnmYrGer6qT+kfXKroDaOMgpsp7c9KiHI3fH1kBEmEREmyATVx1MpkP169opp5hwgmSgJ63ygnjxpMc5OIOcmZpGAFdhF/xOR5YwHwe4cJBnxOmEhOZN6m0SmNGnimvVMNIIQSUcUccBvek208LXruDltK8lyU5F0/XOIuxdpK32/RxnTGgAu9S7ykE/Utw5bSA4mWQPx3zQT9bM4k4SKvxvNfnTFVCh7wIbDn9VjZnMx8BqLY0Os6NPy5RN0q3/bQWT2YcGlt7Tg+3xJ6JQ/7hqnBU+T3BFikE6Wxov27qEjrM4VNeYRyE5w7mk9CTCan+RCNHKYqThYZDp+ct5aBYAtyP+6VNDQc35lmF+s6VJ8mo0gx7i1D0t/QiEQkvs50AkkvRuHjQcoXAzGrb3XLuEM85L/pl4vt6LbtkRn1GnbFOriS1vkGsOfLA3RRtKWVlhhT7YW1spa+8xfqSfTnSVZpZjkEpP5DIsGF3A0fU3O5ifwTRNLrMcEcaUQQw+lHJmrl63HVcDKWopzIk9zpzPhglRFOKnT9ySgARndoGlN9q7cmXqNbYjn7pO2GoH
 ctjRbRPy
 CME6/kG4owGQ0WJI/RR86RbyhmhubAsq5sC7XtyXoT329VMayDN6NlKdoNWCGXLgdh10d37fwKrDA12vPmiHTmMcTyrS5i6CeArf/Peq7aw6LmwUSGw9EAsv57MlkDWoBPwBpAAz6bY6DkophducIsI5v3sVCwzxO7LYAb/4uk3x4nxKLreea3CzD7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 03:35:26PM -0800, Shakeel Butt wrote:
> Hi Bing,
>
> Please don't reply (i.e. use In-Reply-To) to older revision of your
> series. Send each revision independently.
>
> On Wed, Jan 14, 2026 at 08:53:01PM +0000, Bing Jiao wrote:
> > This patch series addresses two issues in demote_folio_list(),
> > can_demote(), and next_demotion_node() in reclaim/demotion.
> >
> > 1. demote_folio_list() and can_demote() do not correctly check demotion
> >    target against cpuset.mems_effective, which will cause (a) pages are
> >    demoted
>
> pages to be demoted
>
> > to not-allowed nodes and (b) pages are failed to demote
>
> page fail to demote
>
> > even
> >    if the system still have allowed demotion nodes.
> >
> >    Patch 1 fixes this bug by update
>
> updating
>
> > cpuset_node_allowed() and
> >    mem_cgroup_node_allowed() to return effective_mems, allowing directly
> >    logic-and operation against demotion targets.
> >
> > 2. next_demotion_node() returns a preferred demotion target, but it does
>
> does or does not?
>
> >    check the node against allowed nodes.
> >
> >    Patch 2 ensures that next_demotion_node() filters against the allowed
> >    node mask and selects the closest demotion target to the source node.


Hi Shakeel,

Thank you for taking the time to review this patch series and for the
helpful corrections. I also appreciate the reminder about the patch
replying rule and will make sure to send future revisions independently.

Have a great weekend!

Best,
Bing


