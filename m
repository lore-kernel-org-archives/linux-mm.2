Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B15F0CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 21:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC8F8E0003; Wed, 22 Oct 2025 17:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4768E0002; Wed, 22 Oct 2025 17:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF11D8E0003; Wed, 22 Oct 2025 17:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE1D28E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:58:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 550D1886A5
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:58:45 +0000 (UTC)
X-FDA: 84027115410.15.1E5255C
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9E64C20006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:58:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761170323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1bUd5Tpr+oS5QfaaqQU4CAiIopEYt7+Iku17W2qt32E=;
	b=aBdW3INb2MKzgJWCWbZ7lm2EZp8eyHX5EpSzPK0x5S2LJkzrwsrWrQVENuwbi53DS0Yi3q
	FkaBlRIkJ2iczaTztIk8A6SjabNpbQnGk1ZgLElYxlQmmK01GT6u8yKNRtg+EmUeudUUd8
	aJARsfp+SRZ4ExT5J+IFfdPAVjAcNPA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761170323; a=rsa-sha256;
	cv=none;
	b=3UKx1487kqGYLG4kOE9nw9SZL/txb4bxxyP4ffYle8iRNWwOPsikXkN+zpPASA7QzwDYs5
	yCQMc2Qi9AzNdWeQWy0oNbC69Pp/RMRFeCr26OOn3HBu3QXI3JzwK4wZz/fGr3DPFioJWf
	ZZM9yRCEKwVh8Sbbe327tBi+/KIZXqE=
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDC15160997;
	Wed, 22 Oct 2025 21:58:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id D10CA35;
	Wed, 22 Oct 2025 21:58:30 +0000 (UTC)
Date: Wed, 22 Oct 2025 17:58:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Remus <jremus@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, x86@kernel.org,
 linux-mm@kvack.org, Steven Rostedt <rostedt@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Jiri Olsa
 <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung
 Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andrii
 Nakryiko <andrii@kernel.org>, Indu Bhagat <indu.bhagat@oracle.com>, "Jose
 E. Marchesi" <jemarch@gnu.org>, Beau Belgrave <beaub@linux.microsoft.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, Florian Weimer
 <fweimer@redhat.com>, Kees Cook <kees@kernel.org>, "Carlos O'Donell"
 <codonell@redhat.com>, Sam James <sam@gentoo.org>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, David
 Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
 <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>
Subject: Re: [PATCH v11 00/15] unwind_deferred: Implement sframe handling
Message-ID: <20251022175855.383f4148@gandalf.local.home>
In-Reply-To: <20251022133932.5e8b419d3525da07453b137d@linux-foundation.org>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
	<20251022133932.5e8b419d3525da07453b137d@linux-foundation.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18I+F+bKdHr/1KWa9dV4J918j6i3JKGfmQ=
X-HE-Meta: U2FsdGVkX1+6Dwf/frnjEfjO+nympxtkiyuuKnisUQHr0Ev92Yu80CM0iT0usvlkaJZYGaIje1yrwxXmuC/2UwH2bLBFlm4aEftY60JIyC8Po8JN8XT+0XN9xMhK7T0Yc3dOEkK+DfC9KY0c8XFYcSLHVLGR/rPlrif/jrS7eiW/K4a5BqbVunBK4ORQ5r4o77YidFgjWtBjWG02uaglaCLPKbMNmlv70EX7LsB03TgsAleK8nBQOzgx3Dr5xk81Qq3N94MBUCR5kAGVuGm3DmJNBLoAdeykzbNvVJugFbhOt8fkmMkVkAkA/HVBssjta7TFaiiBrjbrpMnHdPNR9SvdxAqZSyzwa5E78Php+ZvqWajXvn4KcUbGfIlAtwcqbuaXmHDan4QPGEMhnQ0oTg==
X-Rspam-User: 
X-HE-Tag-Orig: 1761170310-477037
X-Rspamd-Queue-Id: 9E64C20006
X-Rspamd-Server: rspam03
X-Stat-Signature: eq8tx7ksb5zojf5j5358uqdb168sqn1a
X-HE-Tag: 1761170323-870371
X-HE-Meta: U2FsdGVkX19oPgMEHjzpOqRRhlmkrpH/DpIxZIuqV6l/n8z6IbDTwSTHbVgp3CdIQ66/cguLkbzAkVaAqJ1c6C/X+2J3IoSl3tKQ1eGRIv7dTOiJ6BGSSadZnjmt1/S8w0Q0x0+fWgeqridUjhhlyxVyMhpKh9y7AVckX1HFthXTrPrAoXdJwkksTqZcXwKa3386hYvFwJ5EHX12NxzPiMkQVOfvSexPeZhV80nTZMD0GaWTz761VPocDIvxb6fHLIDt0R5sMOO6hexZhGulOJALTX7f0L5/LIrpR4uTzQDP/TR5dcKkjzp9MzSzW4/0BbFaQFUYz0B5koJZARwxA6sLVLoH18Q8bfe/qmBAog1Si0nuvZcnSHkiuRroVzwitlzmp/gA56GP+UXy1VWKbkwU7HTa51U8+j20TROCdy9C36P2XgYnzlH2EcshfLl4G8DdNdTjWOZplirVzvuTl2HgXZDYLAs634w7tvlwqPpU0QZB+lHPBAUcSqbd3UDJ3edD5I9+PPT7kF6+ymacZ4m+1PaiXU+4PSl0aTNLCiKB7aH71MrTKx7WSZP1eGiYdTXYfsZSh7qRkxAI8yWmuqqOU/3YeryihFKhfP6jM5/5rF/6FkXJhtVgIbO2bIH7N+gUVQ7i9HinKm3rZyqlMKKvPd9xjk8vXMVmw+Hu0M5o41KjTsPecQ7hlIXTvSMQmepAx4+Er4DUvbo85xS3NhF+96FunpRX/qMtIDBtu6hNQS73PoR3AXdK2CJtSP8cPOcPRYgkwTlPFE+BymbAAdKrkTrsQYFEfe/OHXB9cqBxkiVd3zMXR6Uul93Ia6lTvzvCEJ7iC2+0Fv6zSI0oBZLYmuSxm9DwOhQ6QJpZrW8I2bGF/ohUO+LMXIoGvZdhfIxtnbgQ6anvRJvQ/7OmHQcFjVbD4E/XRyD3OP88E6iuheJbnJ6GDobZV0EfchPoNv/ocoEDW9d2cnCUlBf
 GnAQ5xgh
 cEauB61kOsw9FkV2fmmF7Rt2j9imRZPakKjnt36VjZ9ozLGJVAXsj/5E+Lms8hAxEZUI5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 13:39:32 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 22 Oct 2025 16:43:11 +0200 Jens Remus <jremus@linux.ibm.com> wrote:
> 
> > This is the implementation of parsing the SFrame section in an ELF file.  
> 
> Presently x86_64-only, it seems.  Can we expect to see this implemented
> for other architectures?

Yes, and Jens is here to port it to the s390 :-)

Currently Peter Zijlstra and I are updating the deferred unwinder. Jens is
working on getting sframes to work with it. His interest is getting it for
s390 whereas ours is for x86.

> 
> Would a selftest for this be appropriate?  To give testers some way of
> exercising the code and make to life better for people who are enabling
> this on other architectures.

Yes we should definitely have selftests. But we are far from getting there.
One requirement is that the toolchain used to build the test must support
adding sframes.

> 
> In what tree do you anticipate this project being carried?
> 

It will likely go between tip or my tree.

-- Steve

