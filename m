Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393CF606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=eqG+dkL/;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=mbGz2EY9
Received: by kanga.kvack.org (Postfix)
	id 589706B05B5; Sat, 31 Oct 2026 11:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53AC96B05B6; Sat, 31 Oct 2026 11:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402086B05B7; Sat, 31 Oct 2026 11:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 133306B05B5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:48:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F36FA0A05
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:48:15 +0000 (UTC)
X-FDA: 85383352950.04.C05CB61
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id D5DDF80006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:48:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="eqG+dkL/";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=mbGz2EY9;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793461693;
	b=iMfFIrpY+fvJZdZNU1OdiNYGKIdf9+qGNBbSPI9FcO1p0G4e8k8/yFoC3jwWN069Zt43ah
	fFXu0Xy/vJgsdSf9nw/egqZI7VA00obpg2ep8892Jv/XJjxqOqyfrYxfBFzlJ52YGshpgZ
	Bt3PtXA40HDpyNVQTao2kOfuQ8FU7nk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793461693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0B/Jt4PrkjhDnRBbGsYYmLETRWHMQgnj6GHzv/YqbfE=;
	b=4iC1yY/FMvU4NQpIjq2Eu+9sU6wzhbzdA+jLq2prLhouGUriGaOnomnWwDniviyFO8M95O
	w/lJJEc+jeJ95h1Xmhtvmavk8uesfcV1dS/0oOmi0k80pTq5P7oDp8ZHW3s37S/SnNEH++
	WYLePZhjEkT73DMcJcsc8aB68R0/MR0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="eqG+dkL/";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=mbGz2EY9;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VDkK0B969236
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:48:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=0B/Jt4PrkjhDnRBbGsYYmLETRW
	HMQgnj6GHzv/YqbfE=; b=eqG+dkL/DIdDxKBio1cYT1jv31aCRgvdOlPth5bvUl
	R0Bx03HdiL/JUQFbhUqDPsrxZIg5QRHJNgT7IAOaIQ7HHfX6Vd1vnFOVZD4WCxot
	XbLw+J4fFpzwYVabOPUgbdbC8GoxlQj3QdmgEgBrT7O3P8vP0Ol2gtPunwqsvk+o
	SIQTej/u/GcV0OuoqQ59f4w3OUbvr908K2lshMi05wv7s1gtw8OKM3ZYRBK9PU1c
	E2c54XqfrrL6hSh8D1MqGENTjNgoQwEJKo9ukUbVWUfnxsyQ6lc1AqfdtVTssvOm
	WjciJi+B22MTmMX3CoeLMayuxhLH3GJXIDbJ3t0eHEmA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hn2x2v2rw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:48:11 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f13c143c8so309288485a.3
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793461691; x=1794066491; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0B/Jt4PrkjhDnRBbGsYYmLETRWHMQgnj6GHzv/YqbfE=;
        b=mbGz2EY9whldKaqYZrUHXiKDMFMfsAgTR5cgQ/VREQ2IxqBs9reoa6TTZSZsvTvG6K
         E1I4aYNYmiF+Cjyg2nsnxh6XWki+Fi2fKUagYWVgc4Rd3OV9dNx2BWQZ8k1fKTUu+dFw
         0jfQQSAw5tCEvRpC4s0svHeevVwS/MRtMJlSdRPrwGANFMUfRs9CTfwBN5VS8x/wGk6+
         AqXq6m5iCd+lce/9UwmK79nAU/sFqjndidyWxWt3G37FZFt/8WkU97p1wliXxnmDdMR4
         Azo/tXfTNzpcE8qmMXKJ/2eTh6HDgWuHCM+VTRGld175NhJU4ZMrKgFvvTS1Ccfap3qa
         9NmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793461691; x=1794066491;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0B/Jt4PrkjhDnRBbGsYYmLETRWHMQgnj6GHzv/YqbfE=;
        b=DkI/BGRzhY5go5eMT9/2tj3K6cu1GvjIvGQAUPxjun9zeKK11xIcGH7aN/zlqrmNhI
         rcPU4exu8zJoGYYCuIrM79Qpyu3pp/TXqXBJlk3jZrlLNZ7CL0uLFOWvbirsy5Svyzzh
         ZT9t9xPzKOMGQJ2PL15UOGG4htkaI+jD5l443HcARNEI8vQMINxKEAHNN4Uh8qMMHy4C
         Tnxpul7cKs8SthEioC2n8mUf+XFNUf9m7T3Lyniq+REYCB36QNsg8ukiIdqf/q1JrJbt
         YkYYGR0vDn7autLEFrqgJsjPqXGAENu5J4A5wRYFL5efxrnCK9ZCr80y7k0xOicODlv6
         3Gig==
