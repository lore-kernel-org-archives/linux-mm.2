Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B19CCCDB47D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 03:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3E88E0003; Thu, 13 Nov 2025 22:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175708E0002; Thu, 13 Nov 2025 22:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064618E0003; Thu, 13 Nov 2025 22:21:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E26648E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 22:21:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D8931A023E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:21:10 +0000 (UTC)
X-FDA: 84107761500.09.B8A491A
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6C35740009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:21:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lzUdZ7hm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763090468; a=rsa-sha256;
	cv=none;
	b=OrBWKij95S9YZMfVMYM6cT+XmuCYczPeSRGYEreLTRSPzFl4rUhJtxTWpqSMJob8PwzaWR
	rSX+c2fuDhOoQSryVyDJ0IWMKBT9p87tssB90xhy+psPDWAvuD2aMcIuWCnoyBnjhqMH1p
	tdU8IcQwmV9yD0nu7EGNRaxKH847Nd0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lzUdZ7hm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763090468;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/5wmX3vv4vFKi28xDhKnQlE+jF8joyjiRYUba0nN3LQ=;
	b=US7SYkEIkfRKMaqXPzzJbodk7BOndISFPmncdjTk0KkzpeuusyKRB2/L+EHS2VzpZsVR9x
	3c1Nyf4cXantR0r38p/0y8IEAAyjGelpYH6IK5YbE+3fUlR6Fe/yNFVEfpwnejMT6kM25P
	lNXvnV7NT65gJRKOvFM/URtp+mA9Hag=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b736cd741c1so27293266b.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763090467; x=1763695267; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/5wmX3vv4vFKi28xDhKnQlE+jF8joyjiRYUba0nN3LQ=;
        b=lzUdZ7hmGXkY691ZMOMQXh2/oTRoxVn2OlVkWe3knWKRf3I+y5JEiJPSnBGTe29mLV
         OZA58/deTuXy4XBrP1hVsmW0+scEgwrS9eDU7sEmPqWrEPXFMtslhW3S+DGcVE+fvaS9
         2Q4/KSpb/wkI94zdJJ9LzQPIyrjR6cFWA7iDPMsPFXAYZNmn15OfnKlYM0lo2AxzmlcS
         S4ishCIwUtXhqiQ2G265/V9kRIf6PHxZmZcxw4+aH3je6R1ebe+lPmSd+7umXa7gD3Bv
         yJv9FcO+tEdKyYEo4VmxgmIj4rYQmiMRqCAmi+HPA5ljvsyYFil0czvjRbZzg+6Al8qX
         /CdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763090467; x=1763695267;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/5wmX3vv4vFKi28xDhKnQlE+jF8joyjiRYUba0nN3LQ=;
        b=H14QkVbR0vhfQCh94U5H95uNp2kkB0Xx80yWIqKgtkd0HdncTKZnCyeWE87iBuucQK
         C3Y6Ii3EdPNWTjrEeAsqODm+dUcFWQNTtlzxyHe2AoCE5BAUHSp6Iko/zhvV4TFUHl/d
         n8GSYDOZaMJQj40yEG4WM5oHswG16qxSw5eOvMXzp24rHPgwegu8PGShycb6Bd8Uz5C8
         znQi0CxctuZHD1AEk16pvgbCZuUK3dGTeapmVh3V5oma+37ohXCD9IyQXOmzF2Q7jLHl
         u5Q8uiigyUrE+0+we0YIrqG2bKrz1m22dKe7c/PFvQRK0zJXCcBKRO7bFBr4FDC1DYVt
         DvSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOb6yrIXWZm1VxHaTv1QfZXNngnjfIaa7cNbSTVRlWoJvqsVeGhTZ3c3UoIlnsPexKXoT5eFPbHQ==@kvack.org
X-Gm-Message-State: AOJu0Yyl6o3ZYZI79rmuBvKxFpvV0hwB6wEp5joGt60tx7Y+oZnx7zxl
	wcs4J9Ubfzq5XaeCxpnu1dqjnwpURy70QfzCROeY2fj3Q0ygGhD92+q3
X-Gm-Gg: ASbGnctxJVBIO4DAbabhUSqwRP4a4CesdWayfUta8UmYc3/UU0OvfplINSkEuvP07/D
	5+l92eVJxLxYgkDJ2Pd1YKMoTJVZK7jqR5XyONIuhYHwbQiNMBactf3Wwl+XeAlNLb81gES5kwe
	0r0Gbj8//ClPHFVuziQeo4IMDbBP/diiAdpxz76gU2Bnlo1IA23uHMA7GzxgbugQtgTPNsQ5jwM
	Vv7H0HHJvm3EM1HtL5TqRC8GIQjX9fxPhhOstvT4YD30mPM7PedUsZ8gU0SD22jfGhbj1XV4l5k
	N84dsddMMGtKAHBPj2anE8+PwxlEZoXt+tGfm50GRVv9HqTVyt5k9SP4dNy8KrJcgIZCMrq43P3
	BduPdCxHQFEf6Xu+LeE1Vjd19F8L7mROPMVWIrdKbn6yEw67pK/b8UB+tczJpXdRzO/x5zQXVNV
	28lhACvR5nwjfyD7mjMGdUVXZc
X-Google-Smtp-Source: AGHT+IHbuUMBYx1gZ2NiTOoA/bD4B8HTfyo2gIrHxPc512K6tga1/jOkeezR+gJcq0oCl0G+5ceVCg==
X-Received: by 2002:a17:906:f59c:b0:b71:df18:9fba with SMTP id a640c23a62f3a-b736780caa9mr157876466b.15.1763090466739;
        Thu, 13 Nov 2025 19:21:06 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fdae69fsm289095866b.51.2025.11.13.19.21.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Nov 2025 19:21:06 -0800 (PST)
