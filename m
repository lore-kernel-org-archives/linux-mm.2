Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1396ACCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 06:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF178E000E; Tue,  7 Oct 2025 02:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FE78E0005; Tue,  7 Oct 2025 02:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DCE18E000E; Tue,  7 Oct 2025 02:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF208E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:32:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7CC2160830
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:32:34 +0000 (UTC)
X-FDA: 83970349428.20.753E031
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id D1008100006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:32:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of yskelg@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=yskelg@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759818752; a=rsa-sha256;
	cv=none;
	b=deAx2RbHnDhvoR9ahgrPFgWyCoHNlSY2oL/5k92dMXrAeYq2iQSUYdbP+LezgSTD0qMq25
	urLO+nj/QHCo5zUp9KeYRUTy1ImyYZfo4EEE/IuRGvpvjH9MCom7u4rMyym+jRW3vCFmnL
	3o/Wa8ajFlJqHenT6EHoGRXlEATwNeQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of yskelg@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=yskelg@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759818752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KJGCKWDOB+HDW2IfjXMw+O6nf5o51khcjA2mbC8osTg=;
	b=jQm8K+7nZDqKIFcOdxVS0RMMd0nQmcLTYUeoBuHjDah1E1azSSDBiJTh5jfr0YX4SuOrmP
	xwvMQ5o6jz3XgPPSvmejuzAkGp1ahgkGPRReTDPAQVsQJbQgHPBKvI4alnKa2plweMPGkY
	GHOA7FNWiGPol5XXXy65pR2nHxWWyFI=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-776379289dcso477063b3a.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 23:32:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759818752; x=1760423552;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJGCKWDOB+HDW2IfjXMw+O6nf5o51khcjA2mbC8osTg=;
        b=WqSU4Idzya9pBOSNbMWj4BXMasJAAuqIttTiHcqexBEb+DvXXhgsRbRYvBFAk1k0CF
         HUGeIobCn5E5E1d7/HDpViwjhpmhR+S3xXXPx+pvGMUeuh7o2sPovefKFA9fpmbP3aiR
         jCUbO6dfJtYcgBb6ahFwnEeMnNKtR7PY8qNFML93C8iDoaGPexEWrIwGMAHGVhxw69zn
         Uxb7d5hoFtmeU2WTcwXJRK9lAkM+HlcWdwxYRJ7LW+Cp7vy+MObcO94eGZY/7xCMXzgU
         GLVmauIRuXfAmIchJNDexFihxVuuynRB9BuObpmRQkcSqV9j6pWFH/+Ym7oxahBnzAer
         cYKg==
X-Forwarded-Encrypted: i=1; AJvYcCU2mutV9xlv7L1TImWoUYYGeRTvN3ihkTLMG1nu5BTRk1GQFxB8uwdcES2SlNo7dBA9+iCzTLNFVg==@kvack.org
X-Gm-Message-State: AOJu0YwnsUR7hkr5Sln1Q4e1vpAMI7zd/d16ezBjHjY8LJ9dMRs2Sv2W
	wKQx6TKBEipCYbkwWX/xdebHeCog3y2Vq6StgTrl2F2cI/dPdzMPA9Wp
X-Gm-Gg: ASbGncv16kRJqxPxRxjTTbsLs5A7mtVnnOOiphz6HTEJkeZJnTaG2qoeciOKsaQJz1N
	6oOfqNHWIf3CCsH/YWwUSnY7yPk84uNXm72QeOLdlNiyFAJndQf89Gr9Mj5wy6T73eMBfS+P9GL
	O9dTOv7Pm534eOjhDTWoNcWqOhgL3o8mmjqHUrVNiuBXFZJSkalftrfxzbxML04NsP2ljVqe7In
	SWG/N9YNb8XXbjm9zfn13TVjiNO94XsREg7UeXXAA8CVvLL48mBm88Vxebh2LnbeWsZAj2AC53I
	oac+UPsQZjZG9KtZ2gtsAt4XNZuRjcoL7TdRO3DXnJbozW3Jf84kc5AG9q7OKHMslZBRxOixrmn
	yI+8ZNSrlsxkie7yMTH5mDuKMV9XRYNoPiODMnkxZAy0zsq/zaHUtbkpqEMveqLlHPoNciMpwiR
	ejxq67RI6tHarU2attykdPRIDkTLFk8Y9VdK/3J/ni2PFs6/PgJ/33
X-Google-Smtp-Source: AGHT+IEhca/DKV1gkMLzYSeFHCblQernrwx8MiefUNdEs8Uem/33USeoThMFjQF25dXOu6Ao9GH78Q==
X-Received: by 2002:a17:902:c403:b0:27e:f02a:b280 with SMTP id d9443c01a7336-28e9a65bd1cmr98147365ad.5.1759818751599;
        Mon, 06 Oct 2025 23:32:31 -0700 (PDT)
Received: from [192.168.50.136] ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d110cdfsm153463955ad.13.2025.10.06.23.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 23:32:31 -0700 (PDT)
Message-ID: <3b66d603-543d-4616-92a5-9e6e32f116be@kzalloc.com>
Date: Tue, 7 Oct 2025 15:32:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
To: Byungchul Park <byungchul@sk.com>, Hillf Danton <hdanton@sina.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 Yeoreum Yun <yeoreum.yun@arm.com>
References: <20251002081612.53281-1-byungchul@sk.com>
 <20251002220211.8009-1-hdanton@sina.com>
 <20251003004828.GA75385@system.software.com>
 <20251003005230.GB75385@system.software.com>
