Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E88C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67FAC6B00B1; Thu,  7 Aug 2025 13:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607CF6B00B2; Thu,  7 Aug 2025 13:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545236B00B7; Thu,  7 Aug 2025 13:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 45CEA6B00B1
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:38:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09C7CBC91D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:38:19 +0000 (UTC)
X-FDA: 83750670318.01.E36955F
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 14476180007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:38:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RxSdcc2Z;
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754588297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7q3Q6iUm+lHnGSyrlBHDosOzs9eiv0aa0pxVcHH9CQ=;
	b=TtECDD9gvm57qLP5ml0obM1J51DrmWodto5Cda1OdchAA7kZuqnUEOeXK+U92nsozFtAk6
	bTg4e5r+uSlICgJeqO5fdxvgb9kWZgxbDd6UFFcFFAkmPGvPFYTEObT2DI46B8h8EAP0iJ
	UThp90W9QenhtXo2+5Ejv64eDVkWnbw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754588297; a=rsa-sha256;
	cv=none;
	b=17paPzAsBnruhAjbsrIgS5O7YI8pBKzl6dGe9S4KxPO+XxeDD1+ZL/bLtBPVJDrScALwsw
	x3KGKvhyc5gi1lWjpYLmd1jZARNDM9NWoIfQtr8a+oKU7uizXd4ln2qTUxTCkx+ILEirZS
	H+CHaRnitu5rY4+u9usDyhIqz0emt5A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RxSdcc2Z;
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61543b05b7cso1123a12.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 10:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754588295; x=1755193095; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7q3Q6iUm+lHnGSyrlBHDosOzs9eiv0aa0pxVcHH9CQ=;
        b=RxSdcc2ZJj60mzlJQuED+m7ANEJhaXOI+ohE5la0+YDTLnTAhj/5/f/dSR9N7fnN3i
         u0rml0mhg6QnZopNJYIq7lhUUKSo4es4hZXiW1V3nw6/ncEjdUed3/csLXhZuKqU9MEH
         krJd6/vrjduqP2+UqZ1+qizRY+9iSvUTZR7TbLf6skZ8Z7I9PHCKUGe6OizGMclqVWe2
         oP10X103B0YWRIR51wndrXpAplJFUXOX2Z3NC7Kyfo8/eBBW6kcP9ogoIzN+24WbJjKL
         7EKYZGQeBuPf4mmVENManhjnXwxZn6H6H56UWkVMa8Ez788n1S7tbJOWgMktsbCZKEf9
         BniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754588295; x=1755193095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7q3Q6iUm+lHnGSyrlBHDosOzs9eiv0aa0pxVcHH9CQ=;
        b=WjKuhVawXASkThSkHwAs4QIYkj7Q51dbrxvVq5Zd/vxjJY5QZ0t8eEDfi6ijnf6zfQ
         eP5IxMBQ04tAsPCeRlkTW67KuSAtg9Hrq3b0T35nYe4oUrzxVsqyKJQmWwxCAWdyj3Sq
         LMwGd92uJg1NxxE+iRv5Ky37GXE9Kb/CIi5/Q6VQGGs0/KrVJ94e3Oh28Q7NE8KzQur6
         NuNEt5PQKEuRDBZC+/hFgM2C3A20nd01NKDdZhic4pbN5ZvF2Bll0boLG7eSp3lp4gHN
         j8UQuNPdJBfaChxnzGT/Q+JNt3FG0ginma7+l5Lb46PJfgoJ5mieRPjR519I5aTcuc/V
         ohCA==
X-Forwarded-Encrypted: i=1; AJvYcCWWsc58gtHLNpH9CAa7rTwx4Jz1T5aT27SQU1+ALAS9Hhl2nzqE/l7crQafp7TklDJ4hNLuBosT0Q==@kvack.org
X-Gm-Message-State: AOJu0Yy4jE/2ePEm547TuUirczjH6lBeRkuhCk23Gdiheo0NdnUjl3Hc
	1GDRgIWW0Uol2a4PkoNDX0NCLNPbsRZJu/7slyicf7gX/8souIEd/bvPxb/Ccmdt0Kkh6eFsfV2
	lw3SfOZtWq4DO3ymcvMiyvkgSyEyRmHThYqT424JQ
