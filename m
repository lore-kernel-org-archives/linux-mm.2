Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 643D9C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 17:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72BC46B0088; Fri, 18 Sep 2026 13:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1F76B008A; Fri, 18 Sep 2026 13:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA5E6B008C; Fri, 18 Sep 2026 13:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 384E26B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:07:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF624C06CF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:07:30 +0000 (UTC)
X-FDA: 85227514260.16.34BC003
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id E65B7180007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:07:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DiEpTEIn;
	spf=pass (imf24.hostedemail.com: domain of karthiproffesional@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=karthiproffesional@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789751248;
	b=HgEXlhTL4kJkrEf4JI6KjNSDBWRWba5F84hRFGfJDLtaAf+ChNh+7bcxBbsirVYA7oxtRd
	MPd4PncdZ5L2MWP6Jbq0PzEImPWlUp4qYcfG02ggUJOJPTYYBX5EPVli7sjFk/MqFHgzhA
	+dtvcff5DD1FZQzY6/7/vZsAzJ0QUBY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DiEpTEIn;
	spf=pass (imf24.hostedemail.com: domain of karthiproffesional@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=karthiproffesional@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789751248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVQkb8h/HFIIvBjGE5JjDQ6o5No3SfXCNcrCIUgaTp4=;
	b=7h4PKl7s2tqLWISJ/LUSm9DDiSYEc85YJdqPcEkK0qSai2fFAAKfn/v6Us9hQvi/s05apY
	F1TBaxUCxpQCnEcVqHQ7A/njspjj8ZzPJ6VLrtpkiKR4bGlDwJlyRJ5E1I1xakBe9c6JlL
	7dxygx3wNPIvfKLh3rM8AOw00pvkHOE=
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-39d654f02baso941848a91.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789751248; x=1790356048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PVQkb8h/HFIIvBjGE5JjDQ6o5No3SfXCNcrCIUgaTp4=;
        b=DiEpTEInYYJxnPG05W+gWYF8Xnm+tpIMVxB90uDpNsODdm/moVd0dp76Qh2wFx0xzz
         vwdw3vpB4To6+2PdStVvIuPWsQC79MrPN/c+JedZtur8M6aq1Ed4Zol69bpVVh6siugv
         /OQHz/H2xiKAuIbTkouolbPgHYherNWBFCII4on2q14UYWfLDQ/nc0SVwjk3hbJVvymS
         AU8EWIBTxiAg8b639yFv6zbtuJPJQ5tatIN20A1whlWatR8mXa6A7p8S7ft/c7H1HY3y
         qf1AcIqokkp3gEjxb2swIeNgsetL1LfoPXggsfD4Rve2vXeSOnCLFvg28LHAEKicpVSN
         U8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789751248; x=1790356048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PVQkb8h/HFIIvBjGE5JjDQ6o5No3SfXCNcrCIUgaTp4=;
        b=HvFwxgaCm5FJevdJr2WjmLtAV9EAQiLl8Mv3MCsfIM+ZwHhx5wsTDDs7fYnUg3DMqF
         nFFKRNfcnYzPXZB3hbwYyI/FO7AS3BtXt+y4UA1f2lgn3O5CYuHVAMMR/tuHGP2rzUlH
         y139y9c8lzjejy1SCgs/BKoia+sWBkli885o0ZZRlm56xCNsS72/Iv3PiGOVw2cH0aDr
         xo2fF31DuArkcZag+jYLmRj7tX19l7jflOrhuvmCkuNLwPwEFPhfiXHdQeRlXld/ZH4N
         zKw1t5O6ylq7C2gHX2Tv7KU+s49L/TNHVCArfq8TAwYsSPKbbmj+1R6+LfgGE8oQ2KFy
         BwSQ==
X-Forwarded-Encrypted: i=1; AKwUvBzS1gcN9xUgCcV6SCosMkiXwutYD67g8zoF6TDZLUjYazmnKM0WyUakMqGM6m0H2fUywnzvChwmTQ==@kvack.org
X-Gm-Message-State: AFuF++l0WDIRYOBMUQZtQnfvfHQKOcO2GraWIBlzyMiZDbqLS88IXzVr
	Ofvu1L25SVmkp5lA9eHxU65HZTQPm25kfv4J7RJ/u5mrQeWAQ+KfqwbI
X-Gm-Gg: AYBFou0m+YbM0BpO+49h6otSdmsz7giSvmf/c6VUA94kqDPOHs7RcW6YVeAu5TVpSML
	Wg/ml1p/fT1QCJJO29LnF7ppNfPpItJ+jKaDiXbHbksvPsuemmOK8P/30KYLhuXt13F+l41SQUt
	MUvErUdluLOBmpLM3/otu6/CcjOsLhCbodw3qoHzho5iO9LTztYXL6mifLh4HdRkRVNW7be4d3L
	KA3TNc2S+MhCdIAhf4pocyTb6AN80wURV+JjbBwt11Y/AennVBT7XMGCN7q5EoMuCHEYIsvo6Y1
	jXNE2X+3jpgUaD6DiYw9KdEP9mUc0zeqDfPynDDn1i3jRPpwLY2EPsIrFgMq0vAuKPPtp+I5suW
	LiyNtvXhjcy7W96wXifza4pQE1LnpZBbdk3MWVaf8+oQ8yMNWd49g4OuWgN+PrVGcGcbtjXWb9m
	0LSCyBKBav5+WktTA5/wR6qJfiyPzRp7FOWewv/IjpdQ3EOZd1Mu2MgoaQhas9ozxUMBEA8gJuc
	Ie9Kaumv7J4GB2wcyvIB5lU8+I2BtgUD0NhSvhcYxoG4AY8WyYp+XPlHHtsIEwhM5uskW/3agp0
	ZTVqx7coWHPYVvCZV8EXka4Csf+ZNJtQyfpJK2uuvpRs
X-Received: by 2002:a17:90b:39ae:b0:39e:6c69:34d2 with SMTP id 98e67ed59e1d1-39e6c693659mr358962a91.54.1789751247561;
        Fri, 18 Sep 2026 10:07:27 -0700 (PDT)
Received: from LAPTOP-97G9G880.domain.name ([106.222.202.182])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144d55e29absm116665c88.12.2026.09.18.10.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 10:07:27 -0700 (PDT)
From: Karthikeyan KS <karthiproffesional@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon: document that a zero sample_interval is accepted
Date: Fri, 18 Sep 2026 17:07:20 +0000
Message-ID: <20260918170720.105849-1-karthiproffesional@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918133513.26828-1-sj@kernel.org>
References: <20260918133513.26828-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E65B7180007
X-Stat-Signature: 716pq1a6mpj8j3zr1kyo53jscqcnkndk
X-HE-Tag: 1789751248-930097
X-HE-Meta: U2FsdGVkX18utq9q0CVDXjC0wJkWfPbKPuRQlKugBmRpx/5hVgaqwRsarwrF54JQmaYVJzAQrVHidJnRLes2afRDilnE4bL4Jb4o7ycg03gWbIgj9ntWuJrGPtuTEVwMwikJwERtoo5OCKI9kChM7zq64Q16J74qhBzR464itbLgeta/+r/pe2kKcaZjboMmTIhigGlpcE9X18VyErY0IC9LToQUGHoE1VVI5FObVxGkRdFc/t0hbB6Ab72FC7ji7eKuGwbBdPw5jQ1FcX9gxMEtBYZTtkOcPM1Ly15C1FVauEjuLOIhTpZ0ETisuXXOXQwWjET8cTE2qeqsaL9+ssn/uF3LLHMqtYI2IrQULsnNH4gk/zU1/Bj+bO3OxsAOc+OcAMmgua0yibhEr3vWeyV4FJT9xbtBkq7SwzVrgeZiG2FIOvIqq9ny/NxI5aYGritbiZIJcIN4bsyAWsltPEttDT48FHdCDsswuH0/Nas3/ba1wAnji5IZxxHdYx3/xkDl/r+2nbqcKMrvBpuf8Iw/R//ggShMyrWyOq1ZEd23D7BPd21I9BMuaMBv5idLJUjuWvDMcQwfMNRIOcbFiAVXqkDSYHE3o9HmDV5y7n3SXsF50d0t4wpnHe6/odk0STfWxYHQPse0WNTXtlLNURUbBXXGscJ5/yCFwk8Xe2CO8RY0x0h2qZDWklA1pyKK0o0EX2jjzhh0mIyJiX7OSEhsBOPRpSXY7CpKwRZ3NI/U5RH7UyY2RTAlBsPRp8xNkteSFXjr+H+7h9TSVH1JEodQ7m2wKOA6W6E3gtDr5wUS+8SIPjvBtOzWWYsl7dovlX9Mt90Mr1cglrQc4EEQHCzHAHSDButqfj4eD/d/9WK8m+ZHd1uL3fq0NstgpWTenAi01tnIyf1xeI94eRLIWeErJ1Mmd8iZijBOQXey9c7ejml8vQgr4bSbdHit+2vjGGJpdqR8QbBJ16H0qi4
 eeSGWLzY
 wi+2bdz0xk8EKNuSBfDXU7Dl2vqmwise5LYx2hRqagVIKalqE6ognUSZHujsmzG0kRqHz+qJS2woV7wLlUtYnbT6uP1T8CS3gybh+s+V3cu6xl5rz/6xcMMIojy4dad0xwtNscmfx5KtHxGbzW8yABSASErGjlpR9W3M+cwTQ5Jv4IKm9mIVT3MjqsRGWjD536GIj4XmGTZzHI36u6C+fdghDgtMZS3mYDsbWn4TCACAkQCnE9QQuDNCS7LnbWndEq/S5IZZkg6C7pu56jo48lxzHmMrhbb3898678pWiGkqhR0N+6Os+2RXAr1FIjY7rIkzXNF5k/czU535s7+KclFsQsw/1p89NTjjJ1L6DhK2QG9iZRR2rmX/rt7HqxuwKi/nt0eBSLd3+xboz+SL65y8PTSlq4e/maT5twaZRnJ7LU5ewu+EdydTekA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ, hi Sang-Heon,

Thanks -- appreciate the review, and the pointer to the July thread.
Will post as a new thread with a link to the previous
version next time.

Thanks,
Karthikeyan KS