Content-Language: en-US
From: Yunseong Kim <ysk@kzalloc.com>
Organization: kzalloc
In-Reply-To: <20251003005230.GB75385@system.software.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ragcmem9z5385k1r1spqrrecf16a1xjy
X-Rspamd-Queue-Id: D1008100006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759818752-740606
X-HE-Meta: U2FsdGVkX1+mrjo+K7eTXyI6jgWr/yLZ+qXribMeq396q71R1Zr4nVzRV6mHEY9Ls/qLAs8KAsNgYhkqjV60er6RSc/reEHSxyZSJo+FywIrpX63nNE3heLyt5/IRW0byaCKi80trUY7QkkLvLDFRNTTGRD5K1WBqnMZ3q9SjbPJtSaezQx1M1G09OOSLPWouGhq3Xyduj+XGeGVLNGakAfWWchvH4T9/3vbknsnVdeZdfXO/JovNlxJu2UgwlzwpMya7+uNrBAvv7K/TDj/tDMj6w8moxG+Yt0v2OdGRrHp0K00j+ZY3cL7UwOzJf3i4z2SZE6DNsw5i+NkzkHF4CS4YZNDmn53J1hQ4z1jXvmxag0B8JfbirbD7v5bVucMx1duJMVGzfm8hFDYkGaSOrvC4AFW74fe6EK1SidPCHRYLxb5PiQv3zL5ZyWujzDbAe6FtdiJ7QGZn7vGHGe1WG8+A4EnTDU7Q+xGeiimrGs3KG3fS1DpJByoIGbbL1jhPK6wmQvMngUxySprA+LGo1v7KUJxxZT9gY3mc4kkdQnWU4kOygozRvhC01y1rqQVz4Pei5qwCZp3Btpo2/m/IaegirFCpktBkvyzIanp56Fa0rbiCYzDIM4gdorUvjSOs/OVTcGqYdL+2yXwstNN4iTl3oFVjri8JgWG9mwj2QHtXKoMR1Oxyx0PCc3H60cfU0isEgLKVY+CfJ7mJ4YD7uiaBRLNt1cKOIustkZPUHsYAkI0HqvIIdJo84khK3JoukAcgF1Bfnu4HdW0CITO1wJMbNatpOVKRHZHrIUtO9b9H9EmG1LaX4V3oQx6VFkgc+xQbFWpGbOY3XSOAWhAj9K5BliyR5ebw9Vtbifjvegvz3FjI+AB0VwNwwPnoRMClaH2zfW9Hr18I5k+oQkj7c1PZHUae7D2V8P5ZsbqNSRIDBoz76J6/PGjidKYjKsMZzNfv+LHhu/MRb0oHvk
 Al9B3US+
 lJ+MfqOPAq3oMLiyty+3J67wU+WBPkMGK5HGf8MOJCCh/GmO7yfqEABPn6/emmCKLS6MmyDwI7AXtR6Ad3XNNXd6/tFyFSpPr/fM6kN8RIL+NL6g0T6bt5foxyKtSGZjybmSuvDT1vNl2maH40IzfpKHFd628JT2a8LfOTSfsadSvPeUEQ5hXzuALmA251RIkMgcePlalJjxIC5D0XI9yl+u/l/0TtexPDAFzF8FINIRBYfA4CUzHOtFNqAygfZyxd+HTLUu4+7hfFoH2Yw2KRZEXuyplUaYQ353xSqGs215zJkXhlC9agp5kN4RA2DXu+t9cwiP/f2cE0mDq9XSELubbnquN7qnZfVN910AlKXFCVqW5FbFST/vKEx8i0TGZLAkNidhlV5C0cntge9yYJKE0CPxeDVNTbn5JR2Iu4Eq+9LlgQ37bjWzGp9rpYCIsef4NLpnIi6qRC53KRCCoK+T6icQNxqTZ3kD1zGjHUGmW98k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hillf,

Here are the syzlang and kernel log, and you can also find the gist snippet
in the body of the first RFC mail:

 https://gist.github.com/kzall0c/a6091bb2fd536865ca9aabfd017a1fc5

I am reviewing this issue again on the v6.17, The issue is always reproducible,
usually occurring within about 10k attempts with the 8 procs.

On 10/3/25 9:52 AM, Byungchul Park wrote:
> On Fri, Oct 03, 2025 at 09:48:28AM +0900, Byungchul Park wrote:
>> On Fri, Oct 03, 2025 at 06:02:10AM +0800, Hillf Danton wrote:
>>> On Thu, 2 Oct 2025 13:38:59 +0200 David Hildenbrand wrote:
>>>>
>>>> If it's a real issue, I wonder if a trylock on the writeback path could
>>>> be an option.
>>>>
>>> Given Thanks to Yunseong for reporting the issue, testing, and confirming if
>>> this patch can resolve the issue, could you share your reproducer with
>>> reviewers Byungchul?
>>
>> Sure.  Yunseong told me it's 100% reproducable.  Yunseong, can you help
>> him reproduce the issue, please?
> 
> +to ysk@kzalloc.com
> 
>>
>> 	Byungchul
> 

Thank you!

Yunseong

