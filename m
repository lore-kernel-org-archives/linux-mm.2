Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CB0606A339
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVzFkiUi
Received: by kanga.kvack.org (Postfix)
	id 4F1066B05C9; Fri, 20 Nov 2026 05:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8EA6B05CA; Fri, 20 Nov 2026 05:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405A26B05CB; Fri, 20 Nov 2026 05:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5B96B05C9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:34:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4EC080EC2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:34:51 +0000 (UTC)
X-FDA: 85455139182.26.96ACC46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 02CB040006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:34:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVzFkiUi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170890;
	b=JNjvbINkyHr5B4LV62wvPLt3A0JVG7iJwD/fshTEHf4nVBYAUfKOtxLvPyKazi8gzwXoeE
	ZJpyXq6ZMBzGQGZsZrBbuDCoNRj1r3JHGQ4sYG1UMVXyn9ySPEcsjseusMw15Y0+NSy5ca
	SNy17OH7XhIbEOW5IYK9w4F6++gKa1c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wQqfgunTLnRwvEQh/g3zIyzHHyLtB+m2tV6o9f2aJHQ=;
	b=dZecTGnXaft3tg6DW3B1SdEUq5zLgv1G52lhweob9OLkzQ+9ydoA8c6xg3SKhjLSdAsnMh
	HR7TPaXzfADyoImshlyEcJ+AMgh/XLllpJlaYN9A2MblbYY5jkN0LKnMv0iaShQ5kUXpj4
	M4294NKqybuT2jvM9V58Kw/Xdgam0Bw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVzFkiUi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3356343879;
	Fri, 20 Nov 2026 10:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DAF1F000C0;
	Fri, 20 Nov 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170889;
	bh=wQqfgunTLnRwvEQh/g3zIyzHHyLtB+m2tV6o9f2aJHQ=;
	h=From:Subject:Date:To:Cc;
	b=UVzFkiUiMwNUbS/HWiQlCYAU6Kqri6wlrHFzHqicCWVoNn4OeFiMXdh2lSdq3M9Dr
	 37Qoq+GgPti6suume4wRMhjy0rZ3b4tnuw8XXxovm+Q+vPB0kdW3XNC2jpkSN9V/UX
	 3J85NLshKtgQLLH+eFsHJV4F9yQvNgHKLti05K3RmzTbUsEwasTSukpmTlJFxd3HhU
	 fpeAyRcUolnaVn3/OtaovAZeWaf1hm3Pf0vRfUaubH8QmO7OcEmu+8IpQ3MW9K+uLA
	 T/Yf6qIBXYDhcfOwx/pmRDbBy/00JAehm8V6GDNEolexVF8jvSK+7eMw1E3NqiTU5A
	 CUCz/llR9Lx4Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/2] mm: two NR_BALLOON_PAGES accounting fixes
Date: Fri, 20 Nov 2026 11:34:41 +0100
Message-Id: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMQQrCMBAF0KsMs26gSSViriJSkvqtIyUpmSqF0
 rsXdfk2b2NFFSgH2rjiIyolcyDbEA/PmEcYuXMgdq3z1rrWpJNJcZpKyX2u/RxHqDkDF5+6hM6
 DG+K54iHrb73e/tZ3emFYvhXv+wHMEPScdwAAAA==
X-Change-ID: 20261120-b4-balloon_nr_pages-7ee96b3be36e
To: Andrew Morton <akpm@linux-foundation.org>, 
 Nico Pache <nico.pache@linux.dev>, 
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev, 
 linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Shao Mingyin <shao.mingyin@zte.com.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=688; i=david@kernel.org;
 h=from:subject:message-id; bh=u8RpUaqYDleLKlHxY5TTxwcSUWPuzOrFCFR8UGPSP4I=;
 b=kA0DAAgWx+nLGEVVu3kByyZiAGsAIkOi1KpWa7nTJYIQCaa+Cb0UW7jbV02GcVHHHGiKZwQwe
 oh1BAAWCAAdFiEEUlPfMOnprn17Rg4Dx+nLGEVVu3kFAmsAIkMACgkQx+nLGEVVu3nEEAEAt5h8
 G5dAvgmD7YbKaOmb6YJNykDvpfMLWWyg0r8D6ZAA/i9ruCfdvmaJuFw7O7MLlkLsBMm9G49oxuc
 QvUnxsywA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Rspamd-Queue-Id: 02CB040006
