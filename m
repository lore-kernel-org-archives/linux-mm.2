Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6D75D2FEDF
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 21:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1067B6B0005; Tue, 27 Jan 2026 16:21:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4416B0089; Tue, 27 Jan 2026 16:21:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7CA6B008A; Tue, 27 Jan 2026 16:21:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE8456B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:21:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FA3B1B055F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:21:28 +0000 (UTC)
X-FDA: 84379015056.25.35075E5
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id ADBC340012
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:21:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nyKFeAn9;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769548886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uvYegCnSnLXBpj+Df7xCTE5+wMwk6X3LJWzKMTNbnXE=;
	b=xCn9nU21H3DK4FVttikmJGrlnrCSqYeOBIcYuadFDehUuzJaZPDFw+ArKdDbOjKmjNvyla
	AKjPXbrvWMc6Ys1rOZReUr8Ysm5UFKWOdCJYNC5SG7XUfx9wkOEr8MHpWI0VoigerYQGi/
	apt1qsmS8BIHYEnNxfV0bdCeesfvK20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769548886; a=rsa-sha256;
	cv=none;
	b=dd9QfBHKe/jxln1q/03bK88NK6tmLUuII/o8SFtieTLWEGsH/L0dSbMkCg2zZNAiSuJlTH
	468R2En80G33WH4sp5xTxQekeUS2tAE9FTCt/8a67rCpDSEhT7tKNtXrz86GjB5cT3fjRK
	cbND1jSGka6i7R2NTAuoSjby25FwAVI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nyKFeAn9;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5014db8e268so98079591cf.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769548886; x=1770153686; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uvYegCnSnLXBpj+Df7xCTE5+wMwk6X3LJWzKMTNbnXE=;
        b=nyKFeAn99WeHcc4BE75qFMjS9XLXVcQ31htUvSzQgSBQNNvK6xHfOTlCsnBiVFyf8d
         vbm0EjSj1cgNXwe0HP9V26ABsMe3n+wMVDiqApTepcYjnz2XP+1I363sgQNPOH1n9/J2
         QA8M3dDx3q+Y9cVA7EmrrHkNsC9J0clbpKxEjlw/XOrxUyj2Ph3TDUb7x2VTQtUUMPsO
         FmkAGWITt1EXu+HQo67Dhol8Buz54arNr3i8jacbLojjQSkD5hzP/2QsvfyDIcmexytn
         6UkJjZlsik4l29GsOERfMBJG2GWm7QAB2iVYIqJy/ixTzy96OZhJ/8/ByR/0iqyckNyv
         jn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769548886; x=1770153686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uvYegCnSnLXBpj+Df7xCTE5+wMwk6X3LJWzKMTNbnXE=;
        b=EG/apbUdtW7srNEYPNV0dVgZfuY0qxOX4YaNcO7b6ZNZXz82/kx2zpwXilQqBW4lU9
         Ahn2HPy2cgAqSWvw7TpzkELxDws8hgUSMLbvqQrAm3Y9WRXh1iIB9BTfxiSf9K/0aIDl
         kK7D2f533DqjSP6cZjSWsjhgPN5i9ci/g95etRZeNn7G4qixTd21ISYjcj5EnIjcD7jA
         pfOszm+lxQDiiwod5dDkdVHvax2epbSO9MLkf6oQcSl2q6e1RaTo4EPRQWKeJO+YHzTl
         +c8iZK3vUW+CFnSx5KPLQsN9SucgAqyGqNimk2reA+iOrfZZGjZeOLNrNTm35m6A7eoU
         0h8A==
X-Forwarded-Encrypted: i=1; AJvYcCVZcnws8rH8RmzOHmvueYZnnTyS+ji8c29G6/s/aUBjx22zTEYxxokAHsyXgyra+uiJkyK+E0R5fw==@kvack.org
X-Gm-Message-State: AOJu0YzsfhdjYfEwlBBwHvLauJkY8EIuTlBVa6jwdpLUn6lSKZEAsP5J
	nviVIolsuElGLoJs3bfuwfb0eHRBgpidcjgf7rqNvNuKOIN6VTIj48RDOufTLgU2BQw=
