Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281BE606A336
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M+37idsG
Received: by kanga.kvack.org (Postfix)
	id 411836B05B7; Wed,  4 Nov 2026 14:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1966B05B8; Wed,  4 Nov 2026 14:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289F06B05B9; Wed,  4 Nov 2026 14:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F064A6B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:17:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70ADF40843
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:17:16 +0000 (UTC)
X-FDA: 85398394872.23.68B146A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A2066180005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:17:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M+37idsG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+yARzdOpzdllKXUJ7Oz/hxaICj5Mm35ej5JnL7jd2E=;
	b=KuwEJDbvcNIc5MpUHN4idOJQ43WCl94eDhCHZPKIfhyF/YLpOwbTrnpn24THlUP4bBE78J
	+FU2AvsV3E85ZalDEIJPx48nEYMbEmjCtRLWLq2/KLZPBgi3z1Bhmv5dfFR15803SgErSQ
	13Q8Kdl0Ym9+q6xGPuDkOQWQjmCMaDc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M+37idsG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819834;
	b=de0O1KAAZkIeGSCLoSFuCW8TnvQESDM6Fr/okpm+6kF6MLRvriuB2gXinCjrlOqSAGGoeN
	ptcXbMfbfuFxkYUF3Pq1q4GoyNWUD8i0WD4TKYvp0rjki9PDUl/uJ47l2ewlypPDuuziKZ
	HT1D4A8L1v2CH67EJB4eSJ3IVyEqzjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3281260D79;
	Wed,  4 Nov 2026 19:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CC31F00A02;
	Wed,  4 Nov 2026 19:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819833;
	bh=9+yARzdOpzdllKXUJ7Oz/hxaICj5Mm35ej5JnL7jd2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+37idsGrLxfFvku7zl/pBSwEmNcKERej4x0tosO6grxOviHHdjWIUdhmF1vqg/33
	 ePdxdVUOrxZAd03o21+XtRZheQyVUQvUyzG6bID6wcddrxq3hFrluAQ9lLCdxqRzfp
	 kt/0B12iz71I2xcJyQXTn4hjtTXM1xta/DcZkdyqFcRIjvNQqhjLQ7+o4RQS7ld9uJ
	 RxppQtsQpkcAJfI1T2eabtz3JiLt/pD+Ac5EuC64kC1SX9FzH8iROGnJpsFF7HprX/
	 digopjDGEPs9QYh/4IRuwVyogSNhJ6h7LRJdrzEAtQ40rWwZdXm33gXiB304dOVRmc
	 6xBzDofOt/82g==
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
Subject: [PATCH RESEND v2 04/51] PNP: isapnp: don't go on when isapnp_cfg_begin() fails
Date: Wed,  4 Nov 2026 20:16:59 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-4-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3910; i=brauner@kernel.org; h=from:subject:message-id; bh=zJWqbpFP7Eog9HhLBr1/8hQ7kUfFg3Bc340XkbmHZ+k=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bjwfy6albiRae1/wtUrq+c387TdzlueZHTlof0l6C 9s2jaXJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOxOMDwP/P/rHn3hBMn3dDV dmaavka+U/6WztZHr9XU+ayeBLut+8/wz/yq9VK/Qs8AXxn5YxmeOze0nVnNEjjjZ9J8gXrmcL1 FPAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A2066180005
X-Stat-Signature: gzgrymy89sm81crx8gdfsk7oyf89deew
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793819834-734432
X-HE-Meta: U2FsdGVkX1+1FVclzdZrB/zwMoI11hexyBX01k8KJt+uDQEcveNhpKdOKRLbPUzpWoV/TzbPIANKut8VQ0r3WPg87LuoYbyz4RGk/cgqVB3T0om9JP23Uzxk3356FZLNbWxpeolHtmym+I506SH1VqSqFX8otaoNY3S8oj+lvEpnhvZNB86Ictn8RtzxZDiAKGu8YDlD5/SShW3/YoUpKEIQ82uaeP/yu2TJUEsiXtm51OOyNzC8a6H5ALZja+yJNVIq8i70lrPfGyl8d0S56zC2hxn4YOBZzrXR4fqOO/zlQmT9yescKKmkmmRrPF2F6QZYVNsJQ+IJMaMrd/YQxZ3+bJC59IOJUbpv2n4gHBuise3j0jMN5+8t/iFCbIqeZdFiTrsPk3q7OZBsLE8Vz+3RMFnXZT3GotCEUZnQ42CJ9EvI8eqO97VueTM7YUW9XCtsPQyJbbA5QPcQlnf8Xv0M6Gs4dFzYaQkp8kcEydOkmkYXFIvByj/cfnZ2a/LlMX4p0r2V9EgKVcnz5ZCMJQN3mk8YiwKM01Bf3nNJCYWmAYB+yqzlMKumMCxFHH6E6dH8PmnMU6edCzK+ORHs05cqXEYrndYM9hPKk7lwEptw28ix+AQZ0J60I/Vz9gUwz1JqqIsK213/rsFkBr/6LOXSSK0U81gVSGQAXA35tQWKC0KJ4WeP+O0ZdMzFYZ/Hf4NaojEuKwsiVzhIDRL5M0egu5kXHBHAvFreXHxEqdKH9TZPI2lloP53LbH+O+zCud1kPvNT1iJQiJHcVtUbU5LXF1Yzo0sN909Xh1TYeFHKJ0sMQUcNNXqff0Lq04T8b1f6oNWDZa+/u9nw8pSzbTZhi5fgoLNXe2FJ7HQN/a0VamZoEAyWfRGgobMKBfDijG75v4Qpn7QsrIEnzLmf6NnlJ8X4CFjDKXjP6iLaxgAocHlATnZ1pURq/4sgC23LVIplctGK0ywbxHxl0xH
 P+MsJsU4
 pTltVq1h+RBLd6lWNMr0OdTwr1y0GZKhNdHOJ2ITovs/U7gFdV1ks04raJth1rInCPp9JFYznvq2Vxx+WR0nypP0BIcJJP1cQIgQjdLQFWeLpS4xXmecw+OjHLkYvyTWYmgG2Y2MtST5OoYrJPKH5y9bE5cRMbQwZbqtNQXZtuxvLhYxY9ls61AnVH3ETPNi5NkzPifKpFSOE4mvkp+a+MEtn9InkK+gdzaMzkDtn11vlp6WVMW6ExSS0ty6Fkg2iifkFGtvvXY4RnAGqXvK8JPhB45w0uf7F/ubmxfkd68Yqu5Sb/rmECDka+Pfal6v5modH2145ZkHQcNGPtvz2Gwyyc+gIAlo/7pH73gWOzqmum0iuN6tfXLvTTHMwG3vwRaxPAg1se0w8ODW6X7wmBaVI0kZf3/CsrDs32VlrjHT4ZG5XoH3A9vxMFKyQ+faTTRvSvMsZ4v2lDsmRco2Yi9EfS/Hwbk6SCBzJXXIPprRWbaA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

