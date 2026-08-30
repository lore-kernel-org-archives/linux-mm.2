Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A793C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 11:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CAE6B0088; Sun, 30 Aug 2026 07:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD7B6B008A; Sun, 30 Aug 2026 07:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595A26B008C; Sun, 30 Aug 2026 07:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2830C6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:59:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABB001C1A68
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:59:06 +0000 (UTC)
X-FDA: 85157789892.16.F7A2991
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id C997C16000A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:59:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=R1fYfzRZ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="WqW1+/hC";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788091144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cga6AlYSi7DCvZrZkLitELwSbIPiw2zoKeAlwpkN2QM=;
	b=r0Dk1KigUWdjtW79jyEPgD9Mqi2JmV5mPyTcm6DqM4RSfqbSjW09xK6wcvpFTr88I61h2y
	oX+uc2wgVi869ibp0OFPtvuE30BCMkJK3D8XN+6rlu7UWGIm+VQQBbXWW5oOX1tiYLmn9V
	Y/mnJshjEQW0u2ybGSUVASn9v408P/E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=R1fYfzRZ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="WqW1+/hC";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788091144;
	b=niZU8GUlK5QRrXQWpx9U3NGAOFpYKsEMxmIcv2x6AHQ2M4yyy1tnjoS//xUBrrvlvdXB8V
	x5lAB2UbluabaYPeac8iEkhM2DHh8cxgBJdEsfLsE+WYJPHOp47fT+Ie8r8RgB9xoqAJPx
	5u9u9/juw9/G9t6nRZly67WnK65tE5A=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67UArioG3806172
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Cga6
	AlYSi7DCvZrZkLitELwSbIPiw2zoKeAlwpkN2QM=; b=R1fYfzRZvSO1FDHDhGXw
	PcaI6hMnEQ/xqggSf7cs1BiJfs1arR1Ga52y2IMmdtQHz9ERH8r+lTSXR7AEIGEi
	uZ0VzBon73C3fwyQew/NIGcr97SjbOHZzm4ndo3vN47Hgtuz8eiDxisN4zVftZHh
	W1XyGiVVqTuueMMPOd5OlGyGeoOvQEdUKdi3Il2hRko9Z5HKsURS6SGZYDnTqo/M
	eE4Wf6UQACIzzDcNudBTmUHxNEuz5PdrK2iL/RlD2M8hcoD+YJpMfdLyAiDfEdTz
	uO0sJoyhcu9HpCUg2oEmRXt9/OLYJyqPrwfsdwiRWd+g4lWtMqABYNzeZav8GgZk
	HA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gcgdtgh8n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:59:02 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52fb6c7b680so32670871cf.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788091142; x=1788695942; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cga6AlYSi7DCvZrZkLitELwSbIPiw2zoKeAlwpkN2QM=;
        b=WqW1+/hCI7B6V02Xka+QNMU/+Ny7CKgZJTAoxvNQ5nDHzzWCPcdonps9CmYYO6MtWf
         AZyMDS8y2ib24f5S/vO4tM0KZ032Rhy9xEAan6f0fZJRx+DpLAvz9Pq8XTkxZ+Sl7Ypb
         dIQ0v6LZT7wStbyb7bm9iTQ1NQ4OJ4Rm+2KzA4+UYk0OJ2LFg3a3Ds1ucAxevk0uyDEt
         oSccRPcc5sJxE2gU+RO4NSAq/bnh2IiV2XSF4nhs0rDHJ9s/h8gpjphrFS6KL0rbsAQy
         Fu78mhGc1S3ssW7k9H5LFB/ut/dGUas4rCUrEPxto1qdd2L+qh29VAFYMALSdAdzjXgQ
         2OCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788091142; x=1788695942;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cga6AlYSi7DCvZrZkLitELwSbIPiw2zoKeAlwpkN2QM=;
        b=srvvZEx6OAwkQu/oZxigpIIFN54zMt7w6QeZZkSZamVmWg4HdibaILQEwuUCT2XQGr
         U6wokXoFkF8uNm7KqyN3aQh9YwQFI52DeALHv8Pe/mnNeAs8I6F850LMuM8KV5NHc6f8
         hrhdpMWrLCz5s1rKuzyecMadAEwWCPjiOr6SoOxwXcLKd6Vtml4BAv8VvQj0urNCjjMT
         KIVKBuMT6W6WQ9gO7xER46Hd5pmEtwVPLEoiCqeT42Kb0e1yvujwNTLWl3UCcyDH86Yc
         PMrRTCCu09QAXHlRn46Q+dEPGm6PK0jfvXPfcjwWNg4QOeP23oH40xeCFVU5PpJd2tTc
         JuUw==
