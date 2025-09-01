Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA00CCA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58948E0090; Mon,  1 Sep 2025 11:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09058E0084; Mon,  1 Sep 2025 11:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7C98E0090; Mon,  1 Sep 2025 11:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB0548E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:13:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77D62C08D5
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:13:18 +0000 (UTC)
X-FDA: 83841024876.12.AE53ED0
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3BF1B160004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:13:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=KKZeLbJ2;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf08.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739596; a=rsa-sha256;
	cv=none;
	b=phpUeNvSwZv/6d62eeOyEgUx1fSsg30IKUfcgYnutp+x778Ibut+I7sIDAMnSxMsaz5dxS
	n/rqQ/3tlYIf2dMFg000IoSX9BvDN7wzHt/xLMEvkUQnjEheDPW7G/D3/dljyJaQSyDT1Z
	DaUmfWr+KId2jL6cfJv1NBplEE9XCuA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=KKZeLbJ2;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf08.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A08kBdKHaoJbHo5ouUdZLXPFTzEYHeueCSYh810eJqo=;
	b=cz2qz9rMQ1/7Dt+azor7op4dTXb4fVA/ZpWGuwx8/s7IRjX5Js6sXpZbaHC0p9ZBGiVAc8
	anNfHl3O0nY64/+d7VYVHDIW2cHQ7/GyS05kniv5yaFRZ7KaZWH9aFQRBcTD8b7Au3dphi
	UKVI5Zy964yTcQ5CN61pUOsnc3hoGrs=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb7322da8so869422066b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756739595; x=1757344395; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A08kBdKHaoJbHo5ouUdZLXPFTzEYHeueCSYh810eJqo=;
        b=KKZeLbJ2z9rvNuk5/RH9pn4hrgAUFkt+26SOqUj2i2JeAV7KMhcpeFcHn+lCHpOmC/
         DoWlxL4TEDT1/KezdibpmAMr6YsBpOYTxk1UGJTZb6ierX1OZmUmzR+YDdybot6eclFQ
         4gaLln4SNy80fKRJqWtqcOkSJNHzYT3i46UJiINMwRT2DwqkE12WD2CEWagTZGWSKzVm
         /ov6BVPETwz+kfaeFnpR/ol2ERorsN3tkIwutin5Fs0vPb5gosfkbkuOa20U3hvgHXLz
         b/bohlmAFh9qiJXpJkY1KCKX4BUh6bd2QHJvtQZ1QnWtc51Cu9fqraiRt+2uDZvjflt7
         tgMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756739595; x=1757344395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A08kBdKHaoJbHo5ouUdZLXPFTzEYHeueCSYh810eJqo=;
        b=P+3AxIiVPcNSbeYBQa9jpdPGeVHI9JS7y2XTQo0JLhJsFV6pPdlPhBgqlcw5CrZVHO
         ucMBEwq7W7yYpimcqcP3vOeb5IQgCiqtNeqKY3j5Gsihrjl/S35tcqVvinOIzx70S7oO
         ruHSv4b4CH9WWxadSGuAZ2qsWz//vOhtNdgt5ffunJWaTUMOzk0ol78mqy+Z3UBHmo2E
         1UfowKKtPSBrldxtxZkfTcw2LQgZS/Vt0+DUQGcVPeh2Bb025ciIm3VjuFyVUhe3+va5
         c2aTnEGwnrV64JuPIzKMk3VIvZ0YkHaNyojqYBA7qk1PUSe8tQ0nHrGlvWuVhAkyJ1NK
         kn8g==
X-Forwarded-Encrypted: i=1; AJvYcCVKUQQi0Ywkry9h3WZMgTC0hRtfmenvvp2Okf6xmxZwKQZ9ciMvVPc9neSvrdVfQYw4VKh3rD8BMA==@kvack.org
X-Gm-Message-State: AOJu0YxjOjqWpfb9xH8eaKHsFP+xUgqRIuLvKv/Kzro+2S3OX95Nm5MK
	BOZXfNSdNZmNGJRS8yISMIu/L5OvXvqgWKFLqKztINH5XPZJ2hKfU9s9F/vYCHlur9YiSHJYnd/
	OEEEnwVzGFMet1zqW9+y3Dqjp2j79Ya8/Y+y6+pTBOQ==
X-Gm-Gg: ASbGncsglUzs/oCMdh/xgetiauAuJZ8qNUWuKX5zS0U6iG4uVrDCU3XGQdAwPg53ly3
	iHgDzOdlvZbGZE5/Ht4jPDEDsRrBFqeuihORE9MinRnxUjOUaa/rNWE3X2ylpmpes+DM4+M3CR3
	sau69Winxm7KyG7rs0JMwScfPRzrF+0NxVcdlFujiZd1UxU/+0WsynNHxzZ4JiCpKSkt0zNJFwY
	ZHxbTh8JKQl308Wn6EiFI8bimfOzRwDHUEnTFBnhkbkCw==
