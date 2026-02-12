Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D78EB491C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074D26B0092; Thu, 12 Feb 2026 07:50:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049A66B0093; Thu, 12 Feb 2026 07:50:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1EC6B0095; Thu, 12 Feb 2026 07:50:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCE7D6B0092
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:50:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94938160156
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:50:03 +0000 (UTC)
X-FDA: 84435787086.16.8F748A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id A3AEA140007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:50:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LY42j0s8;
	spf=pass (imf09.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770900601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/FMz5x4DmdZtabmz3VNxJ7E7VlcqQfXAznqr1KFH7q0=;
	b=s4r8ehJtsNyW0tYJ8FgBEMvnsw/yPP5WDEhf8OTFW47DtDpKQjziq30+jJhu4wKVyUbBHK
	XDMBy8fjNFzhBG1GXDUqcRE/fxmkd1j/nyi8A7s87EoGhOhIvgeG5Vry00LRd96/JkFf7B
	434FgYxtov2E5QWaElrCjOJGuoM8KKA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LY42j0s8;
	spf=pass (imf09.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770900601; a=rsa-sha256;
	cv=none;
	b=iXWeO++AYeXcB4m4MnK27eMzXrKo7GCeHsBZ6Zf6RA6VV0cegB3QdoNoLA3KBW9EOHsIDC
	WWgPq7EPhDZKA3Juk4C93hEB39H9HAsE5T0MMd9F5Ls9aYk6mqHdgElyFiq5ftgizsPdFL
	Sq5Eh8/1AUG8U1HF6GgoquVLXImCbsw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770900601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/FMz5x4DmdZtabmz3VNxJ7E7VlcqQfXAznqr1KFH7q0=;
	b=LY42j0s8vGtlOAUE+zfokKYCOUyOJu+a7ByL93q5BKU1cR5VS8YJmyz1iNlp2RHJp9QQ7j
	5SxCaDkwgY03uRwa7P7jzcWK26VJzp4gKr+rRGBUt/3Bv4nbQNuJX/SKzv26FP1AFsHqq4
	+4m1FFisqf+OR2e08uyOpxc/k5+1Yw4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-wNNyPXEiNCqNcE7X1lGA4w-1; Thu,
 12 Feb 2026 07:49:57 -0500
X-MC-Unique: wNNyPXEiNCqNcE7X1lGA4w-1
X-Mimecast-MFC-AGG-ID: wNNyPXEiNCqNcE7X1lGA4w_1770900595
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60EE0195605A;
	Thu, 12 Feb 2026 12:49:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.22.11])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE2D030001B9;
	Thu, 12 Feb 2026 12:49:49 +0000 (UTC)
From: Gabriele Paoloni <gpaoloni@redhat.com>
To: corbet@lwn.net,
	skhan@linuxfoundation.org,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	brendan.higgins@linux.dev,
	raemoar63@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com
Cc: acarminati@nvidia.com,
	linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech,
	kstewart@linuxfoundation.org,
	chuckwolber@gmail.com,
	gpaoloni@redhat.com,
	Alessandro Carminati <acarmina@redhat.com>
