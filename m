Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3182CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 06:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A8994000D; Fri, 19 Sep 2025 02:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371DD940009; Fri, 19 Sep 2025 02:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF5794000D; Fri, 19 Sep 2025 02:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1BE940009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:49:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0983C0585
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:49:21 +0000 (UTC)
X-FDA: 83905073322.05.1EE5C53
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id C45C520008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:49:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qGzgnZWW;
	spf=pass (imf03.hostedemail.com: domain of jasonmiu@google.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758264559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8ChdVFL3VbJv1RwXe37ElFR0o5xJ4LIb9+Ne1LI908=;
	b=ryd3OU2fZhEXSVzgDqwZj/eHZR16+YSY0cBgAsOmpoOXXGyLVINIUwqz4t4hakISQ7Ejmj
	RCrWK0r8uxpbiLysBZhLsBuDthCRPGEUQ3iZ3Hfk2wyEEc3KfO+oB3KFCyIdVvxT7k7I6S
	P68ujyKQoUZkZ57xlEGAweyrQbes+1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758264559; a=rsa-sha256;
	cv=none;
	b=Hl3f0etJ9y0iM/YkFvJopK5vgJdidUBC/Pgcnw7Ru3OPba+WjcuDiHSQ5iKsHGSAbJZmrc
	+srvDsPDXxYpCjlV5aYDqvaq9pAV+kZ1xkW1HsyBky3Bp2wPDJQShZXBB7Of0jC1OgbSKx
	LgwYx1NHy2FrefamONQhYu/eEu/DzFk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qGzgnZWW;
	spf=pass (imf03.hostedemail.com: domain of jasonmiu@google.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-544ad727e87so1351501e0c.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758264559; x=1758869359; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8ChdVFL3VbJv1RwXe37ElFR0o5xJ4LIb9+Ne1LI908=;
        b=qGzgnZWWLz/q8/tM5RvGkqis3HVvaEQLMxc4TB8/eT+BB+Quy/ul95zM0c4BnaXO6E
         H+5mzzd56SqdINqUQA6WYCEr8zD5Ybgc++fhfdWQa2WNB/RWXhdoX++0GHJYy+vceze9
         4nydFLwxqp6191uqOKR0L5pXTkd42wltlhAC90eHr3ysGaBUiZMz+7+gwVmBpp4ugr3p
         9JBSRj6lD5t6XEbwWuHNE9GP9sZ19e1BNSqO/4gJiMWnHY0DZ+S6QPicJISNncKG7xju
         RHjxrqeaQ25s+YchshYPwV7ML8eKhOtoNna6eLQiG2MoH0UkawptlSYDn1M0y3NLNxtv
         YWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758264559; x=1758869359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z8ChdVFL3VbJv1RwXe37ElFR0o5xJ4LIb9+Ne1LI908=;
        b=esykeYhuLH2xeHW8ElOJIEB4R98Qp47p/ZqkNAMp0AnonTm62MA2C6oJPAiwvSeexp
         NYAww0kJWY9+TQBnZc/+b5p38KFBI//kn7ZrzrrduISy1PfAiDms04D8UcBAsWHDXb2T
         3DxSqxX722Xjj7a6/f2LEmTWiyI87stOHVXHTDovjUcxYbKIP8/yG/h0EBoD/LlFRvGM
         iLRM0C7sOD2VBg5osHJHgmJ4NSxl0Nq9I1bgBSVrdyjqLtL/yag50/qL9+TtkzjEaBco
         61fDQHDTrVJsXL1wq/opm8Sn4TjHIJ/M9Ry7qpOM2TtnoTpcwtH9u6BkOlLQyIaOW6mt
         /mng==
X-Forwarded-Encrypted: i=1; AJvYcCXf/KRFwhxyi3SuDBP8WlZqhlCgwJl5qu98lB1IE/kHOCrujiSA3jXopA0cGCuFdqx+DjXS/maM7w==@kvack.org
X-Gm-Message-State: AOJu0Yzwc7O2C4OveOFoxPEhp0Twj2En4Mv/7qJH0YOc9a34YPAdayrD
	096ETsX8givdHDhIBS0ck+ZodoOEt/99c181lqTqaWYfiRR3aqd48lJFP7AeiXSTzSue7XpimuG
	YOJyMHUG1yMGi8NcVwSx+85XtzZa6lfvfrHGhblQQ
X-Gm-Gg: ASbGnctniXQ/KoIUdhl9ZFadNTO7U7VzMPci0mFrHMaG2meyYqib1YLrovZPCkTL13/
	jS4twAc7Eyj+4KZAdmHuYWI6aZAvxYB/AuYnzSZ9B5ODRh2AcQRRSqfvxjKTL1KlGFiB4KeaY6j
	KJ93IJO2lPp9zQO5v5bnXpJVyEAGhMJDv3AZ5zXWLs6zrOrBBPz1HBt5/hDTWg9CR7f8u9itdiT
	qF3IvQhx4+qcbMCzW2cOHahC2wQHPbyV/OzKikffD6aJG2L
X-Google-Smtp-Source: AGHT+IFVsk862c6jBLBQHlKlwevYkZVfUWmmFw+NQU42kXUhgZ2xtmh0tS9iCTXHJ7q0fDyvegsZslZdHcK2rLPpIvA=
X-Received: by 2002:a05:6122:2a05:b0:530:5308:42ec with SMTP id
 71dfb90a1353d-54a837e6887mr813853e0c.8.1758264558514; Thu, 18 Sep 2025
 23:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250917025019.1585041-1-jasonmiu@google.com> <20250917025019.1585041-2-jasonmiu@google.com>
 <20250917122158.GC1086830@nvidia.com> <CA+CK2bBbSSyCDAAgThDSSwH0WdOeHz-eVgB-1bdiwsDtTSE5pg@mail.gmail.com>
 <20250917163200.GC1391379@nvidia.com>
In-Reply-To: <20250917163200.GC1391379@nvidia.com>
From: Jason Miu <jasonmiu@google.com>
Date: Thu, 18 Sep 2025 23:49:06 -0700
X-Gm-Features: AS18NWCRC_XaURHfJJfME-M0Ey0ObAUOEvcdAIB2Bzvin5AUuRN7ltMM3UG48RQ
Message-ID: <CAHN2nPK+Z5cvQ_waTWyPZiEoeSc9o7e3YnQLLjRzNzrb7VhAqQ@mail.gmail.com>
Subject: Re: [RFC v1 1/4] kho: Introduce KHO page table data structures
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Changyuan Lyu <changyuanl@google.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Joel Granados <joel.granados@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	Mike Rapoport <rppt@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Steven Chen <chenste@linux.microsoft.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zfsnh43fazt4txin1sc5tyixntajzcjb
X-Rspam-User: 
X-Rspamd-Queue-Id: C45C520008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758264559-373082
X-HE-Meta: U2FsdGVkX18Uy56qSz5MFuQmB4e9cWhrA/PeqmAxrlbGkQxVborXDK5nj586s9u6ozGWZuoRTEiDHI43kDMB40nuxw018kJlUfYcSiH3ZDhivqQONDbVM5DxzOHjid52YNQpKdqtWHpccFP6a+CQ362BfRrCAA8GMJpptmf/nFGZm5Ydv4nBI7YC3l2T4xhUPlExne9UAs+yVhyXQZoIfF29hRqvOEjO3Oc406YBWhRdvLHBCxwYVNw+rRFaThA9wMdnxhULrWQ9gCoZ85vHf5uzPGNfjCtI3J4/uEjZ3JAk3C8BRw2BOAIY6TJnay+ioX/WrMzzV+nQLYC/G7xLpZ59Kd6ja1QdjtTBwOt12JEx7Lzs25izy5FAk3aRJClrykP4qzA43txzG4B5NU07zaHUfVEK35YyFcgdA49K7eytrjMRGkZBs8itJqKG7Mk9z7MgHWZ9TchhLSw9qnzGvWcSKW33WtH0R9D8wX/cFj8BOdPe+q0C+oDHU6Me2OyFJpmhi2tWORl6d1XgTAyEutOUSnuojIENgyMHqzf48HggKY44nLTZIQuSNzyTEqSA/0a9WKIO9qOLWwWrLr7JinByw6M87ESv0nGIoVu22XkPKeledfxzMUuYOiuhYVFNPQXJrgxurWl8T7mCiPKCI1D660ES5qlXIrjyzegN8BYnrtwlFODbml1BMswWAS1Sp1ViMbxiMAMuTg9Wn6kkONPI4CBNKi7GO64OhzsqLTsp0JjIVIbjMQuqkJit/blKAoUpx+J3DXL3ZUVe8lLr6IhN1kK4kuA17UVIUqyJDWAzX+v3/wmnzBNktKIomgVvqYCiFw1ZnEI/BB/cx2HOb+cLPNxoxngxXOYqPLUYN0Du6LVvDtbfgA7Zjr38imBP6wU5oxggBWW9R7VoZEQY9q8y4cY4CwYrYWfrin7dNlUXQoUYjzu8VQTK4yR59lv5kmSQo4v28V980labfge
 0VbBlXlD
 jTeAXDLTDCtxn/9HVmBQYgtPMPoW0qrw4/R9MqnirubcGoCnOW3HOrTr5wmgNnPo2dxL62mjK1uJlFUCMeOWL0sS+TkVqWqtikXbIKOjGRSUHV+WDGlxc9ABJIAC7CKHZQk3yUyMR2cl0fhH5tNjco4qCyVQq+I/BAOnjMusnwQrNNUm7uJOr1VqgGDe2jOMngZpnQJN+coO+SdC5u5ZpbspjGoZ/Stqy5J5q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Wed, Sep 17, 2025 at 9:32=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Wed, Sep 17, 2025 at 12:18:39PM -0400, Pasha Tatashin wrote:
> > On Wed, Sep 17, 2025 at 8:22=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com=
> wrote:
> > >
> > > On Tue, Sep 16, 2025 at 07:50:16PM -0700, Jason Miu wrote:
> > > > + * kho_order_table
> > > > + * +-------------------------------+--------------------+
> > > > + * | 0 order| 1 order| 2 order ... | HUGETLB_PAGE_ORDER |
> > > > + * ++------------------------------+--------------------+
> > > > + *  |
> > > > + *  |
> > > > + *  v
> > > > + * ++------+
> > > > + * |  Lv6  | kho_page_table
> > > > + * ++------+
> > >
> > > I seem to remember suggesting this could be simplified without the
> > > special case 7h level table table for order.
> > >
> > > Encode the phys address as:
> > >
> > > (order << 51) | (phys >> (PAGE_SHIFT + order))
> >
> > Why 51 and not 52, this limits to 63bit address space, is it not?
>
> Yeah, might have got the math off
>
> > I like the idea, but I'm trying to find the benefits compared to the
> > current per-order tree approach.
>
> It is probably about half the code compared to what I see here because
> everything is agressively simplified.

Thank you very much for providing feedback to me, and I think this is
a very smart idea.

> > 3. It slightly complicates the logic in the new kernel. Instead of
> > simply iterating a known tree for a specific order, the boot-time
> > walker would need to reconstruct the per-order subtrees, and walk
> > them.
>
> The core walker just runs over a range, it is easy to compute the
> range.

I believe the "range" here refers to the specific portion of the tree
relevant to the `target_order` being restored, while the
`target_order` is the variable from 0 to MAX_PAGE_ORDER to be used in
the tree walk in the new kernel.

My current understanding of the walker for a given `target_order`:

  1. Find the `start_level` from the `target_order`. (for example,
target_order =3D 10, start_level =3D 4)
  2. The path from the root down to the level above `start_level` is
fixed (index 0 at each of these levels).
  3. At `start_level`, the index is also fixed, by (1 << (63 -
PAGE_SHIFT - order)) in a 9 bit slice.
  4. Then, for all levels *below* `order_level`, the walker iterates
through all 512 table entries, until the bitmap level.

so the "range" is the subtrees under the start_level, is my
understanding correct?

--
Jason Miu

