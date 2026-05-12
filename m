Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0264CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62EFB6B0092; Tue, 12 May 2026 03:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DFAA6B0093; Tue, 12 May 2026 03:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BDA6B0095; Tue, 12 May 2026 03:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF676B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:46:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03F291603DA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:46:41 +0000 (UTC)
X-FDA: 84757985844.24.8307866
Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	by imf07.hostedemail.com (Postfix) with ESMTP id 512744000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:46:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=w4qF7xON;
	spf=pass (imf07.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.209 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1gWWEdnfiVpbt8SwlLf1vkbJ8s6eN/LdkmgSTqf5xc=;
	b=B4VQYYs5od+/X9jTyt28H47+a7B/Rqc26eFbrDBo4YBTrAGxKseO6HB6+9HF528iswkUNb
	sy4SiCWB8ih4oKmI6CUQhudlQEfch2RZ95fWfy+B79crke0+ieX1qV4PMBD8P0wNYwVPOQ
	pXnMEyMnZlXvKhjzXocO0vYoRL6onpc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=w4qF7xON;
	spf=pass (imf07.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.209 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572000; a=rsa-sha256;
	cv=none;
	b=KMXudLhFqgjyz/AvjGJM4+iZObRY/vSq6QdsnSpLt4E9YLaQ3k151FLqPUruEHwFRP95PH
	WLzH/wE8VnlCuLLQjeWgT9XtoER6OHuvUgRvFsvbFqBuJItZhXdjRwx7xy+kDeG7AnCtaT
	4skqIOMrbPjym3lJyqNTD2gEwJuqaYg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778571993; bh=A1gWWEdnfiVpbt8SwlLf1vkbJ8s6eN/LdkmgSTqf5xc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=w4qF7xONG8y8V7+itLHBJtBhXXmOAf1dxETYrS1FzeIcar9I6HodxK0USb5q8rG8D
	 83076I1pSiE6IdqfZAWnw+JQVZBNtoqoYURihJvhq9ucbJUOXje7Pm5eR5gRjmIeJ1
	 +u93d9YInFbjkqGv34grzw5dkwe61ymRDBCozxCU=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id B9DAD42F; Tue, 12 May 2026 15:46:29 +0800
X-QQ-mid: xmsmtpt1778571989te3rzsv8b
Message-ID: <tencent_BE4D8C052157D1B38BA2F9FCA287D4C8E606@qq.com>
X-QQ-XMAILINFO: OeJ9zRfntlNPhvVoS0Rd28/94ISJ34l9Cby/cCX5+IuHqb3PwKrf2k6h+n62a+
	 XQgRdbhfQDJNKQh3PAagJBWlYbJRkrLLuPn5Os2x86wtxVP9On7fsUlYXpCVqhb8LKUydsN9DFBU
	 bbtX0NaIObGsrL9288CiDogiiEEJz/Fnx/iS5w0ih3QWmko6f5sdTedLEJDDr3m1U7iF8MI+fDN2
	 sz4Q22+jkYrSoFVhtekjoLN5cRMP6fftkm44MlMP2pPD7gGThooO4IiNIVp5oyDO0oR4kOCraVH6
	 Zg6i+73xFzyE5PBRZK5iv6L4FJD0jlRyun0wy2mWmSII3X9uShdGEhHySi867FHcDtQbJqwBkYmU
	 j4ki6JVJ6H8cK7nwiNCe/1Eo0gjv0w94zalPWP80HItNl0TYJqtyMmKhDQv9wMZPp1SAtCMQ43Rb
	 8nTuG3aDcnq3Gg5phMkSfangiQFKaNu2yYKgjdG42Eb7V0Y0JTpvzGOXu82OPzlBVB2oKk3wEmBo
	 I0hflA5TBZ9U02nyuHDUzNn+BNrCUTcRrgQVHp59K47rDuWMEaRr2iEpAYSRkVCWfXLP1PXsvpjr
	 wdjciUd9ZyyphTOiXgsYXi9gnrqzN2Y7L+RhGciR/JsWWoG/rBpQlV785vNHzdiuOAW+pxEU/6uW
	 tiYTT0ZoRLGNZOxSudNL+0HJvGi1q8o3B8/lPp37x9viCasBfR5nyej/RIjAzzQtHtgjj+qah66w
	 3vOfCrupQdPtl3vpUgv4JgIj46YqoqiQZjYArIpDZfqfK4/tsHJXYg7QtojlCq5n+nQwugAyIJN+
	 elbZBm4L/BSq5Z+Gb14q7CLYVw6ddAY+m6TzHAH6iN2m01jr59dYUcgpcfMaf0fWOk6D7dOQrT62
	 u1RggAf2Hu/QuIP3LQOdFtSIXpVFn49ioV062M9znHDO1nG1A8LZLm0emgQuTl2x32lnuf0Pgzd0
	 CdKuGN3ndM+l+OJmtwUaQlbLjHXl3Y/FgHbI8bGoM7i8DLYkzkru1VlalPPNUecGPCJMN+Pjkv/B
	 woSOpz5Ia84Gc+gUkMLp5/k6Kgz0ddcbZp3ld2KJE5zTKuhc8VgyRe8CpR+NtC9yM14sYpTY77xc
	 M1UODa
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-OQ-MSGID: <e99715f3-a79e-44d7-9304-ef63b71fe1ac@qq.com>
Date: Tue, 12 May 2026 15:46:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio
 swapin
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <CAEmasaV7ejxqb9-wTT=7xdt+icxj-ZvdSLkSoC6X5i6NMfsKPQ@mail.gmail.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <CAEmasaV7ejxqb9-wTT=7xdt+icxj-ZvdSLkSoC6X5i6NMfsKPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 512744000C
X-Stat-Signature: i6zpb89bhuock5tukdofkmu3j3hi49zi
X-HE-Tag: 1778571998-106394
X-HE-Meta: U2FsdGVkX1/oy7Tm1VMqsCo6t7QZUSixHwbO28/7NHIxmTliNCNm3okWDK1xrRReiCuJROyUMCTusIALSeCTlQS1ws0ZcqA2SO905xk4j/CT0p2PR78I+qE2H8VK+Zu+zsMbUsiZHxPgNkLw5EhEizHQntepCcI1tyhBZJAsF7cJVWjlOYnSzx4p0opweI3HkrNl/9q+LK0K3m/HOamwCwNCWjSG6oFfMxiv0T6vR3kNtcMdnEHscjOB6kitddu64j0ncqFJDI4Hy6YvqXH9L6OD3QgD6rYcY0JB6bxv4NTQzOglwWpG8g8L/75vPSo15fPKtBpMI/a3DvQcJdeAEJyuabEsxDcMPR93yO56Zf8LBnZj2rIKaWsZMyPx5im+NXQT4iFN+VmRgmdOTjLKKFBUSNHRqFjHvEnPe1M7Wg4BRaJSkvjN2V/URX/3bVGcyMAB7qQ78QA0oCTnZ6Zoac7ONgeBjm4P4dC01WYAApG/bbdEEasLaeTdKi2pdoSrrtBWNcrGByMnT+PHfXdX9IoGAw/whzocOoa8Lnao8Hznig3ITdUd5uzDNUSdda8qxZUCK1nxfAVSsukKrDDSFtyjwm8HZQICXUjnIH3uvIKrhMKaOfoaFalEP0P9htYHaVbECSAg2m1npzSKc2OfsiOZ7u+dWdrKUiOcCox1zZ6mzNoLivsUTEfK6IiqwPhsrDx3WoU5mxNcBXZRGYyj/j3vFvIjrYWPQX3L6K1CB/++CP/s5lutl8WMa1wmn4EsuLySCaYaW36+5LUlke99zNqXXCrtwb4TWa+ISmcf8uq++f7a0jWK0ioZGmi99bVSqtfezXgv3GfaMoStdgpieUEJMoLesPSBCsaIW+erbZNRLzTGuu0nDaQEgcEmrgucHGZRjuqmC0ykfGysEql2t1xQ9tAT4iIAm0ybPQoAk7mLNG94JkSS+cXxeFuWbZ3T+zCz3hQXLBZipcVR0AX
 8aAl2Ra4
 baaxksdfX2NUUUiLLSH5Mkf8O9918qGqOK7riTNnRt92vLwCTPRht1x5WS+VfGyVXyyLLfahDER9js6qmQgdpgd/UZaZui7If6pc94nCI7Qk0GNmNi4nbifoxHCsq4tTYnj+PxHyfU8OrN88RQaa1HtoEuASuj6qoLcZlDAepY4Zf1lYxfx0grlrAgt9I9yVs7lrnkKDzshw15ZEO7ZYXH4iCgkvCUT/X64mJzdUkN/T8nqwKCAdQrO96ia2qx1+XI0raijYxR8WUwJnKUdPKQieyK0vs8mubNlUd2mAwZYQPvVM9NdjFnTRn0X/hdK9F3AFFv82EHZUQaQzHJeFvdN69zTM3k/UVI2OvimAqdqlCuFduHc5R4gh65OUKtGRAP6vCqWYALAnGwOlHCuMeEJiseWm1+E1T0cvvy2d1NmWzi9t8umXeTGSSF9agmHbbvyhx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/2026 12:20 PM, Alexandre Ghiti wrote:
> So I have been working on the exact same thing for some weeks now. My work is based on Usama's series [1].
> 
> The problem with large folio swapin is that it can create swap thrashing: to swap in a large folio, swap out may be necessary, as reported in [2].
> 
> I implemented quite a few throttling algorithms on top to try to avoid this issue and so far, I have had mixed/inconsistent results. 
> 
> How did you test this series? Did you encounter thrashing? Do you have performance numbers?
> 
> Happy to talk more about this, thanks for your series!
> 
> Alex
> 
> [1] https://lore.kernel.org/all/20241018105026.2521366-1-usamaarif642@gmail.com/ <https://lore.kernel.org/all/20241018105026.2521366-1-usamaarif642@gmail.com/>
> [2] https://lore.kernel.org/all/SJ0PR11MB5678A864244B09FDE4D914EEC9402@SJ0PR11MB5678.namprd11.prod.outlook.com/ <https://lore.kernel.org/all/SJ0PR11MB5678A864244B09FDE4D914EEC9402@SJ0PR11MB5678.namprd11.prod.outlook.com/>

Thanks Alexandre.

My RFC only had correctness testing so far. I tested the all-zswap path
and fallback cases under QEMU, but I don't have bare-metal
performance numbers yet.

If you are already actively working on this, I don't want to duplicate the
same effort. I will pause this RFC for now and wait for your series.

After your series is posted, I will take another look and see if there is
anything that still needs follow-up work.

Thanks for letting me know.


