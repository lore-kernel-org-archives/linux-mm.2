Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87345C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 22:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66EF6B008A; Fri, 25 Jul 2025 18:37:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1EA86B008C; Fri, 25 Jul 2025 18:37:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D7F6B0092; Fri, 25 Jul 2025 18:37:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 835EC6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:37:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 541115BDE3
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:37:51 +0000 (UTC)
X-FDA: 83704250742.01.142EDD8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F59E140007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:37:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HLrWBITs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753483069; a=rsa-sha256;
	cv=none;
	b=Oo7J43tbA0stA2KAPmiMgRHTV91D1fLVv258oTHzmZ38Oup01CzTDDBo4iAtt7dY0pO8Do
	bLa5/wgSjEa9M0ifVGu8KBkcMtUC30IXR2wfsKfENQoj2TqsjvUSnPTYMA4Yb1OEhFDr1g
	D8auvs4z44Wz947HcpepK3INPEvf48g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HLrWBITs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753483069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxMQJ32P9TM5LgrkFm1FLN9ED8pQui3GJRtf4HfC5h4=;
	b=gnOq4TtltLEWxjgEGs70ENRWnAJWc3UHGzDkLIgaaH46nrLc8lvJCk7//tAZYGkM/bN6W2
	fr1+AwKOENKNuGz1nN2pfTYS8EzIIJdXg1OfXQBaCFX9rgqzNJiU2an+TWMHPzrgPWsgEm
	DrMEFKHpCU/ED0jNGH/E025hj4lWQPo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753483068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PxMQJ32P9TM5LgrkFm1FLN9ED8pQui3GJRtf4HfC5h4=;
	b=HLrWBITsS8zgU/vH4iAPhs4UCRrHuraaL9dC619wNHtl3I5VJ+3xCqVdoggmjWEQm5ZKjA
	lrvNkjGr2eESy6/hfbeqjExx4vrPUdWgCvVHAVsN9p+Fc88fbXL4ypdq+/yFbLQp53O6lN
	/GeIUDt6Dhd1fznXArGUxYHZDpi35cA=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-9nRyzZtMOBqmrEDrPePgMA-1; Fri, 25 Jul 2025 18:37:47 -0400
X-MC-Unique: 9nRyzZtMOBqmrEDrPePgMA-1
X-Mimecast-MFC-AGG-ID: 9nRyzZtMOBqmrEDrPePgMA_1753483067
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7194c6ce830so40860687b3.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753483067; x=1754087867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxMQJ32P9TM5LgrkFm1FLN9ED8pQui3GJRtf4HfC5h4=;
        b=ccjzcw2kEFnpGrrJtlhpO4N72TnfBUjN0GksmZGjeZeApxkMxs/7qO/uDngVm7Yzo8
         guV7VwpP/pikZC8AELCBQJrfsrRT1sHSWYzQffVSdFxLEYwO/5dm4roLB7fvizEjwZOJ
         OPugCA3J14xZnvXpPMoijk7UKH4S8/5Tyop9aBGlJVJCtLJdkWTOCllmBjsoyHaX3n9s
         P5QYVgGTKFHl6xnJr0JE9yx2O7cgkRr+9WlUX15k10/PwRxE4nLluGS7vg2/WcntpqdT
         J9UsdClTNjm9KNIglx5ZXcIL3UAQlSZmVLguLALn8uaC0fhfwhIpW47L/qeV6q7E01BX
         fHmg==
X-Gm-Message-State: AOJu0YzU/1aPfBb6oC6afUwsnpAZ0DvG6O7f2UlNChnJfcA6bAKDY0Yq
	cJLJVsNBaw5lvLe9GWfRhJYxAqI1xMqXOol0tGmwirVeiaHo2IbJBzyY4ua/UQnDYuDvhrOWMAF
	Hy7bQ2jpgijk37t6ezS+P5ZHVqktntwxLk+JI0nwlWd08mio19o2bCetLNSd/2dW9wlOfaxS/O/
	PNkd0HnLLkmVH3D+H12QtABtkEQ0M=
X-Gm-Gg: ASbGncvcIfG0jwEzAhbgQZTRgVJicgsGYpion7JdUTzpX8VCYhkCboIFuiziiI9Eaj1
	YT/YC/p5Q6ae/OEen2CV9FFdMBjQnGzF4Y3VRjvI9I/CCxHYFcqcy7Vyy0bTfs1Ay7caN77YRz+
	2cjMvi0m/9at74XEKXCostLCE=
X-Received: by 2002:a05:690c:4513:b0:714:3e:f424 with SMTP id 00721157ae682-719e3461242mr52042977b3.35.1753483066679;
        Fri, 25 Jul 2025 15:37:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfOqA9QhdPY+M0vEESx6VKf5ml2IvqKk9pj3fqjSjpp95LtZTi4ZjJtdc1Jt2Guhr63gv18jpOEl7GBVnJQNw=
