Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F61F9D0DA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64526B0088; Tue, 14 Apr 2026 13:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B143F6B0089; Tue, 14 Apr 2026 13:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03006B0092; Tue, 14 Apr 2026 13:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3A46B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:32:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB50B1B6DE3
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:32:56 +0000 (UTC)
X-FDA: 84657856752.09.A2F40EF
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id D135014000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:32:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hvoDx/Nd";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776187974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8VROB7nPEHNUyRB5MclbcMkN39zlz8ADjK6buJJwrg=;
	b=tb3axb2qM3tS9bwwjUVhmBhVDnTYJX8yufjfTGT5EK4FnBxc8+/O7k6OZhj9OsItFDm7bX
	PPDNEyIfXKISAZa0KY974IqQkyegsLQ3REJp632EL1PN4JjKDtaR3hTHoRlHyk9iFeIlFJ
	JvbGizkhJq74ThnBGKIczF5vI2AFEdI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776187974; a=rsa-sha256;
	cv=pass;
	b=CzWYzl30ycjlQ3ogBq2hje1IlBM7O3jcrBmb/7aurg4a9jkz0UtuP97MIluqJFQk8XThvq
	peo1QMR60+z2HCeSfcYFsVN8XEf8HJp2LMpHlgE59qV8s7XVrjILdxr1JtU9x14FIv5r5O
	uqq+4480zCfCOCbXXqhMx+WKObvfFW8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hvoDx/Nd";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488b00ed86fso60917655e9.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:32:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776187973; cv=none;
        d=google.com; s=arc-20240605;
        b=YjdpQ4WazksRRmgLJ2+Isg4DpVms8eDCYpOTi8m5XJQCyXrBXGDLo/J9RJYhCYzBJj
         YluzjhFto9LPNYffLY1XT5uObAlooL6FfN+vQ26mSQL3qM/7RaSQs+26dsssFqLVDfG1
         P8l3/XG1s96H6IePhyyY4EYXefUvgnLkIA0lttPFq+IGkFoTFKWg3SgUPcVZKXzBHktq
         t5QS2mqpXrmj7WWPc7U3yEUSyoBJtzT48r3shuIvONwwfO261lUdm4VIbpNpo6ymzKRT
         Nk60jtUlkgU30X7JwvUtJ3mT9Ygn8EiMiQzXFh2QoO9abKeH4cnnvN99D7Z3IkIJJXPf
         2Vng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c8VROB7nPEHNUyRB5MclbcMkN39zlz8ADjK6buJJwrg=;
        fh=q5iQrwYgN0B2GgLt6KJLuSdpBm+xWo5fxpO43R7kw0w=;
        b=OAwsEznU8XVaqaWKTOHZ+A617JfEJZPZJMixoHEwmLIIUjReugHLduONuCnoG7pWMm
         zI7F7YYfqJNyh6F4UYH1eGJvv6zoDf/JFFoaH9znV6rmUn3PxZsXaOq4AGPpf/Y5RsMI
         ZbMbaXN1hyGO//8uJeRPKcf1BlB3vJShDudvpNyF30MsC54GKG/HqUvmZv94bMp47XJm
         BRvElcGsqnHFzdZPwxvblXcrcxbQ5XKc1miKONcwkcJbh/lPPtiudnRVajdyzFDy67Nl
         COSXyx8z1RPS+30uMLk8GFJ3eJLbci12JkPgny8SvQY4S2AqIexfooZRD/QDCORFZuzy
         ZIvA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776187973; x=1776792773; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8VROB7nPEHNUyRB5MclbcMkN39zlz8ADjK6buJJwrg=;
        b=hvoDx/NdkiOWr8KRf4I7A7OLmTFwZOVZTuYy8ddC6ipWmi65W51vi1C9OGEY2CLJ1K
         Qw9NTFeaRkj8XMKPvMXBdgtSMWHV4JX0A8BxZJqjvpFut+KST+dL8AGXa9qTezvA1fuY
         J+Ccl+4AGsBYohG9xa3BJKbzIc4KSwnM+yMS3YTO0CZ9/jhziNjNlpvVGRrnXLcGhknx
         V8XRZe/Otu3kJBL7AzCfKPt1nidHtFw6CVMvxCHID5n3CFmFb2rVncdW+fwWhvFz9xSx
         VGGOwnLgclYC8VXt4JLe0Heb3lbVJ2D1tJ2fkxfQLgVy/2AlaP5dj48bTTxilBF+//pA
         TOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776187973; x=1776792773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c8VROB7nPEHNUyRB5MclbcMkN39zlz8ADjK6buJJwrg=;
        b=W2z8NVgPJ9I3x8N4it+fNIN9Iq7EdMie2XXwDW4Z9PM90mAQvb934ek5wNYXiYPf5T
         2PzRVKZnguNNnbfCdxRAj7UAC+Yg7CQCUOuqj2tsm+K9wa/KQ68N94Q9ImyjkTxoyHWr
         nb8o73Lrll+c4PADzV9tcal8yiwcO3tX1sC2jaLpkOLG7vWn5ufGoeh4CqhkwGvcB+5P
         hcpEWWHz8UnJqFs0pFOE8+Ppu4bBQd2I010GQVOhk2l2Uy5Wb2rpNT3V5w4Uq44SvXFK
         1d66Bv7KDtPgSI5Xc/uMPBpL1OAQaQcbSlivsIP0pS3ZRzplAQoBaOi6Un/xmIg29O/X
         9YfA==