X-Stat-Signature: gkyuqozd1mtc5b458er3quitugnekqpi
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795170889-94221
X-HE-Meta: U2FsdGVkX19J3I8tIiYXlUzZfa88wbOhk+DRbZRjFq/CQFziSyk3nZoGDEJanLuXUWY7PduQDObPCP9C2TULFmXfpjQ/npHFfvaq4xk9AZimr8+5t4VRZpG3RfUzkzaoAAeab/OP3Aj9XwqqDT67YoPX7jzK4ualVu1JrSleoYfMXAcPzGK+9mmG2YEKHTf+2P4XB9cmP8pqQSaE37QBLzuetwsWqR2yhzrv0579L9d5CCcqGxSO+jPAfhtbq1TV59jvIpJ5KOUeWqUGpJ7AL7svmP6GmSzit8zpgoAMycuBhOp9O5uq9UqcvzcU63RBxWrqKud7EQlfa3ULamPDiu8pcUmTZs59wWcs8nTSDm+IAeDGT9VNDeS73ZQSa8GkA7JNseRAs+645qbBAiIJ+hQfzb1Vp/5n0JjOiK4SrzUtV+K4n89GEG0qmEexnDUjrnoGLRbiOZA4D6Y+3aQ2nc8mxTz5ihadPirbVQoS+GDlZLOO5UtZFo7UZmdbF+hCUrzIvl/iF1gaNfuKbwTDu//0pyoHa62r4v76Vx2elJgJbmmHP/ZVksdyCMslCcSqSdTtuK6bioCPt6PUK2ENnYUvRviL60FcN3mvqCbJFL4nG6rpFZGlZTg5+HgPp47H5olfLSo7u2mX/ION+0CFwmkmpg/LTc9wLxTWIb5ghwGASP9daPTR2Gj73ETcmhRdq6qwSTa49qQdmUvO75QdWHye53m/PTRTt9dgKhBeGeLVSnqbhQVAGGunykHsOrO4zJVp4h2mZxIelFfZO8YVGYvH6JtXYwAjWJ6kPDs4wbttUXcoOz9s1gsH9mS+rPWaaCkSL2ZRtyc4faEL+mKVazowqRRcSFU9bb4da2PZAwUp3g9ektuRrRv6FbJb3SnNp7tiqsAjhswdxXSn6fL1g9u2KVXgCiFSKMkXIl1ELQ7njLTeCLjNkZK9HpGsWQZ5cfpnDDJjWO+ifBMJE8T
 upizUsHx
 6J4+qzDsmTFwrpQEe/jzo/XYCMS0D+fJ06Lqbths8qYj41WrexWJWNTp6vy5GWm0ejqkhWmCL3dIuD/VnSBNmCXpwvS7BYX28pEdspeImSuv0EnUXFywHlw6qnslhoyoXF1IRk7WHg7vZFWvzkRIZSCE+M3CuUh2sCqC4WP9Q54zwa1NsFDSAvvtXt/jfMEWYxWehWEGLtEfT41jHaG6oXfZU5H95z414BlsncmeL31gOS0W4EfZ6pJh66xG1Pm4Ja1oinHHR76GT9evOi4ltNLanOoSiHhbSf5TbYbYgz6cq2N7A75nMy64/mYFl3u+dh3504vhbVzqp+9T6WlUuhJ8hZN0E55HnLnsZcMplIYZt7Rlw9/yi97Bu7IAT8LzxEKAE1FmBnk9z7Qr/QfTB2NjNYxZnZyCszb+GM7Zk1EUuVfblnfanQpw7p+8hPE8eTbpD3EJG5WG7ZipwJHdKGInvAgMyv+RIj9mfGF5vO4S6Fg0dot8QA4ISf4ebSbNpyln78ifcHXTo1bVv0btFkOM8tLGRpKcskXzg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

two simple fixes for NR_BALLOON_PAGES accounting. I can take both
through the mm-core tree.

I tested patch #1 briefly in a QEMU VM with two numa nodes.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (2):
      mm/balloon: fix NR_BALLOON_PAGES accounting during page migration
      vmw_balloon: account 2 MiB pages in NR_BALLOON_PAGES

 drivers/misc/vmw_balloon.c | 4 ++++
 mm/balloon.c               | 5 +++++
 2 files changed, 9 insertions(+)
---
base-commit: f7d95bf74091373fad7273db4557df9b5a902335
change-id: 20261120-b4-balloon_nr_pages-7ee96b3be36e

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


