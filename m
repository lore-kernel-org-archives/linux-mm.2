Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A0FCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 21:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B918E00FB; Thu, 18 Sep 2025 17:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953B38E0068; Thu, 18 Sep 2025 17:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868DA8E00FB; Thu, 18 Sep 2025 17:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 733268E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:07:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C5A6160274
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:07:52 +0000 (UTC)
X-FDA: 83903607984.15.0D5B968
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id EB5E740006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:07:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iRQZNXJ4;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758229670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=roUBDBcfKj6FP3l8Gf9Nb2+udjPSnvi1fQaLWj3+7y0=;
	b=FgJ+W5D2PeOt5heblZOKqUwRwJpWITyzNTE+SWhx6VVzl6Tpg2sKh69xCkP6ZAwEx3L5i1
	t3Jum3CB5APnsNYbzqvhejQt56W1X4BwV5LjgfSGTkG9UXhFZLQqHxb+Py/g9sg3gzv3wX
	OZdZD6WQEwttYTKxiaFOggkFJB1Moic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758229670; a=rsa-sha256;
	cv=none;
	b=FlE8p8OGYKQrvnPqxfHEFZIkxANaNALaSrqhXNo4dfkKNrnIW6SxOqSJcvKau+IUq5CchK
	c0UMxtgoxeQLZZbUrs31djSJuUS1pumzaqkQUZi0wLgSRkSGaFHYVU6X43urDA0lAsCplV
	KVbXhvUt2tXua4C4OXYMaREZF7AlI0Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iRQZNXJ4;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758229669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=roUBDBcfKj6FP3l8Gf9Nb2+udjPSnvi1fQaLWj3+7y0=;
	b=iRQZNXJ4+zV3sueV0VXtHJhO2sbVTBetUyyy7x4fC2tNDoBdQ67Y4B/TpgOVwomnZkcnJt
	s/s+Tx9EPxqGm0UJQRPtQkBT9l4K/zotHse8sa/h8XwwATW/hxLtYyqaiNZ0JNaVDFu0ux
	UcPYuYHfFBlyVejFZPVooStYUG/qNic=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-gBC5In8xN2SzPc7HaRgPFA-1; Thu, 18 Sep 2025 17:07:48 -0400
X-MC-Unique: gBC5In8xN2SzPc7HaRgPFA-1
X-Mimecast-MFC-AGG-ID: gBC5In8xN2SzPc7HaRgPFA_1758229667
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-718c2590e94so49764096d6.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758229667; x=1758834467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=roUBDBcfKj6FP3l8Gf9Nb2+udjPSnvi1fQaLWj3+7y0=;
        b=SHqfAOT4ns+ViHhpx4MRwfOowLqZ4IDjKmQThvshU27eMC3XYfa+3vRfnu5HQK56gb
         yocQwiejVWZNbkV0dIvdC5fJ1lmq91wzPPt+RqI0Z58vephnVcS8ONztFDTk69IZ1q8H
         d41/yufU+SkLYAJmsShdhwY05ZKRFJd9H7jkPGPcUCOE9HjEHghwbrIDLa36UXNdZxIK
         +1d7frkT6WmsaaxchLTnLKM7MJVAaAGdurtr3ikHbYhTrP4JE1Vr5EmeGuGcmqIw9x5Z
         xD4T9mneYsxsJjrQOPnh6D6vAmxSARkkziF1RRYm5g2Phqel6wjh3mLgplsGpDwlUd5+
         maog==
X-Forwarded-Encrypted: i=1; AJvYcCXuvG3LMFb9Nyuw/jxF7sY1R+y5lJbTj9wIPnXSWTA4kwIJoI53b0RNKUtG3A4mRTpELBpwJXCa8A==@kvack.org
X-Gm-Message-State: AOJu0YwvbusQx6Ewwh9ou+PNYIqDJk31xEBWbBuMk/HGN0Bmc9INezAc
	C1UTNMbwzaeBVQr0XTOHzHQNENpsiGDWOP3K8psBVHCHbYPukwpbNZ/OUaW0T6pNYP2Nr+ow//m
	sq06+zgexRsbXMVyBw/wqEH90D6BPPrzZqVFJ8yd49SOlxf2DQt0U
