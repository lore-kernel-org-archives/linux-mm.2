Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BDA9D41C02
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3302F6B0005; Thu, 11 Dec 2025 03:11:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E09B6B0007; Thu, 11 Dec 2025 03:11:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F66C6B0008; Thu, 11 Dec 2025 03:11:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC1A6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:11:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A896C083B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:11:23 +0000 (UTC)
X-FDA: 84206470446.06.001CFA4
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 914D5C0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:11:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=Gu6ZW5oV;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf28.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765440681; a=rsa-sha256;
	cv=none;
	b=LT5KXP9dvaCnL5X4U1cg9jgehG599BE4jM/XyhUxxLwS8OjSzCwhhpAIzYwNFQqyiW9v3U
	rPZlt5bVcta7N1a5PX2UqPcpYyqpDzfa66IkK6XtSR8kEPVlmS0FodOI58eApJBIxjM2fY
	IrebDnT/Nfl6n0iPMUKY05fsBs8wHy0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=Gu6ZW5oV;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf28.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765440681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J7hgCetQRqwLzuw1G17bsIthDhB5FCYZJSHHZ0nd+sA=;
	b=cnvY4FQcctvLMqL+VIy452/6SbAN+8yjJO1nldelkTjqrOpEEo83h9Yw5zV8iMyySA6pkV
	qeC8M0PaQZ2CnkwZaX6tR4syJGl7eR1eFsxVosNRKXWkm9ynZ63aM+A11BJ6n2IuDNRFSW
	nJZGxNL2BQmOXnhsHFrhnE7lIlyqgI4=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c03e8ac1da3so628622a12.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1765440680; x=1766045480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J7hgCetQRqwLzuw1G17bsIthDhB5FCYZJSHHZ0nd+sA=;
        b=Gu6ZW5oV5DEVqrQFN/dHCOGMzncQaHRgrqybnXlKfM36HjDD66VCChY256aRVjWP6F
         4MLjniHLunYGILkuWvhb9yCO41A3MH4gGJeq2giQHEpc3qZ6TQBrm0ij2IRxIGX4NsQX
         XqIEy69vcNP//hhyAc7VRUwNewPYEwzhwzP91vHMS9/3xQefbCIybfRpYZT6sZaKPASn
         7wyCuWWFOdBmhIQOxFWaICUaV2h65ydYqobKo/iQir55sWIMgyxLSQEJnq0htJPem0dz
         RnPHCP8snyJY5LbVXf9QEWOsUrKWFQhjhvR97gngkKeW1iZmawy4wqBtEBK+WWrIptC1
         sDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765440680; x=1766045480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J7hgCetQRqwLzuw1G17bsIthDhB5FCYZJSHHZ0nd+sA=;
        b=t3YdmooYyEO5LBbEtbmmbQnN1L6f68eEkqy8I1ATMFjo4QeTGGENJwCXDQQGWTVaq/
         HiO8J/rasf4fQNYJ6EUy7hzDh/Crh2AaGu/vMnydGJrK84GhFUuBXdEOt88MeHagWW2m
         N6UIzh1ZehKJh3hWxjP+6ZnA19Wj6cKlSSCPAc9cPjKKb5OHRcJufQOdmcAKhrKQirUc
         6otohsnPrvRujUm/aaDC0nFB0+/McInWeqnN588w49Ef6+iDorNoFv1iS9/fJRIbrE/W
         hMrsp5xQUEGOjt97pFVjyAB3OdD2fEK7auOaBcwGkFDCchdFKvg22nsPS4paUajK+xjJ
         refg==
X-Forwarded-Encrypted: i=1; AJvYcCUSpiqdLPrmsaCyAf2qPrHtuvXiOWGNTENC6L8uovAiDe8ybFv3NbX2mNbZ1mMWfrpZIKKUyPh2YQ==@kvack.org
X-Gm-Message-State: AOJu0YxpCZyE3jkanc9BUXncuMNPdzFpqTomBnH7sbx4sL/twQg6yk4l
	w3G2saUHiE34KArPaiJL4n7fL8NiVeUwRM3aM7D5LsFn5/Enad2ZGmuv+Ol+fFkHObc=
X-Gm-Gg: AY/fxX5yPL7uoTEVOCN+lh8EWv4pTczmM+vxkFyeMlZPt2+PYU9fXqU76kMuYH4P39e
	wV1vRhGatqLtwQbvHPRS1woM1NdYkPa5i/RIH/Y/DrWLotWvhLzAXr/1i+djcFq0E/NXa94kkh2
	zYwpCzkZiCz0VrKJF0Alco47EbFiwKwdw6Frm6vt7kajexOkA0erXc1h4hdFFLdAxpHzrfCeqAa
	T9N8EpP/c+WLvfsNpsmzzCwXqGOe+HbnIEdFmo94yfA+E8tRZDgrsc4aElgCHV7baESaT2wIiSG
	HQMwD8+1YtOypePdzMlPbWPq/KdqmQnx+YyrmRvDBFgK5s7uMOwSj/xKLoP2zwKfkOilBE4R3N6
	2aw43o3wKK2Ynhu95jcCXxoQb63+XntDKab0s3sD8FmWZttrCBTVFwshJtxWYsVdyCKTMqQ8BDI
	airBMu6x1U5F+QRW0/xVlYZw57hAvmN4ry
