Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F77F10F2867
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 19:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0EF6B008C; Fri, 27 Mar 2026 15:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6982C6B0095; Fri, 27 Mar 2026 15:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE6A6B0096; Fri, 27 Mar 2026 15:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46A826B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:43:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9659E19AC
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:43:41 +0000 (UTC)
X-FDA: 84592867842.06.19F7DAC
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 12A3220008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:43:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DBC2+xN9;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DBC2+xN9;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774640620; a=rsa-sha256;
	cv=none;
	b=RH49pUsfs1hGq4+tQ3UcATAIL1lQ9Q/Ci7zn6Jv1r8P8ubngVQD1RvOULZYIwFqXy5v0Zf
	NkBIAPGdmnhmp7nypotlP7S/x2ztqmT+g788RzYH1yC+6y+SGafeV8R0oNpN9MoMRVlGAJ
	HmQe+ETDszwN6DBeGG8gm7j+d5WKemc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774640620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ycsjbas8cC1Onl2FsApYb1y1z6bcYUHR+E+PGpMszI=;
	b=TL1RN95UiEFdNvIrLwwmWRSvLBhLCNYjdwgr9eliWR/a0y+WtvIZPPxf+piuyaHcQrydfV
	ffrvxG+2A8U4vZiT0Ny8SM5/gcZpgFy9qC9fkQBp9jGenxI6/ZlQSz9Uj7Rdpl8pdibtOy
	W3ietLrqsb+yPX2iDlHIn/mNEIgNk4Q=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-89a05955720so29378426d6.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774640619; x=1775245419; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ycsjbas8cC1Onl2FsApYb1y1z6bcYUHR+E+PGpMszI=;
        b=DBC2+xN9p3AcE0AsXrEv9qRmtLx0Zr13+iNmopSwvbpZGjyP3t3vTEXveLDQsAKnOk
         ms+dWXSM6FtzHYfpKZI4iUVsJdaEfyCI+ATFW7JNiYR0ylCwuSwN7AjCePWd1N17Y0IX
         b8TUXQtvYsWLk6HgYfaCkLj0scoBNttVr9Biu0twpsaGAydUl0WlgfVv2g05BO9HDWgr
         oWzjHvv1rPKMll248JD6Zf563DlSn9qNwvs3W5+lh2ValXja+HGQ0zvFy94wRmDEyI+J
         rCJOAnZmFI8zJGmjd1HQEqnfKIhX/gQIfsnUcpocpgTVLqvbGywHxYbVMwVw6qyhb9Se
         iMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774640619; x=1775245419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ycsjbas8cC1Onl2FsApYb1y1z6bcYUHR+E+PGpMszI=;
        b=BlJ3uWHYKABv/pMj4RheRCupMrg8/5kWhM7QTWEmjE1dzCELmWmmg03NdYudGqq/Md
         +SQ3MxkvxqTlvSw9IL2GuMWx2dZsrxjYsWshtvLhEu/kfk8xs2QBGKxg+WQ68zUF9m/Z
         2GOON+0IFKaP4efs1puNcJrl54DbpYuX6GJKMQHPy08UiKnOTNT7UJ2eyfwN5zkT37JO
         Q2X7Q0np/ZU+dCx02kJEjHfFK09nIlnJldhToEMNWEzaLa74hosrrw++YccJ5102FX8h
         +gIFGCCD49JalneBciAzProhZrwVbLp1n2mpJQC6WtbnNdFM3kcOaVKdUinD3nCuqJh8
         nJ4w==
X-Forwarded-Encrypted: i=1; AJvYcCU+uWYkESyAvhjmk7BcnsXQV7aVKocEZKVhJFKote/+LYAEip5mQeYYOr1DM7ZLOYr+/+nD/1eHHw==@kvack.org
X-Gm-Message-State: AOJu0YwW4tF5BOaNmYJL36S9enr+Q2HLIUg9BUtNseMXaK6d7I6HjNl4
	qrZ1HVZxN7gmz6r4O/8uDKVsqn7rgWjO9vyT0u5ys/Nu376No6kX7k0Vy36dxC6oDlM=
X-Gm-Gg: ATEYQzyceb/CWLo4+w7DYC7AiFOHAAwHji4g+Npg9xoUqJUwS3XNpPVqRE6igEEsKJT
	/vhdGHOmPm8J+gbaMcTAiYmsTglRLeeMmC7YBQwXJhB/UU8pLk13hoE2HnRVtA0gBcyxZeSP4cX
	+qPYP3prNiTfjVLSWvvupMdpcIpT/cR/iqZFmN0Sgx/+8Cwsk/nKLVazv2ChoGsb4XkbdYnO1w1
	hDuF1KhHSfBV/PBI/TDqZNtQpDYhtqp1NelXn9U7e4QjxlMzTVDbprlHcitG+txZOQgpyJ4+bmL
	BnKt0TXR8eKGd4bORc/3bDavbJo9Omlpy07f8EOyB9aD0Yxhf2Q4rtHEI76XsyBaz7c0fkLowkV
	sjH2i2KW33MVHwdcNz6zWVD6+QX9P8Su/16MNAkagxrNNyGi9sWvI1MAxsdxm4FbQhQ5zwx/BiS
	23LUhU6XyNpstAhQbsUNOZ9lInO/58GMdOK9AHQXtoSxlfW39gsr9OwwMYvNrX8fBw74UzoK6Kl
	l6f
