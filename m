Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A839CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 21:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F64C6B0005; Fri,  5 Sep 2025 17:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE1D8E0001; Fri,  5 Sep 2025 17:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3876B000C; Fri,  5 Sep 2025 17:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2186B0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:41:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC239119B9D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:41:04 +0000 (UTC)
X-FDA: 83856517248.05.FC0F40A
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id E8A86140014
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:41:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bn0ZNSP3;
	spf=pass (imf23.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=yepeilin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757108463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJ/emNLCJz3vxOzQ9R3rq9Yl2yjJO1c1zooZAILHbKw=;
	b=00HRkeV3FEIEmq7cNgtbXddYDV7Woz92eByZnM7zo9AhZjepcQXEqgV01n2pDUgqrQooSA
	hoZ9Ah0VGf8tKow5NQclS7RjpKhNVexq9AI7+SEGUcWm9RsLsTJ5du+wusJ18MgqlyIhMr
	R6W8PMQQExKGZDCYM5F4afJI49CaIcM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757108463; a=rsa-sha256;
	cv=none;
	b=kafbRyy8SeEBEHK9J+SRdHOfcn4aPivGeTE+0Pamnk1Tz9XPev4pFA/Jz5sS5oa2Uwm8Hb
	t6GB6OkJUxN9OFy3V0SRKKvhVUrkaHkNLvZbNwQAVdnugEU4Cs0LIER0aNi0B2ojWDLe3x
	Q2z6uWRjE9CVZVvVFbFXZl7jXTen7U0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bn0ZNSP3;
	spf=pass (imf23.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=yepeilin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24b2337d1bfso57275ad.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 14:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757108462; x=1757713262; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JJ/emNLCJz3vxOzQ9R3rq9Yl2yjJO1c1zooZAILHbKw=;
        b=bn0ZNSP3S579RnIJ1tOBiD/XQmnY7UVoj7MikZEJ6A8/Q0S1yilfiepT1sSNvVjUt8
         9LFQLzxmuYioC6DVzCI3yjCY7AkT3vdHu5cH7n0Y4ix3R23pkvZLbTl4A9GdzXERCbb9
         giFsWyFvXe+FMvUZd3LZ3OTDYO8xppoR+UPcpU8IVJYgSkLDKdVUHiWf/bOmcrutyPCh
         8If5ayXZ7OJ4yI6PTSOerDTUN/JF/3YKCpRbQ5DdpEphBcOVt1bMfUpQJSpas09qWc9O
         y1NrkkANbiKiKWnr0ZEHjCIuuEGX0Dnjoufc4UYurUxRxvy7O2gPJ95BqdqOdhfLxOVz
         U27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757108462; x=1757713262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJ/emNLCJz3vxOzQ9R3rq9Yl2yjJO1c1zooZAILHbKw=;
        b=E9BYvr7gsWchcW8Snxtah4fySHt6odCDS1AyVNmV/XsWuaAFHRvMBB+i3s8iKUYJZW
         FUiWHuWJgbkhx8Gd6mFSB3OKbH+u7htRFuaPKdMNDht83QldPYXC8QxviiGLqFRGF2Xj
         xxk+eA5y6brqARkYXTL0Ifqx5LcOz9iWSMCV5VCi6AVwp7RQtuyRx6rdO50wAzJ8BeSd
         gDbFLk3r2gZuj+kK1BoS4Uti/naMoJyO768FrvBqQxtWYin6bQJgf19h018wuSMDUN+x
         IZM77uLcPVs8PvEv1jc2xh28UuLbyvM00eThuEAgrpfoG9YsW4RZLxQJy1Qm8W4tL1MU
         4jbQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8USiynHX71Rz85bm9peCbL6HRuufSSFmXriPYqvLLS1wxKcnzsIXyeEVydGt3VDgAeuwPcMUNvg==@kvack.org
X-Gm-Message-State: AOJu0YxZOKANnRAAVptuRRFkhudKhCd1MBbtBFPkS8bwqcdW0PvF2gmy
	ije9fMjCYlqsDCM9BwRamYt39OBbgB+hl2yv8QBGSbC65G8k+jmDDc51q2n0cW1rNQ==
X-Gm-Gg: ASbGncuMDaA0eilHYH6YH8VI/ZBh+vCXGEy7/yfwcDCmFFPH/neQ8FIQ7YT3HXL41w+
	GdqDsysDWiiIdfwK9aebmoLm3QeJQZ1kYMpA99KntjJSGkNH4ePKW6pFMNEjFH8N60St85M1oU2
	5861vFiX2xdSiTuhYHiEij/kE4zIX0aLpoT4Xwzw8LJiAvMl+qXTRBc4UrKZjBNxn3iWeK4DI2g
	ZYhlGnthh2yYeIT2ccR//sYeBltWgwP0XYu0Cm4PTLH9xpWmh4/kvwUista6LKNgfEt3OCQFlLm
	bszES1IV+8NTzX83RHXRe4nqJx0VcDrm3vMHgR4mH0UXFqIGusjxrNSrOsSCqoyDJGiZZcORcit
	yE4wNrE7D4HOfpJzpwmFdL/jElw4jVoyloc5A2ie1asoBuk8kchRkGXJkwoor4SIbT4U=
X-Google-Smtp-Source: AGHT+IEgsoKeEdAOmf7V3AwPOG3rhylbsP/X4Pjd1kcqhKfVj8Dc8zkYrCPZC0GXi2o1KWjaV1iW6Q==
X-Received: by 2002:a17:902:f546:b0:24b:9056:86a5 with SMTP id d9443c01a7336-2517446f701mr288115ad.7.1757108461368;
        Fri, 05 Sep 2025 14:41:01 -0700 (PDT)
Received: from google.com (132.192.16.34.bc.googleusercontent.com. [34.16.192.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a2aaa70sm22678386b3a.24.2025.09.05.14.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 14:41:00 -0700 (PDT)
Date: Fri, 5 Sep 2025 21:40:56 +0000
From: Peilin Ye <yepeilin@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <aLtY6JqoOTMA-OtG@google.com>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <aLtMrlSDP7M5GZ27@google.com>
 <ukh4fh3xsahsff62siwgsa3o5k7mjv3xs6j3u2ymdkvgpzagqf@jfrd7uwbacld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ukh4fh3xsahsff62siwgsa3o5k7mjv3xs6j3u2ymdkvgpzagqf@jfrd7uwbacld>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E8A86140014
X-Stat-Signature: a33fd736j1k5nduen65os649cna5uc1o
X-Rspam-User: 
X-HE-Tag: 1757108462-157724
X-HE-Meta: U2FsdGVkX18qV0GzPB2jGjzOXjecexBc6J9fdZgFNI+67d9DMnMVPPzdledMGuQaTdU0Qb5wfW9O4aObJo9touz4v5XW20valu/12mw/sLaxlLwwlnDw1nXhH/lh6UTNN1fAIn9AmiWm9ARN6gqRJ+bu/kOHstEZ2jPEjrAqi6HVp3bnuPxuWRtCzHLBljcfI/ixFkcDYrBn1qqCpgJGqc4Ui0mqpJ7gZOCTdnNt9mdNqVce4Mi5z3xr3Ilv1LsN4JyAg3GTwNtqpg8zgHq94fV9/UqfcWfwS2kCAMeZn3gKqdxsJxN6db7U022NzGL83A/D6wpHUVPTMl2zyk/mXJdWWaFSoC/XCrCaaswqFuSOamlfFoOhPLNghluRZxUYwYqzWZultZ31UKrN7ETAs07r4bglM1JvOFUJ3K+ACkrE63WB97wsPM7qwf52DxAvZby1unt9An9pydFZlcf/t9SMQf7UypDszx2GeN4Ilmy8VC989IVBj50jTFPDdGD60NVDh1U7kf6O38fNygoL2iHE69ztroaZruXe8SDggczND2NXLeuBF9ud2VeyQZjwW2GnKfIxloH2G9/JzHvwSBjWBGCW/4dtEdhXTlSPRPlnf5eFboaZDa0nn02hAxGJlnVun+yUEoRu2lJh5TBz4S1HLYKYOVOvCi8ZlHGk3nrhQHQOASIUVxLfYSoRdsC2LXld81A2CrMhSoT0BgekCpTnkpwjkSAYWAtbN2DlK2Y7n2Sfyxt+a4j/lROnyFQRQZfoX4m4ffqJcu1P12IDHojA2XTC2wkDyeWYkZOiPRChLr0xaDhckktlguKWdoazXr1CqCtKH7U2oba+iLM29+LVtRIOwhWQBDae+QZxYw1kZDAE2+HkmauvOXit1e01qvd8XrmKSfSzAWATrW2P6fFuWIVDOAMvgdFaIQ0vB/+/yRH5LEvhvxBSfUwF/WKu1gCBkaBsQ9J+eFSBzji
 LfInAWiA
 5UQexu+8a/yxRhuhG8uPyRf0lmVca+wj91/XHYuH98NlNAitzGS51CalUyCUy49g1f2d4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 02:33:16PM -0700, Shakeel Butt wrote:
> On Fri, Sep 05, 2025 at 08:48:46PM +0000, Peilin Ye wrote:
> > On Fri, Sep 05, 2025 at 01:16:06PM -0700, Shakeel Butt wrote:
> > > Generally memcg charging is allowed from all the contexts including NMI
> > > where even spinning on spinlock can cause locking issues. However one
> > > call chain was missed during the addition of memcg charging from any
> > > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > > cgroup_file_notify().
> > > 
> > > The possible function call tree under cgroup_file_notify() can acquire
> > > many different spin locks in spinning mode. Some of them are
> > > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> > > just skip cgroup_file_notify() from memcg charging if the context does
> > > not allow spinning.
> > > 
> > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > 
> > Tested-by: Peilin Ye <yepeilin@google.com>
> 
> Thanks Peilin. When you post the official patch for __GFP_HIGH in
> __bpf_async_init(), please add a comment on why __GFP_HIGH is used
> instead of GFP_ATOMIC.

Got it!  I'll schedule to have that done today.

Thanks,
Peilin Ye


