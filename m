Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1F26606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SJ0HWlSy
Received: by kanga.kvack.org (Postfix)
	id D317C6B05BD; Thu, 12 Nov 2026 11:44:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08C36B05C0; Thu, 12 Nov 2026 11:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7BE6B05C1; Thu, 12 Nov 2026 11:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD066B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:44:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23C021203DA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:44:32 +0000 (UTC)
X-FDA: 85427040384.14.E475CEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id AE3D020008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:44:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SJ0HWlSy;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794501870;
	b=guUBpwhaQop0uph2lOSPOq9wFgPzzuEF2njPgzHIW5tnuLKMn8TVb9mf2lt/uV/2bE95KF
	l5t5FTRqLfbt7B5fw/TDBk2Vv4f4gCIky2w8bqWPeRdHNpBvIm+jzYefva9j37r30mA366
	zG85onr7qogHb54zXJq74cZtYanljDA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SJ0HWlSy;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0tJRUuqq9I/mLQynKz/Dyg/O4hVratqHBUQ/E2JNFQ=;
	b=maLSf4o7WmtjD7zOkr5NgJfnyiAMeOSh7mNRvUSD88uF4BbDbl79OLI/QDRaJ4HEd1hO3R
	rGTpfI3dMrTkz6Z0Uza9XkuiBBRNCF7tReirnAA5JXHKFLzZycFSXq6BW2AcJ06HbFtHfU
	PCUDRz6stf/TvwmBXZHXCnfpOML+zE0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794501869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0tJRUuqq9I/mLQynKz/Dyg/O4hVratqHBUQ/E2JNFQ=;
	b=SJ0HWlSyBRjhTsP9Vu9qcZxyRQOfJhFwcUrFB9w1QbK0OaY2Zyl2kdq3hWuWo7c9g3vRNC
	LNeHd5REf4CvMeYorTQmxeZrkemKkOK1H0zxCmRAxaRWNmsrVBxGStbZGh6VvRq6faOsuE
	D1T2Mt7PeKXRYgdQ/V8vdN6fQ8sMtok=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-s_nKOJLiP5WkT9GkoorRtg-1; Thu, 12 Nov 2026 11:44:26 -0500
X-MC-Unique: s_nKOJLiP5WkT9GkoorRtg-1
X-Mimecast-MFC-AGG-ID: s_nKOJLiP5WkT9GkoorRtg_1794501865
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3ab20dc2aceso5083351fa.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:44:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794501865; x=1795106665;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W0tJRUuqq9I/mLQynKz/Dyg/O4hVratqHBUQ/E2JNFQ=;
        b=B83cw0UuMVB8UhSDEtQqMLQ59+eEBEpC7Vr8GTlRA7eyVwBMLB11GxMpnYhzxa1oNe
         KaNy3yiK2fqYnSt6JkNZ4gUO1pGEyGIWf7XIxuEvhM1bZ2ZcKOSk5h7hqKlJvCsx1J0w
         zHR4bl2q6QQn253Qpx7lyW7gIkS3Alr8Fxs+0huncWA0mx6DsJDdS6gp8Pud95n/sMJ0
         67/Xjewq9SWFytqtCyfyPKrWtpuwklHs354a1MazUSx1Ho+lGHB7LCRaHaY1hrsfvEH9
         zMUJKUeo+wkE4oZzAmFvlIqFYq1mjhph/DvSEeMjEai9gV3x6NGoBCvIWZZwrA/5bygt
         ptFA==
X-Gm-Message-State: APuU4Z9ZKVNkkvcrkIWExlAsdZ/hoI4YfHJkRvcvmeXMRjepjoWtffi5
	Hv8Qe8grjZoDWL4UuMtiE0VVLP3YoQaCJD/fpXn+IkdSW/omjV/aj9bJqeeOsGrf0AyJHkbNZ5Z
	jKvpJIbXt1u7HXzjzHPPUCldDI1WYOi6XIdg5N/iNP1Vf/oqkXrA=
X-Gm-Gg: AYBFou1agk2DHSjht1aZnYD51Ax9JDAnGtSFqiCLT3A3TDps7sJ8pD+DIoWxYunwpsj
	DI7wwmASoRPwSi78jQoCIlqnf6FF15wqGUN2pOwLVLKlvF8JL+pREVF31XmFsWT4mhPrJHyKf8s
	F95y7tr/2xL2Fig8jCBoz0Cnbva+JDT0nSxKAMhy8OthC7Q1Qap9fwo7DrhY7qp1H0WsbbwPXZC
	dHCGiYfjUVANhKkz65IIuslvLeuNuFA/qF+8WAUj43H0FdZ0JDy6UqGnVHq2OPHIt3sC0h/7H/z
	JMrGkhpQpXfHWnvFy1OkdviVVZyH73EUPlyfklpzSd3fl2aGjR5/+emIDOEP/cvTCAy0HrVrrhX
	aILQizHDURQdk4ZD6ucb/L2KfQ0gvZkDk3fttP0tvAoWsV/jeeuzqQVei8wunUtTY2rq45t0EYm
	P5PkpD
X-Received: by 2002:a05:6512:2303:b0:5bf:ca51:e2a6 with SMTP id 2adb3069b0e04-5c164ece630mr1090716e87.40.1794501864884;
        Thu, 12 Nov 2026 08:44:24 -0800 (PST)
X-Received: by 2002:a05:6512:2303:b0:5bf:ca51:e2a6 with SMTP id 2adb3069b0e04-5c164ece630mr1090706e87.40.1794501864387;
        Thu, 12 Nov 2026 08:44:24 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae2b780c49sm183231fa.19.2026.11.12.08.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 08:44:23 -0800 (PST)
