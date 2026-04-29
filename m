Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE0CCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534C26B0005; Wed, 29 Apr 2026 11:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CB16B0088; Wed, 29 Apr 2026 11:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB856B008A; Wed, 29 Apr 2026 11:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 308356B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:24:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92F881B92B2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:24:48 +0000 (UTC)
X-FDA: 84711965856.17.0806A14
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 49B04180004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:24:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CaiSu+Nc;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777476286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAXYezcr0Iy1hB7ntqgzjazz7eZ4Gyavm9fB/UWyNQQ=;
	b=1EZYi3LK4v4t/7XtlXN8HBr6onN1lhODUb371Ib4J3xukcfYgX4uFqG12rL9lJ5KVyUOvw
	7FD81Ly4eL9DsuneRF99QHXKez39Qzo2bVG2jz42pvu0ClAVxymSiQtKQuR63W7fdwyOy5
	ydPsEAmW8ezSChXbyC88EYtAk+SVn6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777476286; a=rsa-sha256;
	cv=none;
	b=bGPtPqDpCWd6Y3r2k2SXD2JEt7nTB9Vpz0tapwVah3riXCB7taxjwbtVAz9Lu0qC3pJIdi
	rhR1JgKZ2gVmB1Y3Ieb25eJLr6DK3fKG3Gho4HXSnpcU0AP3dIgjnTsxn7E5qn6b3xQFGb
	hhhWnjcJAc6/bcZPx6vTmffOooOU8os=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CaiSu+Nc;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777476285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZAXYezcr0Iy1hB7ntqgzjazz7eZ4Gyavm9fB/UWyNQQ=;
	b=CaiSu+Nce63Kzlu/BrEjKx0dfvNEJKiHc+dF0V5pk7O6VNRzLfr8j3d9fboy8KR4ZMGasN
	3P7wIMVwV6WU5BcPyHtfAKc9cjdUYlSMnjfvZfbOYaUlefHW3EUkCe5jAcaOnqAknVYwuc
	qxkf2DqcmrYnNFz9d6wo8VL9fSSG9ak=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-JepyDPiiNe-cYpKsZOgmKg-1; Wed,
 29 Apr 2026 11:24:41 -0400
X-MC-Unique: JepyDPiiNe-cYpKsZOgmKg-1
X-Mimecast-MFC-AGG-ID: JepyDPiiNe-cYpKsZOgmKg_1777476277
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03E3A1800451;
	Wed, 29 Apr 2026 15:24:36 +0000 (UTC)
Received: from fedora (unknown [10.44.48.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D6F7A180045E;
	Wed, 29 Apr 2026 15:24:26 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 29 Apr 2026 17:24:35 +0200 (CEST)
Date: Wed, 29 Apr 2026 17:24:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Darko Tominac <dtominac@cisco.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	xe-linux-external@cisco.com, danielwa@cisco.com,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
Message-ID: <afIiqR5CqYRId0N0@redhat.com>
References: <20260429131522.4049054-1-dtominac@cisco.com>
 <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
MIME-Version: 1.0
In-Reply-To: <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: wEKLiwmg5MIATFEguFjpIafdJAE9SB_9u5DbpyLAGiQ_1777476277
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49B04180004
X-Rspam-User: 
X-Stat-Signature: r3nxgfokxhqmkeci41dy1mako47addie
X-HE-Tag: 1777476286-52003
X-HE-Meta: U2FsdGVkX1/h+TlVKSZPtbnu64WzTfVQWicLXaOMR/uV9gzH85QBlPMJcPaTbmO31MXsRDJF80FVHVPlkirX61BKjByhZC+zPUJoPhP5GgMI4063EG3QHgmk6M9OJHR1F46LR9bUBucNKUCNh2bMX+q9l5XlhnW7txuBMu5rkeSNC4GG/lLLpwavqZKwfSNPy2Tm9Mr2JlrKWVorgqO6/o2VqH9enrVo/hzVQ7g3WQpDhy2A8jC3b13r/uvS0M1o95lijYyghxWhVl+c/zzdJNKfKzOmaxdSq5UKIiOHS2/i+sOI5u0UDdgRTIZXOk0BHoEl35qIJGcCU3nYdyCW2DQyNLCXeTaKQcjbReRLV7jC0yL/cNbWslfzVv+0X/8hjeG1zW4q8l6IowdWZFo5ZpGRik8yQcZPOk+o55Ymyu7kilcS+HxeCSGe3rTkTkrj3U7ZuuCeLdzEs1rv6A9yO3GfrWlqSlt4SUYlG8IvPCOxDDN57hOagGCio8JsqdO7pcN/lIJzOuFZ1BItgJ3I4sCDJvmqCK73nCWS/3RHeHNYs5AkwyoMMj3RMIogqRBDLZjNM0iGrLi/U3suFbYqo8J24hhpxWMygE5MeM5sosM0UG2v+uvoUpDserw5PS6dY6MSyMPBIF6MYuk2AmPZak1Yxc9C1gwiV0nQHwyVa/Zq/gK5HibSJwtwym7sO5kusrhqYmnHw/DxLA+e43u5nuGc3UmRZPe4GqOAcLX69xembZv9yihLmS2poAi+coZHhWnlzMJuSHMcOL7LnT48hQXzeN88zp+bIckAVRoTyjLdSoP9VtcTDoQA2KF58Y6gANo5aH5fH0BT40I1t+g1J1+RCEtF5w1MUJRnJi8bFLYddt1aJZITNpER2KRDJ9eAoB1Omax9yk0dBo0Q2nGDNvxDbQH2zwND75Jl0Q6Tvha9Cui8YyZJFNakThrUCD2nFVlviL8fDCq4YZ2dAer
 mW4lHeLX
 /AqrmCaORye2nd0/DWkeWKWahWFQPoqdNi5jm7nyzCVAPo3ZJPuOfX6TaQAqY4xAWeTG7ja25+ogpoaBr366EYDJG282/fIi1w0qt0TsP2vY1MkG51XZ4SyAoN0IYtGf1sJdDP7P9I2Phn+I0HBnfcnuJ7WG24XPSLTglDLsB235a+BvGbr0UuQW6YreBoeGp3HLnY2GKtuykF7jRSRbYNFze49ivZzg6o8Pc098dlio4JSfLqkrPc2talZSAO3UfbOjhRMEgxJ+QWazjT/aOZF3yHZNrKVmOcJt3kL4HFBAT/B4MNodSIpVzGBgobqSNJnAX0xA6utFhWjo35m1/bo5Oks7mLatVwdGaP/0kic53itp1HxI61hh/eKm2mVGm0kASaS71qhKh14Y6S8TmHIyvBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/29, David Hildenbrand (Arm) wrote:
>
> On 4/29/26 15:15, Darko Tominac wrote:
>
> > uprobe infrastructure does not re-instrument pages on individual page
> > faults (uprobe_mmap() is only called during VMA creation, not on
> > page-in), the breakpoints are silently lost once the discarded pages are
> > re-read from the backing file.  The probes stop firing with no error
> > indication, and the only recovery is to unregister and re-register the
> > affected uprobes.
>
> Right. Don't MADV_DONTNEED uprobes, just like you are not supposed to
> MADV_DONTNEED debugger breakpoints/set data etc. :)

Agreed, thanks.

Oleg.


