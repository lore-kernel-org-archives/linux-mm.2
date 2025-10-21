Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51DDECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977828E001F; Tue, 21 Oct 2025 05:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F988E0002; Tue, 21 Oct 2025 05:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E208E001F; Tue, 21 Oct 2025 05:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4D58E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:44:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 307A31A043C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:44:37 +0000 (UTC)
X-FDA: 84021636594.06.B9373EA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id A02531C0003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:44:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gU1Jd6o+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761039873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7HVROVgx0bb5nBCxg5N7qerxadWj+WPkTkgih4XRWM=;
	b=TZTpNOjiiyGaN08/DE5fiQlE9rhYiSOt+MP9uFpk/0YUQIDS4n/ywyAb+2kspPDBO1LTxO
	9Mo0pWg52ez50tjoCFyTa0aBCKvaVEuyXJqZo+cR5ro2eCiCNLBSxG+MJNWXBlvtXabWBK
	cFyRMIs0pAnNKkHJJzqkf3Eo/zFrvFU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gU1Jd6o+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761039873; a=rsa-sha256;
	cv=none;
	b=cpSwrsB0Ay+NLScysmKxDwBY/fg3UXx/osKYpmjHqKwRESRUkwrrTnAC5DL+0wsxQV3v5K
	1nKpdqYeB7hxQ38g8xxL3C6ibfj0fx7P/Tg6z+CU/hPgqZaJ6Cy+3tFYO7vH5cjsvf3H2F
	xsENfatQxNgCfwdEKmS9Lp1358g69Ng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761039873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A7HVROVgx0bb5nBCxg5N7qerxadWj+WPkTkgih4XRWM=;
	b=gU1Jd6o+EY2rkh6l6eeN43pyBq4wAztQQ/a/J0m5lmxfUFI+25zSAH9Ra6+Y5t5InH8Pko
	EfqvaGkjUEZ/pLxINXsKHdNBZEagA959uJkLQ4DBGdtZ0AnvhRbTp+UKajqaqMmXVzv0QM
	uez+A6nFh6CDuRb1YC8OMjG3Du8Ke9Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-uIbnuLoDOqOjCgdTl8SF0A-1; Tue, 21 Oct 2025 05:44:31 -0400
X-MC-Unique: uIbnuLoDOqOjCgdTl8SF0A-1
X-Mimecast-MFC-AGG-ID: uIbnuLoDOqOjCgdTl8SF0A_1761039870
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso28704195e9.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761039870; x=1761644670;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A7HVROVgx0bb5nBCxg5N7qerxadWj+WPkTkgih4XRWM=;
        b=lsXyQO7ic2RNdN7pT8H4h3l/hJQkYBZxCFhtCN08aL3JdDnAZNVhnuoQuicb9Wp7ZT
         wzcWRqhnM/+IM+gREc0AxiuG016YsATLlNzpaTMklrvJJDir8Lu/VcMIO7QAj12mYQiE
         loE0k4DsF//VsXgS8Swt6y7i2BEflb4vUowcnr02Jk7TvXH6q9eZjS3uJNDN5S0jnfFR
         F5bcSQVmzq+gX2fRCHYHYLDxV6DhIOgm09F//e+q83LAcYcaPRaTh+uukn/erphSV3Pd
         PAI0qSSEOmT+AJxktOhWcMN7REsOfVALb3Zn/YPwENQ7S8QG5Yl+4DiaI2LApwLyD5rY
         0GEw==
X-Forwarded-Encrypted: i=1; AJvYcCUigxq5Br4Z7QmzWicTZwkpsyKrliRwhjbrO8I/3SxyTvpq8ZnMsAGesrwMdCuNTZBPZNOrHeDD6A==@kvack.org
X-Gm-Message-State: AOJu0YwzRLn8DPjTrbbp1BPLmERIu0dLnFAbb4iT4zq0aLifoM9tamwN
	4BXN/WReitflnCWXAsai3OnodkYem+NJIOr4OxTb0nCX7Dl28aj1JVfu3e2m0LnBBJvMFfG+JNg
	0uGqMgyd2nhjdEKz9CigG6XZrLgvI+mc7E6kCeUVzRObJ+h7sBFDA
X-Gm-Gg: ASbGncuCRIJysBPLrxTqpDgia8gp5O2NNOUPVmZGdw8mV5b234mPt3nV676DZWe9kgR
	eMFUmyzTkHnB4y4RQ342hDgMIgd8RfkcY1GgcBz7+BAFifdkJP9tsUwemtzVnj6XGL297IfW6d8
	kcpqan3WQA6Jk5LAnWSFUon7l59MtbaPk5Fz5GvNBXULVQTuvC2WNFQcfdQSm5KsElUD6SQMKKI
	5z55XvrBN9C3ySZEa6pV9ebq1JnuDMiCIn0K1uW6lOphZyUvUkB050kuEQ8NBYsnEdY1JmNJAuv
	5QtubSuW4mv2RJsMhiJwO20bTG/El9L7nXaxymBOwRCtFFspd0W1/mXyM0hFtGUcybID8M7Nmze
	xXpuf8ZfTbyiZ3thOzaDHgkL05vV7KhKOTdT0CjkGt0GqKlRw8i6fHnTlGZiOoEFstqMuTccapm
	NUMu3HVoqT/glTdvwmUxEhYdq32W8=
