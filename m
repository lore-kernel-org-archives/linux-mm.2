Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F6BC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 17:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA996B008C; Tue, 22 Jul 2025 13:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C20B6B0092; Tue, 22 Jul 2025 13:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7E66B0093; Tue, 22 Jul 2025 13:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8E66B008C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:43:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D879BC045D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:43:35 +0000 (UTC)
X-FDA: 83692622790.23.AC3FB18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92804100002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:43:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PUgTL6CJ;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753206213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsDH1uioSNYFyJB6j2gj5W37ON0NSVyJvbRCti5KG5U=;
	b=xRBdPWrxiR4T2NfS8jfPvVbtd029uLO9xHfYd5JoBVOxs8zN8BDyhTNpvV/Gg5PlC2k9VL
	hgBUE6y8SizQRDatVIWtnpvZmNvlNsWocrLBjzLlKvoAXs6gt7OvpFGaKj+u5U1LcMUeaP
	Cj1s8Ld/U9pGfYJJ5JdLsWSzhfjWH3g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753206213; a=rsa-sha256;
	cv=none;
	b=c4B+u9sJ5ZTYqKxYIy+2HsGS/mXAY3GnZFMfPB8AfOeYotKlW2t2vQkxm1ckBoMgzYHrRv
	I6GH4uPyo41GNcpBv7Jc1hd3LsMwQS/+z/1SrpZYr1V4Cy0xcdpnfgYsNsF4Ns/eab7FpE
	mAKIwWDp73SCtXC+mm8wLlOmfMlFMQg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PUgTL6CJ;
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753206213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VsDH1uioSNYFyJB6j2gj5W37ON0NSVyJvbRCti5KG5U=;
	b=PUgTL6CJ4m+lbxT8rLcPhswDMwWFUrR8MU/4pg+2bueBdtrXHG25V5O703tmK0anuRqukY
	Mj7yXkG4uRyt9wIhAHCc1iW4BRUsh2rOT8SaxhbZxPASGexMVxiifaZgHp6IajhueKPc00
	iiODhRrijghXfX4wcn+QGUCfkgv/2R0=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650--aFm7RfhM8O8ENlezGtj2Q-1; Tue, 22 Jul 2025 13:43:31 -0400
X-MC-Unique: -aFm7RfhM8O8ENlezGtj2Q-1
X-Mimecast-MFC-AGG-ID: -aFm7RfhM8O8ENlezGtj2Q_1753206211
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7194c6b0b8aso74393457b3.2
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:43:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753206211; x=1753811011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VsDH1uioSNYFyJB6j2gj5W37ON0NSVyJvbRCti5KG5U=;
        b=D1XfguLtsyAqsAgvgRdyedN/DBxQcSUhVvyxIIg8cjw+Q/KzOB8f61lUbzwygirxQb
         rXdEwCk6iOwK5sx+eWNIw66zqO/mkbwA+dG8ps9E0wZlEgYOdxboM/hHNt9MlgMjcdDY
         +6tArvB1Nn3JX2ZBfVwjeVa5g641cjt/HKy2OZf+v9uOrsZTPD8zqRhhH5vqBPqQ7jkO
         Kmrjfip5upeqfGSx9L8GPhv823S7HGPAP8mgABc1U1M2syYC175O8g2OGNFmCYJQky4O
         foVkyhxB5k/HbgFeFI/1ZvOXHo9k/CYhnNDHhX7jxLjuvvOu0EWZ6CyeltSxqtmlTe0+
         av+g==
X-Forwarded-Encrypted: i=1; AJvYcCWt5/CuL4nizw3WTsKlaeZTJDjvHTn91z0yuAFairxe+T2H4ghWeugoUIOYwEoY4NY1/XkJMG8S5A==@kvack.org
X-Gm-Message-State: AOJu0YzfFjwCUW61zeCw85yW1mOpyiAiNnmBLzk/VvieB5C/uHRlPrwp
	J94kiDXwLzkkfbsfOR3xphGeBTpnSwkMwJE3PfUlGvEvc7zrqh1T1fDnGdfgb13r7GdFLaWoReL
	0foUf42Nc5mV/IduRB7WhoIY2MSQm16wj0wXqy2cWDDJ+30RG1o1hRk4cFmRYXh3ZaKMUawCKby
	hjM9LS42kEFU8gg9JnSjsf/7NcSAA=
X-Gm-Gg: ASbGncuLhhR9AVMaNjDYwsdkmZaibYMNUeB2bxiANKqsc8t5wqZCq9tbOS6XmHBUujf
	n8bE1xPuqPqxPGcoGHisx+dYK3tq2IqT6hY4/56xQZ6NYjmq6x8Q2qRiGU72fcOZMVM/K1HMqPo
	mXBhtTYC6ULiFwjGPqsv5+1Ec=
X-Received: by 2002:a05:690c:dd1:b0:70d:f673:1412 with SMTP id 00721157ae682-719b40e10d0mr713867b3.0.1753206210957;
        Tue, 22 Jul 2025 10:43:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJY0nNAxT5tewwnLcCVplQzJwNdk/gKqQRCywyeYDl6NvY1tKvaGB3litrfV1J9rWe/RV38T2/mmZ8Vp3FheU=
