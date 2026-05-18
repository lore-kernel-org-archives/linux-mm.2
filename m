Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 740BFCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9A66B0005; Mon, 18 May 2026 02:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99B36B0088; Mon, 18 May 2026 02:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0F76B0093; Mon, 18 May 2026 02:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD6E26B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:39:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3202091810
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:39:24 +0000 (UTC)
X-FDA: 84779589048.13.1ACB92C
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7E4B740002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:39:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lRTiFQOl;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779086362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUBLwiSnJ+yN8ROsUfa/+tX1XkZcgIDIxGet+HC+cC0=;
	b=vr2WP+VXsCPQGhi9se/gT2lCa75EY0Bq9wkJ1xmcL0UGzdbGlz86zDFGuJqFFVRSCXB8/i
	9b2fpyVtK3/TrulXybxsh3LURt7U2cGmLSltQq0FilKxkKZI2XtLygQxk3hzIvPOde9Om5
	68itjBsvQ3gqLgTo1gqgz3Qjs60irxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779086362; a=rsa-sha256;
	cv=none;
	b=cIc7XyUKpl6utAyzO1OrPvl7mA+WKXWPjZzrl4WwfAG6ubUXWKlbHW3pdbm2NSQ65Okx4G
	Vw+sGJQj5F+8GVpc1GBYJDnmxe6/h5N+nNwNW9f0EJU+PU7gyX9tBAj91MWRiNdE2n+Dbo
	xS2CHq5MuzgHtc4DnHXCMmF0OvyEm4g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lRTiFQOl;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779086356; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lUBLwiSnJ+yN8ROsUfa/+tX1XkZcgIDIxGet+HC+cC0=;
	b=lRTiFQOlmqq+ks0Jiwusy9FW4PIfkLr9WPB9dPFmuU3iiYH01Cxcp//poNQ1AxUA0NzjQs3M0NhyEInHXNBaawRWRQqaCyynWqyhBPKnogCVf5izrjoSce5YoWad6bF0PbZcI0I74iIbeY/3fk9XpGoTt4YUsI/ikMTOmA5dd0I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X34EaX1_1779086354;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X34EaX1_1779086354 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 14:39:14 +0800
Message-ID: <c0a6e4ea-3ca5-4efc-af5e-b5abc968308b@linux.alibaba.com>
Date: Mon, 18 May 2026 14:39:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm/shmem: use SGP_GET in read operations
To: Chi Zhiling <chizhiling@163.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260515094702.1092355-1-chizhiling@163.com>
 <20260515094702.1092355-3-chizhiling@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260515094702.1092355-3-chizhiling@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E4B740002
X-Stat-Signature: xqp93ac4h7upk7b3dm5jx78pswhy1kw3
X-Rspam-User: 
X-HE-Tag: 1779086361-820223
X-HE-Meta: U2FsdGVkX18lmeuF3Sb+60AKRgjuN5RhJ6Dfm48yjX5f2HW9CKwJ9TrvbnHb9oCNeej3kM+j+DOOjXKCxonzS+XIu23m19r2Bjbldt3R3syduNDHDBMDyYWWB50GhARshcwz+/EW0qv2nj5ZaSHECg09N2Et4hfcexj5wd1vRC/++c4iLZjfZ5guy039r6tK6P1gn6JVbfChVy9ATL+C0+fl6YBKqqgJjH+yuYMbEsh+1AQIupRSMekroW4mHp5hN7nH3dMSIqqpuKhpKp/7CfF9IeGmRcNoHESTsnRAvza48p4h5vNSc/ijjS7MIGBcsup9b5MX1doFEuaP7l8MxAc7eLvBwCYlaSqkG8qSxrMG4NTkPbL1c7zzTpB4XMeZWKGFWKEXRYRX2FOn9118/2r7MAoqOL0eD1g33yfotD26XMIDtIah9m7muMng5eIIX4fQQWBs+GOAzab0dQcU1muIqdZ8s+cwPPYGOrYFIO9Kq0BBcX9kespr+7UGAUik7idbBg1UD2w5P1gVDoTLoEVv5bAaUH2tRmSYzFhbKhiEhRDRUWBBnRko7TPu9itbnBIIXvYy7V/8QBOWv264tyTWjbaqOHOvglKettGCddCyLycbjHjrKCHsZnjDI4NTMeb83wlE9CgBxxatHPtX/3Kx94vFvd0eA6vRPGZHR9MX1Wls415rTJjdmw49V6oghk8gnWEFpu9Mmy/s0f5xhkbrcxWCY0QDlhC/6UB7t+jwSE8XFOwzZCyFjP9jVXNI187USgQ2XDfqq1AR8DoOobJOGWt+RPMcxGWCTLjUEhl9PsUe76GCmDpARnplWoi8A2JNEFJn3ENZTDa+T2ugcxzphEhM6cX1yjiaP0Fyl4eLh803kz5kEAJd/Pjc5IeW7CbJ3cpi5tl2RW3+DNXZMR8fGmc3eY0RG0k0tvTGxmayWSOurlHAtpSrXzAmgmKZTD0DNPSeLXrh62KOeSw
 dNH1bWKf
 Zhg0aC49lADXBQUa92waYl14558LAOvCZVnT1fV8h/iP0g14s/mA42OReDuXnSN9xs46gpxiNOPiD3lWioCSPH0387SUlWCM1CAIdJjKv1SNl7+mIxXytDRMLg0a1lRezmokGeVjR0DDq6hsW86f7nAqqu4OVgg/IC1hOYfDPzDwQO18Zhr7qvj3NCg8heJdv+21ma2j+gyhmsWLst6wqDf4SqF3kQ7Q7fhnYClQZ9iJSC7QbrhYfFR9CYr5HiJo3LaVAMzmj+TDKVO1jwTOeV16SldqeW6q8vSeBcOHnYmhP0B4w5x81NMYmS14BnoXgR+Ttq0x7nGK4vF/Q4sc2L4OLLrM5Ya8xG1AkFmjL3Ih2knA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/15/26 5:47 PM, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> Replace SGP_READ with SGP_GET in shmem_file_read_iter(),
> shmem_file_splice_read(), and shmem_get_link(). These functions
> immediately unlock the folio after getting it, making the lock
> acquisition redundant.
> 
> Even though folio_lock can protect folio data consistency or prevent
> truncate while holding the lock, these can still happen after unlock.
> Since these functions continue reading data after unlocking, the lock
> does not provide effective protection. The folio reference count is
> what actually prevents reclamation during access, making the lock
> unnecessary.
> 
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---

Thanks for your patch. It would be better to squash patch 1 and patch 2 
into a one commit, so that the usage of the newly introduced flag can be 
easily seen.

>   mm/shmem.c | 12 +++---------
>   1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ef19968cc51c..767610f78d0d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3370,15 +3370,13 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   			break;
>   
>   		index = iocb->ki_pos >> PAGE_SHIFT;
> -		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
> +		error = shmem_get_folio(inode, index, 0, &folio, SGP_GET);
>   		if (error) {
>   			if (error == -EINVAL)
>   				error = 0;
>   			break;
>   		}
>   		if (folio) {
> -			folio_unlock(folio);
> -

This is incorrect. Since a shmem folio can still be locked if it is 
being swapped in from the swap device.

Essentially, you need to show reviewers the benefit of introducing a new 
flag. In what scenario would you see overhead from locking the folio in 
shmem_get_folio()? And how much performance improvement does your patch 
bring? Data is the easiest way to convince people:)

