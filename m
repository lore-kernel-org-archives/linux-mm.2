Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33ACDC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 22:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF306B0088; Thu,  3 Sep 2026 18:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AFF06B008A; Thu,  3 Sep 2026 18:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FBB6B008C; Thu,  3 Sep 2026 18:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6F286B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:36:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7050BA06FB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:36:29 +0000 (UTC)
X-FDA: 85173911298.04.1B8DC3A
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id D45091C0004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:36:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=gmI4LzXl;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="KBhUSk1/";
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788474987;
	b=sQ7EwUwQHkzxGKtlTH2CcAXRpfHbTQ1IzQPIk84Q6YxtcYPUt/mKndhme/O6Av0GnKmP0K
	6UrTFY3SPOEzLud5E4nzV1C448uJgnB5WpDQeSN5gVOPKms7sxsVDjLbTFZhzUPOvm3hBh
	8+YOkUWQARg7FZdSqxjvAz6Iv0Fovaw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=gmI4LzXl;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="KBhUSk1/";
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788474987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iieITx8FG+BUBDRFx+zChg7QgLhyCTCz+Chx0VCTWeI=;
	b=67dJzoNsOAIrjuR2Z0pjtcxD9itlQV88Bv4e+qVRU8DyQQKLm5vlFPNuzrTg3lBHRZvAN3
	3xvPcE23qV9HPK2s2MSmd9WiU0RPW6qGU3BMBVS8cSl9SbCvDtMnnmUHsQvLUG+7hPqwC4
	ev8qC1qR0K/1wUfbCER0rvsJZp4n9+w=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683MaPHt760708
	for <linux-mm@kvack.org>; Thu, 3 Sep 2026 18:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=iieI
	Tx8FG+BUBDRFx+zChg7QgLhyCTCz+Chx0VCTWeI=; b=gmI4LzXlug0M+JiQLPMj
	jZ2aYW3ufTCPlNIRBKV80vnH/QUypiaeAkEVqTtzgfVbTGNWgpn4aW1aF27N6AkH
	mgGKulG/o9lYpoTX3M6BGL5hTaQmKFAYkQpkK5GTw/2aWxFdDFrc/yDsIWB2K1Xt
	LqMFplevHWLvDsH8YrbR6/7+SFw+U5s+TNmnTL8WkNanwb8rziHteyxgXwjsWjWw
	BgDzG9/YbqhCAmga3tezaMxVJGEAJThfZAeaCem4HpcvhP28k3dAJzvs1hFrOaY0
	MmGsLOGpirYgQ0dKbO1kQ8lAgb3ZwVM9YW9pRakZWrYTkrlNeXaccWLwC3CjxgHq
	Sw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gfhgug3sa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 03 Sep 2026 18:36:24 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-939694871aaso62333485a.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 15:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788474983; x=1789079783; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iieITx8FG+BUBDRFx+zChg7QgLhyCTCz+Chx0VCTWeI=;
        b=KBhUSk1/dygsuMJqzc8qPvpK8BMJ/CZONGUZZuVGUx6p4Frktoq8AeCOAnG8E2V3uu
         Cix+Fj4F/tN/3UvCtCXVEyWSLdbrnTyVwj1be8G9dbv6SzYDpIGEbi7CtFFllsuiPIUM
         eTCZ/33D/feN3sYtyhqiEer0GB8AWUYpLBlbbpx/CRqAjRrzWSnosPjEqTg6EmDvZR/q
         0TwPqjrH+B3qL9Cvz8qIb3NDyJbu7ESdkNpNC+o2QyzlD0PcDRY81M5iR7zEasIcHyKw
         8vsxsZtDNLy9jjotRq5meMNdOHgZSiE3AyteETKtkbiLWPkxQzYIKNraJ4Ved+Z4Gr25
         VMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788474983; x=1789079783;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iieITx8FG+BUBDRFx+zChg7QgLhyCTCz+Chx0VCTWeI=;
        b=B5bXFzPf9sAjVOik8LiKOiY8U8zytAPzADyU1FmZYY9biUZzNea8QBDYsJQZSEXvfk
         DT/b46BpAbp1Xg6vBwsnWlApd/F9Dbi4HaANN3TVTSUMxOS4+JyiiAxXg1raeuF63lh6
         cR3oOTg007VthmpwPQWWt0mHy/f3aM4fTYDK1yDkWR5MxxnUg770izBHObGJOrxF6FiT
         ArL6WzpFnDBzLTIC6JtQTlXRwteKVip6+cKirskQjFWxkuI4U9kr+qY+8+ZZVgHZijE3
         8QikoF2u7LSvFvdAG51/GzWKlJ7kZioyTX9+8R1zm/WDgf9QZqcP3t0bxZJKNIcrWVIu
         M0Zw==
