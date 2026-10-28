Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6002606A321
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 05:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=d8uBw4I8
Received: by kanga.kvack.org (Postfix)
	id 919756B05B0; Wed, 28 Oct 2026 01:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0046B05B1; Wed, 28 Oct 2026 01:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806A06B05B2; Wed, 28 Oct 2026 01:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 524EF6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:52:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28A58140B98
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:52:25 +0000 (UTC)
X-FDA: 85370965050.17.EC6E6FB
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4439CC0003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:52:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=d8uBw4I8;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf28.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.182 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793166743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0+YQ8IhrloxYZmXJNyf64tQivuQ6Pn/Dp36CBxwNv4=;
	b=6CAnJ/4B27ri/6/EMRhzf6pSSTwODZHJqYQswmzrZgNpyYq9BBpbOIUSPx8o9Qy4TciK10
	z/qBF2dtYupX8DRqAwvqrHw5nyTIUSNYf44rzx7AaBmWyea5z+RHwcRKJpJ8Lk9k2Yk2W4
	NSeYdYEnUDrV4JpTgN3s3nNjyQkq7QI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=d8uBw4I8;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf28.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.182 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793166743;
	b=kiggUCm23jB+xMDJ3hGGPtMC0G9itQ6BxtAVPA7i6tx1LcDU5+H2XLmk0c09r4eZL8syWx
	KBJXZJhYbFIJt/fiMDq7sm9o/NBU0gOolv7XJftNu0W00bjFCG+h528CrB7g34LqIOR+93
	NciAUVvin1gE8b7YIwU1kjTZFutNC+w=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a06454116eso332151b3a.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793166742; x=1793771542; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=o0+YQ8IhrloxYZmXJNyf64tQivuQ6Pn/Dp36CBxwNv4=;
        b=d8uBw4I8v7xgFPmx+U9xrJ2yOq6x5BAzfSGuLXkxk3T0ZrqEJnGLJav+kN+EYXKNFy
         TrTo4k4tCz/Hf5yvc724bVPKU5q2adWLRwVPNmqE1zJe4lbBYW9RftOax9zEepOVLvCa
         017z5A9q4/4swv00+HV9XICLLZVWP5Bj6/o/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793166742; x=1793771542;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o0+YQ8IhrloxYZmXJNyf64tQivuQ6Pn/Dp36CBxwNv4=;
        b=oj89PWtfoXm2+/6/QGG9gaenYNQ+4jIYwqoC15mDDSG0R5+6OKcXaHZSVHrBiIZKKL
         Mn9jJ+V2tBBDATIn2wTIf99fWkI2MPB4Tiy/k3jBAg+WipzgLSrlTbzS/Gse1dfvATrT
         8cdkY4VEX5JzA3+x/BwRvtjF6Ac0IFxxbhGXofxg3kLIJ4PG/Uti+y8Sicayimtrr3ek
         fZ5K3nLwtoeSQkIrM/s9Fn5zPXVVqeq50pO8cKeNdKP9XcUSMBygGyYDjTENtjsbNoap
         0C6+B/RQ68pJxhSukKSrIdY1kdWGd9yLApBvsUWYwI2wlF8k9mPn578loy3yMzCDB96S
         0YLw==
X-Forwarded-Encrypted: i=1; AKwUvBzVaIDF5brKGh30MYZtetrWJMH5LNuQfjQ5UtwyeO8ozS3r/K0kg6XIyu+0VO7AE0yViX2voR8hyA==@kvack.org
X-Gm-Message-State: AFq9FYKl4q/7Y8lk584GCeLCc3kH0T9PGqgPrMJlMqvttyeaBbvXh0Me
	umpiuryBX2R6iuZbUNsEgi9Pv54zuYoXbvjss4QJ9+/5Q7lKBvhcdBTe6uWtz63q4yQ=
