Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2F60CFD647
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 15:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E956B0005; Wed,  7 Jan 2026 10:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0046B008A; Wed,  7 Jan 2026 10:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2096B0093; Wed,  7 Jan 2026 10:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A79E6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:16:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE556C1BD2
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:16:54 +0000 (UTC)
X-FDA: 84305520348.24.F6F06EA
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7A79940013
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:16:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OWRM2YWG;
	spf=pass (imf27.hostedemail.com: domain of 34nheaQkKCJ89KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=34nheaQkKCJ89KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767799012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y5KhcYh/HDEMfhpeShJc3bIRP0HovR3OTZMD4Ywi+6M=;
	b=vsdCn9uQqd0/icCEJQjvcDb9hmvcGclM79zpVJ459jhr+2ILKR6XdhHbw0lVQHW3gY25Ho
	GmQ60xRT/A8w1vqv9dDhXZV5OGCN6e8+kXe8fRkFi25iZ8fRho/Uoej7I9SMlYbLV3gzPl
	hH7hS8laHvp4/avPfTaTcA8FyJ63//0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OWRM2YWG;
	spf=pass (imf27.hostedemail.com: domain of 34nheaQkKCJ89KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=34nheaQkKCJ89KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767799012; a=rsa-sha256;
	cv=none;
	b=OAVK/MDpzOqhbFAvKP/avG8Fid6yhyDyGfQJNmNoDIRF5GZF8nqemTeGeNoG+i7PrhOyd7
	eyMFez2r6hUkSLEG9KuclpDrHp8ncUqhGQUGlzfxqSXDeNvZ6r56bDS/boTwbHAL99WhCU
	62h3v44C2YcOl8jDbwJjFSPDFfjarj0=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so20336255e9.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 07:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767799011; x=1768403811; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y5KhcYh/HDEMfhpeShJc3bIRP0HovR3OTZMD4Ywi+6M=;
        b=OWRM2YWGaZnjqP7keugdU9rtoNLBKK8FJ1+ncOZn6jCPW/JHeGppR54ilLDnXONXcX
         3NyYOAbYluS877Tt7y0JXbpyl2iXvLchLwrNny5bE1QWWIE1b9sidSd/AVoe47n2Vr3y
         rAtL2cPyeK78otuwHQjclm6TcSAguBw1MFUM/4lGszYbqp5LUfXcRfsiz0I9QfufkBb6
         a5nUDzLPN+nGi93X3LWPjsA8NpqOIUeqQcCbnUQF1QIIffRlZA8NqeLVZ8pAdChB/xca
         xks0t1gSPYEcIBV7n+G33ReyBQhyDTcRLSKT9rcte3oSx0c9vsOa95vnQytJUlncOAqD
         Cq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767799011; x=1768403811;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y5KhcYh/HDEMfhpeShJc3bIRP0HovR3OTZMD4Ywi+6M=;
        b=OiqgkR0ae9YSTBR/xO30sO3h+tpBAVOJ057NDYQPMcLriuwQxhv0vc9Eq5TTT7Bybn
         c8H96qh47XC6H/vA6ptmpGr8TEbUNdg8iBR0E+hegQHj7433SWrCxtfiLL7bpmjEXI7+
         npJCtZhswqrVQ0DzC6Sl8U0B/BT+kcQdf6ILjh/P2dBMnfgj2Fpk0dszQ5h877PSpFEQ
         B462lNf1FQW2fF9BR4WSkWJzQ9wzco38dhi+FgPcYSZDzT+hK5wzkimJWWGAG8SLAqtF
         K1H8a4V8ZglHvOQCfVpH9E0UG046OvenqxgswRmGsJh3LZOR3ihfAS0ubYWfvgaLzMM8
         Ql9g==
X-Forwarded-Encrypted: i=1; AJvYcCVfMri8vnbEJxCNXwarIXOLALaoekAgws9bREO2typVDO6V4dr/TpT0px2mUEnxT4VJU/gTfPGtQg==@kvack.org
X-Gm-Message-State: AOJu0YxVljPhDnuQla/sFgMSLtziaQLuSVuujgDP1ynDuZwaG/e7JeGu
	GtOJxPCCZRfb7Lc5a4C30YikKr7pI2vGOSbqVxPsZJUCMNrKFuhTlt4EYcwRzxNfGHWoiMvsDQ0
	IxbBJeRvLLV0hUkqFHg==
X-Google-Smtp-Source: AGHT+IHy/226WGsfxdKTD5bXwnrI3EV2nDVTyLl+dpH3NIQl5WMq3eRB8ICpabqPOangIJYEAg6br+51EJCY7QI=
X-Received: from wmpb42.prod.google.com ([2002:a05:600c:4aaa:b0:47a:9a5e:7c36])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:648a:b0:47a:9560:ec22 with SMTP id 5b1f17b1804b1-47d84b17ae4mr29501795e9.14.1767799010827;
 Wed, 07 Jan 2026 07:16:50 -0800 (PST)
Date: Wed, 07 Jan 2026 15:16:42 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIANl4XmkC/x2NwQqDMBAFf0X23EAi1LT9lVIk6otdCNmwERHEf
 2/obeYyc1KFMiq9upMUO1eW3MTdOpq/Ia8wvDSn3vaDddYbHEV0M7sipCTzmGXBGBKvuWFRicb Bx+k5+QfuA7VOUUQ+/o/357p+JlX+h3MAAAA=
X-Change-Id: 20260107-export-vrealloc_node_align_noprof-1e7fb9b78e56
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1584; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=Zh3CosvYSB2naZ/tsAZBGceplO+NdNCSsEdIc5N4TP0=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpXnjdN3Qj2lLaTIbxVd2IVEGyuBmcThP0qr2rK
 uDFctaFH0OJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaV543QAKCRAEWL7uWMY5
 Rr7AD/9uGRGZAWi9Wblof+yZYze8SKqGgaSLZFQM64E8snBItkl6yglCiP/auZ8VtIf0Op2SShY
 p/K2oFYUG/HMxdMHO0XcUIj/Qr5fr6XHqswxN35keDJrSDry9gor73YDia/Vt3g5v77H/a/D5gh
 IzmLu4of8u8dqDUpjEckhG9YBeaBLm+1zkI+QtTsqrwI+zKfn1Srl9CNtjsTCMAfiUb7CEG9kDh
 87a2QV7Xk40EtEAwz+AK3vggOXc2dICZjByaGRllQ29jMPSfcIBQO3ZzziL/VQyYuEck9xgJnX8
 aA22Evey+SyZh/MGOYcwga7NlBCVnT59/Cb+xCj0/ijwUR7FOHtAzUUjoq3xYgnIRovLLJc9msD
 qA2O78NRF3NNKKOLWd69y0EdKf3VtXzX3Q9k9KxODd/Sx8ORudOfw6kT75bViZmVOCkYd3C3DJr
 k9iUI7oCHjTY1iC2dld5cksCYzoPrhqKntjKeDeRecYP3RxC8/XYStwXEadEer4o3JodsZ2fmOM
 kB4M2QZSYl+oTpnIaMIagvIdodTf+Mq/G9cH+U8y548A7bISS5R6F0w4166g30DfbIvJZBrcTVv
 S/vk1vSMUoZNG8LX9k06wl7itOwpNUMjMLXQTFnqzzH16rndDTmdM31fdEObwu57J0WC+luJHw8 JiBfm1i2rzrYUvg==
X-Mailer: b4 0.14.2
Message-ID: <20260107-export-vrealloc_node_align_noprof-v1-1-a581bec13054@google.com>
Subject: [PATCH] vmalloc: export vrealloc_node_align_noprof
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: rzbqbmwmc17nr8rzmf6ytshw4fr4t7y7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7A79940013
X-HE-Tag: 1767799012-270859
X-HE-Meta: U2FsdGVkX1/ad5R6+2cmo2IVh2bDh0Bdmfb2fW7wRqKpzJL9HT5hwPSpbN+sAiBfqAsPKh/fJw7qTiZddJ3I/FEi1VVyHByFA/DL0qESTCAXFx/LIymO3OFKP+cE+CaLaGCrCoDeBmS9KRvFhGnCbcWHRCe+2HhxlPARV3f0gm2b9WHC5ZpCug8g+ysHHnn4M12W5zq//+pdHmBexT2aiF2KDOhnTOMHwNuihtYDZknruJq48Cxbh/Me4yw0lTbdDZGDYu1h9nnDgK0H3xzwmq+sbgaFtg9g2aabegEeGl9LWVFTApuotB/BqspkP17Rwh2g4akP8PS4jzDQFogkW2dsHp0Rxq9PWbQYgndR1tUn3adTQ0nTQDPnbKjl/k2lMzAFzZiktT/qmjb++2PTF6F9oupmH738856K6Om3gLArBnKAgMVVjcTz3uCNLuXDY+lUMLBcw8Yl2/v5UtOIKzr9BMyr9vkg/WL4wh/ZZdVGcKM8T2o4UiVWMwZhRVM9t3tJvlx8on+SRQiOysQvpxRHav6d3ej25AiQnNVFGiinQDJuRggxFqQcKkvrSPxezFiBPGdxhLE/XzvjfX9leghf29J7Y1+90AKT2u008UvlMWPqKFYLH8M7/MwDv6navaD4ovruSCfUsjlxy6oJgXzhuUueQKh0BonHg6LllpWNVZ3kD+FUvy2SDWratXp7BR+pB7+UPkNQGxSzO/onAsFUbxx+/pIPSyc/IsjiqYR38qsa007BUtirI/rmRmcopYRSpeKq5psicaGruTMGYolDtnaqB3P6HeTvtJQK1V+jLGwPR6yzJwjdhOXhZ3N7DBJvZall7x0fdvX0W/p3PX9ftli+1uz/wY0qWBcqMrjemyCQEfIswyoERv3yPr9om13N8yq6HtVEk18YgGCnzH4EeOQ0o8t62ZyAKo7qP6abKZD+Yju3U7pZ8b5qPoStv3tvYukp6ihGsPsnB8Q
 K9jO+G37
 4qZlnMGfgjuB1RBGJ/nppiFMTtvtL/s/1UyTE4CNVfm9XqUxkEIAe6IRagv4ExJA9ih2DAn3KkV/70TzgCZjaDy//JcAIcpotFSgwfF63SWOPYzwZICBRV4BDaklnurjwHAR1NBfr55cDWb6tRCprp67Yb+pDVbcxuI2suzUWl1Zl2Us1WzhGLBCB2kNrXV6sPzyd9vmMq1purP/JWcMbfNX3A4xVuZd2xpCLybT3bvk1MWCHd5DSUBmQQC6sp8GtQuEn5pOq1vy6HNPaK/FNM0K/C1KsbRfBs13ol43pjengKZ5MafqjJ2FKKb6KAmzgouqG4aS/8nEklQZ7M/zbcO9Ptd15hlVmfS9fnAQVDCKdE6WFPlCK6KDBbPq+aMcRD1AgTUMv00wmdHjMihEvfBvpIlk15C0d40oAvzlaR6fF0mns7/rG3goT9FHFSXnprfBjpY4RFrzae5T1ic6yplDEyz40KjCDsnW6G935al7QB991PfdCkMJOKZQBKUCSWPKlZ0dcxP3dKx7mb68o4fe3Mt6tnQ03T3D2ncriP4sFd2Z9VSeilwAaKgiAGin6yYeb2qHYINCKdXy4hp7+4HO+6SLMTLISzCCFrtzNd3+5mu3zBMYthUK9fB9bieq16sTJ2XLjo2AgO80ePyn1/O1H1tB7eCGVgTQHZlEM9CsaHTFIIlDtl3t6SK80Y20AuNeU5ZqYR6MKq57d5eP/je+Ko0HWxbzfffdYsjdpWWCxROE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This symbol is used from the Nova driver, so it needs to be exported to
avoid a build failure when building Nova as a module.

ERROR: modpost: "vrealloc_node_align_noprof" [drivers/gpu/nova-core/nova_core.ko] undefined!
ERROR: modpost: "vrealloc_node_align_noprof" [samples/rust/rust_dma.ko] undefined!

This error is only triggered if helpers are inlined into Rust.
Otherwise, Nova will call the exported symbol

	rust_helper_vrealloc_node_align()

instead. There is no Fixes: tag as that feature is still WIP.

I used non-GPL EXPORT_SYMBOL to match the rest of the file, but let me
know if I should use EXPORT_SYMBOL_GPL.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
This patch was split out from this series:
[PATCH 0/4] Inline helpers into Rust without full LTO
https://lore.kernel.org/all/20251202-inline-helpers-v1-0-879dae33a66a@google.com/
---
 mm/vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f9cf207ac9299be096939509be43c..c248b5edb682e9a08acc1c3e804122f5fea22d19 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4355,6 +4355,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 
 	return n;
 }
+EXPORT_SYMBOL(vrealloc_node_align_noprof);
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
 #define GFP_VMALLOC32 (GFP_DMA32 | GFP_KERNEL)

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20260107-export-vrealloc_node_align_noprof-1e7fb9b78e56

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