X-Forwarded-Encrypted: i=1; AKwUvBx1y0bvA7DH+F05WvYku+rS9D+SmdljuQpQ/nrrQO5zU+ijyD2mJxljB6uRMEt7eeQBlE8apc74jw==@kvack.org
X-Gm-Message-State: AFuF++kn9/fyVgxjNHycaZij6W1ysiqnUJ8DR81A3LDOW7J2XDnB38rP
	4r3uEn+YmOIxRR5pnK7H0Z6/QJx+J3z14b4eWZnNRC9wDE27AjuiCnfsl9rv2e0MQqjdCoemN3+
	WVIOQGUyQeaR7UCxLsTshatvCfOBreTIrvbWUpmI/5FRgkzLt
X-Gm-Gg: AYBFou1RpmQm1Oir/mcR1xXILvSNznYCZQJdn800MSxr/vr6qyypdWxyeo09YsfC67Z
	X7fk9sr2ZFSoZSwg8MglgoLv6z/psZsEmWd7A8MKOL4hiu/01ij0yqtCmvBWibOSt0KfSXVAIUl
	JuH9lphxPxKalqL3OOIFbGh3ETIZLbxwqmw4DTZlWHjg8puTHnzSNkyASE8pcp0xfCp2NG95vcm
	O6U0a+aD97UI0QYzi5bmIHkuUg1PYCcDQiabjTc+wE4z4g8wfmujdVmye4EnOH0pSA4d3xUv57g
	yV/1pCbp/CfA574VyJn2FQhG7cvuEDP06O6ACD3Ii33LPOfvX73zDtEXlTi4mIqa6I4LqenloId
	JsazryIXDj1pjXbKPavK02fapj6JObm1qIJ5M37S4mqIGJOjL8g==
X-Received: by 2002:a05:620a:8016:b0:930:a635:a782 with SMTP id af79cd13be357-939802f7476mr224865785a.11.1788474982813;
        Thu, 03 Sep 2026 15:36:22 -0700 (PDT)
X-Received: by 2002:a05:620a:8016:b0:930:a635:a782 with SMTP id af79cd13be357-939802f7476mr224859485a.11.1788474982194;
        Thu, 03 Sep 2026 15:36:22 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fb90d6csm71746785a.33.2026.09.03.15.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 15:36:21 -0700 (PDT)
Message-ID: <1e5118a5-6b61-49d0-85e1-825e22059241@columbia.edu>
Date: Thu, 3 Sep 2026 18:36:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
To: Barry Song <baohua@kernel.org>
Cc: Wenjie Qi <qwjhust@gmail.com>, willy@infradead.org, jack@suse.cz,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, axboe@kernel.dk,
        trond.myklebust@hammerspace.com, jaegeuk@kernel.org, chao@kernel.org,
        qiwenjie@xiaomi.com
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
 <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
 <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
 <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
 <076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu>
 <CAGsJ_4xMK=rPXCH5OiCOYHKRQp-w+xDJQusJ_ykbuAuLZr+8bA@mail.gmail.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <CAGsJ_4xMK=rPXCH5OiCOYHKRQp-w+xDJQusJ_ykbuAuLZr+8bA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: seNEEFyb5kGUqZ0_XmrIbNAOG2YLgXsi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE5OCBTYWx0ZWRfX+fSQyi0ecUao
 RcKvj7xfV/7rhWCnEOAEULsgTFzuOgwIThFqeToOfzBqx1KgZk5/sC9+w65X8nx0lpoL3F/mDWF
 5yyGfQib4wY9dwTTOKGoOgnvyzyfPXSZ1VMooEdLwKaFiKAlE9rw+QBsE5aH01x3N2REyi6OlRK
 R+GqxZQRLdCETWs6s1MxRhsUzmMD4nzDgdo3NjTyC1ts0RldZsReUT1eCTtVzoEhiyelcVmCcKb
 lXrG3EipXb3hyTpGfvR+nftkgnuYmq1Jai3C2R/uxSRebNKDOah1DqmB4J2rIDAv2COpqyTQi4F
 q+Ix2ADa2aOxuCEGVYRmdgxEZ2LJo0b8VmhNURaTzHkrYBaj9YQHNOA5vPMOm6tJp3Wxxe5NkQa
 o/TjzyTLdSvwXlVgzC5pINBfrCj56WCzhXhMP/E0CtZbUk9R2DCfSNXwiK27NGa0CntwFlIk3TU
 b/r95IBRp70UBDGHMkw==
