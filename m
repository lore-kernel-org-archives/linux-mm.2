Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4FB2F41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1046B0005; Mon,  9 Mar 2026 11:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F866B0089; Mon,  9 Mar 2026 11:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC30C6B008A; Mon,  9 Mar 2026 11:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB8B26B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:59:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D4368A5E0
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:59:50 +0000 (UTC)
X-FDA: 84526985340.24.4D8CE76
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id C6DAB8001E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:59:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FKN5In6y;
	spf=pass (imf30.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773071988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxBJyqGJiol9HEpza28/mPltLmrDdSsX1VZdrScZvFw=;
	b=eTPkcP3IbzbZb2WYeh19HgDzmz6etGoXPE+WDlygUnfkq3SvDzTKYeQbIXel1b7Cm6cesu
	fTQl+IWgSqSky11OoN6cRMRzVT7tNMJYToINApb9X+gZY+Bduck07Bfrnb76lIWtsw9d5D
	AC4ipCCJRb1ZeMCRcc9ad7PzFPjUx6w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FKN5In6y;
	spf=pass (imf30.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773071988; a=rsa-sha256;
	cv=none;
	b=3IN3NcI90hWyEROsl2Ra1pVNFJ0syOLiG6xfEIC5QvOK/Za8TVtzwRUTSyhW0OTqpR2NKA
	tfsUbzjf6p2u9tGZvRzTAZC8UY8/c6QjxOJE+MZDMPv1A4LmUBRXxBSloQX79lGL2FfaF9
	k+pOi8wUcNSWxRvNzohUHw27AepHxBU=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ae46b9c70dso34014225ad.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 08:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773071988; x=1773676788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxBJyqGJiol9HEpza28/mPltLmrDdSsX1VZdrScZvFw=;
        b=FKN5In6yeUGaL9X/F6FZ4ck801Bs2ZZeMUOl8t+F+Mssv1CNjxcuUO7SP3kpTzQCQr
         9OYWloa+stPufqcWHeEYxX5daq8K/jGQj/sjQ7BBQfu7ns3bwsDx6S17ljAgrthnYRsR
         496TcTlzxxxmXWdwxQDjGzW5YXYc/20AHgQWEIYfeQGm9bRtJmwRr6ejCeTITqiOb4jo
         lJosX0q6Lx7HAqReTlZ/5cc4RxDmZIDJuRBt6VENTDh1715qRNRCnEXqza8zxAYfTGnH
         FFyqAkQqDoBPAHKsRYq0UbUl+BokMZzNNYv0zG9KDHpZmcD9xneBfuZoRFOELUl2o+2r
         /XSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773071988; x=1773676788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lxBJyqGJiol9HEpza28/mPltLmrDdSsX1VZdrScZvFw=;
        b=LnKQ2BBKxBOv69cPM4sR9EoM2Ll/mWTUK0p9iJx+lzPOZlMJTkR1P4xP9eBFQK8M5F
         2hroNEkMdZR8QnYsUVnTUAgswV/LHzPNvt8r3yzPdparS5EabfxPwzcLJ9TJvOrwTMjh
         557FOpAJ88aRVJ4So7K5kqTOdhmz6+fLoUL8lty5cQuCEE7kG3cOGAAYTVSx7d64c4qi
         wL7/Og2v/vw2NkVsUVd+ILVa8XEpv6mTRJRj5fRn8vXczmKEkwWYoDKjnnfhYE3RFabb
         unYDH8UcP587Sc7M+mxmpmDUwbeNvn67q7t6ogMwhHxIaSvEiB1pQt7KbF1W404hQY8n
         bB4g==
X-Forwarded-Encrypted: i=1; AJvYcCVq4cYUYyTAOfe8cxNRxukZQL3CHI80tNT5JGv3RaRmXlS3gOg+Wde8zEWd01vWjUCEF5ql8irheg==@kvack.org
X-Gm-Message-State: AOJu0Yx2XH3KqTolwxro/IJ7pJTBrDsTP4z+vzftXum5z/6VXUN/H8J7
	yIoo7Jiw1pR7o2a2z5NGOca9iE4zHiIuzz30cBbQ+yVHR2douExBpQAW
X-Gm-Gg: ATEYQzxVOXBt86+SNIn80Sq7lYB/wKmT3q7prWhyt8KFGUmDpDxYUJyqkbGJdVy9dgk
	tBPIwG/2Q5As84mFGWaV4t73a1rKtk3Cw382558j1kQAZ3X4MDzhsfTS4p+8KMsFctvgGN3tPxt
	/KOP3tHXo0wWQ5w3vCtzKmaulvapVi8iDjnUwESBriNE4gsuYOnfZ764H/8x3RKb48AkTgp1xu5
	TYHfvY1JFML5k7A8DjIxqb5nKlTMPRtvM/loYNwZGn7EnP8QxkhXn0x4p1TemefvmVJONwIBTsw
	jdKXDZHw2/wjVtZ1m+HB/5hA3JkXuBDpsoh/+5zrfaJ1VgMnwVZperEFK852NL4MQUThFgAoHl5
	VlKRRSu7xh2+L20Cj3vBJTADKJg5p1/EwIUc1WiEGfWlYGswRm3zJmD1DYlcI6pXjG/1sw8aaZQ
	UhfH3CQxBRh2kB3qhVs208NzQoS3cfe19N8x3VejLqZLg=
X-Received: by 2002:a17:902:e892:b0:2ae:4da9:afce with SMTP id d9443c01a7336-2aea1e1b6bemr505155ad.23.1773071987450;
        Mon, 09 Mar 2026 08:59:47 -0700 (PDT)
Received: from DESKTOP-3LEPQG8.localdomain ([119.28.20.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83f8a629sm144852655ad.62.2026.03.09.08.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 08:59:47 -0700 (PDT)
From: Xie Yuanbin <qq570070308@gmail.com>
To: willy@infradead.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david.laight.linux@gmail.com,
	david@kernel.org,
	justinstitt@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	llvm@lists.linux.dev,
	mhocko@suse.com,
	morbo@google.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	qq570070308@gmail.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: optimize the implementation of WARN_ON_ONCE_GFP()
Date: Mon,  9 Mar 2026 23:59:33 +0800
Message-ID: <20260309155933.41179-1-qq570070308@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aa7p3eQfEuh2wObQ@casper.infradead.org>
References: <aa7p3eQfEuh2wObQ@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6DAB8001E
X-Stat-Signature: j3g89qkntarzjzycw34g6nkx66ofbeau
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773071988-780633
X-HE-Meta: U2FsdGVkX19A/wHIKDaq5PL631tOsD6Vfydkd1yDEdiEYM5o0CiHQMHC5feq7MB9c2AH5BsSc17GabBzRmZ/VWd2Jp+pfq1HJEjoCaUZ3v73FHXrBtj8V0VrKrOL5CS0hBfZTq4mpLDxsRZV+t6RBmBZxD2+3xGbUCl3BZl2RNm+3A51gGTsEbtco5skk/sV4pZNsO2uKk4R6wrE8fMHNN4VnSFplikhTRYHfc3P6P/VsbHG/5pmq5EwwEb2U7Idmmtqis9BBgwFtMVJ9FrwVzY2EX3uXKHyLflMITrZwuA+ASSf9yICHy++7H90rrfezGeDDgM9gSGqF+V+mJbz+xjMNhQQlW3HTLs4xsMdKKMtEO2qGtkz6zhQ0HOt5T4ic5dcHEt5+5UYO9ewz9C7CVh77DhykRyVx9vHMCf4A6h8TTY8bFCVXyDqGkh6ZwIBopPuPVJON6J0zisTPyHwrowyetwtlaQZFg4/p1rHVWcWhmcmujs9fRyzxB7JvomAfXM0maUwBrD4yMSTa73JrXei4DYK9ZB82ltbZ4wIBO+JKvNkgb3wtU9CPLlMwsWIC9gj3f+uHXIp9QzzZbdTcWoD/S337ZeH/QK2B02f6OgnS38Ir3nYtEe9ttQ6bmMQcK1FapwncwlmYa7BxRtnGvpUX+cIDSunb2CHszYPhJ1YT7mKDZVpGnHKwpdwv1U3n5TiISZr5bK4QqPMaAf9TUrMmpDKOLc5pmnv4yNHYtRoCt8rrAJRoNXgUlo1sXklnl+EXqBklzzll76PYltzlyz/8Kw0MzKsjZRUnO6QjlTcnNJfi6KEeJuPd3t6/PzmRmXKN9XHHy5Sm53KtFTnJNRNzriZ/Ui9AeSD5ErZEVy+03PL8IlNaV+OTiA3ptO1n3ABDdZD3Zidv8LuqWqUlOA9KG/fJ9Oam2qlhZgcc0QLOxJuGlH1NJIElCWHu4K3lg6Kdv/o2XsraST+DK2
 itN8/61N
 JIpCJBV0qUC1sR+u8PvMu975IgUmfAO1vyjbs6IU+Xrx6kXtn3xncgSpawCKa62TXZUPXtzhuCRZDAb4CrnkZFjnk8195lfDv25AH4M1udH2CbmnHT89IbrdzZ8V1gfrujkWNw1KtwQyhoWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 9 Mar 2026 15:40:13 +0000, Matthew Wilcox wrote:
>On Mon, Mar 09, 2026 at 11:38:11PM +0800, Xie Yuanbin wrote:
>> As shown in the commit message of commit 242b872239f6a7deacbc
>> ("include/linux/once_lite.h: fix judgment in WARN_ONCE with clang"),
>> the code "unlikely(a && b)" may generate poor assembly code if it is
>> actually "unlikely(a) && unlikely(b)" or "unlikely(a) && b".
>
> Why fix this in multiple places in the kernel instead of once in clang?

If a and b is both unlikely, then "unlikely(a) && unlikely(b)" will
generate better code than "unlikely(a && b)". This is also true for gcc.

As for the issue of clang judging twice, I have already submitted it to
clang:
Link: https://github.com/llvm/llvm-project/issues/167117
However, even if clang fixes it, this optimization will not be merged
back to the old version of clang.

