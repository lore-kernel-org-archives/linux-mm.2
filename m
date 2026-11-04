Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E5F6071AD7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DS3z8fo4
Received: by kanga.kvack.org (Postfix)
	id ACBEA6B05EC; Wed,  4 Nov 2026 14:40:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7D8D6B05ED; Wed,  4 Nov 2026 14:40:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9446C6B05EE; Wed,  4 Nov 2026 14:40:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4B66B05EC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:40:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF77C807FC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:40:20 +0000 (UTC)
X-FDA: 85398453000.13.D56AE1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0A875180002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:40:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DS3z8fo4;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jqve5dom8G0YagWg0DUi21Qt2CUJnz11dMCfHhOCDkM=;
	b=WxRFcAUOkQqW2VkLQOruQryQwvjkTxo5cbFz0aJbUeDNpn77o2GY2iiEMvqyx3CyWzIyhi
	g8L77aekdtfPmvMyp1l0shyByLbzsl2UweW0ltgub9Dd+ujg7xL+lPb5y2aAgHdscmDjI9
	nB2gaMIgYUnKNjKRfj8DADjuaDqzywY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821219;
	b=OZRchCn2SW1M/9IRcwutcHNfiT8u6eLrHKBoX6TH2WC0WM8Z/CCYVFO+EIZTMmqtLSm7Im
	utPbthVO9bhjhOIE4YrCRXSNy4gbvznITwNyy4zp8ggQQAcF8pIbKBfQbypk0ChF3tgtSz
	YGPYJ7DMFydbULnjNnduz7/KgBNZkVo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DS3z8fo4;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 549CC43770;
	Wed,  4 Nov 2026 19:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224F31F000C1;
	Wed,  4 Nov 2026 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821218;
	bh=Jqve5dom8G0YagWg0DUi21Qt2CUJnz11dMCfHhOCDkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DS3z8fo4+XcVun7qDjz2NB285oy50w37ZhabVQ+2KTyYBD2yK9k0cv1ydfdyDbb2G
	 F2kOHfTeVzmbTPa9e/WdAD70pmv8wAUop1Anni0EzwRVSbumICFkMK1x1F9P4tYZIC
	 c3MZ0Kd/4HbFldytGX1vHUsdhINZ5NpZWDpvM+t0Z5wHT/E+VFr+t/6p+AttFRpI6Z
	 mwCDXmDky64VEy6slIdAHdiThaCm746BEvz4eDgLL3BHUTx/IA08z0BMxgO0LJmQyT
	 NF1MhcwXbC2axzqG1STp/J698+gtyVKqI7HYsWuCQMJlP4fOePGgiGm6vAX9LAFZim
	 TqL2Dw1DliqSQ==
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
Subject: [PATCH RESEND v2 18/23] ACPI: proc: let procfs copy in writes to /proc/acpi/wakeup
Date: Wed,  4 Nov 2026 20:40:03 +0100
Message-ID: <20261104-work-procfs-arch-v2-18-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1423; i=brauner@kernel.org; h=from:subject:message-id; bh=IJsID2u9MwR2UWiBoMaBlflke6dvKtZBVcAIKZfI9/A=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mTSWXVefuGeEyelmfYp78ycWKUkyn49ZGWQk+eRL 0tjb5df7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIXhmGf+a115bOnrtr8gHR +0o1t4SK21/t283HxHqtW0P5SrNTrxYjQ6Pi/sVHc5622fk3Tnk5Q7znZtAi0aS07pWzZjY9Od9 YwQ0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: mgxa1pc5o3wonndyfxzn6x6hn4di8nze
X-Rspamd-Queue-Id: 0A875180002
X-Rspam-User: 
X-HE-Tag: 1793821218-831346
X-HE-Meta: U2FsdGVkX1/NCwFen+OpvEtp421FBWgWnQIIDpdK9UH/aQ0liyr1frXFeepA0mLbM/riBxYmYXMtzCpv9G4buQy/GOaVqVfsfyyj9dMXUTZrE8FMjXyop6E3g84scAxH+dIKnKiZYVhgjGU3ZW6hrT0Z0IFfjAxv6AajFnEYXW6I3U06hDvCNhOUjRZBE9VKeh4CRmb31qwGoiDfRwxL3NxwG+hOtzn2RDJiXmMNgMhrcmyiwHwFckKwZoF1D6eeS7HADvL+NwYtdJqKcqks/E0j03zE6P+8EV/5RwIzUz9M/Mw3BsXmuVz1+NJL3LuB7xqsMYGildNRFsFtAKsl0xYbwyjVkSJiAsNecPqYygXtkO/KBGoTxRAI8W/JKIpue7N3AUZGD+nISA3BtB2IUFd4Azanrh5pZnVqPzWliPf1gdZW1AKMAGCNyJcgoqBpNmibhrCc84vYhhu3O5E/G8owHD4Y6PeQ4bLshVunE/fbH1lk5FumKH8cDJsr6zZZb3DTrt3TkMie+aFA53GMUv9fPnQ8LWN9wdPmAPEVNWidrzSANgg9UVHk10/vJ6zYrcVgnQXy8FW7li1ODYqCDFEy1pO3QDzHIVbx60qjDEQHlP2xOSiiMfz/tZAJYmPdk6p0lFraoRc73RUZZREHGVc8+aqMQhgP+zjvP2FLmodNOr5XPdiHFwlMEVl/SE5YfbLknFJhv6R9RZ9P91GeiDXltwKNUgAdHds0G2BEyJ3Q70So4uJdejIsxXUBa8JnrOtE4tYTv3ZMSX8WRyDkEll29wQkeItn4YzBhO+rRim0t68ggnhf+ReS1mnB1bp4Ml1SHRWkOjjwLgc8Q0+V15Tu9ztYHmc1CLzGY2RaHQnfomGyegLwZg+Dgdi2tabwdqIMTVHbs5p43nBqyTu4OWUbJMXWccEO8df9HLWTP4OHjjaOXNtchOuGqRwMCRd7nVsRXpXCZ8mrr08EqMm
 f9bt4mQt
 5p5fhZvd9nd9BB/TE5t43Rf2+/YWX/ZPgX+cPxkHtF4ccB2iHFw8eSWoR98xwunZBJuC3CFSUuoTAvfF9qIBaE+adUQrX/Iz6coyUleHUyZKMplp4072wJgNaCdnvy8RWai8Wo462YRA7E2FJWbnk44MkrW2gfblU7eOLFbhEPa+GtdTU8k8kDLmaYiMlAdX2WQb3G0UmTCpcrqmtdck5Hp40IOqJ0zEUGZvschYb59EoOPqcuWxAEp6S/uPNzYYVf/Vhpg45TPdvJifIPtvu9ImqLAIwRlAj/zsZIejGOoNf2MR+63CSdlfavm7CGaX9fJtIcvNYAJYQBGX0E9dongKl0WhgwbhTxZ1r+hfdpC0g6S447E7otYvC6ISRzJHVTCURmvqgvIa37dl8TfoDUXRu6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and take the device name from that copy. Writes
larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/acpi/proc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index b8a0bd4580e0..feb8283fd855 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -86,7 +86,7 @@ static void physical_device_enable_wakeup(struct acpi_device *adev)
 
 static ssize_t
 acpi_system_write_wakeup_device(struct file *file,
-				const char __user * buffer,
+				char *buffer,
 				size_t count, loff_t * ppos)
 {
 	struct acpi_device *dev, *tmp;
@@ -96,8 +96,7 @@ acpi_system_write_wakeup_device(struct file *file,
 	if (count > 4)
 		count = 4;
 
-	if (copy_from_user(strbuf, buffer, count))
-		return -EFAULT;
+	memcpy(strbuf, buffer, count);
 	strbuf[count] = '\0';
 	sscanf(strbuf, "%s", str);
 
@@ -123,7 +122,7 @@ acpi_system_write_wakeup_device(struct file *file,
 
 static const struct proc_ops acpi_system_wakeup_device_proc_ops = {
 	.proc_show	= acpi_system_wakeup_device_seq_show,
-	.proc_write	= acpi_system_write_wakeup_device,
+	.proc_write_buf	= acpi_system_write_wakeup_device,
 };
 
 void __init acpi_sleep_proc_init(void)

-- 
2.53.0


