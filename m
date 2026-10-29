Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E275E606A322
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IDm7FOcC
Received: by kanga.kvack.org (Postfix)
	id EC1CA6B05C2; Thu, 29 Oct 2026 11:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72636B05C3; Thu, 29 Oct 2026 11:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62556B05C4; Thu, 29 Oct 2026 11:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A47096B05C2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:18:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 315664048E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:18:13 +0000 (UTC)
X-FDA: 85376019666.23.7CCBB39
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5D9722000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:18:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IDm7FOcC;
	spf=pass (imf03.hostedemail.com: domain of error27@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793287091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKclWe9kzl34mf7ikCBlpHKdvGAXpEly40KTRKr1ZNY=;
	b=k/VqCMv8Bp+MQQFt29+V1WzVxX8R2MvjPIb23zo7uij8go7rgiIij8PfI8uW1vN3E4XfZ8
	yGv2hBQTmJMQgVnvHp8VVVynnaw8XkrsDoIYWDZ6YeW/XRXzv6NscfpKvBkLuc8OTy9Fbg
	RvdxqL+yOZVLOL1IO9+1OsAbLQvZibA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793287091;
	b=Ku//maFi0mk/dePUVyJ9KyO3xycC6qcLHOH3DS3icUrq+uPSFlaYdCWxva1vRXqj+s4a/J
	QZN6v4Oy+r4r+ENoZZu3rrOeSJMxQUrpfBNJGhn0fVX5W7+VxUcN8xJFJiocoP2kjCy14Y
	eowGljchc3UHiQJzqVDZKCX+gvojGGM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IDm7FOcC;
	spf=pass (imf03.hostedemail.com: domain of error27@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so22800295e9.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793287090; x=1793891890; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XKclWe9kzl34mf7ikCBlpHKdvGAXpEly40KTRKr1ZNY=;
        b=IDm7FOcCwOyAMe4Z22TT/uRFprFTtXtCIAUPHAfD3LeYavBSAtTr9hy9J8O8UpJax9
         9cB9DloExf8ksEh/3M3cCjO0Y4tbELFVaevbFanEX8IA3Myycxld5HZcbs69kePUTI1I
         I3cWtOT79eFsxe+xJlj7S2PfEO7WmtZ0WRSGaksoQFUCSA3VWZ4UrwytUGt1BPJP88ri
         QFZ/Wdicwo4iGTNxlthFFZeEokPD0fF7ErqJhKwoO26YeGXf2qk74oWJsjHUb/lkRmQ9
         lr2za2kT8Wh/CXaiSvNi5Bh+K2/X76+Sc1ZzMhqwEhbDx45xyNH5YndVzRtckBFVUNOk
         CUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793287090; x=1793891890;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XKclWe9kzl34mf7ikCBlpHKdvGAXpEly40KTRKr1ZNY=;
        b=GWThcutpvrvETz8sVeLoS8LSEO4nhsaIBaW3PMGAt22Mrlt1cpMCi1DNO1Lhrjn7sg
         tmfYP/5L3WbjF+cxEpHbxuUq202HyMl6gYixSBXXdNBk1a/38NYtiDZqh+SgNGGjOPv3
         5CRlfbOduxJ3qjCzZsFARAIJShcz2OvKe2bP9VJ84T6nRSaR9Z3+5VerWF9CYz/Qtesz
         RZyXtMo4sVzbNbQ4II4mC4L7WOUs0EcqwOee+zHYIRjPjW7sBJRcoF40izn3LJvWsbN+
         cLDeGfPGJbDaUiFUQE7hYEkhd6yRcf8PKOWvSO1naAKGjMHnmJUZCAP8GgO/51JHnxr3
         3/Fg==
X-Forwarded-Encrypted: i=1; AKwUvBw/eYxj2IpwkXBf2+bEA7Zt44PDFq3d/oM1UZcJNxOS8lozqjSU1RQ7iKJKpEapFRwtFVwryLWT2A==@kvack.org
X-Gm-Message-State: AFq9FYKZAYjbAAuof4B6GYzypezhvRfuT/XW6NrwWThrMW0k6Y1p9LeP
	EdZiMolHmGdniZnjfaFRLveH0L7VMzYMdEOKeOchryvbO/jh3Stm3GH1
X-Gm-Gg: AYBFou2f3kIYcDM3l+20Yzh16FkEBU65lm6Lzol+VGcOJNLRDCIr9Hp1aKAhbMyuK1Q
	7PKk/8h8TtyjOeapDotrP7UHKlh3rZWxIMdIqTIdyYKdKjQejDts4JlyTeuqGaZH0zUhk3Z6uJX
	21fxeYSDq44zRN1lYGWeOFb0OCFg0cV4aH3p7q+Vn0UapDKqbiKZ/q5IZ5+OMMARqEi6A+JSsKS
	7JPVj2XIeh65KK9IidPuJe/TLERYaDdR7c2CPWjyFJRM4E/wvwgbRlen5vQeNIcN/rTRjrPg4Fe
	vLwFpOb/PPTkjI3dZ2tCbbGnr6zRURUAWMG92TrEc4Rxu+hGx6xT0S8m+i26PLDn5hraRNpvItg
	qQ1SdLeTKaryOTWkQi5SZB8ZPu2zgOsg1y0O3udH939VQ8/lkgMPtyhOIOXYtZZJAC/ewbPZVTp
	FInrIoxeMJpC45ln0amIsMbT7oADjNcYjrbziDSK6YUDHJlSXOMYGt4xsoKga+M2+sEI6MM+wUZ
	NujIARpJnmnSM933HOwt7OHecPR1W409AnQGXIpk/AA/HUyT6gtYFk6wgBBxclmbj+Gs6f1NZJi
	9Q7vYC9WxfbWTkx5s7oIUDm4PdRgLv93foBTAqmJhUZg9HyyrlfMM7/hCTtSTQhQXXSEsKKbB+p
	HZjXSsKpRxvh3SEYfxTdsaixtkhz//5FRV7ZnJ5RDey0keepdtDqmF0kJrgIgEm93exA=
X-Received: by 2002:a05:600c:4f89:b0:4a1:c6fd:4db0 with SMTP id 5b1f17b1804b1-4a966c41836mr142852995e9.19.1793287089736;
        Thu, 29 Oct 2026 08:18:09 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a94f05e4e4sm87571055e9.3.2026.10.29.08.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 08:18:09 -0700 (PDT)
Date: Thu, 29 Oct 2026 18:18:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Xiaolei Wang <xiaoleiwangxiaolei@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/tests/sysfs-kunit: fix leaked pid reference
 in add_targets test
Message-ID: <auNjrR4FyTf4WbgI@stanley.mountain>
References: <20261029075609.35661-1-xiaoleiwangxiaolei@gmail.com>
 <20261029141040.148392-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029141040.148392-1-sj@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5D9722000B
X-Stat-Signature: dicxgf5i3bk6xjz3q483go8zkaqrggjr
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793287091-325694
X-HE-Meta: U2FsdGVkX19chI1CUf18peQlK971kSiGpyuu48lR8D2WhT2ZEV8Wj7Ba7Qqivf2tKfXkShBwHsNYVefFkDKh4+E7do2ljxfMBJqsBIvne9u/8AdyVpa4Z56UlSPHCKQkogwkbgkZALJM+64rxNfvuMLlp3YQIuFsH9h8u58TEolTipaYph3c8BaiBpx3q1fcubYv2FCt2jtsnrnz8qj/7aKK1gjFeA+IvaSTJhXcFqraD65/xTed1aHQA1pnPpvr0uMb0XcJP4PPfnNq4R8ELgRvj8LDag9kqJ0YsnlP2prpEekGZ8IfFg9B8vc7NUic+yn0awlG+xIgtwoeaNBhrSLVJ0KrtYWe2L/4S22kTQ5UvBSb0eimLSoP1tTo07ZU3rmMx5Tby3gbwvbSJH9p7itoxApnSKBm1/mRiqq+yaO0X2CKSM7ojXstaJRUyvidIi8omGGdeVfXP35oA1yZMWLbloqoChG0ln9igg7ceiq9G8CrDsDvQabaqQg/ZXA8UJ2MRr20Kinmq17M8BasPCePjzRkjvuVI91mrAGTs5SFZAXub+G+knK0u0k/2BtcVXTGSSccsXx7EwCUTs31EY6pjD+ds8hS+dzhhxvnUcSXT1C5xJOrNg1sfjsIXI/aLQi8fro/zeK/wWX/rOkMJi1rOY/UuMpwVRxEcugXq7vQl771rCgLC2ZSw9SkAXp0V7QSIHMWEin4caN08+d7gdZB6/LEWZ/fQVrxk+rClaVJRrc+ysT3nwcp2VfnfylM03/rHnqfuIu6rF025pkLdP28eMRk+aRKvGUCSb/4h+H0X9P+/EFroziR7t5NkkOewE2wWiaqXYy8g6z2UGHnyfldE99fLO++Xa/Ki9i5gRFAQ8oeF4JyzGvq9a1cgNSHinn0D8gd9EksgGr5L4M1FOd39lzTrlEliNnGfH3cd0HZ2/pV2osDCQ97imGrMGQfbxzv64ZyDWOvbOvZZvr
 0AIzZyol
 Yx8uoOlyWlnNwGasKZmAS1mgNND8yswfz8KY6NY7F824LQGrqZpIf3VS0acQ8cFaOAavWTBKoHA4wV2srCnj2Uxxv57aXPnloHF0lQnVUF7N8sBOtHIm6rIbmhR5YvYmE68in7QGK72VOllfTaa89upDUdKA3PlYQg+5ib674OBPoUwP7x5R2FnKGPBK7X9vsuK8/2HA33BANLpkrHSWyTT0x7RjlnxcvSfrX+glMD19Y+GilZhcofZjiGEOFmXI/Z0VMYP5UTG2b/KPur+ttIfkjjbXsPg41T3tm0kLO+Zv8SDzHvSaQRUiIOEDIembANzzquNcJcBw2emUPIAxf7hOHl+6keN1Bp38BzlulS6je2G9z0CJzDWuZviZJypqsv9QamNZJ6gL52scqa0a9vIefR12HOL6YbB4sntg9odLW+Gd95XM5Sy906suFon86mlELnIBLJBLXZxoT9seQf3yx+3YCAEgAIhLQK2a0bhsUJ1uIt9l2Ztdu8d5TcPB9QAa59Luv05IYqC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 07:10:40AM -0700, SJ Park wrote:
> Hello Xiaolei,
> 
> On Thu, 29 Oct 2026 15:56:09 +0800 Xiaolei Wang <xiaoleiwangxiaolei@gmail.com> wrote:
> 
> > From: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
> > 
> > damon_sysfs_test_add_targets() creates its monitoring context with
> > damon_new_ctx(), which leaves ctx->ops zero-initialized.  Since
> > DAMON_OPS_VADDR is zero, damon_target_has_pid() returns true for the
> > context, and damon_sysfs_add_targets() therefore calls
> > damon_set_target_pid() for each target it adds.  That function grabs a
> > reference to the target's struct pid via find_get_pid().
> > 
> > The test then tears the context down with damon_destroy_ctx(), which
> > releases such a reference from ctx->ops.cleanup_target().  For the vaddr
> > operations set that callback is damon_va_cleanup_target(), and it is the
> > only place where the reference is put.  The test never selects an
> > operations set, though, so cleanup_target is NULL and both references --
> > one for each of the two damon_sysfs_add_targets() calls -- are leaked on
> > every run of the test.  Running the test with CONFIG_DEBUG_KMEMLEAK
> > enabled reports the leaked struct pid objects as unreferenced.
> > 
> > Fix this by selecting the vaddr operations set for the context before
> > adding the targets, mirroring what the sysfs interface does.
> > damon_select_ops() fails if the vaddr operations set is not registered,
> > in which case the test cannot exercise the pid handling and skips
> > itself.
> 
> Makes sense.  Thank you for finding and fixing this.
> 
> > 
> > Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
> 
> The impact is leak.  I think we should add Cc: stable@.

I wouldn't bother Cc stable for unit tests.  It's not something
which affects production or real life at all.

I used to be a be more involved in testing and the rule was that you
pulled the tests from the latest kernel and ran them against the stable
kernels.  It feels like that can't make a lot of sense for unit testing
so maybe for unit testing we didn't do that.  I can't remember...

regards,
dan carpenter


