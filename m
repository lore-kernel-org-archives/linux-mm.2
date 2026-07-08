Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D254FC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FE46B0005; Wed,  8 Jul 2026 10:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0A06B0088; Wed,  8 Jul 2026 10:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAEDA6B008C; Wed,  8 Jul 2026 10:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7A76B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:10:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F277DC0666
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:10:40 +0000 (UTC)
X-FDA: 84965795040.30.6B9D415
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1E9C8180005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:10:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jGnRC/tc";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=julianbraha@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519839;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AFwfd7Yn4EH4PNUXJ3nn4zm9f+PLaHGLkpoj3xgsyrM=;
	b=HBfO6yetSTNAq8AStTX9oV7eLkrrqD/+ct8C9KIcBAsYUA11Tn972GIpfP6m1+RBmXGGXa
	1yiSrf3E8u1Iw2DyvgyvHxzz/oY3Q+U2jNZXuFRih08r2hRsCCqfS8pQqX8LFMu5wKoz6B
	A5F0mudMvBMN5LD3+H+jBiLJdnFizKI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jGnRC/tc";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=julianbraha@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519839;
	b=d63/V2Gz8246Ac3KoRyccbr/mAWnJBTXFdxnqT2feIQsaYYisDq613JQHPnbP+SIl23gDW
	23sgmtsqu9mOhHJDeIjkimPyaRDVaNCPByA6LrXybu9uLr0I1p4sYT4a8+YOIGT5u4vhHa
	SjX0Mza3hpjzY+sXpegmzfAurm0b0To=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493bf73ec2aso4261335e9.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 07:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783519837; x=1784124637; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=AFwfd7Yn4EH4PNUXJ3nn4zm9f+PLaHGLkpoj3xgsyrM=;
        b=jGnRC/tc8KJ4aR6VF0+0QrNabceVEiP8XgBvWx8kIT/rBQRk2Puxce+4KKxQM9lYZl
         Li14jHXbBrYM0PQKbv10iKxDvjw0XZZlH2yMTcGGlt+59oNiS7ziu3wtqDgaH1h8936/
         aXhKyYK30GyCxB+7fyMZYrsDYGeqKkULDLH5i3GmUxp+pruXTbvURNdCjnKsNlcRHmgh
         LrEuwcBnGUDy7PK7bYBSA0J/nughrZwqizz1GOtqxokBlUK0WFTLgMM03JJ3/BtaTJh1
         e8/6J6R0baUeALUZqF84GhC+JK0DE6we/cQ6U7iXNSV2NR+BrnLHCNGMD0koOboPps2S
         uE9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783519837; x=1784124637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFwfd7Yn4EH4PNUXJ3nn4zm9f+PLaHGLkpoj3xgsyrM=;
        b=mldo2grgRnRS02BnGv4R5qObpUcKey0vhi1Ie/3+IgwQ9eoEV65jaKiTiMIwemkFlM
         shfh+5It6i/e1zMSp0JjL1fG9h8LRjzoUj4ThD0qlyvwcCIDkkFl+oppE7j2lFWMlUH4
         p9rbuntwS1SZj2VMLiOvrGgAGDWuAaMpv7yzMm2BgY8oODJDy/eFhqUFiGX2nx91kLcu
         ctVpwN4VvphFv4MMJDYMxVvs5+9xxgBCA1uifGqEFQ1saoYG3ZYmxptUBg8lRiv7/baJ
         23VjmqfkvCC5sjGFEG60MJZwOy8QCZxyN6hOqJxWkTq5HeMUZ9XhXwgFU9W1X3DYMkpC
         5o6w==
X-Gm-Message-State: AOJu0Yx7tF6XyIinTG0an5txxSUuOJ14BdxsAEduDVntcgk18dlh2Ucc
	7k3prNbU0iB1RYYZwieKRGOev1HAhW02fhWe74QDY+sDXs1UCe0FkvlI
X-Gm-Gg: AfdE7clicNkat5H01jfc6zrnP2gXxsvWLVqdxikpqxD1/jqCRMl+g43puH1wlY8PN8V
	tx1Kmvfrw1MqYdlCj55Vnquv7fOna4XHoqTQNjpEtKjFbg7oZ14D1nDHLHVR3vwpR1Xq59SUc9u
	jh98ieb7VJvCvN2pjtyN+8AnMBPcMFApnFtaGItqrFQB1h4WhELVZ7M5NhIMzwQyPLkDutv13Ps
	hc9Yj/4cfzM7z30kx/dzVpbIKt/sFdrBkoX7ZWNmjTnT33gAKqXBrFMQOFb247Azt095vPS6JRQ
	uxNkLAnx7ICsQ1+ZZxA1x4LRdfivvAAZCeHHWIXW/XuMEhz3GpgUyKpFVufscybVPn3RStqoU6T
	FvUIE7I3pH2x94lS3NBzuTed9fxTf+oXTklzLhO4Q/cblpInjeXXoWAXIBYMICm8L49lW/QBcMf
	+lz9o6lavyXT/DB3MTf8uWL7jlqpbkH0MFmJ0F7VlNlrP3JKGTFUs4YEoKB2MTsCrfjixm8E6Jq
	CcB+PZW
