Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9BFD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 18:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A316B009E; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3976B009F; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5642D6B00A1; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D56B6B009F
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:03:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE7431A05BE
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:14 +0000 (UTC)
X-FDA: 84345856308.29.688A94A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65CA31C0003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OP7NIgjK;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768759393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJdiJ9Qz6Z9GE3AqHdIrqQkpTZPyKe/vIgUg+UTE4Xs=;
	b=2/G3JwsDU/JaWay1m9me0BO3n9eDfrdH5TlAleZ//jizxKzeaDz80OQ6WBGRHwJN1j4fHA
	ZfJN0kM7iI2CdrO5Jj3GN6hBU/lrWMxVqBrjiWj1NbN4DDykUZvHlDuMzZPRLHJYH9FY+K
	8vBrzozAHrQG5TNzbagGAqsYy5iuv8o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OP7NIgjK;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768759393; a=rsa-sha256;
	cv=none;
	b=J1dK/Y2jHRPT+vPguU7T9bzxmPcPMtDVN2wPag06cj2P0eA3vJ9sYxWCABHzTidSPZf7VW
	xBz9uI6gdqmmj8DBf06lK28UTC0JNZjVnP+LsZTvcj6Sg4xUHQ0/wLGvyD9X6nKPzCtWeR
	rj2qtZDr8vc8e0nm5VICs70DF8DNWmU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CFAF60126;
	Sun, 18 Jan 2026 18:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148C0C2BC9E;
	Sun, 18 Jan 2026 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768759392;
	bh=I6FIvpCZnqc0+Nxtus5G/drPLTTVOCDnzupWLi+vC60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OP7NIgjKh+KigUkX5vwOsPfqukrM173PzOHmo+HcScObB99mbsPJy4/Q63zTPu+ul
	 UdGSUUGj4RRgbR8c16U+gYmMnboSaKZD/4RSgRZE2IvwVy+1WJCoEklePTi+2K+gxz
	 WGRcJPniDM3Or431A3vO7RsPETKXfKWzAHDlrx9zxLIhCavp9itljcAN7844OrRGGr
	 dHc2FQa9BFjhioAvYIYThHgwr0DIMVbS8Lnl3NPnI5aQfWfDt7SZBbnOgJNJkC4gsw
	 vZr/7yzJc2/weeb0LFWqRzMjGvi7hYxcnvazpZVO/uOrUsxRJ3wjDo+6/rn/z8h6yt
	 8sf2r77Cgk1bw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] Docs/mm/damon/design: link repology instead of Fedora package
Date: Sun, 18 Jan 2026 10:02:53 -0800
Message-ID: <20260118180305.70023-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260118180305.70023-1-sj@kernel.org>
References: <20260118180305.70023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 65CA31C0003
X-Stat-Signature: j6n9uk7tpo4joz6h8e1bwagm6d8hycfd
X-HE-Tag: 1768759393-394705
X-HE-Meta: U2FsdGVkX18LtxOd/Tj746NrLpzzQRWf2FDC+FybHQ7YVDRnyA7qIzV+kGTlkkhrcRQsHX2OMqZEpzaglzecXDHiEACYf2cfNoDDmpWHdQdELlMstINbF/kpnJdT+1RzPfKA+cHOmf2oJdBl7l7agwlYIUVfsaFQfI1Jui2gbCUci4miBKHpeUIdDWJ0dDCTy08krweJE2pA4djiq65OYyOfFyzpMubntHlVNa326W1tF8Hym9Dm/JiiUiDgkwODvnn7tx9T3g9OlwRYI/jbnZy7+eZHmop8EnKjh2fqmHJud9V5ge+ggM+kMI0O1mqCq4/jTI/4FTJLnJ1v0DcQMs80ZGluJIZt1ykJ2NfyKIPsKZ60sWnkCQ4tRzCrPM4u9N2GzSPL6czYCGYASv3fausaT8lXzr6i3Hgi7nvIjycQo7rmmQuaWq3uNqhh5ytoVqpS7rI5rXTz8RoineyqsHL6IDWCQ67LWD8iq2Iaw++nR58OrZAwGRYRyDvViceh8PguN9iTqHTRSoMuGVP0B2i7RpY1cdGDe4mwhG2c2e92bu1t9JjFAaqJwkopxGKT6I6P792NZnC9gRhmSLdBUQGSklMjo9FTOmxS9nWzMt3ws+WZOJxwbDg6orNQu3G4nDwb027o1BU8VxDsVVeFTX91dDsFV6HENsDS90Wn3sKCwnv5Y5EC7PQaojjKqTWY8ruPrnImVW3ReOwryGhc4tioOjRfPhcdI1JmW/8hFjbUhXLky/SQ7NiTtKmLLhOIMoHS3TSbmsWC6h71pUBDS8fJPBo8G/KQ4K8siEZo4k2oj7sjWK07YS2T3RHSGZH0/jUVqK7W/IChpqnSKysxu8/kqmz1WqZ+pI4fgwC3QCwXdPJiRD4zETIlJuftJ4+TmltCHF4eg6tPLRFAI5qUNJP4+h2kxPIZOUTNosO4EtBj5shXZ+ocSfe59LFSrcFUK+J+dmKx/zqPx20WOfY
 9wrPhkyV
 PnsCWg3Ga6D+cGJ74GorZTJpbNRm+1VLeLslWszM0vmko/xCUBOINubEjdG00LJPse8hsJPHNkfo49wOhUZEFIlNdLgHxI1/oiTLrNCgDJHu44UieIiORJu9D0fxvHFacg32rLZ/pBzL5RpNzSqzAguLFQaFHJvxACjwo6H2C9F87yXIszbVdU9M7y0E4fsanKyEf8DLKklaH/Jx1Zup4UaS/E1OqI/fsPmE5FJSeBZ4Li76XZ3UMXW4UK3e/oWgDwjw7v69R5frEjjd1BrZkLdmtO//naSdnGllDKmieDXKkUIPcg1kNd1Fv3jRb9y0+zTdfd7c6c1icGcSkWQ+HaFXk6cgeLP8Tp7lWf/sR4tbMzJAnf5bIdFHUV+ZRwPt6p1/1rEyHuiOTrio=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The document is introducing Fedora as one way to get DAMON user-space
tool (damo) from OS-providing packaging system.  Linux distros more than
Fedora are providing damo with their packaging systems, though.  Replace
the Fedora part with the repology.org page that shows damo packaging
status for multiple Linux distros.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 0cfd4c25e92d..f3db943d7efc 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -809,8 +809,8 @@ The ABIs are designed to be used for user space applications development,
 rather than human beings' fingers.  Human users are recommended to use such
 user space tools.  One such Python-written user space tool is available at
 Github (https://github.com/damonitor/damo), Pypi
-(https://pypistats.org/packages/damo), and Fedora
-(https://packages.fedoraproject.org/pkgs/python-damo/damo/).
+(https://pypistats.org/packages/damo), and multiple distros
+(https://repology.org/project/damo/versions).
 
 Currently, one module for this type, namely 'DAMON sysfs interface' is
 available.  Please refer to the ABI :ref:`doc <sysfs_interface>` for details of
-- 
2.47.3

