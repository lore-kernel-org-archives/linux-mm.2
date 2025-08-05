Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69ACFC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8508E0005; Tue,  5 Aug 2025 08:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E638E0001; Tue,  5 Aug 2025 08:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47B18E0005; Tue,  5 Aug 2025 08:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C48608E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:29:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 671BE810A0
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:29:27 +0000 (UTC)
X-FDA: 83742634374.10.01BA3B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id A0F1C40009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:29:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eO2Uw2tV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754396964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PUsESmGMc+I+/9P1CUuXeKO/V0uem/5Yunali6bEt8=;
	b=TojXD2loXjLevJbKFbHmRFmCbkn14ReQ2gyXCOieixOxfQmS6Y7Tpi4Pnz/lEdpkcSZz2x
	/nAOtn/zrrbF/uM9ms8ka4DYQJnrqe05AwjSbSn6XujIKzULaDA+uRXVkXlf+j7O4K9OF+
	MZLRYzmpbPhXeL5s2u+QZLKE2DvMU9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754396965; a=rsa-sha256;
	cv=none;
	b=GyewvHHs30KeiReLpiyQsWAytCXGN+hepc7YB5Ox/zB4CqXmkoDJO4vKiXG5NFh+tJoHx3
	QLWW9mK7QLVPlbJIlviawp4wbRQ/rDu5eMYdteOz4usqu31bOKmsGNGbtaPdDZ9NNTdPlL
	qaq8Wgog4avWqZ6qaos6V0ewCcvHHD0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eO2Uw2tV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754396964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0PUsESmGMc+I+/9P1CUuXeKO/V0uem/5Yunali6bEt8=;
	b=eO2Uw2tVi63VMmjD0bm6qH85WcGs+8yGVIgjZ0GfrJnE6HI62j8VKz0tkn25qNjnd1eUsJ
	KrA34SE+9A00Jtyre9D6/+PQkdvRRbK0PvzjLnXGNsVa1lBk/pS+bbEjPF/nX4uPkRzx4e
	/KeY5skRrqoFQs7QUeF1d1jk5NRhOzI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-_Q4WjxsXOriEN6o35Bi7lA-1; Tue, 05 Aug 2025 08:29:22 -0400
X-MC-Unique: _Q4WjxsXOriEN6o35Bi7lA-1
X-Mimecast-MFC-AGG-ID: _Q4WjxsXOriEN6o35Bi7lA_1754396960
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459dde02e38so8715675e9.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:29:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754396960; x=1755001760;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0PUsESmGMc+I+/9P1CUuXeKO/V0uem/5Yunali6bEt8=;
        b=TC9/SHOE/RJHsKvcLZXMSzllJ/mBNwRQLfrtlx+UYeXvN5sEGKvbfPbh1v3Cy+X0xn
         Lyf34fVnYP2//bAU6SS1gGtIHLuM/gGBfk2Kf8M1xOkUgkoFfbsd0nJDt0CXkV5zTHhh
         koJJRf28bvhBzxX+nns8i4FIWQoHMDFuBVzvQY/ZS6ax5jx7ugCliWlBXKaZ4idKOjQ0
         7/JnbLj7zUMXK2RamJX5XA8sQEpg7lINiLBNX4Bk4QGk296KSUDXH9Y6qZOqAwzCRfW5
         5a4qx0li0Ugkut4w6IZXJJldCOEdBfFiDHVLk2+9Z8MVs59QgCkMJ8ugucHNHzJGfeYI
         RJgA==
X-Forwarded-Encrypted: i=1; AJvYcCWgrf80A+/kdCKwS1Jw0vLn3r6O8n2qr5WXlT8vVH1S6H7eaGtd7OmkhuEweXCXxlf4edwOfySBdg==@kvack.org
X-Gm-Message-State: AOJu0Yz1LMrJSZr6VS9YVoncBrdEvyPUiXnpND1q4vCDzv1l6XCGaLla
	PkwXFdcXm849EBQygGIV3smUyJf2obDKLG2MsCJ7M6F6Gwiqxa4hMZ5famH8UtrcBDqAwxlvhD0
	lu9HSNhf6jtLa1V4+sKP9m8Hqyr3cBJ7+XiQ8GOYU+sqFeDwUcvnB
