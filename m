Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 939E8CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 16:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15BB8E00F0; Tue, 14 Oct 2025 12:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECABB8E0090; Tue, 14 Oct 2025 12:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03098E00F0; Tue, 14 Oct 2025 12:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D08CB8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:09:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A37511B134
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:09:54 +0000 (UTC)
X-FDA: 83997205908.20.9E35125
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 85D6F120004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:09:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xVqSR5mP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760458192; a=rsa-sha256;
	cv=none;
	b=GmYNyv4VO024vEreqcmPxge1RZH1T5ebT9fvkQc9VnMW/sSJY/DXrKr5dzGdD/xiQWrf1B
	mp5rdyg04fCva+NuufOiCZG7bvwF8KusKWBhFPi2DMtBdlgZFzxx61fu4Creu9BOvxFKa5
	PSMCVqjxqjTqtmIlXwgyCqGsNHIfdu8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xVqSR5mP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760458192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+Twt08nWN4Np4W7evQ3ot+OSGaLX8P0SMb0zqLKEwM=;
	b=xROkJY1lNCiDGtThVP3ixF3LeYZ9gP/BKtMoEsdlSZUSQ8BC6djjr/+fucLARwm/1NaeVC
	VBCHOK7RpCCHliLEti5OboZ6aE1z/yzL/fKmEouBH7ZNgVVGvVJh8R15Y1Ha92WgNhST/2
	tiKo/cZ0VqtqCMINymimpymIjUp6ewA=
Message-ID: <b0e88b97-3c55-4be3-9782-4ab5e5d72ebe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760458190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O+Twt08nWN4Np4W7evQ3ot+OSGaLX8P0SMb0zqLKEwM=;
	b=xVqSR5mP5Kwg/dvugAJHEPNCg7sb/bH/6mecSofbYeyIVMvdk1hXmF83ovYbzQEl0s0o4/
	wnR6gkCzhFWaxScV9CsI+UfFEXQM3ZndKVGWOhUwaZ7/gHbPC7EkT2B+7RGNVPBkkFNWcH
	lisHrpd9o+mpdDdPxI+g0xwEbQIJYmw=
Date: Wed, 15 Oct 2025 00:09:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
 <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
 <95a223b1-8d57-40c3-8226-678b1db233aa@redhat.com>
 <57cffedc-65c0-44f1-8364-3a3ff9bdc760@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <57cffedc-65c0-44f1-8364-3a3ff9bdc760@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 85D6F120004
X-Stat-Signature: m966x9q38iogayh6z65345p4gqniom3x
X-HE-Tag: 1760458192-868417
X-HE-Meta: U2FsdGVkX1/C0RjAEPoJUKWt3hfb59LSQATftnT44Bvhpm9bD6MWzjB/iIMaAzjgnWg8ruzCSFeW1IO5dQKDG/D0qLa8QPHhwLb2JJWDhAXmLnO3WAvWkNwt2csYKE7cp2FihcmaC2hZ8VX2iVZnxjS2P33S8wOkkejc5piOaZA/J6aBHXLjRAFLXfkbtSeTDoYtO96ZQCZyWua9c3uPgEbUqDgAV7QuqUpWLjc72ansWyTUBplEmfoGWJKmyd7z53tanHKyYDGEk0cBzUsLsb1HQ2NJ26Lb+gd/OrirJNUISRMeNAaNQF/T5CRVmh+EPIZGXoX/fqUr3lzPcwzJN2kWJG2Umy9qlV4fTv3yxtY+kCoWjKx6hzNljJQ7JofZJBkAmV4RUslWL8PBr2EEtd4WYeR6DSJfkOOx3d0tjdgZ1VMaF8cW8NVQ7x9aa1NP8NIm5yv99j3TcdzhRUTJv3vqlIGq4VPAaH/ySDJjh7nTiySjWWBjw+zEDLZpP5+YvcwBEni07Tyr3YTpo8I/PehkBC4mbrgnTiRheLfsaHkSxoRfBYwRV1jn5Sa4r6V6qNHedabsrNNMWyH8wP8aVjbuNpNrvz2eusX65oLzlmKwGsF84ggUxpPCrHVYGYeiGgYAPDiPDquLrcQvhWMWI3Vzxt0JT2KHPFIe+B556UOHBUHQnTICUJo49iXFNc5VTmSJqI6ZIpzDe/M406j4Ugn5x3i4XJlirwgP5NWEix+54dvmTuhhsboQabnT8iag0T6poivzUYwWfhn5NvNDlpf2eAc+nhThyDsOJLgGNLlSqKTdQcg4MCcxHaPboUhLiM5bQ08bICFl8RkZeg83Zy4wJlIB543iDNx1eFbdRaW4v9rbyjHieqZxcqco8EsiqKLDZspw8joDCSAvGxxdyi0r9CqKaJTHKCzEJxhEOS62FbijhxlbN8/3/8m1ciAaMbB1l5ynukeRerYKoIm
 WwhOETjm
 8LOnJ+m9UXZAdgQsgcXvljHPzPE1a6iiYoc1z0k0HduIgRhjoD8sPhZEbURbWyJrrv7dZmcPLdyRupZmjtp8Dw3IpqNmZuSw/Lbz0aSRL1HYrcEaiT5/UG71rDfZP4EBlffXMg3yXnE9ug6y5mNf0YLjMFByHysfrrDUzIeaPacMCiIsM/dRv02ha6EEDie97w2wcsNnxT3JZXRM7rLkm6xZc2WpwOBfTD4hZWAjVlSAGG9g56SgvQIKgKRS141jQk6Wx+fZnvkf458UErAdGSjgEfpHJzs7SgDu5y8stAm39Uje78gBD24UIXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, Lorenzo,

Thanks to both of you for the deep dive on this!!!

The code we've been discussing was moved to a new helper by
another patch series[1], so let's call it a day on this
thread and leave it as-is and just review/change the logic
at its new home :)

[1] 
https://lore.kernel.org/linux-mm/20251008043748.45554-1-lance.yang@linux.dev/

Thanks a lot!
Lance

