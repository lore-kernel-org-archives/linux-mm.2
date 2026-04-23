Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA30FDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4D36B0093; Thu, 23 Apr 2026 17:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175666B0096; Thu, 23 Apr 2026 17:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063FA6B0098; Thu, 23 Apr 2026 17:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E68A36B0093
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:58:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78024C20D0
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:58:56 +0000 (UTC)
X-FDA: 84691186272.29.43EF2CC
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6E298140002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:58:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=szRRclZP;
	spf=pass (imf23.hostedemail.com: domain of fmayle@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=fmayle@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776981534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbYF9ZG445gn8aa2Rfe2DrFqGQr7JCLV6XOA6mQVPOY=;
	b=zAetnfVYH27xHqU5fJoQJDXvANrDVc6lby10dvTlFj8Veizso8Ic1Uy23flKrSSOrkC5lA
	3ao3Zqek4ZNgDQxJW9hjqnBSyMahu/mNuoMTx+vFmMgBC62l2isi1N+r/wUy1FK6CD9RVZ
	2ftIswmAPzvoJOoJkIL8faLtna+qOwM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=szRRclZP;
	spf=pass (imf23.hostedemail.com: domain of fmayle@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=fmayle@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776981534; a=rsa-sha256;
	cv=pass;
	b=jTw3lnarpWexq7It82lSDjcTIImFT3TpQkSgA2Uw/b0od/Ab0JArdkUAE1IFJBL1N8XVkp
	oJCybSZixOs3xuCOekMvs/6r6RFINCgp/2pKhEzex0U4k1MNilnfCcA3355RieQxJPSRBJ
	+swMxD7vylxfq2bS8Pue97i1B7mqKpI=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1270f10a774so53983c88.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:58:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776981533; cv=none;
        d=google.com; s=arc-20240605;
        b=IZcSqZQMWzPvC8yrPeK4AygdM7nimU+6mY1IiL/CWK2psRVeGxTOYWeqeKgmCVuB+Z
         2bP9yU3DiWNQ0S40vy4S87NvEw8ZlP3QhX0KUF1C8Rj1ggfS7hKTxgISr0AHx8zI4SG4
         kOY7jZ2mb5KfqkUeN/56vYVEFCP8iCrjwMqOSXijX2iWi2JuWLiqsaUMicVMuOiXRIHo
         78/KXdMU1pC407ErzTbUILGrb9f9XEOLrSdQByamRsUGvfttlH2ukuoHieH3cKTh6gDv
         27wjgvy7ypVg4B7QnYgh6IVm6II4S2Bl5Bec714GyT3knX5kzOgbYg9QCMAO4gRWKMEC
         OTFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YbYF9ZG445gn8aa2Rfe2DrFqGQr7JCLV6XOA6mQVPOY=;
        fh=ZWAiEEmooQVExU55DNUQtbOU2VGV68k9KOuzbgIuS8I=;
        b=B8OgYmvOvyo/zluqPT0/jKhJd8uLLg/h8O0ivtbmltuFKxZsE1rSFjiLRW5WjAjovt
         eWvDb5hTGPblxDKPpS4ygRV1jyEu3HdxxmMpGg5R+uL0mOByjx/SrJ4KD8YdldFU7JYy
         QPmIbf6XjpE35/G84p/b5+qda6bH0I0oFK6tbiBROwawINssCOBRnQGXQNEbQhCGMDsi
         Ptchgvsx+WUmMq5nB8KYmLEy66R4Zib8c0iqHiVihGNLrwnmTKYDoAhsPpjzLEUEYB1Q
         AQlyVFq/jQWh9VA5okllkSm4LnIbm5gIGWtLT4EGY4g0+yD7QzF8pDWhrfoSdeRIq6As
         5BiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776981533; x=1777586333; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YbYF9ZG445gn8aa2Rfe2DrFqGQr7JCLV6XOA6mQVPOY=;
        b=szRRclZPnal5vFIY/ECvcJpJvpvp9iCP6GmOzXU/ZeO+ur+HgWwcO5YZLA5wF/LQZN
         0mwwvlp04VvtgqGs27KatrlzuL4kIKBdaZsKc8jwykJvoWJODjE5gDVBNKroMpQQrOXQ
         K/t40eg/khiy351y0TQcXAZFiRna87ashc94h9Mf+8qPTeQc+bA4xRiHtZvBPd8YAwB1
         O7QjIVndY/iGKm16/AbGgN5qpcMjlah+AduIxDI2xZgQHHukf4a/8q2nCppzACN5kpb4
         BhlLzV+6fP2qj2/UXlhZorbD2sl/5W6FRDoetu1riYz8wjjHvk1W3hwxcZSxdR8UQ5iX
         1lWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776981533; x=1777586333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YbYF9ZG445gn8aa2Rfe2DrFqGQr7JCLV6XOA6mQVPOY=;
        b=l3Hklgr7iFZ1QnFIOOBtltE2UJoQetG2YLR5JX9s1ZE0EtVZR0IRxNUnE5TRIJ8LgE
         GSxPMOKwW7s8f9jZWiNwA3DgdtyB0+J0EOItVuaiDeS8bSkjtqw35gHK92d1gVxEabpk
         RB28H2h0x0y9TQA8dISiDqoL8j3iu25iFLWV1jP1musyVmbTPX8ncbKVks7KLBPMTQgI
         QP8gXmE4i/7oHgA5WDfqiQ8s7TeAYvBTmtlv70dBWC6mwRnMsATUU5lin0w8ie4ZvB0F
         zjmpEqvyu+Kq56GrpfivhBeN7ena2qojbRDFJdNIZSUJpDSi4jT4cC6J9i/5sjnqtgRP
         9C3w==
X-Forwarded-Encrypted: i=1; AFNElJ9kA00s4IrcZaLbVv4JgUjsiHSVwK4F7XNlSUVFCmv52MTs74hqWYGwp8Ci2nFTusQXTqtO/hcqmg==@kvack.org
X-Gm-Message-State: AOJu0YxabxHuxcORVt6EOE2uKT+Q77ZrH7phVd6UqfR1UNpT2aUY9j6l
	C3aXMev6mK0VdlmD5FeACsBwiecua1NAo9ZTkCGuZm9MeLvp4Lrg8usekk63knM/AkTiMREiv0o
	/8Y9K2S1Sqk0qsZDkLUi2OSmRwKQmQVZ+sxmFXEmK
X-Gm-Gg: AeBDiesCzTDRs24dIO9kRRWlIv6sROOJbLEQIYhaJMOKNOF/daQzG+T+0JkPxk850YA
	0OiO7Ks47oyPPYeiD8ylf+uvzUAgj8lQN0iguUll87KZoYSnelU8iiFH+DVbzx713Tnmg55T/Uh
	cKXYbJkIafnfeCEmxOMmWoEwaAj4JECYXHwS6OKKgoZ2wW3POcIEEGzqS+QW7P0wqli6qI5UQn9
	WSOmU1Q6NKxp64HDPfzZ95JNp9hnOz/F+YFmwQIFZjqF6Dvb9rSoCXya7sKQqkND6HAYJBQAfsa
	PJOdBqjm0q5e4wOfq33IAgA41xTR4voHZEsZZoW17wsLPDf0PiJczdWnb9d3N/xFpCnqPw==
X-Received: by 2002:a05:7022:4396:b0:12a:b39a:31da with SMTP id
 a92af1059eb24-12c7ab5879bmr1020973c88.16.1776981531942; Thu, 23 Apr 2026
 14:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260422005608.342028-1-fmayle@google.com> <cxthb6g7tqgluwicuh7xc75i2bp27hjlrx3oreionu4duknk32@x4tmnklhvkfz>
In-Reply-To: <cxthb6g7tqgluwicuh7xc75i2bp27hjlrx3oreionu4duknk32@x4tmnklhvkfz>
From: Frederick Mayle <fmayle@google.com>
Date: Thu, 23 Apr 2026 14:58:40 -0700
X-Gm-Features: AQROBzAgJMo_Hhy1amk3Qek_Bw09oB2dffxAYeLAqOYckcRkm-f1GTxyRcN8b7c
Message-ID: <CAHCxdc47qCEpEWtmq6dbeWiz3X5CP996zFmKNUXKX07YWjefkA@mail.gmail.com>
Subject: Re: [PATCH] mm: limit filemap_fault readahead to VMA boundaries
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, android-mm@google.com, 
	kernel-team@android.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6E298140002
X-Stat-Signature: yd9g4fbow5gyfthe9ck1hgzrb6zq5nr3
X-Rspam-User: 
X-HE-Tag: 1776981534-760180
X-HE-Meta: U2FsdGVkX19jGaNUWJg9gf+WcKzH28Do0Fo0P2HC7U9X+PP90stjzZUQqNICAXl5dXATnivaKxZhiET9nsmx815njLzx0nRca3Rxds+xpGCOves29YJiCUim+Q0GgcF+IqBMTI0+cg4GgYC1YAA/74dQw/1Xint93//bt1nEUoz2IWwIkJ4LUwl79r4KhTpz0gLyaxXLv7URPUlCRa8DVDF3eSjWSB7QUq3WFXwVR1rCNo+O/cxVBI7/hpBwlTdzRtq8HKX2jddpprUX5qpUYT3xTmMxOmAjlW1u27t/d5mByjpg+J8ID67UyO6CLJhxMRy13XcM/lM5LH614D8ic6ond+XxcH7zerQEiT5579ANpHnLt0wD9m9J8Vfj419XdGw5r0nKKUV5ZeGisOpxPp29ba3QmE2hOaI+uqFOmTyQcUoob8fsle+yA+T0GLPCBxzta79TzirlC6gHfLe6fR05S3BFPdoKBdrjEDpYM0DHpY/cKTYtHKWpIvdV9MjG6H+GOt7rYrjvNyRlwcUmxtZ3/AQm4gBQixE9XfG6zXnhw6HY9XZKdbIpIOYdJQqncbBo8qs1HQthYw+EyUTkpNsw5oDE7b6xRcIdEPt5yEDhnNrvbt6JZf6oT7WR+RwnO6ql3iq3ihr+K9NO3IuOYNnk86F6ogNC0qNP2l47QPDMTpd+c2ox6l/px6NLSmMOYxDCLq2IGzE0lOb0UbsJkVQ4m0qnJyC4ZKAT8mtgZ9kWuujBIL73XSXc0HyLS4TkGfRhLZGjLxkIr1i3TaA7crjVzUodHNE+T8qZ9c4RebacgPZnQTP8kw/hV+TsDOAHAMT+pafCUVfbMpmXp4pAxq0FZ3ED3mP7ldFKUxh09N6fx+qfZsIdZWpqDpgjDTtt5VZa/SCy1IT94E6fAOFKAlvyD83e5/JCzirzCvd2N7I9lR0tCqm6ydgNvjhC4TNkKIB/zuwizsMboQUekDm
 vQWYzQWF
 hYXw8cUxc4VSmRD+XO1DWOtB29L627n3mWNI1f0OW31Wup5Tk2xStgdubmVXF36/W3dHize26Rt6RJiiW2frSLBc6iMLZXopYjyFUyXa5EdRC/XogXGU8lia+0WJDqrunQmpDzYoRZ+l8drF7j/k4vTmVuCROK3sCdINnIGiBZGBJCtQRWgrMIIpKVEzHzWfe+eI/MPgmzRSmBc56qFyMzzKrpNLPOoQVUC3cfwdURDUDLKlwvkmpJ+RL8JPtDIw1Fo4YImGN+xYB/fVlpihoqwozFDZs/8e1uEcGExMTTfLL45W5S3O5NOIk4iDMvcEAMp93jb7s+JmbUKdFtR+y5Gv0lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 6:32=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Tue, Apr 21, 2026 at 05:56:07PM -0700, Frederick Mayle wrote:
> > When a file mapping covers a strict subset of a file, an access to the
> > mapping can trigger readahead of file pages outside the mapped region.
> > Readahead is meant to prefetch pages likely to be accessed soon, but
> > these pages aren't accessible via the same means, so it fair to say we
> > don't have a good indicator they'll be accessed soon. Take an ELF file
> > for example: An access to the end of a program's read-only segment isn'=
t
> > a sign that nearby file contents will be accessed next (they are likely
> > to be mapped discontiguously, or not at all). The pressure from loading
> > these pages into the cache can evict more useful pages.
> >
> > To improve the behavior, make three changes:
> >
> > * Introduce a new readahead_control option, max_index, as a hard limit
> >   on the readahead. The existing file_ra_state->size can't be used as a
> >   limit, it is more of a hint and can be increased by various
> >   heuristics.
> > * Set readahead_control->max_index to the end of the VMA in all of the
> >   readahead paths that can be triggered from a fault on a file mapping
> >   (both "sync" and "async" readahead).
> > * Limit the read-around range start to the VMA's start.
> >
> > Note that these changes only affect readahead triggered in the context
> > of a fault, they do not affect readahead triggered by read syscalls. If
> > a user mixes the two types of accesses, the behavior is expected to be
> > the following: if a fault causes readahead and places a PG_readahead
> > marker and then a read(2) syscall hits the PG_readahead marker, the
> > resulting async readahead *will not* be limited to the VMA end.
> > Conversely, if a read(2) syscall places a PG_readahead marker and then =
a
> > fault hits the marker, the async readahead *will* be limited to the VMA
> > end.
> >
> > There is an edge case that the above motivation glosses over: A single
> > file mapping might be backed by multiple VMAs. For example, a whole fil=
e
> > could be mapped RW, then part of the mapping made RO using mprotect.
> > This patch would hurt performance of a sequential read of such a
> > mapping, the degree depending on how fragmented the VMAs are. A usage
> > pattern like that is likely rare and already suffering from sub-optimal
> > performance because, e.g., the fragmented VMAs limit the fault-around,
> > so each VMA boundary in a sequential read would cause a minor fault.
> > Still, this would make it worse. See a previous discussion of this topi=
c
> > at [1].
> >
> > Tested by mapping and reading a small subset of a large file, then usin=
g
> > the cachestat syscall to verify the number of cached pages didn't excee=
d
> > the mapping size.
> >
> > In practical scenarios, the effect depends on the specific file and
> > usage. Sometimes there is no effect at all, but, for some ELF files in
> > Android, we see ~20% fewer pages pull into the cache.
>
> Didn't Android have a gigantically modified RA window? Could this be why
> you're seeing such large effects? Or is this no longer the case?

On the device I used to test this, the relevant storage device had a readah=
ead
size of 128kb. In general, it can be configured by device OEMs, so perhaps =
some
devices in the ecosystem have giant RA windows.

Android binaries can have a lot of padding and sometimes unrelated APK sect=
ions
adjacent in the same file (see https://lwn.net/Articles/1016860/). Those ma=
y be
the source of the effect, but I haven't verified.

AppImage files have some similarities. They are an ELF files that include a
mountable filesystem. Here is a quick test I ran on Debian with the latest
neovim appimage (./cachestat is a binary that simply invokes the cachestat
syscall on a file):

    echo 3 >/proc/sys/vm/drop_caches && \
        ./cachestat ~/nvim-linux-x86_64.appimage && \
        ~/nvim-linux-x86_64.appimage -es >/dev/null && \
        ./cachestat ~/nvim-linux-x86_64.appimage

This patch reduces nr_cache from 4134 to 2131.


>
> --
> Pedro

