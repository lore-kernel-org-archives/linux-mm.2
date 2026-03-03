Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 575ABE67A9C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19706B00A7; Tue,  3 Mar 2026 03:52:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E11A6B00A8; Tue,  3 Mar 2026 03:52:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2D56B00A9; Tue,  3 Mar 2026 03:52:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AFCD6B00A7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:52:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01D351B7295
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:52:47 +0000 (UTC)
X-FDA: 84504136416.16.3DF4E25
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id AFA2740004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:52:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="m8LCE5/G";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ZveKXXDB;
	spf=pass (imf17.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772527965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNCoDF0Cx477EaFoLRXf9AP45l0gNVgmAcjZgp84zKw=;
	b=572dqO0STN6clAOYCnuw1cNQbLubxq697CIj9RspzH6UrbqnFQn1JpA9vJYJwUGAj1twyh
	PcPjUwK4+geaL4mF5M5tiNfig5TJG2zgWG1GoWk2q1n6NlPLl1Hy7y8AUD3Kzba+tJ0xfI
	YLHM6Rc3kAN3zX40EP3+2YL5miGW8YM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772527965; a=rsa-sha256;
	cv=none;
	b=t853jgwIGx881D7nhlOEipv92nFG6cqEK+o1iF1Zd63iCV61zPaDHrMf+5oIreqg0MUkAo
	c5KZhU88E72dsm8oWyxxwX5qhy+rj+kozxRGuaTE5w86m/bnTOQT2AsF/Q+JKT2kTRxJDr
	FDNaUFMaorincOtWU9X7yHEfC5zy7CI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="m8LCE5/G";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ZveKXXDB;
	spf=pass (imf17.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6234oOgO3862874
	for <linux-mm@kvack.org>; Tue, 3 Mar 2026 08:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=YNCoDF0Cx477EaFoLRXf9AP4
	5l0gNVgmAcjZgp84zKw=; b=m8LCE5/GG26H7daYOSgbqY8Xg4ZNKzApJqvYus6K
	SdQMGPTDn5gNm/wBRQKC3x9wD9ZrYTDIDJFWA9iK1r5vHasFbIS9dYc9+LqN7Nx1
	kUHGHzp3AaFc+C3DQJuxvftRVKKz7+8UnR3sJlRyXv/510mKsSihs/k3RzbQG9ER
	Bo/rTLuUWmKs3i2rjIHmPmw8CbT6iiyqlVXMq3fXTkNd4KcA2YDYqIAN9PS8VQ7q
	NCJT7OQT7lIuMPOWHe9bkJ1raNCq8FSxRq91AWiA7t17uDOcmYqRVFgNg4i7mkQq
	Mb1OwaTxGfvhD0zBjEegsk/B02RZO05M1dwqQhOEIir8Bg==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn9bjm153-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 03 Mar 2026 08:52:44 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4639e1fedcbso61244868b6e.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 00:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772527964; x=1773132764; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YNCoDF0Cx477EaFoLRXf9AP45l0gNVgmAcjZgp84zKw=;
        b=ZveKXXDB5qyUYk4EmQ/lmgXjPpXf9kOjEHhSHrI3vsprBqDAz7gyAaEDzsWi+pTktj
         lxr1Q+B4RPRQu8loY7tS6cpZW2+DQDB8HxCa6sjEhFiysguOS7ZqMTEc8fN8TFJgedmk
         7sknnXmnzqmiT77+yz+dSqB3Kv3wmec7O9qE4S47dqGlOOC7KWLgrvQNFgiZZp8E5Lcf
         iAzYBx8097NUaVaAYUtCKDUeChFcDGP39WedN5VKi2FAZSHWWRQc8IBXZEdIRyzBvB+w
         GGRk8YjdO/NomF4OEGrYQapMG5iHJGa1HHliAsdMxOpkjp81GkM1vhq/w/AJDr0rXBfM
         gJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772527964; x=1773132764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YNCoDF0Cx477EaFoLRXf9AP45l0gNVgmAcjZgp84zKw=;
        b=Ak0pugKYfoWcTb/57gPq91SbAGhQ1pFhjUXMoKGRgwizxEZhBBNEqvk51ANwk6QT6B
         AMcHOcqKetBhDyyGGseLvgg+JiBlvQ4RfdDmQOfe1ZvkJfBBmw3dIiro/rgMH4dATUFr
         Hm4Y3VYxiBzDuLhxymEQduz9GqpoyIK+/HsyjzPC1poWRpH+3VfupmoTzERMSMMWWkw3
         ffd3tw3i4Gp/XipvEIN7F24RHQovO7gJT1g+qwn9Ij7fukKVZuTvN77PcwoViSlrxvas
         23IRvY44fBvX4wG5oTno917ELSUt4tlGwrbWwdrSK00WdVac6NcD2JbZOwTTkYaTxhl/
         7lHw==
X-Forwarded-Encrypted: i=1; AJvYcCWMuL4KBAd6kIWjWDi9mkFpKi33IsE2yiP9oLqSNJSoBke+ORMLIzFJQ6M4ZoGCpY2kTsOZf5RT1g==@kvack.org
X-Gm-Message-State: AOJu0YwmpUMijTGQqZMPAuePHWGxIqq5rXS4f6vPR7GnpeXdKMibOGCL
	O/owAy6d4VDGylltU0iqYTu/pixKCV8RN6BBRdsl5Rbrv+hPcy7KUtvZn/+XwTo8dXeIwxcnm9U
	oyHi5V3b926okZgMI5egDskJQwHGx90yrA+UaQUcJG9OWMPWLVP9htg==
X-Gm-Gg: ATEYQzzVgv5l0mRKi1UqsaylVvYS/1yQ+AWO5V5zy8k6JVgalZ/i7Xk9KHNS2YuaRrO
	AQO+nenI+OJLFwh/EeMbedTHyTisFZfGfHF6pR6+SfnR830PElK6yc7qfco2q7mRxtv/Iwdut3V
	ZHxbKMdF95hIHhy28NulZu8qpRkDu8V4+5tk/o3gFRpR02iQI7br3zeU5ZedH0cs8sb0qHYArsy
	qXg326eNIEqYhwM04HGuSrDz3xHjbA1+B9tMz5hho5F3Wr/ZamM8fx5MRrdGOWXCcZS24drBQ7h
	hEUuLW950Q1/MVJhYY4gqrEQp9qeg7N0f8LdjdIPeSKslun2Vxojx/S3r2e55+hHti6fC1xr9fW
	sb0g2PQ30C19ujONte7Wu8IpuDNhZPj4DsqGdBnA7tWZwgFGuSP4gsRs5Zmdk0sHXoBksaHoSe3
	rX6dpL
X-Received: by 2002:a05:6808:c412:b0:45e:e174:d07e with SMTP id 5614622812f47-464bec22949mr7968572b6e.3.1772527963984;
        Tue, 03 Mar 2026 00:52:43 -0800 (PST)
X-Received: by 2002:a05:6808:c412:b0:45e:e174:d07e with SMTP id 5614622812f47-464bec22949mr7968567b6e.3.1772527963596;
        Tue, 03 Mar 2026 00:52:43 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59be78sm9432983b6e.13.2026.03.03.00.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 00:52:43 -0800 (PST)
Date: Tue, 3 Mar 2026 00:52:40 -0800
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, mst@redhat.com, jasowang@redhat.com,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, linux-mm@kvack.org,
        virtualization@lists.linux.dev, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
        eperezma@redhat.com, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com
Subject: Re: [PATCH v2 1/4] mm/page_reporting: add
 PAGE_REPORTING_ORDER_UNSPECIFIED
Message-ID: <aaahWAWkXTS1lae+@hu-ysakshit-lv.qualcomm.com>
References: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260302111757.2191056-2-yuvraj.sakshith@oss.qualcomm.com>
 <2f14572e-e02b-4bc5-abd2-7814c24f7905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f14572e-e02b-4bc5-abd2-7814c24f7905@kernel.org>
X-Authority-Analysis: v=2.4 cv=Pe7yRyhd c=1 sm=1 tr=0 ts=69a6a15c cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=oZke_92Gw2P4qifsOy8A:9 a=CjuIK1q_8ugA:10 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-ORIG-GUID: WhXjocUDre4iMjATHR9w84oYlD4Uoaam
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA2NSBTYWx0ZWRfX+4dG3cwf+DtE
 DY+QEJns+yA0+5RHyaoIWuZSMiWWOAAbb94tJAvQFiwXbrrkO10Vin2Ykl9+u4x3vxgQ4kg/Ekb
 z3EYVj7VuAXr/DUAPb0ELCFGY6roFX7lfqGeQG+2g0yy5t+UCvaJQcAMNrzXG4UB8ATzBRB+rGP
 ZFJGquFXKVP5XdBfh5FGvzyoJLUZ0sIdYc1HR0mdBLKYBnOFGIAKLlbO5/aORuHqb8o5pXBP3JO
 jDwFA1EA2hDzTI3gTaRW2N+QGUZXhRI6gN0gpRZoznSP7a4FLiPha54L/PwQwSGX41iOsADrcX9
 mAiFm7Q9mLmnu6x6hksHkrcX47pFWR8V7796TWmqT1q1OzSg1IIW9tLuicK86xx8T1XcwngOxzY
 L8mKM6bLJ4nr44d5y4KrsOrbA0MPgNuN1XXrY/XN6MbeWQE2zprq+dCHi1qizV1PW+VVLYYWQ3W
 +l3Us8lee0KRs6uSamQ==
X-Proofpoint-GUID: WhXjocUDre4iMjATHR9w84oYlD4Uoaam
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030065
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AFA2740004
X-Stat-Signature: rdbwzdw6ho4spd6o5b97gpeogyigmqf8
X-Rspam-User: 
X-HE-Tag: 1772527965-245817
X-HE-Meta: U2FsdGVkX1/RKLFz3z6UDV0rg/7WujIobPmxNde+AjLR8LD84sEZN6tU3XEmHtQfDPRI666JDnf+UI17mvRQyXtfP8ZxSw2ZpWq1WR1Y+YuDIq2n9I2yA855ggQluf7pslrfUkC0efNeIGiRfW5xpRQyF3urcZoUlTk+37gAwFB/XxCzODytK79e0t9tf22xlRHtaYGe0LsOCVwxKOuMZ6rd0cnU6oQcBu4IBFeTD9lzNMMRrkQHSBTnBAvIJ2e7a1/+30IkjaVcl+uDAOXYhT1aHqVQg81UCNb5iAOQrWnu9vGi3j7MP8fwxy0IySqZr1DX8aC6vjnSlFOWvU9emgcVQTAXpLdSY8BVjUgGy4xQY44pGLBCtf3mSwNDUW5r7EAXBvgrtD7LR8Xe9TRB3nlRtsGzTDpcw/hkr3EAAsGhRX7W8sJ0Ynjv5NLLWzMtYpSctCaVT/kC+b4DOax4bwvekOtqT7bg19LUvhwnhg6DV20hQJqTq9B0hcIi+b021ZUidto3l2GKQeXg1AGxyxQD46TcISSpBUmBF7sPUckVevkL4ZuYyduesciTV4fKcfpuUYnM2EAwQgKsrdYKdxCWeZQk6ao1pE23MMp8q2te2/5ZsRK/3YKXdM5I98J6vgxudXrxL3ySXgPHLYbJy0mRodizAXWMZCAyXvn99omYvD410whk1a7e1m8r5cPiJDoMYlXWlbBI7jheV2afc/6OZQIflD9+pMoRwvUGqPe5SvcR634bPbchfPuFMRkHgvedBUoZMsZ+eclrOd17UF+6fK2HcYXMWDFKvse/uDSsuAcLlGGGo3yJ1NYHTRSrCyFD7ku2q6Fz9XcVb4lLPEtsRegBdcURpsy/Y4afoBqI6wOYffglvm7hANSekgPzl/mY7Cxzj8wPgCMnUEi5taU1fqCN7TjWKnK3Knpem2/Hu5ci0w2yeCI0xKD26sqN/xlGEJcICgf+M0cLVph
 XeUqR60R
 rVHRhCAM7QxaXr+NSLSgB/17nOEE5i6r8vXqP1qo8t2qVkQT8JJJxIKseW5rI+GdlyxieFJXHMJFQZXccqULWczNcAPkSkluyTu1wOiUNKxdvfS8jsx3iqGUfGzml4N+AKbuhmv/eps/+3lKPilrNhMtWpNE/iBJCPR3eQQmqG+j79AUWpV46SnQbi8Zc1Ml3+hAIeCnV76U4wsNLq6uRIEtbvhB5vV0dryFiagX1nWBdfzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 03:57:50PM +0100, David Hildenbrand (Arm) wrote:
> >  /* Initialize to an unsupported value */
> > -unsigned int page_reporting_order = -1;
> > +unsigned int page_reporting_order = PAGE_REPORTING_ORDER_UNSPECIFIED;
> >  
> >  static int page_order_update_notify(const char *val, const struct kernel_param *kp)
> >  {
> > @@ -25,12 +25,7 @@ static int page_order_update_notify(const char *val, const struct kernel_param *
> >  
> >  static const struct kernel_param_ops page_reporting_param_ops = {
> >  	.set = &page_order_update_notify,
> > -	/*
> > -	 * For the get op, use param_get_int instead of param_get_uint.
> > -	 * This is to make sure that when unset the initialized value of
> > -	 * -1 is shown correctly
> > -	 */
> > -	.get = &param_get_int,
> > +	.get = &param_get_uint,
> >  };
> 
> I think the change to page_reporting_order (and param_get_int) should
> come after patch #4.
> 
> Otherwise, you temporarily change the semantics of
> page_reporting_param_ops() etc.
> 
> So you should perform the page_reporting_order changes either in patch
> #4 or in a new patch #5.
> 
> Apart from that LGTM.
> 
> -- 
> Cheers,
> 
> David

Sounds good. Ill add a #5.

Thanks,
Yuvraj

