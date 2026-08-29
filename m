Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CDB9C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 19:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2CA6B0099; Sat, 29 Aug 2026 15:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB356B009B; Sat, 29 Aug 2026 15:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9931B6B009D; Sat, 29 Aug 2026 15:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 720AB6B0099
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEDC11401AB
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:32 +0000 (UTC)
X-FDA: 85155245784.07.58B5F80
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6882D4000C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=q78TxGpU;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=bbfiRSlf;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788030570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qd8cecCELFD5bdWPS8BkzXqz+Y6D30q+8Og+jFoSTy4=;
	b=1iiju/OT1qp8vGBTiy5LaVkIfSUBYyA7vCDY6JeoDAB+NvKx24xQ8uxTR5i5wom7PCtMUi
	4PJFB9Ri9y7wQH3wsXKv874A/BLEndepwUtQNAtuNcVg5hXXsw5XvIds1irlRGVYiVxIc8
	eEMxR1x3othxsrkcO80EoaV4CsYUz2E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=q78TxGpU;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=bbfiRSlf;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788030570;
	b=NfiHDa2w0sOOh6U4yo/yTeSrcaPAcScwiW3UUDfFX5lNXGZ7MOkPaBTW08/bjT1xpFySFn
	Zmy0PydmOeRR0OQot707SPMTYhnbWm6oePtmqS73H90LpsCKqFApJf7m2kizRGQFko3f/z
	VJh8a+goMqqCGrfLYEtb0K/ObsHt53I=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TIhe0S1266207
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Qd8c
	ecCELFD5bdWPS8BkzXqz+Y6D30q+8Og+jFoSTy4=; b=q78TxGpUNktCCwYYDZWa
	B6x739MK/D/w2tDFAhYlffntu1bm0LIrUXNEgo5ieW/SRpnx60Zbb+L031/dldzc
	uuFph98K+q9OPb1UqpecJZKQxKzIJlLPMLRDodSUtovneH6CKtX/LuhA3fsqnsCt
	fhPbOJYsxs5rwhjScQcZ4ml51hwBxDOoUrqPRnnNP8CFFOShS91075NSkboyBPo6
	B1NsQ9DqpuIrs656RgEPv/FeCOu5dFNXdv5QJOEQk7CnMBhkIdqhdg8V2or+GrWR
	s5rpFyukAdoQJ9vPZKdq53dCsTE0ks5e/slVyRkMuxykIeJGEmGPqoGCnNG6BJNZ
	7g==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gbukp2rg7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:29 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c0e702df8so55366661cf.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788030568; x=1788635368; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qd8cecCELFD5bdWPS8BkzXqz+Y6D30q+8Og+jFoSTy4=;
        b=bbfiRSlfQUZUpaB6Odob+mxP7rs7mLs1r9825UGn8TpfBI3HPnLbXnC10x1bFUlrwn
         Z+lkl8NL69dxlgdj2VAnZxNRGqpI7hMmu2Jmimv6jE+WHXk66tgwaFYl0zXaWKN65JD/
         heCiOMS06FziWjON3s7uW/GdU1uiOjC/oH0ylcaqOYXCwozoPGBITE2w8zrqJg9e2XPP
         csX2bi4uIDpctPovXMv/UcOp0wM7BctHtVdPUpXQm2u3yIK0HfvYw/SeGYIE5JQMGPAR
         QgV7CN+j+MfyWe/tP/XZc2QSOWFE9ifn8H/OeuXHiXuAwAJW57WnI3aqwg/uU7wRQT2+
         k4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788030568; x=1788635368;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qd8cecCELFD5bdWPS8BkzXqz+Y6D30q+8Og+jFoSTy4=;
        b=UH54PSQvaVJ6hJdtuqtSSojMbiwx9FW6o1d2JVnBsxYJeDTNb0IYNIaJvUafwzZYOD
         zbzWjujvHyggUskhMqQ3pjeRtDcBCXTUTOEARGlgGlskhzOcs39QSLyZh+pWaqIf3pku
         qLX6TeB1zgb39qYo7oUpcjFCRkSJRNAHhq8u12cAlSGoMCWwmgZqG0mOWf9nZLc//xkx
         oRvDptht5+YJcLhv0cggugiMpQFZ+hYU3Jm4TMJDOPMyBB2bwOMTbBbJ9/ctCBivdQSk
         b8TkTQn7hdhrZyu9c0QSrrjr9wx5WUrdfzWTMB4/ZdoYu9DjBuBIecXlZImLyBGOSYfc
         9W0A==
X-Gm-Message-State: AFuF++m8DmH/Sc1vmI5sf8FnswafX7z1OXYcuBGN9LKmEwwkd2JWNEdq
	QxN+825x410JDtZdpU6Sw//JEJmVuNmNheEvEnTvHY9EBy1vS5T1Apvvt/v+nU3xV86eGGyRoDy
	CVMLic4rSvW9yvKDo/j1ZjsqJlq/F6zsvsd3ietdwRH7hp25w
