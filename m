Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A88B0C5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 10:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FA96B008A; Fri, 31 Jul 2026 06:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE01B6B008C; Fri, 31 Jul 2026 06:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6896B0092; Fri, 31 Jul 2026 06:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A07196B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:13:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C13A1403A3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:13:48 +0000 (UTC)
X-FDA: 85048660536.26.E36A0AC
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 081694000A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:13:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=MYYIYtx2;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785492827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xv27c0/vD/Df/b4Y/cIi4N2Epf5NFx+e9qZ5FbCg3WY=;
	b=jgojkOK3L4uZTh9gix+X9UJgRph0Wljry/qBEe9wPSHlo0IHGVUM2tVfGvNGZ2SVhuPaXF
	FLNNt73O089GVtEnCVJGo1W/lEe6B4TFI71NEBeXwYqGfvNj1txmweTB2MDhvKVS6UQVSq
	c7Eb+tIvASeDGvHG4AS6b5p01B5OzWg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785492827;
	b=EIJfv969P3boLM6iL64bdT3uD/jl/XnnmAu7VJcj/pdFBYOZaWlYIlEre81yYsNsTNGL7S
	+bFSWO6yNrfgALeowxTD5PmdngD/lRQcgFDA3o9/cYXIELjpNZrgEeBNtPPOhBnCrIUYFF
	LZ5NHu1GMxKWCYhvkfcC6wuwmux1640=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=MYYIYtx2;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=xv27c0/vD/Df/b4Y/cIi4N2Epf5NFx+e9qZ5FbCg3WY=; b=MYYIYtx25XZoY10teoNoDLot/E
	Gl9sbTwyvUQ6S0g5EIbUCl+mr6lZVAfMUoeka7/OYi6q25930ikXJMu4itu6NyBTiSfjit93Hv3xm
	rzBoWiFMrELqo/27L1V0wCEQ8Go7WUjnhMQ1I5ow6p9jWnT33J1Z8tbXfjYKCovV3UVt7ayuN7ilz
	lZIe5uH+WaOOXwoUcJhDOqkfklhFMi+bHhhvAL/fXfFa2MfRBONhcEXgH/6hGcq7n76ik3ZTFAGBi
	PlViSh1cEXzz6f7rWorRnvX9mKWcX54xMDD2E9gkM3hvm0cljVTFVF7f/cf0sVJTwhwTg04HZO/83
	TJxDTG6Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpkF3-009wAq-1P;
	Fri, 31 Jul 2026 10:13:26 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/3] mm: kmemleak: default min_unref_scans to 2 for
 verbose kernels
Date: Fri, 31 Jul 2026 03:13:03 -0700
Message-Id: <20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC91bGoC/33NQQ7CIBBA0auQWRczQKumK+9hGgMyLZNaMGAaT
 cPdjT2A2794f4NCmalALzbItHLhFKEXuhFwDzZOJNlDL0CjPuLJoJwXWh5k51uw2VMkL+mMXau
 9Up0eoRHwzDTyezevQyMgcHml/NkXq/rVf9qqpJIOnUY0xrXOXTw5tvGQ8gRDrfULAi/+m7MAA
 AA=
