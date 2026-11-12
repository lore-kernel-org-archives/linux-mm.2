Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B84606A331
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=F3cN48X0
Received: by kanga.kvack.org (Postfix)
	id 8DB926B05B0; Thu, 12 Nov 2026 11:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1D36B05B6; Thu, 12 Nov 2026 11:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9036B05B8; Thu, 12 Nov 2026 11:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 581E56B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:35:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F06FF1C3E9A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:35:33 +0000 (UTC)
X-FDA: 85427017746.28.5046EB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7ED95160003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:35:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F3cN48X0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794501331;
	b=QNZYRg1ZYZGv7AjPLbgaQjCGfFoPkqnHheCyUBuJJMaa1rfTWwEG7Tlh6y5h+qhXu9qYiN
	KAgAbF0azrGa00i6Lb+LvXrNQOHnP63c4bjsgIWWh4inRQ4rTqUlIZ/f1lA6/NS8pwy3zZ
	o6B4CXN1snzLO4AeuUtG93kB6qlz7o4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zidr50P/tGTG0fyue72d2UJbI2Rv5djOGtCARdBGkgo=;
	b=ByXQV7mzv9rKQYWCT1BZ6O4U7nvADXyYV41W7c+hXT4RsSRzjNS+UABm8Tv1D7XT4Vt7FB
	P5MFMPpkNiN4bvIatX0rU9tM4t58yserQod+JXlRRrLQHIjzisYPOMyfsffcn1Y2Ap9c3a
	HXpoq0bsrvDs1yMv9H1MpSruMw3JWeg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F3cN48X0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794501331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zidr50P/tGTG0fyue72d2UJbI2Rv5djOGtCARdBGkgo=;
	b=F3cN48X05VyBgQ/C3QKv5gmTB46k94wHxBniNvLFvvKe+7RCFrfK25gE5B20tVOY1gAPoz
	Zv3PH50NPW1IuZEux814cZGbA9JJwqDbjdwFFXldhmF99tsuDGTrAeH9T8tlSTiIVQtanL
	Yk8trTMGMj2wxZnRbawuu6k9Ml7Dmqw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-_zbC68OANqOlkKQzjCYpJw-1; Thu, 12 Nov 2026 11:35:29 -0500
X-MC-Unique: _zbC68OANqOlkKQzjCYpJw-1
X-Mimecast-MFC-AGG-ID: _zbC68OANqOlkKQzjCYpJw_1794501328
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5be43747161so2469458e87.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:35:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794501328; x=1795106128;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zidr50P/tGTG0fyue72d2UJbI2Rv5djOGtCARdBGkgo=;
        b=LczbE5QVUrWdy1hyxw8215n/VmGxbRvIm3RFij3XDN1O3ZTa5g/zCEUdk5TPzYOywN
         U44TD6dgpmsNuBBh9kqxrdCrtem6uMKO/JByr2Jkte2795h4umwO9gT4Eiz30nhdAeF8
         mY4hTMhLYeuHIoCEnPKGvPkdvgS2hqrhan/RDpzoaup4goptVOZhSbdJcK3xqLhvSMD0
         1dSDFXFSJBRjesueT8BgBxK0eHGsCzjhVlA74KhqaIS2mlhznNrjv85wEsQLcLO0s/1C
         zzlL4gyaeSdQtzUVsTb0Mzm1F0TElG1elPZ8bb4IBSH3tFMRl2Cb1LT+/HL2EpLy0XN2
         vlGQ==
X-Gm-Message-State: APuU4Z9t6/4AzPai+kOe9/tk7Gy3AFCyTqO4rWprV8tFlY+uMEk6lMR8
	26Nu9hUkf0NOQjoIqF9vjposywKaoLpwXTyc0PylYIssQCh27se2YedEIMyK5q29HepRD/I9+5p
	rXu/bUGO11PDyemCqvzQu+ksdVMNmHQgR9W3HK/houqyJm8sOQok=
X-Gm-Gg: AYBFou3L2HsWie6iguOGMKIl3wpUG87p7hfEhUI3+BQ1cBnIG7asaYHljMX11sDIttd
	nXE77Zf806vXn0ngYmPhzEZTRT8mpizIU1tyHVWmvTs7uAOVjo8XtZJhfKv4mK/y2zmMZfLThbd
	wK2MGDvDh4aLbD/gyjoDglMxcaknoMLKgGMHvHe/23bvRKlE4BIoKMa8ilIzY38m8liNAXUCipi
	ZuDTkAyhejBtvg9Mxr+jFyo5Xg/SY3eWtJizbu7Yz2OJX2N3kRdOKFcntE9wat+QMDFyh2rix4J
	amqu53RpBgYCZf/57iA3+lfCuuYvnGYUKb0NosbKt7AbzbTybu++C6VH8TUAgizXdX6/wmd9lTO
	cvsj5IOQ4yZFOEb/GC9aN2wzlsL4BdsVp1nGFeJjU6Qj7wteTVaivhgUzzp29ea/JXMkeNSIogN
	IJXy1Y
X-Received: by 2002:a05:6512:402a:b0:5c1:5be5:a543 with SMTP id 2adb3069b0e04-5c15d5a80b2mr2335293e87.9.1794501327768;
        Thu, 12 Nov 2026 08:35:27 -0800 (PST)
X-Received: by 2002:a05:6512:402a:b0:5c1:5be5:a543 with SMTP id 2adb3069b0e04-5c15d5a80b2mr2335272e87.9.1794501327252;
        Thu, 12 Nov 2026 08:35:27 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c157bab721sm1785202e87.40.2026.11.12.08.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 08:35:26 -0800 (PST)
