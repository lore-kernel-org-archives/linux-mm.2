Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6019EEE36B0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B93E6B0088; Thu, 12 Feb 2026 12:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7671A6B0089; Thu, 12 Feb 2026 12:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E9C6B008A; Thu, 12 Feb 2026 12:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 516226B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:39:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22B4E8ACF5
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:39:17 +0000 (UTC)
X-FDA: 84436515954.14.5FFE391
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2917B100005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:39:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zh+4qB3q;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770917955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmDSu9rHdkQKCyukTIemQGDTasI1Oy6wKb2WDyCVFJM=;
	b=5BiJfnJYdW+5exeiHzP3PLvg5GL/USwLKVa/icAnhfVqQ/dTKj84Ua/D2IUTxPbwew/LX3
	EcAplcU8tvcTr9E8EAxpGCaVstW7uyIjodzU5JuO107Rl1zwcdVwMnUeUBZNgf/+xW5i99
	ZdBi9KTvbfdSmLMp/HNAa1xDYFwKIUw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zh+4qB3q;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770917955; a=rsa-sha256;
	cv=pass;
	b=QustInQm06w0J8ZwebfZ0pvPIVSD5g2U5atGqibW9lUxNgTOx7HY+pTNCZHeh9xNuO0T9V
	+eOMKK3xhFRHmae20aMimhXKC4P3xjKrUGmngL4iy4oZrUj2J/gh4977FAWyPQWBhNJLHH
	XmXMxq4ooYL+kzWh6VeFuqeF4JytpLY=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-480706554beso1034235e9.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:39:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770917954; cv=none;
        d=google.com; s=arc-20240605;
        b=NLtZClRMswicKAAbmA2juxVxAQsSFi1MoxjbcHXJNLdHOsernoG7+1uXSVBCCbE9Di
         GL9OokPLB+rtlNi1UYXr2oFGRLESpFgsLAuKuWpSPalWVH+UQKCk2XJy8ylIhzRnVn/4
         XLXrzxnOKlnP4vJffU07gHU60wyUuAoLaEIr5TA8xoV4jVNXGXXShsVuI5rByCtlRVKB
         3jffZW8k6cv2JhmyP8JURyLXzW8TEa7V881gP3tvGnY3iO7nLBKdiCVDKEe2j9c3eVGu
         v3GEf2Py21wHIQPDMxY9GGh4qUaD9Z2MH5IH2uuudAg1osIi7zSieLSQ+8uHLgkmm47R
         eYYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PmDSu9rHdkQKCyukTIemQGDTasI1Oy6wKb2WDyCVFJM=;
        fh=owzbJn1ZYHdmsJlNv+Nlee6aH2/aKres9mXirmEu4ks=;
        b=bpJAMA2Yv3epCCISr4hCxdyczLYYuwWGQ+vZp9qsxxtiPAMWzQW90Jx2cIXl/YC45y
         PCy+4C8QpENiz6CFQGqBW1KO20TCOFYed/LeJUNR7PubN4RFDEioi4tUQYUnwZYBsN6S
         soPsrOXrXdWOfVTCfRYTOrcogzhBR99K9xzrjnAKkYAESKdup8trqfSGQcVPnDuUxiy1
         IYy1IehidECPDZ8PdjRYOp4DDKxe5b3q4Kia+iyx6I7eBQprFl90vwRg581pQzwwPfxC
         /p87AgfJYFk7jgCw+/HlNMfB2kO9X/WEgeYrEAWXD6wY3ftscczIMoHrKeI9KnwAlksT
         e2Rg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770917954; x=1771522754; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PmDSu9rHdkQKCyukTIemQGDTasI1Oy6wKb2WDyCVFJM=;
        b=Zh+4qB3q8Bz4yOrHKq+wxswUMggtrkHB76yUoiJN7sAnb8PqVcKd7b4eONJS46PPlb
         XzetbtWPy7y8IaASgfK7Ghr0ilqibC+r/jps/9SHpQIiuLrJKp/E6un/S0VJ1WWZImu2
         FVeHnP2i1EcDMiQNhzCPL7mAJ9OYmd21JR44YYPAENXnkh4gw5DM2npWEl+XnPq5Z0L+
         GDKUvIP5r1V76WUPZ4so9/7OGChHlPhoKu3lTsnjRNA8B92MGwRk841bZ8en9ijCg35L
         sIEyvutNoLM7OkX7iaRpkq7nqABFdcflggoj093UhdQaXxJys8coa189ZOD6U1NEmDHs
         ziKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770917954; x=1771522754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PmDSu9rHdkQKCyukTIemQGDTasI1Oy6wKb2WDyCVFJM=;
        b=hJwdaKix/Q3wKRhc2mq0xFzUfpOKp7+M8cyPH0Sa94ffJaD+6g+yJ4iWjbxBU10mG0
         yaam/+/wDw/s4Xj0gCJ4q5ViiOjDuVkQX15TO5ibjQ+EckJrf1bfZyBvlNJTadxXw8qr
         wpIXokf5l9Nf4iJTo5m5biMVTSOQyIoJkn2/NRn3v6/gxkpVmULrMl4yrnJznM0G5heN
         3EFz7NZY4/fjEQOy7O3UjTXgR9x3pKs0Y71SK3a5owKeRdd/u+jrZyEHghNy6yIs4LqI
         2skUTWnGZpTaR6LpaXKzftIkELlA9RPEpxG/kY7IvMsZ54icPRLFcVH0injyzT6cnig8
         hapg==