X-Forwarded-Encrypted: i=1; AHgh+Rq3ZkpM4W6S9Twl/akezkw9UiKMowqSQD/6eUxzmgtB0dlgCOhajalgit7tlWa75d1KW7Twkjj7Ng==@kvack.org
X-Gm-Message-State: AFuF++kjQxx+zxdUXjQqVBbc3IRk3TUhTDz9ZLoaXjjyO8iio4MLbzLG
	uUl7vYM8moPiGqgiL362JI2wdoM3HnH3cU94VbFAS9mVuEiaGmTHBYdJTAm9IORxgcRGdYHVmTP
	vEtIknjsPJUGQyJtQgmYevBpc/I//BoKGCzCg1QHWNxLHhbnc
X-Gm-Gg: AR+sD116FvYPixbHEzqyGkc+IdLlyd0QXnqVQoy5FAQvzs5yKoxwzxwv1l4IAuBMut8
	VENrAyqgVjtnJ/Wsnnm7md8TcHVyd63Hvp+qMh78sMQRTO70RTkq+D8JlMO9qE09/Qze4z7Z4S0
	F59f2I39PtxNCC0shvMB9dd+EdTYw20aD9C2urdsrZ5bzeCkZLl51GGz/8w+AVjZLZO5xvTiUUC
	1ZDJGLjvgVcFxJWdfGFNWvnRl6125scNduOEcWOD2Ept72YXbbWtcYg9CZtEnQ+SKIoEE115LUI
	3Z65foJlEC+9rPr6EdnFFq8XqCVqbIYJvGFBk9Fk8JiRtaPZ9ORxLCgeGDn4Q02V6OU8jjbleZw
	uxNz9qgLTPIf0ZV0+NiTJEpwq9CK61oWiGZ4O7/6r+tZcZJU=
X-Received: by 2002:a05:622a:550a:b0:52b:4e1f:940e with SMTP id d75a77b69052e-52fb93b34b5mr233768971cf.1.1788091141983;
        Sun, 30 Aug 2026 04:59:01 -0700 (PDT)
X-Received: by 2002:a05:622a:550a:b0:52b:4e1f:940e with SMTP id d75a77b69052e-52fb93b34b5mr233768661cf.1.1788091141539;
        Sun, 30 Aug 2026 04:59:01 -0700 (PDT)
Received: from [192.168.0.175] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbb32d30sm16562243f8f.34.2026.08.30.04.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2026 04:59:00 -0700 (PDT)
Message-ID: <076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu>
Date: Sun, 30 Aug 2026 14:58:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
To: Wenjie Qi <qwjhust@gmail.com>, willy@infradead.org, jack@suse.cz,
        akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        baohua@kernel.org, axboe@kernel.dk, trond.myklebust@hammerspace.com,
        jaegeuk@kernel.org, chao@kernel.org, qiwenjie@xiaomi.com
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
 <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
 <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
 <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDEwMSBTYWx0ZWRfX+DwxA+bJ4dgG
 29v81w+aB9Sg0f5SyIpWAfmY9gdBplododV/EYJdwE1Wvo+jBpST8ky3Qqad/63S6Vjqfrt1u7U
 iPvIwfg6qQ5WCwHeWhIhz8AAFmoIVKiNdJHGwQuwGn65q+H0dpYko9PRTyPzjMBSMzclDYzGe50
 Rey9sabeCF1BHfezTWm6XbD2cs1j89oDxgYueN2O5REksJgYV76dIS//ejIBykIB71e5FsDxWPW
 EN27wFKLhxj6JpF4G0DHWr2c9QSGsBrPLODNsBDVPa+eaD4exoszbE7B5HaH1PSFxtPczcweAp2
 JfpalGIRzNZetLlY4r5+A/FuCsbv8rp2wn3R5qkheim5eysh0czbfrZmUrSnPfGfCPs24r6V8pU
 9kM8b2JlrPHjCSvyaceYWSbY8/CmCltZIuvYyWlTYy5x7Yr5A0eADYFtSHuIpskQeSX1TL7LSWo
 FybAksgm/KHrrouZndA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDEwMSBTYWx0ZWRfX2UcUeMBc4jTs
 KJTXQeiy1Q11vD1YK1GAdydS8AvfidjYCpZSV5OlV7qSMLBY6BhF1REmjF9YK/b6kLVIEu2uLz3
 znqy7AI/OMzvuyRVKvnEyGAdkcmsV9ezqMo73lxYVrDwKU9tpT9a
