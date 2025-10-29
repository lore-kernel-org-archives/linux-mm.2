Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17983CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0B38E006D; Wed, 29 Oct 2025 10:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8148E0045; Wed, 29 Oct 2025 10:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE618E006D; Wed, 29 Oct 2025 10:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C42A8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:04:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7F46C08A4
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:04:03 +0000 (UTC)
X-FDA: 84051320766.17.D12C243
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3F52A1C0025
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:04:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Dw/X+03T";
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761746641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cnslAE1BZQVrAKABEOK7rtluaysr6PV5JU1KbGuTZi4=;
	b=Dsaua3dpxRBnOqWpwqwKPbCX8M3UEHnm5k1y3QmLZdZxRayZrLvptPPKAblHlXa7ViSIFB
	jGfDzuTHsdqTJvWj83lhEfW0Y99H8OuNDOkEi4i4eWASUo9TjbJ3WUg28sxZibBJJB9hFO
	QUf48vfiypx5oCR5E67ZO/E6YT9UK0Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Dw/X+03T";
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761746641; a=rsa-sha256;
	cv=none;
	b=GIFo8DcRd8tYCAqd26Hq6vhUK3pv8ql2aMZ8v9jvqwxYjETuJvZOibgfS6rW0bL3VngLWI
	9QFPFJrtU4Nj1MfX05dYto2+skuD6EckRncp6MwIPo9nmtz1sLS04+BPTA85oOMoluDUH8
	veTQR6+WOib1XshXt48gduZjqpQ06Yg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761746640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=cnslAE1BZQVrAKABEOK7rtluaysr6PV5JU1KbGuTZi4=;
	b=Dw/X+03T/EdFNZ1mQJ2ZyO+sNvr6wD75TL2DgYX1e33ex2lzIps+gLjSL88uc6PN9khQnG
	r8p11HH1HVlffJ6DXYL1FXgRVKlpQ4x5vrdNQV85tCZ7efZMHVmMbdlJbRFyp612UgEIW/
	hg2CsgMZ0RVefLGApdpLwtPWQQ0WkkM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-_uY9va-9OXaR2SJckUQBIQ-1; Wed, 29 Oct 2025 10:03:59 -0400
X-MC-Unique: _uY9va-9OXaR2SJckUQBIQ-1
X-Mimecast-MFC-AGG-ID: _uY9va-9OXaR2SJckUQBIQ_1761746638
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-63c585eb47bso801518a12.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:03:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761746638; x=1762351438;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cnslAE1BZQVrAKABEOK7rtluaysr6PV5JU1KbGuTZi4=;
        b=TKyTQIeDSMgHeixDB/pqmqJtvOKgmdDL3UPnv/GcGng9n5zlfVTPyLRfR+qX0AUgsc
         N0K/Ydk18fopzL2d77U5fP6OytxzONZVdv4xAW/YbHaC4jaAFIrbFJUPUFsfws52sUGP
         pQkcfgrKZorsqPQitoOX9DHtfq0+GbG1Ayk2lmWwvSBH55lCtwkrh3drWuwl8CKO/SkX
         NXAMRwXbTx/QTcPCTSDAerlz0GoPZnT5hVCP0ytSrxuF9QVqiGDS3cdbiFVMycwRC37R
         MUjlHenbmZGR13GrcBaLsi1ZRdpIhtHOqyjn78IcEH6iz3wzVXkXsOSP7lN1/cTqW84B
         eurg==
X-Forwarded-Encrypted: i=1; AJvYcCWEKG/CcCrrbIpH8ATuCwAoJLmq+sZoQvRvQ/9CitZBw+Tp8uvzOa5aC4JfH9iON/NpTzpT6tEX3w==@kvack.org
X-Gm-Message-State: AOJu0Yxhpy9PHVuzcpnRLWmO5eHDzJlTypHhlA7P2k6RxBdgDkcyo/wl
	qbSAe7DxZ9/1/K4B3dd+mMG9KwAzrvLx0d/dpARDtgMMWcqRb5R+yQ8Gof0vzJK4fFWAV2WS943
	/vtbSLiIkYa+f9Q4pt/0VIfSJ3jQlWb2qQlugxGvsZ4b/OSryUu0Y
X-Gm-Gg: ASbGncugd7TQ1caAGLJMnuA0N7+jhR+k8l8vCMgdslKQgydl2HoM1u2ZA+SIhVOmySJ
	Z6zPRN89kcn7QuzTZxSkXQflr4N/c5NqAStULfwJTDqW4gpeQc6iD6QznJJMbMGrCk/DKMnhSWE
	shTmlp50xmmd38UY9GJArV82HlK7GWGVGuwLgh9iKlQU8kgwB2eQ1dZyKs/hVb96VRVNySB55g/
	zkgUI5NB1vjd54awD2UeeKpwn0s+KaCE/XDcOq1HhGIlzfEPpFKkhFagTevtjbXU8nl7wEV1rWW
	+fF4uaa66Jc3LnNfo/Y7kAa3DN9JBPHYjx94mBROR94f2BcTvKlN0g9Bhf7RspkFv41jSm0aPea
	CMgx7AmxFaY7NypSBYb17oA==
