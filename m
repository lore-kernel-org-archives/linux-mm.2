Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E93ECC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499566B0092; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386966B0095; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C4126B0096; Sat, 25 Jul 2026 17:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E23316B0092
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54F7CA13D7
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
X-FDA: 85028522796.01.C49B642
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D468380006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0wg4+jg;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4y1qSA/aYOSgEWPMfO2AYPRIpl0Eg8XdC6GTGwB2f5A=;
	b=7nI98F+tyqX5rHZ4Qh8wqnJGMdq9W67o+K5S5Lh7xeaRay9S0I/llcHjJDIUQXo1lzNDTK
	QWmYq1Y/ob+8s40HqzqNaAaCGGH/8FiVsG4veCqnMK64xJCWwce+m599jWWjZZHgc1aWa0
	d//p/kjyc0dbQvBtHoQz6LD/RI0/1Io=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0wg4+jg;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013356;
	b=Thp5PJcHy07Vo7ONwIXx3H1CJy7eRThAtaMR5w41fYaYyrDD0nNnMrRwQO+3XYaZdHKzVk
	EfsgURHl2II1++88p0q6piA+ntAIvsQ13XSWol1cdGukASoH6M6p+9kNURItqp8kGmURQy
	Tt7QKiPAjdBiXX1NeqYF/8XOZTJjWMA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7742A60A9D;
	Sat, 25 Jul 2026 21:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9A01F00A3E;
	Sat, 25 Jul 2026 21:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013356;
	bh=4y1qSA/aYOSgEWPMfO2AYPRIpl0Eg8XdC6GTGwB2f5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0wg4+jgSmEwWeiytUGolWv79Rdy65hdvnU21V3X/EZLTwpDEcIk133lLTBKzuyoI
	 L+0L++HWoCnvlKTfM1lZusqf4b22i/eQbBfzkNhATwbDymhRelL7uw/qvNlUWT8uYw
	 HD9rqaTF+XU+VE5CnJgo+U6YbBCUKI27P62AeBZEDW4yJSrFWi3RR87v3muTD+tGvD
	 5+t/HS+Z5iQiPWdaLYN20IO8EDdGtW7mAqPBXtfzNW++CU0C1zysF0CqjAMSENJq64
	 gsFxjx0slAeTjEadWcCi6TjU/SkpGzSik8Rsy8N2SYZDXWvgc2L5s0QwRuuHtG6E71
	 MFzRSU4C43lwQ==
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
Subject: [RFC PATCH 04/17] Docs/mm/damon/design: document pgidle_unset probe filter type
Date: Sat, 25 Jul 2026 14:02:08 -0700
Message-ID: <20260725210225.129944-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D468380006
X-Rspam-User: 
X-Stat-Signature: bttctygacuwbu9urxdpgur3cdyf79cn4
X-Rspamd-Server: rspam04
X-HE-Tag: 1785013356-323784
X-HE-Meta: U2FsdGVkX1+c++YW5uG1SHvWsBeG6PZF7bYtrEpV8jlpE8TCSdLdc+1vtrwhPpjeVdwimF2AqA7RkFgLnPuo5NlQQRF10v6FVTz/ewKEzs3BYX/1uyRTiqEm4/+SrUyQqneMX/YRGOq6B3uWtJM19md+BOUeQ9xPhBqhPZk6dXH39BnOknBz9tN3SXZd2M8B492bCKfmkjS4W1BEGMxdrZXRgab0zVjvZu6Vb0zNn74vPkSV78PRIxYXpvSIJs2/ohzTQqiKg1plQjKJK4yc6LsfhK6acl18FmMW9fHGTrIw0LJbqtniYMQJj/tN4ChuxOJwUjTTy+jYkz4allGVsH5BzZth5DVj8W+rPIHBstFbBjyp6Eb4SjvtTqEiKetJIVtz8fHN67cDgAwLeACXQRIaKvC8JWbThNtPxRWoAfFvjs2X+RJeV7Onk06uFAKu6mpLVWcjgH8K6pDIBk+EgJA+odsWO1Ij2TwbuikM2RwBOjxzeYtykY+zqGFoT8wG6JBUvO/TCFXV6GyvkQwI6VsxDLMW6vlGK7VobzcHFU/JGXC1kXQlxD5B64HDJCtfHb0mk5ELePpTHeePyyBl01BdDKs6TfKaeedllIwOrzx/WhCRUJ8NBjIhP/n8vfAzx/Yq5sa9rh3KcaavNFayMlkOmZerXFsyZK1jisWAZDrnM43qBEWoRJ4+6DAGdyzCh9N9FIujd0Tr/sUfzfm5hO4oWASxCxtwA57I8IbD2zkDEEUbJeNhRgU+sWcNF+vJC96gaQlNQav8kfH0t8hHKfiVZ0k0bBnRPUZiT+7K6Mb7QRImfbbz94fvqKMF02Qm+skzbhQOqKC3Uo5AumgrvpxwAVwtiN5KSuCRETYO/I8qJNgpkJp96DDYnhRoM1zUJI/xXdtvqXoys7ssgpRyVUffJOvu2+TGHNJRvNllIKB46g2hizbLd3ZYLoI9edcnOVzgt5tmIo42Sa7hfTG
 TnGETzlF
 J7sRqtELoccvsbDF6BwTv02KlR21ocoVQIseCAUDzgx78MY+m/lxnFl78DO+GZy5i3i1XeQcsGoM60jwveTHDhZRS47EyBCNb3rxzBxwAGMtWNEjTH+MLPYC3l8Uiwb0v22k5c/I6JuUz7Kk+rkS9tq2EsAqc1nzgBgherlEYVSZjgNuI9KBSGQGteOkFqW80gy920l6Uw1NWq5OzycCdqXFUBnb9coX+nsaLIBxph7QUHrE3zyzJ6Vs3egaQcECJBuwXPt3csmK0uLKGldwHsCEKsg==
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
 Documentation/mm/damon/design.rst | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index a8c163475ef2b..12a2c3f81a262 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -293,8 +293,14 @@ registration is made by specifying a probe per attribute.  Each of the probe
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently only ``anon`` and ``memcg`` filter types are supported
-for data attributes monitoring.
+filter types.  Currently below fitler types are supported.
+
+- ``anon``: Same to that for DAMOS filters.
+- ``memcg``: Same to that for DAMOS filters.
+- ``pgidle_unset``: Matches if the page for the memory is marked as not
+  access-idle.
+  Matches if the memory is not backed by pages that DAMON can idnetify
+  idleness.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