X-Gm-Gg: AR+sD10sHn3Z5JmYdvb8uxzL4glwPwO6Iq5zpIDlqlKRc8IfcNJ+g/jS1X0BANEGOgL
	ZB2YmNh2hkz7y9MHQTwo/YM6o0gtoMYZ4KUWPkl15fEsZYvVoYuG5/D8H0w+47E6bfl0ve0hSOF
	CTC76cSPDaKUO4g4SNhXSDTTB9dhftSaptO5tRcruj3bRj9xGqpurM3vi078U7i7C2uiy+cowrF
	TE9Z5QmMDMyQ5cqY/UgxGsKd2Sjan0Oq/sEj1VrIASEvHXs9z2kEwTOLjuEW8T0xT+WrO7C3zlg
	Wlx6CZjcVOrc27IqoaXEMaiKOCaf8tUtbMS/PtdQ3cKlP8PBnrSSWi5rqXHnCKTX30j7OewwdTY
	qTrE0RcRE9BgyRzImoJSsXxPFAJxCCz3F2BTi7hGTTw==
X-Received: by 2002:a05:622a:60d:b0:527:43a:2f31 with SMTP id d75a77b69052e-52fb9406840mr173558871cf.15.1788030568260;
        Sat, 29 Aug 2026 12:09:28 -0700 (PDT)
X-Received: by 2002:a05:622a:60d:b0:527:43a:2f31 with SMTP id d75a77b69052e-52fb9406840mr173558331cf.15.1788030567802;
        Sat, 29 Aug 2026 12:09:27 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b963c3c0asm239150095e9.10.2026.08.29.12.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 12:09:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 29 Aug 2026 15:09:02 -0400
Subject: [PATCH v2 3/6] mm/page_io: use swap entries directly in zeromap
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260829-b4-page_io-folios-v2-3-649728091117@columbia.edu>
References: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
In-Reply-To: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788030553; l=1980;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=3mETznkI5OH7f+YXwonxhIQNBhySzPV2vF7gnTTFy6I=;
 b=qT2xa4TBuFq785SRkjS6czWfdHiCo+8CrJ5OYkcXFJOK+hO5vVuW7nLuEhFRSMSTgJZRv7qa7
 SjUMIiZXOi/B8ZL0k3knMQ5cuM36lRhwSnNOk1JHm7uSWhvBn0N5zlL
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: tcg9Y2hwvuzLMClvNDvdrpr8Ej1W7NeC
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX3LS6ce9rb2J7
 hoBWoRHyl8SjohagSbqdcLt7WxKIU7D5RWRwcgALuXy1pcDWXavxzbOXdCCvCl8JvFsjNcK0Pzb
 fHR9gTNAJ3p1QLDAn3XAtVddVhEW4RYjOcVjIR9UXYVgFt5sZU7g
X-Proofpoint-ORIG-GUID: tcg9Y2hwvuzLMClvNDvdrpr8Ej1W7NeC
X-Authority-Analysis: v=2.4 cv=R68z39RX c=1 sm=1 tr=0 ts=6a932e69 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=ufHFDILaAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=HViwNVsgdNRDn9LUnL8A:9
 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22 a=ZmIg1sZ3JBWsdXgziEIF:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX+Y5/8ljqwZtk
 bOahxV3X5y1Q6KpoJvBvGFq4ZxijA90lzrQi7oPSi/ZfU0B+a+HDXheEKua0+xGolDb6iGg/DMe
 HKuBOQ+dJpBbJwLo6hTCdXDJ2xDzxtzGfccisLmgxhWHKRj5cijx/XRySEeWBts1LnTUT73Zyk2
 5pt+tyh/VeXlBANztwjeCkfBUFgPmkRMggGJBFszIjp9YtEpTRiCshbtGVUGhLjcSpNj71ECXXH
 NUKYZT6Aoy9uQ1YrnbtcUlsUQtNgs8ZXefZ56h3dVdaDg0Bi9jIYSWy3QdxBux21kHnmhHfwupR
 qUvmIEJvYS9ThDjUl4FnNHvcs5+QyqJJ4pFJhqPAnWeVjLx8iBh5ueZVd3ZOPjgzrvJQ2izGYji
 rfvhObwr3AAaT+wHTsAhUucTBORRbw5pX3uxUTCXEPUJ6FhBXYce8aIYvHhaGVt4YDjNQjHv5jd
 ae7/BRDBo37DPUupIww==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 impostorscore=10 adultscore=0 spamscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290165
