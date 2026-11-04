Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FCA9606B207
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K2MBURx3
Received: by kanga.kvack.org (Postfix)
	id 2B1656B05D0; Wed,  4 Nov 2026 12:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239056B05D1; Wed,  4 Nov 2026 12:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101BA6B05D2; Wed,  4 Nov 2026 12:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D99816B05D0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:53:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69625A0782
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:53:37 +0000 (UTC)
X-FDA: 85398184074.01.65E765F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9C68F40007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:53:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K2MBURx3;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKQgab6F/A3kQED3xQkQ3++bbO+NbqHo8+XrgOES7ts=;
	b=ogJvVlERQA1iHsfoWcYwwROLocZu2mNa95OeLcqtTtVxVvAtKpMvpAfOmB4IGiPzOBal3t
	6+AjuM3cQ4yBod3YPha+K80VVA9yY55RDqaa17wlD+Gvqz3qJg+2dvodAj8c3r6A4XKukn
	/MLswClygmlWOr5QF8u4k5RjSmVBCOc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814815;
	b=u6qRz2iBeb6xxNa60k3Jol9kO8AiB6/GDAizrMOUnHaGk7QrNAY+czEosMfJnAwQDFMa2q
	dDtxMk+1gJCUsLTX5DuaBv7meNxxTqvmu1N5tgkXTh5brQ33NPlwnf5ImKmHXzvgaUZmSl
	Gbs5hD/QAYJdjhDq6z0SqlVDE4cyjQw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K2MBURx3;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5ED2401D7;
	Wed,  4 Nov 2026 17:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A771F000C1;
	Wed,  4 Nov 2026 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814814;
	bh=QKQgab6F/A3kQED3xQkQ3++bbO+NbqHo8+XrgOES7ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2MBURx36IjZzkcLb2KZAEwlpj6Z6rTqm97dO+7doIkZr1Kqzh3uc53FtsyC6p1Qp
	 E8Af1CfcCZKJoPDeo0p3M/GnYCJ80+n57IzNLCGvu4Bk9CouKYGn+orF70IL7nf4yK
	 nSpBJriEksHHTVFnNpFK4ihBuIC0cyx3Y7QU8Dbel9oqxkaIvG8hLqBlKw9PD83NvO
	 Bpz6mm+6hDo0ijhkfwkqF65V7CvpgQI6W9+n1sejUJ9eDCv5Ck/cp7SLlpsYIc7IQv
	 Zd1bVKw2snQGORVqHtYYXf4KLvRRmu/GjBV2fT+bsIs5Xg1tLwdr852VnqimxYBAh0
	 3a+pujJgabI2w==
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
Subject: [PATCH v2 30/51] net: pktgen: reject device names with a '/'
Date: Wed,  4 Nov 2026 18:47:16 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-30-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1684; i=brauner@kernel.org; h=from:subject:message-id; bh=F9CLtO30/n/hY0YqeSuPpMfy319PBmjhBXOfLkB61UI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9znvCdcJ1NYf0fOujSQtemwvu3bBBpcRumo2Bz5Xi5 X/ThD8YdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkbhIjw/Ob9c5r2Pj/Kk6s buYtSBDaVZfYmFppvu/Y99lhKbqyPIwMMz2n+1lZtz+NPHGpn+1Yf0m55kdBz6TyQ6z6D9ifhZc wAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9C68F40007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: wmzrymwznchbtc67jcmk5th6zxw1aozp
X-Rspam-User: 
X-HE-Tag: 1793814815-919382
X-HE-Meta: U2FsdGVkX1/ez7lDG0ux3gKKEfKsuVO7F9g3tkFKmSZDpCPXGR1+ShlJnRHX31CBasmatwVZyZ29HWS1hw5OAZI08wRG+1FtztfjSzlvQYO+yBm5AjKg2eYd5rCypY8bB7uQlsW1zjjgFYDhg7cK8QVugrXseVjAMCNyQt0BG8DUM0cPwZcYQOdCXsc27Ip3Fp6P17GUIJHQSXsbhnDpFZiUvpxMdAmMa1Z0Ws/LXEOj4M81JVOgD6Ao4Uj/OATNg78Um9W5T6VTMF4Lp834G7JxTe9vPzOkhf/miYsFqP7L5vEl1E6L4eDqIxqfNdRqT/r9SavB5Wma+vb97gN71UbmBYAFi22XTYVnHiA1AdlBRCifrH6KERbkGA4oEXVwTxoP/V/U90qahqAyYPTy2Dw02AAjwHnvTwJBcR/6xiwv7SBwljQsVaKwsc5Rx1KPeLBTtOCmccYSYrxefvztwD0LUi/ZcgLsW06uutFUYO1cPhxCHdVjcTPQ2ScVLRVlWAPDM5q7DDlzOvZN/sv14/3b1j1OUgzTbPkWhqV7f53SX2QcDEtitFRzw4VgxFS8cM6/smyiPZxhiOJhWjvi3s8FwL9i/pULUCE1aMzQMRXWrpi3LKoVtwuAIiWA6jQCC6beCSnZ+DmlEetb7Cs87fHRYzuBbxnDgwJkmBu99+VTzLSi4tMNaCdQtl6j5R5tsFNrECyVbMKrtDFwNfv8fPO3rfczJuWwBvTkygBF5b/cF9jiY2FtIwbqjMDOBPhHskvNWnhAIZ87Ei7B8eqP1j2dR0/TH1cmBfDidcSuw50sXJpgKKZOA492E+3MVsJzjDDx/Bq71kTeBjq+dW49hnZKKKZjwU6OU7iads2Pdbe21MSa3vPBJ7XV2Oyr6rhYLJYW39I73a9VJAf6QUkS1DW6i2gs1tXyLoxmplE6fhbhlDZiFNtiTqgXNkDiJA9+ZaY+kC1AJMpwHef30xM
 k6ng4H7Z
 gJ0crpcKpD8217gIeuxTR+++diMgubB3Bq8st8x92hkJrEjmPHVLedmGWZJjKnE476uSjD54v16DHbWQY9+P99KTmHIrovMptN699DWjLfVa/WDG6IYKtnRu0QGIfUdJCi9qEBx/q0Mbr0b15RAE7K4bCyS+AfwJhyJHSAl9fjCByzIuzVeNaS5D7pEjYqZuFkwxx3Dz0Mq769kLjK+6MDWfEdiG8mlGmRDaSwCyh30FlnkqdJluIUwcEx4h0NZFidgXjsqYCNNsdCWrc6Wv2joCplR54sMjLmDfZ14Z+kYvM9RwFNaXPn7XulwK3tTykzQ5reHtrQqOEATOTv2fSgf4DNJGne1VOnAGfhthYFbxWmITAzr7fDMz6DhWHORyRbh+Sm2Lk12o5wDTVwYZF+nnepg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"add_device" takes a name like eth0@1. Only the part in front of the
