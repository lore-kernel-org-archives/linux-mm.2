Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0AF4CA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD14D6B0011; Fri, 29 Aug 2025 14:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA85E6B0012; Fri, 29 Aug 2025 14:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A490C6B0024; Fri, 29 Aug 2025 14:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95B416B0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 505601608A5
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:11 +0000 (UTC)
X-FDA: 83830639662.11.10B8427
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 29B862000A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=imWK3cRf;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492329; a=rsa-sha256;
	cv=none;
	b=Am+E+0skJ+9FCiBYzzFDh111s0LMqBqdvbuJ3AlO1tyW+ABGSosHYvSkCDuCYcmMeoQu9W
	UWDE5GvWFplonA6vANf0vWznCWMhVnqvaf83YNDT47S93vkcZEdBte8/Mqt72FwugGIIMv
	Wh7Xh+QQsfCRwEKCjrg684aGgk96HzU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=imWK3cRf;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSo01xEtu7GaLlUrg3B9Uz1MDG42fOObUQbcFYUl6Tw=;
	b=FfH3s0Xg7GZ35kneEGVrpwdE7Y79tVQkk1ejyumbodESF2vsVFHwb67Sh0+mjpga29bPxj
	dYq5QJ0Y+W+Fy+iRjzDHHwG+2PntVi7l9iVPyHTKmwIU92PTHOLDq/8e8w8WfZh/vjGWq2
	XUDYsFwjq/aXiPt4/0E4PIPes+nqjrA=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afee6037847so362719166b.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492328; x=1757097128; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TSo01xEtu7GaLlUrg3B9Uz1MDG42fOObUQbcFYUl6Tw=;
        b=imWK3cRfekfKzTbJICSKI8hlpGJhmhqpEmyTTHZl69cvD8Qd0N0h0Elmu4gkwAqDEz
         U3h4QZqGxaqH8qopxYRKz9K8iHA0Ruz9aJQicTe721cJDEwaikzA5FjciIKbLqzhoT6Z
         Q1EhE89gEhbuW6X8wlCX8V/mCVbXHDlXS+v2pAIaD6/e6kw48aeN8MODcFQO5OY2PidT
         jRncXsEtP/ndQqpoduyxl3ifajCv2fIkxfycnNlSAz/Bdp35TAJLEx8gjnIvT7oBSwX8
         /ZGlaCZANQyl8eAe1GLhL9VgbkrKoKYeV6Lw4MsKd9+2+MEM9NxpWvKxKddAi5hjumm4
         r+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492328; x=1757097128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TSo01xEtu7GaLlUrg3B9Uz1MDG42fOObUQbcFYUl6Tw=;
        b=UyTAICMHjqjcYV0GyablH15/zquYyM1qiYRMciJ7GKIWstcjOl8MAWT7eEykp/BzCG
         VBYmckJ6kdnSdv6NgNPFNqZ5gP5TwqhLDmhzWSzlpx/Iko9mF2xp8Hs8kqb2ko0raX5S
         oSdf6+yHu61ilY7ndgwnCwUnyzqihUDZJ1wOPGMsDMIMX0A2AZflGTP7ButATGmJoCgs
         U1816KIpfabJh7ddus0S9Np4lt0ptk2Oa3DOBZ1tgrYxEqkbYUkzL6wCNXOtS31No9D8
         /RB1zcOch2gUsBC+a+gH5+CNSYLmQee6MJJBmEDzgu5m5nvlE4UR5w9ZCSly2I7AGRON
         gfug==
X-Forwarded-Encrypted: i=1; AJvYcCVTD3zrc/vrzkELMeS0MBBa7GZraHqcIlAE0J5iWpeO+n/XKDRRmQ3B10sh8XLV6x/0w7bYuoZ8MQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/4r9ec2T/1VKHA8zeU7K7JstalampoucrcSP33ty20SP03b8n
	IQgIJTUi/zrMUjiVqZgt4K9L0VBPav6k9lGxDlxLwf3HszRNJ0HXj8nrN24WiS9b0hY=
X-Gm-Gg: ASbGnct9QyTeZmAhJbZUFB7FVabbvWWFhA6RWtzoYIjqzD7f0CVXH0aztWBZ71lTSOT
	wFQvvf6wutdvZAkQGHy0kIZ0ObymIqNuqHrMu2P8ZCx7SsTp3mgOiwejct85N0aV0JQQrMOG7Zu
	tUpeFvRDxtIzlhghzhdJfPVB6wtYKaiw0dulvwQB01Ym05fQU0FvDJAM7KVIZwdR1k4+zakv/iW
	4D4xxOJ2ax/ve3lU2BKuk6OfHh7pbG4fRyPDQX0g9EuURfmhJ2VrZ27Tc+ra2s2vKE9z61lkXG9
	MugBIGo2+igiNQQ8W/ysGTX18J1LFTsR6n5RKy1nb2v6IDuK+f3e/tEOiEc7JF7Kx3CKGJFADMS
	AAkh7VgdyAZAuIw3SRV2MGL3mGllepCiIEy/0r4+tfDrsddnY3fCQuOu7nB4KUnm7bgnlVl+JaB
	2O+d607e02yNSudwU6h5KyNQ==
X-Google-Smtp-Source: AGHT+IGgIyPvXdAAvfBmrm+euAdBjSIIwKAClvgKzuXio2hH7ieSXYoNrka6sHgGz0RCbGkrNqL78g==
X-Received: by 2002:a17:907:3f07:b0:afe:35d:fd5d with SMTP id a640c23a62f3a-afe28f75d2cmr2585600666b.1.1756492327516;
        Fri, 29 Aug 2025 11:32:07 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:07 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 01/12] mm/shmem: add `const` to lots of pointer parameters
