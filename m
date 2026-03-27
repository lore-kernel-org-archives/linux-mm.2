Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD7B10F2861
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1DBB6B008C; Fri, 27 Mar 2026 13:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CECC6B0095; Fri, 27 Mar 2026 13:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4F66B0096; Fri, 27 Mar 2026 13:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81C4D6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:32:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42611E1437
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:32:42 +0000 (UTC)
X-FDA: 84592537764.08.1C43046
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4F98C100018
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:32:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sruap5SP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774632760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xn4jfIlqJ8j0SglUOPqzBzIxBo2F6zmgVlZu4AmYgAs=;
	b=29gOoXUn64LzXuUOcASgXDzcpIC0Rrxj9sNoSU8a8l3Q+6qGZh+uGS1PCt4SstFj1kvZBB
	xdDz7dfDJvPDYbhWB8MvquGMR4wRyvPySUa8G00/CpxarmUPnGrJQ7INCmPhGeBf+jUsP7
	WU3mOQum1C6ePfq82AuFqX1J7puzJ4s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774632760; a=rsa-sha256;
	cv=pass;
	b=ziikTCSyF/tMGnQwEa4BJrjMXBf38xUWVvwmmIZw8r8yMficpYhZzCtTncA8gBjNKprAK9
	jcuZlsRuxOIbPi1mtBJNKcHPFTDYANxg/LifJ/putvwl7EGiC9FLD/OyErW1u/3TBMKs+P
	B6q+gcWhgOQ/Y8nyonbuFbrEUUGEYXc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sruap5SP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-509062d829dso32801cf.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:32:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774632759; cv=none;
        d=google.com; s=arc-20240605;
        b=Hcs/+WcEFyra3p8PNydX+CdAxvSAgpeM+2IEHyF7YQl5bx2dEHgAL7S/RRrZlMDtGG
         iaMa58dRVcpU0ZGAdBqPwgeXwl4JKQjtnGE3OLErPka/wg3mC+f6fwRlOgDky5f5YmGV
         IuxHjIRRfS/7fxmAw4pIeV0orUztmhNiAwK9to+hE3uueN2XT7ohw/Vy0yySWxHxjdEp
         MIGTQDQZuDMYI9fXdVLSErdRNZVW8CI9KVxo7LfI7MzkX4ff/R2aEfQKAYRMhT/P5huB
         0JwVA4YJy2fRUfBAlAUHwI5TFNz2RJKf1+8/7OExp2DDEZYc0kPfBgguVfdnwkfpBNBI
         /q3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xn4jfIlqJ8j0SglUOPqzBzIxBo2F6zmgVlZu4AmYgAs=;
        fh=w/l2Gx+jFt+LNDdRgt/tOERBsUC5/ZQdmqB7686Z4Jk=;
        b=e3HQxdko/jOxohFEJWAn8bWqk98KS2vxBP9F9QZNJEEdI0lRIk+acUSJ/d8IamR7nv
         WAbw/8zjtCa8UzZ4ZcCaUj+JXfmhvkF4RFIEEbvGqIVAlpmqOlFZhk4rI/K8L5v0rXk3
         rHtJqiQFGJZIDt7q+e0u0rTnaJAIjjd5Wqi4kETwFRL6JdSiebAuePmC6K9eBqwx7hq1
         pw0RdqhLoHBPSpqMddEU+Bv7jEr5IWpfFAwiD5a3fzLDSPAV8yL91ujYyC3PPr39DjVb
         c9TSD7TsRL1IYqoaxwMfJe8l0SrdBUhpmcEkH/INwG+jVBCp3jBP+EuspjOfRYhAdrLL
         sNLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774632759; x=1775237559; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xn4jfIlqJ8j0SglUOPqzBzIxBo2F6zmgVlZu4AmYgAs=;
        b=sruap5SPkRBWSAYBq/t2ts1oBoqb2ny5GdKsESatzy+5pwLMKT49gxhXbwBjX6P/sj
         kmk3SZvR5JcbFIX0Be1VKj0hAKeFxPGxNri9nKnVvh/KtfZh0qTPi1qOkD2B0tsWxmDy
         nxfCN80I6IbnqjSx6i2QyA7Izid3a7cIz1Pjz0LFHrapeHa56qFKImzSISlAkG6PMT/I
         8oQ/GKNlIW6vvDtF1wytanFuKm6niPlTEl2wAYrtjb7Q7Qh5qDsftd2qwRuGtBFC7IZe
         Zhh5WuTcLn61pBM6Ax8xdvXFWCTiDjetc3y+swGQk89kYd77g182ytcnTCFuX7rRdvol
         EBnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774632759; x=1775237559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xn4jfIlqJ8j0SglUOPqzBzIxBo2F6zmgVlZu4AmYgAs=;
        b=NpMmgR/CSDxBFpzmEFSmZBCq1W3m31FQyOStNort+JDRlK28jEkvjJTYOgDmIwM+qU
         WhHKeIlvGnQEeZLClraRRZE6Rpo3KubZjdf809aU3NTAjY10LwtocI9jYSof8khlv4ET
         4KsS+BSNnz76MdLOeg0N7u+87K1GzVVqGq67gMqZbLkk7Jf8rqTbdyUmVe5m5B52l2xm
         9ODe92I1ixp00Jrjg9Ic6fmzIfn2QLo6g+a3H4Gl3zK3K3bw+uCazJgTigOHyklN9Nk8
         WBIcf0XG6Z9KRZlVngZLZmgNr4jJg9EAZrR+T/iO0Oc+qNRCzH37EcRPCPX3TS2NAyI/
         R0iQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1wPvnPBVqC65NP4D8Yp9pgqN8mXHBIz1vOpUYlXm1koMKfp2OY+guz2y5Gl3tcZj8dwKyqXWqgw==@kvack.org
