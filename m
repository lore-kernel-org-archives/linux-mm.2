Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB24606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dQeKx4Kw
Received: by kanga.kvack.org (Postfix)
	id 443916B05BB; Wed, 28 Oct 2026 14:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CD846B05BC; Wed, 28 Oct 2026 14:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2472C6B05BD; Wed, 28 Oct 2026 14:51:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E71C56B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:51:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 723F01201F9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:51:09 +0000 (UTC)
X-FDA: 85372927458.14.01565B8
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6BBE0C0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:51:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dQeKx4Kw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793213467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsxFQdeZKl70TZpDvN7IvbuYmeaB4nmztdIPw08KPJc=;
	b=u0OHYY/1XYj61tCfYNh2zxzHEUSevbF0BhBGFVOjGsGqWoxLLAALUcw1Hvh+m3MTrceCy/
	i8Bc9zOVzmwSiaxOpEXRCOJ4DJoZIlt32kYS4bYpUsTcd3V4kDBYmM2/I5dwxpYAKcBbjE
	ey9Twq9vvKRWudcViZVBqwVFPmOcD+I=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dQeKx4Kw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793213467;
	b=q7c4xzE6zdJvHNK5fXI6RP4vNLktYsBJLzHR+a87EoY30mE9/WUDuktvBzf0/BSZr2JaSK
	aU8eUvpqXIRZfNNGUXT9FKH3Sk0gxyUnXsFbMabg+yVMcpjyXSUwdA4I4ihbQSKLc1HZ7x
	yItj0Et0KC72k46ZMgA+YDCndDlz4Ds=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48c45111bebso666079f8f.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:51:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793213466; cv=none;
        d=google.com; s=arc-20260327;
        b=ifdK9YdwQohrMGmZ5OWgGXWbgw0wgSPESGBpad2GJLIVeSEmYJZywxYuc9GMSA0IFA
         LCEAEiyQnlxJfIcdMKY6HavDMBH2RpNRqhBVnTDOemWeCigpiiMYGetoQasy3OqbqDwN
         7DjMjiVl1ZO0yv8ytfZ4oNlC2xYYDb4zZfiHlBxzvQyhU7ztJTaHpAaSl+H202E/pUr+
         +/DJKGMrJR3wf3yWI4sk80iG6uU7EEG9kPlpdDr2jOM52f4sZS6AsAGW5h0VzzIUjnCc
         8k1lmufDGY1co2nCa363uqge1NXheDeAP5bNtpMCnwZXrn5Iistpumnz76NwBOKXIPfP
         1cAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YsxFQdeZKl70TZpDvN7IvbuYmeaB4nmztdIPw08KPJc=;
        fh=IcNtxmNDRXutybTTsULkVUjF2vSoYJyXkCaOSRLrARg=;
        b=CLSeyq1si2fmVFMoRcnE+ZSXe7X5fiu/BHWujk60DhxP9ULYUxSEjj+aXcz47SwSZ9
         fpMPkArkb0luPq/1vIpwieOZp7IALJgjrrEgqB1/NC50t9WDOOlPH8Axl6jN8bsQjtwk
         uwFH6PDaossaiU5UG5U8vaa4b576YZQmYO2gchuvmEOjn2DveF4jj+lIUV6HsmcRtTRR
         zmutpAuUpwuYpPpOrRQoBzoeun7jwEEKlkfc2ObNT0X0QJpC/Qps2Bf1IcNwkxFNVenX
         lVhm8WFCU2AjDlw3zTOADEqL1Vqb6vqSWcwtZ5bH5bDF5uHygY3/9HAjib78shO4CGa3
         v2Og==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793213466; x=1793818266; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YsxFQdeZKl70TZpDvN7IvbuYmeaB4nmztdIPw08KPJc=;
        b=dQeKx4KwCcixrcybGZNVQ4WPbblcfv93yV5MfbH/q/To0JGk9gC18/Dsmjne5gLRlW
         k1BZ4P/PFuKylPCyN8x5tpwCwj8JOP7mAscBIwldEyCk9Hvx9qbNpeo596ZG8n2w7OyA
         c/xAoB3VHRhBB7vu9vadgRlInWRUylTToi+plk6jPNRf6lD/JsJqFmXPuWfSzjeWDKnZ
         W4t3B/+h+RirPISG0B+rxay2ib94I/Ot4dzNdaL8xF4i5c1xM1IXPCHWtakOf20ATgOr
         49hr/mmyI3QhG5XZeBSUYbnODjujNyQgoXIbIwuWZ+ugDuXRMUTOawLm7sTsS9RS+qow
         ORGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213466; x=1793818266;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YsxFQdeZKl70TZpDvN7IvbuYmeaB4nmztdIPw08KPJc=;
        b=HHQKb+S4x3UiioQTmYjJ24YsIGqn5/oIKbMs0YynHQ+Dxxe6jVa/ly8KhHB9T5iV/H
         4e2vmiEUZqDf6YDc/onMtKEU6TG7wgy+Uyles5k8SemU1OhC7BbLac8HX9vm31+xOIpJ
         rlDirYt4EwTNFxxU1GWWjfPjjAQCCdYvoR6t7w8Az2PM79hxOZ8f9gPkjSDHaATp5WFA
         59UUKix0bbzf5kzJ35prfw2X1gaTCRpvIPNmbQrGQI7BdarqRQ9W4fq74j7cVusA0OMG
         bKPLsdIdVxzA4/VtWB/iSV0kkscCi1zg7scVyNf9/RstlDPPxQtEdGN8msI3vQ0htpvX
         dN1A==
