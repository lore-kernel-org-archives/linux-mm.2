Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C0CCAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857F48E000B; Fri, 26 Sep 2025 11:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8095F8E0001; Fri, 26 Sep 2025 11:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F74D8E000B; Fri, 26 Sep 2025 11:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5823A8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:42:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B82A1606C3
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:42:00 +0000 (UTC)
X-FDA: 83931817200.23.6B96AA1
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A49A20010
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:41:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fn92LAyJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758901318; a=rsa-sha256;
	cv=none;
	b=5USc93IyRkZjTBWXv4bwwcji9AKcqS1eg4HxWxEbvFzXlYw4Ew1rlQuPfKxTcSGmrBlHbU
	j7SenmjTU8plf1lsd7udyvMIIvF5igcOOzuUDuN1rgmnFGNIdQxff4/UkuE9A7T9AkZEHy
	vYdyLn1zZjiDn6wwkyNhK5dgQNfYuSg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fn92LAyJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758901318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pH/Mra/vNThcOhoVJxCqltpBD+kqqv3l/039qoiWKE=;
	b=FZQiAEFjUEtrHvDrUmfVLRcmvloOSwXVWBUS5fNX8KCon27X9SOlm9odbJL2dnUfm5ZfFz
	alNgJqMCnTq8ZkMZDVVOr9iNFFSEyrfWjO7vnqvw5Uz6sjnQRUK9AMLNlEo1eajp1/g5OD
	+k4AZjOpNydPHMTA6mh7DkiQdm83fD8=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4de66881569so166771cf.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758901317; x=1759506117; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pH/Mra/vNThcOhoVJxCqltpBD+kqqv3l/039qoiWKE=;
        b=Fn92LAyJJEbu1/n+7taETkGv7YKk/A9tSLp8IyJJfiDH85PeaKRTxPRMKY9keEnq6x
         sCZ/8YMi6x+KXFS8c7Pvye0jf0NjE+fZCiHUTQZ7uUjnkHzUhJg0QD6ZZc/csB5wrgYx
         DhYeNXXvcYxnRs1N5/IwDhuYQratqtu61GGo1zSWa8es27HHrGDQmDLOO3pPa6S3/Fnv
         pYkpWXgoOurwXfe2nEaU5J7fIf1vA1oxFNiOcqliRxYwD1g6YwaR/92JTtg0fbqFpFV0
         dynw0naAwnj3cjD74aRIpU0ALkBUqelLmeE/yUh5Ngg77WpIHPzegrDZtEjrARxQdkLN
         Svdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758901317; x=1759506117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3pH/Mra/vNThcOhoVJxCqltpBD+kqqv3l/039qoiWKE=;
        b=Fe2PZ3zi8P7YSGG7XIJXeNFnPDsQrGGDC3h8UzadXHCF4k2BIln3a6W8epDTl4Pe7z
         ZanT1TDNDrv+RxJLOh6sdhS9NgqJJK94ALilO7xG2rVcaHp8aYhV62YTRC52RpZsEeyP
         wFCgjCUNi5vElocut/+JM52j/DKNgvASar8dh1E2IEmS9zR1e22lHb4NwMKQ1MRTf9Pa
         Aj1+zJpnIL/bYZ9Q5uEd+T61qpD2BbIYbpMeRhXoVYVxDVDtqYTfy5Mko/jQSnC04Ql0
         lMhP5LG0yQoKY1L5kQI6Jxyf7mY0S4lyG5thW79VH5nnVqM1u40B3F5VfupeZnB2Sex2
         3IgA==
