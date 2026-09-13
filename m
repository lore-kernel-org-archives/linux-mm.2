Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8195BC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 20:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505F36B0088; Sun, 13 Sep 2026 16:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E01E6B008C; Sun, 13 Sep 2026 16:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC9E6B0092; Sun, 13 Sep 2026 16:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF506B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:11:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4817AC0AD4
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 20:11:11 +0000 (UTC)
X-FDA: 85209833142.29.6F23BAC
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8B428100003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 20:11:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=meP7My1q;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="L/ZM/xUs";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789330268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmmCbWeNjsNg9Gzck7tgmssf89nltQI5HT0F64h0084=;
	b=YQb3FY2+J1eH6qEOdhKmNC6PIicnIk8kFPDaPkaSD3xkjaLwetrOfyBTutkLejmFlYCh+0
	YpjfXO7aNSBS+eXyhfBLkvC7WivCE8bglFMAdEGLlVChdPH954i9ClhX9KHbSeb/q7b4tv
	zt1k8WFhllVdqB/svfhK+82MplFe2ug=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789330268;
	b=73KPN1oQVTvSuWETaqD31tYDqP3AOQFZFC8orWShu+VDB8heji1mwBX4H0DTtZKohY0jMW
	vgecnvSQDwJfmH2gOxsJFDXBz+4vJtGWnaJWk+Sx93Sij0CkEexhmkrFmBqMDEb0gLv4d4
	cs2o2crKFSk7/oe4YHnh78JrVCOe7+k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=meP7My1q;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="L/ZM/xUs";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKB66w606010
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:11:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xmmC
	bWeNjsNg9Gzck7tgmssf89nltQI5HT0F64h0084=; b=meP7My1qraBPv99/dAct
	c/kxivRvRltxw9A6To/cOqKHpDAm+YNr566ZKHQ1Fg6VDfO1lg22RQflyrXDDfLA
	a1HBRKgeUcVtf0UlvgPz328n8zl1aG9fa9SycosDvXclEvReC8w3YnfW8hEBx0my
	Rm7pH1UbInIC7q30KWdnKhymAimiiRlj0m1+5ePEijhir0Fi6FEi7Ixun692MifM
	n0BWUdTH7UpQ++WYr8OVkt/V0i2ppih16ZjGfZ7Mh4pL1BS33j6YahRVevB4tmVB
	RBSNITLU9JDlP6kV8GL5j15Yfe8yKdJUcGPB2hhHAKMSa78Hk99bB7C8QlNAcCKo
	3A==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp2mjg061-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:11:06 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-939f27c80a3so504494585a.1
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789330266; x=1789935066; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xmmCbWeNjsNg9Gzck7tgmssf89nltQI5HT0F64h0084=;
        b=L/ZM/xUsN791CFn3cqUoDC3+74h7GD9yvpSd635wipv5tr9fApwtyjZNNUD/TlPqyT
         gXPNEyqhtfMW3AxP8ZO4naleqfSbZMxm1xvuiOEZnTSlsNlfnQ+tCpeqJTl5PjV1s6L9
         XOj0Pvt1m7zUYpOe1fu27Yo0NsZY+vE/L+tXf9DCwjPPJs5qvyH6GUccaevJAuEOUZAn
         tUrELA2JkQU6Ay0FhfzhqzHt3O6SF2NsPKNJPU/MOgdXwj4elYxt8ZDhTgJp4/sd+6KC
         SEr8tytnJp7+ei+eak1Lel3jjr2BtxH1iL7hU6N4lEmk8IEG3OvyjwWevV6NwboInxyr
         IdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789330266; x=1789935066;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xmmCbWeNjsNg9Gzck7tgmssf89nltQI5HT0F64h0084=;
        b=cRznfGDLwjempIvJpaKeRETCLEYqn8HyJfFD8xCphHOusG6Bef+pYUZ32/464gMaJS
         pDfKC26X3fw+jYqL3QZrfwwpfKiTmiNlDwPOHm/5YzUq7PxK5+UOXf8gZe78EIKMMfaM
         otJAJbW7jrhgiml8yf4E52H1VwNzOwmuADjNxUpl2PO1S4Kjrd+v4oVK5zaFH2H6lK9x
         ajtgcgbGRUTtRyM91nBYM9HhyDLg3eGMW5oRPwzgcjco9q62OHcRQ5uF+d7d8OhWPIln
         KkmtSUWP1xPVhog8ET91Mr6cSdS/IpGwGvaxkMKbp2rB5BKhnCzdpnNLN50PqilHmGEP
         cEXw==
X-Forwarded-Encrypted: i=1; AKwUvBwXo1GEljDQg+ChbP+8iwRo3rLAR+RcN0T7YGmshIOy2uhg3z0nVtDgRKaspdAjH3/bBnJBJ69jMg==@kvack.org
X-Gm-Message-State: AFuF++nrk2qI7RMEurE13FzKEAnEr8Yb5buBgonm4ocl1cwj190Fnotm
	Wun24/ybZV4JynmV03ctRKg+F9w+TByQrk5fNwuzItpg0hUipHk0wYBvMEsYHLBJszj5teWJJ/p
	dhEcNqgrl9PROXOCA9InktMetwjxhXZRlmnIM3FEife7xwidI
