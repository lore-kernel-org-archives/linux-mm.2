Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42DE1F3026E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91BE16B00BB; Sun, 15 Mar 2026 16:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6266B00BD; Sun, 15 Mar 2026 16:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3006B00BE; Sun, 15 Mar 2026 16:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68A7A6B00BB
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:20:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C7181D46D
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:20:31 +0000 (UTC)
X-FDA: 84549415062.07.1448B8F
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8A917100012
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:20:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g17xB9O3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773606029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y8j6iHVra+pKfyywa0HrOaBeipJSEcSsIygb6AM7nHg=;
	b=GK357NZwsss0XbDCfmPqaqnibuUQP5VnOd4M97Omj9LLDKqfvTftVnMnD4/7iiwqkgf1eR
	TZX9VhsCZJ3Q3wHY4ennBjdFIeodTUxA88YYU7bugxNWIX6gHtOF7mhNDhL5T4DGfv9/Ip
	iBEX31PQZ48l9UAIuethoF+/weeMooU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773606029; a=rsa-sha256;
	cv=none;
	b=6RnawbQHYBR1O1od6EEbH2PT3TDZqPFiZesD5MOnKe+JMT9IbwGTkumWKc9QsIg/SSXVgJ
	btRwO2cEWE+xr4pIQH3qhBqairkx6WfNhbowWmUaFVZ6Nnanie6w0tE+WYdUwGpKVAVfik
	UKNlKnHig7FLCwKX/bZmCFhvihjgdG4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g17xB9O3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b052ec7176so26825ad.1
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 13:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773606028; x=1774210828; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y8j6iHVra+pKfyywa0HrOaBeipJSEcSsIygb6AM7nHg=;
        b=g17xB9O3DLoVusBSWbEFYVHuYbu5VlV4muYPjcKnGLFdPMmu92GheJKpScy2NFrR/u
         M9jja45feOJsgkt8RU7UHU23Fsuwpq4Rt++iiIuaZsM6H/98RfPWrYK1eAwxeCF0pcb9
         HTQQ8mK2jw94vFkeMY9eKP/43tb7gPXGhuDtd0lBCMYHWV3RYu+JqiY729as7M83JubH
         1UekyM4Sx4z+NJdHRFfnYkKZMNDaHfCoNzWtPVVApp0GmBdNdZXuYbx0UQ6MYWIHrmsU
         uMItshp8PVrZH96nYnVzl45hL21R7L8+i5kr/ZLLGWGYwWrv3agPyGGN37KZ/1KaO1aO
         i4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773606028; x=1774210828;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8j6iHVra+pKfyywa0HrOaBeipJSEcSsIygb6AM7nHg=;
        b=N17CmpXstK/dVJyZErJQ35IwJQcbp4hGLQFgqDMH+Iyszv7R8UeAcUVXGDH1ll+V7A
         lXV1hdFbO5zso9s4NhWlcW65vodjfBd5wXgzYriGK3GTDw+/eaLJz3V0Jy1VzMxs7tMt
         TGOXvQi/R6IPXHaESHLvBRUUaBE3ZTQ2oCIHjMWuaATu+gUBZZR2SGpwHtUUXt1eryCh
         6xKX8p/ilnjJgWGQ9KQvRNXYytfSBCCP6AgwMWNIe/voAWbk9eVVxe8gaC8tM3cQ9ply
         wATwzcCJZxwot9rPpX7LJLJ/eWMlt6VvKZBSWQegTY2ZeAYLsZjYr8PMW8qOdr+x4QIN
         i5fQ==
X-Gm-Message-State: AOJu0YxR+QVV4E9H5D77yyycVIk6gs0iEKoPX+iCqUD9NdSjL1qJjxeh
	9663FzrZSFEEC3uZk0nb8REo8zcQRYm70iDBRz6SAeVTHa1NeflflQXgWxAg7IpPMg==
X-Gm-Gg: ATEYQzxvPVoFK+qHQMx91twkjyTFJn/8K2qzgBtnm7129eior6n0GMzl3XFY46eotqh
	ecGJu8tMoGqU2r9tklJp+gQCOC5cKaYorCZNnuWt7+YgKXoXmp5Xka7uY3djPtZl9klNwbaJs2O
	wu8RanpvJ1QkA7I0tvBAfNYDPsxGwd7tJF8iPkyeYRSJN7Rd4FRWTMU28Z1jKhqnOSHyQ4fBDJv
	6Jw+aN5ZtAczapfb1Uf+0Re7BlPvKi6dupxxoHMzg1OBnUsH8gmOeVcvZWR7Quezjbz3mVAR3Qz
	iAvoIjkxvb1dtDyUqX0DjU4w0UqOt0ZUd/JjTtwBJkoTrA/55zz+XFm7dWbbB1IBDHrphynJP8L
	VYWZAnhioiLlZuXb1rO5GdcvPe+HyLAW22Oubjmf3so68TV9+fe+GIA45fs4cdFfF/sojw45jYT
	IqaOlCR50q6SJfl+0Nu1dWsp42VAzk2X4jx1fcQbVJYTfdHdRHR1RfirtvtGrqOH7p4TGGm2AM/
	gRcG36nwKoQpKnLDLkcywA+b7/YE87saHIsONdgRGAkwsXdFDI=
