Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B45C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 02:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE43D6B018B; Thu,  2 Jul 2026 22:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC666B018C; Thu,  2 Jul 2026 22:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1996B018E; Thu,  2 Jul 2026 22:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF3A6B018B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:05:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF8171203D0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:05:25 +0000 (UTC)
X-FDA: 84945823410.27.BD9BC16
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id F138AA0003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:05:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dMnAFHsS;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783044324;
	b=x0tfPcEarl8KuwDCGVxyU5KlReJvazeujjNEQPRTl5wPioA4oLUod8CIxbSAwe6+mTuDv+
	oXUGm1gz0p6JDlA5VAiiIcXw80iN9iKnMmA60W9TqySvu4VnSQ1PTKTetuMbqfW/wk22aJ
	7cHQcLHS2T4xsyd7HFIOrxkChlfU9hk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783044324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghwNRxDlC7Tmn53ov5gek60j8bF0++lAix86h0ASuzA=;
	b=HIwFRU9WATQczORqyPw4feukmokDTCSknMR8vpcKB5g9S7jy4jI6/Z2zbEvxkZ3gzs4Tc0
	ahEDY2MPdI3Irq+5uXmCe9LmqDpYUz9NgS0oaw1wfj1R07fciY6I+TUbMYSvMqMdbwVchY
	/yQPVR9Ebsl229nyxkMZli/OrGWVkWg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dMnAFHsS;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b418dabe-b4f4-4911-ae46-550abc3331d7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783044321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ghwNRxDlC7Tmn53ov5gek60j8bF0++lAix86h0ASuzA=;
	b=dMnAFHsS93DoOXRC9Vb5kUI0Bx0weWwbzv0pieehdt/UWMPStT7X3N84wUcGOE+oE82Zhj
	lQ5pNxrPMwVbmmxdx8ZOiOWOVO5yx9TKPDg4dEaSMbjwjnYr2/J4z6Vl+qPEMgF1ZzB3hv
	XvluXolpPdB91+6i1gnbMdMUD+Ue2Rg=
Date: Fri, 3 Jul 2026 10:04:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/6] Open HugeTLB allocation routine for more generic
 use
To: Zi Yan <ziy@nvidia.com>, Ackerley Tng <ackerleytng@google.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com,
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com,
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com,
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org,
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev,
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com,
 vannapurve@google.com, yan.y.zhao@intel.com,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
 <5BCC635A-9CB2-42AF-B7CA-43886CF2BEC7@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <5BCC635A-9CB2-42AF-B7CA-43886CF2BEC7@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F138AA0003
X-Stat-Signature: h1rj347rc8cduka989ju817e7biyugzx
X-HE-Tag: 1783044323-472019
X-HE-Meta: U2FsdGVkX1+61yw7Rn09VkmNpu1WAI6cIHXz2c9Nb8sLkInoaal0SWDqB1EatJWlS0alhHEGJXHZCPOT3d5D0ycZWFn5wcD7tch6lGndXkRWnisH6XNlQnekcXeHv18SvB1sfRZBJ1GLZZVRG+vefahRjGMisBL7MH6IuPZWn+trqMPtqcI0P2DozXtWvK+3ZqGR0FxFZiVeLJZtHl3YY3ZC3ZSh+YIjvWiz6dVEL4R7x00KmgQOK0DCGUcSJbScVmCojQVl3jp9R/2KbQPCWPt3n1mBQ4rF8ZmvPHWhF+6SWjKd5o2hQtNYAVsLfM4oUSri4mYCfo3Ojkz8MPD61OrHFNoEMYjWlURhPYsoYJ0WN0w281p4lt0sTDmLqI9kzLONr7fu4E0B4g0UExsgkd+OMur5WPRuSpGy5rX6BQwMIyjiGgHdfOuPgUGhkj9ykxIp/Q8BLOgBR9jThFrd/2RXCtbnpW/KrkAOGnE852B6LLTaLphx6Cbyh5lRjbVf/NAh3HxonZrpUrWdvckd0u8JJmRdyK1YkrOesuTLnZerZs5z1hOdoe7x4yJllx29kZvyX+/vfdhOcSllR6y2sm2Du8YrK8aAX35SIcpgufvTV0GvmCh07REiSECfm2Hmzl5sFIHKNG8JkJSkCjwTgCfcYiOJ4gWl0pG5q8qT/6RdqWSlevcL7030dvwf9ue6ZYgcIfu6VTVqAKwV1AQR+MjZc90ItVgXANOIxKP3eMXiwKUD0BChJdpjYmgDft+NiSfQK+cybtg+Wl9fAP8cEAEpwzUNzk6/sIOYSnI/8MXQJFMJcbSmZfUBeCi+XHut3fEZkIxL3zkxHFesWMkzn2RgxGJAWabxPQW9dqo5PAq5clMAAvv1lVpA6RN3RMARlRH3OSLx4uvS/wFZfP5q/KLX1ZSuszL/oLGEQVSmj0WGjVHziyqRl/mVqjKkWL2vdyn38Pkw/8J/0mYUikR
 nkqo4Nyk
 Bmb0DscSnP/50XIHKCCebCph3+SxKmO9Wx/kppZ9cU+V2QsaljZcRcpsDa+XuJKYNVfs/8+40KHRYYpYgY5w/5HVQt922Ff7HPrBqTbT2UgBCFoal6wDRfV09kGeV599ybXFE7S9bmsXzbDestSDdy946CKmD99BtChM3qmiwqW5rs81H3nwMWp96O5okIMn65yLNHcingg1fej3YstotqgGXuQc58EWodxXeQFaQ9N51fhhCsfZvwg1NRmzeY3Ty6v64+I0qn6Mqe7y2dQpuIIUbsLg/X9mFTmI3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

On 7/3/26 12:51 AM, Zi Yan wrote:
> +Qi

Thanks for the CC! I'm very interested in this work and will
keep a close eye on this patchset.

Thanks,
Qi



