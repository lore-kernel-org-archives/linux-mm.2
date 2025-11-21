Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B97ACFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1166B0030; Fri, 21 Nov 2025 14:40:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1A26B0092; Fri, 21 Nov 2025 14:40:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FB26B009F; Fri, 21 Nov 2025 14:40:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12FA66B0030
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:40:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF2BE13B9A8
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:40:29 +0000 (UTC)
X-FDA: 84135630978.10.2A0A12D
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id E1E2A100011
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:40:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Tdw69nCu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3KsAgaQUKCH0npscphpphmf.dpnmjovy-nnlwbdl.psh@flex--morbo.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3KsAgaQUKCH0npscphpphmf.dpnmjovy-nnlwbdl.psh@flex--morbo.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763754028; a=rsa-sha256;
	cv=none;
	b=svry5qBMPRBGMM+y4kYCEi0B66MxxK6Fk5e+PH1c4vhfod8mPfhz5ZJ2QnwiNozQeXpmsD
	JeyGesG1Nr3Oda02wRZK7+Un97zydiaDmZqNflRUr8L61C0Ew7/2Ao/dPo4vkZ5+XqadHe
	/Ojs8Ai/rxFz7bRyN5Aoowq5397XBVw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Tdw69nCu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3KsAgaQUKCH0npscphpphmf.dpnmjovy-nnlwbdl.psh@flex--morbo.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3KsAgaQUKCH0npscphpphmf.dpnmjovy-nnlwbdl.psh@flex--morbo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763754028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ObV+Zk4UGl+OHKUlzzzuAGKm0snV0PrXsMvOzsuqro=;
	b=bxyqI9XgeBUpfPMnLQmACdoStrMUCYY6/QWZ1liEwUnaztyDfg/NTzgICbeyWZWO3RplfN
	CHF55FdL/JkXHEqCJcCziQMlhmw8aej+z1ykRpRbFH7WW+sJbqrybpOMF2jwU2ILqxkGHt
	4WHoMGi0DpkS+TPuv6oiwEstEujVh2M=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340ad9349b3so4984718a91.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763754027; x=1764358827; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5ObV+Zk4UGl+OHKUlzzzuAGKm0snV0PrXsMvOzsuqro=;
        b=Tdw69nCuoUSggJ48ubSpbMjAH/vk7Xns8kpi7FwK7PtevWXGhWtRktxQe6an2bZ7I6
         XM6XF9apLiNc6eLcwGdZii6w304SfYU0v4VyPSdTMqiX37fEqKjWvKAqyPP3du1f54rw
         UKtAhSTvqlIgjyqZOivBSTWSY5bt+hq0EDGV0uCi0EPHpVMvIj6p4h6T6t7EIkPgxe0g
         tx6aHoOXx20OCGOY7ARSPz70aAXaJB2tGYiHfk0uYfS/P4zWDGKVTFcr3ug/cZCvrKiF
         D2Rz8EJnSOTUKkfjFS+aafFmdReigdOWYzbJJYQeeCzyrLRIMlMeIXkjU6kD1JC6s7X0
         IAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763754027; x=1764358827;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5ObV+Zk4UGl+OHKUlzzzuAGKm0snV0PrXsMvOzsuqro=;
        b=w3XmAu5DjsZKDRC+u7vUE0OEIxL4GU4UlwR3nkEezqWuBisoQy+9zWltN/aZzIkUoL
         RAVbKSPaqEUs3qk/yPJK6xRy5jbIzJihxiDJEKUKZS7Fn7aqph5fykMFxfKx6iCBrN78
         tm/dE+gCIyTU06Rm5Lwi4y2T5pD4HNt4e+J0VwV8oVcrZ1H3X7+5g5GXJMQ/+wbG7ISi
         12rsrUuLxZyFUWZMftFBgieUg5qyqburNMg4+acCdMUT+R2ejhdpwno3rldJLH+Mk/0K
         GyUZxy8I0tSiY4nqUJCeeOo9zA6iDirlm67HkKcgaSWeFuqstYePdnoGtyTTyiJuOvjU
         UsWg==