X-Forwarded-Encrypted: i=1; AKwUvBx+pfiDbihnLrlH3Ni9ukq0cVEgv2Yz/3begsHwFkx56qET8SKorVWeRMjt+8bUo2QWo7carXykVw==@kvack.org
X-Gm-Message-State: AFq9FYKb5XCP5AxyPpGqZ4NkBBikmlcGuOmQFKBzut/uHdQHbmGvLIKM
	Yu+OKuVe1ukdL6CcBxy0tQXD8Hdsq9cys+WhbBji2t4kiqBXih5QDOU1yHEK52wgGk9lf//eVyM
	VYDtiQuSMynauYdPC0b0ld0NJ+HMGbF4=
X-Gm-Gg: AYBFou1iLw18UhIGJC0gIJjzdoZnJaACtihOSBApLQlrrPgzy4vbCe9hJzIGUGyclRL
	mV+Dxnon1p0omnV/L39E5qme8UIvz5PTwAEMh87WfF3o/YcK4O14sPyQ+RDwkiCRzGlzionmV2u
	2UXl5CmF0rawSYuGrxlOtJpRkwvL4Y4npJmHapZkiCWmps+66zGefpAM4Txpa+Ln2/ulRjbIg8X
	5G47+8oKF9VylNZaYiRJq7ZaoBasAWW+NoJjJ/i8uIMn2pGijJoUWVinvrJbHCKIdn5sLbRhSfl
	/Rd47msATpo3sTo6yf7xZvFMWk6EzvI1jShBxb27OXYGnHxdfzRYZTlhAHu/GOPg1fDC8lH8rDU
	qyJHIRu4b/V24YIV0H6iEzn0nLnjoRDUUL0YXa52UltFQyexleyNoCfYtCtJINAdmrHxdEY6g5X
	CNESqb0d/Cf3nW1LUQsNs0Q4v7FZ2jNYrHh9xr29SU+jcF6uxFkTdw
X-Received: by 2002:a5d:5507:0:b0:48c:6fa4:fc89 with SMTP id
 ffacd0b85a97d-48e5d2e704emr6315682f8f.12.1793213465946; Wed, 28 Oct 2026
 11:51:05 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
In-Reply-To: <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 28 Oct 2026 11:50:53 -0700
X-Gm-Features: AclHuK-Cll-04Q9PCKTnwQsH04kXEbIsuiNTHafay22oqcGn_p331RDj9A27JMY
Message-ID: <CAKEwX=PEkQEap=KRsutwtuXp23=zoeCNjdk=4rcLJtO_3ESFJA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6BBE0C0002
X-Stat-Signature: kmk1eep5afb1ed9oxzusckb8xuuin3uy
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793213467-119997
X-HE-Meta: U2FsdGVkX1/aKzMtRtnVhgEK3WMGLW4LhHmmjy78IGQUi3uuNQFW+DLthMvQKgTtinCagb6CWtjk2eXz7NrSAwWz2AJN+Qrv1leY++MClUXjR4Awi9TN4N4v00m46nRUkA8Vo9EnwjpQ0vjkjpyV2x5Tvawm2Rw7aGFvIRBzDS2l5tLluRJYoMFVaU7nyWssbZg4YcXq40pYE/iLU0qSf7KiplsLpoL0lIvC9BTjovIe90k6ZDD1L/8p++/1aiotKuXL2Lh38AbkG1OAea/0qDY4PFolCFgoTrJNdWBQEYEdnAkBZVrnfr1rdAJ9++gfpsDlLNhhaZDUKfaDNIfpQk0M6TN7I+Vf2cbbfkDhZe/0B2UqRYaUriF/0srASYoBH5g1SbwLjPaLtcU5uN6tEPoYZ7qsjl2onu6xhlgcvuM7nv+ulh0oGmRCfYyrOummf3N5DYJBdstSHTVeaQE8/2J68TFG5OBMQT/JDmU79keEKMN+nzzqZfzBVuQEysrVwybISrLN5X+BloRFRru5YLAHwyIBzDSi/tK03KwGqoxJDA5sUkfD3HbKg+DmVmcx6iB23oJilLQWIM6lpX4/UqHTK6/bc/RCc1z+b3mtNpUD4WufN5dVL2n5aY70X3UtZ3y0gJAKcho7jYStRP4OZHspab2594KQNnbvAjuNrBIVH/pGUR28Zg4FFDhjbQRsKR5MVjAylLPQIj491OIy+Ki8GIuMUUMltEVJcZBGRtp4vz4Wn0mLCQFVquJ8HYVRjGPsjnKeKG+iJ3h4mJrbIg63NsEjSYHOBe5O6IVnkBSxW4NMYkRRU1vPZuT+jYNMLyLcoZBDMm5SjCdcRhZdmYfek+sfC/EDRtyCBNzCRrO37jJn8k+qt7sOlZXMIV4CusaaBNtTqwceA57tY5FnyUD8Me8X7i8WrBgdfDUKKUaNFTFYZsaqj24GKarA7bfzduhLH6EABDhJz911C5c
 i+s7GDVZ
 yhOcqf6sf7amr/rxdzzpY1IwbpmG5DsolDw8pznH74fgF8yBhQQw4L+4v66vXmvM0tWBb11Y45J8OtKtLAXNwqMchOi0mJBdjcNZxGlMt1dNZqWWPgBxN2xZaNpIq8xoHE/rrkJd1s9KcZaQuA5L5Fa5fOpM9bUSUG4DA6rEu+2mnYx6fRSOCnVrlVb1/ZWxfizztxVNTH3pqqg80IQsNoBsDE7XuFylqZ9d5wEF3dslWvQ6/9NQr8UQlTptZ0SyUgffk2Yi7EJhyiVYUQ8l3z0gpD2Okk4p0lCKhsBjPFOcbThwB94jvLTschikI5Ytcy/+fER2snFdJ3TUuCfXznt3Dq2bqHVzTnFv1R67K7rEmSGAktLKon9LdqJxeKfh0S5SNyke+bNczuhauw35APB4kAmrsWrprcnWQ60kX9HIdZGYANvB+XoYeoI+zfhSnnene7ZLPeLxeRQ3jeb5R1pV+U3hOVknKMo8pAR7bjEgGP9/Uqqh5aFCo2qPT3zstM2RXOe5PUP9ox9WaiVuLqSKNHnrcdrGh8ubudqMVK1HJdPvLdpIa9cz3XZIghPIQSHni
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 10:24=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 10/19/26 14:24, Nhat Pham wrote:
> > >
> > > I'm traveling this week, so it's a bit tricky. I cannot make Thursday=
 morning.
