Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC37FCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 16:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C62B66B008A; Mon, 22 Jun 2026 12:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13A66B0092; Mon, 22 Jun 2026 12:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD6C6B0093; Mon, 22 Jun 2026 12:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8B546B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:45:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53FC38C7AD
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:45:32 +0000 (UTC)
X-FDA: 84908124504.29.0C63361
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id D5D5A160017
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:45:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=OgqViIyl;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782146730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdMma0yFZmweYohmNWNZydRh/c/N/8MYIz6Kz390Uw8=;
	b=LLStU4EDbkkFI0wMRMexZJHPwg6x2lQrKH3f3JxJ5P6wrzmmnN0TrOATpZptrU21XPQqHo
	MFkWXQqRGpaTYMzFGb0EQBMCaHV+lduHP36IxOtsTIe35dA1cpbwWWgGS4pLAmiyVbL8yb
	V/Au/mscneVe35WCZSnDC8QTpKqMlCI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782146730;
	b=X1417WPytaH7h5H5j7vZsEH1WFHbM4tFz/doIZgwyz6zpvtKI4urYWKA/BnqTTNBGQN8tE
	zCCsANt9GdlsEny0JADtpS6LeBdnJHLk2UQhBhXxr+EIm0g/a8UrMmRxvyaHFinEaC7Q6J
	hRjmlKOEZC7MW3vSBqxJ68I67S8Ew8I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=OgqViIyl;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MGjSnV2361583
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:45:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xdMm
	a0yFZmweYohmNWNZydRh/c/N/8MYIz6Kz390Uw8=; b=OgqViIylG77wjYnZddWf
	88YfH8KC/P+mTnqfevI0Too4wjycZ3p6FDhKIuH4gSeU6WIqYUin9SIwCTR6PaKZ
	045ca89rm3XjdDbD88fhES2ssfW6qKxDwQin7jbln+eDXhZkvt3rzuDRgmWjHMRt
	bXYHTOkWmIAFxgnpV4zpM7IRvRFLSqvlRe9rO0LhHgRiw57Lo6kU9bc2l1P547kk
	e9qbhjV/IUmE4cBLJp0ph0MjvifIWO9Cbl1cu3blssXdXcGOmioJG41eIAP7Lg8m
	yUF+mqa00i0REXrcqjro2yGFuw1WO8p8bDvLjCkeQhbdW59jQV35RatkKdld/Er1
	Cw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4exktt60ng-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:45:28 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-517d766e05aso1911331cf.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:45:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782146728; x=1782751528;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xdMma0yFZmweYohmNWNZydRh/c/N/8MYIz6Kz390Uw8=;
        b=kFvPuB+ciIU24ZieOJpqMbTqJN/0BZDJXl1je9p/8XznzwLfW2V/xBM5C9L/sbB02n
         Eihz7wGm+2NWE3/0CUiVRvUdOjj/eSamxMFjjZ+YrG4ZazHhX2qgAaCgtOqarC2fTIxF
         D0wcwFl1Z1XiBBTuDz06tgtGtf1iDi+Hjf0c+IM1lA/1k5O3Vv145gxOb36Iv05+rlsf
         57EB6pvVpIeezvVwCRM0YgjcIVAmZwwjCKz5wAyzSiHPpFEeTm2nl31+cyMeaEPS9EWU
         i+YtuhTZYkGWbmLhTroWkYHXKth1wEh48evEsyVq2up/L/8AVTyz8Qt7t2E1fUDoXUDJ
         ESFw==
X-Forwarded-Encrypted: i=1; AFNElJ8SoHdjq2O+zzkHddG4Fxe+tJc35g/68Oz1m8GPXJdZAN9YU7LLTJ3QBusgwLCXuj0LGJkNc1yX0A==@kvack.org
X-Gm-Message-State: AOJu0YygZDEkz8CWa/NpSn2hOpW9LlpCJyn4YNxcrqU7eNB07qbvgs+d
	ZE8ZiG2dtD3vCql6J+tYLk9PWoteOYF9cguSYk0vg5uFncSmjwhdhD5CWM4DPKcrcgxg/cse0za
	TlRm5w7D1SSAxw0GS7zqxOXClHC9cpI6/BevAy4hUmuRmVj11
