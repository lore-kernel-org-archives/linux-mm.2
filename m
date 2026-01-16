Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE99CC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30ADE6B009E; Fri, 16 Jan 2026 10:55:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2D16B00A0; Fri, 16 Jan 2026 10:55:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169396B00A2; Fri, 16 Jan 2026 10:55:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02E9D6B009E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:55:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4BD716015E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:55:30 +0000 (UTC)
X-FDA: 84338276820.11.E7C58B2
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf27.hostedemail.com (Postfix) with ESMTP id D605D40011
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:55:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=M6rgvyOo;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768578929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nC1t8XaX/bq14ENSBQ5Fda7IB2vEXwzrtJEP49kE9AQ=;
	b=nWWMFaEE5oKCe/kbe2VBeFwOW47l6U3znFXFdYGq5OwA9v/R2o3Jyd1zQ5J9GoRQ0mVWly
	O5pPSPjt7SZJ5g0aD6VZYD9KsVGF5hfJ3JIO7W9X7Xg2Oifq1T/EY+8AN4rUH8B8pcXJRj
	iu+CYsP8YOvBZ95jAMdmuseH21D1D50=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=M6rgvyOo;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768578929; a=rsa-sha256;
	cv=none;
	b=bPFpxYt/yR0jvZpiGQJ9eWj6AO3kGUOeopfHH/e4JEnCBAPzr4xGVbqX6kQCbsRHzyciF4
	F2yrQ4haQOTiU7hXAxpEIV66GZABCBda1PxVxGqa3xGYWRNa4gGQNAPouMUtzd170L/uye
	77mDgl4+YDbUBSAl91ZIXcK4F2Vt/lI=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-4801c314c84so11610065e9.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768578927; x=1769183727; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nC1t8XaX/bq14ENSBQ5Fda7IB2vEXwzrtJEP49kE9AQ=;
        b=M6rgvyOo7r+lGlnlkWalhJ8ma3IEt76N/veWk2kYm1z/Tnos21wUao0SzlyVorcu16
         qVP3zaTCE3q64ZWFEeXXh5hoqAKdShX4kj8fHnwhL2vw+gJL4pOYxPe6ODaV/63lLGnw
         ViiXhb7nCyovV1YP2lO6TQqwvAyIazDKDG32mDvcZkIgT1AYIXceGB9OKD/jDl2PYAzs
         Guwh68bWSs0Y0Uwv/VyuQQ9O7dI4ug89iQNip7UBmZIXlCmfKGa9T9NjsSCp8HcGyIBU
         mxlB/GZe6Oc/TopVeL1z9yF6GGDch7twltD+DAapvHe049Y6kY8kyrgc9UAzNZr/X+NI
         nbNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768578927; x=1769183727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nC1t8XaX/bq14ENSBQ5Fda7IB2vEXwzrtJEP49kE9AQ=;
        b=V0GCSwKpVhG6WGthWWQOzRuFnBBZokmKrN/U9xB13+1463MrHV2D4wvLIzDBgpFGWl
         MEKAASit/dBR+fxqiHi9MvoG6W9ds3MFlyYADEegneLB/RwXkm4qzj6/IrXgsJm8cPbV
         8PUHBv1t5cDcIxmp2o2gRJ45oMgl1TDMznL0KOvcjhFuvBQb2H2eNZA5Dfho5/rfGoUu
         btPFuDLPdM5WuWWOo8bo25d2iFeTaf+L6zbTSFcImqsNeWo4Kmhjmxplwxnfvgo7V7GW
         LZnOWzC7JR8Z/4bQM3YMpqi2FRjcLMqvSbQidz43JRWYK3HoTTN3V8R9W5pNQ6h6vB0J
         uxZw==