X-Received: by 2002:a05:600c:3e11:b0:493:df1d:7488 with SMTP id 5b1f17b1804b1-493e6904b5dmr32367975e9.16.1783519837353;
        Wed, 08 Jul 2026 07:10:37 -0700 (PDT)
Received: from [10.128.11.240] (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0fbb410sm145207215e9.12.2026.07.08.07.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 07:10:31 -0700 (PDT)
Message-ID: <4769c44a-4345-4015-afd8-1bba2474d81e@gmail.com>
Date: Wed, 8 Jul 2026 15:10:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/kconfig: Drop redundant memory hotplug dependencies
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260707090331.52971-1-kaitao.cheng@linux.dev>
Content-Language: en-US
From: Julian Braha <julianbraha@gmail.com>
In-Reply-To: <20260707090331.52971-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1E9C8180005
X-Stat-Signature: izr9o3syigmx7nr4gwmxgdbfbxau1rk7
X-Rspam-User: 
X-HE-Tag: 1783519838-389467
X-HE-Meta: U2FsdGVkX1/lfDoJhjvqn+jLyxztI7l3B0AQd96xghkZ3roOWfdSmxZkDeoLJoPjbphdr1O3bx/AZSU8MxaMpKVcF5YiwbvBOiaKz4G7BrVx0Px3Ru3ipoOUGin84oPKKYCUlsJI5sOmKhAhEQtHYUIghBo2LT+qvrKdlUQqnSrjslbaEwnTeHu6Nea4L5DviG7LLrXQHO9dskzC4oL7gloEs3tUIM9hcDOTkthJVQET3HHyfSYODckxucoSbeoDuYRw2q9bbms9OtXwz3a2J1JL6OQmKtAaIaW4A17tCm+CS1ccGlsTK1FuOlMWUvyn8Q4wtv9s4O/aXz2Sd+0hksR+1psupbfkTgYjoKhbHdzhuh1YMxxMHKMsy82JZolDG1m4Nl0sXR4jw2CmBmHgA1Q8RmzSY0f99AwOxXlCuSLkc4ldReGP+Pdi6RnT0D0CIG/RcFbrljaINGTAvO7lTlYFBES01i2niqLc+GN/8Jti8eYOLMOIqyNcvp76l/n2sh4VUiAn0x91LYeir7wEY6gvTKeKBpokC7cMc+f1WVzJNd6OtSKIR0zorsF+fWgbUsEkhHF9q/f+axiH6iFrj6ksrA3F+VmWZabjglXR7hhV1zWt4V1G6N7SwTHMHW0bYIlVP1VmW8I8Qk/pTWTwwB/W5N59xcJyg9LchsYPFduaLKgfKK8Rk5IoU8Bn/CRrFQywicqcpP42rRzRVQaIbtqpX/sasgexxPoMp1prWbgh55KUoQe4oS9oRs/QyGUMCpFqlJsaXq+LtwaXnO3cp/RC3l1WzfBFpTKGuLpCKgCfXs+x2bu11F9yQt/CJmepY9sEPLJ29Ut3a6wJgMNm/XWL8R7964a3FT8b5IezydMtfkPB9G7DA7Q5i/yv8TGiqnBBIWp4S12T6yJNUX0UUFELZcypkw0IzUuP50B0+FRIt/B+o8f6BG92i47JzF0dCnu33HTvwy9dvvSUNSz
 CTiayXXw
 BG3eGu8wb+E6yalVAmOGC1OkBCncTwHObgY+Axzfc9Ht7Te7W/eSi4+9uQhNT+MBkmIILjkU1oFsJnnwpayxOHcIzQup3EbeTbNTCjxj2j2tJbXYgX0jGv74oTtjFwBNyhja26/ECAf8nRGzjIV2etr9dgtUI+bi7DnLRo6SIKQQAA/1XwlKv4sJ8BJJAci61I5k5O6uNEKhM3VQTFrSXlrbGyCj2Y4bU/gVz4PjtxWqYAXlnfVOh77+8rUkvt9W24KIvseO1g7k/SlwGFw2mCOGaCGMmAXxd/16dXa9QYzvsBrn7meRk53tmiuzGz4UmjwwEQWt7Iczj5zy81vRn1sZ6Q/PRNf3WW+sr7ywAOB/xQbsj73x21mO8K1VVRB5WjZ/ViF1Gb0CRYP4LfUO5JdRl2CqmxGngh9ArTj94WU4X2E4T1fKdZeCHWfcXnJUqHu29
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kaitao,

On 7/7/26 10:03, Kaitao Cheng wrote:
> MHP_MEMMAP_ON_MEMORY is defined inside the MEMORY_HOTPLUG block, and
> MEMORY_HOTPLUG already depends on SPARSEMEM_VMEMMAP. Keep the explicit
> MEMORY_HOTPLUG dependency for local readability, but drop the redundant
> SPARSEMEM_VMEMMAP dependency.

I love a good kconfig cleanup, but why keep both the
'if MEMORY_HOTPLUG..endif' and the 'depends on MEMORY_HOTPLUG'?

The "local readability" could be achieved with a comment if keeping the
'if..endif'.

And if we don't want the comment and would prefer the explicit
'depends on', then why not remove the 'if..endif'?

- Julian Braha

