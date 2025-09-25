Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33835CAC5BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D028E000B; Thu, 25 Sep 2025 14:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6252D8E0001; Thu, 25 Sep 2025 14:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513868E000B; Thu, 25 Sep 2025 14:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 400D58E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:44:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBB2814049A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:44:51 +0000 (UTC)
X-FDA: 83928649182.24.A013473
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 178E11C0007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:44:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nsRtArcn;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758825890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pd8ejEjzronLUI3XRPYabqh93pMkqarOd/GpoVCbhA=;
	b=xXA7Qx1/UHqTGCNFHvV3TPW7dorxEA5l7d5pfXbb6cnaXRAgx10lwHJ836tWmRxYg27X3T
	2+77O22hzDRWMDsWYFhDkGugioHTZkFCBK+Rgk6XBNyH9dXPwzDWIdJwXHGyWtiOutjJ8y
	2O0wEc7CtAcGXigVBsRYy367R8FJwpk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758825890; a=rsa-sha256;
	cv=none;
	b=xJshVGAOi/5roKhixPOPbh/9ZidM/IAUBqoSe2yzahsOydG6ZBYCXvPECljAc9nL5m7qQN
	n+XaJhaM2CBMMXD7F1+GvmV8eJTeM1km3x6ttN9JP8sv/5RHi/D0YmOg2H5hJb0GDicsiI
	anRh931Lpqm0oZ5JizavpdC83U6L//Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nsRtArcn;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d6083cc69so17662147b3.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758825889; x=1759430689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1pd8ejEjzronLUI3XRPYabqh93pMkqarOd/GpoVCbhA=;
        b=nsRtArcnwFjWbKIHxQ7EImI/4+bE+J6avf9sHLSHFvUK1Jz1isechVbXWpOx+3gNUv
         j/wd4YjMyma0SqvdI3tkZfs3jAOrj0fvxZBW8Fh3mupjkoKaK1BIQaYoNcgTisJadAFZ
         fMPOVFqkz7NjOW1FfyMQHkZneL0i+eSdtl8cdtRcFolgt4xEwqtNjNBHChiGQlj2M5eV
         63JAs0tcZO3+aUkpW3slJ0U50ysuU/vBiysbl8Ls7c4g4X5Y9c+DGrD3EBNAyxA3gMve
         BMujHLXSOlM/Z3P8Cs/LxtP4VPfXk5fYCca5KbJxi3EW1P2dlOG3sQfSS0FGePuhbxv5
         mR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758825889; x=1759430689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1pd8ejEjzronLUI3XRPYabqh93pMkqarOd/GpoVCbhA=;
        b=DgwJTzyHaVelC4Rs1o2w5ZMcNCKjfSz52EbCnD+l6PqaE71DpGrk66u+62UDw0vB0c
         PR3+ADyeFv9TLv7EmLorCeifF/9MTr9OMWbO34VBHHjL0Q1fPS2Fb02/1S/QO7xPEpb4
         nY/y7YnimA31TVfYPyLY2J0r5s1Q3shqE/+yflvm+tPCD7B3tOX/f3BNowtanrPbBvCz
         l20GpwiJv8dzaHBE0MY+4EI89MnIcsJD1BECSXxzC0xDqLZWYP8Ja8xj0fc9aw4ewRV0
         8CfAF+DqJkv+W1/gmhaJNyfUq31JpK4jUdEDuUVo4YzgVUvvqEliEz0bYEUS0MpHFEQY
         4VsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+1Bs7fZmClGSaZt+vfWwoJFlIYuMIAV49JFt+4MxNes1ISaiJpBOuOQelmksxktRZ/s59I5s9qQ==@kvack.org
X-Gm-Message-State: AOJu0YwGXkLdmGT1SL4yM7vhO0qItykl/mCyzdPHwfyBM9r4SVgta234
	a4xx0as1TNkNLMjuOU2zvmJxY3KNf4PI2QtuMa1QEVNAslkGV7538PCF
X-Gm-Gg: ASbGncvUREz/R/ex91SbJXQ1SZymzUf1Fi1dIGxKinMuJBCFBPAwnZeDnvlf4rJY+nO
	DJQRLIJ0Awz4jp2dKbRLkCf8OLm++n16QhTdir5fYnX3qDyqsdDwtc3vk0d1p54Rk5q3fDvQrH/
	4HsDYg8M7Uu4IrBH13GzB+i0x2xdT7Q+iaJGkYTbVgsiAnhKBE44FdRLuPBalhMsb4iyWO9OiwF
	SfOnoi+5+Hsr7hHIKD+c3uySyDNrsSMZYAFAsJ/sxKs2Mi+40T0mzP28PfyRkNE3b5UFMMP1a1j
	UIiDgnWcZmqQyEBBZ6YBuztd6sGVeKeZQhI+8yi1MUVc9vHirsywy7ZcMh4sn51RLz1WwqKMUiL
	j//KfYitCW8vDuv8scHxslol1GF+XqLv/5afE94MALMUoOMUzO6cLGA==
