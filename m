Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33239C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 08:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D87E6B065B; Fri, 14 Aug 2026 04:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291716B065D; Fri, 14 Aug 2026 04:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1786D6B065E; Fri, 14 Aug 2026 04:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D81DC6B065B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:47:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50541A2A46
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:47:04 +0000 (UTC)
X-FDA: 85099245168.13.E038F59
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 93FF61C0008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:47:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pIRbJ5tG;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786697222;
	b=8G3MNu1Lx8SWr8/7wxm5QEFf35OIxOJ1gzL+a/VrXtQIfNilJmyo72IKviqAYjnLTWY12Z
	KB7ZfYLRsZmIzGPuaZPYQqawq8j1y8lY0KVDhQGP/KpkzulQmydjakgrYPzy35TK6jipgw
	KGyxtJBsqbfqcay5prW1H5Bg/fzLW1E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pIRbJ5tG;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786697222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iDqjoiUvHjoApvKi+JnXgMQwtgW5BY8TIp93JdyJukM=;
	b=QuSzHJVM0XCmhzooDW+4A4G7VG7XHXRkjyW8mBdSbcKxJlSPTg1lsWqEROLj54z64fLEru
	rfY+svpaHatuQeaz6kSV4ROS4+6/JX0gVsNsNygvT8iwL5MC4Z1PcV5cpn6R82gMSs2faY
	aS6s43U3/jTjFpDo/Bh5oVGpqhE0Ujw=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cacf197759so12693805ad.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786697221; x=1787302021; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iDqjoiUvHjoApvKi+JnXgMQwtgW5BY8TIp93JdyJukM=;
        b=pIRbJ5tGsdIZzAfVLWbbIYRmIgmUE7jrvQXhtLKQBXtUQTwEnslxC5TH89ohPqY6q6
         VgRP49ArAbF4PnzESKs6KLQKa+42yr6iYLsMnnszg1P6gf1OKSAcbEZKIMh6QoMWeZIN
         GPKgMxw0P9rXamPFAGAYdZ1irh3yyEPSWt5sVW7f1javs/XvIkVqC1Qw7fEZMaVvJUVP
         535if4vowl1FccWQBlyQs0WjLd4IgDJ69VuyBUZKTHVS/93+uhMgDLkVjK6UuKinKFoF
         7vNVJV1iKajv/Op7meIe2PQeUtVHJSixDpEpBzOnrf1vAxfvcM2QZ+tipc5OCE/M8xQo
         YTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786697221; x=1787302021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iDqjoiUvHjoApvKi+JnXgMQwtgW5BY8TIp93JdyJukM=;
        b=ILI0FOtmVU522vT7BOEffVCATmIO46dUzyjSsX2TzWbfm0ZEbJfD+QOK3c7pDXN6Y/
         FNZz08P/NBetCAvY63TQG9YQ3IvQHdMhtZGWJNnNnw7vEoz0x7OiXtbl2p+swNt6OAZr
         rlK2Egdc5HOnU8aDvjNWXvJanpBsOmtGZ86QpKl/F0MntLA09MwYlbamTg4siTeqAJbR
         w/Z/yKjrkcc7OVQaySk5aBFPX+Uqx2rz2LZ5cKjeGvcHaVR6nH+Yh7VZOXcdVtOyKw9n
         ghgmrESB+ZBrKZG9L/TLbNk70PXlzu9H0PyEt+6CCbc7j2ShOhnrmNO8/kgYe8oZ8/13
         hx5A==
X-Forwarded-Encrypted: i=1; AHgh+Rrgyru0u2nTqX4F9McY0IJwmoX+3Wy2/oWN0z1oi/VXTY67lLa+IkrOR9BDywZQqbOgd8SvMU2DLA==@kvack.org
X-Gm-Message-State: AOJu0Yx6NAC58BIfbpfzTYgQ2dP5UKdn4Zl9BpEA83dtGktzujAbjbwc
	wOxZiAeiuRsO7iSQsT+8X4jEWSkViCSCzd3M9mmn8YQ/SxJQo3sYdfq6
