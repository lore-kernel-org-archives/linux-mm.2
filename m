Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3C1606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 08:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ceVAMCxC
Received: by kanga.kvack.org (Postfix)
	id 33D5B6B05B1; Sun, 22 Nov 2026 03:20:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315C66B05B2; Sun, 22 Nov 2026 03:20:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254166B05B3; Sun, 22 Nov 2026 03:20:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0F576B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:20:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07821803AE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:20:29 +0000 (UTC)
X-FDA: 85462058178.04.26C83E9
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5975C100006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:20:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ceVAMCxC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3x6UCawsKCHwpfqjxmxnslmlttlqj.htrqnsz2-rrp0fhp.twl@flex--kaleshsingh.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3x6UCawsKCHwpfqjxmxnslmlttlqj.htrqnsz2-rrp0fhp.twl@flex--kaleshsingh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795335627;
	b=GyLhR4RFsXAeUEnA/txJiAoUaTCsJTJk7bdnUKIUg1HgylWWWrPYTd5ZBl2Iyfeal8QPlJ
	Mu4LO+6gXWhSgZCiEipq4DB5ACsSujiLpjb/jghsF8CcBoNeHpMiOuVZlNQ4HgrBY9T8Nb
	OIIigs+k3/Rw7lYFP8XOEA9gCHIZv0U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795335627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9REF9NRXOVx9SK9lOEFtyseicoUgX0zz5kc9LuhiAJc=;
	b=InBYrKXTQaBQVAUFbufsXey0IJ6gDcmq/Mf7haOEC2O6GfD2CpEWsze7M8Gs7alNVjjdj+
	tKqLT+hO1H/NfgDc7tWOLWoaAz8YAOZjlWZXeNyBIqEh7VhhJMBk6bBA3pDZ/a+hotFPqm
	JTNt5nwL/0c2Usyrzu5SKy47FuNGLpQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ceVAMCxC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3x6UCawsKCHwpfqjxmxnslmlttlqj.htrqnsz2-rrp0fhp.twl@flex--kaleshsingh.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3x6UCawsKCHwpfqjxmxnslmlttlqj.htrqnsz2-rrp0fhp.twl@flex--kaleshsingh.bounces.google.com
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1b29df78132so2208019c88.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795335624; x=1795940424; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9REF9NRXOVx9SK9lOEFtyseicoUgX0zz5kc9LuhiAJc=;
        b=ceVAMCxC5a47iVSjW3XbNwsfDMHeemSfh5aOyICRnDOrYKOdy+GoRQnfkJH4+x8EQO
         37oYMyy4wRWJgLjFwbhnCNc9qbZdzDIHhtCrHwVNcfSnN1k6fLFexAeCAt/bMzPEGJnj
         rx8/0G+sJaYfO5n+GeQ/ILtWtkdti6SIdzg/gqCxokaAhpwc33L5bHuJoWr4dGEdvTo9
         ji42W04LXvaEvbXE145iQ9lUh/E1cCa3rGD1YUFwajspKmug24tHqKKIFXzJvwZeHqOl
         a0bqJPy3/22xwzH27qRytX1L9WU7TCzAgpCtKP5Nrz6ppHMNcwYqmRzHqtJaGoIQN4GJ
         Qcmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795335624; x=1795940424;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9REF9NRXOVx9SK9lOEFtyseicoUgX0zz5kc9LuhiAJc=;
        b=hWGLpEWQRxXmiDsQ0smmN655F7NdOXkFpbrAu7/+fSJ7hbPDdJ9ER11DcNoDpfPL5e
         j74c6WogaeThbUOvw4wn4A9PlR0pwAIJuXFKyf5gioQSm5kvZBGyBhtVHEMJsiMaRhii
         ex8U+vKvVQGhOUk5dWvY8l56Jv7euERtIkN8485LMHqF9sCO3WvkjaM+b6yiP//mj/7t
         LkfB2bC/y50tglr3kuJ6Vi3mHSa78XoIb01j6grKNUVtQUvKb/BzMJuhRA3JEfGS886q
         zC0KcLqAZAA+0Q46iFLI319BQWwQf076lqA9VyT5IscYHol6W+5s/lLa9S/cWAE9eR6x
         Dvxw==
X-Forwarded-Encrypted: i=1; AL+hErFrFDfMxc3nRAyvka7XFwA+zBzWCz4ldhtrOLlfXp5pNh5DdBcLpj7tAv/x+6tuh5Vu/gm3Px9mFw==@kvack.org
X-Gm-Message-State: APuU4Z8AUa/L53a3T8564K1+Dgh9/L1sevj1B1yOmR6HN+TnWkjWUQdl
	XSAYgbGQlwQKwV0eT5VS0QD9YmxyBE9L9JvJOa7Nn/yWKDcODM1F5hzCnW+SCo3/9s2VIEeO2zn
	+XUlOgGetcRmX77mR7UvaUMJSnA==
X-Received: from dleb8-n1.prod.google.com ([2002:a05:701b:4248:10b0:1b5:5697:15b6])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:7e8c:b0:14d:c53a:f6a0 with SMTP id a92af1059eb24-1b55689eb35mr9056801c88.13.1795335623311;
 Sun, 22 Nov 2026 00:20:23 -0800 (PST)
