Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18809CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2749B6B0092; Tue, 29 Sep 2026 10:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C616B0093; Tue, 29 Sep 2026 10:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1638A6B0095; Tue, 29 Sep 2026 10:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D605B6B0092
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:18:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56579A6DDA
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:18:29 +0000 (UTC)
X-FDA: 85267005138.18.A690F11
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9FE0F2000D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:18:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CBJ23xMd;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790691507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GbXDTdZnaMARV0PaqG68M0h00pQ3SsjxJmf4zOowgA4=;
	b=2pRhkSs3Haj8SIQWytW46h5T7HiiBFnv+MuyRvx0sn9SBVW0ZMi2PtBvhGuq01RVG/ek06
	JvmTF2aYMpysafhPmRQGo+ss98N+BHGPSiwhCKLBcPi1u2U4ukRHk51NYp4dVPeCg8F7PT
	dZiUv1ZoUHljJL7K6vTvEmfaAKpXBZc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790691507;
	b=41hbKhZll+IKrTFloTDL7yB22cdEvXhgDIvlYA4To1b/6tTPYEgwOk42EkqWhDTjUTv+e5
	S1SZInrjuNs2KSfvOzj5tFa4uEV43fSL73cfXz493uqp5vstv76NcNDCHE1SPB1M65E8KZ
	6vaSf/5aPyfrXS/pWMmVGjepsnDy0fY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CBJ23xMd;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790691506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GbXDTdZnaMARV0PaqG68M0h00pQ3SsjxJmf4zOowgA4=;
	b=CBJ23xMdQo8bc38di2tTw9U6gvu6mi584ndVh+mXCaiiK0xcyU4jDF+VHxVcvJbzrKqTaf
	9VHuX2HCS3jLDLaOmJvsug99vfq5AlHF6W39xWkQcQ+JygYsy14DeOUPHGIfD7UtJwBVM6
	X99fB5DhbRhPBAK5A7iZbuWHAxYg+nc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-toa3jmJxNeizIQGzlOuiXw-1; Tue, 29 Sep 2026 10:18:24 -0400
X-MC-Unique: toa3jmJxNeizIQGzlOuiXw-1
X-Mimecast-MFC-AGG-ID: toa3jmJxNeizIQGzlOuiXw_1790691504
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a05d645acso906754285a.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:18:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790691504; x=1791296304;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GbXDTdZnaMARV0PaqG68M0h00pQ3SsjxJmf4zOowgA4=;
        b=eEx1ifh9EZYixChsfT5zkFU51frXNN8lKDGXSkk5x16Q/+i8p2L/DpIHGfQR2xlALB
         sGd3tS44rODc2tjDtVbyrnrxw+U87EnGiT4xh+fk9WpR8EWk1UFV/WdP4mBzB2ihOjmk
         AjBBFqMlOw4bxztmsdlXg/yHa5bl2G8gNNF/xgudko7You+hhwYF8UFsyEieAfXRg3xJ
         sQwCmm6sUWudhJqvmFd9zl1B56dndPPqgO+lzwo5jX5dFp/k6XTGgchG5/b+DWSweEdq
         doB1Vp/tKQo0STGoxvER05bE2LvWiJ70oczLeyC97qFiK7DYhFl0kgt9tgw9CKaVBq5L
         hT+g==
X-Forwarded-Encrypted: i=1; AKwUvByl/byRskmotyKfUuL8F7uoEjLVH6WdAh9k56KySmSsrJa6oGi7+7MU6fdQxUlIUXVKhrpbZq3zjQ==@kvack.org
X-Gm-Message-State: AFuF++k5/NJp4U4txq/lVQ/GS15O5vz1XAIwEYmY11xmPeXixTu6n6mq
	DniOaPCnvFVCieROT8MGDeP7EexvmZkGcFY1npMiV/G5QI4/9DquAHSvxnlahv8M37Dbdh5eigR
	2JKCYSVSWisqdxU4mP4q4Hm3I8Gq8iodoMUlRrvVHdEc8uQk1dHGo
