Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B8B5C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 13:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA666B0088; Mon, 28 Sep 2026 09:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3146B008A; Mon, 28 Sep 2026 09:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DF86B008C; Mon, 28 Sep 2026 09:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D111D6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:08:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5811E1601DC
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:08:57 +0000 (UTC)
X-FDA: 85263201114.10.F38273D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id B7040180006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:08:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EvDN4b84;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790600935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQs++mWTXYLPchSKZ2aJXcq46fdxtEFLIJ23TkCwnS8=;
	b=hv5knULQ/saMvsGZ3w4ZTgiy8zlSuIAylw6MBqsvx8zE+vJCNI3wpP3rMscLHUXxkofs0C
	PS1GoHoRunygtyL9E/+tznagZvO+Ds6Sou2AMfU1w2N2NSxbT1QPif3qllw3OiR48paimj
	Q0pdQNNwjWc3Sf1PWUNlznU4Xf5ecc0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EvDN4b84;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790600935;
	b=7ZYIHuV36qIZn8W4k6JA5xUr3j4UjWGQoLbREzBv4RRTnvMUkZkGuKT7HB3AopeuhhISNa
	eQRHRhWMIVQnA6Zd6+9yWdYQR+LnKpWm7IXtaiEawZlqJdyWUCYgjJzBPUdKR/vXPw6KZ4
	c1drrPfHeObeA5iATZj/bmlW19Z1Ggs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790600934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pQs++mWTXYLPchSKZ2aJXcq46fdxtEFLIJ23TkCwnS8=;
	b=EvDN4b84OkaRLMI3E9q+D5dYO/X6uLbNXb4JSFk/YDrBrNM/B5EYcFPx/GCdQ+ah9s3eDf
	UrcMC0n5fSXkeCuCHT3u3+j9BkALtSAhKHBZHH8ARJxJcDf2tIUatkROqSHI6FB4Bixknp
	1sGTAOCmIx5M80MmqgA+EPnhhL+rSa0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-Sh6BJA6mMeKkAAko73DPHA-1; Mon, 28 Sep 2026 09:08:52 -0400
X-MC-Unique: Sh6BJA6mMeKkAAko73DPHA-1
X-Mimecast-MFC-AGG-ID: Sh6BJA6mMeKkAAko73DPHA_1790600931
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6ab0162426fso1900673a12.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:08:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790600931; x=1791205731;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pQs++mWTXYLPchSKZ2aJXcq46fdxtEFLIJ23TkCwnS8=;
        b=Qg8ePkRBhBhzeUUDadsezOv0/9MrxccTL+gz+YAPDmSrMeIS2rY2ql4Zflbwf8Pf3b
         tbg6dPF3NlSs9klqaEhPFye11kLN5yrkWKLLo36TTvyUgF/Uh02frlI5apGtjbUwZjRi
         JnhMGrppBuaBDt658idoV7trcpvoO7P1QZJnF6Mm11IjJcjPPiF7HPrsVwI0XmmMYmi5
         2VZdCiHZksXPeLOr4w+T449bZfnnVU8axnqDPMWl0w2mtqQ3A4BmgBaocJR/GgBrOdDy
         PHl+WwgwaB4s7wB22WYPYqTLJBZPKYJkOE5j1qejY4FLELkwBvKHtIRVBoAmOwYdKWPu
         h/Vw==
X-Forwarded-Encrypted: i=1; AKwUvBz/IS7P4Pn2ns0LV0icOdfanh1KLtgsSeWF4Y4L8xhVb8FGZ9CiaTAmkVDnlYpQnPVYVRlCIslflg==@kvack.org
X-Gm-Message-State: AFq9FYIIkRr6ORxaijf9YoZnfxJvJFyfRlsrSiZPrS+aBtn+n5fKBIeg
	66/O3NQ3wzUOfWA3O7TiPeK/5dW8tCciBog5XdUTpRZjWOhJxlu82oBYM/srYXg0wDXs5oD6usM
	AKK394rdSp/zO4T9eUxSWtq1si6wQ3aht0IzdbGO4jSizK+VFVO/i
X-Gm-Gg: AYBFou2v1/FbJ959RqU4sV9YzWYXBzivQiUMAAJqrswko4WJO5wAIXO77TqXBEtXUKf
	3pn9epSxJB0kLmsMm9KmBCyxtfFJdTJjAAHeXgIo8PA+tQugPTqsfV/TimZi1UmlZlaTbPiZ0oU
	Cdq6ZEoXnV9w8Pku2B52uWaeuZQLfhaEUmpKi2MW4T55dqJJcVpz5yHeEqmo7IO58u1cqPBcE/K
	5BOMCWacpzAwnzygkAqqWea03J741dQzOGVy2gNPUfTNz39vbNDf7OcPyGqnFKzMrZ9vQSi/IOr
	ob2VYRFiPS6KwCKaJdL+6cELFCaYuV3zcTr24Ht4w5fqvLABTlNWxTjuR6JciJjSGQhcCYgxvPQ
	zgKM=
X-Received: by 2002:a05:6402:2787:b0:6a7:ee56:6160 with SMTP id 4fb4d7f45d1cf-6aac90e2d6amr10105591a12.34.1790600931429;
        Mon, 28 Sep 2026 06:08:51 -0700 (PDT)
