Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB4DCCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 15:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E42080066; Mon, 27 Oct 2025 11:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBA18000A; Mon, 27 Oct 2025 11:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1C080066; Mon, 27 Oct 2025 11:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE3D8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:55:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DE7F14018B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:55:13 +0000 (UTC)
X-FDA: 84044343306.14.F17DC25
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf04.hostedemail.com (Postfix) with ESMTP id EA45F40009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:55:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xrOOneM3;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761580512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Oww3CGmP1wV3xSalTiZsZV9ZqwE3MH+4I3z0fYx0m4=;
	b=DPNV+btK3czWsblzztjOzZ+dbg1kGRKaS4RUKWZVeps4rhcvpaq5nzAPVdOkhODSSDJguq
	d4a3gzChHWcD2xrCpOv6Lim6jACxBb4VpeJCAvdYSqdnHH2vjBPoZ20tisWOdZqOcxKKDO
	YBG0JjUmIEKn8PZUGi65hROWhGZeGug=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xrOOneM3;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761580512; a=rsa-sha256;
	cv=none;
	b=SiVTPyAaOpfOH421iby8B5EMVTCBgLIMYeuTTY4PdMrBklNt6vTNlH8QEeU7aCqSWQu07+
	fLIHPbA0UuAfTEDq0UbnZ70NxL7WR+j27pQ5aBIpnyRf4PdNI/RCE3Kw11BPe0+oKVUhlt
	XpA5KxcaU52HgbLIK8qP46Qj3KCKx74=
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-290d48e9f1fso371045ad.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761580511; x=1762185311; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6Oww3CGmP1wV3xSalTiZsZV9ZqwE3MH+4I3z0fYx0m4=;
        b=xrOOneM38Y7J4OzkMwbIiFvnG5nANQKSp07S/VgGRIW/+7YHv4iSGFY18dhQY4YXTN
         Roy5CW1B2GuWbXJEygu8VcnxGPgoC07ZYXdWFiN3lxs2xeHQwVdq9FfV59mVUi6HUgF/
         A/70toJHZdPnWntLU7AAClS5Fphruy/b2loTWMQ6VpRVtB0STRSkH1AQGwD9odL73P03
         sC2m+za2yaUb9PXFz0ySzP7Yg8VPh/FjlwbJt4zr+tuM9/e8tX6UGbJlp3YBarvtUy2r
         ietQchnBBs78NSEO0RPXaJsDPg7AxhNNKavaJIqtK5Nbit69DS0eQA2yh5zS4bpzvhTK
         +1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761580511; x=1762185311;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Oww3CGmP1wV3xSalTiZsZV9ZqwE3MH+4I3z0fYx0m4=;
        b=upEIJQXHWOizNrKIRGdH/CK5cKcjhfGGNqqC/S0/AhMwrscPC8GaS8N0xASLr0mVf1
         0DjtSicwTJwB4jgxzOZyO15+Rxu+wc0qDsyfr4LqrRBgOuNCzsve7xmXIPL7zz+X47pG
         OndFgCClR4OuPz0IPthSfjagEk1wW0YiaPx/0P7bm2+3NAHZxd5f4bH/ZSnZiQ9uJUFh
         MSf/+C75AbloAt9x5WQopBas3Ti/KLOCzF/lxqXWKImZCt6/EOfk6bD3FNDKSUQvNz3u
         NZhsdCvPGWD+K8MhxDKEWixAno5ZNMje0LiBuam3NBShDS94IQVUPfHaVyj4letxxkMf
         UWGA==
X-Gm-Message-State: AOJu0YxNet+KgogId3rdUdnnMjep+YSDZfe4G+yl6q5uJ/stfGePXOkV
	7/1rtZefGoch1/PAsGiV5oLVgrMb9UU8KrWYSGSJkCcYKnVM0pRJC4tC7SdlT5kOrQ==
