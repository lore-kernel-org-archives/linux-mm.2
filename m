Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D24EDB7CA
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 08:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956AE6B008A; Tue,  7 Apr 2026 04:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906D86B008C; Tue,  7 Apr 2026 04:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F58F6B0092; Tue,  7 Apr 2026 04:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9F76B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:15:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 130765A123
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:15:49 +0000 (UTC)
X-FDA: 84631051218.10.59A6F4A
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 216BF40008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:15:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F1ZxXRpj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of komlomal@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=komlomal@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775549747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z0L5DxdHGgTgLV0g1fo3M5qT56sdXFA3p4Xf95pp+uI=;
	b=6ESMlfGmHk0DUqof+kulAdkviqUvhNkVQ2n3ZJCurzoev88itS2C5h20m7Axw+jFskhPzf
	pSeMNsTDaO8Hm4Td3pZN8efGufMPHFAI3OcgS7VwI92J27yfBeicg/xOTvcFtlIRf89aFR
	RsQftRVD8mTbU4GSji02IIikDWRrzv8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775549747; a=rsa-sha256;
	cv=none;
	b=KjUujgfHAnD70h43X9ZEx2MDAe8bSQThmqicQDk7AjzrGCQx87CsiQpXT7BB7K57Fhdekk
	R1p19wj47V9M7DN6d6hxZdkHlz51m1Ty7GtUdM+ZcBGc81UHb+EPauOyCvo9Oqe+2Rg/Hn
	DhZmGN5S2biSB8I2RzqD+GoYE055edw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F1ZxXRpj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of komlomal@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=komlomal@gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a2b5ea59a1so5358807e87.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 01:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775549745; x=1776154545; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z0L5DxdHGgTgLV0g1fo3M5qT56sdXFA3p4Xf95pp+uI=;
        b=F1ZxXRpjIWJfYrYpJ6UqmHmi57ZI4pB5891l8CdW+VTsFX31DwgVkoJDv42NVwR/d7
         aTh70GyqTHeGF74LLJ9HJpkjh0Rsn4zqoQ5L6ZTW7MDVTO0yghPK50bEJcIfdsx1W5cx
         6fm1zYAn4DinUmtvX55z12HMYGb2DJyQseM0uPMoa+DfU1lqB+D8IAJRI73eCQNH3iOD
         fUjTCOjsM8/xNW2xg0HuQahrShjYvOEZiILPPFbpKvDaOLEH8ZQo3m6XV3UORSYjyroM
         xJ4HGw2bvrZ+xq5klo1eSEj7ESPtnx3AqBtUlHQpcE61AH044yGx643FNWacZOp8IEcM
         wl4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775549745; x=1776154545;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z0L5DxdHGgTgLV0g1fo3M5qT56sdXFA3p4Xf95pp+uI=;
        b=dkEPKQQ1dsUILDdVbRXew+japyYLeAy4OcaeQhiU8RrdxOWBIuI+fBYlY1nmuAQ2os
         aYc/awLH9GiFqM84Ves1jCVQHj/TWcAKTq16f3kbj0q7Onz6tRofighrZvID8xz7YEfM
         nG85Xy9atIAYNU+42POpXwcSYEdybR+In/nztkHXZidiveCSEM/svzQR0XwegpBXHq5Q
         rVugz73owfCCqQ3M62uPK+z4dM0JGTcWgAGLABI6XfCyRpyhhCJkPsUW3PzuFvFw+ZIw
         DJ1yt33NiXnk5gdebScQlh16ov066WNs4MhhatPSpvsd5136ZnqfOTsMktuaP1ZExw0X
         CY0g==
X-Forwarded-Encrypted: i=1; AJvYcCV/H6wekCd00q6M1lTofry9pxKznMG2TjftkWAJiTN6hAKyMdiykv1wICJXnxg6RCLbwieiuQ9Fzg==@kvack.org
X-Gm-Message-State: AOJu0Yxk+SDLhfXrcwedt1qwOpMctJWUpK7oz20Pc5UhBvdgAL/7r4rY
	BuyVvI0O7Uyyutlw6hkSWeWfwc9mnlbsghPXqHAFSeSrzLTaY6UWXslA