X-Received: by 2002:a05:6402:2787:b0:6a7:ee56:6160 with SMTP id 4fb4d7f45d1cf-6aac90e2d6amr10105567a12.34.1790600930936;
        Mon, 28 Sep 2026 06:08:50 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aae5e106c7sm4378214a12.29.2026.09.28.06.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 06:08:50 -0700 (PDT)
Message-ID: <7f58b9fe-8053-4068-89a1-ed217f62c9d1@redhat.com>
Date: Mon, 28 Sep 2026 09:08:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6.18.y] selftests/mm: hugepage-mremap: fix mapping
 alignment
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
 linux-mm@kvack.org
Cc: rppt@kernel.org, sayalip@linux.ibm.com
References: <20260925172129.2962208-1-luizcap@redhat.com>
 <2026-09-26-daily-reply-0004-re-hugepage-mremap-alignment-6-18-bounce@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <2026-09-26-daily-reply-0004-re-hugepage-mremap-alignment-6-18-bounce@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6IiAwGJvLszuhS7zKwXvNoI0YCw3BP6aaUAnR8532HA_1790600931
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B7040180006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: r17cgimotohm6p4chxqowkpbhdsar64f
X-HE-Tag: 1790600934-342741
X-HE-Meta: U2FsdGVkX1+XWvMnvPu0s+Ox0n5GioliaG4jJj3YBUtAdAwXmi5GConSgkVmhFQ3Wj9S3tRtQvCQnsbb6TNFftNs67PeFCI+Yn2cELe8Y4TVMgwuD/GDJfzU0uO8wcU3GZOJ8zQoJVeYWUdKxENBC2Urip/l9OsiSj3i+1gc8Doy6HwL/7YZVKnO8/s12V6TbkuxoHhUVoLhxc6CKWMDnyuJkCf1tUgCTxaHp6vvn2A4dR2JMG099k9O5vmJEsZUXnrnKIwP56t+Y2nuPq3FwJswLp/9xGppkwfvlqq97TY0eLqsygcDCyT0FUodz+hkfctKMmJDK1xj+0SjRo8YwuJG++3a2Mhq6LW+qtti1mnGk8ftYI9fskcUCWhR3eGZyZ/gZs2rEdr+30ETeR+/CY5nwC0YoAOitrg+EqX2vLm9wDRwSEXkGrc9U+/EJkijvhRiG6bpA0ABZUdrYs5RJ6IUUJGwjesdlnl5eHQRdDcjzIUosgUHMcIOeuaUmkrMBYAknyvjy/vLNuBS02I+ouhc9JNkilzZV2Am+Xnh8tYizo2qB7ecGTBAHhaTtNh7p2DiE2USosLy/+nJFlxhKG0JVDePHnGyf2mp39HPDm/N3phNbV3VCI82vmBL/0xF5CH1dqxKsjRj0ykDY3i864+ngnrqtazoo9kiWQ2bGk3EjN6hkt/q/cq1HVASNywcwnxX7rLh/p9cyJRX6qaNSJF+oKdSgujrgpdChO52c0fcrQkZgeg4zR4AeV8oj7nm7Q1DDcM20DDxMk/Dk7SgGioUqKUEVDBzelHnyKpYgatF4cVXbRTXQMcShzYXXeYf6IkiGJb5Vei4IkrXfCDzkb92mKtGDhj/0A2AORe9Uzl7T0e8eDta640SVOmVOL0XOFrB3N/voFnRHtrD2vMnI2o8ezMr+mTQTpi+CCluTcEUlthG4xe4IpcpWdM+f5+xvRLHIAEaFMKrqOWJFBr
 YuuF/+gr
 9Rurtu3Vr39XDRL/Ky5yFDU5qKRCjX7pe8MbenZ75YzkNPnFhtY0Dc1FJ7sIQq9ObGfNCguoUNpQBOPj+w3GRp3Z8e7aqrnGJ+trvRgaiqG/YNWVtSLGlK5qdQv4u4x7DQZG0lfGmgaIpkGIt72hKF9tC/q6w4mEh4qX09/RRic+wBZvQFCBcwugLHtav7CWZHQpz+US/oP1dKzWb1fgDb+OZ6ygnSs5ECRY7ITQJWmgpE4q5jnlY6q+Wr+x3RCXkXjrx0JmO3La/Qgq/2Ct8/KKPlFkGPhbA7fCWTTpIsMTjTH9noIgyAcdsO2L6nUI8C6YOy1e0iSH8gIDo2M0wF9OWuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/26/26 11:26 AM, Sasha Levin wrote:
>> On upstream this was fixed by a914785f6349 ("selftests/mm: hugetlb-mremap:
>> add setup of HugeTLB pages") as that commit aligns 'length' to the
>> default HugeTLB page size as part of what it's doing. Since this commit
>> is part of a 50+ patch series, we backport only the 'length' alignment
>> bits to fix the test.
> 
> The change itself looks good, but the commit message has no upstream
> reference line. The SHA only appears in the prose and the subject differs
> from upstream, so the backport can't be matched to the upstream commit.
> 
> Could you send a v2 with
> 
>    commit a914785f6349da754e1226420bf4e51961956769 upstream.
> 
> as the first line of the body, with your explanation of the partial
> backport below it?

Yes, will do.

I was unsure if I should add it or not because this is not exactly a
backport, so I left it out. But I'm sending v2 with it now.

>>   2. This should apply to v6.12.y as well
> 
> 6.12 has the same failure, so please send the v2 for both 6.18.y and
> 6.12.y.

Will do.