X-Gm-Gg: ASbGnctR6OiytABIPk+mDjPCFfh6Bz1V8HpdpJ/Dy/AgJ2w2qgQy9TO3n+BwLIHk08W
	z49Jzn4Ce13evIo4HkmUO0ekD+/rsAzjaxCyM65F0khIlh7d04bC9S8WriAKqMHti6r5TDEt/As
	0Py1ntD/pkftNFlkTtGqtEu2f5vPxIV1WYEW3yNFaYPshfVscIBAG7k4vm8T83IPTMK1xpv2yhH
	O1gXImx8CxU/qJ+cXy5+aR3VixDkZpdhz4zplScq/BsIJDCRcXd+jlrqXMJiuE7/ygdnXqRSWQ+
	9XN1Ir3njB9fQs9VxLhlvHkjR45czBrKuXJzwWRPIdPoj0oTPjTzx3eyWDz8bx/eNdQwBjuvWfL
	5d3ySBW4h4eJCWB9Mpn8JBP4S/+q17mf6gL6LUGEvCD4E9/lJSkV1uyexqwCCnN0lLcIzjBAGTs
	pchMPB6Tgn4YTI38ac64UYRHNJpLeEVbyFIb/vMw77ztD6WCfnHJ6pWiptdsLqDTmrOizad0T3U
	hE9YIjKF6dtVFt8YGvBdjVYEmp/URdAKLZ/a9aKqA==
X-Google-Smtp-Source: AGHT+IFAygkDhdDesD6JSy4kvvW5ANJvTI0YV4mQJAzgxS5me6mWgRI7Zh0IxGsSPkWbgM7cfn1jJA==
X-Received: by 2002:a17:902:dac2:b0:274:506d:7fea with SMTP id d9443c01a7336-294ca9b2346mr708825ad.5.1761580510301;
        Mon, 27 Oct 2025 08:55:10 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:ec2a:54b8:6afb:1576] ([2a00:79e0:2eb0:8:ec2a:54b8:6afb:1576])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a41409e456sm8531999b3a.71.2025.10.27.08.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 08:55:09 -0700 (PDT)
Date: Mon, 27 Oct 2025 08:55:08 -0700 (PDT)
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
    Zi Yan <ziy@nvidia.com>, Brendan Jackman <jackmanb@google.com>
cc: linux-mm@kvack.org
Subject: [Invitation] Linux MM Alignment Session on Address Space Isolation
 on Wednesday