Date: Fri, 29 Aug 2025 20:31:48 +0200
Message-ID: <20250829183159.2223948-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 29B862000A
X-Stat-Signature: 1snuqxkbrpadc1j8bsckxw3cerdmz3bn
X-HE-Tag: 1756492328-48742
X-HE-Meta: U2FsdGVkX1+7ZzBWhnQaNHfea9laDhBtE5djBhiXY0Lk4xjHPod8bctdUvVv3XDgIydXzbg9FIrPR1wEuaKccFGON/6orGAVdlzDr+t8v75Osn/z6Zm/XQXlqVco4W/H3N4o03d/xjPShdDZx9uAveiPZAqVcYOTr+AZBOR2WVc+SOX07ecUhJJycI6QZqzolbXxIcYu7jNoYCzG0rgLSeLEWwt0mufUzrqAslawL3pMGgZoZ5Xd+OKMFtufDDsBCJ9kI5GboQAGPyouDefchqqffOfjgUKz9IBifS3T7IPowwEV5SzNiJ35fttjcLeBH+9sl353MXjORKPi9NLKl3fz3/GPjiWHaZeicSjvySn4ZeoHdIPd85YJ6ApRPb6hHf7GTuMcaun+Z7MOLlwpCi6Cnj599DHoFfRIcHzZU0zK02vIQ07aC7F7ujk13tdUbnMv1KRaXs+NJgVH/MVW72Fak7l2J0JiPj1W87TVFjgGkpzex2pBpcefr2c0vIrXGWeOIJM4jxy954mAGR2NOKNzVixwuqn+ozPL0xOLkQfFz/kqt4upHZp5PKt1m4IEsTieXcUPCNT5eNT1/hQxUMULkTAa2W+/B9x2kIMuuCwwBmkT3v9nR0jgzN6lOBxW51IvLPD66JH+QFP762tN8cxwc11u+hh6x6CRpqdDCqpUkw5Nh+0kyIaN+/Toq3NATl1yLVn6q9O05CcPfC2sJgRM9koctUotcSiRpZZsJqK5FYUxIGyQGIG2G+rMZm+ubvAnqk/nsiEAypfQmSRyUmUWdVvDdwyteR8lH0EQt9xu2igslsW59YJcwL5woKXjdT/Y79kCaJqPVUKK+1pKVHylUIJZCRlMbXF+I498qYxaqzbFAC04Hw01Y0ljA/QpSc8vm7PnHln1wOjQtL9hAuYVOHTSTzxBMhAaJLNWuAYtLss6vP2jYT1dFyPzgtkvuFZgpvJk06REBu1two/
 WahWZWJI
 WhIgyUJv2Hq/FwdzjAORBimdeeWwHN+LoQeQun3HxhqqO7vM0nXG3HIBw7r7fyMvNYxI0ugmFtGv4F1+/UNHJPaINcIbWSS90U9rZ24dAk+IBZUzDl2pxMCSmPMNmdECnHm+pH0Eip52J+YLEZkVpQ3W0ELUeEYsg+ZHWL2itY+aSRj2NcyG/7R3T3bUep08S2j0VLSZQKM7+tlWZ7vgtZ+8V8sjQqt5r1eS2ye1Oyy8I1ewXbaEJYwSQKGDMMA2nxFKdKUsyRje1wpIyJPR6juN15fzK1BgQhmQiNeMAJjpDJwF4kZ+D4Dohsi2SQJt0DZNTRL4naZb9OW4OsHOG2yiQ2vkKv2eFvNc1dHLkdQCY6lc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mm.h       | 8 ++++----
 include/linux/shmem_fs.h | 4 ++--
 mm/shmem.c               | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 00c8a54127d3..a40a3c42c904 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -979,11 +979,11 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
  * The vma_is_shmem is not inline because it is used only by slow
  * paths in userfault.
  */
-bool vma_is_shmem(struct vm_area_struct *vma);
-bool vma_is_anon_shmem(struct vm_area_struct *vma);
+bool vma_is_shmem(const struct vm_area_struct *vma);
+bool vma_is_anon_shmem(const struct vm_area_struct *vma);
 #else
-static inline bool vma_is_shmem(struct vm_area_struct *vma) { return false; }
-static inline bool vma_is_anon_shmem(struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
 #endif
 
 int vma_is_stack_for_current(struct vm_area_struct *vma);
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 6d0f9c599ff7..0e47465ef0fd 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -99,9 +99,9 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
-bool shmem_mapping(struct address_space *mapping);
+bool shmem_mapping(const struct address_space *mapping);
 #else
-static inline bool shmem_mapping(struct address_space *mapping)
+static inline bool shmem_mapping(const struct address_space *mapping)
 {
 	return false;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 13cc51df3893..2a4476e223a3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -275,18 +275,18 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
-bool shmem_mapping(struct address_space *mapping)
+bool shmem_mapping(const struct address_space *mapping)
 {
 	return mapping->a_ops == &shmem_aops;
 }
 EXPORT_SYMBOL_GPL(shmem_mapping);
 
-bool vma_is_anon_shmem(struct vm_area_struct *vma)
+bool vma_is_anon_shmem(const struct vm_area_struct *vma)
 {
 	return vma->vm_ops == &shmem_anon_vm_ops;
 }
 
-bool vma_is_shmem(struct vm_area_struct *vma)
+bool vma_is_shmem(const struct vm_area_struct *vma)
 {
 	return vma_is_anon_shmem(vma) || vma->vm_ops == &shmem_vm_ops;
 }
-- 
2.47.2


