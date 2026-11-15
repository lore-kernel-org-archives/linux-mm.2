Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E86E606A337
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 05:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=izOZUxYS
Received: by kanga.kvack.org (Postfix)
	id 49EA36B00EF; Sun, 15 Nov 2026 00:02:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F466B05B0; Sun, 15 Nov 2026 00:02:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366156B05B1; Sun, 15 Nov 2026 00:02:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 147776B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:02:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80AB480547
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 05:02:09 +0000 (UTC)
X-FDA: 85436156778.12.41BBFBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 022B5180005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 05:02:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izOZUxYS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794718928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RvmTX8t5j5/IoltMXAdXZ4t6ouHAYznQwasZalqaL6s=;
	b=ZGX8/70BEyUb4MaH1W9CGWIQXtnmjMLU96Mr6KVNwoWwA7ts7Kqxh+zTZXa9WeaYeHxOuE
	e/r65W/uM5E/s2Ezth/qcOWIuiIEsmwBaYCsTmBjD8/hjUBvURcdkP8POTKcxLzbROSb41
	vHKW2TlupzY77vt1TU6R2S1is0MTs5Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izOZUxYS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794718928;
	b=Kjja7AhPTEendL4EJ5WEOgvYTjmTvkuq+BSN66pIOAGEg3P5ePVLTkW/yU2av2Zh+qZpVg
	dNRGfUpTVrWWcrlf/cLmef+Wkk7J1PgmO//0Nt7Q8+xS3aa+hKdT1HMA6M4hIVZb1AfP6L
	po6IvOH0lOh2FQgm7Ok7J+zFQr0CREo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F052B4372B;
	Sun, 15 Nov 2026 05:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59CA1F000C4;
	Sun, 15 Nov 2026 05:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794718926;
	bh=RvmTX8t5j5/IoltMXAdXZ4t6ouHAYznQwasZalqaL6s=;
	h=From:To:Cc:Subject:Date;
	b=izOZUxYS8HzrKJi/UTtmkSX1XsfKOfNT/yiOgTXLdnD2mb1BL2X5Y0LGXWS1HHELm
	 u5zNT/MvMnyq5cDMbRI+VExbc48PKodmpXx+pcb7xSEg3xoWvRxJtt4dGYjLL6O9s7
	 YM5O0UmhtfXCvw4ZKHKaesI0+OPAda34j10NsiEiSBP1cua2JuJGQAUXekQkSYyEMG
	 3n+6t+xGDvI6xfCthg7ELLZaNoJPC4i9v72Ttw6PT3H3cVrCAFWqcsgP2C7G4tEooH
	 52EdZ/htiGD5VY4UChDHYXH7saYSG/+F/XE0EgCNTNMZvxZugmg2YahDHt2zasdGpC
	 2UHhDR1omBYWg==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] kexec: MAINTAINERS update
Date: Sun, 15 Nov 2026 07:01:59 +0200
Message-ID: <20261115050200.1847508-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 022B5180005
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: u9d3iwbxi9s817fmxzxug3oxbprz1p96
X-HE-Tag: 1794718927-608846
X-HE-Meta: U2FsdGVkX1/k6EWMePuhg6FNAYlaFqf4FgxVbwd6/aP+S7V8ATT3MBFPZACaf9lOK5FM7aTLe4vSZEWy+JJ2DLDgxdzpuzHyUJ5ukbLSqn6+V9cVfgZBdqjWSdHqyS/ctavexyP+rUzKlB2PXyLb3Zqx4rhQNbXCX1K7bYwY89Am8USsI4N1resgcEo+gvNewkM/6+eUh9VSiU8rlfVwiIOItR1zhP3GhVVuDY3zc1kGV9sZ8ocvOO9vOolNk9wrV1CLpdl8qtCwcfjrbwzEEJREozMz0MRgA3JEbqQYs1ZPpOoGiV/GiJ3H4keCuUfA8Oh8NcwUypvfjhWy45l9G9kaf3BRgzawBAbNK7Fd+ftS0K2nZSS9njXRBG8VpDuU1bhEbdFnWm3ECsk2eTCemB+uPPsT0OLr/2GfZXWq5Er2caR3qWU6G6iKUPS06C4tCKeBoDqspzD5j6kCsfAWaIU6W/ZlbneDzG7VdF74xPLHn2zYzBS3Z4Iyo0B6pk7fwUw/lnwHqxpcnWOKPtqSyejZhMQLIwCcNBpvmurIZj6aZ1QCRnbgea/QPvnke9zBISW58n/d7QuaoS6akZdO7RUcx8X1qzx4rCUgxYOFHH2i1tNVluvt2QEOkPtZCgZCYRw0hfRUE8AvuJo7lChUnhTt44EbtQvUl5ERrxD7QMkJK/udFpCzJgpNMNyRhWzgvk6stzBabrkkMriFleJqC1zoDTjJ94vUK3HfI11g10V0blQa9RHwVyfITiy+NEWgIFrp988UAUlcQugmqiRI2YbXGQNCXs9NFI9aR2wumFRA0msZhw48W0YAX2JZjDT3gLuKHmpaD2sRC+wDXzwqx0cqFnnkIbvXpwgZdJHA5OU+zJFxpw+qgEn28bpF1tnTUmqbpTQ1yPCQUer14T1mta3FcQWL3381wKUS/ElZhswi9PFZi3idoIuljhydauqBSqwJWe7PmxTAn2DaAUA
 jbIf3FC5
 2iS9n5/0kaLyBvFfys8rtlLlcAHi2Z3MrejjXUXfq6caDl2UhWfoCOww1rIHmz8O+PT8nPIvQLvcThq93Feycdq92UxDxBtGJqezzbB6GSFyukCjNYACiKAboQ9HEmiPVMbEoEAfS6/5Q4N04B60uw37Ujg4kV7ZXULBh/j4ymKOjOfeeIzIvGCLJ9piA+Bzt/gZfOHYih2VD1q07VX1rgkahKLK2W4AthUfszRB5oIVZ4Hw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/kexec-fixes-2026-11-15

for you to fetch changes up to ab75132e99eb0b7dcd3a1882e35519f8229a669e:

  Remove myself as a kdump reviewer (2026-11-11 00:37:37 +0200)

----------------------------------------------------------------
kexec: MAINTAINERS update

Remove Dave Young as kdump reviewer

----------------------------------------------------------------
Dave Young (1):
      Remove myself as a kdump reviewer

 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

