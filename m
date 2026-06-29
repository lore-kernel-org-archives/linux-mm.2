Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E55C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6436B0005; Mon, 29 Jun 2026 10:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086EA6B0088; Mon, 29 Jun 2026 10:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91B06B008A; Mon, 29 Jun 2026 10:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE5046B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:31:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CB9A4016A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:31:06 +0000 (UTC)
X-FDA: 84933187332.14.99AF30E
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 587F214000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:31:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hx41SWcz;
	spf=pass (imf23.hostedemail.com: domain of jackmanb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782743464;
	b=WH8jJAbcLRowiLy8IYY0uw/N9TEjaCZz9NB1RKZq87VNhbdnaq/e3HKT/Ne2Rit7KQjczm
	ftXm3N36blSQn3jtx0ltNes7pGnzh5LCUeITIIx44aYZaV3iOE8NfGdDdLO7edCFPwTJIH
	ZrftlnQ+oxshHUmU6TBNRFBObq/KZBg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782743464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnUpC3GuUlHFE5pSzflrbaIDrqRbSXDM/GZaCK/+qOU=;
	b=PaQOGU5hDFgfiznijB8nJzSE8Isz9BgexB/vF7jN68sxj3wjihBLbJPlt5+Pxk81oI3VW6
	Ztq/67sFM1dhGine4+3MhAv/1LQDO4VvSxLRFHMHbxRjUHfh7R0KHfpD3KR1bLCdO8fPr7
	SDeGTNOwGtpKsnKEHmI+bGPcIJDOb9s=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hx41SWcz;
	spf=pass (imf23.hostedemail.com: domain of jackmanb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6982f2dc01bso13200a12.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:31:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782743463; cv=none;
        d=google.com; s=arc-20260327;
        b=jPWjOTdsYkVyMUs+OYRvglGflFPD1JHGFP0lanhaVE2o9nPIclPqv9SOTixgYs+RdM
         aJPotIHdbrM5Q2iuhaZCAIfG4Un3Py/x3R5UkbZlfnAcyDkb9AmIsTGRe3yV9pJ07p5z
         MZoE1W0ahJD1on5AHn1j8zKyIiZHPGK+hAvdZ+HoYTNXk/c1x2TXy81sCfPEFWye2XbE
         FeaAS1vk+s5NdW839ALhrrQcNgF0Wy5lV8XqjXPNjnOzzSM60ToRjYq7tApRQZ2pPH2L
         vbw3aPNU6U6lJDL5QHBfqtnk98BYE0inknQzzDLkTs4iKErPa3SxwywD/Hg1aiYzR7H5
         OdOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HnUpC3GuUlHFE5pSzflrbaIDrqRbSXDM/GZaCK/+qOU=;
        fh=nBSL9eMFFsxnxtNgE+x49+z6/u7+2ZQMt6uF+eljra0=;
        b=ZxMW4ueEaK/oCNlxTdNY0zJ0MLGebhlRtLfj4ZlL6uTGdD+7RfaVo3RvKIZ0lXCATj
         P4eHgm/AzlRdtCVRKoSvr4GcIW+O1Z2yNTTJ+N+b4Hn2vWJC/MFYdIidEyIqjUeSUQie
         SE5ofWVsuDmYG/HwFrQPUt8KByt0267YQZqjXXZWBAH1ILR+FXoz7u4wy6KJ7BCIQcVs
         IuMZygFtoEqxzpqI8obckol7IvmbfPFyFRMitGH2mmDtFVLUFwGfzb47Cq880EQyymIn
         Vp7/WlnYvE40J7725P5o6OMdyFvyUIwhGcsiyan8Yo40StNbVEpczp4bpWL7FwdAMsdg
         feXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782743463; x=1783348263; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HnUpC3GuUlHFE5pSzflrbaIDrqRbSXDM/GZaCK/+qOU=;
        b=Hx41SWcz9NKiW0BVnM40tnMgoUc0n1CASSdAvTdoi7zuxO5f4k+50gwmdGTjE9JpgS
         cctgNM8V1sVOvHOhv5AkzNfotFYb3r2PLU8+oqZt87CSGMqxqFjcmjpS3++58uvhPlJY
         TAhA8gchOBRuwXfYEOuxovkiY/SXEmJG0MCyBee93Y2ctiwIVUDJrfW5dPmZ9msVCEBh
         13e8pqtE0TA7UlixPCDfV2tE8cAlgVxr6bvOjrbQF7viPMg2JTze04uJ1T/drggSfjtT
         o0znQBY8v9UoQY84i5/ENaWDdXKt0jY8PyCFp8RF11hWko7IJs2JhaToaGhaQ0RwQSEZ
         iV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782743463; x=1783348263;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HnUpC3GuUlHFE5pSzflrbaIDrqRbSXDM/GZaCK/+qOU=;
        b=nk6lm4OIwWSNo55puXRmco/Prh1QF4lFz8s3PQEodoPFMv3jSfk9pMvOh9oMjs7IB5
         v+NvRUh4h/TeEg//TguPhssEMYkl8nVElJMdjRbWWCdtskUunKmpm0LN+KynzLNl5pBc
         Z7YA1L+aoWIAdA1cek1JYMsMQbpxlKXjH0K7WIArEf/K//jDx2FgmI8PQNdB1OVojeau
         iYq2BIPdBxvwpOEENhOn7cTbgGy3xkT7FWOIB8gQoxJ372A56YKPxv7Eayh1aVuP5w/H
         IyP4gW9VUG22f8yL4VK0wEaiutxEAmIvDwbbeVcsAQRknZu6Vs0WqExewaQ5OLEzae0m
         LTNQ==
X-Forwarded-Encrypted: i=1; AHgh+RqwruuT7nl5NPS+Cou0J9PBkBnMVk6w65gf8GA4Lr0yRbmx6+UaMiO/RjP7uKKjR7yPP1IZstUK8Q==@kvack.org
X-Gm-Message-State: AOJu0YwjADm7qrwwWLUPnkbUU+lMQK0FbY+pjwpOxxO6g7ACD6aOKm1E
	RKUs6NnfLuHU1F7fCPVjQRsfnrdxdgfDWGk+TTZIUgia0iwSc9NKt3EAWWS3A8sW0dGdPLsBq3x
	IZmfIZxqkpbbo8A3S25Ewr3hqc6bJy+hzudwAZ/PO
X-Gm-Gg: AfdE7cnGXQDMic74mCT6c6JBj5jHGLA79jJNrGZ7fSUTNjUq5xxaAGpqoj/jAM5raVR
	w04bpqP20S3LSq2Hb50rdBbfNaxDQyaUo5mqDlJ5YhIpm+9+VaG6GZ8CImXpGjSjAeZ+ubP5zdN
	7m8PPbBPD36FChQhfu8Po4MGcoa2t6GMLUq9v68BuvEDw1t7ZT2an06FhSfO/TlbvOMt5fsWwl0
	CC2VUx/rPhoi9Yo+dtJttc8KLXMCmKHBOX9GGb+Bcu45DTB8Q3KOaAc1vcBiNoW8gpZ536UBA==
X-Received: by 2002:aa7:cfc3:0:b0:693:3e06:8f4d with SMTP id
 4fb4d7f45d1cf-6983f23c5a0mr91050a12.2.1782743462440; Mon, 29 Jun 2026
 07:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com> <akJ6Z2P8eMm1tc65@kernel.org>
In-Reply-To: <akJ6Z2P8eMm1tc65@kernel.org>
From: Brendan Jackman <jackmanb@google.com>
Date: Mon, 29 Jun 2026 16:30:51 +0200
X-Gm-Features: AVVi8Cc2-nXLSknBHksHveOm17x8Qt4efvzGWpwSODhQBj5we1EbHkogy0SyKrc
Message-ID: <CA+i-1C1CMgmPyqxT3dkLWVT34HqoPBi+0=GhF2rk2-wJSjSZng@mail.gmail.com>
Subject: Re: [PATCH v3 00/16] mm: Some cleanups for page allocator APIs
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Robin Holt <robinmholt@gmail.com>, Steve Wahl <steve.wahl@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dimitris Michailidis <dmichail@fungible.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: iuka167ipxrmzo5uidp8ih383c1d7g6z
X-Rspam-User: 
X-Rspamd-Queue-Id: 587F214000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1782743464-949393
X-HE-Meta: U2FsdGVkX1/XM4liL9AwvclRBoppel/eOqNkKlp7eIJyvo6+tI+/FdQPd3sJiObDyewBQFaYpqB/snTSSrliZ4aQLl0vf5m1LgQn02llYy1/NnyB/vB2dildiFCir3cteN4r2NhJcXiIlS23R77yQ02sCkEZYccKQLBJMCdXIo5W+4dXMrwk4zcEkAc++lacmuEl2pJexAq8TkVNvIIOrENSMTDxStQTmt4jed8oe0j89uYMZzspXwQf2h359NKeHMR9WJh53TWnH1kq4pkED+8sFqu7bMbKrxvpuTOxuV2QmBfgNQWYtX36aHOenWah4FFQ8jajIBqcPm+lPLMsQ/heH1w5C5OW2cZkbvwqcdf677WxOjwB3yhHGVxWlBJfW945BfrE4+3uCcq3aT0pglZUo4pLN3Yfe5kW4AS7krapcZwS4OMKsi3rzrgqRGYjUA3PHa41H+0/BDlwXB0FRhcf1XqrpJu8WvTHdoJ83Jbjx+aV5uethTQWUFYwdwF4bm+kieckHVCB0t9aW4K/a0/hwWFXEwPNOpF5Nx8vb7XSaFXTE3LdJvjNrnlg80hYReEHcGBFXiMdDbA1Qlp5hmnvdwLGzmPSgyOXbVTfn5NUj2ezfvar5v3g6PSN3aHFlOAiVsu5MABL2L+AzsxH/e1etH0HHzE0TOKvnNNBUKA6JoGqqZwZ7+rERpbNmZ6y9lHukDPD2eItsPqC88EFx/tzIjxyghv6Qe1BJolqIS2fk5MOMTtDFawoMVqyyFwN1Q8MPnK3CjrGy2pbjefNzAfrJmrZ0DSlALmYEXeluD3d6vUMTxGY3JDO5sqIwEUj4oiOXAUyv7uOnEpaEUJMdzvTi9K3Nst+F0c6/GU/zOR0uppuPzYMNTS49qKGPF2tNkHkpp17Baq7xTEzifmOdjQ4s+wMuxlBCHYItYlrPcxnqrISHelhtJdPoSq/gFqIbnklKd2aJYCaMgBNobj
 +1i+peM9
 tK5xGQbNxe/kab/RFXEjVuEKrtPgwbrY4basuUaTxinXSWXwr6kV5x1XvIaGPNeau06Zcje1QQ2BbBEJ37WWPEWxbytvitKgaxhJZjEwR4WeZW3GA16OZVfjis9jAwIPs2FwH7GqjtPELq5QT5ayZKL79bWst39zT7LMGONGKAIVj9czAoJaorTbZBPATsJN2V9CLTSxX7VpMPclQyYc2nhG5O0RMcMdGmc7Bky8V2vcOiDGDGAkSgBFjx3LVBhmiX5ZmS9MVO6eBk7EgYTlfm/QSHqOIi/ZldUWs3+r4IO4cDuKspk+oRoKb969kb5CFNqxtY/1fjnhKFOJifVos0b/XiEojtdiDGEHCxjlUhDNwdsgnfugSSI7eVepwiPmKoQE07PNmwGeeYvYkr3QLZdK6uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 at 16:00, Mike Rapoport <rppt@kernel.org> wrote:
>
> Hi Brendan,
>
> On Mon, Jun 29, 2026 at 01:11:49PM +0000, Brendan Jackman wrote:
> >
> > Some tweaks and cleanups for page allocator entrypoint and flags. This
> > is motivated by preparation for __GFP_UNMAPPED [1] (which will probably
> > become ALLOC_UNMAPPED in its next iteration), but all this is supposed
> > to be an improvement to the codebase in its own right: unifying code
> > paths, reducing API surface, and removing GFP flags.
> >
> > Tested:
> >
> > - KVM, mm, and BPF selftests in a QEMU VM
> >
> > - kunit.py on x86_64
> >
> > - For the ALLOC_NO_CODETAG bits I just booted a VM and read
> >   /proc/allocinfo. I confirmed that if I remove ALLOC_NO_CODETAG, the
> >   kernel crashes in early boot, so I was at least booting code that
> >   depends on this logic.
>
> Heads up before the full kbuild report:
>
> CI has tested the following submission:
> Status:     FAILURE
> Name:       [v3,00/16] mm: Some cleanups for page allocator APIs
> Patchwork:  https://patchwork.kernel.org/project/linux-mm/list/?series=1118244&state=*
> Matrix:     https://github.com/linux-mm/linux-mm/actions/runs/28375636866

Agh, thanks, I broke the build for CMA.

I thought I had this covered in my local test scripts. I will fix that
first then I'll send a fixup for the patch.

