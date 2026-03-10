Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C79CFEB1042
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1706B0088; Tue, 10 Mar 2026 06:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07F176B0089; Tue, 10 Mar 2026 06:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD136B008A; Tue, 10 Mar 2026 06:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC0316B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:24:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2BEDB97ED
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:24:21 +0000 (UTC)
X-FDA: 84529768722.20.D63AE5C
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB0CF40008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:24:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HQqVjHAv;
	spf=pass (imf17.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773138259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpIywL6/B0VmcSqv+O4ei+ncP93YXxlEM6TGb1h4X2U=;
	b=4wAceKBjcswzc6rtXSVy0F2HHHYrKmX+jSV3WTRwlsP6yBYVVV+GCfey7PdGWqRwJpgHNG
	4TaF0V8hAMJUjyfam+Gk42PS9vR2imueXuc9/q/1Bt78l1Wgrh7vo2053Ey2kyLG93CdGn
	9wRFejXn+mVJzBMMs5G8/nGXj65tJQU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HQqVjHAv;
	spf=pass (imf17.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773138259; a=rsa-sha256;
	cv=pass;
	b=j7a1Z5WB+jZmBzb7a0ZmTU57O9/bSXJ4Vs5LvJ6cKLUntqn0v85hwHBQxLyvsL4ciMYl8x
	2Hq+KiAyK8r85rdJOGQZN2eghd34oILbtQWoFwmOHGVTrdJ1+qEGJmomQrQKoMv4QPZwDa
	eYZmWu9e4mv/wYKED69Qz8IPvpR2kg0=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2bdcf5970cdso8436689eec.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:24:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773138258; cv=none;
        d=google.com; s=arc-20240605;
        b=F/THcXckN9EH9Gdxlr0rCtG3NszS4h9n0+EWoQ9ytnCso0TTumjnFayLfnSJFbJBrC
         WbpVp+dvIG+RenEh35YECYilIHyPzNX8Sw9ptIg7YoqeMLP/Gf3fSppj1I5DI41Y6lHA
         JJmUH6vnvZA0jL9qfL1nX7geAz8dJZ6oWUvYQ4zf6Hru3hqrJfh5qAOPiZThIU5AngQC
         +rtC4eoNPnazzPuOFLLWfcvlTFqQYq4Vc3nakeKhySopJeNaRsvJYENedPXH8beonUGI
         kR2bDXqCVruBZE3WkGMKSCq2Tu4eCtVmDQLS05exv7lz5Mf/x/Nfe3pQ7SYCL6c4mKJm
         7Qog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kpIywL6/B0VmcSqv+O4ei+ncP93YXxlEM6TGb1h4X2U=;
        fh=BRNRax2UYiSHEkD+gjPctkoloM/hKfc9ajgfsD7KvT4=;
        b=ZKIPp3oLAl5eJxtJCrNsSrqvE6OiD8T+Fx2V8Dn17shx2eDUnbJkL2ShRAOq10UBTl
         yxxJcfTviddbip8NQ203UxZAx0wbtZwsPmxUSliEJRdopN/sZjNFaKDJbvjoWUF0lpa6
         p6PHjpHT/9XmGDIwI8h0kLyfEtPMQR4Z5b3btGJXvzCIapxP4AJUcuB0JLxx3zuzXyxM
         2whJNKJgFmF30rculNcAPk9s3ii652GD8gLI2iomjnqFx+vf0uhQxe0/2sb5kkHdEbDR
         lZGDwrcLfzC3sYtDL0DzUDVKaGVY6ZgBCVqF1viHg7s6mrWHELpS7m7awpKp7zQU8OUE
         NL6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773138258; x=1773743058; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kpIywL6/B0VmcSqv+O4ei+ncP93YXxlEM6TGb1h4X2U=;
        b=HQqVjHAvtvUAw90A0Znu/l+Q+cQ3vQmrtnq19pVLtwRyEyU2N3A1fZpQJe+c3ScXke
         tvYrOqh6s9juCbFLE76aZqQaqtdvPUEBuxevtoxk+C33HkafuoN2E/gtE1vuwdsDOkBj
         AN1rCUlLPUAbYstJuSJb0eZmNrnHKnHpBVscMRjOeoSV57tB7V4/jFBwaGJgrMqltV7d
         QOPZEGwZfSf/1a3IuySuM8WTtw76r2egNwnFkMbSO+HFYTHzHS1rHxG4DE/uDUSrxWOz
         k1m0R6akiSoRSTb4glszft4sS8uWWgo6o308HNtyg+00GqKh09FXRbGJzUoCFae4gKdl
         Nzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773138258; x=1773743058;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpIywL6/B0VmcSqv+O4ei+ncP93YXxlEM6TGb1h4X2U=;
        b=lCKOkaz7inTx4qp/pR8pV3XPiIOTGcpiuWnBOxS0z+dlVJJTTZUn0eowZGlXbaIvWx
         UBg8AYlSL59FucXWbgoGWz76V7ioXL4UefD7FahosuiaXs0EJV9g5llVW27B3uVsk2aP
         NzM1iWokkNnmB+z2bCeXnHeF5JZk9Vb9XWJkb+nmqoRBUfN0jktwXvPIXNGRx4COTxcs
         9vwjSmxc6kqJqwXTUPEctlEbKeRMqLGqmArRbaFPbJ3hrFXPO5dI3n7mCbwoDSWTx/5J
         YE9i0lVIFnJOekTqhe6QvNWFtxTps2RqF4j6LPlJGs059cfwkh18IcdjX69YWE2im5g8
         N/1A==
X-Forwarded-Encrypted: i=1; AJvYcCWIaAsoI5CgIgkQDQ7r93/pSRMJ4p9+pseV8e/u6qibvKp2mct6VHx/w/5+lrac5y2ecaYPNkVNFQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7f30PJxSId3OWwIOWigT8jWHlzAOL4afGMWw5MHMoc23NRe5U
	z2iMs7/oBPl4TbUCgcwexYv4glNi8vA2FH1IvS3qzFby1CpDiaq8mkMGu7ptTnvhF7zY7EXYneh
	xEwiKSkD5cnEBoC3eh044tx2h3u2qYls=
X-Gm-Gg: ATEYQzzwdAUGcKSneck86SE+dhO46RTeLxtNsEt0xJY7ml73CQliGHPh5/WsrflSdtu
	ZL+Wfmf0NnMIAPqMrs0y1S2rp5RpBPxs0fhUutxFsXOUxS7L4Fcf0J32Aj7L8oU/wlWRIMuLg9W
	q2giiwBsliRr8qRCzd+FMvUqabCzk4zwDKUMjXOwnVRhpJ4bgkvEjSziPC3K77aX6R8c5Va9w08
	mr7lEpW22F6l/3RylI/+3NboaBm/LLVOv19s6x4BO5oSmHyrFhSJS35ziOer1vtavN5QRcT8I+d
	8Li72krfrLJX9K4l7S0LYmoVY1DgVMOTQSIRB0TMwYmRBIOYXBdE
X-Received: by 2002:a05:7300:8810:b0:2be:69b3:2de4 with SMTP id
 5a478bee46e88-2be7a0b02a7mr855584eec.6.1773138258338; Tue, 10 Mar 2026
 03:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
 <20260307143542.179953-1-jianhuizzzzz@gmail.com> <ae1bd46a-c5b6-4b74-b861-eefca84979ce@kernel.org>
In-Reply-To: <ae1bd46a-c5b6-4b74-b861-eefca84979ce@kernel.org>
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
Date: Tue, 10 Mar 2026 18:24:57 +0800
X-Gm-Features: AaiRm523sIf-ybDdxVnbdZHg6GtAPEP78OhXdQFf7b9-RPc2RAly0CqnAXnY_xM
Message-ID: <CAEgWzV6ZzVY=vz5=v=pMWYkanzd9q5XtRRjo35DHtCxrS66Nrw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/userfaultfd: fix hugetlb fault mutex hash calculation
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Peter Xu <peterx@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, SeongJae Park <sj@kernel.org>, 
	Jonas Zhou <jonaszhou@zhaoxin.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gb4jrwjotfw8wjc4a15kkpcy9n3zd4rs
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: CB0CF40008
X-HE-Tag: 1773138259-889719
X-HE-Meta: U2FsdGVkX18rRpW+dG7cOMnIOi2Zg//Ogvsi/npgxM5jahFEO+1BRNMkGUcCJYKv4uSdQJITk01SQD43G5Xd17m8uqng7RkX7qauREYnmohYbxXTpSSw8inyj2mQMV54mMR3koUMabg7ED6S5HFS8Fj1AJrehUHmrxBgfQbVCFlmvfnCTITHec2CIDrVMvfNI2ixfhRytIYxrIEc2qHEtx6J3Ue5doXZARldx4GeecLnM+p2O+0eQTK2XEt0rtHL+wx9/XzD8G2lVNVqKiIbxElMZuuooja6crhBgQ0NHGOAzhEuG3uJZXr6cjb8++IbMwFlCkDzC6NQ/SoYm/WjOzNQ4bggGkhrRyNyAQarxElWFiJqsCiSU6H8mdQPRSLOuh8rZTts3m+BwZ2OjjUka0yevWEPsTivWlYZIarWQyGciUjBk3EIHCyH5PUH7p37czbgr/HApU9H91oXmlW5G2f73OEdRGtC9jEdfZvOfhRw90yJhgZ2ZM7A/JECeNnMfS1aS2gVNb5Cx1jNKIdA5iRXRxChKFxYSf3ojGD331jN+5ha781ZWGeI2hJTaioxeKjoRb27AzpivK00uGJBDYfxOOLT6FMh6/2daC4bkt1zXPC+aRBews1tWxQ1obeRbjgDcnR8TShW0OM81Co91WRWxeSqMkqC+0LsqhV6am1n7KvbupSuj0hRGBdLnQfGg/AMi4ysqpoQcu/uTmSXZ085sUN9k6upIzCmc81McqEk0HMoiiElOY48qHgwF+w2i7eVCIQwkekwfU7lAjBpzK5kEbzCIItYCyPsbIX1g0b2UylzzyPfyNvQ1DtbV/CaemKb0A0d4r0YomZw8IESoi9QzVA+ePCQr35tiiEHnoXvU0zYq42EdwyyQ8YHtqFpfspoeabqg6EPyFuVMu55qm1c7pHo1ywCyZKOWpe6KGfBB4WMtJXeXN/H9u5dprj4kQNt9IVEFkq5w5AVnE3
 gvt5+318
 VnHP6S7gu9hE+XesLjsR1Z53AdBdwmHkCP78emnNoLqcs1Z9od2d27TvElI8tixv2JPjfTUJcMALErJ2xKJRqQJ9GdcX/69qDax5xJ7Gs0Zpo/ctnGhIbE9d5b8QEzrtRJbxlTspZ42p6m+jquIlzF1MRaVbLmrcEpAPjJs2HkA98I2gaTjdyp2XRrZz/JHWX4Chgq95geLI0X3IRT0Bj7mbR566HKCAOa6HYMWGJNNAcDuzoCZjILMfjFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 05:47:26PM +0100, David Hildenbrand wrote:
> It's hard to put my disgust about the terminology "hugecache" into
> words. Not your fault, but we should do better :)
>
> If you're starting to use that from other MM code then hugetlb.c, please
> find a better name.
>
> Further, I wonder whether we can avoid passing in "struct hstate *h" and
> simply call hstate_vma() internally.
>
> Something like the following to mimic linear_page_index() ?

Agreed. I'll add hugetlb_linear_page_index() in include/linux/hugetlb.h
with hstate_vma() called internally, and keep vma_hugecache_offset() as
a static function in mm/hugetlb.c untouched. Will send v4.

Thanks!