X-Received: by 2002:a17:903:388c:b0:2ae:ca87:b1c2 with SMTP id d9443c01a7336-2b0420ab5e4mr3321275ad.8.1773606027680;
        Sun, 15 Mar 2026 13:20:27 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:3db4:c014:312:f50c] ([2a00:79e0:2eb0:8:3db4:c014:312:f50c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b050656d13sm24795875ad.87.2026.03.15.13.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 13:20:26 -0700 (PDT)
Date: Sun, 15 Mar 2026 13:20:25 -0700 (PDT)
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
    Zi Yan <ziy@nvidia.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Pasha Tatashin <tatashin@google.com>, 
    Frank van der Linden <fvdl@google.com>
cc: linux-mm@kvack.org
Subject: [Invitation] Linux MM Alignment Session on HugeTLB Preservation
 Support on Wednesday
Message-ID: <cd02c9c2-748a-a199-3df3-22044493ea43@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8A917100012
X-Stat-Signature: jh7y6ps9b9qpk83kfftmpzah3qdeszwu
X-Rspam-User: 
X-HE-Tag: 1773606029-802346
X-HE-Meta: U2FsdGVkX18VGdMRwcy+1mHYhmy2eTxx5rl4sMOuCevopJ1B8XX/NhkBDaFvP5PNs4f2KKV5xKVKJRUnEUl9iI1/l0yUFY25344Gkw0Xafke0ylGuGIfM30kqnVP5edrVUgF3efGeweQq2/U3dKEtdXEWFqEVD6arDKe2Yn/EY386CI2mEKFQfNHu+uTyteBACdaPTG4qPHEFrVd8HrQnXDl+kWQVKrHACIY3YwT8uFHyBZG/EZpcR4S0V/nQVI2SVvcU/hBaiZgjNZWhQV787EABxGQM/Ja0t/x6ZbygtuApQyrTl7Zxnn0lRVvyf2vP86BcSwqNcVj4ctvaFhnR+njD5wJqNSJykB0N5DzFBB4TlBus6PNc+t9pqMyHDpEkDwRCGShEn5kLUDjZXoWxxyZa9ZlMTLRWsbXT/lDOL6B2xGC3KAk7g57/IfnXHzI3lKYYXBrzAppOk74MfvwG0J6polakZS5lx+FZkcIs7Jc5T1hl+72b9hLudJ8pkt39jl91/pFtrJbu+3y+SCOQFKmNLIeiDsA1xdHqekLTNINnuP2Qf2OQmpAxGRCxhpECzNXckXoZkF/O8KK0b6ywarWHrLGwHa+J/xz5IGXGGhqW46SyVo1FSo6H2dMKyFYwSQ8CuEY6MrFdm2QLuN72kdbRbilozix7NQ72+AYlhJeWuC+rlk/nIkINuqtB8d8vULu+7Kes0hMvKpboEzsp47Jw106rmFb1pvlRVNr2gn/Wt9xPCHVTVwOB9E5FUXRLy0lPogvmLPua5cFUSx5crMK/F9jmViG1FzzAJiIvcFhKyFXSyaNtqcxGhGjbAAKr/xdIVnENfuSildlCWdlElRxQADSd7UQzQ0wllh0pzFw+VfbKHnKsXW5p8HZSiB1mk1IcLtWzj0ie08Y89s0fu4cq8CHvu0HUcbFMKsfUQNntyRsKrXj99YQINlTGHZ61yks3UV7HrzPWdwlDEj
 jieBf9y8
 g3eU52dq6F02bKjro4I4vNdRJ35hPx56ju/0rmA4OrPBScaezNyxjb3DCyYdeL6D5ngAFPR9xRutgRefQjaUwmUhkAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

NOTE!!!  Daylight Savings Time has started in the United States, so please
check your local time carefully.

We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
We'd like to invite MM developers to attend and will announce the topic
for the next instance on the Monday prior to the next meeting.

Our next Linux MM Alignment Session is scheduled for Wednesday.  The
details:

Wednesday, March 18 * 9:00 - 10:00am PDT (UTC-7)
https://meet.google.com/csb-wcds-xya
backup: https://tel.meet/csb-wcds-xya?pin=1301132214803
doc:
https://docs.google.com/document/d/1QQfZFPHa-pGEGf4A06cSqS0jdJwuZ8ro9JU5H0YSUQ0/view

This week's topic will be HugeTLB Preservation Support led by Pratyush 
Yadav from Google.  Pratyush will be talking about how this will work for 
hypervisor live updates and preserving fd's across kexec.

If anybody has ideas for future topics, please let me know and I'll try to 
organize them.  We'd love to have volunteers to lead future topics as well 
as requests for MM topics to be presented.

Looking forward to seeing all of you on Wednesday!

Time zones

PDT (UTC-7)		9:00am
MDT (UTC-6)		10:00am
CDT (UTC-5)		11:00am
EDT (UTC-4)		12:00pm
Rio de Janeiro (UTC-3)	1:00pm
London (UTC)		4:00pm
Berlin (UTC+1)		5:00pm
Moscow (UTC+3)		7:00pm
Dubai (UTC+4)		8:00pm
Mumbai (UTC+5:30)	9:30pm
Singapore (UTC+8)	12:00am Thursday
Beijing (UTC+8)		12:00am Thursday
Tokyo (UTC+9)		1:00am Thursday
Sydney (UTC+11)		3:00am Thursday
Auckland (UTC+13)	5:00am Thursday

