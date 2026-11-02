Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6685D606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=U0N7v0Sg
Received: by kanga.kvack.org (Postfix)
	id 83F426B05BA; Mon,  2 Nov 2026 04:42:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0206B05BB; Mon,  2 Nov 2026 04:42:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B71A6B05BC; Mon,  2 Nov 2026 04:42:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1536B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:42:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D33E41A0C93
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:42:08 +0000 (UTC)
X-FDA: 85389687936.07.AB96C40
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 444E2100004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:42:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=U0N7v0Sg;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of "prvs=97666edd39=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=97666edd39=alexghiti@meta.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793612526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hV4Hnpm2VWLJSnk5OSmTN0Rwaxm8j2FGjnR6RitV28=;
	b=2iXsCklOCsKzXkRrW5EDIIGAGQGCdeWgG6XewzThXQBMyxc3toafkbD4z580tZ22QOBoHi
	I0nqEzn1kn1mzFypV6xlDFiHcR1t38KJoV0tQLMcT1re/Tc8r0c4hBC1Bud6/KGBpgrIsh
	Ut0T1kojm+SNXQiHVCQzxFvN9Pkoyh0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=U0N7v0Sg;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of "prvs=97666edd39=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=97666edd39=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1793612526;
	b=uKK31EQjy8TMK+sWFpteuDWVW6w7iO0XgdYeY+9O/9eQS3gIHFBvrarvXMb5wgxRzFnOEJ
	sNwD0yPHHxYTw3y9kbqHuJZPeT/3CYmi3VkG5fbByKoEOHH0UTuGws1s6M8IMTAa3otccN
	Ql2dkNjhWFsYswgvWeCdsGHdrInOpQY=
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A29B5Lf924004
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 01:42:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=/hV4Hnpm2VWLJSnk5OSmTN0Rwaxm8j2FGjnR6
	RitV28=; b=U0N7v0SgwQxHQ246GVeanalPcEONeLCxzU5siSRRWqCa+hdN/RnFc
	NvFgGyNqzKStZCzCekswqNsvCo7cJ5ZOUpuRtrO+QZAleGd0ddpswuABA4qavR1c
	pczD+Oja7LoBG81u7uSQoTvOqirMp0Jat9ecDP+/4hEK5yWrGIF8g5wNeUY9eXUw
	ze8tL9r0TW9eY5n6Cv7tsksy1Xis4yjUE/C0nHh2TIRsx/mSjNnCCBt1c4LfxZVL
	uZDSkP+DoqjGU34+Dk3oHKiaG2v2eoKi2dncDmURL3LxtQTgMgBaPrN2fESmBt7w
	pWelAoq/Y84/cqIKjSpDw7rlx+tKoMXjw==
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hne108ehs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 01:42:04 -0800 (PST)
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b1e00100eeso3275404a12.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 01:42:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793612523; cv=none;
        d=google.com; s=arc-20260327;
        b=JWs4SThw1IRwhdh8/6/0ZujmB5lDkXOiXc6lLoA8pBB6goniJK8r3q9AaUzBAj/0Co
         vK//h8xOGQME8/pbZ0taxiC4gy+wVtoYc4fQ1+/BNTzE2izy+iG/wv3cVAdIwSU0Dfzj
         d0tB8NUI2D/Suls2cJ5Lbxz8WtY+mXzlE3gUXDp5D9BN6COPedZ2QcWLlBXbo26fA9lf
         v/70+rEombp0UZqHh6hMpM9xQGZppDhpUw6ot2uOm2xdfUZyOor9v0iBIkDsvD7IZKSg
         SVYZmSS6NEYdDpnPVQkiS0PAxlS57BCMQRPMs0RePp2NeYpcVi+XTVw8Ati1C/KeksSM
         gbpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=lRigYOwxo9HQkB/bmQdmGkVxLN1nL2Qp3TqgTnuUPG0=;
        fh=VOtZ48yj+SFZTQhJFPT6End351oQR3CXPW6GI/erAL4=;
        b=HXs3Sx2qn8VcnLXOfMDAOdkY863qBAQ6Qe2LO9iHiZKD/giEcTlNdwht/WC9DRWEK9
         QwDuD8fV8VOp3WyO2UFl9KbDeavath938n3u/Gj/Rn4q94bLkgemwwU0PDVL5D3UR1zM
         n9Hx2CgfmagAKS1gkI9CpPoztsHJCXq5IlIQExVYQQ/WB8loYsndJbBri+FfrdWo2Ks7
         eJl1uwkNmVnTGglKQdsupyCgITImyCKaNuaMH1wjTOFvldrlcd+Wvn7GbaDJhwvm9MRX
         JIQA5NJ34hjjaoxrBM7I1CjgwVFxOBwDN2510OCv0QJVxoqHldhN2bPfpRFZYxZqU08+
         NUKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793612523; x=1794217323;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lRigYOwxo9HQkB/bmQdmGkVxLN1nL2Qp3TqgTnuUPG0=;
        b=jGGWxsR4f5OGtcHLlec1M/GIk1+KFxw8V0JD5LWVXah5S8THsxNjoo9Sr0S+jmhFY/
         NEYNqRH9B1er1nr6gSV/m2uLVitRLleQT765MnXG1i2kf2teQy2vZz5Py+Fy9OSMg0Kt
         G3yEDeFKTRBoCLRsXu1r2OmQ55xisW7JeYVRMq0e62uj6jNadDdHW0DJVrUO5V22reLQ
         eQhy3E9Vg7nc8FDG5Tk4/QttW40eHSsjgs3TknZPlD3JaFu6N/xcOdbgdOtL7gqpXbfP
         zYUjOcxUrdhPIDQTPNYtzmAqHsyALYwSy2cFhvOnBQb0tOSi8FHxSIO3eR0TUpgEWpbH
         GnFg==
