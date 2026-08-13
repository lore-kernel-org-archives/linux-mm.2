Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B648C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7FF6B0294; Thu, 13 Aug 2026 07:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F996B0297; Thu, 13 Aug 2026 07:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280BB6B0298; Thu, 13 Aug 2026 07:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7E186B0294
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:51:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D57C140120
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:51:22 +0000 (UTC)
X-FDA: 85096080804.09.9EA36B8
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id B35BC8000C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:51:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fQp2HEHo;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=2dhk7HRn;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786621880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cbEbpn5Hw7xsVAZB92jcWtVfy6QlgvAYpkTwn5oETE=;
	b=Y0iyJXuA6in/C2DNBDJNbi8360vI/EPWIWUEDT5iw8GIylnih8EqBaDRC6pwE4TirDn+bM
	utQ9a4HEnNVtU73jr25hE3wOxv4rcHhlHwLLWWbeCHQmuY4ijihw3GZIXbasiDYIeylqV4
	PC3IJw8sURYnLHfBgYmKSZ9/cALBZVg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fQp2HEHo;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=2dhk7HRn;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786621880;
	b=P95NBDJNF4HI4+iH2VpEdAzvKeW5Qu1n9CKaSlfCJDXDBgZNfA/ZoX1NRanjk9T9v5fqyY
	TonZx97o4psGk8GQU4NC5nobjF5iGpWQyJYcOXj2f2hqGh6M00FCj1cmQKgLy0WFGb3EzS
	VqhrVFWm8an4wM+9rf66R4Hx5h4zTPE=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67D7aWDp3098122
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:51:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=1cbE
	bpn5Hw7xsVAZB92jcWtVfy6QlgvAYpkTwn5oETE=; b=fQp2HEHoj+JYXCXLaZGr
	ldQMakSg40j4Abbi6x9/UB/C9DzuNT4s8XhYAzjbTDgmi+AReBDeg3fF4w4nWOjC
	e2r3xlUQcXZuOakjDvc5syP2LOebQ/7umwzl+LlGoNDqMqH50fyhM0sUq3CsAdOj
	z3fNHd3NQmXiYG1oFFV5o5AjpVx5bzlnxxHuqoyxwp9H1icuQgWTwIAxE7LWAzjW
	sECTj1JsFD75sjextmKJeH+KdK00vL8ZR+o7XBHN1XOd98wutmWH2oEAV5ozUktf
	P1TkIBYISO6QosVwaIJ39r3AJ4oc/Q4TE806ly9sceZBxgjbhj2OizfeWSqDrg8F
	Kw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4g0vmrmjm1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:51:18 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52d7b3b6aa2so3326791cf.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786621877; x=1787226677; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1cbEbpn5Hw7xsVAZB92jcWtVfy6QlgvAYpkTwn5oETE=;
        b=2dhk7HRnfUfEel6UaA0mD4B2d1OM/Zx3AEDyP7DKC2I8fQm3okRrtm9An5b/zqRmW5
         rxvbMrmOmNxg1M8H8NIaRw9f6eUnKA4HFb665ZBPHroTLCb9T+lOwkaz9hcIfhlbEWkO
         gM5Te7M5HxC9Ip7DQnuKoLDzS0ytJoBVy6Ox9nUEsx1ckuNwXu1UwYllOjKfwcmXlDGt
         aIST0aFPWoXqpm7dgAVRhff4ZXTJLqog/pkTJuIRezNK+qK/Z6uVeIKWhXQaQ8cGKnaM
         pPet1IBB+5/MzaEnsaNd3t6XdauYIRnQiNhOJTyKC+eqhAiWtdse+B/IflTpHpAfj92m
         9Fnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786621877; x=1787226677;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1cbEbpn5Hw7xsVAZB92jcWtVfy6QlgvAYpkTwn5oETE=;
        b=QsOhkLgkzmKbag9xeaFhr9/0TA/kRivonAcI/sAts5SB0YV5K4SBrHiOeMS4d/Muwe
         GDqvuwAwdpxFxbFjJ47vpJj2hF5u5x1KcmGIR/YXEUV0B65UICIa0G6rmsMvpwHxGDza
         clAVMBwJyTeZpnrRO0EfRJjzm9YVf5RDkILrT25XXMgTKs0Y4ArinxV0WlZUgeqttIkr
         FP1W/H31+6u7lZ21TU2ojxWOTPHSZuLRUJr6nelbo2hPtd4sXvnp1ZVxxs14M8irQlmc
         0FQbUVnOJafSUWBH8V6Zucsz/H4DUwBKmd8jNdpV7ioD15x1Lb32zN1rJAk8x1jIm4MB
         KkFQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro6qBy/m8w2k0OWz1T9V/5miNX2dP4EoxqxMd+D3k6SQfVoYkXFYpYNnazmcAFNyddz79N9e1uipw==@kvack.org
