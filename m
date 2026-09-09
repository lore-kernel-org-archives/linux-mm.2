Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F16C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9CF76B0098; Wed,  9 Sep 2026 13:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E156B0099; Wed,  9 Sep 2026 13:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3DFD6B009B; Wed,  9 Sep 2026 13:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 772166B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:47:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6E101602FD
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:47:33 +0000 (UTC)
X-FDA: 85194955986.12.A7795C8
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 28319180004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:47:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=DjRQeO6h;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=285f1qP6;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788976051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPEyuOHa2Xf8hImQXcpukM+8uHb3YA7v7XMeWMx3v/U=;
	b=qWe0aGmjXPef+D+CLj93WvTkohR/bHvESc7IKcKHcYPdI2V2xzFgMUVXqUqToHl7031rM5
	xngxn6fMQ+KyAuiZdusU8Nups3EzI7uN2zK/7tzIprjhNpZ2aqkN1nK/LxihgsqJC8qz1h
	P6LBZk0RPYVuyz2OGFejdL1teELRgCE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788976051;
	b=GtWhZWUB3y16X3VMrfw7dWjXoz/N9u8DNOpvtVY6ZEbSUe9ATN6oCPi+DO97ialMkaSpZO
	zAyT4Wtg42WCM8MQhv0NqsIA8yT26ZHrdtKWf1d5qV5ay8DdKlUxpIQPPl6RnYl0k5RCgO
	vEAHBrbyONDOpLR5J/hTw8GYRZgPO5U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=DjRQeO6h;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=285f1qP6;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689HS9FO298899
	for <linux-mm@kvack.org>; Wed, 9 Sep 2026 13:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=aPEy
	uOHa2Xf8hImQXcpukM+8uHb3YA7v7XMeWMx3v/U=; b=DjRQeO6hhGQ6ZYjAObJ5
	/57qcPKnOwj1fymOVEV+nrbxT9iWnT5Bdyg31cdt6boDVmYsyuhwvfKfxvkKfoTD
	Ll4UPjKBfzaaxj0H3M04AdKlciGt0q9P//CcKBoFBtJkdycJZtaE1uqSgMoUW3as
	YCftzjHUlpEKNZyxh7TGR5BLLGwZ4+wGYmqBHBIBbfT8aMwdz2j2KOO6x8aDoZYk
	Gp3amBJ0NYy0AO6OHdFKAKfJd07JJGvH/QUDn79JHP9mL2Fo7UzyARY3hAHRQbMG
	/UXL5xzBCj9b7xfRivTDlni7o0R7ixrTI23YkRlAsEWpzfQb9N54FJxNnWE5tB8N
	BA==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gk4fh47sb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 09 Sep 2026 13:47:29 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90ceabcd64aso125253266d6.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 10:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788976048; x=1789580848; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aPEyuOHa2Xf8hImQXcpukM+8uHb3YA7v7XMeWMx3v/U=;
        b=285f1qP6klSUDnB+/loKU4MEqhQF3rWXNu8pueCV2XFHPstdjd1iE8qAMyN+plqElT
         li+QMenDkYzuKuxlPd14Bh7zrBo+HGns4KBg7uX5abGGlsK9QDQ/KoAdY+9PECCJRMdy
         om9wOECIWdKeP4oThjSb92G0uLEh2XhwroU2eh3+iAIDPq4QlorJ05C8dqPgfwd0HGz1
         2tl97lFQL2CC9rjRAVQpkTqFTxBZ5G8dzjYa4/7PldxZQtYHhJRlgY5HqoMqYpQjnaFR
         7waEqlycMQDL7dbIg1SwgcfP3HAIq5QwfqGOd4O9nkXG1PfIZgnXG2mr8k0XZ/mpP3CA
         3niw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976048; x=1789580848;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aPEyuOHa2Xf8hImQXcpukM+8uHb3YA7v7XMeWMx3v/U=;
        b=Acb24cFvEZiRuie8zs5/lcWFwur/ZbFJxZnHl17TmIZuInV/d3vzs3zKy6YE/patIR
         3hitcbpOSPCEppOtsS/gL0Ltmf8LFKME31j5u5pF5G85k0oxlFQZWyfDCiGRMfao9JVG
         OB6GfkI+uKqH9zv0wxZ5ITM6stJjHluKcCZhV4EchlwtjvSh2XdymqsnwMPAbrd4xqs/
         y9S4Cn5bXTWtRbmIRGTAmVyGw7u/kxekmT6jIPMS0w9Yo9O19CQBoJcK0Qiz7hMKYPit
         RyizdfXflvpoae5Kd2cDHY0tHExYEpf5ilI8Al8I8A7njnkB39EswaGTBz6UsDZNQAWJ
         jvOg==
