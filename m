Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D0FEB7EA5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41FB56B0088; Wed,  4 Mar 2026 05:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDBF6B0089; Wed,  4 Mar 2026 05:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4FD6B008A; Wed,  4 Mar 2026 05:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1357F6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:23:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A60C2C1F4B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:23:37 +0000 (UTC)
X-FDA: 84507994074.02.C7CC191
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id A63A480010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:23:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=a5ug3J1W
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772619815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lj5MBj9ncBIFNCzED+GtuvP5PusClJ12tqeGukAFQGk=;
	b=bfJD6RP7qdVH/8h4vedHCWKpU0s9T70+fLP4jT4gE/kN2O6D/gvXm7qbdzByusz9tXy1Zj
	+Y2I+abGt4S+XjBzYJsoNkwtU1mYTSsZY09GpJTCrZFCCTxyUR058FZpoSy5StTWvN8alx
	/tsxqz9oEsrUpdDGK8ljaIvcxHwH2AI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772619815; a=rsa-sha256;
	cv=none;
	b=NTedaIHwlB7gcASyhLw3Kjte7ZuVmnLqKyWRwJq7IasnD+WY0nDEaEmj2xnjsydAEOtzJP
	cfj3d5etRAf21fOoV+KKngKFBjEdJWG+kpCpiQVY3YgW7Fy15fOQEKQ5iqsjY2/KjWcW7K
	MKcpFGcu+hkQR466tfrOU7MvHS+IB8A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=a5ug3J1W;
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=lj5MBj9ncBIFNCzED+GtuvP5PusClJ12tqeGukAFQGk=; b=a5ug3J1WkXImJf2RjxiTR1yiLj
	lFeE+7ZfEcJBXBjIFcsWvcQaF/JEJemO+4Som6qQkLA31tZm4fZCEoDAR+JFT3Bn/EQK1j1sYE1Fi
	81hMXedSrRXqgHB5wgF0NT3KwIMZwgIvVRh4+cEMLvwb+Ad1Ahfb2p1bJcKyfGXhpeAjOTE+GVXU7
	PvIFANpl5gfjb4yc/ipFVKzNyVcuFTVeaTPSYkOwVEhL9SquISiHESquVYr9GO77oWms/FULjbusS
	ONBcATbvJ8xZS0EpzdEO+ODMLvw9+xtqZ6eQnyVfqWNpLOrqCx4Mg75NHI/dkQUpJpdCgyxywgG02
	iN1sy1Sw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vxjNl-00Ft46-1h; Wed, 04 Mar 2026 10:23:09 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/2] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Date: Wed, 04 Mar 2026 02:22:32 -0800
Message-Id: <20260304-thp_logs-v1-0-59038218a253@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOkHqGkC/yXMQQqDQAxG4auEf+1AqjjYuUopUp2oKUVlolIQ7
 y6ty7f43g6TpGIItCPJpqbTiEC3jNAOr7EXpxGBkHPuueDCLcNcf6beHJf36JuKOx89MsKcpNP
 vf/V4Xm1r85Z2+Xkcxwk5f9PxbAAAAA==
X-Change-ID: 20260303-thp_logs-059d6b80f6d6
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-f4305
X-Developer-Signature: v=1; a=openpgp-sha256; l=2078; i=leitao@debian.org;
 h=from:subject:message-id; bh=PRTS0YWFCVoNZkpWsPM0Yc3J9V/U7IkkuXgM3/9GJeI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqAgHH9iIHniZ5nv4kv1Sc8en2rfakjyrdBHCG
 lJ5nulUhzKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaagIBwAKCRA1o5Of/Hh3
 bQdPD/9K83EQKDrsQRC2sqEHMt+Y1EEwiRw8QRgPG5Iwe1gpJnc1YANslku6TzeaPzWy4TkmH9v
 Q+ixmOnUQ10Hyi+X84IQcV1UOqsJ2taIhNr2ynBy8MMYOMDH7xx5OkrfvxBBAlZTErY9ZukM+l9
 qDFMkN+J6xofS5TaX/eCEcrsSkLUyYpM4foUcQL0zztF+g/HmXQbUutE8BkNWH2fdsgRQxZsTwz
 QXF/06wTdKPPmDd9ohIYTR28G7TsKyCPePzLlLSXxdpbA8OVXLyRqEUFeaiRVgwdyhewpuW3NkG
 WByjj1F0KDY+3G1Wu5TQKOK+pxdSBn1cH32OmZTlGKkARDzw09bAP2xH+Kj2khxpHKY4jZML5H3
 +sm9JtXDshZ03ikfI4T/QXQs7DsiQtAtQ7XhMabjrYFwr90HTp33hUF13D9FcxRCan+yMYKB5Fj
 4kJAXD4hpW4Am4Fc1V/tpHx94mR5IR02WD4zzbddAS40/DnRwxGGTKsbNJYkb0VrU7wZ6fGDdKg
 Ilv4qJM6v3j3bDIEGQWQ2d+Uwcoy1K48LbEo9+IYy5N9uvCNcnQpWsUItTuD+LR4q1m0eRo2TsW
 Q64d8c79cyTISOn8iOmaCX4GuEr5xWVheH3mJZf4p9hrBGFtpBtYfcWT3nyOEgAr74XM6zlcdEq
 4tK928SUchdZ85A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: f66x38jggpaqu1batafo6mpcfwr7hjd6
