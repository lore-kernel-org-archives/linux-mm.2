Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72761CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 22:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3928E000A; Tue,  7 Oct 2025 18:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A40B8E0005; Tue,  7 Oct 2025 18:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86CFB8E000A; Tue,  7 Oct 2025 18:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 713CE8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:52:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A81D286C3D
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:52:52 +0000 (UTC)
X-FDA: 83972819784.29.660FAE1
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id A77F9160008
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:52:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ainll35Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759877570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0RpARBk/VGx2IT+Z6HHZn2PJGTtFCDMF9v41q9D1XPY=;
	b=6wfnQCpFSU8PsWdsN1Rjsi1D3hFwlUGZXSOuy7vL00mfquw9Pa5ozlIfJAat+BmbOGDPOw
	5aN9bqVrNYKgqPELeOmOISblZRjh3d2yw69UHwrOQcJHY1jr+GYdZ61Bqw9SSJS4Q22iJJ
	uiTvXsvB/bRxTeaZeBHm/98QXY+PRRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759877570; a=rsa-sha256;
	cv=none;
	b=5o3bNDB+6cnpye1OY5jZRso0x9ygl2JlHfSlo7EWti+tvCgHBZMiuVvqfWfKyH+1YcGn+P
	i5Mt/eFq427mMGMlDQZW9qG7R1rrbP1hd00j2ig5dmZcfPbJCVEgHl/FK0hFWP/sJzgHcZ
	wcmT/fPXif+R13hV9OhTLigVpyB1W5I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ainll35Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3f0ae439bc3so3205478f8f.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 15:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759877569; x=1760482369; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0RpARBk/VGx2IT+Z6HHZn2PJGTtFCDMF9v41q9D1XPY=;
        b=ainll35ZnwXpl4T99Y4xdOwM56f3RFSjLCRvm8Xb08Us8nRb1tn2VUYxM8HIqgETQ3
         9zyKn7Oq8c6QjPJTDsynhp64hD5ECFVkDTL9V+0vaRFhA6VmBqnkywmp30pf3mUdZspB
         TURX3IEmXYvvC/DKc29sWgKX39Tp/4iaO0Yw3aQuy0znHn2xXcU0wEgHgSrFLGDdqoM7
         xEU2RmZkgrTPfhIkYTur3Getp6v8cOjH/fu8S2VVIWDzk1DMeKyqcRzQpZN0KMUeyCTV
         qDlvD0h5JsauU7yzUZuaU5HFT0mt6uLiyws4rneWgY/aB+fx1Z9u9Nk5mzpgmo7QdUSt
         LxVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759877569; x=1760482369;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0RpARBk/VGx2IT+Z6HHZn2PJGTtFCDMF9v41q9D1XPY=;
        b=L53CrLMq3f2cpA1MgG/fIcL02IQFrlVMXIj0VQERqYEQWrzNC0ja7XQ7SFr25Ruvvn
         PEZ8anb1j+yd9TcXD1cNHS6K0bvM0gIRTbtyT/WNwSvbmUjB4LU76raFELP+w5WuApj3
         4AfCybSyT2xaQLH41yhM4mTWnqxTI2A2LXcM6OaAg/0Y9E4KiKUn7y2OSpSuDzbl8Dqf
         fN9gklD2Wlnk4FgFOb3K7wnztkspgfWCEATyaB8b5HDn0nW+z1CQJuUp2GQ7RUO1yEao
         KpzPWg3ETGFePIs231uLRusQcwmGWD1kDEyj/k5kZfquQNg/4rfN2Me8BZas6osKsg7G
         OeOg==
X-Forwarded-Encrypted: i=1; AJvYcCUyB9YQGSr0fzjWiTyVJI+KEVdZtkvUAdh6EtfOYh+p5IHI2FXMwaTGsw5kVYQp8LQ7YYJEss+f8g==@kvack.org
X-Gm-Message-State: AOJu0YwHMOvxg3vyUp1Kuj2dWJ/aW43/nIHwXfNBRKexHQbKIBI3gn/o
	4z1qD+v770pChWo1Erx1u3GHtGyrWjE+jAgdsyivo0Ug6NqBj78dkPeZ
