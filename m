Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E05EAC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 22:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E942B6B0088; Fri, 11 Sep 2026 18:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1DDD6B0096; Fri, 11 Sep 2026 18:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7136B0098; Fri, 11 Sep 2026 18:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A161F6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:21:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3359A0342
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 22:21:30 +0000 (UTC)
X-FDA: 85202903940.07.BFB35CE
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B398A000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 22:21:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fmhRumc6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of yury.norov@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=yury.norov@gmail.com
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fmhRumc6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of yury.norov@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=yury.norov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789165289;
	b=HeeIO0Q27H07EcoA+3VEM2gfQvDcOKbeafmRDRnrxRavYsX5YIBB1C3r6p39SOKmSrkCmj
	/JKdjxPPC+34IugR5MlMuIAq3XNYTSUvURYBrMyrlzVpuIv6vEL6LK5WklLdq6tGUb6bcb
	HeR0RUn4/i1Xs5uoWv8hlPr6xhxc0dA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789165289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2k+37bKOMj5uflztInqcHyMEmLHoz6JlZjzrLWxQac=;
	b=YknAOmiCHz0TUMUAAt/OIuapVtOharjzV4nxqjkZ2/4cVreGO3YX0xN7xyEco2Gn9m9omX
	kbP9lXCjgDqS0qhwZezUwsfw2bzoLOKhA0XNpCIZY+peeaeZgwcKcwvS21CDFWkPssV2wi
	w0tyruqHsb8RyB9mYApQ3CTrSWq06S8=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c2c368cb3bso267184b6e.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789165288; x=1789770088; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r2k+37bKOMj5uflztInqcHyMEmLHoz6JlZjzrLWxQac=;
        b=fmhRumc6J/t8PppuP8F9KNRHocqmdu2QzZtVeqJhECScrnvSYYp+H8eyjN+NzzSkc7
         b/1MM+JyZDSQ7xEyYD1Y1sn6hJzxcW66LIfVEb3QaVUZMt0k+WyoOliRWYdW+mZTBX+7
         5pwKDPA5xmBeffuDGGZpfBAaCt7a5aZH37lKq+YmJYeQlOSpnFZfsECgLHZAXlUnUPnb
         Sw9rGxVRFxeb8D9lkS93/ZlZeLLTQcL84e/kWSvXFIg66ltMhyG1wYsgRd9DAA5blqS1
         o/F0dIUpN9T9fuS4nvLpPG/wOoYF26LVdurAgCPBF8NnEHJJLJGuO/gKNul3p0+eFBi8
         eiqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789165288; x=1789770088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r2k+37bKOMj5uflztInqcHyMEmLHoz6JlZjzrLWxQac=;
        b=ItK2bETj7wN8Q8AThKojweaV8ElUHBJ5Ugf9DjodavQIstYLVwMkggdJdq35DdZfI9
         TracuPXZvf/9VHzjdH+3sPOLbzeNasjS+F+pmVvs4Q23HlwoX4MQMbIK/Huf2dCKWMZb
         Cp7bDbvyhXSM9Rw9C0o/yWYp9dK7Y/2vLflPXSesyepM94fOKurLWbkc7Wi9h/1xTu4M
         PmQmLCdn+V84jtuKaVhSDZjWbt2BsFuasZxIOBQdXB6rD5mOPwxciW4RpkCxlvhU1Yqe
         k6uoj+eIRwgOVXJo0+bzN6l9yScnglRjsNrcuOjRvwut2XMbHEOZRXkq/4rjSAamG/R5
         DukQ==
X-Forwarded-Encrypted: i=1; AKwUvBwb9/jY9PCAJrPuSnlgD4VeFDh12q1iVWtj+y3t07n1VS8ArR6a5vfkcDBJMq4IRF3HVcBACe6X3A==@kvack.org
X-Gm-Message-State: AFuF++ltVzZEoVIC60eELBZByBWrN7JICLX12rP2CEAklGeTG15Y/ERz
	E9isr/jwNKccV879VRxo3tb/ikLpoKbCzWgxBGiVB/A9uFFkqs8pI3LO1kP4DA==
