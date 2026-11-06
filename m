Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91560606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MERLs9Cg
Received: by kanga.kvack.org (Postfix)
	id 8C1B86B05B0; Thu,  5 Nov 2026 19:23:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870C16B05B1; Thu,  5 Nov 2026 19:23:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788766B05B2; Thu,  5 Nov 2026 19:23:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AF726B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:23:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0943B1C4588
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:23:54 +0000 (UTC)
X-FDA: 85402796388.07.750B0BF
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 29CF81A0007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:23:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MERLs9Cg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skunkolee@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793924632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bnssphz9tPNkziEw1TrPwX8Qw76+EQZeM5ElxoXCNo=;
	b=3QZuq13BzsX6HFs2ktEv3JLCMML4MZ9oD8zvSGGYR7vy6COTkRr5UWJqNnUc1O5gXouJ5U
	gYnLnGd59FUcuSK/+LqsC209dqLBiUi5lVPBOPCropfw42m+DtkXw9fBTMz/FaU3klQtnC
	YWRUqcfBQ0MkAvNQQugFOFR6n4Dn9n0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MERLs9Cg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skunkolee@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793924632;
	b=tEKeTaY0iXGenMw3nqiul4Irnfio+bMKBnLUuDKx/3rCgX1BS/oUQaciRtK0+TjcjUJmmC
	4QeDVJkFkFrW9MBRBgXVaV5AwykbgL7qwF6FN9y79MTrzxazMk8DXycfsSpcbiF6d45yOH
	ikHqjTI0/QsI2f2DzlYCIbwbiWMh3Ak=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e8f2c3ad6bso411965ad.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793924631; x=1794529431; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9bnssphz9tPNkziEw1TrPwX8Qw76+EQZeM5ElxoXCNo=;
        b=MERLs9CgPX6PhqXixCuPRVUu5YBMoa1qdD+fGXL2teMJb4AcZfsTzMThCx+WtSTdsL
         9IWTKkn7+Qz0Jwrb7y7IZjl6EOyAWKaAbCvYu6Pc3UtJLBY60eygoJDkQvYUW9VHBRq7
         QklIBuEXpkJCdEqCwvO2xIyVF7Ib4VQcYB5C5P5/lQ67jrL4LKNy1aeunhQAvRL4tJfK
         XiRctBqzXzVjjBIED5fGbNTsqAgBdZcHtth6Q8X4MYVjPJhE5hGxzXdtOGCA8pHS0/9E
         IAR5dqq+THTdKZD0T8oWEFrTVr/o/cc8JwJSzMXgmmjL0My2oiTS3B3znrW2Y/n8RBZ2
         iceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793924631; x=1794529431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9bnssphz9tPNkziEw1TrPwX8Qw76+EQZeM5ElxoXCNo=;
        b=cZLcn4zKb5Gm1lfiO0B/GA+feZU2GG7hzQ+/mHxsSxCAEjyQ52BVUe+q8jvUZMuqN9
         x5q+MMCZtliTUfA2jPq+mqhRHZSkOwV7MVoGe7oZMfUOlkgeJ5Stpfu6GliNCmt+e+PI
         61TPoRWXK5vC6QZxAvyKdJmJVht/8d8ugEhME6T1l8T5uHAPoBnZ68reSnmBHUKSVhpc
         ovqhgjTWO+9TfUQt9sGSWEIU9RgPzjX46B0Vij29P5Sj24UYmeWtfkahaClT1j8pRDRa
         ih1jNEjpp4t3DISI1RObbqUZMJF+hkAUwpnvJBUaujS/OOORIQ4W9pF+q+EV4GrDdv4g
         C5wQ==
X-Forwarded-Encrypted: i=1; AKwUvBz6ytBdLDIQ6kmaqNYiNPK4T9mjR/kJYaCv7/cg7o2E3xazMgmMQE8ub6wV4A3Yz6dU27fe9Op1jA==@kvack.org
X-Gm-Message-State: APuU4Z+KtWM6Lvas18nPHAtFLBb61vvr8fK7baTax+UwfP0pkXDpQfYM
	W7jqYtN6o82wIz28mtN/KfLy5fm/b77OHSLFPtHQspv/6izHMkkjPVNm
X-Gm-Gg: AYBFou2KeD2xXuySYKCHXulnTlwmAXUtsG8WOYs4790eDPUfDhS/ur8WUCdwI+IH9eK
	zZgSUTOLEFN1Lc7xVY6hT1Aelm9VWizclAde+cPSDyaHGrbuFvzPIKiQOscL/nLmD/QKli4LXSY
	zRTesiREqgHdI4GZctYu4bVQ9r/MoHg8AmjgpIKB2bVhGSY3NxaMu0x30kbn8QS3gawEg3KCjlO
	oc95fDj6zi6+B050CS0HK+0hH2xSt4RtNCaOZbogCyuaowdd+ZKhVNjqi6+RFi5VjgHtH0CGRYv
	mfyWJuhKo3ZbfekNfRgpzdvCnVzDOcMli1SmODbVO8i7wALtSQHNva/XYHEY3E2lLYxZGTjk49p
	ncHl3XPiHx+rnjRwmLIZ9shtrBI+3Ksj4Rn7b3H5BZzza8/HgfDspGdDg2AUEychrCpWbXjLxi6
	T0SjPoFpFUgJ1Tt5LkEQ2nJ4gHfRP39Y9wwbWZ0/mdqbPSFf8cYtaOcjAhizuGNSEkFOVQI0QTQ
	120hUXdPJAO83qUGF6cGGVgqLbj6j0zOdSIO8cwMKvroqWLHLnQEz5l8EgfH2GEFV2Ug69itViO
	EXwYA8n7+ofpZNKCVHtGpjaCNXQhD7cOBGuLOtVI0rWUcKLdqOxqkgmR4t+1utNzmwKZYJjmK9+
	KO5drCj8=
