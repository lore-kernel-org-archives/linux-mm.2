Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ACECCD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 01:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86DD86B0088; Wed, 13 May 2026 21:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EDC6B008A; Wed, 13 May 2026 21:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D386B008C; Wed, 13 May 2026 21:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 61F576B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:49:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F33E11C1034
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:49:14 +0000 (UTC)
X-FDA: 84764342628.07.DF830DA
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0BC3AC0002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:49:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fdsd0SaI;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778723353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMNfACDhJ3G0JKOCj9Pol48hY/nga61lHeNgsRWpW8A=;
	b=r7TjilWR1dTz7+no7hKZ0zi3c743OkCUBaKR6viJ8np8RZ6rzXynMoUf6Bi9Rqq+hUIb5C
	wlfG99G3mzgSzNdyZxGYikqdX6HDZVu+0Z4b/huFxkp4LdkkG1RkcSe1rJCTXSORNdrbe/
	Ycuwv96zRY53oJhVbYz756N20gVJcK8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778723353; a=rsa-sha256;
	cv=pass;
	b=U+iTOwBvdZQhkdjwlpfJTEcnA6+Uaw1n6BsDp82WP5Kt7L6H0Tu+JMsJG6MgQe17zMiW0+
	YmnXFlovuGjUGbd9oSEp32ATd8z3BMMMyktnK7MAHEoN0W3buJ24Iv2g89Laa6FX/Q3QvY
	/sglTXVUXP/GpRIdeddU1Zx+knZISp0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fdsd0SaI;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50e61648f10so166361cf.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 18:49:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778723352; cv=none;
        d=google.com; s=arc-20240605;
        b=jl26s5Cs8yQIhhkXpwm2NvsHUn+++MBwep9xhorl/D4dLZgdh0Jts7dz/DRM51vyP8
         lbP1FigBCvvtQ85qacvacC05y4t8OlG0w1nSNuFIPGBN68EPreZUWsT6VoFMclcmP3Wd
         YjkOrpb0nYqtMu2YzkMf15o/mLEtjlaVvCr3xwJK1CsDwBKnDDAslRYc0Kqq+YqQjDO5
         27ngyhPS9UXKMFT6GDePTQKNwFwQAng+k1C8GuMalAzYqz7ljS5CUFcKqArQz4ttJOVF
         0a5ifKetCR2qKaCkxBLIfUmBlviHC16PU1TWJ/FOPSGGJKErc94KqrcgC3E6j2oaIZt8
         XkdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MMNfACDhJ3G0JKOCj9Pol48hY/nga61lHeNgsRWpW8A=;
        fh=FEPTzkbWOABQtHIxY5TjtoQjwYEq2E9hYj1zp+7jjnY=;
        b=YgHbh3sx+asDb02JvBGY3zIlgeXdcO/af8FwCfB1HHSEe/dmAOhKQbn3kSQTb7vNsk
         TCWG5cvxMpDx4sSaV0ONGUk57pzfq2xlZ53UigP0j6GPa6UvOY6dmArOfvsAeA++t+AO
         izHsYXMz71uDHtN1XjwM89EACmAqk6nRA2JHx84am7BIYiAQDU+wgxVRPTxHkAWE5S+2
         ZFRlbi4zCdtoPfrFubJhlbVWJCoHMHwV+WvLjXEArg7N+BTHEH2MGvxp1sDsNyHeVM3l
         DUnsOmpdsUaXRG3srxxOz7b9uO10MkH9osqIw/+qvYITyMzAfKZ86M17DWXiqNVdiud9
         D0xA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778723352; x=1779328152; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MMNfACDhJ3G0JKOCj9Pol48hY/nga61lHeNgsRWpW8A=;
        b=fdsd0SaIV3z1orK2wU2upyS2LnyOFgZAacLhHsbEfLTRLOndDuQCazce5ojD+vVkCx
         xxR2A+FuvwiK0ouSzI6AVx71XUPzoiJiJCqErA9+7KkZq5tc+36KJbRi+f3H0HkSbmkT
         Y4jnP0Mfk7pVvvhinQcuQqeen+nI4nkZHwGp3cEyRFz0dy0fP9M4SJGa8mN6PSHgk3Bw
         26Rm2933ibN/fFIdZZtNFaMm8Qdbe/73xQimegCB0y3Xxc5dXSvXIIn62LtnBJyvH3Ud
         cFe7hFElOL2t80H3K53Ra+cb9RCGOt7pQVm7qu+M85CKGSve0DoW5B2N9SswEokiPT1J
         I0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778723352; x=1779328152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MMNfACDhJ3G0JKOCj9Pol48hY/nga61lHeNgsRWpW8A=;
        b=c5jpYfolaO3Mnuzj9wQI99TYcQrr7GaOV7TKEFog6GJvJJDNCSIQBGTh9ak+mA2eQu
         gSecT/htgtSBBaxgiMWR9KnjpdOYdhm4+t9s7jdnXNtfGWBUlK3vyQZpK6WcyM0OxWIY
         L+l/WMaVgwNK1RpBC0amwfaKpcu3qOKZe9u44wluAF9m4CcveoAj25l8cBHXz4CJjyfj
         mNWhvk2/6I8gbiu5gzvcW6Pth/CC1HCNBPhX2UvB7kuwpI3tPzxfHHH6nYFNnCvGNrBF
         Z8ajE9A48hUbW9gi9BH/NmVb5phT/hZkvw1cc5xfTWZo+vFPuikB/fs64brSjIIyCzDy
         7EKQ==