X-Gm-Message-State: AFq9FYJspe0sq0jkDyE8s1Br6RF02b/LWyPpO3RlXHZ7ebumrXra2IiN
	0UEMWjQRZIhZq7xzDBf/eJAQbzyXsNG08PlBZLR0Uz+M4OIe6nIWm5p2qOSKeH79KZRaIxOTVJZ
	bAgmCQ/OZodg6Zj4U3qI5C6dSKX6om0RPKKkOfNC+6iOoCEWj
X-Gm-Gg: AYBFou3aCxDHXmzXYZQIrD1NjGVON5p5AkWbksfNlsUGq42w3Hb8BsRSh/bumRcdL8h
	a+FVX9EcZRmXxAX6DIiy7dyb9ZxPMdboj+OpuKP3oOMXhRoxuw/fjPx9PLM/cUm5YJfY+JCV/tK
	w7E6SmeT+cyNW2m22rovuOpWzfXdVz1TGhJPAGl607+9bxwL/vrn4lhKGgO7L/X0oF9WXGL//03
	GWtEBf05M31bedTUuHInkyp3L0Wvo5XJxVdpyvRqOmMS6wdU6Ic0TLiUchWZO0ns5mV13cZKWxK
	MiW6e4HAQ2lsWjPonNSJtWond8qnWW3CuNyodxRitkqywVWLK/RmVIcIcdKr0ZB+6QJSIKXQI2v
	rWIg3ENHt2hA0OUHh0aP0APqWJS7IhEj0FRJndygkWRMGk5nacb5hz86vww==
X-Received: by 2002:a05:620a:1d06:b0:944:a46:5c1f with SMTP id af79cd13be357-944217452e1mr861669585a.40.1793461691233;
        Sat, 31 Oct 2026 08:48:11 -0700 (PDT)
X-Received: by 2002:a05:620a:1d06:b0:944:a46:5c1f with SMTP id af79cd13be357-944217452e1mr861665885a.40.1793461690718;
        Sat, 31 Oct 2026 08:48:10 -0700 (PDT)