Message-ID: <b7234cea-c015-8813-237f-cde6808894c9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: w1rwadfp4gi9rby1144rkfo4bpf4pufp
X-Rspamd-Queue-Id: EA45F40009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761580511-6607
X-HE-Meta: U2FsdGVkX19+hih31ESFBctUCu9Z+Z9DTNUfQ0iO/HSMusCtVMUISaKoeGXVoE2PnCVC4Ctce9Me6jK9eVbM3fUjyeSQ9m0QnGB16pRxMj3vCEzspuKhi24z6a+vcUiS8kIxj4yBHSZEvtdNUarbr8/OBMMC6qgwaNwTxnF5TrRmNxLT9a/W3LOU3TpSoBaxOdy3sIedAzjCzlP0pV5NrDLoSriz+568rx8KMnMJuI5rf2iyS58Qd6jNbdxyaJHLL7Af3uUsAy1NWn+ukKgvvx9VGGNakoxiKvS+U1Pz2bh3tR8vVTymfy3oG1U62fXl3Xsg2JZsFExWY/EnrWfbKXzMjjwJaHFNGKkyy2tTEiTTlEdGtbEiz9gtEXrGpF+5L70zERoFqwmlNZIFo/Ce+V+lTXgo6sm0XM35s0nqAnVCQXsvzXJs0pDHf94jEhwG78MJmOxPd47gCMG2ASCa149/05P8nxeNa8VEBPSzV2yYtbEqPvZtBhdVr3lnLk+ynTp05KjsD/natU+coDle7lf45XUqhqYF8mA3OK+P4yaNSYUiJ+gho/P4yMc6bcyB1bd0osKRtq75W27WJfM7JLx3WdOlGwUGxBkBYa3U23OGJAbdTuB9DvSSggp7hgrxHfSAq8OE8pgdzGJfd8MaGdN0qyN2IxcNW2JTOJ4EUMpRvvhaP0qQr7ufj1TxIptv9dGvaTrIHDuunsggLWINhxUxEqaFAwGnXGKQuP8vknWoeTZVdMvJHnkQP4g39U9ZywyPyglnGVsCgrUoyxg7FUVoHhgSILFtNyavUsvMId5R9K5XXbv71uAP5D9T00DbcZJu5pb/F44BzP4Uwd19kHm0+D65A0j6JWrgnOROzsu0Ajt+k57JZi02HZUHBTxLMHg3SsHsSorU7dkqlcwyatVUwIZfsFG0Y0QVD2+Oz5g16kTh8zPgpz45cpmYqCS+T8THz6u6bQC/4+8KA/F
 MhtxNfKx
 v2V/PfajG8SWs8iwelQbrPA7mkcf3uNkTI2rEcozZ2Acz2d3RiH/0sze+81BbNrs+k7M8UOq1v1WEUZaovZTI2sT1byydqadsJUqG7QjvIzOn+Hegi+Crlj7zf8mPgyfJ8v9JR8RBx4hjl4R6UtYpluROqzFPcBfXBhDK13Vuif3vxb7J81Qfpjo6zGtdifniDCEdyEcIHAUcM9Idnr1Osmn13vKZQ3fUBx+0VRioYv80qyBGDF334VmlSvG6T2u2XB1tcdhwNuBuHtTfPcSoDwU130iXGLZ0W3R7yZGUjbssXCIxl9ctyZ+xvjFHR/0QP11ofqVbh8kNBUlRF70MEV489/7SrpV24vGxxOZB5Ct9OYkkWeU+wGd1pDxqjfmGrEHxC//xwp914un3lMomh+hksMKmlDk06Q5LQnqhpvwUVT5GzycB9ShHkbqQk6zgpybS0qacZT2Srzau3hUSeRv9Z1go0CwoBPgGQX9QoZ1xusmDc61x1cgC53LV42hYAxuPpLZPcjaSrJnS0+xwg5TvNrtrwdbeeXZwTm21aOMZcBCnON9Gij3i6AiMap5PUGSw1k5r1rU3ymslbInm05SkOoaa1hBT1PERg/mi6/TRtRKmLYeGkkhvhSLq7oEGR+TZnm9/lIKbctC8/uQQ3qQXGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
We'd like to invite MM developers to attend and will announce the topic
for the next instance on the Monday prior to the next meeting.

Our next Linux MM Alignment Session is scheduled for Wednesday.  The
details:

Wednesday, October 29 * 9:00 - 10:00am PDT (UTC-7)
https://meet.google.com/csb-wcds-xya
backup: https://tel.meet/csb-wcds-xya?pin=1301132214803
doc:
https://docs.google.com/document/d/1QQfZFPHa-pGEGf4A06cSqS0jdJwuZ8ro9JU5H0YSUQ0/view

This week's topic will be Address Space Isolation (ASI) led by Brendan 
Jackman.  See the latest direct map management series at 
https://lwn.net/Articles/1039549/

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
Jerusalem (UTC+2)	6:00pm
Moscow (UTC+3)		7:00pm
Dubai (UTC+4)		8:00pm
Mumbai (UTC+5:30)	9:30pm
Singapore (UTC+8)	12:00am Thursday
Beijing (UTC+8)		12:00am Thursday
Tokyo (UTC+9)		1:00am Thursday
Sydney (UTC+11)		3:00am Thursday
Auckland (UTC+13)	5:00am Thursday

