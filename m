Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 749B51125811
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 18:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2ED06B0005; Wed, 11 Mar 2026 14:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2306B0089; Wed, 11 Mar 2026 14:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACDF06B008A; Wed, 11 Mar 2026 14:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6A36B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:21:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36CF98B5A9
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:21:05 +0000 (UTC)
X-FDA: 84534598890.18.351F57C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id AC02E40016
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:21:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UUM+ow1l;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773253262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cq8+tWfGf0TNmdPtc7SAv9a2DVpNwq16jsP0bVMh1cM=;
	b=jd9kCs5u3sJe/Ju76Zr/zDQE5e3j8EYiXvoymZw+vyo7Ie+ah/q4CKJCJBFFtpQDgQFw4Q
	NzTapjDI0neCdti0Z1EUSM7tFeX1iQBo0EKLnk+3W3IJ9+32kvj8z3EWY6R3anIQ1X1b2f
	qlWEl6DlMhmGk9NGJ5pEvF5czqrrp7U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773253262; a=rsa-sha256;
	cv=pass;
	b=78hcbtHuFY663WiRh3cIAmhc0ycXA5ksZ8qwuxFzBiPBVVprlwmxjhIW8nhLQlVjT/27y3
	odCW7gRaH/ZcIpsL+4R8o7NjYgNrqeD/oIAIiW1NGV23UCal9ljBo7g3gwMGlxYH2n8P2+
	mhyBZznzWG6M37eZOdqn9IZjMVPp1/o=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UUM+ow1l;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BIDc1Q2326288
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Cq8+
	tWfGf0TNmdPtc7SAv9a2DVpNwq16jsP0bVMh1cM=; b=UUM+ow1l9Ax4aODk3kCA
	f7C6HX+J1u99B/02owTapIzmg/S3suK/So7h+9shCsOsMY31YQ+ehmWLJShBDZtJ
	XSPB3SYVeDnU5cbRSko0FZu01N7ob0aWMQCkAQxNNKfYhkrHloUojrVFq2qb+lrm
	6SwDtWiAxy8bBpNfFnmfwdfuhUVGAAvvZtsQsPKsxGPE9DClIL++hxAb18jfEGmt
	XOjrspU7yPFaEr4YHZgDT7jQr7AF4Oi1HRsZTHLlWuzw7s9+LBlcYmbUdLVRCZms
	ao5ZTen4Lmub3RDeEx9C7ttLVWXnex1T9F2275PLGcL4nuBCa3SsS9N40ALWOpX0
	YQ==
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4cu7umubfb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:21:01 -0400 (EDT)
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-79904eb0d1bso3905027b3.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:21:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773253261; cv=none;
        d=google.com; s=arc-20240605;
        b=OPIfTA2ijyqwl0N+aAtoTIUQ5HBR5WrKZ6TkKwinBjEk/7ANA5VG/38VytpeJT6qsn
         QCfMZlmaKutZGAlbQogMBhU/9A5uQhZvIxBuf+xj5AJ2OqMz/41hHOj6sYFjxwvMGsuj
         JXl3rAfuugYAsSEcPY4CLzzHJ69QECvb9pgWVLFVfRfjtJhHl7g7/zBHQpHVUWWTXeGJ
         wJ7mjJ2TwB7AYqypSE+MtEsiA/aYD4ncaHwB+jAd8D2gla9ueKLY8yRFSrynAf/LS4oJ
         hzo1elBDsOaVPjER6AuLCC+E5ZITuhSzLPzG5WjnZTICo1ICBGNogOqhTAeGtGTfI8Xt
         VP/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=Cq8+tWfGf0TNmdPtc7SAv9a2DVpNwq16jsP0bVMh1cM=;
        fh=G+qxzQDQ0dXiWL/ii4h7NnZFrW2SnLxL0jHzL3Mr6nU=;
        b=cZ7EC1XDsKf7rJ64MCFzXVP8eG60CcZkOgnNhvR7BlICYKdlg5iGNerRkGXtDp1wlY
         hnC/sVvOpv5GreQCQB76BvO+BXxSCS1nAXFmHolKyYbN+fMRjqiSS/sCAtD6o0UCAkr0
         /2CkU1h+qZW7jTwQEWSG+14BIR9b94d7FPWdSB/FhgaeaNB7yNuUXXTd543PBaaoaM5p
         j+MwMDktnLSA1qfGFSvKygmJUruaQhPtgdQUJAHZuFAaKz+WkJ1R2SOMNhjdhHq5gfmC
         KXV8V0d08oKmKDBMBc2zmApkGkWRJlyMO2dYK8Z0YNo/tVV9kKs5qYU4SuTDLpkKaaJ2
         lHMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773253261; x=1773858061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cq8+tWfGf0TNmdPtc7SAv9a2DVpNwq16jsP0bVMh1cM=;
        b=K7vlSQbdHC+3llBEO9vphWh7/WsG3rY/oxt25tZZpP96zg0b2XPfEC8CR+F7ZoHZ47
         cjDY7KXNZXrZWeo0a+A7JStiRRaOk1UeQHd4joSbF6sxnFJSubYHCDRZP9+AtvmC424T
         dezf1ES60fOpPy07oa+KfCsSizz02I18CmfHWxVha1iX5UxQMIEX9MpiIpjkaTtKs4cU
         liCryr0OvXm9LPDpIgvhHTA6j81Lc2nsVI2JuECjTcqiABQcbyD7iuA+BizD5kVvpqm6
         C7eCAx9v3BHrJZx/pZ74X4YAUykemzH9K3n92Tu6ow2J5OEHg7U8razxEcsj1RcjIB3i
         zfZw==
