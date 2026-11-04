Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5EB7606D80A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mYzQuqq1
Received: by kanga.kvack.org (Postfix)
	id B88916B05CB; Wed,  4 Nov 2026 12:52:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38906B05CD; Wed,  4 Nov 2026 12:52:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFF56B05CB; Wed,  4 Nov 2026 12:52:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FBB56B05CB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:52:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24B0D1C4196
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:52:32 +0000 (UTC)
X-FDA: 85398181344.10.3AA520B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 560D1140009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:52:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mYzQuqq1;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yb3WLcVokXU6BuV8DQIS3cnoxrtkXR+HXTNSt4lhnr4=;
	b=STp1sRK5nsHoN8fjf1M3aJMKlzKbqjFhjGk31UCJMc82FZAbUtIqGpqatMIRz8xQTUPW3e
	VbHfz3q9GvMJ3cMq9FxXlkpcaNCFHPBvBEbHC/M24jqHP4owy2BSt+9d8nKupEoXwwJ56N
	vpkrVal8CyxxeCpZThPCoj1BnyZrF0A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814750;
	b=WI/UxBjk2iHOgIfj8aMYZ6dRJl+VETPJuXt3zXbfDJVqpOwnSjofinSNFkr9Ip2DLA90iX
	O3TkYeDGr39sm7qdIwtJzhCZVbH9RHqYRd7blxRNbzu7AS3lh80mALNsmSaR8Ji/v9aIrd
	qczPS/4pLIer8BSKWUCLJRNHoXbkMb0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mYzQuqq1;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BAB8434A7;
	Wed,  4 Nov 2026 17:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5214C1F00919;
	Wed,  4 Nov 2026 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814749;
	bh=yb3WLcVokXU6BuV8DQIS3cnoxrtkXR+HXTNSt4lhnr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYzQuqq14/wTRRzzUwsG17Ab+8tgoUHpySPnl84Mr25NNzcLhEp7Tq87twOltFKtA
	 dLD4dH0S9ylQ5twpfaifjPBB9F9nLw9N+znijKLYLcOnWkObGODYTAZeChhNq2O2Ca
	 IQI8NCRh7J2BZ5sI7mVRJjsoRWd+WGQFkSSMno0hv8VCeplcjuV9ER78Y79IneS3ww
	 A/5asZFiMwgLRWg3CnX7bPRgzhBlLJJ299YG81hHCGwYVIYI6Vtka99WENBzIlbtj9
	 RDwPxtwzVpVgN2qYy6WEMTlYIhf+ZUrM+RRJ4JaWwLGuxFHxYcI/kP7k045W27PJnL
	 9gvSnUTnaD3zQ==
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
Subject: [PATCH v2 27/51] um: NUL-terminate what is written to /proc/exitcode
Date: Wed,  4 Nov 2026 18:47:13 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-27-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1042; i=brauner@kernel.org; h=from:subject:message-id; bh=wRElBRQ5ywf1BhvCA77KtICLks8yyr6GFoKnZLCCyMo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9znsQFfC+I/C0Ra1Qv94XtoNfmEzj9zwr/ak74frKN 6dmt7y52lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRvl6Gf8ru0zvmyVXlJJn5 RX64VRT8c5vVqQOhHe+XJk+QCA1678rI0PD9gNXt6xMOWujrbTe9wyTBv3D/B9HmPSse+sbVn4l X4wAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6nf8whe9qorbrepehwkfmhuakh6kskk7
X-Rspamd-Queue-Id: 560D1140009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793814750-931696
X-HE-Meta: U2FsdGVkX18+d0v1A5cbDCpHNaN8kQuqqHHr+CpouIGTqJCp8bF6t0CF9IEjEgA0ejrQ7DWzvXXiwyOvnOYKEdNbLwDsCwxfuFmXC+yCz5R3MAs12ECwC+05rdO2kB2KK20OACopysHWaTfTgpEEr9VGz658r1KFYyu18fkVBHtu1cpRxjTtbw+b4RqiOlba7mbvp6y1xEOAi3gTaRjPGrtiNO4KpmMya6yVX0KI46/f81Ddk/Zt4mf+kdg80zlnSp/QDA+/NJdcYFwbeLwbvVjYjFmV6ed5Y/513miy1KxtzbZhmBIR+lESYfasJ8ciw8jOt/GZzV8VbCdKI+lYIc8KiFUy1BqCCXJKcGZf5RdmqNaihoJYfjkGom029LiKwSTO9NxlMlG3UmK+eQb2CJP8xvn7rU1zyGEz9ufVEFhbzx7iANrilMYw8JppHw1OZ7w/4WP7e9HEbNPzA2/9izF4xjIkgkQHwn/USTjfagmSj8Eu7YuhqINX0pybf4g7qO0x2yzKMYovKnF9RBhDJ2q55l4PBPZtqD+CFTPIZGLrs8QHoDmi0DueJMjCQm9oHi3r39KRKPD2QACL5SyPBF/cGLGwtWutPdC1TFh2F2UeY4dy0/fk0L0INHR0pAOsn4vdby3mTtCQSfyhn8Ujk5Hu8bn7iTYv2ekRNBcV+xixBtz17SQc83dZl0uBnYTsF3vgXJGBq7YkHRQc5Nj7GHeAFXimtfy2JMai6MrRtColRynmwHz7AV897fTln/pKlIzKUMU5rDTaXycLIcgclSmUgSl3iU56qHbP5cYzIZ8icpWwIAyouww4VlbaFhpTTzyFr5Z/J7jHfEvU5o1p6HkdtgBcAq9sMXEFM8B6T4SnfKEr4L8Cdsm8BkvujdL03rbrln0DcJ4xsLwPmMwNDxlIP9C6F55lc7/NzBDZrxiboTFuWUly9TSjHtdk0XcVbrh0pd6qEN2Tr2NjWYx
 8H04Og3/
 opkO4/tPE8MGQUz3M8ifNvCWAExVIDvtbdZcFFHZlCzTs33Q2sE72GBPASPpWFzWvFNfGT0ilpG3eDZyavp5VKMVLsWhdeLOQwWoHe+ZoroJcuhNJonkC4zTjIi4ZTLg40Q6gZihoK9fxPsR9V4CpWGoCNBWKJp+ApmC6SQ1Wmx8HQBZ6weJjrMqUzU9Rgk4j5T8ye2zsIo9ZBpt1nUAxjXsN1sJBPzDgGCdrKLYJ6y9+dQar26/+A2pHbUjIvkO0zYnI+4iiZq4Jxsp09e6qvjd/bQZCXW45Ebp/POnxw1ExcD2qAz9Mkg7uI6E8QdBQo7GIgUmU19KBxP5MCdBcEiooSFhjGDnhhCvB9cjtzkeE++bLqi7ZKWdswr0YaejlQROb3+AdCjOoyRri0d1Jzgy7lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

exitcode_proc_write() copies up to sizeof(buf) bytes of the write into
buf and hands it to simple_strtol() without terminating it. So
"echo -n 5" parses whatever the stack held after the '5', and a write of
seven bytes or more reads past the end of buf. Terminate the copy.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/um/kernel/exitcode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/exitcode.c b/arch/um/kernel/exitcode.c
index 43edc2aa57e4..0230354f4812 100644
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -43,9 +43,10 @@ static ssize_t exitcode_proc_write(struct file *file,
 	size_t size;
 	int tmp;
 
-	size = min(count, sizeof(buf));
+	size = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, buffer, size))
 		return -EFAULT;
+	buf[size] = '\0';
 
 	tmp = simple_strtol(buf, &end, 0);
 	if ((*end != '\0') && !isspace(*end))

-- 
2.53.0