X-Forwarded-Encrypted: i=1; AFNElJ8uZs1ZLp6IDOEGUn0i5K5nSRNBhVv0aI1PCcjr8BXKk8TGl95mnSSkfRhQOYa7fabMqnxHPePFyw==@kvack.org
X-Gm-Message-State: AOJu0Yymlp06iHUdF887AZNMCsV1chhql1qq1tckBq+h3N+/JN+6av/8
	NfW3w1vaPr80vb7xfPqRbxNiwrfhpRd+SwTqHhvjCGUFlMTDA8n1bUch6aEAqHN8Db4V+HlEfcM
	4V8uibw8aWbsXpeeObrkJ/D4fkpTtu1o=
X-Gm-Gg: AeBDievJ70i536LsYcPGvIF0Cgex/kayVOzl4JpJceCtWExEM43aWqZCMBhkTe0cidR
	V9L9rG74oK2tNgjQKtSL15i67DXsTVolTxmxF9bYYFnr1clbVbdDYh/rNZsx3Enctw8TGyS0mId
	R685Ag3+3cN55ek5jVfQFlvXYE18VLV2HJcXAFCsQ3kU7xj+eQGR5SRi+pxXtyaHkMRSNIaV3rv
	lnCXew1m9lB/p+eRcgpNXG46MwZfInqDmNWHrGW6hIBvikcOGXRt8XlvZHv/2VqDMOzmR4u+51+
	wKcCkxwC2C42B/ySYmSh3kOyQs0aOqUSfZcnebA=
X-Received: by 2002:a05:6000:1ac5:b0:43b:3d02:7806 with SMTP id
 ffacd0b85a97d-43d642c852cmr27633427f8f.28.1776187972920; Tue, 14 Apr 2026
 10:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
 <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com>
 <CAMgjq7AzySv801qDxfc8mEkEsFDv4P=_qw0rNOTe0n+qy7Fz6A@mail.gmail.com>
 <CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com> <CAKEwX=NrUhUrAFx+8BYJEfaVKpCm-H9JhBzYSrqOQb-NW7QRug@mail.gmail.com>
