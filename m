Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D052C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362AF6B008C; Tue, 22 Sep 2026 11:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3394D6B009B; Tue, 22 Sep 2026 11:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228496B009D; Tue, 22 Sep 2026 11:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB1806B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:14:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FCFF1C2DED
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:14:01 +0000 (UTC)
X-FDA: 85241743482.06.5BE2D40
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf12.hostedemail.com (Postfix) with ESMTP id 528EA40002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:13:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Evq3fvVO;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.231.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790090039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TzjZBDA5iUg3ko8RNpB6y9UNWK4AO1BnhWiKj7vnaJU=;
	b=AMNxfFMv85W1whlsXsWQB6yrZepapK3rkPyY0dR0cbFec+fEgR2gj1Zq6ezvk3/Qm+c6SX
	yF+XjubK87TJeJkOnDB2g8Lq80xx9rFo6ydsjpAkpGb8DzGDTpGJwVw+1TIIuNQ/SlNQ+T
	gpg2sAP4oLSyDOy/DStsy1SXJ1GpWL4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Evq3fvVO;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.231.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790090039;
	b=OEcfUrlbl3H2xNDDXHVNTiKE2SVLsDuw6oPCrTaW23/ApFNAatn7J6+oFeB3+XoJe7IXEJ
	2wkUbA2l/c3OVo/7gJCkcszGR1uEU2+mZmSDN7C17vAT6YKuGpoy4yY1u4ImvcjwjtliDI
	SNBIOjfZeAF331q8XuEXo0HHN+hs7iM=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c0776592e3so3525b6e.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790090038; x=1790694838; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TzjZBDA5iUg3ko8RNpB6y9UNWK4AO1BnhWiKj7vnaJU=;
        b=Evq3fvVOMvLQSQ8iwEXnMHMJEwDLwRmGQA/AobdYMRLBTeBLj44d+pQhR1dbTepx/m
         zfCXpVxh/0zUJ6pnddA+V/oPfKkcTAeq8vj1EtuUAHhAXnophj+p4aNqnfyd2WPIFKqp
         fRB0c8uXpBqQXuhvKwCQF/HiE/C7Kvyx6a3tktbdoqDD29oYxvq2hLeRk7tZHVc74DhY
         OF7mfyIxqLoEsYOZEdmd1m/MikeROq64AyeqwUltNY7vW/1PPQdApsEKoqKh5ucRm3tV
         WdIx9kjnlRW+IJahFtvBOc66Yzh4GZtrbR9EYr2dotPL00Q/qvuSSpK3BgITahq3GntO
         Ulww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090038; x=1790694838;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TzjZBDA5iUg3ko8RNpB6y9UNWK4AO1BnhWiKj7vnaJU=;
        b=GJ1TXXoUJsJyRyFapxhjWRlXK1pkLJO7EwJTZmPCg7Awe3U3g+Osmw6RBRp4X7PbPN
         Ai6V/qvi+nfL5t4RtmZf8B07loicDBMXc8qyClmiTri+CmcVEUh8tlpf6ENEBkD6uKaw
         TNUpb5Uoe5UM1h6cSA9Xl/WvcNIOTwmJhfvS7Zk1Qrymuuz86fzVk72Qm7dlHjLec3Bj
         zN8HXwAmtISOdZp4xv67WOYSGmVeWSE7brqB4mOPdOyQKVRotzSGzch8d++m8gPwUUFq
         xabNzRVmDtFr/FdtecJDGjZT3VCf7K6hfmLDFAdJh58/5U30rDZzObTLjC6OXYzqdDA3
         X1xQ==
X-Forwarded-Encrypted: i=1; AKwUvByBblLTJJCjVvbXMRuymqNGO7/2+Kf1JTihRZ/234R5t4ACEEgOl9Cnk3Ui2iDFWd1Vy/vB79uGnQ==@kvack.org
X-Gm-Message-State: AFuF++k9yAlyWIUfu0UnVbgaMX/N2LzMD9Xds7xjv5gzkcwxlEKrM3Ec
	2QJaNLPHV7zXua0hi74+56qsToyspfAphvB7Mcf+ameDXUzVJEzCJpb+DE1L16AhXuN/QFI7EEG
	glzE1
X-Gm-Gg: AYBFou1qT/9zUoAYssdjY/8J1Pcn5e48qsN54Xd378kFEwbDAZTM2EQ7b7lZWZmFl1F
	sJndzmsyH3lYRIiAUKgNjePXZOHSZm8vQc5u4j3ZdGxPfguxWuvLJBVJtl/K9p4kjYFHS/KM9ET
	4/DNsTQ6wWve4mJIIUje37cwOE1hiJkFeAF/pkKEkc3vfwjxrVALSgKqNtuLcE9gi6hjVObKvuF
	1+weKzanL/T+1kmshiXvJIMDBLgg4+Br93GpTTNkP4DA2ghUXUmfn7seFZoXlE1sz5djQzQRPDx
	hyA3+wpXO7p8u1l6kDASYRdWNd3eVWQNvBrrWtYmT31ESfeXfYNXv3zdkUvBquWHj6rXIgKCFUt
	4i781zb6mfr1B6Q4FpouNAob+qL2kmAFsqauc3C4QGy6qSe4Bqfm3W56HDw6+kKE2ZVgo7W7D2g
	W6Pcze3rHk0rlwj1oi8T71tw6JQnXEJzdBwk0aunQhsQhfDqSTyRoaHcoA+oUgP3d9K6QU
