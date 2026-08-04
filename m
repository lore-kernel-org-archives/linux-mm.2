Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10E26C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301846B00D2; Tue,  4 Aug 2026 09:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8946B00D6; Tue,  4 Aug 2026 09:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2476B00D8; Tue,  4 Aug 2026 09:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAB376B00D2
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:43:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 797EAA106F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:43:57 +0000 (UTC)
X-FDA: 85063705314.21.D58FD9E
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91AE9140017
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:43:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=F1AWhHbH;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of luto@amacapital.net designates 209.85.210.179 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785851035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VAxXDfQTeUSwzSc1A2mLr5Ub4YRI9H9bgObn+nrblJU=;
	b=EQgn77wkufavVshEumOJQuconHx4OBylWZ2/rThVYZV9uiUElszMfMeYK/htoFQsSq4fYd
	sHr61V1LW3C2kFezeJDtck8d2MMu6EWPuVhqo7BkD5a3TvK9/Llp8/DKHBNXxwVwkWlPKa
	JslvpqGVKtnFpj3PNPPOu7vaFmLqQsE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=F1AWhHbH;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of luto@amacapital.net designates 209.85.210.179 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785851035;
	b=YapmKdNBdI4kspta2VLVcKcRnhsbEX9HTle/fFfRcmUUK3px+sCK2tN2GR5/MhICILsJU8
	xptADlqjjjCunmZvIrIqANbTmFGm9N17ruRtTC82LEEW216L2Zjlby9idHKLSxOvFRlj7a
	qpub3Ze6GXfP+dZ1ZzJAccyOOg9Ewcg=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-848743155bcso1822671b3a.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 06:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1785851034; x=1786455834; darn=kvack.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VAxXDfQTeUSwzSc1A2mLr5Ub4YRI9H9bgObn+nrblJU=;
        b=F1AWhHbHbxOgllYEFk/ALpoOQ99jvdwTsDZj9vVs+I68vMh9aEGXl1SmZgotGykOhM
         S6GkQvAzHrDWr2XrPWhWuNejKBSlO1UAao1BfHbmkBWUMm2KFm9Ftr4coZseDqp6kbOw
         l9Vox7TZRzvPqWev61SCo4tXRzQYZKwhoIMtzVDQLr6fPZQh126URwiC5iLGv3xhBqEy
         kgNzirZcMoX1Y0rIko2C678JVXkzbVikgnHjf3fuJjWWgJQvQI99ENi8bSO27o1esjzg
         5iuLtYTMu1cxzz0Ohi5/qh4HXNBU4L5s0kAsrT6me+ZHj/rmDHVuIo2WK3TFT0SVhRIe
         4Bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785851034; x=1786455834;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VAxXDfQTeUSwzSc1A2mLr5Ub4YRI9H9bgObn+nrblJU=;
        b=BjfMk7ab2cUa1RAku27Y6EpX5PE4ZuekEDthkq1RMPesD2mrb32ffNMPQwzuNOYFeD
         UQ7B5i1ZJR4NjkWTTIxRBPSiqBY23SDV+y2B0qpI4bJjTAQlJ4ydsv6s3Yleck966lrB
         q3hzOFrktZrdU/0nVa50uHevqsPKXFRjvBEBepoQwnj7SQO3JX3Oseee938lfYt+eSeD
         kar+ftAOx+hC/tZcWOmveUT/A4HIpwT1Z0UnWysjtIckczCSFTpOYQQeR6QEjJtMtBS5
         PGRSPwB5DlLW1l9cL/AFmoZL55SpAKS3A5hkYaKyX9gVvVRHiQ28eyJi8JhFH+s+elyy
         eVLg==
X-Forwarded-Encrypted: i=1; AHgh+RpjcRCAuhxJ0l/4qwcGNjRBTRpuOD3vAY9Dr4eApb6vF3MRbcrs4qC6H28tWkTfvJonoT9+mFGX2g==@kvack.org
X-Gm-Message-State: AOJu0YwPiyZeZRoucKEL0QUUdJcYKpzXyaAj4nB/WWz1voaHCPqh92Pz
	UgA7davSXc8b05LKE8H74H3wZzo3BJ53ov+5UTb1x2Hs/GgDhY52KHazZqJM+zJOZg==
