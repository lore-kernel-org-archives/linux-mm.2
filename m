Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC66C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62EF6B00AE; Tue,  7 Jul 2026 04:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A131A6B00B0; Tue,  7 Jul 2026 04:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7066B00B2; Tue,  7 Jul 2026 04:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49E7E6B00AE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:31:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEFDA12038E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:31:57 +0000 (UTC)
X-FDA: 84961312674.14.8424865
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E05A44000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:31:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eggo2rgi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783413116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzX7mzeA1AC6coQRpZsiU7J4pYqQofYIQYGr1P5+3wo=;
	b=ZpkxVG/HY99i8NtdlBI2yg8xec0ymNJ2IyqGeD/o3yKX9OBqfmu31Gst1lzEvHML6rmmbD
	WZDqw52ncbvhapVHJi1DrsXYMXu4s+QgKUHONZf56b98UTWZQkIAG38algSYFBUFOERZGZ
	7/pDZjN5FgYJNVk7SaCpLrJ6oWVR3jY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eggo2rgi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783413116;
	b=0I3zQSVbzh71wkaLlvpW1TdQGSH0qpETvO4+r6RygCMTC6zwv6NG+UMW5DwEUAloC9u6Jf
	muIrg68RH+OmWqjKclzy8mxm5/wyaJVs4UNr0yBDWaOv8DnrFfnYU9ffVD5rk/xaptkmz+
	DbPMpXYAS+OLIu1ta1fMvi+7xrCrWQo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFCE741162;
	Tue,  7 Jul 2026 08:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D571F000E9;
	Tue,  7 Jul 2026 08:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783413114;
	bh=fzX7mzeA1AC6coQRpZsiU7J4pYqQofYIQYGr1P5+3wo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eggo2rgiLbJFk1vCjCUu/Dz28j26GN6Yu8vt3wmgUN2a3/ieZTz1zPjKBfib9h6xy
	 h1kW0Kun/1QSnKKMyh0ugyQqkx2lPDUFRNoZxx+9cgkxggHn1SyFT9G/thAGmjP5rI
	 6hiWA4RUk0otidjZMkPV1iBpjb+ZUFHYFC/1T8/ykz4bEULihjbdg0uaapwovv/uYI
	 xmHOFwYd08Qs+bHg40UHoMAn//hmg4nif2GwDTXChpwsRiLkil+2Nywtilwf0gH2tO
	 uuTaifCgJO4uHlEWrO/JRc/XMrIpjQeYwFsBWlF0tj/wqeCrN1j3UOXCGVPg2V91R8
	 Nz3pjSIB/IlNQ==
Message-ID: <0e8e5a28-1111-4b81-b04f-b81e749eb3dd@kernel.org>
Date: Tue, 7 Jul 2026 10:31:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
To: wangtao <tao.wangtao@honor.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "willy@infradead.org"
 <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>,
 "kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com"
 <luizcap@redhat.com>,
 "zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
 "kas@kernel.org" <kas@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org"
 <liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
 "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
 "jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>,
 "harry@kernel.org" <harry@kernel.org>, "jannh@google.com"
 <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
 "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com"
 <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "damon@lists.linux.dev" <damon@lists.linux.dev>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>,
 "jparsana@google.com" <jparsana@google.com>,
 "dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>,
 wangzicheng <wangzicheng@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
 <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
 <b00a03d62c53430ca22b3f3c5e5327b5@honor.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b00a03d62c53430ca22b3f3c5e5327b5@honor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E05A44000D
