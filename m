Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15B9DCCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 21:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453068E0011; Tue, 21 Oct 2025 17:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403448E0002; Tue, 21 Oct 2025 17:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2FB8E0011; Tue, 21 Oct 2025 17:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 191818E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:22:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC85148829
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:22:19 +0000 (UTC)
X-FDA: 84023394798.01.6A06FBA
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 17B0FC0006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:22:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZCkQ92NA;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761081738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=cXIFDeQWnub4h2NG/T1RFeyMBXuEyOQzNVu9o94NDmM=;
	b=wvi2W3r/FDBi5dJXaH1TT/+Fy1mWk8gpdDqE9FpCrx+1nhEbtgoiiNSeVxCOYIpJBaTyii
	Oc9FEZzHFH6ds9qsHm5FFXP/E3ZytQ5nORJGTQYSMFaInrQJGFtTwXioLnKTUR+JR+XOtw
	oDDhkhbaeX88/NDCRIn5O9FP+uMfNUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761081738; a=rsa-sha256;
	cv=none;
	b=7xeue/Fsv9ZPsAYP4HgsnvPqEOdnb6Ckcu0zEYqKrLy+0XgKns0ayelWLdi5oAGRqBl9WT
	fFK1N1cRk/w0mdV+t6xOJOp16TwpeSglTCRVJ0A/EGe4r+59/H7GsbwyQAS6Llz7gu+HEV
	xkAmJYqoFGOWz0Z8QPMTfTxneBycmyI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZCkQ92NA;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b5e19810703so992837466b.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761081736; x=1761686536; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXIFDeQWnub4h2NG/T1RFeyMBXuEyOQzNVu9o94NDmM=;
        b=ZCkQ92NA1j8e/qKhTVqw1PQfxOL28PIm/k10xrOIs4etIe74xkcogI+1T6D89LtpgE
         ugFOpRKKWTAMsKxCJdXJm6eBaa4B9HifOABCtDy3bmpDvrCL7dO1VleVgrcIxwpyZtbV
         NDdbjpIJmqAy3LqJEm1vn34aerk0WwtkdxdYQp9rk1HfctXTRnQZGRC+j3VWlbwt2YG+
         ZoH/kly4CE5BuwPTh7r04LEHyYJhLhRn7iLovHuku9VxzXrhp3Em/U0Qjv8D1l+xytjp
         HgOcfV85oWnZBR3eBlFQzevIZTT953rULRZltyZxrMKbMoMc2HVnPk3/Q0KZC0Pncq3i
         Mgkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761081736; x=1761686536;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cXIFDeQWnub4h2NG/T1RFeyMBXuEyOQzNVu9o94NDmM=;
        b=jI3dkv7JISdgDBvwdUg2VHn2+92L8SSkodSjcYhGVMEDkQBEhvD7Wg30CTMczc8CwG
         T575y+pdsiH8y0LqsHL0q1giHq/2WNE45kChQNX9qBDKlG5BBD+aoTCKY9LIcfQLBIQO
         hsr/bh8nap9aZmBhg7zai+LuxMhMLcepQFcHy3yNZQZcVrUn0J5scCHoe+EhnlRW8u3o
         GnY2SUOsZP/OXacvmTYZ+m9qJy3iuRjBRbAPILGlDo3u0lhvC7EcQOHJ/1Tskf1FMAEt
         xgNOlOXQlBgocV/B3BN9WBBFQW0PZkUV0AuGiPjAQ1V9qLPYiiqKAv3OpiIGPVmdbRBe
         wYsQ==
X-Gm-Message-State: AOJu0YxoHE+9q/f5riRLJ5laOtPoSQV6dFKRr7xZMX0i7cxJc1iuiyRT
	XMD/XwSiplHYW62oww4qEGi2TFB/CDK075mWBejZ7dGeoQVZwtrG2F8z
X-Gm-Gg: ASbGnctDYYlBYkOUpvTwupEsE+duLIqPgKJid5NmfbZO7koWJbkAF3e3JChOA1Q/hhf
	e5yyqhrCiUL+qfcCbv1CCslpNm0mOghWpmugw4anBleZoS52N84Q/tlN25cpvgKD7IZPm03arTa
	yUpoqvJToir/uRDq6yEfKIZ0QYz+cV3WD7vr4Wg/oM+2yFD/TZWO6ElSUwMSIWromgh5gsQK5e3
	utYAvXdrZcJ1X+DtzBwylOReCpAL0AdjBwimNkP/iIwCo+RRTWBEegShufgC9b1T7+aXV4VRJx3
	823vRnxyPI3IWoB2BUKDhLw/V3+k2t657ChCA5hpCVjGTTmhZjENKpJk3YOf93m4IBjGbyXI9Nz
	5vzbExdN519xx3fEL3Cm64qsL8mC3OgMSOTBP8oTgi0fxcFENAMwEDyYkjfnhFLmY5AZ9xgUzkx
	I=
X-Google-Smtp-Source: AGHT+IFPA4frdNInE08OEPmGZi6SHjKdqmYchzpTtJev6eBcMNQJIE0dQVOY8/iPEshvEv7GoHvMQg==
X-Received: by 2002:a17:907:7fa5:b0:b2d:a873:3a4 with SMTP id a640c23a62f3a-b647254f787mr2213891266b.2.1761081736226;
        Tue, 21 Oct 2025 14:22:16 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65e83914d0sm1154829266b.21.2025.10.21.14.22.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Oct 2025 14:22:15 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v3 0/4] mm/huge_memory: cleanup __split_unmapped_folio()
