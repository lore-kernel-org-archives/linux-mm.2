Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C89606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZSsGOIum
Received: by kanga.kvack.org (Postfix)
	id 5B75C6B00EF; Wed,  4 Nov 2026 05:07:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569FC6B05B4; Wed,  4 Nov 2026 05:07:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457A46B05B5; Wed,  4 Nov 2026 05:07:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 223416B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:07:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FA004069E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:07:27 +0000 (UTC)
X-FDA: 85397009334.24.91C5DB4
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf04.hostedemail.com (Postfix) with ESMTP id E233440004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:07:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZSsGOIum;
	spf=pass (imf04.hostedemail.com: domain of wangqing7171@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793786845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6mGpkBy9RlN0FEVR7x4Php3XTrxwEWY6tQtidxcE8M=;
	b=hkhCgSy4LHGwO/tvYER/2RfjVZZut2zz5QLDLYqCcGlfB74V9ZUZBW2Ub/AViPYHgeDo6j
	PvHIBO9t7JCyHTgpENeHBCdfXElbjfhAR8Wnx7GFttnrrsHYFwqrb5nykAwsqsRhQAVu2F
	CTs5exoGX2RB/zfSAkxeIn9wRCAj/fA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793786845;
	b=kGz4Nk36nAwWCi2txrikEh8JY/R9iScdBMqcnidbynjvSpC8LXFkgrcdMKMG/koMfPncZ8
	HWpDUUIqK6DdOrfY3+utYmCBo6w13d+lu8m+JhElyq7qnuTXG1ktWxXR0uShj3up5U4bpY
	RQ7/ewk0+/XEIbhGuhClpM7L8uv2SVc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZSsGOIum;
	spf=pass (imf04.hostedemail.com: domain of wangqing7171@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f9.google.com with SMTP id d9443c01a7336-2e97ddaf3c4so2141535ad.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 02:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793786845; x=1794391645; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f6mGpkBy9RlN0FEVR7x4Php3XTrxwEWY6tQtidxcE8M=;
        b=ZSsGOIumcgyJlAMs8D7oLAUwg2mBip67AN3dDabtqU39fsY7tdNrANEclaTq3+XwGJ
         qMWuQa1SsdBEZdrXsl+BkS6lLoYkMsMQGCcIG497QQL/tK08uXHu/sso/kuQYJ8Vfh0P
         flmuTPsgGXOAMDjqombPQuc6XlX+H04yDmI07TbiqM+SXMPTJtvGKEox7ny72QzrE/BU
         u/sExB6s3EGo/unyzCpW1BM+r++dDSq0e+YgjZmYTjlu4tX76klg7sTtiVZDd2smKVjy
         VTv7PQMSqD0MMqMF64g4GXXKLvs2iYyZo/6VGh+kFGSN4MJ9OJE+dwKy/ZRoWc4hzbqs
         jQIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793786845; x=1794391645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f6mGpkBy9RlN0FEVR7x4Php3XTrxwEWY6tQtidxcE8M=;
        b=AtnthLwgpS0ElQjpiFK+xz5iTpJowXBtORlDJnhMpHunPqw0xMZSqaE6bhVbqM9V4i
         HKNowWqUpsEAqa8QkqbBI9CSrsG4I9zF1vdBfuzWVGy3E9TMzwLxQi4VPA2vvem0EZeA
         UKVpKsGpLtS4MBLnswducC0cstPERLkQmnhCps9K3ZEJpzNVkLT6zo+hNBJAw2w/vFzR
         y/KeDGcuvOJMmdPQjeYedBR8vTfvLeP8wcgfIbpyIdQn997FZX0A766tUY2ALUdizICF
         8wNhE2rlqOBL8QqdFrNtwx9Bvvj98kymDMDqWBUvO8QC3zbfek5pjYQwS/M93hKhVkou
         z2+Q==
X-Gm-Message-State: APuU4Z/VAYi/YhoXxndnx6gciIvlPPO3XfDea4mji3vEaNuKuH4/8Byg
	5sqhKX+hcZPZNrWg/Ri1+hDkRmQxvgSH1p83AADxxz3EM9PFrvC1UPl8
X-Gm-Gg: AYBFou2U5jVOSyVFGgMnFa15s2dh9KW0Jrpad10tgk0nmXnfDC4JU0Z39dE0ycpSyX5
	05aXATh+NTp4pnAJaUqyP4qEtZKTiY/ZCI4d48mU7XMwTjmDdfzbpM6Fa++1jmcni+Zvyg4/Hz/
	6CLyp5AFjg8HyYiLSxrRPWJ6hnqlb2KYd+kvgZfOPnTKP+kO5BElMOgVJL3J9+tPsmInZRxv5rZ
	nKwZxm0w/ai4iCf6zOwX7zrgU+QM5mQIf7K2ZPKtujnY/exes44s8RjX6dKKPPRe9ML3TDEYnM/
	IW+Yks8/K7G8/8d6XyjykbvlVLrNeNPoEEMbvqCvhI/O6YTCJwH5uOx0lL7/M1nAe+1kFovS6Tw
	G+Z8c2jQ3JlVkhI7PfdDdGBRAmiCM7SrWjpSRd8dQnYLapktff4A8k3an1hh7IcSx1pvLbkaWBq
	6xf/z5pAVdCGKJw77YCkE5WG/Amoeq0mYwo4FbMWyyqQGTf016UO5M3YYOvlWGzylym4ItUTbHM
	KyU5+GGdEZAcujOK3Kc48ACxYS0o1NkfhAae6x/4PhARg2pyYN4dThwOxWSymy22jzHqhXmlbge
	7/Mlop1Hulg6c+gXhSHj2uKW8zKUUJH3AL17b2ba7AzpFXEj9Mb2+ZSu
X-Received: by 2002:a17:902:ec85:b0:2e8:965c:aedf with SMTP id d9443c01a7336-2eb364c5da0mr157401935ad.42.1793786844641;
        Wed, 04 Nov 2026 02:07:24 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.214])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed08fe55c8sm5603145ad.14.2026.11.04.02.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 02:07:24 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: xuhx@hust.edu.cn,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: mm/slub: has_pcs_used() reads remote per-CPU sheaf state from flush_all_cpus_locked() without synchronization (data race; KCSAN  blind spot: slub.o is uninstrumented)