> > >
> > > On Thursday I'll be traveling back from Cambridge. But hang on.
> > >
> > > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.3=
0am - 2am.
> > >
> > > I could just naturally join that day.
> > >
> > > So one day later would work for me.
> >
> > Would that be too rushed for you? :)
> >
> > For everyone's convenience, this would be the time slot:
> >
> > PDT: Thu Oct 22, 5:00 PM
> > EDT: Thu Oct 22, 8:00 PM
> > Europe: Fri Oct 23, 2:00 AM
> > China: Fri Oct 23, 8:00 AM
>
> Hi folks,
>
> Thanks everyone for attending - I didn=E2=80=99t realize swap was so well=
 loved :)
>
> I took the liberty to summarize the points being discussed - please let
> me know if I missed anything or misunderstood any points:
>
> * Swapfile sizing: Kernel kept swap slots after read faults to save IOs
> if these pages are swapped out again, and thus needed swap occupancy
> (and hence static size) for a heuristics to trigger reclaim of these
> swap-cache-only swap slots. However, this is not useful for fast
> compressed backend, and zswap invalidates its compressed copy on page
> fault anyway. Vswap does not need this heuristics because it just
> frees up the swap slots eagerly on page fault for in-memory backends,
> and rely on the existing slot reclaimer for physical swap backends.
>
> * Logical footprint limits and charging: cgroupv1 allows logical memory
> footprint limits (unique page tables). Cgroupv2 controls physical
> memory and swap resources separately instead. While virtual swap
> entries continue to count towards memsw, cgroupv2 counts only the
> actual resources they consumed - post-compression size in
> memory.current, and nothing in memory.swap.current. While cgroupv1
> continues to be supported in its current state, a cgroupv2 transition
> will present a problem for memsw users that still needs to be worked
> out in some form of overcommit control.
>
> * Swapoff: this was brought up as a request, but we ran out of time
> before we could discuss the motivations and use cases behind them.
> Folks interested, could you explain as a follow-up?
>
> * VM_SPARSE v.s xarray: no performance difference between vswap v.s
> part 1 of the xswap=E2=80=99s patch series. With all 3 parts, there is a =
win
> for xswap, according to Baoquan=E2=80=99s testing.
>
> Let us keep the communication line open and coordinate on the next
> steps.

Hi folks,

We made some nice progress last time, but I think it will take more
collaborative efforts to drive this one through :)

I'd love it if we can meet again, say next week (making this
bi-weekly). Some agenda on top of my mind right now:

1. Use cases that are glossed over last time (swapoff).

2. More interface design.

etc.

I can bring some concrete proposal to the floor so that we have
something to work off of.

Regarding the time - would shifting the meeting by 12 hours (so that
it's morning in NorthAm, evening in China, and afternoon for Europe)
help European folks attend? I'm fine with the old time otherwise.

(BTW, we'd have 5 timezones to accommodate, because where I live,
Vancouver/BC, will be in its own unique timezone starting Nov).

Best,
Nhat

