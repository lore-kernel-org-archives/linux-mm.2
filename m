Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B05606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=OnXs1rBK
Received: by kanga.kvack.org (Postfix)
	id 8411E6B05B2; Sun, 15 Nov 2026 01:23:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F14D6B05B3; Sun, 15 Nov 2026 01:23:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9156B05B4; Sun, 15 Nov 2026 01:23:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1FE6B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:23:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 997D2405A0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:23:54 +0000 (UTC)
X-FDA: 85436362788.14.ADA722F
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id B1282140003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:23:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=OnXs1rBK;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf26.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794723832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjlulku/2dq10AOxE1AaqZxjwCs9790A4Bi3utPP5NY=;
	b=4BcUKZvNTWTH+VaBbJdhufdMbLDZyAwIBqgCbogEVq6SMcHJDrWRNRmzZd3lT3gCeBmVD4
	23gm8wM3PBzqvI92TEEigl77nxiuEyot9G5SBc5L+CHB5f9WDNDEPRIUlJYN/kMPThR1hD
	NQR7XPO8ubWLopag7Wotb9/RWitkpiQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794723832;
	b=m5ikTMs9Ur7B/29tigGBuuc4S5RUadEvVYf/5sb2YYUNvlKfByCjBxIPBVzKFbLKqDDUnB
	YZ8vunKNb6wA14kwAeQkPpKeCeSRiujpXvK9bhKhYaovJEWr4tf7jo6s8yPBSjAdBukEX1
	qq+kaLD+hQ/BSwB7BTRSO1NCfyQw2MA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=OnXs1rBK;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf26.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-37d424f1ae8so799909eec.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794723831; x=1795328631; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bjlulku/2dq10AOxE1AaqZxjwCs9790A4Bi3utPP5NY=;
        b=OnXs1rBKQp7OoLsMiw5tZpCGBraz31+NyH/i2kbFiCKKh8cFVJMv/25DVwxVuO9o48
         pahdRVkSc1+Yp0tmqUHv/JPHN+qfsY4qVPkVEbL6Wfxz6kPszJilKx4AIzgb7MEq6Q7X
         mLvIKX00dURHbOFgrD1vYjk49s2bQG12rlKKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794723831; x=1795328631;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bjlulku/2dq10AOxE1AaqZxjwCs9790A4Bi3utPP5NY=;
        b=JMqiLkzEU9UcRvrpudadm9d6C2xvsHUndF203J+aGe3An4FDiyUxRPaoKwJrpCHKX0
         TvVB6JzIxKyhCFTWQ3bORDKa+gFxtuWGfIB1mJAFVzDW1Cf9Dn+MZJNY95NOGHlrM7AY
         b2gNBX4Cb91RKaK80O1oUhb0RJJTFJtjhffqmx5jYqmSdFttTas136DfAZfGEJCHG/Fb
         kku0sALDvYn/mjumRf87vhc6koQdR+lAmnppUCjFswPjQQxyclKXy8g4CS31Qm1fiONH
         fN6MMNtkcOu4UBQZELd5gGWBXoDOv99QsRFOa+0LdC36lVEUihX5mDi986UBMEQdxd1A
         3FqQ==
X-Forwarded-Encrypted: i=1; AL+hErEjt9vSfuOjH67RfbMA+f9JU5/fh9y1N2xyOZXi26U/ir8jZCgEKzMNmjsu9L+gJ9/LhVALyko68w==@kvack.org
X-Gm-Message-State: APuU4Z/c5y45ZrSCTESi1z0UIZV09iDHNR8BdACDvTmbFilCeYCqI/FR
	O3Ime58L0pHLGSjjsJfdiEyOrWJ8J2EkCitVxurbWw2un0Nc3mny7fGqD1/PjkVOV/0=
