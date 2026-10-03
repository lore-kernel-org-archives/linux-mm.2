Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C589CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 14:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3986C6B0093; Sat,  3 Oct 2026 10:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36FD06B0095; Sat,  3 Oct 2026 10:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239C66B0096; Sat,  3 Oct 2026 10:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF8986B0093
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:56:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68F16A0960
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:56:06 +0000 (UTC)
X-FDA: 85281615132.28.C829DB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 21A971C0003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:55:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JcBOFHG6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791039364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJ+CZ2ko8FayCrjASuAr19+3e2iBiy5YcdksjdcrxFA=;
	b=xOCC4CXe1Ssy94/haOXwcUbCFeAoblwFtpAZmcBCUs2B0VLXJCNUTj+vJmPpr6nan2PGMB
	Upg7u9lT8dOqIXYstD8StTOPOvByl9fDmuddXBu+NZmaU33MgTAOqv3r4poRmGj0mOA17v
	CJB6gl3UC8TNrQs0p6wfFNdzGXDNaec=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JcBOFHG6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791039364;
	b=zWI2e/2xuZ2FuJnGHTNvyff1gXWn/N1BsKRfz59oXr0bshrirYYSvSyXvrKs1AIrnnl8/l
	d/0/xtcyHwRD6q34gpnglmAr8cFv07u8ocI7oZPj86yaRbADHav1MhL/3HCgqQP2QwDtGB
	zd6mctGPJoKmxZm1DYGBBAO42ewuR0c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791039359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TJ+CZ2ko8FayCrjASuAr19+3e2iBiy5YcdksjdcrxFA=;
	b=JcBOFHG6gLbj7zMSK9HWrI4rYhOeHgUgY53EAOdAhsjhhRFEIJNtULlWxfXWTnSn+4PYdg
	PHmeXyBN74v39EYc5rH8A+CytOMzZzAQAZh6MHQMarC0wLyJ/98waKkTvMZtLodCAJdBDz
	s5blIJNVrgvK4TIjjcQcaAIxch1VAY0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-ArxDoYN_OUSKvCKE7QPSjw-1; Sat, 03 Oct 2026 10:55:58 -0400
X-MC-Unique: ArxDoYN_OUSKvCKE7QPSjw-1
X-Mimecast-MFC-AGG-ID: ArxDoYN_OUSKvCKE7QPSjw_1791039356
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-532d420abc1so9972661cf.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 07:55:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791039356; x=1791644156;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TJ+CZ2ko8FayCrjASuAr19+3e2iBiy5YcdksjdcrxFA=;
        b=X+vLiQDi33wMTEHY4XSwQBwLpIGeU+xLzfDpQAbxN6W4mv1bHkBIpOzbyBORGC1y/g
         9136e+K9n4rPtXXWi0Hku4RCi5tMzByeIIz6QEvsSKDhrt2531BA/WyMCMiP5uHWPppU
         sQwciPX45ADkpQhRFKLW0P9YzUy/w1kHXdfRD0fzoUaPerpBrtFLcPQEuvEUsUxokfk9
         +/Ut0D8pPqQHmx4bh91QXh6N8GuouOeXpaO+F+Ay2hLihe64XWnU1C7CCarcLoOTgLUF
         uA6xDK8xDMgJeGoGY9SqqJcw4mpid4jFo10YWkzVZNDhedls/18S/D4U33Rditb87M+J
         izqg==
X-Forwarded-Encrypted: i=1; AKwUvByOjq86D9m4TypvP5t832/v1nbTKNfUvPCWIdNCjU137F/xrmOI/q9aXT8BzlLGk4fikn4GTdyYmQ==@kvack.org
X-Gm-Message-State: AFuF++kkiq1i1lGJ4db0qhUwEg3iCytW1L3U4U0QCdrKyxE2GVSxskHJ
	JKZNInkAGT8NeQgKuUHZuo5+1mxjcEM+N/wHEAzEtlbCzXc2UEkK0o8j0uOWxi+qKe1m+o9mFM7
	A1r7dVxQvNp7CTE9pGYWGb4QMy6of52O7Kc6SLsyAgzRflSlSaPux
X-Gm-Gg: AYBFou3w0WFz2+Iqd+eda5Gr8SgMh1aKjuJoof9nqqZOi/TDapthsHs6g+k/BqoK/3i
	34OnfI+kvWbTnPVBX6aFtf4sXce3wgqHz3jYU/Tdw7hy2nrejAXSYS5z1ud5vZh1Xst5q8I2wvs
	Kt/odHwizJYxm5bFsR8uzD4/JV4yDd2bKPpV3d8e7puw97aMyfi95DzRn7TMbMpasNsEpLmYXcn
	si9+ae5lNK9EGQJ8ho2imghqiJDFOG5vPXX0Fc2HMn2KPLvviTOOo1QLkb5C1JK2fQB76B9zFA6
	CwikLlwg6fj5mxNwPgZLiOogjGEohCPpAiFYiTut3hzaZNPSr9K0S5YXczlii9ROR4SgQE/zOIT
	3C5w=
X-Received: by 2002:a05:622a:1482:b0:533:96b4:8dd1 with SMTP id d75a77b69052e-53511e4e1femr44616691cf.26.1791039355707;
        Sat, 03 Oct 2026 07:55:55 -0700 (PDT)