X-Proofpoint-GUID: HBaEI1JsK6g_1yUIhospgz9oEJ85ms5B
X-Authority-Analysis: v=2.4 cv=ZKXnX37b c=1 sm=1 tr=0 ts=6a941b06 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=IeNN-m2dAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=G6hifmNftL5Xi8x2x9UA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: HBaEI1JsK6g_1yUIhospgz9oEJ85ms5B
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 bulkscore=10 priorityscore=1501 malwarescore=0
 suspectscore=0 clxscore=1015 phishscore=0 lowpriorityscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608300101
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1qp1qyu4qnoamin7w9a3tzpy1fmwbqzr
X-Rspamd-Queue-Id: C997C16000A
X-HE-Tag: 1788091143-499517
X-HE-Meta: U2FsdGVkX19HwOFXPg1EuhM4ThkVuPlqXS8HEDcSi1UKbWp9XJKfnw1IncJtSfZG7AqZyLN3zHI2cjAsyTBLFK+EsrZajn47MtxVXkuTPbkAcU2fY25/g4F/Q1E+5hVlVd9HMrgQneY1rGJZNQtH6ly8+fNerppHe3lLGt4Y0Q/qcGhwlKaPKGlhzJiXZ0ciSrLIL48mj5dp+CeM6ett88YR29zUUPRFX8BTPzfg1v7vRCWH/ep9ZgrZyXLeyqjFoJbHvtArKrsO0x3vaXlo24Af+XalMEbbBKT7KC3w/KzDhcYN/MBHb+pvOJQjMJQtrHRVUozJacQhuLKRUzhU2Hg2tmuWieyDi8uU0JsW3zv4r56CxAlvdc8g9t2pJsOh80x9mFxytkLLuhxXT51oNVqw08jSCaAqnJrClfmLcjCLG8ENfvQ9CnfBg9rsiR3HCZi77hbnTdaPz4AMvgdreBwQraS6Mbq+qZVHEp3oLWsbequWk4TtgN4UMCwzAFD33akbX1e3a+A8J/iKSuD+S7CFY3jfHOPQ5qZc5yRjH3udAbHZTAOWhAooAkZYnC18+gfXmtRBS7ODeUQkxgP85IlvnHaPoTnw/7yhs9/I27b4x6tFdnC6IEM5aGXJCBPWhMbpuAMjR8T37FP8Jnjcp/CAu1K1eIXqtEsoW66HsliH4+/keSFO4sme/m5DF/ipmbB5ckOIXdFFdCs8ai59XB7OMVv93Qqw2NdwSKsfhGpLkWJxeitg9ctEcby0GAfDh+x+vfPp2SgO81GhiIUnjTI/gR383B4ZVBKJUR5x/m7OCblsDGFjK0bq8WD+3OcnYECNmhN7tR8b7Df598WtypDfmf4jdRfo00kW5gFVLei3/LY2rFkdo1Rm+MFuikOEU75bOZoDGVgmfZFfxtvNq1xqFELARaK02RaKOgnMeAYLXgY33JN2XnfjanzFwi2iZXuvWJueuwIBSK0KnMt
 Kb3C/npP
 eVXV9G5Geq+uNjwyvj73HTYYXLZKTQ05w5qUTaodcvQENP3wSpMILSKLMD5U7ZWF/vHDX/YQZ0LIs+6SMrK7U3LS5hY+AH298AFSaup822Nqmei47IdqKnY3oE9DRLQ//VqnRhHew53FJX84P09voz0fHqU65F5lgyXyriv0XJqSbRD7k3j2Zyiuq31rwxXPozkckQCUTHhvO1Zrc/+YDYBLmUfP5LezC+HBJXbh4leCbv7Go28d0JsuhF7+8pD7xMj9hALZAJ7hXvAqokCuCAxONoIclb17tvd6N7/DjlAtMwxGqYTQExe/FkvOaWJtbFw06XuyqY/HjEbeWraiAhwAsQJhgFgkQ8mWc9Tm2KI8g5dQQU1Vhk4DMj92qFvmPeRTyTtmDv3kX/iESgqV7TvorbN31kGqXTuCqDqHtGYq+KZCXORZn4mE8Ixnv9q3PV6/jR0RAxkJ41U1OAb2f+aAVsON/JMw0lC6caxs0hLYHr26dRVemXXvkA/8iF5DnsXAPVLWqNJIjGoOd6CG5wAr7ffQCwODOWcS0DpClcvfHAI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/30/26 6:25 AM, Wenjie Qi wrote:
> From: Wenjie Qi <qiwenjie@ xiaomi. com> Fault-around can map ready dropbehind 
> folios without going through the normal page-cache lookup that clears 
> dropbehind. A mapping represents a competing cached user, but writeback 
> completion can currently
> ZjQcmQRYFpfptBannerStart
> This Message Is From an External Sender
> This message came from outside your organization.
> ZjQcmQRYFpfptBannerEnd
> 
> From: Wenjie Qi <qiwenjie@xiaomi.com>
> 
> Fault-around can map ready dropbehind folios without going through the
> normal page-cache lookup that clears dropbehind. A mapping represents a
> competing cached user, but writeback completion can currently unmap that
> folio. A later mmap access must then fault it back in.
> 
> Retain mapped folios instead. For a mapped folio,
> folio_unmap_invalidate() can call unmap_mapping_folio(), which takes
> i_mmap_rwsem and may sleep. Retaining the folio also avoids this path when
> folio_end_dropbehind() runs in non-preemptible task context.
> 
> Unmapped dropbehind folios continue through the existing invalidation path.
> 
> Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> ---
> The mapped-plus-dropbehind state was reproduced in QEMU. The patched
> kernel retained the mapped folio and continued to evict the unmapped
> dontcache folio. I did not reproduce the sleeping-in-atomic warning and
> am not aware of an existing report.
> 

I was able to trigger the sleeping-while-atomic BUG on current mainline with
some help from Claude. The reproducer itself is straightforward enough, but the
configuration was a little finicky. The atomic context comes from using
threadirqs so that virtblk_done() completes requests from the irq thread under
local_bh_disable() and the vq spinlock with irqs off, so in_task() is true but
the i_mmap_rwsem down_read() sleeps. It also needed 1 vCPU (so completion stays
in the irq thread rather than softirq) and ext4 -o dioread_lock (so end_io runs
inline instead of on a workqueue). With v4 applied the bug is gone, so:

Tested-by: Tal Zussman <tz2294@columbia.edu>

Full splat:

[   46.745106] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1573
[   46.745183] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 61, name: irq/40-virtio1-
[   46.745211] preempt_count: 201, expected: 0
[   46.745233] RCU nest depth: 0, expected: 0
[   46.745292] locks held by irq/40-virtio1-/61: 1, last CPU#0:
[   46.745324]  #0: ff1fce9901fc2f20 (&vblk->vqs[i].lock){....}-{3:3}, at: virtblk_done+0x56/0x100
[   46.746801] irq event stamp: 1585
[   46.748015] hardirqs last  enabled at (1583): [<ffffffff88dc7c54>] finish_task_switch.isra.0+0xd4/0x360
[   46.748224] hardirqs last disabled at (1585): [<ffffffff88e2b16c>] irq_forced_thread_fn+0x5c/0x60
[   46.748405] softirqs last  enabled at (1578): [<ffffffff88e2b159>] irq_forced_thread_fn+0x49/0x60
[   46.748580] softirqs last disabled at (1584): [<ffffffff88e2b12d>] irq_forced_thread_fn+0x1d/0x60
[   46.749233] CPU: 0 UID: 0 PID: 61 Comm: irq/40-virtio1- Not tainted 7.2.0+ #5 PREEMPT(full)
[   46.749323] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   46.749472] Call Trace:
[   46.749552]  <TASK>
[   46.749653]  dump_stack_lvl+0x66/0xa0
[   46.749747]  __might_resched+0x154/0x260
[   46.749787]  down_read+0x1e/0x170
[   46.749806]  unmap_mapping_folio+0x74/0xd0
[   46.749854]  folio_unmap_invalidate+0x92/0x200
[   46.749886]  folio_end_writeback+0x51/0xb0
[   46.749906]  ext4_finish_bio+0x36d/0x3a0
[   46.749979]  ext4_end_bio+0x51/0x140
[   46.750010]  blk_update_request+0x101/0x4d0
[   46.750045]  ? detach_buf_split_in_order+0x18c/0x1b0
[   46.750098]  blk_mq_end_request+0x20/0x130
[   46.750135]  virtblk_done+0x75/0x100
[   46.750173]  ? irq_thread+0xb3/0x2a0
[   46.750190]  vring_interrupt+0x8c/0xd0
[   46.750205]  irq_thread_fn+0x23/0x60
[   46.750238]  irq_forced_thread_fn+0x35/0x60
[   46.750261]  irq_thread+0x17c/0x2a0
[   46.750274]  ? __pfx_irq_forced_thread_fn+0x10/0x10
[   46.750299]  ? __pfx_irq_thread_dtor+0x10/0x10
[   46.750333]  ? __pfx_irq_thread+0x10/0x10
[   46.750353]  kthread+0xf6/0x130
[   46.750369]  ? __pfx_kthread+0x10/0x10
[   46.750404]  ret_from_fork+0x248/0x350
[   46.750421]  ? __pfx_kthread+0x10/0x10
[   46.750442]  ret_from_fork_asm+0x1a/0x30
[   46.750585]  </TASK>

