Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996CD606D804
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 18:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RHkn2fRv
Received: by kanga.kvack.org (Postfix)
	id A75E46B05B8; Sat,  7 Nov 2026 13:03:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26E86B05B9; Sat,  7 Nov 2026 13:03:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9156D6B05BA; Sat,  7 Nov 2026 13:03:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61CB86B05B8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:03:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D67641203BA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:03:05 +0000 (UTC)
X-FDA: 85409094330.16.446C568
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id E861640003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:03:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RHkn2fRv;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794074584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/I+DSuPvds4ikStzUhuSfn+6bMaR5mQijHneFdoPCEY=;
	b=HQDp3co6Wn/DjN1gJQxqGndoIIuZHdD3jqIk6HdXOV957/R0I1qjla8cn/BD61zuaqLtsx
	U+Kd87ktW7wFdmLMjpoS8ELhEGtsaRp08U/ENXF8ulzf06yvMs9CKQwis5SxB8QWd+RHcF
	nFQkqRlz/ReeMA38I1Fg2DCFIQBiYlY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RHkn2fRv;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794074584;
	b=xCepAJQ6j3QiZxeP5yFWyhm1Ccfdmqh93nG3DUhOcr3pKSIbMg3dzuyEcBZo7NlEiETLgD
	olxnYbK2ek7tzKFjR4/RiNTxVQEWqX+FQGREDhiteGXEBFc6BrYg9REg2Sb4AGjTz6MnZH
	zCEmUKYZej7Cnyu0Y/m/I6pITWUS/pg=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4d473cfff6so184498066b.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 10:03:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794074582; cv=none;
        d=google.com; s=arc-20260327;
        b=YOO0CC1Qat5Tzk+SEBnb6ngWxfTfN4HWNU1lkdiL61cRfegNlRXn0glkesv9VJwOzo
         9L0Xke8Uq9TRK+r5YvtREU5G8/iTpPYwIr5ZJ1Ij0hUJLeCWS9Uos9gs/3yYlgG6ughr
         XA5SdBOQMYkCYvrWefaCj5l6+pZrjEh82MWMUpiwlzsCCzqCS0f9QMIW5gLxSxLNcVH9
         4YuQ+ylG3e5zxdl/DHDY/0JtHma6qZKT1Crph6Ejt+iAmAQFfAHUfpYVVjpmU+517TN8
         SO+S4oClLZ1Npq41ueob++oYREvdFcXBUl1zIFmA3v46TBdidgdtjxKGq5jSbSu/RXNt
         E7wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/I+DSuPvds4ikStzUhuSfn+6bMaR5mQijHneFdoPCEY=;
        fh=cei3nRchQ3uQP0mszEDzA7JTQmZAy5oab4R1+6MQQJY=;
        b=IILwZFXK0GxajTcQA3LjvNPn1NUcDpfYjHJNBID1hTsVV3aNS4+3hctqE7o2ul4dSz
         8Tap+gwzTFkBkeFjpN/P6hc0iHVWULAGG3zG8a9F9QN7PO0NU9jIlVHvRhesqQb3nRgO
         Rqo4+2v2wI/JZRherwXNkvzWFVe2xQ2/ubeHpfiH/DtIxBaTew5PKcrq6ooXVYrvh7Fv
         vUuXlc6tDuVzUs+Zj0w1PKe4/ks/aUgrMhnr6zrXb3bB9hfXz50B9YrcAKEYhonC3der
         ZArq8/NlmaZAu7xUnNbNqgGVgWjyZy7KAjGLKLHhL8cAmChwMYZFNT+wVYxRqYwj405U
         yPLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794074582; x=1794679382; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/I+DSuPvds4ikStzUhuSfn+6bMaR5mQijHneFdoPCEY=;
        b=RHkn2fRv7e91rciGK37++1i6ThVAxqmXOXHYxErGbJSeBs79ef6GEsZF87+ze4lbO1
         P4JNwnqtaUp97f+wnyToy0btrRGMbQqK2vwmDww+ZmxXPg8/hmwO7j1VrknPaBkBrroF
         G51BIb/KFuQQPiUfk49P9UpoqhWskmwTIZ6Wbz98JasvbyNVVaRs038cN2m5FlffwiSE
         9KeeY5Sb03m7cNZW+yAyHVavQj9GV1714xw15P6pwBRTtKR2XOq1jXZhbQiW707Hwvt+
         j8GXDROloZGDZ+hMU9yx538EVHf06ZdW57eeW15LdhKJlmIRcb6cvEtXZ4DneJ3kn61P
         3C9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794074582; x=1794679382;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/I+DSuPvds4ikStzUhuSfn+6bMaR5mQijHneFdoPCEY=;
        b=iXxQd+fST+7OTrV+nZaMmnEg2w5v+rpPQ4+aSO64xQncvP/5kMjjxVzQzfpvMLX+eI
         z4QvtK0zdj28r+WcNpv+hh7g0VLbNwKK2GOACbBHaoxCOX3sX7z4COEKekF2XnxXVIJT
         w5ohU+uA+uA28MioPdyngHU/ufeYHxAMEHXEn/uU0ndfk3vaHuXYO4YvGSJM/gdTroi3
         G4QBwF+NaSE5qJwRYItxzD1+SBzQBdj6zij+ywmixDmDVHjd0lgunNIKw6M1ec+3T29n
         vWrEz2MdIxZOhItbfXPRyeUS+vu8vetkHlYG6B9q+w7BHQTpaQD/xQqm93vgzVBoG2Ac
         Gxow==