X-Gm-Gg: AfdE7cnsuysDmfJbul05bu2LTpUT7Ov1F6iagf1Tr/sWg8sRmB8Ore6x1IXeqfqgDLB
	vR1ii2UYIfK/aoti8LnozZAgojDjNJMx9+G1iD7Z/hDZJLE6eqyl8bbtIeSsxeBzFQN4O+DCiM+
	VNGcAmWLvGPFsOA6ax7BHe6aLOPhcknFtBRolOkgceKRABf3v2WnmVcwGLAF05epAU/K0xcNLTV
	QS2AQ9nbk7biui/SH5ndKpf2xZMfg++jiuX/rYmiVkZi3PyRv2RKkHDcXLTJLHEpfwpft4pnYHv
	/MWPHKca5lVMB0uh+kS1nOKF6DEP15LbIjUcPqSX2pNfNH7bE7borgNnmysg539UycR1ZREVUPO
	Zspb1CUcAyQP96pwGEf5IXpfz1GvH
X-Received: by 2002:ac8:5703:0:b0:516:ed2c:9c75 with SMTP id d75a77b69052e-51a51a9be7bmr4274151cf.16.1782146727895;
        Mon, 22 Jun 2026 09:45:27 -0700 (PDT)
X-Received: by 2002:ac8:5703:0:b0:516:ed2c:9c75 with SMTP id d75a77b69052e-51a51a9be7bmr4273601cf.16.1782146727437;
        Mon, 22 Jun 2026 09:45:27 -0700 (PDT)
Received: from [10.206.129.146] ([129.236.229.236])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a515ccdbbsm2022461cf.11.2026.06.22.09.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2026 09:45:26 -0700 (PDT)
Message-ID: <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
Date: Mon, 22 Jun 2026 12:45:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=SsOgLvO0 c=1 sm=1 tr=0 ts=6a3966a8 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=Ne+/oOzQhjyqTAlfBCchDA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=xMg8OGkpyC76Z8KfPXcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDE2NCBTYWx0ZWRfX/eSW2feA2EGw
 8UUvQ/dngTXMCXRJFfvPfPKHTlDQVvD+rCge1jZgf1O7GL4e0F7UkkPPNQVCwV85vqF5stf6L+D
 qPQOOIz4m8ssNlWLQWmH000ACwCloGw8J4WC1Xtq6M3NLJC0T1NC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDE2NCBTYWx0ZWRfXxYWUAIf53cG2
 vdVYh28VVtp7oeMxKG/GBsDj9bH2nU4jQVWSk+vl52XcG/n+jCXLf9ew4jOs9GvlYd2B+n/dHks
 3USS5YaP/RZoD3ex0H2i2a8tOIkI6H6yGJ2s/M/wvPLKWZvqKsu5QgmF4iHv4x0Rzgt0lkCG0li
 oehRO1c99KSvQ+s3cPS/rG+jG9BIzy/a1lPWCjB48NBewY5gxGGB/IBpLJK+7ZKiv6gkCzfb7kA
 bFBMOyn/rfOGlVZAcjwv6B7dXc/XgK0QxFmN42S0h12nk97spJl6el9n7pMhkHp068RxbPNrZt1
 TDS+9JOQwJE6rhVGVo6F8qkxeF1uegJ4Tz124UAaw2vkVDjp4Ilr5JkFIDZReoSVaxqvNpLrtW0
 g8kJrjA+A5AnwvuuPe61dvCdl8OJLVrfLIAPoC7P8ibiwTV6Jt4cO1Xj/jTlm8VF/9iBLP49deH
 qBcbF0ThRoBVawV7jKA==
X-Proofpoint-GUID: ZySRx4lUhjNAscUAbytoTxU8NdhouzZ-
X-Proofpoint-ORIG-GUID: ZySRx4lUhjNAscUAbytoTxU8NdhouzZ-
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11825
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 spamscore=0 phishscore=0 adultscore=0
 bulkscore=10 malwarescore=0 clxscore=1015 lowpriorityscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606220164