X-Change-ID: 20260730-kmemleak_hardened-e80542d1152f
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, workflows@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2742; i=leitao@debian.org;
 h=from:subject:message-id; bh=rI4kD2TwEQlbmRB9Uvl6bgmy4k9IQvZx1edgQ1gLWsk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqbHVA+cxEjDiwoAAfP34NakpeN+bDGV7HTNug6
 phdzcYHNhOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCamx1QAAKCRA1o5Of/Hh3
 bQYmD/4vgOFaWo7gi6XQJHUDIJpkx64lWbF6oOsiz9aXuHUj0eWlHY247RHDUkkSrHA4RPLHVwB
 8yOO0FqFxl9Aq61ahvmzNu/e3ydpOdB6PEIDDZnaRs7/IWiBZwBMVMnkza+NG6nLTN1D08UtFGE
 aZax4IGjtqWLmhQiCAj7Ti3C4OQn8xiPx8UVTBKVAgjOobr0Lf0pl+RKsSufunk48xYzQFWIFGe
 uwen6kuEq3dxgmeZaAW9adl0kYVyWSzkKhyxSOuRIdGEjQ1GdVAglQFhB6OmiX0UHHSjUr5xe82
 DJROxYxZKkXo+HZZwLNcEl34OXGrEU8VsfSGIwx3DqLjAm/QRYtQOJipkp+iAWdLyxh2upoKet6
 athzJlL1Fylw3WccUK2kZESu679j2EfpoCPsRvrFhVg8zDI/m0r9xWudsexomB8xzV8ObizDDhI
 rAia3+qMrvxtxwmOgy9uPrgMRZ3ZZlIvToQuUhxR19cfp9w0fBj2O3GEOB5/b65UDpzc8RJgfRz
 L7YMWzcbKB4C4bi+ggAqJZdxRl+NPW+S03Fx6NiNsGkOxADK+LJ8ltxhDeRm27n3FGKDKMjUQtf
 MvrNmhaddv5FZgpP5sKdMT8Yg4lCjIH2ImUDAA3VbAho2JBRwEyS/3RS8++ivDA/UbEkCjn6fcB
 DkbErejp9H9e2Ww==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 081694000A
X-Stat-Signature: ijupqntpryicqmxj4sq6merq66mothac
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785492826-722028
X-HE-Meta: U2FsdGVkX1+iSbuUsn0K0b3sn989Wfac/zOm5yEPKcRfFK9PEHkyths0woTQ7diLs9A9t6jAo/WSIYGr8fwCKe02JRprG7BpgTPlizmsKE4x70dJmUX51vSCGbCiFpj8oPyg/RSxIPAMzXMd0JBvokGfbw11QYhvcH+mzsvLq4YoLdeIp5OpVTdLhCHp718i5iJDXcCY3rwnmyyMuNwXw6dUNsySnzgTWsKlF7XQ0DA0ug4pktpbmF3HcznOGloQXtxwNI4YZy4F+5Av6Uq0fuMWKlpB6jwwjIUeaH80T++1frqDa37v9MsvxZi53P7DusyPvt/4qcoKvIWDIo0k7madQgp0LzFZMI9hj+0ftPVPjWJfXdxTt8++Ml7OCCMNMIGl65ANf5ENW9CUWkoLcAl7UIzQVo6TYrvGVTiLNh45qJK94TQl2RipAe8M+boOXhAtS0cEr7v7v+7tBp4y7BV1tbuPeH2+YTAZUr6JF6So8yntPhvvGJyJmcJc9L2HDpvNHdzOooLR557ztmFR4ejdjCruRz+GkPBQM1A09DKcV11k19G7TiHDNYqYEvErgdg5KN3Fs9gZky3oFECNTixKwH8zGxvYro0ujySI1g6yVIOpLm6Pn0GvVoMzW1DClNvY0C99J4aK9tRs2fsPjhMkCg+OFyetQtvpxmE6JNUTERdGzxFFr9oH0ZrjkfpTMlUSaoHX1B3SpyCOQeL0EkH6dMHqQyQxhyVH1V+4fX3hCED7ZCAO22WkxMr0a+iRFkgR1HV0YxEy+KjGXdK8+s53tFTIKyPXd5CQ6S0Z6tRkN0WjxHKv7BhBCBya6l0Vi/RVb2GQl20tfZtkbEbay3rEbLUagQt+TMcfxtLqpX2oCHH1VW4wFYwzGjZpTrlefL6R6ioWGKJzlMBvl9pm9HfuB8G1oB2NFBkW6a+hCak6H7AKobiSE3KEWqwVVOqPvbjjfyeMr1eRu1BTMHS
 JxWk3v55
 bHxS9S7XNQxyh2D4ZBaGKsmK9d6LEybSkteRCKRfL4OzRYYAR79BsFUGRDn0psT6A9xToJFzi0yf720ucisFMH/zv+ItC/CjZ4dVGFiBRf6l6YiXcgP7RdWcPnDJiZ3kEnPOPLjRtwsIgWwCxpcfwddAWvcBNQ2w/k3ZRiKEQRvlp/ZZHgiMAjutB7DcKdcp2vdUIKSXUKAeaLMb8ustjFjl+IWYmpTJh9nRihy4yPky6JYg47GWG605pJ4/frPlhFhclHjpbqoFdqjt9Cr2j7IZg+BIsU+FfEkIk6xMtNVFv8A65zpOOnMYbP6s6LcLgFSrwfe3MgUvbz0gu5C6rOGcLGrhOP8skY04E4nTRK1+FGKjlYrMokJ1t3sVWlz5iMzuP/ywfnuh8r77Q9YblFzN1jZTu1URtPTWiroWNNm+BbR1z6JF9Y3JFmyguMYJ7QMgAdO5Y3vRDou/lt4BXOc+Rcqb959WEEhX7IjhHS0ALMBEfV+dHBduGawvxI90g+Ll3jM5RlVw+3KMllh3xdgNWnwe6czCJ9lmDzqdKimPiBJGppzWQHT6YG3SRxEtl72IL4V/j9nxhmbDy2HYVccuD/obz/wCqHg/QFIc72MlAA9wU4Z/TD/5ebDwcv/lRDgdyie1NcTUIh2mSbaD1ikoWP79us3i+LfLV735G5Z9jfnaz6uB6/FIojokoAOxBepFEHf+rdE/rjw46uBn4S4x6Jgl0dAosoHyF4CBGJ6+8B6T/FLN74+5hMk5XPQyYBxunWMrD4tZ8ANe77W6Q+EZQz+LCLl4bJWN9EKX5f6u6xFQgKe9lwHaMmiCf8ioibYXKIWiV6T53iSUeobuPeqUA5h6WdzHUl7uBhJ9GTf1fwevaRgcIsUuJDIg7UpZAwpPE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DEBUG_KMEMLEAK_VERBOSE is set, which means the host is in
