Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E7DEEF31C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 08:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1236B0089; Thu,  5 Mar 2026 03:46:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1926B008A; Thu,  5 Mar 2026 03:46:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB9D6B008C; Thu,  5 Mar 2026 03:46:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD7AD6B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:46:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60786BB9A9
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:46:01 +0000 (UTC)
X-FDA: 84511376922.08.77D5EB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 79FF880009
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:45:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNkwpWXC;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772700359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttQU0THMP6cO57CAgYBq0vHWU+4aWMEJlwp9h80V51o=;
	b=TZWjEQV4Nu2vFDzJUMM8gg80H/xQs7aN7uTtayUKqentjgVpGzM3yKZJmlpNCqIuFPeuma
	d9bs67wragRf8eopRZRz1IJR881BlVGySuMbCt3Qojbg6Yfu0SAqgSwo1dATAl/mcV/fT9
	a8msM+jyLWXxR3JaOg1dBgDfZM038I8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNkwpWXC;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772700359; a=rsa-sha256;
	cv=none;
	b=RvksVeBCeLFsdWDMjbUlifBsCsm1/wGA4IRbDS3ETLZ+6kMVDW9t+Bud61btpPVc6omY2b
	ikC3jqcNIe3NxzVtpj7qRetW4SdEV2rt41+tYxf5OQ+Om0ciIVgaq/+WiWF8m+6B7I5DKx
	yJPqtxpm7r1y9jWoAH1soAAoV/l68yQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B88340908;
	Thu,  5 Mar 2026 08:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8E7C116C6;
	Thu,  5 Mar 2026 08:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772700358;
	bh=s6pLjGUg2KXOqOul98dDTFwqWjkNiixnlgGf1DeELvQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eNkwpWXCCwpzVVy4+fEqwpuyc5ESopWXOVNu7wBXfG4yZwnYR0o0PiiioXRuepWgS
	 boX/Ep3agnqb7BRov2vB4siErMYbHjzcsqXocMwmpII2XNPfl4XIwaK92GN3TOD3LW
	 QNwFDF7/e6SJVEeOMopZmlNiQBawjlwJczyTC43ZJ+II9Ervgg4L7StTLhm1TgLI/h
	 RJIe7nWkp/mjU3BEgt+HJmDn5nT8KqOtAVt95sY3BjTQ5k8ghyKL65MvTcPzL3xdqI
	 mw1FiDZ6YnLQGYwVDox+lSMFm2EC38gNq5jSZBpgqcRNLSfK3tZE824ULQ4Vk1w1x5
	 qY67ZDkmkw85A==
Message-ID: <650cda1b-bc15-4d41-b6f1-d85ded0c7872@kernel.org>
Date: Thu, 5 Mar 2026 09:45:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Usama Arif <usamaarif642@gmail.com>
References: <20260304155636.77433-1-david@kernel.org>
 <aaiUmx8yRsn2LBMW@tassilo>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaiUmx8yRsn2LBMW@tassilo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 79FF880009
