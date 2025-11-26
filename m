Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA62ED1039A
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3849C6B0029; Wed, 26 Nov 2025 05:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35C136B002A; Wed, 26 Nov 2025 05:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2730B6B002B; Wed, 26 Nov 2025 05:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 138D06B0029
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:03:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADDAF899F0
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:03:34 +0000 (UTC)
X-FDA: 84152321148.18.D011225
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id A83BF40012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:03:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g1soAtyZ;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764151412;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykctEEfEkXvMFQ4wUOVtyWUvMU+o2tt8Ek+wdyE8hFQ=;
	b=LQG9zp4FcxvUoNieOuRu0kHMt9U1AiTngLxW11jLQOQr4eq4a/1rt38ymxCE5U1fmVLWU2
	NslLlMxgmZTt3m668fR7cTkiuEyzloHR9EDPlrIk9PbF+m+W8vP5G+mPiMR9WCrpgARfLH
	wyGTL7wg6u9ee/M6rHcOGMQzJIzF71Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g1soAtyZ;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764151412; a=rsa-sha256;
	cv=none;
	b=CNqXo9+8Gn03dLKfkSFrMZEwj2B3YhlaS1fMQy1w40R68C7hPQQJ5YUb3GCpExtSM0BtG7
	Yu51ykGqv+jOesLVyEyW2xvEL78xbY2HzKW/WiJt2o+gyBpG+UlFwCeRMNlBhbO+d7WUlW
	CUMo57TK1PG3vQaJpAZozO8UKZIj2c4=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b73b24f1784so135740266b.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764151411; x=1764756211; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ykctEEfEkXvMFQ4wUOVtyWUvMU+o2tt8Ek+wdyE8hFQ=;
        b=g1soAtyZ4bQnlwgClmB9ngezQgDi2gnvKSIGw2qfUmy6QURPMb2h7git03uj9vJdjY
         dMj5zX7i7qBo90WPpXa7BrnXdahfnQyGeeWj5ytX2Ajk2sIDpQBDoR8KUvXsn1NIrMT6
         hZAPOZ8M37iXT8+Y1Ch8l8kk0mh4ZrxyGT+NSlTK37ip9f7OWis2On4dVXBxQ2+4wRuX
         3cxP88b2bda1pnboiRjFViR+2MMouqvbTXZkI1PA6I/z/Nhk1WCQxEN+cuYAL5Bo4OXb
         zLJTO7Wg/bibFit31/HTZ3lWkY0CdDngZXVhPOzoMyxqZ6BcJ+HUCJHcEIm8BHmgkjzM
         aaqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764151411; x=1764756211;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ykctEEfEkXvMFQ4wUOVtyWUvMU+o2tt8Ek+wdyE8hFQ=;
        b=p4cx4oBmjYLh9qbjNuVcl708hA0VOrZgZvq1NN7voff9DpyrZFquOiBRH4AfTl2SAC
         CJECNwfktfbM1DoAkZDkf2xUA+I3QAiV+zUEwy2p4ytFUuFoo+Flr5E8lz8P/xmUchad
         VYFOx4Y04ZDbu3NKZHLYME3KAQIR/H7F5u7sxmpTF24R7h+gXRCkHq8pf30xsO4/qeBc
         IXX4oVEVo8bo75qhOkc1EOy4jdNoCjv8fwTwieymY+qHX6TKIzG+EyI/4BvywrEALsJc
         +Sn19bxzdpVQbRCzpnFZ9C8k77Zqf/Pv9lGYaxF6i/O4ZjjlbIskYRA5487oSArV5uEo
         lPqA==
X-Forwarded-Encrypted: i=1; AJvYcCWVogf3XlcOujzvAEsGxWw21/IzaDDjpmBnsdgOcGuaxAKDvmQDpR3G3G2CCaAD+Nx5pRv/QcO+6A==@kvack.org
X-Gm-Message-State: AOJu0Yyp1GhRvjGZtZOGpWja02ENy2cgup/jNQDXvkEqKt2VwneTVkG3
	4DUdD7l4HhS5ok1onSQfuj7xlrPAmEMPFm8e2yu6BNNBdKfoscEcxi1a
