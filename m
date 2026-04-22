Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D70D8FA1FE3
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 19:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1276E6B0088; Wed, 22 Apr 2026 15:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0F96B008A; Wed, 22 Apr 2026 15:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBAB26B008C; Wed, 22 Apr 2026 15:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D673A6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:02:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3ECD4A0190
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:02:04 +0000 (UTC)
X-FDA: 84687111768.02.12451F5
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6AEE040022
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:02:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="iPnM/iED";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3KBvpaQcKCFkGI1KD1C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--pratmal.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3KBvpaQcKCFkGI1KD1C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--pratmal.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776884522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UK/b3kF9CVImcy9Ye51I67Qy3lRyYOCKL572pRP5aNA=;
	b=621tb7ABWBfVZNQZIZyOz1z7mVcwjuU5HkM4VqiTCHOiU3FrowAQBXMSf2p6hhGXQkINOo
	g2HLQAu/fWlBT1PIOrq5wUEMVYHNOKO8EX7ssKlft5t62nkuqiGEmOHU4eKGk2ZKkdcxX9
	MZAqwRpQi3kk0Nz7qZvKMDcPbJVJh7Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="iPnM/iED";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3KBvpaQcKCFkGI1KD1C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--pratmal.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3KBvpaQcKCFkGI1KD1C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--pratmal.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776884522; a=rsa-sha256;
	cv=none;
	b=wkIHaTf2yWafztvnwK3V6YaRJ1x2SSywLO2uNeP2oHLRoSgRnnqiN/4O8iSdPCQWdPljrM
	i5OyWAd7wH7wKmuu6KlVCau7JEXpui1sq6jngl/uScnI6CpzVDREuiseAudWp0nQA8ieVA
	x2f2IQecv7VDMzpXpRNIKQ5bHn/lT3Q=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2d8a677cdfaso6158802eec.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776884521; x=1777489321; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UK/b3kF9CVImcy9Ye51I67Qy3lRyYOCKL572pRP5aNA=;
        b=iPnM/iEDjGYMZglZTQ8U/O8hpoNz2a5ayDj8Xx1qygVtgzVCT0HTU3HTND5xykwPba
         oyUTTNtNUMcV8ryE9T6xL3i2FIM1GAmT6uJhp4gNY1Gla4B2yaY6WFayzHs8gNzgoPq8
         qmeNmKbiQEzRGcykh47S+w2rvt2zd5ErrK3K6ssahnEFgMVjIje7LU+0e4bPlnJtGWxU
         KPBJsQiOQL1qWCpyii3vp+gHJdbDobIwH+UnUm/gjaIIX9Pxktj1IV/IWEgmn5VLpKVx
         zDXfCfaAaWZS3FInHFMNbOkEvmlFuMfzSlbvaIkwfneML9NbL9yzL5EKcJjvlwdlum5V
         QxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776884521; x=1777489321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UK/b3kF9CVImcy9Ye51I67Qy3lRyYOCKL572pRP5aNA=;
        b=seDtT741lY1Ifkmajn/VercqbdoYZiwyaVSusU0r9Zk64Rt6+NqgvmLD9F07HArQuU
         c3G5Vk47oWLy2wWkP7B9WhF/UUpj748nW0iG8SjSc1rQEVq5HKH20NPXPy1vFFgoSgis
         gtIR5ZDAdPv4lPlzyYKQxRKIzWPaL2h//len9tltqXmjejGePdY8q1J8PmIzcOc4uixp
         693PehvGNQ1ypuHUjzjWaBjpC4UlAMXUNyy8UP1Ny0r1ipYU/A7YAZp30xpf5Oieub+K
         OdJe8uLAwcGxbrPQflVnxY256fJTQoQmR7dZoi6Go94LvSTrrQp0ZPwYlAAPDNYUV5UA
         b3hA==
X-Forwarded-Encrypted: i=1; AFNElJ9hBhNZBkZlnMJVRcdAaRpGnKU4qFPsTL+ixGIu4JmGppMflXP2S7u0xFX7NTnX43HnGaA72cd1lA==@kvack.org
X-Gm-Message-State: AOJu0YxhRjH79xXpjWoM8fzg9wUebHFnXIY5pt7Vr5lXckIhyn3k+1if
	zBxxA88Wy/0M8zP9jSHmTtVozq6DJJBHK+l2Nils1GI1WmAwj5gjfOMnlDjBNGrseL8gv5KQ6L8
	vhr9DkuMYKg==
X-Received: from dlec2-n1.prod.google.com ([2002:a05:701b:4282:10b0:12c:4ced:d080])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:7f13:b0:12c:873f:eba3
 with SMTP id a92af1059eb24-12c873fef0fmr4642699c88.8.1776884520768; Wed, 22
 Apr 2026 12:02:00 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:01:59 +0000
