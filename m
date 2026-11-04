Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5012C606EE9A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nuEE//0p
Received: by kanga.kvack.org (Postfix)
	id 5B8336B05C1; Wed,  4 Nov 2026 12:50:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568696B05C2; Wed,  4 Nov 2026 12:50:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F986B05C3; Wed,  4 Nov 2026 12:50:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9DF6B05C1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:50:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98313C030A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:50:37 +0000 (UTC)
X-FDA: 85398176514.10.FB9A32A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id BDC36C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:50:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nuEE//0p";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9+kMzHwjVYuWJQ2+obB/IGMwn7xV7y09JcSQ7GHv6w=;
	b=K7BhZbOuWwRgBIzCBAoYBKZIK4GHOdQ2Gx4MbcPc2v7Gce+p8D6Xxh01NNtOnQTpWm+r80
	i58J8mC4zFEK2CUdFW4TEhXZuqD0GNV6+Zt232Tec2fvcsmMx0VjNiTeZx94u1fwXN8gXh
	WzG93meA17DsVfQ18c7bEfJJpMw1p60=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814635;
	b=1sYbl7QEXTrgLt7z/4Xlxd8BP7HW8n+VHftRTSebm3SrHRh+BCU876octT0Q3P654A32/R
	ik1Z+ogXL+dQn5MNLHfMgMDdxbB+oXmCzvd5OPQcFpRrJkHj07mH2mvSytNrLzEH9ojMMm
	/V47M9LeSV0bg2ER43m04vbfGwRoRqM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nuEE//0p";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16565410CB;
	Wed,  4 Nov 2026 17:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1105D1F000C1;
	Wed,  4 Nov 2026 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814635;
	bh=p9+kMzHwjVYuWJQ2+obB/IGMwn7xV7y09JcSQ7GHv6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nuEE//0pTMjiN4EAckF29THCaCp8OShYg92gOVf7lMyKvCn0dVCXPo4XEmIgwbvrF
	 mgNMx/eNkGPYY7G6H0/+5Z2vYWnryKoGvrqXmpNUIJXHh7VRJoCJ9vZOSJMA/OjJoT
	 8z6LvY6TdWjfMQKBqFRTF1g7G5I/em9dQz+ebu6Y4iFujPyG6kD5aM4cOhxD5zLdkS
	 0mLt2so9jaXkBdOELDLBFZJsYTghdzOgcrQCBh4fJ1VVmpw1xBKRg75vKt5bYd5IUj
	 +CjnJztBrPQd0ybc2en6qZmMR8GIuV6NMVYOONgqhfspT52PI5BFxqfGvNedHL80U/
	 rS6/W8sLjdi2Q==
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
Subject: [PATCH v2 21/51] powerpc/rtasd: zero the error log buffer
Date: Wed,  4 Nov 2026 18:47:07 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-21-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1050; i=brauner@kernel.org; h=from:subject:message-id; bh=mkSbMC6ZDV5f4P2v+qDezcMlza9tkw/MXVPMWZSeje8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrvxY+J+keMVs7edupnp1Ff4+Ah738HHuRv3nhU1l bJwbb3Q0VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARpRsM/8P+v+y8bZx29NuN hw/PunmnX07Un1++7juvb051byL7qQCG/6n83y77TZpU+sZ0i3q+d/jTxn/VP3mKFCceKbEpuaT 1nAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BDC36C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: dhhdmd885ch8fqtma9ky97huw7aj9ikc
X-Rspam-User: 
X-HE-Tag: 1793814635-918358
X-HE-Meta: U2FsdGVkX19deZH96qyLAeWEAAQmdkcDuUTJV6ab3D6KGq8TRo+Z2vp0EYRwHJdRTKuaTb4UWe4LZWawtzHv+rkyaVknCye2hEM8VfJPWKmxtby2/l3fPQ1Z5tVYKvDadYoKlWr+r6RPq0tKEp5fzIQYPqSTffBnhwH5upBciBPjSgSOETSx0QnYjj71i6EF3WqRxaSg2Fa1OsoOgQ6+TrJgVxymNslxiu7leZ3mpYmInllLnjsubird1PY9ysCQtqh7bYF7CV4Sh32iKNIO6F61NctYN4vYi0oDd0NO6/qlZdGJNdhOJugeaPZvXgBWoO5RlYL/jL/ppR7QJsIk2+TEZV1APhl9UGERFjntvf3kPzyJCM6ibC0Tilq5216zH73ScJKvUr34ITGTjQhgZKEpgfWSOGWHf5VAbJr7MXgWOrnrpfgz/k3kgI0NJwS4KFcpa0r+Pd7uWGDVyp4zGCw9L4a+nhpKHquaSdwofiNlN2Ma1v5YXjhAe5BqBvPQizI9dJAgRpCgDUq2bOZehKFrWGahrG0uEiYt4m48eeUcUjjZGGjGg1w0P1hOFLDRAtAqcXh0KXawNTPMsPn96U58yjdaJks+kVrzteLBJzFg4WV4mxHxlOBdD4olpxv5zaaRO6oDhrT+PtIrJAUzWOgf9cioyMiaJeLQ8soxW7EgXzbQx/cJ2sW/JoDWy61H/PvsqVCYw63dJsj68BL2sNWQnc+rFHrETTA4i938TFo4J/0BI9zN2eXFy1PU4ekc0mcSvnFhq0CGPOPleew4OeLwjHR+56wJwDJeNXbiwVawFZZrBIfBJ/ImBmnyocDvMqsnEgP+Ob8lKzPYZ7rJYk3mfxCsBYNndB+FFEZkxAMG4iujgyAlFz1CZ4tNFRLohKvF2ZodavG6zqRaFlcJSrmg4+UgWIQdRzTV4yWnmLoRtLGBbKMdDqUFGqdpGadghUeKFSY0e8AtBfcWiJc
 erJ8ZSgi
 O/z/ZFAkkUluRwpWiD9QXB9QytlspnO1pIDp1IW5sdba6gW+ia6zAWDzycZO+3ifxH8dXvujS+50rO6mh3Jxh17hUnWOuKWc2PXo181kN9TnYLCZhHCFBZHzEIlK0vPYuabXZIEqrf2dPiFcrZimAdBxsA2uP9Ore0Ws+n6dJb145cChzNjZROUWffAnU9lz4Rsq8GN9TJ8K4Y6ekImiB3wA2MpR6uvXyforac5TI3DY+/4xmwhimmgVXEj4GLwvvqBpoXT21O36TZA44krY6LP0PCfgFqpcuTaUcCadWAIkenlXZN/1Ye8sdcw8msqQ6KdQKWYI7ofchz4LyHaJ8f4sGDHdYIORglWTTSAwA/nE61fruWK+Bf1iaj3cxzrQwNops978doY8+2DRE/G7bqnsxIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

rtas_log_read() hands out a whole slot of the error log but
pSeries_log_error() only fills in the sequence number and the event,
which is usually a lot shorter. The rest of the slot is whatever
vmalloc() left there. Use vzalloc().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/rtasd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index fd40864bdb70..dd0df5e164a3 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -523,7 +523,7 @@ static int __init rtas_event_scan_init(void)
 	rtas_error_log_max = rtas_get_error_log_max();
 	rtas_error_log_buffer_max = rtas_error_log_max + sizeof(int);
 
-	rtas_log_buf = vmalloc(array_size(LOG_NUMBER,
+	rtas_log_buf = vzalloc(array_size(LOG_NUMBER,
 					  rtas_error_log_buffer_max));
 	if (!rtas_log_buf) {
 		printk(KERN_ERR "rtasd: no memory\n");

-- 
2.53.0


