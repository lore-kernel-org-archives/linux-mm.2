Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B05606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kJ9QqZdW
Received: by kanga.kvack.org (Postfix)
	id F42136B05B0; Mon,  9 Nov 2026 12:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF35C6B05B1; Mon,  9 Nov 2026 12:03:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE31C6B05B7; Mon,  9 Nov 2026 12:03:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B139A6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:03:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51F14C0756
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:03:13 +0000 (UTC)
X-FDA: 85416201066.19.5D1058B
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id B2321A0017
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:03:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kJ9QqZdW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of rientjes@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794243791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EiCyFmyHns/6JeMiTgX99ZP7gU78wmi52w0Se9KfmH8=;
	b=ZcU+LqPZiVS/9/3oohuB2rRK5ZhH4MgIpCpEJjmVkcOe80ARCGwJcOr1JhgnLQyYDvIUyg
	3Ez9eipYNCqe0lA+To7l22f2/kTAzTjfYh6WCFDn6m4B5mRfElPdIwv9Y9CjwsM/kod+zM
	Wu9sR9sFbuPRC6+AmsEVPZ3VqMweWr4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794243791;
	b=h4d5PouYO6ItvtMst3AeTrvUZwOG99+4BM9gauO8dJQsYVBA6xr8N0IxLqO/4FgdK/r5pK
	K32KW8f8iGASNyLEgiqORskXoxHuozW3L8VFKniRxfKbXFoI1mWsOXFcNAzK9T4aQy9idM
	aG8+U7B5SpOcC7BukPNXW0/fHUq50kA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kJ9QqZdW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of rientjes@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2eb0a52d605so48265ad.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 09:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794243790; x=1794848590; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EiCyFmyHns/6JeMiTgX99ZP7gU78wmi52w0Se9KfmH8=;
        b=kJ9QqZdW0DNPc4dvq44fyWucsXXFX851lHvMuUTtZYb6c97svePQWRuaGfCQw5kjH7
         osXIedli0yr1hC+5cwPx9uguw6ozPN4GHeYx+EBvXa/mAxCAzoXpism7q6p58rfYUtiF
         D/e1O4R6GPlQT21s1CE4hzXpb10ANd6SCgslGTi3iG+OQ72vjSVYOARm3dQsqnsP/SIA
         8mCAozHLjtfmolOtVk9XJs5xwsY5XW/DivBKLDqLtkdzMCMSzRRnYWAJx38Dcsh0DXWQ
         ya0ciefJg6SMpMWfYDW5YkWo9DpSDyeUUH4royXZP3jZ3gPSC6ACGuwMYiFwGN7OigEz
         mYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794243790; x=1794848590;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EiCyFmyHns/6JeMiTgX99ZP7gU78wmi52w0Se9KfmH8=;
        b=JJPRLdQ3yDImVZSJ2m1lRQXb/Y+ff1p/T6jvm79pfs++14ayFbx725a1NeatYvtJl6
         K1i73Sbrjsg1Nn1e0C62FFW1ma+j/I7f2Az3kDeWDsGAqz2wyx5CzvyMx7HvYx8xVgkt
         A1cB9TCO1UVpa7Mq1SWo5edu5WO9hnNr2YmDtTDiVJY3MKAnHopb2gN4hxgQH/ql2XRU
         rRl9F+hiHARqhzrfxKV0Qi6oojp2LUFCRumxdSlivPd7X0K7lBleQfTU192YkcwV198B
         nTQ1z4g3HGm0jMnJ9MixiXoD/u9Amp1H+Kblicwxicvtm520m0tgTS+cqu0iz4AiYK2N
         Dxpg==
X-Gm-Message-State: APuU4Z/hZbdlmLru1CNUzoOcW8NNNJSNshu1ZhEXuQGmrKGCzyFnOXh0
	KKOjqjDvXQrgF5IzkZnhPyoOUJxrJjfc3VdcbbHh2oRFE3ATVjdLB4tJf1HVPVEgVQ==
