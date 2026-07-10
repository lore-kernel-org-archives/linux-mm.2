Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6B4C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35CA6B008C; Fri, 10 Jul 2026 05:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CB46B0092; Fri, 10 Jul 2026 05:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5E46B0093; Fri, 10 Jul 2026 05:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7726B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE11B8DCAC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:25 +0000 (UTC)
X-FDA: 84972353970.18.3420806
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D37220004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJ4mSzmi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpRcp/2dJk6gV7eAG1xmqQEL3beSixOls/uDr77Rs8Q=;
	b=YoTuNfRaSH8yDwWKSrOtew31GpClnJTRTuEfXxvJ9XQn6hNaCGnxoe+yoGoQTi9AZXKn7d
	CSxWYm8woDJTxCt4pU4/08fppkyEzc/UUHePHSPYXtUm8hV2af/mwSZodDRBoZ8nTAfYhY
	pX9bswuNBfEUs6u4oQHhwdYzQIXTEwk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJ4mSzmi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676004;
	b=5J0v3RCgOqBovsIxoKdF0ZnWvIskkHYeQEB3anZ6ij678kwDPAZEGvVJoiklutEv6cTaKc
	ejlv7R+ci5AWZA2DHDNWIPo36jb3c2Bl9eXyzwgzwOGhM4stqygx0JzkiT7H0KEEorYpk2
	H2yAep0VASI0L8SiLHbCpCoUvttrQ5U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8A7960EEF;
	Fri, 10 Jul 2026 09:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE23A1F00A3A;
	Fri, 10 Jul 2026 09:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676003;
	bh=dpRcp/2dJk6gV7eAG1xmqQEL3beSixOls/uDr77Rs8Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CJ4mSzmilNfuTzVZJBZ5TTDTJcCkU1HRfdPz8EBM46cO1wmsyCbTNl5J2bnjs0M/X
	 m1KiAnTRY5R9jojRFi366yUKwEJCRjeYbhqbEYt8u+bfdaCuYM80w+BKeMY8YoiwYE
	 KZdchNouw1WOV3smuUXAp2Kko6CwCSHZ8REJKzD2UKjuiN12Cn6XG8OmvSZz/JSdUh
	 Iv3CTmVjkQM5rpxAE12S2pNgJdL/JHopTxXKQ7nwGyRAA18ey8PZVtmx58fKDh+FrD
	 UuFc2u6pZRJykGyLyt865qEPolEIsZEGsbjlZPy/h5MeYhCgvtXtSxaaoSLm/kHbYc
	 VJsfJMW/4iKcw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:02 +0200
Subject: [PATCH v3 01/24] binfmt_misc: restore write access when removing
 an entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-1-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1605; i=brauner@kernel.org;
 h=from:subject:message-id; bh=t8nER3lsjLzcjeJujucgoUoGrAUWFYH7V6NQav6UZeY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7Il9rPhM7Mnn4OPM/54IdO9eXLwiXyzG+8br4xb/3
 au81PxtO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbCnsvI8G+j0rvIfVfkXyUp
 VCRvOfxBwqAqP9vqpKTmFP2r2XVG9xkZnh+dmrf3da760T+ZmVzXf12svX9KLuWeq+svllfCe1L
 LGAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D37220004
