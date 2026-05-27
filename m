Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F81CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 23:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913D36B008C; Wed, 27 May 2026 19:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EBCA6B0092; Wed, 27 May 2026 19:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828876B0093; Wed, 27 May 2026 19:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6C76B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:42:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 107161A0357
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:42:42 +0000 (UTC)
X-FDA: 84814826964.26.13882DE
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com [209.85.222.196])
	by imf29.hostedemail.com (Postfix) with ESMTP id 27C0D120008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:42:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Q1k5xCTA;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf29.hostedemail.com: domain of paul@paul-moore.com designates 209.85.222.196 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779925360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahn0OAmqt3NvDffvYvLmMgx13/Qe9oNxidNwtJQvEmM=;
	b=3yRo29kW6A1Go+c1OTD3Xcyk/LSFvdIf2OBPWHPZTnuzQm3U1Yf+JvFzHGOspF3uKs0thX
	CmdH0Aq5mAcvGPqHjCkskspvFE0oFn/kFyJJewn6ZqZn6bSpMc3h8+jUzinYLWwyc9nPCA
	XAUUU7RKkFWdz0Axjw8YRdGFsdRyymE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Q1k5xCTA;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf29.hostedemail.com: domain of paul@paul-moore.com designates 209.85.222.196 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779925360; a=rsa-sha256;
	cv=none;
	b=lhjDXUKoi/UkBoMW/FvWjAcA+ejzHmYLDUmuNlac6z9M9kKbE+pbyHWXjzDqZ+CeOpnhAj
	DhS1nnuHvL7KJTLYhAtdX+XDKrIlXjllATfyZ4OJxTC/zKDyvIKLh8QM5C8aIjOf4DBVv4
	F1P5pllbQy33J3CSHPlMuPSNOTS+0XE=
Received: by mail-qk1-f196.google.com with SMTP id af79cd13be357-914bf8abeaeso457250985a.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 16:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1779925359; x=1780530159; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ahn0OAmqt3NvDffvYvLmMgx13/Qe9oNxidNwtJQvEmM=;
        b=Q1k5xCTAHA/4sggK6aJ6WtP4w4pZyUA4NnHnlyDkpp3Og3CzR68Rryf3TooXkWhZI7
         uZQAIhUdOJ5VZtrhWumzEuq/L5Gbpxjag2FRKxG9Z/BveVUp12+52/eELF/E7T5CVs4c
         aMYqMINuWt0Gdqa6XAKyP7QnoNi7JOCx5NWDWafn38WZ6T23qzNcqG7E2RW6lZ1EzPZa
         cZ8hWPHesBk78xRQtjBn+S1K3LM3oPJAudOXs5Ke1OQRZF8wwUhYOTAPRuUfQycMhRE7
         HTLjSyLt1aXZlaAItXIN7viAbJWsuTsJQl2yIN5Km440HcMJcncejTNSshLK3ktwVPRp
         7Cag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779925359; x=1780530159;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahn0OAmqt3NvDffvYvLmMgx13/Qe9oNxidNwtJQvEmM=;
        b=lH6gipuc3GJ1JttKv1xfr5GjB6buZXzjrGxoZFN9XkQhrYYWx7qFmuxvQUKWq6Ax6A
         nbldOoKIlgbanr5G4S8a3YnyOmhczEBPxr6sOBVJqGrB2o4w/rtTbYkYbEjIfdRAD5yE
         bsfKfAF1zNG49y6UxJKKgurSgl0+o5xYQ6n6TkzBXowTNjS/uy+NVtbFX52827t4R3G9
         0fhrOtO1Sar2kbvrc2s9aD4lTQPAVcZpX8EpudebEElU8QHTGmciRtJKgre1eh2PxUUH
         XsslHQgStmuofZlwiOqyPvqjvSYvzeRlyX4EgDhPy86EwQ3rh2LAS/gQurGuMRGvLa1N
         7TNQ==
