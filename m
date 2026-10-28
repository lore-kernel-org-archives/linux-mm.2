Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2889606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ggbZR6Ok
Received: by kanga.kvack.org (Postfix)
	id 1C6A66B05B2; Wed, 28 Oct 2026 10:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19EE26B05B7; Wed, 28 Oct 2026 10:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017306B05B2; Wed, 28 Oct 2026 10:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2E1E6B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:12:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58B87140410
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:12:00 +0000 (UTC)
X-FDA: 85372224000.13.E6C735F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A35781C0004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:11:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ggbZR6Ok;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793196718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aj6NKlEI/katth2wIESymczEJETsapNVp1gfTJSIOI4=;
	b=PbwpAYXI6wviEf1xKRRPfdqRmWIrcakRoA6yGIKgEF/nq2exIrWDEjhpcjYlZzpsSXYTh9
	QDJgeqdi3QdG+tHnjFClegr5IrLX/0qH0VAL4YuaqFT+d1G3gXhnM2Y6R2cW0iH7M4HpgD
	ThHMBCkqQ+WXdYe32diYAVOQNpd68jg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793196718;
	b=jgRZ6M9POHMVYeHscD1FTsc0gTae5N/dJixq9r3bpCL3/Ze0WHLiOEaj8KNzRJcbfPf1aM
	yUVJbuxz7on4t63MjnuEykupWozAzQLEnX/HS7v7OWalG4x7sK34WoltCUF8xUJNU46Srz
	STQXTz1Qr6tRWzjl/rMQF0nhhJapbP4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ggbZR6Ok;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CEA26022F;
	Wed, 28 Oct 2026 14:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2371F01829;
	Wed, 28 Oct 2026 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793196717;
	bh=Aj6NKlEI/katth2wIESymczEJETsapNVp1gfTJSIOI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggbZR6Ok/naZyBXDs/7zovL9VXOUbN2ItXbN3g+z++nLTPY4u2+ZTFAsyfMKR7amD
	 vSZk620hsvA2AVSmX5WnHEo9iF0bReERm8m3chFlU5YJhnSPuoiMsnZeVkO6nm/pqx
	 IRgzNKHGWbDrqiNPg9TlENI1G2Pmi+8ZKHZ930hLdiTtBze4VYDp2p8HVHz0nREz4A
	 mvoJLBlUkdanhnG63CXapTPmfhpkbY1dTtTmnF7TC5c9bA2m/qHZpR39jOh9k6w/IK
	 h8/SHHEiYMtoe/a+wRbcpDxANKc+mo3zg//FjvrhF4oquLROvBZ2MxS3RCq8tnQnif
	 I2TdLbCQdxJgA==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y 1/2] mm/damon/sysfs: put target pids for damon_start() failure
Date: Wed, 28 Oct 2026 07:11:48 -0700
Message-ID: <20261028141150.160711-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028141150.160711-1-sj@kernel.org>
References: <20261028141150.160711-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A35781C0004
X-Stat-Signature: a6zj3n1ur1chdjmy6ts7qafpwsubuo7o
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793196718-205967
X-HE-Meta: U2FsdGVkX1/dO6LxZRDFO+UiMOE7qZI0nra0PWxy1Q86HsKglqdl9U+arpz04nxH0k8Z+JGAnPW39KpLq0dyDL00CjqBdlKd4iybDcGSijUjCVjA9cJR33zh7XVIZ/MsGy3vpPzg7DwvFPDxw5/F80v7yDbtzE7R194HFJeYjVw5MXjbu5HKm425B7ZiN6esieZorX5+0EbEJqE5ZF1GIVGsW6HtD3JCX7xvu/3JPmqaN80Oxsx63KdDZ0Xy+erfLGEPvxyj8qGloLdJRS18ETSlmxyaxUXvdCATKYUIe+HLuDjbCUy/JycnVD/6Y4dED6BJbndCIHS29hDOCk7c90n8mqjsyTcUweGNddS952hUMKob7GH491dTIlcs9CyAESZsMREjDfLQtgulC/x6HUCVJSnGb1xhpiMJZ2cZW9Kxf3R1qOPTOFfR4X/E7QGOtbLNX9vVWtT8A9gF7nuXa7yPgSoKu3EqvAJ4E9b7Tb4IKboZ1jw2GHXQ83Ui6gbIdngKc2xEgvSMCc3fiOFk/G1Q30c1FfA9S7tPHvCKzNhKdOi4ZpWFELlJBTflKghGL9uacdEl1WjWMo1hzZ0PwybmxZCqKbEfY5v+ypEdNAQfXeXkCRDKtr/BXCA2ycf6q5CK0NQqyDg92Uh3gzu3hdSzX4+EcfR7GgFl/oRnevJDzGEHoI2K55k2IJxmmFf4ydowz63F95YizPMNwDYKxuUgRm/+jQ2LVdQVvTFT9q8tzp8gSWPnMuDFnDWwsfsJXBXnMmzkiVRdErCsAMCnpeGBrsgEMp5Cj6LA7X6RC5b5RNabU8NZcjS930z980RRrMXruIsLw5BDpgLAx1HgPCV1vZQOYLhl3FQb+LHi+9kmdqeaoxr96o7xFG7ccujHyY8B22NNON5yMm6vPe1PMbS2fbDnIlzWF6vry0P0sneVHR2pCofh87AmaX0lnsByhd1wIQad8z+mvS5xfg0
 mYfBJp1o
 6O9W2GvT2/Tsy16B0d/3QY/s0dr/t+mHV6XCKJx0OR0fMk8lNSy46hBDY6gLFKoFBCmRAb9JEd7CkVf7tkaX2+VFw0+zHPapSIGZBuhr5M6V1By4aj0XPa2QHwc67F+ZBOWVvfF8p4Wgng7lEOmtXl6SFWJJ7aeyX/Qhlwk+roXejEpL0XnZlaSRMTBRatFsK7bOuGnj1TY86Q8SgKMN5C6lBAeQHg3oybv4qZakCxld1DhSXWUMe9yUbixR4zG/5nZMvp7IuG5uBmxIpFHwOcFzX6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_turn_damon_on() allocates and sets up damon_ctx to start.
If it is for virtual address space monitoring, the setup increases the
reference counts of the target pids.  After the setup, the function
invokes damon_start().  If damon_start() fails, it deallocates the
damon_ctx object without decreasing the reference counts of target pids.
As a result, pids can be leaked.

Fix the leak by putting pids using damon_sysfs_destroy_targets() before
deallocating the damon_ctx object.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5aa23c6545cb8..107a28557afe2 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1519,6 +1519,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 		return PTR_ERR(ctx);
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
-- 
2.47.3

