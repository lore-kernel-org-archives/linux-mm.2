Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5360D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15AED6B00FA; Thu, 15 Jan 2026 14:41:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135F06B00FB; Thu, 15 Jan 2026 14:41:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0584C6B00FC; Thu, 15 Jan 2026 14:41:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3A626B00FA
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:41:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3DB958EC9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:41:53 +0000 (UTC)
X-FDA: 84335218506.29.59AF1D8
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id E6217160003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:41:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nYFPEGLZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of manish1588@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=manish1588@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768506112; a=rsa-sha256;
	cv=none;
	b=hL/dY+bAPVW1HTyuzo3AoAodBTBSPNP+fIkEBGe5u+L6CPpQrIxeJjeHlhVvdhDz4TFWfp
	HpCoXMKbV3JqD5vSChc4mZgq9k4DWKPM7lOEPWDg5IJh8eOB2YVMS1eFLLHFUQ58tDymep
	KKyrs3SwvC20nXDg2ZVTWhe6aq+eNIg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nYFPEGLZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of manish1588@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=manish1588@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768506112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WQl7iR/tVdOMMi2eZMZAf7ekxCObn9XxdapG7+LUjT8=;
	b=cZoLus4rGwV5ANQtKO2OduLoWYkQgM4Ps6j4S0U+t2K/wCZQefuCqAZ2F4iL0WDVwWJ72A
	vPpczudUo1PE3rVao89LEWS248Edr7OJnZ+SHagT8mUpGM6lWRn6MDuX64SDOTnf7haGUH
	4ldPbR6z6ZtFoiwqkXSlBL0IG05B3ps=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b98983bae80so527548a12.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768506111; x=1769110911; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WQl7iR/tVdOMMi2eZMZAf7ekxCObn9XxdapG7+LUjT8=;
        b=nYFPEGLZKwPQSZ1joxdSUDTz+sRXguo2GvkrMC27JiRAQUkI9bmfUMhqfBP6/dhCo/
         R02/WvdlSc/BdOqODHa+WOlxDFry7haVXz4Z8hLVlNZaoD8+Xz+VnpXWoa5MBTAUW+YL
         1ttnIdGRxLvpfx9Kw3IrAD3gkLdYkG1S3ENG/pal5Py79rfteJKb5h2F2JKcH/VJX9lk
         7IW2PRflTxCIhstpoJJeHrkBDsY3U1r4QefSK4fmcuxBvfXvVFnEIkz2Ry8ML0EKmC1v
         p83BSY0mVl/s17we7wkvlaYy2oy8Dc55jyN2ANVEAjZXJAR5CqmXp7iDvDa54t9iZiMI
         Nsog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768506111; x=1769110911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WQl7iR/tVdOMMi2eZMZAf7ekxCObn9XxdapG7+LUjT8=;
        b=sD63Dvartb4Hr8BmluOhkjcVMHVxwNM2WZGHoHGY1Wrrts9SidR8NAZodh/7eUlp5Y
         AM9dI15/6M3ACsl8IwY5QBqqzaeRPQ1vr3u0HEwzw0IvoDJseNvL8EM66pxoTLpemNJn
         hkkPQGByOQ6rA72AlNmtfTH7T3uTfyqTNM8ChJrZBQtnGwy/XH3cHjrhkGt3E3nNLXM6
         WXhYXENhO6Zmru4tEMi6B08is2K1t600H4wWHACAXxfARt9cZ0J8cdZWqFR9qnfbyKOD
         YX2a/FzrhFBDqAkRYL9mkPdiq/Sn+Nn5LKo8eNLbDzbOkmkMPqGg9QltxImBpmew3JeS
         GfvQ==
X-Gm-Message-State: AOJu0Yz0PC2At3/k+zhDkvdssZuzNNUIWxWQ2yCl24PuopJ8K9hMGkx2
	vw7VLLlgeBzUnWo7JqNrrD/veGJ1ZxjTm+aQiw8IMZzStOq0LRGt4AQY
X-Gm-Gg: AY/fxX7u/Uw+fxAhfseNu8jF0c87VOkyA0or02q8ehFsQQJ3wWrzwSw81Y91cFaXFyV
	ZGmw+X1t915NdEkizARH6FlXivSjUsix+bk7sZGSInNdv+alKLGkcf/6yq/YhdRUmYu5ANhCX4a
	uKoAqLh3Tb9Nd2W4zh43jpIImcNVxiM4RTl/0VmaB939Nq9o1WVdnKUa2HqBB+Ln9qfsTby1SRO
	ADtT6GNDEdggGoim4TN8Y5UJsvtOyoCKuhB7rqVRdIYj1ClunRFphzD+mL5/dXpqtVvrotYVFw9
	edXTRZfqcRtx4ZBZPoChztuQXxOjzv4utmOwLtPU1MQfmrwHXlVBrWrvb97cdBv4ygnXDhDtXXz
	e/z9iOVxoQw6sePh0Adjf4vDPaBdRQI4vmAOe3YXd53Ddf0AG+xpoeYXBh139XOgG+4ifENVGFs
	EjClDceWxr4owDdJhMHQ==
