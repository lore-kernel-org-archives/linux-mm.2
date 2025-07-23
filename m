Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB0BC83F34
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 15:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402EF8E002D; Wed, 23 Jul 2025 11:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DAFF8E0002; Wed, 23 Jul 2025 11:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0E18E002D; Wed, 23 Jul 2025 11:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3898E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:05:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E341F80109
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:05:26 +0000 (UTC)
X-FDA: 83695853052.19.289B8A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7D7A014000E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:05:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f+rOthXq;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753283124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yv5nB3643mwqFffYhxn7JpZMpQCIFo0F3qmPkPIlgM0=;
	b=AeWia65eE39VMQVqopngLW/L0/CXM2YlymJ0VCZShFrEBr8X2k2kIwOaiQbN8JktLCUDtL
	MvhhZbo20YUSEAAPvYeCUUQWC8Y3fzqvVUyrEloD2Wg9M7A3eSKbVImFD8Ao2DwcgVE9dy
	Etf7+puC/sJ/gQ4Wo3piXZ3i6AQwpRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753283124; a=rsa-sha256;
	cv=none;
	b=IpuxQO9glgiSDLIiZzm11qv/FZsht2eITjweC19E0nmzpTTaxMzrDaZ9t6cu3MxXRcHIPi
	NQJGpwzcRuG+Pr30KphruYLdAwptUvyBz83j87vlUAr6s5BtdITuDgLkROHDViKBlcJbfJ
	6BCCeCSMVeXzOCK4MnzefirspSmOGxo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f+rOthXq;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753283123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=yv5nB3643mwqFffYhxn7JpZMpQCIFo0F3qmPkPIlgM0=;
	b=f+rOthXq91A7PkLb1LJoQXCsf7uznn253tN3ge2IieIxy3FGVbeyx7ajZyN7fRx9wTe71T
	ZFqqPZnD+mI/bosiyX2spIC/6bB2i41msOd9PqpGsH1Is1XtTz/Mzebrb0dxRf1AttqhRH
	T9MjLkYbbX2PdbPkdSwr/yR4OLmTrr8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-OH8hPX6KN3iPe9tMCkV8tQ-1; Wed, 23 Jul 2025 11:05:21 -0400
X-MC-Unique: OH8hPX6KN3iPe9tMCkV8tQ-1
X-Mimecast-MFC-AGG-ID: OH8hPX6KN3iPe9tMCkV8tQ_1753283120
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so43222735e9.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753283120; x=1753887920;
        h=content-transfer-encoding:organization:autocrypt:subject:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yv5nB3643mwqFffYhxn7JpZMpQCIFo0F3qmPkPIlgM0=;
        b=fI4/DYjEJDbUCRXGqBcQTR3ZhPGE6BEM9Vmg70ias53CXx2hN3SoQtbsJOrBpY43R1
         D5htadFwLE0qwvZK1GuTZskLfvcEZcYD894N9/ViHN8/QpJSvxWgFk9OgBlEO28qGEwd
         mmgfhV3h83gAMOO4sOU8p2Rv1XH9DJB4f3caTeFBBe2wce8BpNVQO9/N2HCM4HiorMrr
         FDebpuCEOSbGXo/7mV3WO+PcAbTk9JYUNyo7+PQdzsnTy2FJe18PPMPtCbn2DYCbv53e
         cPpQ6p+dgFg4Z6VTmlv4fWNoOzko/MZqKo2rHKh1RB3Ldyn98mubCp7WDJIfiVYuWPxW
         SIpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXA8KfJzM/3nrqQQ4Pnq94x/ALlv+Q3a5lFKJISEtro/YZSNdUMpTd3uf8yaz7pjWsBXwm8IyHTOA==@kvack.org
X-Gm-Message-State: AOJu0YwD2kQ4gbPYZ6E813nZcZ5qhkTRdHF4JqeNZUeCCJ6Nu1ezcEuZ
	/apqW3XmIx0sgjDYpx96M2FiWiV5ZZSrCi9vm5FMFHJIiemEW0B4IPMy9y8Xqto50llnMcsNxUB
	4W/HlHW5RrWcUpbWRjICThcCNO95JJkwDnc8soVBgHRhYaIQHengw
X-Gm-Gg: ASbGncufKXi1QE1F20jnzQNTAnoqcs/HwOlt0iyZ0YyJqWdbDjQz51eDnVn5GYlTaXG
	99uEKvhgk7nBBhutBXkt8Szc7nsJPHg/j/E6RwngSqOJ2Zr/jETjjQIiLfro4EPPDjFTTlSo45I
	6azSO9m54aQWfV5JZlQCn29lRgmaSHWnhZ/o2QOayVcHuBaROKnOtDZc/KHChCevAmQNTQUoSyp
	Re32eG1trnFt7kgA3HAzrxbpjcyFDkPDf2XivDTUZUJFxLrq2E0Yx7pgAmf0+9yswwMUSPBBYL9
	+1HnK7IY09bTOIPSDobIHuOPNIRzG0gcmW9+sYutN7Do1Y/HBRtmkA3zLPML0Tw4/wnyaY6FArm
	fmPdRqy7bS99MYYYtjkaPZ2h6MxXJA8u90zJ5wCtc/LwsXvB1e/HXtEKPjxswcbrycTg=
