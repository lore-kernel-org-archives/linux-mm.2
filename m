Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65453FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 09:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5C96B0088; Thu, 30 Apr 2026 05:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366B66B008A; Thu, 30 Apr 2026 05:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255966B008C; Thu, 30 Apr 2026 05:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13CDD6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:17:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2D13140553
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:17:10 +0000 (UTC)
X-FDA: 84714668220.25.0822A88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F770140002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:17:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YGh05/7U";
	spf=pass (imf26.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777540628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zASkZpDnp0HKO3Di+BYa06DeuxEaSIIb9mLPGirXHSA=;
	b=GSj79VrPkH7/4hrK3VRElKS7kc9FXVzw02EveS8z8pko/svs594xgaecfEFdGLPeRzuPRl
	XOaNsstOa3NHDsiR9FzM2xZ8yJ2pSE29bEb+cKc7TxCggkYxXZKCFOE5huznJFDtBKjuIk
	0X2nEV9PRH63Ep3LtJgvohBJLOaHS7A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YGh05/7U";
	spf=pass (imf26.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777540628; a=rsa-sha256;
	cv=none;
	b=t4mqlcZLgCcHPdMbp2WtnY3Yzdg8MQaC22P5fA7W+e5Fa40lEv0GHGjVUXqWELhZupWdHI
	hTP7iFQFG90eE8OWfnAasW1vlfaV3mNElpuwcyu5XG7GH1Ao+FMdFhJGICcDI7qxACy1PH
	Q9COFHleV5zUNNSF+vWea2kX6/ZZTr8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777540627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zASkZpDnp0HKO3Di+BYa06DeuxEaSIIb9mLPGirXHSA=;
	b=YGh05/7U9KnnR3DdfLPh4i/ZH2WLhUnGAwFlpbAdPujlAz3s30CYD6Tx9C82mBsjuTulW3
	/TByb4V4gJDpIwDDkzXg+uKUA2IAtnleihwLfhGdbGZed5SXOz/y5ls1a/VXHAjZ3VtGcc
	eFuGMXrFp9So8tFMOIbJ4feh1C3WHnI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-jvU-4sD1M2-nzrBsuwhr_w-1; Thu,
 30 Apr 2026 05:17:04 -0400
X-MC-Unique: jvU-4sD1M2-nzrBsuwhr_w-1
X-Mimecast-MFC-AGG-ID: jvU-4sD1M2-nzrBsuwhr_w_1777540621
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E4C01800358;
	Thu, 30 Apr 2026 09:17:00 +0000 (UTC)
Received: from fedora (unknown [10.44.48.22])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 48D911800480;
	Thu, 30 Apr 2026 09:16:51 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 30 Apr 2026 11:17:00 +0200 (CEST)
Date: Thu, 30 Apr 2026 11:16:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Daniel Walker (danielwa)" <danielwa@cisco.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Darko Tominac -X (dtominac - GLOBALLOGIC INC at Cisco)" <dtominac@cisco.com>,
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
	"xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
Message-ID: <afMeAs6upm8kLCYb@redhat.com>
References: <20260429131522.4049054-1-dtominac@cisco.com>
 <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
 <afIiqR5CqYRId0N0@redhat.com>
 <afJz3l6435DHLorn@goliath>
MIME-Version: 1.0
In-Reply-To: <afJz3l6435DHLorn@goliath>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: GUa-OPaUki_3gfeVIhQWt-bQ6e0ZSuEIYuxVXYGQYqo_1777540621
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: feo9sowe3p8a4hrn9gch7rw9x1dxqxir
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6F770140002
X-Rspam-User: 
X-HE-Tag: 1777540628-588893
X-HE-Meta: U2FsdGVkX18knlj0TePZxnk5S0emVXxTQrIOqUN1WKuQPEeivUW54YMfRBo3vmflnjzht3A4VxVwtlrN5oVGnL5SgSH/K91uU8FIlsc0/rm+BjTSzWbB785WavSzopcINWVYhDGi/id5qzFw1tG6I4nKr6osUbL/P3UnVfCjgFmEQCScNr0wy+ZiGTC0gcUmWAIc/m3TgtSUaVMXde+L/ycFbKAgNYP6U9ZfHR3Cq1SNPJYIM2hXxFt0PU3Hlx/+54uK7SIsnVCvp7DV/+Ec2q+OYUBvG2jBZnsLgdlwNluAaA8IyVqCtsUt/tqlNxDtDna6LwTEw+5CM17/7ld8Z/eZevGrTNo7SHhLMuQzE4j4+mofsck/SEctEoMhBmbNegjg1vUbc3qdd8+8ecq+XLLWh/MscsKtoaRYpSCQADP03kMMHQFGMdGP7FuRuiKwiQnuufunYdaXsZvbzwUGG5ZEo5BoyrRy3xiD9PyKPucL61p2Nuekgd0EUlEyqwsLchXZeaTnpfqZIevuXf3sPm0mbzRS4oANRO7Pmlz1bHOyMoqg7tYznj8Sj0Smn+AR7HhgIl5v4hLWt+UFkELcnSxncZCOF8ro8NUyzgzh7J0fqTJNYKn2u0fNetJUmGTNIM3+WSJsGqle2rjZVlWSa7T9Q4MPlnMs1jFc7vB9v0ZEmuVsZvzZo0UNH2Qf8JiPAGS4rHc3GrlW0lthp2+f9uzJ6f/8grpWNtSRexetdUFkHH6agefAzeIpdDalzGTImq6Tn2WZQkXc15LsV2LuYh++wY9UcfcQZLUQEAd017/bVmkT46GwnM2QlN81eM4IDU0JrWGxYk3ChWWDYloLZEEeIf8Wzj4AAQGCdP+t6DhkmisTBalzDRIciMeqqUM4kZYn8rcV7f9+47m66nU+4XtuohybMqyHe4GiFJAdizRw1mo0NPHny/Rt3z5jVrQsjVK5P2+KKYM+cJPG5ys
 dWKgC+2S
 tkuIxbfBxVhm/fuSz45lyj97Tf3cz9pvU6yCGpEbO/i+L5X08T26ObGIqLwC2aZIG7+f9j29lR6+JzmRNRadbzqD+9RMTC0l1YMujvD2qpyckHietsKHGwttsKk4fUSPjyuywSmTNygKaClKgRoTas6CAfSZPyZbhzrL3MnqWhZr3fCgNlgvU5rnHdzU/Z+zONK/AyNMvje0KWw8BthVGc3+qK8bdpBb1BBAiFfYDm8+CF3KUQS2lsZmuzJN1McwZ1Ahtdb6SEpkworDsj/7QJlVPd5cSZibN+yUNZO09y4AlGVJEXC3NZ5YleJKoRRRFoZW30LwdqZ9bivoN4dl11TBnvPCDdJMBi8XXNHTzTlj9fisOoLg3dWoIT/MWJQ9KFwBgJV/iZFPvDk3tRFShNUpgveA/QntSbYBCpFpNtcWSilsm0NDVSzsr9dzUGSmYxR11
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/29, Daniel Walker (danielwa) wrote:
>
> Shouldn't there be some sort of compensation or notification for this, or is each person that
> hits this suppose to just scratch their head and send a patch that's rejected?

Not sure... uprobes assumes that it owns the modified page and nobody
can modify/unmap it, including the probed application or debugger.

But may be MADV_DONTNEED should not set zap_details.even_cows == true
by default ?

Oleg.