X-Google-Smtp-Source: AGHT+IHpC9+Ql44BqP4ZDNZQjX7uQnXGh226uiJjuZb7wY6Cim2hKfCptNADi0/jHYRaQLJ4UcldeQ==
X-Received: by 2002:a81:8a07:0:b0:739:7804:8014 with SMTP id 00721157ae682-764069fb3b9mr32273317b3.39.1758825888981;
        Thu, 25 Sep 2025 11:44:48 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:54::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6361e916c8esm807433d50.5.2025.09.25.11.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 11:44:48 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Thu, 25 Sep 2025 11:44:46 -0700
Message-ID: <20250925184446.200563-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a84ede7d-60ad-3df9-77ae-cd0dbc545b85@gentwo.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 178E11C0007
X-Stat-Signature: g38wssd8hju5eh4z7kfjqufmuux7jueb
X-Rspam-User: 
X-HE-Tag: 1758825889-118329
X-HE-Meta: U2FsdGVkX182GDAW54wMyIznlIRQulHhs+k3Yi/4N8aZ4OjjvcTDLPzFDTobxliqznQrbCyOaPjchh+1S6oDI02jxxy0k6EK4gKxktIvdJqC4YBQtaPnW1ApPzlST0LULTcRwsGRN9H8Rqbbah2Mh0yZHKXAO89RQ3Vs8W0c0OTxEkrnhBzVlB+rn5hgd3sQioRsP5ImXHlIsnKeqiDV/3YsD5Dz7hxqEm+iJvDyO2tiSu10s4ScthD276veKIPfjiOtR2xZDtTfVfccvks638Lw+jil31uRQxvqzDCkoHcOvEdq21LdhMsAv9lDuzNOQc9+gnoR3l/SO2agZgzbHPLFyYOFjWFjk5k/VSz52AFLIMXPFrVksDnk9opjtfgJxLAE/cq3BcuSoCjIxO33HMwgFNle/cSGzHF4nSwUuBRtWM3rFGGqkAm0xEgF3ZY4d9UqgHI6yaIQ1P8d8i83VbmJ4grL8OkhhhxXY3ZBVHySOMJFnxqH3x24MAkgh5FzMZWR9nlvA8KuEimmvsSb2hxtCgnmljYnz7N3ufp5Jka/OW/0XjvHNReEHKtU5vo87a1QVVSekpn7dIGbSTx3JpZVmN4QxkwpMzt8jkOt8NZUOaUjWVuC/tSdWKJ0NT8S8xe+wQ99Da5ADesniVEElz6nuWkr/wrds0G4UxaoMAYRLATQZRpecljExMhmEtqtSapvzPEcqdZjJpX2wYi/lYFU2l85DZZoUV3AWDRxVxcOCv2hSM5UYmZ2+a3mY7Ah0UM2gbxQso6DOSuEeV9Z63btSWsD39MT+x+Uyb9/Gykp29LTUQwdECRtKp3Sb5UYbVaYJ7xsPG0hFyCzMIIiqyHVNd/hNVCjRHxg/fQPcbWshzm/hAKU9Ve7m/e9t5nw6Od5wlgRX/CXxl8b8hR+iENajB22vJXJIGslHfXp7IPNJIVmIKUcLVtG2e6RSZdljuAUvFpASS53Pkzxf43
 PWMbSMm7
 18Vbazz37Sut7K3hpTX6x7UK5cpeCknPp6mOK4pmuKySeF5Soj83elh1JnfecAa2iHXpF4wiltvCV7Qy+m7xB1EzJ3frJY3lALQUug1bigVqLOPUKzcrQovwuTJ4vEUJmKPDnjzpOu2xyxGCX7pgPlKkLTEvYc0/hPPjSf7m6QGZMD9pWS/1TDhg4FgihH7duVaw7XXA1qn0LkSMTfRj+fuykWnLXBfJVKNNos1m6VtPprpaGPtRopKmWvr8Pnbc9IXXiD4h5H0137+yriyH/akmy7MIi3oeZkOWO8dXDdphDHkxo0FA7A/lBYoR5eBErJtJVHlUOJilIaAerqzwJ7dXP9KPbISALwf8hrBvOM2/aD9u35gTDQUtRq4eLq7CVXUrUs33yFffxytVwIJp8KWS2zvL7Q7oGtXJ4Jb2PY2gzG4HeRobl+KHIHz8v5Q53wMzVG6roYgjEFuKhisoxVJmXbu3RkIb9kf5a7SUEw6kBso0HY7RBaM6R918xXMQx5OFrb9gbY4DkEQUOlp0YLLvVcLiGwSsBcdxxttl9Cn+icbzOya94R5qRcwSePPVUmXokwyyy9EyCmq71FsqaFXLPFEmKnCUsTv3HRKumioZk6EQafNXKPTyjTzjdtGoNwk62
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sep 2025 16:09:47 -0700 (PDT) "Christoph Lameter (Ampere)" <cl@gentwo.org> wrote:

> On Wed, 24 Sep 2025, Joshua Hahn wrote:
> 
> > drain_pages_zone completely drains a zone of its pcp free pages by
> > repeatedly calling free_pcppages_bulk until pcp->count reaches 0.
> > In this loop, it already performs batched calls to ensure that
> > free_pcppages_bulk isn't called to free too many pages at once, and
> > relinquishes & reacquires the lock between each call to prevent
> > lock starvation from other processes. 

Hello Christoph,

Thank you for your thoughtful review. 

> drain_pages_zone() operates on a lock in a percpu area. The lock is
> specific to a cpu and should not be contended in normal operatons unless
> there is significant remote access to the per cpu queues.

When you say "the lock", I imagine you are referring to the pcp lock.
However, there is one more lock that we have to think about, which is the
zone lock which drain_pages_zone-->free_pcppages_bulk locks & frees. Perhaps
I can be more explicit about this goal in the commit message.

Actually, in the original version of this patch [1] the goal was to
relieve the tension in the zone lock, but since it was a nested lock under
the pcp lock, it was required to free both of these in order for the
task to be rescheduled and other processes to come in and grab the zone lock.

So from what I can understand, it seems like there truly is lock contention,
just not on the pcp lock. Please let me know if I have an incorrect
understanding of the code here.

> This seems to be then from __drain_all_pages() running on multiple cpus
> frequently. There is no point in concurrently draining the per cpu pages
> of all processors from multiple remote processors and we have a
> pcpu_drain_mutex to prevent that from happening.

Agreed.

> So we need an explanation as to why there is such high contention on the
> lock first before changing the logic here.
> 
> The current logic seems to be designed to prevent the lock contention you
> are seeing.

This is true, but my concern was mostly with the value that is being used
for the batching (2048 seems too high). But as I explain below, it seems
like the min(2048, count) operation is a no-op anyways, since it is never
called with count > 1000 (at least from the benchmarks that I was running,
on my machine).

To demonstrate where the contention / offenders of trying to free too many
pages at once, I compiled the upstream kernel and made a histogram of
calls to free_pcppages_bulk where count > 1000.
On the left is the value of count passed to the function, and on the right we
have the frequency. This is on a 250G memory, 179G swap, 176 CPU machine,
running a memory intensive task for ~12 minutes.

free_frozen_page_commit
-----------------------
1000-1250| *          (3732)
1250-1500| *          (3329)
1500-1750| *          (3102)
1750-2000| *          (2878)
2000-2250| ********** (28456)

decay_pcp_high
--------------
1000-1250| ********** (837)
1250-1500| ******     (540)
1500-1750| ****       (337)
1750-2000| **         (249)
2000-2250| ******     (547)

So it seems like drain_pages_zone does not even call free_pcppages_bulk with
a high count. In fact, it seems like free_frozen_page_commit is truly the
biggest offender here.

When I was writing this patch, I was doing it for completeness and ensuring
that all callers of free_pcppages_bulk have a limit to how many pages it
can try to free at once.

I am happy to drop this patch from v3, if you feel that it is an inappropriate
change. From what I can see from the above numbers, it doesnt seem like
there will be much impact on performance, anyways (at least on my machine,
with the same benchmark. Perhaps bigger machines or more memory-intensive
benchmarks will request for larger drains?)

Thank you again for your review, and please feel free to correct me on anything
that I may be understanding incorrectly. Have a great day!
Joshua

[1] https://lore.kernel.org/all/20250818185804.21044-1-joshua.hahnjy@gmail.com/

