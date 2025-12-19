Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B287D74956
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 05:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE956B0088; Fri, 19 Dec 2025 00:30:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5EA6B0089; Fri, 19 Dec 2025 00:30:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2596B0092; Fri, 19 Dec 2025 00:30:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4694E6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:30:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC792B97C8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:30:04 +0000 (UTC)
X-FDA: 84235094328.11.8FE058C
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0CB431C000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:30:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dn9mXhUF;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766122203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wg274Iu2P5kqEB4w7vk/JnnAiAN5EJXKFqrP+Z0u+4k=;
	b=axCHDiu0g3FMsa/6480LeYbA7HM47lOuVzSGZYffBPMQad0vCv7ovgh/KFcFN9Beyl4+rE
	dfjudP5uokGgqfN0Ls/9DoPbZinlHu5+J93orD+s9Iw5W3aICi6JLawhbTsKN2bFATNEBd
	ARQfuxAmNM1HCPBPuHaIVNfEbOR+u88=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dn9mXhUF;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766122203; a=rsa-sha256;
	cv=none;
	b=mBPDMarM85si61Q8Wlnuld43khtIITsUZlvjpk3BDzcGZjYxISg6bHSRJiMKo45LI/u5V2
	dBhPUMHarJc2FXoBDkCvpPUydkeeiwQUq1F8QhoMyU70LclQMeu5fut5UChDQx/3s8A+kJ
	M2BDSUDxgsRpyGWUl3387MODNLcdhZ8=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29f1bc40b35so25099915ad.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766122202; x=1766727002; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wg274Iu2P5kqEB4w7vk/JnnAiAN5EJXKFqrP+Z0u+4k=;
        b=dn9mXhUFZFk1AQ9IeFqzjQAysW0AbcPaf213DmIAOSGP46OYzBw55Si/Ac0W5p/pCq
         WGMuZ06KnG01w5rb5YIaeI1qQjIWGzwE5NWjdKX8lnuIY7+v+6cJXiWkp3baQoQAFWuz
         N7YiE/7rHJ9gANnAPqyTjSh6YudUn36oZsvX8rxB/ZGN2ZzmJ5589sxgTnVAr/cQQFjU
         v2UrmB59BMIek6QHksAnP6NunV7OpB8q4kBvRo64JN59XwXSBoouLaAf7Rhlekw9T613
         6WFh+GFni52/HETswdEi3ao3RH/F0mCu7DLPqUh6ekKTdcp61avsOFib03l6Tiwbfdak
         NYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766122202; x=1766727002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wg274Iu2P5kqEB4w7vk/JnnAiAN5EJXKFqrP+Z0u+4k=;
        b=rPuRSO5aGUpC/r+66A+bP/tjcG3I2D1bQjDBJhB56S4b+aBf7A0v6qxv6Ai/q/v+9X
         F3mAqRE2PT+BDN3ViYhKGSoHOIIKh5tsf1KGCyHDxFlewA9LGsAOWWlE29SNSZaWsMim
         IIXWwsibm2ybPfbzSnyKDMn1yVoah8lbXbhymqu53nbwCYVQ1ExqmuYqW9Pcdp/IpHr7
         yEa6GQ5etRXru/N+EFYOOkms/r3GqgOLSngm1nfWORNfySdzJMDLrQGtr1UBDfxMcG2H
         h4WmaMOjy39ZeqKOaWK1xfyIVrSC8locOD7GWvpDU9uMrI7BpZKR5V3hGmud5y/16UZu
         vlCA==
X-Forwarded-Encrypted: i=1; AJvYcCVqMvuypgZu1A+dmQAJ7YFn+Vs+yfTZ4eSW0roQw/IIU51ebM3rie75GjVO0yewIg68KYiFxg6o4g==@kvack.org
X-Gm-Message-State: AOJu0YyCcRNHt2zI74+0gGAkr0cMHQHKkzes5dwRP0Spa6Ce3Xx2Dztk
	/r/l1JB0AIhXYxEjKJ2QMILPviTcU527Rsam4FXznbm+8yLrDW3LxjPq