X-Forwarded-Encrypted: i=1; AJvYcCWhkExqTkYiEm+cdeCRayy5Nac6K9cjR7tkDPdBNYQTJYl98tWiPm99VQz2w/q9O/RMty771j4MHQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7g/eYcBsSVOMVXa0bzbCsSAns8gY5qAa267IX07T2u+6Zd9HU
	0jc+/Wr0oZ/8Z3MVvxEZCUyuAm4frK+xPi9tJQ5IBpDiyJO05TxfUDYy1S3aO1LoNewtDkGCwAW
	Vh0qYFgz6yQjMrzAz7amOxsg65d7hVetHS8fXrzDcVgI6/xgRD/Fh34uva+4hqig27UFkd68g7R
	cefltwStBqf+rRM9Rvw+7+UXQ=
X-Gm-Gg: ATEYQzyszQY9rF6po/f/F/IFHgDDPNMTknxk4yKgC7dVjHa/jhP3f1jXilRJK0ROhBc
	CM1M8vstjFY9ima8Mpr7lm9lRUQS2fsYafV5Pw9uBuqIBpMOWEamB7vX2wZCscK70RwWnQi3I4b
	QtcteNb9sXoxHLTdp5jcO3w6ozF+IoRUNVsSJrInQvqqSqI0jFg1OvVG+hlMdc+b7pnJRlw1tMN
	rOQVMg9
X-Received: by 2002:a05:690c:2704:b0:798:e281:a51d with SMTP id 00721157ae682-79917f7333dmr31676387b3.32.1773253261153;
        Wed, 11 Mar 2026 11:21:01 -0700 (PDT)
X-Received: by 2002:a05:690c:2704:b0:798:e281:a51d with SMTP id
 00721157ae682-79917f7333dmr31676087b3.32.1773253260648; Wed, 11 Mar 2026
 11:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu>
 <20260227-blk-dontcache-v3-1-cd309ccd5868@columbia.edu> <wen63cjbk3k54mjzgw7zftsuze6bzxmdk5u5wdjabzdiqg645k@67666k5lrevh>
 <aaXK0_HqEnU5SK61@casper.infradead.org> <aaybsigvp33i54w244jy4jarwf53zph5mzwjy2hcfm4v7m5o5o@e5hljmjqa3kq>
In-Reply-To: <aaybsigvp33i54w244jy4jarwf53zph5mzwjy2hcfm4v7m5o5o@e5hljmjqa3kq>
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Mar 2026 14:20:49 -0400
X-Gm-Features: AaiRm52QGrwhBIHZ_poQdAn3zaJ3OJ_GcxWQiC5XIABJrq0SVTc4spz01Omwcfs
Message-ID: <CAKha_sp3nF=UbVd3tjie2qat44P3_puZLABWJRXs24SLVpG+gQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/2] filemap: defer dropbehind invalidation from
 IRQ context
To: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDE1NSBTYWx0ZWRfX9Y/ELuludw2c
 onp5PmWCQB3kiGwQEo6zVfw7xB/V6MyvlRR+Wf7qQtAEBcuVlIJObgqdHtbbGqZho93jCjqfna9
 3RUQfEwf5dJFwwaZDDklRxvGwO8zwtFdzPtBe/ekJ0Hejw69FRnMsVu16lDaeE4whxXFZ3Mpyiz
 vaGZzx9r4v7oc40wChVrgE4mz7+3hKZmuL5V/9OY864iJvVNjDDSymwpeubk0ExjD//Ly1XDcwM
 waiWvJgTGz0pjEfEuQzIqF+FfMH1terqSoHQuwG5LFrYZ+KpN/CXbk9FEa89rLK2J1HkBNi2awi
 /8Yt2wm7CKluW5dlBTxieN96iOIHubuUSyGM7SIgN6SSL+ehy1hQYYzDB6SN0jsY5C3pjtaQfRq
 1rJ2Qlv90hWp2WgiEgkwPtuLuWlmAs6PZYnfkxiMfLR6EIwBYyxwa8k5r3/zvfMIGwjOdxrbobn
 0qEZl7jFSgxTuc4Il2A==
X-Proofpoint-GUID: TCq7iuZllmHDBrDm3AJ1UO2r5D_iBf6O
X-Authority-Analysis: v=2.4 cv=fP40HJae c=1 sm=1 tr=0 ts=69b1b28d cx=c_pps
 a=NMvoxGxYzVyQPkMeJjVPKg==:117 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=BpGzv1V74M3SfeTrGa8v:22 a=-5RlsJUDQDLQn6G50gQA:9 a=QEXdDO2ut3YA:10
 a=kLokIza1BN8a-hAJ3hfR:22
