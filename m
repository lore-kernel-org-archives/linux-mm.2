Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7681BEF99E5
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 01:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C9D6B0005; Fri, 13 Feb 2026 20:00:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA8C6B0088; Fri, 13 Feb 2026 20:00:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6B66B008A; Fri, 13 Feb 2026 20:00:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 97E856B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 20:00:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40D891C8AF
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 01:00:33 +0000 (UTC)
X-FDA: 84441256746.23.8E18C83
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 78762140007
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 01:00:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XfBZIJ9O;
	spf=pass (imf09.hostedemail.com: domain of 3LcmPaQUKCFIy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3LcmPaQUKCFIy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771030831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=N52x8JQ9Owt92Dd5wyBCJma3b4DEePYMVk8MRoPWKBM=;
	b=7vdfkwwcE/HdyrZTdvDpSIIGlVGv2xrJngL7084WRbL2X5Nr+MMtTAeJdiaYoNUvy11Fb2
	U/REQhoDm1yMuvPMDPBrUVFOhqMoo2VANXuVwjtNgrgg6TlUdbWSGtG5GNhBtEbel5Knt5
	6BI0M3f9OoWOxLE/Ggwfpttn0kyER/Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XfBZIJ9O;
	spf=pass (imf09.hostedemail.com: domain of 3LcmPaQUKCFIy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3LcmPaQUKCFIy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771030831; a=rsa-sha256;
	cv=none;
	b=cuCLWWM7KTGnLwgvuywK/WsL6xbCuChWl8Pg+8hhbE77OcWj9o4dh6daSQjPMPSIaE6LZI
	1kiQM0oJeLzZmTUIdXi1yrSGJB97pWbtr6cmFt+/hgu0j8uvSPCFqkJ/ArNkSSj7LltEQU
	B9P/JUcsmW6mmFjGW7wAGoQlFdZDPsw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4832c4621c2so16183335e9.3
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771030830; x=1771635630; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N52x8JQ9Owt92Dd5wyBCJma3b4DEePYMVk8MRoPWKBM=;
        b=XfBZIJ9ORlUBqxgYKr/WHmMMoj2WKaOyBKLP2c2K0IWJpHaibdHtf7BOi4XXA+Fr21
         h6ov5FH3WU/hh4ANRcxfUloEOy4OFI9CJEDzMgROsRUm0wjJ0cSP0ut3AlfzMr7BntiA
         Vf6kBSKylFTR9SKG9fRJrOQ6P5ypqBJSLe+7qpj55Km+wXwGNM2qgS3T3+hMql633fLd
         IpTCuCIhpMGdUwZvH8T6glEok4C5Xh0kCQ9T03KJ1QZCdJLhnj2Nkniv9JAnDTaK8tz5
         u/Lh8ohw2WVY89qnbyFFQFTaydGYTCEt4/BT2hq4fpdtq4gY6Ha8enEy5wYmqP6jUpjD
         pk4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771030830; x=1771635630;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N52x8JQ9Owt92Dd5wyBCJma3b4DEePYMVk8MRoPWKBM=;
        b=so2Yzo9jILr95eBVYq7g0SN3WaSCixKMJKGSAkFOehWW9P6aKXP1M2ZJ68P2CIVXsa
         uAn4N9bFOsP3E6ONOd6WwMyfWdNbG3z+c/M36Deslvp3Snp27zqd0bExig/JSVrm1zU6
         cGycWYk8UUtVbp9PFHluWpjJylrSV/LSwi5z7mTPQX+R4ZEojXmU0bTbamBcG6LPlBmO
         +DD1XPBh6Jqx7bLkjs6pyMWh+yJECmCwRZFDxTquW/30AORgwWd6HTBJ/ipoHoIAg4Vi
         j5WTsmdosyx3X+ATEpYmEkBBBbsfm4yY72xCQXqPMoxKS8dlG4CR0jANBcdFFAEhrZYr
         Telw==
X-Forwarded-Encrypted: i=1; AJvYcCUzO9UGq4VRrUtebRZKf8QuCk79it5F2ikXdeCDNU2iCD5R5rjuuUbmEVAkAufGMr3FXgrKm5qyNw==@kvack.org
X-Gm-Message-State: AOJu0YyquxLQxAVjNP4Hbkv4p/ZkqC6ixzwavy6r3GV70oNcS4U+IK7a
	WvL8LoP+tx9JqWPMz68JsafO33LnLLLEuu8d0n9RFVXmaWEFMtEOuqQCy4Sb9Ac+HsWIrVSY3yN
	W0g==
X-Received: from wmby28.prod.google.com ([2002:a05:600c:c05c:b0:480:3227:a124])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c1c:b0:477:7b16:5fb1
 with SMTP id 5b1f17b1804b1-483739ff8damr66109275e9.7.1771030829456; Fri, 13
 Feb 2026 17:00:29 -0800 (PST)
Date: Sat, 14 Feb 2026 01:57:51 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260214010013.3027519-1-elver@google.com>
Subject: [PATCH] kho: validate order in deserialize_bitmap()
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 78762140007
X-Stat-Signature: wyy7efxj9hscfr7og54eryjeceosjcig
X-Rspam-User: 
X-HE-Tag: 1771030831-870212
X-HE-Meta: U2FsdGVkX1+FXEa9e4h9L9I+ItznHyg/KorZ1nxOUkU+G2Xs6jHuiN7UORRd7A9dZ6eINUhQ0G+ovv9FTFHyFNHwVvXpe8YK+ZH/1Tj7HVKXyXTkvus45surxfdn4zSju3KMv3xUZK5iMPVmrfWB1POMsp3Vojsk00Cv8pp8i7bHVGFNaKHCKumzsMs3/3yy1vturYrc9KkAA4vq3rEODE7coIdH2TNO9m/bkcZtpBfQrGxc4y0M/duvqPM8dV9UMZUC9TTJp7FIZklGsU43BgzyCx6dnR1fZVKAanYeGaKXzZYk8SLgpW651YeYQfg+2UZ/MkE6KVMVVLF8nTjEip1dDr5fzIVC0N5QfLujoJQkc3buicA/AOc9JgOh4SBt/eOi8llJ5+f1kyqM/rOzl+2epgHPYgNFzORwJAoGEpXbksESb2BuOQKFgc3ww1FasU/OEMIaLFPeY/ihBEttuP8waZ/4VBGtSjNKez7NXt/Xgt87iBD+xlE5Vf8ESbF1rGPno3NJrTujvw8Szn4PgrvClJQU3vq83Tvv1PMqYfAwvVjLzXk9utI5N1KDhcsdY2UjcXzGQEqLDwdmxpNchv5sF7fQdYTlJAKB7w87QJ4/3rGj4fcB7C7b+Z6Yozspw/JQXNUYfdTFf8y4VcrhNOh0S9fVOFHnQIaaGkmhXSDW9yMyY9wR7JX075L445Uzi8o9Cdkts5vnOB4zr2Or4oBhBXKnEaiwAE72YHE4GPW/p3Zf+mW0P/77I3IwBl4mERtVrvJwklC8bbCgReb1phl65bpb5tm+dtDo2pigZaGy7bPHVMjcciJjKGdR+ye9BRl+T7+gkBzvOWiomxZeg2QdaqoB9qjR4xPAZjS0gJOrGqc1tQI60ozRI82t7GqusuRA3BGtzQxQfrvUG/L+RIVj6SKzzWX+GeTg0I0emiQ+D5VCrWLLPrNIn7BSA2cOEL/8sO4izkQr81Tp7ni
 zRzXJi6s
 knWCh73Bbm32KFECG3SVC2DM6U07FIwfPg4K6SCGNF1zzLo8Zuals7yivY7htEHNa4DU9hcVh+RSZuMZNJ5vkk9iE+1DzLIlZM4yA9Dgw0Fxv5j97+37ZadACut0h2MMnp59qi9wt0mx4ayQuLwtMVnzfRA+mUZtLD/Wytfyes3mHdVk08T27CYeQHt2pvjcUdXvOSkE99fF8AUl0pzxdVWxdWpXlL8IMKV1KgbcfuGMt1D6hozbkXG9/3tA2Q2n8zcin72Mx8sjeBzFdKdFn2OeSqKajkr+yKrtp8mc1pAs6xsOLUn8CQYIiMYDRkx+l+vEZ9uqmsUwtXjqrDsbv/Q53P9KuTmPPTtOoPVtwfZODRZiisC/MaIh+KZRFu1fRn6kRPJz4Z00WnX4uVGisX8fYhtQCAvTVnQHVXJL9hhvVbyrCnC87f3xY+gjUr74sUaps9bgdu1NFqhI2Q5Y49HrvAMwwYIY3iH3jtmsyolHWtCPKgj0Lm05B1c31M0Q8qXe40lFMKMAalbKkvKeDCpubH8wKSTtjYehlmS91t7Nov3qw88YcluGbf5iot33YXbuuK4IG8grWCMg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function deserialize_bitmap() calculates the reservation size using:

    int sz = 1 << (order + PAGE_SHIFT);

If a corrupted KHO image provides an order >= 20 (on systems with 4KB
pages), the shift amount becomes >= 32, which overflows the 32-bit
integer. This results in a zero-size memory reservation.

Furthermore, the physical address calculation:

    phys_addr_t phys = elm->phys_start + (bit << (order + PAGE_SHIFT));

can also overflow and wrap around if the order is large. This allows a
corrupt KHO image to cause out-of-bounds updates to page->private of
arbitrary physical pages during early boot.

Fix this by adding a bounds check for the order field.

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Marco Elver <elver@google.com>
---
 kernel/liveupdate/kexec_handover.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b851b09a8e99..ec353e4b68a6 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -463,6 +463,11 @@ static void __init deserialize_bitmap(unsigned int order,
 	struct kho_mem_phys_bits *bitmap = KHOSER_LOAD_PTR(elm->bitmap);
 	unsigned long bit;
 
+	if (order > MAX_PAGE_ORDER) {
+		pr_warn("invalid order %u for preserved bitmap\n", order);
+		return;
+	}
+
 	for_each_set_bit(bit, bitmap->preserve, PRESERVE_BITS) {
 		int sz = 1 << (order + PAGE_SHIFT);
 		phys_addr_t phys =
-- 
2.53.0.335.g19a08e0c02-goog