X-Forwarded-Encrypted: i=1; AKwUvBxNDfCpO0zkYARw4/P2FReft74OM49RIAlod2WnYk/HPRahbfLXVknKLG0qzKMHeu4BbDO1WTSipg==@kvack.org
X-Gm-Message-State: APuU4Z8606osiEAdkbQYa+DvRoI81K2Uno9kKla+vjyZzuXQD1LozjjH
	/GaZsre0TGZBsHxgMyKifDwPpWQJ60NU4xplUMz36ntMBPMShRWyYvBrWz8/lzTMQdHAHj/OTs/
	LvphsPaXau+9WJV92M53p7NdYpsN3oxTL0ZehF1yDc9Rk1lLXffKDgDRyjRv62VVgFW/VNhqzFJ
	Ym+cCU9EmIAmtmssrzSn7xuo/jiA==
X-Gm-Gg: AYBFou2WHcKL3HMkcIT/SUeudL1QiC5KnOA+Mr7+Xm+Jq8BtNlCV5mnaj5WcxjqpXTm
	rH/s5BjSDgiEJqAXQAJSG3aXPrgc9pHTK/PGsSAI4uTU+BcPuNtQ4qEd5xxYl14qt6h/Y5plCEK
	OPVHgju1nc12XYR1Iqy7BKJ9pBwInNpsJugINuFbL/jRhv+msb3GjN/TsI5QkZMkPonnqBGf0bI
	MYjls3e0QK7h/JsvA==
X-Received: by 2002:a05:6402:160a:b0:6b3:d0a0:39c3 with SMTP id 4fb4d7f45d1cf-6b4d487b106mr4570096a12.27.1793612523242;
        Mon, 02 Nov 2026 01:42:03 -0800 (PST)
X-Received: by 2002:a05:6402:160a:b0:6b3:d0a0:39c3 with SMTP id
 4fb4d7f45d1cf-6b4d487b106mr4570081a12.27.1793612522721; Mon, 02 Nov 2026
 01:42:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022145615.2184343-1-alex@ghiti.fr> <CAMgjq7AB4wUzmugV3n4mhWcYqMKmhoZJCDV2uUagFjZXjUUi3A@mail.gmail.com>
 <CAEmasaXz2GGoy4dyhbo9Em95Cnz6QL3u2fcnAa2=8pJOOJyH8g@mail.gmail.com> <CAMgjq7BjOeboPMP64PfGDoY4yMGq0xR4E4Wa66U0+gsd2tnu+g@mail.gmail.com>
