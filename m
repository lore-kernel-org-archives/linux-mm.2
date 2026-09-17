Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B325BC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20AC6B0095; Thu, 17 Sep 2026 05:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB476B0096; Thu, 17 Sep 2026 05:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8656B0098; Thu, 17 Sep 2026 05:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 614026B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:10:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFD83A02AF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:10:03 +0000 (UTC)
X-FDA: 85222682286.24.38974D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id EFF171C0005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:10:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l3gjnXE7;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Hss+tphsWYYElyG0udvHfxNWLscjSFYocLTPr6cLgQ=;
	b=5+lbcO4AX5qNol9DXaFmyIIagdtM2xBahrKtH2kQ36hQf9H4sPf4dTgnqp/Sblmhe0VU3p
	sKUTIub939INIo3DKrT7jceAiwqRQLT1Hq3Pr7Mrno042Gns2xQdDoc6kN+IJOA313JjSl
	dZ1OfSYTgWgJAypATxdr4iO61xhFzTs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l3gjnXE7;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636202;
	b=Jc+m13DVj28zpSxE3wXT8wfgNx9x+WUaM3grzqfu8Mlnfhd9AMVoRXP4khOrTcr1hJdRDc
	3MO8F27r5TPnifEv7mJR3LrXC5nSqotKUnAFjOjBpln5eTYnhwbHS0ZIHg1xpy2DwwiatN
	JONBGXKNp593Mgat4yoD6nKwVZOMSBE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AF5A60233;
	Thu, 17 Sep 2026 09:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812851F00898;
	Thu, 17 Sep 2026 09:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636201;
	bh=7Hss+tphsWYYElyG0udvHfxNWLscjSFYocLTPr6cLgQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l3gjnXE7hyT5hOLZNPuXtJreEraAnkHGYjZOWrcBMNjrzVCWdvetpyMslrwhSfAkO
	 dRQF4mzZw8Y2oBrhxgj1+KlIDVtCllYMWw6nEV2QDqvjo+PpIsY3F4eSkb7CFXTq5g
	 6ie6SAioCC9t3pGh2WqYiA1cVlB9RwhtH36z7l8mtgypnmlNz1f6coAtrJoiGo7Ic6
	 6bsNfAy8z4WRfiuNSoBwsbSg691wK9hc7SgDLYTu17XLnT1aSqTcvtkCnScw6mneEs
	 xNybY3vM3kCYqY6KHxfBrts0RxMC6vlY8bnK4wzq921kn+rwbhbK1xm5mfT6Le9Y7q
	 2xoHozTmkIevA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:09:43 +0200
Subject: [PATCH 2/4] file: declare the FD_PREPARE() variable with
 __cleanup() directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-file-fd_prepare-v1-2-b87534ca49f3@kernel.org>
References: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
In-Reply-To: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 freedreno@lists.freedesktop.org, linux-media@vger.kernel.org, 
 wine-devel@list.winehq.org, linux-xfs@vger.kernel.org, 
 io-uring@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1726; i=brauner@kernel.org;
 h=from:subject:message-id; bh=h8FDYLEJ2wCbTw+8dTetJhDBaeIOwFIz8qAAMf8e6eA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStXhe5uVx3TjxPZLCm+imW81Fc3kEKSm+U25QOvTeX1
 yj62pDUUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMBEuTYb/Tue6jnQpfGRSycj4
 7OZ9mvk0u8L1e66vj/06JZdSrMvxleF/vLJdkGZv25roipfn7P9vT3sQN/f+5M0M00LYou33PPz
 OCgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EFF171C0005