X-Stat-Signature: c73onns73msbpii5f1igdjjpdhynsxfu
X-Rspamd-Queue-Id: D5D5A160017
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782146729-431581
X-HE-Meta: U2FsdGVkX1+zpUSrEcJiqjP/UmNlSA46r0PO4FKQa3HFFeC7exwz+t00tVK424uCVpWdZ96a3aTO3kZJyktL2miRFU429M7CNP3X5MUIhtFbHO4E0jP8KvpHvT1OIyTy1kOVqtxTU881TM5j/nZvxl4G92D/3ZQHL8sS92gwJlpl7waNEgjvIjy1JLnInZ0Eo/jZXXwRAz/+WSlDbsl2vw8ypWfyTNBVc7ZCUA7XVUHv9rNW+xPiqcJyJ3WWD7EmYXDHNqX1UiFTTtSndXeEySRCF8Dhpq1yNUwXp7h6n6lf98KFm4++kg3a6mN9gSZndC9AAUyi1qlEnnIOYRauz3CfjkdI1IKksOsGdjIqFEgmaYjq1a0biUMP2qH6kaQ5HX17ppZ6WqO81hcBVpdgccy8xUdQFDXETsHo/04IjUPXPZdn4QMnhxjrDL6HyaOLwahOlBnKPXA+3fxGPSNUhx+jxBaTxXi9iGWXN7dN/sv/cL/15ILRfgkZgyBWiyEJQdZRwHlSZYd+zFHOleB2L8CjIdqGI0Y2gJaJy3gbL+CNjBKOS90HguASgM5S7dvtUt44pWQ7jEPDMYk19BPj87E9cWR1betkSfjFCzoHmxXuS5W2AZP5jAnnZcIwLyaJlC9glzcFWWTPGq5jBjW3U8wvhUEdT8ChpZKIlMcxWNrLyocxrwv2nk1L4mshM30gIbRK3PgKQi3MMy+8myibEsZ9qEuGs5pOOYWS+NFtbARqXWz1uYDeyPZnu3w5jwNoA5CbOqav8tjZWa71rCLKd+GVs3lknKaYvT/cAiNv9fXHfsVwyCQNJ/zf5swhMpmC2prUWUCubcf8b4MYbfSuLnikMGsMqu1zjnvxNlbZ8CCl80S3Y0KEef29IeCdvbBs5CsOhf/EWkCNtgq8MkVBK+q0KekNJnM5pfv6bcglWitTlJIupKYjDG+xPD0Nz3VmMy8wyj3X8d/jTpHjR+y
 nqQOPesj
 tMoU0/Qk236iRtXvwOZA7RmDOIXqF6FnV4uARDwDxdL1x36c3kLUYvT1XY42Io13j3UMcncvgZj2NVtZQSZA5clFU0+1mlJu345xDN9V9K8RrW39wTkOfCKiZA92RQm3uJ2sUSw4JMS7xo0mbYlekoVzzxkUUdI6I+k2dVqaad+rBpM8m81qkDXBhSkbfyZDlsrgP4ClR9fE9SdDQqKv4psSIp10MARcuTiOamVfoXJTnLW2OLTibNbzsDfzsxw+9XUgq5vCvSSQf1S1m43XK79jRRDbgvYf0kwQ9vEzAy1huo6pvaqjp0ltWO9KmIhpgf5cw5VCIF5R0QdZ7tGl1o9NEBgTrgvfpPHCyDRvTnXocZvbBI0yJqNlf9/hArAVqU2921NGHlxIw9pOn3Vny7kaITXOypm3CAw1I9T1uHCRaxz1t3YeCK+HqrMMneSv91meegZpLCYq7ejVxzydAjYOYIvOCpt/0S7JO6cND/6jvmVW9moIo90fMCk5PEtdzjVCE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 10:26 AM, Jan Kara wrote:
> On Mon 01-06-26 13:04:41, Jan Kara wrote:
>> On Fri 29-05-26 16:46:15, Tal Zussman wrote:
>> > On 5/27/26 9:00 AM, Christoph Hellwig wrote:
>> > > On Wed, May 27, 2026 at 11:42:28AM +0200, Jan Kara wrote:
>> > >> > I ran some experiments with fio on both XFS and a raw block device. Five
>> > >> > iterations each for 60s. Results below.
>> > >> > 
>> > >> > TLDR: Removing the delay doesn't significantly decrease user-visible
>> > >> > latency or otherwise improve performance, but does significantly reduce
>> > >> > throughput and increase context switches in some workloads (e.g. C).
>> > >> > I think it makes sense to leave the delay as-is. Thoughts?
>> > >> 
>> > >> Thanks for the test! One question below:
>> > > 
>> > > Thanks from me as well!
>> > > 
>> > >> 
>> > >> > Results:
>> > >> > 
>> > >> > Workloads (all `uncached=1`):
>> > >> >   A: rw=write     bs=128k iodepth=1   ioengine=pvsync2     # XFS
>> > >> >   B: rw=write     bs=128k iodepth=128 ioengine=io_uring    # XFS
>> > >> >   C: rw=randwrite bs=4k   iodepth=32  ioengine=io_uring    # XFS
>> > >> >   D: rw=rw 50/50  bs=64k  iodepth=32  ioengine=io_uring    # XFS
>> > >> >   E: rw=write     bs=128k iodepth=128 ioengine=io_uring    # raw /dev/nvmeXn1
>> > >> >   F: rw=write     bs=128k iodepth=128 numjobs=4
>> > >> >      + vm.dirty_bytes=64MB, vm.dirty_background_bytes=32MB # XFS
>> > >> > 
>> > >> > Mean ± stddev across 5 iterations:
>> > >> > 
>> > >> >     metric                     delay=1           delay=0     delta
>> > >> >     --------------------------------------------------------------
>> > >> > 
>> > >> >   A seq 128k qd1
>> > >> >     BW (MB/s)                4333 ± 27         4374 ± 34     +0.9%
>> > >> >     p99   (us)              36.2 ± 0.8        35.8 ± 0.4     -1.1%
>> > >> >     p999  (us)               3260 ± 75         3228 ± 29     -1.0%
>> > >> >     ctx-switches          184 k ± 59 k     3.68 M ± 65 k    +1903%
>> > >> >     cs / io                0.09 ± 0.03       1.86 ± 0.03    +1888%
>> > >> >     avg bios/run            80.4 ± 0.6         1.1 ± 0.0    -98.7%
>> > >> 
>> > >> So 1 jiffie delay is (with default HZ=1000) 1ms. That means for this load
>> > >> the completion latency should be at least 1000us but your results show p99
>> > >> latency of 36. What am I missing?
>> > > 
>> > > Yes, this looks a bit odd.  Unless there's multiple threads submitting
>> > > and somehow the completions get batched this should complete one
>> > > bio at a time and be the worst case for the delay scheme.
>> > 
>> > Sorry, I should've clarified - the latency here is the userspace-visible
>> > I/O completion latency (i.e. fio's clat value).
>> > 
>> > I ran again and traced to get the actual time from __bio_complete_in_task()
>> > to calling ->bi_end_io(). The results match the 1 jiffie delay now:
>> > 
>> >   metric                  delay=1  delay=0
>> > 
>> >   A seq 128k qd1
>> >     fio clat p99             38us     36us
>> >     bio cb p50             1.23ms    2.5us
>> >     bio cb p99             4.13ms   1.44ms
>> >     bio cb p999            5.01ms   2.63ms
>> 
>> So I'm clearly missing something fundamental as I don't see how can fio
>> reported IO completion time be lower than the end_io callback latency...
>> Ahh, it is the strange meaning of clat in fio in combination with sync
>> engine where clat means: "how long after the syscall has returned the data
>> is ready". Which for sync engine is immediately so the clat number is
>> meaningless. I think reporting 'lat' numbers from fio would make more
>> sense but whatever.
>> 
>> The bio cb latency indeed looks like what I'd roughly expect now. And
>> notice how the median latency of IO completion is 1.23ms in delay=1 case
>> and your throughput isn't abbysmal only because writes end up accumulating
>> in the page cache and writeback infrastructure ends up submitting a lot of
>> writeback IOs in parallel (you have ~80 bios to complete per run which
>> amortizes the latency to decent level).
>> 
>> However if you'd have IO that were to use BIO_COMPLETE_IN_TASK
>> infrastructure which doesn't have so many IOs in flight (like direct IO
>> with lower queue depth which has to do extent conversion on completion),
>> you would very much see the latency hit on your throughput as well. In the
>> extreme case of qd=1 direct IO you'd reduce the throughput to ~4MB/s.
>> 
>> Now I'm not saying the delay is bad - it is a tradeoff with clear wins in
>> CPU overhead your benchmarks are showing. I just wanted to point out
>> there's also the cost side which your benchmarks don't show very clearly.
>> So we might need to keep some stats showing how many IO completions we are
>> offloading per second on each CPU and switch to delaying the work only once
>> it crosses a threshold like 1000000/HZ per second or so (so we at most
>> double the IO latency by delaying the end_io callback).
> 
> Any progress here? The patchset looks really promising so I'd love to have
> it completed :)
> 
Sorry for the delay - got caught up with some other work and had to set this
aside for a couple weeks, but haven't forgotten about this. Planning to pick
it back up some time this week.

Thanks,
Tal