X-Gm-Gg: AYBFou0nZTof6LKrLD87G6CjKhDjJFH15L8dxM//S9oDWJg9I2YPd0esJ/5dYoD/ChG
	cjLb4MfWYOpY8EoBd9Bwkt4zRjF5AYGbhajh2nEkfzQ2Hueej4ETr0A2WKXokLhu6VIjB6X4jRe
	B+QfzlXaMCUwI2gSoYp04cUEYeifvg7nDeluWPy3t0NlRYGje9KT5eU5ypbDnBOcYApeB+b61xQ
	bL+2oy6fujSSfsF8jBx9CqXM+Ha6d2NlEeLHUeJye5uU8Y/CZFi5q6NvERmEBaJdsT20teiKCvO
	vQwio0lDisikMCQ+W/1sZnyBGgaQ9SV7escvPZixTlYDGy9whyV2OWilfpg/B2d8fFijAtaPfEz
	QqC/GQ10g9kvIaCZ82JVbzun9NWX8YWO82J9DNP4QGk/kgZsE0aoI
X-Received: by 2002:a05:620a:4443:b0:936:eeab:307e with SMTP id af79cd13be357-93a0357e40fmr1139532285a.9.1789330265921;
        Sun, 13 Sep 2026 13:11:05 -0700 (PDT)
X-Received: by 2002:a05:620a:4443:b0:936:eeab:307e with SMTP id af79cd13be357-93a0357e40fmr1139526085a.9.1789330265446;
        Sun, 13 Sep 2026 13:11:05 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939f592c482sm659587485a.3.2026.09.13.13.11.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 13:11:04 -0700 (PDT)
Message-ID: <f971be6c-c3e8-42ad-ae4b-fb3d0753a8c2@columbia.edu>
Date: Sun, 13 Sep 2026 16:11:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
 <178889163877.1334491.3646957026033534678.b4-reply@b4>
 <83a8743b-9cbb-42a5-9ff5-718297916a76@kernel.org>
 <3dfab5df-c205-4853-bf48-86351a02b4e2@columbia.edu>
 <927c0ec3-4183-4355-9269-721d79f4983c@kernel.org>
 <30DEBE66-9E26-4468-9A12-123539ED68A3@nvidia.com>
 <DLBY1EIZD8G9.3O0LMDKCMNPIB@nvidia.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <DLBY1EIZD8G9.3O0LMDKCMNPIB@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=NfpzRGD4 c=1 sm=1 tr=0 ts=6aa7035a cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=FP58Ms26AAAA:8 a=3Zgl-KUdFkos_lAptz8A:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDI4NiBTYWx0ZWRfX/OGBidA7S6En
 Xm5n14qRRJXyyW1zD9qRrIMwWhU090ZlrskkbGAaRTPzu7kLEU975CtDvwgX/TyF13J8gK+6p8h
 WH/MRNN+Y2Xe4PZkkTlPGDJ1s+FNVZmE2Jsz+d7nwb0O4W3DktDgCQNgN2Klkt47UKKw4Y6gjar
 4qwKHpAdmDbtYR5kUmr85vg4n/JoBpEw5VYAaI/JsmR5Sks+qJO0ykktZiCv3ckfsWlFRUJbZFv
 5u+6XqMw3/rgF3JPI9lmQ62nselOxor57VfiXyRc0CwAgKT5CaV33QXIw8KMEvnFRBdwjYJYF3O
 Jte7LF0EAdKw4umJZRjywPuEUmhAdIqMzQXdnFr4ABZFwjlJsUPUty6EogjxaqjuLhG3tszsCKE
 GbJJOxA2BFSVv1NlheSBzKPqZtQTZxEpi/48ain+20hO2iRIUq+XY3/lJJ2Pos3WCoJXCxPi1JI
 /axWX+RZZKnt/AietfA==
X-Proofpoint-GUID: BnzNqaouBapwtnDBs2WGdRMWOgByS5FP
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDI4NiBTYWx0ZWRfX1CbaXnOddnFl
 Ea1APpWHhC9k2YIs0eWAv4xwv4jazgPPjkeT9OX8MIaPrWUXCq+HQErBMYBsim64YARo/uiTBBo
 j+3OWJ0bwu0d+SLWEpUO8ydx9HsLS08Lev8S6HjBwrmJ4CC/J62X