X-Proofpoint-ORIG-GUID: TCq7iuZllmHDBrDm3AJ1UO2r5D_iBf6O
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11726
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=10 spamscore=0 impostorscore=10 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603110155
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC02E40016
X-Stat-Signature: pagf7aayc4inoybojsxi3rj1w49foc7c
X-Rspam-User: 
X-HE-Tag: 1773253262-242743
X-HE-Meta: U2FsdGVkX18F9sV3W6rMzcoIfxfAz0n5yQgjaWo+4zFWVEYG8nqO0vl3KrVdCEslTkLafApZTQX5NXBB5pNtx+oIAxvAxP3aA7iTkEU6ggts1QXDvYtV0N253W+QQFvSHfVJAiNYPhT/MGTg+txOF6yKf/XG3eet74uwghy+Xm4QxAofpopf+Dg9/QJAVr+XUfufKrR6xHhozhvorFkH0kXHItt4BP9I/MpXnL5nBXtRKwTredkh57APlvNZqtJbpQpHKdgB4kFs1Abfnv471Gd3MwF7nbdMJ+ek+HUoN2igYKJmcNLDqZWYM0kImKnrl17Fx434dmlGL5il1XqvbAllcMLRk3A0KpaM2hm6qxoRNJInL9EZmNUxiFqVjoZsGlp99PC91AUq8xdITosw3wMCHB2i3seYF+AKBvX1naqMLIlgQbWG6wqYROeo1tUH9NDwP9YA9cBErbGQDyGId9Xix9hbilei69mxf2bjPeCrQ1O+VOLXpiutd8Crv3lAJbMXaZHt7lTS+hfne1OwytVvSqL4DWnyAmFcHgDkcjI1zcpDnta+6dyGzxqAztOkqFZaWqIPsP0lfFa7KK5nqsRlgyvETaPZnChui0HUrkT2/bwcsCScDSCg9VmEJBiK+tnan0BaG0NLTeILBO4hkSZeyVO1AzRXeX4LrOxYMk01W4mIeHWiGSaOo0DGTs7Jc/RtiCCSxJcA5/oQ4Kqz7KbtWb6JjiKnr171vVclW4B72bJDJt8BhsojIxZ8UxcZplZmq1G/jAhyzD6yBC6eCqkpn44mxaz4YVxpkLcZw38dAlo2nqaTiCbpWRf8VUaSNQKN29ebwNkpm3T7mznGxLWHVolwHAKt9IlkNQHwh9NgH0HPi4s/SAF6aGZeTyTCzZKuBO0QVEiV1jsc7LhjwxJmZk4R7YUvBImnsc0KpKvgGCyQkibr7Z0XZuVL6+jKJNFtedJoJ39UytrDCo8
 QU+fothm
 MJ27rg48mD9mMLjuZcv1K3ypaEh9pnSPnFukJQeAnK9Ki9nwmkz8/Gm+RHnVmg0IAIe5gzjUcNag42msv6doeELCDcOF3c8gdxdR6JC8GpzZn+9QE1FgkDHm2hWYpfVEqzSSp1IbHtiXX9SRaSafFe8+xOe/10PgLwffRZosMFjxkhq2oa0rUR48rmoNuL2c0OcxiMnFrO7I1XpL1Rqj5ZyecTOxqOtwOkNXtOkbFOnL5bqNeXcMGnsI7IaTZUOjBG2tLSfMYbhd1W0MbnRUc8ynIWtMhzb5Dnt+4lMVB2i1RwDGlbKFMgO/GJoCcDWpArkMffhymtBuWdurVxah3dxoY6qtWoVfKSDMEXwpAYw+xoHaQ1fRGX7FCKgmR9knxcEMop0y8OF2iHW7ihIYdOtvugvoQju3kyxkYo1rL7LQeklYZGTacre2nWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 5:39=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> On Mon 02-03-26 17:37:23, Matthew Wilcox wrote:
> > On Mon, Mar 02, 2026 at 10:11:19AM +0100, Jan Kara wrote:
> > > Folio batches are relatively small (31 folios). With 4k folios it is =
very
> > > easy to overflow the batch with a single IO completion. Large folios =
will
> > > obviously make this less likely but I'm not sure reasonable working o=
f
> > > dropbehind should be dependent on large folios... Not sure how to bes=
t
> > > address this though. We could use larger batches but that would mean =
using
> > > our own array of folios instead of folio_batch.
> >
> > That's why I think we should allow the bio to be tagged as
> > "finish the bio in workqueue context",
>
> Yeah, what you suggested there makes sense to me. The workqueue would
> probably have to be a per-cpu one for performance reasons but otherwise I
> think it's worth a try.

If the consensus is that completing tagged bios in workqueues is the right
approach, I can give that a shot based on Matthew's suggestion.

Jens, does that approach sound reasonable to you?

Thanks,
Tal