isapnp_cfg_begin() refuses a logical device number above 10 and a bad
card number with -EINVAL before it takes isapnp_cfg_mutex. The callers
that read and write the device's configuration, the proc file included,
don't look at that: they go on talking to whatever device the card
currently has selected and then unlock a mutex they never took in
isapnp_cfg_end(). isapnp_create_device() hands out logical device
numbers without a bound, so a card with twelve or more logical devices
gets there. Return the error instead.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pnp/isapnp/core.c | 16 ++++++++++++----
 drivers/pnp/isapnp/proc.c |  5 ++++-
 sound/isa/es18xx.c        |  6 +++++-
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
index 219f96f2aaaf..3591a2791c1a 100644
--- a/drivers/pnp/isapnp/core.c
+++ b/drivers/pnp/isapnp/core.c
@@ -853,7 +853,9 @@ static int isapnp_get_resources(struct pnp_dev *dev)
 
 	pnp_dbg(&dev->dev, "get resources\n");
 	pnp_init_resources(dev);
-	isapnp_cfg_begin(dev->card->number, dev->number);
+	ret = isapnp_cfg_begin(dev->card->number, dev->number);
+	if (ret)
+		return ret;
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
 	if (!dev->active)
 		goto __end;
@@ -887,10 +889,12 @@ __end:
 static int isapnp_set_resources(struct pnp_dev *dev)
 {
 	struct resource *res;
-	int tmp;
+	int tmp, ret;
 
 	pnp_dbg(&dev->dev, "set resources\n");
-	isapnp_cfg_begin(dev->card->number, dev->number);
+	ret = isapnp_cfg_begin(dev->card->number, dev->number);
+	if (ret)
+		return ret;
 	dev->active = 1;
 	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
 		res = pnp_get_resource(dev, IORESOURCE_IO, tmp);
@@ -936,9 +940,13 @@ static int isapnp_set_resources(struct pnp_dev *dev)
 
 static int isapnp_disable_resources(struct pnp_dev *dev)
 {
+	int ret;
+
 	if (!dev->active)
 		return -EINVAL;
-	isapnp_cfg_begin(dev->card->number, dev->number);
+	ret = isapnp_cfg_begin(dev->card->number, dev->number);
+	if (ret)
+		return ret;
 	isapnp_deactivate(dev->number);
 	dev->active = 0;
 	isapnp_cfg_end();
diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
index c1f6e6bd0eb2..b3abab24050b 100644
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -25,6 +25,7 @@ static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
 	struct pnp_dev *dev = pde_data(file_inode(file));
 	int pos = *ppos;
 	int cnt, size = 256;
+	int ret;
 
 	if (pos >= size)
 		return 0;
@@ -37,7 +38,9 @@ static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
 	if (!access_ok(buf, cnt))
 		return -EINVAL;
 
-	isapnp_cfg_begin(dev->card->number, dev->number);
+	ret = isapnp_cfg_begin(dev->card->number, dev->number);
+	if (ret)
+		return ret;
 	for (; pos < 256 && cnt > 0; pos++, buf++, cnt--) {
 		unsigned char val;
 		val = isapnp_read_byte(pos);
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 3cadbf7cf238..de1eda5a0656 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1950,7 +1950,11 @@ static int snd_audiodrive_pnp_init_main(int dev, struct pnp_dev *pdev)
 	/* ok. hack using Vendor-Defined Card-Level registers */
 	/* skip csn and logdev initialization - already done in isapnp_configure */
 	if (pnp_device_is_isapnp(pdev)) {
-		isapnp_cfg_begin(isapnp_card_number(pdev), isapnp_csn_number(pdev));
+		int ret = isapnp_cfg_begin(isapnp_card_number(pdev),
+					   isapnp_csn_number(pdev));
+
+		if (ret)
+			return ret;
 		isapnp_write_byte(0x27, pnp_irq(pdev, 0));	/* Hardware Volume IRQ Number */
 		if (mpu_port[dev] != SNDRV_AUTO_PORT)
 			isapnp_write_byte(0x28, pnp_irq(pdev, 0)); /* MPU-401 IRQ Number */

-- 
2.53.0


