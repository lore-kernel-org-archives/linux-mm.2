Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1F2C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44286B0088; Tue, 25 Aug 2026 14:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5036B008A; Tue, 25 Aug 2026 14:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE2A6B008C; Tue, 25 Aug 2026 14:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86CA86B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:32:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B8D1160142
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:32:32 +0000 (UTC)
X-FDA: 85140637344.08.348ED52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 466BC40005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:32:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I1XPhPdl;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787682750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4M/A6prs9qi150UlkMo7ilOIhLeRXUnM9FxtUHao4M=;
	b=zhp8a1vbyECBmD5/aCbz4dO7t+cOXbLwfiYk7eicSnONEmZTOeDqnkN+ZyRDRs6YrHQ7Ki
	cij5c5NPDVXJX5LQxu+kpp8JFnncb4M8M+CHixuWMwJie4MiWkGO7CNSjRa+KdmwREDvTc
	3zOo45a308DelzoJI0+dluagRGR58EY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787682750;
	b=nwEJY1FWpeqMBNyCHkU+J0m66L3Uemqrbv+lbKP4LpBXlu2siUF9H9i2/rKArvPkFnl3T2
	duRhDWAAY9C6AZyj+YMMhg13UyP3csT4D0nQYpEJTT2ZzNXQjC/BxD6PA3YglS24tatNzj
	G/iAxLX6KOalT0un8zwoFte8FJZJdl4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I1XPhPdl;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 658ED40E56;
	Tue, 25 Aug 2026 18:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C9E1F000E9;
	Tue, 25 Aug 2026 18:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787682749;
	bh=E4M/A6prs9qi150UlkMo7ilOIhLeRXUnM9FxtUHao4M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I1XPhPdlnRLXQNFuVbZIZyuKCmnP5tLm2XlvwkVszdlSEPx7JPAdOzhL4QiuWRF/Z
	 9WmX6PPjrtk28PKXIXXkXDmoLoP+W3UBL0jVeHnrmdlTVUaCzW11VGjC5Bja1o5e/L
	 5jBOGV3vlR98lAtbJl4h0WD13DXkNBGoJdLJBMOf2XjBJDJroXUmQxDwh78aPAND4h
	 j103mofOdm3Ld7OTetTznmIwmnUKvZQuMbHHK2CBLCKrxwGqM6toQUGaMWcHSIefwx
	 4C8EZpUgkF9VDGiajs+639zZA36RvoXH+6WxJQY0SAtn4ltZJPFw3lV8M4GCFStFh5
	 rNAfcbkeewT5Q==
Message-ID: <a89c39f6-6901-4daa-8619-ea9c9940e721@kernel.org>
Date: Tue, 25 Aug 2026 20:32:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: check strdup() and fix buf leak in
 parse_test_type()
To: Anshuman Tewari <anshumantewari123@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260821114416.12255-1-anshumantewari123@gmail.com>
 <7bb2d581-924e-4a59-9955-b8afa2b51268@kernel.org>
 <CAJqi8kJf9EzfZWBo=1KpEzGiq+vGRz0J0mN+-NXAjrtq9HDrMg@mail.gmail.com>
 <e7c339b8-b936-40c7-b121-1a4c14838dd9@kernel.org>
 <CAJqi8kKaNsxBM86Hg4W09gLo2rj0+kc9dAvps48jmQCshUkxqQ@mail.gmail.com>
 <b993b8b3-351c-4d2e-9bd9-12c622f427ff@kernel.org>
 <CAJqi8k+cTXvvk4Pz0RdjQMPvSNCszzORH746fb7YgQUgngykbg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJqi8k+cTXvvk4Pz0RdjQMPvSNCszzORH746fb7YgQUgngykbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 466BC40005
X-Stat-Signature: wikqxq79mensxkk4ien4tbueb6iz31qx
X-HE-Tag: 1787682750-321893
X-HE-Meta: U2FsdGVkX1/k1GhTAx/v8x5jN4VRciJCkl/gALEsQCctPdLsCe3lzd08vx1SSascS3+SJL1jGsIY0NlG2RPi2PlkZtKzolSQP2FIw27f8SUxJOqpMeg7nRNc7Jo2obzBIoq1ybYnX/6nzWgsDhsyQlvK/7+bh7COStUuPIqDvq0HvyFu/oS660lz0xDBGd90aIJSf7AcmK1uENwVyglF6aIkCFNSaExW3AR7Cz4AkifoDUyddQGm1DUgcBln7e9gQMR/SlI+SHTQg2kJLjmn5rNeQQRQQbbIXKxXbeQkX+EAHrzeoE113Emtu6jLJrdLS2LepQk2AmJ9F5tRRkOKRO9gYRkdEe0fn47ucbiH/X9wP0FII5+hR8NEU8F9LwULBgIJeLadjj4Sv0JPMDya+Omox8tnKdRtIl7gPGjEUB/vry+JJAz57nZl5mkySeZg+8d+ERepxeHmCFjHU+3oHU6JU9UKtUcFnPcnQgo7u0pzuFrD1vR86diJhNHhvsOa+7QPrtM/gZKV+SfGaUl5WmW+g0l1E93RFDnZ15EwnvsXFrfYCqiwd1IS7rYm4YIsL+PK3aiHgpSvrILldkQk3Jdt7A97kxgvofI8kRzE94LXQqmWYzyBOeslFjgmWBdLkjtH1wqWKFiFY3zuOABr5DgCLanLR+ImZBDQ4n7rPcuxT3b2cect9rQWBjoQVsZzUH5B4sAi2fc1skNsdMDEiAUk7ChE9MCYpVIXLFXa13ZrbGQOtk/3AZsV1gq1wEe4dFupAvZIVk4rLv6PuEwpBSoXTPPsMnGq+q9EDFH2mqx7ws0Nai5tN5lfkqp2hDuTktTw+jEzZcxUmc6JaiC2ZIPXhlvEjHBoO23A8FbUArAN2Zk46gWIfYMGjHeUmxNhT+2TP+VQ7sLpPG6j2MwEEryAJC1ri3UaeK+j2asn0XHxEyAy41qVIRAm8LY42LAlQUZcEvdL7HGPrqKZnGk
 LBgWoubC
 OboYHFB7Ps69bpWIY0CL5g+EnB8u5bvqzK2Q2/rbh8Dozz0YzIqDPMmi9r5xVR3HINsooRSh41a+Uf61neiKc6s2lulZYS1x2R/6+f6j6mAph9G/3HXSmyxTGH0HJSZM8Z7uqwR9M3RGxtGi1GfpOXiTNMZeaESnX6xjRnPo976eu0Gs7uOFqG4Ob+glWJq8AIzQrL+hO+tl9OqXnUE/KTQyyBAOu8P1vePMr7Yh44wm/as9xjUf8FyzmCq/j/wrC+S+pgGlz0OllcppYWnHCb+UPCJZlrGCmoshZy7FkGoswoFLj3W1+OuE8a2Z1KtJ3/yRu1NWT3uJfKROFjblKvUhpj/MAjrVEpdlyraFqtEJ22i5UxIJ+e2uEBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 20:20, Anshuman Tewari wrote:
> That makes sense, thanks for explaining — I wasn't aware Reported-by
> needed a Closes: link specifically.
Yes, it's documented in Documentation/process/submitting-patches.rst and
checkpatch.pl warns if you don't follow the documented rules.

-- 
Cheers,

David