X-Gm-Gg: AYBFou3X63/uBDPlDu9gCkdeJgMrdsbqEJopN4qzhptw7ap/CuloPtHUh8tEHgldtRf
	Acgfdd29P/SfDr+wWn401bEOy4bLFWyy9yfJ1wd8XySmEaQYWOrEnt/rXQUpWLfT7s2iV2JP8JK
	kLHmzOeQym2Cc9HOBI7/ubJvG9Ny+WpghJAEms0TIA9UP15e6mFB1urNVY69Gtm2XD3hacPMVm4
	QruMmHD9BDYGtoEVxdVdTmVJHsR7RPAyahQEFrwYv7ezL77FKZ1nEwFBuet+/BBIIEUEXdkuTIv
	U3EsnD5rqBzpRBNqkSR1A9eL1M9d8ZWeTJ3ssGA7jq+uA9ffSxXaZQD5FiEr5fGiuFwskP5CiWy
	xIyY7cHBlNl0ZlnvzdnI8oY1TYru9/1IRAjpNcQcuIEi8Zt4sx1Q+0tYgrid3s3puLOQQIo/foV
	yPeqQqY9AKnIQzuQ+mF++sMQM+iYaqHcwgLPZKQRAUfH1sDWzSu9EiFY0DEYMFRGNsEaEiYkCct
	VgWMQ==
X-Received: by 2002:a17:90b:3c03:b0:398:de23:9af6 with SMTP id 98e67ed59e1d1-39d9c1db154mr11222277a91.15.1789164889827;
        Fri, 11 Sep 2026 15:14:49 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365b8137fsm9073522c88.9.2026.09.11.15.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 15:14:49 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
X-Google-Original-From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R. Howlett" <liam@infradead.org>
Cc: Yury Norov <ynorov@nvidia.com>,
	Chris Li <sparse@chrisli.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Yury Norov <yury.norov@gmail.com>,
	linux-sparse@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	maple-tree@lists.infradead.org
Subject: [PATCH 1/3] compiler.h: add ASSERT_STATIC_STORAGE()
Date: Fri, 11 Sep 2026 18:14:41 -0400
Message-ID: <20260911221444.1523311-2-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260911221444.1523311-1-ynorov@nvidia.com>
References: <20260911221444.1523311-1-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B398A000A
X-Stat-Signature: 6j6zs1sc7ri6g5gfxj7qfy36cay3enqn
X-Rspamd-Server: rspam01
X-HE-Tag: 1789165289-827103
X-HE-Meta: U2FsdGVkX19TFJYmaBR8OVY9aH8Zlo+FkAMzWjlvKVEiahtJnL7ftnRk3YLSyNEF3RXI4dXzPpw67ixZ4lYv3/Y4RQanIosuCs2x8wXpxD5rnG7/mAX4JxPs+KjMydqOVDhYPKArlcf5x9X5d+UxV36wXPYTXSOQ9gdyGCkupGvR+ettClQyMiL2WxlgnWqgPkfhfeua01ZImbEoyriF7XdXQLmxBGygjwqbFWxATVD3xkzfvGFr+pfhhyRgliXdkW78WEtc/oBqjf7ndwsw5hs/8mQV5thoMJfAOFrEfGyYuDu2Ze2PoDnzHtjAx6he2aGDXxL0Nd0CqGfX/vuPkucOqB61lIh7BOYa06zHim/B7pDKCOEKE65A+o82hpWXR1XooEnV1g6bxqIBQL2VNBSdZFc+pWDTbYXUIcHKLsKylHkEhcM5mrCCQ2PrMBhGPU8cSD++TVno0p5qkfA0Wo4BOAOf+KCr74o/pmOTLv1JLNdgeTr7NLvlqx1XZP+XYHgxmxp38EMSwrubx/a0eqoDjikcTmXADd/QvFHvEKnvJ93G+1622qV0eXhhJdn6ISJC8+jMm38phvi+wK3zhl8xRK04K5t4YtsGTq27F/jf0WWhDq0FGsLpCt30b0JQwKISNoPrwlNi1SV3SEzBdyTRbHhmJapGnZS31cVUkiHjZGOJsuYnZ2Mxh8jeeDifJEdHRWOQ6MU7RnhlIC8Cxbl5h0M/l97hylbWmKeIgHFx57V0D++Pw//wDGMZQ5gNXgugZWZQZRkpKma1+0hTTAS69woNRKgR/ARNSXGzwB/6W78+JDhd1mN3lEWYN4s21Rr/leSIionmyy0h1xdN7t/hhBWEAYnMVsaxWLIhQ3AJcQL82uvMEvlPFBWkef+20vu4VfQPoAUuG34gsKSS8VhC5s9WVi4vYnvtFwKW+XNYd9d94OMrKXmTvVXCaXXPu13pD1z+BqEjYU6eznr
 1T09xpWl
 9ZAdYcuC2pMrTPTHojkOpfTMBH/+MTMo32wSBE5Eyx7Eb5rLmNT0mEIg1xZMyOK5FQ6U0AqDB/6AGDdu/kjkepEKRGs7OvoJVfro+9kEbKU/4gUdjS4VUzL+sCwnSRgbnM3//WDM882W2tdcJfVno0QT8yDx4PN59dLE3phx+kDSxpsWETLzVu8asV3H7OH8Um+ocl+tfHWVy7EM/J0LX+Bpo5HbLPqy4gfx8I7Nj/7bWyKYSPzcBGIUlEFU+fwuRaJr5nvyCqiwzWmslVZy9AbSe4QeVLpR/1hSffkU+sNBMOVq2O4/p04z/fgEWA/rh0ZjoHcnIFUxjUUV8f1bsIAifH2PKsyXR118mW6yQr4i2leYZxX+OqLFMoZ3mGEIIsiNB2TbYIHSyxgqAYWaEX584ckokPqBhCtMRZHo2ei26Ng8izxLSSDo/pemHPnl20rvUa4RPCqVAxiu+Wv8Re2/G81kfYdF6Hznshuu/mbNSV+ZUMABRltT+C226MZX592n4T31M7wj4u/X3XK0c4OEsQ2WqPVTzIPqC4u8p7+UcPgI0iTijoci+Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Static lock initializers rely on a persistent object address when lockdep