X-Received: by 2002:a17:902:f78d:b0:2ed:2475:e40e with SMTP id d9443c01a7336-2ed41e914c1mr13079085ad.61.1793924630892;
        Thu, 05 Nov 2026 16:23:50 -0800 (PST)
Received: from bloom.localdomain ([2604:3d09:178e:e100::5567])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47da165dsm307555ad.73.2026.11.05.16.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 16:23:49 -0800 (PST)
From: Ivy Lopez <skunkolee@gmail.com>
To: david@kernel.org,
	rppt@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	fvdl@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/cma: fix range selection in cma_declare_contiguous_multi()
Date: Thu,  5 Nov 2026 18:23:47 -0600
Message-ID: <20261106002347.255584-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <6099bcde-15be-4197-905e-13dfa4c83bfe@kernel.org>
References: <6099bcde-15be-4197-905e-13dfa4c83bfe@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 29CF81A0007
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 6pgxdbo3j81h7sa639a8h63xaoa44148
X-HE-Tag: 1793924632-768975
X-HE-Meta: U2FsdGVkX193XHkg1+ip4LmAyWSQSHRhafAwt3hPGDzr95I1C6gKyVkBptXwR3i20nP4tzf7tCyNfVSyTVIbIw4Oynh5mbmj/geiXsVi3rGeRQ4YPk/YdmYQIu50Df9GJn2PpKuy5TaNtl7puCoVyPbF2WlyCPHGs8pCPJ3M79VIMSiDCT80gxEtFmg3QABoBEJIo1arQw7gvg/xIYypcsTNN+Zfm5v+94ThL6obWlkUhGrfKZwwBOOvKLKAjlWUCAEpkddyajLoaX3j6RcLwFMvcwLG8kXuFPsH78ZIuIV1X+d0BJUEsD0XpYTcoy/JQ1oDK9Zyy77bUalrQMn5TwjlFs/WvL9zeVj1BWbaddhsdIbbDqxNxw7SU1m5YJFMAHj/VGLJvPZskQprCn2ceT5qtXfSaGLIwns7QVt0dmdEzYAezD5kuxiHCRYI1b+Pd23gXiXG5kYDVxYMtRUFrB5tom0owX0ckppNmUY2xgAoTHdLrkMKZBy+gVGPEdpX1oa0zfavNxfP8Xlns0DZB4lWBe2worxGCuOBJ/FHtMRQTpmhy9eTSxEPKZM75QBvy0Eujorxtxg5k4LaTNoaQFUJiT9vFKHE1oDasLTcX1HLkMLR3g/oDUJQLiiEhjrx6Vmi6o2ofCHVxCmMySXidDSXMZQoADNoew3V15OX3rdDIx670EndRNGXCsVxMahni+25mm8Nn+ClTQKLERtwqhQQH5D98KfTFBj/DIHXW1sUqAV5EM1nHzIVtdvpr5QIr0/rBHO6DGumHqmVANr098+M7KfZpvF23Lyg/1l+bzwzTJA0+q/7hl8M2DkbhAbyXjtDX/n1HaXTSOnvV1V9EgeL+i1crDM7Zgq8JVmhEu2fC0TbPNRqxYQwbJ76uOz0E8fPzGFaeYujC3L9MI+QqagOnHNF3+L1eE9EOr0UrgHH8Er/IcRGE0JDCRicMYII0UWRQKTuo+El0YSQzM6
 dViCKsCY
 gOQAOlavl8GYaGYP7KFkgkn+MBS3rjgUuKycNGNfd/1iPozp3NNjro33AlGohu2cW83PQXgBespgehdcTPLJ+nngTySTopVTJ1Z0FuKrQqG9Uvmg9mVKEablW4YdwGQSIiLa8To0CEK5SYoH4+mJyQL+ixVd12MZL/5TsjbdaM9wTW44Qva/vM1kG3G5r+Sy0Xyu7JAGMi0nTWH0rK71oHLqY17O0VsksKU+TDYHvg10PfXCshdwi7NO4JtSKRSoQJTdJt7hyMgBQhpg4DWWpZJcUtevoBsOcN8BI5yqhOgmTIwb1qVeRzFD3FmsZrUPSgChw6RrFX5paNcrkaCihup3RV0vtjZ7rfb4+YPwFJ+kp9Oys8XGTfn/RLim+pBSbR413FLk5SSXI9wrvhzjc9bGvt5UoztLpijPO20zilHSfXIxhDmskZGfk36DiVGn8dg1bnlRdt0xnAaSHelAGp73l11YiwCKTQC8i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 20:38, David Hildenbrand (Arm) wrote:
> Do these two fixes still apply?

Yes. I checked against akpm/mm-new at dba8aba0a9a0: both patches still
apply (two hunks with a small line offset from the accept_memory()
additions) and both problems are still present, since
list_insert_sorted() and the sizesum accounting are unchanged there.
If Mike's rewrite is going to replace this code soon, dropping them is
fine with me. Otherwise I can respin them.

ivy

