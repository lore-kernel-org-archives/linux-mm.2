Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0107606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=b4o1XNDl
Received: by kanga.kvack.org (Postfix)
	id 97F1F6B0AA6; Wed, 25 Nov 2026 14:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909526B0AA7; Wed, 25 Nov 2026 14:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8E06B0AA8; Wed, 25 Nov 2026 14:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E29F6B0AA6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:20:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBDD180271
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:20:23 +0000 (UTC)
X-FDA: 85474607526.08.0E37100
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5124A140007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:20:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b4o1XNDl;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of shivangu@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=shivangu@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795634421;
	b=MhUcVDyd1VaBzTLw1WPNbEdj7Bw/qU+ooy40b1lJoMmB7V99zKk/Xm2YautbcYjwRFwsvr
	LOnuM9nF+2wclMCSUQNTcJnJ8ziW32Zap4vYAhTXiIzqG90PJzWStYxuAAU7D+8TLOS7K2
	Nf1qLbJptSk3KC79a7vowL4kvyOPZ18=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795634421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjkmUYAQqhObZomEhSZvG/YB77KWT+YtxY8LYQ+JXBM=;
	b=7UnXK2Uxm8hc8k7QKYhJnhfjGnsWXXsvxtsaSm5Eq/c30TB7cuAz8x7z2ZX24LAYtgcCi/
	1M6zIu5NOquB80afWd0hlmn6+/985+q7v0+7Qv1hBMGF9KOgupoKDvLdiOfy/fITiEjE20
	3X/klPZCdCWKl/UMbZbMcDAVw8Xlnuw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b4o1XNDl;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of shivangu@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=shivangu@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6APGYdNb1999322;
	Wed, 25 Nov 2026 19:19:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gjkmUY
	AQqhObZomEhSZvG/YB77KWT+YtxY8LYQ+JXBM=; b=b4o1XNDlfljukz22wGJQ0h
	hFDvCKahLQE5+oELMoxpvR8yus1xr/9HFGs7jXKfv24NedjQNfOPAQLQsOYaYxmJ
	dUFE5fhXckqAuW0PYjKLfUY4rjnJnXiiEJ3J6heXYs/hWnlWwEUIeiE6+U2PbLg2
	8YmBlg57Xz94o6TGMiXCPGRFMqcx7uqeKTvP5PT0Ve/GxmJjLufrD15klX7U8Hzv
	zal0O8X8xVHjp69b9e+a0liO17XVYXOOvkfuUiwLL6YKgBmTbYUQ+hOU7A7uWYN1
	Af/9bgIBBKYXWxK+4RRNAGIaKYwc8nTS7EMTL98PhsZN4n/5Bz49Dm62UQ2Sqx/g
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fae8qk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Nov 2026 19:19:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6APJJJGp505545;
	Wed, 25 Nov 2026 19:19:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5uxx22n6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Nov 2026 19:19:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6APJJdNd42139928
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Nov 2026 19:19:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBD8220043;
	Wed, 25 Nov 2026 19:19:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75D8420040;
	Wed, 25 Nov 2026 19:19:14 +0000 (GMT)
Received: from shivang.upadyay (unknown [9.67.112.155])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 25 Nov 2026 19:19:14 +0000 (GMT)
Date: Thu, 26 Nov 2026 00:49:10 +0530
From: Shivang Upadhyay <shivangu@linux.ibm.com>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich <dakr@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
        Christophe Leroy <chleroy@kernel.org>, Boqun Feng <boqun@kernel.org>,
        Nicolas Schier <nsc@kernel.org>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org,
        linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, linux-mips@vger.kernel.org,
        rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 05/11] powerpc/vdso: Enable the vdsocheck tool
Message-ID: <awc0rvqmahY6cHtv@shivang.upadyay>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
 <20261123-vdso-absolute-reloc-v6-5-161e218dd217@linutronix.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261123-vdso-absolute-reloc-v6-5-161e218dd217@linutronix.de>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDA3NiBTYWx0ZWRfX3whPefz46WC1
 hNygsADgWWH3q76IQ97vzHqlw0KVrxx7r7UAw5SVuBqmP03DlIHvveHdnCb8I+LFUdhf3IBTEF4
 8I0LKw8A6RDat+2jMShRhIdJyHC/snbMARzB3j97ZRg4dk9eQk6Kb/c17OPxkgsEeh56QxlIgDC
 wUPWuvr9YTBgUtvA8T8GCqkSSvcvT95hsmx8Ct0PUUDgvFCs7cWvxl/cHPmpiD4Kk1M2+/XY3xk
 DLiaxWKhSrSivaxvdgJ1EA4G7gz0ulJrAaMk8ySQ2/S47CSLA2FI3plB5nV4GNPFWQXLUfRWPHl
 QcXK+Qe1+YjjykPhUcW6RI716uPTfT8UPFmL8V6qwT/f4oC1rJT58R1VQobyjiFZ9MGmwr6WlCS
 z5ZKV+GghS12zlmcdRFYX61cx8WcuTghM7JYnVHIKLaR9Q0N8q8XzXIjmtuCeYWzKrV/9/k7FwS
 CZCtvJAPPqeb1X+3DCw==
