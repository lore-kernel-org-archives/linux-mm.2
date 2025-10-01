Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB32CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 07:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CF18E001D; Wed,  1 Oct 2025 03:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3CF18E001C; Wed,  1 Oct 2025 03:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B618E001D; Wed,  1 Oct 2025 03:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA868E001C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 03:12:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 437BE16098D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:12:41 +0000 (UTC)
X-FDA: 83948677722.26.5EB7276
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 62AF2C000C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:12:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3+YqPqit;
	spf=pass (imf28.hostedemail.com: domain of jackmanb@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759302759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2HSfqYJ1d1CTnDukXhgKX6m4nuO8rCoGcHf7t25Q3o=;
	b=h+Y7jX5D80eFAeDQ7yIyWIdGhtJ+m8qPhY74pEZJTzrJrZ+RN0zS/Nq1NJtCc2pcbszJvf
	+4b0YfzPRrQQQLrguyedoHFmRWED1pjKHm66/EjI/qdYfbPfp1ywbnOksRzpNCLUJkNvwF
	Zr+14wh+vBedALjeXsaNb/hXu3fR9Ng=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3+YqPqit;
	spf=pass (imf28.hostedemail.com: domain of jackmanb@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759302759; a=rsa-sha256;
	cv=none;
	b=hczJrrkFnFOrEOL4eK7NRwQvcZ+nZQVhiKPeiKcsGnv2QLvUJA8tcJQsBaLjuyCb872irA
	Lu3YDqoskxB+ZRQfPccRYqXwiYSiItwIU65ZF5fE80Z3rIYa5ZmXy4mcRIlD+aMA7vucTC
	CJU0gUVnctgGb+NaTGvoZB/F/xEzsKI=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2681645b7b6so84675ad.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 00:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759302758; x=1759907558; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L2HSfqYJ1d1CTnDukXhgKX6m4nuO8rCoGcHf7t25Q3o=;
        b=3+YqPqitmy2rRmWetyQoRG/4uzbQbX5B9CTY4/VOiqzhaVOHYPPVD7taQNjst1e/kj
         eEtJOHpsPWEXm+bQd9WDgFWscegre8TrUSzSyFz81XGMOFMR2VAuFCoj0pDoQocQ7vtS
         qBaWL9PQ5Ed5b0MG39kN5JRNQv89mWoiJZWZguljHdJl0aqZHyp3zJmVKL849OC/BMpI
         F/65PVkASiYphUmv4zs6hHAAoX58+F98rN7OkraZBNs84kjV6PRXd1Eh9QzHSaJx+kOB
         H5qC0O/yk8N/uq4aWd402DX3RtEMjm6AfJm/qoZc3A0+tF4D8iKkMnjylsOiaEhQcL+9
         hoMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759302758; x=1759907558;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L2HSfqYJ1d1CTnDukXhgKX6m4nuO8rCoGcHf7t25Q3o=;
        b=NHv+KjCJ0GfTlZZuIWTw+97DBlEGI61/1lweRfVuBH+YjQtChRU1t1eRIS6IpG5kw1
         GqJUKCQfarJ6ZRMq3JuiDG86iuZ7bQMwLEku1II+MtjtWxkptz9aVVwiUhslCd7jbRHg
         Rs/D8LBEk3x+NOYOQlsi7ym0w8pC7CESPGjVjVCL3yE4BS24o215yWBTeHXkqdi8pDF5
         m0Ol2qC1XF7+cWn/PBoyQ6jq6kpg83sfDfn6hwPboJKCP1XNCmMXqrYLmF6TE1aX/GQp
         SCv4uF0DZEJqeBcyUOQyq3KsfXhyMYr+19Q6xhhje9k0QUJylFsMxnWN/ptE/f9luSFr
         4OKA==
X-Forwarded-Encrypted: i=1; AJvYcCWtpSm3tOj/jebYmZQQxn2SwoR0Bxbe1x/XDIeot9kjj/XvJleoGgE3Oy+EwwV5bmR3jdAw13RGHQ==@kvack.org
X-Gm-Message-State: AOJu0YzvgE7ZIBrjwvq9ueQUTXStC7IZSuU/VEO0pPwYLTRqnJw/Zkh5
	vwkCKhpr3NHH5egXvXipwQGO6yJraEXX1WFuLw1AjSA+BI6q1qo9TViBT1fqc05IK1Hbnbj6g1P
	YLQhXtLYo3KfTBEQFoJ0GLjoCo4A5+Zx6CpxTkkzx
X-Gm-Gg: ASbGncu/O7t6VMqqHVUswT2qVB9ddxTGc1LYn7FWqKDOW7zuGePtPeVkXYuyk4vX9jL
	eTthVsdFNQ5jC5DT08306NJ4rLgEQ9Vb4+E4Yz8diPE9/xLnspipcStB6tdB6lZr7B/M8REM/fq
	+KpNcotRliElFQdNHXO/JGlh8AvQKiw6T/am3nIpo+8ToIPQHlbnjwSyF+AQf8iAPdEcc79Ir5X
	7KdeQ/0YT7A8ORH4GF8KecC3M1Grcc6hFxqXdOehGPMTrKPtUJzmxi5f8R4p/pXaVRtj169IKr3
	rA==
X-Google-Smtp-Source: AGHT+IFKqalmxPPvbMf8gFFBYBwD3PuLwLfacEpGwfmVbHR7x+xhXopvFQOtlxwKsWCLYK7vchRDPFO/yKXEXrAzbhw=
X-Received: by 2002:a17:903:144e:b0:248:f683:e980 with SMTP id
 d9443c01a7336-28e7fdd3e70mr3595135ad.2.1759302757663; Wed, 01 Oct 2025
 00:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com> <aNw0sNehEQTWVI29@char.us.oracle.com>
In-Reply-To: <aNw0sNehEQTWVI29@char.us.oracle.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Wed, 1 Oct 2025 09:12:25 +0200
X-Gm-Features: AS18NWAifHOvvZfxOYNmfg733w5HRL1kfD7yDfmp_AAQDacXW-pG953lY3cbh20
Message-ID: <CA+i-1C3ry07NdPFFS3m2-WoboffgPSrOASJ4pPvoF=cN8NxbBg@mail.gmail.com>
Subject: Re: [PATCH 00/21] mm: ASI direct map management
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org, bp@alien8.de, 
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de, 
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com, 
	junaids@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	reijiw@google.com, rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, 
	x86@kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 62AF2C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: tqbteaex57bpa3idbnjcf6o5by77wp7r
X-Rspam-User: 
X-HE-Tag: 1759302759-481468
X-HE-Meta: U2FsdGVkX18SbB2zxxSnr81f+bxrNfz+IoMR2PGD9u9EtJAmigyrexIKcwa450JmWgjgU3NAPKmuXKk6r7ARcqInkQvrVwKaZnYXmbMEAHAUPcCspB00193R0xc5cuZad4YvD+0oBqX/gP7gm5Hg2psKyIxwXwY4+ylfs0QzwVh7WsJe+Picv7JaQaY8fJ6ZL8VfipFLQ7ntv1NKOnyqhdxuxdvbH+lj3PsurKIZS+WYr8x7sMp+jV0k5ioPUlTQCScGQ1ETB/KDI6/8FM10/7FYZkakciKzao4STM0opWGXpDBxdvRRWG6WpLvbzbuMrYRbUTSYYXvgHCePjTap+3zVjCSSiWCHmB0+Tp13alsA6HMwXMS8harTDc5nWITHwxVSlMdvu9ssuPT8vzJ6Lbx6Qx1Q3QbB5mxulXpcX2QTf5NAqUSU8At8JIeCXssaBPAlhOwHGpqpq/d0enACXS+QXLaCfhKpQeLGT6MPRJ3TnUkawNtDE8yfXArC4onmh6Et8hxnPRozzKE38vP2/tkn3o5gmdMOXjlUA+urjZ7q5cxnOI5JWD4vLuN4vwHhgGgAoSn/Rmh/be4l6/1X3nwc3e9o4uZ/wVmg7HEk53ZCGM838XA6iEaHX9oofHjOYSh8XV3IFqAcVb/jspWDlUcSuXZk34yNwz2tOdQMxBMPEtZKTaY78ZM+bStf/xnaYWJxSUgug/Dwnvd3E73nvni9JELXxXTzLk61rJmav6PBpIoGmEP8Epv+Egr44TWZAIwioF+gq/Ab9ZLS6LfWek9cF+TRU3ZQ0VVma6KXDpMwGbYl/yf0CyhocnE1HjX2Gds4NsgoO37wFrh4D4P2SkzkX1y+ms5bmibkfqIafPwbw9JstE+WDqwlMQNrbXmWzgjxf2ZQhLpqdBxUhmW+5UrICeJHkz0urqk7y7swt4xh6wL6n4sWxXVPjCKKyT2OkqrKpsbF5lW2WNzeMhp
 OvTSsbM8
 6RQk8Z/KSUCadl8lKCSbqNI67lrbe+GIVyw/R1YNw3R06zVbcDWihT01mK6ROv/oGCHv5qnN14bG2+Do2EenJzIdnwJJVXrR1H3PsQzr33aYiwBKMVjFyuVMV2lYzbPlTTooX27FhN+Tfd3VLKWx1CNwBx6FRuKOVWeLlub1ZAGifOlgBNVca3r7JFVEigGkhmEm6iU6O2oQ01n4S/w6jBRBjEa51vB5wUkwBxNQNN0bgh109mgb25+b9B6pZS8bd/8gTWhtP5f0sexI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sept 2025 at 21:51, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> On Wed, Sep 24, 2025 at 02:59:35PM +0000, Brendan Jackman wrote:
> > As per [0] I think ASI is ready to start merging. This is the first
> > step. The scope of this series is: everything needed to set up the
> > direct map in the restricted address spaces.
>
> There looks to be a different approach taken by other folks to
> yank the guest pages from the hypervisor:
>
> https://lore.kernel.org/kvm/20250912091708.17502-1-roypat@amazon.co.uk/
>
> That looks to have a very similar end result with less changes?

Hey Konrad,

Yeah if you only care about the security boundary around VM guests,
and you're able to rework your hypervisor stack appropriately (I don't
know too much about this but presumably it's just a subset of what's
needed to support confidential computing usecases?), that approach
seems good to me.

But that isn't true for most of Linux's users. We still need to
support systems where there is a meaningful security boundary around
native processes. Also, unless I'm mistaken Patrick's approach will
always require changes to the VMM, I don't think the kernel can just
tell all users to go and make those changes.

Basically: I support that approach, it's a good idea. It just solves a
different set of problems. (I haven't thought about it carefully but I
guess it solves some problems that ASI doesn't, since I guess it
prevents some set of software exploits too, while ASI only helps with
HW vulns).

Cheers,
Brendan

