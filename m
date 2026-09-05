Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35938C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 12:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0624C6B0088; Sat,  5 Sep 2026 08:51:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0134C6B008A; Sat,  5 Sep 2026 08:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6B586B0095; Sat,  5 Sep 2026 08:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C41666B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:51:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52DD912034F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:51:34 +0000 (UTC)
X-FDA: 85179694908.29.B638685
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id 31ECD1C0004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:51:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Cg9UTZdQ;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf18.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788612692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k2Jon0zzAG3GmxIwfb1s6njp3H0RiBpGPLuVr+GERyo=;
	b=jIkR75COx1n0BU5QsWdB6YU+KQIqpmRr80mmNp4srX1uwIlZMtZu9RL6i6tRDA760B8XDT
	ojivAPNFLf//cpCR5YVYqq5YIHmOnXfod0qj0Mf5JWX2OXXjpnmClJh/+bvSrdOGXKCZ0s
	ozg6m1PNkjSmuCW4txy3Gvk2AV4C3Hw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Cg9UTZdQ;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf18.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788612692;
	b=xw5B3NwxNcwOWx+iXkVJ84N9UKp2g9Jttasm/pQoBbjPyrWrymc/XYg7wm94Hmr+SQme/q
	goSXOua8Kt59frfNDGli8DOUIMeaHIEOShmJAYW6K4M1eLmre2Psh/s0CmHTgNLh5RUy+s
	d4glRMpHsuuc3NY9UPqiW9pjjbFvTDs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=k2
	Jon0zzAG3GmxIwfb1s6njp3H0RiBpGPLuVr+GERyo=; b=Cg9UTZdQQuAC6W8SSm
	aL1wFXACcpWS++QiyLDXQeChhGYDedLPh+0GdMV9R3WQBg+x4zvZmm3ZiWkGgpbx
	oS2iEABiWppIUKS4E4e51oIXPYtCMdwVebLK8UiHdQOt2lS3C4Xv7nIuFJQHynbI
	pIeBAKx/gOms2J6yuH/pxEknE=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgC3mfg2EJxqFP0ROw--.17076S2;
	Sat, 05 Sep 2026 20:51:04 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 1/1] mm/zswap: enable static key after runtime pool recovery
Date: Sat,  5 Sep 2026 20:50:28 +0800
Message-ID: <20260905125101.2970456-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgC3mfg2EJxqFP0ROw--.17076S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFyrAw45Cr1rXw4fCrWDCFg_yoW8Cry8pr
	y0gasagr1UXF1Syw47AF48ZFyYkay3Kr4rKF1UKw4xZwn8Ar9YyFWIyFy5tayYvrZYya9x
	ZFsrA34UJr1YkaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1PfQUUUUU=
