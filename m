Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072DE606CA14
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ay5fDaWt
Received: by kanga.kvack.org (Postfix)
	id 3447B6B05D2; Wed,  4 Nov 2026 14:53:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31CE26B05D3; Wed,  4 Nov 2026 14:53:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233796B05DE; Wed,  4 Nov 2026 14:53:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8206B05D2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:53:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A22B0C0866
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:53:53 +0000 (UTC)
X-FDA: 85398487146.27.025997F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id ED914140005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:53:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ay5fDaWt;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4E5LhgvAcYWZljBgO/W1U3MMJwdn+qZCE/pQraBe8U=;
	b=qD8nAndtyLMcy7q6nX4Z4VzitHJztS+Lzz49p7cujuhSbCWqDD9loya+CDxDWvdWZ2FIfQ
	4YIFT8Myv9Z1nYmbv4Io6c13yeBan/foH8nSBv3rxeIaatDf+89h0m7AhRzEiovjY3iIOL
	R6k/MPg0YG28aP1CV8xLEAg40TSkMm8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822031;
	b=q6afpU2LR/C2RV91jBeatvA6DO8lA39Zy4b2C8Qeszzz3liHKte/V4zv0N56oNcIet3WAX
	dmQOkP/aRYrbSAHUPaj9znaSjyrylrmeDgNroU6eHJxBkeCH3sxOAp7DLVeaesumMFbLLF
	jQueGLA7fES7LBrikB7EDy/QeRgHyIM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ay5fDaWt;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C9C660F33;
	Wed,  4 Nov 2026 19:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAC11F00919;
	Wed,  4 Nov 2026 19:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822031;
	bh=f4E5LhgvAcYWZljBgO/W1U3MMJwdn+qZCE/pQraBe8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ay5fDaWtG/yWIDOYM+DggFzTN2LWbh0BW6otP+jIWAHXSuBEsVaLRZz5ZGfpgRvCE
	 6shldu61dY4NwBfkCYbw7q4cTqz3itoS1DSO0jJ/m80wdS5Zd4cXDBc3qovYZ0srLC
	 U+IQP3Cf9hMAd3vazbsilUbA8DkxquoHSwEkBJ+7nEkOcCIfxO9SZLsKEJkxUQ3qC/
	 DcxdbWZq7MCNC9JXaZdePv4FyzB69QN2POFSFhjzDTIlCOpxPJ8V89Q5VWoSMQ/EHp
	 J1FcUjC8ycDtKpuAOuzPui/5hlEvRP7hunia1FQ4b8dx3JEke6caIeMQIFr6OP34Hm
	 Nxddkhn+cC83A==
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
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 16/30] profiling: mark /proc/profile permanent
Date: Wed,  4 Nov 2026 20:53:37 +0100
Message-ID: <20261104-work-procfs-fs-v2-16-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=817; i=brauner@kernel.org; h=from:subject:message-id; bh=G0gwYdZ16oKFC7EZJsDlPxepqJg/P4CRWLJP6izrYeU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97rGrTu0wWKSzkuXO+Urv0AN64bf3zr/V5uClEO3wY I7J/p1/OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyag7DP5V5JQ833nexiq6f s5gt0f6uqxUzZ/T9PH2FDXJ9PK+sWhkZJl1nDLj2O2fpAYUv714J5enO/mdzabLGrvDt7b2/l0U pcQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: wk3o9y16z9na9y9gf3gwommufsjrzkw4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: ED914140005
X-Rspam-User: 
X-HE-Tag: 1793822031-438914
X-HE-Meta: U2FsdGVkX18p0l70/EYo4DMvqHK8NlPQOsM2qNBJkoN4oryr8l3GRy8s4ki/yzzAvFV6DqIBVek7kNVT6IlO3poKSpgZzrtt3+rI1m6co9U5RPgtrVIBFgs1/lR+BEAUD6VP++zUnnf7A3x/v0rbVGGV9XrLbRqKAuH7HVStK36Yr+/WXC+ZG0ks3LcDaBZxaihhfDZ4+lVzgqlqWEwvMl9+vWgKaRaJF/C9SA1BCMXU4mDARTmA2wh7E1w/MIh/2GGnpkeGIR/Wzn10XkOxoJR3Ga3bALfAQFbpKuaIaVR4YzY0XtPFaMnebeRctF4fVgd7lHi9y1vIme6gnwMgyJ/xefh2bicT+l4Rzv6o2bbud9y4T7lLJEWnBw5bGIaaATZIFb26OTdspsOXqj7v9uTsR9WtVHxIwBPtFBs4cnl1Z4yeAX/+HFQ+XzlXgWdoh2JI5XWbRDQbDUR10XkZe3RpdmnfVhRRSiyLJliQJgbr5G/zmHCnjpGairxUnUjTfBlIKgMPUdlAvBCsPwPxt6s8bWktVeSQg9Z7y3BfqS4XbPMjxeVTzN2e2IiiNZH2Q+KdyM/sO5DSzNAcXy4/hrLTuMY6HSVOstZvzvcMoHhR6DllI74dviFbAbuisJZbmpT2VBGPa/wTjLrq9RS+EAt3j7tK3D8+ENBpvuycpBiHdLEBjWwW8qWOHc0EBv859xgazR2RjMsmmu+XHM5nEDXbe7V/1dM/W5S7oMbeCgwBMjKtDE+ozGX8qU9+a0Eu0wiRIPgGDnHv4vuz3M7UR2+9TK93PT77lN8EYvdPj5lGLQJPLyB5C4tgJc8OXSz8QOUNdPVYOpW5II2QvkxXvrRjHb81pgO156EzTV9MAovhUM7y1I7Lo7lLTEc0kaOShfAr4/Rj5tOYcPngAN+9BIZ09Rrb6ngwn+vnPxYBBtxAJv780mdwEUq4G0Zr5cBHVEIQI+D7T/THr5gpFqg
 PvGTC3x6
 nAVp3+XC5eK55quZBRgK+NikILD090eDoK9jwjPs47HD7t4dAlPSkJqUU/AMerb7GP5p//FF6DcKxM2A16KbXg0WV/ChnUZlH7cSno0hMG9sJcl8pFX2yndz4QHoST7dSkPsVOLJqauUtDWYi4ct8PrHZfkcRhR7GfQLR4QM8gmEkSH5hvRhGG5R0M1pLyT0dsMO/xpMVY6YL1Xpyjv15thAHJ5mdmWTIADLyI5H9+EyWIqTiKocVYEau4yJgsNgk4T3jc6qgzgtrME0khDV32Q2MsdOAYNCtEPiR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

/proc/profile is created when profiling is turned on and never removed.
Say so with PROC_ENTRY_PERMANENT, procfs then calls into it without
pinning it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/profile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 64f6a45834b1..0c2672adcbb5 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -203,7 +203,7 @@ static ssize_t write_profile(struct file *file, char *buf, size_t count,
 }
 
 static const struct proc_ops profile_proc_ops = {
-	.proc_flags	= PROC_ENTRY_FULL_READS,
+	.proc_flags	= PROC_ENTRY_PERMANENT | PROC_ENTRY_FULL_READS,
 	.proc_read_buf	= read_profile,
 	.proc_write_buf	= write_profile,
 	.proc_lseek	= default_llseek,

-- 
2.53.0


