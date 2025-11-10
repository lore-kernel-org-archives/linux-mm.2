Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FAAECCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896DE8E001A; Mon, 10 Nov 2025 12:02:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E108E0003; Mon, 10 Nov 2025 12:02:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784E68E001A; Mon, 10 Nov 2025 12:02:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B09B8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:02:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5CA587259
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:02:48 +0000 (UTC)
X-FDA: 84095316816.19.BD28E49
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3150740017
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:02:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c2PPnCcv;
	spf=pass (imf01.hostedemail.com: domain of rientjes@google.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762794167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4gzrDAy++ryz0tOnhaIRAZIf79M+ZQuD2Rb5q2TXAZs=;
	b=eu8/aVp/u925WJuX3lVhIoZ5B5OpHDLi94g4ik+sC4Vh+kKMfSG3xYXiffr/Eq6Kt6MJsg
	OL8h3z6XoiXkQYHQAp+GQrPBK4MaNdapKCa4Z8fpsr7K4/s8l931iW0fyFyRsJm4d+3fR3
	e2GrtADUpN6cfcsA6Y78L3sUWfJAFyw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c2PPnCcv;
	spf=pass (imf01.hostedemail.com: domain of rientjes@google.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762794167; a=rsa-sha256;
	cv=none;
	b=angTfvpyQG6OlB54GNdJl1J4xpocSa3uShRteIdSN/igpcaBBdoNioHU/jB0GvfoRMN1Rb
	gCEkVjLyljPn4h0BRxn6PJvqyU92X+ZAzN7r/mPth03d5d5VMDx/PpLnvqVrDIlZzGaizj
	FyfIQ2uUPqxETXnK63u6UR2CdLm2ahE=
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2980343d9d1so259235ad.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762794166; x=1763398966; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4gzrDAy++ryz0tOnhaIRAZIf79M+ZQuD2Rb5q2TXAZs=;
        b=c2PPnCcvGCRNdX/RoS2IUxFTZxnwl5b9D0XJDmfXhcojCTXBYovgAAeiH1yb1DfLwG
         VTQ3EJZAISpbm7FmPfofWKMZYifBZTKHsTiK3+46yMlwfKnV8T0jpjBpT3DNnTY4PLMS
         iyJLbIi0e5rUll7zM4wvTGy4kHiq+cYqqzWrLUgVxHGw+bn3PottFJNvaOiXSSs3iZ4h
         RyXviBICsDHIm2rvK09aH1xy1GWZW6BnLJ3oF6iE/dE6iol9MYJ2XTld7GKM03A/OjwY
         oddxKGHzym3VUvPqfWMzToLtxlEKWIO6Yz8R9Qi2UZgE0MngPeEbENTGvbc6Czd5xg/F
         OkLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762794166; x=1763398966;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4gzrDAy++ryz0tOnhaIRAZIf79M+ZQuD2Rb5q2TXAZs=;
        b=JAdVSKwKm64vWFW7QqEFN/Gr2wtBxPqnJIVapDOW5ut/4RW9dvsubRQGOdQYsDdZb3
         8ZXh0LH32G7szNBocWx+19JB8HRDoOUnHhrQF8lrrgyVHAjlQ2ALChfoQ0BU+P+FpCFN
         cWPy+lfIgq18tF8PRd2Sh9zyAeo/INDCndyk9/ft22TfU13sz6xf3mTLO3rYRA4XfrTn
         nSbtsAFjin3vZ2L2LHp6Sxs3s+7A7pmWNC1rH0iweLMLmlrZevdSRu8IUAr8MTyDAr7k
         LD7xQ67CIBaTmDvqzP/9AHcOZhNxp52rgYW1QVCbtypbjlsqcKrLdDfP1A1/NY4tVkGz
         B2vA==
X-Gm-Message-State: AOJu0YzjKp83lbxhzzDkH0d2Vfv7zI7Zf3BLvTz4q1KY3lEzJ5hJ17SX
	vV+tJw6G8Sew5b51vENa7xZtiXkbW2ft4heDFr3cVrjMXQxAdOJyeIHvW9n2//OsLg==
X-Gm-Gg: ASbGnctILbJHGL8J01pzwp3yrf7N3cBCbq+YYF2ncJzzRSZ3A9rklAIV4xN11dmwg4h
	jTiHqRCDqB5siFf9kVqTmXm8uluqaJky7/l58w10ePdBeXsk8mr8RkpZwSQ/vlDBmdkKAZvLBKp
	5ca4XRKiQdy4ipz9mLPNXu0Dcgi6HLnthfoe42kYigweWb8R+thD8P4kqTcVAhqui/7M0mz7tSy
	zsCNwP3kgAOzqLJowA3KgBwFmDxFUrHigsB7KRZnkifzEukycOkL9QTuHDjRDwdwrjTFAtN5VKW
	47VbmW+1Bne2wvfz7nkD9eyDlybBAg2Ud6y1rhEjpR4Q6LJ3ekhUTHC/XRmAqnR3oekhBBBuz7A
	iglZ3JoV01+WPS6cdNg+QYwmaMHdHgg+VpsCQ0gSBnopB013sZIqLgYSMR6rYijjPHGdEHorG0k
	pDE/NBwhXAo9eoZbFgft1K2rCh96PyhKOuQGfmfnVBPoOZv4/b9gi31w5grXciqGZ3FinMR7Y9r
	ZDHY13xtfZRXqAr2j/1dzwUGfpqx7ges84R
X-Google-Smtp-Source: AGHT+IH6O4PQfV7tezhQoTzF9IqNocaCJTor+FWLTY0OtFSML6yj5bX7CDGaX2L8admdWlcIiBzmqg==
X-Received: by 2002:a17:903:246:b0:290:d7fd:6297 with SMTP id d9443c01a7336-298400d9cdamr619085ad.2.1762794165100;
        Mon, 10 Nov 2025 09:02:45 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:bd79:6e:8877:1a84] ([2a00:79e0:2eb0:8:bd79:6e:8877:1a84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc76c0dbsm12280272b3a.51.2025.11.10.09.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 09:02:44 -0800 (PST)
Date: Mon, 10 Nov 2025 09:02:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Amit Shah <amit@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
    Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
    Christoph Lameter <cl@linux.com>, Dave Hansen <dave.hansen@intel.com>, 
    David Hildenbrand <david@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>, 
    Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Kirill Shutemov <k.shutemov@gmail.com>, 
    Matthew Wilcox <willy@infradead.org>, Mel Gorman <mel.gorman@gmail.com>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>, 
    Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>, 
    Sterling Alexander <stalexan@redhat.com>, 
    Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
    Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>, 
    Zi Yan <ziy@nvidia.com>, "Garg, Shivank" <shivankg@amd.com>
cc: linux-mm@kvack.org
Subject: [Invitation] Linux MM Alignment Session on Page Migration Optimizations
 on Wednesday
Message-ID: <bd6a3c75-b9f0-cbcf-f7c4-1ef5dff06d24@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 3150740017
X-Stat-Signature: f56uzww79ctkpbajfn9z7s83ut948h36
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762794166-900464
X-HE-Meta: U2FsdGVkX1+Us7lJECb3ewyZART2wLLfJhesBoZEMzHsbXoTn4wDHnPG5rtW2fEsJQSpuhfIcbI/F6nqu/mQ8NdhD2aM+dGPnJ5JDl7LuvrDBlsREIk3RjhVPkpJ4614E55/JTkusB2txu2hihvXgjswwVV8FAwudUPxSEWe0H/6yA5j/Yv4kNwgpcx3uSL8dvMnNGdYo/EcgYeR7WTCXj8lDlU+X2NczSTJn51OHmnC5adK9+CNIwdA5z4rw2P/vVoeEdYAnUs21fL8/FxbE0KsiBHYJNXF3siLh2Zkyrw6HOeA+LPcc++M6TIOFlhpuhlTDLSjy2c4iiaSCkouviTKl5Yn7W46dcLpAuM/eadnl7rjji7LdKOysGjwZSSRnAGuqvA5OtC3MEQ1AQbPeFVlRfsT7c73TkhN68ffwqYlKLsod3+FAerM7m/4HgTY0IaFlge9QlWnzuNrWLehEqNSH1q8lkTnzmCNvniSRrxhgHpwN1hhxUy4aZaiDNrD7uI0DhKWjW6KPJfWAm0ncBtnCqVenbmEx8igsU2C1bkLKI5zmPER17Ho+DYCXWeZAkoAXQOjCylYdh4gAsKLYlPqeJIGe5fwnCyNpDNMJOuEqheDQFffzboKpu1GAgbtqj1imozcqgmzXUjYdssRxxVHPqzkMh7qackSzD42GQ6TESRlzmKKGHrxkkc32l/GWi3Bxf6Qeu4+6hQ1spLBk+DKhOsbRDAm6OYaE/IjfAkQskxHhdlmm+XyMgNh/JZRe8WdisFKkKZfYh3uxCcWxf4kRzTCOyiNsSeorAyc6ET9qU0U5SZ5r9nqDgsur4AuLE68e7Mw+FJdH+p2cPrvE85RNhn3xKqU+6x+1rHClIe2W1i0HJeJ0kRSl67xE8dIhA7BGv0t33x9hKCxWDqzpM80a2s5gsGYh2L1EBL4HzS1chlH4dqwvnq1qAmcaMN+b5nSjlXuN3SLtd43Fsm
 Lu8qZ2mM
 6/OK5gXvwrC+pCk0exXRQ36P5v6hT1/Qq5RyRK0LIlyAfeYkKHbWh8LiyLiKffxl7w+ey3aVbZXcPQgM63SVFnbIxAJBRqFzZKB7erJYE5rkwsEgLKYYgn3rn6LSR+YCeFpM+qBNC3m/EE4CXMdE5aCBzkQTutoEM2I86P77bGY97+2NzJ4ROCZO4wwea8RleKxnVp1ZBq8LMFxXMaj5DUJMhvgCMgvCflSu2D/StNIapiIMkj/HjLvJMaOO1/WixO+wcz/3RnNpupC3Gg60RAkYTdZLusKyvRMAHZud35qa6Ht9CcSJ3sorwC/6xzqdpjIa6qt9y5CNjIoNZIkhjVnwcs0hoYP56H1vlutNI+Cg88Ul0VrJ39IhYwJoCRv1NKlCgJVaV/699PBMDxwu3hTfAlXGnooL2CrC0YG6w54e66FLeQV9+Lmo9jb6gIk7w5Htg4a6sl1+NrU56KDbI1R3vqnf5IdWauu6CIDADnWIxYJIQKg0KyH4DWqQ27KtE9KZJ7QtA74GTRteyfiDWYQSbXEe2/xDUOfxD3Mm5O39uPi7QQpscng1nh67JjzKtkLqcAFcvxormVTm35LZ0UnuYfTwgYcl0Z4PJabDwi/vylp/YpUH4EltT+r0UYUsDflmqMHl7R523d+4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

NOTE!!!  Daylight Savings Time has ended in the United States, so please
check your local time carefully.

We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
We'd like to invite MM developers to attend and will announce the topic
for the next instance on the Monday prior to the next meeting.

Our next Linux MM Alignment Session is scheduled for Wednesday.  The
details:

Wednesday, November 12 * 9:00 - 10:00am PDT (UTC-7)
https://meet.google.com/csb-wcds-xya
backup: https://tel.meet/csb-wcds-xya?pin=1301132214803
doc:
https://docs.google.com/document/d/1QQfZFPHa-pGEGf4A06cSqS0jdJwuZ8ro9JU5H0YSUQ0/view

This week's topic will be Page Migration Optimizations led by Shivank Garg 
from AMD.  Shivank will be talking about accelerating page migration with 
batch copying and hardware offload[1] as well as demonstrating kpromoted 
as a use case for batch-offloading performance improvements[2].

If anybody has ideas for future topics, please let me know and I'll try to 
organize them.  We'd love to have volunteers to lead future topics as well 
as requests for MM topics to be presented.

Looking forward to seeing all of you on Wednesday!

Time zones

PST (UTC-8)		9:00am
MST (UTC-7)		10:00am
CST (UTC-6)		11:00am
EST (UTC-5)		12:00pm
Rio de Janeiro (UTC-3)	2:00pm
London (UTC)		5:00pm
Berlin (UTC+1)		6:00pm
Moscow (UTC+3)		8:00pm
Dubai (UTC+4)		9:00pm
Mumbai (UTC+5:30)	10:30pm
Singapore (UTC+8)	1:00am Thursday
Beijing (UTC+8)		1:00am Thursday
Tokyo (UTC+9)		2:00am Thursday
Sydney (UTC+11)		4:00am Thursday
Auckland (UTC+13)	6:00am Thursday

[1] 
https://lore.kernel.org/linux-mm/20250923174752.35701-1-shivankg@amd.com
[2]
https://lore.kernel.org/linux-mm/20250910144653.212066-3-bharata@amd.com