X-Gm-Gg: AeBDies/63TZ1OnwMHPm021kW0dIpXnJ7KkeCbse9z53QErOxuguhdlyT/552hlvxsG
	yV722OS0Bh6Fbf2yP2AOFP03mvs4nGeNLKp/EIJhkTopDa7Qk3zW14lIr8yL/inswB96X09xb9T
	ej9yN0m20Xbu+4MYxucRSZkcisVRPrIGfw2v1kNMzzzhD80tAHe2Dyc7eleJTw30iVVPJc6rvn6
	wiqM7zJG2qlRzypmOufSnecu9ZRIDCipkhaqZDXHq5G1XYWgttCIZgYKYKMW1c9F6gtPj3/0m+q
	n01ECMcE2ZPflrWj7LqWe/MgXA2F/m3px95jMNsmactPGI7Xz2TdF4jTWHmqkzK9zIXexLhYEJo
	nx6dwNJyuqlSfnZEuJTxc4jfy2U6H+DNU7WBWi2v0i5t3g8nKu/R4DZHSru80sdBXcgDe1KbuKD
	cVnTsgidPULtWBbxZQ61TI
X-Received: by 2002:a05:6512:3d92:b0:5a2:bb45:7f21 with SMTP id 2adb3069b0e04-5a33757c21fmr5925103e87.28.1775549744839;
        Tue, 07 Apr 2026 01:15:44 -0700 (PDT)
