Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B683DCCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 02:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C3A8E002A; Tue, 28 Oct 2025 22:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3C48E0015; Tue, 28 Oct 2025 22:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609218E002A; Tue, 28 Oct 2025 22:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50D2F8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:47:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B12461A06B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:47:44 +0000 (UTC)
X-FDA: 84049616448.11.E3D9A81
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 445AE1C0009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:47:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KXtujlG2;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761706062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tV6geqkUC9yszulriWkMA/zBhhS+rMg3DhyWlFe+W7k=;
	b=LR6UgkDPB0yGm5G4xlLABhy3EPC3vCQHHeY2p9CsIkxaJamnD3JQsrYm9BEPjiTs5JwvMn
	sB45xoCWVGK9Lgy6o+/K0MRjmrGuQHd5AV43DCr9WpHsOqkoTbsjyHhRSxdJ3/L8UPgGdd
	XiWOxGY3nL5l0zH2wsapnxrfaHb2rWA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KXtujlG2;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761706062; a=rsa-sha256;
	cv=none;
	b=RD2/uwwCS2mltH4A44qGbFCKt8XCpJ+N4e1gMahTLU68mXk9ZPbTxzXEj6zpHKB74reV8X
	6NJFnh8ojhjGT4y8je+mndB66xNUwuLxymTqs5y/P6eDxdBu35YwJICzueFQGJT5pXULG7
	a+2tPnIGubIjCsg/EDHMcAj6vGZdAfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761706061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tV6geqkUC9yszulriWkMA/zBhhS+rMg3DhyWlFe+W7k=;
	b=KXtujlG2hWlQ+HCw3xDDABfIVJ9yCiEtImQfjLLo1bMoWVvm/Ia5OBbP/3YlONAeDmOcCA
	4lFa1hGnq0HrG5g3Al7fxSlDtv6AbsR4LBfUhNgNHcJsWFWtJOXh6AGf3D+R1xkuHX+Rg2
	nas8sADJtvFcrkHnQwqVfi34UbS9ksU=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-xwsy1GmtPjG_fhEaPFscmw-1; Tue, 28 Oct 2025 22:47:40 -0400
X-MC-Unique: xwsy1GmtPjG_fhEaPFscmw-1
X-Mimecast-MFC-AGG-ID: xwsy1GmtPjG_fhEaPFscmw_1761706060
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-63e37c94219so1051699d50.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:47:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761706059; x=1762310859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tV6geqkUC9yszulriWkMA/zBhhS+rMg3DhyWlFe+W7k=;
        b=HMT56S42oetduwvbnrvDumdzqbKKIixtCtIDs7hpdv3MvDxdj3D5gGUFXR1aYpOSpO
         0xZdxGavYs243E+DSqRcLExZHlxiy7YBfwcRFyg2ksuqiv1cwAwgJKeWPWHexdWVslhH
         c+jladCZqmVDFQq77iP/rP3Qk9R08ESmyxo7+vSjioHvmBN0XUw6JvaBqBujCOrWcNFm
         ZT+1Ee8GUa+vzikkC/R4S4dmozoskz9hrnDhr6+442Q/9bcNV2iyJ5822zOf5ZgEjfnm
         8jPBDcVQWlTLAEoGghI47XNNZmugz2de0MOPe2bug9upmA+nw0gv01Y/lB0w0aoT3bjd
         KHrg==
X-Forwarded-Encrypted: i=1; AJvYcCWXxjl/PRtM4L42UiYJgIToZI9G3H46Ll6MBomaJuIDHZ0mofZ8HGf9uVggOKlLxzEgho5u0ATtUQ==@kvack.org
X-Gm-Message-State: AOJu0YxH6fh3nXVfa8XIad05YFRb9aUMPsbrLhqmEEjtckrfMmWfPeYC
	8NPu36qK1ikG8rGBBrJrtwZQdBRcquTMeGLH2agDlVNLPNT0tZzBOBJf576+D2Ge+Txsuh1AWPy
	mqS4Oio3F/0icWr3JSJna2lZjq49X0b3ZhfqJZPuBrQEqDaRfB2nHQSdZOaTgrAaQrMQnQoYeA6
	ewCzgtMjATw2MVTkw7oq8vqMGMnCY=
X-Gm-Gg: ASbGncuoR+Ot+llloXM+wZfQYwLeEWD+6Lt5wMsPiJMu4/ZzxJRhevOwh4VVPycJCez
	lmt0pDkAOXY7qyzRxENjK2TGAZT4bg7nMUAjcpee8+zP+obLiSadXl3vTsIczD7PpiDkqGaLBEG
	wdJWxbA+oMpJngyv4hxc4MhLJjizdy/7lysenDVG+u/DHGLbHQCk+nOBMMum0kp56OGZyKoQ==