X-Received: by 2002:a05:600c:6992:b0:43d:46de:b0eb with SMTP id 5b1f17b1804b1-45868c99c85mr30116165e9.12.1753283119412;
        Wed, 23 Jul 2025 08:05:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2F5mSqLZEunEzF7urtX2WBp8ykNV6oKnn0wFMx2cm8cOAKr3D8at2B+ii/3mueYJl1zKZiQ==
X-Received: by 2002:a05:600c:6992:b0:43d:46de:b0eb with SMTP id 5b1f17b1804b1-45868c99c85mr30113555e9.12.1753283117177;
        Wed, 23 Jul 2025 08:05:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca2cc06sm16564115f8f.35.2025.07.23.08.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 08:05:16 -0700 (PDT)
Message-ID: <37a930a0-e1ba-4be7-8b0a-4fb5409131d4@redhat.com>
Date: Wed, 23 Jul 2025 17:05:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-07-24
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sJcKff-JUt5tqTvM23cciszImdvEFQpZGCYcoJs_fbg_1753283120
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7D7A014000E
X-Stat-Signature: c3hoojnxwakwbkae9n8nhs1zffokjotf
X-Rspam-User: 
X-HE-Tag: 1753283124-808891
X-HE-Meta: U2FsdGVkX19NXXjy+KIm2hTv2lEvYORh60A9UkcOLiwoAZe9+QZhp1edn0r8yS7b5g1IPnzcU2w4V84JBbJPY+5nVLmEn8/ER8h5j739vazumlBF2sC1vwFe+qUVAWT6M7OPtdBCJ4exgelbo/kKUGR0zaxpq8tzpqcqsXkwdp9GB2hqY9seJZ4pM7IkPIfenSen18OaswnR7eXR08doy1xWUHC56/liUtaqvQW8b/G1U4RJTU8jCi8/hTHgL+ckjkAZJ0AcQYh41cX8mtw6eiqxL0pQMfdbDLoIi+zZznUtYBzFdB6SpB1epiavI3eGP9E/ND/IvdGQsrdN9hxDOQ2iiZLNcm6Wp/LeMnS+mz/gTV78jKDvfNh4VtlhColL1KAWsu76TPnzsmxmBoCBjlU3W5+6rc5nz9trAEAa7BVeQY0WI2LFhSo0LDxp9xl+u3gRiNPBGjDRNN/ZCNftu2lXdBJkKErlk8TnvUA7jmx7O+NIacPDLYV4FVckbyzpQF9JdT338i7cT5cSKyQkbELpOgybhiMzL8BTLRCQvAnAmsKBfc1KuPKkmwmRRYSGpv4oXsaDPjkpO0vNXDzERMWZ478tT5UpstZOkH8e1byp0gnENO2wnZCpOGC2j3AeJz8CJ6IJkvvRynLgk1LufA7jgOIdpIDGBMaGQvll2rQcC+KgXKWuU1r6SS1fcTnLXKuQHSfBhifklYICGShli3MOQwifnBZJx7rYG+Y3a6j6iT+LUJ9wDqvGUsv0RhHoP8hunHLIZfyNCPgky2XRZHn8QGLJy6C97MifTVW8593YCBJo29pYtajOI43pC75INkb+5H0mjIl7hHivoTQL8YDgiX2HhThdXE7dX201071EnK/LaFwnEDaSRZfK4Ch3V//G9xPhJublUoUsD4hQ60/EgjadqznioY5dYvxZoSQI7TVDAaHYhqo3G0G+mFiGu8DxDdBGV75HSJjbsoM
 fkrT3woZ
 rFZBx5zp9vIeGDXFbAK9CPVBnqE5GzKQ2ZIKzlXemCUq6iGbZALGIvdLtYz5bfld1OWDFtDBM8iuICsPg3epoGJrx4yWDpf9TS+zd3KvZBV3gxAXc0RclZL9JFprD2j2rLErHXuHqLRchVI5hSCkGWahjYLq45i7y0trMr8zmngHg7JeKdwGhk0bWVwqXIh4XK51/fxyY9fk/IOLR5LvAb5Xp3oJmuLxkV+wRvk0Cnzqxfl4+jKdHKPpGk6ipBH2gBEmgYXm72HRA52MMSnVs4g0Je1Y38FsjTTPKu8+kVdoLR2ltbQhmFEBlKYw4pACa08D7ArYVd4ZCNCNXERFfzZIiU5XtqrIS69kUVzTEYl8Zwo3hpKhc1sunQFwiii8PSxzgOMQSeJYrZfPJYabao6eCIY2lvv5nGRHffWTvNM/hmnlXjBu3L3d1M4Pg7xVs1ML0DZ+pHXueVUUqhBi0YK79ggalq77GELOyWk9xRsge8qlUxSAWevWL7r0HZ78TGQeeJ0FjLBqa5nF4OL9hfU6zgP8ZWxpoE1Y4KiS4Awy61j3F+dpEGzRuDw1NEzo7O241DLUqTvqTSMPLkZy03a3t64hvpulQffCV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

whoops, I almost forgot.

Our next guest_memfd upstream call is scheduled for tomorrow,
Thursday, 2025-07-24 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

Cheers,

David

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing


