Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12332606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=modal.com header.i=@modal.com header.a=rsa-sha256 header.s=google header.b=cp8snKXq
Received: by kanga.kvack.org (Postfix)
	id 18A216B05B1; Tue, 17 Nov 2026 23:59:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114F76B05B2; Tue, 17 Nov 2026 23:59:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1E2F6B05B3; Tue, 17 Nov 2026 23:59:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C07966B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:59:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2744E80681
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:59:15 +0000 (UTC)
X-FDA: 85447035870.04.655095C
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 37386100005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:59:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=cp8snKXq;
	spf=pass (imf05.hostedemail.com: domain of samridh@modal.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=samridh@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794977953;
	b=xvYVSEnaespQucNdYNLjcFtYrZ1vAy39K5Ri5hFLJp1Fjx7RAwdGzRKjjsUcaUBk+SxQBz
	CNvgQvJkY138Hw2Zu1ggO/XVpQyJmRplSvydEfQaleGKUiEVSsVQ5EgmqbjBGe26lhSURy
	O3hW5Dn9iJ5OnlTBJEwGI0NhaS2HljE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=cp8snKXq;
	spf=pass (imf05.hostedemail.com: domain of samridh@modal.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=samridh@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794977953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L15FRrjBvmM4ofKQ3Ff812vzjU+8L3wtPEj17f9j0B4=;
	b=QP2JDA4a6oJs9Agtg4P2Eyl5e+vMc5NGeCUpRpPgBgxSEf+ts8oJXxANMZKbKXa+o8s+FQ
	OvKHG+LbbYz0X8KKui/sZXzQXrysW3hloq/JqKRAVBhs/rf7nv56sWV246rVjLB8yVeItu
	NVDftDQul8+JY8t4KZaBBtiemcwpJVA=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b10d24345dso4548337b3.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:59:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794977952; cv=none;
        d=google.com; s=arc-20260327;
        b=Ptymd+kU90pj4t2gqXCrocDQto9Npj47pg0CRdj/xeYOyBf8mRmFv2CGm9aPiDKKuL
         IbEtw7pcerCb43n6nF5KmYujcCL1sgawccRFnczX5wbm3O5lk7WkMFrgrIFxQTkyVhx5
         Ohcg5RLrWTQcLer2bCMQbnM/yiuPInHbZl2tsHnTvikFN5YsBgvk+9Xq4GmnhSvtZyUO
         kPk0UkYBgyGIJ1NgDyy8fET3sIOQ6L+wIPfzJf1O3IJqwo9riNb5jNbgr0Rsw4wQrNL4
         2fG+Xbk9itAnhQlie7UscSul/zTS4AzwO9zsaofd6eUwg/5A26WSD4qPbt/Ke175GN6h
         3pUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=L15FRrjBvmM4ofKQ3Ff812vzjU+8L3wtPEj17f9j0B4=;
        fh=cL+dmY26rejL/J5M//GtRzhE8WhgraKwqYXp4p857+U=;
        b=oyVoVWwKpmkHGHuxubOBdj9PcV1hWGMHeSswZUdP6KhnviVvZy9zeLiX5+8Aa+5GzP
         0TiDSo2fmkBsYPN/4NZ76j5UjTa3vVBzGRDL6/efR9wGHbd37M7WJFZVusP21cE7LrEj
         yWMGFtCUA2AFX59l8gtcxrpIzmY76S+k+R7t3gwerHUS6N7iOArYn7TneNM33pFxlkBb
         vbelzq08nW+72Cv6n4qWrjGyVTcpNCNKkVmhSImh9o6HGNfiKtEJPD1+y9y7RLELlDZR
         3TUYLH+eY3o0u5QcAL1FIZ7TN6sshBIxQFTd+XBKHR7l/7KmsVPBBybxQZjbYs501T1j
         4aaw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=modal.com; s=google; t=1794977952; x=1795582752; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L15FRrjBvmM4ofKQ3Ff812vzjU+8L3wtPEj17f9j0B4=;
        b=cp8snKXqBd84LcCdZjlObMJHdwsWPpRyRWLWJtJ5XWYqdUW8fBa4ttgr4o2pBxopuv
         ogqiNO/L9bfGvyMyE8QwyWBwEoAF8/s1qvyhxwhp34tG6y1/bAcSIejBj0jK1LZi6R7L
         zTlYGHRUBKw481PxB2yPs/2BFRojAoeC0wKufpLR+PHjMiHIUK2RjPO0YQhl0lxVMjHf
         Erv20CH7rg3rK+1h6eZGLxD19QG7tcDLiPVHaThUcO5juWYOozXpCgjHaewXAfZvq6+b
         /FDLJZzgh/92Tp3N1DFnXlc3QR1KxOHJsrrEGYNPxCA3qYaEXrQQuLyQHBU+IMd+PMPu
         W6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794977952; x=1795582752;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=L15FRrjBvmM4ofKQ3Ff812vzjU+8L3wtPEj17f9j0B4=;
        b=rvEPykpn4pcIXQTp/8rWzB5ak7ueqnlUdmGydTkOg1ez07kGncUvZsABUTlfMzJlBU
         YcShhQqYmvwzSAtcK+PnNDlxmmDMGOV0dXhTVfGt1GnX6bUYCEXiz0QE22rRzhle/egA
         kJ/3ou3u0FB60SyCjhX6guGIJflmoIqPop3OsqbVmPuSs5lCsGUdfvTxIr6FcEOq2TTB
         RgMZFtUUC3xYknwJLHRQ02LAb3mYF5JW/ivwnbjxgq5wZo7bgacznOrj/wiU34rRnd2h
         oiPdydtY7zSiv49MOXqW8TcWVzrBYy0Dk2Aq9Vm/q0PvXyBbZ5L14Dz7Pk++XilYq1Jf
         wUfA==
X-Forwarded-Encrypted: i=1; AL+hErHf7/uDlzNPMuqhuQyrn3RL5khHGnu6baWkN9STDrNoe5W+Egd3fX/mQsXCKD3Jlu/iQdFo25BtuQ==@kvack.org
X-Gm-Message-State: APuU4Z9ifxL1fyMFk6ADrN7pJz62rWZww6a+SXBhTp+02yvUU/Q1/VHj
	Ulo9EJ/LFm1dCGwZ6iPwL2E9DEI+mt4JTmEDY0gF26Q6huTec/HR57PwdY5oMpQlf1VLe7rEsZZ
	ewUIyABy/ygcFtPZWCY3zxQ7vEe5c++jdxDpp9wL3yn5d795294wall0owg==
X-Gm-Gg: AZFdTZcO6eeRL31WvR3Lq2I0ONpHo1t9G/vZ0o1ymO+afwPmHfgPWyqT0titP+Bzl2X
	MdVjXAwA/NsKAAhShp4FGgNW3i6u5BOqua/WakNKtS6Ft4bdJ/oqiKVnM//2QsrwRxzkqOudQBj
	YeU0SZ/MjxIKTwRP9zFjD4Xwtxi9BkLGRrYFS61F6uFmO5UwNQ9TFhh0pdzWHme5b4O67h+2pwP
	ZfIGPlAh272dn7bmyo2QkaVN5YME0RDxir9ig0fhIJCIYqF+Q1l2fGQW/ACd8OMYRsucTbFsau7
	I+DD3cTLY/AyvXS1M8vOyMZv47q3W5PxyX8U2NSrateL5GS40B2yd8sV5i0UDeh2nv4eAU3EpTO
	KCoEBV3Ict6k+FAPpklr1bt9Blq6G+xt1e3BzczeAXEBvAQeL7EAAFrJSGWtm2agNqAdQmRw=
X-Received: by 2002:a05:690c:6c91:b0:8a1:781f:4aa0 with SMTP id
 00721157ae682-8b4fedb40ccmr7127757b3.56.1794977952130; Tue, 17 Nov 2026
 20:59:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-samridh-shmem-send-v1-1-1b897ff562d9@modal.com> <8d90ee6b-ed72-4ace-b667-42e35c5baa5a@linux.alibaba.com>
In-Reply-To: <8d90ee6b-ed72-4ace-b667-42e35c5baa5a@linux.alibaba.com>
From: Fnu Samridh <samridh@modal.com>
Date: Tue, 17 Nov 2026 23:59:01 -0500
X-Gm-Features: AclHuK_HM_FofLuPSN0Y7ZflCaBv9_Ptu4MF3HkZBfGCwfv9f5hrG09K70kQ8wY
Message-ID: <CAKyepcRQntK6TPGXxaz3rpV3qJ_oQdjL4utnocwzS1xt-t7tGg@mail.gmail.com>
Subject: Re: [PATCH] mm/shmem: avoid zeroing new folios twice with init_on_alloc=1
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 37386100005
X-Stat-Signature: b7sma3z7mbijb1jysctz85d3mh5bcoc7
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794977953-672045
X-HE-Meta: U2FsdGVkX1/bNEreEAlcjKH8FWSY3KpOnrYVTNPaKZvoQ3NtMmSFVO5smaY2aVPRrzTtqN6iI/sO+oWrJkSKJ0oi3JePZ0qG1jdtnG0JH+xCdjejclsPnocBIO79WEKH399Waye92ye57X9Is0NwnwlYLBpIgwRzuZVP6cOEHYy73rh74qOIyRnhqSh/2nlKlWDMoTAIiqTpM5OxgI0N7UG7tPxBqXLQ7KF6eI3ExGhOEhzxP0cqB2f8nn1IwmbfoBidKNsE+Z1z8VN3nb/d0yTwU6uUiuALtTCO5D5Uzue54L0YlGFpODEpCnU0drxICH2/KXMwk/Mbj194/EJ5hvLXuX74fNOY1kPce1FdRfQ2Vi0GhP69tpDelFItx0wGXO8tPfenoZEauvuaAaeGKXIXhr/3MzJeA9zEa5F1XTBwOtuFYaFNNwBCwURhOjX9XzUEf1IWe2Lk5xSGCerU2sxtRFLd9XVyPFEDk9g4uhWu9MmucqoeaQ8l2v4Yy03ECzd1V5+2XKdxPgDbm16844/d2PzZhkKsWP5QpAGK5OTFLsQxBee8hWKX1zM+jjnYak3pyQrDm6Itn8n5AcjRv1vrzU0D2Q4Qal0sGJH1wofweZXQxdeUWq+Ps27bNq3ZxArvsop5oehgE6SZyZA9O5rRNIt72G1oLV2GaCxQW+/8rwysZW+i1Mcj/0DZPquLZy6iuEk9dXX4p8gMVhiFKcEF3LpRBUaZasYJxEH3TudOpzx8Bfy6ChuUKVoGRfcO8dBpn36BCeHLzgId8OcLtVWMGcpIY4C0N51XSAh//PE3+4nQsEpbDEaCba/+s3Oe3Lc859XFHQEwoZveJog+TMskF0/7mEK2p/N0iaHCS2SG4xxkXJ4+OnUB/oRa5LUe+Cial6lvIBlGv+nqV+1DVzd4XjLrbBIDlsNgkLGmZcpcWsqKpTWJ6UEjkQnqTEISsW0imMA2TXP8ssaWZaO
 wZvjuChb
 kYAFbFVk4+ehvfCDeeuwtdqlxjDXHRaX/Y5xmrbxU15iZ12KZnh6LcG2/c5NBy4HlklrLb6C/Pa+y1h8MhqocBcqsoqSLXmGSk6sUhA2+hbMnspEvR5fKapf0uVJEYG826uhfbTmiYNaGOfI8KaGFa9iGCSogjBRjuV1kAxw5mf6q7H88Vm+uadSzAcOH2Y/d2BN/E0t+ZjrUJ8SQV55ltMB7z+NJ8HtPvI6U7ibbP1SQt4f3Yrk4yp15M1dNzvfa+v3okcDBuGyMtmYYLt8g3lcKR9+nMKH9FvqTlVxV0TB5Lac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:29 PM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> I don't like the GFP flag hack. Why not use user_alloc_needs_zeroing()
> to decide whether we need to zero folios, like anonymous memory does?

I started with user_alloc_needs_zeroing(), but switched after a comment
on the list, thinking the helper wouldn't be accepted here. My mistake.
I'll go back to it in v2, which also takes care of my flush_dcache_folio()
question. Thanks!

