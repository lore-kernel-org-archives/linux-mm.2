Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3142606A331
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=YFDMIGSS
Received: by kanga.kvack.org (Postfix)
	id 048736B05B5; Wed,  4 Nov 2026 09:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F1A6B05B7; Wed,  4 Nov 2026 09:06:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50716B05B8; Wed,  4 Nov 2026 09:06:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEF646B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:06:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 561221206A4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:06:31 +0000 (UTC)
X-FDA: 85397611782.26.AE550DC
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf02.hostedemail.com (Postfix) with ESMTP id C57BD80002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:06:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=YFDMIGSS;
	spf=pass (imf02.hostedemail.com: domain of "prvs=97681eca36=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=97681eca36=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793801188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAMpWDWruKPumB6Xa1CYIphLFL78E2eeQCtuZQA6IQE=;
	b=zpQZTSHwfZ8iqhhZVNpeFCbGzCnWOJyGJ5eCDNiaLq78zJ+GK4hqOYWLZuRmUe1v82qNIo
	XiwLTWZEc1j6HuHgvqdz9M4qg8jhbaMJgOz8LbQmIcb6arLinK3PKIJSpJ2llfnbDf/jmi
	FehN9aSc/pDHI41uAl5pgtDGDvCgz9A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1793801188;
	b=Ywuwc6WT1gBdUQ1fAu2vi44b4pMewU1MSLSLrHpVj4qA/IDX///ApwMlYWaTjDIJLobh3j
	4BbssdHPYJ2gRkSMvFQONmuIVg2rbY3JG4NGk8QwUSyLTAOrgEkTEOVCE7/kJdhTftNQs2
	jJbvjth46BcD5OfRn+8o+snK6E2+NQg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=YFDMIGSS;
	spf=pass (imf02.hostedemail.com: domain of "prvs=97681eca36=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=97681eca36=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A4BdClK596356
	for <linux-mm@kvack.org>; Wed, 4 Nov 2026 06:06:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=QAMpWDWruKPumB6Xa1CYIphLFL78E2eeQCtuZ
	QA6IQE=; b=YFDMIGSS7tBalD3DxD9rUovijS31f1vY8iPYKyCDvc5ROgVf8/PYR
	9PUIfbBcNEL6hyRDrPIAjV6H6HpMwYSHNgRElSJSv6yhLkDApUdqhF8Rd9Q8+mlV
	nKgGkb0jd0mGqcokKWVkPUZIIlCfbyvAw25P6q/tZr9GlXjbuqweDSvJWtJPSDXf
	7kLVklEXcF1a1UTyxbeoEVpYJ08wi0Ico/y8i/3VETsnX+s4DAkXhS5wueDontDO
	rE3P9T36rhts8f5GkjiR9XBxnHAHHEzS0EW7sgVRJIcMokrRWufCR08Sf6XMVO4m
	Y8jwnvlMRtiJihnqNy4vXqf9jwI4ke6bw==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hqkba789n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 04 Nov 2026 06:06:27 -0800 (PST)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-67bdee091feso1039599d50.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 06:06:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793801187; cv=none;
        d=google.com; s=arc-20260327;
        b=gbhM4riHQeRlP6YZdB5YMgkbgZQYOzId8ROYdvC5JbdEBt/B6AhxpNSgmB1RocpZKT
         LvUPvhXsRYl/VGLN2ASUsXdj9Fjo2V8l+tZnW+u8+GyXZr7dFUB3WVYUnnUwRh/W8ih/
         WIkl99j1Ljc7tp5O+ieEHDXDSBdvjdhrBFA9h2yB8n5SvRTy2I3BcihZzRgaefIEajJm
         QxWqEHohnKFfYW2HpmHxWBFG090/ObPWJYBnrIAp9O59MhUGmyGGgLV1ATo8gSkeVURx
         7uAr5HqinINJT3Ff7vQucVY90QfuM9LGDS0Fou4vBRQCVc01kx1A3NYTLPfrU644NF0D
         LccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=/f4EP84Fx0L/VX6arx5pyVe+AN5q2SyBdZOt/navcCg=;
        fh=Du4orlncWe+KvmkgHuUT3I5CjeYA+JKwbr3EDjtpYoY=;
        b=DVftCt/by5gt/0IjFZmMQ4d74puVsXHkknZqyi3GMoKMcjgW0lk4JK8unS9M/L4a4S
         AVJSibebd/Q28WNicyHGosg+oVd2e298MVdPreeEHfM7eMbWnFGV9rOnHWsYvCU/zw6q
         W6KtXa/SB2Xt4ulBJwdXTUKj1s0GwHRhDX2G8YPhdex1Y1xtBhkAUaDOfy08Y4yq1zoZ
         mcIqBhfMnPkz7PsVgmWc6hd7XGQpwrDctOthbro72DXydPeaxhzkfo9tmxIz2eUKIBsD
         HNCEqHCnYesq53Am4b2sNT+xbXRMu4ffySJfDNw1If8bXzXQtYxCStuCW7wDQhV2s47C
         JMCA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793801187; x=1794405987;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/f4EP84Fx0L/VX6arx5pyVe+AN5q2SyBdZOt/navcCg=;
        b=kJ/iJDQ3C8lthW4b7hNFfOd1tyYwocYumRsiR0UCQc1irl6YfcOnVTiwtQhDBIR8nw
         r2DP+woeuNG1qKX9N2MccvUQX9qjSTTSNpWtii/aIE+2Mxx4kj6zSznuqGc6I8g0xczn
         vu4FtG88n71jII7jKFcGOymv+Hqwd/BzkFHgz71G53IhO0Fvskc+ttnsO7n8kFIIZuJx
         VbHEQ98YXrAHUbPzpyE5PcO35UxPY8VAo0Fb1mFWFCJm3CvqwGhWVKWOsQzKvyg8SQgz
         BBtNyd0ug1/1TvgqoWOWGPGK5DLx12Q80ZH214UlgJDK6gAFiD/UFx0ZbRCy6f19fbtM
         tRaQ==
X-Forwarded-Encrypted: i=1; AKwUvBwKVCHSCYnZ4oVS/Uq42704EOzPnt2F3T3W3WOA1Pw8O5uI2jC0KJRShQt3KdSnPpheLy4sHp533A==@kvack.org
X-Gm-Message-State: APuU4Z+imjur2HNEbdRNfoIg6WS3vx/J+fIOtvnOnRC1DeplhbnI7qS8
	9Kz9VvkZra0h9PvGoKjqEX2S+aI4hC33E95VBbgPw1cLMVzGlJsqBUd7iH0E/X9/gRkZt7iZJEY
	X3+CJYFZ6k7cIpHFAU7wk83H++ukiSQjFHeStiaDeCBZtPaPab1Saf3siSVfGjRpf98jKBzWitn
	JVNXZN4eHOHIkrUr29bx4jEj7N+Q==
X-Gm-Gg: AYBFou1k5L8cnNcVkaT1m1n+WASyjY0sjhjBqei15GQmxR4SAGuL1NALb1nxh+4aiBd
	XOocGP4hdTpfXriLb0b1SQ8RCugCpjMia7KBQyFPjd8ae1Q0Ljl0+no8HSS66ICy76el+Kx6mWl
	dkffLiMlykbXn9x0qR4x6YT2dkFAKULbnEoap6g51b6xRFACddu/OOBEpH3PEc+5+hxj8AuF8oR
	3aWJ0/p1tqY10PB2A==
X-Received: by 2002:a05:690e:b87:b0:677:b923:dbd3 with SMTP id 956f58d0204a3-67ba5053dfemr8349306d50.154.1793801187271;
        Wed, 04 Nov 2026 06:06:27 -0800 (PST)
X-Received: by 2002:a05:690e:b87:b0:677:b923:dbd3 with SMTP id
 956f58d0204a3-67ba5053dfemr8349284d50.154.1793801186561; Wed, 04 Nov 2026
 06:06:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022145615.2184343-1-alex@ghiti.fr> <CAMgjq7AB4wUzmugV3n4mhWcYqMKmhoZJCDV2uUagFjZXjUUi3A@mail.gmail.com>
 <CAEmasaXz2GGoy4dyhbo9Em95Cnz6QL3u2fcnAa2=8pJOOJyH8g@mail.gmail.com>
 <CAMgjq7BjOeboPMP64PfGDoY4yMGq0xR4E4Wa66U0+gsd2tnu+g@mail.gmail.com>
 <CAEmasaV0D3ezZyWf0k_84qXOa1c5KyUjvX9Jez+RXMDPM7FdBQ@mail.gmail.com> <CAMgjq7BFbXEKEt9faj_rg5AStfLkpJ0j57EQOOJ+L3-w2xRvtg@mail.gmail.com>
In-Reply-To: <CAMgjq7BFbXEKEt9faj_rg5AStfLkpJ0j57EQOOJ+L3-w2xRvtg@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 4 Nov 2026 15:06:13 +0100
X-Gm-Features: AclHuK-ywCYCDes2w5waoGRQmyFziLeciMzNMPbjxY3l1ZmHrzYocw8iw65rVKU
Message-ID: <CAEmasaUoAcgwBJ2Q5fa8NNrxw7xeRXWH_sDGs+GP=L9BVRuUVQ@mail.gmail.com>
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
X-Authority-Analysis: v=2.4 cv=dsdOmFg4 c=1 sm=1 tr=0 ts=6aeb3be3 cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=xtH7KyWI9dI7BmFOsl-x:22
 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8 a=ScCvlEzxO9iafL6ztjAA:9 a=QEXdDO2ut3YA:10
 a=uujmmnXaIg8lM0-o0HFK:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDA1NSBTYWx0ZWRfX5TJvv/xNEp4i
 /T+eOsEcHOf3F3Zh/hFiNPb/hlFR38AYSNjxQyNoUYZ4w6N0FncU98Eiaqh3AgscIgJGs3ZL7MF
 MptfFJq9ZjO07c3Bl9vgYjFBmY2mKwMzpiqzodR/wfFAjXSYsI9zNFiCXooKeqdVLc7+LCcN9Xv
 CCzNZGY3lHuCjwc0Te5IMtc/w5GguuqpQsrFZAebS0lf/f1pZ4vYQorqgdH7lUsuW98kr8+lSyc
 yG87fSX3WbbAaokGOTea/qG2F5p4kZh/SCcwlgQwlcmhcHK3FkAc0JPoM8JqjAJwWVCYz139Ekj
 ayDEiTDC7zmvyJBBjGmALNDLfN9V6vppIE1D0rqgkZxPST6jb8roXbCsig2cxSP4O948mhSWzRW
 Jf0ZLkKj2/+PLs0Jusyn6YMFxdKgfAoydDLn2AthrbNE0NHHNYXNwo4su/Pk/VZtclnUiB6YPgH
 BwxuiCb7AKGb8Okt1NQ==
X-Proofpoint-GUID: MDtD6-Wb5ea3Gcs3lN4fZLgXGimr9Nra
X-Proofpoint-ORIG-GUID: MDtD6-Wb5ea3Gcs3lN4fZLgXGimr9Nra
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDA1NSBTYWx0ZWRfXxlL0oZzMCVWT
 fpW6iG7st8RdeQPJy3T9FEPugwnD3zTbU3R0TF13MeDJiiclJQIOQGhkuLH6qJXo9lpl+SVR9mm
 w4beL7nYMifAxn251zMBib2DKtnVWso=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_04,2026-11-03_04,2025-10-01_01
X-Rspamd-Server: rspam06
X-Stat-Signature: 9o4wj3f3in4drnw11m5t3d8ex4pmzw49
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C57BD80002
X-Rspam-User: 
X-HE-Tag: 1793801188-593996
X-HE-Meta: U2FsdGVkX18YVxU7vVBiWyLHGlEG7/2aHI1VpQpKY0nI3Hf3+/jyEunSjtCe9UZEBWg3rcQ9nJ7aSJqYbGlhmA5vgAoSh1J3VxUTG60f7ckh9kYvbeYcreY/lk0sFRM8ko9XCsr/OjFgsrmtwQVcow3jz24MC6uLT2YAAEuJ/0i8rD/fM82GifeFVcAfnwPk9K+RDZM4Uf6bzORJAVgcSVMicFi2miQwQM/92N6bIR2oSltCZRlo8+azMaK2dKNvOHs4m53yENRj75nCJFg0WwixdFaGfCfKlCw7tThWKNgV9zMsfSogmVBbuYCCQhZIXNIfu1JLcv5u1KDxYauMrFQrAFBfXu7/B1mpyvIkEp41RSTJRxBdDhpXnlcxMv01VMl0xVXKFOM3XQ/TUtwXttU72EgaQUksxHtOwA2zi8LxALk56DxfEhUZ3t0Cebf8Ct+n2/9m/QJETycsP9V/T2nUsmc0f0wPumlnIcQU3ukOwSX+S98tYRR4NaYEl3fyZnCPi81ouSpEzWwYvPUv8vX7lh84ZV4VQ5TMqyaih5nuK1Ch6BALh8Gj8Xg/LEYa9FWGGhhC9BhivYY7P8N8Kb487UxmtCR4pcT+xNF7UIcpqdgWd4Rb5XPcd+tpGwT4mG9IuZcHOkIp62H//jq83Sq9U2XuV5sX2LWz3VV6rxhvTwSM2bKfkITeY/WhCg1JdHK0BCnwJnFv7SBHw2/v8CESAsvKnJk5R45I1F7pP/e9r4GGmWlAWjZ5UJON9NwxkaVv6MKHtE48qGVJ/RWHddt4HbRCt/neQ3PVMHzwpTyQ+8rqH1/1n5nM21DizEWY6Qaddr7zS2CF1bHB6zwZ1yiPq/L7ZDZOcRCLVTvDh1Q6kWfEIDQa8a+b3a/AGe9WNO3UrApKSDEGlVDJUr8jiydVkZSn8O+UoDBFSt9kX2Q1cBBD6QkfWSQdeUqeZV0Rn5Fwy21MuS6po2/rrL7
 dJY+npi6
 eVjQ9gLmnTODwAG4ybD7ViDzkl4hifQAvurHCywVs+PaDKvlIMKLWAm0J7Mu5l5v4+5K0b3Ss5q3zeIaedZ+mXHzOFeaUC2Ha+pp8hvgPZDs48o59zMoevaWXvvSadeUtypOTpSNhGohPDsbmyzRytru/zX0+KKAQLAUE2VHD29Ur+Vs3f5jMipGAJrkbUoouFo3ak84inzuI3hFMnIV2JO+tBR0DRkQ0PCwYEPzf90tIfoJxxgGB6uMWVB5+Wqp5fVlx9KBk7W11Fqa5zDJnimK5f9XqBlnxJcdV5+GotbFbBWr99onwp7cGuxSWPLmhJirjjK/STwK0Y2+YgLBBY4i+PDUsnQhAbTVJ1Spa2/mUDCjCgwOyOanQnAvfKGRJemOr7AZZ2dw+fm92UPkcBzo+hzKL3dsM2mIQKDxcgFgtxhjLVoAsRbqsEDCYK1KyUJfx17YfVMnMKNBuPti76wVKKUx2l+9tYvsCd68YkeEhSBXyshRG0OzrHplokT0FZjo16STwEezNvnYVuOBs98QuGplD8RdaE47ZLIy6VSX9hfdNMFDq6lbJloxCByxZSjBt5cxCEFfdB2fnm3i3ytSJeczTjivOr4eYlNkXVM4gcaKH0Pug7NZtCrKh25FHj/p3FsdidsHst68=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kairui,

On Mon, Nov 2, 2026 at 5:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote:
>
> >
> On Mon, Nov 2, 2026 at 5:42=E2=80=AFPM Alexandre Ghiti <alexghiti@meta.co=
m> wrote:
> >
> > Hi Kairui,
> >
> > Back from holidays, sorry for the late answer.
>
> Hello, hope you had a great holiday :D
>
> > On Mon, Oct 26, 2026 at 2:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > >
> > > On Fri, Oct 23, 2026 at 12:17=E2=80=AFAM Alexandre Ghiti <alexghiti@m=
eta.com> wrote:
> > > >
> > > > Hi Kairui,
> > > >
> > > > On Thu, Oct 22, 2026 at 5:27=E2=80=AFPM Kairui Song <ryncsn@gmail.c=
om> wrote:
> > > > > Perhaps we should instead always scan the full clusters and revert
> > > > > that one commit? That commit was only following the idea of keepi=
ng
> > > > > the allocation more compacted for that series, it looked good at =
that
> > > > > time. Since fragmentation issues can be solved in other ways,
> > > > > contiguity seems to matter more for large physical swap devices.
> > > > >
> > > > Oh, okay. I thought reverting it wasn't an option given the good
> > > > numbers the patch provides.
> > >
> > > That patch is 1/3 of a series, that series yields really nice
> > > results, but that one patch plays only a small part in them. Or
> > > perhaps we can limit that to SYNC devices?
> >
> > I'm a bit scared it would not help zswap with writeback on, unless you
> > mean actual SWP_SYNCHRONOUS_IO devices?
>
> I mean maybe we can just scan nonfull first for SWP_SYNCHRONOUS_IO
> devices? These devices are less sensitive to discretely distributed
> I/O. For other devices we then prefer to keep the IO pattern
> continuous by using free clusters first.

Ok, I'm working on this and will send a v2 when the benchmarks are over.

Thanks for your feedback Kairui,

Alex


>
> That may just fix the issue you are facing?
>
> Or maybe some threshold or quick scan in partial_free_cluster before
> putting the cluster back to nonfull.?

