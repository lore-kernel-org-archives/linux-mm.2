Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17275CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711258E0005; Fri,  7 Nov 2025 11:59:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1F58E0002; Fri,  7 Nov 2025 11:59:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1948E0005; Fri,  7 Nov 2025 11:59:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4681D8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:59:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B90E1160559
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:59:05 +0000 (UTC)
X-FDA: 84084421050.13.FEBA394
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id A5C2D40008
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:59:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/tN2mim";
	spf=pass (imf07.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762534743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4sd5p9K6Q7d7iLpd9Xn8vyRDq9SyY6gsIqiEGANBmA=;
	b=T9aMhWf93PkLRW/a6Pfw/pbG6wcE36bnfRq89pMRc1POkQHU7vGvwrNZcPqZKgJzi8sJh+
	lJWBxb2BELUErlHLe9uadrvWnPCV6jaB2wNq2uOwMvwwUAg04o9DbD94zD2O675IyEbE1y
	D+ZFq3oU1sKAYgQUkJdfNJ30VIobIoE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762534743; a=rsa-sha256;
	cv=none;
	b=0ufhHyIRyRYFAbppcKXdG/Ba4ePBGFK5fb/J5A+cl4+7KapqegfmvmFslilkp0n4hhZ5Oj
	WFCE8NcBKM+ZF08/fpZhyRRaukVx+YxPF0BZVvkHn0oUR1hrL8AbcqZBEEMhAFl0Gcbqj4
	049RDRTRISMF3PI8xlAda/r+vIYIZn4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/tN2mim";
	spf=pass (imf07.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34182b1c64bso665837a91.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 08:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762534742; x=1763139542; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t4sd5p9K6Q7d7iLpd9Xn8vyRDq9SyY6gsIqiEGANBmA=;
        b=M/tN2mimT186dJ3yP5Zf+ICd1e6Ot53jkzSo9vx1XX4RsJq4g1YGJImvxaH7HEDoIj
         437iVPSv/IupgdhRaIvRD61sU3tKVOj+EACIJpbMatfCFqkrPc5OUvixLhxFBaRZ27Al
         3KW8YcPR2VbgF7aTTYq1I3DW8mczqqK0XYROClZVXZv25AD12bux+ZJ+9HPqiGJ+vZjb
         N+MvaWqXreJZWUksnNvQLHSHaGF8GAim8aJoggoo7KVrUSmn2zDrQitTce9eNtcuNTxh
         81k9zi0vfXkvurN1pUMDlD1Xczoq+8mhFot+13yj50qbZd/SKPsYln9cUnUBa9a3KLOs
         ittQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762534742; x=1763139542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t4sd5p9K6Q7d7iLpd9Xn8vyRDq9SyY6gsIqiEGANBmA=;
        b=NTgyMnLOKbpqP/dajlpQIerPrqIt2B7+fM4pAGfw5oXdnZ47O0Un/0dVhSol1UQ2Py
         7i7d0YtHDTSl9p+3Yn25T3Exus80z151oep8DyFUqxc4gFzOE9PkY20j8LPpO4EUvYuZ
         dLFsr9CpF4NEctmtchm2rIZCYyh3Odi6CBp9WdPYQFKhonV49ig/iEqdt0Ghp60hkFmd
         keBkH1b5kM4N5pAir1cEwwFyQFal2x+QB6n7BHVeDDtXXgIQySF2iT62GOeXlUoXVslN
         UnjFE76Qz3ui6xzlsw3+QKcLt56uRICQ/kCUUybpDAzTibQVq2/CjR8hx3oBKITfCYN3
         wX/A==
X-Forwarded-Encrypted: i=1; AJvYcCVybeQhN/NxIpZLLxsn5B2QtDxz3ZggTi0FflqausliAp5lh1YxbKiL7WWmqhyrjU76LaHbTz5F4g==@kvack.org
X-Gm-Message-State: AOJu0YxOcMJ0wESoQ/gm8C1nDcGv7+dxJT82JohOQkzoTFtGpFWbqusQ
	MgIIaRTLDo4xISObrtGW/m7aie1aLT+KLnJ7+wyFKDo/f538uy5hD4Dz
X-Gm-Gg: ASbGncvasymDRknTaOAMRTVuNjge03i4vmV+cqEBSGS1ZDhexvOLmFE0lUrZORK7vfP
	80/Emz8KtCM2kHFVXd7xYCt0Vgw/4kNaGw3F31WgUkvM09bd8wzMdoh+Ksd0nh+yqiQQKVCs+uF
	V+JnlWNVy5FXJZTQndA2h3QD8TNihqn/gUkj2AsRoBlB+GDjPXy5ErfIq5y08H5YSTx9jlroMG4
	eYHntCHMpxeJOm0H5/OoO90CGO+/nmKs3cv6hvQZ7FoMQffBXnNYHnvgwL36kq9L+wJvsmmZ3iX
	Rir6QBZK8BoeBvrS7GEtKWvh1dhP3l6lxWfxaB27IFq9OjLQ+QhQVfx+w6CH0LehU+6OApfmWlq
	Zi1mkm6l2wOjNXHu43M5uspAaTSw6iwXAMStejJDXHuS+j9OOee7+6j702TVfdcANRszq25ney5
	FjmSGhxEruvLPrjDtK3OphkeeTvQd9lD+W
X-Google-Smtp-Source: AGHT+IHMVwIIf/5HSM26FvAI00bqSm2Te209tly41PcGS5bZmMWGwjGv3U8TNmpLDYqzMgZOpWO5tg==
X-Received: by 2002:a17:90b:2547:b0:340:ecad:414 with SMTP id 98e67ed59e1d1-3434c575537mr4058720a91.27.1762534742462;
        Fri, 07 Nov 2025 08:59:02 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341a67e2f82sm10072766a91.0.2025.11.07.08.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 08:59:01 -0800 (PST)
Date: Fri, 7 Nov 2025 08:58:59 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Kevin Brodsky <kevin.brodsky@arm.com>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*()
 about HIGHMEM
Message-ID: <aQ4lU02gPNCO9eXB@fedora>
References: <20251107095922.3106390-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107095922.3106390-1-chenhuacai@loongson.cn>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A5C2D40008
X-Stat-Signature: 39t7rjcre4yzw3t7uupjs3iqkz6xxkg4
X-HE-Tag: 1762534743-831590
X-HE-Meta: U2FsdGVkX19R3xp/roHILvDn0aBNOvn9qFnMUlrR54+nUCEKJhTiaT8+pKlMsdwOk8nuR7wXJDu02fAHOkIXBhro0NAJMEO2+ktOCaf7drwtvI1MEtKopoquyTJwhfOwUd2JK892rIw86NuPArYLDVKS0D4UImg63nD+H0JwvIE8tcivE1v1YLV+mIy/ij0fYRnxeku4x/0JR1aEmabPMWWJtuUxYiDwIgJ5zkwzB8vF8s9fLdulilsDGh29bnajBw8l5Wem6Z31xHPFXczhUtBKN8rz9jYOypIMIJVGag7TtgHxLLYEoZYk5bjNqWQaC1yOw5zBz/9Dhb5RB4YvgcUq/uyremyjgmWVTq4YuByRBh3tE6dKSskQ/GCA7HQWeBKGGwIl2sqa5VrIyOGejjgZEQOkjHztEE6AwsHmsWPNg1DL2wSDLEHfJD1S2NrJvpFVnEztq6J57xAiXxcE5HS2c2jkY6QEMS5X/MzAvnziGXBfXe9Puld/WDsjx98G+VOXrJ1J8WYCXnvNlHQYslv6lfG+Ybs3boGWDCYt2XQD7PVoSo2ww/aIDruSYt+jE99LsI1J86fvbM8wgQFYeT3awBaDBcNoRyThv6wqhdCD/lfhrnYiiUxxuYUpYtA/J8OACBBH77CwLvmGa3OVVsh33mqOnyMOuQ3pTgdktpsqbk7rr6DCpnLcER+BalF24+4jgRlVrMpcZW6n84okMq58rIPBYEwTBZKnR74cR3dLQ+/0T5ufUoJI/89Wx2x+nGqKX2BRW10NhloEAF0rEk7BP1kymaebytUlhCsTvCjOZP1vn3CYyg97EAm+0KtNVwT1Q8b4S4xKoA4PmvvRhiTmFpL1d2eiKTBqwOKTjYn+HC6HumY/es8tVZo/cV7KK9/Zt0loyImUm6Ueuc20wkTioEg5/X5eSXaWOqJimU2zlaJhOZ1VQRx0j9KZ/qkG7241kTwBSkLu3Jm8AJF
 LcWuYVj+
 00y8CZ//DrtvBXisbfBiSMEYItd/y+VtnttT3qJZeAlTGDXMkAqtV3WUnNuh0njbQB9Uk+wBnkANfJfzEnjENorLJAoudMz+VOv9JY93+aQSNTrJKJHPlmzwkmBS4aZy3XWZCcyWykHh6+JalnJVSR71S3v2VDx+2SZ2kNVdBSHpL94moy8J2JCj0OBYLg1kfwQ/2lVYg2xNPlH+2bc6yspA3IyxoWNVxjXMnABfTPZicrSadlwxU9u7crk6Rf4KV7ZP+Ev02gvS9nA6hHAI2qDnMCUt/awcbyDRbY98QjSNY2UN9JLqAnRcVWSpMVE4sI8TXK63FiQu+h5EG/MMH+pvE+tMXhygksgLr7f1wfTDXNWZ81qFN4ghVm4wbcli5ctYUiWFkVU6uGyi7UWR0c9RdCmBnXwmxhBCglAfuFGZ+NbLHy2q+KolmYQ2aNaXe4uUx2nRkcREpLjdcr/J7UyDeTrgacWxSi5Re7kfGht/80f3cyOH6A1GPFfBxcAD4wO2S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 05:59:22PM +0800, Huacai Chen wrote:
> __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> as follows:
> 
>  #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
>  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
> 
> There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
> explicitly.
> 
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---

I'm not really sure what "Refine ... about HIGHMEM" is supposed to mean.
Might it be clearer to title this something like "Remove unnecessary
highmem in ..."?