X-Gm-Gg: AYBFou1oTDYbOI+vrVgKqk1XQvs9bitgUkYfhiFvp4r1j/+VulkwgSUay+Zf6hshMUH
	aUOoYdzWKb2EF/vS+/OPPMgpEDbDFH1Um+DmCl7Ps0vKok6eUoHjKlXwLgH1QBvgIBJl2hOJJAA
	1DxywP0NeLcbu6NFqcY9PyyzXGktcJmr7qTuv2OfrGkg9BzxmYy5UVhHqr1qQ3DfSsZ39HduI7v
	1xV3KQIVFavjPf0PdDDAR+4gU+bB8H+jMjIjTexjJ2pc09Oo8Fe7he4IMXXG83sV0PRFfLHMgXc
	StAH+ZrYuLSc2BZjzFBZc14kK9FOGleoSd1qGL3nbBBUvKj9hdNlb5okDABSJRkQxgDAxtZQlnk
	bUi8=
X-Received: by 2002:a05:620a:404c:b0:939:31b5:4e08 with SMTP id af79cd13be357-93c439c33fbmr2664002085a.0.1790691503753;
        Tue, 29 Sep 2026 07:18:23 -0700 (PDT)
X-Received: by 2002:a05:620a:404c:b0:939:31b5:4e08 with SMTP id af79cd13be357-93c439c33fbmr2663993785a.0.1790691503101;
        Tue, 29 Sep 2026 07:18:23 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c813a4587sm400548285a.7.2026.09.29.07.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 07:18:22 -0700 (PDT)
Message-ID: <cd4c16d1-d23e-4321-8f2a-6754294b74b1@redhat.com>
Date: Tue, 29 Sep 2026 10:18:21 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6.18.y v2] selftests/mm: hugepage-mremap: fix mapping
 alignment
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: rppt@kernel.org, sayalip@linux.ibm.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260928130916.231112-1-luizcap@redhat.com>
 <2026-09-28-2-daily-reply-0006-re-hugepage-mremap-alignment-6-18-v3@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <2026-09-28-2-daily-reply-0006-re-hugepage-mremap-alignment-6-18-v3@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fpXhVOtudJARqBJmzxRJ_1eP9PNbBmJ5oinkJHb1PdQ_1790691504
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9FE0F2000D
X-Stat-Signature: w8nzu1z1uuqc5a481t9uehgcwzf6fba3
X-Rspam-User: 
X-HE-Tag: 1790691506-988377
X-HE-Meta: U2FsdGVkX19q42GZ3iFf1eZlNIAA6gaXru17RBOgpKpo8/QmnMjR1jdOyR1dikcecIx9Yy7OSnVC7F8QNS11tNCN9pLnNEeFnCq1knlh+cS2n2dsl9LuwN5LFIynLnpwevYR/jzTM214bPVv9qlSv0KyCj5GJo5F0yezLVfynDkRKnJ9JCVb55z20CSuSJeeP0EXFYkM/uZNlcrdNovvIhscqLMtJLl2so7zSWBCtB2+NBOiIQIC9KVEjXUObD/INM14vZI0aeE/DHqZZaFUm8ky1Oxd5vbDpnz7b1y1K3exehJQgza70M/mQxgECz93wdd7QZSF5LlhY5m4KEr6o0G4Plg7U0dCD7Cr3LQKNac1VKKKqExKlvqn4Q6HtIqdyz8lUwWBlYd5s8MLH14xsFtOExfaOEtsiqlq4hQzUcuMPzGfTEhxgwS6+XkjPrMtMqamDTFuqrf3LJX8ph/6SQtO3l8YaI//m7j3lFZWQl4wWm0pjIWy8LN4mz99MjfNkBvSMB7EfOeM4/qa5WH7yZOCbBgmoppRQa872oVRsdwS/E+Pui5YDzBUjdyxQekQTpz3LlHS7I3rEr9U6PRhD9816SBV4UDMygA+dmDLfaddScbXzOcO28aoOyDWfSzHjfIg8yPWQBroU9FPfDsXaUbro1bJ4XubVcMKKyT/cfY13SQBW+YZ5s6cxi82rRULB+UT/jmM/YYvDx3SjzvTdce7ePZDPqupe/U2ItZ2XgRwzevyNZ/d225sGa72H5sCvzofvZr1oowfoHPX9mTj9gPgCST1b6X2MNm5ta6C52OkOpz0XoxYM9GaYlow2Rc2yo/0f48iYXu65NzcfN6c7lE5wBQZjiAHXnI2/54oTD5aQG5CMYNLAB+T3XR4hVb/YPwzUCFADUQ4ARQ/oVVlODJ3nZSS7HkV30LbxflEiJ0Uo4nR8I5sfIMzuoUFt3Fb5x6hsy60j8X/soQg5m/
 BnaXAIgk
 YEXFk4kDKZD07/HlY316p2+cC6Zwcls5xuHYVY2uHlfb0Uyk7lMvx8cZeBmQ2XFsuIDPdzSODtmW4mUnbdS9jrWCu55k0Z9b8U1YvGchVfhiGff1/7MEhwPEC1D1ca+vXjrATmmMc9X7WyyFa/3e8m3uF3u3zYYqwQGeM8jLK3FQGj7dAI433YRYeckV0jjHgOfXKKx//FwGeFJZ6pSmB5GqB5DTpChLvy1EPRXNeRGaEY4tIma5WLHPOg3R4mq25wIN5/1P44MZSEX+HA/mheSIwGY4W7p6qcFdbqc5ZVOiw4mZ9nDZJKhGvAKYbzMyk15YtaYIwrmW64z/uE9phXORCDco+/bO1FrPhldzcImGgaxU2VwD2LtzvcTEWcGPANdXRFGv8SyLPHnv43B2A2vuXJhm43FQWxG5ZSsnhAXk6FSOwMuqAWR1IOXGuEyFBVcc3IH0kdvU186rDshZ0XnVX4t2GLjDg27fQS8b//U1bJvaK76HE61l0KdAYwQGcr0ZULFwXNIHPzXGy+jfyNY+llZMXh6mz4tsstiCmaDZWo6zAMNSVW8wdI3N+mADvMBWBcMiVJEtdfcsqSMggE9Tl0+p+YMqDXjjp9dr96zomGT5xq8mvsKitupfIzA/im1yQ6VTgV325CyIEF0zmFQOevXsGf/mUeFkvTsEHUdzgee7CE/hyexrXoI5vZtnuE0fpJ8Gd71UWn+t6KHyX4jfg3Ml1Ww23VSdhF5yoBtFzw8MX1iN/E18Ss4pus9HbB1LH8ymwHX0C5oViVKGX2mWzGCvW4yWsiyAz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/28/26 6:39 PM, Sasha Levin wrote:
