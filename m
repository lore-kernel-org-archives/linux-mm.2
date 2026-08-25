Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA7B4C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAE56B0088; Tue, 25 Aug 2026 13:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792376B008A; Tue, 25 Aug 2026 13:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680F86B008C; Tue, 25 Aug 2026 13:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC856B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:34:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C133B14015E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:34:49 +0000 (UTC)
X-FDA: 85140491898.28.D568850
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E8B82140006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:34:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0Kfdsgp;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787679288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBtQZGWC4Ugh0+/iEMWJovjl+7Q8gLykzrTSJVSRweg=;
	b=vLoBA2PTojFft1eyxO09tMk26VTCRxiiHA8H8yujs+XyVo7WV+cGmbChl3wsR0tXOyykFw
	glU+U/KulQCqffZmkqZJDtpvlLFpy/k9Qbtx4jxA/OCMNewjp18t0qFWChlYTlDuRrSh0i
	7cIzkJSbZgnDMm0sZD5Ija/C/qbBzy0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787679288;
	b=0Cl3AXEQxnT+IDNXnB4az7UAD8orR/OQ49hOR3A0cX6jTpTY/ycT3CTvbBo5ddmPstrnGu
	Ut20WojT3qYLdmXR4JhLiVlAt+AEnOduZXIH6HYJej2z8gn1quEjlU4ZdqT46SBhOI8llg
	2VHUBox+CYS8qmkukPREpJYr0FFxLdo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0Kfdsgp;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F47140AD9;
	Tue, 25 Aug 2026 17:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E12E1F00A3A;
	Tue, 25 Aug 2026 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787679287;
	bh=XBtQZGWC4Ugh0+/iEMWJovjl+7Q8gLykzrTSJVSRweg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I0Kfdsgpt2MNBf64t7Qf9F2ffnbma9jiMHAcZ+1Y0aUTT06CV7cZgafPnY7haTtAb
	 vKD1qp443An/6+T8qahH+kSL2VEn2AtcwHENoXttNwdmypQLLH2+SM6KkjSfnsICRC
	 dFLROykYYCG++15ZPcEcxiJsNO3YswU1RDcPeIMTQJsLWuWlQh8kJWpYH7oLz5izXZ
	 q7oue+qXoY4JihTk3nKrJmGnyJCDGH9P9PxrlkebEa+17LNZArtuRK8Ex0EQwpcUzu
	 qBShWVzolwP3xvc5Z/TFBWmGmGcKzMOPPMGiSd2V2UMBmGP7MbeAAL3/aruLgsktLH
	 fchjhvFkNvhTw==
Message-ID: <1da189ad-a7f6-42fa-a1ff-a26cc5e5c563@kernel.org>
Date: Tue, 25 Aug 2026 19:34:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>,
 ljs@kernel.org, xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, usamaarif642@gmail.com, yuzhao@google.com,
 aarcange@redhat.com, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com
References: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com>
 <20260609172719.803537-1-usama.arif@linux.dev>
 <CAA1CXcA84BtQZxOpE0sWgb2ed6y3m0NLKkWD+5MfWS9eF5dqTQ@mail.gmail.com>
 <a464c20c-8b41-4264-b560-497ed91cbaaa@kernel.org>
 <CAA1CXcCsqkV2PrLicY5BnOMp+iJWJxsPn60g_3WXugWQqOFYpg@mail.gmail.com>
 <0b268070-95d2-45bd-aea3-56cefe01dc8c@kernel.org>
 <CAA1CXcCp0z0kw9pQtj55qNGOBJOpfDsrf1GJ+EhGZCfA+dhbKQ@mail.gmail.com>
 <004bdc87-8c8e-44f8-93c3-1ae0a47051a9@kernel.org>
 <CAA1CXcA50Lfeo+JkhhRc5b8TNzBETj8+z6iMVuqwUSJhyo2G8w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcA50Lfeo+JkhhRc5b8TNzBETj8+z6iMVuqwUSJhyo2G8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E8B82140006