X-Gm-Gg: AYBFou0k76KJMwa/JcsSm1nvLdF6FhlR+CWEV9MmcN2iC3dqm7lw3aUUDA4h9STlF2C
	KvBYSK3BZZXn44yGYTJ9EQTn8zyZXFHI7FSNUqjR/4XHkhslwZDXOigZCzcMpM/GHotMybxalYD
	/tnjtXs49MJcfTYROKwd28qjzLGZz6mNVghB85zuou/fPiKPsLZ2PpIi9oefMVevL0VXe0APmta
	YYxMpZfWji4JEuPZX1Y5ycjuUyLeIWiJAre5hnC03vG5dtTwvV4XH0ZVmHGrLUTeayR6YQDfWBk
	S6N63SgR8BLFQ7bw9hizf49da2+gKjWJSoTOtUqBeuwJq7sTkWLAxsLC3lSbHpcw5t64B7uxqjr
	5SVp3nYscK1Sn8Zs/ymdiudI88pD9KnJaBjf+7ne+YoSmvAsXx7bmO0g52WcwtURsY0JZHbjSgE
	3FLIRVrprzB3ii0UiRcc0KsztxvAqkr5wHb6DQZmzDx7anMIZV7CPXAyG8p4HxBri4lLmM8XJ/0
	SlkUgePyGAcooCYzdJAGI5mgNs1Rjb0He5ka2riC0V8MEkjgJ7WpRTLca2dT8bwjIY2incVoMqV
	szNN2LdsNNUOvkztYlYLFyz/e4ZQoH9RDRtVnrbLxKiqk51VqxQR/h0pg/HxDSfmsNwck/TVOPJ
	Ck4AN04/DRnjM2rN7mvz/B0oyFDSr4ePXTy++UBM6f1xJfDX5Djay5rphU3HKQ04zuBzZqfHmyE
	6mCB6n9W2c7H4bKJlQSS0rdBp+VAsJDGu2jWmqMG8fC3ni
