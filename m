Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED51FF494D
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 06:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2706B0098; Mon, 30 Mar 2026 02:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3F36B0099; Mon, 30 Mar 2026 02:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4746B009B; Mon, 30 Mar 2026 02:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D86F66B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:40:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0C2FE0A4E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:40:44 +0000 (UTC)
X-FDA: 84601781208.10.9332554
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 48B28A0014
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:40:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Vk91nqqZ;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774852842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9tPUG93KFW9eXmcEZ52SvxSIOvXoItR764o3wit1Kc=;
	b=LsJ6emAFBugYMXvNMPxXQAn+QYVOwlA1TPZL/OEAL91nZ4y0UtEeOz5NSw7sjf5mBpinak
	+MHMH4K40c+4Ybop0IVKyYokxW0t3AcWjaLp5U2pyy78XSEkD1YdMNj7TjKCO/fuE+LzXr
	M072ll1120l/6riWjZpHNFfF9PDYjW4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Vk91nqqZ;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774852842; a=rsa-sha256;
	cv=none;
	b=DK2y9Iw3jSvNN2DpvxbwyFdH4CIJkd7pBqqTKmH2mmi+MUyIvnyLIIIJC9+hAoBJDp1nM+
	PvtqdojDU/Avf/YVqT9a1dyHTfPFZ2QyZ6SQohkrP5xKbRuUkkklgXnxYEgsCSEeuXEizF
	hvE+TYRRW4SU+ucFNT/dmnB561MBcSw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774852841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9tPUG93KFW9eXmcEZ52SvxSIOvXoItR764o3wit1Kc=;
	b=Vk91nqqZ1QGAUFO5Q8RVPPsQXwkzY1BpUsU02hPZMxrMwDOjvS2868/Zc2LYMg9qENVTiN
	iymrb/qHQaW8UzTX2j8AxheknljxeYRfOMaBAusHW+BfdO2xzymX+pyxsPudtMtSaycFTv
	k/uQ3fqiVQCx+n4RWkEiJbhWJi5IpLE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-K2IiQzb1Mv-M98pqTzML8A-1; Mon, 30 Mar 2026 02:40:38 -0400
X-MC-Unique: K2IiQzb1Mv-M98pqTzML8A-1
X-Mimecast-MFC-AGG-ID: K2IiQzb1Mv-M98pqTzML8A_1774852837
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a2a01b6cf1so2536611e87.0
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 23:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774852836; x=1775457636;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R9tPUG93KFW9eXmcEZ52SvxSIOvXoItR764o3wit1Kc=;
        b=m/wQsLrfOmlQ4ZuNxcuXDjbCNjOxWstM5FRsg+Cp1mb2q8xaQ0wEyEBuwKsOvRs0c1
         rWSvgrYMaqbsWT8agHlUzFSZxM6Xvzs2uLQwk6Dqyk1Uf/F+TiDtfRpjNVOzMm67nxGm
         OJBiwAoHZaIWDfisXgxQWrLmSrDC6LaPIvN26it82j4fu+7XsN0ZEvxxdG2oQoQKbJXF
         e9PWEeEhmaWUEKr8tunEk1ccgGqvohCth9wrBGsNe4woDFFWipxXiAgQRni2HhgUmI6i
         e96uVO0prxck/iFfoTQj+hbw3boc9J2dtZF6/U+030JdfbA4jboPBy+ZS1nx8wcXLjt7
         LfDQ==
X-Gm-Message-State: AOJu0YxnhOIR55Z5DJW0WFQgXbY9YjzhbmET4HdIei64i4BWDp4cCU4v
	1PvZjrDUULZzs6tp1/ewJ4Pou87z9m+aZQbgLi7U9NqHutnZi3CAJeNOoxhtLLOArpF8+Del3Ni
	83e9biaB0jQUB2HVSpYrKnwr6ZbPwfFfE0a8A9oH/uTOoK9X0BfM=
X-Gm-Gg: ATEYQzw/2C5+xGI6wuqtk9BlgRk9+9Y5KpzWdaERy0a0Dr3blDfwjen+K2A2qZhFY9p
	zirzGpsl+3/cyMFFT/h5oi0SbtYm6KRw/b01bK+dNfTn14ud3gS+qTXmDxWlyopFQUD6K1MBCq3
	OTndh/7Pm0BDbSJuXdU93IX0SxPxbwcb989m1lfSaPAbyzjpwu3iZne8M/DAFuV06FwT9vW5dNP
	Fl3tFtFO2CColRjzhPBk6kdLNyNljkfqtLWVkgJbCvcLyeg84MehgzrYiV+QI+2rZDiFcszNnxG
	xHLLYfB1jhDyB1cMRgQ1AnuMSgCo28mdrmagAn7GHjaJFMuPy1G9hZrkhdonkJKF4vtHFToHRjC
	mXuJYT3cOmjvGMpzLFUEA6YZhj0oufi3Ew6wAf5BW4HJcNGg=
X-Received: by 2002:a05:6512:1307:b0:5a2:792f:b836 with SMTP id 2adb3069b0e04-5a2ab92c85dmr3817450e87.30.1774852836456;
        Sun, 29 Mar 2026 23:40:36 -0700 (PDT)
