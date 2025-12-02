Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D90CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758926B009B; Tue,  2 Dec 2025 05:22:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F5A6B009D; Tue,  2 Dec 2025 05:22:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66CAE6B009E; Tue,  2 Dec 2025 05:22:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 573706B009B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:22:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 655C813B3EF
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:22:20 +0000 (UTC)
X-FDA: 84174141240.08.05D1B26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD0351C0007
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:22:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UfUVHxVe;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764670938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PSrj/Z7a0DQnMkwrtMNeFn+P4DrXplpqLIqSYWuoZeg=;
	b=dfqH2ZZQVVBd/V2/QkidJSTUh8p4AaqiF0buDvhD44VUIEOwDbXkaiCKVsrZzQKTvIA4H5
	4oADiN8mJLLhR6P5sLwVSHtBk8FU0ljJSttIaK2RaubAwWe+k9e14/L6XyAaluDzYA1xyc
	/gvZA4SlYRoNCx75mHBqywvGuSrjoqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764670938; a=rsa-sha256;
	cv=none;
	b=v1f98zqs8A2G8fU7ga7MaVpjzpfFreJ5Ve4Y+tuaNYU7jLcZG+EloM+p+RC5VLiQdHzGVt
	Llgih3bmUUc2O4fmHpY6Ae1vk1IJ5BBJpLCxeGTmLjOKVOCnO0ll1KQaRx6WWxXIlgSTw0
	DyKbfUBElwR3Z638DiiKOOTvgfxYFBw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UfUVHxVe;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8891B42E0A;
	Tue,  2 Dec 2025 10:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35900C116D0;
	Tue,  2 Dec 2025 10:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764670937;
	bh=yj3FN/V5KbQow45uVjosHH53hDgKacz7AQeCSi6AvTM=;
	h=Date:From:Subject:To:From;
	b=UfUVHxVeNJIIhMfXVk17M4vjFCcwA+zpS9oiRqG4YqU9vz7OwKhm03Vr5sqZ7m9gk
	 ZyapLJ6Tm1uzwJJui7X3LzZPtudsxzWERJd2M64u9qR2OMNndF7xqygZGy9UaxdaCg
	 rwPGVdSzCOjKd+Hf5cJ4TRlsfpiJLh+oZX2ckfIe+zv0eZzFChqXhjOEI1z8RfTbDw
	 v19x0BIGqaRxO3EY2FVgI5eUoCFZ0ZRf2XNwSsSHBa+zzftEtBGXH+Rb4soHFEzXVA
	 EQieqPKGl7COlC1osbM8uwf6aUcAX2hOXiIbYC7bittxQ3XOchq+CRoJP66Ze/vETh
	 4lf41pKSqwbMA==
Message-ID: <66c32ad4-a59a-425e-8a00-bcfb918e7559@kernel.org>
Date: Tue, 2 Dec 2025 11:22:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-12-04
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD0351C0007
X-Stat-Signature: j8zs19s3adc96q48n4naidwwasqch44a
X-HE-Tag: 1764670938-402280
X-HE-Meta: U2FsdGVkX1890jQAWNOHdnLxkJGo3gQWZxoU9IGJxssEIgtuO1TsKSCxMF1jHRR3Kk5s6gGpmmgvi5XgoI7FsGvPYImbpvlQhJHMiHnJ8k8jndxz2pgRrVudmE90OEwLHM/zkSw6HNBv5rNN9qI+SeQB9UvNgN1mFD/uY5M5Ruk4Fov6KLzQKIQmaRonvAZqWuLCkNA4LP2+Dd1D3jFH1CSIqGzX/1659E9c+B+mI/2erHmbS66OH/h+e7nSRewuzkUs0XHI7ipJD/ilkyKaYs/FpfEx6chj6fnMUNDcBZCu9n+8phA1UsW6TvRVuRm9056TPUIAXDMozSPKqiY12T5zqtSbb9LJCSbmSPtQ6PGXdQYyHmRdFhLJK1/1md2buqFAU0n+pZ1rmIcnypuMX+d23fmew9Digzos0mj5zHIcN4ugKiBLFTPUnfGI4dTndM84t0zGUTE6zBlnuPYDhKLeICHsEgG+5EJ4y5zSOuFCYP3tmYBmbFsrsVBHhhO1XUOMbldwLmw9ijKveFvuN9DevYOt6Srbklz/08a3e9rzEVwOZYNm4UNIcXF2scclC13dkgt0LJxMgrbJZew4iBUKPSDFunvKE0aqKEAbtV1qI/qO26VZ0m57FVBmZMf/BiFM7eUOW7Dj7d/D7pDMaUMdwY4MPZbDBCPnFLyq++k529sr39AWDi1xzifLr8Yqp+IpP9GFIl7xjmILNVOkShL/S+Emujz29HyhBOgWuPPrt8COcJKqjOQFMh36bAgnEke9KYJcdphF8l6ZEgDIXXkWGqzwTiIqBRKaztN/aZuTCPmWgSYEx12Xx0iXiT26Ay1wp8TlYnrc66x4vvhs1q6jh4aveOkqy3/zvB48jGnQFdgjDvNdYamFcP2NlVPMqRKkldoII+2uw3fllgeEmFNbvtJxYhpp4VvchQ55IQCXFqftJpXS2y+9Ki/DeoPT5XyzYRgd6YkOIS3phds
 MIu3VW+c
 SENPAc0wF/BsRu27WK17DR14v9BzUTg+Ck9Ai1gW2TPjVurkKDKIBOIYUk1CUZwQLmZeLp/55enGwILcQo4HcQcuUqogvDpB738ToHYSxPnqP+eGgXbRzSwiPWhrkLegyszlITIcuvKiSOVXb7yj3jxMtColrBxK8mJj1zXNBWzCGnOX06FkJgooA4oBmgIK9OGwqp+XJOEas+n30pcT9dSQTKOmYaxzcASBv5I+zEFEjq8H6168bNZz7UwHg4y+fKrXDU6sRVt5VifTvOHJIhj5Wyw0qjedHCea3VUYLBK9j0TpgMSJFbVFXIR24ZtaddTTh4wQv5O5h3tiV+WaL9FEboiaW/dHoaFpbUDHTr4Yoh3jQHddbSlGyKVRDeBOP2EsQTefDgMEYe+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000012, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for Thursday,
2025-12-04 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, we'll have Ackerley continue giving us an overview of
work-in-progress HugeTLB support and discuss whatever comes up.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.


This might be the last meeting this year: I will be traveling for LPC on 
December 11 and December 18. Then, Christmas is already around the 
corner and we'll skip the one on December 25. So we'll probably have our 
next meeting then on January 8.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers

David