X-Received: by 2002:a05:690c:dd1:b0:70d:f673:1412 with SMTP id
 00721157ae682-719b40e10d0mr713527b3.0.1753206210605; Tue, 22 Jul 2025
 10:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250722171904.142306-1-lorenzo.stoakes@oracle.com>
In-Reply-To: <20250722171904.142306-1-lorenzo.stoakes@oracle.com>
From: Nico Pache <npache@redhat.com>
Date: Tue, 22 Jul 2025 11:43:04 -0600
X-Gm-Features: Ac12FXzAodyj834b2REngbgzb2Y6TeaeeWycPt5oGwsuolzLS38sonZX2VsP7wE
Message-ID: <CAA1CXcBY4rFLkNqJM2Dj-EajPw9TMTHNcYapw9P=U0bo=QNqkw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add missing mm_slot.h file THP section
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t9epUwtaRLvpjV8BNQbmbkLH-PwD01bZD58QMXmXmfI_1753206211
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 92804100002
X-Stat-Signature: is65n5kcoiuaksx8e3g6o6wtembxy8xt
X-Rspam-User: 
X-HE-Tag: 1753206213-494738
X-HE-Meta: U2FsdGVkX1/vt81KO9K5crUAN7FFNTyEumaj1ftC6bv14BOGB9xu7S4yMwrvxJyN0mdj/zCF0o5MlvxLR8vPK+y2KAvhnbJjkD0mzbZfHFB44grtUBKaCKm7tuIr6KFq+HtrXP4xXRXb5Zv2pS617a8xKJUZO2wQn/iLjIPEJM1xmtSXANaagx8Y4uefvn76rid+zojKtf16E9fJCP9GKMVVVFXb1W/mmMQ7rnjWfgIdKaFmetVFHQX2j8YDpih9gZh+3hG+ldaSZnTok924C0wrwZOXVecaNQ/Nfq2VwDAk+TdOqFFqs5sI5xNaQFTiwsyMea4M9CVDsmlnj5rnH1e3BYSk0Vm1/v623eio3yK8XhEG5UoxlwWxNp2P7RhYMe0179BBdAgcAJpt+lU+izE9Mr7h7E+bX8m5cDAAXeheTdMJnObFE2E3Q2G6zE/terbsF2tAKdHh3dDbmNeSXvU/CrrCASfByiKVO8tPYDmWtsofOMEclS7lbCAA/AM0iKf18ROVEvHZFXSUP8aiJn+doK42GJdFkNAU+prEaKEvc5Z84ZGXDiVkJ+sAr2XaHXYBwvjToccQmkPRp+RozDYk06A4pS33Mb0HBKWrHYtHzEx7BDEg0ePQip95NmFXwLIqZWoYtmfh4KfO/K9158TOtyCNCbnSofrylbjTGVhYpRkueBa1acTp29SIfk9xO8eeiwUxKDiUf4AnUMNJ7xcOZz9r3Im2jt/E13joVttTFtmCZpub0mM534nDoKVTd1H2RehRxRUZ+IenLx05iHN023noa4R3mlk8v6lGI/I6raeu4q2zLNwlrXgzyebzhA6SQonuzu6Jv6rC8qv9K5skEH7ZZBuD9FeXssXcCDcjVmxaiioFG8Cze5N2wQpE3EQADD+RTaRn1IeoEQ3Uz4q9HR3FptV2zUEPd4HQ+7JCgVFRIxAV/fHgA4iRYH+WUbkWpRQWh/54XdNFfXB
 gyKljFr9
 /rKwpNtT1AD/Eeiz+sVcjgkAJvRZqxtmmUQL4fHfo7jEFjSkfnXi/TcI+g9GqNNEpf8CponxscnLLqHKAMJ0HZMlvBDgJreTkCQvO9me9OeeQKUDPrenB1p5OFylxKYcof61oGYJHhbxkP/eMVxbN/3Hvx2nUmOc7avUSYF6GKtLCXSHhlfskxQUIOs35KKE1QU8SGJtWECxZ6gt/4BaCIEjUlf/XbGHfGqNU31tuYySTMXdOn062n9aeaXji9Q3O+kXqdkWLHMTaS0UwbmV9PqppYUaJz4Til0/npgHxEH7D9KBBxwFTTGjHyfXUkuENLbAEI4QJCaAY/Zc1DYMOlfWheMpFl4Bx0bA2mp7s8/QswzdmAYL9DsOHYddLx8xv8Zru
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 11:19=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> This seems to be the most appropriate place for this file.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 837bc5cd6166..3f83fb317f51 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15966,6 +15966,7 @@ F:      include/linux/khugepaged.h
>  F:     include/trace/events/huge_memory.h
>  F:     mm/huge_memory.c
>  F:     mm/khugepaged.c
> +F:     mm/mm_slot.h
>  F:     tools/testing/selftests/mm/khugepaged.c
>  F:     tools/testing/selftests/mm/split_huge_page_test.c
>  F:     tools/testing/selftests/mm/transhuge-stress.c
> --
> 2.50.1
It might also be worth adding it to the KSM section since both of them
utilize it.

Acked-by: Nico Pache <npache@redhat.com>
>