X-Proofpoint-ORIG-GUID: 9DuPW81bc1Ne1-Acmq-ZFQ1oXTeQgO4D
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b0734d1 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=8nJEP1OIZ-IA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=K52B-zMjTZoA2OaJzQcA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-GUID: kgd6ntmKeCF4y3vpHzpfFLVurSHBIu2a
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDA3NiBTYWx0ZWRfXwLCiikm0vVyM
 9boHPXPDQcdJQkQPxTdXN6x3x8c/RPGIYsu6hqtP046Hh/4b5uaJA5LSJKyG0fXuE8vE282QQVw
 jau+sQ3OeVvDMeZGSzccJJHxqp+Tqsg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-25_04,2026-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1011 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611250076
X-Stat-Signature: fxwxp4uxi6zwjgmeiqngug9iafs3ppxz
X-Rspamd-Queue-Id: 5124A140007
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795634421-266673
X-HE-Meta: U2FsdGVkX19liJgYzKjwJDPoPADUdT/zCzSWZ8m29iUh9GbQZHrZIRX5KmV6E/zbhXsb+o3mOcE6uEdslBsvkmTJKRwTYK4dswfCujjg8hXWphdau9622Zjj2HUuAQ7DmxxobVJ8NEbdEdCuFzZcxRWP7eIshWEqTHIyZ+TvzA6LKZYIpsasLZrduCOUuttqli9uWP/dIdjIdiMdWPzzQg+BPEOZAqbMXWKqfXUShsu5Do3UEq/4VLCgfnzniZ0aYQfedfWqS9BqB+gMkEvt96NSh7er/hhk49yaQBPcIR8uidXTyMvliP79QNhQPCzgdqcw+q0YP23eQM0loR13KESeEq5JG+xKYeOsPS5Jv9FQOuxf5w4ewWgdz9wCye+/cQFIRBbW71F2nVApzzOrtN0pT7w8NcEH5v4zo81AnmG29K8yVPHDMrvYs81j+yRpNyIt3GeEaxuFpqXfWuZ/Qvu094z/Ebj6AM9aUHmPaMGfsvt0rvbZ4XK1Q2eRevlHeUAX7zgL7KUv2OkZUNUcOfUFCg9/eR79kEkAcQWgwWoDhTIyx7IFcn7H+ku/N5fZasL6Tr8iMp23mWFw4SHW/Rso0+w1zq1HJ2DiZkp5noUj56h2NcZSyW2GFACDHmYgoe1XZsKLecAiNDAKsOnPUFnu5QBMdCa5DGa8fYOWN+a3zYa/xwcRdyYBlRr3AwBUXMrWLwX+AMx2XKSxAAGQgO91AfSIkyaxi7Gmz+97mwhZSQoL6POTfssOTEAIpNN6x+f8A/00qQNqX2TJ/3nfC98ohxubEbioR1fgtwBhOq+bfyS/6HNd26gWGdLf0POiGAnuNO93c6qmU0zeBpo0B3jkpH0vsw7gezCvhck+h2LEgNxO3lceg1xL4by2fyrDbFIi/9FU2H4E7wG58JrWYmbZDD8PwGPRLq77XTdPzAlj4D1HFlbzj9q5sNOaNoj5dsIcZOPEF6Z1LrvbJJc
 kKWJHjSW
 jiHJfKwwU/gHPurXze7kWfozHloipZjvXiJBpzc1YxVXLH3ruE6JO1EO0gDGM5xU/HBKkfMqqwcJGXsPUM+mMTDBWJLcNowhPi82lnQmrrsw3TfJeAbKr23wlW9gRw74EMfvEnZzpXFIT1cbMZIFCTu5LgmhPgzXtC99yQPPZ1zsp/PNFPUgoOKfdL/wlpcWcYMAaLrHmL1iHTOpy5MT4ey/nM8tRJZe3dv3nb7jvieSK9DZX988xHtKcrVf52FRJQPGk646H6kLqLd/mpGQ0VAoGsRWKnFK+cR7Xn5XC7yJOVeEkXfWp1FOd+3WILPDKZ7k6cl3NTELwQtCTW0Qgz34yeSqMfOlJCCEvzWXYyZg91s+0zO9YRBDZGrjtB09o8w1aNfTEQ2yyElxG6eNoobuInZamiDypL08dnb0yh6fIkRHNc3XNjncegUQO20dvwQrl7YhAVyQ/HRirRqx/Eu1StstH/QaGSi+InAc04OswNFmzavD6IbmpX7JP9dFoqJVKkWwQSQaXhqb+8vsHPShb2Lxi1TxLK4MjM86GnsF5sox3O13RVSGvxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 02:50:56PM +0100, Thomas Weißschuh wrote:
> +        bindings::EM_PPC64 => AllowedRelocations {
> +            in_object_file: &[
> +                10,  /* R_PPC64_REL24 */
> +                11,  /* R_PPC64_REL14 */
> +                26,  /* R_PPC64_REL32 */
> +                44,  /* R_PPC64_REL64 */
> +                249, /* R_PPC64_REL16 */
> +                250, /* R_PPC64_REL16_LO */
> +                251, /* R_PPC64_REL16_HI */
> +                252, /* R_PPC64_REL16_HA */
> +            ],
Seems to excluise list of all reletive relocations.
I only could find the following being actually used, for defconfig ppc64le.
But good to have all there.

[root@system vdso]# for i in `ls *.o`; do objdump -r -SD $i  | grep -oP 'R_PPC\w*' ; done | sort |  uniq
R_PPC64_REL16_HA
R_PPC64_REL16_LO
R_PPC64_REL24
R_PPC64_REL32
R_PPC64_REL64
[root@system vdso]#

Looks good. Feel free to add,
Reviewed-by: Shivang Upadhyay <shivangu@linux.ibm.com>

~Shivang.