X-Received: by 2002:a05:6214:4901:b0:89e:a170:6af2 with SMTP id 6a1803df08f44-89ea170721bmr11920846d6.41.1774640618959;
        Fri, 27 Mar 2026 12:43:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (158-94-182-130.mclarenap.oninferno.net. [158.94.182.130])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecbba4bd0sm797206d6.11.2026.03.27.12.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 12:43:38 -0700 (PDT)
Date: Fri, 27 Mar 2026 14:43:34 -0500
From: Gregory Price <gourry@gourry.net>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Matthew Wilcox <willy@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	lsf-pc@lists.linux-foundation.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acbd5lKEh8xa1IQk@gourry-fedora-PF4VCD3F>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
 <acWXdvHx9mYqvT2w@gourry-fedora-PF4VCD3F>
 <CAJHvVciAmX9OFLBSahwvXL=E+3xnDsL2aE4WKfDBFqaT1Gu+Qg@mail.gmail.com>
 <acX8_XMQYA0-NGUW@casper.infradead.org>
 <6f40c513-af3e-45b6-9000-c61494a23bd3@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f40c513-af3e-45b6-9000-c61494a23bd3@columbia.edu>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 12A3220008
X-Stat-Signature: xrim7bhz3qtx1gtdzoxx7ifgbe5j176d
X-Rspam-User: 
X-HE-Tag: 1774640619-199883
X-HE-Meta: U2FsdGVkX1/pnQoo8XdLzXg7t8R2DxWUGGI/hil/QMPeIZU87SmjxsaWP67uqZr1kktRNk/UMsGjRoczHmmy88ueNE22w4Lgt4o4wFvdH0K1XXouOKawadpk62+83OftvzG3fAO9uYsxwmE16IW0/dj0OskUbiDAO8nwnppmEekph8v7wBHAkm0RufOOOvvUgPMnmnw0E3lLvTKLuhAo6zGWgCRanjZvE14N/1goiD3vBQjtEzTXg1gz5OYqD7pUh85Jwen7HREufmcJHCR7bhfWUAA0LmsOEgJdRHVaI87qkytP+FsvATBcy6ny6h+1r/JJJ4GgqKbKIUKDj4puL0wa1tfIdhsVzwscszZsjqqfULv5X9uNIA5AnnFkwuNsarFMY6JRp4waKF1G/dj/dWfvEudSwxynQivuCSrNGoOL0nWYx4Q//mxB/Qm0oZzMvaQzjiiLQHgLqu/DofpDQGV/1vFp8LiOSHbLsIRjQbHYHJ8JUBOzX6eRXS+cjOO3AT8+a6Uvv/ERK6LIBBbEL/Z9Z1wcN9dTrBbUyB0nplB/zg2ObZ0b3IuchczFId7S2/oWCfqA+5xQpIEvoSleYjeabD2XkaJFgT/Z+9ZzjC2pVquTa+tqjG47bKoKPGVs0Z2WDXtHHXybSocq1pILi9GjBH00GxFSv5PuRZ3JKmcNum1qZaWWknLhwWhMLbAG1FO8rVoOunWtaEeDORb3IiAORXo/0pyKgnBfDosgD0u8khdJvQUpe30sxTsYMEbkpq+qBJdqeVWOORiUsqHE7cDkbbQOk7eS29lJ9n4P0aXlTcmhc7smH7NOnQ1Yq6Kx+ya8iN/Iw2JK1f3wTGVFQ/uXSEVTDTiVsYPyIp+1OzKBtpbhKiUketb5LgNJttO+C7wjFdWrjbVKAK1dIsvi3d39teZ0ZHaVz0bxWrnLBR5lDgkwOb6rVuBYTrp4D84WGCzGB8UInq00dODnltc
 PI0nGgim
 0fxPralhO0opF+K5OhN4rebeuZZz8egJv8XNRj7IFho9mDqz7z3LVt1Ak5Sp0X4ylubE8+ruor5AwGud24CF02EpZxkhSYo3McVzR2q/7lOLSAlyRtWzKqNIrUeW2G0wHQrcyPWMgmvTSjQdwBS7VXC+rZCLmJBqotjPB0DIrqsZi4eRv0KVN2XkyDmWVG+NJoGkHWxk/5p8mEItUuTdW9WhcYSojnQvuEE1NJBQnXTgOkHy5YRC8d4j4x/MkEYonMpyHSJ9SEx5yH+iNSAEpRbZlWHKLjWz1cljCcMNQ2DtC3zduNyVsr+tIrrvcGrHeq0W7qDHUUgW+CjJiOtk1HuXNyxxdfoAAgLxTqhxYUGBSEXvgVvAlu8VDJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 03:12:16PM -0400, Tal Zussman wrote:
> 
> It's been well-known in the academic realm for a while that there isn't
> really a "one-size-fits-all" policy that works *best* for all workloads.
> Yes, you can make a general policy that works *well*, but if you really care
> about a workload's performance and want to squeeze out the last 10-20% (or
> more) of performance, you need to be able to (1) experiment and (2) take
> advantage of application-level insights. Being able to extend reclaim (in
> our case with eBPF) enables that.
>

This just makes me think going all the way to reclaim_ext and re-writing
MGLRU as an eBPF extension in an effort to simplify the code/maintenance
and keep what works working is the least-worst option.

But this is a naive take, i'm sure making that interface stable would be
even worse than just maintaining both LRU/MGLRU.

~Gregory

