Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A88FC107BCEA
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 00:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1170F6B0088; Fri, 13 Mar 2026 20:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0CF6B0089; Fri, 13 Mar 2026 20:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C1D6B008A; Fri, 13 Mar 2026 20:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E00746B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:27:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C25F13AB30
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:27:47 +0000 (UTC)
X-FDA: 84542780574.23.0928483
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2DF218000C
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:27:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IQJ1SN2B;
	spf=pass (imf02.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773448065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpuHCYoGS7oGl56imcuDsGIrqLNIijvaRFDQVaHkhGQ=;
	b=eAsJlcgmEz+v63o+UQXdqX6zFpcrD7vx0NHDuLi3LMLMgdKqg8N1Nd4yAEqZ/xCOkou1fr
	fm0m0PknYPK81dlTtSUztn5N2BeYLGKLfbKPEV1YirK7bg+qITpLIeXyN9A03H9+oKmzoz
	lQsNxJRCyRDjPM8yKyAKtFkV5yEouBg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773448065; a=rsa-sha256;
	cv=none;
	b=H9nKz8bQLgylQ2zEabENVskuWNlUu/Jl1w9altgN0bV5L6U35UZHbLjBnCN8wxz/brmSgU
	Z+Jw9Jl/ko23cWqJetClvAQKTSBZuROx3TTXtmH4SYuOEZslywgUfjQr8tHtRNwq00hdfl
	2NVyoy6qTJ3OImIXxLNpXpz9Bh8bBTE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IQJ1SN2B;
	spf=pass (imf02.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773448064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VpuHCYoGS7oGl56imcuDsGIrqLNIijvaRFDQVaHkhGQ=;
	b=IQJ1SN2B0ilv73RynObScCYItokrxasQUuIHMvS9/uFwikzQk7u6MDu3wHCEBOaIZzCQ+Z
	x09D0F1YiOYp8svFNSSeXlacO567EMCGyXRoolGvmPaCXeOhUFNTOU27Pw80iTeqf50UUd
	zB/RvFG9P3LHfCZviaCKAPiJqsmSjfM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-adaovf72MkGaZh_9ITwtHA-1; Fri,
 13 Mar 2026 20:27:41 -0400
X-MC-Unique: adaovf72MkGaZh_9ITwtHA-1
X-Mimecast-MFC-AGG-ID: adaovf72MkGaZh_9ITwtHA_1773448058
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C91E1956095;
	Sat, 14 Mar 2026 00:27:38 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.67])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18EAB18002A6;
	Sat, 14 Mar 2026 00:27:26 +0000 (UTC)
Date: Sat, 14 Mar 2026 08:27:21 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH 0/4] selftests/mm: skip several tests when thp is not
 available
Message-ID: <abSraSfIAGRpy4BQ@gmail.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <abLHz2qjdeNqdFaZ@kernel.org>
 <abNZmiL2C7KMQM1t@gmail.com>
 <abQq-Mt0p3vz5rQm@kernel.org>
