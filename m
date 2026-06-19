Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C63CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 17:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3BE6B0088; Fri, 19 Jun 2026 13:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5DBE6B0092; Fri, 19 Jun 2026 13:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B552C6B0088; Fri, 19 Jun 2026 13:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 879EF6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:08:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E2438ED92
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:08:39 +0000 (UTC)
X-FDA: 84897296358.23.E5E8586
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6FA764000B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:08:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tj7b6zPm;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781888917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSFyUTSQCQY5vs7VfKRlVX2+O8jg+IdCcyNy1PibSiY=;
	b=ztyUDpu+z7FDWT4MIAteFZnrj2Jw8CA6kzbt9tlzy/ht1fRbJwkqyYO61zg0vjISLypWBk
	i+5+KGp+e4x+PsVu6TtseaxIwG5HnU8Vb1Hv9SMIVhqvrioILMf3nHlQH0+uGa0+TDZFba
	eY8/C588tvG7Uy42hE5as6+CCZCG07k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tj7b6zPm;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781888917;
	b=S/mpXXiG0iLLa5oGPOULBohYiyjJ//awu5ITtJqkcNJW3hVb8AGPSyPOc60m3a7OJQOXVy
	XNYNgsvzdXqtvEOx975DZK69HV4meARXhRYBXbznZOIWrnl7b/77hH4BMFTYT45Y70q924
	dBcy1EKPTNQ+MbFKwtukyXjmAEOcRuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB410601E2;
	Fri, 19 Jun 2026 17:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0285C1F000E9;
	Fri, 19 Jun 2026 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781888916;
	bh=gSFyUTSQCQY5vs7VfKRlVX2+O8jg+IdCcyNy1PibSiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tj7b6zPmYnN41mwKxXh1WftVElB0s9elgh2RAbdMpaKYPseRUwwUPcNtUQqL4PIex
	 pGQT4BmMhMmy6rImlTB+6AKZF4RF6KUhrINF7CNWUWz6OOd3NoFLU754zj17tXZEe+
	 TeFBEQYdseQcCrTr1p5QH7PoJp2oxq/FyU8o2V/usMZ3+9EeEz57hxOeWrcn+bi2kr
	 pQBCsMWCwS9h1NyyNMd5ZPTQmPih/RvQYpxE2c8veT8Y3B82+zOzGSDmfQr+VTlHLv
	 Bj0DN7CWSTcCWu+xnYEEltibAMieD/uGakEU4XI9rs/fjPK2BvKtWc67B+Dkf6ke7k
	 70BbqEGz4MFxQ==
Date: Fri, 19 Jun 2026 18:08:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Frederick Mayle <fmayle@google.com>, Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajV3b02BnQdKK8bw@lucifer>
References: <20260619112852.104213-1-ljs@kernel.org>
 <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
 <ajVz1nhMn2JwucMY@casper.infradead.org>
 <ajV0TbwEyaKMzoa6@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajV0TbwEyaKMzoa6@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6FA764000B
X-Stat-Signature: domppfdcsc61snujzmykuioy5c47rx74
X-HE-Tag: 1781888917-107865
X-HE-Meta: U2FsdGVkX1/pFRtCca5VWQEQijzPpxUH906KizK6Qts/sf8ZEF5Vthm7W1qm0K34t1s5Oad7a9AjSk3v4k4TE6sOwYqqzuab0xQTT9kL8l6EDdlCbLAfNNK8ka29551pPxC7cV5ma0L04o2T2u8oj/MuuWw0OwdzFflIRMtldfKb3SPR/y2zYkB/pW0WjUQLbB2/5mzBDhKEeOWD7ixqd7H7fk3xlDlepm8Hak61Kl6l/lKFp1rZws9QH5Kj770aRaBIDu3HA72HnvsEOtBhwqY5t8t5/IDIUvwQ/A7HnWfYzjjgTDXinE93g+nfZihyTlwGKRF7FZHXIylTJ5rdmhwIzavofmLsXFKZDrY9ofJ10J2btj/ioRzeSQHiWGWoKaLfat5pmBLgXEUHw4EqAM1QPoGSFlnS72YuDgslwEuSGzJd2pghmqOrbjZeLipw7L8tubQjtUqsYB/n/CpzLIegp+sd6OWuPE2twQj6aOtqI25tx1LfZy/R9HuhVpWy4RV3vSbPVH+4MXoe6VNdf+9EodAA5rmZI8v4Wl4MkL4sYFMaTHibaUWgX1CeAuFLXPaUmvvPYXPJKF1ATrO3eiQ0Xt4zr860O4oEwdHbDVhQmzDzFapWRzChp9j3KP69Xwn9IPt4tJLyln8OR4uEGYNJzhit5S6DCprcoSfqeScog9EJvWEcYT9tA0GifNeenwX3mpoJyQadSuZ+8oeLTsHMbb6uhmXkKyVtYcKNMleYz85rbn1lt6U8VBoT/bBFAcrPvq3bebPeesC71QnK/GjVqKVgHcVc9YAJke/VrZD5n+6/2PI5uElxRG9TvxbmJuEI1uQ6IKivnZUiN7MqjC/u24jcxKAhLfmABkTWS2xC23eoxW18Vn8SqfuXWXhyWa0JRXlEQxNPKk6daROeUIojHkjJtlENaV6kqjaMHePXMldosfK7lBcYhhjZodiaYTwBNhKWexajT0eY24l
 JSCkO/yh
 0ypKotgnnLkRTGyInF5e5lRkYuD52fHwFDW0th5wW2Y6pDZ7mDJrRKLx27C/2nEoxQZKwZXZfYub/60IO4gxCVn7uPVrnlh/lnJuHZOV9RNBJ3qbxGWOuBM21IDFAWPQgxm+kLhsWAuysizc3xuvMHqQG5Q3cO2LHKF260X6tPoI5wquaXgnhAWBfAa2opZn05Gf5Nd60ZWtKTn/Djc2Ffhnl9OjcUed/KdqcpNLr1vzc6LqM1p7qTVQfjSCZEvxdwEnYqDH0gHGa6NIRw1Dy3SvXAOUetedy0/b05jpmQFcrx2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 06:07:35PM +0100, Lorenzo Stoakes wrote:
> So yeah, this does not to be reverted, and as a hotfix sooner rather than later.

Does _need_ to be reverted :)

What an unfortunate typo... :P

