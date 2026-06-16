Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D3CCD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118726B00DE; Tue, 16 Jun 2026 17:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9376B00ED; Tue, 16 Jun 2026 17:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3896B00EF; Tue, 16 Jun 2026 17:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C32326B00DE
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:42:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C526A40130
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:44:06 +0000 (UTC)
X-FDA: 84886196892.15.AFD568A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 80B2640007
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:44:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bFtf/ljm";
	spf=pass (imf17.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781624644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PM8sP3MAiJZZknY6HDXqfIBCoWcPf7VRCGmXyvu7wus=;
	b=mYp6TSOPh3BJj6PSnLxXWVv+T5xHkX10XvS0PNpDH+55ub1bxTPbVBFIA5hM+QYCMz8C/Y
	i7G1f54SmC7eLoMMQP7LYfIAZP6lbP7h3csbfGIazL5YdimWf2JSBMIw1x9a2Ihe+l0RQB
	xf9dCpMg+4hvOGy0IqeEVog+hJGssCc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bFtf/ljm";
	spf=pass (imf17.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781624644;
	b=Fc6q1/bic56a6280XOUiNMf+D73EFPM6Xg/zJbJs/58fIPI9e+rLoNG1Av2c03sdzCevI6
	w/2R0eE5VPKh95HgkVFSSQ5MO155+xu/sWFgGgPyv8G0bU534qMicssBnsQv3z3T/HVsnX
	LQb63mIuooncltLPDxMbGX7OeY4wyC8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781624643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PM8sP3MAiJZZknY6HDXqfIBCoWcPf7VRCGmXyvu7wus=;
	b=bFtf/ljmQQCZwQ+abOXBWrX7JpPzc34SUMIFdGdQfYry8qoCI9w7v+35CuDMLZJOap35Ej
	JXiVb2QdHlhR6sVymkwkXfTQdthusNPKmuRIZY2rY/TguEYAwkTIvqzqwRUf3zKBnX67i5
	oLpUYdOWPRL5Ksdp7kn0g2kUVV/2v3U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-jgGo_N4IM2WI6zmN4LSXbA-1; Tue,
 16 Jun 2026 11:27:23 -0400
X-MC-Unique: jgGo_N4IM2WI6zmN4LSXbA-1
X-Mimecast-MFC-AGG-ID: jgGo_N4IM2WI6zmN4LSXbA_1781623638
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AB4C1955F0D;
	Tue, 16 Jun 2026 15:27:17 +0000 (UTC)
Received: from [10.22.81.159] (unknown [10.22.81.159])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 60017180058F;
	Tue, 16 Jun 2026 15:27:13 +0000 (UTC)
Message-ID: <cca24d1a-f4c9-43a2-8411-5b2919d4efb0@redhat.com>
Date: Tue, 16 Jun 2026 11:27:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
To: Gregory Price <gourry@gourry.net>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Farhad Alemi <falemi@asu.edu>,
 Yury Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
 <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
 <8d3b4561-92cd-4ebc-8462-5fb0fd659e8a@kernel.org>
 <ai_IHvyptWPcTD0y@gourry-fedora-PF4VCD3F>
 <70f486ce-5ef6-4d72-8cc3-7086f4eea930@redhat.com>
 <c1495b1b-9dee-4cd5-ac8e-eeb7a2d968ed@redhat.com>
 <51eafe6c-6622-479b-b391-6d3ff9350e75@kernel.org>
 <ajFTVaMBeu-ViGIC@gourry-fedora-PF4VCD3F>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <ajFTVaMBeu-ViGIC@gourry-fedora-PF4VCD3F>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: boxWzrUxkXp8YSdaRIL4skZ_Vz0XNqqD9rtsSmwvr5c_1781623638
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 80B2640007
X-Stat-Signature: jdy7bu88jsyxszmwm8auw3azp7kcbk6q
X-Rspam-User: 
X-HE-Tag: 1781624644-122655
X-HE-Meta: U2FsdGVkX1899cHVxuu72Ye6QFmqYDI+3UQAQBgl6fb8NCi88C0kQDfEwpD0Pg8WvBHFZPwQfS/n9rcGyRYQDQjT0JzRV2NPlE8oeGAx3wtsqqNK1VTB9RtfDMmtLZmoVPB/i3LGcrn/Pq7M7qZJYOMnHt/9+1VcWi+/DY2Uoxt0J/Yi3NmorPBkGdP8ljYIDRGctcdkbGfO80hkg9nIDtPrrdyVY/Fhe6YhA077EjY1lwZaUsv+y+hHM563n+MeiteQlRFiRcgpxbHEdVjDLvSyDoR54ADfwsYW8pssGQlNc42frGOh7pYDq01+/84BPsiGJSwmMjqHUW0ZKe8ArChSivp8gcn/RjMve+6QQ+iz5JU1zxhD/7369QNQLvIG0zKShyLbjW5hhGB+Fexk9yR4hF7YsZwPIPwMf07FbIR4/xFy3VV3+ph9JL8rTUkocxWoE7fDNylig8sn0M0VgVjVzcyKFcZW6iEjXqzjUtlxIb5Z4GDewAlduSKDmQxxBbdumg18BrNsD7ADWXdCiQ6v6yyolPKaY+Z1lMBLcBPkUb8DcxSUhhhW3tiKAtH3kdbYk7bf75JUHxsLQz4+4jq3zgf03bOxfSWxFyKrUGmN34Tnw7nXhF4AW5faveHnP3j3JSlAvUXXFP28RfcjVCYMmgjv5rcdOWnhSuF0wwy9MT4PH2WXw4mu9tXA1lh4LnNj5SF23FQeEyHgcVCktDf7ISuV3MOrm7zDBkTS1CgYsxMgaBWX6BvRdWVWA4CTdOkl+zAdRneykd9/s2BT789ax179HXxCni0jvhCUlItn/SNb4Be+1EsMTML3D/YsyRh2Wxo9i8VITzbpmBOwIONeRFO/ouEiKGRu5X85GprECF0X++t7Ol2cXBdBf9yfZxvWG1PSS8HG7gMmuBACT0ijtGAbHHwaBaAJ4VThF9vStdlwmcVcMI19Hf6fS/ALzvXTSo2XpstoJiQmu6V
 L7Ph2Zw1
 mR5ENWJ3niqCoaJcARGxv/e5r0KfADzHk1xd4dHNRsMwTXL92vBM9D1QY6qZYMho8Vs8Wc8IbZOt8yWdcCFUxOYAB01N05KF0Nne9nbmcV4A0pQP2WKPuZPboja15xwa0al/28fv09jrtk0KM8wzye62M8i5FW221Ut/gEHBnjyKag0uH5vS9PvR7LYNlKbzfMMzbefbwXwIuBPlL7q6Wkf+Yy/AKbYVQ0kjs35Rmc5gSKIX2MAsaSIt+TYxpOsisqR5e1lMYbP87vsMXG2IOUMr+8zAYpPA/P37/h9GGQHbNVc4RLhlG8Ju1u/Qhk7vRAhuocBHWANUkk30gVapCbW8cB22QajbctpHp112ugYOBilo3s43plPpU17c5Js08AxbphK84AKecJZhQ3hTQQ0kRb7P5ZZObHNY8+sU4cbC4hN2Ll3TmNmfNMSmJirwKX9oy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/16/26 9:44 AM, Gregory Price wrote:
> On Tue, Jun 16, 2026 at 08:59:07AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/16/26 05:43, Waiman Long wrote:
>>> On 6/15/26 10:26 PM, Waiman Long wrote:
>>>>
>>>> The reason why I am suggesting to use cs->effective_mems to keep the old
>>>> cgroup v1 behavior. If the consensus is to use the output of
>>>> guarantee_online_mems() for mpol_rebind_mm(), I will not be against that but
>>>> it will be a slight change in user-visible behavior.
> I'm not grok'ing what is user-visible here.
>
> The two values should effectively be equivalent because we're
> using this value to constrain mpol's during a hotplug event.
>
> If the values differed, you would be saying there's a race condition
> that could affect correctness of the rebind (which can't happen,
> because this whole thing is done under the hotplug lock btw).
>
> Can you help me understand?

The effective_mems and guarantee_online_mems() should be more or less 
equivalent for v2, but not for v1. In my response to David, I gave an 
example of how the behavior will differ.

Cheers,
Longman


