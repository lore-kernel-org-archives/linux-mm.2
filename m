Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6642DCA5FA2
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2AD6B0458; Tue, 20 Jan 2026 11:28:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7AFA6B045A; Tue, 20 Jan 2026 11:28:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7D56B045B; Tue, 20 Jan 2026 11:28:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACD876B0458
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:28:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 770D2D189D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:28:54 +0000 (UTC)
X-FDA: 84352876188.20.98C2BE3
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C837120003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:28:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fkoSeDE9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768926532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NdbYcVwZi1ih+onTl3vtMwhcrSn8T+MqEL2Cz0G25Q=;
	b=IGD5Og2VNxhaYfSq5w/M7YNOrytUyYydBeE3GXe3d205S66F026aFs5nnHrOG0AXALWpC7
	QV5IpT95vJCJMFt/liTuhCKrc8LpjxoQJCtFk+2Mg6sbm574sLulUSQXm83IS5rlg4SxCM
	M/ZQhKuSnoUeTMqEkl9ZD1w/XdDuKFM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fkoSeDE9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768926532; a=rsa-sha256;
	cv=pass;
	b=6SS4FwXb+e98m33ZSv5kNEszjUwYpSGoHRNdjFUxqXYh3N+n1RLvcQSo+tOJ7V6+qyMF9k
	d/8hjkCQDaI6Bz/lU8xuGIYuIqUyePTJaxlc8dMd1C4/nY/uw9A7dZJhabgCuaYcisltkY
	OnBoz7MwVcthvPpfDCFnSEf4FYHi644=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47ee0a62115so187385e9.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:28:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768926531; cv=none;
        d=google.com; s=arc-20240605;
        b=QERBc8JTFYS1U6jC9DovHL8DCkO1Y9YNws6ZdMVeaqqbhyFUfKYGDIO4mOttCi9S5W
         TWneo4iP1ab1edqA54Z+xta7y4Jg2ln1+KqTGI8/LpJ1KilccZa6BVtdNpDPC2bxwvcr
         IFcckvTfHX7ZbF9hxeF9VdUohFe4t4Xqgb3I+RBU1CG4fpZKWCuUWLGdXFJNLs7QOmue
         zI7aIo6xgL+iYQ9rwJdSpkHYGOPw/mJtaIyRkIo+AGQigbTZI5EWHmpvThxJ48ASOzss
         VLHr0EXOeJGF/ACn7Pd/NNGdqUG8qOm5dELsSGJYbKOWwm48GVyP56AtyDJD4L+FVd1P
         kS6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2NdbYcVwZi1ih+onTl3vtMwhcrSn8T+MqEL2Cz0G25Q=;
        fh=8Rw+jbh795zxOPAqMRswhWpJG2l4e6pZNX2FFQ0/elE=;
        b=O63cH9oGAI3LprzH+7YdAtscIpeJBUnKFv72X/AfR4F3K7BJU9mMN9+tjbUz1Nzu4i
         WPuVUPNpx3vhwzEOn2yMbIUnvKyIDrguEoyi0EFhsPTAALA44BAbWVYFFcnsNP7G0TQB
         aXlCV413LnhuduUp0VlLB1DX+AXDltffnUx+yH5VYSZKZSDyuio3Ml3V13Szb2bJnH4E
         34Ww1CgiDzoFVxO6LiDgstk1U5JNybpFWwpxmXNt5P7JF5Z+OuMCiIFKfjcAlm6EWfGQ
         rIMO1oYfHHrAMHM97qo5L55nxAYwBV4w4VQGFPoq+L4UcfAuJBTfkhz7kQvIGYMfsA49
         s5KQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768926531; x=1769531331; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2NdbYcVwZi1ih+onTl3vtMwhcrSn8T+MqEL2Cz0G25Q=;
        b=fkoSeDE9ZSuFhLHOddHnm+7184weczaaJcfoJild/28LSIYJgqptwYx7TV0MUX2Vsd
         GSLs1NBOOGviQnlhzOA7QeSK0oqSlqJ7epN3+Tz8Sid3f5mD/YSfxru+jdRjs5Y0IyXz
         A3Lx7qzTIsFF5HNAy6undHBfF3BEP08f56Bp+i+SAoiCk+Z0SZdX2YcLL6+fXXFnWNyH
         +CGIn8Q0ugcixS6S+HsfpRJHueZrSC8TPdl7zy3RzPwF7jVMKUFzWnyVFJ3DS11wMc1X
         s3yZuzLoDxpOwAkiIXV8zcXKW2Nf8tTUv10MTSyYWja2UYer7TbUzgwVDK+q3RESbZNq
         /14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768926531; x=1769531331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2NdbYcVwZi1ih+onTl3vtMwhcrSn8T+MqEL2Cz0G25Q=;
        b=Cfbplt5V1z6xPkdU61pbMkMFscn+Tb9UlwdRl3PwF5TLjTZtVW4sVn+E6bzLU4gSO6
         Gg/vhWLLfJJ+Z3C1BFW2VJ14pNap1x6/Npfbbz7BTP7QOZZxLS8Y2w6YG2L5TNk52cyq
         TvQxlADStW2SZFKxOG2mStlskYJWU03dT8C79xWT9zXZd0c2SsFgOLVdEt3Zd8EQ1CQD
         II0V6+M8wQVUqRACsFOy75jGwG6/Yu5nq8pU9NLRaLzieaBNdTpBcFm8v68Fa8IMWZ8Z
         5iue9PpcwAA7yBr8NK3Wc3NsDpwjkeAj6b6w567ek/1plNbLFNFhOZm7IZZvLAA1fXr0
         phMw==
