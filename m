Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB54CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 20:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09858E00CA; Mon,  3 Nov 2025 15:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0138E0058; Mon,  3 Nov 2025 15:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF55C8E00CA; Mon,  3 Nov 2025 15:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD6BF8E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:47:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 381A81402F7
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:47:08 +0000 (UTC)
X-FDA: 84070480536.12.F171396
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id CFE334000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:47:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VO0HSlFn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762202826; a=rsa-sha256;
	cv=none;
	b=Zwt3Z6awqDupsSd6KWCr2imzQgR35lH1X0FB0AcNW08X6vLip5iVxuh2VIH5nOK1NmWu5/
	KctWoP/DPOxBiJfvQEIaxFIUqvpPoOo0oq8wF6oUAOeWGj318bLcjPITzGNVJUrXbdKxHo
	I3VdpFk6z21q6o02y6gLp5h9bNwa4o4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VO0HSlFn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762202826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vghBKiSvOSdxfV0lhypHIAUMncAsgcwHnYxmY/VnkRM=;
	b=KGcP+iRPFORL2c6lB2UFoKtMZmiLnBe07U5CdEq0QvjqOW/WoW8RoywwNxrrIAwgNTt7gB
	lLl27KKXbHCZyQNvvMy75/AcdHrhfdDkqRyXeUyxq2kGHqNQfj8caTpuUzCqp98f8ZrrHS
	w4RIUMN+VG4hUci8JJT/F+mgx3AZNzw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762202825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vghBKiSvOSdxfV0lhypHIAUMncAsgcwHnYxmY/VnkRM=;
	b=VO0HSlFna2i7mcPULJMboPxE+4x6iZTDWRwuL3kAO1cOtvSumdbAGX6hwbPVmWKXAplSps
	a8LOWai3BD0Z9jOq5xctsxrKZF3MAcJabUV0XjPM2acKcbDe50F9evSWkC52z+XXecWCdi
	w+hBvYKPfxz+Oz0OvXGV1m0MYYoVbYU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-BlWVBS0dMKaSV2VUj8bf9Q-1; Mon, 03 Nov 2025 15:47:03 -0500
X-MC-Unique: BlWVBS0dMKaSV2VUj8bf9Q-1
X-Mimecast-MFC-AGG-ID: BlWVBS0dMKaSV2VUj8bf9Q_1762202823
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8804b991976so47639866d6.2
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 12:47:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762202822; x=1762807622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vghBKiSvOSdxfV0lhypHIAUMncAsgcwHnYxmY/VnkRM=;
        b=BBIHuWrKH9m/w4WHCfc9fs4QbyR+A37xIjoRsB6+C/qi+z/8ivzPVqIh1Pel80eFEV
         4SQtRInBW+rUlkD2C8NdDvxMITWDi+eRjOCWdX7zTph6o9ha3vck2vTH+xGwNy6gqbOR
         4URud5V8R1OdCECpAyWaVK5ZnrFKvIX/GbFAcHQ3cbu3j5lswa18ILpZ6sIuJsb+JA8c
         so1yZ9gg8EWL8Dt0J9SJwtW2qw9C+SuE+MRHIGQr9kcF0H0LWV+Th8lU05rljN08p4ci
         JhD57xpCLkViRXztaAZMo4XDclrXEo7tpW8/XZzoEm997CnaKdAYr6BJPBuumCblXDpE
         4NLg==
X-Forwarded-Encrypted: i=1; AJvYcCXdluUUDLLXX7TlDaNuBfspvb4PRHaI3cj+IAx59Vw5oYRn/6dlSOKv8vTTPK0u3weBSrBABuSAqw==@kvack.org
X-Gm-Message-State: AOJu0YwHxArLBu75lt8KdxJ7gwkXDudWwWAFTHW+IJKsTcW6p3GvwC3Y
	DHT9gQyTDqfy7Ma5bFUkM5kuLWl+pJ/cnnn9Eg0GR6FTHhOQDtQTid8i0J3KFfCWxUJKDu9BOTW
	bFOnqdad7Sp654tIM6Xz5JrLKEGOHzDEXV0Na8LTu9kCPbPStmYkj/ShZs6hN
X-Gm-Gg: ASbGnctLLZdKHDQDjNbaUdQqC4zDOyuHKX4+0VxdJmiFLZfGfu63bjoS6ueQxLNwICD
	QL65Rm28kUVrgklO0mmoE7qzc3WHo8jMmsxJevDcZMPKPECE0MRdlnWRl/LPwKFXHYT1l5/Xztq
	baGVbKgJggLEhY5ZDUs+2oqLXAJGnxaU53Lgw/VQjQiZqZl7mD4/Y3Ee9u6OdggEzaJ/+5Pksyq
	HW4vdj8FkjpYsqqGMQopyAuhcvvmGM1uoYi8ZFinTRGNIT687RNW9wr8CXyMIUXvqTEQJ8xYlPh
	hpVfinQFjfXu7UL/+Vr/OhZERF9Qh8Y3x+0YAP9XVxF4y3cBndllcBQGgm9qzyJA0ds=