In-Reply-To: <CAKEwX=NrUhUrAFx+8BYJEfaVKpCm-H9JhBzYSrqOQb-NW7QRug@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 14 Apr 2026 10:32:40 -0700
X-Gm-Features: AQROBzCXAeCqcScOKrvPHFEfL-AEpSgsJNqZGDJveRabXpX0aHvntrnXQgowKrw
Message-ID: <CAKEwX=O4VJzHGqJFnXOyUhamr5-hckrd+C=V8+f-Lz_HNtaJ_A@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D135014000E
X-Stat-Signature: 3pfqy1sxhyw1majmcjbmj47dbuoqzfgf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776187974-114488
X-HE-Meta: U2FsdGVkX18lvL4CQqhfY2AW0315pQgj69uOw6aDYIe4fno20mtRSoSkwin/VPYAgWZ0aXcDJLWl8yLatY7eysFmciyxfSLxeeLy0s9cO2bhmtR8NSNrNSOiobej5arfkZCP9zWT26OhNWd3et7wb3VqXXMSR0Pb745r+WK0fvlc814dPmRZj6XBWMYsqEw+xF7+LJAhnJor3nK6x0MJrS8gt1Bbnap6pQGYikv5ehwEzd/Aq+YUw+R6tygRlQ24qLX5scB51W33NvptPhxfMe/WoOZy6ZDffdvdtGh3QF4sk6KwaLIS2hlT/UdbYNQY8g+JpW+PgUG429JSjgxFI5Bln+9XXGjP2XYPbQUCh/HNlPA6iOtktLZW4s60HtnCaPKmyY2Z7koDrp/oOvfneIkuHNOsWav1iIyhnl/avpEegkQQOO8X7SYlZwTZnkvW6fwfGkHBM4Gl37qy306c9j1QdaqhG28UMjMmL5YHUwYKNyIGkiU/PIrWrDQPMImxz4IT/glfz8EGGe2tACT8lB0lCY08IM7PmPHPWTj9GNU6Nt76BRogNhgVsdJFmqm/C+129dNRg0oQeSvG0CV5Eys7UYLym9P49ZmybMfyumdqvWJr2g5g0d4b1bKssG9dA0X8F7BZvRJLmsDQ0H7JMnzY1ag8uwZhOfWDYHrOMsUqcMUz7rqf2dVOip3kVd/mWqtneshMYhwicUgXtevZBKzt2lmgRCxSJc6UZrMC1cpHhfFq+mKRU4KVDUdjxhSZgdDhvMnQ6Ki6ZEvSWwaZGwVf/QENmYCJb22BbYF8aN7g5dPfurwSz4T9IWxO9L7k34yNsOVguZuMdWTj9Ls46o368FPUwOh8wMvVk5hcMHcK3UMspFuSksiw/2rQ1wdeRPxXuR15cDke6Bd/gWSMV8XepP8rGAK49tUtkXmbQTKiIS6oqUlnoNJeNtlHihXqRjFBwpedJuEZG7ApIF3
 lkbZ3Ci8
 mIQRwkFiEyQbKGxnDfoawqoALKzXJFzajHezWV8Oxz3VrBqBjVhuDButsHnLwsQL+JB6rftrOE5mSp/hKcXIqm2L8HRU4bsGfpm6ajzxNMIavyVcFx9Nydty+N0647mpPhKSfezE5I+v4xvVUKKMb+kCMbj8+FKs2EDB24YyJhrYArxnS2uX2e7TB7xPjQWNk6TUeYgqhhyb2ChPdMnAaPrEVdXuSNM9joc3Bzh8wx90XTydlGvdp1DXzUy8Cicp3X5fCe9d2sSmUrCIkShPfH+bkvttwpJo+Sdq+MVhbKuoHnMrEIv6pcZki7KiYceByqvdr+Z3AFfYq/SzxwP9MC4YXMb/hy0ueAnd7rbwEgGCeww6wveTHTBcO5G438SsplYcwdOpHJdcfWBCyozeRNJRUXvdgvmZrSZB6hWMvWJVk/xbk79Kz2npHyxdYg6bcca5rjd7vtE8zyNeybCniDbYCmQ+ByXAQ8VvyMEBibV7smiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 10:23=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> * I still think there's a good chance we can *significantly* close the
> gap overall between a design with virtual swap and a design without.
> It's a bit premature to commit to a vswap-optional route (which to be
> completely honest I'm still not confident is possible to satisfy all
> of our requirements).

And to further note - these benchmark measure, in effect, purely swap
overhead. In a production environment with a lot of non-swap work, as
long as the gap is close enough I think we would be fine, even for a
hostile case like a fast swapfile-backend (I assume SSD swap's
bottleneck will be the IO mostly).

I will stare at your responses to see if there is other benchmark I
can play with, but it would be very helpful if you can share your full
suite :)

