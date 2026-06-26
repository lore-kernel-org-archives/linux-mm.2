Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95755C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871066B00A2; Fri, 26 Jun 2026 10:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821166B00A3; Fri, 26 Jun 2026 10:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB966B00A4; Fri, 26 Jun 2026 10:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 473D16B00A2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:38:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B52298DD1F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:38:52 +0000 (UTC)
X-FDA: 84922320504.23.2C398C1
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id DDDA1180003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:38:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PhqJhoG7;
	spf=pass (imf06.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782484731;
	b=wJe5GxmYN9ypzdMNTw1LOWVYQ+kakw4aiSTs1ZrtzV7RxI9BffDmB6IfgXRxyIhSrGpJS4
	A4C/WE7m/dpJ+8rhhVJxpfx5SbmK0FtBN5nXlx+clg2KQ1ruYEF3CTerjfzsebq+8TVNNu
	o8RPvfXIxG+xBU9FV1AupJ6pfpIES3U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782484731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywfVVfHIaMt446COgp92lwZKXn494SDuKzJCEPWrxoY=;
	b=H7jpveC51izbU39zmOIvEka4DjNlOOheJkOwef1BMsTfFjcgwP1T/EP4YmB5A5zdcohezB
	oIkQXVKHUZSMNi4In1HE9o/dmjiECFP9PJnc0JLiSZ71lojYS/sHKV4lVPV6ewCHYk2T0N
	+h7qRD38KT2eS4eMMe1fjCizUHoBV0A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PhqJhoG7;
	spf=pass (imf06.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782484727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ywfVVfHIaMt446COgp92lwZKXn494SDuKzJCEPWrxoY=;
	b=PhqJhoG7u6ok3Ih9DjMgoZ6ovI2yjIinVBsySEs7Qw3RiK/Oq+Zc3N2SAZXs+yXqvd1E0l
	e+iA7cqchVdYTpQQvBZjPyxy5YEfiGxVaOtpJD5Y08vSFQLRDl4gghkSy9NlCsT02LyeaD
	kIpat7BwpGr6soNSeerUQ203dXuim8w=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:38:29 +0000
Message-Id: <DJJ23EXF55VK.1EGQZS511HFB6@linux.dev>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
 <linux-riscv@lists.infradead.org>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org"
 <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
 <yuzenghui@huawei.com>, "will@kernel.org" <will@kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>, "willy@infradead.org"
 <willy@infradead.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org"
 <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
 <kpsingh@kernel.org>, "haoluo@google.com" <haoluo@google.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "jhubbard@nvidia.com"
 <jhubbard@nvidia.com>, "jannh@google.com" <jannh@google.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>, "skhan@linuxfoundation.org"
 <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com"
 <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
 <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com"
 <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jthoughton@google.com"
 <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
 "alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu"
 <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
 <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org"
 <chenhuacai@kernel.org>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
 "gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com"
 <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
 <shijie@os.amperecomputing.com>, "svens@linux.ibm.com"
 <svens@linux.ibm.com>, "thuth@redhat.com" <thuth@redhat.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
 <urezki@gmail.com>, "zhengqi.arch@bytedance.com"
 <zhengqi.arch@bytedance.com>, "pavel@kernel.org" <pavel@kernel.org>,
 "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
 "vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
 <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [PATCH v12 01/16] set_memory: set_direct_map_* to take address
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-2-kalyazin@amazon.com> <aeeDvpDnGnY5n69n@lucifer>
In-Reply-To: <aeeDvpDnGnY5n69n@lucifer>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: prh6tt5pkjg8g5yqxty79uxkk94xs38i
X-Rspam-User: 
X-Rspamd-Queue-Id: DDDA1180003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782484730-929497
X-HE-Meta: U2FsdGVkX19i8ZyOtO5xURKBl7nj/iWNsj82wmK61TuMT/A6ukkhBUJt/PMLuddoMMlS07Qtf/JxsNKZT1Q4vNIoZe83h45cnQchf2QnQ0WUQjLexSvOvZag4OctF6fFAzq/11mAYPS2JBsHsw+kjHTIEJTZD5k9mRvP5umuOVJIP48PM0tuG5vsq83k+Ynz3I9Zt7Oi2p4uVX+HZsRt8Nu3elkMPoUTs7LBItcPBDxznoutaNffZKiIyqENR99huRlKZ+3/YDIQBGlXflFGQNKp0UDqe7IpQb1zP9LqgQiGEJy9j/ohtMije08dMUF9mquQYDxMhieeVZTVJS3gFbujiC0s5Q9yzVbHD6cXwslxKIcaKBmPB1wG3fltdpR+GJh0L42xE5n09xp1kSeK3NSoNP7nA8KD5xmTJlWApYRvJxiFwZHNuhgUAD05YjkNCkETxqb0MHiypWK2v6bt0nAHx1HEHHGUueW2FHSV2ZMqzZ2yJ1JKW/c8SULFPuinbIGRjyZdmalOYFDfPcrQKulPJRtQEuFDmH56UidpifKjg1yumHXX2JJQthA5aVmvWVJ8xBjOeK5j0QD0Gj9dzV+/WeGGFtO3Et1FXbSOSymORGlWjx4catVhalbpfnM9ewRFdBB4AWoGwoxnyIeTOQABh0IAgUJzcODrGMTp2yUeuhiV45p+cqLhQkKKz6wExqu9gQxqm3ar/ZApnh6lZOfUbJ1x8sq5yNzNe8Q3gZ9KD2SCdL9h4zvO1XTq6S2Dij5sXx8eDmWKjDmlkG5ELZbSOfowkFuVaZqb4E41BFeViqKdJ3MGs281fXP4+1+zdHyIo+v4xRJ/7K1B1K+Wh+ZEfEdrlRl8HlAOnJ3g9/vf5oMj1vCermSRx8/SxfEgK5FSDoIFOe3clr2FpWlmkNM6m+JPhGs2bQ4cOSM2EiT+kzbSJf1gXaa9bfLeMSErm8Bo6QT5axmIhWlu8jc
 wnGvH5+E
 8JhQfAkZgRr7J9uee5xn2gRUNP8d11t9Rr/8+d2gNup8ULi3GKONaYmrfrKcplBRPUGHiFsmDXfJaPVmx+kWMiriYggozvppjvj1i8z2tcPbQ8aLOHiu53CthMAuGUWGU1UhdSFvpI0TnVWkHf+9SwixXTsZuB/4cKvgh7sBGxmETQghkAR61vXonQ5XgPLKatY1LyJRW8/Jljke68QejpklEGWQghOScc57CqW8Cf7WeZ57mx2SIGbWDGp+vGnMpuC5yoyEuSsaSnUNwNnxFuL3P//oS12lO8w++vr6y4+MaQ0va1nPVkAbBOsqj9xY8PY6NJ6eAb4NoviTSBqzwo9IQeqjwrYhSrJvnByYNlrUaYKDUtPDLNAi/aZAZWY3IYa3Juc9xiKQCzOSiCf1JbBHYuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Apr 21, 2026 at 2:43 PM UTC, Lorenzo Stoakes wrote:
> On Fri, Apr 10, 2026 at 03:17:58PM +0000, Kalyazin, Nikita wrote:
>> From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
>>
>> Let's convert set_direct_map_*() to take an address instead of a page to
>> prepare for adding helpers that operate on folios; it will be more
>> efficient to convert from a folio directly to an address without going
>> through a page first.

Why is this more efficient? Isn't it a purely compile-time conversion?

Indeed in the current implementation folio_address() is
page_address(&folio->page) so it still goes through a page anyway, no?

I might be missing context here about how this will look in the
memdesc future.

