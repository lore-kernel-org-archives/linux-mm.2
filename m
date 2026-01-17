Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C49C98327
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 14:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 824066B0005; Sat, 17 Jan 2026 09:15:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1836B0088; Sat, 17 Jan 2026 09:15:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6456B0089; Sat, 17 Jan 2026 09:15:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1A86B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 09:15:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B4DAD1D19
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 14:15:36 +0000 (UTC)
X-FDA: 84341653872.09.8211DA8
Received: from mout.web.de (mout.web.de [212.227.17.11])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9B02E40011
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 14:15:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=vNN5C054;
	spf=pass (imf27.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768659333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqIofFag1POKA+lzs2mmMmqamGZIMXPbQdb31WVW458=;
	b=Lj0x/cVwuhHJq6FkAtmigDdbRI/kK49jFQ2lUIw41OMYq2nZ6ji65GbU7KYpKz893X2wwh
	OF9GQ24PjA+t6LWR+YQjvlrPdl7k1iGkjlvedUdKQtHxUTqpHlGGeJSKiPvkNskMQolLgC
	5kmRWbYKOe13lXRRnUSkARBnmn/XjSA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768659333; a=rsa-sha256;
	cv=none;
	b=0knJ0PGPwA2311vSSoG0Yfxorgd/lmympdviU2ZTWWLQdX6kPSqfY73NWLmphHS0wvcbtR
	z7skfQlxaatiXJ5s/hh7+Tq3cRKOb7rlbk9C5VeXsnGSi/InJYwRR5X83tIj6KMKRY0i5f
	TK1BYZ2m11C5gMsuLxjk+/1pyh6Sq/A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=vNN5C054;
	spf=pass (imf27.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1768659325; x=1769264125; i=markus.elfring@web.de;
	bh=gqIofFag1POKA+lzs2mmMmqamGZIMXPbQdb31WVW458=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=vNN5C054G+uFb7dFFg1ZkIBIC7g1dn7euzjKB149MQqUwLQ125lCHuUwhWbTUg8O
	 EW0uwn/OT5GVqwUVjw0NYTsiFktLlmJ81ewVaWNsisj4im5IeaUr/Z0CP/gsSR6io
	 3HZ0hOoCxkLUUGo5IMXFp9U5Uf23AY0zxvxBpeJvdskl3LmTgWpApCpoy7cyBigiO
	 5MLlL/Tie2gj/h/SpAR2bCIaPU0/Y4UHd62Wee5u/DXHeKbbrVZ1eDAlYr7KPo4n1
	 6rHqsx0egUmkJG3N9j4rsx3DlAckHsFssq1mYRdMOyTsxeqilTbXRSQpQ1PUfS4l4
	 mu0oBDt2FvNkT+tDXQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.177]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MhFhg-1wK0bP2RHO-00eJYr; Sat, 17
 Jan 2026 15:15:25 +0100
Message-ID: <f89b35b4-c912-48fc-94fd-00d554222d7e@web.de>
Date: Sat, 17 Jan 2026 15:15:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Yajun Deng <yajun.deng@linux.dev>, linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Zi Yan <ziy@nvidia.com>
References: <20260112121614.1840607-1-yajun.deng@linux.dev>
Subject: Re: [PATCH v2] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates
 in move_to_free_list()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260112121614.1840607-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nkrlcC9q1WGqt2k3AZUS8IOvRqLjmxXFv58RqYN7e8DfF6kF5aS
 Z+t259w1cWtNwuG6sbb6hzm2bp7DhDSgY78Qva880rMCP9PgHOnBhT8i67IugSLarAgg+lE
 0nJV9fie6lIIiNuomI1A3TFwQGaz1pE35nibzeJlz/5UL0dvAQHP4U9GFk4QDNFhPVIIkfn
 xr3bPaKL5W3ofGJDncT/A==
UI-OutboundReport: notjunk:1;M01:P0:rOh1J5yYc7g=;q+p58HSN3NSpiTtJI1WxsckU/1B
 6cMN1Resaba0BvHhR9Pnbx5BFhYE5366hGbb3vFxf38Q1RMLQa+6jvG3L1gWZpgh3Z7111PwN
 Vgi654XdJ65JcdWO1ru8Y2GxN20SSt4DJ1TTjMNpcyOEX5xMLLhlDV7Ci7YNNsE8JqKrI9Bxn
 F58YlOOQ2W/LoRrlztLCqD+iRflPqcqbrasfF0JLvrVTl6zVRlCfwtw4ZeiiV8RbjFqRfZHI3
 91b6PWS/kUrzLRy29SETQrcu+bJTFDydUwxbeIHsVB7qgUIGquRFghBsxVu0HcpCQ42BaV61L
 Lba34sLpxmfvdtdKQdeBGqVc9FoXww4odzqFFVYFGZeXJeVBPlEthRMi/7enDECYopkStNxp7
 IODSeVMT/LNWTLzOl123ZJxnucSdWObkLQFEABQ/axkwWw3I45TQvz1FTneDV878NAcma4sL0
 N4xKSVlhUDi1gxh6i51FzuCha4Gn0E0VrWBCqiYarTVS3jrEhfZikdr4Otih3rYzzd8deXiGj
 YfxCzBSPIdYPL8qXU/4XQZAHd2QdG+ETAo/xfVXHjMxpugNWyBYdox+XQeWf0dqYbRRlfJ3Yz
 P37dSketNV3g7pTcy6IuPqEAE/IUPD2bcFwmzNkll2H3sruIKIExBB9ORJhWTsAgey/fHHFop
 WN+ZcZGtthck9gagBa37qFN4q3HMNE1yFqdeKDZWri6Tu0j/HK0V0WbR8fFlvhDLtmupMB2GU
 I9o8N/JO87mAXiUOGR8bS+v4d8Av4SYEwDG5Cp/d+2SDdqdA9311c8fBERnb8WOj0ulwia5cI
 gEuDMD9+3TJH8i6+J4JooW8CvFkT62eI/vCsQW/zjadwnp4qaYB3rTaZbLMuwzyjT3ShM/uTR
 ++lyC0B35BE6FYBFuhRHpaVurogfNfRar1CX0dGt5acTOG8JTDGKq6E8OcptN10IkDUwZoxW5
 9E3xH5BahvfKHFEebtvIX/1fqkkVlJ89ykdVwOlrfd80MVHq1GUBvttU8hiS35YfPzYBOwgGC
 bAZ6jWSzoQH2Z7GTHtaok+wja8uUv9UNViWdZ3fz3W5SH9b4cayJFzhT2PZXElEbQ/Yk0a16T
 L0lBsETROcFs9u65GuhI0WENUJupgAHfkRjkIz0EsI543WOrruFjev3tS9f87K169otB9ox5B
 q1BGqSokyuZGIAWeGH1Bv9q0VBMC6HiUxYBPZV38okE1pJ3nz5Z36GZIOT4a//zy92GQ9k5zd
 4hwzU90u7umMMl7j9Ba4cyxIoeqqqhDh5Tw92ryFvcjMZGey1bFNVPxAe0EBBIELTiiM83kTX
 ZsEBM6KDo+Rqlk2r0JTvVHWxazPXdonC5xoYpWkoLnuNDpvjmnRBsdUvpZU7FFaB7Tu16j5Vv
 B1G36VXTnW3b5hzVYAoW/MptZmFuKV4zxBKK50jSJ2VLkjD5R1BO9hAPxRy5rlRveCX6Z3/Qb
 pUkOJQ7JZyBBBLclaRVRIyxFbHehAMBpxuHlhb4sh7ts1/oybd4yHFhDugKXnzPJHSU9ExKHS
 nQuUi2dXRgdQCRgvudd45XlJDgD/2+33EwDWdbbzPVaQDfr/SqUu0s6Z1uYLUD+CBPQBCimuA
 UfER0XXSq5TPDGkp54KpLOUkedwM1+P1001UpVR5YKcVJ2i4Ov3Kd/PLZgTCePpkghfWZmVzk
 n5uGk9Hhu7GEI9i/Srg1+p2TaYl7Ka15yL5EUPaABeu80+hFeJFE3y0XaLSy6gGAm1pWAjhsZ
 Rk2b5VbpvPKqx55z1iEI5SM9yibZfUFEkngAp1nsmjIC/RM1ehA3OLRcOeYh8VTq74KoS3Rgm
 gBmFtg4CnO3FzHObUgRGCs7FZUc0LpBb4LRNT/C+QFjAPqmmqYgUlfJ9Lx/7fgAaMSdIpU3p4
 KIHe8kqTVHHNGPFcMRpjvVDv2hgEcg30bofDFB2fxDF4NA2AH1w6szpISxUmtYFT6lS9D6ZQN
 dS31Ly5wf1mbU3gKda2T56QyLLbNInIzgn8mFJJaYmNwFOnAESHtiq+uskSZjcbFIQOAfyAUN
 Bqf20PUXLhiJM1WO7i2QT0+rf4wgxf6vsnwPNwCOdqU2rzuRactj3F/AiR9a7J/3C6kuxY8rs
 joIcwZjMm9vjxVIxYqR5R0uH+cDWlblgwy939TsHhFZjSiAPymYhV0Uwy0vR87x2gkVeelu0y
 LQjQCggORD3YYuvx8nW4zAQ76R58cy8uhc/SDZx/iAhnBchbEtUrPelz/7IahepSGjtU1bWwF
 I1qrb11aQ6U5dXjN+clo3tEcIxQOLELh3kmHUXGB2sKHez72I2NkNzHecovW7uLox9JNBy72u
 ILiSM7VFbXHJZGXppbUzC0gs9J/5cNFtzl2t0L1n7ovKixF1FN/Scs7zjl/JazXC14lwPIr+o
 /XmkzCn+tqgJ+MFriy7CIJ1uto/yimyYb0pBF1TXty0VO9b+N3H57ODsM7PkyTMnjKMduScju
 NkEvgdHexYUP3KbPHWPmD/MQ/Ulak8Xi42XGLCqhxfBSqydIfEwkf7FWC7+XxiZvKh/LiXGBU
 Cvi7VVIknQn5aLQjAK90TbVe0uVxA5C+vS9aQ9jmFPdl7jeuVf65MAi9FiFkCnbo23wve4RKx
 4KKtRZ3b7mFyhlLhvmRB2RCvXF+DkraojHNbq32XYyqNpPfzLos5TNVy5vC232SqU6ePegkV0
 LVTmZ4+mWICPfb04CZAw3UBbwneKNMJtYEP79PUJejqeBu8Rlo+cHlELqd+SgZezc3IHG2v25
 kGOK+7/gSYSkqD1UGN25LvvOWD0zwPU7Lz0+UK721u7qS7LqEHTlf1IdfB0rAd7biGN7B1dYe
 RMZ+xWrOhun/7/49YhKx/VgttRFXfC/ZUS2e6HxFBOErd/vmZPhmpyXHm0F9nJ224Sf21Q4KL
 blVIdCfRoowcAX5hkbJOPQbRz5Iktrflr/6PZ8nJYPM/KZmjtjE50yJddLFEt8FzJjNLgVpAN
 XmmRCx1eR0WgGbc5lFdAzvNxT/Wtf0kl9jV7taWoUoJyWM8Pbu4zJO2KMStpBXKOL/rIbpRBw
 hs5Rod3UEEJViRsns1iaHg8/iqIHC8bjnXdPfP9cKO52L3+MAXsnzdKxQcwwHXhNOZrsG/sWR
 /tceR/Bkpea6SghP4BckbYBhl+DEvJcYiz8ETbQxcdWv6EdAACcWLEj0Mhw62JzJs/Vf4LYOw
 cCQKX0mpZhnZSj8T3BHdKNoHS5FEAH3rJFIEnGb+YJjtTPwrD+gbeC1c2quuu8Y0pwTmK3eZ5
 eSQllomF3ckJBiFM0YZoEn/dYGqZE8sXQGq57vDzF3MOUIwj6rwqQjLlJmm3Md5sBx3ISQ9JA
 GjZqOHa9EH2hbKfvGVIiPkwSfLk9mwZo/I5sDU0To4kKjLNysQgC5vNo/bzEwFiWm19gsNCvK
 /BnITZJHfpZYxfbpW9ssbniv9hi8up+7/H1uJ/1FD0FNlgh94fiATDOUvKRYwQFCHiUtFQwpr
 CwSQ6oZb+Ye2f0x7xofesexH+kBvN07oNiLA4kzOQHKi8Y2RzZ2OZNfYeiAK9yKm/f46v6Xwb
 aT4vAGY6l6QSNxuwcSY8oDRzdJsW1nbBxThyF74PKq/ZvkX0ZljYYjxTi6wQtcfqne+CzIA+2
 fhKFp0oHmCZVt/WTKdMMfRS+jY0IUWPJFwC1GrHM1Y0nkZtNw2BY0P6JXUbAAf+K6k5d9P4Du
 k3VjC0MggJKNPdjHcDc90uHko3QB3r0CVUkLAN2RoysSthR3S4VyWQOuew/Ky3qhQM7/4mESV
 /1jddznlHDMgaMlLIUBDqu5NNGALyqGGRq/o3pSZCbur213Q9EBNSRVSu+DWCddGbuUgO1lOp
 Ix27oys6eX5kn3HRjmvFF7FXrAppBggMK1Npyr/p2yoAEK8L5mlE0+V3YagZUi783GFT1AF6B
 X9aKCujP3HQvAw21KZWC9vs2SMXMh29Z1FnMytboyRtc3ITbVs02TFX+DjXeFMcmpYcOgpueg
 +ujuHfI+ybSB2+XsKThvJlaaOTkNgz2NsPUqXs43ybm76m8LxRQ5eZBR8wTX44EM7M/ziEMeD
 FEgbymCtdTz5PK4wNvAqZ/x/jgcaHSSpkljGUtCXu9Le7UiPKFnW+EYAmQEI1hkBZRo0QHHRg
 vXScjJEPBcknJFuJvRB8/aOqvrh/gduFb38AKp3ON+4Las8SCJm58xsk6HhODNlFSBEnct3Y5
 4Tl1xu/wWsoMV5OqLQ9ohtEqBOgaSOpXoIF0YjKlIG7GCfx8DWlh5E5MNWM80mFYW7MUcdrcl
 mRqdaOHm4l5etYRcadWi+RO3K39gKPq6N7fMSS5rLoJkRvfLkuFUoWAJ6FYCqVr3wdwC0rbyM
 D1i+pdpx7Zo1c/8TANvsjsLIYjGgNDb6vo946B0jE8OAsoyfe2REBN1FRM/23H6fmjJpDRXMo
 L4Eh74NGnb6y3uHtZRA1sisQ/5NPop88wbBnVjkzVZReomTqilc9dCn7t5lnnp8JBHMJww6/8
 qgbMVjbR2tevqxm58ofTbb5Xdlf0KboVTSt30CK9x/DqmafxFYVVBbwCTthuvpsfe3DMJYsYx
 Apu+fjcevzhpONl6T5Sn5236hI7SZxRtuZgEw3wscet+pLNMo5ceGhwDgQJUT2UY20//xOjKj
 L2XQltnA0zKUPtcF0EOp+mJIxCGj1d4vojvk7UJGe2Mc77TdFferOQQ607SB3ewS4sxyhWtij
 kgaVYr3IgqPRWBqnz38WFdh0w8dpTH8/IEnYLp2ZZaRPQ9tWYwGFruRy8dfEbuPDrR7NI+Dti
 jlTSsHSBoFUXU9vBm2u7qJhVzcHhallqQjV/hkNkFRMVoyOE+69FM2oxqhTSW2KmhGxRObzog
 9OzrTWLW7AlzdKM0hWoHH+tjp0uAHcTEoxgjrqjTSjhgeZFG5HW+RDjCx4ylJyD/IoA6lReeT
 bUdNSknRl5aKGhRkkEF9vlpDKwgcBwUC1rkJMeZgGMtdNXA339ujTtSXLyYx22c3x9WDxsZe4
 Mvfq9ersmCEM3sLBVxPwRm5RtXRJpYAKMFTqeezRp+iZ7LFthrhzBc/PwtG29+6Pmnryi8Tb8
 q8NIXP/a6b5H15WCgPo1Ws7zo+9czLFzu3WDHEiwTP5PQjGZSeym98sXHsXptbT4XKYPUkEJL
 wCf24qXZYQ8YQal1nbOtAvDyLblJ0vFQV9SAd5AOERehh//nK8bklb3+IKapYw7Ktcve6FT9u
 q7W/WWZA=
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B02E40011
X-Rspam-User: 
X-Stat-Signature: w1ffhaq8j8mmrishcwi4bjg6b3fbpskd
X-HE-Tag: 1768659333-441752
X-HE-Meta: U2FsdGVkX18giChGACLFvlzhUB+rqp/xTXnCbp5I2VWF9wszpkIppLVqrMhs+s6fQcWygz2JOQo4ONxkfu8hCey6i3aHcXvrney5yc7Crm+p9siYu3cJghJ5SzEzsjmt+qSa59niEEWZZR9BvtqogYNM56WsFG265QVdWxbZNJ4hZa3APyiEXziEnQWE54c63al2GK2nqQ5TYaXyaq8HyH+XRwcmwZaeLKqrKBEOB0MBp04EibYaD9nx1cTnef/JCSGobnHxLqW71uB7tOHKa2LfszgzDe7kzGuB1GPfzsP1cfS0VmC1eQK62I0Z5Y0ZJm3WAJbafxxU+/gq0gZEhTNPwLBaeg275C7rDGDYsFfzGBuJzFRY2QV+gmnACOBP00gj3H6uLONNEvMzc2+arCvxrw9nCGj9uxcLq5BWopkg4DcVpn3jepH+avf5t8XRzW/pu2FRhWzVe20RgRXQd2GpbWgR9LBaSBOSBKbMdvahZGMwYeX9LENSgtDcKOeqAmCmq3+Tsls1Ee60rhoNtrAI6WoXWpvFtkZlRhyRBfDgXLAMCzxkS+mAkQFC/Ik9xFX07UYsgIWWpsaSuBoQ2iD6GeE73O7ypEdsgqzqDEChk+U8No7r8a/R9Z+h6srn7JMPCcUsQhtarjHoVad5P1IgkDKzV3jr4Z7mgnV/mpwnPjBcbTZuh1Egl7qxrWxCn51+ENtqIPd7zEpuaA78XgQTjuYHXtFpfQH+RcnGefD/RWFZpWFK/w6NVYB2UMPTz4f7jtrgQVu0fMgHCSzmnE6Y1CYQbOYcDYOmjlr3eB1Go7Kgn3ao9+K+gjjyTzpbYcS4kCQvzZFUV2S0YYXscnyzbnJgm1mdX/hfZZ41RtsRv5aCkQjVU+79IYlw2ujBuSsUwk4FtWQ+UI6seYBT7YHdcOO9d1MhH54G9Y76ry+jdW1ZT5P9vTIfF386qMUoBMk2dpS37B4G3hAmmHH
 QXiNgMtu
 80klcNl6ZEEaurS4p4vNe2idJeW1+TGEyBl+/dbx4I8Yk/hSzC/5t2z0RzYnZLqjIAxnmFUXaQecEKtwMFY8kSjWNUk+XZ65zMcr1HHR9l2V6q2Q/xpZbm/pCYits66K+XYzuHilnqX3v0dHfxKocRUhyBQAKB4uSVmD0QbWAdW0JEuh/1Fp7aOPEEd84ASQK3Bsc2hf7gQDrKsZunFSg3q2Csn2CD6qGJAiKYrcU5KuF9+YKPrX5tYWc15DhlPcHaNmmRRW4xOTRCLhcY3bjckWGWS+7/lgUOe18fkMfLeVhUHHge3QB04LLcOKLs9YgIL5pRrBiQiVGJxZucT/dpQyJFN8tWVub4tM/hn0q8Gm7xP/8nxtqkDdmpHKlaHEgRDzjNpXxjGZk1rBmUX9Qp4OvUK+8MvZnIXutuOXbvoU0uemyongp6EuQre0CTJ3giWDE5fBy5jUWewM5gHFyb1apdxrjDmi4ITuDI1tsc29AJbUgG2rbTU8EAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> This patch adds a condition that =E2=80=A6

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.19-rc5#n94

Regards,
Markus

