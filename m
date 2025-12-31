Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D6A6EEB565
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 17:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899ED6B0088; Wed, 31 Dec 2025 12:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8476C6B0089; Wed, 31 Dec 2025 12:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7297C6B008A; Wed, 31 Dec 2025 12:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE3F6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:36:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 074A6CCA76
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:36:13 +0000 (UTC)
X-FDA: 84280469826.15.16C008A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7FD32180003
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:36:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=euqIVIQp;
	spf=pass (imf16.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767202570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+hPaZspsreAv3BlbsaDeG27kbGxsQkCDH5b5xlUDn0=;
	b=2SkKJUst1Jb/MiPyQm7/ZfH6+sjiJMHivGoxeZWc21B86hieGrP1hAZLHc7av//laJhsjB
	sWfaJeUD9ISGQ8t2IQRkp3Wc+kpCCKbD9r+Fqk8OmiiFkOQcX9zedPmY+05gq56n48PXl9
	bhgWXuvywGyOz5E+aa8PBxqabYOwWfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767202570; a=rsa-sha256;
	cv=none;
	b=uXGMvbn/Vr6nkdbRjHec4YXl11Q1J4bLcojgJn/Dxn9/wbLG1c2QdSPSV8uRKtH9qceaGh
	7N7X2ZHK3qtHWJDO9A4I3dNrZpZjWbO1qUsUidyq+xK0vnyGDn9glBNBjuZ7+titHRRKOk
	qDP3sAHvDfJ4fkgL0QOCkPN2plZcRio=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=euqIVIQp;
	spf=pass (imf16.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767202569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D+hPaZspsreAv3BlbsaDeG27kbGxsQkCDH5b5xlUDn0=;
	b=euqIVIQp/TpFb1I7aDBhO+DQG6ASExg19D24BcogyOJmsjwbRM4UzT7gqvTeHi0XzuSBeA
	idIOM9dM/JIUdPDVwUqYRdB9SgW2ThbIraTAC5MQmGNQlkjkgPnZp9Lt/ipkxlPe/FHzJu
	zb28dQUz8gbozGxtBj0JE3pAMX+ZKbE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-28J50FeoMSWiblsP0GMk-Q-1; Wed, 31 Dec 2025 12:36:08 -0500
X-MC-Unique: 28J50FeoMSWiblsP0GMk-Q-1
X-Mimecast-MFC-AGG-ID: 28J50FeoMSWiblsP0GMk-Q_1767202568
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b630753cc38so18327666a12.1
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:36:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767202564; x=1767807364;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D+hPaZspsreAv3BlbsaDeG27kbGxsQkCDH5b5xlUDn0=;
        b=V6pI45qEyPNn3b0oFt5hYbsIMiyOik5hR8lF5u0i5Zj1HqjyO+JTAgE4n04STrHcoy
         BaPsn5oOeOobT4HKHqBJ1QaAZ/UabAAiQILiGcoazvA1U6mkShuv1JYzpauiT3NmBPrv
         m8Fpbjw3qTT2e6MABv8ZvpfGUtHt24jHBN1Lo+NzobgdV5aiVdLYdPj9zeRUy4Fe7i4p
         vcyYo1baRUMx4W1op6JjuFzntm3dU2eIVOnAskQaO4fUTvyeW6wBck4qjfaIkNjFTPgt
         p5FowN5o+7HjCithkcdi+Wh9fZKzHnZbTEtu2yy+lv+wRQdk9+Xn12uSD8zC7xckJt8A
         8Hyg==
X-Forwarded-Encrypted: i=1; AJvYcCUzzxlGnkG6qvbi4Zdg8zl2np1Tx6Gpjv+hKDu++rVVEIeqe5SJmXxrDefKhdZqQOFCjAsj0zZpDg==@kvack.org
X-Gm-Message-State: AOJu0Yw4HLjmv65mC9b67ISTrFXMoyqdmdvBeBd055cIZbck05RY4yXc
	jykGptC7KyNHkiYvaVYW9KrYaxh5RQb12/Qubq2il1svAKf5Y+EVyB62HHNyVty/2HPE5rr+nmE
	Z8ishXF8VGxR42UPmu7NCiLX4NJNZoB9TEiArT9mBQVWENsp4rEtM
X-Gm-Gg: AY/fxX5HMxfRqHa1GHr+EBzt+QngaMCO+yVQvd/2nak7KR+2n8mWmq5rdrdcoAqGXU5
	0nz65O6CeQDOkojX+IJAmJPVzpB63WyeqS6STfEghle6qTQ3VHeNA9jUssrl/rzU2pcSjaOGJir
	WAilBKFZApmHruyn0fXvf7zvK279Sy0tjYvaKWuOXT/4xAUyfuHijfBIQTswD4T7+i14F3Al7eJ
	zooxhveExSg1wpmi6M7U736jLFI1nUKlbTutW54zGiFV63q76GbJGrAEHGk/y6KZ7wQqHe5ARY5
	J3QO3RkV17W9Tek/J4/dHUrxiC6kDYokj7bLkcRpcqxyyPWmN1sPX1+6h75vOziuTxF6J+TZIpU
	ZjtiwZ/l55lGLwraAF58DVLh82n6QhGBcbx7LU0VnX23/1xnO
X-Received: by 2002:a05:7022:6722:b0:11d:f464:38b3 with SMTP id a92af1059eb24-121722a9757mr33784152c88.2.1767202564081;
        Wed, 31 Dec 2025 09:36:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEi3paBF328Dvc54FaF7ePmfKoOt8e8CqfUvXWomZaBGFhC0nmzfA+IqOZP166rR45yxweuTA==
X-Received: by 2002:a05:7022:6722:b0:11d:f464:38b3 with SMTP id a92af1059eb24-121722a9757mr33784129c88.2.1767202563623;
        Wed, 31 Dec 2025 09:36:03 -0800 (PST)
Received: from [10.61.55.87] (syn-184-074-098-043.biz.spectrum.com. [184.74.98.43])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05ff8634csm87792829eec.3.2025.12.31.09.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Dec 2025 09:36:03 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <f4228e20-62ff-4701-b6ce-59c99188d7b5@redhat.com>
Date: Wed, 31 Dec 2025 12:35:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 33/33] doc: Add housekeeping documentation
To: Frederic Weisbecker <frederic@kernel.org>, Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chen Ridong <chenridong@huawei.com>, Danilo Krummrich <dakr@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 Marco Crivellari <marco.crivellari@suse.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 netdev@vger.kernel.org
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-34-frederic@kernel.org>
 <370149fc-1624-4a16-ac47-dd9b2dd0ed29@redhat.com>
 <aVVAfb2eaeyd7l-h@localhost.localdomain>
In-Reply-To: <aVVAfb2eaeyd7l-h@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xUnmDEF03U36IclDZAbHUh3wk2YyLKoIk6sCfArv3I8_1767202568
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: px1w3n64hryujo9f6grfs9er1j6cmiaa
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7FD32180003
X-Rspam-User: 
X-HE-Tag: 1767202570-666007
X-HE-Meta: U2FsdGVkX1/KanoqZf4BvxQWB+PF8BitxhZ0IwZwJJFehcuovZyyy7xWq1ea9rdQhk8ja3pNJvT/21ZwasFs9Busa14SwMEvfM+I+YJw/HTdNHY3/4UxPy6Sz1FpN5p4UgSF3tjWuaO29rzVNwmEewxhwHAX74roSkXH4j61cZzl+50YpD9nmW5jxxvJOUFaxjp8aJQ/9toAfpo2ogZgC0dcyBC9CPedUBfFbuwqsadD15Jni3SxClfo/DsYR01970LtDufjTvIJpWhpmaKVSAKDZuuCEEw5nGLhXwQs6pb2BW+G4rOqxkIFB98ZuN/HXRYHA6YQVhbbigXkv/rSgQlwuw3fT/7a446iHIlrypv+3PadMNeA+Tu8psTgmSFYe8WJA6gwQNQQYlEM7ynhVdMr5G4XVycDSEgokP3T/oZtWkIhXjf5kbzKpxkk1a9Axml6CmsVhR3NSLN3gqYPhzAt3A8qKMfUi1Fwh4zQvc0sZNSHLO18vtOghJ0Pno00xNRGTDrvcPImK2xH91DSo9yNYOMvnNbE7mDALGXpMAIWfdMd9oybELu9LPohR7dh6wuK6OmOnWixa/r0/Wsii9ZvKG70fTlbKNbJIzTathJkPTt8o3NSz9SBL4g1GwuIBAdTeTg5QvwKrzcIkHJHek9vByNltlvBEBkaE7d4GNaEIig3IF6N/IAB2pHhHekrgIYSVzt9ISNWwM2OQ9NyyVUapcWKK//FAh1bwVPwSKI9Dl0e1cLiLICBXDkIheMiqUWo1RaIbg+xgmMvY1Dd1+kkKBKxNW5jW2i2NEPlA9pAvTW50C0vL0qhNF/v94dOlmXZFNZ6eYg7v3/k9gPMOLX+B9PeDIavqx/cplAV2k3W2vK9G6bJA5Lqc9qw1nJByoxD+1vDMTpxR9Ja/ccXjt9hf8AMF9PCRQqPICRliqHb4oc6zc8M1alRnl9q16/cs5NLr5wTfHpLCcWM7bX
 zI+32PCP
 pkNvveEy4mzCcpy/gZhCpL3j1By8tdh5p8VaOBliajeV4Rm+rxcIRBNWMDNQITuywueScCqcv/zcE2ypo172LPCKnBpDHC7O01s+5ZQhlQ+h08K+kYT/VpuwWuhjSZbe56lmSburTbt6c5dMjbUPrWtuPQAudXV/1faHW3U58GdmoDfeBgguaKu5Z0u1yZsy0RAKk9ISwnXbrSwMQFNdTniV3DHFaY+epeb3HNEoOGCmoTdoYM48awCF3TgJs0LThiurykLcZIujhuAL0e/CzTTOLSxGNNmX5wnymOBS/YDOXguFxzf7ihIGsthBaKyrBY2UrTLjkY6vNik7IcsZWZax/LSckhopUgVp0UAtKNZ0G5U4yfFWqUeOr3/5Ai3/EXU4sRAQVe54w4qvUQak406nMPvewikHpX8qVYhv+wa2kkCLTA+IrfvRCJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/31/25 10:25 AM, Frederic Weisbecker wrote:
> Le Fri, Dec 26, 2025 at 07:39:28PM -0500, Waiman Long a écrit :
>> On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
>>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>>> ---
>>>    Documentation/core-api/housekeeping.rst | 111 ++++++++++++++++++++++++
>>>    Documentation/core-api/index.rst        |   1 +
>>>    2 files changed, 112 insertions(+)
>>>    create mode 100644 Documentation/core-api/housekeeping.rst
>>>
>>> diff --git a/Documentation/core-api/housekeeping.rst b/Documentation/core-api/housekeeping.rst
>>> new file mode 100644
>>> index 000000000000..e5417302774c
>>> --- /dev/null
>>> +++ b/Documentation/core-api/housekeeping.rst
>>> @@ -0,0 +1,111 @@
>>> +======================================
>>> +Housekeeping
>>> +======================================
>>> +
>>> +
>>> +CPU Isolation moves away kernel work that may otherwise run on any CPU.
>>> +The purpose of its related features is to reduce the OS jitter that some
>>> +extreme workloads can't stand, such as in some DPDK usecases.
>> Nit: "usecases" => "use cases"
> Are you sure? I'm not a native speaker but at least the kernel
> has established its use:
>
> $ git grep usecase | wc -l
> 517
"usecase" is not a proper word by itself, but people do use it some times.
$ git grep "use case" | wc -l
694

Anyway, you can keep it if you want. It is not something that is worth 
arguing for. :-)

Cheers,
Longman