X-Forwarded-Encrypted: i=1; AFNElJ+M+qfDhKSK3Fu7dd8iq/w1R+zE2oJ6AP9Fi5ETTt6/hjLh4ZdWterTtVujRqKbO2wNt4N5TCtXwA==@kvack.org
X-Gm-Message-State: AOJu0YyEzYlm9z12NvfNo2rCwB7lo9cYdJ+9JaudpYmr6VE1tqtrXVk+
	nSBTAmG0K+vPJJtnZ0BqJMXgkWrWcGhAroLJIz7dbi3tdKh+mOjJCEStLXC9IdEqlwDmTFxGkKZ
	WW9qL7bVI9luGYo53TAOcKwjN+e7RKfTLvXuu8ltO
X-Gm-Gg: Acq92OGZiD5R3oPo6A8iSU8HcTuOcpEjTckL+oOqYoFchlGbBqzOIvXTNrzEpgkMr+r
	31V6Jd52R1jhX8recr2uLilYXFMAGUuxFj20wI2ivLb40N4xU/+FYxbCO7E82Eb51cvAv3Mepc6
	/OqMxb2penXkMmTmXE2adKTc3zQdYwZcxsPQNfLGMGjVCYzcR5EHk1tyxlxyRavYEhBQbvgdZ4r
	m1t3ptALg/fuvvonVFpSrdOa2ZfDnSdNcQreVrqbFxTOREU9B7GuZqvAG8jgg4RiVZS0J2H/uH/
	3/LVi4odXRWUZ68q
X-Received: by 2002:a05:622a:9007:b0:50e:6360:96e with SMTP id
 d75a77b69052e-516420a4ecdmr8299231cf.0.1778723351474; Wed, 13 May 2026
 18:49:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429182005.00BF70D8@davehans-spike.ostc.intel.com> <a46738ebd632ff046bc9b0d02a5382de5f2e9f2e.camel@intel.com>
 <7a82a652-f861-4d72-8bd7-4e082af482f2@intel.com> <af5Iqr7oLukvdJVJ@lucifer>
