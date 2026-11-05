Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293C9606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GbSvQJ/l
Received: by kanga.kvack.org (Postfix)
	id 2E8FA6B05B5; Thu,  5 Nov 2026 12:37:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1276B05B6; Thu,  5 Nov 2026 12:37:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0396B05B7; Thu,  5 Nov 2026 12:37:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E57826B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:37:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E7AF809B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:37:55 +0000 (UTC)
X-FDA: 85401773310.11.623D1EA
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8CD5820002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:37:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="GbSvQJ/l";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793900273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/9VHkQVwisO5bupjKzX692XjiMS3IZKTYKgohOq9P0=;
	b=xgmwe25pCaTicMujZyoDzEKsn1gG6Gi2w1YOybKBVfw950NT5gmm34SQBO8EnYZKsLIBGm
	CdN1E8egsQ6LZtGDy8d+d8NTAtfODtwFlq2iQjv1XwjX43EBBo9xSsQ9WF2NiU6Kl3axhK
	+okyZA1K08OjqacZhzEBgCH6u3voCuY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="GbSvQJ/l";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793900273;
	b=nw+zOi13uLxt4j/pH4krTUXX3RXjQSowJymuiV7B30LRfph13eSv8i85WTuiYGMwAeLigW
	y24kuLBuKlTK0muv66ezwSkjwrllF8WSOdYlhF3tNKafdLTgieBMVspYZwqEhNhHPp16wR
	QNebuBxJCwUuG/qvNLmNMJX8lccUKPY=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b571979178so2012726a12.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 09:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793900272; x=1794505072; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I/9VHkQVwisO5bupjKzX692XjiMS3IZKTYKgohOq9P0=;
        b=GbSvQJ/l49LJOiYT4YYN3nn6wzDbS/oHfEsIbFEk9xYHPs/ZXbPoOuas109ArdYZys
         aLtH21Fwcbd+pnfC8tL8G7qwHREfZYFgtrQzVbYR2KbJiiUj+RRMssvpCegWxcrFHx/M
         kczhV8LW173GZS/uIOoXEuanFvMQxnyEI4G9SqXLsbjr3T6n5jpsKC+tmmNrOsHNxD9i
         jECyS37u8jyHh48AkHd1KztVxe2DGjX7SPB4B5ak4ritXk6HW6YV8WpeQyL2lQt4MD1M
         L+qLyxG/G5h0wRPzGi7zEjJZq4FdoxfxxV/3Kr2qU3+ZeEwtEPelC8BL0SYroDz3l4yI
         MQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793900272; x=1794505072;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I/9VHkQVwisO5bupjKzX692XjiMS3IZKTYKgohOq9P0=;
        b=Gy3tcn0x2/kfpJ1ApGTWqywZY6xy+rfW7hdOZmFwjjvsk3ZSld0O2Ih9fpE1nGeRcH
         9njTZ/ht1o0MNs2bHYNqurlqR36IgyTX/RMmuacqcxSnCsXRa2A3M7nESpl8b5i+B7kZ
         NJPXWpcZ73GRdO3lWSHvqFe32plC466uzS7SJdiffVNUh8PgNmJqeCLtn3wffn6UYQZ9
         ZE50t14hjD0T+QukFeQAhevKgjijftFqgapJ+5MA7v14ug6Pf40nSX72JdSCherPVVQM
         +Zmdcz2hACkWsM0t3vwi9Lf9QtOc/uYc3Ig/gYb9Yqy19F32Zbq3yOC5sJ78Os/ToM9F
         J+9Q==
X-Forwarded-Encrypted: i=1; AKwUvBxIddI8M70wH1lUvfAiPrv2YDpKIFsLtkw22imNSXlwxmrvDcNVvfH7j6ToH5cRvpm9tlVSGJpQiA==@kvack.org
X-Gm-Message-State: APuU4Z9e+G4dOkSmosmbCKUldyP4ue7zZv06qJymkDR8jWsROHmrw4Wj
	v037d+ydHddgBqgvUmDzbd6w8YFDanld4s5psySUw4ikJ9heKf20Nt+G
