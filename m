Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF7CC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1060C6B0092; Wed,  9 Sep 2026 05:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF3D6B0093; Wed,  9 Sep 2026 05:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BC06B0095; Wed,  9 Sep 2026 05:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D54056B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:16:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4FC4A305A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:16:30 +0000 (UTC)
X-FDA: 85193668140.07.6794076
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf07.hostedemail.com (Postfix) with ESMTP id 53F0940003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:16:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XHx1oSBb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788945388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9a6AchFeClJ0X2mXxJBaf6V4wwK/h2PfVSfYzesQn4=;
	b=qlcYv/DPz6mOb5FkaM2przkdTNnOB0kHkb7WvmRLMy6wvQ9tnJ5sxXQYhaN6fAgDq1R4Rx
	lS5au1wHJ6GgGq4fUEHv+RcZIj+EMWtiobuUJqq8BSUJlSGMxB6+q6+EJIAasezgWlgRUD
	fZbOriff6KFfwK3/Dnk4HHVFTUs0G10=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788945388;
	b=SVrvXj3w+QtnW1SBYWsA/7+WYW97tnf5Zb3Yeo6kfpqeBE7+37PaXwDr2yk+wFRSrZP5a1
	UyfHiyYPj/qZz+TFYzxoZmGI+r4Vho5n9xzA3Ur/9eZSrV0EUvYfuZAIkVdHcOjE3vbLMo
	DjhwINGQ1JHEVmkdQolYG1GJoSeIeb4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XHx1oSBb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788945383; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=P9a6AchFeClJ0X2mXxJBaf6V4wwK/h2PfVSfYzesQn4=;
	b=XHx1oSBbDO8Lw3r86QcMVbiAgf11UIL0IdAKCuzX5qj8UhFMmg3tftoGSvHGTgHJgpYJO5yZs47vuuTjUl9yJY+1l7NP4IRW3FPjeqvnOav8XLLEguSVsst9m7I0WOhP7EH+tQqPJ0DIgXel8A0askDui+Ym4CauRnuEoLH6lnM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAePNMm_1788945380;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAePNMm_1788945380 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 17:16:22 +0800
Message-ID: <9fd65a16-51d6-4c21-91f0-f278479316c5@linux.alibaba.com>
Date: Wed, 9 Sep 2026 17:16:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/19] selftests/mm: move is_backed_by_folio() into
 vm_util
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-8-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-8-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 53F0940003
X-Stat-Signature: 95f6ik145scdr15y48ikx1h1zrksrbsr
X-HE-Tag: 1788945386-49070
X-HE-Meta: U2FsdGVkX18/cdI5cE9DKdtOGZsP3BqaUw0zxp9dv458oT4Vt58UiUSVvvZ9FZz/K0RHoYs9wbhi/mwxzbUpeCQXZ7biorWVfeQZFhdY6O86IiEedZjbIj5qFW5INFsafQZNzgmax4JJUawuABawHHTN/yxtewbVyYG9aMbKmoXlb/uRy8WL80cgZTdFQxvedgQp08PBdtFfGkoEP1XxTJX2NIQzeSCplQKMdIBbR/HjSkyAOaLyFB8avhVG3lh9JRqsLUyGBFZ9fxtTBDueL+uym+khEiDD3Bu5Vd1cavQ+702xB04BOhDXWshU7TP7BzPKZGe9jaoGX3Ci+1E3ZfRew+NWyxVBRqbzgbT8CyxFWfRlc+VpNA9erRQLzjhvua03oAjy/U0FFUrOgXD/t7pZDgjY8LiYXHXtEknM+bGwHEOawjgW2m7oLkosQAxlPvx3bJSmQj1FW6BQ3yNcFKoNNXC1XRX9x2eh2Zbbc3QJCefPQNHkYzF7t9NLImRIptMHoaxMLZRhHnXX6URc/uft+PoaDaXgHcbKQKiQXLJbKBdpFBfsIxBDnSTAR+zhLTWHHwIgBwM+IGGtedjCgPdV1U2JPLtxcPe+b9pnrckI78x3JPkTj2ZR2NoYj10xlWBGYcWfx0a3OKn1mm7qe+Io/I4oGLj7+cwJ/JXPb5Az+G6iqR00QNw9oau5dNHhuJKT1nwvG4oIPd63j0SfLyXWTijXdgO/OspUg+ols26pKUHOy+w1dYQdISUCtckq+E7WEBmGPEZWcPwEurd5UihScLBPV3Bzqrryi6WiJqC4P/U7GZuz8rpHXUt+p81jtONTiLiyqhty/J5CdA4m/XUEj1GUd8Wu7RVHCiezeuu1+kwYnwRxnOTi5JPIf5jz2y7ajqz7e4OAZmmXwZIe05dVFJWmk5ztuH1ji53VwqNH+Q6H3VRePkgDdsjHA3n2UV/3HGCeTqXKrZom69w
 aiaPQDXs
 ST3BGdQcaJ0uFzAJ66JqT9Yz5QHhWeLZUCerXTVvY9Td5xaatz7cqAh7CMFe/ZGKIpsiKvE+DgFg+FbNOUTiJUlgBmAFOvjGkqpEiq8hmfw9ja9M/uGFdS1hpYvVuMDSZ+wry+nglULYZmXUlMUQo8S2bzZEwX+5yEPASxP9iTeQqp0D6UDm10QBeRlo7ltg2O52tSNkF5hiX4tYs1jFoxWhYS0FVjPQLEAWu1hLIMVoo6y0Dnww52CFsTDxJUzZ8p+7Ni0lQml23qOazbxcg0F3hmkN3RqeCnOkgBOFJpY4r55sSZXy/1nK/a+u05Zt4wizS+Y+RhdmPDjrvoVWAwsaiqbvWNIJZWvs68ntCGcWvDLdG0m+2SJUUL+4WyhPD6TgY5iwaHiAO3Qr5GtKi6QEDhNnynxHk0DqzfJhPOEXJUBma8e+0yHji95DXO5AQ6HDJlvjUvMQb37I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Checking that an address range is backed by a folio of a given order is
> useful to any test that builds or collapses large folios.  mTHP collapse
> coverage in the khugepaged selftest needs exactly that.
> 
> split_huge_page_test.c already has the building block:
> is_backed_by_folio() reads the compound head and tail flags from
> /proc/kpageflags to classify the folio behind a page.
> 
> Move it into vm_util so other tests can use it.  No functional change.
> 
> Assisted-by: LLM
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

