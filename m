Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C7BC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83BCC6B00F1; Mon, 21 Sep 2026 07:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8137B6B010D; Mon, 21 Sep 2026 07:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4916B010E; Mon, 21 Sep 2026 07:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4ACB76B00F1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA718140110
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:08 +0000 (UTC)
X-FDA: 85237477416.23.A4692E4
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2B27F20012
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=USCahjEq;
	spf=pass (imf03.hostedemail.com: domain of 3cQ6xagoKCK4jRcbbSTcfhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--vdonnefort.bounces.google.com designates 209.85.221.72 as permitted sender) smtp.mailfrom=3cQ6xagoKCK4jRcbbSTcfhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCrcI7igLaQUil9vBYjywYIs9hdqlrNEBSUMKWJIUV4=;
	b=X0kIqbMcy8TDE05eMfnppcI6uS5JRjRlUq8wLUw64IBDgEJRXnaII/m+6464eFwDXwT9r8
	o87cM/ZFzrehGkqsXmhyz1zJWFI+iubqyGxQhhPwbav9CkPpld/jtQLzFbaiG0Z7bPkQZI
	UQXYgZhjs41/xbfVmxFEFFZbsqE0eVU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=USCahjEq;
	spf=pass (imf03.hostedemail.com: domain of 3cQ6xagoKCK4jRcbbSTcfhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--vdonnefort.bounces.google.com designates 209.85.221.72 as permitted sender) smtp.mailfrom=3cQ6xagoKCK4jRcbbSTcfhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988467;
	b=z4jCGOrk2QtF3h79843YINdNVcm6MbAW+42vMX6DcFpbsLLzlwry5J7/41/VYwv3iS6hyi
	bheA92MlIhVzP/Aj0dm6KcW6lr2ZQ4JI9oduQnI5SWdEoejU50iFZMlw+mh1ZtezOFVIbW
	eKm4r35+SNBK6+dnVz6EYttxcbxKJCU=
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-486f768517dso1968306f8f.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789988466; x=1790593266; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oCrcI7igLaQUil9vBYjywYIs9hdqlrNEBSUMKWJIUV4=;
        b=USCahjEq8X3oLY1sqy8Om5l5+0A5xcfvh4otXWcrELcGGmXU+UJtW5Z0qVxQ9FpXW/
         tQEii6WYZBhihsIPe/zncElnjTSzarwF3iVXkZiqQ9Nx6vN0TObtvDY8ZYQqLEmYyBrU
         JPjJG4zfvCdFa97FjpsgUZ9n/+OsFtqEMaqDHr2aHsCmuU4Urhvt12fhIRI6TbWrmY0E
         pEC1zueWshRuHqwnwAMnqAzp6i/MWpNXMsr6ydqgtPKL/H1pwSP1kjpYY3UUE5b23AvQ
         0RANG10WlaQYdnpYGnTsa/wHcNSvawkHYlMBt8H+QXVaxcrATp02uNjTrzc7QfFatHyO
         AKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988466; x=1790593266;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oCrcI7igLaQUil9vBYjywYIs9hdqlrNEBSUMKWJIUV4=;
        b=ap2jpka6jXFpqIDhEu0GNjRzUKB1iQBuAh6+deiprpUFCooAPWnQMC7V+/4yUGA9Fs
         xzQCf6ms6LJ9zbewwrsHRkjNI3zKKsdT9kCd7F0gub9C55nKw/znx0+MYKuEHl0QdUQl
         fCB1YLdWToRNLM1fxTKYYmKvNzMSse7tihtrxorLlzYeAofiKl/L1ayWW+yZhrNJGAA2
         BTN5iQP9LX72BaJWZzAi/PnkD9xf7yGv+yCJsaFzGJVNrA9KmP1VrPfnAIowYZRo1xuy
         mdYKMEzYEJ4pAhikn0VE/0N0YYW7U4/uZj2rIj2IPLJVf8TwGC3suC3leUFbI06VTqU8
         rp2g==
X-Forwarded-Encrypted: i=1; AKwUvBxdg2f5Y/N+PxjwSWy5p/4+GSwNATB2WRYmWBqzcsX4jv619d4bQReKsoLNjLjyCChK0O94eLzsfg==@kvack.org
X-Gm-Message-State: AFuF++nWIrLCPPZ/xs3apTLKj4/f8JMblaavwIEBHDQD42eXQlH62aRm
	cflRw2mgiqV/FrT1px0Y/OAOyoKCXNPwVBHvG6fME067/jJ05FnRcgjJQNaWPamZhEP2NNj1p/K
	DfKiNCdgU/5FThvLaO/bODQ==
X-Received: from wrbeh15.prod.google.com ([2002:a05:6000:410f:b0:487:2514:733])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:290d:b0:487:27f9:829 with SMTP id ffacd0b85a97d-48727f90a8cmr8269596f8f.30.1789988465393;
 Mon, 21 Sep 2026 04:01:05 -0700 (PDT)
