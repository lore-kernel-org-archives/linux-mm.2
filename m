Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1351FD9E29
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB0C6B0259; Thu, 26 Feb 2026 19:44:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FD96B026B; Thu, 26 Feb 2026 19:44:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174F46B0281; Thu, 26 Feb 2026 19:44:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F06C06B0259
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:44:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9055CB862E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:44:56 +0000 (UTC)
X-FDA: 84488391792.09.1C83AE2
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C759180005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:44:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=i1OndWU+;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772153092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7pDkBpYJ27xEgY18ooGDGOhBD+yHFwQylYRdDgNI+M=;
	b=P9Xv77E9s2eA0DEfqSlUPMDZcpfHZy3kYObCWMULCqlI+LTMTHcu/VLiGx6UdR3cUpkUib
	DsQhqZUBBea76jK2m8pQpHmkPFJAJKuZV5fK5z3be32CM3nMuGvDiQ7Vh34upnIiybSNA8
	B/Ss8aNQXHIPnBPqe1yJFGQeWvaiB8A=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=i1OndWU+;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772153092; a=rsa-sha256;
	cv=pass;
	b=u6rMJpnRjXwt0VR3yFu7m9QU8Zhc44RhHrAJg1PaN2SAHscuRjZ3IWAF0pFMB9RaksDpPD
	xDlLqyPF059bpPG12Zl+XQTT1gQ5nESR5U6k0A7NQdu4Qb5dgNEiEUn+ot1hPw+0RX0FP1
	JBAQb9SMAbGtUq8hxTjn7rethJUKVvw=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61R0Qxok3740028
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:44:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=X7pD
	kBpYJ27xEgY18ooGDGOhBD+yHFwQylYRdDgNI+M=; b=i1OndWU+3hVbPOhJLPdB
	3dZ4nSkztb1ikKbvdbatjVGkVMLfV8JFZoIoELwMzvOYxfwUR6nLGakr/qfu4h1Q
	GO8wKJ8wC4UazfM1LbiYLaf16jQ5TxOebgu7QRs3IVlvCrkOwzJVdNdZd6DNe2SA
	UyzFa/gtDwTBn+WHSFtqboptIKXNMRyDXiRy1/HJUeBhpCt4ysnry1Waeo2FSSbr
	T44fjXhU7o2QxsSczc0EG487y0F+MHbUzU5UXRAbhPw2wSNZ/rXct8p9OvNCLgVx
	J8CkKDZsIksblH1voMgwtFzQHi7YdkePQnLp9goufCO+S9tQvuISr4koC2RoM7Sx
	xw==
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4cjhx874g0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:44:49 -0500 (EST)
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7982c3b7da7so33903737b3.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:44:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772153089; cv=none;
        d=google.com; s=arc-20240605;
        b=gYHz2wzYvrNWXPAuLxiqk/VbvujpiJhTdLa5/fn7p2MUU5m1Lurqujtx8WVSRCPY/A
         Epb2nHOxAyTCMJc2swZJoF4TqhgZvCsyOUnrH2EENqgbcSliGs+93ecOecdv38LdDe+i
         eBmqjd9VLko6GGy37ssmRcQADeogsTEvwcK8o8l6fXrgdDN6QrbmpqzDbvI9KFluERxs
         dyyvXNhIP3FtjykFgJyxBn/M1A07VgBGBiGJGBX9H2TowwCm1WJCzjfzuMuf6rTgwygl
         lKstwFDynk8ArZ0luhFSGaPIlHwbLZJEVQli/Kn0fib5PG1oPqFkwa8Fcbqm85jIEGWo
         2yQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=X7pDkBpYJ27xEgY18ooGDGOhBD+yHFwQylYRdDgNI+M=;
        fh=n8s5IgeTGQyvbkTcsO4mbNxSV5bYT7aX3F96q8H5IjQ=;
        b=iUItE2muCnhqfoKE6V/6EXvYVsDJUREjVXdouOp6HxZiK5beiKny5EfvwYNVmfSIv8
         rTa2CIsRF/Vf920MBx/UjQafPUFlvPbWiTZvwBiU5llkc0Mz/8UK1QiP1uAbrbGkODIw
         KHn5F5bTyOt8zi71ZR40Aam+LUNfdggAiqi1AyhxqRYBnSKvHXH/OgasQtDimx/RAs9E
         ZGA7D+Vbf0LSrFuueaveYiJLInEL1tS8dSssudKwqxq4eQAQP4Gr4DeSHnJ7KHTzGDt7
         LZyfQnX6ppL35K5M1qX7PEXVEGXuS9UkNrsW+uWJVxlFf1FGkKK913Gbmyv3JZ+ezF+V
         gs8w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772153089; x=1772757889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X7pDkBpYJ27xEgY18ooGDGOhBD+yHFwQylYRdDgNI+M=;
        b=BRuSOIClritie9TuCyi1ZcyL1JLo0XVzYfShCVsRL7PJS48EOycEJd6Kp7dNFn2C8y
         FdVynbAVSG8URuHwHsXKmF1s3ZheN37uYWMUPEU9ujZtTUX+p2JfjnmS0x0gcu/YgBAI
         BQIWrTUBJjWZc/UiU5sCqXtGn6A8WRWiOlXHo3KI+0Uzn+ppri/GZPqu838mZbQ6OdS+
         g7UZzBa5oWpaXiZX3ZdY2njQ6lXTMUaa78AjaGd/HmCBQWRnjluvS5JWhfgmb4sr2LoB
         IIYR0kpMn448jOAghDEtVAmrIf50A2xI0QwKSB7StkV+yJ7gi73sBmAXC7rBwO0bdq69
         qh9g==