X-Received: by 2002:a05:600c:45c9:b0:46e:37d5:dbed with SMTP id 5b1f17b1804b1-471172d7ee5mr122639875e9.12.1761039870374;
        Tue, 21 Oct 2025 02:44:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETXIw4CRBEm7c+CrRa7e7TiaCGIZ5364ZZEDG9h9Uqo1MIuOZe6REk/G99LmxJ95M7gJl8yA==
X-Received: by 2002:a05:600c:45c9:b0:46e:37d5:dbed with SMTP id 5b1f17b1804b1-471172d7ee5mr122639705e9.12.1761039869981;
        Tue, 21 Oct 2025 02:44:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4731c95efb9sm153935405e9.8.2025.10.21.02.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 02:44:29 -0700 (PDT)
Message-ID: <a013f044-1dc6-4c2c-9d9a-99f223157c69@redhat.com>
Date: Tue, 21 Oct 2025 11:44:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/truncate: Unmap large folio on split failure
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20251021063509.1101728-1-kirill@shutemov.name>
 <20251021063509.1101728-2-kirill@shutemov.name>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021063509.1101728-2-kirill@shutemov.name>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2SJOdvue-oeHmAfpGxXaqLwQAzUEydCjnTWt7snt4nA_1761039870
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A02531C0003
X-Rspamd-Server: rspam03
X-Stat-Signature: deq3fnjfcphuw819re6acmuumrgxe8ai
X-HE-Tag: 1761039873-401393
X-HE-Meta: U2FsdGVkX1914sZNuRq/yOs/bnldssVCG/tNfAN5cL1Sgi+JsbZmWleUFmHdjn5SnXybdPR7BnuFRi4gmk138h9khNdcEAK3NirDkMopueuP58ddK8kiaZOjLxKtEyqhYm3fx9np09cRWSuddoYAZ4dQJv1BSh+6SY6BTpeUkzVhd1YukyvOtpfys0nB3zKmyirqN9oZCPoyIR6y2U7xrLytX47AHeG3mtAcA+yVt6dhykUi3HAxAhFOO1i2Xwh5MhFd9smuuoySXfoDySyRXfKCQZPAI/Roaicu+9A9CYbGpUeTXYON4xhJlt403/3lbw/zOaBN4WutgHXhaGa8SkYGPz071ol9E1go28BULL6kwW+nm0ztQQLhSQRbvxRxWj3Nu/kylrN6slKrtamwFgsdwQ8DMtfv8Sp25bZpCfCyoO44QB8jNxvEDso0QzTc1LqbXzNw3n9ywViZYswcJFkOdKqWmqaqQRhCY88AoOpcFLVR7YKsCa/pVa7V5KuaoZ2dL9izVoiWwIsUusagWRzA4CQuSpKvgGTGbpas0GVlV5EgYtBrJZ/TecPbM9afxEt/24QP5Cx4wBYc57iI2Jl/NE4oVPxquAP6vy5AgObodMcz12wNW81IIKwUoz2G9hdMC4VpHTfHPeGGkI+mS1aQdc5xP0NYZqvOHU3JryhUFoa2NY+QQAk20xOtU1armGrwHLkYzvFkBuz4UiDhT8jafEiqcwvUORzLavgt6GbNKnJyxyOFIOHBizVd4zBEqquyl4+eO2GWbVojpZlJ4Dd9L6H20ZhohKkREroTtoWpH5wUipFfHF8JxOhS3rkgNksBWigHXQzNTXyyk2g4X38KSnLrf/tWwWTCN1QGXeh/y0gjo/m1K0FsyPO0MGbJnSfJiYw5Mqe30ZAgKRInhh63IdWTbXeHo8o54JONrlJGCxaUQgL4UFuwDVUSmaj90lFhmPKJ6+loYe0fGjw
 RL4myfoR
 r1J4RDnK/53ceq4F4nVCyvcOmHnNhElbJAcZctCrxv38Ia4Xa4UjWEELdTBFLi8+O7e8NhTbHPg/XUbsS404KGdAdBV1G4uOFE0cleov/KBVgrIiFb0EuhssnatBbcEu2UsELqz6jLYZvecUm+U8qykJN3ly0U3yNK4q4Cl5VcL3ER8y3Pnx9L74ATvWFreOY/fjMpFonX6qkmBwSoG2Ez9Njh6vJRTUlZWhDl04t/aavzixcPz2gYcBnEuRxNFxGkVs0ScHse+Os8b7eYva61tHU1Wsqdvza33wooOtbV6ByNFsFFI6zcZju+7t6MgRrOQFocwKpEdt6HwA0bqWPThPyDZ/xUlzuWuFJzRqSh34+b/xICx86z7geSGCF1FtLfbReJASdzsKy9EjJAFLeCPmGpqgKAX7lhTZfSg8djhw4U55NNWPiUcomMezTlw/6P3E+TChp0hRbBao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 08:35, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> supposed to generate SIGBUS.
> 
> This behavior might not be respected on truncation.
> 
> During truncation, the kernel splits a large folio in order to reclaim
> memory. As a side effect, it unmaps the folio and destroys PMD mappings
> of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
> are preserved.
> 
> However, if the split fails, PMD mappings are preserved and the user
> will not receive SIGBUS on any accesses within the PMD.
> 
> Unmap the folio on split failure. It will lead to refault as PTEs and
> preserve SIGBUS semantics.

Was the discussion on the old patch set already done? I can spot that 
you send this series 20min after asking Christoph a question in reply to 
pushback.

-- 
Cheers

David / dhildenb


