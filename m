Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C3FE92FDE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 21:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45DEF6B0088; Mon, 29 Dec 2025 16:15:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401B46B0089; Mon, 29 Dec 2025 16:15:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D9F6B008A; Mon, 29 Dec 2025 16:15:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7096B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:15:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB8B2C2EF2
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:15:04 +0000 (UTC)
X-FDA: 84273763728.12.5341003
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 23FE61C0010
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:15:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jKY9UZls;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767042903; a=rsa-sha256;
	cv=none;
	b=3ipaFyBOVWsPFiQHIxuC1C8RDNWiweyAXgfNNOTbU/9E4V/HJW1WB4a5o6PCYWspMQfR8C
	vecEtJp5USJY1QHzZu2vjhnTruCt+vYwvD3lfZRI/npGmHUqrVPc6Kf6qKKzKOSSmXrdTM
	Zcok4J9QpxSQm3ut3O4/kR9sYToTH38=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jKY9UZls;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767042903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0hKzidYvfWG+s9TtusbziTKi6XLXUnZ4Y1pxbN7Jvc=;
	b=z101GSft9pixJXqTNGQSo6WwdhDWYyC+ef/52DBJnQ2JVHfG4WmzzEd4U/grvUAnevLy6/
	L5hLWkJrBItHghOZb0zePAdhrI5Wpv3UFMnDQXSP46rF79RPMmaCV2wwKB9bc1JmTuTWQO
	4KM60qaGny7tb/F6DJWaiIgYE9+6HG4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58F116000A;
	Mon, 29 Dec 2025 21:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E38C4CEF7;
	Mon, 29 Dec 2025 21:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767042902;
	bh=+0hKzidYvfWG+s9TtusbziTKi6XLXUnZ4Y1pxbN7Jvc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jKY9UZlsTOJCp8mrSaW/YOoqI/r+yyNyFf2huGx4VFftVsJRCMpS4UchEWmSNJU2+
	 mmW/SR65hRZs3p/IS7waf1NjQ9aTDSyuxztBD1pNzRqCoQF95mGqFK75bOE8qiOsTh
	 r/34jl6+cJGesKLtTSrG0wiDLX0xjY3kxFF0yDM8QokptRaq8I7jRQ4niRqABeII49
	 A8Rz7bg+1ZrAHDw6vrD56WZ/IhNI7SrXFPMEOUt9GgTg5RArbxf9AqMyAQ0D8X7rC8
	 ZOtaBzMp1jsL14bwuklPgimM0VCDonLAQ3ZKPaY9/XbQn4TXWFX/cGXEO9V0n2jsnv
	 Kjh2IexLkouyA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  "Liam
 R. Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Jonathan Corbet <corbet@lwn.net>,  Thomas Gleixner <tglx@linutronix.de>,
  Ingo Molnar <mingo@redhat.com>,  Borislav Petkov <bp@alien8.de>,  Dave
 Hansen <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador
 <osalvador@suse.de>,  Alexander Graf <graf@amazon.com>,  David Matlack
 <dmatlack@google.com>,  David Rientjes <rientjes@google.com>,  Jason
 Gunthorpe <jgg@nvidia.com>,  Samiullah Khawaja <skhawaja@google.com>,
  Vipin Sharma <vipinsh@google.com>,  Zhu Yanjun <yanjun.zhu@linux.dev>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-doc@vger.kernel.org,  kexec@lists.infradead.org
Subject: Re: [RFC PATCH 08/10] mm: hugetlb: disable CMA if liveupdate is
 enabled
In-Reply-To: <CA+CK2bBeJwACBiKsuXLcbzC4m0zLhu0yNg2HDGR=AQGeEVCJjg@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 23 Dec 2025 13:16:57 -0500")
References: <20251206230222.853493-1-pratyush@kernel.org>
	<20251206230222.853493-9-pratyush@kernel.org>
	<CA+CK2bBeJwACBiKsuXLcbzC4m0zLhu0yNg2HDGR=AQGeEVCJjg@mail.gmail.com>