X-Forwarded-Encrypted: i=1; AJvYcCWXm+JW7riOytFQ1YVAmI2Z710mwv+nMrbsR+1kG9cASz2CGR7gO8VxORZ9ohbwffiXKKkzUX9ebQ==@kvack.org
X-Gm-Message-State: AOJu0Yze2ttt4JZlRx1h9xpV5BQw/tBZbMz7um0yL5An4gAS4fPuDIkU
	hP9T0zcRWGkkkl3zEDT+ss7BJqFRxAmQcOpuIpaL01nsfrkQ0+o8cT43XGawfygQTPLWvuLA1N2
	sxjafczjiQqrK7vHi8moYQZjm0jbPioKlshE7Czws
X-Gm-Gg: ASbGncvCYqFENOSihzKBM5DW+0bYFG6aerjYKFiooHIc9bnARcIxBLLLtfbZRgX8G0I
	HMKywwNj9DnB2xm86hdXcpag6AE9PS1oBwyuzob6X2iqZEK89fi9P5AW5TLM+nqLoOCZxGuwmn1
	UANL+tZzWPJ6eZPC1crabcBW+NBF6nz9QT2vR4KnJNXgJAi5WeMU5+asLkALP/dTZME3g6SVg2N
	B4Qy/AWGPks
X-Google-Smtp-Source: AGHT+IFie57Mb7sKx4CUZ5qKsCQeoeNOTrEmPRiPoBnlLAWdzMBBoHnVt4sefNukmoViqBJmoJjKbHzT5xDU0mO3fA8=
X-Received: by 2002:ac8:7c4b:0:b0:4cf:dc5c:8c76 with SMTP id
 d75a77b69052e-4dec6c15531mr179221cf.11.1758901316443; Fri, 26 Sep 2025
 08:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz> <aMpxnACqmsQl-lp0@hyeyoo>
 <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz> <aMqcXyKRlZggLxu_@hyeyoo>
 <6f92eca3-863e-4b77-b2df-dc2752c0ff4e@suse.cz> <aMqyn6nenR8V_p1y@hyeyoo>
 <bf8b4741-1025-4cc8-b9ed-5b566bdcb2d7@suse.cz> <aMq40h5iOjj8K7cc@hyeyoo>
 <a32bd837-2597-43d0-9da3-1ce5a53b15f4@suse.cz> <40461105-a344-444f-834b-9559b6644710@suse.cz>
 <CAJuCfpG6CSm2iZ3jrwLQA4vVbTMvC=B37q10OL+wLzm-DSRhFw@mail.gmail.com> <80f8bdf8-ce50-4682-9468-9f38e0817e89@suse.cz>