X-Gm-Gg: ASbGncuGLlF7JX/mo2ZZs0axw2NKTsOS26eCm0ATR4XUP9Nhb7IMvzVJaFLIEb+Jlkg
	Vkq+HwQVPsfMF55cvJPAWpJVU1MgiO8kf2rXKztYaBWuHU6wNnpF0HP6Q2N18G0g2vFglGdVfHt
	LuPOn7nuB9JcXLWULfRNKMyU7e9TCQmivorv2wrzzvJSPEhiYdPXoUMCSGp4rOCOuZf7nDKltAp
	rl7lkSIN68YRnPqUcsjiap2G/yuZOpKh6Jz2dt3frXd/69UQYxlvLiCSCJDafkHkDNjNd/dJtcX
	/J6NI29nPVDn11ur9KTomOTvxLSEcEVRzwofI/wd1hj1UXt3kczmW4hUtAICkl23z9Nx6D3JJNR
	m5RVBCdovrqP64I0XDdixqpLVw7g/Hx9/qRWQB0ObbScNKcHHI18WewPJ6LFO+ww1txOuJy/5If
	ERalDQ5GFObQ==
X-Google-Smtp-Source: AGHT+IGdJkcjv/6fbp7vc+WoEUKD+u65Eh45Sh1WQmS4malszYEdr3Qxc03Yjx8qYmvhmGqMN1irXg==
X-Received: by 2002:a17:907:96a2:b0:b72:dcda:fe5a with SMTP id a640c23a62f3a-b7657132d28mr2549717266b.5.1764151410869;
        Wed, 26 Nov 2025 02:03:30 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-645363b66e5sm17127893a12.14.2025.11.26.02.03.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Nov 2025 02:03:30 -0800 (PST)
Date: Wed, 26 Nov 2025 10:03:30 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm: use standard page table accessors
Message-ID: <20251126100330.n66n3uvt3junflao@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251126064723.4053-1-richard.weiyang@gmail.com>
 <9c32675d-c48d-405f-a38f-4c90a8edac74@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c32675d-c48d-405f-a38f-4c90a8edac74@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A83BF40012