X-Rspamd-Server: rspam07
X-Stat-Signature: wxied649ki6jc78d8dn488qs6j7iu1mm
X-Rspam-User: 
X-HE-Tag: 1772700359-337629
X-HE-Meta: U2FsdGVkX18jycVuJVbm3v8ZvqOrYwD6CTLiruO8aPfcJlg2obrAduwicAxDaXjGazf9GTX0JeRGmHx3MUUN4X0ScymOF23OVJpTtsiK+pYymlqC5alYqFmIPuun1b835WISOOhBbK2WWS51DMCIuH9X/4kt6wG0wxzOUjXabCbrmhAiQ98bHF/J6oHzSkE/fTystcQoYVTrajTC3HYVN5uoc7KpdnaFzwuobP7jReAPunTdkmg2t+RWGSuEk5BCuCmWvJXHrdlDJB2uTwXwewXBvLrvZx3qf4JvOr+44pjWT26QVfw1a/NdD/uCndxNRz9sJi0t82e7+v5HsfItxzSUjOdU1Y+uUVLjuNNssZ6itBovBtd06Tv2NGH/yyGYynJUnBPORWxQ8dOilzPgikwkQSoQKiVMZZMVz0hJ+jjlrudkvgXX7skdEgZXYW1+5MuB30oref2BDOTeFLjbskivP+XINgJXk7fBmhauzs0Xi9YZla5tp2N1xEeq8ZE8cd4b3fiYuA7xkzHhskpxyug+egh6+HoWqe2PxRoSdK5IkU1qH0hRywgLXvqKqK5SEC3eStdtYV5mkh+PtCi3r0vkzhiAgGumnnWFYQHP2CkMQhgcDw/pTUdhZPgOKJhLrjxnesLufhigDe6GMycDuUvgfIjcK47pp63H1E7YZ0OeuovqJ7cjwT/+bvuA0QZ+WStod3twp4P/9qKFtBlF++YFTIoXhLgMPNZIfQvqZVl5KRhlk4oR+h4bloHzLxqzguTm2nlL0d5Gs2IuQfw5gNQdS290/73hIqVkx8YM+tQk5VphIPXKkEVQ/063je6s2FxO2AYfqLWF2lBSgA6RczqTQl99cjbB2D6EiPmMRueVeL9GabhNZCwIpOmp4tCNTYgzFFGzUsy03g4AlpW4FiKOyY+qdmQHH27o7M4eytTsW1QPGGbwAWCHiLCeoJC/eODkDmBM0h4BZEyDqqb
 7DDiLqGI
 4uwHeiBQ6r3JfBewdKkVFNWOOPITYbZIpD9i1pzFwynwXS2QfZqTZstrdgcEVsMxuIfzkd/Ey6aJ1be5/DeiluNUkXaoc3GAYxJeEgy44cXD/UQp417MuJCn4I+p8ulVHlc+66ZtcR28Ac82mEo+drAOCQtVpA9ZrDpDKB2v6HNk1IS/CQlyqsMnbHTXk5dzkDDzzQNcsgZD0Aw6geCoaJuHvsosZnSJXzMB1srKmif+hSZ2kIVrzrx9ZwQOedn3rX/IaI3/gcVxSoIxO93HWUjQvsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 21:22, Andi Kleen wrote:
> On Wed, Mar 04, 2026 at 04:56:36PM +0100, David Hildenbrand (Arm) wrote:
>> There was recently some confusion around THPs and the interaction with
>> KernelPageSize / MMUPageSize. Historically, these entries always
>> correspond to the smallest size we could encounter, not any current
>> usage of transparent huge pages or larger sizes used by the MMU.
> 
> It still seems like a bug to me, only documented now, but seems
> I'm in the minority on that.

I'd agree that something smarter and more future proof should have been
done if THPs wouldn't have been added (checks notes) 15 years ago and
how KernelPageSize / MMUPageSize behaves and what it means would already
be set in stone for a long time.

People decided to add things like "AnonHugePages" (which I also detest,
but here we are) instead.

I wish we would have never exposed MMUPageSize (in 2009) to handle some
ppc oddity.

While digging through some history, there were earlier conclusions
(around 10 years ago) that MMUPageSize [1] is not a good fit, and people
even tried exposing actual amounts (Ptes@4kB, Ptes@2MB). I don't think
that's the right approach either for various reasons raised already
(e.g., doesn't really tell you the full TLB/MMU story).

> 
> But anyways if you change this file you should probably remove
> the duplicated KernelPageSize/MMUPageSize entries in the example
> too. That triped me up the last time.

Good point. I also discovered that that PPC64 thing is still in place
(maybe it's dead code, but at least code-wise, it's not a thing from the
past ).

[1] https://lkml.org/lkml/2016/11/29/882

-- 
Cheers,

David

