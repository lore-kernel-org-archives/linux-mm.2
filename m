Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4ECEFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5F86B008C; Mon, 27 Apr 2026 12:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE4F6B0092; Mon, 27 Apr 2026 12:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E42C6B0093; Mon, 27 Apr 2026 12:30:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2216B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:30:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E7B1120C37
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:23:14 +0000 (UTC)
X-FDA: 84704855508.26.17FCC46
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id EE5B41C001F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:23:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kmlXj2LU;
	spf=pass (imf21.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777306992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=206Fh4X3dDRStaXDm8n9sC400Cq7S/zIhUvs0OOCjSY=;
	b=qcgSmi3ObL5dmbwP7L3eweI5PRV1CgZMBYT8sn9RfOgUqZr2pzVQm90nU0XOm5WrkI0R+u
	WirkJF9l5UByqSyoemgFDLsEW1IcjRa6nL+aLSxwvfrMaGSScfjPm99vEyif52QP+EEcdE
	pYb16ck2YvBJ12BhV415KoW/xDB6pyg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777306992; a=rsa-sha256;
	cv=pass;
	b=PZ7XiDx+ALxYOD1G+7zYS74x7HbiQbGhuZzfWCSKplesXIzb5TMkPhZwqGKhNIEBVV/ZtL
	RApCN9HHTHLB3NCf8ZOsYW+ecvFmyESIVJjfMxpFdTZ7/X4M7QsyPOJfANXgEBqqjHarz6
	fgqdknz4qGyDR2jDSAvrcefC3igg2dI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kmlXj2LU;
	spf=pass (imf21.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso409065ad.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:23:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777306991; cv=none;
        d=google.com; s=arc-20240605;
        b=gupQ2dCZJ3b48Fve5HnIo6yudDCd/m65/YqCnwyJt2ffyvUcawNLRXNS4u/relDCKV
         JpwSzYyqDqieedWt0X5ot//8YLg+hbkRJvaeY/G1mMhCOeG+N+LZE7B5Zjdsc3ssNcAo
         MM7FXNpkJtRDwtMC8mVbTVcMLf8PjnR5/17VutolWQxe4n1yItcGe7IQvetHtr65h/W4
         ZLxtL0e2gveKzh2QnGQa754NS2qkFrn1ye1isTfe7zvGzk9zUWQtM8EeRjZ3OhzpjEN9
         xWO47pHTwumjYMCJq4XeR0enZcvSXW6ZP12Wc2QXT3uuBu0th+0saiaypliVqWTtVHzH
         Vdkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=206Fh4X3dDRStaXDm8n9sC400Cq7S/zIhUvs0OOCjSY=;
        fh=+TNE74Pa0FhkEdNgRCYTBL26OLVvlf4PaH0I/wEeBAo=;
        b=d6Prbh0W2Ds/5JNx7SRP1jRoaJekMqS6H90NjBAAlS2b3gOBlr4Bc4R9YkfjnkxyDG
         fepscTIiAFUausLMnTP/JTFGTutV/Rblpzij1X2FUxuF+w1/mkuyQNxSeH/BLrj7ZgDG
         0U+89P0RnoOEz21QOMx/7lngbMlqLeiWs/Acnirw9oFiGtvCkyXdW9qGB/fievivYFAE
         Qp8eZAFxGxf1Yl6uR53T/4DW2CSG6H7+oPgjRHB5D8FFcMCxw23PUdk3qPsG+2W3tl1t
         dYJPV1wvtBWWU0hnPH2kkyx9N8IXbFKsjXJNPWzoNEiEIbIavcSgPq32tx6KCmgxj0h3
         0wyg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777306991; x=1777911791; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=206Fh4X3dDRStaXDm8n9sC400Cq7S/zIhUvs0OOCjSY=;
        b=kmlXj2LUEnVFE9h6pSFRziojRTojFi3nvn0L37MCwNyP+/D38I5plsbwyxx9//LrCQ
         1tasJcFjDwOb/60fRXPXCW341FqMcegUxMp7guQd/PqaExwDVIdtzAOCNgChsHhPgONo
         7tVAweFHbKx4SZJdSn5QwN50feiPqF8Vpd+nvcqJkGiPG3QKlD6qVZBs8Tkj6GehimXu
         Fgz7Shjy2BXrCChi/JUfeG+4S04KqGg4Ph4TTLsTti8Rl02Eb/zUNunBcaFtBSxO9rvL
         azpH2U+uh4+OC+MufoZF3TN1L7KkVWkDQUg8TAERbsb3fWDTr0ZLrhLxtu39KYy/TRzw
         T4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777306991; x=1777911791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=206Fh4X3dDRStaXDm8n9sC400Cq7S/zIhUvs0OOCjSY=;
        b=SCb6MGKNA0IL7u+7W/7Tr89+7qwD/h8aC8A5T+HL6GxC7DEqy9oc4hVqKrBGvqULtf
         Q8vgqvn4jATH7BsMwr+ETMy8r+zBcL8NA84BqydzLrekkWM54GkOnt1qLLLw6r3eMClZ
         /ENuO8qEYHLbD7m3hiIJNnILtFpOUWChkCCzPbtLTuSt9RBYyDc9BLvE4rgPYtvBJE+V
         kO9orAA3ykaBt4UPq1x1WRlLqI1thZINkavMwIeboEGj8paIIV7jjl9wLa4loGCnKYRN
         8wUVgUti+aIoGv4Mnw8Z5I6YG2IqYZIa8B84YJXqt67KI2wVTAtdJBIfPZvPTmWOWHjP
         J1yw==
X-Forwarded-Encrypted: i=1; AFNElJ/5KUU7mPM98AcFuei+ucGJ4pVFXK7lVg8g/bWIgxc0x9de1+nusVqoF7FFnwGXVDgV+ouKfaQp3Q==@kvack.org
X-Gm-Message-State: AOJu0YyZ4ddKE1B5uX06sfWpvZjuZ/KkYGNIpUIQuNYLHl+CxnS/LQHe
	kcfo7Th3G8kRiXWrDGXGP+lv3PNcccMJ1ZLgXI5ghTamW3fzW7kI6OmvN9f6/vP7+2bY/2U/Q/0
	QqzrOJaNNhN/ppoy/TEH6k0gqzv/qgEpY5aPDV7dm
X-Gm-Gg: AeBDieuDEMZBXcZlh3Wo/AjRGe6KQ7coU7rU9dKk5WYTSmMDXsbXL+byHUf7G+ZvKOC
	/SYbZnoSvyYgXRyNoAyK7YPkCrimOMm8V2jhQxIINmdsutzniEwiP56FEasaAf1M+D5nF8HpN8K
	GfHk8FbSftssJBHr0G4LR/Wl3m6NNMBRRJIQpIshihRe2yOFWclZcIK17/rw03wVogfFTXqp5Iq
	zqwa4eWJktHQewan2pTwupk4vQQ3phYsOx3UMJARm2bkKI0PQvaJaoBZYHpjJaMm10MGPzuMIp0
	/7zrO2xNt3uunXkCxTnX1VUlchKpeGBa1omQxRRt/HQV3rbDz0tKMCgraQ==
X-Received: by 2002:a17:903:c05:b0:2b4:6529:7bae with SMTP id
 d9443c01a7336-2b97a4e7ca7mr51125ad.17.1777306989849; Mon, 27 Apr 2026
 09:23:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260427030148.653228-1-fmayle@google.com> <c7f94ce6-1dfb-420a-b073-d86abeff1f76@kernel.org>
In-Reply-To: <c7f94ce6-1dfb-420a-b073-d86abeff1f76@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 27 Apr 2026 09:22:57 -0700
X-Gm-Features: AVHnY4I1vyG5MhQpN8fAKqxOe-avfjBnum1jR3fQl3SDDHUoZnLZAP_N2GaXCNE
Message-ID: <CAC_TJvcM11got-LcMo24OTN8uXa01oVvUX6HmVvrWMJWVSgEzQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: limit filemap_fault readahead to VMA boundaries
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Frederick Mayle <fmayle@google.com>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, android-mm@google.com, 
	kernel-team@android.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EE5B41C001F
X-Rspam-User: 
X-Stat-Signature: 9mm6dpdttjy6tkqscnp9hrnwmyeg1zns
X-HE-Tag: 1777306991-958336
X-HE-Meta: U2FsdGVkX1/OW1o5Q6jonxxqBEPhrZF0RirZ4xo9xSzA1KjEERqn9gZDifHO6FlfihtHRhFGvFGx2tdTTiPGeEm1w2SOuJcjiEIq0FSs3thPkO5+6uDjRlAdaHfscBNA+9PM9Q97EwjwVPsLbDEAkzX5RvXYRYqUtZKg2US03XITVmNje7LC9BwExscdjTWd7rmYffDeUzR33dMo89sgXUfDVttj8wNElDoBzfwfPBdojJS+OgrMk0CnW27MgwatX1LMgkQ2z1Wu5ZCrCzQfWzHkmwiDNBTNRXTN9X6N6eEB0zqpyKrmoe0spBn5/qS9FZ594yDADGqjNOt8ZKXjVGNfcZbytRRn5OYWnS3PXWpgbGJPjshjoTjc/aAxfYdPQ8pkKO2I+6oE/8j3UqMGqBrR0avwDDDamDvHdSckrvuDphYC3+O/O2YTe+wzPdn8+EocSAw0AoXA3k8pu9sNkMUDXQcpiOodSC6NSo+XsTgPf/iK0EGCcIm1EqcBvcpjRzifkPSkZgsrXAoxSjq123A3NgPXPUZC66B+7vTvOWtgf3uNQvR7Vlyv6stfBdJmn2iNXZ91e573Z5kuqcEFxtGb/pPRLbBG/4gFf75twTAO7jrb2JINliHAKlSTzfYK3MuLwwlDzuAKn9qaEHT3CZIiQqBezYvBnhAtR13pGPCxiAAvT67l+VgvNHF6Gq28M5+DhQMzTS8zNbfvVK4T4fDTXFDHY33jQ+tLVkSCQy0yMukve7cubdjzZzs/7COVt+5QVOoqL8uqlbcYlgeFu1UgZbWef4pfoK33nj6+tPT7SIzVQCL8Z3mLdPZi5Vrve3Y1yb2F9NkhB04lFfD5guXjPgPPeRdUeSWzTECs1KN4xDG7f87LNAl0EUrt2RdE/YFtaSXfKD4Rv4Q9gnh4kP6xmD3D029ly/KZGMqSbeQfxXI6b8zME6WqqORtiOmoErH6EejIU1lg0QEM8fZ
 sqxozzGY
 6BDKso2b3yhocyotuGc2Il7w2PP8K8Q2mhF6YjwnXuXbLa59dAeM9y5lXY4XC50+ecudE+kBe2UVQpgYOhWYZiLNLoNilGLV/Vk1PX+nB6wJs39wEWXNzN3/bsqaOrJOlbX04ktagx/d5TffO7Wk69TE7lcpHpsS3rf34J7BsXOwA253zLe6752E0lhph0xR6IuU+tFUkwXiH5XPjGotExgQNCVKP2RYbmRqKLXKmjDh0nFCTWeJT9o7jsgN9YCbb/pQ70HwsBfdh0WLgTjN+xfPuAI9e5m0Ku40WCh92rU9FZu+WWEyWYWVhbrg2XOkvtX9+q1Why6y1MJZhxy7zGcAW91MlX7ncUYApEpQRiWBuvdhV5xyeEl+HqMqqbSAVa/midSTnm6SBCDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 5:41=E2=80=AFAM 'David Hildenbrand (Arm)' via
android-mm <android-mm@google.com> wrote:
>
> On 4/27/26 05:01, Frederick Mayle wrote:
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
> > * Introduce a new readahead_control field, max_index, as a hard limit o=
n
> >   the readahead. The existing file_ra_state->size can't be used as a
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
> > This patch would hurt performance of a sequential faulted read of such =
a
> > mapping, the degree depending on how fragmented the VMAs are. A usage
> > pattern like that is likely rare and already suffering from sub-optimal
> > performance because, e.g., the fragmented VMAs limit the fault-around,
> > so each VMA boundary in a sequential faulted read would cause a minor
> > fault. Still, this patch would make it worse. See a previous discussion
> > of this topic at [1].
>
> I agree that workloads that do a lot of mprotect() magic likely do not de=
pend on
> readahead optimizations.
>
> But I'm sure we'll learn quickly if that is not the case :)

Hi David,

There is already this limit for the exec VMAs, so perhaps these use
cases are in fact rare enough; but we'll need to see ...

https://lore.kernel.org/all/20250609092729.274960-6-ryan.roberts@arm.com/

Frederick, could we also now remove that logic (EXEC mappings)? Maybe
in a follow up patch.

For this patch: Reviewed-by: Kalesh Singh <kaleshsingh@google.com>

Thanks,
Kalesh

>
> --
> Cheers,
>
> David
>
> --
> You received this message because you are subscribed to the Google Groups=
 "android-mm" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to android-mm+unsubscribe@google.com.
> To view this discussion visit https://groups.google.com/a/google.com/d/ms=
gid/android-mm/c7f94ce6-1dfb-420a-b073-d86abeff1f76%40kernel.org.