X-Forwarded-Encrypted: i=1; AJvYcCU5BrV7zlHT+xpX9CVJhWF7z9dUzJXmG/QegjvBxqa9QnWpoiQNpC74DxcU2xzW1ONbyyRpnneimQ==@kvack.org
X-Gm-Message-State: AOJu0YwFStvdh387NPaiGy9tgjQFjgtTKoDYS1fBguFkjaRzlRG7VdGB
	+gf9FsikqiUcsSTyYdvB1/j7kJZ7PzM66t2rmehg5JuvQu3v0yYASqc2PbAezhAsfaQ=
X-Gm-Gg: AY/fxX4tniUC8q/vVlf7yTGWtZtbppJGFje5ErA86QOJgETQVNciynIHlK0XMQGiX1F
	smhPmnZaXY1Vwh3KaIqWg4dlhrMBqphif61x0lmHHtBURtJrsegaQKEji+Bvyg7JB60FzFIvkTK
	1Tq4JMcNWxGW4fXwAhAtOtKlk+hdTeo+E2k6wEChixIzlxD8DnXKdGW3NQ6rGwmcK6vbwI1yPfr
	uQwKnY3CcPcJoSPsK4SazPFN1gIZBQplDo/hG1UV1OPlq8M+eyo5izHBZ47XwwCdhiwt9qdUa3O
	YrYDEe1bQQN0vf3t+CUVPmjf8/aM3feez10ewu/XOtr8eGkJ8WaCV3QC1ts4Etbc3khVIEdAEOW
	jZyF88LSCIjSKSV6+BnL/zOdmg0ge8YEfYf+Y02vcNrEAdafzjjfJOccBm0bNJE11dj7ahvo+99
	NjJZPP9eembEcpF1ULxFNRG+tlbvyOocOXkoA=
X-Received: by 2002:a05:600c:1f12:b0:47e:e9c9:23bc with SMTP id 5b1f17b1804b1-4801e34ce8emr40733615e9.30.1768578927236;
        Fri, 16 Jan 2026 07:55:27 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801fdefed9sm19855285e9.3.2026.01.16.07.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 07:55:26 -0800 (PST)
Date: Fri, 16 Jan 2026 16:55:25 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v16 3/3] mm: Reduce latency of OOM killer task selection
 with 2-pass algorithm
Message-ID: <aWpfbSJe5vREzzyd@tiehlicka>
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
 <20260114145915.49926-4-mathieu.desnoyers@efficios.com>
 <aWfNMKCoEp2LuA2v@tiehlicka>
 <a46b298b-baa3-4998-8715-0568b5b186e6@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a46b298b-baa3-4998-8715-0568b5b186e6@efficios.com>
