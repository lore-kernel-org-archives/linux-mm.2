Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6A0AC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D4E6B00B6; Tue, 21 Jul 2026 10:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DF06B00B8; Tue, 21 Jul 2026 10:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534F76B00B9; Tue, 21 Jul 2026 10:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1631D6B00B6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AF75C0186
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:19 +0000 (UTC)
X-FDA: 85012981158.16.0531BB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD34B100016
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MOJyNJXL;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7Tm4RCgUtWKY56+njHwkepgkA9xUFGEGOQPYsg9B+o=;
	b=w10xIkpDHq4rzj+7yRw9/mnSa1fu+89bzaLP/9zKH7cS9ItdQ/DdtNokqpqy9XrdWPhE50
	DBOs9XonX2FwwtrtBPYMuOZmnvwt7/xbJAYcWX0MEy1CAfInf8Ncwg2Ie7ywccoxKQNluL
	AVjTHjVt7KWPgbPLs8lKPv+0f3qjVWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643317;
	b=eZMIPblrh340Bdw88lQGgfqq/thUGIJyY6pe1hqqsec8UNN6QGsn0+hS5BunieihxlUwPW
	ZQDxvWgesI9ZXdRaGbeBy/vcy6LiTrWsjGnZl0XUA+qqlPqyIhBqsympOa79p7C4SOWXwf
	CMhj0mSzL/QkVa6IyJX1t3nxDa6Zw9k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MOJyNJXL;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 157B040181;
	Tue, 21 Jul 2026 14:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583231F000E9;
	Tue, 21 Jul 2026 14:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643317;
	bh=/7Tm4RCgUtWKY56+njHwkepgkA9xUFGEGOQPYsg9B+o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MOJyNJXLyGpqijpk5v4ODaoFMiEL2VlKtJbS2YgccRyIo+QPYy4pGlpnVv22/WIoe
	 Us/lCcqvKRy3k6HhsMMJUWjZwFgVgZ3B0tPD9Y8nT0siA37E9/Mn7NxXtkB2/1yxRt
	 L9iy90GXi6/AqXmPj7LtrD/7lmJqXuxNkZaQWDhqlRo3vIethdvHgGmAdi+03/XloP
	 sh+iVi4VaMO+2hfxh8avpTfySYqp9ZNSV1W0iMRtiawheSl3ybMoVrsEjEc0hng3Yl
	 aITQLLh/6lYx8GuZsWVZkxfvFTAW5YThwBJ28Y4nsklf4GoAX80Bb938foq/ioDV4q
	 vU9VdMfY+f3Ng==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:58 +0200
Subject: [PATCH v2 16/21] binfmt_elf: consume a stashed PT_INTERP
 substitute
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-16-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1448; i=brauner@kernel.org;
 h=from:subject:message-id; bh=64u5m6QOKfkJeGSkjeAlH+MI9emFWrAvETsceMdnnkY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x245hK6iIlZa/2CR9yPv6ad4PpiVcAxLWDyyuvvn
 Gz3Pv2s3FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARjcmMDMtnNG88blWx4VFA
 6+yNFdFKj3tDeJpjv0XdbzeP3tv1/QHDfx/d9x9mXWcPvaS2bRLDXP/nrVJxu21vymXoHs8p3PS
 SiQcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD34B100016
