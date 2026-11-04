Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20563607030E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NiQpXkOL
Received: by kanga.kvack.org (Postfix)
	id 43E436B05C9; Wed,  4 Nov 2026 14:20:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415DD6B05CA; Wed,  4 Nov 2026 14:20:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305686B05CB; Wed,  4 Nov 2026 14:20:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6E86B05C9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:20:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3248C0827
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:20:38 +0000 (UTC)
X-FDA: 85398403356.11.D72CE84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2DA1C0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:20:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NiQpXkOL;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820037;
	b=t+Xw57af47vwvpNNS+3y6O5y1tamc6cH702r96QPUw22whqJ8HxNXwHTFJBjZ4/60TeF+4
	ip91J0/Zi8z6HUQNj9005g7BkbEPsA9U8J03U7clk2j8DVUzScrT1YJpuS2SIk0fyDwC9V
	2I5cEGWbDo21M8hf9xblE9Fe7mQNwT4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NiQpXkOL;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXeWRtHDTvlcvQqGcGXKpHSOkC75TIYAS6cttW7V/+A=;
	b=pa+H72GDbA68QDNlDAT6SIVlFyNDWuqsoyMVFfgNxlj3Bs0Siy3QJCdKzpZBCWt6ulTlDR
	7m69mLQw0aQ/fR5qVZfuocO+xjOIsLJR9MYW0Szdq8M+N0YXkFu/PfABjwnwYwxSpauFM5
	nXWKEJNIBdKwfqiG6d17vIvMqk+eJ58=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9023960D80;
	Wed,  4 Nov 2026 19:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB4C1F000C1;
	Wed,  4 Nov 2026 19:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820036;
	bh=WXeWRtHDTvlcvQqGcGXKpHSOkC75TIYAS6cttW7V/+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiQpXkOL9hkwE4/WfxFpkq7xHtcYi6yJMSB/+5Lpz/WzmPrYAgiA9H9E5e8qDQYcu
	 CVPJ+eFkDXwM8lejKQ7l89O80BgN+V6VLVj2MFzydedaUh2ITZxqC0P3DhBM8SW3kd
	 pCt0I4NIWeLQoB+KBmB/wtCubDHhs67Vexmb2baBUUIt9W1Eq7UCs6W7ysRAb8/LDD
	 SDwIlPhMq8t6XaxPl3DjFQXZ3Ur1uNe/CRJYwyWO/oMuT1/a92x7gI55ZC16NTFei8
	 hciC0aS2Vu+Ct9yg83X4LRieliSduhcrx1rvxzn+tzyYmiH3Ei2GE3zJ0PaQhCEuEm
	 WxwcvbYHuQ6iA==
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
Subject: [PATCH RESEND v2 18/51] platform/x86: toshiba_acpi: reject malformed brightness and fan writes
Date: Wed,  4 Nov 2026 20:20:22 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-18-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1850; i=brauner@kernel.org; h=from:subject:message-id; bh=dBPyRrfA4AE5uU+SDwP01KQAXBYhly7L9ZsRpXHhzrM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnw4ha3i4UvNWUm2/209lmecNc23PLjw0wP/o3OiK 6UDhFNWd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExE7Bkjw6nnQYwPZr7OET2+ qr74iELMBq1imTVmvO3H9S3OC3yaIsnI0LnEIuBiSUVbEM+ZK3VNl7d/f8y78dePT78Xx+be/BW lzgQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fifcphsjwpufspwyd44eezwfmop5fz3c
X-Rspamd-Queue-Id: F2DA1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820036-616976
X-HE-Meta: U2FsdGVkX1902CI7VK/ECQgkjS/MI2fuygLpiajiiwVhyGS/1Nni0ojFxK82ZVzuPXidFqWJgEQ6kRW2hBRD1GPQTVVmrF4/+Ef+aIOZz3dU6G9pxqpIJMrf+2slSbf8ugLtDkzbc9QZpD0LxTk88F9DWnHN/gaxlhKQQOdF/n9kU+cHtKZ74eRUAXFc9DEXR3KAdBWzoDnGkcvdbL0mMv8GN2OzTvX10MxcqoxSrItKzETKGoj1habiNikVrApF8ZCFR3Z2OXhzWWLXBWZRJ4KOx9QT/BFuqgV2AZRYOYWg15EU7zx+nCrPehmqFlyLIHGTNU6SHFDXZFndQwwUwVnhVwDPPgdpv12CGDV6cqDa7kHFlpIH28p34Oxl8hgnp6HGZ7BdE1rOX4oU4Ftxg3kuAnbF0X/qCTpvzpGE+3j9E30ionPaszwan5P5KYFHbhNwofqpUiYVHN3NnR4NeLXEM0rfWT5UzRUuBkcN9XJ8GvvNBNTRJG2cP6r/VxviuRO6vJyX/PDiuKmGoLBLwt2sPQnbJ5MIIgPwnqbFuQzKhsCi2rn6tidZc4FnjTf97m5EmZIfCQjwEnMEUHEs+gxGCANxvAmjgvfgoZ22EzB1u2O9fWtFTsL+h0wQkPDz0+ST3G/TLe51LczXQXNqqyjQZ3uMYBKKjdVmVpW35NMUEyFBYqgG7AgGSS4H4JuZAolNaop+F5wKFgyajWGJQH7ZuA9lK3zE3VjRluzJ4WWz5sBVEyyR5PtwLlQ/9iHMPpK57cuRpaeluWYwGvZjNXukS0rhmLiM4s8rvI8fUwEd2qEYmEjIzV/8AHb5KmBm1wB1uMBGEioIlkDSER8PhnuLUuejdk29vy3WP3o8x1p8ubXF+fJ9qeRvxMblc0+6u0eEANKA7wTEGJ8LuZFayKr1q++uJSVB+J3MIhN9wMp+QwtJwd6jjRcIydIE8eN5pyq10BRCSqbYgijWr8+
 Mbhn+p85
 qLfTEGFbg1A/8wwRFWGNPHn3WJu4H8s3I+49RgyqfT91ioQclSmS95JR8fVLnzPad+0mk0xZ1HPKoTrgOAFQDh0BM9rNsDNcjIE3nTa8V03sS4l4HoT8rgNwYVz2ILzLL8VlV5apxpQmQVo19dBX9bZVqAzzR4c0Tx4nqUS/t9GFz4pWnTVISciA7RhkQuqYPqfW1oblI9tiJfwAoSzVxdAAkANqd2qavwUVyy1VN7gytWdQRZlDvRGKFRvYY3qJCzPqN9QubZ1pDl2OfiOk9g94U6ZruOcXrTRvAGLXmTHkhEfl5w9hS0x7J5XkVSSUeKtz+3OXK+d2P0Q6t0MboNHXEBEeKx6CWe4KxRmNxcJ9NJwam35EUScC/y+Djb0+9GYeiUZmhgGGmlL0mp3AfNy7VENn8RaIq3dGkbdBrcdqOX5Sto4RCDzs9naD09luCzfDi6JQ4RAAqy0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When lcd_proc_write() and fan_proc_write() were refactored their checks
