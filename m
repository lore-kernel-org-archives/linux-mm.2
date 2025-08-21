Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C594CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF898E004E; Thu, 21 Aug 2025 16:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98058E0048; Thu, 21 Aug 2025 16:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AACCE8E004E; Thu, 21 Aug 2025 16:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC418E0048
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:36:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E602216053F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:36:46 +0000 (UTC)
X-FDA: 83801923212.22.5E58D1F
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1297112000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:36:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=gqyLrIs7;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.219.171 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755808605; a=rsa-sha256;
	cv=none;
	b=ZwBWbWxnJYR0GwwVMBXivQpwrjV+axkgzcSYjgr8M9sWItCKXBCc7WzHe+SWsAts+NCQ8y
	PZBdFxr9jTfLRDTpH+xXvYZPNb9KivHYjJNatFScEGcm81iKsqhi45w72HRtNHwK0jVp/5
	ZdAw3pseuOekRLu/znE0rg5paCDfYgQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=gqyLrIs7;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.219.171 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755808605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=083PuN2wICwWm8iwB5WBlP6qyKXLyqdZEBdZ0ztp8l8=;
	b=SdpNh4FamxssaVD+MGWb4bCAtRE+USDUAPzmA+kEqF6cH8OkeWTRQ0OFbkNLQH5Jq5tEJP
	KTgTEWWoJ4S/e/+Dts8ciJpI6tQ2Jzmu6AJOTf2tyngKrRdxpoXZshvdNukFagnLU0TMbX
	LS5BlG2N/EK1q4fGLKCpG3O3uoQ1g9g=
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e933af9f8b5so1158479276.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1755808604; x=1756413404; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=083PuN2wICwWm8iwB5WBlP6qyKXLyqdZEBdZ0ztp8l8=;
        b=gqyLrIs7IorTxoUi4MvRu7u19pStWhN3teJiFXSYJhmT6LGOd6x3luelowmiwWRnWU
         tnW6ZVzwEzVA+fVu0CMSH6VQSZb9tUtIxHlDXz4Cqpz7N3K9EIukedSmBVLP4+/RId13
         /cAqMOvleYeLwWOibAM6jw1FTbIso7J71wQ7U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755808604; x=1756413404;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=083PuN2wICwWm8iwB5WBlP6qyKXLyqdZEBdZ0ztp8l8=;
        b=Dj+prjT2OA/FX5Gh0+DSFoXrJsH53G5F8zQRTohy5DHWjwksMccndWu2didCfEvJ/F
         H3G5GT8jwNqcY5DEk+mvP2unJXU8AX28R2ARkOYmK6TYxPd2AguV57j92VOnSfn7vAkb
         /7AVKFZWOazaY3IeHjyt1WDyU725Rwrg9eI6WMrJyxM4U7PUui3YPRKa0pQyLbck8+ro
         QMJ0iV3JNqdTNy/UhKg1idK8tcFFk9Tpx7aIkBID5tvKtLnUtgmArmza1B9AiP9KOrVE
         u33jVbtUDI1LGKXI7rNM+yW/9XJhSMVcV0FKDYcmZOBfx35991H7KqWZ2fyKiJqdD/kh
         XWlg==
X-Forwarded-Encrypted: i=1; AJvYcCUrcu6fpC94Bv52ROMXd/iB8lWl/hlWob/ZCOoJTQh5/lOqLqVaMDPB42r2nJNqoe5KGE9cUlEheQ==@kvack.org
X-Gm-Message-State: AOJu0Yxztq3cEmOi5X2jW3q+F+c1pD61e79JvdBKR8eAcVb/ezfFR2kJ
	8fTTJ6yPq5KRisy3BgXu/TXJo5xlBHb/eZ5aI6/BiLaEJiDqk4L6nkPkYN80YWOT+rt8Y4+ZBxX
	d8ehJtrpnZJgGJF4hSgaTJWAH/8epRrViasBKgQ4CDQ==
X-Gm-Gg: ASbGncvVcVz4HGI1JAbndprns8FC7uX3UOLFPyQgqIth3wBtxe3urt/2b1u6gCORnIk
	EIhQIvwPCXvt8D/yFKdhqte7bscOQt9UDzdyhZKxM2lAz7i3lmPxPqZkZOOFbkMYrnvv1PUokO5
	F83UyawxBPJH3g+RMHuSY3xN1MUknjU9+UjfYhNjsXDp4ztDxrKjsn9esdwfMSWOO7v1cvghUZh
	kfkL0gbmJatC8luJMtsyf1txew=
X-Google-Smtp-Source: AGHT+IHnF0lVhm+1Tun1UWlMLnnSk/jF/jUOt69DP22IOjEUNxjHdHqCJTIRGjm6XM6hiUq/Axp7jnIGuYc/D1Y8ZZI=
X-Received: by 2002:a05:6902:4381:b0:e94:dea:b80b with SMTP id
 3f1490d57ef6-e951c365621mr715984276.40.1755808604080; Thu, 21 Aug 2025
 13:36:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-32-david@redhat.com>
 <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com> <2926d7d9-b44e-40c0-b05d-8c42e99c511d@redhat.com>