Date: Mon, 21 Sep 2026 12:00:50 +0100
In-Reply-To: <20260921110050.3977591-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260921110050.3977591-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921110050.3977591-9-vdonnefort@google.com>
Subject: [PATCH v2 8/8] dt-bindings: firmware: optee: Add memory-region property
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B27F20012
X-Stat-Signature: s3xsezwqabz6qq9b4d6gedi85top97id
X-Rspam-User: 
X-HE-Tag: 1789988467-247550
X-HE-Meta: U2FsdGVkX1/p1zbazAu4fv+LkeU3Dwr5BWgqR+CVqUiZorz7+aGV4leIRUX6jMnYX40kX4Rp8VG9b4dlBj8MRAVPmGaMX2kkARyfujiUo488B1xFQmn3eis5dn2aOP9rs4+6xk93tvZh5o15ZJTIi3rhjOGfyHkQ9YlyT831YqAL4OV7mHlew1aIL5fnXT7p1LcC0X/QEYVx0k351SJRnWBa2XoGijT+j1lxGeB0E9ouvBECVO1VlgRsVqw866lQgJdkIywkSg0t/e5jBGEHiKf7mrXHqsqZxwQ/Xufhw/bwr+TsQ7MAzitnIRNAOrAI0A4XE+mOIF30DjKAm80ygc1AUcqXeJ1cTdpnbkkwsBvrzgfAkhunf1IjtN+/bHOlX6UvOp5/4b0sdQ00VlfQqmfrKVHT45UNPTqy8hH8L6aUJ/IJmeWUKM56Lwbz8Oz9cliu+PSotsXwUphP95o65QkPWF4dTeZNDlgx8TCmr7k/Z/hFBGf8GX/Y2jZf83hWvdprBJoNxGFwV1R7bWGQgsRCib0ke3a3R4onR4lzKq/Dxy4qwO7WzDWTmXnXg6rqy3H7oBCXXXRVDDpHvof4wY5D9WLqCxJ21UcrO/KJDWqdCtOUTpBTi5qdEuehkeSXofk+sJxOzSA3AweJ4xZMwJgIwKaVSyfBIAhXR2c3q27aLBeiwCvv+Xk6L/LkEfD9NlagGH6+vgOzTOsD1b68sTZPdNIYRCgu1T5AXy+zyqiFG7gQlNLvtCWSspL+8kG+Z4szznCfB1PPMQpJ7o538KGdDpR7p55jZ+rWVlmLta5LAGFcUd/Vo/9YJrYA8VXWVj09ymbe6gaYPLdpM57831m07QjzkvjGgaCOGIztTsaa503foQ7yJkPskxtj6FbCgWZZ0fQsi1rUSA8Dci2wPWbTzN9VB74L8U6nYORfPLihEK6NDeBy/aE3eWLQUHiHYc7zTdwvMsDdjPLmqbE
 N/oWnpoD
 bLbEsbgS64jSrPYk83ntV7Lu/R50cC1PoqCy1kmdHXyHxBd0CZXO02Tmc/XkSjwReQk6u+LmQxh+JuTrRvcdwYqTuH90zM8Aie7VR65nJsN/N4WLQPKYCdvWHsEg8mpWXOrIBstpwE9K2ZU6LcYN3F2KzXjHNU3aFKYUzLP8YzqhVlPVucHfYTsVvR36PI2ZZs+l9IueWI8xgHDT9UxlAefW906cl2ihXlxSZ3S5qM4uv9VqjcSG0fvfwpB4WD5kEKseRsgji4OYP5ECAbWe82vvDyHRz9wky3hBAyKSLBcWG/mu+AXAx0oo/Q6u3eFfkgBVo/WqBCqzDyv0T7QtYAzvoF0/WNO0I3BG6d9qHk8V9CEBpdmk2fjceYvjIvW0V361j2X6Ywhke/PSbUlhRDIA+sZCmlWHixcsLPDVclJF3cLO7A+WQAZfI/ijONgaI0OnYK6+1hFm4t8hnOuqjboFbbNa2N9ZK8y4GhD58PyMp86BJTfdBeyTfd8SNCP8FFyIjjnxY8bsGAi028Iobppmw1aZ5QvxJbvdq84k+G7xGXKdIaJOR4s4cRldEsTXiQYBwKlPHLO8x03E5xrTGeb2eLCeGQnKrsUFozJ0JJxJCIoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow reserved-memory via memory-region to support the arm,ffa-lend-pool.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 .../devicetree/bindings/arm/firmware/linaro,optee-tz.yaml    | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml
index 26ebcf4565f3..7fddea9cfdbc 100644
--- a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml
+++ b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.yaml
@@ -41,6 +41,11 @@ properties:
       HVC #0, register assignments
       register assignments are specified in drivers/tee/optee/optee_smc.h
 
+  memory-region:
+    maxItems: 1
+    description: |
+      Phandle to a reserved-memory node for the OP-TEE lend pool.
+
 required:
   - compatible
   - method
-- 
2.55.0.1082.g2b9226bbc0-goog


