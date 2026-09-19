Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E28CEC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F6E6B0088; Sat, 19 Sep 2026 06:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F125E6B00A0; Sat, 19 Sep 2026 06:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01396B00A1; Sat, 19 Sep 2026 06:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C50FD6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:18:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5594BA496A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:18:37 +0000 (UTC)
X-FDA: 85230112674.28.6ED474E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A44A214000E
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:18:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="T8H/Qs/u";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789813115;
	b=cv5MUFgSfpCoWiTHI4W/1+JkV06Pv9elAg3QFkM0XqB9gbiqtgRDUp+RoZHiNoErhiPZ/Q
	3Qk/zn83n0HlWBUKr9hA+xcLxkB5jtpzimWGqh++be6Zs5WYPjdRWn7KTpSX915ihzXQFW
	8rqYVnVocA5+BXpgf00ACeizyZC04w0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="T8H/Qs/u";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789813115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFPf9N+HqWZ/4XEX8ZUkux5HGcllbJMP2zebWj+Adys=;
	b=PsAHYd7f0bue2jza6a8QuB59VdL3mqqo2oPpHyW0SGgueZF/wuqrRSJ70pk3Y3zNcu01wu
	wwZZlsZ7lo+vO18MnGy9zeqUpLDOZ4e16ajjQB0cbQdRQeDYQjVe+JJ2eyC8tSQWEdyxTS
	tFzoPVtKXE7dRnbr4sdA1P+NwwTcvdw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22E4C6020C;
	Sat, 19 Sep 2026 10:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927BB1F000FF;
	Sat, 19 Sep 2026 10:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789813114;
	bh=dFPf9N+HqWZ/4XEX8ZUkux5HGcllbJMP2zebWj+Adys=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=T8H/Qs/uQISrJVGibVwy3V2yEE1199PwMjke2RtBbxtv/IIxBZ2CQ72Pf6pp483g4
	 HYUftZe/gcEdkMrSJj471w6zF5HETModrWgQjxXqKgefvnejmox3ER3VYfSYf59uw/
	 d3Fs+eAqR5USipzu17vhxfM41fS/uZ8utfuKL868=
Date: Sat, 19 Sep 2026 03:18:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-Id: <20260919031834.d0b38fc1b6637445cd08f419@linux-foundation.org>
In-Reply-To: <20260919-nommu_gup_pin-v3-1-3660a8851243@kernel.org>
References: <20260919-nommu_gup_pin-v3-1-3660a8851243@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A44A214000E
X-Stat-Signature: nhka8pdj69xx54beifc4ctxcmecydhph
X-Rspam-User: 
X-HE-Tag: 1789813115-434478
X-HE-Meta: U2FsdGVkX19kvRKTBIUvvtmEnGyYgppoiWK2HCfUFd4w5mHeiEEM/NozSLmn6/P+2JSDix4vx8z06ufs/L1SiE/BVjxIxE/J3xSlXoBaj0wfX0+yVf8VI+fWjOz3+kRLH55PVzJw16IbiT+w2D8YWfS933sSCTixYikTKXUe7GmlH22OM097ea0F1QgT6wdvgEiZkUCbwvNqHvxkIWv9jwyE1ZbyBzKu1ZLWUTbcLwCjc7q32jx98kYiJAHUdB3GZsJVpJvNQp4RYjYDxfhIUVI8xcsvgqG/UzOLx0+z4c5LGKeA+CARIIC799g68t7n69mOOdAiIKJYw8a5m6imlv5CxQ8xMhVTpr270UsQDJlqxJQFHcpDYCdjtpAT0SSe91x5i760fIxpJz9Zugu3tXYNQZClgiqXXnIbm1UtijSjMGxtkbO/8O5c3uZR9QiHZ/GRmobTiHKSSLOl3G9cUjHAukQba04WeWsgEmXOwyA/w+HQyeFXK+BUs5RN0aO2e4jKiG65szL+yuogfLrxrgNTh86Ie+1AEGJ07otber8cxtuEvnRzphrx6yuBQzmiFfkek+WYbLiKoX3nJEHXcq+nJCV9UUtMXxQRaH+8YxlLtlF3qcqHmOUObXHyCkeqotDG/YkFCIjnv16Sd0dMiBjZgArh16oSD+I+b1FzLSNUVYrwC2xBQhe9JqKvjWiyPkgJuhJNLe5qlmlCBmyaWfFR21W/JYfnWABJiZEOV598lhBjmmbTbVf6ntCnpLsYZ0Hwc7F+SfqtKQgJjwA43gcTg+6HiuB0sLWTts91RfsSxWt+IFtaDcOS3Lx2URY67p7HXtdieAZkcc2kNas4IbU7dVbs4fRCwhczchCknE0Scnn/GUwZVg0VCe8QSwNQzKY8PEGWQrgPrRVotK3/lgyegmsORxdoFzsa0ynJwTOatA38irEey7Iq9U7UPiVqgbOWWSrCCxfBo6SFldo
 SnEyNZT/
 p6W3XiYhRs+LOmqG7mWGAmHSLX16VK6c/Umrf+jSixRZGpjs7uGOm/rY/KoSlEC6mZszgW3kN3HiuumGbhING+igR8mQAM/JA02QR1WfYxIKAc3FvIVSsksdWC06Mfy+buYveTeoWrUl+IM/js8c6niUh2FKldHP49x2tMi1hSXKYWJbDPs7VaySo9Ur6ZhauCcaVCHNCefZfcIfnQEvbrLpeYcQAEVIWP2aUfOESZDNM0Ns93wnHi+hE+2VHzQIqcTsTbxjV1AnBzH7n93bRNybl+1CvrTIfLt/DhQfq88R4SqFtyf8579a2waofqMrX6Yjt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 12:04:36 +0200 "David Hildenbrand (arm)" <david@kernel.org> wrote:

> I added a best-guess fixes tag. Given that this has been around for a
> while ... and it's nommu, I think this is fine just going into the next
> merge window. In that case, I will pick this up myself. If we want this
> as a hotfix, Andrew please pick it up.

go for it