X-Forwarded-Encrypted: i=1; AJvYcCUW/bihJR44Lkyu04goYKqbq4AGzF9RrCVOJb23Rt+nHWYw3+KAtBTOezU2boaywzIyufi+IetkkA==@kvack.org
X-Gm-Message-State: AOJu0YyNXW7FlIk1rwRNTPGpBuvEu60QSkQsVb1BHyhImIuOvwXu45Zv
	sqoVoxn19H8rAAvchHyBHaFGuPJWpfNp5V/Loc4aC9C4HW4eT+8dnFnfBjOIuCT3tG8RaQy7et4
	r
X-Google-Smtp-Source: AGHT+IHYGh5zV/fY6RILJsIKpbvv1F1nIeTXt6YbFfyOedqnc8pj8XMUszI38AOKmYkoqII6p7rKJtxK2Q==
X-Received: from pjbch15.prod.google.com ([2002:a17:90a:f40f:b0:33b:9e06:6b9])
 (user=morbo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:274c:b0:32b:9506:1780
 with SMTP id 98e67ed59e1d1-34733e60873mr4100051a91.9.1763754026636; Fri, 21
 Nov 2025 11:40:26 -0800 (PST)
Date: Fri, 21 Nov 2025 19:39:44 +0000
In-Reply-To: <20251121193957.1655580-1-morbo@google.com>
Mime-Version: 1.0
References: <20251121193957.1655580-1-morbo@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121193957.1655580-3-morbo@google.com>
Subject: [PATCH 2/2] memblock: annotate struct memblock_type with __counted_by_ptr
From: Bill Wendling <morbo@google.com>
To: linux-kernel@vger.kernel.org
Cc: Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Justin Stitt <justinstitt@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Marc Herbert <Marc.Herbert@linux.intel.com>, Uros Bizjak <ubizjak@gmail.com>, 
	Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	"=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?=" <thomas.weissschuh@linutronix.de>, John Stultz <jstultz@google.com>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Brian Gerst <brgerst@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E1E2A100011
X-Stat-Signature: hf6tj9sr5swo1xq3xnh9pez7dtdbtfyy
X-Rspam-User: 
X-HE-Tag: 1763754027-728518
X-HE-Meta: U2FsdGVkX19Bb71MleuTZDf5hML/mxWezJamzVBfRhq86gS43b0yrQnPa5VHlI5782TkSOS5U1vyw0IhTXELwzVGjuJD1VfVY9P6sNrtR1QA9dtmCkeHhf0qQk+6egj+Pjb9xa8yfpWK9O9uzALgF7OlOCpbqvY3CEqAgfMc9+zfmR6IMF+r9suKTC/sPHfG0FF5wGu21OgfR7CMJWSs/dRA0F2PznsMoCTKD2q/wETNqq4hTwzP4AeZqdaXXh859xROOgebpSyszo97inrhsayQAywkiKvntq7ObZ6L1YnEDMB2DCA0ldNa7QmMCekFZX3iK77fF3jzFVg/hwdWHvoGFIoVKlpv3EQXu+nkVlpWZMaV+7bbLA2VdQQbultSi0XAe9x6+/QuFVV/+0/S5a/cgbAoXicsIjk23gSTHtnG6gc7YDdqXFLHUjbv0O4/BXYClfeg9s23eE8JN2ysE6v7udwyzKFhSoC523cQjW9Eo9tiZmNuVnfEgMm+uSCKwifkwndKqo0JenNYq6hm/Vzod+gDJaokKXTBTMLp2ZozvDfjhLkGcTPYO13VnBylS9XvzoO7WfHpVUKCXRMG5gL8vqn+x5Y0BVem32F8u+QHjGJATY6mgpyyM2awJQCUr9F6k6FJuMloq2PZkcg6YscdWhxXA7Wx85xiNqP+a7QQGkA0KgxBU06OacD73aMRiAXHf4sarTKW8Goeeh+HidfthITmOwzsrEuuurBAxkhR6/j6FPAU8ZydUJxznOfTMBEKWcBSIk62zbu5vxVadiascE8tIjgeU6AA9PR3upTZ6DA0pLcilABQ8Nr1EcC/E0BXLDLpYJWJiyZ636Z0s1JYCBtHJ34Nr6P4f41wPY1zAuh/9QjLqtO1BEBHA3gZYXJHBTxPxyeQoxaGkWCqTNHNMMsqzGu3AF5h5qMAWQzf6Z1ssh5GQAAnEBsTlElDi4E8tdSv41Xz/Vo4c5r
 wrT8nyUl
 2K2iqNSmfm2FSkPHtz4f3sd9qc6eIx+EyORM93rSPaepINkJskVwL3Se9goIS+xjkmBjtcuym4PgnsFy9lYf9iGVWehb8FoVSqm43l+c425QuzSl37ff6MvyY+SDgPCBvFdn4AZWlo96jV9A1sI60VRt56ofvUMyesN6fB/Wjf/mtu7lIFywr2H8LK7mNRNs490OL+Ei0tMlFn2YHARWZXEVdARH/utWzyNUrKUvtbLVcxKtJPrffds9w3wvPSqT6Olen1ma93UrfeWGIELvMCILEO+j0PQZxmbdWfdKdIXzZTdNIqG8Ea/gCczYXGp0H5hs/ZOtBKKabqq6EasBSkubsxoYBpOcdDyROmT7dFiwyr6tHEP/l7SteFGg/MCBTSyicrqrmbVpU3Q98bj20YJnuVynGlUvvbirZOYKYuBEa/+anYtb9bngJbs2oy44Mz179LkAuk6CgSfNua5LqHE2x+p0yEDgcxtij4gN8bblO3LmrUfkog6Ul1EjyKi1gL4sdp79vFzmenZXyQ3II2FopCr1EIDRN1iqhTSG8y5A1uQvcOx4d06cUnqDqgWJmPDOEwF9U2lXXGbHI/CirXhuZd5eo1ODBc/Nl8I99UyI3e6FwXg5/rC5BOTQkV1GIDZzIDf8XGT2qUlzc0+x4inCQR/51pnm8ssl0LZAlpVhWqDY8QUeqe+4eVGEKqCxljLCm96WS1TsPVO35d7MXsuYhZbJ7PSqPiDq8KrPMw3P9R5L0slLgVmeDfT4Mf38T+C13B+/JDKyPf8AVJHv2v6ohXVQs3QnhAMNJqU2Dlw0EVRWNQK4HSw3GRqwThio9ehxNl8QV0Nqs10JtRw1Pns+3c6Z9uEGAJSlUGgnWkg/l8DJaJ9xjD7f+lhhOaWlJutFA23e2WFNJUK8bIHdsYoebmgiQHl636jNBvatClTbJna5HNgJZh16qDbEuTHblgW1fxpnruc3NVVnDmxXHcAHyqa0c
 eNbniaJy
 mN/V3Sry3kG+9sRxgDcyV/S6OGXDfzrO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the '__counted_by_ptr' attribute to the 'regions' field of 'struct
memblock_type'. The 'regions' field is an array of 'struct
memblock_region' and its size is tracked by the 'max' field, which
represents the total number of allocated regions.

This annotation allows the Kernel Address Sanitizer (KASAN) to detect
out-of-bounds accesses to the 'regions' array.

Cc: Kees Cook <kees@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Marc Herbert <Marc.Herbert@linux.intel.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: "Michal Koutn=C3=BD" <mkoutny@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: "Thomas Wei=C3=9Fschuh" <thomas.weissschuh@linutronix.de>
Cc: John Stultz <jstultz@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-hardening@vger.kernel.org
Cc: llvm@lists.linux.dev
Signed-off-by: Bill Wendling <morbo@google.com>
---
 include/linux/memblock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 221118b5a16e..ba7f7c999a45 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -91,7 +91,7 @@ struct memblock_type {
 	unsigned long cnt;
 	unsigned long max;
 	phys_addr_t total_size;
-	struct memblock_region *regions;
+	struct memblock_region *regions __counted_by_ptr(max);
 	char *name;
 };
=20
--=20
2.52.0.rc2.455.g230fcf2819-goog


