Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C69C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CC9B6B00C7; Wed, 22 Jul 2026 19:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4F76B00C8; Wed, 22 Jul 2026 19:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA3C6B00C9; Wed, 22 Jul 2026 19:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4316B00C7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:02:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71572A0292
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:02:55 +0000 (UTC)
X-FDA: 85017939510.24.C29E1B7
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id B9C6440006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:02:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h23nPmt7;
	spf=pass (imf04.hostedemail.com: domain of mahad.ibrahim.dev@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mahad.ibrahim.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784761373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kv31Od05MjV5ejp4GXE3h+wOouFnNcaRzCrwckd302Y=;
	b=kba31Nv1pVL3J+UfFGVv2AdUItq4+xfcY78wr995zub37B7DHdL1duUREh2eIuDqHsLJhg
	JTxobO87BFF94JIb16vSYhc9lGlRvdS6hZCEpcziBrNJs9pTcu5GegKyex3fNL7Dfo18j5
	nKPMedfMpkNlETqc7cr8pzg2XxkI5k0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784761373;
	b=zNYmcQn9dhxpZOklWIxu99zQpm+6JX2DenhzY3Es3dA3RNZ5qjn27wVK8yAwLk2g2x9Zqm
	o1J/MnxdPA9G7YO5yNLp7QMIsFIBrpd05B8h7xLcl9XMMSJkKFi1imShke9SrrHTCZye9a
	7IhJIMeos8QxUKFuCWS6SZq4LINkfzo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h23nPmt7;
	spf=pass (imf04.hostedemail.com: domain of mahad.ibrahim.dev@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mahad.ibrahim.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49554ebb87dso321235e9.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784761372; x=1785366172; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kv31Od05MjV5ejp4GXE3h+wOouFnNcaRzCrwckd302Y=;
        b=h23nPmt7UCGER3pdc9tcaZOqbKrQldMdjKufXGMhoRneSTvYZH288TuD8JDJH9PXog
         PkJjh+jk5vZ239r/nCtSHGH5EMoMgZvjQ+CMHCooSdtZ9YYHErdAqZAW+JICkL8SDDmH
         nzbxwgnNDEewTrBK8KbEAwVNtPME735Mr6fe5udfr27bYaXgj3pSZuBc4IFljHgWZJDe
         YJ6FEVV0EcLIXrqlCIrahVGuf+GVdA5AktDmJrgXZ7gfPqIEAmgjp5INhD0n8UyWrWpu
         1zDlaHm5haYMBMND7uPov4ISERKZQxop1HO6P0tn8rZ8vXozK/wwLPVPBIm5+VLLHPu/
         SMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784761372; x=1785366172;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kv31Od05MjV5ejp4GXE3h+wOouFnNcaRzCrwckd302Y=;
        b=B6vJDITg0PKfEoKOmvVdSmvWEy9KDGhVg3X4QDbVnTwSF8bzOHkLxXs3xd77R+4GhI
         KZ9WXvl4PgXsGQQg0ShZ/6jKeDKrjfjOYG3HD4HDFCALVz1Pt/V/3u7c2PhjIhgSUiIB
         e/5RH1SSp3TUAJQv2HIjXG2mwh+QAnNxhFyjTWuGuCLXTTQx5tYN5NbufK0wfiknuNs4
         7Y1BFGaKnlp3m87yWGk/0iq/JYBSUBIRcalZL+18ecoR/LYnQPrlGLDif3xlrMzGX0Y9
         /JLFk8WJcSvuj1+HoVyxI+tDfrI7N2dLvk+0iY59R0eDNx7UkVztTRy5YQlkPAYVqYeZ
         kLZg==
X-Forwarded-Encrypted: i=1; AHgh+RpilVxvO5yHvVd2CQXKVwCThoEMR+jBweEvSv7XkG9xduBHR9z/PwMwmOAjGhhw0rbr5nFzaZXsbA==@kvack.org
X-Gm-Message-State: AOJu0YyK30hoi0T2jIDhfiL/dybbV6akxMjWBQC1nAZgfdI4Vke7KnqM
	mSl/SyXD3G1KaUx5pYthnn5MQIt+8u0bHxc0WlWdx9zeqnE0/WfBD2cb
X-Gm-Gg: AR+sD10Z9W3GSSTatzEhrNQM1dyCZUe09IBNMb5qaGarLtiWA1w6rY46bDeI0Pp2LYQ
	pnGh5CeUGtcKqmu8O5CMp0sYpsPXhzSMOeC+wX0+5KlzAE1ULfAVhywTcMty2oi+ACeHHQ3LzNo
	uiXMSOhpZO1Wa/h0/7S9sBceoOCYoYVWOpBV63MwUAW0/NnEVUa6Ohg/286u7/NTtuCvRNBVuke
	63jDJcdxc+pV8EoSpYC0BZFN9deUrWbLsjas4jFf6Gvz4ajGdcn0zwnnQQY74QbOGKP7SELBYvA
	SDDya6ganVLS6c0RbpTtzUDDinMPQX+rumjWCXECVTDc7KIvk3awS4ynVgQ0CveXMfMFP+OOCk/
	1BkMEGSUj9bjb+HUXvjsk8cXFQFItrklTFWRAQa9NdhfxVwgThpqkTC5TzgbLNHrw6lEnVGn0nv
	a6F+DFDSgrl3pUGAnzHqnvKFNJ
X-Received: by 2002:a05:600c:46ce:b0:495:4d88:e630 with SMTP id 5b1f17b1804b1-49573cc9704mr6470555e9.10.1784761371977;
        Wed, 22 Jul 2026 16:02:51 -0700 (PDT)
Received: from localhost.localdomain ([72.255.58.127])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495653c8760sm163276375e9.14.2026.07.22.16.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 16:02:51 -0700 (PDT)
From: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>
To: Kees Cook <kees@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>
Subject: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
Date: Wed, 22 Jul 2026 23:02:46 +0000
Message-ID: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B9C6440006
X-Stat-Signature: mdn55eg3e5x4qxjhcshmm4sccfsckp3g
X-Rspam-User: 
X-HE-Tag: 1784761373-754292
X-HE-Meta: U2FsdGVkX1/vbm2X/7nCAY6iXxhNfdtHmqCpKEa9uT6gtMlDDFnZtnuAABihAiVxplDenexxGRAKXaUreLzaHc4hF2NbWXusXyKSbXk4l57l0nr8IPGNu/mTG65GlnPR8MOAKuATAA1CYRYHiAGsJKSDGhD/IIYTRJ9fGPayebk3NjmYDwBNV8X2euTz1kXnA9uJvHxnxfMbph3p84+qdZ7e+/sQ2S127LGU+3uTDvyNizCPrKXC+VWgWPhJYYmks+9ZbUGd6fRbQJHH/CsaSgIJ3Yzc1hFvS0LFv31zmtbbjeFd57xWnjkKyqNfb0N0Gduf0B+KH/dWxES+qFLLn4pNvDt+qBlX+hpIZkyQY43n/4NwLMPjLZIazpVGmZHU01MPqcJLN+5ye0JRD9/Zj83hnXocLrYHSBbz+M1NV2PjQSDpsFR9w7rVj22002dMY0yKEEkvoPMDh0NxEPkJrJ7EQ8RqhgGosFNcNwuKz40g7KZ9DWzcxrBW35byxgziEEuUVUuWWNGUs1DJPTuMHpJxI/wo3f3ebeg9nUudt2szEY9XG2kWmSnnfLuYaPIY+Hvl6Q24/Rys2wmY3qPAVuKznmkgA5ttpbeOEs2ichItEgRN3uOAxPMR+O+wpykHU3ut8Goh9imvmIpNdhdUnuakQckbOlgdw1DZtUMD6X4BdRaUiiIu+XUsw6iP7NxwFpYhXwLqo4qnz/1/Kt5RZBq0Shmaukx4K8dVxQ80OZHEcz6t66Vu1TMWwq6qL4V+HFsODi703ff/kOMYLw1k/g1vpZQkY4CNbL/oH+LU+Tmuq97CtgYh3G7V6l5QO6/x11ikvXPEEAYpS59N8uJM2FaMGS69ja8KM1fTOJ9weUVG1IjLxXsLjkhLMyXcl9cvivG4hJcCi6uNcdQWylBMKbcn/e+zVBKKF8ccW2ORid74gG1Nk+v5YZHpnO2A5eX0hPr9xJFSun1CY2B4hTO
 K/bOns6P
 HETaPm0XRTz3am6kSKPBvDJmO/EDqWWNZ2aG1ybm3D7uRgZO324yYyS1LBvS/8aKn7pWmGlfY6aDchjKmW6EhWu4Ph1hZl1LjL/RNBsS5C1krLljAQlFXW6OLRZTBrFdRlLZD5e+dP5QFjkh+bjQQ+30Eo8RfZlErVGeHUxwNcQXi2c+1CcXGR7sH0RG/eUqUQAl7CrWA/0c9pVXNFOI8+SeIidlbv1PX78j/rcWq+tAND0oZxbHOA/iLlf1dtzAwaln9VP56unnAIjXhmwILTYBBlJ3HZaGShCcA72ZkJOrwcA8TrxL698Rl7kDs9TFyJjO8w7Uhgm8y2unbLAlhJTeDlduUXHH+yXQGoWU4CdOBMJ53lsLR50O+d2AQrUMMleZL4aakICsnk1LlOD1RDyQsr0v9tzXVy4x7LkzwiPyXIn7O2Oi/9S/HL/H5cdNBrjkhsL6NKMWyOgcMdn/OCBzZLF3nvoXWrsQVnkLP7PqSlbKi6xIopTs/UqHcbS20izHu+vHFiN7u5nPg+5ARfNIj8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lkdtm_debugfs_entry and direct_entry use __get_free_page to allocate a
temporary buffer, perform copy_from_user to get the crashtype name,
strim() to strip whitespace and find_crashtype to find the corresponding
crashtype that is being requested.

The lkdtm_debugfs_read uses __get_free_page to allocate a temporary
buffer to store all the available crashtypes, and then copy it to
userspace.

The buffers that are allocated can be allocated with kmalloc as there is
nothing special that requires a struct page, or the page allocator.

kmalloc() additionally provides a better API that doesn't require ugly
casts which obfuscate the code and kfree does not need to know the size
of the freed object.

Replace use of __get_free_page() with kmalloc().

Signed-off-by: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>
---
 drivers/misc/lkdtm/core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index ededa32d6744..01bebcb33bd4 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -236,11 +236,11 @@ static ssize_t lkdtm_debugfs_entry(struct file *f,
 	if (count >= PAGE_SIZE)
 		return -EINVAL;
 
-	buf = (char *)__get_free_page(GFP_KERNEL);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	if (copy_from_user(buf, user_buf, count)) {
-		free_page((unsigned long) buf);
+		kfree(buf);
 		return -EFAULT;
 	}
 	/* NULL-terminate and remove enter */
@@ -248,7 +248,7 @@ static ssize_t lkdtm_debugfs_entry(struct file *f,
 	strim(buf);
 
 	crashtype = find_crashtype(buf);
-	free_page((unsigned long)buf);
+	kfree(buf);
 
 	if (!crashtype)
 		return -EINVAL;
@@ -271,7 +271,7 @@ static ssize_t lkdtm_debugfs_read(struct file *f, char __user *user_buf,
 	ssize_t out;
 	char *buf;
 
-	buf = (char *)__get_free_page(GFP_KERNEL);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
@@ -290,7 +290,7 @@ static ssize_t lkdtm_debugfs_read(struct file *f, char __user *user_buf,
 
 	out = simple_read_from_buffer(user_buf, count, off,
 				      buf, n);
-	free_page((unsigned long) buf);
+	kfree(buf);
 
 	return out;
 }
@@ -313,11 +313,11 @@ static ssize_t direct_entry(struct file *f, const char __user *user_buf,
 	if (count < 1)
 		return -EINVAL;
 
-	buf = (char *)__get_free_page(GFP_KERNEL);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	if (copy_from_user(buf, user_buf, count)) {
-		free_page((unsigned long) buf);
+		kfree(buf);
 		return -EFAULT;
 	}
 	/* NULL-terminate and remove enter */
@@ -325,7 +325,7 @@ static ssize_t direct_entry(struct file *f, const char __user *user_buf,
 	strim(buf);
 
 	crashtype = find_crashtype(buf);
-	free_page((unsigned long) buf);
+	kfree(buf);
 	if (!crashtype)
 		return -EINVAL;
 
-- 
2.54.0


