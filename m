Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70233CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 966656B0005; Fri,  1 May 2026 14:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917C76B008A; Fri,  1 May 2026 14:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D576B008C; Fri,  1 May 2026 14:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70F246B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:25:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19A1F1C0196
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:25:53 +0000 (UTC)
X-FDA: 84719679786.08.B6C76D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 06E5E10000B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:25:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIVeO3aI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777659951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4A1t9IUPAxFiSXYXl3Z4jwgMAwfMFsg3JsxiXOyKCg=;
	b=3gClCw/cbpcy8AU+83dcfWs+j6VOuMmBOMmFuaPMVObQihpGQweAZ7GGs7A1D7BXcXuLsy
	CYgFXM+17z4OPKTZjAQAYcWdl68UDALZJ619ZCpv8k3KO/jLKL3xTJrzU5uA5Lm+njbOzK
	/KbgqOIBQxQ5hLfMskGhVb2RPbjBBXA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777659951; a=rsa-sha256;
	cv=none;
	b=CNbCFUo2lyEqc+rbVt0g5hWkvnnPLZ/mUOueqSUTURDeHxqZlIBDyLDU4VUPypSeJf+68U
	qHOah+xT+WJsa05mEHXmLYLAQgHGDSepKDIFA4kUdcz2Bhn4+byEKm6yDBlvvvgdgwiJLs
	ckKOKyAINlo6kNM2/9/4BCggWjosDgs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIVeO3aI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0EB344549
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0625C2BCFF
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777659949;
	bh=lT/rPel9FmT35iq3NDhHuchj5jXwn6oKumOJ4dCsmXc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FIVeO3aI7z+jFqDqXITJ+jWsf7lknsacv1Vzwcn4Qsr6jBLZMM2APApvdOADED8Ln
	 tAIwXt9R3qywh7SwzohMPLV0t1vg1LPT7kOq55TgbdDGfwhWLLAjfL+brTf/OPCywN
	 jEfUkX05+1k8ouTnvv+GA9F+JEnzTnf5Oa3U2Pt8IrB7QbY20FMPALZdtczL2ANGRj
	 CrACi6wIjjOv4ftAgLt74Gg2ts3YaDODuAFLoaOg1uLSZtNISIx6WZBJZfcCC4lqXH
	 2KD3b4Y7/PA6fAAoCZuEsL9/UflhQWvEAIT7FBdFCoa8CcfRc5UKFiKNKCX0uHRqoY
	 UbCOWCsY8mKUw==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-506aa68065eso15258871cf.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 11:25:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9tNg+/3OmLKCWTj+2jqayiF+t5AMKMBoTBTZpaf3lWAWcgs+PFoDVmyDw/HVFhGU5RH2y7/u/0oA==@kvack.org
X-Gm-Message-State: AOJu0YxT/+0wZsLjOr3pNtgO1t5QU+Kj5iBK0VM76vh8oGPZNrxYKAWf
	1HYS/zRkhaZ460J9GBqrRDyvr1xoaPFBiSKjzeqTRNa0sL0d+jQ1DOqS47EwJUdWrKwgZygo1Px
	WNj2cV5t3HYgwdJlFZ8cMdRIF/pWz2mA=
X-Received: by 2002:ac8:7dce:0:b0:509:2455:2b53 with SMTP id
 d75a77b69052e-5104bf755a7mr5248631cf.49.1777659948730; Fri, 01 May 2026
 11:25:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