X-Gm-Message-State: AOJu0YyN4bPmkHwkb4xL6AEL5Gtk/dqMFBYFvflvViyem3TaRzGneINY
	IYmpaCTlnpxepjdIsajDgUdey2v3e0yIWQbuKwMtV3fW4+bWFpmvEUQ5eVca321GuPJzhdyCtyH
	P9ZilglE58K0d4t1RZCNVJ1AoTvWmdgo=
X-Gm-Gg: AZuq6aJiwjnXdcgIjGwTub/WA0FvjMlMWw2u9uRblCe9i5I1iaU/5A3QmlUteYwKWLY
	R6qUTA3VnhZbyzaHDbHzC8zQ/JCzIF0+F4HvYesB8VUpHm1ohkaqC/Knxd+pEQdXJB5S+jfHTtg
	uVRe27Eu0REPFwMsmx+uFcr7wEv22MGoW9zEpX4bk1KjqOILe8/oca3LQZOY4moDFqurTtFAf1A
	nvmGNuXHxgPfnvuZ0SjIaIVcbdLKQVABcMrQG9Ecl54pe0L7/96qzwfw86gF+DNPw04eBxW1qnu
	q0MG2NRibCSgjop0VH6KAieA04LZndIj7uIZ1QE=
X-Received: by 2002:a05:6000:4024:b0:436:1b1:6cbb with SMTP id
 ffacd0b85a97d-4378aa01106mr5591885f8f.7.1770917953341; Thu, 12 Feb 2026
 09:39:13 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-1-nphamcs@gmail.com> <CAKEwX=OvuVPJzQsSQm8F+zsRgJFnbMmW2JMJbGebp=U8+jMRYA@mail.gmail.com>
 <13e3cada-60a3-4451-ab7e-16dfbab3c352@kernel.org> <CAKEwX=Pww3ZNw=VGZBa46NhKuvefRM7wnVuZy0aADoCoE1KSzA@mail.gmail.com>
In-Reply-To: <CAKEwX=Pww3ZNw=VGZBa46NhKuvefRM7wnVuZy0aADoCoE1KSzA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 12 Feb 2026 09:39:02 -0800
X-Gm-Features: AZwV_QinV0WPB7Xpdl--Xq3J6j8mlfT34orj9Pvsm2hWI8SWmVi_aDb838NayvE
Message-ID: <CAKEwX=Oqn5vZrYnURqwoNBhBmA5xU9jy5-5ti8vzFs2DHDaWYg@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	len.brown@intel.com, chengming.zhou@linux.dev, kasong@tencent.com, 
	chrisl@kernel.org, huang.ying.caritas@gmail.com, ryan.roberts@arm.com, 
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk, baohua@kernel.org, 
	bhe@redhat.com, osalvador@suse.de, lorenzo.stoakes@oracle.com, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, tglx@kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, lenb@kernel.org, 
	Zi Yan <ziy@nvidia.com>, dev.jain@arm.com, lance.yang@linux.dev, 
	matthew.brost@intel.com, rakie.kim@sk.com, byungchul@sk.com, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, apopple@nvidia.com, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2917B100005