X-Forwarded-Encrypted: i=1; AKwUvByy+OFHkOvwYi8/SRHr0g9nMYc4xbEr7jhWWfUU4zX5/2Bfrn5vxe8ACYuWATGfoukKc/f9IH5GEA==@kvack.org
X-Gm-Message-State: AFuF++nPWIJgJUFzg5Wlc/JH8ioUYFBfbgtnluWq4H0Ryof5aYT2sRR+
	UkHXSn3jxNWdLBzNVzhhsIs46kuwklt1/4lM+vjk5Wfx47LTtS/S5WOXEoo5oN8bnEY5rkZe8Sc
	q3W9RVw6Nc2nF7HDo2d253fHDBJ8uNbkNJKMi7HGH5zgG6/EJ
X-Gm-Gg: AYBFou3wnMeSD28EkmCVTPsOoQi43d4/RS+OddOwfS7jSp/6U8irbT/s6oEkUj89SQ6
	QqL9IKMrlZrVOY+nlQ9BZanKZy64fWztFPEvxMR4nrX8wdTeQAThdKPY6kCK0cg0CW1F/hbVjOh
	C3umvWpbyZxWxbxlcbWKAJF9hN+M2/PXPtvSROO+ON9NI6RwtYxs0mm9qPopwRB+0NgZlKqMevC
	wEERicgA3J47HES/WRR2KyEjUjxv7hQvqpMMlFK2Akwad1CBh78umszK8H5KPfNBelCFUzaGlYi
	8TNMu+l9Q2GJueFrzUBvPZjbk+C/VIzKpbB84jFcT4xua+zjYjDjqAIP22QQcax7IUVRY2ixKLb
	eM8hn3k3piQBHsR5qtlGIhJvJCmhJ/QwQsMjreRqedtwuuGFcilqL
X-Received: by 2002:a05:6214:5297:b0:910:345a:8bd2 with SMTP id 6a1803df08f44-9103f07142emr449128066d6.35.1788976047922;
        Wed, 09 Sep 2026 10:47:27 -0700 (PDT)
