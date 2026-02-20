Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC001C54FCC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 08:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C0C6B0088; Fri, 20 Feb 2026 03:02:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33DB6B0089; Fri, 20 Feb 2026 03:02:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F976B008A; Fri, 20 Feb 2026 03:02:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C01886B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 03:02:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6147EC36F6
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 08:02:00 +0000 (UTC)
X-FDA: 84464091600.26.5C7117E
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9F318C000B
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 08:01:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KZtoCYoM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 39BSYaQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=39BSYaQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771574518; a=rsa-sha256;
	cv=none;
	b=yalgMMUnDx9JK+emFwzrsU06FjBAmJl/VZIyO8enjJ3NZNJZN/e/pGn2269gECw9Yly7j9
	KngEt0n6PjwFdc+3yKgKqgpyHqvDAtQCa59Zcj6BHRrg/NatodwYcwt0de6QWrcr43U8oF
	PuZkATv1olv6fX140QCRY2N+MTvRCk4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KZtoCYoM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 39BSYaQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=39BSYaQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771574518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpmZ91pFlVLj52IzRQKQdCJI30gSUuotaRTYqedSM+s=;
	b=UIOFQB0yXd5EBQbSNV8ushkp6D5yvQFDncE8/sM77SkOSpcZZUMuCJgCch4l30CpaBrAKl
	QL7S0z84ceiFVjwD+eBhh3NubPBskVdRNBRigou+zj4D4dkIsZJZ+HtuzW8tTChUHcRJ4c
	h3/ZwSBwPgZSir4ncfPl86NoiTy3Wqs=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836b7fbf4fso18387085e9.2
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771574517; x=1772179317; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tpmZ91pFlVLj52IzRQKQdCJI30gSUuotaRTYqedSM+s=;
        b=KZtoCYoMLviBWm6iIidVhrTNl9LtQ3gi2QzdtsWOflDgoZ8bNko3ijdfecaro8L4ro
         fO0puZYrDbNOiGhpPKQ0KEeNOUnkzmCvOYtAohD/siOzia1Z9c2pGwLpqzyxGi8/qCZA
         0N8BWRUlix239QkPOKwfOGeUM0yBYRB+19vB04L1YcJUaI2WeydB24a0aNEjsNTKbA6v
         FhDd3yseZbMPf1oIHgMXQN5yZxKFSpdOmX67jXP7X+YNIGrdBrPSwBTZy3cJc9jMMUEr
         eJ1k6D5OIyX8YzdP55jbYvyRlmQicKCUpMG2gQ7zuuKz2rTf1W5riXEltHonBDDnX9w1
         Ubuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771574517; x=1772179317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tpmZ91pFlVLj52IzRQKQdCJI30gSUuotaRTYqedSM+s=;
        b=Kz/VFLBn7mcIb2P4vGLLYiMvUUl8u7AQzMDd1lMwcxfSZA553xj+ClZcgoGKPf/fdT
         AhHsC2LvvtDK21LvPS8ZMhr3DDrZY594Jot94paVyAA21MwbcdFw5eBrUe+r8DeQIodh
         VYxvMZdH++X6Nxk2tXl1vFKL+KqgaOo3FnQSK0VNMzRpF7vMCkl7rZw/DOSW8h8ry90e
         nJNRPhaqBAL0GTTTIZW3sOvMhau/rhe9WOU+uV6gbLVknyLpK2ksB5WDkKW6QZfVUrVi
         l9uI1ujM/dHZcU0X88ij19zABUvJTdG9q/0/ZdOZauJdx0nD9UlElHJKs+ytiEmn9gmZ
         wwdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXH7II7EWHr9AddxReM1CkxcRua4TMFNTE2RIBy/71i/tDe9ahz793B43XPYPSmxONXrCearPmJ2Q==@kvack.org
X-Gm-Message-State: AOJu0YwNAMC76MmCvc3caqZKGamFM52pKW4qHrAOh7xPw/LAJ/yfE4ay
	sa05BnCLucD28pc7wpytNzIt3X37VGflhI72/+sbt7JPLJMA/nW/MJaItLxMhmn8j7ogAVX85pV
	zmcn9GeLg4Up6nTdDIw==
