Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80C98C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 16:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DAED6B0088; Thu, 24 Sep 2026 12:28:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D846B008A; Thu, 24 Sep 2026 12:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C216B008C; Thu, 24 Sep 2026 12:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07B0F6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:28:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB9C4403BC
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:28:44 +0000 (UTC)
X-FDA: 85249189368.22.B988C77
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1454280009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:28:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rCZz01el;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790267323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqnXyJFHA3jgUbjUAmybKoPJLc3QQSs1Be5SK9r4kic=;
	b=TOq98JyTKZXsGOyOyFn2xq0j1PUuL7i+EDqIi656DdUzwN8c8+x+wUwzWNi2mKjXp0cCws
	34qxcVwztg/0b9aVZ5im4q9bdMAE4b+4JM5wd8FBi/+8yz5zTcdhVmQkFYIBYxlsnPf/7A
	qbvLO5wJ4uznufOKz6wxvZMZPzWxbQw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790267323;
	b=rZPciAJZ5+/tNT6PKyKwLe5WRSgOil2azugLdBAtz7H6a/YVOF4xIvsIkKLz3e1iDkyqeg
	LpIXQCceqNpCN88cAQe4nsGklKDtWe04enhP+MrGlDlfbyGeVaM3q4fBwD13IF23wniSGf
	a6oE81GdTqeEgen608PzlxXApUZ/e5E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rCZz01el;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939eb3249c1so179047485a.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790267322; x=1790872122; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vqnXyJFHA3jgUbjUAmybKoPJLc3QQSs1Be5SK9r4kic=;
        b=rCZz01el17lTKmqR0QRfEOXKDWH1vV+MtRSyzgxNIIsFxdoUDE9hpzHTaxYEiiYzJE
         EKN2H7TwdYTjPdSBme3WZOQ3bUM9w6P1ed/SAki2Tgt6vbKOnn25bSmFCL1rqoKiBXdU
         vusbXeP/sXdFBpFzY4YY1b/E7qVfkoJbOumqdjyvjyRc25+4RmK63oQa8MssQ8TZv+KK
         kcoZrXR3lrmfY9Q8DdIkyOOS4Qzjpw6Jv2casengyHjct17rNzeA2SwhH9WN2V8uqtpP
         B1Lr/eXhLnW4mDJFZrHaySmIw6knY0xCSY2OHbRQNQN2UF16YuIgvM557pspGDg8wC9I
         J2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790267322; x=1790872122;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vqnXyJFHA3jgUbjUAmybKoPJLc3QQSs1Be5SK9r4kic=;
        b=Ne2FLZ9bRSkXzs4XdvWj51cpQwjqUIOhhR79/oKZdb/pgwO+RFbYWohHoikKP93mek
         dqnKDaYY/hFa4zzalhv0paGA3eb+fGlk/Knv2KUfpwEmu35hK02EwPF6O+ymUe7EYcs9
         JpZ0NLM44gh+DBK1bJBmAsP5sxMH4Wl3hg+ZBv0OJ5SMP9eZ6Bn7Wf/D0J+kBS1p7H3b
         QjZNmAtqBi1kGKncUuWVJCiN26xYWl2hXsbLzn4lXduLDeuSqpI4hJZ+hWFbuRKcUTOq
         uSnSVUCHhISKBvKv+LyD7LHWEIUKqYoieBKgV+wJk2SGp9+KObuD3II4gUeUDYF1YBDQ
         aEIg==
X-Forwarded-Encrypted: i=1; AKwUvBzDREUISSkMW8D2EPzR7/CNRCY2nehjQRPqVtvjGKJ54cpRBDNTw19223d2DZst4GuoPDMlCLXfSg==@kvack.org
X-Gm-Message-State: AFuF++kvJKOqHbKrclW64e2EZSZRAUrlGcs7BM+fiA0fF/ze34Vk91B2
	xTuPEXXQCibFXBL/bUnsnDrLczzrOcn5IwcmAG8rquoUUbavTkb5tsmwNx7npsDAcnU=
X-Gm-Gg: AYBFou0gAMieIrnfvIMhTL4NylxCMurExxVVxEcVaeZuPasLgmdAJlwOBYypG9hPSc0
	Fwrw2EQmRh4kiwQzbzpl4wHfw67VbXMyzOVNihf45EH8XwzKELTnwJ7PY/MAbUKylf0NkFbzeRG
	yNYu4q/d36A2Izb3iXqPkV22gq8IpQUBrNkj+0GDWodUg3/QA3Vs6bOspAdWNHf2fkwlDQa/pmd
	2bD8fyU+JV65tnJxTauqEex3G3hj5xFYU6rA8xf6Xngk53pkWZi/szsN1/Tt5HAW4SvBcXSdHON
	M+ooKTXo34lTmR2+kwC9/QLQ7kL/HF/LYh/SaNwWugugCTerDMeaHT5Nwe3OYUeHngjoY/X9CPK
	dZdoXDdE3lVNUaDxhtsdrLn+qH2bErIsCY8W5wyhZqsjMbmqgdL9KXsptrhsJqwx15ZTpLLWuWk
	YsIrL3bDkUFpD+Inf7soKuVgd1ouDqTA88VfhW6sC6Q9TbRVvVSy4f+L3w1725CyDdsAa7OcOim
	FXHjOOUXVNZUulfy3tchYOb4lORlVs5Sj/Fq2jud0mzeoZQ1cmcfPE=
