Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05EA5606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ksKXrU4E
Received: by kanga.kvack.org (Postfix)
	id 109336B0703; Tue, 27 Oct 2026 12:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E17A6B0708; Tue, 27 Oct 2026 12:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39776B070A; Tue, 27 Oct 2026 12:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D02A86B0703
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:04:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CEB2C0976
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:04:17 +0000 (UTC)
X-FDA: 85368878154.16.FC6CB23
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 633BB1A0014
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:04:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ksKXrU4E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5d5oBiDNym+XgxzH0b6C3qDhntNhLNghMGNMGMVJJaQ=;
	b=T7gFtCFeKNBaaDOSB8zvNhw5P/d0CiIm4y83FCoTQOYmEgHwz7XKYKSzkQzVr/kTjfuuAv
	Frq+FBlyrlG9ZjNsuyMY33bPbqxygJwGZi5k0MzefL7HO2VD27YyX5uB2Fm/kyS550C5Ux
	yX0fSXYrM/Vfl+KDQOzpBEJ9MrlByMk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ksKXrU4E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117055;
	b=ulfH4MTgkkOz/PJ3nsaYxLlFaPQL1ZuTsVstkKwGaXs8QoRFxEBKDuLccp27C1+sYOTh2E
	02hoFVlSP9wTGtXnd+L9mMiBF+gyH2hIjLSWUXsKa4fNbt9gVuJ1sjK7cfSjFZE2w5sULD
	xzfLqDCGm7Py/ENqoqrppFGO5KzJejM=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso54530a12.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117054; x=1793721854; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5d5oBiDNym+XgxzH0b6C3qDhntNhLNghMGNMGMVJJaQ=;
        b=ksKXrU4Envy3rW1qwrVPKUmadMGAanlRE8P/cPbfj9xSzPhWqTTCASB5iBpBVt+rJL
         TbiNU/cxUU6ockDVClu6U2h+8vBwkghdKNxuaVC+yu04niFc7aO4MRAilKVAnZ5llodE
         Yfl7xtFyuZBXWpZLqms54A3dYNMgmn5lyCSd1CKDfYeuwgCM7Jzbs48NZ6VtzZFxTFrL
         dX3btHO8f9Ns2thjvsfRsKfeybv3LiD+3OuEhKFOtkU66KRiQdXr3BHhCHbQSQtLHoSr
         OJp5fK2JeaumnOPjLhH2+0ykEo585+zHyd0UBL4HNc/fMCJvWmBprt6wxQ44ltlBIrjn
         2FqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117054; x=1793721854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5d5oBiDNym+XgxzH0b6C3qDhntNhLNghMGNMGMVJJaQ=;
        b=MsEy5fLVnsDJm8epLbmXnEj5WpTNn7HC7GDN57gi1vZVItbG8B9IKQXaJX6t4dnw9V
         D/M+NCdvpZVhsT6nbXPp2mge/6z/zYIyN8bof4EyDB7I23pJcO8Iz55R3/l0aVG8k0U9
         fKJ2zH4jc7pxrMrcMDM4FghVfcg0HFbZOV4A2EJeF18lBQacwKH8mWIdGBx1G23r/U0z
         CeZndWCTi8IMYeJwGu6EEnYSc3Rw7yp6xQUdYg18VX5MFjNIjFe2FX4mo0EiLF/MZT78
         h6KdOWQrVq+2z3UHEsUSygpp7Ye86g5vbbMXEoEf8hFsqERoM7wn43Emm5bZ8ZNZVzf4
         TpMw==
X-Gm-Message-State: AFq9FYK5o9kNb6lGVpNEJPV7yvy06ZBLi5QAhjxq9/TqE/eMoBYFCIf4
	bSlS42i94xhK8OQs9dh9gZg7ituYpGZ9nXtkKKQ/cR80LAeSkhf8fAz2o/6WTw==
