Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3B3608208B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkCvPqeJ
Received: by kanga.kvack.org (Postfix)
	id 41FA06B05B4; Wed,  4 Nov 2026 14:25:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F75D6B05CF; Wed,  4 Nov 2026 14:25:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E67B6B05CD; Wed,  4 Nov 2026 14:25:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 097586B05DD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:25:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 863CAC0827
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:25:19 +0000 (UTC)
X-FDA: 85398415158.22.A4AE91D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C38B9A0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:25:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkCvPqeJ;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlRe6ByN3zpYNOlJQq83OVbC6fU3d9RayIfuGISBpLE=;
	b=mOh/1KuFn6ioCQzTr48D4rm1T8NsXaRdLj2iUi+91x8HoxxJviSYR9Q0Cgmw4JakCu3Nnu
	5mW7TI7knTjXTc0GuIY4nb8SryQBJn1MUObDpOvpz+H3eK5VAWdtil8GTLsHdjUD9bHRuc
	hwbN/J6My173TYCCeaVpy8/2SMX15+A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820317;
	b=S0r3SjSEH+KqPIZYDmWsqY7cFVvvEPy+oMQkKaYT3vsbIsg6rWYox1Xid1CK6cONXL+p4E
	fcw9Srv5nqrezEj8WHX+1aDArtiC9OgIKNkkU2mBkVBjpVp0BbymRtW/kpowEGuozrjDgZ
	kXKcuaQnto/wIHGvhKm+x4tN3QNoe7Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkCvPqeJ;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5ECCE60DA4;
	Wed,  4 Nov 2026 19:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76511F000C1;
	Wed,  4 Nov 2026 19:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820317;
	bh=xlRe6ByN3zpYNOlJQq83OVbC6fU3d9RayIfuGISBpLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkCvPqeJt9hXEFyti3iJ1FwuLHxmLXyjHHLihOfXAuh24SOvF5m2sIXA2UBAh8zQQ
	 tsZTpgZBpzYwBDlu66b4vShl+NYAJTi7OGk2wP7Ucha8AWhX9jcDy7R8S9N5GjeOby
	 MOJMhwZqq5jk1LHpQtOrhu5TAJznkDJyCPku1XJuUlWnmjNp6Lg/pIqjCYjb2E9pRw
	 PlIWcj69apuPJIahs9+j3NJIIhvqdlJy8k5li84RC/zXcbSfahqzG08MO06TAxTgGD
	 MsdlO68zHBsAVPP5uOrOJ4ggSIX4Lm9icnN+egX0bDbSKuctAZGL1q6hKv1U57BXdn
	 DGKynIt51Y7WQ==
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
Subject: [PATCH RESEND v2 37/51] proc/vmcore: don't let vmcore_cleanup() run twice at once
Date: Wed,  4 Nov 2026 20:25:02 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-37-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1758; i=brauner@kernel.org; h=from:subject:message-id; bh=gmON/Vwu30bm66aR7FLjt15bWl4pslPspuVjwp92LoI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvzZL8Hl33wxMMfFJ8kjYsv9ztuaxT/NbubGcJp7u i+Umj2lo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCIcnxj+2TzZ/6BE4al+9D+l /+ZvBS6e1/KbqBD6LzUpOUjjyhHN2YwM69oa4jcaTUuZdOZNvK/7ramu9j/M3Cx9f4RUnOD8bDu LDQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f7gubdrsgqm3qj6kjfzpxbu7if4au9k1
X-Rspamd-Queue-Id: C38B9A0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820317-29809
X-HE-Meta: U2FsdGVkX19iTGypLSE7llVNW77uwylgMY+Dx3+8zUCUFxi+4FAuXoW8WCO3mZoJgBSn0Zojhvem715ehYTyzdQQ/hNabW/kEwreT3pIi19jG4NK5fcPBcQAt7GR/bs0SaI1NzgOu8rFYvDPt08qKBZONJcVnuXNIfM3fmFZt6FSskNRl9I3JJ2TzGw/IJpwDdmmQVB5NKTOCYttnOtISsHaOKaY3FZXTJbWowK621BWfch1e+X+cZt0RenJ6V6xs1RJmxEI0ceHc6mSHbdH4SK26KxGX78Ydg7l6h7qpzqD/V0uFxqLTB0WpWyc5s4T1Rww2lMaQqZISNKvImZWOY0gLWaJoyECtM20CIl45XpTqlDJ+y7qdxn+rOQxe9gtz2pOTTU/NHQYrpzgTBt6NfhXtkDTyov4VtX7FwiZ9lpl1ATCtET2AXeZyylPAMaEaX+jNQosJlId3h73clP7Fzr60ELocqWJsrCYYs1Or09njkuNK9prRQNGv/uSOc/kfPotPkc4jY+3t3xywKl9nJn9+y3bhFL8KFeVOnA4QKpGHLKYFAfbJ4iZNz984yLnoX4FbywJF7oyK4Y5m3Ie+MX/V6j2vGX0ns1yBI9f9fWI2vL2NEyrBy3yTSy/uriyA5iynFkJnQw2qVmpEHQccMY2sZ6AB9yX6gjgGzOeHHmnf5gz1/juh4UeO6GXUTNtq5MQXBrT9E9BGqERC0vfy3ELizmdb5hlzBE1aJ/vZ6upDQzmE/0yUzaZKhdNGJcjdwTBQWyT+KMikDKW10xphn3vZ2g0b3yDNssdZcI5Iql5XpxvecpYigUuD6HEvw2KkQBKQy9lqUultUXEwW5TSuoP0UFS+ykNJNRe3jrDfmL2lNBLo2z4brIXJKIX3pAorkf2vLalF/tzLbG7ONDX3rEfSxBRyLpRjt6vWJcLMzf3S9EKfOC712/xOFC2OfeJfpJ7mH5ymnjVcI5P2Hj
 uV/12Yd3
 ItjaKrvz9YzztMdahfz8xwheOym8+8NcKmVS6lH52BFchLneSl8yWqWL5NJlZ7YJAfTVx2kborsFiA4wSFyAZmdX6dqOw1as6XFDUhkvL8/RdodEToMLx7E4341I/f6v5vC2iLcf4QpH51ioEH+EZu/82AaPTqSb3gbJnDdajDGn/IP5pHBw9/jwB1BnrdqpVvfYzGZbmJq6+xAibJjwiyNliwy6NHllcRz/hyo25K7UXTiAa3qFwt22Y9S+3BmmDBNggSyiiXwz8tamth0jWxUtaivTComNISAygXfZMCESzyEsyoRaXYr2qPKxKx9u8iWPaZ95CIdSREMfIXvE3lb0cee1aiiLuZhCaJPqeD0P8oUyMjrBrUupvM4RnkGkTmV4aPo2cJ+0FFky47v1B/c5tpS3Lnye8oQDK7TQkbGMCN9HhytZBua7Jaiv6SX00p+cTXjWNqqkBRW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmcore_cleanup() has a single caller, fadump's release_mem_store() on
