Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25458CD1297
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098D58E002A; Mon, 10 Nov 2025 10:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049718E0006; Mon, 10 Nov 2025 10:50:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C708E002A; Mon, 10 Nov 2025 10:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEA2E8E0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88FEF1DF31F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:12 +0000 (UTC)
X-FDA: 84095133864.07.438BDC3
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id B62984000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=jQze7y0b;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovYggh8BE0fpVvDPOK5TnkkygYn9qlYyuaX7+8QzWGs=;
	b=mCrAtpramHwZPAVMbW8IBQiqOS5xYKLczJW2Z5rP2/CKBNAlNXhaJVoBbjSNkqt11Z/nlO
	CjsR6AW05+TCaGD/P7yh919QRx65zeEPPh9eJkv2TxmezgJXH892/P+fftzxQqG1r+rxfB
	fTT3UvC7WKVnmylXoODwPUmQV0gyog8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789811; a=rsa-sha256;
	cv=none;
	b=J15rtowR/QPYRfJF3wYaobioalvyKEYN5EtjEvTPvwFx3NZN3jPunXfQTZfjQBW15X+5yN
	TC3qIDleCqrDIL0ByFb8t37XO3lQKewc8aVgYqEF/7Gj5QbB89l7IBj2IlJMkM+e9rv+u+
	izAH7986J+RWOdBJuUdyATgVM5GbOT8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=jQze7y0b;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789807;
	bh=sQcBV/ZWlVLGeAwivyndjv3Kv+k/mZS823qVLbIeFmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQze7y0byXq4iTzQ55HzRx+h6nr4yYkDlwuMy2JM159P7TE6fPnD+0mNngsxOqATZ
	 /4C/ntQT/eCIvKIceSmrV9fWNZ4M/LKynS11N1AEsnOCrdTVPj+vqMFG3rcC+XqWzd
	 jyYNMwoJ8KaYcIl3fWgTMUVE90CTDvstPmFetLwK1D7Q+B8SeIAAOL49GAbqEZFwom
	 jTj2UzrbPuB0VBahYL99gj8FuhpINL9PNTZ6StVzSnez7clS6Yy8ym2+Reh4pPy72u
	 EX1CmFlLuwEMTWmyoUGIZxBSc5i3vyJZlFc1Eq4TZtfU2O47ne+eY3Qbtc3NaboJSf
	 jYvW1XPgrdn5A==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 12C5017E127F;
	Mon, 10 Nov 2025 16:50:07 +0100 (CET)
From: =?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Herring <robh@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?UTF-8?q?Miko=C5=82aj=20Wasiak?= <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Christopher Healy <healych@amazon.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kernel@collabora.com
Subject: [PATCH v7 01/11] drm/shmem-helper: Simplify page offset calculation in fault handler
Date: Mon, 10 Nov 2025 16:49:49 +0100
Message-ID: <20251110155000.2936-2-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110155000.2936-1-loic.molinari@collabora.com>
References: <20251110155000.2936-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B62984000D
X-Stat-Signature: 9mnukudzzb9wi59tjon9xiy1qt5sa199
X-HE-Tag: 1762789810-986613
X-HE-Meta: U2FsdGVkX18lpdyJ/IOuV5u0r1zjOYNbwI2IVDIuiTckRZoc0fX3T5fY3eJSmDa3XahkiTRyoYWsKSOY1qQrYugBmI27CfPMrdjFmCzIFvrYS9WZzJyow9CzZYXwl72OQ6AQc/fi4oNvKeLW3E0Q5rjKJx6tV8czLpaoaTtpHe7H0E6IuLyNCuPiSg2krIyIVdgUsmN6TzdfDwl+WVWgRw9HdhhFzclLVaPJrqDe9Nff54tc2Bu/Y5JRpwt41b0JPW5ldKQblMVz4ujWiIIJVvhvzPLdOch4yCqDLQxFc8RU7e99BkB2wm/sNdDylAETRYK+to+f3W1JcZW5N0myQUgkcSRvAFp2B8nOOu/KImiLzwabG5lPNMg9kIZ5kuo1I5YQ8gILeok1Bp/K4iCu6eDiGcmn0G+5BSvgqjJyc+hC44FNgdI5H38YRj/ZrWlVu+x+wLE0+67A4dBZrliEGAtqSYJ39fJdLPhwsGGGkyW1kSF1bfSwkLh908iqENJHX5qhyzzClVUHX7dvVRJ2GPxMuAZamxIh9hcSUSYhOctEW3i/E31kR8/gXjz1ptiLGeB2bB+8LrZPRejW/E+HaHgYs6S6b2TF13Cny7P4R5Goo68JZ7zVcrKI8lYrFcoeL/HV7tR4+ljoWHZoq1c0nzBpBtOFUPFy3a8Ko+wbX2Nyygg+VF/w+vAq7Zk2fnAcDgFfdYGAMyGMDEIxFSg3vFja04cdtjZ0zPK5k24j1LQG4/9NbSWitB8F9WnRuiOY1V69NIP+K9ysF6k+rvUjB338FvZOoRg6dvRkcEJajbLXFPp4kpgIZ6EZ4bKkCQEQoK3njbGenaOGV8rwvSqXgyWkHB00pixRZR/pVi9GiVd1mm8LqHvBFuuL3nslrtGdS6VRmNRkayAXm9F7HKfJOOY0ElqpCMxBkckHalzRPvQQYr36eGIB5pRZZC3syLC8ofA54WgSqugrFNpPDpk
 OiM7ZCp4
 WD9pSvi8rVVQhIUvHT4X0yTLNrHgtMa7BY/wbxF+CaYtXthvPHjRScZCKiYs4StObtjNSj5YP5sA6ywqi5TOBJX3n45EsuggUf2nHFt4CY81IEQEpaW33XwMgxsXZddxbwXUhBaj8iucrYIzFcUFJrgxWAmJBJLSqszLwusxZNPqWzcBj985upi2+5ZqtGFm0gy2aii+F44WZExzkyykuCtnO+dz0MjnaguKa8ABFhbGQY/mo6iFzzbZ0gAZhJQK7Hdr6aOR/6fGH/PqOTJRslrcN74CwQXw1pz+TxSxDBnu7/sATDqaZrvgXWoPbdcmd76rPLWbajuwlzet56mdcaW7FqDzsfJqNC/BfhkroUphMkOH3LF6sFMOst0pQIvZNrHMZmkwfmwNVC0wSf90gl6z2Kd7l7CpJTw7z68apqRG5wkfymZ25s1l/pJdq1f2gXg1cOTaJju8BBYBVWMqv57XP4KQUr3OZ6AtCZ/GuTRB7O7eIzj/fgz0tbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For a fault at address addr, the page offset is
  page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT
              = ((addr & PAGE_MASK) - vma->vm_start) >> PAGE_SHIFT
	      = (addr - vma->vm_start) >> PAGE_SHIFT

Since the faulty logical page offset based on VMA is
  vmf->pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT)

We can slightly simplify the calculation using
  page_offset = vmf->pgoff - vma->vm_pgoff

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index dc94a27710e5..be89be1c804c 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -577,8 +577,8 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	struct page *page;
 	pgoff_t page_offset;
 
-	/* We don't use vmf->pgoff since that has the fake offset */
-	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+	/* Offset to faulty address in the VMA (without the fake offset). */
+	page_offset = vmf->pgoff - vma->vm_pgoff;
 
 	dma_resv_lock(shmem->base.resv, NULL);
 
-- 
2.47.3


