Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BB98CDE00E
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 21:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DFD46B0005; Thu, 25 Jun 2026 17:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 290D36B009B; Thu, 25 Jun 2026 17:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17FF86B009D; Thu, 25 Jun 2026 17:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D99B36B0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:21:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E7738CFBC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:21:10 +0000 (UTC)
X-FDA: 84919705500.06.779BD8B
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8ED63180006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:21:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=LGdYDv07;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=e1tX3Oxb;
	spf=pass (imf06.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782422467;
	b=xN2BIMyRZXcaP2PJODeudHpNq4MiHGT9qCAOXp3nQrs8eorkJp03WeVKlt6fxSxZeUwi38
	+GTAzGw7qVJZ9eM/uEODlqeu3BvAgIeSX3b6FQd0ONP2xDdA25wtRfD2kkZ1uGt7ZP8j1G
	yulEPgXAVPtVKCmWIdt8+w01T35e7wM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782422467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDBSl4oSawDBGp4EE+DhIVEqti8kBgTQJq6hOPS71dw=;
	b=w1tfxRXTHeySSRZKplcqqJL7xyCN0XIocUrfd1BXZkRELzYMD/35Z+HjGAVLGldhBWSMtb
	ELPfJAcyCgnkC5f/EfW6RpQWVKnKPjHCPxVHzrgXj5yFLfMkqjXS3FjaEA6odzO+at1y2r
	y0ASf2p/KofwzWfJtlogeGG9/199qgQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=LGdYDv07;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=e1tX3Oxb;
	spf=pass (imf06.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65PFePAE2801847
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=rDBSl4oSawDBGp4EE+DhIVEq
	ti8kBgTQJq6hOPS71dw=; b=LGdYDv07oS3smIKoER9m6aduJXoqyAnh/EuRW3kA
	k9kaipZ92UNfdZJ9bGDoJzFMkst66AkQlf7OQ9jbNHqbXgG5hoWI76fUW5fg0EfB
	uOPqdHmZ5VKXVCGliDVqK8213HJKz0pS7lI46qjIJrvAdB6Nq5RsydPtA9h+Fhnu
	9rn/HLeRCC8jAX8XGK/NT0PUiQi2eJ20yI58Ka7ybIj2+wk+H/jGgpBdlPZufoNR
	NXw0Il+lEgWaTB2M8SqzYh/noCHeXIOHwka24jPeiZF+dDuwf9Lba9kpl8z7x1TQ
	UY7CUtiBhHw7UogJZfO6jhG67aoj+uP9STZGsztfTXwmUw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f0uhmmb1j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:21:06 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30c0a27ad86so180575eec.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782422466; x=1783027266; darn=kvack.org;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDBSl4oSawDBGp4EE+DhIVEqti8kBgTQJq6hOPS71dw=;
        b=e1tX3Oxb84WAOCKAddbloLpN4GPrGp6MlcDjzD0+j/Ukf478p0N89YEWWXs6PPYb0i
         GBASU6DM/OvD7VipbQaCEPTmL9AQpPFWg6ehNhiO042q4/2u00z3gZFQ8vl55tkyYhZi
         hmfslTuspIMm5Pp1q6q7PLzFjXo0CkSzKJn7+uicLjw7k+cmeX4HS7sK3RLv+u0RDIJ4
         buQCJMwzS4xRxfcrQZbvlgDo94c6iaEmmaDi4yMUPBtj4lv7U7ArXS2ssp4shSB+tMdv
         mf5loFw0nAr6A+BkHE79OdCyeOs6pw8R/PPltY5qbh+Tio9wTGMSybEmp3pVr3/iYXbs
         Mt/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782422466; x=1783027266;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rDBSl4oSawDBGp4EE+DhIVEqti8kBgTQJq6hOPS71dw=;
        b=PpM5MPiKupJCfBXazZXU+myx6tGUGyMoDGjOyQz0AbyFV2H/Sx02fwoUSaV+CVK4qp
         RJsfgr+7wsWMUcVyu1SmIe24gjWRfqtFNT1KOt/rbz7f/8Z3hwfOrOs2KDRzK7AvxPzo
         vksEy1BHI3dXpA8sYKYn1EhQYwybPen1NexHeZrAXa9BuNfENRHR5eKkK+3+hChqFoo+
         fs3RP2QKB9nK1zttCtvbCPrxqH1IZ7xAYgeKU6yMFvCCiTtqDAC8YkAF9n2k+6RHNaUI
         Uxyg3MEsMotdkqsRix/OA9Dx/NapqgVQotCylGKn+5fLvVaGRij3LSl3DF4KCX7Jb5IO
         jeIg==
X-Forwarded-Encrypted: i=1; AHgh+RqhQecwJH1JkzYOVv4ybTXnuzKVAK36oiKTlDVwmz7lzxAmaDEgBOQ1ixQTz3vyrhUxK8AJQGHeRw==@kvack.org
X-Gm-Message-State: AOJu0Yzjccj/udeHlgQ91hGgpFtKZaiteLvjy182/++EgSBTiiiqAVan
	WMZlG/YTuI98O7AYDu7HQnzQ4jD6WAeNhtXC7u6LGjgBdU+b6gh3PJ3RAFwcKoW6aXE4Dec7uXP
	WbhAlUyiVzAljt7uWQBEF8qRGGtYtkChgWC/tswMQAZsxxYEdxJsiuQ==
X-Gm-Gg: AfdE7cnKf5TBQ0SL/4tugoRdndqOffvhv98rq4C+dP/1P7m8zery45rkb1fQsGJqT9O
	keDBo//xk+c6rUw7vInZ8k8FzxTgS1hzLDJt7wAuOc/tsxflv56KFEBCeo3sjzG8xqUgvu+kMcn
	ONnTQPkWOdM24R0za9tGgbTVsWdcF+jh0Om8q/Yhh6r750A8S7Dl4ywdox49PQP5iXvJu9qldV9
	URyZ06wUizhg5UdNcSnz3TNf2+F7CCzhARO9FQpTiAfd+4uEO5STj0+0W7PuARoXTvamOoq6S7I
	WO+8BvsoBGdEB76bkff8pMIyYul+ta3ZIVFsPXJOrjOFjNp/A4v23Dr58v43JZlIxgmxPt0pBtR
	56NEZifFWs+pcLnDw/rIz+Q8DDs4ax0wAa+eb4sz9
X-Received: by 2002:a05:7301:3d0d:b0:304:eaa8:11ea with SMTP id 5a478bee46e88-30c85124ae2mr4280805eec.34.1782422465515;
        Thu, 25 Jun 2026 14:21:05 -0700 (PDT)
X-Received: by 2002:a05:7301:3d0d:b0:304:eaa8:11ea with SMTP id 5a478bee46e88-30c85124ae2mr4280734eec.34.1782422464116;
        Thu, 25 Jun 2026 14:21:04 -0700 (PDT)
Received: from [192.168.1.4] ([122.177.247.87])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c4c9dafsm14601833eec.1.2026.06.25.14.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 14:21:03 -0700 (PDT)
Content-Type: multipart/alternative;
 boundary="------------2EH0m31DC62N9So0VslS4ncf"
Message-ID: <0a55626c-1875-4835-b58e-e27e78bd0737@oss.qualcomm.com>
Date: Fri, 26 Jun 2026 02:50:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>,
        linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Lorenzo Stoakes <ljs@kernel.org>,
        Pranjal Shrivastava <praan@google.com>, Will Deacon <will@kernel.org>,
        Suzuki K Poulose <Suzuki.Poulose@arm.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mostafa Saleh <smostafa@google.com>, Balbir Singh <balbirs@nvidia.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>, Shuah Khan <shuah@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Brendan Jackman <jackmanb@google.com>,
        Puranjay Mohan <puranjay@kernel.org>,
        Santosh Shukla <santosh.shukla@amd.com>, Wyes Karny <wkarny@gmail.com>,
        Sudeep Holla <sudeep.holla@kernel.org>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
 <ai3kkIpaR0aT_6q5@casper.infradead.org>
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
In-Reply-To: <ai3kkIpaR0aT_6q5@casper.infradead.org>
X-Authority-Analysis: v=2.4 cv=cqerVV4i c=1 sm=1 tr=0 ts=6a3d9bc2 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=/mmxY0Z96yNuczEkiZ583g==:17
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=r77TgQKjGQsHNAKrUKIA:9
 a=QrJ9IbtdTVaOtOl6jMIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=JfrnYn6hAAAA:8
 a=QPyj9Y_XUGObnuAi2IoA:9 a=QHwtYfj8MSqCnlJB:21 a=_W_S_7VecoQA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDE4NCBTYWx0ZWRfX2xrx20rw+EHe
 drae1PnYY2N4Op3eL7vAwZAsWqeJlVNfhqY2C1dg1+CaxoSOj7Y2drD72d8sz+lCyQRFnZ1+Dz7
 hzGSOIVN5KI1AOc6kozeWLy/WBPi+YqPYTxwC27z+L/mJLLZeJ9kkUkv9t/rL8/ZAfOAeY78DrQ
 VZtMDUBaXfL8hUtxtQflfBcFikuGjXhgZVvmWARSzbbhBYccRN4SNHSISqX7w2kfL46A6eGcz0B
 aapfn5hP/odFAA8Jeg3Njs86bhHlqmv/ylzyGNALihKxO4+93yiawBKgiVUZYEROuIoj+tMcKiW
 8yNcuxawsRQZ66Iyo+dafl/DCj0UCRnxIaqoHePbOgsZn7Xmb9LgiJDD9CivQlB3cRPd2O2BtGL
 p2vTpJfp0fkTHDfU1puJ60UnjAUH1zNQ9Wny6OAITjqrpuQgDKMCq6CIOuOeu+XgsKAabkk2fbu
 TfsfA3OBZ7rWsmJqIdA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDE4NCBTYWx0ZWRfX+Yro7IjJh/fq
 2XJpXN2tL81v+lVLUpi+kZmSSZqhBJBNtKeJlxex+aS0yGFLmyJm2YemietCHemphY1WNcjiAML
 ikfPvFS5Pvaog9A89dy3UxZ8prZAt4M=
X-Proofpoint-GUID: u3SjPJRSR0oy3cQ7c6CpLIIBr1Z_--Sv
X-Proofpoint-ORIG-GUID: u3SjPJRSR0oy3cQ7c6CpLIIBr1Z_--Sv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_02,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606250184
X-Stat-Signature: muk1pfj87t6iu13zdbr4acbozca1qcty
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8ED63180006
X-HE-Tag: 1782422467-251633
X-HE-Meta: U2FsdGVkX1+wN5FmO1KxLpJs6Nlew2YSX/Z6N2ijBknNM6LBTNWvOneR/iaBPSn1i/SIH/KnGfXTNd2ugair2q4XPbmJ6kNcuAgEvylD6XoRl+f3NJM7KsdHtpYkwawnMcl3ePBHLz08EHnmxN6BCxZj4tqk2KKWMbfxm+vUoiAgntHJL2taTRmNmdyBAMedJnC8Oolv3ifj1MObZ7RmP4m6Gm8/UQNAoh1oLa5IIPDnOmCvGerUPOL6hrp9daL+C10fmlsshLJKqpQFJyitTKak4WvuadoMgmtzWrlABHr7dQeuWYrd9WY1gn3WuBPq2a3qFXNzrUT0S+rXy/nt5BiW7vMCqfe3Se3ebyJnn3EO0RIfATDzVOLv4Lub5QpiQPYm2soSV0xr68EObTyyzYGfjvzjCtJRuSyMSxoG2Fm7Rgv5Jnbu7aDumx/8V7QW6TKvjGLhFLWUifYd83NFcQQVYJctVAxL3QcE2Wd5vLIddWzEBcSQXYCp7m4Pb+ZRIKCkjGpqWVwH4z0+nfwVUwZmc64FgE8CR9nKhcckxtH9i/3/pAZkdQ0EsYXlT0JKq9N5P7aOSypemqXBAm8US5cEQ/VoxTl7Q18Oh+kSdkY19Q0+9TRw/xirGYamed/gRQDrLynE4xMzu/3Aw1mmHP+VAck3uILyw36mcRWhJRrsEMVxyFHJXb+a/8e/lDrWZIq90POvBFXsAyIC1bsm2m8+VfLlFtYA/+3JbVVX15v/vQBDzTU0qFG5Mjeh1ecsNsbCdc4b4VfXWAx2Fq36IuQDuduncsGrIWcwvOULlQDQCWfRZJms+hJnnv9Y6ue65/7Jp/LIQRlvyJO6yDB1SbmLdPahvnIBftPKNAAV35qHfl+Gx4AC0szjOuQShZkcLU/20tKab2GnHzwY03y5IF759WEz7E6YvC8qYWogBaOC1gysOrjtgysDoNFnKevhT1MD2WMN0XudxTWtdUj
 9WtY23/A
 kmcKlVKg1zN+0PuLJq2+6SFgOJGhsIsaSXds4DSiisrKlWFVW27pE100OhZlleH/GsaJV9b2AnYsCrKgUlbnc1MCRZ6ZdKkMbdZ+8h6XMxGnNv90r5Z/LqrrCyXZQ8LGf7t5qNiSJNLjgYI3+NhPcYR5nVOI+AX2TCW4Na04qEzHmiS/Af+hlOzmW2kd7kwwQzML7PzUf141PpaGuGEtVyt/10Lwx92pye3ja4pSbpx5b+CkSu1xULnVsWsLwo2HkcV/5j7TsdH98AytbKAYpjdCM0+0ZdA4LrWyx8g6YWt9j5Ud+7a9Eus3XooOZrqKuXra2gUTD90K+vUKyXTInCcoLnFRcoU9u35P7rIkH35hxIcQ1YXQ4DMENQFHpk/5sQ8DegXMOt5djCqKmKC/BtcqEsZfFyQ0lqmCtOpsEAvIo1cV7dMCuR5cGmGlS5JqH2dUz/bYIX4tiFI+htupC1kc7+/uOi4vCA9mclvM/Oi7zHAfYXnzjT2FRbyV4o9e7Gsdl6+zcADolri/MRQCIZDx/t4eie3BiefYfij3SNNIXLRdbCWlx1rRiISYIBnonw5wEYXZ+p8JLC2qsev4kjl7JAaRLQ4oYeTRhH1xE7+I7mPFvyASSVQF+Svf05NFid26D+tdod5W08A101fdmUauAepFT9nYdcLVQ6cIhM3IliER9x95VNLuzHkdU7uJZlgOc0hBJJjvmKN8QED1aUFIJw4L4WevXzXWD3hg/DhCT8Nh7CszOS0nv378Fda17XPouz5PIyt0lzw0MMr7vtv3UFvc1FIIZ6ce14yNix6Mv0qlE2DBtGKguxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------2EH0m31DC62N9So0VslS4ncf
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 6/14/2026 4:45 AM, Matthew Wilcox wrote:
> On Sat, Jun 13, 2026 at 10:49:42PM +0530, Pranjal Arya wrote:
>> vmalloc's free/busy/lazy area tracking is one of the last remaining
>> augmented-rb_tree consumers in the core mm allocators. The rest of
>> mm/ has been gradually consolidating range-keyed indexing around
>> maple_tree (notably the per-process VMA tree in mm/mmap.c), and
>> the underlying reason is a structural mismatch between rb_tree and
>> range tracking:
> First, and most importantly, I love this.  The maple tree is undoubtedly
> the right data structure to use for this purpose.
>
> What I don't understand is why you maintain a separate "free" tree.
> It should not be necessary any more, but maybe you tried removing it
> already and found a performance problem?

Thank you Matthew, that is very encouraging to hear :).  The maple tree's
native range primitives and built in RCU support do make it a much
cleaner fit for vmalloc than the augmented rb tree was.

You are right, and I'm going to remove free tree next patch. Allocation will
use occupied maple tree which will walk the gap space of the
occupied index directly.

The concern that motivated keeping the separate index in the RFC was
lock contention separation. Uladzislau had originally structured things so
that the alloc path could touch the free tree while unrelated readers could
access the occupied tree without blocking each other. Your follow up explanation
of how the maple tree's RCU contract makes a separate free index unnecessary
is the key insight with MT_FLAGS_USE_RCU set on the occupied tree and
call rcu deferred vmap_area free, the same contention reduction is achievable
without maintaining a second index.

--------------2EH0m31DC62N9So0VslS4ncf
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html data-lt-installed="true">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body style="padding-bottom: 1px;">
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 6/14/2026 4:45 AM, Matthew Wilcox
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:ai3kkIpaR0aT_6q5@casper.infradead.org">
      <pre wrap="" class="moz-quote-pre">On Sat, Jun 13, 2026 at 10:49:42PM +0530, Pranjal Arya wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">vmalloc's free/busy/lazy area tracking is one of the last remaining
augmented-rb_tree consumers in the core mm allocators. The rest of
mm/ has been gradually consolidating range-keyed indexing around
maple_tree (notably the per-process VMA tree in mm/mmap.c), and
the underlying reason is a structural mismatch between rb_tree and
range tracking:
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
First, and most importantly, I love this.  The maple tree is undoubtedly
the right data structure to use for this purpose.

What I don't understand is why you maintain a separate "free" tree.
It should not be necessary any more, but maybe you tried removing it
already and found a performance problem?</pre>
    </blockquote>
    <pre>Thank you Matthew, that is very encouraging to hear :).  The maple tree's
native range primitives and built in RCU support do make it a much
cleaner fit for vmalloc than the augmented rb tree was.</pre>
    <pre>You are right, and I'm going to remove free tree next patch. Allocation will
use occupied maple tree which will walk the gap space of the
occupied index directly.

The concern that motivated keeping the separate index in the RFC was
lock contention separation. Uladzislau had originally structured things so
that the alloc path could touch the free tree while unrelated readers could
access the occupied tree without blocking each other. Your follow up explanation
of how the maple tree's RCU contract makes a separate free index unnecessary
is the key insight with MT_FLAGS_USE_RCU set on the occupied tree and
call rcu deferred vmap_area free, the same contention reduction is achievable
without maintaining a second index.</pre>
  </body>
  <lt-container></lt-container>
</html>

--------------2EH0m31DC62N9So0VslS4ncf--