X-Forwarded-Encrypted: i=1; AJvYcCUMfSHW/uq/jMdBF3zGsamVqhqU+x8mlL/6CrIGQsDcZ7PxqghY8H0cwRlOHRzjgvquqwEOxMtn1g==@kvack.org
X-Gm-Message-State: AOJu0YzZDvvx4s5XcWjwB6Oqrvta6PbH19ePwKhLFDg93rO9KcrjC8ui
	t0tl34dM85MekjIRv+HVySUOoQ4P2LUsX3R7sVS1Zr6iuYnagf0EzrJrAFWEW0QMUMlXo7AOx+4
	6SZqE14KX7D69XPaYVcsCgXqrOO2Ndf4e1f3bAEIDkB0epAn60/ogVRULbEarQdv0j6cNdxigMe
	9g6+W9IT3wyZksO61mFoFUrj8=
X-Gm-Gg: ATEYQzzE5vWPurH6rNHYU1wVeWi7vRKnDA+zA9OPNFGFaCHODRkWzWM9gVK1n3awa75
	EHEZqv+63jRxUIe5hJBv5iyfrIvgOk3UiOVFTZWxECECkf7bWdNOvTFcz5ovsbeUVBa9+WuJS9c
	C+HJXnCOtsZOxmxneprBa3I6tuu+47y+WVQkKx1dI6maCUB6kJb9BMNQIUIHnf193/6OndJKzpH
	j5AJw==
X-Received: by 2002:a05:690c:f16:b0:798:6401:fd1f with SMTP id 00721157ae682-798854a7e4emr11636187b3.14.1772153089301;
        Thu, 26 Feb 2026 16:44:49 -0800 (PST)
X-Received: by 2002:a05:690c:f16:b0:798:6401:fd1f with SMTP id
 00721157ae682-798854a7e4emr11635807b3.14.1772153088806; Thu, 26 Feb 2026
 16:44:48 -0800 (PST)