X-Gm-Gg: AYBFou1wZdSO08ehQ24DxRueBXX7TfKyMSQe3pX3Sfcx/YULJvMk/Ihs2TPKo4Wd7bO
	qgfVd6yqXIUAe573tDBGdVPZFbQvCaSEzl+vt4gVLYY9mIEaR2JMRZ6JnAqmjOyq5BMcAhsEBZk
	qqq/ttuqxOvNqhmKarUNw0+qafrSQd28+xgqI+DQ19N9XEx6vIN5NAqHv4Mf4A3y6lEMQV3jOr2
	hpQYKHIxyDG866oMr0MFyoMAk5SUHn20sVuVqNQ8vseKYcUl1sIGQKgd6NBogM3oO3lLtTo11E3
	P+ZhS01rZHa9cUGJlnj95BUBMFaCmipHw6UdKGpp1Hzv95R4ttRZpteg92+S3dwSsRG4PUPmlZ9
	4sf+yY2beG4nkk9H43xhy265Jbvfw+T7nyppJ/p5ftd6wvoaWOBo7w+tQI25nlxplKH73Sn/+W1
	BhZwfp9+j1JxuYvF+QhZFi058G3AXmkzRPpp1mT9srRCNVazQAaxrCFqSZetZYJHq5kUmHOfwiz
	g7dD6mkf6MPBvKk07b6wJ5a5QVJzZ664dHKd7rwUTNpxDKQF2vKovmO4lme+tjk6lipk/miXs3S
	H2WJAWYsJ2I9yAX/lp/z35F92NbibVBPwdSH19Ugr3BnmWDUcIyaiIyGayTqGwFoiewgHQt8zv4
	YGexI3Kr7YXlvesXKx5CM3+IMwvcpVFVJVsAZFF5GnwwAIZRe80fQb9LCwDFwvyeq4AAyq+u+
X-Received: by 2002:a05:6a00:4b4f:b0:88d:20ff:15c9 with SMTP id d2e1a72fcca58-8a6e7acb277mr1168038b3a.17.1793166741947;
        Tue, 27 Oct 2026 22:52:21 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a6cfc785sm695363b3a.38.2026.10.27.22.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 22:52:21 -0700 (PDT)
Date: Wed, 28 Oct 2026 13:52:18 +0800
From: Chris Down <chris@chrisdown.name>
To: Jeff Xu <jeffxu@google.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>, Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/3] mseal sysmap: Add mseal_system_mappings= boot
 parameter
Message-ID: <auGNkhSHpBRd2U_5@chrisdown.name>
References: <cover.1793094611.git.chris@chrisdown.name>
 <5bd3c89d733ad22224f296dfa8900769de937de0.1793094611.git.chris@chrisdown.name>
 <auCxjbvY3qPv1sV6@gremlin>
 <auDTMb6WMFUpxeZy@chrisdown.name>
 <auDTptDQsB4xBcz7@gremlin>
 <18e2972cb8520c2e.3137322e32382e342e3434.279dd1.0000sendgmr@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <18e2972cb8520c2e.3137322e32382e342e3434.279dd1.0000sendgmr@google.com>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: 4439CC0003