X-Received: by 2002:a17:90a:d006:b0:343:c3d1:8b9b with SMTP id 98e67ed59e1d1-35273243355mr386349a91.19.1768506110825;
        Thu, 15 Jan 2026 11:41:50 -0800 (PST)
Received: from muxbit.. ([122.171.16.181])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3527306c41dsm213280a91.5.2026.01.15.11.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 11:41:50 -0800 (PST)
From: Manish Kumar <manish1588@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Manish Kumar <manish1588@gmail.com>
Subject: [PATCH] mm: add blank line after declaration in page_alloc.c
Date: Fri, 16 Jan 2026 01:11:42 +0530
Message-ID: <20260115194142.117144-1-manish1588@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6217160003
X-Rspamd-Server: rspam06
X-Stat-Signature: 961gucpxwrifn8t53frywtxa1wyx5nic
X-Rspam-User: 
X-HE-Tag: 1768506111-243324
X-HE-Meta: U2FsdGVkX19M9xg7tB2mpahwLKQNYU+khe8f8LtVYIWxq+UrH4UVSP2AlZpHrAPK74W6l/ziKUoYytw9rkzoRoMzUJ1U1cQKlJRfIV22k0YuT5vpLh9hP/IwF4l64Zrgr7L1pk/T6cWHsZZihms8V0OcfN6S+G1UJxj/viYOOCl+ECSURKROeKDgMGWXMEcENLFHvWpmSJPXowwP764l0ZIbn3C9aEwMpAmh5ObWOTCo9fDYC/MtG9bNi+35mQCrncub7w1A9n/LlUeLxHyZD6QjoIJ5y7MjVy9wsKO88817vA3fssgDbGmOvqtE6F6LSFzDRti25FJk0zkaFw6Lt13mTCJe9M3BrXZ6GieeZDBckTgBilEEBwVLIOUF5gCiTPXhIyFvtBV3X8+7618dzRb1fYKOEEGwLQtoaYTo6/ahbPA74nIwHOtnhlwTKg+jSh/uGCXWWitCAuoYfwjBivdRNlAMXrxOnG/VSraZpkaOoPHzLg6xVm3rVwvPEAR9joY7twzF/kjJ8Oyd/gbe+2mxWh2MpK1vpw9geAt5Bf68UHq3j4ij0EjlUxcGGp70GrTuh9mn9reQz2iO1z5/CHTtU1pSiXpUvYnWCDUZQQi5u70pLH+Prs2bsx2ZAjFOQDd2Ty2G4/D0yhI9qtslRf8DVElNZuPXDzBVHfB6gmyx/Wep2JMZQbMnS0t5aY862nchGcd7aLjs1RcMNns48hXcS46Wmmgn1zUnjqwf1+GxKGEG3KzTpgSgdjosUH9JGzO/vijTKZxgdz4M6raeyE0P41gIFlR/I+t2iZHJpj8a+79uHs0ho/CYGOpT5xhUbMIoVUFFbTXayBAjjTepCLlT8CzLFQDrwm1HduIwUqSIpL7VhY/Dd79jSlLLi0l99Vh4pSKmZ+WDfTdm2v8ZlOE2H9JHtHafsjTA5NK8cNcm14vlgYuDRccIcy1YkcAGWqtwMkk/xq8hIxo+LsM
 dCYiQdI6
 CxBqqD/i1M6nvN45j/mjw0RmxThDT1GH9pKvGZwFM2beyANj602Ri82Fx3A0wlMC7OJylJZttlZMsh8wUwvwoYRJh/WBNHrXx7Il6GqbZRETBK9CUN9F2xEWXxTGalG7iDGqiRmZidchubLRylZQLK4waOtajz+zzZzDiKmv4NoYuU9zWm2PEvVMsTEvR/eEHqEyCSZkeGyFL56yQi5pWNoo+aI4/W8b/NtIVJbqQ+Lzodp62+KCm24VNicu9cSH8z7NGf+fGLULFnCZjx7LjuTuXHs5CO0EVPNAX5RA3jVmWv/QCeYowo4s9+BunoNl+bKXYr8Oz05TPNp2PkfOMwhZIwBcJuFATAH4B8U2gdI3noqhAVgIfSGnxvzBG9/kkIOnmx3UrmxGdGthZnjXkOwNSM9JWsR7Wy+8X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a blank line after the declaration of 'movable' to follow
kernel coding style, improving readability. No functional change.

Signed-off-by: Manish Kumar <manish1588@gmail.com>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e8db6af741b5..231950d9d5c0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -659,6 +659,7 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	bool movable;
+	
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
 		VM_BUG_ON(order != HPAGE_PMD_ORDER);
 
-- 
2.43.0