[   46.752964] =============================
[   46.753047] [ BUG: Invalid wait context ]
[   46.753230] 7.2.0+ #5 Tainted: G        W
[   46.753353] -----------------------------
[   46.753438] irq/40-virtio1-/61 is trying to lock:
[   46.753533] ff1fce99004e4990 (&mapping->i_mmap_rwsem){++++}-{4:4}, at: unmap_mapping_folio+0x74/0xd0
[   46.753882] other info that might help us debug this:
[   46.754000] context-{5:5}
[   46.754062] locks held by irq/40-virtio1-/61: 1, last CPU#0:
[   46.754171]  #0: ff1fce9901fc2f20 (&vblk->vqs[i].lock){....}-{3:3}, at: virtblk_done+0x56/0x100
[   46.754371] stack backtrace:
[   46.754441] CPU: 0 UID: 0 PID: 61 Comm: irq/40-virtio1- Tainted: G        W           7.2.0+ #5 PREEMPT(full)
[   46.754656] Tainted: [W]=WARN
[   46.754725] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   46.754887] Call Trace:
[   46.754942]  <TASK>
[   46.754996]  dump_stack_lvl+0x66/0xa0
[   46.755082]  __lock_acquire+0x92e/0x1a80
[   46.755197]  lock_acquire+0xcd/0x2d0
[   46.755282]  ? unmap_mapping_folio+0x74/0xd0
[   46.755403]  down_read+0x42/0x170
[   46.755476]  ? unmap_mapping_folio+0x74/0xd0
[   46.755565]  unmap_mapping_folio+0x74/0xd0
[   46.755664]  folio_unmap_invalidate+0x92/0x200
[   46.755763]  folio_end_writeback+0x51/0xb0
[   46.755851]  ext4_finish_bio+0x36d/0x3a0
[   46.755958]  ext4_end_bio+0x51/0x140
[   46.756043]  blk_update_request+0x101/0x4d0
[   46.756135]  ? detach_buf_split_in_order+0x18c/0x1b0
[   46.756254]  blk_mq_end_request+0x20/0x130
[   46.756349]  virtblk_done+0x75/0x100
[   46.756438]  ? irq_thread+0xb3/0x2a0
[   46.756515]  vring_interrupt+0x8c/0xd0
[   46.756595]  irq_thread_fn+0x23/0x60
[   46.756678]  irq_forced_thread_fn+0x35/0x60
[   46.756768]  irq_thread+0x17c/0x2a0
[   46.756842]  ? __pfx_irq_forced_thread_fn+0x10/0x10
[   46.756945]  ? __pfx_irq_thread_dtor+0x10/0x10
[   46.757045]  ? __pfx_irq_thread+0x10/0x10
[   46.757136]  kthread+0xf6/0x130
[   46.757207]  ? __pfx_kthread+0x10/0x10
[   46.757302]  ret_from_fork+0x248/0x350
[   46.757383]  ? __pfx_kthread+0x10/0x10
[   46.757466]  ret_from_fork_asm+0x1a/0x30
[   46.757594]  </TASK>


> Changes since v3:
> - Describe the forced-unmap/refault runtime effect.
> - Record the reproduction boundary and add Cc: stable@vger.kernel.org.
> 
>   mm/filemap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6afec636881f..00fd89cf6f55 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1616,7 +1616,7 @@ static void filemap_end_dropbehind(struct folio *folio)
>   		return;
>   	if (!folio_test_clear_dropbehind(folio))
>   		return;
> -	if (mapping)
> +	if (mapping && !folio_mapped(folio))
>   		folio_unmap_invalidate(mapping, folio, 0);
>   }
>   
> -- 
> 2.43.0
> 


