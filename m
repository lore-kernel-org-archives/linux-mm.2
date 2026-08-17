Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13DBDC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1741C6B0855; Mon, 17 Aug 2026 15:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126E86B0856; Mon, 17 Aug 2026 15:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C536B0857; Mon, 17 Aug 2026 15:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD4A96B0855
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36E611A076B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:34 +0000 (UTC)
X-FDA: 85111715388.09.6993951
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id A60F24000D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Mpbf+hhx;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=XfFjOHHd;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIiElFGXP+TJuv/wEXsiRAFNhkPhkbHdub17m4BLpvA=;
	b=a7rkxgPtBzjv4ihupBTg6OFaPZlWbXgxEZ9ODptU8UwasaCYZbPYedsHThZQ32+I6e9acC
	rQr+MD7ZLDwjd6NoMyDlbe+1trwuN8QzScv3Yj24mBvV+71IjOevO/QV77fcQsGydJBa2A
	7qPdvDUPLy0+AhDSiT+AFpAtQCevyrk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Mpbf+hhx;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=XfFjOHHd;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994131;
	b=joESX8Kms0Xsw4WlCrq8qJhYYS1DTcH6wXoHWxeOZj7ehTa5v2nC+wnf9LnebaYyYsroJR
	M0mO9LxvWOdgV46lnA3WKDuy4bq9Uxg5jDIulZX9wMPqGIZuuGFEjiM3I2kO44WsLO1iak
	mRZKOITCqcnjvuNaUNiAgdUJbkVw/K4=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HIZDZ43665032
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=AIiE
	lFGXP+TJuv/wEXsiRAFNhkPhkbHdub17m4BLpvA=; b=Mpbf+hhxQOXecHMI5xg1
	yNQXNUCmCIeUEA5Z1GBHaN+77T3R+M4MSMfiXf88p782FXBku4ajZGvErbxUmLIp
	MCDiwx/pgOW+u7jddimLk20iZGmBZQqFxZ5JdkOm/INw7222tmMehpb5JMc5Xmwb
	PiUflXIIHDyvRwBnJCeU7MxgblcpifMs6vaeXYqolMIBihMCxS8vyNAzb3RTyos9
	CgP0BlpWx+ArAm5aZ6i5Kim/rN4pvmSaB74UKIyboxUyXhD/jAxTTHCOEF4PGzrW
	hc8nQogU/PmRHw2qkSssBDVnERslfvwTZsWnpm2LUIZw/6cpKa66sotnUMtFoSjZ
	Kw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4g3mkfnqgh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:30 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-9309af14fd7so314236485a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994130; x=1787598930; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AIiElFGXP+TJuv/wEXsiRAFNhkPhkbHdub17m4BLpvA=;
        b=XfFjOHHdROSgW6qKgzhb1VxXebgaSArkkmP3ck7G8B7T0Ww61beqW0wQt6Otzsmy0U
         QQWxzF93DSBcTRP4r3TivJp6Vd0kWDLOohakvKtyXvVkUCDd8v3y8ygPcZXb045hqZnO
         TQ/WeWnYZqbIP5fcXJp8MqUCDnd1cYcWfOfwPXTWlnh03+Whu532vOI1sBwNVVfiZmXs
         618vI6xob2rhs3z6VQ5uOwrHpqaGnXRjamkSczlXfVXq97svln8YaD5/fTAR4BweKbSh
         9PonlORivCTYN1sNeBkLH7QO57VRy6Gu/ZCGRhwPplH0A3FS8o7sHPDWlh9G3y3eMKpH
         BULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994130; x=1787598930;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AIiElFGXP+TJuv/wEXsiRAFNhkPhkbHdub17m4BLpvA=;
        b=TUB98ncV4rYDqiNPW8DkKNvErMCVN7cuJXQcLTlRMfV308S48zfWjedRz5/ES0YFYv
         KrWoHHiexiwZ0BIekKUU+HZ/0/+Zp0ySDwdE9pZt3DYpSOxXo7z9zbhebgLTQDfrA5MZ
         RmGEY4+XkXEauWIJ3hypVN/51zZsqsi6pDVHQkxGM1Q0/1P+4BNDtSUSghRWd30JDPTz
         LtvMt9hBVsihjh5bnhc4VCMzeE5Imkuylh1vhLHYBuqOl8440o+Dm7OskJ6FotredzFv
         rTVYkDycR82m+6/yPsrIglhXZ6twM2y8kQknJg6FIpQsxU9+sInXB79HZI81LbzFm44z
         /rDw==
X-Forwarded-Encrypted: i=1; AHgh+RomD80KOtpCTYxkc3h5DTSY1i6ONv33nK9qjEfnYmfREGN22fhzTww9wB65xxKfWLpGBWDTfo5Zig==@kvack.org
X-Gm-Message-State: AOJu0YyHrR3JrJbNAStrX1A5sZjrsv9991iT7IxI3ZeH20mVJadQrfTc
	kedXvSrazU8+nGh+ZxQb4pL4xjzHYSZiq42Qj4Jl/0zp9F7lNtTSlsBee/DIaTNtL8sDX5ZsR4r
	QmUDsWAsTQiOnnMePye6to36/2thQgreNgAGQLwNaW18djvAgcJ706TbR
