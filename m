Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C149CA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 06:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36F78E0006; Wed,  3 Sep 2025 02:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE02A8E0001; Wed,  3 Sep 2025 02:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81988E0006; Wed,  3 Sep 2025 02:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B33498E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:52:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50988B9E24
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:52:45 +0000 (UTC)
X-FDA: 83847021090.06.B322FAC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id EED6920006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:52:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="g/xmDN2c";
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756882363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XO0RI0g2PcjH/Mi0NTM9HS4GzVWZNGinRmDvcNi+eAg=;
	b=Hk687/iYqZYSyelF3DNOYhSLOXEps9DWHkwhQQLki5TgX+4+TJmqSeVU9L4nEHCKJSTkE7
	R8/o45X9eyaVM7ztcLEnmcCD4oQv/yYSYdyANtChXm30vPbYX9bBP7fVqicl/79SqNdJhp
	N0S9COUTzSFB4816diaej7ckEvbbMYs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="g/xmDN2c";
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756882363; a=rsa-sha256;
	cv=none;
	b=CGlr8TLR7auxxWASnIfXN6J+aOicO3QbPuHi2cQBr+4c8VlPY+fJ8kYy4i7+taOmE+Pft5
	6Uzw7SU6FGtJVOb+lFt9P5CaLogd7XDQOuipg5GFzDy/v2VdJt+oAud7YNEBno3KlxoSbp
	la9yW2mVEkQCTmd0Y+U7WQDiZI2z9/o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756882362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XO0RI0g2PcjH/Mi0NTM9HS4GzVWZNGinRmDvcNi+eAg=;
	b=g/xmDN2cbA6lFUWqM7C+qlb6yTIUlOHj5iTRUQLPJUUcxJN1zg6LpUrWawT/fovv7cBlLk
	1wAL++eZc/4DgALktv08Od4XUvYlChmKXEe4BPAT5XIEM83Mzw+IcTZATKm+6yZs3fdgpo
	cEMxDZgvKp3hFtPwMVOZaPj4lvFzHgQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-QWsD-YWzNbOjR8cfg1DZeA-1; Wed, 03 Sep 2025 02:52:38 -0400
X-MC-Unique: QWsD-YWzNbOjR8cfg1DZeA-1
X-Mimecast-MFC-AGG-ID: QWsD-YWzNbOjR8cfg1DZeA_1756882357
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b9a856d58so11172895e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 23:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756882357; x=1757487157;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XO0RI0g2PcjH/Mi0NTM9HS4GzVWZNGinRmDvcNi+eAg=;
        b=rV5Iw25Ss/sWobACKCOA1/1m/0N5OU9gZEeSIiFGujGpZnjLsNROyDK1GTkG4tnj57
         QJ1cUlFaoQMY8Moq3kjSBnxkFPwh/mM5Nme4SDz7pi1P4FEjkID4KXK0FsJxibUWEtjV
         y4r863Ft2nE34JXiPNc6NWC8y4EoEBD+/K8BAawjvu8IM3XSfeC1FCebDadJejM4XU3P
         fTIf1GqMOuELCfBMzSAhLIXhgrNe4kGM3gIforA+/bN5XLO7g17KBtdgxqT3u+NoLn2D
         ORtQyKe2Xr1lKrEo7u9b1Iy/np3oTw2FvH2jrNn8hMBxxsAB49s45ZPqwIRbUnoXS4KR
         KuVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWF4hJ1jjUbZ5MViWLTM81rPeDvmBVxpRh6iah0Plp4nxz49VKpOhstFKXSD7l15/TTUhPrtHevuA==@kvack.org
X-Gm-Message-State: AOJu0YxpHWvOR6S2m1zQwM+0Vk4cg6IQpQttzuo8myPBkfzPAYhau9dM
	dQmyW/bD/uTFdhsPbuVH27RU5AIbgTcv5ksO7YJ5PtkSOrmGhWX1vrT/w3WeTwaLbWxbNc4601W
	Tgh5tGccRpgsVw4bF7MZVSURuIZIV5C6T5QlvyNYXAfGTvy9D5cIO
X-Gm-Gg: ASbGncuy7JLz0hk0s2k3QGt/p58paQ8/9ZTau8wIUfjpDeYEM3CMjky93G2XB5zNZBZ
	tf1abzrHwDKIK5ZO4VKtjDQiJn9a5wgC1XbCSw+x7SfIbDT9tzeGh+gLYofrVUnRmds0Te7GFZa
	HGWxFmJgKvSdvjtuPZccvkEtV4QaqMPxa22z67/gh769TdaXmvvMsSwd1LXhb+47BNRJRvIZ89k
	YNJsPhbbdWHigRgxhWcK0YPXlKPC4m6fvkQgp+qkauLShT01mIwIpmXnkucbtUUnvzXD8ZKLxV+
	Qq0kr60zhGjhB4jA4H6sxELYX3Dadg9dYW9CGoFZ+r15rZ89ym0ngxDr4OQT19I7OuTfX08=
X-Received: by 2002:a05:600c:a45:b0:458:bf0a:6061 with SMTP id 5b1f17b1804b1-45b85598614mr134948785e9.24.1756882357482;
        Tue, 02 Sep 2025 23:52:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG82XsrKBdBKXFiQ5caYIfv5UU9SJ+wvI5cP32dJdf+EaQZPmn3EUQKNyCx0iR71ou6s1l70Q==
