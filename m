Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398D0CD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49CFD6B0096; Thu, 21 May 2026 21:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473E66B0099; Thu, 21 May 2026 21:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B14E6B009D; Thu, 21 May 2026 21:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA796B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:37:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58DB414079B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:37:43 +0000 (UTC)
X-FDA: 84793344006.05.8D39050
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7F12510000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:37:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BEzZ4sXf;
	spf=pass (imf14.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779413861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvA2acxT+PUWoFnhiyQnKqpADcf34Gxxo2YPPgOhPzY=;
	b=OCfRgk8xzvd+BZ8T5sg9PkanKseME5bpUfsU4NueAwD2D/Nr/1XMJnGtTjEa6Tk3S5yC4o
	a0+KbumQOmG16YZ+ZABKTaoGrnpegdQNGVP8RbPrqRzqfQS6Mu6s0mzFatnSoSZf/5sSUT
	sQkDsLiPepCMpkD3qJUCGJScoF1aeHU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BEzZ4sXf;
	spf=pass (imf14.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779413861; a=rsa-sha256;
	cv=none;
	b=8RFPWZql/t7sZ39+URZQSwUND839cILWJbQ/IxQH+Inp8rzMMrKBmNSPpJCX7ltDX1tNpf
	AHqDBN/DhG2JVgLarNHnUarWKJ/HW7zxLfeJPZMa2UUYNVgkFv71/zdkv4+j9swuiIgzTt
	VziLEEG0cnKM/JGPccfYktHIU/qxWBc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=fvA2acxT+PUWoFnhiyQnKqpADcf34Gxxo2YPPgOhPzY=;
	b=BEzZ4sXfJTbJc8wV5opq/0kxCCuhgFfztRK+kjCmsogsHHPFoBaITAxHXFEihd
	q63CWIPKpgxrlgD2X0+LmfDpoAvyiY5DG/qsoI5GyMMlvwV1/WA6s5ejIkJK9oA3
	qDhf9r/tlDaYp04ycnTXNLhBKvNyzMaUGxAi+aCTO8lgI=
Received: from [192.168.3.148] (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wAn09g3sw9qVK6RCg--.8337S2;
	Fri, 22 May 2026 09:36:57 +0800 (CST)
Message-ID: <ecf092ec-80d6-4851-b0bd-e05ba11074f7@163.com>
Date: Fri, 22 May 2026 09:36:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/5] mm/shmem: optimize read with reduced xarray
 lookups and folio batching
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Chi Zhiling <chizhiling@kylinos.cn>
References: <20260520101538.58745-1-chizhiling@163.com>
 <20260521171454.02e35e71f999672518087037@linux-foundation.org>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <20260521171454.02e35e71f999672518087037@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wAn09g3sw9qVK6RCg--.8337S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar45Gw13CrWDtw4xZFy5Jwb_yoW8Aw1kpa
	43GFyfAr4xG3y3G3s7trWjqr1xtrn7tr18XFn5JFs2qw1FyF1UtFyxXrW8X39FkryDAr1U
	JrW7Jwn2yr1UKw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UZJ5wUUUUU=
X-Originating-IP: [116.128.244.171]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9xtZ9moPszsYUQAA3n
X-Stat-Signature: h8xn9wa1fnosmiffppsb7dn66pg7f3qy
X-Rspamd-Queue-Id: 7F12510000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779413860-17586
X-HE-Meta: U2FsdGVkX1/WzwMzYYsro0By4AhqlxsM6zAzJkniKGrQ6yWzshi0V20V0jBGrxvCDdgEnZJGF8VXhM4IMyF0HfPHaDuY7Ukk/GdnKlx1TXSA0zl0QEkT/Y1MdzpspwsdOTozXzusV3ov1dCP4I4RR2VBcZweYnKkzZ63eoNqDVbrAQE8Pgc81SLwtqmvvyiZFaV4ToNlUgyYEASS70loWKbfHUoWr4hWGEcdUw0w3rH0AVULrR5amTbTPMUdXmaXQVakTAcKf2dUj7vBc8S2I7e0HhYZ5QGvaWhtoWlkDozMvl3afa8N8dSqym0jZsICuF7tZerb/vy8lAjpoHRh6IjFhiAs8RoCo+kauqS6yxZ+Gj12w2jvrABJmR6/pnxVGb9zEmSM0ZjUJknOroZsfik8q/pE5VwnLASOlnUZFnxcQcBnEPyBQoe77vWKrY3J5ctqc8KvZjNXiCgQ6rIkPFLRKiua/RUF2uAApMKH8nsVcQYuGLKRJfYzII7rplsXmqwiLhCVLI9OHECi8zOZYK7S9tUZDJ2Dsjph2+FiBcNxZfoShqW2bcq0JRzPMlrxvr/9zB9k+8uqvx+xGFP39N/MdXptCiQTkMxlnbHKoQRGe2TjSjxbJ41DcvbuzwFZMdhOd3ouoW6LY7OG9s1AF/M0dA8/CL4+mPx2wyBKTBDgRBmX5PG9uffDnGoVf7TMyHWqCQlByfJPQukJ3C6/KtPCWvo5/NDRKdTVidIj8bryrS2egqBz7isNxkQMEKvr4bwpHN8IePYjjW4tSBkq7SAiN1x3pug8Nhnpu4Zmfx8qHLIpJR9C/LT9qAREgPGQa+sHAwF7I9lpeTGN4zAcD01Y11NuoepNlm3eEfDci8oBIGSGZ+B7Zu2plbb1N2j19R+0IVKQJGc41IS6z3GEVIWlmv9ryCMYxI2hSBC4FUbbyO3TsHjw7GltTmm7mm3ueWuDZDxCidNmOBUUHze
 xvrzjWI6
 W6MJiVUNlnCfOkP8TjcwgUY9yVjsxowCAkKoXJAnVpjOKLi68YyycLyIl84Jsl6KpIUdI43yz6sMBXWQsqGuPkhrdvxghs6O85GzX119bOwgl9BbaZtDKOGD467GN46D37J8awnbLZ73/PgOquH23i+gHejgdPplDl49VK2jWR3bEh7n9gBYvnFCl9/p229RFUwb4FdZKGp8H1pYryLE0ciyWaE7iDMxDlnc/+GPLjBcXGTJVqTqkNp7ema5qwXISuZYwXsNg22lD4yW4geCbD8K/AhpI2gSWRbm8RJw+ArXeGbavazA92fmpF7gv/7avrmoW8vXScHjhmI+69i87UJQK1PEm+rAe+vKVin6CiVfl/7DrWYeMBZMDfF+AnPvMqWNrExM705qrFuAETLT9syXNxDynq8xjA/ymzzRROOr+37nVqlhl3UTGgUTV9ykJ6BpinL00etce5XynbIm1jJIJReBf3DSUSZCw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 08:14, Andrew Morton wrote:
> On Wed, 20 May 2026 18:15:33 +0800 Chi Zhiling <chizhiling@163.com> wrote:
> 
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> This series improves shmem read performance by implementing folio
>> batching in the read path and reducing unnecessary xarray lookups.
>>
> 
> Thanks.
> 
>> Performance Results
>> ===================
>>
>> Testing was performed with fio sequential read workloads:
>>
>>    fio --ioengine=sync --rw=read --size=1G --runtime=180
>>
>>
>> ### THP Disabled - Normal Files ###
>>
>> | Block Size | Baseline  | v1        | Improvement |
>> | ---------- | --------- | --------- | ----------- |
>> | 1M         | 11.4GiB/s | 12.7GiB/s | +11.4%      |
>> | 64k        | 11.2GiB/s | 12.2GiB/s | +8.9%       |
>> | 4k         | 3809MiB/s | 3838MiB/s | +0.8%       |
>>
>> ### THP Disabled - Fallocated Files ###
>>
>> | Block Size | Baseline  | v1        | Improvement |
>> | ---------- | --------- | --------- | ----------- |
>> | 1M         | 23.7GiB/s | 28.7GiB/s | +21.1%      |
>> | 64k        | 22.6GiB/s | 27.0GiB/s | +19.5%      |
>> | 4k         | 4668MiB/s | 4678MiB/s | +0.2%       |
>>
>> ### THP Enabled - Normal Files ###
>>
>> | Block Size | Baseline  | v1        | Improvement |
>> | ---------- | --------- | --------- | ----------- |
>> | 1M         | 13.9GiB/s | 13.9GiB/s | 0%          |
>> | 64k        | 13.4GiB/s | 13.4GiB/s | 0%          |
>> | 4k         | 3818MiB/s | 3836MiB/s | +0.5%       |
>>
>> ### THP Enabled - Fallocated Files ###
>>
>> | Block Size | Baseline  | v1        | Improvement |
>> | ---------- | --------- | --------- | ----------- |
>> | 1M         | 24.1GiB/s | 34.9GiB/s | +44.8%      |
>> | 64k        | 22.9GiB/s | 31.3GiB/s | +36.7%      |
>> | 4k         | 4721MiB/s | 4708MiB/s | -0.3%       |
> 
> That looks nice.
> 
> AI review might have found a few things:
> 	https://sashiko.dev/#/patchset/20260520101538.58745-1-chizhiling@163.com
> 
> I'll skip the patchset for now (unreviewed v1!).

Okay, I will fix those issues in v2.

Thanks!


