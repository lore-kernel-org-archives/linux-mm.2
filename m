Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FF7606A32E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GoWFHZsl
Received: by kanga.kvack.org (Postfix)
	id 4AFEE6B05B0; Sun, 15 Nov 2026 11:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4616B6B05B1; Sun, 15 Nov 2026 11:59:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328886B05B2; Sun, 15 Nov 2026 11:59:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8766B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:59:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A80FA8531
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:59:00 +0000 (UTC)
X-FDA: 85437963240.21.3563F0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C4461C0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:58:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GoWFHZsl;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794761939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7icfoIT+Mng+FLAG3S5PMcuwQv7cbo7W5CDYKdjKwU4=;
	b=K41gEYv/VKHxSlSWk3g7tlm4FtxuS1KZGNi3QnWroZgOZ+VZafkV2RVHBJpHwe2YQWZ6ia
	b7l2Gd89j4NCVOaUNicxXwdEKqMwr/XM7tRK9zbliU1vDuAgxEesPyuw/XQk1ZHtlSpn+d
	QTRiRMev32gMoljxE4Prt4RYAqsSO68=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GoWFHZsl;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794761939;
	b=czcg6XssupsEInbkD/4TerbH++gvLvn2HMDonRICagRO0SvXyEclJAymi6jAe94a1jXgdC
	0KrUYVMIY5RvU6RxYduO2kE4McEnakLix7ALilH5F45EiwzdH9pw+zjGSgdGRW9V+apF3p
	OR2uqp3f0aYzhFv9iCmzVcWYfH5rAOg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD40542351;
	Sun, 15 Nov 2026 16:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC631F000C4;
	Sun, 15 Nov 2026 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794761937;
	bh=7icfoIT+Mng+FLAG3S5PMcuwQv7cbo7W5CDYKdjKwU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GoWFHZslNnHYuGjrh/bx7l/8F07iyWDyej/GltR19PHb0krwpgQZnzQ/w29MU9yvY
	 9N/ydZSw/qY2tK5FaOYCK1ORBjMwxhvWBnuouItS4XKDkbn9gWaeGjF+XgXMKjfDRb
	 yRjP08VgPpWhb821Sp+uoP9Td3foxZ3vOKkFT2wkHSIOuMW3DhfBOncL7YGvQAJ7mS
	 moyJ26SpKW7UvwaxAzqtXI2cUraP21SQ9Ax6dJRbxzUvfCguVEowEmmIQeonLglFpU
	 MQxnJgWY8X4ntDgBifkx9ExXqmq/oX+Iv0Gpat2G+lyO4H7GjhcZ2VGKcIIaDnB2Ev
	 itbJF0Q8f6G0Q==
Message-ID: <f37ccd71-8e1d-4dd4-b11a-e22b9e617dea@kernel.org>
Date: Sun, 15 Nov 2026 17:58:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] docs: ioctl-number: update MM entries
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 linux-mm@kvack.org, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>, linux-sound@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 linux-bluetooth@vger.kernel.org,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowangio@gmail.com>, David Heidelberg <david@ixit.cz>,
 oe-linux-nfc@lists.linux.dev, Chas Williams <3chas3@gmail.com>,
 linux-atm-general@lists.sourceforge.net,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, Helge Deller <deller@gmx.de>,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 MPT-FusionLinux.pdl@broadcom.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org,
 Neill Kapron <nkapron@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Hans de Goede <hansg@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 devel@lists.orangefs.org, Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 Tzung-Bi Shih <tzungbi@kernel.org>, Benson Leung <bleung@chromium.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 amd-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, intel-gfx@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-2-rdunlap@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20261114202653.3113381-2-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jktdjddybftpnzkru46w8xxc58if5q3j
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C4461C0004
X-HE-Tag: 1794761938-459568
X-HE-Meta: U2FsdGVkX190y6tTK7vFsEoxSAubQ/n46XpwAp58mX195lzXDLJGGheY7yuxKyBcTsiB5V2mI7BVmoke7QVwbGBoeDgD92C+mXha1pqOC7XVSEw4KBVxKClt6PdtUDSrln1gkDwMW46jUAtvqoigIefenK9bSpF9UD5f90faprAMIEbBNnHzd6ajN4QAsKxljbSqZ5ahRnxfRhPVikSoPJlx84djAypeLTJ9YOZNY+WRvbl1iP6wBqsQc7bdcvN8HQLzZHBdylS0L5fjbo/GwV9zn9NZR3ju5d+d/ZOuzdJhGLlIE5nB4vp7WZHBtYKZCT6ilmcXf8mN0GfZe8gZv6fT20xwmOr1DTpVlpciU/hiv3xSDbqjLXQeai+N9zKu+0OeI415uIzWLSUX3QbKBIFSZpYe1AXO1HhxbJpI5yw+b+6SpyS6y/To5m9PExHc28Dj7M7pXljcuufN3L2Yo4a03ac/Ft+lA/kQhxUNbthQ87WbjD4RRidylsNHDqukCQfotcFHXJ2863c7bDtJH9+hSklH6KXXhfZgRxJMF7MNGOnGymA/sUIfmJ2nXtL/EHwVmqAlb2chJDiref9UCxP+xUKMLtJyeTfraIPuZMcQ5aqBcKUIUAHyrY/vuiSWBH8ZLyiT6ngstgBzzsTL+28D1ZbXmptnnf8ALHgGaEpVb7fVjc2wWYJp+Ba9kiSX9HtF4WZcIfeLLuUhVLZoDKoISGHI0Qb9qXJRa+uKdcOwotnem0r4nzYm9BQP/ORrN0jnfX+RxYeH63GZsFzZgJQFKDeSt5UW9AqyBd0rWiEAUWWe046YwMPFWDhF897+/f39s/BAdZRMdRYh2hbn7eNpveERZEWvvR0/jC082Se7s+y+zx6nt945eFLXbEhfmeG9l1Gt8Q+ejVnqg4/qqagXzeiA5J6mMxg0gDeYAH8qsgRs3zI9C1yeIKvAPkuoQg+FB/s/xUpsfvVpgiq
 Dbjh/M4U
 wm4NPvDIPUrJiQNRDARgSyryXZlYwDhozrkMp+9di0E9VOwV2ZLM51wJNlYtUAuejcA68QvDLDrSLOShHD+hCHlm6Zy3/zhp1g1CeiI27Ydl8nbXSZ1Y5H3EYnOYAdLKqlCbVXseg6sl5EWbyLmxWm7crla/VLqPTznA2pMq3avzqNDy01/VMaV//NLG25qvnJavEqOfYF2GIgNJ8HCcXAefAmFOQU41645jo5b+B+/T8LSzsORF8+hZuuufSTg63IY6vRIamTIVPVACeTiW7IdqPYpsvfFwIadhQZJ8ifluiIprqJIEYkmORLKeWMeHJLf+e9Dsb+lGjJxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 21:26, Randy Dunlap wrote:
> Add ioctl number entries for test_hmm_uapi and gup_test.

Just curious, why do we care about uapi for test interfaces that never see the
light of day in production kernels and their sole purpose is to go a long a
dedicated selftest?

-- 
Cheers,

David

