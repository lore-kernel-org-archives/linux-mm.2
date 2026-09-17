Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1C5C982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 12:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F86C6B0092; Thu, 17 Sep 2026 08:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A91E6B0093; Thu, 17 Sep 2026 08:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1975B6B0095; Thu, 17 Sep 2026 08:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE6106B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:26:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C6A9C0317
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:26:57 +0000 (UTC)
X-FDA: 85223178474.23.026BD1E
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf23.hostedemail.com (Postfix) with ESMTP id 48FA614000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:26:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y c0v/qp";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ALN8pvoY;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789648015;
	b=I/YFY02nXe6GtLvjjHb26IOiqxkyBITonmvGSpGlHzrOjORBAhJ25li6FhrRv+j+QnYxVv
	oDTNpFXzm9rCkMiOnpxSq1eHGwK7ZHRD4ubzyp2by/7jvZvfZa+Ph52WFeUQB5yZw5EsXN
	5s0mpojMyszDFOXi2T+Eu2u9TwfaKkw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y c0v/qp";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ALN8pvoY;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789648015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lyJ8zqBoEOycT5nzPuEdvgCgVgM2x5/iPvVMuCaVJY=;
	b=6PFA6SVsEHCc8iHyw/GDecQ/4Kv9fRYQn21vRWzy6oZ0D73P/XWhrit49Nr2RVTrhsL5YU
	rlm2CovvWK8oVbcif57MJ7/Rwe1/AhiYprTysVtIjWmWnUBf7qsDIZy4uf6IweevHyZbd0
	Jay230A72YBtYnPd8WF3c0nUdGNQ9Cg=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id BCC361D00019;
	Thu, 17 Sep 2026 08:26:53 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 17 Sep 2026 08:26:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789648013; x=
	1789734413; bh=0lyJ8zqBoEOycT5nzPuEdvgCgVgM2x5/iPvVMuCaVJY=; b=Y
	c0v/qpweF+XkmUFfjS8UkDWrnJbtI7+FEdnJLT3S6mGvvyPZAEo7YZEANPn/fq+z
	O28S+HKUZjjWNqF3JwyhyJKKwbAxIle1lxw4rL/ZKjmqB+STh1vy2CUi42FX9BTy
	2L6HzF/M3WO24FuaQSUvE7d4HBWgbPEAy7wiVYsQLtJN7N71jXNoH2SDo1Rj6PM+
	mCXnie2NZoYz6n4JNbQpXMo77/dUrBBMO6Ud/dnxAFR8Wm5roLQFV/e4eviOXTRS
	q1+Ot8g4fSKXPZa8EIr1u+2hsQEH71EEsYambYO4Mwtqk/yPo4AAa6Wj46r9lAIO
	Ql6QQGI3e6iBlSNX+eCDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789648013; x=1789734413; bh=0lyJ8zqBoEOycT5nzPuEdvgCgVgM2x5/iPv
	VMuCaVJY=; b=ALN8pvoYJsRMNe433abxYc6n5sOtCrv4CBuFxOaMJKsyCjQfJdG
	QiKair/ubRVxfFl7+g0c6w7OWwEES5gjDl8qJbpOLcAm86RycrEEMwoDSaO143Mo
	ObpVVDA9qTYYLde/gyWvs+THbAH6YP7OBl0F1mqZjRx2CAym3NhM8y+6GBAhHdqA
	BGQZoLFmqRQ0i4fHeP9HNmF4uyOfuq5hI2+JKWrLPPT91uUPw+doU3Jsk/t4iNLr
	fS0cgiw2aWzjPbGI1NIUfOiIpJRogfrB2GEAUc9WMser4WZwLiI8LU9rZMsMMGNw
	9GMRSay8jiALrXKBZmMugPxuuAGU0ViB22A==
X-ME-Sender: <xms:jdyrakRoZI92Tp6sc8CLBoOhDnwe92mamuZmAB2XALyp9poloaoEcg>
    <xme:jdyravY3vadlYzNchPVd6w2zwZN9SUoC6gRe5tigCjmSxumI_2I9y8ArRgihc-tyd
    jipFsucr9hpRfDfrWmZJoJF4NPuZ1WTUMCEktmeu2MlwfA2YYpRwGFS>
X-ME-Received: <xmr:jdyrapNp2CUcfXxLANiniFIsJ7Ev3t6Wmil50whE255GfTZlYG3lp44Ghyg>
X-ME-Proxy-Cause: dmFkZTGIiRiuQ5PMdB2WYxmL16h5CDXoi1BFdRa7lEVtBzpOMWHvb9A4/pu05WY++SyB+h
    qExORmtkwcpdpBx8kTLTdD2wg0WhATVYsrhgOD5W+6ELkRdhoGJssibkTiIJKtVXEjtk7A
    abZuYwWU65Tb9ms4R2+ualLkQ9DW57htukuLgBJ1T3SoWy8/WQzkTiBwuJv5n84UkwNxs5
    M3SXhPj97KF9C7Fzth0o/d9Mv0/WeFzA4nIgaD/nn4wtzFBm6/B82Nx8Qb5vXsDuOk0wnJ
    okZKZfIrf3eyA3N1pS9qk8io4H+hh41gcNmq+1pesqMZ+KVqRTIiVkArDwfY3zihPAo/cp
    shq6EuhFEI+p78q5WfCrVdjXX6r/GfGohjsYha8rR2ghFknr8HzMI20hLV4AkFwzXcCotj
    oDEh8kOdZ9V/fG5MToWJIhktomfB0yGIF0rLqhGX9hRLmte0KUdjqZ/sq2eRmnIvgwd+KQ
    FrwwLRffN7dh8onZo2ufvtN0LasncW4XM/AACBKhjhzhGOZiMZQdQ5iC0BNOarm5fckdIB
    +LXF4HO8ZzS97Ze5a+Vdw+vlJ15cERKPbcfCKPScZcVuarkG6laBE0ODrtaNV+js+SwXxA
    Un+vN6ZcLtrhw/FhRk9d11voZB7nEz9UWPp38Xrpc1HK+2NU2L28Xqm5SYww