X-Stat-Signature: x3adt3cnyxi1fxy31fq3o8km8fafmxdw
X-Rspam-User: 
X-HE-Tag: 1764151412-504348
X-HE-Meta: U2FsdGVkX1+OmwpthaByuqx5TkMHbAJx38P2JgI2SOUZ6dIKEHm0lwnw/9/nP+nfYHrO+PJFXxacw2pZ/OmyKCdDg5UlXMa0jVpC4UNnQ+uvlxdLeDhaFPtLAgPYAfIZTcLRs6/BDHQYht0vjpJnCNRhjY1IXPewpHezexNUv5aO+r6FW/WIBHqI5rvEGKAf8vzJF8zwpHOEnmJQsFoYAUfiMXA7RzePZXWOqXE3zyjtxSBc3aVbpfj9bwKYhIxUd1viDwSVI88Bo/78Y4Aw5xVwX7dceKvsbxIdqJB2ZRVPVttlnOZ5K8v6pVCsaJIB/bdSvMCGtCJ5vNmzVBF8uNTyfBWkB94oMNaXWwIGDDFYk7YMj00TkUnpcOPugWlYQJoSw0VzCoyOpzqyb+Xl3v5paG0QgZAciGvXd3iZr5gqaP9Uqps2VlnqOJDbiA8EPyYbr2hmsC56sBpHFff+QDI8/dbv+8SkdMWTyAIsKBsdFTascMRaEiMNL7PMJHZhfJ0NIU91LOHBQgjxRJReNtY9c2byYSAgc59Uo1TRIUb2xMn5rSW1cK+6qYM1j4cERLAQcm7fSdbo2tWNkHY9KYGCMVOtJmjs38uKLP+zJX+J8zgVmkUa5MapWDkLFXR6MHrAmqXGZVAY9pUowwREsXQS9CtICBXYyrri9FP6yNmlCiphsZ8TDvKXToJ/PMMpAKgUCVeKtEWAqFpG/U+JahjiyWMA8NL7nUVzQfCFk/Z4ylA/FkZiGWLemA/9UD5BdBZKLPBJjXLaxX6tHTCJsXl2Y/enwa8Ek13+exo/1VKuldfdvIlcwFS/zUUUg/EauHaaUtdMd1e3onQmu3zrwsRg84SxO1+zIF6wJM5SpMQ9wLPfSSdM8SwCstAVZYByDP13pr8po6+P1OUbe1c3rjST+Rb9g23uFgFGJmjCvSCRi0BTi4FELfJM7iLLiP/aU8XnrZSE+iOyV/4iQGs
 gfzsOxMx
 RfBRQhec3QuuZyOaXqbHWQmFKob0Znf1zF22oOO3Ejga3U7EDyoDM1Ynpz+ZHgG/DqmrCl82T5GTQe9074qaNSLjSx9XYIdyPUljzmuZDb371F2nNahrIEcR9ZXDlHpWaGdpz265zuJjF1DNQ1+Kmq7RhKDMZUS/PhUste1298I53OUVX+J+Tp/RbOaSCv62eqi36j/8sdKyJGJxWl2EGkvuWXNTayKx15gKSesfU2EoFnEgY+0F9agyqNgJNYDIudwBiJfdrhIOO8gMeySufCe2dDGJZuA1jGjop2p3sosuv4L1xlrwhSrD+eEXRD5rpFHlzkYJHOd/Rk19r+LS5uBgYiLQEEXQ3GkpGW+2G4jeTSBdTkrIoTrCLXfLbpr1CuJuiEnbbp8/vB/ApH1Pa7m4tX5sfpJZB3C1jDCYukLo4KS2OebQ0ReSvFQ+P2ufq8Pe+7Vp7ErJayV6v1P8CkmGkKabDH5Wh96IcVrEjCOfGJS+1ZrK4wnCC0qpOtnbRSDOB8/nD0sBCS1wgc9SQMZxG/hzc5SkA8KnfNGyC0MUOb+sGnC4WInnk6dF428Glyu8+fFiXTKWUX0ZC/tDZwcrwnce+lbzOoHPfJ2ACAnJ6TaWtz1XkGQE7VjqobcvG28Y0C/nrbCQHv/1bJr78TmL953osNOOBfZAB5Li4I7Vq+8qnWse2Wp471o1Hzq0WoIqXkqXqn7B309rlbWg7PmyRWFabWVZpoz6a6kbv7KdfaKdI4ym/y5CrzHN+zT/2pWVToRFUFEnyPF3T4u4Cu3owxYmSnTOenN4/Uq/vAXvk2shS2ytnfxnfPVwCqPnr15a/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 09:15:24AM +0100, Christophe Leroy (CS GROUP) wrote:
>
>
>Le 26/11/2025 à 07:47, Wei Yang a écrit :
>> Use standard page table accessors i.e pxdp_get() to get the value of
>> pxdp.
>
>Please provide more detail of why you want to do that and how you are sure it
>doesn't break existing implementation.
>
>There was similar tentative in the past already which proved to give
>suboptimal results, see discussion here:
>
>https://lore.kernel.org/all/f40ea8bf-0862-41a7-af19-70bfbd838568@csgroup.eu/

Interesting.

The reason is P4D/PUD/PMD on PPC32 actually just has PGD/PMD. So it is not
necessary to retrieve P4D and PUD.

If this is the case, sounds other platform with less pagetable level would be
affected too.

And this looks only affect when we walk the pagetable from pgd. If we just
iterating pmd/pte, we won't have this issue, right?

>
>Christophe

-- 
Wei Yang
Help you, Help me