X-Forwarded-Encrypted: i=1; AJvYcCW8+iMTklo4HE6l9G4x3h+A1Kd9Y1pf3qaD8BDco3TMv6TiVrdiM/u9Lgl3pqmtuX6de2K0goKMIw==@kvack.org
X-Gm-Message-State: AOJu0YzkkYrDogMD/kK8f0ZaSgScUufuOnXd8S/mRb6pKX5raKww8dqk
	sSvzvKpVQVhKTZCnF3/dDyoE/Lkv7OZjEraXqnPqAXRZD4I8eVQ2RU2bnbFmtETIceic1zAJaaW
	bZOxn/OID2bINSzfiTlTaJANOvdHCkIgijRpwGhZL
X-Gm-Gg: AY/fxX6V+HhXMwDezJsFpjg8uhAOn2HmxPJYP23tPNKqHQHstJsTCvVQP9aWBxQEnfw
	2msyJm9NyqBdCQ+s0/syEDFbg4QLGX5VU3cM1ZzPAM5cCJh9Ott0lXVqEn4vV1GVNCF/2dRExxS
	oxzu7JtXCOlg5stfE9J1QiojYrIXpkRhSKn3mQ3GZzymbdcm266aV+aQiVj/0O0BNqCB+t9qXrH
	X2eDrv0OUdvPNV8YtdYLx4Tqt0vRaJjroZ07Xc59dTnD5ttRyH2KtGngbyp82UAk2BaC9vhsCWv
	SkG2F8dINDGs3k/rb/EiFqPcfaqM
X-Received: by 2002:a05:600c:198b:b0:47e:dc0a:8591 with SMTP id
 5b1f17b1804b1-4802788e239mr2686005e9.2.1768926530251; Tue, 20 Jan 2026
 08:28:50 -0800 (PST)
MIME-Version: 1.0
References: <20251102184434.2406-1-ankita@nvidia.com> <CACw3F51k=sFtXB1JE3HCcXP6EA0Tt4Yf44VUi3JLz0bgW-aArQ@mail.gmail.com>
 <SA1PR12MB71997E2E101E55CDE65EA6B3B08AA@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To: <SA1PR12MB71997E2E101E55CDE65EA6B3B08AA@SA1PR12MB7199.namprd12.prod.outlook.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 20 Jan 2026 08:28:38 -0800
X-Gm-Features: AZwV_Qi-sOyZ-R41AFqxYbo27tCfgIMGnJS7jLDAEJnKTv2-_C3tqbgzg63dbdA
Message-ID: <CACw3F51qrBXnN370Btk7=bcKU7s44nmQYfN=EAfq25MondRUNA@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct page
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, 
	Shameer Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"tony.luck@intel.com" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com" <guohanjun@huawei.com>, 
	"mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>, 
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>, 
	Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, 
	Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>, 
	"Smita.KoralahalliChannabasappa@amd.com" <Smita.KoralahalliChannabasappa@amd.com>, 
	"u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: od3uoxhtgcgssukbhtaegyhs4587obk3