X-Received: by 2002:a05:6402:4415:b0:62d:6601:a6cf with SMTP id 4fb4d7f45d1cf-640433159f2mr2640511a12.9.1761746638024;
        Wed, 29 Oct 2025 07:03:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzL9nsIzjqYVEDAPqxer68RLicZll6N15l3UlZtS3k0Ux6XvHSf70IZUbFQ651og2L846wOQ==
X-Received: by 2002:a05:6000:613:b0:407:d776:4434 with SMTP id ffacd0b85a97d-429a83e5134mr6401396f8f.30.1761746241529;
        Wed, 29 Oct 2025 06:57:21 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e2358cdsm51810715e9.16.2025.10.29.06.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 06:57:20 -0700 (PDT)
Message-ID: <f289e9f9-7c6b-4451-b78e-f22473c1d006@redhat.com>
Date: Wed, 29 Oct 2025 14:57:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-10-29
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -K3TLBdUXIKcPPR6fUYsTN_pWD2fzY7EPaoU5L8mM88_1761746638
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3F52A1C0025
X-Stat-Signature: 3meebyi8tcg649a8qtwpbujow67f5q4c
X-Rspam-User: 
X-HE-Tag: 1761746641-217840
X-HE-Meta: U2FsdGVkX1+aADcW4KTbW6zAACljDxw4yKB1wL9wMSoSEHtbexkWCUZEQOcgbSofXcyZvKnBClEXFuLPPj1PA1rERQW26uoCPeHWGKjVG0RYSwMqYC69JyzAWzOKVW6Y+JspvdF4Q5NEKsf/axP8sS0IX5aqXkLHHuNlP8jXv/ItzsJxLrdknu3YZsLkVj/BD1vkmOId37NKAf/tspFOTcKtLxasJm0CCVJwaJ5x/R005aFRu7UrR2kj4AijksQvGp3l6DsTYqflwwr8493oCf2hzqNmn0QvdCzWHypukhJCe3YTgPOAwVYNHVJSNz/Yi4f8sn+805DCTlCqE3MVDzsEG20PFzpMqSsafqEKUMVzY0EboFeaaJ7SaMn1h1fJZKXG0RvvrK+zbj7p0oAyTvNmykBqfOAwXPskdrGHwHbaXO0eEYlE6ibvvjaeCHqqd/R7zNQ9IiUBuEOK0NqbgRN7rpJlv67AjWGb1+IlyV23gOQfoeJnyh/YWh+5Y/SpNFsr+2h/MvPz/w4NvJL8gEW1pwQQvrraByjVv3YsaMQABiV/ObOAKPCS6nmBQfZvhdVxEjCw1qFKZ18/d+US7lffaQfd7M3EdWEaOtj7GKtUOlEa/1rCM1p1o1zgqXFKZuz3pJfvTisfQGsAXrYOIJiTCJcx5XzdpnzPOFFGUO/LfH3XPq04cDYtLz94CbuXEBH2/hTSGFbrONS/Gdp+9BlFCC82jcWJdQHZZv14eZuTRQwt9Ck+7cIyieu6l0TlMGzGNWjOPP/HTKBC/pTFOP+XD87sGONQwLLoIFoCU8Sj6jCMsCkwL0hjjKeGMwkw1zb0W1Xn35kZlcOIxEjsGAGQzRHtQ8t4I8nbNwHYR36u59wf42SCaIFWxO+4cwU8Ky9nO00o7VtWyskvy00vwVTkeccsmiGtCfEccBCGkiXXBXRFEYW/EaL8+iL3bbp1LvvRpSJh/z9F6GhGKZF
 znOwrkKg
 8AboiaP3ZlaAJyGR3mnq0bJiWodOq2QzhPoAPiXgLB9pIGDre8DSSJ9D4VAsICkgPeLYfVZ+bP29lWgNVnpedugN17cHxangyX79H8XXIaBU4zQ5S6ZxeMkeS22HOO1r1MPXwbieL3HT3AZqVNjkuOZMn2CasID8z2oYMiRlpY1PWLTm6JZgkI9hf/HZm1avneihDaet/iZCcHHbxND3VNu+24+O818jJAeoPgk/yPTn3eecRiC8qKyVR3EvthtMsHrlGUXAsBnjlpOp1xlSbWi8Kr9I2Bt8g+AFZlByhGLLNBfqaPMZspYXx2qE8nC3r1yBbwyoHlIyGKEMD3nC9MW5esgiueT6DkRBZZODKIBlOyp4+2G/UPTXMMCzzjZQuZG7Z291fjsDzosOfOwefRj242N5TLEG3x6X5s7/X2imJUsrdlx7EslYpJnXlOnAuQKxzRmmnv818coou5P4m12gUB0MDXKEbH23M/y67/hcl+BiIEpXLm0q0Y4DRl1aG9y2aPLFCdGW+XEQS9Wba9XcVTakdjXNCQOqlnuBD2SEkY8YnMX2xVu+uaCbWmjsB3JuTu+L/YTuvmv6T0hajmmWCTAb0j8pc5tQpI1Srr76qgqWnD0HX44QXfdDbWNKUQHzTqmf2tZcCCzY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-10-29 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, we'll definitely have Ackerley give us an overview of 
work-in-progress HugeTLB support and likely we will talk about the 
in-place conversion patches that are already on the list! Further, 
Michael wants to talk about using the SWIOTLB for all most/shared pages 
we touched upon in the last meeting.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers

David / dhildenb