X-Gm-Gg: AYBFou3+dvHVhn8Df0THk3gXnoFupccbhNJUFjJUH3kUJTROKemzVifupLsXUUsqOWv
	/FbH2QQfp3xIQfDtt6JESAUKhYzIKySjuqoBxe08V5TXU4FiQMDnuhTE6wLWutBHcK3VpgMwPwA
	zOeUx5oUwPH84eb8A80/FrWTxcUacxMMJG8TBJ5kuv9S05P+EqBOKSkuBJZ9K5cFs+3L8GTx668
	/953dCpKlS3TKKcUTDhHsoSyXH9LxthOqicihUwVArDWKBXQPEA7zmRAaRJsiA3+0kHjXFJdgSN
	9hk+EV2W6xGiHeCMsRef7ZFk9U9V5PWqfkosn1WI85eFUNQTQn4ULYBEx92xJH6eSh/rRvYkSOa
	0D6SZn7CWzLMQCSexklJ3sSULmpa79EO1SnQ97zhSVZRgZkGF04nud5DnSgMQi+dnrH3+qNJ5BA
	Vre9u5ME8yJv3/2BRB+Es2u0ROtgygoGc9vx+TnOK14gQtV7+HngAGVzR1PZ0Qva4adF/1AQC03
	t5Sq5B3G2oH4f+UF33T0ZuQa2QLpk9kYCURCyk+Dr67CW7eve6IfPnwmI+PMf7P7Wew4tEQhd8h
	XVPIiitGjwdgkooZXiQoMExssRIDL+7Zg+wmIziNuP6lZX9tYnHn1PhLBXs+2c9hr8GA/xuDOKA
	LfzOcrfdctK+aqRLp+zUNaDE+brQKZmAsZhMJ3JaPuFaIpJ8JE8YqCook2KzYg4IQCKV8m0yNEh
	2iGn3uWfHBIKW0RdnqWSRixq4AW3qsc6prg+1M9dElgkrjCQtyK1qJyoPeBMzd/Xtsg0GD3i5cM
	kUOVk8HVKo5DIw=
X-Received: by 2002:a05:693c:6383:20b0:37a:c882:994f with SMTP id 5a478bee46e88-37ac891df02mr4316528eec.9.1794723831472;
        Sat, 14 Nov 2026 22:23:51 -0800 (PST)
Received: from [172.18.0.2] ([172.56.232.151])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50319e381sm20719709c88.12.2026.11.14.22.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 22:23:50 -0800 (PST)
Date: Sat, 14 Nov 2026 22:23:47 -0800
From: Chris Down <chris@chrisdown.name>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>, Sang-Heon Jeon <ekffu200098@gmail.com>,
	Mostafa Saleh <smostafa@google.com>, Ketan <ketan.kishore@oss.qualcomm.com>,
	Usama Arif <usama.arif@bytedance.com>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH 3/3] kmsan: fix metadata loss during HugeTLB struct page
	reinitialization
In-Reply-To: <20261114104150.58424-4-songmuchun@bytedance.com>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
	<20261114104150.58424-4-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114222347.227199839f5ffa44@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: iuckye6cwwq9smwzopnuq5zogi1awbmh
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B1282140003
X-HE-Tag: 1794723832-628490
X-HE-Meta: U2FsdGVkX1+OceUtoLyRO3ss2Gr2WmLvoMdGb6E/C+TwFrGOioA8a7KT+nJslo9KGvDN3lGcaucJPjq+UOSn7WzDhXGgbeDNvRHgpzPLuUKgaMgrsvjogMo5AG7FlMGe1gNz6/eQM8uyFLPldvJBcFYH44Fi2aM/uKLgq69jyPMRTeBcJSSityjcW2lTePY/uJ8um/of7VCv7f8fllFCScduN9Dkj2ggT1ysNu/pNMsYzGM5r/5S8Q8z+Xt2SUQIyP9B/z9Whte6IMt81rz1r6VZQU+WopdF87i9mJr0SwRvuy4SPh64Ql56Iiwm8OSCcbXcR5H+FHOCb8FwjlFFed6uKAWsMftvprOLjPSVKBzur9iAXQ8pPZx8+Urw2BA8VQ3nvjiVbN6xZYMkZizb6dnqDkd5c/cPGIwyXLTqOexGyafgxYyJs7h0aIh+Xe0VLRI7k5DJr/lsTyhRAUGThouQ3EVLT1cMOlSUWod9K1dIyVHeS00b+bRvlpuE3jYPlFpcwWBoKjkGhN3Ml8YPQoTOmen9swqqZJi/+rSrM2ZukoM+kai/T5W7jg71lJvvGCQFlwjk/kH9i//1T1PV5uMVTHEazZAqNWtFAxihfqSVfRBQqYMFhLiWeiB+zLPNH0jxecUQQHX04QSL4hD3pMnX40AuzufKaiILL1EaFWN4/kMdFwYdL3KWbnV3AICabNK/DHaIcpbFB1fQGMonxvof2O3qSuwbK2/LWhx4sg730SIxn2PMYLhfbLh7Tu+YXhWwhp18CdBzdhhg78IUGgSffw9mXnTpSCLa9XOgmJIlvj/qk36jk//LmZWR7WBoPTsRRR/9qZ0YRN4iKXdG2Dfcr4Nyk4czziQDwyHzt9p4XuVFz3e6KesGsDvpxep4JRZNKT8wBQ4+/+KZny3DBrnOpXmmACMW85nM+ykwsMqHAJTII/joSWOTYZayilC3qPXYWpDsuWJssuPNMM/
 +DYcKk1G
 pxbFWEuHKysxXlBNBHdiT0xGO8GYnzEgnIASS9ZadeQ8GiOJduMVvas38dDhKeKWmnjg80YCH4CAYjkr/qkNzxi+/s6qEjYKB9ppljTIwXesL4QkX1Rl2NC0md/DZy1aOPgyWRB9RTj4zG2MLAEbFSz9FRwTAr89mN4PmgFcWjPoBH1sEPw+K74Y1oMD3+6egfJ+7+E7MjdPh+3HX4tCJNLLGWXIvmBkj+k1KG4lkLjq742DT7NeHvSUzpuSeaJI3fHtVZnVZYcNlIvDFBaSwi/8286VpdnwU0Ecny70Md86IPIshc7iAM74o0olKkigtDzWI1XzXQv79x4vpj7SmBC59wHH0uCARJ6f9kX4EWVLSiWd9jibiFO8RQFqjXwU0aCrU6UuOShisA2T5isGjZArpH2cbUPxZM4bwdsha7umCZp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

I can reproduce the crash and the series fixes it, and I think page_ext is
the right place for these pointers. I do have a few comments, though.

Muchun Song writes:
>-	struct page *kmsan_shadow;
>-	struct page *kmsan_origin;

This takes struct page from 80 bytes to 64 on a KMSAN kernel, which means
that hugetlb_vmemmap_optimizable_size() no longer returns 0 and HVO can be
used there for the first time. From a quick check with
hugetlb_free_vmemmap=on it seems to work, but nobody would guess that from
the subject, so I think the changelog should mention it.

Documentation/dev-tools/kmsan.rst also still describes the two pointers as
members of struct page, under "Metadata allocation", so that needs
updating as well.

>+ifdef CONFIG_KMSAN
>+KMSAN_SANITIZE_page_ext.o	:= n
>+KCOV_INSTRUMENT_page_ext.o	:= n
>+UBSAN_SANITIZE_page_ext.o	:= n
>+CFLAGS_page_ext.o		+= -DDISABLE_BRANCH_PROFILING
>+CFLAGS_REMOVE_page_ext.o	= $(CC_FLAGS_FTRACE)
>+endif

This takes the instrumentation away from all of page_ext.c, when the only
thing that needs it is the lookup. page_ext_size is already visible in
page_ext.h for page_ext_next(), so I think page_ext_lookup_raw() could be
a static inline there instead. That way it gets compiled into
mm/kmsan/shadow.c with the right flags already and needs none of the
finagling above, and it saves a call on a very hot path as well.

>+	preempt_disable_notrace();
>+	page_ext = page_ext_lookup_raw(page_to_pfn(page));
>+	if (page_ext)
>+		meta = *(struct page_metadata *)page_ext_data(page_ext, &kmsan_ops);
>+	preempt_enable_no_resched_notrace();

This is quite a lot more work than the two loads from struct page that it
replaces, and kmsan_get_shadow_origin_ptr() has to go through it twice
for every instrumented access to direct-mapped memory, because it calls
kmsan_get_metadata() once for the shadow and then again for the origin.
You might think that's a bit academic, but it does add up. For example, on
a 2 CPU VM, perf bench sched pipe -l 30000 goes from about 1.37s to about
1.58s with the series applied, perf bench syscall basic -l 300000 from
about 0.66s to about 0.75s, and a dd of 300000 blocks of 512 bytes from
/dev/zero to /dev/null from about 1.63s to about 1.90s.

1/3 says that keeping the pair together lets callers avoid duplicate
lookups, but the caller that matters most doesn't make use of that yet.
 From a quick hack that has kmsan_get_shadow_origin_ptr() look the page up
once and take both pointers from the result, the same three come out at
about 1.38s, 0.62s and 1.54s, which is no worse than before the series.
Could you do something like that here?

Thanks!

Chris

