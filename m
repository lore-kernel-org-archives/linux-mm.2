Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FC62E8B386
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 01:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA456B0005; Tue,  3 Feb 2026 20:00:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78256B0088; Tue,  3 Feb 2026 20:00:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A2146B0092; Tue,  3 Feb 2026 20:00:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8974C6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 20:00:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4088B13B5B0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:00:16 +0000 (UTC)
X-FDA: 84404968032.23.FC53EC5
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 344CAC0012
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:00:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nJQHM1xK;
	spf=pass (imf10.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770166814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETtAgu9zn2DbdID69yeQZoqXuJNNuYg+Fj5vMI3aElk=;
	b=Bodss6lVgLd6l+rTMONv0rsNqYnR6eCtoTymkXYsGJdmtrl/J4YTJOCX+F8Zedt5Qso4yi
	ZDNAPNwvwObFpQgFTvntA6I/AXKEZkH6D0OYOdqenqSNFgRXAw65/1qh3NIeyuIC/I45Rx
	FLsL8YcaTLlUeTlfRQHCJoDHFDieits=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nJQHM1xK;
	spf=pass (imf10.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770166814; a=rsa-sha256;
	cv=none;
	b=Mg61aX54CZLOR14zC6xr8jYWlgx5xZ9hbIgmsybEFwS2BcB+v1tbqI7KdGPA6FKgCnykQv
	b/0ELlAXBD3SP1BJwR0o2m3Q3xSe4RX5miG564H+01/2gu78AN11lqPQdoFT0GOorIZRAL
	lUY7NxD5BYKbaOPziU9NvlomRtZ5bQ8=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-124566b6693so4993673c88.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 17:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770166813; x=1770771613; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ETtAgu9zn2DbdID69yeQZoqXuJNNuYg+Fj5vMI3aElk=;
        b=nJQHM1xK+UT4lBBYKSGBguqtObq689uOFh8rWzlRr3s4lAy0Nmue7s3s7jSfjTWILU
         DuBh0MScrbJRZM//Tl5LYrXIbx3ieldFYYV8lIYW7jeB71mTcNuJTxVo+aeq/x9zDwUY
         9j5osFCr7VaAAI7lDSyNdoPyQC5CJCYwExFAI02SMyMV2PZb8p6cqkfuSYv/DbVzpH24
         tvVPfPlOY8x4E880VvKTPbuu5FuatGmbrXeRoJIHUwPDjJ6dai7GWQFDog6IIGJ/PmQ+
         25fealfzpwp9Fc8y8Tfvlx5byFnd2RBjVzImzAI+lxqzeWAz/4v0HXeg+UC7QOCHbdbK
         TdYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770166813; x=1770771613;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ETtAgu9zn2DbdID69yeQZoqXuJNNuYg+Fj5vMI3aElk=;
        b=L6NwJ12u+4h1B9jLcg5ffa4cY4p84fGitSrcK1sTyTNjbryHi/YTJQiIBm2Xj4Mznv
         NN0FvFv8H6/HYLZFZa3Hd7ub5BCmbfSu+3/gSCwTMZ7fqZuYoy4hgYUFkDJ25k3fm0af
         QUo0wWup/0EX8u8vz+FrPYsElzf0R6/Ss8oes0htUnPmhej15u5Su6zzu+mSdeQbF3bS
         Llncr+S10Kdaw2ALiI2HgdwDRXR1g4p7zbUDNjVvmLdv82RGr8M54x0HTw86W1uw9rdJ
         vUaMx0AcwL/geDFJKVqVD582dTE9VrYYnYyK6aHYRz0ev+dST8QJwGf0mg9lMrKzld92
         8vAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHkqyrptvJS7AyQo/76EiHFcFG4CAoInmZxniCOIMBOXzgbm9JYnoHztxKh1OHBCl1MX6Kz7lOew==@kvack.org
X-Gm-Message-State: AOJu0YyjlTGqqNcdtfBm+3jckb4HBAJL5B8/ASiCxDKzIclnsYKxkHky
	BTCayw18FYC+4ulpcJFNZG60/eNt0xDjQqzOa1rksILE306yTQNvhTfY
X-Gm-Gg: AZuq6aKvv8N3MxWtashXNL3enKaGRvTu85Y2wCxJMZadI5cch8DUVa6M/D/X45+1QcM
	3VV/ppNBjWGloXsMO3tO+6UcQIMrTVH/W5n9eYGCTQCYr0btW1YOtiRKpFuGgrqyVPQ6rHRakMd
	GtpUoUaEjHf1KECtS8fWdcNtwByir6YJ0rQS4uum3GJyCq3J2aBjw6WdqfmUIno2fTOA7IJIbnF
	1+ZOMPacYitGfCxjmeIBqMO6PeTIc1CdS8qEiCYRJo4j1OqNgh4LMjayPdlFdqFFJGhBROVYUhr
	kfgxf7TSU+hhw6coxEiGOlxyCfmec0KBuxR0Elvmb78sQaJOA3wMSDIXd2u9jDKIkDlv2wegApt
	GZavPKG6KmyVjMG5v38GrJVZ8VrBqbwzI6ovnKAVgDcwSwITWth48p1CUxL9R285stcpO/En5GJ
	GcqpaqjWK2Hin9NipoCpcpCDinCbVsYQqAaKA9aJmPy8YezkTdmx6J3QW8I/QARV4=
X-Received: by 2002:a05:7022:418f:b0:123:31dc:e8b5 with SMTP id a92af1059eb24-126f470cbaemr700307c88.0.1770166812500;
        Tue, 03 Feb 2026 17:00:12 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:1cc5:26fe:6b00:bcef? ([2620:10d:c090:500::21b0])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f4e04467sm654039c88.2.2026.02.03.17.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 17:00:12 -0800 (PST)
Message-ID: <2efaa5ed-bd09-41f0-9c07-5cd6cccc4595@gmail.com>
Date: Tue, 3 Feb 2026 17:00:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Content-Language: en-GB
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <e65bc740-8e20-452c-b66f-0e13cd4e9c59@lucifer.local>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <e65bc740-8e20-452c-b66f-0e13cd4e9c59@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 344CAC0012
X-Stat-Signature: o75jgzc43jsk58di19bsgtct96btx8hi
X-Rspam-User: 
X-HE-Tag: 1770166814-183216
X-HE-Meta: U2FsdGVkX196xJJ98X/cEr0kTwqmbAA/K4JgaiWzxO/WN/TMSos2AVVLdPdibLhuf4MVyN2srpYKvxJkisT3iJCyauSoeRAPwxu513Q5x8e2fXYXQ0zoX1uQV6rN6RDG2LBlbGhIEXrUBhI60dG76GXD1TFvMhyUTMGurDZN2fUsAoIH1ntoADOANHB9ZUwKW372beiG/PvIa1eGcgVKV82QHeCknp4V9FH5VS+SgZrOEZvYDqNzXi3cWbOmPzTkTr5TCxLWqXYZvhdYqMpnqS2v3zeakefQLrAQPSPEEHds2ABuFAP2vCh+ISJWet4Ylpnr6c4TqUOixgWgA0RJ+Kds3Pj1GUgd2d0aagy5Cnf1bHDq5wV0iu6b7YG5vJbjxaBRFDFQppR+/AyVuBwlSrXDSYtF5DSh3HFhYquno9KduxiEgB9nv2vAocsrwkgt5UTs1Wju4sYs0ZLcgAJhhH03sbbqVfwITIjNct4vDPDfxnaJruFqYFsTb6ygqKdub74572kbMm2Ab0LYyOn9gNfdq5gEAvR9j8LeT0k0i7FnDnwE8vNRPZlCFhDDIOgnnae2Op5n5yYenjYudsZh6CrzMb2rqgJgGdCu09NwogEyY9zf6IMOg03u0N2oQvEvvpjFxjPsAKmlsSnKNHfmto4j39kayKUr+LhmQ9hDXCImPfUea9FTxfSW28xwwSFqOrotRXsgBFZp0WydirsLcsOGvzixXQlE2WaDuVX0T8J9I0/dxoOh9l6LTkPvkYT4sWi9T0U50TtZUKir5Hj5OsJR/uL7TvaSQyQW2x/CZJgMYAshHdP1ajHVRpMZ4zsfxIGdJHDGggi8df4qiZdRMF9NB7bQDSMQ5C612ByLfRLfi7tbxb6m18so7ZpyHSyAbH6NlWcF8WX+dDHTmHX2NLA1LEmLlYN5x3Q0FTq3tUwx7wIl/uRq2cUo4jIT1W3ha/z6eV+NUTnk1QvFJDA
 ghVbmb8N
 /tLXP/3wrJ89IzbULm+FENcHwMipuWuBq/DFpy6eQ5/NJnvbAW0BwkTHsC9zhHaCEBL3itfVWmzGk7OHM1vDokpTB/YB6wj47fI15Pa71KQ7Z5L6R8lTNsyGRffzRQmQ+m7vqhQE3Gq+emgFFTe5oGO6DhcmxbDlA5ijMptp5Yq5/d/IBYDc7E4tIG6n109OnsQcGOWJmP/3mmZxdUaIe30tzP1qEGUtpbU0ld4Zr/wpH+0x6LIv9gQ3+RA7RflnVRHUroYT1QyKTNrghxSirn65zjCXvhwTxE93VhxCc+etILxpyXqw7kZlQ+efPnF+tOtdKygic1AMp8FY4cnW4gsq0TaQxstHOhsEDz/IN2uWS5Df2SUzbBIX8e5RNtu2vpJqlLHknkBiwLO+ZglkezJYgD7qAizi6B6zskJYJdxc4Nd4KmnVwQXq7iR7BXFZmGYU0kioKZy64zrAaKa9FD5fiHZQSEtGTeidqh68qS/n8lyteB3+hoWCgeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/02/2026 03:20, Lorenzo Stoakes wrote:
> OK so this is somewhat unexpected :)
> 
> It would have been nice to discuss it in the THP cabal or at a conference
> etc. so we could discuss approaches ahead of time. Communication is important,
> especially with major changes like this.

Makes sense!

> 
> And PUD THP is especially problematic in that it requires pages that the page
> allocator can't give us, presumably you're doing something with CMA and... it's
> a whole kettle of fish.

So we dont need CMA. It helps ofcourse, but we don't *need* it.
Its summarized in the first reply I gave to Zi in [1]:

> 
> It's also complicated by the fact we _already_ support it in the DAX, VFIO cases
> but it's kinda a weird sorta special case that we need to keep supporting.
> 
> There's questions about how this will interact with khugepaged, MADV_COLLAPSE,
> mTHP (and really I want to see Nico's series land before we really consider
> this).


So I have numbers and experiments for page faults which are in the cover letter,
but not for khugepaged. I would be very surprised (although pleasently :)) if
khugepaged by some magic finds 262144 pages that meets all the khugepaged requirements
to collapse the page. In the basic infrastructure support which this series is adding,
I want to keep khugepaged collapse disabled for 1G pages. This is also the initial
approach that was taken in other mTHP sizes. We should go slow with 1G THPs.

> 
> So overall, I want to be very cautious and SLOW here. So let's please not drop
> the RFC tag until David and I are ok with that?
> 
> Also the THP code base is in _dire_ need of rework, and I don't really want to
> add major new features without us paying down some technical debt, to be honest.
> 
> So let's proceed with caution, and treat this as a very early bit of
> experimental code.
> 
> Thanks, Lorenzo

Ack, yeah so this is mainly an RFC to discuss what the major design choices will be.
I got a kernel with selftests for allocation, memory integrity, fork, partial munmap,
mprotect, reclaim and migration passing and am running them with DEBUG_VM to make sure
we dont get the VM bugs/warnings and the numbers are good, so just wanted to share it
upstream and get your opinions! Basically try and trigger a discussion similar to what
Zi asked in [2]! And also if someone could point out if there is something fundamental
we are missing in this series.

Thanks for the reviews! Really do apprecaite it!

[1] https://lore.kernel.org/all/20f92576-e932-435f-bb7b-de49eb84b012@gmail.com/#t
[2] https://lore.kernel.org/all/3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com/

