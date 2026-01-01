Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24ED8EEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859506B0088; Thu,  1 Jan 2026 17:56:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCA06B0089; Thu,  1 Jan 2026 17:56:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC406B00B4; Thu,  1 Jan 2026 17:56:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 586FB6B0088
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:56:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDFBC920EE
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:56:00 +0000 (UTC)
X-FDA: 84284904480.13.9E4F7F5
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 54F00120008
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:55:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LvE3nsof;
	spf=pass (imf29.hostedemail.com: domain of 3fftWaQcKCCIERFCJCLEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--gthelen.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3fftWaQcKCCIERFCJCLEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--gthelen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767308159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I1gS6epj+hr0rH6I+yAY+Pf5DGDN/1lY3+3hmzSOP0E=;
	b=fXso41M3L+E3Toyc0HmKF6z/KcdeNpOcJSdYsF9Xdl4m9C8OGatcxGpd2uqXTNM6QwFTNd
	gX6Do0QssJseQclJDk6goSihNDGabje9l5gROStzNvL8aeLR+QOm7SSt7FN1+cj16YiAV3
	X7VwtMMy2PfZnnaQtapWACUBVCDo6bI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LvE3nsof;
	spf=pass (imf29.hostedemail.com: domain of 3fftWaQcKCCIERFCJCLEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--gthelen.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3fftWaQcKCCIERFCJCLEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--gthelen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767308159; a=rsa-sha256;
	cv=none;
	b=STd6oNi4gX5s7f9TSPHbutMKWO+3qUUV7OQRy4FshfDacZqIFXJ3A+zXOtx1FfMKQGxLVg
	jMYphE8hNIyVS9rKp6npfWDob2S6uTDvHgt5oHgp0ZjoSZ8zNie+ohOHzxLOAjCmaoub3v
	gk4UpecI7WMEm3BUe1+hM7+tN4kxXm0=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34aa1d06456so27096921a91.0
        for <linux-mm@kvack.org>; Thu, 01 Jan 2026 14:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767308158; x=1767912958; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I1gS6epj+hr0rH6I+yAY+Pf5DGDN/1lY3+3hmzSOP0E=;
        b=LvE3nsof3Wgd4MsPvoO9LOLSTkeDQQTTF9HjMT/x7wV4uW1Btm36y9sYirjtTgn9i9
         zK65qXy7hxhI0IMlIlmbznsDC+zSfE/vIX171MGGMBfIwDWqMI3vPu8so6E/kUKP559N
         TfXSKQHWBk8prAcGrVZyKaQQK1mNBsp98j8XWmJZccDxz6Cs6NfOWNnFPkDDqyk6x5+I
         X5fRzzOjbAk+wqS6YBYZPTiCQFkTE6EQoEZcggyd4KTtwdlG2fg8ZpamkEuyDgkDFjO4
         FzizXXqW0y8X/4xF2t/gYRPYN7QAMK30atcQLqJPojuIWHOZ2u4rb3/xL0M7NUtdNdz6
         Dnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767308158; x=1767912958;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I1gS6epj+hr0rH6I+yAY+Pf5DGDN/1lY3+3hmzSOP0E=;
        b=I/Y3RF+QBJ+iWOvOOTMtIO0hvVZLMIqjodNnmn6NBYgAHSifq6hj+hWOICdzqtGGVH
         +CEg9f2Hsv4VZXld9+Aypdxp2yYY9tKiLiJ4ki2CDY/7JvFiJLR1rSyhr1ZRrTSNmKas
         ud89q8Y+A8a8q4kyKOU3O/O5sluDz9trFwcaGsXYvxitdi3jGoxhRSmtGa+x2x62fDVx
         LBmEl//Xs3Zm7y3lp5L4DhBR7pWoKvLRi+Gp2upiCycLFMQGhwuDSTdFtnTwjQL4yXzV
         Prj5JcJTV5OFJvIj7Ui4wVPp9Qs82bIIAbScI5P+N0csrLqujLIISG4O7tcddukQxMEd
         sUAg==
X-Gm-Message-State: AOJu0YwIhXP0qmjxVx8RRx6Zue8vxCVfAHw5JXdq5npfK1QRQn+FO3Yp
	rB3ZCBSiALGvDJC/4Ezd2FQgN80Wq3vN0BrUeqHXSR57vEESiQNfi/+LmpMlCHOJqicwk1M1CtZ
	1E7yqQDOsLw==
X-Google-Smtp-Source: AGHT+IEeangDUpkOYswA7LbzE5LNqy02vZOyzua3r0aNxLNhZI7tu3Luqfknf3iF/ilWE28iADIZZhI8lTje
X-Received: from dlyy26.prod.google.com ([2002:a05:7022:69a:b0:11d:ccc4:4c98])
 (user=gthelen job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:6984:b0:11d:fb4c:db13
 with SMTP id a92af1059eb24-121722b7f18mr39930665c88.14.1767308157999; Thu, 01
 Jan 2026 14:55:57 -0800 (PST)
Date: Thu,  1 Jan 2026 14:55:51 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.358.g0dd7633a29-goog
Message-ID: <20260101225552.3423108-1-gthelen@google.com>
Subject: [PATCH] memcg-v1: remove folio_memcg_lock() doc reference
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 54F00120008
X-Stat-Signature: kdkyhu9fkgp5iizqeq7wuqd57t3rah55
X-HE-Tag: 1767308159-857972
X-HE-Meta: U2FsdGVkX1/d0YZ+EwkwmaJO+PYXablkZKjV3t0cr5C6gU3hCGccKISuVu8yB8dASmkjWJqzj1OrMYX7El2ZbvbwcoitAkKuHuiOH4rKrerYrFBXRc7EcuSQVZscjw1tv4j2ZFOayZCsDCT+5ZwnhsrdZvedYZQO8HU+o+oKeG0PQBIfbmPeX74tYTi4f5LsRIMInpY6UuQQIlIitOt7AyGxleUVegn80Kcq/rnpeh+T6Opehk6KP7OxPc3J2Sc7yydo/VK75L2GGuj0BehpRf+nrhM5G5nXM6PvSCWyE5G3C8CjHVsvj8oJ2eRWt/QAPMCMxHB/wQULXmosKgjoiaprd3mAEwEqqel7IjzrGOZIhRb5MUSpq3ow+b5s1jqST7T0H1PruzoITF2BlMW8OlvPVcv45B3SxqzsgZOu4xkitEl2ojK9ivb8smzInbSJB36BOhRljuLMiB0FlM7VXKnNQTtW5YG57fNt6jTgwDpa/tXNpYJDeOyJvJpscNx3lbE4d8jtrRylwKs2Ro12QgHQNAZbDen+xzhdbabPS71pK1mtP5ec/Yx/F6NH5lX0Io1uEr7UYthCqS5kmS4oPRfualCNpUH6rahzm+/SJPcR3T7OTeD4pmjKi+X1jQjeh4OqCAVqJpTbALtiaMqgXIGZQH4K07ejNM7HtoZozBter5M3EKqbufo6ulDFn/W7FIbeopZazZk68qXrGMT/N2X0yc0vPuXM6QlyEaXC+Jazg8Jvi+0jeaoepVj2+jlVy9nf/flh9wQ/JzLapXX+w37i8j25uneAKlWvH+ugZUY3SxU7DNCtt2PGb6ty6ybwxrERoZJ41qCblIGsPi1RHYMDTLn5l1S1O+QuLLI8Gk6/Qi3t5E6q0gnbaYj4Tt1C/MZzsJqS6W8Gqe10xMRUt/DcNJKFsAlfFwuI6WQGnrNIWPJkSYmSFzq77N/nY+1WHfV5Qxv8/hx0SmMEdcG
 zZoyMlZh
 9TOS75d9//7kL4YZ8wT6x8tqK4T+vcPXgFX9ZbjjXopa8RcVRCFhYWvUIW1DbWGZpZZwFHDS4EjXpnvyhQX8ugqh8HTDCxz89tmsIADqs8yNcUz7bXe//L+qzs4HUPomACc80UWYRrrM2pGVko6PO691qK8nOxclBpcb0bWhyGx6KCsK02UoN+nsCIJdWExLqNFBcqIBK+SZcZa1IYttvt2UxacOXcTfANHKRxtZVBlrXczdWhAcyTrUWFSYQJNX4kTOaY5m/J2kXLMEJ4TnVio0GA4G7zP33emDLfTtYSFxU4S4wuQKBxdtXK7B34QBnKpy29yycLZziJwCOZvD8lsBFCjyiNSp3FueVdZiw8ElD3k40gCZypgf3Jxr53vUdPWSQkjCO6AikRsRgb5otqOXttnC7x3TXQY0bonyPvqLm3+EkPtiiio/8qOB1GjQ8zsKfOQugRnDIuLdvSm+NeScqm9MAellvFaTWWT77AQZUUxIJgLxU87MBTbqX/uUggwK1WPL0+SXAfdh4/S2ru8zoyji3Px52KouM4ZRF3q/891miMdKDLcxlZFcXbKSKyDt5co+trpwZV8MPX076BO6vTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a29c0e4b2e86 ("memcg-v1: remove memcg move locking code") removed
folio_memcg_lock(). Delete the final lingering documentation reference.

Fixes: a29c0e4b2e86 ("memcg-v1: remove memcg move locking code")
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index d6b1db8cc7eb..7db63c002922 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -311,9 +311,8 @@ Lock order is as follows::
 
   folio_lock
     mm->page_table_lock or split pte_lock
-      folio_memcg_lock (memcg->move_lock)
-        mapping->i_pages lock
-          lruvec->lru_lock.
+      mapping->i_pages lock
+        lruvec->lru_lock.
 
 Per-node-per-memcgroup LRU (cgroup's private LRU) is guarded by
 lruvec->lru_lock; the folio LRU flag is cleared before
-- 
2.52.0.358.g0dd7633a29-goog