X-Received: by 2002:a05:600c:a45:b0:458:bf0a:6061 with SMTP id 5b1f17b1804b1-45b85598614mr134948575e9.24.1756882357056;
        Tue, 02 Sep 2025 23:52:37 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0fbfb.dip0.t-ipconnect.de. [79.224.251.251])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf275d2722sm22600275f8f.19.2025.09.02.23.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 23:52:36 -0700 (PDT)
Message-ID: <e0f9754b-ef24-4821-8b41-acb8a1d842f3@redhat.com>
Date: Wed, 3 Sep 2025 08:52:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, kas@kernel.org,
 willy@infradead.org, hughd@google.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250903054635.19949-1-dev.jain@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XEoXLL5GHBAslMVgqdG0MCHDv66ofIvVrGcYlAFhwZA_1756882357
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EED6920006
X-Rspam-User: 
X-Stat-Signature: cfxohw5us3wj11kppskj5u9eaxdh8q8r
X-Rspamd-Server: rspam09
X-HE-Tag: 1756882362-140528
X-HE-Meta: U2FsdGVkX1/NUjxdoIfKCJ5j71WJM+wyqj618XMUEYjbJ+q29MPmKwQCU943EfXpuVFcG1po6V2vI4OOurPHbIWhG+I8FNzbepHTg0NFdyiNrO3R1FDHN0UfzfoJDYaeW/p+f5n2R2gn8lDH08iZ20mmWRrL8Lrbke7Nd0FJH/ywpAEMdHpNWINrPHQ41Po+JU1j2mdkraRH0QtDo8lJRCUxr8aoZmgTU03X2t/d0VEIp9a9ZpYCejC8w/WLmfZdlIMCjsqQsBiufU0ZlmZTOxyCuoiVVrjH5EMRJ5FQWNIibhxSI13QHl8DSoxCwm4/HtjAkYzYQKMDwoL0+N2S1HxZHfj15RMJBKGgtpeZxk2Qt3j+5G/Kggs1zuK9ezOAvUDbphLSTNL0GewHImYTKkk1GzvDJKWejjVIoHleBaQeQ/WTCpIb0U/4vpYUa6hBb1My91QeaDYgEmYLmI3eNL6jYqQfuoGFomkhPVLNMOQfuID6VMDs94raDMsLAS38UDwEWpPIwK0CrQa1zsXnVyEpsplnMFL+eeygY29T1TZfVSs2vRPHq07QIcURVwBKbUipT2/O/2LrsCO/QB+MjQh5PDdOr91PLYU2J0MNsFXxiZRty/Xj6cwn8X8ruZDJkCIJlNp8ObHYdVM0yTnhE+bfUo/xRzjmWTZHywfTwcV6Ox66NvxdiGUtURDSDAirrCVoQFaUA+hmRG7lFQF5tavWkzOeMouJl8NxvpnNGPvJJ0RvtQgKaWVPJD63gon7JyxA7tM2Xp5cfIcYxs4TeBjBr06wz+U2JO0yve5nVH64/RN67UyVGxZIpzbL6ceJVHOP6MbOhPVfm1/tBsIoXTAVEPlbJus2I14Vbvm5ybuFSNrxHNVGqARhXDcTE/hjjdsnfmV1BXtoaWXDqypkZ9v5Z8S8eU5RfQIw6LX/1UQN9g1gOV16ZFVl68YzPEM0Yf+e+2AvdZtEumnBgpR
 gt9eNHFf
 7wO5ggJTsE8nBQFSdIqgb/UC5OwaOJoSrMGKiDMlpxKqO3Xts8Vrpi6LTK7hFOQcLYX3lAF6MJLxDO9wm4KvF8+O/O1Acc6X007Kg7Cj0nExdJOLeVpR4DFWU0OYL7KMBOZgeEBwiLjbD9sGOdQM5Jn1dq2HO7oQCi5nPOP+a/FXDtYaTg/y67p6q5lR3G5Bdmw3Lp7jHwaaYsV86IrU438n4exloiASOssaXnaPLQ15apYiGFmCSZAQuvHU0dUiMGS5cHYK27r/sDdfsNuLhdTt/zhTpMIv7j9RypmjSw7ihew7gB+K8L9ns/hTEyMkuH6E489ZzMvz3uiDAIs2qjIdP4+Djgf5qVlDFtNg048pvndlOp1i4oiRbcF0d4pk32vU81T4gE1HjiOQ9uaMfDpjro8bdDOr+8eWxJnfaAXzWzYka1gZObVNJ3CQHewJdh3TrEGJaUv72vf0z5B571jgFjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 07:46, Dev Jain wrote:
> Currently khugepaged does not collapse a region which does not have a
> single writable page. This is wasteful since non-writable VMAs mapped by
> the application won't benefit from THP collapse. Therefore, remove this
> restriction and allow khugepaged to collapse a VMA with arbitrary
> protections.
> 
> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
> non-writable VMA, and this restriction is nowhere to be found on the
> manpage - the restriction itself sounds wrong to me since the user knows
> the protection of the memory it has mapped, so collapsing read-only
> memory via madvise() should be a choice of the user which shouldn't
> be overriden by the kernel.
> 
> On an arm64 machine, an average of 5% improvement is seen on some mmtests
> benchmarks, particularly hackbench, with a maximum improvement of 12%.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


