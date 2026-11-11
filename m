Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A89F606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=TIcq03Up;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=C9Ttc9h9
Received: by kanga.kvack.org (Postfix)
	id 65F456B05B9; Tue, 10 Nov 2026 22:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F8D6B05BA; Tue, 10 Nov 2026 22:19:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D84D6B05BB; Tue, 10 Nov 2026 22:19:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 199A76B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:19:56 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A08C5801DA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:19:55 +0000 (UTC)
X-FDA: 85421383950.15.501A4A2
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 75ED7180003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:19:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=TIcq03Up;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=C9Ttc9h9;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794367193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8lmC1CEcuQRQENyfqYrXJ3vs6TTuyhEVdpg3dSwAzs=;
	b=mifcjfPTUDOgoi9go0zWbYmbMYV3sPz/i1FtuCFzGFZbd1Qzag6ZxoZa0NF7FUZrE3wOXT
	+0/gqIAPPi1q61ofA0ZwJxUnZCOtbv1+QtK5wHTLTMR5jxl4zRfA1kb18jeokBnOk+e5RV
	EYS1qQuUgbfSosGjNJqolJmOWY7AVoU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=TIcq03Up;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=C9Ttc9h9;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794367193;
	b=zrr0CAQ/UMb2/QLiCNH1xf12Q5oFhJ5bLj8pfrJMbIEdTA5kVt/p+rywSSt2U9Bem0DhtF
	SY4NKrFJgD06bTDA/TsKLYyXwtAv5SpibEjyTr+/HIymkfi3cyy+A0OA51TrB4+b9VSXsA
	cXkw76u2cUAyTdY+qw5PhR/W03Mn15k=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB1bMYk2569908
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:19:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=o8lm
	C1CEcuQRQENyfqYrXJ3vs6TTuyhEVdpg3dSwAzs=; b=TIcq03UpeXG5lwYgqnoC
	oiIGN1h+T9pWC3UwBNT1771VVg0u4q1PH/9AAQYGex6VEhdW0bmD2r7tdcfA1RQr
	5yZ9JD4Z5ClYyb2xiZ19yggiwwQausPdbOJMzZamTKLiypUKCJYQfN6n7wBcljC9
	ep7JF56xU25TxwH4SPaQ1EEnRp2bNNXupiNQXkmfzICk9oYpIfUQCmXfLW84GfO8
	pVknrQmjI7YGa/+hcBaCMyp094tU2VEK84j96m6+RMOvOn+MnP3HC/izSokntB81
	uepYzn0NW6tQtZCTgHkNB/Aqey9UQ3gc1xsCvOivR7oWbmYZ+jLPww3zMKXtXZoZ
	9w==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hvayq23ms-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:19:51 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f6f4fe531so495554285a.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794367190; x=1794971990; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o8lmC1CEcuQRQENyfqYrXJ3vs6TTuyhEVdpg3dSwAzs=;
        b=C9Ttc9h9jW6r9M9efpXMVJf/h5gj9wcZ/nZu9MDo3Wu7tegO0ldclGbXI2M7kwPnwl
         sINu++Ox87dTaYG6omMGdCrz90UY0y6M3/FuJ73HnvMFxArd/erbO/+27xkh6BkrNat4
         BovupYSvT1snA+lrxO1Fm7X4iDKONbw8P5jXETlfscv+o3NWW3bKAwT4GuzhLAu1hJ0r
         SCoOtAKsbv4ObA3tttLOQssq5CNPy78CQUewMFzig+QotUjcf/bCutEZ7M1uZgpsuqGK
         amQBVO+4lbCy3hIxYIqtS1ucNAVia2DWcA+ylRLHgg8H4CaRYomFKNtN0QyHxXlrXweQ
         wTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794367190; x=1794971990;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o8lmC1CEcuQRQENyfqYrXJ3vs6TTuyhEVdpg3dSwAzs=;
        b=yRiGoxHgGP0XWSo822V4tQrKv34OWi+CFMMeLw8ynFT3hUFMELF28sxhoUiTiLkI62
         WnH7j29XafYbNU9UG0YXxH0IxFGtvP1JESWL6k42xpQgkCCJiKlITAFnxv0fDYRzlLaH
         8hVET02+IzK+PMUS4YqoCfy824C/2Nr9oD5BV4N9zsiE4Nvw8Kgub+Hcl3uflEgFjREV
         4ADKNgAyM+jA8fF9PI4FtBFEjF5BVDlOwfoXax1Onug6gTRDOIW5j3tZfhL5bWeu140s
         5guYd1Yzo+R4FWofOShBCckOuTGX2UHO+lAIztu7FZZK8kbZt5pjO9UVpoMTTcle/FQK
         JBig==