X-Gm-Gg: AR+sD11GhOu1LhDgdgrBW8kMEbarbriM34pVg7o6i7C9HcKxEjGpxdyXG/lYhe5x4Co
	Ya45oOAYsiFN4NCj+h8geLjnTqvji6jpO0c2Q3PZnMo67tRaI9y3gxMyK9qKrEs/NDq7s+uof1d
	qJ01Yf6wVy1E+0/XxrK409cCg2jmsDR6/UnzXpEu7OlJzMWExM2nUH2GJPA676F0pE9KI6E6gUC
	iD7w/XggK1VdhpNmyUTsh/cmcDiZCywIM3CWsdKkTsRx2RO38zIvoqKd8N1ZQkuyKrn13UzoqUo
	m5yV3F4pgbN9a9CftdH3F9clAljNtIgAUrSidbQUeLX1Li9aOji5bSqfBxqZzEl9lEm+dLtER1u
	d5KdznlzR
X-Received: by 2002:a05:620a:480e:b0:915:e9c3:f1a0 with SMTP id af79cd13be357-936d22840f5mr2649155285a.12.1786994130019;
        Mon, 17 Aug 2026 12:15:30 -0700 (PDT)
X-Received: by 2002:a05:620a:480e:b0:915:e9c3:f1a0 with SMTP id af79cd13be357-936d22840f5mr2649148185a.12.1786994129555;
        Mon, 17 Aug 2026 12:15:29 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:28 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 17 Aug 2026 14:55:20 -0400
Subject: [PATCH v4 04/10] ceph: convert
 ceph_wait_until_current_writes_complete() to folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-remove-wait-on-page-writeback-v4-4-0e5e53d47eb0@columbia.edu>
References: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
In-Reply-To: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=1518;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=CtACIxblCkTU4GIVsMywndtlFj4/darbY31uUhcppE0=;
 b=nIMGKfsxXx6M6GzoWM4iYtnVdPx9NR0aDw+bCSaFBNWhD63LVG3atj+/qqu8/Yz6tEBDnGsoN
 1ecdxtRxUCeCpDtJIU1agCfCHEGVsNVlqr48rrktcXV72oraquBe8/y
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX18CYthvWWlhU
 +5G10/m0qBDfF33KfJ0KJSH+BAdf8c3ROamqk2AGq7S8UdRU59n5MpSTKYC1fdCBuHs3tQRjoCI
 hV+wdXk5O84lwppcYjrkDIYxAC0dYt0esol15TSob3IMX6k3T5eo
X-Proofpoint-ORIG-GUID: Os3Ogy6KX4A37izzm5uY8-ltQJdYhfKM
X-Proofpoint-GUID: Os3Ogy6KX4A37izzm5uY8-ltQJdYhfKM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX8qYPqAxapUno
 A2xDAR/E7/gTlFxIr9VNWnLveUGO29dox8EiobcCh0kOfqbrSOCDu6rQmziA8NU6BvXvB9efWxF
 lXo8gYOW9j+gXlLt0X3nCmbx6TMfiGyvaiXGMd+yB+R0vPnv1g3c9lCNBI2mGf38Del80/ZxpaC
 GzhYWL9rYlC/CY728YFMZNZnj2B9EdNXZcVxItpnaa7Rk3cu8XL6KSzeF3wflwxe26YwKJz7wbZ
 IEm6UGN58ykqin53YB7TkexCgSv7qHvxRdzoOiyMS6F2JSmABeO8+bOVSN+PrvI8Rzy8AGKg4Vo
 RhRrYeK8ZrUnAclIqDI5FSldHUBDC81aTzidDMgNuUN5olBbmmgVuRCzeG2nJLU9ybTX4rcScGn
 rNmUATl5QId9NRhoHbk0SGBPg8amorUY8MFTU75v7boB0DPfp9ywoXHxEpvWl/CqNYnT9PIe5cw
 puId7TqpE2tNQBvrnWA==
