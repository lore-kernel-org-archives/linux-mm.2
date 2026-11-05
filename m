Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F52F606D805
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 01:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=erKhzqWK
Received: by kanga.kvack.org (Postfix)
	id 27CD76B05B0; Wed,  4 Nov 2026 20:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22DA16B05B1; Wed,  4 Nov 2026 20:45:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E9B6B05B2; Wed,  4 Nov 2026 20:45:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBDF26B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:45:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0D6AA8567
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:45:18 +0000 (UTC)
X-FDA: 85399372716.05.F36DF13
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 24887100005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:45:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=erKhzqWK;
	spf=pass (imf14.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793843117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aw1j/DMSrkeRfjbyviCP/rue4/RfxPKGIkftd8fC4p8=;
	b=dQpIOH6MEim56VbM0x2TeexPq+zlA6k6js9inJr60uJ3DAoqYVIdpIAlTQgHXpDKJ7YTmN
	cqPz3oY7ZT6GOodwVNg6BvkZ1u8AqnoPeITDmkYzqG2L1CAbSzcC3UlZ/iTpkNTQkv3hb5
	QDQeCTbObk9z3kUTaQ9+wQQoHaVDsKI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793843117;
	b=BJrccIjVB/7LhvBWS7XT+nnDFNWXtE+R9J2HIZbalHuo5Z1ckLafV+rrfh0GYSaXGsUt5Y
	adaKcgHUsFtLFJH5UGKd9AF/qlxChFcDKKIAODoscuzcBuz0In5bm/YG2kbfg5Wa757Vcf
	lTLp+WHFUJcTFqlzaXM+ucmC/F6y0kY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=erKhzqWK;
	spf=pass (imf14.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so923140a91.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 17:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793843116; x=1794447916; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aw1j/DMSrkeRfjbyviCP/rue4/RfxPKGIkftd8fC4p8=;
        b=erKhzqWKp+abzSicIgmHVRSMN3Fw515nD/eUOE8ii5rs+Tva8vRGNBjdP0EHBRJ9o6
         Q2gcfgaZfpKazWi6qkKJxujopLRXx+ehHzwh8Uw/kH5yxUmGmKUnVftLMS7qURJdAm6E
         c1HfjSWmjGBPle+Xw0a1uecAYDH9iu0yzeyXTaKoDx1VnL03ZZfFlQVu9gMrtdNoLQKX
         +Jiez27E2VhyggVEtvTSvTcTQTa9DkadbpHMi0vICMRJUNQonTsGsoy/9NunVkx3ZveD
         In7Xj6mEJf5TQ16CDTiNjNrmTA/Dbm8fgH2bE+CdHjBZSumDDRB7t5pTpu2wrhZxX/kL
         jO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793843116; x=1794447916;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aw1j/DMSrkeRfjbyviCP/rue4/RfxPKGIkftd8fC4p8=;
        b=Autl9DY9KX0++XYNOYMhPoaGTD7THatN0a1tN+B0UWINeKL2KAD5rb7OsL98apzo+N
         YTafi+D+kaLS5uq07tTiWvoEe+eESgRLUf+dOwhL/EAQCkW4JCDrMxeU8LqbN1+FhrBH
         w+eHBhGQePJbK0ERcfTEabR1dl1O9zwbMyUTXYAjn4ClKzIJAy2EmbW0vPF29HDxld+7
         XWi7kPB91ty7zIqWo/Eoe/hejMep6gkIei4ny5I7gKxed+II7s78vPonIU7WLCpf8LKj
         ccEFjn6h+TfDER3e0Fg4SXvnOzFFIdSHUmywOSGFyosonlEY5j2hYBQtTtvSPbDMT3dR
         ghKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzDwhi8qWIRmHuUmJX6MMh9J9cjfNjW/a26EsXB+zezRIpz9x2mNJGozt8fSBwA8Jn6cC3lvlpIQw==@kvack.org
X-Gm-Message-State: APuU4Z9iFpTOjMt2wfRiEu6TTmJSmcVYKDwH8Zgm6VLWt9hfwZwhh5Ar
	IWMF2aIdtjB5oP/LAgKmDf8u69DFjSh4MlTj3Y+BZbwcVw8huMPMZx+H
X-Gm-Gg: AYBFou2gUc0UwanLsXD4rRIsOO9lRNBA+3Va9U/u3PzHm5IuM9ap9GDiAlyIVLm3JgN
	fCoT5FG5YP/set6wmRpfHDD6wRyMb2oXy2EwdcYftwIjzTljtiEG0fx/+4ul74f3Mpw7WDBZ/PQ
	mgOonmXzEqJeOwNUrDrxWPEeAhF7M+gWrrmmp89P9J2888rNxJ0t/rS9yxf0N3oCCQd1CNfOacX
	NEeKdUP9aWtWSHD9eArPjQFCYeDvXBBR4hrpZWC9hAO+qtSEBxFMWIWMgQY/0VLwtFRrta/S1j4
	Q7oe4fkkzjlF7LK8sqMUv7BvQ7fGTaQFt9MIGsd1yHGq+EjKdcGdD/rR1lni/e/RyvOxJ0XXQFe
	qac3DPaThCyaFSpvHeUwv5uXF439l+V6FNa1Bdgs9IBhbJw9oluRFbX5Xr+lVpEVxqii8b3Dvbn
	/J9HuHgNdNcf03mVzqPGZMikx0fgZ4UsBEQW1JMI2WoLZa4IfgbiROSJTZ/Xy0wxvsuCt/5BW00
	it69SIWJ4on6QMBvyMrZg45wxQO5qADDISGi6IMH2bIARlCY5fxTUza5dE5KcV4troJMXCSBJBD
	s82GInKMMcQbhpD52sZZNFSekulLV8w1GvTw+Db5nhbQriWdMw9/KgKzuM3vmCl5AoLy7Ds7hUt
	tq5DX6AUMMUxPSZpMT5UFK/lbyg==
X-Received: by 2002:a17:90b:2f08:b0:3ad:50a2:9abf with SMTP id 98e67ed59e1d1-3ae89835db3mr14659660a91.38.1793843115728;
        Wed, 04 Nov 2026 17:45:15 -0800 (PST)
Received: from [192.168.52.49] (ec2-13-158-86-59.ap-northeast-1.compute.amazonaws.com. [13.158.86.59])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b3131f8csm1307297a91.2.2026.11.04.17.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 17:45:15 -0800 (PST)
Message-ID: <0ee661a9-b642-424f-99a1-21c9731c53aa@gmail.com>
Date: Thu, 5 Nov 2026 09:45:10 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/core: reject empty access pattern intervals on
 scheme commit
To: SJ Park <sj@kernel.org>
Cc: jm5905938@gmail.com, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, error27@gmail.com, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 "Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>
References: <20261105013653.88123-1-sj@kernel.org>
From: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
In-Reply-To: <20261105013653.88123-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 54e4t5j9y6e8u7uzrg4pjaxtty1hgmnk
X-Rspamd-Queue-Id: 24887100005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793843116-566736
X-HE-Meta: U2FsdGVkX18IZETRrxJcrRIcTTfN40qRwig4v3sKHnROTevcyFVcSbgPq9Z2VodozB0ULMguL9ogn0fy9l+XLjthCYSVagQID/YGA8XmlGW6hTx3r/41SYD8RWXrh2tSjKwpYrNPU+7gPn7imZy7EXqnqviGedo8zJCcl6uMNzFrZlboBMw6Z9zTSDaTZNXtOh9LzdHdsaLJHg+8xIAibnPYWKmo9t1Fkwr9mRI5x8e7JMCmZ1bcsDdEJQEBLqae2aDS7v1kCpRwJzbUAMs+uAa0F1cY5PA3K+otVNHUrUVxsjRoHJk4kCZNHCqH7TPNqP1+kaKv5AXe2FAstWMCtqn2bsKz1ILWQHubumlHTltumv0p3qd5h0nxbwYl+vnPNGnnr0CfefMIGXSigVybywfAvJcaB+tLOcO+vt8HEIjAqjSQ/So+k26yuXA1qhla5YOR4a0sr+xKUEb7nz5wmvVZVD1Vdq5t3cO762nAyiF5KNYptO3q7Ur1pfSiwLKPb7318M1da2ddQK52tNwZ9ByGxfhDFegbIWtOjR6CT5Y3iV9cDEoP588cT7XXtUQkz1f9x5xeUT2Gr6ZGAdjTQgzru9nHqNLUMVOhwyzwW82eRpbm3cYbKPHErbNffR9Ejq9o7dP93VpEpekerCeHg+P2Vuo7WNoiX1DcdQgsg/2RTbBwx+BOMEZNcXyqkklYPsBdGxFdrN8DamvRPn5BpKYXRikfW46hTbwB1W4yz9jUpPSfkPLGnPCXUSq8r4T+vmhFpaNWzS4BGbFE65+AQvlqZCQaHr9TnEDn1zdmB86a5CFxdsp3uMaZbR+oNH2n7fzxLc82MFpb+aLL9szYTUXiLjivy3iZFjPa3rP6TxHCIeUQ6SntH+i6IkgVCFM7DNgsJcfd08DWmJ3zAOhX97Wq3CJk4lGvhS3efwdj4SFPXsWEVGiDAPdSZI3XI8xwZUV3GqTjcCCF8X52EOT
 HunVE5po
 Zo3uO0zusbuYreU4+3zkkHvWJ1/e0AakT/7HZrLOKT6xw4mwjd1+Owt6ri9VnYR4P7ia0QkyKZZ9+JmJqCzlspgrrdXF/p4wZjixA8bC18ys/iN/WpxkruSzX8M9p9Q3N2Be/pp9vQITl82vMMpairbR5rDPHganvevvS+SuR5SteH14WazBRwjwD30EbSZlkQt/E9nLYBwQ0HECCe8zM1nWcWg6dAQ/P4q0EHWgP4R/bkSvxu3Iad2/TMKxPxegUinacR8qEJ/dsURycm5OQHWH0GVhni2JMkZez0sW04byj53L3zyYmcjsLNouy+Qcjqf7Yl7CRS8i7oHz+85m+UrF+iBbArEgHSwYrNHdeEH8ViSgGyoSUipqLr0C41gKLVAbQtY/y4OD8l7+uPXynRu/zTOgaogq+88YEZr1trG0Fw92CBtuTu+ujI0V0lKtnPB540ze7DV+f1W/JRG4NZ6fg8FCiuJNtsBYtTSZV7mVIVR9jGf2jU/wKMBoG1nJQ/6+x9ZrHeJo6zcRKBAQX6ArSMExnwlX2Nf4VqPDnJFZmeLLwrwmqJz9zdNgjreGflm9JaGr7pmek5dQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/11/5 9:36, SJ Park 写道:
> On Wed, 4 Nov 2026 09:17:24 +0800 Wang Xiaolei <xiaoleiwangxiaolei@gmail.com> wrote:
>
>> Hi SeongJae and Aveline
>>
>>    Thank you both for the careful review.
>>
>> I appreciate the clarification that DAMON simply executes what
>>
>>    the user configured, and that this is more of an input validation
>>
>> improvement than a bug fix. Perhaps I was too aggressive in framing
>>
>> it as a bug.
> Thank you for clarifying.  But my point is that this change might be just
> unnecessary behavior change rather than an improvement.  What do you think?
Hi SeongJae

Thank you again for the clear explanation.

I agree with you . My earlier framing was wrong;

I won't push this patch further. Let me focus on the

other items that are genuine bugs instead.

thanks

xiaolei

>
>
> Thanks,
> SJ
>
> [...]