X-Received: by 2002:a05:6512:1307:b0:5a2:792f:b836 with SMTP id 2adb3069b0e04-5a2ab92c85dmr3817431e87.30.1774852835948;
        Sun, 29 Mar 2026 23:40:35 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2b1443f46sm1508497e87.43.2026.03.29.23.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2026 23:40:35 -0700 (PDT)
Message-ID: <394bec19-7313-46e2-b0b2-640492454d8a@redhat.com>
Date: Mon, 30 Mar 2026 09:40:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/6] mm: add new testcase for the migrate on fault case
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Marco Pagani <marpagan@redhat.com>
References: <20260330043017.251808-1-mpenttil@redhat.com>
 <20260330043017.251808-6-mpenttil@redhat.com>
 <acoWems-CNYT3cwo@infradead.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <acoWems-CNYT3cwo@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VOo3JgOpv-tGW4YwMs1wsUfLqU3l_SqZwjnJ1-vi_xk_1774852837
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 48B28A0014
X-Stat-Signature: pdb8bsgyqhp8jbswnnjnf3oyjr7uhkqq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774852842-137998
X-HE-Meta: U2FsdGVkX1/tSF/HHRnDpRSt56pYB2p5NEZhZvo7QJvXyLwJBwRaLGypiZHbkUXxDo/1slb8VREUOKBPDPjneuxpc9/UfwYKb/Dg1PBiAPE7aYTLIfb9w2rQ4DKKiR3DZZZ0BfWTSOizEhJ9z2LdEue8EoCfHhBVWlbi86ZNMmVXLsv26qZLvL+4JvduD4lDEWVunJe6Wxe/OZJp/jQc0vpDRJAHaNuByUotOAYWKWdcmS31uZJJGQT55USYU8p64cxxfnjgrI+6LPkJL/DszQKv1vdDNuiwwBxnjybWCTSlhrAl7AKcHQWs3V4ft5dl6IOJ0X0z4qplYCdhsSi5kpSB5mNnmEQRWHa2G49oRe/OKYJ2xnn6RSUEFWCcvITKMpCJjF3PonuAwg+a0x+7kx51ntz4NJuiwtDbUV2fhTaNuBUy4Vwd697Smi/Q91aWRYdJuHhHvbWsCVEW01ZTMomtxjKpGMIvjnX4dE66FHF1N045rqbwVKsp9gRnu5IermHC2kvepI3AOIElLuQyY3Xkk06S+qRw0NsOV5Rw1CeiGQw8gl8biwhZyaINh3cM2dI4onD2kIvbxBX/4qyXQxZla2femKB84jTbPz5rWmvaPSUWrzie9dv0bMuQynfhw+tb0ypgvIDFY8rbW5Rd+ZrFGFGUa1bEJSDfFt8CSe+3LUx2I1JSvgoVhQkjTf6ZPGncgnSg+JB9k5L07CAiex9SEU48T6n2IMdQ453J3fP0fydQRPEcUFZMtUtY/3NdEINUd6edkncefOGbM183o6y95iiSo44s4MhRo0PBBaKCtHpTuEc9av67NKZ81Tw2VakiXlj5WXRqFe7casOgW5sARaM7t7YKCMBWJdgofCmwUauXxso9/OLxcI2qbKnonDCLGdym8eWUCe8dDjfnK1vbAM9lA1Xf6GK9MlBY6GniwYQbnNKZOJVuhGLxZZ28UHuXtpy/NMe7tdnlS3k
 1/c/eDKQ
 peHTCr9WRrpyOblBlw8ZMcqQnJo0YenGOw0HcCDWlozQz/sBkGmGSK/UJKKo1CMpnu3foo3Jt4C1uhWx//L+pKuYTfyaanvoy3iSNmWdjVqNy4cnkQw+ZYR9JFS00bkixlrSO/BR49eBbYye6nb8cqbZSKMaFFGCPrGKAyIYTknG7KNyC7az8/xoFSWklDoJH8NgtqwOnwhq/lIVrx2h4AG0q33Iq1eemsq6Dqwzu4ZCFk3fXYiLhgBcPzO9J7PLQssmmwe1CJFbwsqH8w+8KFD/5/Dkr6PdkASoJF9rB3t7NhsqstFvFfsHM8LKEGSA8FtUNhMJo//fsGRsTrMOUkxAea1dVazqoHSxMg7+CgAeDNfNbs3S53dcR+s2OewzoxY3OEHblrTBUJjeou9EgFmBEn7u8QKz3yznz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 3/30/26 09:21, Christoph Hellwig wrote:

> On Mon, Mar 30, 2026 at 07:30:16AM +0300, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
> This seems to lack a commit message.
>
> Also where is the real user of your changes?  It seems like only this
> test case consumes it currently and you actually add dead code?
>
The changes add the possibility to do migration initiated by hmm_range_fault()
while handling faults. There are some advantages to it, like more efficient
flow, and you get the VMA populated (needed for migration). 
Also, the current migrate_vma_setup() initiated flow is changed to use the new code,
so it's not dead code.

Thanks,
Mika