MIME-Version: 1.0
In-Reply-To: <abQq-Mt0p3vz5rQm@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: -EDVu5m1GdAamf6lyNMOqDBZV3uTOrcvTahi20FO2BQ_1773448058
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: zwc3hmed9fh7bud3nccx4751bob7df43
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DF218000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1773448065-705628
X-HE-Meta: U2FsdGVkX1+B3m/HDWdB8HIQeT+BiZIdP8JsE4CSYqrN55gfkKWTeNrnWiKUWkdSRP0Z8IFJ0R4fSpcMRnZx9UWo1IRPeoGjI4YCXUFG7C0cGcoxDYx/mxypAXOOfl5/tCKVnVocYOzJMOVFIl6o/Cqm1fkGyYQzzVQE/7CNyeHiGz88Evy1/9DI6RtmYJjwL9yM+6CBElYuWjTAo+JfgG6rT4Tlet3KFWgFmGMLbjcQkqCBCueq5s1giURVZ6FvpnsBLh+vhecop3bKvSUG0UEccSzDy0APe1w0cAXDOrvLQwT5QVqufl9+Qg7nYq5JhoDwblAnRoIseTwYU2WBYnPLmdaVjsJF7jW9VZULZ+u0vC8lQvp77IlZ7hkZsYyt7VUz4Nsg+HoebVOhR28d83t4FNPuHATFpCLzqH80cdF7NHWXeuZ3fASwSu4BQmpcPe/RojPnE6loEJRwUcaaMguvyMTLC3hC+th+7RLnxhpx9RJ5vHL2ErtgWJFda0pwlemQf6krBW8f9G8m961TAAcdPkiqlqlTSOMGytBAItResrnr08FQeayeqRe72+zI+SLtydSUgU6iTekXWEB50INwQTjvmSwlBkYXTwEP1G/SE9pDdH9IS4BPXR/2wz5SFa/85c83e08eVLrqhu+QgZFhMlh4jwz8uksrf/bPTnJ8xPf8mQNCIdqGlKatfLZsROn6fqKyqIq2/8CH6w1pCvKI74GZoowrzhmqBQZ/4Bs1Ku2Dwi783Z0khZU6JDeLxk/8jZ6ObGD+TRtMH2oOoOAFrj8waCkhhVlPD/l749rHycYrvE4wVdag7I85iofup8xV+Di7AHByzI3F3dgKUkpD3nV5Cie88D9k6O/680uZ4pIAHHJYME9X/7kfNDCKYeJjY5/GEZDrpDXgyG+r56SYWXzKoSeTPf/HpQno7H5y8zOYz8B2s/ggjU9LZpXR5ctT7gxlABg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 05:19:20PM +0200, Mike Rapoport wrote:
> On Fri, Mar 13, 2026 at 08:26:02AM +0800, Chunyu Hu wrote:
> > On Thu, Mar 12, 2026 at 04:03:59PM +0200, Mike Rapoport wrote:
> > > On Thu, Mar 12, 2026 at 07:40:23PM +0800, Chunyu Hu wrote:
> > > > There are several tests requires transprarent hugepages, when run on thp
> > > > disabled kernel such as realtime kernel, there will be false positve.
> > > 
> > > I presume that when THP tests run on kernels with THP disabled they fail
> > > and it would be a false negative rather than false positive.
> > 
> > This is an interesting point. I'm not naitive speaker. I just learned
> > from AI. It really matters what we define as 'postive'. I presume 'postive'
> > is we run selftest and got a failure report, that's postive, not thinking
> > as it's thp disabled kernel and a 'pass' is postive.
> 
> I think that a passing test is "positive" and a failing test is "negative".
> So a test that fails because of misconfiguration is a false negative to me.

Thank you for the explanation. I unserstand now. Let's use 'false
negative'.

>  
> > I'll add statement about 'postive' in v2 like "a test failure is
> > defiend as postive"
> > 
> > > 
> > > > Mark those tests as skip when thp is not available.
> > > > 
> > > > Chunye Hu (4):
> > > >   selftests/mm/guard-regions: skip collapse test when thp not enabled
> > > >   selftests/mm: soft-dirty: skip two tests when thp not available
> > > >   selftests/mm: split_huge_page_test: skip the test when thp not
> > > >     available
> > > >   selftests/mm: transhuge_stress: skip the test when thp not available
> > > > 
> > > >  tools/testing/selftests/mm/guard-regions.c        | 4 ++++
> > > >  tools/testing/selftests/mm/soft-dirty.c           | 4 +++-
> > > >  tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
> > > >  tools/testing/selftests/mm/transhuge-stress.c     | 4 ++++
> > > >  4 files changed, 18 insertions(+), 3 deletions(-)
> > > > 
> > > > 
> > > > base-commit: 80234b5ab240f52fa45d201e899e207b9265ef91
> > > > -- 
> > > > 2.53.0
> > > > 
> > > 
> > > -- 
> > > Sincerely yours,
> > > Mike.
> > > 
> > 
> 
> -- 
> Sincerely yours,
> Mike.
> 