X-Stat-Signature: homoiiqdoer44csobaz8texxsknpx6b7
X-HE-Tag: 1787679287-70360
X-HE-Meta: U2FsdGVkX19/ikioizHy21OZTsT+kqNh3Tx6TS3SrOOsK/TmMfYXJWq8hHw9hzoxfmICcsaQGbxCLiTHH5/V0ayOEsINjqOSM+O1tnbyKg9goIXfW3fXjQpU6xw1+3hmjWOLyBVH+wTwRC93Y9VBr05p34QmII9Ee5/SfmUQu9Nn/6Flnx0xT/8FjUM0A+kqx7rMM+VlEsFcGTXGuou0usTZ+RHsFcRlYUOmHX5d1SH5uEJWPKB8udMIYHb9kdJQCSilHBg2O3O8tHK8VLKHe8Ecwtr/D0sR4jHZO6f+nG6di/OKugtCIQ6WiHXKWZ4LFCc2bqm7TzxHwhd65R62NDYZEdRuU6C0GirPASAs+Fu/D++2mQgZGw15n+Gz3ezL3FW8XJy3+vOWIzsEAipex+gGkeoRbp+ScU2wu2R6iieNVhccJzwLGClLLOC2uGqZ7L2Z+6Id/n+hu0XnG0CO2Djoa6EfYYuwYZhuJE2sWid7wf/8rZLYxaBRhEzDgCRvG+v+TkmVR7xnEpGtFLRK2gKQw1ZQX1MAAq1T7EoNJb0dhdiRHhIkFPsJLDvDC8+095JUj8K7Wmb32ds3+8aN0s4nyP6YNceaJ+xzP92U1JLh63+niZuxgpFrZsS+YrQr54SpwsS8vMM7JxqEaty6lQk/ZtLPVLiJqVlF0j1IccMPCOxswM1TC10ipMUtnU5XO1kw6tFm2mxJ/1SeCFLIApvm/q4tB+AF5JnpbT502IQfmr2Th3pLrubVCq1vPh6+Su9PbVqkL9Vy8AYOIuv7jsqPym1DPfRdzbIAyp9cf0aXjeqYayzbiRChPbLvP9+OjPZVsezQkCDQdH6NX/rQfWIJsc8rv23Lid2ZonH47AQiXFcN+cb/4YR6Yw6CxZwHw3TTvNKiXpKMlbvk8gvRu4hnExGRQEiHpsPUnCgbwXl+ofeLwZOIXd13Pz9o5DNo2PWmllO8tWkAlrVjd8r
 ZJYR9eYB
 AO8cHROdBVki0MhepEgRy14EBBX2meMBNJ6ard5IDDS3AgP7B0Eth74COjX9m6tonHbokgb8U+DKxZDbmUC2Djy3opD9Bhk6eocCF0OxAKF8Ok7PTPqwrDP0gShJol2f63SxZbae4gi5jGE2CkTG1zOMVGjTglYBpTbEr7lkMNeQG1NXrFVr6/NiII+8ysiok2ewRyKmqtuln6SAHBZ/Gf5PjV2G1BsIc6udPyL2pyNn0oU0y6SjhuBDOA8ace66bfUc30lcdramxJgr8ZvT2i4csK/+kP9hfoWHZ3/b4yffbf0mjWlftxGrjQi9ZSVFZc2joq33VwVgMSfWuXk6QvJ3WlLNpCruPemxUZXq726erX5TPwMXeqqgk/lHYrGGr74Tn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 18:27, Nico Pache wrote:
> On Thu, Jul 30, 2026 at 2:34 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 7/29/26 18:54, Nico Pache wrote:
>>> On Tue, Jul 21, 2026 at 8:02 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Yes but now all VM_MERGEABLEs lose the underutilized shrinker
>>> independent from weather KSM was the one who triggered it.
>>
>> Because KSM takes care of it?
> 
> KSM only takes care of it in the case of 'use_zero_pages' being set.
> If we stop KSM splits from reclaiming, we regain the intended sysctl
> behavior; otherwise, KSM splits and reclaims indiscriminately. The
> secondary effect is that if we don't have this toggle set, the split
> would still reclaim these pages. KSM then has to process those pages
> (despite them already being freed), wasting cycles.
> 
> Your proposed solution works too, I just think its a more aggressive
> approach (stop all VM_MERGEABLEs from split-reclaiming, not just those
> that are currently being operated on by KSM).

I think we should really just stop two mechanisms to compete entirely: if A is
active for a region, B is disabled.

Not trying to follow "who split what" and operate based on that.

-- 
Cheers,

David