X-Stat-Signature: ku88tefttrkiw6z3mbkf4e4zy464kotk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793166743-318633
X-HE-Meta: U2FsdGVkX1+n4KVPvYib0gR99ikvtuP8OH+C6CzX1x+jq8+L5dSLDt1cw1Y16z+FipXVnMOwONvihtTvU5XelwGcCFGbMLzmgJQx7rD2fyq2P2lfclgcnFj6PdG2jfdetWHpMBrgJWSBZ3B2BEmhLb3YwYVyHdCEUlanB0xC1AGnzjsgz5v1lj7PehXdsy3hZUJLNiSGO2E5o0rmBAV81kmShOWV9yCYHyFMagm17x8qoIWU4PKKFFddpTWnunzZOOSEMDp7nsM35p1c+lpunwiUENsPeSdFwKfgyT0B7pxg4bbhLInNjfBoDqwY0jySgZfuFcnSIHcaqyPlK9xCxOpEj4/rMu2dQmAQ5pYWBX7XmsPp58vpgsgVK5Xwj42MSpRWgK0PhsaNuIOwZBEH4jAxiQlyBiqhEw5z11SRyd5h4a9bdtuxn+RutEF9f9NlZmIKSGR9uclc61jjVKWXCVeXg2813PGe2MCmCofjnrb+esef7jot0dsnYQKP6IpxH4LvwczhCFKDs/AUv3wwh0uA3i56x6RlxeQ5lwa/Uh4BqGCkK9SjmkMJyug3/qEhFQN7+tmTjcB/CQL3TDPXsEp3bCxCeeuXfl9GogiJaMQM8i8pq+kcWwikRth+er6LisP7RzhDjTM4ep89pFZUAOA4oFVCVavHgJafH1Xnn563wGc9RWSfivuLm4GidOnQL2Nwd29aRgq6GfbsZn80m2jIvfHwpLwIxZbf4U3wBUIHTJzmXAdHcvTnWB2NZyO8NDmy3DjoWrrcYUrN0dAL4uUFk0VjfjxDerMMqmrrFT/U0aTRePc00IH4sAONc3HhRc0RpfdWB8i1JRw2KV/GW1IdYFEOsDwSHhnzqr4s9CPJaT+S7hL3MvuenRPqoYyKz4NWiStGgbnuRRVS7KyRBmkJF62NVK+QEgaeJfzwsas9SvKWUGgLm917Nditt/IQ8yrGMPAI4GGkRA8Wt6h
 tgk9OL22
 OxH2cTyMk202fsphfF+JTyzcXgyCAJuNL8N0Sg8Bc7ATgKoEKpTYT87q9eCOylpEM5QPnbqH/t3k0EIp/FIlyPstcpVyBp8PwdnwpD5fEIinWU4/ncc9x4tPqw+OSggQ3ywQI5DSU7PBkIzpmSEvz6BF4YwPVWt+EZkNUEPs4nk/RwYYA+3D5UJV0HHotMJLbjGIgcdWw/lENfDYoAYa6z9+q0zWaYf9amqg+SrYWWGSzSKWsVvwGl3+CORnWhUaCmEQ1xxVWDODz5PAFCPjYo5/tFTiZd5C+KgGawLwnjoQ5k0BRm6gJ2XMPtke5/e13Wi3RCFHXeBflcTqlafCC0iIZYePEJ2Sw96OEEwel29rA/eOESIpSi0Jds582bJZX8vd6EJeh9JX5OYrcnpmwIvNI7SUiPLhEH7dBl37/d7bU6uZ9R1s6Ktxj2XnwY83xwGusunsnSBsN2IGMnPtgf4yRtjvehG/nd7hnRcfUB3lb0sfZgOX6Sa2Ic+NsBiIyGl5Tk0s64gHDLug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jeff,

Thanks for the review!

Jeff Xu writes:
>Could we please keep the test coverage for the unsealed [vdso] case and
>avoid unconditionally skipping whenever [vdso] is unsealed?
>
>There are two regressions I'd love for us to still be able to catch:
>
>1. Kernel or config regressions when sealing is expected to be on:

Yeah agreed. With the cleanup it matters even more I think because when sealing 
is set in one place the most likely regression is probably one that unseals 
everything at once.

>2. Regressions in the new `no_mseal_sys_mappings` boot parameter itself:

In v2 I can check /proc/cmdline for no_mseal_sys_mappings to do that.

Lorenzo, I think that also may inform your question about whether checking for 
the disabled case is redundant, right?

>   When booted with `no_mseal_sys_mappings` (or when unsealed), running
>   the assertions in Patch 3 (verifying system mappings have no `sl` flag
>   and that `munmap()` / `mremap()` -- and ideally `mprotect(PROT_READ |
>   PROT_WRITE)` -- on [vdso] succeed) directly verifies that the boot
>   parameter works and doesn't regress.

Sounds good.

>  or keep strict failure as an option (e.g. `./sysmap_is_sealed` fails if
>  unsealed without the boot param, while `run_vmtests.sh` passes a flag
>  like `--allow-disabled` when `CONFIG_MSEAL_SYSTEM_MAPPINGS` may not be
>  enabled), so CI environments that expect sealing still catch a broken
>  seal.

I like this and I think we can do it without adding some of the complexity that 
Lorenzo was not so happy about:

- Have check_sealed skip as usual when [vdso] isn't sealed and param is not set
- A new test, say expect_sealed, fails in the same case
- run_vmtests runs with -T expect_sealed when CONFIG_MSEAL_SYSTEM_MAPPINGS=y

That should be pretty minimal. Lorenzo, Jeff, how does that sound?

