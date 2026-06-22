Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0BFDCDB470
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 12:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE63A6B0088; Mon, 22 Jun 2026 08:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A974F6B008A; Mon, 22 Jun 2026 08:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987D36B008C; Mon, 22 Jun 2026 08:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 742B16B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:52:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0336C1C01BD
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:52:41 +0000 (UTC)
X-FDA: 84907537764.25.C2342AA
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 067A2140002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:52:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="AVb/qhwl";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782132760;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TkQhP0uWUVoXEcgVjZA91Kv5N2KnxefpO2wbntWaF0=;
	b=UPKU1QaeHCUfD4+quGYRQw3Ly7P316gwN6P5bYAyZvo+VDKVLDN6T7aDoCM2+N661YiX1S
	f8QdvHOcO7E5TmLcP5JMOOdBqEVmRY7wKswP1fyGPsmpZsrTRTcTNsCCAcSPe8i6PH8i/X
	2mCSlLvFgg2kqc1/rK4Hti11iprK144=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="AVb/qhwl";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782132760;
	b=fXVdHSVDNz9N+p1SqbjY6LmT2scW/0k/GCWk7PgOqfNCz7vMdndrNfcYmxOduCPY6dA2xN
	EyhLLneIqqbUbmmXI2QgcyjiW0KFwPS5UFYv5aktUTAAsHOLNtCO78M5z0TlcISC5sSS+k
	bO6N+bwbnAyXOIjPvmuONv3rjD1Y1/Q=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so678725566b.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782132758; x=1782737558; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TkQhP0uWUVoXEcgVjZA91Kv5N2KnxefpO2wbntWaF0=;
        b=AVb/qhwlNIDipUbRx6IaseatuGFuKAIv/bwEGw4LFcvykOBNqrC48JTh55QpKSCk/u
         5RvBwABDQIS8/kmWCXkmeb9Ylhpwf0HehjclKzjgOX2mInHQHN9O9P7aUoQy4XHPg2nW
         QIIEPi9OGgPB8PrD6St/fpLiJfn+9iwA5fu/grrMnWZ2lK4Ogyg95tfrMiqarqNn0QCO
         oHIryqiZp4vxLyQbmWJpwsJ0x025W98norCI/uusMZ2/c5MiT9VLrov4xhuAJFFSNisp
         iGC7WbyJHG2MstT9KPH8FedGcBdLrvduNbSnXqiRJuRuGMLc5xHeHHJYDeCWfr7/WlSh
         6h3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782132758; x=1782737558;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6TkQhP0uWUVoXEcgVjZA91Kv5N2KnxefpO2wbntWaF0=;
        b=Kn71LE2pm7ggLuRxnRmK63AVD/NHze1Tguv6ugjO5kNTKXD90jk5gWh0fpjuhIixcr
         9TN1GICoZ3x0uqpv87/aGYacaw35RQKY3Ctrr9Afr2q3TiGa8Ua8Hffid+0kkZo5/3q6
         CnFxSa7yQcDYAmNzDGSS2PS1KufQPKqEq8jits1YYLkSLmbQ/VVl7WmFd8T21bnszB4x
         Qd4fwEJ2YZJX/oFyoeuMHi+siCAQDZpmrXpSzTv8aAH4FFLto4IASm66gj9hWBvAWjNJ
         2QejK9+Uoa3N7xIo8h8g0u0F8yif01sFUrBgCfMOgxkYict+90Y36WBNEiOoVjiGTYfj
         yj5Q==
X-Forwarded-Encrypted: i=1; AFNElJ8M1IxcQo3UhD+bH6JhI5K52/X0nW3vHNqOKvj4LG3cdyLGjolWITPpmbMKHGPqdh8ywCCMWr/K+A==@kvack.org
X-Gm-Message-State: AOJu0YyJFBurfJsFey01w0TY5o836kHsWJi3URoFf1jZbqnKcNR3Gef9
	m1UA+D7HsVzNjnAO88MrdYQ5cVKJ4vVxxyzIoq6FWyOmf9gMFEFZd7WR
X-Gm-Gg: AfdE7cl00qlAIObrB0hZXlwvl6HzjqbDUBfhPkl2OQAQDYhh7o05yDhoxYRNL1wdqa3
	y+hRB9JFoUuV86/+CyAeysSUcvcsLlFMxG7g48vQwhmfkO7L3BFoPyASMkK8/Hv8j2d/UK5ZdPK
	0QRByBT9KcTH7+nZC2+I9gHTCladQRY9t87a3BWcHNKcrbKfWYsdeq5bLq/1SOS4MKcrJSNUZQJ
	hfVB2MFYLcxpukv6xsexeHRdS7CoHKZsUQSJH4q9MllWXjlytiD679vJ6nXfL8RJ8vn8j8nO0n0
	wOc3KPCqFgRwxkUl9+76DralpSq+ze3Z07oH4wDtk/Cz7JZ4iH9HVdlooOtUOfaqHIzpZmGagfg
	bFFzmt8SIke8U5pGbDeSSBj0Mh82zcAURq+57s3XtbLq3Vb453L7dSOBof3YpgYkquBjCwL26+b
	/AtVSAsaRYoYs=
X-Received: by 2002:a17:907:940e:b0:c08:580e:899a with SMTP id a640c23a62f3a-c09b7b99854mr653419266b.10.1782132758077;
        Mon, 22 Jun 2026 05:52:38 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5e49a9fbsm354825066b.12.2026.06.22.05.52.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jun 2026 05:52:37 -0700 (PDT)
