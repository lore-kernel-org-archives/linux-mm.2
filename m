Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B2A610AB822
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 20:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD716B0005; Thu, 26 Mar 2026 16:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B379F6B0089; Thu, 26 Mar 2026 16:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7CC6B008A; Thu, 26 Mar 2026 16:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89BF46B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:48:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C287E1528
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:48:24 +0000 (UTC)
X-FDA: 84589402128.17.8DCFA56
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 329B41A0008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:48:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nUVqgrMY;
	spf=pass (imf19.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774558102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FM6ckp+68IcxeglLaEaLrNIkWIjcigeiQoeOq6MhKHE=;
	b=v9JoWcnFwUmLQrLuUpXRpXMtK6TfbjDW5Dnnt8DN1exLIkGx20knIvDJ4Uva720MfK7eXd
	Fc+4Z5ajvQnNdluo3VY5ev9FGQYkw4Ef5tm90nt70MsbdYA2gy4Z91YzWMeONAYknjAdsl
	/450ElwiqksBLQKa14Ty/KqvuLp9Tb8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nUVqgrMY;
	spf=pass (imf19.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774558102; a=rsa-sha256;
	cv=pass;
	b=y7cNsdVaiqPbyFtBXfm90FWAT51o5AsiIv7g3PXm7f0S5tfWR88x59yAijbxjcOjhtbnOm
	FYQsZEGru/2btdlfveyVcyynN5wLtndxqew89adU7GJhzIunI+WIIHipz2a3Z2i/ZLISCL
	nOeZuwWbrAGm9v1/nexvZo6ELGa7Z5Q=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6628cc1bd69so1182a12.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:48:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774558100; cv=none;
        d=google.com; s=arc-20240605;
        b=KVI28Z5UuXyVUq+5elTd0PoFHDlfSCW1vh1YnbxLUkCbvGQ2OnskqTGJiGhrR6l9bM
         5Vm3/u9WLMeXPqrVcVh+8L89UYx186zzgbVmSS6eHFAy7qcHw5RUoCzQ5vuUqVSvKi+k
         BHK/OFoUvOmJs453x4Q0WaXTbziWtpL5ATY8+thtrEu/RPnLSDNIJLWv31pjb31tBX/4
         ijS7Ip6/6ZYudVpie1XEtTIm+SyRpUabMMIUtR1ziYOv9oq2TG76MohgtT5MKIi5oQcy
         f7vlJFo77yluzyJ9y1+W1FWSr4ip32KLhHwCYkTCPny+EJkP7LF+GU5GUpfZYfG9BGjC
         z2KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FM6ckp+68IcxeglLaEaLrNIkWIjcigeiQoeOq6MhKHE=;
        fh=Vnqlrign75Loi2XN6KEWaUnC92o1sMlkYuB2JNqcjr4=;
        b=T5QwnebbpuHY9iI79cof7AgwaOsGrLsRhFY6vyR8P5rT4HBpvZnKmJ50/DWDahdvPN
         a7lBpmyeUR4lR3/y2aP1rAJr/RwxaC6J0bDpomc3giP7O1uJtBFOTwEVwADNA4b/oQPi
         dqvbu09bTVH2CvSRq+hhT4vZENhVjywU9IomuAPLMC7jiMk6ON7Qt+7OgKwEqLm92/Le
         C4H528UvkIxV21eEWpzRxe+h9m72068M2XfljsusFObtmZYn0Vd7SA2LOoOhu9puPH+/
         pGWJ6LCEfSrwZ9EtPmcD5A0M7YKcftqXm1WRnLfg5APyPs/jAh+qb2FO/OuozJQ5CO9X
         i7+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774558100; x=1775162900; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FM6ckp+68IcxeglLaEaLrNIkWIjcigeiQoeOq6MhKHE=;
        b=nUVqgrMY1n+GOpIBelrcHnZDhiG7d9fcvBbfmUhGBA793s7aV1pMBBWkZbBdhCAryW
         zsv93tO+R0xhzNdCxXTsQ7KtetGw597vBAxDQGEkgSMRZ4fNqTZy77XhRDEUZ5UNTvjz
         l1BYA7m4U7FEdkqBswEd5SZm9DmgAGj+DAlIf0+ACX7nmmrLV5wdkr7KWT7M9eu4uQBB
         9WY/qapyST/KW+4DIWC3p5CA66n6BARHdK8Edj1CosqXAc8XBjshHxQ/2dGEteAmiqNJ
         qAu1Z7ROsipDnRxWKHZodeBX3B7x7G/VgWP5CJWGysHNw9CuTfsPoGToPHY0+b6k7T+v
         mO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774558100; x=1775162900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FM6ckp+68IcxeglLaEaLrNIkWIjcigeiQoeOq6MhKHE=;
        b=KTXXa6NJxl13MyZI6lbos/x9fj1AXnoXdRX25iE47Ck5qiOCvrTyYtyIjk4QjSICwY
         7Cks8wdk4VcY9FFwasoO6tjMwc3GDivHpJHyD3JG1Lj/tpocce5QTmCY72gHKuDkH+Aq
         wW1nM8vhTGB+lVf5tta0baoypnhIck7Iz+Ka3AUNeOGIRDictsxfZJ7XXXXinZEde2fu
         U58nEWXtDD9JLwPAU3LH6jHiQRb8uO4jpYH5bS+tfh/TYcYSwOhrPIpvA2P9V/r+pWh+
         j6jUO2L9O6I+17lFRhMr4uzT9CKWAbK915YoKXl/Dp1FmzyjLKiSLDxequ6jk94u/DML
         Y7wg==
X-Forwarded-Encrypted: i=1; AJvYcCV2/p8CLp9NFCC+O2yoxHh0eJUqo3j1kbroT7oi1z96frE4YOfvRDpx3h9w7e9WpQcCP7hm2CTnCA==@kvack.org
X-Gm-Message-State: AOJu0Yy+Eb9SSSG3tCIfUAAyzbAHO0eIv99sUc2ZTLtWDXVp6VfrQvHw
	n4XB7NnY9qNGQFt4WYiI9YULUUiP5HbExIXI02XVb7O45NwxzzMZHrsC0RcX7WSvS4jgI6IdDLA
	z2dShbonB/AwDNcHDMkzxa3ak7QCoouVarZCVRy25
X-Gm-Gg: ATEYQzxCnROvnIThXr99EqvveHkrmHiyxN2ox1YIr6+Voua56Vui+uzlOCKxrxMjZQw
	tVUsp2lwMhrcx5HgQWzX49AqzjpaYR0WQsJi203cG75F3ZB0Ag4p9xUL9lYxsfPbnbClAaC+FPV
	93909qZnSaz5snO7UIU6mro1BOO7FjWZH4SinINW5qF27t6k+KxDJ7NkMoSyTf0/U18cUm67sGL
	O8ZnG41RaE3ROuZViRo+S7yoRQN81KFMX1dC7wbkkXgiHXxgGtMIoQbqOS5iHAxa70aSCzxGSLK
	fg6MZZt/6wGE8IZ3m7XH4mbBWb83mAw7/kSv
X-Received: by 2002:aa7:d51a:0:b0:660:b029:3d4c with SMTP id
 4fb4d7f45d1cf-66b19d0164emr16240a12.2.1774558099955; Thu, 26 Mar 2026
 13:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka> <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com> <acWXdvHx9mYqvT2w@gourry-fedora-PF4VCD3F>
In-Reply-To: <acWXdvHx9mYqvT2w@gourry-fedora-PF4VCD3F>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Thu, 26 Mar 2026 13:47:43 -0700
X-Gm-Features: AQROBzAHA4ptrGJWFLow7x6MKJvJgvIZ9qDDLijMZz14WwQA2JSL7ISC-0-uVLM
Message-ID: <CAJHvVciAmX9OFLBSahwvXL=E+3xnDsL2aE4WKfDBFqaT1Gu+Qg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim (reclaim_ext)
To: Gregory Price <gourry@gourry.net>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	lsf-pc@lists.linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 329B41A0008
X-Stat-Signature: skauk9jy78rwys54qgmhqm48377dx4n3
X-Rspamd-Server: rspam06
X-HE-Tag: 1774558101-392051
X-HE-Meta: U2FsdGVkX19ycIubUlvYJtvIp/BUYrKIodl53od6t9wHJo8WMJbn8lCEz89NuB87JnTzlVCrE1c1DHhsT9b46G8dUgwKShQrCzeNB3Njz8XBMruVHx/jCDVjnuMaa/jJlJKACmT1VSwpfYWJHl7DTTwvuPQSIvZhKAfIgl855yzLQjiIp78HbAQ40lyeOEBWSI+bROm0SEOd1oHXxvzsaQ1TIMQuLJVAcXes/xTXOcL7KXNN/biqDVa3KOVvOMG9kxcJ9ru16fOTscB6kkVMy7j3ub5+FoPqMzEndjyc6/Tn8TZkq0/eEOama3pDKDqXKgCZi26AIRTn54yOJZKGnYoGdsLCLRgMl4fYUKgSjX2YdDy5CGSpx30R8lyPfIXAHQqjFJf9W29ToXweh19rqReNH+hXJ+H4tc+/DiH1hjsYOrSCk4EwJ5Y4WQYP52BxfU4xyf7sHCKemhEu/gRRl5l7Vv8JwUpq6RLKNYLztUwlHmp5rCMrJ5C99UWxfewKikr9xpLsEaA2XoVyyQ8xWvmkcweehEcOdZIaKthz/wpAK84b3eXsS1oExor8kScNjIqaw3of6Iih9ZTGQaOHEAI+TvXCcOIzYFQmDoVSB+go8P6udo/Z4OGhSA1uY9mwND8IK/Eimuf+uD+sjCgp8HoIym7zTfuiJ9pyklQVivweaOG2eHoWH0Nkklg86Ao6h0ODRfE2167CCWzIZBXf3b7FY7DY603fKUOqJyfvEgOe5urbCygtFaEwgWDzac4JS7L30vNE94tFj6y3vmgs10Mk0RJl/KPJwJ84PAEd8Q4cdSzolyXP+NrMlgC+pdLHLFB7svz8HWpLIh9LTUryWRYKXSNdIngPJz+kuC4JvJv8g95xhd6JAHWwtbWbXgl37Sy0GoR0yYodiZ9rFQKh1MK57X0bK6qdP9VGMyNSRxIs8i85E7h9MLWBUntxDr3190M5aNZ2db0kqFWUGxW
 D5TIwDw/
 7W2ysJyKvUZJZjQ2gvJ3X+rrB1vjWd9gAE5XhoesMSu6wloF/AaK2pRx7ZuDw1GBjSc3x5Xk7wNjhzwNoHi1n3vnPDbchELAnIIoWURjqcbR2nJBcmAyYdh7VVNAkMdmtxuKyNwe1Xehb7/0CJ8+cILpgQHxODn61lnGPG2AZALy242fcQZ1jNKuPJkoeopNwPI+S0NlJS4bAWrqe4l53T5Fp6Xlkr9Kh887gFXt2rOrqJ47A3pjzhjkQ+b2UbaT2hEcIbhDEKsiy0KbC5mYTNALgtRHwJ4h6EIjOTbDjXvXN9M7B/Q3oJRGNPH0NmMiFpdne2OANZbf7fK07/3pa9vnNeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 1:30=E2=80=AFPM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Thu, Mar 26, 2026 at 01:02:02PM -0700, Axel Rasmussen wrote:
> >
> > I think one thing we all agree on at least is, long term, there isn't
> > really a good argument for having > 1 LRU implementation. E.g., we
> > don't believe there are just irreconcilable differences, where one
> > impl is better for some workloads, and another is better for others,
> > and there is no way the two can be converged.
> >
>
> I absolutely believe there are irreconcilable differences - but not in
> the sense that one is better or worse, but in the sense that features
> from one cannot work in the other.

Right, agreed. I mean a case where we have workloads A and B, such
that there does not exist an implementation that can serve both well.
If such workloads were "common" to me that would justify a reclaim_ops
/ pluggable abstraction layer. My thesis is that they are "not
common", so I'm a bit skeptical the abstraction is worth it.

>
> > - My sense is MGLRU is "close", meaning as Kairui said in "average"
> > cases it is substantially better, and the gaps are both fairly narrow
> > / edge-casey, and very solveable.
> >
>
> This is a really, really bold claim.  So much of this is workload
> dependent, and LRU has decades of battle-testing while MGLRU has barely
> been around 4 years.

Fair. My basic thinking is, MGLRU is enabled by default in some
(admittedly, not all) major distros like Fedora or Arch. From that, we
have some various regression reports on the mailing list, but to
Kairui's point, nothing that looks super hard to resolve.

Then again we can always be surprised later / as the footprint expands. :)

>
> ~Gregory

