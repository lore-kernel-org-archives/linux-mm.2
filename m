Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A101CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 14:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177FD6B00AC; Tue,  2 Jun 2026 10:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129816B00B2; Tue,  2 Jun 2026 10:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03EEB6B00B7; Tue,  2 Jun 2026 10:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAFBB6B00AC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:14:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81E4612093F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:14:01 +0000 (UTC)
X-FDA: 84835166682.24.375C56B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D07A0100003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:13:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rv/vc6Rq";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780409639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Da0hGHRQ+u6EMu8JOWarmoA+lAxekjyOANZmQgjUI8=;
	b=emNrIL+5G3QJor/42qdiy+1fBnJnNfH8Xs9VHy7+ytEKoWT7BZix2N0RfxL3D8yO3Tlt1L
	xENc8Iu/15NXcmP6KOvjrmyFfQ2NvoO5SFGp7Pl1YtbSv1SgF9KhwVACbqfpYqYQrN4+ID
	YZOsZ5fVQWU9wqzbTbNinzGwyYqDmbY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780409639;
	b=xDwBqftyGNwnZHJ7UvZy1UvuuvNnQUpBgsMBKvReZ1mNB3Y0ltV2FoTnCoMmfcMzgzhdAh
	7wI+xrjb5kewO9uTgePtGwoeCLzNs0oHSZF3B2bjhV0qu32spydOD0Xjsx40sxBqUAPbis
	8Rep6Zm6drcOGWuW+mvjN7AeYFe7eqg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rv/vc6Rq";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8E9540AD5;
	Tue,  2 Jun 2026 14:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DBA1F00893;
	Tue,  2 Jun 2026 14:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780409638;
	bh=1Da0hGHRQ+u6EMu8JOWarmoA+lAxekjyOANZmQgjUI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rv/vc6Rq3YhE6Vacsb3plHHgWxNahSbe1mNpDtLyb9Uio74S65fjQxTJgNxUExRkv
	 DB6lL/S/394EBIVzKoOBtNMHw3o0gzMpdFJ7jGNznmhAaJKU3LMdDHcrWqodrt3/DK
	 nhKCESyl4IrdiepEdcK/glKszRYQDCcIs/7RTxVu8UZDQOQT8Ydir99zx/UGjNrNOv
	 GrAP5v5AN73YYhp5+oGM3Br73FerFxPt7/5H/MufCscbE3XYgCyVeXFsdNX516iJe7
	 NkcAF+VjtFjOMibA3owVxDTdEdCDY2Zi9goO1V2u3ffBaq/Xos2lmucHn0a1Fz8RlQ
	 nw4cru+UUv9Eg==
From: SeongJae Park <sj@kernel.org>
To: Ruslan Valiyev <linuxoid@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] selftests/damon/_damon_sysfs: support kdamond refresh_ms
Date: Tue,  2 Jun 2026 07:13:49 -0700
Message-ID: <20260602141350.101848-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602131217.2210912-2-linuxoid@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D07A0100003
X-Rspam-User: 
X-Stat-Signature: 9nc8tharakxsjqtan8dbtc7pxk9ewsme
X-Rspamd-Server: rspam08
X-HE-Tag: 1780409639-113294
X-HE-Meta: U2FsdGVkX1+2cvQP8D8MOOANbYbN34M6ChQiWwyZMvI06TWNxAruBPUle6qRUxXMxAfXkK7736jthTYBqa9kFF6f0iuGFt01J+2vMRcntSEg76l2GQx6WNrJM2I0eYvxeDYucD4chGkh+meIEq5uuz8/fHypNnHaAXMDP74L3xhkHL+DEZHxZSG+jQ2xnu0a1lOh5lhkWsk2imF6h4AqwQSFZnJSSInh57/T70Oq5AEfcZodu0gP+5CCy39JBkDsZZcuXBFZG8vQm9iloGWkZ3sBgsdOuHCZbqUQ4j2WFGabKHA7AGzO1ApGMj6btFDfQmRDClUe2BZC0/Xv20OjQ2iOkMPeGpjdbZbaqBzG77mPXSM0dx1MR1Ri48bQxB3zHmbDuE0R+oBCennX4y7gh+43spWwYKow8xUB2Xgs0V8gJyhaLyoV7HgiY4SeELt38TUsCYVlpe8V2X6Iwh80v0HrHPPkGH/n+68thLScAREbUKq5K1r+3rm/8ZRL2kPoxho49BykvkFUfzLckyUmPC7ptFQ0C2rm53RGF5wMBCSmUtYMKc02LLPysCaVkUZh684MNi+B2GL9EmLGpDf3/l3/yVgqf+XI9dexe5jq+dMFIXHRbYh8CFjQG3RORHaD2JTI0+T72u+eVgWvCei0r+OV78S3I5IjPyMB74iE0Lo8/dKNNonJcz2KAxwTPTct3kBs9YJFaXp3YelZsr4KnDJBfIUcjrcjB5KaisHx5fVQBJMMetHvRkhBMWLAcx4weQhRcOg+E9zkid2qQpYc21+c34zSdAOcnCqj0Csouqex75XljLPoour5BH538z30JC+dugxRwZlxKIsvo5ahNcl1Ruqqhs6nCS6gyGjsbZgtpoFqwintOXPdpUOft/am3bDR7Xa+o7crHYqpwDRqUg6hNM3WP57KKM2lZamEbjUcce2g0Szi0EfFRQJkjcSGhdlo6dJ1Lnecofwstk6
 4m2w/oLF
 Xjl3okg7q6tdGl7lY2Z1NhqCYKAay7/saxwwQXb4f+p3PQkZEJ8qnQtvnaJZ/LH3fSGRvijyx527Srk+O/zt0mddSOxdhTGS4/B3YaRWt6BKEeUUczdJpiZM9HYW6HS9qmdoKbLZXyWsSpYPp1TV4ym7BoLELI0abVJkRVGFUXy++8QldXqdAZZRLu88WW4lCi9qogQNR655K+LX5CPXmARrdKsBI+cXD1ivb62vm9XRk3p3H/c9ZQbWTeWaftfVbSw0DTqeAMHB8S6pN0AlTPXjgtea4KbS3Wue0qEkgtHNG/uY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Jun 2026 15:12:16 +0200 Ruslan Valiyev <linuxoid@gmail.com> wrote:

> The Kdamond class has no way to set the kdamond-level 'refresh_ms' sysfs
> file, which makes DAMON periodically update the read-only sysfs files
> (DAMOS stats, tuned monitoring intervals and the kdamond pid) on its own.
> 
> Add a 'refresh_ms' parameter to Kdamond.  When it is set (including to
> zero, to disable the periodic update), write it before turning the
> kdamond on, so tests can exercise the auto-update behavior.  Leaving it
> unset keeps the previous behavior of not touching the file, so callers
> running against kernels without the feature are unaffected.

Nice addition of the feature, thank you!

> 
> Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