X-Received: by 2002:a05:690e:1405:b0:63c:f5a6:f308 with SMTP id 956f58d0204a3-63f6c6be3edmr4184094d50.31.1761706059373;
        Tue, 28 Oct 2025 19:47:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVsJq5W8R7sT70TPYovDlqz+rtyyBJ9vZ8itjbDB85MOT0ZftJAHwTGtjUh24PfkoVwi9hTpXPs7aXJ7Jzq6g=
X-Received: by 2002:a05:690e:1405:b0:63c:f5a6:f308 with SMTP id
 956f58d0204a3-63f6c6be3edmr4184060d50.31.1761706058849; Tue, 28 Oct 2025
 19:47:38 -0700 (PDT)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local> <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com> <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com> <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
In-Reply-To: <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Tue, 28 Oct 2025 20:47:12 -0600
X-Gm-Features: AWmQ_bnjuph0S2IHnCzLzLvJQtkBH9xEZPK558u1lNAN1P5WHxCGuxiWYNQMh8o
Message-ID: <CAA1CXcD1YDAbYzdYfchOWbmUasa3tN55AYroOLJb2EqoQfibvw@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wip6Z6eLHaaYfLwfoNlAbVYHa9azK5f-Sle7diFzpVo_1761706060
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6kn9czs43erab1c6e1jngcwdz3fm6864
X-Rspamd-Queue-Id: 445AE1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761706062-344955
X-HE-Meta: U2FsdGVkX19nYpDSOAvg531fxw50Z8wKwRENxjewLBxsMxuIVuoD/1+bBaW1HzaeSJLZPdUYPsAWSwGJ4WThA26iJWGKflajQ6aWZI+PSLlWpz2CnwTbutTF3PcIJZn/XWcTA5aIDKWbywnO3HNh5TK540iAr04OgheXGknQTa21tatdpLC59OxMr8wIWtkVv26SjQkz2GtjTRcisa7U2guHh0ju76hCV4+HNewsCNtXpr7E9wdpYai2eBNWQ/l1CNsE46btaa9/gMGsHDOYDvXzBh6dru2+MET1WiIhosoWRRKyJ9GsQQqRwA+HUAd6NBU2a9NQ0A0W7fiGkJ0hzwnevUbdmVonttcR8g3Hchx6DtnIeaCKiXMSxEc/2X6dXfsgOaVB7haC2W54r3JfUJ69sMP3ajrS+InNj13ZZDi+RJ9NtXxdPcV616qfMj4GsHh2jPG0BvA7KbKWpa0XgH7ltMt3Ksgx1n9UwEynbqQYlqfaygdIMcBdoB+Y17X21j0ADbjTokQSgJTwE6V2W2dQuMZ7DatYplc8psAR/dmrH9kCaTLjLRFxeR3ccbqBQurqouPKPFwlOgNLd8BImHDzzzvRdjS06JDuDGxvWNq42uuJ0Ue/Nc/2izB06ZFPFhto2rDEnjxG4NhbAgCA9QiI68Zv4mphr13oc7BafJNn7fACHcJ79E/r16TAP0gyfOB9keHVvWtxQnnS0iQycRcQMjoxsWvjO+U/sLcmjxt+aNxmVQ9eOsUQrWkWphWBYZZBZhHbjEEdQ2l07LBH6TbO0pEqeGMiNoURm1+BNv+aL7gTy4sHsrPnjWXWMFU8WNf+q5m4QjqqPKS8l/X+bKEz4ZSJAD/6e6MacNiaLZzSs26j9DE8MY8Vu23biJTIzfOQej4govzN+hcxecKCU+CVrPDpM8FfTARfLqQnVOu7W9CBKb7iAmeeD6eWAhTw/1mfyK/DB8z6NxtwZsa
 9Y3V2/XV
 oPn1zzZsRa5iyPwCqauTAxnyC+fVJhiKbC+fAo/dTVH+74rthF7nN+vA1D2KaObhPTqUJCe5/BBXdmmJmG8CEXovnUnImeSOQ6HlXCaXTDCa+mIFXG2QH5fpMhplivFj2ZFa4GRIo1sqUV4C/g3hkD/vvMN0t4uifwvWNN97FCLnVHFPQZffJKxlkQdyEgaSTXLfsP4hy+9qY+YABEwBxVOJwy9gmth2MAylQb1+C+jk453x5SxuYRuulFc8/mj4cSKhpj5JspwONX7PlpI7LVyn/LfieVHcBr6iCUzkyXuHjU34TBgqrt8SJ5f/0B07FUJ8PdD04CTU9u6iCcsAGmEGN6JLmoruhD/L9dq31+/acshXnc6n2yXLxGOQmMxwoLOzQUBDHPT4MGeMMeJbXrZ65Bu+BeXfAG541721+eU1HFmtaks2qDGTswxx3OeYZQ9Qj4xYQFDCvyVASSxAd/6wJYeFyZxZi3bLyoWwkG0ZFd39OtwEHMCqkCHd8O37DxZasdpaCbjNkx/A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 1:00=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Oct 28, 2025 at 07:08:38PM +0100, David Hildenbrand wrote:
> >
> > > > > Hey Lorenzo,
> > > > >
> > > > > > I mean not to beat a dead horse re: v11 commentary, but I thoug=
ht we were going
> > > > > > to implement David's idea re: the new 'eagerness' tunable, and =
again we're now just
> > > > > > implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
> > > > >
> > > > > I spoke to David and he said to continue forward with this series=
; the
> > > > > "eagerness" tunable will take some time, and may require further
> > > > > considerations/discussion.
> > > >
> > > > Right, after talking to Johannes it got clearer that what we envisi=
oned with
> > >
> > > I'm not sure that you meant to say go ahead with the series as-is wit=
h this
> > > silent capping?
> >
> > No, "go ahead" as in "let's find some way forward that works for all an=
d is
> > not too crazy".
>
> Right we clearly needed to discuss that further at the time but that's mo=
ot now,
> we're figuring it out now :)
>
> >
> > [...]
> >
> > > > "eagerness" would not be like swappiness, and we will really have t=
o be
> > > > careful here. I don't know yet when I will have time to look into t=
hat.
> > >
> > > I guess I missed this part of the converastion, what do you mean?
> >
> > Johannes raised issues with that on the list and afterwards we had an
> > offline discussion about some of the details and why something unpredic=
table
> > is not good.
>
> Could we get these details on-list so we can discuss them? This doesn't h=
ave to
> be urgent, but I would like to have a say in this or at least be part of =
the
> converastion please.
>
> >
> > >
> > > The whole concept is that we have a paramaeter whose value is _abstra=
cted_ and
> > > which we control what it means.
> > >
> > > I'm not sure exactly why that would now be problematic? The fundament=
al concept
> > > seems sound no? Last I remember of the conversation this was the case=
.
> >
> > The basic idea was to do something abstracted as swappiness. Turns out
> > "swappiness" is really something predictable, not something we can rand=
omly
> > change how it behaves under the hood.
> >
> > So we'd have to find something similar for "eagerness", and that's wher=
e it
> > stops being easy.
>
> I think we shouldn't be too stuck on
>
> >
> > >
> > > >
> > > > If we want to avoid the implicit capping, I think there are the fol=
lowing
> > > > possible approaches
> > > >
> > > > (1) Tolerate creep for now, maybe warning if the user configures it=
.
> > >
> > > I mean this seems a viable option if there is pressure to land this s=
eries
> > > before we have a viable uAPI for configuring this.
> > >
> > > A part of me thinks we shouldn't rush series in for that reason thoug=
h and
> > > should require that we have a proper control here.
> > >
> > > But I guess this approach is the least-worst as it leaves us with the=
 most
> > > options moving forwards.
> >
> > Yes. There is also the alternative of respecting only 0 / 511 for mTHP
> > collapse for now as discussed in the other thread.
>
> Yes I guess let's carry that on over there.
>
> I mean this is why I said it's better to try to keep things in one thread=
 :) but
> anyway, we've forked and can't be helped now.
>
> To be clear that was a criticism of - email development - not you.
>
> It's _extremely easy_ to have this happen because one thread naturally le=
ads to
> a broader discussion of a given topic, whereas another has questions from
> somebody else about the same topic, to which people reply and then... you=
 have a
> fork and it can't be helped.
>
> I guess I'm saying it'd be good if we could say 'ok let's move this to X'=
.
>
> But that's also broken in its own way, you can't stop people from replyin=
g in
> the other thread still and yeah. It's a limitation of this model :)
>
> >
> > >
> > > > (2) Avoid creep by counting zero-filled pages towards none_or_zero.
> > >
> > > Would this really make all that much difference?
> >
> > It solves the creep problem I think, but it's a bit nasty IMHO.
>
> Ah because you'd end up wtih a bunch of zeroed pages from the prior mTHP
> collapses, interesting...
>
> Scanning for that does seem a bit nasty though yes...
>
> >
> > >
> > > > (3) Have separate toggles for each THP size. Doesn't quite solve th=
e
> > > >      problem, only shifts it.
> > >
> > > Yeah I did wonder about this as an alternative solution. But of cours=
e it then
> > > makes it vague what the parent values means in respect of the individ=
ual levels,
> > > unless we have an 'inherit' mode there too (possible).
> > >
> > > It's going to be confusing though as max_ptes_none sits at the root k=
hugepaged/
> > > level and I don't think any other parameter from khugepaged/ is expos=
ed at
> > > individual page size levels.
> > >
> > > And of course doing this means we
> > >
> > > >
> > > > Anything else?
> > >
> > > Err... I mean I'm not sure if you missed it but I suggested an approa=
ch in the
> > > sub-thread - exposing mthp_max_ptes_none as a _READ-ONLY_ field at:
> > >
> > > /sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none
> > >
> > > Then we allow the capping, but simply document that we specify what t=
he capped
> > > value will be here for mTHP.
> >
> > I did not have time to read the details on that so far.
>
> OK. It is a bit nasty, yes. The idea is to find something that allows the
> capping to work.
>
> >
> > It would be one solution forward. I dislike it because I think the whol=
e
> > capping is an intermediate thing that can be (and likely must be, when
> > considering mTHP underused shrinking I think) solved in the future
> > differently. That's why I would prefer adding this only if there is no
> > other, simpler, way forward.
>
> Yes I agree that if we could avoid it it'd be great.
>
> Really I proposed this solution on the basis that we were somehow ok with=
 the