>> commit a914785f6349da754e1226420bf4e51961956769 upstream.
> 
> a914785f6349 ("selftests/mm: hugetlb-mremap: add setup of HugeTLB pages") is
> Mike's commit, but this patch has you as the author with only your
> Signed-off-by. Could you send a v3 that keeps Mike as the author with his
> Signed-off-by, followed by yours, or otherwise makes the provenance explicit?
> 
> The same applies to the 6.12.y posting.

My intent was to explain what was being fixed and why and, as it's a
partial backport, I decided to author the change. But I'm keeping Mike's
original changelog & authorship now, can you review it before I post?
Note that the subject will change as a result.

"""
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 11 May 2026 19:28:25 +0300
Subject: [PATCH v6.18.y v3] selftests/mm: hugetlb-mremap: add setup of HugeTLB pages

commit a914785f6349da754e1226420bf4e51961956769 upstream.

hugetlb-mremap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-42-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ Backport-notes: this is a partial backport containing only the aligning
of 'length' to the hugepage size. The hugepage_settings.h include line and
the hugetlb_setup_default() call are omitted. Without this fix, the
uffd_register() call always fails on arm64 with 64K base pages and 512 MiB
default HugeTLB page size causing the test to fail with the error below as
'length' is 10 MiB and not aligned to the HugeTLB page size.

   # -------------------------
   # running ./hugepage-mremap
   # -------------------------
   # TAP version 13
   # 1..1
   # # Map haddr: Returned address is 0x7eaa40000000
   # # Map daddr: Returned address is 0x7daa40000000
   # # Map vaddr: Returned address is 0x7faa40000000
   # Bail out! ioctl-UFFDIO_REGISTER: Invalid argument
   # # Planned tests != run tests (1 != 0)
   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
   # [FAIL]
   not ok 1 hugepage-mremap # exit=1
   # NOTE: These hugetlb tests provide minimal coverage.  Use
   #       https://github.com/libhugetlbfs/libhugetlbfs.git for
   #       hugetlb regression testing.
   # SKIP ./uffd-wp-mremap
]
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
"""