X-ME-Proxy: <xmx:jdyragPSqitgC1MlxnXpN6bbVDo49IBbMen0y8FE8q9LkTXAAE-4Hw>
    <xmx:jdyralPVFU_zzhXlw1oGsEuxEX3vmI98H7BAL7mN0tHGvMdCDw4zVA>
    <xmx:jdyrakbnB9DM8HUjWyVvDaDbfkEeDiKaB8g4V_03s5FkbAFTiHll9w>
    <xmx:jdyrarinjKDK4oeu8C-8eC1662fFcY_Idh8x26i2DejmRWtNbbn1vg>
    <xmx:jdyraqhwaZ0ZEZMIr5H9bj7ikmZa54srOOa3YA6BcW051TM7hTWYIZ-F>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Sep 2026 08:26:52 -0400 (EDT)
Date: Thu, 17 Sep 2026 13:26:51 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 00/12] mm/collapse: separate a collapse from its
 callers
Message-ID: <aqvcElQxmtysJwbA@thinkstation>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916154826.a55591eec86b5514dab898ca@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916154826.a55591eec86b5514dab898ca@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 48FA614000B
X-Stat-Signature: acmpexmyzk5py4y3f3atb95hspuq48g1
X-HE-Tag: 1789648015-806389
X-HE-Meta: U2FsdGVkX1/9DYcAq7n2KFyS/kW8NOy/LX1LlgR9Au8Bb0ocajJnwxVbQmWvSS0cvqzwjB9EOI/hDPsLAotC6RdZ/bZBFxpH7MMgTC9LdLrbyyNwp2Ah0/t/2FSad9lPrEQTTuhMlBiAgaAJ0xAeFM4NkIDqdFzc4wmT8GDmUIbYFkM10+LEwKp+aoHR6w/RYSllssXvBkHZp/B6OxGvpxJOFMmKjdWWldtmlIzpLxV+0OcC4rHpq/AqJupb1WkQx5qiPCI2eHIkkBnCa2ofxjyt4E3V5xON4VBM0X10QIWeQiCBmyz3ALPPI4YgHXm1o3bxDuHTy6+eOsIWbqAQk0mEUxjwlBfrJreHQEyHImlaJ3qsK2uqUwfSCkQtsJGBua0OBw9XtE1OzSNp1Et9Mv7VZYoppr4tDShCdXIWmljtb/kSMUOHKU9FGCbhA0m6j22AqL5JrhShZQqtOaXS7Zq6NJC9OuE6Wifa72fRS+u5qpA3j7l9dbO9cBEdUpHPCXiLrYFWNB+rY9zF4FN+X0E0Pe4eyVq217qfMDaYo4IumI4seKEBFeO5eXGTEB/73KOcIdFzVBfqmWrvcj3hBkC2QDxcAETviH2nhyb47jRcx0WiaZesGL6vYxYtOszEdiOD5kNmkDulPcpf4wTzT44cEXp6ebZ0kTjCbPPnlSSDkpvug0BTCFnLmBVjRkzlmc+exJ7JRplePU9s7gzuYLqChFmLutNsCgbwoBBbZm8Y8RqrCbOrgyztUNxC+bEBtJGubn8xJZryTnWUH3ZMP+wdcWyuMtm1qBbnHYYQjr1FTcolGungx3RLhPfZliqbczjSRdBxoxYzjNYvGX9DULT6PTGK/ijjix5Uj9k6+VtoNBgkJSmwPbcUvobpYIVq5GMC/uy+yewEetE+3qsRZTHg7DeA2f4f7dwzmuZR4lsovBdHoZh8zJF5xGWCsfYy5ogqG1PcIMkKcKzoX0a
 5bPoD+uT
 Cirx+L8Dcbbg1VQMl5mHrpSGFs+p+8EyjvSA/1ZBy0KbEuRPRgDL7jsnHlPRiSfV8Mr3tM1osWGUNwSUmnglLi4lyz97VBPPAlZdM+os7DdlvUoU8V/RbCUYmOfY1QAUVUNovu/5dxzQuhUFpKExk5QDVWGxMzV5qrDI7ph0UfdhtgSVYK64XGjJp+8UY6P7f4zAJ1Jz0tCZ0viHKx1Qp2tkkmem/lP/W7FFUnvSF6Ttu2RPNw6coyWO6dQqDfS9BtAX2z3WW8sDySpQW9TFCmCWHMH4CVC7R9nKv/3E8FuSzBAiCZahOeY3OXOKxGvAihfgZAl/hShT2+KZMmvNgKQA8mh0PeTTjRv+lSRWQld6S7nL/beH4I6SSIyyrcxwtcj43xKQLntEY9pxU4F1TgMPZwZGZ6JxO4PxjdXk0n0iMbpYLfLBijXS/VIatLun8p7kp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 03:48:26PM -0700, Andrew Morton wrote:
> Here's how v3 altered mm.git:

BTW, is it helpful to append a range-diff to the cover letter on a new
revision of a patchset? I can do it in the future if it is useful.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

