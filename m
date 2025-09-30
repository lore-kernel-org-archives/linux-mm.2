Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6351FCAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 03:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 927BD8E0006; Mon, 29 Sep 2025 23:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8AD8E0002; Mon, 29 Sep 2025 23:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778B78E0006; Mon, 29 Sep 2025 23:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6203C8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:32:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F9BD599D3
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:32:09 +0000 (UTC)
X-FDA: 83944493178.24.C58777F
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C4C21A0007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:32:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GFLdhnee;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759203127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ipg2xSQ+y9eG+cY+ycWtarKVzuOf0KH86wwLmftXUAk=;
	b=VYZg8VryKrGB7baYc9e114iFLRjwcX4pVQa7k2OIPTLUFAWWkaseI8WCgOAfAYZa6IeJNL
	FW/47zRSK2L4HM6eLEE2/tYnm6kjRALQWHMGk5plTnEgpHPGOfw9J2kn8rOoBZkOLmjHKj
	FRgxw6afkmsXwnebPPsF5XEqhDnKwkQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GFLdhnee;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759203127; a=rsa-sha256;
	cv=none;
	b=xtTAxvivoE8qDlXco+2+cVDRZUu5Jk+BrZSH0CeeSX7n59DZj+j5EU2ewS/9CEDTv/flR1
	L6CA8BEKNEJr9mC4RPy0eMz6GaLq6iwJnefycQ8Jqz3hA1H07zlWnq8F2urIcbLz6DAnLZ
	JL+tpU61D6uELO6EXI3oPp5YFHi2k+E=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-781010ff051so3733665b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759203126; x=1759807926; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ipg2xSQ+y9eG+cY+ycWtarKVzuOf0KH86wwLmftXUAk=;
        b=GFLdhneeNh0cgtI6gf5EMtmpCnBSCto3WkA1/ed0rogWwkhLCodywQZMobSbUiMKw/
         jW9sktV7LxUNUsp01SCny6pnDfsm1hvCCM9Yn6r86/Td5361lRKZVItoVv4FURzZNqBR
         SIR5gC+wkmRlLiCqhqGXeTnNksJgfto4nsedOJHRi5KCq+/yuCFrt5/slhNiybwRTe3o
         KtgsAgxtqE/E2qnqtnouMwq/HRTBj8ZoXSiZ3GhsFlpvXO0Co+2JfJjO4Rr1p/XHxZYX
         G1YnuOJRaENOkQ12JPNnnnTAs2uDzDQEb+FsTAgIaqYrsH1NfwUPzJJASO5DxlGjMCrB
         s0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759203126; x=1759807926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ipg2xSQ+y9eG+cY+ycWtarKVzuOf0KH86wwLmftXUAk=;
        b=h76u5P0xXdHQNYB2ebCjtMjkgCqwiegM9JYY9TAFa9ULw5ozcpoivmqWVB416vntdx
         MpBK+pVuXRjPUXHITPl9jMZ+10oThAPBujl2waSWKMPR5wxJel4Yxy3O7bjSd64zHG55
         tv2h3eZGaij3lhDm3dhuZcVPy3GzhfY1fT44jIoyBaZdv/4qx7WcBtQJhYumrZrWV+OS
         tlZOLWPoaG2+K7eG61HBEHOyB75JhMgx2vYJTpwEJ5kQhsnF3B+02gCMgKmFAGag789r
         o3hclWD9guU0A7X6Y5jNVr3HeG7Td2icRpeK6hP/snWtFPePvX1FVv/NRJBVkbyuKnKN
         gdQg==
X-Forwarded-Encrypted: i=1; AJvYcCWNAk88mz0+htb7lUukLPQnQ/0P3jo5+SoFtvWV8RqjgEjftgr5VGDxEeG8JOZzsfE1rZhsbxr00g==@kvack.org
X-Gm-Message-State: AOJu0YzU39Ab5aAM+08s+dyfHEz8jj/kzY0IEBkcTOxUFvyrWXb+3GJE
	Xtfr1MEDoKXLZvFCRJTiGCrsUTdoEL/kLw721a6XXc6mzE/7WGqspcRg
X-Gm-Gg: ASbGncsnPQx8fUvHcOcy89PnodFOFChf5xkgmbmdYPlF3TeFkmUSt1cZ+6NCRgowG6L
	QYhP/eipN9Gjk6WCosK9yS5yIyyu+9QdBnD6nt9m3vv3EzCTnjgI0cJUPoriTuSw32P/vpfPMyP
	5LSP04mQJtXqi2JZ9GhH9AvoHa0wXcRLQEkI6iwVf2qsJJnubKRxSjBIcSKME1CYnC99MM+az3k
	FlXjdFFyinc6nVwTo76MVkIVMCGRP1x2W1p7KWy3/lDW0DxYcP6buUBSG2AvP2OH591BmKb54Ug
	Pugi5pTop6QkIqOGllVDOcPXugEMBB7VAhrs3C5ZVEnwFoI6YjJOmAbgGLAqEky6oVuKAX1eV3I
	yGVB0ERZA/RmDFeVj6Q7ngMmAaEP5T8ml6ajIgEQBzWpLLEcEXB8Lu7CbtKvUM+5iDathY+ZpED
	YtMJ4=