Received: from agp-laptop.. ([5.180.139.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2c6cd3698sm3937616e87.77.2026.04.07.01.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 01:15:44 -0700 (PDT)
From: "Denis M. Karpov" <komlomal@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	Liam.Howlett@oracle.com,
	ljs@kernel.org
Cc: vbabka@kernel.org,
	jannh@google.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Denis M . Karpov" <komlomal@gmail.com>
Subject: [RFC PATCH] userfaultfd: allow registration of ranges below mmap_min_addr
Date: Tue,  7 Apr 2026 11:14:42 +0300
Message-ID: <20260407081442.6256-1-komlomal@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 216BF40008
X-Stat-Signature: 7xuffoukm4cifiwmn6bwpgrq6omo9s96
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775549746-694478
X-HE-Meta: U2FsdGVkX19vFlM9+7vpd2DuZvAEpUSsXp/fXKkRGA7Ym3EThX2r5fWCzIMVOT6zw5WjF5ZlKZNIQwA1h123zNBM/RscVUS+BYDVHE4GNdF7nqWDxXZLajqEEPVbyMm2qOOge7kmL/TjA2C1SzJSny+TgDS+lSXInb0SjoeG4u5+kZVwr2Xvl5iQuiuuHeWAkcxt2abfL8izYUfSZjPwkgggWibjBBbSTMjqcQ6Crg7LbF3Z65mYyTQa5RGSxdTHY1VOAY4GJYCDzMlYsNjAUhm6N/1Dy+TC7FS33SDAAp19/KOtqBeT/UCv0Zo5baRAL44edgDL0P7ClFe9RpIzVllHMKa4ckCOksqGijXFREnhgLnL1qmfkvZkPXJQVPS4Rto2dQlwphE+yPIRvxSYH6+lb/AkyYWvZbOjGxAWhTJc+n7xSAkby1QsnQ+hBAIq6l1B3Y1hl11dd2dPFpy1fxlGTj3SZY3NLUSuEIh7f7LfIJfgR7CmfA0vxL44bnsXUvdd5dZqIayVPNLeT0HL2vX6TxcX7RdmUbEtLrztorw2dE5hB3MvIXIDtPHw4/evKZczI+6m80nRs6uXaHUmedM3h0yYP3f3STxPAj7L64bwi56FXYczsOk9ivrhkQCCYsQppKojkmDHXky0imginY2VtF2KXZ0u9wNf8QUaa49q9X5/MJU9VeuvDSFWMqUheOHhv031wgpDerlCgRxvgd46gx92h4KIBEhuAvarzs6Xlhg5F6+bR9+TV/nz1uk2p+Ot4FM9a6FyhZog29cb7EutNoZCMr1kknTi4G9wPq+UmdPJzFwBrwsusJVwo30ZuXG0T/vnx8JUodveQkpsnXoBZDqnStM6wtnwKJ34SnCCmkJK1aTOJAMSWUCg+fxANWeERNfDrZaGqo8HoDOhsGM0sN7ecIuucRCTVg6Bc/OCotl77KXBIY++LFaZuv3doUFMk5vRVkLFDXVDD87
 ZGDpAe9+
 O/U6GVBP9F9eOKcZx+bwf4Vpf6qM60A6Jwy/wnijGNChcP19v5Q3/ch1Fj9IGs/xnOJohDt1DY/vqGvv6nRXjKakiDaYvedLGPkXgK2rhNBx5xWJDfb5uweiob+wfAkpjNAfRRm99AZ25sv+1ZMuwvAw2xjVV1uCL88rz6iDSrONX0xNpEkZcl1EqBDhtkBSMi3zNH3+JZ4Iaax1URgGcn4kuybOvn8sUAtXj4xc9f76Y29jerWOb16si2diRTrchRHhRcfmp1WovHdIfK/hZBWxtcvcZ2cldHzxzftpVNPbo7kXxZSYlc22+a/MXkOcASmpYyFL+NTieP5WcjyKa6CRzTqTLr2UimT3stXRlUCeMW/IIZ5N+juKoZkFTbclKOMfU3Pevmoi7einL93Pf+8hX/5AkYHt8UNxYLP6apGwGgNNRutJi3cXiL9Sucg8kBnFy8dwLYgepTlj1cVffer/5hypQe66QZUQrVko2/4PNNQcQkbEboY0Xmoxr6vg+WHiMkgt5ZJ2YBnmnSP6mB34glgesKxAejuubBZzmFwV1PuUGTrLjwSAa7NIBgJ2u2hc39sDdCBikMTCL0Y/X+HdCsKPySydw4a2Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current implementation of validate_range() in fs/userfaultfd.c
performs a hard check against mmap_min_addr without considering
capabilities, but the mmap() syscall uses security_mmap_addr()
which allows privileged processes (with CAP_SYS_RAWIO) to map below
mmap_min_addr. Furthermore, security_mmap_addr()->cap_mmap_addr() uses
dac_mmap_min_addr variable which can be changed with
/proc/sys/vm/mmap_min_addr.

Because userfaultfd uses a different check, UFFDIO_REGISTER may fail
with -EINVAL for valid memory areas that were successfully mapped
below mmap_min_addr even with appropriate capabilities.

This prevents apps like binary compilers from using UFFD for valid memory
regions mapped by application.

Replace the rigid mmap_min_addr check with security_mmap_addr() to align
userfaultfd with the standard kernel memory mapping security policy.

Signed-off-by: Denis M. Karpov <komlomal@gmail.com>

---
Initial RFC following the discussion on the [BUG] thread.
Link: https://lore.kernel.org/all/CADtiZd0tWysx5HMCUnOXfSHB7PXAuXg1Mh4eY_hUmH29S=sejg@mail.gmail.com/
---
 fs/userfaultfd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index bdc84e521..dbfe5b2a0 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1238,15 +1238,13 @@ static __always_inline int validate_unaligned_range(
 		return -EINVAL;
 	if (!len)
 		return -EINVAL;
-	if (start < mmap_min_addr)
-		return -EINVAL;
 	if (start >= task_size)
 		return -EINVAL;
 	if (len > task_size - start)
 		return -EINVAL;
 	if (start + len <= start)
 		return -EINVAL;
-	return 0;
+	return security_mmap_addr(start);
 }
 
 static __always_inline int validate_range(struct mm_struct *mm,
-- 
2.47.3


