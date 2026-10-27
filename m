Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC49606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kXA3ADmL
Received: by kanga.kvack.org (Postfix)
	id 382F66B06C7; Tue, 27 Oct 2026 07:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35AC26B06C9; Tue, 27 Oct 2026 07:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222CC6B06CA; Tue, 27 Oct 2026 07:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E13296B06C7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:43:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 319FA120A22
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:43:00 +0000 (UTC)
X-FDA: 85368219720.29.B4A7170
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id 54372160006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:42:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kXA3ADmL;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793101378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IFKYyZe98olIOt/z7FVjqJN0LXwahHsaIWrhXMheXUY=;
	b=6QxJyMIgz78paohAuMbaVqZ4CeM1kM+4Vl2gtrLGzu2lNCvi6hRXzMngoAT8AmzxqXAoSI
	6k+fTog92a5l+CsWlFx3Mv/4Y4poAZEf5nOTlvlR5nxs/ehL9w947VN1XvsoaQw9D6H2IZ
	9WZO6s6F1dWY9dQqnQGxlsfb9yhQ++E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kXA3ADmL;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.54 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793101378;
	b=ODf7rDHeN/DhpoNuT3oSVruC2FlLdb7ytjkBJ83QBy+djayGfl+QwABfMwcfdT+ls2rNGx
	6oMJ67xfqPPRqXM2lyjzoyW0g1qeuQnObKeNeLqCM3YBOTa0gjxu9K8YRm60EyL8GZZ6+S
	Q1vuUma0QhiiwKZnk8s/65oahPY8Djs=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ada4c06b7bso1901166a91.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793101377; x=1793706177; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IFKYyZe98olIOt/z7FVjqJN0LXwahHsaIWrhXMheXUY=;
        b=kXA3ADmLoM/Na3Vt2Mpq5JWycB7nRGBasAX30ekdWylIbMyS4eOOWqx73KVjlp/utp
         eoR2PfXqtEd9tLj9xH366tjoaJOmz9jXRA5yJGg5/uF6rHBy0N6VHAiUw+gkS3q0vPrB
         LzwbRoPkB2NdokXB2O33s7Llwo8y6FridhQuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101377; x=1793706177;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IFKYyZe98olIOt/z7FVjqJN0LXwahHsaIWrhXMheXUY=;
        b=v6eMKtcAWioOa3XCqB1KbFddifPuvQtRXswVKYz/VH3AKNQUYtauGk8Ra+I5T7P5Yd
         TeXdPFwDQGHtPad+GQtiBNUL198mFZ/R6MPzG8+wCgXNQdIDq8uhNP9vY5/WhJJ0NgGP
         YEbk1IQ2msjG1oqn+eiNfB/khXdtP0FXFFKX8qxq+aHulpfdHWSiF+lz9/q6ZiJzqVMg
         BmWdk1ydmjHq18tQGxeyNu5bqGGqnztaCqMiINqV2L1YqpFgbrDGthhSuLztkO+YBUE5
         rgnfGxAFds8/0qPGdWgd/aEi3AADQUSWFo4ueakPZedMNYyE7gRDLfsFEiOdFzZENEf0
         piZA==
X-Forwarded-Encrypted: i=1; AKwUvBz4/smytJh8E5UYJXd94jPKQvfRLPUtCU8VqCUP1DwEkEwf6kBGzu4VNLIsls0z7nX0qtxRAQyacw==@kvack.org
X-Gm-Message-State: AFq9FYIuYvml8ou4Z9Jhv8smOr0CCKMBMBcO4EV9FtYdOmGjgJ+TQdjO
	U5+4llzMCAiOvMvCHI3FKZunalQABwme3AgDmKKnTshfS3Xa6NOgp2v9aetGagIJQY8=
X-Gm-Gg: AYBFou39cgmHqgMz0xPG96s9bdBlmXq6xEchiyNifgJ/wxz30SLL9E9W//Trj2Yfehs
	X5JTaUbL7FmZH65jPqLYpNCqwVzeTzn0+X8qRvJavTmwFxMld6WKrO05wyoiGd0yXTRgVG0u4Al
	XS9K8jCbk/+yG5rc4jl257aFcgpwfMyJ7r/FqdMuxeFx/IYgjmo0mAOnONhB6Oek3ZIxoc1Gnpm
	ueaf4a0mjfhpta+n1yOF/B4dOMrmxgM4DadeTTJVU9TLtqdimb+mreYk1zHvsjhH5qgLn6dx5h6
	2fzHAOWqgmjIce3W376PgHcadXxIYC5slxCchD/gDOnmq1RG3FacNVP51M+icz7wyYGh3T+c1yS
	I4pogs1dPmivOO1IHwNCVZB5vKWSOcVxQd15ZY5BoB61wUTBFL0Ki1rcCYbFOKkqG3FJxAGfwo0
	PyBhK7mq5Sv1ITw4/ulENLR7qHrrRDTX5fIJPAvZM7IYIAHM0Bcj7RzNe7Wi7mgWLwbDXRjhHRt
	v5jN8uSXzVCgDwCwGU4quJHDprT/9t4J82ghrcdoY9ciCdUAOvGWCqmd6+im7g5jzmgl3mQEXfm
	k6Fl6Mf4ypWowT1HezMvD2g+MXmuEllEDD9hqp6GmdkA36a670jcr99174Up0D89WqEwb34Gxpo
	4QLcb+IWuxjKDXpM3izwyk9/oktX1sX7QlYqKheHqfiOV7q38gUTF9lf39QYAzZsSnXQFKDMW