X-Gm-Message-State: APuU4Z+1yRV8FpVFSoqdQk5juN+1s17UifovkbsEIKOqlAaIhMoVllhT
	6nGah4wdgJsM3/PFXwVEtn4A1Y2ufNSj+rne37LgVy7Zv1DZUj3Cr8MtrjvbAnZVf3Jd75tK9kS
	/iUckoWD5Sfa7443H5mZPparQcWdghIQ=
X-Gm-Gg: AYBFou2ULnfiVIAGX6eVoCcVX6zMPubPRV+aHU/7oTnpHCr3mrhcrtY/k4s/GZO5QuH
	LLOPpLKmn3CiV3xikRPQAZr7nr2qHrpAbYrWTRjeMUE3xWdoGMyUQKKg64SZkP4Zc+SUs52+lxb
	a7VrUXr6CUp3TB3yTDJZIRKDuMXsdSK4JyltKpr8uGVDyAlmJcfjv1pzDTA8ipSAKKSe+9YwDel
	uI4guGotHt5AIXZV+wX1z2AGZJxn4jnHTVyACL6PHD/1yMlvV0+FkQiu1F1n3S0LiIZ0ZuBPZ6P
	HIx7z+/3HYIB8VO1I/4EEbSLq/x4R9uS5KGbjHE8KlQVJAWdROBgYR7dV7nYbFKSOmDLFodRm9m
	mrBqLKoJOyXLIAiYpEkVSJ0B3ijHUvcOlFGZpX60rjUckqAMKHgFmQsoA9DF2QRG/VRxWAA==
X-Received: by 2002:a17:906:c150:b0:c46:9ca9:f524 with SMTP id
 a640c23a62f3a-c4d354b9d04mr488402166b.32.1794074582110; Sat, 07 Nov 2026
 10:03:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106160432.2552507-1-nphamcs@gmail.com> <20261106160432.2552507-3-nphamcs@gmail.com>
 <CAKEwX=PiM8vc27jOVdinOGO9AdCOpbKozu=Hj_b55y10-ynFyA@mail.gmail.com>
In-Reply-To: <CAKEwX=PiM8vc27jOVdinOGO9AdCOpbKozu=Hj_b55y10-ynFyA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 8 Nov 2026 02:02:24 +0800
X-Gm-Features: AclHuK9RPnAApTAFi0PfukcJ0UQmuTrX5qH0AJlbdKfeuTMpH9rclGGAWt7gGFg
Message-ID: <CAMgjq7BuAKZ1BjTmdTmXHV+SZCpGMT2YL+q1qvbDOSeqYA==Tw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/swap: publish cluster tables after reacquiring
 allocator locks
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, brauner@kernel.org, 
	chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, weixugc@google.com, willy@infradead.org, 
	youngjun.park@lge.com, yuanchu@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E861640003
