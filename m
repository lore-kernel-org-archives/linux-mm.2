Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB630C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9099E6B008A; Wed,  9 Sep 2026 11:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E12D6B0093; Wed,  9 Sep 2026 11:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7306B0095; Wed,  9 Sep 2026 11:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC1B6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:23:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29961A0278
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:23:44 +0000 (UTC)
X-FDA: 85194593568.13.E8F9836
Received: from mail-yx2-f6.google.com (mail-yx2-f6.google.com [74.125.224.134])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2ADFB1A0009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:23:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TUxjsDBB;
	spf=pass (imf19.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.224.134 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788967422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkLeKWnz40CVRXvuK4QAI4eUopbSKa1rB037g2lRL3w=;
	b=1jbAL4YnCqDE4N0I7yUx0Angj21st41HA+HP2cxA5M4Ff84J+U5ez9W2r6fTfCz7cjuDCD
	rjZ4LLcq4vm8HfvuAksNwkc39BqIDd7InmCWyzgz+yR6bP0si3pp7GCf6pYQs+bdk60hmD
	T4Ucjf/GJtl9PZda6wYa9yCiB1re06U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788967422;
	b=PiUvOPav3LaARG59jbRZZVGWy/84WmgZq/gIRphFYXkDM8qYdjB4ul1gChCyDOAfQgo3BK
	zg4B8bTQFOthoPxCtWa+he+G8K9SiVccqw1cjIAV7yVxdwuGJ0q7vfdLZKjkiS/eljNnAz
	lv5o/DZJtMOCi4KCi76V+k4aJO8ZqGk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TUxjsDBB;
	spf=pass (imf19.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.224.134 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f6.google.com with SMTP id 956f58d0204a3-66d22ff32abso2329985d50.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 08:23:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788967421; cv=none;
        d=google.com; s=arc-20260327;
        b=K4IzHw5UhtLuHZ2Ywq7JMKvC9gLYzrJBECN6lfgz675Wu58z29dBPKteqGbcU+EGja
         JcbJ+18nZ5wcQ5TodhPezoR8HcWwtNNcfChB448VKz3zRNWwE6cx41s51ZJEJsB/bDng
         Ck6gzEbo7U2IR2aNy9eLwWUWH0MKzUq4RUxl4xVK3mOvSKC5BINYtj+pU0XQ5LjTUaDq
         e2TMUxgTimKUFWLXybMsaU2I/pgvuwaKTt4nV3RGIvuJN6ZJc9rp/fsKzQsqN77bqNvS
         FGLj2VaPm5gj7i40SI9Cc/FJjQEEwuWDvOWFaCBPFVqYCPpUN82S3eek9cplOV3r6GPC
         d2qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=KkLeKWnz40CVRXvuK4QAI4eUopbSKa1rB037g2lRL3w=;
        fh=kQkgBMaAeByqeqeeBdG1b50g5mN4l7lCedUBQCfH7kM=;
        b=HKgc/I8iFz3zIbsfmuaQO8LlMCzo9rjWEiZ117Ng7RIxzxX6yyCgD/KliCXk6EdLyr
         DZ9KDjQ6sJ07jJ/QaZhJNlLh0MKt2i7wJprzBXlxOkYM6jAhp0jlrBrPY4eIw72UT9Ay
         MaGaZTH8zgJq1Zo6EEgFk37WesQoLXq3aSteXreUG3nhtDbGAfepwta+xVY6I5iQhrt2
         Mga4iOkl+4Hxq6eq2PBWccciRGSsHWbZT/VEsDOGN/cFc3NFBVkMupFyaii1rE0d9u8b
         bg0qDMk35A18XCk3lIwjJ+8y+103P4xhFBPvGnyVKs3KBMbsjC8RvwAS/xXSWydlNj2q
         ijyg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788967421; x=1789572221; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KkLeKWnz40CVRXvuK4QAI4eUopbSKa1rB037g2lRL3w=;
        b=TUxjsDBB07filnwHbAfxpYG3miqsRgL45e0dMTZ3R/sH0NBSyB+CCpq2/vWJ/TBeV/
         Yxx0eCbHn2PIfIpBjFBXQHls3/fd5ZWHlB7AFqmL+5pn1QOe4py68jXDdd1SuvQeIxW2
         1DJrZFc3yHppx9egZZDU3N+8UFSnRmryEBi4lmSt4QJ6tR4aTAFNIKos4dzXrTqAWaOm
         QlTA5cHP7H4+27YU+eg5oQ9c6XC/F5hDUR+dQAMPwyqrDB58ZcADOOuXK6Oxg7M4PWqq
         ksdePquECkCysxAt/wnVNGbQu+j9oM65c7t5es/t0X2j86KPI1/oPeDnc1dGBnwwpH3I
         1lwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788967421; x=1789572221;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KkLeKWnz40CVRXvuK4QAI4eUopbSKa1rB037g2lRL3w=;
        b=ilrvPgZDNQq5AUHyCRW0+V8+tBwKCBJEHrsUjpwcbJmQm3lHaYUlxcxVXEBjBdi98a
         RKo80kXadtXZbiPa8IheUSRF8V1oVz3BA91RW3/51fm4j88WAVcSfZMxTsSSL0lCvvjn
         vLX8VyJiM2GIR5JRb59bpD/Tj4PLfxUUgXbA2gMlKOnMq2qD0v8Rd7pHcwQW90yALW1f
         PsFPRTzMFyWKCXni3GVqhmxyYD7Q/qM11tgvfgVJXU9MFPwcyvF9yzamEG6n2ly1/uDd
         4h+eGcZcUzexeRWuiPU0WSDGLZMTw0lfMfsiLA17de75u/hRjgJGrtBQNTT5ir8uaV2/
         P7jQ==
X-Forwarded-Encrypted: i=1; AKwUvBwKoovwnOWmqWmcO1gLBzyk+JT4RoAeVn2B7I8MAZdPZx0r2p40Xhq6FnIQaTsZdRMI4hhKRUZSHg==@kvack.org
X-Gm-Message-State: AFuF++m27M8/3ZJlX0GOMqWYlHFwy7901ld7tRO54FLFhyk/BSnHkxqt
	gKjYse47InIPM7TcCHn69nZ1pNNu1vtp3U3u0+8mg7neSK70PYhDArN7W9nBp0sTFM/LjwQUbEA
	OUryFrRpHZoZMmHSm3bZbDE/3dSGo0ro=
X-Gm-Gg: AYBFou2prMOCunEZk4LZ9QrRmj5a27mm4J7Lp+jdMDzHJzLXzLNvw3GczetawNtence
	SvYtQqn4fDyFSaHjJY0+ko5bxWJncmleOLi7HVFTCVg6U0eXWCXIjmU7w5vb2fA8oWTW4goaPoy
	dZwCGsiMDyTmGOHOH7OOC36QNaLSx3aoZfE8tctCGOneysl92XOxgDuJt3KRJaqd+4JyJqd2rar
	Y2VdBwMxcOQBQ+erj0QeMzRvaY6dKZO69/ir9s89X77g2th+SWkxsULSn8tpzl1x0WPCOaN3DA1
	Yq88QUeBV4EbVkNSu8MVsY9DLVtibnifL+2ITOTNpZDW6uKgJpOWVw==
X-Received: by 2002:a05:690e:4809:b0:66f:c1be:a641 with SMTP id
 956f58d0204a3-66fc1beb247mr6374583d50.51.1788967421093; Wed, 09 Sep 2026
 08:23:41 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 08:23:39 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 08:23:39 -0700
MIME-Version: 1.0
From: Tianyi Chen <diannaaav@gmail.com>
In-Reply-To: <CACGbirTvSoSeNSpMCBiifTdRKKDsKbgk7nfvh=09fHw2b0M4Ew@mail.gmail.com>
References: <CACGbirTvSoSeNSpMCBiifTdRKKDsKbgk7nfvh=09fHw2b0M4Ew@mail.gmail.com>
Date: Wed, 9 Sep 2026 08:23:39 -0700
X-Gm-Features: AcwNN1XqW6dUN8Vb7KE_XG5Wlgt0dfTuo8v3RlFz25qPqa16OtVUGQTRkFzBqcc
Message-ID: <CACGbirSjNMD1mijDWRp4gLcw-6dJsErrF_jgjwr3nO-geBb1Sw@mail.gmail.com>
Subject: [PATCH RESEND v3 1/2] selftests/mm: Reject invalid test selections
 before running tests
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>, 
	Tianyi Chen <diannaaav@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000a66c78065b0e6fc8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2ADFB1A0009
X-Stat-Signature: migre33dj383w8e65igsa4e7b4c161tc
X-Rspam-User: 
X-HE-Tag: 1788967422-205605
X-HE-Meta: U2FsdGVkX1+vxD97vaX2DtN3NC3KIQsFtBTL9mSkA9zCZ47yRdidaw8bfT3VwAPg7poanButPPiDpmxmKRUojQV+RjxvXHfwiSvTG0QZTIQLp5BK3WmlhYYfQiLcCT8QWrITzC6GpoYG3yFh1+t9gKBFNNl1JB+WiahudJu4Ujref8GXhT6SqBNF2OKve2BknbfLR5lwUaSX4PxOC80iprZHTstWkxh1NOJ3z89jRuuqupWq+BDmRvD0b/J+iZKtCI/zHWrtCWtggGpHzcw8ebgLrIdxuVcvms4pL3fsajHMqNsl5uKHKohpduNTH5pZnduMC5OFNSEfHte/hONcPSptY2UdZTecmZm9S6B7rQzSzQO3Aqx+ZcXDkDUignEvJ1MLzzxxJNZfq6vPUE4qMs36FMfBlpMSmJRDi+gJNrx+7V8iFAuUXoWbiML6p8PCteDVqdXQr2jCYn43fYDOxs670Bs2Ndr56w18jDO89V1Mprnf92OC0Wa1xKwv4D/TE83NvTz3RWVs+U1FwUnCgSwDSACPwmg4P4QA8BuANO8LkclBuNl+w+NXmCCNKKlyqqEjzjTNAPJZj4B5NF7qMmOt2vmo5IHM8kC0luJLIWMKvupIYsub4znpoQDPHudzj1H4Pqa61MNDf6pXbGtQ/eKxk45ayHLhD3PGWb5UULTArjEE0soygQNLCMZq/yh+jM2sbMmuZCP0XTuCJyhkkVJaeib1yVbNNJIBRBm/por0ITBG4CySUbyvlY+9UQM39SlV1tr1MKvIfVXI15J0tRf5ecfWAHsP/ILKHqB2blb+GEAsfhbSz4zS/wgG2+GRv8DQJXEpad7JHQ7+PPek8Y7hgAccEsF1Wshep+fOFEwkwZ9Uai8rWBB7F/UXVb4D7DhZt1OqJTiFJJ7NLGmkGTys585ThCl+kyyIfqBJzwKzLShw6R/DwBlmT0MjpT0MxoH2i9FRHADowuoERKc
 9AVDvv0r
 FADyL996foNzBJs07HwyZifm/JFPG5mb/XzYSRfl73p9To7vHRxMXYVM2WjXOCF2U2DU75ZBNYRBicvJ8Cl/8o+IomtR2dlDbICbW4Xl/05QhVIVfLcqyyN/UJRb+6LU7OWpouxjEXr2tKEmiG26krmwef490FdzA8nMGH2US5E9dWhTOEXM2VRUuGY5fUuNYZFKoVoz86V8q0JGyu4AqkkPVvPsSNLVnS+YstGQ/U99yacV6Dz5aZc9RQImpFGnVNla20LcO/6czjhpQKnOyqrHv7hmKGeJXGpfY67vkkiGdgvuYCvv0MfxoW3Ktu9fsetAU+1PasWk3eu+C+HrPKB5fMc/UhezpMF7dbSPsCHHRw6GfFuf28AelgBoSnYXxV9Hx3wqmUNaYTJ2TNSCUI1ixsNZ8/TgRkrcWFgmRGI/DvgETRuF8LCojPltEqkfHRJB/LfWsP9A6XZ+WAaoa3aqTkAicinOxcBkilj1icW6YXzdxfrNktC8sMMrndUdwJjJxELs/1F6FPoSQxfLUN0ON2lEKYF0VvG8JcumJkZAPzc3t7vbQHSZ0y6ruSmvKl3tRL6U0XPOcmSlBFo2BoLWxTgJF8LPZN/zHHd4BhSX/+oosvwo2KAOQ+ZsjjR71fMrwHvTNaLs61blsdnfUv1h7zKzdY5zXbOepW1sKlH5qsZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000a66c78065b0e6fc8
Content-Type: text/plain; charset="UTF-8"

The unchanged patch is attached as text/plain to preserve long lines
and whitespace during mail delivery.

--000000000000a66c78065b0e6fc8
Content-Type: text/plain; charset="us-ascii"; name="mm_patch1.patch"
Content-Disposition: attachment; filename="mm_patch1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: 62a76dec474c2618_0.1

RnJvbTogVGlhbnlpIENoZW4gPGhpQHR5Y2hlbi5jYz4KRGF0ZTogVHVlLCAwOCBTZXAgMjAyNiAx
MToyMToyMSArMDgwMAoKZ2V0b3B0cyByZXBvcnRzIHVua25vd24gb3B0aW9ucyBhbmQgbWlzc2lu
ZyBhcmd1bWVudHMsIGJ1dCBydW5fdm10ZXN0cy5zaAppZ25vcmVzIGl0cyBlcnJvciByZXN1bHQg
YW5kIGNvbnRpbnVlcyB3aXRoIHRlc3Qgc2V0dXAuIEFuIGVtcHR5IC10CmFyZ3VtZW50IGFsc28g
ZmFsbHMgYmFjayB0byB0aGUgZGVmYXVsdCBzZWxlY3Rpb24sIHdoaWxlIHVua25vd24gY2F0ZWdv
cnkKbmFtZXMgY2FuIHNpbGVudGx5IHNlbGVjdCBubyB0ZXN0cyBhbmQgc3RpbGwgcmVhY2ggc2V0
dXAgY29kZS4KCkV4aXQgb24gZ2V0b3B0cyBlcnJvcnMgYW5kIHZhbGlkYXRlIGNhdGVnb3J5IG5h
bWVzIGFnYWluc3QgdGhlIGV4aXN0aW5nCmxpc3QgaW4gdXNhZ2UoKSBiZWZvcmUgYW55IHRlc3Qg
c2V0dXAuIFJlamVjdCBlbXB0eSBhbmQgd2hpdGVzcGFjZS1vbmx5CnNlbGVjdGlvbnMsIGFuZCBu
b3JtYWxpemUgY2F0ZWdvcnkgc2VwYXJhdG9ycyBzbyB2YWxpZGF0aW9uIGFuZCBleGVjdXRpb24K
YWdyZWUuIEluaXRpYWxpemUgdGhlIGRlZmF1bHQgc2VsZWN0aW9uIGJlZm9yZSBwYXJzaW5nIG9w
dGlvbnMgc28gb25seSAtdApjaGFuZ2VzIHRoZSBzZWxlY3Rpb24uCgpGaXhlczogODU0NjMzMjFl
NzI2ICgic2VsZnRlc3RzL3ZtOiBlbmFibGUgcnVubmluZyBzZWxlY3QgZ3JvdXBzIG9mIHRlc3Rz
IikKQXNzaXN0ZWQtYnk6IExMTQpTaWduZWQtb2ZmLWJ5OiBUaWFueWkgQ2hlbiA8aGlAdHljaGVu
LmNjPgotLS0KIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL21tL3J1bl92bXRlc3RzLnNoIHwgMjYg
KysrKysrKysrKysrKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCsp
LCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL21t
L3J1bl92bXRlc3RzLnNoIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvbW0vcnVuX3ZtdGVzdHMu
c2gKaW5kZXggZDA5ZjlmNmEzODRlLi45ZTYyYWI0YzY3NzUgMTAwNzU1Ci0tLSBhL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL21tL3J1bl92bXRlc3RzLnNoCisrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL21tL3J1bl92bXRlc3RzLnNoCkBAIC05NiwyNiArOTYsNDQgQEAgc2VwYXJhdGVkIGJ5
IHNwYWNlczoKIAogZXhhbXBsZTogLi9ydW5fdm10ZXN0cy5zaCAtdCAiaG1tIG1tYXAga3NtIgog
RU9GCi0JZXhpdCAwCiB9CiAKIFJVTl9BTEw9ZmFsc2UKIFJVTl9ERVNUUlVDVElWRT1mYWxzZQog
VEFQX1BSRUZJWD0iIyAiCiAKK1ZNX1NFTEZURVNUX0lURU1TPSJkZWZhdWx0IgorCiB3aGlsZSBn
ZXRvcHRzICJhaHQ6bmQiIE9QVDsgZG8KIAljYXNlICR7T1BUfSBpbgogCQkiYSIpIFJVTl9BTEw9
dHJ1ZSA7OwotCQkiaCIpIHVzYWdlIDs7CisJCSJoIikgdXNhZ2U7IGV4aXQgMCA7OwogCQkidCIp
IFZNX1NFTEZURVNUX0lURU1TPSR7T1BUQVJHfSA7OwogCQkibiIpIFRBUF9QUkVGSVg9IDs7CiAJ
CSJkIikgUlVOX0RFU1RSVUNUSVZFPXRydWUgOzsKKwkJIj8iKSBleGl0IDEgOzsKIAllc2FjCiBk
b25lCiBzaGlmdCAkKChPUFRJTkQgLTEpKQogCi0jIGRlZmF1bHQgYmVoYXZpb3I6IHJ1biBhbGwg
dGVzdHMKLVZNX1NFTEZURVNUX0lURU1TPSR7Vk1fU0VMRlRFU1RfSVRFTVM6LWRlZmF1bHR9Cisj
IE5vcm1hbGl6ZSB3aGl0ZXNwYWNlIHNvIHZhbGlkYXRpb24gYW5kIHRlc3Rfc2VsZWN0ZWQoKSB1
c2UgdGhlIHNhbWUgbmFtZXMuCityZWFkIC1yIC1hIHNlbGVjdGVkX2NhdGVnb3JpZXMgPDw8ICIk
e1ZNX1NFTEZURVNUX0lURU1TLy8kJ1xuJy8gfSIKK1ZNX1NFTEZURVNUX0lURU1TPSIke3NlbGVj
dGVkX2NhdGVnb3JpZXNbKl19IgoraWYgWyAteiAiJFZNX1NFTEZURVNUX0lURU1TIiBdOyB0aGVu
CisJZWNobyAiTm8gdGVzdCBjYXRlZ29yaWVzIHNwZWNpZmllZCIgPiYyCisJZXhpdCAxCitmaQor
CitpZiBbICIkVk1fU0VMRlRFU1RfSVRFTVMiICE9ICJkZWZhdWx0IiBdOyB0aGVuCisJIyBLZWVw
IHRoZSBkb2N1bWVudGVkIGNhdGVnb3J5IGxpc3QgYXMgdGhlIHNvdXJjZSBvZiB2YWxpZCBuYW1l
cy4KKwl2YWxpZF9jYXRlZ29yaWVzPSQodXNhZ2UgfCBzZWQgLW4gJ3MvXi0gLy9wJykKKwlmb3Ig
Y2F0ZWdvcnkgaW4gIiR7c2VsZWN0ZWRfY2F0ZWdvcmllc1tAXX0iOyBkbworCQlpZiAhIGdyZXAg
LUZ4cSAtLSAiJGNhdGVnb3J5IiA8PDwgIiR2YWxpZF9jYXRlZ29yaWVzIjsgdGhlbgorCQkJZWNo
byAiVW5rbm93biB0ZXN0IGNhdGVnb3J5OiAkY2F0ZWdvcnkiID4mMgorCQkJZXhpdCAxCisJCWZp
CisJZG9uZQorZmkKIAogdGVzdF9zZWxlY3RlZCgpIHsKIAlpZiBbICIkVk1fU0VMRlRFU1RfSVRF
TVMiID09ICJkZWZhdWx0IiBdOyB0aGVuCg==
--000000000000a66c78065b0e6fc8--