X-Received: by 2002:a05:690c:4513:b0:714:3e:f424 with SMTP id
 00721157ae682-719e3461242mr52042437b3.35.1753483066311; Fri, 25 Jul 2025
 15:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250714003207.113275-1-npache@redhat.com> <20250714003207.113275-6-npache@redhat.com>
 <f87dd075-59e1-463f-bc36-0f6582abf31c@lucifer.local>
In-Reply-To: <f87dd075-59e1-463f-bc36-0f6582abf31c@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Fri, 25 Jul 2025 16:37:20 -0600
X-Gm-Features: Ac12FXy2-qDATzXIVs0g2RONSMMgciAzDMU4oBvRHpQajDJJel4xlOl2pw4wSCs
Message-ID: <CAA1CXcD0qKMqR4KSD-uqVORk=_gB=JwfkQ5owYV792B5Ng788A@mail.gmail.com>
Subject: Re: [PATCH v9 05/14] khugepaged: generalize __collapse_huge_page_*
 for mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LAjRFg7Fa5OhQPlRk3rG_z-b1OYh09K7fm4L2ZY6Yy0_1753483067
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1F59E140007
X-Stat-Signature: en3dcwsq9p17prd3wtg8374z7e7i3gxc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753483068-546916
X-HE-Meta: U2FsdGVkX19utRDUkPm12HkLizjGa3PIYbgfCMzTh1zm1pZNGKftfFyfdj2Qasu+nonyDuWoZEA1qeCx6Bisjuk9zbJyZh042vi0rB8h9SvwvEE4Sf9Pn+chtre42SKq5WodqR3gUnMMaf6KSOLHavlDuAdbXB9M0BDo11jOOEy2kVx3WEdoKdoUJKcAkjGRD4u+1WWpavHfkiXlYowr2rtn/6Om6v28kFCITxqJEYLOikfd3nzfkbDZztMN4oEIsT+cFTj73sYFHbKFmhmqYyYcrKaG2OfvLXrEzAUMscpFg2JlWbV4xuJzAGNZQU+JspegGEw0w/8WVtXXWTAYtZgSYy6z0FvVFNi3q5Wyt5YI7Fil+53c/ekJrDW9uaYbah3XLOYc4F8L0P4DsEt/Ex6qkYKFMIWSTRJrjatMeTrDbUhKsixtJAyVzSe9Yu9y1jImuZXaDWCMZrfJN0ozCs1VQrwW00gdNBxabfFeCirOYEXPL/L5of7RuG4w9UV5pOOSsZW1iw/3fnwvROzUNxEoVxpTdqXmCWZnzrZTRiqBcUnlnVITPDLMysodoXiREX5exGFatbaKOCHCSG1Ubn/5oUeZOB0SjSeoGw1FgYi2bWKYNpGPBlFaf/+0ApVWOiFH7+m2MxvS2LiqCNMhDm01wjlDdHE5S6kUI/3FUV4E4QOVk0zg//UBZ2QPOMDvprZmMyW5Sz+uWkcHi8CNVbTZuR0DaydC428RCPYJyU2CXimtL5SkGl24TNBWokeNCO/GSrTJ4+UticYyuYSp/Zkb6PlFkKSZPDd0yZvoUQOyA5LTzlqF527AjobTCgrrSN9MtUjvaPASm3c5eUHFR9TgQz3Eocr4Hfk2wb+YRtUlad+iI0f5YPdDV43nb2qH3vnqZGRp40iD6+YIa2osNbBcjgV2msQYIr0Km7Yyc5C26+SVAFdZ3ASXsC7ByQiV4Vn/aSSo9o9O7nUkxpo
 KxpU+PHX
 5h9roVxNTb1aHv0lTz+9BbbTdkSn8UD2Ctr3c+EFAzrIa8iHdnKZY2y7HSFeI1hJpRpMQKIc0/YYjGVmyTPJOSkDOZsGrVmLQncjucdve0fuExNmC9w4iduq3MhLFATRMUtX8J4+I1TcGYw5y+T9bY9VyoWnx2T+tW/3ymXqmvgvHHIas0gJZeMgoTNxZ3tnKOYoKatoN/UpZawkn8EpdWrMs5QGue6GduFRXStMQTWvUZetQqS5YmI8BSR2ChURkjtadh1EnwzOMXB8tpXteB5342XwdVWWXhW/t1RD3eOmD4Qor8JfnWlHHmiBJyFSOxWtKIxUkGSmeRMVCoCLaODCpUmAvW5KgWb7lAPp5Nh9A/V+FGYsJRjagajcq9jqlfRn05ClarfAEdQk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 10:15=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> FYI this seems to conflict on mm-new with Dev's "khugepaged: optimize
> __collapse_huge_page_copy_succeeded() by PTE batching" patch.
Yes, I did notice this last time I pulled. I haven't taken the time to
resolve it, but will shortly. I want to make sure I do it correctly
and that these two dont conflict in any undesirable way !

Cheers,
-- Nico
>