X-Forwarded-Encrypted: i=1; AL+hErGW7biX/aw70hjXlbtXFVO7qYBnyANqmbqx7dVwsYBWynz3IkRm0FSuru/c42b+sp8F00oFpBLkyg==@kvack.org
X-Gm-Message-State: APuU4Z9H2HbBfMm2t2a9jGwX4wRVls+EI4sUvzLdUNr+DGWXFfxHgLFm
	d/8s8OIrXoTh9XCBFOrN0ztLufS1UIu14Yw/rPRK2XdtX90BcW9OyMLS2wpRwCyrAf9lVcrdHhQ
	D38OCrrAIrGOFEX6VOtUYvFeGucyIQlP1vU8VzG73tgkAwL4K
X-Gm-Gg: AYBFou0RU6K30JEEHaF3mu9n54H+/D6R3XErz/28xHM+BFoa85jlPdl9MmWG+IXSHL3
	Sppqlv/wlWrG5A6uiCdzvWl2zsVAy5PvEf7P/NDOmUdvti48ivKb8q/F50629NCR2CHaA73KzDZ
	jLYqYDVsXp46owP0i8z0pTrYR81szshmhtkkFtnfGEqgVqZEl9lb3cd59wngYPFVTWQHeyK8r4p
	UbJRRHeE8x1iAh8E05CZmFs0apayYPFnnU/bzsnXaehKSUNc2PjSbQ+yhPSw1nMJdbhPjP3T2fi
	ZhUJtXsUgaVjsGSItl7entkwM7eDV5/rcp3gWhA0wRQqLk2eQl/tuvpSbEubkZQQsn8s6nyCgYF
	AV6d2dMolXPGp/m3kSadC8YYpS8yzt24oiWGa2pBTYuUaShhB1jzhAGb9AOZC7m2HvV9H04BnDj
	v0d395QnfY6n7zygkKLHXeSg==
X-Received: by 2002:a05:620a:294c:b0:93f:2b23:481b with SMTP id af79cd13be357-947afd6d3camr182910185a.22.1794367190193;
        Tue, 10 Nov 2026 19:19:50 -0800 (PST)
X-Received: by 2002:a05:620a:294c:b0:93f:2b23:481b with SMTP id af79cd13be357-947afd6d3camr182908385a.22.1794367189754;
        Tue, 10 Nov 2026 19:19:49 -0800 (PST)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7f2edesm383441285a.40.2026.11.10.19.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 19:19:49 -0800 (PST)
Message-ID: <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
Date: Tue, 10 Nov 2026 22:19:48 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] mm: khugepaged collapse_file() drops RWP PTE markers
To: "David Hildenbrand (Arm)" <david@kernel.org>, n3rd <18670333770@163.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "ljs@kernel.org" <ljs@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
        "ziy@nvidia.com" <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "security@kernel.org" <security@kernel.org>
References: <606cae9e.bbec5.1a1c54f4f9f.Coremail.18670333770@163.com>
 <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAxMyBTYWx0ZWRfX9wH3uIgzQh2F
 RUVvYe0Ls7GjTtSQBDhSXi0yKAl9HzdATweopUhMTH1lfne+4G9B3JdB2AJppsmdG83QJaaeDe2
 ZeZFlA3KuCXTEGbSvjAjwkamjTdMMesg2g20mCDFD5zOMp+9jZEVcDZe64oTIkoAkVFE+5s6SyZ
 D6rZJX9Hn1fa+hqojeSNaxOtV8+LTEh27ukdQEnLYYlkb3NrpcQMs11DmOzGFvp3iDkidDZcCBp
 4dIdjHsNRVm0K0vNqThAgHEFgnoRahuRGWzAPbfcmQ9Rnkor7e837v7l8YgRvx2VpNpLRIzISrR
 cOgaiJsDyVWb/jTSUek5IsHoCscWD4J6khoRK73CEhQopiePHhFGw9D2w+DkgDVFUmYQPWb/N1t
 EXqqW+taeFnv960TshHYV9J7Tnn6VHRzB0oadM9F3avLUBOe0anFZ1+4pJep1oP8W0y8aS5y1NZ
 KWoB3MjLlC+CaJp5QFw==
X-Authority-Analysis: v=2.4 cv=X4vHu2Te c=1 sm=1 tr=0 ts=6af3ded7 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=a8VdgqZZYpu-pf18SQIA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAxMyBTYWx0ZWRfX6ALOBC97814H
 CwdVaLAgZtoCyt8GjRnCK2WSKeW/sdGV9duUTMr5axKXDGKPSzn57I6y6SviS89YayIcw3cUPx2
 0tmFGuUXtZmcwbg9hOSz3U/B3xhLY+l6Iw+pV8DrenG5I6uHN7uq