X-Stat-Signature: oagaczp5nfp7fun9ttbp5bq79pztqcpg
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794074583-745588
X-HE-Meta: U2FsdGVkX1+4oeb2hfZNG3otfj5Tl3TdanjniJnNwOcuzT9jIiO6TZ7hSTKe27SJSNninOnOXT/Pso/XBy1+9hh9Ijd5jx13LNTm31oPZX/Yu67/wAsXnQLXX9u/wYRLnn+iKxHRl6pwN+MtCLuxt2McD/49VZCCAUQ/bTbQW+MZzGh/X0LWhx63iRumJg0YARLCeOXyaFozItnxyzOAu8dySEoTn19ZYwL+609EM/x7j9kvg62Ecjn6nVHLlXy13ftU7zsYarPCDgUr+PPHv4ckiVdm6zYVDktLNVxH+c1N1tyQ8kupC5r66vpnxpM/KcDrwC0rhYNzm5tujWym4v9DUNUJlV6IO69J/WldHSTZ95SMYPg+TSXnnbSxkdTJkGg6xL01oGng3LN7jtK41vUTBGYQ7TamzTaIRyg9G0XrekQ6zTdfUrHhnuGDkBI42Q+Wy9pEVYPAx0IQTK6yQ9gedFTxo2PvHFLzMEBlZX3fbFk68qrzy89src1ynQZhsj/NyS6ED2uwi5aPejvdK0pLpvJR9kbKuDiswLhPnl7/1i6WLPYzsRjqyRIJ6lJ58RpIjFzmVGFHcWZ/5wOdye4FTDd6kwTsyGZdrhhNUuMx2mLVad7e+kznUgYbGjndMS5O4IZLudqK7QhL2mHe7KLkH5Ndt3YpowUld/hzVgA9bTrOZXdfJVdeSvGqIH+dgmOehuAdyAoaVQVvIPMfFMSkDRW7RZwfHryB7pBiNpZpCw1glW3rpj+MUH1VJ9rPgxKo69yGDmGa65Iq708Kqx0CnhFIOLZN7RrXVN6XrNLQnmjLKDOkMgb7d/b8miBzg1QS8l7ExhhuTjknMlTpWExGoiawSCA46d+Q+3cTwlSJmI/rjCX9HylZxQmIbfjowxEIDsUWVMYuQb85QRkGzxcd8yhom8nvfbjwl/gT6OF7BQ0UutswWSsOy73kqs3bfIpwiI6zyNlo6NHMIH3
 x+IijXAw
 gskOpep5FWHxneGKHsDK6pdek27TYx8BVsuDGyTMqfId4Ya8xFP8S90YS7jbfpY+6z0QGI9IQ2eUC5Qy0KN9Fs09G1XacEXnlGpwuYP0+RmJXGKJaCsVBn1Cv7c6Y43zZ6TmP2YWHL2DyP1sRcOujy63gXbrkXpaTULL0de0iGjblcvzt7Xhvd3UJz323TczGDpzM3bWuJ66W0nnFnV+h9YlIKnqxfQccnYev7r7VrZFcEDqeLTko9rwAm87vMoHsE7zIxavTihkNt22T7H/4R55jY2mOQGNTR4SiZtRkrZyvYXYhZqCIgPrMPZbOddHSbL73wdfcKbuiS1nBT2IW/XA4YbG8UCEy/Vm0u/1lonHEEKQI0ksZX2c3d8ad7FgvN7jqcUCjURdcNkd6ySWQEugyXH/ASvgk1vyJPjwFXuzJwM8CrkI1SjyxXF0J5zdy7PKl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 7, 2026 at 3:59=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Fri, Nov 6, 2026 at 9:04=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > Under memory pressure, swap_cluster_populate() can publish a table
> > while its locks are dropped for a sleeping allocation. A cached
> > allocator can consume and free that table before the populating
> > allocator resumes, leaving the resumed scan with a NULL table.
> >
> >     CPU0                           CPU1
> >     swap_cluster_populate()
> >       drop local/global/ci locks
> >       allocate and publish table
> >                                    swap_alloc_fast()
> >                                      consume the table
> >                                    charge failure cleanup
> >                                      free the table
> >       reacquire local/global/ci
> >       return ci
> >     alloc_swap_scan_cluster()
> >       read the missing table
> >
> > Keep the count table, cgroup table and zero bitmap private until
> > swap_cluster_alloc_table() restores all allocator locks. Install them
> > under the cluster lock and retain it through the scan. Initial bad-slot
> > setup takes only the cluster lock because the device is unpublished.
> >
> > A stale reclaimer can return the isolated cluster to allocation while
> > its locks are dropped. Abandon installation if the list state changes o=
r
> > a table appears, freeing only private allocations. Restore locks on
> > allocation failure too, so the caller can return a still-isolated
> > cluster to its free list.
> >
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Link: https://lore.kernel.org/all/sashiko-outbox-181084@kernel.org/
> > Link: https://lore.kernel.org/all/sashiko-outbox-181086@kernel.org/
> > Co-developed-by: Kairui Song <ryncsn@gmail.com>
>
> I think I need a
>
> Signed-off-by: Kairui Song <ryncsn@gmail.com>
>
> here as well...
>
> (Kairui - up to you if you feel like Co-developed-by + Signed-off-by
> or Suggested-by + Acked-by is more appropriate here. I just filled in
> the sketch you gave me.)

Let's go with Suggested-by then :), I didn't even check if that sketch
actually works, so thanks for taking care of that!

