Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 279F2CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672306B0088; Thu, 30 Apr 2026 14:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623056B008A; Thu, 30 Apr 2026 14:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538A16B008C; Thu, 30 Apr 2026 14:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 457F86B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:47:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF82312028A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:47:06 +0000 (UTC)
X-FDA: 84716104452.20.BF5AA95
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B226DA000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:47:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aYsAg2M3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777574825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgEmDrRG7CWGy0GhWu6kQhiMkkhNkXPK8olzYJNcb34=;
	b=mSa3OauK01vKyGbJ02NuAxn0qPm5iWLnu8vA6Exfnt+BMQtjtiJIbMRaCIXG77ueWL6GnW
	/4dkeIE/22Xzmdon0/wrO+N086OL7ARYY4WGGxFqrenucViUEndR3Ja/nOpcR01zHcZyJ9
	jDOJ9vnjG1UjRAvrVABmrhIw9sgppIU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777574825; a=rsa-sha256;
	cv=none;
	b=MrnDuK3kJxbc7EUfHXPdop4eIrPW4cxodGP0TAfUo26MZzTjw0oZR5xXD8uPCs87ROYPIL
	2VuOvjT9B8fpYpsuK8p1dzDL7e5WnJJkNvtmcsrCQ5+drUdPi2Zr8z0J976mMVtGpczLHc
	aoeWNJ5jqSXGLUUiV6LIB0m7nHs6frk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aYsAg2M3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777574824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sgEmDrRG7CWGy0GhWu6kQhiMkkhNkXPK8olzYJNcb34=;
	b=aYsAg2M3IMuYTEgHRSDeMDzqkMBgqfitbS/S/vETpVtKly0k038oXjVoYA6YMHcJuOjBGu
	Pbea43ooxRXMJ7As6u7mURoLx6F8DBdUDB5ZoYzpsP9WWIx8rGvDiYxhw9wsf8YqJMgG7u
	2WHoJyU+qtAMkJH/eqT1xD0pd0sgDjg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-yQvVCO7mO_iiuCeNpI7Y5Q-1; Thu,
 30 Apr 2026 14:47:00 -0400
X-MC-Unique: yQvVCO7mO_iiuCeNpI7Y5Q-1
X-Mimecast-MFC-AGG-ID: yQvVCO7mO_iiuCeNpI7Y5Q_1777574815
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8785B195608F;
	Thu, 30 Apr 2026 18:46:54 +0000 (UTC)
Received: from fedora (unknown [10.44.48.22])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 564FC19560A6;
	Thu, 30 Apr 2026 18:46:45 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 30 Apr 2026 20:46:53 +0200 (CEST)
Date: Thu, 30 Apr 2026 20:46:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Daniel Walker (danielwa)" <danielwa@cisco.com>,
	"Darko Tominac -X (dtominac - GLOBALLOGIC INC at Cisco)" <dtominac@cisco.com>,
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
Message-ID: <afOjk9igx9nlc9cg@redhat.com>
References: <20260429131522.4049054-1-dtominac@cisco.com>
 <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
 <afIiqR5CqYRId0N0@redhat.com>
 <afJz3l6435DHLorn@goliath>
 <afMeAs6upm8kLCYb@redhat.com>
 <2d815203-a81e-40b4-92ba-31832c84c20b@kernel.org>
