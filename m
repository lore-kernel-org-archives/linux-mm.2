Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFA4C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4406B0096; Thu, 27 Aug 2026 23:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2966B0098; Thu, 27 Aug 2026 23:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F356B0099; Thu, 27 Aug 2026 23:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD616B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:50:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57D4F1A0254
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:50:57 +0000 (UTC)
X-FDA: 85149302154.25.3B9E3B8
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 79591160002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:50:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k9X+Xl8M;
	spf=pass (imf08.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787889055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KcPIBnQ86fi9vMxouOV7SSnCq2u1kcpTpfhzejq3Hs=;
	b=0Uf5Bm3Z+eMTojf9BAuR9OCwrPm0YMxwLvMwlWxkwSI4StYuz8zFaYLhAJdeEyGenYsMTI
	ud9FYl434YRGBIDrFAI25c4jVU3wzfawbmr9RdRQ3UoXly3Z78o02xdLM8U5SGpRGNufGP
	FFo/RoM1525fGKDyNwXGNC8AmWC/lRE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787889055;
	b=ApszZB2e94Hd3Y9Y8MQZwX+MCDu4cuDTR0iUIfpght+QkCo2Jyv87NL29elOAfwKjT0VfJ
	LrmpMGRc1Sc7ONFAgcmxlCkMv+Jpfk6ZFw80EH/Mj769UxYfuzVD8bNImLUk8EzYqGGDME
	DzyFRR19ztmiQCIL7GliBvcUzFowNwM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k9X+Xl8M;
	spf=pass (imf08.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-39266382df6so723412a91.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787889054; x=1788493854; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3KcPIBnQ86fi9vMxouOV7SSnCq2u1kcpTpfhzejq3Hs=;
        b=k9X+Xl8MbQIwxXcdqal5taRJgkhl+wT/A4J6/yA/wJg3SsM4h+mTxQ+tHeVZY8sXqi
         QCxZLdDlEWLQG2OwblRcvCQwwxsm47R2D1Rs+Qx+/qHlKG+G6aEkZoSRoektf5lqmgXE
         JqpyBCTyytMHS9EHuIHNxYhZCoIR3EIrKrW2s8RFqD8LDDZQHbCQuFZftr1Vr5Xjg3BD
         0t/Vqpm5U+LL0b67tc1JWtasc8lKxnbkUywrzQ3cQPm7+BL2MK7VsjbTckSM4okmtxZP
         ESrDFGznLlckYeY03JzQ7oTlYqj0KQdriToefhQIsC464/G1NZDbVfYoZIDMzQFQqIwF
         pVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787889054; x=1788493854;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3KcPIBnQ86fi9vMxouOV7SSnCq2u1kcpTpfhzejq3Hs=;
        b=J15yrlx6OLs4JQ2lA9zTY13UUURyjbbzXqcOO2FZow40I5dz39bogcEKbSrUI3tmNQ
         egQc87ueyXlRnzld77pLcIK2QZCjaR+KpBXwoiXcQsL6T0MuYC0wOqBOWsJ6y4H6YFsE
         NA2e6GIXU8LcNXY6uae4m/Vjl4UW5meRR0imUX7FLH3UgZZV65R0QkV9nkqGL2iwzyOS
         ICX5+4ioC13YM+JJk3OnVK5EKffsX6ZaT5vIRdLToeA+jSKBAQK/2Ai+2welGn0J2XWt
         vxHvwQX17Hv5WYVR+iNPBuE/oKXrV7xOtQ3oM1FSvkiFh1JRUg0ATdGfOHLlQrNio/jt
         LK1A==
X-Forwarded-Encrypted: i=1; AHgh+RrMkQmv0yAfBP5zjZPSqEwi+gzJ0hPQ/7e3bTwK8trIvmjLSdut4pwtQKEKbBRQv3yPwNsEEPheiQ==@kvack.org
X-Gm-Message-State: AFuF++md2fdYkoFFDDADwXhXBofJIS1KpKGt5Ewrw8uboFPo44WN89Li
	FfW8/Yt8t4Uy5D1LGGkUrOXpOyBlqHmFl0/CA4i2V4k6jGlGQoN7q7TC
X-Gm-Gg: AR+sD13My/0dFGR5uzMN7YmZ5qAj/MqDmG3ssQh+9xqXFxsFs6PIi30L6KGRGBQDYFx
	gtJiwLG0bnbRJVbi2uCGZDkiIqKlSTt5uFNWP2ESS1u23sjJEDQJaAM4m6TK+ZGy2S/4d6NXT8D
	w6wSFQPJXTqsUuyHvoYZzdDsUat1TxwNoXA5ryNd4Th9lAGftpAomD9FYnU8zMlI60R4FeRN/Us
	RvEKVq9xPcsxlTT2ll20D1R23I+V1iytla5L2tFVk4bJoHychi9Zwetrj60mmjVkrv7B9TFVwrC
	HrZ0SUqWosE/8Xk1QvVY4vGLcMppmhTlPLZyExTqiru0yNXImUiKBnRXjlXWfzphpIveL2RKb9y
	qWvRMv31Q1zTIobVbwkoTDCQ/7GvbFSXinTcUS6NqxfFepeurYfw3TdNwAVJ0q2lQK3zx6g0yet
	1tslGYWEtDaSSvcdzBWKXMRpzeTPoGe3rQLnPMgiEUX+2gqh8auDLbi7F4rnSK7pQHTw==
X-Received: by 2002:a17:90b:2d82:b0:393:194d:5366 with SMTP id 98e67ed59e1d1-396d0f6f8bfmr8174751a91.10.1787889054288;
        Thu, 27 Aug 2026 20:50:54 -0700 (PDT)
Received: from [127.0.0.2] ([73.222.46.22])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0e0e67dsm1659184c88.15.2026.08.27.20.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 20:50:53 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] binfmt_misc: only let punctuation delimit a
 register string
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, Farid Zakaria <farid.m.zakaria@gmail.com>
In-Reply-To: <20260826-work-binfmt_misc-delim-v1-1-43618adf8599@kernel.org>
References: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
 <20260826-work-binfmt_misc-delim-v1-1-43618adf8599@kernel.org>
Date: Thu, 27 Aug 2026 20:50:28 -0700
Message-Id: <178788902860.3236768.6730484936359324341.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 79591160002
X-Stat-Signature: brg1fandqqf69p7cdnxwpopsp7t54cx8
X-HE-Tag: 1787889055-492705
X-HE-Meta: U2FsdGVkX19ILfUcN8f/pNr8gJ0RCYug9iJRhOJFK3QFmaCPwpso1cDeXU5bNm9Q3rYQXmjAgJBtWH59TkD60XqAP5S/auDqFmkwERQMWOhdfbGPlA5eyp27w8zmQRWadUZCUKsRVQSXAVy7HiPixMx1Bi0JlIfhpwckvebuDippj+jXZy7hy6jxLWcXq59+qSLAcbi7honjSFmruJ9D6KQ3aCpamXaDokqCx8r0HFY1TFK/MblDUsubt9XVNMighMdWvfmKiuPRfoPmV2K+lfkUuSXRjVYXO4TU2i+NazNulrBox7OrRZZy3zc8i3+M4U8Yjvq/jgD9cYfslwV+Aq+A5mwiqD9gYQ5VhwzXAd1v4N71Mvsjw4PYBZqLDQwJCdkaUsJ8PTAVtuOW5YUn6j502Pez8YGizf45Dj8y8VCayXX0XOVi4gl8OM31F1Hyfs8ri28C5HAY1uSVOgPzCbLfYsAPCz9uQ+iEahw65JZBYQGLl52YC/wB6nubrHhuBTdkcdriAMa7S7qqfwSmWikQqyS25BDlUtB4y8PPTF2qwC8EK45g/7Gyh+fYkTPCviGkAmzPpi04jJ4FxyjgjD0wctgKfeiSNb1mPSogFxwtTBBOt6w7wl9QURzlOQDTv8W5fi55JL6BsDnEBv7qLT0zKS3II+2xB5hKD6ffHnCIHKBB+QrUp/VqXQOuljnrce4oeufLCDjMyTL9v7kLWE7mWZ+R/kAdtIom4a0X7iF96ywF3SUoSIIYTrdQwKuKDo7B8dA2M6W+LpizBFPfVJNfaH0vM/yvVR3LQ3Tbni9Vq6TvMaNCUeL7y/wxy4iwKI1lSRprd4o03b2pJWTbrX7HaJdlfaETYPi+5pTkrmrzdhr2S5HUlXT3f/1cST+lR56R9SjPm59c7ebadeNdAPiuKCvq60TzPz48EG6sbQDFALuBGxT1+PiIodyHfOx5Yw6etKkn1tUYrNn/RyV
 B0Ne1hZ9
 hMo6WzdsUNWOw9GUz6xqqL+qOBHpYXlWHbRtvXs9i3S4md5JV1bxt6e434Frb3fLvzdBUUPGn00IgpXyYD9TS29OxICVszdZ0SclgL8XXLZdsF3gdU507vGRAFbWV2zhIe8ibxi3hpHMtbR3cHP4rUmcSmIQF5cJAjf0YQ+Kssj6Lgcx/dkcBuKmXw03DEshsvTA3V1UxsU6+9821huFL3PgmaoUB1ueCFYMQcNOuIi+u2iYOUI90S8hXHhjYPozL1CEUF3A6VOUJ6kZNAcVG47I/KI1x6TC7NwjLTE206YDeTRkuZX8K3YU6luy3zqvBaDDa/LYxmnW6p0LcojocjnmeC26PQOisz2+ROFOz6IYbCMQ/U/QIWDv1INWQhM+H5nh9PjneysfZHpV39kMHY5zSubn1vIey2wkWNfi0MK3Dq72CP9Rtu+IPy2AIjWLXE0rWSYWcs4on7x+MQ4adCL/PhCddRgZ7ep2f4S+ti7Hqh8IcwSLZRWtSEgghrxYBqjC1kxgWWbj+X4gaqPJRbUVvVff2oWN+oUQVI275x0CZZRiTONtEefmVmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 17:55:46 +0200, Christian Brauner <brauner@kernel.org> wrote:
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index ddfd3aa57ac8..809c91d21b39 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -100,6 +100,13 @@ static const struct binfmt_misc_flag *misc_flag_by_char(const char c)
>  	return NULL;
>  }
>  
> +static bool misc_valid_delim(const char c)
> +{
> +	if (!isascii(c) || !ispunct(c))
> +		return false;
> +	return c != '\\';
> +}
> +

Is there a ready you did not make it a single && ?
Feels a bit weird to check the negative;

i.e. return isascii(c) && ispunct(c) && c != '\\';
(DeMorgan's law)

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