X-Rspamd-Queue-Id: 6C837120003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768926532-597304
X-HE-Meta: U2FsdGVkX18aMPDLA5W2rIbGtvhkURRvv4L0P/UJAxU5p9uImDkXlAkKrKHW/5cZUO8fFJQlSrOpXkcJ4JT7N7+A+3ZXjDbe7Q5VOt7EOAXAlsBzN3A0BsGyfWC/fy8G2V4jIazXF465qxjHKpCMTtYsKXoJmRznKIVDv1G20YyZpk/5ubcfTxJ61V0h7p2ldupiR6T1Z3pGqX2yc/pnz0ZnPoplOYqQmSnsmi8KhdB7lgIngImyqtB4nnxl9WlnSaaEbwA2sN6a7ohHTqUfkfTJlzuCKCYPXnyriGNI9UjbonEiYwpzbuBw/Yilby++8wB4v2rL/5eKG9++aQ1vkClKx1dGJ3IMJWi3djVzJ0sNu8ykWtL7SQr6659amAs9oSn55Y/1iYSzRYVylEdyie2d7LGOiL9orw7b2J1Er0DItyeu7eItRFD0Meh6QgIDljgI69fzppacRtf89OckDKqNH3mB/En92L76ualzscmAKGxXLNBjy6mHmm/7ZHsUHreyUf18nRF2CTM39sBsLdL/LxsJPdopoS60e4LQXLM4Stnxu6i/K/OnCkp67DvLGiUDFcycnsWPCWihBdnOLMjot4exnEAoCYFUtIAqmnAdXhVlvWVEngZxDlcdy3wu/bldPtznhPwY032cZtKUuzNLYRHm0Jm5E2iTYj5x/8QKAFvKOdZK2NH54MUikxCw6RlqzYZp64Q8WmCz7MuaiBp9G6N1eXlJvVmS6l0u8kaEHgxtQtKTZLfgAuExJpyAVcGs36xh01gli4gTtbunWh9PDEAFtyx5EnTpZ7De4/a3AuSv4Bb4GEY6sHJJobeg5UmuGICjF3Ui0hPnssCoDZaXJpGU54bRzgLeOkcdhHq0A8pw809KiM3r/UUc00T95Xu7cUqxKFD9sipyi9gGSkqRCjVwRFqs/ZA2doFl97MWQ4tMFiBbqsGmrgDbrm6sBTBJYwCBT7ukd0kpLUA
 n+vQtsh+
 3tSllgi8FDNsFK/InhcN/5SGa1CAxfQIVsiUhemlwmKr8TQ26CV6lrB4QugSaDQ9MhbdqW34RwsK/dgZSFlP4Pc/0/OlxqAlY9dkAYHqC+tjVU2j/PcI8wB9ZXvxO3DiHzJ+kvFSXnsXE2Qe7NBETXBxqdDrh7vn6Bze/EIE9q/Bq1MnoJt5SFw6XCajF3t0X/7lg+KvKyy9vgyYJf+7CCU6buxSRvICznb9mlZ7MkVHOdOgkuHo/z+CYB1Jit1LrwAo5x2FHfHNV+pgo485qu82B0GQJEEYUMzl7FCFLK+sDA2NDHwkJCO4HNSLtNPiYDma5/5JtkqgUkB1yaX4yNY6z2AHgW/IOL95oEvRIvc0yrV8WO3iZ7Ojz4EvhBumD3g6ATIXF+csISvLkSbPfWoBUv0gQzheaeGr7KZkFeB//n8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 9:36=E2=80=AFPM Ankit Agrawal <ankita@nvidia.com> w=
rote:
>
> >>
> >> v2 -> v3
> >> - Rebased to v6.17-rc7.
> >> - Skipped the unmapping of PFNMAP during reception of poison. Suggeste=
d by
> >> Jason Gunthorpe, Jiaqi Yan, Vikram Sethi (Thanks!)
> >> - Updated the check to prevent multiple registration to the same PFN
> >> range using interval_tree_iter_first. Thanks Shameer Kolothum for the
> >> suggestion.
> >> - Removed the callback function in the nvgrace-gpu requiring tracking =
of
> >> poisoned PFN as it isn't required anymore.
> >
> > Hi Ankit,
> >
> >
> > I get that for nvgrace-gpu driver, you removed pfn_address_space_ops
> > because there is no need to unmap poisoned HBM page.
> >
> > What about the nvgrace-egm driver? Now that you removed the
> > pfn_address_space_ops callback from pfn_address_space in [1], how can
> > nvgrace-egm driver know the poisoned EGM pages at runtime?
> >
> > I expect the functionality to return retired pages should also include
> > runtime poisoned pages, which are not in the list queried from
> > egm-retired-pages-data-base during initialization. Or maybe my
> > expection is wrong/obsolete?
>
> Hi Jiaqi, yes the EGM code will include consideration for runtime
> poisoned pages as well. It will now instead make use of the
> pfn_to_vma_pgoff callback merged through https://github.com/torvalds/linu=
x/commit/e6dbcb7c0e7b508d443a9aa6f77f63a2f83b1ae4

Thank you! Sorry I wasn't following that thread closely and missed it.

>
> > [1] https://lore.kernel.org/linux-mm/20230920140210.12663-2-ankita@nvid=
ia.com
> > [2] https://lore.kernel.org/kvm/20250904040828.319452-12-ankita@nvidia.=
com
>