Received: from [127.0.1.1] ([37.142.159.89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80333sm9694395f8f.32.2026.10.31.08.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 08:48:09 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 31 Oct 2026 11:47:48 -0400
Subject: [PATCH] mm/userfaultfd: store the child's new uffd context in the
 wait queue entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-uffd-fork-ctx-v1-1-a837fd576ffc@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAKMN5moC/yXMTQ5AMBBA4avIrE3Sn7BwFbGgnWFIkBaRiLsrl
 t/ivQsiBaEIVXZBoEOiLHOCzjNwQzv3hOKTwShTamU17sweeQkTuu1EY5lUadvCeYLUrIFYzu9
 XN7/j3o3ktncC9/0ACm7sEHEAAAA=
X-Change-ID: 20261031-uffd-fork-ctx-23fe063a5cde
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793461688; l=3087;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=4VwRN2aXCA+IhJ6bxdAbQ/+gb2gC5RTAIQ2hevD75F0=;
 b=VS5pRjL5E2ZcJ4ee/ZGTrATXKELkz1s6LtsMjvYqAjM7zUNhwY3vw5GE3DpFv97TmyWb6ODwl
 xBtBxSwLNZPCaLWfaSp5pzvFwELwA2t97mg9o+wfjeq+dNQtbeCfwvy
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA2MiBTYWx0ZWRfX+CQ5ZzfLXM7X
 QycJP7mxdQEBKlG1eRz2RPu4lNPsEpjLLlff7wrrR1r2dAkzcgR9CC4MbdnpDDbsBUjhRee3Pd4
 s5fgfR7RLwRqiqPptEk9AQi4icZrofqCmBL09MyTiYMP0iE1mTG45RMImJXIciJdvj/1KR6HMGt
 84HRIbRJZZkgVhMpI5r+tC3iSsgY94LNpOm8wYKROuG7+DxgkAjV5I+DWI5iG4uVmyR1FPpWNIm
 hU+Fx6519xW04o22KzK8LXLD4C4VVHIy2J6QUoiuYWQNz+2I+uXPtMlcSTCQAv/Z47SuLGb1sKP
 WtM+mIyrxz04x5OXVK2KMBUS1xLSa0RM2D4xkqWNbW5K9aK8AvjnPOmbDgeEb8e5Lw7btM7b75r
 i6rTA6znC00cGSXm4oPf4E+FfbRKqx4G+oWQi6bgVTQWmDxUWctHqu/5ghjqMBD+EwjkfslrPt0
 jcuMfc6FterGgxZ/1MA==
X-Proofpoint-GUID: vUhQLnqEnJP_FKM7iESxQl0mzjg-j54N
X-Proofpoint-ORIG-GUID: vUhQLnqEnJP_FKM7iESxQl0mzjg-j54N
X-Authority-Analysis: v=2.4 cv=YLMKWhGx c=1 sm=1 tr=0 ts=6ae60dbb cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=P+xgYyhW+KadpqoI50EQPQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=bMp_idCJdzv5ZnZB5UwA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA2MiBTYWx0ZWRfX/q5G+qpgcQjR
 DhrrwMfu8pfy7L4sChPP4V8MBPGFR7VqpIRD8MKUpB8KKLL9WrWBAya9KRd5+XvmxKqYfU8E/pi
 CV9CM5w1+Bf8oYHhEhL3Wn/0u+lXzguWM6TBH60wiOG8mSR+bNkD
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11952
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=10 phishscore=0 adultscore=0 lowpriorityscore=10
 priorityscore=1501 impostorscore=10 suspectscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310062
X-Stat-Signature: 7c51bdoii6tynhtqxd94bh4oq5pqquyq
X-Rspamd-Queue-Id: D5DDF80006
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793461692-344561
X-HE-Meta: U2FsdGVkX182s6LHUrAzjJYrkicndHVZQc0QmIrhYlss2OQrU/+Ty/ade5JGPcYw8bL/S+HnihKE6Ug0cKbgIpKHI23Hewujy01cpbJ3u5kkZ69nAp8IgMXm1bu+rx+Q4rodRBL4mk59qLp2LValw+BpHDQNuIojpvGhrIG/nNpM4B76l+PeuqXKm9k7Tuxxv0XA262EisbHEaWzFQlW5O1HmI+DZjJR9s7790UKih2ePdHyJcA86Afp4DVmkD4hiMXBqhBJoDWdAS3wQaTVHFsd+EaWlGXInL1oERZVZIcAEEbsy1yK4q2i8O2jk7ZYY9QZ2jQd97rj703WTWfCrDuupkoSx0HHbUjiLjGEwbOAK8yZ6fu3HLw3gDmiceEYAqxJPdmI3ybV/0vJsmiCTVD6z64BKLhVOsV8GZXZmkrraeHePvFQ6ftKgrRNli9St78Bug8rJkN9MiV+PFxTnzuFaHLnec1T22ptEIjzAHig7Lu1DSKScz27L1RSWTSacAsTNPAgQXnlpcwqCuTINKN4PAmexIf3RcU3TDS/qJemAa+iaI8j7fTLtr9XRXlv2+U4HQkaN0dazm2x5jr2yq5dbDLw5SK6KPw88L8EEjvjKQCigZqUHcMd21GmjJYsvMSBvLwHM8vyElR1e5zaUQA530ijNkbA7ohO57ZC7zeunhEnvVylPXoy6+LXDv8i8G1BhgneoXkNSNhDYLIKTpdywIx6Zwpoi3ToEbNV8XveOZ0JFBbU/Sh2G00ctzVqkuElSYRGoTxJMMIQ3tioH8WWUWE5U8GJlq47pa+8XVj4IHRM0SWwL/MNpq7QF4NlOB2HVngVSWMO5JgI/pp+YhkZUgz5VSIDu9UwSQtmytsl3cImDfZkluAfXd/Xs4yS9ceszbcAkzprEGxl/qIxSqbwhAlKyD/pctJQXu28nFQPUv5c2C4afyu2Lxh34+9P0JJJmX87uEgFFgd7cDH
 iqmDK2Cv
 46tkQGasJjE1yslywvozTR92bHa/mEPcjcecusQTj7uEmVXN/bbKcHyte0VGH/pCOHKM+7yYzVvC5K8V8o1v+P0YL3eUoU32CL1KbJ/NMrQRlfT3PtJWMIYypC+UVsGYd6QMFbgweAaNsBXJ2nv7t+03xzSGnu1W5sZ+wKSVsaLHD5KmOo9SSnY7jAOtosdGsnAtQ5Hujas9f9w62kdZclWKSYASDzvMIQAD8Mh1F2LRl/91369MffXp4tDzA/s6veJX7cA2nwtXJjfl5H+OdWWCptGEmYsWr+cjjM0+DfENfUVzLpPwyvmsuaz66KzmnXHbiQRAgU2THI68VMMDgatmh+zYQYEBXGHeQRgwpOnQ/JibjRpa98XcXKi5NdMWSF/WogwuX/59NcuhvD3bN8nxXEclX6XMSyJDD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A UFFD_EVENT_FORK message cannot carry the child's fd when it is queued,
because the fd has to be installed in the fd table of whichever task
reads the event. The forking task has to hand the reader the new context
itself. It does that by casting the child's userfaultfd_ctx pointer into
the arg.reserved.reserved1 field of the UAPI struct uffd_msg, which the
readers cast back.

That temporarily puts a kernel pointer in a struct that is copied to
userspace, and results in ugly casts when passing the uffd context
around. While resolve_userfault_fork() currently zeroes reserved1 before
it is exposed to userspace, this unnecessarily risks leaking a kernel
pointer to userspace if future modifications are buggy.

Store the fork_ctx pointer in struct userfaultfd_wait_queue instead,
which is kernel-internal and passed around anyway. The casts and the
zeroing go away, at the (negligible) cost of 8 more bytes on the
stack.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3b71712edab4..cae70df89c00 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2430,6 +2430,8 @@ struct userfaultfd_wait_queue {
 	struct uffd_msg msg;
 	wait_queue_entry_t wq;
 	struct userfaultfd_ctx *ctx;
+	/* UFFD_EVENT_FORK: the context created for the child */
+	struct userfaultfd_ctx *fork_ctx;
 	bool waken;
 };
 
@@ -3006,14 +3008,8 @@ static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
 			 * didn't.
 			 */
 			__remove_wait_queue(&ctx->event_wqh, &ewq->wq);
-			if (ewq->msg.event == UFFD_EVENT_FORK) {
-				struct userfaultfd_ctx *new;
-
-				new = (struct userfaultfd_ctx *)
-					(unsigned long)
-					ewq->msg.arg.reserved.reserved1;
-				release_new_ctx = new;
-			}
+			if (ewq->msg.event == UFFD_EVENT_FORK)
+				release_new_ctx = ewq->fork_ctx;
 			break;
 		}
 
@@ -3111,7 +3107,7 @@ static void dup_fctx(struct userfaultfd_fork_ctx *fctx)
 	msg_init(&ewq.msg);
 
 	ewq.msg.event = UFFD_EVENT_FORK;
-	ewq.msg.arg.reserved.reserved1 = (unsigned long)fctx->new;
+	ewq.fork_ctx = fctx->new;
 
 	userfaultfd_event_wait_completion(ctx, &ewq);
 }
@@ -3404,7 +3400,6 @@ static int resolve_userfault_fork(struct userfaultfd_ctx *new,
 	if (fd < 0)
 		return fd;
 
-	msg->arg.reserved.reserved1 = 0;
 	msg->arg.fork.ufd = fd;
 	return 0;
 }
@@ -3482,9 +3477,7 @@ static ssize_t userfaultfd_ctx_read(struct userfaultfd_ctx *ctx, int no_wait,
 			*msg = uwq->msg;
 
 			if (uwq->msg.event == UFFD_EVENT_FORK) {
-				fork_nctx = (struct userfaultfd_ctx *)
-					(unsigned long)
-					uwq->msg.arg.reserved.reserved1;
+				fork_nctx = uwq->fork_ctx;
 				list_move(&uwq->wq.entry, &fork_event);
 				/*
 				 * fork_nctx can be freed as soon as

---
base-commit: 243e8cdab64129d6207c398f8cf5fbb1962ff7e1
change-id: 20261031-uffd-fork-ctx-23fe063a5cde

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