X-Received: by 2002:a17:90a:d888:b0:3ac:80dc:f419 with SMTP id 98e67ed59e1d1-3adeae7309cmr8343178a91.25.1793101377141;
        Tue, 27 Oct 2026 04:42:57 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae404426c2sm3637757a91.7.2026.10.27.04.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 04:42:56 -0700 (PDT)
Date: Tue, 27 Oct 2026 19:42:54 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
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
Subject: [PATCH 0/3] mseal sysmap: Choose system mapping sealing at boot
Message-ID: <cover.1793094611.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: 54372160006
X-Stat-Signature: hbdronewrotpee9u97cnucx3r7d6mssd
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793101378-237122
X-HE-Meta: U2FsdGVkX1+gymTmrEXOXd6rpYR2YrFeLhw6XXh2k493mvk8+OqAyeLIB2ej0643+UUjH+CjOvnFpyUw2a7cYPidD+TcsU/X+vh96eOIWrgLSct0zT0LWM3u1/IVAClmrslwyx/hxbsDsc1lTS3Kaz2YPuN2gkorLfTJduxHaAB8+ObvGdAXjAtoBG4hKaRhO3C6TxdedDyRIM5FSTtlOAsXkjZ80L8F+decN3+CehmMWpEOrlbkH/I5zl64ah+mnwI2PwEZAu1ti9IMAb+N4gRxRGu7dN9dZkcGS/0O6YB/L+muaopP9SfWH9yk188Vgrj4zbIsvEQHKSHP3xx/FBSwqbmfX0dLfXY0df59uWe56HNyoZggahCqv+pVWX8bkShglLQ58jSJ1SUrZk8P0l+t9Y6WBOZEl7/H03QjQgEjlmKkupu77xpdZiNvzgE/SQ4wbGkmOOXj9f4Voqa5PQG2aFH/+kOFqaGpnmD6fngW0tH4VwaAv9pT5aU/sUzxI7NMUdFY9/IVQlZnOaF0iNmSSj2F5NxDCoKk6f/oxpqDY5ReBaX81zgGMPkF0wEvgurcmHWXkLcE+M9T3pj7IuLYANm+l/xXyJgenSJ0g4UL2Ei+OVgPcVcasdnF9zXBDJl3zjL+/v4ZiXZaq9aVdsYsn9N9O/QRVJvpqc7n4usP9fs+AOQDAWYfZr0lR9At4yvSSSqsfIj6J0ZNhKzfVH6SpZW1jhKaCy3/ki8VQp3QNDCQDBB6+FC9kIfJMo9k7rVAVOuekWotIcaAX2HjBAvXLjm2FTK+pX0ECeeixJlfszb/antyK0itouiIKCIzJwHujYUeBNxm2qTpW6sjKi0dyay3heAsQbHL73Nr1U/1vD90qxgulkA3Y/Ff5I8JvdjW0ewRaYDkOObbbBt3ZFT5QPAFgVm87FV2hr7isrM/xHdZE2xIQoJdZ/d22uIuTesGX4klkJQibEMET9K
 WAKqBh4y
 NOcONcdq3pu6bEjhfPBBcb1qV+VxgrSSuL/ZsCPO5GCn43kFymq2I8n7OnIQ6f/om824zrzLTjR+RkNyqDdKGB7k8nXcrVYwtrsFS0Rh9fGO5pGXvL/VbQ25HniV+Ey3xmXG3VpHGQT0hGQDd6RKc8TovmYBw6EDhc0jbMQtqbzYpMTPyPQxk56TgL7ss2/qEg/XuUraJ4r+BDC+ocfbyIyJ6BG6nY2akdHW4hoDfCk7GQcDfKd1uUGmOq8+70L0G26McsY/3FqmFQk3mQe/qljzbcYD3HwN6CV391tyVdRTZw1gLfx251+GalrKRrv5dNpfPxPoxdmIv/CbwTgm7iR6v8zwzL8qTAwKJnzYWlLssrKC2c9Hg/t0pIzmzI6qtKQPsPQNJYFNI7iuuuOmcqzGtPCLB+ORsRiMONuH6DvQSXvDoehi5fHyJBR/mjFD+mjRvA4LNqDaJ13/bs4fP9oUXkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

System mapping sealing is currently a build time choice. Hosts which
want it and hosts which need to move or unmap these mappings therefore
need separate kernels, which is not ideal. Let's allow the administrator
to choose at boot time.

Chris Down (3):
  mseal sysmap: Add mseal_system_mappings= boot parameter
  mseal sysmap: Allow with CHECKPOINT_RESTORE, default off
  selftests/mseal_system_mappings: Test vdso unmap and remap

 .../admin-guide/kernel-parameters.txt         |   7 +
 Documentation/userspace-api/mseal.rst         |   5 +-
 include/linux/mm.h                            |   3 +-
 mm/mseal.c                                    |  13 +
 security/Kconfig                              |  17 +-
 .../selftests/mseal_system_mappings/Makefile  |   2 +
 .../selftests/mseal_system_mappings/config    |   2 +
 .../mseal_system_mappings/sysmap_is_sealed.c  | 236 ++++++++++++++++--
 8 files changed, 268 insertions(+), 17 deletions(-)


base-commit: bae9a042b03b27924c6fd5bdc00a20d6a44d6041
-- 
2.54.0