In-Reply-To: <CAMgjq7BjOeboPMP64PfGDoY4yMGq0xR4E4Wa66U0+gsd2tnu+g@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Mon, 2 Nov 2026 10:41:51 +0100
X-Gm-Features: AclHuK8n9a89pYL_Wa05qubleq6jQ4-R-im7loQEEosJ8TTL3UEl--es88mxuFE
Message-ID: <CAEmasaV0D3ezZyWf0k_84qXOa1c5KyUjvX9Jez+RXMDPM7FdBQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] mm/swap: keep reclaim batches contiguous on swap
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Youngjun Park <youngjun.park@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <ljs@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=FueQbGrq c=1 sm=1 tr=0 ts=6ae85aec cx=c_pps
 a=9KvDgq78n9V61H3VJbnhTw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=PAz_-FQ8hEVmOPYdF0yf:22
 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8 a=GHlurvfvZonIQdaYDxsA:9 a=QEXdDO2ut3YA:10
 a=j5kO0B45gQVIxiUYEfTy:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: xjLb9g46PNPQLQaQsFVWbPEjKSrn5ZnO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAzOCBTYWx0ZWRfX2v8BJrv1uola
 UY9CdBRAcdZXjtDHI5LKzLrMfMQKGJ4Ekq6HgdAPbfqfapSrnFxO35n5zRRZG8f9WRhGQK+rUYf
 IfUxjgMM2PJfmxOHbt3zAaApqYJexPE=
X-Proofpoint-GUID: xjLb9g46PNPQLQaQsFVWbPEjKSrn5ZnO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAzOCBTYWx0ZWRfX1spPQTxfmiKK
 MgnAKhhNP/dQfgvNEzu++z1lIxmaLxSEqLGCsNSIOUBJ1zgNMbwuOB8+060TKIR8dj6bf475VFT
 hGDRNoDGv4RIC+fc56b+njSEp7kyUW0vKVN8cLlIo+POS/WpnFpQ+n9izFmQhbiFO2tov2n8wx5
 9QumEdrdBQLtHs6wNnk1h1Kdd5JmNQmDyxbYpTZip+rtPGkNVtu2f77pqUm6KpyxADUqKHhkJQJ
 gz8hrNTaGuVH1MoeTG70ICuimCj3lkBhMGRwjz9feeY6/ciU4B/+kiST+80V1rDqCgChGI48fsV
 4r33O9RA83RnLpFzeI1XRfh2e0dH2COcafKuXauuUYQDEwuNITCnR1PjYFHZ3biGKj5zZgd118N
 3bWRowIq0zAwT+Gx7X2tb6N5io6IHlR0yvAcS7t1wC/vBhckG0Syvvr1nO8UAseKkjEcmjwzR/L
 4Pi2pf/4DvnYuIvNFMg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_03,2026-10-21_02,2025-10-01_01