In-Reply-To: <af5Iqr7oLukvdJVJ@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 13 May 2026 18:49:00 -0700
X-Gm-Features: AVHnY4J_iQUsAwPSx7NfT1GTdm0E4TCNtQfe0F7fLyQ129z0IhlwddHxMGDZzSk
Message-ID: <CAJuCfpGJgwE1zVYZC4t_Gr76P=UTUYi2ESr4mbhTw_NbyQS+jg@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast path
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0BC3AC0002
X-Rspam-User: 
X-Stat-Signature: 39exceys7yjnw9uxs73gdm9fdcfystap
X-HE-Tag: 1778723352-341645
X-HE-Meta: U2FsdGVkX1+/icbOv4BEEqTyAuYMEhwYMzgKeUd29NSUJpURyc2lZhO+LiRObQxC5X5vTLQ+AYbETBIwOzHAThoBfjezHsXWlpV10OsrMv0RUahHDf4WCvno59Weuy0SAYts7AyVFu2kJLucqLr1LoHeazDljJSaof6Bf7DD8gZSUpqCogzFf2M0xod1L3ET6qiZcKPjZM1oKd31a9dnBbgBS0MIOxwz0+A8icdbgpYNn4R11RxAYjF0Q0UgniroC6ksdF5QJrKHt+FXKdD4ftDfWgEcPGcaZwadaPFjVqtdG6hSaThOW6ZqUSoprLdGsGi+E3hvCUhU51q9e3cIFp0dXydMpczu3Lm4HfJqYhtVjikOSGlzFQdhT9pXc8TG6Hia7SACY/NmMh0y7NUOtFHY3uxjA3m65Yc10U9FLWRqdaHiWxmzG3gauXj2QJg1+OY6nE20QrLm/cRpBLoRrCCDSQGEB1QNueZKVF9PGpVn9RhV2isDuNNJFSoPbPlPTvW0Uj0FxtH66hkQZwAXwajTAf3UKUxBbEUh0sGObMRJoYc3gY7rwVBZipmTBS942sIAaZX+wlNuxGDSERVjoc1EyNMbRT6YwJlnYIaBoX02jvuahHO8k2Ct9JrrZQYHQCubDAkRn01nlcKBS+LdKFDWYPfJIIazRv8fIiZkMAoEHsPnxTdOD+4eOyQWpl41aRgSbdsu1JPzjfMOrER83DV1FCWFsotQDotOLf2oeD3rAdqyn2Xo/2Fog6/yIqm+oEmCtF6v72dkFOXv4y+/kV5CQgMAkBdr8yPq8aVoCBe0hhTRp3+P8iB4p350jHru72gynLpfVolKuwWxV00B5MZGz3RP5eW0Xp4CY4hB/L4L3X/+uYoQIH3Dzq59TI7zvnfFhoELQQyzF+FmdrqbWoq0FuvYfZHCGpH5LAbD5uI8ck24Mzd8dYhYT8uFXhatXqU/ipN8XoaSh85fnQY
 eiSHWjO1
 dtrOgL+GrNHlK+n0zuInXWfv2uL15m1E1KlvsZcw2PM7yLFOTq4ujJSDlGW98y5VXJ6pYn530DXX1YSYBAd1aii+/Zc2uv5fGdq3iAPvTAU45RZ4SrqNzbIjhDfk72OSYfI8wbjDLy5p9dxPd9U7QR2QJSvWZNvJtFtDIPC69D2piNR4l9jD+Dg2aya+t8K8Ruk3LXD+Gvv8qZQPO0mV3N191ZGAlo/TfccuPV0EvtTAa+pTD71JODWZPPDJHVB354rdQ9S0Hg2bZ6l++T1bGM1+T85KNmmV3wWmr4tG2P48vB47aSmrJk0mT4mv5uWYuDmqD6pFN/c60AIQgpUAx0x6FZCOao1/LPUsvK+HDZcgMlNrp8v41haztyFT0BK5mKIu42AVAD0O3TBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 1:39=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> On Tue, May 05, 2026 at 09:39:09AM -0700, Dave Hansen wrote:
> > On 5/4/26 16:15, Edgecombe, Rick P wrote:
> > >
> > > I guess the problem is the lock ordering. Not sure if there is any sl=
ow path
> > > avoidance details that could make this splat a false positive. But ho=
w about
> > > this simpler munmap() case:
> > >
> > > Shadow stack signal                          munmap()
> > > -------------------                          --------
> > > vma_start_read() (VM_SHADOW_STACK check)
> > >                                              mmap_write_lock()
> > > mmap_read_lock() (user fault) <- deadlock
> > >                                              vma_start_write() <-dead=
lock
> >
> > It's a little more complicated than that in practice, but I think you'r=
e
> > right.
> >
> > I'm not sure when this would happen in practice because the fault is
> > actually on the VMA that's being held for read. So I think another
> > writer would have had to sneak in there and zap the VMA.
>
> Honestly I think any work around is just going to be more complicated tha=
n the
> existing code, which sort of defeats the purpose of the series.
>
> There's not really a way to speculate with a VMA seqnum because you'd hav=
e to be
> able to observe its vma->vm_lock_seq and to do that you'd have to find it=
 again
> immediately afterwards and then you'd looked up twice, got the lock twice=
 only
> to confirm its the same damn thing :)
>
> The issue is that a page fault on the same thread is always going to risk=
 an
> mmap read lock being taken (possibly due to I/O waiting and fault retry f=
or
> one). And faults/zaps are inherently racey and neither acquire the write =
lock so
> the read lock doesn't preclude them.
>
> And you can't realy disable page faults because you're potentially relyin=
g on
> them to populate what you're touching...
>
> Also there's some tricky stuff done on initial stack initialisation that =
can
> cause a headache as well (when stack is set up), see relocate_vma_down() =
to make
> life more painful.
>
> So I think the existing code is simpler.

+1

>
> It doesn't mean it isn't still useful to move towards having VMA locks
> everywhere though :) unless Suren or others can find a flaw with that...

Nope, I'm all in for the rest of the series.

>
> >
> > The funny thing is that the fault handler is really just trying to find
> > the VMA. The thing causing the fault *has* the VMA. So it's as simple a=
s
> > just passing the VMA down into the fault handler, right? How hard could
> > it be? ;)
> >
> > There are still games to play, but they all involve dropping locks and
> > retrying, like:
> >
> > retry:
> >       vma =3D lock_vma_under_rcu()
> >       // muck with VMA
> >       pagefault_disable() // avoid deadlock
> >       ret =3D copy_from_user()
> >       pagefault_enable()
> >       vma_end_read();
> >
> >       if (!ret)
> >               return SUCCESS;
> >
> >       mmap_read_lock()
> >       vma =3D vma_lookup()
> >       mmap_read_unlock() // avoid deadlock before touching userspace
> >       // check for valid VMA to avoid looping when there is no VMA
> >       if (!vma)
> >               return -ERRNO;
> >
> >       // uh oh, slow path, something faulted
> >       get_user_pages()??
> >       //or
> >       copy_from_user() without the VMA??
> >
> >       goto retry;
> >
> >
> > This also needs some very careful thought, but something like this
> > should work, where we avoid fault handling (and lock taking) in the
> > actual #PF and do it in a context where the VMA lock is held:
> >
> >       vma =3D lock_vma_under_rcu();
> >       pagefault_disable() // avoid deadlock
> >
> >       while (1) {
> >               ret =3D copy_from_user()
> >               if (!ret)
> >                       break;
> >               handle_mm_fault(vma, address, FAULT_FLAG_VMA_LOCK...);
> >       };
> >
> >       pagefault_enable()
> >       vma_end_read();
> >
> > That's effectively just short-circuiting the #PF code which does the:
> >
> >         vma =3D lock_vma_under_rcu(mm, address);
> >       ...
> >         fault =3D handle_mm_fault(vma, address, ... FAULT_FLAG_VMA_LOCK=
)
> >
> > sequence _itself_.

