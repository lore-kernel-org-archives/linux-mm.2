Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35887D7977B
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 14:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC1A6B0005; Sat, 31 Jan 2026 09:58:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60306B0088; Sat, 31 Jan 2026 09:58:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B099A6B008A; Sat, 31 Jan 2026 09:58:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99E316B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 09:58:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C400595BD
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:58:32 +0000 (UTC)
X-FDA: 84392565264.27.ECE9025
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6015810000F
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:58:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=OvHzB4qP;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=b4idgSxL;
	spf=pass (imf14.hostedemail.com: domain of krishna.kurapati@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=krishna.kurapati@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769871509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjEvOy2WGDJOvuBTZY4HtZUR5P6Q5ANbgXFoz/CfBwA=;
	b=najs0lJ57zuwZtLbryCFKHNV/u3h81c8/fVEyPBNJzlXW+Ih3svFIuIqSqVvUdWunikrmr
	7D9aY3TtdsqOHYvoCxyUlwahbWK5wm5/wIXcUigiPcwf+UVQcfUZsO3/HPu0f5bF8Jq6eF
	pEQD30qFQX+egk+cBDpfyArKtegZmQY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=OvHzB4qP;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=b4idgSxL;
	spf=pass (imf14.hostedemail.com: domain of krishna.kurapati@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=krishna.kurapati@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769871509; a=rsa-sha256;
	cv=pass;
	b=O/FaP2d+1vWHC5uoIpYYvbaRXgkFj/v+dwb+XPobzbWtvZTsWQJZV2a8zNz8MLbV0o16l9
	3zt5vVj6By2FuCy4hoO3VT0yYbIIhgyKyp6TxrMHtexsopTvFXI+ovbVloW1FixLstoutZ
	0eCaijiV9tR3QyaG21JG4DYmUkhf9A8=
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60V4YfjB658342
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:58:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UjEvOy2WGDJOvuBTZY4HtZUR5P6Q5ANbgXFoz/CfBwA=; b=OvHzB4qP/0jw0pjw
	qHWpKU9MTVgAy76IZFOwvomNtT5ojMnLFjv9vAMABxUYDDdhCdM/mdh/1U5ckbR1
	OHXys8Fv+a3PchmsefgHP4EyfqjCbDSoUrH0Z9vDG2TJsjY7dmvbMOIBYgB07cQC
	ID8YMzju3Vh/8MpgAyNwHRivnN+v5eYDr5CIhLCfTj2mGS4XRYyxzAUFh9cINBG3
	4lbqX8kwiPdpC2X1VC+X57Yc4hGnLxfwp4WoeziP1V7KW8OWpTYzBS2/84Kelkij
	c7Hl5zdRcBv8uYhTITx455LsNqpLBdwF+tnJlsXg2fGzqhfqDBQ8OAyarNxVhK3m
	+a43bA==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c1au2gxc5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:58:27 +0000 (GMT)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-64956cfd789so3847652d50.1
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 06:58:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769871507; cv=none;
        d=google.com; s=arc-20240605;
        b=i5pqE64flEcbaCKUwv2mS8EQoVuTghR3xbYJLgHa8WjAM5yvRxhUaub8wgMfSu4Qnt
         D/WPKx8SgUjvO2hDiCm8dwIgfvuX8jaQG6F8zkelXmkbKT3wefc8RDSyVY0c5JOqKjL7
         Y2faz3lPMdCtl8Lmbuk/kRm2qpOyUoMEyB2ItfDREvEaJVzcEl+GwTIdSimiGMdWaC81
         n87dsZd6vO7nASWoQ7DSPHqORBZLwuzOkFx1yH8Y0ZV3vv0PWvuEeQOwJzWC4Hg8nu21
         W7REDRLuquacF0F/NdS+MnglrCpnAzBLWBWhgudp5mT/fYOo70TdFYNexW/70zWqnd4N
         GQyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UjEvOy2WGDJOvuBTZY4HtZUR5P6Q5ANbgXFoz/CfBwA=;
        fh=h8zgALXxzBMEURF0nulaTsO3tQqg+/t5t7hrHggA8rM=;
        b=IfV5tX0oepvVxAQUcX/LDvnOTW0B9aYy+i/KIn30mA0rz27i9MsdX4l7sEYraWS/Fs
         iRc18rBzoMOnmP0GMFTOgnCfLSuI69qlY4cU/VQi1f7aiT61bR6lKEXCaINl14Zdx6L/
         SX4E/jmkSntzqpGRtMO2F6zOVLLcekwUx8O9tLizTVBekQ15+INxnqJp4N1yT3u5ndth
         MwVZDEWiWK0vnUZsKFgbCTY9Z8p32UQb6wo3NQ0BDCvcbSNDXa1/Owk8f0X9WMKwSMU3
         AEYocVfGYXFV9A3Qud91pKRgLXSD7DBXuSeQDMaBg3Hl+srAu/IqV4TMg4C9ErOunGFT
         uLiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769871507; x=1770476307; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjEvOy2WGDJOvuBTZY4HtZUR5P6Q5ANbgXFoz/CfBwA=;
        b=b4idgSxL8n57d+dr120YDxUMioB3W0N9bwhyhAvxDSG/H7lSMBT+ZwTlVTBv+p1B02
         /9E28Vc4XQWeCIPwKoHUyic1VAiFI6fXvy0lMxSXM3IeNq0BUsxT1MK6cMrmVG5OD1f4
         hf/2LWQAhF7ditnBrqNdbx9TxojW2zjUwDfH52GppE8vXGB9KnHlns95MwPPKJZCFXZd
         05gmH7WpGJtLoMjGd0PP5+JcA9TjdtunhRIdQBtmJNtOdWMPY3PDUNKjV2OuQRj02wRu
         2E9gFrNCHgAhqb7OrMQulO63/y7pUy8ylzjW3oyS+RfRKDf+Z4MhKcKYaoW6b5TFWYyK
         3cVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769871507; x=1770476307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UjEvOy2WGDJOvuBTZY4HtZUR5P6Q5ANbgXFoz/CfBwA=;
        b=UANdIPzuvJLp78Fzde68YUIOAwuVWPFayjBONgqLv+FmpGvXZIjtjY1FgMiT1b9NQp
         kO/055JX3bNZzFPBaJEpRVUDv2zIYXiFIj40/2pe8R9NhdAB1TYJPkCYzJ+cTwimNn9/
         6n97h2Z1DsSlB4PboJmgPzFjsUcYniZQeLlFNOwT0fG/KhRTOfMnqB5RFzuNzDKHqTEk
         SuCcwIX8d9JjQbQGoDciA0YfR0kYqSkxlwqDg/snycRnLtu/fcPdzr+zjr+8EACg5Uaf
         wfE2vRCnkER8TMgB5wllzzvmkdOCqSlRX+Qi1cqnZuT/EwNK9UQTd4WIkipkGl6lvNyw
         VxaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVZdZEf6FSgHSaPebytv06M+m+Q8pQwQVZA3jOeA0XqMixh/2awJ4QJQ4KHfCmW2kmYjZ9cDxSkQ==@kvack.org
X-Gm-Message-State: AOJu0Yx77xmDzkeAtNyok9tiGYAlzXk5cKDc4mRxmdlWT9/HVfmHWfod
	FWsR/kOg3wV7ZRrOt8S0ugEjXfUzv2XFzohsLJBhvBROLjg0lWnt1FZKNXDP/eFsAJNmAAhh9yU
	NWHwnq2Putnsq2BhVOq13J66mdnlhDgJz9H7wBLesOx/yRxbRnls/pNqnen0AMu5GpbcdjaKMVO
	r/YEKxCv0/BXvCLYhBFnD1P8UqBaHS
X-Gm-Gg: AZuq6aKQKJAWs4NU4gYLfPYRskfed9VUMAx824IExePz1hisqKG0f4GYEiSw3QDW6c6
	6dQsX290H1Mi4z/8cP9yRaUuRr9cw2Y3alIGnLCwBmhHO1rzgaH8UKDEQeu5tEmTpAxABf/zaqR
	zwqQY18KEttkKbjvlmIQuGh/yLg+65XrNC3PjgXsIaGPMBeGgjCNL9irUq7Aq6Q82/PQo=
X-Received: by 2002:a05:690e:4107:b0:649:7c5c:88e3 with SMTP id 956f58d0204a3-649a8547db8mr4403458d50.95.1769871506940;
        Sat, 31 Jan 2026 06:58:26 -0800 (PST)
X-Received: by 2002:a05:690e:4107:b0:649:7c5c:88e3 with SMTP id
 956f58d0204a3-649a8547db8mr4403441d50.95.1769871506570; Sat, 31 Jan 2026
 06:58:26 -0800 (PST)
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV> <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
In-Reply-To: <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
From: Krishna Kurapati PSSNV <krishna.kurapati@oss.qualcomm.com>
Date: Sat, 31 Jan 2026 20:28:15 +0530
X-Gm-Features: AZwV_Qjt6-X-XbfNyo2_bleHjewtRG1qoA5gEXW9Hu9LjqRyKmxz-97xcVzcIio
Message-ID: <CAEiyvppoiL2EiSmVvNV3DEkr7wwyC1Fbwhm14h7Rfus4Z8uP7g@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Samuel Wu <wusamuel@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
        brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu,
        neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org,
        linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
        kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
        paul@paul-moore.com, casey@schaufler-ca.com,
        linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
        selinux@vger.kernel.org, borntraeger@linux.ibm.com,
        bpf@vger.kernel.org, clm@meta.com,
        android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: PQSjBbhcWPpgRMmZyt1-NLXJe12E6tL5
X-Authority-Analysis: v=2.4 cv=TtfrRTXh c=1 sm=1 tr=0 ts=697e1893 cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=1XWaLZrsAAAA:8 a=drOt6m5kAAAA:8 a=wEBb_YokH4NsbSDSc3AA:9 a=QEXdDO2ut3YA:10
 a=uujmmnXaIg8lM0-o0HFK:22 a=RMMjzBEyIzXRtoq5n5K6:22
X-Proofpoint-GUID: PQSjBbhcWPpgRMmZyt1-NLXJe12E6tL5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMxMDEyNSBTYWx0ZWRfX/ny/tL1mgk6x
 odgoT+pUPhzR0DHIsn/uClZ2DIXi51U7NWviL20bgT4db1dIb8rqd9WqKpncEqc/h7Y0WjeoY5+
 4fYkLOB07j08NJ3E+jLm92nlYx6/Jad72GBWHzc/kY39JkKlprS6kyvioZA4Uacqc+CkbAC4c2b
 1YQvLizR4SL8nEfgSCpgEwTgYCTttI/+LFxxHSWGc9yYXD9HvDvXw2cHUCg5ksxBqvp/JXrEEP+
 +RHWnUeeEHoVF48Yn8Fv/W1s1g1VrDhb/58YfyhjTPdFGuWYYMcz9U928J4Qx8Zu8Y+AEiqR+UB
 FDGxR/OGl/VwKHqBeAuO6XrdSaWScPQJpe66Wh1h7a7cscp5v/IuzwiFAuZUOAtNcSj/zS0gzEe
 JPkS/BnQwjOA0nnVxdSGY+sa5CJcWyHPve2XBrrvycjpgEMD1p1Jo+vU+VNUFwoCVIXuptagraf
 itJ0Y12sfkkOevOpbyw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-31_02,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1011 bulkscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601310125
X-Stat-Signature: uhbjruwck4oxnwieun1se5wcoretfudt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6015810000F
X-HE-Tag: 1769871509-608762
X-HE-Meta: U2FsdGVkX1+KGCY/vZjYOAa4+uw1KDfHTvD9w7MD03EzOSlSsDPZJiVDv80a9Gos6wsKMj+yFzsBgTxydfENmnWl7vplYH+mC/DjWK1deeeyaGJtzipT4pEq6rWYJvbiayBR6IAd//e2ZEg+nCJOE0OeT8+oiPthB+t+gFNlZFOSj2P1GzBZmpCwETkiJ74kBIuObSYa7YZb9/W9R6kQlgQeIxrDYFJO2/BoL91Aa8did2zOcqGoTMVHxuidUPke8GDqQBgTQEt7VwTvliZ455f8HmA9lU39Lwzw/Ni0x0ydiF4y5oDdLtNzv7c9hfOUdZVlqfmLcrDhGJIFrYARWOD7LV4z8t3USk+2zpmRn3PkB0wl56T8PbDjUwkTYsge4Oc1vcPcGxeqF/Cr/AUZWYz3cg6F4MJPLM+k/QVbS6fazE+9BivTTrA84IHd/ngtxJcy09WGB53xyeRaBi/yb9/OrQcOv+vNtrKeQx8Li8KfthZLhU2xxgnLQ9nWYW46qiS6zoVW0H9X0gLpCIWJ4v/2+aAyAoRybULx7YtEapxivUDG27+izKoik83TwtzvqAd6ohcqRXlYXAHjKEWjJJfjTPeIB0R1YDeXE/9BckxQpk1Bq9TUlumoJi9VeHtF3Ps1QauwAYFQDoPM5J/O/I5z+wFo9xBYXLsMuySgow0EkWF82ZxDaDUUxWJFC62xt87MOHeKfPrOTLky4Rc1CEc8RJruep5NjoX83oqbFC/lZ/j3JnQQVOu5p9SSNanXFPsK0RZmE3J/hFzVEmNbIoY/ThfIyn4HG6qaMSjreNCzHpa3HatfGosLoPXjyqs0XRz8l/Xr5CTkBl+E2YUJoVvdIAF4qzjAmCMNMJtUkL0paXrt4j8WYxfma3+LjaU2vtAmoc6fuwVzzQG7OrpgMwuB6WqXJUY7KNQ/Vs8w3Xx4JDERb1Iu86drx3RyE0F5utG+irR9bXUqqvAy7QF
 8JBBv7wm
 8+0mENoI6y1PXiIELC8LFw9a/Kkja5zNxXOEvbwK+bZ3Zs46ImeLtzxTldwk13Ksuy50TB8zglkZGAxL7YaItcv3pGcLpIGyzbKLakn7TfqcWIsucW2uXTa1ieE+BV9XKIm1vm53zfQTqcATpdYQ869t85CVTnV3B3xvzvbzMYTWzT1Xuiz/FbxMDUx+biWA1CAOrzBSEtB7GhHQRncbayRum+pK7Ms8aIqpcvkmoh2wXGrqMpvOYxeEIZzaRPppsvrs8DQ1c2PjUMqx1vhYK45rYzcBcK1faRbyxVNZNxXca/PX+F0CjriWqPmHaRADgtMfoOXLm6iPDEtLN4QwOczUtwSMzhqg6WxlZTHajU5Ry1sU4IFdU/iAFC0t0JKxmblogYZ4JyWTLzKlio4r7NWj9yCXeLp2RflRjBtZ5P3l8vtSP0IrKr+7ATdVXFdi+rvUypLmDXtRTv1hf8uCKFbEzIOOJZZAG3tTQ5HptXwZus1c2/Ex1i3O0oZKVXTq2DmCB9b/l4Py1dQJzqnK+MyttYSZqnFgvEMbalMPR+8aT/TB5MWRX4hLyoGcTjYksprwBCuCNU49c8YNezY/jAAcfv4SLOFj71Qe5VfwHMVExjAAnG4iMG3AIled+40wECIYX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 6:46=E2=80=AFAM Samuel Wu <wusamuel@google.com> wro=
te:
>
> On Thu, Jan 29, 2026 at 2:52=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk>=
 wrote:
>

[...]

> I'm exploring a few other paths, but not having USB access makes
> traditional tools a bit difficult. One thing I'm rechecking and is
> worth mentioning is the lockdep below: it's been present for quite
> some time now, but I'm not sure if it would have some undesired
> interaction with your patch.
>
> [ BUG: Invalid wait context ]
> 6.18.0-rc5-mainline-maybe-dirty-4k
> -----------------------------
> irq/360-dwc3/352 is trying to lock:
> ffffff800792deb8 (&psy->extensions_sem){.+.+}-{3:3}, at:
> __power_supply_set_property+0x40/0x180
> other info that might help us debug this:
> context-{4:4}
> 1 lock held by irq/360-dwc3/352:
>  #0: ffffff8017bb98f0 (&gi->spinlock){....}-{2:2}, at:
> configfs_composite_suspend+0x28/0x68
> Call trace:
>  show_stack+0x18/0x28 (C)
>  __dump_stack+0x28/0x3c
>  dump_stack_lvl+0xac/0xf0
>  dump_stack+0x18/0x3c
>  __lock_acquire+0x794/0x2bec
>  lock_acquire+0x148/0x2cc
>  down_read+0x3c/0x194
>  __power_supply_set_property+0x40/0x180
>  power_supply_set_property+0x14/0x20
>  dwc3_gadget_vbus_draw+0x8c/0xcc
>  usb_gadget_vbus_draw+0x48/0x130
>  composite_suspend+0xcc/0xe4
>  configfs_composite_suspend+0x44/0x68
>  dwc3_thread_interrupt+0x8f8/0xc88
>  irq_thread_fn+0x48/0xa8
>  irq_thread+0x150/0x31c
>  kthread+0x150/0x280
>  ret_from_fork+0x10/0x20
>

Hi Samuel,

 Not sure if it helps, but Prashanth recently pushed a patch to
address this vbus_draw kernel panic:
 https://lore.kernel.org/all/20260129111403.3081730-1-prashanth.k@oss.qualc=
omm.com/

 Can you check if it fixes the above crash in vbus_draw.

Regards,
Krishna,