In-Reply-To: <afTpoL3FklpQZNMM@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 2 May 2026 02:25:37 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x8sNtgv7Y198Gh9NSY+SE2o_JPFAxG9aWE+xXsB9vwGg@mail.gmail.com>
X-Gm-Features: AVHnY4Jc3ag1bUQ2844h_SA5sVSne-TN_r5pli71-jMQXFzkdxM1Ig0IdK36GUU
Message-ID: <CAGsJ_4x8sNtgv7Y198Gh9NSY+SE2o_JPFAxG9aWE+xXsB9vwGg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 06E5E10000B
X-Rspamd-Server: rspam04
X-Stat-Signature: e53d711d1765eza99z94xzt437fpbmpx
X-HE-Tag: 1777659950-740742
X-HE-Meta: U2FsdGVkX19kC2ln/3ZeuYWWLivYM8Ufe/4wHux5YQc7D3z9z4qGc7M8QtBNa63YBAmPVXfZEuWOMseI5Ejek31Q9dPTlRJbONvd/GroH805dbQEn1vl/A2+qaNvQeuHUcmaZ1ZlJs1PKpgzZ0JPZ9bbbNzXmIa6cw4w3/FfVUuKaNKvJTIwJ+s6lpsxM5RHV4rvwipENDPtFviS5i6AphRXUHBP6iJOaOeSI+gkfo/vGjNqlPiAnzXTwX5yth92gn+D3eUJL0PrbezZZH6892w896V6XVR0aLuBVWpA9myfR8MYji5xs1et5Q/TVqzoJ2wZcqbUGns0p7djeuzCJhx/M8J1RJERz+3REudB2Dmco6gPG8h6Q+YzXtgDshr+0Exn1/qs+fjj2Ep0eSKawMnA2TYys9DZzHS44Zm6oM7pSklDHqWsvmyjEqP0EUhOAC6QyErfieDo7e4FsWLm0PzCxwerl0LxuK5mybEcMwmJxXT6RuaJmR24F2n0kvFD9GKtEUp87/zK+SGqEBHU9azZQwwDwW7YJ1kwAfkuiBiLUgklGIoYDCgpvToScE1aN1D+M/dd/YrLVA2NFWWPPTJgRI9ELLivNawwp5lbyUzJmWltEQOEH0VcNPOgbAyfJzKD4vMOATOtQXCFgcwMg1ksSH6BhNsTDHk2v1kl4gUXtEKByVBvcM/yk5gXYdykxRS+dRKfubHDS3gA14xXqC5D35tjp7Z6tmnIGqflrd5zUrXUlks15i8VGSVKOWtMp/6djYVGLxEZFJ0Lh2+s6qw4TC0YzKUfcpgjsOOdPvC4UrO0MhX9eKzuQQXuY7Q7ryIQ/o35o2PyK1oNhEsfTFexKIsb4rJcKCKVluUlGxBcK4H6W9JABvip8wL84AMk5AX9CeDCuP5EfaNKWPekf/wG48luu8s3w1jVf6ynWixnHOGQl7/asEnrQPNqRmib2BszSCTrjTpAfKpQNb8
 XVsv7Ime
 8IhTGn9SGGJaFo34X0nMNRqYPpp4+6Nhomdym5bgiFfW+k66IWNmVjaS7rzvH8qNN3yRhrQFw7ldB/a2PoS1VmKl9LjNgpJR5tr/jodfozkCkv+jZ1Tt98u7YyBbmQ6HRUywbjrGwZ+7+L0ijioFDE6aVKYIXd/ZecDpVyNT0wLI5eXwf/y78Q24iMXMOiXZkZ0b/7+XQuRgpjRJqfETOcjNwotViods5EMyWdYw7i3R0Vx0MhDpJAXYIvo5TiD1LjN1ejLh54VBkJifn767zi1jwnDW8ZUDroZwSUUvCwY+rhgcVbAX5tBKXrxMVM/revBsks8q3bGYAv3xc0JlW16hrK1B7VvE+EYAxUylSWHKr9cFkXe/nCngiqCeMqqitQ24mBelNTyYy1rtSvLr2scorwticsLkJMDXEWQ0tgqtv+0uZtC0i7zmiXy7sKnKD05yk3eq7pbk54LNugxf4wrYAeSYGbAuXegExIs/ubJoYhiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 2, 2026 at 1:58=E2=80=AFAM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > On Fri, May 1, 2026 at 10:57=E2=80=AFPM Matthew Wilcox <willy@infradead=
.org> wrote:
> > >
> > > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > > 1. There is no deterministic latency for I/O completion. It depends=
 on
> > > > both the hardware and the software stack (bio/request queues and th=
e
> > > > block scheduler). Sometimes the latency is short; at other times it=
 can
> > > > be quite long. In such cases, a high-priority thread performing ope=
rations
> > > > such as mprotect, unmap, prctl_set_vma, or madvise may be forced to=
 wait
> > > > for an unpredictable amount of time.
> > >
> > > But does that actually happen?  I find it hard to believe that thread=
 A
> > > unmaps a VMA while thread B is in the middle of taking a page fault i=
n
> > > that same VMA.  mprotect() and madvise() are more likely to happen, b=
ut
> > > it still seems really unlikely to me.
> >
> > It doesn=E2=80=99t have to involve unmapping or applying mprotect to
> > the entire VMA=E2=80=94just a portion of it is sufficient.
>
> Yes, but that still fails to answer "does this actually happen".  How muc=
h
> performance is all this complexity in the page fault handler buying us?
> If you don't answer this question, I'm just going to go in and rip it
> all out.

I=E2=80=99m getting quite confused. In patch 4/5, you suggest a more
restrictive condition using
if (folio_test_uptodate(folio) && !folio_test_writeback(folio))
rather than if (folio_test_uptodate(folio)), before we decide to skip
retrying the page fault [1].
That seems to suggest we should be more cautious about when we can skip
retrying the page fault.

However, in the cover letter, you suggest removing all retry code entirely.
Does this suggestion apply only to file-backed page faults?

[1] https://lore.kernel.org/linux-mm/afTQl12XcXVnku9J@casper.infradead.org/

Best Regards
Barry

