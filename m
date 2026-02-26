Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF30FD9E07
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 20:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6966B0101; Thu, 26 Feb 2026 15:17:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874746B0109; Thu, 26 Feb 2026 15:17:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C326B0248; Thu, 26 Feb 2026 15:17:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6034D6B0101
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:17:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF4A81A01AE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:17:51 +0000 (UTC)
X-FDA: 84487718742.20.926C4B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF3D14000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:17:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cd14AqJK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772137069; a=rsa-sha256;
	cv=none;
	b=qRx5Sy+ONo7yxMH0dIC+xR1/0h7amhhiFrS0w3e9x04dGFj3ABCGa4obRnnosXI3hxPebk
	0m8F8SUyC6LMG53jdHrCJ75bKUxnQf5ypkgpgcH8Zpi/fCWPK8nQ2Xev2qi3NLEEHPL/t5
	dww0cpIgp72AMWtE8KCAB5x3HQR2W6E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cd14AqJK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772137069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vh/GNXYp7z+n+cq+qnQ6Y9M+IWBvHNHTqdQ3EZ8sYPQ=;
	b=YwCX4v4N9hVA0IUmx9x66PBpJIOHoBDCQbqY0B0MEKoq3A1+Kps7GrjQ6VCoJq8gIpv4Y3
	RnbY9a7jzPoJhuD5YPDJcNg4nHRzUdUrvBwe1pVkips8EO9Kd39WzBNm3/ji3ofF3NiAqc
	OG8e0ScTfFOPF1K5mIs5WFIGDBBIc6U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772137069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vh/GNXYp7z+n+cq+qnQ6Y9M+IWBvHNHTqdQ3EZ8sYPQ=;
	b=cd14AqJKgAv+gthXAiTf9IL+jk/42CeQsOcW05WFL6QPGJrgsnP6wa37ijhZK4E6KvTPgd
	jyb/RrdDgIs8hsFx8JeaYSXAAhX0Cht2eEQZoeWtDtCtBVZ60GmHpYTTx65w+lEyDc47tm
	YamHpi9XuWY0MotYWu5J6hePXOakU8Q=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-ongK4i64P3-iBB_om9LSiQ-1; Thu, 26 Feb 2026 15:17:47 -0500
X-MC-Unique: ongK4i64P3-iBB_om9LSiQ-1
X-Mimecast-MFC-AGG-ID: ongK4i64P3-iBB_om9LSiQ_1772137067
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-64ad0c50067so1745029d50.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:17:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772137067; x=1772741867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vh/GNXYp7z+n+cq+qnQ6Y9M+IWBvHNHTqdQ3EZ8sYPQ=;
        b=s2uy2YgQySjcmE7H/LOpfVtO4D8M0sdPgm6nkXWQHf4Yjhk+uK5duBQC68Xwr3OF8I
         YmEgeEYJdrMUuQ/fUePByEJ7+Rrbzmkhw5W8B/Dw3eKN+lzejQA9Lgd3Vof2NrGtX/as
         L5i12Gxu/WCDzDEoRe83GQPX58m/l7xJ1oP6dhGqIswhJiP3HE9I6OI7RhGwtlbFlbiR
         TNij0LyGTfZHzhu02e18n8lyOhR6EPREEQNt7bZQNGP7sKI9dXN3/89ogfy4F+oWuwoc
         9oDD+LcJU5qHedCA87QrcscBHf1qlAnVjVwMTTNvK+o4oi78qhDxbgE0CQaCbU9a2gep
         jLxw==
X-Forwarded-Encrypted: i=1; AJvYcCX0nC5Agz7UYnR0g3IHwbB92Gv53aHGghgC2IYpm4WteecGhIH70SzWPncv0U/WNsLsNqjdoE9H3A==@kvack.org
X-Gm-Message-State: AOJu0YzIDSK4PAic3z1wfXtBsnUHZh/Ckdvn/1xYaoseHIpreATXPNXD
	SjXi/LHuvcW52FWCwmWJyXz2ryQ0z0USibMviSdPwOKfgqIy5JLRxSfle6k06S+0wRgxh/uWv8U
	lR/G8e81shbY9t+zY40RIkMJdqxJA1t6D/PNzi9VYtCTUro8hRhA3maNP68qVZMsowOG8EqucI2
	UaQWNMpcDkIOdpmfIjt6Lf/RcGaG0=
X-Gm-Gg: ATEYQzwNFgvXZ+rUSQbvSyujrIY0hFJk0q+XqwgUBITS+wPPgBWJPmURcHs3SdiFhHH
	tmgujbRT4N+2G8k+x3Rkdxwic6zv46sS+UWAnPLf1nNMzshm1xL/Xz8RTp5dZ5bCLL2EtONFQBa
	9NCTYIHvaxUTqlEZDwP+y/wAazwQz7H82WNDVFUF9JOGPDRoxduxTca5LaOUEfM+6nin9xE3lMW
	RQW
X-Received: by 2002:a05:690e:4497:b0:649:603f:7026 with SMTP id 956f58d0204a3-64cc207eb24mr411168d50.15.1772137066900;
        Thu, 26 Feb 2026 12:17:46 -0800 (PST)
X-Received: by 2002:a05:690e:4497:b0:649:603f:7026 with SMTP id
 956f58d0204a3-64cc207eb24mr411114d50.15.1772137066376; Thu, 26 Feb 2026
 12:17:46 -0800 (PST)
