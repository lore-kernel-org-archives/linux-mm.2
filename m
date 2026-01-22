Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A2CD3EE89
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A04F26B0288; Thu, 22 Jan 2026 11:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8666B028A; Thu, 22 Jan 2026 11:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D216B028B; Thu, 22 Jan 2026 11:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 703516B0288
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:10:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3673A13AF13
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:27 +0000 (UTC)
X-FDA: 84360087294.01.C9C3058
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 85EC6C0005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSJMMtX1;
	spf=pass (imf10.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGw9UBjkpyzbN70YDhl5jcX+BSpRYzPPHb7Ba1+nMrc=;
	b=gV2ohtIBPlPDBWUolSGB27GpjKChFcOfwMn6svwIuSYM/2FixkXRHeuCPuuqhpMF7BKbg5
	WLaVZHejnxFScuj5rPnMfsqBQ502evHMQd7Kvb6lGyyW7gLrjYvs6aYQ3Rgm4izlb1RprN
	y4rfb0fj2TUr1NQXdmWDIm3qDTALxY0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSJMMtX1;
	spf=pass (imf10.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098225; a=rsa-sha256;
	cv=none;
	b=iZpZ1Ia/2WT9QeeCX/AZz1ACGlZ8H3QJufRvGsSW0R4bkdpZr+d+8We3U1TFqVeAi1pJxw
	9NkLIut8G2QhH4zRn73sqzyV84xjVx7/9mC4kzeB2ypKw1LVE3z2/WEoqOvZSbR7Q6SD52
	y73T6d07OhbkTlSEKsGiQJVoqIOwoRI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 062396012B;
	Thu, 22 Jan 2026 16:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E87C116C6;
	Thu, 22 Jan 2026 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098224;
	bh=LmgB3NAOjY2EXb6KKktntFdTHuCI5bomDczMPMk21vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSJMMtX17uMId5qnzEFbziYqxYETI2pr51ysG1ENZJyeMwGCFR6aWtyor35a6hgWc
	 mVoKE1PLfg1iqNj5RMwTd2bFk36grxBnFL3n/UH3W3mLyujydUCnh1AipUXW9koOvJ
	 +W2jPRJwvcJ3ttoxIM0ifDKSIp1SMD7ZIDgE+yeiE/2YwprYArt5wBaBa/3ych9p9K
	 YnFlVvo8EJ+W6DWZLfi96vHNYPxnU7SruN3LkQD3J4D+1DKGrN2LHi+PbqyYRQfA7D
	 OEVibrds0rDZaojZuwjLuz5pzbuIGbX/duIVsWXVMWd+HycimpAa4sJmvlp2gUHOnC
	 GxoWgTKQQFPuQ==
From: Thierry Reding <thierry.reding@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH v2 03/10] bitmap: Add bitmap_allocate() function
Date: Thu, 22 Jan 2026 17:10:02 +0100
Message-ID: <20260122161009.3865888-4-thierry.reding@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122161009.3865888-1-thierry.reding@kernel.org>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85EC6C0005
X-Stat-Signature: w8mj3enxixod73bu88e3jqqxrk49dgf9
X-Rspam-User: 
X-HE-Tag: 1769098225-487069
X-HE-Meta: U2FsdGVkX1/Vy25iT6EOcVCNLpTzifpUxCL5rmNkUQ2VlEw9tc0PtdKdB4n2OyOthgxsWRL8KcQKUeTIRkzyQjYIvhyCpFaz6c5NvvGs+t9nbu0IV1EJY0Y6+FI49GfYS8HpM4SX3vDWWzXcY2QfMwzNm5wpKVvSp/LZIWvBzGrNil96YuRtUrAtZkbF/rymOVF3YyU0KP0eOM/8vSQLuTL7BzbeVOtGZZN9Bekc0ox8SwBMMmOWZUbbRow4GvAUAzpvzF937UsgouJcwhDF+0I650dj6xnVJSQ5z/Qq1/OON9mF+lUtfQaidXHXCLUALRBPWo/CRpzBjHk9yXPiFAG8JNdLctnaJEhIaaEXyxFCTfZTa3iwa+IUuPauw1F9Z1FHUBDgp/yfhVKvCrhUH7vsmWSpaOBZmIlRKOOoKaXfQ30I63Y3Po4rjTzXf1kitE9VtHGli7gOW/YYP0tWV5kKnX5l5YdMySV0feWby9gezsy0uNP7OFtiWH7MOxxghLf39rfjC688u6fpH7UEu7KnPhRk59NfTjsTO03CHz8g7VDLTOQhjn/DRUKeblwo+vawlJWLKfeIlaKXcHoehj24BZPLScs9xm5XIVXxkEwuotR9x8llWR+oII1gLAh+eGYFm9Xc5lFGanrJsXwL6re1jZhOfhEkGComqDMK/0cPlIYJaI0fMJgBARORAiY8tTnriTpH1NrdKzrFKFV9cJetbMbD3l1vdUkMPZMLapVbL6rqqNHS6uEzsgQfDXdAKWWOXwXci7qJl7fY5RBKog35ozBz/mp8l+HbMp4aaEuR1tNqRFA5ECx+yLaBxTaOx+Ui+DYVNZZoiMxRM1IiaZ4iJntjk/w3m5mYNItsMbEzEGw1GpkPeOnq+cFLMvVHJeKBR0xwazSTvHmZg7tzKIznNtNhgClhnPxRTDJd56uZ+zHZTKGqoYk06y/cBZVL6Az0AG1htG4QrvQxvqi
 OIu47lMp
 LtLfobrTsK81rLeNp1Df87FWq5+U1JD2W1yg5xNx2xBNyk9uqv2j3pXo6Ul33/k+wvOpH+9ho44mCjqMJsIfmjegdj5sH3Z+aY3iGYKaLVWLvR1QpOXS1xUkWL9Bh+xi9FTkAYyeVkzr+SS+0dO3+1AXNrZsDhbgkEB69Jy1R9D/FAfGwzcyArIoc8p00uCfZLFaJn5um6TnUJQgEiuOQBPTbYeQS3F+5sdRhGid0cTnaIR6S0SFc6//cTS3v0HsNj6pbxV4USGsTa2aub6zVYjlVstWDvz55J6LmbH9ZDfVlbZrFfl+q2Fm2z92EgfanitQPlj+rIJ3v8u53kUE2q7CoHVxuht7BHs/aDMnfGFH5YKTzsgJx2rLxsXk5Uww8m3k4c1nhVRrPbM0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

This is similar to bitmap_allocate_region() but allows allocation of
non-power of two pages/bits.

While at it, reimplement bitmap_allocate_region() in terms of this new
helper to remove a sliver of code duplication.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/bitmap.h | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index b0395e4ccf90..0fc259908262 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -673,10 +673,10 @@ void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
 }
 
 /**
- * bitmap_allocate_region - allocate bitmap region
+ * bitmap_allocate - allocate bitmap region
  *	@bitmap: array of unsigned longs corresponding to the bitmap
  *	@pos: beginning of bit region to allocate
- *	@order: region size (log base 2 of number of bits) to allocate
+ *	@len: number of bits to allocate
  *
  * Allocate (set bits in) a specified region of a bitmap.
  *
@@ -684,16 +684,31 @@ void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
  * free (not all bits were zero).
  */
 static __always_inline
-int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
+int bitmap_allocate(unsigned long *bitmap, unsigned int pos, unsigned int len)
 {
-	unsigned int len = BIT(order);
-
 	if (find_next_bit(bitmap, pos + len, pos) < pos + len)
 		return -EBUSY;
 	bitmap_set(bitmap, pos, len);
 	return 0;
 }
 
+/**
+ * bitmap_allocate_region - allocate bitmap region
+ *	@bitmap: array of unsigned longs corresponding to the bitmap
+ *	@pos: beginning of bit region to allocate
+ *	@order: region size (log base 2 of number of bits) to allocate
+ *
+ * Allocate (set bits in) a specified region of a bitmap.
+ *
+ * Returns: 0 on success, or %-EBUSY if specified region wasn't
+ * free (not all bits were zero).
+ */
+static __always_inline
+int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
+{
+	return bitmap_allocate(bitmap, pos, BIT(order));
+}
+
 /**
  * bitmap_find_free_region - find a contiguous aligned mem region
  *	@bitmap: array of unsigned longs corresponding to the bitmap
-- 
2.52.0


