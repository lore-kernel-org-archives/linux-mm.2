Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E922EA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F31B6B0005; Wed,  4 Feb 2026 16:35:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D3E6B0092; Wed,  4 Feb 2026 16:35:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792CF6B0093; Wed,  4 Feb 2026 16:35:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 680D26B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:35:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 265A51C1B3
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:35:42 +0000 (UTC)
X-FDA: 84408081324.23.1B04AE9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA7DDA0002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:35:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NpzRmSpU;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770240940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nlyrMaKGGiD8GgpuGPaSWwtm7U6K5QJqsNa9rsAtym0=;
	b=qhpyjvPBcQHD6fJWRXGC1OqFsHP5S1ub1Obuh5IjWndIL9u8TQIhxmrov95cIVZBlFYEof
	FE1iMHK+UveuJxw7f+X0kKKJTfA8nUTdGPMToeLLkxCxbvdYrP904PjjX4ggxd1hGawzdm
	YE28MECogtkvbmEMcfuordtkbefjI6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770240940; a=rsa-sha256;
	cv=none;
	b=Pr96tj2YnSc3VBICI8zlPqandS61oFx3xU1/oiIccLzvvKTkKrpfzVq9n3kXxU7kxjN2wr
	IoEA5H1q5S6QdE/MCrhouMJ1I9zA3e85EuUkPw74+zawvjwIqJ7lIw1d0KJH6rCaoBhPSj
	1FKhurCtZY+ACDU0rJ8KWrVOz3n85Tg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NpzRmSpU;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770240939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nlyrMaKGGiD8GgpuGPaSWwtm7U6K5QJqsNa9rsAtym0=;
	b=NpzRmSpU6MBWbeeD2QRsFEGmxHzEsNUXsNMwmKRRWP1u6U1BUyrWm9OJ+ZsFhhO4AmSCOy
	H30Yn1iz2SUvhR9Ow1T5ZS6sU6XyU4gvdx/3rQdoHLOUCN6meI7ng1KR5o5utJbIjjglst
	fm9dn74QF9DdOrSRzVCretNjjTFxrCQ=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-VLbEigN-O2icIblliR04rg-1; Wed, 04 Feb 2026 16:35:35 -0500
X-MC-Unique: VLbEigN-O2icIblliR04rg-1
X-Mimecast-MFC-AGG-ID: VLbEigN-O2icIblliR04rg_1770240935
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-794f00a879eso4057357b3.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 13:35:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770240935; x=1770845735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nlyrMaKGGiD8GgpuGPaSWwtm7U6K5QJqsNa9rsAtym0=;
        b=DWSO1E2lVcFf6TRYjHeStvorG6EF+eRxKVgH/O4mpPt9FugiewEVafnB9XvcQ5i4EC
         rHadZXERwWnzC1z1VV/xvupoOvNEzHqkqfFUp5V43OGdLAl9PWFdumtz7uCDv4tbf1Dh
         3yK5LgDSyDz54BxNwfqq0rq8ToGtrCcxZgLyFcaDgVzallcserOT16zpKWeXdeB6JKCf
         21UeNhaIsFN299jokVMuh/nOcrOTyEnXcHh75sK9fLc+XMjUrDvayHWtspF/Hn1kLdlB
         3cmTfoAvdcKs78+clbP7/oAGRFIfBaJrv4E54WkRLOocWFpS+AE1lvvWiB2Mp1BPvMWC
         QujQ==
X-Gm-Message-State: AOJu0Yz9EDz7zOWVLwiwwvXqQrZXWAYQZ/DVFbmSUCV0psruKZ9qLYoh
	+fuiwFK2Cj+OKGnB/2e3K8498+SUnIl3X8UXu7mN0sLtLY1t4Z5n2yGcV0qkdbFgoArZrdswQI8
	cG0W4yj8G165sIYezlGbBV/AAcSfikAOHD8kwMS7iuH/53WxW/sjIhz4fyZ0hhf1dCRUSg6Us+y
	rIO/0paPU6q4++MCc6Fcjg+DKvEIE=
X-Gm-Gg: AZuq6aLrqlyXLMZp8JsHYzvAYkTZj1jUnHNAIBKChJx7ZCKgc44dXS+sJOEnOzRtKIw
	ssLGm1K3AxgXOeRuiatJyZU2KZco35F28UkaDWEsxoyZkUOJm33hedyoIJeXk+aif8pToGXiUCa
	wwNTKs4HdVSo8t+SYKtUn9FRbG/MqygGCbt+piGaThk9plhuis4ilNi79oM5Q98ilf
X-Received: by 2002:a05:690c:c50d:b0:794:752d:cc73 with SMTP id 00721157ae682-794fe823278mr37751677b3.61.1770240935361;
        Wed, 04 Feb 2026 13:35:35 -0800 (PST)
X-Received: by 2002:a05:690c:c50d:b0:794:752d:cc73 with SMTP id
 00721157ae682-794fe823278mr37751487b3.61.1770240934851; Wed, 04 Feb 2026
 13:35:34 -0800 (PST)
