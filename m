Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D2CD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 20:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2246B009D; Mon,  1 Dec 2025 15:13:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691CC6B00A4; Mon,  1 Dec 2025 15:13:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581906B00A5; Mon,  1 Dec 2025 15:13:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4637F6B009D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:13:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 529B213AA65
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:13:08 +0000 (UTC)
X-FDA: 84172001256.12.31FF132
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf03.hostedemail.com (Postfix) with ESMTP id C6F732000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:13:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=J1eoWaQR;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf03.hostedemail.com: domain of "prvs=4230525c4=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=4230525c4=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764619986; a=rsa-sha256;
	cv=none;
	b=cQ/Hqb2OhRxTk0q1j0+DfneBD05/FzbrOG3sj82bkrpX6ouajU+xGuNnTZApc3m22LVcRm
	SZfe6FiDCqNZaZw4KEc96SVewpN+g3aiq73bfF+gXMXpwYeHrRoRBUlLoXOZkvCEY5ut5L
	H/cAJM6Z/BsGseoUZRwQpnIWzZZhwFE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=J1eoWaQR;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf03.hostedemail.com: domain of "prvs=4230525c4=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=4230525c4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764619986;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jw7sf18yjrGUxi5LoRiNzSqIdVAlpc8gStzOjw+D3GE=;
	b=t3v283tNDkrayAMwAJXz+7WOlEdtywX+ry+q/+pu05yrfBpzxGEaCfsJ1Stjgba6IO9Yga
	CUzPxXZmimmn7/F70Yw4Uaw/FDssBERopkOVDdws1/0uAp+Bsy/tlToMhrih2khLDDgrnK
	UZn+nXDlhJWWpIU/uemxdSvBVNZMxh8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764619985; x=1796155985;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=jw7sf18yjrGUxi5LoRiNzSqIdVAlpc8gStzOjw+D3GE=;
  b=J1eoWaQRCLTa8gBDMw46ZyKV8niH4obsWBHzpt7rQMVwghL6Da6Ly1qb
   8/EEFWU9zYshYMX04tFlq0mAL+NE8owjQtkR/rKBgfarFcS6umRW2sRcD
   4p+fh62G9Tku86AB/z2h7B5FqoA+CUnnHmE7VKO/ZT6sLAqEDYx+ByfW7
   sF8mitOs+02u6Qh0tUvAGDMKnvvDUBmS8cR4bVRsVXg43nChIxNSNUnqp
   2glhjldomQND+c72fQnoAcqv1+p9il2v+cEq8YidqA9Ys2Y7Nw5isjnmV
   5+G07aleFzYlMYbqOyBgtdurDE2N9bBRWLx0V3VX/tspmIPOLCDXn0uak
   Q==;
X-CSE-ConnectionGUID: UBre7cQ1R7asxuwwMHYSog==
X-CSE-MsgGUID: Awp7RMVESxm3JxgQeF7zFw==
X-IronPort-AV: E=Sophos;i="6.20,241,1758585600"; 
   d="scan'208";a="6082826"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 20:12:48 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:2863]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.60:2525] with esmtp (Farcaster)
 id 72a6fd31-2cc3-4330-9bca-5a8a723d3114; Mon, 1 Dec 2025 20:12:48 +0000 (UTC)
X-Farcaster-Flow-ID: 72a6fd31-2cc3-4330-9bca-5a8a723d3114
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 1 Dec 2025 20:12:40 +0000
Received: from [192.168.8.132] (10.106.82.12) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Mon, 1 Dec 2025
 20:12:39 +0000
Message-ID: <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com>
Date: Mon, 1 Dec 2025 20:12:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: Peter Xu <peterx@redhat.com>
CC: "David Hildenbrand (Red Hat)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, <linux-mm@kvack.org>, Andrea Arcangeli
	<aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, "James
 Houghton" <jthoughton@google.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com> <aS3f_PlxWLb-6NmR@x1.local>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <aS3f_PlxWLb-6NmR@x1.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.12]
