Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211D9606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E4P0MDK9
Received: by kanga.kvack.org (Postfix)
	id 43A486B05C3; Thu,  5 Nov 2026 03:46:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EADD6B05C4; Thu,  5 Nov 2026 03:46:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300896B05C5; Thu,  5 Nov 2026 03:46:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EEC36B05C3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:46:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A09EFA8301
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:46:32 +0000 (UTC)
X-FDA: 85400434224.13.34C4E96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0BE0C180002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:46:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4P0MDK9;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868391;
	b=Y/nB26GyUnG3lJP0f203uUC63bP0goiodkxcBxw1CNIa7aoHDOOAPnMe8H5d30AFWsKbel
	Zy2tH21qFtWHdIIoh2866DvSGJ6EUzEVNdaSUGKhZTSNGHdqr3RSK7IH4Uv1vGSye76c/e
	JJu3UXD8gik9RxmojOYQ/SWb61RHfEs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4P0MDK9;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmBeefEXaw5O44dRo1dUAqRZA0IAtNk7Ok9Q/ObhDCE=;
	b=l4fKWMc6iTkb1iTRE0T49N8ZFpQyU6v7Jqvm6Wu3WDcae/VFUX+e5XThpjd05RnE/Nw2Qu
	YSJqstfRzm9PGE7cqMo2pt3t+9w87Hnok6sbPFOMwrWHAuPH8jl5EBwimjExZAYMrPFrNi
	5BwTZNQEk2hLyEE5c9P6Que/77F/pu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D6B54097A;
	Thu,  5 Nov 2026 08:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BC61F000C1;
	Thu,  5 Nov 2026 08:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868390;
	bh=wmBeefEXaw5O44dRo1dUAqRZA0IAtNk7Ok9Q/ObhDCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E4P0MDK9oN1/bYIZaX+CzCBXo5968WnoaZcub1+UXlBhsOk4JvcS+2O9hQfyoHN+C
	 nsOZJM2T7NEX4I5rKnnu9nSOAlCeujUJ8XS7+h6mjPEQ0cMh2HKBXNDqxDBjBUqNMj
	 s9gAsnVjS4PB4U6brVXo52unIJKr4VIZ3OHfcQo0bK9kbI7nD4XMNu+6XCZbix+I+c
	 JCdoLh856Jj18QapogrDVNejW/EDh1TvbDZ428C4IuMCztSOUvPEpA5caEFAGKu7HF
	 c+Lt6ud85OpidUoluXjrPSX/nj0B81QXe16CAS8rsUX22ImGmgOvjHXNTl1ua/hS4G
	 MSMgtbAH86ejw==
Date: Thu, 5 Nov 2026 09:46:26 +0100
From: Christian Brauner <brauner@kernel.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 01/51] alloc_tag: don't remove /proc/allocinfo
 under the codetag module lock
Message-ID: <20261105-beigaben-anmarsch-wortreich-8c117c8ef23a@brauner>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-1-021c84d852e0@kernel.org>
 <fc4939cc-84ec-4c5c-88a7-658ca800377d@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fc4939cc-84ec-4c5c-88a7-658ca800377d@linux.dev>
X-Stat-Signature: k186ssjw1myoeygmmpyi3fs75wcyt8bn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0BE0C180002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793868390-395838
X-HE-Meta: U2FsdGVkX1/5ydrCTFG/DSWk/NeYrgh16hoOEm8l8yLIoycq+4g/XpBFd9K99NgrKsKCstHOlOfJCZnYznLxP4ZzG3WeWErrZMf4VK6MHqOHm9BBY2rekO+7tBpcSVdPkTMHPnHK34rII2jMGbT6WjX4W/i+HxSjE2jSbJZ/YowbO9aUv4JeGvOnwCowj6MtKikkhOiWdNXBvzlNAX/zXLGWy3PDHH7Z21CoJU9UuUua7Ix/NlgiMdfsocS54siei8lvMz/ACpMPGaKQO+1WV5kFqPgBKvYMDtr+cuP4ZLHZreYATqE9yjan47To7uR68A/bTZIcyQp3r6y4ZP0hQTRD5xxnMr6lMHWn5XqX9sdXji0trpM3psN+Iota2Xlr1ZLn4k8FJDQyyifJyj6uB4VniZt9OOK8CzentoFY46i2ARgKEho2n/MkFPWW1Wa0PcDedOzWDKBcMAQbbGdv04a7Ru4OymqH6+Odx5egMAOEwxGCmuP+EuKdJZnnhDyGPwnakhogYOtZABSKrHDNyp6PVobS7SFLiKmd+uRbe5+Vjfynu2B1kTFcVvWnaFLvIFsiWzti2O5ghfAKgT/DFGUqDwBpxuPmzTB8AbGfRd57HAeu/YtBDkqgVzXqbxXoObXXx2GIwpD0zxMiy9KJxt4Zl9tVv3Yx90YEzhwLd/VWhMwc255ziR9mp2sVCrWpwjW0E6gLJgsJLjLOHPFNJtQTkZrd7WdU4AdIP83/Kr9g1k7o6B5WOJQbDFsDrHd/BYpH/qd0aoZWZ/IOm5EIRlMLaF3WfE4YErGGwzYHxZs/n6J86THchlbs2ih1w7jSJSa/1yDYMvd4HZ60rVrtKYW4l10hh+Byv7x2f2Hxyq3rBjK9tk0b3VCmENrdzq9drRZjJfYvsl35/9dkT9Qxr4cJaC52YuuQUjkYVdjoXMiBxn2nCjetaCjzLIg5THacoPmWXVCeJomCodIq/2J
 N49qSlEZ
 B+LEKxuKb5C3NDklKz21qBmkGglz25JdrkrIzYUA4BvVw+S9rmNajBpxGRQgikRLrpmWoHxRc1Q6oEUkX0xshcKvJ2VehrKM3WmdKfk6SjTzRT4Y0Rvoatord7DYU2ElGi1C0lH+cM4bLv+sckqNq2rHR3IiO4WO3Rx8giq7hMGzLoUGmgj8fpXsTmAQqG6XQoulng8FRvvgj07tDRh46PWSx9WGrTJWs7Yar5G0ydl0RwEJBg50MOkcyHilwNjKMZAuWP97gl9cmVNOj38YU3BDAdbKaBGczRZCWYtN2F0ABjz/303cW5skRsVi/WKgIAN6Ca9tB9HRSIA8TSlVeCwoL6N8kijWbTmlnoqe8Z0RxPZoG2/Wlgt+rmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 5 Nov 2026 10:15:13 +0800, Hao Ge wrote:
> is this a problem you have hit in practice?

No? For alloc tagging it might be reasonable somehow but 90% of these
problems I haven't hid in practice. But they're all reproed.

> I previously sent a patch with a comparable idea, though Sashiko remained unconvinced.
>
> [patch]: https://lore.kernel.org/all/20260817062726.106511-3-hao.ge@linux.dev/
>
> Could this patch perhaps wait for mine? No worries if this is inconvenient.

I don't care. We just need to keep straight what was fixed.