X-Gm-Gg: AR+sD10ZsOT33DIZgaw4gYvLXqo0G8eTLSuG48eGkCP2reDiwCX6xC0iW86SRyj0aLr
	78DEkSRl0a95OzQ1E1w64MTJQCte+8Jc4cnGC8uPbaBlPcZ6bpLJ68CCkEVgIXr75bYzsYvw5fF
	b5s2FUfTrrC3tAc11sXH7pFqw5JSoAnOWxh5VeJ7UgUqXWapQ6ehYx0lL+uc4+dq6qAmMYsXTl0
	znEy+n9n2ED6v3D4Vg5bvsmcTLom8S2h1W2aiw282u6P1fhGgDC6SrqUMutII0UwpBDLpuqiTLi
	Apurr3p/nBNu99ZKu+3/j7aSfG3Dy/2mkhn9inY4QUolFcqy+1ud93gauISnHD/qO+kE+fxiWkC
	gubPBLuxJaFHmBSYZqCXDmHolEfb/Z8COnmeHotvwPqVk2rW2cI/tX8yoC01TI0bt67dzJqNfG0
	gN/znXR6Vm9dktC5PrKiSfr+ZSk55vzJnTAw9qY4cHCzCa/ZyLb/AZzj8IQVzMFO73Ng3PU+0FK
	2jaCcHwpDM1GKUp
X-Received: by 2002:a05:6a21:3384:b0:3c3:64cb:9b99 with SMTP id adf61e73a8af0-3cc719c78e4mr5591931637.6.1786697221422;
        Fri, 14 Aug 2026 01:47:01 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320ea2fe8f1sm2058373eec.23.2026.08.14.01.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 01:47:01 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC/Discussion] mm/damon: Helping with alternative for watermarks
Date: Fri, 14 Aug 2026 16:47:10 +0800
Message-ID: <20260814084710.39955-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 93FF61C0008
X-Stat-Signature: qdich4kq787hrjnnnhom6wky19yeox6z
X-HE-Tag: 1786697222-895572
X-HE-Meta: U2FsdGVkX18+T4+NgF8I5mXwSaduESx67UUR7d+5Fg7xf78ONgaPuGgizHyYoPdnffPNdPqMH2QiiKV/wtZMvaqoxdQzmxZIrZbHuy4vYjAbOjtLO6kZyStBRRI40me0szruSUEpG1WNFnm1M/QLV2SWF+zC1lQrwTjDrq/uGLhmFB09Li25/Sbhxz/zFuxS+6tzZmR/b+Q5KDy9nf9SGu5zeT2tzLCmaiO+70S2ls6tDZJQFZhA96wWItghW4Ozg+7n4MbIrK0UiN6uQZEu2e2iODPBRh81v29jBtrxi7DJAcoJ6Rp846slVMeyMJqylvS7FQq8IvVDgwxE3+lcHjknp0n7E7MDmmObbNkCP+acEPKRaShLmyI8L2kX/zBb/ZYEZIKi3b2qwO1jfMX3NeyYREp/sysA0ljxyRN8DAcf7sxPvlx1kq0KVA31nBFTFuIatEYHHrQOr8PSoFCMJ4GSuWMy5+P7S9Dzk8SlboJnazkhqdkFIcb6gii6VZymQiD9WkmKasHCctrfFt8qpH5cR4KpxVBkAUC88fGaKlbzMk4NMbs0a81zBpcFQA9+2U4AJPUgHC7jZfCq6UtG4bfeG5viaxT8UhhmGv+04YGnKYVF46y2AtBHMQjnY6TTV6E954n5JcD9f/AlcQFE7nkZgIbroMwU0AXQYLap1KxIDtYrrvwEz0EA7dfcyRH3bpRoVMlekuy1slt0Qm77YC0SDjbvvNt1vTIAqZnZ/f3pfACrDuSDxVGQyQjZlSOWfT9L49Ne6iFJhd8PasKp2KB9iCg8sq4swx4i37FLxsKOqrupaR1CsZsICB191eD8M3hxUBWWQs6CgINZkn7SopVBSkbVFcT1JpZwhkw+d7h0pJ5tpmfrb8YaSQhVeqNkp6opQt6OpKtPIvJbitGE+7oANv1Is9ZWCP/H7VQKMdA1VIypx61YoMs7BneQOMSZRZ1Rm6rOF0r1qHkd0Pb
 cu/Gr85G
 qx2fkV9nNwLJk/i37jONsV2lojnfsppuZ3YohczWBvW23jteFcEKvH4VVmGGkG3wMxepMpiLnl5hhaE3lhHxPE3PTMg5rInLgWvQ9dgfyhEbonXBRufE003EzgR1YuVPl6m2vk8eMqFk1ylPhQtfqlxUlaJKfer4SmnF1+IfV0/qOn7yFz9LfsumCo9FCB6Tch779z0rYuUQ82krYUmehr3NvWvDw5GWqGt4NiqsMDeMHTkLN3poyxg2u9HACwZMb7RaN5MXJT0uAmGJvDKnx36Hfrody6knGCx2VAdegF2rSAciYmmyNnI2u8tgLrg736tIwy416xiJdfXxB5axJY5pJkRS0WZcPeKGRHLYqRp88YJ6scW2yy50ZGS6qh8v90ImoEfq+ygI/nLFE8a5i4yqY+HTfu07A8fK+LhrWqPsfet/OpIcFxRvg5keM9CjjIT4pTbhvU6c5wFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Regarding the alternative superior feature to replace watermarks [1], I