X-Gm-Gg: AYBFou0r6Bb6gpdGPtgl4UV+2pQ5mG39+NkPhhhK4mxgkLJO7ItFUhdlRtPStoNMiLJ
	FEU/mHEcoQLGWO//lb6wO6CDjC8K6zYnnvg9W1bkSr5AtgCar6KRPwJzvR3YJICPr2nDGnLrfbi
	0XG42h1V04EnabtWc0q8b0q4DNYDFdJVPt0BStL7g994Wt8LkjybhTkcBcOOLIzFSKEo4M3eBUH
	MugUjysTxdx52W6UK6TVHwh2EQ+to7stjWi6cFAy8s3uGfvZdEmz0sRse8/X8hn57YBtg4E/Pl3
	XeYiQ2Fl4fE/tYlf4Tm8jspYHo8LWKOHiL7cy57kNHQsv9Tet4zNGpdoOdr86hQKWVHMvVAII0E
	JISMNMV5zCd4L5SPvEgUBBuWCiLiWvaVe6fYNe5PAqBwboyf0Rib2FPhQeSkosENtKjZLklhxnC
	U02tzNXOEGkTobXOyM8QQ5PHOo2SOKg+jpzlDXAank9ehUeb9WmSEMjrfN/uOUZpsP+GH+yk3at
	qG+A8hsNSdfSpJANdhkwWqvznDFuW/IcO/jIPGD1vBbprcjbZAkPUyIrYjfg4FFe23FIzaw0gh3
	FLc6L6IgEUGmhQK/5qM=
X-Received: by 2002:a17:90b:4cd1:b0:3a8:1943:cb7a with SMTP id 98e67ed59e1d1-3adead44808mr7894909a91.18.1793117053971;
        Tue, 27 Oct 2026 09:04:13 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebb1e37esm8365129a91.4.2026.10.27.09.04.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:04:13 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 02/18] mm/swap: slightly cleanup the code for hibernation error handling
Date: Wed, 28 Oct 2026 00:03:47 +0800
Message-ID: <098f63eaf6b12c7340d39cbfbff22678cdfbcb92.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 633BB1A0014
X-Stat-Signature: xfaxan83mxwcpzgptx77jefst8da378j
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793117055-548617
X-HE-Meta: U2FsdGVkX18UtoTwrrvI/L/QB1jlpnhy+XfS/DYjOjx14heyUu5pvsG6NZBV7WXYVBBlKFx2k1p/UYAknd9e1aKInY/LQyNNjdf1YkjgrdtHjEGe7Rzzb596LBetrsSWq4ynhK3r4m5Ykd+VK6zJDZvPIJ5scA0yMrfKIrtz6Icg+MeR+sP3TIACbITHIJiByzFBMcd64Beklrgea4kVlQt857vMdT8vFXJokibe9VkFBcjQF2SimJWbpgC4sReftIPOeiyofaLux1aJaAobU6A2vEJ4Ik7zoQKL4VI16DsmUvJDgdPM4vtS3QTRkQXz88ipm61D6DXSAzpwwD9S5IzXRS1Eo0tk8gmArZI/MRSkPFWg835Aup524FF31h99qaKXUOHI6MF1FUDy3CBofp0SHTBNFteajC1JfKwmu79c4nqBXapwXWC5snshEjzQpcfab2h+8XABFKRcCPT64MN1mtfzI7UmDArnK2495s+PC1vXTsQxdXGZ6akYDUv8KqiTC9FK8Nd90E921dBgjAdVflzN1F2OLen6+JyI1ZN+X3tiU4OMDyKBNhh6gZM+J/egzp+yOeSbiYfeudILits+1seEFUB/qrLGvWlYTG9uLn1TKKTMHbEb5u74UzThh1AqZuk9nF+GDM6Utjtyc8Z4uOMN6qyT1BP0SctvQk7873Sq9FWnuiLJmlzzgiaUKtiXj69ih3nxGMwd3qJDsq39aI9VblqpXS3p9/Tps9X5b2HS4MeUZQhjxSzxRDKbkgqPkRFNEKkX6jqs6BFk3HMooKuDju8qWOyxnZs/rSpb6m7+Sq1UqnxpXxix2yveYZvUwbBAmTexD9Zne/YIhnockYjZCiDg3KPU+InczgdBmoHIi85q9gZSdr86Q9VR/EbBRiITqpqkDeW18xwUf0hV8ljLmOVLAy6Mrt28arYfaw28OMjMAcpkyVWAJBIx+czVNDEYISDzXM9fwfJ
 bR4phOXa
 w5fjjOAI8XYrcMalUU6A0tbqDV1D1UanxpYXQTACUAxb4S+W5vxxEa0zFYIHJxYCT81ZuhhBpaU23yV9USnQqKDXbREt6+AqFbAor6WQIQ/kPx+QLgVHDWJ6zMLw+erN2UY43fLqDYjrZ38HXYGv9RQmsjUTs6i4HzY/SP1dkDsxmR+nakYiwBZXp6xZ6tQ65oYJD0aKt5FMw8lDQ0sXJsIVvaRTMrIO/1blGgV2IlOMfB1HfvgESKyk0DwjuevAgvDQlnuIWV4u1OY7K0KEkAvXzovCvtW+yZE0g9ML7UWc6EkT/uLW8bjsEZED/uShv+eFkeRQIaFApMr8PeD2n2otIB3lHPS4FoJHL/xZiIV0+Ux1PU84PNhZMZjwxyEj3keCk/LQJQOcuaXLW+DS/f2mB5g3YRstK89NvQV6hBU3kJ51qz4LB4FcWF7LAwsAwWwSbNA9n5lpSnY1Ou3X28xId2AdWombmD4gnK4gNv/ukuOloMp6eBbk1v9WJSgnpZ0qtWzQkfUyVNh7U4fc9otFDqIdd8q4DCjhpAvuoQJzSmto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Restructure the error paths in pin_hibernation_swap_type() using a
goto out pattern to avoid repeated spin_unlock() calls and simplify
the return flow.  Also simplify unpin_hibernation_swap_type() by
making the si NULL check inline, and clean up find_first_swap() to
avoid an early return inside the loop.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7acb33cd8b71..cf8c0999655c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2279,21 +2279,18 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
  */
 int pin_hibernation_swap_type(dev_t device, sector_t offset)
 {
-	int type;
+	int ret;
 	struct swap_info_struct *si;
 
 	spin_lock(&swap_lock);
+	ret = __find_hibernation_swap_type(device, offset);
+	if (ret < 0)
+		goto out;
 
-	type = __find_hibernation_swap_type(device, offset);
-	if (type < 0) {
-		spin_unlock(&swap_lock);
-		return type;
-	}
-
-	si = swap_type_to_info(type);
+	si = swap_type_to_info(ret);
 	if (WARN_ON_ONCE(!si)) {
-		spin_unlock(&swap_lock);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	/*
@@ -2302,14 +2299,15 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	 * the same session.
 	 */
 	if (WARN_ON_ONCE(si->flags & SWP_HIBERNATION)) {
-		spin_unlock(&swap_lock);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	si->flags |= SWP_HIBERNATION;
 
+out:
 	spin_unlock(&swap_lock);
-	return type;
+	return ret;
 }
 
 /**
@@ -2389,11 +2387,8 @@ void unpin_hibernation_swap_type(int type)
 
 	spin_lock(&swap_lock);
 	si = swap_type_to_info(type);
-	if (!si) {
-		spin_unlock(&swap_lock);
-		return;
-	}
-	si->flags &= ~SWP_HIBERNATION;
+	if (si)
+		si->flags &= ~SWP_HIBERNATION;
 	spin_unlock(&swap_lock);
 }
 
@@ -2428,7 +2423,7 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 
 int find_first_swap(dev_t *device)
 {
-	int type;
+	int type, ret = -ENODEV;
 
 	spin_lock(&swap_lock);
 	for (type = 0; type < nr_swapfiles; type++) {
@@ -2437,11 +2432,11 @@ int find_first_swap(dev_t *device)
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
 		*device = sis->bdev->bd_dev;
-		spin_unlock(&swap_lock);
-		return type;
+		ret = type;
+		break;
 	}
 	spin_unlock(&swap_lock);
-	return -ENODEV;
+	return ret;
 }
 
 /*