Date: Mon, 22 Jun 2026 12:52:36 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
	akpm@linux-foundation.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	balbirs@nvidia.com, ziy@nvidia.com, sj@kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260622125236.c7uqapdqn4bybvvp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260616063436.20455-1-richard.weiyang@gmail.com>
 <ajUXNjRMraKb6k2n@lucifer>
 <5e7f7fe5-221a-4fca-aa76-297ae19eb80d@kernel.org>
 <20260620021353.nn7xp2ldqachq7gp@master>
 <35b8dea6-3f0e-4e95-bbcc-bb778e567d20@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35b8dea6-3f0e-4e95-bbcc-bb778e567d20@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 067A2140002
X-Stat-Signature: 5szseuk4r87d9gyrwwzb7sndxnn41uig
X-Rspam-User: 
X-HE-Tag: 1782132759-511582
X-HE-Meta: U2FsdGVkX19Xk9Ih8ydOzPUYw9cSbGMmgwwrZ9jfZomaVKwijfN9RmoB+VHFSJ2/kkhtX+RvGb++4gHqHyNUdFNUJVwxIa6qHz7/r+oKQmCkUnckV/9AnxFlMW39sSom1I/tweKSg6bSAzQNijDkxOoWw1CJKlG4AouN/Mvp52+cKKhtYbaKJLO51NqEKzSofHW3jalKhv1QNIzm1xlRV9rZ/EKp7QUTVTbLQk9V1wcK6MALQxZ/WBbLAPVkQMwtnhGnmpo1xIDsQfJNkYgcjgbelNBPtsn3U6Id6DMyXQn1dU4/LYTfyFGwQHcW6deKZQnTo7oGka/6Z7o+UKN1QEh5xhfBHEB/tCJH+13W2XKceViv6SjZtvjFfw8F4jTaxmYFv3QSgQMVb3ef4AycgXYxit58sB4Za0LQWEGWb/g+hO3QsXOtfmjRHZvMQ3/r6pJA42rJvlSRp48fkOtEXcPKTVReUigBO9RKTsGzNlPrmPNm0oiIxwl23/BifV6rUc9qWZTjAMJSv1PTZHUjEEcYuJSI1OQAw/moShf5n1xl+hQvqGb+cnr64D39H1zovF08Xvj0pnaUBjYEKdBCMHA36qexz/R79hBydVm82A4Jg2M9V6FPHVtcAQiQve5Pu5dunwcZAp41S3g4q2vr+cGLTUTfF0Td9zuNfSalX1OQS0I1xz6pRj2UZA9Wrgv3XC+VEAWDuqdmD/06J2YnNyFrPLzAqor3l45y8/3sJ5U5ON67WU1BJqsWoxMw9I4BCDt5fM2KNmO0hIxW5uOZSTFq3y6qu3g7P9OANO/zY87buuYjFDdjS37wpYpqcBkXBXpKnwpH0RFZiouHw4y5OTRY8+Q6i0KAnUehuo6aAD/I5UpmhNjzcFTgbOXz90BYOT3CSDEO3ka5dhX0Nl+zL6XU9TpqLcZ2jbRfy2yzXpfS6UQbCuB/55vkzf/ZkORJfT+IfGBQff5l3zADjuh
 RnKt6QJN
 /+/ZwW+B/Pcvy2w481DcD0XVTadF4rtR87uJ/DlvU3lRtAkVxhvtpkOmmlUX1aw9nxYLllVRinmXvZfq9mOdARYZ55ziyzX/UJVSpPqi7W/QWMRGyh3/txc+pT3W9/I1/A+LvFCatdFCYPMT1tJkHmUn6caIgmfcjP+XM6H4Jw20CNHLlVSf/KvOKoFZ6AyQba0hFSIH4rVyrn7V3GzVr8j3FykAmp3M3AilnvM2AT0kuqgbynhAEFwZgtAb0RL4dL2dyHUSPKwo9EHljcy+hOHVJ+Y3JQTX59q+NN4/X5lrwpljl50zfA0yz6qWypF2t0OQJ2mdPyVZcUFPlOWGUbeHuhLphmMaR9zebjMATK7wyVhodosSgekwURJ002Nk0iVEK4t1kEMIIVU1AR4ihA8EfUdnUn87h5r3GhvGD63bOTOfXweavIamoDKFYChFJJ55gkKaevQ9nj6PSFZW2vuAx7sneo7LzZNRqGpPBJDPVW4cUPPIgzmxR5K7juL8Atc6EEaOPND0IFHvkqt+dzu2j7JZS642QGu8klKmv0eNhzAr2vpxfA2/f9UveYHs2r8f+v/nzoKYo/E9Ojv0DRPJkMQ86pBYp/wUap/NgxNHq9ZkJgb5IF9soWZBmUw9QmJ/s8XyHDl1O7Ao5MLBTRGO7tRAvIpk8BI6nqEIBgiuixVMfKefFdVrRYnX9mjPHRWP3NBMmevD2fNGDuZ0hSRqYRud9VYS3qARp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 01:33:28PM +0200, David Hildenbrand (Arm) wrote:
>> 
>>>
>>> I can then follow up with a proper cleanup.
>>>
>> 
>> I would like to do a followup cleanup for this, may I have this chance?
>
>Let's fix it first and then decide how to proceed with this code here. I get the
>feeling that some more of this code might deserve a cleanup.
>

Sure, I will prepare the fix first.

-- 
Wei Yang
Help you, Help me