assigns a lock-class key. Using such an initializer for an automatic local
object can compile successfully but disable lockdep on the first lock
acquisition.

Add ASSERT_STATIC_STORAGE() for declaration macros that require
static storage duration. It declares an unused static pointer initialized
with the object's address. An automatic local object's address is not a
valid static initializer, so the compiler rejects it.

Mirror the helper in tools/include/linux/compiler.h because the userspace
radix-tree tests include the kernel IDA and Maple Tree headers with the
tools compiler definitions.

For example:

  void example(void)
  {
          int object;
          ASSERT_STATIC_STORAGE(object);
  }

GCC reports:

  error: initializer element is not constant
    name##_storage_check = &(name)
                           ^
  note: in expansion of macro 'ASSERT_STATIC_STORAGE'
    ASSERT_STATIC_STORAGE(object);

File-scope objects and static local objects remain valid. The helper takes
an object identifier and must be used as a declaration after that object
has been declared.

Link: https://lore.kernel.org/all/20260911155244.1406122-1-ynorov@nvidia.com/
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/compiler.h       | 5 +++++
 tools/include/linux/compiler.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index cb2f6050bdf7..ef9036fa5413 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -275,6 +275,11 @@ static inline void *offset_to_ptr(const int *off)
 #define __ADDRESSABLE(sym) \
 	___ADDRESSABLE(sym, __section(".discard.addressable"))
 
+/* Enforce static storage duration. */
+#define ASSERT_STATIC_STORAGE(name) \
+	static typeof(name) * const __always_unused \
+		name##_storage_check = &(name)
+
 /*
  * This returns a constant expression while determining if an argument is
  * a constant expression, most importantly without evaluating the argument.
diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
index f2f54b038168..03ecf9086643 100644
--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -73,6 +73,11 @@
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 #endif
 
+/* Enforce static storage duration. */
+#define ASSERT_STATIC_STORAGE(name) \
+	static typeof(name) * const __always_unused \
+		name##_storage_check = &(name)
+
 /*
  * This returns a constant expression while determining if an argument is
  * a constant expression, most importantly without evaluating the argument.
-- 
2.53.0