X-Stat-Signature: j7kmtnu8rzgm3ocxmnkgeip1egos4i9u
X-Rspam-User: 
X-HE-Tag: 1789636201-939236
X-HE-Meta: U2FsdGVkX18a0rlpS2KTL6ZymKUuMzfTL/zmCDc/nsDwn7PLWktjYcbMvbSI14N1g8qXdAj/q3mDSfwYQYTftlbyNl/0Dq3P6lx0Ng6PB9ZRzoYKkfOtIp2majMaub1gf192VJ8hzRQrpVOP+/QWU48BFpQIEp0w7Z0FinYbEYOvCNjrxH5+ANRS8Zz22B7O+HgebrbmomA4+5OxgKlpYZlUlVVQc1FSIQdNuUrIqrjwMwyqNaa8pK72YLYPojNWlTFMRPg38pH+UQdne03q68Mw1cTSmuQUgRWcRMjNKGo3StJDrUrmfStYWKPJd7TRq6rNWW2vPcCpy9nlBZ9tJEmLw9Ix9qMqskcmwPnaFaSZNRu9wBeNaYXtbWAqhGHFMu0b0VcbklzAa6iAjzdhKeKGLy/+p94xj37WU14TAa6fliPypklYidQD00m8E/AIaw0FFzYPd6Gb46EyjvIRprMlFxwVsuFPorwU9+VzBaW4WWpvYhOnO5XM6stK65FJsaE0kjpgwTSJ32eugGJxuL84/XHcf+gxyQC4dzT0eWODylGbOplc9KedmxUI9knRwrryghy76c73UITpzhe+HhHNwyhjCgDBJ6hzWYD1t3eDC61bbGwWxdtnaEp+dpc3cBch5m9IgmJQyf92VeJO4brYy/6GbKN1H+CiBDFdDeEf95A7x1ItbTiAFy33QmhiuY5zshizH09Q4I3EixRuQnVfsHUhPIvGEuN3bFzL+C2281/ubFq2s+FMu9If5Znt1PoVMn70zKrW/Y/5ztovr+DpZSzY18olVUwg3BglS1YI1eaYLnIT6PaOjhC12P6BstttpIeVRadqI/cCJcd27o7o0Mkwe7OHZpm7YtR/UEkyEtJNc/SLy4S2QEoVidxo110rPWifAZgIVPwr8c+rIz3FyEqMnFywtFohuQCKOk2qmkZ0OzmMNO26Ogym/Fqi9qIDT0aePv7nhIH9v6m
 9vJ7+cab
 RljrWF7kMZwoVxrJ0mc9CLZLlhsYZdS3czo7sWr9MmYC1yVgC65LqnuTI16jDOEhPHAqANR6m25+FemtP6gvuCkez7FRPxf0hidGhCTbGWAVjtHYeLhs8F1YBl1s1P/YTR3+VLh2kSVpbGmZirRp0pWXYbrlE6WtlNrMTrVNZXWs9WDvfEmG+g8e7Wfxw0BlE5CeoxkKn3wCvukhY7ZiDGt7z+FjV1SK8+iNu+CAd+QTKEUCCOsA+SdQe7kAfirpJGdXR9SxV6Xf1QjMYqgvFUXbnzvuVXnU6DeLa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The whole CLASS_INIT() detour isn't needed. Use __cleanup() directly and
give the destructor a private name.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/file.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index 2b864f457211..926cc58d0b7f 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -146,9 +146,6 @@ struct fd_prepare {
 	struct file *__file; /* do not access directly */
 };
 
-/* Typedef for fd_prepare cleanup guards. */
-typedef struct fd_prepare class_fd_prepare_t;
-
 /*
  * Accessors for fd_prepare class members.
  * _Generic() is used for zero-cost type safety.
@@ -160,7 +157,7 @@ typedef struct fd_prepare class_fd_prepare_t;
 	(_Generic((_fdf), struct fd_prepare: (_fdf).__file))
 
 /* Do not use directly. */
-static __always_inline void class_fd_prepare_destructor(const struct fd_prepare *fdf)
+static __always_inline void __fd_prepare_cleanup(const struct fd_prepare *fdf)
 {
 	if (unlikely(fdf->__fd >= 0)) {
 		put_unused_fd(fdf->__fd);
@@ -199,10 +196,10 @@ static __always_inline struct fd_prepare __fd_prepare(int fd, struct file *file)
  * @_file_owned: struct file to take ownership of (can be expression)
  */
 #define FD_PREPARE(_fdf, _fd_flags, _file_owned)			\
-	CLASS_INIT(fd_prepare, _fdf, ({					\
+	struct fd_prepare _fdf __cleanup(__fd_prepare_cleanup) = ({	\
 		int __fd = get_unused_fd_flags(_fd_flags);		\
 		__fd_prepare(__fd, __fd < 0 ? NULL : (_file_owned));	\
-	}))
+	})
 
 /* Do not use directly. */
 static __always_inline int __fd_publish(struct fd_prepare *fdf)

-- 
2.53.0