X-Gm-Gg: AZuq6aIY58n+oiKioKUyaqw/0HvKXfy6+mpfcROUXXZ5e3PoeErPC3PQq2/uJgvnAHe
	TmfXop4QoP8lng3Nhbe9glxlGkQu/bCarNRjJpMSpWqepZvqbHSsGl6/u4wIe2Bnd3m+RuMjv0C
	P+wLKixRBIgfa2/zu/C8UCedZKEH4lE/cI6ZL2FBmACgA8o3rVashQNnvz/nKK+svNwan51zwv7
	z6oUR4XNpaVQfCUhxyQIv0H+ydpnaaex0sfljQgZkU9CcXXFCC/qYB8UvIorkgWJXdR08pBAhxc
	tL/MlKGeqv0M0Wmi6UjQnpfGc0bcY06dM9tXWy0NcC5hYcxiISKtGgv2ZXBsZUuuJbBrpll4GOX
	yocwpXunmaqHxYoF3CKwEQi+CZAbOeGFzADlZ3wfefNZmgwENT5jqkuWKRzYhP/sCOgVdbNz0H3
	N8xDyX3Usht20fZ9FKzwkAzJxG/FzossG45+0q/PttJArL3zTWAEKNg/KiPxoBugpz/MqED6BQp
	8/EXNI4
X-Received: by 2002:ac8:5d86:0:b0:4ff:c63c:525b with SMTP id d75a77b69052e-5032f77560bmr39338701cf.26.1769548885384;
        Tue, 27 Jan 2026 13:21:25 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d3759a59sm4809356d6.38.2026.01.27.13.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 13:21:24 -0800 (PST)
Date: Tue, 27 Jan 2026 16:21:22 -0500
From: Gregory Price <gourry@gourry.net>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	bingjiao@google.com, jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aXksUiwYGwad5JvC@gourry-fedora-PF4VCD3F>
References: <20260113081453.8293-1-akinobu.mita@gmail.com>
 <20260113081453.8293-4-akinobu.mita@gmail.com>
 <aWZLZzo5Hb1aFZ0j@tiehlicka>
 <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
 <aWfXHKDzoQBsHxAp@gourry-fedora-PF4VCD3F>
 <CAC5umyg+wubKoQSfpDQvNh3K5Y7+iOEYn6_BuKFd53kHDVE7aw@mail.gmail.com>
 <CAC5umyjOgZE0Qpa3W3qZ=sSkwkuf_md47jctXgi5UKWuG49o1Q@mail.gmail.com>
 <aXJSlv1_K1uQCN16@gourry-fedora-PF4VCD3F>
 <CAC5umyhrcb963mA9dUaZswJKq2MF_OVaipNmy=L4J7u6rPjfqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC5umyhrcb963mA9dUaZswJKq2MF_OVaipNmy=L4J7u6rPjfqA@mail.gmail.com>