powerpc. That checks fw_dump.dump_active without a lock and calls
vmcore_cleanup() without one, and kernfs only serializes the writers of
one open file. So two tasks that write to
/sys/kernel/fadump/release_mem through different files run
vmcore_cleanup() at the same time.

The first one removes /proc/vmcore and waits for its readers in
proc_remove(). The second one finds the entry already unlinked, returns
from proc_remove() right away and frees vmcore_list, the ELF headers
and the device dumps while those readers still walk them. Or both of
them free the same lists at once.

Serialize vmcore_cleanup() with a mutex of its own. It can't be
vmcore_mutex, removing /proc/vmcore calls release_vmcore() which takes
it. The second caller then finds nothing left to free.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: b500afff11f6 ("fadump: Invalidate registration and release reserved memory for general use.")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/vmcore.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 1fe70c4ecc54..ccb795b85509 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1764,6 +1764,11 @@ fs_initcall(vmcore_init);
 /* Cleanup function for vmcore module. */
 void vmcore_cleanup(void)
 {
+	/* Not vmcore_mutex, removing /proc/vmcore calls release_vmcore(). */
+	static DEFINE_MUTEX(vmcore_cleanup_mutex);
+
+	/* Two writers of fadump's release_mem can get here at once. */
+	guard(mutex)(&vmcore_cleanup_mutex);
 	if (proc_vmcore) {
 		proc_remove(proc_vmcore);
 		proc_vmcore = NULL;

-- 
2.53.0


