Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38826D58CC5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 04:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D47E6B0005; Mon, 23 Mar 2026 00:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137E56B0088; Mon, 23 Mar 2026 00:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A736B0089; Mon, 23 Mar 2026 00:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB33E6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 00:29:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51D451609EC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:29:49 +0000 (UTC)
X-FDA: 84576049698.28.68F32D6
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 545AF140005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:29:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ER4KR8W1;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774240187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otZTpvGKCcuyL+5ZI08WO9k61dKZ8I5f3HXdDFzO2RU=;
	b=OzWitvVVc8C7v2IbsyoYA8XwxGlH5xu+svIsWSk8gkyxq4U9p1ZiYWWl4CYvALmIRe2jg+
	H3Ig0hfS5xx0iTrneCw055H8C7p7XIZWM5kSCkI5PK1/fcs15BmvfwFy0ro1nS6ltoZYov
	QjBSbJZxEgkg6o1OINU9YQ3PnF0u35E=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ER4KR8W1;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774240187; a=rsa-sha256;
	cv=pass;
	b=qEvxRY1PGWHy3AwqObVfyfsNSzabRPGhKUmncUZTFLvoQXP1dRPFpmdWPp9i33fc2+rtkI
	xTQ+quwkzFWqKtciBFimokKmxg9HpF5jvGh25a6S37Prv1SjVOB6GBjWA4779nGGwBd/R3
	iYlvI7s49yrxv+OxAL9rbAMou6nRUlo=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5091ed02c54so888091cf.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:29:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774240186; cv=none;
        d=google.com; s=arc-20240605;
        b=Jfo4U3eSDFcFm1RoGr2/SVI5KmMTGRzNKxeMgYwR2TdxOP8rn3g/YVi4TooiqT1uja
         M59wkNO27XGuG/sdTX5CO8ZJiGMjx3mGcYojnYfpcxkYn9nV74fqNmQCXZJRkQBm85Bc
         H/4S34nV6LRdIorvc84VAlj9OelE/8qekxrY7bP748ixbCzXxURP2RjlAAWjmugICMzH
         uRXmqMKabNJ2hSiwPhT6RJhX3CMspaVDP0dz4kNViq6XBHc/G+d2ktZnMcizLzGeUqlx
         XRA9nJkoN22YsdAtN3MisMscckAvjuzfN6tycfbDrxnt93lI84iPr+4wI8MFriBSoVQh
         t1oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=otZTpvGKCcuyL+5ZI08WO9k61dKZ8I5f3HXdDFzO2RU=;
        fh=8hO82VE+vXIypSmgPQl4P5lAsqOEnp+GaqhFnvcR84k=;
        b=BJOX0TS5Xm2BX4EMAR9urrWDBKfucabq8ILfkDO84F35JoenWKEst6DYQIY5WKSOrk
         3OcN6WCzBvSfVEmgyNfrBNnSRXQBt9+iPc1VDizhtbNElWZdhsqoA69sTfzZJ+s5TL2K
         z9lY1IrsRGowRc0vlPyknTtPHPkycizbROtzkt61JL1CWWHcH9B0FirD59PKYUH++JuI
         3ev8HVdjwMFqp+saWHyh9WXvyLJzyjXu8s4G/EtJOXA0/orj1NtheuN8aO/tFo6IPYVc
         v6MFQWgQc0izhJa2qDxeTLIEYfwzU2WUtFhqX+XfZB5Dx4qqC+WBq8yCeMc4csD5Y0qm
         VO5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774240186; x=1774844986; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otZTpvGKCcuyL+5ZI08WO9k61dKZ8I5f3HXdDFzO2RU=;
        b=ER4KR8W1IWbU4MRF1xct/Ur75gG9R/u6dM7zR0V6Md2XzOKuIJOlhn1D9dGscqiEy9
         QhhT49PdCQiQQlu6YVeE7PE8EktgfLTvE4dkezetdl4riiH2rE3snCEDfYAhp+0M2z3u
         qXIHrZu7V3y0Ev793khIgTV1IpfIqAqcn20H/rqGOIBX9j7DCSAosR3pGuwu4zr2GG1j
         +kuqRT0QdH20YDGk9brw7bJ74bJa7KJ0ra1884P/OWt9yrPS1Uzaia5XCU4o38SNSIKV
         W/aIq2EnW2XNqxpwSrA0mqTi8oAPklAZa5TqEYLh9bcRNoddu6V/uW21g9kHf8W0VfuM
         KQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774240186; x=1774844986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=otZTpvGKCcuyL+5ZI08WO9k61dKZ8I5f3HXdDFzO2RU=;
        b=eG4sL4uAtx9CrJthVnDv1/XUiBHbDgGKme8551c3s5b5ljp006BffMHasR59HKZnx/
         QvyfZG9AB4n0grHRvU2RYevEHka7peCQO4Em0EKaAK715oAFHRbq/cgzjSM/i/GbNE/x
         YrV9KekAhuRi33TFbRdeIfHfG6SCcHB78vHPnj74LSTyRU+4Ayah421MWuQc6nD102rC
         IlK4E77tP0J8wioCdRQBKPINF+MpvyZoUnAJrBZ/qIl47xB1Ln2IqtIdl+zYKowRtgXM
         JO4b3Bun/qddKSIKH2zJu5Ov4Du9z/FpO7G+1eZ/AJSXY9UhcWsTAZ2b+QKoZdrWBh71
         IrmA==
