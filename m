Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B104DCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192708E0005; Wed, 22 Oct 2025 16:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B2B8E0002; Wed, 22 Oct 2025 16:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F258A8E0005; Wed, 22 Oct 2025 16:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DECF48E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B4B31A0950
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:29:44 +0000 (UTC)
X-FDA: 84026891088.14.B9DA4F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 47236A0016
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:29:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bWWEXE3A;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761164982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZKZ2AJTFv1mWcw/RXVrzmeGdXQKQ8Fz68OVoUjUSa8=;
	b=wJPwHLS7YZGhn/SxLi+kcDrwvj2XVTx6v+w7rDaw9Ablt1yKi72vHc2WtGePF6zX40c3y8
	qrN9/XGHV+QhdsBr1vzvYQ0rEffx87OedWV4evpU0PBqjNGKynprGS1Ee7NWOnbQAaIX+J
	fDtYz6EpEmVUP3979eCNvhytJBFVczA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761164982; a=rsa-sha256;
	cv=none;
	b=Uc/qdXAdbV3MDwJ6Uw4n8O9FkEq0W+zve93A2LFZYSTwedhpZNoDVKSjFCPlD4Sv1Ni8L7
	o+VnJ2HF06imUOgt6oCcb/ljMZYL5UvF3LaQBFmfg0oD+lXadVRuNUvgacAUL+KI5t/bWN
	UBj4cILWeWfgRiEgpKNbk4/QxNnnR3Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bWWEXE3A;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761164981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JZKZ2AJTFv1mWcw/RXVrzmeGdXQKQ8Fz68OVoUjUSa8=;
	b=bWWEXE3AawOCVSp2lGhyjHf7uEu5U3eHRwNrqxRMnVq7/2+xAwDTtOOSnugQWiHZF72L2y
	p1iJa9cOVJAdFMfT4NLDDRM16A676JOPqjQ3U7Y4ZBlYKPNNh9zz78tiCULavASIfG8iAh
	2UQRgy/ObTFtjHNZHTeFlYtOEt4YbGE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-Px6B3oJ2Nq-JkTl965tiPg-1; Wed, 22 Oct 2025 16:29:40 -0400
X-MC-Unique: Px6B3oJ2Nq-JkTl965tiPg-1
X-Mimecast-MFC-AGG-ID: Px6B3oJ2Nq-JkTl965tiPg_1761164979
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso107725e9.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761164979; x=1761769779;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JZKZ2AJTFv1mWcw/RXVrzmeGdXQKQ8Fz68OVoUjUSa8=;
        b=FgKxBsOssqTPYzphLCqIAhUJb2jrIhUNuQQNMEUIfx93SVEQdJdwy30BKbSA+A33Gi
         lNq8k61Lh3514N2AVER6pk3JtRQ4uzQ5YxcedhRkxPHLW+5LmG7ZWZ0u0SkpHiNP/l7G
         Y11S/7dAI9UwrlxAtdBzsbNQE2IUZXtUbpseobwzRP1tupEYd2kHEIEnvPCJyKYsVnq6
         LiF/KkKgAHw1h7uToFuLv1VKGeuCyiQvMCIGDXj6rOqT9FkL9EgAEz/1xAS4AN2OHrku
         UwDAOO30WKxAVmZyZIMoxM18VMptX9nipPMYEzC9XHHPyhYqbQQfytgQdStjTV0UC5Q6
         jYYg==
X-Gm-Message-State: AOJu0YxR3ybynLRwUB9vnCSrvdTf8DSY2l3KEzYndTm4dtyOnRQ3svJs
	DiYjjj0BgdRw4juuOMgCUmLD8LBVx5Uw/fav99f1qo2jqzAQahm0eCVNjwBrpZTHXHSdcWs1hJ/
	22Ce/e+peMdDsadYTQDE9wAZdNpGtQpPQHqux19UNWfhmkuT1lgyW
X-Gm-Gg: ASbGncu4lSCXZRr4s3Gin/fiYoscASDy1hOsE+HPeoTvTIjJ4WtZVOD63kHEbnYGmp0
	tFlRJSp/xIYl+ylR8/QYpIA06fXiZXHMJd5mNR2Dt0gMPcjyGrqqcW+NWGkUoMv5/b5O5NkZPtL
	wqwZdaxub5aBF7W0mdJ7j3htjbaK/rwkXHQDEpc624p6kz2ET+ko5ZDDh29kcRPuNYBPgqqlnou
	10PzbXsQrE4tauF+gXNIPgsBMHWGTmuRSrQLI4Yme0ecmqkeG7SHNCxI6iAL62/Hz7RYxeEcDsQ
	l2fhnJ3Vn+zsGT6wis868hKeI4vbBCXrPH/Q/cLZABLbXc7fKs/SgNQoa1mF+nKJe2SVhrkUIjD
	HCUxw7U5TcdMJ2RjdE7D8DUu5TFdO80NSaDrLN4yIGFVc07si2euGsmp4s6geu8A1mpJxd8HV8a
	sJgt3b657tGCt2imfX9IR7h05cSDY=