MIME-Version: 1.0
References: <20260122192841.128719-1-npache@redhat.com> <8067c5c9-491e-453a-be1b-33603744758e@lucifer.local>
In-Reply-To: <8067c5c9-491e-453a-be1b-33603744758e@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Wed, 4 Feb 2026 14:35:08 -0700
X-Gm-Features: AZwV_Qhj9f0Nsb6Ktl9VTFxoa5W8_cz6au4xpYaFZG8J9_wccM3oiCb7CJWR8Xc
Message-ID: <CAA1CXcA8digLf78mc2UFCGnGMu=xRBGGXsY6Xb4uwwkfr2kB3Q@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v14 00/16] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com, 
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com, 
	vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com, 
	yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com, 
	raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com, 
	tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, 
	cl@gentwo.org, jglisse@google.com, zokeefe@google.com, rientjes@google.com, 
	rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s--NYJm_wLqW3RwDnbCN2t_EjZYreCOxhbjIgMKRC-4_1770240935
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BA7DDA0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gtjrijaxwdn434s4aebc5787i7g85g5s
X-HE-Tag: 1770240939-746337
X-HE-Meta: U2FsdGVkX19ZkeIyL3qPXDTlVXWdTswRJ6YNQbOr9ZwmhQYFeLmM0gKuBo/JU+o8fJ2VrnEnPqLMdmSmVWq16rRJHjT6DDbsIkBLgfkJDGkmnWJIBwxrWxvy99HXbX78TLD0pNo9BIRDXfIdHJgYR+ssJxTZDP1iYbGge9aqvl85gVLhevWYd7Da1GXIkufrREgYoQ3ZQHec8WwtL0QY2Ma7yKZE58yoJc9E0hwi1c2CopZstO1hb00BhBrdVw90H0YTj7Kf5Qaawds7B3eRbsHUKH63fPqWCwhX/g9sMarzrTmb6DKFMB8IpGttQbNCF4F7UKgzmR5LjssGGTcULMtHT/DPznwxY0BoTxwjVuHLmX/opaZ0BuM9lv0gxBodL1Lv/dZtzU6HpBT9ZjgKc9LVoqzf4DqlSoIPYLYhUjTYze+JsIeexc+Q/Ka30ZOD/vfZ6cv0GTbdwbuJxHkx+ASfnfsRDd1HLhK31P4GHTgTPLrUrBPgdu30CITYEtHRNYZ7NTZmsStbCgY1MkOocEWuAXiMCARcNQ/bZ7Pupg2Vq4xze9wWD8Numjzl5BOSbicGjv4Rp1eJ5Xt3M//X7zlQK7eHSuSo5U/j9QCgThIjfe6AQGlcNTAicBZ7i1LV8VZZ0QUepPaunDLY3XAPw67zIGKh0w8xn4vro1GPf+yXQPqTVheOVRFfMtu4EvKcoXsj+k+DQQybNKw6HOcd4aC69sUnOwVxv/FZFbDTuI34BbFDqXXxt/waZu4DXlK+I26ZhIxO92KAZBm2rRdi82jtXhHgh9M44F+GBwRaCQWtutddECZs0P8xSK1HFv3ZtpOasIL0MpGj8uswaaW4iotlwZz6fQkpd2ZPXUsurQ5AJuSktUtEcFYDR2vAT3VdVaXaKIz/kcU52SPOBkngqfA32b43eKEKiTsf3OKVA6vywXxpj2ZeLB77051vcYsP+LUjdwXpyBznm0yrQt4
 qf/W+hG8
 61MlQSZoxJxnQJRDz+zCfAyTe5f5tjjqdKY304MdUYxPyLxXmgVV0jBThBp/8V3RVoG/TmsL99zf0Bp8GxG6Om1W/uwsNY8Di1XjKOqO3bkDDgXlLVC+ihpqG6H6790ARihf97tnkYx/QoNyw6xKp6tZu9OvQNy2Q0C0Hs3xOQvhBPOICH/qFrPvq7pkYSnBEZiB2PFXRrJ/p8ZgritOXw5ns1aMDMGXRrzjJct/sJR4HU88aSSwZI0uxMaig92TNYUQDQctOQ2o21T0A3ceHQBNb/PRccMY7oj8JDnzXfxWXer5cEEv8bz8PhpR74iVRg2ErF1UoyFIaVaTZ9blmvRszSVxuLolvehVHyaaSjrHUAA9WbW4uMjxfVA0RiTMGTulPLTAxe2Q5FxoSzX7BEu8h2VsB1vZTSt1cusuusxJupxM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 4:34=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Jan 22, 2026 at 12:28:25PM -0700, Nico Pache wrote:
> > V14 Changes:
> > - Added review tags
> > - refactored is_mthp_order() to is_pmd_order(), utilized it in more pla=
ces, and
> >   moved it to the first commit of the series
> > - squashed fixup sent with v13
> > - rebased and handled conflicts with new madvise_collapse writeback ret=
ry logic [3]
> > - handled conflict with khugepaged cleanup series [4]
>
> Hmm no mention of change to 3/16, unless it's folded into one of the abov=
e?

It's the line with [3], but yeah my bad, i'll try to be more detailed
with these change logs in the future. Was particularly lazy on this
one.

Thanks for the reviews :)

-- Nico

>
> Very important to make reviewers aware of this stuff.
>
> It's also worth separating out things at a fine-grained level, really
> everything. More detail is good. See [0] for example - I practice what I =
preach
> :)
>
> Thanks, Lorenzo
>
> [0]:https://lore.kernel.org/linux-mm/cover.1769198904.git.lorenzo.stoakes=
@oracle.com/
>