X-Received: by 2002:a05:622a:1482:b0:533:96b4:8dd1 with SMTP id d75a77b69052e-53511e4e1femr44616411cf.26.1791039355289;
        Sat, 03 Oct 2026 07:55:55 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53398a5b6d6sm52871341cf.9.2026.10.03.07.55.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 07:55:54 -0700 (PDT)
Message-ID: <4a52ea71-63f1-4b78-925a-233ccb4edc61@redhat.com>
Date: Sat, 3 Oct 2026 10:55:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/14] mm: debug_vm_pgtable: use
 pgtable_has_pmd_leaves()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <e7edf7e42f88d361c177e1baa7e2138c193f0805.1789695931.git.luizcap@redhat.com>
 <fd486bd4-c166-4b46-8047-0a777b239d01@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <fd486bd4-c166-4b46-8047-0a777b239d01@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MvN4ZLEogxbhoY-F7ewxJXrWtF4yQE6vh-F_0Zh7Sak_1791039356
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 21A971C0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1f1kkqxqbr7obqxjid46hy8p43wgfp4f
X-HE-Tag: 1791039359-12865
X-HE-Meta: U2FsdGVkX19krYkDEnewRt8be2MWxfVDviZ4YXyw9JKdAFEowpqEg3oNr0L1ykfQakH2Ou/Kt//gZhuba4StBAHpZtDUxT/qF4lSMjm0atf5jlyqHMSbQOWZWcYOUetieIonFmftH26WUdXwJ2WfcDVn4RxLpZECxKCgihR+ZFBo/HHUaO3Zlj4IOwqqgeazJxcK4zER84boJ5TnBnnsXRwLrDxuKyW635kpltqtNItJ1GISF83KW8eQI5umDdq0l1QpdUo4JQkD3MOvW41+XPH3FFx51t6mds3MMEUAVwWdzdINXEzqqfgx7200lr5z2vrTp+0O1w+6OMmq5P7AkGebl5sAcLxS6xXIE8eeo1CvV9pINLFy/5mGr91XoirabdVV7/h75/Nh/V9KXzJI8fu0tzQfJyP8DrvQivVfbSwPE/Ik0OhTPF1rLghBgSpKdrtummScUXIG6ZyAJ8be+pjDrFRhIgC044x037rrZCbuvOGg4o3OW44WL7G2EwQ7LlR5MKBB9e4vMNA+NYjd/v/RoXOC7XMjnH+/k57IOz3q7ILPHVec8eZRsJXR9yvMi15FtlZ2KPkyg5d3S2efY4w7LYmR4+Bf662cWlyh8XIUKOt3htOle0112tzKq2XOlevmFQsvWsCbqL0olawDfjwACi280bz6nQDLc0q0Uj2cMDUBme51hVFF8NCUeJWCn504ir7xgXdlNkjzQIwJGMsPmLXF+/baD0LXKnRJR4iiZGRJOVN0R+k7vrecIHi6V4qm4xQvw5Vlhv+dxBBoW20ihrnBs+bE8uINBkWco1LRYsJsawkKtbrHqD/RSgpYaH3XpMeVeUyvSgGuU6ZEqy21shps9kZaVAKFGO7WXJtxfkj/w3RQKlUOsElNhvNzGLIrRnHzavdFoT/rmtkuxZt7oaBznmsOoQLb+IkXw+pgCORf2LptXNUCzgCFzstmlwjLQRAagNsqOeF+D09
 2XOidVxH
 r70yWURbsjPOu3LsG3muCVij6Ppzg+vWnWSiYtbMd0DfSzNNvUK9iW8TrmsymHpXwcNY6YFCc/D3tf3PMg+ktxDi5EjzEkgnRQDT8qPQaMcQMX6HnMJOueNc0tgKRMWAA74JYUYFmYgOS/qXWLzbvTyzNM0vpQrP6LmcqRcBs3d16dMUo4kDF4inQ6/Ww+dMBGKmhIQyP3JXsup+XpGODE1rEDkkpK3fIs+6BNNEWwsDjoL76laiVKz8EEpgABl02BDtS8ZUvd7hioOL+OK/F7IZ33sdv8rp9If5Q1olh9hW4LiTrumXajQ6nd9Xx4xSt21NoXmcWluHL45wKzd/0WesaTJ4xvZuPKr85j0918B7gl11IOoNyHMDb0qW+R6NskUEfXcw4i+Oy3/nVASyzdwCTJN2ExySIz0zWces4K/zcJjXk5XDOJ06kH28NpFMCQHHcDMdzKYSn7xo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/2/26 3:19 PM, David Hildenbrand (Arm) wrote:
> On 9/18/26 03:45, Luiz Capitulino wrote:
>> debug_vm_pgtable calls has_transparent_hugepage() in multiple places to
>> check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()
>> instead.
>>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
> 
> Best to mention in the description that there is no effective change as all
> calls to has_transparent_hugepage() are predicated by CONFIG_TRANSPARENT_HUGEPAGE.

OK, the new changelog reads:

"""
debug_vm_pgtable calls has_transparent_hugepage() in multiple places to
check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()
instead.

No functional change intended since the call happens under the
CONFIG_TRANSPARENT_HUGEPAGE guard and when CONFIG_TRANSPARENT_HUGEPAGE=y
both functions return the same value.
"""

> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>


