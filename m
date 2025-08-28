Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E62BC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CB968E0026; Thu, 28 Aug 2025 10:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2B68E0006; Thu, 28 Aug 2025 10:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DFD48E0026; Thu, 28 Aug 2025 10:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5858E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:28:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25EBC1DA3E2
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:28:13 +0000 (UTC)
X-FDA: 83826396066.20.CD76F0F
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf30.hostedemail.com (Postfix) with ESMTP id 68D6F8000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:28:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756391291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qed2s606kSWD/7t3vmHZTvVxooums+Qp6nwVoTsAR0M=;
	b=v2Nk7vu3Mu7mSF3FL/rHAJ4wemLNGgM+0RqSa9Ld0tIJ5cvIJvRrqrNSvX+2uB49EeojBM
	tiTnoyx+S/rGSX1ZNoptBKcOvvpHMPg/3h3YSmFfIHT7ZZnDT5zMu24RrmS8/8bpCO+F8k
	K18OSQNRgSoeFkmIRIQwCcT/JdBowsA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756391291; a=rsa-sha256;
	cv=none;
	b=M8/GCZIMT2KvfTsUODkM1l57t0MwaJVxQVJsslLeJoq67o6Dr6VIzw4bW4jp65xA6xDFjD
	JmJn1OZwsiTAvMkuPbZjedGPRTIfIlLe5kTwgw7BXe4Gumhsp38jokhsft4EkLXRlncMUX
	Weddp1iF9UGSuKk60TXwB9+G2pmamB8=
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3E74577E2;
	Thu, 28 Aug 2025 14:28:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 39CDD29;
	Thu, 28 Aug 2025 14:27:59 +0000 (UTC)
Date: Thu, 28 Aug 2025 10:28:19 -0400
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
Message-ID: <20250828102819.27d62d75@gandalf.local.home>
In-Reply-To: <el6nfiplc3pitfief24cbcsd4dhvrp5hxwoz3dzccb5kilcogq@qv4pqrzekkfw>
References: <20250827201548.448472904@kernel.org>
	<20250827202440.444464744@kernel.org>
	<el6nfiplc3pitfief24cbcsd4dhvrp5hxwoz3dzccb5kilcogq@qv4pqrzekkfw>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/UpGGk0sN7ZRFjbCfmYaa8yXlKjFyWmZ0=
X-HE-Meta: U2FsdGVkX1/NHsF/xLEc4nIoi2djvu4+eFUqz+90saW6KPe2SSSeHmY3d+2NzAa0ja91OBKVE3l04tc1bxQy7939iX/OxWrqxK1IELyEJeTE86USU8gn/Yo564nlJA0gRJUwLSoesr1f16mCj/54MlKG/D2f/iybpDUF+amParwwGdPNDuwVkc+tupcJa0smZ6kzulttx6uToOb3SFRwLvkJ65U63MpGUeLUyl80lS7vxSNbsm3iUljE607my7wQG5plrIvuU58Lc4jwmSELen3dko11S0vheFH6PbTbHgw4gWUnnOaT8XsXXcBY7bDZVhxP1UVlbhi9CDBAw8HqA0VFWELP40G2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68D6F8000F
X-Stat-Signature: xedd6eijkc1xu5qms1rx3p8witpz3qqo
X-Rspam-User: 
X-HE-Tag-Orig: 1756391279-514030
X-HE-Tag: 1756391291-306788
X-HE-Meta: U2FsdGVkX19WtD/WPilPrY2WtC+PORXcZW4PhcDPWTMYmOWqJaTMDbrBb9C6IuSLUvc68vwpH8VbogbxM4LUol2DdQHnqFLihemyL2+U3I/m9TjQ6DPBg63+47AuYtgU38G+FKpqhCALfOi3lB6Fs6YEQjBncQJmV0Nv9IrijMeYBT8UG3mA5DVwVW+yWJa5d8JvNuXz7XsdwY06hJiFkSGzD3Od6wwoIWUjY966Ad6GX9fe2aIdDDhiDZ9iKnYnq2Ydl1OykXWjbruyJHkbFZaw3QMI2osA7EcCs+0tpMh+8hv6i5h6hojy+MPcEoou0xth4Nq8PqFT6q8FMOAQA33iBulf+QLgLM4DMV0GHFMmbVKEsHyJM6wkdgWwxconvHnB6uca9TF6O2ACWk8QWlrfgk6oOVOuKbzkr2b3n/Of7B5AcypIKMxoXvjSaPicN7ipKpf9vRAaEN5l7PL/sR7v4POhGzIseEiH2jTLNgGTgkybemnwiGeTWK1otKsVM7KBSr0K0VI/a5ca43nAEkU6nqxra/7SkB4/ayzngUOWQnpFwie92XTexnwxU4FXZbreGU8qTqvKsbdoEG9PRq4gk4FCTCslGfIKgyRz4XBTbnOP5olS/n4GfxEBG3gxxn6EMtVkAVeBR3oaJeTlw+fl5b1yX4rXBJtRc7Zd5vkv2gI1699GVOmXgz6khovqULJUdkRwnsqOdXD8ECQ2XSaeFCwMji6jdFT9sv7Q+oGuRQcLgEBx/1gBbzeAseafrwX7Gxyl82+tQEsknwJCqg6jIsaGH+WeCR23chYT1+ccO6NaZdb+ipWANl3qLo1SnALs4ZpCBG7mncjn4Mh0CNwnfLZMzfL+bLH3b/fRlai4aiA/MuImSKJtYUOCV40sb4A7tlxHD1ayTTNeSosO1dB2Pwna76zAwsS2m2yAJeTbGSs610Q0Cdib7OP1cKK4NWY5+RcL6oP0Cuwep3i
 9dmRq0l1
 HZhEb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 21:46:01 -0400
"Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> >  int sframe_remove_section(unsigned long sframe_start)
> >  {
> > -	return -ENOSYS;
> > +	struct mm_struct *mm = current->mm;
> > +	struct sframe_section *sec;
> > +	unsigned long index = 0;
> > +	bool found = false;
> > +	int ret = 0;
> > +
> > +	mt_for_each(&mm->sframe_mt, sec, index, ULONG_MAX) {
> > +		if (sec->sframe_start == sframe_start) {
> > +			found = true;
> > +			ret |= __sframe_remove_section(mm, sec);
> > +		}
> > +	}  
> 

Josh should be able to answer this better than I can, as he wrote it, and
I'm not too familiar with how to use maple tree (reading the documentation
now).

> If you use the advanced interface you have to handle the locking, but it
> will be faster.  I'm not sure how frequent you loop across many entries,
> but you can do something like:
> 
> MA_SATE(mas, &mm->sframe_mt, index, index);
> 
> mas_lock(&mas);
> mas_for_each(&mas, sec, ULONG_MAX) {
> ...
> }
> mas_unlock(&mas);
> 
> The maple state contains memory addresses of internal nodes, so you
> cannot just edit the tree without it being either unlocked (which
> negates the gains you would have) or by using it in the modification.
> 
> This seems like a good choice considering the __sframe_remove_section()
> is called from only one place. You can pass the struct ma_state through
> to the remove function and use it with mas_erase().
> 
> Actually, reading it again,  why are you starting a search at 0?  And
> why are you deleting everything after the sframe_start to ULONG_MAX?
> This seems incorrect.  Can you explain your plan a bit here?

Let me give a brief overview of how and why maple trees are used for
sframes:

The sframe section is mapped to the user space address from the elf file
when the application starts. The dynamic library loader could also do a
system call to tell the kernel where the sframe is for some dynamically
loaded code. Since there can be more than one text section that has an
sframe associated to it, the mm->sframe_mt is used to hold the range of
text to find its corresponding sframe section. That is, there's one sframe
section for the code that was loaded during exec(), and then there may be a
separate sframe section for every library that is loaded. Note, it is
possible that the same sframe section may cover more than one range of text.

When doing stack walking, the instruction pointer is used as the key in the
maple tree to find its corresponding sframe section.

Now, if the sframe is determined to be corrupted, it must be removed from
the current->mm->sframe_mt. It also gets removed when the dynamic loader
removes some text from the application that has the code.

I'm guessing that the 0 to ULONG_MAX is to simply find and remove all the
associated sframe sections, as there may be more than one text range that a
single sframe section covers.

Does this make sense?

Thanks for reviewing!

-- Steve

> 
> > +
> > +	if (!found || ret)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +void sframe_free_mm(struct mm_struct *mm)
> > +{
> > +	struct sframe_section *sec;
> > +	unsigned long index = 0;
> > +
> > +	if (!mm)
> > +		return;
> > +
> > +	mt_for_each(&mm->sframe_mt, sec, index, ULONG_MAX)
> > +		free_section(sec);
> > +
> > +	mtree_destroy(&mm->sframe_mt);  
>