X-Gm-Gg: AR+sD11EVRVkhrqQj72eoTUbVIuCcTHI2p78N494UUyOGs9hHeFDYT8xYIklntHY89J
	iEMw/WQn8OdVYxuz2AwTgeIOlESAVoEflPHMQ9V6RrhYTM3MmV29cIT9YqSFMyIdGW1TvnLJdRH
	dSoPpC8EZFBOoesrWAGvOLxxHwd9Wor4jY9mEL7aLYjjT95UouvhIJsnAfqA0JWO07mq94B4UPL
	5D18kgk7ukvTINKRErSxM7wcjqXdZb3PCfQ4Pz4c50W4RLaVmNetHcbUPbY9SHeQDQunmLTU0Vg
	yK/nHx4bcT4RcRa6+ii8fDbgs8Y2xdikMS4+3N+0QbelnsrMdoklyahFcwp2XvikqrbQwxT94pm
	NthuZBqrKBIpijW2RVOTtfp1LqjeYcTrRv/gv8xnPiTD0y413iExwvCPQeV6cVDJxcUfLYkAA1Z
	Wx3BGbZ6rA1K8sEyP+GgKadud5EHgIGVZsABkdozh2I0/vtjLytzQnfQDVUfW/YucZxNFwFaz6d
	0c3ZMZO8UFi+QRF
X-Received: by 2002:a05:6a21:9985:b0:3c1:657:4c95 with SMTP id adf61e73a8af0-3c92a75a3b5mr15448830637.15.1785851034479;
        Tue, 04 Aug 2026 06:43:54 -0700 (PDT)
Received: from smtpclient.apple ([76.14.8.147])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315863b0bfesm5304154eec.3.2026.08.04.06.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 06:43:53 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] Fix incorrect flush address in direct page table reclaim
Date: Tue, 4 Aug 2026 06:43:41 -0700
Message-Id: <0B39A63B-3697-4FEC-B6FF-2F4D5901F7E9@amacapital.net>
References: <3d3aa670-76bc-4df3-9c36-609c14354e9e@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, luto@kernel.org, linux-mm@kvack.org,
 Liam Howlett <liam.howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
In-Reply-To: <3d3aa670-76bc-4df3-9c36-609c14354e9e@kernel.org>
To: David Hildenbrand <david@kernel.org>
X-Mailer: iPhone Mail (23F77)
X-Stat-Signature: 1efu9mqhhiu9jxwqdxbxew1btpa91x1q
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91AE9140017
X-HE-Tag: 1785851035-994198
X-HE-Meta: U2FsdGVkX198ULD7wy2DEmCppNPsrXik/66XV/KL7yUymSIre/WtgquntnhlXPQGafCznCivbdfTz/A51PABCkvMPiAexRNnEyNOO+syjFDTXkZ3t0VsFygtF0CSOVw8kfTM8PRl2pBmY3tls1G4VvoDT9sK9anYJms0IjYoVbl+LBpvh/x3B0GEobdLI8dIDtzTNIUo+qHxkzh3RmbKPtsCv4Jlk2xX7dIUPCEFguqUGfz0bssAbomcZ7xiG7jgO3JbMjwIBkEWoGA3wHIPv6Z92Qkq9773m62bs+O9U4dO59USoksY+UJUJ5IXEgISwvd8rR+LbCrkHIaovS8O5lh2FdnRvQPCk/aYm6gqYhChFbLmWMyU/2BSF2cajUgytDq2RzqiBRFVERSniPJD+UZTuYtN1ULuML0n6mHdJp4cSTpjniisC4prkROEDSD7LEVGJ4sLPTtR7UdG6RZkE7lM57W6fYlJ8AN4Fe9MjVoMWOd4/BjSuoTwAocSz8HVkdCc35Hdf8QYtJX9MYsngcjAlDB6X2IttovYy/ARgz7eXxSuiBuP5mXW5uZQOgTflojxBW9aD4xGf6dcO1Kpw6dTYD4W/YGuFngkVFrMDoLlpEuV/FyeKOoitn8Nugo69fbrz7QQTUWFOBYeLhnO7Jmnt94QXPLod8sKlSDgDHbO2c4NCXSsdH7T3wXawIhEi0truz93j1sYID9BeJh++QJHg0WkG7gdo6vMzDTniIrc/xMDE/Jf1O9ZOXcFera7hgbPer5B8o/45nYZJkMAIUcvoAIHpQPL9U/bmba1rVNw90HmlolLD6/MlB2a2nhynnQXDmNyD7OPS3mbCJhmrCn6Cb155LecRtk88b2xGeQCXrFPr/IfIpXPDHoVF65vZR6Idz8+qHpKXofShVEMuHIqreroFiTKnCknenLAZEfWO+4WY53R4cGJRyEserQnEmwZvWEpNr4f4/1I5EG
 uaWWQQJs
 KHGyVE5vZW+5ZHPMciquP0DRQ9obFEZn2LmmrpVUarup9+ChB6jTRkd5nJac8g3QOMfeZBxQLHKgArGIkfiw4OzFMhNGFFI28RRkhktsrBHRPJdDytzC2sGuP1HqKthZKDgB95TTMg0FHWT9L0OaqtJiz80lxc65iq5phi448QyRL58Rjgjt0SS0oZ6geHtVq9rl0YvFgAxYKCfL4S/OroN1/ADmbO8EbauPPC26vLm5rf2I+fci9nQqICZf+yIa0Nk/QOnXMvPU/VrZlZqFnfHsY5XaVDwWd6cDdw4dUYDKjEmwvVcPhn2Pi5O3xS0oBUemQo0qKZGtRyV5LBLxY+H5fuhZoAIvW0kqPDJI8z6t5O2OZePJ/M10427VNzgKWvRO6Id8sX7Yugc4zp/yJVDAY0YyekHzbXH2DwQCLWlKmJwi/Rxz/DjGUAVTK8zxGsJq2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> On Aug 4, 2026, at 2:34=E2=80=AFAM, David Hildenbrand (Arm) <david@kernel.=
