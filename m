Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35887CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 21:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D43F8E0117; Fri, 24 Oct 2025 17:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D708E0112; Fri, 24 Oct 2025 17:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF658E0117; Fri, 24 Oct 2025 17:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 086F58E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:52:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AEF8129C3D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 21:52:19 +0000 (UTC)
X-FDA: 84034356798.22.5FA1432
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id A7898100005
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 21:52:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FJ2bxntR;
	spf=pass (imf14.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761342737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FUcCcJlUQX9N5j73IHlm3kEsLEzA/w9xUA1plBPmHM=;
	b=Mjkz+tphzM4TiG/VTm5c3F8ULLwzrulxWzJmwJ/I/yu/JXGdKBAFX9NXxRQT07obnhZDkw
	2xqXJbhe0jo73TRCaL49sokqAKd8Ur+CSHIZNry6E5CenxPsglHNfU76kHU305xspHp3Cf
	+6rVQ/qiFNbGwGmyY2WxheJnGiNG5P8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FJ2bxntR;
	spf=pass (imf14.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761342737; a=rsa-sha256;
	cv=none;
	b=xMhbZTr86an2giPJ6de7loPXF1pgWovB33w9+apuvKOHvQTbkXFHsn4ptusyckd707uqje
	euZRWJLun+iDhB6KMsYbr7zv/8udjWCVx9XkdwWyxmS6KnV1T8pgtcx2qTpIC5Wk8wVmln
	ynXcaa9YQiMniAMIvTvOHdIwflsplqc=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-793021f348fso2270434b3a.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761342736; x=1761947536; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3FUcCcJlUQX9N5j73IHlm3kEsLEzA/w9xUA1plBPmHM=;
        b=FJ2bxntRqp4IKV3Q7O9Dddpjl/M2HnX/sfZRsFMV0alaDAjVcN+IIWAKbfTqlnsuYx
         nqNAoj0VK3hAclupvskve6S+HIVePeHFroE01UREtPi9HCLHn/74Tc6+ZQxw3AWC7geH
         Hobn4DzBPs8BfB/FDkeikdyvYjrHvXHTSIkDZNsTdJ2Wz2Y7lew1bBdcYutZaBALPZ02
         H7Te8/eTyzrwbODJGzTFHqiczllRWzPSn6wGphJC0IjYSdppFjpEmkXHRq6xKv4sEEEg
         T+iZkT1SbdjHolQa22EU2L/idL0pGT2EnzQjcwuq0YxSNBqFoAIjb6BJZMVeKUPfeL6K
         JJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761342736; x=1761947536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3FUcCcJlUQX9N5j73IHlm3kEsLEzA/w9xUA1plBPmHM=;
        b=wwaR0y8BWEFpVDB9vz+ho+iO98Znj0fa04PMw4khiBV+th6HzxDD4aVUqT6ZRoCrsc
         7nZVye0P4eU7XETMGh7jkP6M/tMQGa1+RKEKxs/DmJGhmZzg+rUWyYS9X3YL2qPM3+sx
         dmHkqaxGzAmXZjWv1T9RpuYJasHaxqU7ZqjSWj6u2OJJ2MUNepzJEHic6EbQsRvYTy57
         RkrTwPIjdV/ELkL3ClakO6NNZd3TIJTB/lT4/fa0b4mCwKcrPuBz3b3D5JvaZ4K6avEH
         jBqNYLcxS7J3IBzzkaUq+uc65mF3rxEFRCLzvhyT3wPzYGDLy3w+cD1xVN3Y4c5bcD4F
         xVQw==
X-Forwarded-Encrypted: i=1; AJvYcCVDXNZPpPUgZpj0qI/pZ8Oz3W0IAW0onedsik8YufX8dPUIVec6itvBp3QqWtIn2OAjLE7rdt6ycg==@kvack.org
X-Gm-Message-State: AOJu0Yx82TdxUoYA0Uu7xn+eaupPm60gmqhEc+2j0kBTfYGsOuSXKDc7
	TdhvTh7TVZDWRWA9mt0xThnMDxg7ws1K6R1kyYS8niAtoHEdFqUjuyKch+ao8ITI02M=
X-Gm-Gg: ASbGncuV+m96ULS1oT1qb4rY/CYt5wq88+/sfHB0SwBFo1EHDC8N17pJWbt2Nz0LNPN
	83Trup8I8hG/qS31f0Xhkxv2sF553Eth+zISbxQxt14bArKbA1ZH9mkWA4jIFuzbPdvgjLjTpr6
	oCCKNuoU42oYVJkqOkJnR4Mc+HrKkZdX++4KKC/e4emASwnIip7U1tPuaAYwC/qsgBDFKuvgv/g
	64vvmWuJ2hT9tQVuk+TjbzJg4MOjky3UVs7hVgy/ZC5Mwff6FFEaWwCck3CBBHknq2Vq7UTFjnP
	pUMhhoRM92l4GT+PvZOBBbp9dYv25i8kmHhGJpx8VOvYmblVcbWnntSRredbo6TohT8smbFxLeo
	WT0OTZa/33hMhJV1xbOGDK697GvV+wqFhiohpEp63HmWDI5B+/muDGFKzHLuBPPchIOi9gEBLUs
	IWDuNFHiTGaLyiSf182ND/v2ED9GjJWU/qBlq1RRnbaJ3BlMwnXCouFe4=
X-Google-Smtp-Source: AGHT+IG3Hti9nXwXuPqxU1C5U9jMd0lkmL/3K+zlGQ2zLi7DLtFKyeyBcAj1+fh+6WnqvT2HxVfD+A==
X-Received: by 2002:a05:6a20:244b:b0:2d6:9a15:137a with SMTP id adf61e73a8af0-334a864368dmr42090465637.53.1761342736424;
        Fri, 24 Oct 2025 14:52:16 -0700 (PDT)
Received: from ?IPV6:2804:14c:5fc8:8033:7222:c3bd:a7e0:56ee? ([2804:14c:5fc8:8033:7222:c3bd:a7e0:56ee])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed3db6f7sm112347a91.0.2025.10.24.14.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 14:52:16 -0700 (PDT)
Message-ID: <51c4dbeb-7df4-458c-bfd1-1744462f50a3@gmail.com>
Date: Fri, 24 Oct 2025 18:52:12 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 craftfever <craftfever@airmail.cc>
References: <20251023035841.41406-1-pedrodemargomes@gmail.com>
 <e0886fdf-d198-4130-bd9a-be276c59da37@redhat.com>
Content-Language: en-US
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
In-Reply-To: <e0886fdf-d198-4130-bd9a-be276c59da37@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A7898100005
X-Stat-Signature: okmi3ct5recdssxjzyxf1xnbhqfwswyj
X-Rspam-User: 
X-HE-Tag: 1761342737-106375
X-HE-Meta: U2FsdGVkX1+n17PlBOV53ot8e2qpFF1Nvpv/wyupW6/N6NcKfbqHL9k2bJn+LIcfxB/hFQp1+Q+0u5TLOcowcJ17kDFa3LTAp0QShlTqhrJDRnC/NrB0xbgX5XReUs0QryY/0VAISFIqUjdFP+VSnave1ZWDc80jd6Nvw6V+E43XJUm9tD9N01GhmsCXKpFDCarOulSnWXOE19NdlNfNTFEx/JAW+c0BdOHz0QvpdzxN7o3pV+4uyBI2qoJWgzvxNso3tfji8clkLQBTp0jFX/4eoNn8CfQKTGht/OA5u5PK7G5LwlqKDy33FCgCkgxSvneOoYFwK3UMDM5v8jBfe1paYsqMzgOVs2qtRmQ21kyNqos90PYFiIDxEcTszA2331rVlXeCmCGHJpIJ0tPcFzfNfsGkaQR59d/YoE/sLnsbu7kXWZGnsBNzBcvJ0XSAes8zng7M69JEo5/r4DTusvEk7unI2nKiZ55catTYsBcGBDRrtU8BEAi4YyHLhIJ6c5h7Eg/R58Dqrl0FUSizfaccrM0rP49R9MBgHQBoLgxLZEaEec9w1nN8VQPyuyUXKlFR0lpULsoOyHWjUMU6Ar7QBa7kbURVHBjMxBnUZLM1akTegY2Qo191O75XqnKM/9T18oiZ43h0+dpLMLLq9wTpu3CCvIldu5eztk3ZhUie/5cw5JSG88bI3xHk9HjGq06cmzN7rlUDl1jbpvpQqryUJKKSdsoQ0Mm0sPL1b+PQYATcTKVB8IiSIQTNw7MnlIR2DOCE326ic0vqsrBVJF6+mRdINxZXTtj0/MX33z05SoelX/XuX0ACrYK1xRe2ESZHMyV6yJTBJSiCl9cXHFHZiwApLykIfcUhVyef/f29m5wMxIAjYuYvNBOUnStnLjV2TAEE61SDfd5sRdLACfep4aJ4ty2vXYOcFzF3GtiL3GovDsxFrvD4ow7SvnuerPsM9yXdMW9yAGapxJK
 kWGIrYLe
 37IAxZ+toD2k+J8XhJBVX1EipV07GOIOxklPcGnQuYrWF45lnE/tleFooF3Qv9IpDNzro1N2TmuQcNJBGhu0tzbuR3tbrAZU9sxdUpug5W9dIyRytO0Jt+gdx9qg8CtUUunsy5CtTwsaBXvlttXoedvNoq9RL1nHCN/gHBhsKkSJVQDtVzfvZhPNKtT4yEsgk0ytfzC0sKdTW+20VOL5G1fLjx/dbAjp+KjEkNQU9zzGsFRYkdWSRqFKQqtZnZU2c570pREnZbswaln7/cZx5HuCsg0xuff92BWPsRx10CAzHGyDUKGDVBCLjVw046rziG2Ct+4fXFBREvgp3jqCpzi/qgQnTD1W21TJU7KK36FAZ7/Mneh8vBUaZ9i+336OB/NCCumUOlSXUD54Favy3EXphw7TmRImLNig8vtKL3llwANOegumU9Yxz7P37LZGSRadv3+SeNUSi0usNWlFp/a84gkXVrAQj65UF8AC2Dhxi6ah9M9uug3M4Rn5goh7DqYCX5AGGVEg6gRwKSJ+IznSGejp3ZRF9u6B3A9bBqAWJj64=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/23/25 07:13, David Hildenbrand wrote:
> As a note, we have similar code that should probably be doing a range walk instead: unmerge_ksm_pages()->break_ksm().
>
> It can be triggered on a range through unmerge_ksm_pages(), which gets called from:
>
> * ksm_madvise() through madvise(MADV_UNMERGEABLE).  There are not a lot of users of that function.
>
> * __ksm_del_vma() through ksm_del_vmas(). Effectively called when disabling KSM for a process either through the sysctl or from s390x gmap code when enabling storage keys for a VM.
>
> In both cases, it's not ksmd that's blocked, it's just that the operation (trigger by the app) takes longer.
>
> So both are not as critical as this thing here, but likely we should take care of it at some point.
>
> Interestingly, I converted that from a walk_page_range_vma() to folio_walk_start() after converting it from follow_page() to walk_page_range_vma().
>
> But we never did a range walk, we just walked individual addresses, because that's what break_ksm() does.
>
> We could effectively revert e317a8d8b4f600fc7ec9725e26417030ee594f52 and adjust it to perform an actual range walk by passing a range to break_ksm(). 


Thanks for letting me know. I will send a patch fixing this issue.