X-Rspamd-Queue-Id: ADBC340012
X-Stat-Signature: 4fkwypnosrobb6ucg9b8ysbdsoy6ytjf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769548886-452485
X-HE-Meta: U2FsdGVkX1/pQ3TkTBnxbyYD2SPBo04Tx6R68wZrKKCj2vHTRpQylnIX99XPoZ6eFBP3tvFKD/QtUCE+Q0ByK45Zxr8+TmFWjt6TAcMnVnmDmg8Fmreu1wfDaIluWUNCDprKmAeDl6spWHJhLHM+mB1Yf5sveVGGTOEjg3x/K1lbQFyB+h0cL9vUew+KqHG34bMriGkmGM9gjJ5VVHHcGxvmrdE0oVoBKXTIX+flaM/0yBuee0zbw43dpqEH66ldv7bmGAq6Jta5dH45sjg7j4R/VXuSQ5420GbTKPKMko7y+ROTjrXAinvMwnoid5AGtr1Ue/pw0iJQN2bqJiZXt7ww6R42z9Vo2KcEp1AaQoUe4/BdIwZcmoJHAKo2+uRegM0ArsPs3javN3SK9pKvt0tLQFGfPcAzCsbBMVHW4DkSnXVduRin6MQce+KuBc0LJfUGIrlwugTxeTGrNqtedJmjVodDL4kJRDrrWLGvhmWANZLVJ3oB3sb7aSI1RCyhTNOfHUV2WXG6JehZHcDDEDZadxZYkXVWyhK6fVmWt5SAciiQJIO+i0TY/uxeSArCJiw38sATanxJeSqH+yYJ89vgZurr2lGEq6sX9XTI2gJM5WezO691xEvUUKoXbrErTq4Js7Kuu3BzcegkEnRZymHCseIdJw+GDKtlZKDmuqA8j75dQiGfB/G83DEKj4FJJU2t70hL2qYYrC/v2WpReMt4YqcReXAUL23Zy95IkcoKxhxUO70jSo6m1KTZxy8Fe+XqYS/FxpYZJd+5h3STE+YFcgOCsbt+yDX8jhsO3FAkVaoXhLCLSAO7DjlVxiJ0uVN9e6drHq1qIG5S0/Cv5ykfeZEM3OSUGayXcG42D6PamFdOAr1itndX8VrpII15+jNUfSaXsyqRseJEFlSx/2C1r8TKFo0L4I62xg2Y2hliCAXZO9vLzr9tFFqwrW6mCraVFXY6tqC4YscTrEB
 ZYf60Aon
 evtX9kmWgZkwply8/SsoLMivUaAztMW1Oj9HaBtrscId6DCsTyRarEx0GsKk8hQcRpjQPdljwjvaQrA/7j/KmR1OiiPaOj6fvrq5SoXXyeX1Vaesnv4P0j14isrnLYHIYl0fPq7jxI6sFASfVyKV52KCecDVz7GwmL4yUKR99SFT8MS5rJ3K0t1NLrEfh+lou2lV44a5qQ2Tr9ZfUqacEKn4unbkcaamfRAriBeCk+v9c9O+MWuxVclu/DLL09Mlq6acAIA4yCU4myevKSmFwe1iZuDAqjKs8MTKSanU8Mpwj8fs/AFwJBtd6WoXSygo1Ab2RuC+ULc0v7q8jzqFMF4V43e/QSZRgrhos270Maq0p9fu2LyBkrrWcTU3OOAGQhJ0yDdNuL0uzOPV8srpmZQQccup+umtK/Hef4Bv3SUHrZkdZrXr72WjZ/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 10:57:11AM +0900, Akinobu Mita wrote:
> >
> > Doesn't this suggest what I mentioned earlier?  If you don't demote when
> > the target node is full, then you're removing a memory pressure signal
> > from the lower node and reclaim won't ever clean up the lower node to
> > make room for future demotions.
> 
> Thank you for your analysis.
> Now I finally understand the concerns (though I'll need to learn more
> to find a solution...)
>

Apologies - sorry for the multiple threads, i accidentally replied on v3

It's taken me a while to detangle this, but what looks  like what might
be happening is demote_folios is actually stealing all the potential
candidates for swap for leaving reclaim with no forward progress and no
OOM signal.

1) demotion is already not a reclaim signal, so forgive my prior
   comments, i missed the masking of ~__GFP_RECLAIM

2) it appears we spend most of the time building the demotion list, but
   then just abandon the list without having made progress later when
   the demotion allocation target fails (w/ __THISNODE you don't get
   OOM on allocation failure, we just continue)

3) i don't see hugetlb pages causing the GFP_RECLAIM override bug being
   an issue in reclaim, because the page->lru is used for something else
   in hugetlb pages (i.e. we shouldn't see hugetlb pages here)

4) skipping the entire demotion pass will shunt all this pressure to
   swap instead (do_demote_pass = false -> so we swap instead).


The risk here is that the OOM situation is temporary and some amount of
memory from toptier gets shunting to swap while kswapd on other tiers
makes progress.  This is effectively LRU inversion.

Why swappiness affects behavior is likely because it changes how
aggressively your lower-tier gets reclaimed, and therefore reduces the
upper tier demotion failures until swap is already pressured.

I'm not sure there's a best-option here, we may need additional input to
determine what the least-worst option is.  Causing LRU inversion when
all the nodes are pressured but swap is available is not preferable.

~Gregory


