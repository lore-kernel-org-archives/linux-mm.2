Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3BA3CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 00:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43136B0005; Tue, 12 May 2026 20:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC6D6B008A; Tue, 12 May 2026 20:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94276B008C; Tue, 12 May 2026 20:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B4A9C6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:43:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BEBAC21A3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:43:03 +0000 (UTC)
X-FDA: 84760547046.08.D5B28E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9F3AD4000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:43:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJ2dmddO;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778632981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcAUK8KI4UMD1UsWpjQ6qMwxAklwsKW9scar53mWefI=;
	b=NYQg7UX0EqjnCjtEv9DfCDbrMvNU2XltCdUZXy0Io3nn6mgHb5vr+rHwqCXuhP/g1fC1jE
	hU36PnYlNnOZAB7FiGQEKvFhJTw5OEeO8/th8hnqgQIuKZYXXJckoM+mZBl3btCDq8v6jf
	kZ8GhAwZlzUBYPjI420nKd/rSRrhHwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778632981; a=rsa-sha256;
	cv=none;
	b=X4CajCHtUKAf1pBgD8bn1MfamUCVvXtwy9rOM4Rakg3vUMQhcQL/qlRWzdNEFB4aVHtQz2
	BDSotVjVOLlc2NkXrGhMqzmnQ2C7D/qXremNV6klmGTORBDPQOnPQPbo4Z4AsUNfOCA/8Q
	V6NAmwXsrIbz4WjYy9dVmNq06sFrz8s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJ2dmddO;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5E0E600CB;
	Wed, 13 May 2026 00:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16C3C2BCB0;
	Wed, 13 May 2026 00:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778632980;
	bh=F67x74zQHDavInVewpEn45XQx3OuQF+BwWkBzVhar/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJ2dmddOQdMDLftsFFJcND6nRRMR1+HtKsSZc3SxDbKf+/cdldMq5ap3SZ6pb75wt
	 lB5WpDIQEkLKX051okiB5uFRqVHDFM/PUHvfTaB4yHyEHRwB7aGJBcEQ/eukiHbLUg
	 oEgZ5+/f+DPlYQvY21MRaHtpmYYZ6SRn0sjX4EPBX+BjhpuqX/0cOJo3Z55JS6sgJW
	 FdzUp+QBd6gmb4CtSlIjs+A+y3l193N3X6rghhph4qS7Y2asFhU2iFNqpTZ3aKFPnR
	 fyDwNHb38Q+SmLVW68BiZS0Pjmst6yFnnOzKyKzwYGVtyl7BA4bc7Q/vCvs2ZIzYP3
	 wos4kr2I5IilQ==
From: SeongJae Park <sj@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix mmap() return value check in run_migration_benchmark
Date: Tue, 12 May 2026 17:42:51 -0700
Message-ID: <20260513004252.118855-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512101305.139509-1-lihongfu@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F3AD4000B
X-Rspam-User: 
X-Stat-Signature: xtkpj8eeofqr8xzco3yty1opb94uneeh
X-HE-Tag: 1778632981-5753
X-HE-Meta: U2FsdGVkX1+waz7VSo4MpJuc3N0sXrN0HDOUcZc7No93/WLckTR0l87wlcQLspbT2VpyhW/Xtn4jo8Kh3CE4l4kO8CVGUgp4dOQOpckZS2okhI/mN7Lwr04OtBVQ5lmBkjs8RGYU+PSv+7u1ZozkwEdFudxPSnIZBxho1AyHc3tB39w7O2dWegHgx/HByjMoxQbKNfInXWjqaghxRP+LBxbZ3S8PhkQGGdeJcTnX7uvL03/1oULrOj/MMibDjzR2uf0q+CRoLe97oQNgoJ7sURePmTQ9L/8pyPNJlBzIIjxc5kZAYbKRpkhL2mf4Owa5issMUaJhj0sKSpRhrUqhFIqtF9aDqLnOTzQ0hNz5tin8xfW5kltS+HRSbnv5dtfNbcO6M73ldQa+aDwtKe1NxRv3Pkp1QPhkzB1fRZQyxTlOoBdypaTiPd42szcx1jXOu740hCiRXq1m38cxQyGAxInJS5ntLsVPgk+PBwBxY+aZn+MQiYue3daEHpugklZtLBYRfMCm7UeFyySSzaqCKslL+LBDrG+G5d1E+mEQd7W1BOCTG4aDqWFDuGGgWUREz+xTBoOEIgnbP2mFucUwBQ+54h3PCc02XP4Ppwby6jWQdBwp0yEzQbc8IqVHXOW5X8QDgWGvGq8RDXkrnM8RgFIwH1+3Y/4YQjs9Z4M3os6lIgHYlXjHX2of5WX7bxOyuuxIYe8H6slhusga/3pT/HbTm9gY3dNsxABDLIg7OsBBR2+23GFUULXZn/rApYPiKJUUfpodT6RjHWfYFxgFc7uNlpt5YOwC7JZSAB1tPfUNlAotxv8xLeJqQIJKDknKDtB/aoYV2iOOlDjZQpM6jlG5Njr/UTO/7BubuX7eHlFj/O3kRYgFPnfz8mwVOLU6RjjY2QOWPzrqVPljwHBc+Xhj6hrROsVfA5edz76pw2TjFNdtCLQeQrD3Jz5uWXhm0I9n8pEAZmYKBqqcBee
 +IBpfjhF
 8VHuH29n9fdZMc+qjZrtE/z9LO3ix3wSiBz+iw81mnOi0Fhh2Ywz6LK0SD//8y1NFxM7nenwUTmAM0ai6fZnFUAP/3iZVIfCrU3FIHD3yIcEMv5tUKcq8/DG2hEDGwIeX2R+m64bCk1LdQc+HppNm02Fgtgnh2oGgijPPzX87IWM15Hbxcutvc4wvlkUupuQ6xeM9qkKEz6sBRahb1xCvNdkZ5pmey64j0IXrd9KM8CSFEhj//uxFSqqNwV2icOz26HWfNW/1Yy3NZxWovsy0dTIhHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 18:13:05 +0800 Hongfu Li <lihongfu@kylinos.cn> wrote:

> mmap() returns MAP_FAILED on error, not NULL.  The current check uses
> !buffer->ptr, which evaluates to false when mmap() fails (since
> MAP_FAILED is (void *)-1, not 0), so the error path is never taken.

Good catch, thank you!

> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