X-Gm-Gg: AY/fxX493KK2rm8pJYvnZspE7bQhDubBWNMFgMh3a1CaJqno/dyHjUgaPrzXfBlwkan
	/2QytBy1JHD4tYFp6jY0PTzd/GY7JdVTO2lp3BNnhReMk3VowyF9P09eO1ol/rZmLS1UGY+HT6l
	m2koCIB8U4Aip2lTbIGGwJ2fZVFf+Ta/h4QkrjMPmkXqwS6ggEiFD5msZw3wMeim5WqxiBjP574
	p/1dp5aUTmM/02zW50LRqXrGOKlb4hFwrDxYZMVAO4c+/fc2yzS08ncfls6FGBnTu8Cazy2ikPx
	poiMdLdyZB4ICm1Swbgf7r9f9YZE613avGlcRCc3n9e4p/xmdaIA7zvn2BU4xyAg3prmB7q38ax
	a65P90rJXcPPw5wl7FmfMrGo18XNZGErzMEREGZyZkcmgqnFB80PPMTaVfSyf5q8NzS9rH0HoWH
	dlRSnhxwBkp6JBDto+cdY8asMl
X-Google-Smtp-Source: AGHT+IFmQTJ70XE9pUbgmDIsseJXhc57BM45s/esQugwzeKartzPMnDDQNwsmT0dqjoup+l1weaatA==
X-Received: by 2002:a17:902:ef12:b0:295:5da6:600c with SMTP id d9443c01a7336-2a2f2206644mr16215745ad.2.1766122201828;
        Thu, 18 Dec 2025 21:30:01 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c667cesm9994865ad.18.2025.12.18.21.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 21:30:01 -0800 (PST)
Date: Fri, 19 Dec 2025 13:29:55 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
Message-ID: <tnvhnikpfxyjassrdsnqmpxlem3hnoepwxmp4hysfzqzl3wltw@7utx5hxc52th>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-4-yanglincheng@kylinos.cn>
 <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
