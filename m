Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68026CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C212D8E0026; Mon, 17 Nov 2025 12:31:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF81B8E0002; Mon, 17 Nov 2025 12:31:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35CB8E0026; Mon, 17 Nov 2025 12:31:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A14B58E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:31:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53035C0218
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:31:39 +0000 (UTC)
X-FDA: 84120791118.10.3D75B43
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 636791C001B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:31:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IuRJrH7S;
	spf=pass (imf21.hostedemail.com: domain of ujwal.kundur@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ujwal.kundur@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WV7KJq3JWbWy4X8KgHXwI0VdrSU307t+6yjEnmz/ZNg=;
	b=iDoLrG2mgTXMJ0aqrlwTXi8Qv2a99uhIaBOOAds1SOLAjpPwL0VqR9ppSuP+ZxTIjkAreA
	3CTaSWytSadO7Z8yTVG5uRQD2RdC8gL8qraQQz/5JPsiI+DIHVGc24PRQgSDsQw3C9StC9
	h7e7C+8wGzzdyVnyuttPFzkh8fFRuFQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IuRJrH7S;
	spf=pass (imf21.hostedemail.com: domain of ujwal.kundur@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ujwal.kundur@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763400697; a=rsa-sha256;
	cv=none;
	b=ySbkjgQHMEhki4iTnngiCjLQb77YfYwrDwjxxXAlgpAOPlRZtx5r18FGrEJ5R271qTnb/M
	g4oOinCEc4XskP0ajyuMdLiUN4+BztFNcM8Mf7bjGFmNGbIAtgYq3CSG9VSZCXHhy/X3af
	kYwoPYrf2FKpLgjZ1NQ8UESWUf7DT7I=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-644fcafdce9so234976a12.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763400696; x=1764005496; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WV7KJq3JWbWy4X8KgHXwI0VdrSU307t+6yjEnmz/ZNg=;
        b=IuRJrH7S4lT7vW19n/lGrMs3D81u+PpL79DmTuN3+8nm2hy61L0sTd4cQYtqwtr14g
         Gvq0MjgDUuYMzZpR0hkFM228xTzGZ96DQYIt96WgclroAvFdOprTV6GNkS4CrT5kjGDK
         decNDpgvZa1T8H4talufu+sahSEXLGdq90yiTugbMl91sk203Qw8eOPA2Ci7OIr5m1R6
         RF4GpGbklLXTrlhweP7eUzNJtpdRZpQ+9FRbHzxAd9THIUdUs4YkntpMCF3Kq5U3vA9+
         F9w3HvYRU2yCLCpQsAFCdUly68tGcO3IUbiC2FrmlFzeSsWPz3cqzaz2382HROTmpVzo
         Lu+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763400696; x=1764005496;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WV7KJq3JWbWy4X8KgHXwI0VdrSU307t+6yjEnmz/ZNg=;
        b=uvGJKOXeAHcq4RrlcWx5/ydSW8/LMfMtaVna8ta5qD/EI/wRpAwGR2iym3ny9VKuC7
         ex45trlKGRfRsmsaO7YULJ4lN1fu9tZTW8HuDVUdWZ8sSFvMQGoGVrWSZqyXdlFOiEoZ
         +hb0XCOBdpOVFdIy0x7z7b2MaXC7Xw55gQ6dxj/8qjtePvv3qnK9XHUsAmcSOk7qA1nP
         QlUEjh/EdFefemq3QqE9nM4IdbGbuURZP6ax+1raMX/3hVpjrZI2St+PloJP3dHOK9Zm
         pQsB0hJHaWKjCdA6PXw4AiIkoST0hfBmyNi8+rg1al1MAusmllsBAzX2/qd/epy260oF
         3l4w==
X-Forwarded-Encrypted: i=1; AJvYcCU/Yljr1c0t6NOGmVVJNGsVjQ7qJec9MBiuyo5CfzYPpokQmAoe+bVQg9QLynaNiFavbDpXffQYKQ==@kvack.org
X-Gm-Message-State: AOJu0YyGtND7DHwsHVk5mq9vRXPgYzlQKvUw9lp4kk9e8QFM51lkw0Zx
	fV7RngKQMaR345/UJ83BPkQBfUncQnELdLYnJC/+QxWlBPjMY/5eezVNw4tbODiDnVJe4k2aG0X
	5mb3o8MUC1Ca8BqimgzHnzdD6wQ6IBg==
X-Gm-Gg: ASbGncvZHUrtxtIYxdU/z9CgI2XkrJxC8gFHTGXiHiLqr5luXvmKp/nr6pg9L/gw7/J
	9t0o1XwQrR+6/gixNyAEFuK5xFVyjkaItDhakq76ggu1JgUoKsjKtiIHUgZ6ZumC0kPAodVlswo
	czolZD3TxYSsyocmFfTBvN/YCzHwjOxS/nvh3PaR/Jpm9rPbtCzKAvmHKJf6mfyOB2j8TuVfmCA
	nj53902o7i+rsDmXCSI82o6L8h4iJAuekzkzj4HABi0g8xklVGYLtDsWZE=
X-Google-Smtp-Source: AGHT+IFVNP2uP6Q0JshZHVUTd8X1+5WDmG7OavAZHYwuqKhkIu2hA2v7ot1RIcdD+T6gGeIwMDW97WO+/8hkBclFsrk=
X-Received: by 2002:a05:6402:5112:b0:640:a356:e797 with SMTP id
 4fb4d7f45d1cf-64350e2092amr11284922a12.13.1763400695483; Mon, 17 Nov 2025
 09:31:35 -0800 (PST)
MIME-Version: 1.0
References: <20251113034623.3127012-1-cmllamas@google.com> <e0be6864-4260-4843-a432-d47437b5d43f@kernel.org>
 <4a60a703-d9c2-46a8-83b4-a7ecff7f6ba2@lucifer.local> <aRXyxWeh81-aTHaC@google.com>
 <b4291d0d-b913-4e61-9f9d-fbebd1eb4720@lucifer.local> <20251113153205.6507ecb308e7d09362905da7@linux-foundation.org>
 <9d30836b-9ddb-4432-aa39-85e32c2ea645@kernel.org> <20251114143909.14ecee31b88f179bc2858e30@linux-foundation.org>
In-Reply-To: <20251114143909.14ecee31b88f179bc2858e30@linux-foundation.org>
From: Ujwal Kundur <ujwal.kundur@gmail.com>
Date: Mon, 17 Nov 2025 23:01:22 +0530
X-Gm-Features: AWmQ_blYT_0n6-EoSgb5vkK1TfvHayH6Eh8aX8bnaH1niORp_lD21yGSPt8taXc
Message-ID: <CALkFLLJP7J7fUsUuo2TYseeDd+4JeC8pqJN9PwfhKFS3jd-TFQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: fix division-by-zero in uffd-unit-tests
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Carlos Llamas <cmllamas@google.com>, Peter Xu <peterx@redhat.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Brendan Jackman <jackmanb@google.com>, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	"open list:MEMORY MANAGEMENT - USERFAULTFD" <linux-mm@kvack.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 636791C001B
X-Stat-Signature: szg71k1t8xydk1zbrx79t7uk17nnn5m7
X-Rspam-User: 
X-HE-Tag: 1763400697-989136
X-HE-Meta: U2FsdGVkX18+a0D3x7e53mzZOPOEHQ8yJ8UVwJqV3knDnr0ODTJxhtu3OtZKBXuyousclAy2ghyyYvHbYG4M0PFVXfp6+HPHGReNJXN9+Jebn8ae00nY3XCSD+IejDG3++SfqfHjF/M1jT9fL0tyWNEaS6kqgzXNGE2rcqcMF7exJ6nXg7dPXSQjIrxVoMz+I8Ui+JoRxOliCiMS24ijdIUifb2kGJYjoHEaxt1MoMI1DpEAW7cRQk2FuF8Feq7eGGBRi6UcZe+YQnp6rEBAtVFWOc46VgHtDFsxLBRc2EUmYeZIsfDudswJ5mH69uhZgsmQB0UvPc9YmUV5/Pbm0eygd9NE3mQf6l16mO/P0BnqS9vvvHDnjQE5fCSIdyyGfH+3ERMaCwW06y8YAwjAcHlkvv0zG1R1ZagqTISipqJKYCbiBQhqDAsH9+VydLEr2A5E2b049Z2aVVzCRBqe/4wWm/bSDJZjjOVTHvlS0reAZJIjn2duxcoI4bO/XpMsZt583nPos+Ygi9EYiD+cncS1Fe4sNEgDWUnBp9ARBSNNr474Ei+WTi7Q5UDrTq98hBFpXOzPiaeKRsB28C2y9QzpHW6rpICCGy3pWXTLjxuOfcaHdlvOz736TgeU3hZY3eq7RvayF50JDDhqrEzX1l8NyxuOHyAS6R/UFpauuQDN3to0uAby7IJIfNOAaRR2T2tA37hbfqjxJtWCSegx7/VQtdN1yVjU8ccmaGaV/xYibE0Qv7R9Z8RI0EL61aOaursRZY1Cz8OXdR5EvEb7jUWku3aTOeAeUMffSyoVaUUKcnaToV9pVVxtfozfzWxMBo1EvjI1SkwmztQvKvW5oVCpCGQG01EEMD0gCmr3Y8ZBvU1Ha928iWYNGT6QLdjWtWStkSdbmlVQj3/J1Hwrg9SsBMsFHezlfvIONfukq0PYTkns56eT2DU61CgxX5heDNwYhLPgOUWv4famTFX
 1pSamvzx
 GWnxCV9D1u48vZ1cPtDaoKA7utp/vZAu0R5PoXfk6HP/mYPw3C8gR6sEPsmYVzPNVqhV9pqd/UGCjvd1JQNe2Q1vJx0jXFOLYXCBD1LQD+BBReY1kOEoRpO48R1L8T14QniTd94RUTF2//TglOCUQSoV5/Xj2E0qPTEPkFkDibsegFC7+2c7f7dQRJSBL/3SVg7MLfnJOgNb0kFyYP8WzZscNfoe2Oc+61IByO9DqcfM2EBRcEt9ef4MC+CqILNoavxHHRlKR9A6xER98UBczZwjdINuZg/+xftxiWfzvBLRJgqgRnZ0j6PMa0tXv8kfcSMWm9Yk9Uibx8LLNIdG1fwuj7VHYpjDF5/dKm1RhuCwUjkP5KQXElW+9W9whT+h7k3L7mPx0Ua4U7RNdy7Wr/IRgutlvJ8Se620KMSd1zsXTYgUy9+JhnauPKIBWXis9/V7hxy3r4C8LsohJIJI0L0sOo0AXfBruRNJCbwqfkz5sLQie7ny/gUL61sihSmmcgGsE7ObzyGUJWkjt7LkfOl/0+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Commit 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global
> vars into struct") moved some of the operations previously implemented
> in uffd_setup_environment() earlier in the main test loop.

> The calculation of nr_pages, which involves a division by page_size, now
> occurs before checking that default_huge_page_size() returns a non-zero
> This leads to a division-by-zero error on systems with !CONFIG_HUGETLB.

> Fix this by relocating the non-zero page_size check before the nr_pages
> calculation, as it was originally implemented.

Thanks for the fix! I never tested with CONFIG_HUGETLB turned off. We
now need tests for tests :)

Reviewed-by: Ujwal Kundur <ujwal.kundur@gmail.com>

