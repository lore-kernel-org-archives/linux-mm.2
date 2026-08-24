Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD63C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FA06B0099; Mon, 24 Aug 2026 03:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F796B009B; Mon, 24 Aug 2026 03:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45EF6B009D; Mon, 24 Aug 2026 03:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A24466B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:27:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34C94A36DE
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:27:54 +0000 (UTC)
X-FDA: 85135333668.07.2FCC248
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 827A1140003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:27:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LisqMsMw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787556472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDmng5bNiE+YiLBp1dwqj9DRhmUVXQIS/lif+VRO/fE=;
	b=2LprtogPVzpXOfkv8+cT/2VFhfujW5luUIRrUl3JkItCnoMS/dadIRyEUgQkKuIm3aqh4f
	u9Jl59QieBTQHA/WmOTRA2uF1a9e75YnOOnJDhKfKci9xo7N4QjG58HNrL19JcGwu/JUlJ
	tW2PWkNw0P/3uah0yEHYRd/1m5P2jeA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LisqMsMw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787556472;
	b=hz21UtwXxxdy/mqgjeOFi3A+866BLgvZmG3tgI+xtqj7w9G1qF64cNwz3MwrOSJq71+WQA
	3LJ7LRj9dMRCfGYfSgoNk6eR5psysTI6rhAnXNx3DtHcvBJFTxRUHq64dOx4XBV0Wnm1il
	UruweNn1+Imd0eC61nz08n5TZ1DIYJE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1173E600AD;
	Mon, 24 Aug 2026 07:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AFC1F00A3A;
	Mon, 24 Aug 2026 07:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787556471;
	bh=TDmng5bNiE+YiLBp1dwqj9DRhmUVXQIS/lif+VRO/fE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=LisqMsMwto/kBuZ7gdbcgEJrUKMCvB31iYajSaP8VSdLEt16BVkX4Oh7MmltHH6/x
	 lgJMQ/bHIDKxJx2zSKHsCi53faclUGyXrEjtwgO9HglPDbBjmzSGM601uHETfiupKK
	 k9L2jhdovk2XzuRexJe8lI2Ja3+L6F1zhgtZeR57y04iBM9ZTxAg8R4/0hzvBRU/1n
	 j/yQ64IOrcqDTuW2xREKaopx2MCLiJJbnIajCPVW+gYaQ/oYq0qHnMHsDEPBeQlGIk
	 UAUiHCdZACNNtFoUCqb60H6mqsfCFPiGb92umTHv0AOcuZ/mH0PdZQm1D5ksQY3O+D
	 A0IEUUHfnBZfg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC V3 1/8] mm: Make ptrval_to_str() generally available
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, 
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>
In-Reply-To: <20260818040041.1891769-2-anshuman.khandual@arm.com>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
 <20260818040041.1891769-2-anshuman.khandual@arm.com>
Date: Mon, 24 Aug 2026 10:27:34 +0300
Message-Id: <178755645423.3606540.12945780031100652573.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: hscxtzd1351w5c16xfcy1et94i4xm65g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 827A1140003
X-HE-Tag: 1787556472-351292
X-HE-Meta: U2FsdGVkX1/kpc4BreZrm87fwLYZGcLs567md7QEn7ZbPicGO6cZZI9ZyQaL/0tdNH6/RPqQKly1uXqU3m6SUW9EIfaR3HpKrawjLQF/V8S7Jf6BAJ/1pqEdkRPpr6uGIoZ2t7PwYMM3kgsQx2fuLi0isBLXSOFbiRwFz+jMs2U32XURM7Jw77lKCMGOGyQldZMahNCyUW8C+rvMb0dV2b1GJPjcWNrUBaIdulWxH7KIUUpQ3OL+NU38JQPI4DJmmhPdDtRiO75J3hNXtoG4XGMRQXWaQ8r+O/xMNxWO9qWQ4/DoaRoBfEjJFe7Ah/S6OhFnnZz8alZSooedIx2nkeFYCESCD48pjtNKI2JmZD3H7ICV1siTOqh5jigary/LbbaeoqkKeFHw6Fuf03KS2ZER2C80c7GDkJL4DVRmZL5LhpmF0BDqsHGQNq7YZAb6N4aLL1B/hZVZotqDe4qyGh39j4plUVIJGPEmiDVoa+qtnDBeCWQbGUqQYGD1aOL4LRfU7C33So1GNd4Dl3bEgrNZmvQA1sNO/OSQ5yEi8q1/u9SyJjAKLgY00WHDqOVv0zs7iW3wYqFuuG+6VB69kUlYVvYjgD5j1bk6NSh2zESbH6rRpL55qHzC9G9fID8BHIe2QGoYyFHK2OV+6bP3aq2dwElWiO4807XcKqeakckV1j+c8C4NyKTUhh64N5JLSV6T3FeVlHoqPSSyo/VZuxjEPzuL1eHJBpXScC3NjuV0o5BKjmPUSMcwgtP9KI2goKt4DT8QsZwfrR8GPq/Te+ke+IZOMuCE3tB+uvtorbSDeBlnvwsyMtsIwBeqa3dgd5YkZWfE/GxW8+PjwAFWZcZxehs9osbxP+knH8p/5EMqFYL9o1QO6qB5BAKRHycY9aNK0OBtSSqa+h7A+7ZezBM1HU5RWvlc5fzoaou3leGAKN/IOXlZ6v6qrhZeXJJA+0IPR+hWJAHC0q0oxNX
 2xNwbN8f
 ENslsVzpjy+qMmWYXIkL56JtISg9/V2+SvH2C8vGqzcMnstimXU+S1ribkfFr/3IXppYw7TkfuL+i5s43C2sfyNvv31ogS4ZEhk9gqgUzlU+pA0TLMi9Hs7m4rVZ/2TPNMA4znU3Lrd7xyAWJtGlmNqPpwnXWnlCR1Jeg+C2qSIA+jj13Qyw+fGoP1g23cws54z5mY7QFTKtLdiyYgV9XB2cuC6mZf6rhKH4F9T1QcrpOWZbfoQO9zYCaQetkz/utz/oyAvCjkCxzUhqAaedWPzAx1CoXy1S6GIUxOoVnaEVmjypxzduo2EHVE98+j9DJNYLqt+1E7Xph46I7ghLmum5Sf0VikdysDwJ0I2Hlli6yclWo2qjpJkLYF9p4akcS4aPz5UGVp9wiF0iNhgmzSR4Lmbygx6gkBb/OnZ0B/Wlu6aGCf+ZBEjW+Hjk+KnqaCAqX4PmCc4ZmdGvb63ZqYm7MbClhukFH1lfFc3PUvohJF6VE/CxwYwS6xxf3QoL/q+GNWxSVZvnAJiJK9YWevcbFo0FImn42X91N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Move ptrval_to_str() inside a header thus making the helper more generally
> available for new users which are being added later. While here, also move
> another related string size macro PTVAL_STR_MAX inside the header as well.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

I agree with David, include/linux/pgtable.h is better.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


