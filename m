Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6431C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1EF6B0099; Tue, 11 Aug 2026 15:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E791B6B009B; Tue, 11 Aug 2026 15:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EE76B009D; Tue, 11 Aug 2026 15:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B338E6B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:39:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43067801EB
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:39:52 +0000 (UTC)
X-FDA: 85090003824.05.689B0FF
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5122AC0008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:39:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ECLCC+Ct;
	spf=pass (imf28.hostedemail.com: domain of jannh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786477190;
	b=ar/PwWGVd69ETn/Ll2msbTcMqWEod6iBg70RqC1CFY0O0DOdj/q956W2haM1oiCgtaROQ/
	RiNu5Q2nUKfVFpTTdZvHc4Wye+VGLg12kUxI88PEpPGZE0i+0J8OfBP0Ql+4RJkoYUa7wN
	9tErw1INyV457OTdWLKpCCy57IZ7vZ0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ECLCC+Ct;
	spf=pass (imf28.hostedemail.com: domain of jannh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786477190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UuIwl6rqjNT2GK6MHDUeAAQX29Svi83Q77R51FpwQc=;
	b=OJxFLEHjzkKLW5QxXgDnDxq8dfOWV/YBDuuczMs/5c5yNLSV7miT5osXPxcXm0r78FOlHJ
	k2MIu/kuzt13oTYrZqpTnu08jKhb6AQBYNgDHNm/5O+YQxAl+dXEa+iB48DNC3IAFzea4O
	dPbs94/AzFz9b6O2gpvdnx/kKTlEEx4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cab97c86bdso485ad.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:39:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786477189; cv=none;
        d=google.com; s=arc-20260327;
        b=UT5idjImWHe4Sq8Epa32xyovx1Z9iJM3fW4yUmLMZ7RHvADpXWKlTGp8Moba9933tK
         q+YBY0ggHdzB4RVXYGQoc1LPG6YELS5XNWFVMvBqFa0hstPf8QMoKt7lvlG5UdHilwbP
         X1aTCYV2nallmbPfvERe/oFODcOn38ZkcCNYqAht0X2owpmFvkRpbYjoB5P7gHg36/cI
         bJJKH0eGE5uj1kgQV9lpBvLr3kolzJtvgA+iG813HXh7VaWWTmkhqnt+7XhB24Ef5KEd
         FxUIhYvWmZa/2ouagKyXronc6TBKX26tHAkVDNt0IT62i7MwhR32DAoGeF7wOybDji48
         5CpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4UuIwl6rqjNT2GK6MHDUeAAQX29Svi83Q77R51FpwQc=;
        fh=ewc3lVRSpsF0uuSl5ZyL8GWlPpIBnfuyBShjMoK2pZo=;
        b=AzdCcKPQrkrucE55uhwSFEXn7G3XtuwTSondzvhRwr8/TaoQLcaV1fJksodEdE0acC
         XeOuwpgjbV+gDesMOxCQtrJrB/Zf//PgW0jRJWo9Un1++lNFLU7GKxAd1i+m6zQyUWMr
         nlweML/UwTJ5ssl6PLzUMy8PSmZ0jFPy63kIAT7HNHVjq+5RLMZ8AUZOHwJVjsfW7r3Y
         a38YR3smNT6MJJ9qDSmYVvl3HSLfvZIlTgtb+YuVUKdMbsWd6AK3/Q52PzvTT+dmCfES
         8LZ/MLyzZLSU0vGoJza8o8syPsMdbaZr1j1/LR2B/hegbqMzN9+Vot7uF6F6Jl03LvT2
         9xNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786477189; x=1787081989; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4UuIwl6rqjNT2GK6MHDUeAAQX29Svi83Q77R51FpwQc=;
        b=ECLCC+CtjwXCG6yrIs/H0BnXzNZDxVKIBfNFwAORSWlJkZolvgZLvQ7w0+46wlp0Q9
         8NSrL5zUQMmzW94lmAxgLKMI0ggL7j4vxqr6+kEfE93WLq17ohGvCtToWASPK6Kf9rbG
         o6iHDiTGyfBx/6nM+I1+xM6esE5Rjg5+a7mm2yoLhxR53tVLMyIAUpLH8QR3pmcP9aML
         U6Lb9kwvdz8Tb8G4X/eAiIGDPQOlI49SmS2q88/gb0dGkYHuQcoiDooY9N7U23+Fz3nT
         pjXKpFbiHKL+Kit8OHht+UAHFoNytZO9b9NxLS/0y3DaaIG1epos+2J4U7+FUerLoW9m
         EKNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786477189; x=1787081989;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4UuIwl6rqjNT2GK6MHDUeAAQX29Svi83Q77R51FpwQc=;
        b=ouufr18gV522F4uO80d47QxsbA764eOqNVfdbek+ISofeA7a0VX1vNWe5RkwRggtig
         lOyCWe6+RSio0G+1KhEnbNixEouI84Waq1LVVA7asvT2nn6+RAMvKB4Z7GLckXyDU5/2
         mqNNHzfLzFwxxXoq0i/X3rlSAVuDWNNymetchHNBOxss5u+o6kGxtW+o78okWt1lAX46
         tzGz1xSWoDhyZjmXIANQ7b4ruNmsSfNRE7lIs+CRO0dBcJqCpuPXKhQwYr4UwPvke/9n
         GHl86fhhMMPM1aZY63tJTXZ/dvqT708pXMQpBU5w4nUg81Hy/0w/y1MdQQs+vl1uZodU
         2/uw==
X-Forwarded-Encrypted: i=1; AHgh+RoAz/2NFddKWj7kz/a6wyivFd026fgJYW7Xq4jC+BU1HwLrctOCc81wtDGDq8Ag1yRFpRZOxuiwcQ==@kvack.org
X-Gm-Message-State: AOJu0YwpB18hkM2doGbUNOzUSGmWWQmSd0eMBco+aVc2eeWMq3CFgNly
	uVCBwSAL8xPnzpcCFzqEBOEz/FKGLPZvt+/VsS2wJT/KBLlJFqnLe1cesPJRMc+oZB8wx+EB5Yy
	0vYPgir28Ep13Z9TpZQSwawEd8fYPmodZfklGZLDA
X-Gm-Gg: AR+sD13hJSbxdtpi9rp+7+AJw81PE6Mhvor+oxt9enXScej1otKmAVYPcM3QGax/Q5i
	RtpkWVK1eAWmBPTTsiviqcuJ5rcqKqiTwLhum7KbwtoI5Zu569ZNA4n6tZswKmZoWvv4R9KLDz1
	y0J7tbZzQgqN4L10u2LS0cyPocUeFcuwhRSaY3p+8rfQk7d7yNuF43m5vDVIZPipakmoOGsWivK
	qqdZ5L2NcKcF3nMBKUht639OehoZX5zHGSwkrE8TokW5wdpg+4im/+TlGA3adXIkuK5062N4eqC
	WFrTyKJ7QNOKDRqeMDQiHCVCxoBxwoBDNR3GZvVqqXck5tQ3kBqgC01woso1NndMMaESeTCfXrx
	I//v0K9sU7inMy56yRdWUn3qF+W9J1N4=
X-Received: by 2002:a17:903:3e24:b0:2d0:1aaf:daec with SMTP id
 d9443c01a7336-2d33a9bb8b9mr1376625ad.9.1786477188642; Tue, 11 Aug 2026
 12:39:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org> <CAG48ez3QwUopEyfB0tEc84A57g3GZdnptazJW+htiTi2e0Gc=A@mail.gmail.com>
In-Reply-To: <CAG48ez3QwUopEyfB0tEc84A57g3GZdnptazJW+htiTi2e0Gc=A@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 11 Aug 2026 21:39:12 +0200
X-Gm-Features: AUfX_myNWbh_52Kb4nyJ3nHpbMubkiK4TzA6UuwI2EkOKm05z8EIDPP_R-GhG1w
Message-ID: <CAG48ez0Ty5GTR_vYazWsWOigWP2=8SYstw13zaiJB3auBi1bcw@mail.gmail.com>
Subject: Re: [PATCH 00/11] coredump: allow to create sparse coredumps on the
 coredump socket
To: Christian Brauner <brauner@kernel.org>
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5122AC0008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: mswujgi8xai8txajecrinedqrjqj1p1x
X-HE-Tag: 1786477190-292962
X-HE-Meta: U2FsdGVkX1+KIPI9uCS+bPeT/rtlKgIPtgxM+rQOIKfjz44VXabH21rafL0D6ymzTmCAJUDiWR/JOMwIr7KksmWusZMbRHBweKSAixP0sV61msCej/7Uh9d+5mfkm6TieY+bSHoQheYw5rK6a5VF0dDN5ofX+WFnHsBKuuF91s/6aHBjmtBSKZLAmBzIa6xFsbolJ7775CPwC7/caKwIvnqSrFM+HGth3sILwc8IXNId4gOmpUCGCI9EH0T8r1NQWgwE5YkO+Lmewtb+LZcxDcM+Gk/0WFd9qvR1DoEiv5J2OFMxxtPGQNdxf6NBFDvMwjF/yKJkXMniMidNvI63xjBDPXI/fRP1H+qLw/+VtdQ+mCas55b5XxZ7SoTWlEnc1/wVVQ+vcHrqeQez2h7BtYj5acd3OoO9iNwKM6+6oE822WTYCbQguJFRzM+EUFC4VwL5mYRX7vhfcm+N3MlL/ubOkvlPJouucIxomQ+AYDsjMWCjS2qamqUr4Zh5DbUQZNZ2LIPP34kEwaPPMMehOvgE8GM+/NN57kXdDknhCnrKKk0SoFd/dMkVNGYZ6qcIJK4CLPeR++pua+rLjuUMox6/wAlOMIVo84bVtXzbo0Ji4B5ThRKETBTyno7TkKhcw6z0KjHdZTOD9LSy7RMr/rTj5dmuLs69YnG1lWNfGxpESiPFtFk7Ruwvue72rOVXWuovq/GA1DXE9sq+DDldF1bkzVzBGPGxrIi9cv8GcdTLyoftBrPVr070vswZ2yUgFhx785tBbbxdxUvOZSHeE+ZvGJG7GQb/6mzhZ//rnLra8AnlsYaamV4CBHzDOmz7W7XtcT825Cg5jwImDTKGCFllMxK9Vw9o/+QvAPMMudr24coc+uVgvJz4SKgdQ7Wy9Jm6e+YK+tZbdMMGPonn12E9yl1pSaCSdyAowN6o3iLi//PnreMdt3a8h+CxSzEUGg3ZEmNWxFKBIaQ08a0
 xHeFkpir
 Vq0oBGnS1ZZEtqAlp64Tj0E87LmcS/zty3xFxKdwoPxDvh7qS23T/PzewnE/qDV62DOD0TkvFPqfxjZ4MtdK8SiBBuKu1xlFCcx+h1HTtpr2ltfOBY5lZEejCbAOu1u8Lw7EjqH7sz/78VxLvTOsnjHSkxRXRnAC27Qd+pk2geOAzemHJrpbkuxtBe6bLQJlDDOhDz9X8JBFJURc9FDpRLH2OONQIIMt1rY85NwEix5G5t1eH9T8O3HCaNhoaWdCPPLZQVqMmLAKtqin1lz64U4PCWNlmPNzVzP47
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 9:07=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
> On Tue, Aug 11, 2026 at 5:27=E2=80=AFPM Christian Brauner <brauner@kernel=
.org> wrote:
> > A server that raises COREDUMP_HEADER in coredump_ack->mask doesn't get
> > the coredump as a plain byte stream but as a sequence of frames. Each
> > one a struct coredump_frame_header followed by what it describes. A dat=
a
> > frame carries its bytes. If a server also raises COREDUMP_SPARSE, zero
> > frames are sent for unpopulated mappings. They only indicate how many
> > zero bytes need to be written and to not include data. Reassembling the
> > frames gives back the same coredump. A debugger and everything else
> > still see an ordinary core file and nothing outside the coredump server
> > has to learn anything.
>
> Hmm...
>
> I think what you're doing is probably the easiest way to do this in
> practice. I guess some design alternatives would be:
>
> 1. (overengineered, not generically useful enough): If the transport
> was a pipe (which already has the concept of different types of pipe
> buffers) instead of a unix domain socket, we could introduce a special
> representation for zero-filled pipe buffers and some API for receiving
> zeroed holes through lseek(pipefd, 0, SEEK_DATA), but that's probably
> not sufficiently useful for stuff other than core dumping to be worth
> the effort.
> 2. (somewhat overengineered) With some refactoring, we could maybe do
> something like /proc/kcore and create a seekable virtual coredump file
> that we send over the socket via SCM_RIGHTS?
> 3. We could leave the userspace memory dump out of the core dump data,
> and let userspace take care of filling out the memory contents using
> /proc/$pid/pagemap and /proc/$pid/mem? That would also avoid task
> switches and SKB allocations, and probably reduce the number of data
> copies involved in this by 1.

I also wonder what userspace actually does with this data - does
userspace just want to write it to disk, potentially after compressing
it? Or does userspace actually do some fancy parsing of the data
stream to extract stack memory or something like that? Or does
userspace buffer the whole thing into RAM and then process it from
there (it kinda looks like systemd tries to do that but I might be
reading this wrong)?

Anyway, I've looked through your code and it does look fine to me.