X-Google-Smtp-Source: AGHT+IEFPWeGuNqM2+QiOgw6fHvRg/b0a6N13KZkb/trfYqooePyXBS3syenI4NwqPjQnySBBQHmRMnR+cpdOfOLUuA=
X-Received: by 2002:a17:906:9f85:b0:afc:cbf4:ca7d with SMTP id
 a640c23a62f3a-b01d979fe6emr930093166b.54.1756739594447; Mon, 01 Sep 2025
 08:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-11-max.kellermann@ionos.com> <5ff7c9bc-1722-4d8a-ad2e-8d567216a4e4@redhat.com>
In-Reply-To: <5ff7c9bc-1722-4d8a-ad2e-8d567216a4e4@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 17:13:03 +0200
X-Gm-Features: Ac12FXzpx0s0QI5qZl1CeOcQ-w6EceVXiGl7R5sUJVErAX6WQ0b3KxehR5HEiuA
Message-ID: <CAKPOu+-zBstZVw4LjKz7ZQyTh_PKEJXaWYsgF0-E0+shAaTvwA@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] mm: constify various inline test functions for
 improved const-correctness
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, linux@armlinux.org.uk, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, davem@davemloft.net, 
	andreas@gaisler.com, dave.hansen@linux.intel.com, luto@kernel.org, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, weixugc@google.com, 
	baolin.wang@linux.alibaba.com, rientjes@google.com, shakeel.butt@linux.dev, 
	thuth@redhat.com, broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com, 
	mpe@ellerman.id.au, nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3BF1B160004
X-Stat-Signature: oskoyttiw18i8boouwxha6tzp1bucb59
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756739595-912173
X-HE-Meta: U2FsdGVkX1/qIxVhhw7j8vVQh4cuovCgn8TXGBnvYbOKxTZSzERCuzpdOrHHsZ+lzcw/t5gBsDdoqwzi87pvd3ld7KJn1F8U4+VaPzgfE+DsEt2H+Dd9+HnZNs2xQZefGWZI0vdrBV+4/5pLJUa9r4AKuFD+UUfHf2rOlKNYb96gzZbCB0FnSJ8y5jYApvUrG3vLDUKwldLaS2LYYpoaBOmaqW2v1y1SG9pJK9qS4WXeCU78kFUTovNc+wWWPjlid1dzAv4DZVYIYES76wfL7fydZ01KYDBsc7nakOmo5gp0/li/DsjtKXhx1qRwa0h9c1yd1FF3LVBqQKJEbkfkt7wcRx6G0L9oauN3D6IjRfJLIEgLhqgkq6R8Qd8fwd0ShKxrbLi1RbSMjFG0A6OAvuHFW0/QjQy0bUmzO/+0FaUNnqHPnDKzGE5eDi/gS9VOgq90DaDl1FJEPD/qOFgrKFBUN84RvgFj2F+uKGocr4ZmPRi4qUbMghezvtPBcb/XDVcDcVUCAbQ+Y6JHUpgHhrzzyQ02PJMjHNBIs09J7C2uwzSJBAmKtfvBqhMGG7OLkS0eHm/ZBqzOFwh20zL3mrk6qHJbcdp7OyqnkYOfI0zyKU0QxF5mxQSPtquSiImANUe5Vyi+Q/BITssWRPwf++dI+9rTfDEmHP8i3spzw3XK28AZceMh7pSoadPLji88C7aA1uQ9h7VVOmLKKKEy6Bd0dc7gyCFTqZDTfhuyQjaXe6DFvGryPEF9RtqRXfDywJNyqKnyzu1hdpPF3dlG9+5N+x3auL4bYWqRlZQLPlEsLuziQuSz4TDXqn5lUSjcTuXSG8IlW2HtjCKju3NYUGL5/tpOEsv4fc8V97PeOcdkteM94/yabqJSkx5XcTquHNFg7cVVibUrRM4dVf/7EiL0R8vkDVChui/3iLvjGL/tb38/mot0TIe8HlNgFbYiMhopcSx32oV1yvtmA+H
 JvArFAsq
 OLOaMQ5G1fFgBRrV3hKJP0Dv1ItaHBSN+Y4z7Uh3VkowuvDjeeVHoCJuc6M4ZUOO5+ScDykDt44Zz9RtZZXMljIAC0+4L593/gT/8TCDibI3YDuu96EIN+5tII6zT46GzX48kKCYpvrGrKzk+D8pnzxekk1qVLjbYTO2rPZGQ4q86KgmqZk9pzfyS82mgWuVAM7ZMl1y4541Gv/uNk99UE7RKtY9kW8syly7yvZ7wD/EmR03RKRBV+hr2nkwC75ZqZQX8Qald1OK9qYLJ73J/bOHR2RzjcyhmwjJg0mVbTyoIhklgJzlmyK2HCOmXR9PUkqyafePlYcGjEPHcRGUJmaX9Pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 4:00=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
> Also some getters hiding (and functions that actually implement logic --
> folio_migrate_refs())

Indeed; I mentioned that one in the message body, and I thought this
was good enough, but I dropped the word "test" from the subject line
to avoid confusion.

> > -static inline int folio_lru_gen(struct folio *folio)
> > +static inline int folio_lru_gen(const struct folio *folio)
>
> *const ?

Right. Added for next revision.