X-Gm-Message-State: AOJu0Yy4ID85yetQdBOvzCAENWxR7o3mmDndanBOoq4F9LPa1c1uLXTD
	E9Bcx8ZBddyYLWKxBs24FtE1hTnyGTlT9K50F/7A6Z0i+h6bQbcKegMaU5g0GEdnetxPwp74jlO
	FzRsAF7gdR9SClpT7QyjYsVQjSmELZAy92G9HJrma
X-Gm-Gg: ATEYQzxrZkdof1B0NbfvEF/uYjEd/gle7c3UE2bxrjR6s3oarKVJJuYCsuPm/WNhSsj
	6rxIP6gbEBbGEF0qL0sxt3fMROOSE/dWRjFpt9t6sELJHtP4WOqCoTZfCFyVd8rfTSYCDX6X3sQ
	zZD1TzTsMxcv4V78u/0PbF+DRqKb3yFbmauJpmKYFSD+LqZHIUzf5YVJxzey869i4HpxqFee67F
	Ps9V/A4depWzjbr4hUGF4OFiG1G7yJqyg5g36ae2qLkUeB0zSkFmP4TNBve8wuJlIW0H+V955mD
	3FzkDtLj+Raqlx8qpyR8uFpqMoDFlc0kp86I
X-Received: by 2002:a05:622a:8c05:b0:503:4bc:c925 with SMTP id
 d75a77b69052e-50bb292f320mr200991cf.13.1774632758893; Fri, 27 Mar 2026
 10:32:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260326080836.695207-1-surenb@google.com> <20260327094738.7150efc3b0619e6ccf095c23@linux-foundation.org>
 <20260327100322.b539f1a9f3662a0a4c080cce@linux-foundation.org>