MIME-Version: 1.0
In-Reply-To: <2d815203-a81e-40b4-92ba-31832c84c20b@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: MwN1jZfmN0SBx38u39lwrbZefqzoXoEoiYENPV7Qmq0_1777574815
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B226DA000B
X-Stat-Signature: d1siptswmzzct9967yzmtqdpphpk7xs4
X-Rspam-User: 
X-HE-Tag: 1777574824-596536
X-HE-Meta: U2FsdGVkX1+sdnwtGr++O3DZeC8ePpCDWwSs/fPjedSy9arQXPARFlgPla3F68Gnbv1A8oT6oKWb0keuOGXBCYgnIA2uihaDWp2nJnrkcFt1M+impOtzy52SFquL+IzUV3yl1Z0yvGUUbLVmSuOmM/QabjkvTW734Gs2X2SpyBqxz5WEZ/AVxt2BrFGkzaF7ZgHyriDeo9yihGLIiX0q104ArY9p1jmw9cpes0MuIK8KeNhCE4VnXsxB3XwYwuceTItohGU4Ll4tXDbD06/hNXMmdl4Aq7d/UKJUg5NmploXdaz964SfSNUNXZnyQCu0uxenHsJ4Kaarxb4tsn2lZiALNVXPMok6B3v/MbTbMcuKgL1DK/lcz3q2Fz4a2dNY+G/Ldr7gNs6y6uWEUfFTb6YCsOcegFCrXAEO/+e7+U2xLgXuHGpMstrGXyHYxobpgCa+ZLt/ey4E7G57CGAlC4qO4cjqhvjJV1wz2PUvIN53vcpMtFcr0eMRwRZep2qAGEdKOO71qVxJ21co9+jlPjDtuWB0T3FvADbMcEALVD3oFfE4W2JbJr+LEX1/YTkFulFh+aE+Tzyf6HP2dtHZGLRvvpjUg0LNhHxdsfr4YjCgLBq0VkJ+9El1ABQYY60axYM0XwHawA8gNMR9dLR61aJsIqN22cwohmZ8DL0AOazaM1WOnNv/8CrralaNslqzCE3HaubqrLygzKHq0QZHKj9RAhBdlli87ISFhY8yoqU8CiE47PLf6Snh5sdhaseC+JT6XE1UEB5y/X9vzdwuq7dtRyuN8qeJKbXlkJ9ymPqU3bfGNCPg8UAinLZbbrmFkhgIjbUQtdHIm4ADrbJlU+YrNzHEPl5XQ/EC4NcL+iMNEALvIiaTRr7DpBE9fyoSE7oIsZBu30Uh+8huCn223hWMLyxp0V1W5Hb0ISKHWgUphKZ+1o+WoP4wf30e1ah8VRmLyYSOi4CDCYj9VdL
 vupLFnN1
 BbbXQkawLN3uWTw0PI3yPA7nfhkewEBRghdmfDxhwwwNzZewWKG+4MARYOdKKBISb76ncGOcztZX+Ny+MDb4nx54Dj0AAckhv4indXq3Y/XMJ+5BtxokWwUnMTnCrQQQ5xnOvrRxtpxC/fuAPlratvabJDg44VMZ9S9WyfpPBEZ1L2/Y/Lrc0vVypO6vePIGjxAEzjjN65923lypXl9Ovjqq2/9hk/nqZv1e0Wf0AwymQuv/sIZb0FMoFaqy5WtnZyz5cvJpdwQJoAD/7nFFCb7adBy0qd5lgMLZ9qIxIqMplgZZlJ69U/CJu49Z2FCZJpO+40HWpzI1y7h9okOE7baDWTbxHft6btTVDMIbYC8hl/Di38506CQ5Wk7i36gPVvCecakMgCmFLPE0S+tlx0q3CAHLW2kTJqVFQzqu3wPbISTqDVxdbVfenrtv/0QvbCIu9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David, et al, I am sorry for the unnecessary spam but I can't resist...

On 04/30, David Hildenbrand (Arm) wrote:
>
> On 4/30/26 11:16, Oleg Nesterov wrote:
> >
> > But may be MADV_DONTNEED should not set zap_details.even_cows == true
> > by default ?
>
> It should. If you do mmap(MAP_PRIVATE, fd), and modify some pages, MADV_DONTNEED
> must zap these pages.

[... snip the correct explanation ...]

Ah. Sorry for the confusion, I should not have said "by default". Of course
you are right, and I understand this. At least I hope ;)

Let me try to explain what I tried to say. First of all, I still agree with
your "It shouldn't do that on a MAP_PRIVATE file-backed VMA". I also agree
with Jann who suggests to make the manpage more clear about uprobes/bps.

But, lets suppose that this "problem" is raised again, and we come to conclusion
that it should be fixed/mitigated. ("we" actually meaning you and other mm experts ;)

_In that case_. Instead of this patch (which, rightly or not, I personally dislike
in any case), can't MADV_DONTNEED paths check MMF_HAS_UPROBES or vma_has_uprobes()
to decide whether .even_cows should be true?

At least when madvise_behavior.mm != current->mm ?

Oleg.


