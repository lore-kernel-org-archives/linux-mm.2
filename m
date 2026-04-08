Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD5DD1073C98
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18426B0088; Wed,  8 Apr 2026 07:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9286B008C; Wed,  8 Apr 2026 07:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE566B0092; Wed,  8 Apr 2026 07:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFABA6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:04:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B87E13BF96
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:04:58 +0000 (UTC)
X-FDA: 84635106276.08.0CBE573
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id A339EC0013
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:04:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZyR3BGBB;
	spf=pass (imf10.hostedemail.com: domain of 3VzbWaQsKCHIZeedmedaQdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--joonwonkang.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3VzbWaQsKCHIZeedmedaQdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775646296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QFeYzDg8GJ9NKSr0YRaZ+Ij5/0muyTGiaNqDyaMghA=;
	b=4t1m/YkEj/SByHSShM0Xsx0NQZ0BynGSZ8X+m2iX7v/tPxOFZOd/n5mbVMVaAfuyluozit
	k395qYjfXxfxSglmjYihBi4uTitaTufm3bihUPBuxqXsgnBts6tFpR/Q4t3GYCKMW/lLE3
	xvsNaDYqf0hWBSkA7upHjDTKFoWdxR4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZyR3BGBB;
	spf=pass (imf10.hostedemail.com: domain of 3VzbWaQsKCHIZeedmedaQdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--joonwonkang.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3VzbWaQsKCHIZeedmedaQdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775646296; a=rsa-sha256;
	cv=none;
	b=OyAKhSkMfMDhk2TB1oz8fq2m5SL50OrYwh7mj93wXHxE9NOwr7Kb/eAn1/QIF/Bft8I2IG
	9HacwupRh1ad97cQYBiwuHiZYEsMI32EUYSH9xosnRkF3Kea6oIZJHXveUXLg8suzrUEb7
	sF+Wwc4YDCH12oIlWqaR0ALulZdGRTY=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b241be0126so163440835ad.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 04:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775646295; x=1776251095; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1QFeYzDg8GJ9NKSr0YRaZ+Ij5/0muyTGiaNqDyaMghA=;
        b=ZyR3BGBBifvFF1OCPv8xhyn4aSdInywXZTYODDDAFhF1XQX1LXHC5W3NXlVnriPLZi
         vftHBDv/7Kl3WisevX1WrHTK1CB2g24/Qt+T4ZnfWMfWms1bhVRzXXjT2VX5jfDGY+Xy
         FtvHPEdeirH5YAeAbdifsSYobbrkXWxWxyxlpYYFXaxeHmSMlSiaJSADRThg5bRW1eZk
         VlgNmS7AFAKRPm4jhic2qBQop/m001jW1SEbSDpkR5tVGyFdYxWpdF8r5DIt9q6lll2n
         GbKjmdSic8QMOclH7s9sZwtjDuVk1pvzXkbyxOvApcTH7iBFMgRuEOW4A59fAAdQEwZq
         bU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775646295; x=1776251095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1QFeYzDg8GJ9NKSr0YRaZ+Ij5/0muyTGiaNqDyaMghA=;
        b=qSk2VDSpNRVPc6SDRsEBxtozgNMQNKFu75/j6Mt7DoPSBoWHVIxhjQjEkapL7Eb+1C
         nBpYFAZae7wV3REV9S0KNlDptGjSXtN7rPqDYKxLMjZgeuZXzpbv0cedH0E8xHYgNqOO
         vwyweECknj+QFaYJ318o9QC+bqhPGzS8IAv24MTr0aQ9ObzBDEdwHjJVNdfJF/RnL6vA
         kTuVLUD3EeNkrLl7BMFnMAVRP7fEAOrNBGeP3A/Mss0MuIEeEufpCwgAZxtBhNsYt0H7
         3PBlevpab5tFgWISPEI2ME4TLh4glAMIpN3r6FtLx3eD1M8KgMRFr9IELQxgMh/smdq3
         Spnw==
X-Forwarded-Encrypted: i=1; AJvYcCWBbBtscxUcr70Q6FjC1y8GdHjtb3lJmf3CA9FpcFH5bF9BRbBGdMUc+UHcWb38K4Jhf1yCs59tug==@kvack.org
X-Gm-Message-State: AOJu0YzoyUnIO3JJ0fB1HpsV5aBvWV/lpMB0YL/iYV3PWGDy8Fwp5pe2
	RuHVuXf2GqGThqxcRhHKBRDgdCt8aZ3lKZ9MR1MkfuXLCJclhax6Jp/Qhu1QuE1Y0ViGTCXbQgL
	dNdZioq4/f8hB/8ze30sfjkfUsQ==
X-Received: from plrd7.prod.google.com ([2002:a17:902:aa87:b0:2b0:495c:f3ec])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:38c3:b0:2b0:a980:367c with SMTP id d9443c01a7336-2b28167312cmr221287015ad.2.1775646295294;
 Wed, 08 Apr 2026 04:04:55 -0700 (PDT)
Date: Wed,  8 Apr 2026 11:04:53 +0000
In-Reply-To: <20260408100642.83919-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260408100642.83919-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260408110453.694461-1-joonwonkang@google.com>
Subject: Re: [PATCH v2] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: joonwonkang@google.com
Cc: akpm@linux-foundation.org, cl@gentwo.org, dennis@kernel.org, 
	dodam@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: xi8udsqwzx51wk4eu9fizim44iuytwru
X-Rspamd-Queue-Id: A339EC0013
X-Rspamd-Server: rspam09
X-HE-Tag: 1775646296-860282
X-HE-Meta: U2FsdGVkX19SuWVsYJwmXhwvNuCtcWI8iCdez7qDn4/a1OpfD0Y8mRnYSGs+dRfNlyOQf/ySR7OkNVPDP/RbH/tI5UUn2KUoIKlqO84CnFRPB5D1EG4Xji6n3RsCYlNJpFopEKbKL5J8vMtp7rtgOzWWNFfKNWK/ySSBIXHHX9E+pu85Y17uW+oveOBM4hLD8UDBKBs+akY+BHfKgF0ag+v7G6fbp7bMU5GJpsvaCaZYLOqC65FFO3DXUdupmsKnbnjuTVwvNp7vu7pruDUWUEwG2bWBUDP4UOBpUGZ097MVg5kNVrf1ECt00wVWENW6+jklMpKmqdmAgeEqUYjOjp956OeJ2bKUPv/HNcv9TkABgUQvoFjeiIKiVd6KmHAZ8zPHPUbQJK0F0BKf0t2JXaSS+WFY2Fb5AAAX7h9ibV13LWuhB7Veg3iEjHnYMY7Hrfv99WAyvMHKZRBMrbAcGu1HOrkJ242JTtUQVrQCH9dE/pvfxrXlkj0q2toivVPlPQhDv3YomtRPzhnoVyoO9/xHkUvtwNDxDO8Hvd0hnn9fMygM9Q9Tz3hhF65Xrx0BJTkx3Q9EfPgsXl44q1v+pRVDHdbTq1TBepAN1E/8WWLUt2QJdijrEaK8Vsjq0c2srGAgkRbEPZPRIAwxtUJDVuS8bNnl0/UdYqX2Mu8Y42oJoCp5wlyEHsaLyfT+e3SBIPte/mFRKgvNhm6Y5j1br4VBuTp3hNAOt3+msrjWNgkoDHllCJv1ZvqHVP4f7m73kH9GEF9PXNeA3Sg7GUl1xInyGa25yHsPxcY9NeRS3PKVTCi/cMPWEtXcDwIEltJc2XJUXu3wB8VrOI9vINbQ78Uh8A963e333zTEfCZiAtYLUmxrOpdbEIC1FNY4R0UYhv20EnRZpr/jhrbI88oiKag6ICRnOyx+RTaxlfTMqIxdBopoTA+naI+6EZY5ilGUK4gleLmLWD4Hd1GayJl
 QzjqSdKU
 wxZctq4fBP07Ykxg3cy5AyShxc7ryPskDXSwOAHuzoX2HlQ/J21CyljnqqGoMmmaIOI59/g9Fo5xidNbkg3up/ROuI61fl6LjyZuueXMeBypjfZoS1AdfFhxJeYGsU/m7ODfjivjmuFay8bfBCUoupEHtNrk6pXhtY1CNZBWRhrFMhT3SMyDHRJ559J3rO3NoxutSoAh4XDxooRhnd+/+PBWn887FA5zKugRoub6pRZD67KSsUflCclBibh7Hbf5K+chSMlfVezzvMPEJBPufffFucTJ/wxavWEvR4NicDQ+f7p6ms1Q+NHP3XIB1wbNbZ9YLftRaLMflAxpHnaCx43XnJYmTqwXb22/hIcBLvhrsACMA4an0w2PLRX+s2YG6Zw583SnApIVHjigzpE4D0+rI3job1CCisTq/xT0/64JuAynSTGLucTirmtwFRMks/qxK5h9wiTwXPIEsF9uRKvPbGXajLZy61DOESPLxr2T+CDsU57nfTdyvEB5TX9u/NZyyrC80s+DaVhoIrcorPsQkFUb+P9qSarblQ9iVHa+3CNLI2PO68w9a1zxMT+xDVIi/jpTBbdsnQqM3ocRBkwTXf8sE1H4FMsAPH0OMs+uEDnoVz3vU6y42TNTu3hcN8Z3b9cacau73hXQUk1IpVu1fEQHQsu4mmX/wTlhKmwuFa4KcpRea6zlJtUqSRw15eArRuzXPjCPjAoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The invariant "scan_hint_start > contig_hint_start if and only if
> scan_hint == contig_hint" should be kept for hint management. However,
> it could be broken in some cases:
> 
>   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
>     scan_hint_start < new contig start) && the new contig is to become a
>     new contig_hint due to its better alignment, then scan_hint should
>     be invalidated instead of keeping the old value.
> 
>   - if (new contig == contig_hint > scan_hint) && (new contig start <
>     contig_hint_start) && the new contig is not to become a new
>     contig_hint, then scan_hint should be not updated to the new contig.
> 
> This commit refactors the percpu block update code to make it more
> visible on what to consider, e.g. when the new contig overlaps with the
> old contig_hint or scan_hint, fixes the invariant breakage and also
> optimizes scan_hint further. Some of the optimization cases when no
> overlap occurs are:
> 
>   - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
>     contig start < contig_hint_start), then keep scan_hint instead of
>     invalidating it.
> 
>   - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
>     new contig start < scan_hint_start), then update scan_hint to the
>     old contig_hint instead of invalidating it.
> 
>   - if (new contig == contig_hint > scan_hint) && (new contig start <
>     contig_hint_start) && the new contig is to become a new contig_hint
>     due to its better alignment, then update scan_hint to the old
>     contig_hint instead of invalidating or keeping it.
> 
> Signed-off-by: Joonwon Kang <joonwonkang@google.com>

I have just encountered a kernel panic with this patch. Will submit a new
version after working on it.

Thanks,
Joonwon Kang

