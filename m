Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B6FDCF3977
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 17:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA1A6B00C0; Wed, 19 Nov 2025 12:19:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91BF6B00C1; Wed, 19 Nov 2025 12:19:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE806B00DB; Wed, 19 Nov 2025 12:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFE1A6B00C0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:19:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A463CBA470
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:19:49 +0000 (UTC)
X-FDA: 84128018898.01.7DFE82B
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 808C110000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:19:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=xhqWMMuT;
	spf=pass (imf14.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763572787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoCeIVGZrihZGBDqvC+f7PXwUd8OXTG8E9X1EYx2gXI=;
	b=SYzDj6WysAzjmy1mNMw8mg6tbtTZsXzTky093EGJ+t0lLZtiRrifmNEwcu+uJnr2nzIXoy
	pKcQG2WorxlnbsrrvZS9Q+ml7QtTCfszaR8fy4WNzIj/kqh0wdkxfiViU1TGXeLhr6aU9s
	aAXd/Kp5EVxCOiTj/y2IJUs2TrQLiOI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=xhqWMMuT;
	spf=pass (imf14.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763572787; a=rsa-sha256;
	cv=none;
	b=W0TUGtrzrUSmyHUHsUSK37v1y+pWrNTi1GbjG/eQumsZ5mn9+PDYzalyrcry293V2T5p85
	rCmjVmAkQ+y8FXW4Ee2EueSuLo3N8h4vaViw0ujcnsDy22zMzLLalGfGqHGLRFK+EBAJTi
	aIkEmK9HizSoxU9S0OwHzM2gMUyBpeQ=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b7636c96b9aso162825566b.2
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763572786; x=1764177586; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yoCeIVGZrihZGBDqvC+f7PXwUd8OXTG8E9X1EYx2gXI=;
        b=xhqWMMuTrDMYYYoAL5MKFm+mpxH+h4UGIk6WuvPojsbFe7XQr7rXk1DwAaBqlC9Luv
         PeYWQRMrLd5ZjHKTv8SY+tFtKNgU1o+UjGi/pSu+XveI5YzNPcIjOzRhHOT9DP0W2YLy
         ZxxUhvjH6O9FoIBdSOidXBwGbFU4Si0PPFLYzj4SHGcol2nSo0OGVNb1cPK0q+4FksE4
         em4qTMHT9h9wk3u9HD/9hW75m4baw0NXMvTQWR5VvMqsNLqbj39JHuA97pryDZjPBxVp
         EgFv6kywR5ch2GZcNSGxaVaFT25LQ7dbuhwrd6kjM+8W2FxSkzgZmu1cesV/B1ujd/rc
         cXOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763572786; x=1764177586;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yoCeIVGZrihZGBDqvC+f7PXwUd8OXTG8E9X1EYx2gXI=;
        b=sx+NH/mwsiDsHbEld8Q5fzaKbvfa5oHXSz3BO37uZ+6stWVNkc8NQVPc5MrF6v3n/h
         c+LoPqm+oOFc9u2bacV3reO4I4SM2DQJBCmOLJ/oP+t15cWHuRj99GWzYytrGlcuOB7U
         r/iiBaXltt6alDgQ9Hf7yi2Nfjzy8IjSEszPYf1d8/xzki8Ufoa/iyjz5I3VjGUbq2po
         hckFUzeypXOvP9X6xavj6nhM5XcQxCwtehNgA6q6FY2Alfm4O3/g//241h0DZY80qg3s
         Z9HIGTLK0/UfZ+yYpizwyiCnD60NwX5RyGttlCL6v5pfWrFqID149NDfSqnN6EIul5Ss
         rt4A==
X-Forwarded-Encrypted: i=1; AJvYcCWqQeHVb1IRPDc9K0IQ/nPsVYd0Geg1qd6K/OB7TlQEvKujDEy5O6oaHP41zyr9QlqqHYNXYoCR0A==@kvack.org
X-Gm-Message-State: AOJu0YwfFR5/9zTs6MvHNIVvXleKT4JXBcbmLrzvR1yNjoSroW1bN4JQ
	CMSnzyI76Gv+tEPvVYoqxtGQkzSHQYzu8hi7nTZwRMkarRm0LzfATXA03ntmH3atHlw=
X-Gm-Gg: ASbGncu0QYZ8kgu+O7RxF8n/jp066WGfIWd+uWZ0Ol4H127tGQrqoO1i4ah35H5G/8I
	+pJ1ODg57l9HgtT+yJQli19xGY7onnfRxOxTkS6Cqf0yHYAJ6oyR83lGQqyqBzh1PHnehYv7FX8
	4glka88bnlaqANkJ2Itq/E36mmtXxm2amM7ZEjSU1PK0LeDMLg/bhawW6+iMTq+qJU6Yff244WT
	SEraiH3TIGEtW/vPhnt166R6ZVF15FmBARpAAGzwTIK/8hn95r7Qz9EyYqo+J4Nr8KzPqIJPl+f
	Vb4iIZ07xE9ug4xfRVe+zEyMiyLEgdsfGbvBiH1xCQNpjCjYIslaAfqwxH3/uawJhcBYaZZpxPH
	HmbxzJTWGTSsVOv8vauH8g36IGCenYzZmJl5Wo63OWArAV4nHeoVdqkRVSRsQmrKbVvGFjDb8fp
	PZ82BQQkCflgQeGggQm12x7gJ1/1Y4g3t0fthhJ9kyqQ==
X-Google-Smtp-Source: AGHT+IHFXlBYjBXYt8PjoVc6j/wKQUSsTRCIrYOrIhFX/QpfdOU8ruX00omnczPPKhikD5LHpvnGDw==
X-Received: by 2002:a17:907:2d12:b0:b73:572d:3b07 with SMTP id a640c23a62f3a-b736782d087mr2292251166b.28.1763572785909;
        Wed, 19 Nov 2025 09:19:45 -0800 (PST)
Received: from [10.101.2.140] ([93.122.165.106])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fdaa15asm1625320866b.57.2025.11.19.09.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 09:19:45 -0800 (PST)
Message-ID: <d24c4f4c-e58e-483d-adeb-9ec1799c80dc@linaro.org>
Date: Wed, 19 Nov 2025 19:19:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Introduce meminspect
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com, tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <6c9b0aa2-820c-4153-ad64-cd2a45f7cf32@lucifer.local>
 <19171859-94ac-4f41-b100-70a1497e62e6@linaro.org>
 <dc9a8462-8384-4e9a-94e1-778fc763fa9a@lucifer.local>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <dc9a8462-8384-4e9a-94e1-778fc763fa9a@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 808C110000E
X-Stat-Signature: icb61zrz8wqjmybnkqahw4w9xufioh7j
X-Rspam-User: 
X-HE-Tag: 1763572787-343216
X-HE-Meta: U2FsdGVkX1+ZDHkf4Yz+GbvvsG7SJGnZZI/DzgMRIXV1zsBbCA/HJ4nYXElCFFas0daktvN6WxpZjpu9xbRJZ3az9NeQAATH6+7MeiKZVYzt5bjoqUxvuR9vW/Wr7xhbdY08KQk9qZCCUE6B8fBRhUhgoLxrArGc+PZf2Ru4gtSVNV6BtrBMSFLvxWVwAocIQAvdrDz7pVlonh7hfmaJFf3iNHRdLc1c6msEHbSgKOKVb+c/VI0miLukfwmXbYXqfqK7OmrVTt0WKh9hi8L1ly1rveBI7Jt1IxCjy9qV//JvzuH3w9a3mjAqvWABaUWjZ9nPxSssjx92QY/LmJhf4E6rkTmzrGLKhkH2Ox/u3rpbfsAuH+BbwyDUBdEomXyHV1ixoSTbPOm+P1ui1LrAYUh/lyJVUdSRNHoHkAkDA8DRle/ynLbly1080buwUz1udICyWGpLBYuuTMhofJjfg5nieRsGrJu3+4DkC7wi9iH91cUTlQ926A2O5umU7lCVPILA0Dip5TcqXW8ldBbPRR4USMQaGm3gFfIDy0A5lXLSNuVj1ce7qBtwGZ8eBBPQ7sNqpXoy2p6zM7P/PH9Sf0pwb0/KQnR5GjD6a9zkqesxGGWkF0WC6PUdSooGT7QBrmgio/NCmuSLoPZdHKKeWG9Z8l+DE3WQMWwNzait4SUhDh+yYmuy+kpheyG9U2RtA6XdJCgpg09rQISWjmFUEI0bYucJzq/7fcU4RVNqjrMEI2mk2AwbUHREG7E7oe5U2iOCQcUHHYYlhYYfogYSqUAZV94gk+QuKPTcZP8v4OYfc4LQH71AkLoVSbszK5gjzmP5DlcqgbCWCDA1FtdYLKagCZFkFcEci8cG/DqXf+dVpvdqTLtZkkManNbp0Ysef8ED3ViYS08TU+anzdM1M5kRtOb8kIlDWHcg9cmPMxTqaYt6H9YIoL7vbP/LnAX/+x6SbN3cnzqeBFk2EdV
 GWnO+00d
 vuEc1PIx1Olay5cO95nz+5T0daWtu01c0nWLM8kyNHX3mWpkUn61da4zdBifS0ghOp9BotWJ7r8tSBJtk5RRQZKDbxp0pjxRBUnPGVriCvBX7gHJVQgYPyB5hRhjMr2l4AHjRT3wKt2OYIGgJhcXxqh5kY8akjMSyKdhG7qh4v8Hq95LHFj5WbdXXcee954yX4nGc26KhUmf+R7It9g+Z/tmARNsOH4DrYSf0yaGfKgplJw+rGBaPK4hzxF+fQFLP+h2fqY9e8ycytMAUPcEgyBOad7zmWWlNjzYMWEN74jUN43XgtrCN+KQXP0NMy9coLQrW81OGw7jw50PrhgSOPvf8Ko0fGTIp+NhQa2JP2FvWc+rHNsL2ywA8+3ddX4/OWDSaSVtmJn9qNGEH160D/MVNzFHluGDciEXk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 19:14, Lorenzo Stoakes wrote:
> On Wed, Nov 19, 2025 at 07:11:23PM +0200, Eugen Hristev wrote:
>>
>>
>> On 11/19/25 18:30, Lorenzo Stoakes wrote:
>>> Hi Eugen,
>>>
>>> You've not run scripts/get_maintainer.pl so this is missing a ton of maintainers
>>> that you're required to send this to. This is not a great start for a huge 26
>>> patch series that seems to want to make very significant changes.
>>>
>>> Please try to follow proper kernel procedure.
>>
>> Hi Lorenzo,
>>
>> I included the relevant mailing lists, but indeed I have not cc-ed every
>> individual maintainer. Do you think it would be appropriate to resend it
>> as-is to everyone cc-ed (PATCH RESEND) or just do that for the next
>> revision ?
> 
> Yeah probably fine to do on respin :)
> 
> But obviously let's not land this without at least 1 respin/resend.

Definitely. This isn't something that would land without a lot of reviews.
I am sorry again and hope to hear your opinion on it as well.

Thanks,
Eugen

> 
> Thanks, Lorenzo