X-Google-Smtp-Source: AGHT+IFM+gm+gG5GgxkbUCg1FcdRjiia6gi0E826vfXfotSAQ32Epzqu9WXY3/hKrr7wAk6Zl+XlMQ==
X-Received: by 2002:a05:7301:1c9c:b0:2a4:51f8:4a6f with SMTP id 5a478bee46e88-2ac05580433mr2585893eec.37.1765440680245;
        Thu, 11 Dec 2025 00:11:20 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ac191e1eabsm3914759eec.4.2025.12.11.00.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 00:11:19 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH 0/2] mm: Always use set_pXX() helpers to write page tables
Date: Thu, 11 Dec 2025 00:11:10 -0800
Message-ID: <20251211081117.1126521-1-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 914D5C0007
X-Rspamd-Server: rspam10
X-Stat-Signature: 6nyzrusjm594xgqhnznhdbpiakmy6cy6
X-HE-Tag: 1765440681-66176
X-HE-Meta: U2FsdGVkX1+osp2EyeYArOvYvvkjR6xHvGGERiSVH9KemZoryCPriqSW8u6PxPpD3IarHDBgMQdOUfv7MF2LoA4FkKSC8c0YaBSmtpNj9GgdbQZlTfk0IEfBb+WC4qpO5mAT8C80I7mHZVQYUfVQfp+KQTaKYH+GTppHpDtyOVZLdIyeKD0qW/lB3RW+oSR0OERyc0grsK2dkxtliImd+1i068Av2ZZq6ilSsDQzIXJ+UUL7ESTj0bzqbY7gKpkD3RWx6oS8+pd5aKrCRsdeYD0+tou4O97GgOvqYki7tg6dt6wVEqKG5mpBjslxA5yUKNlk3tTJVVXM4fWuVCChrMFda09DciZtzoUifEkBUmQ3eZD2kOoXsIVgfMDY4uwxZK7cSELIfuOeIzh8V219W7yAwjRxmaWOs71F6sK+ADtAOsTSsiKDdzYjWwz7JacYsUXpeQcTOKMmP7bAg6dsTXZERlcFvOzVlPihaI2FM65ch2bKrRfbi+GNm8VcSWeZxAVlfDQTrIMfaLBTZB/ZYkLehX9eMN53jEWaXm0/RW5LOzYtQHBY2wkK+PouE+p9CMqoqsKh+9RSIjLkiNx0oWGkFkqiBh5At80E2XoGozPDNmtF/6WkToSGEk47FkQJS5ZA3dFmyKEw2Hb7juRfOsDdQ9o/JLQbtIGlEcopO+cVG4h0MbQfkLNm2U0hvPu2Yv4KaUazrDgxFFxXC2y5X0xg3yRanpH7cRANtV3qGVV+rY+s/WQqRBLNL/S7q3yQdIZzUoHvdz1cyrt6l9xZ9RYw9FUHVQ1Cs0JSD47xdP6/TPYLJj+KJ0yJFV9VlN3mugj4ojTOw/sru7xDt6KtgXu7H+7yk8MziXE1pnJNseYvyES/o8/lWMnnrlYjC6vB4skXLfAoPHqaawXClkd5u8A2gZyr8Di8zBvmkZcyb3QJrpKuH/dDtF50sNhYwMTdTZ8F/UwJNOyr9gS7rWP
 H5Ewxe2L
 7rt9dmy2xGuMoHAvvyObKcMeQfTDHRZq5Asq3G4UmP7XzvsgqUpgKyeSum4AhVqWmo4Rl0GR6AAxSS6ZU26g7bkWNrFevYPw/oBI1qmRCqdb397/+gX74DM6B2VM8P+LqsViz1y2vri+tuddFgfz67cApepf/Pk26ogHi6aNj5heoHbglXCKlT6y39WVGM7/qO61E8FKrYnnAx6toTpCV84GZpv/28M69JaH63O3fSmXEJpDDn3505GZG6+q5p14b90Z3FVFzOwvT/EBzwejPA3rs8mF9SEuc+1EGZsktpmwdoCUO7MoJWaYyICbv5cvb4UoNR30uOPYAxg5LJk/b03J1ghAtuJtijgngkNeFhq0EmRumNJfaaF5odlbB0NRPVMg4YTc7Ci9NKF7MJ4piq5hmep0yT+uAhhAYhfuE25xx36hLL1Hk4ldXLn3M6iXiFYKTMtWKQz8XsZQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As Ryan Roberts points out[1], when writing page tables, generic mm code
should already be using the architecture-provided helper functions.
This series includes fixes for the few instances where we didn't do
that, as found by my coccinelle script[2].

[1]: https://lore.kernel.org/linux-mm/02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com/
[2]: https://lore.kernel.org/linux-mm/20251113014656.2605447-7-samuel.holland@sifive.com/


Samuel Holland (2):
  mm/debug_vm_pgtable: Use set_pXd() to write page tables
  mm/madvise: Use set_pte() to write page tables

 mm/debug_vm_pgtable.c | 4 ++--
 mm/madvise.c          | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.47.2

base-commit: d358e5254674b70f34c847715ca509e46eb81e6f
branch: up/fix-pte-madvise