auto scan mode, set min_unref_scans to 2, avoiding false positives.

CONFIG_DEBUG_KMEMLEAK_VERBOSE depends on CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN,
so a kernel built with it already runs the scan thread periodically and
the user has asked for detailed leak reports.

The confirming second scan comes for free there, so default
min_unref_scans to 2 in that case and keep it at 1 everywhere else.
CONFIG_DEBUG_KMEMLEAK_VERBOSE defaults to n, so nothing changes for
kernels that do not opt in.

The other two patches bring the documentation and the selftest comments
in line with the new conditional default.

PS: A similar patch (v1 of this patchset) is applied to Meta's kernel,
in real production hosts.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- Test only CONFIG_DEBUG_KMEMLEAK_VERBOSE, which already depends on
  CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN; the #if block becomes a plain
  IS_ENABLED() initializer
- Note in the changelog that CONFIG_DEBUG_KMEMLEAK_VERBOSE defaults to n
- New patch: update Documentation/dev-tools/kmemleak.rst, which still
  documented the default as unconditionally 1
- New patch: drop the stale "default" wording from the
  ksft_kmemleak_confirm.sh comments
- Link to v1: https://patch.msgid.link/20260730-kmemleak_hardened-v1-1-b0b20033b4bb@debian.org

To: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: workflows@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org

---
Breno Leitao (3):
      mm: kmemleak: default min_unref_scans to 2 for verbose auto-scan
      Documentation: kmemleak: document the conditional min_unref_scans default
      selftests/mm: kmemleak: drop stale min_unref_scans default from comments

 Documentation/dev-tools/kmemleak.rst                | 12 +++++++-----
 mm/kmemleak.c                                       |  3 ++-
 tools/testing/selftests/mm/ksft_kmemleak_confirm.sh | 10 ++++------
 3 files changed, 13 insertions(+), 12 deletions(-)
---
base-commit: 78bc8af4affb9a732504eb22eeac7d1e50883853
change-id: 20260730-kmemleak_hardened-e80542d1152f

Best regards,
--  
Breno Leitao <leitao@debian.org>