X-Stat-Signature: 1d7q139ogq7q1tbpgey69sfznr5gnxhi
X-Rspam-User: 
X-HE-Tag: 1784643317-304387
X-HE-Meta: U2FsdGVkX18RkUpShiFjmTWaJwkPEo5NNaH1M/TUapZEwuKBW7AAnGZUF9jCO3JOOvyVJvQJr9rC0jfHNwD6FTtleL0Fv+vcgWwers4gzikL0qeWoUN3ViXqed62EJehByDw6+K4/x927kzNyyrqb4R2rAe4feZkqKZ+6gzZz+kbva9RT4BJZdIubcJGqGri8KW06RIzH1TVmENXFC+mAxAbtzvEKhWtlrwHri1EiFxtick1qp1lGk/TPdIIUUPOaLXQYvYPXfTF/ardbirb0u9LkgAWypiGpBCboKnJIuANY3j/d8TVCQIL1f+B/Ygo3uIeNP+UTmLnZJJWVRYSPe2MUx4qF/N+CaQBstidihMPNOqvCjBPA5hsIrVQAzOBaWBwSyJI8QFEdCScpAWCu4bYgo1lQZzAvF9hsi/YHwsOpTCgXjGWPQrBN2EyCfyJJiPhQigX9rMsejAb1fr9JUbX8qKSE7gENdwD2uJg7bU8fsez5hb6/U6JvbSftbVhomaqjqfJ1PVfx6XUZUIPW5hlycyHVA5UaE2iuAPRI4mKKH2T7Iqq+1oxWWy0cx099RbfEU/CHmBj1i50bOoeBYhxevuoPcdAC/TuiCdeyGd+AmQPJq/GrrS+FwWjxZbnRXc2RuFUlnTI2FFTIi4xjqE1aHK+B4sBoG0+AtG/YVolL3+JMc6on9mczMfwRJGl95b18MW/OOebnIuGz99jIYBqPhBsbSHVtsW9dgR5FKg73GVbAdPFmkwCaifUqlIBgKzhs2osVF+h5tcX3i1XOnoOPlYapVHUaWC2J/1XVdOnYZcoFP6q70yUvCG48e2P5O9AFGmyIW1OggyEKlPRl9Zgd/0oJuS+idAz0eXoCDqpbLI5/Ws3jlV2P/Ek8WLmLL1qyRR201Nqix7/OIjkPqwANjWqFtd2ottCzlT99EaJgE32hvDI5w4U7TaEMkfMTK1cMQdH9SkwAs1nd2k
 kE3K637D
 VKeMEDcESM5TLk2vLWkpnZGGesoeeUnt64VBVhBh5Lv8xPPlDArzO5u64gDlJMMuhDKHk+VVuXY0h9XDGI3ygn+D6Ax5PYAKoeK5GQ2C8OCWF0T6BeZbVHZ1y25Yex+mxeg0pQcJM5rMkpAWLl8U9jyrqW+/eCNsNKz9ZXy04UXvCXNHugc1mivKo4dOL4wnehVU1ly0UmXCl4H/izIlIEQYJRNRx7xF/gjITlSrllh+6+CY/fthuWLDMWy8IdRSf2hJIXLUPFHqprhvU3l+Wz7J6f9hpS65fHqBBQSdAAIDsCvy5rmxgGT9KsbHJcs5uC4WTk0RGCP3L8sA76sy0Wa1IVk2OL20ah8BYbWVr5MfDHw0yuasWu5Vu9kHtcvO2bQwhhKUayhl1H5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a binfmt_misc loader entry stashed bprm->loader use it instead of
opening the path named in PT_INTERP. The substitution deliberately
changes as little as possible. Ownership transfers into the local
interpreter reference which the existing success and error paths already
release.

A binary without PT_INTERP has nothing to substitute for. Drop the
override at the end of the segment scan and load the binary natively.

Nothing sets bprm->loader yet.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_elf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index be8fd437b5a3..00ff35cad441 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -901,7 +901,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
 			goto out_free_interp;
 
-		interpreter = open_exec(elf_interpreter);
+		interpreter = bprm_open_interpreter(bprm, elf_interpreter);
 		kfree(elf_interpreter);
 		retval = PTR_ERR(interpreter);
 		if (IS_ERR(interpreter))
@@ -932,6 +932,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		goto out_free_ph;
 	}
 
+	/* No PT_INTERP to substitute for: the override does not apply. */
+	bprm_drop_loader(bprm);
+
 	elf_ppnt = elf_phdata;
 	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++)
 		switch (elf_ppnt->p_type) {

-- 
2.53.0