X-Gm-Message-State: AOJu0YxfeQQhc2uyjrk/M1YTC2YUh1NosOjfn7pdai5fomiQv6UHwfMC
	9lpD2xfKFDChgdmnti1JiEiBLB1AXDYtfDrBW+yMGBzk7YGAmZbjK9A+JHciYMnuPSFEK0jAvaT
	08YbfATLWq/vp85Kjh5Zl9gEBU8O9Hzxs6BEhElTjEpwvv+hy
X-Gm-Gg: AR+sD108Dfsj9Y8o8atKHjJaGjhLUAukDAtYSqsKzRahf436R8mkPbw9vCzZjDY3ziF
	T1clL5KvXBv1oBvl3Xq/T+7kD8AcScTTxd25CiCyQlPsYB+q+EMyDg+gxqilf4NtnY09sGYlQI2
	4GxGRQ+YD7hn4BNXQF6sNvdRfO7fORM6iTxWWQcrzi5rfGUIRR3eRXH+K91zie8QfrHqF3krEKL
	OtWA8be+4nH9c5J7PBAUyBkcihoZiNZiw+4HWlhThKXG1v7wTiaCnOx3VyUUeUozTfJcJnmDBdZ
	r6+ipCXZQ1k7A+84c8whurf8wVSyg11u/WoTSRjBOiuJ7uou4QoBPH9TWC7gEJlXgl7J21MWgU7
	S5kDoRFxtVHkoo2u9D0iW6pNU+BF861/JzwBJb9oyNGyTH0Xz
X-Received: by 2002:ac8:5805:0:b0:517:6d6c:187f with SMTP id d75a77b69052e-52d73c7b09cmr47608951cf.14.1786621877325;
        Thu, 13 Aug 2026 04:51:17 -0700 (PDT)
X-Received: by 2002:ac8:5805:0:b0:517:6d6c:187f with SMTP id d75a77b69052e-52d73c7b09cmr47608411cf.14.1786621876825;
        Thu, 13 Aug 2026 04:51:16 -0700 (PDT)
Received: from [192.168.0.165] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a569314sm6335812f8f.16.2026.08.13.04.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 04:51:15 -0700 (PDT)
Message-ID: <709df647-3af1-4d9d-a99b-c36c9ee69ac0@columbia.edu>
Date: Thu, 13 Aug 2026 14:51:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] ceph: convert writeback path to folios
To: Alex Markuze <amarkuze@redhat.com>
Cc: idryomov@gmail.com, ceph-devel@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
References: <20260810-remove-wait-on-page-writeback-v3-1-dd7531704f26@columbia.edu>
 <20260813112028.3989422-1-amarkuze@redhat.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260813112028.3989422-1-amarkuze@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDA4MyBTYWx0ZWRfX6TkqCYgNbA+E
 t+VolJWBFzHCGYgKvJ0KOZ/c2AeFIUiBhk+15N6NvGTNtiKzGR1kxu9XZaWduHwbdPFgI77HVMC
 aawFK5z8hxh0394R/l4LXEkF4JCsvgZIUm/JDq6h/TNT/kdcpVHFYPySYwfbNaLfd/0YKRA/UzK
 epSSRD3U8fTaGVnkh3p07JrwN+NUaIASdt2TDnwlcwXOByr6JkXclfb14dXrQiuWIvi5L056mXw
 zt3k59X/jhdeNzgW6HjC3W9Oc0Z6jkMIIlmGPWN48FIoV9NHmge4pPiy/TdUhg7EqDQ451jpt6C
 z7zKUzLVLPrJGCnbng8MmODkNVoX/G3xWnBi26SCXksEz0GLMzz3Zy3HV/jlABTawP9pn3Gmqb9
 O++zh3Ou67A8RfkZ90d6sq+r8RS926atTJ0CJTPsWHeGD5QDnve8XJ7nfDHxt/KzKM3IlPu2ia4
 WL/p9A5kOBwV6mqhxaQ==
X-Proofpoint-ORIG-GUID: kOwiqKCe-CCxYJ3VZpmAiGkQQ72VB0dC
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDA4MyBTYWx0ZWRfXydHYymuj9llU
 /yNnR1ek79FTqrsYY4Liu+J7szmRJfk77LUZH/jz+Og9Y5xAbkGSpDEETlChiuer2m2mQU64Djy
 MBQtniTuB/NtRtyEb7rv79zM+hX3HojmbBFpKj2rWX6jDboJM+yu
X-Proofpoint-GUID: kOwiqKCe-CCxYJ3VZpmAiGkQQ72VB0dC
X-Authority-Analysis: v=2.4 cv=e9A2j6p/ c=1 sm=1 tr=0 ts=6a7dafb6 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=mxPCofyttrhx9O2bwGQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11873
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 bulkscore=10 adultscore=0 clxscore=1015
 spamscore=0 malwarescore=0 phishscore=0 lowpriorityscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608130083
