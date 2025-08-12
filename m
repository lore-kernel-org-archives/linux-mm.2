Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CE8CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 22:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8A48E0199; Tue, 12 Aug 2025 18:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1B28E0196; Tue, 12 Aug 2025 18:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FDCE8E0199; Tue, 12 Aug 2025 18:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 918B68E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:52:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41E801DA0DF
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:52:36 +0000 (UTC)
X-FDA: 83769606312.09.632DA15
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9B1A0100009
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:52:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=a+VJflJa;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755039154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JkpdNoByUPSDeXAHBz0N3W7oELZquDkJvgXY/J62Us=;
	b=8HwdBiJvgKfrfDBxI0II+S7YUQ/lcI8Z3SUy8mD63iebHJepQBw0mrKqSVTvatrHNpaCim
	crtBYFl2tHxN+vjZAiKwKLh7VTGPi3QOVNZ/awsnoHf256H9PVzbKGJjKqEwdrQGFyHQI2
	ua11lweamrPj+QQAZyY2O8RoAxBAjLc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=a+VJflJa;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755039154; a=rsa-sha256;
	cv=none;
	b=2TdFP+kbu57dC7FgLBR7i21NMW/mCjMiHFniuI/pvWORPhVuxknsGB677KEUxukRSAgFDu
	YkhNkVYhw1jCrxDicsOzzIcgAPkiK7wxjB7RtgTVX/M1RDQXVW1nAyR+aCjnP3yOP1gc8K
	6AG6xXIZBPZ+U9hpd6NvWGsLoUs2HXY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 879DEA56E69;
	Tue, 12 Aug 2025 22:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B46C4CEF0;
	Tue, 12 Aug 2025 22:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755039153;
	bh=4QcopLUUVGIVRRCSZ4jv8Sl09V42iH0FB+VA3/a1kZI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a+VJflJavF7yIMQioCGtFvNcvBDFfTx45hCKkTusYA2BdnqZ4kWT38UBmlbg+oIZ8
	 J7h9f7rapCJ5U4FK5B6scoDK/gC4UcmFx7+jCF9mS1b8IzhQgiAFmp5Exg01cPkPBS
	 9/DB97qAo9nryrBGFF/USiAc3gsuzO/6GNmoq6vM=
Date: Tue, 12 Aug 2025 15:52:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 "David S . Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Dave Hansen <dave.hansen@linux.intel.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Kees Cook <kees@kernel.org>, David Hildenbrand
 <david@redhat.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou
 <chengming.zhou@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, David Rientjes <rientjes@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, Masami
 Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel
 Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, Mateusz Guzik
 <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 02/10] mm: convert core mm to mm_flags_*() accessors
Message-Id: <20250812155230.f955c6470db223bb371ac683@linux-foundation.org>
In-Reply-To: <1eb2266f4408798a55bda00cb04545a3203aa572.1755012943.git.lorenzo.stoakes@oracle.com>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
	<1eb2266f4408798a55bda00cb04545a3203aa572.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9B1A0100009
X-Stat-Signature: 8qidsakkrn9gsjy5ecmqmz91gzb1d63a
X-Rspam-User: 
X-HE-Tag: 1755039154-411269
X-HE-Meta: U2FsdGVkX19E8cLFmChjDpbV9aTP247LkWN3ZwO37WCOh4Gfc2ix7hWwGNebXX5FHXvYOOUjB3AtcRYbNrOUNavzQxqqBwWOBCZHmL1jWb8JFSbTKBwXotPCHhEyd1bWKgFSDnvhEskqqPD8RbdBQTS0T0yMgqoeDvhFmkBXx9lAw/m0NrLADPPDElTTXdy3dAYtx/o+Xa2moTJF5btOSPGk2N82NJr1CZzHE9AxI3zf0Jg1QQBSVJvLaB3yCDyz5hee5K8xwLepFsodN83LX65Obx9Nc78y3rzzSscU3Qa/Ng68HH20MnbogxvAPdZRFxE2iquwsb2K+2DeyZRFLlSF1K06990VTeg407Qtqe1RijsQYwYi2RPxDp8U0MFS134vjp/zShsd5hArBoub+Baapvst2DFhxNy9AYEuFebPfU6NU3zfIWQ6J1aIuGmdkHCwwpRH8RxLhv/GuTX9hcZsp1NMVkODKR6PKjWLbNWBNUjMmLDXS75Pueng36RVkNV7Yd9yihzYQWEafMneoM+xuMqSUzrGlEGXcxv8MKZFS6wb2/AVkDT/saeEKbLV1GTxkKoQTSqIxixeCmmZlzHR5UUWfVEZUma4at40rB9WWndtvp0qwbMLQJXKuhpLQbsSVKOPMPsYZiJNykrVQ9ABMhDVVo2Jd10CsqILAPFdu2oYgG7aeFV0xaHza97iVKQLlNdYAbdKXqIeMC42LCpfBBnH1fRGhWWXlKsketG8YMCIyV2wDnAB9BHK/RChaBjxvKmISVTfFwhz/YPe6Bdp007V4c/p/0xUfZKdUm53EXbffMejL2wkYoXsygJzuhrMqvndlE27IDk2ozKp9RsTKesKcj96Rli6GYjqAAQa1ZbEvB3RMYzegSS2bw4JDGvzKnT6imTo8kkYdHEJXDvnm2p7k2cbqQE6nt5a4CdTbGeUh9uEFFEK1hpxmeNln/MtZ6Tjg8wPmFCMiql
 BATQRPPx
 KbgV4bABUXIiGRcXAvQnXe+q+bmFa5/4pYBdBcZrtSCLOXWz6sSgRkmyO1lh0d07jqlDpkZYSRpImEs2r2VE/7KJf4Q8ykFK+pXyzDMz44W6xximeoj+zFt7tNRZFafJ6PQDgCOf4bBf+TUfSVcrjLi3UIFFN6bUaOBN+I30WzOIXICOLeHEyCGrD3wRg4E/oGQxaboQEEtqosML4B2kQo/gIAh13lITGBrrt/i/5snsmZfdT0kUFhE070zVK93RvwT4E/hjoIUdM2ErBJ3+cvjYYI+hWXkFnN8yeBH1Dvv4SHZYB4LGBAZBQbXQ7KzuH3o6y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 16:44:11 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> As part of the effort to move to mm->flags becoming a bitmap field, convert
> existing users to making use of the mm_flags_*() accessors which will, when
> the conversion is complete, be the only means of accessing mm_struct flags.
> 
> This will result in the debug output being that of a bitmap output, which
> will result in a minor change here, but since this is for debug only, this
> should have no bearing.
> 
> Otherwise, no functional changes intended.

Code is obviously buggy - you cannot possibly have tested it.

--- a/mm/khugepaged.c~mm-convert-core-mm-to-mm_flags_-accessors-fix
+++ a/mm/khugepaged.c
@@ -1459,7 +1459,7 @@ static void collect_mm_slot(struct khuge
 		/*
 		 * Not strictly needed because the mm exited already.
 		 *
-		 * mm_clear(mm, MMF_VM_HUGEPAGE);
+		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
 		 */
 
 		/* khugepaged_mm_lock actually not necessary for the below */

there, fixed.

I applied the series to mm-new, thanks.  Emails were suppressed out of
kindness.


