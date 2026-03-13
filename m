Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79BFD106FD6C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 03:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB076B0005; Thu, 12 Mar 2026 23:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EFD6B0088; Thu, 12 Mar 2026 23:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436A66B0089; Thu, 12 Mar 2026 23:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 305C86B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:24:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D18CABA815
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:23:59 +0000 (UTC)
X-FDA: 84539595798.20.4859B29
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8961240010
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:23:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i0P1yAnf;
	spf=pass (imf27.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773372237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyUSirNPJAnFjUFfi5pJvHSlQzaYa0PVQM56kebxuis=;
	b=aLdgQtHI908SeQ3Gxpa8yEf53I5dqc86G7bUFa50SStrzUAkk/rsz9Ut3B00bua7r9lnoJ
	FsmR4FyyqcVgZAk/yXw3AV8/tOkAC4TVgUKv2ufMu8rRauP7FSah1rrpzAsW6jSik67WYk
	wNWwwAQY6xoFSC5JFfjvjakFl0couLM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i0P1yAnf;
	spf=pass (imf27.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773372237; a=rsa-sha256;
	cv=none;
	b=GeHC1MeDNnfzxb/8C5IuSW1uVXI/HfySHepkd1TuX3l84XdjHPqp7Lwaxr/Ywufz9Syh1b
	80zZ8etRnBDnq3HNqfkeZnmVGZnMZXDp4EyjvY85MNyEc+yL9MSo92Xn+6z5F4gt+DhY3j
	67KcyHe9sroOjYYXDeIdNV1+chp2uR8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773372235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XyUSirNPJAnFjUFfi5pJvHSlQzaYa0PVQM56kebxuis=;
	b=i0P1yAnfvvt7qQ+0N1l8cyWPt1st0z1F7uizEpjSoK1UMXuOnoALvzqYBbcuMJ0n7z4cmZ
	eI+Xdlw0hU05Kghv4rjW84ewkmjVCM4rmx20xI/OwqkOvleat/87peydBpo+mj1yh9UU5A
	9qrBTOIjjsk8ae/6IuVdHBVdd/As564=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-U6VQs62wO9WzFsy-ONsiXg-1; Thu, 12 Mar 2026 23:23:54 -0400
X-MC-Unique: U6VQs62wO9WzFsy-ONsiXg-1
X-Mimecast-MFC-AGG-ID: U6VQs62wO9WzFsy-ONsiXg_1773372233
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35a032cdd78so7524176a91.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773372233; x=1773977033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XyUSirNPJAnFjUFfi5pJvHSlQzaYa0PVQM56kebxuis=;
        b=TbthgyrKyYkIywljC9tkZ93Xe4nkJdUxS5p0A0pvHSpDvaAEYfzAOJ0UN5EGJSJ3md
         A+2ARtQLzXpNn+hQ+XQSesuHQ/s9WYXy7/DRNTj334Vti6dsCNgAdZI/flBJPauPioYX
         jgvofcaj2SHd38X7iOe5a9hXPN+VirH4w9aoD58Yaxy/HgR814/HK2KSoXwe8UHmq93x
         sHJpbfU5jdb44M8dG8fdGa9G8AU9jT88WDowKoqu1b2ngJvYA76rzeeESXY5XkA0OT85
         ORP/qA5sw66andxnk/Bwfo8x4v+XRYWkGklrge+hD+HIJONZ5UdKss6bUKxCik53OFtp
         ugmg==
X-Forwarded-Encrypted: i=1; AJvYcCXKTrH1KADi3dRUXUo6JD9d4KG1CIoy50X99XHyI61kRRSEIiyWjWmzduLOzi2IIq9SVItz2KYZeA==@kvack.org
X-Gm-Message-State: AOJu0Yy3ljoj93S3szsQoa6uvOC7n8QZsOu5RQQ9zvK9xFzy7do1wc7x
	M4ehutJIx6WkrRQt1614P3017zqRFW0wwIJuizpAurfQYonLMnDrsG3jRKaJesZIz0PL/ezj2Oo
	o6rQCrkaX3RLSctClmt+nx6Cai8q3v2tU0R/cHzwI+9cGkPwHQEl0
X-Gm-Gg: ATEYQzysBBAHTufGFRNIEb+/8hg6JNH+3dNt3YufTJYaorbVJ99xn+oZdvhlGRVmgfm
	e6h+rH/l3kQdf7rIHUsUN8hCQnfyYo3rjZSyRlJRMBa7mH2jbIHlTSj2U0/kiLPF4cChKXjw98S
	D9pSXlZcHDdQu+CgpIC+T6y23EidoMdzfw/BoO03siMgOn0whtLYbHx9MrIo20jnvW2sM7CVvqn
	NtYhu8oJIXXYBdQowM9HaGcDW+0LPUovDHIkbEU35xLrUdV/vzXWyecKrja+5XoPdCV21ujxjJ2
	DwE2lBcvu518K+4KD16xaUeew6aMGNAMPNOSyTT6y73x7RBNj0poobuPssn4scACn7oLHvEsqT4
	rhe4iD+zwJOrlTAFstA==
X-Received: by 2002:a05:6300:193:b0:398:9820:f6ff with SMTP id adf61e73a8af0-398ecdc67eemr1371860637.62.1773372232822;
        Thu, 12 Mar 2026 20:23:52 -0700 (PDT)
X-Received: by 2002:a05:6300:193:b0:398:9820:f6ff with SMTP id adf61e73a8af0-398ecdc67eemr1371846637.62.1773372232455;
        Thu, 12 Mar 2026 20:23:52 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73ebb75624sm421173a12.24.2026.03.12.20.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 20:23:51 -0700 (PDT)
Date: Fri, 13 Mar 2026 11:23:50 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, mkoutny@suse.com, yosryahmed@google.com,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v2 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
Message-ID: <abODRsaeEul9Aj2X@redhat.com>
References: <20260312040627.55257-1-liwang@redhat.com>
 <CAKEwX=MqyGQSMuVCSWmhKfHju5uHBe3ySQEgK9XuKwCvpL4x8w@mail.gmail.com>
 <CAO9r8zPmV8v0tiQvn2xFqX8F2oU23mfbVK67nxMO3QKt49kJeg@mail.gmail.com>
 <abNtUReAUHT6j9Rn@redhat.com>
 <CAO9r8zMh=tAV6UJcH3hhZWrZJO_emVe4raiq4wiBEgC-GAD2=Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAO9r8zMh=tAV6UJcH3hhZWrZJO_emVe4raiq4wiBEgC-GAD2=Q@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FHNHfoOj3Ax8nfGQ3JubmVqQIcq1f3uECFG94CMJ1EE_1773372233
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 8961240010
X-Rspamd-Server: rspam08
X-Stat-Signature: uw9mztkub5pa4fbmquh1ii66kzpu47oe
X-HE-Tag: 1773372237-997966
X-HE-Meta: U2FsdGVkX1+eO089tQRRt+eoFMIftO+Y3xNyxve6GV9eNO8E9p2wMSmbkZ1uk7YQNTR/VxpX157LMtUmHcxCZ647ahtswi1oBZG1uZRb/NQt03mdfArcOlqeM+TiWW1Qv4ObyWlcX1mJ+RJ/9iAZFMZFZ8eTqNJvnWBQST4sd6dzDTaHXwW9RBDzFHMYid02x/7m11qFhT3qFpFN2d77d+6DF3BFoSL7f+OPQ5sAsxL7NLXLKEvzDIVZDiMxI1s1GETye+gGvXLSYx7s/el3ODEm86/sKgiHPeIAEsbHeKeB87/S4D7M73MYsVBOf5+q+9Qg1U3pnHL8lHa8RDhxLREOk0iTrCHmXyVl1UI4mSyTmKgg4HsTTFuR2zhJLJQmVmmEHCJQh/s4Zv0yfjb77Z24jNaVkfTSTNwXGgLYJcJfyROBG1IER4ArXApoFt02HjQ42xFNpufckzNSGVlSYypomasHGb4WW8NkvzSI6nubhe7mjXhgOoj8sXZDB7RQhSUbw69Ogqfvr3BNIuVTGyeqyCY+cyuErKf+5XFmWcgbFZFL43o/PkdNJizNCrlLvZ3tez00zhDSkC4YbvpEN6UM+RN8WR4yY+kRzm8K4swC0uUrV28FbKEEbQfMSoGjJ867zzfcQFgWcs2H2NgciJxPGpLGOuDbHKsMBdeMrXeVznzKuXKyhUXyFsvej12nt/Q2Olvblru/4jveGeFLHenugN/iZQ8sbyJCh5S+ic6rlW45XasukONR8MYrLkQYo85/GTtD9jDEdQRd8zBYULI3YXfuFkiN6Icz0GE/9VaQdd9+8n+MlYGIocdxylYVHAfVwxP5ePsJlB6Kguq/BxWzM60bf4XZ5r8rm0PPViEEjxHM9OM4j6nmaOln+BjD0sVB6WmTShopHmJsImX17p8VBq8wKm+78ofZnskjkkbDFdp+iEmIGeTKx5vN4E0KMFYeWdz0QvOmKybtHFd
 m6qUq2iP
 +HQN3b/y9+aZikOyTd9Zb2o5vUbuKgCinWlz42+YHbiHxvL/zEULTxeYLaTLlHfJJuw04yqBg5USnY1SiwcupvNjvD2AlZtGQa8UIpnjsM9V20jsSsNWVhM9C4ogTmfs81FBjOVE8DG1U5r1vrzHtXWxyPWeHCqFwD8fMalX0E8jvfecqd0j07/t7talaYwSyz4u6CpWowtaxMgfh8kd1AXatZ4OcUix7pint9evdp2x0kt8D26tdgUyaK3JZ/S4/pPDu1o4Hu8otJFc5whdYIE2iYPpltts2jpMRlgLcRvUvzh0T4WkxfOQIhVVeYDVb9BBUo+fC3ihsOLuahQ8n+ic4YiAMqkh4kQZnTdb5MqqughKmt12b4Til3M2PzlRG+pKmZN6aR19Y3QMHAiCXwd9O+MekQAz7KmpV1gDGlCrsMeCMPstSCxD+9AoYU3rOuv4I2vHcY9Yqu1olFpDMwxXp+s1Ow8cmzuiJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 07:58:28PM -0700, Yosry Ahmed wrote:
> > Yes, this looks more tidy than open it. I'll go this helper in v3.
> >
> > >
> > > static void check_zswap_enabled(void)
> > > {
> > >        char value;
> >
> > read_text() requires string but not char.
> 
> I was just illustrating. This should be passed in as &value. That should work?

Yes, pass it as &value works well.

Patchset v3 is on the way :).

-- 
Regards,
Li Wang