In-Reply-To: <80f8bdf8-ce50-4682-9468-9f38e0817e89@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 26 Sep 2025 08:41:45 -0700
X-Gm-Features: AS18NWARWDrEtqEv7CROqpWdTroNvRVXVK4eBsZm2RsgspwIkCZ14ujtVqZ6vgg
Message-ID: <CAJuCfpG4JYPE0YbzcLCZbtsqkqCrzaRENkBunpvzLC_B5q2vCA@mail.gmail.com>
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu() operations
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, "Paul E . McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2A49A20010
X-Stat-Signature: uoi4q7t5epzp6y176o56uwajtg5kyqni
X-Rspam-User: 
X-HE-Tag: 1758901317-54404
X-HE-Meta: U2FsdGVkX1/psdjlao3qow+l+gdMeQ5r4vQNPHXR/+E6PzcGCTUg1/F5CVJynV3JsCsI90xQqa8wmTSsyL+qiiq9mvnVyZBX2CveleEweDXkctYb16i5hBM1vJBt1m8++eGcf2tUiYabWKQZ7LLFgPI5awLAzxOyJH7KULOucPIFwiyJrjDASmpaPZ3P02cRC2f1GyF6KUv3hZ4xZalZotcpQKMp3/SJjCvddUYiy1jtDZv7DmDadF0k+OwGNBSGnmQ09c5I1QY9mGdrwTSWE8xUloHvvYvw+8D22HwvxPmjV+F8QqVYPHxK+iw8p9d6mJf/wXEkpDdf8xgsa3iWZKeKeESJHFbCLEoEuFIqFrj9txBnnBhrCEMmFCmgLVUNyOCfS+BBypzaQaBgSA4wiCcGwtTu/K/TyaMQJjxO+KU/d08pGPIrUqpOpXX5dn69oVkjen+b3yr2Je7Gb2cMTdkhuT52OecKrEGzU6a3Vs1CR2SVTlK7BIhMCdpxh2OGTgFMB/iDzGD7+x4acK9RVJZG9kFHarn/qa0lzePSdygQX4AM68zlTWYsb6F0VikqtmMfMKB61XZbKoZJztHAiqLpHwu8J+d7HsCDGHOOQV2AzInXwzKb1m7xNIJYEJ4dZu9WucFJM9tQMW4jRiQKhgWvtQwYbQ93eYcUlgRnR4NmomStagtBLbPAC88UpP/gRTDcUhVp9B6tfRWKLYBTU92+MWXIsSNNvl2Is112ICgYcFwCBXMJpCqt3JX3eDGItVUj6aC6bp/ELMxGkoL2OyFhrL1ni3U9Ed1Wlyz7uwlUOuWPeKAhPiK2nDYx4A2YhMWoRr77zz+zchoC1/4mJ1qAqAevpYpoBoKGGJOk1mcMBnDxW6Axw+T0C1CUeG/SrBKHFkE9ek+z269GiOSeol+pGJiaNadp6ov0jivUQojKJDCt+05RquFcsarb1BUyWfsYfXJqLWHIJ6p69Yc
 kfLWWPOI
 wsHdHbF8I5+/RQg9MsNNm+ulnpZsjT2i5zErovgLZDVZ7rwU02oQFd0jMsSlNFhKAoNaGxLbBOTXWDN1ZwRaNH54FHNtmtwAQze0IaTNCsh4ktbjtnAvLAaFSEB2Qa6/sJaNp68XUo05xfBN4uh6qhAB64pP9yt3RzWXEYuAC0ogI2DdcOoTlcvfgsCIneihm0bHg/4PQyC1THE0tVR2BRekicn7euqWrJp56
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 3:08=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/25/25 06:35, Suren Baghdasaryan wrote:
> > On Thu, Sep 18, 2025 at 1:09=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> Expected advantages:
> >> - batching the kfree_rcu() operations, that could eventually replace t=
he
> >>   existing batching
> >> - sheaves can be reused for allocations via barn instead of being
> >>   flushed to slabs, which is more efficient
> >>   - this includes cases where only some cpus are allowed to process rc=
u
> >>     callbacks (Android)
> >
> > nit: I would say it's more CONFIG_RCU_NOCB_CPU related. Android is
> > just an instance of that.
>
> OK changed that.
>
> Changes due to your other suggestions:
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 8220ce095970..fec0cdc7ef37 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3945,15 +3945,12 @@ void flush_all_rcu_sheaves(void)
>                          */
>
>                         INIT_WORK(&sfw->work, flush_rcu_sheaf);
> -                       sfw->skip =3D false;
>                         sfw->s =3D s;
>                         queue_work_on(cpu, flushwq, &sfw->work);
>                 }
>
>                 for_each_online_cpu(cpu) {
>                         sfw =3D &per_cpu(slub_flush, cpu);
> -                       if (sfw->skip)
> -                               continue;
>                         flush_work(&sfw->work);
>                 }
>
> @@ -5643,6 +5640,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void =
*obj)
>
>         rcu_sheaf =3D pcs->rcu_free;
>
> +       /*
> +        * Since we flush immediately when size reaches capacity, we neve=
r reach
> +        * this with size already at capacity, so no OOB write is possibl=
e.
> +        */

Perfect!

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>         rcu_sheaf->objects[rcu_sheaf->size++] =3D obj;
>
>         if (likely(rcu_sheaf->size < s->sheaf_capacity))
>