X-Received: by 2002:a05:620a:2608:b0:939:35e5:94ba with SMTP id af79cd13be357-93c15d59204mr577391485a.6.1790089638560;
        Tue, 22 Sep 2026 08:07:18 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1cf10929sm167536485a.6.2026.09.22.08.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:07:17 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:07:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arKZpJDpsavixjPx@cmpxchg.org>
References: <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev>
 <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 528EA40002
X-Stat-Signature: bc87t4ipzbc9z9u7gnqi1s39do1fboq5
X-Rspam-User: 
X-HE-Tag: 1790090039-386609
X-HE-Meta: U2FsdGVkX1+u/+UN7D5+hlVI+oCJVfl/G6T7KmYQ2Rxzpy6DAYSL17yNMj067f+2U+OG2CFPbbzUh2/xVjCTtjlov9Zvirv6m4tvLzYaskMB+ytaawPcH6ItnNoSdlzukxp0htJVZoKGowdtTJsYLpFvbPGNrrhmVsvthwrLyot7Foqw1Kmi0LejYda+Ycd+PHh8Y6MAau8iA9KJ6i7e5Zca7PTR9dQa+77S+/iYtRyhp3vw+HGKOb4a/rqcYaDjHC+O68FXrf+F13KNxta+EQAfeMEVKuPpP0cySazVZFCIyAsNreGiNIIMr0wnUfOe9clrF4yvN0gofmYls3CKP+/vafFhfqYOQ08DLKKRV6uE4SRVWfzCs+ABALHclFIKalzCzK4sT7LpA3Wkp16JTKqVg6WOdEnyNK5q1MhVXzPJ0jRXXK1ZncGdf6wMNa1UuW9O1b7ZMMglmQ3AHA8VRkimXK9R1FlkbLq+2uESsqJzoruh2bAS+hAYR4oxp5alXlapIk0km8U6HCOc/muno8cbtdd6xzQ02mmxMoT74g349uBpxzkdo5uZ8Z6GEfN3bWTgvboqZbyQwICPgeiKykD+0IjMkbIQ6S9nswDRxEYKLcuHYWC1EG+6Nx9q1H8ziNHFqAANbJsc5H5YGOy1ZI3/Sp/DGVBU0jjbDNCLP44zyVzmc4iyJzU2zAPD3BUPaWXTpNccgbqy/th5hPuUhztZ+2qYRmGWWjtKEjtUmhKFqCPvGUI4nvEDEvNmZF+OaKJnWwlIjvkw+jaXkJWaqcjxkHmnDkAAQJ2QEP6NySjBW4Qz22kaebaGH9t7ReKpeSNeZtRVnKMClLv3fRFvTf16WON0T0aVgqcS3/6a3lI2ZidH8Mw/YVTdMlFUuglMkPRa+qHZAwLeLhWg/fGk+pM0k3MtBHP5UbNSLkWwpLhc4mztXmvlpndHWk6gIClWlVS/tiOjuLz1ateLd++
 UbQInOEY
 ErMz8Vrcb6qZ90EfvJCrvXZvhbdAZAqRJj8AhXU5HRA8CeV7pnsb3WoO1Hmnl+omjcXKDwyteflz6lHlDOc3aAhtqFnAlIL7sSsovGHOpLI0GvGn3jb8iecO8QtwbaF8Xr/y6M8gcnPqOaMI6mZVhtcbx7iAXTzgotpDVkCx8F65hN4xuMTheorxyeApEcaoeUMKicUGR0PMEyiH88BajZD7V6jpDemCY4GowjhHay8Tydf9j3VCPvbmKXNwKOuv2Wb8YZV9g+NPUdtIMp2piUNDJnpiL1Jqcq2J21fDESV5h6ErT3iJmD+ZYdCzSkh/OALCpf8ekyuwYmJ7pUk4jfVTIcf73V/ZzW5QzcEgoFAVvGfEVLVUUl7GDcw7P4B4MovBjq4yGToufHR3+P/DcE6Y9WR+AVYI57nYvP86ACzUdLVsjTQHYrMnIoKs1CdcFYaYZzNujVMUCvp5nO5kUR0mluUUMZFvM3RLzs1Ktzouq0ypEWib386cA4bf6OZZqzEWoSBR54cegt597ONMb3csAWF6a8pQ9xXwM7wL4iWk3Jpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 04:56:48AM -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 4:43 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > People can speak for themselves and suggest other time slots. You do not speak
> > for anyone but yourself here. At this point this is derailing the conversation.
> >
> 
> I am expressing my opinion, freedom of speech. As you can see in the
> previous discussion, Baoquan wasn't able to join that time slot. He is
> a major shareholder in XSwap. I worry that alignment vswap vs xswap
> without Baoquan is ineffective. That is my opinion.

Actually, he said he is not sure if he can make it, and before Nhat
could respond to that soft push you drew a hard line without actually
proposing a workable alternative that made Nhat give up instead.

So my free speech opinion is the same as Shakeel's: you're speaking
for others and thereby derailing efforts to align on something.

We all want Baoquan in the room.