X-Rspamd-Queue-Id: D605D40011
X-Stat-Signature: hwxjci4fhwahd5bkhiq8wy1s8stejy3u
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768578928-759793
X-HE-Meta: U2FsdGVkX1+P1zkT38WPlQaP+dVEXLbojTgz9xokKDYr7cLIh573c1epSGBAXWFuo33k+uSIrqKQQoxn3MRTrT4V9R2dn2mSD0ycMtmngG96d9sKuNZeTIzkchyjWwKAmdWK6yk38iX204kwG2UWkCY84xT0HPrI6YWkrv/ZtqzTRPNzSfvdPp2w5tHf1ztMw6AUUg5XtWnSmHQcHktutXFKnJ0CYj14BS0DK2x8Y4wuAp9ld1gKg0iFd47clTo9prD5b3sFZa5k5KjAwJVynUjuEbLQLuWBb/dyK2LZeMF9VdNMvOGeX79BD+k73M0nN6DdKwUDDY3MHUbaqwfPwOsUWL1ox+oLFfB8NG0a9bcALzXMpXPWHGVEjqkJ9WOuisbM8wgobU5boWO3Wb0U/Iuw8YyuRZLG6fw+zjtH9gZiYJzg0lWDjbZOXvs709AoIhsJmU45jjJnxQZ5sapsQnKeE8JXi1s/2l4cBWYeFgrG5uU2KxBBnvFDlN0UbJYkfyBIMD2WnJXNRXDMvfNdrpW1BbmtWHDG1WfEexGIrQUQhXgK+T2kP6NStFEV/XHVnGAfPWDUW4BaegyMO4YHn5gG/RyN0VcI1LChbc+U/ZJSIR7Ayh5U/uaV8SITfGqwg2Yx+IfiwJkaI8/VRjuQWv/6g3V5Xynj3qHTM2Lv9qyRrIQ0gxaXWyX7OUOJOLDVJNkHdB5tauTz3V/hoTLsAGiIJZikbqxVfIhvuKIPbn25HAS9IlM0ezRhNFmY829C4Rtk/xrWQHgfkSXA0quaYd2plzYMJubedPbcMg6Jy8Dds1lgFEyXIlk5t0AVRO8RUmIQvWztnYMOD+b1nEmwx8mNhNCYHgqLgbJQmkOG3aUlTYFr2HLpmEvmdxTmOFj0QS6PYum0fAn8d8NbXGd5XAZECoujqOw7Gci6ynYi65zjSnJadPAiVecrUIjwat/w5gb0cFzlI9c27YlA4c2
 TdtxM3mV
 DkQCGkY77n+D8q2GG01MU9x+qNu8xk5NvEmXxEiQBHexVQs7NNt0dgrmn2qZAHs1TTUzwHrI++kyKZFAanudaND6ZpbZl+CN7nSQ6+CZWCt27PdopZB/Sctl9SQX6no6n6mxIdda8RsmU/qts5BWNgqJjaBsittoyHddtz+i2xsZGJ7dMrx54rWAiWk6JJZsrMVD5Vn8UbEY1GLZ48+HYHUth7+KbbEK/anqwjF0EgrTyxQicI2aPULKyQPXedENwzNldXm9dJe/eiakN047INkicJyImD1gXKwurAbvHe+7tY2IeJMiT+1x1ddcQJ/fN5wE2LAQhY0j6hGQWyR4GOcQU6fgB6D0dkik2pO6rnqdF7lB/EHcd2O0XPV2qa9NG5xJ/RUmve9IpC4cU7JI9wPZoxS6UX5fvrWs5Dqt7yfI2ascNEJr4loDQ3O+yLeKOdyTTVYu/t0DLQ/45kOSOFKNfPGmRh3syHOKqF/od/cIUkMRd27lzXAZz8lu2K6i1d64T2afBOdJnhRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-01-26 14:36:44, Mathieu Desnoyers wrote:
> On 2026-01-14 12:06, Michal Hocko wrote:
> > On Wed 14-01-26 09:59:15, Mathieu Desnoyers wrote:
[...]
Thanks to those clarifications
 
> > My overall impression is that the implementation is really involved and
> > at this moment I do not really see a big benefit of all the complexity.
> 
> Note that we can get the proc ABI RSS accuracy improvements with the
> previous 2 patches without this 2-pass algo. Do you see more value in
> the RSS accuracy improvements than in the oom killer latency reduction ?

Yes, TBH I do not see oom latency as a big problem. As already mention
this is a slow path and we are not talking about a huge latency anyway.
proc numbers are much more sensitive to latency as they are regularly
read by user space tools and accuracy for those matters as well (being
off by 100s MB or GBs is simply making those numbers completely bogus).
 
> > It would help to explicitly mention what is the the overall imprecision
> > of the oom victim selection with the new data structure (maybe this is
> > good enough[*]). What if we go with exact precision with the new data
> > structure comparing to the original pcp counters.
> 
> Do you mean comparing using approximate sums with the new data
> structure (which has a bounded accuracy of O(nr_cpus*log(nr_cpus)))
> compared to the old data structure which had an inaccuracy of
> O(nr_cpus^2) ? So if the inaccuracy provided by the new data structure
> is good enough for OOM task selection, we could go from precise sum
> back to an approximation and just use that with the new data
> structure.

Exactly!

-- 
Michal Hocko
SUSE Labs