X-Rspamd-Queue-Id: A63A480010
X-Rspamd-Server: rspam03
X-HE-Tag: 1772619815-950908
X-HE-Meta: U2FsdGVkX1+iq79fOTWJUIYe4smeJ/kPRxm1TWOm1OPeh7x0qbOLJVFGRlKiT8IBoMzW8nainYylfgTpMfW28+q4wqEXUhc3QdTUMDXMr/KjUoUV3RrHP3qIyrVI+TVKRZ8GaUgFUoGVxjnvksy2WDHxDtA332pfOYnwQ56Jpl3ihP8/NV3EL4wO56u6Sn9STmRMhaV61dC8Z2QGYMPNRb7poiHHS02oaiClluhIP836n9YZnFgWHraI6ta4TAgiw5NUV6SF3Hnmpv9nqCSzD69No0/Lf0bxHerlFUWXlgQF5kLygzbCGF8A3/evFt4lRPqc65mFbThvG3q7Cu7m6CCf2BEzNOLSB/6/Wl/ZK7/bPEHeIY/CBY47pAV8K1jQdL7tjWfAOBBLOPHUNXnrkeG1DL+CtDxg8NttdyT3Trgm/VSdtHlT/eLfiAQDZgf7XvMrT8b2Sv+QP4l11meYKRFy1CBqXttlMNJrcGmmo8oBAKiecNns/hYoAqi+GTZKr1kzm+bhrfNnDPX6xd4meZJBaAp1SCQA6oH4LIHtKSKT2jDY1i6dB83CuXbYMSinP9FO53xmK68soXvyZ6GY6J0RxPyjzZxMLxHy9S/Oj/NjT+kz6g5yL+ypYkIaTMa9+qccCPjWCR922kMfGEICoYXwXrZg+EAV9heMZm+Iyjs7ASCSX19wbD+bKX/x/THTp4KrHhrK48flaCD2xwN66URsCCq3y6TsTq48rx2gjHbGxngNm7GCZIKd5NGX+yr/JfVa67wr5GlHY68IahZdXMuVSMIafKHo9yWlYGEPR/fKPwQuRkPVjfU5b2WzzFEniWMp6ss20Aet7xZRSd5uw0tIrf0Kzv+fad4nPwgLtV2/fyJ2xzlK733+bmWxia/sDilkB2qzPJC5o6ATjOSjmUXduiI2nXElRk6s5qKJ79PsHOTj3k2q59qQmsjZqXMJTA+ssdJRFJ26WFD7TYM
 LGqq01HL
 TuNQojYecGsoy++tnBQT0O0GGjGPufBB4D+QDwm4U3QhPR2SMGX5EQkPFrYR+mRi6pSVnMxNa696IzPPNKC6+/IPWvMTUVqxsy6UyHlCSkIYgInRmaCVge2SwOh+64m+Wtp32DG2f7YEr18M0IilKB+SkGWDESKZxdxZZFOMmsepc5L3OY01aqjJFj2MOQEkzOEssT2uMFZtzW2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Writing to /sys/kernel/mm/transparent_hugepage/enabled causes
start_stop_khugepaged() called independent of any change.
start_stop_khugepaged() SPAMs  the printk ring buffer overflow with the
exact same message, even when nothing changes.

For instance, if you have a custom vm.min_free_kbytes, just touching
/sys/kernel/mm/transparent_hugepage/enabled causes a printk message.
Example:

      # sysctl -w vm.min_free_kbytes=112382
      # for i in $(seq 100); do echo never > /sys/kernel/mm/transparent_hugepage/enabled ; done

and you have 100 WARN messages like the following, which is pretty dull:

      khugepaged: min_free_kbytes is not updated to 112381 because user defined value 112382 is preferred

A similar message shows up when setting thp to "always":

      # for i in $(seq 100); do
      #       echo 1024 > /proc/sys/vm/min_free_kbytes
      #       echo always > /sys/kernel/mm/transparent_hugepage/enabled
      # done

And then, we have 100K messages like:

      khugepaged: raising min_free_kbytes from 1024 to 67584 to help transparent hugepage allocations

This is more common when you have a configuration management system that
writes the THP configuration without an extra read, assuming that
nothing will happen if there is no change in the configuration, but it
prints these annoying messages.

For instance, at Meta's fleet, ~10K servers were producing 3.5M of
these messages per day.

Fix this by doing two things:
 * Make the sysfs _store helpers a no-op if there is no state change
 * Ratelimit these messages to avoid SPAM on config change

---
Breno Leitao (2):
      mm: thp: avoid calling start_stop_khugepaged() in anon_enabled_store()
      mm: thp: avoid calling start_stop_khugepaged() in enabled_store()

 mm/huge_memory.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)
---
base-commit: 9dd5012f78d699f7a6051583dc53adeb401e28f0
change-id: 20260303-thp_logs-059d6b80f6d6

Best regards,
--  
Breno Leitao <leitao@debian.org>


