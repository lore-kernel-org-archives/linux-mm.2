Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7B06072673
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xc/lpKFD
Received: by kanga.kvack.org (Postfix)
	id BE1ED6B05C7; Wed,  4 Nov 2026 14:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8FAF6B05C8; Wed,  4 Nov 2026 14:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58B36B05C9; Wed,  4 Nov 2026 14:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 852C66B05C7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:20:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 301CC1C357B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:20:24 +0000 (UTC)
X-FDA: 85398402768.05.37AE329
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 71D8710000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:20:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Xc/lpKFD";
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDYBcNUn+VWuCpTwTZF6KvGO9475Dcj2RU9o+tvUNt0=;
	b=Ino/rakAR+8oaHkQ2Tm/BSBPcX2j8J+4ukwaqf3FrAghufz6jXWZB+Eo2C4G1EvlgMF9MX
	FEpvyoyAyNRb7eb8QRYECvjDF/IfJ40D/YjMjCFJ7PPQRPJuGHUF/A/P5eG1ehQl8W0Pn1
	B9LFlVHdld4Xh6PY/okk8o+BsrHrVQE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820022;
	b=Waf+O/4P8Qnk4k5e9T92CmJR2w3R16yTERgaEZsdhhfd7CQdHW2ToTcsERBLbRRJF88gzd
	XLflEylLPvVHJc0ZnwCAon9p+c8LE8ZjF8Wrqb0P2BXOupM+hDO/Wl64LNjKnXhKzC/Tck
	MejwJueQRwEMgj9uXMFQ52Dgk9T/6bc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Xc/lpKFD";
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06D7E60D89;
	Wed,  4 Nov 2026 19:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53051F00919;
	Wed,  4 Nov 2026 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820021;
	bh=bDYBcNUn+VWuCpTwTZF6KvGO9475Dcj2RU9o+tvUNt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xc/lpKFDn4s3PLh92W7MP/0EYRbr9DtSlo+aTgCoiS4rp456CG2OTm4mdzAcBJWEq
	 Ldjk5qAoEyhPyjStEGoJwwsLF6muQudRMZSm3dpoh/6WOOqikDwAONtjMuVpHReos4
	 Y67yz+y4bnZfnPjGe5X72XzUWZlpcgaEPlqDhTQSTzjJGylhHoAXVkmsvgtRloeENx
	 Ezkm9787vd7BxlmMILJww46DT1dWDqRcMPOg2nMKQMVCbPmPG41MkkecEf01xpeInf
	 S+AV+2Ll9y4McQGjdLnxElbFeubshKJGcRNGF7y6UPi9zZBWMvJNlUtStZmpr1zHH6
	 a4kGFVBEfnA0w==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 17/51] s390/dasd: don't look in front of the buffer on an empty write
Date: Wed,  4 Nov 2026 20:20:07 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-17-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=952; i=brauner@kernel.org; h=from:subject:message-id; bh=vNxDJDpmoyfXJahneUuQ9vEH9eL70g/8w71rNTJgUxc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnywlMF3yW3bTMV5otIz0k5cNnaUnbRb6akLs2LWJ ybd53uyOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyczUjw+J7+6Q6zp3ZqLzq nmj5ZNvI96xHteJ17jyP5eFsniikWcrIcPHN7+NqVe8Wda9KbvPRPx9rN23XpqQDn9ky+1XSGSp leAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: h9u3pgtohn63zaaxopznk96gtrzd394m
X-Rspamd-Queue-Id: 71D8710000C
X-Rspam-User: 
X-HE-Tag: 1793820022-189097
X-HE-Meta: U2FsdGVkX19qqG4J4gKXp12Yr13uszr8wvf9eVgTSPZVkSycZ1Vz7VgWYHy+Nj6gnA/wYkPISWiWKEEnNQWr35aScGAgGXb/7V0HrEfMrbx5UqBiN0Gpv8bxMGF1k1/zJD6EK+As7rssS9xiW05NFXYs2k5kOzYxV9iCcBa9TFnMWeL9aSTR0F1pN3HTzw7CL9SKQqzXetUyv9zJvO54uhZsz3eShzleLosqa664sucGu/b5E9/paxM/CZrqOM5oCzZT4wbuxnPYWerEbrj5ewNVmkohKQeU5YyysCSz68XF4W6irYcopoWhJTPJ+LTTt1DToCGMN9i2V/xvncw1eyC8TviW7jieC+A7cvPYDorWrweN34ceTvleJ/YZLR5zw1HCrBc5E3Y5LRUs2IRZTOUKN8+TMI4WYhm0x+gDNclPdfKXoY4Jje1ZmWAVGvBYHNYwi3PAqVzmSbwrY9Xo2E2UIEz1SunfUcL1upkCdM9ztPWq68kyVO1iNGjR0M0gXRYYV7CxZzsVFMQ5R2BEiGbdP+BD+hiRoiMSGhX7zU1anH/8zjXfWjk/aF7P18mhh0rwYSPUDrPSpnHR+q31Y8cYRAHvUS/fpcpJlVlGR0cqbOfEg86J+yISryGKviparjOu3qxkd1AqhdLRc5RTMEcPqcCe0z37pZq/voh1TUX5ovIAxaWq3mP6SJWB3e3hL/5+OKbcMTzc96S1QatbQnwu2F/vTbmsAl4CypgUb7esta9hueog1wCXffEzT6mYRsyS0TpVVCfk4XE7uHHDJvYCoy2rfmEQ3BHGlDGV3vsbcvNSD820tQYvy8TPWMQ9N7acFJVlurMoKnCCoRNacsoQDZ0ONMcftB94CehMS6BMog4HNMaCZc/uRZjynIxMw89pBJKJ3cnrTgnToFBkHk6kkeEPY4JS1CJ4fu0N6HsAg6AQc0bRxoD5NtY3L3Bb4Qod46YsJCenXv8oj53
 wifSnsnh
 d0e26H23/NrWo16OsAqzIyMDWf087sJSQLRo7TCsE2ttSZOa/ezsxCgaQwF/TVC5UogBz4TMKCzR3/nQvA32QLNohFXIZRpuLm7BQCzqBXkODxie8ee3gWSpJFuDBu3TPFjsHEJvRf3rN6Y7pKpPGRx6K8a3pmZRiOyW4f/j7VTiJX7Bb0asV0/S0MTFGHgsbCNLAnrIrItDGAJ5vRnRVer5CWvTcpSmHaBcxLQRyMo8kEqrxR6o5w9Y7kPURfOFIaMm48XcoxX10/RHZE+8fqN83WbOgKQCXQN3BFJRHFniLugyOtHC8PBOTCA13s6hNedaY2wbujvxa/gkdYuMk6iqeA5gmqmr8TNMPn8FESA5zejrYxaKZOXbHrZV24TA6g0tx9GQaS2UVDR73nMBOnhuIkTrWIOHI58OLl2Mgn1z0Z8hmk8f5Ehcixg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

dasd_get_user_string() strips a trailing newline by looking at the last
byte that was written. For an empty write that's the byte in front of
the buffer it just allocated. Only look if something was written.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/s390/block/dasd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 2ffe404b890f..e97891e58957 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -933,7 +933,7 @@ char *dasd_get_user_string(const char __user *user_buf, size_t user_len)
 		return ERR_PTR(-EFAULT);
 	}
 	/* got the string, now strip linefeed. */
-	if (buffer[user_len - 1] == '\n')
+	if (user_len && buffer[user_len - 1] == '\n')
 		buffer[user_len - 1] = 0;
 	else
 		buffer[user_len] = 0;

-- 
2.53.0