X-Stat-Signature: osbe1msknnydj5xhnd5dr8y39demummh
X-Rspam-User: 
X-HE-Tag: 1770917954-945207
X-HE-Meta: U2FsdGVkX18mLlude+XUqy/wv4WMz/2nRsx+BCCBh1mVSuPbieL7CAUSpwona/O5YArYEWFGsO+luejyusW+f75e0JwqO037wkTAkVFO2ULtQ23mDoQdDSlAUCRDm8ijh2jeEHh+ymd8NSn7r4gqb10YhsZmyoHMr+n3iquZhJR/CUqwZpmpr1EZ4aL5oxqpUEbAmGIvy6jnQzm98K901P6285WHqnNeHLSKsrF/UfQnuUS+rNQllm9SxKXAaszbr/WZLY4Ic9xK0diGTl+wCtoEFHMNkzA+kEx9SCtBiOp8dAl72I9UgSWgiw/UUgDoblJ6X+4if5lF5vUunuxu4VU6JLSjLozM2O2uK2LmmtxliB6eiL448H6Uo2lSMsBDC7ap/h+BkW8f7+PWjWZ5ycjYzPl6jzG1QuV3Lb2osAmQzHHjPp38qVsTlcb6DRGBg4tDO0+eAVv/hIMjlVWUwUui3jpwM1AGiLn1CYce6iCxA6+ZkbNjvzGcE094NsP3mAhlJ2bPzawAwj7U9cO0DeiV4caI5vp3mkbjSUo74XyejWtkjWM6kgmEd2y67w0ERItlI7RKs/9Z7I04mlvVu3xOk3nTUlXoOTivKP/p9wmNx9wGJ9b2YeP82xRyXbIxDf5jpp8UY0q1Ots0qZY1Xq37rGShap5nJliPkZ+GvTXTcHHLE46yL9mgmoacQCqiBq2LwbdZ4lDTS1ywsJSdJi7nddqarKOpbJgLanz0LQlAqaBDu+cCX35Kokw1uiud2pZPEjboym6S84bRotZLRk4AMX5DyQxcI/LQic3XUpcO1b9F/smtTE/MQkYebzWMr/fjD3d8U421jUnbDZWeNWP8li7WQLnOILnozxRHenksvtH+vEPBT6RhMki43b67MMwbbwVrEOOPgNI9bwGtTzkol9oL8cLheKtz8fj/2e1Qvhy+oniMqwUjSW3hQP0Bmx01qrE9eagNwNurOy6
 kIuXRflp
 jqwqV8gtVm0H6cQyaqpUk33hT7SgCvW3k0hKlHx0XUm0h5PumFFfBRtRUXnZPi9PbyvJXdV8ct5A8lC3+J3gBkSEUL2vC7HAcDChPFQKvrJjVMTSobFAedCFNplGyuhxahpD3MbGQx+2NLj5Nmd4sH/PqKk0KzYbVub9CFL5wW4sAqf4BWSbvBsXAZuMasyvW/gqoKrpTfsPrWtw5UxE0b3/Ym5uYv5qYBbexwgyTZ8ryPkwUmm7D2H8iHe/p5P/iPn2Ypz5G/vKCWm6RU0Vz2LxYW9hwTOc25axtflpOS+6GlO0wPb/0AnxCOI7wxxCigHQHebyBFt9MuTJzJZbgzynXO3QgVaAvEm8NxfcAv7h/5CHlATx5TnuWhklofGnyym+6ttz8P839mORy13J36K7trGgPSesmG0qH7oOv05E47HNksVwvaWHRUcHjrAMwwg4Glxv0uT5w4xOdmNplRot6QaOSEB6QRmZjIuD/5ZLtgatQy4NEYuYPT/K35FrtpzQmp0ngVF1FGKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 9:29=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Feb 12, 2026 at 4:23=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >>
> > Are you CCing all maintainers that get_maintainers.pl suggests you to c=
c?
> >
> > --
> > Cheers,
> >
> > David
>
> I hope so... did I miss someone? If so, my apologies - I manually add
> them one at a time to be completely honest. The list is huge...
>
> I'll probably use a script to convert that huge output next time into "--=
cc".
>

Ok let's try... this :) Probably should have done it from the start,
but better late than never...

Not sure who was missing from the first run - my apologies if I did
that.... I'll be more careful with huge cc list next time and just
scriptify it.

