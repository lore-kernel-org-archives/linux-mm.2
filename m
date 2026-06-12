Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857FBCD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 01:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4CBE6B008C; Thu, 11 Jun 2026 21:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A356B0092; Thu, 11 Jun 2026 21:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A6B6B0093; Thu, 11 Jun 2026 21:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 835326B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:41:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D6C4C261C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:41:13 +0000 (UTC)
X-FDA: 84869557626.01.AEBE5C1
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 05BC84000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:41:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bkQ5xiSO;
	spf=pass (imf12.hostedemail.com: domain of wqu@suse.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781228471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EwJ/p+oe1BDJOA94TxGJDYaoC20bK7b6q/AC5geke2c=;
	b=av/a51X3XUmYTANGyYfmjUkwzD0yNsnVibBLgqst+Dz9x935llOd1csA/aFIplgxyJfLAh
	n2kzM5C+qFddBm9HEcpqCGCvfpwErY2y7JAGALym96vsHdL4PQOkgK3glzb01mhFo4fxEn
	XecJ75ZUe0tiao+YtiPtiLqne8Nh6Lo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bkQ5xiSO;
	spf=pass (imf12.hostedemail.com: domain of wqu@suse.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781228471;
	b=QVXP5ocxVCQr0EvIlHgonZB4QLXwsxPnjHE+9t2bNj86MsNFUZc2WP+Y55xFHWYb4KRQgD
	dCohT1pUlAEBOaF5YkBF/hSgOJeGDJimJ1jOO6Wz5CRYBxCEkC0QVPQ+PZfKZA55hWt57t
	QCtxedpBR3Ajp23Im2yjublbZ/EMGpw=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bed4f2f0898so60179666b.3
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781228469; x=1781833269; darn=kvack.org;
        h=content-transfer-encoding:autocrypt:subject:from:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EwJ/p+oe1BDJOA94TxGJDYaoC20bK7b6q/AC5geke2c=;
        b=bkQ5xiSOcoTYA/0hLPqhcYpCx2TQdYaZaiDpQF3zgjpdsPRVfofgfERhZx3TTx0vc0
         I4R3ex0Mv3Q+tZ7gPdH8KUodM1trg41m82TiMGMckVva2DN7c7DTMRcXY1S1WWoJU8tP
         n6L7nfc3dJ+rWCjR1ROhpaG00u0AE6sBUM4I5WQPNRm3CwxdDPQCZ9LKY37Q2F3qIzR2
         9qaxrzrRs16jWCO7Hb1FaShLHLkyKgD5lQm8CKXYBX5Xp/23mxlcFdWl3PYNy80GUL+X
         OolLfjeGwz0WEm9HEuEypf+cbSQe3I9qLLgrf2AB+OZll1MewHN1/cxjElHeZWiaAdxG
         ONMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781228469; x=1781833269;
        h=content-transfer-encoding:autocrypt:subject:from:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EwJ/p+oe1BDJOA94TxGJDYaoC20bK7b6q/AC5geke2c=;
        b=J9Cm5usbdl0fYfXE30MBlnsodbWhS1JVINubiYTCI5Jkx2/HI1FZcj+4Mlkj78sbec
         645xZWFhcnR5rE6LO5nPDGmg24tKymqbT6tnvtWD9n8aj6xhrJVtpwa8w1OdcmC/kt39
         +lyZiyg7oaqqW9TIDEJtDtUK1xw7bMunXdOMIoCyVusBjK6UgjZGaJn3qB4IOQ9q+m/n
         zf7iv12EWmuNYattTOkI6Iu4M/ytNS/zDEok65ocQSeh28ekagAdkcby4g9414abkow+
         W0gNWsxgOTgc7x4c9b0jZENEyfWawHBAscbaf1mmvb5jsCo4uk8ULPpNnPaEEtLJVsdq
         UoJQ==
X-Forwarded-Encrypted: i=1; AFNElJ+KmNWww1y6y0vb5uC92Cu/e1Ij3RAiVLpdGn4SXbsyhEiM61a823t9IXXP+UmHNimzJHaNnLDqgg==@kvack.org
X-Gm-Message-State: AOJu0YyfDkM4Ft1RQCtAi6IFn8W5GxxoydEzcSVXXmXwhdlgzBrtLyNL
	YCo5bP3X1XndhCLvIeE6h/ffcOTsuMka7loNy2oOpn6/InEzWrjulyIM3QK+a3+CZeY=
X-Gm-Gg: Acq92OGn5unjxQypkTnFJIj0Ba+cwZhf7FN3Jk9KxQ3oUwtWx96GbNcqVaqF27a3jhx
	i7huSheYaLREnRfCbWzSl6I0eJ55Cu6xqjTB1BapQ8bSAParVREc1BLg0VXN063rlIBFBdDg5L6
	UIdRl4L/xTIl5fgaqPJVfqrJd9fwyI1KZdGg5UzYCGmYOMuJrDISx8y6+2DXat9zxCuT6dQAhdS
	Z+ELPqO4/Ai7Gq5s9LX4Q6+ttuH9mSWXkT1cWFji0QKs9OsqV94JVIITslsHCmVINXXfeGa2cA3
	PM5NeC+gvG4uQBTXBfdKeocBUjO10jdnc/yCRpoEUqePyrAtgVxfyGL4aXA4Im0TsYi06Eka57N
	lOQJ02qQFhO2dzgSungHirNddm/Gl3dBiYuvAwxGKkLMG1UNEwHK4tjslxyixVnrN0EgBsvdBKR
	7KrURjjdCe2u5b3+Eeq7TEbr6O3y9DjlUVOpOApWvDE6b9dXqeho0zZBSzyJsIjVO+E6kSHXadH
	sjFAe0PITE+xFC5kEGw8MsCkSTB1F0dpjIQ5pC2fk16jNs=
X-Received: by 2002:a17:907:7b91:b0:bf1:1df7:3e50 with SMTP id a640c23a62f3a-bfe27b20a09mr22554666b.3.1781228469252;
        Thu, 11 Jun 2026 18:41:09 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ac9bfe1sm431703b3a.12.2026.06.11.18.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 18:41:08 -0700 (PDT)
Message-ID: <b866b2e6-292f-4c5e-ae5a-d77e983cfefd@suse.com>
Date: Fri, 12 Jun 2026 11:11:03 +0930
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>
From: Qu Wenruo <wqu@suse.com>
Subject: Direct IO page bouncing got some garbage?
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 05BC84000F
X-Stat-Signature: mf4cwo8d88oampzgeetmnhafk98quap8
X-Rspam-User: 
X-HE-Tag: 1781228470-379905
X-HE-Meta: U2FsdGVkX1/4MoyAJ0wlST3Fky6okzda8P9+ZgaCq2a69eApPFliMGQ4SGbc8Jig4+PUpOGqbTzW5/D3IVwvz/pE88KMYd7oBvjwi3UiISNatWmyOxaeKIxJHmqtK74DcbB2Fbuw+3Qgkwq5/bSZauYz9ZugIujaa7T/9PvKXZT+omiNcWPuBIBReqc6hM6Zk1Wi16IHYACdGZbc5Ammb0FKfZSA9qXBV4thZU52anfevZqhgXgSw9sKsqh4JkXvhN1+TNT+uInWdkeq5BKNrc5vofE1BIZ557xS0YfWBzzBzA5MPRICbWZTSrUGy3pn/HA6rDhnNL2FT0hpKRF3tYEI8OrwF00RQbFQj9hsmXYlcOt8UGfZJy7QKLaOwutzu0UniG4wE7gq/CyfZ3MVkbx6vENjyJZB9Kouj9ZXE2sJaT3zoijAC9SoC0y/s7E8ZzgugO4Rsl77gKKf/MvwgNn2ytfUBZAB9D9EEqAWrrw7DImA49/vDmerorX3brHJfkD/o7+1REWsUelkbIMLuQHtUy0c934dMgyJNkPfI/+touBuoMJb89w/qIGdpeQc7SSwIDAhUFV7qY1IhrdrsRZmtZc+5+ov+1HeCIK/McCOTKVsCOgv3tljMLQJUZ4kqnwlDAFDHhsV9uNE06YWBAwJJP6aeGNm4SeP089otP0R9Jd2vA6qx6E4xYiPmfzKcarayiL32Hpws2dZGUfISSK6tihvF1mtQ7+9OIJxUEr8r/8mAs4l7SioDZZdmZjiCAbEV65QBxB7SH2ZqT3QfJA7X/35w28d3u15YuKKalBu1svmK/zRRDFtWxE6yqYfLojykkVY3I5q6iy1EtBe9yFfmlPTGKLSoyNvNmWThLfeSUVu9lPGQ2O9dsTRAYQdS1jxcmB+38MtZZueYGfU336CUjaJjcsUoYmXOcsCp6RDOcAAagfsofiUDFZRTBu1h7PrTEzmDqzuDP8sewQ
 wJJAg3ej
 Vbc5JOdQrrGX1B+cmHaXcfKSZ2EZ40Lj2MGFsrGE3HyNAzVcLwA3FP/8uMB5WpLUpEW3dA4B0OmaKl5G11gwZ9acGUPwCmmXQsge+7bc15tGM3gnlObeor1Y4IwcBxTWcuZhP3jEALoaPGtKvvvIdKHPcouPcjlQ79M74NFP+VqMPZq9O03JtZXhs2didfrhqMU2WSDZoDt65w8Uo/C44P3f7o/zuoowWrvZhsxbjmQc1E4GpgLwlpgPyiU8xV1wFcGCvLhEgw1PAqiS6wi2bDDkkOhIlsYldRd36+rdsoUg6wBuPdYv4QXZ+QCVXQyBZJCPAPLCLNFSTtIwR6nvCGRB8m7L1zdkBEfs6xfngNmhEXlnkDPrKQ7XB4ePCRE9DPWqUdOdSV0utPE1ImYAS7koknXtrKRjS82HbDlkdhDz1VAqYN/RHjZ7VEm+UhaKcYloK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Recently I'm trying to make btrfs utilize IOMAP_DIO_BOUNCE, however I'm 
experiencing weird data corruption.

During test case generic/708, I'm reliably hitting garbage pages at the 
last 64KiB, the garbage even contains an ELF header.

In that test case, we mmap a 2MiB sized buffer from another file, and 
use that 2MiB mmapped memory as buffer for direct IO, write into a 
different file.

The source file has dirty page cache for that 2MiB range, and no 
writeback happened during that direct IO write.

So it means as long as we fault in all the pages of that 2MiB buffer, we 
should be able to copy them into the newly allocated folio, and submit a 
bio using the bounced pages.

But the last 64KiB is reliably corrupted with some ELF header.

I'm wondering where the corruption is from, especially it seems btrfs 
has very little to do, except calling fault_in_iov_readable() to fault 
in all the pages.

Thanks,
Qu

