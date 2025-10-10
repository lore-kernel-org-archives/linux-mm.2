Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDA2CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 09:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77AA28E001B; Fri, 10 Oct 2025 05:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752528E0018; Fri, 10 Oct 2025 05:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6682D8E001B; Fri, 10 Oct 2025 05:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 535DE8E0018
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 05:02:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4BDB1399CC
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:02:48 +0000 (UTC)
X-FDA: 83981614416.04.9CA3C84
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 64408180018
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:02:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FKHVvXpP;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760086965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HW5td0SWXdCvZ05NdV55x6S0j9wHlZDx+Tv+YWgnDiE=;
	b=FXGd/ZvOUQeG8WiI773K9recbjUcjKJGwb1nLtG1nmMK3Pcy7sOw0AV0hoLP1XQKipf3Iu
	cOHLhZq8uAwX7brcusQf8mOokzNXi541XRZm0dTtnal4mPEEf0yP/V79onVwqKJAR17Zjy
	x9y4ZNc/lvRpbdWpR5gAm6mf1owE4v0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FKHVvXpP;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760086965; a=rsa-sha256;
	cv=none;
	b=M29SILigsw56iP+VKoRgTeItXr0eB2eNWEvNif5twyJt5xzt73kJE+dfYtlhiru+AW2/WQ
	CUcwOnKj7GaeZJyKFyogJi3RzCMYqoBtjbBe3840qlvCntvJuHwFukPAit2LVPND+eKGXb
	UHH7QbhN/Tjp8lwBboHlRFFTVkoVck8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760086964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HW5td0SWXdCvZ05NdV55x6S0j9wHlZDx+Tv+YWgnDiE=;
	b=FKHVvXpPkUklVX0DZ5zs/NW5uYSsehElA3c9OSnOWg+5P9ArrfEF2A0lchuBKs3XWJbCpP
	xLs5vlFhRASMU6MhjHOGHADdV4q83IfNgNIsm40rxS1lDI2a3aEa/1CC9lMOAZlhDz7dKA
	ft0A55IV2jNxFrPMUXfgEP+Sdw5q1YA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-lCv27Z5lMWOsbgxYT0TGhw-1; Fri, 10 Oct 2025 05:02:43 -0400
X-MC-Unique: lCv27Z5lMWOsbgxYT0TGhw-1
X-Mimecast-MFC-AGG-ID: lCv27Z5lMWOsbgxYT0TGhw_1760086962
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46fa88b5760so6016685e9.3
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760086962; x=1760691762;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HW5td0SWXdCvZ05NdV55x6S0j9wHlZDx+Tv+YWgnDiE=;
        b=Yw5c1FDF+eIHiMLcVTivtesjzGK5w1yQODwNNfC+SeTCPsp+S6f+luNKXfiKOObg4O
         B9fsBmhPrgYlsX79IefiiyiNTYqsVUN4hhBdQ7tobJmA6vSq1pcewrIsXO3sM3UVi24p
         iU7i+t/rWt542AVC2nfQqxDwWWLsOUkKZEgOg3t4dRqFelhClJBorY/UXmbkyr+C7pxY
         B/7KwqRI2x3mpDhZms3Ql2uQFPTo5VhJkpEzZTsGLT5Y/B/pwfEfGTP6whMv1Df+ZWV0
         Q8boy3EmnznhV9jX0O44C3cjnY+PPSF6Y1QSKX9+XucjNiHKnhXNMf+lsBON8yqWMve4
         botg==
X-Forwarded-Encrypted: i=1; AJvYcCV7sezwYFUoP/fgA0SWREfvJpxse9e5F846/5pcyqh+iEXG+8UjKg7PKyyRzIi9/63zpiVfeoQm5A==@kvack.org
X-Gm-Message-State: AOJu0Yw35dAycrzVxy06MEQsTeXSLM4TG0eQYFCo1e8GNpwr9QmVO/se
	r9+zy2IWgOczh7m2H698Ppn4hk55k6pzjkEsCt12AYK8gTKvbZ7r+dNlrddZ5B7QoJx+gJj2tah
	dhogzQ9S3l4nYbPAMpTxACLgBd5NRouiHrGVHFwz6Xio9jTlpn7z1
X-Gm-Gg: ASbGncv09MbPHtANc5wIsmkYuo7ay+eWdG2aaUioayS+vCQvRQaNy7wVBbdLqBE+OZ4
	fAFRjVRCj5N98e4syzmPsZs0YnjrPeQkvn5ghU2vJmcR2ZvJTXho0wW4YG/vgZccbM8WtuhdDP6
	BogcD/BBnEPG7DMpIRzvmjjjW4vfYrlCSIQTcPfvl7jJAEZdN2pjgDDippFsz+rXCulf57sec0L
	7SADEGmD+Gj77YoCtwHbx3CFVjgM9SaJSuoPE95Mp0hPMdDhQb59PnaOnieL6qlcH//FKLiy+rk
	Ax5X4yfLbm8z0G5JiFmALv47yury7i+TIJ8tcz9t+ozh3404jsJK4QLHd7tAGSbyf6GsYFE8+y5
	3vHQ=
X-Received: by 2002:a05:600c:621b:b0:45d:d609:1199 with SMTP id 5b1f17b1804b1-46fa9b08c13mr80512835e9.30.1760086961949;
        Fri, 10 Oct 2025 02:02:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcNFVwacUWgdTF5cZzdAVjtZQjHGkGYmsKNypeybnL+F7IrjK7WBQw0hVHz78I8+aMAo3glA==
X-Received: by 2002:a05:600c:621b:b0:45d:d609:1199 with SMTP id 5b1f17b1804b1-46fa9b08c13mr80512595e9.30.1760086961539;
        Fri, 10 Oct 2025 02:02:41 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb48a6069sm36473545e9.20.2025.10.10.02.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 02:02:38 -0700 (PDT)
