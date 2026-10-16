Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF91ACC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F009C6B008A; Fri, 16 Oct 2026 10:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED83C6B008C; Fri, 16 Oct 2026 10:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16C06B0092; Fri, 16 Oct 2026 10:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3E6B6B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:35:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36923C0398
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:35:09 +0000 (UTC)
X-FDA: 85328736738.18.35B18F1
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id 76C6F2000D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:35:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pfNUX2ci;
	spf=pass (imf31.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792161307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yc3ap3MWdlDha/MVHspUrtH+yCZz2kVrPVlYau2goN0=;
	b=ZX8oOcfp4Ga/UlRV2XF9riQNMleGO+OxTtCUVqV0B4LUISRZH4qLz/d71zJWfEBVjO+qo+
	9+2Klyix80UxJDRZxPwxWxsDgyZu+CofLZ0jnXb3tO+WEJFO5EiRCo43B1L0YVDEJDmwYI
	TvLwit8VIuDf6bHzQ//HbXeThN7FqCE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792161307;
	b=69K9m7mICLM1ovB83N15RS1zkc2pHK1VLHrt5XpRNFw2rhAeVuTbCZXluDBmZA+E9EvmJT
	Jpmo7slvjA8E/pkfWG3774D4v+g3CUcgfww9h3XFQn8gAhzws/msmxW9dttmOn01ZJFZ37
	KUHuUwq6M1N/RveZdflfi5pfFXNo/fU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pfNUX2ci;
	spf=pass (imf31.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-30b6dad2382so15816124eec.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792161306; x=1792766106; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yc3ap3MWdlDha/MVHspUrtH+yCZz2kVrPVlYau2goN0=;
        b=pfNUX2cik0hUpFnYxBJJ0HRQ1ZzXcJ8BjjMakyglW6I0DZijaen6J8r/OjcnDCk/Bc
         wlMU6Q3RfLqzgkjKn/VSljNszZbE91N9d3O1ge3EathQnvWbI/GsH0PljMpydVnh5gNh
         nsxI95lc7IXM2UFmwpveYJqRECvLCinXqlZspF8gXnyjT+J4KE3Byx02VjWsnWFnYlty
         AegkAjxqTYz2gR2jAi+rO9G5lxP+pgRLPevPR7z/x44BY0wZ8ibJvDAk8Dkh1+OGwoWi
         hWI9VixjAmHppgi82a5DBQu81QU92ZVNt4ztvX8rmPS9wBh4WlApAX1qjpB/h7dKNmV/
         GBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792161306; x=1792766106;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yc3ap3MWdlDha/MVHspUrtH+yCZz2kVrPVlYau2goN0=;
        b=Chqyn2oQv00slB6PiH3uD6LaVZl4lUElUKzgTRh10m/mIkxjtH3+zMbbyMHCsKWLnh
         BW1430EmMv6HQSW5QPaHX6vIitkFpmoEgcLwBeIPK4odE9mFotATddymWRk6MYaQdzn4
         SmXgtMppRs4Q/l4is0zkdSVp20KhjIy5/UCnpC4CvGiuDLSErU1zUlFjiSuEfDcyZ+WL
         efBU45r+KhgviuTkBs/fNPyH4wNdIxxA+w4TfIoB7MHNyY/JMESLYmId4RdjDh/XbTgo
         7mgnWAE5+EsfRJwym/8R37TKeI3bjjuwGKsM6wAGmozIv7j3SbgFUVdRcL9yGg1mIbLw
         tJMQ==
X-Gm-Message-State: AFq9FYIR8XU3iKw31icDDxvPnTxCsLCYO2vwEIxOYzxqdvsZ+W+VAb1F
	eBDStSx/YbPumnGh/KGJZM+f/HzdhlqnAwCXWJ6Tif2B8FBExnVsouKk
X-Gm-Gg: AYBFou0QYfNJC0uKgvSnSDC+NhDnk2OIde6CMqq7fBCjcq6uYGXh5pEZrS27nBMXlL8
	nk4M217cusnr2CiOr9Hq8v6OFK3djmIjXxPiOVOP5OOooyHCmAWMdxmyYJ/WNfS+Hl2s1EjdRV4
	8d3htBxX9SKK8orG4PcbthXkIkhcL+yVKf60VC1Rqk3so29WUrHyAYrvlhKzlota+BPw2kEERZ5
	6pj4kOiFVDQaJS9N5eJhHLK2sldgQvTXhJtzj8UhHEHCubr1aigk0IPXn2BQrIK/hddn2Bb171+
	sYf8nx8/d6GWylgaf+jtc8S0aaKSpu4YiE07CfYPA8q0J4IWd8ir3NR5/G8XM/jNbrn7kXMljOJ
	yDuWqsS4/CpC5YtPDjAoc9EJmc8wF5HpM70WqdsxqimV8vE8Xmt3ypu7vOWEB2naDNFmZCzWCII
	5N1ZNamhW5JtvpeivOzYvk1l1t2sdqOR7LU0pBhd48MyTWDOw7KFn7Hv9Y0r7vWJKJxyrKXKn1D
	+7SYw==
X-Received: by 2002:a05:7301:424a:b0:35b:9bd:1435 with SMTP id 5a478bee46e88-3619ea236e5mr34190eec.2.1792161302290;
        Fri, 16 Oct 2026 07:35:02 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3608297f4f7sm7611812eec.23.2026.10.16.07.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:35:01 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH 0/2] mm/ksm: keep smart scan from losing duplicate pages
Date: Fri, 16 Oct 2026 22:34:55 +0800
Message-Id: <20261016-bug-mm-ksm-smart-scan-align-skips-v1-0-2f91d76416be@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA820moC/x3NQQqDMBBG4avIrP0hESraqxQX0zhNB5tUMm0pi
 Hc3uPw2721kUlSMrs1GRX5q+s4Vvm0oPDlHgc7V1Lmu9873uH8jUsJiCZa4fGCBM/ilMcMWXQ1
 hdl4uPA7DyFQ7a5GH/s/Hbdr3A9Hmhv9zAAAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 76C6F2000D
X-Stat-Signature: 5z6em1gaj481auw65c6q994xqoymdcct
X-HE-Tag: 1792161307-851554
X-HE-Meta: U2FsdGVkX19IM7Tq/bRLXwFsfIhNYF82qO33LN2MmzUNYwkirUysQD9Vhf0VvKL/hgQLq65pGwp/oDLzmT90guXUdkI2he2XKT9N9uth1JDywmYcBms8KADtm7K91NdmdfyNeYNGeojv9wbBkH2tzZ/xUp3ZBAmLkFLk/QCdNDzfTzt8s8xzCNLdW/RYlIZJIYmo8E2u/yJ99R1MLHsS8ibq6jyYh5F87qvG/atwqe3UvTNDSth9viV+Ba4BO5sysoEzrcAydCGkJWR2IkoUgVXa5ltLHldqEdaXwn5rnf+U0ayYkPlPk2S6npYRZfleBqkJ+umqz7wcnLZuQbxYfjpaN5KbwkD6F1KUWXPeJCt7K0qE6LxCOBbbnW3prAlEkR4hrDRAkbQyWKL4u5AsN7Xm63WLd01Sh0SDfOG5G5c8g1pRjPFB2RkkWi1flwbcbj5Kmjwcr/D1E0pnqyDtmmb++DiW/ejrCsyx3Lb2U+lNPUOy0izdx047mMccvq1qmsSI4gZefzYKIHN5wFXH0ghni+ZL6Tw/0GPwykfnRSNV1RsBeqXjjQviYyqLIFrkZf+UmkU7k4TYUPMt733Qjj7BE/YgYIn7YpqMpVHCsctVaW4P6nCzs+8rfpMDzHZOJiJyLX3OjIR5WD9L1db9U7EvndnPHkEjPyirUJFQx22rXc6KZ8wCBE+g9uvw4+QMjlogs4bN8nOEftZFY8LBxvvxKyHd95Zbm+Asdzo+IDHlBHQzRoTQwpdE/vk4AQRMUjmuG5gh1HU1Ra0Hiq1lnJ6DFec6O5WM76c5ykOAfZQk5sevaJEriGCv1F4ELD+6TXfNwtkvtALtnC5U/GuRXV2upugdut79RdeYtDzN1O0uTFTMxdOHkDKDKQ/dTuiT15MnyDbTYzum+kRDppzY1RzD3GaS4GuUh3LboDbSK7sQQfCG+AVrXtD5N4oo8SrK6fBuCiOXXSMYbhJpP0x
 yElzqjf1
 XhLBqKuhB+anp9PxVMAKHAsyjH15OkFRlzxwyah+X3xy2iq5FEiTC77mwb7tgSjN/+EL9shRbAeCbeCUTsIZU8iygDfUP80pyOSg3fgJrnXAz2U3vlkdFrpbtpShPQv/C5CF72pG6yuMZ38BLebGrOelXBgwNlcOVPGR6S5SIk2f/xeuyv6rgvqjfV4M6NCbMfedNuKrML/A0klfLYYTh5ht2kx6cdlEZXli5fP8l7Kwp8K2f2ev95nglBB9zZGy89HoRHpRSJqLCIksJ8VdF6Mf0VaWgTVXk66S2nehcBe35vLv8hMaLKz2O7mjo10p9jcH/Gw8m+9Bu473X3Tul4Sdyajyw5OC+LwidYhp16ZuMVDcelybCNY+ur1Qsy2mAFiugm0CkAuqO0o1r88HR1g4/yH+1fLB0lKRQFF2I+Fw1JQX/hNeSgeGBr/UkhdmVbU3swqJ+xQqsgfPZRG7lpjiGP1d7V4Q270mE5tlGvnTgsvFTuOgLu9qEcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With smart scan, which is on by default, two identical pages that become
mergeable some scans apart can stay unmerged for as long as they live:
each page times its skipped scans on its own, and once both are old they
may never be looked at in the same scan, which merging through the
unstable tree requires. This showed up as intermittent failures of
ksm_tests "KSM NUMA merging" in run_vmtests.sh.

Patch 1 picks the skipped scans by the global scan number, so all old
pages are looked at together every eighth scan. Over 420 pairs made
mergeable 0 to 20 scans apart, 317 merged before and all of them after,
at the cost of about 7% more ksmd time on memory that never merges.

Patch 2 adds a ksm_functional_tests case that fails 20/20 without patch
1 and 0/20 with it.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
Qiliang Yuan (2):
      mm/ksm: align smart scan skips with the scan number
      selftests/mm: cover merging KSM pages aged by smart scan

 mm/ksm.c                                          |  24 ++---
 tools/testing/selftests/mm/ksm_functional_tests.c | 108 +++++++++++++++++++++-
 2 files changed, 117 insertions(+), 15 deletions(-)
---
base-commit: 437a7e839def0f505277022622fc59a8b071d6cf
change-id: 20261016-bug-mm-ksm-smart-scan-align-skips-cd01e5a9889a

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