X-Proofpoint-ORIG-GUID: VILwgAI7r1ZKQbB6JrjUDO3lhUqh6ra2
X-Proofpoint-GUID: VILwgAI7r1ZKQbB6JrjUDO3lhUqh6ra2
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11962
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 lowpriorityscore=10 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=10 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110013
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75ED7180003
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: oodurix8w3hs8abzyimoh8j5g5qejny7
X-HE-Tag: 1794367192-889265
X-HE-Meta: U2FsdGVkX1/tfRzJJAtBCiJLa0NCwkI7n3hE8QlZxvc/UxJ5PcgHZj67pqfgycBsfOlxmdmWe9I7wuJ1c0y04OgZIE2FbXnlxDpyW+FtiFkCT6rKXIKYFr7Wfuk2wpPDe3kksK4541X1rrq9ikKsiDb/X0amHClDQzdOslKYSl8UIkXZzqf8HzllKUdw1OMzCqoopfSbgb17olQG8DshcMOxfJpqksdd4b86hY9sri9ARqdUfzl7bCnOmUFJLun/++NB3ohqyrKdRuZGfvvC+5zduKiNBauwlI9K6Mqi4w23TG1LPjq5c3fayKxwChw5RoJUxdcKA8H2G+Ag2Gkg+6rXUCAjG+FjwbaQWjkcQdVll0NdXdQks0DB+FyCcjpqcI5sk5cu8tohJtdzHB1kBSgtc1c4bzzppQZkYlyhgcNWmsC++zt9RoE+i9fucnFAeT1G/2LG2tE/nqOT7QDMq9qNc3LhtSNQTz8RcYDC9X/RfWKUSiS3Ki3DKieNNQxEzMZGr/LMxiG1Sb+CY1x6AlYuafWHLvALyRUUWYmyFZhGoyS0On+lvyqFC3VFAw4frtcDUA99fkxmw9vfFScEq5ctqdj4b5Sq9r+PuNkPbFQpmGjgNVkbAYZ1WPWq/ednvrxw8WkqTDrZEXs00raluNqNeP0I8xFSszVNzaxxXyNiZDsXjVP3E+Rvkv1qmj6qgEV054iAwfk0r1iJNn+gzzSSc62KkJ6T4CXxNAzDdNIp2IkmOob2mF8/QQQNOzcNdI2UGYn7Q7k7SzcS8VrJHk2MFiNG5HOXakR2a4OuzjSx9q2pSxYZADUZeY3tEWxjRRSX8PkI6EpK6f0vbZXL5cJqT0GobxOIjDxr9mcpCt3voA0/j7tuF77cDJmFYFYjxVtYpgvm9r4/T7dpUgiUyTxFKgnFW7N9DFcwoAiV1IseYQ0QSOx+5eJS7wc+t8xIKJxCIaSKhYGMXRpSCNd
 dWRYCVn8
 irio5+LJ4XTbuuDvlOWi25KupmDfjJO6y2fnngi2bvczhWU2beheJ/rFgcQ6QnniZgTjjL4+jTIMr/f7i6d3lETJtKj3cWl45vGaaQR2JpHbzqlPhvY7xt6Rf8iGTlm08BIFA/KpLIunUC32op/on2PVhgISZrcU0DGaCmT6ydXMlLfymxkFsfbMdq1TudCBUChrJY2KcM4TqLXBXGaaH5hdEWlDNJo8yb83RlYTxFyIH4E/XgebZAUGI/+7OtWCA9aYg7PFOLofYj2kzJa3fjx2ShZVNb7INCEB5y7pm63nxyJsJ7LcnCPGtED0HkL5tYv+EDvKNQxoA1jeuM7e2/76W9hXe9w/OCSWWhmeHM4lyigjGJlPf1aWQw1ckOEvETPprti1zRyJsGkILMsfLq/pmQVi3ivL6QfoB9bi2EwwBhWEm3Odluf61k0RICpFk7fADthW0wCXUemH+uhrnnVWhV+m9jiP+W+eb0XzYmA/d3wAxxc9cteUA6X+6SqsxF8fq/1YxWI3Ta+Ua+Mei5FJQHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 6:55 AM, David Hildenbrand (Arm) wrote:
> On 11/10/26 12:54, n3rd wrote:
>> 
>> Hello,
>> 
>> I am reporting a security bug in the Linux kernel.
> 
> Stop sending uffd problems as security bugs. STOP IT NOW.
> 
> Tal has a long list of uffd-related fixes he is about to send out. CCing him.
> 
So this issue was originally on my list and I had a fix for it... but it was
REALLY ugly and a band-aid, so I dropped it.

I think the real solution is to just add actual markers for RWP and solve
all of these issues at once... but that should be a separate series from my
batch of fixes (which I'll be sending shortly). Is there a reason RWP
markers weren't done in the first place that I'm missing?

Thanks,
Tal