X-Gm-Gg: ASbGncthAZC1WvfgddGnQqXMakho3+3Nx6EgxhXlyhbkW6E12CxL/wNK7AvALM5siIA
	XNktWZHtzgEg+I8KoECNp4C/cIo6MzdfBc3vWUzwyM1Yc1FKy0YUHnCJGTjhPt0az9Iyq53fATI
	eviBcIZ4Fm5JUAMOd9cawRvS3GC2Xbk29YiTUr6VnA2vnBuBK+PFSoJKHOE9JgRvUyqTN9rHI/A
	U/tZD8xb9nvyR2UnmnWKhavzKIsJdEAY4/nmemWAHG/yxQ9jAHhk9YDZ5pXOOhKL38GzsOmqupn
	8oGtRCqpjI9aCndmMZFmE0kd02wihDySrJjqqmC7JAaXDqRbjHCGI1N2XyV6QpGdcU9IX+yuZmn
	IByrbqLeMSF++zujt+iibtA==
X-Received: by 2002:ad4:5dea:0:b0:790:40cb:6df0 with SMTP id 6a1803df08f44-798c72124c8mr14225136d6.34.1758229667318;
        Thu, 18 Sep 2025 14:07:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZ/WT6zqYgXmOWGIVR34EnFP0/c2WTo4aDRdjYQx1EN/bJVh35TR0Iu+LlyCr7SxHDPithFg==
X-Received: by 2002:ad4:5dea:0:b0:790:40cb:6df0 with SMTP id 6a1803df08f44-798c72124c8mr14224516d6.34.1758229666734;
        Thu, 18 Sep 2025 14:07:46 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-121.dsl.bell.ca. [174.89.135.121])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-79351f75812sm18704136d6.36.2025.09.18.14.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 14:07:46 -0700 (PDT)
Date: Thu, 18 Sep 2025 17:07:44 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aMx0oGwRpSTcfdnf@x1.local>
References: <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
 <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
 <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com>
 <aMxNgyVRuiFq2Sms@x1.local>
 <cigo2r2x22bk7wzr6qvazcdkmt5kfqhbgb7nslpuff7djufucg@f6xucfuntz3q>