X-Forwarded-Encrypted: i=1; AFNElJ/LVOyYsc6d+RKDf/KEPsLgBPCtpVDDLJWUtcXo5AW4ukLEaalRSh37KvOFNprZBh9myOHbUD725Q==@kvack.org
X-Gm-Message-State: AOJu0Ywi3GuQsE1D6B4wPAZAadvRbjPZSFK51OQTViAlyiczu0Bxu0fH
	bZL9w6iwqHjBaoJf/VwAuJWMLsYShvWyJCCxnBd5Xg7Bls+0XuhEx+HQobZEo6ZxTw==
X-Gm-Gg: Acq92OEvEobSRSQbgv/XbXIUnJXd+p+lF09VIQb82iIwc0rxa2PaOIYbc7iEnvrChci
	/XPZbBuorxfWUAyBN/x3JaSzm4R+WWUDzF1c9Wez4uDkc5WDbO2lwqgwNDnnglK81JN3PDlFv7U
	6mj+SEtMOaAMyPUgHLrYZGT4ECZyIL5xOJxHZkAsqwZeu6vUNpYVtoP6mVnsorx+s0S+QkCgQUk
	juWwCojYEXBcoj958idbpGjB3v5D7tqAdRTm1/HN9MVx/9HCAKalehoy0do8ZkwieZIv9wysKDp
	VDOZIGDBDrUXtpFTaNIJtZ2l6Q/JyChHYmSjak8+iNGnOR0yW/ObtXRaJ0bPJEFir8IuMOfCWKZ
	SL2TkHf0u1+ssSDC1AJLsLVsDdM/c0VcWgrbmLNs+Ih3CVCr1HUcbB8/T0cxuLzLtg+YH8odsbg
	lOPjNG6gwySh3IINMcKQevbGKM771xLC/BcqZealDSB8XhcegtBpEJlMxlSRt/6N+y50KO7a7Lh
	Uq8qulAD89zjpEftg==
X-Received: by 2002:a05:620a:2809:b0:914:9bed:9439 with SMTP id af79cd13be357-914b499684cmr3819952385a.44.1779925359286;
        Wed, 27 May 2026 16:42:39 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f86ff83fsm630942685a.14.2026.05.27.16.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 16:42:37 -0700 (PDT)
