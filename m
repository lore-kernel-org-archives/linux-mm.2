Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A07A1EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E246B015A; Mon,  2 Mar 2026 16:04:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC296B015C; Mon,  2 Mar 2026 16:04:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0DB6B015E; Mon,  2 Mar 2026 16:04:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0A46B015A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:04:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16CC6140330
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:04:08 +0000 (UTC)
X-FDA: 84502350576.27.2D407A9
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id CDC031C0014
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:04:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=0s07wgvs;
	spf=pass (imf18.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.173 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772485446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvIDDVWC3amChzTdZaAU+7HRWfu0rMD4zIP/5WJSg4Y=;
	b=0rdL/q9ipFd685IXeh6OK0I5LFXIClaCYeAw5pSWmFtlZc2NjYsTYPkqz8rGYZHl7LbUco
	NbAPy+r5qhrCUz2CSC9U7cU2RyepzpS8woWIJENg2Cw35nHtlUCz5TREKB3JNg4gRe8i/G
	O+ANhExHCiUtedYZvOo9mjCI2WRKMKY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=0s07wgvs;
	spf=pass (imf18.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.173 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772485446; a=rsa-sha256;
	cv=none;
	b=0Dma70V51XUEZ8ZvEbarVkakgUyhmwzyH1UV35PTJ3BtN8OfGhpna61ID98PSyY0SemMcL
	qfvpaRhhp3S5uhu3asDj53KiepHR0SJgSKcmKZUYBKzD2YJ+C7kZMicEWBdXNsXLeZ1qR2
	BOgnevfpnXUg7bB7Z8RPwIr7M1JMTMI=
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-463208653d6so3971174b6e.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 13:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772485445; x=1773090245; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UvIDDVWC3amChzTdZaAU+7HRWfu0rMD4zIP/5WJSg4Y=;
        b=0s07wgvsqVmkBQk4GfnFSgr2vPMuZNa7XCiN9CAP3ZkE8PdbVWF6m11kbFfD4+5pI2
         kGW8rDgmyNBX9xzKZzLdJW2UdNYVM6gVS6S64r/T4DFU48tnR8PgTAjGmuyl53dy3uAQ
         QdubF6Lgf8KtlUbEh2xokmaaZwomG6Kt8apWnTBsEcFqY6LJ65p1a7/KgwAGh8hjW6Cu
         Pvu2BEmz4h59wUB4FbReC1RHHnWHzquPCxmtXmwOXtYYoe477I1bOOoOuateugm0tzT/
         nrIkU1xSu4LZ3yRftO48CUFejdbozG6QC80+gvBD8DL1zRob7BHQ4Nlej9U0yZPf7I9b
         SOXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485445; x=1773090245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UvIDDVWC3amChzTdZaAU+7HRWfu0rMD4zIP/5WJSg4Y=;
        b=atFeTcZQwfTBtNZlcqhts1Wp8uIoJGFMU36DMxDgR5kyyJt1nqc+kAFTM7HcuLhjvT
         xlqTk0kpc6ND3y3nH28gWIP5ie9jkzTeZwUvu6SXPXGafNyRBwQM2zUP/W9Z1/U86CNf
         j6tOd5/hhDm2vitPnhy3baBMeA7hWbj2rEYxi+9NDUbgkyhwdmfun+CqhE0DuEcno0m/
         05muROYvrhWWYXQhv2iT0bzAroIhSVcba2BBDxwxsca2j/3OhTAPi2MdaiCa/6tpIsX9
         lXj3smMomTKZfU85vOolHKeFEZPPC3vXy2HL/j1h648vBLVvr77I5wbshSjoU4wFIHZH
         mJfg==
X-Forwarded-Encrypted: i=1; AJvYcCVfs2rcaAn1bC4ZOS3Nmf1nYnc/Apal5LG0da2EZlkJQAL7uGtGwZ2+xffPhg5pbmoXFWZHUy8VYQ==@kvack.org
X-Gm-Message-State: AOJu0YzE7lk4uzd50mA1fDAy1SeAA6A8u37zcf7E0paFZCnCqe6EP9Lu
	iADyE2xID33aDGAY3WmhbnLqBdsZHMpQVVg10A1cVNQEN4kABF4xigXprQs0voSEgCY=
X-Gm-Gg: ATEYQzzDw5ReRPx7jKfGRQQmAj1wmTmy6v9InZJ0dVKWVzodKv20YnjbMoVi6Y4D8ei
	qMZBXrU8GF1iCsYvAJpT9x83HcHmAZBxVLaiBSj9vf4bDdWA8V5veheew1FlCV1gVis8ocPZQZs
	Ww6PcBClwbsGXibLV1tSFELcUx3Is40zShv8JoJIpicrnh9SeMpfrySFdNwmSQc7ejSseHxKMxA
	aofrNfvEPUX3xTdqJaFKJkxqbySs5noGKT3Zu6EjDItFA4LP/ulC6Q9qrURTn1/nOLkGGzybkd/
	/XP4aSy4IkTrXSawplHI5mTnOjx0zz9CDEXD+HQVkNvBJGpxf5KDbDnZkoUqN4hi/00IPVONqvj
	9Df9L6e9RjA5+vM2v4GY07RTb3PQScpJEpM85dlCtkzcVLHKfOzzRCDJuG83jJG1RTAeKdx0LaO
	CwVEwxuXYkic4CnLGuCQc27WAQgXStm8qQoffKE8HPQpYRI+xzosX5xtRbOqZS7Qp1kMjNuAwai
	5fMJKKXI9Y6x9sZuLfY
X-Received: by 2002:a05:6808:8281:b0:463:b4bd:5287 with SMTP id 5614622812f47-464be921973mr6434178b6e.11.1772485444663;
        Mon, 02 Mar 2026 13:04:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb3ab302sm8292175b6e.7.2026.03.02.13.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 13:04:03 -0800 (PST)
Message-ID: <40e13629-aa4c-45ba-a2da-b7614961def0@kernel.dk>
Date: Mon, 2 Mar 2026 14:04:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: remove bdev_nonrot()
To: Damien Le Moal <dlemoal@kernel.org>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
References: <20260226075448.2229655-1-dlemoal@kernel.org>
 <5b8c1811-c9d9-469a-b8d0-992814a11b9a@molgen.mpg.de>
 <a2993605-2cdb-42b2-85fc-b071f07af4c3@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a2993605-2cdb-42b2-85fc-b071f07af4c3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CDC031C0014
X-Stat-Signature: jpoz696qzbzdcd34xcd4adtwnunsa7go
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772485445-489556
X-HE-Meta: U2FsdGVkX19l2JSY1Btubjqo2eGpcJc5GfktDZszejQ+3WnEYDHPNpxWcGCM+Xwm3s51073ZRpsXhO0ChyHkphFFZ4mhqm/fXc2a7jkv44w5rDH0WGwa2NYT5jVq2m93NOelweAIcOo6sIREOdSK7FXGj60gEDmxMX9Hv6ZnnCTAzQut1WytpcVaQQJMnW/OxRkbRssCe3vC4abiaZTzFP0W1xtS/dkfYOEr0xqmiCiOVPRyRh/IgNd0hadddjZyyWotvM63GF/W+ypx7fgHUMXDAOl2NHojMEZ525Qlv1YqnAwct/lSUcX865w3pabu5IboD5eGV9i5tl5F3grlEoqCXRlNjXhmTbCtAnd/tuZPf88xaTwyRBd/mB32aTYgnjTWmKhQG7dnazeZxCl1c204UTYyKHS6MfNxMs6x7jZ4/EUZ2GOog2ExUGLF5BddnmmUV+839F5V2jxQnj831N0dUEniuo4A+ZnvOlnKOdodoOPTsq2RCb0W7RSMTySiUzsHRZ+I70hrdzMX0KX204zpuiiojk5I11gWINhcfwOHcWC8qFhU9KmHPEiqBlyklUYWcBu9uvW0qacVqGezBiwzibUZAnEKrJ2gG/mKX8a4DHGbhL1gK4Zo4RQUYqeczjlQ3M02qGjlYN4h5HV2lmVQhx1mMlUeUz/iBIkTyfAgWdPmdU6piwCeNLEKTBzIHz2f/3+MqmVfxw7wDtZLC8FbpT32gBGRkRmQztkrk67QGq+kfwEVWOfqHXRXm+TDmg/vV9/V8az/+Rl2YpSe/MNbXvbQs5ymwB1RVVYrMxyTRRY+SEjgQ+T1CmV7Bp6WMACHvYQej93kGEwsLspNHrQKtKAmEXL/8NLivmMvr5Wq7UIxQbcfyRasCwGv9oc31SPylhpmKMpiMcdWvHpOS7Fq8Om/u7oqB4YnTHKbr3VpbsJSNTVTPrBXmE2GfbsHX2QRnpK+jqqngkmQb42
 fB393Fk3
 YojJrXSvSy1mUIRqtSbgppDzMi669CgYvgu9k0s9eLGrmrCmUmqrBjaoiVXBXmRD2yjmxcIB9PJP+Z8Fs0mcjIXEU17MkxAOCUxYFbNTBOsMcwr9PYDUNDjRLE+GWOiI76yxYJO0tzMBt0wChAmm5SRPJYuq9hXTU/ANzrOTsAWyek5XoWUxQn0h0qZx1Nmj5ngY45LUE8Si7hPWqGtEwDJADCZ+e+oK9cvxeUXkH3A36EJVcEf70MxsmJVvJ4yMydTSuX05hozwb8Qkx0A4bR1Keo3Pnondh9bHZDTO1XaCkPCuMpsO9LA/BABXT7AD3woiTdVHG9rFENEG4Itmu4qpBRlkZmpBpI6REVPfdKOr3tK5dQAjMUXWJTfTSNKESyG+n/eFxhB3t7FOWPNFGwP6dJdj91BPdEb3avq6TMNaee4SQHmcZtNa+S22T0SxP3in1fMg6xbbJlnqBkxAe+6I11w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 5:27 AM, Damien Le Moal wrote:
>   > Is it worth the change, as it looks quite subjective if you prefer the
>> one or the other way?
> 
> I think it is a nice cleanup, but I will let Jens and other
> maintainers decide on the worth of this patch.

It's a bit of pointless churn, but I kind of suspected this was coming
when we added the bdev_rot() helper and now had both of them. So I guess
we may as well finish it, as we're half-way there anyway.

-- 
Jens Axboe