MIME-Version: 1.0
References: <20260226012929.169479-1-npache@redhat.com> <20260226012929.169479-4-npache@redhat.com>
 <25723c0f-c702-44ad-93e9-1056313680cd@kernel.org>
In-Reply-To: <25723c0f-c702-44ad-93e9-1056313680cd@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Thu, 26 Feb 2026 13:17:19 -0700
X-Gm-Features: AaiRm52hZUYxaK0hEqp9YTAESD97uBUcOTe_e2diu130upg0BIMjrY8f8CWO7cs
Message-ID: <CAA1CXcDYc0=_=BiFDJXQ6KwjZZB6TYwykW_c8ZhocfEZw=MXbA@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HQL0FEbu2PNBULINdwkxAy9D9soRVThK3PW-1FMeJ7M_1772137067
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF3D14000E
X-Stat-Signature: pc4b9w4sbgcyh9dbm33qgx3ynws1gjnp
X-Rspam-User: 
X-HE-Tag: 1772137069-54821
X-HE-Meta: U2FsdGVkX1+psAMt7EBXkgaLpTRza5mnu6sIEVBNSbLvhODAwYh7SGyixRwbLvUjP/5OuJMV9wvE+MfiL3wa5ZoGE/Kle5mxkG/DpAaE331fkXwKPxFvbV/F8ClyVFY0LfVTlfeO6j5AyuAW9179X7qwL3LWdur4R6stY1tQ8WtRyjO7z4Ye0l6i+jIRNZR/6bDY5nl/HwU6BbUdUeeFRjhzUSbfw9kU+jyw3gd1kixleMEdovdQdZ4NjrRO7GLdHNGcs0ytpFRS1+afMXt0CLhbZa+G9kbR1w5jUtmbcN/GYkjnACQql+JLT07+cNWoCDOGhuUiXp52opqvYtLDcAByXovIKU8TUyfSrbeJZj1gMYSjddadoPgqu6LN338Z9Q5oHO703YujA4e/dAJSPe7d/L6HozIjeVn0qBKbLA7Xcu/J6EA/pynP+Mxz0xQ+08iB1ze2dT8B7OADhKNNZKDJy/KAenatv0brxnrD4jpAan7qhF5lj5LCSq8qxMJ63Nv76v+F3LcuNyO5goz+Ql/6n+NJDZnLR4Q95hLXCDVI+CRdQ3UTs2ZDpxnRKnbeYDZJLF97rtyZZPulLbld/3E54kUUDT2CKvbBBg7dP5DOY2orzcq+xcF/vXX4e+6tuB09kDt9gh8D8OO5K7SXpYakONyi08q9Eq9CxIC9Kyb7tD2c2QAmNn3Qb42zv4qj88nyPG01djsin++U9RbwtPu7jPqUTDORYqaY/ejGV56kC7gt9ZDFeWdExhrm0fSoo+leaDgHdhenDbkXe4R50Qyapv5y5O2VS/Qim/anwEZZAmehLkbZH3u9xDK+/KBhYuuFz1VumHduBN6gKZNkLu+AG6u43W6lkus3GU8bG4Q6zxLK39Rncomah74gEbcBHmsgvpHj/bkTbkU3sbDpyLAu2FC0RMQSgVk1PGe8OMNO2hnOGyNupiEpZnvoz0/VKmCSGaGcWVHAgn2Sk6T
 8t88izsD
 P6KFyviVeq7IahMLwmug6MCedwjm3iZlaDORtG3d4Az4Biet6+qBOzaHKLQYJIBgIDg4HO0nih1fO8NHBP7WxVjA8df3b73E5iT0oTzhaNcTf17GkLlb60PuJzlbwfDYA6KjMbjEMEnV5HtoMZySULno5v1mGAplXTdibSZ/exe5549WmkpKkBvJBJRDaraSwJkkmn6XRWfi5t/zCXuqKfMd5oTKI04R840ojZqJctkEPXMwGXJTW5zVzb0f4/GqzOyoZBBu/t2jzSoFxo6DLFA8OKRteQGUi/RWlHXSh1nS5rJMvpEEsxhjQEaRmJbl6OBvIC0+B6Hp7BXTII6BxSmGxjQ0vaixq8rahitcJ5JY8vBlPUgDKZ5YUlXNY2Fwgq0Y1CJoCRWN97VDYGzgIyQW/mCyKb22W8R4ODlwNFcdMejFzji4Nx3H1HuxgNeMTOTp0pYp31J5AL7UT/UdQVPufl9Uw6FBnudQHmSgS66g5oxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 2:28=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/26/26 02:29, Nico Pache wrote:
> > The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
> > signify the limit of the max_ptes_* values. Add a define for this to
> > increase code readability and reuse.
> >
> > Acked-by: Pedro Falcato <pfalcato@suse.de>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 2ef4b972470b..4615f34911d1 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -89,6 +89,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
> >   *
> >   * Note that these are only respected if collapse was initiated by khu=
gepaged.
> >   */
> > +#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
>
> I'd call it "KHUGEPAGED_MAX_PTES_LIMIT", because it's khugepaged
> specific (no madvise) and matches the parameters.

Ok before changing that, note that this is also leveraged in the mTHP
set. It's technically used for madvise collapse because when it's not
khugepaged we set max_ptes_none=3D 511.

But I'm ok with either name! I just want to make sure it makes sense
for the later users too.

Thanks :)
-- Nico

>
> Apart from that
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David
>


