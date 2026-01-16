Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D05D2C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2363E6B0005; Fri, 16 Jan 2026 11:45:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E08C6B0088; Fri, 16 Jan 2026 11:45:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120FA6B008A; Fri, 16 Jan 2026 11:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 031326B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:45:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC80E56F2F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:45:07 +0000 (UTC)
X-FDA: 84338401854.18.F87F1B5
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id D3FC820007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:45:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eJ5I35i5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768581905; a=rsa-sha256;
	cv=none;
	b=sphjyb1kV5Fk/8XbIHNevfIcvhSR4P6T52QYZe93kjIv+XP/TF4Q/sVnUsjAIAct+Vjust
	C3KiO3iU83vRM3dfZHuKRJMjdZpJt6wO2dalfq4Y4Qs/K9pwkZc1ZrkbrmTITxROQ7uOl/
	T6gPZvV+n0WVR/fTjuA+66pFYGDRvgc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eJ5I35i5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768581905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48ahlDlvXHvN2XBj96iMS5cMBmYr8ePFnJit57gKV6M=;
	b=2e/cng8nbKKR89J/Jhp5+qVmew2IFHvjfj92wC8++EOiR9+22NdoJ1HWcynw3vlis07s9Z
	o5h7L4miPC1jxmCZvvWiFrivDixUNCcbsoXyf20rAu2nfV1zbgB+OjyTxC+uUKVnnuXjLY
	M4KAzN03eig8l0HKg5l06wsXt4mkbJE=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6420c0cf4abso2018168d50.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768581905; x=1769186705; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48ahlDlvXHvN2XBj96iMS5cMBmYr8ePFnJit57gKV6M=;
        b=eJ5I35i5GG0Zccvf8GbLKYfNpOfBe6bgl7KQUUFHjCd3opJvl8uEiIDARadcyQxkCV
         qkIo/9c3lzkbFHcW/CjDdH4sv1rMhgeA+TBfnFkpEYNXSDrohqGm5tnf8OqA6F+wsGHK
         tGJlp2KYfW3OQBfZoFPUDqnQZqM6lcDlkAw8rrWPDpK3UbnO3alww/+FK0GGIVoXjq7V
         gFpQG7x7G4qHgBSJhwINYCcOktwV7EfJmAu/swTZLbF15ro4zrUaRQNY4qbGumCbHVNc
         r/3/x7xvT0v4XV2MtUP5KEZYyIRtICsXK0z2Dhm1GLCb4VQ3tP27AMRoUN+O7fEen0Cv
         rQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768581905; x=1769186705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=48ahlDlvXHvN2XBj96iMS5cMBmYr8ePFnJit57gKV6M=;
        b=p6Cq99WI5nUEky79egfQ8pw2JggXk+VhvjiIXyNT2m/LxxyEjI++fF5FZEv6Y31Ipk
         xs8Rr4fdQsLR4xbhMFHsXIAxT5PsXthewkPp9aScAI0oFKatQsDNe4HPtJ2gnGlPpOxO
         h9RyNovIbGeswjMWJ3E1tPi/k5iEAo53/M6pDNDOWKMO09QAsaxyZ02iqNe8k7THzwO+
         KPDaErfJ4xBJweE6VC+oVML4yMPu1G8tgaDbpMc6Gal7bwfEe9Ow/piMG4Bf+nUzQ8tW
         twrK8uqOPzl47A+zbLfEzyxSGiLUoG1y+lR2mCeZVNLAyHIaUZv3l2lotJ1JLUQEL56P
         gvOw==
X-Forwarded-Encrypted: i=1; AJvYcCVhLRzG071Fx4A89Xcly+joInKbxV//dVK6JCXLZkvC+B/ucxKqESmPrF96E2pfZG0ad/kljFjiww==@kvack.org
X-Gm-Message-State: AOJu0Yzvo51ugJLx2uZEhME3zO3ZbYJb0Kmycquns6aF4YWuzLCgkSuG
	cjF2TFzY4Ov7xFEnCUvyApZxtSIX/j+G4oXMwMdL9DoFhG+pIvt5SVxj
X-Gm-Gg: AY/fxX4VOfUvilV8y8PBYerRLBaj55dABpWcGwGh8M2jTRYDyIE0AgmOAQIJFIULgGj
	GqE3BD3tVVQEzvpxOgIuqAigK0mu87lfPcFYzv0me9hn0JQD6H8g6PFwgqDFXYDIc4cJBhCBd6N
	LxVf3E09gJTZ/c7T6xPEkNm8NCdK/9YrgEmKbca0pEczcqPypw38XoLN7hLDHNBJZvXH4Rxk1g2
	dSkDZgkyI2dBTmrpcD026cNteNFuNhwOOK+9OljMUsDmS5xElIqI3CD1OWwLMqFpK4IsTwbHG5O
	TiMS1ASXduoQEBjFaLzpaBG5Wfnf4wuIgAJ1K2aex3Wm/qg0NIuL1TPjprrkTGKomMrW99znP2G
	kwxjTjCjGy2ID2IeNn015pOcXrdDAAsw06iJObgnNUx8z+wLE4ZQyvKH3yV6lZL+FbSjyNgT/f3
	yywzS4D8X3Rw==
X-Received: by 2002:a05:690c:398:b0:788:14a2:8bda with SMTP id 00721157ae682-793c536b298mr34222817b3.38.1768581904585;
        Fri, 16 Jan 2026 08:45:04 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c68bec97sm10523647b3.50.2026.01.16.08.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 08:45:04 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm/hugetlb: Remove unnecessary if condition