X-Proofpoint-ORIG-GUID: BnzNqaouBapwtnDBs2WGdRMWOgByS5FP
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=10
 clxscore=1015 adultscore=0 lowpriorityscore=10 priorityscore=1501
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609130286
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8B428100003
X-Stat-Signature: ej8r4qoy1yjbousfw4otuzcfm5ng7tdj
X-HE-Tag: 1789330268-878626
X-HE-Meta: U2FsdGVkX19H5Rk+NXT2h/zpI+sOOf30/eCqLjxo8jZaTJT4Ar3invunM/9H5GfSrHl5+1qA2zFWFhnW6ZbYxNhuPJt0tvBH8kuwlu2sQ4OttE9dtIhyyxqUEHR+anck4iazmwGix4fHCuKwhShxR0Z4oetShfsDZVzuAf6vXpCya4PUK5aQ27gq87MXhubCqw88lp33kDtywn5v+kIZP0RXl+Bvx60BAjvCPxeyV8eWmy/Iqql2QpOlUdkZdNfaUJcbI0OMqbrS1TDwplC4LdcGbDSKGSgloPktdaZI9Lqis42lIr6PwzhN7FfBF8M/MJhasJKaD+vQXUfwmG0/ynCr0FAUsZxRu098Z4e58f34rgYJxjnm259KLreBwjtVvOH3it5zkX4IJXaBusWwnsZtdeoW/hkdfLDw9xyNb0WMNl0Zrs+MVwHRurzjrbRXYlJUTG5QRj50kA8fgxK+Kie9rI2R9Pi/ABeCjHH0INIxAvewmgdx3WwW9kBmkREn1/9JhY3Lt2/4SJ38DUE2y4G5bwzhXBN49hgtY+m5TrNNu+ac5rQj/CU7BK7NyOlTB5PeWqVf2UZK4xD1qLF2ar/qDGSoEZHnNUGLM9hkXPr6f9qIBovEGpLPHDq+YI6Hk0KeCIw84nRegwcrs68rOG/ReHLhP+fIc0JJ0g9QuQZKwEstYi9Hqee4eghNrmCaHBdhpj2xYe8C4+yYcCDQfo/W3rSqQvf5zd6mZiVBIJJcPvRfyVHAuYsrje2aRM1ZTID/3+lcGoDSq+9wZR2OySVrWi/pQeTNI8LQ8tmMlGgsqlTdLl9+k7B+r7cwTubxgDIwHqDWjSaYsuhGTOCVK0OvGsWyeuWonCjPpnRXRmss6zFhIn4NtkA1HJPE3ilXPI6Dot4GkTV8OS0KSvTIvzC75SII2qhx5W2dj9R0DrXOP9oBwT6nfgLFDun1PBJDvDKSbzwKW3zEAIf3lXC
 1msLFZ/E
 LWvKTa8/WGtqlKWqqh/bMYcymh3EWi3X1ZUFBn8DVyVEATvhmJ8fURRmNRARwdsyZyfWsg3l4vTutf83RH1/5G8ljvERiX8CmooZMvtPacaEE52NV0x79/vXlG/E8N+Zsy0jP0LYmi4X/BJ6Nk9prBjP9cxY5rhm6FYk+3QKlDrfeGGLu3KVMGdXEn2aucCfsUKbFh8qbr87VO20nOufsCm2CRC1SMLGcXSk139cMZLxa6NLjPmwCOCw+LT4NIEST8NLneQlPrNzqlWvH5oLcv0iOk6wm+tLl7uQTsedsnkb8sofklQnm3r5Cd1hwKONPy8UfwS977vkXsWDKwtw5G2SHuFUYjY8uW99XzDAVyKVVMUsfsxlkIFyRvMyPkNL9fjorTklzZr3YcUovqiVoMB3nSGc3H6eNzkQ9zef3TgIJPhASIdGGm9paZyYlm0r56MYPe2ZrbUJWVerlSoZeUpES+6B/rwU1RxAIcytbqCHyZxDAoZ1cv0aA+NNJYEjCEjtfFCESrnr0/xbMZzvJMbboMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 5:11 PM, Zi Yan wrote:
> OK, here is the patch. In addition to David's patch and Tal' suggestion,
> I also
> 1. converted PAGE_PRIVATE_* flags to F2FS_FOLIO_PRIVATE_*,
> 2. converted page/folio union in f2fs_io_info to folio only, since no
> one is using fio->page any more.
> 

Nice!

> Let me know your feedback. I will add this to my patch series once you
> are OK with it. Thanks.
> 
>  From 3bae5c494459b3dd05893df6051e3eb37164f810 Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Thu, 10 Sep 2026 16:42:39 -0400
> Subject: [PATCH] f2fs: convert the ->private flag helpers to folio-only
> 
> page-based ->private flag helpers are used in the compression path, where
> large folios are not enabled. They can use folio versions with
> page_folio(). The two remaining users in data.c and segment.c can use
> fio->folio instead of fio->page (two are in a union).
> 
> Drop page-based helpers after the conversion and rename
> PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC() and the PAGE_PRIVATE_* flags to
> F2FS_FOLIO_PRIVATE_* to match. Convert the folio/page union from
> f2fs_io_info union to folio only, since no page user is left.
> 
> The folio helpers do a plain read-modify-write where the page ones used
> set_bit()/clear_bit(). It is fine because the converted code either holds
> folio lock or, in f2fs_compress_write_end_io(), matches what the
> non-compressed code does in f2fs_write_end_bio().
> 
> Assisted-by: Claude:claude-opus-5
> Suggested-by: Tal Zussman <tz2294@columbia.edu>
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org

Looks good, so:

Reviewed-by: Tal Zussman <tz2294@columbia.edu>