X-Received: by 2002:ad4:5d43:0:b0:880:4c73:9e44 with SMTP id 6a1803df08f44-8804c73a24emr33040646d6.15.1762202822198;
        Mon, 03 Nov 2025 12:47:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFki4qB2bWfAdvpnwwEKDZVQ/jgwqxyK8R5E1a/l8fmyEI99KRQ9GoapziPmE3jrH2Z1ZbnIQ==
X-Received: by 2002:ad4:5d43:0:b0:880:4c73:9e44 with SMTP id 6a1803df08f44-8804c73a24emr33040296d6.15.1762202821640;
        Mon, 03 Nov 2025 12:47:01 -0800 (PST)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88060e9566dsm9124636d6.47.2025.11.03.12.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 12:47:00 -0800 (PST)
Date: Mon, 3 Nov 2025 15:46:57 -0500
From: Peter Xu <peterx@redhat.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aQkUwbx7Z4q1qcSB@x1.local>
References: <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
 <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local>
 <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
MIME-Version: 1.0
In-Reply-To: <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2-Lxd5ighq6RbboP_ffZqXFszH9IS1DhHDkf-CrXqLk_1762202823
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CFE334000C
X-Stat-Signature: yz47i9coqoe7rec4otoebwiarifrwq9o
X-HE-Tag: 1762202825-56727
X-HE-Meta: U2FsdGVkX183GetM039iLuOfziaYqZjN6Z0ek+t3xouKyzYww3tcTs2AwHPzKYYcBDrFOkSaXiL3DSXO2lbdua0QGpVWw/NHOGUXecqUfNdhTk8ns9FMUqsAL7/bRc/Y1HjnZJ4aMtBUFOPWVQwiNEsi1LxA0a1tPd5M6pNRHgoa+vlXFmoYIDT9h9uA+1rj5XmD34YNcI6MXnUBcOrLmZQXTzk6qk9qhSIMEzsXw1lmmE8K3ftt2fCQ90niqnlWQgfAc1sh5D4E6LvS4XF4ZsT1/+XntspiChcJ0hD3+pMVjB+ZKXdiHUDPGkURk6S/ScqmOEK6MJhFJOPc3rm5Ae4Ww3/7OYgchZF5AUXX//yGQdLTnN8aaRkI7NrE9dGNQRH4Ye8335lowDjYHWwHaeoXO9hrwOwJnitvGUOjFxNoW42uJaW6TQSXB71i19k4y1JFtdOiv6nE/qJpVT8yarb6e5sN+D9JslHc9pUnOlXZ8YF+9XVrD4YibZA58GBmDXDJB8lrblESY30QtH6LfBiwnXhl7kgWBb70OBn/3bTpsO2WPrO7Kc+lzeOX+BhvtOCs+sH0aSd08HZlsXtOblyXID8R1VrbetyDoZSjec9/94ylfb605zGXWsf1bkW5Yee3YihcDUMskVaMgGy4tgIF+CO5NTbfTlDEdkj1ISkrR9BFg16YmIgz0sK8LQm5k5rAHyhfAMh2+HEdOu4+1YjrrQpHR8qWIbIEJO07wCS4PQGdEC3nXi/fBBxXSRLP/srCiMF6w9ciDWYPrkaY/xd7rxPzlk/ia8vLcUFPWqD/veVOi6q9zxEtvgjPpDHLQrfm6dlfqmsQM6PNhKn64MTHwZYBVQ34OtQRcM04Ou1w8Pqq6w6QrzSMzHL+CcOSME3RnQhQkhnWeq93N0SNsWqY4Yu1g7uBwV3CZ2Fh9j0kNYeZEiab0Wjl2/FXG1W3v/3/A2SQo+CsxmGJHN4
 xDzNOce1
 VbByxqaq0TpsUqk3SYc5UTYqiAoeDjkgDuRjgLyv2JwNzH3kK7nsoMNpcIB1cwtogFlm0QylRu+jbBogdaGEjFkX9hK85eo4mZPqyfOt6gr4a6qOg6DZMBtm04MxUV9OrTE5HZJ7Gw2X5/vQJcoFTRnho0aFJi9DMjZORADcwadgTxUQ3V7jTdciaM6az/2SvUZWM2MZZCDX7axNbBwRX3FACtcLchxcoRW6G6HY/iOcUPQgI97bG9YmAnK33RJbKlaaNMppA9pHrkeHM4qFB7Fp0j0nQ3bItZOBQ2+tlZKDbW8bTRf4P6vZT2lMiKQ0d08EzGTAXcnrwxg2kWB1u6Zm8iAgbGKb37FE3zJsvAvq8k8EZeOgrBVUiMHplreFRBw885/9Whctp5ml59Q04dTZtyQRJfGxu+lBrCcb+3ZvvuVvRBlyQ6+G5zlEtOP0FhPItYrxI+rtObnnGpK5sBoGc4WB8XGmq8/O/LEwXmvmJXYPKwHCgdcp68UwufjWVB9N7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 09:01:02PM +0100, David Hildenbrand (Red Hat) wrote:
> > > I have an extremely heavy workload at the moment anyway, but honestly
> > > interactions like this have seriously put me off being involved in this review
> > > personally.
> > > 
> > > Do we really want this to be how review in mm or the kernel is?
> > > 
> > > Is that really the culture we want to have here?
> > 
> > Gosh.. Seriously?
> > 
> > I'm ok if this needs to be audited.  I have all the previous discussions in
> > the cover letter as links.
> 
> I'm late to the party (or whatever this here is called. ah right, drama),
> and I haven't yet dug through all the emails and certainly not through all
> the of involved code changes.
> 
> Peter, I was a bit surprised by your messages here indeed, not what I
> expected.
> 
> The "Your code allows to operate on pmd* in a module??? That's too risky and
> mm can explode!  Isn't it?" definitely was absolutely unnecessary ... or
> telling Liam that "he want almost mad".

It was a joke!

uffd_copy() API was NACKed because of this.  Now the new proposal
introduced it.  I made a joke saying Liam allows that to happen in his
branch, but forbid mine.

I thought it was super clear to identify.

> 
> Again, not what I would have expected from you, and I would assume that you
> had a bad day and would at least apologize now that some time passed.

Sorry, no.  I won't apologize for that.  I was not fair treated, and now I
think it's fair I at least make a joke.  

David, you're leaving, and I'm totally dissappointed that at this point of
time, you ask me to apologize instead.

I thought it was obvious a joke, because I never thought having pmd* in a
function in a module is not OK.

I always thought it was fine, Linux is not a micro kernel.  It's just fine.
It is what happening in Linux right now.  It is so obvious.  In case it was
not clear, I hope I make it clear now.  If I'm going to formally NACK
Liam's series, I won't use this as one of the real reasons.  I just hide it
in some of others that are real reasons.  However if to be fair, when this
reason is removed, this series should also remove the "highlight" that it
removed shmem.h header, because my v1 also did that when with uffd_copy().

> 
> I understand that you were upset by the previous feedback on the earlier
> series.
> 
> There were some heated arguments in the last discussions, but most of them
> were based on misunderstandings. I would have thought that once they were
> resolved that we could continue focusing on discussing the technical details
> again.
> 
> From what I can see you asked for actual code and when Liam came back with
> some code that looks like *a lot of work* to me.

It's Liam who stood out strongly pushing back what he at least used to be
not familiar with.  This was, IMHO, rude.  It's ok to keep silent on some
patchset that one isn't familiar.  It's ok to ask questions.  It's not ok
to strongly push back without being extremely familiar with the code.

He might be more familiar now, I wish he is. But it's Liam's decision to
work on the code.

We're adults, we do what we should do, not what we asked to do.  If we do
what we asked to do, we should have our reasons.

My ask was trying to make Liam see that what he proposed is over
engineering the whole thing.  I was pretty sure of that, he wasn't.  I
explained to him multiple times on why it was an overkill, he doesn't
agree. It's fine for him to disagree, it's Liam's right.  Then it's also
fine for me to ask him code it up to notice himself, if I can't persuade
him.  That's the only way for him to persuade me instead.

I sincerely wished that works out.  As I said, then I'll properly review
it, and then we build whatever we need on top.  I'm totally fine.  However
it didn't go like that, the API is exactly what I pictured.  I prefer my
proposal.  That's what I did: showing the difference when there're two
proposals, and ask for a second opinion.

It's not fair to put that on top of me to blame.  He's trying to justify
he's correct.  It has nothing to do with me.  He can stop pushing back
anytime.  He can keep proposing what he works on.  It's his decision, not
mine.

> 
> He really seems to care (which I highly appreciate) and went the extra mile
> to show us how the uffd code could evolve.
> 
> We've all (well okay, some of us) been crying for some proper userfaultfd
> cleanups for years.
> 
> So is there a way we can move forward with this without thinking in binary?
> Is there some middle-ground to be had? Can some reworks come on top of your
> series? Can so reworks be integrated in this series?
> 
> I agree that what Liam proposes here is on the larger side, and probably
> does a lot of things in a single rework. That doesn't mean that we couldn't
> move into that direction in smaller steps.
> 
> (I really don't think we should be thinking in terms of a CoC war like: show
> them what I did and I will show them what they did. We are all working on
> the same bigger goal here after all ...)

We've got some second opinion from Mike, please read it first.  David,
you're co-maintaining mm with Andrew.  I think it's fair indeed you provide
how things should go together with Andrew.  It's fair you and Andrew
whoever would like to make a decision on how to move forward.  I'm fine on
whatever decision you want to make.

I think I tried my best trying to make gmem work as simple as possible.

For the CoC report, I wish someone from CoC would also review it.

Thanks,

-- 
Peter Xu