X-Google-Smtp-Source: AGHT+IH6LhWbk9ue158EeoJf03eqT7m8bYm+d7vM0ErLdQPaLK8hlGYtsJv7ZK2fU0mzhBBLUHqIUg==
X-Received: by 2002:a05:6a00:b53:b0:77d:6a00:1cd1 with SMTP id d2e1a72fcca58-780fce27f29mr20086588b3a.12.1759203125932;
        Mon, 29 Sep 2025 20:32:05 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:7cd:1d59:4483:ece3:c019:40f4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102b23634sm12557741b3a.66.2025.09.29.20.32.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 20:32:05 -0700 (PDT)
From: lianux <lianux.mm@gmail.com>
X-Google-Original-From: lianux <lianux@lianux.local>
To: sj@kernel.org
Cc: david.hunter.linux@gmail.com,
	hannes@cmpxchg.org,
	justinstitt@google.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	morbo@google.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	nphamcs@gmail.com,
	shuah@kernel.org,
	sidharthseela@gmail.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH v1] selftests: cachestat: Fix warning on declaration under label
Date: Tue, 30 Sep 2025 11:31:11 +0800
Message-ID: <20250930033111.63465-1-lianux@lianux.local>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250929172724.75108-1-sj@kernel.org>
References: <20250929172724.75108-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1C4C21A0007
X-Rspamd-Server: rspam05
X-Stat-Signature: 1akgqqh7zxydj3ez68fpanirtuejix4b
X-Rspam-User: 
X-HE-Tag: 1759203126-416400
X-HE-Meta: U2FsdGVkX18hFbfPT8fvnqs6+Khta+Pdum827KsM0Qq2nvyg7bQkEtEqcX8yv0mvtJLuUxmPI/seZ1FSjFAeHM/CDny+lPa/VigF9lsLkeX+CTwo1vuQ6NTcQdzGZL9zmuL8G+XWLUQHGQV6/IFmfcPjPS1sO3/XjyEDIjqiALGnNZLQ7fGm0oZmWQ9HmPiH0EW3CaRSkUOGtS1lknxf0FjrGNat+lCiBj9ak9mbO5zqHSs0mN7AoA/TsS7zEscY+dOmC939oSX9qquzd2Mt+3hSzkSokVB7yKO9cwIwJNBvr7aSr7nImFPer88ilaFrRHlx+IpEwVDi6jM7w/9nfupzQdqBWDbuv1jFJDbcj290LYYkLHJZQgqPsAysfez2GRNOMVljOWuBb55gkQ9AA1c5mXsF81gdiA4zpf28bF1tTjU4Q5Mcs0TVpOOpk3PN5AcqwtofZncUQvNwDCShDelr1FjTR4S09UvtKQDWc33yZZDzpui48oovFs/kox6lLueWgNqzgiINJ6ga8xR42g7QzHVdP78CIk5BbciTpbmgCY7+r9R2wHS2MT3132srI5cbn1mk6lU/FipEGQBnAizNgC6dfFLhUNPtjhTZRsTHKjhqLKoVDk4ZGncjb2qVyo3XCv+HDoaEQH6K1nzEcsN4LXe93UaG1HVirjE4Pc0QTjI595hLyg+DF5YQv79+ytoamdYH873Q4OR8ktPcBxLgVhHItv55PzVdUywgv9EvpclWzAYvzrxYvgWyf0mqmY873YNV5m7u0CUJA06njf98lOFeawbNHnHAa6yR1nsJuSL1HJkqC6FMxTdXwhmMCN7k0d6DEHQ3vgDUgnFGB2MzRrJyQKFb9cimfxOL97zjV3SjAzyiTy+yY7rJNvY6mDML/i82HF6ik6ahtztvHVPLLlChjg7as7kCJWsvdeAV24GdOABtf/SOCqAv58D+mmgid3y7nFURrQxTtY0
 1hm3O0jJ
 RRzUsLU3n/N296bRqpLJsSsP3Qtrj6lAnAxOn0ywLGka1jgqWMb+yfvMqdPgmrkQC+S3Ph+mBBHM7e9N0hDY8osf/8ga7nVgOj4/dw6KJBd9DX4gJ0QRZZrPzVJSgk+t1i1MUqgD84i+2KT4PG+yOAmW1uTBETrlQKbIgeCBO97Nn5in+waSh+zTEpHH+mXcPr2hwB0FjyVc4u5Q2bbdGqWUWr5vPvKnDEMO0TJxOrVAmuzV7sa2tQicuDEiy8pKfqFuZYT6YyEC6euBbq8EBUf7/DUbGzqQ0eRtiqh5I/Ed2YCeopEUrzhTmSGTgiwAb9Fc3OVuoVo4c8x9LF1DnwNzC+u+f0PmCV/nxK6iSlXV06CRwV/hYL3Mp+ITKprMGZWQY6dLsFG0bBBj4L4oN8yjqwz0p2q7uj9tPRV3hMEw6HODWBFhSUiSTNSr9qFd2kr5zl4HolP08h6k//fuFPYOyJY/42YZ7ZgPyy9hpqJSWkaM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: wang lian <lianux.mm@gmail.com>

Reviewed-by: wang lian <lianux.mm@gmail.com>

> Fix warning caused from declaration under a case label. The proper way
> is to declare variable at the beginning of the function. The warning
> came from running clang using LLVM=1; and is as follows:
> --
> -test_cachestat.c:260:3: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
>   260 |                 char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
>       |
> 
> Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>

Best regards,
wang lian

