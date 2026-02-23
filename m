Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B9EE98DEF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8AB16B0089; Mon, 23 Feb 2026 02:25:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0AD56B008A; Mon, 23 Feb 2026 02:25:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B7E6B008C; Mon, 23 Feb 2026 02:25:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 83B476B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:25:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38A2513BC0A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:25:37 +0000 (UTC)
X-FDA: 84474886314.07.9147EA8
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6DABA2000A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:25:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="l/fheoFb";
	spf=pass (imf13.hostedemail.com: domain of 37QCcaQsKCLISUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=37QCcaQsKCLISUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771831534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hidpuNttSwZHxHCys+Rdwk1AShkIe4ps5Ps0hErcBKQ=;
	b=DsS2nNF89yKV1vuMjFWhV/rOErUHdqXqoBEAmL7tkv7LCeFvYuktno88xxKaxbYphDdB3U
	6Dmos3Tks/5hnxWKjU0LlNTo5a+/4SKv7+4ghb/cst6QJrNTbmuJQ0qz4lkvHeMiMUONnb
	lX94/NUgxCvowaJany39Kb92gS0Dg40=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="l/fheoFb";
	spf=pass (imf13.hostedemail.com: domain of 37QCcaQsKCLISUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=37QCcaQsKCLISUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771831534; a=rsa-sha256;
	cv=none;
	b=BteSd2gqvd+qzqDiqVHE9FQW4Y5dtj7fFZzx4ho6+Tg21iTGofJCXy6kod3zDj2cb7BZxE
	lIMxS316ovySYNhR5ACVP8hnv7c+gook4T/URozwnf/fShWkQJIH1lwRwvsHw/xD1iaT/g
	MVljeR2w7PVlrSf1OWqqM31PtJpPcSE=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c44bf176so4031617a91.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771831533; x=1772436333; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hidpuNttSwZHxHCys+Rdwk1AShkIe4ps5Ps0hErcBKQ=;
        b=l/fheoFbYEMRzwhxgKZK2062Xfvks+B0AMvNb8tbkwDV7fDRFh24+qwLVNevZykdSG
         D7FwZdyI4ldeu/uoUpPM8SGKvevwKFOSdTlFtPJpg2fLurwRtew4hf95bP4JhhuoA0VT
         CAGa08c0k5Cz/1vJ/lhocqjn7Bz1kUNSVvHrkUhZW7PVwofAbEQL/h9AoBu7GqApkZnY
         0w6u0jNCNYu/jcYpvqWBraRrBHC/fK6+toZjVkgNb/VOPf8mJxQjyUnVwSSgJFYbXowD
         KcoRDY7Ury3x8KpgUc5XA3sBJVMi3QhDadB/LaNa5yAjlbJzgWAt7Dc7y6C4U9a/exG3
         jW9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771831533; x=1772436333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hidpuNttSwZHxHCys+Rdwk1AShkIe4ps5Ps0hErcBKQ=;
        b=bQCXfFQGE1YKD7II5tw3q2EQ6VTLV0YwKVR9NGV1oiAwz3PEgMtgudXcjFNPI3dH/s
         umE8Gj4D4Sg8sPUTdN7hGx4isD5JxMkM6KIGOghPU6s8RAzNkNR7h5QMap8HxJlNbsqs
         7f2Mw4smiuopxQGu1WW2iol/Zne9mQEGDOv55DI33U4m/ciYvxupf3FMKK6O63ohS0Ue
         nw1Z+vloXQ3xMAJgE/adQ5AUPHILTCP7pIIUXgIixFKFGcfU0czYA309vLTpZCXuI+oe
         2G6l/gWI576Bn5MGwquLpxUC8ZO5oTbUuzScCyK7MiJhj86l+1FX7B+4OsKliS3CNcn6
         HH8g==
X-Forwarded-Encrypted: i=1; AJvYcCVm7D0gs5fRfieXrBZup4pRzqnJGnCmytvW2gmeF9sK6kR0yUK3ryipaO2XlzGB33fUEkemYUF9Pw==@kvack.org
X-Gm-Message-State: AOJu0YzN0IV2+VM+nu0Ag0ETPswgnhUvj/JbXYWEupCY9EMNOP0GCWz/
	mPRFqQhQxGSIHqsBfKyKPsTGVGPqp0aKrHv5hD1MHeed4e5L45vBJYlSUy8a0nvnmHU/tsCiQ+B
	0IMLUdZ3tg8KRPK52sj7xUmgXXA==
X-Received: from pjbjs16.prod.google.com ([2002:a17:90b:1490:b0:32e:ca6a:7ca9])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c43:b0:340:bfcd:6af8 with SMTP id 98e67ed59e1d1-358ae7be0b3mr6177609a91.4.1771831533175;
 Sun, 22 Feb 2026 23:25:33 -0800 (PST)
Date: Mon, 23 Feb 2026 07:25:27 +0000
In-Reply-To: <cover.1771831180.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771831180.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <3d698e6fcf052628629d9bd928fcef5fea049a76.1771831180.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 RESEND 1/2] XArray tests: Fix check_split tests to
 store correctly
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@kernel.org, michael.roth@amd.com, dev.jain@arm.com, 
	vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DABA2000A
X-Rspamd-Server: rspam02
X-Stat-Signature: ukdgbuaon1ob8qt5m6y38ew6xsozfowt
X-HE-Tag: 1771831534-19445
X-HE-Meta: U2FsdGVkX1+msmtTSPAY500nb8PZKovXKAI5QU7QvLxRkhmwZI7nJf/bpH9AIW2q4/MmxV+auEAQmlpSjHQzIoR8jveB6xsJ62MXf7RX95DmZo5XGUYkFvr4oYE7ceplO/FJhzWmUVyV8ckvxSl3cgW+qdGqD6hC7pzPsIYvIv+Z3bZdE983krhcSxaBR9VHJEfj4+hWzAyUcsTk57j08DHKOgoVpqgxcrV6W0GqevzXMx2z8ZCP6x7lDSI2i+nqBW3HJGOnTMZoSSSaX+6MzrIdVXD3xHvcMAgh95oGLEm9PgeYLnFHNsz+JdUj222QV60egmIn5uUf25CorxekXWeRtDJwHmawWv6509ySCbEHjWC5sy3QPrjZFAqw+9SL9W/WElDc2lz0ParGbwzBnLyAP/QjyT0FGTHlbWkCY+3hIi16fnqc1xykO+iLZVP4uOg3s8u/z1mkUV0z5hx0+Weg2oLHuCw46/PRzDm/LwBSDzdItd4TUD5RcSDazKlDh7bcn1fMYLZto/fVt8PjsFJ0bwr22VSGYOT67JE/m5ghH2kVl6KWvgte89kZn/Ubiwv65vwuKeVOdit4u+PzNClgNjRNj4Hap723M3JU8brMCIrU2kc2gUwaIt7co1Zum7YJzmYY7wsMLccjp87iFR4UFoJ8CHZdW6xj94Pt7QIH87hi+wl+KMrl9O//O2qtr356f9JvgXuT0ZCR8tkFayTeEeAfIDCx2XK6LAUhUKLPYRUNXxaCuFYHWwk+5MNPRAIDxsSPEe/aBoEZkYYy2LNYk9DdRotec0jOEi8r3N3XKQHJHuKp1TZ1MnBAWrtAT2b3sQuM2JtAIz9BVJ/QMVolYVTLkZFi3Cr1xt/nSYS/IG8MUC320Tz50t0bFS+y6Iubz9ozrEvRNM78fZYtLdBKFCFRWKReHdoHTmwlqXVlzvJJkLAPHS2b5YCYG1XmQhghl5/GkkpUvnWM/YY
 e+euz2/7
 2rLfA+exuW9u6BHa01OReEAWCjPFGtDJn54VvCy8/2L28P6WBVki1r2KgPpp7YFZj+ThhDJtD97lQFzL4H+Pk37qA98saIEGNXvsFHgufB/0DaXTZXOp6qipgOGEqleAxKNIfN3Liyy+z3mWSr7mBJDWoOxAF8c7EcOqD+hGUW9DB4zlzugwYo3iphVKO9Sd9exOa9y8p2r9YRT4Alcl2mN9Q+Tf9uveUw/OsFWkRm3p7iCsANcptIP6cJnu9/lYuUbM0/3wIRIcRpuYgOR8/M+A+PDsm2FNu8c9qflJ260lvP8L6mgQSvHiehUc6s7biAir9+EXxExK5YJuvaz2IsV7MviAgRZRaK6PAXgFH5t/zEt8ylGM8wdZXeswPisty0D4C/Ai6XcTjBgn09S5zTrgytxYUDbqGq3VGNgDH9jXXL800r6nx+qmK6lL5eCx3yOSLmZQ5drYEcknZsGasLx+M0l3fUqiNFo28UviHyWiiuZUrKkJckFFEQEc08NqOEmwC0KuPJFSJjWProQkhk4sSdYF+QGkMt/G4vrWwwYHx7oPzXnmnaXS53jVlCs7nC1xSHiSaYkOP2RssnPBUQSkaPiIPUtutEOY4zEZKelRNyI8ERwFlB90NIp0zgzEwXtky2S5olSxi/VDN+H1jSjqlqIaAVkjSJ4H5IDk/xUk3sLU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__xa_store() does not set up xas->xa_sibs, and when it calls xas_store(),
xas_store() stops prematurely and does not update node->nr_values to count
all values and siblings. Hence, when working with multi-index XArrays,
__xa_store() cannot be used.

Fix tests by calling xas_store() directly with xas->xa_sibs correctly set
up.

Change-Id: I144b96b8724c27ac4a6d53be1e74125bf8d3aebe
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 lib/test_xarray.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 5ca0aefee9aa5..e71e8ff76900b 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1846,8 +1846,14 @@ static void check_split_1(struct xarray *xa, unsigned long index,
 	xas_split_alloc(&xas, xa, order, GFP_KERNEL);
 	xas_lock(&xas);
 	xas_split(&xas, xa, order);
-	for (i = 0; i < (1 << order); i += (1 << new_order))
-		__xa_store(xa, index + i, xa_mk_index(index + i), 0);
+	for (i = 0; i < (1 << order); i += (1 << new_order)) {
+		xas_set_order(&xas, index + i, new_order);
+		/*
+		 * Don't worry about -ENOMEM, xas_split_alloc() and
+		 * xas_split() ensures that all nodes are allocated.
+		 */
+		xas_store(&xas, xa_mk_index(index + i));
+	}
 	xas_unlock(&xas);
 
 	for (i = 0; i < (1 << order); i++) {
@@ -1893,8 +1899,14 @@ static void check_split_2(struct xarray *xa, unsigned long index,
 		xas_unlock(&xas);
 		goto out;
 	}
-	for (i = 0; i < (1 << order); i += (1 << new_order))
-		__xa_store(xa, index + i, xa_mk_index(index + i), 0);
+	for (i = 0; i < (1 << order); i += (1 << new_order)) {
+		xas_set_order(&xas, index + i, new_order);
+		/*
+		 * Don't worry about -ENOMEM, xas_split_alloc() and
+		 * xas_split() ensures that all nodes are allocated.
+		 */
+		xas_store(&xas, xa_mk_index(index + i));
+	}
 	xas_unlock(&xas);
 
 	for (i = 0; i < (1 << order); i++) {
-- 
2.53.0.345.g96ddfc5eaa-goog