Subject: [RFC PATCH v3 3/6] kunit: add visibility helpers for static inline functions
Date: Thu, 12 Feb 2026 13:49:20 +0100
Message-ID: <20260212124923.222484-4-gpaoloni@redhat.com>
In-Reply-To: <20260212124923.222484-1-gpaoloni@redhat.com>
References: <20260212124923.222484-1-gpaoloni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: kWtYPQNCs3WxylNQQbvN1N9Crl3NbucBWwR9wOI0i20_1770900595
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Stat-Signature: r4fmo3pd86ftcxx51phg3dk57fw6gjbs
X-Rspamd-Queue-Id: A3AEA140007
X-Rspam-User: 
X-HE-Tag: 1770900601-509027
X-HE-Meta: U2FsdGVkX1/9TEwXm1FG50IuTa4TS0YVYp6vnnoLR7OnyaCj4RM9XnBe+c1bffcrwxN5OX5wwqqD1EHnSDKYXTiaD875LHyv/ZNE7lcZ7EF6hAZphUX3KYp2oK586oq9vr9O1GG8sgSI5LkTpCP0OLj3e3TgQlYC1oJE6Bls5KlmxHeDS1dOofhys21yUBWUivex1wukWndTzAo+N4hxWkX4W05/Es2kMEc9gqfBgXDCMdTnr5DMb13A8oGf3PnTzdfDEtFB32QnK5mXmYu0PcckWZhw1L5GMu2FrZFwC8XgzA7SBbnwajNTOuvCW/7YpZezy80bNr2i+w8k1/x09bTx1FhXsjCqvM18PTBIqCzKEM03R+jtd8KR6RmMzBISTf0bAuh59MIYgj7zEeaphFAlTFukk57SDdrX/05ZFNxrx9uTfOQPh+hoPBSmXRQr7DAbonef/54MixTvVCTJdTS5ArqqX07/rPvQ9O3tU2QPQ7QhX5QpOvLKOMz5HI9u9I1P76amzexs1F8lxN2RJZMBEGVYl5S0HPj3Wv2nUrhQG841XV4vWTwKrfT001QT5uwwQ2FMewdLMT+jfriHnpnkJSCKMF4sM+IVRLgltfOKTG06xoIvDay5joGPODpkM0xSQzSHS24iVHP6BifumRfaDZepCbeflgUv1NfTkQJQsAo+BYiIrBABjgzVGCS6P0EsUUEV8ryV7jXqvoz3VtEcJ4mJnTF/xX7HwPv+cFSinDdaU2XXlpUEMXPyJ174hB0+kjykUahVkzcKgagWTraHWyQMmxof/rr60Qf8fFZoIri1cp+NRscDC92aXittNIFh+7lH3AoaRYzhsJBc/BQ5G1lxuusg/v+9NEEDeC3x7eK4n4XXsvi5rF/xyPtaWtWfaCSQ60oVph1tU7OaX9KnHRe4nj5pWdCbUzyOwvi0oCWdLkRA8nUNs/wtRG/mdPwpfziI3K9vQ7L79I1
 P+kT48/f
 rQMrw+oCWJYYaTK5VlrInRKj+JhOc1l/ln7DFbLQ78jIwsNN1EmnzQDZSPz97gsMGnH2KEMdeMAzySAvpUidJAWz+VA1uaistDxKiv+KUkMNX5Q6sMv4HAAu0qe0317o+/LEn7vfyJXcopsVPKPBMQ9UgiL0QdlgFlvFfg2hQpQO1yKXfKJnEovf5kbFBCqZ2y9GTuhugCY+8xdEVqximfChdEBOuuU3rykP8eutCgWod3YTUqvGckbBtWMEnARnd7TwVqgX1ImggKpzRtOATSz81SOAswEmULa1TymHfePCwXoY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alessandro Carminati <acarmina@redhat.com>

Add KUnit visibility helpers for static inline functions so they can be
referenced by test code when KUnit is enabled.

This change does not alter behavior or expose new functionality at
runtime; it only provides a mechanism to override visibility for
testing purposes.

Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
---
 include/kunit/visibility.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/kunit/visibility.h b/include/kunit/visibility.h
index 7c34c8ffcf3b..82ab7fffc943 100644
--- a/include/kunit/visibility.h
+++ b/include/kunit/visibility.h
@@ -17,6 +17,7 @@
      * there is no change to the symbol definition.
      */
     #define VISIBLE_IF_KUNIT
+    #define INLINE_VISIBLE_IF_KUNIT
     /**
      * EXPORT_SYMBOL_IF_KUNIT(symbol) - Exports symbol into
      * EXPORTED_FOR_KUNIT_TESTING namespace only if CONFIG_KUNIT is
@@ -27,6 +28,7 @@
     #define EXPORT_SYMBOL_IF_KUNIT(symbol) EXPORT_SYMBOL_NS(symbol, "EXPORTED_FOR_KUNIT_TESTING")
 #else
     #define VISIBLE_IF_KUNIT static
+    #define INLINE_VISIBLE_IF_KUNIT static inline
     #define EXPORT_SYMBOL_IF_KUNIT(symbol)
 #endif
 
-- 
2.48.1