X-Gm-Gg: ASbGncsopz6t9QR1ugKMumN9T+AIoggQigVY5FStp3AU1MkGx3ty7QPkBHUZU7TxweT
	4jXclD3xGFs6kdTEXRLsBS4mWxTRGZjDbAbJOsRXImmoS9MgW2fBovn+q6KnWsWXDVQYj0lje7Z
	izB65dWbmEtVdTSO0fV+mHeErzYMW+lJE2AJbwn1iyCgQ/cRBzQG+hYjPB04szP6RgeCc1IrAPH
	2lz/0PNcOr/OoRJsNW9Tip+ULYBwKVY/GM=
X-Google-Smtp-Source: AGHT+IEvIyaewpd1z50G14jfP2i5jSv0GcxRpXNr+oXtWD/QgpMt2hhkcUb0kWVZEwAn2vN3hoIdh8YmyHA5+kYPcBI=
X-Received: by 2002:a50:aa95:0:b0:607:d206:7657 with SMTP id
 4fb4d7f45d1cf-617e152e274mr1175a12.2.1754588294999; Thu, 07 Aug 2025 10:38:14
 -0700 (PDT)
MIME-Version: 1.0
References: <202508071609.4e743d7c-lkp@intel.com> <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
In-Reply-To: <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Thu, 7 Aug 2025 19:37:38 +0200
X-Gm-Features: Ac12FXzlXycSMR6_C9Cle-BO1qGA01-IsNhuqseD9fQKbf1SHEDGINCkLu6Sek0
Message-ID: <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
Subject: Re: [linus:master] [mm] f822a9a81a: stress-ng.bigheap.realloc_calls_per_sec
 37.3% regression
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: kernel test robot <oliver.sang@intel.com>, Dev Jain <dev.jain@arm.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Bang Li <libang.li@antgroup.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	bibo mao <maobibo@loongson.cn>, David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Ingo Molnar <mingo@kernel.org>, Lance Yang <ioworker0@gmail.com>, 
	Liam Howlett <liam.howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Peter Xu <peterx@redhat.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 14476180007
X-Stat-Signature: w438761b93ordq7za34cqibj4485qtf6
X-Rspam-User: 
X-HE-Tag: 1754588296-833876
X-HE-Meta: U2FsdGVkX1+EEhDR3DxckkAgDJKpUqihz0PiaWWhRkD0+QaYi+hjddwZMmcRHrKUIZgMzE/spI27xkNdQB234KvPST9xuINzCn+AnqfWYuAQ7stACW1tzNunOsRbFYykxjRqyFv2js9vqaXh5jeMOS/YaPQbQz3NO10X3mxpmv70uJhTlZ084/0b+w0/pmrXbFgf5zdaidggGY6ZopYaK6RV1eFQwjRHIWMZ7wiAet1BEEK0w9nZ1Tk7+kilJ+GH/LgxpOKlVviOsGHM9nzIT2gEt9gqMarGhlW4uKIV3m8lLkCqNRjIgalUNKOJ7TSnuFIjhOaFNR5A+ZthGnB2se+QY4bG+rYiWdZZMrqdcwOLNkSMO+y1gK625V4W/GLzUukI2UZnvzCn/cvsyCg1wTrADWbvHjVfL7TVuN+zKlQCv1WiB6zaef5JC/4Og2Bc1C8dWTga+1j95J/6KbuSVDv7ATj958UUZCoZOC8t7zRnJ2icEmnfQqx55ZZnSeixOCu8TaJIRbL7CRA/aZ0r1urZcAZGhKhuJhXyb40MyUeh7vvVzigzMx2i7dh/PUzRzyaFX0/R+13pVlEVwdrpHSxgMvNlfATuijvwPN2NtsWB5tkGhtvscwBmeu0EO28s5XhF3Bl6Vqjg4jSOKkcRsxR9GCy0tMqmYA5A3kotFFOqJMHYB+ngiw7bJh7ls6x4/WlvdfnhLI1BbnaZMb0uIVvSEzmAyfxIBI3nw4IASI61e3yZXBk58kbac22mMYxNGyVigdhMFqiJxqIG70KHlC8Dudv1hQomiew63oTskgA8rvopTGjiN81qLM/4VkpPYHu8EuKWARJCOmJqZdqC4auSdfgTb6h30oRgdy/fGq4HRUn6mzRic5NYyQsOYOnPaXUXqO4cf1I9b+VoHsfVjXPeVLlC2OewK6uHO3wWJN0JeXP0q2W0Se5mLVKyzcOFStCNU2Y4ChH1RKxWmZW
 bjx5jA/K
 U6Cg/yN2t8tIbRmj2vxf9BYuaAvlQt+DL24z6l+za0Yk9FFpkK4w/TM02c8z6M+dZrYSNkXuEyHhvZQvb1knoBceIZeatdxMUmraz95TJSZe4ghM2wIUwiq4u+c6uPSo08Jm5VE3zFf/BuR1aq/DyPg+SblxdOh2ITqB20eD3le5bc8pJH+WOSmFBuviUK+U6VbbI22kv/82WF0VJmkXtCH/R3qz/F0TZigxUaeHvh0FUzE3vBuKsBq7qqhzCSAB5UxjybEwzEXx7pWK8N2lY/jObFTLF4FLgvUoW1LH9ghPwWcVwi9lWYPgrXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 10:28=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
