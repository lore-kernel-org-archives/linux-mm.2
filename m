Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D069F45A11
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2296B0093; Fri, 10 Apr 2026 17:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04BD86B0095; Fri, 10 Apr 2026 17:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E516B0096; Fri, 10 Apr 2026 17:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6D276B0093
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:36:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91A28160217
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:26 +0000 (UTC)
X-FDA: 84643955172.15.4F62BAB
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id A21481A0003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mgkfxZ75;
	spf=pass (imf19.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mgkfxZ75;
	spf=pass (imf19.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775856984; a=rsa-sha256;
	cv=none;
	b=8iq2mal9qreTikUxsnjC28z3f+2powVx33HCFtUp66Qiw6WTqDg7+bllGLvbPRywwk0L+9
	9seAVATgWKJd9JoE0WqPQAy7LRk5fsWCos2oO/zcS217UWkHN50VsJ2DObAOC8OVNt91Z2
	74OeRTMBDDcy5PMI6+yac3BiAFIj7ds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775856984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+v45jw94JRi1dGGjjK8/w5xNCSncG1F0hGpE1jyeuw=;
	b=pLRZzmUzwdc9q4axRlXdd/5CdU+iSaydrftRzqfkr0w+sxyQnj+WxT0bGG0LNZ99fGT3Gw
	k5nrzDcBsluJoqkfeYuY503dQRw5WNnLFi1WTpF35YCewyq8WgE2iWJRh67sUMb7HXGOTA
	mcSMvAn5g+QWGHtgHKrdVOYSd9rVxw4=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82f07e5ad92so1003218b3a.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775856983; x=1776461783; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F+v45jw94JRi1dGGjjK8/w5xNCSncG1F0hGpE1jyeuw=;
        b=mgkfxZ75BfcI6ftByz+G4AFaA0fh+7+6/cxf6FG+qUMmjKXUI46I3Xk+sHveHq1ihC
         LVsrtiw/6fkBl+81srRU6aLhNx/8l8LoC14NU94/bk57n8X9vU2S2vTOD+ea6UJSz3vf
         61Nf8sxvBqoJT/ZNI0+jAA3Wnuj1FBnAUK5UxneA6dcLVGe4IWyjbVBG60ovLw5GgbQk
         4Z0WjdDWlLYOdc56B6CLuehRar2J1TtL5upiBAtYv6B2Ew8YP8WhBP41Nyw/UG3Ns6jJ
         jsQvC0ZbkOf18Oc3rRFITFhGrhXyL5SSn6d9vhpM+iXCIa6UljbxYcv/o73Hrjwp4eU+
         gjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775856983; x=1776461783;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=F+v45jw94JRi1dGGjjK8/w5xNCSncG1F0hGpE1jyeuw=;
        b=enAFOO0Kq3AIWZlh9oBMx/fogYvup1G+Ql2QYG1zORLFl6clYSi/DoNMZBgP4wy7El
         9kxkgIDY6bnpbgQmBoSPYsl7mG7+CyY8N+somRqOZp7mLOLPCG4FCRNx73sfQVTqDWoP
         K9DwHG35OU2jkv5nyLnajoanxQ7ZVW8xrdUURbNcDhVx4zTRXwtwQQuQweizMkqvQv79
         f7/EPgb8qGV9qVCRSJlK1hSDWgY6BO5byP5ccUplBOW2c/0LBKvIKXuDZJjSOL73X2/E
         u7huPtHngOkar469jCl66t4pfsT6cqs9baAUDHKAzFmrFKcG8D1SY9Q+GPXhMqtzzos3
         EMjQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/IQQ+X+PLS53eQuwvfvHafx8EInpX3YRgasOe44dQ34TOK0XghDtbxTyQpvvzIr5pzxQ49M0dew==@kvack.org
X-Gm-Message-State: AOJu0Yw1GzFt0kWdlWaIE45YvNWY9qqrnkr5+2McGBJWzNLPtXlEk9yq
	r7aQ/RL7QpvrMPfLqn8wHyscBrWo5L2Wie62bv9RzhNwt3lGeo2EPK9P
X-Gm-Gg: AeBDieuoHf1wrEvhT2D7qDDnRekhk0Q2PANNiXSn4H4/t5ewTLjlicG0DDLUZm9gxrx
	gWj5v+YfnGDCABShsgMZ78D01y9ZsooQXxkIwIE7+Opfld7s8oh7pDkmHomLgGNx82zFRxQcjbO
	jjSHHFvsbuDXNMBJboxvVD39v6BhbDjgFraJUYWqQ6anGZrlnnftfHPXpjocHpoEN80N4diYrHY
	wadDjoPgeuQGHJBmj3aaGnwT6eyQ3ZPau8xyTmdYpGWg0vZ05lE+Sr6Vs/iGobC8yHTlk0FHrnL
	wn08F3ECnEYsmLnkdmD4x7U1/Kxhvvsf6zvGEPm0mHJyJTJRzkUSm81XhOZPm1AqO/HH3YFNZQB
	dIjtmr3afttIPzPzdjqIQfjjlnhV486ulqSo1I+dPFdiJWOtHV7TqLcxIKWWXjnCy+wDKxXfO2X
	kCbV/uE/+WkD4v3a9ZpRU/7VcVkwsHxeORgP7T6m+t0mtS
X-Received: by 2002:a05:6a00:2d1c:b0:82c:9897:70e0 with SMTP id d2e1a72fcca58-82f0c37f54bmr5055454b3a.47.1775856983472;
        Fri, 10 Apr 2026 14:36:23 -0700 (PDT)
Received: from mitchelllevy.localdomain ([131.107.1.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4e3d41sm5111551b3a.48.2026.04.10.14.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:36:22 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Fri, 10 Apr 2026 14:35:33 -0700
Subject: [PATCH v5 3/8] rust: percpu: Add C bindings for per-CPU variable
 API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-rust-percpu-v5-3-4292380d7a41@gmail.com>
References: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
In-Reply-To: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Boqun Feng <boqun@kernel.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775856978; l=1610;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=LiqeN21hmlSzqeftoSl/GLCyPQV5RGEp+g7qmLBlTQE=;
 b=iUFnR3cUvYb+VI/DXA9Z3DypclDwajbL3MjM2j/sG8C8YCvKAUERXgFjlgI8fe1xS0FPR8yPj
 FaOyoJZfdzvBlVouoUriBmn4xf9cq/lvTRJ74Z9sbo/4C+GjPyslY/f
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A21481A0003
X-Stat-Signature: 455hya9zt8haa3i9icub1fjkhjt54u1p
X-Rspam-User: 
X-HE-Tag: 1775856984-840024
X-HE-Meta: U2FsdGVkX19OAwdCRRo1il0qHqmf8e6O7Q7CddkxNODmfCJfQ51UNDdfH0/DWMmu8oXeK1y1Cd+ETe27/aAqDW1lFNch1PdtRVTM1e+st+cPM2itDvh+y19WVP/sex7gyUVtwbSA7KwEqgkqy1dd4Lv16F0j/4UttsA+w2To8Y2K/+P+Brzxb77fuRBrN/jFPbAfimdt/4mi5cK4+LDvCgCRx4WnKfz+hBbTozXpmxalrHQl0OumQn3PbGgXVIvzG+2UD8H/fnxvBqvvu5Y3GHic7rp3o1MMJU74Fwfaj4+XldA0VaQTKOnHy6JbDKkuMNy81+rVDg2+Iprt7e3MrmoDqkQnk3cf7d27sh+2mu82ZqSVyGyAkmXTgIxpsbjvGIiDKNRUAUdaL56Nge55B94uMzyiD+zjLBlByq9im1zf7Ju13RkgQXepx/QoH7l/x5/sC8wvjxNNkV4jCrkmQUoePPaTpnMWjgdZqYxdGQk6vOaL0TbSCFZcrmnzkcEJ2WGjDzQ0JCYfzFJKxhMQXZi+6No3SSruy4KLlG8gWU7Zsk+oyDax3v96/Z+/OW+1hSO7x/N+ktHXPlervJTk5hOiVRaMqkdkzctEbTpd/Z1b1SQSqfhkQxAleXCW+r9gMSp9yfIVncVD3udaP+sdq//7LeOdhliXFyenA8eKXJP0ABX8xrcPKzyHDCx3Zldf1YiMZMuYuP3WXaVuAwSIpTon3VWG/2ISVZmFqETF62de+cN5GNGlrrWf62IBNwYvR7jTG6s7WyZ3RXp9GBJCmPThsATlJBmcPp4+NnIxS8REizNBQECsLx0o4TEcJfJ9t+ShT4gzA5f8vSl1KFej9xWacaHuCSxGERVF+XVS7ZgFrrTOWz4d739YxmzrQYZX/F4CHtR4sLepRD9kmcZkwmgV9Psy+z/WoeAoct3PLJwhuI9ibAHd7PHf2Dgr/yjdwjgJbhI4dGmDJ1DKyrO
 0yT3SN+l
 xGpOO3Mh08EjOSqowsdN+Lu/OLE1/6pZLxXY94a+z0yi8KDLJ1xxR9FGvMWb+ZXDzJDfmqpMPaubyYXPievPH3wIhuelYDG5ljB2JpwcanMZQ74X2vkk+3d9PkaT6mLKjO9bcqp1jtKmrr7X5sCQ5MvQSYR9lspj5wT+u6GDE1EewxmONPbhSq67JoRqQk05a5evZBPhoWctydsu3K2fT4vmTzlp/2bz265siq+qHOP8sirTnwCuXm8eLm5fSAchWvYN+UciCVqaVmGho5vyzllSRvRI0WJiwu/x9zEpZ54UvIchEWn+F9yljGI8w6DjMs3b95u2bWUe3uAMKEpPwKgHjwljp8ANFwy8qSurFE9UgEzVHTGfb2LOLUk75OdRIAm/8FB+CJrq3B5rGNm4ghbcLt6U5lcrgxkh7NJr/On2Tsum9Vq+V+T2MKMc3I57A4SqxVdqCcIyva37jXzBQGGciRYqQEYGjXZHYMW9xnFlVyqqY4ftWxqVx4/Y66CX62xKOPUQwiaDwP/gFr1KjAOMasg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bindings necessary to implement a Rust per-CPU variable API,
specifically per-CPU variable allocation and management of CPU
preemption.

Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/helpers/helpers.c |  2 ++
 rust/helpers/percpu.c  |  9 +++++++++
 rust/helpers/preempt.c | 15 +++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index e05c6e7e4abb..af661bb9be34 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -70,9 +70,11 @@
 #include "of.c"
 #include "page.c"
 #include "pci.c"
+#include "percpu.c"
 #include "pid_namespace.c"
 #include "platform.c"
 #include "poll.c"
+#include "preempt.c"
 #include "processor.c"
 #include "property.c"
 #include "pwm.c"
diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
new file mode 100644
index 000000000000..463186b8af9d
--- /dev/null
+++ b/rust/helpers/percpu.c
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/percpu.h>
+
+__rust_helper
+void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
+{
+	return __alloc_percpu(sz, align);
+}
diff --git a/rust/helpers/preempt.c b/rust/helpers/preempt.c
new file mode 100644
index 000000000000..77dd5f10d8dc
--- /dev/null
+++ b/rust/helpers/preempt.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/preempt.h>
+
+__rust_helper
+void rust_helper_preempt_disable(void)
+{
+	preempt_disable();
+}
+
+__rust_helper
+void rust_helper_preempt_enable(void)
+{
+	preempt_enable();
+}

-- 
2.34.1


