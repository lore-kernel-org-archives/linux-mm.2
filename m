Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E189606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PN4x1n8m
Received: by kanga.kvack.org (Postfix)
	id 6B04D6B05B0; Tue, 10 Nov 2026 00:45:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661956B05B1; Tue, 10 Nov 2026 00:45:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B5B6B05B2; Tue, 10 Nov 2026 00:45:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20BC46B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:45:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A17AC07DD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:45:41 +0000 (UTC)
X-FDA: 85418122482.28.FDA68EE
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 91C1680004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:45:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PN4x1n8m;
	spf=pass (imf02.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+E82dUvkv8bQC8oFlCDIESMAlSG6FiZTUr4W0LfqWTA=;
	b=bSfmDxWcwFkSAcGbQ8/YlWWsOmZwH/rCv9pB3evPfrSZ5PmffhhSqwb71nFqEO6o/gVrit
	3d+mfFwt5WDuigF1MNLaCWnrmyzJcBcN2NujukPDLDdMQT1HlKuNO9qJukdVr2ZjbvViDf
	ejyr29fooHLFov/QlFVN7MuopEgUl8k=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PN4x1n8m;
	spf=pass (imf02.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794289539;
	b=DKGY93gfzLci+smMZ2TQkRNrmfXqqtZiR4tr8J3nSSwVeLfZhb5vCJCitysNfMtXj2LD43
	M5LZj3Usuds2s6j3CiySHlVz3sFsw4K1WKFTDwddpjlZZIGaomY01RzzSnosJ4+2/XOIIK
	lIwH6WjlbnnWpsujnOSJoEDx9e1QNt8=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a018493d57so20185e9.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:45:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794289538; cv=none;
        d=google.com; s=arc-20260327;
        b=cZTgA957+gmqY+p9TkJQVcGkcCC17TJupAAFZ9a81ra030Cvu0Q8D6pqPYWvuPWZUx
         LdJYa8o/0lHbBXifgo8XGG2hUsrSQtliErOnFD7rt3Yp6QUg72xcv1hlTn4CcrJT+K3r
         KbWGHROR9/t3y6pzZrS0vaVTM6Ql1EPaEhWPi0fxgpCgJCRtVrk/5Ys3hZPMzeZcxaX0
         ra5ebKSXNsgMMz/uOOH57hrmgmNc2DcWRdr/NsIve2xRNXZbISafdBuBkzRBudtG98lm
         0oZDT5/seG50Enhas41cyucfojG18fXRZtU4rujnhPW+3bStFzU3GFNK+YF0gZSiPYim
         +e2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+E82dUvkv8bQC8oFlCDIESMAlSG6FiZTUr4W0LfqWTA=;
        fh=AND++HT62ePs5xdr3pwLvSjpXtDsjlIGMZP5dRoc9QM=;
        b=ZZpqGi72Gvn0Oy3elt3Jmnm1Oy9CIS8beVyGWM0HA4jT6gavfUsI5EGil2ZptnLU1X
         viCynn1tUidxsJgE44VWFJbu5NeFb2B1fBtLm5CNLScWgkhC9nVkBJoOoAP4s842+5rW
         IPmq6y5+uaFaNX7+6VshTyBx1bQM73nDkzhEo8UORJHFLIVnSqcB4i+6QikCgX+WJ22r
         cSbefmfgKSo2RRP9SMwQmODPh0IAyOWexHZNJr2Lpiht5ag/A/b0slOQpqWDB2aIeyQ7
         LJwEFfB/awQaNn/ecyw99BrrNOpEdvETzjwyLjXfRgKJ5knw1aNbH89tql8VxV232rdr
         3ycA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794289538; x=1794894338; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+E82dUvkv8bQC8oFlCDIESMAlSG6FiZTUr4W0LfqWTA=;
        b=PN4x1n8meGpaaGtOPh0632LPg7WXVGLs9iZMDwl9Ths5W+oJas4+3IHNO5fvcPNddM
         PJAmNazQw19UiOO1MiRzv3TTpZ4ubxjm2LXRjh7lbry6mHbaIDQot0yNlYbcknMJJOcF
         VcenKd5UNOzr+3uNFDEx2bVj2pAvPpBomUuizluEJihjEV9T1ayAo1FQhv3SsAjJBvZI
         a2bC8XVDoj2Oud+QbphcJPCWZLwGPfDFamIPjjPKY3pi3Fib0ZV4vRP1sfrbm3QrF7GN
         zDMhws4ndFXLKrDANXqJWe0IUFjDYOsWvziC18fcy0uA6TkJL740TVxEI9aP1h06jvQf
         quAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289538; x=1794894338;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+E82dUvkv8bQC8oFlCDIESMAlSG6FiZTUr4W0LfqWTA=;
        b=CZHZIUblw0FHlW+osRx48sZsC3IyJWi8LmKG0gAF7kSAb5FvVUSfk+Dp9vHlbHM3qo
         xtRz23p2KXS1/xMvNLKejaA47fccvLP4mslt9N8a7c8HNt6B7nGk2XgaxPbtddHLaYRP
         bY0lGDJIIXXUe+GOV6eN+02sxBe9D4FTMp0pG1lg8jMkMiJeNEFUp/zULyOXEiJrVQLm
         waQuPOZuLqhH/disjdjYnu7JazUb+DOdoHIs2NBWM2aK8yTP7K5rr5XDaD4uSAloPkag
         uQCIewJeBfqHZPLSYXo2Gct+ilNuftL6Zlki46zUsFBc6iAtAHUBHl5blb6BK/TD1gtz
         ZWEQ==
X-Forwarded-Encrypted: i=1; AL+hErF+6RK7/+BSfMcze/DAzUgGWXGY9FYVlxC/7M/3dOnoJa3tVbJQyiEHxhxcOcYKWJcAhzeXwE/3oQ==@kvack.org
X-Gm-Message-State: APuU4Z9UR8ilLX1GBY88zi1ZEvGFc6OF5wBah1xb+CBPer67vm2b9hVq
	hxe9SYlq0M9qFhn8zMCZ29GTOcLONSt5C0ybh7Ub281jwrOfoWwNKzq5WOqCzbQD/7S2zoibZ3m
	CG4SiZhT3T7UUKRhV1JYrv+SVlcsVTStdyKadoUV8
X-Gm-Gg: AYBFou1tWZ713jCWNAaxOOvVTLXSuCdmHjq/hBQiuhc+RwZPYFj2CiMqGaFambsSYyc
	iEAJxRiM4XrjwAevGih1/9KaynVC7Ju6JNNYMeISoia9nyhXnjEJi4YPuIRlofSlOz+zT6c3tvl
	vI84BK2eSwve1b/HK/cLgyoXATJ3PL7RkC8WOjDWXQ8RdrlE+gvp7otfMLfftckNUGsP4zfaYhS
	fGHgk3NsMZZ6oCAo7b/ZMYw2JbGnqDesrF4z4eRTpwKHLfq3McGQnrZgYVfS68vOQtjs8O9Hfxv
	AfF0SBGXAV8+xb+lxKWbnZSqyYMI4M4bWkpDL6LRLCvhrAsmKYEK8/vqAX7fQDqdBThakisSa5P
	FMQWh3K9lXyxUU8/Kj1gzFtLNctK05OsDHIt4zAzTfMhWHEuDe7JyMpm99BnUUpljEquf
X-Received: by 2002:a05:600d:6445:10b0:4ae:4442:ac17 with SMTP id
 5b1f17b1804b1-4ba0236623amr435715e9.6.1794289537823; Mon, 09 Nov 2026
 21:45:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com> <ahXI0cK9fsOByvKy@lucifer>
In-Reply-To: <ahXI0cK9fsOByvKy@lucifer>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 9 Nov 2026 21:45:24 -0800
X-Gm-Features: AclHuK8JoFravzJWRGELAyfLQvRrdOszwg_B9l1wvjwh5zE1CbS-L9cnu-hn2ZA
Message-ID: <CACw3F51Q9TkMWr4WbnN07q60L6vj72-hFWwpqf0n6rf+drfb0A@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] memfd-based Userspace MFR Policy for HugeTLB
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linmiaohe@huawei.com, william.roche@oracle.com, harry.yoo@oracle.com, 
	jane.chu@oracle.com, nao.horiguchi@gmail.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, willy@infradead.org, akpm@linux-foundation.org, 
	osalvador@suse.de, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yp8swmyqsatfy6fcekbshsruixzwajyn
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 91C1680004
X-HE-Tag: 1794289539-917923
X-HE-Meta: U2FsdGVkX1/5RLuzNBIKs192KkjM0JNQO2Zq4oxYQY2UDU8/gXGlNUN33G3zmMVkidGwUO/T0ynIAPhy6IrM9sHJ8svFjmhJAIYFb3fx/aSeVEf6shBjgIrQSWuzK86qDnEzD+YoznFPJFLTxiGWU0D7n1IIDrWZ5D3wB8qRuE3YATlsYuap40cmmXZdUb6XwdNdy2tlJmr85a50GZzj7zKjjZ84vXgqWXqsUJ2Rwif9pgUueeQvNdwsnmv3sHw+3nw4Jy4jXqtoqodDLGCOf5V/M1Ag4NWgn74alrqV/LwmK/BKVMdRIh2tau+ZF/mmJ/RnWCQF3O3gixhjL4mrcYJr4h6TlBDO+L9BKpOxf8hhN2NhK7Ia13cs07ogxuCDkXs2zeQsgfZp/6lrcrsZUATfBLik9Xu/MMcY5UAwtz42KSuaGdLKtxuzW/78uHl9VnN1xKa0VBLbMSPoEWfx9MIK+At6lmVii4dD4MKlb3hBi823azTvXgambeHpH0KM83UO8WFCzAJomLyAb/iA563qiwZJgAi1530/Ujzs+DAweb64K23kT7bG5sgNVzvtsIbDR5tKEXGXCw1SpKWrcnbrRAE+RYjlFLqvp5h1L2+8k7vJzmaSCUNJWp6KOxOfrk3vtxNWJk8t0dbG6D33BpFzMQQlEvDN8DlYOQm4AXhFYLQS1di0GPs0AMZCVqG+78ZJ3Rws5gFa6U7z2de4I3G/Cwhh/Etu2oueAtP4mpickpqjcho8ccEorf8rfE8pHKkixRU/hS+CRq47QsXwOwaVlpZAmaFFBHs0V8fyibD3Mxn7odg6CCYrsQm0jo6qo4wv1cx+Lx+PMsTpFiJGcfKtFPENvXq3xPr4inL3NMnmHhl3iKsVQv/GFjj/OO4/WS8X73R4U6lD1P2eGrbOU3MXHJYmIW0DdeeB3+kxcwbiOwh8Z4RLvL4CAX4MDlG7yESsiMhRwp7GQzwAPxk
 tB48WciQ
 5L1RBlrMvu260U2WHVvaJtZULJgX+qj8Xix3mO+0GDn2G58kLYTFCJQtyzIZ04cgX2EHshHNF1lgmZjOaCMNP4RxlTCk69D/JzwRde48JXOpY36OkTeGM6HbpcDRSNF3nQK95pXLYB/dh1QOD0r1T57SvMwnT5ve4PxNw5RA8e0IygzRm3bP+fLfKjmnmr8PU8BqhBnRR9OpY3PDNOaLs08y9gJRw2x+CHGNY/mBlby9iKPAR6XTI/SpvVJeiGoOmjxz7pxLOzbdnl2/mjLS8eECATd+feXnNFl2RAtI+S4Ym+1llQF1nQEFlRuRH/7JKiRRq4OLnrXUbE7AP1+wNzJWwdOYJLBnawhCsZA2R6LiykVjUQSDQ7nucRrnLwZaBBCFIbN+8FH2HdJ+5Kka27ISgZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, May 26, 2026 at 9:23=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> Hi Jiaqi,
>
> It seems this series got stalled on review, wondered if you planned to
> respin it at all?

Hi Lorenzo,

Sorry for the late reply.

Yeah, I was stuck on the issue Miaohe pointed out for quite a long time...

In offline chat with William <william.roche@oracle.com> he expressed
interests in taking over this patch series. However, he seemed busy
with something else and couldn't get to it.

Fortunately we have more powerful AI now than we did six months ago.
While I worked on [1] with an AI assistant since 2 weeks ago, I worked
out a solution to the issue Miaohe raised [2] with the help from AI,
and now a working draft patch series. I think by the end of this
weekend, I can send out a v4 built on [1], the patch series I just
posted for freeing high-order folio that has HWPoison subpages.

[1] https://lore.kernel.org/linux-mm/20261110053331.2708996-1-jiaqiyan@goog=
le.com
[2] https://lore.kernel.org/linux-mm/5e0fc743-eb44-b69f-01a2-da7b6f2eca8d@h=
uawei.com/#t

>
> Thanks, Lorenzo