X-Received: from wmqf8.prod.google.com ([2002:a05:600c:4e88:b0:483:509d:729b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6091:b0:477:df7:b020 with SMTP id 5b1f17b1804b1-4839e661d1bmr99895665e9.18.1771574516871;
 Fri, 20 Feb 2026 00:01:56 -0800 (PST)
Date: Fri, 20 Feb 2026 08:01:56 +0000
In-Reply-To: <DGJ3LPUDBDTK.1TK1DXXFNXYPN@kernel.org>
Mime-Version: 1.0
References: <29e454bc-5a46-43b2-80b0-4d8d93e3feae@zohomail.in>
 <aZdBDOPUccXa85O2@pc636> <DGJ3LPUDBDTK.1TK1DXXFNXYPN@kernel.org>
Message-ID: <aZgU9Gup2_w58kJq@google.com>
Subject: Re: [RFC] mm/vmalloc: vrealloc() shrink TODO - seeking direction
 before implementing
From: Alice Ryhl <aliceryhl@google.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Shivam Kalra <shivamkalra98@zohomail.in>, linux-mm@kvack.org, 
	akpm@linux-foundation.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9F318C000B
X-Stat-Signature: eakzbcpnfkiqr13heh6qiymxaxbfuff7
X-HE-Tag: 1771574518-161063
X-HE-Meta: U2FsdGVkX18IXUd4TMe8GNXyPZv4VFP02mkfoH5NElD/fp7X3jaGpOB+Kcj6bnHoqOuu4oHTOp3sKU9xhfxvfJaVogZcUQLsHM5MbHRcfMXnrUgUzVoRtK4loQoH4DVGvV0ixNOwFxrtIZ2XDLugXQg9amGqMdGml7IkbWiOWKi9yFmjv6cs1ORtqUpA6n1zCBCpKu2QSDevmu4oZu3uBpDCshQ+s7gvZhfOP5jR6bk0LtQrQhlS+Khh0ldT1TDauUu6UZKO1U/RlBWwsOcd0WFvnhMKIpAF3eKV366j5VDZQox6vgJ8Xy9LQwLTRA+IuB+/tgrGj9Rl3IEnAv87hlwEIw9ZYBhJlgI79F661asAwqNfcCMVaS6aYJK63m0niG+oPWxoANe+v4RrAxIyvfinqxjJ+frm1FQMifbMDhwglCMtRspGL0PLDJf7pUIIgcJCS1NM1OZjIGCfQoqD/j29p5Gzu9bvgrHIZ2503kQlkj0e0DWuZwKR6rntgLuVZvqRM7KfVUkVuvHQZakHZPL/GBcGgMtLIGt/nM6iH2gk1WOokNc5QazahV+2ZavuEabrJVd58ZW6N/hoz+kM21OpWRH9uz6VqxUBwYAiKN5MdhundO8SsslTMli44p4gHPcHAzBpWepj2PK8xdr7MWL481FUqpLVIw5grQRsW873m1U6JyP8M1RiY+RzT7A0BRxR8aDjMJE1i8ELsbRUmY7nTU7XwToQDINiymGChN3U6/P7zGzVjvN99l+H/1KfRNWoEVPErQSPC7mhIHSrbtaMML00z2mJMIAnNHQ4UhWVCywEMR1ZfVL5g57SQB22VOTqyux+HOsJhRnWggt6rVkhzuWzz9GYnGQgO8X/1rlBJYZ858HlTvxnS7BLhqhEtCgKDrRzoeCOilPZskTFbanxaFnBeb68qRzOqzhB/k5c07XV3hM5gs/qCx3CcBq7R16wTFyN3nvW0MaEeYR
 Ua6zgRO0
 kJSf70bcecUNS4wiBGjdJ/X8yZ/C57xL9rWKUGZTXw0FF96U9QMm5TDwq+DyQTYavu4ITI/zTLmIKUqTK5k9M9uUs8r7xffU8xJZ6DcA+FviSxverukLdUTTroHujdOUiv19YRvnTlLTlFKR5Lr1C5vABsdA5o131JK9p6Co2i6rtrIr+R93IKy8N1RvxBmnJZpp2/9yCWiDURjls4Ne9VtOqO2pR713RJbvm0SmSv+KbZHq5LABwV9YakMli47F+kkLQy8RIoBFaddQeLr/bfy7L1tlR5TGozjS85TLOMG02Xq7oUVbISjOY3Qt0vNLoKA5a4ZiBrJ8azliFWwf/Oc08SyHpV4yDKKybYL6XCjS3hmfceEMgA6bPJ18wIwKPRd3l4wr15XY3nqQy+gyF+AHZjGWn64h3B51YxbqiMMz3Ju4WczpT9iSaPWSyYFnpWIksSSxJziIR6tUO7AVzPZNw/bBRHv/8gfSruYl1ZEBbFULqy9463wKYfH8H+JD3CRsywAA0skb0OJTut10QPXP1ezwtepb3iD6zD2uDrKTuo0XIIREIKppTnbvkMkga2DF7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 06:01:29PM +0100, Danilo Krummrich wrote:
> (Cc: Alice)
> 
> On Thu Feb 19, 2026 at 5:57 PM CET, Uladzislau Rezki wrote:
> > I think we have 0 users of vrealloc(). It was added because of Rust folk
> > wanted this.
> 
> We just gained a user with the Rust binder driver.

Yeah, if I have a long-lived resizable array (allocated with kvmalloc)
then I'd like to be able to shrink it if the number of elements decrease
again, to prevent unnecessary indefinite memory usage.

Alice