Message-ID: <1be7d08f-7de4-4f7d-8897-ef90d2188d5a@redhat.com>
Date: Fri, 10 Oct 2025 11:02:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] Support dynamic (de)configuration of memory
To: Heiko Carstens <hca@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-s390
 <linux-s390@vger.kernel.org>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
 <20251010082422.9132Ab1-hca@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251010082422.9132Ab1-hca@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IG5ow0g1S03E9nvtNhV3_Kn1YeQF7FAlgu3jj4LaZ-0_1760086962
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8tyan3bcij3456yxbmca66jps51ipobp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64408180018
X-HE-Tag: 1760086965-130403
X-HE-Meta: U2FsdGVkX1/s8mWghVCkau6CkgHGNSwO2hpY1KlJlQAi9QIfdymMgjuR110NvL0nTnQVNtkkAJg3rfFZ1vH0dInSksl5O6XwLxDO+D9RqD9wtT6R/MJakSBxtlI4Yn0ckn+ksQvVGB4zK1vUNyK3H7Auv9gZLlpnxxMj7PLXs9KLVuNlxiklvBU1K5cfokXPFMWW9M8GB4vvilInzppWQkSaWercR/XXlYi7dQWoYcwbm5YEcduI9EFo10E33gmWtfxADicq1KTWn/lZcX1u4XruUae9dq3MJ3tTgnYJGTXw48X7jLolhErLrVBRXwnSAGW0JkRE+IY4cla/nR+CSIRcBo4Xl0atPxqkf9DOJyNz6iiHo7aSFX3gfH/gq0OapIWk2j/assffEegev6XKzk6YqoCupu1br4Zg9I7vCToneYxviB/iFS3s9H0Ox/Aq1JlBQDTFqEKp7QYuA/yS1aj5V8XCKFh8lGN58I18XJIx1OeJghScRw+FLNT1mtkSvae4U0Lduz8JOjoVlD2ExwrzNo4GRDQzwe4uAeKNHc0hi7QOkqT9zkZzvsHfq5ihsNiDiVhOIfUuR+42VN3TfQ1RbeA022ZF6+yhzqX1CazgHxpUZEvFjQdlp5VrOtY6xoNQpNgv0r43K+O5JcrZbWXOwhta8OmO8jA+D/aXRaQ//TWf1Q3JZLW6P8lqg1inG0vEylajsF5hffGoSuS3VIvqyPQD7fj5FOcCbfJ6MCVjljauBQtabKTeIAgtdwFmeaMxz4e9iwsoCb0jM0tT+bEzFVnhJOk0hmJz5jx1/7rddy6QAIzmIecDj5/kcmKuIfmUQ2DyE5ElHft7Kgx18FCD/IjJiLKrHHTyY9aKK0B75igNckhEbAlGCn8XZBnPhdBm7+tx8JDwsLC8af3Moibfl8wj2VwWEDlCNVKdnLbE9vgk5exlGzdFq+niWOM5tdC1lmu5njcxjYR0aSE
 n9yrep+K
 F2G+/XgVscc0/Z4l72+i75xZUM3Qm9XoilQjdmgXWx8Q+xlJ08fys9NnuDsvU1D4w8nPBR2ghDRPlPNS2tLr20LBF4GoXZYnFjlVHhDPgeF1LOzkMDGbueNXv2hdbQl/5d+4nbiLWMolBxmqPObHH8eSNv05mOMv4HdxqRXX+6HJxeZqYu91W6KNbJXQXNJLsbJ9GAmPBTX3rNFyinxShz3H+OL5dJwZDDPlO+iGLxN5r/Op2afDrlatknGQ4ZNpMdP+Bh42iur1fpmY747dCvWAdg7eKyvBeXCLz7OEmDX7MBpPZGjBnl/IFrQP8kGrbvEaRwSgjsxf9UWBHYDe8gQV5NEx86gOsARHl2Tsih1qqkNyRjx7e4rVZ0Ax4mj/gC4gKQpyZEyR9hiTQiHR7lfy/n7116jP/USjIgThwbfNtHiRss3yPgnwLcNa8MnJS1i+WBanZoz/1PPu86fcJcZ3ikKguV6Iocz1TnKAV3nKLrt+JUXMtSBTZvkmxdyU9z+9r52WUr9J9DanSLFSa4iwRiflDLfVNP/A6PCNg3oTC122xqW7PVXzz6W3A5c/FsW33eWSgkWQbn1fxy8QwggW+bTin20ka2xUg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.10.25 10:24, Heiko Carstens wrote:
> On Thu, Oct 09, 2025 at 03:18:35PM +0200, Sumanth Korikkar wrote:
>> Hi,
>>
>> Patchset provides a new interface for dynamic configuration and
>> deconfiguration of hotplug memory on s390, allowing with/without
>> memmap_on_memory support. It is a follow up on the discussion with David
>> when introducing memmap_on_memory support for s390 and support dynamic
>> (de)configuration of memory:
>> https://lore.kernel.org/all/ee492da8-74b4-4a97-8b24-73e07257f01d@redhat.com/
>> https://lore.kernel.org/all/20241202082732.3959803-1-sumanthk@linux.ibm.com/
> 
> Andrew, David, we would like to carry this series via the s390 tree,
> including the fourth patch, which is common code only.
> 
> Is this ok for both of you?

Fine with me, I don't expect a lot of memory hotplug changes that could 
interact.

As an alternative, we could route #4 separately later through mm.

But this one feels like it can just all go through the mm tree if Andrew 
is fine with it.

-- 
Cheers

David / dhildenb


