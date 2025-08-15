Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A1DCA0EE0
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 06:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C258E01D5; Fri, 15 Aug 2025 02:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E5E8E0002; Fri, 15 Aug 2025 02:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ACDB8E01D5; Fri, 15 Aug 2025 02:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EDC7C8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:08:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1109C08A0
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:08:10 +0000 (UTC)
X-FDA: 83777961540.14.28D78DD
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C6D916000F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:08:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fqxUkf8c;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755238088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6Xki8soLW+vw63qx0n+Ld6/faF33zlxnTUtiZxzosw=;
	b=61oOrFvLPMcIyezmYHwztrzZ+wEF3mV3bx38LmZyTRCXM8q7mzrCZveUOcOAOHT//DMET4
	4y5dJ8ciICgzjGUkm271vwKyOdzGeALWM8S269PdT9buvKLCGp/+2Irc8XL4j+gXKlqEd4
	8ZhlzXOTRBiDfgsVz6R6Ujpf7GJAVJE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fqxUkf8c;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755238088; a=rsa-sha256;
	cv=none;
	b=kQItbiUn4/SuhaZDpjZNvFqCgFk89zR2wu5AEHdL2zspOJAitcE3Tc+S1tm366muSc/PfL
	CwcOXQpH81rOmbULJszyciA1wC2TVOWCphJzHpRnFJWSGcu+8bLkE9yDRhD6e5G4G5/xT5
	s/eINaNolEK6OhDNzRMrg/TNs0e0Hic=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755238084; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=c6Xki8soLW+vw63qx0n+Ld6/faF33zlxnTUtiZxzosw=;
	b=fqxUkf8cWnfCqh0p4/H5f581qXTJ37nkRhmiyR89roWMAGIrpdryV3i/eWoP7ft8cOZAkUNurHDYku7MNORIWhrIgSmo8lubIt9d3pJXSRMQSkYFl+XAAqhet+Kvy9eB35Kc74KUAk7Rosf2c8gTQB4ne/9Wn5rIp05kJh1psbU=
Received: from 30.74.144.112(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wlnr11M_1755238078 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 15 Aug 2025 14:07:59 +0800
Message-ID: <0e26b400-e477-4722-a524-8a3c520f5429@linux.alibaba.com>
Date: Fri, 15 Aug 2025 14:07:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] mm: convert core mm to mm_flags_*() accessors
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
 Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <1eb2266f4408798a55bda00cb04545a3203aa572.1755012943.git.lorenzo.stoakes@oracle.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1eb2266f4408798a55bda00cb04545a3203aa572.1755012943.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wcezk91prjnono1adcp9f1aodxek7ey3
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C6D916000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1755238087-187327
X-HE-Meta: U2FsdGVkX18kkqaH2FPXbX59VevKVk4TazzKU9Pu2rNaA0BqT8rj8D57IkUQr4+qfh5QFjCRW8OyxeJfrEcctOqfoXzqmkporfrUTasfvLqXN2mNQjjwmN4xjhBIY85xb/3eSxPMIu821C8WwMf0y1TcsZTsnnMlkHcW3bj6lwdF8tGmPhakrBHQd2JAFzHY3Vjh8vN4MvE0fueh9IEArua17mZwAuT3PmjB0yBd36pgpSdxolDT3n5L1Giepnn6fy5xP12nkTzeKtgEnKDLqWY6cb9c0Szvo6b4Jgaa4YN+Dg6qQvrj1m1VfYmQZ9XpPACK/khLG/EPewDq6Ot3BdAUwsHtyXWn9XfM76D63215fZvXJ7rTFbCnUZie4LJRWThWQ1LbYHb7kgd8jTrx5F3sqyIMGPcGCyfENdYadngI1ofHWUT135ff3spHnUagr1Ns0cScc3CD9LGl4zN3cDGUTSUsRUVBFlYjuTc7S5sds4DhsHDbCxNxLHUseHbJHQl69Yh2F8O/ZNnJ3qOwEpXGFXBQ/fDoxIDbUN11S2iT0qXhb3lOpZkfDVR72AmK89B7qqFywIylZgfdhuF8L4MySkaYNhGwVDINYbmcpJTZo1e7SZpyGaDqIiYGTlmSRSah95Hx6CDX6F+FW8JzGHT0rJeSl917hMqZ8vpw3m5pCx3Wh6b9BsWpWK7Z9UndOWIxADBkgSrQZoWMlUNe1DPC0xzh7rKyQ1YSWFE4GMHW1D6pHVifZr3Rxhnv01ztQflMSlhX7oq1ksKLtNhpqW9P5V6bvdEArbvNA4QOM886U8rj9EXrvZuSOBjd5iDDcTuivXjdZ6elTwDev8qrB1BTvb2ViyO3ETmprMqEGt1399aWqZUedT6iBQO1GNpRtuIhlvLqF0auVZqnKeA/ADpECrAIHOYO+2okexJ4lSerbZX4xJo/RRI8RIuRYIRzDTyVBvDIbQ8yUP0Wr9/
 Hr8Twi62
 RF6JW4AcajyPhRlJC19VfYSWOfpDzRnWE40+LCgp3TIsMTeR19VeqVFAgjJVGZXDwc0GJNFxzPv1yRvjRpxCFfu/0NTn4Y6Aw1F0xQ1BtihclErZM1pZWx5lgyshh7hb5euu5rQOgDXTTlPPDxi9UeQ/WBWnqrLTf7PH4w6f7W2NK8JfxLaets63MSxuAt8JAozkowi2f90/Y/lX6gEikWQl9unYNwO72BRDg3WpN5QXWjBmkLXLvwUjEW6Rx4+THx+kyx0lshsaPO2dIPlpNOFPyfmSdm3qT7gr14qqFYDqAXgrgTftLtjdeXkP4dMGyofxRbyKTCJ7tB5eFkAOIrbz9zqpRWE2zEge5YAomCa4MoRqNVyRx5UHJKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/12 23:44, Lorenzo Stoakes wrote:
> As part of the effort to move to mm->flags becoming a bitmap field, convert
> existing users to making use of the mm_flags_*() accessors which will, when
> the conversion is complete, be the only means of accessing mm_struct flags.
> 
> This will result in the debug output being that of a bitmap output, which
> will result in a minor change here, but since this is for debug only, this
> should have no bearing.
> 
> Otherwise, no functional changes intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