X-Gm-Gg: ASbGncs2vdnrcQMqlcXZ//CXgrLp64Q3JHvVOms0ICH+ZUphPMDrXz02fPkYrPVP7oT
	HyZprFToWo4hnbfVEocnG4KGIGzFiCzpIxmcnN2LO5BswGL8d5ztiSth3bwjT2/SUu9U6ObAXHg
	c+SJdsyafcXj9ckqyU1zqdcPivC4xW/1c8ewEl9Oi6gZu5AS8ESWBIp2kpPT9GxoReBXYGqjXCx
	T3lNLvhHK2gxg5b5xRjRiZlSLVdXsc9zeyYs3U4gIffP49WMOR2uw9bs6u18PuWbsYIL+uEzy5G
	RS7o3hwoo/jNOE1YC0MERIfMGEAFKCCILWyq4ohk4CqWNCXFwleXhsQU++u6d4gs0rUdrb1SAm3
	EdBIncl88WJTpw96fXXzaH2kKmObYg/qhHpnrOeuT46Z5Uaz3tF6stSv4j1v15Jk9Gak=
X-Received: by 2002:a05:600c:8b37:b0:43c:ea1a:720a with SMTP id 5b1f17b1804b1-458b69c80bamr106556645e9.1.1754396960252;
        Tue, 05 Aug 2025 05:29:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCYX+oIAWm7P6J9L9FL13e5nv15VWteMneKcFbKtrf1zfS9R9mzwxH7mkHE3dPyFpu0k1T0Q==
X-Received: by 2002:a05:600c:8b37:b0:43c:ea1a:720a with SMTP id 5b1f17b1804b1-458b69c80bamr106556235e9.1.1754396959808;
        Tue, 05 Aug 2025 05:29:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459db13fc9fsm75518385e9.7.2025.08.05.05.29.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:29:19 -0700 (PDT)
Message-ID: <ff285199-5f29-44b8-81df-891196eeca3d@redhat.com>
Date: Tue, 5 Aug 2025 14:29:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-7-usamaarif642@gmail.com>
 <9bcb1dee-314e-4366-9bad-88a47d516c79@redhat.com>
 <5dc09930-e137-47ba-a98f-416d3319c8be@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <5dc09930-e137-47ba-a98f-416d3319c8be@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wt25x9led7e80ciYtktFveUysseEl4C-66YJEpLUdpI_1754396960
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rz4b1rei7qyz3d5tmxska1s36isg4trt
X-Rspamd-Queue-Id: A0F1C40009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754396964-314965
X-HE-Meta: U2FsdGVkX1+JK9EZB0UWVw/v6/M1GIxa/Ux90PFr/EhgrevtMJTYVjZ/5M0BoBbEjZp1/KTrVzzkBprKQ0r9EgudhtqpHBKWfIgFH/4QjCun7hB/R5tKW1hTsIBgYESpUDYWAkGvhvtgnk9fORGb3OBRZ7zATLG05Tt9SuK4hKpAdYDVe5l7Tr9SoitH8kZy35Eib5v8y/S94ALMU1RkepypnkTyK7mDC2DW4xBbtQT5bWFMs2MxC9s21JaptT6s5lRVwlMR/ZOgud08+8TcmZSu3NHY5+5UoKvGDZf2BwIFdB6vi0viHFbhcs7dGEu/kjLcWlPmwIod38kQzqUCmH1rZ6rLlLWvm7u+pOQesOstMf9kPXO7Ws84Zb1uc628jkKLrqHi3/bT5eVG0wrzDKlzkL81oWc96JHYsMEYXxy2PjvnWGqXf4n3brlWpTaQwVrWiIB3uCszXznn7yxHAUe983pwq0uoi7VCpAhQLX8fYQFqR46555w8XzhKMwwsCo7mCk7VG3BAWWrCetS5SPXlFuGKxW0wiWc4/GjXuMd+zjSqu6O64MClzRUysZu7Mks4zdRgxXJGPH0NKphRGGMyKHnYJ+DHi62CXdiRNUIpGHoKI2Z4X2LRn2+hBhw3ysBGyG4l6UqNJmBw7HULkvdiSU0lTtaY8w7JUFgh1QxZ19dq6r3QtxwY5zabRGLcLgM2rlA69ypRqAX4h3oXv0O020qV4ruf9XmnB7kRk4bYGdzh0sePJBQsW7In5qOQpRBh4xaJuoWBSJScbFY6WP21JEbrgtGT6Q+bwIn0fW9/jWAlvRjFViEZr96+CiKIWYqABwNHHuLh9bb4Fc/qgZcPW8h7Sau44laUnpItY5DFbdiUiMZzjheHpORpRyqYq7WiGyASwjrVYxC84DeBaD7YT4ctTXCUsIbFrkrCb4MryD8BMEKbKHfiFScOmWbWINLWxJHrERUQzWRYu1i
 Rbm/+0k3
 w5jcElieEbGvnvfSqMRbbdZUsVjYKgftowz1Zby/Bpvul+gFfTr8zlMF+7Z2mlXslp3UmRiHkjb4USnR4vbPRy8NrS78F9LzZBFrWL32CGibc1BTXsTpoOBw/v8Ci5RHbJrMpvxtyVSjkgKldUi8Xb/9I5n5s8FUswq7UepUq1AHLHE8OPE6m7OOChQ1TqoYQnSJT6UcFVA9bz6y1Nwj7RUuAT/WPNZYGYYIsBycIQp1X+eQl7JD37dePvUFtwcrCT+USB9yydcPddThO6gSlEPbMVVzzEn1TW0SJ4EVI2eqqaz/Aa92kvjvOGNoVet59CX5wrKd1BTZQ1arkez+hUUEiY29zYNQ9/mpAiGY6t1zK4zC6zX0+9yvK7LHKudnc18flTEIP3iTdDWFIsVNm0dGstalVwKvsEkH93F0Sw7f+/QL2dXDTu2RUhesdfULyK6vXpQ26fkTAuKXqqsKhHunUlboG6Sg6Drl2Np8Bd7EH9WKCMttxICxOuPIhLbO/xxalgbZrGeR/E94m+iTiiK76V679X7mP4V447I/w4Kz4amGwFqMIAvx92Tk+NpNFl+ct8p5Lqz3Eaxg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 14:19, Usama Arif wrote:
> 
> 
> On 05/08/2025 11:36, David Hildenbrand wrote:
>> On 04.08.25 17:40, Usama Arif wrote:
>>> The test will set the global system THP setting to never, madvise
>>> or always depending on the fixture variant and the 2M setting to
>>> inherit before it starts (and reset to original at teardown)
>>>
>>> This tests if the process can:
>>> - successfully set and get the policy to disable THPs expect for madvise.
>>> - get hugepages only on MADV_HUGE and MADV_COLLAPSE if the global policy
>>>     is madvise/always and only with MADV_COLLAPSE if the global policy is
>>>     never.
>>> - successfully reset the policy of the process.
>>> - after reset, only get hugepages with:
>>>     - MADV_COLLAPSE when policy is set to never.
>>>     - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
>>>     - always when policy is set to "always".
>>> - repeat the above tests in a forked process to make sure  the policy is
>>>     carried across forks.
>>>
>>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>>> ---
>>
>> [...]
>>
>>> +FIXTURE_VARIANT(prctl_thp_disable_except_madvise)
>>> +{
>>> +    enum thp_enabled thp_policy;
>>> +};
>>> +
>>> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, never)
>>> +{
>>> +    .thp_policy = THP_NEVER,
>>> +};
>>> +
>>> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, madvise)
>>> +{
>>> +    .thp_policy = THP_MADVISE,
>>> +};
>>> +
>>> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, always)
>>> +{
>>> +    .thp_policy = THP_ALWAYS,
>>> +};
>>> +
>>> +FIXTURE_SETUP(prctl_thp_disable_except_madvise)
>>> +{
>>> +    if (!thp_available())
>>> +        SKIP(return, "Transparent Hugepages not available\n");
>>> +
>>> +    self->pmdsize = read_pmd_pagesize();
>>> +    if (!self->pmdsize)
>>> +        SKIP(return, "Unable to read PMD size\n");
>>
>> Should we test here if the kernel knows PR_THP_DISABLE_EXCEPT_ADVISED, and if not, skip?
>>
>> Might be as simple as trying issuing two prctl, and making sure the first disabling attempt doesn't fail. If so, SKIP.
>>
>> Nothing else jumped at me. Can you include a test run result in the patch description?
>>
> 
> Instead of 2 prctls, I think doing just the below should be enough:
> 
> diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
> index 93cedaa59854..da28bc4441ed 100644
> --- a/tools/testing/selftests/mm/prctl_thp_disable.c
> +++ b/tools/testing/selftests/mm/prctl_thp_disable.c
> @@ -236,6 +236,9 @@ FIXTURE_SETUP(prctl_thp_disable_except_madvise)
>          if (!self->pmdsize)
>                  SKIP(return, "Unable to read PMD size\n");
>   
> +       if (prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL))
> +               SKIP(return, "Unable to set PR_THP_DISABLE_EXCEPT_ADVISED\n");
> +
>          thp_save_settings();
>          thp_read_settings(&self->settings);
>          self->settings.thp_enabled = variant->thp_policy;

Then probably best to remove the

ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, 
NULL, NULL), 0);

 From both test functions?

You can consider doing the same in patch #5.

-- 
Cheers,

David / dhildenb