Message-ID: <968f4667-ace0-49bf-a628-845c5fd577e4@redhat.com>
Date: Thu, 12 Nov 2026 18:35:25 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <avWpWBl1nPcRVmpQ@raptor> <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
 <avXoJSGh5xjGFgod@raptor>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <avXoJSGh5xjGFgod@raptor>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OuqLarauhKi7bBC2UmA2dgpE6xOjcj97D_6dbtX7ezk_1794501328
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7ED95160003
X-Rspamd-Server: rspam12
X-Stat-Signature: k8zeztmiewnywmguqfk1b4ittjwpcoju
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794501331-409297
X-HE-Meta: U2FsdGVkX19pi7h2d1FpJoWnL1ORIdRSzv5cn8E0RJd4HLILh+lcsMcDpUX+z0CcbH920pCYnh9r7XWKoP7GPO68Jil0PNUSnk/B6os7cvvF6UFn5SiShuCtbyYvpZL8V8MGXfRJlnh9SGIWNg0SqI8csKsclsAisTU1U2MoNMda8p2xmNB30YfjfsA7kR9EKBqdFifM4nvCa4sIkRCwkMD6y9hRUydqGbrlfqjicMFUmsXiC8ttgFEBWj4mrowaUQx4b865ZWzw1IyN90nalF9B65bAxPzpariIOY3iKsy70NsZOwfAU4QIHRrcBrkjiYYgOCxnbYo7qfCUHiKDHQE06+f7/E6J46BzK24N37QHWSX0jxVCcPNozy1bvJkgoqBcHAMyXiAZ8vxC8hpHKKsF6Xx3uaDWAtDOIUt38GfRmhbcUZG91MXkpVkKxW5WvwA8L20oTas/MJ5JX0pHdTBDzbJ1saU9Q5fu2rJla+TvfSAhaCBS0Fd8NnR68ln+xO+kqxarG1rM4kB0jcRbxYMu2RCWl9T9q0IkKX6EoDITRxwOkVeTCrjXlQ2nNxhCOdp6e2CUHCet+MktrzWeg6hCchz/tzxEmGP5vVdynzr87r2GfOKUXKiKF60dZga+uEylqtbqOM1PhnbsUo7El8F3XL3QImne03rKZytfG6EMTu2BlvKlHG54xwSi8lILOyVD4PsmswVXUmKES/ofzwXjiVxtWBMq1Btp+76Xk2WGpEsT2czWBHJKju35A8HtmcyHlVTQ4cOvVxjustBF2hRXyHaE/1WRIUIpwvDjg7nYNZb/EhlXJtrhlAuJn2RF8HQN941r/MlHZ9ebGJKXrN0mUOeiToasz8mlKoA9bbyJEiiGocJWXh/wqIcwR/UE5/m9f1pbwmeSDk0+fL/oJVcLesUaCjMkYmCBUx1j2zcNtPRysyuRVReXctIDk3p5MEB/uRgXtbxsM4hW0LD
 Obrn8t6L
 fDvIcByNPcCFjPCAPvQpJwja4DINjQMnpPMqGN857L6hyqlLcKBLu6yjm4ELqCSrVJE6EM6JurYYns7Q7igKmH79/f2yWxjLgk4sRqs28ffE/onzv5b3Ew1pzc8sBQ6c4J0ffT0lRMGbxdsRVKEBzn7bRC+LVoSGMpxQ16MWS9D89Si9Zcui/q7HQb0k3th0rarI9O1J/sHEJFubFMfqzxjFDs9cUu8pRX+eG3pfuWQGCymDZfo3mzdVUvxqY+BMzGIcLvh6COdFplY0P9jmgHb11YNQETWrIDWWSPnt6fHyZi/A+Hz+pHkAN2/ZXnYHTUo2efrA/FcoVoJThNIVsipSvjGaUGMDPUXwDnJPNq6CO4bWpBx7cABnRe33120+RX25xjRfsu7lirbkeE10Eu05ucFuXNaT7RR57iU8/yntQF8q9KiadSNfwtB0yVtYQEw2jxENqww8dAEb6JXd9/pUnyE/utCuapWFZFkyAT2bs0UdKu2aw/UHU40wcuP+8JkM/+TmONGEM+X8yyh6i0UFOoSr6w1qb0Ek9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/12/26 18:24, Alexandru Elisei wrote:
> Hi Mika,
>
> On Thu, Nov 12, 2026 at 04:00:09PM +0200, Mika Penttilä wrote:
>> Hi Alexandru!
>>
>> On 11/12/26 13:56, Alexandru Elisei wrote:
>>> Hi Mika,
>>>
>>> I want to help getting this series merged, and I've been familiarizing myself
>>> with hmm and device migration, please bare with me if the questions I'm asking
>>> are obvious or downright silly.
>> Thanks for the interest and willing to help! I am preparing a v18 of the
>> series and plan to post it early next week.
> The series is big, and as far as I can tell the MM people are hard at work
> reviewing bug fixes. It might be better to wait a while, to give people a
> chance to have a look? I know that if I see a series being reposted often,
> I am less inclined to review the patches since probably a new iteration
> will be posted soon. But I can only speak for myself, you know best.
True, my motivation for quickish repost is to address sashiko concerns,
and after that give time to reviewers.
>
>> I try to answer your questions, there are quite a bunch of them!
> Thanks for your replies, it's going to take me a while to digest them.
> Despite the silence, I'm working on it!
Appreciate it!
>
> Thanks,


Thanks,
--Mika


> Alex
>


