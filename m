Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDBF606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2WPmp5+
Received: by kanga.kvack.org (Postfix)
	id 8B5E06B05B6; Mon, 16 Nov 2026 08:40:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F7C6B05B7; Mon, 16 Nov 2026 08:40:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B856B05B8; Mon, 16 Nov 2026 08:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9206B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:40:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF13C409B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:40:29 +0000 (UTC)
X-FDA: 85441091778.18.8F8F347
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3FBEE20006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:40:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q2WPmp5+;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794836428;
	b=hOnPEZsJA8pzDu7AssAPjyNy+S0xPi2QzK3TNzTEtqLXC1ADDoBAQHJIHxCSC+BNj3xUs/
	enwFMtEKfigHCPrBQ2bwNxfmmWv6vjywF33xiqrlL0WsEQZS9cwLedmCq+TSnwYylzqy/V
	2ojnpp/IqzcUtG7xnmI4xGi//C+y4Q4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q2WPmp5+;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794836428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrdcdttsZ7Y+FKLVhKP3yfAgeP8cp4gI+kbn3HQkam8=;
	b=BaSIT2Z4HPfhqehFUhwmPZLn1oTo0J93YHLKSGC6oFr1FHVUIoKyprH31IR2faVqGmFhwR
	KVAVx6vljlt9WVGw9BM2C4JDuqrWS/8ZWEImy0WyE3KSoKjspaGiWUX/mMRTove31A8yJr
	L5Hoejxp+NH14FLRWIAwWPT01LnurW8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC97762A10;
	Mon, 16 Nov 2026 13:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B3E1F000C8;
	Mon, 16 Nov 2026 13:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794836427;
	bh=wrdcdttsZ7Y+FKLVhKP3yfAgeP8cp4gI+kbn3HQkam8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2WPmp5+BJ6A8U6M9SELLKrOsIM4+EP3Sd657t/2tdHbA8zM7d5o+aGG/HrrvNWGI
	 z5iMsQldw8skKSZG2hVSqWw+KwUN1DAhvHwSVfqNUB4TUcs3pPrbvbVY5OEUdZEv+q
	 mD0DUoouUUS57SI0CPZOasMLvRAHl8JiITcte1axz+oiELn4i7FEpJ7KjKIOH28Jnq
	 Jl29UKbapBWXBaNOFhJEFm31ONmDP83um0XNPRtl2KscdiQPBkq+Az8mhyUD9W9QZS
	 oP90ei88TFq2AcU3CryGYKgjyyOMg5Es3yqr7igo19uFD2IdUphHkLtQ2aJ5553TeZ
	 W+kOSiL0rTeLQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tarun Sahu <tarunsahu@google.com>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 1/5] kho: add KHOSER_CLEAR_PTR()
Date: Mon, 16 Nov 2026 14:40:06 +0100
Message-ID: <20261116134013.1636689-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
In-Reply-To: <20261116134013.1636689-1-pratyush@kernel.org>
References: <20261116134013.1636689-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wwfwmjppkdd3bkrc4ptq3f9wcbs19qf8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3FBEE20006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794836428-823365
X-HE-Meta: U2FsdGVkX18xZHp2BX2T4VGrpc+X2id42hrI20XZSJCG6qQsw0CuCu+QmiwiHM2xiMOhmgWBEEupvWlqk8n3Q3Tp61/s2wavMzLeTiiIQqjFeE0y9pcR6PhwypOc6U86M4cOqWVre2upwAs/+aCqwFw0QLGXaQtAAifIgaUhydyGsVeeZ65q213d86zaW8nFVvYH6Dy18KWBKyWp8+77NafQrGlksE/XypbKQXe+ew5Gjtd89APgdgWYuUd0enJ1I4z9UGktu7DNHdrVNKYCJVws6gTWIj4h9X9uCcMIdkR85Wq6jp1n35Ak0pJsuHEtaZBvhcNK8RmE79SaZdA+IBiO6tGF/EExCs3QWCRH3KrekpsyXxF3aWHu4XNFjmJOotyJnbSWbdGvJ8BrhNGBMjISf9uREyyghDe5ymsse7q0Ecas3rBd8znmNhJRCExQpDevHJiQTnOwMJls4hXQyuaCqA8P0ZO9IjPkJRa5aPZEVthA0Onk1fbTw4db+A2N+ep0ReXIn0JxHVI/yHihFAoLv6oAvl4bRsDZ0I+pN/+nhfqDrtqW/DNFvVcCU9oUoEIpt09pneWBznfFYYwyhzI5E3Rzj97Fskdn8Ii70zncJRH9tXkLNv7r55+ED1vMUUclK9o0n83WKmTJooX7gBP7xWqT3VJoWP2I1ejrIw0SdmNC53+byZL/lpRLjBLrEBN1gJVoVoeJ3RWO7tt/f3aerhnw5b613kMLcoUP6DNJjxj/Mg4GcREm7yfFTHoIzUSpRg2r2KcHB0+v8+nMBcq5tbrWTg0Txh8bRcboPEVwZGIs3Fa6NuZjPOUtsitJ3lXH2GXwcvFpDzQl5aQO2CdDR+bF3b6fFlWFmPwov4tCbV1N80DWWGsMne3gIOvpzikNxoorvHP3VYCIHqYbK2pP6tcJgbmtBFf/9YbBGiu7SdxZuC2+FnkyKIWmgA4VJZZnTV3zYQiIVotoqKK
 f7W6si0C
 q9K7jVDMYc9Igrvvw0lq6X0FyE7Gq+duzGTTKaubK/lvs3JfOxClTVGOKA5HzUnZ4BVbBeGai/56DoMeJNSetKX3FORFyJJPnDaQiL8X64jDTmAhg9P5PF/XbGMd/McynLlAbQNdMxbSZxZYSKbNzmyPqAbyjzC/RBHA+KYLIjnJYHBQdW8ptV99/H7sk756qAduwGrsc5oNiJXU/qzOqZevJQSk5JazWcs7xMBjHr3GFElpXjMCgF+4w26EHjRGJubs17mhHswUpGV5OR3Ixhb5lDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Add a helper to reset a KHO serialized pointer to NULL, as a counterpart
to KHOSER_STORE_PTR().

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho/abi/kexec_handover.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 2f4fb9c639421..5fe9c5e10ac89 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -132,6 +132,11 @@
 		(dest).phys = virt_to_phys(v);    \
 	})
 
+#define KHOSER_CLEAR_PTR(dest)			\
+	({					\
+		(dest).phys = 0;		\
+	})
+
 /* Loads the stored physical address back to a pointer. */
 #define KHOSER_LOAD_PTR(src)						\
 	({                                                                   \
-- 
2.56.0.611.g1030f0b940-goog


