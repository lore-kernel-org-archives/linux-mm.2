Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B666606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=g2kji7Jk;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=BPOv7KgL
Received: by kanga.kvack.org (Postfix)
	id 839186B084C; Tue, 27 Oct 2026 12:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA5D6B084D; Tue, 27 Oct 2026 12:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A916B084E; Tue, 27 Oct 2026 12:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33F406B084C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:47:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6A0D140A5E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:47:32 +0000 (UTC)
X-FDA: 85368987144.01.4D78121
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id F195C14000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:47:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=g2kji7Jk;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=BPOv7KgL;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf26.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793119650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7RlopbpHsfSD/OHRLgQiY6wQ2MChlTJY7NnjiKCoORg=;
	b=MgjWOaUVVY/xn3hX4eWiONx5DP/IPa5U9m3aTNwfcm6j52Uvsa/67lwAz9u8KjEp3vseBC
	c1kS5jmACTQjP9QVgkfpyPhWjIsTvxV4wPBXTMyXf4y+HyJRhrOTUMlrrqN4y13Dxq09qF
	/He5Wp6ss8wtRbu2Rity/EKImTabG9Y=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=g2kji7Jk;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=BPOv7KgL;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf26.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793119650;
	b=3WNFQAyNhzXwlWgWLS1n5HSYUuc/XqShOdMlAt+LyV3twXBGwjojWAc/BVfcWJJoIGPPfl
	hX7M89E9u8wkiedjHTrQeV6IcYvkbURWt+sZBBCvLGlk19e4G8Zdpl9QI1ZqUh4pD/acyj
	2yFu/z8BZtWXjYUAriho/BHEsiEduls=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RGXVWm1027286
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7Rlo
	pbpHsfSD/OHRLgQiY6wQ2MChlTJY7NnjiKCoORg=; b=g2kji7Jk4RhgPJwv9HHA
	naNWY22THk4WwGe/onm8xh1Uf6dP1LvHroRUCU9ynd3jMTEYToa/hG0mRCRIjw9j
	hnPUmvdzWwYwJg3sN7pi5HbbsaZiHumQQ9a8dEal5SxjjUiHlqBEPyf/6fG8j3bE
	c+cy9kt2nG2sLEKbRjW7w97kJOnyT7NIqdEWcsarsYIq34oMN0uLAlSLyyt8SHer
	oyMuJjnx5p5gns/Wk2/Q36cpP1YQntoEPCF9GNxcDnzIOS+QtzRE2yvZ15wpsVMa
	qBgjNPh1CPUgHKr7LVVAlF/S/MGglB+Gbh0m83oOS6xF8vihaD8JdjCAxMhT8dTf
	CA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hjjpc4f5v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:47:28 -0400 (EDT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cd61bdc8683so66231a12.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:47:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793119648; cv=none;
        d=google.com; s=arc-20260327;
        b=NN4CdHfLqO/exJQ/ML312LJ3yxnrt2kCID2riRiQUGlwXrZcNa95kskDs7cDcsbjKe
         LDx0oGV6SWWcF3E9t4OFfXSC/zG/WggWYmN/BjFUcbUVqh/Y9JHwpcptd8PqKsOORN2M
         4PKKPpC6jZe2Up3scgWZgK7bdLtlOERtfqRNqskkSvYpTSvwsrUdvkHqnJ6eiy4vHZjR
         yLFyA1XOAOCCFotpKRdav7bzCTiuzsAMuWTlAiR1kfyFKiudin78rlsvs2xPFFbGcxaI
         KISCdM1WsJ/Rve163ZJGoAr1aZRLSzn0gsCXGTsGxVJb4LeHjfW/SA8aBKv41WRFQ5PY
         M/+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7RlopbpHsfSD/OHRLgQiY6wQ2MChlTJY7NnjiKCoORg=;
        fh=QOW0Lm36+8zB4Y8Cmz/1MeZ9UiyABmMPgLpkYfMne4I=;
        b=gTCvrgKBYwI9ABPs23FqQh3UWU4f7b3mNK7VbpXOncHABIIjMg9XD6XLNAQH6lV29h
         eIZPlRogNbOfQgp7vUhlumh61O30MLkatFKm6sMmtustSUFM+C66FkuEmQmHkSQ5Iflq
         pQfp5OHgYD/pM312YjPje28RFYmbwdwMC9SFYsO3e9JgBmeZ8GsGXoPN/FBUTO+rqPKk
         HqTs6dp73867qSuzU8A3T4aAsdH0KUzq9GxvfkmASt/gsuDygH+ZFMvmVWSaZaM6veLD
         XQf3jGgh9lo/Md4G6GxCSJ0b2EXPu632vSPfk3cU7anluu0tL2b1BcTu/MN7T4mY56Ge
         yQng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793119648; x=1793724448; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7RlopbpHsfSD/OHRLgQiY6wQ2MChlTJY7NnjiKCoORg=;
        b=BPOv7KgLgzxPXY4ZmzFseP1fAIkLrccZixIDyB9iSuIjliWr5jcA4Wui4X4mhPimC6
         VJ+L+ANH0THzbxrMfOwcZzlBzv7kSlhGP32HqtHPG9O2tagGw1C4KBESCmKIECYm8OIX
         g76QHihsHHjMSDRLBj97OXPEUHdpzmY13dne+4prFe6p9n6CWl+MoJgRq6/0T4pkms25
         AHhhE+4tRE1eixn/Gxm/Ggfq5xkte+FC27b7TBqb+Gu4v0jZLBz+L8m8YCY2k9BUVsir
         X1/XwIkuACSlkO5A5Ol4tgPhwKaM35p0ZLhfnS7BGUUmlmBhUhAvOFCveTg2e3rDtoHE
         z3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793119648; x=1793724448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7RlopbpHsfSD/OHRLgQiY6wQ2MChlTJY7NnjiKCoORg=;
        b=oXTM37PkGSgr+UDsepgCEVpZdSqBvPOxBl4swlQCHF+dSGfssBq1XarbcDeAJ//XSC
         xhcs/0J8u9lOu4PgQOeu6hvyeod6NySQCtrSGMtxNI7/7kYFimSpqQAgx+7o9InGJVbE
         SVtLHehmO9+SOZu97dXYMNQrN8OSo623/tuoW9/p6qjRKVGhEX5WdPlTXCCQRSYZW/HZ
         yN79/z55u6WIAv80/YwJTWDzT4TIQMH+bI4k41Nhx3iqtVXNq9nPOVVbRhkdnCUDdPGh
         Swyd/nVGT+6Xp9atwvWrWygSTclCD0XW0xdDWdUeAPNUvEUKZQZmSlRYKobGGSpo2Hhq
         Gb+g==
X-Forwarded-Encrypted: i=1; AKwUvBxnDlUnwhf253R3frm7H+FNDkVlYvWsW36Q3Sx3+pO7qBfleJHxK26VVFP94H2avunkAjWsCSqthQ==@kvack.org
X-Gm-Message-State: AFq9FYJ2rGEU30y1OcOIvHKBRoiJQs1kdpqk6e/Yrlw+VQSmi0ZuDgUm
	vr9UA2OAy5Kuv7g2sO6H/fXnUxt/hi20i4zZrKeaipmWhHiUu9tCrVnrd1cMgT/HstRAjKWDhjO
	L6IYRNus2F//3yJaafJ5rvEXstMekCnVp0fa5wAz0ZtaamFmWLjzFkJQVOeZmC1T7IQgwXCSizX
	0/VgxuMZOcACc4LX9XoneqY+Y=
X-Gm-Gg: AYBFou392OV1fkYgK7euti7RRXR+aOkJk0+oTOh70SUD1Gyh7kJLNGOq0Cz8FEx/AYf
	Gzy1+/N/7xMqFfuJtS8P6rpL4n3x+hkHNj4937SqiRTxRDkTD2QEnwnVsCHLxgF+szsJWXZjeNi
	RUMJ7GPREkE7oZIjMjzqfGzXDam8RzqpRTm4MF/XFdSin/jid8DB++R9sjEgPHUWeZmvROFQDZS
	oksqL3ZsvxrRGgTA1PZp45xTQTpsozRl3lg3GbvYPazYsHx+/JJt4TUsoX0/DMm5C6Nw7BnnkGv
	nahTl1JnOM5vmzPVAc0NDChf4qdsDXbSqHn8DZHRWULkLWDYFN3RH4jM+scL
X-Received: by 2002:a05:6a21:610e:b0:3e2:7c10:d47a with SMTP id adf61e73a8af0-3e7bfa41045mr7510169637.15.1793119647867;
        Tue, 27 Oct 2026 09:47:27 -0700 (PDT)
X-Received: by 2002:a05:6a21:610e:b0:3e2:7c10:d47a with SMTP id
 adf61e73a8af0-3e7bfa41045mr7510137637.15.1793119647432; Tue, 27 Oct 2026
 09:47:27 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026-thpsplit-careful-v1-1-d357d70fd6f4@columbia.edu> <9620707e-59f3-4b91-87af-2b8e12fed260@kernel.org>
In-Reply-To: <9620707e-59f3-4b91-87af-2b8e12fed260@kernel.org>
From: Mani Tofigh <mt4022@columbia.edu>
Date: Tue, 27 Oct 2026 12:47:15 -0400
X-Gm-Features: AclHuK8gWWzzlKcn_L6a5T3j9EArAQHuwSjlQ0HWOR8CGZpOIEuzbTcpRfvDslE
Message-ID: <CAE2e9Owov22KK3ZPkfqwrJFpAMc_H5Qq22aoKpQ=0mWhiX5Q_Q@mail.gmail.com>
Subject: Re: [PATCH] mm/huge_memory: fix deferred split list corruption on
 partial unmap
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
        Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tz2294@columbia.edu,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=JcEpPkKV c=1 sm=1 tr=0 ts=6ae0d5a0 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22 a=VwQbUJbxAAAA:8
 a=nzbCeCAtSJT6Iwx4FrAA:9 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: 1hDSeReq44I_R9xTPqTw8TzLkC4Zyb6V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA2NSBTYWx0ZWRfXzStSePmPGxpa
 TtiBH7i5mkg6wilY0U7OKpbLfIuxNxdhvypAt27situyNTjlZsN8usydjeSwLVMjyc019283zCs
 BN/7vFSWpvG+jHLvInG2mtskCIReilkVQvWY3WLH0+NuNuZ9jOvyNq73Lv9nCYhWMBrxb8oatgZ
 n1/V/Vy2QCF5lOAULERbo8RW7CGWxvPb+VNXoyb0otrpwc2omPJQNAH2eV79npus+fU8xfymG9T
 EFXBVYSC3FVG9GiVdJcfoD1pGYAWXPEioivaHKC/5SymrsEvD4dDJdTX3Ln88sDfVQqSTMN796y
 N0AHAbYJuWDalczbnRCe76YwmshksjvZFvYxBNN71uK5F/S3j2SBNc6nJk7wnUAj5iXh2UOe8MT
 NeOQUUpw2X9ZALs6T4QxN5rS/RoUTIkO4DQAM7L4KCK2gmkMkiXqnPw1eYR11VsRPru2EtGoeAs
 iGp9puZq/5FV+ieIJQg==
X-Proofpoint-ORIG-GUID: 1hDSeReq44I_R9xTPqTw8TzLkC4Zyb6V
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA2NSBTYWx0ZWRfX0rjut7Dq1ix5
 mA+D08S2rDz1sscmO0CEYPtegdmDpcipuYclW4C3JZg01c70BHnsZt/nm4Zv5iOhcea/YCZgrmk
 Fqmg+yASvpNKtYYMJH7FPgJrc3jWnqyPjri+3q6FCHWX4TZ9BYFh
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11948
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 suspectscore=0 phishscore=0 malwarescore=0
 impostorscore=10 adultscore=0 spamscore=0 bulkscore=10 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270065
X-Rspamd-Queue-Id: F195C14000C
X-Stat-Signature: crwizmghb9g9hq3pd5woknig8mzf1uzn
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793119649-343892
X-HE-Meta: U2FsdGVkX18tjSwMbeh5UtWda0Yc5ywejnjfvFv/mA65VfV4S8IbY/CAfQ2TbwiAgt8ehCw9Krua1HDJRCTZb2vmpiJe05Tn2HB0TXlsNnqxJostmzSqDumpVzlUw2BGTv0qIdLWgLIqKxe2lm5JTZ4CgzUh7X1ynPbGHhV6U60Y+mxL6dpNe4zsKyGwALkDHDFhdOMAt9x/R52vGa0hw7un3+OduP8OAOYbR1vq7g/jAtFaZPe5zf+lZXf81TGWTyUVXzjOEsekH5N1qVVlAZGO/NCSe+MK1z0uoqw4eJ1WbMZF92mSrqd0/kTGHNCqongem5Jqfnrv4Mti64S+og1iC30xZdHWjSOnIGtJ1WFgHVQaJGkhzjJBJqGQuB0/vz1fvWikjUgMp1tYVc1bX/epFcjLrIesBxUUtmPnJRllkOAa+Ii5BSSh01rRlV1q12y69aLLTOk+H3Pd15iU4KXnBUck4OYD/Ev2EE6MErLxz0LGMXsDzmnL4ofznbYPfrGiYw3IQuR4lEURHyQcZ6ygpCeqcWmbLbIaOt+R2oKYWS7zZyXBlVkHw3BvWOrNs9+bSJZg8VPzH4iLSYm0We6T3dkvx3StTDjEmediuwJDmUGJ4zNjNxqQyVFLkz9JvfjtjCrBI6gjSkrYDqNLM5ImgHQUOvmB2Ap1YmjW7m3pPxecuC4z/TXqv6iMjqcwmcDT05biu/9jJ2hTLQC6O4HfPJ4383/St8SOdsL+4YfoaDqSjil4kPxiuqQjIniSMj/noA65iDUMltVga7m9LIyHJqJFH3FPIcxtlSOdFM9g5GCndFRlruHf2MctaJ9bPeH93+UyrfMl5Uk7QiK1jkMPNvxV5BTSl1SJ11JUPz4QiwalsFTC2MHp/senpMujjJkn+3pSwsMB8BugG4NKdH3Py/9L8nKytedGqWZjvIcnWX4X3qWKROjfm0R+ZPcyJzf5eotfLrkmVPxkqT9
 pGkc1k2T
 BpaoarT9MwFjwvF0+aWH+DYeL4lI6Vbr6VHc3JllT8Ej8oFGJvpsPJXelQ/rf5kEbLNP5ywm9UIM79YBWCVRrCWCFnwI1CAOVqqEfq9AeHnG90okLrCclGreW2UjmEqOfpE7rudxf2l6cJZeP9NvB8QiJm+zPkJMixmucAyzpD14xZVpYwOMhTERu78Ep3eWUGmz9rL0o1Tz2S5wGf2glxO2QAehFa2btc7GMgCcwRw4g6eeXnL1LB+6MiPyFCm7MsrYjLEmMOflasWisdb9KiDdbmJpXIvpjtFzwT8LV8blh8Tbmr3/59UyYRFrzVbyHbF4rTutnMJQ5n4hbYXIuwdZ+khXi33lzjBvxkApdOJ6ZQK+N5tGGMJeHQ/9801LIjIBotYSUo+yxjxR8zJcaO1JspMaIY79yL0wUtwmpDC2IwkjQAKJy1dMpEbT7qjTvLLA89dwWUwZ4+q6adMuUItaeFQ5P9DfGsrfR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Ouch, sorry about that, it was not intentional. I searched for similar repo=
rts a
couple of hours before posting, but missed yours since it went out about an=
 hour
before mine. Your version is actually the better fix (more on that in your
thread), so please drop this one.

Thanks,
Mani


On Tue, Oct 27, 2026 at 5:01=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/27/26 01:=E2=80=8A22, Mani Tofigh via B4 Relay wrote: > From: Mani =
Tofigh <mt4022@=E2=80=8Acolumbia.=E2=80=8Aedu> > > When a THP is partially =
unmapped while the deferred split shrinker is > scanning it, the deferred s=
plit list can end up corrupted.
> ZjQcmQRYFpfptBannerStart
> This Message Is From an External Sender
> This message came from outside your organization.
>
> ZjQcmQRYFpfptBannerEnd
>
> On 10/27/26 01:22, Mani Tofigh via B4 Relay wrote:
> > From: Mani Tofigh <mt4022@columbia.edu>
> >
> > When a THP is partially unmapped while the deferred split shrinker is
> > scanning it, the deferred split list can end up corrupted.  With
> > CONFIG_DEBUG_LIST, freeing the folio later reports:
> >
> >   [  523.871401] list_del corruption. prev->next should be ffd40000005e=
0090, but was ffd4000000500090. (prev=3Dffd40000005e0090)
> >   [  523.871412] WARNING: lib/list_debug.c:62 at __list_del_entry_valid=
_or_report+0x177/0x220, CPU#0: thpsplit/63
> >   ...
> >   [  523.900715] Call Trace:
> >   [  523.901753]  __list_lru_del+0x5f/0x220
> >   [  523.902588]  __folio_unqueue_deferred_split+0x238/0x520
> >   ...
> >
> > Without CONFIG_DEBUG_LIST, the list is left pointing at the folio
> > after it has been freed.
> >
> > Since commit fafaeceb89a5 ("mm: switch deferred split shrinker to
> > list_lru"), deferred_split_scan() moves the folios it scans onto a
> > private list under the list_lru lock, drops the lock, and then removes
> > each folio from that list with list_del_init(), which sets
> > entry->next =3D entry and then entry->prev =3D entry.  Another task may
> > in the meantime partially unmap the same folio and call
> > deferred_split_folio(), which queues it only if list_empty() reports
> > it as not queued, and list_empty() reads only entry->next.  If that
> > happens between the two stores, the folio is queued again, and the
> > store to entry->prev that follows breaks the new link:
> >
> >   Task A (shrinker)                     Task B (partial unmap)
> >   -----------------                     ----------------------
> >   list_del_init(entry)
> >     entry->next =3D entry
> >                                         deferred_split_folio()
> >                                           list_empty(entry) is true
> >                                           list_add_tail(entry)
> >     entry->prev =3D entry
> >     /* overwrites the prev link that
> >        list_add_tail() just set */
> >
> > Use list_del_init_careful() instead.  It sets entry->prev first and
> > then entry->next with smp_store_release(), so once list_empty() sees
> > the entry as empty, the shrinker has finished writing to it.
> >
> > The reproducer repeatedly faults in THPs and partially unmaps them
> > while the deferred split shrinker, run through
> > /proc/sys/vm/drop_caches on the same CPU, is scanning them.  This bug
> > was found and replayed using a deterministic hypervisor currently
> > under development, but the non-deterministic C reproducer can
> > typically trigger it in the 10-500s time range.  With the fix, nothing
> > is triggered after 1800 seconds.
> >
> > Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
>
>
> Are we now sending alterantive fixes for anything already posted? :)
>
> https://urldefense.com/v3/__https://lore.kernel.org/r/20261027-fixes_core=
-v1-10-6f74bec9a5bb@kernel.org__;!!BDUfV1Et5lrpZQ!UY3X4w_grTd5b7xfCu9wwNwdk=
STttnBXOqxvYQg-6iGDIzSIewW3zRtTjNpV60Vszy5yvmUPwTRGqM6HMis$
>
> If there is a better way to handle it reply to fixes already posted.
>
> --
> Cheers,
>
> David

