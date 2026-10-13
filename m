Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D7DCA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAAE96B008A; Tue, 13 Oct 2026 06:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5CE46B008C; Tue, 13 Oct 2026 06:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B991F6B0092; Tue, 13 Oct 2026 06:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99B9A6B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:33:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04394120A08
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:33:25 +0000 (UTC)
X-FDA: 85317241212.14.F65A1EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5E4F6100005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:33:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKHPTuBm;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791887604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFfNmiQ8uFdg5KDWX8jozlYpSU9VWRxyP54Yxnv2AEI=;
	b=vzfRlBnwPwyNQP9dtc+4eNU1ARPpXjzPMh0AjOqNChbRMOAadOfUTstS2EqV9SVkrVpQ2z
	vscA3bLGx534a+mKRnNkQ1gxlrT0TabW0bvGqVyO6CFMl4V2k5aP2Vlu8MH7NfDabo/JNw
	WBMjt4dzmOkP126B40aL5I3jxA+5kdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791887604;
	b=OGz5HjjT2nLBL3OUAUlc7cxCIIlPlgFaI78O5p8Y7M5MtR54p/KF8ONvMLqNUu0AQT+ZKX
	gXCcsHE0i/Ls0llHX63oJGL3U+6fOpcL8Z/S69f4scyst9AuIR01LTZQDiWMmNy62qiQ6n
	LFUhKn0gcaZOtqEo7u4qm9nGZ1Pb+fI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jKHPTuBm;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9206F40E26;
	Tue, 13 Oct 2026 10:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCF01F000FF;
	Tue, 13 Oct 2026 10:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791887603;
	bh=UFfNmiQ8uFdg5KDWX8jozlYpSU9VWRxyP54Yxnv2AEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jKHPTuBmLFZipjd9P4kREgUhXNCvJCeC2JaAU0iC/JBffENTSJaTkCZu7s981u7Uk
	 det8OEUxoTnC8iAQKoOaSIgcf6KGQXWjftcVGVZxviw8jds4C/5PHzbNy6VceuuE7z
	 js+VQ/jlz6s2zAY5fYrPzab0LyQsPk5m6vjpIxzE1rFqG3mywMVnKL+kjsHd4xcISb
	 h/k9nDaErnfi6zJjuqMY8rUGSUKpgwi6ruLawoqF61ZVJYp19sXUwQncH3+hYbfgEh
	 UXFgb5mGrfeEc5HkZmqzQKUDuLBsQ4UwI2UBAQDWgNuknib9mIp1606vArV28lOrJB
	 7Y0Xht+9Z2FbQ==
Date: Tue, 13 Oct 2026 13:33:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	peterx@redhat.com, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH] selftests/mm: fix uffd move-pmd test crash on 64K base
 page systems
Message-ID: <as4I7OKld_XJbdb3@kernel.org>
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
 <67c30e4c-3576-4ded-a71f-b49075ed42e3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67c30e4c-3576-4ded-a71f-b49075ed42e3@kernel.org>
X-Rspamd-Queue-Id: 5E4F6100005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 7rg6okf8s63yep4773yj9fmpno9ftjt9
X-HE-Tag: 1791887604-658610
X-HE-Meta: U2FsdGVkX195mJagsyDNUH1I2lw3HMOTyq8+AbuztfGfEW2VKl74IyS7Dq0NLLlV72/tyCp51apmeKq3ZiJykjkOUGTtbAzMQuCxLZGp1VhlL8dIYZ569oSWnH6W2FUGTS8/nUlKBlJxLQ93KMv5KmiKIgIvW4hk6og+9AdWAneWE92ASp/8EgGQYIA5CN1+Yc08VoRcfLPv5NTxlnePzMlrScqQnPuRbWx3F21w6732M74Isj2XkCmNKYiAvJeAAKuClJHom3QzP/3BPVBHqbrxOzv10jHy0Ziesfbfqekb9ggFokxQoQMlc7lSOk9lfFlb2ljGp1bp7u8vni8tMXXwN35kuauDGvsU0Jc1Bug3XhBXzsICUGDZ98cSuRzLKkJ3d8qxyzSqEP72n6aRNSaG1rUQqoucTYpamcGoOKC8WX3iZxgkvBH44pDu+NH8w2ZR8RzoRT0SZ1mmK/RDhGI4j1huNFAWwXK6JSmDiKhGQ1rPjcX5RXNJur2/SIrEb+yQ6zOmcOIGljZeFFSiNGoOd2U6ptglTbRbb0yF7kYxHnWE43k2UI+RwLe50U1lJ0+LaPh6sdz9DuDgP/XDKkBOrRuRF8GBWnrvN8JQbmFWXaZqvdnGthfjDowM8ADijc9vJvd62L/X5eZXgX8SiHRHR+6qwWRkQqS9+sm/WY1PgeZ+GakdTYkOKB22POTCWEKtQRHx2+cMn5ztkhe1OhCFSR8iagSMXSK1md7YlE3MPSkJyiPfgPPNkpPMxQSVG4kaVQqcSThfmCnl5pGcTbUTWygEdX7fuoXbG+YUxLVHJZ8KTGr+zeZqjHU0xZQyxBoAPLPkXqvTC9+bbBYPxKUTwK9ndZ0zWXepfy1g5xPyJ+/35oeNyIPRH818+HZlm0xVptzirXgkr6/Hbh13W7u1U/9yDLIjFsi3kxXtuRnyiQV+wCBAVTTFFvNQmmuB5QSxX+aGPD4BhgYHMyA
 a7fnER9h
 dCNs+aY/qJPKuH1yunwT2KSuSboYJoCEvA0sdIM9vXQr/eGBONfaHL4mqMWOctfKL0f5fhz7sXliJWhMQW78hPl/aUs4TMmLw/vyqdT9AMpW8h9LFkCtXQjDY48DzbBqyxkArvg4V0kzzPNxqp9nzghUCIzkVwHwrMT12l97PAothOrWl5YX2FACXpc7ctBm387b0cv+/QnkK7Ob1fq1wt4l8501KltbsKJhYZ7vp2gCuQEpPSZ9o3Uzy1gyNbzGqN37r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 09:39:54AM +0200, David Hildenbrand (Arm) wrote:
> On 10/11/26 18:35, Zenghui Yu wrote:
> > From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> > 
> > uffd_move_pmd_test()/uffd_move_test_common() splits the test area into
> > chunks of chunk_size and moves them one by one.  On arm64 with 64K base
> > pages the chunk_size (read_pmd_pagesize()) is 512MB, which is larger than
> > the whole 32MB (UFFD_TEST_MEM_SIZE) test area:
> > 
> >   step_count = nr_pages / (chunk_size / page_size) == 0
> > 
> > Because chunk_size > page_size, the test then aligns both areas up to
> > 512MB, which points far outside of the 32MB mappings, and decrements
> > step_count, which underflows to ULONG_MAX.  The verification loop then
> > runs away and the first dereference of area_src faults with a SIGSEGV.
> > 
> > Skip the test when a single chunk cannot fit into the test area.
> 
> That leaves 64k untested, though? Why not adjust the chunk size accordingly?

To test anything PMD on arm64 with 64k pages we need to adjust
UFFD_TEST_MEM_SIZE to have at least 4 pages, i.e 2G :)

Maybe we want UFFD_TEST_MEM_SIZE to scale with the page size?
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