Date: Sun, 22 Nov 2026 08:20:16 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261122082020.1255434-1-kaleshsingh@google.com>
Subject: [PATCH 0/2] selftests/mm: fix userfaultfd tests with CONFIG_PTE_MARKER_UFFD_WP=n
From: kaleshsingh@google.com
To: akpm@linux-foundation.org
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: o5zts6858i5ohs1j7rqkaxpsir48hsm6
X-Rspam-User:
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5975C100006
X-HE-Tag: 1795335627-397196
X-HE-Meta: U2FsdGVkX19OMgpkodY2CkualDYgZXQwu0xhkgHUaR0hAkkEPuY00HAO6ER6pzKR2V7Q8QQVLnjryNTQW7DDocm2Yf64o6nTfggxZ+ODy9u731hIhR2kIqvl0fBndDTUbw0xmp8/HkcPWiZmK0WkWLZw+Fx7dwPQWaxlpBPnyNWQgckKqFpVyxJzyGRO51BEJYMEHQT43gG7IUUOUjT3/RxKRecvYOqMHFh6xF0jZL8Ot1x9JwbXj2LfwfDM3thtNoE+2ZZpR28y9da3M5YhuiZxOW1gGSFGCzng/dc/1Kh093Gqo9OJlusTpXIsBq5MpwZoGNTqC5k0vz2acXhIRQlbmrfj5Dkx+jfogqSGnT2FPZbukFkRd6ahBNWikgkO5WDrMCtpYkma6/4Ii1Bk9+fx7pL9wvCFVgpUJjV8WLf+A6nHdHFQAr+oG/j9+kM1qpkfUqk2giX/+B9h+1D+hSZu9ZwazPJBfRA13DAtRLGxfWStCUVeShbzE93XZM9vkFwPFVZkccdHjrWAnvV9RjA3/uKXLMRrmFLE/XLwBM66sBg5jKmLFWW71DJHWOsLv1LZ8IP4t/kQr0psvhBT9dyESCNuzS6G876HAg4wJRXqs+nfTnYOlkdgi7NbsSBrAcP7TV7ulLZDdT/WttmXn9RzGCrJSodFoqqIxCorHlmr2vG8dTbLdQ3pbKCt0spo8OFwSCvKQwMW2SZirmBlHJGFGLGahOTcvTDjhCAdt/ncvvaDD5Qxa1yMvxI9TYyI3NcOsOPuW7MQUzHCjirrPYO0yHT+fuWksiNLdZG9b0QDpZZXqzxPfj9eXf7aMIAp0n1d+uppvltd3nFKv2cP0Z6qTAQs1q+1duBtoeSuraubOpgFIMJzw9b59J7xRyWocyFsksi1refQkDtvag3IX5G4482e3kY7iZOt03Xf79hs+bLzuOINL7S+zRnXNwgETM6+vjvgFQOsRkCJa1+
 t/n8wrc1
 4H6vQ12YPrnG6WeJyP7lwQvNbg+rITkR7V/JLk8uayVBZLXO9W9VN8Tt9dT6RMDWe7YDXMIDfY2/B2TUQ8KuhpzEXaFUQEVsBt4xIdtD8WVOElT969EvIvay8tRVxsADaGYwm4mnxW/6vzJYYvrO3lWJTnRI5RgXq7dD/uNv9/rN48UZeAN0F610ktuZVr6vlG49WRMEMfOzjxlf/hTE1KbSm7WiRl58TJv96h8TiHdcxmL11K1A+hBtSnt738CR6/fbFc3q0c8GIlWCRafocY/YuXuLmZmX3FgInTRkIw6ojDUC2Z4/YGUTzseLE9S4Sw3GG1un7nSP1MmUlTXPVuNOwOUltXwFLS2IebeFdYX6B39XpkYWPO58Bj4tN9W8YHPvg8Febz+MbgKQVx/OYrrJ1bZWk8yfSboDAyb0McVojWzjd8TAeelzebRikBup1JjHN+U6oQAy60tV7bCHhs0It6tsbzi7zsYnQdCmX99pAjDt3FBll5lNkmuTVGncxRVVfzEaZsbS0vnAIK0MyaEzMjdWhaE5qyAWRc9sOF860sxCWzJ7vFdkFLrKDAGJ33VhAIqbH5s8aSUKIQL++nvBFxVE8HA0YZc+IHWJ6IiG4Cq93vurAbNUSdJALxRoZQ332Jpmwa9Kr8/DHeTR9DFpd+NhFeGNmALqp8i20Q4e0BG6vPrPd5nO/S5bCOCY4sTCwSF6F2ZVDLDVvgcvEX2+NdvoM1ILGIdFLJWI2GMrzaNgJ58Pi687xlbzA7lecSx1MfhfFOhNSeIBIPHMOunUMuBey2r4VaneXLgxUE0/GerfJpVwOfK5f7+9iqSDm77kPU/Osg4o183wKX3LQG3af1aiP1Rn3plTS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kalesh Singh <kaleshsingh@google.com>

With CONFIG_PTE_MARKER_UFFD_WP=n, userfaultfd write protection only
works on anonymous memory. uffd-wp-mremap then fails its shmem and
hugetlb cases, and uffd-unit-tests skips anonymous runs that would
pass. Patch 1 skips the unsupported uffd-wp-mremap cases and patch 2
filters uffd-unit-tests' required features per memory type.

Tested on arm64 device: with CONFIG_PTE_MARKER_UFFD_WP=n,
uffd-wp-mremap goes from 26 failures to none and uffd-unit-tests
passes 78 tests instead of 70; with =y, the results are unchanged.

Kalesh Singh (2):
  selftests/mm: uffd-wp-mremap: skip unsupported shmem and hugetlb cases
  selftests/mm: uffd-unit-tests: filter required features per memory
    type

 tools/testing/selftests/mm/uffd-unit-tests.c | 42 +++++++++++++++++---
 tools/testing/selftests/mm/uffd-wp-mremap.c  | 13 ++++--
 2 files changed, 46 insertions(+), 9 deletions(-)


base-commit: 4843f6873f7c4835e62f2c73ba0fd538e57a2f22
-- 
2.56.1.750.gf70dc682cf-goog