MIME-Version: 1.0
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-2-70e7ac4f7108@columbia.edu> <aaDEEjVKBKrLxsht@infradead.org>
In-Reply-To: <aaDEEjVKBKrLxsht@infradead.org>
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 26 Feb 2026 19:44:38 -0500
X-Gm-Features: AaiRm52uN73WQ1q0q0Bsy0nLJ7MoTUQc88yWQcbleL3GQlPfTUc323g8dJKyM6s
Message-ID: <CAKha_sonOvAGriyromHtyRc-VY6Zyg3J3zd9UJPfBOAt1a522A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/2] block: enable RWF_DONTCACHE for block devices
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Bob Copeland <me@bobcopeland.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        linux-karma-devel@lists.sourceforge.net, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: eskFxJ-FnaWznU1O65odDNgDkLChLiWW
X-Proofpoint-GUID: eskFxJ-FnaWznU1O65odDNgDkLChLiWW
X-Authority-Analysis: v=2.4 cv=KeffcAYD c=1 sm=1 tr=0 ts=69a0e901 cx=c_pps
 a=g1v0Z557R90hA0UpD/5Yag==:117 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10
 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=BpGzv1V74M3SfeTrGa8v:22 a=JfrnYn6hAAAA:8 a=lVyRQGvDAGr_LZokY8wA:9
 a=QEXdDO2ut3YA:10 a=MFSWADHSvvjO3QEy5MdX:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDAwNCBTYWx0ZWRfXwpvhRhewGT/S
 mM8QwmsbbLFUOKZKZcskuAOsLudRU+vnhXRWUDBztYaKrzfhBv6m+RUqJM8SwQDPlWRjg9K/odt
 Tptdp6g0am0gY8TOQLG3EsOOi5gNevBs4Nxig9ARvmf3jBIsliReAm8I1zX8+jRVdsnmPIRTFLI
 ZpVQSsqTg8jFLMjzK4b/uHyiS4ANT00BNFsWFwwB8RU1FrLWOFtrrGTXMnXnrPVfim//YwG7H4Y
 CVuGULUkSDprAAB7rDd3pzBUo3MgYlhVLI52bMTCjX3yJP4xD3yvlpsPYeCwPCorbCi8pLk53E2
 /R2cw/ee7dAwVimoeheh0PVuPH+99pmLAvePlzNsgl3gWvDNrlqApeu0BmYKD7mv9EONP15qVkZ
 FpuPdGPPLZVRUN6+f70R4RU8PAdFd5gepFpGhn80Ujv43m7S1B07314k0cXEps7A3BneYm/iGxR
 wn1vzTYiQjfw659gR4g==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11713
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=10 priorityscore=1501 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 impostorscore=10 bulkscore=10
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602270004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C759180005
X-Stat-Signature: p6r5839ucqcinkpbhncrzfi9g5i7sqzb
X-HE-Tag: 1772153092-89101
X-HE-Meta: U2FsdGVkX1/97dORHOGOv9GBZXSIiv79s124mAIJTV3C6NCskFtcdUL13HMI+JLCaSXIndjOKRjxMBgSQbnZxGoyDiUHPZU8C7nFY6BGwITR1BX4Gq6MMM2N0OAjuXpx+eHxH97YhSH0bIdhTvEtMWqQOofQ5tmZAQTPz+eiqHQ1aLcvzazUfCS+A6oKGYb6BTbZmZdjT0R6NHGHOqYu90rTXiivSNWHbc+2b+idT5hSC2ukQKARAZejnZ4JY0Gu8Q/LtJIHk8OJwHNPirJM8pKE91+jjD9uvAkJyWnf0tTmHYuOJt3jka62QtSi3JPS9+17hdzKD4f4RhBZ9VV0NeVWCxEaIOekDhRzbrpZ4KpdsujjMMLjg2H9lSyt33sNL/YRRbLxZzH/YB1E/Vs+Hrqt97jagIavX+YiMz+4FaeQbSflJ/F8G4zqHZpno1JOU3O+tPfUzBauVcVBIqDRz3l3YqvvPWJ8n1VMpjuE8dPXEoadFMw2Vy5uPTHk4UA2TIu3q5oMwB6rzUpo51RvCP+sLTygThXPIxDD4hKdTCuOrTSttmFPr9AKGnxKdHgjaLO4YaEKNYPxMtzO/IP4eFAjQAUNyV364ueaKzgWK7Yf60FVwd5p9/jfYoJYtV3CnF1PU7OufBE1wIu0n+4hOJrkmLTpy3Lndf3u7IQVgVsLr5VvRntA7swiCmQY6WKNQ9V8WRCqe6HNML0wq5CRt+qsZL7raZn4mnw9hx70HnMPwpV4yKy4KqwxD9J3BdApF30DOXXYtbkVhI6XAtIEny+1xmEoqgOC44+Lm+ABt8W/xX82UUrOj60eYOhLOETGVsnzOZFc+tMtQ1KEEJueIjDECF02eMbDGwDW3vJM1cVFLzPiQ376/lBchAVLEuSjtdqcYcpiO1I5syDZY86dud9J6Y9yGu4mgzMI64k2CaSG0qmb9vZMkdLs895OKy2gHllfaWsovPLAZoIj0mg
 8L+fw09U
 VKja62Ve+2UStOB2Ck2P+sPNd4N9bisVBOPolwpFNLSd3zjlVQwYQBZmbhobmCYHaHmAbdpfTzzmX01VOeD+doEIyW8A5yj58wnzaS+Cs3kW54kHjTKUXZ+rwSdhvLc1GdzDRDet2cI0DvaFOt+SboobUpNwdgBI8Oh9Nusq9zsCmVa7ApDIsnvNTLAhLQoKoA3avIfMJE1bwnCQJ7d/sKOzhPimx+u4DGHopRtOnLZzi1p6YpQNjgUcvOSr9/lzdnJU4XAXAtRxSjDlPjw30WbPhervPHEz48JNdsulwUaS+yXYrqxmDXjqKzeSclQpc42ffVn+5vaOSExMpbG7NIu9dKxZOqgnJl8XAbiLNr8lthQnsNXQTSZd391VSKZx7mkueOZ1M75zq8cVS0Mug3EMhnxEW4yoP4y7CGuQzBQSLtuwePGUmsxEnhhlIK4s7hR/ZIhloSih6Dilr8tpZzkiEOz440/1n8LiXWd9Be7P3v+BWI5/DMR83C1OG83jgOVkIFPq1VLDg4qoGcCAUmVsbItr0kfu+b64JAHR1FLOnxYPNibA4BHqC2flbHKEX+vR3pxcZlWDENeMBfaXoCopm59ABGbcrHpB3qNVi8PlVZjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 5:07=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
> > --- a/fs/bfs/file.c
> > +++ b/fs/bfs/file.c
> > @@ -177,7 +177,7 @@ static int bfs_write_begin(const struct kiocb *iocb=
,
> >  {
> >   int ret;
> >
> > - ret =3D block_write_begin(mapping, pos, len, foliop, bfs_get_block);
> > + ret =3D block_write_begin(iocb, mapping, pos, len, foliop, bfs_get_bl=
ock);
>
> Please don't change the prototoype for block_write_begin and thus
> cause churn for all these legacy file systems.  Add a new
> block_write_begin_iocb, and use that in the block code and to implement
> block_write_begin.
>
> And avoid the overly long line there to keep the code readable.

Will do.

>
> Note that you also need to cover the !CONFIG_BUFFER_HEAD case.
>

I don't think there is a !CONFIG_BUFFER_HEAD case. The only user of
block_write_begin_iocb() would be blkdev_write_begin(), which is only
defined under CONFIG_BUFFER_HEAD. !CONFIG_BUFFER_HEAD paths use iomap which
doesn't use it. And buffer.c is only compiled for CONFIG_BUFFER_HEAD. Unles=
s
I'm missing something?

Thanks,
Tal