X-ClientProxiedBy: EX19D008EUA003.ant.amazon.com (10.252.50.155) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C6F732000A
X-Stat-Signature: dbkhzy9e5pqufkz4d4zgweu3nrqs3zrn
X-Rspam-User: 
X-HE-Tag: 1764619985-658861
X-HE-Meta: U2FsdGVkX18BkmMPocMumJrU9lKuyxHS2NKToZisnzxfHT2Xj6j9+eEusHtcajPJPnrKjZFl5Q3on0hSTHgiZU8X2o0gFVVfRmNVlIqUHPK8/4PO2414gKuvvE2pjlMzXeSrKPJRshGnvD98994vIINiJKmJkRIXysnqP/7gxNHZaOVS9ZiIULeRTd6T/QywSzJX6+MkaUKrWuVAAWb0BOnizUpI/VAeCKSR+zEtjy2zGlgS8pn0DiUq6j5dxfRQDuOBy1DwosqLrS5OMzJDHPxyJeXgtQnpF4z/vNH5GMpntlXZF3lySFsi0ifjSjcVgLRMxdjAysYDluttkukq8fo6RUjTJF4PyAh64cjU0+w72n1XcPkBXkj9bx5Qnlq/3BuJQph2qJFLu/OIioRQ91EALmNcl3wvrMcQwEsTerrc0zavTFtgcWT4kfGYKnN19Lna5Bwc4v5qDsN+Q7yLPO6yrutLKhBWoEkHAMm/fn/6m1YFlVp2Ka60i+0jMzpQ/nENeW6spmJPQNfWRj40sjBAgwfUMsiBOliOk4dvr2WEIC+p/iPVs9APgriJWSBOB4WTQpQIusaNw3OaXYxnSncnvPRozw0T8hljidbUE3TX3dhw/AGZINIJYGUxzIfts/x6GTmcYLKUtNWPzCcMSUH4ylN7yfBXxAzB35QvNr5M7rBOlfFIxTRcDitPNgFlTaRc0vc129ud0dj/TOIdSNLStUdV9bn8U7IaOiTdZaMjG1uix7J776OKILoZvOvU1r7bw2P4I5PM323i5E77nykixgylM96N7QU6H3dUeATUmhmkMmPZqvkEDaXb7hPx3Z+MP0RtYSNlYaCpKdGAwON2qBN+1zCB78TWuQzALUZh3DoXizf5VojNuW4aSPAuQkuXOzTWdaJUyOs8aVobvxnifFZG40L8IPfbSSGbMK8qw0/rA8khhQ7JNT0SRgZ17Gz9bDpi3AVP8zUXqDL
 vlYBCyuW
 yzrluhI6m4hbmrP9f18N+3iC4HAkASrru5cNZtH/fwqGI1t+Yc0OR1asEbrjG5UZQIresZxtqAUnGTHKFIo/hN9WsPyIqAjt+u2zpQGY5JFUwhGJMaupWKiidh+DaCTBILU/D4DO2tyFcZrDcDNIYvsnIxpgkwHsfXY1QmYLonC5mdm28MSGJZNewm3pzZBCId2g3nJTlRVlx3s9Mjer46mE7qpqyAdnTxeO109NvbEOjlow0Vk+PUN39u3sqsk248vUhUEPCAGkVFs3AbWYH/P5UoTizPqLlp2K5THs0dUAWUxL5qZfXRsTbAIF0SHf5f8sTCSX3jBE4ci5ggzz7YaidIA3jiKuHBzUGFNHpbfQVxKT3okS24Sr3w/wFdLNqZ01bGrvQV8GneTSQjYDIhVMuOGQdqc38yek3Ic22VrLCoBLkIlVVhPKYr1rRSs9HmMepVlyOfl/00KV2722ZfgwZB1c0TCIlnVnzhSEv5e2djylgi2l7konDU+OS+y/xudp2BkO+lWHmmOh5qP6PndPzhxk08HJWqNJZ10apEAAUxh/AFfpYA3xAhPgGSoKR7QgsjINNpFt8p0VjDjQXPdeejC9N3zebynmwfaNbxuK2vhKy2BsorSObZHrAB5OLuHmw4aZEQRmHlxoS/30gh7r5trfom4aT+oM/9Y046/AZzUEmm5rIXwtudOd2nIHM6JZb61ixwZHhNoYdNGNY0bnMvyf+w+UY3pNNJBwDMwiB5jxcBVKaHNifUdaT2W/RTEdf4Yag2odw3YdJBepH8NvalOsvyGUdyiowR5xzgvSP0TEht/1HXB2QWKNtyVroi+IUT7nv1grnK3dwAH8loQLBiXi4TmovFBeLaFhgH7t1bCC4RXU17R1v/oWICKHfTN+89UCeEH3Z6ez0Mcw2UZGkqm+ilxF8qIJhWd+b/RNQAEKx8bCrKWbNqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/12/2025 18:35, Peter Xu wrote:
> On Mon, Dec 01, 2025 at 04:48:22PM +0000, Nikita Kalyazin wrote:
>> I believe I found the precise point where we convinced ourselves that minor
>> support was sufficient: [1].  If at this moment we don't find that reasoning
>> valid anymore, then indeed implementing missing is the only option.
>>
>> [1] https://lore.kernel.org/kvm/Z9GsIDVYWoV8d8-C@x1.local
> 
> Now after I re-read the discussion, I may have made a wrong statement
> there, sorry.  I could have got slightly confused on when the write()
> syscall can be involved.
> 
> I agree if you want to get an event when cache missed with the current uffd
> definitions and when pre-population is forbidden, then MISSING trap is
> required.  That is, with/without the need of UFFDIO_COPY being available.
> 
> Do I understand it right that UFFDIO_COPY is not allowed in your case, but
> only write()?

No, UFFDIO_COPY would work perfectly fine.  We will still use write() 
whenever we resolve stage-2 faults as they aren't visible to UFFD.  When 
a userfault occurs at an offset that already has a page in the cache, we 
will have to keep using UFFDIO_CONTINUE so it looks like both will be 
required:

  - user mapping major fault -> UFFDIO_COPY (fills the cache and sets up 
userspace PT)
  - user mapping minor fault -> UFFDIO_CONTINUE (only sets up userspace PT)
  - stage-2 fault -> write() (only fills the cache)

> 
> One way that might work this around, is introducing a new UFFD_FEATURE bit
> allowing the MINOR registration to trap all pgtable faults, which will
> change the MINOR fault semantics.

This would equally work for us.  I suppose this MINOR+MAJOR semantics 
would be more intrusive from the API point of view though.

> 
> That'll need some further thoughts, meanwhile we may also want to make sure
> the old shmem/hugetlbfs semantics are kept (e.g. they should fail MINOR
> registers if the new feature bit is enabled in the ctx somehow; or support
> them properly in the codebase).
> 
> Thanks,
> 
> --
> Peter Xu
> 


