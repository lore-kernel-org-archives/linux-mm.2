Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF921C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7566B0093; Tue, 22 Jul 2025 14:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF146B009B; Tue, 22 Jul 2025 14:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB8E6B009F; Tue, 22 Jul 2025 14:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 536D46B0093
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:47:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3F6A1404A5
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:47:58 +0000 (UTC)
X-FDA: 83692785036.27.5B729C1
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id EDE421C0011
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:47:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="px/4UZxU";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753210077; a=rsa-sha256;
	cv=none;
	b=IPAn/cS0zaerb7V/43ZExquLVsQg4nJJPLGGUSwxTgzpXsI2Djwyt32do903JF/hW94Iq7
	nCY7+eS/uR72IH8ibRMEAl30QzXVFsZFHhZuTHE3CsGF46pF1x5c1kjtnlV1FarKKTdVC9
	Fr7dgFlUr5fVZH+4S8SijE2AsNVa2Jg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="px/4UZxU";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753210077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sCklFQeH1wpwJU3c3owakmNQ9FbOcSJOwXrNUCuwsc=;
	b=JW7qmDdVxbhV13H+pgidcTqFQBnWbme/pZcEsjtpzkahENEZFfLWp5Q9x7Qf/K36twTSCB
	Qhu+AOokSTgiHY7tUqRQlqmaMAXFFSBFZKHik/1h6VdGpx61nKwUJjA4uspE/hytjaw7UG
	FZ/UbDJ/mmsgZH9fVsSw6dMSrtE1eTA=
Date: Tue, 22 Jul 2025 11:47:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753210074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5sCklFQeH1wpwJU3c3owakmNQ9FbOcSJOwXrNUCuwsc=;
	b=px/4UZxUJlH60I/csj7mBusDiqFmR5qMD44hPwbqcQeWS+/juOizvApMMbDvBJ1nexsZzw
	jO26AzePuLJXHPA+HrDuuFUuo01ntMFCnPe/c8vmwzqC+A9Zgfak7zhOqq4D3L3EeT8QOi
	1fnx+s/trAF2+75Rr6x/CUG6BZcLMDY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Eric Dumazet <edumazet@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
Message-ID: <p4fcser5zrjm4ut6lw4ejdr7gn2gejrlhy2u2btmhajiiheoax@ptacajypnvlw>
References: <20250721203624.3807041-1-kuniyu@google.com>
 <20250721203624.3807041-14-kuniyu@google.com>
 <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
 <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
 <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
 <CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EDE421C0011
X-Stat-Signature: wgx6kwqxnfo8grmr31peydmkz48idqgh
X-HE-Tag: 1753210076-85465
X-HE-Meta: U2FsdGVkX19Bo2by8SGbCVIlP8JuYIBq9LnnJJs9ELHDaUIvK2yPwggmZqwAbt/AXcIBXzmn1sYuTt3Tu/OyKvVFxFsIIgrV2ZaVvq2v/zEam5aZ075zuGeT1gpBth4rIiCq9xdYMyLFNqMAmlty9/WfjS/QSk8+vBxGU7qW8MZ0YrPjzlQqnOaq+chGCeXZRzQcKu5y2xRtJWDaU2QMBx9aZ5+Jufj+o3pGWZKMJDMLArT1BLraAPFds258sAQMGqgTiz1fuwHm/SNSppWBAaa8W3/s9go6wChwHLCST6YCIaZKMEG8rIpLed768d5XvcN1yGSuCToumK5XarQFKbBTpbcp8klBTLWPlyrwsYssJBr5BxCwk9KrBPKAo6RovbAjMGX1Mxz4L3V7zMdgQNHWENyrNLSy8G9/1myqhI9ELO9ufGHf8DzweckJEkbhG5n18nbFcHYP49YXnRaXlMZq93X8Fk95k0AIOgGmN5wDdeToh90XVcCwppSx4MvzQFuzI1TSBYXYHza4HtflWl8Jt3Lx2sIz2QT072IFNhzlcsYjjfQA+UtisLG1kFe861nJogffxKQCeVuHFxlrV5zR9BF1S3n9sqD95MtKL4A6pHpVAfMr66sjHhFwJLtoWhJ0gjQp/zArsPy6PSg6CSKaye9+l1oSBBr63Ez/1LLdfzcga7vfl3OoQYTErbseKFb3D2KlMHW2c8h2Zl0YDTE4ap+sdv8nNoQJNX9456wuWpSFvLN3Hw5xMvCE81p0loadjcuNc8+nvoPiFtFEVADvzbNAzgbW7Ao3qHhDsRA0RvpYXVLUAyku7f2XraltYb8s2xuZpAugecXjapdLymDRYZ64i2yu2GImTmqyNy9wWE7isBN4Bej2G1qRN+J7JvhhBviq7cpA2KiojgQnY1IGGv+PuINH+d+hymOaRsbIStzWZ/qMcET1wopVrUcBOVuufS6HiJpD+SoBdy9
 70xguaPK
 MPOME1YJ+fXNAYKxHEnA08bU5FVObFsA7MxZC8izxsU9tGkwCQyALVmRoQdAFlsmIJVwPFW2ghBNSSjO8pJJ5oRtSFNMgYafSomSFM+dCe/LGIbNYABlpudBgPOcPPTz7FrZ/Y5chuoI6YJKkfaCFjZCFFeCGvfP2wSTtgLeL5mpqWkOCTir5LE3j3CAVjLTJALFhn9MWCkZWOxinVGzg16UBoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 11:18:40AM -0700, Kuniyuki Iwashima wrote:
> >
> > I expect this state of jobs with different network accounting config
> > running concurrently is temporary while the migrationg from one to other
> > is happening. Please correct me if I am wrong.
> 
> We need to migrate workload gradually and the system-wide config
> does not work at all.  AFAIU, there are already years of effort spent
> on the migration but it's not yet completed at Google.  So, I don't think
> the need is temporary.
> 

From what I remembered shared borg had completely moved to memcg
accounting of network memory (with sys container as an exception) years
ago. Did something change there?

> >
> > My main concern with the memcg knob is that it is permanent and it
> > requires a hierarchical semantics. No need to add a permanent interface
> > for a temporary need and I don't see a clear hierarchical semantic for
> > this interface.
> 
> I don't see merits of having hierarchical semantics for this knob.
> Regardless of this knob, hierarchical semantics is guaranteed
> by other knobs.  I think such semantics for this knob just complicates
> the code with no gain.
> 

Cgroup interfaces are hierarchical and we want to keep it that way.
Putting non-hierarchical interfaces just makes configuration and setup
hard to reason about.

> 
> >
> > I am wondering if alternative approches for per-workload settings are
> > explore starting with BPF.
> >

Any response on the above? Any alternative approaches explored?