Date: Mon, 29 Dec 2025 22:14:50 +0100
Message-ID: <86v7hp7zxx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 23FE61C0010
X-Rspamd-Server: rspam10
X-Stat-Signature: yprag96wwmhnpzppufdgphjeyuj1nbb6
X-HE-Tag: 1767042902-769858
X-HE-Meta: U2FsdGVkX1/fJ0NTxPGg1pUsYKUjDu+omTr2fRTjICEKesGoPhOTeuChXPzsoE1esA4ilbTcd4ndVN5DfLirisFdEEIMc9r2YVmcnOso8aqOWn4mOfkYh6QsBS1GJYjRjvUpUaTgmjjyswhrdujrYv1MvOv3Pkm0yDJbpTTfHwpV2NVk6NiOHFTHr+6RqpHOPh6BHU7eRrISWe/iqTAf86pA9pgZqQ4gj/xWsaKWj3vzMhjLmDrMAXLEuBvsIo3oOfMFxdm4K37qp0QNcg9G6cGnTSjyQjzdDH75M6DHymFEpiaJZgCYjuFtV+5bQS8wk84AdyXfZNpPQ/+HrZLEMKhZ5BwfnaZegAIi59XIJNRnya17vuA6QZ0/z9Adu/IzVVe21JSFcv8z/V5A1tpzDWdA2C/asJJdqln/ptEmmtcXgYSWB8r+xKHQBMr74HATfOhaMdpEAyCv+G4i0BK67M8T4bBnW/rJkmOeN5jYmGCNWeEoenTGOZkebtc9iURQ47tCyyyDx+YDoC2R5R1c4JW4Nssx/fkTgpX6Ry2JfLSMraMOyAmCyxzqfEcS3vvOdZDujgXAj3QlhtJvPnMBp4L0ULL8KDtD71p01BOEhDfjbYyT6AFcLq6kSB6FdlA9qAqStY91kjByCvTANAN8wnwG9Iaqs+RzqyRedGwAtzNEXD53sX3AxITU2PzikYSmFlRdPYtyq+zJyzUe15Tyu3g60PTnZ75Gb0ZCYlcHkdOJrcPNBTSZKzIxY5eerdqiwBB4VvGthQgO3raK5czrKMXbRTVj6nOMLUW0RAobrM9t/wiq8hUf3mIOzpruPkmDkbCAXpXBdUD4FFXo9/R6mWSpqKVoXEo9vOK6WiMWjvjI3C+5KM9ni9sS7W7dhte+VrDmumMp74tlu+Tp+A0a6aXoIuE7o1KJprffpcSp6WyRYMDBeYUWGeEOjAdQgOEq2aG1oSpZbf2K3fQcoyH
 ZK6cFqJg
 sxpF7v3djnK/h2QlSkYes+s7AJVzvvtP2fFGLPt9PxyobHK5oAP8C9mtXiWGsbe5Cj0n5n6OQdfjwSWeSwo8i5QRGHRtTY+7UYLanaC/dXGN6vE9Jstf7FvzGz9qx9OaSyGdM8zG8j12I/qNxlAzN+GLSRIkomnpytxbUxFnwKgMyWi9mDLbChMSqP5uZiXApJD/nomdIEQsQ6IA8c/GiT87z9+OXaVldUBrgvq5pVQtGTgirTSS5zIxTiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23 2025, Pasha Tatashin wrote:

> On Sat, Dec 6, 2025 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>>
>> Hugetlb live update support does not yet work with CMA. Print a warning
>> and disable CMA if the config for live updating hugetlb is enabled, and
>> liveupdate is enabled at runtime.
>
> Could you please elaborate this commit to explain why it is not
> supported, and what it would take to support CMA.

The main reason is that when HugeTLB CMA is enabled, the huge pages come
from CMA. If we have preserved pages, we would need to "insert" those
pages into the CMA when they are restored.

CMA does support multiple ranges, so I suppose it can be done, but it
needs some plumbing to work properly.

Will add this in the next revision.

--=20
Regards,
Pratyush Yadav