X-Received: by 2002:a05:6214:5297:b0:910:345a:8bd2 with SMTP id 6a1803df08f44-9103f07142emr449127266d6.35.1788976047298;
        Wed, 09 Sep 2026 10:47:27 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-176-193.net.columbia.edu. [128.59.176.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9106412e038sm53426756d6.20.2026.09.09.10.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 10:47:25 -0700 (PDT)
Message-ID: <3dfab5df-c205-4853-bf48-86351a02b4e2@columbia.edu>
Date: Wed, 9 Sep 2026 13:47:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
 <178889163877.1334491.3646957026033534678.b4-reply@b4>
 <83a8743b-9cbb-42a5-9ff5-718297916a76@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <83a8743b-9cbb-42a5-9ff5-718297916a76@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: PleO27al89rAXsVNwZYuBNXpAPTOITSa
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE5NyBTYWx0ZWRfX0o3m4Gigw/4i
 Y5YVr9pCCxLlbSwE1VNeYnc130KI4YK9Z2WMQmMJkii1HYFUIi7bJSTy8Ly5qPLdzwc3LQ9OlHk
 nvOrnmehBwVuiCmwtBIEWUc/egA2RxBrzRdQPXNpN81MltXkfxpv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE5NyBTYWx0ZWRfXwmzHxabeapQe
 cAL9HBpuySQPXY7harH9Rg2sQeTYMqnVs4jXpd0k1wG3gymU/7+6sxuW2KkMs9EmXhtQEMMJFfK
 6OUhpkYX3dtQSDTNK4jmuAqIc6NVrRg2xkJkO458xdwNg5ulKpu5ceuaR013eW3GaWNzrjDsVo8
 Fd8E+Hx1o3j4R8xu+tQ26W09Gjrg4OHMgkmZd/IpSLSX+r62Iq3NmR7DT/0gO+saltLLsReBu/J
 YRf+a/HUya1YtsRHY+pPhubqt1U9ttVjdWiUx9RKgLVQcWeXtTQCgM3MdSvXm9/H1lQVj0Kr6Tz
 R25N8Dfq6y8As7ZQyAngYNYYR9dAshpT6mmh8MY+PPwKwA5t+ttTXAPTnAhuyZuwWHMqrioZr5s
 JOmIthCxsN5BCcXAr6/mQLybf0Qn5JLqMf7oRfUJ1L6XsyECBjEBYePFGvbvIVlA3BzWEH4Gpcg
 PRyTWlXsO5wBQNwL5gg==
X-Proofpoint-GUID: PleO27al89rAXsVNwZYuBNXpAPTOITSa
X-Authority-Analysis: v=2.4 cv=LdUMLDfi c=1 sm=1 tr=0 ts=6aa19bb1 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=fJxgZNdXt3opHMdyAp+FXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=VwQbUJbxAAAA:8 a=FP58Ms26AAAA:8 a=Ikd4Dj_1AAAA:8 a=brY8mzgTOjc0s726uLoA:9
 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 adultscore=0 lowpriorityscore=10 clxscore=1015 impostorscore=10
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090197
X-Stat-Signature: ca1gjnoeidi8rmeacz6im5oeqw6tz1rk
X-Rspam-User: 
X-Rspamd-Queue-Id: 28319180004
X-Rspamd-Server: rspam03
X-HE-Tag: 1788976050-904414
X-HE-Meta: U2FsdGVkX1/9tUlGQlWUvRTB8Se8aUgbyZN3aF+npjsGEZm6mmwhXfD2SVOI1yzjVMpK/4nXreIhue87lkV+g0qockBuCGNSL/uy8fdFaQRYlcz3USXXJC88C2jcRlkeGcBBGymD8KHo6Ikojg/G797sFjpYkRD2Xt+koQMMce8O1Y3mU06Nfwg06hSExlSQI8TcyVq8r+SYp/re01D4u379uTiaSjJOZ5DjkoTy6AwVn6NM8F5jeo+JL80DIsePMf9lYLNDLoQ4C+nKIqNvnuxQcjxXFSY4wfCP8Rs4hDk9ZK1em0Fw+1yBfzoRzPJA8SwMtJ6zADk87VH3/QP5sdtDSrDQW+92vpsrzdCUfKNGkutb1uRxbGCrdKhSy6Fq/YrdTTk088Vp7niusAV2DgPgQQn6yLgy/gw2E5XQr2bQpzvcvckrnWYEfHJrggnoyea6FxbaGiePh+YFuO0VPzvfMs5gtHS+204vAvHlgBjRhYQpIU+8TVBIByQr99cYsf2I/WB9/dN6sav89AMkYV+IonXrxjvLNQHr8o63OMw6T/y58WjiP+BXch4qUxpQ8S1H/RuJ1DS7jo26SedV1gUDDX4aw/6+z4LOBl9Cnvg1N9g2vAnWqngbL6S5X9pLthxFhsJwy1nI7dzB/rrJ9bUe96k6wNnM678xs3E50WyFe3ZQTG8u/mPsGdGxR58N2HMZKEV1MmsAR21fMqS1y5F+cQCnt/v+WT0xlzRloiOBlFI2KjdtMR2IWNxYSflhyJorZN/W34QeFNcu/GzlsuEgloVpBXGlWiuLq+aQ+97dWnk4BO2u6sAmBbOTfYF4X8VsGPGL0F7ZnekR7Rj0p22UsYVeRZakgPrRBLvFQqH+xvLSVBMHjPij65DEiYm4QZWa4cGoMZxesuXbCZC5xq30PZZJ9v0lt2nRWp4UGe1u1qDYPK5sIf955ByRuwhLndiRD7wtcVGF8aO2hBA
 2NQVdeXw
 eedwXvjpw2XY+ODTPrSOh40Kxho9y6l93rrXpIAeU+hBDtqJNUp8rAmBJfGwJx3d5vshQX3bt0reljAWFZZDCDNLSOSwOT3xuX0U4WVEe9x2hNhRKy+9KeRuDHyZdwofGxNtemSr3cuzcsau/Pd9AoTgQpAeRKuIPbaZ8edrR12sdXhfKbibEe8CYKNdjy6zLwkdgQeXVXASboC3obaq0uQAVuixLp8Gs+BIKQxYM/u1gQuNlbe4cSB2VbYjYBIFd8vZosXo0JWJrfOh9ccSLE9p0wpuZVJ1+ityd8DQzaXGScR3/kwrVImiqYXJxQErXT0TOBGiDEx7GY1QxMVIuY+1glN9s7gaeKieKo116n2VyDU5sUxFf2jHHjCjHxbJ5Lg/O7koaYsCNIn3uCZldyR5qz1dT4uBm4sw8pPx4L5Wc7+MzyItIeAe1sWvaYcmc6QDorhWG4LBU3QbHgQ4ALokOZaN7X/AAr0fEUrLben2PCENKWV/OaIpSxM7flrgBKl9rA7dQ2Oy7fBQ5th72ZbZSCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 3:48 PM, David Hildenbrand (Arm) wrote:
> On 9/8/26 20:20, Tal Zussman wrote:
>> On 2026-09-08 17:47 +0200, David Hildenbrand (Arm) wrote:
>>> On 9/8/26 04:56, Zi Yan wrote:
>>>> f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
>>>> page->private != NULL is equivalent to checking PG_private. Change
>>>> PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
>>>> page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
>>>> but it can cause confusion when PG_private is removed and
>>>> page->private != NULL is used instead. Change it to initialize
>>>> page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
>>>> semantics.
>>>>
>>>> It prepares for a future commit that removes PG_private.
>>>>
>>>> No functional change intended.
>>>>
>>>> Assisted-by: Claude:claude-opus-4-8
>>>> Assisted-by: Codex:gpt-5
>>>> To: Jaegeuk Kim <jaegeuk@kernel.org>
>>>> To: Chao Yu <chao@kernel.org>
>>>> Cc: linux-f2fs-devel@lists.sourceforge.net
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Acked-by: Usama Arif <usama.arif@linux.dev>
>>>> Acked-by: Chao Yu <chao@kernel.org>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>  fs/f2fs/f2fs.h | 8 ++++----
>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>>>> index 9940a6cecf1a2..2f7ab5888b078 100644
>>>> --- a/fs/f2fs/f2fs.h
>>>> +++ b/fs/f2fs/f2fs.h
>>>> @@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
>>>>  }									\
>>>>  static inline bool page_private_##name(struct page *page) \
>>>>  { \
>>>> -	return PagePrivate(page) && \
>>>> +	return page_private(page) && \
>>>>  		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
>>>>  		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>>>  }
>>>> @@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
>>>>  }									\
>>>>  static inline void set_page_private_##name(struct page *page) \
>>>>  { \
>>>> -	if (!PagePrivate(page)) \
>>>> -		attach_page_private(page, (void *)0); \
>>>> -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
>>>> +	if (!page_private(page)) \
>>>> +		attach_page_private(page, \
>>>> +				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
>>>>  	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>>>  }
>>>
>>> Very weird interface. Why do we even need the page-based interface still?
>>>
>>> $ git grep -E "(set|clear)_page_private"
>>> compress.c:             clear_page_private_gcing(cc->rpages[i]);
>>> compress.c:                     set_page_private_gcing(cc->rpages[i]);
>>> compress.c:             clear_page_private_gcing(cic->rpages[i]);
>>> f2fs.h:static inline void set_page_private_##name(struct page *page) \
>>> f2fs.h:static inline void clear_page_private_##name(struct page *page) \
>>>
>>> Seeing code like:
>>>
>>> clear_page_private_gcing(cc->rpages[i]);
>>> if (folio_test_writeback(page_folio(cc->rpages[i])))
>>> 	end_page_writeback(cc->rpages[i]);
>>>
>>> Makes me wonder whether we can just use the folio helper instead?
>>>
>>> In f2fs_iget(), we enable large folios only when !f2fs_compressed_file(inode).
>>>
>>> So naive me would assume that we can just get rid of the
>>> set_page_private_/clear_page_private_ stuff entirely.
>>>
>> 
>> I have a WIP series of ~30 patches converting much of the remaining page
>> users in f2fs (including the below) to folios. Still have to do some
>> testing and clean it up, but hoping to send it out in the next couple of
>> weeks (in the hopes of eliminating some more folio_compat.c functions by
>> next cycle...)
> 
> Indeed best to wait a bit before flooding -mm even more, it's rather a lot at
> this point.
> 
> In the context of this series, it would be great if you could review whether the
> diff I proposed would get the job done, thanks!
> 

What it changes looks good, but I would go a little further.

There are only two more users of page_private_gcing(), which pass fio->page.
Those could easily be converted to folio_test_f2fs_gcing() by passing fio->folio,
which is in a union with fio->page. That would let you delete the
page_private_##name() implementation in PAGE_PRIVATE_GET_FUNC() as well and just
remove the entire family. At that point PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC()
could be renamed to something like F2FS_FOLIO_PRIVATE_{GET,SET,CLEAR}_FUNC() and
all of this cruft is gone and folio-based, with no more f2fs use of page_private()
either.

The renaming could be done as a later step, but I would get rid of the accessors
as well in one swoop.

> -- 
> Cheers,
> 
> David
> 


