Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BEDC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB246B00BC; Fri,  3 Jul 2026 10:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A39A6B00BD; Fri,  3 Jul 2026 10:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9B46B00BF; Fri,  3 Jul 2026 10:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 153516B00BC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:55:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A7071673D0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:55:00 +0000 (UTC)
X-FDA: 84947762760.12.E3CBDDB
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf30.hostedemail.com (Postfix) with ESMTP id 99BFE80002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:54:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GoqgUdNe;
	spf=pass (imf30.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783090498;
	b=TVEwXAYW3M1wF51dVWth6vNYP6d3sYdv4xIfH5l/LehulPPoAT/epnFZHs9er3IH8hJS2q
	j3iTK9k7jdjiwmlNddxqpAYEAJZA255yxKHC9Doxn13wYp0AlaRprzwdDEhq22dLgK0QQU
	StGulrXd42sIh8bSVKpXOpFy6WJ65q4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783090498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbPuoxe9/8K5nDiss1P1G+SXa5cD6+BbCbutJ10O3gA=;
	b=DN11hxu/MRf1npdEUBozim4zE4SuuSCBs9wkDW8/JWgCFYBTTp0W3DVkoeWF0Wz45Vy5ms
	ZXR/i8sQeqaELbIL2cE+D5Cp2V58HAgOU48MEtwhTm/w4mRy6Ia7bbks8ZZw9vo4rpHj6B
	/Q+UZzpRSP4JjZQDeFvhC10fXU4QTas=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GoqgUdNe;
	spf=pass (imf30.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783090495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbPuoxe9/8K5nDiss1P1G+SXa5cD6+BbCbutJ10O3gA=;
	b=GoqgUdNey9WibpT4bCWElWCK/Q8ZarEulgJnOwtH8yUYJA68i9+SGQflaQqhfntmLTLqoe
	eB23ClEBpn2xCd2QuZuRlpe/F6BVVRjYG8MpJKtoXNNPTsnfkNo24Jc6bEsuCimTjf2nDr
	Gtk6mCa7gTMDQeIwZl5Jn3GGSudvZ6Y=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 14:54:45 +0000
Message-Id: <DJP0TON6OW7J.EPYIYFFA5ZOZ@linux.dev>
Cc: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
 <kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
 <linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
 <linux-s390@vger.kernel.org>, "loongarch@lists.linux.dev"
 <loongarch@lists.linux.dev>, "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "suzuki.poulose@arm.com"
 <suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "will@kernel.org" <will@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
 <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org"
 <david@kernel.org>, "lorenzo.stoakes@oracle.com"
 <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com"
 <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
 <kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
 "haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
 <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
 <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
 "jannh@google.com" <jannh@google.com>, "pfalcato@suse.de"
 <pfalcato@suse.de>, "skhan@linuxfoundation.org"
 <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com"
 <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
 <yosry@kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "tabba@google.com" <tabba@google.com>, "prsampat@amd.com"
 <prsampat@amd.com>, "jthoughton@google.com" <jthoughton@google.com>,
 "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "aou@eecs.berkeley.edu"
 <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
 <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org"
 <chenhuacai@kernel.org>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
 "gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com"
 <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
 <shijie@os.amperecomputing.com>, "svens@linux.ibm.com"
 <svens@linux.ibm.com>, "thuth@redhat.com" <thuth@redhat.com>,
 "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
 <urezki@gmail.com>, "zhengqi.arch@bytedance.com"
 <zhengqi.arch@bytedance.com>, "gerald.schaefer@linux.ibm.com"
 <gerald.schaefer@linux.ibm.com>, "jiayuan.chen@shopee.com"
 <jiayuan.chen@shopee.com>, "rafael@kernel.org" <rafael@kernel.org>,
 "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
 "vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
 <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek"
 <derekmn@amazon.com>
Subject: Re: [PATCH v12 02/16] set_memory: add
 folio_{zap,restore}_direct_map helpers
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Mike Rapoport" <rppt@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-3-kalyazin@amazon.com>
 <DJOUYOKL6N3R.BFIO8HEL03OA@linux.dev> <ake7aPB2O_-dAXhI@kernel.org>
In-Reply-To: <ake7aPB2O_-dAXhI@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: dbd9hhzgmk8r9ux5c6bhtcyi9gxtukzi
X-Rspamd-Queue-Id: 99BFE80002
X-HE-Tag: 1783090498-603482
X-HE-Meta: U2FsdGVkX1/FwOdNp3GJAPFqcSn4HlZv9Xmo9HH6LNi4/0wLHhdukIu/zBzHXfBPWueQW+SQzGmwHdpyTwJ9q1p2uinp2B03B8HgPj7AqwpaEnrGxwhU/koZCQ8iMUrjoB3yEokc0RDpu9u5qymviESANvVdjfsVEZAenacBXDqFZdVYP5CWCdyIKsUoHaJ1TYWzj1Pr21VeHveJ7lhJJs2vqFNXi6qOfkcqviz6PTUDDafgpDXPc/5W41yUCpfW1M1NBZ+dkWnx/GmJIMMAv4UXmeLvMB/jJUtGdATfFIYMr98vKcy0rehKOjBg1Q63Gs4wX1VaGT+fqLiTYG/1HUzgKJXCFczKrv8Ncksl9nVTSh4tGIX84UbfNb63zMOkdzbBk9IgJGes0eSQOmHtR2J9HZNpDMeseeDU+79iKc5yQ6EN/Ygzw42T1Q107v4S/qNOF7lTeXz/iMRmPdY9cKeBaxwVjyP85Snvy+tRv4clfbGMp0Yle3YjbyNRsgwgo/0gfYYwH64kcF7bN5am+0ETwatPxa586SafkXBF5aRBS3JNiYqGjTipp+9qyuiRGRe7w1zbbn0Fhp7AMhHbSVn5bA9tVQeuvMyyqIcvL1CMDmR/MePZeYQ1ZC4dfrtGffpU8sdwMXPxTtIc/8bioa4PUr9wFD9vcYlpLxA90d/QXkhHlyXibsteLI167Pc1a61ov8R1OH7Eml7gnjGf6Pdj8cJUNJv9UYHJ/gUg31CKMeiZq7uGpyLp7iy7LZj4FXtBrUyPN7jO73XbzS+kZ7GgvOz3AC/QgUnsRiX1y+i1XnKkS2SnVau2HmuPN6yTzjpb+cyXsS8dLnrWzaRtDA/lD8sBymbK4H9BI2b8HySUyt2nSWjR+9b72x+cLSx/uErrzWiYJrNK96/hb1lm26FbrNmZadDYy1YkYaSh5SfK1B15NG4HJ9jElejbyexWiB2OD9R5oEZ1/0lUlad
 vI0dGlLL
 ma06xISyUDeCk6E44Viry1l5Ctz5jlvIBHkK03rB17QgP6BmfoBFRvehVJY+JB0cJQMkHNxNA2Iv5RVvRWmzTUuYwhiM85eSy/hQeWfeOaEwDrX8G0FYA2cal30fynU7ajlNjQWXqO9SkD6DsEngkxxIwxMQmK23JcAke/SdDdv8syLAeZx7yLWts8OqH9JVjVMKHr1azF21O5I3QokQSfkoSgY9jyXSQ3Yux/2KQQeoicpg2q//GQWYJj+Y8NcPvbSbpDoYCwTcBFIwL57c7M1BTxpvyakB2WvmT2Lld4Nydt8TmOlJ45d53G/8HkdVvIgq1MOvBrNO12AqKT2yxe2ctWYMAfSKvGaTAM+3TZRJoYl6g0dZy+5tMQOJG6ZT+kDpFHplZrYy5kVyqANSCK1MZSXP80LQGmhcCxn18/cRex6NaPlIPf3xr9/cFWwbe76Gf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 1:38 PM UTC, Mike Rapoport wrote:
> On Fri, Jul 03, 2026 at 10:19:10AM +0000, Brendan Jackman wrote:
...
>> Alternatively, we maybe should disable secretmem for highmem systems
>> since it evidently doesn't have any users.
>
> Yes, please :)=20

https://lore.kernel.org/all/20260703-secretmem-highmem-v1-1-30d5ff944664@go=
ogle.com/

