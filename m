Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D587606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dmaECEyc
Received: by kanga.kvack.org (Postfix)
	id 4286A6B05B1; Wed, 28 Oct 2026 12:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400326B05B3; Wed, 28 Oct 2026 12:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B8D6B05B4; Wed, 28 Oct 2026 12:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11D7E6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:31:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F33D16012C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:31:50 +0000 (UTC)
X-FDA: 85372576380.29.A0BA5AB
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8E2441C000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:31:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dmaECEyc;
	spf=pass (imf18.hostedemail.com: domain of glider@google.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793205108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SM6UQLiiF4IKvYx+4KeCb2inIR7WQ1RoFKmtqWIOiHE=;
	b=KhmRCXD2N+U8iSfICA09QpdRjhKKypqiR/qo3bq9suTCptF4mC8wrgxCCy5161moMDBhtA
	9NAzIB4ga83fhNRrr6OEIDR6Ejput3Jx5I6CaVPjSP1SA3bpVuKil6Zg03w34AmCXCJQ7Y
	xOw3jd9cATRG1DypJ8Ih7hXe1FH0Rxw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793205108;
	b=memIKBSPZESrFGPt/BECz3C28Si+Y1zkTTUbD3R5vAMMoqeMVCPuKJbk1poffZgwXzG1hN
	oAepCjLsuaaXkGPo+HitxbR57ZkhfwKW/ngDZWg2lRP2xMT5qBrzu9ygENbXkEMBOm6CA7
	FK0k9Fut7iSEm/CGP1m3oiJ0TFTqqJc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dmaECEyc;
	spf=pass (imf18.hostedemail.com: domain of glider@google.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-84e513877a3so1098953a34.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:31:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793205107; cv=none;
        d=google.com; s=arc-20260327;
        b=i4A8+40+8e2v/Ww4SEbVuCaTRJdJvdAEHN2i//oTUstNfljlxoYQbPwb8dOT7IhD8Q
         yDudhoPPmPfFxIKne+irPsTNaughkWlcXfyotPvTAqOJ7SOt/Pb+tveuuU6JGW+Ezxos
         OFSUr5kEefSyLh00Woq8e3a5CDn9KXc2oJW1kYG2pnRjOfJOQb+r+0An6zpzg7gXbApg
         9MJzjNZ9TfPYXstBAHBF21lFKhXatqeEa1m40EF0drfuvE3gYoGSokRwps7I53YnejEh
         CxQXxqCCbWoCTpSG92Z1gvTfOPJHsl10WPGVkk0zE3Aw2B1v31SEQ76WCruNHiaZhMRf
         /05A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SM6UQLiiF4IKvYx+4KeCb2inIR7WQ1RoFKmtqWIOiHE=;
        fh=eeC4BC+CAlb6FJBBblOFUVHTG95maS1VkOD0qj1b5Hg=;
        b=K8D4F/+WriRCe3ZEqNiY415gt+rymPALEFHMgMPk6GU9kYw7CCh0OShcGDSmHJn7Ai
         7+hohH8zAzmTS4KHQbBz7JiyjXbKrBJ4gybIHocBkmWo/2kavAW6Neb67aH3pen47JBV
         SKlvrhyTbo4hwXrnBb59i+ta6W4uHaCejE1gW0Hs8MTSiX1ZNRBIRJVDjfu4vDqbVWPF
         D75/ZqkA6IAyKRaiWZ7U23Wedi6fp1eQXkgVQTNCcCGmjekc9LDAhV2L2rz5QrvDPbjw
         c6RGsltwlwtC1XOPpnyXLwLe2G+F/ECw5lArRF1aDq9djGFHba6pRcZy4ORPZWEasVWR
         5Jfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793205107; x=1793809907; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SM6UQLiiF4IKvYx+4KeCb2inIR7WQ1RoFKmtqWIOiHE=;
        b=dmaECEycMR/3E63x3yscoP8uxQaaBieV1Ysa3rROvDZaLa5hz/Xy6clG54kv4rHt+h
         YjNkzWdZgPkVrwtcTYlQHPHL6Vt5uPWSpJ1x0hjYrZPEDYQaMdAWUp3RwUOJnQIiAeMB
         AvRZxxOKyPPUxMo8uvt6kDspSvXf0kdbOKVVenOZn/Qz/fEealpCPiMQsP2Diy8Zqi2a
         IyZ6ASUWEU7ZaO0ImcakgSc5wTSwSFoVCLnUQKaGfhTAFHOEc0ECXcpKret7SCdlog4K
         36LP5ypFfXUi88UMu6HOnBcP4sBXWK3EBoQFM3KEK6uYVO7opo10aO35rPZUrDvVlkc5
         4aJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793205107; x=1793809907;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SM6UQLiiF4IKvYx+4KeCb2inIR7WQ1RoFKmtqWIOiHE=;
        b=ewc37J7zNKCtUG/wlD5i9rbvwBOpoKZrVKGOgLuNyW5EPhI/6BrzINqjw7AXlWODsE
         /12N18e77IAwk6Nab4Psu2hMUEFrxSEpX+Vr96P8lRmFNron+Plk3AJsyjNw/LDbZRFu
         I447alNM0tFlWUQu/3btUVS0lR8AEEIaNh3uE/mzJiSppfM4IMKYtSlCRCH/4S7tTOSv
         CePWQu8QRbFT2qJERhbBQ7IFSDxzt9mGnFfRu8mYCJr13yVRW3RIt6hCLoD028DLjMbG
         K+esM8mGkak8k1qtIowknVwuw2haLxJdDl0y17GJ/i1cVrD+omPhC2TiXO7+7z2jaSmy
         yG3w==
X-Forwarded-Encrypted: i=1; AKwUvBwOTTDRGtC4finAH2pBR7NFDuzKEe+JLHyiuE0BxOwAOhYi7AR6tllBsHpS1WLttdD0MTQKwXje3Q==@kvack.org
X-Gm-Message-State: AFq9FYJSbtB6FMw/7SphFl0OjRDskwvg4HNVosCU7OhDYllTMr5RghYk
	3mX2Lnrqyp9vmNY4b4HL8s/pOFYad4x9vVXGrXzHy9YKB+zIm/3UMS57mEvKxgzqQpSfOG3YRDN
	WQCRX6DMFmzNhcM2mh/f562cnHkzsJd7qXNZo0iRwQmm3gKQAepMDNbKAGQc=
X-Gm-Gg: AYBFou2zBZh//cDeHQq/1pQFwQWdpCBOerMwsDwrmlR3kQuZiTe9yCWEsBY6rGReyH6
	0EDnjIWYuX9GaPsqNJXANDGOiCfrCDe+CN1dviH1QCjuVFAp6ZljCy1tapSVz6Jzw4c3r2WUrPP
	9Qcqm0xW8nb2GJkP1esQrnKJXzrn6rexzhHWu9iy4K5LAk8kHjoMdKakSWA/Q6fJiBROw0DQ8aQ
	nU6EylgZnnGVbzLrP9i0p6BdRnzsG33SvlbLwddbolQKwtePyNAMqCA6bmE6Stm0agixxDR5jxP
	j9UgjL/ujJuWAxiczkvwoLmhMhkf5Pkqi0NInLsfzCQwxG66A6uTFMU8Y41P+wrU6Qo1P64jije
	yer1EiILDe0Tx3jXqWQlELmBi+TTpKlc9vIAFutnaVSNtewpDDyplLu0NT3gax0NWg1s=
X-Received: by 2002:a05:701b:280f:b0:1a3:cbd7:1269 with SMTP id
 a92af1059eb24-1a94587827amr45626c88.23.1793204666877; Wed, 28 Oct 2026
 09:24:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027222557.1072105-1-kuniyu@google.com> <20261027222557.1072105-3-kuniyu@google.com>
In-Reply-To: <20261027222557.1072105-3-kuniyu@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 28 Oct 2026 17:23:50 +0100
X-Gm-Features: AclHuK83Ew5Sd-KIeLIE3eJfQT5_WPH_CxOEVfOjpqqsktBeC5R3K2Kibmqo24Y
Message-ID: <CAG_fn=XL4uZ_+DXxqp5tvx_NsickTino36fvh-aXjhKiVnELvg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8E2441C000A
X-Stat-Signature: 97d4o37sfr9qoxhfwirpqujeirkwd9tz
X-Rspam-User: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793205108-871297
X-HE-Meta: U2FsdGVkX182y3rtOVAb5Jf24Omzc3dMTgbg4F0/xLXDwbwgKIXUMNwaaCAE3rnihJFPvgJf9yySjrs1wL1oydBFM5fFIxhcSy1WxhGTyDwQBXqqnT9seIBIgDRzn/XtFWVdus8nsM7W2YjW4S3wYQ48CBq6Fze7YqWk6lEaBS+s2w1DFxcw74oVFvLoU0g354nVcfQ2Rjp6xu4JDD5ATx2UIZrnZ3A/d0Q1nC48Yp8UAe360NZLl9eH5osw1cPsl8Y26W4r30UQ5Bdkyd6EM7Lh4DAKTCswPT9J7GeWNaKzwdbDE83nInecPorH42ZiyYQzT81TycVKFbUPA2IWC4YggT3wQPT8pzI+84oJraeimzs96k9TqS5d/rtsWyUG3ZRvMg4gSXDYpFCdVjGuckZxyzuWov6dfdP04unc5QqXCFjzaRdpQxoPJhNGl6HxVJWDJH8DvHXQ5/cj23jkSwrWbE8mRoj8HPb9T392qvNpey4B6YUlZ13qnjYIBOEN3BBjxW9aCE/8Cmqd5iewtBdvot8w0wbzhUMjMai4GfBHvwudhoiqrYCrva9o0EqwgMoIksSX70AXX9zy8+olLfb6nIIkUPdjrG16e2FU86CVm775n1eo/1IpGJq2zKmqtKDmHZx6mmJ9Ix0FWrOsBh1hAy4A2kAr+05j2twHxLC3knO+zGlyNNVCa9zbPT8y8lTt4RScpbp0sZfW0lWZUkgtgGb3x9HKEhD8QhyOpOSW/vEmynqfwYk706MfgFldIUzEFS3V6rJtEXSrvxORHK2hYRhJXysrjergR701vEjzOtR4fjfMqQ+A7V7/g/JqngIR39Z0KAlk4TEgAZi6DJdBJo33S4ktaHsgRSHKiIFlOKAGyPySo0C9QSHUj07ZJk/HXd33cjfeR10jpibUHbyi2kZHvcJKApgNB7Rs0LTGGrdNd+KeLUIW/AOnG7bx+PruKS5W7sPfIzN81E4
 vK47vRRQ
 I89l9MdorHJ5wMfVLFx6UsmmVMp0Xb1H8XkkXH7koA8mq30rBuqgvPZzlPfKqgEi/eGR60F5GCxXEDaB9rxPePur7yUvy0d/L7W64q0RLCxnF72NhkBaprbo4vf6YPyFWHEzBjW//jVZXz1/TPWiaBvE4HMbbayA7Op1njAOgqNelNZh3eBdtT2DXtva6eu4rSE4Isd5etx3+0+76cG3LOIVBs/10L/e6EiMq/blzcZSg05QQ/jj8OiRWYnoh0CsIa02A54GRcod2KeDVlG6ik5HlkQhD7xVLMMNhiJ06VPb5bpjMCJ23Ay305tJONGhhXc+4D5v6TBGPLfXSXm1lAZtp91bW9FwBPXZVRxWedT0ihRDtTmIR5CpTWCFRHKOqOslS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>   Memory state around the buggy address:
>    ffff888106dc7800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>    ffff888106dc7880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   >ffff888106dc7900: fc fc fc fc fc fc fc 00 00 00 fc fc fc fc fc fc
>                                           ^
>   ...
>       ok 2 kmem_cache_double_free_rcu_2
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

