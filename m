Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD07C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 23:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8216B007B; Sun,  2 Aug 2026 19:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479716B0088; Sun,  2 Aug 2026 19:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3679C6B008A; Sun,  2 Aug 2026 19:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 080966B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:05:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 569E7C057D
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:05:27 +0000 (UTC)
X-FDA: 85057862694.01.258C018
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 99FF6A0006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:05:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OZDlRiLQ;
	spf=pass (imf25.hostedemail.com: domain of rientjes@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785711925;
	b=S1euLFfwXEZ+uBDnX+SF1To+3ngfKJ3oaLdmolBj0wMBHxJ6Ug2asrcEi7vTLhEHwDL+Y7
	1disEuSLeuIp2OKgwpJeGhuIy7Y2wibEd1LlZBY27K+Y+JeFouXKqfgBEZ3NrO66dtGHaj
	AeY/QSePjOgbcJlcveRVdV9dt0NmcYE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OZDlRiLQ;
	spf=pass (imf25.hostedemail.com: domain of rientjes@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785711925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cyiqh0K+Vl6nUEB3uY5lDQOT7FZOsVbRvtIeDGocFo=;
	b=QbQDFN7rp7hPEmCl83jxtDRZpVF3aEWsAyvOgqn9ROhzyJ7BTUsdjRBTZm8fyYEoC2ckNM
	owsa1KAsHYxVW4KpF5bfvrBwNTIpEZfT+u/5wsdDiBEz4sx2EyJCvPmjDPRJPvyKYxAH0i
	sNHL8GM//vRqVHf99VUzpcLWXUSpaoA=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cacef7d299so65415ad.1
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 16:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785711924; x=1786316724; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0cyiqh0K+Vl6nUEB3uY5lDQOT7FZOsVbRvtIeDGocFo=;
        b=OZDlRiLQzpf5ahlRlELX8uJVoDXRHvWyCYt0qJIO6UGrhTI/jRkzqTeRUP0uLL6zGj
         yP248A2FOQpeU6VSNca9DA0wWUMkn2NOEdufagc5wyZTlT5Y+ZJUC1VPn/9RCYM7jcjQ
         bmh/XmOOFGPRG+bJgaAt+k9x52japdrj7KGdwwffsPO+V5DjZX9K1KYdVHTWejPyNEMQ
         J+0nOjfNShQ6/q23O5SqLKCYXW6TQrfmCqQwbwKkjM1ydAOa6xsR0JCZXIO+U1RBF4ru
         bLQsSnmFByMnWBgKbzOS9Zs6Cw0HdBc+VtEMqtE7tgycpSe/xlO0Zw2NvgGehYhUkjkv
         Tm0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785711924; x=1786316724;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0cyiqh0K+Vl6nUEB3uY5lDQOT7FZOsVbRvtIeDGocFo=;
        b=ZK8FuurjfLXn2FCdoid/RJONrfGBOSzFCUO5Q2bASr0Y8N2yabA4Uw8K7Kc0YxdD90
         zqo+6FtR1mRrMu3WvswIhQij4VgMt9vgNr3YyihegKgabVkEKiSxQpSl7e3BoHajPfAT
         PesX+BomKCzwyuw7La/syDWJqrvtce6Y7wS6VhkYLY4K6SAlRzb8k3wyQI1n0bsx/RRy
         uWb+sXvF5n1UaMO9yKsnf45aKw6cdPd4lBYULO8rylfot2CHuuSzN9mjKV0cnM4mOmcG
         P1QsBYFFU7p8ln2VlsaGe3heT+xv5QqACe6H9Rp73XSXSzVsFZszdfIn/26wTBCiQE1v
         T0kw==
X-Forwarded-Encrypted: i=1; AHgh+RpNJUVkmru2sCb7SyJuh3vgwbbNXz/YBr+dfnipAOtes48dYCc68SxWpjzjhiA3QQbx10sp7eT/1Q==@kvack.org
X-Gm-Message-State: AOJu0YybPei2yxShn3iPQMoA0k8AAap4nGS/nteY+l858Wsqg5cHTZ2P
	Oz19BQ23gytrI58RpbkkLEv2f4UFUFGRIXcDbvoSnfP6EYEqNdA65PNj5KfUMr40jg==
X-Gm-Gg: AR+sD13iLrGbSuLeS6pUk9oUMyY8kWfWxPNdT4n7lEVeV4CqAKztDzBmyOj3YfkdbnP
	SHQbunzuzTATZWiNVhKdPr5pfGQafRQcmvk3MKK4U+yHdH3r0S6HagElyEm4civ18PGNoOCTUH/
	E7Sa8nWszm/DUrsuu9MMJcrKjWiHpVF+6KaCvPl0ThyejUIzn0HAXWvhWyjoMvkaqHULSebXahl
	byynu2jnuP1hQhKqYCjXT+KBfT2/45XF/J03KPZvCgIPpw+GNS9HpzPxoWAY57ETmw8cWhktpun
	i74Nc8/uY9VDVJpB3hTHzVsomIZ2lVUXdmlXfASnZZulBHkx7y5w/uwVSpw/yZ732R38xhrMLpf
	2KZYxkRGVZdmeAevkL7eQ/1R7ApJfx6D/4DLhTHyv64gmjIsfL1Ec88xjp0+OCy/9DN1+jgk+IT
	DBcep7+U+oOaUuNyZxA0e+m89zd8bFLze+2thra9yCuC4YcoxuuY/BQj22ylWZ2Wpv7EX3/Px9t
	xS9shtuTep6haALNyUlOA/k7JlNhuI2i1lrH82FyWUdSiHxsiioYkB/ladFCzLs3Unqdx/3dNb9
	nNCGC1JY/0lwd6g=
X-Received: by 2002:a17:903:384c:b0:2b9:e831:5e5c with SMTP id d9443c01a7336-2d054694188mr10229235ad.4.1785711923806;
        Sun, 02 Aug 2026 16:05:23 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:b3ef:da16:936a:c7c9] ([2a00:79e0:2eb4:9:b3ef:da16:936a:c7c9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbd35ad5sm2820914b3a.1.2026.08.02.16.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 16:05:23 -0700 (PDT)
Date: Sun, 2 Aug 2026 16:05:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Usama Arif <usama.arif@linux.dev>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] lib: test_vmstat: add synthetic benchmark for vm
 stats
In-Reply-To: <20260801132038.2926647-1-usama.arif@linux.dev>
Message-ID: <a81c8e4f-d9d1-18ba-cdcd-73ce68df9f8a@google.com>
References:  <20260801132038.2926647-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 5g6wy8k7he4u6pbdbjuts4iaeyzn7t9w
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 99FF6A0006
X-Rspam-User: 
X-HE-Tag: 1785711925-356656
X-HE-Meta: U2FsdGVkX1+OCFXe4yW4huEJW+WheYt7sPeWfDQo+fKgtmzYoT4w2exp3WBAk9g+W0uLHrOrRWZmrUhV+u+hP36vTx4kUvWbLJgEart2YkS28gChVl5eW8ZuReNb8sNo4jkp/Q3ovUCoUcLY1awG7Y3RR5AXB0JbHeQnL1VNqoGTZVeRqZ9eZoIagy95p0livf0TVOeENkVP1m4vmpAMZFf2BA4BzNo3ncjuGowy6OEAWhxKOwPEyxnnDmwa1k4rjAKGtWPL8ftSB7WWXP9H7EktufHT+RsspgUSw/GfV1Yq8+Igk+jW4B+zagntehTyNsoRPlwQCzDc0M8wKCrDnoun3Myp18zVnjvAVQ3sJ9MaF45VF0Ksx1/wpcOBwx5bC1FHE4+4PCnCcppiKuoDNaFBAjMqkSxP6DEOBT0FxlvKfBk5ZykAyuLfUe1xXSCb1EbfO/ndddS6P9LZou9dKlubK4IhF1Yg8NJ/x1aCLuLlqfNfDwqDmL7UOppasdGRcBeKJnA3skXuCHAzMtHJVowS2omkEJ9JCZaT02tS9AkJFxhMqLHTa4WQwoVMN7e8/GrZ/UGXJ5Q0YppSlEQFBRaTOQMgSu9RSmw8psYry4IEclDDZvuXrahWe0scJdCAErDf2b0Y0B/0OYAOOyIDM6lPUifciVUIyl/FXT2pDr+bAdk5DMslMJWMCPsMWt7trYdO94Y0KLImjbSo8L8yjS2IZUAHbt9xNX3WeRRuR9x7fO5T6gfzZGQ1PSmoq45seIxbB9JNiHcBeFm9NP2hPyaBs500+rDIz86VL6bVRUo3yQpEdgAssBBE4Ntn2HNLwD/Uh5YxOd1iPfjfCQA67SH8qHeeFrpevKlCs2d6fZasd+313d8rghJ7TnvepVVq2b/eN+b430JDJ4BhYfkhX3bMoLhTTebo1E6RESV+DGRynJ80XBXBN78OeUDU/XgJHxl0k7SFx/CzVlCsc9I
 DbzfXMws
 GZJbCO/+cRshsDhVqFICSWYPwZe4wPDBp742ckJiXhd03e8bch7Rv+SU4cVhdxiZSB9dl8dz3k2a8FI0L4ukmaIcaBxQnRS8jYhigJ5IA2ZSb4yB2qshenmeFLSI4F0upYmI3jQvpef13l1nURQZevP9oRJwTAQIuOhzBtHKwiEzKYbZzKUTpuBar+q8GCvFOZ64r7/twJpF1I0w7IeM26QIrzUp1HMbDAw6QwdwYLsfV6IzLRlWoBZ0j22xnG49REHN4XZkyhFdSu7l0rtRgSbDi1XF71oFdY+Cg5/rXiaO6fnAhEuDAELr4hSAFH2DRANCkVup/+NmOqfT7YGy1TE3B3h1lxOgt0ZsUkvd3JWKz9wnu+RSHt51833Se0fzQq+BwUSnhcScKNU/radwFu4bxWSt7QGroWzyKfQOuZboJFGcE99c8/i2Cv0dz9INYuC2vDMyjHhItdbzzcLstiFrHnVWODiJ1fTjJ0IBI1e9K/rRllzxEfG1veCKc+hy8er9F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 1 Aug 2026, Usama Arif wrote:

> > diff --git a/lib/test_vmstat.c b/lib/test_vmstat.c
> > new file mode 100644
> > index 000000000000..f63f439ab9d2
> > --- /dev/null
> > +++ b/lib/test_vmstat.c
> > @@ -0,0 +1,95 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Test module for in-kernel synthetic vm statistics performance.
> > + *
> > + * execute
> > + *
> > + *	modprobe test_vmstat
> > + *
> > + * to run this test
> > + *
> > + * (C) 2009 Linux Foundation, Christoph Lameter <cl@gentwo.org>
> > + */
> > +
> > +#include <linux/jiffies.h>
> > +#include <linux/compiler.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/mm.h>
> > +#include <asm/timex.h>
> > +
> > +#define TEST_COUNT 10000
> > +
> > +static int vmstat_test_init(void)
> > +{
> > +	unsigned int i;
> > +	cycles_t time1, time2, time;
> > +	int rem;
> > +	struct page *page = alloc_page(GFP_KERNEL);
> > +
> 
> Good to check page != NULL before using it below.
> 
> > +	pr_alert("VMstat testing\n");
> > +	pr_alert("=====================\n");
> > +	pr_alert("1. inc_zone_page_state() then dec_zone_page_state()\n");
> > +	time1 = get_cycles();
> > +	for (i = 0; i < TEST_COUNT; i++)
> > +		inc_zone_page_state(page, NR_FREE_CMA_PAGES);
> > +
> > +	time2 = get_cycles();
> > +	time = time2 - time1;
> > +
> > +	pr_alert("%i times inc_zone_page_state() ", i);
> > +	time = div_u64_rem(time, TEST_COUNT, &rem);
> > +	pr_cont("-> %llu cycles ", (unsigned long long) time);
> > +
> > +	time1 = get_cycles();
> > +	for (i = 0; i < TEST_COUNT; i++)
> > +		__dec_zone_page_state(page, NR_FREE_CMA_PAGES);
> 
> Why use inc_zone_page_state() but the __ variant for decrement?
> 
> Checking the 2 functions, __dec_zone_page_state() might cause
> problems if preemption is enabled?
> 

Fixed both, thanks!