am very interested in helping you design and/or implement it.

To share my context: I am primarily using DAMON_RECLAIM on my personal
laptop.  During my usage, I found that using the free memory rate
(MemFree) as the default watermark metric is highly problematic for
modern Linux environments, because the kernel aggressively uses free
memory for page cache.  Therefore, I compiled a custom kernel that
supports monitoring the available memory rate (MemAvailable).  Since I
understand that the current watermark mechanism is not planned for
long-term extension, I refrained from proposing improvements to it, and
instead focused on understanding why that direction is limited.

I am very interested in understanding the design constraints behind
deprecating watermarks.  From my current perspective, watermarks have
these drawbacks as a run/stop mechanism:

- Mismatch between local monitoring and global triggers: When monitoring
  a specific target (e.g., via VADDR), the scheme's run/stop decision is
  currently tied to global system watermarks.  It is impossible to
  determine whether to run/stop the scheme based solely on that specific
  target's memory usage.  Therefore, the new mechanism might need to
  allow user-space to pause/resume schemes based on custom, target-aware
  metrics.

- Lack of diverse metrics: Watermarks currently lack support for metrics
  like PSI or inactive/active memory ratio, even though such metrics
  might be better suited for DAMOS auto-tuning goals.

However, I realize these features could probably be achieved by simply
improving the current watermarks.  Most of the drawbacks I can think of
are basically about "not enough metrics/customizability".

I assume there is a deeper architectural reason why you consider this
direction unsuitable for long-term evolution.  If you could share a bit
about those constraints, I would be able to think about the new
mechanism in the right direction, rather than approaching it from my own
assumptions.

My need for a more accurate trigger metric (like MemAvailable) and
always-on monitoring is exactly why I want to help build the new
mechanism.  I prefer to invest my time in the future architecture rather
than adding features to a mechanism that is about to be deprecated.

If you are open to this, I would be happy to start by reviewing the
design direction you have in mind, and then help with implementation or
testing where it is feasible for me to contribute meaningfully.

[1] https://lore.kernel.org/damon/20260808000739.1308-1-sj@kernel.org

Best regards,
Rui Yan