X-Stat-Signature: ghasyricfnd3b5urc9e155bo7djqacbb
X-HE-Tag: 1783676004-44250
X-HE-Meta: U2FsdGVkX1/SqT0WeI0bZDBikPSTetnoXLclUR+yJUZ3/+MAtLfPuoGRYGx2zdHvuqzXoFpnMAPzRFPvywZCOsNLBtlz+qZ5gfjNxVynGTBWyUJ52a39ShRvHWasPcr+4XlieH1y61ES9S6YZ1LU84Gxsh0lsyz2nP1+l3oKb0sL9VWGzvteyaCk/Tkd1wTcpEHWGnR270u4j+AGWBWyd62bIVhsjJbFTpWLnqiZW0W/QIHbuxE0cYIjK0aaqK+HCM5IVvweOeWtI3QfORd13T4RhKXm2qxZf5EZXgemHKnOJV4m/nUmjR5icsw1BuW7UxAEZd+jlO/IirZ5HCV7UGSEeurFriBNzx/lWK2cC9/zlzaT2BCpl71qyjs+rMYruHl64zgexBGQ8V5e312zyOvMDoskPTLIUS6dgditxVQyjWZvlpOra2OPjJ+jgEhulcV2MyENaYkmMzfjDv++fz9QgfNqCrzsNkAKCpEOZ7OtK2vW8JPb+IvquzdqW9heZoiz8S5SV81ct9/hYWRzUhfSBrCiyk32VPIPooVNYLIeGLFUx/NRm/pfB2Qu1xhqHDnk82rn9qti0+eYbzPpnN60G02oysBp+JgVIYdCiDzKcm9+uQPzpddpqta8ppyx1WDFHsl/9yhPkY10vanodnK4eXRSazicM3qBgv6ZPdap18OS5VzEiZfvrVzIzmJYoJFzUmA0V1jCqHvC0PNwiHyCdQX2Nv70S7nLMt2Ec2u1p8CVkmkq6k+CM5OG1qwIx3WH0QjtcoHgQfvtBwbuZd+pgO9G9Krtf+Ti2z3isO0wsdLWNsZwOnUKfRvVnzF7MHKIO5hO2X+8PrnjG1tLpIHWiB/3n9SQnnQjMhQS0QjJ8pM6TJngAvjCjuoJpF+DCD+vap0FaxHg2eJ0x+PuSONsabUgD4iEEpNfFm6uamjwoYCuM3bNcnaJVpKM0Cd/A/oPt63hjVOw8mXci+d
 KxfhEtyS
 epMvwMU3wpG4AcQT7IhoznCuUD7YhWMJ8cwPzyvgpIXnQTQREt77VsldcAoBIUI5S1IkHo6MblS838DwjMHLSl93sjp2Ymew80DrMso7b6YZcL+Fi/0mirE6pDNNkE5bqD5Z09toMFdxvvufQDHFN6yYrww9P7Ig4k+tGAkl5XM2KTllfetdCWAJw21iAC6v7nbwqJMAiEW4pJoLwoDyl+TA0BosqxJZPKoGdTCCmbkSMJAXdbFhv7WXJVE07pgTDIbWfK87Jz1QkvaKV+Q2awZIup5tfRrglntY45/U45l2M0++w8nThfIxoS0HI2fA+tnkiGc8kzjbI5igUiQBpfdrAKPG/t+UoixXwoUTsqH3oeuspqTBNi7gfuHLINBiq77FE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Registering an entry with the MISC_FMT_OPEN_FILE flag opens the
interpreter via open_exec() which denies write access to it for as
long as the entry exists. Removing the entry closes the interpreter
file via filp_close() but never restores write access, leaving the
inode's i_writecount permanently negative. Opening the interpreter
for writing keeps failing with ETXTBSY long after the entry is gone
until the inode is evicted from the inode cache.

Commit 90f601b497d7 ("binfmt_misc: restore write access before
closing files opened by open_exec()") fixed the same imbalance in the
error path of bm_register_write() but the actual removal path has
been leaking the write denial since the introduction of the flag.

Restore write access in put_binfmt_handler() before closing the
interpreter file.

Fixes: 948b701a607f ("binfmt_misc: add persistent opened binary handler for containers")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 84349fcb93f1..de50a7468b07 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -162,8 +162,10 @@ static Node *get_binfmt_handler(struct binfmt_misc *misc,
 static void put_binfmt_handler(Node *e)
 {
 	if (refcount_dec_and_test(&e->users)) {
-		if (e->flags & MISC_FMT_OPEN_FILE)
+		if (e->flags & MISC_FMT_OPEN_FILE) {
+			exe_file_allow_write_access(e->interp_file);
 			filp_close(e->interp_file, NULL);
+		}
 		kfree(e);
 	}
 }

-- 
2.53.0