X-Rspamd-Queue-Id: 444E2100004
X-Rspam-User: 
X-Stat-Signature: ro9jb67edd5a8iocm7a3n1kuqj6k4cug
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793612526-739175
X-HE-Meta: U2FsdGVkX1+eHWTINmhpJHq+Lu7S53sHBr+hi7sJo+mhC79Ayswtpft1e6XbroHjJcGesy6K3k7SrRCoyxoAhLpBcwka4/jfik1awADsbwxr/a6wPJbzoOZ2nj8aRkGWlfhJ1pIz6EGJzrTH5Co5ZDwhz1gQvH2spmzo0Kw8zjf1U2Ws5QjLb42SYAIPh+9hrNK0HbAJo3TYJUIUFIjxPCVvFzZdBNwutLocNWXElajsjT8v+S+WqqsxU2B6TlQu9guzXNSgF/8a9+7aBWDIHwXYmHHAMUIGjNib4l0XgBJwW1NNg8PKnPhekab/814sFz32XT3WvkwOI+X0p6gsuPPpn0V0bVBakbaq4hwVDGxTsSWsZpbXQ+W7BxiNPCqI+SLv/W7gFnqb2x2AqcGlPIO9c8jPJbnNMLc/8r3XOvXT2/ZkgBQSbLvt0OO+9Nd0YUBSBV0xXWBo55GkE3G/psq5sy5PKy1oJkOZ4LeG12dIhlq/BIQ3vTA2pe0FhDWVBQzKxhPJrCbPuqeDvmRYZ4bEqEfWZZtt9ihSbkMAfuQzhd/jQVCTudpOvHV+1TurCvIx4YO9SFr34IDbINDr/Rlo5jN5kEn/WcWvzoZellBdQ0vJm1INbpeAUJ6WagWQ6CdXioXGFKsfSYOvOASHWWE7MV5o1TYhzr2gP7xDPsFbh0gSn+M9/ldxYkn5oFRWR6esnnDo93116DyuKr+k+zLHwrC+vYhT9fMD7+nO/EHqrWxf746G59Ec4tRnrxEb/tsXe8Pbt6Urm0Flr8MTTp0d6Pu3lsH75gtS++bshFyktPu+UNH+dcDz9+9sAVoL5mWrwnX+1HfQmNr2Vz7YnJW+lpaOwN82LG0Q7U50WfAGR0jiTnuYOHu2Qj2Gxgjv3e/ZJXjufa0eW51tk540PWDDfgppm7P3Ntz016oj/oWW8VenRC9P9vFNiMqZ0q7S9AuIbuyto6FxUuEYfhF
 blLYCDlU
 RUeyq999ueuZS+CDtiwyOvWY6RjWjvO3/yIiXsmDyxPincQEc8jhL89i3D62K2CF3n/KiwsZ/dcVUKiSlCt5KqIas5wx9WHlHWnROL3Ci6q771tv278sq5ExOYU24bkCsKxJcASVex20SrwEzdcAh0NK7MAozfYZJ7O4usNb2QQACO2qVNTCaiKhh9SlvBRV1+/sJXA6d+PMGI2BngTGaq+JQMvAsZ2NDQ3b+xjFXmBSJSXo8xxZTxGzwffMjCr6rSeha0GN9azjD7lLTiExuCho3nB+szyzIBevgxOB5m0scREuoKCXylqWLu37vIyYDnU/dEEnAn/r/plvKUcehKB+zaC79DH40U1b1Dp+l81pANkISPd4nQ9JEK2TURTQqc3NK0MiksOxS5sWYTTaCk24aAb2Y8nyRke/PyPLRZhcqoB6J1WFNtflhK23RbsG9AaMdbtF7N/fYqgVS3KBC3ftPn6cEZYJWltGBq/BvQWN40P6KoTsAPdu59OI4ZoEIcZe1+8Ecz113ZAW4MQQ6kCGhINKdmeJutwS2r0YC2TGfwiR2yFJ6Nmc2oqdBrUvS5T+1EJb+A6sYSGMz0x5gMFeiCqjZLtB+ixpEoWETH0rJYfRaYV7R5RlazR9yPXEcERttx7i+A8Le1Yi0qJGJo2SnCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kairui,

Back from holidays, sorry for the late answer.