X-Gm-Gg: AYBFou38ImmrDBngppgFNUf1Xz2l7MQrTe1XfOXqOBWOiIiJMXISGguB/hAKXvpdEGU
	K2FNrdawJo1zPf6yQTUDcl+RuO6wtkDF+daqvJX+AuVYTDUvvly478dn4jjjMSeL/qhl4d/74Gu
	j0JOXruN2NdEHQBOdHCRPH0phEC83I6hDB0gQ3b+zfK/7NocBwiJKpSGiGi1ggPIZdHcNbQh5EU
	cjMBpJhQqK/F7W/ers6vpvDJH/8ko+f7af6jv5sLH7z71FllBuqddoDTMJn/LrGh9ybH9HIBnpD
	QUwQVIyIewc+DBppZwVxlKMrpvIehJSP+DSPrcS07cMfEEbKm00e2gAL9wI5kWwIZhCmHVd0uYw
	JU4LQLA30HNPexSpRDKsc5cR2sLCUM1+orkcdKJ2YPmnwQFfDuqV7T2VAm6QT+Bjz+7qQbPTuGW
	iDf2AXL9QzKLOqQYkpVDs06DaJuBfGL92xdVEdOvAzucL3s7pReAqPVgAuKhJGLHzTH4uTjMqE6
	Epzoom+MR9HWrYzhjByEJ9MNKz/PRaH04xqSBJ3fUbzuivFoeR2D+hFVHy/gPRhrGQm
X-Received: by 2002:aa7:d281:0:b0:6b5:916f:938c with SMTP id 4fb4d7f45d1cf-6b5916f94c8mr459489a12.41.1793900272060;
        Thu, 05 Nov 2026 09:37:52 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b5876145a9sm494548a12.36.2026.11.05.09.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 09:37:51 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 5 Nov 2026 18:37:49 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auy-7TvVzJ-VCrG4@milan>
References: <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
 <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8CD5820002
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: atfj31uh9rc9ziu7hz3co58onygekgji
X-HE-Tag: 1793900273-208913
X-HE-Meta: U2FsdGVkX18TFIxc9M/ny+GVdBXBxNTtiO4NDorsLjePAZ/t7mtoxEXD5/rXtdSZ2iA10OhyDSVr+ETdj1IXBvYMrvjNateGq30TV+6ulZbu0Hw6w5zY7Bep+Ynx0As6DTys3EUlgUzOjMNAMMuLS1eHBzMX3s/hI4BUd8IrwXBqiyK1idcmBTm5lutlwOgimxqv8m9uAthiLoYtlzNPrzS2rr0M07K+jK+KBgm+LSEzRHyh17cajq6z3c2nzIPBhX2uzn8gvWHKLEr/NnYVDKfcp7ek1bJgFz1Vvq/76ci6VQ+zcLT49xtR2c6cvSnTh+bh4EcR4jDL061uQmxLZjACtIXYqJqYNpYgMQqld1Ueors4cc21wrsKw0Xh7jn55/pEoSvenpHQVGjZHA3ZRcNxbFVBzI+52wft08RbVE/VIk/VepzA48t2wFz60Z6Nbr/mwkh0lUXl3I3OZl6PCL1zNGDMUxIX1uPzGQBDkKv8ouq99HCfc/v+jPk6+ko0Mdg+LAcHAWlMKaXk/cn4jmYPkcKmEh1c1ROfDVxTH+9UTaOrj0Z/UNvP7OmplEm9MdBuZQcZDoCVnhLlCUrn6YleLk5DQysIqlwV6opxWUARfacNFaLdCdq2QlS5YzxfQIRyXg/Ak+zcntqlarpnnLaywjkqHbutUJr136Ft2rnS0MuYQtf/NzgGSf4eai8GZs6MFXA6Su62uOyPXZ+51VmNT/P8Mn08OzXE/D8xjs4io57hw9NEK6cj9z5Gm28lRJax67F0k1D8RnG4B3F74jMSE/IZuMzKM+jpzlIlQNhLlmTyTbkbF4iaPT55MWha57FRy7o902OnuQ0IxC9ZKyz4Q0pqHlovVAND9KVvaPIOvg3lx8Dbeq/UVyE/zptivy+VkZzdBQdkQS4j7CZV/SERUjnHDSupmID56CeSMVxUsEGmiAbOAPXnmX5/fkO1+VEqX1ohPOtOixEeKEp
 zwLeph5r
 Qimrnk92dBp/Bjb7nOISP3lKE++iTdo1q2QYfnpEWdy9tRQy5JdYaxiHSrqv+dFkx9nASIpClNq8xRyubTSzwjawhmx8oUQTVYJgO8swOYbOAJeChCl7CRRo8pX+yAs5beT9XgEQn3Ij+whebB4kPpolIV+kxlY7g+PPePBMbvXS/Wb9Zm/93ktQNNbU3JGiwzF4D6RAN3H+JVLunL9E7WoWrD+Yqs/F/P66dhGudKP82r3JGuA7Kgyz8gkl5rcMlN2OgzZCcdJdkrVTdz9VSJH1a60EmVLfpdsVpsu4glmvRM+vp3kf7+3VKDsgEbX1YJIh6RSiNSXmjtlzSXSxOFLfoAkA4gfM5Nr2u2FmQPWWyNYK93Cf0aRHMpNooq1zVhc8c4QbND5swogxdQeqAwyBCMd+UDkKXYm0vFpcQ6Qbd70XUymHdkkpYQE/k7d5/AJZ2qt5Cn24DTpe6swEt4OxTveZ8w48NnxuK4RB6hhu4MyffBwk8/r8YJ3zldcHBN1/fXyCG1TmJcJ4qX+PfojI78O8jacqPGGPKUUyHjWZhTxxtXpZ5oe0nFBNkmuE18FJDvs0LOe9meCdX8Wx+wSqrjXRPANPrkZ69vOvoxkuny0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 08:22:52AM -0800, Linus Torvalds wrote:
> On Thu, 5 Nov 2026 at 00:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Wed, Nov 04, 2026 at 12:11:24PM +0100, Uladzislau Rezki wrote:
> > >
> > > There are users in kernel. For example:
> >
> > Thanks for the list.
> >
> > > drivers/GPU
> > >     /* Allocate the file in vmalloc memory, it's likely to be big */
> > >     iter.start = __vmalloc(file_size, GFP_NOWAIT);
> > >
> > > AMD-GPU:
> > >     kvzalloc(size, GFP_NOWAIT);
> > >     kvzalloc_objs(struct amdgpu_coredump_ring, GFP_NOWAIT);
> > >     kvzalloc(ring->ring_size, GFP_NOWAIT);
> >
> > These appear to be executing out of process context without spin
> > locks so they're not really GFP_ATOMIC.
> 
> Historically, GFP_ATOMIC and GFP_NOWAIT have been largely the same
> except for GFP_ATOMIC eating into reserves.
> 
> But I wonder if we might be able to soften that a bit, or add a new
> form, because it looks like the AMD-GPU case at least doesn't really
> care about any kind of "don't sleep", what it really just wants is an
> "optimistic allocation" - try to get the memory, but don't spend
> effort on freeing things if there is not enough memort.
> 
> The AMD code in question literally has a comment that says
> 
>         /* Dump ring content if memory allocation succeeds. */
> 
> so while it's possible that it has some atomicity requirements, it
> doesn't look that way to me from a very quick look.
> 
> The etnaviv case looks to be the exact same thing: it is definitely
> called in normal process context (that code takes a mutex lock around
> it all).
> 
> So those two cases really don't looke like they are about "atomicity" at all.
> 
> > > net/ipv4/udp.c:
> > >     err = bpf_iter_udp_realloc_batch(iter, batch_sks, GFP_NOWAIT);
> >
> > This looks buggy in exactly the same way as rhashtable.  It's
> > called under spin_lock_bh, and the same lock can be taken on
> > the softirq path on another CPU.
> 
> Yeah, that case is definitely actually atomic and holds a lock. Not great.
> 
> Is there any way to limit the vmalloc() case to the actuall atomic one
> and just fail when it needs to busy-wait?
>
Probably it is not easy. vmalloc() takes several locks including
during page-table setup.

Probably the simplest option is to return NULL for non-blocking vmalloc()
allocations when BH are disabled. That would address the reported
rhashtable deadlock.

--
Uladzislau Rezki

