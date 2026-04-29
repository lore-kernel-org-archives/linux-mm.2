Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE6D4FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC806B008A; Wed, 29 Apr 2026 04:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4947B6B008C; Wed, 29 Apr 2026 04:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1376B0092; Wed, 29 Apr 2026 04:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF666B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:01:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E03DE1202B8
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:01:06 +0000 (UTC)
X-FDA: 84710847732.03.FE887E9
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id D9EF2180014
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:01:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JlAlwDLE;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777449665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPx/kD4WGWKxwaJpCnYAciCBrDKMYIK8dIZn6jPFTzk=;
	b=Yu7Gx20cFWrPrKYk+ZfSPRHWco/Ev4Ius6ARDqJbe2u/MfLCcYWD0/ZEKiaxoAt5whNJ/O
	uv7OhozHo9Kld4RKVpr1hXI7HzTfAvNu4MuUaFsV9cAUUnMcWx9QwiLZtcC0UIrLvUN3Wx
	tOtiG1Mlj5hh4FEd8yB0X5P3Q9Og518=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JlAlwDLE;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777449665; a=rsa-sha256;
	cv=none;
	b=AeQ7YzamHcf8alSOPmwEZl7Jme8pbrn2J2a/7PM147TIrDPFzKfM00qyIvBPaBMGUl+eR9
	V+AgA2L/Nh+lfb2u5YcCKA4yIccYSjuKH/fjS3Tuh3MbsHJKgcDx7C18cGFKTYTV2QQSUl
	8gQqatgmoLPg7YlAJrJb+5Hv2Wr6TuQ=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4832c8f9d87so15612505e9.3
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777449663; x=1778054463; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kPx/kD4WGWKxwaJpCnYAciCBrDKMYIK8dIZn6jPFTzk=;
        b=JlAlwDLESDmENQGLR9m4eqhiEKPMnOREHRAa6Stqm9yc8hq46UFqrD0zrKTYueoZfd
         5oqNP4QBMuFAxUa4oSuiEum7x6Bo36uAznrEb5e5ZAl46j/jUY0txamMNHDEa/jehGIM
         0MGrBX4E6k855v50+zq2j2OiXUfvH1ryGvo3djgtAVxlNTRpVbQMMgFzPQfR2j0uluT/
         pri4Jlbe9YzchGOvKwgUcjSQ+LyVVBAPsZVXxeJm758gX2AJ/U2VUzPZx+UBgic9jVby
         WC5dAdF+e9NhtVpOMP5i6zT2XtnIo2atU0qFmp9STr24tbulQhb2KMX+i0Uk902ZSIDN
         fTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777449663; x=1778054463;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kPx/kD4WGWKxwaJpCnYAciCBrDKMYIK8dIZn6jPFTzk=;
        b=ELRXZzE3M5lpUZ0lBvEGXLFY4Qdbnot2/50qWQnpRWpV+F1XmPOyXeG5XxLXrSl/04
         1GQzGCuMSemTPNsiSEeBZMsUjazU0NaqzySuLt8ONXm3MCLDzCqldfFIOxiL8yd+2v8j
         xRSwWRGLrp3ZbdjTjXrFze9Jm8/0zefQvciFoyvMvraJwJ1Uh5gi9T9FW4nKabViGCw7
         WIyYb8zjxd0+7m7yQJ6UA6zYaSrg3GfP3Zdq/HOpAyz3fpVSF4XC1I8cTSxmuk8sp0Zy
         hIOTocNuPN+6crdZ96sfT6xR1hKtAZmqGb++xD9BvpE7RbjExNJ5zW8Fd9vyy8T+TJKN
         lJ1g==
X-Forwarded-Encrypted: i=1; AFNElJ+6o8aj6aZh2VxtLf7/E6XpX6nfiU88Jdywoxr20BEGPEKHQAyWlfQkuhQiI74BDckETafZgd9iIQ==@kvack.org
X-Gm-Message-State: AOJu0YwJ/3fPeGMYYxG9NP5u8i4gz6dMsdkfpeK+XXxpcRItt2kwNddU
	Wsc0JRNdEUwHLhaHVYYWbuucvL4/2oew63L5IEp6ArUgploA4Hb7rhdCiLU4nQrPzSA=
X-Gm-Gg: AeBDieszLsopz3wbvy76EjPFq2+6K/mMWM7ko8RKXIIwuo7gROn0KeyNVvF69Z9xapM
	uNhPV2GGAHT3uDc+B6kj/ux554pShQTfKW1y3mLkGc415OTHmSOEI5F7CW6jPsLM7u/9SaR4gX3
	TpwT8g2PuFYCw5CP22EWloPROy6YIadg6i6ukzL37GVAjLGhlsa27GZAbXYt5eHhGmv6iLox050
	QCwTUo0WlHYSSUfbywS9ZsgsrMEYZ86EREklc4CbT5nkzcNNHQnYBp5ALdkEtUOB+veaVCQWmsN
	KleYpDOLS66lCdF0b9cKmuJTwkr6M+rrXUpgTqw7ifaLh0Aaa1qdelRq/3UGqCcwj9bdsKjoZVN
	t8HWLJ73ZOYvqiB5OGzxO/Vi/ZGgzUGvNpLt8hq5TYrMu5/le+sSX6+yzEFEMwBE+Fkf5UtXJrM
	3cPML5Nej6h6wY4o5H9N0cga3yr4dRK4b2BcJgE54O0LeudRq55KkyPYwzumyJ48I+Tz3L
X-Received: by 2002:adf:e00e:0:20b0:445:c2b4:a284 with SMTP id ffacd0b85a97d-44643e18116mr3536239f8f.8.1777449663151;
        Wed, 29 Apr 2026 01:01:03 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b7ca6451sm3922019f8f.36.2026.04.29.01.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 01:01:02 -0700 (PDT)
Message-ID: <1a9ae46f-b43a-40fb-8bd8-750c6e17dd01@suse.com>
Date: Wed, 29 Apr 2026 10:01:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] Documentation: RCU: adopt new coding style of
 type-aware kmalloc-family
Content-Language: en-US
To: Manuel Ebner <manuelebner@mailbox.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
 rcu@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>, linux-mm@kvack.org,
 "Paul E . McKenney" <paulmck@kernel.org>
References: <20260429070759.309110-3-manuelebner@mailbox.org>
 <20260429072320.310817-2-manuelebner@mailbox.org>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260429072320.310817-2-manuelebner@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D9EF2180014
X-Rspamd-Server: rspam06
X-Stat-Signature: eur1nocmgognhgopee6gc6xjunaje865
X-HE-Tag: 1777449664-319306
X-HE-Meta: U2FsdGVkX192MpHzbLpTAooiHYBQvf5d0cVl2XSUo43EB78nDahycXSMh45oOnP3eExA61rR/vmDdlwV8LaQwGeExWGy/Ipvy7rdg1XLXCFRCrfwz4O4NxzmgNROn0hg5r1IRZB+UbiEraIxrpI9iYr1cUJwoOYgVRsFKjzeoT2CjmaamO6UDeBzJgFMJeKigaim10iSHMO3+/TDsm2SwwypVb135ATsQpHPohV85apB1V7mQAzNPaLao3GFxEdQdr7P5ngKbD2TmYClxLV//0InPMcbgu42rUMPxpg+hos1eb5hlJmYxY0T/RhP0suJ/2vuO7/y5gstdfXcxv1hFzoLnjFfRajMHbGsnmBH7jYtQ8r1Hsh+5APZIZFnnu5O6+Byj1yjOHUr26pJAr2sPqiiDeRUW9J26LSLuuErIPEpseDRZQZn0an2W4D4kYnoZnu3lMZBt6LIGeODlsEfPbexIrmVAXdOV9+enMIJ/ueV9enMVYNntS3nGqQGuV4kqEvgwzwkzffoo3S35u8VvxZOLRDycK7Lq5zIPLZjP4c57R31+92Zph/zOXstEb48NjMnlgaRE6T5gDsSeTxrX8IkIcVBQdy40TcgYYYzk92bVbmztaUvOu9kuRHpUqjXzZS5IB6Y5W7kLd8mzaz5GmubxsacxWdEj2TD/x+juUfFtsEA/pt82wXniTkSbgFMl5TQ8eIqAfNbD8xHQozIrb7xV0qL7mbHWWp9Th7V2B33J5IXBo4klFoPOpxCTgOdm4R5irgAdCtdHpoEfbuBVJedPKr5VKNGns5/q4nk7c9SdfMbxI+dfhfuWw5O1Vo63W9K4xs7d4vDj6SvLeK63awQw90nBvJdFC6A56Xw1pawhz9shyLpUEYUKi0ObezfW1ufqGuTGg8g4W95EHWDcDbh0Q4iuRGPtNtOvOsL8vbOvQj4gYyAa8yP5UCUSVkaa2BnKEJ7Z8Oe/vI2H0E
 GqDaK8wC
 3dCkmHuVS1juL1xj5MjGe7M4yLJRJkyMsZo6sOyTg4RXTefdG0xmt2+RCeUNxVQJGjkmOvHWGVXlYQUXaHa5OB7QPfJ4tlsC7RLD84G40+8QGVll9AckNEbb3GXQNApTKcuAsxNFvsbiYxfhchV+emjXWb7RlR3WuwWb3EykoBf9tBv9IHOkqc3CneSFUwvkT75xmwbcn9il1AXf4RB/1efOg62B355z0QpPpcmJBcgSq90OljhRUrNchq2vxxMDBO59svh9FnMTHI1Zq0LkpPCZFbbxDQXyZHPn+EyKsd0lONSFarR+edOpmojzfS7zbqsUJJ7m8HbqW1W7/SiqWUjLOy3wFRF++ioWzs09w1U76G+URqZE+/nkSThulMgmaCt2btNScopIysJeKnK6Oszj7ZCsKWTStUXG4N4ZmF6qvu/dvL1DgbkS9SZ+3+u+KgEf4MMOojwXqRUEu5GVt6G0Ecdc+e7LchOAKVQK8cpFfNbHfNSPTEJ33UZLDo5++OygcJKIemlb/x7sOLqFSOvZZsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 09:23, Manuel Ebner wrote:
> Update Documentation/RCU/* to reflect new type-aware kmalloc-family
> as suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
> and family")
> 
> ptr = kmalloc(sizeof(*ptr), gfp);
>  -> ptr = kmalloc_obj(*ptr);
> 
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> Acked-by: Paul E. McKenney <paulmck@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


