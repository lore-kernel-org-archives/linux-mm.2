Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AF2D78794
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D67C6B00CA; Fri, 19 Dec 2025 11:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7926B00CC; Fri, 19 Dec 2025 11:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26726B00CE; Fri, 19 Dec 2025 11:00:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE6FE6B00CA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:00:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 943E71602E6
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:00:58 +0000 (UTC)
X-FDA: 84236684196.03.832024A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B8CA7100034
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:00:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ovlQWGJW;
	spf=pass (imf14.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766160056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubmk564mZhVjNIunyhFyRVWYQUIX3tzkV8rUqSxXjHA=;
	b=pIBq6eOcUPNxT3ceJ3KnkniAM3i2z+XUukOw8FO84vt9yhG2xJXxpOYLTGbwGJUQrjt1Pv
	H4oRf619cwB9SGMFe4ZhGAZTJYwxkI6HomSe2KjA7rIzT6PlHyv196seBOVKhfpSKNWPLK
	5HmayJtkJ9FlccC1Soefmqh05PszXW8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ovlQWGJW;
	spf=pass (imf14.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766160056; a=rsa-sha256;
	cv=none;
	b=MXzwcONFIKch5VV5vKrtDc8TwA6/wdNi7WvLDXJHpfGWOXZoywJBexK8V2bMM/DC1rs6ZR
	pr+tJEeXVuVc/8FwfmaCoEzjFBRo5C07zCnYt42bXdKVCrEfm0Fz+MFGCj+IvJvnoobE2/
	HA2Id3yXTxlzoChG9TL8pxoGFM/I6T4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 706B242ADC;
	Fri, 19 Dec 2025 16:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3084BC4CEF1;
	Fri, 19 Dec 2025 16:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1766160055;
	bh=ubmk564mZhVjNIunyhFyRVWYQUIX3tzkV8rUqSxXjHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ovlQWGJWEZcPQLYelIukLOqalx/qp1OwKqd7aa3KhVjiRmJZvqijCRnc5lMxtlZCf
	 1utDGwrN3sGSzfljsYYIr5qrXweO3nQLm6baV5UVmwTIP73WDjhEmzyhhNi2UIBCrU
	 3dN63Bciu0q5BdobvfgDiw1lllFk6gPOmThsqQVo=
Date: Fri, 19 Dec 2025 11:00:54 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/khugepaged: remove unnecessary goto 'skip' label
Message-ID: <20251219-flying-congenial-harrier-a7e4f5@lemur>
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-4-shivankg@amd.com>
 <848E8F85-CD24-491C-8A3B-474E4FCBF995@nvidia.com>
 <32f3f9dd-f84c-4113-b356-01750b2af80a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <32f3f9dd-f84c-4113-b356-01750b2af80a@amd.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: hti3s7qcdmqnytax9s3gy6urrecjc4p5
X-Rspam-User: 
X-Rspamd-Queue-Id: B8CA7100034
X-HE-Tag: 1766160056-313005
X-HE-Meta: U2FsdGVkX1++HLHa+gUY5vK3a7eLRmTj15aYscFiMOARNIpC65Sy9McqWB/gdT4u0ttaHVYst4gwpfqBvS/nS/5xdp3d689Xk3xNKSRO/MajGiy0ZCwFbmA3KV/fFl8dv3wus7zCdlCRcfRXL0m/UnH0P/ayap69hCLDdRId7NfrKjH4PyB5eYfsl41oS9uj6cTMe+qXNiAPxEYHqlKXe1SSOWpsURNa5aflfEV+wM7AHpT1EL3kiU+uSIy7Env/fElNbyHrgwYserT2+jwkX1Y4hUj5Zbwv7g4v48mtgizzQpp9DlCd4/04MMkUXBK8SZt9Gn+Ca9lt9l+GOOOgF6uTOWbXX+Kv3RlBPojpjsG/Yi95BFnWGWRUzJCHrCBoicQM9zpN4n7G+T+Fs5JYAtVecwj+tR2GkYtUd/ACUetCmg5rgNvpi8Cv/UZuJmTT9gsa/mX18RxQSeG1bpxgFx34nzWvytAL8clueUDmrfWp3kIAfcNr4CBRGgqx6Ne6ARG5y67tFK00ZBnnIUVOp/RJPmcMe8/Boj6aAwRyjSMBuiCJCPWt1LRG6FSdVk9FZO6Et3ehw4cMQI7JXnoHCHorZTIiFPuEx6dbSgXqVpq/J5jtMW8H/kWskQ2PUYNusADsFQM+NZHyxgKn6gehI+n1/7SM3xFruoj3Cqjob8B7Gvx3AhPAr8wZ+bPFeiKVtnhL9dC4NsOo7OiD8CGH7Mbar9fhC4++s6Tq79ZtxezWZentL1rm0FoYatHu4kLrUHW+TwBkJ4cRto7ZzhF3Ibm9KxVhEKwp/R346ekwtZvXjTr9dpkruoPpzKyaASvJf7i3OgFV5zp7CIvhnM93KlvICX4tnm0gJhJGWDgzg3KLn0xYIADbTp55LndKgPagB2617IdDm1HDc2WhWoVVB9cu7Vq8Si2FrQPGk/Z2uG9r8biGaCnQoU4z6HmqGHSN2fN/FPZNd0ZqIeAw3BU
 gAOmOr6K
 b7ReokiwvtAnB5S+qCT75aMyMG8xg3KLNghifscOZ27D+9xIQk95BthICI3a8XAUftyXUNlz6YQbadaB6+iNq7Vvpvm3zX19DjpwYkNM9NNMAfeKUifoXQOSqLo4J1TTZ/bj0xs0fp6l+hyr7TpE+8nEWSxRL8F+5VFrpIo+R3TM6mONl3wv6OrfpFlQSqCegcfS07QDOH7Atw2jN8YFaDQDLqBonvwMlMJBd7gWVjvc9e3PJNHvAL1Qj+qaQxgrfXA3gHP+PofrkTJ0aAeHMmvEAzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 05:50:39PM +0530, Garg, Shivank wrote:
> I noticed that b4 didn't pick up your Reviewed-by tag automatically (possibly because
> it was on the same line as "LGTM.").

That is correct -- code review trailers must always be on a separate line for
any tooling to properly recognize them.

Best regards,
-K

