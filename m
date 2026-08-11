Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC30DC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79A16B008C; Tue, 11 Aug 2026 02:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54A26B0092; Tue, 11 Aug 2026 02:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66F06B0093; Tue, 11 Aug 2026 02:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 972E26B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:38:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09E851C0DC5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:38:02 +0000 (UTC)
X-FDA: 85088033604.20.019C3F0
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8A12C20003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:37:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="l/SwJ6Jk";
	spf=pass (imf03.hostedemail.com: domain of linyongting@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786430280;
	b=Zo+UUae77oa4ky1FlFSZpsPcgDAUv3lX6hYtdHWhqlXGFM4vwpamvJMJcGbeCJ7pQ7CYT8
	lkQIRxeY5Zi/f1K7PZ1gZz/o+5KdbMXIzvOUGMnh90TyZyY/D/jrCPjBe+W3cdXQ1wiFGa
	4ZcWIoWS12I5NCY+N7Pht5Qeopm/0mI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="l/SwJ6Jk";
	spf=pass (imf03.hostedemail.com: domain of linyongting@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786430280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tMXjFTEIJh4ZFVEtGejCM19Xx/d6/1X6gIZmbvszynU=;
	b=hVrkTaInaqtcWiZ99OSWeu6dXVG1BMecS7uk4cgaQ2xxra4OixqWIhTgyM1kXQYXoWvEyK
	JS56DoH4YnVZ/I53DvOhuvWFdnxsAibOLDogOE9YV1fZ7ut+u21DRP88knMQOMAH+LaWa2
	nfl4dpoL5GbhafNrXISaP57ge+DKQrk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786430274; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=tMXjFTEIJh4ZFVEtGejCM19Xx/d6/1X6gIZmbvszynU=;
 b=l/SwJ6JkMmeZKNYb7KzHme8emcYMQ8FmQEqWJdVB43qjrieTAfDtlRHMDcCkBk9OUUG+ZN
 3Lb+uamS2dVQcYr3rypBYsSMmQkie04pceWDV2jmE9/W2JTv/igDbsA6dWWaKvE+8q7pdf
 1cWZMlh3byufqwGjsXD9I0PoyJ52/UapUzIwIufM5EHpnFoiOrP76CAHog1EaJSo4JpGZs
 jZlecaIZ96ProsKZUGrTEUSOOFngejiuRmsxNIoF7A/5h53V5teg+ELpWYPIbAY+V/ErmY
 A2XMZFAEVsnwB9IbU4Z8nCmBj9LsEFSD7JXtCdtpUH3oNL/onGDpICBm7x2hBA==
From: "Yongting Lin" <linyongting@bytedance.com>
Date: Tue, 11 Aug 2026 14:37:18 +0800
In-Reply-To: <20260810143706.93163-1-sj@kernel.org>
References: <20260810143706.93163-1-sj@kernel.org>
X-Mailer: git-send-email 2.50.1
X-Lms-Return-Path: <lba+26a7ac340+d47459+kvack.org+linyongting@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260811063718.63086-1-linyongting@bytedance.com>
To: <sj@kernel.org>
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Mime-Version: 1.0
X-Original-From: Yongting Lin <linyongting@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <Jonathan.Cameron@huawei.com>, <akpm@linux-foundation.org>, 
	<alok.rathore@samsung.com>, <balbirs@nvidia.com>, <bharata@amd.com>, 
	<byungchul@sk.com>, <dave.hansen@intel.com>, <dave@stgolabs.net>, 
	<david@kernel.org>, <donettom@linux.ibm.com>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <kinseyho@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<linyongting@bytedance.com>, <mgorman@techsingularity.net>, 
	<mingo@redhat.com>, <nifan.cxl@gmail.com>, <peterz@infradead.org>, 
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>, 
	<shivankg@amd.com>, <weixugc@google.com>, <willy@infradead.org>, 
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, 
	<ying.huang@linux.alibaba.com>, <yuanchu@google.com>, <ziy@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A12C20003
X-Stat-Signature: 56ahp69qddt4uzz8bcd5xo1gqs1bgyu6
X-Rspam-User: 
X-HE-Tag: 1786430279-319728
X-HE-Meta: U2FsdGVkX18wCSSczo8/zlkLkI9hPpQHgdDqXsoE0eLavZkOOUSE5PGW5/SjuDyJAIZaI6QbFJjSoUjIJS1njP8FpqwjNIYDilX+s4KiomWL78ecZDcoGIoNIZyABbQoxAde9qVgMAUjbaeRHGXvFbBsFo8Ux9znvZcdxEE/yQQ54dP82zWnKOy6eZPN2fxpmPr5YsBQ7rdqwY543b2Ys2qJKqF3inFn8EZJFR26rAYzU5tiA5WA6htEo4acY5TrB8ZCVK+w34GJUGho4FCaHc99SNctYelMwYQw458UpSnJrooRe9S5sdv1XjDwV4f5sgOJARi+ujtjOy/+PC5WLIw12F7nO1adJITkZzkP0ikA4WMolFaCASmqKOnKiwRcqmC3LoST9XipIELbmM03/iSjN/I4tz6td0hMES/n56nzARsf0pAiEgZmziPWM8J/RaM55eBrwz8inkkPqpgu5SaeuWQXc7rqZJTb+Rkeg9ZYhyI1XckVN4mnjUkG3K5L9NGPUIxLCVqK6LM+tU2XNHllBme9RO6dLlrtr1fsGbRQUgU/9pj/tLQUsKW+jIPlXGtSgunpdu4stsEPtl/nEYqlvmxMgTmqAtQhYKEAj7F86wM2bndMUQ3/kmqf2ctC17a1Q8wRK8tzjaH+nzS9wVVaHEBd+sX2PlMYcUKuORtb4iS8C3ePkWyVeBTYkj5e4+sWYMsmah1KcFvREKwy7J2ZVxCISjkvMmTbfQhASHcqz/kINDy0Abvl3/RrpKlIAyIK7VQxAFnqNb9bYxQMY82H6Mcg3flh/22C1WvrtHKw+HZ5t91jVwNbffZ39cLDzAGvF6RfxDOXRX8dv49+PF+nAhHvrKpPTlHWnQRFX0imNlR1UUVd+5zH+k/itM+zVfiVtP8ULIEMNyeyaYcA+q6hp0KlTR9pYc8BaVlsxYoR5Tkv8sLhBb/xFWWvHtHtj5/fD+jcNtQ8Y5YgVQO
 KlaI8njy
 I60qG8mhi9jDSUhccIsSTpfA+DNj8sUZYPwK2Zs3N2fq3jCW9KhByf++qjRa5ZWa++pRzndqD/LyJBU1Q4px7NuPNxZHOHniKhfMFpCES9CrZCx5zFMOgRCY4SCRmhpofukKsfaM1h3F7xAts/ec/wR+fVx76+ajR9WI6uC82P9v2kX7JCHniYbRVcCgtKLM4alYnt2Ghrle5PgfJZR/ASnHGYjkly1xjmGYtay4pKVretcKVODo+wQGbRx9NFE2Ozz3keaheo9HQbnp6Ki9tkIuzzscaJZZHXmKN54CO5JWsPCUeb+tesBfDRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 07:37:05AM -0700, SJ Park wrote:
> [...]
> > IBS is not the only possible hardware source. CXL 3.2 defines CHMU for
> > device-side hotness monitoring, and CHMU has also been discussed in the
> > DAMON and CXL hotness-monitoring discussions.
>
> Yes, we discussed DAMON could be extended for access check primitives other
> than page table accessed bit, and CHMU could be one of such primitives.  The
> extension is in progress [1].

Thanks for the pointer. I will take a closer look at the series.

> [...]
> > We would also be interested in helping test and compare the different
> > approaches as implementations become available.
>
> Please feel free to let me know if you want to test DAMON-based approaches.  I
> will be happy to help :)

Yes, we would be interested in testing this on our CXL tiered-memory
systems.

I previously built a Redis workload with controlled hot and cold memory
regions, and compared DAMON's results with those reported by a WSS tool.
The estimated hot and cold memory sizes differed substantially. I
understand that DAMON and the WSS tool have different semantics, and it
is also possible that my DAMON parameters were not optimally tuned.

Once hardware-based monitoring becomes available, I would also like to compare
DAMON's page-table accessed-bit monitoring with PMU- and CHMU-based access monitoring.

Thanks,
Yongting