MIME-Version: 1.0
In-Reply-To: <cigo2r2x22bk7wzr6qvazcdkmt5kfqhbgb7nslpuff7djufucg@f6xucfuntz3q>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Zx8h3YLZdLY0Xj_R5wIVyb2cLy5Nb0Ir17y2VaCpQRA_1758229667
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EB5E740006
X-Stat-Signature: fry31htyjbs3kz8fgbpbe78yxtgmx1re
X-Rspam-User: 
X-HE-Tag: 1758229669-58414
X-HE-Meta: U2FsdGVkX1+qjgHIpl3HBOuVTi3022mir/hJVNniYSWStTY6STS5CuTIyidIK5hcOACEB/tQ6mBo4FyyukZRtmwdTNYgfYJvKS2EkttOw87xCcsV5cfOt3J/nxKXZr5gxmesSFaGidarI5FDybYyJd91GV/r7YMB7uhY8NDmW67s4X5ZYiiV7KFlw9YNqj2t7p6t6sna3KkS7cTl+pSV2hMoZKjCIccp4rniaau2L4ZtIjUiS1867UqEhV89ROHMDFIn1kXCEC29n3Xz/LGd6qjV8PRjJ/g13eONDdemODLnHwxuO1aRinPhrRylXLf/WNYQP0K2fndggl+YP3bn6q1yl1Qsp2qzlqyp8IxBOXVm6Mh4UDO3Inmk/Cl9DFxJcrQ+3lYA1M9AtURDeQPwCcFR7znrdWIbXmXWslkJVNpLMo/Uf8i8+/FVTYPe4m8GbUzzC3ZXGTzy33LHTveEP9l0kKZ3vMEbpCAKSpoF7rWehDTbyu8wC5J95ne9kN2zDq/6ChyOTG15lVC17wnTEdNTdyHr99jT9uamzALLoEgU2HMhlZsugh7cQmYFSwZZrxY23ndnnCw+mjELLiKR63Yjsd4H/lK2EwkKqFUj7e8VdTHKbxca6y2ip0GmCxP0IfKG5kHBJxisZoxpDr74r9V662ycu9mMyhONhN5HPz4Kun/Euhh4Bvr4ROXgGUqY9rJpPWmU8LzvmSs9WJ+Lm8kJk5rlVoyXOyMeGELWbJsoNjVxvzhWF8+C3ML/Hn8MsQnQLTzCphLBXWqOfWG9RKeofITxHK521r/AYpZ7xdKn+iJZEuW13D2J1bWbazQhoH41MawjVNVh3QrBLRUPQWfafGQy/9apUSkg3YnwXktcUFdqQ+ODq8vz4UetOvTkazvtSuktvKQXgBKbL85uR7qXoCTD1K4pHSC8SBQc+zYWdvl4BGVU96/RdBtg4eH06zIFqVesKKQ0q6acoFS
 eqfgfLqC
 Ovg9dLgEq+96TQmK5jiVxMNp7vMy5FehgCpuJvMiwuNv2eMWLwue4l+xJUNez8h6Hjocam6vhKMrSuCkUXo/cwi9Yq2Agys2F0bWKkkKYVMUxzguvAhgcIUIUczamRj0LyJbHEhFsaVHCm6+dZG/YSRLT+ZPL/xtsyjeRuwtbNgkT3DOqo0rGk+MjBwMTOxGI5ob7kXlHnvErqRFVJXvbCrEe3tckLI0TCpzvUqGC7zT//WxfaDx9k/jt7JsMXpladwKzAw8B20xnFW3rDrALlv8dyTADQgGZnnEkNedqh5m/bxHpZepyIhhsfiQWEHe0gG0AIk8f42NApjsDsx1gw2u4o0jw2BFxgeet9x/C3rT7a2NeBmDEygFSKhHBN+mfcn4aAk/L/Vax2x3j/bbIEXlpjwKaXKZ81CmGcHM+tO1z0QyCpBHjMfF4/I8KOXUV3vQjh8jq2v56cN4gnGJEnb3II4qSZVXEVBRznz5hXOZmeq4i2YJSvbIeg2AunbB4FNeAIL3rKWyflzvycTBai3wmW7/7LOsHgd/LlOhEkEh35/6xxEpL8m3G+aKqYLtpjarEaolycI6iP+6OVQxHtkQsd0Ve5uwX7aZT9IMMmUiV0f0Ub2abZtNGgohah0qI//jRqqHLgCdgpUtvbM+o5mogLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 03:43:34PM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [250918 14:21]:
> > On Thu, Sep 18, 2025 at 07:53:46PM +0200, David Hildenbrand wrote:
> > > Re Nikita: If we could just reuse fault() for userfaultfd purposes, that
> > > might actually be pretty nice.
> > 
> > I commented on that.
> > 
> > https://lore.kernel.org/all/aEiwHjl4tsUt98sh@x1.local/

[1]

> > 
> > That'll need to leak FAULT_FLAG_USERFAULT_CONTINUE which isn't necessary,
> > make it extremely hard to know when to set the flag, and comlicates the
> > fault path which isn't necessary.
> > 
> > I think Mike's comment was spot on, that the new API is literally
> > do_fault() for shmem, but only used in userfaultfd context so it's even an
> > oneliner.
> > 
> > I do not maintain mm, so above is only my two cents, so I don't make
> > decisions.  Personally I still prefer the current approach of keep the mm
> > main fault path clean.
> 
> What we are trying to say is you can have a fault path that takes a type
> enum that calls into a function that does whatever you want.  It can
> even live in mm/userfaultfd.c.  It can then jump off to mm/guest-memfd.c
> which can contain super unique copying of memory if that's needed.

Per mentioning of mm/guest-memfd.c, are you suggesting to take guest-memfd
library approach?

We have in total of at least three proposals:

