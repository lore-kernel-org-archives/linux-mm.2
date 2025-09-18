Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9CECA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 18:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32988E0145; Thu, 18 Sep 2025 14:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09618E00F6; Thu, 18 Sep 2025 14:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20F58E0145; Thu, 18 Sep 2025 14:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D05208E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:20:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80B58119A9D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:20:59 +0000 (UTC)
X-FDA: 83903187438.25.CF9BF35
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D3478000F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:20:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SkcOwI84;
	spf=pass (imf02.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758219657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5VA3ijQYKv27DV4SLvZvWkSfaGW+8Q5F0B6zn7IdzE=;
	b=IspVp50t/L2waGt/OV5vgK7HcNA82xVA3WcV0ssXjjf5SALovUIe6A1HC0TfN1AhLu7xrN
	G0AfNv9sO+aDwq6erWA0Djx6J/SDK6xvoNYEZPVkAK9mfMf6ot28IQs/qxuIQ+Z4zfq0o2
	w9lF0Sde0eA3f7cFsByYHO/AoyEfZyE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758219657; a=rsa-sha256;
	cv=none;
	b=sRMQMw8vprcTbTfHjOR1/Nq4Bbu2pXVqLIZpDKnZrBzG29wxmeGod5HV1xf3Br4JbLEhwQ
	ri22FkJfAau3Nbt5UzpJWNG2YZUrFR1fTyqlBK03ItTlrLUnuZdeNYGiG7UjrMSLvADNvN
	J3kKS0eCNXqwNu5cdJ7Jne5ej0ccGk4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SkcOwI84;
	spf=pass (imf02.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758219656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y5VA3ijQYKv27DV4SLvZvWkSfaGW+8Q5F0B6zn7IdzE=;
	b=SkcOwI84tgspsSo3WidAP2hjPtRea7m1mbsnTnyAuBrvNloOND90OwDQN2IcUVXjyx8PMU
	NY16dvTTkmHpVKRwgYFkzuG6HfWpn6ZbnpHycCwJ4casK+AuMhEWU23ETZ/3uKZqlHu61x
	oELW4lQFVhGpplvbyYMVrgLfjlQbgaI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-Vv-IX3tCMVS68_k-GAQhEQ-1; Thu, 18 Sep 2025 14:20:55 -0400
X-MC-Unique: Vv-IX3tCMVS68_k-GAQhEQ-1
X-Mimecast-MFC-AGG-ID: Vv-IX3tCMVS68_k-GAQhEQ_1758219654
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-83622c273f2so267941385a.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758219654; x=1758824454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5VA3ijQYKv27DV4SLvZvWkSfaGW+8Q5F0B6zn7IdzE=;
        b=tMxp3SJefbakv5N5c8iZcZrndAk1C4LpZRsYF8t221Mcy2HyN67OJZp3gbEkaPOsHy
         q7n6GYWSccIbr9g0noQMGyNobWjle7k/O3DkDz5FAlDKu55hHaw7qmMBkJy1eW42zgGS
         0/qPNTlUwqN7gekptQfnpoPoWQmBzre2MC1lOJjk9OJpwatMbVyTx1AklldCZ6KcKNUB
         fdf4NyCVcG5vWRZiBIGOjXAX1P8NhmpSoggJKm0J8LrP8btpZW1r18gt00wSsXxv7CLx
         8L3FBNmGnoiMNChZGLC52cZ00Ytxlsx9dJBf2DCpxxDAcR+PzFerZaym5LDL9k7+apn5
         bNSg==
X-Forwarded-Encrypted: i=1; AJvYcCWVF4R9DVKz0lg9RAJVjj81J4EqubvWmmDaGp1KKwAxzuhDO9l+uoaoHmmxSnE+zr3WNQG613uIyg==@kvack.org
X-Gm-Message-State: AOJu0YyyToqrmrsq/kBklXhcSaTy3hhdMqs9W2zBftFSuVsoLT2YdOyC
	4oIXHJPoPxk+2JI0J6q4WtlHjMFHEg6aFo5D/wxp5xMJ07J/Ne3rPjj/gZ3MNkDFs2IiyhGdQQr
	qSML2AtzTqMuTfSM1J5AMWo2LZetr8+y0WqK59CgPJhI+DDf/vc49
X-Gm-Gg: ASbGncsbY8ushNIfOz+frl+AgqU2a4a/XuvbpQc33RPIjEetauPeqFtZTmcDmkqh1FY
	s5VO1bN8LyrTRTtV5ShseghQql8vJ4xnHhg0911w1/XSlN8HPe0EJYn7OjMMiu1TiqYdcY2G/wD
	fise0x2vSDW4tc8yt7YkkPIOLcaaqOP7a1OuUnderLQcDZ0aeOtR8gX+1sKtXBrUurGUq0dKLxy
	dSCIRrEqfy8v9RFwj2OSLkGi20pBmU+yPAp0ztEEQJIg53FBY68TwfYWQllPNFMHkWyuy+fSHqg
	TFfaTh53rDxwJ1XXnbmnKTWsZfJWvhftf271cqzvC0dOt1bfTY+y4BKIlmo0fLW/DbX3nh8Q5eh
	YGOsz8KlEbTGXjO3sVlAjQw==
X-Received: by 2002:a05:620a:4504:b0:7e8:147a:73c5 with SMTP id af79cd13be357-83ba29b5d3dmr70208185a.3.1758219654554;
        Thu, 18 Sep 2025 11:20:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdSaJyu1WpitpTyrKCmwN5bGuXeY9Sw55Xa8528h1i3flXXvY6EQCqbcm6IpoYNJwYjC2hug==
X-Received: by 2002:a05:620a:4504:b0:7e8:147a:73c5 with SMTP id af79cd13be357-83ba29b5d3dmr70204785a.3.1758219654129;
        Thu, 18 Sep 2025 11:20:54 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-121.dsl.bell.ca. [174.89.135.121])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-83631a7fc2fsm195959385a.54.2025.09.18.11.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 11:20:53 -0700 (PDT)
Date: Thu, 18 Sep 2025 14:20:51 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aMxNgyVRuiFq2Sms@x1.local>
References: <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
 <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
 <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com>
MIME-Version: 1.0
In-Reply-To: <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IUQghZLpS6BCtdZz59UA2WlogXTYP08wUa5mo0-5gWw_1758219654
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 0D3478000F
X-Stat-Signature: qoxz3n77i161b87m8e7t7qidrex3qnye
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758219656-528915
X-HE-Meta: U2FsdGVkX18UgoT/M+G84Bp2mHpT0EcQpP8SkwT5k3kxPTXubZwaXcmwoXBT5dgx+cCOcFEVQUru6UnHKUNJiq2useQZASSD5pMRidJVcuDjKYu7WCKxTYrdGkonV7qChVCqXPafx0YMFheo1wwAvxXnGAAuVQlngiPhuEOm0p0RqcXpQy+ZqS1dq3Yzcr4EKKP/sfJhA9DyobW1kyK3sfaotUfCVC4fq24HJ1cktgYOdBRsxUPph8w0zLXR3v/YkIxUMEOKW20kzKmCK+pZHyfDf9secEknzm+y0xF7lF8mJbQtGnqVXR3iYTIuSANj2ZVnvCwFuwkWamI/puEWbzF573pRhHcgWPF97J3PhoxoBoYJOXQh195Ky0zPLWQVVPofgJahM+hzPJIaIsnrDrkJkp3MkDCPsG79LL75wLdmFUJoa+wArQmrXSrHcw06rL9IKZ+Al9JZ7ua5rsIE3Ue4RgmWp8GrYmT0KIOm2+bGJeqgsKoJAydDZD+zbJL5qQvVKLIa22GF9XXJC15NAK/0BzpRG/3NuA2JUA26sOB6KtmTbP5Y/TfSEEGUhpo7coJYsX+nIyRTEw6oZ7DYsCclTbrZw9mbZT7CysbamicQD6lT7c4yPHs7B15iYhl99kf5HWxrw5yPntoBvK2+QLWo9J7wEajUwNMIogxuOKGfFikefm5C9tgwOQ/rfCo4giYgP9m3p6LUIgzQtD1K+RJ7/uUaFqwIbowyJPX02ckWDlbAAYmy+8g1wDgf4fG9IDb0s8W0elnr2IXkIhvSfFzinvcYCvzco8vqdXjPCdgEAJg3Ge7GU/9zpc+uDqi5348cUtC0yP726BhDyZICmqQwuY04jSFpLesV50mayy2omNXcdlJCrCI0AYJwn0FJpBXSQTvUsfMpW6hC20XPRrKxOD3EgGCqRtkXKkwJpvMGgZK+yOcbhzeUAMFU5IQpyLyLBy9STEJ6k6AiI9+
 9+6T34bC
 fJjlMjmtd7LkHYcpB9/xweTbmn4ktR4CwLvsDpC8bOas1nHBJFwewmhb/hcFPE4NlA+jzYnOcGsocCrYClX2t3vYRqbjmiIzY3fiUmDlb7N8Z1dwAytGQX1dIJIa9I8KpePoVTiu3SD6+zob1p3blR7kzeybthgVcfwfoSuLr2HCAJ20lofb1OuxBp/nNpnHc9LaoK6Rfu2aofNMv85LIkKneAm+fyGva3WbcH+hY1xMlT5MzYfBJT8E0WMRdYMIL5H0f9suw8w+3FDPjGKctUt4jvcrqceFoGIZ4hehzsenncn2VHaeZ1WCMXZ0g2zYiULE7mNlJQdoCtXDpZwy3ZBib3Ule+FHANtB7dmPyFOZc4u1y7fWVSGeE4G7XfcbesXue9E0xdtdLJ85CC9fD6lTy868kxdqLW0Ki0b+CPpc1lveG1QU3ufC3hr9TPmN7uOakraByW5Q7+PA9uZRdJyzXNf2Ei271X/PfdUuXQOSJQFU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 07:53:46PM +0200, David Hildenbrand wrote:
> Re Nikita: If we could just reuse fault() for userfaultfd purposes, that
> might actually be pretty nice.

I commented on that.

https://lore.kernel.org/all/aEiwHjl4tsUt98sh@x1.local/

That'll need to leak FAULT_FLAG_USERFAULT_CONTINUE which isn't necessary,
make it extremely hard to know when to set the flag, and comlicates the
fault path which isn't necessary.

I think Mike's comment was spot on, that the new API is literally
do_fault() for shmem, but only used in userfaultfd context so it's even an
oneliner.

I do not maintain mm, so above is only my two cents, so I don't make
decisions.  Personally I still prefer the current approach of keep the mm
main fault path clean.

Besides, this series also cleans up other places all over the places, the
vm_uffd_ops is a most simplified version of description for a memory type.
So IMHO it's beneficial in other aspects as well.  If uffd_copy() is a
concern, fine, we drop it.  We don't plan to have more use of UFFDIO_COPY
outside of the known three memory types after all.

Thanks,

-- 
Peter Xu