On Mon, Oct 26, 2026 at 2:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> >
> On Fri, Oct 23, 2026 at 12:17=E2=80=AFAM Alexandre Ghiti <alexghiti@meta.=
com> wrote:
> >
> > Hi Kairui,
> >
> > On Thu, Oct 22, 2026 at 5:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > >
> > > On Thu, Oct 22, 2026 at 11:00=E2=80=AFPM Alexandre Ghiti <alex@ghiti.=
fr> wrote:
> > > >
> > > > 7.3 regressed swap I/O: for the same swap volume, a workload that
> > > > rewrites swapped out memory sends many more requests to the device.
> > > > mysql/sysbench in a 256M memcg swapping to an NVMe partition, 7.3
> > > > compared to the previous version:
> > > >
> > > >   device read requests per transaction        +59%
> > > >   device write requests per transaction       +27%
> > > >   throughput, iocost off                      no change
> > > >   throughput, iocost on                       -19%
> > > >
> > > > Two commits interact:
> > > >
> > > > - Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters=
"),
> > > >   in 6.18, makes order-0 allocations fill nonfull clusters before
> > > >   taking a free one.
> > > >
> > > > - Commit 3cedb745d354 ("mm: clarify the folio_free_swap() for
> > > >   do_swap_page()"), in 7.3, frees the swap slot on an exclusive wri=
te
> > > >   fault. 7.0 to 7.2 kept the slot, but only as a side effect of com=
mit
> > > >   4b34f1d82c65 ("mm, swap: free the swap cache after folio is
> > > >   mapped").
> > > >
> > > > The freed slots leave holes in full clusters, which then go back on
> > > > the nonfull list. Reclaim allocates slots one folio at a time and
> > > > merges the writes afterwards, so a batch of LRU-adjacent folios gets
> > > > scattered over those holes and is written with many small requests.
> > > > Readahead later finds those pages scattered as well, and needs more
> > > > read requests to bring them back.
> > > >
> > > > I tried three fixes, which perform similarly:
> > > >
> > > > A. Revert 3cedb745d354. This keeps the slot on write fault, but und=
oes
> > > >    the intent of that commit and keeps swap space pinned under dirty
> > > >    pages.
> > > >
> > > > B. Below 50% swap usage, make order-0 allocations take a free clust=
er
> > > >    before a nonfull one. This is what the allocator already does, at
> > > >    any usage, on swap devices with discard enabled (swapon
> > > >    --discard=3Dpages). It is about five lines, but the threshold is
> > > >    arbitrary, it stops working as swap fills up, and it applies to
> > > >    every order-0 allocation, using up the free clusters that
> > > >    nonfull-first keeps for mTHP.
> > >
> > > Hi Alexandre,
> > >
> > > That's a interesting problem. I think the real problem is with commit
> > > 9a42aed48421 ("mm, swap: prefer nonfull over free clusters"), right?
> > >
> > > It's more like a balance between fragmentation and contiguity of small
> > > order allocation issue.
> > >
> > > Perhaps we should instead always scan the full clusters and revert
> > > that one commit? That commit was only following the idea of keeping
> > > the allocation more compacted for that series, it looked good at that
> > > time. Since fragmentation issues can be solved in other ways,
> > > contiguity seems to matter more for large physical swap devices.
> > >
> >
>
> Hi,
>
> > Oh, okay. I thought reverting it wasn't an option given the good
> > numbers the patch provides.
>
> That patch is 1/3 of a series, that series yields really nice
> results, but that one patch plays only a small part in them. Or
> perhaps we can limit that to SYNC devices?

I'm a bit scared it would not help zswap with writeback on, unless you
mean actual SWP_SYNCHRONOUS_IO devices?

> I hope there are simpler
> ways to avoid the problem you encountered. I think the ~4% reduction
> of 64k mTHP failure is kind of trivial compared to the problem you
> encountered, and 2M swapout is still not easily doable, as the
> main blocker is from the page allocator.
>
> >
> > What are the other fragmentation solutions you are referring to?
>
> Right, nothing has landed in upstream for that yet, but with larger
> swap space the fragmentation issue will be largely solved. And before
> that we might be able to sort the clusters by the continues size of
> slots on it instead just blindly move then back to nonfull on any
> freeing.

Sorting would only help the current patch since reclaim allocates swap
slots per folio, not per batch.

What do you think the next move should be? Should we implement your
sorting idea on top of this patch or revert the nonfull cluster first
allocation? IMO, trying to fill the holes before allocating a new
cluster is the best solution. Doing that in reclaim, as I do here
avoids distinguishing between sync/async devices, so I'd favor a v2.

Let me know what you think and I'd go with your preferred idea,

Alex