Date: Fri, 16 Jan 2026 11:45:01 -0500
Message-ID: <20260116164502.517338-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116013940.71199-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D3FC820007
X-Rspamd-Server: rspam06
X-Stat-Signature: fy34bjfbxbiy1sy5f7qbcrjcksft9483
X-Rspam-User: 
X-HE-Tag: 1768581905-394776
X-HE-Meta: U2FsdGVkX1/WocieUyJmkUn6HkQ86A1YX6U0IXOf+ybwgzLbHbvm65VYwqddS/1MgqtuubG4672f/XPyXX1oji4aGlGPtfBh2ycOFwdOkJVEcZQq3GzX5c8qB121kcBEZNi3lWyZuExgSgoGhu1ZpU6BPjw1n31aw5VsTCiNX9SKsfCb3Mm/OxsZIFOJ+xSgDAnm1vQFVvC0cONVLKJ5nR9eAOFp27C1Pw4GUWTIdVsGVX+NuLIhWO5rzT5/6Ag4jlR6P9HbugFQhTQXGuf+Y2R+fTBJkqAsX//k3ZHzoHQHI6Pt3aevdGL8UCSucqsK6AOx4sKxGNlx+3tkATLbV9W2CfE4dBFUZBEsjtiGzElmJcwQgm/zdvQcEB7KJsoxmrE0GzOqELbPX74r+E81kL4p+Nd2QCvPSi4y2IcoRIbV5RT1Z9UgdLvEH3h+MISJ8Bj6+h3+/KJiEAxEa0Otov4Tn7ezxT4HqRae4D0zS81gkdt2EiPQzWfdNQMqVUoeKCByYzBfQvVyzgbq0ckDMduf9SER6sTXt5yqGylHXKX70aceBDhwGKEkltf8/9eNbipyfqB4sKEYR5Y3niFFrXcv4M4vcvZlbQV5Eqxiv5BuBh90wdLkYdN0qFmBbiW72yzAnCwVcEX58j6Lk4PuMsgrp2sX0pOYYqpM0bPdNM9mQ9UjSdha1rCJ61D3wwJFqZ7dMmHPoye94SfYpUw6YFVFbs+rcEYF7WdJnY70rz1mzUbV5T91YG50V5TukpY/RUWW5hIAojUn+tFqaIapT7uwNAq37pZZTLux2zTZk2Z4V+Z2DmkZWPvMIKNHXoc/m2EdsQk94+2PW0+uZD/fjV8DDyA4UxRaS9gi4oxoNFtW2tqMD0W/nkVi4hQ2crrFg+QW4WapZnBwdJt/q3TJHryIVnCieFicMA4RfktfNZL+29BR2XK3ch2KFtqBJBt4TBv8eNTZZRPrsw2lxXo
 vCyvs+HF
 IaMatXIfoGfI4GbESirL6P29ZM6xhfIc2c9/u0YO6tjAGZIwLuOLtxaK3vfGnYzpmBp6tPTH1myM3knnwlk1YrmWxj6xO567aZU9er6mQDhNbJjlodXRQZXTvcIvg786Olw6iqNU/Ir/TMhpWdT0SyNkyciZo63VLFIxMzWRqEypnFj3hQKapnryks0i1TrUbqGPl+eWGyp21rAG7zfOHTdpk1FW2D5wr+0jdJnt6S9CwdK56twTpCwXPO0aRNZotc4qu32t8KR1y8Gm9UtoLDhDylRgyEImMPBSSUFIJw6rO8gH+MrtrZtEZTuJy2af6lpfr4DYzGnzz02fcQptWoy/UIP6gUHKKbNBxdzAwA0ElngK8Toz8QnoZjiX2fcBh+wnL/jAJb+DKynXgRMMHdi9eyUqE++MQzNwcb78g7h8N7GbR+DSIB8CEXyMEP9ZUAKQTuXIFWUtWB0Gi4qssIXO4AuMLjSIKAWaoWo9wAnpLhS/RgnztC4WHdvGkKd7/pcn9L+3LuAjvN+4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 17:39:39 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 15 Jan 2026 13:14:36 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > if (map_chg) is always true, since it is nested in another if statement
> > which checks for it already. Remove the check and un-indent for readability.
> > 
> > if (unlikely(map_chg == MAP_CHG_NEEDED && retval == 0)) {
> > 	...
> > 
> > 	if (map_chg) {
> > 		...
> > 	}
> > }
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

Thank you, SJ!

> > ---
> >  mm/hugetlb.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 88b9e997c9da..432a5054ca1d 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -3019,13 +3019,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
> >  
> >  			rsv_adjust = hugepage_subpool_put_pages(spool, 1);
> >  			hugetlb_acct_memory(h, -rsv_adjust);
> > -			if (map_chg) {
> > -				spin_lock_irq(&hugetlb_lock);
> > -				hugetlb_cgroup_uncharge_folio_rsvd(
> > -				    hstate_index(h), pages_per_huge_page(h),
> > -				    folio);
> > -				spin_unlock_irq(&hugetlb_lock);
> > -			}
> > +			spin_lock_irq(&hugetlb_lock);
> > +			hugetlb_cgroup_uncharge_folio_rsvd(
> > +			    hstate_index(h), pages_per_huge_page(h),
> > +			    folio);
> 
> Nit.  Good chance to reduce one more line by putting 'folio' on the upper line?

Ack, will include in the next version of this : -) I hope you have a great day!
Joshua

