Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C614C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E5C6B00B3; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7E86B00B6; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284E56B00B3; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E973F6B00B3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 694CFA07AF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
X-FDA: 85034812632.30.A4659DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C692C18000F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nf+I80LA;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qlh6y9Au18vR1Ou/T5ICe3OGlXl5Nc84fCTR2Y+rZXM=;
	b=K3fbvpqCCmcOHKzGbrShEl/J94dnVr65+CIpVE2UlbDtvWLDMn9xKaYi36o7hdB2/wz99t
	3re2ZEShAPcoixOXeQNEAE329K4aQx/9tLnZ0ivUzxNpw85y6N0JLLaMZpukWXJAjDCRR2
	S3TrzF4oaoWNrD33t9kPdz4vBNfy7is=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163114;
	b=2IZ+Sr7JnPz/dk1B9TPBhGC2r5EnQ+MFM1MwB8kuwktH+rSwJwJKZpDIrUySNNnCuxNBwW
	nTF2RRjYaTL8/0T+0WGFVkwKUw1SEpJMdtsrjsb2uDnUn+IUWP2C4R4GijVLkN8vsOVFGT
	+YDF22XYkGul1iNBC+0wxAVRF5MAaRw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nf+I80LA;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62410600DA;
	Mon, 27 Jul 2026 14:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949831F00AC4;
	Mon, 27 Jul 2026 14:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163114;
	bh=Qlh6y9Au18vR1Ou/T5ICe3OGlXl5Nc84fCTR2Y+rZXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nf+I80LAkKRd7P1QuxdT0ahWW1m3/tjIC5d3Lyv5qO6h7JRFrfG+e25ObO3z/tJGE
	 qBeH5KnZXbBvcaLhWDcEw/gwbLljpG74anL+H3X2y5NglYg/6nw0oM7hCfy6DY/6ao
	 hycb9VgwkzBpGswgxUfwZgvueAPdHtpvZFURSbTRbjmwRq84S0A9zh8fkBwFpWu0AR
	 P2yuFiOqK6kQ8oeAyHc/7AyOIerKD7lt9iC9Ciwhr6tWSO+HrnTUun0ZuLF4BX9ops
	 aiCbPaftTeQWTZSiuxZ+riD//La38XY6PfpLveEPmBa6gI0tyvEuj3EnqDlgEv9f59
	 j70NqIWsQJWSw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 04/17] Docs/mm/damon/design: document pgidle_unset probe filter type
Date: Mon, 27 Jul 2026 07:38:13 -0700
Message-ID: <20260727143829.86236-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C692C18000F
X-Stat-Signature: 5zqy6bef5tudwa6idgigpbqy73it99r4
X-HE-Tag: 1785163114-474027
X-HE-Meta: U2FsdGVkX1+Uag4P2eH6t09jpw5wy91swg5T+w/T0AkQ4RfXVBkOiwxMbcKmaOHgItHT/SEnrztiOceEDKByHRaS/Kivnx9zLvi9jG5yC5jx9sppx5s2dtyldV/4sQxoSrIysl0PH2tQeZsa0t043cp4fensaQDNOdTmVKMexWj1Fuoye2Vjcyv75OV8YZEfHqIIj3DG66hA386v1XygE3G5m8tD5+TEuCxr5RnLLXWEOk/sQtaEnUmXt82xmLUrDNuL5ef1FVa732/1Gyh+HIlsiunaJ+/CGf5KwB4mPUh7+wFVQ1uI+HlLW/3WnKKhyq4tC1rJFUiXYzefw3XseSvkOxaZyGKB3Ld3RNBlwwAg9R2ebCDLmY3zBi/lUHNR46DI0OYy8M/fFQ0P4FKMYOiET7FJeqQLrCfsa65BcLN0YQz2bNERtBMaWdk/ackGF0l4o1kHiok8wM6p++IENsEnq3KcMPGOEISWp35+OEdR1oDoR8c0XiftJn7BJGTSvpLHjxLjwLgtsdMh8pGaXUS6pcjlRrCI4TjTmggi3dLv+ZN5iC0O/vaaHOaFMgYFyhIncUOBNU6g7ffgSHJRMlvU1yG/yfJ7bMtwwrbKDCfO/m+obeMa9j1UFB74D2SrWhR1rFNRifBy3Mc2AQjgrsRCs5Kjffa+JsMPh+vJpEu4dz+COk9LyIkpkAXzBIziZlGOgtmIxsKtiOIY804pBOmtBi8S7acmhh2TSCodQlosKjW9fK9cY4Z4bwmLmMhIqd3y6QI5D2q3gxMrlJoma1LUeIhaERvQ44SvNFGCU/OvPNpjagJli6XsIyELX6K2oQqvCOcAruBeFpCe3Ogvz8NcDkCH+zQMRAuCtX9Edqflj03OFH+MPwetjuJFrHBJdmjwnSkQbyit0lnXL/tan8prZ66VBuPVJi0OnQzDYqazgcbkvjsRxtxrM86k4rzoGvGaFAo5EwzziV8soMG
 2VlIkTTz
 E+UDISpvJYeBBHSf7gTzft8/I3Woj54oJiuH/nbXQ2l2rvujMHc4jqxKb/Rq1i/Sn23yNeKPdMzMLoiXaRLF/1IW8PlP036fRfB+tyH/pHozhZTRyHvl1he6qbyV4mGQ2YQRg6iARuc6CHzqPEsMLASWIHZ3BcipE1Ko4L3w04373VHtMkVlfqan0ukFBzp1wInvME10aav08wUwj3REXCrHlqz9hxxReWFNdtbzTaGyP1MucezbqBEeE4Xe6ezMhR4S5S6O26ERMb/igoYik/VC5xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added pgidle_unset probe
filter type.  Also use a list for the types, as it becomes not very easy
to read the whole types in a simple sentence.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index a8c163475ef2b..c4830bd09498d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -293,8 +293,12 @@ registration is made by specifying a probe per attribute.  Each of the probe
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently only ``anon`` and ``memcg`` filter types are supported
-for data attributes monitoring.
+filter types.  Currently below filter types are supported.
+
+- ``anon``: Same to that for DAMOS filters.
+- ``memcg``: Same to that for DAMOS filters.
+- ``pgidle_unset``: Matches if the page for the memory is marked as not
+  access-idle.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