Date: Wed, 27 May 2026 19:42:36 -0400
Message-ID: <be755d49760dc9083ddd6d9a485c71fd@paul-moore.com>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260527_1931/pstg-lib:20260527_1608/pstg-pwork:20260527_1931
From: Paul Moore <paul@paul-moore.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, James Morris <jmorris@namei.org>, John Johansen <john.johansen@canonical.com>, Ondrej Mosnacek <omosnace@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, apparmor@lists.ubuntu.com, selinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] apparmor: replace get_zeroed_page() with kzalloc()
References: <20260520-security-v1-3-831bd8e21dd0@kernel.org>
In-Reply-To: <20260520-security-v1-3-831bd8e21dd0@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 27C0D120008
X-Stat-Signature: eyff6ezzdxpgr5zyzmwt8wzquo6mj9nh
X-Rspam-User: 
X-HE-Tag: 1779925359-551069
X-HE-Meta: U2FsdGVkX18afpZ8iCTm69bZMYm/ssgqyvaqLplRiDqycPbLNUrXXsalEPCstphjD/RYJOhnLh1rWEOcVxRJFmLf7UrlXWH0G816J4ENr1RCotr2nI1KdXZdQ1T5I2BbCF8FpPZHzE+pjaiPm+HJhxDdwF+mubHgJbzou56OZ5jAZh9k6RYfwrUfmCjew5isuDDBzIFmJ7a/n8pN5cyTuraUO/8QFhTS8jScgef9JizoTCX84TOq3pGJ3qAfgTxikMBg+OJkitHq3n3UfJ2hsTfgRftpx+skmVJuAHSE8y8kK0BbSksNye5B84uh30moEmn/mW1vXCtSygxJXFssOSlJvMxXWGoTFsNMHB+iA08LM5bO7juBGL2alrbzMskTJKOdizyzr3OYjjjc8Pzl3eH0hmM+PAnwy5Lgpd1D21++1CV/IxedBj/N8yjb4zgV2wtyLHdmC00ilCnctCrYuszOlRE6ylqNTRfj66r0YLcxoVgt2NCPMWKOCNy4XwO6J7/gvTt2NVsMfugZIZ/rYpH3WrMQSE5Nb0pa0o7SAC7RuGc3BUpciEYD7IDc1ukohAKj4XcfGKYEldrJfUaXNM+9S4Y9M33227P5hP3EaAK26tXf7rdKZ65IvYurD6VNzM58qpfsEW1jUs3e182s+RaTlxUglnNcpkV18U1ElFguzyg2b0dgcRWnnG5b5EkDHlZrNoTcv2vltD62s/jbVZNdUn5iPtN8kXaixtIF7qIuPGwRspBDUFRGODDYOZU0WZMQdq6EosUykO9AcjpwbcctlDe3gX0Bt6HW2ud71aJxhcaoMvHl+D6xemf9bvummq224FKeG9eHKzTFIqKw4j+ydgNTZlO7LsF2ht+cOJhy4+RWM7FhTVi0/hhPArFD0mz0peDJ7CoqoWoYQsXhL8SRXmvpYj2RKFtPSOxLErsJ5jy3sZUl62ZWYGCH57LEf0vDuDWLcEgecrQehmw
 jRpSPet5
 rw2KNdU3MADLYlj5yCVtyShByqoaOKRhwDZ1/GxqeRBmjxW0RtBg/L0HjPTLMMX+Q0ZA2+5EC9PgQAdW96IkrO80V6QE8SJQOSG2f+G+PaU5JErAVkxr0eCpug8cKj2f7BDbMQEGUUWpQKm4pKaWBijz9HUmxv9ImDgCnEiGIi7CC5vasqaL+PgQpa3lyRgFkIxhAa/IBNgYR3wHKp4nXXYXPqumAJBT+F7d7S7QR+jCK/gC0InX8RpIANuvqv2k9Cr2sazLRExGZ0wxCOLR9vXOCgGh272QME6mawVHNcEALPUYfKVm1jyDcez8HYlgRd/IIDogvxvbzRLAAVRVMBzuMnuuIYVFchT+Le8oC4ZtveqkNAc/HRRAQtzbCPSm+QXiWiLRnv/bO9HMTdK+zfpWkBIlAFsEUqdJ8zZjlADqClruoFRw8emYhmN5A0IYjmmRZ25dLqOUKv+3ubo0D5k5e8Un6ajx0/o/usAOJyfbUbW1nfO0cfmx9RKIEDZof9xYb9MkAy3nJ2yeQ/tkDD/By8HH36WSVHTdCZSqa3Yy2SFCvf1NsEvYbGZqmYwK/x0E1AUJllvfofJmFaQCNIO+/am+x7oRTCkeKAQKwMcr/x3JQctJsffG4UA6qn7zUo95Ikhmf1F2n66IbECYK5b8Z6gdYc7xfg5sQ2Rl1xaJ1dkw1D1HTP1jPlQF+KEVR0CZ3Kz89cG1nmw8io5pIXg1Q/CW1DU0LqrNE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On May 20, 2026 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> 
> multi_transaction_new() allocates memory with get_zeroed_page() and uses
> it as struct multi_transaction.
> 
> The usage of that structure does not require struct page access and it is
> better to allocate multi_transaction objects with kzalloc() that provides
> better scalability and more debugging possibilities.
> 
> Replace use of get_zeroed_page() with kzalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  security/apparmor/apparmorfs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

I'll leave this for John and/or Georgia to review and ultimately decide
to merge, but it looks okay to me.

Reviewed-by: Paul Moore <paul@paul-moore.com>

--
paul-moore.com