were inverted but the && stayed. They only fail if sscanf() didn't
parse anything and the value is out of range at the same time, and for
the brightness value < 0 && value > levels can't be true at all. So an
out of range brightness or fan setting is passed on to the hardware,
and so is the uninitialized value if nothing could be parsed.

Restore the checks as they were before the refactoring.

Fixes: e1a949c1b988 ("toshiba_acpi: Refactor *{get, set} functions return value")
Fixes: 3e07e5baa2af ("toshiba_acpi: Add set_fan_status function")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/platform/x86/toshiba_acpi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index a0b8060836d0..9eb8f1e5aeda 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1498,8 +1498,8 @@ static ssize_t lcd_proc_write(struct file *file, const char __user *buf,
 	cmd[len] = '\0';
 
 	levels = dev->backlight_dev->props.max_brightness + 1;
-	if (sscanf(cmd, " brightness : %i", &value) != 1 &&
-	    value < 0 && value > levels)
+	if (sscanf(cmd, " brightness : %i", &value) != 1 ||
+	    value < 0 || value >= levels)
 		return -EINVAL;
 
 	if (set_lcd_brightness(dev, value))
@@ -1678,8 +1678,8 @@ static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 		return -EFAULT;
 	cmd[len] = '\0';
 
-	if (sscanf(cmd, " force_on : %i", &value) != 1 &&
-	    value != 0 && value != 1)
+	if (sscanf(cmd, " force_on : %i", &value) != 1 ||
+	    value < 0 || value > 1)
 		return -EINVAL;
 
 	if (set_fan_status(dev, value))

-- 
2.53.0