X-Received: by 2002:a05:620a:31a4:b0:930:9585:e08e with SMTP id af79cd13be357-93c362b2742mr373053185a.10.1790267322126;
        Thu, 24 Sep 2026 09:28:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248223dbsm499338585a.10.2026.09.24.09.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 09:28:41 -0700 (PDT)
Date: Thu, 24 Sep 2026 12:28:39 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <arVOW_frpIU_JbbP@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
X-Rspam-User: 
X-Stat-Signature: coz8q6jqe1ifyyprmpugnxfim3sc519q
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1454280009
X-HE-Tag: 1790267322-708154
X-HE-Meta: U2FsdGVkX1/XVD1bgvqfOnfVwP8hpjOt/eUvkHchn66TnUQTVvzLjDw0R7oz3Jq9nby9GDd8gKAHtgk8UPt343hMEyo6x+s7fySCiUtGBkyDia1dpOs/qWGZaf5iuQJRz/yupFL7qJ5efmunUYLfQX3ExjHiOpXdd4Q9XMQUVWZQ3Epb2ICVjITn8P/4FFzv1IWaDToFQdZV6JAyN/pWnSWa4R6ICqrrWWZuzu5531Aay2IY/JXPvHEIxa2JzEek+nK8jkPqvK9Y1FnQied4Z34PtSiMirT6n3QsKkjpyv3dNhKvbxC0KVZ4FyL9LWIL3zVhx4WRyRl2z+vx6xCWm0r/zeCcANEyWFdGHBoX67P7KljdM3lrcR1lB9aNqNbJw9wdiWRjXCF/2afiXQM0YoaC3n90+t+KsG2odhf4BgnreaFOUaUanmzO1OxFhuLciJZ6c1piAUKTWnLMMg9i73pjeBN08tmPb5bPTg4+RV7FGRubNpBzXN/RSE4aXudfe/MyoadEc3MgOoYaTPaF2ThpxUhpw2tf27L//l1yXMK2SvaV//Onv8monRbIK2aKM3s8KnV3lKlPu5hyk4bYvQizY5XqwwNri2DGwuIRcvCZrik4hK8EbtgaAViC2loeCpSs32VpkbMixS59GOMGeaytRCK32kDm2xiSKSPsfrnkU0pVuAuHWwk4wZz5dSR6/WtgPsAoHF9QmqNLMfixNeSYH4o+pVlxdFLZinfSyYKodroJ7VWUQwrnXiHim8UENQtApVydU3k+M7y6v3SHb+hzUvwW7oOFLmmXgkmPVRVEKE5r3eEFIK6ZIfifKVh6km17o2iKaLb1o7oa4XFtdtJTN2WF9n53Dl4NPAYcOhy3GJOS60yRq5mLGS7OSa/ueFXHjKWB90E8z6CDmdqPwZfsPIvo5u1yTGMZ2Oi/Dt5FFF8NjaagU2lh+fGTco1upaXdsLnu9E34JeFlrIG
 tLG0L+gS
 VrhGHxsCUDunFTrn/K+cGT2Sidp7gEpMIKCAtXZq3CKbfp2b3SayWPa1debDBLBy8I5O+gKZlWjzoK10m8tALUHQud1VzYaTNd5dUVQjW1QLPcCanDMEg+TUoKqV8rnXfLd7UCFYQGpelND039IBeenjfCumdyQsVnK0SzU3QtBHfWh2oUxRl+XCMb/+EZkzWZXHWsB+QkqzZ6hsisLgPuhv+s2Sx+xh91JiT0hhFpmqfoii091rvsTg3VRUfmpj2W8CQKwP8B+MlcM2UWAGp4qLsiu3GT21IJjHeHRzYhpWeHDM37sxAo5JOlniaAdXmhOpKKoGwqX14mtyGEt6Pue0IdexzY/E/VQqepRxcyZl9iCj/8J02BmOaVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 05:22:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> +static void put_map(struct mmap_state *map)
> +{
...
> +	if (map->vm_file && !map_same_file(map))
> +		fput(map->vm_file);
...
> diff --git a/mm/vma.h b/mm/vma.h
> index e97bd2dfa786..f15faa83f3d6 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
>  
> +	if (desc->vm_file != vma->vm_file) {
> +		fput(vma->vm_file);


Sashiko pointed out that this could be null if the vma is "anonymized".

Previously we'd discussed that anonymizing a file folio is more of a
wart than a feature, and IIRC you intended to remove that (i think?)
when you removed zero-file mapping "anonymization" so some of this VMA
stuff could be detangled.

If this is an intermediate state, do we still need to manage this NULL
scenario, and when we drop the anonymization mechanism we add a WARN()
that says someone is being naughty?

~Gregory