Date: Fri, 14 Nov 2025 03:21:05 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
Message-ID: <20251114032105.sdkjaoiwpdmpynew@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251114012228.2634882-1-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114012228.2634882-1-balbirs@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C35740009
X-Stat-Signature: 14bipxzsnsoyqypczgax8b8so9ticsed
X-HE-Tag: 1763090468-373292
X-HE-Meta: U2FsdGVkX19WfpAYBVvZmNLJC+GS88wXt4iAB15+JteBxO5y+5qLIMAinjN1VDlReZvoiNkZ2CMoksqryTX9obrUNQ0Dz88Wi7L21Y/Uh/eT/OGz6eZQuWIoxyVcYBjQWQoyI2DRUypc68piVEP6smTLirMaM0voTLrF8kmSnXvRahQn+4uEFFBYNW9AL1ddYuglm3y551is1dRkk5kKqFblzNN3MVGo/4+xhKLZYxJ3batcMIfwAmGaFRpK2RjkP27+bStAo+g4zO6Iv0Cf/NWAImYuvmeMOxg2Vbm9T2xTCFcCioFeTntq+fu4zrvSYk44aB9QHgl/sBlqV5Tc5iN24SSMQDb6Q/a3MFznWE3OMhMgu8rogWTkKsYDOtRdsldy7s4zgNLnWFtyOAelg2Xst1XjHAt0+WR6zN+GsOkF6s20b/l2rgI9AbwEiMrq330j23QVZ2eas/DppcG4VM4E7u+CS1D8hdLrYL8W3mjgUGBLBNBFlHUUk6en4VaUNLoyDkH8rJaCojHfRqhVOjKQHcN0eZZqct1MvnZkEpG7X6KilMCpucv0UVh4iqIGr9R8ORTJsq0ep7tOGgZxw16x+vhtPUVXUo3OTbvCx2n4Y8gNDwvHl70f5Ixj1d7jdokGUjHO8celObh9XHE2QdUNHiW3SYDrjmtHt8u1nD3tm7TOmOX2SAE244ZCOEz/X+7J616TFIWKrNDwH4jZh8+qyTYuDx++zGX2cJbYF/lpzfMPIuugyEp7jk1YslDs05tIlHKADXzfuFCLSWDbF/uOlwX0yBsbT8ym0LwKPuLMNWGt32jIAfsAKDZPLauEhU2WYnWltIbb16iKaE8TQ0D1wWSqGYcuG+MlaESz3Iaws2CDDL2Vf9XRSKHhBMZ9MwyQYEGIlQt0LeFI3l6RLQDAYPxm3DJMsnBdAyS9LAJqWrmTiGYJLhG0qB+lFkhw5OIt7TdMVO7XBVJg+en
 cgkG3cUn
 69H8zyo8gGR/T4XsfbAzCt25eWTVsWuQITEjfR0SmKY+nSC9RwemlED4fYmQWOzJY1/f94ndhFSBVuI4EQfUvxDtGQ2N7h1lpwggMp/NY6+m1F6iEA1bmYUKk9IXsMQ7HGv7460GXNblARrAD0wpjbxppvmkU8Vh+ylZNIDR5IYoF2qVxmsNvAaSthpc3S6EGRRugPPrg8JCQJlWSF35HbbY/OPy2vyh3x+i5etz5LKiRbs/5BMLlywZs4YMwh+eH/vmpHi6lM+LAKM3IEe5TJZkB3MaFTPoma8cK8+mq/GDet7u/reK8duN9dEs0ZUyW6/+P73YNG/zoEqDBaTyYBN4p5QBrA5GcqKbkmhjHEhY81Nqicsg7JAkT4NZ3UZAUb0D8bDyqGYD9t9TDBArI+OgppLzC3/Oo7NmsxIY8Ke5Xq2XO5KJpM4wC3OoXPg08to7F1yc8GUId2L/2+J9hD0jWv58DszIFW4S7JolGwHkdbr/QjXCVZrtqueR6onBZFQmyorEMbQf2cB5NN86WTk6/3YB8phkHeO5wISxDL5m1YNa2Ja+DfmoJYgd3t/uBdsFe9iwzxCA3HlhnYklFV+9yPjXwDZeCxZt5PRiccVgGcMX6c5DAGydarvxRMQCpNFMiPelJrrDKz37GxEsud7qa03C9MEaqhkQmqOIhIduIgTQG0dGORzupVemJagtphzuVczbUaVREiCg6rVzlaC+FxRBNMwL4uNl4U2u2iZ2Dc9Ts2LfLdbrJTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 12:22:28PM +1100, Balbir Singh wrote:
[...]
>@@ -4079,6 +4091,36 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 	return ret;
> }
> 
>+/*
>+ * This function is a helper for splitting folios that have already been unmapped.
>+ * The use case is that the device or the CPU can refuse to migrate THP pages in
>+ * the middle of migration, due to allocation issues on either side
>+ *
>+ * The high level code is copied from __folio_split, since the pages are anonymous
>+ * and are already isolated from the LRU, the code has been simplified to not
>+ * burden __folio_split with unmapped sprinkled into the code.
>+ *
>+ * None of the split folios are unlocked
>+ */
>+int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>+{
>+	int extra_pins, ret = 0;
>+
>+	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
>+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>+	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>+

Compared with original logic, we did check folio_split_supported() and
check whether new_order is supported for the file system.

Currently folio_split_unmapped() only pass 0 as new_order, which looks good.
But for a generic helper, it looks reasonable to do the check, IMHO.

>+	if (!can_split_folio(folio, 1, &extra_pins))
>+		return -EAGAIN;
>+
>+	local_irq_disable();
>+	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
>+						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
>+						0, extra_pins);
>+	local_irq_enable();
>+	return ret;
>+}
>+
> /*
>  * This function splits a large folio into smaller folios of order @new_order.
>  * @page can point to any page of the large folio to split. The split operation


-- 
Wei Yang
Help you, Help me