> capping.
>
> If we can avoid that'd be ideal as it reduces complexity and 'unexpected'
> behaviour.
>
> We'll clarify on the other thread, but the 511/0 was compelling to me bef=
ore as
> a simplification, and if we can have a straightforward model of how mTHP
> collapse across none/zero page PTEs behaves this is ideal.
>
> The only question is w.r.t. warnings etc. but we can handle details there=
.
>
> >
> > >
> > > That struck me as the simplest way of getting this series landed with=
out
> > > necessarily violating any future eagerness which:
> > >
> > > a. Must still support khugepaged/max_ptes_none - we aren't getting aw=
ay from
> > >     this, it's uAPI.
> > >
> > > b. Surely must want to do different things for mTHP in eagerness, so =
if we're
> > >     exposing some PTE value in max_ptes_none doing so in
> > >     khugepaged/mthp_max_ptes_none wouldn't be problematic (note again=
 - it's
> > >     readonly so unlike max_ptes_none we don't have to worry about the=
 other
> > >     direction).
> > >
> > > HOWEVER, eagerness might want want to change this behaviour per-mTHP =
size, in
> > > which case perhaps mthp_max_ptes_none would be problematic in that it=
 is some
> > > kind of average.
> > >
> > > Then again we could always revert to putting this parameter as in (3)=
 in that
> > > case, ugly but kinda viable.
> > >
> > > >
> > > > IIUC, creep is less of a problem when we have the underused shrinke=
r
> > > > enabled: whatever we over-allocated can (unless longterm-pinned etc=
) get
> > > > reclaimed again.
> > > >
> > > > So maybe having underused-shrinker support for mTHP as well would b=
e a
> > > > solution to tackle (1) later?
> > >
> > > How viable is this in the short term?
> >
> > I once started looking into it, but it will require quite some work, be=
cause
> > the lists will essentially include each and every (m)THP in the system =
...
> > so i think we will need some redesign.
>
> Ack.
>
> This aligns with non-0/511 settings being non-functional for mTHP atm any=
way.
>
> >
> > >
> > > Another possible solution:
> > >
> > > If mthp_max_ptes_none is not workable, we could have a toggle at, e.g=
.:
> > >
> > > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_cap_collapse_none
> > >
> > > As a simple boolean. If switched on then we document that it caps mTH=
P as
> > > per Nico's suggestion.
> > >
> > > That way we avoid the 'silent' issue I have with all this and it's an
> > > explicit setting.
> >
> > Right, but it's another toggle I wish we wouldn't need. We could of cou=
rse
> > also make it some compile-time option, but not sure if that's really an=
y
> > better.
> >
> > I'd hope we find an easy way forward that doesn't require new toggles, =
at
> > least for now ...
>
> Right, well I agree if we can make this 0/511 thing work, let's do that.

Ok, great, some consensus! I will go ahead with that solution.

Just to make sure we are all on the same page,

the max_ptes_none value will be treated as 0 for anything other than
PMD collapse, or in the case of 511. Or will the max_ptes_none only
work for mTHP collapse when it is 0.

static unsigned int collapse_max_ptes_none(unsigned int order, bool full_sc=
an)
{
unsigned int max_ptes_none;

/* ignore max_ptes_none limits */
if (full_scan)
return HPAGE_PMD_NR - 1;

if (order =3D=3D HPAGE_PMD_ORDER)
return khugepaged_max_ptes_none;

if (khugepaged_max_ptes_none !=3D HPAGE_PMD_NR - 1)
return 0;

return max_ptes_none >> (HPAGE_PMD_ORDER - order);
}

Here's the implementation for the first approach, looks like Baolin
was able to catch up and beat me to the other solution while I was
mulling over the thread lol

Cheers,
-- Nico


>
> Toggle are just 'least worst' workarounds on assumption of the need for c=
apping.
>
> >
> > --
> > Cheers
> >
> > David / dhildenb
> >
>
> Thanks, Lorenzo
>