'@' has to name a network device. The rest is free text and all of it
becomes the name of a file in /proc/net/pktgen, where procfs takes a
'/' as a directory separator. So "add_device lo@a/b" makes procfs look
for a directory "lo@a" that doesn't exist and warn about it. Any user
can do that in a network namespace of its own:

  name 'lo@a/b'
  WARNING: fs/proc/generic.c:174 at __xlate_proc_name+0xb1/0xf0, CPU#3: bash/241
  Call Trace:
   __proc_create+0xd0/0x9b0
   proc_create_reg+0x45/0xf0
   proc_create_data+0x77/0xf0
   pktgen_thread_write+0xd8d/0x1750

With panic_on_warn that takes the machine down. And if "lo@a" exists
because somebody added a device of that name, procfs used to register
the new entry below that regular file, and removing "lo@a" freed both.

Reject names with a '/'.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: e6fce5b916cd ("pktgen: multiqueue etc.")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/core/pktgen.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index d63eeadddfcc..02af70d360bc 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3831,6 +3831,10 @@ static int pktgen_add_device(struct pktgen_thread *t, const char *ifname)
 	int err;
 	int node = cpu_to_node(t->cpu);
 
+	/* The name becomes the name of a file in /proc/net/pktgen. */
+	if (strchr(ifname, '/'))
+		return -EINVAL;
+
 	/* We don't allow a device to be on several threads */
 
 	if (__pktgen_NN_threads(t->net, ifname, FIND)) {

-- 
2.53.0