X-Authority-Analysis: v=2.4 cv=C+vZDwP+ c=1 sm=1 tr=0 ts=6a835dd2 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=JfrnYn6hAAAA:8 a=oBeIbaJldBQvbLH65vwA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=10 impostorscore=10
 priorityscore=1501 phishscore=0 bulkscore=10 clxscore=1015 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170147
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A60F24000D
X-Stat-Signature: 9hh5qrq6nba6ygj879bzcpnaktsbzrde
X-Rspam-User: 
X-HE-Tag: 1786994131-687097
X-HE-Meta: U2FsdGVkX1/37HHu00BaY1z9HDY99o+3kx8Clm/0TuHcLecmZfgRW27dQlQXhPy1koTxUfjHKzieD6BEnpEphmpZ4en0ZrgwxQKgRu2CTV3HJx3wYD4IAs7vjcM0gnIpuk7fyNKunJaXmOf8oSf7MSOyoVEhMZ0NBNEhXZ9HlJNvNgAWyT/Vs2b125U2sLWC2qmY30tQ7z74Shl52uLTwON6RolRYkau7xyYTrjiM0WtAVx3VBsut/sywH4g3pXpOsrTn7cIBEM0SUpOkPz+syI9kvQzs4XdKRK4iox8Drsrim8ypGEk/v75IVS6UGVOEVlZpFNbNI7rYs3vTBMTEWWjCqQOR1Fw5w4N7w3QwlKVYGcbrSBrcs4V6UymVTinnB1Ah+1jJNQBoWW17NBTFAHGQ33lCbC1On8iqeT5aWyLa9xSPLDwdMaB9ALNpB4e4kRV/fDbX9v0MAUcjamzDVlzSiS1UcNtjrDhv+U6jJxrXL70k3MNGIzWoktgE7u9G+4pQYYkZnilQHIgeHs5cRCDaUoElR+dxFGfvTGE3b7fu9kQMVdprxwCs3Wx+TEZW2e53d+xQ0eRkjWrELBQj1TE+1e2lXYUeJEog2Gm4tLxHpfq/kLe8JJFlh9FSDMZgeXJPnQnau2mLPtYU5mCw/lwVEB2g+EO7oH53ny9eRMLfw/G8G9AmQDQ3CqJrC84KpoomjHL5cD052YGg4hvv8eLi4aJQzpHz+S+df+F30v/kzeDI1Ci3QhGp4E0W10/Ijiex/a8NcRckNgYuvJAY2EO3+nEdYTjjtDbgJUoSTMQR2aoZbMeMNHS77KY4vEkxmkR1J6pEGwnuXnRc40P+7MHiC/9x4wQPkjDRtfdt8zlo/2wNeVCSjtu67zk3lQbTz9l0JZ2gg3J+I6UrR/myb/YQVYW62JwBNdrdrrrY/cvQGchLoiZuPBAYzccV5PGpYf457hlLjNX7pdZJC5
 n5SqCy/a
 gfOpAw+MQXJU7362BYYVfSGMPTUOc7tAfzjQD61lKI2B6kH761AJMspOekBaTB///4y/zlpwL1LUuVL8HBSKFPXGXVwL3H9F5YVhOsPLRUsuKj8L9H1+3Q8kSKMRlH1jSH8+DiuyvIpYPCsP8mMGHAMMgo7LkrtGaALCshCU+C2EKBq3F5euMh4ObUWXgymZ/mI85VxHUsY8PhYSGT4V8cFQwxD9XNPLkdqcnirmrBSAuKhmRCMngF5iHdDsWmlB9pQRBdpU4r5HuO6e1HDIL0aNS50uwL3P7Dmzz86AJ0lOahKXO2Dst2dJb8D2EnrUgwlVM5t8NaZfEhn0Q6lNfC1fYqTk4zvwRQTUbiBAcYq5Hp67cAwIPhM93pjlCpSql9meY76Onb7frK0jFdue0QpfBHP55e+fxQIHQKF91RHWzuABUPaKMGwqvgmfvSk0LHBsVt7pqwxOpotMtvPdhakZKOf5l6zYHFTrR0VQmn5MgoN3CcRIZ60Ywn6lsYXnYTa7aQYlcofLXS3YSLOf3rEd8SiCavw+wVxNwaeaogJ6MIn24/hxpRxeEJzNNIqxvH/64+zboSkLTWZBga5T7QDDiPP7PVGrFs0LLd2zC56ts3kV1Zm5sA2//Niz+d7wr3hsIIgsGs/KGlsc16ivI+ly0X3PBqK1OHe6Q6hiMh6O51zQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Iterate the writeback batch as folios rather than using
&folios[i]->page. Use ceph_folio_snap_context() for the snap context
check and folio_wait_writeback() instead of wait_on_page_writeback().

This removes one call to compound_head() and the last caller of
wait_on_page_writeback(). No functional change.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 60955060dd1b..5efc8c7c91df 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1648,7 +1648,7 @@ void ceph_wait_until_current_writes_complete(struct address_space *mapping,
 					     struct writeback_control *wbc,
 					     struct ceph_writeback_ctl *ceph_wbc)
 {
-	struct page *page;
+	struct folio *folio;
 	unsigned i, nr;
 
 	if (wbc->sync_mode != WB_SYNC_NONE &&
@@ -1663,10 +1663,10 @@ void ceph_wait_until_current_writes_complete(struct address_space *mapping,
 						     PAGECACHE_TAG_WRITEBACK,
 						     &ceph_wbc->fbatch))) {
 			for (i = 0; i < nr; i++) {
-				page = &ceph_wbc->fbatch.folios[i]->page;
-				if (page_snap_context(page) != ceph_wbc->snapc)
+				folio = ceph_wbc->fbatch.folios[i];
+				if (ceph_folio_snap_context(folio) != ceph_wbc->snapc)
 					continue;
-				wait_on_page_writeback(page);
+				folio_wait_writeback(folio);
 			}
 
 			folio_batch_release(&ceph_wbc->fbatch);

-- 
2.39.5