Date: Wed,  4 Nov 2026 18:07:17 +0800
Message-Id: <20261104100717.2666250-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261104094132.2665206-1-wangqing7171@gmail.com>
References: <20261104094132.2665206-1-wangqing7171@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: mng4eee3qayo3t5kmkygbrdiznwgbmc8
X-Rspamd-Queue-Id: E233440004
X-Rspam-User: 
X-HE-Tag: 1793786845-741637
X-HE-Meta: U2FsdGVkX18ALCvBvw1rHJEI2uMVM9b9ck/BwOl7yJc2JUF6CX7mK9VcUsKGouQcurBH537MJ/24fkESs1AnckqoCF5E0q33xza6ga5mP+tU0sTvTjWs493dsx0YZta0YGY62k5jX11nFuaNdl1w19jfFIzBVN1htBfPS55ITYpd17e5rDSP0kA1Z1ks+qT+vxQ0RpTqHFA9aRRWWYNd/Gl8L+B7ybIuabc0TfXvdzcD22OZ38x3hi1tHo5RjXMUs8L3semeb2PMXtTP7L8LBWNbBrtweN/idRfBg56hbzvDUNVGPoqaBGlWjfSMByiiHPWUouwCLm1Q5WySQone/AOtfA0pyrJRsMnlvqEl6PWwjSvVopm4OvFNvQZGYyhVPGxlst7QGCEd+9qh1D0FRSygLrDT0NAWlfaLZyfGUabNz5QoSpmvX6Iww8tb2jgulj+cZLfcqPv6+rJ+7mXFCx+yacybwOCWs4IMjSTKnDHF+A2nYaORYzQ7MPOpoioa5Sg4vj2YYFqJZKFbbE6qVSC1Co3TfUqRf1Xgn7Wz7iYPs7tah6b1aDvknC80CSDN5KlSW5j4vIaI07zXsSMdz/FqaOA9NccQ9RWUYdQtbkAlB32Ft4/ea+Nc6fFCuTTHm1+Ts0IGkVscCGzPWu3I+L1lWp2uWupATW+h8ljwGW1SrEF2SQxe3u09j9QlgAEe462f1eW9GNz3i86NGJGU83shRd+13svDZyMyphlEZ0wS09DQykvIvlL6SMfkWqfjXsCgy66WrRzOcr+FNalf6q8z88lcCWU531IDOZVq6t9JGEGm22BUAW+qHO6Ifu7/5sBPvfemULjL7pwze7oh75mRq0Hef8KfMPZIsLczFXX9uo9ZhHkl7IkBwiochkEBAC6EPPcqGtz+CMKaA0+8uTjo5gzpiXUejVRQRX8Ku09xKGA1+lMBgrvI+UtNvLo4EY3wM/tPrhHA6BU/E80
 UOXCZ1cE
 eX4El5SZl1RAz6+/ULg3C5r/T2EVaBExv4rOTQXHOiVop0wNI2Ax5snOuRGbukn+QWd/k/DvjNzcmFSvi5GoVsBcJjWD+neYLHc4/sS0YmQsNnnEs5JHaoX/bxx5dyjSkYvyS3KCqev3GKw77kypdBb9PcuBGT1UeLs0UngoXVqaBa1u9gfkjez8G3nKUXNKUoE/LFzj3A9XFUM6h353WCC5jTfOqDrwj7RCcSsiPbEYpBGUQNJKLfJnk0JmHjZcypWb+lhc3lOyV9W8KHQvh6u2FVFr3YZiVTfSMWzEhRWv3CRpDENtYKs8QMZD9yYFdMJVXbebFuIv1naUIAITdVt3B9n0JnVuOdsZJHG854r7pbb2cHc7KtkbJxPz+EBAld6DLy59oY+jYp25UJ8T/AmE5Jo+eFz9ncBx9Irl4g6NvLjKZPU+nw6v/k37ENEZhsW78uYzyNYk65Ck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 at 17:41, Qing Wang <wangqing7171@gmail.com> wrote:
> You're right, there is a data race in has_pcs_used() reading the pcs
> fields.  The possible consequences:
> 
> 1. has_pcs_used() observes an empty pcs and sets sfw->skip, so the
>    flush is skipped and the memory is not freed in time.

Sorry, I didn't state point 1 correctly.  It should be:

has_pcs_used() reads main->size as 0 before the concurrent free
increments it, so sfw->skip is wrongly set and the memory is not
reclaimed in time.

--
Best regards,
Qing