In-Reply-To: <03a23a7a-58fe-42f4-a294-9d688ce33e2d@kernel.org>
Mime-Version: 1.0
References: <03a23a7a-58fe-42f4-a294-9d688ce33e2d@kernel.org>
X-Mailer: git-send-email 2.54.0.rc2.533.g4f5dca5207-goog
Message-ID: <20260422190159.214830-1-pratmal@google.com>
Subject: Re: [RFC PATCH] selftests/mm: use pattern matching in .gitignore
From: pratmal@google.com
To: david@redhat.com
Cc: akpm@linux-foundation.org, shuah@kernel.org, yosryahmed@google.com, 
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6AEE040022
X-Stat-Signature: 35n9oswjydz1pn1ue9mhp9z4abdsm6rx
X-HE-Tag: 1776884522-153460
X-HE-Meta: U2FsdGVkX1/FxfjvVdqH3KaLSyI5ePIHpywfQFcLi6yQRLgJYBvW+xXehkrvOJdEH14qCyKSMWstCvzufowBc6t4EvcQvfmN3DLQ7aLD8jCiik/5tNPsKjI6/cKYVYY2Vwxp0bjtqQFF6SoqcX2Rx2usUtHtvyMXWlD9yr1Cej6hMjwL8TSqTpyfTjtNOWhNIxSYpUJ0QST+A4aunnDsbU8ZnJZ1zwEUyvAbM3cnVQPJIMQ6HkXCkEh2f6r84wJs9SlkOhdXNzy4MdipcoqKCYpwgTTt42LeQZakuheAASoFEDEcIJUx/7toLzXlCnJkfN1b1aT2bMV2Cgn7giDw8BqsWHSuYJy5i00kyHzJetQz1QeyKqqdVY8T+FrmQGckXcoKtGXwAkx3rmngmSNWVAdKmkmk/S42PC6pJL2TGXWJF0plOHkiCsAtBB6zIg61y5VcsOhKTo/r//kcjibN8J/6N6dU7v/kBBJMEIIrt1nHbTqPfDbFxY0SxZ8vSmsfIDBmIg0PdSfGuOeMkhpH/jktL/BJwcD4KrK7QUIqDnO0IlYCDPUAVVEZIY/GR1+xolq+/zGayEmUr9+VAFwy4ajol4ZXUo/sia2Ewo+fNOL4VwpGnX3FpjQAeo3hi2h25YZZo4TEYLsCGYfutbZXvcsghMq0L9sLDHdsXTgu7LE6fy1LpmcpNxw6ZhKivdvx8P95L3szuG07axPQe4qWGUAmqu42YkgwrAmo03EyeHZ6MHay3CHfrAp35XQGe20Xt7/QKfTxlK00L2S2PKcgjwkvE3Gx1YNPB4QEDo8oYLuLEmtm7HLE7IkwqqcWUgcTRoegxDIItiJhQRGicBjmXX8v98IK1bgFZOWRj6G4MzMktZa1IY26LAZ24jKoYP+Ys9vcKmPXjf/FB4ka9fLds4GR9/pSZivGxlNNw66xl4PDgFWyTYQvzpfInnGD9DEN5lsW+jXuX7hMNaPqVt+
 ez8GbBNl
 thuXymB+Yyh3HPLzUUkK7AHIT5Enm7qE0R3tb2+Z3fGgCR3Wnj/XzvIsJlNAvJkQ/7Z8+s4540mM+chLFNDqXl4sQtn/eEQ2R7Br0oNo2zHM3MigWX+QrFVbBBjYz8re4O4aRBht9+acA2IO6SqleNCDktncZMHQdLBuH7x8BCaunND6vRmg0vo+gb/bEYCWKqm9wZEUIyBAytqsCPqwDIYgBIcCQrcHTd6IIVAjcMTU9XBU6VB46pO/HkJEkX5x8xnwAljDUERjQ2HKjs7MJ8jAz1RR8brxMNxW7hJZzyfjbKUdkAMrUx9MVNNI+zOf6klcmn643hmLN91KFnpWvTASmB7FLZdeDOy29q5CEsr1o5hdHaD+JfGZBcq7utVfCSVqpV4cgiLT+5ejRl+aFYiE/WMxtWrTmo6vkXUkDpI7taoUxfXEgVWnlY6jUOCcnGPumBwonSzDhADna3fMnwxnVck6z2gVmluuCM3tKm9TAg3S2kpxcllEGbX8a4sA1GUkJCgWcbAPNJpGcrAhqIHPf5lb2dwQ4uy7iD6KcjKd32QsVjbyLVHrRpbnLr6QqKhMi5iW2+XyYG/WcxYB888oUercZq+G0Y1RxkyUpnmdOGxa63Hh7MK9X5pVyqmPD03DS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 18:04, David Hildenbrand (Arm) wrote:
> On 4/21/26 20:30, pratmal@google.com wrote:
>> From: Pratyush Mallick <pratmal@google.com>
>> 
>> The current .gitignore hardcodes each generated test binary by name,
>> requiring updates every time a new test is added.
>> 
>> Switch to the patten-matching approach similar to KVM:selftests.
>> Ignore everything by default and then allow source extensions (.c, .h, .sh)
>> and tracked non-source files.
> That looks pretty nice. Any reason for the RFC? (iow, are you unsure about some
> side-effects?)

Exactly that. I verified that the build works fine, however I sent it 
as an RFC just to be cautious. I wanted to get some feedback in case this 
might introduce some unwanted behavior that I'm not aware of. :)

Thanks,
Pratyush