X-Received: by 2002:a05:600c:5298:b0:46d:996b:826a with SMTP id 5b1f17b1804b1-4711791d69fmr149450475e9.36.1761164979173;
        Wed, 22 Oct 2025 13:29:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdSUGO+JE2UvMMxAnm1uiJ62CRqKcahHBwk0GHkiUoXLPOrVH3Z0GbT+2tDLQY7xgEYecR+g==
X-Received: by 2002:a05:600c:5298:b0:46d:996b:826a with SMTP id 5b1f17b1804b1-4711791d69fmr149450335e9.36.1761164978810;
        Wed, 22 Oct 2025 13:29:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c4281314sm59307375e9.4.2025.10.22.13.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 13:29:38 -0700 (PDT)
Message-ID: <a2476c36-2d10-4aff-bf23-a96f15235ed1@redhat.com>
Date: Wed, 22 Oct 2025 22:29:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 4/4] mm/huge_memory: optimize old_order derivation
 during folio splitting
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org, wang lian <lianux.mm@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-5-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021212142.25766-5-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xin8m01bmPDvRKki7gY0R2hNHKS7BO6Rr2woI3IOMdY_1761164979
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 47236A0016
X-Rspamd-Server: rspam02
X-Stat-Signature: gr841n4baa4d65ke4wuo1wg7i8gzjdrq
X-HE-Tag: 1761164982-490631
X-HE-Meta: U2FsdGVkX1+0zLn/Q7hVfyvmsCLXwE1pbpMOmV6mynndi7PIn1SgsrV6PI2EPFh/MDBVcadVTYE61pOKhuJ1lX43gL6vgpefF9I/MAYVwedVvMma7BeqZjgfL3+FvSDWCYtdhIYWSDdOB1z6RU1X+SAih8ad/gFocM/1VmZ+WXqYRM2PGOGyYPos8CiqhWIBjThaqz3e3VplJostJ42RW39W3AfRGdL07xSID42PNaVo4J1KpnikU2GCxEWX2GcFVb7XL2eH/F/K93CfZ+ALX3ddDLuDpI+iBd2Z+8ymZlr0jf34yOr8L12TqONBSgtkxYk7SrOxrQJ1yOV24PXYcRYkCNBybAkvWO/fUZ5dx1crO6nlMtnQ71OrFSp50leparaIK/QpT9auICk5Ie/MzwrXD0+Wu1ZWjM+FGRb68CIKLFZmvTX5P6m6E83fbdCz8IM8oRiynSkYBAjbHhYRSChZLvJ1JT7SD7oPlFJ/YWxGclOD/VmtpVFGKWmNWqDGaIwWGXW5NADqcfhL7Twu+4RCPWwVBJS5W6apS0ZuYHoZ+HQGj3qcvGJ5KKy472E0hvQzYKDdzNRBOzZ4LmKfIkd4hqoBl/KjY0Tsqk8tierg2vm5lbkd+bFYxi0GYfXdKmXz1VSqzYyZQ4G93EXDlL6JZPXOSE4fzsXCqGZ99uY9rdakBeM6ljlrIIS7aszDUX9oiUS5+kO+84d/BiTlboLoYiTfwxs1gogOqqMcdOlO2O4qVQ1Fdn+m7FsQYpe7RRMW5Pq18IaRYWTc3mVHEFov0Siz5rndSWPKuV679j6cDpoUlDvscqsIcrfPq8cVNPt7PjOyQCYG0A8eiXGObOxsxdFUspmsGk6e0TQB2+j3PInU4oOJlcpGrVq98f3mU7a7bwQtzADtSh9CMwBaTzkzjgh7PvWjOsPeclR+5/ASPtHRJszZKu1jx9xvg2g0mEKiezxuGi0cHtSAa67
 heVjdiXw
 UeDJDgNKy03WpxKDxMFoRXGNlG5s3Eug7vAbxzoj9ACvElxkB4CgIFdS7OmmGSX7RMvtfl0JTZdPn8BzDFJeudUi8b8WRyOrKceX+ugKlVNFPUX/wqzXkG+ixD89KLfT3NQMcY9WC20x5fNlAOn9Q90yYBMZr/ZN2tJSjcy2N2Rz5e5iztjaU7FKEcF6sG9lU7+kLPli8QTvx4rwHpJCQcVxejkkAZmWEwY8ZSvKq7oCcKSbK69lWRRs630oAE1+wAQKib31c5J8Sg7YUKJ5896ajaqtna+mm0CBZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 23:21, Wei Yang wrote:
> Folio splitting requires both the folio's original order (@old_order)
> and the new target order (@split_order).
> 
> In the current implementation, @old_order is repeatedly retrieved using
> folio_order().
> 
> However, for every iteration after the first, the folio being split is
> the result of the previous split, meaning its order is already known to
> be equal to the previous iteration's @split_order.
> 
> This commit optimizes the logic:
> 
>    * Instead of calling folio_order(), we now set @old_order directly to
>      the value of @split_order from the previous iteration.
> 
> This change avoids unnecessary function calls and simplifies the loop
> setup.
> 
> Also it removes a check for non-existent case, since for uniform
> splitting we only do split when @split_order == @new_order.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: wang lian <lianux.mm@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