X-Stat-Signature: 71tffuqxf8rbdh1wgz5rey3xukfnzdop
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6882D4000C
X-Rspam-User: 
X-HE-Tag: 1788030570-172085
X-HE-Meta: U2FsdGVkX1+GSXFjJhUlvVrXjXa5noe9KpL4DATbi6up021/Xutk5VOQVg3B6rjYFhw8kO+NrvZi8LCKTYvzxMVcI0z3TMS1mFki+zKEcmCClaFWyNKxqOhT5MOIXqJVX6OXDqn/LWwTa6SgYGioQL21SWScmFZnq998hew1fQrWzZUQFDyYg6GH0i196rcZVjafkPeRigl3uUvN3Rk2W3vRAWaep41/GoKbpa0E0VnEffFK4VDAHI9wN+2iX9lL5Q4c4gnQS6HFNI/60rBR//9g9omABS7u1tgFFcdGDR9Kbl91fE8wPolbP5nJ92hvHKTQ+fJcpx6S95iGc2eym7abqlGaa72C0BueDh6nJ0kOqqOcs92pufk6SagJRCfGQofpuZUG/RDwQdgtmFY7InLSOjN7IpNReJlWRyM1eiZspXq8UsIXBlThK/r3Y6ifSKRfa6K/zb6Km1aqXg1XC8rkiqHvaI5XuPfW6Qj3FMfKMlXXbdD8IuYo0CvT8Ca/Ihk9KQqfvdikA61F3wlsJ3heENCSedRZ6mKmL2VPlKEaHIpYs0j1xmXtBPv8pjvN+bpwsvfgly8oNPNawnRBvr+AX/YAFYaxm3KCVU0hRc/CRE6hBjaauPXtsYAf3EzMnHbE0RIeGstj887rY7v55ipNDF+ku3sZR9A0aHzKdDVeGSeVcj8u61JlFp7NzLvg6r41f9Rd/wHvoco8s96phXqFXOHAAhies5TDbSe6chMSvX3Oy2KKVMm5MKoougtz/zmQBFqaKvjh1SCxJw8JiknwsD9rLtJT8gMvpA+yEtlbMfOXW5WdtlZVb4fL50ow29qFRhCFUU6qtYV/fHQtTZSQcXRGfHj+A3cwphuM5NZTh8ss4EFXMI+YKaUCVvLwPVULZarlqbRaBGhIG1oNs559xohI1xQo6pbKXbJvI/sjC7rM3SnfxMyIeLfdiJ7wn4zdhpeARzoxmP++xeF
 NZVpeqIC
 cj/JPgjhnxE8wpVTjVQpSEOPstOlHixYzr3X8i5CR14jfNqm8qqe9YrdUM4IUMmdWU6H4UCBFKFTBh+6BW8ep+Ipzbmk3Jx7ECl/it+YxomkyRtrkKeVFsdlmI+SP35LdEakOO3k84JvaOXSyrao0lzj8o/leM+DeUVWC9ejvkW6J3uAnwrPtX570VtSGJL74r79LEtj4xgUY/5qgrd97TK1kQALbFned1+snTghcJ5JljoRzSGLxP8DLb+2P7zx0Vhvwo+7q33iTtTgz0lhrZjiZPNLcCGdDbL3f33gSnY3aXy0EVuP5K4Vfd2oOv1uOlZC4zhCfP+LbEfRzi9Q7hJjOl18Mroh+BTiU/i4ZkWrwJ+MjVMQTrn2ju9WQqlkXo9E1SxvS9qZTCW3YaTuhRPVUK4qyzDOM4K++VLcymnRvXPeApSd3xn5dvYwX09yTfZhuy4OIcEk252qE/LMi322cqnNXHrx8V/29rPIhe2m8lih9qohHgFnUhJFcHcsUKhjCRY7NCYO46GtAGBOLdsOoIUXOzN4vKYpmU0LvKyywhRCoT3dizzaDEkugfw74jbuB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Increment swp_entry_t::val directly instead of recomputing each entry
with page_swap_entry(). This removes the last struct page usage in
page_io.c and saves one call to compound_head() per page.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index fbcf58ff292d..dd95cdb0cd7a 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -160,7 +160,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
 	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
 	int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
-	swp_entry_t entry;
+	swp_entry_t entry = folio->swap;
 	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -168,8 +168,8 @@ static void swap_zeromap_folio_set(struct folio *folio)
 
 	ci = swap_cluster_get_and_lock(folio);
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		entry = page_swap_entry(folio_page(folio, i));
 		__swap_table_set_zero(ci, swp_cluster_offset(entry));
+		entry.val++;
 	}
 	swap_cluster_unlock(ci);
 
@@ -183,7 +183,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
 static void swap_zeromap_folio_clear(struct folio *folio)
 {
 	struct swap_cluster_info *ci;
-	swp_entry_t entry;
+	swp_entry_t entry = folio->swap;
 	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -191,8 +191,8 @@ static void swap_zeromap_folio_clear(struct folio *folio)
 
 	ci = swap_cluster_get_and_lock(folio);
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		entry = page_swap_entry(folio_page(folio, i));
 		__swap_table_clear_zero(ci, swp_cluster_offset(entry));
+		entry.val++;
 	}
 	swap_cluster_unlock(ci);
 }

-- 
2.39.5