In-Reply-To: <20260327100322.b539f1a9f3662a0a4c080cce@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 27 Mar 2026 10:32:27 -0700
X-Gm-Features: AQROBzCNRgKBqW9q5PX49UYqB837bDipJe3mVx90Rrm9LZ-wrkWrRewJtwtbwBQ
Message-ID: <CAJuCfpFxZsnZqqfoKXX=JEBrBaqZHNAgBE0VHbTc=GhQzP7X=g@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] Use killable vma write locking in most places
To: Andrew Morton <akpm@linux-foundation.org>
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4F98C100018
X-Stat-Signature: 4hexf14ma7wguyjsj9558sa7ygcq3rtq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774632760-434768
X-HE-Meta: U2FsdGVkX19/swwEl+vyBoH0VQ66sLrIgmYpyrfvNpKxdlWKWCHL7B05k93D9NErem5caNlVAbTVRm9lY6tIBwBofrdcq62hBIrH0a3hhnDVhVFuFvmtZiEH7hL7++iljNmqsHWfTLqsNLkTP6WyMhptnK5eEnv/VN0UfrLFvD8SI+98etwtWw25JERIa3zoSbFkvFliNh4rABs2H4pg9ThHyjUqeDFIPw9CntozfQ/uzditV2S1f/hcycX0+eMCPw7id+NgE79cSk2TqfOnxD4L5bD+dqpYJLGPvfY1AHx99F9G7hi6Pj1RXG75gxD6mzqGjQn6wVdGC+e3pWuza5ScTnKc4ULnTEJALk8/wFGWkjWRn2U1yH+gDo6s0te1WeoTVW/fsiuMDCC6xpkvdq9Xd51CA0n/CTg73htWSjP67S8jQeNbw3B0YXRTCsGHs90gNPopyRToxWnspylZvqOQkLFf5JV4u2jhnxe3sNyzrhmzyDovimeIr/XXDDjG1QTYKjuMY+uFRmE1JEx8jOh8URYVJzawirkjLlHddETMOn7LnR0MOuK4CvavoXQx1cCEytIljZlDv+Lwu+5wpba+UUH3KwYlH7v45uY+IFX8G3Gfl4CuyO33nxoldg2AuO9ODPix/VxbQqqoh5RigSkXpWztYENufvkElpcNKB++TjlH4AISMG6LlTOEZiMh0felsn3CK3tfMdX0pSjOE/Aer1AejyMWVg/K5g5UQd1i8PkVaYzo60UL5UoR1LXF9e3hkG1aX9wqHo/m+m8gVgE8+WRvpevgtxL84r2l6agOxaRMwlsq6PRIRX3ah49TMPWvN7mBRy6QErHAncxQ3OKM8X32qPXmMHozr+gqiY8kVcpHCJmsf8wDX8Y9vAc/sWu0hJAe/QQQf7JERsVzwOkcTHStzJtM+16hzBYVZKaipckhcFfBvNsJSRDjNUULyyXYtp1xO4cvBgdaKS9
 zaSIguXS
 9xiYuGTw7X8Bah/oOAAdlHHUUmL84vCXGAHMbAd17nZFkQybtQfLbCgloVDiBYyijXvjY5vu5kkWw/AVSb6Zrcqr3pYC9e4pMRkdh1ZEakuTNHjYkiufIMI+almd0E75IKhaN+E3i6gylWdEBTTwt8+ybeS8wZBxS9jswCQHc20stCnpskYJcJpz6ac7GzkJ+qnvbfVBYldCLE4uOSJNUJR97pyIYKdYB/AMZvQ+ZSwCDg1J5+uW2rSCH6uFZXJLZlsg1WTN+OiQjFkhrpQYrCyaJHpGnwcsVil9MdZu8buYSoLdlEAcgsQHfSnqnGp5Wxhn1TeIfe/A7r+ocB/tBX+8hkM6H7UIYjfVAht+jo8iFPfNArRyYmM4HjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 10:03=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 27 Mar 2026 09:47:38 -0700 Andrew Morton <akpm@linux-foundation.o=
rg> wrote:
>
> > Three of your patches lack review tags so now it's 65!
>
> Three is now zero, thanks Lorenzo.

I just finished fixups for issues Sashiko flagged. They are pretty
small but important. Testing them right now and running Sashiko
locally. Once done I'll post v6 and will ask Lorenzo to re-review
those specific changes. Sorry Lorenzo, I'll point out the specific
changes I had to make and will try to make it easy for you.
Thanks,
Suren.