Date: Tue, 21 Oct 2025 21:21:38 +0000
Message-Id: <20251021212142.25766-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam05
X-Stat-Signature: chr6h8fw3n1g5ukxpcfrq6c6otnjt8ac
X-Rspam-User: 
X-Rspamd-Queue-Id: 17B0FC0006
X-HE-Tag: 1761081737-481961
X-HE-Meta: U2FsdGVkX19Gyz+B+Fq0nYU7MebzlURaJVUBe3/4qEBQO6uU/9rWYXSiGB+q2JImf1B0gGDv9xarAi61qMZZlhF1NpkEEvFQNZyKDEHvb4iDYhSU46ct/iqRiY1h8nakwOcqZ7Ip1GoPMTz1SY6d5ctmYH1EOoypA1f/LPMYIQQWIgiaDk3HtFdLXNo0flY3mCHlnmRr2BH+akO4pgvFVV7Vd69deYMItImhWNtvlkqkZVEMyqPBkO9YdFOt7NWJtrfXFskgsR4GfliqY/G6XVrj8fAKjBOxG3EmjlYniKehCOFeVZiCOjz1Ypd/7tTECSk4Va5K1+WfD5098JSv+4lzzGH7yaANnlk7iyD4XT9OXTD4GDYQkQOeVmQ0kkgd7aaW0QkchNkHBU2SZ9LYu7JP8kkbt9/X98bpyfATSxcJmMjlkI0bfMFRkYVSTH4z5GzcSYNFk9nLijLU7nOU/8hUNdSKD634XLsVGMJTVbc6mV9zKIp/pPkLgZ9/lKlrstfm6PmMwWI6vzjuHKqPqeReioDOk+M96/ZlHYcytpjWcSn25GJ4qxR0FT4+TWcubDRVY7ZklEecag/El+ps0QftcMynflXLBZvl0HCnhs495v05NLgf8LXOyrTBUBrOeRBcsbdbI/aedyLg6L/PPYf0tFLi2WX5z0fUAHn9rbTihHaFDtsHb/UkxF7oaA46gYH2sjqpcOG3BsHQfTgfjtu+VWzlHRw/8FInwKUJtTmU3ocTSCklksTmpW/cPXsoEwz60axhe+YzClQrWRhDjUdYBxCgpShXCeeU//jSHhRJVo81Z5/KukD/LmfQZ+mndYEVWCb9vhnKYAJ+5qCGIZWYJf7em/r++BPrS8qZ4GWY3bOiFD+x0f0KyjqESYYxshgEYgG7ebI2MmfZvlzxJ7x2i+s3TeNzQk51lwoi9MH9F2mSi0m1i6oMlcWz4TwZz9H/C2WrzDLEfHZVge/
 NvJNtWW4
 LWWVNjCmtvdqO/sU4EVmHecL6CPi23xKEYfGtvzZg+UayqFC9vuLpGjPAJtCUb8gHt7D8cJGaKKRi53J5xKTiKMnXe9sRPhScFpeeEuYGJ5ZVT0RtCzjAyvog1idelqgdZJW+2uLYC/gOxk9Kux3N6jBYV1+QuMtgHrvFmE+F7+379XBhzTGbIYoepjz5n1fbovZ4wJMePVtt7sozL3Y6KtobnQ+OeUB8X0pyUD6lCHzjGTFJv2rQGUlBU8NScJpi1Nk6z9vhvNGqYB0cVSapn5KQ0RCGkvWKCzL1JSQOTMs7Ung4KFqQWiFB/GeyAwyuF0AFrNGBY2BhUmn6vvJ4MqnqoEW6Cayohv68F9lDvH0hMyFCNPVs1sQW+eUOtmh4RoUootWGKac+bsBgmkd4UB6q0nYNRLLhMsmUoJbTNvec4FJ0gj38Y6W2ynVHpxWkOxEpHg+8XB1pikkFlvGxunM0a/C6A1nYC7RFMDr9zoaz3q3mUiWn0j1B9aMnvHCCCxCxriqpNAFEOEAliWhLeVMN2UdUbVNdXLRVKbyPdeTBO+lqYiq8WU1+9/159e6jCu4kHuhvpkHbTiXFQIoJzlrpKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This short patch series cleans up and optimizes the internal logic of
the __split_unmapped_folio() function.

The goal is to improve clarity and efficiency by eliminating redundant
checks, caching stable attribute values, and simplifying the iteration
logic used for updating folio statistics.

These changes make the code easier to follow and maintain.

The split_huge_page_test selftest pass.

v3:
  * only merge 4&5 in v1
  * refine the comment

v2:
  * merge patch 2-5
  * http://lkml.kernel.org/r/20251016004613.514-1-richard.weiyang@gmail.com

v1:
  * http://lkml.kernel.org/r/20251014134606.22543-1-richard.weiyang@gmail.com

Wei Yang (4):
  mm/huge_memory: avoid reinvoking folio_test_anon()
  mm/huge_memory: update folio stat after successful split
  mm/huge_memory: optimize and simplify folio stat update after split
  mm/huge_memory: optimize old_order derivation during folio splitting

 mm/huge_memory.c | 70 +++++++++++++++---------------------------------
 1 file changed, 21 insertions(+), 49 deletions(-)

-- 
2.34.1