X-Authority-Analysis: v=2.4 cv=Up1T8ewB c=1 sm=1 tr=0 ts=6a99f669 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=IeNN-m2dAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=kgJaSMB93tmHpg8ys4gA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE5OCBTYWx0ZWRfX4/00DiCi1NMM
 UeaIefWl9u6f8vEY/5hXC6QoMXeE6eUXc+mzenMIM9qjxKB18API1UcnpD+qO8anOK2E0cxngd6
 WoErsRWBvL4aoTiSPtzTIQBCTl2GahXOuW7l4qFVThCKxWdtcbbw
X-Proofpoint-GUID: seNEEFyb5kGUqZ0_XmrIbNAOG2YLgXsi
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11895
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 spamscore=0 malwarescore=0 adultscore=0 phishscore=0
 lowpriorityscore=10 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030198
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D45091C0004
X-Stat-Signature: wxj9xudqy6eud6zayufyex8oqki7jmim
X-HE-Tag: 1788474986-231149
X-HE-Meta: U2FsdGVkX1+Qo6JCE9nvUSXBR474HlMomoxMKwdU24MmQ5dmoh+wpHoUAwjmfakANpmW9MRNWdZWER12q8WccblYzh0wf5LDX82ch6gWAHeRTjSWDbQNeVut8aTbIpQRhgYIsQVKtOAhoDh86UCixNwRt8OVBKb8Y3JIi27VWwudNqU3qicdi5Efb0pmx0yAZGQSyzazrXhVjXoXAow0yBgL+iYy8e3fbvzvPK4dKa7B54k/zV5kGVLgzLd+P93x/0rGqCyNamk3earCNLpsUlAZQxkHP/zeH73S6OPS9tciVQJZvyvVEfJ6LmI/B6exwlnlruaBUNDjcgCpOsCBZixXVPJ9d6xnjrbWrLtQPIF9JPkzIzeOI+wa+hmvRc0TIn5TjZPMh0uEz8fpKcMJcnUJqkNd732HkKGaEyVQxIdqjjX1ycz4F8Fod3NlRAk+za3iy1CAVqKwniCGLwWMeCj1sbYDctZQrhwnrRehnHjhFU09v/2hx3hcyw2y99enHes8FZJFoaINjxV+scnMUK3+hrVvuiUWuZN8TCl+wSj1uV3wEcrTHdw3ucGOSx9BIx/ATOL+DG9FINEYowQwZ/bJuzl/i2eZkfh8q1ZraQLyJtmUp/x1u2fm0bWPTvlnjn01U7nSG7Zy5wlqMuuJi034DHJlUeJ0y7xwN5efqdgXQFgWsHXpeRlmI/g3iuGnyeZ3VOQeSix+6g+NsRbgi5gMj91nPqUnuI8gIowjAMrAaW044MDfvc3oVOVuT1RqoZ2cmtxWz3aos9zZ3hg35BXnVNzPiv8JJ/i7jHXWJdDDDkFh/+VEO9fbNxbMWU7mgW8JTHKhTymrtU3iURdDEDNPcUnj0FR1lAh7WYTIAsNEyHuNVBIK8MNxgTyxu1O3EI3zAnL545gv1Q7ARxao75Hd5EyXVpiOQxm5ydM8DR055hk02/KP6FQ7JUqOwcORm46HeitbXMYQIyXt4lK
 ediVes7v
 JAnG6dLHqK1O8ugfc3wP3ZuxPpKesijmEgo218UdbZgl7mZqfs0c04eadqypxlDvGJbwgFsc+FQDaSpvdIzY56aInILRaomM7kg+szusDZN52v4/29dRetvsfoFt0sRkAjPnRVpsqCHVSP1ho2AfeY3boifShdvJburLyYXJwLIH9+Nh3b3wQmkabUQfnvKPgN4FdgLzJsCChg82uqDtCu1GB351XyedF2KkL8STdanjOnORTmqPZwzCdr2wSQG8lbuwATxLErh3+Nkf91qS2TUkbPii8QfbaQ6OexvnvuLeXcTxCoSDGf9BJgZMEWtBAdxVH6bpobTiLgi695xqf0QLsJ2FPIcy7Ucid3rGvjbdaPvDGLcIMxTX7OzwX5n/KOGvw5ZPscWXXTn5NYY0CsagiBND+jnEEOVME8zhjumpEIB+kudTAMq8p7MzBkZk7ccAPi2MjiKTmQraw3aFPiePc4WCKPFR/mv9Kflcl9a54SdYVE+w0c7dzdyjRc5xJLN5dOZHasfvexIe0Ql+173F0eBBb8eNj/Cqdd5ldSyRsovk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 12:28 AM, Barry Song wrote:
> On Sun, Aug 30, 2026 at 7:59 PM Tal Zussman <tz2294@columbia.edu> wrote:
>>
>> On 8/30/26 6:25 AM, Wenjie Qi wrote:
>> > From: Wenjie Qi <qiwenjie@xiaomi.com>
>> >
>> > Fault-around can map ready dropbehind folios without going through the
>> > normal page-cache lookup that clears dropbehind. A mapping represents a
>> > competing cached user, but writeback completion can currently unmap that
>> > folio. A later mmap access must then fault it back in.
>> >
>> > Retain mapped folios instead. For a mapped folio,
>> > folio_unmap_invalidate() can call unmap_mapping_folio(), which takes
>> > i_mmap_rwsem and may sleep. Retaining the folio also avoids this path when
>> > folio_end_dropbehind() runs in non-preemptible task context.
>> >
>> > Unmapped dropbehind folios continue through the existing invalidation path.
>> >
>> > Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
>> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> > Reviewed-by: Tal Zussman <tz2294@columbia.edu>
>> > ---
>> > The mapped-plus-dropbehind state was reproduced in QEMU. The patched
>> > kernel retained the mapped folio and continued to evict the unmapped
>> > dontcache folio. I did not reproduce the sleeping-in-atomic warning and
>> > am not aware of an existing report.
>> >
>>
>> I was able to trigger the sleeping-while-atomic BUG on current mainline with
>> some help from Claude. The reproducer itself is straightforward enough, but the
>> configuration was a little finicky. The atomic context comes from using
>> threadirqs so that virtblk_done() completes requests from the irq thread under
>> local_bh_disable() and the vq spinlock with irqs off, so in_task() is true but
>> the i_mmap_rwsem down_read() sleeps. It also needed 1 vCPU (so completion stays
>> in the irq thread rather than softirq) and ext4 -o dioread_lock (so end_io runs
>> inline instead of on a workqueue). With v4 applied the bug is gone, so:
>>
> 
> Thanks, Tal. Then I'm getting quite confused. Since with Wenjie's
> patch, we are no longer going to sleep for dropbehind in `filemap.c`,
> do we still need all the complex logic in the block device and file
> system layers to move dropbehind to a workqueue task context?
> 

Hi Barry,

Let me clarify. Wenjie's patch prevents sleeping in a very specific case.
The existing in_task() check covered most other cases, in that it just
doesn't do dropbehind invalidation if we're not executing in task context
(for example, block device writeback completing in interrupt context).

However, dropping the invalidation defeats the point of dropbehind, as it
leaves the pages in the page cache. If we get rid of the task-context
deferral mechanism, we wouldn't sleep, but we also wouldn't invalidate.
Wenjie's change is largely unrelated to this.

Thanks,
Tal