org> wrote:
>=20
> =EF=BB=BFOn 8/4/26 11:25, Qi Zheng wrote:
>>=20
>>=20
>>> On 8/4/26 5:05 PM, David Hildenbrand (Arm) wrote:
>>> On 8/4/26 02:37, luto@kernel.org wrote:
>>>> From: Andy Lutomirski <luto@kernel.org>
>>>>=20
>>>> When zap_pte_range reclaims a page table, it does:
>>>>=20
>>>>      pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
>>>>=20
>>>> and this is unconditionally wrong: if this code executes, addr *always*=

>>>> points one past the end of the range covered by the table.  The addr
>>>> parameter is used to flush the TLB (really the paging-structure-cache)
>>>> to drop references to the to-be-freed table, and any architecture that
>>>> cares about the parameter will flush the wrong address.  (But they'll
>>>> still free the correct page).
>>>>=20
>>>> I think it's worth contemplating why the kernel works at all.
>>>=20
>>> Note that this only triggers when someone does e.g., a MADV_DONTNEED ove=
r
>>> a large enough range (covering at least a full PTE table).
>>>=20
>>> So this isn't the ordinary munmap()/exit() page table reclaim code.
>>>=20
>>> I'm still surprised that it took so long to show up; likely we need more=

>>> targeted tests for PT_RECLAIM that
>>=20
>> We backported the PT_RECLAIM to our internal tree a while ago (excluding
>> the rework patch being fixed here), and it has been running stably ever
>> since.
>=20
> I'm wondering whether we should have a selftest that triggers this exact s=
cenario:
>=20
> (a) Populate page table(s)
> (b) MADV_DONTNEED to reclaim the page table(s)
> (c) Allocate plenty of pages for another purpose (draining PCP where the p=
age
>    table likely ended up) and fill them with some data that looks like pre=
sent page
>    table entries.
> (d) Re-access the reclaimed VA space, expecting re-population of anonymous=

>    pages.
>=20

If you want a better chance of hitting this bug, you could try:

- First DONTNEED the range in multiple calls so none of them reclaim the tab=
le.

- Then PREFETCH the range (or use your favorite speculative read gadget or e=
ven do a real read and ignore the signal).  Maybe also do this from multiple=
 CPUs.

- Trigger reclaim

Then do c and d.

The result might be so specialized that it would be of dubious value.

> I can find someone to work on that.
>=20
> Any other ideas what we could check? We could certainly also check that th=
e page table
> was actually reclaimed during MADV_DONTNEED.
>=20
> --
> Cheers,
>=20
> David