Message-ID: <61e5e0ac-dfe2-4a5a-afee-873523df18e5@redhat.com>
Date: Thu, 12 Nov 2026 18:44:23 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
To: Zi Yan <ziy@nvidia.com>, Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <avWpWBl1nPcRVmpQ@raptor> <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
 <avXoJSGh5xjGFgod@raptor> <3A5BEC5A-BAFA-4541-8ACA-43E57C7DBCFD@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <3A5BEC5A-BAFA-4541-8ACA-43E57C7DBCFD@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p5xTkhsIf_IDuLI1VAXVSd7Zmj7EHIEdUAakpXOEpkg_1794501865
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AE3D020008
X-Stat-Signature: chz4r79c6nmqitkz9tmaj8crw7moidt6
X-Rspam-User: 
X-HE-Tag: 1794501869-770825
X-HE-Meta: U2FsdGVkX1+8u9EzGvVcQu3OsL3oeuF90Pvl/RNRdtH3HdaSHbTO1KQ8IDRUGb3qZEezgA2HL7oGjxak8A0h0mFDSk00NmmF7LaigSAc6ihhwIgB7l16gD+Z5n3aL9vaXF/njNAV/8Lr1lyKLqKJ5Z4+2Set9SVKhmrfz6GuOIVSHJos8DdgADzRNV5+m/R30mrY1ZMfW5XZVISk2fLK5gksqYbWqXS7RNGDrx/KkSl4TLsxcuCnr/DkuL0mwPpVtvh0hVWOVdbAtajien14imk0gU8Z6l64O0WAbMZ0n7W0NJkJLRnaqUn26g6I+rMCPT2Av0LtQhGYG3q+J76Vwvl4phGul4xnHFYUfAOE0I5AsbC0uNcaKHI+AnTq3D+8vhr7Tc0SKdtGqV4PpNBVixxdaeTsYK3rcll4vXazi5OJY/tA4SlRzfRfHoXSQzuYwW7R8T2rkRsawQ/I3SC6BLbUSo391mckX9SBwO8LHZ804HZhiMDLWqvlxibIyitLVKfJtezUotWrGvJjttf0l9Fbm1H+211zXmgrjHu/1FzGOTNE5tG9AcaxeAWyWB0JrlpZ3vuICPP2Li4wnCWoDh8dzPLpvaWjrNBWga3Iwg8VkMH3JeiPkCCsbL2HXkS8VqriCHW0wko42gYT13BuUmrA2Iqk8CfKh5cpuGz9JQ1Jevx4NsRRF/tos0l9z8JTHWQt6pklbTq0LOulOaof/N8Ss+9aLQRF//WRzwsxAQ9PwjXdtrXWUawkhQ3njh/8utikLrqXmO55i6QMpLcQsxxrb3eEE6JTII8CtrNR3dYz9BlqW388MwwPRL6L2ooXuYSyv81RwUahhBKWMQXL4X6uJv96J74iiW2CcnFhtEXKoF4p+ZTXWjuy/Wa5T8pG5soxFKU78gorzOM6pKOXdj4+0xPr9Ddm2hBej0KL604OjGWjCurk/7pEBgP6irKrtEB3/LD5jYleNomB+Vz
 /II2obcX
 MU0bh0ZQhiINmYAzQWmpSlN2rRPYvpRMRuiGlTmTwDhL9wQLJiawaJ68T1sL/6oCwWH3Yt4CaGccg2T0Cgq0xLMO9+l0LvtVv2F5WZWo0xKOoEwvKC0Viz0m6m5UB5Cg3oLe2Q5f7K7dhKKyiTXOjlkzn/MeT5V93VlAtzC1A/IB+MSAP+DDGd6nd2nW3xA2x7CdSqOWbij0xX4BZWGfpyavuWp99vTzbplC1qqVMLtCLFksZGD9S/Gvxuj80eiv9/vqgM8c/f8j59h3NwhlJUkyuEtcEK5Y/BWCx7xuwQXUccZq9cYWCf2zcnme3Pv5LnXCfxCMw/ESti9hPjnMkqhxDaeOM6Zbjgkl6/t/5YRpxR2lG7gBbPVsj9biSF6yUtMOZEZARH3X0wto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/12/26 18:33, Zi Yan wrote:
> On 12 Nov 2026, at 11:24, Alexandru Elisei wrote:
>
>> Hi Mika,
>>
>> On Thu, Nov 12, 2026 at 04:00:09PM +0200, Mika Penttilä wrote:
>>> Hi Alexandru!
>>>
>>> On 11/12/26 13:56, Alexandru Elisei wrote:
>>>> Hi Mika,
>>>>
>>>> I want to help getting this series merged, and I've been familiarizing myself
>>>> with hmm and device migration, please bare with me if the questions I'm asking
>>>> are obvious or downright silly.
>>> Thanks for the interest and willing to help! I am preparing a v18 of the
>>> series and plan to post it early next week.
>> The series is big, and as far as I can tell the MM people are hard at work
>> reviewing bug fixes. It might be better to wait a while, to give people a
>> chance to have a look? I know that if I see a series being reposted often,
>> I am less inclined to review the patches since probably a new iteration
>> will be posted soon. But I can only speak for myself, you know best.
> Totally agree. It is better to wait until MM people finish the bug fixes.

I was going to send fix series to few regressions by earlier posting -
no new features or anything - with the mindset that it is better then to
review a fixed series than known buggy. 


>
> Thanks.
>
>
> Best Regards,

Thanks,

--Mika


> Yan, Zi
>