X-Forwarded-Encrypted: i=1; AJvYcCWcLYcr6pqroRuCRPcW+tYgEAlMU/5Dstg6n7gjRNLGBQucl6/wHdQhDkJcHMF9u8cL2ixtU6Ziww==@kvack.org
X-Gm-Message-State: AOJu0YwM39aWcRk+HZ6jJCFuRRWsgM7THPFR+T132SW52jhcKRoplHVo
	4rkrATG/D2b0anwScI1BSeO/7JFLlHeJR/Z020ZMY2S80Ypd1lNLrCKH/7canbIWyhG3lBaO0PN
	ib1TdDBjEYSMKKu8HDbFZFvvqz1xGA/9gBoKarAHm
X-Gm-Gg: ATEYQzxqxx2XDAjhTCjPYUDWZd0T+hQq5IHp3IrrlcRokRPGgVNihZp4MjxYOVn1cqp
	nr8A4xCFrwzxBM0fIFoo+TJV9TxEu4gGnoKjbXZlveTD88A2QldhUM89VyvB3ZSGTymXkz+xQvx
	HzNvsZWPGKpSrvmUKfFnznZs5A2C4RvbDxNQ1vYYzixGlOi1yGfMJm5v74g45YmjJIdnbYBX3dE
	JMDrt0e2O1tHLwsjBL6L7Ta44eMpRAIXjM/FC7LfMakEfLtvIRsMqlCp1g2bGcYBJQbu/5uoguZ
	hZ57FA==
X-Received: by 2002:a05:622a:5597:b0:509:123c:f317 with SMTP id
 d75a77b69052e-50b46a6754emr23046811cf.0.1774240185749; Sun, 22 Mar 2026
 21:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260322054309.898214-1-surenb@google.com> <20260322091723.dbc1a8e45f4412fca43ba510@linux-foundation.org>
