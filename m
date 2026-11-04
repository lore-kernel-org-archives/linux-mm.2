Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F25B56071A0B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d2Yp3suk
Received: by kanga.kvack.org (Postfix)
	id 0EC1F6B05B6; Wed,  4 Nov 2026 14:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3866B05CE; Wed,  4 Nov 2026 14:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1BBF6B05CF; Wed,  4 Nov 2026 14:25:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF0F06B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:25:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65CA81A0857
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:25:34 +0000 (UTC)
X-FDA: 85398415788.05.DE6AD30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C515720005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:25:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2Yp3suk;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5t8qKNo68SCWoforDimF8hL2ZYL+p0Okj8bWoZ1JT0=;
	b=7sWMjRWLDrYAZrOs2ui38aU9/Fn1kyLE7okNsZigZXQNopWJ+2ddhCchwLrKAZJ+x4Z5ew
	Ob60MIr3jyZ+FLE9EDxM771utHpLTHmlDfQMInrizTKA70PDRqW7bvsuSJEFmIQTMuG+hX
	oszOE6q9D4cOQGZmjyqMilYkJyfUTco=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820332;
	b=ACah6gI6jPLLEpcfjJ2QGaMQMuveeS97Eh5bA+55TAk/5GjUMO1O9gAB3mleosKKBdybDv
	JWOL2+xUakF1eVdKSHaf2Kmpo+G/niufEfqyAxr2+uRp3pU//LrwrEAzByimQ1s7q9NqwO
	R7ievQc8Wga5k5uJ2skoO/nEIFopNEI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2Yp3suk;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D324E43AB6;
	Wed,  4 Nov 2026 19:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98241F0093A;
	Wed,  4 Nov 2026 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820331;
	bh=v5t8qKNo68SCWoforDimF8hL2ZYL+p0Okj8bWoZ1JT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2Yp3suk+xIFUQRM7BO7x7E3aft20rXKQTfKi2EJdB6puqKguKbDO/RzfDRA7X3lV
	 gSljFhFAbMDcd/asHliyJikYnWdkdW8FRwy3bQh6M+ewh9drJ7d35YOJvdhtwFBPH9
	 JRwJWLRJM4Vxp/NSD7VcC/GqW0BZH+vd44UCHmE480t5IclYXqoZgoP1rxpP7ASvzi
	 MV6zaQzy3dS5SCMydWsqMWRJAW6dgE80WRCZ4oN2w3QDfNKA1V+orpBh9N1WCS1BnB
	 qAK1SagQtlE4k26S60ABDjOQvWS+i75OCJwN1Sg08aifhf820lnDivFXg1KjOzyPpn
	 JuTk2cFWA7+Bg==
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
Subject: [PATCH RESEND v2 38/51] powerpc/crash_dump: check ioremap_cache() in copy_oldmem_page()
Date: Wed,  4 Nov 2026 20:25:17 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-38-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1312; i=brauner@kernel.org; h=from:subject:message-id; bh=2dbZnDPFapx3dAW5qeN54CL6hHWBvjsrs28L3h6tsIk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvxl/P2Dzo5anu13Tqzf1xxtev7aJSeWp+ezo6b2t N9VrY5U7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIaS/D/3hfsRnFFt+mr1Gq mfCx747C6gAR6081CmdVZ93UW9i0TJWRYddzz5Q7xvsdygJ9F50qmvOkfr37pFAJ8balvcaJT6z +8gEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: k4dm8r3erhshahnetmer1sguaz97anfn
X-Rspamd-Queue-Id: C515720005
X-Rspam-User: 
X-HE-Tag: 1793820333-944227
X-HE-Meta: U2FsdGVkX18fkumJmZ5fRHLzDInE4n8WxeGq25T3OCk4CsQ2SsntwaJy5cWqagw+SXjqAdctpagCoa4eZT7f7h1HWf81a4B2VnhrrdOjAQWjXnkXykSry1LeY2OFA0+3K7aPW/vwtSAJmPDFKlniPyVG9EHoUHIVAac7yLXb3vgZ2XcrpdKL1njqtG1GsC+EFqQYHoZbxeEY8bTVM6MJyq5LRE4/H5nVjPrzW7L7vC/VHvE0ifCNq2whiSspPCpcnGA5sH7D2pZy+zLOjs4YpWQg9+h0u7JmIp2OCFH+1V8/4Wrmyim56csXylsFTUd5nwmAFYbKMmroeSMp8wzuYtHHaFfnMUB1oAsxtHa1YOq5NARR9gy/OxPvVKlzepTtG4X2rtBMtVQv5UT2ocA0plPRLjlNCE3/Mbgnbb4066Gsv1hKWNEL42nXfuX4ehoS8L1dhCYML7fg/yzgAWHpQMLDvh2DxXf/jPLbPBUglxYxDQ4KF/iAyh0NYSnGAQhHpNbbytERUn+eZZQFYnx1LBlt+IYLWgumPGwRh+D11oin5hXKMRa1ZTKma9Wn1kIxlMMz0QNyBcpsFfdOazk6Kgi4Xk5He/tc8wKsHLT4m2JEgyJoJ9Xl33pYULIO0NdmzlrkQ8Uwp3+oE9FIkVcbcbxaL7AODTmCh76uTxN86uQyQzdZ4CQS4nz/OZOFSssSP4eVoYQnBjYlG3FssWZnKvUAdgHFb9XrXsVm/qObn53tNEBM31CSHlSOoolc/EGzKwQGoRxSGvmg+S/AIfw/y/i1cc29aN1KMxuq7cuoPVgyC6p8+vo2Tp/6L0MAYQ8jdkjwKSIvHnc0X8IkBkKLlAh5ZXaRQAT1zjjivplPn4Pt/eSQlAaHtlxFvaX4jIIpQKI6x2NtKEoaTSvPP1zEDkJXI/sikW1PLV0P67wx1bEUtJHTqNIY+SB0QwE9/UeDwzteOcI/PQ+JNDXHCn/
 kqe8T9eZ
 eb4GwYHDXI6gKdAT+kNYoj7D+n4HlJj1NbwMgJ3rT1BsuzAl1eXmW+llelQ5gyn9zwtJOJTJ0xhBbCLh6LGmEiKUZ5Fj9vlD2kzKVrzhJxVojT2mFz3k5W5DYRKsPkdb2eBMchUzYfbLm1sb0Tr1AF/laIML7zSjEYcd9idWG/I63v26HQCNE2UbeqwWp2WZH769u/1ecPc8P49g0dSvLelLxsW0h6K/XuLIS8zbNQcswaURD0HHBBA+AQKsHWP7KaBMZlPl4R70cIvF0HskAENvYjKpJ7T1GDiJJbfgGvzv7bqhH2ZmZLAV+38xDJwCGaI0spzkfqKaVhOanTby9FaCwKoHgPETzIrc5zDm84Cr6KL9e/CAn1CAWBtDUh9avuLagO2cdo6dDptxZg7h2fI2kJdFqeNAydZn98DzzRm9zz+q0IGz+Pm1RuvL6C9bIVtn5IYIw0u1pFsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

copy_oldmem_page() maps a page of the old kernel that isn't in the
linear mapping with ioremap_cache() and copies from it without checking
whether the mapping worked. If it didn't, the copy reads from an offset
into the NULL page. That oopses unless the copy happens to be a user
copy, whose exception table entries turn the fault into a short copy.

Return -ENOMEM like the other architectures do. read_from_oldmem()
turns that into -EFAULT like any other short copy.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_page")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/crash_dump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index 103b6605dd68..1543917bd3e1 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -86,6 +86,8 @@ ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
 		csize = copy_to_iter(vaddr + offset, csize, iter);
 	} else {
 		vaddr = ioremap_cache(paddr, PAGE_SIZE);
+		if (!vaddr)
+			return -ENOMEM;
 		csize = copy_to_iter(vaddr + offset, csize, iter);
 		iounmap(vaddr);
 	}

-- 
2.53.0


