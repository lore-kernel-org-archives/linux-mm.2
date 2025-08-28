Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4434CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 15:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9A36B0099; Thu, 28 Aug 2025 11:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1A56B009B; Thu, 28 Aug 2025 11:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00E166B009D; Thu, 28 Aug 2025 11:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E6F9B6B0099
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:51:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6347C0297
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:51:22 +0000 (UTC)
X-FDA: 83826605604.19.2DA3917
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf27.hostedemail.com (Postfix) with ESMTP id 03B0340011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:51:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gJlQ6N+k8dqRuJlVg3SlprK/3KF84yfiT5cGX4gaAAQ=;
	b=BE9AfQZITHMlAI4Sx4Yl/FTgliEdTKekO6GZmR73zJ9VPLCMWSsbTiZhi22V/7KK4Incsp
	JG1lH89vjO2rMZv8sIT5H8QXCiJW8jpYj0hSKjwASHzmFaAZIG0CIYObndNauZ29zX/TfC
	EPcJ3ug8UVopagX4RI26LXKety2kLqQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396281; a=rsa-sha256;
	cv=none;
	b=K3i0YybjBZq1rl35BUfU5A24N17qovKY5h9qYxC0zAG4d6RTH4gC/3jnCTKgnG7qkpd3Z6
	sMn4jOReaOKsyj2FETmynPORDXQq5jlBm4qVLBDdQadyP5gOxjQ3/+aRr7nRUJRXu7KVb/
	x8hKjy/46aQzmQAnGbMVfJQcesr/XjM=
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B621D1391CD;
	Thu, 28 Aug 2025 15:51:16 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 518E31B;
	Thu, 28 Aug 2025 15:51:08 +0000 (UTC)
Date: Thu, 28 Aug 2025 11:51:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Steven Rostedt <rostedt@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, x86@kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Jiri
 Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Andrii Nakryiko <andrii@kernel.org>, Indu Bhagat <indu.bhagat@oracle.com>,
 "Jose E. Marchesi" <jemarch@gnu.org>, Beau Belgrave
 <beaub@linux.microsoft.com>, Jens Remus <jremus@linux.ibm.com>, Linus
 Torvalds <torvalds@linux-foundation.org>, Andrew Morton
 <akpm@linux-foundation.org>, Florian Weimer <fweimer@redhat.com>, Sam James
 <sam@gentoo.org>, Kees Cook <kees@kernel.org>, Carlos O'Donell
 <codonell@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
 <hpa@zytor.com>, David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH v10 02/11] unwind_user/sframe: Store sframe section data
 in per-mm maple tree
Message-ID: <20250828115128.25f7b171@gandalf.local.home>
In-Reply-To: <emcthzvyvaj4fqfurbjx7xxqh3w4uwt2qxa4h6hdurh6brvnkc@zk4dspp2tcca>
References: <20250827201548.448472904@kernel.org>
	<20250827202440.444464744@kernel.org>
	<el6nfiplc3pitfief24cbcsd4dhvrp5hxwoz3dzccb5kilcogq@qv4pqrzekkfw>
	<20250828102819.27d62d75@gandalf.local.home>
	<emcthzvyvaj4fqfurbjx7xxqh3w4uwt2qxa4h6hdurh6brvnkc@zk4dspp2tcca>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19EvgcdawFHgwUNiQPAjXoZr2Nlbn5YCvo=
X-HE-Meta: U2FsdGVkX1/6C8uLnTWJJyXcAvMV6Ww3mVMIM9gY+X+uMOVQ4Puy6e3J2Dlc5raOYtp2QzM2wBOFerfN59HVoeBMe+Tdj8C5Fn+8nRf7oWjxdaTUvaQo6kRqdblbhE4PZVdALKEcsT43WUnfYzXV6oBilCDDKpNVNNMSwzYHl1YTsTQO84j8wFEJm7lrBRS1tQ20W8+I6G9Nqeh0o2XTpJI5PyJW0/PKjreV6dl2ZTHEpNLnjBOong6uuuZbKiNZwuSGwjphz+Rsvfk9nAzc959FMbLnVLiNy1yRY0APE88kODj3LROXx3qDs5NeQLB/qBbGFIZtIzMaIdlkeXvkxkSCdyu61AYz
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 03B0340011
X-Stat-Signature: etf1r68hxurzy47ti6noiaecma5p9fpz
X-Rspam-User: 
X-HE-Tag-Orig: 1756396268-783114
X-HE-Tag: 1756396280-242043
X-HE-Meta: U2FsdGVkX19389m8r8bde1K4sV0Zx3r8pMU28uk3aZt8K5cxnPiRMZfWJln3Pp2KCVwemJo7s4z5aIcqTykb8Ak089s+EkIQr2gj6zcYOpSuWQVQUCVph8V4BCITjM/M2Dk/iGEYUTwlyItpRgqdvElv9myYa34qo+UbhnNCDUYhjWw50b1/SOdpduiFFimSPSwvX4dER3JTTyE7xfFpOgz+V3msZGrOz7MNT6v3PHfAPqDsUgCqsTBJHySuCsqUCeEUma5F+D7iT0A2IjVkpGdZSh4k3FbXq64VkJVKE8Zl5V222exafV3exi0P1i4MRi+yuDqdgO1RAWF6aR+qX4bGQ5MyQvcWhd+RwJT6mgKflRp3RkPnqkxlj7F7gRSNBmFViMazGGOh351iMYskD4dqWe7BYxahY2gaEGr2lTS5vDcg6lbSFNwaWm9lRBonGQzObRZfWlvLF7CilYvKfa8+skjRtlzCo99O512Kr7cdL7CskDPWmsvR++0DFrZimViJ9cIWWLWQIxYm/+A1uVPCzAptEa9YpAO4MQkxZMZCfh0vpdUyYnk/6BooEAKqJD+ny0Uw4albgUVW2W7DKiLmkZHjskmSscnFAr/u8IRVBUPSqbb1DQWiK/rid5vv3ophZ/q+mswutLN2dABrxbSD8o0frD+Bzxah4SvSk87IlhQd3li/j7VAbcVsCDo3G4Ov0hULMJrYYodJSoZTx8NuiXG+X9z6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 Aug 2025 11:27:00 -0400
"Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> > Does this make sense?
> >   
> 
> Perhaps it's the corruption part that I'm missing here.  If the sframe
> is corrupt, you are iterating over all elements and checking the start
> address passed in against the section start.
> 
> So if the section is corrupted then how can we depend on the
> sec->sframe_start?
> 
> And is the maple tree corrupted?  I mean, the mappings to sframe_start
> -> sec is still reliable, right?  
> 
> Looking at the storing code, you store text_start - text_end to sec,
> presumably the text_start cannot be smaller than the sframe_start?

Sorry, that's not what gets corrupted. I should have expanded on it.

The sframe section is two tables that describe how to get the return
address from text locations, much like how ORC works in the kernel. We get
a start and end address of where the sframe exists (that has the two
tables) and a start and end section of the text it represents.

When I said "corrupted", I meant that the sframe tables are totally created
by user space and can not be trusted. While reading the sframe tables, if
there's any anomaly that is found, it is considered "corrupted". So no, the
start and end of where the sframes are and where the text should be
validated at the start (I need to check that we do ;-).

But once we start reading the sframe tables, they could hold garbage, or
have something in there that the kernel doesn't support. As soon as that is
detected, it gets removed so that it isn't looked at again.

-- Steve