In-Reply-To: <20260322091723.dbc1a8e45f4412fca43ba510@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 22 Mar 2026 21:29:34 -0700
X-Gm-Features: AQROBzBY2-_fJYphsyTdxWc7XCwazEP7y-d_Omc4v7H9yVwU181BEprIAh7MNYs
Message-ID: <CAJuCfpGEA17hB4BMdr5a7=NxfeF1RUt0q=_w2WieVv0XoN24Gg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Use killable vma write locking in most places
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
X-Stat-Signature: dadnz5diuwgkpnjgds4pnjg6pngumnd4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 545AF140005
X-HE-Tag: 1774240187-936309
X-HE-Meta: U2FsdGVkX18xgeCapql+5efq8HGAxILgAqloAYU6xt8mVhZpF5ArSS8DwetYk/2wf1IZwR2lA8mbEzJNjauFDXYHaGy7W8QenSSLXLiE5MRh7ACeJ1i89PytwypZL1pkEB54ShXh60vbJqy8hIrhZhnBaiSTNWX0fs01yX6VagGiGuLyq/IEgye7Ls6UGY6+BlCAmg4Lc9Lw93DOEEDImM5Q+MzweNstV3FNxme8s6ETFQNLV211/OyNMyd1RwuquXhss3Ayn49JosOVel4Had/zMRVRP2kGjhpZjRehI3esa4ZdKBW6jcA7wcW5nQYb6f4Q5MbojpbMQA8oRI/foCzVwzRMTLvzEsy2PBtkwTDxs1tqDMfEwKdjM/LWRhOUbo9i/tVqwb+rBLtXqVHqumoctK53KMQEb5B4TBXGZ+7OCEV7OVS/Ti3lEU/3v7MaUmGuPLBGmZFm/8vEXPiPWajp+a30WzBcVXo0SmSX8xebrvjjX4gNGUMAX9Owjl2ouvScP1FZfMq9lgqpOj1IGVSXFrr1r72hyhyTDQgGuRSuCjotc2eLE84J5q2IDV1kVX7n5yAYvITerpl+bWdc2RXUVtCs99ECnNNeJpVxc2D2WWU9cIv37sdniDnN23aHEOJozCabOONi+xn+Q7hWpJjQa4WN2h8lOZFcMXg5uQ1mxjrwVxMceyoW85ZPajtu5GtX2FBDDtyUNR3GjyT4yh10vViFSjXrjGZjXyQaQgRhqKl08pW6BXfGgOebsdfG2JQ6Y4w7nM4+5HM6S0BLU4/VlzwMBHwVrHr8JgYuIHEwDuVop2gS+8GlLbuCDA5pKFmkyOnjucp6HSh6R3uoRGbXMFKZEFoBOoDZrde/zdtVf0DqSoLFIbmEOB6czm5dx2o2rI5Z1PDF2wEaYf9+wG2UMB68EaCf7TlOowRjrDWXMTMf9zdtu6ETGJZZ3krHnE1N9G9s+UJ+U98c1Eg
 HFmsu3rN
 DHD4crXw1wpuDeA+hErMT5OA+YwfzwAnq2EHBCxnI/mGup0vUH0Y/ysPrSo3zGNyTq1ZoF6JdWpwOMfHlVI1ENnUBEWj+oPEEyrSGJDc3Q2/P+1Ja7J/PE+/DqemKBgapEcmB2Zr7ZMdvmkw4yPEAfIQTvBk6KyPzecKLOBpGGfEKc4Gn00gMVBPSorZeqURvBC+KOGhRvKZH+ARJ/IMHxFUXg991sXwJmExF9Tu9vVUVLWCJczTI7d7tHe9tgOEM3TicWY+2HwLzHDx5mpAqgimdidrGFnrMTVhF3qhfwHbCHSjKjNhKgOUbiOEm/or7zHc6uxkpG5Vg4l1IMQZ0bRTiOhNcVH47uwiNfhUwwVnvPWBGZzN2TGWxbDZKhtauypi10QW9+7annA2ddSodMauIhRmdcuD8pFjpHSS/wDUbOPt6jUuRTCnKYRzYGLY9S/x8R7WzpVjnEzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 9:17=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 21 Mar 2026 22:43:04 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > Now that we have vma_start_write_killable() we can replace most of the
> > vma_start_write() calls with it, improving reaction time to the kill
> > signal.
>
> Thanks.  Sashiko review raised a few possible issues:
>         https://sashiko.dev/#/patchset/20260322054309.898214-1-surenb@goo=
gle.com

Thanks! This Sashiko dude is good :)