X-Stat-Signature: grwhprukqhzumsxrc5pz95x85tbfk69z
X-Rspam-User: 
X-HE-Tag: 1783413115-619131
X-HE-Meta: U2FsdGVkX1/Ny/ETQYPL0TrgHkvNrEcevzy73rynlKFTcCK76ImgazrGJ5z3Fz4eyVFqGHKpGJ1wXlLXmnUUo5++Q3o6olSgGrhZ3WxKATzIudHnEeN/nn2PgPewyprPk7P+FKLcDW6Qx8y/6dgDTSPRqxzfsNyloZNVPdBpo8HwzUxnhYnfo4q6SH4knU3Gu0bxI5k9Fvzv/MOfJ3JLG+iWJI7U9MpD81qpegePC1CYNuetE0/DKveLuZTnfPr6gNgk2ukzC2OvjDTEEp3afkbBx6MwruSLU2F5Be6Og86RZ/a1BUpU5LdPNyUz/58V4bHxofbmO/zXClmLtRuqY404TnCvtcX4G2WwuP7zbdBdV2GR1dzY69fqYVh6Ri/QTj2MDlMv5Ct73GpMKEqxvEOBXW6z5EkXOapGe1afg7j2fA3qN6QtQshigFU54430KPYx5OkC4UUwt+Sascz4xXun5mfmfjjaRGiyejx8nFU+sw2+CGUMSJ9LZhOcvCpj0TY7lfjkaZf4E6aNEPuDlaUa7duFhcXTxmZz5RW3MN9IJnhCb13qgSMuRsEvF3hfeS81fYSqT2sF4mR6SfMKzZbhtMYVLFkCjym08SZP4h9LkbVXvE5U7IwfI0wAKamJgIBblBdIbeAnjjvMeXZ9cGWOpFsRG6/NqKEejgNP9quA71f0PrJIBPoJCiwuhKmVppw9Xxo4JcAYsrl3ZGdv53YTLZ8Z1G6cFlpeGY1BHk+gKVVzm2QKuCnMk5MAxVEjBPNB2UVDP7BlVjlTVp4hN8JW7K1honJ6v/lSN2a2rOryKzLs74az7pA71Y50AR/7SPjM2/YENvNiDK2hax6Y4GyUpROmgJTG3ND44ZmJrlXRKV+skrz7EdQWp17LRjMrjCBsKiTmJk+xxgYK6OvyU9zrA8bFsqU26h0pT9JLPrcnPH8Gz5PD2Cmk8RUjLAEAko1Jx0osKr5LjsHuYQ4
 ATbYXN2Y
 7PnVBC3knOghqtNvm/dnKtBCtDrJNiYX/78sEZMqKx6oek6oHImMi3fHRw4Swbay/GvLPzhy7/P3c+co/QbxrFk22IaHO+n6/HcUuvO1sLwDjVl+DWO5Jle4TFRymMlogBJIHmdMAFWgZGG9EOOXJQRuFsHxeUFOBNbM8XrG2/1DGXEFdQeTaHfQCYYgh27JUlzU77qvpJeankmxyjANZbETXSsbxmKT9EC6kfL7/DWv3FFweG1ZE1Idk2xqu8krj9axHuUXXKqEvaIv0hA4BCRgVQdwWIBGLg5QnS2gw9/C0VNFTrdBNMAxKp3AV9LKjMRT/+V7H+NKpVSSgWByf6DKSxHcybq8ZQWaSDe86SpjiBMomTGooLckLz3PUyHjvIoQ/NbP6DPW5Hegjhi6VIMFobgKtMpweXiDP8h6VSkJi2laxJqvPGAqJD9EBHiot8719
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 10:21, wangtao wrote:
>>
>> On 7/7/26 08:32, tao wrote:
>>> Hi all,
>>>
>>> Since v1 was relatively complex and difficult to extend, this version
>>> adopts a simpler anon_vma implementation approach.
>>
>> I really hate to repeat myself, but you seemed to have missed my main point
>> [1]
>>
> I saw it, and I’ve waited for a while as well.

Apparently you saw it but you didn't read my reply about slapping more
complexity on something complicated.

 12 files changed, 1056 insertions(+), 54 deletions(-)

> 
> If there are technical issues, please point them out directly.
> Or is this simply how technical discussions are usually conducted in the Linux community or the mm subsystem?

I suggest you go back and read my email.
-- 
Cheers,

David