X-Received: by 2002:a17:902:cf0d:b0:2e7:e742:8bb5 with SMTP id d9443c01a7336-2edb6ef6dc6mr223335ad.14.1794243789717;
        Mon, 09 Nov 2026 09:03:09 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:d9d8:521f:5a01:aae5] ([2a00:79e0:2eb4:9:d9d8:521f:5a01:aae5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b16769b589sm179496a91.5.2026.11.09.09.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 09:03:09 -0800 (PST)
Date: Mon, 9 Nov 2026 09:03:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Amit Shah <amit@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
    Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
    Christoph Lameter <christoph@gentwo.org>, 
    Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@kernel.org>, 
    Davidlohr Bueso <dave@stgolabs.net>, Harry Yoo <harry@kernel.org>, 
    Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Jonathan Cameron <jic23@kernel.org>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Kirill Shutemov <k.shutemov@gmail.com>, 
    Matthew Wilcox <willy@infradead.org>, Mel Gorman <mel.gorman@gmail.com>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>, 
    Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>, 
    Sterling Alexander <stalexan@redhat.com>, 
    Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
    Vlastimil Babka <vbabka@kernel.org>, Yang Shi <shy828301@gmail.com>, 
    Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
    balbirs@nvidia.com, apopple@nvidia.com, matthew.brost@intel.com, 
    liam@infradead.org, alison.schofield@intel.com, osandov@osandov.com, 
    osalvador@suse.de, ying.huang@linux.alibaba.com, baohua@kernel.org, 
    tj@kernel.org, jgg@ziepe.ca, baolin.wang@linux.alibaba.com, 
    npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
    lance.yang@linux.dev, usama.arif@linux.dev, muchun.song@linux.dev
cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: [Invitation] Linux MM Alignment Session on Private Nodes and CRAM
 on Wednesday
Message-ID: <4b2a7250-ee0d-74ed-2301-ca2f8f30f850@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 5ts31ghkzo7xsxnhicuhkybekk31d1rd
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2321A0017
X-HE-Tag: 1794243791-592419
X-HE-Meta: U2FsdGVkX1+vKsVpTBlEq5gLaPHuPZf4ffIw2EdA2NOeQz/1jj08bBcVV5POJwcOsGuucDR1v9HS//yHAe2EZZQpXmtKQ+FyPF92eEWuY4mfjjYmLPkMtBIqFkDjqO7yMWRwwM5SSC4mZ+lhYkNEtB4V10R1rZt2642SSaqTuQGlXW/T89ccBllxSzcc4osBqtBz5btj6Xi/XmJdspOdNkV2a9YE7lvcp7+vM2RbvpweQ29zFmOTmKTNTkUKcSWH0wM6HURwwyEcRlqDehxb1a3yznlli6xl1xl84jUd7RXULHCCZHhJ+uefYaWAjWeCQjhstYDVVgzLAG9Jj8yi5OCSKKMJ5I33HJlEhNXqnlZYT9FvOQUBhog5QPK0YJHOZnQJt3bBhHbBtnwH+BvidjESQxoMv3tfU19PsCGh+Ro40qhDs8hg+GZ6vnS0TUHyCygI19isTJBIg7FnHJiyejQJWm3xDu5IFVbVZ836YdE3g25JgBGNbgKewAb2Ms8e8vcawg4hDkOSc7L0ATPnejfR+ljLggkH8gJdyVnrJ/B4vWttCmyEnVC0uKt9/tUnKIwC0sTdMpcwwWFfMcMjWwRE2wvrJ6kOOKFSel5mwWMwNPZt73ABKdRFeQVPVt/wBoJNlfcRAOcnV0vOpYkDo2MMPSkurNUGIDegEb7aaW0iIl+KiVI78Oo0B5bA939ExyfbTZ70XGCH4HNWt3mwl35BKG67oA7f5KxP3unTmsTUdVSfesHj81bncPsY6bIkNy4QWCa9s1SwEuSsMWFXjf4RkaCsBgR7dFzw4ai1kHz/1Mv2Q6kEOn5VnhO/A17iiclV3K3nSoEReu/Z5gFY5Hm4GsOoG0lkr8laYrMzWJD502jvmPPhlOq1ctMNYMq12wQA8e9pVgcCCH76bZb2Sm5ZeLNSt4RrW/FoF4SItbxtoIz1yrSx2k4jv9Q1TvNPvsTq8rqRnKAIohW8DDN
 FUgQ8eJT
 4XqbdQj5uCg5bpWp+e5i8pKkYt34MMvB0SqnXGAm8m9nQgZOn5p2O5t885IR0FRRw8D4NcGtvsN6A8e1nk55C6zZDf+9jhVAVg4ZyJmGSgIeFZoIb/vFyy23ywG0wfswTO3+lFs8HfWBr53iDPXo0kNx+FdX+/adAxx90mTeXBeP14miZNOlqqB1lMHRxZutIqM+1oFHfga7wFizy+OJYTK8+nLCqj22S8dmMFzywlk0DQH8zyqRHveuLTBspoaUzy8nyK7z2GM0qScoebne+BqOM+/dlWcDfKwCBKNtMhYG3qG758qmPTduMp8hhMQXvWvefuy5DjVpx4sQ+6sa/fyI0DtV+pvdY1brmvbHrvuXqC07/ok0ENHkQfzla0rKsXMM7SSCESFe20eQjukwJr0QMxbRYWawFpk+FoFAXOae8VQb6b2/hdkVVH/x0yNWkVw3tTXgU7rCSKTVAxxjdu+AQHnGV3cHHMEjPTlAvBBIFsPR9ySqr1j/rKBa5iyuENkyIvxDE2DsUWIE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everybody,

NOTE!!  Due to Daylight Savings Time ending, the time in your area may 
have changed.  Please see the list of times at the end of this email.

We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
We'd like to invite MM developers to attend and will announce the topic
for the next instance on the Monday prior to the next meeting.

Our next Linux MM Alignment Session is scheduled for Wednesday.  The
details:

Wednesday, November 11 * 9:00 - 10:00am PST (UTC-8)
https://meet.google.com/csb-wcds-xya
backup: https://tel.meet/csb-wcds-xya?pin=1301132214803
doc:
https://docs.google.com/document/d/1QQfZFPHa-pGEGf4A06cSqS0jdJwuZ8ro9JU5H0YSUQ0/view

This week's topic will be Private Nodes and Compressed RAM (CRAM) led by 
Gregory Price.

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

