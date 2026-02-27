Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D2B3FD5319
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3AD6B0096; Fri, 27 Feb 2026 04:14:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 857C06B0098; Fri, 27 Feb 2026 04:14:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BB86B0099; Fri, 27 Feb 2026 04:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 56CAB6B0096
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:14:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D83A9C212C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:14:32 +0000 (UTC)
X-FDA: 84489675984.03.884FBF8
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id E1E50140007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:14:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d0wsofeb;
	spf=pass (imf23.hostedemail.com: domain of akiyks@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=akiyks@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772183671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UvTRhrxfKsVqoBZeh0/0n91cab9+yPTUHsILCMpZNg=;
	b=Qfq93RPR0/4vxyGfy+zOhiCmKp03UPbVAyJVnKk2pN0wy0l55iTUzokVUM6921HIRLL07C
	A9HYULa7iM5pNXQ+iwG2GmRLx4iX18hazDoJJTjxNZSUMlcysyq4tr2d4B85geKfAWaCwW
	SUcwY3JJle/WRc9uJ8cF0qadkycFCHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772183671; a=rsa-sha256;
	cv=none;
	b=pjiIqtwr8tburp90le0dVsGXt50B+ZLg5gD5sA396yq8KrMFTh4CyG7PRhigrro6j/ayaz
	tmEEWcYcA2NgJRPxuHXHUct3sk56gBfHYEUmMD1X6maMY/OBC/0FlIf+vjCYHCpbIeaCnh
	KwUH26yL9HYGC8ugYJL/ggSQowrmNqo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d0wsofeb;
	spf=pass (imf23.hostedemail.com: domain of akiyks@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=akiyks@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-824b32875e7so982513b3a.3
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772183670; x=1772788470; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5UvTRhrxfKsVqoBZeh0/0n91cab9+yPTUHsILCMpZNg=;
        b=d0wsofebU4uJ7Dm93j+jVHhQk5pHuKF1NPsYWW/T5fwsValHs7NJYo1GAa8rhyIWAK
         RKsfhVOAYgCwSbNcsLie7xHmsLxaMkO0rZvIxwEZKT3Al5DQiDBgJIz2xNi4/yAM6pYi
         zTFFaO77dFDc/W0zR7NTrN4J39Ja1voMH9LEURORSXykrAzYfUorzDWFRlyT4ExAqB1j
         TjyOoEJXbOf8t6mYIqhCm4cGPBTT9SsoAq9rwV3btAd2f5yqP+47Cu4toCx0sOornSXU
         mf3JZFgNKKOHYM+lyomIvbEOflLgjtRKrknilTKXLj7Jq1U+O39yo81cQ3IPuK5TdGn6
         nuEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772183670; x=1772788470;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5UvTRhrxfKsVqoBZeh0/0n91cab9+yPTUHsILCMpZNg=;
        b=DygykCfCS+o6c04j+i03Xmvy2npTMGZWSRugNy5a3rJ6vzYzr6VyqWVDMhKqLYgl2h
         ba5WFz68BAAXYhTUjeVde9YzkVjXCFVMN9BSt1vp1doq9FVMIgMfUphftda/sc9V0CdR
         +Gt3no1cRmQUBxUm5bBh+2DdfqkJZhdS8KM7pIfaZTj4vj9VZ05rK6443QEth00yF5j3
         jQHknvnuE7siR1MgcrCHI4zbMNop8ZOOMo0MrCUuxT937kw7QVUK4KJh1gkKLIQbRGdL
         42QE+Wr9OhyFzHiLFzml0Gcv6Myi2iI9DOYZhGL17LhaY4qkoSeN/L7JaZdEWsQfHUta
         2LbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL2xzwB2XoivDygOwkuaa7Kr9TNeI5UaIkysuBw3WPEBZOzgt8oVVjcQY7sRWRSgkUhhRgIWdheA==@kvack.org
X-Gm-Message-State: AOJu0YwUkB0d/MyNWja2eQLIo7zGRVPtopToVQ3icPTDnoI5xiYrCwrj
	1cvlDQQ54755+a2BXgJelTPMiE1HsXhiNMzXKIisoo/S4+FCNEdaA98X
X-Gm-Gg: ATEYQzzUsxO8OXs3atAE+M1CbieudMBRheiCndoL9Sj2iwIvphTe6fMpGNeVh0VurkD
	QFW8XDzu/9Z+9m++x9d75jJPz76NcgyK1UFTBIjtuzXI0QAAB9yvjvgAFCS+RzaFkET4YcqNhAa
	xJxTATECcM4Y35Q1TTpsh+ifR29GVvggCp4sOR3BUvCFalAtXIE5jFdcTWHxVcyfxLxuUJwaovQ
	hlsyaNU8XmM21lEOQEmc8LkNF+3F/2gg1s6i6rOcangoBbE+BjXBehSA+jC+7twiiVpu+F8Wnv1
	JP/qNe9PRpxNlFwECJEWP3jP/w535hLDMSocLoAjQy7Eg5HU4jA32+lo+pErXhnOIrj6vxkbKhH
	zlscfgde+011f8mzhroPPealCiyV80zw1+JUxwvol8dKd+2lSpWj5yAVrgRFdhPWymFukdfOb/Q
	y39bdrWGED1yxwOkNgYidS5cmEbEYiddJLsXk8AaNhfCOx2Z5FDjjnBYCT3FGBG5ght6FC
X-Received: by 2002:a05:6a00:3d55:b0:81f:17b:c70f with SMTP id d2e1a72fcca58-8274d979671mr1981349b3a.29.1772183669587;
        Fri, 27 Feb 2026 01:14:29 -0800 (PST)
Received: from [10.0.2.15] (KD106167137155.ppp-bb.dion.ne.jp. [106.167.137.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739d5689csm6176793b3a.13.2026.02.27.01.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 01:14:29 -0800 (PST)
Message-ID: <463aaac5-d36d-46b6-91c3-b62994f0528d@gmail.com>
Date: Fri, 27 Feb 2026 18:14:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Akira Yokosawa <akiyks@gmail.com>
Subject: Re: [BUG] Memory ordering between kmalloc() and kfree()? it's
 confusing!
To: Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Cc: Dmitry Vyukov <dvyukov@google.com>, lkmm@lists.linux.dev,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joel Fernandes <joelagnelf@nvidia.com>, Daniel Lustig <dlustig@nvidia.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, Luc Maranget
 <luc.maranget@inria.fr>, Jade Alglave <j.alglave@ucl.ac.uk>,
 David Howells <dhowells@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Boqun Feng <boqun@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Will Deacon <will@kernel.org>, Andrea Parri <parri.andrea@gmail.com>,
 Alan Stern <stern@rowland.harvard.edu>, Pedro Falcato <pfalcato@suse.de>,
 Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Mateusz Guzik <mjguzik@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Marco Elver <elver@google.com>, Akira Yokosawa <akiyks@gmail.com>
References: <aZ_lJAqxh_hNGr_v@hyeyoo>
Content-Language: en-US
In-Reply-To: <aZ_lJAqxh_hNGr_v@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E1E50140007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 85s6i94fx95qaxcgtt98rn6izoeckbqi
X-HE-Tag: 1772183670-684062
X-HE-Meta: U2FsdGVkX18GD7WmzQRvFPkQ+OTemhm0gKptmU9slpLacD5N2iUraT4x3KRpwYLGTAP2KP+i6HLjQamM8QuRhSZ8MODBN+rfgxe0jHOHJhOkbBEzjQSYW4FTD031tAQL/bRB6xUDO22i5zhm92sXpuKA0iDCwMo4txaFs+P1I95yiHOQlTtvvKXPrCJkP+pFkvN9MKdzixQcMQVTr6b7Lh8fuz6wa8qL76PcFi3CycpvEpNVWAHJO/rKOlqueNkW4rVuwQ+K8uIgtk8715llx8eQ4L6K2DkhiQn054Pv+SpH7fdbCa2Iyy4o6t836HaAnwZYy7WELq+d0t1otYS5TEhtthvNpWU1fcbpNEpABwCLQRkSiZHN+f1YqJr8dEJGeOZDQGgeLc2m6jIb5Jexivn9YT2wY49VGJbxbglFvZZe8rbFlJQkgnHe3fgfF7lLXRgAIf6n5gC8Lpr4LjCBVDJ1uMR+9HnVOV77jtPVokIgLDcXZLSoBCaDnPx7G+hsD8Kqm+zmyM8K0IP8V0+e9FWZPWcUO86DQL7TkJ+nVlyAtBSwjkFWLdSvNGk5kngs0wETrRCV/vztzF58ffKa1+VL8FTuVAieK9/z6Qgwdg1NA6ruww61eLCRM5QMmMNAcY8uc3M29Osex1kLce3/CDxagwM5Zi2oOEetgwOotYHWZGeJNNAk/Wpf0G96JQIp+CwoYSFdEEgv2enLAPY5e4/JiFRYz/+W8yK5fzbyFfUguBbLxG3R74iXu43nfyYsnkpLo0OKhqSlwwfRBJoJjVuDLOwTKuuxNruMdXHz4+qyTkfku9TVGVpO0J94dU1/WBxgTZd8EPRUCOZuHwTGugnmHdOc9ZDIVwr9cvXHXY/0kp8qOCVike2HHq5oXPFhPRuf6xqRCCX2nyl7YW2znYc9AVjzHb5ZUj/fSPuspABycImP2rqZRuhuQpA9GHs6QRA67/ZIoenx+z6tkxE
 0SwbhmGR
 6gL6+a43fIdSh+5s9lXDzSSA36Tcw6ZjfEqCbB47zO/TB+ZqGOQPGaZKWWJhJgGKLYdmGUPWx1L9DAAplii0zAvBUMj0oMPEVKs28XFmmXKYGepxhPrTvsOnosGHClHvlT6jFlATLVjrjQy6ONTuJ0Jza8QI4R0MpgmIfoIDUfXhXr6jTLCAveb/sy+Hdc0k5R+C4sFD/sYxCPOHV1GyHl4m7yO17wkvPh8AzyDHCl9CI3rqN0k0jRHgWdrx9HhKNh8+7mPJVjdLp+m35+atyV9qLK46h6TQtr9YDuaNl/b7AAnHvA7i+L7E2vAhxFgW5eHhAU1RyTJ1U/dPeWJ+h+FtjRSROnx/zg9lX0mJ38temcCvL5b2a305X64BvVyuJf/fhCWc+QgVHq8XZmLrFQK2ZHqb6Uh72e4KvEtFCjmMuyxClsb3DeDo2LZ/09UfllsdMcPtxnGG5VhEBaf37O9S6GnQRu++Gbh9J1srLLwZhg2nvFkPY8Pfxt3nObva8tjqFE7c4oHxGdAE1b5UZ1q8BvKTHEs7iwdz+D3VcZHSchs3KiQrc3z2yOIW2JkwEYauU9aaBJW3GmkXH5w3GUwYRkI87ryLLOGVO+SARBsaDRFEgLVol0elwzWLBLYKS3+CoX0CfhMf3iEUeBJUyWrAi1DZcQeajB46mSjLeaaVvux4cjVEa0vtxlEgEicy0W0KqFAzJq6SQLhSrTOKmAAqJkaSUwpwxNgeWjNZK1ZffnjDq4qi/+gC6s1fZld6eBATgobKTB97zM7TSfD3rBjZgxmUl3mDgNMMeskutSDB3xAeSYQOkjg481w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

A comment from a LKMM reviewer.

On Thu, 26 Feb 2026 15:35:08 +0900, Harry Yoo wrote:
> Hello, SLAB, LKMM, and KCSAN folks!
> 
> I'd like to discuss slab's assumption on users regarding memory ordering.
> 
> Recently, I've been investigating an interesting slab memory ordering
> issue [3] [4] in v7.0-rc1, which made me think about memory ordering
> for slab objects.
> 
> But without answering "What does slab expect users to do for correct
> operation?", I kept getting puzzled, and my brain hurt too much :/
> I'm writing things down to stop getting confused :)
> 
> Since I have never thought about this before, my reasoning could be
> partially or entirely incorrect. If so, please kindly let me know.
> 
> # Slab's assumption: Stores to object, its metadata, or struct slab
> # must be visible to the CPU that frees the object, when it is
> # passed to kfree(). It's users' responsibility to guarantee that.
> 
> When the slab allocator allocates an object, it updates its metadata and
> struct slab fields. After allocation, the user of slab updates object's
> content. As long as the object is freed on the same CPU that it was
> allocated, kfree() can see those stores (A CPU must be able to see
> what's in its store buffer), so no problem!
> 
> However, when e.g.) the pointer to object is stored in a shared variable
> and then freed on a different CPU, things become trickier.
> 
> In this case, I think it's fair for the slab allocator to assume that:
> 
>   1) Such stores must involve _at least_ a release barrier
>      (for example, via {cmp,}xchg{,_release}, or smp_store_release())
>      to ensure preceding stores are visible to other CPUs before
>      the pointer store becomes visible, and
> 
>   2) The CPU that frees an object must invoke at least an acquire
>      barrier to ensure that stores to object content / metadata, etc.,
>      are visible to the freeing CPU when it calls kfree().
> 
> Because the slab allocator itself doesn't guarantee that such
> barriers are invoked within the allocator, it relies on users to
> do this when needed.
> 
> ... and that's quite a reasonable assumption, isn't it?
> 
> Actually, I'm not the first person to question this.
> 
> [1] https://lore.kernel.org/linux-mm/CACT4Y+Yfz3XvT+w6a3WjcZuATb1b9JdQHHf637zdT=6QZ-hjKg@mail.gmail.com
> [2] https://lore.kernel.org/linux-mm/20140102203320.GA27615@linux.vnet.ibm.com
> 
> # Now, let's take a look at the bug I've been investigating
> 
> There were two bugs [3] [4] reported, with symptoms that appear to be
> caused by slab returning wrong metadata (the symptoms: incorrect
> reference counting of obj_cgroup, integer overflow as more memory is
> uncharged than charged).
> 
> [3] https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com
> [4] https://lore.kernel.org/all/ddff7c7d-c0c3-4780-808f-9a83268bbf0c@linux.ibm.com
> 
> Hmm, if it's returning wrong metadata, how could that happen?
> 
> Well, perhaps it's either 1) the calculation of metadata address is
> incorrect, or 2) reading the metadata itself is racy.
> 
> Shakeel Butt pointed out [9] that there's a potential memory ordering
> issue. It suggests that no enforced ordering between slab->obj_exts
> and slab->stride can make the metadata address calculation incorrect.
> 
> [9] https://lore.kernel.org/lkml/aZu9G9mVIVzSm6Ft@hyeyoo
> 
> Let's say CPU X and Y are allocating/freeing slab objects from/to
> the same slab. They need to access metadata for the objects:
> 
> CPU X				CPU Y
> 
> // CPU X allocates metadata array
> - slab->obj_exts = <the address of the metadata array>
> - slab->stride = 16 (sizeof struct slab)
> 
> - stride = plain load slab->stride
> - obj_exts = READ_ONCE(slab->obj_exts)
> - if (obj_exts)
>     - metadata_addr =
>       stride * index + obj_exts
> 				- stride = plain load slab->stride
> 				- obj_exts = READ_ONCE(slab->obj_exts)
> 				- if (obj_exts)
> 				  - metadata_addr = stride * index +
> 						    obj_exts
> 
> 				// Wait, obj_exts is non-NULL,
> 				// but slab->stride is stale!
> 
> 				// Now, metadata_addr is wrong.
> 
> Hmm, this could definitely happen when two CPUs try to allocate/free
> objects from/to the same slab. We need to make sure that, CPUs cannot
> see stale slab->stride as long as slab->obj_exts is not NULL.
> 
> # How I tried to fix it
> 
> An expensive solution would be do:
> 
> CPU X:					CPU Y:
> - slab->stride = 16			- READ_ONCE(slab->obj_exts)
> - smp_wmb()				- if (obj_exts)
> - slab->obj_exts = <something>		  - smp_rmb()
> 					  - plain load slab->stride
> 
> Then, CPU Y should see either (obj_exts == 0), or
> (obj_exts != 0 and a valid stride). (obj_exts != 0) && (invalid stride)
> is impossible.
> 
> This fix [5] seems to resolve the bug [6], yay!
> 
> Before testing this fix, I wasn't fully convinced that it was a memory
> ordering issue. But after testing it, it seems reasonable to assume that
> it's indeed a memory ordering issue.
> 
> [5] https://lore.kernel.org/linux-mm/aZ2Gwie5dpXotxWc@hyeyoo
> [6] https://lore.kernel.org/linux-mm/84492f08-04c2-485c-9a18-cdafd5a9c3e5@linux.ibm.com 
> 
> # How I tried to optimize the fix
> 
> Hmm, but it's not great to have memory barriers in slab alloc/free
> path, right? So I tried to optimize it while maintaining correctness.
> 
> Previously, slab->stride could be set during slab's initialization
> by alloc_slab_obj_exts_early(), or later by alloc_slab_obj_exts().
> 
> Within the slab allocator, for the slab to be accessible by other CPUs,
> they need to go through per-node partial slab list
> (struct kmem_cache_node.partial), protected by a spinlock.
> 
> Hmm, if we make sure that slab->stride is set early, before the slab
> becomes accessible to other CPUs, smp_wmb()/smp_rmb() pair is not
> necessary. So I made that change [7].

So in [7], you moved slab_set_stride() before the store to slab->obj_exts.
Both of them are done without any markers for racy memory accesses.

Moving plain stores around in the C source code does have no effect WRT
the ordering of those accesses.

To guarantee the store to slab->obj_exts to happen after the effect of
slab_set_stride(), you need to do:

     -         slab->obj_exts = obj_exts;
     +         smp_store_release(&slab->obj_exts, obj_exts);

Also, the reader side also needs (in slab.h):

               smp_load_acquire(&slab->obj_exts);
               READ_ONCE(&slab->stride);

This pattern is known as MP (Message Passing).

Please have a look at section "Message passing (MP)" in
tools/memory-model/Documentation/recipes.txt, whose leading
paragraph starts like so:

    The MP pattern has one CPU execute a pair of stores to a pair of variables
    and another CPU execute a pair of loads from this same pair of variables,
    but in the opposite order.  The goal is to avoid the counter-intuitive
    outcome in which the first load sees the value written by the second store
    but the second load does not see the value written by the first store.
    In the absence of any ordering, this goal may not be met, as can be seen
    in the MP+poonceonces.litmus litmus test.  This section therefore looks at
    a number of ways of meeting this goal.

The RELEASE:ACQUIRE pare is needed because your fast path is not
protected by any lock and can see any intermediate states of concurrent
updates done under the lock protection.

Hope this helps.

Thanks, Akira

> 
> But something strange happens when I tried to optimize it!
> The fix didn't resolve the bug [8].
> 
> [7] https://lore.kernel.org/linux-mm/20260223075809.19265-1-harry.yoo@oracle.com 
> [8] https://lore.kernel.org/linux-mm/2d106583-4ec6-4da0-87ea-4ecad893b24f@linux.ibm.com
> 
> Hmm... even when slabs don't go through the list protected by the
> spinlock, perhaps an object was allocated on CPU X, and then freed
> on CPU Y?
> 
> But as long as "Slab's assumption" described above is satisfied,
> I can't explain why stores to slab->stride, or metadata won't be visible
> to the freeing CPU :/
> 
> That makes me wonder "is somebody breaking that assumption?"
> 
> If so, the smp_rmb() in the previous fix [5] might have unintentionally
> acted as a band-aid to make sure stores to slab->stride and the metadata
> are visible to the freeing CPU. But in fact, a barrier should have
> been invoked by the user.
> 
> Looking at commit 9e6b7cd7e77d ("tty: fix data race in
> tty_buffer_flush") and commit f57e515a1b56 ("kernel/pid.c: convert
> struct pid count to refcount_t"), it doesn't seem too crazy to suspect
> that somebody is breaking the assumption.
> 
> Does this sound reasonable, or am I missing something?
> 
> p.s., Many thanks to Pedro Falcato and Vlastimil Babka, who actively
> discussed this off-list with me. That helped develop my understanding
> a lot!
> 
> -- 
> Cheers,
> Harry / Hyeonggon