In-Reply-To: <2926d7d9-b44e-40c0-b05d-8c42e99c511d@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Aug 2025 16:36:32 -0400
X-Gm-Features: Ac12FXz8i_O0Dca-zCdGNOyRYVeCyfB9Z0ucQ3KoLazk0PNM2PIB2a_qe1sXKks
Message-ID: <CAADWXX81Y3ny6WvDN8EeYvBPa2qy10PKhWfZpj=VBcqczL6npg@mail.gmail.com>
Subject: Re: [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-arm-kernel@axis.com, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1297112000A
X-Stat-Signature: go7hi878tm563nrnpg111nb35tcnuapg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755808604-508001
X-HE-Meta: U2FsdGVkX18/SfTnOaqu/7vjgRX4wN8pgtT99teed3ao6PIGRlVxOfWUhmNoHSIkHi0wRvlB4RCZLvDT4zf6K3YNN3Yq53hhrEglAOBo3gss1oHfFqNLxxNQl8Pd5afFFUX06DHb5YJuzZredyWE5HENRV/5naLcYEa1BN6G7bDboLioMAlJOfgbm/Lm8pHaM1SditRYTloYiclCJujbqgxMlTyKfjkZlJiMGIFyfeV60at0hAnEXII/XUpUDu1534SdNTS1nUayXeSYfhmK7WKwdKziOdRNVRHJ74cjNuG5vIUgNHP8J6ff9tO5ZW3HGNgrHA09wn8ONtHKg/mK2nBvUBiPRxMVhZthFy8NYUhXlktbFiRsEV3iwz1/t1U/A3dKvy2TGVQX7QwurwxRupdIxxl/HbIMul/N5F6FtWpHtrapa7ZgUVeisKo4ZLw5SXVbQrQgyJf3WbcxnLYyPX5Wi1NPipA8EAmP6uUbi8tHDOikN7JshVbifqioXXlhl4pGR3g3avQCN8CL3KBEl+M6Wx4+uKtHL+jSmZutHe9VznDpGq+DTy3FqxyO9fgaoeKJDp4XZhVya9f+wtV83TKMJCvHj0iomf6mvg0xeo3GQrceWMdifn/Bkk1ADzWF+oPVKxba5kfB7E+nmyZxcS8iKzeEfQ5xbD9ANIDULBGC7ER062dCof6tXuf1ji4Wdilc78m0oK4NuzPy6Ef8HLgVOtVqYE2FAxgtX3KCrTzApHZO5DzWHu8Y9VTvgC/g9YL3EI38Pwekyl/FBudJ1rAO/EONA5NUIusW1RXdhGRJkf6MiNABULosWa3FZXaaZECxxE7exY31nhMLswU8upDCiYH9qLem4nKoXP1vqMTdFGGov5kwQI+56ybtD+gokM6CxJ++/PsqGFBaBBoJUz1DIeYMU7+D4si96r4Qp983T8zMh21PGKqSNwEC8leBDF7YjQTsch2+Cvfuqbu
 a4Jp0SWa
 K56TZZR0t0TCd2a8nInZAk8vVVbVIBD0yZ9PVXsb9efsVtHsRK44aKYLwC1JVaz6HbbcTHNXS60lYhhbQta3BQ5F8FFjXBT9fAWSjepgxxKvpDKDCy2bq59Fff3AYsim9pr6jycnz2tZbjBG3jaJfqXX2oBelMCKahx7MvlOuIQlnQ8v420ehwjnS3/ZVzpgUhBSRuDwZtajXtXe5ZZMxMe41fhRCFWjILHvLYCR2HKKr4ygJx/3Y3bDKXSNK07/URQYl5Ola+pDGZnO/DZjxfCCCxMCRytZlJTvYs2c05YM0CIrlAX3G9cxzFL8qSe+YMBkxI6q7uo9vXueuhbY9IXsMqPcWBrJ7JjsJhLqkGQ/x8bbOJF0Dwj17hz9S+Iwe6RwtGTjdU5P9Eh6cRA/NycKVQ6QL8JM0pT+PIaAWDnKm0Sb1RzGN/OOhiIwZw/NpFQ0nPu1Ho5lZ4yLGBOfwv1UDKkCy9FS2sgGcF8ahg3iQl2c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oh, an your reply was an invalid email and ended up in my spam-box:

  From: David Hildenbrand <david@redhat.com>

but you apparently didn't use the redhat mail system, so the DKIM signing fails

       dmarc=fail (p=QUARANTINE sp=QUARANTINE dis=QUARANTINE)
header.from=redhat.com

and it gets marked as spam.

I think you may have gone through smtp.kernel.org, but then you need
to use your kernel.org email address to get the DKIM right.

          Linus