X-Rspam-User: 
X-Stat-Signature: by5m3my9w5a5nwf7xtsbfx94fubitnt7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B35BC8000C
X-HE-Tag: 1786621879-805651
X-HE-Meta: U2FsdGVkX1+eJgIy4nc3CBDJwRIc69Bl75H6Q+i1BWRdScDKwMUApV65lnxW7yQQBHbWX2JMN3ib/UahHPBK/kZ1LcCe2VcETU6yBDYxDGSc/0X+URdjfqLGpJx06wDFMH9E9x3Tm02wAEGO4qrNzJfQgHWt3DEJt+dH/Wg5YQGQUEvtKQsseyM04QyO33MgL5abpVBsYF3ikEI0w+Kj0VlOUqE4RMfTpBaFejYGZ8ngREZlBYJm2Utz4KVZMQV439FuNwHUz6zR6mV3thlh9eNLsNmJMvuyR0u2nJhhgTgttv58WQliPw1SmJyQM7hkBDgtnVrJyDMMAMwT6nVQ+43dB0xwp1FJxh6Mt8lf6sKja2iz7s9RAy7eqpdOSIhBQJUlXmKVS6rPgcegT9wE2eRczBeiMSe+JyMC3TtD/7akfA6vxP4lKyQu0dnXwGoQYD3v/GA4OI1/+dpUGZSscu6odesrjFCS5oaJ75JJ+3kegqnSO44HV+uZfcRxirtKqMZWqX3xpLlBM+dGyuSta19biPN4hbarqfxlD7vDQRyPg9pCBIRfWI2LsdIupMIZhR9q6VNIjUE2xFVrQCANBJyl+wSFYApUSbjuREQAahFHuDb/AbNia72AOZq/Fy4e09ZWwVp8p1kprtgTIs3pIjYZy1RZAvX/lOWb3zAaA9XxztWg+naxYKrpAaUOKXrQ3EtJ76c4zyqEF/KJQbtimtP0vMbHMy2zq7jWcTQUDetAEBT54HPQXA9iyNesFG0wIePnEmS0U/Tn1VShQLHnQ7FWsUdQrvMVxx9albmuXaBY485QJsTD6GEf34dgtZOwzKZUTdP2PO6xx5kUWyjJBZEf9+dU5CHCT4DaiPs78Pye83GrbihN+LmIDS/uM/uwNA0esIBZ2zq8pWme86JxgA5nlPGkyUY1nNpxVWSb07pZZmuJNeB72Bhn1yRSl0fKAFXcE0j2jAjdjPX3mW0
 vfjRaWjr
 C1L/YCbwuKK5lkDWi8kk0ieXG7r8A9/0AkVjDO0brkrYI2290aHKI0Tes8bk23tYNvbI2h3Xh/6DorW9n4zFP1mmmvFZlqCTEgWszitmuL1OthfeFQqj3y9c1D5LsJeQ847WJuyoPMQ3wnLBBkIQCbDgQUvXwg4utwTCJ73y12+5V9Rz8wQyPFVxJVK1qZkkWIUXmRL+i1G+Z07bfQUopp9xKAr4utpmk0hfpffZHPmL1w5qmBZ0rzz7Gn90Q0RptX1wfjmFucDGiwxuOWfCMGiRGuCudb4m89lPu4TosecV9dqgrY9GnzAUqMSTvz2Pix3so2WAIkI73u4Wii7HAYeqwzrXoSe8UXJfOFZUpe0IcfggsodaTyrTjYkHf3zMUuH/FZMnB/VoGJ/SDeP57Z5yC8zp4HvMoZJzcfv9WHL/h5iEgrYHWeyTnzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[adding the mm maintainers back to CC]

On 8/13/26 7:20 AM, Alex Markuze wrote:
> Hi Tal,
> 
> Patches 5 and 8 remove wait_on_page_writeback(), thp_size() and
> thp_order() from mm/, but those helpers are still used by f2fs,
> mm/filemap.c, and mm/folio-compat.c — removing them would break those
> users.
> 
> Could you split this into two series? The ceph-only conversion (patches
> 1-4, 6-7, 9-12) can go through the ceph tree once we drop those two
> patches. The mm/ helper removal is a separate effort that needs to
> coordinate with f2fs and the mm maintainers after all other users are
> converted.
> 

If this is the preferred approach, I'm happy to split it up this way, but
to clarify:

 - This series removes the definitions and exports in mm/folio-compat.c
 - The mm/filemap.c use of thp_order is a local variable, not a call to the
   function
 - And I don't see any f2fs users of any of these... it looks like f2fs
   defines a folio-based wrapper with a similar name to
   wait_on_page_writeback(), but doesn't actually use it directly.

Given that all users should be removed and the relevant mm maintainers have
provided Acks for the two mm patches, I think this could all go in together
safely and avoid delaying this an extra cycle.

Let me know what you prefer.

Thanks!

Tal