X-Gm-Gg: ASbGncs1T2PzRMtkeD1tNscTNryCw0o+fY3fQt2Li5Y6H7fpavNWxFP3kItqcmZPszR
	1oq4Rpec9sx8Xh+plstpThaqD7eQi2RM7sBG06aSXeeIdFHHrfaMkyaTC1XZqbSNNeio+eFbN9+
	GGRE3QpaUaa3mMe7xWHq95xVvPieiVq3wLv6KSEYqkFnUwVxt3wg5VLi2rowbx3zsnTfL3G3N9L
	tvNf2MkM5bHVR/Dv0dbF5o/tzQt6D5W581UT4KWtk7s3Akk3sipZju3zsJ25ZDnT8uAVv/2qyE7
	y/4hP83AnZ3epTiSGgAFiGJQmKZ1f9OiqTnY/rdtngqDTL36KdNzXa+9Y6zd0gQ4WENkYpBpMH/
	HtofYbShpI1pdSu4HbQmTbybISkPqm7ATFr5SdnX733ygDX/r7eBsU/mFz4Xx9JRiQJvbvmy1kI
	zWAG+l9DtXxQzVXOn+x/NQ2bz9lf0AiXqlRkNQE+ex/Q==
X-Google-Smtp-Source: AGHT+IEOP0KMn3yulmSLAsD1ntkNExuQaCcYwzis5uWiYSN7Izw6YtqSHSliek9+xL4bNXYcORcUkQ==
X-Received: by 2002:a5d:5887:0:b0:425:7591:7072 with SMTP id ffacd0b85a97d-4265ef60236mr527285f8f.0.1759877568861;
        Tue, 07 Oct 2025 15:52:48 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5? ([2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d6269asm10726435e9.15.2025.10.07.15.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 15:52:47 -0700 (PDT)
Message-ID: <09689e62-a8bd-4822-84ba-0f72f94fed52@gmail.com>
Date: Tue, 7 Oct 2025 23:52:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: allow overcommitting gigantic hugepages
Content-Language: en-GB
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com, kas@kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Shakeel Butt <shakeel.butt@linux.dev>
References: <20251006185607.3257340-1-usamaarif642@gmail.com>
 <20251007152429.4c28fb85205635703229b027@linux-foundation.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20251007152429.4c28fb85205635703229b027@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A77F9160008
X-Rspamd-Server: rspam02
X-Stat-Signature: qbrkn4jwctm91wsjgg366q7snhm5kipd
X-HE-Tag: 1759877570-872623
X-HE-Meta: U2FsdGVkX18nK5HuLRkE2uel70PwPYaWwrVDhB4gYKKS87Qlvz00p13g64ruKT9hKGdPM967QOu81cA0nOyQ83aiP8mZuuh7cYSeNQEdgHl9j/wp/a8rgzicSR5TgDMjo4/kbzOFadcG8BfwCU1Q0jsq9DK4QdESzBbkMn09jOlCtPIcjO4Nmh3nP4JfvZwjs6sQqul20fLnEWvD7fTwztfkO14sged2TDg5nQsKpUX4WpXzHUG+eLZeY8YBxhi79IpK2LY96jaz/xihzyxz5Xk8zpS7DTQUbYQDZJpIHdoz3L3hDtYbu/lmqPbgcDTeZgV/8KHHsB1dYbYW8aE6WmwlxdmNbAIsdOt1wS9Z+j2xeR/MYj5mD6LgrkI1/lxHgIazRERA2tNvxCMV6ljJDyCPoJqcQdJUTATLaRlS6mKzBqTC3yR6zdruLp3m+ppsV6IvE9qjCPQAa7H0gYPXiUs7ODi2ly+CnoUXdfJDEkXSd0N5hJsXzfj8eQjEYAh6EJXoZFATfxNgy8I3IMNLFydRUssMmy93eztk3+Aku6eT1jfy/adu+Xuuk0Y0oA0GqiOIjQ8EM/Via32Zr502vpzNc2LGbyo9RgXCtl9r6th5tDkFxR+wyZuP214BW0eB4j8SsaZ5YaPMRhcS8pq8fS3Y1eFasChDYyoQihSLbuNoQNTVykFL1NBzNQrQw417rsfJBfQqub1nW9KXj87CXb3nLBqX7F+VgVo7FuHHF80LttfFzXRujwJb2Ivkm/Mn1x3UKZnbAJ39/wgeKRhNZYjO8PhvuAHSkWyWbwloaeaijVloE87tsZKdhFaRbhDOLzrTx9NWQuA7p1hw3Dbe5JRykdLybWo+K75KRuM61E42FTR9HsACPKUY9N7BXjll/+LauT9sMX7omKe4Ns7cDjeFn4sTbTs39zWK/BcgmxYUe/b5reNVW4x9yTgjcZNTuIKpi5RnUPRcOBmJ9MX
 NZ8zZJKm
 HJ92MCyC96eC4+eU1pZ8+/1hwl/ZDAIuk7EkISZguLX56MT32g9g0gv1v3OBPFUMdCF3Ghns573b/vWdew+54xUEb4B8LoUqTdhbvk+pZjZPM9SOhqhT+PFsgwwq6nFyZaR7q/233dYN8g25Jq0jxH/ZuwdE5wW1QuonN+XEGn6vy5s2jYCy0O0U21dtfbfhrdwsKpHI5ttOYllpBIfGJels8LrHfk6Gx0Q0kNe/glsn66HTNsYKNzS30Z8TdgFbrtq8DCo3DSjcDSpaI7UpgxkXFj5dBPNx2ZI1b/JVw4pg5Q95vDiV3D8F9HSfBxeQ6+a1xNz4eS7r1h7JhUymQYQrhSOiLCJpa8OIoYSvGgvMiRHDzUKLTMIoTamzF992ZTOMSRHxSRHJELnrIKr00NbCF9Ig99h5HNYnSOF4GLPFWVH0SN7dnW1yjpmgX188wZsU1qXVLiTJcqLdgwBoln886sHUiVAJyoCBvyjJqhnNqujVqdD6Fco8bVVL5hlDqsSKqm5av9OEXB2sa+5xbzUuICioRe9xZBZ4XKbcK3ZsVgdE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/10/2025 23:24, Andrew Morton wrote:
> On Mon,  6 Oct 2025 19:56:07 +0100 Usama Arif <usamaarif642@gmail.com> wrote:
> 
>> Currently, gigantic hugepages cannot use the overcommit mechanism
>> (nr_overcommit_hugepages), forcing users to permanently reserve memory via
>> nr_hugepages even when pages might not be actively used.
>>
> 
> Why did we do that?  Just an oversight?

I believe this restriction was added in 2011 [1], which was before there was support for reserving
1G hugepages at runtime. Once that was added, I think we forgot to remove this restriction.

[1] https://git.zx2c4.com/linux-rng/commit/mm/hugetlb.c?id=adbe8726dc2a3805630d517270db17e3af86e526


> 
>> -	if (hstate_is_gigantic(h))
>> +	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> 
>> -	if (hstate_is_gigantic(h))
>> +	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> 
>> -	if (write && hstate_is_gigantic(h))
>> +	if (write && hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> 
> Maybe a little helper for this?
> 
> (Little helpers are nice sites for code comments!)

Will add this in the next revision, Along with a paragraph about the history
of why this restriction existed in the first place.

Thanks for the review!
Usama