(a) https://lore.kernel.org/all/20250404154352.23078-1-kalyazin@amazon.com/
(b) this one
(c) https://lore.kernel.org/all/20250915161815.40729-1-kalyazin@amazon.com/

I reviewd (a) and (c) and I provided my comments.  If you prefer the
library approach, feel free to reply directly to (c) thread against my
email.

I chose (b), from when it was posted.

> 
> That way driver/i_know_better_that_everyone.c or fs/stature.c don't
> decide they can register their uffd and do cool stuff that totally won't
> tank the system in random strange ways.

What is the difference if they are allowed to register ->fault() and tank
the system?

> 
> Seriously, how many fault handlers are you expecting to have here?

First of all, it's not about "how many".  We can assume one user as of now.
Talking about any future user doesn't really help.  The choice I made above
on (b) is the best solution I think, with any known possible users.  The
plan might change, when more use cases pops up.  However we can only try to
make a fair decision with the current status quo.

OTOH, the vm_uffd_ops also provides other fields (besides uffd_*() hooks).
I wouldn't be surprised if a driver wants to opt-in with some of the fields
with zero hooks attached at all, when an userfaultfd feature is
automatically friendly to all kinds of memory types.

Consider one VMA that sets UFFDIO_WRITEPROTECT but without most of the
rest.

As I discussed, IMHO (b) is the clean way to describe userfaultfd demand
for any memory type.

> 
> I'd be surprised if a lot of the code in these memory types isn't
> shared, but I guess if they are all over the kernel they'll just clone
> the code and bugs (like the arch code does, but with less of a reason).
> 
> > Besides, this series also cleans up other places all over the places, the
> > vm_uffd_ops is a most simplified version of description for a memory type.
> 
> 6 files changed, 207 insertions(+), 76 deletions(-)
> 
> Can you please point me to which patch has clean up?

Patch 4.  If you want me to explain every change I touched that is a
cleanup, I can go into details.  Maybe it's faster if you read them, it's
not a huge patch.

> 
> The mm has uffd code _everywhere_, including mm/userfaultfd.c that jumps
> to fs/userfaultfd.c and back.  Every entry has a LIST_HEAD(uf) [1] [2]
> [3] in it that is passed through the entire call stack in case it is
> needed [4] [5] [6] [7] [8].   It has if statements in core mm functions
> in the middle of loops [9].  It complicates error handling and has
> tricky locking [10] (full disclosure, I helped with the locking..
> totally worth the complication).
> 
> This is a seriously complicated feature.

I know you're the expert of VMA, you worked a lot of it.  I understand
those things can caused you frustrations when touching those codes.  Though
please let's do not bring those into reviewing this series.  Those have
nothing to do with this series.

Frankly, I also wished if one day we can get rid of some of them.  It
really depends on how many users are there for the uffd events besides the
generic ones (fault traps).

> 
> How is a generic callback that splits out into, probably 4?, functions
> the deal breaker here?
> 
> How is leaking a flag the line that we won't cross?
> 
> > So IMHO it's beneficial in other aspects as well.  If uffd_copy() is a
> > concern, fine, we drop it.  We don't plan to have more use of UFFDIO_COPY
> > outside of the known three memory types after all.
> 
> EXACTLY!  There are three memory types and we're going to the most
> flexible interface possible, with the most danger.  With guest_memfd
> we're up to four functions we'd need.  Why not keep the mm code in the
> mm and have four functions to choose from?  If you want 5 we can always
> add another.

I assume for most of the rest comments, you're suggesting the library
approach.  If so, again, I suggest we discuss explicitly in that thread.

The library code may (or may not) be useful for other purposes.  For the
support of userfaultfd, it definitely doesn't need to be a dependency.
OTOH, we may still want some abstraction like this one with/without the
library.  If so, I don't really see why we need to pushback on this.

AFAIU, the only concern (after drop uffd_copy) is we'll expose
uffd_get_folio().  Please help explain why ->fault() isn't worse.

If we accepted ->fault() for all these years, I don't see a reason we
should reject ->uffd_get_folio(), especially one of the goals is to keep
the core mm path clean, per my comment to proposal (a).

-- 
Peter Xu