X-Originating-IP: [2409:8d1e:1b11:5c8:4c54:5129:acc4:6dbb]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+BjTzGqcEDg-rQAA3z
X-Stat-Signature: pub58e1hi3z1c5qnehwgfphjpfnpohg6
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 31ECD1C0004
X-Rspam-User: 
X-HE-Tag: 1788612690-905101
X-HE-Meta: U2FsdGVkX19JCqOq9HT60rkegHqpIXPMiN1bl0t3mXVieNmStonQz+4ZRvLcJR/vnnPNskfjO8bTDPcrvrI3631fMh7foC94v0kwSn9lEiUQOwjrvw8aYwUEzGVlQzuBiUi7P0EgkZK4rIIlRj0GhLm6OQUahjSPivSwVoVKC7Uj2uoQtAympMW/LocIS4/IillzTtY77AFaz+pKexgJ+7rsS6+zT9f56t4zdBQi6eHs8h0hc+g6YQ4EZo8DZ6NPI5fCMuX5AaQ7d1UGHX6VlBk0ZKSJ9bEg8kENLfQSSpr18Roosn+L11JaETsBXGPtyVsnyZJ3Su6Phalr/cyJT0qCm3JnnXg3Trv8SJfpQjp1yk9zmfM/UaqVhtV+u8h0NFsM6laPACnTNDvuZX0ZL278B+nsiNAgxR0uOT8vAK4D2UThBup1++Shid4Vzc+VnBeu2Wxtb6ic3xuhPbKugYHXspDZ+/w/90lMvKAEGz+G6C3nYwKu9Ipke8SaXVoO72Yuv4dsLMvoVNTCDR9vHBB+aIyf4pdFbCTxdI4iUYMdBmXoCBTFX3OXRd/F5tzY25r/ihJgNXYHoOzGCAaKHgacY8Yk197XaWsOlj3KaothLbijntCb8A2CrNfgmlIsemQ/OnnKqH17AEssJz7c5ECMUMr6F/MDR8g8+bQXwYv7jKF9YH5xWQQpXz+iyX7bairU4i+MpYZuu9pohq3NnRCqdJRzPo/rI7H5hTU4Pt7VFpBW+z+EOAtKjUFgVpfZunbkspMBcLiysjKR4fMrmU9/JD9kTITjhNt0VcPIyM4nyLdqIqxUhD+KzQ5OdWtopFmmxrPKU6jxuujZibrmfI5XLuPJ1GcKrzaJ0zBo35bN6kkILhKYiZUbQRMhUDDsghIJDThmvI5YFWRQ4geUVJ4wqGY8hB/iWjbYL5TbP+/xmI3qFxGJLQtfcHXkSxu6OMeMaT1n8VMeWyA2H/h
 evc92VlL
 R17B7ybAP2soGomHtvr7Y+8Q55egeTkB9uYOFR3wPAqB5KrfwX96ZjT9jVoUK0xIXZKSQa5Ik345Xhn/NhIeexCd7I/MK/Bnxr4C7vJabZYXk2rusW9o/Y/1ur50ldKICid1bZgNtutO4gCy7QnvDv7LnR/s8X5DRkBd1AFhIwjn8LA7fgWFQDqy1RkRfU3pSwhJLnnaOIjpXRPGJEu7pCaUWv6p1RcLhHZ9xqOzpxxezOCtV9r5zIS1dE1N2PFGOhwhjeplgfVsLr3VfeJG865OzNShawWWr8CrKMObfhcUr5gc+m00opI1qS3q0mng9gCRRv0+ltKBYuUcBJ6ZjfNAD4zvO8HIpDVeKE/MxJv55NJf3dPUz1T/i3LWIdpk2F+vw9HxOWlBmw7dw1qijbfxPcEu1CkKtAApg/eZ2c+orSyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

When CONFIG_ZSWAP_DEFAULT_ON is disabled, zswap_setup() can complete
without a pool after a failed initial pool creation. A later compressor
parameter update can create and publish a pool, but does not enable
zswap_ever_enabled.

If users then enable zswap, zswap_store() intercepts swapout while
zswap_load() still returns -ENOENT without consulting the xarray. The
swapin path therefore reads a stale backing swap slot because the store
skipped writing it.

Enable the static key after a successful compressor and pool update. Do
this outside zswap_pools_lock because static key updates may sleep.

Verified with fault injection on a stock kernel (compressor builtin,
CONFIG_ZSWAP_DEFAULT_ON=n):

  1. Boot with zswap.enabled=1; pool creation fails, init completes
     pool-less (static key off).
  2. Echo an available compressor name to zswap.compressor; a pool is
     recovered but the key stays off.
  3. Enable zswap.
  4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
     fault it back in and verify.

Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
without this patch; all pages intact (zswpin=131072) with it.

Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
Cc: stable@vger.kernel.org
Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/zswap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e3..c48c4df63f188 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -586,6 +586,9 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 	else
 		ret = -EINVAL;
 
+	if (!ret)
+		static_branch_enable(&zswap_ever_enabled);
+
 	spin_lock_bh(&zswap_pools_lock);
 
 	if (!ret) {
-- 
2.43.0