X-Rspamd-Server: rspam02
X-Stat-Signature: a5ztft6miyx65dayn741xeqj36r7np66
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CB431C000F
X-HE-Tag: 1766122202-929437
X-HE-Meta: U2FsdGVkX190Hrsd0JUeuHvUtdCCoIR2rEcPVuIB6Kvdu/n4foTQC8dMTvZWx+lg5XF+oSAU59QZr9x3jYfVoe3uP8nxHowQqkh2A5eZmN/5UGOJHFcsM1pLhFW54q0rqQdZKuOvIf1kzsv7Hqw1ppoP9rdIof2C5jAMH0KTf8k+kShdSNBY48KUTuKjEnp8ibv0tAhJukiu099MLm2hTnjoQbv09CzRm0nDd2csVPRl41mBH+hq4GRcsXPyf+47r/6lOJpFowG0/7UzThNoeeXyBD/ANC/4n69kpGtb90udvJggvBXqcc0oBeyxZR194oL81EfWTiVzMI5/rtd+l1mQ2QD2M6R9R7Q5345uwS9CbjzXSf6Irkj4n+pAxzYuyjRRdKsgEM3CWG9r+X7JAuvCzMr/EopHwTkNLM2xIMiSOK71nm/4te7tIy/G+prXT8P00RvMFEDqyPwHWu0XGvQJCSH8g0mr1NSQcBUmNitoypRtMkE93rd2+3Sz+5sqFmLmez6wubR2XDYViyre2ZJp7s4HB9Wwf6aK+jm6+C6RQKR/l7eVVeNnRUKpJsluf1vlc5/0pLyhA0ljNE2cO1nrX6a5kMmhzcuuvHK+Cx3ElQDxTIRjU1ewqHhsa98HglzQJgTIkib27vtD0VI9QmUVxPk1IuDzHOzQmSq6ktztQpFBeVSPttiRqdXd/Q4/B6qD2U9fWv4QQrB/ysURCj5HK13WREHvaog4QG+PfUBAzddFTIwKnKVwkKxm6rq1gHIac+PrUfbxl70aGpgVEJmHbj4TqJ8wblsKuTBM9LR6nrecE2/jp9IE9YQYqQb9Qa+FRWthDHIfP619wI1ErC0uHOrw8+4gBG7kd2t4MlWQ2ecbKJoOrpURhpUqQZ03HC/3dYVX3G8boQrlpFui0B1U36rwwap4NxPrrOPLc9EuO/dJp9iqKDnmhB7VF/666KTIbkAEoXn8KEpW83E
 emt1rspw
 X57BnN1M2sF5KSEZD55cYA+n2n8ouKGmcKJbLgIU1wwbeDhkFiRFotECKFtLW0vrRR1774Asd8qbwH8ekkPOQIKo61d6B8xRU7f4/yo459zdi4dQ0mRxGk5BW1AiRbY72yhWseLcM0XnqUSyNFkIUwBQ9TgODjqVQ4JdghqK4F3U0MmJHYwWsel36jwj0ym6i4CLoVdaneY5s666JG33lEboyFm5mgp9pS9b9BbOPPInYF7BQCr1/ICT6oqdFl7e1ZhpMzI7Rsa4QQyXZLPqeI/q0YcBibcR8Tz0G6J3NNN4F9r78mdK8S3WR9CJ/udZjt4TF4d7CVDACNjSWBSkmVONxXSyqenyA1jHZey0MjqWUWQyp+g40xX69mqfSQ6HgSNMDLymIhYLj2nCuc72t0djET7JkDJpREfRDqY+0Xxhym+g4jLtOSVLianq3UZzrzPs62cB9NMHy4peF21SFnk6ll9iaf9Z06qzSLy+NSS3GfgwvxpTd2BvIk/I1ZXGMcYLw/7Bn9uBMW+N8Co0MQ8atFpezE5SUkSPDyRSJ+NG0Bquff9F1O+pxOnSyhQDO7Tk6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 10:31:58AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/15/25 10:04, Vernon Yang wrote:
> > For example, create three task: hot1 -> cold -> hot2. After all three
> > task are created, each allocate memory 128MB. the hot1/hot2 task
> > continuously access 128 MB memory, while the cold task only accesses
> > its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
> > still prioritizes scanning the cold task and only scans the hot2 task
> > after completing the scan of the cold task.
> >
> > So if the user has explicitly informed us via MADV_COLD/FREE that this
> > memory is cold or will be freed, it is appropriate for khugepaged to
> > scan it only at the latest possible moment, thereby avoiding unnecessary
> > scan and collapse operations to reducing CPU wastage.
> >
> > Here are the performance test results:
> > (Throughput bigger is better, other smaller is better)
> >
> > Testing on x86_64 machine:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
> > | cycles per access   |  4.91         |  2.07         | -57.84% |
> > | Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
> > | dTLB-load-misses    |  288966432    |  1292908      | -99.55% |
> >
> > Testing on qemu-system-x86_64 -enable-kvm:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > | cycles per access   |  7.23         |  2.12         | -70.68% |
> > | Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
> > | dTLB-load-misses    |  237406497    |  3189194      | -98.66% |
>
> Again, I also don't like that because you make assumptions on a full process
> based on some part of it's address space.
>
> E.g., if a library issues a MADV_COLD on some part of the memory the library
> manages, why should the remaining part of the process suffer as well?

Yes, you make a good point, thanks!

> This seems to be an heuristic focused on some specific workloads, no?

Right.

Could we use the VM_NOHUGEPAGE flag to indicate that this region should
not be collapsed, so that khugepaged can simply skip this VMA during
scanning? This way, it won't affect the remaining part of the task's
memory regions.

> --
> Cheers
>
> David

--
Thanks,
Vernon