> > 94dab12d86cf77ff f822a9a81a31311d67f260aea96
> > ---------------- ---------------------------
> >          %stddev     %change         %stddev
> >              \          |                \
> >      13777 =C4=85 37%     +45.0%      19979 =C4=85 27%  numa-vmstat.nod=
e1.nr_slab_reclaimable
> >     367205            +2.3%     375703        vmstat.system.in
> >      55106 =C4=85 37%     +45.1%      79971 =C4=85 27%  numa-meminfo.no=
de1.KReclaimable
> >      55106 =C4=85 37%     +45.1%      79971 =C4=85 27%  numa-meminfo.no=
de1.SReclaimable
> >     559381           -37.3%     350757        stress-ng.bigheap.realloc=
_calls_per_sec
> >      11468            +1.2%      11603        stress-ng.time.system_tim=
e
> >     296.25            +4.5%     309.70        stress-ng.time.user_time
> >       0.81 =C4=85187%    -100.0%       0.00        perf-sched.sch_delay=
.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> >       9.36 =C4=85165%    -100.0%       0.00        perf-sched.sch_delay=
.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> >       0.81 =C4=85187%    -100.0%       0.00        perf-sched.wait_time=
.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> >       9.36 =C4=85165%    -100.0%       0.00        perf-sched.wait_time=
.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> >       5.50 =C4=85 17%    +390.9%      27.00 =C4=85 56%  perf-c2c.DRAM.l=
ocal
> >     388.50 =C4=85 10%    +114.7%     834.17 =C4=85 33%  perf-c2c.DRAM.r=
emote
> >       1214 =C4=85 13%    +107.3%       2517 =C4=85 31%  perf-c2c.HITM.l=
ocal
> >     135.00 =C4=85 19%    +130.9%     311.67 =C4=85 32%  perf-c2c.HITM.r=
emote
> >       1349 =C4=85 13%    +109.6%       2829 =C4=85 31%  perf-c2c.HITM.t=
otal
>
> Yeah this also looks pretty consistent too...

FWIW, HITM hat different meanings depending on exactly which
microarchitecture that test happened on; the message says it is from
Sapphire Rapids, which is a successor of Ice Lake, so HITM is less
meaningful than if it came from a pre-IceLake system (see
https://lore.kernel.org/all/CAG48ez3RmV6SsVw9oyTXxQXHp3rqtKDk2qwJWo9TGvXCq7=
Xr-w@mail.gmail.com/).

To me those numbers mainly look like you're accessing a lot more
cache-cold data. (On pre-IceLake they would indicate cacheline
bouncing, but I guess here they probably don't.) And that makes sense,
since before the patch, this path was just moving PTEs around without
looking at the associated pages/folios; basically more or less like a
memcpy() on x86-64. But after the patch, for every 8 bytes that you
copy, you have to load a cacheline from the vmemmap to get the page.

